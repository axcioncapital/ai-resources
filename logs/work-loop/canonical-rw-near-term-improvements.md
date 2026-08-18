---
task: canonical-rw-near-term-improvements
status: active
turn: codex
---

## Objective and scope

Deliver Slice S1 of the operator-approved near-term plan: refactor the canonical Research Workflow's justified W4-H1–H4 content relays to path-passing or path-plus-capped-summary, preserve intentional context isolation and analytical meaning, and prove the plan's deterministic 100% seam coverage / 80% payload-reduction target plus its representative chapter regression. The task exits when S1 and its required proof are accepted. Approval-metadata synchronization, S0, S2–S11, deep-pipeline slimming, and deploy-fitness mission work remain outside this task.

## Lane and unit

Standard. Implementation mode. Unit 17 — build the representative proof substrate.

Named reason for the loop: S1 spans several bounded implementation and proof units, its canonical-workflow boundary must stay separate from propagation and adjacent programme work, and the aggregate deterministic and representative evidence must be independently assessed before S1 counts as complete.

## Latest result

Inspected (2026-08-18):

- Claim (1): HOLDS — `git log --oneline -- workflows/research-workflow/` plus `git show --stat` on each candidate. The first commit that converted canonical workflow source under S1 is `17cc5726` (Unit 2, six W4-H4 reference-document relays, touching `.claude/commands/run-cluster.md` and `run-execution.md`). The earlier S1 commit `7e2b97a6` is excluded by inspection: its stat lists only `logs/work-loop/canonical-rw-near-term-improvements.md` and 56 files under `workflows/research-workflow/tests/s1-relay/`, and no command, agent or skill. `git rev-parse 17cc5726^` returns `f18ed58d6c96b0f97fc677fb7c90073336f310e4`, a single-parent-visible merge of origin/main that deleted `.claude/commands/inject-dependency.md` and its shared-manifest entry — a non-S1 change and the state the first conversion was applied to. The boundary is unambiguous.
- Claim (2): HOLDS — read `tests/s1-relay/make-fixture.sh` in full: every fixture file is emitted by one `emit()` helper writing fixed-width `L%04d ... filler body line for deterministic byte accounting.` lines, and its header states byte stability is load-bearing and asserted by harness T7. Searched `tests/s1-relay/fixture/` for `C[0-9]{2}-|claim[ -]id|Claim ID` — no file matched; `grep -c 'CLAIM|Claim' fixture/gpt5-verification-response.md` returned 0. The fixture carries no claim IDs, no verdict and no discrepancy structure. Nothing under `tests/s1-relay/` was modified, read at run time, or referenced by the new substrate; `git status --porcelain s1-relay/` after the unit returns empty.
- Claim (3): HOLDS — the state file's description was treated as a premise, not authority, and the live contracts were read: `.claude/commands/verify-chapter.md` (Step 2.4 output path plus 20-line/4-KB summary cap; Step 2.5 checkpoint carries path, discrepancy count, discrepancy summary, verdict, and not the body), `.claude/agents/execution-agent.md` (verbatim write to the caller-specified file; the five required summary fields; "the cap is hard and always wins"), `reference/sops/fact-verification-prompt.md` (per-discrepancy Claim / Claim ID / Issue type from a five-value closed set / Recommended correction; `APPROVED` when none), `reference/quality-standards.md` § Claim ID Invariant (`Q[n]-C[##]`, `GF[cluster]-C[##]`), `.claude/hooks/check-claim-ids.sh`, `reference/stage-instructions.md` Steps 2.3 and 3.S3, and `reference/file-conventions.md` rows 59 and 67 for the chapter and checkpoint path shapes. The substrate encodes the minimum those contracts require and invents no field.

Result: Unit 17 is complete. `workflows/research-workflow/tests/s1-representative/` now holds the representative proof substrate — 16 new files, nothing else touched. `corpus/` carries the semantically real one-chapter input set: a chapter with 10 stable claim IDs, evidence separated from interpretation, hedges and a scarcity paragraph; two Pass-2 extracts and one Step-3.S3 gap-fill extract supplying those IDs with source-quality fields; and `frozen-verification-response.md`, the fixed stand-in for the GPT-5 reply carrying a verdict, a stated count and three SOP-shaped discrepancy blocks (`Q1-C02` Overstated, `Q1-C04` Category-leakage, `GF1-C01` Undated) against three faults planted in the chapter for them to find. `specimen/` is the reference valid run output: chapter, verbatim verification report, 9-line handoff summary, and Step-2.5 checkpoint. `expected/` records the pre-S1 revision with its derivation, the 10 claim IDs, and the four required artifact roles. `rubric.md` separates Part A (the eight deterministic checks) from Part B (what the fresh evaluator judges), and states in terms that byte identity of AI prose is not a criterion. All corpus entities, sources and figures are invented and labelled as such in-file and in the README; the analytical structure is real because that is what the regression tests.

