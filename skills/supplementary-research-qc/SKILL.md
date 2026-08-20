---
name: supplementary-research-qc
description: >
  QC gate for executor-verified supplementary research results. Filters results
  before merge into Research Extracts by running three checks per query result:
  gap closure assessment, source quality screen, and redundancy check. Produces
  per-query MERGE/SKIP/PARTIAL verdicts and a merge summary for operator review.

  Step 2.S3 in Stage 2 Subworkflow 2.S. Use after the supplementary lead
  provider has returned candidate URLs and the configured evidence executor has
  reopened and logged the underlying sources. Triggered by "QC supplementary results," "run
  step 2.S3," or similar.

  Do NOT use for QC of Deep Research reports (that's research-extract-verifier).
  Do NOT use for merging evidence (that's supplementary-evidence-merger at
  Step 2.S4). Do NOT use for drafting queries (that's supplementary-query-brief-drafter).
model: sonnet
effort: medium
---

# Supplementary Research QC

Review the evidence executor's verified supplementary report before it is merged into existing Research Extracts. Filter out results that do not add value so only opened, audited, non-redundant evidence reaches the merge step.

**Workflow position:** Step 2.S3 in Subworkflow 2.S. Receives the executor-verified report from Step 2.S2. Raw lead-provider output is not an input. MERGE/PARTIAL verdicts flow to Step 2.S4. SKIP verdicts are documented and dropped.

## Calibration

Be selective but not punitive. The purpose is to prevent bad evidence from entering extracts, not to set an impossibly high bar. A single credible Medium-strength claim that moves a component from MISSING to THIN, or from THIN closer to COVERED, has value.

## Input

Three items, provided together:

1. **Executor-verified supplementary report** — underlying sources opened in full and accompanied by the evidence executor's source-access log, organized by query number
2. **Research Extracts** — for all affected questions (needed for redundancy checking and gap context)
3. **Query Brief Section A** — for this pass (needed for success signals, component mapping, and the Already Searched inventory used in Check 3)

### Input Validation

Before proceeding:
- If fewer than three input items are provided, state which are missing and request them
- Verify query numbers in the executor-verified report match the Execution Sheet
- Verify every proposed claim has an opened-source audit entry; reject provider-only citations and snippet-only access
- If queries are missing from the output, note which are absent and proceed with available results

## QC Checks

Run three checks per query result, in order.

### Check 1 — Gap Closure Assessment

Does this result address the THIN or MISSING component it was targeting?

- Review the query's intended target (from the Query Brief's Section A: which components, which coverage gaps).
- Review the success signal defined for this query.
- Assess: would adding claims from this result change the coverage verdict? Specifically:
  - For MISSING components: does the result provide at least 1 credible claim for the component?
  - For THIN components: does the result provide additional independent sources or higher-strength evidence than what's already in the Research Extract?
- If the result is topically adjacent but doesn't address the specific component gap, it fails this check.

### Check 2 — Source Quality Screen

Is the source credible enough to merit inclusion?

- **Source type:** Primary/institutional data, academic research, established industry publications → accept. Vendor marketing, SEO content, undated blog posts, anonymous forums → reject unless the claim is corroborated elsewhere in the results.
- **Recency:** Flag sources older than 5 years unless the claim is structural/definitional (not market data or practice descriptions).
- **Attribution clarity:** Can you identify the author, institution, or publication? If the source is unattributable, reject.
- **Bias indicators:** Is the source selling something related to the claim? If yes, flag as vendor/advocacy — acceptable only as Low-strength corroboration, not as primary evidence.
- **Citation reliability:** Lead providers can hallucinate or misattribute URLs. The evidence executor must have reopened the underlying source. A missing, structurally implausible, inaccessible, or snippet-only audit entry fails this check; provider citation text alone never qualifies.

### Check 3 — Redundancy Check

Is this genuinely new evidence?

- Compare the result's key claims against the existing claims in the Research Extract for the targeted component.
- **Also compare against the Query Brief's Already Searched inventory** (in Section A, if present). A result that returns a source type listed as "searched but returned nothing useful" is not automatically redundant — but if the result returns the *same* source previously searched and still provides nothing beyond what was already known, flag it as a wasted retrieval.
- Redundant if: same factual assertion, same primary data source (even if accessed via a different URL or secondary publication), same finding restated with different wording, **or same source type that was already searched and returned nothing useful — unless the result provides materially different content from that source type than what prior searches returned.**
- Not redundant if: same topic but different data, different time period, different geography, different methodological approach, or an independent source arriving at the same conclusion (this adds independence, which has value).

### Check 4 — Scarcity-Verdict Independence Check (sampled, end-of-pass)

Runs once per QC pass — after the per-query verdicts, not per query — and only when this pass produces **confirmed scarcity** outcomes (components that exhausted their attempt allowance and are headed for the scarcity register). If no component reaches confirmed scarcity in this pass, skip this check silently.

Why it exists: the supplementary flow otherwise self-certifies "scarcity" — the same agent judges both the original gap and whether its own second attempt was a genuinely different angle. A too-quick scarcity verdict closes the search and lets existing proxies stand as the de-facto answer. This check puts an independent eye on the scarcity call. Sampled, cheap, high-signal.

- **Sample 1–2 confirmed-scarcity components** from this pass (prioritize load-bearing components — those feeding claims a chapter depends on).
- **Fresh-context re-attempt:** for each sampled component, a fresh context (a subagent given only the original component topic and the project lens — NOT the prior query brief, its wording, or its exclusion lists) drafts one search attempt from scratch. The attempt executes through the standard Step 2.S2 lead-provider → evidence-executor verification path.
- **If the fresh attempt finds credible in-lens evidence:** the scarcity verdict was an under-search, not a ceiling. Route the component **back to re-extraction** — it re-enters the supplementary flow with the new evidence; do NOT record it in the scarcity register this pass.
- **If the fresh attempt finds nothing:** the scarcity verdict stands, now independently confirmed. Note the confirmation in the QC report.

## Verdict Logic

**MERGE** — Passes all three checks. Adds genuine new evidence to a targeted component.

**SKIP** — Fails any check decisively:
- Check 1 fail: doesn't address the targeted gap
- Check 2 fail: source not credible enough for inclusion
- Check 3 fail: fully redundant with existing evidence

**PARTIAL** — Some claims pass, others don't. Specify which claims to merge and which to skip.

## Output Format

### Per-Query Verdicts

| Query | Verdict | Rationale |
|-------|---------|-----------|
| [Query # from Execution Sheet] | MERGE / SKIP / PARTIAL | [1–2 sentences: what the result adds or why it doesn't] |

### Scarcity Independence Check (when Check 4 ran)

```
SCARCITY INDEPENDENCE CHECK:
- Component [ID]: sampled. Fresh attempt: [found in-lens evidence → routed back to re-extraction | found nothing → scarcity independently confirmed]
- Components not sampled: [IDs] — scarcity recorded as self-certified (sampling budget 1–2 per pass)
```

### Merge Summary

```
MERGE:
- Query [#]: [1-line summary of what it adds, which component it targets]
- Query [#]: ...

SKIP:
- Query [#]: [1-line reason]
- Query [#]: ...

PARTIAL:
- Query [#]: Merge [specific claims]. Skip [specific claims]. Reason: [1-line]
```

## Output Protocol

Write the QC report to `/execution/supplementary/{section}-supplementary-qc-pass-[1/2].md`. Provide a brief summary in chat: MERGE/SKIP/PARTIAL counts and the merge summary for operator review.

## Scope Boundaries

- Do not merge evidence into extracts — verdicts only (merging is Step 2.S4)
- Do not supplement evidence from training data
- Do not re-run or modify queries — assessment only (exception: Check 4's sampled independence re-attempt, which drafts its one fresh query in a fresh context — never by editing the original brief's queries)
- Do not override operator decisions on which components warrant supplementary research
