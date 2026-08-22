# Target Platform Formatting — Adapters for SSGs and Markdown Runtimes

Use this when: Formatting tab switchers, callout alerts, or diagrams for specific static site generators (MkDocs Material, Docusaurus v3+, Starlight, GitHub GFM).

---

## 1. Syntax Comparison Matrix

| Component | MkDocs Material | Docusaurus v3+ | GitHub / Portable GFM |
|---|---|---|---|
| **Multi-Tool Tabs** | `=== "pnpm"` superfences | `<Tabs><TabItem>` JSX | Sequential tagged code blocks |
| **Callout Alerts** | `!!! note` or `> [!NOTE]` | `:::note` or `> [!NOTE]` | `> [!NOTE]` (GFM syntax) |
| **Mermaid Charts** | ````mermaid` superfences | ````mermaid` MDX support | ````mermaid` native render |
| **Code Copy** | `content.code.copy` feature | Native built-in on hover | Native GitHub UI button |

---

## 2. Recommendation: Universal GFM Baseline

By default, `wiki-prettifier` outputs **GitHub Flavored Markdown (GFM)** baseline syntax (`> [!NOTE]`, standard 5-column tables, standard Mermaid code blocks).

This ensures the document renders properly on:
1. GitHub web previews & Pull Requests.
2. MkDocs Material (via Markdown extensions).
3. Docusaurus v3+ (via GFM remark plugins).
4. Any standard Markdown reader or IDE preview.
