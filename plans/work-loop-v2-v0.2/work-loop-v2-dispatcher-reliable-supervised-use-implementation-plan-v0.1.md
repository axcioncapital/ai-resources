# Work Loop v2 Dispatcher Reliable Supervised Use Implementation Plan v0.1

**Date:** 2026-08-16  
**Status:** ACTIVATION-READY, **AWAITING PATRIK'S CONTENT-BOUND APPROVAL** — bound to the exact tested integrated baseline `2451e3df5b8616e035a39a679799738a975b642e` recorded in § 3, *Activation record*. The merge prerequisite is satisfied and the baseline prerequisites are settled, so this plan is no longer waiting on the durable-state branch. It is **not approved**: § 3 item 6 is outstanding, and this plan authorizes no dispatcher implementation until Patrik approves it against that exact baseline's content.  
**Target claim:** Reliable supervised semi-autonomous dispatcher.  
**Target user:** Patrik, launching one prepared and bounded repository task on a supported awake host.  

## 1. Operating outcome

Patrik launches one approved task once. The dispatcher then carries the normal Work Loop path without manual turn transport:

```text
Claude implementation
→ Codex assessment
→ Claude closure
```

When Codex identifies one explicitly pre-authorized bounded correction, the dispatcher may carry exactly one correction and one reassessment before closure or operator takeover.

Every run ends in one of two trustworthy outcomes:

1. **Completion:** the task is validly closed, evidence is complete, the repository state is known, and the dispatcher reports what happened.
2. **Operator takeover:** no further actor launches, canonical state is legally blocked for the operator, and Patrik receives one actionable handoff explaining the problem, current safety, recovery choices, and exact resume action.

This plan does not target unattended or walk-away execution. It targets reliable supervised use: Patrik remains available for genuine decisions, permissions, risks, failed proof, unexpected effects, and uncertain recovery.

## 2. Consolidation decision

This plan is the implementation-facing consolidation of:

- `dispatcher-reliability-closure-report-2026-08-15.md`; and
- `work-loop-v2-dispatcher-target-alignment-proposal-v0.1.md`.

For the first reliable-use release:

- the complete Gate SA reliability claim is retained;
- the six Gate ST target-alignment additions are held;
- Gate U unattended work is held; and
- no requirement is silently removed from Gate SA.

The two source documents remain historical rationale and future-option material. Once this plan is activated, they are not independent implementation authorities for the reliable-use release.

## 3. Activation and baseline contract

Implementation may begin only after all of the following are true:

1. Durable-state Tracers 6–8 are accepted, including correction and proof of the complete-but-uncommitted closure finding exposed during Tracer 6.
2. The durable-state branch, which contains the accepted concurrency and autonomy-authority work, is integrated with `main` through the repository's approved merge process.
3. The integrated checkout has one canonical validator, owner helper, shared task/checkout lease contract, Work Loop command/skill/core, and attended carrier.
4. The integrated baseline passes its required state, owner, lease, capability, command, carrier, and dispatcher regression suites.
5. One activation update to this plan records the exact integrated base commit and corrects any premise that changed during merge.
6. Patrik approves this plan against that exact baseline.

The activation update may reconcile facts and exact file locations. It may not add Gate ST machinery, weaken Gate SA, or treat skipped evidence as passed. Any material scope change requires an explicit operator decision and an updated release claim.

### Activation record — 2026-08-16

This is the one activation update permitted by item 5. It records facts and corrects the premises that changed during the merge. It adds no Gate ST machinery, weakens no Gate SA statement, removes no exclusion, and treats no skipped evidence as passed.

**The exact tested integrated baseline is `2451e3df5b8616e035a39a679799738a975b642e`.** It sits on branch `session/2026-08-16-dispatcher-last-fixes`, two commits ahead of `main` at `698383207208dbfccf04672a8263bbc55d001abf`. Approval under item 6 is approval against that commit's content and no other. The baseline is not on `main`, and merge remains excluded from this release (§ 4) and reserved to Patrik.

