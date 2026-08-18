---
task: canonical-rw-near-term-improvements
status: active
turn: codex
---

## Objective and scope

Deliver Slice S1 of the operator-approved near-term plan: refactor the canonical Research Workflow's justified W4-H1–H4 content relays to path-passing or path-plus-capped-summary, preserve intentional context isolation and analytical meaning, and prove the plan's deterministic 100% seam coverage / 80% payload-reduction target plus its representative chapter regression. The task exits when S1 and its required proof are accepted. Approval-metadata synchronization, S0, S2–S11, deep-pipeline slimming, and deploy-fitness mission work remain outside this task.

## Lane and unit

Standard. Implementation mode. Unit 19 — capture the attended current-HEAD `/verify-chapter` run.

Named reason for the loop: S1 spans several bounded implementation and proof units, its canonical-workflow boundary must stay separate from propagation and adjacent programme work, and the aggregate deterministic and representative evidence must be independently assessed before S1 counts as complete.

## Latest result

Inspected (2026-08-18):
- Claim (1): HOLDS — `git rev-parse HEAD` → `5d439aa0726dfedd4a9fe6ddf7103806207af366`, resolved at run start, not from the branch name; `git status --porcelain -- workflows/research-workflow` empty, so checkout and commit agree. Scratch extracted by `git archive 5d439aa0 workflows/research-workflow`; all 176 regular files blob-compared against tree `47f050bc` — 176 byte-identical, 0 mismatched, 4 symlinks skipped (same set as the baseline, none on the `/verify-chapter` path). This revision is a state/evidence commit (Unit 18 hand-back), distinguished from the S1 workflow source tree it carries.
- Claim (2): HOLDS — searched the scratch `execution-agent.md` diff against its extracted original; exactly one hunk, replacing only the `- Construct and send the API call` bullet. The post-S1 contract lines survive verbatim: `Return the full response's path on disk … plus the handoff summary below, capped at 20 lines and 4 KB`, the full field list and cap-fitting order, `Hand the full response body back to the caller` (prohibited), and `Write the complete response verbatim to the file path specified by the caller`.
- Claim (3): HOLDS — read `verify-chapter.md` Step 3c: `PAUSE — Present all corrections to the operator`, with the two-group split and per-flag trigger statement. Searched the file for a literal response token — no match; as at the baseline, `approved` is the run convention set by the brief, not read off the contract. Nothing was auto-approved and Route A did not supply the response.
- Claim (4): HOLDS — searched `tests/s1-representative/runs/` before the run; only `baseline-pre-s1/` present, so `current-head-post-s1/raw/` receives this run's own output. No path was normalized, no field back-filled, and the Unit 17 reference specimen was not copied over run output.

Result: the attended current-HEAD arm ran to completion and **Part A FAILED at A3 and A7** (`verdict: FAIL (2 check(s))`, exit 1). The failure is genuine, is preserved unrepaired, and is the unit's substantive finding. Two independent findings came out of the run.

**Finding 1 — the post-S1 handoff summary is under-specified in surface form.** A0, A1, A2, A4, A5, A6 and A8 all passed: the four artifacts exist, the report is byte-identical to the frozen response, the chapter carries exactly the 10 expected claim IDs, the verdict is stated once and quoted consistently, all three discrepancy blocks carry their four SOP fields, and the summary is well inside the cap at 10/20 lines and 609/4096 bytes. A3 and A7 failed on *shape*, not substance: the agent emitted `Output file path:` followed by a backtick-wrapped path plus a `(relative to project root …)` parenthetical, so the string did not equal the checkpoint's bare path; and its per-discrepancy lines read `1. Claim ID Q1-C02 — Issue type: Overstated`, so the scorer's `<Claim ID> — <Issue type>` parse found 0 lines for 3 blocks. This does **not** show S1 lost the path — the path was relayed and the caller recorded it correctly. It shows `execution-agent.md` fixes the required fields and the cap but not the field labels or the per-discrepancy line shape, so a fully conforming agent can emit an unparseable summary. Whether the contract should pin the shape or the scorer's A3/A7 parse is stricter than the contract it enforces is a live question this unit deliberately does not decide.

