---
task: work-loop-v2-dispatcher-supervised-semi-agentic-use
status: active
turn: codex
---

## Objective and scope

Implement the approved revised plan at `plans/work-loop-v2-v0.2/work-loop-v2-dispatcher-reliable-supervised-use-implementation-plan-v0.1.md` through its complete revised Gate SA acceptance contract and independent adoption review, so the dispatcher may truthfully carry the label **Ready for supervised semi-agentic use — durable terminal results are guaranteed after run admission.**

Scope: the existing Work Loop v2 supervised dispatcher, its accepted helpers and runtime surfaces, focused proof, the required live trials, and the synchronous regression gate named by the plan. Excluded throughout: durable results for invalid pre-admission invocations; the unqualified **Reliable supervised semi-autonomous dispatcher** label; Gate ST; Gate U; unattended or walk-away release claims; a dispatcher rewrite or language migration; merge, push, deployment, destructive cleanup; and every other exclusion in plan §§ 4 and 7.

Task exit condition: one integrated candidate has passed the revised Gate SA and the independent review has returned `ADOPT`, or Patrik has explicitly chosen `SHRINK` or `STOP`.

## Lane and unit

Standard. Implementation mode. Unit 27 — make permission denial a legal operator takeover

Named reason for the loop: the approved objective spans multiple bounded implementation, proof and operating-trial units, must survive session boundaries, needs its scope held against overengineering, and requires independent Codex assessment before it counts as complete.

## Brief

Unit 26 is accepted at `74c0b6421c58dfe0431c834f89df73acc212d5e0`. Attended run evidence now records requested and runtime-observed effective permission modes independently, failing closed to `unavailable`. The remaining permission corridor is operational rather than observational: the approved plan requires a denied admitted run to stop further launches and enter legal operator takeover before a later explicit approval can resume it inside the dispatcher.

This unit implements only the denial-to-takeover half. It must turn existing trustworthy denial evidence into one canonical blocked/operator state and one actionable terminal handoff without replaying the request. Recording Patrik's later decision and resuming under `acceptEdits` is explicitly the next unit, not part of this one.

Dominant deliverable: make an attended Claude permission denial enter legal operator takeover with no further actor launch.
Evidence required in this hop: one targeted failing fake live denial before the edit; focused no-effect and allowed-partial-effect denial cases; validator-confirmed blocked/operator state; exactly one complete terminal result; proof no second actor starts.
Evidence explicitly deferred: recording the operator's approval and resuming under `acceptEdits`; live model observation; enforcement of unavailable/mismatched effective mode; all non-permission takeover classes; status rendering; retry and budget work; complete runtime preflight; nested-actor remainder; full regression; Change sets B remainder, C remainder and D; adoption review; capture-retention policy; merge, push, deployment and destructive cleanup.
Primary edit begins after: a fake attended Claude denial produces exit 37 but leaves canonical task state active rather than `status: blocked`, `turn: operator`.

Required outcome:

- For an admitted attended Claude hop whose trusted capture reports a permission denial, stop before any later actor launch and transition the canonical task record to the validator's legal `BLOCKED_OPERATOR` shape.
- Preserve the existing objective and current task truth while setting one concise blocker and next action that state: the denied tool/target, whether partial effects exist, the permission decision Patrik must make, and that resume is deferred to the dispatcher resume unit rather than available through an interactive bypass.
- Finalize exactly one durable terminal result after the blocked state is durable. Preserve the truthful actor-start, requested/effective permission, denial, path, partial-effect and result-completeness facts already produced.
- Cover both a denial with no repository effect and a denial after an allowed partial effect. The latter must name the existing trusted partial-effect evidence rather than treating the run as clean.
- Do not infer approval, change permission mode, resume, retry, clear owner/lease unsafely, launch Codex, alter unattended behavior, or generalize this into every Change set C takeover class.

Check against repository:

1. Verify the current exit-37 denial path, its terminal ordering, and the nearest existing canonical-state mutation/validation helper before editing; treat the rest of Unit 26 as settled.
2. Reuse the existing fake live denial, terminal-result, validator, launch-count and partial-effect fixtures. No new harness or second state writer.
3. If a legal blocked/operator transition cannot be made without violating the accepted trusted control-field ownership or durable ordering contracts, stop and hand back rather than bypassing them.