**The merge premise changed, and the correction is recorded rather than smoothed over.** The durable-state branch was integrated into `main` through the repository's approved merge process at `00855ec6e82313de9272221b03c28e4075512117` — parents `4ba2ff0e91ee94735702bce2e9ee20dfc55949f2` on `main` and `39b6e0a148d3afc061950fcf696e531e332e52fc` on the durable-state branch — so item 2 is satisfied. **The merge result itself was not activatable.** At the then-current `main` tip `698383207208dbfccf04672a8263bbc55d001abf` the merge had discarded accepted main-side Work Loop content, two prerequisites below failed, and that baseline was **refused rather than activated** at handback `f9145ef2fce3027b47cce2239667531d7805fe68`. It was then repaired forward — not re-merged, not rebased — at `2451e3df…`. `69838320…` appears in this plan only as the rejected intermediate; it is not the activation baseline.

| Item | Disposition at `2451e3df…` |
|---|---|
| 1 — Tracers 6–8 accepted, including the complete-but-uncommitted closure finding exposed during Tracer 6 | **Met.** `logs/work-loop/work-loop-v2-durable-state-system.md` is closed at `a97624a8` with all eight tracer bullets implemented. Tracer 6 landed at `096b8985` with correction `96ff6786` — *an uncommitted `CLOSED` record keeps its checkout* — which is that finding; the resulting clear-the-declaration-only-after-the-commit order is present in the Work Loop command at this baseline. Tracer 8 readiness handback `7a8d38e5`, correction `b81a1b58`. Its recorded limitation stands unchanged: the Tracer 8 correction re-check stalled and was accepted through Codex's bounded closure check instead of an independent re-check. |
| 2 — durable-state branch integrated with `main` through the approved merge process | **Met, with the correction above.** Merge `00855ec6`; the defective merge result at `69838320…` was refused and repaired forward at `2451e3df…`. |
| 3 — one canonical validator, owner helper, shared lease contract, command/skill/core, and attended carrier | **Met.** One tracked validator `logs/scripts/work-loop-state.sh`, one owner helper `logs/scripts/work-loop-owner.sh`, one lease contract `logs/scripts/work-loop-lease.sh`, one command `.claude/commands/work-loop-v2.md`, one skill `.agents/skills/work-loop-v2/SKILL.md`, one core `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`, one attended carrier `scripts/axcion-harness-v0.2/carry-turn.sh`. The two deployed template copies under `workflows/research-workflow/logs/scripts/` are byte-identical to their canonical originals, so they are deployments rather than second owners. |
| 4 — the integrated baseline passes its required state, owner, lease, capability, command, carrier and dispatcher regression suites | **Met at `2451e3df…`, and not at `69838320…`.** State `100/0`, owner `133/0`, lease `136/0`, capability `77/0`, command/skill/core `362/0`, carrier `457/0`, dispatcher `639/0`, Tracer 6 `74/0`, Tracer 7 `120/0`, core-resolver `4/0`. Two of those were red at the rejected intermediate — command/skill/core `315/44` and capability `76/1` — which is what the forward repair closed. |
| 5 — one activation update recording the exact base commit and correcting changed premises | **This record.** |
| 6 — Patrik approves this plan against that exact baseline | **Outstanding.** Not given, not inferred, and not implied anywhere in this plan. No dispatcher implementation may begin until it is. |

**One adjacent defect is carried as a recorded deferral, not as a fixed item.** The `$diagnose-and-fix` / `$realign` routing migration is half-landed across the repository: at this baseline `.agents/skills/work-loop-v2/references/routing-index.md` still indexes the pre-rename commands, and `SKILL.md` still points at a `references/repository-problem-resolution-sop.md` that the merge deleted — a live dangling reference. It is adjacent repository work rather than a Gate SA activation prerequisite established by this plan, it is unfixed at this baseline, and this record does not treat it as fixed.

### Baseline catch-up evidence

Before dispatcher changes begin, the integrated baseline must also settle the two known evidence gaps that the 2026-08-15 reliability report assumed away:

- run or explicitly re-adjudicate the genuine two-task/two-worktree concurrency case that concurrency Phase 1 skipped; and
- record the autonomy-authority implementation's actual accepted T7 boundary without claiming that the removed T8 scenario suite or T9 organic-task programme passed.

Gate SA's own dispatcher trials must prove the authority behavior needed by this release. This plan does not silently reopen the removed autonomy trial programme as a separate prerequisite.

