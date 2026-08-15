# Work Loop v2 Dispatcher Target-Alignment Proposal v0.1

**Date:** 2026-08-15  
**Status:** Proposal for operator approval. This document does not authorize implementation.  
**Purpose:** Extend the reliable supervised dispatcher defined by the dispatcher reliability closure report into a thin semi-autonomous control plane that can admit an approved task, route structured outcomes, repair ordinary technical failures, resolve low-value boundary questions, and return either a trustworthy completion report or one genuine operator decision.  
**Design constraint:** Add the smallest useful control behavior to the existing dispatcher. Do not create a second state system, policy engine, workflow service, agent hierarchy, dashboard, or general-purpose scheduler.

---

## 1. Executive proposal

The dispatcher reliability closure package should remain the foundation. Its concurrency controls, canonical durable state, semantic authority, permission transport, universal terminal results, exact evidence handshakes, runtime preflight, execution budgets, operator takeover, safe resume, and live trials are necessary and should not be redesigned here.

This proposal adds six target-alignment capabilities:

1. **Task-contract admission and minimum route selection** before a model is launched.
2. **One structured actor handback and deterministic next-action router** instead of routing from free-form prose.
3. **Bounded executor-internal self-repair** for ordinary technical failures.
4. **A narrow Decision Resolver** that returns `ALLOW`, `DENY_AND_REPAIR`, or `OPERATOR`.
5. **Evidence-rendered completion and decision reports** for Patrik.
6. **A minimal append-only event journal** for operating analysis and later policy improvement.

These six capabilities operate under three cross-cutting safety contracts: non-negotiable execution invariants, explicit replay safety, and a narrowly bounded reconciliation transition. They are constraints on the six additions, not new agents or subsystems.

The additions preserve the governing operating rule:

> **Continue automatically while task identity, durable state, evidence, authority, runtime and budgets agree. Resolve ordinary implementation uncertainty inside the approved envelope. Ask Patrik only when continuing requires a genuinely operator-owned decision or a capability grant that does not already exist.**

This proposal does not seek unattended or walk-away release. It advances the supervised dispatcher from reliable turn transport to reliable target-aligned orchestration. Full-lifetime containment and unattended-host proof remain governed by the deferred Gate U work in the dispatcher reliability closure report.

---

## 2. Operating outcome

After this proposal and its prerequisites are implemented and proven, Patrik should be able to launch an approved bounded task and receive one of two outcomes.

### Successful outcome

The dispatcher:

1. validates that the task is executable;
2. selects or confirms the minimum Work Loop route;
3. launches the executor inside the approved semantic and capability envelopes;
4. lets the executor diagnose and repair ordinary technical failures within a bounded execution phase;
5. validates the handback and proof;
6. obtains independent review;
7. routes one bounded correction when authorized;
8. closes the task; and
9. produces a concise completion report from durable evidence.

Patrik does not manually carry turns, approve routine technical adaptations, or act as the debugging mechanism.

### Operator-decision outcome

When a material boundary appears, the dispatcher:

1. determines whether existing evidence or authority already resolves it;
2. denies unsafe proposals and returns them for repair;
3. escalates only when a genuine operator-owned decision remains;
4. writes legal `blocked/operator` durable state;
5. presents the exact decision, options, consequences, recommendation, current safety and resume action; and
6. resumes only after Patrik's decision is recorded and the complete run is revalidated.

Transport failures, missing results, contradictory state, unavailable capabilities and uncertain process teardown remain technical blockers. They are not converted into product or architecture decisions merely to let the run continue.

---

## 3. Relationship to existing dispatcher work

### 3.1 Required foundation

This proposal assumes the following have been completed and integrated:

- concurrency Phase 1 and its shared task and checkout leases;
- the frozen durable-state implementation and canonical validator;
- the autonomy-authority implementation and canonical solution/capability-envelope semantics; and
- dispatcher reliability closure items R1–R8.

Gate SA remains a prerequisite for final adoption. This proposal does not weaken any Gate SA statement.

### 3.2 Shared seams, not duplicate systems

Where this proposal overlaps the closure package, implementation must extend the existing seam:

| Existing seam | Target-alignment extension |
|---|---|
| Canonical task record | Adds admitted route, structured current phase and resolver outcome only where the canonical schema permits them. |
| Universal terminal result | Carries the structured actor outcome and report/event references; no second final-result format. |
| Exact producer-consumer handshake | Transports the structured handback at the same run-bound evidence path. |
| Capability envelope and runtime profile | Admission validates completeness; the dispatcher does not invent or widen grants. |
| Operator takeover packet | Adds semantic decision options and consequences when the blocker is a genuine decision. |
| Read-only status | Shows admitted route, current phase, last structured outcome and next required action. |
| Run evidence directory | Holds the observational event journal and rendered reports; no separate observability store. |

The reliability foundation also owns three implementation-safety contracts that this proposal consumes rather than duplicates: actor-writable semantic state versus trusted control-field ownership, transition-by-transition durable write/crash ordering, and hostile identifier/path/handback parsing. Gate ST cannot pass unless those Gate SA requirements remain green through the target-alignment changes.

### 3.3 Boundary with unattended operation

This proposal supports supervised semi-autonomous execution on a supported awake host. It does not claim that every descendant is contained for its full lifetime, that closed-lid operation is reliable, or that the release host's effective isolation has passed Gate U. Unknown teardown continues to pin the applicable lease and block automatic reuse.

---

## 4. Proposed dispatcher operating model

The dispatcher remains a control plane, not an implementer.

```text
operator-approved task
        |
        v
task admission and route selection
        |
        v
acquire ownership and leases
        |
        v
executor: inspect -> implement -> prove
        |
        +-- ordinary technical failure
        |       |
        |       v
        |   diagnose -> bounded repair -> re-prove
        |       |
        |       +-- repeated/no-new-evidence/boundary -> structured handback
        |
        v
validate structured handback
        |
        +-- operational inconsistency -----> canonical reconciliation
        |                                           |
        |                         +-----------------+----------------+
        |                         |                                  |
        |                 RECONCILED_SAFE                   RECONCILE_BLOCKED
        |                         |                                  |
        |                 resume validated phase              blocked/operator
        |
        v
independent assessment
        |
        +-- pass ----------------------------> closure
        |
        +-- authorized correction -----------> correct -> reassess
        |
        +-- boundary-adjacent question ------> Decision Resolver
        |                                          |
        |                    +---------------------+--------------------+
        |                    |                     |                    |
        |                  ALLOW           DENY_AND_REPAIR          OPERATOR
        |                    |                     |                    |
        |                 continue             repair path       blocked/operator
        |
        +-- transport/evidence/runtime failure -----------------> blocked/operator
        |
        v
validate closure -> completion report -> done
```

