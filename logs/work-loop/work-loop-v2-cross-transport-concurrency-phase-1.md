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

Standard. Implementation mode. Unit 7 — repair the stale ownership setup in dispatcher Case 12e-3 and restore the complete dispatcher suite.

Named reason for the loop: the accepted repair spans shared process leasing, two transports, durable ownership, controller tests and authorized live validations; it requires multiple bounded units and independent assessment before it can support an integration decision.

## Brief

Unit 6 is accepted as a valid discovery result: three complete suites are green, and the dispatcher suite exposed one root failure plus four cascades in Case 12e-3. The red gate blocks the authorized live validations. This unit repairs only that stale controller fixture and proves the complete dispatcher suite green.

Governing authority: the approved Phase 1 proposal bound at `10d2eeb6f8868b2f073e11150dc1a50a95ea760a`, especially acceptance case 12e-3 and §7 step 4. Accepted behavior that must not be weakened: the carrier and dispatcher both take shared task/checkout leases before repo-depth ownership admission; ownership must still refuse a task bound to another checkout; Case 12e-3 must specifically prove exit 17 from cross-transport task-lease contention, not exit 33/34 from ownership. Phase 2, D4, transport code, owner/lease helper code, other fixtures, live cases 23/24, main checkout, push, and cleanup are excluded.