**Disposition at the activation baseline — 2026-08-16.** Both gaps are settled by explicit re-adjudication. Neither is settled by a run, and neither is recorded as passed.

- **The genuine two-task/two-linked-worktree concurrency case is explicitly re-adjudicated, not run.** Live case 24 — two real Work Loop tasks in two linked worktrees, each completing a later handoff in its own bound checkout — was skipped by the operator's 2026-08-15 decision on time grounds, with a supported contract-compliant route recorded in `logs/work-loop/cross-transport-concurrency-correction.md` and the skip recorded in `logs/work-loop/work-loop-v2-cross-transport-concurrency-phase-1.md`. It was not rejected as unsafe or unsupported, and no attempt was made to reconstruct, simulate or approximate it. What exists at this baseline is controller-level case 12 — two different tasks in two linked worktrees — which passes, plus one pre-correction sandbox run. **There is no post-fix live proof, and controller evidence is not treated as a substitute for it.** The re-adjudication is this: the prerequisite is discharged as re-adjudicated rather than run; the live proof it asks for remains required, unchanged, by § 5 required live trial 8 (*Genuine parallel isolation*); and the residual risk — fan-out-two proven at controller level only — stands accepted on the operator's 2026-08-15 decision until that trial runs.
- **The autonomy-authority implementation's accepted boundary is T7, and T8 and T9 are unrun.** `logs/work-loop/autonomy-authority-capability.md` is closed at the T7 boundary by the operator's 2026-08-15 scope decision (amendment `ff3175cd5123dd2195cc7e80b2487ba3849e57a1`, final status announcement `7dceb727`). T7 landed at `48cca1c01adbeb07470e480d74d427ae5de3331c`: carrier suite `318/0` against a `285/0` pre-change baseline, and `--prove-failure` `43/0` including the mutant that strips the approval policy. **T8's twelve constructed scenarios and T9's 3–5 organic Standard tasks were removed from that task's completion bar rather than met** — zero of T8's twelve rows carry a verdict, zero organic tasks were recorded under T9, and they were not run, not bypassed, not simulated and not satisfied by substitute evidence. Nothing in this plan claims either passed. The accepted T7 limitations carried into this baseline are unchanged: T7 **requests** a policy on the Codex hop rather than enforcing containment; wrapper and absolute-path invocation routes are unmatched; and the unattended dispatcher's Codex launch line (`dispatch.sh:2115`) requests no equivalent policy. § 5's final regression gate item *autonomy-authority contract checks applicable to the accepted T7 boundary* is read against exactly that boundary and no wider one.

## 4. Fixed release boundary

### The dispatcher owns

- preflight of the complete local dispatcher runtime;
- acquisition and release of the accepted task and checkout leases;
- bounded launch of Claude and Codex;
- exact run identity, permission mode, budgets, logs, captures, and terminal results;
- deterministic validation of actor handback, canonical task state, Git facts, proof, changed paths, ownership, leases, and runtime facts;
- the fixed implementation, assessment, optional correction, reassessment, closure, takeover, and resume transitions in this plan; and
- read-only operational status.

### Claude and Codex own

- Claude: implementation, proof, the one approved correction when applicable, and closure under its existing Work Loop role contract;
- Codex: independent assessment and the correction/closure decision under its existing Work Loop role contract; and
- both actors: only the semantic task-record fields and commits assigned to their accepted roles.

### Patrik owns

- task intent, scope, exclusions, and success criteria;
- permission or capability expansion;
- material architecture, priority, or product decisions;
- acceptance of consequential residual risk;
- recovery choices after operator takeover; and
- the final adopt, shrink, or stop decision.

### Release exclusions

The release does not include:

- unattended or closed-lid operation;
- automatic task creation, prioritization, scheduling, or project routing;
- automatic worktree creation;
- merge, push, deployment, branch deletion, or destructive cleanup;
- external or hard-to-reverse actions not explicitly delegated;
- routine nested agents;
- a Decision Resolver, policy engine, second state store, event bus, queue, database, dashboard, or heartbeat service; or
- a dispatcher rewrite or implementation-language migration.

The existing unattended surface must remain disabled or explicitly experimental. Passing this plan may not relabel it reliable, and no Gate SA result may imply that full-lifetime containment or walk-away operation was proven.

## 5. Implementation sequence

