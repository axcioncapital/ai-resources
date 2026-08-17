---
task: canonical-rw-near-term-improvements
status: active
turn: codex
---

## Objective and scope

Deliver Slice S1 of the operator-approved near-term plan: refactor the canonical Research Workflow's justified W4-H1–H4 content relays to path-passing or path-plus-capped-summary, preserve intentional context isolation and analytical meaning, and prove the plan's deterministic 100% seam coverage / 80% payload-reduction target plus its representative chapter regression. The task exits when S1 and its required proof are accepted. Approval-metadata synchronization, S0, S2–S11, deep-pipeline slimming, and deploy-fitness mission work remain outside this task.

## Lane and unit

Standard. Implementation mode. Unit 2 — path-pass W4-H4 reference documents.

Named reason for the loop: S1 needs several bounded units, its live-workflow scope must be protected from adjacent programme work, and its evidence must be assessed independently before it counts as complete.

## Brief

Unit 1's executable S1 baseline is accepted at commit `7e2b97a6d195bc8ac035e670a4b11ab2107331f5`. Unit 2 implements the cleanest production subset it established: the six noncompliant W4-H4 reference-document relays whose governing contract already requires path passing. This directly advances S1 without deciding the five ambiguous isolation cases or combining all remaining relay classes into an oversized unit.

Required outcome: in the canonical workflow, `run-cluster` and `run-execution` no longer read the W4-H4 reference documents into the main session for onward content relay at manifest seams `H4-01`–`H4-06`. They pass project-root-relative `reference/{filename}.md` paths to the receiving subagents, while preserving stage-entry present-and-filled validation, the consuming skill/agent inputs, the Cross-Model Rule, and all research artifacts and judgments. The already-compliant `H4-07`–`H4-09` seams remain compliant.

Governing sources and dispositions:

- The operator-approved plan content at `7fec2ef6a4db178e465282975b06b06ce92892f9`, `plans/canonical-research-workflow-near-term-strategic-improvements-implementation-plan.md` § 5 S1, governs the outcome: W4-H1–H4 use disk/write-and-return-path or path-plus-capped-summary where the isolation contract allows, with no compaction, model, or output-policy redesign.
- `workflows/research-workflow/docs/required-reference-files.md` § Path-passing convention governs this unit's exact payload class: Stage 2–4 reference documents are passed by path, the subagent reads them at runtime, paths resolve relative to the project root, and no runtime fallback exists.
- `workflows/research-workflow/tests/s1-relay/seam-manifest.tsv` and its accepted harness are executable current-state evidence. `H4-01`–`H4-06` are the noncompliant reference-document seams in scope; `H4-07`–`H4-09` are the already-compliant controls. Unit 1's classifications of other seams do not authorize changing them here.
- `audits/token-audit-2026-07-03-ai-resources.md` § 4 W4-H4 is diagnosis input only. The live manifest's corrected steps and surfaces govern the edit map.
- The accepted Unit 1 result established five deployed projects hold regular-file copies, not symlinks. This unit changes the canonical template only; propagation is S0 territory and remains excluded.

Check against the repository before acting:

1. Revalidate the task and the accepted harness at commit `7e2b97a6`, then inspect the live anchors for `H4-01`–`H4-09`. The pre-change target must show `H4-01`–`H4-06` as measured violations and `H4-07`–`H4-09` as compliant, with no unresolved row. If it does not, stop and hand back the exact mismatch.
2. Reconcile current `origin/main` into the implementation branch before the production edit, using a non-destructive local strategy that leaves current `origin/main` an ancestor of `HEAD`. Unit 1 found the branch 1 behind / 14 ahead and identified the missing commit as retirement of `/inject-dependency`; re-derive those facts after the repository-required fetch. If reconciliation conflicts, changes an S1 seam, or materially changes the premise, stop rather than resolving it silently. Preserve the pre-existing `logs/friction-log.md` modification.
3. Verify the current `run-cluster` stage-entry gate still checks every required reference file for present-and-filled status, and identify the exact validation that must survive after its content read is removed. Verify the analogous precondition in `run-execution` for every reference path it passes. Absence claims are limited to the two command bodies and their invoked stage-entry checks.
4. Verify each receiving subagent/skill at `H4-02`, `H4-04`, and `H4-06` can read project paths and that no consumer requires the reference documents embedded in its prompt. Inspect the named agent tool declarations and the exact delegation instructions; do not infer capability from the manifest alone.
5. Verify the two command bodies remain canonical-only surfaces and that no project copy, deploy/sync command, reference file, or adjacent relay must change to make these six seams compliant.

