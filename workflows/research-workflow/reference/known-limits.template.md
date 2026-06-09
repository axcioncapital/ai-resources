# Known Limits — {{PROJECT_TITLE}}

> **Purpose.** Catalogues {{DOMAIN}}-specific public-data gaps and structurally damaging evidence absences so the workflow does not waste cycles attempting closure and so downstream claims affected by these gaps are downgraded automatically.
>
> **Authority.** Project-level reference. Loaded by:
> - `task-plan-creator` skill (Stage 1) — when scoping research questions, mark questions that depend on closing one of these limits.
> - `cluster-analysis-pass` skill (Stage 3) — when scoring cluster evidence, apply the documented downgrade.
> - `research-extract-creator` skill (Stage 2) — when tagging extract freshness and source class.
> - `cluster-memo-refiner` Check 9 (Permission-Class Emission) — claims dependent on closing one of these limits auto-downgrade to `PROXY-SUPPORTED` or `NOT-SUPPORTED` unless they invoke the source-class hierarchy ladder or a documented domain-specific workaround.
>
> **Companion file:** `reference/source-class-hierarchy.md` — declares the best-available source class per evidence type and the source-exhaustion ladder.

---

## Known {{DOMAIN}} Public-Data Limitations

Structural limits — persistent, not freshness-dependent. Project fills 1–10 items.

1. **{{LIMIT_HEADLINE_1}}.** {{LIMIT_DESCRIPTION_1}}
2. **{{LIMIT_HEADLINE_2}}.** {{LIMIT_DESCRIPTION_2}}
3. **(project fills additional items here)**

Number items continuously from 1; the "Most Damaging Evidence Gaps" section below continues the same numbering.

---

## Most Damaging Evidence Gaps

Evidence gaps surfaced by first-pass critique or upstream analysis. These gaps are not closable from public sources alone; they are identified here so the workflow does not waste cycles attempting closure and so downstream claims affected by these gaps are downgraded automatically.

N+1. **{{GAP_HEADLINE_1}}.** {{GAP_DESCRIPTION_1}}
N+2. **{{GAP_HEADLINE_2}}.** {{GAP_DESCRIPTION_2}}
N+3. **(project fills additional items here)**

(Project fills 5–15 items depending on first-pass critique surface.)

---

## Known-Unavailable-Evidence Register (optional)

> **Purpose.** The actionable distillation of the limits and gaps above into a stable schema, so the workflow **stops re-paying search cost for the same confirmed non-answer.** When an evidence need matches a register row whose `Last-checked` date is recent (within the project's `{{CURRENT_PERIOD}}`), the executor records the row's non-answer + public proxy instead of opening a fresh deep search.
>
> **Schema (stable — do not reorder columns; consumers may parse by header).**
>
> - **Evidence need** — the specific fact or series the question wants.
> - **Why unavailable** — the structural reason it is not public (paywall, non-disclosure, not-a-reporting-unit, vintage-immaturity, out-of-scope-primary).
> - **Public proxy (if any)** — the best-available public substitute and its known bias; `(none)` if there is no usable proxy.
> - **Limit ref** — the prose limit number(s) above this row distils.
> - **Last-checked** — the date the non-availability was last confirmed. Refresh on re-confirmation; a stale date (older than the `{{CURRENT_PERIOD}}` window) re-licenses a search.
>
> **Stop rule.** A register hit does **not** by itself set a claim's permission class — that stays with `cluster-memo-refiner` Check 9. The register governs *search effort* (skip the re-search, record the non-answer), not *claim grading*.

| Evidence need | Why unavailable | Public proxy (if any) | Limit ref | Last-checked |
|---|---|---|---|---|
| {{EVIDENCE_NEED}} | {{WHY_UNAVAILABLE}} | {{PUBLIC_PROXY_OR_NONE}} | {{LIMIT_REF}} | {{LAST_CHECKED_DATE}} |

Project removes this section if not applicable, or fills the register with one row per confirmed-unavailable evidence need.

---

## How to Use This List

- **Stage 1 (`task-plan-creator`).** When defining research questions, mark questions that depend on closing one of these limits. Such questions are scoped to deliver "best-available evidence + acknowledged gap" rather than "comprehensive answer."
- **Stage 2 (`research-extract-creator`).** When tagging extracts, the freshness classes interact with this list: structural limits are persistent (not freshness-dependent); gap items are not closed by newer evidence either, but freshness still applies to claims that ARE supported.
- **Stage 3 (`cluster-analysis-pass`).** Cluster memos must explicitly cite which limits they touch. Claims that rely on closing a limit must downgrade or invoke a workaround (source-class ladder or a domain-specific recovery routine).
- **Pass 3 (`cluster-memo-refiner` Check 9).** Auto-downgrade rule fires: claims dependent on closing a limit auto-downgrade to `PROXY-SUPPORTED` or `NOT-SUPPORTED` unless a workaround is invoked. Downgrade is automatic at refinement time per `reference/quality-standards.md § Claim-Permission Classes`.

---

## Freshness Classes

The freshness-class formula classifies evidence by recency relative to the project's current period. Project fills date ranges based on `{{CURRENT_PERIOD}}`.

| Class | Period | Permitted use |
|---|---|---|
| `CURRENT` | {{CURRENT_PERIOD}} | Current-state claims |
| `RECENT` | {{RECENT_PERIOD}} <!-- typically {{CURRENT_PERIOD}} minus 1–2 years --> | Recent-trend claims |
| `BASELINE` | {{BASELINE_PERIOD}} <!-- typically {{CURRENT_PERIOD}} minus 3–5 years --> | Baseline or pre/post comparison only |
| `STRUCTURAL` | {{STRUCTURAL_PERIOD}} <!-- typically pre-{{CURRENT_PERIOD}} minus 6 years --> | Structural background only |

**Claim-level rule.** Claims attempting to support current-state from BASELINE or STRUCTURAL evidence are flagged for downgrade. The downgrade itself is applied by `cluster-memo-refiner` Check 9 per `reference/quality-standards.md § Claim-Permission Classes` (consumes the `[FRESHNESS-MISMATCH]` tag from `research-extract-creator`).

---

## Inert-Fields Ledger

Track fields that landed in this file before their consumers were active. As consumers come online, mark each field active and record the activating bundle/skill/date.

| Field | Status | Activated by |
|---|---|---|
| (project fills as fields land and consumers activate) | inert / active | (bundle ID / skill name / date) |

---

## Asymmetric Blocking-Semantics Gap (optional)

Document any known gap between gate-clearance fail-safes and downstream consumer behavior. Common pattern: a fail-safe checks the presence of one file (e.g., gate-clearance) but a consumer also depends on a second file (e.g., per-cluster permission tables). Absence of the second file leads to silent empty reads rather than refuse-to-run.

Project removes this section if not applicable, or documents the gap and the operator action required to verify before invoking the affected command.

---

## Project-Side Drift Note (optional)

Document any divergence from the canonical workflow template here. Common entries: pinned to a pre-bundle shape, deliberate fork on a named file, or "No drift" for projects deployed fresh from the canonical template.
