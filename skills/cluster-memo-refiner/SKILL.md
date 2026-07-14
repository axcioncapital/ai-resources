---
name: cluster-memo-refiner
description: >
  Refines cluster analytical memos produced by cluster-analysis-pass. Runs ten
  checks for common first-pass weaknesses — synthesis depth, escalation
  patterns, strength-map accuracy, takeaways, tensions, dependencies,
  named-transaction verification, per-country coverage, permission-class
  emission (with per-cluster permission tables), and source-conflict validation.
  Also emits the canonical claim-ID format consumed by transaction-table-builder
  and the claim-permission gate. Use when initial cluster memos need quality
  refinement before editorial review. Triggers on requests like "refine these
  memos," "run refinement checks," "improve the cluster analysis," or when
  cluster-analysis-pass output is provided for quality refinement. Inputs are
  enumerated in Input Requirements. Do NOT use before initial memos exist, for
  writing report prose, for gap assessment (that is gap-assessment-gate), for
  building the transaction table (transaction-table-builder), or as a substitute
  for operator editorial review.
model: opus
effort: high
---

# Cluster Memo Refiner

Run ten structured refinement checks against cluster analytical memos. Report findings per check, then produce revised memos with changes marked. This is a quality pass between initial memo generation and operator editorial review.

## Input Requirements

**Required:** Cluster analytical memos (one per cluster, from cluster-analysis-pass). Each must contain Key Findings, Evidence Strength Map, Cross-Question Tensions, Gaps That Matter, and So What sections.

**Optional (recommended):** Compressed synthesis briefs — the underlying briefs that fed the cluster analysis. Needed for Check 3 to verify grade labels against source grades.

**Optional (recommended, for the Check 9 risk-tier ceiling):** The research plan (from `research-plan-creator`), which carries a per-question `risk-tier:` field (`A` / `B` / `C` / `D`). Check 9 reads it to cap each finding's permission class by tier per `reference/quality-standards.md § Risk-Tier Model`. **Presence-gated:** if the plan is absent, carries no `risk-tier:` fields, or the project's `quality-standards.md` has no `§ Risk-Tier Model` section, every finding binds at **Tier B** (ceiling SUPPORTED — no constraint), i.e. current uniform behaviour. Tiering is opt-in enrichment, never a breaking change.

**Optional (for Check 7):** Transaction table at `execution/transaction-table/{section}/{section}-transaction-table.md`, produced by `transaction-table-builder`. Needed for Check 7 to verify named-transaction claims against the structured table. If absent, Check 7 runs in degraded mode (transaction-row-ID references cannot be verified; only the <3-deal generalization rule applies).

**Optional (recommended, for Checks 8 and 10):** The research extracts feeding the cluster's findings (from `research-extract-creator`; emitted to the project working directory as `research-extract-[session].md`, so located by content, not a fixed canonical path). Check 8 fills per-country status entries from them; Check 10 sub-check 1 reads them to find source conflicts. **Presence-gated** (mirrors the research-plan gate above — opt-in enrichment, never a breaking change): if the extracts feeding a cluster cannot be located, Check 8 fills only the per-country entries derivable from the memo itself and flags the rest for operator attention (it does not invent entries), and Check 10 sub-check 1 is skipped with a one-line `extracts not located — extract-to-conflict-log coverage not verified` note. The remaining Check 10 sub-checks (2–3) still run against the conflict log if present. *Forward note:* once the F3 declared-check-count contract lands, this input may be upgraded from Optional to conditional-Required (required only when Checks 8/10 actually run in the deployment); until then it stays Optional so the six-check deployment (Checks 8–10 deferred to `/run-sufficiency`) is unaffected.

**Optional (for Check 10 sub-checks 2–3):** The source-conflict log at `analysis/source-conflicts/{section}/{section}-source-conflict-log.md`, produced by `research-extract-creator` (same canonical path it emits to). Check 10 reads each entry's `status:` to verify resolution and downgrade consistency. **Absent-file branch:** if the log is absent *and* the extracts (above) surface no conflicts for the cluster, sub-checks 2–3 pass trivially (nothing to verify). If the log is absent *but* the extracts surface one or more conflicts, that absence is itself the blocking condition — the cluster is marked refinement-blocked until the log is created (per Check 10's blocking rule). If the extracts are also unavailable, sub-checks 2–3 run against whatever conflict-log entries exist and note that extract-side coverage could not be cross-checked.

