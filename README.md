# pageworks

![Version](https://img.shields.io/badge/version-0.3.0-blue.svg) [![License: MIT](https://img.shields.io/badge/License-MIT-purple.svg)](LICENSE)

**Write docs that don't rot.**

Pageworks is a Claude Code / Codex / Antigravity skill suite + CLI that owns the public-facing documentation surface of a project: scaffold, schema, page authoring with the 6 Core Page Classes across 6 Main Topic Categories, renderer export, Designer Mode styling, 5-layer CI quality gates, and drift detection as specs change.

It ships with **`wiki-prettifier`** — an aesthetic refactoring engine that turns raw Markdown into Stripe/Tailwind-quality developer portals.

---

## What it does

- **Dual-Dimension Architecture**: 6 Page Classes $\times$ 6 Main Topic Categories for zero-friction information architecture.
- **Scaffolds** `docs/` with a clean, renderer-agnostic structure (`docs.yaml` manifest + Diátaxis templates + "Start Here" landing page).
- **Authors** pages with time-to-first-success punchlines, realistic defaults, "Why" annotations, and troubleshooting gotchas.
- **Prettifies** existing Markdown via `wiki-prettifier` (action headings, multi-tool tabs, Mermaid diagrams, 5-column parameter tables).
- **Designer Mode**: Pre-crafted themes (`stripe-indigo`, `nordic-cyan`, `minimalist-slate`, `emerald-terminal`) with custom CSS exports.
- **Exports** to MkDocs Material (with search, tabs, Mermaid superfences) or Docusaurus v3+ (React/MDX).
- **5-Layer CI Quality Gates**: `.markdownlint.json`, `.vale.ini`, `.cspell.json`, lychee link validation, and `pageworks doctor`.
- **Maintains** docs against drift with 180-day stale audits and `pageworks sync-ack`.

## Install

### As a Claude Code plugin
Search the marketplace for `pageworks` or:
```bash
# Symlink into your project (preferred) or user scope
ln -s /path/to/pageworks ~/.claude/plugins/pageworks
```

### As a Codex plugin
Search the Codex marketplace for `pageworks`.

### CLI only
```bash
curl -fsSL https://raw.githubusercontent.com/alexsmedile/pageworks/main/cli/install.sh | bash
```
Installs to `~/.local/bin/pageworks`.

## Quickstart

```bash
# In an existing project
pageworks init                 # scaffolds docs/ + manifest + index.md
pageworks new install          # add a new page (asks for section)
pageworks export mkdocs        # generate mkdocs.yml + Pages workflow
pageworks doctor               # check everything
```

Then in your AI agent of choice:
```
/pageworks
```
…to get a briefing on the current state of `docs/` and what's next.

## Pairing with spectacular

[spectacular](https://github.com/alexsmedile/spectacular) is pageworks's sibling — it owns the *internal* workspace (`.spectacular/`: Anchors, Contracts, Missions, Decisions). Pageworks owns the *external* workspace (`docs/`).

Both are designed to seamlessly coexist:

- Spectacular discovers pageworks and delegates public-doc authoring and maintenance to it.
- After completing a Mission or amending a Contract that alters project behavior, the session prompts you to reconcile docs with `pageworks audit`.
- Pageworks runs completely standalone without spectacular too.

## The 6 Core Classes of Pages (Formats)

| Class | Format / Intent | Example | Canonical Template |
|---|---|---|---|
| **1. Getting Started / Tutorials** | Step-by-step onboarding walkthroughs (zero to running). | `getting-started/local-dev-setup.md` | `tutorial.md.tmpl` |
| **2. How-To Guides (Runbooks)** | Practical, goal-oriented recipes for operational tasks or troubleshooting. | `operations/rotate-secrets.md` | `how-to.md.tmpl` / `runbook.md.tmpl` |
| **3. Architecture Decision Records (ADRs)** | Short, immutable logs recording technical choices, alternatives, and trade-offs. | `architecture/0004-use-postgres-for-events.md` | `adr.md.tmpl` |
| **4. Technical Reference Specs** | Pure factual data: API contracts, data schemas, CLI flags, config variables. | `reference/payment-api-v2.md` | `reference.md.tmpl` |
| **5. Service Catalog Pages** | "One-pagers" for services: ownership, repos, URLs, SLOs, health checks. | `services/auth-service.md` | `service-catalog.md.tmpl` |
| **6. Incident Postmortems** | Outage retrospectives analyzing root cause (5 Whys), impact, timeline, action items. | `operations/2026-05-auth-outage.md` | `incident-postmortem.md.tmpl` |

## The 6 Main Topic Categories (Information Architecture)

1. **Getting Started & Onboarding** — Prerequisites, repo setup, permissions, hello-world deploy.
2. **Architecture & System Design** — High-level topology (Mermaid/C4), shared infrastructure, ADR log.
3. **Services & Components** — Service Catalog one-pagers, dependency maps, telemetry dashboards.
4. **Operations & Reliability** — Runbooks, deployment SOPs, incident triage, disaster recovery drills.
5. **API & Data Reference** — OpenAPI / GraphQL schemas, event bus schemas, CLI flags.
6. **Standards & Governance** — Coding standards, security compliance, Definition of Done, PR checklists.

## Renderers

| Renderer | Status |
|---|---|
| MkDocs (Material) | shipped (v0.1.0) |
| Docusaurus | shipped (v0.1.0) |
| Mintlify | not shipped — community-contributable |
| Fumadocs | not shipped — community-contributable |

See `references/renderers.md` for the adapter contract.

## License

MIT — see `LICENSE`.
