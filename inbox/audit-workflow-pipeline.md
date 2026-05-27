# Resource Brief: audit-workflow-pipeline

**Requested:** 2026-05-27
**Origin:** nordic-pe-macro-landscape-H1-2026 — Operator ran a 5-pass workflow audit ad-hoc this session (`audits/workflow-audit/` in that project, 10 files + master `00-findings-summary.md`). The methodology produced a graduation-ready Blocking/Flagging finding set with a structured fix-phase handoff. Reusable across any workflow being prepared for graduation into `ai-resources/workflows/`; warrants a canonical command + supporting skill triplet.
**Reference execution:** `projects/nordic-pe-macro-landscape-H1-2026/plans/workflow-audit-plan-v1.md` (the plan) + `projects/nordic-pe-macro-landscape-H1-2026/audits/workflow-audit/` (the outputs, ~2,700 lines across 10 files).

---

## Capability

A single command, `/audit-workflow` (working name — see § Naming), that runs a 5-pass independent audit of a Claude Code workflow and produces a structured master findings file ready to hand off to a fix-phase planning session. The audit treats the workflow as a deliverable unit being prepared for graduation into `ai-resources/workflows/`.

Five passes, each with a clear input/output contract:

1. **Pass 1 — Review-surface inventory.** Enumerates the workflow's deployed surface (commands, skills, reference docs, agents, hooks). Facts only — no judgment.
2. **Pass 2 — Remediation verification** *(conditional)*. If the workflow's repo has a fix-plan history (e.g., `report/diagnostics/**/fix-proposal-v*.md` or operator-named path), verifies that the documented remediations landed as designed against the line-level spec. Skipped with a logged reason if no fix plan is detected.
3. **Pass 3 — Canonical audits.** Runs the 5 existing canonical audits (`/analyze-workflow`, `/audit-repo`, `/token-audit`, `/repo-dd`, `/innovation-sweep`) scoped to the workflow surface from Pass 1.
4. **Pass 4 — Generalization-fitness.** Identifies which assumptions in the workflow are Generic / Configurable / Hardcoded for a calibration audience. Evaluates 3 hypothetical adjacent projects to surface blockers.
5. **Pass 5 — Template-fitness.** Compares the workflow against the canonical workflow template; classifies each file as Template-ready / Needs-parameterization / Project-only; recommends target template shape and migration cost.

Plus a **master aggregation step**: deduplicates cross-pass findings, classifies each as Blocking or Flagging per finding thresholds, structures a fix-phase candidate list with dependency-aware sequencing.

Optionally a **Pass 2.5 — Diagnostic-history scan**: light read of the fix-plan evolution (v1 → v6 or equivalent) to surface abandoned ideas the final plan dropped. Default skip; conditional re-run if Pass 4 or Pass 5 surfaces an architectural pattern not covered by the latest fix plan.

---

## Trigger Conditions

A workflow has been used in production, is approaching project-end, and the operator wants an independent audit before either (a) closing the project, (b) graduating the workflow into the shared library at `ai-resources/workflows/`, or (c) authoring a fix-phase remediation plan for the next iteration.

Phrasings:
- "Audit this workflow end-to-end before we graduate it"
- "Run a workflow audit on `<workflow>`"
- "Diagnose the workflow before fix-phase planning"
- "Is this workflow ready for the template library?"
- "I want to see what's broken / what's hardcoded / what's reusable before I decide what to do next"

Output → directly ingestible by a **fix-phase planning session** (Phase 2 of the audit → fix → graduate arc).

---

## Exclusions

This command does NOT:

- **Implement fixes** — that's the separate fix-phase session that ingests `00-findings-summary.md` Section 5. The command is triage only.
- **Graduate the workflow** — that's the separate graduation-phase session (Phase 3). Pass 5 only recommends what graduation would look like.
- **Diagnose artifact defects** — `workflow-diagnosis` already covers the "operator notes on a pipeline output → workflow-improvement spec" path. This pipeline audits the workflow INFRASTRUCTURE (commands, skills, refs); `workflow-diagnosis` works from artifact-level defects backward to workflow loci. Different direction.
- **Critique a single skill** — that's `audit-critical-resources` (single resource, 7 dimensions). This pipeline operates on a workflow-as-a-system.
- **Re-implement existing canonical audits** — Pass 3 INVOKES `/analyze-workflow`, `/audit-repo`, `/token-audit`, `/repo-dd`, `/innovation-sweep`. The pipeline composes; it does not duplicate.
- **Author a graduated template** — Pass 5 sketches the target shape; the actual graduation work lives in `/graduate-resource` + a graduation-phase session.
- **Manage sessions** — `/prime`, `/session-start`, `/session-plan`, `/wrap-session` remain operator-invoked.

