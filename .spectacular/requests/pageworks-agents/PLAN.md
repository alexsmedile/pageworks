---
status: planned
priority: high
owner: alex
updated: 2026-05-23
target_version: pageworks v0.2.0
summary: "Add Tier-4 subagents (docs-writer + docs-reviewer, optional docs-architect) that pageworks spawns for multi-page authoring work"
related:
  - ../../../skills/pageworks/SKILL.md
  - ../../../skills/pageworks/references/authoring.md
  - ../../../skills/pageworks/references/page-types.md
  - ../../../skills/pageworks/references/prose-patterns.md
---

# Plan — pageworks agents

## Goal

Add specialized subagents that pageworks spawns when authoring work exceeds what the main Claude Code agent should hold in context: writing across multiple pages, reviewing for cross-page consistency, or planning the docs tree from scratch. Each agent loads only the pageworks references it needs and reports back to the orchestrator.

## Why

v0.1.0 deliberately deferred subagents — the rule was "ship the skill, observe how it's used, then extract roles from real friction." The friction we expect (based on the docs-writer/reviewer/architect taxonomy in spectacular's earlier discussion):

- **Writing**: a single page is fine in the main context; writing 5+ pages in a session bloats the parent agent with template scaffolding, prose patterns, and frontmatter rules that shouldn't persist after each page completes.
- **Reviewing**: the same agent that wrote a draft has blind spots; review wants a fresh-reader stance. Cognitively different job, naturally a different agent.
- **Architecture**: deciding where new content fits in the Diátaxis quadrant tree, splitting pages, restructuring sections — closer to PRD work than to prose writing. Wants its own role.

This request stays gated on real signal: don't ship until v0.1.x usage produces clear cases for at least docs-writer + docs-reviewer.

## Activation triggers

Don't start until **2 of 3** fire:

1. Three or more multi-page authoring sessions in real pageworks usage where context bloat became a felt problem
2. Two or more review/audit cycles where rewriting the same page from the same context produced visibly worse results than a fresh-context pass
3. One or more contributor-suggested workflow where they ask "can I delegate the review part?"

## Scope

### In scope (once activated)

- **`docs-writer` agent definition** at `skills/pageworks/agents/docs-writer.md`
  - Frontmatter: name, description, model (sonnet by default), tools (Read, Write, Edit, Bash limited)
  - Loads: `authoring.md`, `page-types.md`, `prose-patterns.md`, the matching page template
  - System prompt: "you author one page at a time; the orchestrator passed you the type, section, title, description, and any source material; output the draft and a one-line summary of choices made; do not modify docs.yaml"
- **`docs-reviewer` agent definition** at `skills/pageworks/agents/docs-reviewer.md`
  - Frontmatter: same shape, read-mostly tools (Read, Grep, Glob, Bash limited)
  - Loads: `authoring.md`, `page-types.md`, `prose-patterns.md`, optional `maintenance.md`
  - System prompt: "you critique a page against its declared type and the prose-patterns checklist; you do not rewrite; report findings as a punch list with proposed one-line fixes the user can accept or reject"
- **`docs-architect` agent definition** at `skills/pageworks/agents/docs-architect.md` (optional, only if triggered)
  - Frontmatter: same shape, read-mostly tools + Write for `docs.yaml`
  - Loads: `contract.md`, `page-types.md`, optional `maintenance.md`
  - System prompt: "you plan structure: where a new concept fits, when to split a page, when to merge, how sections should evolve; you may propose docs.yaml edits and confirm before writing"
- **Pageworks SKILL.md updates** — orchestrator routes:
  - "writing N pages" → spawn `docs-writer` per page
  - "review docs/" → spawn `docs-reviewer`
  - "plan docs structure" → spawn `docs-architect`
- **Update `authoring.md`** with subagent integration notes (when to delegate, what to pass, how to handle returns)
- **Plugin manifest updates** — `.claude-plugin/plugin.json` and `.codex-plugin/plugin.json` declare the agents
- **Tests**: smoke tests for each agent definition (frontmatter validity, declared tools, declared model)

### Out of scope

- **Inter-agent communication.** Each agent reports to the orchestrator; agents don't talk to each other. Multi-pass workflows are orchestrated by the parent agent (write → return → review → return).
- **Custom inference logic.** Agents are pure prompt + tool config — no Python/JS layer.
- **Auto-spawning.** The skill suggests when to delegate; the user confirms. Same pattern as spectacular's handoff to pageworks.
- **Localized prompts.** v0.2.0 ships in English. i18n is a separate request if it ever becomes real.
- **`docs-illustrator`, `docs-translator`, `docs-localizer`, `docs-search-tuner`, `docs-changelog`** — Tier-3 roles identified earlier. All deferred to "if needed" status; not in v0.2.0.

## Decisions (provisional — revisit at activation)

- **Ship docs-writer + docs-reviewer together.** The write↔review loop is the core value; shipping just writer creates an asymmetry where output quality degrades.
- **Defer docs-architect.** Information architecture wants real-world usage to inform the prompt. Ship in v0.2.x patch if needed.
- **No subagent loads `contract.md` by default.** That's the orchestrator's job (deciding the page belongs in docs/ at all). Subagents work on pages that already exist or are being created with full type/section context passed in.
- **All agents default to Claude Sonnet.** Cheaper than Opus, fast enough for prose. User can override per-invocation.
- **Pageworks remains usable WITHOUT subagents.** v0.2.0 doesn't make subagents required. The skill prompts can still run in the main agent — subagents are an optimization for heavy work.

## Milestones

1. **M1 — Verify activation signals.** Confirm 2-of-3 triggers fired in real usage; document the cases that justify activation.
2. **M2 — `docs-writer` agent.** Definition, system prompt, refs-loaded set, tool allowlist, test harness scenario.
3. **M3 — `docs-reviewer` agent.** Same shape, different prompt + tool config (read-mostly).
4. **M4 — Orchestrator routing.** SKILL.md updates, `authoring.md` integration notes.
5. **M5 — `docs-architect` agent.** Only if activation case requires it; otherwise skip and ship without.
6. **M6 — Tests + release.** Smoke tests, plugin manifest updates, version bump to v0.2.0, CHANGELOG, GitHub release.

## Risks

- **Premature optimization.** Activating before real friction produces speculative agent designs that don't match actual work patterns. Mitigation: strict gate, refuse to start until triggers fire.
- **Context fragmentation.** Three agents loading different ref subsets can produce inconsistent voice across pages. Mitigation: all three load `prose-patterns.md`; that's the shared style layer.
- **Tool over-permissioning.** Giving docs-writer write access to `docs.yaml` would let it self-modify the manifest in ways the orchestrator can't audit. Mitigation: docs-writer cannot touch `docs.yaml`; only docs-architect can.
- **Agent definitions out of sync with skill refs.** When `prose-patterns.md` evolves, agent prompts referencing it may rot. Mitigation: agent prompts cite refs by path, not by inline copy; the ref evolves, the prompt instruction stays the same.

## Validation (provisional)

- A user can invoke `/pageworks` and ask for a 5-page authoring run; pageworks proposes spawning `docs-writer` per page; user confirms; each page lands clean.
- A user asks for a review pass on existing docs/; pageworks proposes spawning `docs-reviewer`; review returns findings without rewriting.
- Both agents declared in plugin manifests; `claude` discovers them; `claude` can invoke them by name.
- Smoke tests pass.

## Success criteria

- `docs-writer` + `docs-reviewer` agents shipped, discoverable, invocable
- Orchestrator routes correctly when authoring/review workload is detected
- `prose-patterns.md` referenced consistently across both agents
- No required behavior change for pageworks users who don't want subagents
- v0.2.0 tagged + released
