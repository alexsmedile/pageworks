---
title: "Runbook: 180-Day Stale Content Auditing"
description: "Operational procedure for discovering, reviewing, and acknowledging stale documentation pages."
section: operations
type: runbook
status: stable
owner: "@platform-core"
last_reviewed: 2026-08-22
updated: 2026-08-22
---

# Runbook: 180-Day Stale Content Auditing

## Trigger

Executed on a bi-annual schedule (every 180 days) or when `pageworks doctor` emits stale page warnings.

## Procedure

### Step 1 — Run Doctor / Audit
```bash
pageworks doctor
```
Look for warnings:
```
⚠️  docs/services/legacy-auth.md — content has not been reviewed in > 180 days (210 days old — stale)
```

### Step 2 — Review Document Accuracy
1. Open the page and inspect code snippets, endpoints, and architectural assertions.
2. Test commands against current code.
3. If valid, update `last_reviewed: <TODAY>` in frontmatter.
4. If outdated, update prose and examples before bumping the date.

### Step 3 — Re-run Doctor
```bash
pageworks doctor
```
Confirm 0 warnings and 0 errors.
