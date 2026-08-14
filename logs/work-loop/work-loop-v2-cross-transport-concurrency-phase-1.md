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

Standard. Implementation mode. Unit 2b1 — wire the accepted shared lease helper into the dispatcher and remove the dispatcher's duplicate inline lease implementation.

Named reason for the loop: the accepted repair spans shared process leasing, two transports, durable ownership, controller tests and authorized live validations; it requires multiple bounded units and independent assessment before it can support an integration decision.

## Brief

The previous Unit 2b carry stopped at exit `22` after 593 seconds with no file or state transition: Claude completed baseline preparation and ended while waiting for a broad baseline. The operator has approved this fresh, smaller recovery unit. It has one dominant deliverable—dispatcher wiring—and deliberately defers broad verification.

Governing sources and authority:

- Current operator decision: Phase 1 and its two bounded live validations are approved; D4 is retained; Phase 2 is deferred; this narrowed recovery unit is approved after the stopped carry.
- Approved implementation basis: `plans/work-loop-v2-v0.2/work-loop-v2-cross-transport-concurrency-and-task-aware-worktrees-implementation-proposal-2026-08-13.md`, especially §§ 4.2–4.5 and § 7 step 2.
- Accepted shared authority: `logs/scripts/work-loop-lease.sh` and its contract at commit `c409c12a1a298f5163685677de8da158ee33e5f1`.
- Accepted Unit 2a constraints: `wl_lease_pin` returns 1 when no lease is owned; the helper prints no pin message; it is intentionally source-only and mode 644. Preserve dispatcher behavior at its call sites rather than changing the helper.

Required outcome: make `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` source and use the accepted helper for lease initialization, acquisition, pinning, release and lease status; remove its duplicate inline lease machinery. Preserve its current lock root and names, task-then-checkout order, rollback, actor-lifecycle cleanup, exit codes, refusal/pin reporting, read-only status, and separation between leases and durable ownership.

Check before editing, narrowly:

1. Map the existing dispatcher lease functions, state and call sites to the accepted helper contract. Do not run a broad baseline before the primary edit.
2. Confirm the helper's root and lock names are compatible with the dispatcher's current paths and identify the existing fail-closed infrastructure outcome suitable for a missing or unreadable helper. If compatibility fails or a new exit code is required, stop and hand back.
3. Record `git status --short --untracked-files=all`; preserve ambient friction-log and harness-run files.

Implementation and evidence for this hop only:

