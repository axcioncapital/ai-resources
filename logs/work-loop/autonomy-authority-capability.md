---
task: autonomy-authority-capability
turn: codex
---

## Objective and scope
Bring `plans/work-loop-v2-v0.2/work-loop-v2-autonomy-authority-capability-proposal-v0.1.md` to content-bound approval, then progress through bounded units until the approved capability is implemented and verified.

The operator wants the proposal implemented after readiness/QC. `/implementation-triage` remains explicitly excluded as evidence, authority, or a route for this task.

Operator process decision, 2026-08-14: implementation follows the Axcíon Standard Implementation Workflow in compact form. After the approval record is current, one consolidated planning unit must establish the Fixed Point, Repository Delta, Implementation Specification, and ordered vertical tracer bullets; one fresh implementation-plan review then freezes that plan before target implementation begins. The existing Work Loop remains the sole runtime state and supplies per-slice implementation, evidence, independent assessment, bounded correction, demonstration, and progression. Do not create parallel state or review systems.

## Lane and unit
Standard. Discovery mode. Unit 4 — establish the compact implementation Fixed Point, Repository Delta, Implementation Specification, and ordered vertical tracer-bullet plan in one consolidated planning artifact.

Named reason for the loop: the task remains a multi-unit, cross-cutting governance implementation whose consequential changes need independent assessment and must survive session boundaries.

## Brief
The proposal is now content-bound approved and truthfully recorded at commit `5b0d5fd857a2d663dfc298071faf2033f884b0eb`; the active Axcíon workflow position is **freeze → investigate → specify → slice**, before plan review or target implementation. This unit converts the accepted direction into one repository-grounded plan artifact so a fresh reviewer can judge and freeze a concrete path. It advances the approved implementation direction while preserving the proposal's explicit `implementation planning, not implementation itself` gate.

Governing authority and disposition:

- Current operator decision, 2026-08-14: the exact proposal at commit `d8a89e0f7d4444bc1d3cabb963a6f49cdfc1ce67`, blob `39c67196dcec35a1be8f4fcf8ea3ef6a50cfde0b`, is the governing implementation direction. Use its current status-only successor at commit `5b0d5fd857a2d663dfc298071faf2033f884b0eb`; no substantive approved content changed.
- Current operator process decision, 2026-08-14, recorded under `## Objective and scope`: use the Axcíon Standard Implementation Workflow in compact form, with this Work Loop as the sole runtime state. The operator-provided workflow source is `/Users/patrik.lindeberg/.codex/attachments/18e3181b-5534-4b7c-9fc2-fb520c455b97/pasted-text.txt`.
- The proposal's §14 sequence, §15 decisions and review gates, and §16 success standard govern the target. Proposal v0.4 is historical rationale once an approved executable-core revision becomes canonical; it is not silently discarded before that gate is completed.
- Live repository evidence governs the Repository Delta. Drafts, exploratory proposals, comments, and historical descriptions do not override the approved proposal or current operator decisions.

Required outcome: create one concise consolidated artifact at `plans/work-loop-v2-v0.2/work-loop-v2-autonomy-authority-capability-implementation-plan-v0.1.md` containing all four sections below. This single-file choice is Codex's framing decision to honor the operator's compact-workflow decision and avoid three overlapping planning documents.

1. **Fixed Point** — state the approved outcome, exact authoritative content identity, fixed decisions, explicit boundaries, and observable success condition. Preserve at minimum: the dual-key authority model; consequence scaling safeguards rather than automatically changing ownership; agent-delegated implementation judgment inside the solution envelope; attended carrier as the sole current Standard enforcement surface; the carrier's present lack of per-invocation sandbox/network enforcement; deferral of that enforcement, the connected-development trial, and unattended release beyond MVP; retention of the audit-derived harness-configuration confirmation and no-self-waiver rules; no new autonomy framework, state system, approval ledger, routine checklist, or assumed evaluation runner.
2. **Repository Delta** — inspect the actual relevant files, interfaces, runtime paths, tests, commands/scripts, dependencies, current behaviors, and only load-bearing history. Classify relevant components as Keep, Modify, Add, Remove, or Uncertain/requires proof. Identify ordering constraints and the few risky assumptions that could invalidate the plan. Explicitly resolve or surface the location/checkout boundary for workspace-level `CLAUDE.md` and any other target outside this bound repository; do not silently omit or absorb an external surface.
3. **Implementation Specification** — for each meaningful capability the approved MVP requires, define inputs, outputs, guaranteed behavior, failure behavior, side effects, public seam, and fail-capable evidence. Use the proposal's existing language. Distinguish semantic Work Loop behavior from capability enforcement, and distinguish the attended carrier from the separate unattended dispatcher.
4. **Execution Plan** — order small vertical tracer bullets, each with Behaviour, Starting evidence, Intended change, Verification, Exit condition, and Scope boundary. Target risky assumptions and real seams early. Map every proposal §14 item 1–15 exactly once to an implementation tracer, an operational-evidence unit, an operator/review gate, or an explicit deferral; do not turn horizontal file layers into units or promote later-release work into the MVP.

