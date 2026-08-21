---
name: pageworks
description: |
  Public-facing software & platform documentation skill — owns the docs/ surface end-to-end:
  Dual-Dimension Architecture (6 Page Classes & 6 Topic Categories), scaffold, schema,
  page authoring, renderer export (MkDocs Material, Docusaurus v3+, Docker), and 180-day
  stale-page drift maintenance.
when_to_use: |
  - Any work inside a project's docs/ folder: writing pages, planning structure,
    updating after a spec change, exporting to a renderer or wiki setup.
  - Triggers: `pageworks init`, `pageworks export <renderer>`, `pageworks doctor`,
    `pageworks new <page>`, `pageworks review`, `pageworks status`, `pageworks audit`,
    "write a docs page for X", "add a tutorial about Y", "create an ADR/runbook",
    "the docs are stale", "help me choose a docs/wiki platform".
  - When choosing or configuring Docs-as-Code (MkDocs, Docusaurus, Starlight, Scalar) vs
    Self-Hosted Wikis (Docmost, Outline, BookStack, Wiki.js).
  - When spectacular hands off public-doc work after completing a mission or
    amending a contract that touches project anchors or capability specs.
  - As a standalone tool on projects that don't use spectacular.
version: 0.2.0
category: devtools
status: published
compatible_with: spectacular >= 2.0.0   # informational; pageworks does not require spectacular
---

# pageworks

**Public-facing software & platform documentation, end-to-end.** Pageworks owns everything inside a project's `docs/` folder: scaffold, schema, structure, authoring, renderer export, drift detection, and platform architecture.

Standalone-capable: works on any project, with or without spectacular. When spectacular *is* present, it discovers pageworks and hands off public-doc work explicitly (under user confirmation).

## What pageworks owns

- **Dual-Dimension Architecture**:
  - **The 6 Core Classes of Pages**: `tutorial`, `how-to`, `adr`, `reference`, `service-catalog`, `postmortem` (plus `explanation`).
  - **The 6 Main Topic Categories**: `getting-started/`, `architecture/`, `services/`, `operations/`, `reference/`, `standards/`.
- `docs/` scaffold — shallow hierarchy (max 3 levels), `docs.yaml` manifest, rich "Start Here" `index.md`.
- `docs.yaml` schema and frontmatter validation (`owner:`, `last_reviewed:`, `status:`).
- Standardized page templates (ADR, Runbook, Service Catalog, Postmortem, Tutorial, Reference, Explanation).
- Prose & visual patterns — imperative action headings, copy-paste fidelity, Mermaid.js topology diagrams.
- Renderer export adapters — `pageworks export mkdocs|docusaurus` (with dark/light toggles, instant search, mermaid superfences, tabs, React/MDX, and GitHub Actions deploy workflows).
- Governance & Doctor — schema, orphan detection, 180-day stale review warnings, internal link validation, and depth enforcement.
- Maintenance & Drift — mtime-based tracking against upstream specs/anchors (`synced_from:`).

## What pageworks does NOT own

- Internal operational docs (Anchors like `PROJECT.md`, `STACK.md`, `ARCHITECTURE.md`, Contracts, Missions, Decisions) — those belong to **spectacular** and live in `.spectacular/`
- Project conventions outside `docs/` — those belong to spectacular's convention packs
- Code, tests, configs, deployment

If you came here from spectacular: spectacular knows you have a `docs/` folder and that a manifest is present, but delegates everything else to pageworks. The boundary is sharp.

## Routing table

| User intent | Load |
|---|---|
| `pageworks init` or scaffolding a fresh docs/ tree | [`references/contract.md`](references/contract.md) — schema + folder shape |
| `pageworks new <page>` or writing a new page | [`references/authoring.md`](references/authoring.md) + [`references/page-types.md`](references/page-types.md) — 6 Core Classes |
| `pageworks review` or auditing existing pages | [`references/authoring.md`](references/authoring.md) + [`references/prose-patterns.md`](references/prose-patterns.md) |
| `pageworks export <renderer>` or choosing a docs tool | [`references/renderers.md`](references/renderers.md) — SSGs, wikis & Docker guides |
| `pageworks doctor` | [`references/contract.md`](references/contract.md) — validation rules |
| `pageworks status` or briefing | [`references/contract.md`](references/contract.md) — folder/manifest layout |
| `pageworks audit` or drift detection | [`references/maintenance.md`](references/maintenance.md) — 180-day stale rules + remediation |
| Hand-off from spectacular after a spec/contract change | [`references/maintenance.md`](references/maintenance.md) + [`references/authoring.md`](references/authoring.md) |

## Platform Landscape Guide

When a user asks **"What docs/wiki tool should I use?"**, load [`references/renderers.md`](references/renderers.md) and evaluate:

1. **Docs-as-Code (Git-Centric, SSG)**:
   - **MkDocs (Material)**: Best for internal engineering wikis & runbooks. Python/pip, zero JS overhead, instant search, tabs, Mermaid diagrams.
   - **Docusaurus (v3+)**: Best for public developer portals. React/MDX, multi-versioning, i18n.
   - **Starlight (Astro)**: High performance, minimal JS footprint.
   - **Scalar / Redoc**: Interactive OpenAPI/Swagger documentation.
2. **Collaborative Wikis (Browser-Centric, Teams)**:
   - **Docmost**: Open-source Confluence alternative with real-time collaboration & spaces.
   - **Outline**: Notion-like block Markdown editor with SSO/OIDC permissions.
   - **BookStack**: Enforced structure (Shelves $\to$ Books $\to$ Chapters $\to$ Pages) for operational teams.
   - **Wiki.js**: Hybrid developer wiki with 2-way Git sync.

## Triggers

The CLI verbs above (`init`, `export`, `doctor`) run from the shell. The authoring verbs (`new`, `review`, `status`, `audit`) are skill verbs — invoke them from inside an AI agent that has pageworks loaded.

When in doubt: type `pageworks` in your agent and ask for a briefing.