Required fail-capable evidence:

- Quote the pre-edit failure showing exit 37 with state still active.
- Show no-effect and allowed-partial-effect denials both validate as `BLOCKED_OPERATOR`, finalize one complete result, and launch no later actor.
- Show the partial-effect case remains visibly partial and names the changed path; it must not collapse to the clean case.
- Show a non-denial control preserves its existing classification and state behavior.
- Run only the new and directly affected focused cases, with exact commands/counts. Defer the full suite.
- Report one implementation commit touching only `dispatch.sh`, `dispatch.test.sh`, and this state file; leave `logs/friction-log.md` unstaged.

Capability subset: baseline only — read, inspect, focused local tests, edits inside the dispatcher implementation/tests and this state file, and a local commit by Claude. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No live model/network, operator-reserved capability, merge, push, deployment or destructive cleanup.

Completion condition: one committed implementation handback makes attended permission denial a legal, durable operator takeover for clean and allowed-partial-effect cases, starts no later actor, preserves existing result truth, changes only the bounded files, and returns with `turn: codex`.

Stop and hand back if this needs the resume implementation, a new state store/writer, weakened ownership or durable ordering, live model/network access, unattended changes, or broad Change set C machinery.

## Latest result

Unit 27 did not begin. Its required outcome cannot be built without creating the first canonical-state writer outside the actors, which the brief's own stop condition, the approved plan's own ownership contract and the executable core each independently forbid. No production, test or plan file was changed; `git diff` against `dispatch.sh` and `dispatch.test.sh` is empty.

Inspected (2026-08-19):

- Claim (1): HOLDS, and it is what surfaces the problem. The exit-37 denial path is `dispatch.sh:4991`, inside the post-hop block at 4986–4993: it runs after the out-of-allowlist guards (24, 30) and before 25/36/22, calls `die_hop 37`, and `die_hop()` (3574) is a thin alias for `die()`, which finalizes exactly one terminal result and exits. Terminal ordering is therefore already correct for a stop. The **canonical-state mutation helper the claim asks me to verify does not exist.** Searched `logs/scripts/` for a writer: `work-loop-state.sh` is the nearest helper and its own header states "It NEVER writes, never repairs, and never becomes a second state store"; it accepts one subcommand, `validate` (line 90), and holds no output redirection into the state file at all. Searched `dispatch.sh` for any write to `$STATE_FILE`: every occurrence is a read, a hash, a path report or a die() message — the file's own accepted contract at lines 3982–3983 says "Read-only throughout. This dispatcher never writes the state file; only the actors do (core § 4 — Claude commits, Codex writes the brief)."
- Claim (2): HOLDS — the fixtures the brief names all exist and no new harness would have been needed for the *proof*: the fake live denial is case 72e's `FAKE72` plus a `permission_denials`-bearing stream (added at Unit 26); the simulated denial is case 43 (5793); launch counting is `calls()` (292); partial-effect evidence is `seed_impl()` (5599) and `partial_section()` (5616); terminal-result and validator readers are `res_field()`/`run_id_of()`/`expect_rc()` (314–333) and the sandbox-copied `work-loop-state.sh`. The blocker below is not a test-surface problem.
- Claim (3): **FALSE — its stop condition is met, so the unit stops here.** The claim reads "If a legal blocked/operator transition cannot be made without violating the accepted trusted control-field ownership or durable ordering contracts, stop and hand back rather than bypassing them." It cannot. The approved plan's own **Trusted field ownership** section (`work-loop-v2-dispatcher-reliable-supervised-use-implementation-plan-v0.1.md`, lines 178–184) divides the two columns explicitly: "actors may change only their accepted semantic task fields and role-owned commits" and "the dispatcher and accepted helpers exclusively own run identity, permission approval, budgets, runtime facts, observed Git/process facts, owner/lease mutation, and terminal results." Canonical task state is in the actors' column and is absent from the dispatcher's. Change set C's takeover contract at line 304 nevertheless instructs the dispatcher to "write one legal canonical record: `status: blocked` / `turn: operator`". Those two sections of the same approved plan disagree, and Unit 27's required outcome is built on the second.
- Packaging lines: HOLD — one `Dominant deliverable:`, both evidence lines filled, and `Primary edit begins after:` present as Implementation mode requires. The packaging is not the problem either.

