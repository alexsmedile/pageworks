# Quality Gates — The 5 Deterministic Layers & LLM Semantic Review

Use this when: Verifying documentation quality, auditing against markdownlint, Vale, or lychee rules, or performing LLM semantic reviews on a doc page.

---

## 1. The 5 Quality Layers

```
┌────────────────────────────────────────────────────────┐
│ Layer 5: Executable Docs (Run bash/code blocks in CI)  │
├────────────────────────────────────────────────────────┤
│ Layer 4: Metadata & Ownership (pageworks doctor)       │
├────────────────────────────────────────────────────────┤
│ Layer 3: Link & Deep Anchor Validation (lychee)        │
├────────────────────────────────────────────────────────┤
│ Layer 2: Prose, Style & Spell Checking (Vale, cspell)  │
├────────────────────────────────────────────────────────┤
│ Layer 1: Syntax & Markdown Structure (markdownlint)    │
└────────────────────────────────────────────────────────┘
```

---

## 2. Plausible LLM Semantic Review Gate

While deterministic linters enforce syntax, the **LLM Reviewer** evaluates:
- **Code-to-Doc Parity & Drift**: Comparing code signatures with doc examples.
- **"Curse of Knowledge"**: Catching unexplained acronyms or assumed prerequisites.
- **Step Completeness**: Flagging missing intermediate setup commands.
- **Diátaxis Compliance**: Preventing tutorial sprawl in pure reference specs.
