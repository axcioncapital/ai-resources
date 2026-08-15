---
task: axcion-harness-v0-2-go-live
status: closed
turn: operator
---

## Outcome

Axcíon Harness v0.2 is **live for normal attended pilot use** — one checkout, one writer. The
canonical carrier `scripts/axcion-harness-v0.2/carry-turn.sh` is now the route the live Work Loop v2
instructions select for an attended carry, it carries exactly one explicit hop per invocation, and the
unattended path remains separately and visibly bound to the spike dispatcher.

Two units delivered it. Unit 1 changed the live Codex Work Loop skill so attended courier use selects
the canonical carrier with exact checkout and task inputs and a task-derived allow-path policy, in
place of the spike dispatcher no instruction had replaced. Unit 2 inspected the accepted evidence and
returned the lifecycle decision: adopt for normal attended pilot use.

Final Phase 3 adoption is **not** claimed and remains open, pending the governing plan's three-to-five
representative tasks and its later adopt / shrink / stop decision.

## Decisions that matter

- **This is a release decision, not the adoption decision.** `plans/axcion-harness-v0.2/mvp-plan.md`
  keeps the Phase 3 bar unchanged: three to five representative tasks showing correct work sooner,
  with less manual transport and no loss of control. One task of that set exists today.
- **What this verdict does not authorize.** Unattended execution, concurrent or multi-writer use,
  cross-worktree task claims, automatic worktree creation, automatic landing or merge, `git push`,
  multi-hop or automatic hop chaining, and final Phase 3 adopted status. None of these may inherit
  this acceptance.
- **Deferral — the `logs/innovation-registry.md` ambient writer.** The user-level `PostToolUse` hook
  `.claude/hooks/detect-innovation.sh` appends to that tracked file whenever a `.claude/commands`,
  `.claude/agents` or `.claude/hooks` file is edited, and the documented allow-path set omits it, so a
  future command-editing pilot unit can stop safely at exit `18` before launching. Recorded as a
  deferral rather than a blocker because the failure changes nothing and the stop message names its
  own remedy. Reason it was not fixed here: it fell outside the Adoption-mode discovery unit's scope,
  which permitted no edit beyond this state file. Smallest repair is one documented allow-path line
  (`^logs/innovation-registry\.md$`), routed as small Direct Work before the first such pilot task or
  when that safe stop is first observed. Already logged pending at `logs/improvement-log.md`.
- **Deferral — the stale-session-marker staging tripwire.** `check-foreign-staging.sh` has blocked a
  direct-route `/work-loop-v2` commit against stale markers before; two stale markers are on disk now,
  yet both commits in this task passed the guard untouched. Recorded as a safe, visible and
  intermittent operational limitation — under the carrier a refused child commit surfaces as exit `25`
  — and explicitly not as evidence of corruption.
- **Unit 1's route change was verified by an evidence check that could fail**, and Unit 2 was an
  inspection that changed nothing. Neither unit needed a correction round.

## Evidence

- `828a73d` — Unit 1: the live skill's attended courier route moved to the canonical carrier. Its
  route check reported 3 passed / 6 failed against the pre-change file at `HEAD` and 9 passed / 0
  failed against the changed file, with both unattended-preservation assertions passing either way.
  `work-loop-v2-core-resolver.test.sh` 4/0 and `work-loop-v2-slice-1.test.sh` 292 passed / 3 failed
  before and after — the same three pre-existing failures, none introduced here.
- `4c45978` — Unit 2: the Adoption-mode discovery record, its lifecycle recommendation, the
  operational boundary, and the disposition of all three Unit 1 deferrals.
- `3c7e3a2` — the accepted live-trial evidence: one fresh authenticated Claude process launched by the
  canonical carrier, reconstructing its unit from the state file and durable sources with no
  transcript ferried in, a state-file-only change under `--permission-mode default`, one valid
  `claude -> codex` handback, carrier exit `code=0`, and exactly one operator action — the foreground
  launch — with no prompt of any kind.
- Recorded and cited rather than rerun: the carrier's deterministic suite at 98/0 with five
  fail-capability mutants (`logs/work-loop/axcion-harness-v0-2-attended-release.md`).

## Accepted limitations

- **The pilot configuration is proven by design and by dry run, not yet by a live carry.** The one
  successful live carry ran in an isolated checkout with its run log outside the repository; the pilot
  is the canonical checkout with the in-repo default log dir, and the single attempt here stopped at
  `18` on ambient dirt. Accepted because the untested element fails as a pre-launch refusal: nothing
  starts and nothing changes.
- **Untracked `logs/harness-runs/` accumulation.** Inside the documented allow-path, so it causes no
  stop; it grows one run log per carry as untracked repository noise. Nonblocking. Revisit before final
  adoption — either gitignore it, or point `--log-dir` outside the repository as the live trial did.
- **No carrier-level cross-worktree ownership check.** `work-loop-owner` appears 0 times in
  `carry-turn.sh` and 5 times in the spike dispatcher. In the pilot, enforcement rests on interactive
  Codex claiming the local checkout and Claude's `--depth repo` check at task entry. Nonblocking **only**
  for single-checkout, single-writer attended use, and it must be closed before any wider ownership or
  concurrency claim.
- **No permanent route-selection regression check.** The route is one instruction string; a regression
  would send an attended carry to the spike dispatcher, which is visible in the command the operator
  runs and does not corrupt work. Nonblocking. Revisit before final adoption, or sooner if the
  courier section is edited again.
