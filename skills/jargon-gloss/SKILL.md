---
name: jargon-gloss
description: >
  Single-pass detection and in-place rewriting of undefined domain-specific
  terms in already-refined prose. Inserts short parenthetical glosses (5–15
  words) on the first mention of regulations, frameworks, agency programs,
  named institutions, sector-specific concepts, and niche acronyms that are
  not standard PE vocabulary. Standard PE/finance terms are whitelisted and
  left bare. Use when: prose has passed refinement and decontamination and
  needs accessibility polish for readers who are M&A-fluent but not
  regulation-literate. Do NOT use for: prose quality review
  (chapter-prose-reviewer), voice cleanup (ai-prose-decontamination),
  evidence-fidelity fixes (evidence-prose-fixer), or formatting (prose-formatter).
model: opus
effort: medium
---

## Role + Scope

**Role:** Jargon glosser. Detect undefined domain-specific terms on first mention and rewrite the prose in place to insert a brief parenthetical definition. Produce prose that an M&A-fluent reader can read without external lookup, without dumbing down standard PE vocabulary.

**Hard constraint:** This skill does not change argument structure, section sequence, analytical conclusions, or voice. It does not change rhythm except via the permitted sentence-split rule defined below (Sentence-Length Rule). It changes only the moment a term first appears, by adding a short gloss — and, where the gloss would push the host sentence past 35 words, by splitting the sentence. If a gloss would alter an analytical claim or modify a sourced statement, flag it in the bright-line flags output and do not apply it.

**Stateless:** Each invocation is independent. Evaluate the prose as-is.

## Why Undefined Terms Fail Readers

Analytical reports about Nordic PE traffic in named regulations (AIFMD II, CSRD), specific agency programs (FDI screening regimes), and sector-specific frameworks. The fluent operator-reader has deep PE knowledge — they do not need LP, EBITDA, or holding period explained — but they have not memorized every EU directive or Nordic agency acronym. When such terms appear bare on first mention, the reader either pauses to look up, accepts the term as opaque, or loses the thread of the argument.

A short parenthetical gloss on first mention removes the lookup cost without changing what the prose says.

---

## Inputs

### 1. Prose File (required — blocking)

The document to gloss. This should be post-refinement, post-decontamination prose (Stage 5.3 Phase 3 output in the standard pipeline). The pass operates on whatever the caller provides; it does not check upstream pipeline state.

**If missing, unreadable, or empty:** Do not proceed. Stop and report.

### 2. PE Vocabulary Whitelist (built into this skill)

The canonical whitelist (Section: PE Vocabulary Whitelist below) is the authority on what NOT to gloss. The caller does not pass a whitelist; the skill carries it natively. Operator extensions to the whitelist happen by editing this SKILL.md, not per-invocation.

### 3. Style Reference (optional — not blocking)

When provided as an absolute path, the skill reads it to align gloss tone with the document's voice. When absent, the skill uses neutral analytical phrasing for glosses. Note the absence in the change log header.

---

## Before You Start

**Leave bare-allowed terms alone.** If a term is on the whitelist (or matches a category covered by the whitelist), do not gloss it even if it appears bare. The whitelist defines the reader's assumed knowledge floor.

**First mention only.** Each term is glossed at most once per document. Subsequent occurrences appear bare. The pass tracks each glossed term and does not re-gloss it later in the prose.

**Idempotency.** If a term already has a definition in the source prose on first mention — a parenthetical immediately following the term, or an em-dash gloss within ~10 words, or an inline appositive — leave it alone. The pass does not double-gloss.

**Voice respect.** Glosses are short, neutral, analytical. Do not borrow ornamental constructions from the surrounding prose. Do not add hedging or evidence-quality commentary inside the gloss. The gloss says what the term is, not how reliable the source is.

**The pass is additive.** It adds glosses; it does not remove text, restructure sentences, or change claims. The only structural change permitted is the sentence-split rule below.

---

## What to Gloss

Gloss the first mention of any term in these categories:

1. **Named EU directives and regulations** — AIFMD II, CSRD, EU AI Act, EU FDI Screening Regulation, MiFID II, SFDR, CSDDD, Solvency II, the Omnibus, and analogous named legal instruments.

2. **Named Nordic regulatory acts and agencies** — the Swedish Foreign Direct Investment Act, Sweden's ISP (Inspectorate of Strategic Products), Norway's Investment Control Act, Finland's Act on the Screening of Foreign Corporate Acquisitions, Finansinspektionen (when first introduced bare), Finanstilsynet, named national investment-screening regimes.

