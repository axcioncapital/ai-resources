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

Standard. Implementation mode. Unit 2a — complete, validate and commit the preserved shared lease helper and its helper-level test only.

Named reason for the loop: the accepted repair spans shared process leasing, two transports, durable ownership, controller tests and authorized live validations; it requires multiple bounded units and independent assessment before it can support an integration decision.

## Brief

The original Unit 2 exceeded the 900-second actor limit and stopped with exit 21 before changing the dispatcher or task state. It left two allowed uncommitted partial files, `logs/scripts/work-loop-lease.sh` and `logs/scripts/work-loop-lease.test.sh`; the operator explicitly approved this smaller recovery unit on 2026-08-14. Preserve and finish that partial work rather than discarding it or rerunning the oversized extraction brief.

Governing sources and authority:

- Current operator decision: approve this narrowed recovery after the timeout; Phase 1 and its two bounded live validations remain approved, D4 retained and Phase 2 deferred.
- Approved implementation basis: `plans/work-loop-v2-v0.2/work-loop-v2-cross-transport-concurrency-and-task-aware-worktrees-implementation-proposal-2026-08-13.md`, especially §§ 4.1, 4.3, 4.5 and 5.4.
- Accepted Unit 1 evidence: commits `54d9db9c` and `b67f88d9`, with four intentionally red cross-transport cases.
- Stopped-hop evidence: courier exit 21 after 902 seconds; state byte-identical, HEAD unchanged at `b67f88d9`, and exactly the two helper files above recorded as attributable partial effects.

Required outcome: inspect the two preserved files as the starting point, complete any missing or incorrect helper behavior and helper-level protection, run the bounded evidence, and commit only those files plus this state file. Do not integrate the helper into the dispatcher or carrier in this recovery unit.

Claims to verify before editing:

1. Confirm both partial files still exist and record their current state before changing them. Do not replace them wholesale merely to restart the work.
2. Compare the helper's observable contract against the dispatcher's current inline lease behavior: Git-common-directory root and existing lock names; task-then-checkout acquisition; rollback after second-resource refusal; held versus pinned versus unreadable metadata; guarded partial pinning; pinned-beats-release; read-only status; and program metadata as the one approved additive field.
3. Confirm no dispatcher, carrier, Work Loop instruction or policy file changed during the timed-out hop.
4. Record `git status --short --untracked-files=all`. Preserve the pre-existing harness captures and ambient `logs/friction-log.md` change; do not stage, delete or commit them.

Required evidence:

- `bash -n` passes for the helper and its test.
- The helper-level suite exercises real concurrent shell processes and reports exact pass/fail totals.
- The two-resource contract is protected: simultaneous contenders admit exactly one; checkout refusal releases the newly acquired task lease; a third contender succeeds after rollback; pinning never claims an unowned resource.
- Proportionate surrounding behavior is protected: ordinary release removes both leases; held and pinned leases refuse; unreadable holder metadata refuses without deletion; status is read-only; holder program metadata is visible; direct execution of a source-only library refuses visibly.
- Falsifiability is demonstrated without destroying the preserved work: the suite's absent-library and naive-composite controls must show that the harness distinguishes no implementation and a plausible wrong implementation from the shared two-resource contract.
- If any helper test fails, diagnose and fix only the helper or helper test; do not cross into transport integration.
- Report the final diff. Confirm no dispatcher, carrier, instruction, core, policy or unrelated file changed.
- Stage only `logs/scripts/work-loop-lease.sh`, `logs/scripts/work-loop-lease.test.sh` and this state file by explicit pathspec. Report `git diff --cached --name-only` before committing and the final commit hash.

Compatibility constraints:

- Keep the existing dispatcher lock root and task/checkout lock names so in-flight or pinned dispatcher leases remain visible when integration happens later.
- Keep leasing separate from durable `.owner` semantics.
- The helper must not mutate Git, create semantic task state, or decide transport exit codes/messages.
- Do not add a service, database, daemon, registry, scheduler, new command or second state system.

Codex framing decisions:

- Dispatcher and carrier integration are both excluded from this recovery. Reason: the prior hop demonstrated that helper creation, dispatcher integration and their combined evidence do not fit safely inside one actor window.
- The absence of a preserved pre-edit red transcript is not repaired by deleting or reverting partial work. Reason: partial effects must be preserved. The executable absent-library and naive-implementation controls must instead demonstrate that the completed suite can fail and discriminates behavior.
- Unit 1's four cross-transport cases are not rerun here. Reason: neither transport changes, so their result cannot move.

Completion condition: the preserved shared helper and its test are complete, syntax-clean and green with falsifiable two-resource behavior evidence; only the helper, helper test and task state are committed; no transport or instruction file changed; unrelated work stayed untouched; and the state hands back at `turn: codex`.

Stop and hand back if the preserved helper requires a materially different architecture, cannot maintain the existing dispatcher lock identity, cannot be tested without changing a transport, or requires any file outside the two helper files and this state file.

## Latest result

Inspected (2026-08-14):