The router advances only from validated durable state plus validated run evidence. A process exit code, prose claim, or file appearance alone never determines the next phase.

### 4.1 Non-negotiable execution invariants

The dispatcher, every actor and the Decision Resolver must never:

1. weaken, remove or reinterpret acceptance criteria to obtain a pass;
2. silently change the intended outcome, materially broaden scope or remove an exclusion;
3. override failed or unavailable load-bearing proof;
4. continue while canonical state, required evidence, Git facts, ownership or lease facts materially disagree;
5. widen semantic authority, capability authority or the control system from inside the executing task; or
6. infer completion from an artifact when the required producer handback or terminal result is missing.

These rules sit above agent judgment. The Decision Resolver cannot reinterpret or waive them. A material disagreement must be reconciled through the canonical validator or must stop; it is never converted into permission to continue.

---

## 5. Addition A — Task-contract admission and minimum route selection

### 5.1 Purpose

The reliability closure report begins with a prepared task. The target dispatcher must first establish that the task really is prepared enough to run. Admission prevents paid execution from discovering missing intent, proof, workspace or authority after a model has started.

### 5.2 Minimum admitted contract

Every dispatcher run must resolve the following fields from the canonical task record and its approved authorities:

```yaml
task_id: stable task identity
outcome: behavior or condition that must become true
acceptance: fail-capable proof of that outcome
protected_constraints: behavior, files, systems or decisions that must not change
scope:
  included: approved implementation boundary
  excluded: explicit exclusions
authority:
  delegated_decisions: implementation judgment the actors may exercise
  operator_reserved: decisions that must return to Patrik
  bindings:
    plan_or_spec: exact path and approved content fingerprint
    operator_decisions: exact load-bearing decision fingerprints
capabilities:
  write_paths: approved write boundary
  permission_mode: requested dispatcher permission profile
  network: approved network profile or none
  external_effects: explicitly approved effects or none
  nested_actors: approved count, zero by default
workspace:
  checkout: exact checkout
  branch: exact branch when applicable
  base_head: approved starting HEAD
environment:
  shared_resources: none or exact declared ports, services, databases or caches
  non_git_effects: none or exact approved hook, global-config or external-effect profile
budgets:
  run: hop, deadline and usage limits
  closure_reserve: required closing actor and finalization capacity
  recovery_reserve: required teardown and evidence-finalization time
route: explicit route or enough facts for deterministic selection
proof: exact command, scenario or assessment method
```

The physical schema may reuse existing fields and references. This proposal requires the information, not a second task-contract file.

### 5.3 Deterministic route selection

The initial dispatcher supports only three semantic route classes, mapped to the existing installed Work Loop entrypoints during implementation:

| Route class | Admission condition |
|---|---|
| `repair` | A specific fault and reproduction/proof seam are identified; intended behavior is already settled. |
| `bounded_implementation` | Outcome, acceptance, boundaries and authority are settled without a separate material implementation plan. |
| `plan_backed_implementation` | An approved plan or specification defines the material capability and current bounded unit. |

Selection rules:

1. A valid explicit route wins.
2. An approved active plan selects `plan_backed_implementation`.
3. A reproducible fault with settled intended behavior selects `repair`.
4. A complete concise task contract selects `bounded_implementation`.
5. `base_head` and every load-bearing authority fingerprint must match current repository reality; drift requires explicit task revalidation before admission.
6. Undeclared shared resources or non-Git effects refuse admission. The initial release accepts `none` or an exact supported profile; it does not infer environmental isolation from a clean Git status.
7. Material ambiguity between routes is an admission blocker; the dispatcher does not invent planning authority.

No automatic architecture planning, task decomposition, project prioritization or task creation is introduced.

### 5.4 Admission outcomes

Admission returns exactly one of:

```text
ADMITTED
task and route are executable

PREPARATION_REQUIRED
one or more load-bearing contract fields are missing or contradictory

REFUSED
ownership, state, runtime, policy or workspace cannot safely admit the run
```

`PREPARATION_REQUIRED` and `REFUSED` occur before actor launch and use the universal terminal result. Only named deterministic zero-model corrections allowed by the closure package may run automatically.

### 5.5 Proof

- a complete contract selects the expected route without a model request;
- each missing load-bearing field names the exact preparation requirement;
- contradictory checkout, owner, state or capability facts refuse before actor launch;
- stale base HEAD or load-bearing authority fingerprints refuse until the task contract is explicitly revalidated;
- undeclared ports, services, databases, caches, hooks, global configuration or other non-Git effects refuse before actor launch;
- an explicit approved route is never silently replaced;
- the admission check cannot alter semantic authority or widen the runtime profile; and
- an arbitrarily named supported worktree admits only from its complete local runtime.

---

## 6. Addition B — Structured actor handback and next-action router

### 6.1 Purpose

Every top-level actor must return a machine-validated result that distinguishes implementation success, repairable technical work, a boundary question and an execution blocker. The dispatcher must never infer the next phase from free-form narrative.

### 6.2 Handback contract

The exact serialization may be shell-safe key/value output or another already supported machine-readable form. It must carry at least:

```yaml
protocol_version: supported version
task_id: exact task
run_id: exact dispatcher run
actor: executor | reviewer | resolver | closer
phase: admitted phase
outcome: pass | repair_needed | decision_needed | reconcile_needed | blocked
classification: implementation | intent | capability | permission | evidence | runtime | control | reconciliation
state_transition: exact expected durable transition or none
proposed_next_action: bounded next action
new_evidence: evidence paths or identifiers
scope_effect: none | non_material | material
authority_required: existing | missing | operator
proof_status: passed | failed | unavailable | not_applicable
changed_paths: observed path set or none
```

Human explanation remains useful, but it is supplementary. The structured fields govern routing.

### 6.3 Validation

The dispatcher rejects the handback when:

- task, run, actor or phase identity does not match;
- the protocol version is unsupported;
- required fields are absent or invalid;
- the claimed state transition does not match canonical state;
- `pass` conflicts with failed or unavailable load-bearing proof;
- changed paths exceed the admitted write envelope;
- `authority_required=existing` contradicts the canonical capability envelope; or
- the handback conflicts with HEAD, index, working-tree, lease or process observations.

A rejected handback becomes an evidence blocker. It is never converted into success and never automatically retried after a model request started.

