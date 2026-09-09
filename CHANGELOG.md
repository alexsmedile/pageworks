# Changelog

All notable changes are documented here.
Format: [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)

## [Unreleased]

---

## [0.4.0] — 2026-09-09 — Mintlify Adapter, Touch Freshness, Extensible Taxonomy & Docs Overhaul

### Added
- **Self-Contained Standalone Skill Packaging**: Embedded execution engine inside `skills/pageworks/scripts/pageworks`, allowing AI agents to run doctor, export, and initialization routines with zero external CLI or `$PATH` dependencies.
- **Extensible Page Classes Baseline & Starter Templates**:
  - Re-framed page classes as an extensible starter kit / inspiration baseline rather than a rigid gate.
  - Added 4 high-leverage canonical page templates:
    - `migration.md.tmpl`: Breaking changes, upgrade readiness checklists, configuration key mappings, and side-by-side legacy vs modern diffs (inspired by Docusaurus & Stripe).
    - `troubleshooting.md.tmpl`: 3-column Symptom $\to$ Root Cause $\to$ Resolution matrix and deep diagnostic traces (inspired by Anthropic Claude Code).
    - `cookbook.md.tmpl`: End-to-end integration recipes with multi-language tabs (Node.js/Python) and curl verification tests (inspired by OpenAI Codex).
    - `design-spec.md.tmpl`: Visual anatomy callouts, design token tables, interactive state matrices, and WCAG AA accessibility rules (inspired by Google Material Design).
  - Updated `pageworks doctor` to accept custom types (`type: ...`) with an informative note instead of emitting a warning.
- **Dual-Layer Stale Docs Checking**:
  - Layer 1 (Mechanical Engine in CI & Doctor): Added upstream git-drift detection on `synced_from:` targets via `git log -1 --format=%cs`. Validates that referenced specs exist on disk and raises a drift warning when upstream files have git commits newer than the doc's review date.
  - Layer 2 (Skill-Driven Semantic Review in Agent): Formalized `/pageworks audit` workflow covering semantic behavior drift, code snippet executability, Mermaid topology alignment, and `touch` review acknowledgment.
- **Mintlify Documentation Export Adapter**:
  - `pageworks export mintlify`: Generates complete `mint.json` with navigation groups, tabs, repo metadata, and color themes from `docs.yaml`.
  - Generates `.github/workflows/docs-mintlify.yml` with automated link and syntax verification via `npx mintlify broken-links`.
- **Unix-Standard `touch` Command for Freshness Verification**:
  - Added `pageworks touch <page>` as the canonical command to bump `last_reviewed:` timestamps to today.
  - Supports flexible path resolution (`page`, `page.md`, `section/page`, `docs/section/page.md`).
  - Retains backward-compatible aliases for `ack` and `sync-ack`.
- **Renderer Benchmark Matrix & Strategic Choice Documentation**:
  - Added empirical performance benchmarks (cold build, CI overhead, initial JS shipped, FCP, TTI, Lighthouse score, offline search) across Docusaurus v3+, MkDocs Material, and Mintlify in `references/renderers.md`.
  - Documented decision trees, architectural trade-offs, and concrete rationales for choosing each documentation platform.
  - Enhanced Docusaurus export engine with `@docusaurus/theme-mermaid` diagram rendering, topbar GitHub repository links, and resilient CI workflow (`npm ci || npm install`).
- **Repository Documentation Surface Upgrade (`docs/`)**:
  - `concepts.md`: Upgraded with the extensible page class taxonomy (`migration`, `troubleshooting`, `cookbook`, `design-spec`), Mintlify support, and Dual-Dimension Mermaid architecture grid.
  - `overview.md`: Expanded with the 4-layer system architecture, multi-renderer pipeline, and Dual-Layer drift detection sequence diagram.
  - `manifest-schema.md`: Documented full configuration schemas for `renderers.mkdocs`, `renderers.docusaurus`, and `renderers.mintlify` with copy-paste YAML examples.
  - `frontmatter-spec.md`: Detailed extensible `type:` taxonomy, `synced_from:` git drift mechanics, and `pageworks touch` freshness workflows.
  - `prose-guidelines.md`: Added "Punchline First" first-sentence rules, 3-column troubleshooting matrix format, and GitHub alert callout standards.
  - Synchronized `install.md`, `cli-reference.md`, `export-runbook.md`, `maintenance-audit.md`, `cli.md`, and `skill-engine.md` with current `v0.4.0` capabilities.
- **Enriched Skill Routing Matrix**:
  - Expanded `SKILL.md` with natural language triggers and explicit distinction between micro quality inspection (`review <page>`) and macro health/drift scanning (`audit`).

---

## [0.3.0] — 2026-08-22 — Designer Mode, 5-Layer Quality Gates & Standalone Wiki-Prettifier

