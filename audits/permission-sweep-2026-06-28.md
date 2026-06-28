# Permission Sweep Report — 2026-06-28

## Summary

- Scanned 46 settings files across 5 layers (A, B, B′, C, D/D′).
- Findings: 3 CRITICAL, 1 HIGH, 0 MEDIUM, 22 ADVISORY, 0 INTENTIONAL-NARROW.
- Applied: 16 (mission `settings-path-portability` retrofit only). Deferred: 26. Skipped INTENTIONAL-NARROW: 0.
- Run context: invoked from the `axcion-copy-factory` session to close the mission's "retrofit already-deployed projects" open thread. Only the portability-defect findings (Rule 8 / Rule 9 absolute paths) were in mission scope; all other findings were deferred as out-of-scope.

## Findings applied (mission retrofit)

The canonical Rule 8 / Layer D′ fix was applied to each: `additionalDirectories` removed from the tracked `settings.json`; the grant relocated to the sibling gitignored `settings.local.json` with `defaultMode: bypassPermissions` (this machine's workspace-root path). All 16 local files verified gitignored; all 16 tracked files verified to carry zero `/Users/` paths after the edit.

| # | File (relative to workspace root) | Rule | Severity | Change |
|---|-----------------------------------|------|----------|--------|
| 1 | projects/nordic-pe-screening-project/.claude/settings.json | 8 | ADVISORY | additionalDirectories relocated to local |
| 2 | projects/nordic-pe-macro-landscape-H1-2026/.claude/settings.json | 8 | ADVISORY | additionalDirectories relocated to local |
| 3 | projects/ai-development-lab/.claude/settings.json | 8 | ADVISORY | additionalDirectories relocated to local |
| 4 | projects/nordic-pe-landscape-mapping-4-26/.claude/settings.json | 8 | ADVISORY | additionalDirectories relocated to local |
| 5 | projects/repo-documentation/.claude/settings.json | 8 | ADVISORY | additionalDirectories relocated to local |
| 6 | projects/axcion-ai-system-owner/.claude/settings.json | 8 | ADVISORY | additionalDirectories relocated to local |
| 7 | projects/global-macro-analysis/.claude/settings.json | 8 | ADVISORY | additionalDirectories relocated to local |
| 8 | projects/project-planning/.claude/settings.json | 8 | ADVISORY | additionalDirectories relocated to local |
| 9 | projects/buy-side-service-plan/.claude/settings.json | 8 | ADVISORY | additionalDirectories relocated to local (existing model key preserved) |
| 10 | projects/strategic-os/.claude/settings.json | 8 | ADVISORY | additionalDirectories relocated to local |
| 11 | projects/obsidian-pe-kb/.claude/settings.json | 8 | ADVISORY | additionalDirectories relocated to local |
| 12 | projects/personal/travel-os/.claude/settings.json | 8 | ADVISORY | additionalDirectories relocated to local |
| 13 | projects/nordic-pe-landscape-mapping-4-26/step-1-long-list/.claude/settings.json | 8 | ADVISORY | additionalDirectories relocated to local |
| 14 | projects/repo-documentation/vault/.claude/settings.json | 8 | ADVISORY | additionalDirectories relocated to local |
| 15 | projects/axcion-ai-system-owner/vault/.claude/settings.json | 8 | ADVISORY | additionalDirectories relocated to local |
| 16 | projects/interpersonal-communication/knowledge-base/.claude/settings.json | 9 | HIGH | Daniel's stale absolute path removed from tracked; this-machine path written to gitignored local |

## Findings deferred (not applied this run)

### Blocked by the copy-factory cross-project Edit boundary (mission scope — need a workspace-root session)

| File | Rule | Severity | Reason |
|------|------|----------|--------|
| projects/marketing-positioning/.claude/settings.json | 8 | ADVISORY | Edit denied to upstream identity project from copy-factory session |
| projects/corporate-identity/.claude/settings.json | 8 | ADVISORY | Edit denied to upstream identity project from copy-factory session |
| projects/axcion-brand-book/.claude/settings.json | 8 | ADVISORY | Edit denied to upstream identity project from copy-factory session |

### Out of mission scope (config-hygiene of absolute paths only)

| File | Rule | Severity | Reason deferred |
|------|------|----------|-----------------|
| projects/interpersonal-communication/.claude/settings.json | 2, 4, 5 | CRITICAL | `defaultMode: default` + no Bash/Edit allow — documented intentional (Daniel's safe baseline); mission excludes allow/deny semantics |
| projects/interpersonal-communication/.claude/settings.json | 13 | ADVISORY | colon-form Bash denies; `_comment` inside permissions object (schema risk) |
| ~/.claude/settings.json | 13 | ADVISORY | empty deny list (no `Bash(rm -rf *)` / `Bash(sudo *)` floor) |
| ai-resources/.claude/settings.json | 13 | ADVISORY | overlapping `Read(logs/...)` deny patterns |
| 16× project settings.json (Findings 10–25) | 14 | ADVISORY | `Read(archive/**)` deny without `archive/` gitignored; `buy-side-service-plan` highest (dir exists). Separate hygiene batch. |

## Intentional-narrow files (excluded)

- None detected.

## Full diagnostic notes

ai-resources/audits/working/permission-sweep-2026-06-28.md

## Mission `settings-path-portability` status after this run

- Retrofit open thread is now substantially closed: 16 of 19 portability defects fixed (15 of 18 Rule-8 Patrik-path files + the 1 Rule-9 Daniel-path file).
- Remaining: 3 upstream-identity files (marketing-positioning, corporate-identity, axcion-brand-book) require a workspace-root session — the copy-factory boundary denies edits to them by design.
- Standing thread: per-push operator approval is still required (mission non-negotiable).

## Prevention (already in place from prior mission sessions)

- `/new-project`, `/permission-sweep` Rule 8, `/deploy-workflow` all write the grant to gitignored `settings.local.json`, never tracked.
- Invariant doc: `ai-resources/docs/settings-portability-invariant.md`.
- Recovery snippet: `ai-resources/docs/settings-local-recovery.md`.
