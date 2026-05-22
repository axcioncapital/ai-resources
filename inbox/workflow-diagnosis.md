# Resource Brief: workflow-diagnosis

**Requested:** 2026-05-19
**Origin:** nordic-pe-macro-landscape-H1-2026 — Operator read R1-formatted.md (Stage 5.4 output) and wanted to fix the workflow that produced its defects rather than fix R1 content. Session 2 of an ad-hoc 3-session loop (design → diagnose → implement) produced the reference diagnosis. The methodology is reusable across any pipeline output in any project; warrants a canonical skill + command surface.

## Capability

A three-phase command that converts operator review notes on a pipeline-produced artifact into a workflow-improvement spec. The output is a structured diagnosis document that a SEPARATE implementation session consumes as its spec — the command itself does not implement fixes. Three phases:

1. **Clarify (BLOCKING).** Read operator notes, identify ambiguous items, batch concrete A/B/C clarification questions via AskUserQuestion drawing options from the actual artifact text (not abstract prose). Approve scope via plan-mode.
2. **Diagnose.** Per-issue attribution table (ID / verbatim note / artifact location / issue class / severity / should-produce stage / should-catch stages / root cause hypothesis / remediation locus / confidence / extrapolates-to-siblings). Root-cause cluster pass. Three-tier prioritized remediation list (time-sensitive / pipeline integrity / quality lift — driven by extrapolation + cluster leverage, NOT severity).
3. **Standalone-spec verification + handoff.** Verify the diagnosis can be acted on by a fresh-context implementation session without redoing the attribution work. Handoff notes: risk-check awareness, bright-line scope, read-only inputs, verification gates.

