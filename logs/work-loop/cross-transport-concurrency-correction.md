---
task: cross-transport-concurrency-correction
turn: codex
---

## Objective and scope

Correct the seven reviewed Phase 1 concurrency findings, complete the required controller and live evidence, and leave this branch ready for the final independent review and merge decision described in `plans/work-loop-v2-v0.2/work-loop-v2-cross-transport-concurrency-correction-plan-2026-08-14.md`.

Scope is exactly that correction plan as committed at `f2b19b5d80a061111c39cc7444f90f6374f19d38`. Excluded: Phase 2, automatic worktree creation, a scheduler, registry, service, new state store, new command surface, unrelated `LOCK_KEY` work, unrelated cleanup, merge, and push.

## Lane and unit

Standard. Implementation mode. Unit 5 — make dispatcher status and acquisition messages name the lease's recorded holder accurately.

Named reason for the loop: the correction spans several independently assessable units and must survive session boundaries; the result also needs assessment by someone other than its implementer before it can progress. The operator explicitly chose Work Loop v2 for this task on 2026-08-15.

## Brief

Units 1–4 are accepted. This unit closes correction-plan step 5: dispatcher `--status` and acquisition refusals must describe who actually holds a lease from its recorded `program`, never infer the holder from the dispatcher doing the inspection.

Required outcome: both checkout-lease and task-lease `LIVE`/`UNKNOWN` messages use one holder formatter with the exact plan vocabulary: `carry` → `an attended carry`; `dispatch` → `a dispatcher`; missing → `a Work Loop run (program unrecorded)`; any other value → `a Work Loop run (<recorded value>)`.

Governing sources:

- The operator-approved correction plan at `f2b19b5d80a061111c39cc7444f90f6374f19d38`, especially implementation sequence step 5 and its acceptance conditions, governs this unit.
- The governing Phase 1 proposal named by that plan governs exact controller case 22 and read-only status behavior.
- The accepted shared lease metadata is authoritative for `program`; unknown metadata must be reported rather than guessed.

Check these claims against the live repository before changing anything:

1. Inspect every checkout-lease and task-lease `LIVE`/`UNKNOWN` message in dispatcher acquisition and `--status`. Identify where wording currently assumes `dispatcher` rather than reading the recorded `program`.
2. Inspect the current holder formatter and all its call sites. Report whether acquisition refusals and status already share one formatter, and which paths or metadata cases bypass it.
3. Inspect `dispatch.test.sh` for exact proposal case 22: a real attended carrier holds both leases while dispatcher `--status` reports the attended holder and remains read-only. Report current coverage for a dispatcher holder, missing `program`, and an unknown `program` value.
4. Report branch, checkout, Git status, and pre-existing operator-owned changes before editing. Do not stage or commit `logs/friction-log.md` or `logs/harness-runs/`.

Authorized changes:

- `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`
- `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`
- this state file
- `logs/friction-log.md` only if an existing hook updates it; never stage or commit it

Codex framing decision: the remaining controller matrix, live cases 23/24, and the closing record remain outside this unit. Do not reopen the held `wl_lease_status` dead-holder state-label deferral; Unit 5 corrects recorded-program attribution only.

Required evidence:

- Add exact case 22 using a real attended carrier fixture holding both task and checkout leases. Assert that dispatcher `--status` names `an attended carry`, takes no lease, creates no run or refusal log, changes no checkout bytes or status, and exits 0.
- Add or sharpen controls for a dispatcher holder, missing `program`, and an unknown `program` value across the relevant checkout/task and `LIVE`/`UNKNOWN` paths. Preserve pinned, stale, and uninspectable status behavior.
- Before the production fix, run the targeted new assertions and record output showing status misidentifies the carrier for the intended reason; include a positive control that prevents hard-coding `attended carry`.
- After the fix, run `bash -n plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` and the full `bash plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`; report commands, exit codes, and current totals.
- Show that acquisition refusals and status use the same formatter and exact vocabulary for all four recorded-program classes, while `--status` remains completely read-only.
- Report changed files, implementation commit, deviations, remaining limitations, and rollback instructions.

