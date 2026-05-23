---
status: planned
priority: medium
owner: alex
updated: 2026-05-23
target_version: pageworks v0.3.0 (or later — depends on agents request)
summary: "Use pageworks to author pageworks's own docs/ — the canonical example, deployed to GitHub Pages"
related:
  - ../pageworks-agents/PLAN.md
  - ../../../skills/pageworks/SKILL.md
  - ../../../skills/pageworks/references/contract.md
  - ../../../skills/pageworks/references/page-types.md
  - ../../../README.md
---

# Plan — public docs dogfood

## Goal

Use pageworks itself to author the canonical `docs/` for the pageworks project. Deploy to GitHub Pages via the MkDocs adapter shipped in v0.1.0. The site at https://alexsmedile.github.io/pageworks/ becomes the public reference for what pageworks produces — the proof that the skill works on its own surface.

## Why

Three pressures point here:

1. **Authoring credibility.** A docs skill without docs is a vibe, not a tool. Anyone evaluating pageworks should be able to click through a real example produced by the skill.
2. **Schema validation.** Authoring real content surfaces edge cases the test suite misses — page-type ambiguities, cross-quadrant link patterns, frontmatter that needs evolving.
3. **Diátaxis exercise.** Pageworks ships four page-type templates. Writing pageworks's own docs forces us to use all four and discover where the templates need work.

The blocker until now was "spectacular owns the scaffolding" (v0.6.0 → v1.1.0). With pageworks v0.1.0 shipped, that blocker is gone. The remaining sequencing question: do we dogfood with the main agent, or wait for pageworks-agents to ship so the subagents do the writing? That's the activation question.

## Activation

Two paths, decide at activation time:

**Path A: dogfood now (main agent authors)** — proves pageworks works end-to-end without depending on the unfinished agents request. Slower writing, but ships sooner. Becomes the activation signal that justifies pageworks-agents (multi-page friction = real trigger).

**Path B: wait for pageworks-agents to ship, then dogfood** — uses docs-writer/reviewer to author. Faster writing once available, but adds a dependency chain. Doesn't ship until v0.3.0+.

Recommendation: Path A. The friction-discovery value alone justifies it, and we get a live site sooner.

## Scope

### In scope

**Authoring (the core work)**

- Author the following pages, each with declared Diátaxis `type`:
  - `docs/index.md` (already exists from `pageworks init` scaffold) — landing, explanation type
  - `docs/getting-started/install.md` — tutorial (curl install + first `pageworks init`)
  - `docs/getting-started/quickstart.md` — tutorial (init → new → export → preview locally)
  - `docs/getting-started/concepts.md` — explanation (Diátaxis, the docs.yaml schema, the boundary with spectacular)
  - `docs/guides/write-your-first-page.md` — how-to
  - `docs/guides/deploy-to-github-pages.md` — how-to (MkDocs adapter + workflow)
  - `docs/guides/migrate-from-spectacular.md` — how-to (for users on spectacular v1.1.x)
  - `docs/guides/pair-with-spectacular.md` — how-to (using both skills together)
  - `docs/reference/cli.md` — reference (all `pageworks` CLI verbs + flags)
  - `docs/reference/docs-yaml.md` — reference (full manifest schema)
  - `docs/reference/page-frontmatter.md` — reference (per-page fields)
  - `docs/reference/diataxis-templates.md` — reference (the 4 page templates)
  - `docs/reference/renderers.md` — reference (MkDocs + Docusaurus mapping)

**Manifest + structure**

- Update `docs/docs.yaml` to declare all sections + pages
- Populate `renderers:` block with pageworks's MkDocs Material config (palette, repo_url, edit_uri)

**Deployment**

- Run `pageworks export mkdocs` to generate `mkdocs.yml` + `.github/workflows/docs.yml`
- Enable GitHub Pages in repo settings (Settings → Pages → Source = GitHub Actions)
- Confirm the workflow deploys successfully on push
- Site live at https://alexsmedile.github.io/pageworks/

