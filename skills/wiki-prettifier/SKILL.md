---
name: wiki-prettifier
description: |
  Aesthetic & UX refactoring engine for technical documentation and wikis.
  Transforms raw Markdown into scannable, Stripe/Tailwind-quality developer portals:
  action headings, multi-tool tabs, copy-paste outputs, semantic alerts, 5-column tables,
  and interactive Mermaid.js diagrams.
compatibility: "commonmark >= 0.30"
metadata:
  version: "0.2.0"
  category: "devtools"
  status: "published"
  tags: "documentation, styling, formatting, markdown, developer-experience, mermaid"
---

# Wiki Prettifier

Aesthetic & UX refactoring engine for technical documentation.

## 1. Quick Guard & Off-Switch

Inspect a target Markdown file before transformation:
```bash
bash "${WIKI_PRETTIFIER_DIR:-skills/wiki-prettifier}/scripts/prettify" audit <path/to/file.md>
```

**Off-Switch**: If the document already uses active headings, multi-tool tabs, tables, and Mermaid charts, preserve it as-is. Never restructure for restructuring's sake.

## 2. Operation Routing Matrix

| Operation | User Intent / Trigger | Action & Reference |
|---|---|---|
| `all` | Full 8-step aesthetic overhaul on file or folder | Load [references/components.md](references/components.md) + [references/transformations.md](references/transformations.md) |
| `hero` | Refactor passive title into H1 + subtitle | Load [references/transformations.md](references/transformations.md) $\to$ apply Hero Pass |
| `tabify` | Fold multi-language/tool commands into tabs | Load [references/components.md](references/components.md) + [references/platforms.md](references/platforms.md) |
| `diagramify` | Convert ASCII art or text flows to Mermaid | Load [references/components.md](references/components.md) $\to$ build `flowchart`/`sequenceDiagram` |
| `tabulate` | Convert bulleted parameter lists to tables | Load [references/components.md](references/components.md) $\to$ build 5-column table |
| `calloutify` | Convert inline warnings to semantic alerts | Load [references/components.md](references/components.md) $\to$ inject `> [!ALERT]` |
| `codify` | Strip `$`, tag languages, attach output blocks | Run `scripts/prettify strip-prompts` $\to$ attach expected outputs |
| `designer` | Apply theme tokens and custom CSS styling | Load [references/designer-mode.md](references/designer-mode.md) $\to$ configure presets |
| `mesh` | Insert Prerequisites & Next Steps footer | Load [references/components.md](references/components.md) $\to$ eliminate dead ends |

## 3. The 8 Core Portal Components

1. **Hero Subtitle**: 1-sentence plain English value proposition beneath H1.
2. **Prerequisites Block**: Explicit check commands before execution.
3. **Multi-Tool Tabs**: Switchers for `pnpm` · `npm` · `yarn` · `curl`.
4. **Command & Output Pairs**: Self-contained snippets + expected returns.
5. **Semantic Alerts**: `[!NOTE]`, `[!TIP]`, `[!IMPORTANT]`, `[!WARNING]`, `[!CAUTION]`.
6. **Mermaid Diagrams**: Interactive flowcharts & sequence diagrams.
7. **5-Column Tables**: `Parameter | Type | Required | Default | Description`.
8. **Next Steps Footer**: Links to next logical runbooks and specs.

## 4. Report Format

```text
┌─ PRETTIFIER · <operation> · <target-file>
│ passes    <hero · verbs · tabs · diagrams · tables · callouts · codify · mesh>
│ effect    <summary of components injected>
│ next      <preview locally or commit>
└─
```
