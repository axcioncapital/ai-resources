---
task: develop-ai-resource-retirement-verdict
turn: codex
---

## Objective and scope

Give an existing durable AI artifact a real retirement path inside `/develop-ai-resource`, so
retirement cannot be declared while references or machinery remain and the removal is not recorded.

Scope: `.claude/commands/develop-ai-resource.md`; one minimal corresponding change in
`docs/ai-resource-creation.md` only if the command would otherwise remain undiscoverable or conflict
with that policy; and this state file. Excluded: retiring any actual resource, adding a command,
register, lifecycle store, gate or artifact; operating-capability retirement; non-AI repository
feature retirement; the v1 capability method and template; and any Unit 4 disposition.

## Lane and unit

Standard. Implementation mode. Unit 3 — give `retire` an owner for durable AI artifacts only.

Named reason for the loop: this changes a shared governing command and introduces a destructive
lifecycle verdict. A wording-only patch could appear complete while still allowing the exact
dangling-route failure that triggered the unit, so the result needs bounded implementation,
fail-capable replay evidence and independent Codex assessment.

Plan justification: the operator approved the corrected plan content committed at `6af280e` and has
explicitly started Unit 3. Unit 1, the only prerequisite named by the plan, is formally closed at
`logs/work-loop/develop-ai-resource-v2-capability-seam.md`; Unit 2's implementation has been accepted
but its closing-record write remains procedural debt and is not a Unit 3 prerequisite. Governing
unit: `plans/work-loop-v2-v0.2/resource-capability-development-plan-v0.1.md` § 7, Unit 3.

## Brief

Why this unit, why now: the approved plan identifies one narrow lifecycle gap—durable AI artifacts
can be created and improved through `/develop-ai-resource`, but an artifact already in service has no
owner for retirement. The 2026-08-06 `/work-loop` v1 removal is the concrete failure: the command was
deleted while live routes remained. This unit adds only the missing ownership and evidence standard;
it does not retire anything or generalize the answer to other object classes.

### Governing and applicable sources

- Current operator instruction to start Unit 3 — governing authorization for this unit.
- `logs/work-loop/work-loop-v2-resource-capability-plan.md` — content-bound approval record for plan
  commit `6af280e`; its earlier statement that Units 1–4 were not yet authorized is superseded for
  Unit 3 by the current operator instruction, and for nothing else.
- `plans/work-loop-v2-v0.2/resource-capability-development-plan-v0.1.md` § 7, Unit 3 — governing
  outcome, boundary, exclusions and evidence standard.
- `logs/work-loop/develop-ai-resource-v2-capability-seam.md` — authoritative closed prerequisite.
- `.claude/commands/develop-ai-resource.md` — implementation target and current authority for durable
  AI-resource qualification, building, verification and disposition.
- `docs/ai-resource-creation.md` — current policy for AI-resource creation and improvement; edit only
  if needed for truthful retirement discoverability or authority.
- `skills/capability-development/SKILL.md` and `templates/capability-record.md` — read-only adjacent
  sources for the existing operating-capability retirement standard. Borrow the useful principle;
  do not claim this command owns operating capabilities or edit those sources.
- `logs/improvement-log.md` entry beginning at current line 2823 and the repository evidence for
  commit `0516bf6` — the real failure case to replay, not authority for a broader design.

Codex framing decision: a retirement owner is only real if an operator can reach it for an existing
in-service artifact and if it is distinguishable from deleting an unadopted candidate. Therefore the
smallest coherent change may touch the command's description, input/authority boundary, § 1.6 and
Step 4, rather than adding the word `retire` to § 1.6 alone. This is an outcome requirement, not a
prescribed wording or internal sequence; keep every change necessary and remove every change that
does not alter behaviour.

### Verify before mutation

Check each claim against the live repository before editing. If a load-bearing claim is false,
record what was inspected and found, set `turn: codex`, commit only this state file if appropriate,
and stop rather than improvising a different lifecycle design.

1. In `.claude/commands/develop-ai-resource.md`, § 1.6 still has no retirement-equivalent verdict.
   Report the current complete verdict list.
