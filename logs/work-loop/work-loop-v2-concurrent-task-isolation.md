---
task: work-loop-v2-concurrent-task-isolation
turn: codex
---

## Objective and scope

Make concurrent Claude and Codex work a safe, supported Work Loop v2 operating model: when another useful task starts, the system should handle routine isolation mechanics, preserve task-to-checkout continuity across handoffs, make ownership visible, and refuse duplicate ownership of either a logical task or a writable checkout.

The target operator experience is automatic creation or reuse of a dedicated task worktree when concurrent writing requires isolation, without requiring the operator to reason through Git mechanics. Human control remains mandatory for whether tasks genuinely belong together, merge and final landing decisions, conflict resolution, and destructive cleanup. Excluded are automatic push, branch deletion, worktree deletion, conflict resolution, universal one-worktree-per-session behavior, a general scheduler, a persistent task registry, and any second semantic state system.

Task exit condition: the repository contains an implemented and evidenced minimum mechanism, integrated with Work Loop v2's existing entry and handoff surfaces, that safely supports two concurrent tasks in one repository on separate worktrees, rejects the same logical task in two worktrees, rejects two dispatched writers in one physical checkout, reuses the bound task worktree on later handoffs, and presents understandable ownership/status information.

Governing task method: apply the structural route in `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.agents/skills/work-loop-v2/references/repository-problem-resolution-sop.md` inside the Work Loop v2 unit cycle: failure proof; blind fresh-context evidence review; causal model and structural options; Codex complexity challenge and operator scope lock; controlled Claude implementation; independent clean-environment verification; operator-controlled integration and representative fan-out-2 validation. Preserve this sequence through compaction and future unit rewrites without adding a second case document or state system.

## Lane and unit

Standard. Implementation mode. Unit 8 — integrate the independently verified candidate into the canonical main checkout, preserve a usable rollback, and hand back before operational validation.

Named reason for the loop: the work spans investigation, planning, implementation, and independent assessment; its scope crosses existing concurrency and transport controls and must remain bounded before changes begin.

## Brief

Why this unit now: SOP Step B8 independently returned **Proceed**, and the operator has explicitly authorised controlled integration. Integration is the smallest remaining repository change; live fan-out-2 is held for a separate operational-validation unit so an integration defect cannot be confused with real-use evidence.

Operator decision carried by this brief: integrate candidate base `381559f` through exact tip `94807fde27ed05abd7b239328ee89fd8320dfc25` into the canonical main checkout at `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`. The authorisation covers a clean fast-forward only. It does not authorise push, conflict resolution, destructive cleanup, branch/worktree deletion, or inclusion of later state-only commits.

Check against the repository before acting:

1. **Canonical target and cleanliness.** Verify the target path resolves to the canonical `ai-resources` repository, the checked-out branch is `main`, and status has no tracked or untracked work that this integration could overwrite or absorb. The path, branch, status, and worktree listing settle this claim.
2. **Immutable candidate identity.** Verify both `381559f` and full tip `94807fde27ed05abd7b239328ee89fd8320dfc25` exist, that the base is an ancestor of the tip, and that the exact candidate range contains only the authorised implementation surfaces reported in Step B8: `.gitignore`, `.agents/skills/work-loop-v2/SKILL.md`, `.claude/commands/work-loop-v2.md`, `docs/parallel-sessions-playbook.md`, `logs/scripts/work-loop-owner.sh`, `logs/scripts/work-loop-owner.test.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/README.md`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, and `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`. A name-status range inspection settles this claim. No task-state commit belongs in the integration.
3. **Fast-forward availability.** Verify current `main` is an ancestor of the exact candidate tip and that moving `main` to that tip is a fast-forward. The ancestry check and a dry-run-equivalent read-only inspection settle this claim. If main has diverged, stop; do not merge, rebase, cherry-pick, or resolve conflicts.
4. **Ownership artifact hygiene.** Verify the candidate ignores `logs/work-loop/.owner`, does not track an `.owner` file or mutation/dispatcher lock artifact, and lands the helper together with every caller that now depends on it. The candidate tree, ignore check, and caller search settle this claim.

If all claims hold, fast-forward canonical `main` to exact tip `94807fde27ed05abd7b239328ee89fd8320dfc25`. Integrate that candidate only. Do not push.

Then verify in canonical main:

