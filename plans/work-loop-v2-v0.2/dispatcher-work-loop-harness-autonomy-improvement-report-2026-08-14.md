# Dispatcher, Work Loop v2, and Harness Autonomy Improvement Report

**Date:** 2026-08-14  
**Case studied:** Phase 1 implementation of cross-transport concurrency and task-aware worktree preparation  
**Checkout:** `ai-resources-concurrency-fix-2`  
**Branch:** `session/2026-08-14-concurrency-fix-2`  
**Status of the case when this report was written:** implementation and controller validation are substantially complete; live case 23 behaved correctly but its evidence handoff failed; live case 24 and final closure remain.

## Executive conclusion

The concurrency implementation itself is technically strong. The shared lease worked in the real cross-transport contention test: the unattended dispatcher refused with exit 17 before launching a second actor and correctly identified the attended carrier as the holder. The controller suites also reached green, including the dispatcher at 517/0.

The implementation process, however, was far too slow, expensive, and operator-intensive. The main problem was not that the approved concurrency plan was impossible. The problem was a mismatch between a strict semantic workflow and transport tooling that is not yet fully self-describing, worktree-complete, or durable on every exit path. Fresh model processes repeatedly had to reconstruct orchestration from large instruction files, discover packaging and fixture assumptions one at a time, run large suites, and stop for recovery when evidence was unavailable or a process ended without updating the state file.

The clearest example is live case 23. The dispatcher did exactly the safe thing and refused immediately, but it acquired the lease before initializing `--log-dir`. Therefore the expected dispatcher log was never created. Claude waited for a file that could never appear, spent 205 seconds and $1.86, then exited without changing the state file. The harness correctly classified that as exit 22, `NO_TRANSITION`, but correct classification came only after the avoidable model run had already been paid for.

The recommended response is not a new scheduler, agent manager, registry, or service. It is a bounded reliability programme across the existing dispatcher, Work Loop command, and attended harness:

1. make every dispatcher invocation durable from its first instruction, including preflight and lease refusals;
2. make transport results machine-readable and consistent across both couriers;
3. make every supported worktree carry and verify the complete runtime dependency package;
4. collapse predictable red/fix/green work into one bounded unit instead of multiple model handoffs;
5. remove self-referential pointer commits and reduce repeated full-suite execution;
6. compress the always-loaded Work Loop instructions and bound state-file growth;
7. prohibit automatic retry after a model request has started, tier routine model use explicitly, and enforce usage budgets;
8. improve status and recovery reporting so the operator sees progress and only intervenes for real decisions.

## 1. What happened in this implementation

### 1.1 What worked

- A shared repository-rooted lease helper was implemented and used by both the unattended dispatcher and attended carrier.
- The attended carrier gained fail-closed repository-depth ownership admission before actor launch.
- Pinning and pin-result reporting were corrected for both transports.
- Holder-aware refusal messages were added, so a dispatcher can distinguish an attended carrier from another dispatcher.
- The broad controller gate eventually passed:
  - shared lease helper: 67/0;
  - owner helper: 92/0;
  - attended carrier: 371/0;
  - dispatcher: 517/0 after the final holder-label correction.
- In the genuine case-23 contention, the unattended dispatcher returned exit 17 and printed:

  ```text
  STOP [17] an attended carry holds task work-loop-v2-cross-transport-concurrency-phase-1
  ```

  It did so before actor launch. This is the intended safety behaviour.

### 1.2 What remains incomplete

- Case 23 has not been accepted because the losing dispatcher did not create durable run evidence under the requested log directory.
- The attended Claude actor therefore left the state file byte-identical, and the harness stopped at exit 22.
- The genuine fan-out-two validation, case 24, has not run.
- The final limitations and rollback record has not been written.

### 1.3 Measured execution cost

The local `logs/harness-runs/*work-loop-v2-cross-transport-concurrency-phase-1.claude.out` artifacts record:

| Measure | Observed value |
|---|---:|
| Claude invocations | 33 |
| Claude model turns | 1,022 |
| Summed Claude API duration | 10,564.91 seconds, about 2.93 hours |
| Claude cost recorded in artifacts | $102.08 |
| Cache-read tokens | 98,119,668 |
| Cache-creation tokens | 3,337,247 |
| Output tokens | 783,815 |
| Error-marked Claude runs | 6 |
| Commits from initial Phase 1 red cases through current HEAD | 41 |
| Commit-pointer-only commits | 16 |

These figures understate the total cost because they exclude Codex usage, operator time, shell/controller execution, and any work before the recorded Claude artifacts. Summed API duration is not identical to elapsed wall time and may include overlapping work, but it accurately shows the amount of model execution purchased.

The largest individual Claude artifacts reached 52–67 model turns, roughly 10–14 minutes, 5–7 million cache-read tokens, and $5–$7 each. Two runs approached the 900-second transport timeout. This is not a lean bounded-unit profile.

## 2. Why it was slow

### 2.1 Runtime packaging was not defined as one invariant

The new shared helper became a dependency of the dispatcher, carrier, and ownership fixtures, but each fixture builder carried its own copy logic. The owner suite initially fell from its 92/0 baseline to 86/6 because its fixture repositories did not package the new lease helper. Commit `e859d377` restored 92/0 with a two-line fixture correction, while explicitly recording that the dependency knowledge was now duplicated.

The carrier ownership work exposed the same class of problem in a different form. Once the real ownership helper was packaged, an older linked-worktree fixture became ambiguous by design. The brief had assumed that adding the helper and preserving every old assertion were simultaneously possible. Claude correctly handed back the false premise at `eb17cb49`, after which the fixture semantics had to be reframed and repaired.

This is related to an earlier Work Loop defect recorded in `core-resolver-worktree-defect-report-2026-08-09.md`: the resolver once inferred repository identity from the checkout name and rejected supported linked worktrees unless they resembled the canonical `ai-resources` directory. That resolver has since been corrected, but the same architectural lesson remains: a worktree must be treated as a complete, first-class runtime location. Falling back to `main`, relying on its files, or copying an incomplete dependency set is not valid.

### 2.2 Too many units were split at evidence boundaries instead of deliverable boundaries

Several units deliberately stopped after producing red evidence, then required a new brief and fresh actor to diagnose or correct the same bounded behaviour. This preserved role separation, but the granularity became excessive:

- owner-suite red, diagnosis, and packaging repair became separate units;
- carrier ownership red, false-premise handback, and implementation became separate units;
- pin behaviour was split into helper, carrier, and dispatcher recoveries;
- the broad regression gate discovered one stale fixture, which required another unit;
- refusal wording required a further red/correction/green sequence;
- timeout and asynchronous-suite stops required additional operator-approved recoveries.

Failing-first evidence is valuable. A separate model process for every predictable red-to-green transition is not. When the behaviour, files, and correction authority are already bounded, one implementation unit should normally produce the failing case, apply the correction, run the focused green case, and hand back once.

### 2.3 Full controller suites were too expensive to use as routine local feedback

The dispatcher suite grew to 517 assertions. It was run repeatedly while stale fixture setup and message wording were still being corrected. One full green attempt was launched asynchronously and returned before completion; another later ran in the foreground to produce the accepted 517/0 result.

The final full suite is necessary. Repeated full-suite execution during local correction is not. The scripts need stable case filters or named slices so an actor can run the one affected behaviour first and reserve the complete suite for the single broad gate.

### 2.4 The Work Loop hot path is large on every fresh actor

Current instruction sizes are:

| Actor-facing runtime | Size |
|---|---:|
| Codex Work Loop skill | 64,971 bytes |
| Claude Work Loop command | 21,255 bytes |
| Shared executable core | 24,476 bytes |
| Codex hot path: skill plus core | 89,447 bytes |
| Claude hot path: command plus core | 45,731 bytes |

Every courier hop starts a fresh model process. The task state then adds another 8,369 bytes in the current case, plus repository instructions and tool definitions. This explains why even short visible prompts generated millions of cache-read tokens across a long implementation. Shorter chat messages alone will not solve this; the mandatory runtime itself must become smaller.

