---
task: canonical-rw-near-term-improvements
status: active
turn: codex
---

## Objective and scope

Deliver Slice S1 of the operator-approved near-term plan: refactor the canonical Research Workflow's justified W4-H1–H4 content relays to path-passing or path-plus-capped-summary, preserve intentional context isolation and analytical meaning, and prove the plan's deterministic 100% seam coverage / 80% payload-reduction target plus its representative chapter regression. The task exits when S1 and its required proof are accepted. Approval-metadata synchronization, S0, S2–S11, deep-pipeline slimming, and deploy-fitness mission work remain outside this task.

## Lane and unit

Standard. Implementation mode. Unit 20 — align the representative proof contract with the live S1 relay.

Named reason for the loop: S1 spans several bounded implementation and proof units, its canonical-workflow boundary must stay separate from propagation and adjacent programme work, and the aggregate deterministic and representative evidence must be independently assessed before S1 counts as complete.

## Latest result

Inspected (2026-08-18):
- Claim (1): HOLDS — read `workflows/research-workflow/.claude/agents/execution-agent.md` in full. The bounding requirements are line 18 ("Return the full response's path on disk — the caller-specified file it was written to — plus the handoff summary below, capped at 20 lines and 4 KB"), line 23 ("The output file path"), line 26 ("The discrepancy count, and one line per discrepancy giving its Claim ID and Issue type exactly as written"), and line 29 ("The cap is hard and always wins: 20 lines and 4 KB"). Searched the whole file for any field-label spelling, value grammar, bare-path requirement or per-discrepancy line shape — no match. The contract fixes fields and the cap only, so the scorer's former bare-value grammar was stricter than the contract it enforced. Loosening was therefore unnecessary and was not done.
- Claim (2): HOLDS — `runs/current-head-post-s1/raw/1.1-chapter-01-verification-summary.md` states the path (backtick-wrapped, plus a `(relative to project root …)` parenthetical) resolving to `1.1-chapter-01-verification.md`, `Verdict: DISCREPANCIES FOUND`, `Discrepancy count: 3`, and exactly three labelled pair lines — `Q1-C02/Overstated`, `Q1-C04/Category-leakage`, `GF1-C01/Undated`. Grepped the report for `^## Discrepancy |Verdict:|Discrepancy count:|Claim ID:|Issue type:`: 3 blocks, same three pairs, same count. The checkpoint states the bare path, the same verdict and count, and the same three pairs. Substance is complete; only representation differs.
- Claim (3): HOLDS — `cmp` shows both arms' `1.1-chapter-01-verification.md` byte-identical to `corpus/frozen-verification-response.md`, and both arms' `1.1-chapter-01-pre-correction.md` byte-identical to `corpus/1.1-chapter-01.md`. `diff` between the two arms' pre-correction chapters is empty. Downstream diverges instead: `runs/baseline-pre-s1/raw/1.1-chapter-01.md` differs from the corpus chapter (three corrections applied) while `runs/current-head-post-s1/raw/1.1-chapter-01.md` is byte-identical to it (Step 3a halted on the missing Evidence Pack, zero corrections). The excluded artifacts are excluded for that reason, not because the correction stage passed.

Result: the representative proof contract is aligned with the live S1 relay, and the untouched current-HEAD raw arm now scores A0–A8 all PASS under the corrected scorer. Four files changed inside `tests/s1-representative/`, plus one new result file; no workflow source, no agent, no `tests/s1-relay/`, and no raw run artifact was touched.

