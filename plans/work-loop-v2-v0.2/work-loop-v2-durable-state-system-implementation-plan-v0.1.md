# Work Loop v2 durable state system — implementation plan

**Version:** v0.1  
**Date:** 2026-08-14  
**Status:** FROZEN — approved for sequential implementation  
**Implementation risk:** High — lifecycle-state migration, recovery, concurrency, and cross-consumer cutover  

## Authority and content binding

This plan implements the operator-accepted architecture in:

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/reports/work-loop-v2-session-state-system-investigation-2026-08-14.md`
- SHA-256 at planning time: `6c72333a25d5cc93eb0ba8d2b4022cb9b67b3a4daa8c79dc05ae7740df37fc08`

Planning follows the supplied **Axcíon Standard Implementation Workflow**:

- attachment: `/Users/patrik.lindeberg/.codex/attachments/b361d6ee-12ce-4bac-9bc5-edaa70d623af/pasted-text.txt`
- SHA-256 at planning time: `b425966ec1d78caa086fa5f09c422374d90aa2581ab26984ecaae208bbb76f65`

The current operator instruction authorizes implementation planning for that exact accepted architecture. It does not authorize reopening the architecture or beginning implementation before this plan receives its required fresh-context review and freeze.

---

# 1. Fixed Point

## Outcome

Work Loop v2 has one small, durable, self-consistent state system from which a fresh Claude or Codex agent can determine the exact task, lifecycle status, actor turn, latest result, blocker, and next action, then safely resume after compaction, handoff, session termination, or an interrupted actor.

## Authoritative source

The content-bound accepted architecture identified above governs the implementation. The Standard Implementation Workflow governs how it is planned, sliced, reviewed, implemented, assessed, and demonstrated.

Repository evidence may challenge a factual premise or reveal that a proposed implementation step is unsafe. It may not silently redesign the accepted outcome.

## Fixed decisions

The following are implementation inputs, not design questions:

1. One admitted task has one tracked durable record at `logs/work-loop/{task-id}.md`.
2. Lifecycle is explicit: `active | blocked | closed`.
3. Only four status-turn combinations are legal: `active/claude`, `active/codex`, `blocked/operator`, and `closed/operator`.
4. Active and blocked records have the five exact state headings in the accepted order; closed records have the four exact closing headings.
5. The executable core is the one approved semantic contract.
6. One read-only validator classifies valid state as `ACTIVE_CLAUDE`, `ACTIVE_CODEX`, `BLOCKED_OPERATOR`, or `CLOSED`; every consumer uses it.
7. `.owner` contains only the task ID and answers only which task is bound to the checkout.
8. Repository and Git evidence settle repository facts; the task record does not replace them.
9. Shared Git-common-directory live leases answer only whether automated actors are in flight.
10. Closure order is: write valid closed state, commit it, then clear `.owner`.
11. Reorient recovers from exact task path first, then a strictly validated owner pointer, and otherwise stops.
12. Work Loop v2 neither reads nor writes the legacy session-state system to determine execution state.
13. Existing shared-lease Phase 1 work is completed, assessed, and integrated; no second lease helper is created.
14. All runtime consumers switch to the new contract together. Runtime code retains no permanent old-shape fallback.
15. Operational proof, including deliberately injected failures, is the cutover gate.

## Boundaries

Explicitly excluded:

- a database, task registry, scheduler, event log, heartbeat service, workflow engine, or broad repository lock;
- Phase 2 task-aware automatic worktree creation;
- automatic authoritative-copy selection;
- automatic merge, landing, push, branch deletion, archival, or destructive worktree cleanup;
- bulk migration or reinterpretation of legacy session notes, plans, scratchpads, manifests, or markers;
- a general-purpose test framework;
- JSON validator output, telemetry, convenience isolation tooling, and automatic closed-task archival;
- redesign of the legacy concurrent-session system or `check-foreign-staging.sh` beyond removing Work Loop dependence and false Work Loop claims. Any decision to wire or retire that legacy hook is separate.

## Success condition

The implementation is complete only when:

1. every Work Loop state consumer obtains lifecycle classification from the shared validator rather than parsing it independently;
2. all valid tracked task records and checkout declarations use the new shape, while intentional negative fixtures still fail for their intended reason;
3. a fresh or compacted agent resumes the uniquely bound task from durable evidence without scanning, guessing, or trusting conversation;
4. blocked, interrupted, ambiguous, stale-owner, closure-crash, migration, and concurrent-actor scenarios fail or recover exactly as the accepted architecture specifies;
5. attended and unattended couriers contend through the same live-lease contract;
6. a clean closure commits first, clears ownership second, and permits a new task to claim the checkout; and
7. the complete operational proof suite passes at the real command, recovery, ownership, and courier seams.

---

# 2. Repository Delta

## Investigation baseline

Repository investigation was performed in:

- checkout: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-durable-state`
- branch: `session/2026-08-14-durable-state`
- baseline commit: `814f305b56d87b2c8453ce0ca41a769873526521` (the same commit as local `main` at investigation time)

Observed deterministic baselines in this checkout:

- `logs/scripts/work-loop-owner.test.sh`: **92 passed, 0 failed**;
- `logs/scripts/work-loop-v2-slice-1.test.sh`: **308 passed, 0 failed**;
- `scripts/axcion-harness-v0.2/carry-turn.test.sh`: **274 passed, 11 failed** in the Codex sandbox, with all 11 failures in process-census observation cases where `ps` is unavailable. This is an environment limitation, not accepted green evidence.