- Claim (1): HOLDS — `ls -l` and `wc -l` on `logs/scripts/work-loop-lease.sh` and `logs/scripts/work-loop-lease.test.sh`; both present and untracked at 276 and 471 lines, byte counts 12250 and 23170, matching the recorded stopped-hop state. Neither was replaced; both were read in full and kept.
- Claim (2): HOLDS — read the helper in full against `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` lines 610–745 (the `locks` block, `acquire_lock`, `pin_lock`, `release_lock`). Lock root identical (`git rev-parse --git-common-dir` → `work-loop-dispatch-locks`); lock names identical (`task-<sha256[1:16]>.lock`, `checkout-<sha256[1:16]>.lock`); task-then-checkout ordering identical; rollback guarded on the task-owned flag identical; held-versus-pinned decided by the same `survivors` file; unreadable metadata read via `cat … 2>/dev/null` and never deleted, identical; `pin` guarded on task-owned and copied into the checkout lease only when checkout-owned, identical; pinned-beats-owned checked inside release, identical; `program` is the only added field. Two intentional divergences recorded under Deferrals below.
- Claim (3): HOLDS — `git status --short --untracked-files=all` lists no dispatcher, carrier, Work Loop instruction, core or policy file; `git rev-parse HEAD` is `b67f88d9`, unchanged from the stopped hop.
- Claim (4): HOLDS — `git status --short --untracked-files=all` recorded: ` M logs/friction-log.md`, ` M logs/work-loop/work-loop-v2-cross-transport-concurrency-phase-1.md`, 14 untracked `logs/harness-runs/…` captures, and the two untracked helper files. The friction log and the harness captures were left unstaged, undeleted and uncommitted.

Result: the preserved shared lease helper and its helper-level suite are complete, syntax-clean and green. No behavior was missing: every contract point claim (2) enumerates is implemented and protected by a case that drives real concurrent shell processes. Neither preserved file was rewritten; no transport, instruction, core or policy file was touched, and no lease was created in this repository (the suite works only inside sandbox checkouts under `mktemp -d`).

Evidence:

- `bash -n logs/scripts/work-loop-lease.sh` and `bash -n logs/scripts/work-loop-lease.test.sh` both pass.
- `bash logs/scripts/work-loop-lease.test.sh` → `pass=50 fail=0`, exit 0. Eleven cases, all driving separate processes that source the library and take real leases; nothing greps the library's text.
- Two-resource contract: case 2 releases six barrier-synchronised contenders at once on one free (task, checkout) pair — exactly one acquired, five refused, none silent, and the winner's lease was gone on exit. Case 3 drives a second task into the same checkout — refused on the **checkout** lease, naming the holding task and program, with the newly taken task lease rolled back and the holder's own lease untouched. Case 4 then acquires that same rolled-back task cleanly, which is the run an orphan would have refused. Case 5 pins after a refusal — `rc=1`, `pinned=0`, no directory created, and the other run's checkout lease not pinned.
- Surrounding behavior: case 4 ordinary exit removes both leases; case 7 a pinned lease survives its own release call, refuses the next run with `refusal=pinned`, and hands back the survivors path; case 8 refuses on both an empty lease directory and a `chmod 000` pid file, deleting neither, with holder fields empty rather than invented; case 9 status over free and held leases exits 0, reports FREE/HELD, names the holding program, and creates not even the lease root; case 10 direct execution of the source-only library exits 64 saying it must be sourced.
- Falsifiability, demonstrated without touching the preserved work — four independent runs, two in-suite and two whole-suite via the `WL_LEASE_LIB` override:
  - in-suite case 0 (absent library): the contender cannot proceed, reports `LIB-UNREADABLE`, creates no lease.
  - in-suite case 0b (naive one-composite-key lease, no second resource, no rollback): the same two-contender scenario admits **both**, so the scenario discriminates a correct lease from a plausible wrong one.
  - whole suite pointed at a naive composite-key library: `pass=22 fail=28`, exit 1.
  - whole suite pointed at a nonexistent library path: `pass=12 fail=38`, exit 1.
- Final diff: `git status --short --untracked-files=all` after all runs is identical to the pre-work record above; `git rev-parse HEAD` still `b67f88d9` before the commit. Staged by explicit pathspec, `git diff --cached --name-only`: `logs/scripts/work-loop-lease.sh`, `logs/scripts/work-loop-lease.test.sh`, `logs/work-loop/work-loop-v2-cross-transport-concurrency-phase-1.md`. Commit `4ba60b09`.

Deferrals — recorded, not done, all for the integration unit:

- `wl_lease_pin` returns 1 when nothing was owned, where the dispatcher's `pin_lock` returns 0 in the same case. The library reports the verdict; the dispatcher's call site must not read 1 as an error at integration. Not changed here because changing either side is transport integration, which this recovery excludes.
- The library prints nothing, where `pin_lock` writes a line to stderr and `RUN_LOG`. The dispatcher keeps its own message at integration; the caller owns its wording and its exit codes by the library's stated contract.
- `logs/scripts/work-loop-lease.sh` is mode 644, not executable. Deliberate for a source-only library, and recorded so integration does not "repair" it.

## Blocker

None.

## Next action

Codex: assess the narrowed recovery. The preserved helper and its helper-level suite are complete, syntax-clean and green at 50/50, with two whole-suite falsifiability controls and the two in-suite controls all failing as required against no implementation and a plausible wrong one. Only the two helper files and this state file were committed; no transport, instruction, core or policy file changed, and the ambient friction-log edit and harness captures were left untouched. Three integration-facing deferrals are recorded above. Decide whether to accept and open the dispatcher-integration unit, or to correct once.
