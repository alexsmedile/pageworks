# pageworks

**Write docs that don't rot.**

Pageworks is a Claude Code / Codex skill + CLI that owns the public-facing documentation surface of a project: scaffold, schema, page authoring, renderer export, and drift detection as specs change.

It's the answer to "we should document this" — without inheriting half a docs framework.

---

## What it does

- **Scaffolds** `docs/` with a clean, renderer-agnostic structure (manifest + flat sections + Diátaxis page templates)
- **Authors** pages from page-type templates (tutorial / how-to / reference / explanation) with consistent voice
- **Exports** to MkDocs Material or Docusaurus — generated configs + a working GitHub Pages workflow
- **Validates** with `pageworks doctor` — schema, frontmatter, orphan files, freshness
- **Maintains** docs against drift — flags pages whose source spec changed since last update

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

[spectacular](https://github.com/alexsmedile/spectacular) is pageworks's sibling — it owns the *internal* workspace (`.spectacular/`: PRDs, specs, plans, requests). Pageworks owns the *external* workspace (`docs/`).

Both are designed to coexist:

- Spectacular discovers pageworks via `spectacular doctor docs` (discovery-only)
- After archiving a spec change, spectacular prompts you to update docs — handed off to pageworks
- Pageworks runs perfectly fine without spectacular too

If you have spectacular installed at v1.1.x or earlier, its built-in `docs init|export|doctor` commands still work but are deprecated as of spectacular v1.2.0 — pageworks supersedes them. They'll be removed in spectacular v2.0.0.

## Page-type templates (Diátaxis)

Pageworks scaffolds and reviews pages against the [Diátaxis](https://diataxis.fr/) framework:

| Quadrant | Purpose | When to write one |
|---|---|---|
| Tutorial | Learning by doing | Onboarding a new user |
| How-to | Solve a specific problem | Recipe-style task guides |
| Reference | Look up exact details | API, CLI, schema docs |
| Explanation | Understand the why | Architecture decisions, mental models |

`pageworks new <page>` asks which quadrant; the right template is used.

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
