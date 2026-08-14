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

Standard. Implementation mode. Unit 3a1 — wire the attended carrier to the accepted shared live-lease helper while preserving its attended-surface boundaries.

Named reason for the loop: the accepted repair spans shared process leasing, two transports, durable ownership, controller tests and authorized live validations; it requires multiple bounded units and independent assessment before it can support an integration decision.

## Brief

Dispatcher wiring and regression verification are accepted through commit `5255628a`: the complete dispatcher suite produced `pass=471 fail=11`, with all 11 failures confined to the unchanged carrier-dependent 12e cases. This unit now gives the carrier one dominant change—consume the same accepted live-lease helper. Repository-depth ownership admission, broad carrier verification and cross-transport suite closure remain separate units.

Governing sources and authority:

- Current operator decision: Phase 1 and its two bounded live validations are approved; D4 is retained; Phase 2 is deferred.
- Approved implementation basis: `plans/work-loop-v2-v0.2/work-loop-v2-cross-transport-concurrency-and-task-aware-worktrees-implementation-proposal-2026-08-13.md`, especially §§ 4.1–4.5, § 5.2 case 6, § 5.5 case 21 and § 7 step 3.
- Accepted shared helper: `logs/scripts/work-loop-lease.sh` at `c409c12a1a298f5163685677de8da158ee33e5f1`; its contract and helper evidence are unchanged.
- Accepted migration decision: during the changeover the carrier must read its legacy `${TMPDIR:-/tmp}/axcion-harness-v0.2.<checkout-key>.lock` path read-only and refuse a live or unreadable legacy holder rather than create a two-root admission window.

Required outcome: replace the carrier's checkout-only temporary-directory lock with the accepted shared task-plus-checkout lease helper. Preserve exit `17`, three-state holder handling, pin/release behavior, actor-lifecycle cleanup, refusal detail, one-hop semantics, no status surface, no worktree creation, no simulated-actor seam and all other attended boundaries. Add the one-release read-only legacy-lock refusal. Do not add ownership admission in this unit.

Check before editing, narrowly:

1. Map the carrier's current lock functions, state and call sites to the helper contract; identify caller-owned refusal and pin messages.
2. Identify the existing compatible carrier infrastructure outcome for a missing or unreadable helper. Stop rather than inventing a new exit code or changing the helper.
3. Confirm how existing carrier tests exercise stub binaries and linked worktrees, and record ambient `git status --short --untracked-files=all`.

Implementation and targeted evidence for this hop:

- Update the existing same-task/different-linked-worktree carrier case that currently asserts admission so it fails first under the new required refusal, then passes after wiring. The second carrier must exit `17` before launching.
- Add or adapt one narrow missing-helper assertion proving fail-closed refusal before the stub actor launches, using an existing compatible infrastructure outcome.
- Source and use the accepted helper for initialization, task-then-checkout acquisition, pinning and release. Delete the carrier's duplicate live-lock implementation; keep only caller-owned reporting and the temporary legacy-path compatibility read.
- Implement the legacy-lock compatibility read without writing, migrating or deleting a live or unreadable legacy lock. A provably dead legacy pid may follow the existing carrier policy; report the exact behavior.
- Preserve helper pin return-1 semantics and the carrier's operator-facing pin/refusal reporting at its call sites.
- Run `bash -n` on changed shell files and the accepted helper.
- Run only the narrow red/green carrier slice needed for the same-task/different-worktree and missing-helper cases, plus one focused ordinary acquire/refuse/release carrier smoke if those controls do not already prove release.
- Do not run the full carrier suite or dispatcher 12e in this hop; those are the next verification unit.
- Report removed duplicate machinery, targeted outputs, final diff and scope. Stage only `scripts/axcion-harness-v0.2/carry-turn.sh`, narrowly required `carry-turn.test.sh`, and this state file by explicit pathspec; report staged paths and commit hash.

Explicitly deferred: repository-depth ownership admission and ownership codes `33`/`34`/`35`; full carrier regression; dispatcher 12e closure; instruction changes; controller acceptance; and both live validations.

Stop and hand back if helper integration changes carrier boundaries, requires the helper contract or a new exit code to change, cannot preserve legacy-lock safety, needs ownership work in this unit, or the targeted fixture cannot remain bounded. Challenge a false premise rather than improvise.

Completion condition: the carrier is committed using the accepted task-plus-checkout lease helper; duplicate live-lock machinery is removed; the same task in another linked worktree is refused with exit 17; a missing helper fails closed before launch; legacy in-flight lock compatibility is preserved; syntax and focused lease evidence pass; only carrier, narrowly required carrier test and state file are committed; and the state hands back at `turn: codex`.

## Latest result

Inspected (2026-08-14):

