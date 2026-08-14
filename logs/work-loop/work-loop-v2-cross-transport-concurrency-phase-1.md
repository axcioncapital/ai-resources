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

Standard. Implementation mode. Unit 4r1 — make the shared helper's pin operation durable-or-explicit, with helper-only failing-first evidence. Executed; handed back for assessment.

Named reason for the loop: the accepted repair spans shared process leasing, two transports, durable ownership, controller tests and authorized live validations; it requires multiple bounded units and independent assessment before it can support an integration decision.

## Brief

The previous Unit 4 carrier hop was interrupted at the operator's request and ended at exit 28 with `partial=0`; inspection showed no Unit 4 code changes, both live leases free, and HEAD still `74d506bf`. On 2026-08-14 the operator approved a fresh smaller recovery, so this unit isolates the shared helper contract and its own evidence before either transport wrapper is changed. This directly advances the approved live-validation gate without repeating the stopped hop.

Governing authority: the operator-approved Phase 1 proposal bound at `10d2eeb6f8868b2f073e11150dc1a50a95ea760a`, especially §4.1 property 4 (pinning survives the process), §4.3 (both owned leases are pinned), §5 cases 16 and 18, and §8's pinned-lease risk. Phase 2 remains deferred, D4 remains, and the executable core is excluded.

Required outcome: within `logs/scripts/work-loop-lease.sh`, a pin operation may report ordinary success only when every lease the run owns has durable evidence that a later process recognizes as pinned. “No lease owned” and “owned lease could not be durably pinned” must be distinguishable outcomes. A task-evidence write failure or checkout-evidence persistence/replication failure must not be swallowed, and a later process must not remove an affected owned lease as a dead holder and admit work while the actor tree may survive. Preserve the existing partial-acquisition rule: an unowned resource is never claimed or pinned. Preserve ordinary acquire, release, and status behavior.

Claims to verify before changing code:

1. In `logs/scripts/work-loop-lease.sh`, confirm whether `wl_lease_pin` currently sets `WL_LEASE_PINNED=1` before persistence, suppresses both persistence errors, and returns 0 after any owned-task attempt. If not, stop with the actual behavior.
2. In that helper, identify exactly what durable state a later `wl_lease_acquire` or `wl_lease_status` recognizes as pinned, and whether a dead-holder directory without that state is removable. Report the functions and observed behavior rather than relying on a source-string check.
3. Search `logs/scripts/work-loop-lease.test.sh` for deterministic task pin-evidence failure and checkout pin-evidence failure coverage. Bound the absence claim to that suite and report the patterns searched.

Evidence required:

- Add the smallest failing-first helper regressions that deterministically force (a) task pin-evidence persistence failure and (b) checkout pin-evidence persistence/replication failure after both leases are owned. Show the pre-fix false success or unsafe subsequent admission; the test must exercise helper behavior, not grep its source.
- Implement the smallest shared-helper durable-or-explicit contract. The technical mechanism belongs to Claude. For each forced failure, demonstrate the helper's distinct result and the behavior of a fresh subsequent acquisition attempt against both affected owned resources.
- Keep case 16 behavior green: pinning after refusal or with only one resource owned never claims the unowned resource.
- Run only `logs/scripts/work-loop-lease.test.sh` in this unit. Record the exact red command/output, post-fix total and exit code, distinct pin results, and later-process acquisition outcomes.
- Commit only `logs/scripts/work-loop-lease.sh`, `logs/scripts/work-loop-lease.test.sh`, and this state file. Report the implementation commit and any pointer commit.

Codex framing decisions: transport wrapper interpretation is deliberately held for Unit 4r2 because it is a separate caller-facing deliverable; no live validation may run between these units. Carrier and dispatcher scripts/tests, Work Loop instruction edits, broad regression, and live cases 23/24 remain outside this unit. If total filesystem failure makes any durable marker physically impossible, do not invent a service or database: detect and return an explicit incomplete/failure outcome, demonstrate the boundary, and hand it back as an unresolved limitation rather than claiming later-process protection that cannot exist.

Stop if deterministic failure evidence requires privileged or destructive setup; if a safe helper contract requires changing either wrapper in the same unit; if it requires a scheduler, registry, lease database, executable-core change, Phase 2 work, or transport-boundary change; if the premise is false; or if the helper suite remains red. Do not silently widen the unit.

