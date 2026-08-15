---
task: cross-transport-concurrency-correction
turn: codex
---

## Objective and scope

Correct the seven reviewed Phase 1 concurrency findings, complete the required controller and live evidence, and leave this branch ready for the final independent review and merge decision described in `plans/work-loop-v2-v0.2/work-loop-v2-cross-transport-concurrency-correction-plan-2026-08-14.md`.

Scope is exactly that correction plan as committed at `f2b19b5d80a061111c39cc7444f90f6374f19d38`. Excluded: Phase 2, automatic worktree creation, a scheduler, registry, service, new state store, new command surface, unrelated `LOCK_KEY` work, unrelated cleanup, merge, and push.

## Lane and unit

Standard. Implementation mode. Unit 2 — make the attended carrier's legacy-lock migration check distinguish live, absent, and unknown holders and remove only positively absent legacy locks.

Named reason for the loop: the correction spans several independently assessable units and must survive session boundaries; the result also needs assessment by someone other than its implementer before it can progress. The operator explicitly chose Work Loop v2 for this task on 2026-08-15, overriding the normal specialist route to Matt `implement`.

## Brief

Unit 1 established the shared three-state PID verdict and is accepted. This unit applies that verdict to the carrier's one-release legacy-lock compatibility path, closing correction-plan step 2 without touching carrier shutdown, dispatcher behavior, or the later acceptance matrix.

Required outcome: a live legacy-lock holder refuses admission and survives; an uninspectable, missing, or malformed holder is `UNKNOWN`, refuses admission with an explanation, and survives; a positively absent holder is the only state that permits atomic stale-lock cleanup and continued admission.

Governing sources:

- The operator-approved correction plan at `f2b19b5d80a061111c39cc7444f90f6374f19d38`, especially implementation sequence step 2 and the safety rules `Unknown is held` and `Only positive absence is stale`, governs this unit.
- The governing Phase 1 proposal named by that plan governs the changeover requirement: a live old lock must remain visible to the new lease path, and an old holder is never migrated into a new lease.
- Unit 1's accepted shared liveness implementation is commits `fee4fe49`, `ca35371c`, and `57f3b25b`. Consume its three-state verdict; do not add a second PID classifier.

Check these claims against the live repository before changing anything:

1. In `scripts/axcion-harness-v0.2/carry-turn.sh`, inspect `legacy_lock_check` and verify whether a nonempty PID for which `kill -0` fails is currently treated as stale without distinguishing positive absence from inspection failure.
2. In `scripts/axcion-harness-v0.2/carry-turn.test.sh`, inspect the executed legacy-lock cases and report the exact existing coverage for live, positively absent, uninspectable, missing, and malformed PIDs, including whether each asserts admission/refusal, actor launch, message, and lock preservation/removal.
3. Verify how `carry-turn.sh` sources `logs/scripts/work-loop-lease.sh` and whether the accepted shared three-state probe is available to the compatibility path without changing the helper's public contract.
4. Report the current branch, checkout, Git status, and pre-existing operator-owned changes before editing. Do not stage or commit `logs/friction-log.md` or `logs/harness-runs/`.

Authorized changes:

- `scripts/axcion-harness-v0.2/carry-turn.sh`
- `scripts/axcion-harness-v0.2/carry-turn.test.sh`
- this state file
- `logs/friction-log.md` only if an existing hook updates it; never stage or commit it

Codex framing decision: carrier process-group shutdown, dispatcher refusal logging, dispatcher status wording, the full controller matrix, live cases 23/24, and the closing record remain outside this unit because each has a separate dominant behavior and evidence set.

Required evidence:

- Add exact cases for live, positively absent, uninspectable, missing, and malformed legacy-lock PIDs. Include the stale positive control so blanket refusal cannot pass.
- Before the production fix, run the new targeted assertions against the pre-fix carrier and record output showing the unsafe cases fail for the intended reason.
- After the fix, run `bash -n scripts/axcion-harness-v0.2/carry-turn.sh scripts/axcion-harness-v0.2/carry-turn.test.sh` and the full `bash scripts/axcion-harness-v0.2/carry-turn.test.sh`; report commands, exit codes, and current totals.
- Prove from both output and filesystem state that `LIVE` and `UNKNOWN` exit 17 before actor launch, state why inspection did not justify deletion, and preserve the legacy directory; prove `ABSENT` atomically renames and removes only the stale directory, then admits the carrier.
- Report changed files, implementation commit, deviations, remaining limitations, and rollback instructions.

