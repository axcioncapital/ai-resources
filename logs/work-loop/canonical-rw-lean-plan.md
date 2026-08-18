---
task: canonical-rw-lean-plan
status: active
turn: codex
---

## Objective and scope

Replace the existing proposed 12-slice canonical Research Workflow implementation plan with one materially smaller plan focused only on two operator priorities: a lightweight Research Workflow and a canonical judgment layer / House View. The replacement must preserve completed S1 as accepted foundation, define four lean outcomes with explicit concurrency and integration boundaries, and mark every removed programme as not authorized and not scheduled. This task exits when the revised plan is independently accepted and content-bound operator approval is recorded; creating the lightweight-RW worktree is the next routed action after that shared baseline exists, not part of this task.

## Lane and unit

Standard. Implementation mode. Unit 1 — replace the oversized plan with the lean concurrent plan.

Named reason for the loop: this is a material replacement of programme scope and authority, the resulting document will govern two concurrent repository efforts, and the exact committed content needs independent assessment before either branch begins.

## Latest result

Inspected (2026-08-18):

- Claim (1) — S1 closed at `16b3cd58`, carry only its accepted outcome/evidence: **HOLDS.** `logs/work-loop/canonical-rw-near-term-improvements.md` reads `status: closed` / `turn: operator`; `git show --stat 16b3cd5803fc11617247e159b54eef90897def18` is `update: research-workflow S1 — close canonical-rw-near-term-improvements`, touching that one file (22 insertions, 77 deletions). Its Evidence section names commits `5035a379` and `2b9770fa` and the 40/40-seam, 99.82%, `TARGET MET`, 38/38, `PRESERVED` results now carried into § 2.
- Claim (2) — the plan is at `Status: Proposed`, carries S0–S11, six gates, retrieval/runtime/statistics work and a programme-wide benchmark: **HOLDS.** Read all 279 lines. Line 3 is `**Status:** Proposed`; twelve slice headings `### S0` … `### S11` at lines 87–157; 59 matches for `\bG[1-6]\b`; S4 and S11 are the retrieval-runtime and official-statistics slices; the § 6 `DELIVERED` benchmark sits at line 194.
- Claim (3) — old S5–S9 dependencies and the Sector Intelligence boundary support a faithful lean mapping: **HOLDS.** Dependency lines inspected at 118, 125, 131, 137, 143, 149: S5 gated on G1 + G5, S6 needs a live Sector unit and the four `check-judgment-*.test.sh` suites, S7 on S6 PASS + G6, S8 on S7, S9 on S0 + S8. `projects/axcion-sector-intelligence` exists in the workspace, so L1 and L4 can bind it.
- Claim (4) — no naming collision for the proposed lightweight-RW branch/path: **HOLDS.** `git worktree list` (22 entries) and `git branch -a` show no branch or registered worktree matching `lightweight`, `lean-rw` or `light-rw`; `ls` for `*lightweight*` under the workspace root returned no match. No worktree or branch was created, deleted or modified.
- Additional finding, checked because it is a live authority conflict with L3: `logs/missions/research-workflow-deploy-fitness.md` is `status: active` and line 41 lists `Research tiers.` on the operator's explicitly-not-to-be-built set. Carried into the plan's § 6 as an authority condition of approval rather than silently overridden.
- Wording tension noted, not a false premise: the S1 closing record calls the plan "the operator-approved near-term plan" while the plan file reads `Status: Proposed` and this brief says it was never content-approved as a whole. Both are consistent with S1 having been separately authorized. The rewrite takes the safer treatment the brief requires — the file stays pending content-bound approval.

Result: `plans/canonical-research-workflow-near-term-strategic-improvements-implementation-plan.md` was rewritten in place as the lean four-outcome, two-lane plan. No second plan was created and no other file changed. It went from 8,203 words / 61,213 bytes to 2,488 words / 17,439 bytes — a 69.7% reduction. It now carries: the two-priority operating outcome with retrieval, source products, deployment infrastructure and Content Programme integration named out of scope (§ 1); S1 as completed foundation at its closing and evidence commits (§ 2); the five substrate findings that still govern (§ 3); the before/after scope map (§ 4); L1 reduced local judgment trial, L2 combined canonical judgment/House View, L3 lightweight RW, L4 one manual integrated pilot (§ 5); the two-lane execution model with allowed/forbidden surfaces by outcome, per-lane Work Loop task and `.owner`, no copied state file, no Daniel lane, and two authority conditions (§ 6); sequence, per-outcome proof and five stop conditions (§ 7); the non-commitments (§ 8); and the effort estimates and terminal condition (§ 9). Status line 3 reads `Proposed — pending content-bound operator approval of this exact committed content`. The operator's 2026-08-18 decisions are now embodied in that committed file rather than restated here.

Evidence (each search could have returned a surviving obligation and did not):

