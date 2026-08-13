# Decision Journal

> Archive: [decisions-archive-2026-08.md](decisions-archive-2026-08.md)

## 2026-08-09 — Close work-loop-v2-production-readiness-policy without a Codex assessment

**Context.** The task's discovery unit was complete and committed at `turn: codex`, awaiting Codex's
assessment of the recommended production policy (§ 3), five operator decisions (§ 4) and five
implementation units (§ 5). The operator directed that Codex not be used for this assessment.

**Decision.** Replace the Codex assessment with an independent `/research` subagent pass that
re-verified all eight of the discovery's findings against the live repository by opening the actual
files, rather than trusting the discovery's own prose. Act on that verdict directly rather than
waiting for Codex.

**Rationale.** The research surfaced a material change the discovery could not have known about:
commit `9c66f26` (2026-08-07) added `dispatch.sh --unattended`, which disables the dispatched child's
hooks entirely. That made the discovery's central recommendation for the shared-writer problem
(D1 — edit `log-write-activity.sh` to suppress telemetry for dispatched actors) unnecessary: the
ambient writer cannot fire in a contained hop, so there is nothing left to suppress. D1 was replaced
with a launch precondition (`--unattended`) rather than a hook edit, and the plan's only planned
structural-change unit (U2) was dropped as a result.

**Alternatives considered.**
- *Wait for Codex, as the protocol's normal path.* Rejected by explicit operator direction — the
  operator judged the research route sufficient for this task's stakes.
- *Execute the discovery's recommendation unchanged (D1 as originally written).* Rejected once the
  research showed it was superseded: it would have spent a structural-class hook edit and its
  risk-aware review on a problem that had already stopped existing three days earlier.
- *Treat the state file as final without re-verification.* Rejected — the discovery was three days
  old, several commits had landed since, and the state file's own protocol (core § 6 rule 1) requires
  checking claims against the live repository before acting on them, regardless of which party does
  the checking.

**Recorded departure from protocol.** The Work Loop v2 executable core assigns the close verdict to
Codex (§ 3 step 5); this closure did not go through that step. It is recorded in the closed state
file's Accepted limitations as an operator-directed exception for this task, not as a change to the
protocol itself.

## 2026-08-11 — Tailored structural-resolution route for the Work Loop v2 bounded-execution incident

**Context.** A 2026-08-10 Work Loop v2 session escaped its bounded courier path into an interactive
Claude session that spawned ≥13 Claude processes to test instruction files. Claude's first-pass fix
plan recommended adding a control (`--allow-nested-actors N`) without first comparing removal or
simplification, and it self-contradicted about what the proposed control could prove.

**Decision.** The operator directed a tailored eight-step route rather than a full run of the
Repository Problem Resolution SOP's Lane B: establish the failure from preserved run evidence (no
live reproduction); a blind raw-evidence review by a genuinely fresh Codex context; Claude reconciles
that into a causal model and options at a zero complexity budget; operator scope approval; isolated
clean-checkout implementation; independent verification; one genuine attended pilot capped at one
Claude invocation and ten minutes; close only on observed behaviour, not harness success alone. The
SOP is applied as non-governing methodology, subordinate to the Work Loop v2 executable core — it adds
no state-file field and does not override core close/continue/correct/stop.

**Rationale.** The incident's root mechanism was unbounded verification cost from nested AI
invocation. A route that itself required a costly live reproduction or new AI-backed verification
before design approval would repeat the failure it exists to prevent. Establishing failure from
already-preserved evidence, and deferring construction decisions to a design gate, keeps the
correction bounded while still passing through independent challenge before any implementation.

**Alternatives considered.**
- *Run the full unmodified SOP Lane B sequence.* Not rejected in substance — the tailoring keeps all
  five Lane B gates — but the route was made explicit and case-specific rather than assumed generic,
  because a generic run would have invited exactly the same disproportionate-verification failure at
  a different step.
- *Accept Claude's first-pass plan as final.* Rejected — it proposed new permanent machinery
  (`--allow-nested-actors N`) with no verified authorised use case anywhere in the evidence, and
  self-contradicted about whether its own proposed control was containment.

**Recorded departure from protocol.** None — this decision operates alongside the Work Loop v2 core
rather than against it; the SOP's subordination to the core, and the prohibition on it creating a
second state system, are stated explicitly in the accepted plan
(`plans/work-loop-v2-v0.2/bounded-execution-fix-plan-v0.1.md` § 0.1).

