# Page Types — Diátaxis Quadrants

Pageworks organizes every doc page into one of four [Diátaxis](https://diataxis.fr/) quadrants. Each has a distinct purpose, a distinct reader stance, and a distinct template.

Loaded when:
- `pageworks new <page>` (deciding which type to use)
- `pageworks review` (checking a page is well-fitted to its declared type)
- Skill orchestrator needs to recommend a page type to the user

## The four quadrants

|  | **Practical** | **Theoretical** |
|---|---|---|
| **Acquisition** (learning) | **Tutorial** | **Explanation** |
| **Application** (working) | **How-to** | **Reference** |

Read across the rows: the top half is for someone learning *about* the system; the bottom half is for someone using it. Read down the columns: the left is hands-on; the right is hands-off.

## Tutorial

**Stance:** "I am new here. Take me by the hand."

**Job:** Teach by doing. Build something concrete, small, complete. Optimize for the feeling of success and the formation of an initial mental model.

**Reader voice:** *I followed it and it worked.*

**Properties**
- Verb-led title: "Build your first X", "Get started with Y"
- Imperative voice throughout
- One linear path — no choose-your-own-adventure
- Concrete, named artifacts ("create a file called `index.md`")
- Shows expected output for every step
- Explains *what just happened* at the end, not during
- Estimated time in frontmatter
- Prerequisites listed but not taught

**Anti-patterns**
- Trying to cover all options ("you could also do…") → split into how-tos
- Theory before doing → explanation belongs at the end
- Skipping verification → the reader must confirm success themselves

**Template:** `templates/pages/tutorial.md.tmpl`

## How-to

**Stance:** "I know roughly what I want. Show me the recipe."

**Job:** Solve a specific, named problem. Assume competence. Get out of the way.

**Reader voice:** *That's exactly what I needed.*

**Properties**
- Title starts "How to…" — named outcome
- Scoped to a single goal
- Steps are imperative, short, numbered
- Lists alternatives where they're real ("for npm: X / for yarn: Y")
- Troubleshooting table for known failure modes
- Links to reference for command details rather than inlining them
- `applies_to:` frontmatter when scenario-specific

**Anti-patterns**
- Teaching concepts ("first, let's understand X") → wrong quadrant
- Multiple outcomes in one page → split
- Hiding the steps inside paragraphs → readers scan how-tos, don't read them

**Template:** `templates/pages/how-to.md.tmpl`

## Reference

**Stance:** "I need the exact details. Just the facts."

**Job:** Be the authoritative, structured source for what something *is* — its options, parameters, return values, schema. Optimize for fast lookup.

**Reader voice:** *I found it in 5 seconds.*

**Properties**
- Noun-led title: "CLI commands", "Configuration schema", "API endpoints"
- Heavily repetitive structure — same fields, same order, every entry
- Tables for parameters, options, fields
- Minimal prose; let structure do the work
- Examples are minimal — one input, one output
- Versioned (`since:`, deprecation notices inline)
- Status: usually `stable`; reference pages don't ship as `draft` for long

**Anti-patterns**
- Narrative ("This command was introduced because…") → belongs in explanation
- Tutorials embedded ("To get started, first run…") → belongs in tutorial
- Inconsistent structure across entries → reference pages must be predictable
- Hiding optional parameters in prose → put them in the table

**Template:** `templates/pages/reference.md.tmpl`

## Explanation

**Stance:** "I want to understand why. Take your time."

**Job:** Build mental models. Explore trade-offs. Connect the system to the world outside it.

**Reader voice:** *Now I get it.*

**Properties**
- Concept- or decision-led title: "Why pageworks doesn't render", "The render-agnostic schema"
- Prose-dominant — connective tissue beats bullets here
- Trade-offs and alternatives stated honestly
- Cites real constraints (perf, ergonomics, team dynamics) over abstract principles
- Diagrams welcome
- Status: `stable` once the concept stabilizes; `draft` while still being worked out

**Anti-patterns**
- How-to steps ("To enable X, first do Y") → wrong quadrant
- Reference details that bloat the explanation → link out
- Marketing tone — "elegant", "powerful", "best-in-class" → factual is more persuasive
- No "the short version" — bury the lede and readers leave

**Template:** `templates/pages/explanation.md.tmpl`

## How to pick a quadrant

Ask:

1. **Will the reader follow your steps end-to-end?**
   - Yes, and they're new → **Tutorial**
   - Yes, and they know the basics → **How-to**
2. **Will the reader scan for a specific fact?** → **Reference**
3. **Does the reader want to understand a concept or decision?** → **Explanation**

If two answers feel right, the page is doing two jobs — **split it**. Single-quadrant pages are a forcing function for clarity.

## Cross-quadrant linking

Each page type links naturally to the others:

| From | Often links to |
|---|---|
| Tutorial | Next how-to (apply what you learned), explanation (what just happened, deeper) |
| How-to | Reference (commands/options used), other how-tos (adjacent tasks) |
| Reference | Tutorial (if you're new), how-to (common tasks using this entity) |
| Explanation | How-to (try it out), reference (the entities involved) |

`pageworks review` flags pages with no cross-quadrant links as potentially orphaned — readers should always have a next step.

## Status field semantics by type

| Type | Common `status:` values |
|---|---|
| Tutorial | `draft` → `stable`. Rarely `deprecated` (more often: replaced by a newer tutorial). |
| How-to | `draft` → `stable` → `deprecated` (when the recipe stops working). |
| Reference | Usually `stable` from day one. `deprecated` per entry, not per page. |
| Explanation | Often stays `draft` longer — concepts evolve. `stable` once the framing is settled. |
