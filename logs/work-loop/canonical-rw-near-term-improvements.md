---
task: canonical-rw-near-term-improvements
status: active
turn: codex
---

## Objective and scope

Deliver Slice S1 of the operator-approved near-term plan: refactor the canonical Research Workflow's justified W4-H1–H4 content relays to path-passing or path-plus-capped-summary, preserve intentional context isolation and analytical meaning, and prove the plan's deterministic 100% seam coverage / 80% payload-reduction target plus its representative chapter regression. The task exits when S1 and its required proof are accepted. Approval-metadata synchronization, S0, S2–S11, deep-pipeline slimming, and deploy-fitness mission work remain outside this task.

## Lane and unit

Standard. Implementation mode. Unit 18 — capture the attended pre-S1 `/verify-chapter` baseline.

Named reason for the loop: S1 spans several bounded implementation and proof units, its canonical-workflow boundary must stay separate from propagation and adjacent programme work, and the aggregate deterministic and representative evidence must be independently assessed before S1 counts as complete.

## Latest result

Inspected (2026-08-18):

- Claim (1): HOLDS — `git cat-file -t f18ed58d…` returns `commit`. Scratch source extracted with `git archive f18ed58d… workflows/research-workflow`; provenance verified by blob hash, not asserted: all 150 regular files are byte-identical to tree `8e36dc1338e3bf4be6520acd2a894006e1be07f8`. The only divergence is the tree's 4 symlink entries under `.claude/commands/` (`consult`, `refinement-pass`, `session-plan`, `update-claude-md`), whose targets point outside the extracted subtree; none is on the `/verify-chapter` path. Cross-check: the scratch hashes of `verify-chapter.md` (`0a723154`) and `execution-agent.md` (`6b849c2c`) are exactly the pre-image hashes in `git diff f18ed58d HEAD` (`index 0a723154..d053127a`, `index 6b849c2c..26ba4b1c`). The substitution touched one seam only — `execution-agent`'s "Construct and send the API call" — with every other clause of the historical contract left in force.
- Claim (2): HOLDS, with one correction to how it is described. Step 3c is `PAUSE — Present all corrections to the operator`, and it fired because the frozen response carries three discrepancies. It specifies **no literal response token**: unlike `run-report` Step 4.2e, which defines `approved` as a two-end string contract with `citation-converter`, Step 3c defines none. The `approved` token used for this run is the brief's convention, not a contract read off the historical file. Recorded so no later reader mistakes it for one. `run-report` Step 4.2e was not invoked, nothing was auto-approved, and Route A was not treated as the per-run answer.
- Claim (3): HOLDS — the scored directory is the run's own output. No summary was synthesised, no checkpoint rewritten, no path normalised, and the scorer was not modified. `score-result.txt` is the unedited scorer output and exit code.
- Claim (4): HOLDS — artifacts common to both revisions are the chapter, the verification report and the two checkpoints; the capped summary exists only post-S1. Both the pre-correction and post-correction chapters are preserved, so what the corrections changed is inspectable rather than asserted.

Result: the attended pre-S1 baseline run completed. Step 1b produced no output and no pause. At Step 2.4 the delegated `execution-agent` **returned the full 46-line / 2251-byte response body** — the pre-S1 relay shape observed directly, not inferred from the instruction file — and wrote it verbatim to disk. Step 2.5 wrote the checkpoint from that body. At Step 3a `evidence-prose-fixer` was delegated with the chapter prose **as content**, which is how this revision hands it over, and returned three corrections with per-item bright-line metadata. All three tripped at least one bright-line trigger, so Group 1 was empty and all three went to the operator at the Step 3c pause with their triggers named. The operator replied `approved` on 2026-08-18. Three corrections applied, none rejected, none deferred; decisions log, corrections checkpoint and QC log written.

Part-A result, preserved unrepaired: `check A0: PASS`, `check A1: FAIL — missing required artifact (verification-summary)`, `verdict: FAIL (1 check(s))`, exit 1. **Classified as an expected historical-contract absence**, not a semantic or schema failure: at `f18ed58d` the agent returns the full response content and no capped-summary contract exists, so there is no artifact to produce. The absence is the pre-S1 state the comparison exists to record.

Finding for assessment — **A2–A8 did not run at all.** The scorer short-circuits after A1 because the later checks read artifacts A1 could not establish. That is correct behaviour, but it means Part A returned no semantic signal for the baseline arm, and the arm would have looked identical had claim IDs or verdict structure also been destroyed. The gate is all-or-nothing at A1. Not fixed here — changing the scorer is outside this unit and the brief forbids it — but Codex should decide whether Part A needs an arm-aware mode before the post-S1 run, or whether Part B carrying the semantic comparison is sufficient.