Completion condition: both persistence failures are demonstrated red against the current helper; the helper then provides durable later-process refusal for every failure it can persist and an explicit distinguishable incomplete outcome where it cannot; partial-acquisition behavior remains correct; the helper suite is green; only the bounded helper files and state are committed; and the task hands back at `turn: codex` for independent assessment before wrapper work opens.

## Latest result

Inspected (2026-08-14):

- Claim (1): HOLDS — read `logs/scripts/work-loop-lease.sh` `wl_lease_pin` end to end. It set `WL_LEASE_PINNED=1` before any write, redirected the survivors heredoc block with `2>/dev/null` and never examined its status, ran the checkout replication as `cp ... 2>/dev/null` with its status likewise unexamined, and returned 0 unconditionally once `WL_LEASE_TASK_OWNED` was 1. Every one of the three sub-claims held.
- Claim (2): HOLDS, with the recognized state named — the durable pinned state is the regular file `survivors` inside a lease directory. Recognized in exactly three places, all read by inspection: `wl_lease_acquire`'s task branch and checkout branch (`[ -f "$DIR/survivors" ]` → `WL_LEASE_REFUSAL=pinned` plus `WL_LEASE_SURVIVORS`), and `wl_lease_status` (same predicate → `PINNED` rather than `HELD`). On dead-holder removal: searched `logs/scripts/*.sh` for `kill -0`, `dead`, `stale`, `reap` and for `rm -rf` against a lock path, and searched the whole repository (excluding `.git`) for `work-loop-lease`, `WL_LEASE_TASK_DIR`, `WL_LEASE_CHECKOUT_DIR` and `work-loop-dispatch-locks` outside the library and its suite — no match. No automatic dead-holder reaping of a lease directory exists in the helper or in either transport (`scripts/axcion-harness-v0.2/carry-turn.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`); the only removal path is the manual one the survivors file itself instructs. So the hazard is not an automatic reaper — it is that without the survivors file a later run reports the lease as `held` by a pid that is now dead, which is precisely the state an operator clears by hand.
- Claim (3): HOLDS — searched `logs/scripts/work-loop-lease.test.sh` for `chmod 0*[05]00`, `read-only`, `readonly`, `persist`, `pin-evidence`, `pin_fail`, `ENOSPC`, `write.?fail`, `unwritable`, `cp fail`, and enumerated every driver `MODE` value. The suite's only pin modes were `pin`, `pin-task-only` and `pin-after-refusal`, none of which forces a persistence failure; the single `chmod 000` (case 8) makes a holder's `pid` file unreadable on the acquire path, not the pin path. No deterministic task or checkout pin-evidence failure coverage existed, bounded to that suite.

Result: `wl_lease_pin` is now durable-or-explicit. It verifies each owned lease by reading the evidence back with the same `-f` predicate `wl_lease_acquire` and `wl_lease_status` use, plus the `PINNED by pid ` marker line so a truncated file counts as missing. Three outcomes are now distinct: 0 = pinned with durable evidence on every owned lease; 1 = nothing owned, nothing pinned (unchanged); 2 = owned and pinned but at least one owned lease has no durable evidence, with the new `WL_LEASE_PIN_FAILED` naming which. `WL_LEASE_PINNED=1` is set first and unconditionally, so `wl_lease_release` still leaves the directories in place on a failed persistence — the directory remains the durable refusal. The checkout evidence is no longer `cp`-chained from the task file; both are written independently from one `wl_lease__pin_text` emitter stamped once, so one persistence fault can no longer present as two.

Evidence: two new deterministic controller cases, 11 (task evidence) and 12 (checkout replication), each forcing failure by placing a directory where the `survivors` file must go — privilege-independent, non-destructive, and producing exactly the state a lost write leaves for a later reader.

