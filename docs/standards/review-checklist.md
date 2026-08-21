---
title: "Documentation Review Checklist"
description: "Pre-publication quality gate checklist for documentation PRs."
section: standards
type: reference
status: stable
owner: "@platform-core"
last_reviewed: 2026-08-22
updated: 2026-08-22
---

# Documentation Review Checklist

Before merging documentation changes, verify each requirement:

## 1. Structure & Classification
- [ ] Document fulfills a single class format (`tutorial`, `how-to`, `adr`, `reference`, `service-catalog`, `postmortem`, or `explanation`).
- [ ] Stored in an appropriate section under `docs/` (maximum nesting depth $\le 3$).
- [ ] Declared in `docs/docs.yaml`.

## 2. Frontmatter Contract
- [ ] `title`, `description`, `section`, `status`, and `updated` present and non-empty.
- [ ] `owner:` tag declared (e.g. `@platform-core`).
- [ ] `last_reviewed:` timestamp up to date.

## 3. Prose & Syntax
- [ ] Headings are imperative and action-oriented for procedural content.
- [ ] Code examples are tested and copy-paste ready (no leading `$` in copyable blocks).
- [ ] All internal markdown links resolve to existing files.

## 4. Mechanical Validation
- [ ] `pageworks doctor` passes with 0 errors and 0 warnings.
