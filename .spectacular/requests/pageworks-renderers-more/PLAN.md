---
status: planned
priority: low
owner: alex
updated: 2026-05-23
target_version: pageworks v0.5.x (community-contribution-driven)
summary: "Additional renderer adapters — Mintlify, Fumadocs — accepted as community contributions per the contract in renderers.md"
related:
  - ../../../skills/pageworks/references/renderers.md
  - ../../../skills/pageworks/references/contract.md
---

# Plan — pageworks renderers more

## Goal

Add renderer adapters beyond the two shipped in v0.1.0 (MkDocs Material + Docusaurus). Specifically: Mintlify and Fumadocs, plus any community-contributed adapter that conforms to the contract in `references/renderers.md` § Contributing a renderer.

## Why

v0.1.0 deliberately shipped only two adapters — enough to validate the schema is renderer-agnostic, not enough to claim broad ecosystem coverage. The deferred renderers each have legitimate reasons for being out of v0.1.0:

- **Mintlify** — source-available + paid for production. Not OSS by FSF criteria. Free for OSS projects via application; otherwise $150+/mo. Adding it ourselves implies endorsement.
- **Fumadocs** — Next.js-only. Anyone using it already has a JS toolchain we shouldn't presume.

Both are legitimate targets for users who want them. The right path is **community contribution**, not us shipping every renderer that exists.

## Activation triggers

Don't start the maintainer-driven work until **2 of 3** fire:

1. A community PR arrives with a working Mintlify or Fumadocs adapter
2. Three or more issues requesting a specific renderer (Mintlify/Fumadocs/Hugo/Astro Starlight/etc.)
3. A consulting/sponsorship context where shipping a specific renderer is funded

If a community PR arrives, this becomes a **review + integrate** request, not a from-scratch build.

## Scope

### In scope (per renderer, once activated)

For each shipped renderer (whether community-contributed or maintainer-built):

- **Mapping table** — append to `references/renderers.md` documenting `docs.yaml` → renderer-config transformation
- **Adapter implementation** in `cli/pageworks`:
  - New `cmd_export_<renderer>()` function
  - Reads `renderers.<renderer-name>` block for renderer-specific knobs
  - Writes the renderer's config file(s) at conventional locations
  - Respects `--out`, `--force`, the `// pageworks: do-not-overwrite` magic comment
  - Optionally writes a GitHub Pages workflow (if no workflow exists for any renderer in the project; otherwise leaves alone)
  - Prints post-export checklist with renderer-specific install/preview/build commands
- **Doctor `renderers:` validation** — add the renderer name to the `known_renderers` list in `cli/pageworks`
- **Tests** — port the structure of `tests/cli/export.test.sh` scenarios 2-12 for the new renderer
- **`renderers.md` updates** — add the new renderer to the recognized-names table; remove from the "not shipped" row

### Out of scope

- **Renderer round-trip.** Importing existing Mintlify/Docusaurus/etc. configs into pageworks's schema — separate request if ever needed.
- **Adapter-specific authoring features.** Mintlify components, Fumadocs MDX shortcodes, Docusaurus admonitions — each renderer has features that don't translate. Pageworks stays renderer-neutral; users who need rich components write them directly in the page (the adapter passes through MDX/HTML unmodified).
- **Hosted preview / build pipeline.** Pageworks writes config; the renderer's tooling builds. No bundled `mintlify dev`, no bundled `fuma-docs` build.
- **Auto-detection of installed renderers.** User chooses the renderer in `docs.yaml` + at `pageworks export <renderer>`. No magic.

## Decisions (provisional)

- **Community contributions are the default path.** The contract in `references/renderers.md` § Contributing a renderer documents what's needed. Maintainer-built adapters happen only when a community PR doesn't materialize and demand is real.
- **Each renderer ships in a patch release** (v0.5.0 → v0.5.1 → v0.5.2 etc.), not bundled in a single minor bump. Lets us merge community PRs as they arrive.
- **Naming is canonical.** `mintlify`, `fumadocs`, `hugo`, `astro-starlight`, etc. — kebab-case, matches the renderer's own naming. No aliases.

## Milestones (per renderer)

Each renderer addition follows the same shape:

1. **M1 — Source the adapter.** Either accept a community PR or write the adapter ourselves (activation-trigger-dependent)
2. **M2 — Integrate.** Add to `cli/pageworks`, update `references/renderers.md`, add to `known_renderers` doctor list
3. **M3 — Test.** Port `export.test.sh` scenarios for the new renderer
4. **M4 — Release.** Bump patch version, CHANGELOG entry naming the renderer, GitHub release

## Risks

- **Adapter quality variance from community PRs.** Mitigation: the contract in `references/renderers.md` is strict (write/read/respect/print) — PRs missing any contract point are returned with the gap named.
- **Renderer ecosystem churn.** Adapters for renderers that go out of maintenance accumulate. Mitigation: each renderer's section in `renderers.md` declares `last-validated-against: <version> as of <date>` — stale adapters get a deprecation banner if the underlying renderer abandons backward compat.
- **Maintenance burden.** Three renderer adapters in v0.1.0+ + community renderers can become a per-release support tax. Mitigation: each adapter has its own test suite; CI runs them on every PR; community adapters require a maintainer-of-record before merge.

## Success criteria (per renderer)

- Adapter generates a valid renderer config from `pageworks init`-style docs
- `mkdocs build --strict`-equivalent for the renderer passes locally
- Test suite green
- `references/renderers.md` documents the mapping
- Renderer name accepted by `pageworks doctor` without warning
