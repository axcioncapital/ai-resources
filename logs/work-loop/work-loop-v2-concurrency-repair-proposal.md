---
task: work-loop-v2-concurrency-repair-proposal
turn: claude
---

## Objective and scope

Create one opinionated implementation proposal for the remaining Work Loop v2 concurrency gaps, stating what should change in the attended harness, unattended dispatcher, Work Loop command/resources, and task-aware worktree entry path.

Scope: current Work Loop v2 ownership and transport surfaces; the attended carrier; the unattended dispatcher; their tests; the existing worktree-session command; and the directly relevant current-state records. Deliverable: `plans/work-loop-v2-v0.2/work-loop-v2-cross-transport-concurrency-and-task-aware-worktrees-implementation-proposal-2026-08-13.md`.

Excluded: implementing any fix; changing scripts, commands, skills, tests, hooks or policy; automatic merge, landing, cleanup or deletion; and solving repository-wide concurrency for sessions that are not using Work Loop v2.

## Lane and unit

Standard. Implementation mode. Unit 1 — write the implementation proposal.

Named reason for the loop: the proposal crosses two transport programs, durable ownership, Work Loop instructions and worktree entry; its scope must remain bounded and its repository claims must be independently checked before the document counts as a reliable implementation basis.

## Brief

This proposal is needed now because the August 8 dispatcher gaps were implemented, but the current attended and unattended transport paths do not yet present one structural concurrency guarantee, while worktree creation remains a residual manual step. It should give the operator a small, sequenced repair plan without reopening the settled one-task/one-state-file architecture or automating landing judgment.

Required outcome: write a self-contained, plain-language implementation proposal that answers, with a firm recommendation, what should be fixed now and what should wait. The proposal must be detailed enough for a later implementation unit to execute, but it must not implement or authorize the changes itself.

Governing and contextual sources:

