---
task: work-loop-v2-readiness-handoff-race
turn: operator
---

## Outcome

Accepted. Work Loop v2 now reconciles an operator-claimed hand-off once before concluding that the durable hand-off is not visible. On a conflict between the operator's `y` / `ur turn` claim and visible repository state, the receiving actor checks the latest commit affecting that exact task file and rereads the file once immediately; if the sources converge it proceeds, and if they still do not converge it reports only the discrepancy and the resulting inability to assess. No actor may infer or state that the other has not completed its work without specific process evidence.

The semantic rule sits in `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` § 4 and the concrete Codex procedure in `.agents/skills/work-loop-v2/SKILL.md` § *The seam*, which defers to the core rather than restating it. The dead "with none, report the mismatch" clause — the exact licence the incident used — was removed. All six required outcomes are met without widening scope: no new state field, frontmatter key, artifact, watcher, courier behaviour, polling or delay was introduced, and shorthand still cannot override `turn:`.

## Decisions that matter

- The ambient `logs/friction-log.md` modification was deliberately excluded from this implementation. It is written by a hook that logs write activity, not by this unit, and the ambient-writer interaction is a known open item outside this scope.
- The guarded negative-control scratch worktree at `.../scratchpad/nc-wt` was deliberately excluded. Its cleanup is **deferred to the operator** because `check-destructive-liveness.sh` refused removal while the copied harness inside it remains uncommitted, and the guard cannot distinguish a scratch copy from a live session. `git worktree prune` clears the registration once the directory is gone. This residue does not limit the implemented behaviour.

## Evidence

Implementation commit `8a61a496` on `session/2026-08-14-work-loop-v2-fixes`, with the evidence pointer recorded at `0112e83e`. Focused `race` block (13 assertions) added to `logs/scripts/work-loop-v2-slice-1.test.sh`: red before at `passed: 348 failed: 10` against the pre-change core and skill, green after at `passed: 358 failed: 0`, exit `0`, against a pre-unit baseline of `passed: 345 failed: 0`. Diff limited to the core (+18), the Codex skill (+14/-1), the harness (+49) and this task file; `.claude/commands/work-loop-v2.md` was inspection-only and is unchanged. Rollback: `git revert 8a61a496` after integration.

## Accepted limitations

None.
