---
task: work-loop-v2-concurrent-task-isolation
turn: codex
---

## Objective and scope

Make two concurrent Work Loop v2 tasks safe in one repository: separate writable checkouts, one visible task owner per checkout, no duplicate logical-task ownership, and reuse of the bound checkout on later handoffs.

Human-controlled: final landing, conflicts outside the authorised files, and cleanup. Excluded: push, automatic merge or deletion, a scheduler, persistent registry, and a second state system. The task closes only after integration and representative fan-out-2 use. Follow the repository-problem-resolution SOP through integration and operational validation.

## Lane and unit

Standard. Implementation mode. Unit 9 — bring this task branch up to one fixed snapshot of current `main` without landing it.

Named reason for the loop: this cross-cutting concurrency fix needs bounded implementation and independent assessment across sessions.

## Brief

Unit 8 proved fast-forward landing is impossible. The operator chose to continue in this existing isolated branch; reconcile it with current main and stop before landing.

First verify this is the bound checkout for `work-loop-v2-concurrent-task-isolation`, its `.owner` agrees, and there is no overlapping uncommitted work. Record the full current local `main` commit once and use that fixed commit even if main advances later.

Merge that commit into this branch. Do not rebase or rewrite history. Conflict resolution is authorised only in these implementation paths:

- `.gitignore`
- `.agents/skills/work-loop-v2/SKILL.md`
- `.claude/commands/work-loop-v2.md`
- `docs/parallel-sessions-playbook.md`
- `logs/scripts/work-loop-owner.sh`
- `logs/scripts/work-loop-owner.test.sh`
- `plans/work-loop-v2-v0.2/handoff-automation-spike/README.md`
- `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`
- `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`

Preserve both newer-main behavior and the verified ownership behavior. Stop if a conflict occurs elsewhere, a resolution is ambiguous, or another implementation file is needed. Keep the active task-state file on this branch; excluding it from main is a later landing concern.

Run these checks after the merge:

- `bash logs/scripts/work-loop-owner.test.sh`
- `bash plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`
- `bash logs/scripts/work-loop-v2-core-resolver.test.sh`
- `bash logs/scripts/work-loop-v2-slice-1.test.sh` — no failures beyond the three already known

Hand back: the main commit merged, merge commit, conflict paths and resolutions, test exit codes/counts, diff paths versus the merged main commit, and whether behavior differs materially from verified candidate `94807fd`.

Do not touch canonical main, push, land, clean up, create another worktree, or start live fan-out. Set `turn: codex` and commit the handback here.

Authority: the operator's branch choice governs; the executable core governs the unit; the SOP governs integration and closure; Unit 8's divergence evidence is accepted. Codex's only added boundary is one fixed main snapshot so the target cannot move mid-unit.

## Latest result