- Red, against an unmodified copy of the pre-fix helper: `WL_LEASE_LIB=<tmp>/work-loop-lease.PREFIX.sh bash logs/scripts/work-loop-lease.test.sh` → `pass=61 fail=6`, exit 1. The false success is on the record verbatim — `PIN rc=0 pinned=1 failed=[<unset>] task_evidence=no checkout_evidence=no` — a pin reporting ordinary success having written nothing either lease's later reader can see. Captured in `logs/harness-runs/lease-pin-durability-red-unit-4r1-20260814.out` (untracked).
- Green, post-fix: `bash logs/scripts/work-loop-lease.test.sh` → `pass=67 fail=0`, `SUITE_EXIT=0`, no FAIL lines. Same 67 assertions as the red run. Captured in `logs/harness-runs/lease-pin-durability-green-unit-4r1-20260814.out` (untracked).
- Distinct pin results: case 11 → `PIN rc=2 pinned=1 failed=[task] task_evidence=no checkout_evidence=yes`; case 12 → `PIN rc=2 pinned=1 failed=[checkout] task_evidence=yes checkout_evidence=no`. Both then `AFTER-RELEASE task=present checkout=present`.
- Later-process acquisition against both affected owned resources: after case 11, a fresh run on the same task is refused (exit 17, `resource=task`) and a fresh run on a different task in the same checkout is refused with `resource=checkout refusal=pinned` — its own evidence survived, which is the independence the red run did not have. After case 12, the same-task run is refused with `refusal=pinned` from the intact task evidence, and the different-task run is still refused by the checkout lease. No later run was admitted on any path.
- Case 16 behavior preserved: case 5 (`PIN-AFTER-REFUSAL rc=1 pinned=0`, nothing created) and case 6 (`PIN rc=0 pinned=1 task_survivors=yes checkout_survivors=no`) are green unchanged.
- Ran only `logs/scripts/work-loop-lease.test.sh`, as the brief bounds. No transport suite, no live case.

Known open seam, not fixed here by the brief's own boundary: both transports call `wl_lease_pin ... || return 0`, so the new rc=2 is currently swallowed at the caller and the operator-facing line is not printed. That is strictly safer than before — silence replaces a false "BOTH leases are now PINNED" claim — but it is not correct, and interpreting rc=2 is Unit 4r2's deliverable.

Limitation, unresolved at helper level: where no durable marker is physically possible, no return value creates one. The lease directory still refuses the next run and is never released while PINNED, but that run reads the refusal as `held` with an empty survivors pointer and a holder pid that is now dead — the documented manual remedy for which is to remove the directory. The residual risk is therefore operator-mediated, and closing it needs the caller to say what happened (Unit 4r2), not more mechanism here.

Deferred, noticed during this unit and not implemented: `wl_lease_pin`'s entry guard tests `WL_LEASE_TASK_OWNED` only, so a run owning the checkout lease but not the task lease would return 1 ("nothing was owned") while owning something. That state is unreachable through `wl_lease_acquire`, which rolls the task lease back on a checkout refusal, and widening the guard would touch the partial-acquisition rule the brief told me to preserve.

Prior accepted controller evidence remains: dispatcher 482/0; carrier 350/0; owner helper 92/0; shared lease helper previously 50/0, now 67/0 with the two new cases; Unit 3b1 failing-first carrier ownership evidence 333/17 over the same 350 assertions; Unit 3b2r carrier owner-admission green at 350/0 (`52ecf472`, pointer `74d506bf`); cross-transport red/green and stale-oracle mutant evidence in the earlier accepted units.

Open work after this unit: Unit 4r2's transport interpretation of rc=2; the two narrow Work Loop instruction edits required by proposal §1; broad plan-gate regression only where still needed; authorized live cases 23 and 24; final limitations and rollback record. Deferred without action: carrier process-group parameter naming, dispatcher case selection, duplicated fixture-packaging knowledge, and explicit broken-owner-helper catch-all coverage.

## Blocker

None.

## Next action

Codex: assess Unit 4r1. Judge whether the three distinct pin outcomes and the read-back verification satisfy §4.1 property 4 and §4.3 at helper level; whether the red/green pair is genuine falsifiable evidence rather than a check that could not fail; whether the recorded limitation (no marker is possible where the filesystem cannot hold one, leaving an operator-mediated residual risk) is accepted as written or must be narrowed; and whether the deferred `WL_LEASE_TASK_OWNED`-only entry guard stays deferred. Then decide whether Unit 4r2 opens for the transports' interpretation of rc=2. No live validation runs before that unit is assessed.
