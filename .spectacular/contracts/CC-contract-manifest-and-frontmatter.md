---
type: Contract
id: 01a026aa-936a-7fae-ac3b-176ce2b203a8
human_ref: CC-contract
title: Manifest and page frontmatter schema contract
status: current
owner: Alex
created: "2026-08-22T00:00:00Z"
updated: "2026-08-22T00:00:00Z"
contract_version: "1"

purpose: Define the canonical data shapes for docs.yaml manifests and Markdown page frontmatter.
outcome: Documentation is structured deterministically with predictable metadata for linters, renderers, and AI agents.

applies_when:
  - Scaffolding a new documentation workspace (`pageworks init`).
  - Authoring new documentation pages or declaring sections.
  - Auditing documentation structure (`pageworks doctor`).

does_not_apply_when:
  - Formatting internal project records in `.spectacular/`.

required_behavior:
  - `docs/docs.yaml` defines `site:` metadata (`name`, `tagline`, optional `base_url`), `sections:` list (`id`, `title`, `order`, `pages`), optional `extras:`, and optional `renderers:` map.
  - Every page Markdown file declares mandatory YAML frontmatter: `title`, `description`, `section`, `type` (one of `tutorial`, `how-to`, `reference`, `explanation`), `status`, `updated`.
  - Pages linked to external/internal specifications declare `synced_from: <path>`.
