# Work Loop v2 Dispatcher Reliable Supervised Use Implementation Plan v0.1

**Date:** 2026-08-16  
**Status:** ACTIVE, carrying a **2026-08-19 MATERIAL AMENDMENT THAT IS DRAFT AND AWAITS FRESH CONTENT-BOUND APPROVAL.** Patrik's 2026-08-18 approval is bound to the plan content carried by commit `849d08000292005d6a522454552f7025b89a34ba`, whose blob for this file is `c7857d5fb7956533c1047a8f449ba09f43186f9e`, and it remains the historical authority for that content and no other. It does **not** transfer to the 2026-08-19 amendment recorded in § 2 (*The 2026-08-19 amendment*), which changes the takeover model and the remaining acceptance scope. Implementation of the amended content resumes only after Patrik approves it against its own identified commit and blob. The target claim, the §§ 4 and 7 boundaries and exclusions, Gate ST, Gate U, unattended or walk-away release claims, dispatcher rewrite or language migration, merge, push, deployment and destructive cleanup are unchanged by the amendment and remain reserved to Patrik.  
**Target claim:** Ready for supervised semi-agentic use — durable terminal results are guaranteed after run admission.  
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
2. **Operator takeover:** no further actor launches, exactly one durable terminal result is finalized, canonical task state stays wherever its owning actor last legally left it, and Patrik receives one actionable handoff explaining the problem, current safety, and the exact decision and resume action required. The dispatcher never writes canonical task state and never commits — see § 2, *The 2026-08-19 amendment*.

This plan does not target unattended or walk-away execution. It targets reliable supervised use: Patrik remains available for genuine decisions, permissions, risks, failed proof, unexpected effects, and uncertain recovery.

## 2. Consolidation decision

This plan is the implementation-facing consolidation of:

- `dispatcher-reliability-closure-report-2026-08-15.md`; and
- `work-loop-v2-dispatcher-target-alignment-proposal-v0.1.md`.

For the first reliable-use release:

- the complete Gate SA reliability claim is retained after run admission;
- the six Gate ST target-alignment additions are held;
- Gate U unattended work is held;
- invalid pre-admission invocations fail clearly without creating a run or durable run result; and
- no admitted-run requirement is silently removed from Gate SA.

The two source documents remain historical rationale and future-option material. Once this plan is activated, they are not independent implementation authorities for the reliable-use release.

### The 2026-08-19 amendment

**This subsection is draft and awaits Patrik's fresh content-bound approval.** It is recorded here rather than smoothed into the surrounding text so that a reader can see exactly what changed, and against which prior content.

#### The conflict that produced it

Unit 27 of `logs/work-loop/work-loop-v2-dispatcher-supervised-semi-agentic-use.md` stopped without making any production change because this plan disagreed with itself, and with the executable core, about who writes canonical task state. The three passages, as they stood before this amendment:

- § 1, operating outcome 2: *"no further actor launches, **canonical state is legally blocked for the operator**, and Patrik receives one actionable handoff…"*
- § 5, Change set C, takeover contract step 3: *"**write one legal canonical record:** `status: blocked` / `turn: operator`"*
- § 6, Gate SA: *"**every non-routine stop creates one legal blocked/operator record** and actionable handoff"*

beside this plan's own ownership contract, which the same approval covers:

- § 4: *"both actors: **only the semantic task-record fields and commits assigned to their accepted roles**"*
- § 5, Change set A, trusted field ownership: *"actors may change only their accepted semantic task fields and role-owned commits; **the dispatcher and accepted helpers exclusively own** run identity, permission approval, budgets, runtime facts, observed Git/process facts, owner/lease mutation, and terminal results"* — a list from which canonical task state is absent.

and beside the executable core, which is not this plan's to amend: `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` § 4 says a courier *"may never … change the task, the brief, the result, or any other content of the state file"* and may never *"choose which actor moves next, or decide that a turn exists"*, and its *Who commits* rule — an operator decision of 2026-08-01 — says **"Claude makes every commit."** The dispatcher's own implementation already states the same contract at `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh:3982`.

