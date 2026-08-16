---
task: work-loop-v2-durable-state-system
status: active
turn: codex
---

## Objective and scope

Implement the frozen Work Loop v2 durable-state plan sequentially until the accepted state system is demonstrated end to end and ready for the operator's landing decision.

Scope is the capabilities, migration order, eight tracer bullets, assessment gates, and completion proof in `plans/work-loop-v2-v0.2/work-loop-v2-durable-state-system-implementation-plan-v0.1.md`. The plan's explicit exclusions remain excluded; repository evidence may challenge a factual premise or expose a safety contradiction, but may not silently redesign the accepted architecture.

## Lane and unit

Standard. Implementation mode. Unit 8 — Tracer bullet 6: prove deterministic lifecycle and recovery failures.

Named reason for the loop: this is the next ordered slice of the frozen multi-unit migration and must deliberately prove nine recovery and lifecycle outcomes across several real seams before live concurrency and final cutover proof can begin.

## Brief

Tracer bullet 5 is accepted: the complete five-component deployment capability now fails visibly when incomplete, and its correction proved that the three project-owned files are preserved by the documented merge-only remedies. Tracer bullet 6 is next in the frozen sequence because the new contract must now prove deterministic stop and recovery behaviour under deliberately created failures, not only component tests or design prose.

**Required outcome:** Produce one coherent, fail-capable operational proof of all nine lifecycle/recovery scenarios assigned to Tracer bullet 6 at the real validator, Reorient, owner, command, or courier seams. Each scenario must distinguish the accepted outcome from the corresponding wrong behaviour with a negative control or narrow failpoint.

**Governing authority and constraints:**

- The frozen plan governs: Fixed decisions 1–15, Capabilities C and D, the rollback boundary, Tracer bullet 6, its Proof Matrix assignments, and Execution and Assessment Rules.
- The accepted executable core, validator, owner helper, Reorient, actor-entry command, and courier contracts govern their own semantics. Reuse them and the repository's existing harness/test conventions; add no fallback lifecycle parser, second state store, general-purpose test framework, or speculative recovery machinery.
- Admissions remain paused through operational proof and final landing. Tracer bullet 7's migration/concurrency/live trials and Tracer bullet 8's representative end-to-end demonstration are adjacent work deliberately held outside this unit because the frozen plan assigns them later.
- Live model trials, cross-transport contention, broad fuzzing, performance testing, deployment, merge, push, landing, and production adoption are excluded by the plan or by this unit boundary.
- This is a proof unit. If a scenario exposes an actual runtime defect, preserve and return the red evidence with `turn: codex`; do not silently expand this unit into a runtime repair outside the proof surface.

**Verify first against the repository:**

1. Reconfirm the exact checkout and task, HEAD `4f721055`, `ACTIVE_CLAUDE`, unique repository-depth ownership, and free shared leases. Stop on ambiguity, a competing actor, or a different HEAD.
2. Bound the existing proof inventory to `.claude/commands/work-loop-v2.md`, `.agents/skills/reorient/SKILL.md`, `logs/scripts/work-loop-state.sh` and its test, `logs/scripts/work-loop-owner.sh` and its test, `logs/scripts/work-loop-v2-slice-1.test.sh`, `scripts/axcion-harness-v0.2/carry-turn.sh` and its test, and the dispatcher plus its existing tests under `plans/work-loop-v2-v0.2/handoff-automation-spike/`. For each of the nine scenarios, identify which existing assertion or seam already proves part of it and what composing or failpoint evidence is still missing. Any absence claim must name this searched surface and the pattern used.
3. Verify rather than assume that existing owner tests cover the two closure-interruption states and that carrier/dispatcher tests expose termination and partial effects. Existing component proof may be cited or composed where it reaches the required real seam; do not duplicate it merely to obtain a new count.
4. Check whether the nine scenarios can be demonstrated with temporary Git repositories/worktrees and narrow failpoints without changing runtime behaviour. If not, return the exact unsupported scenario or false premise and stop.

**Proof scenarios required by the frozen plan:**

