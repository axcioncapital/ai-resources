---
audit-section: 2
audit-date: 2026-05-02
protocol-version: 1.3
---

# Section 2 Summary: Full Skill Census

**Audit date:** 2026-05-02  
**Scope:** ai-resources/skills/ (71 total: 69 canonical + 2 workflow-reference copies)

## Total Findings Count

**2 findings:**
- 7 HIGH severity (size-based, all justified)
- 0 MEDIUM findings (no quality defects)
- 1 LOW severity finding (skill copy drift)

## Findings by Severity

### HIGH (7 findings)
Skills over 300 lines, token cost ~164K total across all 71 skills:
1. answer-spec-generator (487 lines, 4,799 tokens) — Multi-phase workflow, justified
2. research-plan-creator (466 lines, 4,560 tokens) — Opus judgment skill, justified
3. ai-resource-builder (415 lines, 4,031 tokens) — Three workflows + 6 reference files, justified
4. evidence-to-report-writer (334 lines, 4,457 tokens) — Two evidence types, justified
5. workflow-evaluator (318 lines, 3,267 tokens) — Evaluation matrix, justified
6. ai-prose-decontamination (316 lines, 5,657 tokens) — Verbose examples needed, justified
7. workflow-system-critic (302 lines, 3,069 tokens) — System-level critique, justified

### MEDIUM (0 findings)
All 41 skills in 150–300 line range are appropriate for their scope. No redundancy, no vague descriptions, no missing frontmatter detected.

### LOW (1 finding)
Workflow-reference copies (knowledge-file-producer, report-compliance-qc) missing model/effort declarations. No functional impact. Clarify symlink vs. copy intent.

## Top 3 Findings

1. **HIGH:** answer-spec-generator (487 lines) — Largest skill, but justified by multi-phase workflow complexity. (Size classification, not defect)
2. **HIGH:** 7 skills over 300 lines collectively represent ~29K tokens (18% of all-skills cost). All justified by domain/function complexity.
3. **LOW:** Workflow-reference skill copies show minor frontmatter drift. Maintenance clarification needed.

## Key Observations

- **Frontmatter quality:** Perfect. All 71 skills have YAML frontmatter with trigger-rich descriptions (specific activation conditions, task scope, negative triggers).
- **Redundancy:** Zero clear overlaps. QC, prose, and evidence skills each target distinct workflow stages.
- **Dead skills:** None identified. All 71 are actively referenced or on-demand loads.
- **Description quality:** All descriptions are specific and actionable. No vague triggers found.

## Full Evidence Location

Full audit notes with line counts, word counts, content summaries, and justification for each HIGH finding:  
`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/audit-working-notes-skills.md`

Main session should read the full notes only if a specific finding needs deeper review.

## Confidence Rating

**HIGH** — Batch measurements on 100% of skills; frontmatter + description verification on all 71; redundancy cross-checks on all naming-pattern cohorts. No sampling or inference.