The active shared-lease worktree was also inspected:

- checkout: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-concurrency-fix-2`
- observed head: `4f54902fc1e087628c482d87020091d7b61834f3`
- state at observation: active, `turn: codex`; not yet closed or integrated;
- durable task evidence reports shared-lease helper **50/0**, carrier **316/0**, dispatcher **482/0**, and restored owner suite **92/0**;
- required live Phase 1 validations and final independent assessment remain governed by that task and must finish there, not be duplicated here.

Two checkout declarations were active during investigation and still used the old `{task-id} {date}` shape:

- `autonomy-authority-capability` in `ai-resources-autonomy-authority`;
- `work-loop-v2-cross-transport-concurrency-phase-1` in `ai-resources-concurrency-fix-2`.

This makes an admission freeze and explicit open-task check a real cutover precondition, not hypothetical migration ceremony.

## Current implementation

| Surface | Current repository behaviour | Delta |
|---|---|---|
| Executable core | Header says `draft for operator approval`; proposal wins. Frontmatter has `task` and `turn`; lifecycle is inferred. Active fields are a maximum, not mandatory. | Replace authority header and state contract with the accepted explicit lifecycle model. |
| Claude entry command | Empty invocation scans for the only file at `turn: claude`. It validates task/turn itself and infers correction, closure, blocked/operator, and terminal body shape. | Require exact task identity or validated owner routing; call the validator; remove lifecycle parsing and candidate discovery. |
| Codex Work Loop skill | Reads `.owner` as task plus date; treats `turn: operator` as closure; states lifecycle rules independently. | Call the validator, use explicit status, simplify owner shape, and cite the core rather than restating lifecycle. |
| Reorient | Exact path fallback is sound, but `.owner` parsing expects task plus date and open/closed is inferred from `turn`. | Resolve task-only owner, call the validator, inspect repository-depth binding and shared live-lease status, then reconcile durable evidence. |
| Owner helper | `.owner` is `{task-id} {date}`. `task_is_closed()` equates `turn: operator` with closed. It separately parses lifecycle. | Read task-only owners and delegate state classification to the validator. Preserve local/repository depth and ambiguity rules. |
| Attended carrier | Has its own `fm_value`, `validate_state`, closing-record, operator-question, and temporary checkout-lock implementations. | Consume the shared state validator and the completed shared lease helper; retain carrier-specific messages and one-hop behaviour. |
| Unattended dispatcher | Has its own state/terminal parser and inline lease implementation on main. It appends `logs/session-notes.md`, allocates session markers, widens the allowlist, and special-cases those writes. | Consume the shared validator and completed shared lease helper; remove all legacy session initialization and special cases. |
| Compaction | The Work Loop exception correctly rejects compact-summary authority, and the Codex hook points to Reorient. | Align terminology and validator/binding requirements; retain instruction-only, read-only recovery. |
| Fresh-thread handoff | `handoff-thread` normally creates a new worktree and carries a five-field conversational Brief, including settled state not always reconstructable. | For active Work Loop tasks, reopen the same bound checkout as Local and carry navigation to the exact task and governing sources only. |
| Legacy session entry | `/prime`, `/session-start`, `/session-plan`, and `/wrap-session` have no active-owner refusal. | Refuse competing reconstruction/writes when a valid open Work Loop owner is present; point to Reorient or the exact task. |
| Deployment/sync | `sync-workflow` verifies the owner helper and `.owner` ignore rule. A research-workflow copy of the owner helper exists. | Treat validator, owner helper, Reorient, compact hook, and ignore rule as one capability; partial deployment fails visibly. |
| Tests | Strong owner, courier, dispatcher, and original Work Loop suites exist, but state classification is duplicated in test-local helpers and current fixtures have no `status`. | Add one validator suite, migrate fixtures deliberately, keep negative controls, and reuse existing transport/owner suites. |
| Historical task records | Many closed records have the four-heading shape, while several operator-turn records and fixtures are deliberately or accidentally noncanonical. No tracked record currently carries `status`. | Perform one explicit classification and migration; do not infer every `turn: operator` record is closed. |
| Legacy staging claim | Documentation says `check-foreign-staging.sh` blocks cross-session commits, but it is not registered in this checkout's `.claude/settings.json`; the dispatcher was built around the claim. | Remove Work Loop dependence and Work Loop-specific claims. Leave the legacy wire-or-retire decision outside this implementation. |

## Keep

- one tracked task file per admitted task;
- current-truth rather than diary semantics;
- Codex/Claude/operator role division;
- Direct Work as the default for small reversible work;
- exact task identity and same-checkout recovery;
- worktree isolation for concurrent tasks;
- `.owner` as checkout binding and refusal;
- repository-depth ambiguity checks;
- exact-path → validated-owner → stop recovery order;
- current owner-helper mutation lock;
- shared lease work and survivor pinning once the active Phase 1 task passes assessment;
- existing courier boundaries, exit taxonomy, partial-effect reporting, and actor supervision unless the accepted state contract requires a narrow change.

## Modify

- executable core authority and lifecycle contract;
- state frontmatter, mandatory fields, and closed-record completeness;
- owner declaration format and closure ordering;
- every Work Loop state consumer;
- Reorient, compaction, and fresh-thread handoff;
- legacy command behaviour in a Work Loop-bound checkout;
- deployment and synchronization completeness checks;
- fixtures and acceptance assertions affected by explicit status.

## Add

- `logs/scripts/work-loop-state.sh`, provisionally, as the one read-only state validator;
- a focused validator test suite using temporary legal and illegal fixtures;
- proportional failpoints and operational proofs required by the accepted architecture;
- no other persistent state artifact.

## Remove from the Work Loop path

- implicit newest/single-candidate task discovery;
- independent lifecycle and terminal-state parsers;
- closure inferred from `turn: operator` or body headings alone;
- claim dates in `.owner`;
- legacy session notes, plans, scratchpads, manifests, markers, and compact summaries as execution-state inputs;
- the dispatcher's `prime-session-entry.sh` call, session-note append, marker allocation, session-note allowlist entry, and bookkeeping exclusions;
- Work Loop reliance on the unwired foreign-staging hook claim;
- duplicate transport locks superseded by the completed shared live-lease helper.

## Dependencies and implementation-order constraints

1. The active `work-loop-v2-cross-transport-concurrency-phase-1` task must complete, pass independent assessment and authorized live proofs, close, and be integrated before Tracer 2 inventories or migrates records. Rebaseline the repository after integration so its closing record is included. Its code is a dependency, not an implementation surface to recreate; it does not block the inactive validator work in Tracer 1.
2. A validator must exist and pass adversarial fixtures before any consumer stops understanding the old shape.
3. Tracked state records must be classifiable and migrated before runtime consumers reject missing `status`.
4. The current implementation task's own state file must be migrated before the executable core switches.
5. The implementation checkout's old owner declaration must remain untouched until the semantic cutover commit succeeds; then it is rewritten once to task-only form before another Work Loop turn.
6. Every state consumer changes in one atomic cutover unit. Partial consumer migration is not an allowed intermediate runtime.
7. No old-semantics task may remain open through record migration or cutover unless it is closed or the operator explicitly approves the exceptional migration procedure below.
8. Legacy session decoupling follows semantic cutover but precedes operational acceptance.
9. The complete capability bundle must be present before any deployed checkout exposes the new Work Loop command.
10. Operational proofs run before final landing, not after users have already crossed the cutover.

## Risky assumptions to prove early

1. **Compatibility during preparation:** current consumers ignore an added `status` key, allowing records to migrate before cutover without breaking the old runtime.
2. **Record classification:** every non-fixture operator-turn record can be classified as truly blocked or truly closed from repository evidence; ambiguous records stop migration rather than being guessed.
3. **Shared-lease readiness:** the active Phase 1 branch can pass its remaining assessment/live gates and integrate without losing current courier behaviour.
4. **Atomic self-hosting:** after the consumer cutover commit and owner rewrite, the implementation task itself can complete the next Claude↔Codex handoff under the new validator.
5. **Deployment completeness:** Work Loop-enabled checkouts can reliably detect a missing validator, owner helper, Reorient, compact hook, or ignore rule before work begins.
6. **Legacy independence:** removing dispatcher session initialization does not weaken Work Loop commit safety because explicit path staging, per-unit allowlists, ownership, and shared leases are the actual Work Loop controls.

Any failed assumption stops progression and returns evidence. It does not authorize a fallback lifecycle parser or a second state system.

---

# 3. Implementation Specification

## Capability A — canonical state validation

**Inputs**

- `validate --checkout PATH --task ID`;
- the canonical task file at `PATH/logs/work-loop/ID.md`.

**Outputs**

- exactly one success classification: `ACTIVE_CLAUDE`, `ACTIVE_CODEX`, `BLOCKED_OPERATOR`, or `CLOSED`;
- nonzero exit plus a specific diagnostic for missing, unreadable, symlinked, malformed, contradictory, unsupported, or identity-mismatched state.

**Guaranteed behaviour**

- canonicalizes and bounds the checkout and state path;
- validates filename, supplied ID, and `task` identity;
- accepts exactly the approved frontmatter keys and status-turn combinations;
- validates the exact active/blocked or closed body contract;
- permits the optional current `## Brief` handoff alongside active/blocked state without counting it as a sixth state field;
- rejects unsupported top-level state headings;
- performs no write and creates no state.