#### Patrik's decision — the read-only takeover model

On 2026-08-19 Patrik resolved that operator-owned conflict. **The dispatcher stays read-only toward canonical task state.** Stated once, and governing everywhere this plan touches takeover:

- Where an actor has already written and committed a legal `status: blocked` / `turn: operator` record under its own role contract, **that record is canonical**, and takeover reports it.
- Where the **dispatcher itself** detects the stop because the actor did not hand back, the dispatcher **writes no task state and makes no commit**. It stops all further launches, atomically finalizes exactly one durable terminal result, and that stopped run plus its terminal result **constitute the takeover**. Canonical task state remains at its last valid actor-owned turn.
- Read-only status renders the required operator action from trusted run evidence, never by inferring or repairing canonical state.
- **Resume requires Patrik's explicit decision, a new run identity, and full revalidation** — state, ownership, lease, Git, runtime, authority and budgets — continuing from the last valid turn rather than replaying the failed request.

This model keeps the admitted-run guarantee intact: every terminal path after run admission still produces one durable atomic result, and dispatcher-detected takeover is still safe and actionable, because the terminal result carries the facts the handoff and status are rendered from.

#### Patrik's governing priority — finish lean

Also on 2026-08-19, Patrik set the governing priority: **finish the implementation as soon as safely possible and cut everything not important to the original supervised semi-agentic outcome.** The original outcome is the one in `pre-launch-preparations/dispatcher-semi-agentic-readiness-fixes-2026-08-11.md` — its target operating envelope, five priorities and release criteria — which is non-governing rationale here; Patrik's current priority is the authority. § 5 (*Minimum release contract*) records the resulting remaining scope and every cut.

#### What this amendment does not change

The target claim, target user, § 4 fixed release boundary and exclusions, the admitted-run durable-terminal-result guarantee, the Gate ST and Gate U holds in § 7, the accepted baseline evidence in § 3, and every operator-reserved authority are unchanged. No cut removes a safety invariant: a cut removes duplicate live proof or nonessential reporting only, and § 5 records where the deterministic controller or regression proof for each cut live case still sits.

## 3. Activation and baseline contract

Implementation may begin only after all of the following are true:

1. Durable-state Tracers 6–8 are accepted, including correction and proof of the complete-but-uncommitted closure finding exposed during Tracer 6.
2. The durable-state branch, which contains the accepted concurrency and autonomy-authority work, is integrated with `main` through the repository's approved merge process.
3. The integrated checkout has one canonical validator, owner helper, shared task/checkout lease contract, Work Loop command/skill/core, and attended carrier.
4. The integrated baseline passes its required state, owner, lease, capability, command, carrier, and dispatcher regression suites.
5. One activation update to this plan records the exact integrated base commit and corrects any premise that changed during merge.
6. Patrik approves this plan against that exact baseline.

The activation update may reconcile facts and exact file locations. It may not add Gate ST machinery, weaken the admitted-run Gate SA contract, or treat skipped evidence as passed. Any material scope change requires an explicit operator decision and an updated release claim. Patrik made that decision on 2026-08-18 by choosing `SHRINK`, and made two further ones on 2026-08-19 — the read-only takeover model and the lean release priority, both recorded in § 2. The 2026-08-19 amended content requires fresh content-bound approval before implementation resumes.

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
| 6 — Patrik approves this plan against that exact baseline | **Met for the 2026-08-18 content; pending for the 2026-08-19 amendment.** Patrik approved on 2026-08-18, content-bound to commit `849d08000292005d6a522454552f7025b89a34ba`, plan blob `c7857d5fb7956533c1047a8f449ba09f43186f9e`, against baseline `2451e3df…`. That approval authorizes implementation only inside the then-approved admitted-run Gate SA scope and the unchanged exclusions in §§ 4 and 7. The 2026-08-19 amendment (§ 2) changes the takeover model and the remaining acceptance scope, so it is **not** covered by that approval and requires its own content-bound approval before implementation resumes. |

