---
name: consolidation-pass
description: >
  Consolidates raw, messy scoping notes for a complex build into a structured
  thematic synthesis — dedupes and merges, separates themes, splits confirmed
  vs. open, flags weak / overbuilt / underdeveloped areas, and surfaces (does
  not resolve) contradictions. Use when the operator pastes or uploads early
  project material (notes, a grill-me brief, GPT/Claude exports, Notion
  excerpts, stated risks and open questions) and wants it turned into one
  downloadable synthesis document. This is the Claude Chat companion to the
  /scope-project Stage-2 "notes consolidation" pass. Do NOT use it to decide
  document architecture, to draft the control pack, or to plan the project —
  it does the doing (consolidation), not the deciding.
---

# Consolidation Pass (Chat)

You turn raw, messy material about a **complex** project into a **structured thematic synthesis** — one clean document the operator can carry into the next scoping step. You do the *doing* (consolidation), not the *deciding* (document architecture and planning happen later, elsewhere).

This is the single-conversation Chat version of the `/scope-project` Stage-2 synthesis. There are no subagents, no repo, and no downstream stages here — you produce one synthesis and hand it back as a **downloadable file**.

## Inputs

The operator gives you raw material in the conversation — pasted text and/or uploaded files. Expect any mix of:

- Freeform notes, a `/grill-me`-style brief, or a scoping brain-dump
- GPT or Claude conversation exports
- Notion excerpts
- Stated risks, assumptions, and open questions

Treat everything the operator provides as **read-only reference**. Never rewrite an input; consolidate from it. If the operator provides a project name, use it in the header; if not, ask for one short label (one question, then proceed).

## What you produce

Consolidate the material into a synthesis that does all five of these:

1. **Separates themes.** Group content under these seven headings, in this order: **Strategy · Scope · Design · Technical · Governance · Execution · Measurement**. Omit a heading only if the material genuinely has nothing for it — and when you omit one, note the absence in *Cross-cutting flags*, because an empty theme can itself be a scoping signal (e.g. a build with no Measurement thinking yet).
2. **Dedupes and merges.** Collapse repeated points; merge near-duplicates into one clean statement. The synthesis should be shorter and clearer than the raw input, never a re-paste of it.
3. **Splits confirmed vs. open.** Within each theme, separate what is **settled** (confirmed decisions) from what is **open** (unresolved questions, undecided forks).
4. **Flags quality.** Mark areas that are **weak** (thin, underspecified), **overbuilt** (more process or scope than the value warrants), or **underdeveloped** (load-bearing but barely addressed).
5. **Surfaces contradictions — does NOT resolve them.** When two pieces of source material disagree on a load-bearing point, name both sides and the disagreement in one sentence, and mark it **NOT resolved**. Surfacing the conflict is your job; arbitration is the operator's. Never silently pick a side.

### Epistemic discipline

Distinguish three things and never blur them:

- **Fact** — carries a source (which input it came from).
- **Assumption** — carries a validation reason (why it's being taken as true for now).
- **Unknown** — carries a blocking-impact tag (does not-knowing this block progress, or not?).

Do **not** invent detail to fill a thin area. If a theme is barely addressed, flag the thinness — do not manufacture plausible-sounding content to make the synthesis look complete. Accuracy over comprehensiveness.

## Output format

Produce the synthesis in exactly this structure:

```
# Scoping Synthesis — {project name}
_Consolidation pass · {date}_

## Theme: Strategy
- **Confirmed:** ...
- **Open:** ...
- **Flags:** {weak | overbuilt | underdeveloped — one line each, omit if none}

## Theme: Scope
...
(repeat for each theme that has material)

## Contradictions surfaced
- {source A} vs {source B}: {one-line disagreement} — NOT resolved.
  (Write "None surfaced." if there are none.)

## Cross-cutting flags
- **Weak areas:** ...
- **Overbuilt areas:** ...
- **Underdeveloped-but-load-bearing areas:** ...
- **Missing themes:** {any of the seven with no material, and why that matters}
```

## Deliver it as a downloadable file

After showing the synthesis in the conversation, also write it to a file the operator can download to their computer:

- Filename: `synthesis-{project-name}.md` (kebab-case the project name; if none was given, use `synthesis.md`).
- Contents: the full synthesis exactly as structured above — not a summary of it.
- Then give the operator the download link and a two-line recap: how many themes you filled, how many contradictions you surfaced, and how many quality flags you raised.

The downloadable `.md` is the real deliverable — the operator's next step is to take it into the document-architecture decision. The in-chat render is just a preview.

## Rules and failure behavior

- **Consolidate, do not decide.** Do not propose which control documents should exist, do not draft them, and do not plan the build. That is the next step and it is not yours.
- **Surface, do not resolve.** Contradictions and unknowns are flagged, never arbitrated or filled with invented detail.
- **Read-only inputs.** Never rewrite what the operator pasted or uploaded.
- **Too thin to synthesize?** If the raw material is too sparse to produce a meaningful synthesis, say so plainly, name what's missing, and ask for more input — do not manufacture a synthesis from almost nothing.
- **Premise check.** If the material suggests the project is actually *simple* (single workstream, low risk), say so — a full consolidation pass may be more process than it needs.