### 6.4 Initial transition table

| Validated condition | Dispatcher action |
|---|---|
| Executor `pass`, proof passed, expected transition present | Launch independent assessment. |
| Reviewer `pass`, no unresolved material finding | Launch or validate closure. |
| `repair_needed`, implementation-class, inside both envelopes, budget available | Enter the authorized repair path. |
| `decision_needed`, boundary-adjacent, evidence sufficient for resolution | Invoke the Decision Resolver or consume the resolver classification already produced by the reviewer. |
| `reconcile_needed`, or a dispatcher-observed operational inconsistency | Invoke the canonical reconciliation transition; continue only on `RECONCILED_SAFE`. |
| Resolver `ALLOW` | Record the resolution and continue from the approved next action. |
| Resolver `DENY_AND_REPAIR` | Record the denial and return to a bounded repair path without expanding scope. |
| Resolver `OPERATOR` | Enter legal `blocked/operator` state and render the decision packet. |
| Capability absent, permission expansion required, load-bearing proof unavailable, unreconciled contradictory state or unsafe runtime | Enter operator takeover or mandatory technical handback according to canonical authority policy. |
| Any invalid or missing handback | Stop as an evidence blocker. |

The table is exhaustive for the supported protocol. An unknown combination fails closed.

### 6.5 Proof

- every supported handback maps to one deterministic next action;
- every invalid combination fails closed;
- free-form prose cannot override the structured result;
- actor exit zero without the required handback and state transition blocks;
- the dispatcher cannot launch while canonical state is `blocked/operator`;
- replaying an old handback under a new run identity is refused;
- a known deterministic operational inconsistency can become `RECONCILED_SAFE`; and
- missing terminal evidence, partial effects and ambiguous repository drift become `RECONCILE_BLOCKED`, never reconstructed success.

### 6.6 Reconciliation transition

Operational inconsistency is neither implementation failure nor an operator decision. The dispatcher therefore exposes one first-class transition:

```text
RECONCILE_NEEDED
        |
        v
canonical validator/reconciler compares durable state
with Git, ownership, leases, processes and run evidence
        |
        +-- RECONCILED_SAFE ----> continue from validated durable next action
        |
        +-- RECONCILE_BLOCKED --> durable blocker and actionable recovery packet
```

An actor may report an observed inconsistency, but it cannot authorize or perform the reconciliation. The dispatcher invokes the canonical validator and recovery capability; it must not gain a second lifecycle parser or dispatcher-local state-repair rules.

Automatic continuation after reconciliation is permitted only when all are true:

- the reconciliation belongs to a named deterministic class;
- the correction is fully owned by the canonical validator/recovery capability;
- no model request started after the last stable checkpoint;
- task meaning, capability envelope, HEAD, index and working tree are unchanged;
- no persistent, external or partial effect is present;
- the required producer handback and terminal result exist and validate;
- ownership and lease facts prove continuation is safe; and
- the original whole-run budgets remain valid.

The following cannot become automatic `RECONCILED_SAFE` in the initial release:

- a proof artifact whose promised producer handback is missing;
- a missing final result or completion marker;
- HEAD, index or working-tree drift after interruption;
- a started model request with an unknown final outcome;
- a lease whose former holder or descendant teardown is uncertain; or
- an external or persistent effect whose completion cannot be proven.

Those conditions become `RECONCILE_BLOCKED`. Reconciliation may classify and preserve their facts, but it may not infer completion, replay the request or authorize continuation.

---

## 7. Addition C — Bounded executor-internal self-repair

### 7.1 Purpose

Ordinary proof failures are implementation work. Patrik should not become the debugging mechanism, and the outer reviewer-correction allowance should not be consumed by failures the executor can diagnose while performing the original unit.

### 7.2 Two distinct repair layers

| Layer | Trigger | Owner | Initial ceiling |
|---|---|---|---|
| Executor-internal repair | A test, build, lint, type, scenario or local premise fails during the implementation hop. | Executor | Two repair iterations within the one actor launch. |
| Reviewer correction | Independent assessment identifies a material defect after executor handback. | Existing correction path | One correction and one reassessment, as defined by the closure report. |

The two ceilings are not combined into a general retry counter. An executor-internal repair does not authorize another model launch, another capability, broader scope or weaker proof.

### 7.3 Conditions for an internal repair

The executor may repair automatically only when all are true:

- the intended outcome and acceptance criteria remain unchanged;
- the failure is classified as implementation uncertainty;
- the repair remains inside the admitted write and capability envelopes;
- no protected constraint or operator-owned settled decision is reopened;
- the proposed repair does not weaken, remove or bypass proof;
- the next attempt has a new diagnosis, new evidence or materially different mechanism;
- the actor and whole-run deadline and usage budgets remain valid; and
- no unexpected external effect, nested actor or contradictory repository fact exists.

### 7.4 Stop conditions

The executor must hand back instead of continuing when:

- the same failure recurs without a materially new hypothesis;
- two internal repair iterations are exhausted;
- repair would materially expand scope or change intent;
- the accepted plan or a load-bearing premise appears invalid;
- required proof is unavailable;
- a new capability or permission grant is required;
- the repair would weaken the control system or acceptance condition; or
- deadline or usage budget is exhausted.

The handback states the attempts, evidence gained, remaining failure and proposed next action. A started actor is never automatically relaunched merely because its repository diff appears unchanged.

### 7.5 Initial evidence-sensitive rule

The fixed ceiling is a safety cap, not the only circuit breaker. Every repair after the first failure must demonstrate at least one of:

- a newly established root cause;
- a newly falsified load-bearing assumption;
- a materially different implementation route;
- a newly localized failure boundary; or
- new deterministic evidence that changes the next action.

Trying variants of the same failed idea does not qualify.

### 7.6 Proof

- a representative test failure is diagnosed, repaired and re-proven inside one executor hop;
- a second distinct failure may be repaired only with new evidence;
- repeated identical failure stops without consuming another model launch;
- an attempted weakening of proof is refused;
- a material scope change becomes `decision_needed`, not an internal repair; and
- reviewer correction remains separately bounded and observable.

---

## 8. Addition D — Narrow Decision Resolver

### 8.1 Purpose

The Decision Resolver removes approval theatre. It asks only whether a proposed boundary-adjacent action is already authorized, must be denied, or truly belongs to Patrik.

It is not a planner, general arbitrator, implementation agent, approval service or policy author.

### 8.2 Invocation rules

The resolver is invoked only when:

1. a validated actor or reviewer handback reports `decision_needed`;
2. the question is specific and bounded;
3. available evidence has been gathered or the exact missing evidence is named;
4. the issue is not already a deterministic mandatory-stop class; and
5. the one-invocation resolver budget remains available.

Obvious cases are handled without a resolver model call:

- actions explicitly inside the task and capability envelopes proceed;
- explicit operator-reserved classes go to Patrik;
- unauthorized capabilities cannot be inferred;
- bypassing or weakening the control system is denied or technically blocked; and
- contradictory or insufficient evidence stops as an evidence blocker.

The initial semantic resolver role should reuse the existing independent Codex capability where practical. It is selected per invocation; this proposal creates no repository-wide model default and no permanent new agent.

A dedicated resolver invocation starts with a fresh, minimal context assembled from the admitted contract, governing authority and exact evidence references. It does not inherit the executor transcript, a prior resolver chain of thought, or unsupported persuasive narrative. A reviewer resolving the same question inside its existing assessment must produce the identical structured authority/evidence fields and may not cite its own earlier recommendation as evidence.

### 8.3 Resolver input

The resolver receives the minimum sufficient context:

```yaml
task_contract: outcome, acceptance, constraints, scope and authority
question: exact proposed action or decision
reason: why the current actor believes a boundary may exist
evidence: selected repository, policy, history and proof references
effects: paths, capabilities, reversibility and external consequences
recommendation: actor recommendation, if any
```

It does not receive the full transcript by default.

### 8.4 Decision test

`ALLOW` requires all five statements to be true:

1. **Intent preserved:** the approved outcome and acceptance conditions remain unchanged.
2. **Boundary preserved:** the action is inside the approved scope or a necessary non-material implementation consequence.
3. **Risk bounded:** the action is reversible or its material risk is already accepted and contained.
4. **Evidence sufficient:** repository reality, policy or prior decisions support the action without inventing intent.
5. **No material trade-off:** a reasonable operator is not being asked to choose between materially different outcomes.

If the proposal violates an approved constraint or attempts to bypass proof or control, the result is `DENY_AND_REPAIR`.

If one of the five statements cannot be established and continuing requires operator-owned intent, accepted risk, material solution-envelope change or capability-envelope expansion, the result is `OPERATOR`.

### 8.5 Resolver output

```yaml
decision: ALLOW | DENY_AND_REPAIR | OPERATOR
question_id: stable identifier
governing_authority: exact authority reference
evidence: exact evidence references
rationale: concise reason
conditions: bounded conditions or none
next_action: exact durable next action
```

`ALLOW` grants no new capability and may not exceed the existing envelopes. `DENY_AND_REPAIR` grants correction authority only for an already admitted repair path. `OPERATOR` identifies the exact missing operator decision.

### 8.6 Budget and continuation

- At most one dedicated resolver invocation may occur in a run.
- A reviewer may supply the same structured resolution during its existing assessment without consuming a separate invocation.
- Resolver continuation remains subject to the existing whole-run hop, deadline, usage and correction budgets.
- If continuation would exceed any approved budget, the resolver result is recorded but the dispatcher stops before another launch.
- The initial release does not automatically combine a dedicated resolver continuation with repeated reviewer-correction cycles.

### 8.7 Proof scenarios

| Scenario | Expected result |
|---|---|
| Adjacent test fixture must change to prove the approved outcome | `ALLOW` |
| Equivalent internal implementation route is better supported by repository evidence | `ALLOW` |
| Proposed fix disables required validation | `DENY_AND_REPAIR` |
| Executor requests a capability already granted but technically unavailable | Mandatory technical handback, not `ALLOW` or operator waiver |
| Material scope expansion would improve the product | `OPERATOR` |
| Business behavior has two materially different valid outcomes | `OPERATOR` |
| Evidence that would settle the question is available but was not inspected | Resolver requests bounded evidence; it does not escalate yet |
| Resolver cannot establish a load-bearing premise | Evidence blocker or `OPERATOR` only when operator intent can actually settle it |
| Executor strongly recommends an attractive but unauthorized action | `DENY_AND_REPAIR` or `OPERATOR` from governing authority, not agreement with the recommendation |
| Same question presented with persuasive versus neutral narrative | Identical resolver classification from the same contract and evidence |

The false-positive acceptance criterion is explicit: asking Patrik to approve an action already authorized by settled intent and capability is a failed resolver scenario.

---

## 9. Addition E — Evidence-rendered completion and decision reports

### 9.1 Purpose

Machine-readable results support control. Patrik needs a concise human operating result. Reports should be rendered from canonical state and validated evidence without another summarization model call.

### 9.2 Successful completion report

Every successful run renders:

```text
COMPLETED

Outcome:
Did the requested behavior become true?

Changes:
Which material paths and behaviors changed?

Proof:
Which fail-capable checks passed?

Independent review:
Who reviewed, what was concluded, and where is the evidence?

Autonomous repair:
Which failures were diagnosed and repaired, if any?

Assumptions and exceptions:
What limitations or non-load-bearing uncertainty remain?

Repository state:
HEAD, commit, working-tree and integration/closure condition.

Operator action:
None, or the exact remaining action.
```

Unknown facts are rendered as unknown. The renderer never infers success from missing evidence.

### 9.3 Operator decision report

A genuine semantic escalation extends the closure report's operational handoff packet with:

```text
DECISION REQUIRED

Context:
What outcome and phase were active?

Material issue:
What decision boundary was reached?

Why existing authority cannot resolve it:
Which intent, risk, scope, architecture, governance or capability decision is missing?

Option A:
Action and consequences.

Option B:
Action and consequences.

Recommendation:
Recommended option and evidence.

Current safety:
Partial effects, commit state, process state and lease condition.

Required response:
The exact decision Patrik must provide.

Resume:
The exact command or action after the decision is recorded.
```

When only one safe option exists, the packet says so and asks for the specific authority required. It does not fabricate alternatives.

### 9.4 Proof

- completion cannot render when canonical state or load-bearing proof is incomplete;
- every report field traces to state or evidence;
- a repaired run names its repairs;
- a blocked run cannot render as completed;
- decision reports distinguish semantic decisions from technical recovery choices; and
- rendering is deterministic, local and requires no paid model request.

---

## 10. Addition F — Minimal append-only event journal

### 10.1 Purpose

The dispatcher needs enough structured history to identify unnecessary escalations, repeated failure families and policy opportunities. It does not need a database or dashboard.

### 10.2 Event set

The initial release records only:

```text
RUN_ADMITTED
RUN_REFUSED
ACTOR_STARTED
ACTOR_FINISHED
STATE_TRANSITION
PROOF_RESULT
REPAIR_STARTED
REPAIR_FINISHED
RECONCILIATION_STARTED
RECONCILIATION_FINISHED
REPLAY_REFUSED
RESOLVER_DECISION
OPERATOR_REQUIRED
OPERATOR_DECISION_RECORDED
RUN_COMPLETED
RUN_BLOCKED
```

Each event includes:

```yaml
schema_version: supported event version
timestamp: UTC timestamp
task_id: exact task
run_id: exact run
event: named event
actor: actor or none
phase: current phase
outcome: compact classification
reason: stable reason code
evidence: exact evidence reference or none
```

### 10.3 Storage and authority

- Events are written to `events.jsonl` inside the existing run evidence directory.
- The terminal result references the journal.
- Canonical task state remains semantic authority.
- Universal terminal results remain transport authority.
- Events are observational and may not independently authorize continuation.
- A missing final event cannot erase a valid terminal result; a missing terminal result cannot be replaced by events.
- Retention follows the run-evidence policy established by the closure package.

### 10.4 Initial use

No automated learning is introduced. Periodic operating review may calculate:

- unnecessary operator escalation count;
- resolver `ALLOW`, `DENY_AND_REPAIR` and `OPERATOR` rates;
- repeated permission or capability blockers;
- internal repair success and oscillation rates;
- reconciliation-safe, reconciliation-blocked and replay-refusal rates;
- false completion count;
- invalid or missing handback count; and
- completion rate by admitted route.

Recurring decisions may become policy only through a separate reviewed change. The dispatcher never rewrites its own authority rules.

### 10.5 Proof

- events appear in valid phase order for normal, repaired, resolved and blocked runs;
- event writes never mutate canonical task truth;
- status and reports remain correct when the event journal is absent or truncated;
- no dashboard or external service is required; and
- run identifiers prevent events from different runs being combined.

---

## 11. Authority and stop boundary

### 11.1 The dispatcher may decide deterministically

- whether the admitted contract is complete and internally consistent;
- which of the three supported routes applies under the fixed selection rules;
- whether structured state and evidence satisfy a defined transition;
- whether a declared budget remains;
- whether a mandatory technical stop class is present;
- whether the next actor role is executor, reviewer, resolver or closer; and
- which report template applies.

### 11.2 The executor may decide

- implementation mechanics;
- ordinary debugging and local technical adaptation;
- bounded reversible refactoring;
- how to repair an implementation failure inside the approved envelope; and
- whether new technical evidence supports another internal repair, subject to the hard ceiling.

### 11.3 The Decision Resolver may decide

- whether a boundary-adjacent action is already authorized;
- whether an unsafe proposal must return for repair; and
- whether a genuine operator-owned decision remains.

It may not grant capabilities, change intent, accept undelegated risk or modify policy.

### 11.4 Patrik decides

- intended outcome or priority changes;
- material scope expansion or exclusion removal;
- product or business behavior not already settled;
- material operating-model, architecture, cost, risk or governance changes outside the approved envelope;
- acceptance of undelegated material residual risk;
- capability-envelope expansion;
- production, communication, credential or destructive shared-state authority not already delegated;
- genuinely tied operator intentions; and
- changes to the authority policy itself.

### 11.5 Mandatory technical stops

These never become resolver approvals:

- invalid or contradictory canonical state;
- missing or invalid terminal evidence;
- actor started but final result missing;
- timeout, interruption or uncertain descendant teardown;
- unsupported runtime or authentication loss;
- unproducible load-bearing proof;
- changed paths outside the admitted envelope;
- undeclared shared-resource, hook, global-configuration, ignored-file or other non-Git effect;
- capability authorized semantically but unenforceable technically;
- attempted control-system bypass or self-expansion; and
- exhausted run budget.

---

## 12. Budgets and anti-loop controls

The additions operate inside the closure package's finite whole-run deadline, hop budget, usage budget and state-size limits.

Additional initial ceilings are:

| Budget | Ceiling |
|---|---|
| Executor-internal repair | Two iterations inside one actor launch |
| Dedicated resolver invocation | One per run |
| Automatic safe reconciliation | One per run |
| Reviewer correction | One correction and one reassessment, inherited from the closure package |
| Nested actor | Zero by default |
| Automatic policy change | Zero |
| Automatic capability expansion | Zero |

Continuation requires both remaining budget and a legal semantic transition. Remaining budget never creates authority.

Before every actor launch, the dispatcher subtracts the declared closure and recovery reserves from the remaining whole-run budget. The closure reserve includes any required closing actor hop plus deterministic postcheck, terminal-result and report-finalization capacity. The recovery reserve protects teardown, partial-effect capture and actionable blocker finalization. Optional correction, reassessment or resolver continuation may launch only from the remainder; it cannot consume either reserve.

The dispatcher stops before another actor launch when:

- the next launch exceeds the whole-run hop, time or usage budget;
- the next launch would consume declared closure or recovery reserve;
- the same failure recurs without new evidence;
- the same operational inconsistency recurs after one automatic reconciliation;
- the run oscillates between `ALLOW` and the same failed repair;
- a resolver question is materially unchanged from an earlier question in the same run;
- active state exceeds the launch ceiling; or
- correction increasingly diverges from the admitted task contract.

The initial release does not optimize for maximum autonomous completion. It optimizes for safely completing the common path while eliminating the highest-volume low-value interruptions.

---

## 13. Layer ownership

| Concern | Owning layer |
|---|---|
| Outcome, acceptance, boundaries and operator-reserved decisions | Approved task/plan and canonical Work Loop authority |
| Task lifecycle and next semantic action | Canonical durable task state |
| Role-owned task-record mutation | Codex or Claude only within the frozen durable-state role contract; independently validated before continuation |
| Owner, lease, permission, runtime, budget, run and terminal-result mutation | Trusted helpers and dispatcher transport defined by the reliability closure field-ownership matrix |
| Admission, phase routing, budgets and transport | Dispatcher |
| Technical implementation and internal repair | Executor |
| Independent assessment | Reviewer |
| Boundary-adjacent authority classification | Decision Resolver role |
| Capability enforcement | Harness and platform permission/sandbox mechanisms |
| Task and checkout exclusion | Shared lease system |
| Transport truth | Universal terminal result |
| Operating observations | Run event journal |
| Human completion and decision view | Deterministic report renderer |
| Declared ports, services, databases, caches, hooks, global configuration and non-Git effects | Admitted environment profile plus preventative runtime controls |
| Merge, push, deployment and release | Existing repository integration controls; unchanged here |

