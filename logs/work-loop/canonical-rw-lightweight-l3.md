---
task: canonical-rw-lightweight-l3
status: closed
turn: operator
---

## Outcome

Accepted pilot-quality delivery of the lightweight Research Workflow lane (L3). One shared entry capability (`/research-route`) classifies a question as Light, Standard or Deep and dispatches it: Light and Standard run in place under preserved per-claim evidence and evidence-versus-inference discipline, one-way escalation prevents a load-bearing claim from remaining on an under-controlled route, and Deep hands off to the existing deployed Research Workflow without running any pipeline stage.

The task exit condition is met: L3 core behaviour is accepted, with both the plan-required deterministic proof and the plan-required representative operating proof. The lane stops cleanly at the Standard-route House View seam, as the objective required.

Lifecycle decision: **adopt for a limited internal pilot only.** No consumer deployment, no broad rollout, no merge and no push are authorized.

## Decisions that matter

- **Proof shape accepted with a disclosed deviation.** At the operator's request the three approved Unit 3 cases were executed by fresh subagents in parallel rather than by three literal serial slash-command invocations. Codex accepted this as representative *semantic* proof — the operator supplied the cases, each subagent independently read and executed the live `/research-route` instructions, and the already-accepted deterministic floor separately proves the invocation path. It is explicitly **not** proof of serial orchestration or of consumer-facing command UX.
- **Standard-route House View adapter deferred, deliberately.** It stays unbuilt until L2 publishes its stable authority contract. Reason: building an adapter against an unsettled contract would either invent authority L2 has not yet defined or require rework once it does. No substitute House View or judgment mechanism was created in its place.
- **Deep target's later-stage setup gaps are project prerequisites, not L3 work.** The verified Sector Intelligence target is ready for Stage 1 but still lacks `reference/stage-5-paths.md`, a resolved confidentiality boundary and a task plan for this topic. These belong to that project, not to this lane.
- **Two transparency disclosures carried to closure.** The Unit 1 A12 revision was made transparently and is recorded here rather than silently absorbed. The standing friction-log freeze produced a failed write during this task; that failure is the freeze working as designed, and it is disclosed rather than worked around.

## Evidence

Deterministic proof: commits `00283026e00b3f0c5d369ba0785581ceb538a96a` (Unit 1 — shared entry, Light vertical slice) and `0a74c2f59a6cf43bcb0bb109c278392520ce92dc` (Unit 2 — Standard evidence-controlled slice). Both harnesses green at `14 passed, 0 failed` and `18 passed, 0 failed`; `research-route-memo-check.sh` passed on its first run.

Representative operating proof (Unit 3), accepted by Codex on 2026-08-18 and preserved at `audits/l3-representative-operating-proof-2026-08-18.md`:

- **Light** — resolved from the base floor; answered with separately marked evidence, inference and gaps.
- **Standard** — resolved from `output=analysis` (also `load_bearing_claim=yes` and `thesis_judgment=yes`); produced a six-claim evidence-controlled pilot-readiness memo.
- **Deep** — resolved from `output=report` and independently from `scope=broad`; verified the intended Sector Intelligence target against the deployed workflow's setup markers, disclosed its later-stage configuration gaps, returned the deployed-workflow handoff, and ran no pipeline stage.

Together these are the plan-required operator-run Light question, genuine Standard assignment and Deep handoff. The closing record is committed in this task's final commit.

Post-closure independent review found four material control gaps. Commits `a306db36` and `041f224b` corrected them by making malformed signal vectors fail closed, requiring executable route resolution, enforcing the Standard memo's claim/source/role structure, binding Answer verbs to cited claims, and conservatively closing the House View output seam. The corrected harnesses pass at `14 passed, 0 failed` and `33 passed, 0 failed`; the final genuine Standard invocation and its accepted boundary are recorded in the repository-owned proof above.

## Accepted limitations

- Deterministic checks validate routing and memo structure, not analytical quality.
- Source-role independence, fit, permission ceilings and the initial six-signal assessment remain judgment calls.
- `/research-route` is not deployed to consumers.
- Prose-verb binding and the House View negation check are conservative structural controls, not exhaustive semantic enforcement.
- The Unit 3 proof does not establish serial orchestration or consumer-facing command UX.
- The Deep target is ready for Stage 1 but still lacks `reference/stage-5-paths.md`, a resolved confidentiality boundary and a task plan for this topic.
- The Standard-route House View adapter is intentionally unbuilt, pending L2's stable authority contract.
- Instruction adherence and the semantic assessment of the five routing signals remain model judgments; the executable classifier guarantees the route only for the vector it receives.