**Failure behaviour**

- fails closed before an actor launch, state mutation, ownership change, or recovery decision;
- identifies the violated invariant without guessing a repair.

**Side effects**

- none.

**Public seam**

- one shell command consumed by all Work Loop entry points, ownership tooling, recovery, and couriers.

**Evidence**

- deterministic legal/illegal fixture matrix with negative controls that prove each assertion can fail.

## Capability B — checkout binding

**Inputs**

- task-only `logs/work-loop/.owner`;
- target task ID and checkout;
- validator classification;
- repository-depth worktree enumeration where authorized.

**Outputs**

- `PROCEED`, `REFUSE`, or `AMBIGUOUS`, retaining the existing owner-helper exit contract;
- claim, clear, or explicit transfer only under the existing ownership mutation guard.

**Guaranteed behaviour**

- open means validator classification `ACTIVE_CLAUDE`, `ACTIVE_CODEX`, or `BLOCKED_OPERATOR`;
- stale means `CLOSED` for that exact task in that checkout;
- missing, malformed, or contradictory state never becomes stale by inference;
- replicas without a unique owner authorize nobody;
- owner absence never means closed.

**Failure behaviour**

- preserves ambiguous or contradictory evidence and stops.

**Side effects**

- claim/clear/transfer may update only `.owner`; check remains read-only.

