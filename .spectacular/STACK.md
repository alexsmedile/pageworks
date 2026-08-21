---
type: Anchor
id: 01a026aa-936a-7b53-aa2a-79e48a0636b1
human_ref: STACK
title: Stack
direction: Zero-dependency shell scripts and progressively disclosed AI agent skill references.
boundaries:
  - CLI runs across POSIX-compliant environments (macOS, Linux) using standard utilities (`bash`, `awk`, `sed`, `grep`, `curl`).
  - Documentation renderer configurations target standard MkDocs (Material) and Docusaurus toolchains without forcing either into the repository by default.
constraints:
  - Canonical content is UTF-8 Markdown with YAML frontmatter.
  - Manifest is declarative YAML parsed with zero-dependency stream parsing (`awk`).
freshness_checked_at: "2026-08-22T00:00:00Z"
freshness_source: .spectacular/workspace.yaml
freshness_valid_until: "2027-08-22T00:00:00Z"
---
# Stack

Pageworks is built on portable shell scripting and declarative markdown/YAML conventions.

## Runtimes & Tooling
- **Core CLI**: Bash 4+ (`cli/pageworks`), POSIX stream tools (`awk`, `sed`, `grep`, `find`).
- **Skill Engine**: Claude Code / Codex / Antigravity skill architecture (`skills/pageworks/SKILL.md` + on-demand references).
- **Supported Renderers**:
  - **MkDocs**: Python / Material for MkDocs (`mkdocs.yml`).
  - **Docusaurus**: Node.js / React / Docusaurus 3 (`docusaurus.config.js`, `sidebars.js`).
- **CI/CD Deployment**: GitHub Actions GitHub Pages workflow generation.
- **Testing**: Deterministic shell test runner (`tests/run.sh`).