- `score-specimen.sh` — A3 gained `normalize_path()`, which reduces the relayed `Output file path:` value to the path itself (first Markdown code span, or a bare value with a trailing explanatory parenthetical dropped) before the summary/checkpoint comparison; the failure message now prints both the normalized and the as-stated values. A7's `-F' — '` parse was replaced by `summary_pairs()`, which accepts an optional list marker (bullet or ordered) and the optional `Claim ID` / `Issue type:` labels, and still requires the claim ID, the em-dash separator and a non-empty issue type to be literally present. Both are representation-only: nothing absent is supplied.
- `score-specimen.test.sh` — eight cases added. T31 asserts the decorated form passes. T32–T38 assert every substantive A3/A7 failure survived accepting it: decorated path naming a different file, decorated path naming the wrong artifact, decoration with no path inside it, a dropped pair line, a restated issue type, a swapped-in unflagged claim ID, and a pair line stating no issue type.
- `rubric.md` — A3 and A7 rows restated to describe what is normalized and what still fails; a new "Surface form is not substance" section records the contract basis and that this narrows the scorer rather than loosening the contract; Part B rewritten to the S1 relay boundary.
- `README.md` — the harness-count line corrected to 36 negative controls plus two positive cases.
- `runs/current-head-post-s1/score-result-corrected-scorer.txt` — new. The corrected-scorer rescore of the same unchanged raw directory, carrying the scoring date, the repository revision, the corrected and prior scorer blob hashes, the harness blob hash, and what changed in the scorer.

Part B now names the exact artifacts the evaluator receives (common corpus inputs; the pre-S1 arm's pre-correction chapter, report and checkpoint; the post-S1 arm's pre-correction chapter, report, handoff summary and checkpoint) and eight judgments: report fidelity through the returned path, verdict/count/pair preservation, summary sufficiency versus detail safely deferred to the path, compression without unsupported implication, then claim-ID and attribution integrity, evidence/interpretation separation, hedging and scope, and scarcity handling at the pre-correction boundary. `PRESERVED` / `DEGRADED` / `UNCLEAR`, sentence-level evidence and one overall verdict are retained, with UNCLEAR explicitly not rounded. The exclusion of both arms' post-correction chapters, corrections checkpoints and decision logs is stated as a causal boundary caused by the pre-existing missing Evidence Pack — and explicitly not as a claim that the correction stage passed.

Evidence: `bash score-specimen.test.sh` → `harness: 38/38 cases behaved as asserted`, exit 0 — up from 31/31, with T31–T38 new. The harness is failing-capable by construction: each of T2–T30 and T32–T38 mutates a throwaway copy of the reference specimen once and asserts the matching `check <ID>: FAIL`, and a case whose scorer exits 0 is reported as a harness failure. `bash score-specimen.sh --specimen runs/current-head-post-s1/raw` → A0–A8 all PASS, `verdict: PASS`, exit 0 — the same command returned `FAIL (2 check(s))`, exit 1 at A3 and A7 before this change. Discrimination is intact in both directions: `--specimen runs/baseline-pre-s1/raw` still returns `FAIL (1 check)` at A1 (that arm has no handoff-summary artifact, because pre-S1 returned the body; not backfilled), the reference specimen returns `verdict: PASS`, and `--check-baseline` returns PASS. `runs/current-head-post-s1/score-result.txt` is preserved byte-for-byte: `git hash-object` → `ea59a39aa3ebed2eab426cb02db765e42a3cba9a`, equal to the blob committed at `c2274115`. `git status --porcelain` confirms the changed set is the four `tests/s1-representative/` files plus the new result file plus this state file; no `raw/` artifact, no `.claude/`, no `reference/`, no `tests/s1-relay/` path appears.

Deferral noticed and not done: `execution-agent.md`'s handoff summary is under-specified in surface form — a conforming agent can emit a summary no deterministic consumer can parse. Pinning the field labels and line shape in the contract is a workflow-source change, outside this unit's boundary and outside the scorer's job; recorded here rather than implemented.

Separately, `logs/friction-log.md` carries 223 uncommitted insertions in this working tree. The friction log is frozen workspace-wide, so this is surfaced rather than acted on; it predates this unit, is outside its boundary, and was neither staged nor modified.

