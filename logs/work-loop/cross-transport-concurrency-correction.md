---
task: cross-transport-concurrency-correction
turn: codex
---

## Objective and scope

Correct the seven reviewed Phase 1 concurrency findings, complete the required controller and live evidence, and leave this branch ready for the final independent review and merge decision described in `plans/work-loop-v2-v0.2/work-loop-v2-cross-transport-concurrency-correction-plan-2026-08-14.md`.

Scope is exactly that correction plan as committed at `f2b19b5d80a061111c39cc7444f90f6374f19d38`. Excluded: Phase 2, automatic worktree creation, a scheduler, registry, service, new state store, new command surface, unrelated `LOCK_KEY` work, unrelated cleanup, merge, and push.

## Lane and unit

Standard. Implementation mode. Unit 3 — make carrier shutdown release leases only after a controlled process-group census positively proves the actor group empty.

Named reason for the loop: the correction spans several independently assessable units and must survive session boundaries; the result also needs assessment by someone other than its implementer before it can progress. The operator explicitly chose Work Loop v2 for this task on 2026-08-15.

## Brief

Units 1 and 2 are accepted. This unit closes correction-plan step 3: the carrier must not interpret a failed process-group signal probe as proof that the actor stopped, because releasing both leases on that guess can admit a second writer beside a survivor.

Required outcome: during the TERM grace period and after SIGKILL, only a controlled census that ran successfully and found the actor group empty may return clean and allow normal lease release. A visible survivor or any failed/inconclusive census is unknown, pins both leases, and records either the survivor PIDs or the inspection failure.

Governing sources:

- The operator-approved correction plan at `f2b19b5d80a061111c39cc7444f90f6374f19d38`, especially implementation sequence step 3 and its four acceptance conditions, governs this unit.
- The governing Phase 1 proposal named by that plan governs the invariant that any survivor or unprovable shutdown pins both task and checkout leases.
- The accepted shared lease implementation and existing `pin_leases` behavior govern how the retained leases are recorded; do not redesign pinning in this unit.

Check these claims against the live repository before changing anything:

1. Inspect `terminate_actor_group` in `scripts/axcion-harness-v0.2/carry-turn.sh` and verify whether the TERM-grace loop still returns clean directly from `kill -0` failure, before any census.
2. Inspect `actor_group_census` and the final post-SIGKILL branch. Verify whether the group query's own failure is propagated, and whether a later `kill -0` failure can still turn an empty or inconclusive result into clean shutdown.
3. Inspect the executed cases around section `12d` in `scripts/axcion-harness-v0.2/carry-turn.test.sh`. Report exact coverage for inspection becoming unavailable during TERM grace, group inspection failing after SIGKILL, a visible survivor, and a cleanly emptied group, including which current cases can fail against the two shortcuts above.
4. Report branch, checkout, Git status, and pre-existing operator-owned changes before editing. Do not stage or commit `logs/friction-log.md` or `logs/harness-runs/`.

Authorized changes:

- `scripts/axcion-harness-v0.2/carry-turn.sh`
- `scripts/axcion-harness-v0.2/carry-turn.test.sh`
- this state file
- `logs/friction-log.md` only if an existing hook updates it; never stage or commit it

Codex framing decision: dispatcher refusal logging, dispatcher status wording, the remaining controller matrix, live cases 23/24, and the closing record remain outside this unit. Unit 3 changes shutdown proof only; signal delivery remains an action, not evidence.

Required evidence:

- Add or sharpen exact cases for: inspection becoming unavailable during TERM grace; a group census that cannot inspect after SIGKILL; a visible survivor; and a cleanly emptied group as the positive control. Each must assert the lease outcome and the recorded reason, not only the exit code.
- Before the production fix, run the targeted new assertions against the pre-fix carrier and record output proving the TERM-grace and post-SIGKILL shortcuts fail for their intended reasons.
- After the fix, run `bash -n scripts/axcion-harness-v0.2/carry-turn.sh scripts/axcion-harness-v0.2/carry-turn.test.sh` and the full `bash scripts/axcion-harness-v0.2/carry-turn.test.sh`; report commands, exit codes, and current totals.
- Show that the clean control releases both leases, while a survivor or unknown result pins both and persists either PIDs or an inspection-failure reason. Confirm no `kill -0 ... || return 0` or equivalent two-state shortcut remains in `terminate_actor_group`.
- Report changed files, implementation commit, deviations, remaining limitations, and rollback instructions.

