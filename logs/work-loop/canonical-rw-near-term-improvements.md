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

Correction round — frozen finding (1) reproduced and resolved.

Reproduced by inspection (2026-08-17):

- Finding (1): REPRODUCES — `README.md` § Blast radius line 111 read "Two copies (`axcion-content-programme`, `axcion-sector-intelligence`) are currently byte-identical to canonical; three have already diverged." `cmp` of canonical `run-cluster.md` and `run-execution.md` against each of the five project copies returns DIFFERS for all ten comparisons. The claim was false as stated.

Result: the § Blast radius current-state paragraph is corrected and committed at `160aa983500c984bce25e4d29111d7800e52f7c1`. It now reads:

> They are **regular file copies, not symlinks**, so a canonical edit does *not* take live effect in them — propagation needs `/sync-workflow`, which is S0's territory and outside this task. **None of the five received Unit 2's canonical change, so all five copies now diverge from canonical**: the two command bodies Unit 2 edited, `run-cluster.md` and `run-execution.md`, differ from canonical in every one of the five. Unit 2's edits therefore landed canonically only, and the accumulated divergence must be reckoned with before any propagation is claimed.

The corrected text drops the two-versus-three byte-identity split rather than restating it, because inspection could not support restating it (see the second deferral below).

Evidence:

- **Divergence measured, not asserted.** `cmp -s` canonical → each project copy, both edited commands, all five projects: 10/10 DIFFERS. `axcion-content-programme` holds its copy at `archive/research-workflow-2026-08-17/commands/` — that copy also differs. Against the Unit 1 baseline canonical (`git show 7e2b97a6:…`), the same copies return IDENTICAL for `axcion-content-programme` (both files) and for `axcion-sector-intelligence/run-cluster.md`, which is what makes the divergence attributable to canonical moving in Unit 2 rather than to project-side edits. Reverting the README paragraph would restore a claim these ten comparisons contradict.
- **Correction-only diff.** `git diff -- workflows/research-workflow/tests/s1-relay/README.md` is 4 removed / 5 added lines, entirely inside the § Blast radius second paragraph. `git status --porcelain` shows no other repository file changed by this round. Production commands, harness logic, fixture, manifest, project copies and every other README section are untouched.
- **`git diff --check`** → clean.
- **Nothing broke.** `bash check-relay-payload.test.sh` → **17 passed, 0 failed**, same 17 cases and same controls as the accepted Unit 2 run. `bash check-relay-payload.sh --format tsv` still reports `H4-01`–`H4-09` all `path`, `unresolved (uncovered) : 0`, `ACHIEVED reduction : 44%`, `verdict: TARGET NOT MET`. Nothing in this directory is read at runtime, so the README cannot move a verdict — the suite run is the check that confirms it did not.

Carried forward unchanged: the accepted Unit 2 production implementation at `17cc5726704ef31e690a89e27a06168f4b3ecae9` and the T9 COMPLIANT → VIOLATION liveness adjustment were not reopened; the five ambiguous rows, the non-H4 seams and the five project copies remain untouched; propagation remains S0-owned and excluded; the pre-existing hook-maintained `logs/friction-log.md` change remains unrelated user state and was not staged.

Newly noticed during the correction, recorded as candidate deferrals and **not** implemented:

1. **§ Blast radius first paragraph is now stale in a second, different way.** `axcion-content-programme` archived its research-workflow deployment on 2026-08-17 — it holds no live `run-cluster.md`/`run-execution.md` under `.claude/commands/`; the copy sits under `archive/research-workflow-2026-08-17/commands/`. The sentence "Five projects carry a copy of every seam-bearing surface" therefore no longer describes that project, and the deployed-copy count for propagation purposes may be four, not five. Not corrected here: the frozen finding scopes this round to the current-state paragraph, and the accurate replacement depends on whether an archived deployment still counts as a propagation target — an S0 question.
2. **Unit 1's "two copies byte-identical" classification was already imprecise for one file.** `axcion-sector-intelligence/.claude/commands/run-execution.md` already differed from canonical at the Unit 1 baseline, by one line: the deploy-time substitution of `{{RESEARCH_AREA_PHRASE}}` with that project's research-area text. It is a template fill, not a semantic divergence, but it is a byte difference. Not corrected here: it would reopen an accepted Unit 1 result, and it does not change this round's conclusion that all five now diverge.

## Blocker

None.

## Next action

Codex: run the closure check on frozen finding (1) only — is the false § Blast radius byte-identity claim resolved, and did the correction break anything? The correction commit is `160aa983500c984bce25e4d29111d7800e52f7c1`, the diff is 4 removed / 5 added lines confined to that one paragraph, and the harness is still 17/17 with `H4-01`–`H4-09` all `path` and 0 unresolved rows. Two items are recorded above as candidate deferrals, not corrections: the § Blast radius first paragraph is separately stale because `axcion-content-programme` archived its research-workflow deployment on 2026-08-17, and Unit 1's "two copies byte-identical" classification was already imprecise for `axcion-sector-intelligence/run-execution.md` (a deploy-time `{{RESEARCH_AREA_PHRASE}}` template fill). Decide whether either is taken now or left to S0, then close Unit 2 or open Unit 3.