**Validate before proceeding:**
- At least 1 memo provided with identifiable evidence strength indicators and findings with source tags
- If compressed briefs are absent, note that Check 3 runs at reduced confidence (memo-internal references only)
- If the research plan is absent or carries no `risk-tier:` fields, note that the Check 9 risk-tier ceiling is inactive (every finding binds at Tier B → no ceiling constraint) and proceed
- If the transaction table is absent, note that Check 7 runs in degraded mode
- If the research extracts cannot be located, note that Check 8 fills only memo-derivable per-country entries and Check 10 sub-check 1 is skipped (per the presence-gate above)
- If the source-conflict log is absent, apply the absent-file branch above (trivial pass when no extract conflicts exist; refinement-blocked when conflicts exist but are unlogged)
- If a memo is missing a required section, flag which checks cannot run against that memo and proceed with remaining checks. Do not invent content for missing sections.
- If any Key Finding tagged `[SOURCE-GROUNDED]` cannot be traced to Claim IDs from the underlying briefs, flag as incomplete traceability. Severity: non-blocking (the refiner can still run its ten checks), but the flag must appear in the output for operator awareness.

### Required Reference Sections (`reference/quality-standards.md`)

This skill's checks depend on specific sections of the project's `quality-standards.md`. The dependencies split into two classes:

- **Hard dependencies — halt-or-flag if absent.** No fallback exists; the check cannot substitute memo-internal judgment for the missing vocabulary or classification rule.
  - `§ Country Coverage Table` (Check 8) — defines the `observed` / `proxied` / `not evidenced` vocabulary. If absent, flag the section as missing and halt Check 8 (other checks proceed unaffected).
  - `§ Claim-Permission Classes`, including its `— Blocking-Gate` subsection (Check 9) — defines the four permission-class names, verb lists, minimum-evidence thresholds, Source-Diversity Matrix, and the >30% / >40% blocking-gate thresholds. If absent, flag the section as missing and halt Check 9.
  - `§ Source-Conflict Resolution Procedure` (Check 10) — defines the `RESOLVED-METHODOLOGY` / `RESOLVED-GRANULARITY` / `RESOLVED-TRIANGULATION` / `UNRESOLVED` statuses and the downgrade fallback. If absent, flag the section as missing and halt Check 10.
