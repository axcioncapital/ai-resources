# Work Loop v2 dispatcher reliability closure report

**Date:** 2026-08-15  
**Purpose:** Define everything that still needs to be fixed after the concurrency Phase 1, durable-state system, and autonomy-authority capability are integrated so the dispatcher can become a reliable supervised semi-autonomous controller.  
**Decision:** The target is not full autonomy. The dispatcher should carry Claude and Codex through the normal implementation path without operator transport, continue only while state, evidence, authority and execution remain valid, and stop with an actionable durable handoff whenever a problem or operator-owned decision appears. Full unattended or walk-away operation is explicitly deferred and must not block this target.

This report is self-contained and is intended to become the planning input for the next dispatcher-focused implementation. It does not authorize changes, reopen the three existing plans, or treat their current unfinished worktree state as completed evidence.

Source citations use four checkout prefixes: `main/` is `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/`; `concurrency/` is `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-concurrency-fix-2/`; `durable-state/` is `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-durable-state/`; and `autonomy/` is `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-autonomy-authority/`. Line citations identify the inspected 2026-08-15 versions. Active worktree records support present-state observations only; the completed outcomes in Section 1 remain explicit assumptions.

## 1. Assumptions and target definition

This report deliberately assumes all of the following future conditions are true:

1. **Concurrency Phase 1 is complete and merged.** Shared task and checkout leases, cross-transport contention, early exit-17 refusal evidence, genuine case 23, genuine case 24, final assessment, and integration have all passed.
2. **The durable-state implementation is complete and merged exactly to its frozen plan.** One canonical validator owns lifecycle semantics; records use explicit `active | blocked | closed` status; ownership and closure are crash-safe; every consumer uses the validator; legacy session-marker/session-note coupling is removed; the capability is complete-or-unavailable; and the required recovery, migration, worktree and representative end-to-end proofs have passed.
3. **The autonomy-authority implementation is complete and merged exactly to its final accepted plan.** Semantic authority, capability envelopes, escalation boundaries, correction authority, operator gates, attended-carrier scenario evidence, and real Standard-task evidence have passed.

The terms used below are intentionally separate:

- **Reliable supervised semi-autonomous dispatcher — the target:** Patrik launches a bounded task and Claude and Codex carry the normal implementation, assessment, correction and closure path without manual turn transport. The dispatcher stops only for a genuine decision, permission, risk, unexpected effect, failed proof or integration gate, then hands control to Patrik with enough durable evidence to choose and resume safely.
- **Operator takeover:** a deliberate durable state in which no further actor is launched until Patrik selects an explicit recovery option. It is successful fail-closed behavior, not a dispatcher failure.
- **Reliable unattended dispatcher — deferred:** the operator may walk away. The dispatcher must additionally contain the full lifetime of everything its actors create, survive interruption safely, prove its effective isolation on the release host, and return one durable, trustworthy result.

Passing the supervised semi-autonomous bar is the release objective of this report. It does not imply the unattended bar, and the unattended bar is not required for adoption of the target system.

## 2. What the assumed implementations already solve

### 2.1 Concurrency and post-hop truth

The concurrency work supplies the shared Git-common lease system, one-writer checkout exclusion, same-task exclusion across transports, conservative stale-holder handling, cross-worktree fan-out, and durable lease-refusal evidence. It also materially improves post-hop classification and descendant observation. These controls should be retained and not reimplemented in another dispatcher-local lock system.

Primary evidence:

- `concurrency/plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh:737-858`
- `concurrency/plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh:1186-1390`
- `concurrency/logs/work-loop/cross-transport-concurrency-correction.md:18-53`

### 2.2 Durable semantic state and recovery

The durable-state plan closes the ambiguity between active, blocked and closed records; removes duplicate lifecycle parsers; makes ownership task-only and crash-safe; defines commit-before-owner-clear closure; removes Work Loop dependence on session markers and tracked session notes; packages the state capability completely; and proves recovery across fresh sessions, compaction, interruption, partial writes, blocked tasks, stale owners, worktrees and clean closure/reuse.

