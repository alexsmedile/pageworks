---
title: "docs.yaml Manifest Schema"
description: "Specification of the docs.yaml configuration file schema."
section: reference
type: reference
status: stable
owner: "@platform-core"
last_reviewed: 2026-08-22
updated: 2026-08-22
---

# `docs.yaml` Manifest Schema

The `docs/docs.yaml` manifest declares documentation metadata and navigation structure.

## Core Schema Fields

| Field | Type | Required | Description |
|---|---|---|---|
| `site.name` | `string` | Yes | Human-readable title of the documentation portal. |
| `site.tagline` | `string` | No | Subtitle or summary description. |
| `site.base_url` | `string` | No | Target base URL (used by renderers for subpath hosting). |
| `sections` | `list` | Yes | Ordered list of topic sections. |
| `sections[].id` | `string` | Yes | Section slug matching directory name under `docs/`. |
| `sections[].title` | `string` | Yes | Display label in navigation sidebar. |
| `sections[].order` | `integer` | Yes | Numeric sort order (ascending). |
| `sections[].pages` | `list[string]` | Yes | List of page slugs without `.md` extension. |
| `extras` | `list[string]` | No | Top-level pages not grouped inside sections. |
| `renderers` | `map` | No | Renderer-specific configuration hints. |
