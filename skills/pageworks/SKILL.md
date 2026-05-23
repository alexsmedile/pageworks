---
name: pageworks
description: |
  Public-facing documentation skill — owns the docs/ surface end-to-end: scaffold,
  schema, page authoring, renderer export (MkDocs Material + Docusaurus), and
  maintenance as specs change.
when_to_use: |
  - Any work inside a project's docs/ folder: writing pages, planning structure,
    updating after a spec change, exporting to a renderer.
  - Triggers: `pageworks init`, `pageworks export <renderer>`, `pageworks doctor`,
    `pageworks new <page>`, `pageworks review`, `pageworks status`, `pageworks audit`,
    "write a docs page for X", "add a tutorial about Y", "the docs are stale".
  - When spectacular hands off public-doc work after archiving a request that
    touched SPEC.md or specs/.
  - As a standalone tool on projects that don't use spectacular — pageworks can
    scaffold and own docs/ entirely on its own.
version: 0.1.0
category: devtools
status: published
compatible_with: spectacular >= 1.0.0   # informational; pageworks does not require spectacular
---

# pageworks

**Public-facing documentation, end-to-end.** Pageworks owns everything inside a project's `docs/` folder: scaffold, schema, structure, authoring, renderer export, drift detection.

Standalone-capable: works on any project, with or without spectacular. When spectacular *is* present, it discovers pageworks and hands off public-doc work explicitly (under user confirmation).

## What pageworks owns

- `docs/` scaffold — folder shape, `docs.yaml` manifest, `index.md`, default sections
- `docs.yaml` schema and validation
- Page frontmatter contract and frontmatter audits
- Page-type templates (Diátaxis: tutorial / how-to / reference / explanation)
- Prose patterns — voice, tone, callouts, code blocks, link conventions
- Renderer adapters — `pageworks export mkdocs|docusaurus` (more renderers contributable)
- Doctor — schema, frontmatter, orphan, and drift detection
- Maintenance — flagging pages whose source spec changed since last `updated:`

## What pageworks does NOT own

- Internal operational docs (`PRD.md`, `SPEC.md`, `PLAN.md`, `TASKS.md`, etc.) — those belong to **spectacular** and live in `.spectacular/`
- Project conventions outside `docs/` — those belong to spectacular's convention packs
- Code, tests, configs, deployment

If you came here from spectacular: spectacular knows you have a `docs/` folder and that a manifest is present, but delegates everything else to pageworks. The boundary is sharp.

## Routing table

| User intent | Load |
|---|---|
| `pageworks init` or scaffolding a fresh docs/ tree | [`references/contract.md`](references/contract.md) — schema + folder shape |
| `pageworks new <page>` or writing a new page | [`references/authoring.md`](references/authoring.md) — page lifecycle + [`references/page-types.md`](references/page-types.md) — Diátaxis guide |
| `pageworks review` or auditing existing pages | [`references/authoring.md`](references/authoring.md) + [`references/prose-patterns.md`](references/prose-patterns.md) |
| `pageworks export <renderer>` | [`references/renderers.md`](references/renderers.md) — adapter mapping tables |
| `pageworks doctor` | [`references/contract.md`](references/contract.md) — validation rules |
| `pageworks status` or briefing | [`references/contract.md`](references/contract.md) — folder/manifest layout |
| `pageworks audit` or drift detection | [`references/maintenance.md`](references/maintenance.md) — drift rules + remediation |
| Hand-off from spectacular after a spec change | [`references/maintenance.md`](references/maintenance.md) + [`references/authoring.md`](references/authoring.md) |

## Triggers

The CLI verbs above (`init`, `export`, `doctor`) run from the shell. The authoring verbs (`new`, `review`, `status`, `audit`) are skill verbs — invoke them from inside an AI agent that has pageworks loaded.

When in doubt: type `pageworks` in your agent and ask for a briefing.

## Pairing with spectacular

When both are installed:

- Spectacular continues to own `.spectacular/` (internal workspace).
- Spectacular's `doctor docs` becomes discovery-only: it notes whether `docs/` and a manifest exist, then points at pageworks. No schema validation.
- After `spectacular archive <slug>` for a request that changed SPEC.md or specs/, spectacular prompts the user about updating public docs. If the user agrees, pageworks takes over.

When pageworks runs without spectacular:

- `pageworks init` scaffolds `docs/` directly. No `.spectacular/` is required.
- All capabilities work the same — pageworks doesn't read from `.spectacular/` for any of its core verbs.
