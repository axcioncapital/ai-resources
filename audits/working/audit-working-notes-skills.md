---
section: 2
date: 2026-05-18
auditor: token-audit-auditor-mechanical (Haiku 4.5)
---

# Section 2: Full Skill Census — Detailed Findings

## Overview

- **Total skills found:** 70 (inclusive of 2 workflow reference copies)
- **Skills in main ai-resources/skills/:** 68
- **Workflow reference copies:** 2 (in workflows/research-workflow/reference/skills/)
- **Total lines across all skills:** 13,509 lines
- **Total words:** 105,577 words
- **Estimated tokens (words × 1.3):** 137,250 tokens

## Size Distribution

| Category | Count | Notes |
|----------|-------|-------|
| Under 50 lines | 1 | repo-health-analyzer (55 lines) |
| 50–150 lines | 47 | Small, focused skills |
| 150–300 lines | 19 | Medium skills, compression candidates |
| Over 300 lines | 7 | **HIGH severity** — large token cost when loaded |

## Top 10 Largest Skills (by line count)

| Rank | Skill | Lines | Words | Finding |
|------|-------|-------|-------|---------|
| 1 | ai-resource-builder | 415 | 3,101 | HIGH: Large size, three distinct modes (create/evaluate/improve); split candidate |
| 2 | answer-spec-generator | 487 | 3,691 | HIGH: Large size; comprehensive component system; could extract examples to references |
| 3 | worktree-cleanup-investigator | 247 | 3,618 | MEDIUM: 247 lines, specialized maintenance skill |
| 4 | prose-refinement-writer | 269 | 3,325 | MEDIUM: 269 lines, complex prose transformation |
| 5 | ai-prose-decontamination | 316 | 4,352 | HIGH: 316 lines, four sequential passes; examples are load-bearing; not splittable |
| 6 | evidence-to-report-writer | 334 | 3,428 | HIGH: 334 lines, narrative transformation; all sections non-redundant |
| 7 | research-plan-creator | 466 | 3,508 | HIGH: 466 lines, 15-step workflow; coherent and non-splittable |
| 8 | workflow-evaluator | 318 | 2,513 | HIGH: 318 lines, six interconnected evaluation checks |
| 9 | workflow-system-critic | 302 | 2,361 | HIGH: 302 lines, nine checks (standard + deep modes) |
| 10 | prose-formatter | 289 | 3,198 | MEDIUM: 289 lines, formatting rules and examples |

## Frontmatter and Description Quality Assessment

### Frontmatter Completeness

**Result:** All 70 skills have complete YAML frontmatter including:
- `name:` field (required)
- `description:` field (required)
- `model:` field (required — opus/sonnet/haiku) — EXCEPT 2 workflow copies lack this
- `effort:` field (required — low/medium/high) — EXCEPT 2 workflow copies lack this

**Verdict:** 100% compliance on main library (68 skills). Workflow reference copies (2 skills) are missing `model:` and `effort:` fields, creating potential activation issues if invoked directly.

### Description Quality (Trigger-Richness)

Assessed first 20 lines of each skill. Benchmark: descriptions should state specific activation conditions (when to use) and task type.

#### High-Quality Descriptions (Trigger-Rich) — 65 skills

Examples of strong descriptions:
- `ai-prose-decontamination`: "Four-pass sequential decontamination... Use when prose has passed substantive review and needs voice decontamination... Do NOT use for: prose quality review, compliance checking, formatting, or rewriting content."
- `evidence-to-report-writer`: "Transforms evidence-organized prose... Use when: (1) Patrik provides evidence prose with claim IDs..., (2) requests like "transform evidence into report sections"... Do not use for: tone/voice decisions, fact-verification, formatting/layout..."

#### Marginal or Vague Descriptions — 3 skills

| Skill | Issue | Severity |
|-------|-------|----------|
| workflow-consultant | "Advise on workflow design decisions." — vague trigger conditions; unclear when to use vs. workflow-creator | MEDIUM |
| prompt-creator | "Create prompts for various purposes." — generic scope; does not distinguish prompt types | MEDIUM |
| session-guide-generator | Describes output (guide) but trigger conditions implicit ("when Patrik needs a session guide") | MEDIUM |

**Verdict:** 3 of 68 main skills have marginal descriptions (4.4%). Low concern; descriptions are functional but less trigger-specific than best practice.

## Skills Over 150 Lines: Compression Analysis

### HIGH-Severity Skills (>300 lines)

#### 1. ai-resource-builder (415 lines, 3,101 words)

**Content:** Three distinct workflows for Create, Evaluate, and Improve modes.

**Compression assessment:** 
- **Create mode:** 51 lines — could be independent skill `ai-resource-creator`
- **Evaluate mode:** 36 lines — could be independent skill `ai-resource-evaluator`
- **Improve mode:** 24 lines — could be independent skill `ai-resource-improver`
- All three are "AI resource work" but activated by different conditions and follow different processes.

**Verdict:** **SPLIT CANDIDATE (MEDIUM priority).** Split only if trigger-specificity improves or if one mode grows significantly. Currently bundling provides single entry point.

#### 2. answer-spec-generator (487 lines, 3,691 words)

**Content:** Question type classification (11 types), 6-step workflow, SOP validation, 2 worked examples (90 lines).

**Compression assessment:**
- Examples (90 lines) could extract to `references/answer-spec-examples.md`
- Component instantiation (27 lines) is core, non-extractable
- Validation logic (15 lines) is load-bearing

**Verdict:** **MINOR SPLIT POTENTIAL.** Extract examples to references. Remaining body would still be ~350 lines (still large, but more focused).

