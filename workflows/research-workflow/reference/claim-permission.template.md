# Claim-Permission Configuration — {{PROJECT_TITLE}}

> **Purpose.** Project-fillable per-claim-type tables consumed by `cluster-memo-refiner` Check 9, the Pass 3 gate-clearance emitter, and `evidence-to-report-writer` at synthesis time. The project copies this template to `reference/claim-permission.md` and fills the rows for its own domain.
>
> **Canonical-ordering rule (must not be violated without `/risk-check` re-fire).** The companion chassis at `reference/quality-standards.md § Claim-Permission Classes` is the source of truth for **class names** (SUPPORTED / PROXY-SUPPORTED / ILLUSTRATIVE-ONLY / NOT-SUPPORTED), the **permitted-prose-verb lists**, and the **gate semantics** (blocking-gate threshold rule, gate-clearance artifact schema). This file is the source of truth for the **per-claim-type evidence thresholds** ONLY. Edits that cross this boundary in either direction require `/risk-check` re-fire.
>
> **Consumed by:**
> - `cluster-memo-refiner` Check 9 (Permission-Class Emission) — reads the Minimum Evidence Thresholds and Source-Diversity Matrix rows to classify each claim.
> - `evidence-to-report-writer` — checks that prose-side claims match the permitted permission class for their evidence-channel set.
> - Pass 3 gate-clearance emitter — rolls up per-claim-type SUPPORTED/NOT-SUPPORTED counts into cluster + section verdicts.

---

## Minimum Evidence Thresholds

> **Rule shape** (canonical — see `reference/quality-standards.md § Claim-Permission Classes`). Claims meeting the threshold reach SUPPORTED. Below threshold, claims downgrade to PROXY-SUPPORTED at best; without proxy evidence, ILLUSTRATIVE-ONLY or NOT-SUPPORTED.

Project fills 5–8 rows. Each row names a project-relevant claim type and the minimum evidence that promotes such a claim to SUPPORTED.

| Claim type | Minimum evidence before SUPPORTED |
|---|---|
| {{CLAIM_TYPE_1}} | {{MINIMUM_EVIDENCE_1}} |
| {{CLAIM_TYPE_2}} | {{MINIMUM_EVIDENCE_2}} |
| {{CLAIM_TYPE_3}} | {{MINIMUM_EVIDENCE_3}} |
| ... | ... |

**Authoring guidance.** Express thresholds in observable, countable terms (e.g., "country-level aggregate data OR ≥5 named transactions across at least 2 countries"). Avoid vague qualifiers ("substantial," "robust") — `cluster-memo-refiner` Check 9 needs binary PASS/FAIL evaluation against the threshold.

---

## Source-Diversity Matrix

> **Rule shape** (canonical — see `reference/quality-standards.md § Claim-Permission Classes`). A claim that does not meet the required evidence-channel set cannot be classed SUPPORTED. It may be PROXY-SUPPORTED if some channels are met with proxies; otherwise ILLUSTRATIVE-ONLY or NOT-SUPPORTED.

> **Triangulation-packets rule** (canonical). The matrix is not "find N sources" — it is "find N source-types playing different evidentiary roles." N independent reports from the same source class count as ONE evidentiary role, not N.

Project fills one row per claim type from the Minimum Evidence Thresholds table above, naming the required evidence-channel set (3 different evidentiary roles per claim is a typical floor).

| Claim type | Required evidence channels |
|---|---|
| {{CLAIM_TYPE_1}} | {{CHANNEL_SET_1}} |
| {{CLAIM_TYPE_2}} | {{CHANNEL_SET_2}} |
| {{CLAIM_TYPE_3}} | {{CHANNEL_SET_3}} |
| ... | ... |

**Authoring guidance.** Each channel must be a distinct evidentiary role (e.g., "aggregate data," "named transactions," "GP/platform disclosure," "regulator publication," "central-bank survey"). Three instances of the same role do not satisfy a three-channel requirement.

---

## R1-Defect Fold-Ins

> **Rule shape** (canonical — see `reference/quality-standards.md § Claim-Permission Classes`). First-pass-critique defects become normative permission sub-rules: when a defect pattern is detected, the affected claim auto-downgrades or auto-`NOT-SUPPORTED` per the project's fold-in row.

Project fills 4–8 rows derived from its first-pass (R1) critique surface. Each row maps a defect pattern to a permission rule that `cluster-memo-refiner` Check 9 enforces.

| R1 defect | Permission rule |
|---|---|
| {{DEFECT_PATTERN_1}} | {{PERMISSION_RULE_1}} |
| {{DEFECT_PATTERN_2}} | {{PERMISSION_RULE_2}} |
| {{DEFECT_PATTERN_3}} | {{PERMISSION_RULE_3}} |
| ... | ... |

**Authoring guidance.** Each rule must specify the downgrade target explicitly (NOT-SUPPORTED / PROXY-SUPPORTED / ILLUSTRATIVE-ONLY). Vague guidance ("downgrade as appropriate") fails the binary-evaluation requirement. Rules should be expressible as "if [pattern detected] then [permission class]."

---

## How Consumers Read This File

1. **`cluster-memo-refiner` Check 9** reads `Minimum Evidence Thresholds` to compute a per-claim threshold-match verdict, reads `Source-Diversity Matrix` to compute a per-claim channel-set-match verdict, and reads `R1-Defect Fold-Ins` to apply any defect-triggered auto-downgrades. The three verdicts combine into the per-claim permission class.
2. **`evidence-to-report-writer`** cross-references prose-side claims against the permission class assigned at Check 9 — verb-list compliance per the chassis (`quality-standards.md § Claim-Permission Classes`).
3. **Pass 3 gate-clearance emitter** rolls up per-claim permission classes into cluster-level and section-level verdicts using the gate thresholds declared in `quality-standards.md § Blocking-Gate Semantics` (`{{CLUSTER_BLOCK_THRESHOLD}}` / `{{SECTION_BLOCK_THRESHOLD}}`).
