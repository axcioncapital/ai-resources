# Permission Sweep Report — 2026-05-19

## Summary

- Scanned 25 settings files across 5 layers (user-level, workspace root, ai-resources, 11 projects, 1 workflow).
- Findings: 1 CRITICAL, 1 HIGH, 2 MEDIUM, 2 ADVISORY, 0 INTENTIONAL-NARROW.
- Applied: 3 file edits (covering all 6 findings). Deferred: 0. Skipped INTENTIONAL-NARROW: 0.

## Findings applied

| # | File | Rule | Severity | Change |
|---|------|------|----------|--------|
| 1 | `ai-resources/.claude/settings.local.json` | Rule 1 / Rule 13 | CRITICAL + ADVISORY | Removed entire permissions block (stale one-time bash entries; no defaultMode) |
| 2 | `.claude/settings.json` | Rule 7 / Rule 11 / Rule 13 | HIGH + MEDIUM + ADVISORY | Moved `Bash(git push*)` from allow → deny; added canonical deny floor `["Bash(rm -rf *)", "Bash(sudo *)", "Bash(git reset --hard *)", "Bash(git checkout *)", "Bash(git push*)"]` |
| 3 | `~/.claude/settings.json` | Rule 11 | MEDIUM | Added `["Bash(rm -rf *)", "Bash(sudo *)"]` to previously-empty deny list |

## Findings deferred (not approved this run)

None — operator approved all findings.

## Intentional-narrow files (excluded)

None detected. The known `projects/obsidian-pe-kb/vault/.claude/settings.json` does not exist on disk.

## Sidebar note (not a detection-rule finding)

`~/.claude/settings.json` contains `"model": "sonnet[1m]"` at the top level. The workspace CLAUDE.md prohibits model declarations in any settings file. Left untouched by this sweep — warrants a separate cleanup.

## Full diagnostic notes

`ai-resources/audits/working/permission-sweep-2026-05-19.md`

## Prevention

- SessionStart hook `check-permission-sanity.sh` flags the primary root cause on session start (wired in: ai-development-lab, axcion-brand-book, nordic-pe-macro-landscape-H1-2026, interpersonal-communication, axcion-ai-system-owner).
- `/new-project` pipeline emits the canonical template for every new project.
- `/friday-checkup` weekly rotation runs `/permission-sweep --dry-run` to catch drift.
