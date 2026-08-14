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

Standard. Implementation mode. Unit 9r2 — finish and focused-validate the preserved dispatcher logging fix.

Named reason for the loop: the accepted repair spans shared process leasing, two transports, durable ownership, controller tests and authorized live validations; it requires multiple bounded units and independent assessment before it can support an integration decision.

## Brief

Case 23 exposed an observability defect rather than a concurrency failure: the real dispatcher correctly refused at exit 17, but the refusal happened before its requested log directory and run log existed. Unit 9r1 timed out after preserving changes to the dispatcher and its test; the operator approved this narrower recovery and explicitly asked to avoid ceremony.

Governing authority: the operator-approved Phase 1 proposal bound at `10d2eeb6f8868b2f073e11150dc1a50a95ea760a`, especially §5 case 23 and §7 step 5; the operator's current approval authorizes this bounded recovery. The autonomy-improvement report at `plans/work-loop-v2-v0.2/dispatcher-work-loop-harness-autonomy-improvement-report-2026-08-14.md` is non-governing background describing the observed defect.

Required outcome: a dispatcher invocation that stops during shared-lease acquisition must still leave a durable, machine-readable run record in its requested log directory, including the stop code and reason, without launching an actor. `--status` must remain read-only and create no log.

Check against the repository before acting:

1. Verify in `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` whether shared-lease acquisition currently precedes requested log-directory and run-log initialization, and whether that ordering explains why the observed exit 17 produced no file. If not, stop and hand back the actual cause.
2. Search `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` for existing coverage proving that an explicit `--log-dir` receives a durable record when acquisition exits 17 before actor launch. If equivalent coverage already exists, stop and explain why it did not protect the live run.

