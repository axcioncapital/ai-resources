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

Inspected (2026-08-17):
- Claim (destination absent): HOLDS — searched `plans/` listing for `near-term` filenames and `grep -ril "Canonical Research Workflow — Near-Term Strategic Improvements" plans/`; no match either way. Failing case for the unit established.
- Claim (three proposals' status/horizon/relationships): HOLDS — read all three in full. `research-retrieval-layer-improvement-plan.md` and `canonical-research-workflow-judgment-and-insight-plan.md` carry explicit `Status: Proposed`; `lean-research-workflow/proposal.md` carries no Status line but is titled and structured as a proposal (Part 2 "Proposal", Part 3 staged plan). Only the retrieval plan states cross-relationships (subordinates itself to lean Wave 1); grepped each sibling's filename in the other two — no match, confirming lean and judgment plans do not cite each other.
- Claim (mission tier decision): HOLDS, and is broader than briefed — `logs/missions/research-workflow-deploy-fitness.md` is `status: active`; the operator S10 "explicitly not to be built" list includes **research tiers** AND **Stage-2 execution automation** (`execution-agent` stays unwired for Stage 2), with "re-litigating the S8→S10 triage-down decisions without new pilot evidence" a named off-mission signal. Both rejections conflict with the proposals and are carried as operator gates G1/G2 in the plan; also noted the 2026-07-18 gate re-decision (zero demonstrated blockers; deployment may proceed).
- Claim (RW substrate supports reuse/dependency claims): HOLDS — verified by inspection: `execution-agent.md` exists, referenced only by `verify-chapter.md` (grep across `.claude/commands/` — one hit; unwired for Stage 2); no `scripts/` directory exists; `source-class-hierarchy.template.md` = 16 `{{` tokens/108 lines (placeholder); `stage-instructions.md:77` Step 2.S4 has no lead-vs-source handling (searched for `lead, not`/`LEAD]` — no match); `research-quality-log.md` has zero data rows; `audits/token-audit-2026-05-18-research-workflow.md` and all four `audits/working/rw-lean-*.md` exist; Sector Intelligence judgment pilot artifacts exist at the three named paths.
- Claim (no more current authoritative RW plan): HOLDS — searched `plans/` (listing + `grep -ril "research.workflow"`): the three proposals are the only RW plans; `logs/missions/` listing: `research-workflow-deploy-fitness.md` (active) and `promote-rw-canonical.md` (closed 2026-06-12, archived stub); `logs/work-loop/` listing: no other RW-named task.

Result: `plans/canonical-research-workflow-near-term-strategic-improvements-implementation-plan.md` created — one integrated proposed plan reconciling the three inputs as three layers of one system (lean = shape, retrieval = runtime, judgment = output quality) plus one named collision (R1/R2/R3 vs Light/Standard/Deep = one axis decision, gate G1). Six slices (S1 relay refactor, S2 Perplexity-ruling canonization, S3 filled source registry, S4 retrieval runtime [gated G2], S5 /research routes [gated G1], S6 judgment local trial), five operator gates (G1 tiers reopening, G2 Stage-2 automation reopening, G3 paid sources, G4 near-term cutoff approval, G5 mission-contract mechanics), deterministic-vs-representative proof split, near-term cutoff as Claude's attributed proposal, deferrals with owners, risks/stop conditions, completion condition, first slice = S1. Operating mode: Normal; no separate spec or ticket artifact (Work Loop units carry the ticket contract). No proposal content presented as approved; mission threads 3–8 explicitly not absorbed.

Evidence: structural proof — 18 grep checks on the file (exact title line, `Status: Proposed`, all ten required content sections, slice/gate markers) all PASS, with a negative control (`## 99. Nonexistent section`) that FAILS, proving the check can fail. Pre-change state: both destination searches returned no match (the failing case). Integrity: `git diff --check` exit 0; `git status --porcelain` shows only the new plan file, this state file, and the pre-existing hook-maintained `logs/friction-log.md` modification (left uncommitted, permitted by the brief). No implementation surface changed. Runtime profile: baseline capabilities only — read/search/inspection, one new plan file, this state file, local commit; no network, no external tools, no deployment.

## Blocker

None.

## Next action

Codex: assess the unit against the brief — the plan's repository grounding, the reconciliation of the three proposals into one sequence, whether authority boundaries survive (no proposal treated as approved; the two mission conflicts carried as gates G1/G2 rather than resolved), the slice/proof/gate structure, and the near-term cutoff being an attributed proposal with its operator decision exposed. Then close, continue, correct once, or stop.
