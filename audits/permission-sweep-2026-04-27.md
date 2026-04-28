# Permission Sweep Report — 2026-04-27

## Scope

Operator-narrowed: ai-resources/ only (not user-level, workspace root, or projects/*).

## Summary

- Scanned 2 settings files.
- Findings: 0 CRITICAL, 1 HIGH, 2 MEDIUM, 4 ADVISORY, 0 INTENTIONAL-NARROW.
- Applied: 4. Closed as N/A: 2. Held: 1.

## Findings applied

| # | File | Rule | Severity | Change |
|---|------|------|----------|--------|
| 4 | `ai-resources/.claude/settings.json` | 13 | ADVISORY | Removed 6 redundant narrow `Bash` entries (`git add *`, `git commit *`, `git restore *`, `chmod *`, `mkdir *`, `cp *`) — covered by `Bash(*)` |
| 5 | `ai-resources/.claude/settings.json` | 13 | ADVISORY | Removed 28 redundant path-scoped `Edit`/`Write` entries — covered by bare `Edit`/`Write`/`MultiEdit` |
| 6 | `ai-resources/.gitignore` | 14 | ADVISORY | Appended `inbox/archive/` (matches the `Read(inbox/archive/**)` deny rule) |
| F | `ai-resources/.claude/settings.json` | — | (operational) | Removed `Read(audits/working/**)` deny rule that broke `/permission-sweep` Step 4 (main session could not read its own auditor's summary). Subagent-contract discipline now lives in CLAUDE.md only, not as a permission deny. |

Allow list went from 35 → 5 entries. Deny list went from 9 → 8 entries. File shrank 139 → 100 lines.

## Findings closed as N/A

| # | File | Rule | Reason |
|---|------|------|--------|
| 2 | `ai-resources/.claude/settings.json` | 10 | Operator confirmed no MCP servers used in ai-resources sessions. No `mcp__*` allow entries needed. If MCP added later, `/fewer-permission-prompts` will discover the gap empirically. |
| 3 | `ai-resources/workflows/research-workflow/.claude/settings.json` | 10 | Same as above for research-workflow. |

## Findings held (not applied)

| # | File | Rule | Severity | Reason |
|---|------|------|----------|--------|
| 1 | `ai-resources/workflows/research-workflow/.claude/settings.json` | 8 | HIGH | The flagged `"{{WORKSPACE_ROOT}}"` is intentional in the template source (commit `81cb6c2` added it as deploy-time fill-in). Replacing the placeholder would corrupt new deployments via `/deploy-workflow` / `/new-project`. Auditor mis-classified template-source-as-deployed; real fix is to teach the auditor to treat files under `workflows/*/.claude/` as template-class and skip Rule 8 there. Logged as backlog. |

## Already canonical (no change)

| File | Rule | Why |
|------|------|-----|
| `ai-resources/.claude/settings.json` | 7 | `Bash(*)` + narrow deny rules — intentional overlap matching canonical Layer C shape. |
| `ai-resources/workflows/research-workflow/.claude/settings.json` | 7 | Same intentional overlap pattern at Layer D. |

## Backlog items

- **Auditor template-class classification:** `permission-sweep-auditor` should recognize files under `ai-resources/workflows/*/.claude/` as template source and skip Rule 8 there (or apply a different rule that allows `{{...}}` placeholders). Currently the auditor cannot distinguish template from deployed.

## Full diagnostic notes

`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/permission-sweep-2026-04-27.md`

## Prevention

- SessionStart hook `check-permission-sanity.sh` flags primary root cause on session start.
- `/new-project` pipeline emits the canonical template for every new project.
- `/friday-checkup` weekly rotation runs `/permission-sweep --dry-run` to catch drift.
