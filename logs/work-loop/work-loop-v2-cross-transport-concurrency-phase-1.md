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

Standard. Discovery mode. Unit 10 — retry the genuine cross-transport contention proof (proposal case 23).

Named reason for the loop: the accepted repair spans shared process leasing, two transports, durable ownership, controller tests and authorized live validations; it requires multiple bounded units and independent assessment before it can support an integration decision.

## Brief

The implementation and controller gates are accepted. Proposal §7 step 5 now requires one genuine carrier-versus-dispatcher contention proof before case 24. This is being run interactively from the VS Code Claude session: no dispatcher or carrier is carrying the Work Loop turn; those programs appear only as the live subjects being validated.

Governing authority: the operator-approved Phase 1 proposal §5 case 23 and §7 step 5. The required observable outcome is that a real attended carrier hop holds the shared lease, a real unattended dispatcher attempt for the same task/repository loses with exit 17, the refusal names the attended holder and is durably recorded under the requested log directory, and the losing dispatcher launches no actor.

Check against the repository before acting: verify this exact worktree and task binding; verify no transport run or lease is currently in flight; verify HEAD contains `40bb184e` and the accepted Unit 9r3 handoff; inspect the preserved failed case-23 evidence so the retry uses a new evidence directory and does not repeat its missing-log mistake. Treat the earlier live attempt as historical evidence, not as a successful case.

Scope: one live case-23 retry, its evidence under `logs/harness-runs/`, and this state file. No source or test edits. Excluded: repairs, controller-suite reruns, case 24, Phase 2, main checkout, push, cleanup, and any use of the dispatcher as the Work Loop courier.

Required evidence: exact carrier and dispatcher invocations; both exit codes; the durable losing-dispatcher log path and its human refusal plus machine-readable terminal record; proof the dispatcher launched no actor; the holder label shown to the loser; final lease status; and the commit containing only the state-file handoff. Keep repository facts separate from actor claims.

Stop and hand back without retrying if safe orchestration would require an unsupported nested actor, if either transport cannot complete, if the loser does not exit 17, if durable evidence is absent, or if any source/test edit appears. Preserve partial evidence.

Completion condition: case 23 is either proven once with all required live evidence and returns at `turn: codex`, or it returns a precise blocker without repair or repetition.

## Latest result

Unit 10 did not run case 23. It stopped at the brief's own stop clause — "safe orchestration would require an unsupported nested actor" — before creating a worktree, a scratch task file or a lease, and before launching either transport. Nothing was launched and nothing outside this state file changed.

Inspected (2026-08-14), all read-only, the brief's four pre-flight checks first:

- Worktree and task binding: HOLDS — `git rev-parse --show-toplevel` is `.../ai-resources-concurrency-fix-2`; `work-loop-owner.sh check --depth repo` returns PROCEED, "this checkout already declares task 'work-loop-v2-cross-transport-concurrency-phase-1'".
- Nothing in flight: HOLDS — `dispatch.sh --status` reports `checkout-lock: free` and `run: none in flight` against the shared lease root `.../ai-resources/.git/work-loop-dispatch-locks/`; `ps -ax` matched no `dispatch.sh`, `carry` or `carrier` process.
- HEAD: HOLDS — HEAD is `5bd3226b` (the Unit 9r3 handoff) and `git merge-base --is-ancestor 40bb184e HEAD` succeeds, so the implementation commit is contained.
- Preserved case-23 evidence: HOLDS — `ls -d logs/harness-runs/case23-live-dispatcher` returns "No such file or directory". The directory's absence *is* the preserved failure, so a retry cannot reuse it; a new evidence directory was reserved at `logs/harness-runs/unit10-case23-preflight/`.

Blocking finding, established by inspection of the two transports rather than by argument:

1. A real carrier hop cannot hold the lease without launching a real AI process. `scripts/axcion-harness-v0.2/carry-turn.sh` line 348 refuses `--actor-cmd`, `--simulate` and `--fake-actor` with "there is no simulated-actor seam on this surface, so no run of it can report simulated transport as live". Proposal §7 names that absence as a boundary whose loss is a *stop* condition, so it is not mine to work around.
2. `--dry-run` is not a hold. `acquire_lock` runs at `carry-turn.sh` line 1456 and the dry-run branch at line 1550 prints, calls `release_lock` and exits — the lease is held for milliseconds, not for the window a contending dispatcher needs.
3. The carrier hop cannot use a scratch task in this checkout. `work-loop-owner.sh check --task case23-live-holder --depth repo` returns **REFUSE, exit 3**: "this checkout is claimed by open task 'work-loop-v2-cross-transport-concurrency-phase-1'". That is Phase 1 working as designed, so the holder hop needs a separate checkout, and the carrier must therefore carry either this task (recursion — its actor would be handed this same open Unit 10) or a scratch task in a temporary worktree.
4. Either way the carrier's actor would be a `claude` process launched by this Claude session. This session is top-level and attended — parent is the VS Code extension binary, not a transport, and its argv carries no `--disallowedTools` — so nothing *mechanically* stops it. What stops it is the design: `carry-turn.sh` lines 84–100 and `dispatch.sh` lines 328–357 apply the four `Bash(claude:*) / Bash(codex:*)` deny rules to every hop precisely so "one attended hop stays one attended hop", and record that "the only demonstrated use of nested AI invocation in the whole evidence set is the 2026-08-10 failure this exists to prevent". Producing this project's cross-transport proof by the one orchestration the project forbids would be evidence Codex would have to discount.

Evidence: `logs/harness-runs/unit10-case23-preflight/preflight.out` — the read-only status and the ownership refusal above, captured verbatim. The status output ends "status is read-only. It launched nothing and wrote nothing." `git status --porcelain` shows no change to any source, test or transport file.

The supported orchestration, for Codex to reframe against, not applied here: case 23 needs **two top-level launchers**, which is the shape the first attempt used ("the attended carrier held the leases while Codex separately launched the dispatcher", autonomy report line 128). Concretely — the operator runs `carry-turn.sh` for a scratch task in a temporary linked worktree from their own terminal; that hop takes the task and checkout leases; this session then runs `dispatch.sh` for the *same scratch task* from this checkout, which must lose on the **task** lease at exit 17 across two checkouts. The defect that killed the first attempt is already fixed and no longer needs a waiting actor: the loser's own durable run log under its `--log-dir` (Unit 9r2, Case 12h) is the artifact, and `dispatch.sh --status` is a deterministic marker for when the holder actually holds.

Carried forward: live case 23 remains unaccepted; case 24 remains unrun; `LOCK_KEY` being unassigned in `dispatch.sh` remains a pre-existing deferral outside this unit.

## Blocker

Unit 10 cannot be completed from this session alone. Every route to a real carrier hop holding the shared lease requires this Claude session to launch a `claude` actor — the nested-actor shape both transports' mandatory deny sets exist to prevent — because the carrier has no simulated-actor seam, `--dry-run` does not hold the lease, and ownership admission refuses a second task in this checkout. A second top-level launcher (the operator, or Codex) is the missing piece, not a repair to any file.

## Next action

Codex: reframe Unit 10 around two top-level launchers, or send it to the operator. The decision needed is who launches the holding carrier hop — this session cannot without nesting an actor under itself. If the reframe stands, name the scratch task id, the temporary worktree, and which side runs which transport.
