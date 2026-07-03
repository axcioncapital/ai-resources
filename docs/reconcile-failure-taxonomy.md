# /reconcile Failure Taxonomy

> **When to read this file:** Loaded by `reconcile-reviewer` when classifying why an output fell short, and by `/reconcile` when writing the report's Root Cause and Recommended Fixes sections. Not needed for every turn.

A weak output can come from five different places. Naming the right one is the point of `/reconcile` — fixing the wrong layer wastes a rewrite cycle on a problem that will recur.

## Failure levels

| Level | What's actually broken | Signal |
|---|---|---|
| **Output** | The artifact itself — weak, incomplete, generic, or misaligned prose/analysis, produced by an otherwise-sound process. | Mandate rubric dimensions score below bar; resource-activation audit finds no gap; genericness heuristics (`reconcile-genericness-heuristics.md`) fire. |
| **Workflow** | The sequence of steps used to produce the output skipped or misordered something the task needed (no diagnosis phase, no prioritization pass, output drafted before enough context was gathered). | Session trace (session-notes.md, decisions.md) shows the output was produced without an intermediate step the task's complexity would call for. |
| **Resource** | A project resource or skill that should have shaped the output was not consulted. | Resource-activation audit: a resource marked required in `resource-activation-map.md` for this task type has no evidence of use. |
| **Mandate** | The project's own definition of "good output" is too vague, incomplete, or self-contradictory to judge against. | `mandate-rubric.md` has no line covering the dimension in question, or two lines conflict. |
| **Instruction-architecture** | The repo's CLAUDE.md / skill / command layer is bloated, conflicting, or routes to the wrong resource — a repo-level cause, not a project-level one. | Multiple projects show the same failure pattern; the cause traces to a shared instruction file, not this project's mandate or resources. |

A single reconciliation can name more than one level — e.g., a Resource failure (skipped file) that *caused* an Output failure (generic prose). Name the earliest cause as primary; later ones as downstream consequences.

## Root-cause diagnosis (why, not just where)

Once the level is named, state *why* it happened — this is what makes the fix specific instead of "try harder":

| Root cause | Diagnostic question |
|---|---|
| Vague mandate | Does `mandate-rubric.md` define what a good output looks like for this dimension? |
| Weak task framing | Did the operator's request leave the actual question ambiguous? |
| Missing context | Was a resource in `resource-activation-map.md` ignored or genuinely unavailable? |
| Wrong workflow | Did the process skip a diagnosis, synthesis, prioritization, or critique step the task's stakes called for? |
| Instruction bloat / conflict | Did competing instructions across CLAUDE.md/skill/command layers dilute or contradict the standard? |
| Weak output contract | Was the required deliverable's shape (length, format, decision-vs-survey) left unstated? |
| Model defaulting | Did the output fall back to generic-consulting patterns instead of project-specific judgment (see `reconcile-genericness-heuristics.md`)? |

## Fix levels — and where each one closes (OP-12: detection ships behind a working closure channel)

`/reconcile` diagnoses; it does not rewrite. Per its own design ("do not become a rewrite agent"), every fix it names must route into a channel that can actually close it — otherwise the diagnosis is detection without closure, which the workspace's operating principles treat as a defect in the detector, not a feature. Each fix level has exactly one home:

| Fix level | What changes | Routes into |
|---|---|---|
| **Output-level** | The current deliverable — sharper prioritization, removed generic language, added missing dimension. | `/resolve` (single-output fix, operator-actioned same session) |
| **Workflow-level** | A step added, removed, or reordered in how this *type* of task gets produced next time. | `/resolve-repo-problem` (MANUAL mode, if the workflow gap is a repo-level pattern) or a direct project CLAUDE.md / skill edit if it's local to this one project's process |
| **Repo-level** | `mandate-rubric.md`, `resource-activation-map.md`, or upstream CLAUDE.md/skill instructions themselves need a durable edit. | `logs/improvement-log.md` (Pending → Applied, Friday-cadence drain) for cross-session patterns; direct edit for a single obvious rubric gap |

`/reconcile`'s report template (`reconcile-report-template.md`) requires naming the routing target for every fix it recommends — a fix with no named channel is an incomplete finding, not a deferred one.
