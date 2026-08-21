---
title: "CLI Binary — Service Catalog"
description: "Service catalog entry for the pageworks CLI utility."
section: services
type: service-catalog
status: stable
owner: "@platform-core"
last_reviewed: 2026-08-22
updated: 2026-08-22
tier: "Tier 1 (Core Tooling)"
---

# Pageworks CLI

The `pageworks` CLI is a zero-dependency Bash executable handling mechanical documentation workflows: scaffolding, validation, and static site export.

## Properties & Ownership

| Property | Value |
|---|---|
| **Owning Team** | `@platform-core` |
| **Source Path** | [`cli/pageworks`](https://github.com/alexsmedile/pageworks/blob/main/cli/pageworks) |
| **Dependencies** | `bash 4+`, `awk`, `sed`, `grep`, `curl` |
| **Primary Verbs** | `init`, `export`, `doctor` |

## Key Commands

```bash
pageworks init --preset platform
pageworks doctor
pageworks export mkdocs
```