Scope and Codex framing decisions:

- In scope: `workflows/research-workflow/.claude/commands/run-cluster.md`; `workflows/research-workflow/.claude/commands/run-execution.md`; the existing `workflows/research-workflow/tests/s1-relay/` harness only where a production wording change genuinely requires a bounded anchor/test adjustment; this state file; hook-maintained `logs/friction-log.md` only if normal hooks append; repository-required origin reconciliation; local checks and local commit.
- Excluded: every W4-H1, W4-H2, and W4-H3 production seam; ambiguous rows `H1-02`, `H1-03`, `H2-04`, `H2-05`, `H3-04`; already-compliant `H4-07`–`H4-09` except as regression controls; agent/skill/reference behavior; project copies; deploy/sync propagation; approval metadata; representative chapter operation; S0 and S2–S11; push, merge into `main`, deployment, credentials, spend, and external dispatch.
- Codex framing decision: reference-document relays are isolated first because their governing path contract is already explicit and they provide one dominant, independently testable production deliverable. Bulk operands, return contracts, draft sequencing, and the isolation ambiguity remain later units.

Required evidence, all capable of failing:

- Before/after focused output for `H4-01`–`H4-09`: the six targeted rows flip VIOLATION → COMPLIANT, the three controls stay COMPLIANT, and the target reports zero unresolved rows. Quote the measured current-relay byte reduction attributable to this unit and the new aggregate reduction percentage; the overall S1 target may correctly remain red.
- Harness regression suite passes without weakening its falsifiability controls, fixed fixture, 20-line/4 KB cap, or manifest coverage. If an anchor/test change is needed, show why the old live anchor became stale and that the new anchor still flips on behavior rather than approved wording.
- Direct evidence that stage-entry present-and-filled validation still covers every reference document before delegation, while the main session no longer carries their contents onward.
- A scoped diff demonstrating that research prompts, research extracts, artifacts, claim IDs, verdict rules, Cross-Model ownership, and all non-H4 seam directives are unchanged. No representative AI-authored prose run is required for this instruction-only reference transport change; the later S1 representative chapter regression remains the semantic end-to-end proof.
- Repository evidence: current `origin/main` is an ancestor of the resulting `HEAD`; relevant existing local checks stay green; `git diff --check` passes; committed paths stay within the permitted surfaces; and Claude records the local commit hash.

Completion condition: the committed canonical workflow path-passes all six `H4-01`–`H4-06` reference-document relays, preserves their entry validation and downstream semantics, keeps `H4-07`–`H4-09` compliant, leaves every excluded seam and deployed project copy untouched, advances the measured aggregate S1 reduction, and supplies the scoped regression and repository evidence above.

Stop and hand back if: any targeted reference document must be content-passed for a verified consumer; a receiving agent cannot read the project-relative path; present-and-filled validation cannot be preserved without relaying content; origin reconciliation conflicts or changes the S1 premise; a targeted seam cannot flip without changing an excluded behavior or surface; the harness becomes unresolved or unfalsifiable; or the unit would require propagation, external dispatch, or another operator-reserved capability.

Capability subset: baseline local repository work only—read/search/history inspection, repository-mandated origin sync and non-destructive reconciliation on the implementation branch, edits within the scoped canonical command and harness surfaces, local tests, and local commits. Nothing is selected from the pre-authorizable set, which is empty. No push, merge into `main`, deployment, credential access, destructive action, external service, policy change, or communication.

## Latest result

