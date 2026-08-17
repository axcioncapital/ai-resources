---
name: realign
description: "Corrects a live Work Loop v2 course when the operator invokes $realign for drift, governance, over-gating, ceremony, or overengineering. Restores the smallest authorized next move. Do not use after compaction (use $reorient) or for routine review."
---

# Realign

Interrupt the current course long enough to restore the smallest authorized move.
This is a corrective intervention inside Work Loop v2, not another review gate.

## Bright line

A move is aligned when current evidence shows that it:

- serves the operator-approved objective;
- stays within the authority and scope already granted;
- uses effort and process proportionate to the material risk; and
- advances an operating outcome rather than maintaining machinery for its own sake.

Realignment succeeds when the course is corrected, not when every possible
failure mode has been ruled out.

## Workflow

### 1. Pause the proposed move

Do not continue the plan, implementation, review, or correction that triggered
the invocation until this pass finishes. Treat the operator's invocation as a
request to inspect the course, not as evidence that drift definitely occurred.

Run `pwd` on its own.

**Degraded context is tested first, before any Work Loop authority is loaded.**
If the invocation or the context indicates compaction, context degradation, or
an uncertain task or checkout identity, invoke `$reorient` immediately.
Do not discover a likely task by scanning files, and do not load the Work Loop
skill first to decide the question — recovery is `$reorient`'s to own, and
reading authority into a degraded pass is how this skill absorbed recovery
before.

That branch produces no realignment judgment at all.
Emit no `ALIGNED`, `REALIGNED`, `OPERATOR DECISION NEEDED` or `STOPPED`
verdict, edit no task state and reconstruct no decision at risk.
The realignment pass ends when `$reorient` reports or fails.

Ending the pass this way does not close the Work Loop task or force a new
thread. Once recovery has established the actor-correct next action, the same
task continues; a later realignment happens only if a live proposed move still
needs that separate judgment.

**When context and binding are already sound, this pass continues as before.**
Read the complete `work-loop-v2` skill available in the
current scope and follow its current executable-core resolution. It remains
authoritative for roles, turns, state shape, correction, and hand-off behavior.
Where this skill and Work Loop v2 disagree, Work Loop v2 wins and the difference
is a defect to report.

Use the exact active `logs/work-loop/{task-id}.md` path already established in
the conversation or preserved context. If an unattended run may be active, use
the dispatcher's read-only status operation before reading or touching task
state. Never edit a state file while a run is in flight.

### 2. Reconstruct only the decision at risk

Read the minimum durable evidence needed to establish four things:

1. **Operator intent** — the outcome and any explicit decision that currently
   governs.
2. **Authority** — the approved plan, applicable workflow, and material
   constraints.
3. **Current position** — what the task state and accepted evidence show is
   complete, open, deferred, or blocked.
4. **Proposed move** — the specific action, gate, artifact, mechanism, or claim
   that prompted realignment.

Stop reading when those four are clear. Do not widen into a repository audit,
rebuild the full project history, or create a fresh plan merely because the
current course may be wrong.

### 3. Test for a material failure

Check only failure modes for which the proposed move supplies a credible
signal. Give special attention to:

- **Drift and authority** — new scope, requirements, architecture, priorities,
  or operator-owned trade-offs have entered without approval; an implementation
  preference is being treated as the objective; settled or deferred work has
  been reopened without new evidence.
- **Governance and over-gating** — another review, approval, evidence package,
  checklist, or process layer is being added without a material consequence it
  prevents; a detection mechanism has no correction or closure path; review is
  recursively generating more review.
- **Ceremony and proportionality** — the cost of planning, validation, or proof
  is excessive for a low-risk, reversible move; a field or artifact exists
  mainly to demonstrate that a check occurred.
- **Overengineering** — durable commands, agents, hooks, state, logs,
  abstractions, automation, or shared machinery are being built before a
  simpler correction has demonstrated the need.
- **Reality and value** — a stale premise, unverified absence claim, or
  inspection-only success claim is carrying the move; implementation is being
  mistaken for delivery, use, or operational effect.

A finding is material only when leaving it unchanged has a concrete consequence
for the operator's request, the approved objective, correctness, recoverability,
or operating value. Uncertainty around a low-risk, reversible move is not by
itself a reason to add a gate.

### 4. Choose one verdict

Use exactly one:

- **ALIGNED** — no material failure is supported. Resume the existing move
  without adding safeguards or another review.
