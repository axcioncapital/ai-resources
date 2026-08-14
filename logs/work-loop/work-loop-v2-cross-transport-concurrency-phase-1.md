---
task: work-loop-v2-cross-transport-concurrency-phase-1
turn: codex
---

## Objective and scope

Implement and validate Phase 1 of the accepted Work Loop v2 cross-transport concurrency proposal: one shared repository-rooted live-lease contract used by the attended carrier and unattended dispatcher, plus fail-closed repository-depth ownership admission before the carrier launches an actor. Complete the controller-level acceptance coverage, preserve both transports' intentional boundaries and existing behavior, make only the necessary Work Loop instruction updates, and run the two explicitly authorized live validations after the implementation has passed independent assessment.

Task exit condition: the Phase 1 implementation and required instruction changes are committed in this worktree, the relevant controller suites and failure paths pass, one genuine cross-transport contention proof and one genuine fan-out-two Work Loop pair produce the accepted evidence, and the final limitations and rollback path are recorded for an operator integration decision.

Scope: the Phase 1 files and test surfaces named in `plans/work-loop-v2-v0.2/work-loop-v2-cross-transport-concurrency-and-task-aware-worktrees-implementation-proposal-2026-08-13.md`, plus this state file. Temporary linked worktrees may be created only when the approved live validations require them; implementation remains bound to this checkout.

Excluded: Phase 2 task-aware automatic worktrees; changing or replacing D4; changes to the executable core; automatic merge, landing, push, branch deletion, worktree cleanup or other destructive cleanup; a scheduler, registry, service or lease database; and concurrency outside Work Loop v2. No work is performed in the main checkout.

## Lane and unit

Standard. Implementation mode. Unit 8r2 — foreground validation and commit of the preserved Unit 8 holder-label correction.

Named reason for the loop: the accepted repair spans shared process leasing, two transports, durable ownership, controller tests and authorized live validations; it requires multiple bounded units and independent assessment before it can support an integration decision.

## Brief

The original Unit 8 hop stopped at the fixed 900-second boundary after completing the two bounded file edits and failing-first proof. Recovery 8r1 then started the suite asynchronously and returned before it finished; the carrier correctly stopped at exit 22 and terminated the unfinished suite. The operator approved this second, narrower recovery. Preserve the partial edits; do not reimplement them.

Governing authority remains the approved Phase 1 proposal bound at `10d2eeb6f8868b2f073e11150dc1a50a95ea760a`, §4.1 property 5, §5 cross-transport expectations, and §7 revise/adopt criteria. The recovery is bounded to validating the already-present edits in `dispatch.sh` and `dispatch.test.sh`, recording the result, and committing them with this state file.

Required outcome:

1. Inspect the preserved diff and confirm it is internally complete: task and checkout held-lease messages map `carry`, `dispatch`, empty, and unknown holder-program metadata truthfully; acquisition, exit 17, pin behavior, and the shared helper are unchanged.
2. Treat `logs/harness-runs/20260814-unit8-holder-label-red.out` and the completed `20260814-unit8-dispatcher-red.out` result (510/7) as the failing evidence. Confirm the seven failures are exactly the new holder-label assertions against the pre-correction dispatcher, not unrelated regressions.
3. Treat `20260814-unit8-holder-label-green.out` as the focused green proof. The existing `20260814-unit8-dispatcher-green.out` is incomplete because the carrier killed the hop mid-suite; do not report it as a complete pass.
4. Run the complete dispatcher suite once against the preserved corrected files **in the foreground**. The Bash tool call must not use `run_in_background`, shell `&`, detached execution, or a timeout shorter than the suite; wait for the command's terminal exit before doing anything else. Capture it to a new raw output under `logs/harness-runs/`, require exit 0 with explicit counts, then run `git diff --check`.

Do not edit the dispatcher files further unless the preserved diff is mechanically incomplete or the suite identifies a failure caused by these edits; if so, stop and hand back rather than broadening. Do not rerun helper, owner, carrier, red, or focused proofs.

Commit only `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, its `dispatch.test.sh`, and this state file with explicit pathspecs. Completion condition: the foreground suite reaches its final summary and exits 0, the preserved correction is validated, the bounded files are committed, and the task hands back at `turn: codex`. If the suite has not printed its final summary, do not return or hand back.

## Latest result

Inspected (2026-08-14):

- Claim (1) — the preserved diff is internally complete: HOLDS — read `git diff` for both bounded files. `dispatch.sh` adds one `holder_label()` helper mapping `carry` → "an attended carry", `dispatch` → "another dispatcher", empty → "another Work Loop run (program unrecorded)", and any other value → "another Work Loop run (%s)" verbatim; the task and checkout refusals substitute it, and the shared-tree hazard line reads "two Work Loop runs". The acquisition call `wl_lease_acquire dispatch "$$"` is a context line, both `WL_LEASE_REFUSAL = pinned` branches are context lines, and every refusal still exits 17.
- Claim (1a) — the shared helper is unchanged: HOLDS — `git status --short` lists four modified files and `logs/scripts/work-loop-lease.sh` is not among them; that file defines `WL_LEASE_HOLDER_PROGRAM` at lines 117, 152 and 180, which is the field the new label reads.
- Claim (2) — the completed full red is 510/7 and the seven failures are exactly the new holder-label assertions: HOLDS — `20260814-unit8-dispatcher-red.out` ends `pass=510 fail=7`; searched it for `^FAIL` and found exactly seven, at lines 84, 89, 109, 112, 137, 140, 146, all of them the new 12e/12g holder-identity assertions. No unrelated regression appears in that list.
- Claim (3) — `20260814-unit8-holder-label-green.out` is the focused green proof and `20260814-unit8-dispatcher-green.out` is incomplete: HOLDS — the focused red prints `STOP [17] another dispatcher holds task xt-shared` against a lease whose `program` file reads `carry`; the focused green prints `an attended carry holds task xt-shared` for the same case. The full green output ends mid-Case-27c with no summary line, so it is not a complete pass and is not reported as one.

Result: the preserved Unit 8 holder-label correction is validated and committed. No further edit to the dispatcher files was needed — the preserved diff was mechanically complete and the suite found no failure caused by it.

Evidence: the complete dispatcher suite was run once in the foreground against the preserved files and reached its final summary — `logs/harness-runs/20260814-unit8r2-dispatcher-green.out`, exit 0, `pass=517 fail=0`. That is the same suite whose pre-correction run was `pass=510 fail=7`; 510 + 7 = 517 accounts for every assertion, so no case was skipped to reach green. All nine holder-label assertions pass by name in the green output (lines 62, 66, 84, 85, 101, 102, 125, 126, 130), including the two `out_lacks` negatives that fail if the refusal calls a carrier a dispatcher and the dispatcher-held controls at 12/12b that fail if reading the holder lost the case already correct. `git diff --check` exits 0.

Deferral, not done here: `logs/harness-runs/` is untracked in this worktree, so the green output above lives on disk but is not in any commit. The brief bounds this commit to the two dispatcher files and this state file, so the pointer is recorded rather than committed. Whether these raw run outputs should be tracked is a Codex decision, not a widening of this unit.

## Blocker

None. Live cases 23 and 24 remain closed until this unit is accepted.

## Next action

Codex: assess Unit 8r2 — the preserved holder-label correction validated by a complete foreground suite at 517/0 against a 510/7 red, committed with this state file. Decide close, continue, correct once, or stop, and rule on the untracked-harness-output deferral.
