---
task: work-loop-v2-post-compaction-recovery-repair
status: active
turn: codex
---

## Objective and scope

Implement the post-compaction recovery repair plan, including the operator-approved Amendment 1 whose exact content is recorded at commit `a366c295`: preserve the Work Loop contract while preventing unnecessary immediate context refill after compaction, restoring the `$realign` / `$reorient` boundary, making active-state result rollover reliable, and proving the repaired behavior.

Scope is Units 0–4 and the completion condition in `plans/work-loop-v2-v0.2/work-loop-v2-post-compaction-recovery-repair-implementation-plan-v0.1.md`. Preserve its exclusions: do not split the executable core; add no model default, hook, parser, state field, registry, cache, summary file, recovery daemon, universal state-size gate, provisional 12/16 KB launch policy, or unrelated optimization; do not change Work Loop roles, lifecycle, admission, courier permissions, or dispatcher exit codes.

## Lane and unit

Standard. Implementation mode. Unit 0 — restore the lost Work Loop behavior.

Unit 1 was implemented at `66688592` but not accepted because the required Slice 1 suite remained red. Unit 0 is the operator-approved prerequisite; Unit 1 returns for assessment after Unit 0 restores the green baseline.

Named reason for the loop: the repair spans multiple bounded implementation and proof units, must survive hand-offs, and requires assessment independent of the implementer before it counts as complete.

## Brief

Unit 0 restores previously implemented Work Loop behavior that disappeared in a merge, because Units 2–4 must not build recovery changes on a known-incomplete contract. It is the bounded prerequisite approved in Amendment 1; it does not relax Unit 1’s acceptance condition or begin the post-compaction behavior changes.

Required outcome: restore the packaging, hop-termination, and hand-off-reconciliation rules under their correct post-split semantic owners; correct the stale live-task test pointer if the reported cause holds; return `logs/scripts/work-loop-v2-slice-1.test.sh` and the resolver suite to exit 0; preserve Unit 1’s progressive-disclosure structure; record current evidence in plan §8; and commit the unit once.

Governing authority: the operator explicitly approved Amendment 1 in this conversation, binding approval to the amendment content at `a366c295`. Plan §4 Unit 0, §§5–9, the canonical executable core, and repository `AGENTS.md` govern. The Unit 1 result at `66688592` is verified repository background, not an accepted unit and not permission to weaken a failing check.

Check these repository claims before editing; a false claim is a valid hand-back:

1. Inspect commits `16de1622`, `8a61a496`, and merge `9b1c19d3` against the current files. Verify exactly which `pack` and `race` rules were present, which disappeared at the merge, and whether the reported recoverable deltas—41 skill-side lines and 53 command-side lines—describe the behavior rather than incidental formatting. Do not perform a blind revert.
2. Inspect all currently failing `pack` assertions in `logs/scripts/work-loop-v2-slice-1.test.sh`. Verify the reported split between assertions reading the Codex skill and the 14 reading `.claude/commands/work-loop-v2.md`, and verify that the command currently lacks the packaging / `## Ending the hop` contract those checks require.
3. Derive each restored rule’s present semantic owner from the post-Unit-1 structure and the core: packaging and sizing detail is expected to belong in `references/unit-framing.md`; hand-off reconciliation is expected to belong in the main skill’s seam; Claude-side execution instructions belong in `.claude/commands/work-loop-v2.md`. Confirm this mapping and preserve one owner rather than copying old text into obsolete locations.
4. Inspect the three failing `mode` assertions and `LIVE_TASK_F` near the current test comment. Verify whether they fail only because the pointer names a closed task with no active `## Lane and unit`, and whether this task’s active Standard record is the correct current pointer. If the failures instead expose missing behavior, stop and hand back rather than disguising them with a pointer change.

Implementation requirements:

- Capture a failing-first baseline from the current artifacts, identifying the failing assertion families and exit code before restoration. Existing fail-capable assertions may supply the red case; do not add ceremonial duplicate tests.
- Restore the smallest semantically complete rule set supported by the historical and current authorities. Merge with judgment into the post-split owners; do not revert the progressive-disclosure split or restore superseded structure and wording blindly.
- Repoint only the single `LIVE_TASK_F` line if claim 4 holds. Do not weaken, delete, skip, or rewrite mode assertions to make them pass.
- Keep the main Work Loop skill below 500 lines and 5,000 words, retain all direct-reference/read-condition/one-owner/table-of-contents guards, and keep resolver parity intact.
- Run `work-loop-v2-slice-1.test.sh` and `work-loop-v2-core-resolver.test.sh` to green. Also run the proportionate existing state/preflight/Tracer 7 checks affected by the restored seam and command behavior.
- Update only plan §8’s Unit 0 evidence entry and any strictly necessary approval metadata correction. Record exact commands, exit codes, restored rule ownership, and final main-skill counts. Do not reinterpret an acceptance condition.

