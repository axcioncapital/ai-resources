---
task: work-loop-v2-post-compaction-recovery-repair
status: active
turn: codex
---

## Objective and scope

Implement the post-compaction recovery repair plan, including the operator-approved Amendment 1 whose exact content is recorded at `a366c295`: preserve the Work Loop contract while preventing unnecessary immediate context refill after compaction, restoring the `$realign` / `$reorient` boundary, making active-state result rollover reliable, and proving the repaired behavior.

Scope is Units 0–4 and the completion condition in `plans/work-loop-v2-v0.2/work-loop-v2-post-compaction-recovery-repair-implementation-plan-v0.1.md`. Preserve its exclusions: do not split the executable core; add no model default, hook, parser, state field, registry, cache, summary file, recovery daemon, universal state-size gate, provisional 12/16 KB launch policy, or unrelated optimization; do not change Work Loop roles, lifecycle, admission, courier permissions, or dispatcher exit codes.

## Lane and unit

Standard. Implementation mode. Unit 0 — restore the lost Work Loop behavior.

Unit 1 remains implemented at `66688592` but unaccepted pending a green Slice 1 suite. Unit 0’s first hand-back correctly found a contradiction in Codex’s edit bound before implementation; no target file changed, and this revised brief replaces that false premise.

Named reason for the loop: the repair spans multiple bounded implementation and proof units, must survive hand-offs, and requires assessment independent of the implementer before it counts as complete.

## Brief

Unit 0 restores previously implemented Work Loop behavior that disappeared in a later merge, because Units 2–4 must not build recovery changes on a known-incomplete contract. This reissued brief preserves Amendment 1’s outcome, files, sequence, and green-suite bar while correcting factual repository claims and allowing existing assertions to follow their post-split semantic owner.

Required outcome: restore packaging, hop-termination, and hand-off-reconciliation behavior under the current post-split owners; retarget the affected assertions and stale live-task pointer without weakening them; return Slice 1 and resolver suites to exit 0; preserve Unit 1’s progressive-disclosure contract; correct the governing plan’s factual Unit 0 record; record fail-capable evidence; and commit the unit once.

Governing authority: the operator-approved Amendment 1 content at `a366c295`, as preserved in meaning by the evidence-backed factual corrections below; plan §4 Unit 0 and §§5–9; the canonical executable core; and repository `AGENTS.md`. Codex classifies these corrections as non-material: they keep the same dominant deliverable, repository files, sequence, exclusions, acceptance conditions, and authority relationships. They replace false repository facts and widen an edit from one line to 14 lines inside an already scoped test file solely so rules remain with the semantic owner Amendment 1 requires.

Verified repository findings from the prior hand-back, which Claude must confirm remain current before editing:

1. The rules survive through `4ba2ff0e` and disappear at merge `00855ec6`; `9b1c19d3` is not the loss commit because both of its parents already lack them. Historical sources `16de1622` and `8a61a496` carry the rule text needed for reconstruction, but restoration remains a merge with judgment rather than a revert.
2. The 35 `pack` failures split into 13 assertions reading `$SKILL_F` and 22 reading `$CMD_F`, not the previously recorded 21/14 split. The command lacks the packaging and `## Ending the hop` contract.
3. The full hand-off-reconciliation restoration is the 19-line operator-shorthand block as it stood in `8a61a496`, not only that commit’s 13 added lines. All six `race` failures depend on the full block.
4. The three `mode` failures arise because `LIVE_TASK_F` points to a closed task with no active `## Lane and unit`; this task’s active Standard record yields exactly one legal mode and a non-self-defeating named reason.
5. Post-split ownership is: packaging and sizing detail in `references/unit-framing.md`; operator hand-off reconciliation in the main skill’s seam; Claude-side hop termination and execution procedure in `.claude/commands/work-loop-v2.md`. The 13 skill-side `pack` assertions still target the obsolete pre-split owner and must follow the rules to `$UNITFR_F`.
6. With the full reconciliation block restored, the main skill is expected to remain under both structural limits (measured fixture: 223 lines / 4,802 words). Restoring packaging detail to the main skill would exceed 5,000 words and duplicate the post-split owner, so that route is excluded.

