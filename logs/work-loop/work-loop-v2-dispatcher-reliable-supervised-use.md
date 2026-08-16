---
task: work-loop-v2-dispatcher-reliable-supervised-use
status: active
turn: codex
---

## Objective and scope

Implement `plans/work-loop-v2-v0.2/work-loop-v2-dispatcher-reliable-supervised-use-implementation-plan-v0.1.md` through its complete Gate SA acceptance contract and independent adoption review, while preserving the plan's fixed supervised-use boundary.

Scope: the existing Work Loop v2 supervised dispatcher, its accepted helpers and runtime surfaces, focused proof, live trials, and the synchronous regression gate named by the plan. Excluded throughout: Gate ST, Gate U, unattended or walk-away release claims, dispatcher rewrite or language migration, merge, push, deployment, destructive cleanup, and every other exclusion in plan §§ 4 and 7.

Task exit condition: one integrated candidate has passed Gate SA and the independent review has returned `ADOPT`, or Patrik has explicitly chosen `SHRINK` or `STOP`.

## Lane and unit

Standard. Implementation mode. Unit 0 — bind and prove the activation baseline.

Named reason for the loop: the objective spans multiple bounded implementation and proof units, must survive session boundaries, and requires independent Codex assessment before it can count as complete.

## Brief

The target plan is still explicitly `PROVISIONAL` and forbids dispatcher implementation until its post-merge activation contract is satisfied. This unit exists now because the durable-state work appears to have landed, but the exact integrated base, regression proof, concurrency catch-up, and accepted T7 boundary must be verified and recorded before Patrik can approve the plan against identifiable content. Produce an activation-ready plan and no dispatcher change.

Required outcome: verify every activation prerequisite in plan § 3 against repository reality, run the required integrated-baseline evidence, and update only the plan's activation/status material so it records the exact integrated base and the truthful evidence disposition. The result must remain visibly awaiting Patrik's content-bound approval; do not claim that this unit or today's request approved the plan, and do not begin Change set A.

Authority and source disposition:

- The operator's current instruction authorizes starting this Work Loop task and preparing the activation gate. It does not, by itself, establish content-bound approval of the provisional plan.
- `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` is the canonical Work Loop contract.
- `plans/work-loop-v2-v0.2/work-loop-v2-dispatcher-reliable-supervised-use-implementation-plan-v0.1.md` is the operator-designated target and the controlling object for this unit, but remains non-governing for dispatcher implementation until its own § 3 activation and approval conditions are satisfied.
- `logs/work-loop/work-loop-v2-durable-state-system.md` and `logs/work-loop/autonomy-authority-capability.md` are authoritative closed-state evidence for the durable-state and accepted T7 boundaries. Their claims must still be checked against the integrated Git history before being recorded in the plan.
- The two source documents named in plan § 2 remain historical rationale, not independent implementation authorities.

Check against the repository before changing the plan:

1. Verify the exact current `HEAD`, prove the durable-state integration commit is its ancestor, and identify the exact commit that should bind activation. The currently observed values `HEAD=698383207208dbfccf04672a8263bbc55d001abf` and durable-state merge `00855ec6` are verify-first claims, not facts to copy blindly.
2. Verify the durable-state task is validly closed and committed, and that the integrated checkout contains one canonical validator, owner helper, shared lease helper, Work Loop command/skill/core, and attended carrier at their accepted locations.
3. Identify and run the integrated baseline's required state, owner, lease, capability, command, carrier, and dispatcher regression suites. Report exact commands, host context, exit status, and pass/fail counts; skipped or sandbox-distorted evidence must not be recorded as passed.
4. Establish the baseline catch-up result for the genuine two-task/two-linked-worktree case. Cite the exact executable case and result if it is already part of a suite; otherwise run the smallest existing accepted case that settles the gap. Do not create a second concurrency harness.
5. Re-derive the accepted autonomy-authority T7 boundary from the closed task and Git history: T7 implemented, T8/T9 removed from that task's completion bar and not run, with the recorded limitations preserved. Do not imply that the removed scenario or organic-task programmes passed.
6. Verify that the target plan currently lacks an exact integrated-base record and remains provisional. After the edit, demonstrate from the plan file itself that it is bound to exact content and unmistakably awaiting operator approval rather than claiming activation.