1. A fresh session with no useful chat reconstructs the same status, turn, latest result, blocker, and next action from the exact task path or validated owner.
2. Compaction/Reorient with an empty or misleading summary cannot override durable state and returns the same validator classification.
3. Unexpected actor termination preserves partial effects and does not blindly relaunch.
4. An interrupted or truncated state update is rejected before launch, while the last committed state plus working diff gives deterministic repair evidence.
5. Operator-blocked recovery retains ownership and refuses a new task.
6. Closure interruption before commit retains ownership.
7. Closure interruption after commit but before owner clear yields `CLOSED` plus a safely clearable stale owner.
8. Task state and Git disagreement stops without automatic rewrite.
9. Clean closure clears ownership and permits checkout reuse.

**Implementation boundary:** Add only the smallest existing-style composing/failpoint proof surface needed to exercise the nine scenarios. Reuse/import accepted component evidence when it proves the required seam, but ensure the combined scenario verdict itself can fail; do not create one fixture framework per scenario or a new general framework. Keep hook-written `logs/friction-log.md` and `logs/innovation-registry.md` uncommitted and outside the commit.

**Required evidence:**

- Give a scenario-by-scenario table or equally exact report: seam exercised, setup/failpoint or negative control, expected wrong behaviour distinguished, observed classification/exit and decisive evidence, and verdict.
- For scenarios 1 and 2, show field-level equality for status, turn, latest result, blocker, and next action, plus validator classification; a prose claim that recovery is correct is insufficient.
- For scenarios 3 and 4, show the preserved partial evidence and prove that no blind relaunch or automatic repair occurred.
- For scenarios 5–9, show the exact owner/state classifications and mutation boundary before and after the injected stop or clean closure.
- Report exact focused-proof assertion counts and exits, plus directly affected regression suite counts and exits. Identify which checks are newly added, reused, or imported by reference.
- Report the implementation commit and exact changed paths. Demonstrate that runtime behaviour, Tracer 7/8 surfaces, excluded machinery, friction log, and innovation registry did not enter the commit, and that the final record validates `ACTIVE_CODEX`.

**Completion condition:** Commit the bounded Tracer 6 proof and return all nine deterministic, fail-capable scenario verdicts in `## Latest result`, with `status: active` and `turn: codex`. State whether any runtime defect was exposed; confirm admissions remain paused, no live model or cross-transport trial ran, nothing was merged, pushed, or landed, and Tracer bullet 7 has not started.

**Stop conditions:** Stop and hand back if a load-bearing premise is false; any scenario lacks a real seam or fail-capable discriminator; producing the proof requires a fallback parser, second state system, general framework, runtime redesign, live model invocation, cross-transport trial, excluded capability, or operator-reserved action; a runtime defect makes the expected outcome red; or the repository/owner/lease preflight is not exact.

Capability subset: baseline only — read and inspect repository state and history, run local tests, edit the existing task-scoped proof/test surfaces needed for Tracer 6, and make the local coherent commit. Nothing is selected from the pre-authorizable set, which is empty today. No operator-reserved capability is needed.

## Latest result

Unit 8 / Tracer bullet 6 executed. Nine scenarios run at real seams with negative controls. **Eight pass; scenario 6 is red, and the red is a genuine runtime finding, not a fixture artifact.** No runtime file was changed — this is a proof unit and the defect is returned rather than repaired.

Inspected (2026-08-16):