Required outcome: in `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, make Case 12e-3 establish an ownership-valid carrier in its linked worktree before contention, so that the carrier actually launches and holds the shared task lease and the dispatcher in the original checkout is refused with 17 before actor launch. Preserve the case's setup oracle, loser exit/message, no-actor/no-commit checks, and positive carrier-launch control.

Claims to verify before editing:

1. Reproduce the current Case 12e-3 root failure from Unit 6's raw output and inspect the carrier-side capture/output enough to establish its actual prelaunch stop. Do not assume the mechanism from Codex's framing.
2. Verify whether the fixture declares `xt-shared` in the original checkout before creating the linked worktree, leaving the carrier's linked checkout durably refused by the ownership admission added at `52ecf472`.
3. Verify that settling the declaration locally in the linked carrier checkout is consistent with the owner-helper contract and causes the original-checkout dispatcher to reach the already-held task lease first. Compare the analogous ownership-settled control in `carry-turn.test.sh`; reuse the established fixture principle without broad packaging cleanup.

Evidence required: retain Unit 6's 498/5 complete-suite result as the failing case; show the exact root cause and why the four other failures cascade from it; after the bounded fixture correction, run the complete dispatcher suite once and capture raw output under `logs/harness-runs/`, with exit 0 and explicit count. Show that 12e-3 now has a live task lease, dispatcher exit 17, no dispatcher actor or commit, and exactly one carrier actor launch. Run `git diff --check` on the bounded test edit.

Commit only `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` and this state file with explicit pathspecs. Do not change production code merely to satisfy a fixture whose ownership setup predates carrier admission.

Codex framing decision: this is one stale-fixture repair, not a redesign of the cross-transport matrix. Unit 6's green helper, owner, and carrier suites are accepted and must not be rerun. The false Unit 6 preflight premise is also corrected for later work: an attended carrier is expected to hold this task and checkout's leases during its Claude hop; future preflight must distinguish those carrier-owned leases from a different live run instead of requiring the lease root to be empty.

Stop if the carrier-side failure is not ownership admission, a truthful 12e-3 requires weakening ownership or lease ordering, another cross-transport case must change, the complete dispatcher suite remains red, or any production file would need modification. Hand back the evidence rather than broadening.

Completion condition: Case 12e-3 reaches and proves the intended cross-transport task-lease refusal without weakening ownership, the complete dispatcher suite exits 0, only the bounded test and state file are committed, and the task hands back at `turn: codex`.

## Latest result

Inspected (2026-08-14):

- Claim (1): HOLDS — reproduced Case 12e-3's setup standalone against `scripts/axcion-harness-v0.2/carry-turn.sh` with the carrier's output captured instead of discarded. The carrier's actual prelaunch stop is `STOP [33] ownership refused for task xt-shared in <worktree>`, `verdict: REFUSE`, `reason: task 'xt-shared' is already claimed by checkout <original>`, `RESULT outcome=STOPPED code=33 actors=0`. It is repository-depth ownership admission (`carry-turn.sh` 1496-1508), not a lease, and it stops before any actor launch — so the carrier never takes the task lease the case measures.
- Claim (2): HOLDS — read `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` 638-653 as it stood: `work-loop-owner.sh claim --checkout "$d" --depth repo` ran on line 645, and `git worktree add` created `$WT` on line 650. The declaration was therefore made in the original checkout before the linked worktree existed, and `check_repo` (`logs/scripts/work-loop-owner.sh` 258-269) refuses any other checkout while exactly one checkout claims the task. Confirmed by running the check from `$WT`: `verdict: REFUSE`, exit 3.
- Claim (3): HOLDS — settling the declaration in the carrier's own checkout with `--depth local` is what the owner-helper contract permits there, and repo depth is not: with the state file replicated into two checkouts and neither declaring it, `claim --depth repo` from `$WT` returns `verdict: AMBIGUOUS` and writes no marker (`work-loop-owner.sh` 278-282), which is why claiming is never the way out of an ambiguity. `check --depth repo` from `$WT` then returns PROCEED. The same local-claim principle is the ownership-settled control in `scripts/axcion-harness-v0.2/carry-turn.test.sh` 955-965. The original-checkout dispatcher still reaches the task lease first regardless of ownership, because `acquire_lock` runs at `dispatch.sh` 1249 and ownership admission at 2370.

Result: Case 12e-3's stale ownership setup is repaired in the fixture only. The repo-depth claim in the original checkout is replaced by a `--depth local` claim in the carrier's linked worktree, made after the worktree exists, with the reasoning recorded in place — why the declaration belongs to the carrier's checkout, why the depth is local, why exactly one declaration is the maximum, and why leaving the original checkout undeclared is safe given the dispatcher's lease-before-ownership order. The case's lease oracle, expected exit 17, no-actor and no-commit checks, and the positive carrier-launch control are all unchanged. No production file changed.

Evidence: the failing case is Unit 6's complete dispatcher suite at 498 pass / 5 fail — one root Case 12e-3 setup failure (`no lease at .../task-a962de0d108a7487.lock`) plus four cascades from it (`expected exit 17, got 0`; `actors ran: xt-shared`; `HEAD moved`; `launches: 0`), retained at `logs/harness-runs/20260814-unit6-gate-4-dispatcher.out`. The four cascade from the root because the carrier stopped at 33 before launch: with no live task lease the dispatcher was admitted, ran its actor, committed, and the control counted zero carrier launches. After the bounded fixture correction the complete dispatcher suite was run once: exit 0, `pass=503 fail=0`, raw output at `logs/harness-runs/20260814-unit7-dispatcher-green.out`. The assertion total is unchanged at 503 — one setup assertion was replaced, none added or dropped. Case 12e-3 now reports all seven of its assertions PASS, including `the carrier's TASK lease is live before the dispatcher starts`, `a dispatcher is refused while a CARRIER holds the same task elsewhere` (exit 17), `and the dispatcher launched no actor`, `and committed nothing`, and `control — the carrier that HELD the task did launch its own actor`. A separate standalone reproduction confirms the refusal is the lease and not ownership: `STOP [17] another dispatcher holds task xt-shared (.../work-loop-dispatch-locks/task-a962de0d108a7487.lock)` / `it is running in checkout: <worktree>`, with `carrier actor launches: 1`. `git diff --check` on the bounded test edit returns clean, exit 0. The evidence can fail: exit 17 is lease-specific and 33/34 are the ownership codes, so an ownership-refused dispatcher would have failed this case rather than passed it, which is exactly what Unit 6 recorded.

Deferral, noticed and not done: `dispatch.sh` 724 words a task-lease refusal as `another dispatcher holds task <id>` even when the holder is the attended carrier. The lease metadata already records the holder program (`WL_LEASE_HOLDER_PROGRAM`, `work-loop-lease.sh` 152-164), so the wording could name it. Not done here because it is a production file and this unit is bounded to the fixture; it is cosmetic to the refusal, not to the refusal's correctness.

## Blocker

None.

## Next action

Codex: assess Unit 7 against its completion condition — Case 12e-3 reaches the intended cross-transport task-lease refusal without weakening ownership or lease ordering, the complete dispatcher suite exits 0 at 503/0, and only the bounded test and this state file are committed. Then decide whether the Phase 1 regression gate is green enough to open the two authorized live validations (cases 23 and 24), and dispose of the recorded deferral.
