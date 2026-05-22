# Friday Act Plan — 2026-05-22 — check-concurrent-session

**Source report:** friday-checkup-2026-05-22.md (weekly tier)
**Journal report:** (none)
**Generated:** 2026-05-22
**Items:** 1

## Items

### 1. [high] global-macro RECURRING — build concurrent-session detection hook (improvement-log #3, leaked 3×); requires operator approval per Autonomy Rule #8
- **Source:** checkup
- **Risk-check required:** yes — change classes: hook file (.sh), settings.json (hook registration)
- **W2.4 auto-draft:** no
- **Context:** Concurrent-session friction recurred on 2026-05-20 (stale `/prime` read + a wrap commit landing mid-session). This is the 3rd occurrence of the same root cause. The proposed fix: add `PreToolUse` hook at `.claude/hooks/check-concurrent-session.sh` that runs before `/kb-synthesize` and `/kb-review` writes; checks `git status --porcelain macro-kb/<theme>/` and recent mtime against a session-start marker; emits `{"decision":"ask",...}` on detected concurrent activity. Also add a CLAUDE.md § Operational Notes line on parallel-session discipline.
- **⚠️ AUTONOMY RULE #8 — harness-level config change.** Present this plan to operator and obtain explicit approval before implementing. Do NOT execute the hook build without operator sign-off.
- **Target files:**
  - `projects/global-macro-analysis/.claude/hooks/check-concurrent-session.sh` (new)
  - `projects/global-macro-analysis/.claude/settings.json` (hook registration)
  - `projects/global-macro-analysis/CLAUDE.md` (parallel-session discipline note)

## Execution notes
- **Stop at session start and confirm operator approval for Rule #8 before any file writes.**
- Run `/risk-check` on the hook addition before executing.
- Commit each change separately (workspace commit-behavior rules).
- Run `/wrap-session` when all items in this plan are done.