**Patrik's prior content-bound approval, retained as historical authority for the earlier content.** On 2026-08-16 Patrik approved the plan content carried by commit `e9a6fd8bc51992a1ce8f6e09dcf95b273dd07240`, whose blob for this file is `43c44e01703c8622482d93d80407ddc1c83e038a`, against the exact tested integrated baseline `2451e3df5b8616e035a39a679799738a975b642e`. That approval does not transfer to this material revision. The baseline evidence and exclusions remain authoritative inputs; the revised admitted-run acceptance boundary and narrower release claim remained draft until the separate approval recorded below.

**Patrik's 2026-08-18 content-bound approval, retained as historical authority for that content.** On 2026-08-18 Patrik approved the plan content carried by commit `849d08000292005d6a522454552f7025b89a34ba`, whose blob for this file is `c7857d5fb7956533c1047a8f449ba09f43186f9e`. That approval activated the admitted-run boundary and the narrower release claim **Ready for supervised semi-agentic use** against the existing tested baseline, and authorized dispatcher implementation inside the then-approved Gate SA scope and nothing beyond it. It is the exact prior approved commit and blob retained here as historical authority.

**The 2026-08-19 amendment is not covered by it, and is draft.** § 2 (*The 2026-08-19 amendment*) records Patrik's read-only takeover decision and his lean-release priority. Both change acceptance conditions and remaining scope, so the 2026-08-18 approval does not transfer — exactly as the 2026-08-16 approval did not transfer to the 2026-08-18 revision. Implementation resumes only after Patrik approves the amended content against its own identified commit and blob. Nothing in the amendment is treated as approved or as built.

**One adjacent defect is carried as a recorded deferral, not as a fixed item.** The `$diagnose-and-fix` / `$realign` routing migration is half-landed across the repository: at this baseline `.agents/skills/work-loop-v2/references/routing-index.md` still indexes the pre-rename commands, and `SKILL.md` still points at a `references/repository-problem-resolution-sop.md` that the merge deleted — a live dangling reference. It is adjacent repository work rather than a Gate SA activation prerequisite established by this plan, it is unfixed at this baseline, and this record does not treat it as fixed.

### Baseline catch-up evidence

Before dispatcher changes begin, the integrated baseline must also settle the two known evidence gaps that the 2026-08-15 reliability report assumed away:

- run or explicitly re-adjudicate the genuine two-task/two-worktree concurrency case that concurrency Phase 1 skipped; and
- record the autonomy-authority implementation's actual accepted T7 boundary without claiming that the removed T8 scenario suite or T9 organic-task programme passed.

Gate SA's own dispatcher trials must prove the authority behavior needed by this release. This plan does not silently reopen the removed autonomy trial programme as a separate prerequisite.

**Disposition at the activation baseline — 2026-08-16.** Both gaps are settled by explicit re-adjudication. Neither is settled by a run, and neither is recorded as passed.

- **The genuine two-task/two-linked-worktree concurrency case is explicitly re-adjudicated, not run.** Live case 24 — two real Work Loop tasks in two linked worktrees, each completing a later handoff in its own bound checkout — was skipped by the operator's 2026-08-15 decision on time grounds, with a supported contract-compliant route recorded in `logs/work-loop/cross-transport-concurrency-correction.md` and the skip recorded in `logs/work-loop/work-loop-v2-cross-transport-concurrency-phase-1.md`. It was not rejected as unsafe or unsupported, and no attempt was made to reconstruct, simulate or approximate it. What exists at this baseline is controller-level case 12 — two different tasks in two linked worktrees — which passes, plus one pre-correction sandbox run. **There is no post-fix live proof, and controller evidence is not treated as a substitute for it.** The re-adjudication is this: the prerequisite is discharged as re-adjudicated rather than run; and the residual risk — fan-out-two proven at controller level only — stands accepted on the operator's 2026-08-15 decision. **Amended 2026-08-19 (§ 2, § 5):** the separate live parallel-isolation trial is cut from the release bar under Patrik's lean-release priority, so the live proof it asked for is no longer required for this release. The invariant is unchanged and still owned by the deterministic controller proof (case 12), and **the accepted residual risk is unchanged and is not reclassified as proven** — cutting the trial removes the duplicate live proof, not the accepted risk.
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

