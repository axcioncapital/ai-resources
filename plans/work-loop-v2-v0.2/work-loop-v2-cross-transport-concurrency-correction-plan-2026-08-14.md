# Work Loop v2 cross-transport concurrency — correction plan

**Date:** 2026-08-14  
**Worktree:** `ai-resources-concurrency-fix-2`  
**Branch:** `session/2026-08-14-concurrency-fix-2`  
**Governing proposal:** `plans/work-loop-v2-v0.2/work-loop-v2-cross-transport-concurrency-and-task-aware-worktrees-implementation-proposal-2026-08-13.md`

## Outcome

Correct the safety and plan-compliance defects found in the independent review of Phase 1, prove the corrections with targeted failing-first tests, complete the two live validation cases, and leave the branch ready for one final independent review and merge decision.

This is a repair plan, not a redesign. Keep the shared task-and-checkout lease, the attended carrier, the unattended dispatcher, the ownership helper, and their existing command boundaries.

## Scope

Fix these seven findings:

1. The carrier can treat a failed process-group inspection as proof that the actor stopped and release both leases.
2. The carrier can delete a live but uninspectable legacy lock as though it were stale.
3. A losing dispatcher writes its run log inside the checkout before it owns the lease.
4. Dispatcher `--status` can describe a carrier-held lease as a dispatcher-held lease.
5. The shared lease helper does not safely recover a positively dead, unpinned lease.
6. Exact acceptance coverage is missing for proposal cases 3/4, 12, 16, and 22.
7. Live cases 23 and 24 and the closing record do not yet satisfy the proposal's adoption gate.

Do not implement Phase 2, automatic worktree creation, a scheduler, a registry, a service, a new state store, or a new command surface. Do not fix unrelated pre-existing issues such as the unassigned `LOCK_KEY` unless a correction below makes that unavoidable.

## Safety rules that govern every correction

- **Unknown is held.** A missing, malformed, unreadable, or uninspectable PID never authorizes deletion or lease release.
- **Only positive absence is stale.** Cleanup requires evidence that the recorded holder is not running.
- **Pinned is manual.** A pinned lease is never reaped automatically, even when its recorded launcher PID is gone.
- **No checkout write before admission.** Before both leases are acquired, a transport may write to stderr or the Git common directory, but not the checkout.
- **One vocabulary, accurate holder.** Messages use the lease's recorded `program`; they never infer the holder from the program doing the inspection.
- **A green broad suite cannot replace a missing required case.** Add the exact case and its positive control.

## Implementation sequence

The order below is intentional: freeze each defect first, then change the smallest shared component that can close it.

### 1. Freeze the shared liveness contract

Add failing cases to `logs/scripts/work-loop-lease.test.sh` before changing the helper:

- A live holder refuses and its directory survives.
- An uninspectable holder refuses and its directory survives.
- A missing, empty, malformed, zero, or zero-prefixed PID is `UNKNOWN`, refuses, and survives.
- A positively absent holder is reclaimed and the new run acquires both leases.
- Two contenders attempting to reclaim the same stale lease still produce exactly one winner.
- A pinned lease is never reclaimed automatically.

Keep the existing race, rollback, partial-pin, durable-pin, and read-only-status cases green.

Then update `logs/scripts/work-loop-lease.sh`:

1. Move or reproduce the dispatcher's proven three-state PID probe in the shared helper: `LIVE`, `ABSENT`, `UNKNOWN`, with a reason for the verdict.
2. Use it whenever acquisition finds an existing unpinned task or checkout lease.
3. Return `held` for `LIVE` and `UNKNOWN`; expose the holder metadata and inspection reason to the caller.
4. Reclaim only `ABSENT` leases.
5. Reclaim by atomically renaming the stale directory to a unique tombstone in the same parent, then deleting the tombstone. Never run `rm -rf` directly on the active lease path after deciding it is stale. If the rename loses a race, re-read the current lease and retry admission.
6. Check for `survivors` before PID liveness. Pinned always wins.

Acceptance:

- A live or unknown holder is never deleted.
- A dead unpinned holder does not strand the task permanently.
- Stale recovery does not allow two winners.
- Both transports consume the same verdict; neither reimplements PID classification.