Completion condition: correction-plan step 3 is satisfied; the exact shutdown cases and full carrier suite pass; release is licensed only by a successful empty census; only authorized files are committed; and Claude updates this file, sets `turn: codex`, commits, and stops.

Stop and hand back without improvising if a controlled census cannot distinguish successful emptiness from inspection failure on the supported host, the required proof needs files outside the authorized boundary, or a premise is false.

## Latest result

Inspected (2026-08-15):

- Claim (1): HOLDS — read `terminate_actor_group` in `scripts/axcion-harness-v0.2/carry-turn.sh`. The TERM-grace loop was `kill -0 "-$pgid" 2>/dev/null || return 0`, returning clean directly from a failed signal probe, before any census.
- Claim (2): HOLDS, and both shortcuts were present. (a) `actor_group_census` discarded the exit status of its own group query (`out="$(ps -o pid=,pgid= -g "$pgid" 2>/dev/null)"`); only the neighbouring `ps -o pid= -p $$` control could make it return 1, so a `ps` whose `-p` answers and whose `-g` cannot run produced no rows and read as a confirmed-empty group. (b) The post-SIGKILL branch was `if ! kill -0 "-$pgid"; then return 0; fi` — the signal probe, not the census, licensed release. Host fact that rules out the naive fix: on this Darwin host `ps -o pid=,pgid= -g <pgid>` exits 1 with empty output for an unused in-range pgid (checked 40001/41234/42222/43333 and a just-exited pgid), so propagating that exit status would make every clean shutdown read as unknown.
- Claim (3): HOLDS — read section `12d` in `scripts/axcion-harness-v0.2/carry-turn.test.sh` (pre-fix lines 1159–1224). Coverage was: *a cleanly emptied group* — covered as the control (`task-be`); *a visible survivor* — covered (`task-bf`, plus the second-run refusal at exit 17); *group inspection failing after SIGKILL* — only partly (`task-bg` uses `NOPSDIR`, where **all** `ps` fails, which trips the `-p $$` control; the `-p`-works/`-g`-fails case was untested); *inspection becoming unavailable during TERM grace* — not covered at all, since every 12d case used `ignore-term:30` and so left through SIGKILL, never through the grace loop. **No pre-existing case could fail against either shortcut** — `task-be` and `task-bf` pass under both old and new code, and `task-bg` is caught by the older control.
- Claim (4): HOLDS — checkout `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-concurrency-fix-2`, branch `session/2026-08-14-concurrency-fix-2`, HEAD `bc979e8d`. Pre-existing operator-owned changes: modified `logs/friction-log.md`, modified this state file, untracked `logs/harness-runs/`. Neither `logs/friction-log.md` nor `logs/harness-runs/` was staged or committed.

Repository-depth ownership: PROCEED (this checkout already declares this task).

Result: Unit 3 is implemented. Carrier shutdown now releases leases only on a controlled census that ran successfully and named nobody, in the TERM grace period as well as after SIGKILL.

- `actor_group_census` proves its **own** query form. The readability control now asks `ps -o pid=,pgid= -g <this shell's pgid>` and requires this shell's pid back, instead of asking `ps -p $$`. A group query that cannot run is therefore unknown, not an empty group. The exit status is deliberately not the discriminator, for the Darwin reason recorded under claim (2).
- The TERM-grace loop no longer decides anything with `kill -0`. Each second it runs the same census, and leaves early only when the census ran and named nobody. A census that cannot run neither shortens the grace period nor releases a lease.
- The post-SIGKILL branch is inverted: a successful empty census is the licence to release, and the `kill -0` probe survives only as a one-way veto — if the group still answers while the census named nobody, the two inspections disagree and the result is recorded as unknown. No `kill -0 ... || return 0` or equivalent two-state shortcut remains in `terminate_actor_group`; the only remaining `return 0` on that path is guarded by `[ -z "$survivors" ] && [ -z "$unknown" ]`.

Evidence:

- **Failing first.** Four new cases were added to section `12d` (`task-bh` TERM-grace positive control; `task-bi` inspection unavailable during TERM grace; `task-bj` visible survivor during TERM grace; `task-bk` group query failing after SIGKILL) plus a new `NOGPSDIR` fixture — a `ps` whose `-p` works and whose `-g` exits 1. Run against the **pre-fix** carrier: `passed: 411  failed: 12`. The 12 failures were exactly the two shortcuts — `task-bi` and `task-bk` released both leases and printed no `sweep incomplete`; `task-bj` released both leases beside a survivor the census could still see and never printed `still running in the actor's process group`. Both positive controls (`task-be`, `task-bh`) passed pre-fix, so the new cases cannot be satisfied by a carrier that simply pins everything.
- **After the fix.** `bash -n scripts/axcion-harness-v0.2/carry-turn.sh scripts/axcion-harness-v0.2/carry-turn.test.sh` → rc 0. `bash scripts/axcion-harness-v0.2/carry-turn.test.sh` → rc 0, `passed: 423  failed: 0` (was 405/0 before this unit; +18 assertions). `bash scripts/axcion-harness-v0.2/carry-turn.test.sh --prove-failure` → rc 0, `passed: 40  failed: 0`. `bash logs/scripts/work-loop-lease.test.sh` → `pass=127 fail=0`, unchanged.
- **The clean control still releases.** `task-be` (post-SIGKILL) and `task-bh` (TERM grace) both assert ACTOR_TIMEOUT (21), `assert_absent PINNED`, and that neither lease directory survives. A survivor or an unknown result pins both and persists either the pids (`descendants still running: <pid>`) or the reason (`sweep incomplete: …`) into the pin file — asserted on the file contents, not only on stdout.

Changed files: `scripts/axcion-harness-v0.2/carry-turn.sh`, `scripts/axcion-harness-v0.2/carry-turn.test.sh`, this state file. Implementation commit: see `## Next action`. Rollback: `git revert` that commit; it touches only the two harness files and this record, and the pre-fix behaviour is fully restored by it.

Deviations: one, stated rather than silent. The brief's required outcome reads as "successful empty census ⇒ clean". The implementation keeps the existing `kill -0` corroboration in a one-way form: it can only turn a successful empty census into *unknown*, never the reverse. That is strictly more conservative than the requirement, preserves the deliberate behaviour documented in the pre-fix comment block, and is consistent with "any inconclusive result is unknown and pins". If Codex reads the requirement as excluding the veto too, removing the `kill -0` call and returning 0 on `[ -z "$survivors" ] && [ -z "$unknown" ]` is a two-line change.

Candidate deferrals, recorded and not done: (a) no M-series mutation case was added for the new `-g` control — the four new 12d cases already provide the failing-first proof, and an M-case would test the suite rather than the carrier; (b) `observe_nested` uses the same `-g` query and carries the older `ps`-output-nonempty control, which is adequate for a count but is not the same proof — outside this unit's authorized scope for behaviour change; (c) on a host where `ps -g` cannot run at all, every interrupted or timed-out hop now pins both leases where the TERM-grace path used to release them. That is the required invariant, not a defect, but it is a real operator-facing consequence and belongs in the accepted limitations at closure.

Units 1 and 2 accepted.

- Unit 1 (`fee4fe49`, `ca35371c`, `57f3b25b`): shared lease three-state liveness and safe stale recovery, including interrupted reclaimers and one-winner contention. Final reported suites: lease `127/0`, carrier `371/0`, dispatcher `537/0`.
- Unit 2 (`2d58991d`, record update `bc979e8d`): carrier legacy-lock compatibility now delegates to the shared verdict, preserves every non-absent lock, atomically claims only positively absent locks, and retains a positive admission control. Reported carrier evidence: `405/0`; mutation proof: `40/0`.

Unit 2 candidate deferrals were assessed and do not justify more work now: using the shared internal probe is the correction plan's intended single-classifier choice; the older weaker stale case is harmless beside the stronger control; and the EPERM case's root-only skip is explicit while the supported host ran it.

Held for closure from Unit 1: mutually uninspectable live reclaimers both fail closed; `wl_lease_status` describes a provably dead holder as `HELD`; the old-marker transition block can be removed only after no checkout can carry that format.

## Blocker

None.

## Next action

Codex: assess Unit 3 against correction-plan step 3 and its four acceptance conditions. Implementation commit: `cda44c50` (`scripts/axcion-harness-v0.2/carry-turn.sh`, `scripts/axcion-harness-v0.2/carry-turn.test.sh`, this state file). Decide in particular whether the retained one-way `kill -0` veto is accepted as written or must be removed, and whether the three recorded candidate deferrals are accepted as deferrals.
