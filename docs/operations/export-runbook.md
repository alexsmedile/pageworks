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

Select the renderer tailored to your team's architecture and performance needs:

- **Docusaurus v3+** (React/MDX components, native multi-versioning, SPA fluid feel):
  ```bash
  pageworks export docusaurus --force
  ```
- **MkDocs Material** (zero JS overhead, 100/100 Lighthouse, instant search, <20s CI):
  ```bash
  pageworks export mkdocs --force
  ```
- **Mintlify** (Stripe-tier aesthetics, managed edge hosting, interactive API playground):
  ```bash
  pageworks export mintlify --force
  ```

### Step 3 — Commit and Push
```bash
git add docs/ mkdocs.yml docusaurus.config.js sidebars.js mint.json .github/workflows/docs*.yml
git commit -m "docs: export site configuration"
git push origin main
```

### Step 4 — Verify Deployment
Check the GitHub Actions tab for successful completion of the deployment or link verification workflow.