- `grep -nE "\bS(0|[1-9]|1[01])\b"` → 21 lines, all inside § 2 (S1 as completed), the § 4 map, or the § 8 non-commitment list. Before: twelve live `### S0` … `### S11` slice sections at lines 87–157 with active Dependencies/Gate lines. No active slice sequence survives.
- `grep -nE "\bG[1-6]\b"` → 1 line (§ 4 row: the six-gate matrix is Removed). Before: 59 matches, including the whole § 7 gate programme and the § 7 gate-disposition table.
- `grep -nEi "DELIVERED|benchmark"` → 2 lines: the § 4 row recording the benchmark as Removed, and the word "delivered" in § 9's plain-language terminal condition. Before: the § 6 programme benchmark at line 194 with eight numeric DELIVERED thresholds, plus the § 10 DELIVERED conditions.
- `grep -nEi "retrieval|runtime|statistic|Content Programme"` → 9 lines, all either the § 1 out-of-scope sentence, the § 3 finding explaining why L4 is manual, § 5 L3's boundary exclusion, or § 4 / § 8 removal entries. No retrieval, runtime or statistics requirement survives as work.
- Dependency read-through: every dependency and ordering statement in § 5 and § 7 names only L1–L4. L3's House View adapter is fenced in three independent places — § 5 L3 concurrency clause, § 6 forbidden surfaces, § 7 stop condition 2 — so the lightweight lane cannot invent the authority contract. § 8 opens `not authorized and not scheduled` and states they are `not deferred obligations of this plan and carry no owner, trigger or sequence position here`, with a fresh-business-case reopening path.
- Validation: `wc -l` 279 → 240; `git status --porcelain` shows exactly one modified plan file plus this state file. `logs/friction-log.md` was already modified before this unit and is deliberately not staged.
- Commit: the single commit carrying this state file and the rewritten plan, on branch `session/2026-08-17-research-workflow-fixes`. It is the head commit of this task at hand-back and is the commit the operator's content-bound approval would bind to.

## Brief

This unit replaces the oversized proposal in place before concurrent implementation begins. It must leave one short, coherent implementation plan whose active work maps directly to the operator's two priorities and whose concurrency boundary is precise enough that the two worktrees can proceed without inventing each other's interface.

Required outcome: materially rewrite `plans/canonical-research-workflow-near-term-strategic-improvements-implementation-plan.md`; do not create a second plan. Preserve only the repository findings and historical context that still govern the lean work, record S1 as completed foundation rather than an open slice, and replace S0–S11 plus G1–G6 with the four lean outcomes and their actual gates.

The revised plan must contain:

1. **Operating outcome:** a lightweight Light/Standard/Deep entry capability and one founder-authorized judgment/House View contract that governs consequential analysis and writing. Retrieval runtimes, source products, general deployment infrastructure and Content Programme integration are not part of this plan.
2. **Completed foundation:** S1 is complete at its accepted evidence/closing commits; it is not reopened, renumbered as pending work or counted in remaining effort.
3. **L1 — genuine local judgment trial (reduced old S6):** bind the separate Sector Intelligence checkout, run one real case through the existing local judgment implementation, require at least one substantive operator revision, independent semantic review and a burden record. PASS opens L2; FAIL stops judgment canonicalization and returns to the smallest local contract.
4. **L2 — canonical judgment layer and House View (combined essential old S7+S8):** one Unit Judgment Brief separating evidence, interpretation and Axcíon context; independent challenge; founder revise/approve/reject; approved authority mechanically governing analysis, synthesis, report architecture/prose and relevant QC. No separate rollout programme or duplicate approval system.
5. **L3 — lightweight RW (reduced old S5):** one shared entry capability with Light, Standard and Deep behavior; evidence standards and one-way escalation preserved; deep route hands to the existing RW. Its core may build concurrently with L1/L2, but the Standard-route House View trigger/adapter cannot be finalized until L2 publishes the stable authority contract.
6. **L4 — one manual integrated operating proof (reduced old S9):** deliberately install/reconcile the canonical judgment capability into one bound Sector Intelligence consumer and run one genuine integrated case. Do not build generic S0 propagation first. The pilot must also prove the lightweight route's handoff/escalation behavior with real representative uses before adoption. A second concrete consumer is the trigger to reconsider generic deploy/sync machinery.
7. **Two-lane execution model:** current worktree/branch owns L1 evidence intake and L2 judgment/House View; a new lightweight-RW worktree/branch, created only from the approved lean-plan commit, owns L3. Name allowed and forbidden surfaces by outcome rather than guessing exact files. Each lane has its own Work Loop task and `.owner`; no copied state file. L4 is a separate integration unit after both branches are accepted.
8. **Sequence and gates:** L1 and L3 core may run concurrently; L1 PASS precedes L2; L2's stable interface precedes L3's final House View adapter; accepted L2+L3 precede L4. Founder judgments remain operator-owned. A failed trial, unresolved authority contract or material evidence-standard regression stops the affected lane rather than expanding it.
9. **Proof:** each lean outcome has one deterministic/failing-capable floor and one proportionate representative judgment or operating proof. Do not recreate the former programme benchmark or demand broad multi-project deployment.
10. **Explicit non-commitments:** old S0, S2–S4, S10–S11, API retrieval, official-statistics ingestion, source profiles, generic propagation, Content Programme integration and broad rollout are `not authorized and not scheduled`. They may return only through a fresh business case and operator decision, not as deferred obligations of this plan.
11. **Effort and terminal condition:** record 50–80 hours as the strict pilot-quality target and 70–120 hours as the safer range, clearly labelled estimates rather than promises. The plan ends after L4 is accepted; it does not silently reopen removed programmes.