Use the existing attended Work Loop to implement this plan. The unreleased dispatcher may be exercised only in named tests and trials; it must not carry its own implementation work.

Each change set must produce focused fail-capable evidence, one coherent implementation handback, independent Codex assessment, and correction only for demonstrated material findings. Run the complete synchronous regression gate before final adoption.

### Change set A — Establish one trusted run and result boundary

#### Required behavior

1. Create one run identity and initialize its external evidence location before any model request or mutating action.
2. Define one versioned, bounded, machine-readable terminal-result schema used by every terminal dispatcher path.
3. Atomically finalize exactly one terminal result for:
   - usage or argument refusal;
   - missing runtime or authentication;
   - invalid state or ownership;
   - lease refusal;
   - permission denial;
   - actor timeout, interruption, or failure;
   - missing handback or no valid transition;
   - partial or unexpected effects;
   - budget exhaustion;
   - operator takeover; and
   - successful completion.
4. The result must truthfully record at least:
   - task, checkout, run, stage, actor, and outcome;
   - whether a model request started;
   - state and HEAD before/after;
   - working-tree and changed-path facts;
   - permission mode, hop count, deadline, and recorded usage when available;
   - actor/session identifier when available;
   - log and capture paths;
   - owner/lease release or pin status; and
   - the next required action.
5. Use one exact run-bound producer/consumer evidence path. The consumer waits only for the artifact the producer promised to create and only within a finite deadline shorter than its own actor timeout.
6. A zero actor exit, commit, artifact, prose claim, or file appearance cannot independently advance the Work Loop. Progress requires the expected terminal evidence plus a valid role-owned state transition.
7. Missing terminal evidence becomes an operator blocker. It is never reconstructed from a commit, report, event, or narrative.
8. `--status` remains strictly read-only: no lease, evidence write, state mutation, or model launch.

#### Trusted field ownership

Define one mechanically consumed field-ownership contract:

- actors may change only their accepted semantic task fields and role-owned commits;
- the dispatcher and accepted helpers exclusively own run identity, permission approval, budgets, runtime facts, observed Git/process facts, owner/lease mutation, and terminal results; and
- every actor-authored transition is a claim that must be independently validated before another launch.

No second lifecycle parser, dispatcher-private semantic state, or prose-only authority contract is permitted.

#### Durable ordering and recovery

Define and implement the exact write order for success, blocked/operator, clean failure, partial effect, correction, reconciliation needed for recovery, and closure.

In this plan, reconciliation means only the accepted canonical validator/helper checks needed to classify durable truth after a crash or interrupted boundary. It does not authorize Gate ST's `RECONCILE_NEEDED | RECONCILED_SAFE | RECONCILE_BLOCKED` transition system, automatic semantic repair, or a dispatcher-local recovery state machine.

At minimum:

1. initialize run identity and evidence;
2. record actor start before relying on post-start policy;
3. capture and validate actor output, state, Git, proof, path, process, owner, and lease facts;
4. commit valid `CLOSED` task state before owner clear;
5. finalize the terminal result only from validated facts; and
6. release a lease only after the terminal result exists and teardown is proven safe.

Uncertain teardown pins the applicable lease. A crash immediately before or after each durable boundary must recover to exactly one of:

- continue from a proven next action;
- recognize already-completed work without replay; or
- enter operator takeover.

#### Hostile-input boundary

- Apply strict length and character grammars to task IDs, run IDs, outcomes, reason codes, protocol versions, and control tokens.
- Parse actor handbacks as bounded data through one parser; never `eval` or `source` actor content.
- Use argument arrays and explicit option termination where supported.
- Canonicalize and bound checkout, state, evidence, capture, and changed-path values.
- Reject traversal, control characters, newline injection, unsafe symlinks, leading-option attacks, paths outside admitted roots, duplicate singleton fields, unknown versions, malformed encodings, oversized values, and fake control lines.
- Keep raw actor output separate from trusted result framing.

#### Change-set acceptance

- Every terminal class produces exactly one valid result.
- A missing result, injected fake result, or actor mutation of an unowned field cannot advance the dispatcher.
- Crash injection at each named boundary produces no duplicate model request, duplicate commit, false completion, unsafe owner clear, or premature lease release.
- Adversarial protocol/path fixtures execute nothing and write nowhere outside admitted roots.
- Valid Claude and Codex handbacks continue to pass.