No executing actor may write dispatcher policy, alter its admitted contract, widen its runtime profile, edit another task's state, or mark its own unverified work complete.

---

## 14. Proposed implementation sequence

This sequence assumes the dispatcher reliability closure package is the active foundation. Where implementation occurs in the same programme, shared seams are designed once rather than landed twice.

### Shell-complexity guardrail

The initial implementation remains in the current dispatcher language, but it must not distribute control parsing across the script. There is one owner for each of: actor-handback parsing, path canonicalization, task/authority freshness validation, transition evaluation, durable-result finalization and report rendering. Transition selection remains table-driven and each pure decision seam has focused tests that run without a live actor.

If a pure validation or transition behavior cannot be tested without executing the full dispatcher, or a second production parser for the same contract would otherwise be introduced, extract that behavior behind one narrow helper interface. Extraction may use the existing language or the smallest already-supported runtime; it is not permission for a dispatcher rewrite or implementation-language migration. The final review must explicitly assess duplicated parsers, duplicated lifecycle semantics and unreachable transition branches.

### Change set TA-A — Admit and route structured work

1. Extend the closure package's universal result and evidence handshake with the actor handback schema.
2. Implement schema validation and the exhaustive next-action transition table.
3. Add `RECONCILE_NEEDED`, `RECONCILED_SAFE` and `RECONCILE_BLOCKED` by invoking the canonical validator/recovery capability.
4. Enforce replay classification and refusal before any repeated operation.
5. Add the task-contract admission check.
6. Bind admission to base HEAD, approved authority fingerprints and an exact supported environment/non-Git-effect profile.
7. Enforce closure and recovery budget reserves before every launch.
8. Add deterministic selection for the three supported route classes.
9. Extend read-only status with admitted route, current phase, last outcome and next action.
10. Prove zero-model refusal for incomplete, stale, environmentally undeclared, contradictory and unsupported admission cases.

### Change set TA-B — Keep ordinary repair inside execution

1. Update the executor contract to distinguish internal proof/repair from outer reviewer correction.
2. Add the two-iteration hard ceiling and new-evidence requirement.
3. Record internal repair summaries in the handback and usage evidence.
4. Make repeated/no-new-evidence failure a structured blocker or decision request, never an automatic relaunch.
5. Add focused controller fixtures and one representative real executor trial.

### Change set TA-C — Resolve boundary ambiguity narrowly

1. Implement deterministic preclassification of explicit allow, deny and mandatory-stop cases.
2. Add the bounded Decision Resolver invocation using the existing reviewer capability where practical.
3. Validate and persist resolver outputs without creating a second authority record.
4. Route `ALLOW`, `DENY_AND_REPAIR` and `OPERATOR` through the transition table.
5. Add one-invocation, no-capability-expansion and no-policy-mutation enforcement.
6. Enforce fresh minimal resolver context and authority/evidence-only equivalence for inline reviewer resolution.
7. Run allow, deny, investigate, narrative-bias and genuine-escalation trials.

### Change set TA-D — Make outcomes legible and measurable

1. Add deterministic completion and semantic-decision renderers.
2. Extend the operational takeover packet without duplicating it.
3. Add the run-local event journal and stable reason codes.
4. Make the universal terminal result reference the rendered report and journal.
5. Prove that missing or truncated observational events cannot change task truth.

### Change set TA-E — Prove target alignment

1. Run the full target-alignment trial matrix in clean dedicated worktrees.
2. Run the dispatcher reliability Gate SA regression suite synchronously.
3. Run shared lease, durable-state validator, owner, authority and carrier regressions.
4. Correct only demonstrated material failures.
5. Obtain independent review against this proposal and the approved implementation specification.
6. Make an explicit adopt, shrink or stop decision for Gate ST.

---

## 15. Representative trial matrix

All live trials use exact task and run identities, clean dedicated worktrees, finite deadlines, zero nested actors by default, no push, and the complete evidence contract.

| Trial | Required outcome |
|---|---|
| Complete bounded implementation | Admission, implementation, proof, review, closure and completion report succeed without manual turn transport. |
| Incomplete contract | Refuses before actor launch and names the exact missing field. |
| Stale contract | Base HEAD or a load-bearing authority fingerprint drifts; admission refuses until explicit revalidation. |
| Undeclared shared resource | A task requiring a port, service, database or cache outside an admitted profile refuses before actor launch. |
| Undeclared non-Git effect | A hook, ignored-file, global-config or external effect outside the admitted profile stops and reports the exact effect. |
| Route selection | Repair, bounded implementation and plan-backed fixtures select the intended installed route. |
| Ordinary proof failure | Executor diagnoses, repairs and re-proves within one actor launch. |
| Repeated failure | Same failure without new evidence stops; no automatic relaunch occurs. |
| Safe zero-model replay | A named deterministic preflight operation with `actor_started=false` and unchanged facts may repeat. |
| Persistent-action replay | A commit, ownership mutation, state transition or external effect is reconciled before continuation and is never blindly repeated. |
| Deterministic stale-state reconciliation | The canonical validator repairs a named safe inconsistency and returns `RECONCILED_SAFE`. |
| Repeated reconciliation condition | A recurrence after one automatic reconciliation returns `RECONCILE_BLOCKED`; it cannot loop. |
| Missing result during reconciliation | An artifact without its required handback/result returns `RECONCILE_BLOCKED`; completion is not reconstructed. |
| Git drift during reconciliation | Changed HEAD, index or working tree returns `RECONCILE_BLOCKED`. |
| Uncertain lease holder | The lease remains conservatively pinned and reconciliation blocks reuse. |
| Boundary-adjacent fixture edit | Resolver returns `ALLOW`; execution continues inside unchanged envelopes. |
| Unsafe validation removal | Resolver returns `DENY_AND_REPAIR`; executor finds a compliant route or blocks. |
| Genuine material scope decision | Resolver returns `OPERATOR`; packet presents options, consequences and recommendation. |
| Resolver narrative-bias pair | Persuasive and neutral descriptions with identical authority/evidence produce the same classification. |
| Operator decision and resume | Decision is recorded, new run identity starts, all facts are revalidated and execution resumes from durable next action. |
| Reviewer correction | One correction and reassessment complete inside the inherited correction ceiling. |
| Second material non-pass | Stops for Patrik; no additional correction runs. |
| Capability already authorized but unenforceable | Technical handback; no operator waiver is suggested. |
| Missing handback | Durable evidence blocker; never false success. |
| Partial effects and interruption | Status and packet identify effects, process/lease condition and safe recovery; no automatic retry. |
| Closure reserve | Optional correction/resolution is refused when it would consume reserved closure or recovery capacity; the current run still finalizes honestly. |
| Control-surface mutation | Actor attempts an unowned owner, lease, permission, budget, runtime or terminal-result mutation; continuation is refused. |
| Crash-boundary matrix | Every reliability-foundation durable boundary recovers to one proven next action, already-completed classification or blocker without duplicate effect. |
| Hostile protocol input | Metacharacters, newlines, traversal, symlinks, duplicate fields, oversize values, unknown versions and fake control lines fail closed. |
| Completion rendering | Report traces every claim to state/evidence and names autonomous repairs. |
| Event degradation | Missing/truncated journal does not alter state, result or report truth. |
| Arbitrarily named linked worktree | Complete local runtime, identity, admission, execution and reporting all pass. |

