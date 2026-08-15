---
task: cross-transport-concurrency-correction
turn: codex
---

## Objective and scope

Correct the reviewed Phase 1 concurrency findings, leave an accurate closing record, complete one final independent Standards and Spec review, and reach an honest merge decision under `plans/work-loop-v2-v0.2/work-loop-v2-cross-transport-concurrency-correction-plan-2026-08-14.md` as bound at `f2b19b5d80a061111c39cc7444f90f6374f19d38`.

The operator decided on 2026-08-15 to skip live case 24 because the required second-worktree orchestration costs more operator time than is available. This supersedes the plan's case-24 completion requirement for this task only and must be recorded as an accepted limitation; the branch must not claim that the plan's original done definition was fully met. Excluded remains: Phase 2, product worktree automation, scheduler, registry, service, new state store or command surface, unrelated `LOCK_KEY` work, unrelated cleanup, push, and any attempt to reconstruct or simulate case 24.

## Lane and unit

Standard. Implementation mode. Unit 10 — update the existing Phase 1 closing record to match the completed correction evidence and the operator's case-24 decision. Delivered; awaiting assessment.

Named reason for the loop: this multi-unit correction must retain independent assessment before merge, and the closing record is the durable evidence source that review will inspect.

## Brief

This is the last repository-writing unit before independent review. Update only `logs/work-loop/work-loop-v2-cross-transport-concurrency-phase-1.md` and this state handback so the closing record says exactly what was proved, what was skipped, and what risk remains. Do not implement, rerun, redesign, create another report, create a worktree, launch a transport, merge, or push.

Governing authority is the correction plan at `f2b19b5d80a061111c39cc7444f90f6374f19d38`, except that the operator's 2026-08-15 decision above supersedes its requirement to execute case 24. Verify all repository claims below before writing; if any accepted evidence cannot be substantiated from the named commits, state file history, existing run evidence, or current filesystem, stop and hand back rather than smoothing over it.

Required outcome:

- Replace stale suite totals and diff statistics with the accepted measured results: syntax exit 0; lease `127/0`; owner `92/0`; carrier `423/0`; dispatcher `632/0`; `git diff --check` exit 0.
- Record the accepted correction commits: Unit 1 `fee4fe49`, `ca35371c`, `57f3b25b`; Unit 2 `2d58991d` and `bc979e8d`; Unit 3 `cda44c50`; Unit 4 `8e4261f0`; Unit 5 `81644987` and `d22978ad`; Unit 6 `a3096a21`; verification `faccb92b`; live case 23 `8f43438c`.
- Record case 23 completely and accurately: a real attended carrier held both leases; the losing dispatcher exited 17 before actor launch; the refusal named the carrier; durable evidence was written under the Git common lease root with `actor_launched=no`; the losing checkout was unchanged; and the carrier's work and leases were undisturbed and released normally.
- State plainly that case 24 was not executed. Controller case 12 covers different tasks in different worktrees, but there is no post-fix live proof of two real concurrent Work Loop tasks completing later handoffs in isolated linked worktrees. Record the operator's time-based decision and the residual risk without calling the original done definition complete.
- State accurately that carrier and dispatcher enforcement is exit-code-borne, while interactive same-task enforcement remains instruction-borne.
- Retain only limitations still true: mutually uninspectable live reclaimers fail closed; `wl_lease_status` calls a provably dead holder `HELD`; the old-marker transition remains until old formats disappear; inability to run `ps -g` pins rather than releases; an unwritable shared lease root leaves refusal evidence terminal-only; refusal records have no pruning and case 23 created the first live record; unassigned `LOCK_KEY` remains excluded; carrier fallback wording retains contextual `another`; dispatcher `STALE LOCK` wording says a dispatcher died; callers must canonicalize checkout paths although both shipped callers do; one load-sensitive carrier-suite timeout occurred before later clean runs; case 24 remains unexecuted.
- Remove limitations that the implemented corrections resolved. Identify untracked harness evidence as non-durable and put the durable conclusions in the closing record itself.

Evidence must include the closing-record diff or exact changed sections, `git diff --check`, confirmation that no production, test, executable-core, Phase 2, or unrelated file changed in this unit, and the commit containing both the updated closing record and this handback. Documentation-only work has no meaningful failing-first test; do not invent one or rerun the four already accepted suites.

Completion condition: the existing closing record is accurate, self-contained, candid about skipped case 24, and ready for the independent Standards and Spec review. Set `turn: codex`, commit only the closing record and this state file, and stop.

## Latest result

Inspected (2026-08-15). Every claim the brief asked to substantiate was checked before the record was written; none failed, so nothing was handed back.