### 2. Correct the carrier's legacy-lock migration check

Add failing cases to `scripts/axcion-harness-v0.2/carry-turn.test.sh` for a legacy lock whose PID is:

- live;
- positively absent;
- uninspectable;
- missing or malformed.

Then change `legacy_lock_check` in `scripts/axcion-harness-v0.2/carry-turn.sh` to use the shared three-state probe:

- `LIVE` → refuse with exit 17 and preserve the lock.
- `UNKNOWN` → refuse with exit 17, print why it could not be inspected, and preserve the lock.
- `ABSENT` → atomically rename and remove only the stale legacy directory, then continue.

The compatibility path remains read-only for live or unknown holders. Do not migrate a legacy holder into a new lease.

Acceptance:

- The changeover window never admits a second writer because inspection failed.
- The stale positive control still proceeds.
- The message states whether the stop was live or unknown and says that nothing was deleted.

### 3. Correct carrier shutdown proof

Add failing cases around `terminate_actor_group` for:

- inspection becoming unavailable during the TERM grace period;
- a group that cannot be inspected after SIGKILL;
- a visible survivor;
- a cleanly emptied group as the positive control.

Then remove both binary interpretations of `kill -0` failure as proof of absence. During the TERM grace period and after SIGKILL:

1. Use a controlled process-group census whose own control proves that inspection ran.
2. Return clean only when the census ran successfully and found the actor group empty.
3. Continue shutdown when members remain.
4. Treat a failed or inconclusive census as unknown.
5. After the final attempt, pin both leases for any survivor or unknown result and record either the survivor PIDs or the inspection failure.

`kill -TERM` and `kill -KILL` are actions, not evidence. Their success or failure alone must never authorize release.

Acceptance:

- A clean group releases both leases.
- A survivor or unknown group pins both leases.
- No `kill -0 ... || return 0` or equivalent two-state shortcut remains in the carrier shutdown path.

### 4. Make early dispatcher refusals durable without touching the checkout

Replace the current pre-lease `RUN_LOG` creation in `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` with two distinct evidence paths:

- **Refusal record:** available before acquisition, always under `$WL_LEASE_ROOT/refusals/` in the Git common directory.
- **Normal run log:** created at the requested `--log-dir` only after both leases are acquired.

Use a collision-resistant refusal filename containing at least timestamp, PID, and task. Do not depend on the currently unassigned `LOCK_KEY`. On exit 17:

- write the human-readable refusal and machine-readable terminal record to the refusal record;
- keep `actor_launched=no` explicit;
- print the refusal-record path to stderr;
- do not create or allowlist the requested in-checkout log directory.

Rewrite dispatcher case 12h so its central assertion is:

> A losing dispatcher leaves the checkout byte-identical and `git status` unchanged, launches no actor, and leaves a durable refusal record under the Git common directory.

Add a positive control showing that a successful admitted run still creates and uses its ordinary requested run log.

Acceptance:

- No code before `acquire_lock` creates, truncates, or allowlists a checkout path.
- A losing dispatcher leaves durable evidence even when `--log-dir` points inside the checkout.
- The active run cannot sweep the losing run's evidence into a commit because that evidence is outside every working tree.
- `--status` remains completely read-only.

### 5. Correct `--status` holder reporting

Add exact proposal case 22 to `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`:

- a real carrier fixture holds the task and checkout leases;
- dispatcher `--status` reports the attended carrier as holder;
- status takes no lease, creates no log, writes nothing, and exits 0.

Add controls for a dispatcher holder, a missing program field, and an unknown program value.

Then update both the checkout-lease line and task-lease `LIVE`/`UNKNOWN` wording to use the lease's recorded program:

- `carry` → `an attended carry`;
- `dispatch` → `a dispatcher`;
- missing → `a Work Loop run (program unrecorded)`;
- anything else → `a Work Loop run (<recorded value>)`.

Use one formatter for acquisition refusals and status output so the vocabularies cannot drift again.

Acceptance:

- Status never calls a carrier a dispatcher.
- Unknown metadata is reported, not guessed.
- Existing pinned, stale, and uninspectable status behavior remains green.

### 6. Complete the controller acceptance matrix

Give the proposal's cases their own named assertions rather than relying on indirect coverage:

- **3:** carrier holds; dispatcher starts in the same checkout and is refused with 17, naming the carrier.
- **4:** dispatcher holds; carrier starts in the same checkout and is refused with 17, naming the dispatcher.
- **12:** different tasks in different worktrees are both admitted; neither sees the other's paths.
- **16:** partial acquisition pins only the lease actually acquired, and dispatcher `--status` reports exactly that state.
- **22:** carrier-held lease is reported by status as attended.

Each case needs a positive control that would fail if the implementation simply refused everything. Preserve the distinction between controller evidence and live actor evidence.

## Verification gates

Run from a clean implementation state. Process-control suites must run outside a sandbox that blocks `ps`, `kill -0`, `pgrep`, or `lsof`; sandbox-induced failures are not product failures, but neither are they acceptable final evidence.

Required commands:

```bash
bash -n logs/scripts/work-loop-lease.sh \
  scripts/axcion-harness-v0.2/carry-turn.sh \
  plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh

bash logs/scripts/work-loop-lease.test.sh
bash logs/scripts/work-loop-owner.test.sh
bash scripts/axcion-harness-v0.2/carry-turn.test.sh
bash plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh
```

All four suites must exit 0. Record the new pass totals; do not preserve obsolete totals for narrative continuity.

Also verify:

- `git diff --check` has no accidental whitespace errors. Markdown hard breaks may remain intentional.
- No Phase 2 or executable-core file changed.
- No runtime record was created inside a checkout before lease acquisition.
- The current worktree remains the only checkout modified by this correction.

## Live validation

### Case 23 — genuine cross-transport contention

Repeat the complete post-fix path; do not assemble it from separate observations:

1. Start a real attended carrier hop and confirm it holds both leases.
2. Start a real dispatcher against the conflicting task or checkout.
3. Confirm the dispatcher exits 17 before actor launch.
4. Confirm its message names the attended carrier.
5. Confirm the durable refusal record exists under the Git common directory and says `actor_launched=no`.
6. Confirm the losing dispatcher wrote nothing into the checkout.
7. Confirm the carrier's leases and work were undisturbed.

### Case 24 — genuine fan-out two

Use two real Work Loop tasks in two linked worktrees:

1. Each task has one authoritative state file and the correct ownership declaration.
2. Both transports are admitted concurrently because task and checkout differ.
3. Each completes at least one later handoff in its bound checkout.
4. Neither candidate commit contains the other task's paths, state, logs, or evidence.
5. Both leases release normally at completion.

If two top-level sessions are required, coordinate them explicitly. Do not simulate this case and do not call it complete from controller evidence.

## Closing record

After all gates pass, update `logs/work-loop/work-loop-v2-cross-transport-concurrency-phase-1.md` once:

- replace stale suite counts and diff statistics with measured values;
- state accurately that both carrier and dispatcher enforcement is exit-code-borne, while interactive same-task enforcement remains instruction-borne;
- record the complete post-fix case 23 evidence;
- record the genuine case 24 evidence;
- remove limitations that are now resolved;
- retain only limitations still true;
- identify any untracked local evidence as non-durable and put the durable conclusion in the closing record itself.

Do not create another report unless a new unresolved defect requires one.

## Stop conditions

Stop and reassess instead of building around the problem if:

- the shared PID probe cannot distinguish positive absence from unknown on the supported host;
- stale recovery cannot avoid deleting an active lease path;
- durable early-refusal evidence cannot be written outside the checkout;
- fixing status requires changing the carrier's attended command boundary;
- any existing suite regresses for a reason unrelated to an intentionally changed assertion;
- either live case shows mixed paths, duplicate actors, or ambiguous ownership;
- the worktree changes unexpectedly while no implementation command is writing it.

## Done definition

The correction is ready for final review only when:

- every targeted regression test was observed red before its fix and is now green;
- all controller cases 1–22 are represented and pass;
- all four full suites exit 0;
- cases 23 and 24 have complete live evidence;
- no high- or medium-severity review finding remains;
- the closing record matches the filesystem and test evidence;
- one final independent Standards and Spec review recommends merge.

Only then merge Phase 1. Phase 2 remains unapproved and out of scope.
