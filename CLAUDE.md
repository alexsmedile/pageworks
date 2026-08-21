# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

**Pageworks** is a public-facing documentation skill + CLI. It owns the `docs/` surface of any project it operates on: scaffold, schema, authoring, renderer export, drift detection.

It ships as four layers:

1. **Convention** — `docs/` folder shape + `docs.yaml` manifest + page frontmatter contract
2. **Skill** — `/pageworks` invocable in Claude Code / Codex (loads `skills/pageworks/SKILL.md`)
3. **CLI** — `pageworks` binary (`init`, `export`, `doctor`)
4. **Plugin** — installable via the Claude Code / Codex plugin marketplace

This repo *uses* itself: `docs/` here will eventually be the canonical example of pageworks's output (deferred to a `public-docs-dogfood` follow-on request).

## Repository Structure

```
pageworks/
├── .claude-plugin/plugin.json     # Claude Code plugin manifest
├── .codex-plugin/plugin.json      # Codex plugin manifest
├── README.md                      # Public-facing readme
├── CHANGELOG.md
├── CLAUDE.md                      # This file
├── cli/
│   ├── pageworks                  # Bash binary
│   └── install.sh                 # curl-installable installer
├── skills/pageworks/
│   ├── SKILL.md                   # Lean orchestrator
│   ├── references/                # Loaded on demand by SKILL.md routing table
│   │   ├── contract.md            # docs.yaml schema + folder shape + frontmatter
│   │   ├── authoring.md           # Page lifecycle (new, review, status, audit)
│   │   ├── page-types.md          # Diátaxis quadrants
│   │   ├── prose-patterns.md      # Voice, tone, callouts, code blocks, links
│   │   ├── renderers.md           # MkDocs + Docusaurus adapter mapping tables
│   │   └── maintenance.md         # Drift detection, spec→doc sync
│   └── templates/
│       ├── docs.yaml.tmpl
│       ├── index.md.tmpl
│       ├── page.md.tmpl
│       └── pages/                 # Diátaxis page templates
│           ├── tutorial.md.tmpl
│           ├── how-to.md.tmpl
│           ├── reference.md.tmpl
│           └── explanation.md.tmpl
└── tests/
    ├── run.sh                     # Test runner
    └── cli/
        ├── init.test.sh
        ├── export.test.sh
        └── doctor.test.sh
```

## Skill Architecture

Same pattern as spectacular: `SKILL.md` is a **lean orchestrator**. It declares the routing table; the actual instructions live in `references/`, loaded on demand by trigger. Never load all references at once — load only what the current verb needs.

Reference loading triggers:

| Verb | Reference loaded |
|---|---|
| `pageworks init` (CLI context) | `contract.md` |
| `pageworks new <page>` | `authoring.md` + `page-types.md` |
| `pageworks review` | `authoring.md` + `prose-patterns.md` |
| `pageworks status` | `contract.md` |
| `pageworks audit` | `maintenance.md` |
| `pageworks export <renderer>` (CLI) | `renderers.md` |
| `pageworks doctor` (CLI) | `contract.md` |

## Key Conventions

**Pageworks is standalone.** It does not require spectacular to be present. It does not read from `.spectacular/`. It owns its docs/ workflow end-to-end.

**Pageworks defers to itself.** Even when spectacular is present, pageworks reads its own `references/` for schema — never spectacular's. Spectacular's docs surface (deprecated in v1.2.0) is *not* a source of truth for pageworks.

**Frontmatter is the signal layer** — the skill reads page frontmatter, not full content, during briefings and audits.

**`docs/` is the only managed folder.** Pageworks never writes outside `docs/`, `mkdocs.yml`, `docusaurus.config.js`, `sidebars.js`, or `.github/workflows/docs.yml`.

**`docs.yaml` is the authoritative manifest.** Nav order, section list, optional renderer hints. Folder layout reflects the manifest, not the other way around.

**Page-type vocabulary is Diátaxis.** Tutorial / how-to / reference / explanation. Templates and review checklists are organized around these four quadrants. No fifth category.

## Pairing With Spectacular

When both are installed:

- Spectacular (v2.x) owns `.spectacular/` (internal workspace: Anchors, Contracts, Missions, Decisions).
- Spectacular discovers `docs/` and `docs.yaml` presence, directing public doc authoring to pageworks.
- Completing a Mission or amending a Contract prompts the user/agent to run `pageworks audit` to reconcile public docs.
- No automatic invocation across the boundary. User confirmation is required for handoffs.

When pageworks runs alone:

- All behavior is identical except the spectacular-handoff prompts don't exist.
- `pageworks init` is the entry point on a fresh project.

## Anti-Patterns

- **Bundling internal docs into `docs/`** — Anchors, contracts, missions, decisions belong in `.spectacular/`. `docs/` is the public surface only.
- **Multiple manifest files** — `docs.yaml` is the only manifest. No `_section.yaml`, no `meta.json` per folder, no fragmented config.
- **Mixing page types in one file** — a single `.md` is one Diátaxis quadrant. Split when boundaries blur.
- **Cross-skill schema reads** — pageworks never reads spectacular's internal docs schema. Schema lives in pageworks's `references/contract.md`.
- **Auto-rendering** — pageworks writes config; the user's renderer toolchain builds the site. No bundled `mkdocs build` invocation.

## Active Development

Pageworks is at v0.1.0 — first release. Tracked work lives in `.spectacular/` (using Spectacular v2 workspace model with Core Anchors, Capability Contracts, and Proposals).

### Active Proposals & Campaign Blocks

| Ref | Proposal | Priority | Target | Summary |
|---|---|---|---|---|
| `P1` | `P1-pageworks-agents.md` | high | v0.2.0 | Tier-4 subagents (docs-writer + docs-reviewer, optional docs-architect) for multi-page authoring work |
| `P2` | `P2-public-docs-dogfood.md` | medium | v0.3.0 | Dogfood pageworks to author its own docs/; deploy to GitHub Pages |
| `P3` | `P3-pageworks-maintenance-v2.md` | low | v0.4.0 | Drift detection improvements: `sync-ack` verb, multi-source `synced_from:`, screenshot freshness |
| `P4` | `P4-pageworks-renderers-more.md` | low | v0.5.x | Additional renderer adapters (Mintlify, Fumadocs) |

### Sequencing logic

```
v0.1.0 ✓ first release (CLI + skill + refs + templates + tests)
v0.2.0 → P1: pageworks-agents (when authoring friction surfaces)
v0.3.0 → P2: public-docs-dogfood (depends on agents being optional, not required)
v0.4.0 → P3: pageworks-maintenance-v2 (when drift false-positives become real)
v0.5.x → P4: pageworks-renderers-more (per-renderer patch releases as PRs arrive)
```

## Vault Tools / General-Purpose Tools

See `~/.claude/CLAUDE.md` for general preferences (script locations, web search routing, etc.).
