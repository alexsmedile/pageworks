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
├── plugin.json                    # Root Agent Plugins 1.0.0 manifest
├── .claude-plugin/plugin.json     # Claude Code plugin manifest
├── .codex-plugin/plugin.json      # Codex plugin manifest
├── README.md                      # Public-facing readme
├── CHANGELOG.md
├── CLAUDE.md                      # This file
├── cli/
│   ├── pageworks                  # Symlink to skills/pageworks/scripts/pageworks
│   └── install.sh                 # curl-installable installer
├── skills/
│   ├── pageworks/                 # Self-contained standalone skill package
│   │   ├── SKILL.md               # Lean orchestrator
│   │   ├── scripts/
│   │   │   └── pageworks          # Bundled deterministic Bash engine (zero external install)
│   │   ├── references/            # Loaded on demand by SKILL.md routing table
│   │   │   ├── contract.md        # docs.yaml schema + folder shape + frontmatter
│   │   │   ├── authoring.md       # Page lifecycle (new, review, status, audit)
│   │   │   ├── page-types.md      # Extensible page classes & inspiration baseline
│   │   │   ├── prose-patterns.md  # Voice, tone, callouts, code blocks, links
│   │   │   ├── renderers.md       # MkDocs + Docusaurus + Docker adapters
│   │   │   ├── maintenance.md     # Dual-Layer drift detection & spec sync
│   │   │   ├── designer-mode.md   # Design tokens & color palettes
│   │   │   └── quality-gates.md   # 5-layer CI verification
│   │   └── templates/
│   │       ├── docs.yaml.tmpl
│   │       ├── index.md.tmpl
│   │       ├── page.md.tmpl
│   │       └── pages/             # Extensible page templates
│   │           ├── tutorial.md.tmpl
│   │           ├── how-to.md.tmpl
│   │           ├── reference.md.tmpl
│   │           ├── explanation.md.tmpl
│   │           ├── adr.md.tmpl
│   │           ├── service-catalog.md.tmpl
│   │           ├── runbook.md.tmpl
│   │           ├── incident-postmortem.md.tmpl
│   │           ├── migration.md.tmpl
│   │           ├── troubleshooting.md.tmpl
│   │           ├── cookbook.md.tmpl
│   │           └── design-spec.md.tmpl
│   └── wiki-prettifier/           # Standalone UX & aesthetic refactoring engine
└── tests/
    ├── run.sh                     # Test runner
    ├── cli/
    │   ├── init.test.sh
    │   ├── export.test.sh
    │   └── doctor.test.sh
    └── integration/
        └── dogfood.test.sh
```

## Skill Architecture

Same pattern as spectacular: `SKILL.md` is a **lean orchestrator**. It declares the routing table; the actual instructions live in `references/`, loaded on demand by trigger. Never load all references at once — load only what the current verb needs.

Pageworks is packaged as a **self-contained standalone skill**: the deterministic script engine lives directly in `skills/pageworks/scripts/pageworks`. AI agents invoke it locally with zero external CLI prerequisites. The CLI in `cli/pageworks` is a convenience symlink for human terminals and CI.

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

**Pageworks defers to itself.** Even when spectacular is present, pageworks reads its own `references/` for schema — never spectacular's.

**Frontmatter is the signal layer** — the skill reads page frontmatter, not full content, during briefings and audits.

**`docs/` is the only managed folder.** Pageworks never writes outside `docs/`, `mkdocs.yml`, `docusaurus.config.js`, `sidebars.js`, `mint.json`, or `.github/workflows/docs*.yml`.

**`docs.yaml` is the authoritative manifest.** Nav order, section list, optional renderer hints. Folder layout reflects the manifest, not the other way around.

**Page classes are an extensible inspiration baseline.** Core baseline + extended formats (migration, troubleshooting, cookbook, design-spec) + custom domain types.

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
- **Mixing page types in one file** — a single `.md` should serve one primary purpose. Split when boundaries blur.
- **Cross-skill schema reads** — pageworks never reads spectacular's internal docs schema. Schema lives in pageworks's `references/contract.md`.
- **Auto-rendering** — pageworks writes config; the user's renderer toolchain builds the site. No bundled `mkdocs build` invocation.

## Active Development

Pageworks is at **v0.4.0** (featuring Mintlify Adapter, Touch Freshness, Extensible Taxonomy, Dual-Layer Drift Detection, and Docs Overhaul). Tracked work lives in `.spectacular/` (using Spectacular v2 workspace model with Core Anchors, Capability Contracts, and Proposals).

### Active Proposals & Campaign Blocks

| Ref | Proposal | Priority | Target | Summary |
|---|---|---|---|---|
| `P1` | `P1-pageworks-agents.md` | high | future | Tier-4 subagents (docs-writer + docs-reviewer, optional docs-architect) for multi-page authoring work |
| `P2` | `P2-public-docs-dogfood.md` | medium | v0.4.x | Dogfood pageworks to author its own docs/; deploy to GitHub Pages (dogfooding passing in test suite) |
| `P3` | `P3-pageworks-maintenance-v2.md` | low | v0.4.0 ✓ | Drift detection improvements: multi-source `synced_from:`, screenshot freshness (`touch` freshness command delivered) |
| `P4` | `P4-pageworks-renderers-more.md` | low | v0.5.x | Additional renderer adapters (Mintlify delivered in v0.4.0; Fumadocs planned) |

### Sequencing logic

```
v0.1.0 ✓ first release (CLI + skill + refs + templates + tests)
v0.2.0 ✓ platform preset + 6 categories + 6 core page classes + 180-day doctor audit
v0.3.0 ✓ designer mode + 5-layer quality gates + wiki-prettifier
v0.4.0 ✓ mintlify adapter + touch freshness + extensible taxonomy + dual-layer drift + docs overhaul
future → P1: pageworks-agents (tier-4 subagents when authoring friction surfaces)
future → P4: pageworks-renderers-more (community adapters: Fumadocs)
```

## Vault Tools / General-Purpose Tools

See `~/.claude/CLAUDE.md` for general preferences (script locations, web search routing, etc.).
