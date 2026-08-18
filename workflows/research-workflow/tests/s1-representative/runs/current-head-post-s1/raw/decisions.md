# Decisions Log

## 2026-08-18 — Section 1.1, Chapter 01 — `/verify-chapter` Step 3e correction decisions

**Zero corrections were proposed, so zero were applied.** Step 3a halted on a missing blocking
input rather than returning a correction list. The Step 3c pause still fired — Step 3 is entered
because the verification report found discrepancies, not because corrections exist — and the
packet presented to the operator was empty in both groups. The operator replied `approved` on
2026-08-18, accepting the packet as it stood: apply nothing, let the run complete as produced.

| # | Claim ID | Issue type | Triggers fired | Decision |
|---|---|---|---|---|
| — | Q1-C02 | Overstated | none — no correction reached the bright-line check | DEFERRED at Step 3a — evidence basis unverifiable |
| — | Q1-C04 | Category-leakage | none — no correction reached the bright-line check | DEFERRED at Step 3a — evidence basis unverifiable |
| — | GF1-C01 | Undated | none — no correction reached the bright-line check | DEFERRED at Step 3a — date-capture branch is a human item regardless |

Bright-line triggers, per `reference/quality-standards.md`: (1) multi-paragraph scope,
(2) analytical claim alteration, (3) sourced-statement or claim-ID-attributed modification. **None
fired, because no correction was presented.** Step 3b's correct record here is "no items
presented", not "items passed" — the two are different states and must not be collapsed.

## Why Step 3a halted

`evidence-prose-fixer` declares three blocking required inputs: the verification report, the
chapter draft, and the **Evidence Pack**. The `/verify-chapter` Step 3a caller contract at this
revision passes the skill, the verification report and the chapter path — and no Evidence Pack.
The fixer read both supplied inputs in full (the chapter arrived **as a path** and resolved
correctly), then applied the skill's own rule for Input 3 — "If missing: Do not proceed" and "Do
not guess at corrections without evidence access" — and produced no corrections.

It did not infer the absence from the caller contract alone. It inspected the run tree and
confirmed `analysis/chapters/`, `analysis/cluster-memos/`, `analysis/gap-assessment/` and
`analysis/section-directives/` hold only `.gitkeep`, and that the sole analysis-side artifact
present is the GF1 gap-fill extract — not the Q1/Q2 evidence tables the flagged claims rest on.

Its reasoning for refusing, recorded because it is the substance of the finding: the fix strategy
for Q1-C02 turns on whether the aggregate value series excludes the seven undisclosed-price
transactions, which only the evidence table settles and which changes which remedy is correct;
the fix strategy for Q1-C04 requires the row's Scope Fit field and a scan for any manager-level
row; and the hedge branch for GF1-C01 is grade-matched, so it needs the extract's grade field.
Corrections written without those "look clean and may be wrong."

## What was deliberately not done

The run did **not** re-issue Step 3a with the Evidence Pack attached. Supplying an input the
caller contract does not pass would change non-send behaviour and repair the workflow mid-run.
The invocation's substitution is confined to the external send seam; every other behaviour is the
contract under test, and a run that quietly fixes the contract it is measuring is not evidence.

This corroborates the task's carried Evidence-Pack deferral from a second, independent direction:
the pre-S1 baseline arm recorded the same gap while still returning corrections, and this arm
refused outright. The gap is in the caller contract, not in the S1 relay conversion — the chapter
path relay, which is what S1 changed at this seam, resolved and was read in full.

Not fixed here; out of this unit's scope.
