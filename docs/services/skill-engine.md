---
title: "Skill Engine — Service Catalog"
description: "Service catalog entry for the Pageworks agent skill engine."
section: services
type: service-catalog
status: stable
owner: "@platform-core"
last_reviewed: 2026-08-22
updated: 2026-08-22
tier: "Tier 1 (Core Agent Skill)"
---

# Pageworks Skill Engine

The Pageworks skill engine enables AI coding assistants (Claude Code, Codex, Antigravity) to reason about document lifecycle, prose quality, and drift maintenance.

## Properties & Ownership

| Property | Value |
|---|---|
| **Owning Team** | `@platform-core` |
| **Manifest Path** | [`skills/pageworks/SKILL.md`](https://github.com/alexsmedile/pageworks/blob/main/skills/pageworks/SKILL.md) |
| **Skill Verbs** | `new`, `review`, `status`, `audit`, `touch`, `theme` |
| **Progressive References** | `authoring.md`, `contract.md`, `maintenance.md`, `page-types.md`, `prose-patterns.md`, `quality-gates.md`, `designer-mode.md`, `renderers.md` |

## Skill Workflows

- **`pageworks new <page>`**: Interactively selects format and section, then instantiates the right template with safety diff confirmation.
- **`pageworks review <page>`**: Micro-audits document prose, voice, imperative headings, and copy-paste readiness.
- **`pageworks audit`**: Macro-scans the repository for 180-day stale pages and upstream git drift on `synced_from:` targets.
- **`pageworks status`**: Generates high-level visibility table across documentation categories, drafts, and ownership.
