---
title: "Runbook: Exporting & Deploying Documentation"
description: "Operational runbook for generating renderer configurations and deploying to GitHub Pages."
section: operations
type: runbook
status: stable
owner: "@platform-core"
last_reviewed: 2026-08-22
updated: 2026-08-22
---

# Runbook: Exporting & Deploying Documentation

## Trigger

Executed when shipping documentation updates to a public or internal static site.

## Procedure

### Step 1 — Validate Documentation Health
```bash
pageworks doctor
```
If errors occur, resolve them or run `pageworks doctor --fix`.

### Step 2 — Export Renderer Config
For MkDocs Material:
```bash
pageworks export mkdocs --force
```

For Docusaurus v3+:
```bash
pageworks export docusaurus --force
```

### Step 3 — Commit and Push
```bash
git add docs/ mkdocs.yml .github/workflows/docs.yml
git commit -m "docs: export site configuration"
git push origin main
```

### Step 4 — Verify GitHub Pages Deployment
Check the GitHub Actions tab for successful completion of the `Deploy docs` workflow.