Unit 19 accepted as valid run evidence at commit `c227411505b51c93ac7fa5e7cf7d717dda58debc`. The current-HEAD `/verify-chapter` arm used the identical corpus and frozen response, returned only the report path plus a 10-line / 609-byte summary, kept the full 46-line / 2251-byte report on disk, preserved all 10 claim IDs and the verdict/discrepancy structures, and left canonical source unchanged. The real Step 3c packet was presented and the operator replied `approved`.

The raw Part-A result failed A3 and A7. Codex accepts the run and attributes those failures to a proof-contract mismatch, not lost relay substance: `execution-agent.md` requires the path, verdict, discrepancy count, per-discrepancy claim ID and issue type, plus the hard cap, but does not mandate bare path values or an unlabeled `<ID> — <type>` line grammar. The emitted backtick-wrapped path with an explanatory parenthetical and numbered `Claim ID … — Issue type: …` lines satisfy the live contract. Pinning a new workflow syntax only to make the scorer pass would invent a requirement; the scorer must instead recognize these contract-permitted forms while continuing to fail wrong paths and wrong discrepancy pairs.

The run also confirmed the carried missing-Evidence-Pack defect: current Step 3a halted and applied zero corrections, while the baseline agent proceeded despite the same absent blocking input. That caller-contract gap is outside S1 and remains deferred. It makes post-correction chapters causally incomparable, so the independent Part-B judgment will operate at the S1 relay boundary: the common pre-correction chapter and extracts, baseline full response/checkpoint, and post-S1 report, path, capped summary and checkpoint. It will judge whether the new relay preserves the analytical content needed at that boundary; it will not attribute downstream correction behavior to S1 or pretend the Evidence-Pack gap was fixed.

Unit 18 remains accepted at `5d439aa0726dfedd4a9fe6ddf7103806207af366`; Unit 17 at `ac522ac2b4c61af0b5a3eedd2e555ddadeb8d65f`; Unit 16 at `83d26431c52eab2f10c276a01985d74302afaaf9`. Accepted deterministic position remains 40/40 seams accounted for, 27 converted and 13 justified, 0 violations/cap/ambiguous/unresolved, 99.824469% reduction, checker `TARGET MET`, harness 26/26.

Current position: approved plan Slice S1 → both representative runs captured → the proof contract is now aligned with the live relay, so Part A passes A0–A8 on the untouched current-HEAD arm and Part B is executable at the valid relay boundary → the fresh independent Part-B evaluation is the remaining S1 proof step → the workflow itself was not changed and the Evidence-Pack gap remains deferred, so neither an invented syntax nor an unrelated upstream defect is folded into the S1 verdict.

Carried deferrals remain outside the task: missing Evidence Pack and verification-report relay at `verify-chapter` Step 3.7a; stale `reference/stage-instructions.md` writer-return wording; writer Reviewer Findings footer sequencing; README `Blast radius`; optional verification-summary truncation naming; baseline GF1-C01 date capture.

## Brief

This unit repairs the representative proof contract using the two accepted raw runs. It makes the deterministic scorer enforce what the live S1 contract actually requires and narrows the semantic rubric to the relay boundary the experiment validly isolates; it does not modify the workflow or manufacture a passing run artifact.

Required outcome: update only the representative-test substrate so A3 and A7 recognize the current run's contract-permitted path and discrepancy surface forms while still rejecting substantive path or pair errors. Preserve Unit 19's original `score-result.txt` unchanged, rescore its raw directory with the corrected scorer into a separately named result, and revise Part B so a fresh evaluator judges semantic fidelity at the S1 verification relay boundary without comparing the causally confounded post-correction chapters.

Check against the repository before editing:

1. Quote the exact current `execution-agent.md` requirements that bound A3 and A7 and confirm they require field substance but not the scorer's former bare-value grammar. If the live contract actually mandates the old grammar, stop and hand back rather than loosening the scorer.
2. Confirm Unit 19 raw output contains the correct report filename/path, verdict, discrepancy count and exact three `(Claim ID, Issue type)` pairs despite its decorated labels. The parser may normalize representation only; it must never infer missing substance.
3. Confirm the baseline and post-S1 raw pre-correction chapters and frozen reports are the intended common semantic artifacts, and record why downstream correction outputs are excluded: missing Evidence Pack, not S1 relay loss.

Boundary: `workflows/research-workflow/tests/s1-representative/` and this state file only. Do not edit canonical workflow source, agents, skills, plans, `tests/s1-relay/`, either run's raw artifacts, deployed projects or consuming-project data. Do not fix or simulate the Evidence Pack, rerun either attended workflow arm, invoke a semantic evaluator, or perform propagation.

Required proof changes and evidence:

- A3 must accept the canonical bare path and contract-permitted Markdown decoration or explanatory parenthetical only when the extracted path still names the report artifact and agrees with the checkpoint. It must continue to fail a missing path, a different path, and a path naming the wrong artifact.
- A7 must accept both the compact reference form and the numbered/labeled form observed in Unit 19 only when the exact report `(Claim ID, Issue type)` set and count are preserved. It must continue to fail missing, invented, duplicated, mismatched or unknown pairs.
- Add positive variant cases for the observed current form and failing controls for the retained error classes. Show the complete representative scorer harness passes and remains capable of failing each substantive class.
- Preserve `runs/current-head-post-s1/score-result.txt` byte-for-byte. Write the corrected-scorer result separately with the scorer revision/commit context, then show A0–A8 all ran and report the genuine verdict.
- Revise `rubric.md` Part B to name the exact artifacts the fresh evaluator receives and score: full-report fidelity through the path/summary relay; verdict, count, claim-ID and issue-type preservation; summary sufficiency versus details safely deferred to the returned path; chapter claim-ID, attribution, evidence/interpretation, hedging and scarcity integrity at the pre-correction boundary; and any unsupported implication introduced by summary/checkpoint compression. Retain `PRESERVED` / `DEGRADED` / `UNCLEAR`, sentence-level evidence and one overall verdict.
- State explicitly that downstream corrections are excluded because the two runs behaved differently on the pre-existing missing Evidence Pack. This is a causal boundary, not a claim that the correction stage passed.
- Run and report the representative scorer harness, valid reference specimen, corrected rescore of the raw current arm, and baseline raw score. The historical arm may still stop at expected A1; do not backfill its missing summary.
- Report files changed, commands and exit codes, negative/positive outcomes, preserved-original-result check, and the commit.

Completion condition: the scorer accepts every live-contract-permitted current summary form and rejects every named substantive error; the untouched current raw arm produces a full A0–A8 result under the corrected scorer; the original failed result remains preserved; Part B is independently executable at the valid relay boundary without hiding the downstream confounder; no workflow source or raw run artifact changes; commit and hand back to Codex.

Stop and hand back if accepting Unit 19 requires weakening a substantive live requirement, inferring absent fields, changing raw artifacts, modifying workflow source, fixing the deferred Evidence Pack gap, or materially changing the approved S1 acceptance objective. Do not perform the independent evaluation in this unit.

Capability subset: baseline local read/edit/test capabilities inside the bounded paths and Claude-owned local commit. No network, workflow-agent execution, evaluator/model invocation, credentials, deployed-project write, propagation, production or other operator-reserved capability is needed.

Claude may challenge a false premise or stale direction with repository evidence; do not improvise around it.

## Blocker

None.

## Next action

Codex: assess Unit 20 — whether the corrected A3/A7 parsing enforces the live `execution-agent.md` contract without loosening it, whether T31–T38 prove the retained substantive failures, whether the revised Part B is independently executable at the relay boundary with the Evidence-Pack confounder disclosed rather than hidden, and whether the preserved original result plus the separate corrected rescore keep both readings of the Unit 19 arm on the record. Then decide close, continue, correct once, or stop.