### Distinguishes from sibling resources

| Resource | Distinction |
|---|---|
| `workflow-system-analyzer` (skill) | Building block of Pass 1 (factual inventory). This pipeline INVOKES it; doesn't replace it. |
| `workflow-system-critic` (skill) | Building block of Pass 3's critique. This pipeline INVOKES it as part of Pass 3 (or via `/analyze-workflow` which already wraps it). |
| `workflow-evaluator` (skill) | Building block of Pass 5 (architectural soundness vs `workflow-creator`/`workflow-documenter` patterns). This pipeline INVOKES it. |
| `workflow-diagnosis` (planned skill, brief at `ai-resources/inbox/workflow-diagnosis.md`) | Artifact-defects → workflow-locus direction. This pipeline runs the OPPOSITE direction — workflow infrastructure → graduation/fix readiness. Complementary, not overlapping. |
| `/analyze-workflow` (existing command) | A subset of Pass 3 (one of 5 audits). This pipeline INVOKES it. |
| `audit-critical-resources` (existing skill) | Single-resource, 7-dimension audit. This pipeline is workflow-system-wide. Different scope. |
| `audit-repo` (existing skill) | Workspace-wide health audit. This pipeline scopes to one workflow's surface. |
| `repo-dd` (existing skill) | Repo-as-deliverable due diligence. Pass 3d INVOKES it scoped to the workflow surface. |

---

## Naming

Collision check against `ai-resources/.claude/commands/` (all four are FREE at audit time):
- `/audit-workflow` — **recommended.** Matches the operator's phrasing ("audit this workflow"). Symmetric with `/audit-repo`, `/audit-critical-resources`, `/audit-claude-md`, `/audit-structure`.
- `/workflow-audit` — naming-pattern alternative; slightly less idiomatic (verb-first convention is the norm in the workspace).
- `/audit-workflow-stack` — clearer scope cue ("stack" = the orchestrator, not the underlying audits) but verbose.
- `/workflow-graduation-audit` — most descriptive but locks the command into one of its three use cases (graduation, fix-phase prep, project-end review).

**Risk:** `/analyze-workflow` exists and is reused as a Pass 3 component. Be careful in documentation to distinguish `/analyze-workflow` (one canonical audit) from `/audit-workflow` (the 5-pass orchestrator that includes it). Suggest the orchestrator command begin its docs with: "Not to be confused with `/analyze-workflow`, which is invoked as one of five sub-audits in Pass 3."

`/create-skill` should reconfirm the name against any new commands created since this brief.

---

## Architecture

The resource consists of one orchestrator command + 3 net-new skills + 0 net-new agents (Pass 3 reuses existing). Pass 1 reuses an existing skill; Pass 2-5 each have a dedicated skill.

### Component map

| Component | Type | Tier | Status | Notes |
|---|---|---|---|---|
| `/audit-workflow` | command | sonnet | **NEW** | The orchestrator. Drives the 5-pass sequence, handles stop points, aggregates the master findings file. |
| `workflow-system-analyzer` | skill | haiku, low | **EXISTS** | Pass 1 (review-surface inventory). Invoked verbatim. |
| `workflow-remediation-verifier` | skill | sonnet, medium | **NEW** | Pass 2 (verify N S-XX-style remediations against a fix-plan spec). Conditional invocation. |
| `workflow-system-critic` | skill | opus, high | **EXISTS** | A component of Pass 3 (already invoked by `/analyze-workflow`). |
| `workflow-evaluator` | skill | opus, high | **EXISTS** | Likely a component of Pass 5 (architectural soundness). |
| `workflow-generalization-fitness` | skill | opus, high | **NEW** | Pass 4 (assumption inventory + 3-hypothetical-project fitness check). |
| `workflow-template-fitness` | skill | opus, high | **NEW** | Pass 5 (canonical-vs-project deltas, per-file classification, target-template shape). |
| `workflow-audit-aggregator` | skill | opus, medium | **NEW** *(optional)* | Master-findings aggregation. Could also live inline in the orchestrator command. `/create-skill` decision. |

