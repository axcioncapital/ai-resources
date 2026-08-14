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

Standard. Discovery mode. Unit 3a2d — capture the complete owner-helper regression result.

Named reason for the loop: the accepted repair spans shared process leasing, two transports, durable ownership, controller tests and authorized live validations; it requires multiple bounded units and independent assessment before it can support an integration decision.

## Brief

The complete ordinary carrier suite is accepted at 316/0 and the complete ordinary dispatcher suite is accepted at 482/0. Claude's Unit 3a2c handback said rollout step 4 was closed, but the approved proposal's step 4 explicitly also requires the existing owner-helper suite. That omission is corrected here without reopening either accepted suite or adding implementation work.

Named unknown: whether the complete ordinary `logs/scripts/work-loop-owner.test.sh` suite is green on the current committed implementation.

Required outcome: run that suite exactly once, synchronously in the foreground, and write its complete stdout/stderr plus an unambiguous final exit-code line to `logs/harness-runs/owner-suite-unit-3a2d-foreground-20260814.out`. The shell invocation must not return until the suite terminates and the exit-code line has been appended. Only after that command returns, read the durable output footer and record the exact exit code and passed/failed totals in this state file. If failures exist, record their case/assertion names without fixing, diagnosing or rerunning anything.

Constraints and evidence:

- Verify the suite path, then run the complete ordinary suite once from its intended directory.
- Foreground execution is mandatory. Do not use `&`, `nohup`, `disown`, a detached process, an asynchronous/background tool call, or any mechanism that lets the actor finish before the suite. There is no later turn in the one-shot `claude -p` process.
- Use one foreground shell sequence that redirects stdout/stderr to the exact new raw-output path, captures the suite exit code even when nonzero, and appends exactly `SUITE_EXIT=<code>` after termination. Wait for that sequence to return before touching the state file.
- Preserve the raw output whether green or red. Do not stage or commit it.
- Do no source inspection, baseline reconstruction, diagnosis or remediation. Do not edit any source or test file, run any other suite, or repeat this suite.
- Edit and commit only this state file by explicit pathspec. Hand back at `turn: codex` with the state commit hash.

The shared lease helper's own suite is already accepted at 50/0 from its implementation unit and is not repeated here. Open deferrals carried without action: helper pin-file write/copy durability, carrier process-group parameter naming, and the dispatcher suite's lack of a case selector.

Stop after recording the one completed result, whether green or red. If the suite cannot start, record that fact without substitution.

Completion condition: one complete ordinary owner-helper suite has run once in the foreground; its raw output and appended exit code exist at the exact path above; the exact result is recorded without analysis or source changes; only the state file is committed; and the task hands back at `turn: codex`.

## Latest result

Inspected (2026-08-14):
- Claim (1) — the owner-helper suite exists at `logs/scripts/work-loop-owner.test.sh`: HOLDS — listed `logs/scripts/work-loop-owner.test.sh`; found a regular file, 34501 bytes, whose header states `Usage:  bash logs/scripts/work-loop-owner.test.sh` and resolves `REPO_ROOT` as `logs/scripts -> logs -> checkout root`.
- Claim (2) — the approved proposal's rollout step 4 also requires the owner-helper suite: HOLDS — read `plans/work-loop-v2-v0.2/work-loop-v2-cross-transport-concurrency-and-task-aware-worktrees-implementation-proposal-2026-08-13.md` line 490; found "**Re-run every existing suite** from a clean checkout: dispatcher, carrier, owner helper", with the recorded baseline "owner 92/0" at line 491.
- Claim (3) — the required raw-output path is new: HOLDS — searched `logs/harness-runs/` for `owner-suite-unit-3a2d-foreground-20260814.out`; no match before the run.

Unit 3a2d — the complete ordinary owner-helper suite ran once, synchronously in the foreground, from the checkout root. It is **RED: exit 1, 86 passed, 6 failed** (summary line `T1..T13 + F1..F3: 86 passed, 6 failed`). Recorded without diagnosis, remediation or rerun, as the brief requires.

The six failing assertions, by case:

- T1 — same task, same checkout, second dispatcher refused across different TMPDIR roots: `control — a shared TMPDIR root is refused (passes on the baseline)` (line 11); `a DIFFERENT TMPDIR root is refused too` (line 16).
- T3 — a second task entering a claimed checkout is refused, and the holder is named: `a second dispatcher on a DIFFERENT task in the same checkout is refused` (line 31).
- T4 — fan-out 2 on separate worktrees completes with no cross-task paths: `worktree 1 completes` (line 38); `worktree 2 completes` (line 43).
- F1 — an unavailable ownership check is distinguishable from a clean one: `the dispatcher REFUSES a checkout with no helper` (line 119).

Evidence: `logs/harness-runs/owner-suite-unit-3a2d-foreground-20260814.out` holds the complete stdout/stderr of the single run with the appended final line `SUITE_EXIT=1`. The file is untracked and deliberately not staged. The check can fail in both directions: the same harness returned `SUITE_EXIT=0` shape for the carrier and dispatcher runs of Units 3a2b and 3a2c, and this run's own Case 0 (harness falsifiability with the helper absent) passed, so the six failures are the suite discriminating, not the harness collapsing.

Recorded against the proposal's baseline for comparison only, with no reconciliation attempted here: the proposal records owner `92/0`; this run totals 92 assertions with 6 failing.

Accepted Unit 3a2c: the complete ordinary dispatcher suite ran once synchronously and is green at **exit 0, pass 482, fail 0**. Durable evidence is `logs/harness-runs/dispatcher-suite-unit-3a2c-foreground-20260814.out`; state commit `59d095a8`, pointer commit `e2a39065`, both state-only.

Accepted Unit 3a2b: the complete ordinary carrier suite ran once synchronously and is green at **exit 0, passed 316, failed 0**. Durable evidence is `logs/harness-runs/carrier-suite-unit-3a2b-foreground-20260814.out`; state commit `8be728e9`, pointer commit `f9125746`, both state-only.

Accepted implementation and targeted controller evidence through Unit 3a2a remains: shared helper and dispatcher through `5255628a`; carrier shared lease at `04de80a7`; carrier pin correction at `2bef1acf`; cross-transport 12e fixture correction at `33d90df9` with state pointer `50874ea2`, targeted pass 21/fail 0 and stale-oracle mutant pass 19/fail 2.

## Blocker

None.

## Next action

Codex: assess Unit 3a2d. The named unknown is resolved and the answer is negative — the complete ordinary owner-helper suite is **red at exit 1, 86/6** on the current committed implementation, against the proposal's recorded owner baseline of 92/0. Rollout step 4 is therefore not satisfied: two of the three existing suites are green (carrier 316/0, dispatcher 482/0) and the third is not.

Decide how the six failures are framed before any further work: whether they are a regression introduced by the Phase 1 shared-lease change, a harness expectation that Phase 1 intentionally superseded, or an environment-dependent result. That framing is Codex's, not Claude's — no diagnosis was performed here, per the brief.

Deferrals carried without action, unchanged: helper pin-file write/copy durability; carrier process-group parameter naming; the dispatcher suite's lack of a case selector.

Noted this unit and not acted on: the raw output file is untracked and stays uncommitted, so the six failing assertion names in `## Latest result` are the only durable record of this run inside Git. If that record must survive a clean checkout, committing the harness output is a decision for Codex or the operator, not a Claude fix.