Evidence that this reading is fail-capable, in both directions: had `logs/scripts/` carried any state-mutation helper, or had the plan's ownership list included canonical task state, or had the plan anywhere claimed to amend the executable core, the unit would have proceeded. Searched the plan for `courier`, `core §`, `executable core`, `Claude commits` and `every commit`: one hit only, line 254, which merely lists the executable core among artifacts in scope. The plan does not claim to amend the core.

## Blocker

**Unit 27 requires the dispatcher to become a canonical-state writer, and three separate accepted authorities say it must not be one. The brief's own last line already names this as a hand-back: "Stop and hand back if this needs ... a new state store/writer, weakened ownership or durable ordering."**

1. **The approved plan contradicts itself.** Trusted field ownership (lines 178–184) places canonical task state with the actors and gives the dispatcher and its helpers everything except it. The Change set C takeover contract (line 304) requires the dispatcher to write `status: blocked` / `turn: operator`. Both were approved; only one can be built.
2. **The executable core forbids it twice, independently of the plan.** § 4's courier clause says a courier "may never ... change the task, the brief, the result, or any other content of the state file" and may never "choose which actor moves next, or decide that a turn exists", with the test stated as "whether removing the courier changes any decision: if it does, it was never transport" — and writing blocked/operator is a decision. § 4's *Who commits* rule, an operator decision of 2026-08-01, says "Claude makes every commit"; a blocked record that is not committed is not durable, and the dispatcher itself dies 25 on an uncommitted state file (`dispatch.sh:4666`), so an uncommitted takeover record would create the exact broken state the next run refuses.
3. **The core already assigns this write to the actor.** § 7 *Stop for the operator* — "a permission or capability decision is required" is one of its classes — says the **actor** writes the question into `## Blocker`, sets `status: blocked` and `turn: operator`, commits, and stops. Unit 27 does not add a missing behaviour; it moves an existing one from the actor to the transport. The reason it looks missing is narrower and worth stating: on a permission denial the child exits 0 *without* having written it, so the write that the core assigns to Claude never happened.

I am not resolving this. Deciding that the dispatcher may write and commit canonical state would change core § 4's courier clause and reopen the operator's 2026-08-01 commit decision — an operator-owned class under core § 7 — so it is not mine to take, and it may not be Codex's either.

What I did **not** do, deliberately: no state writer was added, no ownership contract was weakened, no `dispatch.sh` or `dispatch.test.sh` edit was made, and exit 37's current behaviour is untouched.

## Next action

Codex: decide how Unit 27 is reframed, or escalate it. Three routes are visible from the repository, and the first two are within your framing authority:

1. **Keep the dispatcher read-only and move the write to the actor.** Exit 37 already stops and finalizes a terminal result; what is missing is the blocked/operator record the core assigns to Claude. A unit that has the dispatcher render the takeover handoff and stop — leaving the canonical transition to Claude on a subsequent hop, or to the operator — needs no new state writer and violates nothing. It does not satisfy Change set C line 304 as written.
2. **Reframe as a Discovery unit on the conflict itself.** The deliverable would be the authority question: which of the plan's two sections governs, what the core would have to say for a dispatcher write to be legal, and what the smallest legal takeover looks like. That is evidence, not a build, and it is the honest shape given that the plan disagrees with itself.
3. **Escalate to Patrik.** Required if the answer is that the dispatcher genuinely should own canonical-state writes, because that changes the policy governing agent authority and reopens an operator decision. Codex cannot grant it and neither can I.

Also carried forward from Unit 26 and not yet dispositioned: attended hops now capture the full event stream, so capture volume rises on every attended hop (~68KB for one short probe hop; attended hops run 26+ turns). Recorded as an operating cost to measure in the required trials.