**Public seam**

- the existing `work-loop-owner.sh` command surface, with the accepted owner representation and validator dependency.

**Evidence**

- owner-table fixtures, multi-worktree ambiguity cases, stale-owner cases, and contested mutation tests.

## Capability C — actor entry and lifecycle transition

**Inputs**

- exact task ID or exact preserved task path;
- validator classification;
- validated checkout binding;
- the task's `Next action` and governing sources.

**Outputs**

- the one legal actor move, a specific refusal, an operator block, or a committed closed record.

**Guaranteed behaviour**

- no task scan or newest/single-candidate inference;
- lifecycle meaning comes only from the validator;
- active turns progress only through legal transitions;
- blocked tasks retain ownership and expose the exact operator condition;
- closure commits valid `CLOSED` state before owner clear.

**Failure behaviour**

- malformed state, identity mismatch, binding ambiguity, state/Git disagreement, or unsupported transition stops before work.

**Side effects**

- Codex may update the tracked state record but never Git;
- Claude owns repository edits, tests, state commits, and post-commit owner clear.

**Public seam**

- the Work Loop Codex skill and Claude `/work-loop-v2` command.

**Evidence**

- adapter tests plus one real self-hosted handoff after cutover.

## Capability D — recovery and fresh-thread handoff

**Inputs**

- verified physical checkout;
- exact preserved task path when available, otherwise task-only `.owner`;
- validator result, repository-depth binding, shared lease status, Git, and governing sources.

**Outputs**

- reconstructed exact `Next action`, or a specific stop;
- a fresh-thread navigation prompt that reopens the same bound checkout as Local and points to durable sources.

**Guaranteed behaviour**

- compact summary and conversation are navigation only;
- no newest-task scan, branch-name inference, replica selection, or replacement state artifact;
- no fresh worktree for an existing bound task;
- no conversation-derived execution snapshot.

**Failure behaviour**

- missing or contradictory authority, binding, state, or live-run evidence stops and names the unresolved fact.

**Side effects**

- Reorient and compact hooks are read-only; handoff creates no repository artifact.

**Public seam**

- Reorient, the Codex compaction hook, the compaction protocol, and `handoff-thread`'s active-Work-Loop branch.

**Evidence**

- fresh-session and misleading-summary proofs, exact-path/owner fallback tests, and same-checkout handoff inspection.

## Capability E — live actor exclusion

**Inputs**

- canonical checkout, task ID, program, and process ID;
- Git common directory.

**Outputs**

- atomic task and checkout lease acquisition, refusal, pin, release, or read-only status.

**Guaranteed behaviour**

- attended and unattended transports use the same helper and contend on both logical task and physical checkout;
- partial acquisition rolls back;
- inability to prove termination pins both owned resources;
- live leases never interpret task prose or replace `.owner`.

**Failure behaviour**

- missing helper, held/pinned resource, or unreadable holder evidence refuses before launch.

**Side effects**

- ephemeral lease directories only under the Git common directory.

**Public seam**

- the completed and independently accepted `work-loop-lease.sh` Phase 1 helper.

**Evidence**

- helper suite, carrier suite, dispatcher suite, genuine cross-transport contention, and fan-out-two live proof from the owning Phase 1 task.

## Capability F — legacy session-state isolation

**Inputs**

- a Work Loop-bound checkout and a request to start, wrap, hand off, compact, or dispatch work.

**Outputs**

- Work Loop path: exact task navigation or Reorient;
- legacy path: an early visible refusal when it would create competing state.

**Guaranteed behaviour**

- dispatcher writes no session note or session marker and does not call `prime-session-entry.sh`;
- `/prime`, `/session-start`, `/session-plan`, and `/wrap-session` do not reconstruct or write competing state for a valid open owner;
- the Work Loop compaction and fresh-thread paths use durable Work Loop sources only;
- Work Loop makes no safety claim based on the unwired foreign-staging hook.

**Failure behaviour**

- contradictory/malformed owner or state stops; legacy commands do not repair it.

**Side effects**

- no Work Loop-triggered legacy session-state write.

**Public seam**

- dispatcher startup, legacy stateful commands, compaction protocol, and handoff guidance.

**Evidence**

- tracked-path before/after checks, deliberate legacy-command invocation in a bound fixture checkout, and absence assertions over the named legacy surfaces.

## Capability G — complete deployment

**Inputs**

- a checkout exposing `/work-loop-v2`;
- canonical deployment/synchronization sources.

**Outputs**

- complete capability present, or visible fail-closed diagnostic naming missing prerequisites.

**Guaranteed behaviour**

- validator, owner helper, Reorient, compact hook, and `.owner` ignore rule travel as one deployable capability;
- template/deployed helper copies cannot silently drift;
- partial capability exposure is not reported as ready.

**Failure behaviour**

- missing or mismatched prerequisite blocks Work Loop readiness without inventing a fallback.

**Side effects**

- only normal explicit deployment/sync updates approved by the operator.

**Public seam**

- repository deployment/sync checks and Work Loop entry preflight.

**Evidence**

- complete and each-one-missing fixture check; content comparison of canonical and deployed helpers.

---

# 4. Migration and Cutover Strategy

## Pre-implementation gates