- `bash logs/scripts/work-loop-owner.test.sh` — expected 92 passed / 0 failed;
- `bash plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` — expected 389 passed / 0 failed in an environment that exposes process metadata;
- `bash logs/scripts/work-loop-v2-core-resolver.test.sh` — expected 4 passed / 0 failed from the canonical `ai-resources` basename;
- `bash logs/scripts/work-loop-v2-slice-1.test.sh` — expected only the three already disclosed failures (292 passed / 3 failed): two stale `3.1a` allowlist assertions and the SKILL.md 340-line ceiling.

Evidence required: target path/branch/status before and after; exact old and new `main` commits; proof the move was fast-forward-only; candidate range paths; ownership-artifact hygiene result; commands, exit codes and counts for the four checks; confirmation that nothing was pushed, cleaned up, or conflict-resolved; and a concrete rollback instruction that reverts the integrated candidate without deleting worktrees or branches. Separate repository observations from assumptions.

Return to this bound checkout after integration. Record the result in this state file, set `turn: codex`, and commit only the state-file handback here; do not let that handback enter canonical main.

Stop and hand back without integrating if any precondition is false, the target has overlapping work, fast-forward is unavailable, the exact range differs, any new test regression appears, or preserving rollback would require destructive action. Do not launch real Claude/Codex actors, run the fan-out-2 trial, delete `/Users/patrik.lindeberg/Claude Code/wl2-b8-verification-94807fd`, remove ownership declarations or lock directories, or fix the known slice-1 failures in this unit.

Source dispositions: the executable core governs the unit cycle and safety rules; the repository-problem-resolution SOP governs controlled integration and the still-pending representative-use gate; the candidate range is the immutable implementation input; the clean B8 verifier is retained only as evidence and is not an integration source. Codex's framing decision is to restrict authorisation to a clean fast-forward and separate integration from live operational validation.

## Latest result

Inspected (2026-08-11):

