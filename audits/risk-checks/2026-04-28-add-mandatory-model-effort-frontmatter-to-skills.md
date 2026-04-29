# Risk Check — 2026-04-28

## Change

Make `model:` and `effort:` frontmatter mandatory on every skill in the ai-resources repo, and update the skill-creation pipeline to enforce both fields. Four phases: (A) pipeline foundation — 5 files; (B) operator tier review — no code; (C) bulk sweep — 69 SKILL.md files mechanically receive 2 frontmatter lines; (D) audit + cross-reference — 1 file + skill-auditor sweep. Total: 75 files modified. Canonical mapping: judgment → opus+high; structured → sonnet+medium; mechanical → haiku+low.

## Referenced files

- `ai-resources/skills/ai-resource-builder/SKILL.md` — exists
- `ai-resources/skills/ai-resource-builder/references/operational-frontmatter.md` — exists
- `ai-resources/.claude/commands/create-skill.md` — exists
- `ai-resources/.claude/commands/improve-skill.md` — exists
- `ai-resources/skills/repo-health-analyzer/agents/skill-auditor.md` — exists
- `ai-resources/skills/*/SKILL.md` — 69 files, all exist (verified via `ls | wc -l` = 70 entries minus CATALOG.md)
- `ai-resources/docs/model-routing.md` — exists
- `ai-resources/audits/working/skills-tier-inventory-2026-04-28.md` — **NOT FOUND on disk** (plan claims it exists; `find audits/ -name "*tier-inventory*"` returns empty; `ls audits/working/` does not include it). Phase B input is therefore unevaluable as written.

## Verdict

**PROCEED-WITH-CAUTION**

**Summary:** Two Medium and one High dimension. The High (Hidden Coupling) is mitigable by routing Phase C through `/improve-skill` semantics (a documented exception in the canonical pipeline) and by producing the missing Phase B input before Phase C executes.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Skill-level `model:` and `effort:` frontmatter are honored only when the skill loads, and revert on next user prompt — no per-turn cost added to always-loaded files. Evidence: change description states this explicitly ("the override applies for the rest of the current turn and reverts on next user prompt"); confirmed against operational-frontmatter.md lines 22 (`effort`) and 24 (`model`) which describe these as runtime, not session-level.
- Bulk edits add ~2 lines per SKILL.md but SKILL.md bodies are pay-as-loaded, not always-loaded. Workspace and ai-resources CLAUDE.md (always-loaded) are not modified by this change.
- New skill-auditor Section 8 only runs when `/audit-repo` runs — no per-session cost.
- Net effect on per-session token budget: zero. Net effect on per-skill-load token budget: +~30 tokens, immaterial.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `.claude/settings.json` or `settings.local.json` modifications described.
- No new tool invocations introduced (Bash, Write paths, MCP servers, hooks all unchanged).
- Phase C bulk edit operates on already-writable paths under `ai-resources/skills/`.

### Dimension 3: Blast Radius
**Risk:** Medium

- 75 files modified across one batch session is high file-count but low semantic-coupling — Phase C edits are mechanical 2-line inserts after `description:`, no body changes.
- Cross-references touched: `ai-resource-builder/SKILL.md` is referenced by 3 commands (`/create-skill`, `/improve-skill`, `/migrate-skill`) per `audits/repo-due-diligence-2026-04-06.md` lines 21–25. The Step 4b instruction added is additive (declare new fields) — backwards compatible with existing skill creation flows.
- `operational-frontmatter.md` references found in 2 active locations (ai-resource-builder/SKILL.md lines 51 and 368). Marking `model:` and `effort:` REQUIRED is a contract change — backwards-compatible for new skills but creates an inconsistency for the 68 existing skills that don't yet have the fields, until Phase C lands.
- skill-auditor.md is invoked by `/audit-repo` (referenced in `ai-resources/.claude/commands/audit-repo.md:19` and `workflows/research-workflow/.claude/commands/audit-repo.md:18`) — Section 8 addition will fire for all `/audit-repo` runs and produce findings during the window between Phase A landing and Phase C completion if those phases are not adjacent in time.
- `migrate-skill.md` exists (verified) but is NOT in the Phase A scope — gap: a skill produced via `/migrate-skill` would not be subject to the new gate.

### Dimension 4: Reversibility
**Risk:** Low

