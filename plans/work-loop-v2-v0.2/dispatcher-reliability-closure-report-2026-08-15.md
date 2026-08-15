# Work Loop v2 dispatcher reliability closure report

**Date:** 2026-08-15  
**Purpose:** Define everything that still needs to be fixed in the dispatcher after the concurrency Phase 1, durable-state system, and autonomy-authority capability are finished and integrated.  
**Decision:** Completing those three implementations makes the dispatcher materially safer, but does not by itself prove reliable dispatcher operation. A bounded transport-reliability package remains for supervised use. Safe unattended or walk-away operation additionally requires full-lifetime process containment and its own release proof.

This report is self-contained and is intended to become the planning input for the next dispatcher-focused implementation. It does not authorize changes, reopen the three existing plans, or treat their current unfinished worktree state as completed evidence.

Source citations use four checkout prefixes: `main/` is `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/`; `concurrency/` is `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-concurrency-fix-2/`; `durable-state/` is `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-durable-state/`; and `autonomy/` is `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-autonomy-authority/`. Line citations identify the inspected 2026-08-15 versions. Active worktree records support present-state observations only; the completed outcomes in Section 1 remain explicit assumptions.

## 1. Assumptions and reliability definitions

This report deliberately assumes all of the following future conditions are true:

1. **Concurrency Phase 1 is complete and merged.** Shared task and checkout leases, cross-transport contention, early exit-17 refusal evidence, genuine case 23, genuine case 24, final assessment, and integration have all passed.
2. **The durable-state implementation is complete and merged exactly to its frozen plan.** One canonical validator owns lifecycle semantics; records use explicit `active | blocked | closed` status; ownership and closure are crash-safe; every consumer uses the validator; legacy session-marker/session-note coupling is removed; the capability is complete-or-unavailable; and the required recovery, migration, worktree and representative end-to-end proofs have passed.
3. **The autonomy-authority implementation is complete and merged exactly to its final accepted plan.** Semantic authority, capability envelopes, escalation boundaries, correction authority, operator gates, attended-carrier scenario evidence, and real Standard-task evidence have passed.

The terms used below are intentionally separate:

- **Reliable supervised dispatcher:** a human may launch and monitor the dispatcher, but does not need to reconstruct state, switch to an interactive bypass, or guess what happened. The dispatcher stops only for a genuine decision, permission, risk, partial effect or integration gate.
- **Reliable unattended dispatcher:** the operator may walk away. The dispatcher must also contain the full lifetime of everything its actors create, survive interruption safely, prove its effective isolation on the release host, and return one durable, trustworthy result.

Passing the supervised bar does not imply the unattended bar.

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

## 3. Remaining blockers for reliable supervised dispatcher operation

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
- Require a finite whole-run deadline for unattended use; choose and record an explicit deadline for supervised multi-hop use.
- Parse and record per-hop and cumulative input, cached-input, output and reasoning usage where the actor exposes it.
- Stop before another launch when the hop, deadline or approved usage budget is exhausted.
- Give correction work a smaller execution budget and no nested AI allowance by default.
- Warn when active task state exceeds approximately 12 KB and refuse unattended continuation above approximately 16 KB until compacted.
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

This closes misleading supervised claims. It does not solve full-lifetime containment; that is the unattended-only blocker in Section 4.

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
3. A controlled actor timeout or termination after partial effects, followed by deterministic status and recovery with no automatic retry.
4. A missing-final-result scenario that becomes a durable blocker rather than false success.
5. An arbitrarily named linked-worktree run proving complete local runtime and Git identity.
6. Regression of the shared lease and durable-state seams after all dispatcher changes.

Each trial must record exact task/checkout, permission mode, actor/session identifiers, hop and deadline data, state and HEAD before/after, changed paths, usage, terminal result, capture path and operator intervention. One success is not repeat reliability.

Primary evidence:

- `main/plans/work-loop-v2-v0.2/pre-launch-preparations/dispatcher-semi-agentic-readiness-fixes-2026-08-11.md:196-228`
- `autonomy/plans/work-loop-v2-v0.2/work-loop-v2-autonomy-authority-capability-implementation-plan-v0.1.md:1374-1420`

## 4. Additional blockers for unattended or walk-away reliability

The supervised package above is not enough for unattended release.

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

## 5. Implementation-efficiency fixes that should travel with the package

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

## 6. Recommended implementation order

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

1. Run the live dispatcher trial matrix in Section 3 R9.
2. Correct only demonstrated material failures.
3. Run the final controller, shared-lease, validator and owner gates synchronously.
4. Obtain an independent review and make an explicit supervised adopt/shrink/stop decision.

### Change set E — Decide unattended architecture separately

1. Select or reject a full-lifetime containment mechanism.
2. Prove effective isolation on the release host.
3. Run the bounded walk-away proof.
4. Make a separate unattended release decision.

## 7. Acceptance gates

### Gate S — Reliable supervised dispatcher

All statements must be proven:

- Every exit produces one durable, atomic terminal result with truthful `actor_started` and before/after facts.
- Missing evidence and zero-without-transition stop as blockers, never as completion.
- An operator-approved permission change resumes inside the dispatcher without `bypassPermissions`.
- No started model request is automatically retried.
- A normal prepared task completes within three hops or stops honestly.
- Deadline, hop, usage, correction and state-size controls prevent another disproportionate run.
- An arbitrary supported worktree passes only with its complete local runtime and Git identity.
- Status explains liveness, partial effects, last result and safe recovery without raw-log reconstruction.
- Claude and Codex nested-actor claims match their actual enforcement and observation.
- Three repeated normal live dispatcher runs plus permission, interruption, missing-result and linked-worktree trials pass.
- The full regression suite remains green and no concurrency, durable-state or autonomy-authority invariant regresses.

Passing Gate S justifies **Reliable for supervised semi-agentic use**.

### Gate U — Reliable unattended dispatcher

Gate S must pass, plus:

- No actor descendant can escape the run's accounting and stop boundary.
- Unknown teardown pins the lease and blocks checkout reuse.
- Unrelated processes are never terminated.
- Effective containment policy and dedicated-worktree isolation are measured on the release host.
- A bounded walk-away pilot and later representative runs end predictably with durable evidence and no push.
- An independent review approves the exact unattended operating envelope.

Passing Gate U justifies **Reliable for the approved unattended envelope**. It does not justify autonomous project prioritization or unrestricted external action.

## 8. Non-goals

Do not solve this closure package by adding:

- a scheduler, queue, registry, database, agent manager, heartbeat service or second state system;
- automatic task selection, project prioritization or strategic routing;
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
5. truthful nested-actor controls and status/recovery;
6. live dispatcher-specific adoption proof;
7. full-lifetime containment and walk-away proof if unattended release is desired.

Items 1–6 are a moderate, bounded reliability implementation. Completing and proving them is enough to call the dispatcher reliable for supervised work. Item 7 is the genuinely hard architectural problem and should remain a separate unattended-release programme.
