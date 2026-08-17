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

Result: the shared `die()` funnel now honors its finalizer's return. Success is byte-for-byte the old behavior — original code, one result, advertisement, normal release. Failure transfers on one marked line (`# die funnel failure transfer`) to the new `die_funnel_unprovable`, which pins both owned leases through the parameterized `pin_lock_terminal` (default finalization-failure cause — truthful here), prints the 38 explanation on both channels, and exits 38 directly — no recursion into `die()`, no second publication attempt, no new lease writer. Two guarded returns keep the transfer inside its funnel: a terminal with no run evidence yet keeps its original exit (the same boundary the finalizer draws for itself), and an already-pinned lease keeps its recorded cause and original code, because re-pinning would overwrite stronger evidence (a teardown's survivor pids) and nothing releases while pinned. The unprovable/untrusted 38 paths through `die()` are unchanged by the guard: their leases are already pinned when `die(38)`'s own finalize attempt fails or no-ops.

Evidence: red quoted before the primary edit — with the evidence directory made unwritable at publication time (runtime induction by the actor, no dispatcher mutation), the pre-unit funnel exited with the original 22, left no promised result, advertised none, released both leases, and admitted the next dispatcher at 22. The committed focused suite (harness prelude + cases 55, 56, 57) against the pre-unit dispatcher: 61 pass / 7 fail, the failures being exactly the new funnel cases (57b transfer, 57c control, 57d shape). Against the edited dispatcher: 70 pass / 0 fail. The representative D–L terminal still exits 22 with exactly one result truthfully carrying `code=22`, releases both leases, and admits the next acquire (57a). The induced failure exits 38, claims and advertises no result, records the bounded `could not finalize` cause through the shared lease library in both pins — not a teardown or consumer-refusal story — retains both leases across `die()` and the EXIT trap, and the next dispatcher exits 17 (57b). Mutation control M23 removes only the transfer text while keeping the finalizer call, and the failed publication exits 22 and releases again (57c). Case 57d pins the shape: one finalizer invocation in `die()`, one transfer marker, one pin call in the transfer, no re-finalize, no sleep, direct exit 38. Accepted cases 55 and 56 pass unchanged in both runs. No full dispatcher, terminal-family, validator, lease, carrier, or mutation matrix was run.

Pre-unit commit: `ba174bcecc79d3ce3dbf3f9dbea3db54e94370cc`. The handback commit is this state file's own commit, touching exactly `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, and this task state. `logs/friction-log.md` carries unrelated pre-existing session notes and stays untouched by this unit and uncommitted.

Deferral observed, not absorbed: the already-pinned guard means a teardown-pinned run whose finalize also fails keeps its original teardown exit code with leases retained and the teardown cause preserved — the retention is safe and truthful, but no 38 signal marks the additional publication failure; named here for a later terminal-family unit. Terminal families A–C, M and the remaining N sites (dry-run and carry-one still release without a terminal result), status rendering, resume, and crash-boundary recovery beyond this seam remain the standing deferred concerns.

## Blocker

None.

## Next action

Codex: assess Unit 11 — the die() funnel failure transfer, its runtime-induced red/green, the M23 control, and the recorded already-pinned deferral — and decide close, continue, or correct once.