- **Presence-gated — degrade gracefully if absent.** `§ Risk-Tier Model` (Check 9's risk-tier ceiling, sub-check 1) is optional: per the presence-gate described above and in Check 9, if this section is absent (or the research plan is absent, or carries no `risk-tier:` fields), every finding simply binds at Tier B (ceiling `SUPPORTED` — no constraint). This is the only reference-doc dependency in this skill that degrades instead of halting.

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

1. **Transaction-row-ID reference rule.** For each finding that names one or more specific transactions (e.g., "Nordvik Partners's add-on of Nordic Components AB," "the Brunnsvik Software take-private" — fictional names; never paste a real sponsor or target into a shared skill), check that the finding references the transaction-table row by row ID (one row ID per named transaction). The row ID is the Target+Buyer+Date triple as it appears in the table (or a `row:N` index if the project uses indexed rows). If the table is absent, this sub-check skips; flag in the output.

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

**Degraded mode (research extracts not located):** the per-country status fill is limited to entries derivable from the memo itself; unfillable entries are flagged for operator attention rather than invented (per the extracts presence-gate in Input Requirements).

### Check 9 — Permission-Class Emission

> **Permission-class contract (load-bearing).** The class names, conditions, adjudication order, and ceilings applied in this check are owned by `reference/quality-standards.md § Claim-Permission Classes`. Two other files carry working copies: this check, and `claim-permission-gate` (the authoritative Pass-3 gate, which supersedes this check's table at the shared path). A fourth file, `section-directive-drafter`, consumes the class **verb lists and prose framing** (not the conditions) and must be updated when those change. **All change together.** Any edit to the conditions, names, adjudication order, or ceilings requires a paired edit plus a `/risk-check` re-fire. Acceptance test for any future edit: the worked-cases table in the chassis § Adjudication order — every case must land in exactly one class.

> **⚠ CHASSIS-VERSION GATE — check FIRST, before running Check 9, and HARD-EXIT on failure.** Read the chassis-version marker in `reference/quality-standards.md § Claim-Permission Classes` (`**Chassis version: \`YYYY-MM-DD\`.**`, or `<!-- chassis-version: YYYY-MM-DD -->`). **Check 9 requires chassis version `2026-07-14` or later.** If the marker is absent or its date is earlier, **STOP — grade nothing** — and emit:
>
> > **cluster-memo-refiner Check 9 halted: this project's `reference/quality-standards.md` predates the 2026-07-14 permission re-cut.** This skill is canonical and symlinked; your chassis is a local copy and was not updated with it. Grading under the new adjudication order against the old class conditions would produce confident, wrong permission classes with **no error**. Back-port § Claim-Permission Classes (all subsections), § Country Coverage Table's gate rule, and § Research Stop Conditions from the canonical template, then re-run.
>
> This is load-bearing for the same reason as in `claim-permission-gate`: the skill travels by symlink and the chassis does not, so the two diverge on merge — and every other check here is a heading-presence check that an old chassis passes. A hard exit is the only thing that catches it.

**Target:** Surviving findings without a permission-class label; per-cluster permission table not emitted.

**Procedure — three sub-checks:**

1. **Permission-class assignment.** For each surviving Key Finding (post Checks 1–8), assign one of four classes per `reference/quality-standards.md § Claim-Permission Classes`.

   > **Lockstep contract (load-bearing).** The class conditions below are a **restatement** of the authority table in `reference/quality-standards.md § Claim-Permission Classes`. That section is the source of truth; this is a working copy. **Any edit to the class conditions, names, adjudication order, or ceilings must be applied to the chassis, this check, and `claim-permission-gate` together**, and requires a `/risk-check` re-fire per the chassis's Canonical-ordering rule. These two copies silently diverged before 2026-07-14 — an unguarded duplicate is a defect waiting to re-open.

   **Grade the class on evidence alone.** The class is a function of two things and nothing else: the count of **independent evidentiary roles**, then evidence **fit**. The claim's rhetorical ambition does NOT enter here — that is what the ceilings are for (below). Assign exactly one:

   - `SUPPORTED` — **≥2** independent evidentiary roles, evidence **direct and in-scope** (or a directly-applicable proxy needing no downgrade)
   - `PROXY-SUPPORTED` — **≥2** independent evidentiary roles, but the evidence is **proxy and requires downgrade** (out-of-scope, region-aggregate for a country-specific claim, or `PROXY-DOWNGRADE`-tagged)
   - `ILLUSTRATIVE-ONLY` — **exactly 1** independent evidentiary role (direct or proxy). It cannot be triangulated, so it cannot carry a generalization — but it may be stated, attributed, as the single attested case or datum.
   - `NOT-SUPPORTED` — **zero** evidentiary roles: no direct and no proxy evidence at any source class

   These four are **mutually exclusive and jointly exhaustive** — every evidence shape lands in exactly one, so do not invent a precedence rule. In particular: a single direct in-scope source that is *not* a named example (e.g. one regulator statistic) is `ILLUSTRATIVE-ONLY`, not a fall-through; and a pattern claim resting on 2 direct roles is `SUPPORTED`, with its generalization then bounded by the ceiling in sub-check 1b — **not** re-graded to `ILLUSTRATIVE-ONLY`.

   **Evidenced negatives grade normally.** A finding whose content is negative ("the practice does not occur in this segment") is graded on the same ladder and **can reach `SUPPORTED`** when ≥2 independent roles positively evidence the absence. Do not downgrade a conclusion for being negative. Conversely, a *failed search* is `NOT-SUPPORTED` and licenses neither the claim nor its negation — never invert it into a positive assertion of the opposite. Full rule: chassis § Evidenced Negatives vs Absence of Evidence.

   Apply the minimum evidence thresholds per claim type and the Source-Diversity Matrix from `reference/quality-standards.md` (same § Claim-Permission Classes). A project's per-claim-type table may **raise** the roles needed for `SUPPORTED`; it may not redefine a class. **Triangulation-packets rule:** N independent reports from the same source class count as ONE evidentiary role, not N. Where the project's `quality-standards.md` carries the cross-class collapse clause, the same applies across *different* source classes sharing one underlying origin — e.g. a trade-body summary and a specialist-press article both restating the same underlying benchmark figure count as ONE role, not two (per the `independence basis` field).

   **1b. Generalization ceiling (a cap on the claim, not a re-grade of the evidence).** After the class is assigned, bound the finding's *scope* by how many same-pattern instances support it — the ladder in sub-check 2 below (`<3` illustrative / `3–5` directional-with-caveat / `5+` across ≥2 countries pattern-permitted). This ladder governs **how broadly the finding may generalize**, not what class its evidence earns.

   **This check owns the NARROW branch** — it is the only consumer that does. Unlike `claim-permission-gate` (which must carry claim text verbatim and can therefore only cap), this check may rewrite a finding's scope. So: a finding that generalizes beyond what its instance count supports is **narrowed** to what the instances attest; only if it cannot be narrowed — it is inherently a generalization — is it capped at `ILLUSTRATIVE-ONLY`. Do not silently downgrade: relabel or escalate per sub-check 2. Record any applied cap in the Notes column.

   **When the ceiling fires — two tests, both required.** **(1) Does the finding's claim generalize?** Read the claim text: does it extrapolate a pattern across a class of actors, deals, or periods? If **no** (a single attested datum, a named case), the ceiling is **inapplicable** — record `instances: n/a`. **(2) If it generalizes, is there a warrant?** A generalization is warranted by **exactly one of two things**: **≥3 same-pattern instances**, **OR ≥1 population-level evidentiary role** (a complete statutory register, a mandatory-filing database, an exhaustive transaction record — coverage of the whole population the claim quantifies over; **a large sample is NOT a population** — a 140-respondent survey cannot supply the warrant alone). If **either** is present, the ceiling does not fire. If **neither** is, it fires.

   An **instance** is one observed occurrence of the asserted pattern — *not* a source and *not* an evidentiary role (three reports on the same deal = ONE instance). **Instances set the ceiling; roles set the class.** Never read `n/a` as `0`.

   > **⚠ RECORDING OBLIGATION — this check is the writer, and the Pass-3 gate will flag you if you skip it.** For **every finding whose claim text generalizes**, you MUST record its warrant in the memo, as **either**:
   > - `instances: {count}` — the same-pattern instance count, **or**
   > - `instances: n/a (population-level — {named source})` — naming the population-level source.
   >
   > A **bare `n/a` on a generalizing finding is a defect, not an exemption** — it tells the gate nothing about why the claim may generalize, and silence is not permission. `claim-permission-gate` will cap such a claim at `ILLUSTRATIVE-ONLY` and flag it `[POPULATION-LEVEL-UNVERIFIED — operator review]`. **This is what protects an evidenced negative** — a claim with zero positive instances by construction ("no CVs were used in this segment") is warranted by population coverage, not by an instance count, and only *this* check can record that. If you don't, a well-evidenced negative gets capped downstream on a technicality.
   >
   > Findings written before 2026-07-14 do not carry this field. Expect gate flags on the first re-run against an existing project; that is memo-completion work, not an evidence failure. Full rule: chassis § Permission ceilings.

   **Risk-tier permission ceiling (a cap, not a re-grade).** After the evidence-graded class above is assigned, cap it by the finding's risk tier per `reference/quality-standards.md § Risk-Tier Model`. The tier never *raises* a class — a Tier-A finding with thin evidence still lands NOT-SUPPORTED; the ceiling only bounds the top.
   - **Resolve the finding's contributing questions.** These are the research questions feeding this Key Finding — already identified by Check 1 (cross-question contribution count) and Check 2 (contributing-question notes on escalation findings). Read each contributing question's `risk-tier:` value from the research plan.
   - **Binding tier = the MOST-RESTRICTIVE tier among the contributing questions** (restrictiveness order D > C > B > A). Rationale: a finding load-bearing on a Tier-D question — illustrative *by construction* — must not be lifted to a stronger class by a co-occurring higher-tier question; that would launder illustrative evidence into a pattern claim. This is the same weakest-link posture the gate already applies to orphan citations and unresolved conflicts. *Example:* a finding drawing on Q3 (Tier A) and Q7 (Tier D) binds at **D** → hard-capped to `ILLUSTRATIVE-ONLY`, even if its evidence-graded class was `SUPPORTED`.
   - **Apply the ceiling for the binding tier:**
     - **D → hard cap:** force the finding to `ILLUSTRATIVE-ONLY` (no override), regardless of the evidence-graded class.
     - **C → advisory:** if the evidence-graded class is stronger than `PROXY-SUPPORTED` (i.e. `SUPPORTED`), do NOT silently downgrade — keep the graded class and flag it in the permission-table Notes as `[C-CEILING-EXCEEDED — operator review]`. The operator may override at the existing approval gate.
     - **A / B → ceiling `SUPPORTED`:** no constraint beyond the normal gate.
   - **Presence-gate (load-bearing backward-compat).** Resolve tiers *per question*, then bind. A single contributing question with an absent `risk-tier:` field defaults *that question* to Tier B — it still participates in the most-restrictive selection, so a finding resting on a Tier-D question and an un-tiered question still binds at **D**. Treat the *whole finding's* binding tier as **B** (ceiling SUPPORTED → no constraint) only when no tier is resolvable at all: no research plan provided, OR a project `quality-standards.md` with no `§ Risk-Tier Model` section, OR none of the finding's contributing questions can be resolved to plan question IDs. An un-tiered project therefore binds every finding at Tier B and runs exactly as before.
   - **Record** the binding tier and any cap/flag in the per-cluster permission table Notes column (sub-check 3) — e.g. `Binding tier: D — hard-capped to ILLUSTRATIVE-ONLY`, `Binding tier: C — [C-CEILING-EXCEEDED — operator review]`, or `Binding tier: B (presence-gate default)`.

   The four permission-class names, their verb lists, and gate semantics (§ Claim-Permission Classes) are unchanged by this ceiling — it is the single point of contact between the control-effort axis and the permission machinery.

   **Composition with other downgrades.** The **four ceilings** — the risk-tier ceiling, the generalization ceiling (sub-check 1b), the Check 8 country-coverage ceiling (≥2 countries `not evidenced` → cap at ILLUSTRATIVE-ONLY), and the Check 10 unresolved-conflict downgrade (one class down) — all move a finding's class in the *same* (more-restrictive) direction. The finding's final class is therefore the **most-restrictive of all of them**; because they compose monotonically downward, the order in which they are applied does not change the result. **All of them cap; none of them re-grades the evidence** — the evidence-graded class is assigned first, once, and every cap is recorded in the Notes column so the operator can tell an evidence verdict from a ceiling.

2. **No-orphan-citation enforcement.** Each citation must answer the question "What exact sentence does this source support?" If the answer is vague or the source supports only a general topical area, remove the citation OR downgrade the dependent claim by one permission class. Record the downgrade rationale inline.

3. **Per-cluster permission table emission.** Emit a per-cluster permission table to `analysis/claim-permission/{section}/{section}-cluster-NN-permission-table.md` per the canonical file-conventions row. Columns: Claim ID, Claim text (short), Permission class, Source channels count, Source-diversity matrix verdict (per claim type), Country-parity status (from Check 8), Notes (risk-tier binding + ceiling cap/flag, orphan-citation downgrades, pan-Nordic-leakage flags, etc.). The risk-tier binding and any cap/flag from sub-check 1 are recorded in the Notes column (free-text, additive — no new column, so existing positional parsers of this table are unaffected).

   **The table's frontmatter MUST carry `chassis_version: {YYYY-MM-DD}`** — the version marker read at the pre-flight chassis-version gate, copied verbatim (added 2026-07-14; same field and same contract as `claim-permission-gate`'s Output schema, which writes to this same path and supersedes this table at Pass 3). The chassis-version gate stops a *new* run against *old* rules; this field is what lets a *downstream consumer* tell whether a table **already on disk** was graded by rules since found to have a gap and an overlap. Without it, a stale table is indistinguishable from a current one and its verdicts are consumed as authoritative. Never omit it; never back-fill it with a guess.

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

1. **Extract-to-conflict-log coverage.** For each cluster, read the research extracts feeding the cluster's findings (the Optional extracts input declared in Input Requirements) and identify any conflict entries (sources reporting different values or classifications for the same fact, per `research-extract-creator`'s no-silent-selection rule). For each conflict found in extracts, verify a corresponding entry exists in `analysis/source-conflicts/{section}/{section}-source-conflict-log.md` per the canonical file-conventions row. **If the extracts cannot be located,** skip this sub-check with a one-line `extracts not located — extract-to-conflict-log coverage not verified` note and proceed to sub-checks 2–3 (per the presence-gate in Input Requirements).

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
10. **Check 9 — Permission-Class Emission:** Every surviving Key Finding carries a permission-class label (`SUPPORTED` / `PROXY-SUPPORTED` / `ILLUSTRATIVE-ONLY` / `NOT-SUPPORTED`); the risk-tier ceiling was computed and applied for every surviving finding — binding tier = most-restrictive contributing-question tier, capped per § Risk-Tier Model (D hard-cap, C advisory flag, A/B unconstrained), or the presence-gate drove Tier B (no constraint) — with the binding tier recorded in the permission-table Notes; per-cluster permission table emitted to `analysis/claim-permission/{section}/{section}-cluster-NN-permission-table.md`; orphan-citation downgrades recorded with rationale; `CLUSTER-INSUFFICIENT` clusters flagged where >30% NOT-SUPPORTED
11. **Check 10 — Source-Conflict Validation:** *When the research extracts were located* — all extract-level conflicts have corresponding entries in `analysis/source-conflicts/{section}/{section}-source-conflict-log.md`, and clusters with one or more unlogged extract conflicts are marked refinement-blocked. *In all cases* — all `UNRESOLVED` conflict-log entries covering this cluster have triggered downgrade in Check 9. If the extracts could not be located, sub-check 1 is recorded as skipped (per the presence-gate) and this criterion is met by the conflict-log-side checks alone.

