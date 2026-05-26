---
name: cluster-memo-refiner
description: >
  Refines cluster analytical memos produced by cluster-analysis-pass. Runs ten
  structured checks targeting common first-pass weaknesses — shallow
  cross-question synthesis, missed escalation patterns, strength map
  inaccuracies, generic takeaways, under-developed tensions, missing
  dependency chains, unverified named-transaction claims, missing per-country
  coverage status (Sweden / Norway / Finland), absent permission-class labels
  (with per-cluster permission-table emission), and unlogged source conflicts.
  Also defines and emits the canonical claim-ID format consumed downstream by
  transaction-table-builder and the claim-permission gate. Use when initial
  cluster memos are produced and need quality refinement before editorial
  review. Triggers on requests like "refine these memos," "run refinement
  checks," "improve the cluster analysis," or when cluster-analysis-pass output
  is provided and the user requests quality refinement before editorial review.
  Takes cluster analytical memos (from cluster-analysis-pass), optionally
  compressed synthesis briefs, and optionally a transaction table (from
  transaction-table-builder) as input. Do NOT use before initial memos exist,
  for writing report prose, for gap assessment (that's gap-assessment-gate),
  for building the transaction table (transaction-table-builder), or as a
  substitute for operator editorial review.
model: opus
effort: high
---

# Cluster Memo Refiner

Run ten structured refinement checks against cluster analytical memos. Report findings per check, then produce revised memos with changes marked. This is a quality pass between initial memo generation and operator editorial review.

## Input Requirements

**Required:** Cluster analytical memos (one per cluster, from cluster-analysis-pass). Each must contain Key Findings, Evidence Strength Map, Cross-Question Tensions, Gaps That Matter, and So What sections.

**Optional (recommended):** Compressed synthesis briefs — the underlying briefs that fed the cluster analysis. Needed for Check 3 to verify grade labels against source grades.

**Optional (for Check 7):** Transaction table at `execution/transaction-table/{section}/{section}-transaction-table.md`, produced by `transaction-table-builder`. Needed for Check 7 to verify named-transaction claims against the structured table. If absent, Check 7 runs in degraded mode (transaction-row-ID references cannot be verified; only the <3-deal generalization rule applies).

**Validate before proceeding:**
- At least 1 memo provided with identifiable evidence strength indicators and findings with source tags
- If compressed briefs are absent, note that Check 3 runs at reduced confidence (memo-internal references only)
- If the transaction table is absent, note that Check 7 runs in degraded mode
- If a memo is missing a required section, flag which checks cannot run against that memo and proceed with remaining checks. Do not invent content for missing sections.
- If any Key Finding tagged `[SOURCE-GROUNDED]` cannot be traced to Claim IDs from the underlying briefs, flag as incomplete traceability. Severity: non-blocking (the refiner can still run its ten checks), but the flag must appear in the output for operator awareness.

## Claim-ID Format

This skill is the canonical **producer** of cluster-memo claim IDs. The format is consumed by `transaction-table-builder` (Claim supported field) and Bundle 2b's claim-permission gate (deferred).

**Canonical format:**

```
{section}-cluster-NN-claim-NN
```

- `{section}` — project section identifier (e.g., `1.1`).
- `cluster-NN` — zero-padded 2-digit cluster number within the section.
- `claim-NN` — zero-padded 2-digit claim number scoped within the cluster.

Example: `1.1-cluster-04-claim-12` means section 1.1, cluster 4, claim 12.

**Emission rule.** When this skill produces or refines a Key Finding, it emits a claim ID alongside the finding using the format above. If a finding maps to multiple sub-claims (e.g., a tension-resolution finding that has both a "support" claim and a "contra" claim), each sub-claim gets its own ID. IDs are stable across re-runs on the same cluster — if a claim is preserved verbatim from the input memo, its ID is preserved; if a claim is merged or relabeled (Check 1), the surviving claim retains the lowest-numbered ID from its source set and the displaced IDs are recorded in a `[merged-from: ID1, ID2]` annotation on the survivor.

**Numbering scope.** Claim numbers are scoped per cluster (not per section). Cluster 4's claims are numbered 01, 02, 03 ...; cluster 5's claims restart at 01. This makes cluster-level edits non-disruptive to other clusters' IDs.

## Refinement Checks

Run all ten checks against every memo. Report findings per check per memo before producing revisions.

### Check 1 — Cross-Question Synthesis Depth

**Target:** Findings that are single-question summaries dressed up as themes.

**Procedure:**
- For each Key Finding, count how many questions contribute to it
- Flag findings drawing from only one question
- For each flagged finding: can it merge into a broader multi-question theme, or is it genuinely question-specific?

**Actions:**
- Merge single-source findings into broader themes where evidence supports it
- Genuinely question-specific findings: relabel as question-specific and subordinate under a related theme, or retain standalone if significant enough (note reasoning)

**Output:** List of single-source findings with disposition (merged / relabeled / retained with reasoning)

### Check 2 — Escalation Patterns

**Target:** Findings that become more significant when combined across questions than they appear individually.

**Procedure:** Read findings across all questions as a set. Look for combinations where:
- Two findings from different questions imply a third conclusion neither surfaces alone
- A pattern in one question explains an anomaly in another
- Cumulative weight of related findings exceeds the significance of any individual finding

**Actions:**
- Add escalation patterns as new findings tagged [ANALYTICAL]
- Note contributing questions for each
- Place at appropriate rank in Key Findings (cross-question convergence often ranks high)

**Output:** Escalation patterns identified, with contributing questions and proposed placement

### Check 3 — Evidence Strength Map Accuracy

**Target:** Labels silently upgraded beyond what evidence supports.

**Procedure:**
- "Establishes" — verify High-grade evidence with multiple independent sources (check briefs if available, else memo-internal references)
- "Suggests" — verify Medium-grade or mixed-grade evidence
- "Preliminary signal" — verify Low-grade or single-source evidence

**Actions:**
- Downgrade labels where evidence doesn't support the current level
- Do not upgrade labels — flag for user attention if evidence seems stronger than label
- Note labels where compressed briefs would be needed to verify confidently

**Output:** Labels checked with pass/fail, downgrades applied, uncertain labels flagged

### Check 4 — "So What" Specificity

**Target:** Generic takeaways that don't drive editorial decisions.

**Procedure:** Test each So What recommendation against:
- Fail: "This topic is important" / "Consider X" / "X is a key factor"
- Pass: "Recommend foregrounding X because the evidence establishes Y, while downweighting Z which only reaches Suggests-level"

**Actions:**
- Rewrite generic takeaways using pattern: "Recommend [action] because [evidence reason]"
- If evidence doesn't support a specific recommendation, state that explicitly rather than forcing a vague one

**Output:** Before/after for each rewritten recommendation

### Check 5 — Tension Development

**Target:** Under-developed or missing tensions.

**Procedure — three sub-checks:**
1. **Completeness:** For each existing tension — is the stronger position named? Evidence support cited? Handling recommendation concrete (resolve in favor of / present both / flag as open)?
2. **Concreteness:** Are handling recommendations actionable? "Present both sides" is acceptable; "consider further" is not.
3. **Missing tensions:** Tensions visible across questions that the initial pass missed — particularly questions framing the same concept differently, reaching different conclusions about the same dimension, or where scope boundaries create artificial agreement.

**Actions:**
- Strengthen existing tensions with missing evidence support or handling recommendations
- Add newly identified tensions with full treatment (conflicting positions, evidence assessment, handling recommendation)

**Output:** Per existing tension: pass/fail on completeness and concreteness. New tensions listed with full treatment.

### Check 6 — Dependency Chains

**Target:** Findings where one only makes sense in light of another, implying narrative ordering constraints.

**Procedure:** Scan findings across the cluster for logical dependencies:
- Finding A assumes context from finding B
- Finding C only becomes meaningful after finding D is established
- Dependencies can be within-cluster (ordering within a section) or between-cluster (ordering between sections)

**Actions:**
- List dependency pairs with direction (A depends on B)
- Classify each as within-cluster or between-cluster
- Between-cluster dependencies: flag for downstream use, do not resolve

**Output:** Dependency pairs with classification

### Check 7 — Named-Transaction Verification

**Target:** Claims involving named transactions that (a) do not reference a transaction-table row ID, or (b) generalize from fewer than 3 same-pattern deals without an explicit `illustrative` label.

**Procedure — two sub-checks:**

1. **Transaction-row-ID reference rule.** For each finding that names one or more specific transactions (e.g., "Adelis's add-on of Nordic Components AB," "the Visby Software take-private"), check that the finding references the transaction-table row by row ID (one row ID per named transaction). The row ID is the Target+Buyer+Date triple as it appears in the table (or a `row:N` index if the project uses indexed rows). If the table is absent, this sub-check skips; flag in the output.

2. **Same-pattern threshold (operator verbatim from v4 § S-05 step 4):**

   | Cluster size | Permitted conclusion |
   |---|---|
   | Fewer than 3 same-pattern transactions | **Illustrative only** — cannot support a market-pattern claim |
   | 3–5 same-pattern transactions | **Directional** — can support a directional pattern claim with caveat |
   | 5+ same-pattern transactions across at least 2 countries | **Pattern candidate** — can support a pattern claim |

   For each finding that generalizes a pattern from named transactions, count how many same-pattern transactions support it. If the count is below 3 and the finding does not carry an explicit `illustrative` label, flag the finding.

**Actions:**

- Findings missing transaction-row references: append the row IDs in a `[supported-by: row-ID-1, row-ID-2]` annotation. If the same finding cites transactions that are NOT in the table, flag as missing-from-table (operator can decide to add a row via re-running `transaction-table-builder` or to soften the finding).
- Findings generalizing from <3 same-pattern transactions without `illustrative` label: either relabel as `illustrative` (preserves the finding without the load-bearing claim) or escalate to operator (the operator may know of additional supporting transactions not in the extracts). Do not silently downgrade without operator visibility.
- Findings generalizing from 3–5 same-pattern transactions: add the `directional` caveat verbatim if not already present.
- Findings generalizing from 5+ same-pattern across 2+ countries: confirm pattern claim is permitted; no action needed unless other checks flag.

**Output:** Per finding with named-transaction content: transaction-row reference status (referenced / missing / not-in-table), same-pattern count, threshold verdict (illustrative / directional / pattern candidate), action taken (annotated / relabeled / escalated / unchanged).

**Degraded mode (transaction table absent):** Only sub-check 2 runs (the same-pattern threshold) — sub-check 1 emits a one-line `transaction-table absent — row-ID verification skipped` note in the output and proceeds.

### Check 8 — Country-Parity

**Target:** Country-relevant findings (sector heat, sponsor behavior, deal flow, financing conditions, etc.) presented as three-country claims when evidence does not equally support all three target countries, or lacking per-country coverage status entries entirely.

**Procedure — three sub-checks:**

1. **Per-country status entry presence.** For each Key Finding making a country-relevant claim, check the Evidence Strength Map for per-country coverage status entries using the vocabulary defined in `reference/quality-standards.md § Country Coverage Table`:
   - `observed` — direct evidence for this country
   - `proxied` — only pan-Nordic or adjacent-country proxy available
   - `not evidenced` — no evidence at any source class

2. **Per-country gate rule.** A claim's permitted scope is bounded by its weakest-country status:
   - All three at `observed` or `proxied` → may be stated as three-country (with proxy caveat where applicable)
   - One country at `not evidenced` → must reframe as two-country or country-specific (with caveat for the missing country)
   - Two or more countries at `not evidenced` → ILLUSTRATIVE-ONLY at best (routed to Check 9)

3. **Pan-Nordic leakage check.** Findings sourced primarily from pan-Nordic aggregate data (KPMG, EY, PwC) presented as three-country claims must be flagged unless the aggregate explicitly disaggregates by country, OR the per-country status entries demonstrate equal coverage. Pan-Nordic figures imply equal confidence across all three markets when Norway is structurally thinner (per `reference/known-limits.md` limit #2).

**Actions:**
- Findings missing per-country status entries: add status entries to the Evidence Strength Map where derivable from the extracts; flag remaining unfillable entries for operator attention.
- Findings failing the gate rule: propose reframe options (country-specific / two-country / downgrade) and route to Check 9 for permission-class determination.
- Pan-Nordic-leakage findings: append a `[PAN-NORDIC-LEAKAGE]` annotation; route to Check 9 for downgrade evaluation.

**Output:** Per country-relevant finding: Sweden status / Norway status / Finland status, gate-rule verdict (three-country permitted / reframe required / downgrade required), pan-Nordic-leakage flag (yes/no), action taken.

### Check 9 — Permission-Class Emission

**Target:** Surviving findings without a permission-class label; per-cluster permission table not emitted.

**Procedure — three sub-checks:**

1. **Permission-class assignment.** For each surviving Key Finding (post Checks 1–8), assign one of four classes per `reference/quality-standards.md § Claim-Permission Classes`:
   - `SUPPORTED` — direct evidence, ≥2 source channels, in-lens or directly-applicable proxy with no downgrade
   - `PROXY-SUPPORTED` — proxy evidence with downgrade (above-lens or pan-Nordic for country-specific claim)
   - `ILLUSTRATIVE-ONLY` — <3 same-pattern transactions, OR single-source named-example, OR two-or-more-countries `not evidenced` from Check 8
   - `NOT-SUPPORTED` — no direct or proxy evidence at any source class

   Apply the minimum evidence thresholds per claim type and the Source-Diversity Matrix from `reference/quality-standards.md` (same § Claim-Permission Classes). Triangulation-packets rule: three independent KPMG quarterly reports count as ONE evidentiary role, not three.

2. **No-orphan-citation enforcement.** Each citation must answer the question "What exact sentence does this source support?" If the answer is vague or the source supports only a general topical area, remove the citation OR downgrade the dependent claim by one permission class. Record the downgrade rationale inline.

3. **Per-cluster permission table emission.** Emit a per-cluster permission table to `analysis/claim-permission/{section}/{section}-cluster-NN-permission-table.md` per the canonical file-conventions row. Columns: Claim ID, Claim text (short), Permission class, Source channels count, Source-diversity matrix verdict (per claim type), Country-parity status (from Check 8), Notes (orphan-citation downgrades, pan-Nordic-leakage flags, etc.).

**Blocking-gate semantics (per `reference/quality-standards.md § Claim-Permission Classes — Blocking-Gate`):** if >30% of a cluster's claims are NOT-SUPPORTED at this check's completion, the cluster is flagged `CLUSTER-INSUFFICIENT`. Refinement output is marked blocked for that cluster; the gate-clearance artifact emitted by Pass 3 (separate from this skill — produced upstream of `/run-analysis` / `/run-synthesis`) consumes this flag. This skill flags the cluster; it does NOT emit the gate-clearance file directly. Section-level rollup (>40% across the section → `SECTION-INSUFFICIENT`) is also a Pass 3 concern; this skill operates only at cluster scope.

**Actions:**
- Assign permission class to every surviving claim
- Apply downgrade for orphan citations (record rationale)
- Emit per-cluster permission table to canonical path
- Flag `CLUSTER-INSUFFICIENT` clusters in the refinement output

**Output:** Per cluster: claim count, permission-class distribution, NOT-SUPPORTED ratio, blocking-gate verdict (CLEARED / CLEARED-WITH-CAVEATS / CLUSTER-INSUFFICIENT), path to emitted permission table.

### Check 10 — Source-Conflict Validation

**Target:** Source conflicts noted in research extracts that lack a corresponding entry in the source-conflict log; cluster claims dependent on unresolved conflicts that have not been downgraded.

**Procedure — three sub-checks:**

1. **Extract-to-conflict-log coverage.** For each cluster, read the research extracts feeding the cluster's findings and identify any conflict entries (sources reporting different values or classifications for the same fact, per `research-extract-creator`'s no-silent-selection rule). For each conflict found in extracts, verify a corresponding entry exists in `analysis/source-conflicts/{section}/{section}-source-conflict-log.md` per the canonical file-conventions row.

2. **Resolution-status verification.** For each conflict-log entry covering this cluster's claims, verify `status:` is one of `RESOLVED-METHODOLOGY` (methodology-preference rule applied), `RESOLVED-GRANULARITY` (granularity-preference rule applied), `RESOLVED-TRIANGULATION` (Step 2 triangulation source found), or `UNRESOLVED` (downgrade fallback per `reference/quality-standards.md § Source-Conflict Resolution Procedure`).

3. **Unresolved-conflict downgrade verification.** For each conflict-log entry with `status: UNRESOLVED`, verify the affected claim was downgraded one permission class in Check 9. If not, flag the inconsistency and re-route to Check 9 for correction.

**Actions:**
- Cross-check extract conflicts against conflict-log entries; flag missing entries
- Flag clusters with missing conflict-log entries as refinement-blocked until log is updated
- Verify UNRESOLVED conflicts trigger downgrade in Check 9; re-route inconsistencies

**Blocking rule:** clusters with one or more unlogged extract conflicts cannot pass refinement until the conflict-log is updated. Refinement output is marked blocked for those clusters.

**Output:** Per cluster: extract-conflicts count, conflict-log-coverage status (all conflicts logged / missing entries listed), unresolved-conflict downgrade-verification status, refinement-blocked flag (yes/no).

## Revision Protocol

After reporting all check findings:

1. Produce revised memos incorporating all refinements
2. Mark every change with `[REFINED]` inline (e.g., "[REFINED] Merged into theme: Core Mechanics")
3. Preserve all original content not flagged by any check
4. Do not make changes beyond what the ten checks identify — no general editorial improvements, rewording for style, or additions from external knowledge

The `[REFINED]` markers serve as a diff mechanism for operator review. Remove after review is complete.

If check recommendations conflict (e.g., Check 1 wants to merge a finding but Check 6 identifies it as a dependency anchor), flag the conflict with both check numbers and reasoning. Present both options to the user rather than resolving silently.

## Completion Criteria

**Applicability note:** These criteria apply forward only. Cluster memos produced under any pre-Bundle-2b revision of `cluster-memo-refiner` (which had 7 checks and 8 completion criteria) are grandfathered and not retroactively re-refined under the 10-check / 11-criterion standard. R2 onward is the first production cycle under the new contract.

A memo passes refinement when all of the following hold:

1. **Check 1 — Synthesis:** No single-source findings remain without documented disposition (merged / relabeled / retained with reasoning)
2. **Check 2 — Escalation:** Cross-question combinations evaluated; any identified escalation patterns added and tagged [ANALYTICAL]
3. **Check 3 — Strength labels:** All evidence strength labels verified or flagged as uncertain; no unsupported upgrades remain
4. **Check 4 — So What:** Every recommendation either matches the "Recommend [action] because [evidence reason]" pattern or explicitly states insufficient evidence
5. **Check 5 — Tensions:** All existing tensions have named positions, cited evidence, and concrete handling recommendations; no "consider further" without specifics
6. **Check 6 — Dependencies:** All identified dependency pairs listed with direction and classification
7. **Check 7 — Named transactions:** All findings citing named transactions reference transaction-table row IDs (or carry a missing-from-table flag); all pattern claims either meet the 3-deal / 5-deal-across-2-countries thresholds or carry the `illustrative` or `directional` label
8. **Claim-ID emission:** Every surviving Key Finding has an emitted claim ID in the canonical format (`{section}-cluster-NN-claim-NN`); merged findings carry `[merged-from: ...]` annotations on the survivor
9. **Check 8 — Country-Parity:** All country-relevant findings have per-country status entries (Sweden / Norway / Finland) using the `observed` / `proxied` / `not evidenced` vocabulary; the gate rule has been applied to every finding (three-country permitted / reframe required / downgrade required); pan-Nordic-leakage flags set where applicable
10. **Check 9 — Permission-Class Emission:** Every surviving Key Finding carries a permission-class label (`SUPPORTED` / `PROXY-SUPPORTED` / `ILLUSTRATIVE-ONLY` / `NOT-SUPPORTED`); per-cluster permission table emitted to `analysis/claim-permission/{section}/{section}-cluster-NN-permission-table.md`; orphan-citation downgrades recorded with rationale; `CLUSTER-INSUFFICIENT` clusters flagged where >30% NOT-SUPPORTED
11. **Check 10 — Source-Conflict Validation:** All extract-level conflicts have corresponding entries in `analysis/source-conflicts/{section}/{section}-source-conflict-log.md`; all `UNRESOLVED` conflicts have triggered downgrade in Check 9; clusters with one or more unlogged extract conflicts are marked refinement-blocked

If any criterion is not met, the memo requires another refinement pass on the failing check(s) before proceeding to editorial review.

## Output Protocol

**Default mode: Refinement**

Present check findings as a structured report (per check, per memo) before producing revised memos. Structure the findings report as one section per memo, with sub-sections per check — this groups all issues for a single memo together for easier operator review.

Do not produce revised memos until the user says `RELEASE ARTIFACT`. This lets the user override specific check results before revisions are applied.

When the user says `RELEASE ARTIFACT`, write the revised memos to files rather than outputting them in chat. Use the working directory or a path the user specifies.

## Guardrails

**Evidence integrity:**
- Operate only from provided memos and briefs — do not supplement with external knowledge or training data
- Do not upgrade evidence strength labels without operator approval; downgrades are permissible when evidence doesn't support the current label
- New findings from Check 2 must be tagged [ANALYTICAL] — model-identified patterns, not source-grounded claims
- If a check result is ambiguous (e.g., borderline between Suggests and Establishes), present both interpretations and let the user decide
- If provided information is insufficient to assess confidently, say so rather than inferring

**Process integrity:**
- If provided materials don't match expected cluster memo format, flag the mismatch and ask for clarification rather than attempting to adapt the checks
- Run all ten checks against every memo; report "no issues found" for clean checks
- Report findings before producing revisions
- Mark all changes with [REFINED]; tag new findings as [ANALYTICAL]
- Preserve original content not flagged by checks
- Flag between-cluster dependencies for downstream use
- Do not make editorial decisions — this refines analytical quality, not editorial direction