Primary evidence:

- `durable-state/plans/work-loop-v2-v0.2/work-loop-v2-durable-state-system-implementation-plan-v0.1.md:24-79`
- `durable-state/plans/work-loop-v2-v0.2/work-loop-v2-durable-state-system-implementation-plan-v0.1.md:691-802`
- `durable-state/plans/work-loop-v2-v0.2/work-loop-v2-durable-state-system-implementation-plan-v0.1.md:881-896`

### 2.3 Semantic autonomy and operator authority

The autonomy-authority capability closes the semantic questions: what the actor may decide, what is inside the delegated capability envelope, what requires escalation, what correction is pre-authorized, and which operator decisions cannot be inferred. Its trials and real-task evidence exercise the attended carrier, however—not the multi-hop dispatcher. The plan explicitly keeps the dispatcher outside its trial surface and leaves unattended release deferred.

Primary evidence:

- `autonomy/plans/work-loop-v2-v0.2/work-loop-v2-autonomy-authority-capability-implementation-plan-v0.1.md:965-1032`
- `autonomy/plans/work-loop-v2-v0.2/work-loop-v2-autonomy-authority-capability-implementation-plan-v0.1.md:1374-1451`
- `autonomy/plans/work-loop-v2-v0.2/work-loop-v2-autonomy-authority-capability-implementation-plan-v0.1.md:1481-1491`

### 2.4 Failure families already closed by the assumed baseline

| Earlier failure family | Status after the assumed integrations |
|---|---|
| Two different tasks writing the same checkout | Closed by shared checkout lease |
| Same task driven by different transports | Closed by shared task lease |
| False attribution of pre-existing dirty state to an actor | Closed by deterministic before/after classification |
| Ambiguous `turn: operator` meaning blocked versus closed | Closed by explicit durable lifecycle |
| Resume depending on chat memory, compaction summary or stale session marker | Closed by canonical durable state and validated ownership |
| Dispatcher mutation of tracked session notes and shared session identity | Closed by durable-state cutover |
| Unclear semantic authority and unnecessary operator stops | Closed by autonomy-authority rules, within their tested attended envelope |

These closures are dependencies. The next implementation should verify that it preserves them, not redesign them.

## 3. Target operating model

### 3.1 Normal automatic path

The dispatcher owns routine turn transport inside one approved bounded task:

1. Patrik launches a prepared task with its checkout, intended outcome, success criteria, exclusions and capability envelope already settled.
2. The dispatcher preflights the complete runtime, validates durable state and ownership, and acquires the shared task and checkout leases.
3. Claude performs the bounded implementation and makes one valid durable handback.
4. The dispatcher validates the result, state transition, Git facts, changed paths, budgets and process observations.
5. Codex assesses the implementation against the frozen brief and evidence.
6. On `Pass`, Claude performs the bounded closure and the dispatcher verifies clean completion.
7. On an explicitly pre-authorized, bounded correction, Claude may perform one correction and Codex reassesses it; successful reassessment proceeds through the defined closure path.
8. On any other outcome, or on a second non-pass assessment, the dispatcher enters operator takeover.

The initial release should permit at most one correction cycle. Increasing that budget is a later evidence-based decision, not a default.

### 3.2 Automatic continuation corridor

The dispatcher may continue without asking Patrik only while all of these remain true:

- the task identity, checkout, objective, success criteria and exclusions are unchanged;
- the next action is inside the approved capability and write-path envelope;
- durable state, ownership, leases and Git facts agree;
- the preceding actor produced its required result and state transition;
- no unapproved permission, external action or consequential decision is required;
- no unexpected repository effect, process, evidence gap or budget breach exists;
- the next launch remains inside the approved hop, deadline, usage and correction budgets.

If any condition is false or cannot be proven, continuation is forbidden and operator takeover begins.

### 3.3 Operator takeover contract

“Stop and ask Patrik” must be a first-class protocol, not merely a non-zero exit. The dispatcher atomically writes the terminal transport result, updates the canonical task record to the legal blocked state, and emits one compact operator handoff packet containing:

- what the dispatcher was attempting and which actor/stage failed;
- the exact stop classification and why automatic continuation is forbidden;
- whether a model request started, its run/session identifier, duration and recorded usage;
- state hash, HEAD, index/working-tree condition and changed paths before and after;
- whether partial implementation exists and whether it is committed;
- top-level actor and observed descendant status;
- whether leases were released or conservatively retained, and why;
- exact result, log and raw-capture paths;
- two or three safe recovery choices when more than one exists;
- the recommended choice when repository evidence makes one clearly safer;
- the exact resume command or action after Patrik decides.

The canonical task state becomes:

```yaml
status: blocked
turn: operator
```

Its blocker and next action must agree with the terminal result. The transport result records execution facts; the durable task record remains semantic authority. No dashboard, notification service or second state system is required for the initial release—the terminal summary plus canonical blocked record is the authoritative request for Patrik.

### 3.4 Mandatory operator-stop classes

The dispatcher stops for Patrik when any of the following occurs:

- a permission denial requires a different permission mode;
- Codex reports a material defect outside the one pre-authorized correction cycle;
- scope, architecture, priority, success criteria or operator intent becomes unclear;
- a model-started actor fails, times out or returns without its required final result;
- partial effects exist without a valid handback;
- state, ownership, lease or Git facts are invalid, ambiguous or contradictory;
- an unexpected nested process or uncertain teardown is observed;
- hop, deadline, correction or usage budget is exhausted;
- authentication or runtime capability becomes unavailable after preflight;
- the work would require push, merge, deployment, credentials, destructive shared-state action or another external consequence not explicitly delegated;
- evidence is missing or insufficient to distinguish safe continuation from a repeated or conflicting action.

Only named zero-model preflight failures may recover automatically, and only when state, HEAD, index and working tree are unchanged and the correction is deterministic.

### 3.5 Resume contract

Operator takeover never resumes by blindly retrying the failed actor. Resume follows this sequence:

1. Patrik selects or supplies one explicit recovery instruction.
2. The decision and any newly approved permission, scope or correction authority are recorded in canonical state/run evidence.
3. The dispatcher starts a new run identity and revalidates task state, ownership, leases, HEAD, working tree, partial effects, runtime and budgets.
4. It resumes from the durable next action rather than replaying the previous request.
5. If repository facts drifted while waiting for Patrik, it stops again with an updated handoff instead of applying a stale decision.

A lease is released only when the dispatcher can prove release is safe. Uncertain process teardown pins the applicable lease and makes that uncertainty part of the operator handoff.

## 4. Remaining blockers for reliable supervised semi-autonomous dispatcher operation

### R1 — Carry operator-approved permissions through the dispatcher

The original incident's strongest bypass trigger was a permission dead end: the dispatcher's path allowlist permitted the edit, but headless Claude was still launched with `--permission-mode default` and refused it. The operator then left the dispatcher and resumed interactively. An accurate stop alone could not solve that conflict.

The current dispatcher still hardcodes attended Claude to `--permission-mode default`:

- `concurrency/plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh:2470-2485`
- `main/plans/work-loop-v2-v0.2/incident-evidence/incident-1-2026-08-10/incident-1-established.md:87-102`
- `main/plans/work-loop-v2-v0.2/incident-evidence/incident-1-2026-08-10/incident-1-established.md:151-174`

Required change:

- Add an attended dispatcher input for the smallest approved set: `default` and `acceptEdits`.
- Permit `acceptEdits` only when the operator explicitly approves it for that invocation.
- Record requested and effective permission mode in durable run evidence.
- Never infer escalation from a previous denial.
- Continue refusing `bypassPermissions`.
- Make denial followed by approved resume stay inside the dispatcher; no interactive bypass should be needed.

### R2 — Emit one atomic transport result on every exit

Phase 1 makes lease refusal durable, but the dispatcher still has a special `terminal-record` for exit 17 rather than one common result contract covering every terminal path. Durable task state answers “what is the task truth?” It does not answer every transport question such as whether a model started, where failure occurred, or whether a final capture exists.