Codex framing decision: this unit is limited to activation evidence and the minimum plan update because dispatcher code would be unauthorized before the operator gate. Any baseline repair, plan scope change, Change set A implementation, new report, or convenience harness is deliberately held outside this unit.

Required evidence must be fail-capable and include:

- exact pre-unit and final commit identifiers and the committed path list;
- the merge-ancestry and closed-state checks;
- exact regression commands with exit codes and pass/fail counts;
- the identified two-task/two-worktree case and its result;
- the T7/T8/T9 evidence with cited commits or durable records;
- a check of the committed plan showing the exact baseline binding and approval-waiting status; and
- a committed-path comparison proving no dispatcher, helper, runtime, or unrelated plan file changed in this unit.

Capability subset: baseline only — read, search, inspect Git history, run local tests, edit only this task state file and the target plan, and make the local handback commit. The baseline deny set is required in full. Nothing is selected from the pre-authorizable set, which is empty today. No operator-reserved capability is needed.

Completion condition: the plan is activation-ready against a verified exact baseline, all § 3 prerequisite and catch-up evidence is truthfully recorded or cited, no dispatcher implementation has begun, and Claude commits the update and hands back to Codex for assessment.

Stop and hand back without repairing or widening the unit if any prerequisite fails, the integrated baseline contradicts a load-bearing plan premise, a required suite or catch-up case cannot be established, the update would materially change scope or Gate SA, or any file beyond the task state and target plan would need a deliberate change. Challenge a false premise rather than improvising past it.

## Latest result

Inspected (2026-08-16):

- Claim (1): HOLDS — `git rev-parse HEAD` returns `698383207208dbfccf04672a8263bbc55d001abf`, matching the brief's verify-first value. `git merge-base --is-ancestor 00855ec6 HEAD` exits 0, so the durable-state merge is a true ancestor. `git rev-parse main` and `git rev-parse origin/main` both return the same `69838320`, so the integrated base is on `main` and pushed; branch `session/2026-08-16-dispatcher-last-fixes` points at the identical commit.
- Claim (2): HOLDS for presence and location — validator `logs/scripts/work-loop-state.sh`, owner helper `logs/scripts/work-loop-owner.sh`, shared lease helper `logs/scripts/work-loop-lease.sh`, capability helper `logs/scripts/work-loop-capability.sh`, command `.claude/commands/work-loop-v2.md`, skill `.agents/skills/work-loop-v2/SKILL.md`, core `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`, carrier `scripts/axcion-harness-v0.2/carry-turn.sh`. Each is a regular file, not a symlink; `git ls-files` shows exactly one copy of each at its accepted location, the only second copies being the deliberate template copies under `workflows/research-workflow/`. `work-loop-state.sh validate --task work-loop-v2-durable-state-system` prints `CLOSED` (exit 0), and that record is committed at `a97624a8`, an ancestor of HEAD. **Read this as location and singularity only — claim (3) shows the command and skill are content-regressed at this same base.**
- Claim (3): **FALSE** — two of the seven required suites are red at this baseline. Full run below.
- Claim (4): HOLDS — the genuine two-task/two-linked-worktree case already exists as an accepted executable case and passes; no second harness was created. `logs/scripts/work-loop-v2-tracer-7.test.sh` scenario 2 ("two concurrent worktrees with different tasks proceed; non-owner replicas refuse", file lines 391–456) drives `work-loop-owner.sh --depth repo` over two real linked worktrees simultaneously through a rendezvous gate. All 8 assertions pass, including the simultaneity proof and both negative controls (an undeclared-worktree replica refuses naming the owning checkout; a replica in a beta-leased checkout refuses naming beta, not alpha).
- Claim (5): HOLDS — searched `logs/work-loop/autonomy-authority-capability.md` (`status: closed`, validator-independent read) and confirmed each cited commit exists and is an ancestor of HEAD. T7 landed at `48cca1c01adbeb07470e480d74d427ae5de3331c`. T8/T9 were **removed from the completion bar, not met**: the record states zero of T8's twelve rows carry a verdict and zero organic tasks were recorded under T9, via the operator's 2026-08-15 scope decision at `ff3175cd5123dd2195cc7e80b2487ba3849e57a1`, with the status announcement at `7dceb727`. The four accepted limitations are preserved verbatim in that record, including "T7 requests; it does not enforce" and the open residual asymmetry at `dispatch.sh:2115`.
- Claim (6): HOLDS (first half) — searched the target plan for any 7–40 character hex commit token: no match anywhere in the file, so it records no integrated base. Line 4 still reads `**Status:** PROVISIONAL — scoped plan for operator approval after the durable-state branch is accepted and merged.` The second half ("after the edit, demonstrate...") was **not reached**: claim (3) failed, so no edit was made.

