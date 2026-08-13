# Work Loop V2 Dispatcher — Pre-Launch Implementation Roadmap

**Date:** 2026-08-11  
**Status:** Proposed implementation roadmap. Creating this document does not by itself authorise implementation.  
**Target release:** Ready for supervised semi-agentic repository work.  
**Governing assessment:** `dispatcher-semi-agentic-readiness-fixes-2026-08-11.md`

## Purpose

This roadmap converts the dispatcher readiness assessment into an ordered implementation programme. It deliberately narrows Work Loop V2 to a **supervised execution controller**: the operator and Codex retain direction and judgment, Claude performs bounded repository work and commits it, and the dispatcher transports turns, enforces mechanical limits, classifies outcomes, and stops when human judgment is required.

The roadmap does not attempt to make the dispatcher a general autonomous project coordinator. Its job is to close the small number of failure modes that currently make semi-agentic use unsafe or misleading, prove the resulting operating envelope, and then stop development long enough to learn from real use.

## Launch boundary

The pre-launch work is complete only when the dispatcher can reliably:

- admit one writer into a checkout at a time;
- run one bounded Work Loop unit in an isolated checkout;
- carry explicitly approved attended edit authority;
- distinguish success, permission blockage, partial effects, clean failure, and unexpected effects from deterministic evidence;
- prevent nested AI expansion by default and enforce hard limits when an exception is approved;
- stop and resume from repository truth without depending on shared session markers;
- report enough evidence for Codex or the operator to decide what happens next.

The release must continue to refuse:

- fully unattended or walk-away operation;
- strategic prioritisation or autonomous project routing;
- concurrent tasks in one checkout;
- unbounded nested Claude or Codex sessions;
- external or hard-to-reverse actions;
- projects without an identifiable authoritative current-position source;
- work already owned by a specialist project workflow.

## Implementation rules

1. **One bounded unit per phase.** Implement, test, assess, and commit each phase independently. Do not combine all fixes into one large dispatcher rewrite.
2. **Preserve observable behaviour outside the target fix.** If a phase exposes an adjacent defect, record it separately unless it prevents that phase's acceptance evidence.
3. **Prefer structural invariants over prompt instructions.** Checkout ownership, permission modes, process limits, and outcome classes must be enforced by the controller.
4. **Use fail-capable evidence.** Every acceptance check must produce a materially different result when the feature is absent or broken.
5. **Keep the spike until the contract is proven.** Do not change implementation language or perform a broad cleanup during pre-launch work.
6. **Keep unattended mode disabled.** Escaped descendants and unattended supervision remain a separate problem and are not prerequisites for this release.

## Phase 0 — Establish the pre-change baseline

### Outcome

Create a trustworthy comparison point for the four fixes without expanding the product surface.

### Work

- Identify the existing tests that exercise locks, post-hop state, permission denial, process trees, session identity, and resume behaviour.
- Add or isolate minimal regression fixtures for the known failure shapes if they are not already represented.
- Record which existing tests are portable in the actual Codex and Claude execution environments and which rely on simulated actors or environment-specific process visibility.
- Preserve the two incident evidence sets as immutable reference inputs.

### Required evidence

- A baseline run records pass, fail, and environment-dependent cases separately.
- At least one regression case reproduces the same-checkout/different-task admission weakness.
- At least one regression case reproduces a misleading post-hop classification when the state file was dirty before launch.
- Simulated evidence is labelled as simulated and is not presented as live transport proof.

### Exit gate

Proceed when every later phase has a named regression surface and the baseline does not claim more than it proves.

## Phase 1 — Enforce checkout-wide writer isolation

**Priority:** P0 — first release blocker.

### Outcome

Only one dispatcher may own write authority in a checkout, regardless of task identity. Parallel work is admitted only in separate worktrees or repositories.

### Work

- Introduce checkout-wide ownership alongside the existing task identity checks.
- Refuse actor launch when another live dispatcher owns the checkout.
- Make status inspection read-only and clear about both checkout owner and requested task.
- Fail safely when lock ownership is stale, ambiguous, or cannot be inspected.

The implementation may choose the lock representation. The invariant and its observable behaviour are fixed; the internal mechanism is not.

### Required evidence