- All 75 file edits are tracked-file modifications. `git revert` of the Phase A commit, the Phase C `batch:` commit, and the Phase D commit cleanly restores prior state.
- No log appends, no symlinks, no permission state, no external pushes implied.
- The improvement-log.md may receive stall-escalation entries from the new gates if Phase A's enforcement triggers them on Phase C's commit, but that is bounded and reversible.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Phase C bypasses the canonical-pipeline rule.** `ai-resources/docs/ai-resource-creation.md` rule #4 (verified): "Always use the canonical pipelines: `/create-skill` for new skills, `/improve-skill` for modifications, `/migrate-skill` for converting existing prompts. These pipelines include QC gates — skipping them means skipping quality assurance." Phase C edits 69 SKILL.md files directly without `/improve-skill`. Even if the edit is mechanical, the rule does not carve out an exception for frontmatter-only edits. This is a governance contract break unless explicitly waived.
- **Phase B input does not exist.** The plan declares `audits/working/skills-tier-inventory-2026-04-28.md` as the operator-review input. `ls audits/working/` and `find audits/ -name "*tier-inventory*"` both return empty. The plan assumes prior-session Explore-agent output is on disk that is not. Without this file, the per-skill `model:`/`effort:` assignments in Phase C have no audit trail.
- **`/migrate-skill` gap.** `/migrate-skill` exists in `.claude/commands/` (verified) but is not updated in Phase A. A skill created via this path would not be subject to the new gate, silently re-introducing the missing-frontmatter pattern.
- **`mechanical-mode` QC interaction.** Workspace CLAUDE.md QC Independence Rule allows skipping post-edit QC for substitution-shaped edits ≤5 lines. Phase C's 2-line insert per file qualifies, but spans 69 files — the rule's intent (single-file mechanical fix) does not obviously generalize to a 69-file batch. The auto-QC loop may either (a) skip entirely (loss of QA on a 75-file change) or (b) fire 69 times (cost explosion). The interaction is unspecified.
- **Skill-auditor Section 8 vs. Phase C ordering.** If Phase A lands before Phase C in the same commit window and `/audit-repo` runs in between, Section 8 will produce 68 Important findings. Operator must sequence Phase A → Phase C as adjacent commits, or land Phase A's auditor change in Phase D after Phase C completes.

## Mitigations

- **Hidden Coupling — pipeline bypass:** Add a documented exception to `ai-resources/docs/ai-resource-creation.md` for the Phase C bulk sweep (one-time mechanical frontmatter backfill, recorded in commit message and improvement-log.md). Alternative: fold Phase C into a `/improve-skill --bulk-frontmatter` mode that calls the pipeline once per skill with mechanical-mode QC. The first option is cheaper; the second is more contract-faithful.
- **Hidden Coupling — missing Phase B input:** Before Phase C runs, generate `audits/working/skills-tier-inventory-2026-04-28.md` (the 15/42/12 classification) and have the operator review and approve it on disk. If the prior-session Explore-agent output cannot be recovered, redo the classification in this session via a single Explore-agent pass before Phase C. Phase C should not run on operator memory of the classification.
- **Hidden Coupling — `/migrate-skill` gap:** Add `migrate-skill.md` to Phase A scope (one extra file, parallel gate to create-skill.md). Without this, Phase A enforcement is incomplete.
- **Hidden Coupling — QC mode under bulk:** Declare in the plan whether Phase C's per-file post-edit QC is (a) skipped under mechanical-mode for the whole batch, or (b) replaced by a single-batch verification (re-grep all 69 files for `^model:` and `^effort:` presence after the commit). Option (b) is the recommended substitute; document it in the Phase C commit message.
- **Hidden Coupling — Phase A↔C ordering:** Sequence so Phase A's skill-auditor Section 8 lands in the SAME commit as Phase C, or in Phase D after Phase C completes. Do not commit Phase A standalone if `/audit-repo` may run in the interval.
- **Blast Radius — contract-change window:** Land Phase A and Phase C as a single batch commit (or two adjacent commits in the same session) to minimize the window where the auditor sees 68 missing-frontmatter findings on the existing skills.

## Resolution

All 5 mitigations applied in revised plan. See plan file `~/.claude/plans/yes-make-a-plan-gleaming-creek.md` "Risk-check mitigations applied" section for cross-reference.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file existence verification (`ls`, `find`), grep counts (`grep -l "^model:"` returned 1 file = `summary`; `grep -l "^effort:"` returned 0 files), verbatim quotes from CLAUDE.md (workspace line 35, ai-resource-creation.md rule #4), file-count verification (70 entries in skills/, minus CATALOG.md), explicit NOT-FOUND flag for the Phase B input file. No training-data fallback. No INCOMPLETE dimensions; all five evaluated against evidence.
