---
task: work-loop-v2-dispatcher-reliable-supervised-use
status: active
turn: codex
---

## Objective and scope

Implement `plans/work-loop-v2-v0.2/work-loop-v2-dispatcher-reliable-supervised-use-implementation-plan-v0.1.md` through its complete Gate SA acceptance contract and independent adoption review, while preserving the plan's fixed supervised-use boundary.

Scope: the existing Work Loop v2 supervised dispatcher, its accepted helpers and runtime surfaces, focused proof, live trials, and the synchronous regression gate named by the plan. Excluded throughout: Gate ST, Gate U, unattended or walk-away release claims, dispatcher rewrite or language migration, merge, push, deployment, destructive cleanup, and every other exclusion in plan §§ 4 and 7.

Task exit condition: one integrated candidate has passed Gate SA and the independent review has returned `ADOPT`, or Patrik has explicitly chosen `SHRINK` or `STOP`.

## Lane and unit

Standard. Implementation mode. Unit 11 — honor terminal-finalizer failure in the die funnel

Named reason for the loop: the objective spans multiple bounded implementation and proof units, must survive session boundaries, and requires independent Codex assessment before it can count as complete.

## Brief

Unit 10 is accepted at `ba174bcecc79d3ce3dbf3f9dbea3db54e94370cc`: the real operator-terminal seam now consumes its exact run-bound result through the accepted path, structural, and expected-identity boundaries before release; missing or wrong-identity evidence exits 38, pins both leases truthfully, and makes the next dispatcher refuse at 17. Change set A remains active. The next smallest integrity gap is already named in the accepted evidence: the shared `die()` funnel used by terminal families D–L invokes the accepted finalizer but ignores its failure, so terminal-result publication can become unprovable without transferring control to the accepted lease-pin route.

Dominant deliverable: one production control transfer in the shared `die()` funnel that preserves ordinary terminal exits when finalization succeeds and enters the accepted terminal-unprovability path when finalization fails.
Evidence required in this hop: one targeted red/green case at the shared `die()` funnel proves that an induced terminal-finalizer failure currently continues with the original exit and releases, then proves the same failure exits 38, truthfully pins both owned leases, claims no terminal completion, and prevents the next dispatcher from acquiring, while a normal representative `die()` path remains unchanged.
Evidence explicitly deferred: terminal families A–C, M, and the remaining N sites outside this shared funnel; expanding terminal-result schema or semantic tuple validation; operator-terminal consumer behavior already accepted in Unit 10; status rendering; resume; moving run identity earlier; crash-boundary recovery beyond this seam; broad terminal-family, hostile-input, lease, carrier, and dispatcher matrices; Change sets B–D; live trials; adoption review; merge, push, deployment, and destructive cleanup.
Primary edit begins after: add and run one focused fixture that selects a representative existing D–L `die()` path, induces the accepted terminal finalizer to fail at publication, and observes the current funnel ignore that return, exit with the original terminal code, release both leases, leave no valid promised result, and allow a subsequent dispatcher to acquire.

Required outcome: make the shared `die()` funnel treat successful publication and unprovable publication as different terminal outcomes. When its accepted finalizer succeeds, preserve the existing result, original exit code, and normal lease release exactly once. When finalization fails, do not continue to the original exit or allow the EXIT trap to release either owned lease: enter the existing terminal-unprovability route, record one bounded truthful finalization-failure cause through the shared lease owner, pin both owned leases, exit 38 without advertising or claiming a terminal result, and make a subsequent dispatcher refuse with exit 17.

Reuse the accepted atomic producer and the accepted `die_terminal_unprovable` → `pin_lock_terminal` → `wl_lease_pin_terminal` route. Do not add another finalizer, terminal store, lease writer, reason taxonomy, lifecycle reader, parser, wrapper, retry, poller, or recovery state. Avoid recursion or a second attempt to finalize after the first finalizer has already made terminal evidence unprovable. Preserve the single finalization owner and the EXIT trap's accepted pin-aware behavior.

Governing authority and settled evidence:

- The content-bound-approved plan governs Change set A required behavior items 2–7, durable order items 5–6, missing-evidence blocking, and § 8's one-production-owner rule.
- Units 5–10 are accepted. Reuse their atomic producer, validators, operator-terminal consumer, and truthful shared-library lease pin; do not redesign or broadly re-prove them.
- Unit 10's accepted result records the ignored finalizer return in `die()` as an observed deferred concern. This unit promotes only that shared-funnel control point because it can otherwise discard the already accepted terminal-unprovability result.
- Terminal sites not owned by this shared funnel remain outside the unit. Their coverage is not evidence required here.

Check against the repository before editing:

1. Verify the D–L terminal paths still converge on one production `die()` funnel and that its call to the accepted terminal finalizer does not branch on failure before the original exit.
2. Verify the existing terminal-unprovability route can be entered from that funnel without recursively invoking the failing finalizer, attempting publication twice, or adding another lease writer.
3. Verify one representative normal `die()` path has a stable existing exit/result/release observable that can prove the success branch did not regress. If any premise is false, hand back the exact narrow conflict rather than widening the unit.

Required fail-capable evidence:

- quote the targeted pre-edit red: induced finalizer failure, original terminal exit, no valid promised result, both leases released, and subsequent acquisition admitted;
- show the corresponding post-edit case exits 38, claims no terminal completion or result, records one bounded truthful finalization-failure cause through the shared lease library, retains both leases across `die()` and the EXIT trap, and makes the next dispatcher exit 17;
- show one representative successful D–L `die()` path still finalizes exactly once, preserves its original terminal code and valid result, releases both leases, and permits the next acquire;
- include one mutation control that removes or bypasses only the new failure transfer and restores the unsafe original-exit/release behavior;
- show structurally that the shared funnel invokes the accepted finalizer once, has one failure transfer, and adds no second producer, terminal store, lease writer, parser, lifecycle reader, retry, or poller;
- re-run only the focused `die()`-finalization cases and the directly affected accepted finalizer/lease-pin cases; do not run full dispatcher, terminal-family, validator, lease, carrier, or mutation matrices;
- report pre-unit and handback commits and exact committed paths; and
- prove only `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, and this task state changed. `logs/friction-log.md` remains outside the unit and must stay untouched and uncommitted.

Capability subset: baseline only — read/search the approved plan and accepted Units 5–10, edit only `dispatch.sh`, `dispatch.test.sh`, and this task state, run focused local checks, and make the local handback commit. The baseline deny set is required in full. Nothing is selected from the pre-authorizable set, which is empty today. No operator-reserved capability is needed.

Completion condition: one local commit makes the shared D–L `die()` funnel honor the accepted terminal finalizer's return; finalizer success preserves the existing result, original exit, and release behavior; finalizer failure makes no second publication attempt, exits 38 through the accepted truthful shared-library pin route, retains both leases, and blocks the next dispatcher at 17; no terminal site outside the shared funnel or deferred subsystem is absorbed; only the three permitted paths change; and the task hands back with `turn: codex`.

Stop and hand back without widening if the funnel does not own the named terminal families, failure cannot enter the accepted terminal-unprovability route without recursion or duplicate publication, safe retention would require another lease writer or durable state, or the focused change would need to absorb terminal families outside the funnel. Challenge a false premise rather than designing around it.

## Latest result

Inspected (2026-08-17):
- Claim (1): HOLDS — read `die()` in `dispatch.sh`: one definition, calling `finalize_terminal_result "$code"` bare with no branch on failure before `release_lock; exit "$code"`; searched `dispatch.sh` for `die [0-9]` call sites — all top-level sites sit after run evidence is established (`RUN_ID` at its assignment line), and the only earlier-line occurrences are inside `die_terminal_unprovable`/`die_terminal_untrusted`, which run post-evidence.
- Claim (2): HOLDS — `pin_lock_terminal` → `wl_lease_pin_terminal` is callable directly from the funnel without passing through `die()`; a direct pin-print-release-exit path makes no second finalization attempt and adds no lease writer; `wl_lease_release` honors `WL_LEASE_PINNED` on both `die()`'s release and the EXIT trap.
- Claim (3): HOLDS — the no-transition terminal (turn `codex`, no-op actor) exits 22 and finalizes one result carrying `code=22`; case 51a already produces from exactly this path, so its exit/result/release observable is stable.

Correction round on the frozen finding (2026-08-17). Reproduced first by inspection: the guard line `[ "${WL_LEASE_PINNED:-0}" -eq 0 ] || return 0` sat in `die_funnel_unprovable`, and a forcing fixture (teardown-style pin planted through the shared library's own `wl_lease_pin` at the top of `die()`, evidence directory made unwritable by the actor) showed the pre-correction dispatcher exit 22 with no `STOP [38]` anywhere, the teardown cause in place, and no terminal result on disk.

Result: the finding is resolved. The already-pinned early return is removed; the pinned/unpinned distinction now governs only whether the transfer pins — unpinned leases get `pin_lock_terminal` with the finalization-failure cause exactly as before, while already-pinned leases keep their earlier, stronger cause untouched (no re-pin, so a teardown's survivor pids are never overwritten) and the failed publication is recorded on both output channels in the transfer's message. The exit is 38 in both branches: an unprovable ending is named as one no matter what pinned the leases first. No second finalization attempt, no second terminal-result owner, no second lease writer; the transfer still never recurses into `die()`. Successful `die()` finalization and existing pin retention are untouched.

Evidence: the committed focused suite (harness prelude + cases 55, 56, 57 including new 57e) against the pre-correction dispatcher: 74 pass / 3 fail — the failures being exactly the correction case (57e's 38-exit, its channel record, and its M24 control, which needs the coverage-guard marker only the corrected text carries). Against the corrected dispatcher: 78 pass / 0 fail. Case 57e proves: already-pinned + failed publication exits 38 (was 22), the failure is recorded on the output channels, both leases stay pinned under the preserved teardown cause (`descendants still running: 424242` still present, `terminal result unprovable:` absent — the re-pin that would overwrite it never fires), no result is claimed, and the next dispatcher is refused at 17. Mutation control M24 restores only the old early return by the coverage guard's marker and the pinned failure exits 22 again. The closure check's second question is answered by the same runs: 57a (successful finalization, original code, release, re-admit), 57b–d, and the accepted 55–56 all pass unchanged on the corrected dispatcher.

Pre-correction commit: `a5eb17e380fcbdc00cc5c60eff9059be62012077`. The handback commit is this state file's own commit, touching exactly `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, and this task state. `logs/friction-log.md` remains untouched and uncommitted.

Nothing new was noticed during the correction that is not already on the standing deferral list: terminal families A–C, M and the remaining N sites (dry-run and carry-one still release without a terminal result), status rendering, resume, and crash-boundary recovery beyond this seam.

## Blocker

None.

## Next action

Codex: closure check on the frozen finding only — is the already-pinned + finalizer-failure conjunction now observably terminal-unprovable at 38 with the earlier cause preserved, and did the correction break successful `die()` finalization or existing pin retention?
