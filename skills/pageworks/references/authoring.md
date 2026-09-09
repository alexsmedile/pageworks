# Authoring — Page Lifecycle Verbs

Use this when: Scaffolding new documentation pages, choosing template classes, declaring new sections, or running quality review gates.

- Schema and Information Architecture: [contract.md](contract.md)
- The 6 Core Page Classes: [page-types.md](page-types.md)
- Voice, Tone & Action Headings: [prose-patterns.md](prose-patterns.md)
- Wiki Architecture & Component Patterns: [wiki-patterns.md](wiki-patterns.md)
- Designer Mode & Custom Themes: [designer-mode.md](designer-mode.md)
- Quality Gates & Semantic Review: [quality-gates.md](quality-gates.md)
- Drift Detection & Stale Auditing: [maintenance.md](maintenance.md)

---

## Skill Verbs & Operational Flows

- `pageworks new <page>` — Scaffolds a new documentation page from extensible templates.
- `pageworks review <page>` — **Micro Quality Gate**: Inspects a single page for prose, action headings, and code executability.
- `pageworks status` — **Inventory Briefing**: Compiles page counts, section breakdown, drafts, and review timestamps.
- `pageworks audit` — **Macro Health & Drift**: Scans entire documentation tree for stale pages and upstream git drift.

---

## 1. `pageworks new <page>` Flow

### Steps
1. **Resolve Slug & Section**:
   - Slug: Kebab-case without `.md` extension.
   - Section: Assign to one of the 6 Topic Categories (`getting-started`, `architecture`, `services`, `operations`, `reference`, `standards`) or an existing declared section in `docs.yaml`.
2. **Select Page Class & Template**:
   - Core baseline: `tutorial`, `how-to`, `adr`, `reference`, `service-catalog`, `runbook`, `postmortem`, `explanation`.
   - Extended baseline: `migration`, `troubleshooting`, `cookbook`, `design-spec`.
   - Matching template loaded from `templates/pages/<class>.md.tmpl` (fallback to `templates/page.md.tmpl`).
3. **Collect Frontmatter Metadata**:
   - `title`: Action-oriented for guides/tutorials; noun-led for references; ADR/postmortem title.
   - `description`: 1–2 concise summary sentences.
   - `owner`: Team or on-call handle (e.g. `@platform-core`, `#infra`).
   - `last_reviewed` & `updated`: Current ISO date (`YYYY-MM-DD`).
4. **Safety Gate — Propose Diffs Before Writing**:
   - Present the draft markdown file content and proposed `docs.yaml` diff (`pages: [...]`) to the user.
   - Await explicit user approval before writing to disk.
5. **Write Files**:
   - Write `docs/<section>/<slug>.md`.
   - Update `docs/docs.yaml` with the new page slug under the appropriate section.
6. **Post-Scaffold Verification**:
   - Run `bash "${PAGEWORKS_SKILL_DIR:-skills/pageworks}/scripts/pageworks" doctor`.
   - Completion criterion: 0 errors reported on the newly created page and manifest.

---

## 2. `pageworks review <page>` Quality Gate (Micro)

Inspects an individual page before publishing or merging.

### Steps
1. **Target Resolution & Health Check**:
   - Read `docs/<path>/<page>.md`.
   - Run `bash "${PAGEWORKS_SKILL_DIR:-skills/pageworks}/scripts/pageworks" doctor`.
   - If mechanical errors exist (missing frontmatter, broken links, depth violations), report them first.
2. **Four-Pillar Quality Audit** (consult [references/quality-gates.md](quality-gates.md)):
   - **Diátaxis Quadrant Fit**: Does a tutorial walk step-by-step without encyclopedic walls? Is a how-to strictly problem-oriented?
   - **Action-Oriented Headings** (consult [references/prose-patterns.md](prose-patterns.md)): Are steps named with active verbs (e.g. `## Deploy Worker Nodes` instead of `## Worker Nodes`)?
   - **Copy-Paste Readiness**: Are shell commands isolated, tagged with bash language fences, using realistic `<PLACEHOLDER>` tokens?
   - **Diagrams & Visuals**: Are complex architectures rendered with Mermaid.js rather than dense prose walls?
3. **Synthesize Findings**:
   - Emit line-referenced improvement suggestions with drop-in markdown diff blocks.
4. **Completion Criterion**:
   - Emit standard Report Format box with verdict (`PASS` or `REVISE`), line-specific feedback, and command to acknowledge freshness once resolved (`pageworks touch <page>`).

---

## 3. `pageworks status` Inventory Briefing

Compiles high-level visibility across the documentation surface.

### Steps
1. **Manifest Inspection**: Read `docs/docs.yaml` to extract all declared sections, ordering, and page lists.
2. **File & Frontmatter Scan**:
   - Inspect frontmatter of every declared page on disk.
   - Categorize pages by status (`stable`, `draft`, `deprecated`).
   - Identify unreviewed or stale pages (`last_reviewed` older than 180 days).
   - Detect orphan pages (files in `docs/` not declared in `docs.yaml`).
3. **Generate Inventory Table**:
   - Output structured table grouped by section: Total Pages, Stable %, Stale Count (>180d), and Missing Owners.
4. **Completion Criterion**:
   - Report emitted displaying total inventory count, percentage freshness, and prioritized list of pages requiring review.

---

## 4. `pageworks audit` Macro Drift Gate

Scans the entire documentation repository for drift and aging (consult [references/maintenance.md](maintenance.md)).

### Steps
1. **Mechanical Audit**: Run `bash "${PAGEWORKS_SKILL_DIR:-skills/pageworks}/scripts/pageworks" doctor`. Collect all 180-day staleness warnings and broken link errors.
2. **Upstream Git Drift Analysis**:
   - For all pages declaring `synced_from: <path>`, query `git log -1 --format=%cs` on the target source file.
   - Flag any page whose upstream source has newer commits than the page's `last_reviewed` date.
3. **Semantic Drift Review**:
   - Sample core service runbooks and API specs against recent codebase git commits to spot behavioral shifts.
4. **Acknowledge Freshness**:
   - For pages verified as accurate, run `bash "${PAGEWORKS_SKILL_DIR:-skills/pageworks}/scripts/pageworks" touch <page>` to reset the review clock.
5. **Completion Criterion**:
   - Emit standard Report Format box categorizing pages as `Accurate`, `Drifted (upstream updated)`, or `Stale (>180d)`.
