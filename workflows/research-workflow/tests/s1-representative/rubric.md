# Representative regression rubric — S1

Two separate judgments run over the same pair of chapter runs, and they must not be confused.

**Part A** is mechanical. `score-specimen.sh` decides it, the same way every time, and a human
adds nothing to it.

**Part B** is not mechanical and is deliberately kept out of the scorer. A fresh evaluator who
did not build S1 reads both runs' chapters and decides whether analytical meaning survived.

The division exists because the two failure modes are different. Part A catches a relay that
dropped a path, an ID or a structure — the thing S1 actually changed. Part B catches a relay
that carried every field and still degraded the analysis.

---

## Part A — deterministic schema and identity (the scorer decides)

`score-specimen.sh --specimen DIR` runs these eight checks and returns `verdict: PASS` (exit 0)
or `verdict: FAIL` (exit 1). Every check is stated so that a specimen can fail it.

| ID | Check | Fails when |
|---|---|---|
| A1 | **Required artifacts present.** Every role in `expected/required-artifacts.txt` exists in the specimen, is a regular file, and is non-empty. | An artifact is missing, empty, or the manifest names a role the scorer does not know. |
| A2 | **Verbatim report fidelity.** The specimen's `verification-report` is byte-identical to `corpus/frozen-verification-response.md`. | The run altered, truncated, paraphrased or re-wrapped the stored response. `execution-agent.md` requires the complete response written verbatim to the caller-specified file. |
| A3 | **Path passing.** The `verification-summary` and the `verification-checkpoint` each state an `Output file path:` whose value is a non-empty path ending in the report artifact's filename, and the two agree. | The path was dropped, left blank, or the checkpoint and summary name different files. This is the seam S1 converted: the caller records the path, never the body. |
| A4 | **Claim-ID set identity.** The set of claim IDs appearing in the specimen `chapter` equals `expected/claim-ids.txt` exactly. | An expected ID was dropped, or an ID not in the expected set appears (invented). Both are reported by ID. |
| A5 | **Verdict structure.** The report states exactly one `Verdict:` line. If its value is `APPROVED`, the report carries zero discrepancy blocks; otherwise it carries at least one. The summary and the checkpoint each state a verdict, and both quote the report's verdict exactly. | The verdict is absent, stated more than once, contradicts the discrepancy count, or the summary/checkpoint verdict diverges from the report's. |
| A6 | **Discrepancy structure.** Every `## Discrepancy N` block in the report carries all four fields the fact-verification SOP requires — `Claim`, `Claim ID`, `Issue type`, `Recommended correction` — each non-empty; the `Issue type` is one of `Unsupported`, `Contradicted`, `Overstated`, `Category-leakage`, `Undated`; and every discrepancy `Claim ID` is in the expected set. | A field is missing or blank, the issue type is outside the SOP's closed set, or a discrepancy cites an ID the chapter does not carry. |
| A7 | **Discrepancy accounting.** The report's stated `Discrepancy count`, the number of discrepancy blocks, the summary's stated count, the number of per-discrepancy lines in the summary, and the checkpoint's stated count all agree; and the `(Claim ID, Issue type)` pairs listed in the summary match the report's blocks as a set. | Any of those five numbers disagrees, or the summary lists a pair the report does not contain. |
| A8 | **Summary cap.** The `verification-summary` is at most 20 lines and at most 4096 bytes. | Either bound is exceeded. `execution-agent.md`: "The cap is hard and always wins: 20 lines and 4 KB, measured on the whole summary." |

A separate invocation, `score-specimen.sh --check-baseline`, validates
`expected/baseline-revision.txt`: exactly one `revision:` line holding a 40-hex SHA, at least one
`derivation:` line, and — when git is available and the file sits inside a work tree — that the
SHA resolves to a commit. This is what makes the pre-S1 boundary a recorded fact rather than a
run-time recollection.

### What Part A deliberately does not check

- **Prose wording.** A1–A8 never compare chapter or report prose beyond the claim-ID set. A2's
  byte comparison is on the *frozen* response, which is an input, not model output.
- **Analytical quality.** Whether the flagged discrepancies are the right ones is Part B.
- **Payload bytes.** The deterministic 80% reduction target is already proved by
  `tests/s1-relay/check-relay-payload.sh` and is not re-litigated here.

---

## Part B — preserved analytical meaning (a fresh evaluator decides)

The evaluator is briefed with both runs' chapters and verification reports, the two extracts and
the gap-fill extract, and this section. They are **not** briefed with the S1 diff, the plan, or
this task's state file — the question is whether the output still says the same thing, not
whether the refactor looks reasonable.

**Byte identity of AI prose is not a criterion, and must not be treated as one.** The two runs
invoke the same model on the same inputs at different revisions; wording will differ, and
identical wording would be evidence of nothing. An evaluator who reports "the paragraphs differ"
has not answered the question.

The evaluator answers each of these with PRESERVED / DEGRADED / UNCLEAR and one sentence of
reasoning naming the sentence or artifact they relied on:

1. **Findings.** Does each run state the same substantive findings, whatever the wording? A
   finding present in one run and absent from the other is a degradation regardless of length.
2. **Attribution.** Is each claim still tied to the same claim ID and the same source, and does
   each ID still support the sentence it is attached to?
3. **Evidence/interpretation separation.** Does each run keep sourced findings distinguishable
   from inference, per `reference/quality-standards.md`?
4. **Hedging and scope.** Are the qualifications intact — the thin pricing base, the
   self-selected panel, the market-level scope of the adviser concentration? Confidence that
   rose without new evidence is a degradation.
5. **Scarcity handling.** Does each run still state the fee-disclosure gap as a fact about the
   search rather than converting it into a negative finding about the world?
6. **Verification agreement.** Do the two runs' verification reports flag substantively the same
   problems? A discrepancy raised in one and not the other is a finding to report, not noise to
   average out.

The evaluation ends with one overall verdict — **PRESERVED**, **DEGRADED**, or **UNCLEAR** — and,
where anything is not PRESERVED, the specific artifact and sentence. UNCLEAR is a legitimate
outcome and is reported as itself; it is not rounded to PRESERVED.