### Pass 3 reuses existing commands as subagent tasks

For each of the 5 canonical audits, the orchestrator spawns one general-purpose subagent whose brief is: "read `ai-resources/.claude/commands/<audit>.md` as your methodology guide; apply it scoped to the workflow surface from Pass 1; write to `audits/workflow-audit/03-<audit>.md`." This matches the pattern the reference execution used (see Pass 3 brief examples below). It avoids re-implementing audit logic.

Alternative consideration for `/create-skill`: invoke the canonical audits as Skill calls instead of subagent reads. Risk: each canonical audit is itself a multi-step orchestrator; running 5 of them in the main session is heavy. Recommendation: keep the subagent-delegation pattern unless `/create-skill` finds a cleaner path.

---

## Methodology — distilled from the reference execution

The full methodology is in the reference plan at `projects/nordic-pe-macro-landscape-H1-2026/plans/workflow-audit-plan-v1.md` and the reference outputs at `projects/nordic-pe-macro-landscape-H1-2026/audits/workflow-audit/`. `/create-skill` should read both as primary sources. Distilled here for orientation.

### Pass 1 — Review-surface inventory (uses `workflow-system-analyzer`)

**Goal:** Enumerate the workflow's deployed surface. Facts only.

**Output sections:**
1. Deployed pipeline commands (Stages 1–4 for research-workflow-shaped; generic stages for others)
2. Stage 5 polish / post-production commands (if applicable)
3. Review / verify commands
4. Support commands
5. Project reference docs
6. Workflow-stack skills consumed
7. Canonical-only-but-referenced commands (deployment-gap notes)
8. Dependency map (command → invoked-skills + reference-doc → reading-commands)

**Scope rule:** Include commands part of the workflow production chain. Exclude session-management commands (`/prime`, `/session-plan`, etc.) and general workspace infrastructure (`/audit-*`, `/repo-dd`, etc.). When in doubt: included if cited in stage instructions or invoked by a stage command; excluded if it's an analytical/system tool.

