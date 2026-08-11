# Work Loop V2 Dispatcher — 80/20 Fixes for Semi-Agentic Axcíon Work

**Date:** 2026-08-11  
**Status:** Assessment and prioritised fix recommendation. No implementation is authorised by this report.  
**Scope:** The Work Loop V2 dispatcher and the minimum surrounding contract needed for supervised, semi-agentic repository work across Axcíon projects.

## Executive conclusion

The dispatcher should not yet be treated as a general autonomous project coordinator. It is much closer to a useful **supervised execution controller**: the operator and Codex set direction, Claude performs bounded repository work, and the dispatcher carries the turn, enforces mechanical limits, and stops on ambiguity.

That narrower capability is worth finishing. It would remove much of the operator's manual transport burden without asking the dispatcher to decide strategy, operate external systems, or coordinate whole project portfolios.

Five changes provide most of the value. The first three are release blockers for semi-agentic use. The fourth removes a known source of fragility. The fifth is the proof required before normal use.

## Target operating envelope

After these fixes, the dispatcher should be trusted to:

- run one bounded repository unit in one isolated checkout;
- carry routine Claude ↔ Codex turns without operator copy-paste;
- permit a deliberately approved attended permission mode;
- stop visibly on permission denial, partial work, unexpected effects, budget exhaustion, or an operator-owned decision;
- resume from repository truth after a cleanly classified stop;
- produce enough evidence for Codex or the operator to judge what happened.

It should **not** yet be trusted to:

- choose project priorities or settle strategic ambiguity;
- execute external or irreversible actions;
- operate several tasks in one checkout;
- spawn open-ended nested Claude or Codex sessions;
- run fully unattended after the operator leaves;
- replace a project's approved workflow or current-state source.

This boundary matters. Semi-agentic work does not require solving every hard problem in unattended autonomy.

## Priority 1 — Enforce one writer per checkout

### Problem

The current lock is keyed by both checkout and task. It prevents two dispatchers from driving the **same task** in the same checkout, but it can admit two different tasks into the same checkout concurrently. The dispatcher documentation says same-checkout concurrency is unsafe, yet the controller does not structurally prevent it.

This leaves a high-consequence rule dependent on operator memory. Different tasks can race on Git state, working-tree files, logs, hooks, or shared project artifacts even when their state files differ.

### 80/20 fix

Add a checkout-wide writer lock in addition to task identity. A dispatcher that intends to launch an actor must refuse if any other dispatcher owns that checkout. Parallel tasks must use separate worktrees or separate repositories.

Keep the task-specific identity checks. They solve a different problem: making sure the requested task matches its state file.

### Acceptance evidence

The fix is sufficient when fail-capable tests prove:

1. task A running in checkout X causes task B in checkout X to stop before actor launch;
2. task A in checkout X and task B in linked worktree Y can run concurrently;
3. `--status` distinguishes the checkout owner from the requested task without writing anything;
4. stale and uninspectable checkout locks fail safely and never recommend destructive cleanup without positive evidence.

### Why first

This eliminates the most direct shared-state corruption path with one structural invariant. It is cheaper and more reliable than adding more collision detectors, shared logs, or concurrency rules.

## Priority 2 — Classify post-hop outcomes from the actual before/after delta

### Problem

The dispatcher currently has strong raw observations but an incomplete outcome model. A recent incident showed it diagnosing an uncommitted state-file handback even though the state file was already dirty before launch and remained byte-identical; the actual partial effects were allowed implementation-file edits. Claude permission denials were captured in JSON but not interpreted by the dispatcher.

The result is a dangerous mismatch: the dispatcher stops, but it can tell the operator the wrong reason and the wrong recovery action. See:

- `incident-evidence/incident-1-2026-08-10/reports/postmortem-2026-08-10.txt`
- `handoff-automation-spike/dispatch.sh`, especially the post-Claude `state_dirty` branch
- `handoff-automation-spike/README.md` under “What this spike does not establish”

### 80/20 fix

Build one deterministic post-hop classifier from evidence the dispatcher already captures:

- state-file hash before and after;
- state-file dirty state before and after;
- HEAD before and after;
- allowed and disallowed working-tree deltas;
- committed path delta;
- actor exit status;
- Claude `permission_denials`, when present;
- resulting `turn:`.

The minimum distinct outcomes should be:

1. **Completed handback** — valid state transition and required commit state.
2. **Permission blocked, no effect** — denial recorded and repository unchanged.
3. **Permission blocked after partial allowed effect** — denial recorded and exact changed paths listed.
4. **Partial effect without permission evidence** — repository changed but no valid handback occurred.
5. **Clean actor failure** — repository unchanged and retry policy may apply.
6. **Unexpected effect** — disallowed working-tree or committed path changed.

