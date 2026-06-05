# Friday Act Plan — 2026-06-05 — repo-hygiene

**Source report:** friday-checkup-2026-06-05.md (monthly tier)
**Journal report:** (none)
**Generated:** 2026-06-05
**Items:** 5

## Items

### 1. [med] Investigate DR-1 project-local hook duplicates (research-pe 14, buy-side 5) — add manifest hooks exception or consolidate
- **Source:** checkup
- **Risk-check required:** yes — change class: hook files (.sh) / hook manifest
- **W2.4 auto-draft:** no

DR-1 principles warning: project-local hook duplicates without a manifest exception (research-pe has 14 local hooks, buy-side 5). Investigate whether these should be consolidated to canonical hooks or declared via a manifest hooks-exception. Touches hook files and/or the hook manifest → run `/risk-check` before changing any hook wiring.

### 2. [med] Merge or re-run the marketing-positioning Stage 4 scaffold stranded in worktree `worktree-agent-ab9fa135d0fd661f6`
- **Source:** checkup
- **Risk-check required:** no — git worktree merge/re-run (destructive-git autonomy gate applies at execution, not /risk-check)
- **W2.4 auto-draft:** no

The marketing-positioning Stage 4 content scaffold ran in an UNMERGED worktree (`worktree-agent-ab9fa135d0fd661f6`); its logs/CLAUDE.md/output are absent in the live checkout, which also blocked `/coach` (INSUFFICIENT DATA). Merge the worktree or re-run the scaffold in the live checkout. A merge is a git operation governed by the destructive-git autonomy gate at execution — inspect the worktree contents before merging.

### 3. [med] [SESSION-ISSUE] `/fix-symlinks` blind to "regular-file-where-symlink-expected" drift (2026-06-02) — decide: fix, defer, or close
- **Source:** checkup
- **Risk-check required:** no
- **W2.4 auto-draft:** no

`/fix-symlinks` does not detect the case where a regular file sits where a symlink is expected (logged 2026-06-02). Decide at execution whether to fix (extend the scan to flag regular-file-where-symlink-expected drift), defer, or close. Command-text edit to `/fix-symlinks`; no risk-check class.

### 4. [med] `/cleanup-worktree` — both repos dirty (ai-resources pre-existing drift; workspace-root 5 M incl. modified CLAUDE.md)
- **Source:** checkup
- **Risk-check required:** no
- **W2.4 auto-draft:** no

Both repos carry dirty working-tree drift beyond this run's reports (ai-resources several modified files; workspace-root 5 modified incl. a modified CLAUDE.md). Run `/cleanup-worktree` to investigate the dirty paths, plan a safe cleanup with independent QC, and disposition each. Hygiene action; no risk-check class (the cleanup command runs its own QC + triage).

### 5. [med] `git push` — ai-resources: unpushed commits
- **Source:** checkup
- **Risk-check required:** no — push is gated by the wrap-session push confirmation (external-write autonomy gate), not /risk-check
- **W2.4 auto-draft:** no

ai-resources has multiple unpushed commits (the checkup counted 9; this session adds more). Push is gated and batched — it happens at session wrap behind the single operator push confirmation, NOT mid-session and NOT via /risk-check. NOTE: the local branch is currently diverged from origin/main (1 unmerged remote commit), so the pre-push reconciliation from the session-harness plan item 1 must be resolved (fetch + rebase) before the push can fast-forward.

## Execution notes
- Commit each fix separately (workspace commit-behavior rules).
- For any item marked "Risk-check required: yes", run `/risk-check` before executing that item.
- For any item marked "W2.4 auto-draft: yes", decide auto-draft vs. manual at execution time per the W2.4 sub-disposition in the `/friday-act` Step 3 W2.4 instructions.
- Run `/wrap-session` when all items in this plan are done.
