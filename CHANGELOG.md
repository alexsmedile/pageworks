# Changelog

All notable changes are documented here.
Format: [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)

---

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
