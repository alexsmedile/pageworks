---
name: pageworks
description: |
  Public-facing software & platform documentation skill — owns the docs/ surface end-to-end:
  Dual-Dimension Architecture (6 Page Classes & 6 Topic Categories), scaffold, schema,
  page authoring, renderer export (MkDocs Material, Docusaurus v3+, Docker), and 180-day
  stale-page drift maintenance.
compatibility: "spectacular >= 2.0.0"
metadata:
  version: "0.3.0"
  category: "devtools"
  status: "published"
  tags: "documentation, docs, mkdocs, docusaurus, wiki, diataxis"
---

# Pageworks

Orchestrator for public-facing software & platform documentation (`docs/`).

## 1. Quick Guard & Off-Switch

Run mechanical health checks via the bundled script:
```bash
bash "${PAGWORKS_SKILL_DIR:-skills/pageworks}/scripts/pageworks" doctor
```

## 2. Operation Routing Matrix

| Operation | User Intent / Trigger | Action & Reference |
|---|---|---|
| `init` | Scaffold fresh docs tree (`--preset platform`) | Load [references/contract.md](references/contract.md) $\to$ run `scripts/pageworks init` |
| `new` | Scaffold new page from 6 Core Classes | Load [references/authoring.md](references/authoring.md) + [references/page-types.md](references/page-types.md) |
| `review` | Quality gate: prose, components, portal UI | Load [references/authoring.md](references/authoring.md) + [references/wiki-patterns.md](references/wiki-patterns.md) |
| `export` | Export to MkDocs, Docusaurus, or Docker | Load [references/renderers.md](references/renderers.md) $\to$ run `scripts/pageworks export` |
| `doctor` | Validate schema, links, depth, frontmatter | Load [references/contract.md](references/contract.md) $\to$ run `scripts/pageworks doctor [--fix]` |
| `status` | Inventory briefing across 6 categories | Load [references/contract.md](references/contract.md) $\to$ report section state |
| `audit` | 180-day stale review & upstream spec drift | Load [references/maintenance.md](references/maintenance.md) $\to$ audit `synced_from:` |

## 3. The Dual-Dimension Architecture

- **6 Page Classes**: `tutorial`, `how-to`, `adr`, `reference`, `service-catalog`, `postmortem` (plus `explanation`).
- **6 Topic Categories**: `getting-started/`, `architecture/`, `services/`, `operations/`, `reference/`, `standards/`.
- **Governance**: Shallow hierarchy ($\le 3$ levels), explicit `owner:`, and 180-day review cycles.

## 4. Report Format

```text
┌─ PAGEWORKS · <operation> · <target>
│ effect    <scaffolded / reviewed / exported files>
│ status    <health summary / doctor verdict>
│ next      <next action or preview command>
└─
```