### Change set B — Bound execution and carry approved authority

#### Permission transport

- Add attended `default | acceptEdits` permission selection.
- `acceptEdits` is valid only when Patrik explicitly approves it for that invocation.
- Record requested and effective permission mode in run evidence.
- Never infer broader authority from a previous denial.
- Continue refusing `bypassPermissions`.
- A denied run can enter operator takeover and resume inside the dispatcher after explicit approval; it must not require an interactive transport bypass.

#### Retry and execution budgets

- Never automatically retry after any model request starts.
- Retry only a named, mechanically proven zero-model preflight failure with unchanged state, HEAD, index, working tree, authority, and runtime facts.
- Use a three-hop ceiling for the normal prepared path: implementation, assessment, closure.
- Keep the optional correction corridor separate: at most one correction and one reassessment, followed by closure or operator takeover.
- Require a finite whole-run deadline for every live multi-hop run.
- Stop before another launch when hop, deadline, usage, correction, or state-size budget is exhausted.
- Record per-hop and cumulative input, cached-input, output, and reasoning usage where the actor exposes them.
- Warn when active task state approaches 12 KB and refuse another automatic launch above 16 KB until the record is compacted, unless the activated baseline records an operator-approved evidence-backed replacement threshold.
- Give correction work a smaller declared budget and zero nested-AI allowance by default.

#### Complete runtime preflight

Define the complete dispatcher runtime once and make preflight and fixtures consume that definition. Before paying for a model request, verify:

- actor binaries and authentication readiness;
- Git repository, checkout, branch/worktree identity, and Git user identity;
- command, skill, executable core, validator, owner helper, shared lease helper, Reorient capability, and required transport helpers;
- state, ownership, lease, and evidence-directory validity;
- required file presence, readability/executability, expected location, and symlink safety; and
- the selected permission and runtime profile.

A supported linked worktree must carry its complete local runtime. It may not borrow missing files from canonical `main`.

#### Nested-actor claim

- Approved nested AI invocations remain zero by default.
- Apply the strongest approved direct nested-actor refusal symmetrically to Claude and Codex paths where technically possible.
- Record requested policy and observed descendants.
- Distinguish prevention, observation, and unknown status. Never report containment or `nested=0` from absence of observation alone.
- If symmetric prevention is unavailable, publish the exact limitation and stop on observed or uncertain expansion.

Full-lifetime descendant containment is not part of this release.

#### Change-set acceptance

- Permission denial followed by explicit `acceptEdits` approval resumes inside the dispatcher.
- No started request is retried in timeout, failure, missing-result, denial, or partial-effect cases.
- Normal success fits the three-hop corridor; correction cannot exceed its separate ceiling.
- Every live run has finite whole-run budgets and stops before exceeding them.
- Removing any required runtime component fails before actor launch and names the exact missing prerequisite.
- An arbitrarily named linked worktree passes only with its complete local runtime and identity.
- Nested-actor reporting matches what is actually enforced and observed.

### Change set C — Make operator takeover, status, and resume reliable

#### Mandatory takeover classes

Enter operator takeover when:

- a permission or capability decision is required;
- Codex identifies a material defect outside the one approved correction corridor;
- task intent, scope, architecture, priority, exclusions, or success criteria become unclear;
- a started actor fails, times out, is interrupted, or returns without the required result;
- partial or unexpected repository effects exist without a valid handback;
- state, ownership, lease, Git, proof, path, runtime, or transport facts conflict or cannot be proven;
- nested-process status or teardown is uncertain;
- any run budget is exhausted;
- authentication or runtime capability becomes unavailable after preflight; or
- work would require an undelegated external, destructive, merge, push, or deployment action.

#### Takeover contract

Before exiting, the dispatcher must:

1. stop further launches;
2. capture partial effects and process/lease condition;
3. write one legal canonical record:

   ```yaml
   status: blocked
   turn: operator
   ```

