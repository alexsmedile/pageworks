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

The `docs/docs.yaml` manifest is the authoritative declaration of documentation metadata, navigation order, and static site generator configurations.

---

## 1. Top-Level Schema Fields

| Field | Type | Required | Description |
|---|---|---|---|
| `site.name` | `string` | Yes | Human-readable title of the documentation portal. |
| `site.tagline` | `string` | No | Subtitle or elevator pitch. |
| `site.base_url` | `string` | No | Production URL used by SSGs for subpath routing (e.g. `https://org.github.io/repo/`). |
| `sections` | `list` | Yes | Ordered list of topic categories and page members. |
| `sections[].id` | `string` | Yes | Section directory slug under `docs/` (e.g. `getting-started`). |
| `sections[].title` | `string` | Yes | Display title in navigation headers and sidebars. |
| `sections[].order` | `integer` | Yes | Ascending sort index. |
| `sections[].pages` | `list[string]` | Yes | List of page file slugs without the `.md` extension. |
| `extras` | `list[string]` | No | Standalone pages outside section directories (e.g. `faq`). |
| `renderers` | `map` | No | SSG adapter configuration blocks for MkDocs, Docusaurus, and Mintlify. |

---

## 2. Renderer Adapter Blocks (`renderers:`)

The optional `renderers:` map supplies generator-specific metadata to avoid maintaining separate toolchain configs by hand:

### `renderers.mkdocs` (MkDocs Material Theme)

| Property | Type | Default | Description |
|---|---|---|---|
| `theme` | `string` | `material` | MkDocs theme name (`material`). |
| `primary` | `string` | `indigo` | Material color palette primary hue (e.g. `indigo`, `slate`, `teal`, `cyan`). |
| `scheme` | `string` | `default` | Color scheme mode (`default` light, `slate` dark). |
| `repo_url` | `string` | `site.base_url` | GitHub repository link for topbar badge and edit links. |
| `edit_uri` | `string` | `edit/main/docs/` | Relative path for "Edit this page" links. |

### `renderers.docusaurus` (Docusaurus v3+)

| Property | Type | Default | Description |
|---|---|---|---|
| `preset` | `string` | `classic` | Docusaurus preset (default: `@docusaurus/preset-classic`). |
| `organizationName` | `string` | Auto-derived | GitHub organization or username owning the repository. |
| `projectName` | `string` | Auto-derived | GitHub repository name. |
| `repo_url` | `string` | `site.base_url` | GitHub repository URL auto-wired into the navbar header. |

### `renderers.mintlify` (Mintlify Cloud / CLI)

| Property | Type | Default | Description |
|---|---|---|---|
| `primary` | `string` | `#4F46E5` | Primary hex brand color for navigation anchors and buttons. |
| `light` | `string` | `#6366F1` | Accent color for light mode gradients. |
| `dark` | `string` | `#4338CA` | Accent color for dark mode UI elements. |
| `repo_url` | `string` | `site.base_url` | GitHub repository URL wired into the topbar and footer socials. |

---

## 3. Complete `docs.yaml` Example

```yaml
site:
  name: Platform Docs
  tagline: "Developer documentation for APIs, architecture, and operations"
  base_url: https://acme.github.io/platform/

sections:
  - id: getting-started
    title: Getting Started & Onboarding
    order: 1
    pages: [install, quickstart, concepts]

  - id: architecture
    title: Architecture & System Design
    order: 2
    pages: [overview, 0001-spectacular-v2-migration]

  - id: services
    title: Services & Components
    order: 3
    pages: [cli, skill-engine]

  - id: operations
    title: Operations & Reliability
    order: 4
    pages: [export-runbook, maintenance-audit]

  - id: reference
    title: API & Data Reference
    order: 5
    pages: [cli-reference, manifest-schema, frontmatter-spec]

  - id: standards
    title: Standards & Governance
    order: 6
    pages: [prose-guidelines, review-checklist]

renderers:
  mkdocs:
    theme: material
    primary: indigo
    scheme: slate
    repo_url: https://github.com/acme/platform
    edit_uri: edit/main/docs/
  docusaurus:
    preset: classic
    organizationName: acme
    projectName: platform
    repo_url: https://github.com/acme/platform
  mintlify:
    primary: "#0D9373"
    light: "#07C98B"
    dark: "#0D9373"
    repo_url: https://github.com/acme/platform
```
