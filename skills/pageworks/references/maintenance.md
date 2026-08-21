# Maintenance — Drift Detection, Stale Auditing, and Spec Sync

Use this when: Auditing 180-day stale pages, checking link health, discovering wiki rot, or reconciling docs after a spec or capability change.

---

## What Drift & Wiki Rot Look Like

Drift happens in six recognizable shapes:

| Drift Type | Signal | Severity |
|---|---|---|
| **Stale Content (180-day rule)** | Page `last_reviewed:` or `updated:` is older than 180 days (6 months) | warning |
| **Missing Ownership** | Page has no `owner:` declared in frontmatter | warning |
| **Source-Spec Drift** | Page declares `synced_from:` and the source file's mtime > page `updated:` | warning |
| **Broken Internal Link** | Target link destination does not exist on disk | error |
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

1. Spectacular Core Anchors: `PROJECT.md`, `STACK.md`, `ARCHITECTURE.md`
2. Spectacular Capability Contracts: `.spectacular/contracts/CC-*.md`
3. OpenAPI / JSON Schemas: `schemas/*.json`, `openapi.yaml`
4. CLI Help Outputs: Derived via tool introspection

---

## Maintenance Flow in Agent Sessions

```
Spec Change in Project
  └─► Agent triggers Spectacular or manual edit
        └─► Session prompts: "Reconcile public docs?"
              └─► Load `references/maintenance.md`
                    └─► Run `scripts/pageworks doctor`
                          └─► Update drifted pages
                                └─► Bump `updated:` & `last_reviewed:`
```