1. Task A in checkout X prevents task B in checkout X from launching an actor.
2. Task A in checkout X and task B in linked worktree Y can run concurrently.
3. Status inspection reports the active owner without mutating repository or lock state.
4. A stale or unreadable lock produces a safe stop and no destructive cleanup instruction.
5. Existing same-task identity protections continue to pass.

### Exit gate

No two live dispatcher writers can be admitted into the same checkout under any tested task-name combination.

## Phase 2 — Make hop outcomes deterministic and resumable

**Priority:** P0 — second release blocker.

### Outcome

Every hop ends in one evidence-derived class with an accurate description of repository effects and a safe next action.

### Work

Capture and compare the minimum before/after evidence:

- state-file hash and dirty state;
- repository HEAD;
- allowed and disallowed working-tree deltas;
- committed path delta;
- actor exit status and timeout state;
- Claude permission denials, including denied tool and target when available;
- resulting Work Loop `turn:` value.

Map that evidence deterministically to at least:

1. completed handback;
2. permission blocked with no effect;
3. permission blocked after partial allowed effect;
4. partial effect without permission evidence;
5. clean actor failure;
6. unexpected or disallowed effect.

Add two attended permission modes:

- `default`, used unless the operator has approved otherwise;
- `acceptEdits`, carried only when explicit approval is recorded in run evidence.

Do not infer escalation from a denial. Do not allow `bypassPermissions`. No recovery branch may tell Codex to commit.

### Required evidence

1. A state file dirty before launch and byte-identical afterwards is not reported as newly changed.
2. Partial allowed changes are listed by exact path.
3. Permission blockage reports the denial and whether any repository effects occurred first.
4. The same evidence always maps to the same outcome.
5. An operator-approved `acceptEdits` retry stays inside the dispatcher and completes without screen-driving.
6. A denied run cannot silently acquire broader authority on retry.
7. Every outcome produces a recovery action consistent with the Work Loop ownership contract.

### Exit gate

An operator can understand what changed, why the hop stopped, and whether resumption is safe without reconstructing the run from raw logs.

## Phase 3 — Bound agent expansion inside each hop

**Priority:** P0 — third release blocker.

### Outcome

A bounded Work Loop unit remains operationally bounded even when an actor attempts to expand its work through nested AI sessions or disproportionate verification.

### Work

- Set nested Claude, Codex, or equivalent AI invocations to zero by default.
- Require explicit per-run operator approval for any exception.
- Record an approved maximum invocation count and enforce the whole-run deadline across nested work.
- Give correction rounds a materially smaller execution budget and no nested AI authority by default.
- Report task-scoped actor counts, nested-actor counts, elapsed time, and budget-stop reason in run evidence.

This phase does not need to solve fully detached descendants sufficiently for unattended mode. It does need to stop or visibly classify nested expansion within the supervised operating envelope.

### Required evidence

1. An unapproved nested AI launch is prevented or causes an immediate visible stop.
2. An approved exception cannot exceed its invocation count.
3. Nested work cannot outlive the whole-run deadline.
4. A correction cannot expand into broad unrelated investigation or a verification farm.
5. Budget exhaustion lists the work that completed and any partial repository effects.

### Exit gate

One actor hop can no longer hide unbounded model turns, nested agents, or unlimited correction work behind a single outer timeout.

## Phase 4 — Remove shared session-marker coupling

**Priority:** P1 — architectural reliability fix.

### Outcome

Headless dispatcher runs use run-local identity and repository evidence, without mutating interactive-session markers or tracked session notes.

### Work

- Remove dispatcher allocation of shared session markers.
- Remove dispatcher footprints from tracked `logs/session-notes.md`.
- Keep run identity within dispatcher-owned lock and evidence surfaces.
- Ensure interactive-session hooks ignore dispatcher-owned worktrees or accept an explicit run-local identity without falling back to shared mutable state.

Do not introduce a replacement marker registry, reconciliation hook, or second identity system.

### Required evidence

1. A normal dispatcher run creates no shared session marker and does not modify session notes.
2. Task changes remain distinguishable from foreign changes.
3. Stale, missing, or unrelated interactive-session markers do not alter dispatcher behaviour.
4. An unrelated interactive session cannot make a dispatcher false-pass or false-block.

### Exit gate

Routine dispatcher execution leaves no unrelated tracked footprint and has no behavioural dependency on interactive-session identity.

## Phase 5 — Run supervised pre-launch proofs

**Priority:** P0 release proof, after Phases 1–4.