**Quality gates**

- `pageworks doctor` passes (0 errors) before each page is marked `status: stable`
- Cross-quadrant links: every tutorial + explanation page has at least one outbound link
- `pageworks review` (in-agent) walk for each page before promoting to `stable`

### Out of scope

- **Docusaurus deployment.** MkDocs is the primary; we keep Docusaurus generation working (export still produces valid config) but only deploy one. Reduces surface to maintain.
- **Search index, analytics, comments.** All deferred. The site is reference-quality, not a polished marketing site.
- **i18n.** English only.
- **Custom theme/branding.** Material defaults with the project palette. No custom CSS.
- **API reference generation from code.** Pageworks's CLI surface is documented by hand in `docs/reference/cli.md`; no AST-driven generation.
- **Automated sync with spectacular's docs.** Pageworks's docs are independent; no cross-repo doc generation.

## Decisions (provisional)

- **MkDocs Material as the single deployed renderer.** Docusaurus generation tested but not deployed.
- **No `synced_from:` in v0.3.0 dogfood.** Pageworks doesn't (yet) have internal specs the way spectacular does. The drift-detection patterns get exercised in a downstream project, not here.
- **All pages start `status: draft`.** Promote to `stable` only after `pageworks review` passes.
- **Manual authoring (Path A).** Don't wait for pageworks-agents.

## Milestones

1. **M1 — Manifest + structure** — Populate `docs.yaml` with all sections + page slugs; create empty stub files per slug
2. **M2 — Tutorials** — Author install, quickstart, concepts (foundation)
3. **M3 — How-tos** — Write your first page, deploy to GitHub Pages, migrate-from-spectacular, pair-with-spectacular
4. **M4 — References** — CLI, docs.yaml, page-frontmatter, diataxis-templates, renderers (reference structure is repetitive — predictable)
5. **M5 — Cross-linking + polish** — Every tutorial/explanation links forward; references link back; index updated to surface all sections
6. **M6 — Export + deploy** — Run `pageworks export mkdocs`, push, enable Pages, confirm green deploy
7. **M7 — Release** — Tag pageworks v0.3.0 (or whatever's next), CHANGELOG entry, GitHub release, README badge linking to docs

## Risks

- **Scope creep.** "Just one more page" balloons authoring to 6 weeks. Mitigation: the 13 pages above are the cap; new pages get a follow-on request.
- **Tone drift across pages.** Same person writing 13 pages over several sessions develops voice variance. Mitigation: `pageworks review` against `prose-patterns.md` before promoting any page to `stable`.
- **MkDocs Material version churn.** Plugin/theme updates break the build. Mitigation: pin versions in the deploy workflow; document upgrade path in `docs/reference/renderers.md`.
- **GitHub Pages permissions friction.** First-time setup needs `contents: write` + Pages enabled. Mitigation: the workflow already shipped in v0.1.0 has the right permissions; just need Pages enabled in repo settings.
- **Authoring exposes pageworks bugs.** Likely a feature, not a bug. Mitigation: pause dogfood, fix the bug in a patch release, resume.

## Validation

- `pageworks doctor` reports 0 errors
- All declared pages exist; no orphan files
- All pages have declared `type:` (Diátaxis quadrant)
- Every tutorial + explanation has at least one outbound cross-quadrant link
- `pageworks export mkdocs` produces config; `mkdocs build --strict` succeeds locally
- `mkdocs serve` renders all pages without errors
- GitHub Pages deploy is green on push to main
- https://alexsmedile.github.io/pageworks/ loads, nav is correct, every linked page resolves

## Success criteria

- 13 pages authored, all `status: stable` after review
- Site live at https://alexsmedile.github.io/pageworks/
- `docs.yaml` cleanly declares structure (no orphans, no missing files, no malformed frontmatter)
- README links to the live docs
- Pageworks v0.3.0 (or current target) tagged + released
- This request becomes the canonical "see what pageworks produces" reference
