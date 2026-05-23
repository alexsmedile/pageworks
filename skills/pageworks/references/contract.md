# Contract — schema for public-facing documentation

Loaded when the orchestrator handles any `pageworks <verb>` command involving `docs/`, or when `pageworks doctor` runs.

This is pageworks's authoritative schema for the `docs/` surface. It supersedes the equivalent `docs-contract.md` that previously lived in spectacular (v0.6.0–v1.1.0), which is deprecated as of spectacular v1.2.0.

## Core principle

**`docs/` is the public-facing surface.** Internal docs (PRDs, specs, plans, decisions) live elsewhere — typically `.spectacular/` if spectacular is in use, or wherever the project keeps its internal workspace.

| Surface | Audience | Tone |
|---|---|---|
| `docs/` | End users + agents consuming the product | Narrative, task-oriented, evergreen |
| Internal workspace (`.spectacular/` if used) | Devs + coding agents building it | Precise, contract-first, frontmatter-driven |

Audience is a **folder-level** property, never a per-page one. A page lives in `docs/` because it's for consumers. No `audience` frontmatter field.

## Folder shape

```
docs/
├── docs.yaml                 # the only manifest — sections + page order + site metadata
├── index.md                  # landing page (always-on; pageworks init scaffolds it)
├── getting-started/          # one folder per section; folder name matches section id
│   ├── install.md
│   ├── quickstart.md
│   └── concepts.md
├── guides/
│   └── ...
└── reference/
    └── ...
```

**Flat tree.** Sections are folders, pages are files one level deep. No `_section.yaml`, no nested subfolders by default. If a section grows enough to need sub-grouping, express it via nested `pages:` entries in `docs.yaml` — the filesystem stays flat.

## `docs/docs.yaml` schema

```yaml
site:
  name: <Project Name>           # required
  tagline: ""                    # optional
  base_url: https://example.com  # optional — used by renderer adapters

sections:
  - id: getting-started          # required, kebab-case, must match folder name
    title: Getting Started       # required, display title
    order: 1                     # required, integer (controls nav order)
    pages: [install, quickstart, concepts]   # ordered list of page slugs (no .md)

  - id: guides
    title: Guides
    order: 2
    pages: []

extras:                          # optional — pages with no section grouping
  - changelog                    # resolves to docs/changelog.md (symlink to ../CHANGELOG.md)
  - troubleshooting
```

### Field semantics

- **`site.name`** — display name; appears in nav header
- **`site.tagline`** — short subtitle; appears under name
- **`site.base_url`** — fully-qualified URL, used by renderer adapters (see [[renderers]])
- **`sections[].id`** — kebab-case slug; must equal the folder name under `docs/`
- **`sections[].title`** — human-readable title shown in nav
- **`sections[].order`** — integer; nav sorted ascending
- **`sections[].pages`** — ordered list of page slugs (without `.md`); order here wins over per-page `order:`
- **`extras`** — page slugs that have no section parent; rendered at the top level of nav

## Page frontmatter schema

```yaml
---
title: Install
description: Get the CLI running in two minutes.
section: getting-started
type: how-to
order: 1
status: stable
since: 0.1.0
updated: 2026-05-23
---
```

| Field | Required | Default | Notes |
|---|---|---|---|
| `title` | yes | — | Display title; doctor warns if absent and falls back to first H1 |
| `description` | yes | — | One sentence; used in nav previews and SEO |
| `section` | yes | — | Must equal a section id in `docs.yaml`. `""` for top-level extras |
| `type` | recommended | — | One of `tutorial` / `how-to` / `reference` / `explanation` (Diátaxis); see [[page-types]] |
| `order` | no | position in `docs.yaml`'s `pages:` array | Per-page override |
| `status` | yes | — | `stable` / `draft` / `deprecated` |
| `since` | no | — | First version this page applied to (semver) |
| `updated` | yes | — | ISO date (`YYYY-MM-DD`). Doctor flags if older than file mtime by more than 14 days |
| `synced_from` | no | — | Path to a source spec/file; enables drift detection (see [[maintenance]]) |

> **No `audience` field.** Folder is the audience boundary — see Core principle above.

## Validation rules (`pageworks doctor` + skill `review`)

