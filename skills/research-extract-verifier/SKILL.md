---
name: research-extract-verifier
description: >
  Adversarial verification of Research Extracts against raw Deep Research reports —
  use when a raw report, its Research Extracts, and matching Answer Specs are
  provided to "verify extracts," "QC the extracts," "check extraction quality,"
  "run extract verification," "run step 2.4," "run 2.4," or similar. Step 2.4
  in Stage 2.

  Flags missed claims, distorted claims, wrong strength assignments, unjustified
  coverage verdicts, synthesis-evidence mismatches, and false-scarcity verdicts
  (THIN/MISSING without searching expected public surfaces); produces per-extract
  APPROVED / FLAG — RE-EXTRACT verdicts with re-extraction instructions to Step 2.3.

  Do NOT use for fixing extracts (Step 2.3, research-extract-creator); citation
  verification against URLs (Stage 5 fact verification); judging whether
  research questions are well-formed (upstream); editorial judgments on which
  findings matter (cluster-analysis-pass); or supplementing evidence from
  training data or external knowledge.
model: opus
effort: high
allowed-tools: Read, Write
---

# Research Extract Verifier

Verify Research Extracts against the raw Deep Research reports they were extracted from. Identify extraction failures and produce per-extract verdicts with re-extraction instructions. This skill verifies — it does not fix.

**Workflow position:** Step 2.4 in Stage 2. Receives extracts from Step 2.3. APPROVED extracts flow downstream. Flagged extracts route back to Step 2.3.

## Calibration

Do not invent issues. If the extract accurately reflects the report, say so. Do not inflate severity to appear thorough — an APPROVED verdict on a clean extract is the correct outcome. If evidence for a finding is ambiguous, mark it as uncertain rather than asserting a failure.

## Input

Three items per session, provided together:

1. **Raw Deep Research report** — source material for one session (2-4 questions)
2. **Research Extracts** — produced from that report at Step 2.3, one per question
3. **Answer Specs** — for the questions covered in this session

### Input Validation

Before proceeding:
- If fewer than three input items are provided, state which are missing and request them. Do not begin verification with incomplete inputs.
- Verify extract session letters match the raw report
- Verify Answer Spec question IDs match extract question IDs
- If the raw report covers questions for which no extract was provided, note the missing extracts by question ID and flag as requiring extraction at Step 2.3
- If mismatched: state the mismatch, request correction, do not proceed

## Verification Checks

Run seven checks per extract, in order. Checks 1–6 always run; Check 7 fires only on a scarcity verdict (see its trigger).

### Check 1 — Missed Claims

Read the raw report section by section. For each Answer Spec component, identify substantive claims (factual assertions with source attribution addressing a component) not captured in the extract. Ignore transitional sentences, framing language, and restatements.

Per missed claim, state:
- The claim and its report location (section heading + position)
- Which Answer Spec component it maps to
- Whether including it would change the coverage verdict for that component

### Check 2 — Distorted Claims

For each claim in the extract, compare against the corresponding report content using the Source Locator field.

Flag distortions where meaning shifted. Common patterns:
- Hedged to definitive
- Associational to causal
- Scoped findings generalized beyond scope
- Multiple findings collapsed, losing nuance
- Quantitative figures or ranges altered

Per distortion: state what the report says, what the extract says, how they differ.

### Check 3 — Strength Signal Verification

Assess whether each claim's H/M/L strength assignment matches its evidence basis:

- **H (High):** Multiple independent credible sources; primary/institutional data; direct evidence
- **M (Medium):** Single credible source or multiple with shared editorial origin; indirect but reasonable evidence
- **L (Low):** Single source of uncertain quality; inferential; tangential; vendor/advocacy without corroboration

Flag mismatches. State current assignment, evidence basis visible in the report, and correct assignment. Also flag independence counts that appear wrong (e.g., shared primary data counted as independent). If the raw report provides insufficient source metadata to assess strength, mark the claim as unverifiable for Check 3 and note in the issue table.

### Check 4 — Coverage Verdict Verification

Verify each component's coverage verdict against thresholds:

- **COVERED:** >=2 claims with >=1 at High, OR >=3 claims at Medium with >=2 independent sources
- **THIN:** 1 claim at any strength, OR 2+ claims all Low, OR only shared-editorial-origin sources
- **MISSING:** No claims for this component

Check both directions:
- **Too generous:** marked COVERED but doesn't meet threshold
- **Too conservative:** marked THIN/MISSING but claims meet COVERED — especially after accounting for missed claims from Check 1

### Check 5 — Component Synthesis Accuracy

For each Component Synthesis paragraph, verify it reflects the listed claims:
- Does it overstate evidence strength?
- Does it introduce unsupported framing?
- Does it omit a key finding the claims support?
- Is it consistent with the coverage verdict?

### Check 6 — Stop Condition Verification (S-13)

Per `reference/quality-standards.md § Research Stop Conditions`, every research subtask must close on one of 4 conditions. The Stage 2 execution prompt declares the target stop condition; this check verifies the closure.

**Procedure:**

1. **Identify the target stop condition.** Read the session's research prompt (the document `research-prompt-creator` produced) and locate the session-level Steering Note declaring the target condition. The 4 canonical conditions:
   - Condition 1: Two high-quality direct sources answer the question.
   - Condition 2: One high-quality direct source plus three named examples support the pattern.
   - Condition 3: Three source classes (per `reference/source-class-hierarchy.md`) have been checked and no direct evidence exists.
   - Condition 4: Local-language, primary-source, and advisory-source searches all fail.

2. **Determine which condition actually closed the subtask** by inspecting the extract's source landscape:
   - Count high-quality direct sources cited → if ≥2, candidate Condition 1
   - Count high-quality direct sources + named examples → if 1+3, candidate Condition 2
   - Count distinct source classes searched per the report's Source Log → if ≥3 classes and no direct evidence, candidate Condition 3
   - Check whether local-language sources, primary sources, AND advisory sources were all attempted and all returned nothing → Condition 4

3. **Record the closing condition** in the per-extract output (see Output Format below) under a new field `Stop condition closed`.

4. **Mark `EVIDENCE-CEILING-REACHED`** when the closing condition is 3 or 4 (the subtask reached the available evidence ceiling). Affected claims are pre-classified PROXY-SUPPORTED or NOT-SUPPORTED for downstream `cluster-memo-refiner` Check 9 consumption. This pre-classification is informational; Check 9 makes the final determination.

5. **Reciprocal-rule check:** if the subtask appears to have stopped before ANY of the 4 conditions is met (e.g., extract has 1 source and no claim that all source classes were exhausted), flag as `INCOMPLETE-RESEARCH`. Affected claims auto-downgrade to NOT-SUPPORTED per `reference/quality-standards.md § Research Stop Conditions` reciprocal rule. This is a FLAG-triggering condition (see Verdict Logic below).

**Output (per extract):**
- `Stop condition closed: 1 / 2 / 3 / 4 / INCOMPLETE-RESEARCH`
- `EVIDENCE-CEILING-REACHED: yes / no` (yes when closing condition is 3 or 4)
- `Target condition (from prompt): 1 / 2 / 3 / 4 / (not declared)`
- `Match between target and actual: yes / no / unverifiable`

### Check 7 — Source-Surface Coverage

**Trigger — scarcity verdicts only.** Run Check 7 for a component ONLY when Check 4 returned **THIN or MISSING** for it, OR Check 6 returned **EVIDENCE-CEILING-REACHED** (closing condition 3 or 4). Skip entirely for COVERED components — this contains cost and keeps the check off the common path.

**Purpose.** A scarcity verdict should mean "the evidence is not public," not "we did not look in the obvious place." This check separates *true* scarcity (the expected public surfaces were searched and nothing was found) from *false* scarcity (a top-of-ladder public surface was never searched). It directly attacks the failure mode where THIN/Gated is asserted when the real cause was an unsearched surface — most exposed on paywall-heavy evidence needs.

**Procedure.**

1. **Locate the evidence need.** Map the scarce component to its row in `reference/source-class-hierarchy.md § Source Class Hierarchy by Evidence Need`, to the matching source-exhaustion ladder, and to the relevant Named-Source Appendix category.

