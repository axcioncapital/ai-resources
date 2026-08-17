---
task: canonical-rw-near-term-implementation-plan
status: active
turn: codex
---

## Objective and scope

Create one repository-grounded implementation plan titled **Canonical Research Workflow — Near-Term Strategic Improvements**. The plan must reconcile the three overlapping 2026-08-17 proposals into one sequenced, buildable path for the canonical Research Workflow, while preserving visible authority boundaries and identifying any operator decisions that must precede implementation.

Scope: planning only. The deliverable is one new plan under `plans/`; no Research Workflow command, skill, script, template, deployment surface, subscription, or consuming-project file is implemented or changed in this task. The plan must cover the near-term operating outcome, existing reusable substrate, recommended implementation slices and dependencies, proof seams, integration/release path, representative operating proof, risks, stop conditions, and explicit deferrals.

## Lane and unit

Standard. Implementation mode. Unit 1 — synthesize the near-term implementation plan.

Named reason for the loop: the scope needs bounding across three overlapping proposals before work begins, and the resulting plan needs assessment by someone other than its author before it can guide implementation.

## Brief

Patrik wants one implementation plan for the canonical Research Workflow rather than three competing planning tracks. This is the right unit now because the branch already carries three same-day proposals with shared dependencies and different horizons, while no integrated near-term plan exists. The unit follows the Axcíon Repository Development Operating Standard: define and inspect first, use the minimum sufficient structure, plan vertical behavior with credible proof, integrate through existing controls, and require representative operating proof for the material capability.

**Operator objective:** create an implementation plan titled `Canonical Research Workflow — Near-Term Strategic Improvements`; Claude authors the plan itself, using the official repository-development workflow as the guide.

**Authority and source dispositions:**

- Governing: the operator's current decision above authorizes creation of the plan and fixes its subject and title. It does not by itself approve any recommendation inside the source proposals, authorize paid services, or authorize implementation.
- Governing method: `/Users/patrik.lindeberg/.codex/skills/axcion-repository-development/SKILL.md` and its `references/operating-standard.md` define the planning/build/proof/integration discipline to apply. The Work Loop executable core governs this hand-off and assessment, not the plan's product choices.
- Non-governing proposal inputs: `plans/lean-research-workflow/proposal.md`, `plans/research-retrieval-layer-improvement-plan.md`, and `plans/canonical-research-workflow-judgment-and-insight-plan.md`. Each is marked proposed. Preserve their useful evidence and recommendations, but do not present their contents as approved requirements.
- Verify-first authority conflict: `plans/lean-research-workflow/proposal.md` reports that `logs/missions/research-workflow-deploy-fitness.md` rejected differentiated research tiers unless reopened by new evidence. Inspect the mission record and the current proposal language. The present request authorizes planning, not silent resolution of that product/governance choice; carry any still-live decision as an explicit operator gate.
- Verify-first repository reality: inspect the canonical implementation under `workflows/research-workflow/` only as needed to validate the plan's load-bearing claims about existing components, reuse, seams, deployment, and proof. Treat proposal descriptions as claims until checked against the named files or searched surfaces.

**Required outcome:** write `plans/canonical-research-workflow-near-term-strategic-improvements-implementation-plan.md` with the exact title `# Canonical Research Workflow — Near-Term Strategic Improvements` and a clear `Status: Proposed` marker. It must be executable as a planning document without pretending unresolved operator choices are settled.

The plan must:

1. State the operating outcome in plain language: what the improved canonical RW must make possible, for whom, and why now.
2. Describe the verified current substrate and what should be reused, simplified, removed, or newly built. Cite paths for load-bearing repository claims.
3. Reconcile the three proposal inputs into one strategic sequence rather than appending three roadmaps. Use a compact cross-source disposition for the major themes: near-term implementation, prerequisite/decision gate, later experiment, or deferral.
4. Select and justify the minimum current operating mode from the official standard. State whether an additional specification or ticket split is useful; do not create either artifact in this unit.
5. Define bounded vertical implementation slices. Each slice must state its observable outcome, acceptance evidence/proof seam, boundary, direct dependencies, and any operator-owned gate. Sequence slices so reusable substrate and the earliest real operating proof arrive before broad rollout.
6. Separate deterministic proof (validators, command-path tests, invariants) from representative AI-judgment or operator-workflow proof. Include material code review, integration, deployment/synchronization, and real operating trials proportionate to the claims.
7. Make authority and cost explicit: identify choices that require the operator, including any material tier/routing change, paid source/tool adoption, changes to approval semantics, or expansion into consuming projects. Do not convert a proposal into approval through wording.
8. Name what is outside the near-term boundary and why. If repository authority does not determine the precise near-term cutoff, make the recommended cutoff Claude's attributed proposal and expose the operator decision needed to approve it.
9. Include risks and stop conditions, especially false-scarcity regressions, duplicated/competing authority artifacts, premature general automation, canonical-versus-deployed drift, and a plan whose first proof arrives only after a large horizontal build.
10. End with a completion condition for the implementation programme and a clear first executable slice, without implementing that slice now.

**Codex framing decisions:** one integrated proposed plan is the sole deliverable because the present problem is competing planning tracks, not lack of more source material. The plan may preserve longer-horizon recommendations as explicit deferrals, but must not absorb unrelated workflow redesign. This boundary keeps the unit reviewable and avoids treating a broad strategic backlog as one implementation session.

**Claims to check before writing:**

