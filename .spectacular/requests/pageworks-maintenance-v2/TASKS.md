---
updated: 2026-05-23
related:
  - PLAN.md
---

# Tasks — pageworks maintenance v2

> **Status: planned, gated.** Do not begin until 2-of-3 activation triggers fire (see PLAN.md).

## M1 — Verify activation signals

- [ ] Document false-positive drift cases (3+) — link issues/PRs
- [ ] Document multi-source `synced_from:` cases (1+) — link issues/PRs
- [ ] Document screenshot freshness incidents (1+)
- [ ] Update PLAN.md with the actual triggers that fired

## M2 — `sync-ack` skill verb

- [ ] Document `pageworks sync-ack <page>` flow in `references/maintenance.md`
- [ ] Add to `references/authoring.md` § Scope (skill-side verbs list)
- [ ] Skill verb implementation: read page frontmatter, bump `updated:` to today, optionally write `sync_acked:` field, confirm with user before write
- [ ] Add `sync-ack` to `cli/pageworks` as a skill-verb stub (prints "run inside AI agent")
- [ ] Idempotency: if `updated:` is already today, report no-op + exit clean
- [ ] Test scenario in `tests/cli/sync-ack.test.sh` — verb stub prints correct message

## M3 — Multi-source `synced_from:`

- [ ] Update `references/contract.md` page frontmatter schema: `synced_from:` accepts string OR array of strings
- [ ] Update `references/maintenance.md` § common spec sources with array example
- [ ] Update `cli/pageworks` doctor/audit logic:
  - Parse string OR array form of `synced_from:`
  - Drift fires if any source mtime > page `updated:`
  - Audit output names all drifted sources
- [ ] Backward compatibility test: single-string form still works
- [ ] Multi-source test: 2 sources, one drifted → audit names the drifted one
- [ ] Multi-source test: 2 sources, both drifted → audit names both

## M4 — Screenshot freshness audit

- [ ] Update `references/maintenance.md` with screenshot freshness rules
- [ ] Extend `docs.yaml` schema with optional `audit.screenshot_freshness_days: <int>` (default 60)
- [ ] Update `references/contract.md` to document the new audit config
- [ ] Walk `docs/**/*.md` for image references in `pageworks audit`:
  - Markdown: `![alt](path.png)`, `![alt](path.svg)`, etc.
  - HTML: `<img src="path">`
- [ ] For each image: compare image mtime vs containing page mtime
- [ ] Info-severity warning if image is more than threshold days behind page
- [ ] Test: stub image in `docs/tutorial.md` with mtime backdated 90 days → audit flags it
- [ ] Test: same image but threshold set to 365 → audit does NOT flag

## M5 — Hash-based drift awareness (conditional)

- [ ] Only proceed if M1 false-positive volume justifies the complexity
- [ ] Decide storage: `.pageworks/sync-state.json` (gitignored) vs inline in page frontmatter
- [ ] Schema: `{ "page-path": { "source-path": "sha256" } }`
- [ ] On audit: if source mtime newer than page `updated:` BUT content hash matches stored hash, downgrade drift from warning → info
- [ ] On `sync-ack`: update stored hash to current source content
- [ ] Opt-in via `docs.yaml` `audit.use_content_hash: true` (default false)
- [ ] `.gitignore` recommendation: add `.pageworks/sync-state.json` to project gitignore
- [ ] Tests: hash-match path + hash-mismatch path + first-run-no-state path

## M6 — Tests + release

- [ ] All new behaviors covered in `tests/cli/`
- [ ] `pageworks doctor` regression — all v0.1.0 behaviors still pass
- [ ] Bump `PAGEWORKS_VERSION` to `0.4.0`
- [ ] Bump both plugin manifests
- [ ] Bump SKILL.md frontmatter
- [ ] CHANGELOG entry under `[0.4.0]`
- [ ] Update `CLAUDE.md` Active Requests table
- [ ] Snapshot PLAN + TASKS, archive → `.spectacular/archive/pageworks-maintenance-v2/`
- [ ] Tag v0.4.0, push, `gh release create`
- [ ] `/plugin marketplace update pageworks` (user-triggered)

## Open questions

- [ ] Should `sync_acked:` be a separate frontmatter field, or embedded inside `synced_from:` as `{path, acked_at}` objects?
- [ ] Does `.pageworks/sync-state.json` belong in the gitignore template that `pageworks init` writes?
- [ ] Screenshot freshness: also walk `docs/**/*` for orphan images (no markdown reference)?
