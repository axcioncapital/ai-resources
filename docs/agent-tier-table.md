# Agent Tier Table

> **When to read this file:** When adding a new agent to `ai-resources/.claude/agents/`, retrofitting an existing agent's tier, or reviewing tier assignments. Not needed for every turn.

Every agent must declare `model:` explicitly in frontmatter — no implicit inherit. Tier by work type:

- **Haiku** — mechanical measurement, file census, format checks, line counts, permission-block inspection, simple pattern matching.
- **Sonnet** — structured factual work: questionnaire-driven audits, fact extraction, inventory walks, spec-following implementation, workflow-analysis.
- **Opus** — judgment work: QC, refinement, synthesis, triage, critique, architectural design, strategic evaluation.

## Agent tier assignments (ai-resources/.claude/agents/)

**Ground truth is agent frontmatter, not this table.** Reconciled 2026-07-12 (W3.2 M-A4) against the 42 live files in `ai-resources/.claude/agents/`: 5 rows added, 2 relocated, 0 tier mismatches. Rows are alphabetical.

| Agent | Current tier | Notes |
|---|---|---|
| claude-md-auditor | opus | Judgment (CLAUDE.md quality audit). Added 2026-04-27. |
| collaboration-coach | opus | Judgment (cross-session pattern analysis). Correct. |
| context-discovery | opus | Judgment (context discovery, selection, and cited context-pack assembly). Tier matches declared frontmatter and work type. Added 2026-06-03 (repo-dd F-1, projects/marketing-positioning). |
| dd-extract-agent | haiku | Mechanical extraction for repo-dd. Correct. |
| dd-log-sweep-agent | haiku | Mechanical log scan for repo-dd. Correct. |
| diagnostics-scanner | sonnet | Structured scan of diagnostic reports + backlog logs for one scope; returns normalized prioritized candidate list. Invoked by /fix-project-issues. **Row added 2026-07-12 (M-A4)** — the agent existed; the table row was missing. |
| execution-agent | sonnet | API-call dispatcher. Correct. |
| expert-check-reviewer | opus | Judgment (compares a drafted artifact against book-summary principles in a target KB vault; returns advisory divergence findings). Invoked by /expert-check. **Row added 2026-07-12 (M-A4)** — agent existed; row was missing. |
| fading-gate-scanner | haiku | Mechanical scan for fading high-confirmation gates in coaching-data.md. Delegated by /friday-checkup. Added 2026-05-27. |
| findings-extractor | haiku | Mechanical extraction of HIGH/CRITICAL findings from audit sub-reports. Added 2026-05-08. |
| fix-repo-issues-scanner | sonnet | Structured backlog scan for /fix-repo-issues; returns normalized prioritized issue list. Added 2026-05-27. |
| friday-act-16a-summarizer | sonnet | Structured extraction of /friday-act Step 16a supplementary inputs (SO Advisory, Systems Review, per-project logs). Added 2026-05-27. |
| improvement-analyst | opus | Judgment (friction-pattern analysis). Correct. |
| innovation-triage-auditor | opus | Judgment (per-item verdict for innovation triage). Added 2026-05-08. |
| lean-repo-auditor | opus | Judgment (leanness / control-drift assessment; reads pre-existing on-disk audit outputs, writes a disposition-grouped simplification plan). Invoked by /lean-repo. **Row added 2026-07-12 (M-A4)** — agent existed; row was missing. |
| log-sweep-auditor | haiku | Mechanical log inventory and classification for /log-sweep. Added 2026-05-12. |
| permission-sweep-auditor | sonnet | Structured factual scan (settings/permissions audit). Added 2026-04-27. |
| pipeline-review-auditor | opus | Judgment (per-pipeline System-Owner-grounded design review + currency-check against Anthropic doc URLs). Added 2026-05-29. Replaces critical-resource-auditor (deleted 2026-05-29 when `/pipeline-review` subsumed `/audit-critical-resources`). |
| pipeline-stage-3a | sonnet | Structured inventory scan. Correct. |
| pipeline-stage-3b | opus | Architectural design. Correct. |
| pipeline-stage-3c | opus | Analytical (implementation spec). Retrofitted from inherit. |
| pipeline-stage-4 | sonnet | Spec-following implementation. Retrofitted from inherit. |
| pipeline-stage-5 | sonnet | Verification checks. Correct. |
| project-manager | opus | Judgment (project-content adjudication grounded in active project's constitution docs; escalates to system-owner via Function A for general structure questions; redirects change-shaped structure questions to /consult). Added 2026-05-28. |
| project-state-scrub-verifier | sonnet | Structured two-pass confidentiality check (deterministic marker/keyword scan + semantic pass) over staged Strategic Context Snapshots before any vault write. Invoked by /refresh-project-state. **Row added 2026-07-12 (M-A4)** — agent existed; row was missing. |
| project-state-snapshot-agent | sonnet | Structured generation of one Strategic Context Snapshot per project, read-only toward the scanned project. Invoked by /refresh-project-state. **Row added 2026-07-12 (M-A4)** — agent existed; row was missing. |
| qc-reviewer | opus | QC judgment. Correct. |
| reconcile-reviewer | opus | Judgment (mandate-compliance scoring, resource-activation audit, genericness check, root-cause classification for `/reconcile`). Graduated to canonical 2026-07-03 from buy-side-service-plan (origin). |
| refinement-reviewer | opus | Refinement judgment. Correct. |
| repo-dd-auditor | sonnet | Questionnaire-driven factual audit. Correct. |
| risk-check-reviewer | sonnet | Risk evaluation across six dimensions (consumer inventory + calibration-guided dimension scoring). Added 2026-04-27. Retiered opus→sonnet 2026-07-05 — deliberate cost-reduction exception to the judgment→opus convention (`logs/decisions.md` 2026-07-05); Opus depth preserved as an operator-invoked `/consult` second-opinion offer on non-GO verdicts. |
| scope-architecture-agent | opus | Judgment (Stage 3 of /scope-project — document-architecture map, four-test justification, resists over-documentation). Added 2026-07-01. |
| scope-qc-evaluator | opus | Judgment (Stage 5 of /scope-project — consolidated control-pack QC, five-way verdict, three-way ledger; context-isolated). Added 2026-07-01. |
| scope-synthesis-agent | sonnet | Structured consolidation (Stage 2 of /scope-project — raw material → thematic synthesis). Added 2026-07-01. |
| session-feedback-collector | opus | Judgment (per-session feedback + safety extraction against goal-state dimensions, routing to friction-log/improvement-log). Invoked by /wrap-session Step 6.5. Added 2026-06-01. |
| session-guide-generator | sonnet | Structured generation. Retrofitted from inherit. |
| system-owner | opus | Judgment (architectural advisory and synthesis). Added 2026-05-08. |
| token-audit-auditor | opus | Judgment sections (4). Correct. |
| token-audit-auditor-mechanical | haiku | Mechanical sections (2, 5, 6). Correct. |
| triage-reviewer | opus | Prioritization judgment. Correct. |
| workflow-analysis-agent | opus | Architectural analysis. Correct. |
| workflow-critique-agent | opus | Critique judgment. Correct. |

**Relocated 2026-07-12 (M-A4):** `qc-gate` and `verification-agent` were listed above as canonical `ai-resources` agents. They are not — no such file exists in `ai-resources/.claude/agents/`. They are **research-workflow** agents and are now tracked in the workflow section below. They were *relocated, not deleted* — both are live.

## Workflow agents (`ai-resources/workflows/research-workflow/.claude/agents/`)

Owned by the research-workflow template, not by `ai-resources/.claude/agents/`. Deployed into research projects by `/deploy-workflow` (present today in `positioning-research`, `buy-side-service-plan`, `research-pe-regime-shift-advisory-gap`). Not part of the canonical 42.

| Agent | Tier | Notes |
|---|---|---|
| execution-agent | sonnet | API-call dispatcher. Same name and tier as the canonical agent above; the workflow ships its own copy. |
| improvement-analyst | opus | Friction-pattern analysis. Same name and tier as the canonical agent above; the workflow ships its own copy. |
| qc-gate | sonnet | QC reviewer for stage transitions. Section added 2026-07-12 (M-A4) — previously mis-listed as a canonical agent. |
| verification-agent | sonnet | Independent re-derivation for high-stakes outputs. Section added 2026-07-12 (M-A4) — previously mis-listed as a canonical agent. |

## Project-local agent copies (ai-development-lab)

These agents exist as regular-file copies (not symlinks) in `projects/ai-development-lab/.claude/agents/`. Project-local scope — AI idea triage pipeline only.

| Agent | Tier | Notes |
|---|---|---|
| ai-engineer | opus | Judgment (AI engineering feasibility and best-practices evaluation). Project-local to ai-development-lab. Added 2026-05-19. |

## Project-local agent copies (nordic-pe-macro-landscape-H1-2026) — ARCHIVED

> **Stale as of 2026-07-12 (M-A4).** This project no longer lives under `projects/` — it was archived to `archive/nordic-pe-macro-landscape-H1-2026/`. The agent copies still exist there, so the tiers below remain accurate as a historical record, but **nothing in this section is live**. Retained rather than deleted so the F-9 audit trail survives; delete outright if the archive is ever purged.

These agents exist as regular-file copies (not symlinks) in `archive/nordic-pe-macro-landscape-H1-2026/.claude/agents/`. They mirror the canonical ai-resources versions above. Tracked here to satisfy F-9 of the 2026-05-12 repo-dd audit.

| Agent | Tier | Notes |
|---|---|---|
| execution-agent | sonnet | Local copy of canonical. Same tier. Added 2026-05-14. |
| improvement-analyst | opus | Local copy of canonical. Same tier. Added 2026-05-14. |
| qc-gate | sonnet | Local copy of canonical. Same tier. Added 2026-05-14. |
| verification-agent | sonnet | Local copy of canonical. Same tier. Added 2026-05-14. |

## Project-local agent copies (axcion-brand-book)

These agents exist as regular-file copies (not symlinks) in `projects/axcion-brand-book/.claude/agents/`. Project-local scope — modular brand book production only.

| Agent | Tier | Notes |
|---|---|---|
| brand-strategist | opus | Judgment (PE/M&A brand strategy consultation; produces 8-field scoping notes per `references/scoping-note-rubric.md`). Project-local to axcion-brand-book. Added 2026-05-25. |

## Project-local agent copies (buy-side-service-plan)

These agents exist as regular-file copies (not symlinks) in `projects/buy-side-service-plan/.claude/agents/`. This project is the **origin** of `reconcile-reviewer`, which was graduated to canonical (main table above) on 2026-07-03. The origin regular-file copy is retained per `/graduate-resource`'s "never modify the source copy" rule; it is functionally equivalent to canonical and may be converted to a symlink in a future cleanup. All *other* projects consume the canonical copy via auto-sync.

| Agent | Tier | Notes |
|---|---|---|
| reconcile-reviewer | opus | Local copy of canonical (origin project). Same tier. Added 2026-07-03; graduated to canonical same day. |

## Project-local agent copies (strategic-os)

These agents exist as regular-file copies (not symlinks) in `projects/strategic-os/.claude/agents/`. Project-local scope — Strategic OS state retrieval, conflict detection, and OS self-review.

| Agent | Tier | Notes |
|---|---|---|
| conflict-detector-agent | sonnet | Structured factual comparison (derived state vs. source artifacts; flags contradictions). Project-local to strategic-os. Added 2026-05-27. |
| self-review-agent | opus | Judgment (periodic OS self-review; checks staleness, contradictions, unowned risks). Project-local to strategic-os. Added 2026-05-27. |
| state-retrieval-agent | sonnet | Structured cross-project read of strategic-signal files; returns snapshot for state view and decision queries. Project-local to strategic-os. Added 2026-05-27. |

## Maintenance

When adding a new agent, place it in the table. When changing an agent's tier, update the table in the same commit.
