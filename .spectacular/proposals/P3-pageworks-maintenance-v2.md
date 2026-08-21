---
type: Proposal
id: 01a026aa-936a-7bb5-870f-8c7ff3f99986
human_ref: P3
title: Drift detection v2 and sync acknowledgement
status: draft
created_by: Alex
created: "2026-08-22T00:00:00Z"
updated: "2026-08-22T00:00:00Z"
scope:
  - cli
  - skills/pageworks
target_contract: Contract:01a026aa-936a-7af2-89cd-925245af0754
---

# Drift detection v2 and sync acknowledgement

## Overview
Expand Pageworks drift detection and maintenance capabilities to handle multi-source tracking, acknowledgment verbs, screenshot freshness, and content hashing.

## Key Capabilities
- `pageworks sync-ack <page>`: Updates `updated:` date without altering content to silence verified false positives.
- Multi-source `synced_from:` arrays (`synced_from: [path1, path2]`).
- Screenshot freshness checks comparing image asset modification times against doc updates.
- Content hash tracking to avoid spurious drift alerts when upstream changes are purely formatting.
