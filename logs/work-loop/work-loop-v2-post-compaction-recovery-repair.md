---
task: work-loop-v2-post-compaction-recovery-repair
status: blocked
turn: operator
---

## Objective and scope

Implement the operator-approved content of `plans/work-loop-v2-v0.2/work-loop-v2-post-compaction-recovery-repair-implementation-plan-v0.1.md` at commit `d72cf199`: preserve the Work Loop contract while preventing unnecessary immediate context refill after compaction, restoring the `$realign` / `$reorient` boundary, making active-state result rollover reliable, and proving the repaired behavior.

Scope is exactly Units 1–4 and the completion condition in that plan. Preserve its explicit exclusions: do not split the executable core; add no model default, hook, parser, state field, registry, cache, summary file, recovery daemon, universal state-size gate, provisional 12/16 KB launch policy, or unrelated Work Loop optimization; do not change Work Loop roles, lifecycle, admission, courier permissions, or dispatcher exit codes.

## Lane and unit

Standard. Implementation mode. Unit 1 — split the Work Loop skill without semantic loss.

Named reason for the loop: the approved repair spans four bounded implementation/proof units, must survive hand-offs, and requires assessment independent of the implementer before it counts as complete.

## Brief

This unit performs the first approved repair because the oversized always-loaded Work Loop skill caused the observed recovery miss, and the later recovery changes depend on the conditional rules having stable direct-reference owners. It implements only plan Unit 1; Units 2–4 remain held back so this hand-off has one dominant deliverable and one proportionate evidence set.

Required outcome: make `.agents/skills/work-loop-v2/SKILL.md` a fully readable universal entry skill below 500 lines and 5,000 words, moving the approved conditional detail—without semantic loss or duplicate ownership—into the four direct references settled in plan §3.1. Update the existing resolver-parity and Slice 1 structural/routing checks so they fail on the pre-split structure and pass on the new semantic owners. Record Unit 1's red/green evidence in plan §8 and make one focused commit for this unit.

Governing authority: the operator's approval in this conversation applies to the exact plan content committed as `d72cf199`; plan §§1, 3.1, 4 Unit 1, 5–7, and 8 govern this unit. The canonical executable core continues to govern Work Loop semantics and must not be changed. Repository `AGENTS.md` governs repository conventions.

Check against the repository before editing:

1. Verify that commit `d72cf199` identifies the governing plan content and that its Unit 1 requirements match this brief. If the commit or content does not match, hand back without implementing.
2. Measure the current main skill and confirm the plan's over-limit baseline. Inventory the exact current owners of the resolver, courier operation, routing/admission, and unit-framing rules before moving them.
3. Inspect `logs/scripts/work-loop-v2-core-resolver.test.sh` and confirm which marked sources it currently compares. Inspect the Work Loop assertions in `logs/scripts/work-loop-v2-slice-1.test.sh` and identify which assertions must follow each moved semantic owner.
4. Confirm `.claude/hooks/auto-sync-shared.sh` deploys the whole skill directory so new sibling references require no deployment design change. If that premise is false, stop and hand back; deployment expansion is not authorized in this unit.

Implementation requirements from the approved plan:

- Add fail-capable structural assertions first for both main-skill limits, all four direct links and their read conditions, one semantic owner per moved section, no reference-to-reference loading chain, and a short table of contents in every reference over 100 lines. Preserve the observed red result.
- Update only the governing plan's approval metadata to record that the operator authorized the exact plan content at commit `d72cf199` on 2026-08-17; do not alter the approved design while making that metadata current.
- Move rather than copy the conditional material into `references/core-resolution.md`, `references/courier-operation.md`, `references/routing-and-admission.md`, and `references/unit-framing.md`. The main skill must directly link every reference it may require and directly link both routing files when routing.
- Keep the universal role/seam/checkout/fresh-thread, assessment/continue/correction/closing, never-do, and compact route-table behavior in the main skill as settled by plan §3.1. Do not shorten rules merely to satisfy the numeric checks.
- Retarget the resolver parity test to compare the Claude command's marked resolver against `references/core-resolution.md`. Retarget existing Slice 1 assertions to their new one semantic owner; do not delete or weaken a behavioral assertion because its source moved.
- Run the focused resolver and Slice 1 suites, then the proportionate existing checks affected by this structural move. Report exact commands, exit codes, final line/word counts, and the one-owner inventory for moved headings.

