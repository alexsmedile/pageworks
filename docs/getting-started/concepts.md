---
title: "Core Concepts"
description: "Understand the Dual-Dimension software wiki architecture and the Docs-as-Code philosophy."
section: getting-started
type: explanation
status: stable
owner: "@platform-core"
last_reviewed: 2026-08-22
updated: 2026-08-22
---

# Core Concepts

Pageworks bridges developer workflows and knowledge management by structuring documentation along two independent axes.

## 1. Classes of Pages (Functional Format)

Every document in a software wiki serves a single clear purpose:
- **Tutorials**: Step-by-step onboarding lessons for beginners.
- **How-To Guides & Runbooks**: Goal-oriented recipes for operational tasks.
- **Architecture Decision Records (ADRs)**: Immutable choice and trade-off logs.
- **Technical Reference Specs**: Pure factual API contracts, schemas, and CLI manuals.
- **Service Catalog One-Pagers**: Ownership, repositories, SLOs, and health checks.
- **Incident Postmortems**: Production outage retrospectives (5 Whys).

## 2. Topic Categories (Information Architecture)

The sidebar and filesystem navigation are grouped into 6 predictable buckets:
1. `getting-started/` — Onboarding and prerequisites.
2. `architecture/` — System design and ADRs.
3. `services/` — Microservice catalog and dependencies.
4. `operations/` — Reliability, runbooks, and postmortems.
5. `reference/` — API, schemas, and CLI manuals.
6. `standards/` — Coding guidelines and PR checklists.

## 3. The Docs-as-Code Model

All documentation is stored as portable Markdown in Git alongside application code. Pageworks generates renderer configs (MkDocs, Docusaurus) without coupling your source content to any single framework.