2. In the same command, Step 4's built-candidate choices remain `Ship`, `Revise`, `Defer` and
   `Delete candidate`, and describe a candidate produced in the current run rather than an existing
   artifact already in service.
3. The command's description, argument hint, input statement and Authority section do not currently
   establish retirement of an existing durable AI artifact as an invocation the command owns.
4. `skills/capability-development/SKILL.md` still says retirement must remove the machinery and
   record what was removed, and `templates/capability-record.md` still treats `retired` as an
   operating-capability terminal status. These establish adjacent substance and object-class
   boundaries; they do not grant `/develop-ai-resource` ownership of operating capabilities.
5. The `0516bf6` retirement and `logs/improvement-log.md` entry still support the plan's factual
   premise: the v1 `/work-loop` command was removed while live routes remained. Inspect the
   repository evidence and identify the missed reference/consumer surfaces rather than relying on
   the plan's count alone.
6. Unit 1's sequential one-owner boundary remains present: Work Loop v2 owns unresolved operating
   outcomes; `/develop-ai-resource` owns the later durable-AI-artifact question; artifact
   disposition does not take operational adoption away from its owner.
7. `docs/ai-resource-creation.md` does not already assign retirement of durable AI artifacts to a
   different live owner. Search only the current AI-resource policy and live owner surfaces needed
   to settle this claim, and report the bounded search.

### Required outcome

Amend the existing `/develop-ai-resource` flow so that:

- retirement is an explicit possible verdict for an **existing durable AI artifact already in
  service**, and the command is truthfully invokable for that case;
- the flow distinguishes retirement from `Delete candidate`, which remains the disposition for an
  unadopted candidate produced during the current run;
- every actual retirement requires an explicit operator decision before removal;
- before that decision, the proposal identifies the artifact, every live reference, consumer,
  invocation, deployment or other operational surface that depends on it, and the replacement or
  accepted loss for each;
- completion requires the approved machinery and references to be removed or explicitly
  dispositioned, validation that no dangling operational route remains, and a record of what was
  removed in the normal task/commit evidence—without creating a retirement register or new artifact;
- a dependency that cannot yet be removed or safely dispositioned causes a stop, revision or
  deferral rather than a false retirement;
- operating-capability retirement and non-AI repository-feature retirement are explicitly outside
  this verdict's ownership;
- create, improve, reuse, no-build, defer and upstream-artifact disposition behaviour from Unit 1
  remain unchanged.

Use the smallest coherent edit. A documentation change is permitted only if inspection shows it is
needed to make the owner discoverable or prevent a policy contradiction; otherwise leave the
documentation untouched. Do not actually remove, archive, disable, rename or retire any resource.

### Fail-capable acceptance evidence

Return all five evidence groups in `## Latest result`:

1. **Historical retirement replay.** Replay `0516bf6` against the amended flow using the actual
   missed surfaces found during verification. Show the point at which the new flow would have
   blocked completion until those surfaces were named and cleared or dispositioned. This fails if
   the amended flow would still allow "retired" while a live route remains.
2. **Live-dependency stopping case.** Walk an existing durable AI artifact proposed for retirement
   while one consumer or invocation path must remain. Show that the flow stops, revises or defers
   rather than removing the artifact or declaring retirement complete.
3. **Candidate-deletion non-interference.** Walk an unadopted candidate rejected in the current run
   and show that it still reaches `Delete candidate`, not retirement. Also show one ordinary
   create-or-improve case remains on its existing path.
4. **Object-class boundary.** Walk an operating-capability retirement request and show that the
   amended command does not claim ownership or perform it. State that non-AI feature retirement is
   likewise outside scope; do not invent a replacement owner.
5. **Boundary and simplification proof.** Identify every changed line and why it changes behaviour;
   confirm no new component, gate, register or persistent artifact was added; confirm no resource
   was actually retired; and confirm no file outside the authorized target(s) and this state file
   changed for this unit. Existing unrelated changes must not be staged, reverted or committed.

