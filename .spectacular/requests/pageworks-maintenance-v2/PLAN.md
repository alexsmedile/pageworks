---
status: planned
priority: low
owner: alex
updated: 2026-05-23
target_version: pageworks v0.4.0
summary: "Drift detection improvements — `pageworks sync-ack` verb, multi-source synced_from, screenshot freshness, mtime-vs-content awareness"
related:
  - ../../../skills/pageworks/references/maintenance.md
  - ../../../skills/pageworks/references/contract.md
---

# Plan — pageworks maintenance v2

## Goal

Harden the drift-detection patterns sketched in `references/maintenance.md` (v0.1.0). Ship a real `pageworks sync-ack` verb, support multi-source `synced_from:` arrays, add screenshot freshness checks, and refine the mtime-vs-content drift signal to reduce false positives.

## Why

v0.1.0's `maintenance.md` documents the drift-detection patterns but only the basic mtime-based check is wired into `pageworks doctor`. Real usage will surface:

- **False positives** when a spec edits whitespace or moves a paragraph (mtime changed, semantically unchanged) — needs content-hash awareness or user override.
- **Multi-source pages** that genuinely sync from 2+ specs (e.g., a "deployment" doc tracking both the CLI spec and the deploy workflow spec) — current schema supports one path only.
- **Screenshot rot** — UI screenshots in tutorials go stale silently; nothing currently flags them.
- **No `sync-ack`** — the `pageworks sync-ack <page>` verb is referenced in maintenance.md but isn't implemented. Users have no way to silence a false-positive drift warning except hand-editing `updated:`.

## Activation triggers

Don't start until **2 of 3** fire:

1. Three or more false-positive drift warnings in real pageworks-driven projects (issues filed or expressed in usage)
2. One or more multi-source `synced_from:` case requested or hand-implemented in the wild
3. One or more screenshot freshness case where outdated UI shipped to docs because nothing flagged it

## Scope

### In scope (once activated)

- **`pageworks sync-ack <page>` verb** (skill-side)
  - Bumps page frontmatter `updated:` to today without modifying content
  - Optional: adds a `sync_acked:` field recording the source-spec mtime at ack time, so future drift checks compare against the *acked* mtime rather than the original
  - Confirms before write
  - Idempotent (no-op if `updated:` is already today)
- **Multi-source `synced_from:`** — accept array form:
  ```yaml
  synced_from:
    - .spectacular/specs/cli/SPEC.md
    - .spectacular/specs/deploy/SPEC.md
  ```
  - Drift fires if ANY source mtime > page `updated:`
  - Audit output names which source(s) drifted
  - Backward compatible: single-string form still valid
- **Screenshot freshness audit** (skill-side, `pageworks audit`)
  - Walk `docs/**/*.md` for image references (`![alt](path.png)`, `<img src=...>`)
  - For each image: if image mtime is more than 60 days behind file mtime, info-level warning
  - Configurable threshold via `docs.yaml` `audit.screenshot_freshness_days: 60`
- **mtime-vs-content awareness** (optional, judgment)
  - When a source spec's mtime changed but content hash matches the last-known hash (stored in a tiny `.pageworks/sync-state.json` file), drift check downgrades to info rather than warning
  - Requires per-source hash tracking, gitignored state file, opt-in via config
  - **Defer if complexity exceeds value** — judgment call at M3

### Out of scope

- **Auto-rewriting drifted pages.** Pageworks proposes; humans write. v2 doesn't change this.
- **Inline diffing.** Showing "here's what changed in the spec since last sync" is a v0.5.x thing.
- **Auto-PR generation for drift fixes.** Way out.
- **Cross-repo drift detection** (e.g., page synced from a spec in a different repo). One repo at a time.

## Decisions (provisional)

- **`sync-ack` is skill-side, not CLI.** Confirms with the user, edits frontmatter — judgment work.
- **Multi-source ships in v0.4.0 unconditionally.** It's a clean schema extension; backward compatible; low risk.
- **Screenshot freshness is opt-in at first.** Default 60-day threshold; configurable; info-only severity (never warning/error in v0.4.0).
- **Hash-based drift is deferred behind opt-in config flag.** Adds state file complexity; ship only if false-positive volume justifies it.

## Milestones

1. **M1 — Verify activation signals.** Document the false-positive cases, multi-source requests, screenshot incidents that justify activation.
2. **M2 — `sync-ack` verb.** Skill verb + tests.
3. **M3 — Multi-source `synced_from:`.** Schema extension + audit + doctor support.
4. **M4 — Screenshot freshness.** Audit walk + config option.
5. **M5 — Hash-based drift** (conditional). Only if M1 surfaced volume to justify the state-file complexity.
6. **M6 — Tests + release.** Ship as v0.4.0.

## Risks

- **State file fragility.** Any hash-tracking state file in `.pageworks/` becomes a new failure surface (corruption, missing in fresh clones, sync conflicts in multi-author repos). Mitigation: gitignored, regenerated on first audit, opt-in only.
- **Multi-source ambiguity.** When 2+ sources drift, what does the audit recommend? Mitigation: name all drifted sources in the warning; let the writer decide which (if any) need doc updates.
- **Screenshot threshold tuning.** 60 days is a guess. Mitigation: configurable from day one, info-severity until real data informs a default.

## Validation

- `pageworks sync-ack <page>` bumps `updated:` to today without content changes; idempotent
- `pageworks audit` against a multi-source `synced_from:` correctly identifies which source drifted
- Screenshot audit flags an obviously stale image in a tutorial
- All previous v0.1.0 drift behaviors still work (no regressions)

## Success criteria

- `sync-ack` verb shipped + tested
- Array form of `synced_from:` accepted by both contract docs and audit logic
- Screenshot freshness reported when threshold exceeded
- `references/maintenance.md` updated to reflect the new capabilities
- v0.4.0 tagged + released
