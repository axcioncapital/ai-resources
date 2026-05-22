# Friday Act Plan — 2026-05-22 — session-plan

**Source report:** friday-checkup-2026-05-22.md (weekly tier)
**Journal report:** (none)
**Generated:** 2026-05-22
**Items:** 1

## Items

### 1. [high] nordic-pe HIGH — port 3 verified /session-plan edits (Step 0/1/7) into project-LOCAL .claude/commands/session-plan.md; add "local commands verify per-copy" rule to improvement-log
- **Source:** checkup
- **Risk-check required:** no — editing an existing command file is not a canonical /risk-check change class (the class is "new commands or skills"); /risk-check is operator-discretionary here
- **W2.4 auto-draft:** no
- **Context:** Improvement-log entries #2/#3/#6 were marked `applied`+`Verified` against the canonical `ai-resources` copy, but `session-plan` is a `local` command in `shared-manifest.json` — auto-sync skips it. The project copy at `.claude/commands/session-plan.md` was never patched. Three edits to port: (a) Step 0 freshness check, (b) Step 1 timestamp display, (c) Step 7 `Class:`-replace dedup. Confirmed by both `/improve` and `/coach` independent runs.
- **Target files:**
  - `projects/nordic-pe-macro-landscape-H1-2026/.claude/commands/session-plan.md`
  - `projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md` (add "local commands verify per-copy" standing rule)

## Execution notes
- Commit each fix separately (workspace commit-behavior rules).
- For any item marked "Risk-check required: yes", run `/risk-check` before executing that item.
- Run `/wrap-session` when all items in this plan are done.
