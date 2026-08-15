---
task: cross-transport-concurrency-correction
turn: codex
---

## Objective and scope

Correct the seven reviewed Phase 1 concurrency findings, complete the required controller and live evidence, and leave this branch ready for the final independent review and merge decision described in `plans/work-loop-v2-v0.2/work-loop-v2-cross-transport-concurrency-correction-plan-2026-08-14.md`.

Scope is exactly that correction plan as committed at `f2b19b5d80a061111c39cc7444f90f6374f19d38`. Excluded: Phase 2, automatic worktree creation, a scheduler, registry, service, new state store, new command surface, unrelated `LOCK_KEY` work, unrelated cleanup, merge, and push.

## Lane and unit

Standard. Implementation mode. Unit 4 — make an early dispatcher refusal durable without writing to the checkout before admission.

Named reason for the loop: the correction spans several independently assessable units and must survive session boundaries; the result also needs assessment by someone other than its implementer before it can progress. The operator explicitly chose Work Loop v2 for this task on 2026-08-15.

## Brief

Units 1–3 are accepted. This unit closes correction-plan step 4: a dispatcher that loses admission must leave durable refusal evidence, but must leave the requested checkout byte-identical because it does not yet own either lease.

Required outcome: separate pre-admission refusal evidence from the normal run log. Before both leases are acquired, the dispatcher may write its refusal record only under the shared lease root in the Git common directory. The requested normal run log may be created only after both leases are held.

Governing sources:

- The operator-approved correction plan at `f2b19b5d80a061111c39cc7444f90f6374f19d38`, especially implementation sequence step 4 and its acceptance conditions, governs this unit.
- The governing Phase 1 proposal named by that plan governs cross-transport admission and the requirement that the losing transport launch no actor.
- Existing shared lease-root resolution and dispatcher terminal-record vocabulary govern unless the plan explicitly changes them; do not add a new state store or command surface.

Check these claims against the live repository before changing anything:

1. Inspect `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` from argument parsing through both lease acquisitions. Identify every point that creates, truncates, allowlists, or writes `RUN_LOG` or its parent before both leases are owned.
2. Inspect dispatcher case `12h` and adjacent controls in `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`. Report whether the current losing-dispatcher case proves checkout bytes and `git status` are unchanged, no actor launched, and durable evidence exists outside every worktree; identify the positive admitted-run control.
3. Verify how `WL_LEASE_ROOT` resolves to the Git common directory and whether a `refusals/` child can be written before acquisition without touching the checkout. Verify that the proposed refusal filename can include timestamp, PID, and task without depending on the unassigned `LOCK_KEY`.
4. Report branch, checkout, Git status, and pre-existing operator-owned changes before editing. Do not stage or commit `logs/friction-log.md` or `logs/harness-runs/`.

Authorized changes:

- `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`
- `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`
- this state file
- `logs/friction-log.md` only if an existing hook updates it; never stage or commit it

Codex framing decision: dispatcher status wording, the remaining controller matrix, live cases 23/24, and the closing record remain outside this unit. Unit 4 changes only where and when refusal/run evidence is written; it does not change admission policy.

Required evidence:

- Rewrite or sharpen case `12h` so a losing dispatcher is proven to leave checkout bytes and `git status` unchanged, launch no actor, exit 17, print the refusal-record path, and leave a durable refusal record under `$WL_LEASE_ROOT/refusals/` containing the human-readable refusal and a machine-readable terminal record with `actor_launched=no`.
- Add or identify a positive admitted-run control proving the normal requested run log is still created and used after both leases are acquired.
- Before the production fix, run the targeted new assertions and record output showing the losing dispatcher currently writes inside the checkout or otherwise fails the exact case for the intended reason.
- After the fix, run `bash -n plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` and the full `bash plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`; report commands, exit codes, and current totals.
- Show from the implemented control flow that no code before both lease acquisitions creates, truncates, writes, or allowlists a requested checkout log path, and that `--status` remains read-only.
- Report changed files, implementation commit, deviations, remaining limitations, and rollback instructions.

Completion condition: correction-plan step 4 is satisfied; the exact losing and admitted controls and full dispatcher suite pass; a pre-admission refusal writes only under the Git common directory; only authorized files are committed; and Claude updates this file, sets `turn: codex`, commits, and stops.

Stop and hand back without improvising if durable refusal evidence cannot be written outside the checkout, the exact no-write proof requires files outside the authorized boundary, or a premise is false.

## Latest result

Inspected (2026-08-15):

