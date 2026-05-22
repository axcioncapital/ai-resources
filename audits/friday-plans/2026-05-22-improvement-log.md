# Friday Act Plan — 2026-05-22 — improvement-log

**Source report:** friday-checkup-2026-05-22.md (weekly tier)
**Journal report:** (none)
**Generated:** 2026-05-22
**Items:** 3

## Items

### 1. [med] Triage the 11 other /improve findings logged this checkup across ai-resources / global-macro / nordic-pe improvement-logs
- **Source:** checkup
- **Risk-check required:** no
- **W2.4 auto-draft:** no
- **Context:** The checkup generated 13 new improvement-log entries total (4 ai-resources + 4 global-macro + 5 nordic-pe). The 2 HIGH items (nordic-pe session-plan, global-macro concurrent-session hook) are in their own plan files. The remaining 11 are:
  - **ai-resources** (improvement-log.md): stub-detection for friction log (#3 2026-05-22), note.md/friction-log incompatible session headers (#4 2026-05-22), no friction-entry context capture (#5 2026-05-22), workflow-diagnosis/improvement-analyst boundary (#6 2026-05-22)
  - **global-macro** (projects/global-macro-analysis/logs/improvement-log.md): /kb-review Step 5 auto-skip gate (#1), /kb-review Step 7 registry-stub spec (#3 2026-05-22), Operator Note placeholders in auto-file branch (#4 2026-05-22), settings.local.json missing CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING (#5 2026-05-22), /prime re-derived stale state (#6 2026-05-22)
  - **nordic-pe** (projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md): friction logger misattributes /session-plan re-invocation to hook (#RECURRING 2026-05-22), chapter-review presentation rule at wrong layer (#4 2026-05-22), backup-session-plan.sh gap (#5 2026-05-22), settings.json redundant rm entry (#6 2026-05-22)
- **Action:** Read each improvement-log, assess each entry, and queue the highest-value ones into follow-up sessions. Do not execute fixes in the triage session — read, assess, and annotate only.

### 2. [med] bright-line-review gate rubber-stamp — name specific bright-line before reviewing, or retire/recalibrate via gate-calibration.md
- **Source:** checkup
- **Risk-check required:** no
- **W2.4 auto-draft:** no
- **Context:** `/coach` ai-resources flagged this for the 4th consecutive cycle: the `bright-line-review` gate is a rubber-stamp (78% confirm rate, no meaningful check). Per `gate-calibration.md` protocol: either name the exact bright-line being checked before each review, or log a calibration decision (retire vs. recalibrate vs. narrow scope). Read `gate-calibration.md` and make a logged decision.
- **Target files:**
  - `ai-resources/logs/gate-calibration.md`

### 3. [med] 2 ai-resources improvement-log entries (/wrap-session leaner, permission-sweep-auditor) re-deferred 2026-05-18 — schedule dedicated session rather than deferring a 3rd time
- **Source:** checkup
- **Risk-check required:** no
- **W2.4 auto-draft:** no
- **Context:** Entries logged 2026-04-25 (/wrap-session leaner) and 2026-04-28 (permission-sweep-auditor template classification) were both reviewed and deferred on 2026-05-18 with notes. A 3rd deferral wastes cycles. Schedule one dedicated session for both (they're small: /wrap-session leaner = command-flow edit ~1h; permission-sweep-auditor = agent definition edit ~30min + /risk-check).
- **Action:** Book the session explicitly — log a `review-cycle` entry in improvement-log.md with a target session date, not another "deferred" annotation.

## Execution notes
- Commit each fix separately (workspace commit-behavior rules).
- For any item marked "Risk-check required: yes", run `/risk-check` before executing that item.
- Run `/wrap-session` when all items in this plan are done.
