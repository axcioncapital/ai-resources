# Permission Sweep Report — 2026-05-08 (v2, restricted scope, applied)

**Companion to:** `permission-sweep-2026-05-08.md` (earlier dry-run from /friday-checkup, full workspace).
**Mode:** apply.
**Scope:** operator-restricted — user-level, workspace root `.claude/`, `ai-resources/`, `projects/global-macro-analysis/` only.

## Summary

- Scanned 7 settings files (vs. 22 in the morning dry-run).
- Findings: 0 CRITICAL, 0 HIGH, 2 MEDIUM, 5 ADVISORY, 0 INTENTIONAL-NARROW.
- Applied: 3 (Findings 4, 6, 7). Deferred: 4 (Findings 1, 2, 3, 5).

## Findings applied

| # | File | Rule | Severity | Change |
|---|------|------|----------|--------|
| 4 | `.claude/settings.json` (workspace root) | 13 | ADVISORY | Consolidated allow list 67 → 22 entries. Removed scoped Bash narrows subsumed by `Bash(*)`, removed scoped Edit/Write paths subsumed by absolute workspace path, removed tilde paths subsumed by bare `Edit`/`Write`. Preserved `Bash(git push *)` and `~/.claude/projects/**` entries (load-bearing for current setup). |
| 6 | `ai-resources/.gitignore` | 14 | ADVISORY | Added `archive/` (top-level). Closes gap where Layer C settings denied `Read(archive/**)` but the directory was not gitignored. |
| 7 | `projects/global-macro-analysis/.gitignore` (created) | 14 | ADVISORY | Created `.gitignore` with `archive/`. Project previously had no `.gitignore` at all. |

## Findings deferred

| # | File | Rule | Severity | Reason |
|---|------|------|----------|--------|
| 1 | `~/.claude/settings.json` | 11 | MEDIUM | Operator policy ("never add to deny list" memory note) overrides template. |
| 2 | `.claude/settings.json` (workspace root) | 11 | MEDIUM | Same as #1. |
| 3 | `.claude/settings.json` (tilde paths) | 13 | ADVISORY | Resolved indirectly by Finding 4 — tilde entries removed as redundant during consolidation. Effectively applied. |
| 5 | `~/.claude/settings.json` (`NotebookEdit(**)`) | 13 | ADVISORY | Cosmetic only; bypass mode renders entry shape informational. |

## Outstanding question (preserved verbatim)

Workspace root allow list contains `Bash(git push *)`. The morning dry-run report Finding 6 also flagged this — current run preserved it without resolving. Operator gating on push lives at the model side per CLAUDE.md Autonomy Rules #2, not the permission layer. No structural risk in either direction; flag for next sweep if you want it removed.

## Conflict noted

The improvement-log has an open entry from earlier scoping `/new-project` to write a canonical deny block for new projects (logs/improvement-log.md:25–32). This conflicts with the operator-policy memory note "never add to deny list". The improvement-log entry is effectively obsolete given current policy and should be reviewed at next `/resolve-improvement-log`.

## Full diagnostic notes

`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/permission-sweep-2026-05-08.md`

## Prevention

- SessionStart hook `check-permission-sanity.sh` flags primary root cause on session start.
- `/new-project` pipeline emits canonical template for every new project.
- `/friday-checkup` weekly rotation runs `/permission-sweep --dry-run` to catch drift.