At least three normal completion trials and two executor-internal repair trials must pass. One success is not repeat reliability.

---

## 16. Acceptance gate

### Gate ST — Target-aligned supervised semi-autonomous dispatcher

Gate SA must pass first. Then every statement below must be proven:

- The dispatcher refuses an unexecutable task before actor launch and names the exact preparation need.
- Every admitted run has a complete outcome, acceptance, boundary, authority, capability, workspace and proof contract.
- Admission is bound to the approved base HEAD and fingerprints of every load-bearing plan/specification and operator decision.
- Undeclared shared resources and non-Git effects refuse admission or stop; a clean Git status is never treated as proof that no other effect occurred.
- The dispatcher selects only one of the supported Work Loop routes through deterministic rules.
- Every actor handback is machine-validated and every supported outcome maps to one exhaustive next action.
- Free-form prose, process exit zero or file appearance cannot independently advance the run.
- The six non-negotiable execution invariants are enforced above executor and resolver judgment.
- A repeated operation is permitted only when its replay-safe classification and unchanged preconditions are mechanically proven.
- `RECONCILE_NEEDED` invokes the canonical validator/recovery capability rather than dispatcher-local lifecycle logic.
- Only a named deterministic zero-model reconciliation with unchanged repository and authority facts may return `RECONCILED_SAFE` and continue automatically.
- At most one automatic safe reconciliation occurs per run; recurrence returns `RECONCILE_BLOCKED`.
- Missing terminal evidence, partial effects, Git drift, started requests with unknown outcomes and uncertain lease teardown return `RECONCILE_BLOCKED`.
- An executor can diagnose, repair and re-prove representative ordinary technical failures without Patrik.
- Internal repair stops on repeated/no-new-evidence failure and cannot weaken proof, expand scope or grant capability.
- Boundary-adjacent actions already authorized by intent and capability continue without Patrik.
- Unsafe proposed actions are denied and returned for repair.
- Genuine operator-owned decisions produce legal `blocked/operator` state and a decision packet with options, consequences, recommendation, current safety and exact response.
- A resolver decision never expands capability, changes policy or creates intent.
- Dedicated resolver decisions use fresh minimal context, and equivalent authority/evidence produces the same classification despite persuasive narrative differences.
- Optional work cannot consume the declared closing-hop, postcheck, teardown or evidence-finalization reserves.
- Operator resume records the decision, starts a new run identity and revalidates state, evidence, leases, Git facts, runtime and budgets.
- Successful completion produces a concise report covering outcome, changes, proof, review, repairs, assumptions, repository state and remaining action.
- The event journal makes repairs, decisions, escalations and completion measurable without becoming semantic authority.
- The complete live trial matrix passes and Gate SA, concurrency, durable-state and autonomy-authority invariants do not regress.
- Final review confirms one production owner for each control parser/validator seam, no duplicate lifecycle semantics and no unreachable transition branch hidden by shell control flow.

Passing Gate ST justifies this claim:

> **Reliable target-aligned supervised semi-autonomous dispatcher:** an approved bounded task can proceed through ordinary implementation uncertainty, proof, independent review, bounded correction and closure without manual turn transport or low-value operator approval, while genuine operator decisions and technical safety failures stop with durable actionable evidence.

Passing Gate ST does not justify unattended or walk-away reliability. That claim still requires Gate U.

---

## 17. Failure and recovery behavior

### 17.1 Replay-safety invariant

The dispatcher may repeat an operation only when all are true:

- it is a named deterministic zero-model operation classified as replay-safe;
- `actor_started=false` for the attempt being recovered;
- canonical state, task meaning, capability envelope, HEAD, index and working tree are unchanged;
- no ownership, lease, commit, persistent-state or external effect may already have occurred;
- the repeat cannot create a duplicate effect; and
- the original deadline, usage and operation budgets remain valid.

Reads, repository inspection and local proof commands may be classified as replay-safe when they have no persistent or external effect. Commit creation, canonical-state mutation, ownership or lease mutation, external writes and any model request are not replay-safe by default.

When replay safety cannot be proven, the dispatcher starts no repeated operation. It classifies actual effects through the reconciliation transition, creates a new run identity when resumption is later authorized, and resumes from the canonical durable next action rather than replaying the previous request.

Replay safety is declared by trusted dispatcher/runtime code. An actor or Decision Resolver may not label its own proposed action replay-safe.

### 17.2 Failure table and resume

| Failure class | Required behavior |
|---|---|
| Admission incomplete | Zero-model `PREPARATION_REQUIRED`; no lease-dependent or paid work beyond necessary preflight. |
| Admission authority stale | Zero-model `PREPARATION_REQUIRED`; identify the drifted HEAD or authority fingerprint and require explicit task revalidation. |
| Shared resource or non-Git effect undeclared | Refuse before launch when known; otherwise block at detection, preserve exact facts and do not infer isolation from Git. |
| Admission unsafe | Zero-model `REFUSED` with exact state, owner, lease, runtime or capability reason. |
| Invalid actor handback | Evidence blocker; preserve raw capture and before/after facts; no retry. |
| Internal repair exhausted | Structured `repair_needed`, `decision_needed` or `blocked` according to evidence; never ordinary success. |
| Resolver unavailable after preflight | Technical blocker; do not send the semantic decision directly to Patrik unless it independently qualifies as operator-owned. |
| Resolver output invalid | Evidence blocker; no continuation. |
| Operator decision required | Atomic terminal result, legal `blocked/operator` state, decision packet and exact resume action. |
| Renderer failure | Canonical state and terminal result remain authoritative; report path records failure and status exposes it. |
| Event journal failure | Observability limitation is recorded; state and result remain authoritative; continuation depends on whether the loss violates the declared evidence requirement. |
| Named safe operational inconsistency | Canonical reconciliation returns `RECONCILED_SAFE`, records the correction and continues from the validated durable next action. |
| Ambiguous operational inconsistency | `RECONCILE_BLOCKED`; preserve facts and render the exact recovery requirement. |
| Unsafe or unclassified replay | Emit `REPLAY_REFUSED`; reconcile effects and do not repeat the action. |
| Closure/recovery reserve would be consumed | Do not launch optional work; finalize the current validated state or blocker using the reserve. |
| Interruption or timeout | Existing closure-package teardown, partial-effect classification, conservative lease and operator-takeover rules apply. |