Completion condition: correction-plan step 5 is satisfied; exact case 22 and its controls pass; all relevant status/refusal messages use the recorded holder through one formatter; the full dispatcher suite passes; only authorized files are committed; and Claude updates this file, sets `turn: codex`, commits, and stops.

Stop and hand back without improvising if a real carrier fixture cannot hold both shared leases on the supported host, the exact proof needs files outside the authorized boundary, or a premise is false.

## Latest result

Inspected (2026-08-15):

- Claim (1): HOLDS — read every `LIVE`/`UNKNOWN` holder message in `dispatch.sh`. The task-lease `LIVE` line (`run: IN FLIGHT — dispatcher pid %s holds %s`) and the `UNKNOWN` line (`THIS LOCK MAY BELONG TO A LIVE DISPATCHER`) both asserted `dispatcher` unconditionally. The checkout-lease line (`checkout-lock: HELD by task %s`) named no holder at all, so the holder was left to be assumed from the program printing the report. Acquisition already read the recorded program.
- Claim (2): HOLDS — `holder_label()` existed at `dispatch.sh:733` with exactly one call site, `acquire_lock` (line 861). `--status` bypassed it completely: it called neither `holder_label` nor `wl_lease__read_holder`, so all three status surfaces above bypassed the formatter. Refusals and status did **not** share one formatter before this unit.
- Claim (3): HOLDS — searched `dispatch.test.sh` for status-side holder coverage; there was none. Case 12 (dispatcher holder) and case 12g (missing program, unknown program) cover acquisition refusals only, and no status case asserted a holder at all. Exact proposal case 22 was absent. Note the collision found by inspection: `dispatch.test.sh` already uses "Case 22" for the malformed-close case, so the plan's "proposal case 22" needed a non-colliding local number.
- Claim (4): HOLDS — branch `session/2026-08-14-concurrency-fix-2`, checkout `ai-resources-concurrency-fix-2`, `HEAD` at `552fe9dc`. Pre-existing operator-owned changes: ` M logs/friction-log.md` and `?? logs/harness-runs/`; neither was staged or committed. The state file's own uncommitted change was Codex's Unit 5 brief, which is expected — Codex writes, Claude commits.

Vocabulary check, because the brief and the live code disagreed: `git blame` puts `holder_label()`'s `another …` wording at `ee3a9419` (Phase 1, 19:30), which `git merge-base --is-ancestor` confirms predates the correction plan at `f2b19b5d` (22:50). The plan's step 5 therefore prescribes the change rather than restating the code, so the wording moved to the plan's four renderings and the assertions that pinned the old wording moved with it.

Result: Unit 5 is implemented. One formatter — `holder_label()` — now renders every holder phrase, with three call sites: `acquire_lock` and both `--status` surfaces. Its four renderings are the plan's verbatim (`an attended carry` / `a dispatcher` / `a Work Loop run (program unrecorded)` / `a Work Loop run (<recorded value>)`). `--status` reads each lease's own metadata through the read-only `wl_lease__read_holder` before rendering: the checkout-lease line became `checkout-lock: HELD by <holder> running task <task>`, the task-lease `LIVE` line became `run: IN FLIGHT — <holder> at pid N holds <dir>`, and the `UNKNOWN` branch now states `the lease records its holder as <holder>` and cautions `THE HOLDER MAY STILL BE LIVE` instead of asserting a live dispatcher. The `exits 28` clause on the stop instruction is now printed only when the recorded holder is `dispatch`, because that exit code is this program's contract and not a carrier's.

