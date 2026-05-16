# Friday Act Plan — 2026-05-16 — permission-sweep

**Source report:** friday-checkup-2026-05-16.md (weekly tier)
**Journal report:** audits/friday-journal-2026-05-16.md
**Generated:** 2026-05-16
**Items:** 3

## Items

### 1. [high] Permission-sweep gitignore fixes (H-2, H-3)
- **Source:** checkup
- **Risk-check required:** no
- **W2.4 auto-draft:** no
- **Detail:** Add `.claude/settings.local.json` entry to `.gitignore` in three projects: `nordic-pe-macro-landscape-H1-2026`, `global-macro-analysis`, `obsidian-pe-kb`. Create a new `.gitignore` file in `project-planning` (currently has none) containing at minimum `.claude/settings.local.json`. These projects rely only on the global `~/.config/git/ignore` for coverage — explicit per-repo entries are required. Full path: `projects/<name>/.gitignore`.

### 2. [high] Permission-sweep additionalDirectories fixes (H-4)
- **Source:** checkup
- **Risk-check required:** yes — change class: settings.json
- **W2.4 auto-draft:** no
- **Detail:** Two project settings.json files are missing the `additionalDirectories` entry pointing to `ai-resources`: `projects/nordic-pe-landscape-mapping-4-26/.claude/settings.json` and `projects/interpersonal-communication/.claude/settings.json`. Without this, ai-resources symlinks may not resolve from these projects. Add the canonical `additionalDirectories` block (matching the pattern in `ai-resources/docs/permission-template.md`). Run `/risk-check` before editing.

### 3. [low] Permission-sweep form-normalization advisories (ADV-1, ADV-2, ADV-7)
- **Source:** checkup
- **Risk-check required:** yes — change class: settings.json (ADV-1, ADV-2)
- **W2.4 auto-draft:** no
- **Detail:** Three advisory findings from the dry-run sweep:
  - ADV-1: Normalize `Bash(git push *)` → `Bash(git push*)` (remove space before `*`) in workspace Layer B settings.json.
  - ADV-2: Normalize `NotebookEdit(**)` → `NotebookEdit` in applicable settings files.
  - ADV-7: Add explicit `.claude/settings.local.json` entry to `ai-resources/.gitignore` (currently covered only by global git ignore).
  ADV-7 (.gitignore) does not require risk-check. ADV-1 and ADV-2 touch settings.json — run `/risk-check` before editing those two. Batch all three in the same session.

## Execution notes
- Commit each fix separately (workspace commit-behavior rules).
- For items 2 and 3 (settings.json edits): run `/risk-check` before executing those items.
- Run `/wrap-session` when all items in this plan are done.