Implementation must not begin until all three hold:

1. this plan passes a fresh-context plan review and is frozen;
2. implementation runs in a deliberate isolated worktree/branch because this is a large state-system change;
3. one exact implementation task is admitted and bound there under the old runtime, with its task ID/path recorded, its state valid under that runtime, and its `.owner` in `{task-id} {date}` form. If no task or owner exists, create them through normal old-runtime admission before Tracer 1; later tracers must not invent them during migration.

Before Tracer 2 inventories or migrates records, pause new Work Loop admissions and keep the pause through operational proof and final landing. Close every other old-semantics task by default, integrate its closing record into the implementation branch, and rebaseline before the inventory; no old-semantics branch may land later with an uninventoried record. An exception requires operator approval and the accepted sequence: stop its couriers and writers; commit and validate source state; validate the target checkout and repository-depth ownership; transfer the owner under the ownership mutation guard; verify exactly one bound checkout before resuming. An interruption must fail closed, and copying a live state file is not a repair.

## Safe ordering

1. Build and prove the validator without changing runtime consumers.
2. Pause new admissions; complete and integrate the shared-lease Phase 1 task and every other old-semantics closing record; then rebaseline the implementation branch.
3. Migrate tracked task records while the old runtime still accepts the added `status` key.
4. Prove the implementation task's own state is valid under both the preparation baseline and the new validator.
5. Commit the complete consumer switch as one unit.
6. Only after that commit succeeds, rewrite the implementation checkout's `.owner` from `{task-id} {date}` to `{task-id}` under repository-depth validation. Do not invoke another Work Loop turn between the commit and the owner rewrite.
7. Remove legacy coupling and complete deployment packaging.
8. Run deterministic and live operational proofs.
9. Close the implementation task under the new closure order, then land the isolated branch only after independent acceptance.

## Rollback boundary

Before final landing, rollback is the isolated branch being withheld. After landing, rollback is a deliberate Git revert of the cutover commits plus explicit restoration of any still-open task record/owner pair from known pre-cutover evidence. No automated downgrade parser is retained.

If cutover is interrupted after the semantic commit but before owner rewrite, the old owner remains visibly malformed to the new helper and all entry stops. That is recoverable evidence, not permission to accept both owner formats.

---

# 5. Execution Plan — Ordered Tracer Bullets

## Tracer bullet 1 — Prove the canonical validator behind an inactive seam

### Behaviour

Given an exact checkout and task ID, one read-only command either emits the correct one-word classification or fails nonzero on a specific contract violation. No existing runtime consumer changes yet.

### Starting evidence

- `logs/scripts/work-loop-state.sh` does not exist.
- Claude command, owner helper, Reorient, carrier, and dispatcher each parse state independently.
- Current fixtures carry no `status` field.

### Intended change

Add the smallest validator and focused test suite needed to implement Capability A. Construct temporary legal and illegal records that cover identity, symlinks, frontmatter, status-turn pairs, field order/content, closed shape, and unsupported headings. Prove separately that adding `status` to a representative current record does not break the still-live old consumer before any migration begins.

The accepted report defines the contract during this inactive preparation unit. Do not change the executable core's authority header or switch a consumer yet.

### Verification

- failing-first: the validator command is absent and the new suite fails;
- legal matrix returns exactly the four accepted classifications;
- each invalid dimension returns nonzero with a diagnostic that identifies the violated invariant;
- validator leaves checkout status byte-identical;
- a symlinked state path is rejected;
- a representative old consumer still reads a status-augmented valid record correctly;
- direct execution and shell portability checks appropriate to the existing Bash baseline.

### Exit condition

The validator suite is green, every classification and rejection is fail-capable, the validator has no write path, and no runtime consumer changed.

### Scope boundary

Excluded: record migration, owner format, core approval, consumer integration, couriers, legacy session commands, and deployment.

## Tracer bullet 2 — Migrate tracked task records without switching runtime semantics

### Behaviour

Every tracked Work Loop task record is explicitly classified and either validates under the final contract or remains an intentional negative fixture whose expected validator failure is recorded in tests. The old runtime continues to function during preparation.

### Starting evidence

- no tracked task file has `status`;
- multiple `turn: operator` records have active headings or noncanonical closing headings;
- test fixtures intentionally contain identity, heading, or lifecycle faults;
- two active checkout declarations use task plus date.

### Intended change

Perform a one-time, evidence-backed migration of tracked records. Add status, make active/blocked fields mandatory, normalize true closed records, classify operator waits as blocked, and preserve deliberate negative fixtures by intent rather than accidentally making them valid. Update existing state-focused fixture assertions as needed.

Use a disposable migration operation if useful; runtime code must not gain an old-shape fallback. Migrate the implementation task's own tracked state during this unit. Do not yet rewrite any `.owner` file.

### Verification

- inventory accounts for every tracked `logs/work-loop/*.md` file as valid active, valid blocked, valid closed, intentional negative fixture, or non-state target fixture;
- validator succeeds for every record intended to be valid;
- each intentional negative fixture fails for the intended reason, not an earlier unrelated defect;
- no ambiguous historical operator-turn record is guessed; ambiguity stops the unit with exact evidence;
- the original Work Loop acceptance harness remains green under the status-augmented records;
- diff review shows no semantic history rewrite beyond explicit lifecycle/body normalization.

### Exit condition

