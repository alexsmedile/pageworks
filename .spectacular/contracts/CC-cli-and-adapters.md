---
type: Contract
id: 01a026aa-936a-7fa4-b79e-d399ce47a476
human_ref: CC-cli
title: CLI verbs and renderer adapters contract
status: current
owner: Alex
created: "2026-08-22T00:00:00Z"
updated: "2026-08-22T00:00:00Z"
contract_version: "1"

purpose: Govern deterministic mechanical commands for scaffolding, compiling renderer configs, and validating docs trees.
outcome: Reliable CLI operations that transform agnostic markdown workspaces into deployed documentation sites.

applies_when:
  - Running `pageworks init`, `pageworks export <renderer>`, or `pageworks doctor`.
  - Adding or maintaining renderer adapters (MkDocs, Docusaurus).

does_not_apply_when:
  - Subjective prose evaluation or content authoring (handled by agent skill verbs).

required_behavior:
  - `pageworks init` creates standard `docs/` folder layout and initial template pages non-destructively.
  - `pageworks export` transforms `docs.yaml` navigation and metadata into renderer-specific configuration files (`mkdocs.yml` or `docusaurus.config.js` / `sidebars.js`) and generates GitHub Actions deploy workflows.
  - Pinning header comments (`# pageworks: do-not-overwrite`) are preserved across exports even with `--force`.
  - `pageworks doctor` verifies existence, schema correctness, missing/orphan pages, frontmatter completeness, and renderer configuration validity.
