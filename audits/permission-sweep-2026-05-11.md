# Permission Sweep Report — 2026-05-11

## Summary

- Scanned 26 settings files across 5 layers (user, workspace, ai-resources, projects, workflows).
- Findings: 4 CRITICAL, 5 HIGH, 4 MEDIUM, 2 ADVISORY, 0 INTENTIONAL-NARROW.
- Applied: 0. Deferred: all. Fixes scheduled for next session.

---

## Findings deferred (all — fix next session)

### CRITICAL

| # | File | Rule | Change |
|---|------|------|--------|
| 1 | projects/axcion-ai-system-owner/vault/.claude/settings.json | Rule 2 | Add `"defaultMode": "bypassPermissions"` |
| 2 | ai-resources/.claude/settings.json | Rule 4 | Add 14 missing allow entries: Read, Agent, Glob, Grep, Skill, TodoWrite, ToolSearch, WebFetch, WebSearch, NotebookEdit, Edit(**/.claude/**), Write(**/.claude/**), Edit(abs/**), Write(abs/**) |
| 3 | projects/repo-documentation/vault/.claude/settings.json | Rule 3 | Add `"Edit(**/.claude/**)"` and `"Write(**/.claude/**)"` |
| 4 | projects/axcion-ai-system-owner/vault/.claude/settings.json | Rule 3 | Add `"Edit(**/.claude/**)"` and `"Write(**/.claude/**)"` |

### HIGH

| # | File | Rule | Change |
|---|------|------|--------|
| 5 | projects/axcion-ai-system-owner/vault/.claude/settings.json | Rule 6 | Add `"Bash(rm *)"` to allow |
| 6 | projects/repo-documentation/vault/.claude/settings.json | Rule 6 | Add `"Bash(rm *)"` to allow |
| 7 | projects/axcion-ai-system-owner/vault/.claude/settings.json | Rule 8 | Add `"additionalDirectories": ["/Users/patrik.lindeberg/Claude Code/Axcion AI Repo"]` |
| 8 | ai-resources/workflows/research-workflow/.claude/settings.json | Rule 9 | Replace `{{WORKSPACE_ROOT}}` with literal path (week-mandate item 5) |
| 9 | projects/repo-documentation/vault + axcion-ai-system-owner/vault | Rule 4 | Add missing bare-tool entries: Agent, MultiEdit, NotebookEdit, ToolSearch, WebFetch, WebSearch |

### MEDIUM

| # | File | Rule | Change |
|---|------|------|--------|
| 10 | ~/.claude/settings.json | Rule 11 | Add `"Bash(rm -rf *)"` and `"Bash(sudo *)"` to deny list |
| 11 | workspace root .claude/settings.json | Rule 11 | Add deny array: `["Bash(rm -rf *)", "Bash(sudo *)", "Bash(git reset --hard *)", "Bash(git checkout *)"]` |
| 12 | workspace root .claude/settings.json | Rule 11 | Remove `"Bash(git push *)"` from allow — **needs operator decision** (may be intentional) |
| 13 | projects/nordic-pe-landscape-mapping-4-26/step-1-long-list/.claude/settings.json | Rule 11 | Add deny array with 7 canonical Layer D entries |

### ADVISORY

| # | File | Rule | Change |
|---|------|------|--------|
| 14 | workspace root .claude/settings.json | Rule 13 | Syntax: `"Bash(git push *)"` → `"Bash(git push*)"` (only relevant if #12 is kept) |
| 15 | projects/axcion-ai-system-owner/.claude/settings.json | Rule 13 | SKIPPED — model field in settings.json: operator rule prohibits touching |

---

## Intentional-narrow files

None detected.

---

## Notes

- Finding 12 (workspace root allow: `Bash(git push *)`) needs operator decision before applying. Recommendation: remove — push is already covered by `Bash(*)`, and manual push-approval autonomy rule still applies.
- Finding 8 (research-workflow `{{WORKSPACE_ROOT}}`) is authorized by week-mandate item 5; apply as part of settings item fix session.
- Finding 15 (model field `"sonnet"` → `"sonnet[1m]"` in axcion-ai-system-owner) skipped per operator rule: never add or modify model field in settings.json.

## Full diagnostic notes

ai-resources/audits/working/permission-sweep-2026-05-11.md
