# Section 2: Skill Census — Summary

**Total skills measured:** 73 (71 main + 2 reference copies)  
**Total lines:** 15,408 | **Total tokens (est.):** ~177,874  
**Frontmatter compliance:** 100% (all YAML + name + description + model + effort)

## Size Distribution

- **Over 300 lines (HIGH):** 7 skills
  - answer-spec-generator (487), research-plan-creator (466), ai-resource-builder (415)
  - ai-prose-decontamination (411), evidence-to-report-writer (355)
  - workflow-evaluator (318), workflow-system-critic (302)

- **150–300 lines (MEDIUM):** 46 skills
  - cluster-analysis-pass (160), evidence-prose-fixer (187), formatting-qc (167), etc.

- **Under 150 lines:** 20 skills (acceptable)

## Top 5 Largest

1. answer-spec-generator: 487 lines (4,798 tokens)
2. research-plan-creator: 466 lines (4,560 tokens)
3. ai-resource-builder: 415 lines (4,031 tokens)
4. ai-prose-decontamination: 411 lines (7,913 tokens, dense examples)
5. evidence-to-report-writer: 355 lines (4,745 tokens)

## Key Findings

**Description Quality:** PASS — All 73 skills have trigger-rich descriptions with explicit activation conditions. No vague descriptions detected.

**Redundancy:** 0 confirmed pairs. 3 potential pairs checked and cleared as complementary pipelines (chapter-prose-reviewer/chapter-review, workflow-evaluator/workflow-system-critic, editorial-recommendations-generator/-qc).

**Verbosity:** 4 skills with high word:line ratios (12–14x) are instruction-dense by design (patterns, examples, algorithms). No waste detected.

**Split opportunity:** ai-resource-builder (3 modes: Create/Evaluate/Improve) could split for ~1,200–1,500 token savings per single-mode invocation. LOW priority.

**Reference copies:** 2 minor-variant copies in /workflows/research-workflow/reference/skills/ (~248 lines). Recommend converting to symlinks.

**Boundary cases:** specifying-output-style (151 lines) and gap-assessment-gate (152 lines) are ±1–2 lines over 150-line threshold; flag for real tokenizer confirmation.

## Severity Summary

- HIGH (>300 lines): 7 skills — token cost justified by scope complexity
- MEDIUM (150–300 lines): 46 skills — healthy distribution; monitor for verbosity
- LOW (misc issues): reference copies, split opportunity

## Confidence: HIGH

Direct measurement (wc) and manual sampling of all descriptions. No inferences or external references.

---

Full evidence in /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/audit-working-notes-skills.md

Main session should read the full notes only if a specific finding needs deeper review.
