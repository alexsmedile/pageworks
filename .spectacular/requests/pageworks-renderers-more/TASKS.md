---
updated: 2026-05-23
related:
  - PLAN.md
---

# Tasks — pageworks renderers more

> **Status: planned, gated.** Don't begin until 2-of-3 activation triggers fire (see PLAN.md). Each renderer is its own micro-milestone with the same shape.

## M1 — Activation triggers

- [ ] Track community-contributed adapter PRs (link as they arrive)
- [ ] Track issues requesting specific renderers (count + name them)
- [ ] Track sponsorship/consulting cases where a specific renderer is required
- [ ] Update this PLAN when 2-of-3 fire

## Per-renderer template (apply to each renderer activated)

### Renderer: Mintlify (template — fill in if activated)

- [ ] Source: community PR / maintainer-built (circle one)
- [ ] Mapping table appended to `references/renderers.md` (`docs.yaml` → `mint.json` schema)
- [ ] `cmd_export_mintlify()` function in `cli/pageworks`
- [ ] Reads `renderers.mintlify` block from `docs.yaml`
- [ ] Writes `mint.json` at conventional location (`docs/mint.json` per Mintlify default)
- [ ] Optional: writes Mintlify deploy guidance to README hint (Mintlify is hosted, no workflow needed — the post-export checklist must reflect this)
- [ ] Respects `--out`, `--force`, magic-comment pin
- [ ] Adds `mintlify` to `known_renderers` in `cmd_doctor`
- [ ] Tests in `tests/cli/export.test.sh` for the new renderer (port scenarios 2-12)
- [ ] `references/renderers.md` § Recognized renderer names: move mintlify from "not shipped" to "shipped (vX.Y.Z)"
- [ ] CHANGELOG entry: `Added: pageworks export mintlify`
- [ ] Bump patch version
- [ ] GitHub release

### Renderer: Fumadocs (template — fill in if activated)

- [ ] Source: community PR / maintainer-built
- [ ] Mapping table appended to `references/renderers.md` (`docs.yaml` → `meta.json` per folder)
- [ ] `cmd_export_fumadocs()` function in `cli/pageworks`
- [ ] Reads `renderers.fumadocs` block
- [ ] Writes `meta.json` files (one per folder per Fumadocs convention)
- [ ] Optional: GitHub Pages workflow variant for Next.js + Vercel preferred (Pages possible but unusual)
- [ ] Respects `--out`, `--force`, magic-comment pin
- [ ] Adds `fumadocs` to `known_renderers`
- [ ] Tests
- [ ] `references/renderers.md` updated
- [ ] CHANGELOG entry
- [ ] Bump patch version
- [ ] GitHub release

### Renderer: Hugo (template — only if activation case names it)

- [ ] (Same shape as above — Hugo's config is `hugo.toml` / `hugo.yaml` / `config.toml`)
- [ ] Mapping table
- [ ] `cmd_export_hugo()`
- [ ] Reads `renderers.hugo` block
- [ ] Writes `config.toml` + `content/_index.md` structure
- [ ] Tests
- [ ] CHANGELOG, version bump, release

### Renderer: Astro Starlight (template — only if activation case names it)

- [ ] (Same shape — Starlight's config is `astro.config.mjs` + Starlight integration)
- [ ] Mapping table
- [ ] `cmd_export_starlight()`
- [ ] Reads `renderers.starlight` block
- [ ] Writes `astro.config.mjs` with Starlight integration block
- [ ] Tests
- [ ] CHANGELOG, version bump, release

## Per-renderer post-merge tasks

- [ ] Snapshot PLAN + TASKS at each renderer's release (rename `PLAN@<renderer>.md` to track which renderers shipped from this request)
- [ ] Update CLAUDE.md Active Requests table when this request closes (after final renderer ships, or when activation interest dies)
- [ ] Eventually archive → `.spectacular/archive/pageworks-renderers-more/` once enough renderers ship to call it done

## Open questions

- [ ] At what point is this request "done"? (After 2 renderers ship? After community PR cadence stabilizes? Indefinite open-shop?)
- [ ] Should community-contributed adapters live in a separate "contrib/" directory in pageworks, vs first-class in `cli/pageworks`?
- [ ] Should each adapter declare a `maintainer:` in the renderers.md table so contributors know who reviews their PR?