Authority treatment: the operator has approved the lean direction and the eleven requirements above, but the revised file's exact content does not become the governing plan until its commit is presented and the operator gives content-bound approval. Keep `Status: Proposed` (or an equally explicit pending-approval status) in this unit. Do not claim the rewritten content is already approved.

Check against the repository before editing:

- Confirm S1's closed state and closing commit, and carry only its accepted outcome/evidence pointer.
- Read the current plan in full and identify every active obligation, dependency, gate, benchmark and terminal condition that would contradict the lean scope if left behind.
- Re-check the current plan's old S5–S9 dependencies and the Sector Intelligence boundary so the lean mapping is faithful while deliberately removing generic propagation and Content Programme adoption.
- Inspect registered worktrees and proposed branch/path names only to avoid a future naming collision; do not create, delete or modify a worktree in this unit.

Boundary: edit only the existing implementation plan and this task state file. Do not edit source proposals, missions, workflow code, tests, S1 proof artifacts, permissions, branches or worktrees. Do not implement any lean outcome.

Required evidence:

- A concise before/after scope table mapping retained/completed/combined/removed old slices to L1–L4.
- Structural searches showing no surviving active `S0–S11` sequence, `G1–G6` gate matrix, retrieval/runtime/statistics requirement, broad Content Programme rollout or programme-wide DELIVERED benchmark remains as an obligation.
- A read-through for internal consistency: every dependency names L1–L4, concurrency does not allow the lightweight lane to invent the House View contract, and every removed item is explicitly non-authorized rather than ambiguously deferred.
- Plan diff summary, files changed, validation commands/exit codes and the commit containing the revised proposed plan and hand-back.

Completion condition: the one existing plan is materially shorter and internally coherent; it contains exactly the four lean outcomes, their two-lane execution and integration boundary, proof and stop conditions, explicit non-commitments and effort range; S1 remains completed; the status still requires content-bound approval; no other file beyond this state changes; commit and hand back to Codex.

Stop and hand back if the operator decisions conflict, if the Sector Intelligence trial boundary cannot support L1/L4, if a removed programme is actually a load-bearing dependency that cannot be replaced by the manual pilot, or if the rewrite would require implementation or worktree creation. Do not silently restore an old slice to solve the conflict.

Capability subset: baseline local read/edit/validation capabilities inside the two allowed files and Claude-owned local commit. No network, subagents, worktree/branch mutation, workflow implementation, deployment, credentials or other operator-reserved capability is needed.

Claude may challenge a false premise or stale direction with repository evidence; do not improvise around it.

## Blocker

None.

## Next action

Codex: assess Unit 1 — the rewritten plan against the eleven brief requirements and the completion condition. Specifically: whether the four lean outcomes are faithful reductions of old S6, S7+S8, S5 and S9; whether the two-lane boundary is precise enough that the lightweight lane cannot invent the House View contract; whether every removed programme reads as non-authorized rather than deferred; and whether the two authority conditions in § 6 (the mission's research-tiers entry, founder-owned judgment) are the right treatment or should instead be handed to the operator as a separate decision.

Deferrals recorded, not implemented:

- The three 2026-08-17 source proposals (`plans/lean-research-workflow/proposal.md`, `plans/research-retrieval-layer-improvement-plan.md`, `plans/canonical-research-workflow-judgment-and-insight-plan.md`) still carry no disposition pointer to this rescoped plan. The old plan's § 9 R2 mitigation promised one on approval. Not done now because this unit's boundary allows edits only to the plan and this state file, and because the pointer should name the approved commit rather than a pending one.
- The active deploy-fitness mission still lists research tiers as not-to-be-built. Not done now because a mission edit is outside this unit's boundary and the reopening is an operator authority act, not a plan edit.

Adjacent improvement noticed, not implemented: `logs/friction-log.md` carries an uncommitted modification that predates this unit. It is not this unit's change, the friction log is frozen workspace-wide, and it was deliberately left unstaged.
