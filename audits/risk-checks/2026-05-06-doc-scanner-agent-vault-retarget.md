# Risk Check — 2026-05-06

## Change

Retarget `projects/repo-documentation/.claude/agents/doc-scanner-agent.md` (W2.1 doc-scanner, Phase 2 critical component) from Phase 1 archive baseline to vault baseline. Changes: (1) Phase 2: baseline source changes from `output/phase-1/components/` to `vault/components/`; drop inventory cross-check line referencing `output/phase-1/inventory/components.md`. (2) Phase 5: entry shape expands from 6-field (Type, Location, Source, Purpose, Model, Status) to 12-field for standard categories (adding Triggers, Scope, Used By, Depends On, State Writes, Governed By with [EVIDENCE GAP] defaults); 10-field shape for projects category (per §4.4 schema in documentation-structure.md). (3) Phase 6: update operator paste instructions from `output/phase-1/components/` to `vault/components/`. (4) Phase 3 line 60: update harness-skip comment from stale justification ("out of scope per project CLAUDE.md") to "harness skipped per D-31/D-37 (2026-05-06) — harness is described narratively in system-doc.md only; vault has no harness category." (5) Rules section: clarify agent reads vault as baseline but writes drift report to output/phase-2/ (write target unchanged). Plan-time gate — Fix 1 of v3 vault-maintenance fix plan.