### 2.5 The state and commit protocol created self-reference ceremony

The history from the initial red commit through current HEAD contains 41 commits, of which 16 exist only to record a previous commit pointer in the task state. This is a circularity created by asking a commit to contain its own identifier: the identifier does not exist until after the commit, so a second commit records it.

Those pointer commits add history noise, tool calls, state edits, and opportunities for failure without changing implementation behaviour. Git and the carrier already know the HEAD before and after each hop. The task state does not need a self-referential hash.

### 2.6 The live validation had no deterministic producer-consumer handshake

Case 23 required two real top-level transports. The attended carrier held the leases while Codex separately launched the dispatcher. Claude was instructed to wait for a dispatcher log. There was no deterministic completion marker shared between the external producer and the waiting actor.

The resulting wait also produced a misleading observation: Claude's process search matched the text of its own polling command because that command contained `dispatch.sh`. Claude noticed and rejected the self-match, which was good reasoning, but the polling itself should never have been necessary.

### 2.7 Early dispatcher stops occur before logging exists

This is the immediate confirmed dispatcher defect.

In `dispatch.sh`, `acquire_lock` runs at approximately line 1288. The requested/default log directory is not created until approximately lines 1424–1430, and `RUN_LOG` is not initialized until approximately lines 1454–1455. Therefore any lease refusal at exit 17 happens before the dispatcher has a durable log destination. The `die` helper only appends when `RUN_LOG` already exists.

The command-line refusal was correct, but `--log-dir` did not mean “log this invocation”; it only meant “log this invocation if it survives early admission.” That distinction was undocumented and contradicted the live brief's evidence expectation.

### 2.8 A clean model exit can still be operationally incomplete

The case-23 Claude process exited with product-level success after 205 seconds, but its final answer said it was still waiting. It left the state file unchanged. The attended harness correctly compared before and after facts and returned exit 22, `NO_TRANSITION`.

This is a good harness safeguard and a poor actor completion contract. The model should never finish a Work Loop invocation while claiming an internal wait is still running. When evidence does not arrive within its bound, it must write a blocker and hand back, or the transport must terminate the wait and produce the structured stop itself.

### 2.9 Automatic retry and generous hop defaults still permit avoidable usage

The dispatcher source still contains one automatic retry when an actor exits nonzero and repository facts appear unchanged. It also defaults to four hops. Repository unchanged does not prove that no model request started; a failed process may already have consumed its full context and reasoning budget.

The existing usage audit reached the same conclusion independently: automatically retry only when logs prove a zero-token preflight failure, and use three hops for the normal prepared-brief sequence.

### 2.10 Progress was not legible to the operator

The dispatcher `--status` output is strong on locks, owner declarations, state hashes, HEAD, and run liveness. It does not provide a compact run-progress view: current unit label, last accepted outcome, hop count, elapsed time, cumulative usage, last stop reason, and evidence location.

As a result, the operator repeatedly had to ask whether implementation was progressing, whether work was being accepted blindly, whether the process was ceremonial, and how much remained. That is not merely a communication issue. A system intended to reduce operator attention must make its progress and stop reason visible without requiring the operator to reconstruct them from commits and raw logs.

## 3. Required fixes

### P0 — Fix before repeating live case 23

#### Fix 1 — Initialize dispatcher evidence before lease acquisition

**Owner:** dispatcher  
**Problem closed:** early exit 17 produces no run log.

Required behaviour:

- Resolve and validate `--log-dir` before any mutating admission step.
- Create a unique run log before acquiring either lease.
- Record task, checkout, requested mode, run id, initial state hash, and initial HEAD.
- On every exit, including usage, ownership, lease, containment, and actor-preflight refusals, append one final machine-readable `RESULT` line.
- For exit 17, record the contested resource, holder program, holder task/checkout, `actor_started=false`, and `state_changed=false`.
- Preserve `--status` as read-only: status must continue to take no lease and write no log.