Evidence:

- `bash score-specimen.test.sh` → `harness: 30/30 cases behaved as asserted`, exit 0. It mutates a throwaway copy of the reference specimen once per case. Every named negative-control class fails, by check: missing artifact and empty artifact (A1, T2–T3); dropped relay path, divergent summary/checkpoint paths, and a path naming the wrong artifact (A3, T7–T9); dropped claim ID `Q2-C03` and invented claim ID `Q9-C42` (A4, T10–T11); absent report verdict, `APPROVED` alongside three discrepancies, and summary/checkpoint verdicts diverging from the report (A5, T12–T15); missing Issue type, an issue type outside the SOP's closed set, an unknown discrepancy claim ID, a blank Claim ID, and a missing Recommended correction (A6, T16–T20); count and pair-set mismatches across report, summary and checkpoint (A7, T21–T24); 24-line and 25,464-byte summaries against the 20-line / 4096-byte cap (A8, T25–T26). Two further classes are covered that the brief did not name: a paraphrased and a truncated verification report (A2, T5–T6) against `execution-agent.md`'s verbatim-write rule, and a manifest role the scorer does not know (A1, T4).
- `bash score-specimen.sh` on the complete valid specimen → A0–A8 all PASS, `verdict: PASS`, exit 0. `bash score-specimen.sh --check-baseline` → PASS, exit 0.
- The failing-capable property was proved by finding a real defect with it, not asserted: T16 and T19 initially passed for the wrong reason. Tab-delimited awk output fed to bash `read` collapsed runs of IFS whitespace, so an empty field shifted every field after it and a blank `Claim ID` was reported as a missing `Recommended correction`. The separator is now `\037`; both cases now name the field actually removed.
- Pre-S1 revision recorded, not remembered: `expected/baseline-revision.txt` holds `revision: f18ed58d6c96b0f97fc677fb7c90073336f310e4` plus three `derivation:` lines. Check A0 rejects an abbreviated SHA (T27), a SHA resolving to no commit (T28), a revision with no derivation (T29) and an empty file (T30), and resolves the SHA through `git cat-file -t` when git is available. The expected claim-ID set is likewise stored in `expected/claim-ids.txt` and read by A4 at run time.
- Existing deterministic S1 suite after the addition: `bash tests/s1-relay/check-relay-payload.sh` → `verdict: TARGET MET`, exit 0, 27/40 compliant, 13 contract-exempt, 0 measured violations, 0 cap violations, 0 ambiguous, 0 unresolved, 3058 relayed bytes against a 1,742,140-byte baseline. `bash tests/s1-relay/check-relay-payload.test.sh` → `26 passed, 0 failed`, exit 0. `git status --porcelain workflows/research-workflow/tests/s1-relay/` is empty — the accepted 40/40 position and its byte-stable fixture are untouched.
- Files changed: 16 new files under `workflows/research-workflow/tests/s1-representative/` (README.md, rubric.md, score-specimen.sh, score-specimen.test.sh, three under `expected/`, five under `corpus/`, four under `specimen/`) plus this state file. No canonical workflow source, agent, skill, plan, `tests/s1-relay/` file, deployed project or consuming-project artifact was modified. No network call, API call, credential use, model invocation or billed spend occurred. `logs/friction-log.md` carries a pre-existing uncommitted modification from before this unit and was neither edited nor staged.

Accepted limitation, stated rather than worked around: check A2 requires the run's verification report to be byte-identical to the frozen response. That is correct under the Route A fixed-response design the operator selected and is what makes the comparison deterministic; it would have to be relaxed if any later unit ever scored a live API run, which is outside this task.

Standing authorization, unchanged: the operator selected Route A on 2026-08-18 — a local fixed-response scratch regression with a purpose-built semantically real one-chapter corpus, comparison of the same inputs at the pre-S1 revision and current `HEAD`, deterministic schema/identity scoring, and a fresh independent evaluation of analytical meaning. It covers the later two attended runs and the operator's required `approved` response at each run's unconditional Step 4.2e halt. It excludes client material, deployed-project writes, workflow network/API calls, credentials, billed API spend, propagation, production deployment, and deferred adjacent fixes.

Accepted deterministic position from Unit 15, re-verified above and unchanged: 40/40 named seams accounted for; 27 converted and 13 explicitly justified; 0 violations/cap/ambiguous/unresolved; 99.824469% reduction; checker `TARGET MET`; harness 26/26. Unit 16 accepted at discovery commit `83d26431c52eab2f10c276a01985d74302afaaf9`.