Required change:

- Initialize external evidence before any mutating or paid step.
- On every exit, atomically finalize one machine-readable result with at least:

```text
RESULT transport=dispatch outcome=<...> code=<n> task=<id>
       stage=<usage|preflight|lease|ownership|actor|postcheck>
       actor_started=<true|false> state_changed=<true|false>
       head_changed=<true|false> log=<path> capture=<path-or-none>
```

- Cover usage errors, missing runtime, ownership refusal, lease refusal, permission denial, timeout, interruption, actor failure, no transition, partial effects, budget exhaustion and success.
- Preserve `--status` as strictly read-only: it takes no lease and writes no evidence.
- Retain compact final results durably; retain raw captures under an explicit temporary/audit policy rather than pasting them into task state.

Primary evidence:

- `concurrency/plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh:788-845`
- `concurrency/plans/work-loop-v2-v0.2/dispatcher-work-loop-harness-autonomy-improvement-report-2026-08-14.md:160-207`

### R3 — Add an exact producer-consumer evidence handshake

The dispatcher, Work Loop command and attended carrier must not coordinate by process-name polling, prose, terminal observation or waiting for a file whose producer never promised to create. That was the immediate waste mechanism in live case 23: the losing dispatcher safely refused, but the waiting actor had no deterministic artifact contract and spent a paid model run waiting.

Required change:

- The producer writes the final result atomically at one exact run-id-bound path.
- The consumer waits only for that path, with a deadline shorter than its own actor timeout.
- Absence at the deadline becomes a durable blocker handback, not an ordinary-success narrative.
- A product-level actor exit of zero is never treated as Work Loop completion without the required state transition and result evidence.
- Every normal actor prompt states its exact required handback: one valid state transition, one defined identity refusal, or one explicit operator blocker.

Primary evidence:

- `concurrency/plans/work-loop-v2-v0.2/dispatcher-work-loop-harness-autonomy-improvement-report-2026-08-14.md:11-25`
- `concurrency/plans/work-loop-v2-v0.2/dispatcher-work-loop-harness-autonomy-improvement-report-2026-08-14.md:126-145`
- `concurrency/plans/work-loop-v2-v0.2/dispatcher-work-loop-harness-autonomy-improvement-report-2026-08-14.md:184-207`

### R4 — Remove automatic retry after any model request starts

The dispatcher still retries a non-zero actor once when repository facts appear unchanged. Repository unchanged does not prove the request never started, consumed no tokens, or produced no external read effects. A second launch can double the cost and repeat effects the repository cannot observe.

Required change:

- Record `actor_started` before relying on retry policy.
- Retry only a mechanically proven zero-model preflight failure with `actor_started=false`.
- Never automatically retry a started request, timeout, missing final result, permission decision, no-transition result or partial effect.
- Persist the model/session run identifier and final usage event when available.

Primary evidence:

- `concurrency/plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh:2769-2806`
- `main/audits/work-loop-v2-codex-usage-optimization-report-2026-08-13.md:72-86`
- `main/audits/work-loop-v2-codex-usage-optimization-report-2026-08-13.md:125-137`

### R5 — Bound hops, time, model usage and context growth

The dispatcher currently defaults to four hops and permits an unset whole-run deadline. The historical incident accumulated 92 turns, 108,908 output tokens and $11.3390 across the first four dispatcher runs; a later run reached 48 turns and 42,119 output tokens before its 900-second timeout. Per-actor wall-clock limits did not prevent one bounded unit from becoming operationally disproportionate.

Required change:

- Change the normal prepared-brief maximum from four hops to three: implement, assess, then close or perform the authorized correction/closure.
- Give the optional correction path its own explicit ceiling of one correction and one reassessment rather than silently inheriting a larger general hop limit.
- Choose and record a finite whole-run deadline for every supervised multi-hop run.
- Parse and record per-hop and cumulative input, cached-input, output and reasoning usage where the actor exposes it.
- Stop before another launch when the hop, deadline or approved usage budget is exhausted.
- Give correction work a smaller execution budget and no nested AI allowance by default.
- Warn when active task state exceeds approximately 12 KB and refuse another automatic actor launch above approximately 16 KB until compacted.
- Enforce a compact Work Loop hot path and a dispatcher-specific noninteractive route that loads exact state/evidence rather than the full interactive orientation path.
- Select model and reasoning tier only per invocation; never introduce a repository-wide model default.

Primary evidence:

- `concurrency/plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh:22-25`
- `concurrency/plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh:298`
- `main/plans/work-loop-v2-v0.2/incident-evidence/incident-1-2026-08-10/incident-1-established.md:48-69`
- `main/plans/work-loop-v2-v0.2/pre-launch-preparations/dispatcher-semi-agentic-readiness-fixes-2026-08-11.md:124-154`
- `main/audits/work-loop-v2-codex-usage-optimization-report-2026-08-13.md:152-225`

### R6 — Make the complete headless runtime a tested invariant

The durable-state implementation packages its state capability, but reliable dispatch also depends on actor binaries, authentication, Git identity, Work Loop command/skill/core, all transport helpers, writable evidence/lease locations and effective policy. A supported worktree must never borrow missing runtime files from canonical `main`.

Required change:

- Define the complete dispatcher runtime package once.
- Make dispatcher preflight and fixture builders consume that one definition.
- Check every required component for presence, readability/executability, expected location and symlink safety before actor launch.
- Check actor binary and authentication readiness, Git identity, state/owner/lease validity, and evidence-directory writability before paying for a model request.
- Add parity tests using an arbitrarily named linked worktree.
- Removing any required component must fail before actor launch with the exact missing prerequisite named.

Primary evidence:

- `concurrency/plans/work-loop-v2-v0.2/dispatcher-work-loop-harness-autonomy-improvement-report-2026-08-14.md:77-85`
- `concurrency/plans/work-loop-v2-v0.2/dispatcher-work-loop-harness-autonomy-improvement-report-2026-08-14.md:209-221`
- `durable-state/plans/work-loop-v2-v0.2/work-loop-v2-durable-state-system-implementation-plan-v0.1.md:424-455`

### R7 — State the nested-actor guarantee honestly and close the Codex-path gap

Attended Claude launches request direct `claude` and `codex` denial rules. The dispatcher’s Codex launch uses `codex exec --sandbox workspace-write` but has no symmetric direct process-launch denial. Observation is not prevention, and static direct-route denials are not full containment because wrapper or detached routes may evade them.

Required change for supervised reliability:

- Define the exact supported claim separately for Claude and Codex hops.
- Apply the strongest approved direct nested-actor refusal to both paths when possible.
- Record requested policy and observed descendants in the terminal result.
- If symmetric prevention cannot be enforced, expose that as an explicit accepted limitation; never report `nested=0` when the result is only unobserved.
- Keep approved nested work at zero by default. Any future exception needs an invocation count and the same whole-run deadline.

This closes misleading supervised claims. It does not solve full-lifetime containment; that deferred problem is recorded in Section 5.

Primary evidence:

- `concurrency/plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh:328-336`
- `concurrency/plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh:1650-1674`
- `concurrency/plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh:2376-2382`
- `concurrency/plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh:2470-2485`

### R8 — Make progress and interruption recovery legible

The current status view is strong on locks, owner declarations, state hashes, HEAD and liveness, but it does not yet provide a compact operational view. After a timeout, sleep, restart or missing result, the operator should not need to inspect raw logs to decide whether a model started, whether partial effects exist, or whether a lease may be cleared.

Required change:

- Show task, checkout, current turn/unit/stage, run id, hop count, elapsed/remaining deadline, top-level actor and observed descendant count, cumulative usage, last terminal outcome, evidence path and required operator action.
- Distinguish live, safely stale, conservatively pinned, partial-effect, and “model started but final result missing.”
- Never retry or clear the last category automatically.
- Permit session-scoped automatic recovery only for named zero-model preflight classes when state, HEAD, index and working tree are unchanged and the correction is deterministic. Permission decisions, timeouts, no-transition results, scope changes and partial effects remain operator gates.
- Document that `caffeinate -i` does not make closed-lid or arbitrary sleep behavior reliable on every Mac configuration.

Primary evidence:

- `concurrency/plans/work-loop-v2-v0.2/dispatcher-work-loop-harness-autonomy-improvement-report-2026-08-14.md:152-156`
- `concurrency/plans/work-loop-v2-v0.2/dispatcher-work-loop-harness-autonomy-improvement-report-2026-08-14.md:319-394`
### R9 — Prove the dispatcher itself with live representative trials

The dispatcher controller suite is extensive but uses simulated actors. Durable-state operational proofs and autonomy-authority trials prove their own surfaces. The autonomy plan explicitly runs its trials through the attended carrier, so those results cannot establish multi-hop dispatcher reliability.

After R1–R8, run the following in clean dedicated worktrees through the actual dispatcher:

1. A normal bounded implementation repeated at least three times.
2. A deliberate permission denial, honest classification, explicit operator-approved `acceptEdits`, and successful resume inside the dispatcher.
3. A Codex non-pass outside the correction envelope that produces `blocked/operator`, an actionable handoff packet, an explicit Patrik decision, full revalidation and successful resume.
4. One pre-authorized correction cycle followed by Codex reassessment; a second non-pass must stop for Patrik.
5. A controlled actor timeout or termination after partial effects, followed by deterministic status and recovery with no automatic retry.
6. A missing-final-result scenario that becomes a durable blocker rather than false success.
7. An arbitrarily named linked-worktree run proving complete local runtime and Git identity.
8. Regression of the shared lease and durable-state seams after all dispatcher changes.

Each trial must record exact task/checkout, permission mode, actor/session identifiers, hop and deadline data, state and HEAD before/after, changed paths, usage, terminal result, capture path and operator intervention. One success is not repeat reliability.

Primary evidence:

- `main/plans/work-loop-v2-v0.2/pre-launch-preparations/dispatcher-semi-agentic-readiness-fixes-2026-08-11.md:196-228`
- `autonomy/plans/work-loop-v2-v0.2/work-loop-v2-autonomy-authority-capability-implementation-plan-v0.1.md:1374-1420`

## 5. Deferred work for possible unattended or walk-away reliability

The supervised semi-autonomous target does not require the work in this section. Unattended mode should remain disabled or explicitly experimental. These items are retained only to prevent the supervised release from being misrepresented as walk-away autonomy and to define the entry conditions for any future unattended programme.

### U1 — Full-lifetime descendant containment

The current controller deliberately proves that a double-forked descendant which creates a new session/process group and closes every inherited descriptor can survive teardown. The dispatcher can truthfully say only that no descendant reachable by group, ancestry or inherited descriptor remains. Releasing a lease while an invisible descendant continues would violate the one-writer guarantee.

Required outcome:

- Run actors inside an isolation/supervision boundary that owns their complete process lifetime, or mechanically prevent them from creating untracked processes.
- On timeout or interruption, every descendant is either observed gone or the lease remains pinned and checkout reuse is refused.
- The mechanism must never kill an unrelated process.
- Change the current escapee test from “survives with a scoped claim” to a fail-capable proof of the chosen containment guarantee.

This may require a launchd-job, cgroup-equivalent, sandbox supervisor, virtualized/container boundary or another creation-time mechanism. Ordinary ancestry polling is not sufficient.

Primary evidence:

- `concurrency/plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh:1245-1314`
- `concurrency/plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh:2142-2198`
- `main/plans/work-loop-v2-v0.2/unattended-operation-plan-v0.2.md:227-320`

### U2 — Effective isolation and host policy proof

Requested settings are not enough. Array-valued policy may widen across settings scopes, and the contained profile has only been measured on a particular host/configuration. The release host must prove the effective child policy and negative effects, including network, credentials, writes, push, hooks/connectors and scope widening.

