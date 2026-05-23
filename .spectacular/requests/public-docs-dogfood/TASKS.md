---
updated: 2026-05-23
related:
  - PLAN.md
  - ../pageworks-agents/PLAN.md
---

# Tasks — public docs dogfood

## M1 — Manifest + structure

- [ ] Decide path: A (manual authoring now) vs B (wait for pageworks-agents)
- [ ] If Path A: confirm pageworks v0.1.0 init scaffold is the starting point
- [ ] Update `docs/docs.yaml`:
  - Declare all 4 sections: getting-started, guides, reference (already present); plus root-level extras (changelog)
  - Declare all 13 page slugs in correct `pages:` lists
  - Populate `renderers:` block: mkdocs (theme: material, palette: indigo/slate, repo_url, edit_uri)
- [ ] Create stub files for each declared page (empty frontmatter + H1) so `pageworks doctor` passes structural checks early

## M2 — Tutorials (3 pages)

- [ ] Author `docs/getting-started/install.md` (type: tutorial)
  - curl-install command, verify with `pageworks --version`, first `pageworks init`, what you'll have at the end
- [ ] Author `docs/getting-started/quickstart.md` (type: tutorial)
  - Walk: init → new (a page) → export mkdocs → preview locally
- [ ] Author `docs/getting-started/concepts.md` (type: explanation)
  - The docs.yaml schema, Diátaxis briefly, the spectacular boundary, why pages are renderer-agnostic
- [ ] `pageworks review` each before promoting to `status: stable`

## M3 — How-tos (4 pages)

- [ ] `docs/guides/write-your-first-page.md` (type: how-to)
- [ ] `docs/guides/deploy-to-github-pages.md` (type: how-to)
- [ ] `docs/guides/migrate-from-spectacular.md` (type: how-to) — for users on spectacular v1.1.x; mirrors the migration guide in spectacular's CHANGELOG
- [ ] `docs/guides/pair-with-spectacular.md` (type: how-to) — coexistence + handoff prompt + when to use which
- [ ] `pageworks review` each

## M4 — References (5 pages)

- [ ] `docs/reference/cli.md` — full CLI surface (init, export, doctor, --version, --help, skill verbs)
- [ ] `docs/reference/docs-yaml.md` — manifest schema (sections, extras, renderers block)
- [ ] `docs/reference/page-frontmatter.md` — per-page fields (title, description, section, type, status, since, updated, synced_from)
- [ ] `docs/reference/diataxis-templates.md` — the 4 templates and when to use each
- [ ] `docs/reference/renderers.md` — MkDocs + Docusaurus adapter mapping (cross-link to skill's renderers.md)
- [ ] `pageworks review` each
- [ ] Reference pages: predictable structure (signature, parameters table, example, see-also) across every entry

## M5 — Cross-linking + polish

- [ ] Every tutorial ends with "Next" section linking to a how-to + a reference page
- [ ] Every explanation has cross-quadrant links to how-tos + references
- [ ] Every reference links back to a tutorial (for new readers) + adjacent how-tos
- [ ] Update `docs/index.md` to surface all sections with one-line previews
- [ ] Run final `pageworks doctor` — 0 errors
- [ ] Run `pageworks review` walk on every page — 0 errors, address warnings

## M6 — Export + deploy

- [ ] Run `pageworks export mkdocs` — confirm `mkdocs.yml` + `.github/workflows/docs.yml` generated cleanly
- [ ] `pip install mkdocs mkdocs-material && mkdocs build --strict` locally — confirm no build errors
- [ ] `mkdocs serve` — visual inspection: nav order correct, all pages render, no broken links
- [ ] Enable GitHub Pages in repo settings: Source = GitHub Actions
- [ ] Commit + push the generated workflow + mkdocs.yml
- [ ] Confirm the GH Actions deploy workflow runs green
- [ ] Verify https://alexsmedile.github.io/pageworks/ loads
- [ ] Click through every page in nav — confirm no 404s, no broken images

## M7 — Release + announce

- [ ] Bump `PAGEWORKS_VERSION` in `cli/pageworks` to target version (likely 0.3.0)
- [ ] Bump both plugin.json manifests
- [ ] Bump SKILL.md frontmatter version
- [ ] CHANGELOG entry: `[0.3.0] — public docs/ published; 13 pages across tutorial/how-to/reference/explanation; deployed to GitHub Pages`
- [ ] Add badge to README: `[![docs](https://img.shields.io/badge/docs-live-blue)](https://alexsmedile.github.io/pageworks/)`
- [ ] Update README "Quickstart" to link to the deployed quickstart page
- [ ] Update `CLAUDE.md` Active Requests table
- [ ] Snapshot PLAN + TASKS, archive request → `.spectacular/archive/public-docs-dogfood/`
- [ ] Tag v0.3.0 (or current target), push, `gh release create --generate-notes`
- [ ] `/plugin marketplace update pageworks` (user-triggered)

## Open questions to resolve during execution

- [ ] Path A or Path B? Decide at M1.
- [ ] Do we need a custom logo/SVG for the Material theme, or use the default?
- [ ] Should `docs/changelog.md` symlink to repo CHANGELOG.md, or be a separately curated user-facing changelog?
- [ ] When does the `migrate-from-spectacular.md` page become unnecessary (post spectacular v2.0.0)?