If any criterion is not met, the memo requires another refinement pass on the failing check(s) before proceeding to editorial review.

## Output Protocol

**Default mode: Refinement**

Present check findings as a structured report (per check, per memo) before producing revised memos. Structure the findings report as one section per memo, with sub-sections per check — this groups all issues for a single memo together for easier operator review.

**Report-envelope skeleton.** Each memo gets its own top-level section; each check gets a sub-section holding that check's own Output content (per the Output line in each check above). A roll-up sub-section closes out the memo with the Completion Criteria status and the blocking-gate verdict:

```
## Refinement Findings — {memo / cluster identifier}

### Check 1 — Cross-Question Synthesis Depth
{Check 1 Output: single-source findings with disposition — merged / relabeled / retained}

### Check 2 — Escalation Patterns
{Check 2 Output: escalation patterns, contributing questions, proposed placement}

### Check 3 — Evidence Strength Map Accuracy
{Check 3 Output: labels checked pass/fail, downgrades applied, uncertain labels flagged}

### Check 4 — "So What" Specificity
{Check 4 Output: before/after per rewritten recommendation}

### Check 5 — Tension Development
{Check 5 Output: per-tension completeness/concreteness pass-fail; new tensions with full treatment}

### Check 6 — Dependency Chains
{Check 6 Output: dependency pairs with classification}

### Check 7 — Named-Transaction Verification
{Check 7 Output: per finding — row-reference status, same-pattern count, threshold verdict, action taken}

### Check 8 — Country-Parity
{Check 8 Output: per finding — SE/NO/FI status, gate-rule verdict, pan-Nordic-leakage flag, action taken}

### Check 9 — Permission-Class Emission
{Check 9 Output: claim count, permission-class distribution, NOT-SUPPORTED ratio, blocking-gate verdict, permission-table path}

### Check 10 — Source-Conflict Validation
{Check 10 Output: extract-conflicts count, conflict-log-coverage status, unresolved-conflict downgrade-verification status, refinement-blocked flag}

### Roll-Up
- Completion Criteria 1–11: {met / not met, per criterion}
- Blocking-gate verdict: {CLEARED / CLEARED-WITH-CAVEATS / CLUSTER-INSUFFICIENT}
- Refinement-blocked (Check 10): {yes / no}
```

