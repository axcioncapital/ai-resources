---
task: work-loop-v2-dispatcher-reliable-supervised-use
status: active
turn: codex
---

## Objective and scope

Implement `plans/work-loop-v2-v0.2/work-loop-v2-dispatcher-reliable-supervised-use-implementation-plan-v0.1.md` through its complete Gate SA acceptance contract and independent adoption review, while preserving the plan's fixed supervised-use boundary.

Scope: the existing Work Loop v2 supervised dispatcher, its accepted helpers and runtime surfaces, focused proof, live trials, and the synchronous regression gate named by the plan. Excluded throughout: Gate ST, Gate U, unattended or walk-away release claims, dispatcher rewrite or language migration, merge, push, deployment, destructive cleanup, and every other exclusion in plan §§ 4 and 7.

Task exit condition: one integrated candidate has passed Gate SA and the independent review has returned `ADOPT`, or Patrik has explicitly chosen `SHRINK` or `STOP`.

## Lane and unit

Standard. Implementation mode. Unit 5 — produce trusted results from the die funnel.

Named reason for the loop: the objective spans multiple bounded implementation and proof units, must survive session boundaries, and requires independent Codex assessment before it can count as complete.

## Brief

Change set A remains the active plan phase. Unit 4 is accepted at `b6a85f59b7e7b1ada9a5b16d570c379c10f841ee`: its bounded inventory established that terminal families D–L already reach `die()`/`die_hop()`, while pre-run refusals, lease refusal, signal handling, and zero exits bypass that seam and remain separate later integrations. Implement only the trusted terminal-result producer for the existing D–L funnel now; do not migrate any bypass or add the result reader in this unit.

Dominant deliverable: one versioned, run-bound, atomically finalized dispatcher-owned terminal result for every D–L nonzero terminal already funnelled through `die()`.
Evidence required in this hop: a targeted red/green proof shows an exit-22 post-hop stop produces exactly one complete trusted result with truthful required fields, while one focused pre-hop control proves unavailable fields remain explicit and do not break an earlier `die()` stop.
Evidence explicitly deferred: terminal families A–C, M, and N; moving run identity earlier; the result reader/validator; hostile-result parsing and schema-version rejection on read; missing-result blocking; fake-result consumption tests; durable crash-boundary injection and the full write-order/recovery contract; Change sets B–D; the full dispatcher and Gate SA regression matrices; live trials; adoption review; adjacent routing defects; merge, push, deployment, and destructive cleanup.
Primary edit begins after: add and run one focused case, modelled on the existing case-6 fixture, that expects an exit-22 actor-started run to leave exactly one complete run-bound terminal result and fails because no such result exists today.

Required outcome: the existing `die()` production seam finalizes exactly one bounded machine-readable result before it releases the live lease and exits, for the D–L calls that already reach it. The producer must choose and report one exact run-bound result path, publish the final artifact atomically, avoid leaving a final artifact that is partial or multiply finalized, and derive its trusted fields only from dispatcher-owned observations and constants—not actor prose, raw output, or an actor-created lookalike.

The result schema in this first producer unit must be versioned and must represent the Change set A item-4 contract honestly at the current boundary: task, checkout, run, stage, actor, outcome/reason and exit code; whether a model request started; state and HEAD before/after; working-tree or changed-path classification; requested and observed/effective permission mode; hop count and deadline; recorded usage and actor/session identifier when available; log and capture paths; owner/lease status at finalization; and the next required action. A fact not established at that terminal must carry one explicit bounded unavailable/unknown state rather than being omitted, guessed, reconstructed from narrative, or promoted from a requested property to an effective one. Recording the current requested mode (`default`) and an unverified effective mode is evidence reporting, not authorization or implementation of Change set B's future `acceptEdits` transport.

Governing authority and settled evidence:

- The active content-bound-approved plan governs, specifically Change set A's *Required behavior* items 1–4 and 8, *Trusted field ownership*, and the fixed Gate SA boundary. The plan's durable-ordering crash matrix and hostile-input reader work remain explicitly deferred above.
- Unit 4's source inventory is accepted with one precision correction: `die()` is the shared funnel for D–L, not for every post-admission nonzero terminal, because `on_signal()` is a documented bypass. Carry the D–L table and do not carry the overbroad sentence.
- `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` and `dispatch.test.sh` are the only implementation and regression paths permitted. Unit 4 established that the first producer does not trigger the plan § 8 narrow-helper condition; verify that remains true against the live bytes before editing.
- The activation suites and Unit 3 approval checks are settled evidence and must not be rerun. The full dispatcher suite is deferred from this narrowly packaged unit.