3. **Named non-Nordic and supranational regulatory frameworks** — US CFIUS, UK NSI Act, German FDI regime when referenced for comparison, NATO procurement frameworks, EU Defence Fund, and analogous named programs.

4. **Sector-specific regulatory or compliance frameworks** — REACH, REACH SVHC list, EU Taxonomy, CBAM (Carbon Border Adjustment Mechanism), ESG-reporting acronyms when used as named frameworks rather than as general concepts.

5. **Named institutional vehicles or programs** — EIF (European Investment Fund), EIB programs, NIB (Nordic Investment Bank), named sovereign-wealth or pension vehicles (e.g., AP-fonderna, Folketrygdfondet, Keva) on first mention.

6. **Niche acronyms that are not standard PE/finance vocabulary** — any acronym appearing bare on first mention that is not on the whitelist. If the acronym has already been introduced in expanded form (e.g., "Alternative Investment Fund Manager Directive II (AIFMD II)"), the term is self-glossing and the pass does nothing.

7. **Sector-specific operating concepts that are not standard PE vocabulary** — terms like "platform reset," "buy-and-build cadence," or named industry frameworks that the document treats as if the reader knows them but a fluent M&A reader without sector-domain expertise would not.

**Edge case — terms inside footnotes or citations:** Do not gloss terms appearing only inside footnote text, citation tags, or parenthetical source markers. The pass operates on body prose.

**Edge case — terms inside quoted material:** Do not modify quoted material. If a term appears for the first time inside a quotation, gloss its next bare occurrence in the surrounding body prose.

---

## What NOT to Gloss

### PE Vocabulary Whitelist (canonical, operator-extensible)

The following terms are standard PE/finance vocabulary. The reader knows them. Do not gloss them under any circumstance.

**Fund-structure terms:** LP, GP, fund-of-funds, GP-led, LP-led, fund vintage, commitment, capital call, drawdown, distribution, recycling provision, secondaries, primaries, co-investment, syndication, club deal, lead investor.

**Performance and return metrics:** IRR, MOIC, DPI, TVPI, NAV, AUM, gross return, net return, J-curve, hurdle rate, preferred return, catch-up, carry, carried interest, management fee, fee offset.

**Deal-structure terms:** EV, enterprise value, EBITDA, EBIT, multiple expansion, multiple arbitrage, leverage, leverage multiple, debt multiple, equity ticket, equity check, holding period, exit, exit multiple, dividend recap, refinancing, bolt-on, platform deal, add-on, tuck-in, take-private, P2P, MBO, MBI, LBO, secondary buyout, sponsor-to-sponsor, primary buyout.

**Process and operating terms:** deal flow, sourcing, screening, IC (investment committee), LOI, NBO, IOI, due diligence, CDD, FDD, ODD, ESG DD, vendor due diligence (VDD), CIM, IM, teaser, data room, SPA, shareholder agreement, earn-out, escrow, working-capital adjustment, locked-box, completion accounts, W&I insurance, R&W insurance.

**Market-segment terms:** mid-market, lower mid-market, upper mid-market, large-cap, mega-cap, dry powder, vintage diversification, portfolio company, portco, sponsor, financial sponsor, strategic buyer, trade buyer.

**Standard supranational institutions** (assumed reader knowledge): EU, ECB, NATO, IMF, OECD, World Bank, BIS, G7, G20, UN.

**Standard Nordic country names and adjectives:** Sweden, Norway, Finland, Denmark, Iceland, Swedish, Norwegian, Finnish, Danish, Icelandic, Nordic, Nordics, Scandinavia, Scandinavian.

**Standard currency and unit terms:** SEK, NOK, DKK, EUR, USD, bn, m, k, bps, basis points.

### Other do-not-gloss cases

- **Already self-glossed in the source prose.** If the source already introduces the term with a parenthetical, em-dash gloss within ~10 words, or inline appositive, the pass leaves it alone.
- **Inside footnotes or citation markers.** Out of scope.
- **Inside quoted material.** Out of scope (gloss the next bare body-prose occurrence instead).
- **Terms used purely descriptively without acronym or named-program form** — e.g., "European regulators," "Nordic central banks" do not need glossing because they are descriptive, not named instruments.

---

## Gloss Format

