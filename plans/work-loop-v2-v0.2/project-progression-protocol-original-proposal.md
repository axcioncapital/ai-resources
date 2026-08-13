# Work Loop v2 Project Progression Protocol — Original Proposal

**Status:** Operator-supplied proposal preserved for review. It is not approved or governing authority.
**Source:** Codex attachment supplied by the operator on 2026-08-06.
**Preservation note:** The proposal below is reproduced verbatim.

---

## Recommendation

Create a lean **Work Loop v2 Project Progression Protocol** for the Codex/controller side.

Do not embed the project lifecycle inside Claude’s `/work-loop-v2` command. That command deliberately executes one prepared unit and explicitly says it is not a lifecycle command (work-loop-v2.md (line 7)). The executable core already owns unit selection, briefs, verification, execution, evidence, correction and task state (executable core (line 62)).

The new protocol should answer only:

> Where is this project in its lifecycle, what transition is justified next, and what is the smallest unit that advances that transition?
> 

## Proposed lifecycle

> **Frame the need → Resolve blocking uncertainty → Choose the intervention → Shape the pilot → Deliver → Test in real use → Adopt, revise or stop**
> 

| Project state | Governing question | Exit condition | Drift prevented |
| --- | --- | --- | --- |
| 1. Frame the need | What operating outcome has actually been chosen, for whom, and what would failure look like? | The operator confirms the minimum outcome and representative situations. | Solutions, schemas and backlogs appearing before the need is established. |
| 2. Resolve blocking uncertainty | What remains unknown that could materially change the intervention? | The intervention can be selected without an implementer inventing the workflow, ownership or boundaries. | Endless discovery and speculative requirements. Skip this state when the important questions are already settled. |
| 3. Choose the intervention | What is the smallest credible response: remain manual, improve an existing mechanism, configure or buy, assemble tools, build, investigate further, or stop? | The operator authorises one intervention form and its boundary. | Repository creation, automation or architecture becoming authorised merely because someone drafted them. |
| 4. Shape the pilot | What is the smallest end-to-end version capable of testing the important operating assumptions? | The pilot boundary, real-use test, exclusions and recovery expectations are settled. | Future-state architecture, convenience features and premature automation entering the MVP. Manual steps remain acceptable. |
| 5. Deliver | Can the authorised pilot be made operationally complete? | The pilot works through its public operating seam, with whole-capability evidence and known limitations. | Horizontal infrastructure building and adjacent improvements. Units here run through the existing Work Loop core; this protocol adds no execution mechanics. |
| 6. Controlled use | Does it work in representative real work, with acceptable burden, ownership and recovery? | Enough operating evidence exists to make a lifecycle decision. | Treating technical completion as adoption. Additions during the trial are deferred unless a failure prevents a meaningful trial. |
| 7. Disposition | Should the capability be adopted, revised, kept manual/local, trialled longer, replaced, paused or retired? | One explicit status, operating owner and reopening condition exist. | Capabilities becoming permanent, half-adopted infrastructure simply because they were built. |

This is essentially the strongest part of the CRM route, compressed into a reusable spine. The CRM plan already demonstrates the full progression from framing through intervention, controlled use and disposition (CRM route (line 29)), while also showing that planning depth must earn its place (route gate (line 150)).

## How Codex should use it

When you ask Work Loop to “continue” a project, Codex should:

1. Read the project’s existing governing workflow and authoritative current state.
2. Map the project to one lifecycle state above—without creating another document or renaming the project’s own phases.
3. Identify the nearest unmet exit condition.
4. Determine whether the next move is:
    - an operator decision;
    - one bounded discovery unit;
    - one delivery unit; or
    - one real-use observation unit.
5. Hand any admitted unit to the existing executable core.
6. Update the project’s existing authoritative state only when its lifecycle position materially changes.

A specialist workflow remains authoritative for its domain method and reviews. For example:

- CRM Stages 1–3 map to framing and uncertainty resolution; Stages 4–5 to intervention; Stage 6 to delivery; Stage 7 to controlled use; Stage 8 to disposition.
- Systems Builder Phases 4–8 clarify the need and system boundary; Phase 9 shapes the MVP; Phases 10–13 select and prepare the intervention. Its existing review points remain its own—Work Loop must not add another review layer. That project already warns that continuous review becomes procedural friction (Systems Builder rules (line 18)).

## Non-duplication boundary

The new protocol should not contain sections about:

- Direct versus Standard admission;
- actor responsibilities;
- task-state fields or turn handling;
- brief contents;
- repository premise checking;
- execution or evidence format;
- correction rounds;
- handoff mechanics;
- task closure.

All of those already belong to the core or command.

It should also create:

- no mandatory artifact per lifecycle state;
- no second project-state system;
- no standard review checklist;
- no calendar gates, counters or scoring;
- no universal requirement to traverse every state;
- no roadmap that automatically becomes future scope.

That directly addresses the documented failures: build-ahead-of-demand, ceremony on small work and governance machinery whose carrying cost exceeded its value (problems and lessons (line 85)).

## One core seam to fix

Before adopting the lifecycle, resolve one ambiguity in the executable core:

- It says a task normally contains several units.
- Its assessment outcomes currently allow only **close, correct once or stop**.

Add one explicit outcome:

> **Continue — accept the completed unit and prepare the next unit because a named project-lifecycle exit condition remains unmet.**
> 

This belongs in the core once. The new project protocol should reference it, not recreate its mechanics.

## Treatment of the supplied drafts

- The first draft contains the best material on authoritative project context, specialist-workflow boundaries and proportionality. Its unit SOP should be removed because the core now owns it.
- The second draft contributes the valuable discovery/implementation/adoption distinction and the real-use lifecycle decision. Its session steps, evidence-package template, operator checklist and Independent Review SOP should not enter Work Loop v2.
- The third draft should not be adopted. It largely restates the executable core and introduces competing terminology and outcomes.

The pull from GitHub was blocked by pre-existing unstaged changes, which I preserved untouched. No files were changed.

**Next:** approve or adjust this seven-state spine; after that, I can turn it into the concise authoritative protocol and specify the minimal core/Codex-resource edits without changing Claude’s unit command.