To keep the baseline arm from being silent on everything but a missing file, the equivalent facts were established by **direct inspection, explicitly not scorer output**, and recorded in the run README: report byte-identical to the frozen response; 10 of 10 claim IDs retained across three applied corrections, none dropped or invented; exactly one `Verdict:` line quoted identically in the checkpoint; 3 discrepancy blocks each carrying all four SOP fields; counts agreeing at 3 across report and checkpoint. **No unexpected loss of claim IDs, verdict/discrepancy structure or analytical content occurred.** One substantive detail: the historical checkpoint already carries `Output file path`, because Step 2.5 required it pre-S1 — so what S1 introduced at this seam is the capped summary and the "report body is not needed here" instruction, not the path itself.

Evidence:

- Commands and exit codes: `git archive` extraction plus 150-file blob-hash comparison → exact match; `check-claim-ids.sh` → exit 0, no stderr; `cmp` report vs frozen response → byte-identical; `bash score-specimen.sh --specimen runs/baseline-pre-s1/raw` → `verdict: FAIL (1 check(s))`, exit 1, captured verbatim in `runs/baseline-pre-s1/score-result.txt`.
- The Step 3c packet was presented in full — both groups, each fix quoted with its original and replacement text and its fired triggers — and the operator's `approved` was supplied for this run specifically. It was not inferred from Route A and nothing was applied before it.
- Files added: `workflows/research-workflow/tests/s1-representative/runs/baseline-pre-s1/` — `README.md` (run record and provenance), `score-result.txt`, and `raw/` holding the pre-correction chapter, the final chapter, the verification report, both checkpoints, and the three logs. Plus this state file.
- No canonical workflow source, agent, skill, plan, `tests/s1-relay/` file, deployed project or consuming-project artifact was modified; `git status` confirms. The scratch tree lives outside the repository and was never merged or propagated. No network request, API call, web fetch, credential, client material or billed spend occurred.
- Runtime limitation: token counts are recorded as `not exposed by the frozen-response harness` rather than invented, since the send seam was substituted.

Second deferral recorded, not acted on: `evidence-prose-fixer` reported unprompted that the Step 3a caller contract passes the skill, the verification report and the chapter prose but **not the Evidence Pack**, which the skill declares a blocking required input — so its corrections were generated against the verifier's characterisation of the evidence rather than the evidence rows. This corroborates the carried Evidence-Pack deferral from a direction not previously tested.

Unit 18's first brief was rejected correctly at state-only commit `f74ad5a79718f165f1a2cc69a36c179fd4d45c84`; no run or scratch change occurred. Claude established that the brief's Step 4.2e premise was false: at pre-S1 revision `f18ed58d6c96b0f97fc677fb7c90073336f310e4`, `run-report` Step 4.2e gates a chapter draft on a path that neither calls `/verify-chapter` nor consumes the frozen verification response. The representative semantic path is `/verify-chapter`; with the frozen three-discrepancy response, its actual attended gate is the conditional Step 3c corrections pause.

Codex accepts that repository finding and corrects the framing rather than asking Claude to build through it. Route A's objective and risk envelope are unchanged: use the local fixed-response `/verify-chapter` path twice and require the operator's explicit approval when the real correction packet appears. Replacing the erroneous step label with the actual halt is a technical correction inside the approved route, not a new capability, scope expansion or pre-approval of the per-run decision.

The pre-S1 arm is also not required to pass contracts introduced by S1. At `f18ed58d`, `execution-agent` returns the full verification response and has no capped-summary contract, so the raw baseline is expected to fail the new summary/path-related Part-A checks. That failure is valid comparison evidence. The current-HEAD arm must pass full A1–A8; Part B later compares the shared semantic artifacts—chapters, verification reports and supplied extracts—rather than pretending the historical arm already had S1's output shape. The scorer is not changed or weakened.

Unit 17 remains accepted at `ac522ac2b4c61af0b5a3eedd2e555ddadeb8d65f`; Unit 16 route discovery remains accepted at `83d26431c52eab2f10c276a01985d74302afaaf9`. Accepted deterministic position remains 40/40 seams accounted for, 27 converted and 13 justified, 0 violations/cap/ambiguous/unresolved, 99.824469% reduction, checker `TARGET MET`, harness 26/26.

Standing authorization: the operator selected Route A on 2026-08-18. It authorizes the local fixed-response scratch regression, both attended `/verify-chapter` runs, native workflow-agent execution, fresh independent semantic evaluation, and asking for the real per-run correction approval. It does not pre-supply the `approved` responses. It excludes client material, deployed-project writes, external workflow network/API calls, credentials, billed API spend, propagation, production deployment and deferred adjacent fixes.

Current position: approved plan Slice S1 → Unit 17 substrate accepted, Unit 18's false halt premise corrected, and the pre-S1 baseline arm now captured with its expected asymmetric Part-A result → the current-HEAD `/verify-chapter` arm and the fresh Part-B evaluation remain → run the post-S1 arm next against the same corpus and frozen response → this gives Part B two comparable chapters and verification reports produced under the two contracts.

Carried deferrals remain outside the task: missing Evidence Pack and verification-report relay at `verify-chapter` Step 3.7a; stale `reference/stage-instructions.md` writer-return wording; writer Reviewer Findings footer sequencing; README `Blast radius`; optional verification-summary truncation naming.