Check against the repository before editing:

1. Verify the live D–L calls still converge through `die()` or the `die_hop()` alias, and that families A–C, M, and N still bypass it. If the seam changed after `b6a85f59b7e7b1ada9a5b16d570c379c10f841ee`, hand back rather than silently widening the unit.
2. Verify the run/evidence initialization still precedes D–L and that the focused exit-22 fixture can observe one run ID and evidence directory without changing production control flow.
3. Verify no second lifecycle reader or production parser is needed to write this result. If a new helper, parser, or third source/test path is materially necessary, hand back with the evidence instead of adding it.

Required fail-capable evidence:

- quote the targeted exit-22 case red before the primary edit because no final result exists, then green after the edit with exactly one final artifact, no leftover temporary artifact, a recognized version, and the required truthful fields;
- exercise one existing pre-hop `die()` family in a focused control and show it finalizes once with unavailable fields explicit, rather than failing under unset state or inventing post-hop facts;
- show a bounded mutation or failure control that would go red if finalization were skipped, duplicated, or exposed a partial final artifact;
- show the producer's trusted fields come from dispatcher state and that actor output cannot supply the result framing;
- report pre-unit and handback commits and exact committed paths; and
- prove only `dispatch.sh`, `dispatch.test.sh`, and this task state changed. `logs/friction-log.md` was already modified outside this unit and must remain untouched and uncommitted.