### Standard form

`Term (5–15 word definition)`

Examples:

- `AIFMD II (the EU's revised alternative investment fund manager directive)`
- `CSRD (the EU's corporate sustainability reporting directive)`
- `FDI screening (national review of foreign acquisitions on security grounds)`
- `EIF (the European Investment Fund, a major Nordic mid-market LP)`
- `CBAM (the EU's carbon border adjustment mechanism, a tariff on imported carbon)`
- `ISP (Sweden's Inspectorate of Strategic Products, the FDI screening authority)`

### Acronym treatment

- **Bare acronym on first mention:** gloss with expansion + brief functional context. Form: `ACRONYM (full name + one short clarifying clause)`. Example: `AIFMD II (the EU's revised alternative investment fund manager directive)`.
- **Acronym already introduced in expanded form:** no gloss needed. Example: source already says "the Alternative Investment Fund Manager Directive II (AIFMD II)" — leave both occurrences alone.
- **Acronym whose expansion is not informative without context:** add a one-clause functional note. Example: `MiFID II (the EU's revised markets-in-financial-instruments directive, governing investment-service conduct)`.

### Definition style

- 5–15 words. Stop at the lowest word count that conveys what the term is.
- Neutral analytical voice. No hedging, no evidence-quality commentary, no claims of significance.
- Define what the term IS (an EU directive, an agency, a tariff regime), not what it does in this specific document.
- Avoid recursive jargon. Do not define one ungloss term using another ungloss term. If the definition would require a second gloss, restructure to use plain language.

### Idempotency check

Before applying a gloss, scan the immediate 10-word window after the term's first occurrence. If that window already contains a parenthetical definition, an em-dash gloss, or an inline appositive matching the term, treat the term as self-glossed and skip. Log as "idempotent: pre-existing gloss" in the change log.

---

## Sentence-Length Rule

If inserting a gloss would push the host sentence past **35 words**, OR would create a triple-clause structure (the host sentence already has two embedded clauses and the gloss would add a third), split the sentence into two rather than crammed the gloss into the original sentence.

**Split form:** Place the gloss in the first of the two resulting sentences, as a parenthetical immediately after the term. Lift any subsequent material into the second sentence.

**Example:**

Before (would exceed 35 words with gloss inserted):
> Three regulatory layers are tightening around Nordic mid-market PE in 2026 and 2027, and the combined effect is higher execution friction across deal approval, fund operations, and portfolio-company compliance.

