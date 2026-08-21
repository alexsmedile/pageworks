---
type: Proposal
id: 01a026aa-936a-75c0-bb67-a6ab40e48f8d
human_ref: P1
title: Tier-4 docs authoring and review subagents
status: draft
created_by: Alex
created: "2026-08-22T00:00:00Z"
updated: "2026-08-22T00:00:00Z"
scope:
  - skills/pageworks
target_contract: Contract:01a026aa-936a-7fae-ac3b-176ce2b203a8
---

# Tier-4 docs authoring and review subagents

## Overview
Add specialized subagents that Pageworks spawns when authoring work exceeds what a single agent context should hold: writing across multiple pages, reviewing for cross-page consistency, or planning documentation structure from scratch.

## Key Concepts
- **`docs-writer`**: Authors one page at a time with isolated template and prose-pattern context.
- **`docs-reviewer`**: Fresh-stance evaluation of pages against Diátaxis quadrants and prose patterns without rewriting.
- **`docs-architect`**: Structure planning for sections, splitting, and merging in `docs.yaml`.

## Activation Triggers (2-of-3)
1. 3+ multi-page authoring sessions where context bloat becomes noticeable.
2. 2+ review cycles where self-review shows clear blind spots compared to a fresh-context pass.
3. Contributor demand for delegated review pipelines.
