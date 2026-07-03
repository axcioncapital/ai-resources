# Friday Act Plan — 2026-07-03 — git-remote

**Source report:** friday-checkup-2026-07-03.md (quarterly tier)
**Journal report:** (none)
**Generated:** 2026-07-03
**Items:** 1

## Items

### 1. [high] Fix the broken workspace-root git remote (`axcioncapital/workspace-root.git` not found)
- **Source:** checkup
- **Risk-check required:** no (git remote config, not a settings.json/hook/CLAUDE.md/new-command/symlink change)
- **W2.4 auto-draft:** no
- High-impact / trivial fix — flagged 2026-06-16, still open. `git remote -v` at the workspace root returns "Repository not found" for `axcioncapital/workspace-root.git`; workspace-root commits are unpushable every session. Diagnose whether the remote was renamed, deleted, or the local remote URL is simply wrong (check for a rename on the GitHub side, or a typo/stale URL in `git remote get-url origin`), then `git remote set-url` (or re-add) to the correct address.

## Execution notes
- Commit separately (a `.git/config` change isn't itself a tracked-file commit, but verify no other change lands in the same commit).
- No risk-check flagged — pure git plumbing, no shared-state or permission-surface change.
- Verify the fix by running `git push --dry-run` (or an actual push if commits are queued) after the remote is corrected.
- Run `/wrap-session` when done.
