---
task: work-loop-v2-durable-state-system
status: active
turn: codex
---

## Objective and scope

Implement the frozen Work Loop v2 durable-state plan sequentially until the accepted state system is demonstrated end to end and ready for the operator's landing decision.

Scope is the capabilities, migration order, eight tracer bullets, assessment gates, and completion proof in `plans/work-loop-v2-v0.2/work-loop-v2-durable-state-system-implementation-plan-v0.1.md`. The plan's explicit exclusions remain excluded; repository evidence may challenge a factual premise or expose a safety contradiction, but may not silently redesign the accepted architecture.

## Lane and unit

Standard. Implementation mode. Unit 9 — Tracer bullet 7: prove checkout binding, migration, and live concurrency.

Named reason for the loop: this is the next ordered slice of the frozen multi-unit migration; it must combine the explicit-status/task-only-owner system with the already accepted shared-lease work and independently assess the resulting ownership, migration, and concurrency proof before final end-to-end demonstration.

## Brief

Unit 8 / Tracer bullet 6 is accepted after its one correction: all nine deterministic lifecycle and recovery scenarios now pass, including fail-closed ownership for a complete but uncommitted closing reduction. Tracer bullet 7 is next because the frozen plan now requires the combined checkout-binding, explicit-migration, and live-actor-exclusion outcomes before final cutover readiness can be demonstrated.

**Required outcome:** Produce one coherent, fail-capable operational proof of all nine ownership, migration, and concurrency scenarios assigned to Tracer bullet 7. Import the accepted Phase 1 evidence where its seam remains applicable after the durable-state cutover, and narrowly refresh only evidence whose seam materially changed.

**Governing authority and source disposition:**

- The frozen implementation plan governs: Fixed decisions 2, 3, 6–11, and 13–15; Capabilities B, D, and E; Tracer bullet 7; its Proof Matrix assignments; and Execution and Assessment Rules.
- The closed Phase 1 record `logs/work-loop/work-loop-v2-cross-transport-concurrency-phase-1.md` is authoritative implementation evidence for the accepted shared-lease controller and its live case 23, including its recorded operator decision and limitations. It does not by itself prove applicability after the explicit-status/task-only-owner cutover; verify that against the current seams.
- The current executable core, validator, owner helper, Reorient, attended carrier, unattended dispatcher, and shared lease helper govern their own runtime contracts. Reuse them; add no fallback lifecycle parser, duplicate lease helper, second state store, automatic ambiguity resolver, or general test framework.
- Admissions remain paused. Tracer bullet 8, final independent assessment, closure of this implementation task, merge, push, landing, and production adoption are adjacent work deliberately held outside this unit because the frozen plan assigns them later.

**Verify first against the repository:**

1. Reconfirm the exact checkout/task, HEAD `83745c35`, `ACTIVE_CLAUDE`, unique repository-depth ownership, complete readiness, and free shared leases. Stop on ambiguity, a competing actor, or a different HEAD.
2. Establish the exact integrated Phase 1 commits and live evidence from `logs/work-loop/work-loop-v2-cross-transport-concurrency-phase-1.md`, the shared refusal record it names if still present, `logs/scripts/work-loop-lease.sh` and its test, and the current carrier/dispatcher implementations and tests. For each imported claim, state why the durable-state cutover did or did not change the covered seam; do not rerun accepted live evidence merely to obtain a new count.
3. Bound the current combined-proof inventory to `logs/scripts/work-loop-state.sh`, `logs/scripts/work-loop-owner.sh`, `.agents/skills/reorient/SKILL.md`, `.claude/commands/work-loop-v2.md`, the shared lease helper, both couriers and their existing tests, the Tracer 6 harness, and any existing migration fixtures directly cited by those surfaces. For each Tracer 7 scenario, identify the existing evidence and the precise composing/live gap. Any absence claim must name this searched surface and pattern.
4. Verify whether each required live observation can be produced through existing top-level transport or non-model fixture seams without launching Claude or Codex from inside the current Claude hop. Nested model invocation is unsupported and prohibited; if a required outcome genuinely needs operator-coordinated top-level actors or another capability not available in this unit, return the exact gap rather than simulating or weakening the scenario.

**Scenarios required by the frozen plan:**

1. Stale owner: committed `CLOSED` clears; missing, malformed, active, blocked, and complete-but-uncommitted closed targets do not.
2. Two concurrent worktrees with different tasks proceed, while non-owner replicas refuse.
3. Multiple owner claims and multiple unowned open copies both fail closed.
4. Two actors attempt the same task and exactly one task lease succeeds.
5. Attended/unattended collision contends through the same task and checkout leases.
6. Explicit task migration ends with exactly one owner; an injected interruption leaves visible fail-closed ambiguity.
7. A bounded fresh-session live recovery reconstructs the same status, turn, latest result, blocker, and next action.
8. A bounded live compaction/Reorient recovery proves that empty or misleading conversational state cannot override durable state and returns the same validator classification.
9. A bounded cross-courier live proof preserves state and partial-effect evidence.

