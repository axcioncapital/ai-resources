# Work Loop V2 Agentic-Evolution Gap Report

**Date:** 2026-08-13  
**Purpose:** Compare the supplied recommendation, beginning “I would not rewrite Work Loop V2 into a
large agent framework command,” with the implementation now present in this repository.  
**Status:** Evidence-based assessment and recommended next work. This report does not authorize or
implement further changes.

## Executive conclusion

The proposed direction is already substantially implemented. Work Loop V2 is no longer merely a
session procedure: it operates around one durable task, one current unit, explicit turns, repository
evidence, resumable handbacks, bounded correction, and fresh-session recovery. The attended Axcíon
Harness adds mechanical transport controls around that semantic loop.

Across the recommendation's twelve main proposals:

- **7 are substantially implemented;**
- **3 are partially implemented or intentionally implemented in a leaner form;**
- **2 are not implemented:** capability-maturity context and capability-level closure/promotion
  recording.

The most important distinction is between **implementation completion** and **operational proof**.
The readiness branch contains the accepted hardening from Units 1–6. The one authorized live smoke
test then proved a safe failure path, but not successful live operation, because the launched Claude
CLI was not logged in. The implementation is therefore done, but the carrier is not proven ready for
normal supervised use.

The repository should not now add a phase state machine, a second task-state schema, a delegation
framework, or automatic Notion synchronization. Those would duplicate current behavior and conflict
with the approved lean architecture. If the broader recommendation is pursued, only two small design
gaps deserve new work: a project-owned capability-maturity declaration and a minimal way for relevant
Work Loop closures to report against it.

## Evidence and authority

The supplied text is treated as a useful proposal, not governing authority. This assessment compares
it with:

- `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` — the executable semantic core;
- `.agents/skills/work-loop-v2/SKILL.md` — Codex routing, briefing, assessment, continuation and
  courier behavior;
- `.agents/skills/reorient/SKILL.md` — durable-evidence recovery after compaction or context loss;
- `plans/work-loop-v2-v0.2/context-engineering-spec-v0.1.md` — the operator-approved context and
  state boundary;
- `scripts/axcion-harness-v0.2/carry-turn.sh` — the canonical attended carrier;
- `logs/work-loop/axcion-harness-v0-2-readiness-fixes.md` — accepted implementation and smoke-test
  evidence;
- `templates/README.md` — the explicit retirement status of the former capability-record system;
- `plans/axcion-harness-v0.2/authoritative-current-position-enforcement-report-2026-08-13.md` — the
  repository-specific current-position design analysis.

The approved Context Engineering specification is especially important. It permits one optional
operator source, one canonical plan, and the existing authoritative current-state interface. It
prohibits another persistent coordination artifact or second project-state system. Any proposal in
the supplied text must fit inside that boundary or receive a new operator-approved specification.

## Recommendation-by-recommendation assessment

