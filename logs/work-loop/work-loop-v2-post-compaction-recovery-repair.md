---
task: work-loop-v2-post-compaction-recovery-repair
status: active
turn: codex
---

## Objective and scope

Implement the post-compaction recovery repair plan, including operator-approved Amendment 1: preserve the Work Loop contract while preventing unnecessary immediate context refill after compaction, restore the `$realign` / `$reorient` boundary, make active-state result rollover reliable, and prove the repaired behavior.

Scope is Units 0–4 and the completion condition in `plans/work-loop-v2-v0.2/work-loop-v2-post-compaction-recovery-repair-implementation-plan-v0.1.md`. Preserve its exclusions: do not split the executable core; add no model default, hook, parser, state field, registry, cache, summary file, recovery daemon, universal state-size gate, provisional 12/16 KB launch policy, or unrelated optimization; do not change Work Loop roles, lifecycle, admission, courier permissions, or dispatcher exit codes.

## Lane and unit

Standard. Unit 4d — final regression matrix and cleanup readiness — is accepted at `55214371`.

Units 0–4 are accepted. The implementation and proof are complete; the task is waiting only on the
operator-owned destructive cleanup decision below before Codex issues the close verdict.

Named reason for the loop: the repair spans multiple bounded implementation and proof units, must survive hand-offs, and requires assessment independent of the implementer before it counts as complete.

## Latest result

**Unit 4d accepted at `55214371`.** The complete nine-suite matrix is green at 1,176 passed / 0
failed, the Unit 4 evidence chain is coherent, canonical `main` is restored and clean, no material
review finding remains, and both disposable cleanup targets are precisely inventoried.

Inspected (2026-08-18):

- Claim (1): HOLDS — feature HEAD is `63c02624` on `session/2026-08-17-work-loop-fix-17-8`;
  `git rev-parse --show-toplevel` is `…/ai-resources-work-loop-fix-17-8`; `logs/work-loop/.owner`
  reads `work-loop-v2-post-compaction-recovery-repair` and `--depth repo` returns PROCEED; the
  validator returned `ACTIVE_CLAUDE` on entry; `git status --porcelain` listed exactly one path,
  this state file.
- Claim (2): HOLDS — `ls logs/scripts/work-loop*.test.sh` returns exactly the nine suites the brief
  names and no tenth. The matrix is not widened.
- Claim (3): HOLDS — plan § 8 still carries all four, none erased: "Unit 4 — live post-compaction
  case" (the accepted Attempt 2 semantic trace), the `092a1715` rollover evidence, "Independent
  review" (`FAIL — correction required, 2026-08-18`), and "Correction round — the six frozen
  findings". Noted for the closing record: that last subsection does **not** cite the correction
  commit `63c02624` by hash — searched § 8 onward for it, 0 matches.
- Claim (4): HOLDS — canonical `main` is `0d5641b8` with `git status --porcelain` empty. `git ls-files`
  on this branch matches no `u4-live-case`, `unit4-operator-prompt` or `governing-plan` path.
  `git branch -a --contains a0f4f6ec` returns only `disposable/wl2-unit4-case-2026-08-17`, and
  `git merge-base --is-ancestor` puts it on neither this feature HEAD nor `main`.
- Claim (5): HOLDS — both named worktrees exist and are inventoried below.
- Claim (6): HOLDS — all six frozen findings carry a disposition in plan § 8's correction subsection.
  The only open items are the two recorded non-behavioral deferrals, final evidence, closing
  mechanics and cleanup.

Result: the corrected feature branch is evidenced as ready to close. The complete Work Loop matrix is
green at the exact feature HEAD, the Unit 4 evidence chain is coherent, and both cleanup targets are
inventoried with their exact data-loss exposure. This unit changed nothing but this state record: no
implementation, plan, worktree, branch or Git topology was touched.

Evidence — the complete matrix, one run each at HEAD `63c02624`, sequential:

| Suite | Exit | Result |
|---|---|---|
| `work-loop-capability.test.sh` | 0 | 94 passed, 0 failed |
| `work-loop-lease.test.sh` | 0 | 136 passed, 0 failed |
| `work-loop-owner.test.sh` | 0 | 133 passed, 0 failed |
| `work-loop-session-preflight.test.sh` | 0 | 60 passed, 0 failed |
| `work-loop-state.test.sh` | 0 | 100 passed, 0 failed |
| `work-loop-v2-core-resolver.test.sh` | 0 | 5 passed, 0 failed |
| `work-loop-v2-slice-1.test.sh` | 0 | 407 passed, 0 failed |
| `work-loop-v2-tracer-6.test.sh` | 0 | 74 passed, 0 failed |
| `work-loop-v2-tracer-7.test.sh` | 0 | 167 passed, 0 failed |

Nine suites, **1,176 passed, 0 failed**, every exit 0, no rerun. Every count was parsed from the
suite's own summary line; none was missing or unparseable. `grep` for a `FAIL` line across all nine
captured outputs returns none. `git status --porcelain` after the run lists only this state file, so
no suite left residue in the tree.

Evidence — the Unit 4 chain, consolidated pointers:

- **Accepted recovery trace:** plan § 8, "Unit 4 — live post-compaction case", Attempt 2 (2026-08-18).
  It exercised the unconditional contract — complete lean Work Loop skill and complete core once each,
  830 bytes of the 79,995-byte plan without widening, no courier/routing/routing-index/unit-framing
  reference, actor-correct Claude `Next:`.
- **Rollover revision:** `092a1715`. At that revision `logs/work-loop/u4-live-case.md` contains
  `U4-OLD-RESULT` 0 times, carries exactly one `## Latest result`, is `status: active` / `turn: codex`,
  and validates `ACTIVE_CODEX` at exit 0. Accepted for that behaviour alone; its byte-ceiling verdict
  is non-governing.
- **Resolved review findings:** correction commit `63c02624`, recorded in plan § 8 "Correction round
  — the six frozen findings" with per-finding red/green.

Evidence — cleanup readiness. Read-only inventory; nothing was removed, cleaned, reset or edited.

**Target 1 — `…/ai-resources-wl2-unit4-case`.** Branch `disposable/wl2-unit4-case-2026-08-17`,
HEAD `4510cb0a`. That commit is reachable from its own branch, so removing the **worktree** loses no
committed history. `logs/work-loop/.owner` is empty — the checkout holds no task lease. Its
`logs/work-loop/` carries 14 non-terminal records, and every one is tracked and preserved by the
branch: 12 are `fixture-*` regression fixtures, one is `u4-context-refill-audit` (ACTIVE_CODEX,
created by `d99e7eda` "fixture: Unit 4 representative live case — disposable, prepared but unrun",
tracked on the disposable branch only), and one is a stale replica of **this** task at an older
revision, which this checkout does not declare. `u4-live-case` there validates `CLOSED`.
Untracked, and therefore the only thing a worktree removal destroys: `.unit4-preflight/preflight.sh`
(9,868 bytes).

**Target 2 — `…/ai-resources-wl2-unit4-cleanctl`.** Detached HEAD `7b130cd1`, which is a commit on
**this** feature branch, so it holds no unique history at all. `.owner` empty; 13 non-terminal
records, the same fixtures plus the same stale replica of this task. Untracked, and the only loss on
removal: `.unit4-preflight/preflight.sh` (9,065 bytes).

**The two untracked scripts are not the same file** — 9,868 vs 9,065 bytes, and `cmp` reports them
different. Neither is tracked on any branch. The script's own header states it is "UNTRACKED AND
DISPOSABLE ON PURPOSE … committed to no branch", so on its own account it is fixture-only; but it is
the sole non-reproducible artifact in either target, and the two copies having diverged means
removing both discards two distinct versions, not one file twice. That is the operator's call to
make knowingly rather than an inference this unit is entitled to draw.

**Worktree removal and branch deletion are separate, and only the first is authorized.** Removing
both worktrees loses no committed history: Target 1's history survives on its branch, Target 2's on
this one. Deleting `disposable/wl2-unit4-case-2026-08-17` is a different act — it is the only ref
holding `4510cb0a`, `a0f4f6ec`, `092a1715` and `d99e7eda`, and `092a1715` is a live evidence pointer
in the chain above. No separate authority for deleting it was found in the plan, so it stays for an
explicit operator decision.

## Blocker

None. The operator authorized the cleanup on 2026-08-18, taking the recommended option: Claude may
delete both divergent untracked `.unit4-preflight/preflight.sh` copies and remove the two named
disposable worktrees during the closing move, while branch `disposable/wl2-unit4-case-2026-08-17` and
every commit on it are preserved. No branch deletion, merge, remote reconciliation or push is
authorized by this decision.

Nothing has been deleted or removed yet, and this record is the whole of what changed: the cleanup is
part of the closing move Codex has not yet issued, so recording the decision costs nothing and
reverses freely if it was read wrongly.

## Next action

Codex: the operator-owned decision is recorded, so nothing further is reserved to them. Issue the
Unit 4 close verdict, or say what remains.

What the verdict has in front of it: Units 0–4 accepted; the complete nine-suite matrix green at
`63c02624` with 1,176 passed and 0 failed; the Unit 4 evidence chain (accepted Attempt 2 trace →
`092a1715` rollover → `63c02624` correction); canonical `main` clean at `0d5641b8`; and the cleanup
decision above.

Three things the closing record must carry, per the earlier hand-back and unchanged:

1. Plan § 8's correction subsection does not cite `63c02624` by hash. Whether to add that pointer is
   a plan edit for the closing move, not something the discovery unit could make.
2. The two correction deferrals stand, unpromoted: the stale "five separate things" count prose in
   `.claude/commands/work-loop-v2.md` Step 0 and `/sync-workflow`'s five-name remediation list; and
   whether a reference may cite a sibling's path at all.
3. Branch `disposable/wl2-unit4-case-2026-08-17` is preserved deliberately — it is the only ref
   holding the rejected history and the `092a1715` evidence pointer the chain above depends on.

Still unauthorized and untouched: branch deletion, merge to canonical `main`, remote reconciliation
and push.
