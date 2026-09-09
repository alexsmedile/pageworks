# Page Types & Classes — Extensible Formats & Inspiration Baseline

Use this when: Choosing a page format class for `pageworks new`, auditing class fitness in `pageworks review`, or structuring documentation taxonomy.

Pageworks organizes documentation around an **extensible taxonomy of page classes**, grounding the [Diátaxis](https://diataxis.fr/) framework in production software and platform engineering workflows.

> [!TIP]
> **Inspiration Baseline, Not a Straitjacket**:
> These classes serve as a high-leverage starter kit and architectural guide. Every document should have a single, coherent intent (learning, solving a problem, looking up facts, or troubleshooting). Teams can freely declare custom types (`type: ...`) to match domain requirements without failing validation gates.

---

## The Core Classes & Extended Formats

### 1. The Core Baseline Classes
| Class | Format / Intent | Stance & Question Answered | Canonical Template | Example |
|---|---|---|---|---|
| **`tutorial`** | Learning-oriented step-by-step walkthroughs taking a developer from zero to a running environment. | *"I am new here. Take me by the hand."* | `templates/pages/tutorial.md.tmpl` | `getting-started/local-dev-setup.md` |
| **`how-to`** | Problem-oriented practical recipes for specific operational tasks or troubleshooting. | *"I know roughly what I want. Show me the recipe."* | `templates/pages/how-to.md.tmpl` / `runbook.md.tmpl` | `operations/rotate-secrets.md` |
| **`adr`** | Immutable logs recording architectural choices, evaluated alternatives, context, and trade-offs. | *"Why did we choose this design?"* | `templates/pages/adr.md.tmpl` | `architecture/0004-use-postgres-for-events.md` |
| **`reference`** | Pure factual information: API contracts, data schemas, CLI flags, configuration variables, error codes. | *"Give me the exact factual details."* | `templates/pages/reference.md.tmpl` | `reference/payment-api-v2.md` |
| **`service-catalog`** | Standardized one-pagers for microservices/modules: ownership, repos, staging/prod URLs, SLOs, dashboards. | *"What is this service and how do I interact with it?"* | `templates/pages/service-catalog.md.tmpl` | `services/auth-service.md` |
| **`postmortem`** | Retrospectives on production outages: root cause (5 Whys), impact, timeline, and remediation actions. | *"What failed, how did we recover, and how do we prevent recurrence?"* | `templates/pages/incident-postmortem.md.tmpl` | `operations/2026-05-auth-outage.md` |
| **`explanation`** | High-level conceptual overviews, mental models, and background architecture. | *"Help me understand how this fits together."* | `templates/pages/explanation.md.tmpl` | `architecture/overview.md` |

### 2. Extended Industry Benchmark Classes
Inspired by Google Material Design, Anthropic Claude Code, OpenAI Codex, and Docusaurus:

| Class | Format / Intent | Benchmark Inspiration | Canonical Template |
|---|---|---|---|
| **`migration`** | Step-by-step upgrade guides with breaking changes, configuration mapping, and side-by-side diffs. | Docusaurus & Stripe | `templates/pages/migration.md.tmpl` |
| **`troubleshooting`** | Scannable 3-column Symptom $\to$ Cause $\to$ Fix tables, gotchas, and diagnostic commands. | Anthropic Claude Code | `templates/pages/troubleshooting.md.tmpl` |
| **`cookbook`** | Runnable end-to-end integration recipes with multi-language tabs and verified mock outputs. | OpenAI Codex | `templates/pages/cookbook.md.tmpl` |
| **`design-spec`** | Component visual anatomy, design tokens, interaction state matrix, and Do's/Don'ts. | Google Material Design | `templates/pages/design-spec.md.tmpl` |

---

## 1. Getting Started / Tutorial

- **Purpose**: Onboard a new engineer or user. Complete a small, end-to-end, runnable task.
- **Voice**: Imperative, encouraging, linear.
- **Key Sections**:
  - What you will have running at the end
  - Prerequisites (with verify commands)
  - Step-by-step numbered instructions with commands and expected outputs
  - Concrete verification test
  - "What just happened" mental model summary at the end
- **Anti-patterns**:
  - Forking paths ("you could also do Y")
  - Explaining theory before taking action
  - Omitting the verification check

---

## 2. How-To Guides & Runbooks

- **Purpose**: Solve a specific, recurring operational problem.
- **Voice**: Direct, imperative, concise.
- **Key Sections**:
  - When to use this / Alert trigger conditions
  - Escalation paths and prerequisites
  - Step-by-step action items with copy-paste ready commands
  - Verification & Rollback steps
  - Troubleshooting symptom/cause/fix table
- **Anti-patterns**:
  - Digressing into conceptual explanations
  - Bundling multiple unrelated problems into one page

---

## 3. Architecture Decision Records (ADRs)

- **Purpose**: Durable, immutable record of technical choices and trade-offs.
- **Voice**: Objective, analytical, structured.
- **Key Sections**:
  - Status (`proposed | accepted | superseded | rejected`)
  - Context and problem statement (constraints, cost, latency)
  - Decision drivers
  - Considered options (pros and cons)
  - Chosen outcome and rationale
  - Positive and negative consequences (accepted trade-offs)
  - Compliance and verification method
- **Anti-patterns**:
  - Decisions in a vacuum without stating evaluated alternatives
  - Altering historic ADRs instead of creating superseding records

---

## 4. Technical Reference Specs

- **Purpose**: Fast lookup for parameters, flags, schemas, and endpoints.
- **Voice**: Factual, structured, exhaustive.
- **Key Sections**:
  - Summary lookup tables
  - Signatures, headers, and parameter definitions
  - Request and response payload schemas
  - Concrete minimal examples
  - Error codes and HTTP status mapping
- **Anti-patterns**:
  - Prose narrative and storytelling
  - Hiding optional parameters in paragraphs

---

## 5. Service Catalog Pages

- **Purpose**: The definitive one-pager for every system component or microservice.
- **Voice**: Standardized, concise, link-rich.
- **Key Sections**:
  - Owning team, primary on-call rotation, and Slack channel
  - Repository, staging, and production URLs
  - Mermaid topology / dependency diagram
  - SLOs (Availability, Latency, Error Rate)
  - Upstream and downstream dependencies
  - Local dev setup and health check endpoints (`/healthz`)
- **Anti-patterns**:
  - Outdated contact information
  - Missing health check and rollback links

---

## 6. Incident Postmortems

- **Purpose**: Blameless retrospectives on production outages and incidents.
- **Voice**: Blameless, factual, chronological.
- **Key Sections**:
  - Executive summary (downtime, impact, resolution)
  - Customer and business impact metrics
  - Timestamped timeline (UTC)
  - Root cause analysis (5 Whys)
  - What went well / where we got lucky
  - Action items table with assigned owners, ticket IDs, and deadlines
- **Anti-patterns**:
  - Assigning individual blame
  - Action items without explicit owners or target dates

---

## 7. Migration & Upgrade Guides (`migration`)

- **Purpose**: Guide developers safely through breaking API changes, version upgrades, and deprecated configurations.
- **Voice**: Authoritative, reassuring, change-focused.
- **Key Sections**:
  - Breaking changes bullet summary (what broke and why)
  - Pre-upgrade readiness checklist
  - Step-by-step dependency and code transformations
  - Before/after code blocks (Legacy vs Modern)
  - Configuration key translation table
  - Automated verification test command & rollback instructions
- **Anti-patterns**:
  - Hiding breaking changes in general release notes
  - Showing "after" code without showing the corresponding "before" pattern

---

## 8. Troubleshooting & Gotchas Guides (`troubleshooting`)

- **Purpose**: Rapidly unblock developers facing errors, timeouts, or unexpected behavior.
- **Voice**: Scannable, direct, solution-first.
- **Key Sections**:
  - "Punchline first": First diagnostic command to isolate symptoms
  - 3-column Symptom $\to$ Root Cause $\to$ Fix table
  - Common gotchas & architectural edge cases (clock skew, header normalization, port collisions)
  - Deep diagnostic commands (trace dumps, network inspections)
- **Anti-patterns**:
  - Long theoretical introductions before giving the solution
  - Omitting the exact error string or exit code

---

## 9. Cookbook & Integration Recipes (`cookbook`)

- **Purpose**: Provide copy-paste runnable recipes solving specific multi-system integration challenges.
- **Voice**: Pragmatic, code-centric, complete.
- **Key Sections**:
  - End-to-end integration problem statement and prerequisites
  - Architecture sequence diagram (Mermaid.js)
  - Multi-language implementation tabs (Node.js, Python, Go, etc.)
  - Complete, runnable snippets with inline verification commands
  - Realistic mock request payloads and expected response outputs
- **Anti-patterns**:
  - Incomplete snippets requiring external imports that aren't defined
  - Skipping payload validation or security verification (e.g. HMAC signatures)

---

## 10. Design Specs & Visual Anatomy (`design-spec`)

- **Purpose**: Establish design tokens, visual anatomy, interaction states, and accessibility standards for UI components.
- **Voice**: Systematic, visually precise, structured.
- **Key Sections**:
  - Component status & Figma library link
  - Visual anatomy ASCII or Mermaid callout diagram
  - Design token table (dimensions, padding, border radius, fonts, colors)
  - Interactive state matrix (Default, Hover, Active, Focus, Disabled)
  - Do's and Don'ts comparison table
  - Accessibility (WCAG AA) keyboard and contrast specifications
- **Anti-patterns**:
  - Designing in isolation without specifying token variable names
  - Leaving accessibility requirements implicit