Evidence: `bash dispatch.test.sh`, pre-fix, `pass=562 fail=14` — all 14 failing for the intended reason. Case 30g reported `checkout-lock: HELD by task st-carried` and `run: IN FLIGHT — dispatcher pid 64972` while a **real** carrier held both leases; case 30h's dispatcher-held positive control and the four acquisition assertions failed against the old vocabulary. Post-fix, same command, `pass=578 fail=0` (rc 0). Shared lease suite `bash logs/scripts/work-loop-lease.test.sh` → `pass=127 fail=0` (rc 0). `bash -n` on both dispatcher files → rc 0.

Case 30g is proposal case 22 with a live carrier holding both leases: it asserts `--status` names `an attended carry` on both lines, takes neither lease (both `program` files still read `carry` afterwards), creates no run log and no refusal record, leaves the working-tree manifest and `git status` byte-identical, exits 0, and leaves the carrier alive — with a control requiring the carrier to have launched its actor. Case 30h adds the three recorded-program classes plus the uninspectable-pid path. Two negatives are load-bearing rather than decorative: `out_lacks 'dispatcher pid'` fails against the old wording (a bare `a dispatcher` would not have), and 30h(1) is the positive control that fails any fix hard-coding `an attended carry`.

Changed files: `dispatch.sh`, `dispatch.test.sh`, this state file. Implementation commit named in the next record update.

Deviations: the plan's "add exact proposal case 22" is implemented as **Case 30g**, because `dispatch.test.sh` already uses `Case 22` for an unrelated malformed-close case and renumbering it would break every reference to it; the header names the proposal's number. Case 30d's caution assertion moved from `MAY BELONG TO A LIVE DISPATCHER` to `THE HOLDER MAY STILL BE LIVE` plus a new negative, because its planted lease records no program and naming a dispatcher there is the guess step 5 removes.

Deferrals noticed in this unit, recorded and **not** implemented — all three fall outside the authorized file set:

1. `plans/work-loop-v2-v0.2/handoff-automation-spike/README.md` line 104 still documents the status table row as `IN FLIGHT — dispatcher pid N`, which is now stale. Not an authorized file for this unit.
2. `scripts/axcion-harness-v0.2/carry-turn.sh` (line ~832) still renders its two fallback classes as `another Work Loop run (…)`, so the deliberately shared vocabulary now differs from the dispatcher's by the leading article. The two recognised classes still agree. Not an authorized file.
3. The `STALE LOCK` branch still reads `a dispatcher died without releasing it`. The plan scopes step 5 to the checkout line and `LIVE`/`UNKNOWN`, so it was left alone rather than widened.

Rollback: `git revert` the implementation commit, or restore both dispatcher files from `552fe9dc`. No migration and no state to unwind — the change is message wording plus test coverage.

Units 1–4 accepted: Unit 1 (`fee4fe49`, `ca35371c`, `57f3b25b`), Unit 2 (`2d58991d`, record update `bc979e8d`), Unit 3 (`cda44c50`), Unit 4 (`8e4261f0`).

Accepted limitations held for closure. From Unit 1: mutually uninspectable live reclaimers both fail closed; `wl_lease_status` describes a provably dead holder as `HELD`; the old-marker transition block can be removed only after no checkout can carry that format. From Unit 3: a host unable to execute `ps -g` pins interrupted or timed-out runs rather than releasing leases, because shutdown cannot be proved. From Unit 4: an unwritable shared lease root leaves the refusal terminal-only with an explicit warning, and refusal records have no pruning policy because the plan authorizes no cleanup service or machinery; the unassigned `LOCK_KEY` remains excluded unrelated work.

## Blocker

None.

## Next action

Codex: assess Unit 5 against correction-plan step 5 — one formatter across refusals and status, the plan's exact vocabulary for all four recorded-program classes, exact proposal case 22 (as Case 30g) with its controls, `--status` still completely read-only, and the dispatcher suite at `578/0`. Then decide close, continue to correction-plan step 6, correct once, or stop, and rule on the three recorded deferrals.
