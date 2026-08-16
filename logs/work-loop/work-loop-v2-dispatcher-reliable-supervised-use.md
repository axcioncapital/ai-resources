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

Standard. Implementation mode. Unit 1 — restore the integrated activation baseline.

Named reason for the loop: the objective spans multiple bounded implementation and proof units, must survive session boundaries, and requires independent Codex assessment before it can count as complete.

## Brief

Unit 0 proved that merge `00855ec6` landed the durable-state branch but regressed accepted Work Loop content and left two activation suites red at integrated base `698383207208dbfccf04672a8263bbc55d001abf`. This repair is required before the provisional target plan can truthfully bind an activation baseline. Repair forward on a new commit; do not redo or rewrite the landed integration, edit the target plan, or begin dispatcher Change set A.

Required outcome: produce one coherent activation-baseline repair that turns the two proven red suites green without weakening their assertions or losing accepted durable-state behavior.

The repair must cover all three evidenced causes:

1. Reconcile the accepted main-side Work Loop content discarded by merge `00855ec6` into `.agents/skills/work-loop-v2/SKILL.md`, `.agents/skills/work-loop-v2/references/routing-index.md`, and `.claude/commands/work-loop-v2.md`. Preserve the durable-state parent's accepted lifecycle, ownership, lease, validator, and courier changes while restoring the accepted packaging/hop-termination and bounded handoff-reconciliation contracts from the pre-merge main side. This is semantic reconciliation, not wholesale selection of either parent.
2. Restore deployment parity by making `workflows/research-workflow/logs/scripts/work-loop-owner.sh` carry the accepted canonical owner-helper behavior, including the Tracer 8 uninspectable-worktree fail-safe. Do not change the canonical helper merely to match the stale template.
3. Repair the stale `LIVE_TASK_F` regression in `logs/scripts/work-loop-v2-slice-1.test.sh`. Preserve the assertion's purpose, but do not create another pointer whose next task closure predictably makes the suite red again; the result must have durable regression value rather than only pass while this task remains open.

Authority and evidence disposition:

- Unit 0's committed handback at `f9145ef2fce3027b47cce2239667531d7805fe68` is accepted evidence that the integrated baseline is defective: command/skill/core `315/44` and capability `76/1`, while the other required suites are green.
- Commits `16de1622` and `8a61a496` are verify-first pointers to accepted main-side behavior; durable-state parent `39b6e0a1` and merge `00855ec6` are verify-first pointers to the other side of the reconciliation. Inspect the actual blobs and history before editing.
- The target dispatcher plan remains provisional and unchanged. This unit repairs its prerequisite baseline; it does not activate or approve the plan.
- Codex chooses the forward-repair route because it is bounded, reversible, and preserves the already-landed public history. Re-performing the integration and any history rewrite are excluded.

Required fail-capable evidence:

- cite Unit 0's committed red results as the failing case, then run the complete command/skill/core and capability suites after the repair with exact commands, exit codes, and pass/fail counts;
- show that the restored instruction surfaces contain both the durable-state contract and the accepted packaging/handoff-reconciliation contracts, with no duplicate executable core or lifecycle parser introduced;
- show canonical/template owner-helper parity and run the canonical owner suite or an equally direct behavior check capable of detecting the former fail-open;
- demonstrate that the `LIVE_TASK_F` repair does not depend on this task or another named operational task remaining open, and that its negative controls still fail when the protected contract is broken;
- report the pre-unit and final commits and exact committed path list; and
- prove that no dispatcher file, target-plan file, canonical runtime helper, or unrelated file changed. `logs/friction-log.md` was already modified outside this unit and must remain untouched and uncommitted.

Capability subset: baseline only — read, search, inspect Git history, run local tests, edit only the three Work Loop instruction surfaces, the research-workflow owner-helper template, the slice-1 test, and this task state file, then make the local handback commit. The baseline deny set is required in full. Nothing is selected from the pre-authorizable set, which is empty today. No operator-reserved capability is needed.

Completion condition: both previously red activation suites are green on one forward-repair commit, the accepted contracts from both merge sides are preserved, the stale live-task assertion has durable coverage, no target-plan or dispatcher work has begun, and Claude commits the handback with `turn: codex`.