### Outcome

Demonstrate the release boundary with live actors in clean dedicated worktrees. These are failure-shaped controller proofs, not a requirement to manufacture work in every Axcíon project.

### Trial A — Repeated normal unit

Run a genuinely authorised, bounded repository edit through implementation, handback, assessment, and closure at least three times. The repetitions may use different suitable projects, but every run must have an authoritative current-position source and a real completion condition.

### Trial B — Permission denial and resume

Trigger a deliberate permission denial, confirm correct classification and partial-effect reporting, record operator approval for any permission change, and resume inside the dispatcher.

### Trial C — Controlled stop and recovery

Stop a live hop, inspect reachable process and repository state, and resume without duplicated work or invented completion.

### Evidence record for every trial

- task and checkout identity;
- selected permission mode and approval evidence;
- deadline, hop limit, and applicable correction budget;
- actor and nested-actor counts;
- before/after repository evidence;
- dispatcher outcome class and recovery action;
- operator intervention required;
- completion-condition result;
- elapsed time and observed ceremony;
- any accepted limitation.

### Exit gate

All three trial shapes pass, the normal trial succeeds three times, and no run requires manual reconstruction of repository state. A project trial is selected only when that project has suitable authorised work; specialist workflows and external-action campaigns are not wrapped merely to satisfy coverage.

## Phase 6 — Release and observation period

### Release decision

Declare **Ready for supervised semi-agentic use** only when every preceding phase has passed its exit gate. The release statement must also say:

- operator or Codex direction remains required;
- fully unattended mode remains disabled;
- external and hard-to-reverse actions remain outside the dispatcher;
- one project-owned authoritative current-position source is required;
- specialist project workflows retain ownership of their work.

### Observation period

Use the dispatcher for 20–30 genuine bounded units across suitable project contexts. This is an evidence-gathering window, not a pre-launch gate or a quota that justifies artificial trials.

Record only information needed to answer:

- Which stops recur?
- Which outcomes still require manual reconstruction?
- Where does operator ceremony remain high?
- Which project prerequisites are routinely missing?
- What is the next single bottleneck supported by repeated evidence?

After the observation period, choose one of three outcomes:

1. keep the supervised controller unchanged;
2. fix one repeated, material bottleneck;
3. begin a separately approved assessment of unattended operation.

Do not infer that successful supervised use authorises global scheduling, autonomous routing, RAG, external actions, or unattended execution.

## Project admission contract

A project may use the released dispatcher only when it exposes one identifiable, project-owned current-position source containing:

- current phase or stage;
- approved objective and identifiable plan version;
- completed work and accepted decisions;
- live blockers and dependencies;
- the next work that is actually authorised.

Existing sources such as `PROJECT.md`, `PROJECT-STATE.md`, or `pipeline-state.md` should be used or tightened. The dispatcher must not create a global project database, reconstruct project truth from broad search, or become a second state system. If the source is missing or materially ambiguous, stop and route the gap to the project owner.

## Deferred work

The following remain explicitly outside this roadmap:

- a global queue, portfolio scheduler, or cross-project autonomy;
- RAG or a vector database for dispatcher context;
- autonomous capability or strategy routing;
- fully unattended process supervision;
- a dispatcher rewrite or implementation-language migration;
- automatic email, CRM, publication, access, legal, compliance, or push actions;
- new dashboards, markers, hooks, audit layers, or persistent run-state systems;
- wrapping specialist workflows in a second orchestration layer.

Any of these requires a later, separately approved problem statement supported by observed need.

## Final launch checklist

- [ ] Checkout-wide single-writer isolation passes.
- [ ] Post-hop outcome classification is deterministic and fail-capable tests pass.
- [ ] `default` and operator-approved `acceptEdits` attended modes behave as specified.
- [ ] Recovery guidance never assigns commits to Codex.
- [ ] Nested AI work is zero by default and bounded when approved.
- [ ] Corrections have a smaller enforced execution budget.
- [ ] Headless runs do not touch shared session markers or tracked session notes.
- [ ] Live normal, permission-resume, and controlled-recovery trials pass.
- [ ] The normal trial passes at least three times.
- [ ] Project admission refuses missing or ambiguous current-position authority.
- [ ] Unattended mode remains visibly unavailable.
- [ ] The release is labelled supervised semi-agentic use, not autonomous operation.