| # | Proposal | Status | What exists now | What remains |
|---|---|---|---|---|
| 1 | Make the work unit, not the session, the durable object | **Done** | One task has one `logs/work-loop/{task-id}.md` state file. It persists across Claude, Codex, fresh sessions and compaction. The task leases its checkout until closure. Conversation is explicitly non-authoritative. | No architectural work required. Successful live carrier use remains unproven, but that is adoption evidence rather than missing state semantics. |
| 2 | Add a small canonical state contract | **Done, in a leaner shape** | The active file has exact `task` and `turn` protocol fields and at most five state headings: objective/scope, lane/unit, latest result, blocker and next action. The brief carries decisions, authority, evidence and acceptance details without multiplying state fields. Plan = approved direction; task state = execution position; repository/Git/tests = evidence. | Do not expand this into the proposed eleven-field schema. The present shape deliberately avoids duplicated truth. |
| 3 | Make ORIENT → EXECUTE → VERIFY → REVIEW → CLOSE explicit | **Partial by design** | All five behaviors exist: Codex orients and briefs; Claude executes and verifies; Codex independently assesses; Claude writes the closing record. False premises, correction and operator stops have explicit routes. | They are **behaviors and role transitions**, not a stored phase machine. Adding `current_phase` or forcing every unit through five visible stages is not justified and would conflict with the rule that Work Loop modes are not project phases. No change is currently recommended. |
| 4 | Add capability-maturity awareness | **Not implemented** | Work Loop can orient to a project's own governing workflow and phase, and Adoption mode can end in adopt/revise/continue/stop. It does not require `Capability`, `Current maturity`, `Target maturity` or `Promotion condition`. | A project-owned maturity declaration is the main real semantic gap. It should be optional and relevant only to capability-development work, not added to every Work Loop task. Ownership and the authoritative storage surface must be settled first. |
| 5 | Add an explicit smallest-next-action loop | **Done** | The core requires the smallest justified unit that still produces an observable result. Codex can close, continue, correct once or stop. `## Next action` names one actor-correct move. | No additional loop engine is needed. The carrier transports the already-explicit turn and does not choose strategy. |
| 6 | Strengthen acceptance conditions and evidence | **Done** | Every brief carries a required outcome, evidence, completion condition and stop conditions. Evidence must be able to fail. Implementation mode requires a failing case, result and regression protection where meaningful. Adoption mode requires operating evidence and a lifecycle decision. | No schema change needed. Real-use proof remains necessary whenever a capability is to be adopted. |
| 7 | Separate execution from verification | **Done** | Claude verifies repository claims, implements, tests and commits. Codex independently assesses the returned evidence and cannot silently substitute itself as implementer. Failed assessment permits one correction frozen to named findings; it does not trigger general redesign. | No new reviewer chain is needed. The existing split is stronger and leaner than a generic executor-reviewer pipeline. |
| 8 | Make reorientation first-class | **Done** | The core requires durable-source orientation. The dedicated `reorient` skill reconstructs objective, current state, task, next action, constraints, evidence and open issues from the exact checkout and state file. Repository evidence outranks compacted memory. | It remains a named recovery operation rather than a visible lifecycle stage, which is appropriate. It should not become another persistent record. |
| 9 | Use bounded capability/skill selection | **Done** | The Codex Work Loop resource routes each request to exactly one owner: operator, specialist capability, Direct Work or Work Loop. It loads the executable core only where Work Loop owns the request and rejects a default supporting stack. | Continue to add routing only after observed misrouting. Do not build a generated skill registry or load every skill. |
| 10 | Make delegation conditional | **Partial, intentionally conservative** | Specialist work is routed to the specialist rather than wrapped in a multi-agent pipeline. Repository policy permits subagents only when explicitly requested, and the attended carrier requests denial of nested Claude/Codex launches. | Work Loop does not expose a general delegation mechanism, and none is currently needed. Add one only after a concrete separable task demonstrates value that routing or ordinary actor roles cannot provide. |
| 11 | Establish permission boundaries | **Substantially done; mechanical coverage is incomplete** | The operator owns scope and consequential decisions. The carrier enforces checkout ownership, allow-path detection, timeouts, explicit attended permission modes, default nested-actor denial on Claude, deterministic stops, and no automatic push/merge. `acceptEdits` is per invocation and operator-approved. | The Codex actor has no equivalent nested-command deny, process observation has documented blind spots, and fully unattended authority remains disabled. These are accepted limitations, not blockers to retaining the attended implementation. |
| 12 | Make closure update a capability record | **Not implemented—and the former mechanism is retired** | Work Loop closure records outcome, decisions, evidence and limitations in the task state. `templates/capability-record.md` is explicitly retired legacy with no live writer; Work Loop V2 deliberately did not inherit it. | If capability maturity is adopted, define a minimal project-owned closure seam. Do not revive the legacy capability record or make Work Loop write to Notion directly. Promotion must remain an operator/product decision. |

## Assessment of the five proposed priorities

### 1. Persistent work-unit state independent of sessions — complete

This is the core of the current implementation. The exact task-state file is the interface between
Codex and Claude, survives session loss, and is bound to its checkout by location. The carrier starts
fresh actors from that durable interface.

### 2. Explicit ORIENT → EXECUTE → VERIFY → REVIEW → CLOSE phases — behavior complete, state machine not needed

The behavioral separation exists and is enforced through roles and handbacks. What does not exist is
a `current_phase` field or universal five-stage pipeline. That omission is beneficial: projects keep
their own phase vocabulary, and small units do not acquire visible process stages merely for
completeness.

**Recommendation:** do not implement this as additional state. If clearer prose is ever needed, make
an editorial clarification in the core after approval; do not alter the runtime contract.

### 3. Acceptance conditions and evidence for every work unit — complete

This is stronger than the supplied proposal. The current system requires evidence that can fail,
scales evidence to consequence, checks repository premises first, and distinguishes implementation,
discovery and adoption evidence.

### 4. Built-in reorientation from durable state — complete

The `reorient` skill and the core's orientation rules implement the requested recovery cascade.
Reorientation is restoration from durable evidence, not transcript summarization.

### 5. Capability maturity context — not complete

This is the one priority item that remains genuinely absent. The repository can describe project
phases, but Work Loop does not consistently know a capability's current maturity, intended target or
promotion condition.

That gap should not be filled by adding mandatory fields to every Work Loop state file. The cleaner
design is:

1. the capability-owning project records maturity and promotion condition in its existing canonical
   plan or current-state surface;
