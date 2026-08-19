# Current-HEAD run — post-S1 `/verify-chapter`, 2026-08-18

The second of the two Route A comparison arms: one attended `/verify-chapter` run of the Unit 17
corpus against the **post-S1** workflow contract at current `HEAD`. `raw/` holds that run's output
exactly as it was produced. Nothing in `raw/` has been normalised, repaired, or back-filled, and
`score-result.txt` is the scorer's unedited verdict on it.

**Part A result: FAIL at A3 and A7.** That failure is genuine, is not repaired here, and is the
substantive finding of this run. See § Part-A result below.

## Revision and provenance

Run revision `5d439aa0726dfedd4a9fe6ddf7103806207af366` — resolved with `git rev-parse HEAD` at run
start, not inferred from the branch name. This is a state/evidence commit (Unit 18's hand-back);
the S1 workflow source it carries is tree `47f050bc9e716e2f29f12f5304682c211c5855b8`.

The scratch workflow source was extracted with `git archive 5d439aa0 workflows/research-workflow`
into a temporary directory outside the repository. Provenance was verified by blob hash rather
than asserted: all **176 regular files** are byte-identical to the recorded tree. The only
divergence is the tree's 4 symlink entries (`consult.md`, `refinement-pass.md`, `session-plan.md`,
`update-claude-md.md` under `.claude/commands/`), whose targets point outside the extracted
subtree; none is on the `/verify-chapter` path. This matches the baseline arm's symlink set.

The working tree under `workflows/research-workflow/` was clean at run start, so the extracted
source and the checked-out source agree.

Two run-surface files carry the post-S1 side of the S1 diff, the pre-images of which the baseline
arm recorded:

| File | Blob at run revision | Pre-image at baseline `f18ed58d` |
|---|---|---|
| `.claude/commands/verify-chapter.md` | `d053127a…` | `0a723154…` |
| `.claude/agents/execution-agent.md` | `26ba4b1c…` | `6b849c2c…` |

The scratch tree was never merged, propagated, or written back. Current canonical workflow source
was not modified — `git status` over `.claude/` and `reference/` was empty after the run.

## The substitution — one seam, named exactly

`execution-agent`'s single external action, "Construct and send the API call", was replaced by
reading the frozen response as the response body. The `diff` of the scratch agent file against its
extracted original is one hunk covering that one bullet, and nothing else.

**Everything else in the post-S1 contract was left in force**, including "Return the full
response's path on disk … plus the handoff summary below, capped at 20 lines and 4 KB", the whole
handoff-summary field list and cap-fitting order, "Hand the full response body back to the caller"
(prohibited), "Write the complete response verbatim to the file path specified by the caller", and
the `/logs/execution-log.md` metadata append.

Corpus inputs were installed byte-identical to `../../corpus/` (blob-checked: chapter
`1abacaf4…`, Q1 `ebd4c095…`, Q2 `e1358a35…`, gap-fill `89daa070…`, frozen response `9b78d8fd…`).
These are the same files the baseline arm used, unchanged.

The registered session `execution-agent` (`c39e7c8a…`) differs from the workflow's copy, so it was
**not** used. The agent was dispatched under the scratch contract reproduced verbatim, exactly as
the baseline arm did, so that the contract under test is the one that governed the run.

No network request, API call, web fetch, credential, client material, deployed-project write or
billed API spend was involved at any point.

## What the run did

| Step | What happened |
|---|---|
| 1 | Chapter and its three extracts read from the project instance. |
| 1b | `check-claim-ids.sh` (current, unmodified) run on the chapter — no output, no pause. |
| 2.4 | `execution-agent` delegated. **It returned a path plus a 10-line / 609-byte handoff summary and no report body** — the post-S1 relay shape, directly observed rather than inferred. Report written verbatim to disk (46 lines / 2251 bytes, byte-identical to the frozen response). |
| 2.5 | Verification checkpoint written by the caller **from the returned path and summary only**; the report body was never returned to or read by the caller session. |
| 3a | `evidence-prose-fixer` delegated with the chapter **by path** — the S1 conversion at this seam. The path resolved and the sub-agent read the complete chapter. **It then halted and returned zero corrections**, because the Evidence Pack it declares a blocking required input is not passed by the Step 3a caller contract. |
| 3b | Nothing to check — no correction was presented. Recorded as "no items presented", which is a different state from "items passed". |
| 3c | **PAUSE.** Full packet presented to the operator with both groups empty, together with the halt reason and its consequence for the comparison. Operator replied `approved` on 2026-08-18. |
| 3d–3f | Zero corrections applied, decisions logged, corrections checkpoint written. |
| 4 | QC log written. |

## The Step 3a halt

This is the run's other material finding, and it is independent of the Part-A failure.

`/verify-chapter` Step 3a passes the skill, the verification report, and the chapter path. It does
not pass the Evidence Pack, which `evidence-prose-fixer` declares a **blocking** required input.
The sub-agent applied the skill's own rule ("If missing: Do not proceed"; "Do not guess at
corrections without evidence access") and produced nothing. It verified the absence against the
run tree rather than asserting it from the caller contract: the analysis directories hold only
`.gitkeep`, and the sole analysis-side artifact present is the GF1 gap-fill extract, not the Q1/Q2
evidence tables the flagged claims rest on.