Repeat the envelope once per memo. If a check could not run (missing input, presence-gate, or hard-dependency halt per Required Reference Sections above), its sub-section states that instead of an Output.

Do not produce revised memos until the user says `RELEASE ARTIFACT`. This lets the user override specific check results before revisions are applied.

When the user says `RELEASE ARTIFACT`, write the revised memos to files rather than outputting them in chat. Use the working directory or a path the user specifies.

## Example Output

A worked example of one refined Key Finding plus its rendered permission-table row, showing the claim ID and a populated `Binding tier:` Notes value.

**Refined Key Finding (in the revised memo):**

> **[REFINED]** `1.1-cluster-04-claim-07` — Swedish lower-mid-market sponsors shifted toward buy-and-build in 2023–2024, with add-on velocity rising while platform entries slowed. *(escalation pattern from Q3 + Q7; tagged [ANALYTICAL])* Evidence Strength Map: Sweden `observed`, Norway `proxied`, Finland `not evidenced` → reframed as two-country (Sweden + Norway proxy), Finland caveated. `[merged-from: 1.1-cluster-04-claim-07, 1.1-cluster-04-claim-11]`

**Corresponding permission-table row** (`analysis/claim-permission/1.1/1.1-cluster-04-permission-table.md`):

| Claim ID | Claim text (short) | Permission class | Source channels | Source-diversity verdict | Country-parity | Notes |
|---|---|---|---|---|---|---|
| `1.1-cluster-04-claim-07` | SE sponsors → buy-and-build, 2023–24 | `ILLUSTRATIVE-ONLY` | 2 | Pass (2 independent roles) | SE observed / NO proxied / FI not evidenced | Binding tier: D — hard-capped to ILLUSTRATIVE-ONLY (contributing Q7 is Tier D; evidence-graded class was PROXY-SUPPORTED). Finland reframe applied (Check 8). |

