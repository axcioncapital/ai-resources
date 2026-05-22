# Friday Act Plan — 2026-05-22 — repo-documentation

**Source report:** friday-checkup-2026-05-22.md (weekly tier)
**Journal report:** (none)
**Generated:** 2026-05-22
**Items:** 3

## Items

### 1. [med] Re-author vault/components/projects.md against the §4.4 projects-registry schema (28 missing fields, one root cause)
- **Source:** checkup
- **Risk-check required:** no
- **W2.4 auto-draft:** no
- **Context:** `/kb-integrity` found that all 7 entries in `vault/components/projects.md` use the §4.1 12-field table instead of the §4.4 projects-registry schema (which has 28 additional fields per entry). One systematic root cause — the initial authoring used the wrong schema. Fix: read the §4.4 schema spec, re-author `vault/components/projects.md` to match it for all 7 entries.
- **Target files:**
  - `projects/repo-documentation/vault/components/projects.md`

### 2. [low] Triage the 8 grouped registry actions in repo-documentation/output/phase-2/w2-3-maintenance-2026-05-22.md (136 added / 1 removed / 7 modified components)
- **Source:** checkup
- **Risk-check required:** no
- **W2.4 auto-draft:** no
- **Context:** The W2.3 maintenance scan produced 8 grouped registry actions corresponding to 136 added, 1 removed, and 7 modified components since the last scan. Read `projects/repo-documentation/output/phase-2/w2-3-maintenance-2026-05-22.md` and disposition each group: accept, reject, or defer. Record decisions.

### 3. [low] Apply 2 renames as rename-updates not deprecate-and-add: resolve-improvements→resolve-improvement-log; nordic-pe-landscape-mapping-4-26→nordic-pe-macro-landscape-H1-2026
- **Source:** checkup
- **Risk-check required:** no
- **W2.4 auto-draft:** no
- **Context:** Two registry entries have stale names. The vault convention for renames is to update the existing entry (rename-update) rather than deprecating the old one and adding a new one. Apply this convention to both entries to keep the registry clean.
- **Target files:**
  - `projects/repo-documentation/vault/` (specific registry file TBD — read W2.3 report to identify)

## Execution notes
- Execute in order: item 3 (renames) → item 2 (registry triage) → item 1 (schema re-author). Renames first avoids referencing stale names during triage.
- Note: item 17 from checkup ("Run /kb-update to align vault") was deferred — it depends on item 2 (triage) completing first. Run /kb-update as a follow-up after all three items in this plan are done.
- Commit each fix separately (workspace commit-behavior rules).
- For any item marked "Risk-check required: yes", run `/risk-check` before executing that item.
- Run `/wrap-session` when all items in this plan are done.