Plan-readiness requirements:

- Separate planning from authority: the artifact remains draft until a fresh bounded implementation-plan review accepts it and the plan is frozen. It grants no target-edit authority.
- Identify each high-consequence target named by proposal §15 and the proportional pre-implementation review/premise evidence it needs. Do not merge all high-consequence surfaces into one implementation unit merely because one plan describes them.
- Preserve the current Work Loop state file as the only runtime state. Do not create progress trackers, review ledgers, risk documents, test-strategy documents, or parallel handoffs.
- Keep mechanisms as repository-derived technical design, not invented requirements. Where the approved proposal deliberately leaves a mechanism open, record the evidence/behavior that must govern the later choice.
- Record genuine unknowns as Uncertain/requires proof or as a tracer's starting evidence. Do not resolve them from documentation alone when current executable behavior can be inspected safely.

Check against the repository before writing:

1. Verify the approved proposal identity and Unit 3's status-only successor relationship.
2. Inventory tracked consumers of the executable core, its v0.4 authority language, the governing autonomy rule, capability-selection context in briefs/evidence, nested-actor prevention, carrier enforcement, and the evaluation surfaces. Bound every absence claim to named tracked paths and patterns; use tracked-source searches rather than an unbounded repository crawl.
3. Inspect the current tests and safe deterministic checks for those seams. Do not launch Claude/Codex, the carrier, the dispatcher, a live external trial, or any external effect in this planning unit. If a cited check would do so, inspect it and mark it for a later controlled tracer instead of running it.
4. Reconcile proposal §14 against repository reality and the compact workflow. If an item is already implemented, prove it and classify it Keep rather than planning duplicate work.

Required fail-capable evidence:

- Report the exact tracked surfaces and search patterns used for the consumer/current-behavior inventory, including bounded negative results.
- Report the safe deterministic checks actually run and their outcomes; identify relevant checks deliberately not run because they launch actors or cause external effects.
- Include a §14 traceability table whose failure condition is any omitted, duplicated, silently promoted, or silently dropped item.
- Include an internal consistency check showing every tracer bullet has all six required contract fields and that every proposed implementation surface appears in the Repository Delta and Implementation Specification before it appears in a tracer.
- Run `git diff --check` and report it. Report `git diff --name-only`, distinguishing pre-existing unrelated changes.

Scope: the one new implementation-plan artifact and this state file only. Excluded: edits to the approved proposal; executable core; proposal v0.4; Codex or Claude adapters; autonomy/QC/audit rules; permissions or hooks; workspace `CLAUDE.md`; carrier/dispatcher code; evaluation code, fixtures, or trial records; and every target implementation change. The exclusions are Codex's framing decision because this is a Discovery unit whose evidence must resolve the implementation path before any high-consequence edit begins.

Completion condition: produce the consolidated planning artifact and evidence, record the result here, set `turn: codex`, commit only the artifact and state-file handback, and stop. Do not review/freeze the plan yourself and do not begin any target implementation.

Stop conditions: hand back without target edits if the approved content identity fails, repository reality materially contradicts a fixed decision, the plan cannot cover the approved MVP without expanding scope or authority, a required external repository/checkout cannot be inspected, or meaningful plan evidence would require launching an actor or causing an external effect. Challenge a false premise rather than hiding it in the plan.

## Latest result
Correction round on Unit 4's consolidated implementation plan. All five frozen findings reproduced by
inspection first (none was stale), then corrected in
`plans/work-loop-v2-v0.2/work-loop-v2-autonomy-authority-capability-implementation-plan-v0.1.md`. No
target-implementation surface changed — same exclusion list as Unit 4.

**Finding 1 (false capability-concept absence claim) — corrected.** Reproduced first:
`git grep -ln "capability envelope\|capability subset\|capability profile\|runtime profile"` with no
path restriction returns exactly two files — the approved proposal (§3.2's "Plan capability envelope" /
"Runtime profile", §7) and the plan itself. The finding was real. Correction: the plan's Repository Delta
now states the search accurately — the concept is *described* in the governing proposal, and separately
confirmed **absent from all eight live implementation surfaces** (skill, command, executable core,
`docs/autonomy-rules.md`, `docs/qc-independence.md`, `docs/audit-discipline.md`, `carry-turn.sh`,
`dispatch.sh` — reproduced zero-hit on that bounded set). Every downstream `greenfield`/`zero-hit`
conclusion (Components table row, § 3.3 Inputs, T5 Starting evidence) was rewritten to the corrected,
narrower claim.