- Claim (1): HOLDS — checkout `ai-resources-durable-state`, branch `session/2026-08-14-durable-state`, HEAD `4f721055`; validator `ACTIVE_CLAUDE`; `work-loop-owner.sh check --depth repo` `PROCEED`. Shared leases free: the Git common directory's `work-loop-dispatch-locks` holds only `refusals/20260815T154142-30771-cross-transport-concurrency-correction.refusal` and no lock directory or pid file, so no automated actor is in flight.
- Claim (2): HOLDS — every named surface exists and was read: `.claude/commands/work-loop-v2.md`, `.agents/skills/reorient/SKILL.md`, `logs/scripts/work-loop-{state,owner}.sh` and both tests, `logs/scripts/work-loop-v2-slice-1.test.sh`, `scripts/axcion-harness-v0.2/carry-turn.{sh,test.sh}`, and `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.{sh,test.sh}`. Existing coverage per scenario is in the table below under "existing seam".
- Claim (3a): HOLDS — searched `logs/scripts/work-loop-owner.test.sh` for closure-interruption coverage; T14 cuts the closure at both points — (b) pre-commit and (c) post-commit/pre-clear — and T8 covers reuse after closure. **But T14(b)'s fixture is a *half-written* reduction (status flipped, active body still standing) which the validator refuses, so staleness is never reached.** The complete-but-uncommitted reduction, which core § 4 requires ("The reduction is one write"), is not covered anywhere. That gap is where S6's finding lives.
- Claim (3b): HOLDS — searched `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` for termination and partial effects; Case 8b asserts `PARTIAL FILE EFFECTS`, Case 13b asserts no launch over a partial edit, Case 15 asserts a pre-edit crash is retried once and 15b that a post-edit crash is not. `scripts/axcion-harness-v0.2/carry-turn.test.sh` carries `ignore-term`, `denied-partial` and `allowed-partial` probes at the SIGTERM/SIGKILL seam.
- Claim (4): HOLDS — all nine were demonstrated in throwaway `git init` repositories with narrow failpoints (a crashing `--actor-cmd`, a truncated file, a written-but-uncommitted reduction). No runtime behaviour was changed to make any scenario reachable; `git diff` over `logs/scripts/work-loop-{owner,state}.sh`, `dispatch.sh`, `carry-turn.sh`, `.claude/` and `.agents/` is empty.

Result: one new composing harness, `logs/scripts/work-loop-v2-tracer-6.test.sh` (**68 passed, 2 failed, exit 1**). It composes the accepted component helpers and invokes the real dispatcher; it re-implements nothing and re-runs no component suite to collect a count.

| # | Scenario | Seam | Failpoint / negative control | Wrong behaviour distinguished | Observed | Verdict |
|---|---|---|---|---|---|---|
| 1 | fresh session reconstructs the record | Reorient route 2 + validator | control: the committed record is changed and re-read | a route that echoes remembered values | all five fields equal the committed record; `ACTIVE_CLAUDE`; control returns the changed value and the two reconstructions differ | PASS |
| 2 | misleading summary cannot override state | same route + validator | none / empty / contradicting-summary variants; control proves the summary really contradicts | durable state bending to the summary | identical five fields and identical `ACTIVE_CODEX` in all three; a genuinely closed record does classify `CLOSED`, so the two are distinguishable | PASS |
| 3 | termination preserves partial effects, no relaunch | dispatcher | crash after edit; control: crash before edit | discarding the partial edit, or blind relaunch | exit **20**, `PARTIAL FILE EFFECTS` naming the file, **1** launch, edit still on disk; control retried to **2** launches | PASS |
| 4 | interrupted update rejected before launch | dispatcher pre-launch guard | truncated uncommitted record; control: uncommitted `turn: claude` handoff | launching over damage, or auto-repairing it | exit **26** naming `required heading '## Lane and unit' is missing` and "No actor was launched"; **0** launches; file byte-unchanged; `HEAD` copy intact and `git diff` shows exactly the damage; control runs (exit 23, 1 launch) | PASS |
| 5 | blocked recovery retains owner, refuses new task | validator + owner helper | control: the same checkout over a `CLOSED` record | refusing everything, or resuming a blocked task | `BLOCKED_OPERATOR`; claim refused (exit 3) naming `blocked-task`; declaration byte-unchanged; Reorient stops at check 5; control claim succeeds | PASS |
| 6 | closure interrupted before commit retains owner | owner helper + validator | **complete, valid** reduction written, commit not reached | the lease being released while the closure is uncommitted | declaration survives a passive read, nothing committed, `HEAD` still `active` — **but the next task start CLAIMS the checkout (exit 0) and clears the declaration** | **FAIL** |
| 7 | closure interrupted after commit | owner helper + validator | control: the same start over an `ACTIVE` record | clearing live and stale declarations alike | `CLOSED`; stale declaration survives; next start clears it (exit 0); control refuses (exit 3) and leaves it | PASS |
| 8 | state/Git disagreement stops without rewrite | dispatcher (a) + validator (b) | (a) uncommitted divergence, (b) identity mismatch; control: an agreeing checkout | silent reconciliation | (a) exit 25, file and `HEAD` byte-unchanged; (b) exit **14**, record byte-unchanged; control proceeds (exit 23, 1 launch) | PASS |
| 9 | clean closure clears owner and permits reuse | owner helper + validator | control first: claim before closure | reuse while the task is open | control refused (exit 3); then `CLOSED` validated, cleared (exit 0), declaration gone, new task claims (exit 0) | PASS |