**Finding 2 — Step 3a halted on the missing Evidence Pack, so zero corrections were produced.** `evidence-prose-fixer` read both supplied inputs in full — the chapter arrived **by path**, the S1 conversion at that seam, and resolved correctly — then applied its own blocking-input rule and refused to proceed, verifying the absence against the run tree rather than asserting it from the caller contract. The Step 3c pause still fired with both groups empty; the packet and its consequence were presented and the operator replied `approved` on 2026-08-18. The run did not re-issue Step 3a with the evidence attached, because that would change non-send behaviour and repair the contract mid-measurement. This corroborates the carried Evidence-Pack deferral from a second direction: the baseline arm recorded the same gap but still returned three corrections. The gap is in the caller contract, not in the S1 relay.

The post-S1 relay shape was directly observed, not inferred: the agent returned a path plus a 10-line / 609-byte summary and **no report body**, and wrote the complete 46-line / 2251-byte report verbatim to the caller-specified path. The caller's Step 2.5 checkpoint was written from the returned path and summary alone.

Evidence: `bash score-specimen.sh --specimen runs/current-head-post-s1/raw` → `verdict: FAIL (2 check(s))`, exit 1, with A0–A8 individually reported and preserved unedited in `runs/current-head-post-s1/score-result.txt`. The same command on the baseline arm returns `FAIL (1 check)` at A1, and on the reference specimen returns PASS — so the check discriminates. The A3/A7 result was tested against the alternative capture of the agent's return (its `Handoff summary:` block alone) on a scratch copy outside `raw/`: it fails **the same two checks**, so neither failure is an artifact of how the summary was captured. Corpus inputs blob-verified identical to the baseline's (chapter `1abacaf4`, Q1 `ebd4c095`, Q2 `e1358a35`, gap-fill `89daa070`, frozen response `9b78d8fd`). Final chapter blob `1abacaf4` — byte-identical to input, because zero corrections were applied. No network request, API call, credential, client material, deployed-project write or billed API spend occurred; `git status` over `workflows/research-workflow/.claude` and `reference/` was empty after the run, so canonical source is unchanged.

Carried forward for Part B: this arm's chapter carries no applied corrections while the baseline's carries three. The fresh evaluator must be briefed on that asymmetry, or it will attribute an upstream blocking-input halt to the relay refactor.

Unit 18 remains accepted at `5d439aa0726dfedd4a9fe6ddf7103806207af366`; Unit 17 at `ac522ac2b4c61af0b5a3eedd2e555ddadeb8d65f`; Unit 16 at `83d26431c52eab2f10c276a01985d74302afaaf9`. Accepted deterministic position remains 40/40 seams accounted for, 27 converted and 13 justified, 0 violations/cap/ambiguous/unresolved, 99.824469% reduction, checker `TARGET MET`, harness 26/26.

Standing authorization: Route A authorizes this local fixed-response current-HEAD run, native workflow-agent execution, the real per-run correction-approval request and the later fresh independent evaluation. It does not pre-supply the `approved` response. It excludes client material, deployed-project writes, external workflow network/API calls, credentials, billed API spend, propagation, production deployment and deferred adjacent fixes.

Current position: approved plan Slice S1 → pre-S1 semantic baseline accepted → deterministic proof, comparison contract and historical arm are complete → the current-HEAD arm and fresh Part-B evaluation remain → capture the current-HEAD `/verify-chapter` run on identical inputs → this tests whether the new path-plus-capped-summary contract passes mechanically before meaning is judged independently.

Carried deferrals remain outside the task: missing Evidence Pack and verification-report relay at `verify-chapter` Step 3.7a; stale `reference/stage-instructions.md` writer-return wording; writer Reviewer Findings footer sequencing; README `Blast radius`; optional verification-summary truncation naming. The baseline's GF1-C01 date-capture branch is also recorded and not promoted into S1.

## Brief

This unit captures the second comparison arm on the current S1 workflow, using exactly the same corpus, frozen response and attended correction decision as the accepted historical arm. It ends after producing raw post-S1 artifacts and the full Part-A verdict; semantic comparison remains the fresh evaluator's separate unit.