**Finding 2 (unsupported workspace `CLAUDE.md` requirement) — corrected.** Reproduced first: proposal
§14 item 3 (line 487) names only "the Codex skill, Claude command, autonomy rules, and session-plan
language" — not workspace `CLAUDE.md`. §15's closing paragraph (line 521) is conditional ("changes to
... remain a separate high-consequence unit"), not a mandate that a change occurs. A bounded read of
workspace `CLAUDE.md` lines 129–133 (`## Autonomy Rules`) found only a pointer to
`ai-resources/docs/autonomy-rules.md` (already reconciled at T3) and no competing or conflicting
statement. The finding was real. Correction: the Components table row, both ordering-constraint entries,
and the "Deferred" section's first bullet now classify the file **Keep — repository-boundary finding
retained, no required edit proven**; no tracer touches it; the separate-git-repository fact is kept as a
standing constraint for *if* future evidence proves otherwise, not as a scheduled deferral.

**Finding 3 (review-row accuracy) — corrected.** Reproduced first: §15's closing paragraph names
`docs/autonomy-rules.md` and "the executable core" both explicitly, with no size exception — the plan's
T3 had proposed "normal/consequential, confirm at review" and T5 had permitted core placement under a
normal review. Both were real gaps. Correction: T3's review row is now risk-aware Codex review (matching
T1's tier), citing §15 directly. T5 is redesigned to place its content in the Codex skill only (not the
executable core) — a placement decision marked as Claude's own framing choice with its reason (§5 Step 2,
smallest sufficient option) — so its normal-review tier is now actually correct rather than assumed; § 3.3
and T5 both carry the placement decision explicitly.

**Finding 4 (scenario suite vs. real-task evidence conflated) — corrected.** Reproduced first: proposal
§14 items 8–9 (scenario suite) and item 10 (`3–5 real Standard tasks across at least two capability
shapes`) are separate numbered steps under "Evidence-gathering period," and item 10's "real" tasks are
categorically different from item 8's "paired live behavioural trials." T7 had folded item 10 into the
same twelve constructed trials. The finding was real. Correction: T7 is now scoped to items 8–9 only; a
new T8 covers items 10–11 (3–5 organic Standard-lane tasks across ≥2 capability shapes, with the item-11
measures tallied against them); § 3.5 is corrected and a new § 3.6 added; the §14 traceability table and
internal consistency check are updated for items 9–12 and T8.

**Finding 5 (fail-capable specificity) — corrected.** Reproduced first: T1's cited resolver-suite check
proves consumer path resolution, not that the old subordination line is gone or the new clause is
present; T2 cited pre-existing CE-9/orientation assertions that do not exercise a new citation; T5's
five-heading count and sample text do not distinguish a *requested* capability from one the carrier has
actually *enforced/observed* — and the carrier's own confirmed MVP list (proposal §11, verified live by
this plan's test runs) does not include sandbox/network enforcement. All three gaps were real. Correction:
T1 now specifies three independent checks (subordination-line absence, clause-text presence, resolver
suite for drift); T2 now specifies a new targeted before/after grep instead of relying on unrelated
existing assertions; T5/§3.3 now require any recorded "effective profile" to state sandbox/network
capabilities as "requested, not carrier-verified" rather than "effective," mirroring the carrier's own
`nested=unobserved` vs `nested=0` honesty convention.

### Verification that the corrections themselves are consistent

- `git diff --check` on the corrected plan: clean.
- `git diff --name-only`: `logs/friction-log.md` (same pre-existing unrelated change, still untouched),
  this state file, and the plan artifact — no target-implementation file touched by this correction round
  either.
- Swept the corrected file for stale references: no bare `T1–T7` remains; every `T7` reference now reads
  either the corrected scope-8–9 tracer or a `T7 and T8` pairing; the internal consistency check and
  traceability table both cite `T1–T8`.

## Blocker
None.

## Next action
Codex: run the closure check on findings 1–5 only — are they resolved, and did the correction break
anything? One item noticed while correcting Finding 2 is a candidate deferral, not implemented: the
"Deferred, not scheduled" section's second bullet still lists proposal item **11** among the
out-of-MVP-deferred items (`§14 items 6, 11, 13–15`); that citation predates this correction round, item
11 is actually covered by T7/T8 rather than deferred, and it was left untouched because it falls outside
the five frozen findings. Close the task, or use the §3 "if the correction was not enough" menu if a
finding did not resolve cleanly.
