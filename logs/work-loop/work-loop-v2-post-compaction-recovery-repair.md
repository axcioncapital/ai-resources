---
task: work-loop-v2-post-compaction-recovery-repair
status: blocked
turn: operator
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

**The close was started and stopped at the cleanup step. The task is NOT closed.** Every precondition
in the close verdict's step 1 reconfirmed exactly: both worktrees present at `4510cb0a` on
`disposable/wl2-unit4-case-2026-08-17` and detached `7b130cd1`, both owner declarations empty, the
only untracked path in each its inventoried `.unit4-preflight/preflight.sh`, the disposable branch tip
`4510cb0a` with `092a1715` reachable, canonical `main` clean at `0d5641b8`.

`git worktree remove --force` was then refused by the repository's own
`check-destructive-liveness.sh` SessionStart guard, which reads the untracked path as evidence the
target may be occupied and requires the operator to confirm the checkout is idle. **Nothing was
removed, deleted, pruned or reset**, no branch was touched, and no plan or closed record was written.
The guard's demand is not the authorization already given: the operator authorized destroying the two
known scripts, and the guard asks the separate question of whether a session is running in those
checkouts right now — a fact core § 7 reserves to the operator and no repository scan can establish.

**Unit 4d remains accepted at `55214371`.** The complete nine-suite matrix is green at 1,176 passed / 0
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

**Operator liveness confirmation required before the close can finish.** The repository's
`check-destructive-liveness.sh` guard refused `git worktree remove --force` on both targets. It reads
the untracked `.unit4-preflight/preflight.sh` in each as evidence the checkout may be occupied, and it
will not accept a `git status` as proof of idleness — a clean status is a reading of a moving system,
and only the operator can say whether a session is running in those checkouts right now.

This is a different question from the one already answered. The operator authorized **destroying the
two known scripts and removing the two worktrees**; the guard asks whether either checkout is
**live at this moment**. Nothing in the repository can establish that.

The two targets, unchanged since the Unit 4d inventory:

- `…/ai-resources-wl2-unit4-case` — `4510cb0a` on `disposable/wl2-unit4-case-2026-08-17`, owner
  declaration empty, sole untracked path `.unit4-preflight/preflight.sh` (9,868 bytes, mtime
  2026-08-17 23:44).
- `…/ai-resources-wl2-unit4-cleanctl` — detached `7b130cd1`, owner declaration empty, sole untracked
  path `.unit4-preflight/preflight.sh` (9,065 bytes, mtime 2026-08-17 23:41).

If the operator confirms both are idle, the same command re-runs with the guard's documented
`AXCION_LIVENESS_OVERRIDE=1` prefix, which writes an audit line to `logs/destructive-override.log`.
The guard's marker files are not to be deleted to get past it.

## Next action

Operator: confirm whether a session is running in either
`…/ai-resources-wl2-unit4-case` or `…/ai-resources-wl2-unit4-cleanctl` right now.

- **Both idle** → Claude re-runs the two removals with the documented override, completes the plan
  § 8 update, writes the closed record and commits once. Nothing else changes.
- **Either live** → the close waits until that session wraps and commits. Everything else is already
  done, so the wait costs only the close.

A third option exists and is Codex's to weigh, not the operator's to be asked for: close the task now
and leave the two worktrees for a separate cleanup. The close verdict explicitly says a failed
cleanup stops the close, so that would need Codex to reframe rather than Claude to decide.

Nothing else is authorized or attempted: no branch deletion, no prune, no reset, no merge, no remote
reconciliation, no push.
