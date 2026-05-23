# Prose Patterns

The shared style layer across all doc pages: voice, tone, structure, formatting conventions. Loaded by `pageworks new <page>` (writing) and `pageworks review` (auditing).

Page-type rules live in [`page-types.md`](page-types.md). This file is the cross-cutting layer underneath.

## Voice

**Active over passive.** "Pageworks writes the file" beats "the file is written by pageworks." Passive voice hides who acts.

**Second person, addressed.** "You set this in `docs.yaml`" — direct, instructional. Avoid impersonal "the user" or "one" except in reference pages where the entity, not the reader, is the subject.

**Present tense for behavior.** "The CLI prints the version" — not "will print," not "would print."

**First-person plural for shared journey.** "We'll scaffold the docs/ folder first" — tutorials only. How-tos and reference shed the "we" and address the reader directly.

**No marketing tone.** Drop "elegant," "powerful," "best-in-class," "seamlessly," "robust." Factual statements are more persuasive: "Renders in 200 ms on a 50-page site" > "Lightning-fast performance."

**No apologies.** Don't write "we know this is confusing, but…" — fix the confusion, then write the page. The doc shouldn't acknowledge its own weakness.

**No hedging filler.** Drop "basically," "essentially," "in a nutshell," "simply," "just." If a step is genuinely simple, the brevity of the sentence will say so.

## Sentence shape

**Lead with the verb or the subject, not the qualifier.**

✗ "In order to enable rendering, you first need to install MkDocs."
✓ "Install MkDocs to enable rendering."

**One idea per sentence.** Two ideas separated by "and" or "but" usually want to be two sentences.

**Cap clauses at two.** Three clauses in a row signals a missed paragraph break.

**Numbers as digits** in user-facing prose. "3 pages" not "three pages." Exception: starting a sentence ("Three reasons matter here…").

## Paragraph shape

**First sentence carries the paragraph.** A scanning reader reads only first sentences — those alone should tell the story.

**3–5 sentences per paragraph max.** Longer signals a missed split.

**One thought per paragraph.** Same rule as sentences, scaled up.

**No "wall of text."** If a paragraph hits 6+ lines on screen, break it or convert to a list.

## Lists

**Use a list when the items are parallel.** Three commands, three errors, three options — list. Three things that depend on each other or flow into each other — prose.

**Verb-led for action lists.** "Install MkDocs / Run `pageworks export` / Push to main" — each starts with a verb.

**Noun-led for description lists.** "Tutorial: learning by doing / Reference: structured lookup / Explanation: mental models."

**Consistent grammar within a list.** All items same shape. If one is a sentence, all are sentences. If one ends with a period, all do.

**Numbered when order matters.** Steps are numbered. Options are bulleted. A list of equivalent alternatives is bulleted, not numbered.

**Max nesting depth: 2.** Three levels deep means the structure is wrong — flatten or split.

## Code blocks

**Always declare the language.**

```bash
pageworks init
```

**Show the prompt where the working directory matters.**

```bash
$ cd ~/projects/myapp
$ pageworks init
```

But — when copy-paste fidelity matters, **drop the `$`** so the reader can paste directly.

**Annotate output.**

```
Generated:
  ✓ docs/
  ✓ docs/docs.yaml
```

If output is long, show the meaningful slice and end with `# …` or `# (truncated)`.

**One concept per code block.** Don't bundle install + run + verify into one fenced block — split them so each can be copied individually.

**Comments inside code blocks describe what, not why.** Why goes in prose around the block.

## Links

**Title-style for in-prose links.** "See [page types](page-types.md) for the four quadrants."

**Bare URL for citations or one-off references.** Acceptable when the destination is the content.

**Cross-quadrant links at the end of pages.** "Next: [how to deploy](deploy.md)." Mandatory for tutorials and explanations.

**Never link "click here" or "this."** The link text must describe what's linked.

**Relative links inside docs/.** `[install](getting-started/install.md)`, not `[install](/docs/getting-started/install.md)`. Renderers handle the resolution.

**Anchor links for section deep-links.** `[the renderers: block](contract.md#renderers-block)`.

## Headings

**Sentence case.** "How to deploy to GitHub Pages" — not "How To Deploy To GitHub Pages."

**Heading depth matches structure.** H1 is the page title (frontmatter `title:`); H2 is sections; H3 is subsections. Don't skip levels.

**Max 4 levels.** H5 and H6 are an architecture signal: the page wants to be split.

**Headings name nouns, not summarize verbs.** "Schema" beats "Understanding the schema." "Steps" beats "Here are the steps."

**Two-word minimum, six-word maximum** for most cases. "Configuration" — fine. "How the renderer adapter pipeline resolves themes" — too long, becomes the first sentence instead.

## Callouts

Use sparingly. If every page has three callouts, callouts have lost meaning.

| Type | Use for |
|---|---|
| **Note** | Useful aside the reader can skip without losing the thread |
| **Tip** | Recommendation that improves on the basic path |
| **Warning** | Reader will lose work or break something if they ignore this |
| **Deprecated** | This thing is going away — point at the replacement |

**Format (renderer-agnostic):**

> **Note** — Sentence form. The label is bold, em-dash, then the body. One paragraph max.

**Avoid:** "Important," "Caution," "Heads up," "Pro tip," "FYI." Stick to the four types above so renderers can style them consistently.

## Examples

**Show, then explain.** Code block first, then the prose that interprets it. The reader sees the shape before they read the words.

**Minimal examples.** Show the smallest version that demonstrates the point. Save full examples for a dedicated `examples.md` page if needed.

**Real-looking values, not `foo`/`bar`.** Use `getting-started`, `install`, `mkdocs` — names the reader recognizes from the system. `<placeholder>` for slots the reader fills in.

## Frontmatter as content

Frontmatter is read by the renderer and by `pageworks doctor` — but it's also content. Keep it tight:

- `title:` and `description:` are reader-facing — they appear in nav and SEO. Write them as carefully as a paragraph.
- `description:` is one sentence, ~120 chars, ends with a period.
- `status:` reflects truth. Don't ship `draft` for months without movement; either finish or delete.
- `updated:` matches reality. `pageworks doctor` flags drift between `updated:` and file mtime.

## Anti-patterns specific to docs

- **Acronyms without expansion on first use.** "Use the LLM to…" — fine if the audience is technical and the context is unambiguous. Otherwise spell it out first.
- **Internal jargon in public docs.** Words your team uses that no outside reader has heard. Replace with the industry term or define inline.
- **Documentation about documentation.** "This page describes the things you'll learn about…" — delete; the reader is here, they know what they're reading.
- **The TODO that ships.** `<!-- TODO: explain this better -->` in a published page. `pageworks doctor` flags these; they're never acceptable on `status: stable`.
- **Time-relative phrases.** "Recently," "the new version," "as of now" — what's recent today is stale next month. Cite a version or date.