- **REALIGNED** — a material failure is supported and the smallest correction is
  within existing authority.
- **OPERATOR DECISION NEEDED** — correction would choose intent, priority, risk,
  scope, or a consequential architecture trade-off that the operator owns.
- **STOPPED** — authoritative state cannot be established, sources conflict, or
  an in-flight run makes intervention unsafe.

Do not use a severe verdict to express discomfort or preference.

### 5. Apply the smallest correction

For **REALIGNED**, prefer this order:

1. stop or delete the unjustified move;
2. return to the last verified and authorized point;
3. narrow scope to one outcome;
4. simplify or reuse an existing mechanism;
5. verify the one load-bearing premise directly; or
6. escalate the one operator-owned decision.

Correct only the failure that is material. Do not redesign the solution,
re-open the whole plan, or add a compensating governance layer. Preserve every
settled decision and completed result not implicated by the finding.

Use Work Loop v2's existing state file and exact turn protocol for any durable
correction it authorizes. Add no field, task, plan, report, log, gate, review
stage, or parallel hand-off. If the current turn does not permit the correction,
name the actor who can make it and stop rather than improvising a new path.

## Output Contract

Keep the intervention compact:

```text
{ALIGNED | REALIGNED | OPERATOR DECISION NEEDED | STOPPED}

- Material issue: {one issue, or None}
- Evidence: {exact source(s) supporting the judgment}
- Smallest correction: {one correction, or Continue unchanged}
- Preserved: {scope, decisions, and completed work that remain intact}
Next: {the actor-correct instruction required by Work Loop v2}
```

Report only the strongest material issue. If several symptoms share one cause,
name the cause. Do not print the full failure-mode checklist, scores, a review
trace, or a list of everything that passed.

## Failure Behavior

- **No active Work Loop task:** say that `$realign` has no loop course to
  correct and route the request normally. Create nothing.
- **Missing or uncertain task identity, or any sign of compaction or context
  degradation:** hand to `$reorient` and end the pass, per step 1's first
  branch; do not search for a likely task and do not return a verdict.
- **Live unattended run:** report its status and do not edit state.
- **Conflicting authority:** identify the exact conflict and request the one
  operator decision needed; do not choose the convenient source.
- **No material issue:** return `ALIGNED` and resume. Do not invent a correction
  to justify the invocation.

Prefer an explicit gap over a plausible inference. Challenge a false premise,
including the operator's proposed remedy, while preserving the operator's
authority over the outcome.

## Known Pitfalls

- Turning `$realign` into a mandatory pre-implementation or pre-commit gate.
- Treating the failure-mode categories as a checklist that must be
  rendered on every invocation.
- Broadening `$reorient`-style state recovery into this pass when context and
  task identity are already sound.
- Correcting drift by adding a registry, score, state field, policy, or review.
- Re-running accepted evidence without one of Work Loop v2's permitted reasons.
- Calling every deviation drift when the operator explicitly authorized it.
- Removing a necessary safeguard merely because its subject is governance.

## Validation Loop

Before returning, confirm that the verdict could have been `ALIGNED`, the issue
has a named material consequence, the correction is smaller than the course it
replaces, and no new artifact or process was introduced. Confirm that the
`Next:` line matches the authoritative turn. If any check fails, revise the
intervention once or use Failure Behavior; do not start a review loop.

## Examples

**Drift:** The brief calls for fixing one dispatcher timeout, but the proposed
move also redesigns the harness. Return `REALIGNED`: keep the timeout repair,
remove the redesign, and preserve unrelated accepted work.

**Ceremony:** A reversible prose correction is about to receive a new evidence
template and two review passes. Return `REALIGNED`: use the changed text against
its quoted before-state and drop the new machinery.

**Necessary governance:** A shared-state migration has one independent safety
review because a wrong result is hard to recover. Return `ALIGNED` when the
review has a clear bright line and no duplicate layer; anti-ceremony is not a
license to remove a safeguard that earns its cost.

## Runtime Recommendations

Keep this skill instruction-only and file-based. Do not add a hook, script,
automatic trigger, or persistent finding store. It is an operator-invoked mode
for rare corrective use, and should consume no context during routine Work Loop
turns. Keep it inline because the current conversation and exact active task are
inputs; do not fork it. Use the current Codex model and do not declare a model
default. Do not restrict activation by repository path because the active task
may belong to any project checkout. Leave tools unrestricted so the current
Work Loop contract can govern reads and any authorized edit to its existing
state file.
