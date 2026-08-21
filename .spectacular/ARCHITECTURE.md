---
type: Anchor
id: 01a026aa-936a-7e22-a2b1-e63afe4c956c
human_ref: ARCHITECTURE
title: Architecture
direction: Four-tier system delivering renderer-agnostic public documentation management.
boundaries:
  - `docs/` is the sole managed folder; pageworks never writes outside `docs/` or generated renderer artifacts.
  - Internal workspace docs (PRDs, plans, ADRs) belong to `.spectacular/` and are never mixed into `docs/`.
  - Skill layer is a lean orchestrator with progressive reference disclosure; CLI layer provides repeatable deterministic mechanics.
constraints:
  - Frontmatter is the primary signal layer for audits and briefings.
  - Diátaxis is the strict taxonomy for all page types.
freshness_checked_at: "2026-08-22T00:00:00Z"
freshness_source: .spectacular/workspace.yaml
freshness_valid_until: "2027-08-22T00:00:00Z"
---
# Architecture

Pageworks operates across four distinct distribution layers with a strict separation between public documentation and internal operational artifacts.

## System Layers

1. **Convention Layer**
   - Single authoritative manifest: `docs/docs.yaml`.
   - Section hierarchy and flat Markdown pages.
   - Diátaxis page classification: Tutorial, How-to, Reference, Explanation.
   - Standard frontmatter metadata (`title`, `description`, `section`, `type`, `status`, `updated`, `synced_from`).

2. **Skill Layer**
   - Lean orchestrator pattern (`skills/pageworks/SKILL.md`).
   - On-demand reference loading table (`contract.md`, `authoring.md`, `page-types.md`, `prose-patterns.md`, `renderers.md`, `maintenance.md`).
   - Interactive agent verbs: `new`, `review`, `status`, `audit`.

3. **CLI Layer**
   - Native shell executable (`cli/pageworks`).
   - Verbs: `init` (scaffold), `export` (renderer config generation), `doctor` (validation & linting).

4. **Plugin Layer**
   - Claude Code (`.claude-plugin/plugin.json`) and Codex (`.codex-plugin/plugin.json`) distribution packaging.

## Pairing Model

- **Internal vs. External Workspace**: Spectacular owns `.spectacular/`; Pageworks owns `docs/`.
- **Handoff Contract**: Archiving internal changes or amending capability contracts in Spectacular prompts the user to invoke `pageworks audit` to reconcile public documentation pages.