Result: Unit 0 stopped at the premise check and made **no change to the target plan**. The activation gate cannot be bound to this baseline, because two plan § 3 prerequisites fail against it. The plan remains `PROVISIONAL`, records no integrated base, and is unmistakably still awaiting Patrik's content-bound approval — unchanged from its pre-unit state.

Evidence — regression run, host and commands exact. Host: macOS 26.5.2 (Darwin 25.5.0, arm64), GNU bash 3.2.57(1)-release. All run from `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-dispatcher-last-fixes` at HEAD `69838320`, working tree otherwise clean. No sandbox distortion and no skipped suite: every command below ran to completion and returned its own counts.

| Required suite | Command | Exit | Result |
|---|---|---|---|
| state | `bash logs/scripts/work-loop-state.test.sh` | 0 | 100 passed / 0 failed |
| owner | `bash logs/scripts/work-loop-owner.test.sh` | 0 | 133 / 0 |
| lease | `bash logs/scripts/work-loop-lease.test.sh` | 0 | 136 / 0 |
| capability | `bash logs/scripts/work-loop-capability.test.sh` | **1** | **76 / 1** |
| command/skill/core | `bash logs/scripts/work-loop-v2-slice-1.test.sh` | **1** | **315 / 44** |
| command/skill/core (resolver) | `bash logs/scripts/work-loop-v2-core-resolver.test.sh` | 0 | 4 / 0 |
| carrier | `bash scripts/axcion-harness-v0.2/carry-turn.test.sh` | 0 | 457 / 0 |
| dispatcher | `bash plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` | 0 | 639 / 0 |
| durable-state tracer 6 | `bash logs/scripts/work-loop-v2-tracer-6.test.sh` | 0 | 74 / 0 |
| durable-state tracer 7 | `bash logs/scripts/work-loop-v2-tracer-7.test.sh` | 0 | 120 / 0 |

The evidence is fail-capable: eight suites at this same baseline returned green with their own counts, and the two red suites name specific assertions that pass elsewhere, so the reds are discriminating rather than a blanket failure.

**Root cause of the 44 command/skill/core failures — the merge itself, established by blob identity rather than inference.** Merge `00855ec6` recorded conflicts in six files. For three of them the resolution took the durable-state parent's blob **verbatim and discarded the main side**:

- `.agents/skills/work-loop-v2/SKILL.md` — merge blob `c21ad238` is byte-identical to parent 2 `39b6e0a1` and differs from parent 1 `4ba2ff0e` (`e8fbbe65`).
- `.agents/skills/work-loop-v2/references/routing-index.md` — same pattern.
- `.claude/commands/work-loop-v2.md` — same pattern.
- (`logs/session-notes-archive-2026-08.md` also took the durable-state side; `logs/friction-log.md` and `logs/improvement-log.md` genuinely blended.)

`git diff --stat 4ba2ff0e 00855ec6` over those three files shows 165 insertions / 190 deletions. The discarded main-side commits include `16de1622` ("Work Loop v2 unit packaging and hop termination — 2026-08-14 incident") and `8a61a496` ("...unit 1 reconciles a claimed hand-off once before concluding absence, harness 345/0 to 358/0 green"). Those two map exactly onto the failing clusters:

- **`pack` — 35 failures.** The four packaging lines (`Dominant deliverable:`, `Evidence required in this hop:`, `Evidence explicitly deferred:`, `Primary edit begins after:`) and the hop-termination contract. Probe: each string returns 1 hit in `4ba2ff0e:SKILL.md` and 0 in HEAD.
- **`race` — 6 failures.** The bounded reconciliation procedure (`reconcile once before reporting anything`, `owns the rule; this is the procedure`, `I cannot assess it until those sources converge`, `evidence about visibility, not about Claude`, `never overrides the state file`, `brief names and task ids and ask which one`). Every one returns 1 hit in `4ba2ff0e:SKILL.md` and 0 in HEAD.

