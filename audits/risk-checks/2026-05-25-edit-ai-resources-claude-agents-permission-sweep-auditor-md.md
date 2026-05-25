# Risk Check — 2026-05-25

## Change

Edit `ai-resources/.claude/agents/permission-sweep-auditor.md` to add a template-class classification step before Rule 8 application. Heuristic: any file whose path matches `**/workflows/*/.claude/settings.json` (template source under the workflow library) is template-class; for template-class files, skip Rule 8 entirely or accept `{{...}}` Mustache placeholder values as PASS rather than HIGH. Optionally also detect `{{...}}` placeholders in any allow/deny entry as a secondary template-class signal.

Reason: `additionalDirectories: ["{{WORKSPACE_ROOT}}"]` in research-workflow template is intentional (filled at deploy time by /deploy-workflow); currently fires as false HIGH on every /permission-sweep and /friday-checkup --dry-run run, wasting operator attention and risking accidental "fix" by a future agent. Source: improvement-log entry 2026-04-28; booked 2026-05-26, 1 day overdue.

## Referenced files

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/permission-sweep-auditor.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/*/.claude/settings.json` (research-workflow) — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The change adds a useful path-based override but lands on a file that already implements a semantically equivalent placeholder-based override (Step 4a, `INTENTIONAL-TEMPLATE`); without reconciliation the two heuristics will overlap and the path-based heuristic will fire false-positives on a settings file that no longer contains placeholders.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Agent file is not always-loaded — `permission-sweep-auditor.md` is invoked only by `/permission-sweep` and (indirectly) by `/friday-checkup --dry-run`. Evidence: `permission-sweep.md:65` "Spawn one `permission-sweep-auditor` subagent"; `friday-checkup.md:175` "F. `/permission-sweep --dry-run` — all tiers, once per checkup run".
- Pay-as-used; spawn cadence is weekly at most (Friday checkup) plus on-demand sweeps.
- Adding a classification step adds ~10-30 tokens per spawn; negligible against the agent's current 224-line size.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json` edits, no `allow`/`ask`/`deny` changes, no new tool permissions. Agent `tools:` block (`Read`, `Write`, `Bash`, `Glob`, `Grep`) unchanged. Evidence: `permission-sweep-auditor.md:5-10`.
- Change is purely heuristic logic inside agent prose.

### Dimension 3: Blast Radius
**Risk:** Medium

- Single file directly edited (`permission-sweep-auditor.md`).
- Callers and consumers grep'd in `ai-resources/.claude/`:
  - `permission-sweep.md` (1 caller, line 65) — orchestrator spawns the agent.
  - `friday-checkup.md` (3 references: lines 62, 105, 175-183) — invokes `/permission-sweep --dry-run`.
  - `findings-extractor.md` (1 reference, line 19) — consumes permission-sweep reports downstream.
  - `system-owner.md` (1 reference, line 150) — names the command in deference scope.
  - Total: 5 dependent components, all compatible with the change (no input/output contract change — agent still returns the same summary/notes shape).
- Contract surface affected: the `[INTENTIONAL-TEMPLATE]` tag and ADVISORY severity downgrade are user-visible in `/permission-sweep` chat report tables (`permission-sweep.md:117`). Adding a second template-class signal (path-based) does not change the tag value, so the downstream rendering still works.
- Cross-doc coupling: `docs/permission-template.md § Intentional-template exceptions` (lines 233-241) is the source-of-truth detection rulebook the agent reads at Step 1; the proposed path-based heuristic is NOT yet present there. Evidence: `permission-template.md:237` defines only the `{{[A-Z_]+}}` regex heuristic; line 239 names `ai-resources/workflows/research-workflow/.claude/settings.json` as the "Current known template file" but does so descriptively, not as a path-match rule. Editing the agent without updating the template doc creates a documentation/implementation split.
- `logs/maintenance-observations-archive.md:20` also names `repo-health-analyzer/SKILL.md` as a second site needing the same exception. The proposed change covers only the agent, not the skill — partial coverage of an already-identified two-site fix.

### Dimension 4: Reversibility
**Risk:** Low

- Single-file prose edit; `git revert` cleanly restores the prior file.
- No generated artifacts, no log mutations, no settings cache, no symlink creation.
- The agent runs only on-demand inside subagent context; no per-session hook needs restart.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Functional overlap with existing Step 4a (CRITICAL).** The agent already implements an `INTENTIONAL-TEMPLATE` override at Step 4a (lines 98-106) keyed on the `{{[A-Z_]+}}` regex in path-type fields. The proposed change adds a second, path-based heuristic (`**/workflows/*/.claude/settings.json`) for the same concern. Without explicit reconciliation:
  - Two heuristics will fire on the same file; the agent prose must specify ordering (path-class first? regex first? union? short-circuit?).
  - The `CHANGE_DESCRIPTION` allows two implementations ("skip Rule 8 entirely OR accept `{{...}}` placeholder values as PASS") which differ materially — "skip Rule 8 entirely" is broader than Step 4a's value-level downgrade, and could mask real Rule 8 violations in template files (e.g., if a template ever has a stale absolute path alongside placeholders).
- **State drift on the canonical example file (CRITICAL).** The improvement-log entry (`improvement-log.md:63`) and `permission-template.md:239` both describe `ai-resources/workflows/research-workflow/.claude/settings.json` as containing `{{WORKSPACE_ROOT}}`. Direct read of the file (line 34) shows `"/Users/patrik.lindeberg/Claude Code/Axcion AI Repo"` — a hardcoded absolute path, NOT a placeholder. The placeholder has been resolved at some point since the improvement-log entry was written. Consequences:
  - Step 4a's `{{[A-Z_]+}}` regex no longer fires on this file (no placeholders left to match).
  - The proposed path-based heuristic WILL fire on this file (path still matches `**/workflows/*/.claude/settings.json`), and will mark it INTENTIONAL-TEMPLATE / ADVISORY — but the file's hardcoded absolute path is now functionally indistinguishable from a deployed project's `additionalDirectories`, so silencing Rule 8 here may hide a real "stale path" finding if the workspace is ever moved.
  - The premise of the change ("additionalDirectories: ['{{WORKSPACE_ROOT}}'] currently fires as false HIGH") is no longer accurate against the file on disk.
- **Undocumented contract change in template doc.** The path-based heuristic is not in `docs/permission-template.md`. Step 1 of the agent says "Do not invent new rules. Apply only the rules defined in the template" (line 35). Adding a path-based heuristic only in the agent contradicts the agent's own self-binding to the template doc.
- **Partial coverage of a two-site fix.** `maintenance-observations-archive.md:20` notes the same exception should also be added to `repo-health-analyzer/SKILL.md`. The proposed change covers only the agent, leaving the skill site for a future session.

## Mitigations

- **Dimension 3 (Medium) — reconcile template doc:** Update `docs/permission-template.md § Intentional-template exceptions` in the same commit to add the path-based heuristic alongside the existing `{{[A-Z_]+}}` regex heuristic. Otherwise the agent and the source-of-truth rulebook drift, and Step 1 of the agent ("Do not invent new rules — apply only the rules defined in the template") is silently violated.
- **Dimension 5 (High) — specify reconciliation between Step 4a and the new path-class step:** Pick one. Either (a) extend Step 4a's heuristic with an OR clause for path-class matches (single override, two signals), or (b) add a new Step 4b that fires before Rule 8 to short-circuit path-class files entirely. Do not leave both implementations present and let downstream readers guess the ordering. Recommendation: option (a), value-level downgrade (PASS-not-HIGH), because it preserves the ability to flag genuinely stale paths inside a template file.
- **Dimension 5 (High) — verify the canonical example file before landing:** Confirm whether `workflows/research-workflow/.claude/settings.json` line 34 *should* be `{{WORKSPACE_ROOT}}` (template-correct) or `/Users/.../Axcion AI Repo` (deployed-shape committed by accident). If the placeholder is the intended state, restore it in the same commit and update the SETUP.md instructions to match. If the hardcoded path is the intended state, update `permission-template.md:239` and `improvement-log.md:63` to reflect that the file no longer contains a placeholder — and re-evaluate whether the template-class exception is still needed at all.
- **Dimension 5 (High) — decide on `repo-health-analyzer/SKILL.md` scope:** Either include the parallel skill edit in the same session (recommended, since `maintenance-observations-archive.md:20` explicitly names it as a two-site fix), or explicitly defer it and log the deferral so the second site does not silently regress.

## Evidence-Grounding Note

All risk levels grounded in direct file reads (`permission-sweep-auditor.md` lines 5-10, 35, 98-106; `permission-template.md` lines 233-241, 305-331; `workflows/research-workflow/.claude/settings.json` line 34; `improvement-log.md:63`; `maintenance-observations-archive.md:20`) and grep counts across `ai-resources/.claude/`. No training-data fallback was used.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

# Pre-change advisory — `permission-sweep-auditor.md` template-class classification

## 1. Routing position (baseline)

The change is an edit to an existing canonical agent at `ai-resources/.claude/agents/permission-sweep-auditor.md`. Its canonical home is correct (`repo-architecture.md` § Canonical homes by artifact type — agent definition). The agent auto-symlinks into every project at next SessionStart (`repo-architecture.md` § Symlink topology). Touching it is in the "Canonical command/agent edit" class of `risk-topology.md` § 3 — gate-required (`/risk-check` plan + end-time). That gate has fired. No routing objection.

## 2. Concur with the PROCEED-WITH-CAUTION verdict — yes

The verdict is right and the dimension review captured the binding concern: Dimension 5 (Hidden coupling) at High. The proof is structural, not statistical:

- Step 4a in the existing agent body (lines 98–106) **already implements** the intentional-template override using the placeholder heuristic `{{[A-Z_]+}}`, downgrading the Rule 8 false-positive to ADVISORY.
- `permission-template.md` § Intentional-template exceptions (lines 234–241) defines the same heuristic as the source of truth.
- The proposed change adds a **second, parallel** path-based heuristic (`**/workflows/*/.claude/settings.json`) for the same suppression outcome.

Two heuristics targeting the same false-positive class on the same agent body violate OP-3 (loud failure over silent continuation) — the two paths can disagree silently, and the disagreement will not surface in the agent's output (`principles.md § OP-3`). It also sets up AP-1 (silent conflict resolution) in the agent itself: when one heuristic says PASS and the other says ADVISORY, the agent must pick one without surfacing the conflict (`principles.md § AP-1`).

The wider hidden-coupling chain is real:
- `permission-sweep-auditor` reads `permission-template.md` as its rule source (`repo-architecture.md` § Related canonical sources). Body↔template is a two-end contract per `risk-topology.md` § 5 "Signals that elevate a change to structural risk" — "Change modifies a string literal matched by another component."
- The agent is auto-synced to seven project sessions (`risk-topology.md` § 2 reverse map — auto-sync touches all 7 projects).
- `/permission-sweep` is consumed by `/friday-checkup` weekly tier (`repo-state.md` § 3 cadence tiers — `/permission-sweep --dry-run` runs every Friday).

So a divergence between path heuristic and placeholder heuristic ships to all weekly maintenance sessions for every project until detected.

## 3. The 4 mitigations are right — with one missing and one re-ordering

The risk-check reviewer's four mitigations are the right path. We concur with all four:

1. **Reconcile `permission-template.md` first** — necessary. The template is the source-of-truth (`permission-template.md` line 1) and the agent reads it. Changing the agent before the template inverts the contract direction (`risk-topology.md` § 1 — `principles.md` is High load-bearing because W2.2 targets its anchors; the same shape applies to `permission-template.md` and `permission-sweep-auditor`).
2. **Pick one implementation approach, not both** — necessary. Per `principles.md § DR-7` (generalize only when a second confirmed consumer exists) and § AP-7 (speculative abstraction), keeping both heuristics "for safety" is the failure mode the rule exists to prevent. The placeholder-based approach (Step 4a) is already shipped, already cited from the template, and self-documents (`{{...}}` literally shows the operator the contract). The path-based approach has one advantage — it catches a file whose placeholders were already filled in. That advantage does not justify a parallel rule; it justifies fixing the file.
3. **Verify the `workflows/research-workflow/.claude/settings.json` line 34 state** — necessary, and this should run **first**, before either of the first two mitigations. The improvement-log entry was booked 2026-04-28; today is 2026-05-25 — four weeks of drift. If the placeholders are still present, Step 4a handles the case and the path-based heuristic is unneeded (`principles.md § AP-6` — audit recommendations applied without impact analysis). If the placeholders are gone (file was filled in by a deploy), then the right fix is to restore the template state or remove the file from intentional-template scope, not to add a second classifier.
4. **Decide whether to bundle the parallel `repo-health-analyzer/SKILL.md` edit** — necessary. Bundling a second agent edit into the same risk-check window expands blast radius without expanding the gate's coverage. Per `principles.md § DR-8` and `risk-topology.md § 3`, each canonical agent edit is its own change class. Default position: unbundle. Run the SKILL edit through its own gate when it is ready.

**Re-ordering the mitigations:** the right sequence is 3 → 1 → 2 → 4. The reviewer listed them as 1 → 2 → 3 → 4. Running step 3 (verify current file state) first is dispositive — it determines whether the change is even needed and which approach is correct.

## 4. Risk the dimension review missed

**Missed risk — DR-9 top-3 command analysis was not applied.** The change is audit-derived (improvement-log entry from `/improve`). Per `principles.md § DR-9` and `risk-topology.md § 3` (Permission change → `/risk-check` + DR-9 top-3 analysis), any audit-derived change to a permissions-adjacent component requires listing the top-3 most-affected commands and confirming the change doesn't degrade them. The risk-check report's dimension breakdown does not surface this. The top-3 here are not optional:

1. `/permission-sweep` — direct consumer; behavioral change.
2. `/friday-checkup` — runs `/permission-sweep --dry-run` weekly (`repo-state.md` § 3); behavioral change ships to every weekly tier.
3. `/new-project` — emits the canonical project template that the agent later audits (`permission-template.md` § Layer D — "Emitted by `/new-project` Post-Pipeline Enrichment step 2"); if path-based classification is added that the project template does not match, `/new-project` outputs may start flagging.

The third item is the one most likely to bite. The path-based heuristic `**/workflows/*/.claude/settings.json` matches `ai-resources/workflows/*/.claude/settings.json` (correct target) and also `workflows/*/.claude/settings.json` at workspace root (correct target if `workflows/` survives). But `repo-state.md § 2` pending step #1 — "rm -rf workflows/" — has been outstanding since 2026-04-29 (four weeks). If the deletion eventually happens, the path pattern still matches `ai-resources/workflows/`, so this is recoverable. But the implicit assumption that the path heuristic targets a stable subtree is worth naming.

**Missed risk — QS-9.** The proposed change is an automation-produced system change (improvement-log → fix). Per `principles.md § QS-9`, it passes the same QC and risk-check gates as operator-produced changes. The risk-check fired; QC has not yet run on the proposed edit. The plan should not skip the independent QC pass on the agent body diff before the end-time gate.

**Missed risk — fading-gate calibration.** The improvement-log entry is four weeks old. The original case (research-workflow template with placeholders) may or may not still exist. Applying a fix derived from a four-week-old observation without re-verifying the trigger is the `[FADING-GATE]` pattern (per the memory entry "Gate-calibration system — record decisions when [FADING-GATE] fires"). This is mitigated by mitigation #3 (verify the file state) but should be called out explicitly in the risk-check skip decision.

## 5. Position

The right answer is: **execute mitigation 3 (verify file state) first, alone, before any code edit.** Three outcomes:

- **File still contains `{{...}}` placeholders** → Step 4a handles it. The path-based change is not needed. Close the improvement-log entry as "already covered by Step 4a; no edit required." This is the most likely outcome and the highest-ROI exit.
- **Placeholders are gone (file deployed in place)** → The file should not be a template anymore. Move it out of `ai-resources/workflows/research-workflow/` (the workflow-template home per `repo-architecture.md`) or restore the placeholder form. The agent body does not need a second classifier; the file needs to be in the right shape.
- **The change is still genuinely warranted after 3** → Then mitigations 1 → 2 → 4 apply in order, with the path heuristic **replacing** Step 4a (not coexisting). One heuristic per concern (`principles.md § AP-7`, § DR-7).

Bundling the `repo-health-analyzer/SKILL.md` edit into this risk-check window: **no.** Unbundle (`risk-topology.md § 3` — each canonical agent/skill edit is its own change class).

The PROCEED-WITH-CAUTION verdict is correct; the mitigations are right; the sequencing should be 3 → 1 → 2 → 4; and DR-9 top-3 analysis plus QS-9 independent QC should be added to the mitigation list before end-time gate fires.
