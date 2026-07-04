# AI Resource Creation Rules

> **When to read this file:** When a session identifies the need for a new or modified AI resource (skill, command, agent definition, workflow template), or when routing a skill request. Before invoking a creation pipeline below, if placement is non-obvious, run `/placement` first — see workspace `CLAUDE.md` § Placement Discipline.

When a session identifies the need for a new or modified AI resource:

1. **Shared AI resources belong in `ai-resources/`.** Reusable skills, commands, and agent definitions — anything that could plausibly serve more than one project — belong in `ai-resources/`. Project workspaces consume shared resources via symlink or copy; they never own them. Project-specific *pipeline* commands and evaluator agents (e.g., pipeline commands tightly coupled to one project's workflow) are allowed to live locally in the project's own `.claude/` when they are tightly coupled to that project's pipeline and not intended for reuse.

2. **Do not improvise skill-like artifacts.** If the task calls for reusable procedural instructions, it's a skill — route it through the canonical pipeline.

3. **Capture the need, then route to the pipeline.** When working in a project and a skill gap surfaces, use `/request-skill` to write a structured brief to `ai-resources/inbox/`, then hand off to `/create-skill` in the same session. The `ai-resources/` directory is connected via `--add-dir` — no session switch needed.

4. **Always use the canonical pipelines:** `/create-skill` for new skills, `/improve-skill` for modifications, `/migrate-skill` for converting existing prompts. These pipelines include QC gates — skipping them means skipping quality assurance.

5. **Graduation requires confirmation from every existing canonical consumer.** Before graduating a project fork to canonical (i.e., extending the canonical contract with content that originated in one project), enumerate every existing canonical consumer (other projects that consume the resource via symlink or import) and confirm with the operator that each consumer is OK absorbing the change. Record the confirmation in the commit message. **Reason:** `principles.md § DR-7 — Generalize only when a second confirmed consumer exists`. The "one confirmed consumer + one non-consenting consumer about to absorb the result" pattern is the failure mode this rule prevents — project IP silently spreading into canonical and propagating to other projects without their review. Parameterizing the project-specific value through a project-config knob (so each consumer chooses its own value) is structurally cleaner than graduating the value itself; prefer that path when the value is the project-specific part.

6. **Generalization-residue verification is mandatory at Step 5.5** (added 2026-05-29; Friday-checkup session-qc-pipeline #4). After `/graduate-resource` Step 5's main-agent self-check, an independent fresh-context subagent grep-scans the generalized file for residue from the source project's `CLAUDE.md` (project names, hardcoded paths, domain terminology). On residue found, a fail-and-revise loop (capped at 2 passes — same discipline as `docs/qc-independence.md` § QC → Triage Auto-Loop) re-runs Step 4 with the residues as explicit revision targets. **Reason:** main-agent self-check on its own output systematically under-detects what reads as generic to the author but as project-specific to a fresh reader. The subagent provides the independent perspective; the loop cap prevents infinite revision against structural mismatches. Boundary: this check verifies *generalization*; *placement* remains owned by `Step 3a` (plan-time) and `Step 5a` (end-time) via `docs/placement-verifier.md`. If both fire, placement-verifier wins on placement-related findings; the residue check defers.

7. **Complexity budget — no new component that doesn't earn its keep.** No new command, agent, mandatory stage/gate, or permanent always-loaded document may be introduced unless it clears **at least one** prong:
   - **(a) Net-simplification prong** — the change reduces or holds the count of *load-bearing units* (commands, agents, mandatory stages/gates, always-loaded context) while preserving capability. A merge/consolidation that removes ≥1 existing component satisfies (a); a change that adds net components does **not**.
   - **(b) Evidenced-failure prong** — the change addresses a failure mode with **cited written evidence**: a `logs/friction-log.md` / `logs/defect-log.md` / `logs/coaching-log.md` / `logs/incident-log.md` entry, or a pattern seen ≥2 times. "We might need it," "for completeness," or "for a future phase" does **not** satisfy (b) — that is the AP-7/DR-7 speculative-abstraction violation.

   Before introducing the component, answer all five (record the answers where the decision is made — plan file, risk-check, or `logs/decisions.md`):
   1. What recurring failure does it prevent?
   2. How likely / frequent is that failure?
   3. What does it cost — time, context, operator attention, per-session token load?
   4. Could the same control fire **conditionally** (risk-tiered) instead of always?
   5. Does an existing component already do this, or ~80% of it? (If yes → extend it, don't add.)

   **Distinct from `docs/materiality-bar.md`:** that bar governs which *review findings* become Findings; this gate governs whether a new *resource* gets created — a different lifecycle stage. **Operationalizes at creation time** the AP-7/DR-7 speculative-abstraction ban (generalize only on a second confirmed consumer) and **OP-12** (closure before detection): a new *detection* component — an audit, scan, flag, or finding-generator — must additionally ship its **closure channel** (the thing that acts on what it finds) in the same change to clear the gate. A new component that fails prong (a), leans only on prong (b), and is a detector still needs its closer; shipping the detector alone is an OP-12 violation.

   If a component is introduced despite failing the gate, that is a **loud, recorded principle exception (OP-11)** — a deliberate decision logged in `logs/decisions.md` with its rationale, never an in-line "it's fine actually" assertion. `/risk-check` (via `risk-check-reviewer` Dimension 6) enforces this gate at land-time; `/leverage-idea` applies it at proposal-time.

## Bulk-backfill Exception

Rule #4 (canonical pipeline mandate) admits a narrow exception for one-time bulk frontmatter backfill operations: mechanical edits to many skills that change only frontmatter (no body changes), where running the full pipeline per skill would produce 50+ identical fix passes with no QC signal.

When invoking the exception:

1. **Document the exception** in the commit message (one line) and in `logs/improvement-log.md` (one entry naming the date, file count, and field(s) added).
2. **Substitute single-batch verification** for per-file post-edit QC. Run grep checks across the entire backfilled set to confirm: (a) every targeted file received the new field(s); (b) every value is within the allowed convention. Document the verification commands in the commit message.
3. **Limit scope.** The exception covers frontmatter-only edits with no body changes. Any edit that touches skill behavior (descriptions changed beyond formatting, body rewrites, structural reorganization) must use the canonical `/improve-skill` pipeline, not this exception.

Recorded invocations:

- **2026-04-28** — Bulk backfill of `model:` and `effort:` to all 69 existing skills (single mechanical 2-line insert per file). Verified via single-batch grep against required field presence and allowed values.

## Workflow-improvement surfaces

When a session identifies that a workflow (skill, command, pipeline) needs improvement, two distinct surfaces handle this — they have different inputs and different exit criteria, and must not be confused.

**`improvement-analyst` agent — session-friction-driven.**
Reads session friction events captured by the friction logger (`logs/friction-log.md`). Diagnoses recurring failure patterns observable across sessions — repeated rework cycles, misclassifications, hook misfires, navigation friction. Output proposes workflow fixes tied to friction signal frequency, ordered by ROI. Invoked via `/improve` at session-end and by `/friday-checkup` monthly catch-up.

- **Trigger:** "Sessions are producing recurring friction X — what workflow change would prevent it?"
- **Input:** session friction logs.
- **Surface:** session-level workflow weaknesses observable only across multiple runs.

**`workflow-diagnosis` skill / `/diagnose-workflow` command — artifact-defect-driven.**
Reads a delivered artifact (a chapter, a report, a section directive) and a defect description. Traces the defect back through the workflow chain to identify which workflow step produced the gap. Output proposes workflow fixes tied to the specific defect class. Invoked when an artifact has a concrete defect whose root cause is upstream in the workflow.

- **Trigger:** "This delivered artifact has defect X — which workflow step is the gap?"
- **Input:** the artifact + a defect description.
- **Surface:** artifact-level workflow gaps traceable to a single upstream step.

**Routing rule.** A session that produces friction events suggesting a workflow weakness → route to `improvement-analyst` via `/improve`. A delivered artifact with a defect whose cause traces back to a workflow step → route to `workflow-diagnosis` / `/diagnose-workflow`. Friction signals are inputs to the analyst; artifact defects are inputs to the diagnosis skill. Do not run the analyst against an artifact defect, and do not run the diagnosis skill against session-friction telemetry — the inputs do not generalize and the outputs would be misdirected.

The two surfaces are complementary, not redundant: the analyst sees patterns across sessions; the diagnosis skill sees a single concrete failure with a backwards trace. A workflow weakness may surface through both paths independently — that's expected, not double-counting.

Status note: the `workflow-diagnosis` skill is in the resource pipeline (`inbox/workflow-diagnosis.md`) as of 2026-05-19 and is not yet built. The command name `/diagnose-workflow` used above is the leading candidate per the inbox brief's "Likely implementation surface" line — the final name is set when `/create-skill` runs and may change. Until the skill ships, all workflow-improvement work routes through `improvement-analyst`. This boundary doc lands first to prevent the planned skill from being conflated with the analyst once it is built; the command-name reference should be reconciled with the actual name at skill-creation time.
