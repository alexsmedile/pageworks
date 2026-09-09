<div align="center">

# 📖 Pageworks

**Write docs that don't rot — Dual-Dimension Software Wiki & Renderer Pipelines**

[![Version](https://img.shields.io/badge/version-0.4.0-blue.svg)](CHANGELOG.md)
[![License: MIT](https://img.shields.io/badge/License-MIT-purple.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Claude%20%7C%20Codex%20%7C%20Antigravity-orange.svg)](#install)
[![CI Quality Gate](https://img.shields.io/badge/CI%20Quality-5--Layer%20Automated-brightgreen.svg)](#-5-layer-automated-ci-quality-gates)
[![Tests](https://img.shields.io/badge/tests-219%20passing-success.svg)](#-test-harness)

<p align="center">
  <a href="#-why-pageworks">Why Pageworks</a> •
  <a href="#-the-dual-dimension-architecture">Architecture</a> •
  <a href="#-quickstart">Quickstart</a> •
  <a href="#-included-skills">Skills</a> •
  <a href="#-designer-mode">Designer Mode</a> •
  <a href="#-5-layer-automated-ci-quality-gates">Quality Gates</a>
</p>

</div>

---

## ⚡ The Problem: Why Technical Wikis Rot

Most engineering wikis fail because they read like dry academic textbooks or chaotic brain-dumps. Documentation starts strong, but quickly drifts, links break, ownership is lost, and nobody knows if a runbook is still safe to execute.

| Without Pageworks | With Pageworks |
|---|---|
| **Chaotic, deep folder sprawl** (5+ levels deep, lost pages) | **Strict 3-level shallow hierarchy** across 6 core categories |
| **Mixed, bloated formats** (tutorials mixed with API reference walls) | **6 discrete Page Classes** grounded in the Diátaxis framework |
| **Silent drift & stale docs** (outdated commands cause outages) | **180-day review governance**, link checking, and `sync-ack` |
| **Locked into a single tool** (painful migrations between frameworks) | **Framework-agnostic Markdown** $\to$ 1-click export to MkDocs / Docusaurus |
| **Ugly, unformatted text** (intimidating walls of prose) | **Built-in `wiki-prettifier`** for Stripe/Tailwind-quality developer portals |

---

## 🎯 Right for You If...

- [x] You want a **single source of truth** in `docs/` that engineers actually read and bookmark.
- [x] You want **Docs-as-Code** versioned in Git alongside your code, but need instant static exports for MkDocs Material or Docusaurus v3+.
- [x] You use AI coding assistants (**Claude Code**, **Codex**, **Antigravity**) and want them to author docs adhering to strict standards.
- [x] You want automated CI/CD assertions to **block broken links, schema violations, and stale content** before PRs merge.

---

## 🏗️ The Dual-Dimension Architecture

Pageworks separates **Page Formats** (the functional format of the document) from **Topic Categories** (the Information Architecture).

```
docs/
├── docs.yaml                 # Authoritative manifest (site + 6 categories + renderers)
├── index.md                  # "Start Here" landing page (topology, owners, quick pathways)
├── getting-started/          # Category 1: Onboarding walkthroughs (Tutorials)
├── architecture/             # Category 2: Topology, shared infra, Decision Log (ADRs)
├── services/                 # Category 3: Service Catalog one-pagers (Owners, SLOs)
├── operations/               # Category 4: Operational procedures & Incident Postmortems (Runbooks)
├── reference/                # Category 5: Pure factual data (APIs, Schemas, CLI specs)
└── standards/                # Category 6: Governance, DoD, and Review Checklists
```

### The 6 Core Classes of Pages

| Class | Format / Intent | Example Template | Stance |
|---|---|---|---|
| **1. Tutorials** | Step-by-step onboarding walkthroughs (zero to running). | `getting-started/install.md` | *"I am new here. Take me by the hand."* |
| **2. How-To / Runbooks** | Problem-oriented recipes for specific operational tasks. | `operations/rotate-secrets.md` | *"I know what I want. Show me the recipe."* |
| **3. ADRs** | Immutable logs recording architectural choices & trade-offs. | `architecture/0001-use-postgres.md` | *"Why did we choose this design?"* |
| **4. Reference Specs** | Pure factual contracts: API schemas, CLI flags, configs. | `reference/api-v2.md` | *"Give me the exact factual data."* |
| **5. Service Catalog** | Standardized service one-pagers (repos, URLs, SLOs). | `services/auth-service.md` | *"What is this service and who owns it?"* |
| **6. Postmortems** | Outage retrospectives (root causes, 5 Whys, action items). | `operations/2026-05-outage.md` | *"What failed and how do we prevent it?"* |

---

## 🚀 Quickstart

### 1. Installation

```bash
# As a Claude Code / Codex / Antigravity plugin (Recommended)
git clone https://github.com/alexsmedile/pageworks.git ~/.gemini/antigravity/skills/pageworks

# Or install standalone CLI to ~/.local/bin/pageworks
curl -fsSL https://raw.githubusercontent.com/alexsmedile/pageworks/main/cli/install.sh | bash
```

### 2. Scaffold a Fresh Wiki in 10 Seconds

```bash
# Scaffold the complete 6-category software & platform wiki
./skills/pageworks/scripts/pageworks init --preset platform

# Verify wiki health, frontmatter schema, and link integrity
./skills/pageworks/scripts/pageworks doctor
```

### 3. Interactive Agent Workflow

In your AI agent, type `/pageworks` to trigger the orchestrator:

```text
User: /pageworks new
Agent: What class of page are you authoring?
       1. Tutorial (Onboarding)
       2. How-To Guide / Runbook
       3. Architecture Decision Record (ADR)
       4. Technical Reference Spec
       5. Service Catalog One-Pager
       6. Incident Postmortem
```

---

## 📦 Included Skills

Pageworks ships with two 100% self-contained skills:

### 1. `pageworks` (The Documentation Orchestrator)
- **Scaffolding & Schema**: Owns `docs/` manifest, frontmatter validation, and shallow hierarchy enforcement.
- **SSG Export Pipelines**: 1-click generation of **MkDocs Material** (instant search, tabs, Mermaid diagrams, dark/light toggle) and **Docusaurus v3+** (React/MDX) configs.
- **180-Day Governance**: Drift detection, link checking, and fast `pageworks sync-ack <page>` freshness verification.

### 2. `wiki-prettifier` (The Aesthetic & UX Refactoring Engine)
- **Hero Pass**: Converts conversational filler into action-oriented H1 + 1-sentence value proposition subtitle.
- **Tabify**: Folds multi-tool instructions (`npm` · `pnpm` · `yarn` · `bun`) into interactive switcher tabs.
- **Diagramify**: Converts ASCII boxes into native **Mermaid.js** flowcharts & sequence diagrams.
- **Tabulate**: Converts messy bulleted parameter lists into clean 5-column Markdown tables.
- **Calloutify**: Injects styled semantic alerts (`> [!NOTE]`, `> [!WARNING]`, `> [!CAUTION]`).
- **Codify**: Strips uncopyable `$` prompts, tags languages, and attaches **Expected Output** blocks.

---

## 🎨 Designer Mode: Custom Themes & CSS Tokens

Pageworks treats documentation as a branded product. Export custom CSS stylesheets for both static site engines:

| Preset Name | Primary Accent | Dark Mode Background | Target Vibe |
|---|---|---|---|
| **Stripe Indigo** (Default) | `#4f46e5` | `#0f172a` (Slate 900) | Polished fintech & SaaS developer portal |
| **Nordic Cyan** | `#06b6d4` | `#030712` (Zinc 950) | High-tech cloud & developer platform |
| **Minimalist Slate** | `#475569` | `#18181b` (Zinc 900) | Clean, content-first enterprise wiki |
| **Emerald Terminal** | `#059669` | `#052e16` (Deep Forest) | DevOps & SRE operational runbooks |

Exporting with `pageworks export mkdocs` or `pageworks export docusaurus` automatically generates **`docs/stylesheets/custom.css`** and **`src/css/custom.css`** pre-configured with modern typography (`JetBrains Mono`, `Inter`), card radii, and dark/light color schemes.

---

## 🛡️ 5-Layer Automated CI Quality Gates

Prevent broken links, formatting errors, and wiki rot with automated assertions:

```
┌────────────────────────────────────────────────────────┐
│ Layer 5: Executable Docs (Run bash blocks in CI)       │
├────────────────────────────────────────────────────────┤
│ Layer 4: Metadata & 180-Day Staleness (pageworks doctor)│
├────────────────────────────────────────────────────────┤
│ Layer 3: Link & Deep Anchor Validation (lychee)        │
├────────────────────────────────────────────────────────┤
│ Layer 2: Prose, Style & Spell Checking (Vale, cspell)  │
├────────────────────────────────────────────────────────┤
│ Layer 1: Syntax & Markdown Structure (markdownlint)    │
└────────────────────────────────────────────────────────┘
```

The included **`.github/workflows/docs-quality.yml`** runs on every PR editing `docs/**`:
- **[`.markdownlint.json`](.markdownlint.json)**: Enforces heading consistency and list nesting.
- **[`.vale.ini`](.vale.ini)**: Automated prose style guide (Google, write-good, readability grade).
- **[`.cspell.json`](.cspell.json)**: Technical spelling dictionary for dev tools.
- **`pageworks doctor`**: Fails the PR if internal links are broken or pages lack owners.

---

## 🧪 Test Harness

Pageworks includes an end-to-end bash test harness validating CLI commands, error cases, and dogfood documentation:

```bash
./tests/run.sh
```

```text
Running 4 test file(s)...
  ✓ tests/cli/doctor.test.sh (32 passed)
  ✓ tests/cli/export.test.sh (54 passed)
  ✓ tests/cli/init.test.sh (37 passed)
  ✓ tests/integration/dogfood.test.sh (57 passed)

Results: 180 passed, 0 failed
```

---

## 📄 License

MIT © [Alessandro Smedile](https://github.com/alexsmedile)