- Current operator direction: produce this implementation proposal and seriously evaluate a narrow, task-aware automatic-worktree experiment. This authorizes a proposal, not implementation or a change to settled operating policy.
- Governing Work Loop behavior: `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`, especially roles, Direct-versus-Standard admission, courier boundaries, one-task/one-state-file semantics and hard-to-reverse operator decisions. Treat only separately approved amendments as approved where the file says the whole core remains draft.
- Current deployed behavior: `.agents/skills/work-loop-v2/SKILL.md`, `.claude/commands/work-loop-v2.md`, `logs/scripts/work-loop-owner.sh`, `scripts/axcion-harness-v0.2/carry-turn.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, and `.claude/commands/new-worktree-session.md`.
- Authoritative current state for the landed concurrency work: `logs/work-loop/work-loop-v2-concurrent-task-isolation.md` and `logs/work-loop/work-loop-v2-production-readiness-policy.md`.
- Settled current policy to preserve unless the operator explicitly changes it: D4 in `logs/work-loop/work-loop-v2-production-readiness-policy.md` says a dispatched run may not create its own worktree and the operator creates it at the file-ownership gate. The proposal must present Phase 2 as a proposed policy change, explain the conflict, and make approval of that change an operator decision before implementation.
- Non-governing background: `plans/axcion-harness-v0.2/task-scoped-concurrency-investigation-2026-08-08.md`. It motivates the investigation but does not override current implementation or settled decisions.

Claims to check against the repository before writing:

1. In `dispatch.sh`, inspect the lock-root and acquisition sections and establish whether unattended dispatcher instances share repository+task and physical-checkout leases through the Git common directory.
2. In `carry-turn.sh` and `carry-turn.test.sh`, inspect the live-lock key and the linked-worktree case and establish whether the attended carrier uses only a checkout-keyed temporary lock and deliberately admits the same task in another linked worktree.
3. Search `carry-turn.sh` for `work-loop-owner` and ownership exit handling, and compare with `dispatch.sh`, to establish whether the carrier performs the durable repo-depth ownership admission before actor launch. Bound the absence claim to those files and patterns.
4. Compare the carrier and dispatcher lock roots and metadata. Establish whether a carrier and dispatcher can observe and refuse each other's live lease, rather than inferring from the fact that each has a lock of its own.
5. In the Work Loop Codex skill, Claude command and owner helper, establish exactly which interactive duplicate shapes are structurally refused, which are instruction-borne, and which remain expressly unprevented.
6. In `.claude/commands/new-worktree-session.md`, establish the current operator steps, creation behavior, existing-worktree behavior and product/session-attachment limit. Do not describe worktree creation or reuse as automatic if the command still requires the operator to invoke or enter the new session.
7. In the two current-state records, establish what is implemented, what remains awaiting operational validation, and which human-controlled worktree-creation, landing and cleanup decisions are settled. Quote D4's current boundary and distinguish describing a possible replacement policy from treating that replacement as already approved.

Codex framing proposal, explicitly non-governing until the evidence supports it: recommend one shared live-lease contract used by both transport programs, with repository+task and physical-checkout identities, one lock root, compatible liveness/pinning/status behavior, and fail-closed repo-depth ownership admission before either program launches an actor. Recommend freezing cross-transport failure cases before changing code. Treat task-aware automatic worktree creation/reuse as a conditional second phase after that safety boundary and one genuine fan-out-two validation: it would require the operator to approve replacing D4's current operator-created-worktree policy, and should extend the existing worktree path rather than build a scheduler, registry or manager platform. Claude may challenge or revise this recommendation where a checked premise is false, but must explain the evidence rather than silently substituting a different problem.

The proposal must contain:

1. Executive decision: the smallest recommended architecture and why the fix belongs primarily in the harness/transport layer, with only necessary Work Loop instruction changes.
2. Current-state matrix: fixed, partial and unfixed guarantees, separated by unattended dispatcher, attended carrier, interactive Work Loop and worktree entry.
3. Failure model: same logical task across worktrees; different tasks in one checkout; carrier-versus-dispatcher contention; durable ownership versus live-process leasing; and the bounded interactive limitation.
4. Phase 1 implementation design: behavioral contract, candidate file-level change map, lease acquisition/release/pinning/status behavior, exit-code compatibility, migration constraints and explicit non-goals. Prefer reuse or extraction of existing mechanisms over parallel reimplementation, but leave the final code shape to the implementation unit.
5. Failing-first acceptance matrix covering at minimum carrier+carrier, dispatcher+dispatcher and carrier+dispatcher combinations for same-task/same-checkout, same-task/different-worktree and different-task/same-checkout cases; legitimate different-task/different-worktree concurrency; release; pinned state; unavailable ownership helper; and status visibility. Include the two-resource acquisition races: concurrent contenders, failure after acquiring the first lease, rollback without an orphan first lease, and pin behavior when only one resource has been acquired. Distinguish simulated controller evidence from genuine actor evidence.
6. Phase 2 task-aware worktree experiment: explicitly present it as a proposed change to D4 requiring operator approval; give deterministic create-versus-reuse rules, ambiguity and dirty-base stops, what can be automated without hidden judgment, the current session-attachment limit, and the operator decisions that remain. Worktree selection or creation for a new task must finish before its state file and `.owner` declaration are created. An open task may resume only in the checkout already bound by its existing state file; automation must never copy that file between checkouts, infer a replacement binding, or create a second semantic binding.
7. Rollout and validation sequence: failing tests, narrow implementation, existing suites, one cross-transport proof, one genuine fan-out-two Work Loop pair, then the worktree experiment. Give explicit adopt/revise/stop criteria.
8. Risks, rollback and compatibility: existing open tasks, older worktrees lacking helpers, stale/pinned locks, differing temporary roots, interrupted actors, task-state replicas, manual editors and interactions with current exit codes.
9. Deferred and rejected work: general session manager, repo-wide lease database, automatic priority/scope decisions, automatic merge/landing/conflict resolution, automatic destructive cleanup, and the separate workspace-wide non-Work-Loop concurrency problem.
10. Operator decisions: a short list of only the genuine authority or risk choices required before implementation, including whether to retain D4 or approve the narrowly defined Phase 2 replacement policy.

Framing decisions added by Codex:

- This is one proposal document, not implementation plus proposal. Reason: implementation would outrun the requested decision artifact and mix design approval with execution.
- The first repair target is shared structural enforcement across the two existing transport programs; automatic worktrees follow as a separate phase. Reason: automating task placement before the transports share one safety boundary would scale the remaining race.
- Workspace-wide concurrency outside Work Loop is recorded as adjacent work and excluded. Reason: Work Loop task ownership should not quietly become a global session manager.
- Final landing, conflict resolution and destructive cleanup remain human-controlled. Reason: this preserves the operator's stated judgment boundary and current policy.

Required evidence:

- Cite file/line evidence for every current-behavior claim in the proposal.
- Report the searched file/pattern surface for every absence claim.
- Record `git status --short --untracked-files=all` before writing so pre-existing unrelated paths are distinguishable from this unit's effects. Before the single commit, stage only this state file and the requested proposal by explicit pathspec, report `git diff --cached --name-only`, and confirm that staged list contains exactly those two paths. Do not use `git diff --name-only` alone: it omits untracked files and can falsely report an empty change set. The resulting commit path list is a repository fact for Codex to inspect during assessment, not evidence that must be written back into the already-committed state file.
- Explain why a permanent executable regression test is not meaningful for the documentation-only unit; verification here is that every required section exists, every recommendation traces to current evidence, exclusions remain excluded, and no implementation file changed.

Completion condition: the proposal exists at the named path, covers all ten required sections, clearly distinguishes repository fact from proposal, is actionable without being an implementation, and is committed with this state file handed back at `turn: codex` for assessment.

Stop and hand back if a load-bearing concurrency premise is false, if producing an honest proposal requires reopening a settled operator decision, or if the work would need to modify anything beyond the proposal and this state file.

## Latest result

Not started.

## Blocker

None.

## Next action

Claude: verify the marked claims, write and commit the bounded implementation proposal if they hold, then hand back with the evidence above. Do not implement any recommendation.
