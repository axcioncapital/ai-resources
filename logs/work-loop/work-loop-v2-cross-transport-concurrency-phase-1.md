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

Standard. Discovery mode. Unit 3a2b foreground recovery — capture one complete carrier-suite result in the foreground before any analysis.

Named reason for the loop: the accepted repair spans shared process leasing, two transports, durable ownership, controller tests and authorized live validations; it requires multiple bounded units and independent assessment before it can support an integration decision.

## Brief

Two earlier Unit 3a2b verification carries stopped without a trustworthy suite result. The first stopped at carrier exit `20` after the laptop slept and the Claude connection closed. The second stopped at exit `22` because Claude backgrounded the suite, exited the one-shot actor, and left the state byte-identical; its partial output has 131 passing assertions but no totals or exit code. On 2026-08-14 the operator explicitly approved this fresh, smaller foreground-only recovery. It preserves both stopped attempts as evidence and does not repeat either hop.

Named unknown: whether the complete ordinary `scripts/axcion-harness-v0.2/carry-turn.test.sh` suite is green on the current committed implementation.

Required outcome: run that suite exactly once, synchronously in the foreground, and write its complete stdout/stderr plus an unambiguous final exit-code line to the new file `logs/harness-runs/carrier-suite-unit-3a2b-foreground-20260814.out`. The shell invocation must not return until the suite itself has terminated and the exit-code line has been appended. Only after that foreground command returns, read the durable output footer and record the exact exit code and passed/failed totals in this state file. If failures exist, record their case/assertion names without fixing or rerunning anything.

Constraints and evidence:

- Verify the suite path, then run the complete ordinary suite once from its intended harness directory. Do not use `--prove-failure`.
- Foreground execution is mandatory. Do not use `&`, `nohup`, `disown`, a detached process, an asynchronous/background tool call, or any mechanism that lets the actor finish before the suite. Do not say that the suite is still running or that a later turn will record its result; this is a one-shot `claude -p` process and there is no later turn.
- Use one foreground shell sequence that redirects the suite's stdout/stderr to the new raw-output path, captures its exit code even when nonzero, and appends exactly `SUITE_EXIT=<code>` after the suite terminates. Wait for that sequence to return before touching the state file.
- Preserve both raw output files whether the suite passes or fails. Do not overwrite, truncate or delete the earlier partial file `logs/harness-runs/carrier-suite-unit-3a2b-recovery-20260814.out`. Do not stage or commit either harness-run artifact; the state file points to the new complete one.
- Do no baseline reconstruction, source inspection, diagnosis or remediation in this recovery. The previous brief's extra analysis is deliberately removed to minimize post-run response work.
- Edit and commit only this state file by explicit pathspec. Hand back at `turn: codex` with the state commit hash.
- Do not edit any source or test file, run any other suite, or repeat the carrier suite.

Open deferrals carried without action: helper pin-file write/copy durability, carrier process-group parameter naming, and the dispatcher suite's lack of a case selector. None belongs in this recovery.

Stop after recording the one captured result, whether green or red. If the suite cannot start, record that fact without substitution.

Completion condition: one complete ordinary carrier suite has run once in the foreground; its raw output and appended exit code exist at the new exact harness-run path above; the exact result is recorded without analysis or source changes; only the state file is committed; and the task hands back at `turn: codex`.

## Latest result

Inspected (2026-08-14):
- Claim (1) — the suite exists at `scripts/axcion-harness-v0.2/carry-turn.test.sh`: HOLDS — listed that exact path; found a regular executable file, 92551 bytes, mode `-rwxr-xr-x`.
- Claim (2) — the required output path is new: HOLDS — listed `logs/harness-runs/carrier-suite-unit-3a2b-foreground-20260814.out`; `ls` returned "No such file or directory", so nothing was overwritten.
- Claim (3) — the earlier partial output must survive: HOLDS — listed `logs/harness-runs/` before and after the run; `carrier-suite-unit-3a2b-recovery-20260814.out` is unchanged at 5687 bytes, mtime Aug 14 14:59.
- Claim (4) — no `carry-turn.test.sh` process survived the stopped background attempt: HOLDS — searched the live process table with `pgrep -fl 'carry-turn.test.sh'`; no match (exit 1).

Unit 3a2b foreground recovery — named unknown resolved. The complete ordinary carrier suite is GREEN on the current committed implementation.

Result: `scripts/axcion-harness-v0.2/carry-turn.test.sh` was run exactly once, synchronously in the foreground from its own harness directory, with no `--prove-failure`, no `&`, no `nohup`, no detachment and no background tool call. The shell sequence did not return until the suite had terminated and `SUITE_EXIT=0` had been appended. Recorded result: **exit code 0, passed 316, failed 0** — no failing case or assertion names to record. Both stopped attempts are superseded as suite evidence and their raw files are preserved untouched. No source or test file was edited, no other suite was run, and the suite was not repeated.

Evidence: durable raw output at `logs/harness-runs/carrier-suite-unit-3a2b-foreground-20260814.out` — 363 lines / 15395 bytes, opening `carry-turn.sh — deterministic suite`, footer `passed: 316   failed: 0` followed by the appended `SUITE_EXIT=0`. The check could have read differently: the suite exits 1 and prints a `failing:` block naming each case when any assertion fails, and its own `--prove-failure` mode exists to demonstrate that the assertions do fail against mutated launchers — the same harness returned pass=19 fail=2 on the Unit 3a2a stale-oracle mutant. The foreground exit code was also echoed independently of the file as `FOREGROUND_RETURNED rc=0`, so the file footer and the shell's own status agree. This recovery's state commit is `8be728e9`; it changed only this state file, and neither harness-run artifact is staged or committed.

Accepted implementation and targeted controller evidence through Unit 3a2a is unchanged: shared helper and dispatcher through `5255628a`; carrier shared lease at `04de80a7`; carrier pin correction at `2bef1acf`; cross-transport 12e fixture correction at `33d90df9` with state pointer `50874ea2`.

## Blocker

None.

## Next action

Codex: assess the Unit 3a2b foreground recovery result — the ordinary carrier suite is green at exit 0, passed 316, failed 0 — and decide whether the controller-level acceptance coverage for Phase 1 is now sufficient, or which unit opens next toward the two authorized live validations. The three carried deferrals are still open and untouched: helper pin-file write/copy durability, carrier process-group parameter naming, and the dispatcher suite's lack of a case selector.
