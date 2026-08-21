---
title: "CLI Command Reference"
description: "Detailed parameter specifications and exit codes for all pageworks CLI commands."
section: reference
type: reference
status: stable
owner: "@platform-core"
last_reviewed: 2026-08-22
updated: 2026-08-22
---

# CLI Command Reference

## `pageworks init`

Scaffolds a documentation tree in `docs/`.

### Options
- `--preset <default|platform|minimal>`: Chooses section preset. `platform` scaffolds the 6 main topic categories.
- `--platform`: Alias for `--preset platform`.
- `--minimal`: Scaffolds `docs.yaml` and `index.md` only.
- `--name <slug>`: Overrides project name in manifest.

---

## `pageworks export <mkdocs|docusaurus>`

Generates renderer-specific configuration files and CI/CD deployment workflows.

### Options
- `--out <path>`: Output destination directory (default: `.`).
- `--force`: Overwrites existing configuration files (unless pinned with `do-not-overwrite`).
- `--no-workflow`: Skips generating `.github/workflows/docs.yml`.

---

## `pageworks doctor`

Validates schema, frontmatter fields, orphan pages, 180-day staleness, broken markdown links, and folder nesting depth.

### Options
- `--fix`: Automatically repairs common frontmatter omissions.
