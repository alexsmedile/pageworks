---
title: "Architecture Overview"
description: "High-level architecture of Pageworks: four layers, progressive reference disclosure, and adapter model."
section: architecture
type: explanation
status: stable
owner: "@platform-core"
last_reviewed: 2026-08-22
updated: 2026-08-22
---

# Architecture Overview

Pageworks operates across four distinct distribution layers designed for zero runtime overhead in production.

## System Layers

1. **Convention Layer**: `docs/docs.yaml` manifest, 6 topic categories, and YAML frontmatter contracts.
2. **Skill Layer**: Lean orchestrator (`SKILL.md`) that loads targeted Markdown references on demand.
3. **CLI Layer**: Self-contained Bash 4+ binary (`cli/pageworks`) using zero-dependency stream parsing (`awk`, `sed`).
4. **Plugin Layer**: Manifest packages for Claude Code and Codex marketplaces.

## Renderer Adapter Model

Pageworks treats documentation as pure Markdown data. Adapters transform `docs.yaml` navigation and site metadata into vendor-specific configuration files:
- **MkDocs Adapter**: Writes `mkdocs.yml` with Material theme palette toggles and Mermaid superfences.
- **Docusaurus Adapter**: Writes `docusaurus.config.js`, `sidebars.js`, and `package.json`.
- **Deployment Workflows**: Emits `.github/workflows/docs.yml` for automated CI/CD static asset hosting.
