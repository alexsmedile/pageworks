# Maintenance — Drift Detection, Stale Auditing, and Spec Sync

Loaded when:
- `pageworks audit` runs
- `pageworks doctor` performs freshness, ownership, and link validation
- Skill is invoked after a spec or capability change in a project
- User asks "what docs are stale?" or "what needs updating?"

---

## What Drift & Wiki Rot Look Like

Drift happens in six recognizable shapes:

| Drift Type | Signal | Severity |
|---|---|---|
| **Stale Content (180-day rule)** | Page `last_reviewed:` or `updated:` is older than 180 days (6 months) | warning |
| **Missing Ownership** | Page has no `owner:` declared in frontmatter | warning |
| **Source-Spec Drift** | Page declares `synced_from:` and the source file's mtime > page `updated:` | warning |
| **Broken Internal Link** | `[text](target.md)` target does not exist | error |
| **Filesystem Drift** | Page `updated:` is older than file filesystem mtime by > 14 days | warning |
| **Version Drift** | Page `since:` references a version not found in CHANGELOG | warning |

---

## 180-Day (6-Month) Stale Content Audit

Documentation rots when no human or team feels responsible for its accuracy. 

- **The 180-Day Trigger**: Any page with `updated:` or `last_reviewed:` older than 180 days is flagged with a warning by `pageworks doctor` and `pageworks audit`.
- **Remediation**:
  1. The page owner inspects the documentation against current software behavior.
  2. If the page is accurate without code changes, bump `last_reviewed: <TODAY>` or run `pageworks sync-ack <page>`.
  3. If the page has drifted, update the content and set `updated: <TODAY>` and `last_reviewed: <TODAY>`.
  4. If the page is obsolete, set `status: deprecated` or archive it.

---

## The `synced_from:` Pattern

When a public doc page derives from an internal contract or spec (e.g. `.spectacular/contracts/CC-*.md` or `STACK.md`), declare the source in frontmatter:

```yaml
---
title: "CLI Commands Reference"
description: "Reference manual for all pageworks CLI verbs."
section: reference
type: reference
status: stable
owner: "@platform-cli"
last_reviewed: 2026-08-22
updated: 2026-08-22
synced_from: ../../../.spectacular/contracts/CC-cli.md
---
```

Pageworks compares the doc page's `updated:` field against the source file's filesystem mtime. If the source is newer, the page is flagged as drifted.

### Recognized Spec Sources

| Source | Convention | Typical Use |
|---|---|---|
| `.spectacular/PROJECT.md` | spectacular v2 | Root scope — onboarding and system overview |
| `.spectacular/STACK.md` | spectacular v2 | Tech stack and tooling — install / prerequisites |
| `.spectacular/ARCHITECTURE.md` | spectacular v2 | Component boundaries — architecture explanations |
| `.spectacular/contracts/CC-<x>.md` | spectacular v2 | Capability contracts — API / CLI references & guides |
| `.spectacular/decisions/<x>.md` | spectacular v2 | Architecture Decision Records (ADRs) |
| `.specs/<x>.md` / `SPECS.md` | generic repo | Standalone project specifications |
| `README.md` | universal | Root repository documentation |

---

## Audit Checklist (`pageworks audit` + `pageworks doctor`)

1. **Frontmatter Audit**:
   - Required fields: `title`, `description`, `section`, `status`, `updated`, `owner`.
   - Valid `type:` from 6 Core Classes (`tutorial`, `how-to`, `reference`, `explanation`, `adr`, `service-catalog`, `runbook`, `postmortem`).
   - Valid dates (`YYYY-MM-DD`).
2. **Freshness & Stale Audit**:
   - `last_reviewed:` / `updated:` $\le 180$ days old.
   - `updated:` $\ge$ file filesystem mtime (within 14 days).
   - `synced_from:` target file exists and is not newer than `updated:`.
3. **Information Architecture & Hierarchy**:
   - Maximum 3 levels deep in filesystem.
   - `docs/index.md` exists and includes system overview and ownership.
   - All disk files mapped in `docs.yaml` (zero orphan files).
4. **Link Integrity**:
   - All internal Markdown links resolve to real files on disk.
