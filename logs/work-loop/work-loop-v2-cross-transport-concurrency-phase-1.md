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

Standard. Discovery mode. Unit 3a2c — capture the complete post-correction dispatcher regression result.

Named reason for the loop: the accepted repair spans shared process leasing, two transports, durable ownership, controller tests and authorized live validations; it requires multiple bounded units and independent assessment before it can support an integration decision.

## Brief

The ordinary carrier suite is now accepted at exit 0, passed 316, failed 0. The last full dispatcher regression ran before the cross-transport 12e fixture correction and reported pass 471, fail 11, with all 11 failures confined to those then-obsolete fixture oracles; the corrected targeted 12e slice subsequently passed 21/0 and its stale-oracle mutant failed exactly the setup assertions. The approved proposal's rollout step 4 still requires the full existing dispatcher suite after the combined changes, so this unit closes that one remaining dispatcher-level unknown without adding analysis or implementation.

Named unknown: whether the complete ordinary `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` suite is green on the current committed implementation and corrected fixtures.

Required outcome: run the complete ordinary dispatcher suite exactly once, synchronously in the foreground, and write its complete stdout/stderr plus an unambiguous final exit-code line to `logs/harness-runs/dispatcher-suite-unit-3a2c-foreground-20260814.out`. The shell invocation must not return until the suite terminates and the exit-code line has been appended. Only after that command returns, read the durable output footer and record the exact exit code and passed/failed totals in this state file. If failures exist, record their case/assertion names without fixing, diagnosing or rerunning anything.

Constraints and evidence:

- Verify the suite path, then run the complete ordinary suite once from its intended directory.
- Foreground execution is mandatory. Do not use `&`, `nohup`, `disown`, a detached process, an asynchronous/background tool call, or any mechanism that lets the actor finish before the suite. There is no later turn in the one-shot `claude -p` process.
- Use one foreground shell sequence that redirects stdout/stderr to the exact new raw-output path, captures the suite exit code even when nonzero, and appends exactly `SUITE_EXIT=<code>` after termination. Wait for that sequence to return before touching the state file.
- Preserve the raw output whether green or red. Do not stage or commit it.
- Do no source inspection, baseline reconstruction, diagnosis or remediation. Do not edit any source or test file, run any other suite, or repeat this suite.
- Edit and commit only this state file by explicit pathspec. Hand back at `turn: codex` with the state commit hash.

Open deferrals carried without action: helper pin-file write/copy durability, carrier process-group parameter naming, and the dispatcher suite's lack of a case selector. None belongs in this verification unit.

Stop after recording the one completed result, whether green or red. If the suite cannot start, record that fact without substitution.

Completion condition: one complete ordinary dispatcher suite has run once in the foreground; its raw output and appended exit code exist at the exact path above; the exact result is recorded without analysis or source changes; only the state file is committed; and the task hands back at `turn: codex`.

## Latest result

Inspected (2026-08-14):

- Claim (1) the ordinary dispatcher suite exists at `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`: HOLDS — ran `ls -l` on that exact path; found a regular executable file, `-rwxr-xr-x`, 189050 bytes, mtime Aug 14 12:53.
- Claim (2) the required raw-output path is new: HOLDS — listed `logs/harness-runs/` for `dispatcher-suite-unit-3a2c-*`; no match before the run (only the 3a2b carrier outputs and the harness `.out`/`.log` pairs were present).

Result: Unit 3a2c ran the complete ordinary dispatcher suite exactly once, synchronously in the foreground, from `plans/work-loop-v2-v0.2/handoff-automation-spike`. The suite is **green at exit 0, pass 482, fail 0**. No failing case or assertion was reported, so no case/assertion names are recorded. Nothing was diagnosed, fixed, rerun or otherwise changed; no source or test file was touched. This closes the last dispatcher-level unknown that the accepted proposal's rollout step 4 required after the combined changes: the prior full-suite reading of pass 471 / fail 11 is superseded, and all 11 previously failing assertions — every one confined to the then-obsolete cross-transport 12e fixture oracles — now pass on the committed implementation with the corrected fixtures. The total assertion count is unchanged at 482 (471 + 11), so the correction converted the stale-oracle failures rather than removing or skipping them.

Evidence: durable raw output at `logs/harness-runs/dispatcher-suite-unit-3a2c-foreground-20260814.out`, 688 lines, whose final two lines are the suite's own footer `pass=482 fail=0  (all cases SIMULATED — no live product transport)` and the appended `SUITE_EXIT=0`. The foreground shell sequence captured the suite's exit status into `rc` and appended `SUITE_EXIT=$rc` only after the suite terminated, and it returned `rc=0`; the state file was not touched until that sequence had returned. The check could have read differently: a nonzero `rc` would have been written verbatim into the same `SUITE_EXIT=` line, and any failing assertion would have appeared as a `  FAIL ` result line in the same file — a `grep -n -E '^pass=|^SUITE_EXIT=|FAIL'` over the output returns only the footer, the exit line, and five case *titles* containing the word, with no result-line FAIL. The raw output is preserved and deliberately left unstaged and uncommitted, as the brief requires. Unit 3a2c state commit `59d095a8`; it changed only this state file.

Accepted evidence carried forward: Unit 3a2b carrier suite green at exit 0, passed 316, failed 0 (`logs/harness-runs/carrier-suite-unit-3a2b-foreground-20260814.out`), state commit `8be728e9`, pointer commit `f9125746`. Implementation and targeted controller evidence through Unit 3a2a: shared helper and dispatcher through `5255628a`; carrier shared lease at `04de80a7`; carrier pin correction at `2bef1acf`; cross-transport 12e fixture correction at `33d90df9` with state pointer `50874ea2`, targeted pass 21 / fail 0 and stale-oracle mutant pass 19 / fail 2.

Deferrals carried without action, unchanged: helper pin-file write/copy durability; carrier process-group parameter naming; the dispatcher suite's lack of a case selector. None was in this verification unit's scope and none was implemented.

## Blocker

None.

## Next action

Codex: assess Unit 3a2c. Both controller suites are now green on the committed implementation — carrier 316/0 and dispatcher 482/0 — so the rollout step 4 controller-level unknown is closed. Decide whether that completes the controller-evidence portion of the exit condition and what opens next: the two explicitly authorized live validations (one genuine cross-transport contention proof, one genuine fan-out-two Work Loop pair), or a prior step. The three carried deferrals remain unimplemented and are for the closure record, not for a new unit.
