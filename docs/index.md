---
title: "Pageworks Documentation"
description: "Single source of truth for Pageworks — architecture, CLI reference, service catalogs, runbooks, and onboarding."
section: ""
type: explanation
status: stable
owner: "@platform-core"
last_reviewed: 2026-08-22
updated: 2026-08-22
---

# Pageworks Documentation

Welcome to the **Pageworks** software and platform documentation. Pageworks is an AI agent skill and CLI tool designed to own a project's public-facing documentation surface (`docs/`) end-to-end: scaffold, schema, authoring, renderer export (MkDocs Material, Docusaurus v3+, Docker), and 180-day stale-page drift maintenance.

## System Overview & Ownership

| Property | Value |
|---|---|
| **Owning Team** | Platform Core (`@platform-core`) |
| **Slack Channel** | `#dev-pageworks` |
| **Source Repository** | [github.com/alexsmedile/pageworks](https://github.com/alexsmedile/pageworks) |
| **Compatible With** | Claude Code, Codex, Antigravity, Spectacular $\ge$ 2.0.0 |
| **License** | MIT |

## System Topology & Architecture

```mermaid
flowchart TD
    subgraph Host["Host Agent / Developer"]
        Agent["AI Coding Agent / User"]
    end

    subgraph PageworksEngine["Pageworks System"]
        Skill["Skill Orchestrator (SKILL.md)"]
        CLI["Pageworks CLI Binary (Bash 4+)"]
        Refs["Progressive References & Templates"]
    end

    subgraph Outputs["Target Outputs"]
        DocsTree["Agnostic docs/ Tree (6 Categories)"]
        MkDocs["MkDocs Material (Python)"]
        Docusaurus["Docusaurus v3+ (React)"]
        Workflows["GitHub Pages CI/CD (.github/workflows/docs.yml)"]
    end

    Agent --> Skill
    Agent --> CLI
    Skill --> Refs
    CLI --> DocsTree
    CLI --> MkDocs
    CLI --> Docusaurus
    CLI --> Workflows
```

## Quick Navigation

### 1. [Getting Started & Onboarding](getting-started/quickstart.md)
Prerequisites, installation commands, and a zero-to-running walkthrough.

### 2. [Architecture & System Design](architecture/overview.md)
System layers, renderer-agnostic contracts, and [ADR 0001: Spectacular v2 Migration](architecture/0001-spectacular-v2-migration.md).

### 3. [Services & Components](services/cli.md)
Catalog one-pagers for the [CLI Tool](services/cli.md) and the [Skill Engine](services/skill-engine.md).

### 4. [Operations & Reliability](operations/export-runbook.md)
Runbooks for [Renderer Exports](operations/export-runbook.md) and [180-Day Drift Audits](operations/maintenance-audit.md).

### 5. [API & Data Reference](reference/cli-reference.md)
Command-line manuals, `docs.yaml` schema specs, and page frontmatter contracts.

### 6. [Standards & Governance](standards/prose-guidelines.md)
Action-oriented writing standards, copy-paste ready code formats, and PR review checklists.
