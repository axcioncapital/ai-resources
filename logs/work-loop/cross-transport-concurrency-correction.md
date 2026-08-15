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

The one bounded correction is done. Frozen finding 1 was the only finding, and it is resolved in full.

Reproduced first, by inspection (2026-08-15): both halves named in the finding were present in `README.md`. The mode description read `Returns 0 even while another dispatcher holds the lock.`, and the three-lock-states table's first row read `| IN FLIGHT — dispatcher pid N |`. A third passage in the same status documentation had the same defect and was corrected with them: the paragraph introducing `--status`'s checkout reporting said only *whether* the checkout lock is held, naming no holder at all.

Result: the status documentation now matches the implemented output. The three changed passages are:

1. The `--status` checkout-reporting paragraph now reads that it reports the checkout's declaration and whether the checkout lock is held — *"and, when it is held, which program holds it and the task it is running"* — alongside the three-valued task-lock verdict, still taking no lock and writing nothing.
2. The `--status` mode bullet now reads `Returns 0 even while another Work Loop run holds the lock — and that holder is not necessarily a dispatcher, because the lease is shared with the attended carrier.`
3. The table row is now `| IN FLIGHT — <holder> at pid N |`, followed by a new block, **`<holder>` is read from the lease, never assumed**, which states that both the `run:` line and the `checkout-lock:` line render through the same formatter the exit-`17` refusals use, gives the four recorded-program classes as their own table (`carry` → `an attended carry`; `dispatch` → `a dispatcher`; missing → `a Work Loop run (program unrecorded)`; anything else → `a Work Loop run (<recorded value>)`), says why the old unconditional `dispatcher pid N` misdirected an operator against a carrier-held lease, records that `UNKNOWN — CANNOT INSPECT` names the recorded holder rather than asserting a live dispatcher, and points at cases `30g`/`30h`.

Evidence: `git diff --check` → rc 0, no output. A re-grep of `README.md` for `dispatcher pid`, `another dispatcher` and `LIVE DISPATCHER` returns two hits, both correct: one is the new sentence describing the corrected behaviour in the past tense, the other is the 2026-08-07 pid-`0` incident record, which states what the tool printed *then* and would become false if rewritten. `git status --porcelain` shows only `README.md` and this state file changed by the correction; `dispatch.sh` and `dispatch.test.sh` are untouched by it, as the finding required. The read-only guidance and the three-state guidance were added to, never removed — the three-state table and its `Only the first two are conclusions` paragraph are unchanged.

This correction is documentation-only, so it carries **no test**. The finding said not to invent a ceremonial one, and there is none available that could fail: a grep for wording the correction itself supplies would pass on any text containing the phrase, which is the failure mode core § 6 rule 5 names. The falsifiable check that this documentation is true is the suite that pins the behaviour it describes — cases `30g`/`30h`, already green.

Carried forward from Unit 5 (implementation commit `81644987`): one formatter, `holder_label()`, renders every holder phrase across three call sites — `acquire_lock` and both `--status` surfaces — in the plan's exact four renderings. `--status` reads each lease's own metadata through the read-only `wl_lease__read_holder`. Dispatcher suite pre-fix `pass=562 fail=14`, all failing for the intended reason; post-fix `pass=578 fail=0`. Shared lease suite `127/0`. `bash -n` rc 0. Deviation: proposal case 22 landed as **Case 30g**, because `Case 22` was already taken locally by the malformed-close case.

Rollback: `git revert` the correction commit for the documentation alone, or `81644987` as well to remove the implementation. No migration and no state to unwind.

Units 1–4 accepted: Unit 1 (`fee4fe49`, `ca35371c`, `57f3b25b`), Unit 2 (`2d58991d`, record update `bc979e8d`), Unit 3 (`cda44c50`), Unit 4 (`8e4261f0`).

Deferrals still open, recorded and **not** implemented — both were outside Unit 5's authorized files and outside this frozen correction:

1. `scripts/axcion-harness-v0.2/carry-turn.sh` (line ~832) still renders its two fallback classes as `another Work Loop run (…)`, so the deliberately shared vocabulary now differs from the dispatcher's by the leading article. The two recognised classes still agree.
2. The dispatcher's `STALE LOCK` branch still reads `a dispatcher died without releasing it`. Correction-plan step 5 scopes to the checkout line and `LIVE`/`UNKNOWN`, so it was left alone rather than widened.

Accepted limitations held for closure. From Unit 1: mutually uninspectable live reclaimers both fail closed; `wl_lease_status` describes a provably dead holder as `HELD`; the old-marker transition block can be removed only after no checkout can carry that format. From Unit 3: a host unable to execute `ps -g` pins interrupted or timed-out runs rather than releasing leases, because shutdown cannot be proved. From Unit 4: an unwritable shared lease root leaves the refusal terminal-only with an explicit warning, and refusal records have no pruning policy because the plan authorizes no cleanup service or machinery; the unassigned `LOCK_KEY` remains excluded unrelated work.

## Blocker

None.

## Next action

Codex: run the closure check on the frozen finding only — is finding 1 resolved, and did the correction break anything? Nothing else re-opens Unit 5. Then close, or use the § 3 menu. Two deferrals above await a ruling at closure.