- Claim (1) — carrier lock functions, state and call sites map to the helper contract: HOLDS. Read `scripts/axcion-harness-v0.2/carry-turn.sh`; `acquire_lock` at 636–659 and `release_lock` at 661–665, state `LOCK_DIR` at 259, call sites at 285 (`die`), 1205 (the carry), 1194, 1256, 1269. Caller-owned refusal wording is the three exit-17 `die` messages at 647, 651 and 655.
- Claim (1a) — the carrier has operator-facing PIN reporting at its call sites: FALSE. Searched `carry-turn.sh` for `pin` and `survivors`; zero occurrences of either. The carrier has never pinned: `terminate_actor_group` (669–684) prints a WARNING when a process group cannot be confirmed gone and the run then releases normally. Not treated as a blocking premise — no work rested on it, and the determinate answer is to add nothing. Recorded as a deferral below.
- Claim (2) — an existing compatible carrier infrastructure outcome exists for a missing or unreadable helper: HOLDS. Read the exit table at 116–153: `11 BAD_CHECKOUT`, already used for an uncanonicalizable checkout (389), a non-git checkout (391), an uncreatable log directory and an unwritable run log (1207, 1210). Same number the dispatcher uses for its lease-infrastructure failures. No new code invented, helper unchanged.
- Claim (3) — carrier tests exercise stub binaries and linked worktrees: HOLDS. Read `carry-turn.test.sh`; fake actor via `--claude-bin` (`make_fake_actor`, 120–225), linked worktree via `git worktree add` at 801. Ambient `git status --short --untracked-files=all` at start: `logs/friction-log.md` and this state file modified, plus 22 untracked files under `logs/harness-runs/`. None staged by this unit.
- Claim (4) — the accepted helper is unchanged since `c409c12a`: HOLDS. `git diff --stat c409c12a1a298f5163685677de8da158ee33e5f1 HEAD -- logs/scripts/work-loop-lease.sh` and the working-tree diff both return empty.
- Claim (5) — the two transports were jointly blind: HOLDS. Searched `carry-turn.sh` for `work-loop-dispatch-locks` and for `work-loop-lease`; no match for either before this unit.
- Claim (6) — `carry-turn.test.sh` line 811 asserts admission for the same task in a separate linked worktree: HOLDS. Read at 810–814: `assert_eq "the same task in a separate linked worktree IS admitted" "0" "$RC"`.

Result: the attended carrier now takes both leases through the shared helper. Its duplicate live-lock implementation is deleted — the `$TMPDIR` key derivation, the `mkdir` acquisition, the holder writes, the stale-clear-and-retake, and the `release_lock` body. What remains on the carrier's side is its own contract: exit `17`, the refusal wording, and the exit-`11` infrastructure outcome. Refusals now say WHICH resource refused and which program holds it. A missing or unreadable helper fails closed at `11` before any lease path is computed. The legacy `${TMPDIR}` lock is read for one release: a live or unreadable legacy holder is refused with the unchanged wording and nothing is deleted; a provably dead pid follows the existing carrier stale policy — the lock is removed and announced. No lock is ever migrated into a lease. No ownership admission was added.

Evidence — narrow red/green slice, sections 12, 12b and 12c of `carry-turn.test.sh`, assembled by cutting the suite's other sections out of a throwaway copy under `/tmp` (deleted after the run; no case-selection feature was added, per the Unit 2b2a decision). The number below is that slice's, not the carrier suite's.

- Red, test edits applied and `carry-turn.sh` untouched: `passed: 29 failed: 8`. The 8 are exactly the new behaviours — same task in a linked worktree returned `0` and launched its actor where `17` and no launch are required; the absent-library case returned `0`, launched, and moved HEAD where `11` and no launch are required.
- Green, after wiring: `passed: 37 failed: 0`. Same slice, same fixtures.
- The slice's controls are what stop this being an exit-code assertion: the worktree run with the task lease freed still carries (`RESULT outcome=CARRIED code=0`, actor ran once), the absent-library control with the library present carries, and the ordinary carry at the end of 12b leaves both lease directories gone — so acquire, refuse and release are each proven and no separate smoke was needed.
- Legacy compatibility is proven by section 12 and the first half of 12b passing unchanged: a live legacy holder refuses with `task 'task-y'`, an uninspectable one refuses and says `Nothing was deleted`, a provably stale one is cleared with `removing a stale lock`, and the different-task-same-checkout refusal still says `whether or not it is the same task`.
- `bash -n` clean on `carry-turn.sh`, `carry-turn.test.sh` and `logs/scripts/work-loop-lease.sh`.

Test-file changes, all narrowly required: fixtures now copy the lease library into every checkout and commit it (without it every carrier case fails closed at 11); `lock_path_for` is renamed in comment only, as the LEGACY path; `lease_root_for`, `task_lease_for`, `checkout_lease_for` and `plant_lease` are added once, mirrored from the library; 12b's worktree assertion is inverted with an over-refusal control; 12c is new.

Deferrals recorded, not done:

1. The carrier never pins. If it cannot confirm its actor tree stopped it warns and releases both leases, so a survivor process no longer blocks the next run — and under the shared lease that now also fails to block the dispatcher. The helper's `wl_lease_pin` is available and uncalled. Adding a pin call site is new carrier behaviour, outside this unit's one dominant change.
2. `--prove-failure` mutant M6 was not run. It rewrites the carrier's `key=` line, which now belongs to the legacy compatibility read rather than to the live lease, so what it proves has narrowed. Belongs to the broad carrier verification unit.
3. `dispatch.test.sh` helper `carrier_lock_for` still points at the legacy `${TMPDIR}` path, so cases 12e-1 and 12e-3 assert their setup against a directory the wired carrier no longer creates. That is dispatcher 12e closure, already the next unit.

Staged by explicit pathspec: `scripts/axcion-harness-v0.2/carry-turn.sh`, `scripts/axcion-harness-v0.2/carry-turn.test.sh`, this state file. `logs/friction-log.md` and the untracked `logs/harness-runs/` files were left alone.

Commit: `04de80a7` — 3 files, 341 insertions, 110 deletions.

## Blocker

None.

## Next action

Codex: assess unit 3a1 — the carrier's shared-lease wiring, the legacy read-only compatibility, the resource-naming refusals, and whether the three recorded deferrals belong where they were put.