**The dispatcher does not own canonical task state, and never writes or commits it** (§ 2, *The 2026-08-19 amendment*). Its durable authorship is the terminal result and the run's own evidence.

### Claude and Codex own

- Claude: implementation, proof, the one approved correction when applicable, and closure under its existing Work Loop role contract;
- Codex: independent assessment and the correction/closure decision under its existing Work Loop role contract;
- both actors: only the semantic task-record fields and commits assigned to their accepted roles; and
- **the canonical task record exclusively** — including any legal `status: blocked` / `turn: operator` handback, which only an actor may write and commit.

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

### Minimum release contract — the remaining scope after the 2026-08-19 trim

**Draft, pending the approval named in § 2.** Under Patrik's 2026-08-19 priority, the remaining implementation is exactly these six items. Change set A is accepted work and is not reopened; the change sets below are read against this list, not beyond it.

1. Explicit permission-denial takeover, and operator-approved `acceptEdits` resume inside a new dispatcher run.
2. No automatic replay after a model request starts; finite normal and correction hop ceilings; one whole-run deadline; zero nested AI by default.
3. Minimum preflight for the binaries, repository and worktree identity, canonical Work Loop artifacts, state/owner/lease/evidence paths, and the selected permission and runtime profile actually needed to start safely.
4. Read-only status and takeover output sufficient to show the stop, partial effects, evidence paths, current safety and the exact operator action — not an exhaustive rendering of every stored fact.
5. The original three live supervised shapes: the normal implementation → assessment → closure path run three times; permission denial with approved resume; and controlled interruption with partial-effect recovery. Linked-worktree operation is proven inside one normal run rather than as a separate live programme.
6. One synchronous regression gate and one independent adoption decision.

#### What was cut, and where its proof now sits

A cut removes duplicate live proof or nonessential reporting. **It never removes a safety invariant**, and every cut live scenario keeps the deterministic controller or regression proof that bears on the admitted-run guarantee.

| Cut on 2026-08-19 | Why it is not needed for this release | What still proves the invariant |
|---|---|---|
| Token-level input, cached-input, output and reasoning accounting, and usage budgets | Reporting detail, not a stop condition. Hop ceilings and the whole-run deadline already bound continuation. **This cuts remaining work only** — Change set A's accepted terminal-result field *recorded usage when available* is untouched, because accepted work is not reopened | Hop-ceiling and deadline controller cases (Change set B) |
| State-size warning and refusal thresholds (12 KB / 16 KB) | An unmeasured threshold; no observed harm at the accepted baseline | Whole-run deadline and hop ceilings still stop disproportionate continuation |
| A separate smaller resource budget for correction work, beyond the retained hop, deadline and nested-AI limits | Duplicate accounting of a corridor the correction hop ceiling already bounds | Correction-corridor ceiling cases (Change set B) |
| Multi-choice recovery menus and recommendation logic in takeover handoffs | Judgment rendering the operator does not need automated; the exact required action is what is load-bearing | The handoff still names the exact decision and resume action from validated facts |
| Exhaustive status fields already present in terminal evidence | Duplicate rendering of stored facts | The terminal result retains the facts; status renders the operator-facing subset |
| Separate live trials for operator decision, correction, missing result, parallel isolation, every crash boundary, hostile input, and control-field mutation | Fail-capable controller and regression proof already exists for each | Change set A crash-order, field-ownership, parser and hostile-input suites; controller case 12 for two-task/two-worktree isolation; missing-result and no-valid-transition controller cases. The § 3 residual risk on fan-out-two — proven at controller level only — **stands accepted and is not reclassified as proven** |
| Any capture-retention service or cleanup work | No measured trial harm | Revisit only if a trial measures harm (§ 8) |

### Change set A — Establish one trusted run and result boundary

#### Required behavior