2. **Graceful-degradation guard (mandatory — do not skip).** If `reference/source-class-hierarchy.md` is absent, OR no evidence-need row / ladder matches the component, OR the appendix carries no parseable named-surface entries (shape mismatch) → Check 7 **NO-OPS**. Record `not-checked` (file or ladder absent) or `unverifiable` (present but unmappable / shape mismatch). Do **NOT** invent expected surfaces, and do **NOT** FLAG on a no-op. Match on the evidence-need row / ladder *identity*, never on free-text appendix heading strings — a renamed heading must degrade to `unverifiable`, not silently mis-fire. This guard is what makes the check safe in consuming projects that have no `source-class-hierarchy.md`.

3. **Compare against the report's Source Log.** For the mapped evidence need, identify the expected top-of-ladder named public surfaces (ladder steps from the top down to — but excluding — any *unavailable* anchor step). Check whether the raw report's Source Log shows those surfaces were actually searched. If the raw report carries **no Source Log** (or one too sparse to tell what was searched), Check 7 cannot confirm coverage either way → record `unverifiable` and do not FLAG (the missing Source Log is a report-quality issue surfaced elsewhere, not a false-scarcity signal).

4. **Classify:**
   - All expected top-of-ladder surfaces searched, nothing found → `confirmed-scarcity` (no flag — a genuine evidence ceiling).
   - One or more expected top-of-ladder surfaces **not** searched → `false-scarcity-flagged` → FLAG (see Verdict Logic). The scarcity verdict is not yet earned.

**Route on `false-scarcity-flagged`.** As with Check 6's `INCOMPLETE-RESEARCH`, re-extraction is a no-op when the gap is an *unsearched surface* — the FLAG routes back to Step 2.2 / Step 2.3 for a targeted **supplementary pass** against the named unsearched surface(s), not a re-extraction of existing material. Name the specific unsearched surface(s) in the instruction.

**Source-Surface Coverage contract.** Check 7 reads three structures from `reference/source-class-hierarchy.md`: the evidence-need → source-class table, the source-exhaustion ladders, and the Named-Source Appendix. This is a two-end contract: the project-local file is the producer, this check is the consumer. The producer side is documented in `source-class-hierarchy.template.md`. Absence or shape-mismatch on the producer side degrades this check gracefully (step 2) — it never hard-fails and never fabricates expected surfaces.

**Output (per extract, only when Check 7 ran):**
- `Source-surface coverage: confirmed-scarcity / false-scarcity-flagged / not-checked / unverifiable`

## Verdict Logic

