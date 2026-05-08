# Friday Act Plan — 2026-05-08 — cleanup-worktree

**Source report:** friday-checkup-2026-05-08.md (weekly tier)
**Journal report:** ai-resources/audits/friday-journal-2026-05-08.md
**Generated:** 2026-05-08
**Items:** 1

## Items

### 1. [med] `/cleanup-worktree` — working tree dirty (3 modified, 12 untracked)
- **Source:** checkup
- **Risk-check required:** no
- **W2.4 auto-draft:** no

Run `/cleanup-worktree` to investigate dirty paths and plan safe cleanup with QC + triage. Items at session-start include:
- Modified: `.claude/commands/clarify.md`, `logs/session-plan.md`
- Untracked: 8 risk-check audit files (`audits/risk-checks/2026-04-29*`, `2026-04-30*`, `2026-05-04*`), 1 repo-dd audit, 1 workflow `session-plan.md`, the new plan files generated this session

Note: this session's plan files (`audits/friday-plans/2026-05-08-*.md`) and the `friday-journal-2026-05-08.md` report are work-in-progress for this Friday — confirm they are committed (not cleaned) before running. Sequencing: run this item LAST so the other plan-file commits land first.

## Execution notes
- Commit each fix separately (workspace commit-behavior rules).
- For any item marked "Risk-check required: yes", run `/risk-check` before executing that item.
- For any item marked "W2.4 auto-draft: yes", decide auto-draft vs. manual at execution time per the W2.4 sub-disposition in the `/friday-act` Step 3 W2.4 instructions.
- Run `/wrap-session` when all items in this plan are done.