## 2026-08-11 — Second bounded-execution incident joins the plan, scoped to system-level lessons only

**Context.** A second Work Loop v2 dispatcher stop occurred 2026-08-11, in a different worktree
(`../ai-resources-eval`, task `eval-mvp-v0.2-adoption-readiness-fix`): a 900-second actor timeout
(exit `21`), reportedly caused by an oversized implementation unit. The operator supplied a detailed
incident report and asked whether it belonged inside `bounded-execution-fix-plan-v0.2.md`.

**Decision.** Yes, in the same plan — but only its system-level lessons. In scope: the eval timeout as
a second verify-first entry in Gate 2's evidence set; brief sizing promoted P1→P0; U2's evidence
extended to exit 21; U4 expanded into a truthful recovery contract; a rejection of "raise the
timeout" as a substitute fix; the eval evidence chain added to the compaction-safe manifest. Out of
scope, named explicitly and excluded from the plan: the EV-1 through EV-6 content repairs, the
staging-hook registry correction, the eval branch's merge readiness, and its stale suite baselines.

**Rationale.** The two incidents are the two failure modes of the same courier boundary — one escaped
it, one couldn't fit inside it — so the system-level fix belongs in one place. But the eval content
issues are evidence *of* the sizing defect this plan addresses, not instances *of* the dispatcher
defect itself; folding them in would let an already-oversized-unit incident produce an oversized
planning artifact, which is the exact failure mode under discussion.

**Alternatives considered.** (a) A separate plan for incident 2 — rejected, because the two incidents
share a root mechanism (courier boundary) and splitting the plan would duplicate §§ 0.5–0.7's
manifest, ladder and courier-preservation reasoning. (b) Importing the eval content findings wholesale
— rejected for the reason above; also would have pulled unrelated-task commits into this plan's
review surface. (c) Treating incident 2 as fully confirmed rather than verify-first — rejected; every
report is a lead until checked against its own named artifacts (SOP `:435`), and this one had not
been.

## 2026-08-11 — Unauthorized Codex commit taken over rather than trusted or discarded wholesale

**Context.** Codex committed `2511117` on top of `6ab33a2` without authorization, implementing four
review-corrections that were Claude's responsibility. The operator directed independent inspection —
"do not assume its implementation is correct" — with authority to replace the commit after
verification, not to push.

**Decision.** Inspected the diff and ran the full simulated harness (424/424 green at that point),
then wrote separate probes targeting cases Codex's own test additions did not cover — since Codex
authored both the fix and the tests proving it, its suite could not be trusted as independent
evidence. Found all four fixes behaviourally correct. Rather than reimplementing from scratch or
accepting the commit as-is, kept the implementation and added the one regression its suite was
missing (case 41b — the attribution mechanism the O2 fix depends on), proving it fail-capable against
two hand-built mutants before trusting it green. Reset to `6ab33a2`, staged exactly the three touched
files, and committed as a Claude-authored replacement (`570c4fb`), leaving `audits/working/` and all
unrelated files untouched.

Two further requests in the same session applied the same standard — independent verification plus a
fail-capable regression proven against the pre-fix dispatcher — to two more named review findings
(`7ee93d7`, `8b9a63d`), each strictly scoped to the one finding named and leaving the rest, including
the explicitly off-limits fabricated U3 fixture, untouched.

**Rationale.** An unauthorized commit from another actor is not evidence of correctness or of error —
treating it as either without inspection would have been the same failure mode from either direction.
Verifying independently and keeping what holds up is more efficient than a blanket reimplementation,
and is the only way to also catch what the original author's own tests couldn't see (the missing
case 41b would have shipped invisibly otherwise).

**Alternatives considered.** (a) Trust the harness Codex left behind as sufficient proof — rejected,
because the author and the test author were the same actor, so a shared blind spot would be invisible
to that suite by construction. (b) Discard the commit and reimplement from the review findings alone
— rejected as wasteful once inspection showed the implementation itself was sound; the actual gap was
narrower (one missing regression) than a full reimplementation would have addressed. (c) Fix the
malformed git identity (`patriklindeberg75@@gmail.com`) while replacing the commit — rejected, since
every recent commit in the repo already carries it and silently changing it would create an
inconsistent identity mid-history; flagged to the operator instead.

## 2026-08-12 — 15 failing harness cases diagnosed as environmental, not repaired