Regression proof:

1. Hold a real shared lease.
2. Invoke the dispatcher with an explicit `--log-dir`.
3. Require exit 17.
4. Require exactly one new run log with the holder identity and `actor_started=false`.
5. Require no actor capture, unchanged state bytes, unchanged HEAD, and no source changes.

#### Fix 2 — Standardize one transport result schema

**Owner:** dispatcher and attended harness  
**Problem closed:** automation and operators must parse different prose and infer whether an actor started.

Both programs should end with the same compact fields, while keeping their intentional command surfaces separate:

```text
RESULT transport=<dispatch|carry> outcome=<...> code=<n> task=<id>
       stage=<preflight|lease|ownership|actor|postcheck>
       actor_started=<true|false> state_changed=<true|false>
       head_changed=<true|false> log=<path> capture=<path-or-none>
```

The schema is reporting, not a new state system. The Work Loop state file remains the semantic interface. The result line makes mechanical facts available without another model reading prose.

#### Fix 3 — Add a deterministic external-evidence handshake

**Owner:** dispatcher/harness validation surface  
**Problem closed:** one actor polls for another transport's output with no known completion marker.

For cross-transport validation, the producer must write its run log and final `RESULT` atomically. The consumer waits only for that exact artifact, with a deadline shorter than its own actor timeout. It must not use process-name polling. If the artifact is absent at the deadline, the Work Loop command records a blocker and hands back instead of returning a narrative saying it is still waiting.

This can be implemented inside the existing validation harness. It does not justify a general scheduler or nested model launch.

#### Fix 4 — Make worktree runtime completeness a tested invariant

**Owner:** dispatcher, carrier, and their fixture builders  
**Problem closed:** supported worktrees or test repositories omit required helpers or depend on canonical `main`.

Required behaviour:

- Define the required runtime package once: Work Loop command/skill resources, executable core, owner helper, lease helper, and any transport-local sandbox resources.
- Make fixture builders and worktree preflights consume that one definition rather than maintaining separate copy lists.
- Fail before actor launch when a required file is missing, unreadable, symlinked unexpectedly, or resolved outside the bound checkout.
- Never fall back to the canonical main checkout for a task bound to another worktree.
- Add parity tests for an arbitrarily named linked worktree, not only a sibling with a familiar name.
- Test both “complete package proceeds” and “one dependency omitted fails before actor launch.”

### P1 — Reduce time, tokens, and unnecessary handoffs

#### Fix 5 — Make one implementation unit cover red, correction, and focused green

**Owner:** Work Loop v2 command and Codex skill  
**Problem closed:** predictable local work becomes several fresh model processes.

Default rule:

- When objective, scope, files, and authority are settled, one Implementation-mode unit contains one behaviour, its failing case, the implementation, and its focused regression proof.
- Split after red only when the failure falsifies a premise, changes the causal diagnosis, expands scope, or requires an operator decision.
- Do not create a separate discovery unit merely to classify a bounded fixture failure that the implementing unit is already authorized to correct.
- Preserve one independent Codex assessment after the completed unit.

This keeps test-first discipline while removing avoidable transport turns.

#### Fix 6 — Add stable case filters to large controller suites

**Owner:** dispatcher and carrier test harnesses  
**Problem closed:** a 350–517 assertion suite is repeatedly used for local feedback.

Required behaviour:

- Provide named case or section filters with deterministic assertion counts.
- Run the focused affected cases during implementation.
- Run each complete surrounding suite once at the broad regression gate.
- Never accept only a focused slice as final release evidence.
- Keep foreground execution for required evidence; an actor must not return while its required suite is still running.

#### Fix 7 — Remove pointer-only commits

**Owner:** Work Loop v2 evidence and closing contract  
**Problem closed:** 16 of 41 commits record only a prior commit identifier.

Required behaviour:

- The actor commits implementation and state together once.
- The carrier/dispatcher records `head_before` and `head_after` in its run evidence.
- The state file refers to “the commit containing this handoff” or to changed paths and evidence; it does not embed its own commit hash.
- Codex reads the repository fact when assessment needs the exact hash.
- A second commit is allowed only when it changes task meaning or repository content, not to complete self-reference.

