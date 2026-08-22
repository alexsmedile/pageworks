# Quality Gates — The 5 Deterministic Layers & LLM Semantic Review

Use this when: Configuring CI/CD documentation pipelines, setting up automated linters (markdownlint, Vale, lychee, cspell), running executable code-block tests, or executing LLM semantic PR reviews.

---

## 1. The 5 Layers of Automated Deterministic Quality

Deterministic tools catch 100% of syntax errors, dead links, spelling mistakes, and schema violations before PRs merge:

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

### Layer 1: Syntax & Markdown Structure (`markdownlint`)

Catches broken heading hierarchies, unclosed HTML elements, and formatting inconsistencies.

#### `.markdownlint.json`
```json
{
  "default": true,
  "MD013": false,
  "MD025": { "level": 1 },
  "MD033": { "allowed_elements": ["details", "summary", "kbd", "Tabs", "TabItem"] }
}
```

---

### Layer 2: Prose, Style & Technical Spelling (`Vale` + `cspell`)

Enforces active voice, technical accuracy, readability grades, and prevents condescending filler (*"simply"*, *"obviously"*).

#### `.vale.ini`
```ini
StylesPath = styles
MinAlertLevel = warning

Packages = Google, write-good, Readability

[*.md]
BasedOnStyles = Vale, Google, write-good
write-good.E-Prime = NO
```

#### `.cspell.json`
```json
{
  "version": "0.2",
  "language": "en",
  "words": [
    "pageworks",
    "diataxis",
    "docusaurus",
    "mkdocs",
    "mermaid",
    "superfences",
    "postmortem",
    "runbook",
    "healthz",
    "kubeconfig"
  ],
  "ignorePaths": ["node_modules/**", "_site/**", "build/**"]
}
```

---

### Layer 3: Link & Deep Anchor Integrity (`lychee`)

Validates internal relative paths, external HTTP endpoints, and `#deep-anchor-links`:

```bash
lychee --exclude-mail --max-concurrency 8 "docs/**/*.md"
```

---

### Layer 4: Metadata & Ownership Governance (`pageworks doctor`)

Validates `docs.yaml` manifest integrity, required frontmatter fields (`owner:`, `last_reviewed:`, `status:`), maximum 3-level folder depth, and 180-day staleness thresholds.

---

### Layer 5: Executable Documentation (Testing Code Blocks)

Extracts and executes runnable bash commands in temporary sandboxes to guarantee code snippets don't crash against live environments (`pytest-codeblocks` or `cmdrun`).

---

## 2. Plausible LLM Semantic Review Gate

While deterministic linters enforce syntax, the **LLM Semantic Reviewer** (`pageworks review`) evaluates clarity, logic, code parity, and audience empathy:

| Evaluation Layer | Deterministic Linter (`vale`, `lychee`) | LLM Review Agent (`pageworks review`) |
|---|---|---|
| **Broken Links & 404s** | 100% accurate (deep anchor checks). | Inefficient (hallucinates HTTP codes; use lychee). |
| **Spelling & Syntax** | Enforces hard dictionary / regex rules. | Evaluates flow, tone, and readability. |
| **Code-to-Doc Parity** | Blind to code changes. | Compares doc PR against code diffs to catch drift. |
| **"Curse of Knowledge"** | Cannot evaluate audience comprehension. | Flags unexplained internal acronyms & assumed knowledge. |
| **Missing Steps** | Cannot detect omitted intermediate commands. | Simulates reader flow: flags missing `cp .env` or `npm i`. |
| **Diátaxis Adherence** | Cannot assess functional purpose. | Enforces Class fitness (Tutorial vs How-To vs ADR). |

---

## 3. LLM Review Prompt Rubric (GitHub Action / PR Bot)

```text
You are a Staff Technical Writer and Senior Platform Architect reviewing a documentation PR.

Evaluate the provided Markdown diff against these 4 pillars:
1. Completeness: Are there missing prerequisites, assumed tribal knowledge, or omitted output blocks?
2. Accuracy & Parity: Do command flags match actual code? Are realistic defaults used over cryptic placeholders?
3. Conciseness: Are there redundant conversational preambles or walls of text exceeding 4 lines per paragraph?
4. Diátaxis Fit: Does the document stay true to its declared class (Tutorial, How-To, Reference, ADR)?

Rules:
- Ignore basic spelling and broken links (handled by deterministic CI linters).
- Provide line-specific, constructive feedback with exact drop-in Markdown replacements.
```

---

## 4. All-in-One CI/CD Pipeline (`.github/workflows/docs-quality.yml`)

```yaml
name: Documentation Quality Gate

on:
  pull_request:
    paths:
      - 'docs/**'
      - '.github/workflows/docs-quality.yml'

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      # 1. Structural Syntax Check
      - name: Lint Markdown Structure
        uses: DavidAnson/markdownlint-cli2-action@v16
        with:
          globs: 'docs/**/*.md'

      # 2. Dead Link & Deep Anchor Checker
      - name: Validate Links and Anchors
        uses: lycheeverse/lychee-action@v2
        with:
          args: --no-progress './docs/**/*.md'
          fail: true

      # 3. Spell Checking
      - name: Check Code & Technical Spelling
        uses: streetsidesoftware/cspell-action@v5
        with:
          files: 'docs/**/*.md'

      # 4. Pageworks Metadata & 180-Day Governance
      - name: Run Pageworks Doctor
        run: ./skills/pageworks/scripts/pageworks doctor
```