| Severity | Check |
|---|---|
| error | `docs.yaml` missing or unparseable |
| error | Page declared in `docs.yaml` but file missing on disk |
| warning | Page file present but not declared in `docs.yaml` (orphan) |
| error | Page missing required frontmatter (`title`, `description`, `section`, `status`, `updated`) |
| error | Page `section:` doesn't match any section in `docs.yaml` |
| warning | Page `updated:` is more than 14 days older than file mtime |
| warning | Section folder exists but has no pages declared |
| info | Section declared in `docs.yaml` with empty `pages:` (intentional empty section is fine) |
| info | Page missing `type:` (Diátaxis type) — recommended but not required in v0.1.0 |

## Mechanical fixes (`pageworks doctor --fix`)

| Trigger | Fix |
|---|---|
| Missing required frontmatter fields | Inject stub frontmatter at top of file (status: draft, updated: today, title: first H1 if present) |
| Duplicate entries in `docs.yaml` `pages:` | Dedupe in place |
| `docs/` dir missing | `mkdir -p docs/` (only when `docs.yaml` is being referenced from config or scaffold attempt) |

Judgment fixes (delete orphan files, rename sections, merge pages) require skill intervention — never mechanical.

## Renderer-agnostic by design

`docs.yaml` + page frontmatter are designed to map cleanly to:
- MkDocs `mkdocs.yml` `nav:` block — **shipped (v0.1.0)**, see [[renderers]]
- Docusaurus `sidebars.js` + per-page frontmatter — **shipped (v0.1.0)**, see [[renderers]]
- Mintlify `mint.json` (sections → groups, pages → entries) — community-contributable
- Fumadocs `meta.json` per folder — community-contributable

The schema itself is renderer-neutral — the user picks any renderer or stays renderer-less. v0.1.0 ships two adapters via `pageworks export <renderer>`. Other renderers are documented as a contribution path in [[renderers]] § Contributing a renderer.

### `renderers:` block

`docs.yaml` accepts an optional top-level `renderers:` map for renderer-specific hints. Each top-level key under `renderers:` is a renderer name; its value is a map of adapter-specific settings. Adapters consume their own sub-key; unknown sub-keys within a known renderer are ignored.

```yaml
renderers:                              # optional, additive — base schema works without it
  mkdocs:
    theme: material                     # default if omitted
    primary: indigo                     # palette primary color
    scheme: slate                       # light | slate | default
    repo_url: https://github.com/org/repo
    edit_uri: edit/main/docs/
  docusaurus:
    preset: classic                     # default if omitted
    organizationName: org
    projectName: repo
```

#### Recognized renderer names

| Renderer | Adapter ships at | Status |
|---|---|---|
| `mkdocs` | `pageworks export mkdocs` | shipped (v0.1.0) |
| `docusaurus` | `pageworks export docusaurus` | shipped (v0.1.0) |
| `mintlify` | — | not shipped (community-contributable) |
| `fumadocs` | — | not shipped (community-contributable) |

Any other top-level key under `renderers:` is **unknown** and triggers a doctor warning (it's allowed — community adapters may register their own — but the warning surfaces typos like `mkdoc:` vs `mkdocs:`).

#### Per-renderer key reference

The full mapping of `docs.yaml` source → renderer config target lives in [[renderers]]. That doc is authoritative for which keys each adapter consumes.

#### Validation (`pageworks doctor`)

| Severity | Check |
|---|---|
| info | `renderers:` block absent (every adapter falls back to its built-in defaults) |
| pass | `renderers:` parses, all top-level keys are recognized renderer names |
| warning | Top-level key under `renderers:` is not a recognized renderer name (typo or unknown adapter) |
| error | `renderers:` value is not a map (e.g., a bare scalar or list) |

## Anti-patterns

- **Per-folder manifest files (`_section.yaml`, `meta.json`)** — multiplies maintenance touchpoints; one `docs.yaml` is enough
- **Per-page `audience` field** — folder is the audience boundary; per-page audience is ceremony
- **Sections deeper than one level on disk** — express sub-grouping in `docs.yaml`, keep the filesystem flat
- **Mixing internal-doc content into `docs/`** — PRDs, specs, plans, decisions belong in the project's internal workspace (e.g. `.spectacular/` if spectacular is in use); `docs/` is the public-facing surface only
- **Auto-rendering** — pageworks writes portable markdown + manifest; the renderer runs in the user's tooling. No built-in server, no built-in build.
- **Mixing Diátaxis types in one page** — a single `.md` is one quadrant. If a page is doing two jobs, split it. See [[page-types]].
