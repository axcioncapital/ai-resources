# Friday Act Plan — 2026-05-08 — risk-topology

**Source report:** friday-checkup-2026-05-08.md (weekly tier)
**Journal report:** ai-resources/audits/friday-journal-2026-05-08.md
**Generated:** 2026-05-08
**Items:** 1

> **Note on slug:** This plan's slug `risk-topology` is derived from the first explicit path `architecture/risk-topology.md` per Step 3.6 path-derivation rule. The work also touches `projects/projects.md` in the same vault.

## Items

### 1. [med] Fix 4 dead wiki-links in vault: `[[audit-discipline]]`, `[[documentation-structure]]`, `[[friday-checkup]]` in `architecture/risk-topology.md` and `projects/projects.md`
- **Source:** checkup
- **Risk-check required:** no
- **W2.4 auto-draft:** no

Vault internal-integrity fix. Two of the three targets exist (`audit-discipline.md`, `friday-checkup.md`) and just need the link target spelled correctly with full path; verify whether `documentation-structure` exists under a different name. Open the two files, replace short-name `[[X]]` form with full-path `[[full/path/X.md]]` form per the canonical wiki-link convention.

## Execution notes
- Commit each fix separately (workspace commit-behavior rules).
- For any item marked "Risk-check required: yes", run `/risk-check` before executing that item.
- For any item marked "W2.4 auto-draft: yes", decide auto-draft vs. manual at execution time per the W2.4 sub-disposition in the `/friday-act` Step 3 W2.4 instructions.
- Run `/wrap-session` when all items in this plan are done.
