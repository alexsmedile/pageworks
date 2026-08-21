---
title: "ADR 0001: Migration to Spectacular v2"
description: "Architecture decision to adopt Spectacular v2 Core Anchors, capability contracts, and proposal lifecycle."
section: architecture
type: adr
status: accepted
owner: "@platform-core"
last_reviewed: 2026-08-22
updated: 2026-08-22
---

# ADR 0001: Migration to Spectacular v2

## Context & Problem Statement

Pageworks previously paired with Spectacular v1 (using `.spectacular/config.yaml`, `PRD.md`, `SPEC.md`, and `requests/`). With the release of Spectacular v2.5.0, internal project truth is governed through Core Triad Anchors (`PROJECT.md`, `STACK.md`, `ARCHITECTURE.md`), modular Capability Contracts, and immutable Mission envelopes.

## Decision Outcome

**Chosen Option**: Upgrade Pageworks to fully adopt the Spectacular v2 workspace layout.

### Positive Consequences
- Clean separation between internal operational truth (`.spectacular/`) and external public docs (`docs/`).
- Seamless capability contract drift tracking via `synced_from:`.
- Zero deprecated v1 configuration residue in the codebase.