There is no unclassified tracked record, the implementation task itself validates, negative fixtures retain discrimination value, and the old runtime still completes its deterministic baseline.

### Scope boundary

Excluded: `.owner` rewrite, consumer cutover, legacy session records, task archival, and reinterpretation of session history.

## Tracer bullet 3 — Atomically switch every semantic consumer

### Behaviour

After one coherent cutover commit, every live Work Loop consumer obtains lifecycle meaning from the shared validator, the executable core is the approved authority, task owners contain only the task ID, and the implementation task successfully completes its next handoff under the new contract.

### Starting evidence

- the validator and migrated records are proven but inactive;
- the core still says draft/proposal-wins;
- semantic parsers remain in the Claude command, Codex skill, Reorient, owner helper, carrier, dispatcher, and proof helpers;
- closure currently clears `.owner` before committing closed state;
- the implementation checkout still has an old-shape owner declaration.

### Intended change

Make one dominant cutover change:

- approve the executable core and replace its lifecycle/state sections with the accepted contract;
- update the Codex Work Loop skill and Claude command to require validator classification and exact task identity;
- remove empty-argument candidate scanning;
- update Reorient's owner fallback and lifecycle checks;
- update the owner helper to read task-only declarations and ask the validator whether state is open, blocked, or closed;
- replace carrier and dispatcher semantic parsing with the validator while retaining their program-specific exit messages and transport behaviour;
- update directly affected proof helpers so they classify through the same validator;
- enforce close-write → commit → owner-clear ordering in every closure/de-escalation path.

No adapter keeps a private fallback parser. The commit is not released or handed off midway.

After the semantic commit succeeds, validate repository-depth ownership and rewrite the implementation checkout's `.owner` exactly once to the task ID. Stop if the rewrite fails; do not invoke another actor on malformed ownership.

### Verification

- targeted source inventory shows no production lifecycle/closed-state parser outside the validator;
- every consumer returns the same classification for the same fixture;
- malformed, contradictory, identity-mismatched, and unsupported states stop before actor launch or mutation;
- exact ID or exact preserved path is required; empty invocation cannot select a candidate;
- blocked/operator retains owner and returns the exact condition;
- injected pre-commit closure failure leaves owner intact;
- injected post-commit/pre-clear failure leaves `CLOSED` plus a stale, safely clearable owner;
- owner helper's full local/repository-depth and contention suite is green with task-only owners;
- completed shared-lease carrier and dispatcher suites remain green;
- the real implementation task performs one Claude↔Codex handoff using the new core, validator, state record, and task-only owner.

### Exit condition

All semantic consumers use the validator, the approved core governs, no runtime accepts missing `status`, closure order is safe, the implementation task self-hosts one real handoff, and no other old-shape owner remains open.

### Scope boundary

Excluded: removing dispatcher session initialization, changing actor supervision/permissions, redesigning lease behaviour, deployment to other projects, and broad documentation cleanup.

## Tracer bullet 4 — Isolate Work Loop from legacy session state

### Behaviour

A Work Loop run creates and consults only Work Loop state, repository/Git evidence, binding, and live leases. Legacy stateful commands refuse to create a competing mandate, plan, note, marker, scratchpad, or reconstruction in a valid open Work Loop checkout.

### Starting evidence

- dispatcher unconditionally adds `logs/session-notes.md` to its allowlist;
- dispatcher calls `prime-session-entry.sh`, allocates/reuses `.session-marker`, and appends a `Files in scope` bullet;
- partial-effect reporting contains session-note bookkeeping exclusions;
- `/prime`, `/session-start`, `/session-plan`, and `/wrap-session` have no active-owner gate;
- Work Loop-specific docs claim protection from an unwired staging hook;
- `handoff-thread` defaults repository handoffs to a fresh worktree and allows conversation-carried settled state.

### Intended change

Remove dispatcher's legacy session initialization and every dependent allowlist, dirty-snapshot, log, and test special case. Add a narrow valid-open-owner preflight to the named legacy stateful commands, routing the operator to the exact task or Reorient without mutating either system. Make the active-Work-Loop branch of fresh-thread handoff reopen the bound checkout as Local and carry only exact paths plus navigation. Align compaction guidance and retire Work Loop-specific claims about `check-foreign-staging.sh`.

Leave the legacy session system functioning for non-Work-Loop sessions. Do not wire, delete, or redesign the staging hook here.

### Verification

- dispatcher source and tests contain no `prime-session-entry`, `session-notes.md`, `.session-marker`, session identity, or session-note allowlist special case;
- a dispatcher run changes no legacy state path;
- each named legacy command, invoked against a fixture with a valid open owner, refuses before its first state write and names the exact Work Loop route;
- the same commands retain their existing behaviour when no valid open owner exists;
- malformed/contradictory owner-state pairs stop rather than falling into either system;
- fresh-thread handoff for an active task targets the same checkout as Local and cites the exact task, plan/workflow, and next action without a state snapshot;
- misleading compact-summary text cannot override validator output;
- targeted documentation scan finds no remaining Work Loop claim that the unwired hook provides its commit boundary.

### Exit condition

No Work Loop execution or recovery path reads or writes legacy session state, and legacy commands cannot create competing state for a valid open Work Loop task.

### Scope boundary

Excluded: legacy session redesign, hook wiring/retirement, historical record cleanup, generic handoff changes outside the active Work Loop branch, and non-Work-Loop compaction policy.