Codex framing decision: edits are limited to `.agents/skills/work-loop-v2/SKILL.md`, `.agents/skills/work-loop-v2/references/unit-framing.md`, `.claude/commands/work-loop-v2.md`, the single `LIVE_TASK_F` pointer in `logs/scripts/work-loop-v2-slice-1.test.sh`, plan §8’s Unit 0 evidence entry, this state file, and incidental repository telemetry written by existing hooks. The reason is to restore the known baseline without absorbing Unit 2’s recovery-boundary work. Hold all other references, `$realign`, `$reorient`, the executable core, deployment code, and Units 2–4 outside this unit.

Capability subset: baseline only—read/search/history inspection, local tests, task-scoped edits, and a local commit by Claude. Nothing is selected from the pre-authorizable set, which is empty today. No operator-reserved capability is needed. Do not push, merge, deploy, access credentials, destructively alter shared state, or invoke nested Claude/Codex actors.

Required evidence must be able to fail: baseline output naming the red families; green Slice 1 and resolver outputs with exit 0; affected regression outputs; exact historical/current evidence for the restored behavior; proof of the mode pointer cause rather than mere disappearance of failures; one-owner placement for each restored rule; and final skill line/word counts plus Unit 1 structural guards. A grep that only finds wording introduced by this brief is not sufficient.

Completion condition: the approved Unit 0 behavior is restored under current owners; every previously reported Slice 1 failure is resolved without weakening an assertion; Slice 1 and resolver suites exit 0; affected regressions remain green; plan §8 records the evidence; all task-scoped changes are committed once by Claude; and this state file holds the current result only with `status: active` and `turn: codex` for assessment.

Stop and hand back if a load-bearing historical claim is false; the missing behavior cannot be restored without changing canonical core semantics, Work Loop roles, or another excluded surface; the mode failures are not explained by the stale pointer; a green suite would require weakening a check; or the required evidence cannot be produced.

## Latest result

Unit 0 did not begin. The four claims were inspected against the live repository; the unit is handed back on a conflict inside the brief itself, not on a false historical premise. No file the brief named was changed — `git diff` across `SKILL.md`, `references/unit-framing.md`, `.claude/commands/work-loop-v2.md`, `work-loop-v2-slice-1.test.sh` and plan §8 is empty.

Baseline captured before inspection: `bash logs/scripts/work-loop-v2-slice-1.test.sh` → exit 1, **352 passed / 44 failed**. Failing families: 35 `pack`, 6 `race`, 3 `mode`.

Inspected (2026-08-17):

- Claim (1): HOLDS, with a corrected merge identity. `git show --numstat` gives `16de1622` = SKILL.md +28 / CMD +53−1 and `8a61a496` = SKILL.md +13−1, so 28+13 = **41 skill-side lines** and **53 command-side lines** — the reported deltas are exact, and every line is rule text, not formatting. The rules are absent now: `grep -rlF` over `.agents/skills/work-loop-v2/` and the command finds no hit for `builds a shared component`, `runs the full regression matrix for that integration`, `Dominant deliverable`, `Ending the hop`, `reconcile once before reporting anything`, `owns the rule; this is the procedure`, or `I cannot assess it until those sources converge`. **The loss did not occur at merge `9b1c19d3`**: both of its parents (`9b1c19d3^1`, `9b1c19d3^2`) already lacked all three phrases, so it could not have dropped them. Walking `git rev-list --ancestry-path 8a61a496..HEAD` and testing each commit's `SKILL.md` gives one YES→no transition — the content survives to `4ba2ff0e` and is gone at **`00855ec6`** ("Merge branch 'session/2026-08-14-durable-state'", 2026-08-16, parents `4ba2ff0e` = has it, `39b6e0a1` = does not). `9b1c19d3` is an earlier merge *into* that same branch, which never carried the rules.
- Claim (2): HOLDS on the substance, with a corrected count. The command lacks the packaging lines and the `## Ending the hop` contract entirely — verified by direct `grep -F` for each of the four line labels and for `## Ending the hop`, no match. The split, counted from the failing assertions in `logs/scripts/work-loop-v2-slice-1.test.sh` lines 1616–1707, is **13 reading `$SKILL_F` and 22 reading `$CMD_F`** (13+22 = the 35 `pack` failures), **not 14** reading the command. The two passing `pack` assertions are the intended regression guards on `$CORE_F` and `$UNITFR_F`.
- Claim (3): HOLDS as a mapping — and it is what forces the hand-back. `### Size the unit against the clock` now lives in `references/unit-framing.md` (line 33) and is absent from `SKILL.md`; the harness enforces that with `split one owner: size the unit against the clock`. Unit 1 already repointed the sibling assertion `pack  a longer timeout is still refused as the remedy` from `$SKILL_F` to `$UNITFR_F` for exactly this reason. The hand-off seam is `SKILL.md` `## The seam` (line 50), and Claude-side execution is the command. So packaging/sizing → `unit-framing.md`, reconciliation → `SKILL.md`, hop termination and the packaging checks → the command.
- Claim (4): HOLDS. `LIVE_TASK_F` names `logs/work-loop/work-loop-v2-durable-state-system.md`, which is `status: closed` and has **no** `## Lane and unit` (`grep -c '^## Lane and unit'` → 0). Running the harness's own `modes_in_lane` / `mode_of` / `reason_of` predicates against it returns 0 modes and an empty reason — which is precisely why all three `mode` assertions read empty and go red. The same predicates against this task's record return exactly one legal mode (`Implementation`) and a non-self-defeating named reason. The failures are the stale pointer and nothing else; no behavior is missing. The test's own comment at that line already prescribes the fix: "When this task closes, repoint this single line at the next open Standard record."

