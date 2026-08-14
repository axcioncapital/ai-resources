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
Inspected (2026-08-14), Unit 4 (Discovery — planning-only, no target implementation):

- Claim (1) — approved proposal identity and Unit 3's status-only successor relationship: HOLDS.
  `git diff d8a89e0f7d4444bc1d3cabb963a6f49cdfc1ce67 5b0d5fd857a2d663dfc298071faf2033f884b0eb -- plans/work-loop-v2-v0.2/work-loop-v2-autonomy-authority-capability-proposal-v0.1.md`
  shows exactly the status-line change already recorded in Unit 3; `git hash-object` on the current
  working file returns `e2a50c5e6e82482ed81a37000ac927af4f5bc672`, matching commit `5b0d5fd8`'s tree
  exactly (no drift since Unit 3's commit). `git log --oneline -3` confirms `5b0d5fd8` is HEAD.

Produced the consolidated planning artifact at
`plans/work-loop-v2-v0.2/work-loop-v2-autonomy-authority-capability-implementation-plan-v0.1.md`,
containing Fixed Point, Repository Delta, Implementation Specification, and Execution Plan (tracers
T1–T7, a named evidence-gathering phase, and explicit deferrals), per the brief. It changes no target
implementation surface — the proposal, the executable core, the Codex skill, the Claude command,
`docs/autonomy-rules.md`, `docs/qc-independence.md`, `docs/audit-discipline.md`, the carrier, the
dispatcher, and workspace `CLAUDE.md` were all inspected, none edited.

Result: the plan is grounded in live repository inspection, not documentation alone —

- **Tracked-surface inventory** (all `git grep`/`git ls-tree`/`git log` on this checkout's tracked
  sources): `work-loop-v2-executable-core` (60 hits — live consumers isolated to the command and
  skill); `work-loop-v2-mvp-proposal-v0.4|Proposal wins` (21 hits — live authority hit is the core
  itself); `capability envelope|capability subset|capability profile|runtime profile` across the
  skill, command, core, `plans/**`, `docs/**` — **bounded negative result: zero hits**, confirming the
  capability-envelope/subset concept (proposal §3.2, §7, §11) does not exist anywhere in tracked
  sources today. `git -C .. rev-parse --show-toplevel` resolves to a **separate git repository**
  (`workspace-root`, remote `axcioncapital/workspace-root.git`); workspace `CLAUDE.md` is tracked
  there, outside this repository and this task's checkout/state-file/ownership scope — a boundary the
  proposal did not state and this plan now surfaces explicitly rather than absorbing silently.
- **Safe deterministic checks run** (hermetic; none launched a live Claude/Codex actor, the carrier,
  the dispatcher, or any external effect): `work-loop-v2-slice-1.test.sh` 308/0 (matches the count
  recorded in the closed `eval-v0-3-partial-fixes` task — no drift); `work-loop-v2-core-resolver.test.sh`
  4/0; `work-loop-owner.test.sh` 92/0; `dispatch.test.sh` (fully simulated) 454/0; `carry-turn.test.sh`
  (hermetic, fake actor) 285/0, including nested-actor assertions on both the observed and unobserved
  path — satisfying proposal §14 item 7's "verify ... on a host where process observation is
  available" as an evidence record rather than new code.
  **Deliberately not run:** any live Claude/Codex hop through the carrier or dispatcher, any
  `--unattended` live launch, and the twelve proposal §12 autonomy-scenario paired live trials —
  all would launch a real actor or cause an external effect, excluded by the brief and scheduled
  instead as Execution Plan tracer T7 (its own later phase, not this unit).
- **§14 traceability table** — all fifteen items mapped exactly once, to a tracer (T1–T6), the T7
  evidence-gathering phase, an already-true Fixed Point fact (item 6), a contingent follow-up (item
  12), or an explicit out-of-MVP deferral (items 13–15) — reproduced in the artifact.
- **Internal consistency check** — every tracer (T1–T7) carries all six required fields (Behaviour,
  Starting evidence, Intended change, Verification, Exit condition, Scope boundary) plus its
  `qc-independence.md` review row; every implementation surface a tracer names was classified first in
  Repository Delta and specified first in Implementation Specification (T1↔3.1, T2↔3.2, T3↔3.2,
  T4↔session-plan row, T5↔3.3, T6↔3.4, T7↔3.5) — reproduced in the artifact.

Evidence:
- `git diff --check` returned clean.
- `git diff --name-only` lists `logs/friction-log.md` and this state file. `logs/friction-log.md` is
  the same pre-existing unrelated change flagged at Unit 3 (untouched since, not staged here). The new
  planning artifact is untracked (`git status --porcelain` shows `??`) until this commit adds it — it
  is the one file this Discovery unit was scoped to create.
- No target-implementation file changed: `git status --porcelain` before and after this unit's work
  differs only by the two files this unit is authorized to touch (the new artifact, this state file)
  plus the pre-existing unrelated friction-log change.

## Blocker
None.

## Next action
Codex: assess the consolidated plan artifact — confirm the Fixed Point matches the approved proposal
without narrowing or widening §15, the Repository Delta's classifications and the workspace-`CLAUDE.md`
repository-boundary finding are sound, the Implementation Specification stays documentation/evidence-only
where the proposal defers enforcement, and the §14 traceability table and internal consistency check are
complete — then either open the fresh bounded implementation-plan review that freezes the plan, or hand
back specific findings for one bounded correction.