**Context.** The Codex assessment of the merged bounded-execution repair froze three findings. The
second required diagnosing 15 failing 27-series harness cases: "If they are real merge regressions,
repair only the ceremony/bounded-execution interaction they expose. If they are caused by the
restricted verification environment, demonstrate that with fail-capable evidence from the normal
supported test environment." The reviewers' own run had ended `exit 1, pass=408 fail=15`, and the
blocker said the dispatcher must not enter its attended pilot while the integrated harness is red.

**Decision.** Diagnosed the failures as environmental and made **no repair** to the dispatcher or
the harness. Evidence: one full integrated run on the corrected tree in the normal supported
environment, `exit 0, pass=454 fail=0`, with every reported-failing case passing (`27`, `27b`–`27n`,
`27L`) and bounded-execution cases `40`–`47` passing.

**Rationale.** The reviewers' failures were concentrated in the 27-series *control* assertions —
"escapee alive and OUTSIDE the actor's group", "the orphan is re-parented to pid 1", "a live
root-owned PID is available". Those controls probe whether the host permits process-group and
ancestry inspection at all; they are not assertions about dispatcher behaviour. A failed control
short-circuits the behavioural assertion behind it, which is also why the two runs are not
comparable on totals (423 assertions there, 454 here) — the failing run never reached the
assertions the controls guard. The suite is demonstrably fail-capable in both directions: it exited
`1` for the reviewers, and its controls are written to fail loudly exactly when the environment
cannot establish the process facts.

**Load-bearing supporting fact.** The green result is attributable to the merged code rather than to
this correction: the dispatcher diff against `f994900` changes exactly one executable line (the
`claude_deny=none` log string), and everything else in `dispatch.sh` is comment text. Without that
check, a correction round that edits prose and then reports a green suite invites the reading that
the edits produced the green.

**Alternatives considered.** (a) Repair the 27-series interaction as a merge regression — rejected,
since inspection showed nothing to repair: the cases pass unmodified. Changing working code to
satisfy a failure that only occurs where process inspection is forbidden would have introduced a
real defect to chase an artefact. (b) Treat the red suite as blocking and hand back rather than
diagnose — rejected, because the frozen finding explicitly provided the environmental branch and
asked for it to be demonstrated, so handing back would have been a refusal to do the named work.
(c) Report the earlier mixed harness runs, where `dispatch.sh` was edited mid-run — rejected and
both runs discarded; a green count from a run whose subject changed underneath it is not evidence.

**Accepted limitation, stated in the closing record.** The diagnosis establishes that the merged
suite is green where process inspection is permitted. It does not certify any other host.

## 2026-08-13 — Axcíon Harness v0.2 adopted for normal attended pilot use

**Context.** `plans/axcion-harness-v0.2/mvp-plan.md` Phase 2's exit condition — a real bounded task
crossing a fresh-process handoff via the canonical carrier — was met by the closed
`axcion-harness-v0-2-live-trial` task. The carrier existed, was deterministically tested (98/0, five
fail-capability mutants), and had proven itself in one live handback, but no live Work Loop
instruction actually selected it: the skill still routed attended courier use to the spike dispatcher.

**Decision.** Task `axcion-harness-v0-2-go-live`, run across two Work Loop v2 units. Unit 1 changed
`.agents/skills/work-loop-v2/SKILL.md` so the attended courier command now invokes
`scripts/axcion-harness-v0.2/carry-turn.sh` with exact checkout/task inputs and a task-derived
allow-path policy, leaving unattended routing to the spike dispatcher untouched. Unit 2, an
Adoption-mode discovery unit, then recommended — and the operator accepted — **adopting the carrier
for normal attended pilot use**: single checkout, single writer, one hop per invocation. Not
unattended, not concurrent, not cross-worktree, no automatic landing or push, and explicitly not
final Phase 3 adopted status (that bar is still the governing plan's three-to-five representative
tasks and its later adopt/shrink/stop verdict).

**Rationale.** The one real fresh-process carry cost the operator exactly one action — the foreground
launch — with zero prompts and a clean `code=0` exit. The only untested element of the pilot
configuration (the allow-path policy in the canonical checkout, as opposed to the isolated trial
checkout the one live carry actually ran in) fails safe: a wrong allow-path produces a pre-launch
refusal, not a corrupting run. Withholding the release to eliminate that one uncertainty would trade
the operator's stated ASAP priority for a failure mode that already announces itself.