- Claim (1): HOLDS — read `dispatch.sh` from argument parsing to `acquire_lock`. Four points wrote the requested checkout log path before either lease was owned, all inside one block guarded by `STATUS_MODE -eq 0` and placed immediately above the `acquire_lock` call: `LOG_DIR="$DEFAULT_LOG_DIR"` default, `mkdir -p "$LOG_DIR"`, `ALLOW_PATHS+=` of the log dir when it is inside the checkout, and `RUN_ID`/`RUN_LOG="$LOG_DIR/$RUN_ID.log"` followed by `: >"$RUN_LOG"`. Nothing else touched that path pre-admission: every other `>>"$RUN_LOG"` sits in `die`/`say`/`pin_lock`/`on_signal` bodies guarded by `[ -n "${RUN_LOG:-}" ]`, and the other two `ALLOW_PATHS+=` are the `--allow-path` argument and a fixed default.
- Claim (2): HOLDS as stated — the pre-existing case `12h` proved the opposite of what Unit 4 requires. It passed `--log-dir "$d/refused-runs"` (inside the checkout) and asserted that directory **received** a run log. It proved no actor launched (three handles), no hop capture, no commit, and `--status` read-only; it did **not** prove checkout bytes or `git status` unchanged, and it asserted no evidence outside the worktree. Positive admitted-run control: none existed for this property — the nearest were case 14 (`runs/*.hop1.claude.out`) and cases 27k/27-norecord, which read an admitted run's log for pin reporting, not for the create-and-use claim. One was added (`12h-ok`).
- Claim (3): HOLDS — `wl_lease_init` (`logs/scripts/work-loop-lease.sh:157-169`) sets `WL_LEASE_ROOT="<git-common-dir>/work-loop-dispatch-locks"`, and `dispatch.sh` calls it well above `acquire_lock`, so the root path is known pre-acquisition. A `refusals/` child is safe: searched `logs/scripts/`, `plans/work-loop-v2-v0.2/handoff-automation-spike/` and `scripts/` for `WL_LEASE_ROOT`/`work-loop-dispatch-locks`; every reader addresses the two lease directories by exact path and nothing globs the root. `LOCK_KEY` is **never assigned** in `dispatch.sh` — searched the whole file, two references only (a comment and `${LOCK_KEY:0:8}`), no assignment anywhere — so the refusal name uses `date`, `$$` and `$TASK`, all available at that point.
- Claim (4): HOLDS — branch `session/2026-08-14-concurrency-fix-2`, checkout `ai-resources-concurrency-fix-2`, ownership `PROCEED` (this checkout already declares the task). Pre-existing operator-owned changes before editing: ` M logs/friction-log.md` and `?? logs/harness-runs/`, plus the ` M` state file carrying this brief. Neither was staged nor committed.

Result: Unit 4 is implemented. A dispatcher that loses admission now writes nothing at all into the requested checkout — the run-evidence block moved from above `acquire_lock` (dispatch.sh:1409) to below the read-only `--status` branch (dispatch.sh:1543-1590), so `--status` read-only is now a property of the control flow rather than of a `STATUS_MODE` flag. Pre-admission refusal evidence moved to `$WL_LEASE_ROOT/refusals/<timestamp>-<pid>-<task>.refusal`, opened lazily on the first `r17` line, carrying the unchanged human `STOP [17]` wording plus the `terminal-record … actor_launched=no` line, with the record's path printed on stderr. An unwritable refusal store warns on the terminal instead of failing silently.

Evidence:

- Failing-first, targeted `12h`/`12h-ok` against the unmodified dispatcher: `pass=12 fail=18`. The failures were the intended ones — `refused-runs/` was created inside the checkout (`20260815T125609--574-record-task.log`), the working-tree manifest gained that file, `git status` moved from `` to `?? refused-runs/`, and no record existed under the lease root. The admitted control also failed pre-fix, and for a consequence of the same defect: the litter left by the refusal was an out-of-allowlist change, so the next admitted dispatcher stopped at `STOP [18]` instead of launching.
- Post-fix, same targeted cases: `pass=30 fail=0`.
- `bash -n plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` → rc 0.
- `bash plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` → rc 0, `pass=547 fail=0` (was 517 before the two cases were rewritten and added).
- `bash logs/scripts/work-loop-lease.test.sh` → rc 0, `pass=127 fail=0` (unchanged; the library was not touched).
- Control-flow proof, by line number in the implemented file: `acquire_lock` is called at 1409; every create/truncate/write/allowlist of the requested log path is at 1559 (`LOG_DIR` default), 1560 (`mkdir -p`), 1565 (`LOG_DIR_ABS`), 1570 (`ALLOW_PATHS+=`), 1589-1590 (`RUN_LOG=`, `: >`) — all below it. The `--status` branch runs 1419-1541 and ends in `exit 0`, so 1543-1590 is unreachable in status mode, and 1409 never calls `acquire_lock` in status mode. The eight other `>>"$RUN_LOG"` sites are function bodies guarded by `[ -n "${RUN_LOG:-}" ]`, and `RUN_LOG` is assigned only at 1589.

Changed files: `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, this state file. Nothing else was staged; `logs/friction-log.md` and `logs/harness-runs/` were left untouched and uncommitted.

Deviations: none from the brief. Case `12h` was rewritten rather than sharpened, because its central assertion had to be inverted; the new positive control is a separate case `12h-ok` so the negative and positive halves fail with distinguishable labels.

Candidate deferral noticed mid-unit, not implemented: `LOCK_KEY` is unassigned since the lease moved into the shared library, so `RUN_ID` carries an empty discriminator (`20260815T125609--574-record-task.log`). The run id's defence against two same-task runs from different checkouts colliding in the same second is therefore inert — only the pid separates them now. Left alone because the brief excludes unrelated `LOCK_KEY` work.

Remaining limitations: a Git common directory that cannot be written leaves the refusal record unwritten — the run warns on the terminal and still refuses correctly, so the evidence gap is announced rather than silent. Refusal records accumulate under `refusals/` with no pruning.

Rollback: `git revert` the implementation commit, or `git checkout <parent> -- plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`. No state store, command surface or file layout changed, so nothing outside those two files has to be undone.

Units 1–3 accepted: Unit 1 (`fee4fe49`, `ca35371c`, `57f3b25b`), Unit 2 (`2d58991d`, record update `bc979e8d`), Unit 3 (`cda44c50`).

Held for closure from Unit 1: mutually uninspectable live reclaimers both fail closed; `wl_lease_status` describes a provably dead holder as `HELD`; the old-marker transition block can be removed only after no checkout can carry that format. Held from Unit 3: a host unable to execute `ps -g` pins interrupted or timed-out runs rather than releasing leases, because shutdown cannot be proved.

## Blocker

None.

## Next action

Codex: assess Unit 4 against correction-plan step 4 — the losing-dispatcher and admitted-run controls, the control-flow proof that nothing pre-admission touches the requested checkout log path, and whether the `LOCK_KEY` finding should be recorded as a deferral or opened as its own unit.