Inspected (2026-08-17):

- Claim (1): HOLDS — `git diff --stat 7e2b97a6 -- workflows/research-workflow/tests/s1-relay/` is empty, so the accepted harness is unchanged. Pre-change `bash check-relay-payload.sh --format tsv` showed `H4-01`–`H4-06` VIOLATION and `H4-07`–`H4-09` COMPLIANT, with `unresolved (uncovered) : 0`. No mismatch.
- Claim (2): HOLDS — after `git fetch origin`, `git rev-list --left-right --count origin/main...HEAD` returned `1 15` (Unit 1's commit accounts for 14 → 15), and the one missing commit was `3e7789cd Retire /inject-dependency from the canonical research-workflow template`. `git show --stat 3e7789cd` touches only `.claude/commands/inject-dependency.md` and `.claude/shared-manifest.json` — no S1 seam surface. Reconciled with a non-destructive `git merge --no-ff origin/main`: clean, no conflict, and `git merge-base --is-ancestor origin/main HEAD` now returns true. `logs/friction-log.md` was left untouched.
- Claim (3): HOLDS, with one finding. `run-cluster.md` line 11 carries the stage-entry completeness gate naming all three docs, hard-class, present **AND** filled, halting on failure — it sits before Step 2 and is independent of the content read, so it survives the conversion untouched. That gate is the exact validation that had to survive. `run-execution.md` has **no** analogous command-level gate: searched all 204 lines of the command body and the invoked `reference/stage-instructions.md` § Stage-Entry Reference-File Completeness Gate, whose contract fires at `run-sufficiency` and `run-report`/`produce-*` only, and `docs/required-reference-files.md` § Stage-entry reference files, whose present-AND-filled list is `stage-5-paths.md` and `claim-permission.md` alone. The only precondition is consumer-side (`research-prompt-creator` Input Requirements #4 halts if `source-class-hierarchy.md` is absent), which path-passing preserves. Nothing was lost, but the content read did give incidental fail-fast, so Steps 2.1.4 and 2.3.4 now verify presence in its place.
- Claim (4): HOLDS — all three receiving sub-agents are `general-purpose` (full tool set, `Read` included), read from the live delegation lines: `run-cluster.md` line 30 "launch one general-purpose sub-agent", `run-execution.md` line 43 and line 109 "launch a general-purpose sub-agent". Searched all four consuming skills (`cluster-analysis-pass`, `cluster-memo-refiner`, `research-prompt-creator`, `research-extract-creator`) for a requirement that the reference docs arrive embedded: none found. Each instead instructs the reader to open the file itself — e.g. `cluster-memo-refiner` "Read the chassis-version marker in `reference/quality-standards.md`", `research-extract-creator` "check the project for `reference/known-limits.md`", `research-prompt-creator` "If the file is absent, halt".
- Claim (5): HOLDS — `ls -l` shows both command bodies are regular files, not symlinks, in canonical. Searched the whole repo (`grep -rn --include='*.md' --include='*.sh' --include='*.json' "project reference docs"`) for the directive text: the only live carriers are the two command bodies themselves. Every other hit is a historical `audits/risk-checks/` record. No deploy/sync command, reference file, or adjacent relay had to change.

Result: the six W4-H4 reference-document relays are converted and committed at `17cc5726704ef31e690a89e27a06168f4b3ecae9`. `run-cluster` 2.2/2.3 and `run-execution` 2.1.4/2.1.6/2.3.4/2.3.6 pass project-root-relative `reference/{name}.md` paths instead of reading the docs into the main session. `run-cluster`'s stage-entry present-AND-filled gate is unchanged; `run-execution` verifies presence where it previously read content, so the fail-fast point holds. The production diff is eight lines across the two commands — the six seam directives, `run-cluster`'s list introducer (now "as content, except where a bullet below says otherwise"), and `run-cluster`'s sub-agent Task line (now "read the extracts and the three project reference docs at the provided paths").

Evidence:

- **Seam flip.** `bash check-relay-payload.sh --format tsv` before → after: `H4-01`–`H4-06` VIOLATION → COMPLIANT; `H4-07`–`H4-09` COMPLIANT → COMPLIANT; `unresolved (uncovered)` 0 → 0. Compliant seams 3/39 → 9/39, measured violations 26 → 20. The five ambiguous rows and both cap violations are unmoved.
- **Byte reduction.** Current relayed bytes 1,498,210 → 989,673 against the fixed 1,785,794-byte baseline: **508,537 bytes removed by this unit**, aggregate reduction **16% → 44%**. The overall S1 target (≥80%) is correctly still red — `verdict: TARGET NOT MET`.
- **Falsifiable, not asserted.** T9's isolation control T9b still reports `H3-01` unmoved by the `run-cluster` edit, and T3 still proves prose asserting noncompliance changes no verdict. Reverting either `run-cluster` seam's wording reproduces the VIOLATION — that is now T9's live assertion, so a change that only *claimed* conversion would fail the suite.
- **Harness regression.** `bash check-relay-payload.test.sh` → **17 passed, 0 failed**, same 17 cases as the accepted baseline. Fixture regenerates byte-identical (T7, 475,687 bytes), the 20-line/4 KB cap is still measured not asserted (T5/T5b), the stale-anchor detector still fails the run (T4), and every manifest row still resolves (T6b, 0 uncovered). No control weakened.
- **Why an anchor changed.** T9 pinned `H4-01`/`H4-02` to VIOLATION → COMPLIANT, and its sed expressions matched the pre-conversion wording (`^2. Read the project reference docs …`, `Pass each sub-agent as content:`). Once the seams were converted, both went stale: the first matched no line, and neither could show a flip because the seam has no violation left to clear. Left as they were, the suite reported 15 passed / 2 failed against a correct conversion. They now assert COMPLIANT → VIOLATION on the live directive text — the identical liveness property, run in the only direction a converted seam can demonstrate — via a shared `flip_dir` core with `flip`/`flip_back` wrappers. `H1-01` and `H3-17` still run the original direction, so both are covered.
- **Semantic containment.** `git diff` over the two commands touches no research prompt, research extract, artifact, claim ID, verdict rule, Cross-Model ownership line, or non-H4 seam directive. Per the brief, no representative AI-authored prose run is required for an instruction-only reference-transport change.
- **Repository.** `git merge-base --is-ancestor origin/main HEAD` → true. `git diff --check` → clean. Committed paths: the two commands, `tests/s1-relay/check-relay-payload.test.sh`, `tests/s1-relay/README.md`, and this state file — all inside the permitted surfaces. Work commit `17cc5726704ef31e690a89e27a06168f4b3ecae9`; this state-file record follows it as a second local commit so it could carry the exact hash. No push, no merge into `main`.

Carried forward unchanged: the five ambiguous rows remain untouched pending a later bounded isolation decision; canonical edits do not propagate to the five regular-file project copies (S0 territory); adjacent same-shape relays outside W4-H1–H4 remain excluded; and the pre-existing hook-maintained `logs/friction-log.md` change remains unrelated user state and was not staged.

Deferral noticed and not done: `tests/s1-relay/README.md` § Blast radius still says two project copies are byte-identical to canonical and three have diverged. That was true at the Unit 1 baseline and is now false for all five, because canonical moved. It is not corrected here because the accurate statement depends on the S0 propagation decision this task excludes; the README's four statements that this unit's own edit falsified were corrected.

## Blocker

None.

## Next action

Codex: assess Unit 2 against its completion condition — the six `H4-01`–`H4-06` seams converted with `H4-07`–`H4-09` still compliant and zero unresolved rows, entry validation and downstream semantics preserved, excluded seams and project copies untouched, aggregate reduction advanced 16% → 44%, and the harness green at 17/17 with its falsifiability controls intact. Judge in particular whether the T9 direction change for `H4-01`/`H4-02` is an acceptable bounded anchor adjustment or a weakening, and whether the recorded README blast-radius deferral should be taken now or left to S0.