### Added
- **Standalone `wiki-prettifier` Skill** (`skills/wiki-prettifier/`): Aesthetic & UX refactoring engine with 8 modular portal components (Hero, Prereqs, Tabs, Outputs, Alerts, Mermaid, Tables, Next Steps).
- **Advanced Designer Mode** (`references/designer-mode.md`): Pre-crafted design presets (`stripe-indigo`, `nordic-cyan`, `minimalist-slate`, `emerald-terminal`) with custom CSS variables export for MkDocs Material (`docs/stylesheets/custom.css`) and Docusaurus v3+ (`src/css/custom.css`).
- **5-Layer Automated CI Quality Gates** (`references/quality-gates.md`):
  - Layer 1: Markdownlint structural checking (`.markdownlint.json`).
  - Layer 2: Automated prose & style checking via Vale and cspell (`.vale.ini`, `.cspell.json`).
  - Layer 3: Dead link and deep anchor verification via lychee.
  - Layer 4: Frontmatter, depth, and 180-day staleness verification via `pageworks doctor`.
  - Layer 5: Executable code snippet runners in CI.
  - Pipeline: `.github/workflows/docs-quality.yml`.
- **Time to First Success UX**: Standardized "Punchline First" headers, realistic sandbox defaults (`org_slug="payments-prod"`), and dedicated "Troubleshooting & Gotchas" 3-column tables.
- **Freshness Acknowledgment Command**: `pageworks sync-ack <page>` to bump `last_reviewed:` timestamp in 10ms.
- **Git-Guard Pre-Commit Hook**: Installed `scripts/hooks/pre-commit` to prevent version drift across all 7 repository manifest and documentation sites.

## [0.2.0] — 2026-08-22 — Software & Platform Wiki Dual-Dimension Architecture

### Added
- **6 Core Classes of Pages**: First-class templates and taxonomy for Tutorials/Onboarding, How-To/Runbooks, ADRs, Technical Reference Specs, Service Catalog One-Pagers, and Incident Postmortems (`skills/pageworks/templates/pages/`).
- **6 Main Topic Categories**: Information Architecture scaffolding around Getting Started, Architecture & System Design, Services & Components, Operations & Reliability, API & Data Reference, and Standards & Governance.
- **`pageworks init --preset platform`**: Scaffolds the full 6-category software & platform wiki structure.
- **Rich "Start Here" Landing Pages**: Modernized `docs/index.md` template with system purpose, explicit ownership metadata, Mermaid.js architecture diagrams, and dev environment onboarding.
- **Governance & Stale Content Auditing**:
  - `owner:` and `last_reviewed:` frontmatter fields with doctor validation.
  - 180-day (6-month) stale-page trigger in `pageworks doctor` and `pageworks audit`.
  - Automatic internal markdown link checker in `pageworks doctor`.
  - Maximum 3-level folder hierarchy enforcement.
- **Writing & Visual Standards**: Imperative action-oriented headings, copy-paste ready code snippet standards, and Mermaid.js system topology guidelines.
- **Spectacular v2 Compatibility**: Full integration with Spectacular v2.5.0 Anchors and capability contracts.

## [0.1.0] — 2026-05-23 — first release

**Pageworks ships.** Public-facing documentation moves out of spectacular into its own skill + CLI. Standalone-capable; pairs cleanly with spectacular when both are installed.

### Added
- Skill: `pageworks` (`SKILL.md` + `references/` + `templates/`) routes work across docs lifecycle (init, new, review, status, audit, export, doctor).
- CLI: `pageworks` binary with verbs `init`, `export <mkdocs|docusaurus>`, `doctor`, `--version`, `--help`.
- `pageworks init` scaffolds `docs/` + `docs.yaml` + `index.md` + default sections (Getting Started, Guides, Reference). `--minimal` for manifest + index only.
- `pageworks export mkdocs|docusaurus` generates renderer config alongside `docs/`. Idempotent (skips existing files), `--force` overwrites, `--no-workflow` skips the GitHub Pages deploy YAML, `// pageworks: do-not-overwrite` magic comment pins manual edits.
- `pageworks doctor` validates docs.yaml schema, page frontmatter, orphan files, optional `renderers:` block.
- Page-type templates: Diátaxis-aligned tutorial / how-to / reference / explanation, plus the base `page.md.tmpl` and `index.md.tmpl`.
- References:
  - `contract.md` — folder shape + `docs.yaml` schema + page frontmatter schema (lifted from spectacular's `docs-contract.md`, pageworks-native rewording)
  - `authoring.md` — page lifecycle, write/review/status verbs (lifted from spectacular's `docs-overrides.md`)
  - `renderers.md` — MkDocs + Docusaurus adapter mapping tables, GitHub Pages workflow (lifted from spectacular's `docs-renderer-adapters.md`)
  - `page-types.md` — Diátaxis quadrant guide
  - `prose-patterns.md` — voice/tone/callouts/code blocks/links (new content)
  - `maintenance.md` — drift detection, spec→doc sync patterns (new content)
- Claude Code and Codex plugin manifests.
- README, this CHANGELOG.

### Migrated from
- The docs surface that shipped in spectacular v0.6.0 → v1.1.0. Spectacular v1.2.0 marks its equivalent verbs deprecated; spectacular v2.0.0 will remove them.
