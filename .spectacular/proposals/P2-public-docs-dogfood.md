---
type: Proposal
id: 01a026aa-936a-76dc-81d4-a006878e40b8
human_ref: P2
title: Dogfood Pageworks on its own documentation
status: draft
created_by: Alex
created: "2026-08-22T00:00:00Z"
updated: "2026-08-22T00:00:00Z"
scope:
  - docs
target_contract: Contract:01a026aa-936a-7fa4-b79e-d399ce47a476
---

# Dogfood Pageworks on its own documentation

## Overview
Author canonical public documentation for Pageworks in `docs/` using Pageworks itself, and deploy it to GitHub Pages via MkDocs Material and GitHub Actions.

## Key Deliverables
- Scaffolded `docs/` tree in the repository:
  - Getting Started: Install, Quickstart, Concepts.
  - Guides: Scaffolding a site, Authoring Diátaxis pages, Exporting renderers, Auditing drift.
  - Reference: CLI commands, `docs.yaml` schema, Frontmatter specification, Renderer mapping.
  - Explanation: Why Diátaxis, Why Agnostic Markdown, Pairing with Spectacular.
- GitHub Actions workflow deploying to GitHub Pages on pushes to `main`.