#### Fix 8 — Compact the always-loaded Work Loop runtime

**Owner:** Work Loop v2 command, Codex skill, and executable core  
**Problem closed:** every fresh hop loads 45–89KB of Work Loop instructions before task evidence.

Required direction:

- Keep a compact executable contract containing roles, state schema, transition rules, safety stops, evidence rules, and courier entry points.
- Move rationale, historical incidents, long examples, inventories, and rare recovery detail into conditional references.
- State each invariant once and link to it from both actors.
- Retain a mechanically enforced size budget. The existing usage audit recommends 24KB combined for the Codex hot path as an initial ceiling.
- Add a dispatcher-specific noninteractive route that reads the exact state file and named evidence, not the general interactive routing and reorientation material unless a material context change is marked.

#### Fix 9 — Bound the active state file

**Owner:** Work Loop v2 command and Codex skill  
**Problem closed:** every hop rereads growing narrative and prior-unit detail.

Required behaviour:

- Keep only the current objective and scope, current unit, last material result, current blocker, next action, and compact evidence pointers.
- Do not paste full test logs, diffs, resolved investigation, or chronological narration.
- Replace the previous unit's detailed proof with a short accepted result when continuing.
- Warn around 12KB and stop unattended launch around 16KB until the state is compacted, as already recommended by the usage audit.
- Preserve decisions, negative constraints, and accepted limitations; remove only superseded narration.

The current state is 8.4KB, so it has not crossed the proposed threshold, but the case shows how quickly repeated evidence can grow.

#### Fix 10 — Remove automatic retry after any live model request

**Owner:** dispatcher  
**Problem closed:** an unchanged repository can still hide a fully charged failed request.

Required behaviour:

- Persist whether a model request began, plus its session/run identifier and usage event when available.
- Retry automatically only for proven pre-model failures such as binary-not-found or invalid launch configuration.
- If a model request began, stop and report; any next attempt is a new explicit recovery.
- Change the prepared-brief default from four hops to three. Require an explicit override for a known recovery shape.

#### Fix 11 — Tier models explicitly and enforce usage budgets

**Owner:** dispatcher and carrier invocation policy  
**Problem closed:** routine work inherits expensive actor settings and can consume many turns without a visible budget.

Required behaviour:

- Pass model and reasoning tier explicitly per invocation; do not set a repository-wide model default.
- For Codex, follow the existing usage report's recommendation: routine assessment on Terra/medium, with Sol/high only for explicit high-consequence exceptions.
- Define an equivalent per-unit tier policy for Claude instead of silently inheriting the most expensive available model for fixture edits and routine test execution.
- Record model, effort, turns, input/cache/output usage, duration, and cost in the run result.
- Stop before another actor launch when the run's approved hop or usage budget is exhausted.
- Do not treat shorter visible answers as the primary token fix; repeated input dominates.

### P2 — Reduce operator attention and improve recovery

#### Fix 12 — Add a compact, factual progress view

**Owner:** dispatcher `--status` and carrier terminal summary  
**Problem closed:** the operator cannot tell whether the task is progressing or looping.

Without interpreting project strategy or inventing a percentage, status should show:

- task and checkout;
- current unit label and turn;
- HEAD and whether the state is uncommitted;
- current transport and holder;
- hops completed and allowed;
- elapsed and remaining deadline;
- cumulative actor usage;
- last terminal result and exit code;
- exact run log and actor capture paths;
- whether operator action is required, and why.

This is derived status, not a second semantic state file.

#### Fix 13 — Make no-transition an actor-facing contract, not only a post-hoc guard

**Owner:** Work Loop v2 Claude command and attended harness  
**Problem closed:** the model can spend minutes and then exit successfully without handing back.

Required behaviour:

- The Claude command must say that every normal invocation ends in exactly one state transition: `claude → codex`, `claude → operator`, or the defined read-only identity refusal.
- Missing external evidence becomes a recorded blocker before the actor exits.
- Required foreground commands may not be left running when the actor returns.
- The harness keeps exit 22 as a hard postcondition guard.
- The harness summary distinguishes “actor said success” from “state transition completed.”

#### Fix 14 — Preflight the exact headless environment

**Owner:** carrier and dispatcher  
**Problem closed:** interactive login or canonical-checkout success is mistaken for headless worktree readiness.

Before a model launch, verify from the bound checkout and the exact subprocess environment:

- actor binary exists and is executable;
- required authentication is available to that headless invocation;
- required Git identity/config is readable;
- runtime dependency package is complete;
- requested log directory is writable;
- containment can initialize when unattended;
- state identity and ownership checks pass.

Preflight should consume no model tokens. It must not copy credentials, consult `main`, or weaken unattended containment.

#### Fix 15 — Define sleep/interruption recovery honestly

**Owner:** dispatcher lifecycle handling  
**Problem closed:** closing a laptop lid can suspend or terminate practical progress despite `caffeinate`.

- Continue using `caffeinate -i` for unattended runs, but document that it does not make lid-close operation reliable on every Mac configuration.
- Persist the last completed stage before actor launch and after actor termination.
- On wake or restart, `--status` must distinguish a live run, a dead stale lease, a pinned lease, and a run whose model request started but whose final result is missing.
- Never auto-retry the last category.
- For genuinely unattended long work, use an always-on host or keep the laptop in a supported awake configuration.

#### Fix 16 — Allow session-scoped approval only for mechanical recovery classes

**Owner:** Work Loop courier policy  
**Problem closed:** repeated approval prompts for failures that provably occurred before any actor or repository effect.

An operator may approve, at launch, automatic recovery only when all of these are mechanically proven:

- no model request started;
- no state, HEAD, index, or working-tree change occurred;
- no external action occurred;
- the failure is a listed preflight class with a deterministic correction.

Actor timeouts, no-transition results, permission decisions, scope changes, and partial effects remain operator gates. The purpose is to remove meaningless approvals without automating judgment.

## 4. Evidence retention policy

The current case mixes three forms of evidence:

- committed state summaries;
- untracked raw controller outputs under `logs/harness-runs/`;
- terminal-only transport output.

That is not reliable enough for autonomous recovery. Terminal-only evidence disappears from the repository, while large raw logs are expensive to reread and unsuitable for the state file.

Use the existing run-log mechanism with a two-level policy:

1. **Compact durable result:** a small run log or final result record containing invocation identity, stage, exit, actor-started flag, before/after state hash and HEAD, changed paths, usage, and pointers to captures.
2. **Raw capture:** verbose model/controller output retained according to a clear temporary or audit policy, never pasted into the state file.

For acceptance-critical live validations, commit or otherwise preserve the compact result with the closing evidence. Raw captures may remain untracked if the compact result contains enough facts to assess the case and the retention limitation is explicit.

## 5. Recommended implementation order

### Change set A — unblock this Phase 1 task

1. Initialize dispatcher logging before lease acquisition.
2. Emit the common final `RESULT` fields on every dispatcher exit.
3. Add the early-exit-17 regression case with explicit `--log-dir`.
4. Update the case-23 brief to wait for the exact durable artifact.
5. Repeat case 23 once as a newly approved recovery, then run case 24.

### Change set B — remove the largest execution multipliers

1. Delete live-model automatic retry.
2. Change the prepared-brief default to three hops.
3. Add focused test filters and retain one final full-suite gate.
4. Eliminate pointer-only commits.
5. Collapse bounded red/fix/green work into one implementation unit.

### Change set C — reduce recurring token cost

1. Add explicit per-run model and reasoning tiering.
2. Parse and enforce per-hop and cumulative usage.
3. Compact the Codex and Claude hot paths.
4. Add the dispatcher-specific noninteractive route.
5. Enforce state-size warning and stop thresholds.

### Change set D — improve autonomous operation

