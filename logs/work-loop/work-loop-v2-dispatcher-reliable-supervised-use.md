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

Standard. Implementation mode. Unit 14 — give dry-run one truthful terminal outcome

Named reason for the loop: the objective spans multiple bounded implementation and proof units, must survive session boundaries, and requires independent Codex assessment before it can count as complete.

## Brief

Unit 13 is accepted at `5d31b5b1f43fe9de1108e8d743a2d1ab48883c97`. It established that the terminal-result validators accept the record structurally but do not constrain `outcome` semantically, while the one producer vocabulary owner currently gives admitted dry-runs `UNCLASSIFIED`, `COMPLETED`, or `OPERATOR_TAKEOVER` according to the underlying task lifecycle. Change set A requires the result's outcome to be truthful and every terminal class to produce exactly one valid result, so this unit makes the already-integrated dry-run terminal class report one dry-run-specific success outcome without changing real loop-terminal meanings or integrating `--carry-one`.

Dominant deliverable: one truthful mode-derived code-zero terminal classification for every admitted dry-run, implemented at the existing single vocabulary owner.
Evidence required in this hop: one targeted pre-edit failing case over active, closed, and blocked dry-run states; the implemented result; focused regression proof that real `CLOSED` and `BLOCKED_OPERATOR` terminals retain their accepted meanings; and a mutation control that fails when only the new mode-derived branch is removed.
Evidence explicitly deferred: `--carry-one` integration and its future outcome token; validator-side outcome-token or semantic-tuple enforcement; terminal families A–C and M; `--help` and strictly read-only `--status`; status rendering; resume; crash-boundary recovery; hostile-input and full regression matrices; Change sets B–D; live trials; adoption review; merge, push, deployment, and destructive cleanup.
Primary edit begins after: a focused failing fixture proves that admitted code-zero dry-runs currently return lifecycle-borrowed or fallback outcome/next-action pairs across active, closed, and blocked states.

Required outcome:

- At the existing production vocabulary owner, dispatcher-owned dry-run mode takes precedence over lifecycle class for code-zero outcome and next-action derivation.
- Every admitted successful dry-run produces one bounded dry-run-specific outcome symbol and one bounded, truthful next-action token independent of whether the underlying task is active, closed, or blocked. `DRY_RUN_COMPLETE` and `none-dry-run-preflight-complete` are Unit 13's non-governing token recommendations; Claude may select equally strict tokens if the live grammar or established vocabulary supports a clearer choice, and must explain any difference.
- Real loop-terminal `CLOSED` and `BLOCKED_OPERATOR` records remain `COMPLETED` / `none-task-closed` and `OPERATOR_TAKEOVER` / `operator-answer-the-blocking-question` respectively.
- All nonzero outcome mappings, the accepted structural schema and validators, producer/consumer identity binding, finalization ordering, lease behavior, and read-only status behavior remain unchanged.
- Keep one production owner and one parser. Do not add a helper: Unit 13 found § 8's narrow-helper condition untriggered for this branch-sized change.

Check against the repository before editing:

1. In `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, verify that `result_outcome()` and `result_next_action()` remain the sole code-zero vocabulary owners; that they can read the dispatcher-owned mode without a second lifecycle parse; and that the dry-run terminal still uses the accepted finalizer/consumer seam. If any claim is false, hand back rather than inventing a second owner.
2. In `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, locate the accepted Unit 12 dry-run coverage and the focused operator-terminal distinction. Add only the minimum fixture needed to fail on the three dry-run lifecycle states and preserve the two real loop-terminal meanings; do not rerun or rebuild Unit 12's accepted `95/0` baseline first.
3. Verify that the exact chosen tokens satisfy the existing bounded value grammar. Do not widen this unit into validator-side whitelisting or a general semantic-tuple matrix.

Required fail-capable evidence:

- Quote the targeted red result before the production edit, showing the wrong/fallback pair for each of active, closed, and blocked dry-run states.
- After the edit, run the focused impacted dispatcher test slice and report exact pass/fail counts. It must show one dry-run-specific pair across all three states and retain the accepted real `CLOSED` versus `BLOCKED_OPERATOR` distinction.
- Run one mutation control that removes or bypasses only the new mode-derived classification branch; the focused test must fail by exposing the borrowed/fallback outcome pairs. Restore the production edit and rerun the same focused slice green.
- Run the proportionate shell syntax/static check already used by this dispatcher suite if the changed shell files require it. Do not run the broad synchronous Gate SA regression matrix in this unit.
- Report the implementation commit and prove it changes only `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, and this task state file. `logs/friction-log.md` is pre-existing session noise: do not stage or commit it.

Capability subset: baseline only — read/search the approved plan and accepted Unit 13 evidence; edit and locally test only `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` and `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`; update and locally commit those files plus this task state file. The baseline deny set is required in full. Nothing is selected from the pre-authorizable set, which is empty today. No operator-reserved capability is needed.

Completion condition: all admitted successful dry-runs use one truthful dry-run-specific outcome and next action independent of lifecycle class; real completion and operator-takeover outcomes are unchanged; the targeted red/green and mutation evidence passes; no second vocabulary owner, parser, helper, schema change, carry-one integration, or deferred work enters the unit; only the permitted paths are committed; and the task returns with `turn: codex`.

Stop and hand back if mode-derived classification cannot be implemented at the accepted production owner, if the exact token choice requires a material plan or operating-model decision, if the change needs a second parser/helper or validator/schema expansion, if it alters real loop-terminal semantics or another accepted invariant, or if the required focused evidence cannot be made fail-capable. Challenge a false premise instead of widening the unit.

## Latest result

Inspected (2026-08-17):
- Claim (1): HOLDS — `result_outcome()` (`dispatch.sh` 502) and `result_next_action()` (542) remain the sole code-zero vocabulary owners, each called exactly once by the producer (730, 776) and nowhere else; `MODE` is a dispatcher-owned global assigned at argument-parse time (1270–1273) and readable in both functions without any lifecycle parse or state read; the dry-run terminal still uses the accepted finalizer/consumer seam (3579, 3580 markers).
- Claim (2): HOLDS — Unit 12's accepted dry-run coverage is case 58 and the loop-terminal distinction is case 55c; the new case 59 was added after them and Unit 12's baseline was not rebuilt or rerun as a precondition.
- Claim (3): HOLDS — the bounded value grammar caps a value at 512 characters with no tab or carriage return; `DRY_RUN_COMPLETE` (16) and `none-dry-run-preflight-complete` (31) satisfy it, and each matches its field's established form — UPPER_SNAKE like `COMPLETED`/`OPERATOR_TAKEOVER`/`TERMINAL_UNPROVABLE`, lower-kebab like `none-task-closed`. Unit 13's recommended tokens were adopted unchanged, so no difference needs explaining.

Result: at the existing single vocabulary owner, dispatcher-owned `MODE` is now consulted before `ST_CLASS` for code-zero derivation. Every admitted dry-run reports `outcome=DRY_RUN_COMPLETE` and `next_action=none-dry-run-preflight-complete` regardless of whether the underlying task is active, closed or blocked. `MODE=live` falls through to the unchanged lifecycle cases, so real loop terminals keep `COMPLETED`/`none-task-closed` and `OPERATOR_TAKEOVER`/`operator-answer-the-blocking-question`. Two branches, both inside the existing functions: no second owner, no second parser, no helper (Unit 13's untriggered narrow-helper finding holds — this is branch-sized), no schema or validator change, no nonzero mapping touched, no carry-one integration, no change to finalization ordering, lease behaviour, or read-only `--status`.

Evidence: red quoted before the production edit, all three states in one run — active `UNCLASSIFIED operator-read-run-log`, closed `COMPLETED none-task-closed`, blocked `OPERATOR_TAKEOVER operator-answer-the-blocking-question`; the targeted fixture scored 0 pass / 4 fail. The committed focused impacted slice (cases 55–59) against the pre-unit dispatcher: 98 pass / 3 fail, failing exactly 59a's sameness and non-fallback assertions plus 59c's mutant construction (the branches do not exist there to delete). Against the edited dispatcher: 102 pass / 0 fail. Case 59a proves one pair across all three lifecycle states and that it is a real classification rather than the unmapped fallback; 59b re-reads the two real loop terminals' records and confirms both accepted pairs survive and that the dry-run pair borrows neither; 59c's M26 deletes only the two mode branches, leaving the lifecycle cases intact, and the borrowed/fallback pairs return — that control ran inside the green slice, against a copy, so the production edit was never removed and the same slice is green with it in place. `bash -n` passes on both changed shell files. The broad Gate SA regression matrix was not run.

Pre-unit commit: `5d31b5b1f43fe9de1108e8d743a2d1ab48883c97`. The handback commit is this state file's own commit, touching exactly `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, and this task state. `logs/friction-log.md` was neither staged nor committed.

Deferrals unchanged and none newly noticed: `--carry-one` integration and its future outcome token (its seam still releases without a terminal result), validator-side outcome-token whitelisting and semantic-tuple enforcement, terminal families A–C and M, status rendering, resume, crash-boundary recovery beyond these seams.

## Blocker

None.

## Next action

Codex: assess Unit 14 — the mode-first code-zero classification, its three-state red/green, the loop-terminal regression proof, and the M26 branch-only control — and decide close, continue, or correct once.
