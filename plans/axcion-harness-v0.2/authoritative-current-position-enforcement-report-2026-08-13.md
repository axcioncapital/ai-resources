# Authoritative Current-Position Enforcement in the Axcíon Repository

**Date:** 2026-08-13  
**Status:** Design report; no implementation is authorised by this document  
**Scope:** The minimum way for Work Loop and the attended Axcíon Harness v0.2 carrier to refuse work whose project position cannot be established from durable repository evidence

## Executive conclusion

Axcíon does need authoritative-current-position enforcement, but it should not be implemented as a
mandatory new `PROJECT-STATE.md` in every repository and it should not ask the carrier to decide what a
project ought to do.

The lean design is:

1. **Codex establishes project position before it frames a unit.** It must use the active Work Loop
   task state when one exists, plus the governing plan and applicable workflow. If those sources do not
   establish the next authorised work, Codex stops for the operator instead of inventing continuity.
2. **Claude independently checks the load-bearing claims in the brief.** If the cited state, plan or
   repository reality does not support them, Claude hands back without implementing.
3. **The carrier enforces only facts it can determine mechanically:** exact checkout, exact task file,
   valid task identity, valid turn, one writer, allowed paths and valid state transitions. It records
   and transports the decision; it does not infer project strategy.
4. **A separate project-position file is created only when a continuing project genuinely needs one
   and has no existing suitable surface.** It is not a universal scaffold and never duplicates the
   active task file.

This produces the important safety property:

> A model may execute the wrong technical change only after two semantic checks have failed; the
> carrier itself cannot silently promote repository search, chat memory or a stale planning artifact
> into project authority.

It also preserves the current architecture: one plan, one active task-state interface, Git and tests
as evidence, and no global project database.

## The problem in plain language

The carrier can answer questions such as:

- Is this the requested checkout?
- Does this task file belong to this task?
- Whose turn is it?
- Did the actor change only authorised paths?
- Did the task move to a valid next turn?
- Was the hop blocked, interrupted or partially completed?

It cannot answer these questions by itself:

- Is this still the project's approved objective?
- Is this the current phase of the project?
- Has a later decision superseded the proposed work?
- Is this the next work the operator actually authorised?
- Does a specialist workflow own this step instead?

Without an authoritative position, the carrier can execute an obsolete task safely and accurately.
The repository may remain technically clean while the project moves in the wrong direction.

“Enforcement” therefore means refusing to frame or execute a unit when durable sources do not support
its position. It does not mean teaching a Bash script to make project-management judgments.

## The authority already present in this repository

Three repository sources determine the correct design.

### 1. The governing Context Engineering specification

`plans/work-loop-v2-v0.2/context-engineering-spec-v0.1.md` is operator-approved and bound to commit
`148689d42ee7817239219417a1b884b961660f86`. Section 5.7 permits only:

1. optional operator source material;
2. one canonical project plan; and
3. the existing authoritative current-state interface.

For an active Standard Work Loop task, that third item is explicitly the existing
`logs/work-loop/{task-id}.md` file. The specification says no second project-state system is created.
It also defines the honest missing-state behavior: derive only what the governing plan, closed outcomes
and verified repository evidence support, and route any remaining material uncertainty rather than
inventing continuity.

### 2. The Work Loop executable core

`plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` requires orientation from the task file,
the repository, the approved plan, applicable workflows and authoritative current state. Conversation
may locate a source but cannot establish authority. Claude must check repository-dependent claims before
acting and stop when a premise is false.

### 3. The dispatcher readiness assessment

`plans/work-loop-v2-v0.2/pre-launch-preparations/dispatcher-semi-agentic-readiness-fixes-2026-08-11.md`
correctly identifies the operational risk and proposes refusing projects without an identifiable
current-position source. However, the assessment explicitly authorises no implementation, and its
companion roadmap is also proposed rather than governing. Its examples—`PROJECT.md`,
`PROJECT-STATE.md`, or `pipeline-state.md`—must therefore be interpreted through the governing
Context Engineering rule rather than treated as mandatory file names.

The reconciliation is straightforward: retain the refusal behavior, but do not create a parallel state
system or make the transport layer decide project meaning.

## Repository reality that the design must respect

The repository does not currently have a uniform project-state convention. The July 2026 repository
survey recorded 27 project directories, 21 with `pipeline/pipeline-state.md`, and none with
`PROJECT.md`. More importantly, the same evidence establishes that most `pipeline-state.md` files
describe the historical `/new-project` scaffold pipeline, not current operational work. Treating the
filename as authority would give false answers for some projects.

This means none of the following rules would be safe:

- “Every project must have `PROJECT-STATE.md`.”
- “Use `pipeline/pipeline-state.md` whenever it exists.”
- “Choose the newest state-looking file.”
- “Search the repository and synthesize the most plausible current position.”
- “Use the previous conversation when the repository is unclear.”

Authority is semantic and project-specific. A file qualifies because the project or governing plan
identifies its role and its content is sufficient—not because its name resembles a state file.

