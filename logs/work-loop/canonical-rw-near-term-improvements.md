---
task: canonical-rw-near-term-improvements
status: active
turn: codex
---

## Objective and scope

Deliver Slice S1 of the operator-approved near-term plan: refactor the canonical Research Workflow's justified W4-H1–H4 content relays to path-passing or path-plus-capped-summary, preserve intentional context isolation and analytical meaning, and prove the plan's deterministic 100% seam coverage / 80% payload-reduction target plus its representative chapter regression. The task exits when S1 and its required proof are accepted. Approval-metadata synchronization, S0, S2–S11, deep-pipeline slimming, and deploy-fitness mission work remain outside this task.

## Lane and unit

Standard. Discovery mode. Unit 21 — fresh independent Part-B semantic evaluation.

Named reason for the loop: S1 spans several bounded implementation and proof units, its canonical-workflow boundary must stay separate from propagation and adjacent programme work, and the aggregate deterministic and representative evidence must be independently assessed before S1 counts as complete.

## Latest result

Inspected (2026-08-18):
- Claim (1): HOLDS — the brief asserts `workflows/research-workflow/tests/s1-representative/rubric.md` carries a Part B with a section naming the artifacts the evaluator receives; read the file, found `## Part B — preserved analytical meaning at the S1 relay boundary (a fresh evaluator decides)` at line 64 and `### The artifacts the evaluator receives, and no others` at line 73, listing three tables of twelve paths.
- Claim (2): HOLDS — the brief rests on every artifact that section names being available; tested all twelve paths under `workflows/research-workflow/tests/s1-representative/` with `[ -f ] && [ -s ]`; all twelve are regular non-empty files (corpus 4472/2600/2241/1129/2251 bytes; baseline-pre-s1 raw 4472/2251/1476; current-head-post-s1 raw 4472/2251/609/751).
- Claim (3): HOLDS — the brief requires an evaluator that did not participate in Units 16–20; searched this session's spawned-subagent list before dispatch (`ListAgents`) and found no in-process subagents at all, only unrelated peer interactive sessions, so the dispatched agent carried no Unit 16–20 context by construction.

Result: Unit 21 is complete. One fresh context-isolated evaluator returned all eight Part-B judgments and one overall verdict of **PRESERVED**, from the twelve allowed artifacts and nothing else. Only this state file changed.

Evidence — evaluator identity and input boundary: a single `general-purpose` subagent pinned to `opus`, agent id `a4a6379fa49fff7c7`, the first and only subagent this session spawned (12 tool uses, 63,205 tokens, 78.9s). Its prompt contained rubric Part B verbatim plus the twelve absolute artifact paths, and explicitly withheld the S1 diff, implementation plan, this state file, both run READMEs, scorer code and results, prior assessments, and any statement of an expected verdict. It was instructed not to run `git`, not to glob or grep across directories, and not to read `reference/quality-standards.md` (named inside judgment 6 but outside the permitted set) — answering UNCLEAR instead where the supplied artifacts could not settle a judgment, and never rounding UNCLEAR to PRESERVED. Its self-reported `Files read:` list names exactly those twelve paths and no others, consistent with its 12 tool uses. No prohibited context was supplied, and none was reported read.

The complete returned judgment, verbatim:

> Judgment 1 — Report fidelity through the path: PRESERVED — `runs/current-head-post-s1/raw/1.1-chapter-01-verification.md` reproduces the frozen reply in full (verdict line through the closing "§ 1.3 scarcity paragraph... is not flagged" sentence) with no truncation or paraphrase, and its filename matches the `report/chapters/1.1/1.1-chapter-01-verification.md` path carried in both the handoff summary and the checkpoint's "Output file path" field.
>
> Judgment 2 — Verdict, count and pair preservation: PRESERVED — the post-S1 checkpoint's "Verdict: DISCREPANCIES FOUND", "Discrepancy count: 3", and the three lines "Q1-C02 — Overstated", "Q1-C04 — Category-leakage", "GF1-C01 — Undated" quote the report's verdict line, count line, and each discrepancy's Claim ID / Issue type fields without altering an attribution or a type label.
>
> Judgment 3 — Summary sufficiency: PRESERVED — the checkpoint states the verdict, the count, the three flagged claim IDs with their issue types, and concludes "Next: Step 3 correction pass, since discrepancies were found", which settles both the enter-or-not decision and the which-claims scope; the claim text, recommended corrections and the "Claims checked and not flagged" roster are explicitly deferred to the named path rather than lost.
>
> Judgment 4 — Compression without unsupported implication: PRESERVED — the checkpoint adds only "Response status: OK" and "No field was reported absent, and no API failure was reported", both supported by the summary's status line, and it states outright that "The verification report body was not returned to this session and was not read into it" rather than implying it holds detail it does not.
>
> Judgment 5 — Claim-ID and attribution integrity: PRESERVED — the post-S1 pre-correction chapter carries all ten IDs (Q1-C01–C05, Q2-C01–C04, GF1-C01) with figures matching their extract rows (e.g. Q1-C05's "92–101% of NAV" on four of eleven; GF1-C01's undated Forum guidance), and is identical to the corpus chapter as verified; the two sentences whose IDs do not support them (the Q1-C02 average-deal-size clause, the Q1-C04 "every manager" clause) are present identically in the corpus input and are precisely Discrepancies 1 and 2 the report flags, not boundary losses.
>
> Judgment 6 — Evidence/interpretation separation: PRESERVED — § 1.2 retains its standing notice "The reading below is interpretation... no sentence in this section should be read as a sourced finding" and its inference verbs ("is consistent with", "suggests"), matching the report's own finding that "The separation of § 1.1 (evidence) from § 1.2 (interpretation) holds for every sentence except Discrepancy 1".
>
> Judgment 7 — Hedging and scope: PRESERVED — "Pricing disclosure is thin" and "rests on four observations and should be treated as indicative only" survive intact, as does "The LP panel [Q2-C01, Q2-C02] is self-selected and its response base is not published... it does not support point estimates"; the adviser-concentration sentence's slide past market-level scope is byte-identical to the corpus chapter and is flagged as Discrepancy 2, so no confidence rose at the boundary.
>
> Judgment 8 — Scarcity handling: PRESERVED — § 1.3 still reads "That the pipeline did not find fee disclosure is a statement about the search, not a finding that fees were undisclosed", with the SCOPE CAVEAT framing unchanged.
>
> Overall verdict: PRESERVED — the report on disk in the post-S1 arm is complete and is the one the checkpoint names; the verdict, count and all three (Claim ID, Issue type) pairs reach the caller's record unaltered; the record is sufficient to enter the correction pass on the right three claims; and the chapter at the verification boundary is unchanged from the corpus chapter in IDs, attributions, evidence/interpretation split, hedges and scarcity framing. The only material difference from the pre-S1 caller record is that per-discrepancy claim text and recommended corrections now sit behind the returned path instead of inline in the checkpoint — the rubric's own criterion treats path-deferred detail as retained, and the checkpoint labels the deferral explicitly rather than papering over it.

Evidence — files changed: `git status --porcelain` after the evaluation and before commit shows only `logs/work-loop/canonical-rw-near-term-improvements.md` modified by this unit, alongside the pre-existing untouched `logs/friction-log.md` change. No workflow source, agent, skill, plan, test, scorer, raw run artifact or deployed project changed; the rubric was not adjusted after seeing the result, no attended arm was rerun, no second evaluator was commissioned, and the Evidence Pack gap was not fixed. This evidence could have failed: the evaluator was free to return DEGRADED or UNCLEAR on any of the eight judgments and was explicitly told both are legitimate, and a prohibited read would have shown as an extra path in its `Files read:` list or an extra tool use.

Prior accepted position, unchanged: Unit 20 at `2b9770facad4f19f1041f907962f7e1db278f956`; Unit 19 at `c227411505b51c93ac7fa5e7cf7d717dda58debc`; Unit 18 at `5d439aa0726dfedd4a9fe6ddf7103806207af366`; Unit 17 at `ac522ac2b4c61af0b5a3eedd2e555ddadeb8d65f`; Unit 16 at `83d26431c52eab2f10c276a01985d74302afaaf9`. Deterministic proof stands at 40/40 seams accounted for, 27 converted and 13 justified, 0 violations/cap/ambiguous/unresolved, 99.824469% reduction, checker `TARGET MET`, scorer harness 38/38 after Unit 20's correction.

Current position: approved plan Slice S1 → deterministic proof accepted, both raw representative arms captured, corrected Part A passes the untouched post-S1 arm, and the fresh independent Part-B semantic verdict is now returned as PRESERVED → the aggregate S1 evidence set is complete and awaits Codex's assessment.