## Referenced files

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/.claude/agents/doc-scanner-agent.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/vault/components/` — exists (vault content, gitignored)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/output/phase-1/components/` — exists (archived baseline)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/output/phase-1/inventory/components.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/references/documentation-structure.md` — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Single-file edit to a project-local agent invoked monthly+ from one orchestrator; the change semantics are sound and aligned with D-26/D-31/D-37, but two latent contracts (vault directory shape, operator paste destination) and one cadence assumption (`vault/components/` is gitignored content; baseline integrity now depends on local vault state) introduce blast-radius and hidden-coupling risk that requires explicit mitigation.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The agent is invoked only by `/friday-checkup` step G at monthly/quarterly tier, not weekly — evidence: `ai-resources/.claude/commands/friday-checkup.md` line 182 ("monthly and quarterly only"). No always-loaded file is touched.
- The brief expansion from 6-field to 12-field schema increases the agent's per-invocation output size only — it does not increase per-session token cost. The agent runs from a subagent context, returning a ≤30-line summary per ai-resources/CLAUDE.md subagent contract.
- No new hooks, no `@import` chains, no broadly-pattern-matching skill descriptions added.

### Dimension 2: Permissions Surface
**Risk:** Low

- The agent's `tools` frontmatter is unchanged: `Read, Glob, Grep, Write` (doc-scanner-agent.md lines 5–9). Read of `vault/components/*.md` is already covered by the agent's existing `Read` permission; the path is project-local so no new settings entry is needed.
- Write target unchanged — still `output/phase-2/`. No allow/ask/deny entries added or removed.
- No new tool families, no glob widening, no scope escalation.

### Dimension 3: Blast Radius
**Risk:** Medium

Enumeration of dependent callers and cross-references (grep scope: full Axcion AI Repo for `doc-scanner` and `phase-1/components` / `vault/components`):

- **Direct callers (1):** `ai-resources/.claude/commands/friday-checkup.md` step G (lines 182–193) is the sole orchestrator. Change is compatible — friday-checkup only checks the agent exists and reads back the report path; it does not parse internal Phase 2/5/6 logic.
- **Downstream consumer (1):** `ai-resources/.claude/commands/friday-checkup.md` line 275 generates a friday-act TODO: "Paste new entry into `output/phase-1/components/{category}.md}` ..." — this paste destination is now stale. After the retarget, drift report Operator-notes (Phase 6) will say `vault/components/`, but friday-checkup's TODO generator still says `output/phase-1/components/`. **Two callers will disagree on the paste target until friday-checkup is also patched.**
- **Schema-shape consumers (2):** `vault/.claude/commands/kb-update.md` Step 3 (per fix-plan-v3 line 127) and `vault/.claude/commands/kb-integrity.md` Check G (per fix-plan-v3 line 127) embed/parse the same component schema. The fix-plan v3 explicitly lists these as propagation targets that require schema-change session notes (line 127), but they are not amended by Fix 1 itself.
- **Existing baseline content (1):** `output/phase-1/components/agents.md` line 500 contains the registered entry for `doc-scanner-agent` itself. Its Location field still points at the project-local agent file; the entry text describing what the agent does will become stale (it currently says "Phase 1 archived registry"). Not blocking for this edit, but creates inventory drift on the next scan.
- **Format spec (1):** `references/documentation-structure.md` §1.3 / §1.4 / §4 / §7 (lines 121, 147, 260, 439) still reference `output/phase-1/components/` as the W2.1 target. The edit assumes documentation-structure.md is updated separately (it is — fix-plan v3 implies §7 is touched in a later fix), but if Fix 1 lands first, the spec and the agent disagree on canonical target until the spec catches up.

Total: 6 affected components. Of those, 2 require coordinated change (friday-checkup TODO line; documentation-structure.md §7), and 2 (kb-update Step 3, kb-integrity Check G) are flagged but out of scope for Fix 1. The change is backwards-compatible on the orchestration contract but creates a window of inconsistency on paste-destination guidance.

### Dimension 4: Reversibility
**Risk:** Low

- The change is a single tracked file (`.claude/agents/doc-scanner-agent.md` — verified tracked, not under gitignored vault content). `git revert` of the commit fully restores prior state.
- No log mutations, no append-only state, no external writes, no automation that would fire between landing and a hypothetical revert (the agent only runs when `/friday-checkup` invokes it on Friday cadence — there is no cron or hook auto-fire).
- Drift reports already produced on the new schema would remain in `output/phase-2/` after revert (since revert doesn't touch them); they would be readable as historical artifacts and would not corrupt subsequent runs.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Implicit dependency on vault directory shape (gitignored content).** After the retarget, the agent reads `vault/components/*.md`. Vault content is gitignored per project CLAUDE.md ("Vault content is gitignored"). On a fresh clone, or after a vault rebuild, `vault/components/` may be empty or missing — the agent will then report all live components as "Added" (false positive drift storm). The agent has no precondition check ("if `vault/components/` has fewer than N files, abort"). The 500-component cap (doc-scanner-agent.md line 187) protects against runaway scans but does not protect against an empty baseline.
- **Implicit dependency on the §4.1 / §4.4 schema selector.** Phase 5 will conditionally emit 12-field vs 10-field entries based on category. The selector logic ("if category == projects, emit §4.4 shape") must be encoded explicitly in the agent body. If the encoding is unclear, the agent may emit the wrong shape for `projects.md` or apply the projects extension to a non-projects category. The fix-plan v3 line 88 specifies the selector rule but the change description does not state how it will be encoded in the agent text — this is the schema-encoding contract.
- **Stale paste-destination guidance overlap.** Phase 6 will direct operators to paste into `vault/components/`. friday-checkup line 275 (the TODO generator) still says `output/phase-1/components/`. Two different commands will give the operator two different paste destinations until friday-checkup is also patched. This is the canonical "two systems handle the same concern" pattern.
- **Harness-skip comment is documentation, not behavior.** The Phase 3 line 60 comment update is purely descriptive; the actual `harness/` skip behavior is unchanged. Low-risk on its own, but worth noting that the comment now references decisions (D-31/D-37, 2026-05-06) that are not yet recorded in the verifiable inputs available to this review — those decision IDs cannot be verified from the referenced files alone (decisions.md was not in the referenced set).

## Mitigations

- **Mitigation for Dimension 3 (blast radius):** Bundle the friday-checkup TODO patch with this change — update `ai-resources/.claude/commands/friday-checkup.md` line 275 and friday-act paste-destination references from `output/phase-1/components/{category}.md` to `vault/components/{category}.md` in the same commit (or a paired commit landed at the same time). Verify friday-act briefing is consistent.
- **Mitigation for Dimension 3 (blast radius):** Either patch `references/documentation-structure.md` §7 (and §1.3 / §1.4 / §4 references to `output/phase-1/components/` as the W2.1 target) in the same change set, or add a one-line note in doc-scanner-agent.md Phase 1 explicitly stating "where documentation-structure.md §7 references `output/phase-1/components/`, treat as superseded by this agent's Phase 2 (vault baseline) per D-31/D-37." Avoid the window where spec and agent disagree.
- **Mitigation for Dimension 5 (hidden coupling — empty-vault guard):** Add a precondition check in Phase 2: if `vault/components/` does not exist or contains fewer than 8 category files (vault has 13 incl. `_index.md`; threshold of 8 catches a partially-rebuilt vault), abort with `[BASELINE MISSING — vault/components/ not populated; rebuild vault before scanning]` and emit no drift report. This prevents the false-positive drift storm on a fresh clone.
- **Mitigation for Dimension 5 (hidden coupling — schema selector):** State the selector rule explicitly in Phase 5 of the agent body, in pseudocode form: "if category == 'projects', emit §4.4 10-field shape (Type, Location, Source, Purpose, Model, Status, Phase, Key Outputs, Infra Dependencies, Risk Class). Otherwise, emit §4.1 12-field shape." Do not leave the selector implicit. Reference §4.4 in `documentation-structure.md` by section number for stability.
- **Mitigation for Dimension 5 (hidden coupling — decision IDs):** Before landing, verify `logs/decisions.md` (or equivalent) records D-31 and D-37 with dates 2026-05-06 and content matching the harness-skip rationale. If those decision entries do not exist yet, either create them as part of the same change set or rephrase the comment to reference an actual recorded decision (e.g., `D-26 (2026-04-30) made vault canonical; harness has no vault category`). Comments referencing nonexistent decision IDs are an audit anti-pattern.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file paths and line numbers from `doc-scanner-agent.md` (lines 5–9, 30, 36, 60, 84–100, 132, 169, 187), `friday-checkup.md` (lines 182–193, 254, 275), `references/documentation-structure.md` (lines 121, 147, 260, 269–283, 345–368, 439), and grep counts across the workspace for `doc-scanner` (40+ hits, ≤6 functional callers/consumers) and `vault/components/` (filesystem-verified 13 files including `_index.md`). No training-data fallback was used. The D-31/D-37 decision IDs cited in the change description are not present in the referenced inputs and are flagged in Mitigation 5 as a verification gate.