- Add one targeted failing-first dispatcher integration case showing that a missing or unreadable lease helper refuses before actor launch with the compatible existing infrastructure outcome. Run that case red before the production edit and green afterwards. Keep the fixture narrowly local to this case.
- Source the accepted helper fail-closed, replace the dispatcher's inline lease calls/state with its contract, and delete the duplicate inline implementation rather than leaving dormant code.
- Handle `wl_lease_pin` returning 1 as the accepted no-owned-lease condition, and preserve the dispatcher's existing pin log/message at the caller.
- Run `bash -n` on each changed shell file.
- Run one focused existing acquire/refuse/release smoke through the real dispatcher entry path. Choose the smallest existing case that proves the dispatcher actually traverses the shared helper.
- Report the targeted red/green output, syntax output, focused smoke output, and the removed inline functions/state.
- Report the final diff and confirm that no helper, carrier, instruction, core, policy or unrelated file changed.
- Stage only `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, narrowly required `dispatch.test.sh`, and this state file by explicit pathspec. Report `git diff --cached --name-only` and the final commit hash.

Explicitly deferred to Unit 2b2 verification: the full dispatcher baseline/regression suite, the full helper suite, the complete lease/rollback/pin/status matrix, and the Unit 1 cross-transport 12e red-signature check. Do not run them in this hop. The carrier and all instruction surfaces remain later units.

Stop and hand back if the accepted helper contract is insufficient, path compatibility fails, a behavior or exit-code change is needed, the targeted fixture cannot be kept narrow, or completing the wiring requires helper, carrier, instruction or core changes. Challenge any false premise rather than improvising.

Completion condition: the dispatcher is committed using the accepted shared helper with its duplicate inline lease machinery removed; the targeted fail-closed case is red then green; syntax and one focused real-dispatcher smoke pass; external behavior is preserved at the mapped call sites; only the dispatcher, narrowly required test, and state file are committed; and the state hands back at `turn: codex` for a separate verification unit.

## Latest result

Inspected (2026-08-14):
- Claim (1) — the dispatcher's inline lease functions, state and call sites map onto the accepted helper contract: HOLDS. Read `dispatch.sh` 610–743 and grepped it for `LOCK_ROOT|LOCK_DIR|LOCK_OWNED|LOCK_PINNED|acquire_lock|release_lock|pin_lock|CHECKOUT_LOCK`; found the derivation (639–650), `acquire_lock` (657–699), `pin_lock` (706–732), `release_lock` (734–743), and the call sites at 398 (`die`), 1128 (`pin_lock`), 1182 and 1186 (signal handler and EXIT trap), 1192 (`acquire_lock`), 2379/2419/2660 (`release_lock`), plus the read-only `--status` branch at 1217–1291. Every one maps to `wl_lease_init` / `_acquire` / `_pin` / `_release`; the `--status` branch needs the two resolved paths only.
- Claim (2a) — the helper's root and lock names are compatible with the dispatcher's current paths: HOLDS. Compared `work-loop-lease.sh` 91–129 against `dispatch.sh` 639–650; both derive the root from `git rev-parse --git-common-dir`, both use the fixed subdirectory `work-loop-dispatch-locks`, and both key the two leases as `task-<16>.lock` / `checkout-<16>.lock` from the identical expression `printf '%s' "$X" | shasum -a 256 | cut -c1-16`. Byte-identical paths, so no in-flight or pinned lease is orphaned by the change.
- Claim (2b) — an existing fail-closed infrastructure outcome fits a missing or unreadable helper, so no new exit code is required: HOLDS. Searched the exit-code table in `dispatch.sh` 124–248 and the ownership gate at 2336–2348. Exit `11` BAD_CHECKOUT is already this dispatcher's outcome for every other lease-infrastructure failure (unresolvable Git common directory 639–640, unreadable one 642–643, uncreatable lease root 658–659) and is reached the same way, by direct `printf` + `exit` rather than `die()`, which is required because `die()` calls `release_lock`. `33`/`34`/`35` were rejected: proposal § 4.4 (line 296) binds those three to the ownership taxonomy, and a lease is not an ownership fact. Confirmed no `die N` call precedes the lease block, so the pre-source refusal path is reachable and safe.
- Claim (2c) — the helper resolves from the checkout being driven: HOLDS. Proposal § 4.5 constraint 2 (lines 310–314) frames the case as "older checkouts may not carry the helper" and directs fail-closed "exactly as the ownership check already does"; `dispatch.sh` 2336 resolves `work-loop-owner.sh` from `$CHECKOUT`, and 2251 does the same for `prime-session-entry.sh`. Same resolution used.
- Claim (3) — ambient working-tree state recorded: `git status --short --untracked-files=all` before the edit showed ` M logs/friction-log.md`, ` M logs/work-loop/work-loop-v2-cross-transport-concurrency-phase-1.md` and 20 untracked `logs/harness-runs/` files. All preserved; none staged except this state file.

Result: `dispatch.sh` now sources the accepted shared lease library from `$CHECKOUT/logs/scripts/work-loop-lease.sh` and takes, pins and releases its live lease through it. The duplicate inline machinery is deleted, not left dormant — the root/key derivation, both `mkdir` acquisitions, the holder writes, the rollback, the pin-file writer, the both-leases pin copy and the release body are all gone, together with the `LOCK_OWNED`, `CHECKOUT_LOCK_OWNED` and `LOCK_PINNED` state variables. What remains on the dispatcher's side is its own half: the four exit-17 refusal messages, the exit-11 infrastructure outcomes, the operator-facing pin line, and the three-state read-only `--status` rendering. `LOCK_ROOT`, `LOCK_DIR` and `CHECKOUT_LOCK_DIR` survive as read-only views assigned from `WL_LEASE_ROOT` / `_TASK_DIR` / `_CHECKOUT_DIR` — no second derivation, and the ~14 `--status` and pin references stay untouched. `wl_lease_pin` returning 1 is handled at the caller as the accepted no-owned-lease condition, matching the old `[ "$LOCK_OWNED" -eq 1 ] || return 0` guard. Net `dispatch.sh` change: 105 insertions, 83 deletions.

Evidence:
- Targeted failing-first case, new `dispatch.test.sh` case 12f — an absent lease library must refuse before launch. RED against the unwired dispatcher: `pass=4 fail=3`, with `FAIL an ABSENT lease library refuses with exit 11 — expected exit 11, got 0`, `FAIL the refusal names the missing lease library`, and `FAIL no actor was launched without the lease library` (the run completed and the actor ran: `actors ran: lease-missing`). GREEN after the production edit: `pass=7 fail=0`. The two controls in the same case pass in both directions, so the case cannot be satisfied by a dispatcher that refuses everything.
- Syntax: `bash -n` clean on `dispatch.sh`, `dispatch.test.sh` and `work-loop-lease.sh`.
- Focused real-dispatcher smoke, existing case 12 (`a second dispatcher on the same checkout/task is refused`): `pass=7 fail=0`. It proves the dispatcher actually traverses the shared library on every lease path — task lease acquired then refused (exit 17), the TMPDIR-independence assertion, a different task in the same checkout refused via the checkout lease, the checkout refusal naming the holding task (which reads `WL_LEASE_HOLDER_TASK`), both leases released after the run, and the lease root resolving inside the Git common directory.
- Scope: `git status` shows only `dispatch.sh` and `dispatch.test.sh` changed by this hop. No helper, carrier, instruction, core, policy or unrelated file was touched; `logs/friction-log.md` and the untracked `logs/harness-runs/` files are the pre-existing ambient state and were left alone.

Deferrals noticed during this hop, recorded and not done:
1. `--status` keeps its own rendering rather than calling `wl_lease_status`. The library's report is a different, shorter format, and the brief requires the dispatcher's read-only status behavior preserved; converging the two would change output the suite asserts on. Worth deciding deliberately in a later unit.
2. `LOCK_ROOT` / `LOCK_DIR` / `CHECKOUT_LOCK_DIR` are kept as aliases rather than renaming ~14 call sites to the `WL_LEASE_*` names. Purely mechanical, but it would inflate a hop that deliberately defers broad verification.
3. `dispatch.test.sh` still mirrors the lease path derivation in `lock_root_for` / `task_lock_for` / `checkout_lock_for` instead of sourcing the library. The suite's own comment at those functions names this drift hazard; the same argument now applies to the shared library.

Unit 2b1 commit: `1f0938a7bc0e680583e7abe1ecc933ebe5b5b902`, staging exactly `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` and this state file.

Prior accepted units, unchanged: Unit 1 at `54d9db9c` and `b67f88d9`; Unit 2a at `c409c12a` and pointer correction `1b736816`.

## Blocker

None.

## Next action

Codex: assess Unit 2b1 against its completion condition — the dispatcher wired to the accepted shared helper, its duplicate inline lease machinery removed, case 12f red then green, syntax clean, and one focused real-dispatcher acquire/refuse/release smoke passing, with only the dispatcher, its narrowly required test and this state file committed.

Three judgments this hop deliberately left to you rather than settling on its own:

1. The missing-or-unreadable lease library takes exit `11`, the existing lease-infrastructure outcome, not a new code and not one of the ownership codes `33`/`34`/`35`. Confirm that reuse is the intended reading of proposal § 4.5 constraint 2, which prescribes the fail-closed *manner* but names no code.
2. The refusal now also stops `--status` in a checkout without the library, because `--status` needs the resolved lease paths to report anything. That is a superset of "refuses before actor launch" and still read-only, but it is a behavior change at a surface the brief asked to preserve. Accept or reject it explicitly.
3. The three deferrals recorded in `## Latest result` — `wl_lease_status` unused, the `LOCK_*` path aliases retained, and the suite's mirrored path derivation — are candidates, not work. Decide which belong to Unit 2b2 verification and which are separate.

Then open Unit 2b2 for the deferred verification: the full dispatcher baseline and regression suite, the full helper suite, the complete lease/rollback/pin/status matrix, and the Unit 1 cross-transport 12e red-signature check.