**APPROVED** — No issues, or only trivial issues not affecting downstream quality (e.g., minor synthesis wording that doesn't change meaning).

**FLAG — RE-EXTRACT** — One or more issues affecting downstream quality. Any single threshold triggers FLAG:
- Any missed claim that would change a coverage verdict
- Any distortion changing the meaning of a claim used in a Component Synthesis
- Any strength assignment off by more than one level (e.g., L when H is justified)
- Any coverage verdict not meeting the threshold rubric
- >=2 minor issues on the same extract (individually non-blocking but collectively indicating systematic quality problems)
- **Check 6 returns `INCOMPLETE-RESEARCH`** (S-13 reciprocal-rule violation — the subtask stopped before any of the 4 canonical stop conditions was met). Re-extraction may be a no-op if the underlying research is the issue; in that case, the FLAG routes back to Step 2.2 / Step 2.3 for supplementary research rather than re-extraction.
- **Check 7 returns `false-scarcity-flagged`** (a top-of-ladder public surface for the scarce component was not searched — the scarcity verdict is not yet earned). Routes back to Step 2.2 / Step 2.3 for a targeted supplementary pass against the named unsearched surface(s), same handling as `INCOMPLETE-RESEARCH`. The other Check 7 outputs — `confirmed-scarcity`, `not-checked`, `unverifiable` — do **NOT** trigger FLAG.

### Borderline Cases

When a finding is uncertain (e.g., unclear if a report claim is substantive or transitional, unclear if two sources share editorial origin):
- Mark with "?" in the issue table
- State the uncertainty in the Impact column
- Do not let uncertain findings alone trigger FLAG — only flag if the uncertain finding, if real, would cross a threshold

## Re-extraction Instructions

Every FLAG verdict must include instructions specific enough for `research-extract-creator` to act without reading the full QC report. Each instruction identifies:
- Which claim or component is affected
- What went wrong (missed, distorted, mis-graded, verdict wrong)
- What correct extraction looks like

Good: "Q3-C04 distorts the source — report says 'primarily in large-cap contexts' but extract generalizes to all PE. Re-extract with scope qualifier preserved."

Good (Check 7 false-scarcity): "Q2 marked THIN on dispersion, but the Source Log shows Invest Europe and the national-association performance reports (returns/dispersion ladder steps 1–2) were never searched. Not re-extraction — route to Step 2.2 supplementary pass against those two surfaces before accepting scarcity."

Bad: "Check Q3 again."

When multiple checks flag issues on the same component, consolidate into a single re-extraction instruction that addresses all issues together. If issues span >=3 checks on one extract, recommend full re-extraction of that extract rather than per-issue patching.

## Output Format

Per Research Extract:

```
## [Question ID] — [Question Short Title]

**Verdict: APPROVED / FLAG — RE-EXTRACT**

**Stop condition closed:** [1 / 2 / 3 / 4 / INCOMPLETE-RESEARCH]
**EVIDENCE-CEILING-REACHED:** [yes / no]
**Target condition (from prompt):** [1 / 2 / 3 / 4 / (not declared)]
**Source-surface coverage:** [confirmed-scarcity / false-scarcity-flagged / not-checked / unverifiable] — *(only when Check 7 ran, i.e. a scarcity verdict; omit the line for COVERED components)*

### Issues found (if any):

| Check | Issue | Location | Impact | Re-extraction instruction |
|-------|-------|----------|--------|--------------------------|
| [1-7] | [Description] | [Component + Claim ID or report section] | [What it affects downstream] | [Specific instruction for re-extraction] |

### Checks passed:
[List which of the 7 checks passed clean — for COVERED components, Check 7 is not run; list it as "n/a (not a scarcity verdict)" rather than passed]
```

After all extracts:

```
## Session Summary

- Extracts reviewed: [count]
- APPROVED: [count] — [list Question IDs]
- FLAG — RE-EXTRACT: [count] — [list Question IDs]

Re-extraction priority: [order flagged extracts by severity — most downstream impact first]
```

## Output Protocol

Write the verification report to a markdown file in the project's working directory. Use the naming convention `extract-verification-{session-letter}.md`. Provide a brief summary in chat with the verdict for each extract and the file path.

## Failure Behavior

- **Report too short/vague to verify against:** State this, produce best-effort verification on what's verifiable, note which checks couldn't run and why.
- **Extract references content not in the provided report:** Flag as potential hallucination. Automatic FLAG regardless of other checks.
- **Source Locator missing or too vague:** Flag claim as unverifiable for Check 2. If >50% of claims in an extract have unverifiable source locators, flag the entire extract for re-extraction with a note to improve locator specificity.
- **Answer Spec and raw report directly contradict each other:** Surface the conflict explicitly — state what the Answer Spec asserts and what the report says — rather than silently resolving it by picking one side. Flag the affected component and route for operator clarification before assigning a coverage verdict.

## Scope Boundaries

- Do not fix extraction errors — flag and route only
- Do not supplement evidence from training data or external knowledge
- Do not make editorial judgments about finding importance

## Runtime Recommendations

- **`allowed-tools` (C7) — set to `Read, Write`.** The skill reads the three provided inputs (raw report, extracts, Answer Specs) plus the project reference files Checks 6–7 consult (`reference/quality-standards.md`, `reference/source-class-hierarchy.md`), and writes one verification-report file per session (see Output Protocol). No shell, network, or search tool is used — the Read + Write fence mechanically enforces the no-external-evidence constraint stated in Scope Boundaries.
- **`disable-model-invocation` (C6) — not set, deliberately.** The description's trigger phrases ("verify extracts," "run step 2.4," etc.) are specific enough that autonomous invocation is safe, and the skill's one file-write side effect — the verification report — is additive documentation of a QC pass rather than a mutation of existing project state, so a model-invocation fence is unnecessary.
