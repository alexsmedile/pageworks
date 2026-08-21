# Contract — Schema & Information Architecture for Software Documentation

Loaded when the orchestrator handles any `pageworks <verb>` command involving `docs/`, or when `pageworks doctor` runs.

Authoritative schema and structural rules for the `docs/` documentation surface.

---

## The Dual-Dimension Architecture

A production software and platform wiki separates **Page Formats** (functional classes of documents) from **Topic Categories** (the Information Architecture hierarchy).

```
docs/
├── docs.yaml                 # Authoritative manifest (site + 6 categories + extras)
├── index.md                  # "Start Here" landing page (system overview, owners, Mermaid diagram)
├── getting-started/          # Category 1: Onboarding, prerequisites, local dev
│   ├── install.md
│   └── quickstart.md
├── architecture/             # Category 2: Topology, shared infra, ADRs
│   ├── overview.md
│   └── 0001-initial-architecture.md
├── services/                 # Category 3: Service Catalog one-pagers
│   └── auth-service.md
├── operations/               # Category 4: Runbooks, deployment SOPs, postmortems
│   ├── rotate-secrets.md
│   └── 2026-05-auth-outage.md
├── reference/                # Category 5: API contracts, data schemas, CLI flags
│   └── api-v2.md
└── standards/                # Category 6: Coding standards, security, DoD
    └── review-checklist.md
```

### Information Architecture Rules

1. **Maximum 3-Level Depth**: Root (`docs/`) $\to$ Topic Section (`getting-started/`) $\to$ Page (`install.md`). Do not create deeply nested directories. Sub-grouping is managed in `docs.yaml`.
2. **Domain/Workflow Organization**: Organize folders by service, domain, or workflow—never by volatile team hierarchies (teams change; system boundaries rarely do).
3. **Dedicated "Start Here" Landing Pages**: Every root `index.md` must list system purpose, explicit owners (team/channel), Mermaid architecture diagram, repository links, and dev environment prerequisites.

---

## `docs/docs.yaml` Schema

```yaml
site:
  name: <Project Name>           # required
  tagline: ""                    # optional
  base_url: https://example.com  # optional — used by renderer adapters

sections:
  - id: getting-started          # required, kebab-case, matches folder name
    title: Getting Started       # required, display title
    order: 1                     # required, integer
    pages: [install, quickstart] # ordered list of page slugs (without .md)

  - id: architecture
    title: Architecture & System Design
    order: 2
    pages: [overview, 0001-initial-architecture]

  - id: services
    title: Services & Components
    order: 3
    pages: []

  - id: operations
    title: Operations & Reliability
    order: 4
    pages: []

  - id: reference
    title: API & Data Reference
    order: 5
    pages: []

  - id: standards
    title: Standards & Governance
    order: 6
    pages: []

extras:                          # optional top-level entries
  - changelog
```

---

## Page Frontmatter Schema

Every Markdown file in `docs/` must declare structured YAML frontmatter:

```yaml
---
title: "Rotate Database Credentials"
description: "Step-by-step runbook for rotating PostgreSQL database credentials in production."
section: operations
type: runbook
status: stable
owner: "@platform-sre"
last_reviewed: 2026-08-22
updated: 2026-08-22
since: 1.0.0
synced_from: ../../../.spectacular/contracts/CC-cli.md
---
```

### Frontmatter Field Specifications

| Field | Required | Notes |
|---|---|---|
| `title` | yes | Display title; doctor warns if absent and falls back to first H1. |
| `description` | yes | 1–2 sentences; used for navigation previews and search summaries. |
| `section` | yes | Must match a section `id` in `docs.yaml`. `""` for top-level root pages. |
| `type` | yes | One of the 6 Core Classes: `tutorial`, `how-to`, `reference`, `explanation`, `adr`, `service-catalog`, `runbook`, `postmortem`. |
| `status` | yes | `stable`, `draft`, `deprecated`, or `superseded` (for ADRs). |
| `owner` | yes | Owning team, Slack channel, or lead (e.g. `@infra-team`, `#devops`). |
| `last_reviewed`| recommended | ISO date (`YYYY-MM-DD`). Flags 180-day stale review warnings. |
| `updated` | yes | ISO date (`YYYY-MM-DD`). Validated against file filesystem mtime. |
| `since` | no | Version when page was introduced. |
| `synced_from` | no | Relative path to internal spec/anchor for drift tracking. |

---

## Validation & Doctor Rules (`pageworks doctor`)

| Severity | Condition |
|---|---|
| **error** | `docs.yaml` missing or invalid YAML syntax |
| **error** | Declared page in `docs.yaml` missing from filesystem |
| **error** | Page missing required frontmatter (`title`, `description`, `section`, `status`, `updated`) |
| **error** | Broken internal Markdown link (`[text](target.md)` target does not exist) |
| **error** | Folder hierarchy depth exceeds 3 levels |
| **warning** | Missing `owner:` frontmatter field |
| **warning** | Orphan Markdown file (present on disk but omitted from `docs.yaml`) |
| **warning** | Stale content: `last_reviewed:` or `updated:` is older than 180 days |
| **warning** | `updated:` is older than file filesystem mtime by $> 14$ days |
| **warning** | Unknown renderer key in `renderers:` block |
| **info** | Page missing `type:` classification |

### Mechanical Repairs (`pageworks doctor --fix`)

- Injects missing required frontmatter stubs (`status: draft`, `owner: @tbd`, `updated: <TODAY>`, `last_reviewed: <TODAY>`).
- Normalizes duplicate entries in `docs.yaml`.
