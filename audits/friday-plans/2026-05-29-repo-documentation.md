# Friday Act Plan — 2026-05-29 — repo-documentation

**Source report:** friday-checkup-2026-05-29.md (weekly tier)
**Journal report:** ai-resources/audits/friday-journal-2026-05-29.md
**Generated:** 2026-05-29
**Items:** 6

## Items

### 1. [med] Fix 3 W2.1 doc-scanner coverage gaps: walk skill-internal subagents; walk `.claude/references/*.md`; review project-local basename collisions
- **Source:** checkup
- **Risk-check required:** no
- **W2.4 auto-draft:** no

### 2. [med] Re-author `vault/components/projects.md` against §4.4 schema (1 ERROR + 1 paired WARN — 7 entries × 4 fields missing, 7 × 6 unexpected)
- **Source:** checkup
- **Risk-check required:** no
- **W2.4 auto-draft:** no

### 3. [low] Paste 7 genuinely net-new entries since 2026-05-22 (1 command `pipeline-review`, 4 canonical agents, 2 projects) into `vault/components/*.md`
- **Source:** checkup
- **Risk-check required:** no
- **W2.4 auto-draft:** no

### 4. [low] Decide handling for the 212-entry carry-forward set pending since 2026-05-22 (registry pastes)
- **Source:** checkup
- **Risk-check required:** no
- **W2.4 auto-draft:** no

### 5. [low] Decide deprecation-row policy (prose body vs §4.1 schema addition) — affects `vault/components/commands.md`, `claude-md-files.md`, `settings-files.md`
- **Source:** checkup
- **Risk-check required:** no
- **W2.4 auto-draft:** no

### 6. [low] Re-run `/kb-integrity` from `vault/` after items 2, 4, 5 land — confirm closure
- **Source:** checkup
- **Risk-check required:** no
- **W2.4 auto-draft:** no

## Execution notes
- Commit each fix separately (workspace commit-behavior rules).
- For any item marked "Risk-check required: yes", run `/risk-check` before executing that item.
- For any item marked "W2.4 auto-draft: yes", decide auto-draft vs. manual at execution time per the W2.4 sub-disposition in the `/friday-act` Step 3 W2.4 instructions.
- Items 2, 4, 5 should land before item 6 (kb-integrity re-run depends on schema decisions).
- Run `/wrap-session` when all items in this plan are done.