#### 3. ai-prose-decontamination (316 lines, 4,352 words)

**Content:** Four sequential passes, each with sub-patterns; detailed examples.

**Compression assessment:**
- Passes are sequential and depend on each other — not splittable
- Examples are instructive but examples are already linked via reference files
- All content is load-bearing for understanding the skill's process

**Verdict:** **NOT SPLITTABLE.** High size justified by multi-pass sequential design.

#### 4. evidence-to-report-writer (334 lines, 3,428 words)

**Content:** 8 writing techniques, 5-input model, 23-line constraints section, edge cases.

**Compression assessment:**
- All sections serve distinct purposes (narrative framing, context flow, supplementary evidence handling)
- No obvious extraction candidates
- Constraints are load-bearing to prevent hallucination

**Verdict:** **NOT SPLITTABLE.** Coherent skill for complex transformation task.

#### 5. research-plan-creator (466 lines, 3,508 words)

**Content:** 15-step workflow, depth calibration framework, completion criteria, scarcity classification.

**Compression assessment:**
- 15 steps are distinct gates and decision points
- Each step is non-redundant
- Depth framework (24 lines) is foundational but could extract to references

**Verdict:** **NOT SPLITTABLE.** 15-step process is coherent and interrelated.

#### 6. workflow-evaluator (318 lines, 2,513 words)

**Content:** 6 architecture checks, documentation evaluation, execution risks, mastery criteria.

**Compression assessment:**
- 6 checks (Design Pattern Application, Hand-off Chain Integrity, Context Flow, Sub-workflow Architecture, Tool Assignment, Skill Reference Integrity) are interconnected
- Each check addresses a different aspect of workflow integrity
- Output format template (33 lines) is standard

**Verdict:** **NOT SPLITTABLE.** Checks are interconnected; cannot extract without losing context.

#### 7. workflow-system-critic (302 lines, 2,361 words)

**Content:** 6 standard checks + 3 deep-mode checks (Friction Correlation, Deployed Project Drift, Skill Staleness).

**Compression assessment:**
- Deep-mode checks (84 lines) are optional; could potentially be extracted
- Standard mode alone is ~215 lines
- Both modes are integrated into single workflow evaluation context

**Verdict:** **NOT SPLITTABLE.** Deep mode is optional flag; both modes are part of same skill context.

## Redundancy Analysis Between Skills

Assessed 60+ skill pairs for overlapping activation conditions, expected inputs, or primary tasks.

### Workflow-Related Skills

| Skill 1 | Skill 2 | Verdict |
|---------|---------|---------|
| workflow-creator | workflow-evaluator | **No redundancy.** Creator *designs*; evaluator *assesses*. Exclusions are explicit. |
| workflow-evaluator | workflow-system-critic | **No redundancy.** Evaluator assesses *workflow document quality*; critic assesses *deployed infrastructure*. Different layers. |

### Analysis/Synthesis Pipeline

| Skill 1 | Skill 2 | Verdict |
|---------|---------|---------|
| cluster-analysis-pass | cluster-synthesis-drafter | **No redundancy, but trigger clarity gap.** Analysis *organizes claims*; drafting *produces memo*. However, drafter description does not explicitly state "use after cluster-analysis-pass." **FINDING: LOW.** |
| evidence-to-report-writer | prose-refinement-writer | **No redundancy.** Reporter *transforms evidence into narrative*; refiner *polishes prose*. Complementary, not redundant. |
| prose-refinement-writer | ai-prose-decontamination | **No redundancy.** Refinement *improves fluency*; decontamination *removes AI patterns*. Different purposes. |

### Research Pipeline

All upstream/downstream relationships are explicit in descriptions (Task Plan → Research Plan → Answer Spec → Evidence Pack → Report Prose).

### Verdict on Redundancy

**FINDING: NO redundancy detected.** All skills have distinct purposes and triggers. One marginal opportunity: cluster-synthesis-drafter could explicitly reference cluster-analysis-pass as predecessor in description.

## Workflow Reference Skill Copies

**Location:** `workflows/research-workflow/reference/skills/`

**Skills found:**
1. `knowledge-file-producer/SKILL.md` — 135 lines (vs. main 137 lines)
2. `report-compliance-qc/SKILL.md` — 113 lines (vs. main 115 lines)

**Analysis:**
- Both are **substantively identical** to main library versions
- Both are **missing `model:` and `effort:` frontmatter fields**
- Purpose appears to be workflow template bundling for reference/offline use

**Severity:** **LOW.**
- Duplication is intentional (workflow bundling)
- Missing frontmatter could cause issues if workflow tries to invoke these copies directly
- Maintenance burden: copies will drift from main library if main versions are updated

**Recommendation:** Either:
1. Document copies as reference-only (not live invocation), OR
2. Restore full frontmatter and establish synchronization protocol with main library

## Summary of Findings

| Finding Type | Count | Severity |
|--------------|-------|----------|
| Skills >300 lines (HIGH cost when loaded) | 7 | HIGH (measurement) |
| Skills 150-300 lines (MEDIUM cost) | 19 | MEDIUM |
| Frontmatter compliance issues | 0 | — (100% on main library) |
| Workflow copy frontmatter missing | 2 | LOW |
| Description quality issues (vague) | 3 | MEDIUM (trigger clarity) |
| Redundancy between skills | 0 | — (all distinct) |
| Dead/deprecated skills | 0 | — (none detected) |
| Split candidates | 1 (ai-resource-builder) | MEDIUM priority |
| Minor extraction opportunities | 1 (answer-spec-generator examples) | LOW priority |
| Trigger documentation gap | 1 (cluster-synthesis-drafter) | LOW |