- Claim (1): FALSE as stated — `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources` resolves to the canonical repository (`rev-parse --show-toplevel` returns that path; `--git-common-dir` is its own `.git`, so it is the main checkout, not a linked worktree) and the branch is `main` at `ef78972af2cfa061d030ba813b11e23f2f66812a`. The cleanliness half fails: `git status --porcelain --untracked-files=all` returns three modified tracked files (`.claude/settings.json`, `logs/friction-log.md`, `logs/work-loop/axcion-harness-v0-2-phase0-p0-d-monday-prep.md`) and seven untracked paths (`logs/work-loop/axcion-harness-v0-2-p0-d-monday-prep.md`, five `plans/work-loop-v2-v0.2/handoff-automation-spike/runs/*` artifacts, `scripts/recall-search.py`). None of those paths intersect the candidate range, so nothing would be overwritten by a checkout; the material fact is that the canonical checkout holds another task's live in-progress work (`axcion-harness-v0-2-phase0-p0-d-monday-prep`).
- Claim (2): FALSE — `git diff --name-status 381559f 94807fde27ed05abd7b239328ee89fd8320dfc25` returns ten paths, not the nine authorised. The nine implementation surfaces are all present and no unauthorised implementation surface appears; the tenth is `logs/work-loop/work-loop-v2-concurrent-task-isolation.md`, the task-state file, which the brief states must not enter the integration. It enters through commit `8a24480`, not through the tip, so it cannot be excluded while keeping the exact range intact. Both objects exist and `merge-base --is-ancestor 381559f 94807fd` succeeds, so base-to-tip ancestry itself holds.
- Claim (3): FALSE — `merge-base --is-ancestor ef78972a 94807fde` fails. `main` has diverged from the candidate: 18 commits on `main` are absent from the tip, 9 commits in the tip are absent from `main`, and the merge base is `0ccf397c2e5e486ae8b297bd90aceec01bfbaab4`. Fast-forward is unavailable. Two further facts sharpen this. First, the authorised base `381559f` is itself not in `main`, so a move to the tip would carry all 9 commits, not the authorised 2-commit range — the 7 commits below the base touch only the task-state file (`diff --name-only 0ccf397..381559f` returns that one path). Second, `git diff --name-status main 94807fde` shows the move would *delete* work that currently exists in `main`: `.agents/skills/work-loop-v2/references/repository-problem-resolution-sop.md` (the SOP this task's own method depends on), `scripts/axcion-harness-v0.2/carry-turn.sh` and its test, the whole `plans/work-loop-v2-v0.2/incident-evidence/` tree, three `plans/work-loop-v2-v0.2/` plan documents, and three other tasks' state files — while re-adding the retired `.agents/skills/work-loop/SKILL.md`. The brief's own instruction on divergence is to stop.
- Claim (4): HOLDS — `git show 94807fd:.gitignore` contains `logs/work-loop/.owner` at line 46 with its rationale comment; `ls-tree -r --name-only 94807fd` matched against `\.owner|\.lock|lock\.d|\.dispatch` returns no tracked ownership or lock artifact; `logs/scripts/work-loop-owner.sh` and its test are added in the range; and every file at the tip whose content mentions `work-loop-owner.sh` (SKILL.md, the `work-loop-v2` command, `.gitignore`, the playbook, the helper and its test, the spike README, `dispatch.sh`, `dispatch.test.sh`) is inside the candidate range, so the helper lands with all of its callers.

Observed during the unit, and material: canonical `main` moved while this check was running. It read `ef78972af2cfa061d030ba813b11e23f2f66812a` at the claim-1 reading and `323b57f21fb37c70e571b8cf701355161863a51c` minutes later, the difference being one ordinary commit from a concurrent session (`323b57f batch: group dispatcher pre-launch plans`, 19:44). `merge-base --is-ancestor ef78972a 323b57f2` succeeds and the `main` reflog shows a plain `commit:` entry, so `main` advanced normally and was not rewritten — and nothing in this unit wrote to that checkout. Divergence is now 19 commits on `main` against 9 on the candidate; the finding is unchanged and the gap is widening. `main` is an actively moving target, which bears directly on any integration mechanism Codex chooses.

Result: no integration was performed. Three of the four claims are false, and the decisive one is unrecoverable within this unit's authorisation — canonical `main` has moved 19 commits past the point the candidate branched from, so the clean fast-forward the operator authorised does not exist. Canonical `main` was not changed by this unit. Nothing was pushed, merged, rebased, cherry-picked, cleaned up or conflict-resolved; no branch or worktree was deleted; `/Users/patrik.lindeberg/Claude Code/wl2-b8-verification-94807fd` is untouched. The four post-integration checks were not run, because running them in a checkout that was never integrated would produce evidence about the candidate rather than about the integration.

Evidence: the ancestry test is the failing case and it can fail in the other direction — `git -C <canonical> merge-base --is-ancestor ef78972a 94807fde` exits non-zero today; had `main` still been at or below the candidate's base it would exit zero and the integration would have proceeded. `git rev-list --count 94807fde..main` returns 18 and `git rev-list --count main..94807fde` returns 9; both are non-zero, which is the definition of divergence. `git diff --name-status 381559f 94807fde` listing ten paths against the brief's nine is directly checkable and would have listed nine had the state file not been committed alongside the implementation in `8a24480`.

Deferral noticed and not done: the candidate's implementation commits carry the task-state file in the same commits as the implementation surfaces, which is what makes "integrate the implementation without the state file" impossible as an exact-range operation. Separating state-file commits from implementation commits is a Work Loop v2 commit-discipline question, not part of this unit's authorisation, and it is left unimplemented.

## Blocker

The authorised operation does not exist in the repository as it now stands. Canonical `main` (`323b57f2` at the close of this unit) is not an ancestor of candidate tip `94807fde`; the two lines diverged at `0ccf397c`, with 19 commits on `main` and 9 on the candidate since, and `main` gained one of those 19 during this unit. The brief authorises a clean fast-forward only and explicitly withholds merge, rebase, cherry-pick and conflict resolution, so there is no move available to Claude here.

Two further defects would need a decision even if divergence were resolved. The exact candidate range carries the task-state file as a tenth path, which the brief forbids and which cannot be dropped without changing the range. The canonical checkout is also not clean and holds another task's live work, so it is not a safe integration target as-is.

## Next action

Codex: decide how the verified candidate reaches canonical `main` now that a clean fast-forward is unavailable, and re-scope the unit accordingly. The decision needs at least: which integration mechanism is authorised in place of fast-forward, given that the candidate branched before 18 commits of newer `main` work and a naive move would delete the SOP, the incident-evidence tree, the harness carry-turn scripts and three other tasks' state files; whether the task-state file may ride along in the integration or the range must be reshaped so it does not; and whether the canonical checkout must be brought clean, and by whom, before any integration is attempted. Integration authorisation is an operator decision under core § 7 where it becomes hard to reverse.
