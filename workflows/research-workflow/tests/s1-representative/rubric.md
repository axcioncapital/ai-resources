# Representative regression rubric — S1

Two separate judgments run over the same pair of chapter runs, and they must not be confused.

**Part A** is mechanical. `score-specimen.sh` decides it, the same way every time, and a human
adds nothing to it.

**Part B** is not mechanical and is deliberately kept out of the scorer. A fresh evaluator who
did not build S1 reads the two arms' artifacts at the relay boundary and decides whether
analytical meaning survived.

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
| A3 | **Path passing.** The `verification-summary` and the `verification-checkpoint` each state an `Output file path:` whose value is a non-empty path ending in the report artifact's filename, and the two agree. The value is reduced to the path itself first: a Markdown code span around it, and a trailing explanatory parenthetical after it, are contract-permitted decoration and are stripped before comparison. | The path was dropped, left blank, decorated with nothing inside the decoration, or the checkpoint and summary name different files, or a file that is not the report. This is the seam S1 converted: the caller records the path, never the body. |
| A4 | **Claim-ID set identity.** The set of claim IDs appearing in the specimen `chapter` equals `expected/claim-ids.txt` exactly. | An expected ID was dropped, or an ID not in the expected set appears (invented). Both are reported by ID. |
| A5 | **Verdict structure.** The report states exactly one `Verdict:` line. If its value is `APPROVED`, the report carries zero discrepancy blocks; otherwise it carries at least one. The summary and the checkpoint each state a verdict, and both quote the report's verdict exactly. | The verdict is absent, stated more than once, contradicts the discrepancy count, or the summary/checkpoint verdict diverges from the report's. |
| A6 | **Discrepancy structure.** Every `## Discrepancy N` block in the report carries all four fields the fact-verification SOP requires — `Claim`, `Claim ID`, `Issue type`, `Recommended correction` — each non-empty; the `Issue type` is one of `Unsupported`, `Contradicted`, `Overstated`, `Category-leakage`, `Undated`; and every discrepancy `Claim ID` is in the expected set. | A field is missing or blank, the issue type is outside the SOP's closed set, or a discrepancy cites an ID the chapter does not carry. |
| A7 | **Discrepancy accounting.** The report's stated `Discrepancy count`, the number of discrepancy blocks, the summary's stated count, the number of per-discrepancy lines in the summary, and the checkpoint's stated count all agree; and the `(Claim ID, Issue type)` pairs listed in the summary match the report's blocks as a set. A per-discrepancy line is read in either observed form — compact `- Q1-C02 — Overstated`, or numbered and labelled `1. Claim ID Q1-C02 — Issue type: Overstated`. Only the list marker and the two field labels are optional; the claim ID, the em-dash separator and a non-empty issue type must all be literally present. | Any of those five numbers disagrees, the summary lists a pair the report does not contain, or a line states no issue type (which is not counted as a pair rather than being repaired). |
| A8 | **Summary cap.** The `verification-summary` is at most 20 lines and at most 4096 bytes. | Either bound is exceeded. `execution-agent.md`: "The cap is hard and always wins: 20 lines and 4 KB, measured on the whole summary." |

A separate invocation, `score-specimen.sh --check-baseline`, validates
`expected/baseline-revision.txt`: exactly one `revision:` line holding a 40-hex SHA, at least one
`derivation:` line, and — when git is available and the file sits inside a work tree — that the
SHA resolves to a commit. This is what makes the pre-S1 boundary a recorded fact rather than a
run-time recollection.

### Surface form is not substance

A3 and A7 enforce what `execution-agent.md` actually requires: the output file path, the verdict
"exactly as the response states it", the discrepancy count, "one line per discrepancy giving its
Claim ID and Issue type exactly as written", and a hard 20-line / 4 KB cap. The contract fixes the
**fields and the cap**; it fixes no field labels and no value grammar. So the scorer normalizes
representation before comparing, and judges substance only.

This is a narrowing of the scorer, not a loosening of the contract. Normalization never supplies a
field: decoration with no path inside it, a pair line with no issue type, a missing line — each
still fails, because what is absent stays absent. `score-specimen.test.sh` proves both halves —
T31 asserts the decorated form passes, T32–T38 assert that every substantive A3 and A7 failure
survived accepting it.

### What Part A deliberately does not check

- **Prose wording.** A1–A8 never compare chapter or report prose beyond the claim-ID set. A2's
  byte comparison is on the *frozen* response, which is an input, not model output.
- **Analytical quality.** Whether the flagged discrepancies are the right ones is Part B.
- **Payload bytes.** The deterministic 80% reduction target is already proved by
  `tests/s1-relay/check-relay-payload.sh` and is not re-litigated here.

---

## Part B — preserved analytical meaning at the S1 relay boundary (a fresh evaluator decides)

Part B asks one question: **at the point where S1 changed what crosses the seam, does the caller
still hold the analytical content it needs?** S1 replaced "return the verification report body"
with "return the report's path plus a capped handoff summary". So the boundary Part B judges is
the caller's post-verification record — the returned path, the handoff summary, and the Step 2.5
checkpoint written from them — against the full report that is still on disk, and against the
chapter as it stood when it was verified.

### The artifacts the evaluator receives, and no others

Common inputs, identical for both arms:

| Path | What it is |
|---|---|
| `corpus/1.1-chapter-01.md` | the chapter as verified |
| `corpus/1.1-Q1-extract.md`, `corpus/1.1-Q2-extract.md` | the pass-2 evidence tables carrying the `Q[n]-C[##]` IDs |
| `corpus/1.1-gap-extract-pass-1.md` | the gap-fill extract carrying `GF1-C01` |
| `corpus/frozen-verification-response.md` | the fixed verification reply both arms were handed |

Pre-S1 arm — the caller received the report body:

| Path | What it is |
|---|---|
| `runs/baseline-pre-s1/raw/1.1-chapter-01-pre-correction.md` | the chapter at the verification boundary |
| `runs/baseline-pre-s1/raw/1.1-chapter-01-verification.md` | the report as written to disk |
| `runs/baseline-pre-s1/raw/1.1-chapter-01-verification-checkpoint.md` | the caller's record, carrying the per-discrepancy detail inline |

Post-S1 arm — the caller received a path and a capped summary:

| Path | What it is |
|---|---|
| `runs/current-head-post-s1/raw/1.1-chapter-01-pre-correction.md` | the chapter at the verification boundary |
| `runs/current-head-post-s1/raw/1.1-chapter-01-verification.md` | the report as written to disk |
| `runs/current-head-post-s1/raw/1.1-chapter-01-verification-summary.md` | the execution agent's returned handoff summary |
| `runs/current-head-post-s1/raw/1.1-chapter-01-verification-checkpoint.md` | the caller's record, written from the path and summary only |

The pre-S1 arm has **no** handoff-summary artifact, and that absence is not a defect: before S1
the agent returned the body, so there was no summary to write. It is why Part A's A1 stops that
arm, and why Part B compares the two arms' **caller records**, not two summaries.

The evaluator is **not** briefed with the S1 diff, the plan, this task's state file, or either
run's README. The question is whether the caller still holds what it needs, not whether the
refactor looks reasonable.

### What is excluded from Part B, and why

**Both arms' post-correction chapters and correction artifacts are excluded** —
`runs/*/raw/1.1-chapter-01.md`, `runs/*/raw/1.1-chapter-01-corrections-checkpoint.md`, and
`runs/*/raw/decisions.md`. The two runs behaved differently at Step 3a on a **pre-existing** gap
that has nothing to do with S1: `/verify-chapter` Step 3a does not pass the Evidence Pack that
`evidence-prose-fixer` declares a blocking required input. The pre-S1 arm proceeded anyway and
applied three corrections; the post-S1 arm halted and applied none. Their post-correction chapters
are therefore causally incomparable, and any difference between them measures that halt, not the
relay.

This is a **causal boundary, not a verdict**. Excluding those artifacts says nothing about whether
the correction stage is sound — it is not being tested here, and it has not passed. The Evidence
Pack gap is a live, separately recorded defect outside this task's scope.

### Byte identity is not a criterion

Identical wording is evidence of nothing, and differing wording is not by itself a degradation.
An evaluator who reports "the texts differ" has not answered the question.

### The judgments

Each is answered **PRESERVED / DEGRADED / UNCLEAR**, with one sentence of reasoning that names the
specific sentence, field or artifact relied on.

**The relay — what the caller ends up holding**

1. **Report fidelity through the path.** Is the report the returned path names complete and
   unaltered, and is it the report the caller's record points at? A path that resolves to a
   truncated, paraphrased or different report is a degradation even if every relayed field agrees.
2. **Verdict, count and pair preservation.** Do the verdict, the discrepancy count, and each
   `(Claim ID, Issue type)` pair reach the caller's record with the same meaning as the report
   states them? Quoting is the requirement; a restatement that changes the issue type or the
   attributed claim is a degradation.
3. **Summary sufficiency.** Can the caller decide its next step — enter the correction pass or
   not, and on which claims — from the summary and checkpoint alone? Detail that is genuinely
   deferred to the returned path is **not** a loss; detail the caller needed at the decision point
   and no longer has is.
4. **Compression without unsupported implication.** Does the summary or checkpoint imply anything
   the report does not support — a firmer verdict, a claim flagged that was not, a discrepancy
   made to sound resolved, an absent field silently filled? Compression that invents certainty is
   a degradation even where every field is present.

**The chapter at the verification boundary**

5. **Claim-ID and attribution integrity.** Does the verified chapter still carry its ten claim
   IDs, each tied to the same source, and does each ID still support the sentence it is attached
   to?
6. **Evidence/interpretation separation.** Are sourced findings still distinguishable from
   inference, per `reference/quality-standards.md`?
7. **Hedging and scope.** Are the qualifications intact — the thin pricing base, the self-selected
   panel, the market-level scope of the adviser concentration? Confidence that rose without new
   evidence is a degradation.
8. **Scarcity handling.** Is the fee-disclosure gap still stated as a fact about the search rather
   than converted into a negative finding about the world?

### The verdict

The evaluation ends with one overall verdict — **PRESERVED**, **DEGRADED**, or **UNCLEAR** —
naming, wherever anything is not PRESERVED, the specific artifact and sentence. UNCLEAR is a
legitimate outcome, is reported as itself, and is not rounded to PRESERVED. A judgment the
supplied artifacts cannot settle is UNCLEAR; it is not answered from anything outside them.