## The proposed operating contract

### A. When an active Work Loop task already exists

The active task file is the current-state interface. Codex reads, in order:

1. `logs/work-loop/{task-id}.md`;
2. the governing plan named by the task or project;
3. the applicable approved workflow;
4. only the repository evidence needed to settle the next unit.

The task file must support the immediate execution facts already required by the Work Loop core:

- objective and scope;
- current unit;
- latest material result;
- blocker, if any;
- exact next action;
- identifiable governing sources inside the brief where they matter.

No additional `PROJECT-STATE.md` is needed merely because the carrier is involved.

The current readiness task is an example. Its task file identifies the objective, accepted Units 1–6,
the unresolved live trials, the operator's checkout authorization and the exact next action. The
repository and commits provide implementation evidence. A second state file would mostly repeat this
truth and create another surface that could drift.

### B. When continuing a project with no active task

Codex performs one bounded orientation pass. It looks first for a project-owned source explicitly
identified by the governing plan or workflow, not for a preferred filename. A suitable source must
establish enough of the following to frame one next unit:

- the approved objective and identifiable governing plan;
- the project's current phase in its own vocabulary;
- completed work and accepted decisions that affect the next move;
- live blockers or operator gates;
- the next work that is actually authorised.

The information may already live in a current plan section, a live mission record, a specialist
workflow's state file, or another explicitly designated operational file. Several files that each
claim to be current, or one file contradicted by another authoritative source, is ambiguity—not a
licence to choose the most convenient one.

If the available sources and repository facts fully establish the next unit, Codex may open the normal
Work Loop task file. From that point, the task file becomes the active current-state interface.

If a load-bearing fact remains unknown, Codex does one of two things:

- opens a bounded discovery unit when repository inspection can settle it; or
- stops for the operator when the missing fact is intent, priority, authority or risk.

It does not create a plausible project history from filenames, modification dates or chat memory.

### C. When a durable project-position file is genuinely needed

A separate current-position file is justified only for a long-running project that repeatedly needs to
select new tasks after prior Work Loop tasks close and has no existing operational state surface. It
should live inside that project's existing control area—for example:

`projects/<project>/PROJECT-STATE.md`

or, where an initiative already lives under a dedicated plan directory:

`plans/<initiative>/current-state.md`

The location is chosen by the project owner or governing plan. The harness must not impose both.

A minimum file could look like this:

```markdown
# <Project> — Current Position

**Updated:** 2026-08-13
**Governing plan:** `plans/<project>/plan-v1.md`
**Plan authority:** Operator-approved 2026-08-10; approved content identified by version or commit.

## Current phase

Controlled use — the implemented pilot is being tested in representative work.

## Accepted position

- Units 1–6 are accepted; evidence is in `logs/work-loop/<closed-task>.md`.
- Fully unattended operation remains excluded.

## Blockers and operator gates

- Live permission-recovery behavior has not yet been observed.

## Authorised next work

Run the first bounded normal-use trial. Do not begin unattended trials or external actions.
```

This file is intentionally small. It points to plans and closed evidence rather than copying them. It
changes only when the project's lifecycle position, accepted decisions, blockers or authorised next
move materially change—not after every model turn.

Once a Work Loop task opens, the task file holds unit-level state. The project-position file continues
to hold project-level position. Their scopes are different:

| Surface | Question answered | Update cadence |
|---|---|---|
| Governing plan | What has been approved? | Only through approved amendment |
| Project current position, when needed | Where is the continuing project and what may start next? | Material project transition |
| Active Work Loop task | What is happening in this bounded task right now? | Every material handoff |
| Repository, Git and tests | What actually exists and works? | As implementation changes |

If two surfaces begin repeating the same facts, the design has drifted and one should be removed or
narrowed.

## Who enforces what

### Codex: semantic admission

Before opening or continuing a unit, Codex must be able to state, from durable sources:

- which project owns the work;
- which approved objective and plan govern it;
- what current phase or position matters;
- what has already been accepted;
- what is blocked;
- why this is the smallest authorised next unit.

If it cannot, it must not write an execution brief that pretends those facts are settled. This is the
primary enforcement point because these are semantic judgments.

### Claude: independent repository check

Claude reads the same task and verifies the brief's load-bearing claims against the named files and
repository surface. A stale plan, missing source, conflicting decision or unsupported next action is a
false premise. Claude records what it inspected, sets `turn: codex`, commits the handback and does not
implement past the conflict.

This is the independent check that prevents the framer from approving its own assumptions.

### Carrier: deterministic transport checks

The carrier continues to enforce only what software can establish without semantic interpretation:

- exact checkout and task identity;
- readable and structurally valid task state;
- expected actor and valid turn transition;
- one writer per checkout;
- path, permission, deadline and nested-actor policy;
- repository before/after evidence;
- deterministic outcome classification.

The carrier should not scan for state-like filenames, select a governing plan, infer a lifecycle phase,
or decide whether prose authorises a unit. Those actions would turn transport into an unreliable
strategic router.