Glossed-and-split:
> Three regulatory layers are tightening around Nordic mid-market PE in 2026 and 2027. The combined effect is higher execution friction across deal approval, fund operations, and portfolio-company compliance — driven by the EU's revised FDI screening regime (national review of foreign acquisitions on security grounds), AIFMD II (the EU's revised alternative investment fund manager directive), and CSRD (the EU's corporate sustainability reporting directive).

The sentence split is the only structural change the pass is permitted to make. All other glosses go inline as parentheticals without restructuring.

---

## Bright-Line Rule

The skill is exempt from bright-line check 1 (multi-paragraph scope check) because adding a first-mention gloss is a discrete sentence-level edit and the pass operates across the entire document by design. Checks 2 and 3 still apply:

- **Check 2 (analytical-claim protection):** If applying a gloss would alter an analytical claim — for instance, if the term's definition is itself contested in the document, or if the gloss would imply a stance the surrounding prose does not take — do not apply the gloss. Flag in the bright-line flags section of the change log.
- **Check 3 (sourced-statement protection):** Do not modify quoted material. Do not modify sourced numbers or citation tags. If a term first appears inside a quote and its surrounding prose context is all sourced, gloss the next bare body-prose occurrence instead.

If bright-line flags are populated, the calling agent pauses for operator decision before finalizing the output.

---

## Output

### Write Output

Write the glossed prose to the output path supplied by the calling agent. When the caller passes the same path as the input, the glossed prose overwrites the input file — this is the common pattern inside the `produce-prose-draft` pipeline, where the calling command owns the file-versioning contract. When invoked standalone (e.g., via `/produce-jargon-gloss`), the caller specifies the output path; default to overwrite of the input prose file unless the caller passes a different output path.

### Sidecar Log: `gloss-additions-log.md`

Write the change log to the path supplied by the calling agent, typically `{prose_output_dir}/gloss-additions-log.md`.

**Log format:**

```markdown
# Jargon Gloss — Change Log

**Source file:** {path}
**Source word count:** {n}
**Output word count:** {n}
**Terms glossed:** {n}
**Idempotent skips (already-defined terms):** {n}
**Sentence splits:** {n}
**Bright-line flags:** {n}

---

## Glosses Applied

| # | Term | First-mention location | Gloss inserted | Sentence split? |
|---|---|---|---|---|
| 1 | AIFMD II | §2, paragraph 3, sentence 1 | (the EU's revised alternative investment fund manager directive) | no |
| 2 | CSRD | §2, paragraph 3, sentence 1 | (the EU's corporate sustainability reporting directive) | no |
| 3 | FDI screening | §2, paragraph 3, sentence 1 | (national review of foreign acquisitions on security grounds) | yes |

## Idempotent Skips (pre-existing gloss preserved)

| # | Term | Location | Pre-existing form |
|---|---|---|---|
| 1 | EIF | §1, paragraph 1, sentence 2 | "the European Investment Fund (EIF)" — source-introduced |

## Bright-Line Flags (terms NOT glossed, requires operator decision)

| # | Term | Location | Reason | Recommendation |
|---|---|---|---|---|
| 1 | {term} | {location} | {reason — analytical-claim protection or sourced-statement protection} | {operator action: keep bare / gloss-with-rewrite / other} |

## Whitelist Hits (terms NOT glossed because whitelisted — sample)

(Listing optional; populate only if it aids audit. Truncate to first 20 if long.)
```

The log is flat enumeration — no severity tiering. Every glossed term is logged with the exact wording inserted, so the operator can scan and reject any over-reaches by editing the prose file directly.

---

## Constraints

- Do not change argument structure, the sequence of sections, or analytical conclusions.
- Do not change voice, rhythm, or sentence-level prose style outside the specific gloss insertion and the permitted sentence-split rule.
- Do not gloss whitelisted PE/finance vocabulary.
- Do not gloss terms that already have a definition in the source prose on first mention.
- Do not gloss the same term more than once per document.
- Do not modify quoted material or footnote text.
- Do not introduce recursive jargon — every gloss must use plain language; if a gloss would itself require glossing, restructure the gloss to use simpler terms.
- Preserve all footnotes, citations, formatting, and section structure exactly.
- Every change must be traceable to a single entry in the change log.

---

## Runtime Recommendations

- **Invocation:** Expected to be invoked by a pipeline command (`produce-prose-draft` Phase 4) or by the standalone wrapper command (`/produce-jargon-gloss`). Not auto-invoked on file writes.
- **Tools:** Requires Read and Write (or Edit) against the prose file and the change-log path. Tool-agnostic beyond this.
- **Paths:** No `paths` frontmatter restriction. The prose file path is supplied per invocation and varies by project.
- **Model:** The skill declares `model: opus` as its native tier. Calling commands may override to Sonnet for pattern-based execution (detection and rewriting against an explicit whitelist + category list is pattern work, not deep analytical judgment). The `produce-prose-draft` pipeline applies the Sonnet override at the command layer, mirroring the existing Phase 3 (decontamination) override pattern.
- **Context budget:** Plan for the full prose file + this SKILL.md + style reference (if provided) in context simultaneously. For long prose files (15k+ words), a single pass is fine — the pass operates linearly and does not require cross-section rhythm judgment.
- **Execution pattern:** Runs cleanly as a subagent delegated by a pipeline command. Also runs standalone in the main thread. Either pattern is supported.
- **Sequencing within a pipeline:** Runs after `ai-prose-decontamination` and before formatting. Decontamination's rhythm and voice cleanup are intact; the gloss pass adds first-mention parentheticals without disturbing them.

---

## Validation

After completing a gloss pass:

- [ ] Every term in the change log appears exactly once as a gloss in the output prose.
- [ ] No whitelisted term has been glossed.
- [ ] No source-prose pre-existing gloss has been duplicated or modified.
- [ ] No analytical claim, sourced statement, or quoted material has been modified.
- [ ] All sentence splits are logged.
- [ ] All bright-line flags are logged with reasoning and recommendation.
- [ ] Output word count is approximately equal to input word count plus the sum of inserted gloss lengths, modulo conjunction or punctuation deletions implicit in any logged sentence splits (the pass is additive at the term level; the only permitted reductions are those that follow from the logged splits).
- [ ] If no style reference was provided, the change log header notes this.
