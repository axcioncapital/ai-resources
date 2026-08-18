---
task: canonical-rw-near-term-improvements
status: active
turn: codex
---

## Objective and scope

Deliver Slice S1 of the operator-approved near-term plan: refactor the canonical Research Workflow's justified W4-H1–H4 content relays to path-passing or path-plus-capped-summary, preserve intentional context isolation and analytical meaning, and prove the plan's deterministic 100% seam coverage / 80% payload-reduction target plus its representative chapter regression. The task exits when S1 and its required proof are accepted. Approval-metadata synchronization, S0, S2–S11, deep-pipeline slimming, and deploy-fitness mission work remain outside this task.

## Lane and unit

Standard. Implementation mode. Unit 18 — capture the attended pre-S1 baseline run.

Named reason for the loop: S1 spans several bounded implementation and proof units, its canonical-workflow boundary must stay separate from propagation and adjacent programme work, and the aggregate deterministic and representative evidence must be independently assessed before S1 counts as complete.

## Latest result

Unit 18 did not begin. A load-bearing premise is false; nothing was run, and no file outside this state file was created or changed.

Inspected (2026-08-18):

- Claim (1): HOLDS — `git cat-file -t f18ed58d6c96b0f97fc677fb7c90073336f310e4` returns `commit`, and `bash workflows/research-workflow/tests/s1-representative/score-specimen.sh --check-baseline` returns `check A0: PASS ... resolves to a commit in this repository`, `verdict: PASS`, exit 0. The SHA in `expected/baseline-revision.txt` and the SHA in the brief are the same value.
- Claim (2): HOLDS as far as the seam goes — `git diff f18ed58d HEAD` on `.claude/agents/execution-agent.md` and `.claude/commands/verify-chapter.md` shows the S1 change is exactly the scored seam. At f18ed58d the agent's job line reads `Return the full response content`; at `HEAD` it reads `Return the full response's path on disk ... plus the handoff summary below, capped at 20 lines and 4 KB`. The external send is a single line in the agent (`Construct and send the API call`), reached from `/verify-chapter` Step 2.4, so a scratch-only substitution of the frozen response has one seam and does not require touching any other historical behaviour.
- Claim (3): **FALSE** — searched `git show f18ed58d:workflows/research-workflow/.claude/commands/run-report.md` for `verify-chapter` and `verification`: the only match is line 102, style-reference verification, which has nothing to do with fact verification. Searched the same historical `/verify-chapter` for `4.2e`: no match; its steps are 1, 1b, 2, 3, 4 and there is no Step 4.2e on it. Searched `git show f18ed58d:workflows/research-workflow/reference/stage-instructions.md` for `verify-chapter`: the only match is line 212, `Applies at: Step 4.2, Step 5.2, Step 5.7, and /verify-chapter` — the bright-line rule's surface list, which names `/verify-chapter` **alongside** the numbered steps rather than inside them. The Stage 4 sequence at that revision runs 4.1 → 4.7 and contains no fact-verification step. The attended path that produces the four artifacts `expected/required-artifacts.txt` names, and that consumes `corpus/frozen-verification-response.md`, is `/verify-chapter`, and it never reaches `run-report` Step 4.2e.
- Claim (4): NOT REACHED — raw-versus-repaired artifacts cannot be judged before a run exists, and no run was started.

What is true about Step 4.2e, so the correction does not overshoot: it exists and it is unconditional. `git show f18ed58d:.../run-report.md` line 74 reads `**e. PAUSE — Operator review of chapter draft (Step 4.1b, blocking).** Emit verbatim, then HALT:`, and the following prose states `The halt is unconditional — no timeout, no auto-approve.` It gates the chapter *draft* before citation conversion, and its artifacts are the draft, review report, chapter checkpoint, approval marker, revised draft, cited file and CTL. None of those is a scored role, and Step 4.2e consumes no verification response.

The halts that do exist on the scored path at f18ed58d are both conditional: Step 1b pauses only when `check-claim-ids.sh` emits `INVARIANT WARNING`, and Step 3c pauses only `if discrepancies found`. With the frozen response carrying three discrepancies, Step 3c would in fact fire — but it is a corrections-approval halt, not the chapter-draft-approval halt, and it is conditional by construction rather than unconditional.

Unit 17 accepted at commit `ac522ac2b4c61af0b5a3eedd2e555ddadeb8d65f`. The representative substrate is semantically real enough for the approved comparison: its synthetic chapter carries 10 stable claim IDs, sourced findings separated from interpretation, explicit hedges and scarcity handling, plus three planted faults matched by SOP-shaped verification discrepancies. Part A's A1–A8 checks cover artifact presence, fixed-response persistence, path relay, claim-ID identity, verdict/discrepancy structure and accounting, and the 20-line / 4-KB cap. Part B is sufficiently bounded for a fresh evaluator: six semantic dimensions each require a `PRESERVED`, `DEGRADED` or `UNCLEAR` judgment with sentence-level evidence and one overall verdict; AI-prose byte identity is explicitly excluded.

Claude reported 30/30 asserted scorer cases, a passing valid specimen and baseline check, and the unchanged deterministic S1 suite at `TARGET MET` plus 26/26. Those checks were not rerun at assessment because the evidence is internally consistent and failing-capable. Direct repository inspection confirmed the Unit 17 commit, corpus and rubric. Accepted limitation: A2's byte identity applies only to Route A's frozen response and does not govern a live API run.

Accepted deterministic position remains 40/40 named seams accounted for; 27 converted and 13 explicitly justified; 0 violations/cap/ambiguous/unresolved; 99.824469% reduction. Unit 16's route discovery remains accepted at `83d26431c52eab2f10c276a01985d74302afaaf9`.

Standing authorization: the operator selected Route A on 2026-08-18. It authorizes the local fixed-response scratch regression, the two attended pre/post runs, native workflow-agent execution needed by those runs, a fresh independent evaluation of analytical meaning, and asking the operator for the required `approved` response at each run's Step 4.2e halt. It does not pre-supply those two responses. It excludes client material, deployed-project writes, external workflow network/API calls, credentials, billed API spend, propagation, production deployment and deferred adjacent fixes.

Current position: approved plan Slice S1 → Unit 17 representative substrate accepted → deterministic proof and the comparison contract are complete → Unit 18 handed back before starting because its attended-halt premise does not hold on the scored path → the pre-S1 and post-S1 attended runs plus fresh Part-B evaluation still remain, and the baseline run needs its halt re-specified before it can be opened again.

Nothing was executed, no scratch checkout was made, no substitution was applied, and no adjacent improvement was noticed during this inspection. Carried deferrals remain outside the task: missing Evidence Pack and verification-report relay at `verify-chapter` Step 3.7a; stale `reference/stage-instructions.md` writer-return wording; writer Reviewer Findings footer sequencing; README `Blast radius`; optional verification-summary truncation naming.

## Brief

This unit produces the first of the two authorized comparison artifacts: one attended run of the representative chapter path at the recorded pre-S1 revision. It is separated from the current-HEAD run and independent evaluation so one unit carries one run, one mandatory operator halt and one evidence set.

Required outcome: execute the Route A representative one-chapter path at revision `f18ed58d6c96b0f97fc677fb7c90073336f310e4`, using the Unit 17 corpus as input and `corpus/frozen-verification-response.md` as the stand-in only at `execution-agent`'s external network-send seam. Preserve the run's unedited output artifacts and enough provenance under `workflows/research-workflow/tests/s1-representative/` for `score-specimen.sh --specimen DIR` to reproduce the Part-A judgment later. Do not run current `HEAD` or perform Part B.

Check against the repository before running:

1. Confirm the baseline SHA resolves and matches `expected/baseline-revision.txt`; establish that the scratch workflow source is exactly that revision before applying the fixed-response substitution.
2. Inspect the historical `run-report`, `verify-chapter` and `execution-agent` path and establish the minimum scratch-only substitution needed to replace the external send with the frozen response. Record it precisely. Stop if the run would require changing any other historical behavior or current canonical workflow source.
3. Confirm the attended path reaches `run-report` Step 4.2e and that it is an unconditional operator halt. Route A authorizes asking but is not the per-run response: present the actual packet and continue only if the operator replies `approved` for this baseline run.
4. Confirm the scored output contains raw run artifacts, not normalized or manually repaired copies. If the historical workflow emits a materially different contract that the scorer cannot assess, return that evidence rather than adapting artifacts after the fact.

Boundary: one baseline run in a local isolated scratch environment, plus durable evidence inside `workflows/research-workflow/tests/s1-representative/` and this state file. Current canonical workflow source, agents, skills, plans, `tests/s1-relay/`, deployed projects and consuming-project data are read-only. Temporary baseline checkout or fixed-response substitution stays scratch-only and is never merged or propagated.

Required evidence:

- Exact baseline revision, scratch provenance and precise fixed-response substitution, showing only the external send seam was replaced.
- The Step 4.2e packet presented to the operator and whether the exact per-run `approved` response was supplied. Never auto-approve or infer it from Route A.
- A complete unedited scorer-consumable output directory and concise provenance/run record inside the representative-test boundary.
- `score-specimen.sh --specimen DIR` output and exit code. A failure is preserved and reported; historical output is not repaired and the scorer is not weakened.
- Confirmation that no external workflow network/API request, credential, client data, deployed-project write or billed API spend was used, and current canonical workflow source remained unchanged.
- Files changed, commands and exit codes, material runtime limitations, and the commit containing the run evidence and state hand-back.

Completion condition: exactly one pre-S1 attended run completes after the operator's explicit Step 4.2e response; raw artifacts and provenance are committed inside the representative-test boundary; Part A produces a real pass or fail without post-hoc repair; current canonical workflow source remains unchanged; and the state file hands back to Codex. A genuine Part-A failure is a valid result, not an invitation to convert the fixture into a pass.

Stop and hand back if the baseline or fixed-response seam cannot be established, if external network/API/credentials or client material are required, if isolation cannot be maintained, if any non-send historical behavior would have to change, or if the operator does not supply the per-run `approved` response. Do not expand into current `HEAD` or Part B.

Capability subset: baseline local capabilities plus operator-authorized native workflow-agent execution and reversible local scratch isolation for Route A. Claude owns Git and the local commit. No external workflow network/API access, credentials, deployed-project writes, production action, propagation, destructive shared-state action, nested Claude/Codex CLI invocation or other operator-reserved capability is authorized.

Claude may challenge a false premise or stale direction with repository evidence; do not improvise around it.

## Blocker

Claim (3) is false, and it is load-bearing three times over: the brief's premise check, its required evidence ("The Step 4.2e packet presented to the operator"), and its completion condition ("exactly one pre-S1 attended run completes after the operator's explicit Step 4.2e response") all rest on it.

The finding: at `f18ed58d`, `run-report` Step 4.2e and `/verify-chapter` are on disjoint paths. Step 4.2e is real and is unconditional, but it lives inside `run-report` Step 4.2, gates the chapter draft before citation conversion, and produces none of the four scored artifact roles. The run that produces those roles — and the only run that consumes `corpus/frozen-verification-response.md` — is `/verify-chapter`, which has no Step 4.2e, is absent from the Stage 4 sequence in `stage-instructions.md`, and is never invoked by `run-report`. Searches and line references are in the inspection record above.

Consequence: the unit cannot complete as briefed. Its completion condition is unsatisfiable on the scored path, and its stop clause ("if the operator does not supply the per-run `approved` response") names a gate that path does not have. Substituting the Step 3c corrections PAUSE for Step 4.2e would be repairing the brief rather than reporting it, and it would swap an unconditional halt for a conditional one — which also touches the standing Route A authorization, whose wording binds the operator's `approved` response to "each run's unconditional Step 4.2e halt".

A second, separable observation for the same decision, recorded rather than acted on: at `f18ed58d` the execution agent returns the full response content and no capped-summary contract exists, so a faithful pre-S1 run cannot produce the `verification-summary` role at all and would fail check A1 by construction. That may be exactly the intended finding — the seam did not exist before S1 — but it means the baseline arm's Part-A result is knowable in advance, and whether that still counts as the comparison the plan asked for is a framing call, not an execution detail. It is not implemented or worked around here.

## Next action

Codex: decide which attended halt the baseline run is actually gated on, then reissue Unit 18. Three things need settling, and all three are yours rather than Claude's because they touch the run's shape and the standing authorization's wording:

1. Whether the representative run is `/verify-chapter` alone — in which case name the real halt (Step 3c is the only one that fires with the frozen response, and it is conditional) and reconcile that with the Route A authorization's "unconditional Step 4.2e halt" phrasing.
2. Or whether the run is the wider Stage 4 chapter path through `run-report` Step 4.2, in which case Step 4.2e applies but the scored artifact roles and the frozen fact-verification response do not, and Unit 17's accepted substrate would need a different scored contract.
3. Whether a pre-S1 arm that fails A1 by construction is the intended baseline result, or whether Part A should be scored asymmetrically for the baseline arm.

If any of these changes the approved scope or the authorization's terms rather than just the brief's wording, that is an operator decision under core § 7, not a rewrite.