**The finding — scenario 6.** Core § 4 requires the closing reduction to be one write, so the likely pre-commit interruption lands *after* a complete, valid closing record exists on disk and *before* the commit. In that state the validator correctly answers `CLOSED` for a closure Git has no record of, and `work-loop-owner.sh claim` treats the surviving declaration as stale and clears it. Reproduced independently of the harness, in a bare `git init` repository:

- committed record `status: active`; working tree `status: closed`; validator `CLOSED`; `.owner` = `t`
- `work-loop-owner.sh claim --task next --depth local` → `verdict: PROCEED`, exit **0**, reason "clearing a stale declaration ... which the validator classifies CLOSED"
- after: `.owner` = `next`; committed record still `status: active`

The end state is lease released plus closure uncommitted — the state core § *Closing the task* names as "the one state that cannot be recovered from", reached from the other direction. `work-loop-owner.test.sh` stays green because T14(b) uses a half-written reduction the validator refuses, so it never reaches the staleness path. Whether this is a defect to fix in Tracer 6's scope, an accepted limitation, or work for a later tracer is Codex's call; nothing was changed to make it pass.

Evidence and counts:

- New: `logs/scripts/work-loop-v2-tracer-6.test.sh` — 70 assertions, **68 passed, 2 failed**, exit 1. All nine scenarios and Case 0 are newly added here.
- Reused by invocation (not re-implemented): the real `logs/scripts/work-loop-state.sh`, `logs/scripts/work-loop-owner.sh` and `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`.
- Imported by reference, not re-run: owner T8/T14(a)(b)(c); dispatcher cases 8b, 13b, 14, 15, 15b; carry-turn's `ignore-term` / `denied-partial` / `allowed-partial` probes.
- Case 0 falsifiability — a stub validator that always prints `ACTIVE_CLAUDE` is substituted for the real one on a genuinely closed record; the real answer is `CLOSED`, the stub's is `ACTIVE_CLAUDE`, and the two differ, so scenarios 2, 5, 7 and 9 would go red under it.
- Regression, all exit 0 and all unchanged from the Unit 7 baselines: state **96/0**, owner **103/0**, session preflight **60/0**, capability **77/0**, slice 1 **308/0**, core resolver **4/0**, lease **136/0**.
- Runtime untouched: `git diff` over `logs/scripts/work-loop-owner.sh`, `logs/scripts/work-loop-state.sh`, `dispatch.sh`, `carry-turn.sh`, `.claude/` and `.agents/` is empty.
- Commit `096b8985` (this handback commit adds only the pointer) — exact paths: `logs/scripts/work-loop-v2-tracer-6.test.sh`, `logs/work-loop/work-loop-v2-durable-state-system.md`. No runtime file, no Tracer 7 or 8 surface, no excluded machinery, and neither `logs/friction-log.md` nor `logs/innovation-registry.md` entered it; both remain uncommitted. This record validates `ACTIVE_CODEX`.

A runtime defect **was** exposed: scenario 6, above. Admissions remain paused. No live model trial and no cross-transport trial ran; nothing was merged, pushed or landed; Tracer bullet 7 has not started.

## Blocker

None.

## Next action

Codex: assess Unit 8. Eight scenarios are green with controls; scenario 6 is red on a reproduced runtime finding — a complete-but-uncommitted closing reduction lets the next task start release the lease. Decide whether that is fixed inside Tracer 6, accepted as a written limitation, or assigned to a later tracer, and whether the eight green verdicts and Case 0 are proportionate proof for this tracer's exit condition.
