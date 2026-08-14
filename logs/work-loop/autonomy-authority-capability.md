---
task: autonomy-authority-capability
turn: codex
---

## Objective and scope
Bring `plans/work-loop-v2-v0.2/work-loop-v2-autonomy-authority-capability-proposal-v0.1.md` to content-bound approval, then progress through bounded units until the approved capability is implemented and verified.

The operator wants the proposal implemented after readiness/QC. `/implementation-triage` remains explicitly excluded as evidence, authority, or a route for this task.

Operator process decision, 2026-08-14: implementation follows the Axcíon Standard Implementation Workflow in compact form. After the approval record is current, one consolidated planning unit must establish the Fixed Point, Repository Delta, Implementation Specification, and ordered vertical tracer bullets; one fresh implementation-plan review then freezes that plan before target implementation begins. The existing Work Loop remains the sole runtime state and supplies per-slice implementation, evidence, independent assessment, bounded correction, demonstration, and progression. Do not create parallel state or review systems.

## Lane and unit
Standard. Discovery mode. Unit 5 — fresh bounded implementation-plan review before plan freeze.

Named reason for the loop: the task remains a multi-unit, cross-cutting governance implementation whose consequential changes need independent assessment and must survive session boundaries.

## Brief
Unit 4's repository-grounded plan and its one correction are accepted; the active Axcíon workflow position is **review**, immediately before plan freeze and before any target implementation. The named unknown is whether the exact corrected plan provides a safe, efficient, and faithful path from repository reality to the approved outcome. This review must run in a genuinely fresh Codex context because the current thread watched the artifact being produced and corrected.

Review payload and authority:

- Artifact under review: `plans/work-loop-v2-v0.2/work-loop-v2-autonomy-authority-capability-implementation-plan-v0.1.md` at commit `f5011ff9b22210954bddff464122369edbc029aa`, blob `5baf430c9275698a334e43aeb10784b77ec8572a`. The current working file was verified to match that blob exactly before this unit opened. The artifact is draft and grants no implementation authority.
- Governing approved direction: `plans/work-loop-v2-v0.2/work-loop-v2-autonomy-authority-capability-proposal-v0.1.md`, exact approved content at commit `d8a89e0f7d4444bc1d3cabb963a6f49cdfc1ce67`, blob `39c67196dcec35a1be8f4fcf8ea3ef6a50cfde0b`; its status-only successor at commit `5b0d5fd857a2d663dfc298071faf2033f884b0eb` changed no substantive content.
- Review criteria: the operator-approved Axcíon Standard Implementation Workflow at `/Users/patrik.lindeberg/.codex/attachments/18e3181b-5534-4b7c-9fc2-fb520c455b97/pasted-text.txt`, especially §6 Plan Review, §14 Standard Artifact Set, and §15 scaling. `docs/qc-independence.md` governs fresh-context independence, materiality, and risk-aware dimensions.
- Unit 4 already performed the premise-verification payload work: bounded consumer/current-behavior inventory, exact source reads, safe deterministic suites, §14 traceability, and plan consistency checks. Treat those declared primitives as the review payload; reproduce a claim only if the artifact is internally inconsistent, its evidence cannot fail, it is consequential and hard to reverse, or it is a repository fact readable directly.

Review question: **Does this exact plan provide a safe, efficient, and faithful path from the current repository to the accepted outcome?** Assess only the artifact against its approved purpose and criteria—do not replay its creation process or restart the proposal from first principles.

Review dimensions:

1. Fidelity to the proposal's §14 sequence, §15 decisions/gates, §16 success standard, and explicit MVP deferrals.
2. Completeness of the Fixed Point, Repository Delta, Implementation Specification, §14 traceability, and T1–T8 vertical behavior contracts.
3. Plan efficiency: unnecessary abstraction, duplicated capability, horizontal phases disguised as units, oversized units, or avoidable ceremony.
4. Safety and ordering: weak test seams, destructive/irreversible work before replacement proof, hidden dependencies, invalid checkout/repository assumptions, or premature implementation authority.
5. Review calibration for each high-consequence surface, including the seven risk-aware dimensions where applicable: usage cost, permissions surface, blast radius, reversibility, hidden coupling, principle alignment, and problem reality.
6. Evidence honesty: requested versus observed/enforced capability, scenario trials versus organic real-use tasks, and claims that could pass without the planned behavior becoming true.
7. Freeze readiness: no unresolved decision or uncertainty that would force an implementing unit to redesign the plan silently.

Scope: review the exact implementation-plan artifact only. No edits to the plan, proposal, executable core, adapters, governance rules, permissions/hooks, workspace `CLAUDE.md`, carrier/dispatcher, evaluation assets, or any target implementation surface. The Work Loop state file remains the sole runtime interface.

Required output: classify the review as **Pass**, **Correct**, or **Escalate**, with only material findings and the concrete consequence of leaving each unfixed. If Pass, record a content-bound acceptance of the reviewed commit/blob and open a status-only Claude unit that records the plan as reviewed and frozen without changing its substantive content; do not begin T1. If Correct, use the Work Loop's one bounded correction for Unit 5. If Escalate, name the exact operator-owned decision. A review that cannot run in fresh context is `unassessed`, not Pass.

Completion condition: deliver the independent verdict and evidence disposition through this state file. No target implementation is authorized by this unit.

Stop conditions: stop if the plan identity differs from the commit/blob above, the fresh-context requirement cannot be met, the governing proposal identity is contradictory, or a material issue requires changing the approved outcome or scope.