Completion: `/develop-ai-resource` is a reachable and bounded owner for retirement of durable AI
artifacts only; the replay and stopping cases can fail and pass for the right reasons; candidate
deletion and existing flows still behave as before; and all exclusions hold. Set `turn: codex`,
commit only the authorized target file(s) and this state file by explicit pathspec, and stop for
assessment.

Stop and hand back to Codex if any verify-first claim is false, truthful retirement ownership
requires a new component or persistent artifact, or the evidence cannot distinguish complete
retirement from deletion alone. Stop for the operator before any actual retirement, any reopening of
the approved object-class boundary, or any hard-to-reverse action.

## Latest result

Correction round (2026-08-07). All three frozen findings reproduced by inspection before any edit,
and all three are corrected. Nothing else was implemented.

Reproduced:

- Finding (1): REPRODUCES — the branch opened "It is reached by a direct invocation naming an
  in-service artifact, or by the 1.6 retirement verdict." The `Input:` line accepts "an existing
  resource to improve, **or** an existing resource to retire", so an ordinary improvement invocation
  also names an in-service artifact and satisfies the first condition. The branch could capture it,
  bypassing qualification entirely.
- Finding (2): REPRODUCES — the Authority bullet asserted that operating-capability retirement
  "belongs to that capability's own owner and is recorded against its capability record", that a
  non-AI repository feature is "ordinary repository work", and that this command "names the owner and
  routes". The approved plan says otherwise at
  `plans/work-loop-v2-v0.2/resource-capability-development-plan-v0.1.md`: line 274 — operating
  capability is "**Defined, but unreachable** … **No change here. This is Unit 4's question**"; line
  276 — non-AI repository feature is "**Nobody, and no candidate owner exists** … Stated as an open
  ownership question, not answered", carried as a § 11 deferral. Three live routes were implied where
  the plan records none.
- Finding (3): REPRODUCES — the closing rule admits `no build · reuse as-is · rejection · deferral`
  only, while Step 4's completion criterion requires that an `inbox/` input "has left the intake
  queue". A retirement ending in `Retire` or `Keep` matched no listed disposition, so the criterion
  was unsatisfiable for an inbox-originated retirement.

Result: three corrections, four lines changed in
`.claude/commands/develop-ai-resource.md` (`git diff --stat` → 4 insertions, 2 deletions).

1. **Entry is now the § 1.6 verdict and nothing else.** The branch states that naming an in-service
   artifact at invocation does not select it, that an argument may *propose* retirement while only
   qualification establishes it, and that a run opening "retire X" which qualifies to `improve an
   existing resource` takes the built-candidate branch.
2. **The object-class sentence now states the boundary and two unresolved dispositions, and names no
   substitute.** Operating-capability retirement "has a definition, but the layer holding it lost its
   executor, so it is currently unreachable and its disposition is an open question"; non-AI
   repository-feature retirement "has no candidate owner at all and is carried as a recorded
   deferral". It closes: "Where a request is one of them, say which class it is and that its
   ownership is unresolved — do not name a substitute owner."
3. **The inbox rule now reconciles the retirement branch** in an added sentence that leaves the
   existing disposition list untouched: `Retire`, `Keep` and `Defer` are terminal and archive under
   the existing convention (with `Defer` naming its reopening trigger); `Revise` is not terminal and
   the brief stays queued.

Evidence:

**Finding 1 — two direct invocations, two branches.**

- `/develop-ai-resource "improve /prime's task menu"` — an in-service artifact is named. Under the
  old text the first entry condition was met and the retirement branch was reachable. Under the
  corrected text entry requires the § 1.6 verdict; Step 1 qualifies this to `improve an existing
  resource`, Step 2 routes it to a build engine, and Step 4 takes the **built-candidate** branch with
  `Ship · Revise · Defer · Delete candidate`. The retirement branch is never entered.
- `/develop-ai-resource "retire /prime's task menu"` — also names an in-service artifact, and the
  argument proposes retirement. Entry still is not automatic: Step 1 runs, and only a § 1.6 verdict of
  `retire an existing resource` opens the **retirement** branch. Had qualification instead concluded
  `improve an existing resource`, this invocation would take the built-candidate branch — which is
  the discrimination the correction adds.

  **How this could fail:** it fails if both invocations reach the same branch, or if the argument
  alone decides. Neither holds now — the deciding sentence is "**The § 1.6 verdict is the only
  entry**", and the worked case of a retirement-worded argument qualifying to `improve` is stated in
  the text itself, so the two conditions are separable on the page.