Recovery text must follow the classified evidence. It must never tell Codex to commit, because the Work Loop contract assigns every commit to Claude.

### Attended permission support

Add an explicit attended permission-mode input so the dispatcher can carry a permission level the operator has approved for that run. The smallest useful set is:

- `default` — ordinary attended run;
- `acceptEdits` — only after explicit operator approval recorded in the run evidence.

Continue refusing `bypassPermissions` for attended work. Do not infer permission escalation from a previous denial.

### Acceptance evidence

The fix is sufficient when tests demonstrate:

1. a state file dirty before launch and byte-identical afterwards is not reported as newly edited;
2. partial allowed-path edits are listed precisely;
3. a permission denial identifies the denied tool and target;
4. an operator-approved `acceptEdits` resume stays inside the dispatcher;
5. no recovery branch instructs Codex to commit;
6. the same evidence always maps to the same outcome.

### Why second

Semi-agentic work depends more on honest stopping than on uninterrupted completion. If the dispatcher cannot say what happened, the operator must reconstruct the run manually and the automation has not reduced meaningful burden.

## Priority 3 — Put a hard ceiling on agent expansion

### Problem

The dispatcher bounds hops and wall-clock time, but one hop can still expand into many model turns, nested Claude or Codex processes, or a disproportionately large verification farm. The 2026-08-10 incident demonstrated that a formally bounded unit can become operationally unbounded inside one actor process. The 2026-08-11 adoption-readiness run then reached 48 turns and 42,119 output tokens before its 900-second timeout:

- `incident-evidence/incident-1-2026-08-10/reports/postmortem-2026-08-10.txt`
- `incident-evidence/incident-2-2026-08-11/runs/20260811T101503-405170d5-84471-eval-mvp-v0.2-adoption-readiness-fix.hop1.claude.out`

This is the biggest remaining ceremony and cost risk. Path allowlists do not constrain how much work happens inside those paths.

### 80/20 fix

Apply three default bounds:

1. **Nested AI actors: zero.** A dispatcher-launched actor may not launch `claude`, `codex`, or equivalent AI execution unless the operator explicitly approves it for that run.
2. **Approved nested work has a count and deadline.** The run records the maximum number of nested invocations and the same whole-run deadline still governs them.
3. **Corrections get a smaller execution budget.** A correction may verify only the frozen findings. Its default deadline should be materially shorter than an implementation unit's and it gets no nested AI actors.

The brief should still express proportionality, but the high-consequence bounds must be enforced by the controller rather than remembered by the model.

### Acceptance evidence

The fix is sufficient when tests demonstrate:

1. an unauthorised nested Claude or Codex launch is prevented or causes an immediate visible stop before useful nested work proceeds;
2. an authorised nested run cannot exceed its invocation count;
3. nested work cannot outlive the whole-run deadline;
4. a correction cannot silently expand into a broad behavioral test matrix;
5. task-scoped model-session counts are reported from run evidence.

### Why third

This converts time limits from a weak outer boundary into a meaningful work boundary. It addresses runaway cost and ceremony without building a scheduler, planner, or general resource-management subsystem.

## Priority 4 — Remove dispatcher dependence on shared session-marker machinery

### Problem

Headless dispatcher runs currently compensate for the repository's shared session-marker fallback by allocating a fresh marker and appending a footprint to tracked `logs/session-notes.md`. This was added because a stale shared marker could make a staging guard read another session's footprint.

The compensation is understandable, but architecturally backwards: one shared mutable control is made reliable by writing more shared mutable control state. It also gives each routine dispatcher invocation a side effect unrelated to the task's result.

The relevant implementation is `handoff-automation-spike/dispatch.sh` under `init_session_identity`.

### 80/20 fix

Make the dispatcher independent of interactive-session identity:

- use checkout isolation and the run's own allowlist as the authority boundary;
- keep run identity local to the dispatcher lock and evidence directory;
- do not allocate `.session-marker` entries for headless runs;
- do not append dispatcher footprints to tracked session notes;
- ensure interactive-session hooks either ignore dispatcher-owned worktrees or use an explicit run-local identity supplied by the dispatcher without shared fallback state.

Do not add another marker format, registry, or reconciliation hook.

### Acceptance evidence

The fix is sufficient when:

1. a dispatcher run creates no session marker and does not modify session notes;
2. expected task changes remain distinguishable from foreign changes;
3. an unrelated interactive session cannot make a dispatcher false-pass or false-block;
4. removing or staling interactive-session markers does not change dispatcher behavior.