Discipline rules baked in:
- "Ask clarifying questions" instruction is binding — do not rationalize past it (Phase 1 is BLOCKING for ambiguous notes)
- `Operator judgment` root cause MUST NOT appear alone — always paired with workflow gap (the diagnosis blames the workflow, not the operator)
- Severity and priority are orthogonal axes
- Reference-pattern issues (operator likes X) are positive signals — capture as target shape for remediation
- Small-scope exceptions to hard boundaries are allowed but must be bounded explicitly (what's approved / what stays excluded / bright-line classification / non-precedent)
- Run `/qc-pass` on the diagnosis before handoff
- Implementation is a SEPARATE session — fresh context is the verification test for whether the diagnosis is standalone

## Trigger Conditions

Operator has read a pipeline output (chapter, report, knowledge file, audit, compiled document, etc.) and taken notes on what's off. They could apply the notes as content fixes via `/qc-pass` + `/resolve` or manual edits, but they want to fix the workflow that produced the issues instead so the same defect doesn't recur in sibling artifacts (R2/R3 in a multi-report project; future projects more broadly).

Phrasings: "I have notes on R1, fix the workflow not the article," "diagnose what produced these defects," "I want to improve the pipeline, here are notes on the output."

## Exclusions

This skill does NOT:
- Produce content fixes to the reviewed artifact (that's `/qc-pass` + `/resolve` or manual edits)
- Implement the workflow changes (that's a SEPARATE session — fresh context, treats diagnosis as spec)
- Evaluate the workflow's own design quality (that's `workflow-evaluator`)
- Inventory workflow infrastructure for its own sake (that's `workflow-system-analyzer`)
- Critique infrastructure coherence in isolation from artifact defects (that's `workflow-system-critic`)
- Review the artifact for QC purposes (that's `chapter-review` / `chapter-prose-reviewer` / `document-integration-qc`)
- Analyze session-level friction or process issues (that's `improvement-analyst` agent)

The distinguishing feature is the bidirectional link: artifact-defect → workflow-locus (skill / command / hook / reference / methodology gap), then forward → fix spec for separate implementation.

## Context

Built from a successful ad-hoc execution on 2026-05-19. The reference run produced:
- 21 D-XX per-issue attribution entries from 20 operator notes (one note split into two distinct defects during execution — hypothesis revision is expected)
- 7 root-cause clusters (A–G)
- 9 prioritized remediations (R-01 through R-09)
- Session 3 handoff notes including 2 verification gates, risk-check bundling recommendation, bright-line scope, read-only inputs
- 5 operator-confirmed scoping decisions (D-08 / D-05 / D-13 / D-15-split / R-05)
- 2 QC passes (plan + diagnosis) with 11 substantive fixes total

The methodology worked. The failure mode it exposed: without a binding Phase 1 rule, the executor (Claude in the reference run) rationalized past "ask clarifying questions" instruction and proceeded on hypothesis. Operator caught it. Phase 1's BLOCKING discipline encodes this lesson.

Other lessons baked into the spec:
- Hypothesis revision is expected (D-15 split into D-15a + D-15b)
- Small-scope boundary exceptions need explicit bounding (R-05 inline-gloss exception)
- Mid-execution revisions create internal inconsistencies that `/qc-pass` catches cheaply (5 fixes in the diagnosis QC pass)
- The "standalone spec" test is real — the implementation session reads only the diagnosis + named workflow surfaces, not the source artifact

## Existing Skills Reviewed

Searched `ai-resources/skills/` (71 skills total). Closest neighbors:

| Skill | Gap |
|---|---|
| `workflow-evaluator` | Evaluates workflow's own design quality (architecture, doc compliance). Doesn't link artifact-defects to workflow-loci. |
| `workflow-system-analyzer` | Factual infrastructure inventory only — no judgment, no diagnosis. |
| `workflow-system-critic` | Critiques infrastructure coherence from an analysis artifact. Not driven by operator artifact-review notes. |
| `workflow-consultant` | Designs NEW workflows forward from problem descriptions. Opposite direction from this skill. |
| `chapter-review` | Reviews an artifact for findings. Doesn't attribute findings to workflow loci or propose workflow fixes. |
| `chapter-prose-reviewer` | Reviews prose quality. Same gap as `chapter-review`. |
| `document-integration-qc` | Cross-section coherence QC. Same gap. |
| `cluster-memo-refiner` | Refines memos through a six-check pass. Operates on a different artifact class. |
| `analysis-pass-memo-review` | Editorial decision surfacing on memos. Different abstraction. |
| `journal-wiki-improver` | Improves a wiki from journal entries. Different domain. |
| `repo-health-analyzer` | Repo-level health analysis. Different scope. |
| `improvement-analyst` (agent, not skill) | Session-level friction patterns. Process-level, not artifact-level. |

The requested skill is the missing link: it takes operator review notes on a produced artifact AS INPUT, attributes each note to the workflow locus that should have produced/caught it, and outputs a fix spec for the workflow.

## Reference artifacts (for the implementer)

- Reference diagnosis (the kind of output the skill should reproduce): `projects/nordic-pe-macro-landscape-H1-2026/report/diagnostics/1.1/r1-workflow-diagnosis-2026-05-19.md`
- Reference plan (the methodology codified): `~/.claude/plans/i-have-read-r1-formated-peppy-mitten.md`
- Feedback memory enforcing Phase 1's binding behavior: project-scoped memory at `/Users/patrik.lindeberg/.claude/projects/-Users-patrik-lindeberg-Claude-Code-Axcion-AI-Repo-projects-nordic-pe-macro-landscape-H1-2026/memory/feedback_clarification_instruction.md`
- Session notes context: `projects/nordic-pe-macro-landscape-H1-2026/logs/session-notes.md` entry for 2026-05-19
- Decision-journal entries: `projects/nordic-pe-macro-landscape-H1-2026/logs/decisions.md` entry for 2026-05-19 (5 scoping decisions documenting the in-flight clarification pattern)

## Naming candidates

`workflow-diagnosis` (filename used here), `diagnose-workflow`, `review-to-workflow-fix`. The "diagnose" framing is more accurate than "tune" because the command produces a diagnosis, not a tuning fix.

## Likely implementation surface

- `.claude/commands/diagnose-workflow.md` (orchestrator command, project-level — references the canonical skill)
- `ai-resources/skills/workflow-diagnosis/SKILL.md` (canonical skill — the methodology)
- Possibly an agent definition if any phase needs context-isolation (Phase 2 attribution pass on a long note list could spawn a subagent; verify when building)

## Suggested model tier

Opus for analytical phases (Phase 1 clarify, Phase 2 diagnose). Per workspace `CLAUDE.md` Model Tier rules: declare in YAML frontmatter, not in settings.json.