## Brief

This reissued unit captures the pre-S1 semantic baseline on the only historical path that consumes the frozen response and produces the chapter-verification evidence: `/verify-chapter`. It keeps the raw historical contract intact, including its expected failure of S1-era summary/path checks, and stops at the real corrections-approval packet rather than an unrelated `run-report` gate.

Required outcome: in a local isolated scratch environment at revision `f18ed58d6c96b0f97fc677fb7c90073336f310e4`, execute `/verify-chapter` on the Unit 17 corpus with `corpus/frozen-verification-response.md` substituted only for `execution-agent`'s external send. When the frozen three-discrepancy response triggers Step 3c, present the actual correction packet and continue only after the operator replies `approved` for this baseline run. Preserve the raw final chapter, verification report, any historical checkpoint artifacts, the unedited scorer result and enough provenance under `workflows/research-workflow/tests/s1-representative/` for later comparison.

Check against the repository before running:

1. Confirm the baseline SHA and scratch source provenance, and confirm the fixed-response substitution changes only the external send seam.
2. Confirm the actual historical Step 3c packet and exact response required to continue. Do not invoke `run-report` Step 4.2e, auto-approve, or treat Route A as the per-run answer.
3. Confirm the output supplied to the scorer is raw historical output. Do not add a summary, rewrite a checkpoint, normalize paths, or otherwise backport the post-S1 contract.
4. Establish which artifacts are common to both revisions and preserve the final corrected chapter plus complete verification report for Part B. Preserve any pre-correction chapter needed to show what the correction changed.

Boundary: exactly one baseline `/verify-chapter` run, local scratch only, plus durable evidence inside `workflows/research-workflow/tests/s1-representative/` and this state file. Current canonical workflow source, agents, skills, plans, `tests/s1-relay/`, deployed projects and consuming-project data are read-only. Scratch substitution stays scratch-only and is never merged or propagated.

Required evidence:

- Exact revision, scratch provenance and precise frozen-response substitution, showing only the external send seam changed.
- The actual Step 3c packet and whether the operator supplied the exact per-run `approved` response.
- Raw pre-correction and final chapter where both exist, complete verification report, historical checkpoint artifacts, and a concise run record.
- `score-specimen.sh --specimen DIR` output and exit code, preserved without repair. Classify each failure as an expected historical-contract absence or an unexpected semantic/schema failure; do not alter artifacts or scorer to change the result.
- Confirmation that no external workflow network/API request, credential, client data, deployed-project write or billed API spend occurred and current canonical source remained unchanged.
- Files changed, commands and exit codes, runtime limitations, and the commit containing the run evidence and hand-back.

Completion condition: one attended baseline `/verify-chapter` run completes after the operator's explicit Step 3c response; raw semantic artifacts and provenance are committed inside the representative-test boundary; the unmodified Part-A result is recorded as pass or fail with exact failing checks; current canonical workflow source remains unchanged; and the state hands back to Codex. Expected failure of S1-introduced summary/path checks does not invalidate the baseline. An unexpected loss of claim IDs, verdict/discrepancy structure or analytical content is handed back as a real finding.

Stop and hand back if the baseline or send seam cannot be established, external workflow network/API/credentials or client material are required, isolation cannot be maintained, any non-send historical behavior would have to change, or the operator declines or does not supply the Step 3c response. Do not expand into current `HEAD`, Part B, scorer changes or workflow fixes.

Capability subset: baseline local capabilities plus operator-authorized native workflow-agent execution and reversible local scratch isolation for Route A. Claude owns Git and the local commit. No external workflow network/API access, credentials, deployed-project writes, production action, propagation, destructive shared-state action, nested Claude/Codex CLI invocation or other operator-reserved capability is authorized.

Claude may challenge a false premise or stale direction with repository evidence; do not improvise around it.

## Blocker

None. The Step 3c correction decision was presented in full and the operator supplied `approved` for this run on 2026-08-18.

## Next action

Codex: assess Unit 18. The baseline arm is captured, its Part-A failure is the expected historical-contract absence rather than a semantic loss, and the raw artifacts plus provenance are committed. Judge whether the provenance evidence is strong enough to anchor the comparison, whether classifying the A1 failure as expected is right, and whether the direct-inspection table is an acceptable stand-in for the checks the A1 short-circuit prevented from running.

Then decide one thing before opening the post-S1 arm: **Part A returned no semantic signal for the baseline arm**, because the scorer stops at A1 and the pre-S1 contract cannot produce the summary artifact. The arm would have scored identically had claim IDs or verdict structure also been destroyed. Either accept that Part B carries the semantic comparison and Part A judges only the post-S1 arm, or open a unit to give Part A an arm-aware mode. Changing the scorer was outside this unit and the brief forbade it, so nothing was done to it.

Two deferrals stand recorded and unimplemented: the Step 3a Evidence-Pack gap corroborated by this run, and the GF1-C01 date-capture branch left open in the corrections checkpoint. Carried deferrals otherwise unchanged.