## Latest result
Bounded correction round complete (2026-08-14). All five frozen findings were reproduced by inspection against the reviewed artifact — plan commit `f5011ff9b22210954bddff464122369edbc029aa` / blob `5baf430c9275698a334e43aeb10784b77ec8572a`, confirmed byte-identical to the working file before editing — and all five were corrected in `plans/work-loop-v2-v0.2/work-loop-v2-autonomy-authority-capability-implementation-plan-v0.1.md`. No target implementation surface was touched; the plan remains draft and unfrozen.

Result, per finding:

1. **Split the core authority gate from policy insertion.** T1 now performs §14 item 1 only (authority-line rewrite) and *ends at operator approval*; new T2 performs item 2 (the §1 clause) and is gated on that approval. Tracers renumbered T1–T9 (old T2–T8 became T3–T9). Ordering constraint 1, § 3.1/§ 3.2, the traceability table and the internal-consistency check were all updated; T3–T6 now depend on T2, not T1.
2. **MVP baseline capability envelope stated and proved.** § 3.4 now fixes the envelope in three sets — granted-by-default (§7 baseline), operator-reserved, and pre-authorizable **whose current membership is empty** — and adds a ten-row table mapping every non-deferred §11 control to its enforcement surface, its true strength, and a failing-evidence field. Strengths were read from `carry-turn.sh`, not assumed: task-scoped write paths are **detected, not prevented**, and the push/merge/deploy restriction is **requested per invocation, not a default** (`CLAUDE_DENY` is empty at `:201`; the mandatory list carries nested-actor rules only). Only sandbox and network/tool restriction are labelled deferred. T6 carries the required baseline deny set as convention, visible in `denials=`.
3. **`session-plan.md` resolved before freeze.** T5's reviewer-time `change / no change` choice is removed. The change is now required and bounded: one citation sentence in Step 5 stating that session-level pause granularity does not decide per-action authority, with a failing-before/passing-after grep, a byte-unchanged diff on the three postures, and a normal/consequential review tier.
4. **Horizontal trial phase replaced by twelve bounded contracts.** T8 is now a twelve-row matrix (S1–S12), each row carrying setup, paired legs, authorized surface, expected terminal behavior, fail-capable evidence and bounded exit. Every row runs on the attended carrier only; the dispatcher is named as out-of-boundary and unusable. S4 and S8 are pre-identified as *blocked* because the pre-authorized capability set is empty — stated up front rather than discovered late.
5. **Evidence exits made strict.** T8 passes only when all twelve rows carry a verdict; a subset requires an operator-owned Fixed Point change, not an assessment judgment. T9 passes only at 3–5 organic tasks across ≥2 real capability shapes — a shortfall is now a blocker and operator decision, explicitly not dischargeable by recording a limitation. Item 11's measures are recorded across T8 and T9 and tallied at T9.

**Evidence (fail-capable, paired before/after).** Twelve greps run against the reviewed blob `5baf430c` (extracted via `git show f5011ff9:<path>`, hash re-verified as `5baf430c`) and against the corrected file, newline-flattened so wrapped clauses match. All twelve flip in the intended direction — six additions `none → MATCH`, six removals `MATCH → none`:

- added: T2 tracer heading; "Granted to a Standard unit by default"; the non-deferred §11 control-map heading; the T5 session-plan heading; row `| S12 |`; "Surface for every row: the attended carrier"; T8's all-twelve exit.
- removed: `| 2 (add §1 clause) | T1 (same tracer`; "disposition recorded (change / no change)"; "phase ends when the scenario table is exercised"; "operator accepts a bounded subset as sufficient"; "or an explicit limitation recorded if fewer".

Structural counts: `grep -cE '^\| S[0-9]+ \|'` returns **12**; the §11 control table holds **10** control rows plus header; tracer headings are exactly T1–T9, sequential, no duplicates. The checks are genuinely failable — each reads the opposite way on the reviewed blob, and a no-op edit would leave the removal checks matching.

**No automated suite binds to this artifact.** It is a plan document; no test asserts its content, so the paired greps above are the regression protection, and inventing a suite that greps for text this correction just wrote would not be evidence. The repository's deterministic suites were not re-run because no executable surface was edited — `git status` confirms the only files changed are the plan and this state file.

**One in-scope contradiction fixed beyond the literal finding text.** The deferred-items list named §14 item 11 as out of MVP while the traceability table assigned it to the evidence tracers. Finding 5 requires item 11's measures recorded across both, so the stale line would have defeated the fix — an implementing unit could cite it to skip the measures. Item 11 is removed from that list, with the reason stated in place. The connected-development profile remains deferred.

**Candidate deferrals — noticed, not implemented:**

- The same deferred-items line still names §14 item 6 as out of MVP, while the traceability table maps item 6 to the Fixed Point as a *Keep* (the carrier stays attended-first — a retained fact, not a deferral; what is deferred is the sandbox/network enforcement inside it). This is a pre-existing miscount outside the five frozen findings, so it was left in place.
- Two correction rounds had each numbered findings from 1, so "Finding 3" meant different things in different paragraphs. Because this round added more such labels, the ambiguity became load-bearing; all 38 references are now qualified as **Unit 4 Finding N** or **Unit 5 Finding N**, with the convention recorded in the status header. This was collateral of this round's own edits, not new scope.

## Blocker
None.

## Next action
Codex: run the closure check on the frozen findings only — are Unit 5 findings 1–5 resolved, and did the correction break anything? The correction scope is closed; anything newly noticed is a deferral, not a second round.

Two items are placed for your closure decision rather than fixed: the §14 item 6 miscount in the deferred-items list, and whether the Unit 4 / Unit 5 finding-label convention should persist into the frozen plan. Both are recorded above as candidate deferrals.

Do not treat this hand-back as a freeze. The plan is corrected, still draft, and still grants no implementation authority; freezing it and authorizing T1 remain your verdict to make.
