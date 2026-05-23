# Authoring — page lifecycle verbs

Loaded when handling `pageworks new`, `pageworks review`, or `pageworks status` (skill-side verbs that involve writing or auditing prose). Schema and folder contract live in [[contract]]. Diátaxis page-type guide is in [[page-types]]. Voice / tone / formatting conventions live in [[prose-patterns]].

## Scope

This file drives **skill-side** verbs (interactive, run inside an AI agent):

- `pageworks new <page>` — scaffold a page from a Diátaxis template, prompt for type/section/title, update `docs.yaml`
- `pageworks new --section <name>` — declare a new section in `docs.yaml`, scaffold the directory + a placeholder page
- `pageworks review` — quality gate (errors + warnings, no auto-fix)
- `pageworks status` — briefing scoped to `docs/`

The CLI handles `pageworks init` (mechanical scaffold), `pageworks export <renderer>` (config generation), and `pageworks doctor` (validation). Those are mechanical and don't require this file.

## `pageworks new <page>` flow

1. **Resolve the page slug.** Convert `<page>` to kebab-case. Strip `.md` if user typed it. Reject if it collides with an existing page in any section.
2. **Pick the page type (Diátaxis).** Ask the user: `tutorial | how-to | reference | explanation`. See [[page-types]] § How to pick a quadrant for the decision tree. Never default silently.
3. **Pick the section.**
   - If `--section <name>` flag is set: use it. If the section doesn't exist in `docs.yaml`, error and suggest `pageworks new --section <name>` first.
   - If no flag: read `docs.yaml`, present the list of section ids + "create new section" as the last option. Ask the user to pick one. Never silently default.
4. **Ask for title and description.** Required frontmatter, can't be elided.
   - Title: noun-led for reference, verb-led for tutorial/how-to, concept-led for explanation (see [[page-types]] per quadrant)
   - Description: one sentence, ~120 chars, ends with a period
5. **Scaffold the file** at `docs/<section>/<page>.md` using the matching template from `templates/pages/`:
   - `tutorial` → `templates/pages/tutorial.md.tmpl`
   - `how-to` → `templates/pages/how-to.md.tmpl`
   - `reference` → `templates/pages/reference.md.tmpl`
   - `explanation` → `templates/pages/explanation.md.tmpl`
   Fill `title`, `description`, `section`, `type`, `status: draft`, `updated: <today>`. Leave `order` and `since` empty (defaults handle them).
6. **Update `docs.yaml`** — append the page slug to that section's `pages:` list.
7. **Confirm the diff** with the user before any write. Show: new file path + the docs.yaml line being changed.

## `pageworks new --section <name>` flow

1. **Resolve section id.** kebab-case. Reject collision with existing sections.
2. **Ask for title** (display name). Required.
3. **Ask for order** — default: append (max existing order + 1). User can override.
4. **Scaffold the directory** `docs/<id>/` with a `.gitkeep`.
5. **Append section to `docs.yaml`** with `pages: []`.
6. **Confirm before write.** Show the docs.yaml delta.

If the user is creating a section *and* a page in the same flow, do both in order — section first, then page.

## `pageworks review` quality gate

Run all checks; report findings as a punch list. Pass = zero errors. Warnings don't block but should be addressed.

### Gate checks (mechanical — same as `pageworks doctor`)

| Severity | Check | Recovery |
|---|---|---|
| error | `docs.yaml` missing or unparseable | Run `pageworks init` (won't overwrite existing pages) |
| error | Any page declared in `docs.yaml` but missing on disk | Either create the page or remove the entry |
| error | Any page missing required frontmatter (`title`, `description`, `section`, `status`, `updated`) | Add the field; run `pageworks doctor --fix` for stubs |
| error | Page `section:` value doesn't match any section in `docs.yaml` | Fix typo or add the section |
| warning | Page file present but not declared in `docs.yaml` (orphan) | Add to `docs.yaml` or delete |
| warning | Page `updated:` is more than 14 days older than file mtime | Bump `updated:` or sync the content |
| warning | Section folder exists but has zero pages declared and zero files | Remove the section or add a page |
| info | Section has empty `pages:` but folder is empty too | Intentional empty section — fine |
| info | Page missing `type:` frontmatter (Diátaxis type) | Add the type; see [[page-types]] |

### Per-page-type checks (judgment — skill-side only)

Apply the type-specific checklist from [[page-types]] and the cross-cutting checklist from [[prose-patterns]]. Examples of judgment findings:

- Tutorial without a "What you'll have at the end" or equivalent verification block
- How-to that drifts into teaching (steps mixed with concepts)
- Reference with inconsistent entry structure
- Explanation with no "The short version" / TL;DR
- Marketing tone, hedging filler, passive voice
- Cross-quadrant links missing on tutorials and explanations
- TODO/FIXME in a `status: stable` page

### Output format

```text
pageworks review — found 2 errors, 1 warning, 1 info

ERRORS
  ❌ docs/guides/team-billing.md — missing required frontmatter: description
  ❌ docs.yaml — page 'install' declared but docs/getting-started/install.md not found

WARNINGS
  ⚠️  docs/reference/cli.md — orphan (not in docs.yaml)

INFO
  ℹ docs/guides/team-billing.md — missing `type:` frontmatter (Diátaxis type)

Suggested fixes:
  • Add `description:` to team-billing.md
  • Create install.md or remove from docs.yaml
  • Add cli.md to docs.yaml reference section, or delete it
  • Add `type: how-to` to team-billing.md (likely)
```

## `pageworks status` briefing

Same shape as a skill no-arg briefing but scoped to `docs/`. Report:

- Site name + tagline (from `docs.yaml`)
- Page count by section: `Getting Started (3), Guides (1), Reference (2)`
- Page count by type (when `type:` is declared): `tutorial (1), how-to (4), reference (2), explanation (1)`
- Draft pages: list slugs (so user sees what's unfinished)
- Stale pages: pages where `updated:` is >30 days behind file mtime
- One-line "next action" if anything obvious is open (e.g., "1 page missing frontmatter — run `pageworks review`")

Keep it short. Max 10 lines of body.

## Vibe → spec patterns (writer hints)

When `pageworks new` or `pageworks review` finds wishy-washy prose, suggest these rewrites:

| Vibe pattern | Rewrite to |
|---|---|
| "this page is about X" (first sentence) | "X is …" (lead with the thing, not the meta-description) |
| Long intro paragraph before any action | One-sentence lead + immediate "## How to" or "## Steps" subhead |
| "we" / "our" outside a tutorial | "the CLI" / project name / second person ("you") |
| "simply" / "just" / "basically" | Strip — the brevity will say so itself |
| TODO / FIXME inline in `status: stable` | Strip and surface as a review-time error |
| "click here" / "this" link text | Descriptive link text naming the destination |

See [[prose-patterns]] for the full conventions.

## Anti-patterns

- **Don't auto-create pages without confirmation.** Always show the diff first.
- **Don't put per-page `audience:` in frontmatter.** Folder is the audience boundary.
- **Don't deep-nest section folders.** Express nested grouping in `docs.yaml` `pages:` if absolutely needed; keep the filesystem flat.
- **Don't write to `docs/` from non-docs verbs.** Only the `pageworks` family of verbs writes to `docs/`. External callers (a paired spectacular's archive flow, for example) signal intent — they don't write.
- **Don't conflate page types.** If a page is doing two Diátaxis jobs at once, split it. See [[page-types]] § anti-patterns per quadrant.
- **Don't ship `status: stable` with a TODO marker.** Either finish or downgrade to `draft`.