Each scenario must carry a negative control or deliberately injected failure that distinguishes the accepted outcome from the wrong one. Imported Phase 1 evidence may satisfy a scenario only when the current seam is unchanged and that applicability is itself shown; otherwise run the narrow affected proof.

**Implementation boundary:** Add only the smallest existing-style composing proof or failpoint needed for gaps that remain after import. Temporary repositories/worktrees and bounded live local processes are permitted by the frozen plan. Do not create one framework per scenario, invoke nested models, broaden actor permissions, implement Phase 2 worktree automation, permit concurrent writing of one task, add automatic ambiguity resolution or cleanup, or run a soak test. Leave hook-written `logs/friction-log.md` and `logs/innovation-registry.md` uncommitted and outside the commit.

**Required evidence:**

- Give an exact scenario-by-scenario report: real seam, imported/new evidence, applicability argument, setup or failpoint, negative control, observed classifications/exits/lease or owner state, and verdict.
- For scenarios 2–5 and 9, identify the simultaneous processes/transports and show the decisive task and checkout lease observations, actor-launch result, preserved state, and partial-effect evidence. A sequential approximation is not a live concurrency proof.
- For scenario 6, show the owner set before, during the injected interruption, and after successful migration, including the fail-closed ambiguous state and final unique owner.
- For scenarios 7 and 8, show field-level equality for status, turn, latest result, blocker, and next action plus validator classification; distinguish durable observations from conversational/model claims.
- Report which Phase 1 cases were imported without rerun, which seams required narrow refresh, and why. Report exact focused-proof and directly affected regression counts/exits, the implementation commit, and exact changed paths.
- Demonstrate that Tracer 8, Phase 2, excluded machinery, runtime redesign unrelated to a revealed defect, friction log, and innovation registry did not enter the commit, and that the handback validates `ACTIVE_CODEX`.

**Completion condition:** Commit the bounded Tracer 7 proof and return all nine scenario verdicts with applicable Phase 1 evidence accounted for, `status: active`, and `turn: codex`. State whether a runtime defect or unsupported live-proof gap was exposed; confirm admissions remain paused, nothing was merged, pushed, or landed, and Tracer bullet 8 has not started.

**Stop conditions:** Stop and hand back exact evidence if a load-bearing premise is false; an imported Phase 1 claim is no longer applicable; a required scenario lacks a real seam, simultaneous observation, or fail-capable discriminator; a live result would require nested model invocation or unavailable operator coordination; producing the proof requires an excluded mechanism, operator-reserved capability, runtime redesign outside this unit, or broader scope; or any expected outcome is red.

Capability subset: baseline only — read and inspect repository state/history, run local tests and bounded local processes, create temporary repositories/worktrees, edit task-scoped proof/test surfaces, and make the local coherent commit. Nothing is selected from the pre-authorizable set, which is empty today. No operator-reserved capability is needed; if the live proof requires one, stop rather than assume it.

## Latest result

Correction round on the one frozen finding. Reproduced first, by inspection: `logs/scripts/work-loop-v2-tracer-7.test.sh` at the pre-correction commit `c650d2a1` built scenario 6's target by writing the record uncommitted (`open_record "$S6W1" s6-task active claude nocommit`) and then `cp`-ing the live file across. That is the excluded act named in the frozen plan's exceptional-migration sentence, and it sat on the accepted path rather than on an injected failure. Finding 1 reproduces.

**Finding 1 — resolved.** Scenario 6 now runs the frozen sequence, and reproducing the finding exposed that the earlier proof was weaker than it looked in a second way, corrected here as well.

