---
task: axcion-harness-v0-2-live-trial
status: closed
turn: operator
---

## Outcome

The canonical Axcíon Harness v0.2 launcher was proven in one real attended fresh-process carry inside
the operator-prepared isolated checkout. `scripts/axcion-harness-v0.2/carry-turn.sh` launched one
fresh authenticated Claude process for this exact checkout and task, that process reconstructed the
unit from this state file and the durable sources it cites without any transcript being ferried in,
made a state-file-only change under `--permission-mode default` with no authentication, permission or
runtime prompt, and returned one valid `claude -> codex` handback. The carrier accepted the single
transition, exited `code=0`, observed one new commit confined to the two disclosed allowed paths, and
emitted one terminal result. Codex accepts Unit 5 and judges the project plan's Phase 2 attended
vertical-slice exit met.

## Decisions that matter

- This closes only the attended Phase 2 MVP cut line. It does **not** authorize unattended operation,
  integration into `main`, push, or removal of the worktree.
- The second `--allow-path` for the hook-owned `logs/friction-log.md` was a per-unit invocation
  decision, not a durable default. The hook's write-activity appends were expected, disclosed, and
  left dirty and uncommitted.
- Unit 4's finding held: the residual false-stop risk was invocation policy, not a carrier or hook
  defect. No launcher, hook, test, plan or semantic source was modified at any point in the task.
- No deferral was discovered at closure.

## Evidence

Final commit: `3c7e3a20b0be529cd931c86a8b7d00dfff312b55` — "work-loop: axcion-harness-v0.2 live trial
Unit 5 — attended fresh-process live handback, LIVE HANDBACK COMPLETE", carrying Unit 5's full
six-claim inspection record and its fail-capable evidence. That record is recoverable with
`git show 3c7e3a2:logs/work-loop/axcion-harness-v0-2-live-trial.md`, and its `--name-only` list is the
check that would expose any second committed path. The parent carrier's argv, allow paths, pre/post
guards, accepted transition and terminal result are evidenced separately by its run log under
`/private/tmp/axcion-harness-v0.2-isolated-trial`.

## Accepted limitations

- The absence of hidden transcript ferrying is supported by fresh-process ancestry, complete child
  argv, and durable-source reconstruction observations rather than proved as an absolute negative — a
  child process cannot prove that negative about its own instantiation.
- The parent carrier's repository facts are evidenced by its run log rather than observable from
  inside the child, which exits before the carrier emits its final `RESULT` line.
