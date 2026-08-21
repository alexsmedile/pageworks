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

Every Markdown page under `docs/` must begin with a YAML frontmatter block enclosed between `---` delimiters.

## Required Fields

| Field | Type | Example | Description |
|---|---|---|---|
| `title` | `string` | `"Quickstart"` | Page title rendered in header and navigation. |
| `description` | `string` | `"A guided walk."` | Concise summary rendered in metadata descriptions. |
| `section` | `string` | `getting-started` | Section ID matching parent folder (or empty for index). |
| `status` | `enum` | `draft \| stable \| deprecated` | Document lifecycle status. |
| `updated` | `string` | `YYYY-MM-DD` | Date of last substantial edit. |

## Governance & Recommended Fields

| Field | Type | Example | Description |
|---|---|---|---|
| `owner` | `string` | `"@platform-core"` | Team or person responsible for document accuracy. |
| `last_reviewed` | `string` | `YYYY-MM-DD` | Date when document accuracy was last verified (180-day cycle). |
| `type` | `enum` | `tutorial \| how-to \| adr \| reference \| service-catalog \| postmortem \| explanation` | Functional format class. |
| `synced_from` | `string` | `".spectacular/contracts/CC-cli.md"` | Upstream spec anchor used for automated drift detection. |
