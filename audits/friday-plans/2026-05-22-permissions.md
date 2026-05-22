# Friday Act Plan — 2026-05-22 — permissions

**Source report:** friday-checkup-2026-05-22.md (weekly tier)
**Journal report:** (none)
**Generated:** 2026-05-22
**Items:** 4

## Items

### 1. [high] Add "Bash(rm *)" to projects/ai-development-lab/.claude/settings.json allow list
- **Source:** checkup
- **Risk-check required:** yes — change class: settings.json
- **W2.4 auto-draft:** no

### 2. [high] Add "Bash(rm *)" to projects/axcion-brand-book/.claude/settings.json allow list
- **Source:** checkup
- **Risk-check required:** yes — change class: settings.json
- **W2.4 auto-draft:** no

### 3. [med] Remove the "model": "sonnet" field from ~/.claude/settings.json — Model Tier policy violation
- **Source:** checkup
- **Risk-check required:** yes — change class: settings.json (user-level)
- **W2.4 auto-draft:** no

### 4. [low] Add Edit(**/.claude/**) + Write(**/.claude/**) + NotebookEdit to ai-development-lab and axcion-brand-book settings.json (advisory hardening)
- **Source:** checkup
- **Risk-check required:** yes — change class: settings.json
- **W2.4 auto-draft:** no

## Execution notes
- Run `/permission-sweep` without `--dry-run` to batch items 1–4 in one approved pass per the checkup's recommendation — this generates a consolidated fix that covers all four items.
- Commit each scope's settings.json fix separately (workspace commit-behavior rules).
- For any item marked "Risk-check required: yes", run `/risk-check` before executing that item.
- Run `/wrap-session` when all items in this plan are done.
