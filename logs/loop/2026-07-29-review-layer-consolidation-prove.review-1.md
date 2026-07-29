UNIT: 2026-07-29-review-layer-consolidation-prove
STREAM: 2026-07-29-review-layer-consolidation
PHASE: prove
REPO: ai-resources

REVIEW

Object reviewed:
- The implemented branch through ddfe7a4 in ai-resources-2
- logs/loop/2026-07-29-review-layer-consolidation-prove.evidence.md
- The G1 package, Build evidence, recovery records and complete diff

Verdict: REVISE before G2.

Material findings: 4. Minor findings: 1.

R1-F1 — MATERIAL — The required independent Shape-review chain is not present on disk.

Object inspected: shape.review-1.md, shape.plan-v2.md, shape.plan-v3.md, shape.evidence.md and git history.

shape.review-2.md does not exist in the working tree or git history. Plan-v3 materially changes the architecture in response to that missing review, but plan-v3 itself received no recorded independent review. Prove substitutes plan-v3 §0’s Claude-written adjudication for the missing Codex review.

That does not satisfy docs/work-loop.md’s hard requirement that Prove read the Shape review from durable repository evidence. It also cannot demonstrate that G1 approved the exact independently reviewed plan version.

This history must not be reconstructed or rewritten. Carry it to G2 as an unresolved permanent limitation with disposition `operator`. Do not describe the pre-implementation review chain as complete.

R1-F2 — MATERIAL — Prove did not test the result against all nine Shape falsifiers, and at least two literal predicates fail.

Object inspected: shape.plan-v3.md §9, prove.evidence.md §§1–8, the workspace consumer tree and git diff 2cb245e..HEAD.

Prove reports four checks, P1–P4, rather than a result for every Shape falsifier.

Observed failures or unresolved results:

1. Falsifier 1 requires both broken-consumer predicates to return empty. The file-symlink predicate currently returns seven broken links: two under project-planning and five under strategic-os/.backup-untracked. Their pre-existence may justify an operator disposition, but it does not make the immutable “return empty” criterion pass. Build-4 silently reinterpreted it as “no regression.”
2. Falsifier 4 says any added file outside this stream’s logs/loop paths fires the criterion. The diff adds the transition risk-check report under audits/risk-checks/. Calling that “not machinery” may be reasonable, but it is an adjudication of a fired predicate, not a clean result.
3. Falsifier 8’s specified grep remains non-empty outside the explicitly excluded Prime files. Some hits are historical or unrelated deterministic gates, but they must be classified rather than replaced by the different §-pointer check.
4. The recorded S4 question about docs/weekly-cadence.md was left to Prove and was not answered.

Counts match the §8 baseline, protected hooks and permission entries appear intact, excluded files were not changed, and only the two approved hooks were deleted. Those passing results do not close the omitted criteria.

Required correction: append a per-falsifier 1–9 result using the exact approved predicates, identify every fired predicate, and adjudicate it explicitly. Do not redefine the immutable criteria as though they originally said “unchanged.”

R1-F3 — MATERIAL — The delivered claim about automatic /risk-check invocation is false or materially incomplete.

Object inspected: prove.evidence.md §8, docs/audit-discipline.md:75 and current command/skill files.

The new authority says no command or policy fires /risk-check automatically, but live instructions still require it, including:

- .claude/commands/work-loop.md:105 — /risk-check still fires at two gates.
- .claude/commands/lean-repo.md:118 — each structural item is still gated by plan-time and end-time /risk-check.
- .claude/commands/friday-act.md:7,175 — still records risk_check_required and says the gate runs during execution.
- .claude/commands/resolve-repo-problem.md:147 — still instructs execution to run the gate.
- claim-permission and cluster-memo skills still require /risk-check to re-fire.

friday-act was edited by this stream, so this is not only excluded residue. work-loop was explicitly excluded and should be assigned to the already-planned work-loop correction rather than edited quietly here.

Required correction: re-enumerate every executable or normative invocation, distinguish historical mentions and operator offers from instructions that cause a run, fix the in-scope contradictions, and name every excluded residue with an owner. Narrow the delivered claim accordingly.

R1-F4 — MATERIAL — Prove became an unbriefed correction Build before independent review.

Object inspected: commit 8c24043, prove.brief.md and the work-loop phase contract.

The Prove commit changed four object files while writing its evidence. Its brief was then created retrospectively in ddfe7a4. Those corrections were not a G1 Build slice and were not bounded by a contemporary brief. The repairs themselves are visible and appear directionally sound, but the repository cannot prove that their scope was authorized before implementation.

Do not rewrite that history. Transcribe this review, adjudicate the repairs and findings honestly, perform one bounded correction pass, and re-run the complete falsifier suite against the final HEAD. Because the corrections affect this verdict’s basis, return the revised evidence for review-2 before G2.

R1-F5 — MINOR — The review worktree is not clean.

Object inspected: git status and logs/friction-log.md.

logs/friction-log.md contains uncommitted hook-generated write-activity lines. They do not appear to be part of the candidate implementation, but the owner and disposition should be established before G2 so the release worktree has one bounded, reproducible state.

LIMITATIONS

I inspected the actual ai-resources-2 worktree and branch history. I did not modify files. The seven broken consumer links appear to predate this stream, but their exact originating commits were not required to establish that the approved empty-result predicate currently fails.
