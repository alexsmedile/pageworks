---
title: "Page Frontmatter Specification"
description: "Specification of YAML frontmatter headers required on all documentation pages."
section: reference
type: reference
status: stable
owner: "@platform-core"
last_reviewed: 2026-08-22
updated: 2026-08-22
---

# Page Frontmatter Specification

Every Markdown page under `docs/` must begin with a YAML frontmatter block enclosed between `---` delimiters. Frontmatter serves as the machine-readable signal layer queried during `pageworks doctor` audits and static site exports.

---

## 1. Required Fields

| Field | Type | Example | Description |
|---|---|---|---|
| `title` | `string` | `"Quickstart Tutorial"` | Page title rendered as the main H1 and navigation item. |
| `description` | `string` | `"A step-by-step onboarding walkthrough."` | 1–2 sentence summary rendered in metadata cards and search snippets. |
| `section` | `string` | `getting-started` | Section ID matching parent directory slug (empty string for `docs/index.md`). |
| `status` | `enum` | `draft \| stable \| deprecated` | Lifecycle status of the page. |
| `updated` | `string` | `YYYY-MM-DD` | ISO date of the last substantial content update. |

---

## 2. Governance & Lifecycle Fields

| Field | Type | Example | Description |
|---|---|---|---|
| `owner` | `string` | `"@platform-core"` | Slack handle, GitHub team, or email responsible for page accuracy. *(Doctor warning if missing).* |
| `last_reviewed` | `string` | `YYYY-MM-DD` | Date of last human or agent review. If older than 180 days, `pageworks doctor` emits a staleness warning. Reset via `pageworks touch <page>`. |
| `type` | `string` | `tutorial` | Functional format class from the extensible taxonomy. *(Doctor info if missing or custom).* |
| `synced_from` | `string` | `"internal/auth/tokens.go"` | Relative path to upstream source file or spec anchor. `pageworks doctor` queries `git log -1` on this file to detect mechanical drift. |
| `since` | `string` | `"v1.2.0"` | Release version when this page or capability was introduced. |

---

## 3. Extensible `type:` Taxonomy

Pageworks accepts an extensible baseline of page classes:

### Core Baseline
`tutorial` · `how-to` · `adr` · `reference` · `service-catalog` · `runbook` · `postmortem` · `explanation`

### Extended Baseline
`migration` · `troubleshooting` · `cookbook` · `design-spec`

### Custom Domain Types
Any custom slug (e.g. `spec`, `rfc`, `benchmark`, `overview`) is accepted cleanly without doctor warnings.

---

## 4. Frontmatter Examples

### Operational Runbook with Drift Tracking
```yaml
---
title: "Rotate Database Credentials"
description: "Zero-downtime procedure for rotating production PostgreSQL access tokens."
section: operations
type: runbook
status: stable
owner: "@infra-oncall"
last_reviewed: 2026-08-22
updated: 2026-08-22
synced_from: "scripts/db/rotate_tokens.sh"
---
```

### Architecture Decision Record (ADR)
```yaml
---
title: "ADR 0002: Adopt Dual-Dimension Wiki Architecture"
description: "Decision to separate documentation functional classes from topic categories."
section: architecture
type: adr
status: stable
owner: "@platform-architecture"
last_reviewed: 2026-08-22
updated: 2026-08-22
---
```