- Search `plans/` for the exact destination filename and title. The expected pre-change condition is that neither exists; stop and hand back if a divergent artifact already occupies the destination.
- In each of the three proposed source plans, verify its stated status, intended horizon, prerequisites, and explicit relationship to the other plans rather than inferring those from filenames.
- In `logs/missions/research-workflow-deploy-fitness.md`, locate the actual research-tier decision and its reopening condition; assert nothing beyond the record searched.
- In `workflows/research-workflow/`, verify only the implementation surfaces needed to support the plan's dependency and reuse claims. For every absence claim, record the bounded surface and search pattern used.
- Check whether a more current approved canonical RW plan or authoritative current-state record exists in the directly relevant `plans/`, `logs/missions/`, and `logs/work-loop/` surfaces. If one exists, reconcile its authority; if none is found, state the exact searched surfaces and pattern rather than claiming repository-wide absence.

**Evidence required:**

- Failing case: the pre-change destination/title search and its result.
- Implemented result: the new plan path and a concise explanation of how the three inputs were reconciled into one sequence.
- Structural proof capable of failure: a check showing the file has the exact title and proposed status, and contains the operating outcome, verified current substrate, cross-source disposition, staged slices with outcome/acceptance/boundary/dependencies, proof strategy, operator gates, integration/operating proof, risks/stop conditions, deferrals, first slice, and completion condition.
- Integrity proof: `git diff --check` for the new plan and a scoped diff/stat showing that no implementation surface changed.
- Repository evidence: cite the specific files/searches used for each load-bearing current-state or authority conclusion. Do not re-run unrelated workflow test suites; this unit changes only a plan.

**Capability subset:** baseline only — read, search, inspect history, edit the new plan and this task state file, run local text/integrity checks, and make the local commit. Baseline deny set must be passed in full. Nothing is selected from the pre-authorizable set, which is empty today. No network, external tools, paid-service action, deployment, push, merge, credential access, destructive action, or other operator-reserved capability is needed.

**Completion condition:** the proposed integrated plan exists at the named path, its claims and source dispositions are repository-grounded, its work is broken into buildable vertical slices with credible proof and explicit gates, its near-term boundary is visible, and Claude has committed the plan together with this hand-off result before returning `turn: codex` for assessment.

**Stop and hand back if:** a load-bearing premise is false; an authority conflict prevents a coherent proposed plan without choosing on the operator's behalf; the destination already contains divergent work; required evidence cannot be produced; or completing the deliverable would require edits outside `plans/canonical-research-workflow-near-term-strategic-improvements-implementation-plan.md`, this task state file, the expected harness log, or the existing hook-maintained `logs/friction-log.md`. Claude may challenge a false premise or stale direction rather than improvise past it.

## Latest result

Correction round — both frozen findings reproduced by inspection before editing (grep against the committed plan; finding 1 at the plan's then-lines 78/84/90/96/114/116, finding 2 at then-lines 70/108/116/174), then corrected:

- Finding 1 (authority/sequence contradiction): RESOLVED. § 5 now opens with an explicit **authority baseline** — every slice derives from proposed sources, so no slice begins until the operator approves the plan (G4) or separately authorizes the slice; "existing authority"/"ungated" wording removed throughout. S1/S2/S6 gate lines now read "plan approval only — no additional decision"; S3's G5 adjacency confirmation is blocking, not advisory; the sequence puts the G-session first instead of parallel to S1–S3; G4 is retitled "Approve this plan and its near-term cutoff" and states that nothing in § 5 is executable before it; § 10's first-slice line begins "once G4 approves this plan". S2's slice-time premise now additionally requires establishing that the 2026-08-14 ruling **authorizes the canonical change** rather than merely stating the substantive rule in a project-local context — hand back otherwise.
- Finding 2 (S4/S5 dependency contradiction): RESOLVED via the declared-fallback model (chosen so G1 and G2 stay independently decidable; neither gate is decided for the operator). S5's dependency line now states one coherent model: G2 settles the execution path and both outcomes are viable — runtime when G2 approves and S4 lands, otherwise the manual execution model (batched prompt block per route run, relay burden recorded in acceptance evidence); S5 does not wait for S4. Aligned surfaces: § 5 sequence line, § 4 escalation sentence, § 9 stop condition 2 (rewritten — every G1×G2 combination is covered by design; it now fires only on a conditioned/partial approval neither path can serve), § 10 completion condition item 3 (S5 proof on whichever execution path its gates allowed).

Nothing newly noticed was implemented; no candidate deferrals arose beyond the corrections themselves.

Result: plan updated in place at `plans/canonical-research-workflow-near-term-strategic-improvements-implementation-plan.md`; only that file and this state file changed.

Evidence (able to fail, and previously did): stale-wording regression greps — `executable under existing authority`, `Gate:** none`, `in parallel with S1–S3`, `economically identical`, `advisory confirmation at G5` — all now no-match (each matched before the correction); 9 correction-presence greps (authority baseline, plan-approval precondition, manual execution model, S5-does-not-wait-for-S4, G4-approves-plan, ruling-authorization premise, blocking G5, G1×G2 coverage, path-conditional S5 proof) all PASS. Nothing broke: the original 18 structural checks still all PASS, the negative control still fails, `git diff --check` exit 0, and `git status --porcelain` shows only the plan, this state file, and the pre-existing uncommitted `logs/friction-log.md` hook modification.

## Blocker

None.

## Next action

Codex: closure check on the two frozen findings only — (1) is the authority/sequence contradiction resolved (technical readiness consistently distinguished from authority; no slice executable before plan approval or separate authorization; S3 blocked on G5; S2's ruling-authorization premise), and (2) is the S4/S5 dependency model now coherent without deciding G1 or G2 for the operator — and did the correction break anything. Then close, or use the § 3 menu.