## Tracer bullet 5 — Make deployment complete or visibly unavailable

### Behaviour

A checkout that exposes Work Loop v2 has the complete recovery/validation bundle, or readiness fails visibly and names the missing prerequisite.

### Starting evidence

- `sync-workflow` checks only the owner helper and `.owner` ignore rule;
- the research workflow carries a copy of `work-loop-owner.sh` but no state validator;
- partial or older checkouts can expose `/work-loop-v2` and then fail at different later seams;
- validator, Reorient, compact hook, and ignore rule are not one declared deployment capability.

### Intended change

Update the canonical deployment/sync contract and relevant deployable copies so validator, owner helper, Reorient, compact hook, and ignore rule are checked and moved as one capability. Add early Work Loop preflight diagnostics for missing prerequisites. Preserve project-specific settings and ignore files by checking required entries rather than replacing whole files.

### Verification

- one complete deployment fixture passes;
- five derived fixtures, each missing exactly one required component, fail and name that component;
- canonical and deployed validator/owner-helper copies are byte-identical where the deployment model requires copies;
- a checkout without `/work-loop-v2` reports the bundle as not applicable rather than broken;
- sync/deploy dry-run shows the exact proposed additions without overwriting project-specific content;
- Work Loop cannot begin in a partial checkout.

### Exit condition

Capability completeness is checked at deployment/sync and entry, no partial checkout is reported ready, and current Work Loop-enabled fixtures carry the full bundle.

### Scope boundary

Excluded: deploying to every existing project without operator selection, general template redesign, and unrelated workflow synchronization.

## Tracer bullet 6 — Prove deterministic lifecycle and recovery failures

### Behaviour

State, recovery, closure, and migration failures are deliberately created and produce the accepted deterministic stop or recovery without hiding partial evidence.

### Starting evidence

- unit and integration suites exist, but the accepted 15-scenario operational proof matrix has not run against the new contract;
- closure, interrupted write, blocked recovery, and state/Git disagreement are not proven end to end under explicit status.

### Intended change

Using temporary Git repositories/worktrees and narrow failpoints, prove the lifecycle/recovery half of the operational suite. Reuse the validator, owner helper, existing harnesses, and test conventions; do not create a general framework.

### Verification

Deliberately execute and record:

1. fresh session with no useful chat reconstructs the same status, turn, latest result, blocker, and next action from the exact task path or validated owner;
2. compaction/Reorient with an empty or misleading summary cannot override durable state and returns the same validator classification;
3. unexpected actor termination with preserved partial effects and no blind relaunch;
4. interrupted/truncated state update is rejected before launch, and the last committed state plus working diff provides deterministic repair evidence;
5. operator-blocked recovery retains owner and refuses a new task;
6. closure interruption before commit retains owner;
7. closure interruption after commit and before clear yields `CLOSED` and a clearable stale owner;
8. task state and Git disagreement stops without automatic rewrite;
9. clean closure clears ownership and permits reuse.

Each scenario must include a negative control or failpoint showing the proof can distinguish the wrong behaviour.

### Exit condition

All nine scenarios have deterministic, fail-capable evidence at the real validator, Reorient, owner, command, or courier seam; no scenario is satisfied by design prose.

### Scope boundary

Excluded: live model trials, cross-transport contention, broad fuzzing, performance testing, and speculative edge cases outside the accepted matrix.

## Tracer bullet 7 — Prove checkout binding, migration, and live concurrency

### Behaviour

Ambiguous ownership and concurrent actors fail closed, different tasks in different worktrees proceed, explicit migration ends with one owner, and both couriers contend through the same live leases.

### Starting evidence

- owner and lease helper suites cover their components;
- the owning Phase 1 task supplies accepted shared-lease controller and live evidence;
- the combined explicit-status, task-only-owner, recovery, and migration system has not yet been proven together.

### Intended change

Run the concurrency/migration half of the accepted operational suite in temporary repositories and bounded live trials. Import the accepted Phase 1 evidence by commit/reference; do not rerun or rebuild it unless the state cutover materially changed a covered seam. Where it did, run only the affected proof.

### Verification

Deliberately execute and record:

1. stale owner: closed clears; missing, malformed, active, or blocked target does not;
2. two concurrent worktrees with different tasks proceed and non-owner replicas refuse;
3. multiple owner claims and multiple unowned open copies both fail closed;
4. two actors attempt the same task and exactly one task lease succeeds;
5. attended/unattended collision contends through the same task and checkout leases;
6. explicit task migration ends with exactly one owner; an injected interruption leaves visible fail-closed ambiguity;
7. a bounded fresh-session live recovery reconstructs the same status, turn, latest result, blocker, and next action;
8. a bounded live compaction/Reorient recovery proves that an empty or misleading summary cannot override durable state and returns the same classification;
9. a bounded cross-courier live proof preserves state and partial-effect evidence.

### Exit condition

Every accepted ownership, migration, and concurrency outcome is observed; the completed Phase 1 evidence remains applicable or is narrowly refreshed where the semantic cutover changed its seam.

### Scope boundary

Excluded: Phase 2 automatic worktrees, concurrent writing of one task, automatic ambiguity resolution, automatic cleanup, and general soak testing.

## Tracer bullet 8 — Demonstrate cutover readiness and close under the new contract

### Behaviour