## Should the carrier gain a mechanical current-position gate?

Not yet.

A mechanical gate would require a stable declaration such as a new frontmatter key, a mandatory brief
line or a command-line `--position-source` argument. None is currently part of the approved Work Loop
state contract. Adding one now would either change that contract or duplicate a path already expressed
semantically in the brief.

The first supervised trials can test the existing two-agent refusal behavior without changing the
carrier. Each trial should include an identifiable durable source and one negative case should present a
missing or conflicting source. The case passes only if no implementation starts and the gap reaches the
operator or a bounded discovery unit.

After real use, add a carrier gate only if repeated evidence shows that agents ignore the semantic
admission rule. If that happens, the smallest defensible gate would verify only that one declared,
repository-relative source is a readable regular file inside the checkout and record its hash in the run
evidence. It still could not certify that the source is current, sufficient or authoritative; Codex and
Claude would retain those judgments.

This follows the repository's established rule: move an invariant into software when the invariant is
mechanically knowable and an observed failure justifies it—not merely because a stronger-looking check
can be built.

## Failure behavior

The expected stops should be simple and specific.

### No applicable current-state source

Codex derives only what the plan, closed outcomes and repository evidence prove. If the next authorised
move remains unknown, it stops for the operator:

> The repository proves what has been built, but it does not establish which project outcome is current
> or what work is authorised next. No execution unit has been opened.

### Several plausible sources disagree

Codex names the exact conflict and asks the operator or project owner which source governs. It does not
resolve the conflict by date, filename or apparent completeness.

### A cited source is stale or contradicted by repository evidence

Claude hands back the false premise. Codex then reframes from verified evidence or escalates. The actor
does not quietly repair project strategy while implementing.

### A specialist workflow owns the next move

Work Loop routes to that workflow and opens no wrapper task around it. Authoritative position does not
grant Work Loop ownership over another capability's method.

## How this applies to the current harness-readiness work

The current task already has an adequate active current-state interface:

`logs/work-loop/axcion-harness-v0-2-readiness-fixes.md`

It records the approved attended-only boundary, accepted implementation units, deferrals, remaining
live trials, operator authorization and the next action. For this active task, creating another
project-position file would be unnecessary duplication.

The remaining limitation is narrower: the readiness work has not yet demonstrated, in a live
representative project, that a fresh Codex and Claude pair will refuse to proceed when project position
is missing or contradictory. That is an adoption-evidence gap, not necessarily a missing carrier
feature.

The clean way to include it in the supervised evidence is:

1. Use a real trial whose governing plan and current position contain one material fact absent from the
   operator's message.
2. Confirm the fresh Codex brief preserves that fact.
3. In a separate negative fixture or bounded trial, make the current-position source missing or
   contradictory.
4. Confirm that no implementation actor starts from invented continuity.
5. Record whether the stop was clear and whether the operator had to reconstruct state manually.

This evidence should be folded into an already planned normal trial or a small simulated admission
case. It should not create another five-hop trial, a state template programme or a repository-wide
migration before a real need appears.

## Acceptance criteria for the minimum design

The design is sufficient for supervised use when fail-capable evidence shows:

1. A fresh Codex session frames a materially correct unit from the active task state, governing plan
   and applicable workflow without relying on conversation memory.
2. A material current-position fact present only in durable repository state reaches the brief.
3. Missing state does not produce an invented phase, result or next action.
4. Conflicting authoritative sources cause a visible stop before implementation.
5. Claude detects and hands back a false current-position premise rather than implementing through it.
6. No new state file is created when the active Work Loop task already supplies current state.
7. A separate project-position file, where one is genuinely needed, points to governing and evidentiary
   sources instead of copying them.
8. The carrier remains a transport and evidence mechanism; removing it does not change the semantic
   decision about whether the unit is authorised.

## Explicit non-goals

This design does not authorise:

- a global project registry or database;
- mandatory `PROJECT-STATE.md` files across all repositories;
- treating historical `pipeline-state.md` files as current by filename;
- broad repository scanning to reconstruct project truth;
- RAG, vector search or a knowledge graph;
- automatic strategic routing or priority selection;
- a new Work Loop state field or carrier flag without separate evidence and approval;
- unattended operation;
- a dashboard or additional audit layer.

## Recommendation

Treat authoritative-current-position enforcement as a **semantic admission and verification behavior
first**, using the state surfaces already approved. Add one missing/conflicting-position case to the
supervised evidence, preferably folded into the planned trials rather than creating a separate trial
programme.

Do not add a new carrier mechanism or project-state template now. If supervised use later shows repeated
failures to cite or inspect the correct source, return with that evidence and design the smallest
machine-checkable declaration compatible with the Work Loop state contract.

This is enough to protect the immediate value: the harness executes only work whose position can be
defended from durable repository truth, while remaining small, model-independent at the transport
boundary, and consistent with Axcíon's target-state principle that persistent work outlives temporary
model sessions.
