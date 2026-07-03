# Research Extract Template

```markdown
# Research Extract: [Question ID] — [Question Short Title]

## Answer Spec Reference
[Question ID, full question text, required components list]

## Coverage Verdicts
| Component | Verdict | Notes |
|-----------|---------|-------|
| [Component] | COVERED / THIN / MISSING | [Rationale] |

## Claims Inventory

### [Component Name]

**Component synthesis:** [2–3 sentences: what evidence collectively shows]

**Claim [Q#-C01]:** [Claim in extract author's words]
- **Sources:** [Source name(s) + URL(s)]
- **Source locator:** [Section heading + position in Deep Research report]
- **Strength:** H / M / L
- **Evidence date:** [YYYY-MM or YYYY-MM-DD — date of the evidence (publication/event/disclosure), not access date; if multiple sources of different ages, use the most recent load-bearing source]
- **Freshness class:** CURRENT / RECENT / BASELINE / STRUCTURAL [— add `[FRESHNESS-MISMATCH]` inline if a current-state claim is supported only by BASELINE or STRUCTURAL evidence]
- **Independence:** [Count]
- **Independence basis:** [independently-observed / same-underlying-dataset / same-press-release / unclear — for claims citing ≥2 channels; omit for single-source]
- **Notes:** [Linkage type, caveats]

[More claims...]

## Gaps and Conflicts

### Gaps
[What's missing, why, whether it matters]

### Conflicts
[Disagreements, relative support, recommended handling]

## Extraction Metadata
- **Source session:** [Session identifier provided by operator]
- **Questions in session:** [List]
- **Extraction date:** [Date]
- **Supplementary research:** No
- **Disconfirming evidence found:** [Optional — fix-spec #22. Captured from the research report's report/session-level `Disconfirming evidence found` field, verbatim-or-summarized, including the empty-with-reason form ("no disconfirming evidence found after N searches"). OMIT this line entirely if the report did not include the field. No downstream consumer reads it yet; record-only.]
- **Flags:** [Any ambiguous question mappings, unusual conditions, or caveats about this extraction — omit if none]
```
