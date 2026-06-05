# Friday Act Plan — 2026-06-05 — vault-integrity

**Source report:** friday-checkup-2026-06-05.md (monthly tier)
**Journal report:** (none)
**Generated:** 2026-06-05
**Items:** 2

## Items

### 1. [high] Bump the 3 stale `vault/components/_index.md` atomic-index counts (Commands/Agents/Projects)
- **Source:** checkup
- **Risk-check required:** no
- **W2.4 auto-draft:** no

W2.3 integrity flagged 3 ERROR atomic-index count mismatches in `projects/repo-documentation/vault/components/_index.md`: Commands 48≠49, Agents 37≠45, Projects 7≠11. The index counts drifted from registry reality. Update the three counts to match the registry. Confirm the live registry counts before writing (the mismatch numbers above are from the 2026-06-05 scan and may have shifted). Vault-content edit; no risk-check class.

### 2. [med] Triage the 5 W2.4 findings + per-scope `/improve` findings
- **Source:** checkup
- **Risk-check required:** no
- **W2.4 auto-draft:** no

The W2.4 improvements report (`projects/repo-documentation/output/phase-2/w2-4-improvements-2026-06-05.md`) produced 5 findings, and per-scope `/improve` runs produced additional findings, that were not auto-imported this cycle (journal report was MISSING, so the journal-derived import path did not run). Read the W2.4 report and the per-scope `/improve` findings, decide which warrant their own fix-now items, and either fold them into existing plans or raise them at the next `/friday-act`. Triage/meta item; no risk-check class.

## Execution notes
- Commit each fix separately (workspace commit-behavior rules).
- For any item marked "Risk-check required: yes", run `/risk-check` before executing that item.
- For any item marked "W2.4 auto-draft: yes", decide auto-draft vs. manual at execution time per the W2.4 sub-disposition in the `/friday-act` Step 3 W2.4 instructions.
- Run `/wrap-session` when all items in this plan are done.