The complete candidate runs one representative Work Loop task from admission through execution, assessment, closure, and checkout reuse using only the new state system, then the implementation task itself closes safely.

### Starting evidence

- individual capabilities and operational scenarios are green;
- the isolated branch has not yet been accepted for landing;
- completion cannot be established by file presence or unit tests alone.

### Intended change

Run one representative end-to-end task through the real interfaces in the isolated checkout. Perform an independent bounded implementation assessment against the Fixed Point and this frozen plan. Correct only material findings under the Standard Implementation Workflow. Then close the implementation task using `status: closed`, commit it, clear owner, and prove a new task can claim the checkout.

### Verification

- real admission produces a valid `ACTIVE_CLAUDE` record and task-only owner;
- Claude entry validates, executes, commits, and hands back `ACTIVE_CODEX`;
- Codex assessment uses the same durable record and issues closure;
- Claude writes valid `CLOSED`, commits it, and only then clears owner;
- a new task claims the checkout without stale-state ambiguity;
- final targeted and proportional regression suites are green;
- final diff contains no legacy fallback parser, second state store, duplicate lease helper, or excluded machinery;
- independent assessment returns Pass, or bounded corrections are closed before progression;
- operator receives the accepted proof set and rollback boundary before landing.

### Exit condition

The candidate demonstrates the accepted outcome end to end, the implementation task closes under its own new contract, the checkout is reusable, and the branch is ready for an operator landing decision.

### Scope boundary

Excluded: automatic landing/push, production adoption beyond the representative proof, telemetry, convenience tooling, and V2 improvements.

---

# 6. Proof Matrix

| Accepted scenario | Planned proof owner |
|---|---|
| Fresh session with no useful chat | Tracer 6, confirmed live in Tracer 7 |
| Compaction and Reorient | Tracer 6, confirmed live in Tracer 7 |
| Unexpected Claude/Codex termination | Tracer 6 |
| Interrupted state-file update | Tracer 6 |
| Operator-blocked task recovery | Tracer 6 |
| Closure interrupted before commit | Tracer 3 focused check; Tracer 6 operational proof |
| Closure interrupted after commit, before owner clear | Tracer 3 focused check; Tracer 6 operational proof |
| Stale `.owner` | Tracer 7 |
| Two concurrent worktrees | Tracer 7 |
| Ambiguous same-task ownership | Tracer 7 |
| Two actors attempt the same task | Tracer 7 |
| Attended/unattended courier collision | Owning Phase 1 task, applicability confirmed in Tracer 7 |
| Task file and Git disagree | Tracer 6 |
| Explicit task migration | Tracer 7 |
| Clean closure and reuse | Tracer 6, final real demonstration in Tracer 8 |

---

# 7. Execution and Assessment Rules

For each tracer bullet:

1. re-anchor to its behaviour, boundary, and evidence;
2. establish the failing condition or preserved deficiency;
3. implement the smallest coherent change;
4. run focused verification;
5. refactor without widening behaviour;
6. run proportional regression checks;
7. demonstrate at the meaningful interface;
8. commit the coherent slice;
9. receive independent assessment: **Pass**, **Correct**, or **Escalate**.

Progress only on adequate evidence. A failed assumption, unsafe migration condition, or architecture contradiction escalates. Convenience does not change the frozen plan; evidence may.

Adjacent improvements are recorded and excluded. They do not enter a tracer bullet unless necessary to establish its behaviour.

---

# 8. Fresh-Context Plan Review Gate

Before implementation, a fresh reviewer must answer:

> Does this plan provide a safe, efficient and faithful path from the current repository to the accepted outcome?

The reviewer must check:

1. every accepted requirement maps to a capability and tracer bullet;
2. the validator is proven before destructive cutover;
3. tracked records migrate before consumers reject old state;
4. all semantic consumers switch together;
5. the shared-lease Phase 1 dependency is completed rather than duplicated;
6. current open-task/owner reality is handled before landing;
7. closure ordering is crash-safe;
8. no legacy state input survives in the Work Loop path;
9. Reorient and fresh-thread handoff resume the same checkout without snapshots;
10. deployment cannot expose a partial capability;
11. tracer bullets are vertical and small enough, except the intentionally atomic consumer cutover whose indivisibility is itself a safety requirement;
12. tests operate at validator, owner, recovery, command, and courier boundaries;
13. operational proofs deliberately inject the accepted failures;
14. no excluded registry, scheduler, database, fallback parser, second lease helper, or cleanup automation has entered the plan.

The reviewer may tighten sequencing, evidence, or scope. A material change to the Fixed Point, accepted decisions, exclusions, or success condition returns the plan for operator approval rather than being silently applied.

After review findings are resolved, change status to:

> **FROZEN — approved for sequential implementation**

No implementation begins while this document remains `Draft complete; awaiting ... review`.

---

# 9. Completion Proof

Completion is not shown by migrated files, green unit tests, or an implementation claim alone. It requires:

- validator and consumer agreement;
- deterministic failure and recovery proofs;
- deterministic interrupted-state repair from the last commit plus working diff;
- live cross-courier applicability;
- one real fresh-session recovery;
- one bounded live compaction/Reorient recovery with an empty or misleading summary;
- one representative end-to-end task;
- safe committed closure and checkout reuse;
- an independent final assessment against the accepted architecture;
- an operator landing decision after the proof and rollback boundary are visible.

Only then can the Work Loop v2 durable state repair be considered ready to cut over.