Stop and hand back rather than weakening proof or widening the unit if the two accepted contract lines materially conflict, a durable `LIVE_TASK_F` repair requires changing the test's intended guarantee, template parity cannot be restored without changing canonical behavior, or any deliberate file beyond the named scope is required. Challenge a false premise rather than improvising past it.

## Latest result

Inspected (2026-08-16):

- Claim (1) — merge `00855ec6` discarded accepted main-side Work Loop content in the three named files: **HOLDS, with one correction inside it.** `git rev-list --parents -n 1 00855ec6` gives parents `4ba2ff0e` (main) and `39b6e0a1` (durable-state). For all three files the merge blob equals the parent-2 blob exactly and differs from parent 1: SKILL.md `c21ad238` = p2, ≠ p1 `e8fbbe65`; routing-index.md `e71fa141` = p2, ≠ p1 `f4286c85`; command `5df53e70` = p2, ≠ p1 `515c54d7`. HEAD carries the same three blobs. **The correction:** `routing-index.md` carries *neither* named contract. Its whole main-side delta from merge-base `814f305b` is the `$diagnose-and-fix` rename plus the `$realign` route (`5fd95efb`, `199227a9`, `9e653f8e`) — no packaging, hop-termination or handoff-reconciliation text anywhere in it. That content is also **not accepted by this baseline's own harness**: running the suite with `WL2_ROUTER_FILE` pointed at `4ba2ff0e`'s routing-index turns **7 currently-green `ridx` assertions red** (primary-command set, the 51-entry count, command resolution, the 11-marker set, the live-installation cross-check, the excluded-names count, and the 116-line ceiling), because the main side changed the index without updating `AX_PRIMARY` and the counts in the test. Restoring it would weaken the baseline, which this unit's required outcome forbids. So routing-index.md is correctly left on the durable-state content, and the rename migration is recorded as a deferral below.
- Claim (2) — the deployed template owner helper is stale and lacks the Tracer 8 uninspectable-worktree fail-safe: **HOLDS.** `workflows/research-workflow/logs/scripts/work-loop-owner.sh` (531 lines, blob `fbc5a141`) is byte-identical to canonical frozen at `96ff6786`; canonical is now 612 lines, blob `8a4a0c46`, last changed at `b81a1b58`. The template still carries `[ -d "$wt" ] || continue` at line 347 and has no `AMBIGUOUS` branch for an uninspectable registered worktree. No template-specific edits exist, so this is pure drift, not a fork.
- Claim (3) — the `LIVE_TASK_F` regression is stale: **HOLDS.** Line 1375 named `logs/work-loop/work-loop-v2-durable-state-system.md`, which is `status: closed` and reduced to the four closing headings — it has no `## Lane and unit`, so `reason_of` and `modes_in_lane` both read an empty string and the two assertions plus their derived negative control went red. The test's own comment at lines 1368–1374 predicted exactly this.
- Claim (4) — Unit 0's committed handback is accepted evidence of the defect: **HOLDS, reproduced.** Before any edit in this unit: `work-loop-v2-slice-1.test.sh` exit 1, `315 passed / 44 failed`; `work-loop-capability.test.sh` exit 1, `pass=76 fail=1` on `B5 the template's logs/scripts/work-loop-owner.sh is byte-identical to canonical`. The 44 split exactly as Unit 0 recorded: 35 `pack`, 6 `race`, 3 `mode`.
- Claim (5) — `16de1622` and `8a61a496` point at accepted main-side behaviour, `39b6e0a1` and `00855ec6` at the other side: **HOLDS.** `16de1622` is the packaging/hop-termination change (SKILL +28, command +54, test +101); `8a61a496` is the bounded handoff reconciliation (SKILL +14, test +49, core +18) and its message records the pre-merge green this baseline regressed from. **One thing the brief does not name and this unit found:** `4800329c` ("clarify Work Loop v2 handoffs and completion") is a third discarded main-side commit whose **core-side half survived the merge while its runtime half did not** — the canonical core at HEAD still requires the brief-name-plus-task-id `Next` line (§ 3 *Where the record sits*), the three `Progress`/`Implementation`/`Merge readiness` status lines (§ 3), and Claude's post-closing merge-state report (§ 3), and the merge left both runtimes no longer instructing any of them. Restored, because leaving it would keep a runtime contradicting the canonical core it consumes.
- Claim (6) — the target plan remains provisional and unchanged: **HOLDS.** Line 4 still reads `**Status:** PROVISIONAL — scoped plan for operator approval after the durable-state branch is accepted and merged.` Its working-tree blob is identical to its HEAD blob.
- Claim (7) — `logs/friction-log.md` was already modified outside this unit: **HOLDS.** Its last commit is the merge `00855ec6` itself; it is modified in the working tree, unstaged, and this unit did not open it. It is excluded from the commit below.

Result: the activation baseline is repaired on one forward commit. Both previously red suites are green — command/skill/core `362/0` (was `315/44`) and capability `77/0` (was `76/1`) — and the other eight required suites stay green. The reconciliation was semantic, not a re-selection of either parent: both merge sides' contracts now coexist in the two runtimes. The `LIVE_TASK_F` pointer is gone rather than repointed. No dispatcher file, target-plan file, canonical runtime helper or unrelated file changed, and the target plan is still unmistakably awaiting Patrik's content-bound approval.

Evidence — host macOS 26.5.2 (Darwin 25.5.0, arm64), GNU bash 3.2.57(1)-release, all run from this checkout, pre-unit commit `f9145ef2fce3027b47cce2239667531d7805fe68`.

**1. The two red suites, before and after.** Nothing else in either suite moved: the `315 → 356` step is exactly the 41 `pack` and `race` assertions, and `356 → 362` is the three stale `mode` assertions replaced by six.

| Suite | Command | Before | After |
|---|---|---|---|
| command/skill/core | `bash logs/scripts/work-loop-v2-slice-1.test.sh` | exit 1, `315 / 44` | exit 0, `362 / 0` |
| capability | `bash logs/scripts/work-loop-capability.test.sh` | exit 1, `76 / 1` | exit 0, `77 / 0` |

The other eight required suites, re-run at the repaired tree: state `100/0`, owner `133/0`, lease `136/0`, core-resolver `4/0`, carrier `457/0`, tracer 6 `74/0`, tracer 7 `120/0`, dispatcher `639/0`. All exit 0.

**2. Both contract families are present in the restored surfaces, and no duplicate core or second lifecycle parser was introduced.** Restored main-side: all four packaging lines and the reconcile-once procedure in `SKILL.md`; the packaging-line check, `## Ending the hop`, and the required-evidence-cannot-be-deferred rule in the command. Preserved durable-state: the validator as the single lifecycle authority, the `--depth repo` ownership check, the Tracer 5 capability check, `There is no candidate scan`, and clear-the-declaration-only-after-the-commit in the command; the `status`/`turn` split and courier mode in `SKILL.md`. `git ls-files | grep work-loop-v2-executable-core` returns exactly one path. Neither runtime greps or awks `^status:`/`^turn:` — the three core-only sentences (`There is no third lane`, `is not a third lane, a new unit type, or a project phase`, core § 8's rule) each return **0 hits** in both runtimes, so nothing was copied down from the core.

