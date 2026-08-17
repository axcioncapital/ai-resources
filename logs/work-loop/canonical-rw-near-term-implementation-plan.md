---
task: canonical-rw-near-term-implementation-plan
status: closed
turn: operator
---

## Outcome

Unit 1 accepted. The proposed integrated plan exists at `plans/canonical-research-workflow-near-term-strategic-improvements-implementation-plan.md` (`Status: Proposed`). It reconciles the three proposed 2026-08-17 Research Workflow tracks — `plans/lean-research-workflow/proposal.md` (shape), `plans/research-retrieval-layer-improvement-plan.md` (runtime), and `plans/canonical-research-workflow-judgment-and-insight-plan.md` (output quality) — into one repository-grounded, sequenced near-term programme: verified current substrate with cited paths, a cross-source disposition for every major theme, six bounded vertical slices (S1 relay refactor, S2 Perplexity-ruling canonization, S3 filled source registry, S4 retrieval runtime, S5 `/research` routes, S6 judgment local trial) each with observable outcome, proof seam, boundary and dependencies, five explicit operator gates (G1 tiers, G2 Stage-2 automation, G3 paid sources, G4 plan/cutoff approval, G5 mission-contract mechanics), a deterministic-versus-representative proof split, integration through existing controls, risks, stop conditions, deferrals with named owners, a completion condition, and S1 as the first executable slice. No proposal content is presented as approved and no implementation was performed.

## Decisions that matter

- Operating mode selected as **Normal** under the Axcíon Repository Development Operating Standard; no separate specification or ticket artifact was created — each slice's Work Loop brief carries the ticket contract.
- The two conflicts with the **active** mission `logs/missions/research-workflow-deploy-fitness.md` (its operator S10 list rejects research tiers *and* Stage-2 execution automation) were carried as operator gates G1 and G2 rather than resolved. G5 records that the mission's contract is frozen and `/mission` has no update verb, so reopening requires an operator-directed revision, not a silent edit.
- The lean plan's R1/R2/R3 routes and the judgment plan's Light/Standard/Deep modes were identified as one assignment-level axis, not two features — a single vocabulary decision at G1.
- The near-term cutoff is Claude's **attributed proposal**, with G4 as the operator approval it requires; G4 doubles as the baseline authority without which no slice starts, since every slice derives from unapproved proposals.
- **Codex used the executable core § 3 menu to permit one final tightly-bounded fix** rather than accept the residual S5 sequencing ambiguity as a written limitation. Value-and-risk ground: the ambiguity was cheap and tightly bounded to remove, while leaving it would have made an otherwise executable plan unclear in a common gate outcome. The fix keyed S5's execution path to whether the runtime has landed rather than to how G2 resolved, making `G2 approved, S4 not yet landed` executable through the manual fallback.
- No new deferral arose at the closure check. The plan's § 8 out-of-scope items (lean Waves 2–3, judgment Units 2–9, retrieval C3/C6–C8, deploy-fitness threads 3–8 and F-7, consuming-project propagation, the deferred R1 citation-fidelity subagent) remain its explicit deferrals and are **not** implementation-authorized by this closure.

## Evidence

Plan: `plans/canonical-research-workflow-near-term-strategic-improvements-implementation-plan.md`. Commits on `session/2026-08-17-research-workflow-fixes`: `106c15bb` (Unit 1 plan), `391e6988` (correction round — authority baseline, S4/S5 dependency model), `931a884c` (final bounded fix — S5 execution path keyed to runtime availability), plus this closing record. Proofs, all able to fail and red before green: pre-change destination and title searches returned no match (the failing case); 18 structural greps on the plan pass against a negative control that fails; the correction's five stale-wording greps and the final fix's four G2-conditioned greps each matched before their edit and return nothing after; nine correction-presence and five clarification-presence greps pass. Integrity: `git diff --check` exit 0 at every round, and no implementation surface changed — `git status --porcelain` showed only the plan, this state file, and the pre-existing hook-maintained `logs/friction-log.md` modification, which was left uncommitted throughout.

## Accepted limitations

None.
