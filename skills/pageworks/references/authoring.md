# Authoring — Page Lifecycle Verbs

Loaded when handling `pageworks new`, `pageworks review`, or `pageworks status` (skill-side verbs that involve writing or auditing documentation).

- Schema and Information Architecture: [[contract]]
- The 6 Core Page Classes: [[page-types]]
- Voice, Tone & Action Headings: [[prose-patterns]]
- Drift Detection & Stale Auditing: [[maintenance]]

---

## Skill Verbs

- `pageworks new <page>` — Scaffolds a page from one of the 6 Core Page Class templates (`tutorial`, `how-to`, `adr`, `reference`, `service-catalog`, `postmortem`, `explanation`).
- `pageworks new --section <name>` — Declares a new section in `docs.yaml`, scaffolding the directory and index.
- `pageworks review` — Quality gate auditing frontmatter, ownership, prose patterns, broken links, and Diátaxis fitness.
- `pageworks status` — Briefing of documentation health and section/page inventory.

---

## `pageworks new <page>` Flow

1. **Resolve slug**: Kebab-case without `.md` extension.
2. **Pick page class**:
   - `tutorial`: Step-by-step onboarding walkthrough
   - `how-to`: Problem-oriented task guide
   - `adr`: Architecture Decision Record
   - `reference`: Factual technical spec, schema, API endpoint
   - `service-catalog`: Service one-pager (owners, URLs, SLOs)
   - `postmortem`: Incident retrospective (5 Whys, timeline, action items)
   - `explanation`: Concept/architecture overview
3. **Pick section**: Matches one of the 6 Topic Categories (`getting-started`, `architecture`, `services`, `operations`, `reference`, `standards`) or custom declared sections.
4. **Prompt for metadata**:
   - `title`: Action-oriented for how-to/tutorial; noun-led for reference/catalog; ADR/postmortem title.
   - `description`: 1–2 sentences.
   - `owner`: Team or on-call handle (e.g. `@platform-core`, `#infra`).
5. **Scaffold file from matching template**:
   - `tutorial` $\to$ `templates/pages/tutorial.md.tmpl`
   - `how-to` $\to$ `templates/pages/how-to.md.tmpl`
   - `adr` $\to$ `templates/pages/adr.md.tmpl`
   - `reference` $\to$ `templates/pages/reference.md.tmpl`
   - `service-catalog` $\to$ `templates/pages/service-catalog.md.tmpl`
   - `runbook` $\to$ `templates/pages/runbook.md.tmpl`
   - `postmortem` $\to$ `templates/pages/incident-postmortem.md.tmpl`
   - `explanation` $\to$ `templates/pages/explanation.md.tmpl`
6. **Update `docs.yaml`**: Append slug to section `pages:` array.
7. **Confirm diff with user** before writing.

---

## `pageworks review` Quality Gate

Executes mechanical and judgment checks across `docs/`:

### 1. Mechanical Checks (`pageworks doctor` alignment)
- `docs.yaml` syntax and section alignment.
- Required frontmatter presence: `title`, `description`, `section`, `status`, `updated`, and `owner`.
- Broken internal links (`[text](relative-path.md)`).
- Hierarchy depth $\le 3$ levels.
- 180-day stale review warnings.

### 2. Style & Prose Checklist
- **Headings**: Imperative verbs for procedural pages ("Configure Variables" vs "Configuration Info").
- **Code Snippets**: Copy-paste ready without uncopyable `$` prompts; standard `<PLACEHOLDER>` tags.
- **Visuals**: Mermaid.js diagrams for architecture, data flows, and service topologies.
- **Diátaxis Discipline**: No tutorial steps buried in reference specs; no marketing fluff in explanations.
- **Status Integrity**: No `<!-- TODO -->` tags in `status: stable` pages.