Current position: approved plan Slice S1 → deterministic proof accepted and Route A authorized → the representative proof substrate now exists and is self-verified → what remains for S1 is the two attended pre/post chapter runs scored by that substrate and the fresh independent Part-B evaluation, each a separate unit because each carries an operator halt or an actor boundary.

## Brief

This unit turns the accepted Route A design into executable proof infrastructure, which is the smallest remaining deliverable that advances S1 without combining construction with the attended workflow runs. It implements the representative proof seam required by the approved plan while preserving the already accepted deterministic evidence and keeping client data, network/API activity and deployed projects outside the task.

Required outcome: add a self-contained representative-proof substrate under `workflows/research-workflow/tests/s1-representative/` that gives the later pre-S1 and post-S1 chapter runs one semantically real input corpus, one frozen verification response, one explicit semantic/schema rubric and one deterministic scorer. The corpus must contain genuine analytical claims with stable claim IDs; the frozen response must exercise verdict and discrepancy structures; and the scorer must be capable of rejecting missing required artifacts or paths, dropped or invented claim IDs, malformed or missing verdict/discrepancy data, and summaries above the approved 20-line / 4-KB cap. The rubric must separately define what the fresh evaluator will judge as preserved analytical meaning; do not make byte identity of AI prose a criterion.

Plan justification: S1's deterministic seam proof is accepted, but the approved plan also requires one end-to-end chapter regression preserving artifacts, claim IDs, verdicts and analytical meaning. This unit creates only the reusable proof substrate needed by both comparison runs; executing those runs and conducting the independent evaluation remain separate later units because they carry operator halts and actor boundaries.

Check against the repository before editing:

1. Re-derive and record the exact pre-S1 baseline revision from repository history as the parent of the first accepted S1 conversion commit; stop if that boundary cannot be established unambiguously.
2. Confirm the accepted Unit 16 finding against `workflows/research-workflow/tests/s1-relay/`: its existing fixed fixture is byte-accounting material and cannot supply claim-ID plus verdict/discrepancy semantics. Do not modify or repurpose it because the accepted deterministic harness depends on it.
3. Inspect the canonical chapter, verification and execution-agent output contracts needed to make the new corpus and frozen response semantically valid. Treat the state-file description of the exact file shape as a verify-first premise, not authority; select the minimum structure the live contracts require.

Boundary: create or edit only files inside the new `workflows/research-workflow/tests/s1-representative/` directory and this task state file. The dominant deliverable is the proof substrate. A small local runner or manifest belongs inside that directory only if needed to invoke the scorer reproducibly. Do not change canonical workflow source, agents, skills, plans, `tests/s1-relay/`, deployed projects or consuming-project data.

Required failing-capable evidence:

- Demonstrate that representative malformed cases fail for each material contract class: a missing required artifact/path, a dropped or invented claim ID, absent or malformed verdict/discrepancy structure, and an over-cap summary.
- Demonstrate that the complete valid representative specimen passes the deterministic scorer.
- Show that the exact pre-S1 revision and the expected claim-ID set are recorded in the substrate rather than supplied from memory at run time.
- Run the existing S1 deterministic checker and harness once after the new files are added and report their results, proving the accepted 40/40 position and existing fixture remain unchanged.
- Report the files changed, commands and exit codes, negative-control outcomes, valid-specimen outcome, and the commit containing this unit.

Completion condition: the corpus, frozen response, explicit rubric and deterministic scorer are committed; every named negative-control class is shown to fail; the valid specimen passes; the existing deterministic S1 suite remains green; and the state file hands back to Codex. If a valid substrate would require changing workflow source, weakening a contract, performing a workflow run, invoking nested AI, using network/API/credentials, or touching a path outside the boundary, stop and hand back instead of expanding the unit.

Capability subset: baseline only — read/search/history inspection, local edits within the bounded paths, local tests, and Claude-owned local commit. Nothing is selected from the pre-authorizable set, which is empty. No operator-reserved capability is needed. The later attended runs, Step 4.2e approvals and independent evaluator are explicitly outside this unit.

Claude may challenge a false premise or stale direction with repository evidence; do not improvise around it.

## Blocker

None.

## Next action

Codex: assess Unit 17. The substrate is committed, every named negative-control class fails, the valid specimen passes, and the accepted deterministic suite is unchanged. Judge whether the corpus is semantically real enough to carry a meaningful regression, whether the eight Part-A checks cover the contract classes the plan requires without inventing requirements the live contracts do not state, and whether Part B is defined tightly enough for a fresh evaluator. Then continue to the next unit — the first attended chapter run at the recorded pre-S1 revision — or correct once.

No new deferral was noticed during this unit. Carried deferrals remain outside the task: missing Evidence Pack and verification-report relay at `verify-chapter` Step 3.7a; stale `reference/stage-instructions.md` writer-return wording; writer Reviewer Findings footer sequencing; README `Blast radius`; optional verification-summary truncation naming.