Required outcome: in a local isolated scratch environment sourced from the exact current commit at run start, execute `/verify-chapter` on the Unit 17 corpus with `corpus/frozen-verification-response.md` substituted only for `execution-agent`'s external send. When the frozen response triggers the actual Step 3c correction pause, present the full packet and continue only after the operator replies `approved` for this current-HEAD run. Preserve the raw pre-correction and final chapter, complete verification report, capped handoff summary, checkpoints, unedited scorer result and provenance under `workflows/research-workflow/tests/s1-representative/`.

Check against the repository before running:

1. Record the exact current commit and verify the scratch canonical workflow files are byte-identical to that commit before the send-seam substitution. Distinguish later state/evidence commits from the S1 workflow source; do not infer provenance from the branch name.
2. Confirm the fixed-response substitution changes only the external send and leaves the post-S1 path-plus-capped-summary contract in force.
3. Confirm the current Step 3c packet and use the same `approved` convention as the baseline. Route A is not the per-run response and nothing is auto-approved.
4. Confirm the scored directory contains raw run artifacts. Do not normalize paths, backfill fields, copy the Unit 17 reference specimen over run output, or repair artifacts after scoring.

Boundary: exactly one current-HEAD `/verify-chapter` run in local scratch, plus durable evidence inside `workflows/research-workflow/tests/s1-representative/` and this state file. Current canonical source, agents, skills, plans, `tests/s1-relay/`, deployed projects and consuming-project data are read-only. Scratch substitution stays scratch-only and is never merged or propagated. Do not perform Part B or modify the scorer.

Required evidence:

- Exact current revision, scratch provenance and precise frozen-response substitution, showing only the send seam changed.
- The actual Step 3c packet and whether the operator supplied the explicit per-run `approved` response.
- Raw pre-correction and final chapter, complete verification report, capped summary, checkpoints and concise run record.
- The execution-agent handoff as observed: returned path, summary line/byte counts and absence of the full report body from the returned handoff.
- `score-specimen.sh --specimen DIR` output and exit code, with A0–A8 individually reported. Preserve a failure as evidence; do not weaken the scorer or repair run artifacts.
- Confirmation that the same corpus and frozen response used by the baseline were used unchanged, and that no external workflow network/API request, credential, client data, deployed-project write or billed API spend occurred.
- Files changed, commands and exit codes, runtime limitations, confirmation current canonical source stayed unchanged, and the commit containing the run evidence and hand-back.

Completion condition: one attended current-HEAD `/verify-chapter` run completes after the operator's explicit Step 3c response; raw artifacts and provenance are committed inside the representative-test boundary; full Part A produces a genuine pass or fail without post-hoc repair; current canonical workflow source remains unchanged; and the state hands back to Codex. A Part-A failure is a valid result and must be assessed, not converted into a pass within this run.

Stop and hand back if the exact revision or send seam cannot be established, external workflow network/API/credentials or client material are required, isolation cannot be maintained, any non-send behavior would have to change, or the operator declines or does not supply the Step 3c response. Do not expand into Part B, scorer changes or workflow fixes.

Capability subset: baseline local capabilities plus operator-authorized native workflow-agent execution and reversible local scratch isolation for Route A. Claude owns Git and the local commit. No external workflow network/API access, credentials, deployed-project writes, production action, propagation, destructive shared-state action, nested Claude/Codex CLI invocation or other operator-reserved capability is authorized.

Claude may challenge a false premise or stale direction with repository evidence; do not improvise around it.

## Blocker

None. The Step 3c packet was presented during execution and the operator supplied the explicit `approved` response for this current-HEAD run.

## Next action

Codex: assess Unit 19. The current-HEAD arm completed attended and Part A returned a genuine `FAIL (2 check(s))` at A3 and A7, preserved unrepaired. Decide (a) whether an honest Part-A failure whose cause is handoff-summary *surface form* — path and pairs correct, labels and line shape unparseable — closes this unit as valid evidence or reopens the S1 contract; (b) whether the under-specification is fixed in `execution-agent.md` (pin the summary's field labels and per-discrepancy line shape) or in the scorer's A3/A7 parse, noting this unit deliberately did not choose and that either is consistent with the evidence; (c) whether Part B may proceed on an arm whose chapter carries zero applied corrections against a baseline carrying three, or whether that asymmetry must first be resolved; and (d) how to route the second finding — Step 3a's blocking-input halt on the missing Evidence Pack, now corroborated from a second direction — given it is a caller-contract gap outside the S1 relay and is already a carried deferral.