**Admission boundary:** a run exists only after argument parsing has supplied syntactically valid task, checkout and evidence-location inputs and the dispatcher has established their trusted canonical values. Before that point, invalid usage or arguments must launch no actor, acquire no owner or lease, mutate nothing, write no evidence, print a clear error to stderr and exit nonzero. Such a refusal is not a run terminal class and needs no durable result.

1. After admission, create one run identity and initialize its external evidence location before any model request or mutating action.
2. Define one versioned, bounded, machine-readable terminal-result schema used by every terminal path of an admitted run.
3. Atomically finalize exactly one terminal result for:
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

Define and implement the exact write order for success, an actor-authored blocked/operator handback, clean failure, partial effect, correction, reconciliation needed for recovery, and closure. In every one of these the dispatcher's own durable write is the terminal result and the run's evidence, never the canonical task record (§ 2, *The 2026-08-19 amendment*).

In this plan, reconciliation means only the accepted canonical validator/helper checks needed to classify durable truth after a crash or interrupted boundary. It does not authorize Gate ST's `RECONCILE_NEEDED | RECONCILED_SAFE | RECONCILE_BLOCKED` transition system, automatic semantic repair, or a dispatcher-local recovery state machine.

At minimum:

1. initialize run identity and evidence;
2. record actor start before relying on post-start policy;
3. capture and validate actor output, state, Git, proof, path, process, owner, and lease facts;
4. require the actor's own valid committed `CLOSED` task state before owner clear;
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

- Every admitted-run terminal class produces exactly one valid result.
- Every invalid pre-admission invocation produces clear stderr and a nonzero exit while launching no actor, taking no owner or lease, mutating nothing and writing no evidence.
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
- Stop before another launch when the hop, deadline, or correction ceiling is exhausted.
- Give correction work zero nested-AI allowance by default.

*Cut on 2026-08-19 (§ 5, minimum release contract): token-level usage accounting and usage budgets; the 12 KB / 16 KB state-size warning and refusal thresholds; and a separate smaller correction resource budget beyond the retained hop, deadline and nested-AI limits.*

#### Minimum runtime preflight

Define the dispatcher runtime once and make preflight and fixtures consume that definition. Before paying for a model request, verify only what is needed to start safely:

- actor binaries and authentication readiness;
- Git repository, checkout, branch/worktree identity, and Git user identity;
- the canonical Work Loop artifacts — command, skill, executable core, validator, owner helper, shared lease helper, Reorient capability, and required transport helpers — each present, readable or executable as applicable, in its expected location, and symlink-safe;
- state, ownership, lease, and evidence-path validity; and
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

- Permission denial followed by explicit `acceptEdits` approval resumes inside the dispatcher, in a new run.
- No started request is retried in timeout, failure, missing-result, denial, or partial-effect cases.
- Normal success fits the three-hop corridor; correction cannot exceed its separate ceiling.
- Every live run has a finite whole-run deadline and stops before exceeding it.
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

#### Takeover contract — read-only toward canonical task state

Before exiting, the dispatcher must:

1. stop further launches;
2. capture partial effects and process/lease condition;
3. **leave canonical task state exactly as its owning actor left it.** The dispatcher writes no task state and makes no commit (§ 2, *The 2026-08-19 amendment*). Two cases, and the takeover must distinguish them:
   - **an actor already handed back** — a legal `status: blocked` / `turn: operator` record written and committed by the actor under its own role contract is canonical, and the takeover reports it; or
   - **the dispatcher detected the stop** because the actor did not hand back — canonical task state stays at its last valid actor-owned turn, and **the stopped run plus its durable terminal result constitute the takeover**;
4. atomically finalize the terminal result; and
5. render one compact handoff from validated facts containing:
   - attempted stage and actor;
   - exact stop classification;
   - whether a model request started;
   - state, HEAD, working-tree, changed-path, commit, process, owner, lease and deadline facts;
   - which of the two cases in step 3 applies, so the operator can see whether canonical task state carries the block or still sits at its last valid turn;
   - exact result, log, and capture paths;
   - current safety and any partial implementation; and
   - the exact decision and resume action required from Patrik.

