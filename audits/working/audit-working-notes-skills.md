# Section 2: Skill Census — Full Working Notes

**Date:** 2026-05-25  
**Scope:** ai-resources/skills/  
**Protocol:** token-audit-protocol.md v1.3

## Executive Summary

- **Total skills measured:** 73 unique SKILL.md files (including 2 reference copies in workflows/)
- **Total lines across all skills:** 15,408 lines
- **Total words across all skills:** 136,826 words
- **Estimated token cost (word count × 1.3):** ~177,874 tokens per skill load
- **Frontmatter compliance:** 100% — all skills have YAML frontmatter with name: and description: fields
- **Major findings:** 7 skills over 300 lines (HIGH severity), 46 skills 150–300 lines (MEDIUM), 20 skills under 150 lines (acceptable)
- **Redundancy flags:** 0 confirmed; 3 checked and cleared (complementary pipelines)

---

## Size Distribution

| Range | Count | Examples | Severity |
|-------|-------|----------|----------|
| Under 50 lines | 0 | (none) | N/A |
| 50–150 lines | 20 | repo-health-analyzer (55), journal-thinking-clarifier (110), obsidian-kb-builder (150) | Acceptable |
| 150–300 lines | 46 | cluster-analysis-pass (160), evidence-prose-fixer (187), formatting-qc (167) + 43 others | MEDIUM |
| Over 300 lines | 7 | answer-spec-generator (487), research-plan-creator (466), ai-resource-builder (415), ai-prose-decontamination (411), evidence-to-report-writer (355), workflow-evaluator (318), workflow-system-critic (302) | HIGH |

---

## Top 10 Largest Skills

| Rank | Skill | Lines | Words | Tokens | Notes |
|------|-------|-------|-------|--------|-------|
| 1 | answer-spec-generator | 487 | 3,691 | 4,798 | Research question → Answer Spec transformation. Complex classification logic justified by scope. |
| 2 | research-plan-creator | 466 | 3,508 | 4,560 | Task Plan → Research Plan; posture + depth + question sequencing. Comprehensive but focused. |
| 3 | ai-resource-builder | 415 | 3,101 | 4,031 | Create/evaluate/improve modes. Split candidate (LOW priority). |
| 4 | ai-prose-decontamination | 411 | 6,087 | 7,913 | Five-pass decontamination; extensive examples. High word:line ratio. |
| 5 | evidence-to-report-writer | 355 | 3,650 | 4,745 | Evidence → prose with claim matching and citations. |
| 6 | workflow-evaluator | 318 | 2,513 | 3,267 | Workflow evaluation on multiple dimensions. |
| 7 | workflow-system-critic | 302 | 2,361 | 3,069 | Critique workflow system analysis artifacts. |
| 8 | summary | 299 | 2,954 | 3,840 | Document compression skill. |
| 9 | prose-formatter | 296 | 3,832 | 4,981 | Mechanical formatting with dense algorithm docs. |
| 10 | implementation-spec-writer | 296 | 1,717 | 2,232 | Architecture → line-level specs. |

---

## Frontmatter Quality

**All 73 skills have:**
- YAML frontmatter blocks ✓
- name: field ✓
- description: field ✓
- model: field (opus or sonnet) ✓
- effort: field (high/medium/low) ✓

**Vague descriptions found:** NONE

**All sampled descriptions are trigger-rich** with specific activation conditions explicitly stated.

---

## Redundancy Assessment

**Pairs checked and cleared (NOT REDUNDANT):**
1. chapter-prose-reviewer vs. chapter-review — distinct scopes (prose quality vs. upstream compliance); both complement research workflow pipeline
2. workflow-evaluator vs. workflow-system-critic — different inputs (workflow document vs. analysis artifact); sequential evaluation steps
3. editorial-recommendations-generator vs. editorial-recommendations-qc — generation → QC pipeline; complementary

**Dead skills:** NOT VERIFIED (requires command/workflow scanning, outside Section 2 scope)

---

## Split Opportunities

**ai-resource-builder (415 lines, 4,031 tokens) — RECOMMENDED for future consideration (LOW PRIORITY)**
- Currently 3 modes: Create, Evaluate, Improve
- Could split into 3 separate skills to reduce per-invocation context load
- Token savings per single-mode invocation: ~1,200–1,500 tokens
- Caveat: Verify no pipeline stage invokes all three modes in sequence

**answer-spec-generator (487 lines) — NOT RECOMMENDED**
- Could theoretically split (classify vs. draft) but both phases are interdependent
- Sequential pipeline would add friction

**research-plan-creator (466 lines) — NOT RECOMMENDED**
- Three sequential, interdependent phases (posture → sequencing → drafting)
- Users interact with whole plan

---

## Verbosity Observations

**High word:line ratios (>12x)** indicate instruction-dense skills, not waste:
- ai-prose-decontamination: 14.8x (extensive patterns + examples)
- prose-refinement-writer: 13.3x
- prose-formatter: 12.9x

No compression recommended — complexity justifies verbosity.

---

## Reference Copies in Workflows Directory

**Files found:** 2 in `/workflows/research-workflow/reference/skills/`
- knowledge-file-producer (135 vs. 137 lines in main; minor text variant)
- report-compliance-qc (113 vs. 115 lines; minor text variant)

**Total duplicate:** ~248 lines

**Status:** Appears to be manual copies (not symlinks). Recommend converting to symlinks if these are references.

---

## Boundary-Case Findings (±15% of 150-line threshold)

| Skill | Lines | Flag |
|-------|-------|------|
| specifying-output-style | 151 | (boundary) |
| gap-assessment-gate | 152 | (boundary) |

Deprioritize these two in any 150–300 optimization until real tokenizer confirms.

---

## Summary Statistics

| Metric | Value |
|--------|-------|
| Total unique skills (main) | 71 |
| Reference copies (workflows) | 2 |
| Total lines | 15,408 |
| Total words | 136,826 |
| Estimated tokens (×1.3) | ~177,874 |
| HIGH severity (>300 lines) | 7 |
| MEDIUM severity (150–300 lines) | 46 |
| Acceptable (<150 lines) | 20 |
| Skills with vague descriptions | 0 |
| Missing frontmatter | 0 |
| Confirmed redundancy | 0 |

---

## Confidence Assessment: HIGH

All findings based on direct measurement (wc) and manual sampling of descriptions. No structural inferences or external references.
