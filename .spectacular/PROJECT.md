---
type: Anchor
id: 01a026aa-9369-7284-92b3-efba93b781d0
human_ref: PROJECT
title: Pageworks
direction: Write docs that don't rot — public-facing documentation skill and CLI.
boundaries:
  - `docs/` is the sole public documentation surface.
  - Internal workspace artifacts stay in `.spectacular/` and are not mixed with public docs.
  - Pageworks is standalone-capable and works with or without Spectacular.
constraints:
  - UTF-8 Markdown with YAML frontmatter.
  - Renderer-agnostic canonical representation with `docs.yaml` manifest.
current_truth:
  - Anchor:01a026aa-936a-7b53-aa2a-79e48a0636b1
  - Anchor:01a026aa-936a-7e22-a2b1-e63afe4c956c
  - Contract:01a026aa-936a-7fae-ac3b-176ce2b203a8
  - Contract:01a026aa-936a-7fa4-b79e-d399ce47a476
  - Contract:01a026aa-936a-7af2-89cd-925245af0754
freshness_checked_at: "2026-08-22T00:00:00Z"
freshness_source: .spectacular/workspace.yaml
freshness_valid_until: "2027-08-22T00:00:00Z"
---
# Pageworks

Pageworks owns the public-facing documentation surface (`docs/`) of a project: scaffold, schema, page authoring, renderer export (MkDocs Material and Docusaurus), and drift maintenance as internal specs change.

## Active Campaign

```mermaid
flowchart LR
    B1["Block 1: Tier-4 Docs Agents\n(PLANNED -> P1)"] --> B2["Block 2: Dogfood Public Docs\n(PLANNED -> P2)"]
    B2 --> B3["Block 3: Maintenance & Drift v2\n(PLANNED -> P3)"]
    B3 --> B4["Block 4: Community Renderers\n(PLANNED -> P4)"]
```

### Campaign Blocks

1. **Block 1: Tier-4 Docs Agents (`P1`)**
   - **Capability Unlocked**: Pageworks can spawn focused `docs-writer` and `docs-reviewer` subagents to draft and review multi-page documentation batches.
   - **Prerequisites**: None.
   - **Status**: PLANNED (`.spectacular/proposals/P1-pageworks-agents.md`).

2. **Block 2: Dogfood Public Docs (`P2`)**
   - **Capability Unlocked**: Canonical public documentation site for Pageworks published to GitHub Pages using its own CLI export.
   - **Prerequisites**: Block 1.
   - **Status**: PLANNED (`.spectacular/proposals/P2-public-docs-dogfood.md`).

3. **Block 3: Maintenance & Drift v2 (`P3`)**
   - **Capability Unlocked**: `sync-ack` verb, multi-source `synced_from:`, screenshot freshness tracking, and content-hash drift detection.
   - **Prerequisites**: Block 2.
   - **Status**: PLANNED (`.spectacular/proposals/P3-pageworks-maintenance-v2.md`).

4. **Block 4: Community Renderers (`P4`)**
   - **Capability Unlocked**: Native adapters for Mintlify, Fumadocs, and additional site generators.
   - **Prerequisites**: Block 3.
   - **Status**: PLANNED (`.spectacular/proposals/P4-pageworks-renderers-more.md`).
