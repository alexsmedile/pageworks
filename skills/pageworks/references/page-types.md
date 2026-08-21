# Page Types & Classes — The 6 Core Functional Formats

Use this when: Choosing a page format class for `pageworks new`, auditing class fitness in `pageworks review`, or structuring documentation taxonomy.

Pageworks organizes documentation around the **6 Core Classes of Pages**, grounding the [Diátaxis](https://diataxis.fr/) framework in production software and platform engineering workflows.

Every page in a documentation tree must serve a single clear purpose. Mixing these formats leads to unreadable, bloated documentation.

---

## The 6 Core Classes of Pages

| Class | Format / Intent | Stance & Question Answered | Canonical Template | Example |
|---|---|---|---|---|
| **1. Getting Started / Tutorials** | Learning-oriented step-by-step walkthroughs taking a developer from zero to a running environment. | *"I am new here. Take me by the hand."* | `templates/pages/tutorial.md.tmpl` | `getting-started/local-dev-setup.md` |
| **2. How-To Guides / Runbooks** | Problem-oriented practical recipes for specific operational tasks or troubleshooting. | *"I know roughly what I want. Show me the recipe."* | `templates/pages/how-to.md.tmpl` / `runbook.md.tmpl` | `operations/rotate-secrets.md` |
| **3. Architecture Decision Records (ADRs)** | Immutable logs recording architectural choices, evaluated alternatives, context, and trade-offs. | *"Why did we choose this design?"* | `templates/pages/adr.md.tmpl` | `architecture/0004-use-postgres-for-events.md` |
| **4. Technical Reference Specs** | Pure factual information: API contracts, data schemas, CLI flags, configuration variables, error codes. | *"Give me the exact factual details."* | `templates/pages/reference.md.tmpl` | `reference/payment-api-v2.md` |
| **5. Service Catalog Pages** | Standardized one-pagers for microservices/modules: ownership, repos, staging/prod URLs, SLOs, dashboards. | *"What is this service and how do I interact with it?"* | `templates/pages/service-catalog.md.tmpl` | `services/auth-service.md` |
| **6. Incident Postmortems** | Retrospectives on production outages: root cause (5 Whys), impact, timeline, and remediation actions. | *"What failed, how did we recover, and how do we prevent recurrence?"* | `templates/pages/incident-postmortem.md.tmpl` | `operations/2026-05-auth-outage.md` |

*(Note: High-level conceptual overviews and mental models can also use `type: explanation` with `templates/pages/explanation.md.tmpl`).*

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