**Finding 2 — the two excluded-object cases re-run.**

- *Operating capability.* A request to retire the live `prime-runtime-delegation` capability. The
  command states this is outside its AI-artifact boundary, that the class is currently unreachable
  because the layer holding its definition lost its executor, and that its disposition is an open
  question. **No owner is named** — previously the capability record was offered as a live return
  address. The run says which class it is and stops there.
- *Non-AI repository feature.* A request to retire a repository feature that is not an AI artifact.
  The command states there is **no candidate owner at all** and that it is carried as a recorded
  deferral. It does not route to Work Loop v2: the plan's line 276 says Work Loop v2 can *execute*
  such a retirement as an ordinary unit but that no rule says what the retirement must record, so
  naming it as the owner would assert the very thing the plan leaves open.

  **How this could fail:** it fails if either case yields a live route. Both now yield a named class
  plus "ownership is unresolved". The check that discriminates is the plan itself — lines 274 and 276
  record no owner, so any owner appearing in the command would be an invention.

**Finding 3 — four inbox-originated retirement outcomes.** Input is a brief in `inbox/` proposing that
a durable AI artifact be withdrawn.

- `Retire` — the artifact is removed on the approved plan; the brief archives to `inbox/archive/` with
  the date, the disposition and the reason. Queue cleared.
- `Keep` — retirement is refused; the brief archives the same way. The added sentence gives the
  reason: "the record that retirement was proposed and refused is the point" — the same logic the
  four provenance checks already rely on, where a `rejected` record persists as evidence.
- `Defer` — the artifact stays in service; the brief archives with the concrete trigger that would
  reopen retirement, which is the existing deferral convention applied unchanged.
- `Revise` — **not** terminal. The plan changes, the run continues, and the brief stays in the queue.
  Step 4's completion criterion is therefore not yet satisfied, which is correct: no decision has
  been reached.

  **How this could fail:** it fails if a retirement outcome leaves the queue in a state the closing
  rule cannot express, or if `Revise` silently archived a brief that is still open. The first is
  closed by naming all three terminal outcomes; the second by marking `Revise` non-terminal
  explicitly. The pre-correction text failed the first for `Retire` and `Keep`.

**Did the correction break anything?** No. Content-anchored `shasum` against the pre-correction commit
`3c84c70` returns **UNCHANGED** for every item the hand-back required preserved: the
operator-before-removal gate, the dependency inventory, the same-search completion standard, the
`Delete candidate` distinction, the stop rule, Unit 1's § 1.0 four checks, all of Step 2, all of
Step 3, the built-candidate branch with its upstream disposition, and the existing `inbox/`
disposition sentence. The no-new-machinery boundary holds — "No retirement register, tracker or status
file" is still present, and no component, gate or artifact was added. No resource was retired. Only
`.claude/commands/develop-ai-resource.md` and this state file were staged; `logs/friction-log.md` and
`plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` were dirty from other work and were not
staged, reverted or committed.

**The two deferrals from the implementation round are carried forward unchanged:**

1. `docs/ai-resource-creation.md:17` still names the deleted `/work-loop` as this command's
   "operating-outcome sibling" and describes the reserved-field handoff as live. Not edited — the
   brief permits a documentation change only for retirement discoverability or a policy contradiction
   with this change, and it is neither.
2. `docs/ai-resource-development-playbook/RESOURCES.md:13` links to
   `../../.claude/commands/work-loop.md`, a file that no longer exists.

Nothing newly noticed during this round required implementation, so no new deferral is recorded.

## Blocker

None.

## Next action

Codex: run the closure check on the three frozen findings only — are (1) branch entry, (2) the
object-class dispositions and (3) the inbox reconciliation resolved, and did the correction break
anything. The preserved-item check against `3c84c70` is recorded above.
