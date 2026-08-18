---
model: opus
description: Shared research entry — classify a question as Light, Standard or Deep, then dispatch it. Light runs here and produces an evidence-controlled note; Deep hands off to the deployed Research Workflow.
---

# /research-route

One entry for research work of every size. The operator brings a question or a brief; this
command decides how much control the work needs and then does the work at that level — it is
not a menu and it does not just print a route name.

The request follows this prompt: $ARGUMENTS

**Why one entry.** Most research asks are small and get over-served by the five-stage Research
Workflow; a few are load-bearing and get under-served by a quick answer. Choosing the level is
the part people get wrong, so the entry chooses, conservatively, before any work starts.

**Naming note.** The lean proposal called this `/research`. That name is taken by a built-in
Claude Code skill, so the entry is `/research-route` instead. Nothing else about the proposal's
three-route idea changed.

---

## Step 1 — Read the request and note any preference

Read `$ARGUMENTS`. Extract two things:

- **The question or brief** — what is actually being asked.
- **The route preference, if the operator stated one** — words like "quick", "just a light
  read", "run the full thing". Record it as `light`, `standard`, `deep` or `none`.

A preference is a **preference, not permission**. It can raise the route. It can never lower it
below the floor Step 3 computes. If the operator asked for Light and the signals say otherwise,
you say so out loud and run the higher route.

## Step 2 — Assess the six signals

Assess each signal from the request. Every signal takes exactly one of its listed values, and
`unclear` is a real answer — use it rather than guessing.

| Signal | Values | What it asks |
|---|---|---|
| `output` | `note` \| `analysis` \| `report` \| `unclear` | What does the result have to be? A compact read-out, a reasoned analysis, or a full report? |
| `consequence` | `internal` \| `external` \| `unclear` | Does the result stay inside the firm, or reach a client, a prospect, a publication or a public channel? |
| `scope` | `bounded` \| `broad` \| `unclear` | Can this be settled from evidence already at hand or a small named set, or does it need a research programme? |
| `load_bearing_claim` | `yes` \| `no` \| `unclear` | Does a conclusion rest on a specific claim that must be right? |
| `thesis_judgment` | `yes` \| `no` \| `unclear` | Is a thesis-grade judgment or recommendation being asked for, rather than a factual read? |
| `preference` | `light` \| `standard` \| `deep` \| `none` | What Step 1 recorded. |

**Guessing to avoid `unclear` is the failure this step exists to prevent.** `unclear` costs one
level of extra control. A wrong `no` on `load_bearing_claim` costs a wrong answer someone acts on.

## Step 3 — Resolve the route

Route rank is `light` < `standard` < `deep`. Compute the **floor** from the rules below — the
highest floor any matching rule sets — then take the higher of the floor and the preference.
Escalation is **one way**: nothing lowers the floor.

```
<!-- route-rules:start -->
FLOOR deep output=report
FLOOR deep scope=broad
FLOOR standard output=analysis
FLOOR standard consequence=external
FLOOR standard load_bearing_claim=yes
FLOOR standard thesis_judgment=yes
FLOOR standard output=unclear
FLOOR standard consequence=unclear
FLOOR standard scope=unclear
FLOOR standard load_bearing_claim=unclear
FLOOR standard thesis_judgment=unclear
BASE light
<!-- route-rules:end -->
```

Read as prose: **Deep** when the ask is a report or the scope is broad. **Standard** when the ask
is an analysis, the result goes outside the firm, a load-bearing claim is in play, a thesis-grade
judgment is wanted, or any signal is unclear. **Light** only when none of that is true.

That block is the single source of the routing rules. `logs/scripts/research-route-classify.sh`
parses it out of this file rather than holding its own copy, so the rules cannot drift apart.
You may run it to check your own resolution, but it is not required — the table above is
complete on its own, which is what lets this command work in a project that has only this file:

```bash
bash logs/scripts/research-route-classify.sh --entry .claude/commands/research-route.md \
  --preference none \
  --signal output=note --signal consequence=internal --signal scope=bounded \
  --signal load_bearing_claim=no --signal thesis_judgment=no
```

**Announce the resolution in one line before dispatching**, naming the route, the rule that set
the floor, and — when a preference was overridden — that it was, and why:

```
Route: Standard (floor set by load_bearing_claim=yes). You asked for Light; a load-bearing
claim cannot be settled on the Light route, so this runs as Standard.
```

Then go to the matching section below and do nothing from the other two.

---

## Light — produce the note now

Light work runs here, in this session, from evidence **already at hand**: what the operator
supplied, what is in the repository, and what is in the conversation. Light does not fetch,
search the web, call an API or start a retrieval run. If the question cannot be answered from
evidence at hand, that is not a Light question — return to Step 3 and take the higher route.

Produce a compact research note in exactly this shape:

```markdown
# {question, restated in one line}

## Answer
{two to five sentences. The direct answer, nothing else.}

## Evidence
- [EVIDENCE] {the finding, stated plainly}
  Source: {file path, document title, or who supplied it} — Date: {of the source, or "undated"}
- [EVIDENCE] {…}

## Reasoning
- [INFERENCE] {what you concluded that the evidence does not state outright, and from which
  evidence items you concluded it}

## Gaps
- {what would change the answer and is not known; or "None material."}
```

Four rules make that note honest, and they are the whole point of the Light route:

- **Every material claim carries a source and a date.** A claim you cannot attribute is not
  evidence — move it to `[INFERENCE]` or to `Gaps:`.
- **`[EVIDENCE]` and `[INFERENCE]` are never merged.** Evidence is what a source says.
  Inference is what you concluded. A reader must be able to accept one and reject the other.
- **Gaps are stated, never smoothed over.** "None material." is a claim you are making; only
  write it if you mean it.
- **Nothing is invented.** No source you did not read, no date you did not see, no figure you
  reconstructed from memory. A missing fact is a gap.

**Escalate mid-note if the work turns out heavier than the signals said.** If producing the note
exposes a load-bearing claim, an external-consequence use, a thesis-grade judgment, or scope
beyond the evidence at hand, stop, say which one appeared, and re-run Step 3 with that signal
corrected. A Light note is never completed once one of those has surfaced — that is the same
one-way escalation as Step 3, applied after work has started.

---

## Standard — not yet implemented

Standard is the middle route: an evidence-controlled analysis that is heavier than a note and
lighter than the five-stage workflow. **It is not implemented yet.** It is the next unit of this
lane's work.

Say exactly that, and stop:

```
Route: Standard. The Standard route is not yet implemented — it is the next unit of the
lightweight Research Workflow lane. Your options now: narrow the question until it is genuinely
answerable from evidence at hand (Light), or run it through the deployed Research Workflow
(Deep). Say which and I will take it from there.
```

Then do nothing further on this request. Do not produce a Standard analysis, do not approximate
one from the Light template, and do not label partial output as complete — an honest stop is the
deliverable here, and a fabricated analysis would be worse than no route at all.

**No House View, judgment, approval or authority mechanism belongs on this route.** That contract
is owned elsewhere and is not settled yet. Do not invent it, do not stub it, and do not reference
one as though it existed.

---

## Deep — hand off to the deployed Research Workflow

Deep work runs in the existing five-stage Research Workflow, in a project deployed from
`workflows/research-workflow/`. This command hands the work over. It does not reimplement,
copy or shortcut that pipeline.

**If a deployed research project already exists for this work**, name it and give the operator
the entry and its prerequisite:

```
Route: Deep. This goes to the deployed Research Workflow in {project}.

Entry: /run-preparation, run from inside {project}.
Prerequisite: a filled task plan draft at
  preparation/task-plans/{section}-task-plan-draft.md
  — its objective, scope, constraints and audience are what Stage 1 reads.

Next: fill that draft, then run /run-preparation there. Stage 1 will pause for your
approval at the Task Plan and again at the Research Plan.
```

**If no deployed project exists**, say so and point at the deployment checklist rather than
improvising one:

```
Route: Deep. No research project is deployed for this work yet.

Deploy one first: workflows/research-workflow/SETUP.md — steps 1 through 9 (copy the
template, grant ai-resources visibility, fill the CLAUDE.md placeholders, create the skill
symlinks, instantiate the reference files, configure confidentiality boundaries, and write
the initial task plan draft).

Then run /run-preparation from inside the new project.
```

Do not run any stage of the deep pipeline from here, and do not edit anything under
`workflows/research-workflow/` — it is a handoff target, not a work surface.