The run did **not** re-issue Step 3a with the evidence attached. That would change non-send
behaviour and repair the contract mid-measurement.

**This corroborates the task's carried Evidence-Pack deferral from a second direction.** The
pre-S1 baseline arm recorded the same gap while still returning three corrections; this arm
refused outright. The gap is in the caller contract, not in the S1 relay conversion — the chapter
*path* relay, which is what S1 changed here, resolved and was read in full.

**Consequence for Part B, stated rather than smoothed over:** this arm's chapter carries **no**
applied corrections and is byte-identical to the input, while the baseline arm's chapter carries
three. The fresh evaluator must be told this; comparing the two chapters without it would
attribute an upstream blocking-input halt to the relay refactor.

## Part-A result: FAIL at A3 and A7

```
check A0: PASS   check A1: PASS   check A2: PASS
check A3: FAIL — summary and checkpoint name different report paths
check A4: PASS   check A5: PASS   check A6: PASS
check A7: FAIL — summary lists 0 per-discrepancy line(s) for 3 block(s)
check A8: PASS — handoff summary within cap: 10/20 lines, 609/4096 bytes
verdict: FAIL (2 check(s))
```

**Both failures have one cause: the surface form of the returned handoff summary.** Its substance
is right — the path is relayed, the verdict is quoted exactly, the count is 3, all three
`(Claim ID, Issue type)` pairs are present and correct, and it is well inside the cap. What the
scorer could not parse is the *shape*:

| Check | What the scorer reads | What the agent emitted |
|---|---|---|
| A3 | an `Output file path:` field whose value equals the checkpoint's | `Output file path: ` followed by a **backtick-wrapped path plus a parenthetical** `(relative to project root …)`, so the string differs from the checkpoint's bare path |
| A7 | per-discrepancy lines of the form `<Claim ID> — <Issue type>`, optionally list-marked | `1. Claim ID Q1-C02 — Issue type: Overstated` — numbered, and the claim ID prefixed by a label, so the first em-dash field is not a bare claim ID |

**This is not an artifact of how the summary was captured.** The agent's return carried a preamble
line and then a labelled `Handoff summary:` block; the whole return was preserved verbatim as the
artifact. Scoring the narrower alternative — the `Handoff summary:` block alone — was tried
against a scratch copy and fails **the same two checks**, because that block's field is labelled
`Output file:` rather than `Output file path:` and its per-discrepancy lines are identical. Either
capture fails A3 and A7. The counterfactual was run outside `raw/` and changed nothing in it.

### What this does and does not establish

- **It does not show that S1 lost the path.** The path *was* relayed and the caller *did* record
  it; A3 failed on string form, not on absence. The checkpoint carries the correct path and the
  report body never reached the caller — which is the behaviour S1 introduced.
- **It does show the post-S1 handoff contract is under-specified in surface form.**
  `execution-agent.md` names the required *fields* and the hard cap, but not the field labels or
  the per-discrepancy line shape. An agent can satisfy every stated requirement and still emit a
  summary that no deterministic consumer can parse. The reference specimen fixes a shape; the
  contract does not require it.
- **Which side is wrong is a live question and is deliberately not decided here.** Two readings
  are available and this run does not choose between them: either the contract should pin the
  summary's labels and line shape, or the scorer's A3/A7 parsing is stricter than the contract it
  claims to enforce. Both are consistent with the evidence.

The artifacts were not altered and the scorer was not weakened to convert this into a pass.

## Files

| Path | What it is |
|---|---|
| `raw/1.1-chapter-01-pre-correction.md` | The chapter as verified at Step 2. Byte-identical to `raw/1.1-chapter-01.md` this run, because zero corrections were applied. |
| `raw/1.1-chapter-01.md` | The chapter after Step 3 — unchanged. The Part-B artifact. |
| `raw/1.1-chapter-01-verification.md` | The complete verification report as written to disk. |
| `raw/1.1-chapter-01-verification-summary.md` | The execution agent's returned handoff summary, preserved verbatim. |
| `raw/1.1-chapter-01-verification-checkpoint.md` | Step 2.5 checkpoint. |
| `raw/1.1-chapter-01-corrections-checkpoint.md` | Step 3f checkpoint. |
| `raw/decisions.md`, `raw/execution-log.md`, `raw/qc-log.md` | The run's three logs. |
| `score-result.txt` | The scorer's unedited output and exit code. |

## Runtime limitations

- The caller session had read the frozen response earlier, during premise inspection, so its
  ignorance of the report body is not a property of the harness. The Step 2.5 checkpoint was
  nonetheless written from the returned path and summary only, and the relay shape itself — that
  the agent returned no body — is a direct observation of the sub-agent's return, not an inference.
- Token counts are not exposed by the frozen-response harness, so the execution log records that
  field as not applicable rather than estimating it.
- Both sub-agents are language models; the Step 3a halt is a behaviour of this run and the baseline
  arm's fixer behaved differently on the same gap. The gap in the caller contract is the stable
  fact; which way a fixer resolves it is not.