- **Commit and validate the source state.** The record is committed on the source worktree's own branch, and committedness is asserted from Git rather than assumed: reachable from the source `HEAD`, with `git status --porcelain` empty for that path, and the validator returning `ACTIVE_CLAUDE`.
- **Validate the target checkout and repository-depth ownership.** Before the move the target holds no record at all — absent from its `HEAD` and absent from its working tree — and `work-loop-owner.sh check --depth repo` from the target returns `REFUSE` naming the source.
- **The durable record moves through Git, and is never copied.** The record's own commit is cherry-picked onto the target branch and then removed from the source branch by `git rm` plus a commit. Nothing copies a live state file anywhere in scenario 6; `grep` over the scenario's line range returns no `cp` and no `nocommit`.
- **Transfer the owner under the ownership mutation guard.** The declaration moves by the shipped helper's own `clear` and `claim`, which take the mutation lock internally. No `.owner` is written by hand on the accepted path.
- **Verify exactly one bound checkout.** After the transfer: `src=(none) dst=s6-task`, target `PROCEED`, source `REFUSE`, the target's committed blob byte-identical to the one validated in step 1 (`da58339d…`), the source no longer storing the record, and the migrated record still validating `ACTIVE_CLAUDE`.
- **The interruption stays fail closed, and is now the realistic one.** The injected crash lands between the two halves of the Git move — the record committed onto the target branch, not yet removed from the source — with the declaration already released. Both checkouts then read `AMBIGUOUS` at exit 4, the reason names `replicated copies authorise nobody`, and a `claim` from the target is refused and writes nothing. The second cut point, two declarations, still reads `AMBIGUOUS` naming the double claim.

The second weakness the reproduction exposed, and why the fix is inside finding 1 rather than a new one: the old "completed migration" claimed from a target that was **already declaring the task** (leftover from the cut-point-B fixture), so it never exercised a claim by an undeclared target and could not have failed if claiming were broken. Correcting the setup made that visible immediately — the first corrected draft went red at exactly that assertion, because a record present in both checkouts with no declaration is `AMBIGUOUS` by design and a target cannot claim its way out of it. That is the helper behaving correctly; the proof's model of migration was wrong. Both halves of the frozen finding — start from committed validated state, end with exactly one owner — are only satisfied once the record itself moves.

**Did the correction break something?** No. Two harness faults were found and fixed inside the correction, both mine and neither a product fault: `git cherry-pick` takes no `-q` flag, so the transfer silently failed and cascaded through eleven downstream assertions; and `git rm` of the last record removes the now-empty `logs/work-loop/` directory, so the fixture helper now creates it before writing a declaration. No runtime file was changed by this correction — the only changed path is the harness.

Evidence: `bash logs/scripts/work-loop-v2-tracer-7.test.sh` → **exit 0, 120 passed, 0 failed**, twice consecutively (up from 106 assertions at `c650d2a1`; the 14 new ones are all in scenario 6). Scenario verdicts: S1–S9 all PASS. The failing-first control still discriminates: `WL_OWNER_BIN` pointed at the pre-correction owner helper from `96ff6786^` gives **exit 1, 118 passed, 2 failed**, and the two failures are exactly S1's complete-but-uncommitted-closure row — every other assertion, scenario 6's twenty-seven included, passes against the older build. Directly affected regressions, all exit 0: owner **122/0**, state **100/0**, Tracer 6 **74/0**. The wider set (lease, carrier, dispatcher, capability, slice 1, session preflight, core resolver) was not re-run and does not need to be: the correction changed one test file and no runtime file, so those suites' inputs are byte-identical to the run recorded at `c650d2a1`, where they were 136/0, 457/0, 639/0, 77/0, 308/0, 60/0 and 4/0. `bash -n` exits 0.

Scope: the two remaining `cp` calls of a state record in the harness are in scenarios 2 and 3, where a replica is the deliberately wrong condition that must be refused — not an accepted migration path. Finding 1 named scenario 6's accepted path, so they are left as they are, stated rather than silently kept.

Newly noticed, recorded as deferrals and not implemented:

1. The owner helper has no migration verb, so an explicit migration is an operator-run sequence of `clear`, a Git move, and `claim`, with a real window in which the task is `AMBIGUOUS` everywhere. That is fail-closed and correct, but there is no single guarded operation for it and no written runbook in the repository. Worth considering at Tracer 8 or after landing; out of this frozen scope.
2. Carried from Unit 9's first pass: when a task's record is replicated into a checkout already leased by a different task, the refusal names the occupying task rather than the checkout where the replicated task lives. Behaviour is right; only the message is less helpful.
3. Carried from Unit 8, unchanged: `work-loop-owner.sh clear --task {holder}` still does not test whether the closing record is committed.

Correction commit `1223fda5`, exactly two paths: `logs/scripts/work-loop-v2-tracer-7.test.sh` and `logs/work-loop/work-loop-v2-durable-state-system.md`. No runtime file, no Tracer 8 surface, no Phase 2 file, no excluded machinery, and neither hook-written log entered it. Admissions remain paused; nothing merged, pushed or landed; Tracer bullet 8 has not started.

## Blocker

None.

## Next action

Codex: run the closure check on the frozen findings only — is finding 1 resolved, and did the correction break something? Nothing else re-opens this unit; the three items recorded above are deferrals, not a second correction round. Then close the unit or use the menu.