### Why fourth

The first three priorities make semi-agentic work safer. This one makes the architecture leaner and removes the clearest example of solving a stale-state problem with more mutable state.

## Priority 5 — Prove the supervised operating envelope before normal use

### Problem

The controller suite is substantial, but its cases use simulated actors. The dispatcher README explicitly says a green suite does not establish live transport, repeat reliability, production readiness, or work quality. The unattended plan also records that the walk-away pilot has never happened.

For semi-agentic use, a full unattended proof is unnecessary. A smaller supervised adoption proof is enough.

### 80/20 fix

After priorities 1–4 are implemented, run three live representative trials in clean dedicated worktrees:

1. **Normal implementation:** a bounded repository edit, Claude handback, Codex assessment, and closure.
2. **Permission interruption and resume:** a deliberate denial, honest partial-effect classification, operator-approved permission change, then successful resume inside the dispatcher.
3. **Controlled stop and recovery:** terminate a live hop, verify the reachable process tree, inspect partial state, and resume without duplicated work.

Run the normal case at least three times. One successful observation is not repeat reliability.

Each trial must record:

- checkout and task identity;
- permission mode;
- deadline and hop count;
- actor and nested-actor counts;
- before/after repository evidence;
- dispatcher outcome classification;
- operator intervention required;
- whether the task actually achieved its completion condition;
- observed ceremony and elapsed time.

### Adoption decision

Adopt supervised semi-agentic use only if all three shapes behave predictably and the repeated normal case does not require manual state reconstruction. Keep fully unattended operation disabled until its separate process-supervision and isolation blockers are resolved or consciously accepted by the operator.

## One project-side prerequisite, not a dispatcher subsystem

The dispatcher should not discover project truth from a broad repository scan. Every project using semi-agentic work needs one identifiable authoritative current-position source that states, in the project's own vocabulary:

- current phase or stage;
- approved objective and plan identity;
- completed work and accepted decisions;
- live blockers and dependencies;
- the next work that is actually authorised.

Use and tighten existing files such as `PROJECT.md`, `PROJECT-STATE.md`, or `pipeline-state.md`. Do not create a global dispatcher database or a second project-state system. If a project lacks one authoritative position source, the dispatcher should stop before framing work and route the gap to the project's owner.

## What should explicitly not be built yet

- **No global queue or portfolio scheduler.** The dispatcher should run one bounded task, not manage Axcíon's project portfolio.
- **No RAG or vector database for dispatcher context.** Retrieval does not establish authority or freshness and would make stale material easier to load.
- **No autonomous strategic router.** Capability selection remains a semantic judgment governed by the Work Loop skill and project workflows.
- **No new hook, guard, marker, dashboard, or audit layer.** Fix or remove the underlying shared-state dependency.
- **No general process supervisor solely to unlock unattended mode.** Semi-agentic attended work can ship without it; keep unattended mode disabled instead.
- **No rewrite of the dispatcher before the above behavior is settled.** First prove the minimum contract. A later implementation-language decision can then be made from an understood surface rather than from the current spike's history.
- **No automatic external actions.** Email sends, CRM promotion, access grants, legal/compliance gates, publication, and pushes remain operator-owned or governed by their specialist workflow.

## Recommended implementation order

1. Add checkout-wide writer isolation.
2. Replace post-hop heuristics with the deterministic outcome classifier and add operator-approved attended permission modes.
3. Enforce zero nested AI actors by default, plus count/deadline limits when approved.
4. Remove the headless session-marker and session-notes dependency.
5. Run the three live supervised trials and make the adoption decision.

Do not interleave this with RAG, routing expansion, project scheduling, or full unattended supervision. Those additions would obscure whether the small controller is reliable.

## Release criteria for semi-agentic use

The dispatcher is ready for supervised semi-agentic Axcíon work when all of the following are true:

- one checkout admits only one dispatcher writer;
- every non-successful hop is classified from deterministic evidence with an accurate recovery action;
- operator-approved attended edit authority can be carried without interactive screen-driving;
- nested AI work is prevented by default and bounded when approved;
- routine runs do not mutate shared session markers or tracked session notes;
- the three live trial shapes pass, including three repeat normal runs;
- a project without an authoritative current-position source is refused rather than reconstructed from memory or broad search;
- fully unattended mode remains visibly unavailable until its separate blockers are closed.

Meeting these criteria would justify **Ready for supervised semi-agentic use**. It would not justify “autonomous project coordinator” or “safe walk-away operation,” and the system should not claim either.
