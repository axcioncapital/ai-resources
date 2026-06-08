# Permission Sweep Report — 2026-06-03

## Summary

- Scanned 12 settings files across 5 layers (A, B, B′, C, D/D′).
- Findings: 3 CRITICAL actionable (+3 intentional-narrow), 2 HIGH actionable (+1 template-exempted, +2 narrow), 1 MEDIUM, 7 ADVISORY actionable (+4 narrow).
- Applied: 1. Deferred: rest (out of session scope). Skipped INTENTIONAL-NARROW: not stripped — operator explicitly overrode for the one applied file.

Session scope was narrowed by the operator to **this copy project only** (`interpersonal-communication-copy`). Cross-repo and other-project findings were surfaced for awareness but not actioned.

## Findings applied

| # | File | Rule | Severity | Change |
|---|------|------|----------|--------|
| 1 | projects/interpersonal-communication-copy/.claude/settings.local.json | 1/2 | CRITICAL [NARROW, operator-overridden] | Added `"defaultMode": "bypassPermissions"` to permissions block (38→39 lines) |

### Conflict note (resolved by operator)

The auditor tagged this copy project's settings as **INTENTIONAL-NARROW** (path-scoped allow, narrow bash list, no `Bash(*)`) and excluded them from default remediation. The SessionStart `check-permission-sanity.sh` hook flagged the same file as a shadowing `defaultMode` gap. Operator was presented the conflict explicitly — adding `bypassPermissions` flips the copy from "ask before most actions" to "never ask" — and chose **Add bypassPermissions** to match the no-prompt posture of the other projects. Applied on that explicit override.

## Findings deferred (not approved this run — outside session scope)

| File | Rule | Severity | Reason |
|------|------|----------|--------|
| ai-resources/.claude/settings.local.json | 1 | CRITICAL | Real defaultMode gap in shared repo; cross-repo edit + push, not in this session's scope |
| projects/interpersonal-communication/.claude/settings.json | 9 | HIGH | Stale `/Users/patrik.lindeberg/` additionalDirectories path; other project tree |
| projects/nordic-pe-macro-landscape-h1-2026/.claude/settings.json | 9 | HIGH | Same stale patrik path; other project tree |
| projects/nordic-pe-macro-landscape-h1-2026/.claude/settings.json | 13 | ADVISORY | Prohibited `"model"` field present; other project tree |
| projects/{interpersonal-communication,nordic-pe-macro,project-planning}/.claude/settings.json | 14 | ADVISORY | `Read(archive/**)` deny with no `archive/` in .gitignore |
| workspace-root/.claude/settings.local.json | 13 | ADVISORY | Double-slash `//` path syntax, diagnostic-session remnant |
| projects/project-planning/.claude/settings.json | 13 | ADVISORY | Prohibited `"model": "sonnet[1m]"` field present |

## Intentional-narrow files

- projects/interpersonal-communication-copy/.claude/settings.json — left as-is (no permissions-block edit; only the sibling settings.local.json was touched, per operator).

## Full diagnostic notes

/Users/danielniklander/Axcion Claude Code/Axcion AI Repo/ai-resources/audits/working/permission-sweep-2026-06-03.md

## Prevention

- SessionStart hook `check-permission-sanity.sh` flags the primary root cause on session start.
- `/new-project` pipeline emits the canonical template for every new project.
- `/friday-checkup` weekly rotation runs `/permission-sweep --dry-run` to catch drift.
