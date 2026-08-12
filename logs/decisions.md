# Decision Journal

> Archive: [decisions-archive-2026-08.md](decisions-archive-2026-08.md)

## 2026-08-09 — Close work-loop-v2-production-readiness-policy without a Codex assessment

**Context.** The task's discovery unit was complete and committed at `turn: codex`, awaiting Codex's
assessment of the recommended production policy (§ 3), five operator decisions (§ 4) and five
implementation units (§ 5). The operator directed that Codex not be used for this assessment.

**Decision.** Replace the Codex assessment with an independent `/research` subagent pass that
re-verified all eight of the discovery's findings against the live repository by opening the actual
files, rather than trusting the discovery's own prose. Act on that verdict directly rather than
waiting for Codex.

**Rationale.** The research surfaced a material change the discovery could not have known about:
commit `9c66f26` (2026-08-07) added `dispatch.sh --unattended`, which disables the dispatched child's
hooks entirely. That made the discovery's central recommendation for the shared-writer problem
(D1 — edit `log-write-activity.sh` to suppress telemetry for dispatched actors) unnecessary: the
ambient writer cannot fire in a contained hop, so there is nothing left to suppress. D1 was replaced
with a launch precondition (`--unattended`) rather than a hook edit, and the plan's only planned
structural-change unit (U2) was dropped as a result.

**Alternatives considered.**
- *Wait for Codex, as the protocol's normal path.* Rejected by explicit operator direction — the
  operator judged the research route sufficient for this task's stakes.
- *Execute the discovery's recommendation unchanged (D1 as originally written).* Rejected once the
  research showed it was superseded: it would have spent a structural-class hook edit and its
  risk-aware review on a problem that had already stopped existing three days earlier.
- *Treat the state file as final without re-verification.* Rejected — the discovery was three days
  old, several commits had landed since, and the state file's own protocol (core § 6 rule 1) requires
  checking claims against the live repository before acting on them, regardless of which party does
  the checking.

**Recorded departure from protocol.** The Work Loop v2 executable core assigns the close verdict to
Codex (§ 3 step 5); this closure did not go through that step. It is recorded in the closed state
file's Accepted limitations as an operator-directed exception for this task, not as a change to the
protocol itself.

## 2026-08-11 — Tailored structural-resolution route for the Work Loop v2 bounded-execution incident

**Context.** A 2026-08-10 Work Loop v2 session escaped its bounded courier path into an interactive
Claude session that spawned ≥13 Claude processes to test instruction files. Claude's first-pass fix
plan recommended adding a control (`--allow-nested-actors N`) without first comparing removal or
simplification, and it self-contradicted about what the proposed control could prove.

**Decision.** The operator directed a tailored eight-step route rather than a full run of the
Repository Problem Resolution SOP's Lane B: establish the failure from preserved run evidence (no
live reproduction); a blind raw-evidence review by a genuinely fresh Codex context; Claude reconciles
that into a causal model and options at a zero complexity budget; operator scope approval; isolated
clean-checkout implementation; independent verification; one genuine attended pilot capped at one
Claude invocation and ten minutes; close only on observed behaviour, not harness success alone. The
SOP is applied as non-governing methodology, subordinate to the Work Loop v2 executable core — it adds
no state-file field and does not override core close/continue/correct/stop.

**Rationale.** The incident's root mechanism was unbounded verification cost from nested AI
invocation. A route that itself required a costly live reproduction or new AI-backed verification
before design approval would repeat the failure it exists to prevent. Establishing failure from
already-preserved evidence, and deferring construction decisions to a design gate, keeps the
correction bounded while still passing through independent challenge before any implementation.

**Alternatives considered.**
- *Run the full unmodified SOP Lane B sequence.* Not rejected in substance — the tailoring keeps all
  five Lane B gates — but the route was made explicit and case-specific rather than assumed generic,
  because a generic run would have invited exactly the same disproportionate-verification failure at
  a different step.
- *Accept Claude's first-pass plan as final.* Rejected — it proposed new permanent machinery
  (`--allow-nested-actors N`) with no verified authorised use case anywhere in the evidence, and
  self-contradicted about whether its own proposed control was containment.

**Recorded departure from protocol.** None — this decision operates alongside the Work Loop v2 core
rather than against it; the SOP's subordination to the core, and the prohibition on it creating a
second state system, are stated explicitly in the accepted plan
(`plans/work-loop-v2-v0.2/bounded-execution-fix-plan-v0.1.md` § 0.1).

## 2026-08-11 — Second bounded-execution incident joins the plan, scoped to system-level lessons only

**Context.** A second Work Loop v2 dispatcher stop occurred 2026-08-11, in a different worktree
(`../ai-resources-eval`, task `eval-mvp-v0.2-adoption-readiness-fix`): a 900-second actor timeout
(exit `21`), reportedly caused by an oversized implementation unit. The operator supplied a detailed
incident report and asked whether it belonged inside `bounded-execution-fix-plan-v0.2.md`.

**Decision.** Yes, in the same plan — but only its system-level lessons. In scope: the eval timeout as
a second verify-first entry in Gate 2's evidence set; brief sizing promoted P1→P0; U2's evidence
extended to exit 21; U4 expanded into a truthful recovery contract; a rejection of "raise the
timeout" as a substitute fix; the eval evidence chain added to the compaction-safe manifest. Out of
scope, named explicitly and excluded from the plan: the EV-1 through EV-6 content repairs, the
staging-hook registry correction, the eval branch's merge readiness, and its stale suite baselines.

**Rationale.** The two incidents are the two failure modes of the same courier boundary — one escaped
it, one couldn't fit inside it — so the system-level fix belongs in one place. But the eval content
issues are evidence *of* the sizing defect this plan addresses, not instances *of* the dispatcher
defect itself; folding them in would let an already-oversized-unit incident produce an oversized
planning artifact, which is the exact failure mode under discussion.

**Alternatives considered.** (a) A separate plan for incident 2 — rejected, because the two incidents
share a root mechanism (courier boundary) and splitting the plan would duplicate §§ 0.5–0.7's
manifest, ladder and courier-preservation reasoning. (b) Importing the eval content findings wholesale
— rejected for the reason above; also would have pulled unrelated-task commits into this plan's
review surface. (c) Treating incident 2 as fully confirmed rather than verify-first — rejected; every
report is a lead until checked against its own named artifacts (SOP `:435`), and this one had not
been.