Capability subset: baseline only — read/search the active plan and accepted Unit 4 state, inspect local Git history where a seam claim requires it, edit only `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, and this task state, run focused local checks, and make the local handback commit. The baseline deny set is required in full. Nothing is selected from the pre-authorizable set, which is empty today. No operator-reserved capability is needed.

Completion condition: one local commit implements the D–L terminal-result producer, the focused fail-capable proof is green, no bypass family or reader is integrated, no full regression matrix is run, only the three permitted paths change, and the task hands back with `turn: codex`.

Stop and hand back without widening if the D–L seam is false, required trusted facts cannot be represented without guessing, atomic finalization cannot be shown in the focused boundary, a new production parser/helper is required, or any deferred terminal family, reader, plan change, or extra repository path becomes necessary. Challenge a false premise rather than building around it.

## Latest result

Inspected (2026-08-17), pre-unit HEAD `b6a85f59b7e7b1ada9a5b16d570c379c10f841ee`:

- **Packaging lines:** HOLD. All four required for Implementation mode are present and non-empty at brief lines 25–28; `Dominant deliverable:` names exactly one deliverable.
- **Claim (1) — D–L still converge through `die()`/`die_hop()`, A–C, M, N still bypass:** HOLDS. `git diff --stat b6a85f59 -- dispatch.sh dispatch.test.sh` is empty, so the seam is the inspected one. Verified independently of that: searched `dispatch.sh` for `exit [1-9]` — every direct nonzero exit site is family A (433–486), B (489–492, 664–676, 848, 1579, 1584), C (`refuse_17` 841) or M (`on_signal` 1383); no other nonzero terminal exits without `die()`. `die_hop()` at 2019–2021 is still a bare alias for `die()`. Searched for `exit 0` — five sites (432, 1560, 2610, 2642, 2883), family N, all bypassing. Searched for `trap ` — the EXIT trap is `release_lock` only, so it adds no sixth exit owner.
- **Claim (2) — run/evidence initialization precedes D–L:** HOLDS. `LOG_DIR` created 1578–1590, `RUN_ID` composed 1607, `RUN_LOG` truncated 1609. Searched for every `die`/`die_hop` call site: the lowest-numbered is line 1794, so **every** D–L terminal has `RUN_ID` and `LOG_DIR` set. The focused fixture observes the run ID from the dispatcher's own `run=` log line rather than reconstructing it, and production control flow is unchanged.
- **Claim (3) — no second lifecycle reader or production parser needed:** HOLDS. Every field written is an already-assigned dispatcher global (`TASK`, `CHECKOUT`, `RUN_ID`, `MODE`, `CUR_HOP`, `CUR_ACTOR`, `ST_TURN`/`ST_CLASS` from the one canonical validator, `before_hash`/`after_hash`, `before_head`/`after_head`, `DEADLINE`/`DEADLINE_AT`, `RUN_LOG`, `LAST_CAPTURE`, `LOCK_DIR`, `CHECKOUT_LOCK_DIR`) or a constant table defined in the producer. No handback is parsed, no state file is re-read, no helper was added. Plan § 8's narrow-helper condition does not fire.

**Result: the `die()` funnel now finalizes exactly one versioned, run-bound, atomically published terminal result for the D–L families, and nothing else was migrated.**

`finalize_terminal_result()` is called from `die()` after the STOP message reaches both channels and **before** `release_lock`, which is the plan's durable ordering — a lease is released only once the result exists. It writes 37 bounded `key=value` lines to `$LOG_DIR/$RUN_ID.result.partial` and `mv -f`s it to `$LOG_DIR/$RUN_ID.result`, so a reader sees a complete record or none. `result_complete=yes` is the sentinel last line; `RESULT_FINALIZED` makes it idempotent; the path is printed to stderr and the run log. One existing function was refactored, not duplicated: `partial_effect_paths()` was split out of `partial_effect_block()` so the record counts the same delta the operator is shown (plan § 8, one owner per seam).

Two bounded tokens carry unestablished facts and are **not** synonyms: `unavailable` (the dispatcher cannot establish it here) and `none` (established and absent). `permission_mode_requested` reports the launch path's constant; `permission_mode_effective` is unconditionally `unavailable` — never promoted from the request. `recorded_usage` and `actor_session_id` are `unavailable` at every terminal, as Unit 4 established.

Evidence — focused red/green, both run from an extracted driver carrying the suite's own prelude (lines 1–344) plus only the case under test, against the real `dispatch.sh`:

- **RED, before the primary edit:** case 50 at **12 pass / 39 fail**. The load-bearing red: `50a — the actor's planted SUCCESS result did not become the trusted result` failed with `got outcome=SUCCESS code=0`. The actor had planted a lookalike at the exact run-bound path by globbing the run log, and it was what a reader would have found. Also red: no result at the run-bound path (50a, 50b), every required field `<absent>`, and all three mutation controls reporting `the sed matched nothing — the control cannot run`.
- **GREEN, after:** case 50 at **55 pass / 0 fail**. `outcome=NO_TRANSITION code=22 actor_launched=yes` overwrote the planted `SUCCESS`; one version line; first line the schema version; last line the sentinel; no `.partial` survivor; every line matching `^[a-z][a-z0-9_]*=`.
- **Pre-hop control (50b), exit 18 `FOREIGN_UNSTAGED`, no actor launched:** finalizes once with `stage=pre-hop actor=none actor_launched=no hop=0`, `state_sha256_before/after=unavailable`, `head_after=unavailable`, `capture=none` — explicit, not omitted, and no abort under `set -u`. It cannot pass by blanking everything: `worktree_foreign_paths=1` counts the path it actually stopped on, and `state_class=ACTIVE_CODEX` carries the validator's classification.
- **Three mutation controls, each a sed-mutant of the real dispatcher, all confirmed fail-capable:** M1 removes the `finalize_terminal_result "$code"` call → exit 22 with zero results. M2 removes the `mv -f` → one `.partial` exposed, zero final. M3 drops `$RUN_ID` from the path → two runs collapse onto one artifact, while the unmutated dispatcher keeps both apart (2 results).
- **Regression protection for the one refactored function:** the suite's whole partial-effect block (cases 40–49, including the O2 attribution cases 41b, 42c, 44, 45 and the clean-hop negative 46) runs **51 pass / 0 fail** against the refactored dispatcher.
- **Plan item 8 control:** `--status` still writes nothing — working tree byte-identical afterwards and no `runs/` directory created. The producer's `RUN_ID` guard is what keeps that structural, since the status branch exits above the run-evidence block.

Deferred and untouched, as the brief requires: families A–C, M, N; the reader/validator and hostile-result parsing; missing-result blocking; crash-boundary injection and the full write-order contract; Change sets B–D; the full dispatcher and Gate SA regression matrices; live trials; adoption review.

One adjacent improvement noticed and **not** done: `permission_mode_requested` is read back from the launch path's shape rather than recorded at launch, so it would drift silently if a future edit changed the literal `--permission-mode default` at `dispatch.sh:2498` without touching the producer. Making the mode a variable set at launch is Change set B's permission-transport work and belongs there, not here.

## Blocker

None.

## Next action

Codex: assess Unit 5. Pre-unit commit `b6a85f59b7e7b1ada9a5b16d570c379c10f841ee`; the handback commit is the one carrying this revision of this file, so it cannot name its own hash — read it as `HEAD` on `session/2026-08-16-dispatcher-last-fixes`. Committed paths: `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, and this task state file — only those three; `logs/friction-log.md` was left modified and uncommitted as instructed.