Recovery never blindly repeats the previous request. It resumes from the canonical next action under a new run identity after complete revalidation.

---

## 18. Non-goals

Do not implement this proposal by adding:

- automatic task creation, backlog selection, prioritization or scheduling;
- a general planner or architecture agent inside the dispatcher;
- a second task state, approval ledger or policy database;
- a general-purpose capability-policy language;
- a general shared-resource lease manager for the initial release; unsupported environmental dependencies are refused instead;
- automatic precedent promotion or self-modifying authority;
- a permanent dedicated resolver service or always-on model;
- unlimited evidence-based retries;
- routine nested agents, reviewer hierarchies or arbitrator chains;
- automatic worktree creation, merge, push, deployment or branch cleanup;
- a dashboard, queue, database, heartbeat service or external event bus;
- transcript persistence as operational memory;
- a repository-wide default model; or
- unattended release, full-lifetime descendant containment or host-isolation claims.

The dispatcher remains one bounded-task controller using one canonical state record, shared leases, structured evidence, specialist actors and explicit operator gates.

---

## 19. Rollout and evidence period

### Initial release

- Enable the additions only for prepared local development tasks that fit one supported route.
- Keep nested actors at zero, external effects disabled unless explicitly delegated, and push/merge/deploy outside the release envelope.
- Require the complete Gate SA and Gate ST evidence bundle.
- Retain the existing attended/supervised release label.

### Evidence period

Use the dispatcher for 5–10 representative tasks across the three admitted route classes. Review:

- which tasks failed admission and why;
- which contracts drifted from their admitted HEAD or authority fingerprints;
- which tasks required unsupported shared resources or produced non-Git effects;
- internal repair success and repeated-failure rates;
- resolver allow, deny and operator rates;
- operator decisions that added genuinely new information;
- permission and capability blockers;
- invalid/missing handbacks;
- reconciliation-safe, reconciliation-blocked and replay-refusal outcomes;
- closure/recovery reserve refusals and whether the reserve was sufficient;
- resolver narrative-bias or correlated-review findings;
- completion-report accuracy; and
- time, usage and hop consumption.

Correct demonstrated false escalations, unsafe continuation, routing errors and evidence gaps. Do not increase repair, resolver or capability budgets merely to improve completion rate.

### Later decisions

Only operating evidence may justify:

- more admitted route classes;
- a larger internal repair ceiling;
- reusable deterministic precedents;
- additional capability profiles;
- a separate arbitrator path for genuine technical disagreement; or
- Gate U unattended architecture and trials.

---

## 20. Proposed approval decisions

Approval of this proposal would establish the following direction:

1. **Gate SA remains the reliability foundation; Gate ST becomes the target-alignment gate.**
2. **The dispatcher admits only tasks with complete executable contracts and one supported route.**
3. **Structured handbacks and an exhaustive transition table govern continuation.** Free-form prose never does.
4. **The six non-negotiable execution invariants sit above executor and resolver judgment.** Neither actor may waive them.
5. **Only a mechanically proven replay-safe zero-model operation may repeat.** Persistent effects and model requests are reconciled and resumed, never blindly replayed.
6. **Operational inconsistency uses a first-class reconciliation transition owned by the canonical validator/recovery capability.** Only named deterministic unchanged-state cases may continue automatically.
7. **Admission binds the task to base HEAD, load-bearing authority fingerprints and an exact supported shared-resource/non-Git-effect profile.** Drift or undeclared effects refuse rather than infer safety.
8. **Closure and recovery capacity is reserved before optional actor launches.** Optional autonomy may not consume the ability to stop or finish honestly.
9. **Ordinary executor proof failures may receive up to two internal repairs when each produces new evidence and remains inside both authority envelopes.**
10. **The existing one-reviewer-correction ceiling remains separate and unchanged.**
11. **A narrow Decision Resolver may allow already-authorized action, deny unsafe action, or identify one genuine operator decision.** It may not grant capability or change policy, and dedicated resolution uses fresh minimal context.
12. **Completion and decision reports are rendered from validated state and evidence without another model call.**
13. **A run-local event journal supports analysis but never becomes task or transport authority.**
14. **Dispatcher control parsing remains single-owner and testable behind narrow seams.** Extraction is allowed only to prevent duplicate or untestable logic, not to authorize a rewrite.
15. **The release remains supervised.** Unattended reliability continues to require the separate Gate U programme.

Approval authorizes detailed implementation planning against the integrated dispatcher baseline. It does not authorize code changes, capability expansion, unattended release, push, merge or deployment.

---

## 21. Final assessment

The reliability closure report answers whether the dispatcher can transport bounded work safely, stop honestly and resume from durable truth. This proposal answers the next question: whether the dispatcher can carry the common implementation path without turning every technical adaptation or boundary-adjacent question into operator work.

The proposed additions are intentionally small:

- one admission contract;
- one structured handback;
- one deterministic transition router;
- one bounded internal repair allowance;
- one narrow resolver decision;
- two deterministic human report templates; and
- one run-local event journal.

They operate under six non-negotiable execution invariants, an explicit replay-safety rule and one canonical reconciliation transition. These are control contracts around the additions, not additional agents or state systems.

Together they supply the missing controlled reasoning layer between “something unexpected happened” and “ask Patrik,” while preserving the dispatcher as a thin, deterministic control plane.

The target operating behavior is:

> **Admit only executable intent. Let specialists resolve ordinary implementation uncertainty inside bounded authority. Reconcile operational truth without inventing success. Replay only what is proven safe to repeat. Advance only on validated evidence. Deny unsafe proposals. Escalate only genuine operator decisions. Complete with a report that can be trusted without reading the transcript.**
