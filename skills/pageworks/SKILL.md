---
name: pageworks
description: |
  Author, inspect, audit, and export public-facing software documentation in docs/ using the
  Dual-Dimension Architecture (extensible page classes + 6 topic categories). Triggers on: "init docs",
  "scaffold documentation", "create tutorial", "new ADR", "add runbook", "review docs", "audit stale documentation",
  "docs drift", "pageworks touch", "pageworks doctor", "export to MkDocs/Docusaurus/Mintlify".
  Do NOT trigger for repository README.md, work-item tracking docs (CHANGELOG.md, TODO.md), or code docstrings.
compatibility: "spectacular >= 2.0.0"
metadata:
  version: "0.4.0"
  category: "devtools"
  status: "published"
  tags: "documentation, docs, mkdocs, docusaurus, mintlify, wiki, diataxis"
---

# Pageworks

Orchestrator for public-facing software & platform documentation (`docs/`). Standalone skill package with bundled deterministic scripts.

## 1. Quick Guard & Off-Switch

Run mechanical health checks via the bundled script:
```bash
bash "${PAGEWORKS_SKILL_DIR:-skills/pageworks}/scripts/pageworks" doctor
```

## 2. Operation Routing Matrix

| Operation | Scope & Type | Natural Language User Intent / Trigger Phrases | Action & Reference Loaded |
|---|---|---|---|
| `init` | CLI / Engine | *"Start docs", "Scaffold documentation", "Setup wiki", "pageworks init --preset platform"* | Load [references/contract.md](references/contract.md) $\to$ run `bash "${PAGEWORKS_SKILL_DIR:-skills/pageworks}/scripts/pageworks" init` |
| `new <page>` | Skill / Authoring | *"Create a tutorial", "Add runbook for secret rotation", "New ADR", "Add troubleshooting guide", "Scaffold cookbook page"* | Load [references/authoring.md](references/authoring.md) + [references/page-types.md](references/page-types.md) |
| `review <page>` | **Micro Quality Gate**<br>(Single Page) | *"Review this draft", "Check this page for clarity", "Improve the tone of this guide", "Check runnable code snippets", "Review ADR"* | Load [references/authoring.md](references/authoring.md) + [references/quality-gates.md](references/quality-gates.md) + [references/prose-patterns.md](references/prose-patterns.md) |
| `audit` | **Macro Health & Drift**<br>(Entire Docs Surface) | *"Are my docs out of date?", "Audit stale pages", "Check drift against codebase", "Did upstream code change?", "Run drift audit"* | Load [references/maintenance.md](references/maintenance.md) + [references/contract.md](references/contract.md) $\to$ audit `synced_from:` & 180-day staleness |
| `doctor [--fix]` | CLI / Mechanical | *"Are my docs broken?", "Check frontmatter errors", "Validate internal links", "Check folder depth", "Run doctor", "Fix docs errors"* | Load [references/contract.md](references/contract.md) $\to$ run `bash "${PAGEWORKS_SKILL_DIR:-skills/pageworks}/scripts/pageworks" doctor [--fix]` |
| `touch <page>` | CLI / Freshness | *"Mark as reviewed", "Reset staleness clock", "Acknowledge doc review", "Page is still accurate", "pageworks touch <page>"* | Run `bash "${PAGEWORKS_SKILL_DIR:-skills/pageworks}/scripts/pageworks" touch <page>` (updates `last_reviewed:` to today) |
| `status` | Skill / Inventory | *"How many docs do we have?", "Docs status", "Show documentation inventory", "List unreviewed drafts"* | Load [references/contract.md](references/contract.md) $\to$ report section & category state |
| `theme` | Skill / Design | *"Customize docs theme", "Change docs colors", "Designer mode", "Nordic cyan theme", "Stripe indigo preset"* | Load [references/designer-mode.md](references/designer-mode.md) $\to$ configure palette & custom CSS variables |
| `export <renderer>` | CLI / Generator | *"Build docs site", "Setup MkDocs", "Export to Docusaurus", "Generate mint.json", "Setup Mintlify", "Generate mkdocs.yml", "Docker preview"* | Load [references/renderers.md](references/renderers.md) $\to$ run `bash "${PAGEWORKS_SKILL_DIR:-skills/pageworks}/scripts/pageworks" export` |

> [!NOTE]
> **Micro (`review`) vs. Macro (`audit`)**:
> - **`review <page>`** is a **micro-inspection** of a single page: prose clarity, tone, Diátaxis quadrant fit, alert formatting, and copy-paste runnable snippet verification.
> - **`audit`** is a **macro-scan** across the entire documentation tree: flagging 180-day stale pages, broken cross-links, and upstream git drift on `synced_from:` targets.

## 3. The Dual-Dimension Architecture

- **Extensible Page Classes**: Core baseline (`tutorial`, `how-to`, `adr`, `reference`, `service-catalog`, `postmortem`, `explanation`) + extended formats (`migration`, `troubleshooting`, `cookbook`, `design-spec`) + domain custom types.
- **6 Topic Categories**: `getting-started/`, `architecture/`, `services/`, `operations/`, `reference/`, `standards/`.
- **Governance**: Shallow hierarchy ($\le 3$ levels), explicit `owner:`, and Dual-Layer drift maintenance (Layer 1 Mechanical in CI/Doctor + Layer 2 Skill-Driven Semantic Review in Agent).

## 4. Report Format

```text
┌─ PAGEWORKS · <operation> · <target>
│ effect    <scaffolded / reviewed / exported files>
│ status    <health summary / doctor verdict>
│ next      <next action or preview command>
└─
```