- All twelve named correction commits are ancestors of HEAD, verified individually with `git merge-base --is-ancestor`: `fee4fe49`, `ca35371c`, `57f3b25b`, `2d58991d`, `bc979e8d`, `cda44c50`, `8e4261f0`, `81644987`, `d22978ad`, `a3096a21`, `faccb92b`, `8f43438c`. The route unit's two commits `11cb60ba` and `1c65deca` are also on branch and are recorded alongside them.
- The suite totals the brief supplies match what was measured and committed at Unit 7 (`faccb92b`), which this session ran itself from `c29cac8a`: syntax exit 0; lease `127/0`; owner `92/0`; carrier `423/0`; dispatcher `632/0`; `git diff --check` exit 0.
- Case 23's facts are substantiated from the durable artifact, not from the state file alone. The refusal record still exists at `<git-common-dir>/work-loop-dispatch-locks/refusals/20260815T154142-30771-cross-transport-concurrency-correction.refusal`, and its contents carry `holder_program=carry`, `holder_pid=27235`, `code=17`, `resource=task` and `actor_launched=no`, naming the attended carrier. `git status --porcelain -uall` in the main checkout shows no such path, confirming it is outside every working tree.
- Case 24 has no live evidence anywhere, which is what the record must say. No witness worktree exists, no witness task file exists, and no second transport was ever launched.
- The record's stale figures were measured rather than assumed. Against merge-base `212fa918`: **15 files changed, 6358 insertions, 259 deletions** — the record previously said twelve files, +4044 / −278. `.agents/skills/work-loop-v2/SKILL.md` is 4 insertions and 2 deletions, so its "6 lines changed" claim held and was kept as an exact numstat.
- `logs/harness-runs/` is untracked (`git ls-files` returns nothing for it) and **not** gitignored (`git check-ignore` returns nothing), so the record's non-durability claim is accurate as written.

Result: `logs/work-loop/work-loop-v2-cross-transport-concurrency-phase-1.md` now states what was proved, what was skipped, and what risk remains. Six substantive changes, not a refresh of numbers:

1. **The Outcome opens by saying the plan's Done definition is not fully met.** Previously it claimed readiness for an operator decision without qualification.
2. **Case 23's acceptance is no longer composite.** The old record accepted it on a pre-fix live run plus a post-fix logging proof plus a regression gate, and listed "not repeated end-to-end after the logging fix" as an accepted limitation. Unit 8 produced the single unbroken post-fix run, so that limitation is **removed** and the decision rewritten to the seven steps in one observation.
3. **The case-24 decision is recorded as the operator's, dated 2026-08-15, on time grounds** — and explicitly not as a route that was unsafe or unsupported, since a compliant route exists and is recorded. It states that it supersedes the plan's requirement for this task only.
4. **The enforcement sentence is corrected.** The old text said "only the dispatcher's is exit-code-borne"; after this correction the carrier's is too, and only the interactive same-task case remains instruction-borne.
5. **Non-durable evidence is named and its conclusions lifted into the record.** The refusal record's two lines are quoted in full rather than cited by path, and the `/tmp` captures are stated as gone.
6. **The limitations list is rebuilt to fourteen entries** — the eleven the brief names as still true, plus the case-23 one removed as resolved, plus the two pre-existing entries that remain accurate.

Evidence:

- Changed files, this unit: exactly two — `logs/work-loop/work-loop-v2-cross-transport-concurrency-phase-1.md` (72 insertions, 28 deletions) and this state file. `git status --porcelain` shows nothing else beyond the operator-owned `logs/friction-log.md` and untracked `logs/harness-runs/`, neither staged nor committed.
- No production, test, executable-core, Phase 2 or unrelated file changed. The two paths above are the whole change set, and neither is a script, a suite, `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`, nor any `audits/risk-checks/*phase-2*` record.
- `git diff --check` exit 0.
- Evidence shape, stated plainly: this is a documentation unit, so there is no failing case to build first and no automated check that would distinguish success from failure — a grep for words the brief already supplied would pass whatever the record said. The fail-capable part is the substantiation above: each figure and claim was read from the repository, and three of them came back **different from what the record already said** (file count, insertions, deletions), which is what a check that could only confirm would never have produced. The four accepted suites were not rerun, as the brief required.
- Rollback: `git checkout <this-commit>^ -- logs/work-loop/work-loop-v2-cross-transport-concurrency-phase-1.md`, or revert the commit. No behaviour can be affected either way.

Deviation: none. Nothing outside the two authorized files was touched, no transport was launched, no worktree created, and no attempt was made to reconstruct case 24.

## Blocker

None.

## Next action

Codex: assess Unit 10 — is the closing record accurate, self-contained and candid about the skipped case 24, and does it avoid claiming the plan's original Done definition was met. If it passes, the remaining work on this task is the one final independent Standards and Spec review and the merge decision; merge and push both stay outside this task and outside this session.
