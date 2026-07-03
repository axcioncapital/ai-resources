# Permission Sweep Report — 2026-07-03

**Mode:** dry-run (diagnosis only — run under the axcion-ai-system-redesign design-only window; no remediation applied, none prompted).

## Summary

- Scanned 43 settings files across 6 layers (user-level A, workspace B/B′, ai-resources C/C-local, projects D/D′, plus 1 workflow template).
- Findings: 5 CRITICAL, 11 HIGH, 29 MEDIUM, 28 ADVISORY, 8 INTENTIONAL-NARROW (all on `projects/strategic-os`, excluded by default).
- Applied: 0. Deferred: all (dry-run). Skipped INTENTIONAL-NARROW: 8.

## What's causing permission prompts right now (CRITICAL)

1. `projects/management-os/.claude/settings.local.json` — Rule 1
   — Local-override file is missing the "skip permission prompts" setting, which disables it globally for this project.
   Fix: add `"defaultMode": "bypassPermissions"` to the permissions block.
2. `projects/positioning-research/.claude/settings.local.json` — Rule 1
   — Local-override file declares a permissions block without the "skip permission prompts" setting; the parent's bypass is shadowed.
   Fix: add `"defaultMode": "bypassPermissions"` to the permissions block.
3. `projects/axcion-brand-book/.claude/settings.json` — Rule 3
   — Broad allow rules do not cover nested `.claude/` folders (glob quirk). Edits inside nested `.claude/` still prompt.
   Fix: add `Edit(**/.claude/**)` and `Write(**/.claude/**)` to allow.
4. `ai-resources/.claude/settings.local.json` — Rule 5
   — Narrow bash allowlist (only 4 specific commands). Any new bash command will prompt.
   Fix: add `Bash(*)` (or drop the permissions block so the parent applies).
5. `projects/positioning-research/.claude/settings.local.json` — Rule 5
   — Narrow bash allowlist (single command). Any new bash command will prompt.
   Fix: add `Bash(*)` (or drop the permissions block so the parent applies).

## Other gaps (HIGH — will cause future prompts)

- `ai-resources/.claude/settings.local.json` — no allow for narrow `rm`; delete operations prompt (Rule 6).
- `projects/positioning-research/.claude/settings.local.json` — same Rule 6 gap.
- Rule 8 — workspace-root grant (`additionalDirectories`) missing from BOTH tracked and local settings in 9 projects; ai-resources symlinks may not resolve there: `axcion-ai-system-redesign`, `axcion-design-studio`, `axcion-copy-factory`, `axcion-website`, `marketing-positioning`, `project-planning`, `nordic-pe-screening-project`, `axcion-ai-system-owner`, `axcion-ai-system-owner/vault`. Fix: add the grant to each project's `settings.local.json` (with `defaultMode`).

## Coverage improvements (MEDIUM)

- Rule 10 — no MCP-tool allow coverage in 29 files. Structural note: no MCP servers are configured anywhere in this workspace today, so nothing prompts now; add `mcp__<server>__*` entries if/when MCP servers arrive.

## Hygiene (ADVISORY)

- Rule 8 (relocate) — 11 projects carry the machine-specific `additionalDirectories` grant in the tracked (git-committed) `settings.json`; it belongs in the gitignored `settings.local.json`.
- Rule 14 — 17 projects deny `Read(archive/**)` without an `archive/` line in that repo's own `.gitignore` (`management-os` has no `.gitignore` at all; `axcion-website` relies on a root-anchored workspace entry that doesn't cover it).

## Intentionally narrow — not touched

- `projects/strategic-os/.claude/settings.json` — 13 path-scoped Edit/Write grants, paired denies on `state/live` and `inputs`, narrow bash list. All 8 findings on this file tagged INTENTIONAL-NARROW; requires `--fix-narrow` to include.

## Clean checks

- No parse errors (all 43 files pass `jq empty`).
- No git-tracked `settings.local.json` anywhere (Rule 12 clean).
- Template file `ai-resources/workflows/research-workflow/.claude/settings.json` is in its correct post-2026-06-27 state (grant relocated; no placeholder issues).
- Stale template exception: `projects/obsidian-pe-kb/vault/.claude/settings.json` (the documented intentional-narrow exception in `permission-template.md`) no longer exists on disk — the template doc's exception list is out of date.

## Findings deferred (not approved this run)

All findings — dry-run under the design-only window. Remediation is a candidate item for a post-window `/permission-sweep` run (or `/friday-act`).

## Full diagnostic notes

/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/permission-sweep-2026-07-03.md

## Prevention

- SessionStart hook `check-permission-sanity.sh` flags the primary root cause on session start.
- `/new-project` pipeline emits the canonical template for every new project.
- `/friday-checkup` weekly rotation runs `/permission-sweep --dry-run` to catch drift.