Inspected (2026-08-11):
- Claim (1) this is the bound checkout and `.owner` agrees: HOLDS — ran `logs/scripts/work-loop-owner.sh check --checkout <this repo> --task work-loop-v2-concurrent-task-isolation --depth repo`; verdict `PROCEED`, reason "this checkout already declares task 'work-loop-v2-concurrent-task-isolation' … the later handoff reuses it", exit 0.
- Claim (2) no overlapping uncommitted work: HOLDS — `git status --porcelain` showed three modified paths (`logs/friction-log.md`, `logs/innovation-registry.md`, this state file); `git diff --name-only 0ccf397..323b57f -- <those three paths>` returned no match, so the merged main commit touches none of them.
- Claim (3) branch work is confined to the nine authorised implementation paths: HOLDS — `git diff --name-only 0ccf397 HEAD` returned exactly those nine paths plus this state file, and nothing else.
- Claim (4) the four named check scripts exist: HOLDS — `[ -f ]` on all four returned true (`logs/scripts/work-loop-owner.test.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, `logs/scripts/work-loop-v2-core-resolver.test.sh`, `logs/scripts/work-loop-v2-slice-1.test.sh`).
- Claim (5) main and candidate `94807fd` have diverged, so landing is not a fast-forward (Unit 8's accepted evidence): HOLDS — `git merge-base --is-ancestor 323b57f HEAD` → NO, `git merge-base --is-ancestor 94807fd 323b57f` → NO.

Result: current local `main` was fixed at `323b57f` ("batch: group dispatcher pre-launch plans", 2026-08-11) and merged into this branch as merge commit `953ff64` (parents `c3a3ad6` + `323b57f`), with `--no-ff`. No rebase, no history rewrite, nothing landed. Only two paths changed on both sides — `.gitignore` and `.agents/skills/work-loop-v2/SKILL.md`, both inside the authorised nine — and git auto-merged both with **zero conflicts**, so no manual resolution was needed and the conflict boundary was never approached. Both sides survive: `.gitignore` keeps the branch's `logs/work-loop/.owner` ignore block *and* gains main's Work Loop v1 retirement rewrite; `SKILL.md` keeps the branch's "the checkout declares its writer" section *and* gains main's "Repository-problem reference" section.

Evidence:
- Merge is real and is a merge: `git log -1 --format='%H %p'` → `953ff640… c3a3ad6 323b57f` (two parents).
- Both-sides paths computed before merging: `comm -12` over `git diff --name-only 0ccf397 323b57f` and `git diff --name-only 0ccf397 HEAD` → `.gitignore`, `.agents/skills/work-loop-v2/SKILL.md`. Merge output reported `Auto-merging` on exactly those two and "Automatic merge went well"; `git status --porcelain` matched no unmerged marker (`UU|AA|DD|AU|UA|DU|UD`).
- Both sides preserved, shown against each parent: `git diff --cached HEAD -- .gitignore` adds only main's v1-retirement comment and the `!.agents/skills/work-loop/` removal; `git diff --cached 323b57f -- .gitignore` adds only the branch's `logs/work-loop/.owner` block. Same two-way check on `SKILL.md`: +10 lines of main's SOP reference against the branch parent, +21 lines of the ownership mechanism against the main parent.
- Checks after the merge (all four run from the merged tree):
  - `logs/scripts/work-loop-owner.test.sh` → exit 0, `T1..T13 + F1..F3: 92 passed, 0 failed`. Identical to the pre-merge baseline.
  - `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` → exit 0, `pass=389 fail=0`. Identical to baseline.
  - `logs/scripts/work-loop-v2-core-resolver.test.sh` → exit 0, `4 passed, 0 failed`. Identical to baseline.
  - `logs/scripts/work-loop-v2-slice-1.test.sh` → exit 1, `passed: 292 failed: 3` — the three already-known failures and no others (`3.1a no state file was opened for the direct request`, `3.1a every task-state file present is one this build created deliberately`, `ridx the skill stays under its 340-line ceiling`). Identical to the pre-merge baseline, which was captured before the merge for exactly this comparison.
- The checks can fail: `slice-1` exits 1 and names three red assertions in every run, pre-merge and post-merge alike; `dispatch.test.sh` builds regression mutants and asserts they go red.
- Diff versus the merged main commit — `git diff --stat 323b57f HEAD` → ten paths: the nine authorised implementation paths plus this state file. Nothing outside the boundary.
- Behaviour versus verified candidate `94807fd` — **no material difference.** `git diff --name-status 94807fd HEAD` restricted to the implementation paths returns only `.gitignore` and `SKILL.md`, and `git diff 94807fd HEAD` on those two shows only main's own additions (main's v1-retirement comment block plus the `!.agents/skills/work-loop/` removal; main's 10-line "Repository-problem reference" section). Not one line of the ownership mechanism differs — `logs/scripts/work-loop-owner.sh`, its test, the command, the playbook and the `logs/work-loop/.owner` ignore block are byte-identical to the verified candidate, and the owner suite is 92/92 on both.

Deferred, not done (noticed during this unit, outside its scope):
1. **The `seam` block in `logs/scripts/work-loop-v2-slice-1.test.sh` is flaky.** Across three consecutive runs on a byte-identical tree it returned `292/3`, `292/3`, then `291/4` — the extra red being a different seam assertion each time it appeared (`seam Claude then executed unit 2 …` on one run, `seam the hand-off and the unit-2 hand-back are two commits, not one` on another). Because the tree did not change between those runs, the nondeterminism cannot come from the merge; the commit sets the seam walks are also byte-identical pre- and post-merge (`git log --reverse -- <seam state>` and `-- <seam target>` return the same four and same two commits at `c3a3ad6` and at `953ff64`). Likely mechanism is the bare `mktemp` calls in `seam_classify_at`/`classify_state`, but that was not confirmed. Not fixed here: the test script is not one of the nine authorised paths, and diagnosing it is its own unit.
2. **Two pre-existing uncommitted files left untouched** — `logs/friction-log.md` and `logs/innovation-registry.md` were already modified when this unit opened, are outside the nine authorised paths, and do not overlap the merged main commit. They remain uncommitted and unchanged.

## Blocker

None.

## Next action

Codex: assess Unit 9. The fixed main snapshot `323b57f` is merged as `953ff64` with no conflicts, both behaviours preserved, all four checks at their pre-merge baselines, and no material behaviour difference from verified candidate `94807fd`. Nothing was landed, pushed or cleaned up. Decide whether Unit 9 is accepted, and what the next unit is toward integration and representative fan-out-2 use — plus a disposition for the two deferrals above.
