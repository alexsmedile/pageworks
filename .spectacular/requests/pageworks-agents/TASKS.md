---
updated: 2026-05-23
related:
  - PLAN.md
---

# Tasks — pageworks agents

> **Status: planned, gated.** Do not begin until 2-of-3 activation triggers fire (see PLAN.md § Activation triggers).

## M1 — Verify activation signals

- [ ] Document the multi-page authoring cases (3+) that surfaced the need
- [ ] Document the review-cycle cases (2+) where fresh-context review beat same-context rewriting
- [ ] If contributor-suggested workflow surfaced, link the issue/PR
- [ ] Update this PLAN.md with the actual triggers that fired (replace provisional language)

## M2 — `docs-writer` agent

- [ ] Create `skills/pageworks/agents/docs-writer.md`
- [ ] Frontmatter: name, description, model (claude-sonnet-4-6 default), tools allowlist (Read, Write, Edit, limited Bash)
- [ ] System prompt drafted — references `authoring.md`, `page-types.md`, `prose-patterns.md` by path
- [ ] Loaded-refs set documented in the agent's body
- [ ] Inputs contract: type, section, title, description, source material (optional)
- [ ] Outputs contract: draft markdown + one-line summary of choices made
- [ ] Constraint: must NOT modify `docs.yaml` (orchestrator's job)
- [ ] Smoke test: agent definition has valid frontmatter, declared model exists, declared tools valid

## M3 — `docs-reviewer` agent

- [ ] Create `skills/pageworks/agents/docs-reviewer.md`
- [ ] Frontmatter: same shape, read-mostly tools (Read, Grep, Glob, Bash limited)
- [ ] System prompt — review against `page-types.md` quadrant rules + `prose-patterns.md` checklist
- [ ] Loaded-refs set: `authoring.md`, `page-types.md`, `prose-patterns.md`, optionally `maintenance.md`
- [ ] Inputs contract: page path, optional spec source path
- [ ] Outputs contract: punch list of findings, each with proposed one-line fix
- [ ] Constraint: must NOT rewrite — review only, propose-only
- [ ] Smoke test

## M4 — Orchestrator routing

- [ ] Update `skills/pageworks/SKILL.md`:
  - Add "Subagent delegation" section after the routing table
  - Document when to spawn docs-writer (multi-page authoring runs)
  - Document when to spawn docs-reviewer (review pass on >= 3 pages)
  - Document when to spawn docs-architect (if shipped) — structural reorg requests
- [ ] Update `skills/pageworks/references/authoring.md`:
  - Add "Subagent integration" section with examples
  - Per-page write flow: orchestrator gathers context, spawns docs-writer per page, collects drafts, presents diff
  - Review flow: orchestrator spawns docs-reviewer, receives punch list, walks user through fixes
- [ ] Confirm the "no auto-spawn" rule — user confirms before each delegation

## M5 — `docs-architect` agent (conditional)

- [ ] Only proceed if M1 activation triggers include structural/architecture work
- [ ] Create `skills/pageworks/agents/docs-architect.md`
- [ ] Frontmatter: same shape, read-mostly + Write for `docs.yaml`
- [ ] System prompt — plan structure, Diátaxis placement decisions, page splits/merges
- [ ] Loaded-refs set: `contract.md`, `page-types.md`, optionally `maintenance.md`
- [ ] Inputs contract: question (e.g., "where should this new concept page go?"), current `docs.yaml`
- [ ] Outputs contract: structural recommendation + optional `docs.yaml` diff (with confirmation)
- [ ] Smoke test

## M6 — Tests + release

- [ ] `tests/agents/agent-frontmatter.test.sh` — validate each agent's frontmatter parseable + complete
- [ ] `tests/agents/agent-tools.test.sh` — declared tools exist + permissions valid
- [ ] Update `.claude-plugin/plugin.json` — declare agents map
- [ ] Update `.codex-plugin/plugin.json` — declare agents map
- [ ] Bump `cli/pageworks` `PAGEWORKS_VERSION` to `0.2.0`
- [ ] Bump both plugin manifests to `0.2.0`
- [ ] Bump `skills/pageworks/SKILL.md` frontmatter `version` to `0.2.0`
- [ ] CHANGELOG entry under `[0.2.0]` — Added: docs-writer + docs-reviewer (+ docs-architect if shipped), orchestrator subagent routing
- [ ] Update `CLAUDE.md` Active Requests table (remove from active, add to Archived line)
- [ ] Snapshot PLAN + TASKS, archive request → `.spectacular/archive/pageworks-agents/`
- [ ] Tag v0.2.0, push, `gh release create v0.2.0 --generate-notes`
- [ ] `/plugin marketplace update pageworks` (user-triggered)

## Open questions to resolve during activation

- [ ] Does the docs-architect agent get its own dedicated `architecture.md` reference, or share `contract.md` + `page-types.md`?
- [ ] Should agents inherit the orchestrator's brand voice (project-specific tone) or stay generic?
- [ ] Token budget: should each agent declare a `max_tokens` ceiling to prevent runaway prose generation?
