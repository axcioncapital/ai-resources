# Decisions Log

## 2026-08-18 — Section 1.1, Chapter 01 — `/verify-chapter` Step 3e correction decisions

Three corrections proposed by `evidence-prose-fixer` against the fact-verification report at
`report/chapters/1.1/1.1-chapter-01-verification.md`. All three tripped at least one bright-line
trigger, so none was eligible for automatic application; all were presented at the Step 3c pause
and the operator replied `approved`.

| # | Claim ID | Issue type | Triggers fired | Decision |
|---|---|---|---|---|
| 1 | Q1-C02 | Overstated | (2) alters an analytical claim; (3) modifies claim-ID-attributed content | APPLIED — operator approved |
| 2 | Q1-C04 | Category-leakage | (2) alters an analytical claim; (3) modifies claim-ID-attributed content | APPLIED — operator approved |
| 3 | GF1-C01 | Undated | (3) modifies claim-ID-attributed content | APPLIED — operator approved |

Bright-line triggers, per `reference/quality-standards.md`: (1) multi-paragraph scope,
(2) analytical claim alteration, (3) sourced-statement or claim-ID-attributed modification.
Trigger (1) fired on none of the three — each edit stayed inside one paragraph.

Detail:

- **Fix 1 (Q1-C02, Overstated).** Deleted the trailing clause "so average deal size roughly grew
  alongside deal count rather than in place of it" from § 1.1. The evidence table carries the count
  and value series separately, states no average-deal-size series, and the aggregate excludes the
  seven 2024 transactions with no disclosed price. The fixer chose the verifier's *drop* branch over
  its *move to § 1.2* branch, because relocating would span two sections and would still rest on a
  series the evidence does not contain.
- **Fix 2 (Q1-C04, Category-leakage).** Replaced "which is why every manager in this segment runs a
  materially similar continuation-vehicle process" with an explicit market-versus-manager scope
  boundary. Q1-C04 is recorded at Scope Fit "Adjacent — market-level, not manager-level". Narrowed
  rather than removed, per the permission-ceiling rule. No manager-level attribution was substituted
  because the chapter holds no manager-level evidence row.
- **Fix 3 (GF1-C01, Undated).** Added a currency caveat stating that the gap-fill extract records no
  publication or revision date. Nothing was withdrawn. The verifier's alternative *capture the date*
  branch is a research action, not a prose fix, and was routed as an operator branch rather than
  applied — if the date is later captured, Fix 3's second sentence is replaced rather than layered on.

Deferred, not acted on: the Step 3a caller contract at this revision passes the skill, the
verification report and the chapter prose, but not the Evidence Pack that `evidence-prose-fixer`
declares a blocking required input. Corrections were therefore generated against the verifier's
characterisation of the evidence rather than the evidence rows. Recorded as a finding about the
historical contract; out of scope for this run.