The handoff is a view of canonical state and terminal evidence, not a second authority store, and not a source of canonical state.

*Cut on 2026-08-19 (§ 5): multi-choice recovery menus and recommendation logic. The handoff states the exact required action; choosing among alternatives is Patrik's.*

#### Read-only status

Status renders the operator-facing subset of trusted run evidence and canonical state, without raw-log reconstruction and without writing anything. It must show:

- task, checkout, current turn and stage;
- run ID, hop count, and remaining deadline;
- top-level actor and observed/unknown descendants;
- last terminal outcome and evidence path;
- state, owner, lease, HEAD, working-tree, and partial-effect classification; and
- the exact operator or recovery action required.

It must distinguish live, safely stale, conservatively pinned, partial-effect, and model-started-without-final-result conditions. After a dispatcher-detected takeover it renders the required operator action **from the durable terminal result**, because canonical task state is legitimately still at its last valid actor-owned turn; it must not read that as a runnable turn, and it must not repair or infer state to close the gap.

*Cut on 2026-08-19 (§ 5): cumulative usage reporting, and exhaustive rendering of facts the terminal result already stores.*

#### Resume contract

Resume requires:

1. Patrik's explicit recovery or permission decision;
2. that decision recorded in the new run's evidence — and in canonical task state only where an actor writes it under its own role contract;
3. a new run identity;
4. revalidation of task state, ownership, leases, Git facts, partial effects, runtime, authority, and budgets; and
5. continuation from the last valid turn and its durable next action, rather than replay of the failed request.

A denial is never automatically retried and never treated as approval. Repository drift while waiting causes another takeover with updated evidence. No actor launches while canonical task state carries a legal blocked/operator record, and none launches after a dispatcher-detected takeover until Patrik's explicit decision starts a new run.

#### Change-set acceptance

- Every mandatory stop ends further launches, finalizes exactly one durable terminal result, and renders one actionable handoff — and produces no dispatcher-authored task-state write and no dispatcher commit.
- Where an actor handed back, the takeover reports that actor-written blocked/operator record; where the dispatcher detected the stop, canonical task state is unchanged and the handoff says so.
- Status classifies the situation without writing anything, including after a dispatcher-detected takeover.
- Resume cannot proceed without a new explicit operator decision, a new run identity, and complete revalidation.
- A missing result or unknown teardown never triggers automatic retry, lease clear, or inferred completion.

### Change set D — Prove the complete supervised operating claim

Run the candidate in clean dedicated worktrees through the real dispatcher. Simulated controller tests remain necessary regression evidence but cannot satisfy these live trials.

#### Required live trials — the three original supervised shapes

Trimmed on 2026-08-19 to the three shapes the original 80/20 readiness report named, under Patrik's lean-release priority (§ 5, minimum release contract). The live programme is these three and no more:

1. **Normal path, repeated three times:** implementation, assessment, closure, and trusted completion without manual turn transport. **Run at least one of the three in an arbitrarily named supported linked worktree**, proving complete local runtime and identity there rather than as a separate live trial.
2. **Permission denial and approved resume:** deliberate denial, honest classification, read-only takeover with a durable terminal result, Patrik's explicit `acceptEdits` approval, and successful resume in a new run inside the dispatcher.
3. **Controlled interruption and partial-effect recovery:** terminate a live hop after an allowed effect; truthful status, no retry, no false completion, and deterministic recovery from repository truth.

Every trial records exact task/checkout, base and final HEAD, permission mode, actor/session identifiers, hop and deadline facts, state and working-tree before/after, changed paths, terminal result, capture path, operator intervention, and final verdict.

*Cut on 2026-08-19 as separate live trials — operator decision and resume, one correction, missing final result, genuine parallel isolation, crash-boundary recovery, hostile input, and control-field mutation.* Each remains a required **invariant**, proven deterministically by the regression gate below and by the Change set A suites; the § 5 table records where. Two consequences are stated rather than smoothed over: the § 3 residual risk on genuine two-task/two-worktree fan-out — proven at controller level only, accepted on Patrik's 2026-08-15 decision — **stands, and is not reclassified as proven by this trim**; and no cut trial's underlying safety requirement is removed from Gate SA.

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