The `Binding tier:` text in Notes is free-text and additive — it adds no column, so existing positional parsers of this table are unaffected. A presence-gate default would instead read `Binding tier: B (presence-gate default)`; a C-tier exceedance would read `Binding tier: C — [C-CEILING-EXCEEDED — operator review]`.

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

## Runtime Recommendations

- **Model / effort.** Runs at `model: opus`, `effort: high` (frontmatter). The ten checks are judgment-dense — cross-question synthesis, evidence-grade adjudication, and the risk-tier ceiling all require weighing rather than mechanical matching — so the high tier is load-bearing, not a default.
- **Context loading.** Load the cluster memos plus whichever Optional inputs are present (briefs, research plan, transaction table, research extracts, source-conflict log). Each absent input degrades a specific check per the presence-gates in Input Requirements rather than blocking the run.
- **Progress tracking (C19).** With ten checks across multiple memos, emit a one-line per-memo progress marker as each memo's check sweep completes (e.g., `cluster-04: checks 1–10 complete, 3 findings flagged`) so a partial failure mid-sweep is visible before the completion-criteria decision.
- **Frontmatter decisions (recorded for audit):**
  - **`disable-model-invocation` (C6) — not set, deliberately.** This skill is invoked by name from the Stage-3 refinement step (`/run-cluster`); it is not auto-triggered on unrelated prompts, and its description triggers are scoped to cluster-memo refinement, so a model-invocation fence is unnecessary.
  - **`allowed-tools` (C7) — not fenced, deliberately.** The skill both reads (memos, briefs, plan, extracts, conflict log) and writes side-effect files (per-cluster permission tables under `analysis/claim-permission/`), and it locates extracts by content rather than a fixed path — so it needs read, write, and search tools. A narrow `Read, Write` fence would break extract discovery; the no-external-evidence constraint is enforced by the Guardrails ("operate only from provided memos and briefs"), not by a tool fence.
  - **`paths` (C8) — not set.** The skill is invoked positionally from the Stage-3 step, not path-triggered; there is no file-glob that should auto-activate it.
