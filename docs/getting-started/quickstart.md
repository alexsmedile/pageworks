---
title: "Quickstart Tutorial"
description: "Scaffold, validate, and export a complete documentation site in four steps."
section: getting-started
type: tutorial
status: stable
owner: "@platform-core"
last_reviewed: 2026-08-22
updated: 2026-08-22
---

# Quickstart Tutorial

In this tutorial, you will scaffold a documentation tree, validate its health, and export a deployment-ready static site.

## Step 1 — Scaffold the Documentation Tree

Run `pageworks init` with the `--preset platform` option in your project directory:

```bash
pageworks init --preset platform
```

```
pageworks init

  ✓  docs/
  ✓  docs/docs.yaml
  ✓  docs/index.md
  ✓  docs/getting-started/
  ✓  docs/architecture/
  ✓  docs/services/
  ✓  docs/operations/
  ✓  docs/reference/
  ✓  docs/standards/
```

## Step 2 — Run the Quality Doctor

Validate your documentation schema, frontmatter metadata, and links:

```bash
pageworks doctor
```

```
pageworks doctor

  ✅ docs/docs.yaml — docs.yaml present
  ✅ docs/index.md — declared page present
  ✅ docs/getting-started/install.md — declared page present

0 error(s), 0 warning(s), 0 info
```

## Step 3 — Export to Static Site Generator

Generate configuration files and GitHub Pages deployment workflows for MkDocs Material:

```bash
pageworks export mkdocs
```

```
pageworks export → mkdocs

Generated:
  ✓  ./mkdocs.yml
  ✓  ./.github/workflows/docs.yml
```

## Step 4 — Preview Locally

Install `mkdocs-material` and launch the local live-reload server:

```bash
pip install mkdocs-material
mkdocs serve
```

Open [http://127.0.0.1:8000](http://127.0.0.1:8000) in your browser to view your live site.

## Next

- [Core Concepts](concepts.md) — The Dual-Dimension software wiki architecture.
- [CLI Reference](../reference/cli-reference.md) — Explore all commands and flags.