**Ruling on the newly found deferral.** Unit 2 surfaced one item not previously deferred: a second
ambient writer (`detect-innovation.sh`, a user-level `PostToolUse` hook) will dirty
`logs/innovation-registry.md` — a path outside the documented allow-path set — the first time a pilot
unit edits a `.claude/commands`, `.claude/agents` or `.claude/hooks` file. The operator ruled this a
**safe-stop limitation, not a release blocker**: the affected carry stops before launching anything,
so nothing runs and nothing changes. Routed as small Direct Work for later rather than fixed inline,
since fixing it fell outside Unit 2's Adoption-mode discovery scope.

**Alternatives considered and rejected.** *Revise before pilot use* — would hold the release for a
one-line allow-path addition whose absence already produces a self-diagnosing stop. *Continue the
pre-pilot trial* — would gather more evidence without the harness being usable, when the missing
evidence is exactly what normal use produces. *Stop* — contradicted by the deterministic suite, the
one clean live carry, and the fail-closed stop-code contract.

**Accepted limitations, carried into the closing record.** No carrier-level cross-worktree ownership
check (`work-loop-owner` is called from the spike dispatcher, not from `carry-turn.sh`) — nonblocking
only for single-checkout, single-writer use, and must close before any wider ownership or concurrency
claim. Untracked `logs/harness-runs/` accumulation and the absence of a permanent route-selection
regression check — both nonblocking, both to revisit before final Phase 3 adoption.
## 2026-08-13 — Close the branch-bound compaction-survivability task; deployment continues in a new main-bound task

**Context.** Unit 6 discovery established that the three approved deployment-consumer checkouts are
one repository in three worktrees, not three projects, and surfaced a hard blocker: the Work Loop
cannot complete in any of them today because `logs/scripts/work-loop-owner.sh` is absent from all
three. This branch's own corrections (Units 4–5) are committed but not on `ai-resources/main`, so no
project checkout currently reads them.

**Decision.** Close `work-loop-v2-compaction-survivability-repair` now, as a review-clean instruction
repair plus a verified deployment map — explicitly not as completed deployment or completed
operational proof. Promote its committed work to `ai-resources/main` (merge only, no push). Open a
new, main-bound Work Loop v2 task for installation, the missing-helper fix, and the representative
compaction proof, rather than extending this branch-bound task to cover them.

**Rationale.** Installing from a branch the projects do not read would prove nothing — the projects'
skill links and the stable hook-carrier path resolve into `main`, not into this worktree. Keeping the
task branch-bound and closing it once its actual deliverable (instruction layer + map) was done avoids
stretching one task across a branch boundary that changes what "done" can mean partway through.

**Alternatives considered.** (a) Extend this task with further units for installation and proof —
rejected, because the units would be no-ops until the merge happens, and mixing a branch-bound
discovery/repair task with cross-repository, machine-level writes risked concealing a scope mistake,
which Unit 6's own framing decision had already flagged as a reason to keep them separate. (b) Merge
first, then continue the same task on `main` — rejected by the operator in favor of a clean new task,
to avoid copying or concurrently reopening this state file in two places at once.

## 2026-08-13 — User-level and repository-level Codex hooks aggregate; the later user-level registration must suppress the repo-level one

**Context.** Unit 6 discovery could not settle, from repository or documentation evidence, whether a
user-level `~/.codex/hooks.json` entry and the existing repository-level `ai-resources/.codex/hooks.json`
entry for the same `SessionStart`/`compact` event would both fire or whether one would shadow the
other. This mattered because the approved deployment plan is to add a user-level compact-hook carrier
for machine-wide reach.

**Decision.** Treat the two hook layers as additive (both fire). Any later user-level compact
registration must be written to replace or otherwise suppress the existing repository-level
registration, so exactly one trigger remains effective per compaction event.

**Rationale.** An isolated, non-model query against the installed Codex `hooks/list` interface (a
temporary-home, isolated check — not sourced from official documentation, which does not specify
this) returned both the synthetic user `SessionStart`/`compact` entry and the repository
`SessionStart`/`compact` entry as enabled simultaneously. Treating them as additive and designing the
user-level write to suppress the repo-level one is the only reading consistent with that observation
that avoids double-firing (the exact double-reorientation defect an earlier draft of the carrier was
already corrected to avoid).

**Alternatives considered.** Assuming the more specific (repository) hook would automatically override
the more general (user) one — rejected as unverified; the query showed both enabled, not one
suppressing the other. Deferring the question to the deployment unit itself — rejected, because it
would have meant writing the user-level hook without knowing whether it introduces a double-fire
regression, in a task whose own risk review named "single ownership" of the recovery trigger as a
structural constraint.