- **ADOPT:** every revised Gate SA statement is proven;
- **SHRINK:** Patrik explicitly accepts a narrower operating envelope and release label; or
- **STOP:** a material reliability or feasibility failure remains.

Only ADOPT permits the label **Ready for supervised semi-agentic use**. The unqualified label **Reliable supervised semi-autonomous dispatcher** remains unauthorized by this plan.

## 6. Gate SA — final acceptance contract

The release passes only when all of the following are proven:

- every terminal path after run admission produces one durable atomic result with truthful actor-start and before/after facts;
- invalid pre-admission invocations fail through clear stderr and a nonzero exit while launching no actor, taking no owner or lease, mutating nothing and writing no evidence;
- missing evidence and zero-without-transition block rather than complete;
- actor-writable semantic state and trusted control facts obey one enforced ownership contract;
- an actor transition advances only after lifecycle, role, Git, proof, path, owner, lease, and transport validation;
- every success, block, failure, partial effect, correction, reconciliation, and closure path follows the accepted durable order and recovery classification;
- hostile identifiers, paths, protocols, and handbacks cannot execute content, escape roots, inject control facts, or change routing;
- the normal implementation-assessment-closure path completes without Patrik carrying turns;
- approved `acceptEdits` resumes inside the dispatcher without bypass permissions;
- no started model request is automatically retried;
- normal and correction paths obey their separate hop ceilings;
- the hop ceilings and the whole-run deadline prevent disproportionate continuation;
- linked worktrees pass only with complete local runtime and identity;
- status explains liveness, partial effects, last result, and safe recovery without raw-log reconstruction, and without writing anything;
- every non-routine stop ends further launches, finalizes one durable terminal result, and renders one actionable handoff — reporting the actor-written blocked/operator record where one exists, and otherwise saying plainly that canonical task state remains at its last valid actor-owned turn;
- the dispatcher authors and commits no canonical task state on any path;
- a permission denial is never automatically retried and never treated as approval;
- resume requires Patrik's decision, a new run, and complete revalidation, continuing from the last valid turn;
- nested-actor claims match actual enforcement and observation;
- the three required live supervised trial shapes pass, including three repeat normal runs and one in a linked worktree; and
- every invariant whose separate live trial was cut on 2026-08-19 remains green under the deterministic regression gate, and concurrency, durable-state, autonomy-authority, carrier, and Work Loop invariants remain green.

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
- Retain compact terminal results durably. **Cut on 2026-08-19 (§ 5):** raw captures need no retention policy, retention service or cleanup work in this release; revisit only if a required trial measures actual harm.
- If the shell implementation would require a second production parser, duplicated lifecycle semantics, or a pure transition that cannot be tested without the full dispatcher, extract that behavior behind one narrow helper interface. This is not authorization for a rewrite.

## 9. Stop conditions

Stop implementation and return to Patrik when:

- the post-merge baseline contradicts a load-bearing plan premise;
- a requirement needs a second state system, policy engine, general scheduler, or dispatcher rewrite;
- reliable recovery cannot be proven without reconstructing missing truth;
- a started request or persistent effect cannot be distinguished from a safe replay;
- actor-written content can alter trusted control truth;
- a required behavior cannot be built without the dispatcher authoring or committing canonical task state, which § 2's read-only takeover model and the executable core both forbid;
- process teardown cannot be classified honestly enough for supervised reuse;
- the plan must expand materially into Gate ST or Gate U;
- adequate live proof cannot be established; or
- any trial produces unsafe continuation or false completion.

## 10. Completion statement

This plan is complete only when one integrated candidate has passed Gate SA and the independent adoption review.

The accepted operating rule is:

> Continue automatically only while task identity, canonical state, evidence, authority, runtime, Git facts, ownership, leases, and budgets agree. Carry the fixed normal path without manual transport. Stop with durable actionable evidence whenever they do not.