4. atomically finalize the terminal result; and
5. render one compact handoff from validated facts containing:
   - attempted stage and actor;
   - exact stop classification;
   - whether a model request started;
   - state, HEAD, working-tree, changed-path, commit, process, owner, lease, deadline, and usage facts;
   - exact result, log, and capture paths;
   - current safety and any partial implementation;
   - two or three safe recovery choices when alternatives genuinely exist;
   - a recommendation only when evidence clearly supports one; and
   - the exact decision and resume action required from Patrik.

The handoff is a view of canonical state and terminal evidence, not a second authority store.

#### Read-only status

Status must show, without raw-log reconstruction:

- task, checkout, current turn and stage;
- run ID, hop count, elapsed and remaining deadline;
- top-level actor and observed/unknown descendants;
- cumulative recorded usage;
- last terminal outcome and evidence path;
- state, owner, lease, HEAD, working-tree, and partial-effect classification; and
- the exact operator or recovery action required.

It must distinguish live, safely stale, conservatively pinned, partial-effect, and model-started-without-final-result conditions.

#### Resume contract

Resume requires:

1. Patrik's explicit recovery or permission decision;
2. that decision recorded in canonical state/run evidence;
3. a new run identity;
4. revalidation of task state, ownership, leases, Git facts, partial effects, runtime, authority, and budgets; and
5. continuation from the durable next action rather than replay of the failed request.

Repository drift while waiting causes another takeover with updated evidence. No actor launches while canonical state remains blocked.

#### Change-set acceptance

- Every mandatory stop produces one valid blocked/operator record and actionable handoff.
- Status classifies the situation without writing anything.
- Resume cannot proceed without a new explicit operator decision and complete revalidation.
- A missing result or unknown teardown never triggers automatic retry, lease clear, or inferred completion.

### Change set D — Prove the complete supervised operating claim

Run the candidate in clean dedicated worktrees through the real dispatcher. Simulated controller tests remain necessary regression evidence but cannot satisfy these live trials.

#### Required live trials

1. **Normal path, repeated three times:** implementation, assessment, closure, and trusted completion without manual turn transport.
2. **Permission and resume:** deliberate denial, honest classification, explicit `acceptEdits` approval, and successful resume inside the dispatcher.
3. **Operator decision and resume:** Codex non-pass outside the correction corridor, legal takeover, Patrik decision, complete revalidation, and successful continuation.
4. **One correction:** one authorized correction and reassessment; a second non-pass stops.
5. **Partial effect:** timeout or termination after an allowed effect, truthful status, no retry, and deterministic recovery.
6. **Missing final result:** durable blocker; never false success.
7. **Linked-worktree runtime:** arbitrarily named supported worktree with complete local runtime and identity.
8. **Genuine parallel isolation:** two different approved tasks in two linked worktrees proceed without lease or evidence collision; same-task or same-checkout contention still refuses exactly one side.
9. **Crash-boundary recovery:** injected crashes at every durable boundary defined in Change set A recover without duplicate effect or false completion.
10. **Hostile input:** task/run identifiers, paths, protocols, handbacks, oversized values, and fake results fail closed.
11. **Control-field mutation:** an actor attempt to change an unowned owner, lease, permission, runtime, budget, run, or terminal-result field cannot advance the run.

Every trial records exact task/checkout, base and final HEAD, permission mode, actor/session identifiers, hop/deadline/usage facts, state and working-tree before/after, changed paths, terminal result, capture path, operator intervention, and final verdict.

#### Final regression gate

Run synchronously:

- dispatcher controller suite;
- attended carrier suite;
- canonical state validator and owner suites;
- shared lease suite;
- Work Loop command/skill/core and deployment-capability suites;
- autonomy-authority contract checks applicable to the accepted T7 boundary; and
- focused parser, field-ownership, crash-order, and hostile-input suites added by this plan.

No required verification may remain detached after the implementing actor returns.

#### Independent review and adoption

An independent review compares the integrated implementation and evidence against this plan and returns one of:

- **ADOPT:** every Gate SA statement is proven;
- **SHRINK:** Patrik explicitly accepts a narrower operating envelope and release label; or
- **STOP:** a material reliability or feasibility failure remains.

Only ADOPT permits the label **Reliable supervised semi-autonomous dispatcher**.

## 6. Gate SA — final acceptance contract

The release passes only when all of the following are proven:

- every exit produces one durable atomic result with truthful actor-start and before/after facts;
- missing evidence and zero-without-transition block rather than complete;
- actor-writable semantic state and trusted control facts obey one enforced ownership contract;
- an actor transition advances only after lifecycle, role, Git, proof, path, owner, lease, and transport validation;
- every success, block, failure, partial effect, correction, reconciliation, and closure path follows the accepted durable order and recovery classification;
- hostile identifiers, paths, protocols, and handbacks cannot execute content, escape roots, inject control facts, or change routing;
- the normal implementation-assessment-closure path completes without Patrik carrying turns;
- approved `acceptEdits` resumes inside the dispatcher without bypass permissions;
- no started model request is automatically retried;
- normal and correction paths obey their separate hop ceilings;
- deadline, usage, correction, and state-size controls prevent disproportionate continuation;
- linked worktrees pass only with complete local runtime and identity;
- status explains liveness, partial effects, last result, and safe recovery without raw-log reconstruction;
- every non-routine stop creates one legal blocked/operator record and actionable handoff;
- resume requires Patrik's decision, a new run, and complete revalidation;
- nested-actor claims match actual enforcement and observation;
- all required live trials pass; and
- concurrency, durable-state, autonomy-authority, carrier, and Work Loop invariants remain green.

## 7. Work explicitly held after this release

The following Gate ST capabilities remain on hold until Gate SA is implemented, proven, and adopted. Gate SA evidence—not an arbitrary additional waiting quota—determines whether any should reopen:

1. general task-contract admission and automatic route selection;
2. the richer Gate ST actor-handback schema and general next-action transition router;
3. dispatcher-governed executor-internal repair iterations;
4. the Decision Resolver and `ALLOW | DENY_AND_REPAIR | OPERATOR` semantic path;
5. expanded evidence-rendered semantic completion/decision reports beyond the Gate SA terminal result and takeover handoff; and
6. the append-only event journal and operating-analysis reason-code layer.

Also held:

- reusable precedents or self-modifying authority;
- additional capability profiles;
- general shared-resource or non-Git-effect admission profiles;
- larger repair, resolver, or correction budgets;
- an arbitrator or reviewer hierarchy;
- automatic planning, prioritization, scheduling, or portfolio routing; and
- all Gate U unattended containment, host-policy, and walk-away work.

Reopening any held item requires:

1. Gate SA adoption;
2. a concrete obstruction visible in Gate SA evidence;
3. proof that the obstruction is not better solved by removal, simplification, an operating change, or a narrower actor contract; and
4. a separate operator-approved scope.

## 8. Implementation discipline

- Build vertical behavior through the real dispatcher as early as each safety dependency allows.
- Add no infrastructure without a requirement in this plan.
- Keep one production owner for every parser, validator, lifecycle, result, and transition seam.
- Do not weaken acceptance criteria, proof, scope boundaries, or authority to obtain a passing run.
- Correct only reproducible defects that block this plan or regress an accepted invariant.
- Record adjacent improvements separately; do not absorb them.
- Use per-invocation model and reasoning choices only; add no repository-wide model default.
- Retain compact terminal results durably. Keep raw captures under an explicit bounded audit/temporary policy without adding a retention service.
- If the shell implementation would require a second production parser, duplicated lifecycle semantics, or a pure transition that cannot be tested without the full dispatcher, extract that behavior behind one narrow helper interface. This is not authorization for a rewrite.

## 9. Stop conditions

Stop implementation and return to Patrik when:

- the post-merge baseline contradicts a load-bearing plan premise;
- a requirement needs a second state system, policy engine, general scheduler, or dispatcher rewrite;
- reliable recovery cannot be proven without reconstructing missing truth;
- a started request or persistent effect cannot be distinguished from a safe replay;
- actor-written content can alter trusted control truth;
- process teardown cannot be classified honestly enough for supervised reuse;
- the plan must expand materially into Gate ST or Gate U;
- adequate live proof cannot be established; or
- any trial produces unsafe continuation or false completion.

## 10. Completion statement

This plan is complete only when one integrated candidate has passed Gate SA and the independent adoption review.

The accepted operating rule is:

> Continue automatically only while task identity, canonical state, evidence, authority, runtime, Git facts, ownership, leases, and budgets agree. Carry the fixed normal path without manual transport. Stop with durable actionable evidence whenever they do not.
