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
FLOOR deep thesis_judgment=yes consequence=external
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

Read as prose: **Deep** when the ask is a report, the scope is broad, or a thesis-grade judgment
is wanted *and* the result leaves the firm. **Standard** when the ask is an analysis, the result
goes outside the firm, a load-bearing claim is in play, a thesis-grade judgment is wanted, or any
signal is unclear. **Light** only when none of that is true.

A rule with two conditions fires only when **both** match. That is the point of the
consequential-thesis rule: an internal thesis question belongs on Standard, and an external
result belongs on Standard, but a thesis-grade judgment that *leaves the firm* is a selection no
lightweight route may make on its own — it goes to Deep, where the workflow pauses twice for the
operator.

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

## Standard — produce the evidence-controlled memo

Standard is the middle route: a bounded analysis that needs more control than a note and does not
need the five-stage report workflow. It works from evidence reachable **through this project and
this session** — the repository, what the operator supplied, files you can open. Standard does not
fetch, search the web, call an API or start a retrieval run. Where the evidence is not reachable
that way, the answer is a named unknown or an escalation to Deep. It is never invented support.

Produce one memo in exactly this shape:

```markdown
# {question, restated in one line}

## Claims

### C1 — {the claim, stated so it can be true or false}
Class: SUPPORTED | PROXY-SUPPORTED | ILLUSTRATIVE-ONLY | NOT-SUPPORTED
Roles: {n} — {evidentiary role; evidentiary role}
Source: {what you actually opened} — Date: {source's date, or `undated`} — Role: {role} — Fit: direct | proxy
Rationale: {why this class, and any ceiling you applied with its cap}

### C2 — {…}

## Answer
- [C1] {one material assertion licensed by C1}
- [C1,C2] {one material assertion licensed by both claims}

## Inference
- [INFERENCE] {what you concluded beyond what the sources state, naming the claim IDs it rests on}

## Unknowns
- {what is not known and would change the answer}

## Completion
Status: COMPLETE | ESCALATED-TO-DEEP
Deep triggers: none | {the trigger that fired}
```

### Grading a claim

Grade the **evidence**, on one ordered axis, before considering anything about the claim's ambition:

| Class | When | Verbs you may use |
|---|---|---|
| `SUPPORTED` | two or more independent evidentiary roles, evidence direct and in scope | shows / confirms / establishes / demonstrates / records |
| `PROXY-SUPPORTED` | two or more independent roles, but the evidence is a proxy needing downgrade | suggests / is consistent with / points to / indicates |
| `ILLUSTRATIVE-ONLY` | exactly one independent role. It can attest what it saw; it cannot be triangulated | illustrates / shows in one named case / reports (single-sourced) |
| `NOT-SUPPORTED` | zero roles — no direct and no proxy evidence found | none — the claim may not be asserted |

Four rules make that grading honest:

- **Count roles, not documents.** Three write-ups of the same underlying release are **one** role.
  Independence is about the evidentiary role a source plays, not how many files you opened.
- **A ceiling caps a class; it never raises one.** If a claim generalizes across a class of actors
  or periods and you have fewer than three same-pattern instances and no population-level source,
  cap it at `ILLUSTRATIVE-ONLY` and **write the cap in the Rationale**. A cap that is not recorded
  is indistinguishable from an evidence verdict.
- **`NOT-SUPPORTED` never means false.** It means unsupported. The claim and its negation are both
  unstateable — never invert an unsupported claim into an assertion of the opposite. Finding no
  evidence that X happens is not evidence that X does not happen.
- **An evidenced negative is an ordinary finding.** A source that looked and recorded a true zero is
  evidence, and a negative claim resting on two such roles is `SUPPORTED` like any other.

### The verb rule

Put every material `## Answer` assertion on its own bullet and begin it with the claim IDs that
license it: `- [C1] ...` or `- [C1,C2] ...`. A `SUPPORTED` claim elsewhere in the memo cannot
license stronger language for a weaker claim. The words *establishes*, *confirms* and
*demonstrates* are available only when **every claim ID on that assertion** is `SUPPORTED`.
Say what those claims actually license.

### Refusing completion

Resolve the checker through this command's real path, then run the memo through it before treating
the memo as done. This works when the command is symlinked from the canonical resource repository;
if the command was copied without its helper, Standard cannot truthfully complete and must stop:

```bash
research_entry=.claude/commands/research-route.md
while [ -L "$research_entry" ]; do
  research_target="$(readlink "$research_entry")" || break
  case "$research_target" in
    /*) research_entry="$research_target" ;;
    *)  research_entry="$(dirname "$research_entry")/$research_target" ;;
  esac
done
research_root="$(git -C "$(dirname "$research_entry")" rev-parse --show-toplevel 2>/dev/null)"
research_checker="$research_root/logs/scripts/research-route-memo-check.sh"
[ -r "$research_checker" ] || { printf 'Standard checker unavailable: %s\n' "$research_checker" >&2; exit 2; }
bash "$research_checker" --memo <path-to-memo>
```

It rejects a memo that launders an unsupported claim: missing required sections or claim fields;
role/source counts inconsistent with the selected permission class; sources without date, role or
fit; evidence and inference collapsed together; unbound Answer assertions; a `COMPLETE` status over
a live Deep trigger or `NOT-SUPPORTED` claim; an escalation with no live trigger; the reserved
authority term appearing in Standard output; and a `SUPPORTED` verb attached to a non-`SUPPORTED`
claim. The checker is a floor on the memo's declared structure. It does not judge whether roles are
truly independent or whether the analysis is any good.

**Set `Status: ESCALATED-TO-DEEP`, not `COMPLETE`,** when any of these is true — this is the same
one-way escalation as Step 3, applied after the work has started:

- a load-bearing claim finished at `NOT-SUPPORTED`;
- the question turned out to need a broad or multi-section report;
- a thesis-grade selection is being asked for and the result leaves the firm;
- the control the question needs is beyond what Standard has.

Then take the Deep section below. A memo is never marked complete on the strength of what you
intended to find.

### Comparing interpretations, and the line you do not cross

Standard **may** set two or more readings of the evidence side by side, each with its own claims and
classes, and say plainly which the evidence supports better and why.

Standard **may not promote any of them to a governing judgment.** No House View, no founder-authorized
thesis, no approval step, no authority artifact. That contract is owned by the canonical judgment
layer and has not been published yet, so there is nothing here to bind to. Do not invent it, do not
stub it, and do not write as though a selection had been authorized. Where a request genuinely needs
the reserved authority concept discussed in the output, escalate rather than placing that term in a
Standard memo; until L2 publishes a structured contract the checker rejects the term conservatively.
Where a request genuinely needs an authorized thesis rather than a comparison, that is a Deep
trigger and an honest escalation —
which is what "stopping cleanly at the seam" means. The seam stays closed until the authority
contract exists.

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