The test file `logs/scripts/work-loop-v2-slice-1.test.sh` merged **cleanly** (blob `ee89d18f`, distinct from both parents), so it still asserts both contracts against instruction files that no longer carry them. The 358/0 figure in `8a61a496`'s own message is the pre-merge green this baseline regressed from.

- **`mode` — 3 failures, different cause, not merge damage.** `LIVE_TASK_F` at line 1375 still points at `logs/work-loop/work-loop-v2-durable-state-system.md`, which is now closed and reduced to its four closing headings, so `## Lane and unit` is absent and the assertions read an empty string. The test's own comment at lines 1368–1374 predicts this exact failure and names repointing as the fix. Honest red, stale pointer, no lost content.

**Capability failure — 1 assertion, separate defect.** `B5 the template's logs/scripts/work-loop-owner.sh is byte-identical to canonical` fails. Canonical `logs/scripts/work-loop-owner.sh` (612 lines, last changed at `b81a1b58`, the Tracer 8 correction) carries the unestablished-worktree fail-safe: a registered worktree that cannot be entered yields `AMBIGUOUS` rather than being skipped. The template copy `workflows/research-workflow/logs/scripts/work-loop-owner.sh` (531 lines, last changed at `96ff6786`, Tracer 6) still carries the old fail-open `[ -d "$wt" ] || continue`. Consequence: a project deployed from this template gets the ownership fail-open that Tracer 8 removed. The template's `work-loop-state.sh` and `work-loop-reorient.sh` copies are byte-identical, so this is one drifted file, not a stale template generally.

Committed in this unit: `logs/work-loop/work-loop-v2-dispatcher-reliable-supervised-use.md` only — previously untracked, now added. `git diff` against the target plan and against every dispatcher, helper and runtime file is empty; no Change set A work began.

Deferrals noticed and deliberately not done (recorded, not implemented): repointing `LIVE_TASK_F` to the current open Standard record; resyncing the template owner helper; restoring the discarded main-side content. All three are repairs, which this unit's stop condition forbids.

## Blocker

Two plan § 3 activation prerequisites fail against the integrated baseline `69838320`, so the activation gate cannot be bound to it.

1. **§ 3 item 4 — "The integrated baseline passes its required state, owner, lease, capability, command, carrier, and dispatcher regression suites."** It does not. The command/skill/core suite is 315/44 and the capability suite is 76/1. Plan § 3 forbids treating skipped or failing evidence as passed, so no truthful activation record can be written at this base.

2. **§ 3 item 2's load-bearing premise is contradicted.** The premise is that the durable-state branch was "integrated with `main` through the repository's approved merge process." The integration completed, but its conflict resolution discarded accepted main-side Work Loop contract content in three files, verified by blob identity above. The Work Loop command and skill named in § 3 item 3 are present at their accepted locations but content-regressed relative to the pre-merge main side. This is a defect in the integrated base itself, not in the plan's design.

Nothing was repaired and the plan was not edited, per the brief's stop condition. Dispatcher implementation remains gated.

## Next action

Codex: decide how the activation baseline is repaired before Unit 0 can be re-run. The three candidate routes, none of them chosen here:

1. Restore the discarded main-side content into the three files on a new commit, re-run the command/skill/core suite to green, and bind activation to that new commit — leaving `69838320` recorded as the defective intermediate.
2. Re-do the integration from `4ba2ff0e` and `39b6e0a1` with a correct conflict resolution, and bind activation to the result.
3. Reframe: establish whether any discarded main-side content was superseded on purpose by the durable-state branch, in which case the slice-1 assertions — not the instruction files — are what must change.

Also decide, as part of that scope: whether the template owner-helper resync and the `LIVE_TASK_F` repoint belong in the same repair unit or in their own. Both are one-file changes with named consequences.

Whichever route is chosen, the operator's content-bound approval of the plan still has to follow the repair, against the exact commit that finally passes the § 3 suites.