2. a Work Loop brief cites those values only when they govern the open unit;
3. closure reports the work-unit outcome against the promotion condition;
4. the operator or capability owner decides promotion;
5. any Notion view consumes that decision later rather than becoming Work Loop's source of truth.

## What has been completed specifically in the attended harness

The readiness implementation has accepted evidence for:

1. checkout-wide single-writer enforcement;
2. deterministic post-hop classification from before/after evidence;
3. default nested Claude/Codex denial on Claude hops;
4. a narrowly approved per-run attended `acceptEdits` mode;
5. a bounded supervised-trial evidence contract;
6. machine-readable top-level and nested-actor observation, with honest blind-spot disclosure.

The accepted implementation commits are recorded in the readiness task state. The implementation is
complete enough to merge. It must not be described as proven ready for normal supervised use because
the representative live proof was not completed.

The one live smoke test in this checkout did establish a useful negative result:

- the carrier launched exactly one top-level Claude actor;
- the child immediately reported `Not logged in · Please run /login`;
- the carrier classified the result as `ACTOR_FAILED` (exit 20);
- it did not retry;
- it preserved `turn: claude`;
- it attributed no repository changes to the hop;
- it reported `nested=unobserved` rather than inventing a zero.

That proves honest stopping for this case. It does not prove a successful Claude handback.

## What still needs to be done

### Required to finish and retain the current implementation

1. **Commit the canonical closing record and merge the readiness branch.** This is repository closure,
   not another implementation unit.
2. **Keep the release claim narrow:** “attended carrier hardening implemented; successful live
   representative operation not proven.”

Nothing else from the supplied proposal is required to merge the current implementation.

### Required before relying on the attended carrier in normal work

1. Log the headless Claude CLI into the account used by `claude -p`.
2. Run one successful, small, state-file-only attended carrier smoke test in an ordinary clean
   checkout.
3. Confirm the resulting state transition, commit, actor counts, changed paths and terminal
   classification from the carrier evidence.

The previously proposed thirteen-hop trial programme is not required by this report. One successful
smoke test establishes basic operability; it does **not** establish repeat reliability. If later use
shows inconsistent behavior, add evidence proportionately then.

### Required only if pursuing the broader capability-maturity vision

1. **Settle ownership.** Decide which existing project artifact owns capability maturity and promotion
   conditions. Do not create both a project state file and a capability record.
2. **Specify the minimum semantics.** At most: capability, current maturity, target maturity,
   development objective and promotion condition.
3. **Define the closure seam.** A relevant Work Loop closure reports outcome and evidence against the
   promotion condition; it does not promote the capability.
4. **Test with one real capability.** Prove that a fresh session can identify the maturity target,
   perform one bounded unit, and leave an operator-ready promotion recommendation without duplicate
   state.
5. **Only then consider a Notion view.** Notion should mirror or consume the repository-owned result,
   not become a competing runtime authority.

This should be a separately approved design unit because the repository deliberately retired the old
capability-record producer. Quietly reviving it would reopen a settled architecture decision.

## What should not be done now

- Do not add an `ORIENT`, `EXECUTE`, `VERIFY`, `REVIEW` or `CLOSE` frontmatter field.
- Do not expand the task state into eleven mandatory headings.
- Do not revive `templates/capability-record.md` without resolving its ownership and retirement.
- Do not add planner, researcher, coder, tester, critic and supervisor agents around every unit.
- Do not add automatic model routing, a task scheduler, vector memory, a capability graph or a skill
  registry.
- Do not make Work Loop synchronize directly with Notion.
- Do not make the dispatcher choose priorities, maturity, project phase or the next semantic action.
- Do not claim unattended readiness; that operating mode remains outside the accepted boundary.

## Recommended sequence

The practical sequence is deliberately short:

1. **Now:** commit the closing record, merge the readiness implementation, and remove the temporary
   worktree when normal merge verification is complete.
2. **Before first real carrier use:** authenticate Claude CLI and run one successful smoke test.
3. **Later, only if capability portfolio management is still wanted:** approve a small design for
   project-owned maturity context and closure reporting.
4. **Stop there until evidence creates another gap.** Conditional delegation, Notion synchronization
   and richer lifecycle machinery are not current requirements.

## Final verdict

The repository already has the early Axcíon agent harness described by the supplied proposal: durable
work-unit truth, session-independent execution, smallest-next-action progression, bounded authority,
evidence-driven verification, independent assessment, recovery after context loss and controlled
transport.

What remains is not a framework build. It is:

- one operational prerequisite and smoke test before normal carrier use; and
- one optional product-management addition—capability maturity plus promotion-condition reporting—if
  that broader portfolio view remains valuable.

Everything else should remain as it is unless real operation demonstrates a specific deficiency.