1. Add factual progress fields to status.
2. Make missing-evidence blocker handback mandatory.
3. Consolidate worktree dependency packaging and add parity tests.
4. Add headless environment preflight.
5. Add interruption/resume classification.

## 6. Acceptance criteria for the improved system

The system is ready for normal supervised autonomous work when all of the following are demonstrated:

1. A dispatcher refused at lease or ownership admission still creates a durable log and final result without launching an actor.
2. A supported linked worktree runs entirely from its own files and Git identity; removing any required dependency fails before actor launch.
3. A normal prepared implementation completes in no more than three actor hops: Claude implements, Codex assesses, Claude closes or performs the authorized correction/closure.
4. A bounded implementation unit can produce red, implement, and focused green without a separate model process for each step.
5. One final full-suite gate runs after focused checks; required suites never continue asynchronously after the actor returns.
6. No automatic retry occurs after a model request starts.
7. No pointer-only commit is required to identify the commit containing a handoff.
8. Status shows the current turn, unit, liveness, last stop, evidence path, and usage without the operator reading raw logs.
9. A model cannot return ordinary success while leaving the state unchanged; missing evidence is handed back as a blocker.
10. Case 23 and case 24 complete with durable evidence and no manual copy-paste between Codex and Claude.
11. Nominal operation requires no operator intervention between launch and a genuine decision, permission, risk, or integration gate.
12. The operator can recover after interruption without guessing whether a model started, whether partial effects exist, or whether a lease is safe to clear.

## 7. What should not be changed

The implementation also demonstrated controls worth preserving:

- Do not weaken fail-closed task, checkout, ownership, or containment admission.
- Do not allow the dispatcher or carrier to fall back to `main` when the task is bound to a worktree.
- Do not increase the 900-second actor timeout as a response to oversized units.
- Do not retry because the repository appears unchanged; require proof that no model request began.
- Do not widen per-task path allowlists merely to avoid false stops.
- Do not let either transport launch nested Claude or Codex actors.
- Do not make the dispatcher decide scope, strategy, risk acceptance, integration, push, merge, or cleanup.
- Do not create a scheduler, persistent registry, lease database, agent manager, or service.
- Do not merge the attended carrier and unattended dispatcher into one command surface. Share invariants and result vocabulary while preserving their intentional operational boundaries.

## 8. Final assessment

This implementation has produced valuable code and unusually strong controller evidence. It has also shown that Work Loop v2 is not yet efficient enough for long, autonomous implementation programmes. The safety controls are generally doing their jobs; the failures are mostly in packaging completeness, evidence durability, unit sizing, repeated context loading, and operator-facing observability.

The right next step is a narrow dispatcher correction, not another manual workaround: make `--log-dir` apply from the start of every invocation and make early refusals durable. After Phase 1 closes, the broader efficiency package should be implemented before Work Loop v2 is treated as a routine low-attention execution system.

Until then, the honest product description is:

> Work Loop v2 is a safety-conscious supervised execution controller that can carry model turns and prevent unsafe repository actions, but it still requires too much context, recovery coordination, and operator interpretation to qualify as fast, reliable autonomous work.

## Evidence consulted

- `logs/work-loop/work-loop-v2-cross-transport-concurrency-phase-1.md`
- `plans/work-loop-v2-v0.2/work-loop-v2-cross-transport-concurrency-and-task-aware-worktrees-implementation-proposal-2026-08-13.md`
- `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`
- `scripts/axcion-harness-v0.2/carry-turn.sh`
- `.claude/commands/work-loop-v2.md`
- `.agents/skills/work-loop-v2/SKILL.md`
- `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`
- `plans/work-loop-v2-v0.2/core-resolver-worktree-defect-report-2026-08-09.md`
- `audits/work-loop-v2-codex-usage-optimization-report-2026-08-13.md`
- Phase 1 commit history from `54d9db9c` through `ee3a9419`
- Phase 1 Claude run artifacts under `logs/harness-runs/`
- The live dispatcher exit-17 output and the attended carrier exit-22 evidence from case 23