Completion condition: correction-plan step 2 is satisfied; the exact new cases and full carrier suite pass; the compatibility path consumes the shared three-state verdict rather than duplicating it; only authorized files are committed; and Claude updates this file, sets `turn: codex`, commits, and stops.

Stop and hand back without improvising if the shared verdict is unavailable at the compatibility path, safe stale cleanup needs a new command surface or files outside the authorized boundary, or any premise is false. Challenge a false premise explicitly rather than building around it.

## Latest result

Inspected (2026-08-15):

- Claim (1): HOLDS — read `legacy_lock_check` at `scripts/axcion-harness-v0.2/carry-turn.sh:738-755` (pre-fix). It branched on `[ -n "$holder" ] && kill -0 "$holder" 2>/dev/null` only. A nonempty PID whose `kill -0` failed fell straight through to `say "note: removing a stale lock..."` and `rm -rf "$lock_path"`, with no test of *why* it failed. `ESRCH` and `EPERM` were the same branch, so an uninspectable holder was deleted and the carry admitted.
- Claim (2): HOLDS — read the executed legacy-lock cases in `scripts/axcion-harness-v0.2/carry-turn.test.sh`, section 12 (`grep -n 'plant_lock\|lock_path_for'` returned uses at lines 860-869, 906-907, 924, 1686-1687 only). Exact pre-existing coverage: **live** (pid `$$`) asserts rc 17, no launch, lock survives, names the holding task; **positively absent** (reaped subshell pid) asserts rc 0 and the message `removing a stale lock`, but asserts *nothing* about the directory actually being gone and nothing about the actor launching; **empty pid file** asserts rc 17, `NOT deleted`, message `Nothing was deleted`, no further launch. **Uninspectable (EPERM) had no case at all. Malformed (`0`, `007`, non-numeric) had no case at all. A wholly missing pid file had no case at all** — only the present-but-empty file was covered. Section 12b and case M6 plant locks but assert checkout-wide keying, not the pid verdict.
- Claim (3): HOLDS — `carry-turn.sh:704` sources `$CHECKOUT/logs/scripts/work-loop-lease.sh` at top level and `:710` runs `wl_lease_init`, both before `acquire_lock` is called at `:1456`, which is what calls `legacy_lock_check`. The shared three-state probe is `wl_lease__pid_state` (`logs/scripts/work-loop-lease.sh:218`), returning `LIVE|reason` / `ABSENT|reason` / `UNKNOWN|reason` on stdout. It is therefore in scope at the compatibility path and callable read-only with no change to the library. One qualification: `grep -n "wl_lease__" carry-turn.sh dispatch.sh` returned no matches, so no transport consumed a library-internal name before this unit — consuming it adds no public-contract change but is new coupling to a private name (recorded as a limitation below).
- Claim (4): HOLDS — checkout `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-concurrency-fix-2`, branch `session/2026-08-14-concurrency-fix-2`. Pre-existing operator-owned changes before editing: ` M logs/friction-log.md` and `?? logs/harness-runs/`. Neither was staged or committed. Ownership check ran first and returned `PROCEED` (this checkout already declares this task).

Result: correction-plan step 2 is satisfied. `legacy_lock_check` now delegates classification to the shared `wl_lease__pid_state` rather than reading `kill -0` itself, and acts on three states: `LIVE` refuses (17) with the in-flight wording; anything that is **not positively absent** refuses (17) carrying the probe's own reason, deleting nothing; only `ABSENT` writes, and that write is now an atomic sibling rename (`$lock_path.stale.$$`) followed by removal of the renamed name, so two runs that both probe `ABSENT` cannot both delete. A rename that fails re-tests the directory: gone means another run cleared it and this run proceeds to the new leases; still present means this run refuses (17) rather than guessing. No second PID classifier was added.

Evidence:

- **Failing-first, against the pre-fix launcher.** Added 34 assertions as section `12a. The legacy lock has THREE states, and only one of them is stale` — uninspectable (pid 1, EPERM), zero-prefixed (`007`), `0`, non-numeric (`not-a-pid`), missing pid file, live, and the positively-absent **positive control**. Run against the unmodified `carry-turn.sh`: `passed: 388  failed: 17`, exit 1, every one of the 17 inside 12a. They failed for the intended reason, not a wording mismatch — the uninspectable holder produced `note: removing a stale lock — pid 1 (task 'task-lg-live') is not running.`, `rc=22` instead of 17, `and the lock survives  expected '1', got '0'`, and `and launched nothing  expected '0', got '1'`. Same shape for `007` and `not-a-pid`. Pid `0` failed differently and as predicted: pre-fix `kill -0 0` *succeeds* (own process group), so a corrupt lock was reported as `another carry is in flight for this CHECKOUT (pid 0, ...)`.
- **Blanket refusal cannot pass.** The `ABSENT` positive control asserts rc 0, the `removing a stale lock` line, the directory GONE by filesystem test, no `.stale.*` rename target left behind (`find` count 0), and the actor actually launched (invocation count increased). A launcher that simply refused everything fails four of those.
- **Filesystem state, not just output.** Every `LIVE`/`UNKNOWN` case asserts exit 17, `[ -d "$lock_path" ]` still true, and an unchanged invocation count — so the refusal happens before actor launch and the directory survives. The `UNKNOWN` cases additionally assert the message carries `Nothing was deleted` and the probe's reason (`WITHOUT proving absence` for EPERM; `not a usable process id` for `007`), which is the launcher stating why inspection did not justify deletion. The pid-`0` case asserts the output does **not** contain `another carry is in flight`.
- **After the fix.** `bash -n scripts/axcion-harness-v0.2/carry-turn.sh scripts/axcion-harness-v0.2/carry-turn.test.sh` → exit 0. `bash scripts/axcion-harness-v0.2/carry-turn.test.sh` → exit 0, `passed: 405  failed: 0` (baseline 371 + 34 new). `bash scripts/axcion-harness-v0.2/carry-turn.test.sh --prove-failure` → exit 0, `passed: 40  failed: 0`; mutant M6, which rewrites the lock-key line inside the function edited here, still applies and still forces its assertions to fail.
- **Changed files:** `scripts/axcion-harness-v0.2/carry-turn.sh` (+63/-6 region), `scripts/axcion-harness-v0.2/carry-turn.test.sh` (+134), and this state file. `logs/friction-log.md` and `logs/harness-runs/` were left untouched and unstaged.
- **Rollback:** `git revert` the implementation commit named below, or `git checkout <parent> -- scripts/axcion-harness-v0.2/carry-turn.sh scripts/axcion-harness-v0.2/carry-turn.test.sh`. The change is confined to those two files; no lease, dispatcher, or state format changed, so reverting restores the prior behaviour with no migration.

Deviations: none from the brief's authorized boundary.

Candidate deferrals noticed during this unit, not implemented:

- The uninspectable case pins the EPERM state to **pid 1**, and skips loudly (`SKIP`) if the suite runs as root, where pid 1 is genuinely `LIVE`. It ran here. A root CI runner would lose that assertion rather than fail it.
- Consuming `wl_lease__pid_state` couples the carrier to a library-internal name. A public `wl_lease_pid_state` wrapper would settle it, but `logs/scripts/work-loop-lease.sh` is outside this unit's authorized changes, so it was not added.
- Section 12's original `positively absent` case still asserts only rc and message; 12a's control now asserts the filesystem. The older weaker case was left in place rather than edited, to keep this unit's diff to additions.

Held from Unit 1 for closure, unchanged: mutually uninspectable live reclaimers both fail closed; `wl_lease_status` still describes a provably dead holder as `HELD`; the old-marker transition block can be removed only after no checkout can carry that format.

## Blocker

None.

## Next action

Codex: assess Unit 2 against correction-plan step 2 — the three-state legacy verdict, the atomic `ABSENT`-only cleanup, the failing-first evidence, and the four candidate deferrals above — then continue to the next correction-plan step, correct once, or close.
