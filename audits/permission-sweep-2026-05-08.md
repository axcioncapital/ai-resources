# Permission Sweep Report — 2026-05-08

**Mode:** dry-run (invoked by /friday-checkup weekly rotation)

## Summary

- Scanned 22 settings files across 5 layers (A, B, B′, C, D/D′).
- Findings: 0 CRITICAL, 3 HIGH, 2 MEDIUM, 7 ADVISORY, 0 INTENTIONAL-NARROW.
- Applied: 0 (dry-run). Deferred: all.

---

## What's causing prompts right now

No CRITICAL findings — no missing `defaultMode` entries. Broad grants are in place.

## Gaps that will cause future prompts (HIGH)

1. **`ai-resources/.claude/settings.json` (Layer C) — Rule 4**
   Missing canonical tool grants from allow list: `Read`, `Agent`, `Skill`, `TodoWrite`, `Glob`, `Grep`, `WebFetch`, `WebSearch`, `NotebookEdit`, `ToolSearch`, `Edit(**/.claude/**)`, `Write(**/.claude/**)`, plus absolute-path fallbacks.
   Fix: add the missing entries to the allow list per canonical Layer C shape.

2. **`ai-resources/.claude/settings.json` (Layer C) — Rule 8**
   No `additionalDirectories` block — workspace root path absent, so ai-resources symlinks may not resolve correctly.
   Fix: add `"additionalDirectories": ["/Users/patrik.lindeberg/Claude Code/Axcion AI Repo"]`.

3. **`ai-resources/workflows/research-workflow/.claude/settings.json` (Layer D) — Rule 8/9**
   `additionalDirectories` contains unresolved template placeholder `{{WORKSPACE_ROOT}}` — path does not exist on disk.
   Fix: replace `{{WORKSPACE_ROOT}}` with `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo`.

## Coverage improvements (MEDIUM)

4. **`~/.claude/settings.json` (Layer A) — Rule 11**
   Deny list is empty. Canonical requires `["Bash(rm -rf *)", "Bash(sudo *)"]` as safety floor.
   Fix: add the two canonical deny entries (operator-level policy decision).

5. **Workspace root `.claude/settings.json` (Layer B) — Rule 11**
   No deny block at all. Canonical requires `["Bash(rm -rf *)", "Bash(sudo *)", "Bash(git reset --hard *)", "Bash(git checkout *)"]`.
   Fix: add canonical deny list (operator-level policy decision).

## Advisory / hygiene

6. **Workspace root `.claude/settings.json` — Rule 13:** `Bash(git push *)` in allow list (with space). All other files use `Bash(git push*)` in DENY. Evaluate whether this is intentional workspace-root override or a typo.

7. **`projects/axcion-ai-system-owner/.claude/settings.json` — Rule 13:** model field is `"sonnet"` (bare form silently downgrades to 200k context). Should be `"sonnet[1m]"`.

8. **4 project settings files — Rule 13:** Missing model field entirely — nordic-pe-landscape-mapping-4-26, project-planning, repo-documentation, global-macro-analysis.

9. **5 projects — Rule 12:** No `.gitignore` coverage for `settings.local.json` — settings.local.json may be tracked by git if created.

10. **`ai-resources/.claude/settings.json` — Rule 14 (Advisory):** Deny list contains `Read(archive/**)` but `archive/` does not exist in ai-resources and is absent from `.gitignore`. Stale deny entry.

## Intentional-narrow files

None detected.

## All reports

- Full notes: `ai-resources/audits/working/permission-sweep-2026-05-08.md`
- Summary: `ai-resources/audits/working/permission-sweep-2026-05-08.md.summary.md`

## Prevention

- SessionStart hook `check-permission-sanity.sh` flags the primary root cause on session start.
- `/new-project` pipeline emits the canonical template for every new project.
- `/friday-checkup` weekly rotation runs `/permission-sweep --dry-run` to catch drift.
