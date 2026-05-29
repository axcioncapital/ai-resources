# Risk Check — 2026-05-29

## Change

Add a new Step 8.5 to the AI Development Lab's /analyze-transcript pipeline command (.claude/commands/analyze-transcript.md), inserted between Step 8 (memo compilation) and Step 9 (operator disposition gate). Step 8.5 spawns the qc-reviewer agent via the Task tool with the compiled memo.md + the four analysis source files (extraction.md, grilling.md, analysis-ai-engineer.md, analysis-system-owner.md) + pipeline/ref-memo-template.md. The reviewer verifies all twelve memo fields are present/non-empty, the verbatim-citation anchor resolves against analysis-system-owner.md, and the recommendation follows the rubric; returns GO/NO-GO. On NO-GO the pipeline halts and reports before the memo reaches the operator. Supporting edits: update Step 2 resume detection to account for the new stage, add an Error-handling table row, update /review-pipeline-run.md to check the QC gate ran, and add one line to the lab CLAUDE.md Pipeline section. This is a project-local command (model: sonnet), not a canonical/auto-synced one. Rationale for the change: the memo is the lab's only durable artifact and currently the one place the lab skips the workspace-wide QS-1/QS-3 fresh-context-QC invariant — Step 8 has only self-checks run by the same session that wrote the memo. Source: output/reviews/2026-05-29-pipeline-soundness-fix-report.md Gap 2 (priority 1st); operationalized in output/plans/2026-05-29-pipeline-improvement-plan.md Item A.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/.claude/commands/analyze-transcript.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/.claude/commands/review-pipeline-run.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/pipeline/ref-memo-template.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/output/reviews/2026-05-29-pipeline-soundness-fix-report.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/output/plans/2026-05-29-pipeline-improvement-plan.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A well-grounded, reversible quality-gate addition whose only elevated dimensions are blast radius (a four-file coordinated edit with two contract touchpoints) and hidden coupling (a reused "Step 8.5" number that previously named a now-dead stage, plus an implicit dependency on the synced qc-reviewer agent's GO/NO-GO contract) — both carry concrete paired mitigations.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No content added to an always-loaded file beyond a single CLAUDE.md Pipeline line — change description: "add one line to the lab CLAUDE.md Pipeline section" (well under the ~50-token Medium threshold).
- No auto-load hook registered. The Task dispatch fires only inside `/analyze-transcript`, which is operator-invoked per transcript — pay-as-used, not per-session or per-tool-call (analyze-transcript.md:1-9, command entry point).
- The qc-reviewer dispatch is one additional Task call per pipeline run, comparable in cost to the three Task dispatches the pipeline already makes (Step 6a, Step 6b, Step 7 — analyze-transcript.md:92, 123, 165). Incremental, bounded, and the most expensive runs already dominate this cost.
- qc-reviewer is `model: opus` (qc-reviewer.md:4); the host command is `model: sonnet` (analyze-transcript.md:3). The QC dispatch runs at Opus tier per the agent's own frontmatter — a per-run cost increment, but only on the QC subagent, not the main session, and only when a pipeline run reaches Step 8.5.

### Dimension 2: Permissions Surface
**Risk:** Low

- No permission entries added, removed, or widened. The change is command-spec text plus a CLAUDE.md line.
- Task-tool dispatch of qc-reviewer requires no new authorization: the project already dispatches three subagents via Task (system-owner, ai-engineer) and qc-reviewer is already symlinked into `.claude/agents/qc-reviewer.md` (verified via `ls` — symlink to ai-resources). The agent's tool set is read-only plus Write (qc-reviewer.md:5-9) and writes only optional working notes to `audits/working/` (qc-reviewer.md:133), already within the Write permission the lab CLAUDE.md grants ("Write permission to ai-resources/ is allowed").
- No scope escalation, no cross-repo or external capability introduced.

### Dimension 3: Blast Radius
**Risk:** Medium

- Four files touched in a coordinated edit, per the change description and confirmed against the plan (Item A target files, pipeline-improvement-plan.md:88-91): `analyze-transcript.md` (new Step 8.5 + Step 2 resume detection + Error-handling row), `review-pipeline-run.md` (new-stage check), `CLAUDE.md` (one Pipeline line), and an implicit dependency on `ref-memo-template.md` (passed to qc-reviewer as the contract). More than a single isolated file.
- Two contract touchpoints, both backwards-compatible: (a) Step 2 resume-detection logic must learn the new stage boundary (analyze-transcript.md:34-39 currently keys resume on `memo.md` existence at Step 8 — a memo.md-exists-but-QC-not-run state is newly possible and must be handled); (b) `/review-pipeline-run` Stage 6 / Workflow assessment must check the gate ran (review-pipeline-run.md:143-174, 179-188).
- Reference enumeration: `grep -rl "analyze-transcript"` returns ~40 files across the project, but these are overwhelmingly logs, prior memos, reviews, and pipeline reference docs that *mention* the command, not callers that invoke it programmatically. No command, agent, or hook in ai-resources or the project calls `/analyze-transcript` as a dependency — it is an operator entry point. `grep -rl "review-pipeline-run"` returns ~24 files, same pattern (logs/reviews/audits, no programmatic callers).
- The change touches shared pipeline control flow (resume detection, error table) that the single command owns; no other workflow reads that control flow. The only genuine downstream caller requiring a coordinated edit is `/review-pipeline-run`, which the change description already accounts for.
- qc-reviewer is a shared/synced agent (NOT in shared-manifest.json local list — confirmed; it is symlinked from ai-resources). Adding a new *consumer* of qc-reviewer does not modify the agent, so the blast radius does not extend to qc-reviewer's other callers (`/qc-pass`, `/friday-journal` Step 5.5 — qc-reviewer.md:3).

### Dimension 4: Reversibility
**Risk:** Low

- All four edits are in-place spec/text edits to version-controlled files; `git revert` fully restores prior state within the working tree. No sibling files or directories are created by the change itself.
- The new run-time artifact (a qc-reviewer GO/NO-GO result) is produced per pipeline run and lives in transient session context or, at most, an optional `audits/working/qc-{date}-{topic}.md` note (qc-reviewer.md:133) — reverting the command spec does not require cleaning up past run outputs, and any such notes are inert history.
- No state propagates beyond git: no push-coupled state, no external write, no log-schema mutation. The pipeline-log row format (analyze-transcript.md:289-293) is unchanged by this item (the change description does not alter Step 10).
- No automation (hook/cron) is added, so nothing can fire between landing and a potential revert.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Number-reuse collision.** "Step 8.5" / "Stage 8.5" previously named a *different* mechanism — the implementation-starter schema — which the consolidated plan marks DEAD: "P4 — wire inline Stage 8.5 … Superseded by the externalized /develop-memo command … DEAD — do not re-import" (pipeline-improvement-plan.md:42). A prior risk-check on disk is titled `2026-05-27-analyze-transcript-stage-8-5-implementation-starter.md`. Reusing the 8.5 label for an unrelated QC gate risks future sessions, logs, and audits conflating two distinct "8.5" meanings. The CLAUDE.md Pipeline section and `/develop-memo` references (lab CLAUDE.md "How to invoke") still describe the 8.5 implementation-starter lineage in the Section-A schema context — a reader cross-referencing "8.5" could land on the wrong concept.
- **Implicit dependency on the qc-reviewer contract.** qc-reviewer returns `GO | REVISE | FLAG FOR EXTERNAL QC` (qc-reviewer.md:122), NOT the `GO / NO-GO` the change description specifies. The pipeline halt logic must map qc-reviewer's three-value verdict onto the binary NO-GO halt — an undocumented translation the change site must define explicitly, or the halt condition silently mis-fires (e.g., a REVISE or FLAG verdict with no mapped behavior). This is a real contract mismatch between the described intent and the actual agent output shape.
- **qc-reviewer description scoping.** The agent's own description reads "Invoked by /qc-pass and /friday-journal Step 5.5. Do not use for other purposes." (qc-reviewer.md:3). Adding `/analyze-transcript` Step 8.5 as a third caller contradicts that "do not use for other purposes" clause — a documented-contract conflict that should be reconciled (either update qc-reviewer's description in ai-resources, or confirm the lab's use is sanctioned) so the coupling is not silently violated.
- **Mirror-doc maintenance pattern.** The pipeline already carries two silent-staleness couplings with explicit maintenance notes (Gate 1.5 trigger-phrase coupling, analyze-transcript.md:237-240; consult.md mirror-source, Gap 1). Adding a QC gate that depends on `ref-memo-template.md`'s twelve-field list creates a fourth implicit coupling: if the template's field count or citation-anchor format changes, the qc-reviewer's check goes stale unless the dependency is documented at the change site.

## Mitigations

- **Blast radius (Medium):** Land all four edits in a single commit (per the plan's own sequencing guidance, pipeline-improvement-plan.md:273-283 — do Item A last among command edits, fold the `/review-pipeline-run` touch together), and in the same edit update Step 2 resume detection to add the explicit new state: `memo.md exists AND QC gate not yet recorded → resume from Step 8.5`. Verify after landing that no resume path leaves a memo.md-present-but-unreviewed run in an ambiguous state.
- **Hidden coupling — verdict contract (Medium):** In the Step 8.5 spec, explicitly define the verdict mapping: state how qc-reviewer's `GO / REVISE / FLAG FOR EXTERNAL QC` (qc-reviewer.md:122) maps to the pipeline's halt decision (e.g., GO → proceed to Step 9; REVISE or FLAG → halt and report). Do not write the spec against a `GO / NO-GO` shape the agent does not emit.
- **Hidden coupling — number reuse (Medium):** Either (a) pick a label that does not collide with the dead implementation-starter "8.5" (e.g., "Step 8b — memo QC gate") to avoid conflating two distinct meanings across logs/audits, or (b) if 8.5 is retained, add a one-line note at the change site and in the CLAUDE.md Pipeline line clarifying that the prior 8.5 (implementation-starter) is superseded and this 8.5 is the memo QC gate.
- **Hidden coupling — agent description (Medium):** Reconcile qc-reviewer's "Do not use for other purposes" clause (qc-reviewer.md:3) — update the agent description in ai-resources to list `/analyze-transcript` Step 8.5 as a sanctioned caller, so the new coupling does not silently violate the agent's stated contract. (This is a separate ai-resources edit; sequence it with the lab change.)
- **Hidden coupling — template dependency (Medium):** Add a maintenance note at the Step 8.5 site recording the `ref-memo-template.md` twelve-field dependency, mirroring the existing Gate-1.5 maintenance-note pattern (analyze-transcript.md:237-240), so a future template field change does not silently stale the QC check.

## Recommended redesign

(Not applicable — verdict is PROCEED-WITH-CAUTION.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, the qc-reviewer agent definition, the shared-manifest, and on-disk artifact listings). No training-data fallback was used on fetch/read failures.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

### Pre-Change Advisory — Memo-QC Gate (Step 8.5) in `/analyze-transcript`

**Routing position.** `/analyze-transcript` is a sanctioned project-local pipeline-stage command (DR-1 project-local tier; `risk-topology.md § 3`). Adding an always-run subagent dispatch crosses two gated classes — a new always-run automation step with shared-state effect, and (if a new agent is defined) a new agent definition. `repo-architecture.md` correctly does NOT require a same-commit update: project-local pipeline-stage addition, not a topology change.

**Concurs with PROCEED-WITH-CAUTION; the contract defect is the real blocker.** `qc-reviewer` returns `GO / REVISE / FLAG FOR EXTERNAL QC` (qc-reviewer.md L122), not a binary. A "halt on non-pass" gate built on a binary contract mis-handles `REVISE` (the most common non-GO verdict). Unreconciled three-valued/two-valued mismatch is a latent correctness fault in an always-run gate (OP-3 — loud failure over silent continuation). Map all three: `GO` → memo proceeds; `REVISE` → halt with findings surfaced; `FLAG FOR EXTERNAL QC` → halt and route to operator. Rename the step off "8.5" (collides with the dead implementation-starter Stage 8.5 referenced by `/develop-memo`) — use Step 8b or 8.6.

**Judgment call (1) — reuse canonical `qc-reviewer`, do NOT fork.** A lab-local memo reviewer is speculative abstraction (AP-7, DR-7) — the memo is a new-artifact, prose-shaped doc against a field template = the full-rubric case (qc-reviewer.md L39). `qc-reviewer` is Critical/High load-bearing (`risk-topology.md § 1`). The "do not use for other purposes" clause (qc-reviewer.md L3) is a two-end contract (`risk-topology.md § 5`); adding `/analyze-transcript` Step 8b as a third caller requires editing that description — a canonical-agent edit, itself gated (`risk-topology.md § 3`), touching three other projects → apply DR-9 top-3 (the edit is additive; confirm no behavior change for `/qc-pass` / `/friday-journal`). Named conflict: lab CLAUDE.md frames canonical agents as consumed as-is via symlink; the honest resolution is that adding a sanctioned caller is a canonical-resource edit belonging in ai-resources gated by `/risk-check`, not a lab-local maneuver. Forking to dodge a one-line additive edit buys permanent maintenance cost — not recommended.

**Judgment call (2) — no conflict with "lean R&D."** A write-once durable artifact that skips fresh-context QC is the one place the lab violates QS-1 / QS-3. "Lean" governs how much machinery the lab builds, not whether durable outputs get independent QC (QS-9; OP-9 paired constraint). One always-run dispatch of an existing agent against an existing template is the leanest way to close the hole. Cost note: this is a per-run Opus dispatch (qc-reviewer is `model: opus` regardless of the command's `model: sonnet`); add the Step 8b dispatch to the Memo Metadata per-run cost line so it stays visible.

**Risk the dimension review missed.** The QC criteria passed to `qc-reviewer` are a SECOND two-end contract with `ref-memo-template.md` with nothing keeping them in sync. When the template changes (explicitly editable), hardcoded criteria in Step 8b drift and the gate checks against a stale field set — silently passing non-conforming memos. Mitigation: pass `ref-memo-template.md` BY PATH as the criteria source (reviewer reads it live), not hardcoded into the command body (AP-3 — constraints over procedures). Removes the drift surface entirely.

**Clear position.** Land the gate; reuse canonical `qc-reviewer`; reconcile the three-valued verdict before landing; rename off "8.5"; edit the canonical agent's description to add `/analyze-transcript` as a sanctioned caller (gated by `/risk-check` + DR-9 top-3); pass the memo template by path as the criteria source; add the new dispatch to the per-run cost line. PROCEED-WITH-CAUTION is correct; named mitigations are the correct path, plus the two additions above (template-path criteria, cost-line update).
