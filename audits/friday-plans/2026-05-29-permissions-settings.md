# Friday Act Plan — 2026-05-29 — permissions-settings

**Source report:** friday-checkup-2026-05-29.md (weekly tier)
**Journal report:** ai-resources/audits/friday-journal-2026-05-29.md
**Generated:** 2026-05-29
**Items:** 7

## Items

### 1. [high] Reconcile `projects/nordic-pe-macro-landscape-H1-2026/.claude/shared-manifest.json` — 1 phantom entry (`route-change`) + 14 disk-vs-manifest drift instances (2 wrongly-classified + 10 commands missing from manifest + 4 agents missing)
- **Source:** checkup
- **Risk-check required:** no
- **W2.4 auto-draft:** no

### 2. [high] Add `Bash(rm *)` to allow list in `projects/nordic-pe-macro-landscape-H1-2026/.claude/settings.json` (Rule 6 — delete/remove operations will prompt without it)
- **Source:** checkup
- **Risk-check required:** yes — change class: settings.json
- **W2.4 auto-draft:** no

### 3. [high] Remove stale `/Users/danielniklander/...` absolute path from `projects/interpersonal-communication/.claude/settings.json` `additionalDirectories` (Rule 9 — user not present on this machine)
- **Source:** checkup
- **Risk-check required:** yes — change class: settings.json
- **W2.4 auto-draft:** no

### 4. [high] Remove `"model": "sonnet"` from `~/.claude/settings.json` — violates Model Tier rule (contests `/model` overrides in live sessions); operator memory `feedback_no_model_in_settings_json` is explicit on this
- **Source:** so-derived
- **Risk-check required:** yes — change class: settings.json
- **W2.4 auto-draft:** no

### 5. [med] Retire the 3 stale April-2026 dated deny entries in `ai-resources/.claude/settings.json` (suppression window expired)
- **Source:** checkup
- **Risk-check required:** yes — change class: settings.json
- **W2.4 auto-draft:** no

### 6. [med] Remove `Bash(git push *)` deny from `obsidian-kb-builder` scaffold template (contradicts workspace zero-permission-prompts policy)
- **Source:** checkup
- **Risk-check required:** yes — change class: settings.json (template)
- **W2.4 auto-draft:** no

### 7. [med] Address 1 MEDIUM permission-sweep finding from `audits/permission-sweep-2026-05-29.md` (specifics in the report)
- **Source:** checkup
- **Risk-check required:** yes — change class: settings.json (most likely)
- **W2.4 auto-draft:** no

## Execution notes
- Commit each fix separately (workspace commit-behavior rules).
- For any item marked "Risk-check required: yes", run `/risk-check` before executing that item.
- For any item marked "W2.4 auto-draft: yes", decide auto-draft vs. manual at execution time per the W2.4 sub-disposition in the `/friday-act` Step 3 W2.4 instructions.
- Run `/wrap-session` when all items in this plan are done.
