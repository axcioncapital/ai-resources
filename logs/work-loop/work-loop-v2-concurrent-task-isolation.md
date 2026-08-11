---
task: work-loop-v2-concurrent-task-isolation
turn: codex
---

## Objective and scope

Make two concurrent Work Loop v2 tasks safe in one repository: separate writable checkouts, one visible task owner per checkout, no duplicate logical-task ownership, and reuse of the bound checkout on later handoffs.

Human-controlled: final landing and cleanup. Excluded: push, automatic deletion, a scheduler, persistent registry, and a second state system. The operator declined a synthetic fan-out trial and chose immediate controlled landing; ordinary concurrent use will supply operational evidence afterward.

## Lane and unit

Standard. Implementation mode. Unit 10 — land the verified nine-file mechanism on canonical `main` without importing this task's state history.

Named reason for the loop: this cross-cutting concurrency fix needs bounded implementation and independent assessment across sessions.

## Brief

Unit 9 reconciled the verified mechanism with main snapshot `323b57f` at merge commit `953ff64`, with no conflicts or behavioral changes. The operator now authorises immediate landing and declines a synthetic trial; make the mechanism live with the smallest safe commit.

Before acting, verify:

1. The target is canonical `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources` on `main`.
2. Its current owner/state and uncommitted work do not indicate another active writer, and none of the nine landing paths is modified or untracked. If another task owns the checkout or any landing path overlaps live work, stop.
3. Since snapshot `323b57f`, canonical main has not changed any of the nine paths below. If it has, stop for renewed reconciliation.
4. The nine source files on this task branch are unchanged from merge commit `953ff64`.

Land exactly these paths as one new commit on canonical main:

- `.gitignore`
- `.agents/skills/work-loop-v2/SKILL.md`
- `.claude/commands/work-loop-v2.md`
- `docs/parallel-sessions-playbook.md`
- `logs/scripts/work-loop-owner.sh`
- `logs/scripts/work-loop-owner.test.sh`
- `plans/work-loop-v2-v0.2/handoff-automation-spike/README.md`
- `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`
- `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`

Do not merge this branch's history or copy `logs/work-loop/work-loop-v2-concurrent-task-isolation.md` into main. Preserve unrelated main work and stage only the nine paths. Do not push.

After committing, prove the landing commit changes exactly those nine paths and that their bytes match the task branch. Run only the two behavioral suites directly tied to the mechanism:

- `bash logs/scripts/work-loop-owner.test.sh` — expected 92/0
- `bash plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` — expected 389/0

Do not repeat the resolver, slice-1, B8, or synthetic fan-out checks; Unit 9 already established their unchanged baseline and the operator chose ordinary use over a trial.

Hand back: old and new main commits, landing commit and exact path list, byte-identity result, both test results, canonical status showing unrelated work untouched, and a non-destructive revert command for the single landing commit. Then return to this task checkout, set `turn: codex`, and commit only the state handback here.

Stop if any premise is false, another writer owns main, a landing path overlaps work or changed after `323b57f`, the commit includes any tenth path, or either suite regresses. Do not clean up, push, delete branches/worktrees, or start a synthetic trial.

Authority: the operator's immediate-landing decision governs. The executable core governs the unit; the repository-problem-resolution SOP supplies the still-open operational-validation standard. Codex's framing decision is to use one nine-path landing commit so rollback is one ordinary revert and the active state file never duplicates into main.

## Latest result