Deferral noticed during this unit, recorded and not done: rubric judgment 6 cites `reference/quality-standards.md` as its standard, but that file is not in Part B's permitted artifact set, so a strictly-bounded evaluator cannot apply the cited standard directly. This unit resolved it by instructing the evaluator to judge on the ordinary meaning of the term and answer UNCLEAR if unsettleable, rather than widening the input set. Whether the rubric should add the file to the permitted set or drop the citation is a rubric edit, and the brief forbids adjusting the rubric after seeing the result — so it is left for Codex.

Carried deferrals remain outside the task: missing Evidence Pack and verification-report relay at `verify-chapter` Step 3.7a; stale `reference/stage-instructions.md` writer-return wording; writer Reviewer Findings footer sequencing; README `Blast radius`; optional verification-summary truncation naming; baseline GF1-C01 date capture; optional future pinning of execution-agent summary surface syntax. The pre-existing uncommitted `logs/friction-log.md` change remains outside and untouched.

## Brief

This final proof unit asks a fresh evaluator—not any actor that built S1, the corpus, the scorer, or the two runs—whether the path-plus-capped-summary relay preserved analytical meaning at the valid verification boundary. It is evidence-only: no proof artifact, workflow source or raw run output changes, and a non-PRESERVED verdict is returned honestly rather than repaired inside the evaluation.

Named unknown: under `rubric.md` Part B and only the permitted artifacts, is analytical meaning across the S1 verification relay `PRESERVED`, `DEGRADED` or `UNCLEAR`?

Required evaluation procedure:

1. Invoke one fresh native evaluator sub-agent that did not participate in Units 16–20. Do not use the implementing Claude session's own judgment as a substitute.
2. Give that evaluator only `workflows/research-workflow/tests/s1-representative/rubric.md` Part B and the exact artifact paths listed there under “The artifacts the evaluator receives, and no others.” Do not supply the S1 diff, implementation plan, this state file, either run README, scorer code/results, prior assessments, expected verdict or any explanation of what should pass.
3. The evaluator must answer judgments 1–8 individually with `PRESERVED`, `DEGRADED` or `UNCLEAR` and one sentence naming the specific artifact, field or sentence relied on, then give one overall verdict under the rubric. It must not consult anything outside the supplied set or round `UNCLEAR` to `PRESERVED`.
4. Record the evaluator's complete returned judgment verbatim in this state file, together with enough execution evidence to establish that it was a fresh sub-agent and received only the allowed inputs. Do not create a second evaluation file or edit the evaluator's wording.

Boundary: evaluation and this task state file only. The evaluator is read-only over the exact allowed artifacts. No workflow source, agent, skill, plan, test, scorer, raw run artifact, deployed project, consuming-project data or other repository file may change. Do not fix the Evidence Pack gap, adjust the rubric after seeing the result, rerun an attended arm, or commission a second evaluator.

Required evidence:

- Fresh evaluator identity/session evidence and the exact input boundary it received.
- Confirmation that no prohibited context was supplied or read.
- The complete eight judgments and overall verdict verbatim.
- Files changed, confirmation only this state file changed, and the commit containing the evaluation hand-back.

Completion condition: one fresh evaluator returns all eight rubric judgments and one overall verdict from only the allowed artifacts; the complete result is committed verbatim in this state file; no other file changes; and the state hands back to Codex. `DEGRADED` or `UNCLEAR` is a valid unit result and must not trigger repair or a second opinion inside this unit.

Stop and hand back without self-evaluating if a fresh evaluator cannot be invoked, the input boundary cannot be enforced, any required artifact is unavailable, the evaluator seeks prohibited context, or the result omits a required judgment. Do not widen the input set or repeat the evaluation.

Capability subset: baseline read-only inspection plus the operator-authorized one fresh native evaluator invocation and Claude-owned commit of this state file. No network/API, credentials, deployed-project write, propagation, production action, destructive shared-state action, nested Claude/Codex CLI invocation or other operator-reserved capability is authorized.

Claude may challenge a false premise or stale direction with repository evidence; do not improvise around it.

## Blocker

None.

## Next action

Codex: assess Unit 21. The fresh independent Part-B evaluation returned PRESERVED on all eight judgments and overall, from the twelve allowed artifacts only, with no other file changed. Decide whether the aggregate S1 evidence — deterministic seam/payload proof, corrected Part A on the untouched post-S1 arm, and this Part-B verdict — satisfies the task's exit condition, and whether the rubric judgment-6 citation deferral recorded above is accepted as a deferral or reopened as its own unit.