Implementation requirements:

- Preserve the existing failing-first baseline already recorded from unchanged target files: Slice 1 exit 1, 352 passed / 44 failed across 35 `pack`, six `race`, and three `mode`. Reconfirm the target files have not changed since that hand-back; rerun the red baseline only if they have.
- Restore the semantically complete packaging/sizing material to `references/unit-framing.md`, the full reconciliation block to the main skill’s seam, and the hop-termination / packaging execution contract to the Claude command, using the historical text as evidence rather than blindly recreating old structure.
- In `work-loop-v2-slice-1.test.sh`, retarget exactly the 13 `pack` assertions whose phrases now belong to `unit-framing.md` from `$SKILL_F` to `$UNITFR_F`, and repoint the single `LIVE_TASK_F` line to this active Standard task. Do not delete, skip, loosen, rename, or otherwise rewrite those assertions.
- Correct plan §4 Unit 0 and §8’s Unit 0 evidence so the durable record names `00855ec6`, the 13/22 assertion split, the full 19-line reconciliation block, and the 14 authorized test-line retargets. Do not alter Amendment 1’s outcome, sequence, exclusions, or green acceptance condition.
- Keep the main skill below 500 lines and 5,000 words; preserve direct-reference, read-condition, one-owner, no-chain, table-of-contents, semantic-volume, and resolver-parity guards.
- Run Slice 1 and resolver suites to exit 0, plus the proportionate state, session-preflight, and Tracer 7 checks affected by the restored seam and command behavior.

Codex framing decision: edits are limited to `.agents/skills/work-loop-v2/SKILL.md`, `.agents/skills/work-loop-v2/references/unit-framing.md`, `.claude/commands/work-loop-v2.md`, the 13 owner-retargeted `pack` assertions plus the one `LIVE_TASK_F` pointer in `logs/scripts/work-loop-v2-slice-1.test.sh`, the factual Unit 0 record and evidence in the governing plan, this state file, and incidental repository telemetry written by existing hooks. This replaces the earlier single-line test bound because that bound contradicted the approved one-owner and green-suite requirements. Hold every other reference, `$realign`, `$reorient`, the executable core, deployment code, and Units 2–4 outside this unit.

Capability subset: baseline only—read/search/history inspection, local tests, task-scoped edits, and a local commit by Claude. Nothing is selected from the pre-authorizable set, which is empty today. No operator-reserved capability is needed. Do not push, merge, deploy, access credentials, destructively alter shared state, or invoke nested Claude/Codex actors.

Required evidence must be able to fail: current-target identity against the recorded baseline; restored-rule source and current owner; unchanged assertion semantics before/after each of the 14 retargets; green Slice 1 and resolver outputs with exit 0; affected regression outputs; one-owner placement; and final main-skill line/word counts plus Unit 1 structural guards. A phrase-presence grep alone is insufficient unless paired with the existing assertion that fails when that exact rule is absent or misplaced.

Completion condition: all 44 baseline failures are resolved without weakening an assertion; Slice 1 and resolver suites exit 0; affected regressions remain green; restored rules have one correct current owner; the main skill remains below both limits; plan §4 and §8 record accurate facts and evidence; task-scoped changes are committed once by Claude; and this state file holds the current result only with `status: active` and `turn: codex` for assessment.

Stop and hand back if any verified finding no longer holds; a green suite requires changing an assertion’s meaning rather than its semantic-owner target; restoration requires a core, role, lifecycle, admission, courier, or dispatcher-policy change; another excluded surface is needed; or fail-capable evidence cannot be produced.

## Latest result

Inspected (2026-08-17) — the six verified findings the brief requires confirming before editing:

- Finding (1): HOLDS — content-probed `.agents/skills/work-loop-v2/SKILL.md` and `.claude/commands/work-loop-v2.md` at `16de1622`, `8a61a496`, `4ba2ff0e`, `39b6e0a1`, `04be4f6a`, `9cf6b56b`, `9b1c19d3`, `00855ec6` and HEAD for `Dominant deliverable:` and `## Ending the hop`; present through `4ba2ff0e`, absent at `00855ec6`, and absent in *both* parents of `9b1c19d3`, so `9b1c19d3` cannot be the loss commit. `16de1622` and `8a61a496` carry the recoverable text.
- Finding (2): HOLDS — counted the assertions in the `pack` block of `logs/scripts/work-loop-v2-slice-1.test.sh`: 13 read `$SKILL_F` (four of them from one `for pack_line` loop) and 22 read `$CMD_F`. Searched the command for `## Ending the hop` and each packaging line: no match.
- Finding (3): HOLDS — `git show --stat 8a61a496` reports 13 insertions in the skill, but two of the six `race` assertions (`never overrides the state file`, `brief names and task ids and ask which one`) read the shorthand paragraph that already existed there, so the recoverable unit is the whole 19-line block at that commit.
- Finding (4): HOLDS — `LIVE_TASK_F` named `logs/work-loop/work-loop-v2-durable-state-system.md`, whose frontmatter reads `status: closed` and which carries no `## Lane and unit`; searched it for that heading, no match. This task's own record yields exactly one legal mode (`Implementation`) and a named reason that does not match the self-defeating pattern.
- Finding (5): HOLDS — `### Size the unit against the clock` lives in `references/unit-framing.md` (the surviving `A longer timeout is not the remedy` assertion already reads `$UNITFR_F` and was green in the red baseline); the seam is in `SKILL.md`; hop termination and the Claude-side execution procedure are in `.claude/commands/work-loop-v2.md`. The 13 skill-side `pack` assertions still pointed at the pre-split owner.
- Finding (6): HOLDS — measured after restoring the 19-line block: 223 lines / 4,802 words, matching the brief's fixture measurement exactly and under both the 500-line and 5,000-word limits.

Result: the packaging, hop-termination and hand-off-reconciliation rules are back in service under their post-split owners, and Slice 1 is green. `references/unit-framing.md` gains 26 lines (the two split triggers, the primary-edit-begins-after rule, the four packaging lines and their mode scoping); `SKILL.md` gains the full 19-line operator-shorthand and reconciliation block in § *The seam*; `.claude/commands/work-loop-v2.md` gains 52 lines (§ *The brief's packaging lines* under § *The unit's mode*, and § *Ending the hop*). The 14 authorized retargets in the test file change only which file a predicate reads — no assertion was deleted, skipped, loosened, renamed or rewritten. Plan § 4 Unit 0 and § 8 now record `00855ec6`, the 13/22 split, the full 19-line block and the 14 retargets.

Evidence: `work-loop-v2-slice-1.test.sh` went from exit 1 — 352 passed / 44 failed, split 35 `pack` / 6 `race` / 3 `mode`, reconfirmed against unchanged target files — to exit 0, 396 passed / 0 failed. A bounded negative control ran each restored rule's predicate against both the restored artifact and its pre-restoration HEAD copy: all 43 probes read green on the restored file and red on the pre-restoration one, so none of them could pass whatever happened; the same control confirms the packaging rules do not also sit in `SKILL.md`, so one owner is preserved rather than assumed. Unit 1's structural contract holds — 223 lines / 4,802 words, with the direct-reference, read-condition, one-owner, no-chain, table-of-contents, semantic-volume and resolver-parity guards all green inside that run. Affected regressions all exit 0: `work-loop-v2-core-resolver` 5/0, `work-loop-state`, `work-loop-owner`, `work-loop-session-preflight` 60/0, `work-loop-capability` 81/0, `work-loop-v2-tracer-7` 120/0; the capability drift check still reports `READY` with every copied component byte-identical to canonical.

Noticed and not done, for Codex to place: the restored command contract now requires four packaging lines in the brief and hands back a brief that lacks them. This brief predates that contract and carries none, which the restored text names as one intended bounce. It was not applied to this unit — the rule was absent when the unit was admitted, and enforcing a rule against the brief that authorized restoring it would stop the unit from ever completing. The next brief on this task must carry them.

## Blocker

None.

## Next action

Codex: assess Unit 0 — the restored rules, their placement under the post-split owners, the fail-capable evidence, and the corrected plan record. Unit 1 remains implemented at `66688592` and returns for assessment against its own unchanged completion evidence now that the suite is green.