**3. Owner-helper parity, proved behaviourally rather than by checksum alone.** `cmp` now reports the template byte-identical to canonical (31238 bytes each), which is what assertion `B5` reads. The behaviour behind it was proved separately, on a throwaway repository with a second registered worktree whose path was replaced by a regular file — registered, present, unenterable, and no permission change involved:

| Helper under test | `check --depth repo` verdict | Exit |
|---|---|---|
| template, before the resync | `PROCEED` — *"task is declared and stored nowhere — free to claim"* | 0 |
| canonical | `AMBIGUOUS` — *"registered worktrees exist that could not be inspected … whether one of them declares task is unknown"* | 4 |
| template, after the resync | `AMBIGUOUS` | 4 |

That is the former fail-open, caught and closed: the same input that made the deployed template hand out a claim now refuses it.

**4. The `LIVE_TASK_F` repair is durable, and its controls still fail.** The hard-coded path is replaced by `live_standard_records()`, which sweeps `logs/work-loop/` for records that are `status: active`, carry a `## Lane and unit`, and are not fixtures. It names no task, so no closure can stale it, and it is vacuously satisfied when nothing is open — which is the honest reading of a clean repo, not a weakened one. Its fail-capability therefore rests on controls pinned to a constructed directory rather than on liveness. Six mutations, each reverted, checksums confirmed identical to the pre-run bytes afterwards:

| Mutation | Result |
|---|---|
| **this task reduced to a closed record** (no open non-fixture record anywhere) | `362 / 0` — the durability claim: the suite does **not** depend on this or any named task staying open |
| a live open record naming `Exploration mode` | `361 / 1` — *every live open record states exactly one legal mode* |
| a live open record whose named reason reads *"small and reversible"* | `361 / 1` — *no live open record's named reason defeats its own admission either* |
| the sweep's `status: active` filter deleted | `361 / 1` — *the sweep excludes a closed record on its status alone* |
| the sweep's `fixture-` exclusion deleted | `360 / 2` — both live assertions, since fixtures would then stand in for real operational output |
| baseline, unmutated | `362 / 0` |

The fourth control needed adding during this unit and is the reason the count is six rather than five: the first draft's closed-record control used only the reduced durable-state record, which is excluded by *either* filter, so deleting the status filter changed no verdict and the filter was unfalsifiable. A second control record — `status: closed` over a surviving `## Lane and unit`, the malformed shape core § 4 names — makes the status filter load-bearing and testable.

**5. Committed path list**, all by explicit pathspec, pre-unit commit `f9145ef2`:

- `.agents/skills/work-loop-v2/SKILL.md`
- `.claude/commands/work-loop-v2.md`
- `logs/scripts/work-loop-v2-slice-1.test.sh`
- `workflows/research-workflow/logs/scripts/work-loop-owner.sh`
- `logs/work-loop/work-loop-v2-dispatcher-reliable-supervised-use.md`

`git status --porcelain` shows exactly these five plus `logs/friction-log.md`, which is left modified and uncommitted as the brief requires. `.agents/skills/work-loop-v2/references/routing-index.md` is deliberately unchanged, for the reason under claim (1).

Deferrals — noticed in this unit, deliberately not done:

1. **The `$diagnose-and-fix` rename migration is half-landed across the repository, and this unit did not finish it.** `.agents/skills/diagnose-and-fix/` exists and every other consumer was renamed, but the merge reverted the two Work Loop surfaces: `routing-index.md` still indexes `/resolve-repo-problem` and `/resolve-incident` and does not carry `$diagnose-and-fix` or `$realign`, and `SKILL.md` § *Repository-problem reference* still points at `references/repository-problem-resolution-sop.md`, **which the merge deleted** — a live dangling reference in an instruction surface. Not repaired here because completing it means changing the harness's `ridx` expectations (`AX_PRIMARY`, the 51-entry and 26-command counts, the marker set), which is editing accepted assertions rather than restoring content, and is outside this unit's three evidenced causes. It is one coherent change and wants its own unit.
2. **The harness's `ridx` block is the more general instance of the defect this unit fixed.** `AX_PRIMARY`, `CLAUDE_ONLY` and the entry counts are hard-coded inventories of a file that changes, so a legitimate routing change turns them red exactly the way `LIVE_TASK_F` did. The same discovery treatment would apply.

## Blocker

None. The activation baseline is green on this commit. Dispatcher implementation remains gated on Codex's assessment of this repair and, after it, Patrik's content-bound approval of the still-provisional target plan.

## Next action

Codex: assess Unit 1's forward activation-baseline repair. Two things need your judgment beyond the ordinary check. First, whether leaving `routing-index.md` on the durable-state content is the right call — the evidence is that its main-side alternative fails 7 currently-green assertions, so restoring it was refused as weakening the baseline rather than accepted as reconciliation. Second, whether restoring `4800329c`'s runtime half (the brief-name `Next` line, the three status lines, Claude's merge-state report) was in scope: it is discarded main-side content whose core-side half survived, but the brief named only the packaging and handoff-reconciliation contracts. Then decide whether Unit 0 is re-run against this commit to bind the activation baseline, and whether either recorded deferral opens as its own unit.
