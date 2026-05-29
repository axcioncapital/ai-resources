# Friday Act Plan — 2026-05-29 — project-triages

**Source report:** friday-checkup-2026-05-29.md (weekly tier)
**Journal report:** ai-resources/audits/friday-journal-2026-05-29.md
**Generated:** 2026-05-29
**Items:** 3

## Items

### 1. [med] Triage + dispatch fixes for 5 ai-development-lab improvement-log entries. Themes: ambiguous-referent self-check, concurrent-session staging detection, mid-session staleness of clean-tree snapshot, friction-log Write Activity capture gap, pipeline write-deny rationale doc
- **Source:** checkup
- **Risk-check required:** no — sub-fixes may trigger per-item /risk-check at execution time
- **W2.4 auto-draft:** no

### 2. [med] Triage + dispatch fixes for 3 axcion-brand-book improvement-log entries. Themes: `/draft-module` heredoc routing for cached-deny modules, brand-strategist subagent contract (notes-to-disk), per-module allow-override CLAUDE.md pointer
- **Source:** checkup
- **Risk-check required:** no — sub-fixes may trigger per-item /risk-check at execution time
- **W2.4 auto-draft:** no

### 3. [med] Triage + dispatch fixes for 6 nordic-pe-macro improvement-log entries (incl. 2 RECURRING). Themes: RECURRING check-archive.sh `CLAUDE_PROJECT_DIR` (5+ wraps), RECURRING wrap-session today-header inflation (7 headers/day, 4 days running), settings.json `_comment` schema rejection, `/innovation-sweep` triage cadence, `/session-plan` Step 0 verification, cross-repo write under project mandate
- **Source:** checkup
- **Risk-check required:** no — sub-fixes may trigger per-item /risk-check at execution time
- **W2.4 auto-draft:** no

## Execution notes
- Commit each fix separately (workspace commit-behavior rules).
- The two RECURRING items inside #3 are high-priority within the triage — fix first.
- Each project-internal triage opens with reading the source `logs/improvement-log.md` and confirming the listed entries are still active.
- For any sub-fix that touches a `/risk-check` change class (hook file, settings.json, CLAUDE.md, new command/skill, new symlink, cross-repo automation), run `/risk-check` before applying.
- Run `/wrap-session` when all items in this plan are done.
