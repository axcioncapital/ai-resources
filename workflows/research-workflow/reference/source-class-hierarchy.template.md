# Source-Class Hierarchy — {{PROJECT_TITLE}}

> **Purpose.** Declares the best-available source class per evidence type, the source-exhaustion ladder when best-class evidence is unavailable, named-source paths for semi-structured discovery, and the project country set consumed by downstream sub-agents.
>
> **Authority.** Project-level reference. Consumed by:
> - `research-prompt-creator` skill (Stage 2) — every prompt names its target source class and orders fallbacks.
> - `research-extract-creator` skill (Stage 2) — ladder-depth logging requirement (the depth field).
> - `country-parity-checker` skill / `/run-sufficiency` Phase C — reads `## Project Country Set` below.
> - Operators — reference when judging evidence quality.
>
> **Source-availability posture.** {{SOURCE_AVAILABILITY_POSTURE}}
> <!-- One of: "Public sources only — no paid databases." | "Mixed sources — public + named licensed databases (e.g., Mergermarket, S&P Capital IQ)." | "Paid databases allowed — declare which ones." -->

---

## Source Class Hierarchy by Evidence Need

| Evidence need | Best source class | Fallback class |
|---|---|---|
| {{EVIDENCE_NEED_1}} | {{BEST_CLASS_1}} | {{FALLBACK_CLASS_1}} |
| {{EVIDENCE_NEED_2}} | {{BEST_CLASS_2}} | {{FALLBACK_CLASS_2}} |
| ... | ... | ... |

**Project fills.** One row per evidence type covered by the project's research questions. Best source class = the highest-quality source class typically available (e.g., regulator/trade-body data, primary disclosures); fallback class = the next-best class when best-class evidence is unavailable (e.g., advisory aggregates, press coverage).

---

## Source-Exhaustion Ladders

When best-class evidence is not found, descend the ladder one step at a time. Record the deepest level reached (the ladder-depth logging requirement, below).

**Project fills.** One ladder per evidence type that needs ladder-depth logging. Common ladders: transactions, regulation, fund data, financing conditions. Each ladder runs from highest-class primary source (step 1) to lowest-class secondary mention (step N). Below is a worked template; add one block per ladder.

### {{LADDER_NAME}} Ladder ({{N}} steps)

1. {{LADDER_STEP_1}}  <!-- highest-class primary source -->
2. {{LADDER_STEP_2}}
3. ...
N. {{LADDER_STEP_N}}  <!-- lowest-class secondary mention -->

---

## Ladder-Depth Logging Requirement

Each research extract claim records the source class actually used AND the ladder depth (e.g., `transactions ladder, step 4`).

**Automatic claim-strength downgrade thresholds.** Claims sourced from deep ladder steps cannot reach SUPPORTED — they auto-downgrade per `reference/quality-standards.md § Claim-Permission Classes`. The threshold rule is canonical (deep-ladder claims cannot be cited with level-1 confidence); the specific step-number threshold per ladder is project-conditional.

| Ladder | Auto-downgrade threshold (project fills) |
|---|---|
| {{LADDER_NAME}} | step {{N+}} or deeper |
| ... | ... |

`cluster-memo-refiner` Check 9 emits the downgrade automatically at refinement time.

---

## Named-Source Appendix

Specific named sources to mine for evidence beyond the broad ladder categories above. Project fills with authoritative source names per category. Typical categories include primary actor websites, news/PR wires, regulator filings, legal/financial-adviser deal lists, official registries.

### {{CATEGORY_1}}

{{NAMED_SOURCES_1}}

### {{CATEGORY_2}}

{{NAMED_SOURCES_2}}

### ...

(Project fills 4–10 category blocks depending on evidence-need diversity.)

---

## Project Country Set

> **Schema reference.** This section is consumed by the `country-parity-checker` sub-agent (`/run-sufficiency` Phase C). The exact field shape (line names, ordering, defaults) is fixed by the skill's `## Project country set schema` block — do NOT reorder fields or rename keys without updating both sides in lockstep. See `ai-resources/skills/country-parity-checker/SKILL.md` for the consumer.

- target: {{COUNTRY_SET}}                   # countries in scope for this project
- region: {{REGION_NAME}}                   # region superset name (used in pan-region leakage verdicts)
- region_superset: {{REGION_SUPERSET}}      # full membership of the region superset
- thinness_threshold: 0.15                  # share-of-evidence floor below which a country is THIN (default 0.15)
- dominance_threshold: 0.60                 # share-of-evidence ceiling above which a country is DOMINANT (default 0.60)

**Threshold defaults.** `thinness_threshold` and `dominance_threshold` are tunable; the defaults above are starting values. Tune after the first production run if false-flag rates warrant.

**Single-country projects.** Set `target` to a single country and omit `region` / `region_superset` lines (or set `region_superset` equal to `target`).

**Superset rationale.** When the region superset omits members of the geographic region (for example, when a member is excluded on activity-volume or scope grounds), document the omission rationale here. Adding a member later requires only an edit to this section; no downstream code change.

---

## Inert-Fields Ledger

Track fields that landed in this file before their consumers were active. As consumers come online, mark each field active and record the activating bundle/skill/date.

| Field | Status | Activated by |
|---|---|---|
| (project fills as fields land and consumers activate) | inert / active | (bundle ID / skill name / date) |

---

## Project-Side Drift Note

Document any divergence from the canonical workflow template here. Common entries: pinned to a pre-bundle shape, deliberate fork on a named file, or "No drift" for projects deployed fresh from the canonical template.
