---
task: work-loop-v2-compaction-survivability-repair
status: closed
turn: operator
---

## Outcome

A review-clean, deployment-ready Work Loop v2 instruction layer and a verified deployment map.
**Not** completed deployment and **not** completed operational proof — both were deliberately left
outside what this branch-bound task delivered.

Units 1–6 are accepted through commit `2e9952a`. The task established the Reorient compaction gate,
the validated `.owner` fallback, the compaction-protocol carve-out, one semantic owner for the routing
index, the precise Git mutation boundary, the actual one-repository/three-worktree topology of the
named project checkouts, the missing owner-helper blocker, the absent project-side recovery
deployment, and the aggregating behaviour of user-level and repository-level hooks.

## Decisions that matter

1. The operator approved the user-level compact-hook carrier, and only individually approved
   executable-core clauses govern. The draft core was neither approved nor rewritten by this task.
2. The operator approved closing this branch-bound task, promoting its committed work to
   `ai-resources/main` without pushing, and continuing installation plus the representative proof in a
   new main-bound Work Loop task. This state file must not be copied into main or concurrently
   reopened there.
3. All three named project checkouts remain intended deployment consumers, even though Unit 6
   established they are three worktrees of one repository rather than three projects. The scope is
   preserved rather than narrowed, because that was the operator's original approved target. Tracked
   fixes must reach their branches deliberately; untracked per-checkout links and settings do not
   travel by merge.
4. User-level and repository-level hooks aggregate. The later user-level compact registration must
   therefore replace or suppress the repository-level compact registration, so exactly one trigger
   stays effective; retaining both would double-fire in `ai-resources`. This settles the precedence
   question Unit 6 returned as unresolved.
5. The later deployment must include `logs/scripts/work-loop-owner.sh`. Without it the project-side
   Work Loop stops at Step 1.5, which Unit 6 verified is the current state of all three checkouts.

Deferred, with the reason: deployment, branch propagation, user-level settings, future `/new-project`
scaffolding and the representative project compaction proof are follow-on work in the new main-bound
task. This task was branch-bound, and installing from a branch the projects do not read would have
proved nothing.

## Evidence

Commits through `2e9952a` on `session/2026-08-13-compaction-survivability`, plus this closing commit.

Load-bearing results, each reproducible from those commits. The routing index has one semantic owner,
with index checks and a re-based 116-line ceiling bound to it while behaviour and frontmatter checks
stayed on `SKILL.md` (`a22b54b`). The focused Git-boundary check moved `6/6` to `12/0` and failed in
both directions, including on a copy that removed the overbroad wording but dropped the mutation
boundary (`891a991`). Resolver parity held at `4 passed, 0 failed` on every unit that touched
`SKILL.md`, confirming the protected marked block was never disturbed. The acceptance harness ended at
`passed: 293 failed: 2`. The Unit 6 deployment map recorded the worktree topology, the hand-made
undeclared skill links and the absent prune pass that preserves them, the absent `~/.codex/hooks.json`,
the stable carrier path, and the missing owner helper (`2e9952a`).

The hook-precedence question was settled outside the repository, because official documentation does
not specify it: an isolated, non-model temporary-home query against the installed Codex `hooks/list`
interface returned both matching entries as enabled — the synthetic user `SessionStart`/`compact` hook
at display order 0 and the repository `SessionStart`/`compact` hook at display order 6.

## Accepted limitations

- Deployment, branch propagation, user-level settings, future scaffolding and the representative
  compaction proof are not completed here. They are required follow-on work, not optional polish.
- This branch's corrections are not yet on `ai-resources/main`, so nothing the project checkouts read
  reflects Units 4 and 5 until the approved promotion happens.
- The acceptance harness retains the same two pre-existing `3.1a` failures it carried before this task.
- Non-blocking deferrals remain open: the transport guards' overbroad diagnostic text in
  `carry-turn.sh` and `dispatch.sh`; historical records retaining the old wording; no permanent
  Git-boundary wording assertion in the harness; whole-skill growth and the absence of a `SKILL.md`
  line ceiling; the hook-pointer duplication concern; and the project `.codex` hooks that reference a
  directory which does not exist and therefore fail silently.