Inspected (2026-08-11):
- Claim (1): HOLDS — `git -C <canonical> rev-parse --show-toplevel` returned `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`; `--abbrev-ref HEAD` returned `main`; `--git-common-dir` and `--git-dir` both returned `.git`, so this is the main checkout, not a linked worktree. `git worktree list` confirms it is the only checkout holding `[main]`.
- Claim (2): HOLDS — searched the canonical checkout for `logs/work-loop/.owner`; no such file, so no task declares it. Searched the whole repo family (`find ... -name .owner -path '*work-loop*'`) and found exactly one, in this task checkout, naming this task. `git status --porcelain -- <the nine paths>` in canonical returned empty output, so none of the nine was modified or untracked. Canonical did carry unrelated dirty work (`.claude/settings.json`, `logs/friction-log.md`, one modified and one untracked `axcion-harness-v0-2-*` state file, six dispatcher run logs, `scripts/recall-search.py`); newest mtime was 16:37 against a 21:03 run, and none overlaps a landing path, so no active writer was indicated.
- Claim (3): HOLDS — `git rev-list --count 323b57f..refs/heads/main` returned `0`, so main had not moved at all since the snapshot; `git diff --name-only 323b57f refs/heads/main -- <the nine paths>` returned empty.
- Claim (4): HOLDS — `git diff --name-only 953ff64 HEAD -- <the nine paths>` on this task branch (HEAD `79ed9c3`) returned empty, and `git status --porcelain -- <the nine paths>` returned empty, so the nine sources are unchanged from the merge commit and clean in the working tree.

Result: the mechanism is live on canonical `main`. Main moved `323b57f` → `0d9e335` ("batch: land work-loop-v2 concurrent-task-isolation mechanism"), a single commit of exactly the nine briefed paths — `.gitignore`, `.agents/skills/work-loop-v2/SKILL.md`, `.claude/commands/work-loop-v2.md`, `docs/parallel-sessions-playbook.md`, `logs/scripts/work-loop-owner.sh`, `logs/scripts/work-loop-owner.test.sh`, and the three `plans/work-loop-v2-v0.2/handoff-automation-spike/` files (`README.md`, `dispatch.sh`, `dispatch.test.sh`). No branch history was merged and this state file was not copied into main.

Evidence: `git show --format='' --name-only 0d9e335` lists 9 paths and no tenth. `git diff 0d9e335 79ed9c3 -- <those nine>` is empty, so the landed bytes are identical to the task branch; the two executable scripts landed `100755` and `work-loop-owner.sh`/`work-loop-owner.test.sh` are recorded as `create mode`, matching their absence from main beforehand. Both suites pass from canonical main: `bash logs/scripts/work-loop-owner.test.sh` → exit 0, `92 passed, 0 failed`; `bash plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` → exit 0, `pass=389 fail=0`. Both match the Unit 9 baselines, and both suites carry their own red-mutation cases (the owner suite's F1..F3 block, the dispatcher's "goes red on the regressed dispatcher" cases), so a broken landing would have shown as failures rather than passes. Canonical `git status --porcelain` after the run is unchanged from before it — all ten unrelated dirty paths intact, nothing of the operator's work staged or reverted. Nothing was pushed; `origin` is untouched.

Non-destructive revert of the landing commit only, from the canonical checkout:

```
git -C "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources" revert --no-edit 0d9e335
```

It creates a new inverse commit and touches only the nine paths, so the unrelated uncommitted work in canonical survives it. Do not substitute a `reset --hard` form: canonical holds uncommitted work that such a form would destroy.

Deferrals, recorded and not done now:

1. Two `axcion-harness-v0-2-*-monday-prep` state files sit in canonical with `turn: claude` and no owner declaration — one tracked-and-modified, one untracked. Under the mechanism just landed, an undeclared replicated state file is exactly the AMBIGUOUS case. Not touched here because it belongs to another task and this unit's scope is the landing commit alone.
2. The mechanism's own ownership check cannot run in canonical until this commit, so claim (2) was settled by direct inspection of `.owner` and `git status` rather than by the helper. Worth one confirming run of `work-loop-owner.sh check --depth repo` from canonical during ordinary use.
3. The flaky slice-1 seam block and the two unrelated log modifications carried over from Unit 9 remain deferred, unchanged.

## Blocker

None.

## Next action

Codex: assess Unit 10. The mechanism is live on canonical main at `0d9e335`, byte-identical to the verified branch, with both concurrency suites green from main and unrelated main work preserved. Decide whether the task now closes as **Integrated, awaiting operational validation** — the operator having replaced the synthetic trial with ordinary concurrent use — or whether a further unit is justified, and rule on the three recorded deferrals.
