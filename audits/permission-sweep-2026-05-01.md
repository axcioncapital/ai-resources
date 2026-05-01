# Permission Sweep Report — 2026-05-01 (DRY RUN)

## Summary

- Scanned 20 settings files across 5 layers (user, workspace, ai-resources, projects, workflow templates).
- Findings: 1 CRITICAL, 1 HIGH, 0 MEDIUM, 9 ADVISORY, 0 INTENTIONAL-NARROW.

## Findings (dry-run — not applied)

### CRITICAL

**1. Rule 4 — ai-resources/.claude/settings.json**
- Allow list has 5 entries; auditor flagged missing entries for: Read, Agent, Skill, TodoWrite, Glob, Grep, WebFetch, WebSearch, NotebookEdit, ToolSearch, Edit(**/.claude/**), Write(**/.claude/**), absolute-path Edit/Write entries.
- **Operator-context note:** `defaultMode: bypassPermissions` IS set in this file. Per operator memory (`feedback_zero_permission_prompts.md`), bypass mode is the agreed setup and the allow list serves as a secondary safety layer rather than the primary enforcement mechanism. This finding may be a rule-template mismatch with the operator's bypass-mode design rather than a true gap. **Recommend operator review before remediation.**

### HIGH

**2. Rule 8 — workflows/research-workflow/.claude/settings.json**
- `additionalDirectories: ["{{WORKSPACE_ROOT}}"]` — unfilled template placeholder. Claude Code will not resolve `{{WORKSPACE_ROOT}}` as a real path; the entry is effectively dead.
- **Cross-reference:** Same finding flagged by `/audit-repo` 2026-05-01 (Settings & Permissions → Important).
- **Fix:** Either remove the entry (research-workflow lives inside ai-resources/, inherits via Claude Code defaults) or substitute the placeholder with the real workspace root path. If this file is meant to be a template for `/deploy-workflow`, document that explicitly and exclude from settings audits.

### ADVISORY (×9)

**3. Rule 14 — gitignore drift across 9 settings files**
- `Read(archive/**)` in deny list, but `archive/` not in corresponding `.gitignore` (or directory absent on disk).
- Affects: Layer C (ai-resources root) + 7 Layer D project settings + research-workflow template.
- **Impact:** Low — the deny rule still works at runtime; the gitignore inconsistency is a hygiene concern only.
- **Fix:** Add `archive/` to each project's `.gitignore` or remove the `Read(archive/**)` deny if archive/ won't exist.

## INTENTIONAL-NARROW

None.

## Full diagnostic notes

`audits/working/permission-sweep-2026-05-01.md`

## Prevention

- SessionStart hook `check-permission-sanity.sh` flags primary root cause on session start.
- `/new-project` pipeline emits canonical template for every new project.
- `/friday-checkup` weekly rotation runs `/permission-sweep --dry-run` to catch drift.

---

**Dry-run complete.** Run `/permission-sweep` (no `--dry-run`) to remediate. Operator should review the CRITICAL finding's bypass-mode caveat before approving remediation.