Required outcome:

- Use a clean, dedicated worktree and branch.
- Measure effective policy from inside the launched child.
- Prove no ambient hook, tracked log, external path, push or unrelated checkout is touched.
- Either prevent settings widening through an operator-managed policy source or record the residual as an explicit operator acceptance.
- Use an always-on host or supported awake configuration for genuinely unattended work; do not claim universal lid-close reliability.

Primary evidence:

- `main/plans/work-loop-v2-v0.2/unattended-operation-plan-v0.2.md:455-481`
- `main/plans/work-loop-v2-v0.2/unattended-operation-plan-v0.2.md:609-638`

### U3 — Bounded walk-away proof and separate release decision

Only after U1–U2 and all supervised gates pass should the dispatcher run a bounded walk-away pilot. It must use a hard whole-run clock, zero nested actors, a clean dedicated worktree, no push, durable evidence, and a terminal state of valid completion or one genuine operator decision. Several later representative unattended runs are required before claiming repeat reliability.

Primary evidence:

- `main/plans/work-loop-v2-v0.2/unattended-operation-plan-v0.2.md:120-140`
- `main/plans/work-loop-v2-v0.2/unattended-operation-plan-v0.2.md:567-580`

## 6. Implementation-efficiency fixes that should travel with the package

These do not independently create safety, but leaving them open recreates the slow and failure-prone implementation pattern that produced the August 14 report:

- Add stable case filters to dispatcher and carrier controller suites, while retaining one synchronous final full-suite gate.
- Let one bounded implementation unit produce red, implement, and focused green when scope and authority are already settled.
- Remove pointer-only commits that exist only to record the identifier of the preceding handoff commit.
- Keep full-suite processes attached; no required verification may continue after the actor returns.
- Establish retention/pruning for refusal records and raw captures.
- Fix known code-quality edges before release: the unassigned `LOCK_KEY` run-id reference, holder-neutral stale wording, dead-holder status accuracy, unwritable shared-evidence-root behavior, and any reproducible carrier timeout flake.

Primary evidence:

- `concurrency/plans/work-loop-v2-v0.2/dispatcher-work-loop-harness-autonomy-improvement-report-2026-08-14.md:87-124`
- `concurrency/plans/work-loop-v2-v0.2/dispatcher-work-loop-harness-autonomy-improvement-report-2026-08-14.md:223-291`
- `concurrency/plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh:788-791`

## 7. Recommended implementation order

### Change set A — Close deterministic transport truth

1. Add the universal atomic result schema.
2. Add the exact external-evidence handshake.
3. Make missing evidence a blocker handback.
4. Expand read-only status and interruption classification.

### Change set B — Remove execution multipliers

1. Delete retry after a started model request.
2. Change the normal prepared path to three hops.
3. Add deadline and usage circuit breakers.
4. Add state-size and hot-path limits.
5. Add focused test filters and eliminate pointer-only commits.

### Change set C — Complete dispatcher admission and authority transport

1. Add explicit attended `default | acceptEdits` transport.
2. Define and preflight the complete headless runtime package.
3. Close or explicitly bound the Codex-path nested-actor-control gap.
4. Preserve the shared lease, validator and autonomy semantics without introducing fallback systems.

### Change set D — Prove supervised reliability

1. Run the live dispatcher trial matrix in Section 4 R9.
2. Correct only demonstrated material failures.
3. Run the final controller, shared-lease, validator and owner gates synchronously.
4. Obtain an independent review and make an explicit supervised adopt/shrink/stop decision.

### Change set E — Freeze the unattended boundary

1. Keep unattended mode disabled or explicitly experimental after the supervised release.
2. Document that Gate SA does not satisfy full-lifetime containment or walk-away proof.
3. Open a separate architecture task only if Patrik later decides unattended operation has enough value to justify U1–U3.

## 8. Acceptance gates

### Gate SA — Reliable supervised semi-autonomous dispatcher

All statements must be proven:

- Every exit produces one durable, atomic terminal result with truthful `actor_started` and before/after facts.
- Missing evidence and zero-without-transition stop as blockers, never as completion.
- The normal implementation-assessment-closure path completes without Patrik manually carrying turns between Claude and Codex.
- An operator-approved permission change resumes inside the dispatcher without `bypassPermissions`.
- No started model request is automatically retried.
- A normal no-correction prepared task completes within three hops or stops honestly; the optional correction path stays within its separately declared one-correction/one-reassessment ceiling.
- At most one explicitly pre-authorized correction cycle runs automatically; a second non-pass stops for Patrik.
- Deadline, hop, usage, correction and state-size controls prevent another disproportionate run.
- An arbitrary supported worktree passes only with its complete local runtime and Git identity.
- Status explains liveness, partial effects, last result and safe recovery without raw-log reconstruction.
- Every non-routine stop creates one legal `blocked/operator` record and one actionable handoff packet; no actor launches while that state remains blocked.
- Resume requires Patrik's explicit decision, a new run identity and revalidation of state, ownership, leases, Git facts, partial effects, runtime and budgets.
- Claude and Codex nested-actor claims match their actual enforcement and observation.
- Three repeated normal live dispatcher runs plus permission, operator-takeover/resume, one-correction, interruption, missing-result and linked-worktree trials pass.
- The full regression suite remains green and no concurrency, durable-state or autonomy-authority invariant regresses.

Passing Gate SA justifies **Reliable supervised semi-autonomous dispatcher**.

### Gate U — Optional future unattended release

Gate SA must pass, plus:

- No actor descendant can escape the run's accounting and stop boundary.
- Unknown teardown pins the lease and blocks checkout reuse.
- Unrelated processes are never terminated.
- Effective containment policy and dedicated-worktree isolation are measured on the release host.
- A bounded walk-away pilot and later representative runs end predictably with durable evidence and no push.
- An independent review approves the exact unattended operating envelope.

Gate U is not part of the current implementation target. If Patrik later chooses to pursue it, passing Gate U would justify **Reliable for the specifically approved unattended envelope**. It would not justify autonomous project prioritization or unrestricted external action.

## 9. Non-goals

Do not solve this closure package by adding:

- a scheduler, queue, registry, database, agent manager, heartbeat service or second state system;
- automatic task selection, project prioritization or strategic routing;
- full unattended or walk-away release as part of the supervised semi-autonomous implementation;
- automatic worktree creation, merge, push, deployment, branch deletion or destructive cleanup;
- broader permissions, longer timeouts or model farms as substitutes for deterministic evidence;
- a merged attended-carrier/unattended-dispatcher command surface;
- a dispatcher rewrite or implementation-language migration before the current behavioral contract is proven.

The smallest reliable design remains one bounded task, one canonical durable state record, shared leases, deterministic transport evidence, bounded actors and explicit operator gates.

## Final assessment

Assuming concurrency Phase 1, durable state and autonomy authority are all completed and integrated, the dispatcher will have a sound concurrency, state and semantic-authority foundation. The remaining work is narrower but still material:

1. permission transport;
2. universal results and evidence handshakes;
3. retry, hop, deadline, usage and context controls;
4. complete headless runtime preflight;
5. truthful nested-actor controls, actionable operator takeover and safe resume;
6. live dispatcher-specific semi-autonomous adoption proof.

These six items are a moderate, bounded reliability implementation. Completing and proving them is enough to call the dispatcher reliable for the intended supervised semi-autonomous role: Claude and Codex continue together while the task stays inside its approved corridor, then stop safely and return control to Patrik when it does not.

Full-lifetime containment and walk-away proof remain the genuinely hard architectural problem. They are explicitly deferred, do not block the target release, and should be opened only as a separate future programme if unattended operation later becomes valuable enough to justify them.

The governing operational rule is:

> Continue automatically while state, evidence, authority and execution remain valid. On any ambiguity, unexpected effect or unapproved decision, preserve the evidence, enter `blocked/operator`, stop safely and hand control to Patrik.
