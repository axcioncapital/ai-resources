# Baseline run — pre-S1 `/verify-chapter`, 2026-08-18

The first of the two Route A comparison arms: one attended `/verify-chapter` run of the Unit 17
corpus against the **pre-S1** workflow contract. `raw/` holds that run's output exactly as it was
produced. Nothing in `raw/` has been normalised, repaired, or back-filled to match the post-S1
contract, and `score-result.txt` is the scorer's unedited verdict on it.

## Revision and provenance

Baseline revision `f18ed58d6c96b0f97fc677fb7c90073336f310e4` — the value recorded in
`../../expected/baseline-revision.txt`, re-resolved at run time (`git cat-file -t` → `commit`).

The scratch workflow source was extracted with `git archive f18ed58d... workflows/research-workflow`
into a temporary directory outside the repository. Provenance was verified by blob hash rather than
asserted: all **150 regular files** are byte-identical to the recorded tree
(`8e36dc1338e3bf4be6520acd2a894006e1be07f8`). The only divergence is the tree's 4 symlink entries
(`consult.md`, `refinement-pass.md`, `session-plan.md`, `update-claude-md.md` under
`.claude/commands/`), whose targets point outside the extracted subtree; none is on the
`/verify-chapter` path.

Two run-surface files cross-check against the S1 diff's pre-image hashes:

| File | Hash in scratch | Pre-image in `git diff f18ed58d HEAD` |
|---|---|---|
| `.claude/commands/verify-chapter.md` | `0a723154…` | `index 0a723154..d053127a` |
| `.claude/agents/execution-agent.md` | `6b849c2c…` | `index 6b849c2c..26ba4b1c` |

The scratch tree was never merged, propagated, or written back. Current canonical workflow source
was not modified.

## The substitution — one seam, named exactly

`execution-agent`'s single external action, "Construct and send the API call", was replaced by
reading `../../corpus/frozen-verification-response.md` as the response body. **Everything else in
the historical contract was left in force**, including "Return the full response content", "Interpret
or summarize the response — return it verbatim" (prohibited), "Write the response to the file path
specified by the caller", and the `/logs/execution-log.md` metadata append.

No network request, API call, web fetch, credential, client material, deployed-project write or
billed API spend was involved at any point.

## What the run did

| Step | What happened |
|---|---|
| 1 | Chapter and its three extracts read from the project instance. |
| 1b | `check-claim-ids.sh` (historical, unmodified) run on the chapter — no output, no pause. |
| 2.4 | `execution-agent` delegated. **It returned the full 46-line / 2251-byte response body** — the pre-S1 relay shape, directly observed rather than inferred. Report written verbatim to disk. |
| 2.5 | Verification checkpoint written by the caller from the returned body: output path, discrepancy count, discrepancy summary, verdict. |
| 3a | `evidence-prose-fixer` delegated with the chapter prose **as content**, which is how this revision hands it over. Returned three corrections with per-item bright-line metadata. |
| 3b | Bright-line check applied to all three. All tripped at least one trigger; none was auto-appliable. |
| 3c | **PAUSE.** Full packet presented to the operator — Group 1 empty, Group 2 all three with triggers named. Operator replied `approved` on 2026-08-18. |
| 3d–3f | Three corrections applied, decisions logged, corrections checkpoint written. |
| 4 | QC log written. |

Step 3c is the run's real attended gate. It is conditional in the historical file (`if discrepancies
found`), and it fired because the frozen response carries three discrepancies. The historical Step 3c
specifies no literal response token — unlike `run-report` Step 4.2e, which does. The `approved` token
used here is this run's convention, set by the unit brief, not a contract read off the file.

## Part-A result: FAIL at A1, expected

```
check A0: PASS
check A1: FAIL — missing required artifact (verification-summary): 1.1-chapter-01-verification-summary.md
verdict: FAIL (1 check(s))
note: A2-A8 not run — they read artifacts A1 could not establish.
```

**Classified as an expected historical-contract absence, not a semantic or schema failure.** At
`f18ed58d` the execution agent returns the full response content and no capped-summary contract
exists, so there is no artifact to produce. The absence *is* the pre-S1 state the comparison exists
to record. The artifacts were not altered and the scorer was not weakened to convert this into a pass.

**A2–A8 did not run at all.** The scorer short-circuits after A1 because the remaining checks read
artifacts A1 could not establish. That is correct behaviour, but it means Part A returned no semantic
signal for this arm — which is a property of the gate, not a property of the run.

## Direct inspection, in place of the checks that could not run

These are **inspection results, not scorer output**, recorded so the baseline arm is not silent on
everything except a missing file. Each corresponds to the check that would have covered it.

| Would-be check | Finding |
|---|---|
| A2 verbatim fidelity | Report is byte-identical to the frozen response. |
| A3 path relay | The historical checkpoint **does** carry `Output file path: report/chapters/1.1/1.1-chapter-01-verification.md`. Step 2.5 already required it pre-S1. |
| A4 claim-ID identity | 10 of 10 expected IDs present in the final chapter; none dropped, none invented — across three applied corrections. |
| A5 verdict structure | Exactly one `Verdict:` line (`DISCREPANCIES FOUND`), quoted identically in the checkpoint, with 3 discrepancy blocks. |
| A6 discrepancy structure | 3 blocks, each carrying all four SOP fields (3/3 on each of Claim, Claim ID, Issue type, Recommended correction). |
| A7 accounting | Report and checkpoint both state `Discrepancy count: 3`, matching the 3 blocks. |
| A8 summary cap | Not applicable — no summary artifact exists to measure. |

**No unexpected loss of claim IDs, verdict structure, discrepancy structure or analytical content
occurred.** What S1 introduced at this seam was the capped summary and the "report body is not needed
here" instruction — not the path in the checkpoint, which predates it.

## Files

| Path | What it is |
|---|---|
| `raw/1.1-chapter-01-pre-correction.md` | The chapter as verified at Step 2, before any correction. |
| `raw/1.1-chapter-01.md` | The chapter after the three approved corrections — the Part-B artifact. |
| `raw/1.1-chapter-01-verification.md` | The complete verification report as written to disk. |
| `raw/1.1-chapter-01-verification-checkpoint.md` | Step 2.5 checkpoint. |
| `raw/1.1-chapter-01-corrections-checkpoint.md` | Step 3f checkpoint. |
| `raw/decisions.md`, `raw/execution-log.md`, `raw/qc-log.md` | The run's three logs. |
| `score-result.txt` | The scorer's unedited output and exit code. |

## Finding recorded, not fixed

`evidence-prose-fixer` reported unprompted that the Step 3a caller contract passes it the skill, the
verification report and the chapter prose — but **not the Evidence Pack**, which the skill declares a
blocking required input. Its corrections were therefore generated against the verifier's
characterisation of the evidence rather than the evidence rows. This corroborates the task's carried
Evidence-Pack deferral from a direction not previously tested. Not fixed here; out of this unit's scope.
