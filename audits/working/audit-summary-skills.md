# Section 2: Skill Census — Summary

**Date:** 2026-05-18  
**Skills audited:** 70 (68 main library + 2 workflow copies)  
**Total lines:** 13,509 | **Total words:** 105,577 | **Estimated tokens:** 137,250

## Findings Summary

**Total findings:** 13  
**HIGH:** 7 | **MEDIUM:** 4 | **LOW:** 2

### Size Distribution
- Under 50 lines: 1 skill
- 50–150 lines: 47 skills (focused, efficient)
- 150–300 lines: 19 skills (medium, compression candidates)
- Over 300 lines: 7 skills (high token cost when loaded)

### Top 3 Findings

1. **HIGH — 7 skills exceed 300 lines** (ai-resource-builder 415, answer-spec-generator 487, ai-prose-decontamination 316, evidence-to-report-writer 334, research-plan-creator 466, workflow-evaluator 318, workflow-system-critic 302). Size justified by content complexity; no splits recommended except ai-resource-builder (3 modes, medium priority).

2. **MEDIUM — 3 skills have marginal descriptions** (workflow-consultant, prompt-creator, session-guide-generator). Descriptions are functional but lack explicit trigger conditions. Low practical impact.

3. **LOW — 2 workflow reference copies lack frontmatter** (knowledge-file-producer, report-compliance-qc in workflows/research-workflow/reference/skills/). Missing `model:` and `effort:` fields could cause invocation issues. Duplicates are intentional but should restore frontmatter or document as reference-only.

## Compliance Metrics

- **Frontmatter completeness:** 100% (main library) | 0% (workflow copies)
- **Description quality:** 95.6% trigger-rich (65 of 68 main skills)
- **Redundancy:** 0 findings (all skills have distinct purposes)
- **Dead skills:** 0 detected
- **Skill reference integrity:** Not audited (scoping note: full cross-reference check against all commands/workflows deferred to separate pass)

## Notes

Full evidence in `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/audit-working-notes-skills.md`. Main session should read the full notes only if a specific finding needs deeper review.

