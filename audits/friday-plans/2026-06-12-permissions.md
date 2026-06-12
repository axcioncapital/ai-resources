# Friday Act Plan — 2026-06-12 — permissions

**Source report:** friday-checkup-2026-06-12.md (weekly tier)
**Journal report:** (none)
**Generated:** 2026-06-12
**Items:** 3

## Items

### 1. [high] Fix stale Daniel-machine path in `projects/interpersonal-communication/knowledge-base/.claude/settings.json` `additionalDirectories`
- **Source:** checkup
- **Risk-check required:** yes — change class: settings.json
- **W2.4 auto-draft:** no
- Detail: `/Users/danielniklander/...` does not exist on this machine → ai-resources symlinks fail for this nested KB. Replace with the correct machine-relative / portable path.

### 2. [med] Add `defaultMode: bypassPermissions` + `additionalDirectories` to `knowledge-bases/strategic-os` and `knowledge-bases/marketing-communication` settings
- **Source:** checkup
- **Risk-check required:** yes — change class: settings.json
- **W2.4 auto-draft:** no
- Detail: both KB settings currently missing these keys → permission prompts fire and ai-resources symlinks won't resolve in KB sessions. Auditor rated ADVISORY; findings-extractor flagged HIGH on operational impact (treat as do-soon).

### 3. [med] Review `projects/axcion-brand-book` deny glob `0[1-8]_*.md` silently overriding explicit allows for `02_color.md` / `03_typography.md`
- **Source:** checkup
- **Risk-check required:** yes — change class: settings.json
- **W2.4 auto-draft:** no
- Detail: the deny glob shadows explicit allow entries. Decide whether to narrow the deny glob or drop the conflicting allows; edit settings.json accordingly.

## Execution notes
- Commit each fix separately (workspace commit-behavior rules).
- For any item marked "Risk-check required: yes", run `/risk-check` before executing that item.
- All three items edit `settings.json` files → each runs `/risk-check` first.
- Pairs with `/permission-sweep` — re-run `--dry-run` after the fixes to confirm clean.
- Run `/wrap-session` when all items in this plan are done.
