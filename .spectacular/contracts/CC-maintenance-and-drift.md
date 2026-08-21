---
type: Contract
id: 01a026aa-936a-7af2-89cd-925245af0754
human_ref: CC-maintenance
title: Maintenance, drift detection, and spec sync contract
status: current
owner: Alex
created: "2026-08-22T00:00:00Z"
updated: "2026-08-22T00:00:00Z"
contract_version: "1"

purpose: Govern the detection of documentation drift against upstream specifications and filesystem timestamps.
outcome: Documentation freshness is systematically tracked and stale pages are highlighted before rotting.

applies_when:
  - Performing documentation audits (`pageworks audit`).
  - Handoff from internal workspace modifications (e.g. updating Spectacular Anchors or Contracts).

does_not_apply_when:
  - Projects without upstream specification tracking (falls back to file mtime comparisons).

required_behavior:
  - Drift engine inspects `synced_from:` target files and compares modification timestamps against the doc page's `updated:` date.
  - Flags five distinct drift classes: stale `updated:`, source-spec drift, broken internal links, broken cross-quadrant navigation, and version drift.
  - Provides clear diagnostic messages and suggested repair actions during audits.