Scope: `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, its controller test, this state file, and raw evidence under `logs/harness-runs/`. Codex's framing decision: one representative pre-actor exit-17 case is sufficient; do not build an exhaustive early-exit matrix. Excluded: the carrier, shared lease helper, owner helper, Work Loop instructions or core, live case 23 itself, case 24, Phase 2, main checkout, landing, push, cleanup, and unrelated report recommendations.

Required evidence:

1. Inspect the preserved two-file diff for completeness and proportionality. The observed live absence of `logs/harness-runs/case23-live-dispatcher/` is the failing case; do not manufacture a second red replay.
2. Finish the minimum correction and run the new controller case in isolation. Show it green, including a stable terminal record carrying at least outcome, code 17, task, and reason or holder context; prove no actor was launched.
3. Prove `--status` still creates no log and remains read-only.
4. Run the shell syntax check and `git diff --check`. The complete dispatcher suite is deliberately held for the next validation unit because it could not fit with implementation inside the fixed hop timeout.
5. Commit the implementation, test, and state handoff together with explicit pathspec. Raw harness outputs remain uncommitted evidence.

Stop if the preserved diff is incomplete or over-broad, the focused case fails, durable logging cannot be initialized before acquisition without changing `--status`, or the fix requires another transport or the shared lease contract. Do not launch a live model, rerun case 23, run the complete suite, or increase timeouts.

Completion condition: the preserved fix is proportionate, its focused controller case passes with a durable pre-actor exit-17 record, `--status` remains no-write, syntax and diff checks pass, the bounded files are committed, and the task hands back at `turn: codex`.

## Latest result

Inspected (2026-08-14) — both claims checked against HEAD `5d38c76f`, before any edit:

- Claim (1): HOLDS — searched `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` at HEAD for the acquisition call and the run-evidence block. `[ "$STATUS_MODE" -eq 1 ] || acquire_lock` is line 1288; `mkdir -p "$LOG_DIR"` is line 1425 and `: >"$RUN_LOG"` line 1455. Searched `acquire_lock`'s body for `RUN_LOG`: no match — all four exit-17 paths write to `>&2` only. Acquisition therefore precedes both the requested log directory and the run log, and that ordering does explain why the observed exit 17 produced no file and no directory.
- Claim (2): HOLDS — searched `dispatch.test.sh` at HEAD for `expect_rc 17`: 12 occurrences (lines 447, 465, 473, 617, 662, 728, 784, 891, 908, 1885, 1982, 2186), each asserting exit code and stderr only. Searched the same file for `terminal-record`: no match. Searched for run-log reads: two, lines 1877 and 1970, and both read the *winning* rc=0 dispatcher's log, not a refused run's. No case gives a refused run its own `--log-dir`. No equivalent coverage exists, which is why nothing protected the live run.

Result: the preserved two-file diff is complete and proportionate, and Unit 9r2 finished it. In `dispatch.sh` the run-evidence block moved above `acquire_lock` under an `if [ "$STATUS_MODE" -eq 0 ]` guard, and two small functions were added — `r17()`, which sends each already-formatted refusal line to stderr *and* `RUN_LOG` with the stderr wording unchanged, and `refuse_17()`, which appends one machine-readable `terminal-record` line and exits 17. The existing dual-channel helper `die()` could not be reused: it calls `release_lock`, which a refused run must never do. Every dependency of the moved block (`CHECKOUT` line 506, `DEFAULT_LOG_DIR` line 524, `STATUS_MODE`, `LOG_DIR`, `ALLOW_PATHS`) is set well above the new position. `dispatch.test.sh` gained one case, 12h, which refuses a second real dispatcher against a genuinely held lease and asserts the *file* rather than the message.

Evidence: case 12h extracted with the harness fixtures into `/tmp/case12h-isolated.sh` and run against the fixed dispatcher — **20 PASS, 0 FAIL, exit 0**. The refused run's own `--log-dir` received a run log carrying the human refusal plus `terminal-record outcome=refused code=17 task=record-task resource=task refusal=held holder_program=dispatch holder_pid=54751 holder_task=record-task holder_checkout=/private/var/folders/.../co.nq8ymy actor_launched=no`. No actor launched (empty `.calls`), no hop capture, no `hop=` line, HEAD unmoved. `--status` over the same held lease exits 0, adds no file to an existing log directory and creates no directory that did not exist. The check is falsifiable and was observed failing: the first isolated run resolved `DISPATCH_BIN` to an absent path and returned 14 FAIL / 6 PASS, with every record assertion reporting `<no record>` — the same shape the live case-23 absence had. Saved output: `logs/harness-runs/unit9r2-case12h/isolated-case12h.out`, with the extracted harness beside it (uncommitted raw evidence). `bash -n` clean on both files; `git diff --check` clean.

Held back, per the brief: the complete dispatcher suite is deliberately not run in this unit and belongs to the next validation unit.

Deferral, recorded and not done: `LOCK_KEY` is never assigned anywhere in `dispatch.sh` — searched the whole file at HEAD and in the working tree, and the only occurrences are the explanatory comment and the use itself in `RUN_ID`. Under `set -uo pipefail`, `${LOCK_KEY:0:8}` expands to empty rather than erroring, so `RUN_ID` carries an empty key segment and the comment's claim that the checkout hash separates two same-second runs of one task from different checkouts is not true today; only `$$` separates them. This is pre-existing at HEAD, was moved verbatim by this unit rather than introduced by it, and sits outside this unit's bounded outcome, so it was left alone.

Superseded context, kept because it is still the failing case: Unit 9's live hop refused correctly at exit 17 while the attended carrier held the shared lease, but `logs/harness-runs/case23-live-dispatcher/` was never created — that observed absence is this fix's failing case, and no second red replay was manufactured. Case 23 is not accepted and the same hop must not be rerun. Unit 9r1 timed out at the 900-second guard with no transition or commit, preserving only the two files this unit finished.

## Blocker

None.

## Next action

Codex: assess Unit 9r2 against its completion condition — whether the preserved fix is proportionate as finished, whether the durable pre-actor exit-17 record and the `--status` no-write proof are sufficient, and whether the deliberately held full dispatcher suite plus the recorded `LOCK_KEY` deferral are acceptable to carry into the next validation unit.