Codex framing decision: edits are limited to the main Work Loop skill, the four approved new references, `logs/scripts/work-loop-v2-core-resolver.test.sh`, the relevant `logs/scripts/work-loop-v2-slice-1.test.sh` assertions, plan §8's Unit 1 evidence entry, this state file, and incidental repository telemetry that existing hooks write. The reason is to keep Unit 1 independent of the behavior changes in Units 2–4. Do not edit `$reorient`, `$realign`, the Claude Work Loop command, Tracer 7, the executable core, or deployment code in this unit.

Capability subset: baseline only—read/search/history inspection, local tests, task-scoped edits, and a local commit by Claude. Nothing is selected from the pre-authorizable set, which is empty today. No operator-reserved capability is needed. Do not push, merge, deploy, access credentials, destructively alter shared state, or invoke nested Claude/Codex actors.

Required evidence must be able to fail: include the pre-change structural failure; focused green test outputs and exit codes; final main-skill line and word counts; proof that every moved section has one owner; direct-link and table-of-contents checks; resolver parity; and unchanged green behavioral assertions. A grep that only finds text supplied by this brief is not sufficient by itself—each structural check must distinguish an intentionally wrong fixture or the actual pre-split state from the repaired state.

Completion condition: the Unit 1 deliverable and evidence above are complete, plan §8 records the evidence, all task-scoped changes are committed once by Claude, and the state file contains the current result only with `status: active` and `turn: codex` for assessment.

Stop and hand back without building through it if a premise is false; a moved rule cannot retain one semantic owner without changing the canonical core; success requires an excluded item, a new architecture choice, or edits outside this unit; a required fail-capable test cannot be produced; or existing deployment does not expose direct sibling references.

## Latest result

Inspected (2026-08-17):

- Claim (1): HOLDS — `git show d72cf199` identifies commit `d72cf199542a195e0b78932b5bc2ece2fb703dc5`, "new: post-compaction-recovery-plan", adding the 388-line governing plan as its only file. Read plan §§1, 3.1, 4 Unit 1, 5–7, 8; every Unit 1 requirement in the brief maps to plan § 4 Unit 1 and § 3.1 with no addition or omission.
- Claim (2): HOLDS — `wc -l -w .agents/skills/work-loop-v2/SKILL.md` returned `602 12669`, over the `<500`-line and `<5,000`-word guidance, matching the plan's § 2 baseline exactly. Owner inventory taken from `grep -n '^#\{1,4\} '`: resolver at lines 26–132 (marker-bounded), courier at 217–313, routing/admission at 317–390, unit framing at 392–531 — all four in the one always-loaded body.
- Claim (3): HOLDS — `work-loop-v2-core-resolver.test.sh:30,115-121` compares the marked block of `.claude/commands/work-loop-v2.md` against `.agents/skills/work-loop-v2/SKILL.md` (check 4). In `work-loop-v2-slice-1.test.sh`, 37 assertions read `$SKILL_F` for content that moves: `admission_res` (:388), `routing_res` (:926), `result_block` (:1165), `route_step` (:1194), `ex_block` (:1326), eight `ce9` orientation checks, the sizing check, and the courier-mode disambiguation (:1321).
- Claim (4): HOLDS — `.claude/hooks/auto-sync-shared.sh:571-589` symlinks each shared skill as a whole **directory** (`ln -s "$rel_src" "$target"`, `src=$AI_RESOURCES/.agents/skills/$name`). Confirmed by precedent, not only by reading: `references/routing-index.md` was added on 2026-08-13 (`a22b54b7`), after the project links existed, and is readable today through the pre-existing `projects/axcion-content-programme/.agents/skills/work-loop-v2` link. No deployment change is needed.

Result: Unit 1 is implemented. The always-loaded Codex Work Loop skill went from **602 lines / 12,669 words to 204 / 4,575** — under both architecture limits — by moving the resolver, courier operation, routing and admission, and unit framing into four direct references, each the single owner of what it holds. No rule was shortened, softened or dropped: combined text across the main skill and its references is **14,626 words against a 12,669-word pre-split body**, and all 18 moved headings have exactly one owner. The main skill directly links all four references plus the routing index, each with its read condition, and no reference links another, so nothing is reachable only by loading something else first. Resolver parity was retargeted to `references/core-resolution.md` and a new check 5 added, because parity between two files says nothing about a third.

