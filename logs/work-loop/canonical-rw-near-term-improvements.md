---
task: canonical-rw-near-term-improvements
status: closed
turn: operator
---

## Outcome

Slice S1 of the operator-approved near-term plan is complete. The canonical Research Workflow's W4-H1–H4 content relays were refactored to path-passing or path-plus-capped-summary, with intentional context isolation and analytical meaning preserved, and the plan's deterministic and representative proof targets were met.

All 40 named W4-H1–H4 seams are accounted for: 27 were converted and 13 were retained as explicit justified exemptions. No violation, cap, ambiguous or unresolved seam remains. Measured relay payload fell 99.824469%, against the plan's 80% target, and the deterministic checker reported `TARGET MET`. The corrected representative Part A scorer passed A0–A8 on the untouched post-S1 arm. One fresh context-isolated evaluator, briefed only on rubric Part B and its twelve permitted artifacts, returned `PRESERVED` on all eight Part-B judgments and on the overall verdict.

## Decisions that matter

- **Route A used synthetic local inputs** and a frozen response only at the external send seam, so the representative regression exercised the relay without live external calls.
- **The historical arm's expected A1 failure was retained rather than backfilled.** The pre-S1 arm has no handoff-summary artifact because the agent returned the body; that absence is the correct historical fact, not a gap to fill.
- **The representative scorer was aligned to the live field-substance contract** without inventing fixed surface syntax. It normalizes contract-permitted decoration and judges substance only; normalization never supplies an absent field.
- **Semantic comparison was bounded at the verification relay**, because the pre-existing missing Evidence Pack made downstream correction outputs causally incomparable between the two arms. That is a causal boundary, not a verdict on the correction stage.

Deferrals recorded at closure, with their reasons:

- **The missing Evidence Pack and verification-report relay at `/verify-chapter` Step 3.7a remain outside S1.** `evidence-prose-fixer` declares the Evidence Pack a blocking required input and Step 3a does not pass it. This is a live, separately recorded defect; S1 did not introduce it and does not fix it.
- **Non-blocking adjacent improvements, all outside S1's boundary:** stale `reference/stage-instructions.md` writer-return wording; writer Reviewer Findings footer sequencing; README `Blast radius`; optional verification-summary truncation naming; baseline GF1-C01 date capture; optional future pinning of execution-agent summary surface syntax; and adding `reference/quality-standards.md` to Part B's evaluator input set. The last item does not undermine this verdict, because the allowed chapter and verification report directly settled judgment 6.

## Evidence

Final evidence commits: `5035a379ff82d46c2da04cb512738b43c88f9d42` (Unit 21 — fresh independent Part-B semantic evaluation, verdict `PRESERVED` on all eight judgments and overall) and `2b9770facad4f19f1041f907962f7e1db278f956` (Unit 20 — representative Part A scorer aligned to the live S1 relay contract, harness 38/38).

Supporting accepted units: Unit 19 at `c227411505b51c93ac7fa5e7cf7d717dda58debc` (attended current-HEAD `/verify-chapter` run); Unit 18 at `5d439aa0726dfedd4a9fe6ddf7103806207af366` (attended pre-S1 baseline run); Unit 17 at `ac522ac2b4c61af0b5a3eedd2e555ddadeb8d65f` (representative proof substrate); Unit 16 at `83d26431c52eab2f10c276a01985d74302afaaf9`.

Deterministic proof: 40/40 seams accounted for, 27 converted and 13 justified, 0 violations/cap/ambiguous/unresolved, 99.824469% payload reduction, checker `TARGET MET`, relay harness 26/26 and representative scorer harness 38/38.

## Accepted limitations

- The representative semantic proof establishes the **S1 verification relay boundary**, not the downstream correction stage affected by the missing Evidence Pack. Excluding the post-correction artifacts says nothing about whether that stage is sound; it has not been tested and has not passed.
- The frozen-response harness exposed **no token counts**, so payload reduction is measured in bytes at the relay rather than in model tokens.
- The handoff summary's **surface syntax remains flexible** even though its required substance and hard 20-line / 4 KB cap are enforced.

None of these prevents S1's approved outcome from being useful and verified.