**Subagent brief template** (reference: this session's Pass 1 brief). The orchestrator should template this with the actual workflow path and known scope-rule overrides if any.

### Pass 2 — Remediation verification *(conditional)*

**Trigger detection:** the orchestrator looks for fix-plan history in:
1. `<workflow-repo>/report/diagnostics/**/*-fix-proposal*.md` (research-workflow pattern from reference execution)
2. `<workflow-repo>/audits/**/*-fix-plan*.md` (alternative pattern)
3. Operator-provided `--fix-plan=path/to/spec.md` arg override
4. None found → skip Pass 2; log the skip reason in the master findings file as a coverage gap.

**If triggered, output:** 19-row-style verdict table — one row per S-XX (or equivalent) remediation, with verdict ✅ Applied / ⚠️ Drift / 📋 Deferred-as-intended + evidence (file:line) + drift severity if applicable.

**Method:**
1. Identify landing surface per the fix plan
2. Read the line-level spec section
3. Read the landed code/text on disk
4. Compare; assign verdict

**Drift severity:** behavior-affecting / advisory-tone / cosmetic. Only behavior-affecting drift triggers the post-Pass-2 stop point.

### Pass 2.5 — Diagnostic-history scan *(optional)*

Light read of fix-plan evolution (v1 → vN). One bullet per abandoned idea: what was it / why dropped / does rationale still hold / flag if needs revisiting for template. Default skip. Re-run trigger: Pass 4 or Pass 5 surfaces an architectural pattern not in the latest plan.

### Pass 3 — Canonical audits

Five subagents in parallel (or sequenced if context-budget-constrained). Each reads its canonical command file as methodology guide, applies it to the Pass 1 surface, writes to `audits/workflow-audit/03-<audit>.md`.

| Audit | Invocation | Notes |
|---|---|---|
| `/analyze-workflow` | subagent reads `ai-resources/.claude/commands/analyze-workflow.md` + agent files | Existing command; this is the most direct reuse. |
| `/audit-repo` | subagent reads `audit-repo.md` + skill | Scope to workflow surface, not workspace-wide. |
| `/token-audit` | subagent reads `token-audit.md` | Measures token-usage efficiency of in-scope commands + skills only. |
| `/repo-dd` | subagent reads `repo-dd.md` | Treats workflow stack as a deliverable unit being acquired by a new owner. |
| `/innovation-sweep` | subagent reads `innovation-sweep.md` + `innovation-triage-auditor.md` | **Run LAST** — consumes Pass 1 inventory + Pass 2 verdicts. |

### Pass 4 — Generalization-fitness (uses `workflow-generalization-fitness` NEW)

**Step 4a — Assumption inventory.** For every command, skill, and reference doc on the Pass 1 surface, classify each domain assumption as:
- **Generic** — no project-specific content
- **Configurable** — lives in a config-friendly slot; swap-friendly
- **Hardcoded** — embedded in prose; would require rewrite

Domain assumption categories: geographic, deal-size/scope, document-architecture, domain vocabulary, source-class, section/cluster numbering, workflow-stage names.

**Step 4b — Adjacent-project fitness check.** For 3 hypothetical adjacent projects in the calibration audience, judge:
1. Could the project run as-is? Yes / Partial / No
2. Which Hardcoded assumptions block it?
3. What's the minimum surgery needed?

**Calibration audience:** read from one of:
1. Operator CLI arg `--audience="<description>"` (highest precedence)
2. `<workflow-repo>/CLAUDE.md` § "Audience" or § "Calibration audience" if present
3. Inferred from project context (lowest precedence; flag in output that it was inferred)

For the reference execution, audience was "financial/advisory research (PE, M&A, Macro, credit, private debt) + adjacent (industry research, market intelligence, sector deep-dives)" — that level of specificity is what the skill expects.

**Output:** Section 1 inventory table, Section 2 per-hypothetical verdicts, Section 3 blocker list with fix shapes.

### Pass 5 — Template-fitness (uses `workflow-template-fitness` NEW + `workflow-evaluator`)

**Step 5a — Canonical-vs-project deltas.** Read the current canonical template at `ai-resources/workflows/<workflow-name>/`; compare against the project's deployed shape. Each delta: Project added / Project modified / Template only.

**Step 5b — Per-file classification.** For each Pass 1 file: Template-ready / Needs-parameterization / Project-only. Use Pass 4's inventory as input (Generic → Template-ready; Configurable → Needs-parameterization with existing slot; Hardcoded → Needs-parameterization with slot to create).

**Step 5c — Target template shape.** Sketch directory tree of `workflows/<name>/v2/` (or chosen versioned form). Identify what becomes per-project config; sketch the config schema.

**Output:** Section 1 deltas table, Section 2 classification table, Section 3 target shape, Section 4 migration cost estimate.

### Aggregation step — master findings file (uses `workflow-audit-aggregator` NEW *or* inline in orchestrator)

**Output structure** (`audits/workflow-audit/00-findings-summary.md`):

| Section | Contents |
|---|---|
| 1 | Blocking findings (cross-pass, deduplicated, severity-ordered). Per plan Section 3, Blocking = functional defect / generalization blocker / template blocker / Pass 2 ⚠️ drift. |
| 2 | Flagging findings (grouped by category: design debt, edge-case brittleness, config ergonomics, doc gaps, token-efficiency, backport candidates). |
| 3 | Pass coverage notes (which ran, which skipped, why). |
| 4 | Side findings surfaced during execution. |
| 5 | **Fix-phase candidate list** — structured for direct ingestion by the fix-phase planning session. Each candidate: ID, source finding, fix shape, effort estimate, `/risk-check` flag, dependency, suggested cluster. |

Section 5 is the load-bearing handoff — fix-phase planning sessions read this directly.

---

## Stop-point design

Per the operator's Q3 answer (run-through with named stop points), the orchestrator auto-continues by default and pauses only at:

| Stop point | When it fires | What the orchestrator does |
|---|---|---|
| Post-Pass-1 | Always | Emit between-gate summary. Auto-continue unless inventory surfaces a structural surprise that changes Pass 2's verification surface. |
| Pass 2 → Pass 2.5 decision | After Pass 2 | Decide go/skip on Pass 2.5 based on session budget. Default skip. Log decision in Pass 2 output. |
| Post-Pass-2 (or Pass 2.5) | If any ⚠️ Drift verdict is severity-affecting | Surface to operator before proceeding to Pass 3. Auto-continue otherwise. |
| Post-Pass-3 | Always | Run `/drift-check`; emit between-gate summary; ask operator whether to continue with Pass 4–5 in same session or split here. **This is the documented split point per session-plan precedent.** |
| Post-Pass-5, pre-aggregation | Always | Surface cross-pass Blocking findings + Section 4 side findings to operator before writing the master summary file. |
| Blocking-finding trigger | Any time a pass surfaces a Blocking finding that materially changes a downstream pass's assumptions | Pause immediately, do not auto-continue. |
| `[COST]` guardrail | Subagent count exceeds workspace threshold (≥4 spawned this session) | Emit and continue per workspace rule. Expected to fire during Pass 3. |

`/create-skill` should consider whether to expose any of these as CLI flags (e.g., `--no-drift-check`, `--always-pause`). Reference execution had per-pass approval gates as "optional, default run-through" — preserve that posture.

---

## Config surface

The orchestrator accepts these CLI args (suggested — `/create-skill` may refine):

| Arg | Purpose | Default |
|---|---|---|
| `<workflow-path>` | Path to workflow being audited (deployed project or canonical template) | Required |
| `--audience="..."` | Calibration audience for Pass 4 | Read from workflow's CLAUDE.md; else inferred |
| `--fix-plan=path` | Override Pass 2 fix-plan auto-detection | None — auto-detect |
| `--output-dir=path` | Override default output location | `audits/workflow-audit/` under workflow repo |
| `--skip-pass=N` | Skip a named pass (1 / 2 / 2.5 / 3 / 4 / 5) | None |
| `--only-pass=N` | Run only one pass (useful for fix-phase re-validation) | None — run all |
| `--no-drift-check` | Skip the post-Pass-3 `/drift-check` invocation | drift-check fires |

---

## Output shape (the canonical 10-file set)

Under `<output-dir>/`:

```
00-findings-summary.md         (master — aggregated, structured fix-phase handoff)
01-review-surface-inventory.md (Pass 1)
02-remediation-verification.md (Pass 2 — only if triggered)
02-5-diagnostic-history.md     (Pass 2.5 — only if run)
03-analyze-workflow.md         (Pass 3a)
03-audit-repo.md               (Pass 3b)
03-token-audit.md              (Pass 3c)
03-repo-dd.md                  (Pass 3d)
03-innovation-sweep.md         (Pass 3e)
04-generalization-fitness.md   (Pass 4)
05-template-fitness.md         (Pass 5)
```

Reference execution: `projects/nordic-pe-macro-landscape-H1-2026/audits/workflow-audit/` for shape and content depth precedent (~2,700 lines across 10 files).

---

## Context

Built from a successful ad-hoc execution on 2026-05-27 in nordic-pe-macro-landscape-H1-2026. The reference run produced:

- **Pass 1** — 18 in-scope commands inventoried; 37 workflow-stack skills consumed; 10 reference docs catalogued; dependency map complete
- **Pass 2** — 19 S-XX remediations verified: 13 ✅ Applied / 0 ⚠️ Drift / 6 📋 Deferred-as-intended
- **Pass 3** — 5 canonical audits returned; ~20+ HIGH-tier findings with strong cross-pass corroboration on `produce-architecture` broken/unused, `intake-reports` model frontmatter contradiction, reference-doc invisible coupling
- **Pass 4** — Assumption inventory: 22 Generic / 10 Configurable / 40 Hardcoded; 3 hypothetical-project fitness checks done; chassis identified as template-ready, fitness problem concentrated in skill prose + 3 Stage 5 commands
- **Pass 5** — 38 Template-ready / 19 Needs-parameterization / 6 Project-only / 1 Retire; migration cost ~4.5 sessions
- **Master aggregation** — 5 Blocking findings + 16 Flagging findings + 6 side findings + 23-candidate fix-phase list across 7 clusters with dependency-aware ordering

The reference run also produced one cross-pass measurement-error correction: Pass 1 claimed "32 of 37 skills inherit live-session tier"; Pass 3a and Pass 3c independently re-measured and found all in-scope skills DO declare `model:` (Pass 1's `head -10` heuristic missed `model:` lines below multi-line descriptions). This is the kind of cross-pass error-correction the aggregator should be alert to.

**Session-shape stats** (~10 subagents total + 12 main-session turns + ~2,700 lines of output) confirm the pipeline is feasible in a single session if context budget allows, with a clean split point between Pass 3 and Pass 4 if needed. Per workspace `[COST]` guardrail: expected to fire and accepted.

---

## Open design questions for `/create-skill`

1. **Aggregator as skill vs inline orchestrator step?** The reference execution had the orchestrator (me) author the master summary file inline. A dedicated `workflow-audit-aggregator` skill would isolate the aggregation logic (and make it independently testable) but adds one more skill to maintain. `/create-skill` decision based on the master-aggregation step's logic complexity.
2. **How to detect workflow stage shape?** Research-workflow uses stages 1-5; other workflows may use different shapes. Pass 1's section structure assumes a stage shape. Options: (a) Pass 1 emits a generic surface tree, organizational sections optional; (b) the orchestrator reads the workflow's stage-instructions.md to learn its shape first; (c) operator passes `--stages=<count>` arg.
3. **Pass 3 invocation pattern.** Reference execution spawned 5 general-purpose subagents that each read the canonical command file as methodology guide. Alternative: invoke the canonical commands as Skill calls. Trade-off: heavier main session vs. richer subagent autonomy.
4. **Pass 4 hypothetical-project generator.** Reference execution hardcoded 3 hypotheticals (industrial M&A, energy transition Macro, telecom industry research). Should the new skill generate hypotheticals from the calibration audience, or take them as operator args?
5. **What happens when the workflow being audited IS in the operator's project (deployed) vs IS in the canonical template (`ai-resources/workflows/`)?** Reference execution audited the deployed project workflow. The pipeline should handle both — but the path conventions differ. Spec should make this explicit.
6. **Composing with `workflow-system-critic`.** Pass 3a (`/analyze-workflow`) already invokes `workflow-system-critic`. Pass 5 may also benefit from invoking it with the `deep` flag. `/create-skill` should decide whether to double-invoke or de-duplicate.
7. **Pass 2 fix-plan format diversity.** The reference fix plan used S-XX IDs. Other plans may use different ID conventions (R-XX, FX-XX, F-XX, etc.). The skill should be ID-format agnostic — parse whatever the fix-plan file declares.
8. **Friction-log automation.** Should `/audit-workflow` auto-start a friction-log session? Reference execution did (via project hook). `/create-skill` decides based on the orchestrator-vs-execution distinction.

---

## Reference materials for `/create-skill`

Primary sources (must read):
- `projects/nordic-pe-macro-landscape-H1-2026/plans/workflow-audit-plan-v1.md` — the methodology plan
- `projects/nordic-pe-macro-landscape-H1-2026/audits/workflow-audit/00-findings-summary.md` — output shape evidence (the load-bearing aggregation handoff)
- `projects/nordic-pe-macro-landscape-H1-2026/audits/workflow-audit/01-review-surface-inventory.md` — Pass 1 output shape
- `projects/nordic-pe-macro-landscape-H1-2026/audits/workflow-audit/02-remediation-verification.md` — Pass 2 output shape
- `projects/nordic-pe-macro-landscape-H1-2026/audits/workflow-audit/04-generalization-fitness.md` — Pass 4 output shape
- `projects/nordic-pe-macro-landscape-H1-2026/audits/workflow-audit/05-template-fitness.md` — Pass 5 output shape
- `projects/nordic-pe-macro-landscape-H1-2026/logs/session-notes.md` — 2026-05-27 entries — session-flow precedent
- `projects/nordic-pe-macro-landscape-H1-2026/logs/session-plan.md` — 2026-05-27 — model-tier/posture precedent

Existing building blocks (read frontmatter + early sections):
- `ai-resources/skills/workflow-system-analyzer/SKILL.md`
- `ai-resources/skills/workflow-system-critic/SKILL.md`
- `ai-resources/skills/workflow-evaluator/SKILL.md`
- `ai-resources/.claude/commands/analyze-workflow.md`
- `ai-resources/.claude/agents/workflow-analysis-agent.md`
- `ai-resources/.claude/agents/workflow-critique-agent.md`

Canonical audits invoked by Pass 3 (read methodology):
- `ai-resources/.claude/commands/analyze-workflow.md`
- `ai-resources/.claude/commands/audit-repo.md`
- `ai-resources/.claude/commands/token-audit.md`
- `ai-resources/.claude/commands/repo-dd.md`
- `ai-resources/.claude/commands/innovation-sweep.md`

Sibling resources to distinguish from:
- `ai-resources/inbox/workflow-diagnosis.md` — artifact-defects → workflow-locus direction (opposite of this pipeline)
- `ai-resources/.claude/commands/audit-critical-resources.md` — single-resource 7-dimension audit (different scope)
- `ai-resources/.claude/commands/architecture-review.md` — synthesizes findings into a prioritized architecture-health report (different output)

Convention references:
- `ai-resources/skills/ai-resource-builder/references/operational-frontmatter.md` — model + effort tier heuristics
- `ai-resources/docs/repo-architecture.md` — placement conventions for new commands/skills/agents
- `ai-resources/docs/audit-discipline.md` — when a structural change needs `/risk-check`

---

## Acceptance criteria for the built resource

A future `/create-skill` session is done with this brief when:

1. `/audit-workflow` (or chosen name) is invocable as a slash command and produces the 10-file output set on a deployed workflow.
2. Pass 2 auto-detection works (verified against the reference fix-plan path or equivalent).
3. Calibration audience is read from CLI arg, then CLAUDE.md, then inferred — in that precedence.
4. All 6 stop points fire correctly (verified by dry-run or test invocation).
5. The master `00-findings-summary.md` has all 5 sections populated with Blocking/Flagging-classified findings and a structured Section 5 fix-phase candidate list.
6. The 3 net-new skills (`workflow-remediation-verifier`, `workflow-generalization-fitness`, `workflow-template-fitness`) pass `/qc-pass` on their SKILL.md against the canonical skill conventions.
7. The command's docs explicitly distinguish it from `/analyze-workflow`, `workflow-diagnosis`, `audit-critical-resources`, and `architecture-review`.
8. The reference execution at `projects/nordic-pe-macro-landscape-H1-2026/audits/workflow-audit/` is preserved as the canonical reference example.

---

## Notes for the `/create-skill` session

- This brief is a build SPEC, not the final SKILL.md/command content. Author the actual files per canonical conventions; this brief is the requirements document.
- The 3 net-new skills (`workflow-remediation-verifier`, `workflow-generalization-fitness`, `workflow-template-fitness`) may be merge-candidates with each other or with the orchestrator command — `/create-skill` decides the right boundary.
- If `/create-skill` finds that an existing skill already covers ≥80% of a planned net-new skill's purpose (e.g., `workflow-evaluator` might cover most of `workflow-template-fitness`), prefer extension over duplication.
- The reference execution used `general-purpose` subagents for everything. If `/create-skill` finds that dedicated subagent types would be cleaner (e.g., `workflow-audit-pass-1-agent`, etc.), that's fine — but a 4-new-agent footprint may be over-engineered. Lean toward generic-with-good-briefs unless the agent has reusable specialization.
- Friction-logging: this command is long-running and writes many artifacts. Apply `friction-log: true` in frontmatter following the convention used by other audit/pipeline commands.
- Risk-check: building this command itself is a `/risk-check`-class change (new command + new skills + cross-existing-resource composition). `/create-skill` should plan for a `/risk-check` gate at the end of authoring.

---

**End of brief.** Estimated `/create-skill` session count: 1–2 sessions to author all components + 1 session for `/qc-pass` + verification on a real workflow.