Evidence:

- **Red first, on the real pre-split file.** The 37 structural assertions were written and run before any content moved: **30 failed** (`322 passed / 74 failed`) — both limits, all four reference-exists and direct-link checks, all four read-condition checks, all eleven one-owner checks, the resolver-marker check. The seven that passed did so vacuously over files that did not yet exist, which is why the two negative fixtures below exist.
- **Green after.** Resolver suite `5 passed, 0 failed` (exit 0). Slice 1 **352 passed / 44 failed**. `work-loop-state`, `work-loop-session-preflight` and `work-loop-v2-tracer-7` all exit 0. Deployment capability check `verdict: READY` against canonical.
- **Zero regression, stated against a baseline that was never green.** Slice 1 was **315 / 44 before any edit** — see the deferral below. A set-difference of failing test names before against after is **empty**: nothing green went red, and 37 new assertions went green (315 → 352). Slice 1's exit 1 is entirely the 44 pre-existing failures.
- **Fail-capability proved by mutation, not asserted.** Each applied, observed, reverted: a moved heading copied back into the main skill → `FAIL split one owner: classifying the mode`; the resolver marker pair left behind → `FAIL check 5` and `FAIL split the resolver marker pair moved whole`; a reference link removed → `FAIL split main skill directly links unit-framing.md` plus its read-condition check; `unit-framing.md` truncated to 40 lines → `FAIL split no semantic loss`. Two wrong fixtures built in-test prove the chain and table-of-contents checks discriminate, since the repaired tree cannot exhibit those states. Suite returned to 352 / 44 after every revert.
- **Retargeting, not weakening.** No assertion deleted or loosened. Four negative sets were **widened** to the new references so the split could not open a hole in them (no `## Mode` heading, no `mode:` key, no verbatim copy of the core's mode definition, no invented "adoption unit"), and the `ce9` stated-once check now counts across all five files instead of one.

Runtime profile: baseline capabilities only — read, search, history inspection, local tests, task-scoped edits, one local commit. Nothing selected from the pre-authorizable set (empty today); no operator-reserved capability used. No push, merge, deploy, credential access or nested actor.

Deferral, recorded and deliberately not done (core § 5): **the Slice 1 suite has been failing 44 assertions since 2026-08-14, from content loss unrelated to this unit.** The `pack` (unit packaging and hop termination, 26 checks), `race` (hand-off reconciliation, 6 checks) and 3 `mode` live-task families test behaviour that was implemented and green — commit `8a61a496` records "harness 345/0 to 358/0 green" — and was then dropped from `.agents/skills/work-loop-v2/SKILL.md` by merge `9b1c19d3`, which took the skill from 592 to 532 lines. Both source commits are ancestors of HEAD; their text is not. The `.claude/commands/work-loop-v2.md` half is missing too. Verified by content probe across `16de1622`, `8a61a496`, `9b1c19d3` and HEAD. Not repaired here: restoring lost skill and command text is outside Unit 1's file scope and outside plan § 4 Unit 1, and it is a materially different change from a structural move. It needs its own unit, and Codex should decide whether it precedes Units 2–4 — Unit 2 edits `$realign` and `$reorient`, which load this same skill.

## Blocker

Unit 1 cannot be accepted against the approved plan because `work-loop-v2-slice-1.test.sh` exits 1 with 44 failures, while plan §4 Unit 1 explicitly requires a green Slice 1 suite. The failures expose previously lost `pack`, `race`, and `mode` behavior, including unit packaging, hop termination, hand-off reconciliation, and live-task mode rules; these are material Work Loop behaviors rather than cosmetic checks.

The Unit 1 evidence record also says that the success condition became "no regression against that baseline". That redefines an approved acceptance condition without operator approval and conflicts with the plan header's content-bound approval rule. It is not accepted as governing.

Repairing the pre-existing loss requires a new bounded prerequisite unit and additional scope before Units 2–4. Continuing without it would waive the approved green-suite condition and build later recovery changes on a known incomplete Work Loop contract.

## Next action

Operator: decide whether to approve a material plan amendment adding one bounded prerequisite unit before Unit 2 to restore the lost `pack`, `race`, and `mode` behavior, return the complete Slice 1 suite to green, remove the unauthorized acceptance-condition reinterpretation from the evidence record, and then return Unit 1 for assessment. If not approved, the repair must stop for replanning rather than continue with 44 known failures.
