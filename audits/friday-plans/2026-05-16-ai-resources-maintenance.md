# Friday Act Plan — 2026-05-16 — ai-resources-maintenance

**Source report:** friday-checkup-2026-05-16.md (weekly tier)
**Journal report:** audits/friday-journal-2026-05-16.md
**Generated:** 2026-05-16
**Items:** 6

## Items

### 1. [med] git push — ai-resources: 8 unpushed commits
- **Source:** checkup
- **Risk-check required:** no
- **W2.4 auto-draft:** no
- **Detail:** ai-resources has 8 commits ahead of origin as of 2026-05-16. Verify the count at execution time (`git log @{u}..HEAD --oneline`), then push. This is an operator-approved external write — autonomy rule #2 requires explicit approval at execution time; this plan item serves as that approval.

### 2. [med] Run /resolve-improvement-log against 3 logged-pending 2026-05-16 entries (ai-resources)
- **Source:** checkup
- **Risk-check required:** no
- **W2.4 auto-draft:** no
- **Detail:** /coach flagged this as "The One Thing" for ai-resources: run a dedicated `/resolve-improvement-log` execution session against the three 2026-05-16 logged-pending entries: (1) session-start token, (2) /prime single-snapshot RECURRING, (3) /session-plan sparse template. Run from the ai-resources directory. Apply standard archive/update logic per the skill.

### 3. [med] /cleanup-worktree — ai-resources (4 modified, 8 untracked)
- **Source:** checkup
- **Risk-check required:** no
- **W2.4 auto-draft:** no
- **Detail:** ai-resources working tree has 4 modified files and 8 untracked files — mostly this session's audit artifacts (risk-check reports, repo-health reports). Run `/cleanup-worktree` to inventory, classify, and commit/discard. Expected: stage and commit audit artifacts; verify no sensitive files are staged.

### 4. [med] /cleanup-worktree — workspace root (1 modified, 21 deleted, 86 untracked — investigate before bulk action)
- **Source:** checkup
- **Risk-check required:** no
- **W2.4 auto-draft:** no
- **Detail:** Workspace root has 21 deleted files under `projects/personal/*` and 86 untracked files. Recent commits show an ongoing untracking pattern (`84d3103`). **Investigate before bulk action:** confirm the `projects/personal/*` deletions are intentional (likely moved or archived elsewhere). Run `/cleanup-worktree` with investigate-first posture — do not bulk-delete or bulk-stage without reviewing each category. Autonomy rule: confirm intentional before any destructive cleanup.

### 5. [low] Fix 2 hardcoded absolute paths in ai-resources/.claude/settings.json
- **Source:** checkup
- **Risk-check required:** yes — change class: settings.json
- **W2.4 auto-draft:** no
- **Detail:** The `/audit-repo` scan flagged 2 hardcoded absolute paths in `ai-resources/.claude/settings.json`. Locate the offending lines, replace with relative paths or environment-variable references consistent with the canonical permission-template.md pattern. Run `/risk-check` before editing.

### 6. [low] Archive ai-resources/logs/usage-log.md (652 lines, Cat B over 500-line threshold)
- **Source:** checkup
- **Risk-check required:** no
- **W2.4 auto-draft:** no
- **Detail:** `usage-log.md` is 652 lines, over the Cat B 500-line threshold. Re-run `/log-sweep` without `--dry-run` to execute the archive action. The dry-run report (`audits/log-sweep-2026-05-16.md`) is the evidence basis — no re-audit needed, just execute.

## Execution notes
- Commit each fix separately (workspace commit-behavior rules).
- Item 1 (git push) requires explicit operator approval at execution time (autonomy rule #2) — this plan item is that approval.
- Item 4 (workspace cleanup) must investigate before bulk action — do not skip the investigation step.
- For item 5 (settings.json), run `/risk-check` before executing.
- Run `/wrap-session` when all items in this plan are done.
