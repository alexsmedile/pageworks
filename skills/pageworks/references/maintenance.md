# Maintenance — Drift Detection and Spec→Doc Sync

Loaded when:
- `pageworks audit` runs
- `pageworks doctor` includes the drift checks (when v0.2+ enables them)
- Skill is invoked after a spec change in a paired spectacular project
- User asks "what docs are stale?" or "what needs updating?"

This reference covers how pageworks detects rotting docs and the patterns for keeping them aligned to truth.

## What drift looks like

Drift happens in five recognizable shapes. Pageworks names them so audits can talk about each precisely.

| Drift type | Signal | Severity |
|---|---|---|
| **Stale `updated:`** | Page `updated:` is older than file mtime by > 14 days | warning |
| **Source-spec drift** | Page declares `synced_from:` and the source spec's mtime > page `updated:` | warning |
| **Broken internal link** | `[link](target.md)` target doesn't exist | error |
| **Broken cross-quadrant link** | Tutorial / explanation has no "Next:" links to other quadrants | info |
| **Version drift** | Page `since:` references a version that doesn't exist in CHANGELOG | warning |
| **Screenshot freshness** | Image referenced in page is older than the page itself by > 60 days | info |

Tutorials, how-tos, references, and explanations each rot in characteristic ways. Reference pages rot fastest (APIs change), tutorials next (UIs change), how-tos next, explanations slowest.

## The `synced_from:` pattern

When a doc page derives from an internal spec (typically `.spectacular/specs/<x>/SPEC.md`), declare the source in frontmatter:

```yaml
---
title: CLI commands
description: Reference for all pageworks CLI verbs.
section: reference
type: reference
status: stable
since: 0.1.0
updated: 2026-05-23
synced_from: ../../../.spectacular/specs/cli/SPEC.md
---
```

Pageworks's drift check compares the page's `updated:` field to the source spec's filesystem mtime. If the spec is newer, the page is flagged as drifted.

**Sync resolution is human-curated.** Pageworks does not auto-rewrite pages from specs. The flag is a prompt; the writer (or `docs-writer` agent in pageworks v0.2+) decides what to update.

**`pageworks sync-ack <page>`** (planned v0.2): bump `updated:` on a page without content change, declaring "I checked; the spec's change doesn't require a doc update." This silences false positives.

## When pageworks pairs with spectacular

Spectacular's `archive` verb (when archiving a request that touched `SPEC.md` or `specs/`) prompts the user to invoke pageworks. The typical flow:

1. User: `spectacular archive my-feature`
2. Spectacular detects: `specs/my-feature/SPEC.md` mtime changed
3. Spectacular prompts: *"This change may affect public docs/. Run `pageworks audit` to find pages that may need updating, or skip with --no-docs-prompt."*
4. User: `pageworks audit`
5. Pageworks scans pages with `synced_from:` references that match the changed spec, lists them
6. User invokes pageworks's writing verbs (`pageworks new` for missing pages, `pageworks review <page>` for updates)

Pageworks never invokes itself across the spectacular boundary. The prompt is a signal; the action is the user's.

When pageworks runs without spectacular, the `synced_from:` pattern still works for any file path — it doesn't require a `.spectacular/` directory. Drift detection is filesystem-based.

## Audit checklist

`pageworks audit` runs all of the following:

### Frontmatter audit
- Every page has the required fields (per `contract.md`)
- `status:` is one of `draft | stable | deprecated`
- `updated:` is parseable ISO date
- `type:` matches one of the four quadrants
- `since:` if present, is a valid semver
- `synced_from:` if present, target file exists

### Freshness audit
- `updated:` not more than 14 days older than file mtime (warning)
- `synced_from:` source mtime not newer than page `updated:` (warning)
- `status: draft` pages: flag if `updated:` is more than 90 days old (info — drafts shouldn't linger)

### Structural audit
- All pages declared in `docs.yaml` exist on disk
- All `.md` files on disk are declared in `docs.yaml` (orphans)
- Section folder names match section ids in `docs.yaml`
- `index.md` exists at `docs/`

### Link audit
- Every internal link target resolves
- Cross-quadrant link rule: every tutorial and explanation has at least one outbound link
- Anchor links target headings that exist

### Quality audit (per page-type)
- Tutorial: has "What you'll have at the end" or equivalent up front
- How-to: has "When to use this" or equivalent scenario marker
- Reference: has consistent entry structure (parameters table, signature, example)
- Explanation: has "The short version" or equivalent TL;DR

### TODOs and FIXMEs
- No `<!-- TODO -->`, `<!-- FIXME -->`, `XXX` in `status: stable` pages (error)
- Allowed in `status: draft` (info, listed for the writer)

## Page review checklist

When `pageworks review <page>` runs (skill verb, interactive), apply this checklist:

1. **Type fit** — does the page match its declared `type:`? If a tutorial reads like a reference, suggest splitting or re-typing.
2. **Lead with the answer** — does the first paragraph (or "the short version" / "what you'll have" block) make the page's purpose immediately obvious?
3. **Voice consistency** — present tense, second person (or first person plural in tutorials), active voice. Flag passive sentences.
4. **Cap on hedging** — no "basically," "simply," "just," "essentially."
5. **Examples are minimal** — code blocks show one thing, not three.
6. **Headings are nouns** — not summaries.
7. **Links are descriptive** — no "click here," no bare "this."
8. **Cross-quadrant linking** — tutorials and explanations have a "Next:" section.
9. **Frontmatter freshness** — `updated:` matches today; `status:` reflects reality.
10. **No marketing tone** — flag "elegant," "powerful," "best-in-class."

The skill makes recommendations; it does not rewrite without confirmation. Each finding includes a one-line proposed fix the user can accept, modify, or reject.

## When NOT to update

Not every spec change requires a doc update. Skip when:

- The spec change is internal-only (refactor with no API/UX impact)
- The spec change is about an unreleased feature (no docs exist yet — covered when the feature ships)
- The spec change documents an existing behavior more precisely (the public surface didn't change)

In these cases, run `pageworks sync-ack <page>` (v0.2+) to bump `updated:` without a content rewrite — or hand-edit the date.

## Maintenance cadence

Pageworks doesn't enforce a cadence; that's the writer's call. But typical patterns:

| Cadence | What to do |
|---|---|
| **Per release** | Run `pageworks audit`; address errors; defer warnings if scope demands |
| **Monthly** | Run `pageworks audit`; address warnings; review `status: draft` pages |
| **Quarterly** | Walk `docs/`; consider what's missing, what could be split, what should be merged. Architecture-level review, not page-level. |

The skill's `audit` is mechanical. The quarterly walk is judgment — it's the kind of work a future `docs-architect` agent will help with (pageworks-agents follow-on request).

## Severity legend

| Level | When to act |
|---|---|
| **error** | Always fix before shipping a release |
| **warning** | Fix soon; track if deferred |
| **info** | Awareness only; act on judgment |