Additional inspection finding, not pre-stated in the brief: the `race` loss is larger than `8a61a496`'s 13 lines. The **whole** operator-shorthand paragraph is gone from `SKILL.md` — `grep -rlF 'never overrides the state file'` and `'brief names and task ids and ask which one'` return no hit anywhere in the skill, the command or the core. Those two strings are the `race` block's *preservation* guards, so restoring only `8a61a496`'s addition leaves 2 of the 6 `race` failures red. The correct restoration is the full 19-line block as it stood at `8a61a496:.agents/skills/work-loop-v2/SKILL.md` lines 166–184.

## Blocker

**The brief's owner mapping and its edit bound cannot both hold with its completion condition.** This is a framing conflict, not a false historical premise, and resolving it is Codex's move.

Two of the three restorations are in scope and fit:

- **`race` → `SKILL.md` `## The seam`** (claim 3's owner). Measured: `SKILL.md` is 204 lines / 4,575 words today; with the full 19-line shorthand block it is 223 lines / **4,802 words**, inside the harness's `< 500` lines and `< 5,000` words. All 6 `race` failures are reachable here.
- **hop termination + the packaging checks → `.claude/commands/work-loop-v2.md`** (claim 3's owner). All 22 command-side `pack` failures are reachable here, inside the declared edit set.

The remaining 13 skill-side `pack` assertions cannot be satisfied inside the declared edit set:

1. Their content is packaging and sizing detail, whose post-split owner is `references/unit-framing.md` — claim 3, confirmed above, and the placement Unit 1 already established for the sibling timeout rule.
2. But those 13 assertions grep **`$SKILL_F`**, the main `SKILL.md`. Restoring to the correct owner leaves all 13 red unless they are repointed to `$UNITFR_F` — 13 more lines in a file the Codex framing decision bounds to "the single `LIVE_TASK_F` pointer".
3. Restoring them into `SKILL.md` instead is arithmetically impossible. Measured on fixtures: `SKILL.md` + the approved 28-line packaging block = **5,342 words**, and with the mandatory `race` block as well = **5,569 words**, against the harness's own `split main skill body is below 5,000 words`. After the `race` restoration only **197 words** of headroom remain, against a 767-word approved block — so it would trade 13 `pack` failures for a `split` failure unless roughly 74% of the approved wording were cut, which is semantic loss the brief forbids and would also fragment `### Size the unit against the clock` across two owners.

So Slice 1 cannot reach exit 0 under the brief as written. Nothing was implemented, because widening an explicitly marked Codex framing decision is not Claude's call (core § 6 rule 4, core § 7 *Hand back to Codex*).

## Next action

Codex: resolve the conflict, then reissue Unit 0. The recommended resolution is to widen the framing decision's test-file bound from "the single `LIVE_TASK_F` pointer" to "the `LIVE_TASK_F` pointer plus the 13 `pack` assertions whose target file moved in Unit 1", which repoints them from `$SKILL_F` to `$UNITFR_F`. That is the identical move Unit 1 already made and had accepted for `pack  a longer timeout is still refused as the remedy`; it weakens nothing, since each assertion still greps its exact phrase and still fails when the phrase is absent, and it serves the framing decision's own stated reason — it absorbs none of Unit 2's recovery-boundary work. The alternative, cutting the approved packaging wording to fit 197 words of `SKILL.md` headroom, is semantic loss and contradicts claim 3.

Also correct in the reissued brief, so the record is accurate: the loss commit is `00855ec6`, not `9b1c19d3`; the command-side `pack` split is 22, not 14; and the `race` restoration must carry the full 19-line shorthand block, not only `8a61a496`'s addition, or the two preservation guards stay red.
