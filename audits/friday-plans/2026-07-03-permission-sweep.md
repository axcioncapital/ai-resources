# Friday Act Plan — 2026-07-03 — permission-sweep

**Source report:** friday-checkup-2026-07-03.md (quarterly tier)
**Journal report:** (none)
**Generated:** 2026-07-03
**Items:** 4

## Items

### 1. [high] Fix the 4 CRITICAL permission-prompt settings gaps (management-os, positioning-research ×2, axcion-brand-book, ai-resources local)
- **Source:** checkup
- **Risk-check required:** yes — change class: settings.json edits across 4 project scopes
- **W2.4 auto-draft:** no
- Detail (from `audits/permission-sweep-2026-07-03.md` findings 1–4): (a) `projects/management-os/.claude/settings.local.json` — add `"defaultMode": "bypassPermissions"`. (b) `projects/positioning-research/.claude/settings.local.json` — add `defaultMode` + `Bash(*)` (or drop the narrow bash allowlist). (c) `projects/axcion-brand-book/.claude/settings.json` — add `Edit(**/.claude/**)` + `Write(**/.claude/**)`. (d) `ai-resources/.claude/settings.local.json` — replace the narrow 4-command bash allowlist with `Bash(*)` or drop the local override so the parent applies.

### 2. [high] Add the workspace-root `additionalDirectories` grant to the 9 projects missing it (permission-sweep Rule 8)
- **Source:** checkup
- **Risk-check required:** yes — change class: settings.json edits across 9 project scopes
- **W2.4 auto-draft:** no
- Projects: axcion-ai-system-redesign, axcion-design-studio, axcion-copy-factory, axcion-website, marketing-positioning, project-planning, nordic-pe-screening-project, axcion-ai-system-owner (+ vault). Add the workspace-root grant to each project's `settings.local.json` so ai-resources symlinks resolve when the project is opened standalone.

### 3. [med] Add ai-resources granular `Read()` denies (audits/working/**, output/** subpaths, dated-report patterns)
- **Source:** checkup
- **Risk-check required:** yes — change class: settings.json edit
- **W2.4 auto-draft:** no
- Before adding: verify no active command greps the historical dated reports being denied (token-audit F6-1/2/3 flagged `audits/working/`, the new `output/` tree — 114 files, ~760 KB — and ~40 historical dated reports as unnecessarily readable). Add directory-scoped denies, not blanket ones.

### 4. [med] Permission hygiene (relocate additionalDirectories tracked→.local, reconcile Read(archive/**) denies vs .gitignore, refresh stale permission-template.md exception list)
- **Source:** checkup
- **Risk-check required:** yes — change class: settings.json edits across 11 (relocate) + 17 (gitignore reconcile) projects, plus a doc edit
- **W2.4 auto-draft:** no
- Three sub-items from permission-sweep MEDIUM/ADVISORY findings: (a) `additionalDirectories` grant sits in tracked `settings.json` in 11 projects — belongs in gitignored `.local`. (b) 17 projects deny `Read(archive/**)` with no matching `.gitignore` entry for the underlying path. (c) `permission-template.md`'s intentional-narrow exception list is stale (references `obsidian-pe-kb/vault` file that no longer exists) — correct it.

## Execution notes
- Commit each fix separately (workspace commit-behavior rules).
- All 4 items are flagged "Risk-check required: yes" — run `/risk-check` before executing each, per `ai-resources/docs/audit-discipline.md` § Risk-check change classes (settings.json is an explicit change class).
- These 4 items touch overlapping settings.json files across many of the same projects — consider sequencing to avoid re-touching a file twice in the same session (e.g., do items 1 and 2 together per-project where they overlap).
- Run `/wrap-session` when all items in this plan are done.
