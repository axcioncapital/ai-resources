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

**Final tightly-bounded fix on the one residual: an unestablished lease holder is no longer reported as another holder. Pre-fix HEAD `4053e320`, branch `session/2026-08-16-dispatcher-last-fixes`.**

Reproduced by inspection first. `wl_lease__read_holder()` at `logs/scripts/work-loop-lease.sh:174-180` is four `cat`s with `2>/dev/null`, so an absent, unreadable or empty `pid` file leaves `WL_LEASE_HOLDER_PID` empty. In `result_lease_status()` that empty value failed the `[ "$pid" = "$$" ]` comparison and fell straight through to `printf 'held-by-other'` — a claim that a second holder exists, made from metadata that was never read. Reproduced as a failing case as well: `50g` against the pre-fix dispatcher returns `held-by-other`.

Fixed inside the existing seam, one branch, no new helper and no reader: `if [ -z "$pid" ]; then printf 'held-holder-unavailable'; return 0; fi`, placed before the ownership comparison and applied unconditionally — a run that believes it owns the lease still cannot read a holder record that is gone. The directory's *existence* stays established, so this is not `free`; what is unavailable is who holds it, which is the distinction the bounded-token vocabulary already draws. Nothing else in `result_lease_status()` changed: `missing`, `free`, `pinned`, `held-by-this-run` and `held-by-other` classify exactly as they did.

Evidence — same extracted-driver method, `REPO_ROOT` and `DISPATCH_BIN` passed explicitly, against the real `dispatch.sh`:

- **RED, pre-fix (`git show HEAD:…/dispatch.sh` at `4053e320`):** case 50 at **98 pass / 3 fail**, and all three reds are this residual: `50g — an unreadable holder is reported as explicitly unavailable` got `held-by-other`; `50g — it is neither 'held-by-other' nor 'held-by-this-run'` got `held-by-other`; and the M8 control reporting `the sed matched nothing — the control cannot run`, because the branch it mutates did not exist yet.
- **GREEN, after:** case 50 at **102 pass / 0 fail**. Every assertion from the accepted unit and from the correction round passes unchanged — 50a, 50b, 50c (M1–M3), 50d both paths, 50e, 50f (M4–M6) are all still green, so the focused surface this fix touches did not break.
- **50g, the focused control:** M7 redirects only the *reported* task-lease path to a sibling directory the case creates with no holder metadata in it, exactly as M5 stages its own condition; acquisition and release still run through the library's own variables. The case first asserts the staged directory exists and carries no `pid` file — otherwise it would be proving nothing — then asserts the field reads `held-holder-unavailable`, and separately asserts it is neither of the two values that would each assert a fact.
- **M8, the fail-capability control:** the same staged directory with the new branch removed, which is the classification as it stood before this fix. It reports `held-by-other` for a holder it never read, so 50g's assertions can fail.
- **No broad regression block was rerun**, as the final-fix boundary requires. The 233/0 lease-and-ownership plus `--status` block from the correction round stands as the last broad evidence, taken at `4053e320`; this fix changes one branch inside `result_lease_status()`, which that block does not reach except through the terminal record the focused cases cover.

**Correction round on the two frozen findings, carried forward. Pre-correction HEAD `ae2bc22bdfc66bff8e7b43a429e2ac3027cf6bdf`.**

Both findings were reproduced by inspection before anything was changed, and both were then reproduced as failing assertions against the pre-correction dispatcher.

- **Finding 1 — REPRODUCES.** `HOP_BASELINE_READY=1` is set at `dispatch.sh:2959` (pre-correction numbering) immediately before `launch_actor "$before_turn"` at 2962. `launch_actor()` carries four `die()` sites that run before `run_bounded()` forks anything: `die 20` on a non-executable `CODEX_BIN` (2642), `die 20` on an unresolvable `CLAUDE_BIN` (2653), `die 11` on a failed `cd "$CHECKOUT"` (2684), `die 15` on an unrecognised actor (2757). All four are funnelled D–L terminals, and all four reported `actor_launched=yes` with `stage=post-hop`; in live mode they also reported `model_request_started=yes`. Reproduced as a failing case: `50d` against the pre-correction dispatcher returns `actor_launched=yes`, `model_request_started=yes`, `stage=post-hop`.
- **Finding 2 — REPRODUCES.** Searched the pre-correction record for an owner field: `owner` appears nowhere in `finalize_terminal_result()`; only `lease_task_dir`, `lease_checkout_dir` and the literal `tr_kv lease_at_finalization held` were written. Reproduced as failing assertions: `owner_check` and `owner_declared` both `<absent>`, and both lease-status fields `<absent>`.

**Result: both frozen findings are corrected. The launch, model-request, owner and lease fields are now derived from dispatcher-owned observations, and the ordering-derived constant is gone.**

*Finding 1.* A new global `ACTOR_PROCESS_STARTED` is set in `run_bounded()` on the line after `pid=$!` — the one place in the program where a child is forked, and the place every launch path funnels through while none of the four pre-fork `die()`s do. It is monotonic on purpose: it answers "did an actor process run at some point in this run", so a hop-2 pre-fork stop after a completed hop 1 still reports the launch that really happened. `actor_launched` and `permission_mode_requested` are now gated on it rather than on `HOP_BASELINE_READY`. `stage` gains a third value, `launch`, for the case the correction exposed — baseline live, no fork — leaving `post-hop` to mean an actor actually ran. `model_request_started` is `no` when nothing forked (established and absent) and **`unavailable` on a live fork**: starting the product's CLI is not evidence that the CLI issued a model request, and the only surface that would establish it is the child's own stream events, which the deferred reader owns and which the trusted-field contract forbids using for framing here. `yes` would have been the same guess the correction removed from `actor_launched`.

*Finding 2.* Four fields replace the one constant. `owner_check` records the ownership admission verdict at the check itself (`proceed` / `refused` / `ambiguous` / `check-failed` / `unavailable`), with `unchecked` as the honest value for a terminal reached before that check — `validate_state()` dies above it, so `unchecked` is reachable, not decorative. `owner_declared` reads the checkout's declaration through a new `owner_declaration()`, which the `--status` branch now also calls: one reader for two consumers, so the operator's screen and the record cannot disagree (plan § 8, the same split `partial_effect_paths()` got). `lease_task_at_finalization` and `lease_checkout_at_finalization` are read by `result_lease_status()` from the lease directories themselves — `held-by-this-run` requires both the run's own OWNED flag and a recorded holder pid equal to `$$`, with `pinned`, `held-by-other`, `missing`, `free` and `unavailable` as the other observed answers. The library's holder globals are saved and restored around its reader so the reporting path cannot rewrite shared state.

Evidence — the same extracted-driver method as the unit itself: the suite's prelude (lines 1–344) plus only the block under test, `REPO_ROOT` and `DISPATCH_BIN` passed explicitly, run against the real `dispatch.sh`.

- **RED, pre-correction (`git show HEAD:…/dispatch.sh`), same driver:** case 50 at **77 pass / 17 fail**. The load-bearing reds are exactly the two findings: `50d — actor_launched=no` got `yes`; `50d — model_request_started=no` got `yes`; `50d — stage=launch` got `post-hop`; `50d — claude path: permission_mode_requested=none` got `default`; `50e — owner_check=refused` and `50e — owner_declared=decoy-alpha` both `<absent>`; both `lease_*_at_finalization` assertions empty. The three new mutation controls report `the sed matched nothing — the control cannot run`, because the code they mutate does not exist yet.
- **GREEN, after:** case 50 at **96 pass / 0 fail**. Every 50a/50b/50c assertion from the accepted unit still passes unchanged apart from the two lease-field names.
- **50d, the pre-fork control (finding 1), two paths:** `--codex-bin <absent>` with no `--actor-cmd` → exit 20, `calls=0`, one complete result carrying `outcome=ACTOR_FAILED code=20 mode=live actor=codex actor_launched=no model_request_started=no stage=launch hop=1 permission_mode_requested=none`. The claude path with `--claude-bin <absent>` → `actor=claude actor_launched=no stage=launch permission_mode_requested=none permission_mode_effective=unavailable`. It is still controller evidence with no live product transport: the run is in live mode and stops on a path that does not exist, so nothing is executed and no model is contacted.
- **50e, the owner/lease control (finding 2):** a checkout whose `.owner` declares `decoy-alpha` while the run is on `owner-refused-task` → exit 33, `calls=0`, one result carrying `outcome=OWNERSHIP_REFUSED code=33 owner_check=refused owner_declared=decoy-alpha actor_launched=no stage=pre-hop` and both leases `held-by-this-run`. Paired with 50a's `owner_check=proceed owner_declared=none`, the two cases observe two different values for each owner field, so neither can be a constant that happens to look right. The lease it reported holding is confirmed gone from disk after the run, so `held-by-this-run` is not being written over an already-released lease.
- **Three new mutation controls, all confirmed fail-capable:** M4 restores the `HOP_BASELINE_READY` proxy → the 50d scenario claims `actor_launched=yes`, which is the defect. M5 misdirects only the *reported* task-lease path (`LOCK_DIR="$WL_LEASE_TASK_DIR.absent"`; acquisition and release still run through the library's own variables) → the status tracks the filesystem and reports `missing`. M6 is M5 plus the observation replaced by the old constant → it reports `held-by-this-run` for a lease that is not on disk, which is exactly what a hard-coded field would have gone on doing and what M5 catches.
- **Directly affected regression block, 233 pass / 0 fail:** the whole lease-and-ownership admission block (cases 12 through 12h-ok, including the cross-transport 12e series, the absent-helper 12d and absent-library 12f fail-closed cases) and the whole `--status` block (cases 30 through 30i, including the read-only and takes-no-lock assertions and the holder-identity rendering that now goes through `owner_declaration()`). These are the two surfaces this correction edited outside the producer.
- **An earlier extraction of that block ran 218/15 and the 15 were an artifact of the slice, not a regression:** the same driver returned the identical 15 failures against the pre-correction dispatcher, and the cause was in the output — `lock_path_for: command not found`, a helper defined at line 1997, outside the sliced range. Including that definition returned the block to 233/0. Recorded because a reader who saw only the second number could not tell a repaired extraction from a repaired defect.

Carried forward from the accepted unit and still true: `finalize_terminal_result()` runs from `die()` after the STOP message reaches both channels and before `release_lock`; it writes bounded `key=value` lines to `$LOG_DIR/$RUN_ID.result.partial` and `mv -f`s them to `$LOG_DIR/$RUN_ID.result`; `result_complete=yes` is the sentinel last line and `RESULT_FINALIZED` makes it idempotent; `unavailable` and `none` remain distinct tokens; `permission_mode_effective`, `recorded_usage` and `actor_session_id` remain unconditionally `unavailable`.

**One judgment call inside finding 1, disclosed and now settled.** `permission_mode_requested` was also gated on the observed fork, though the finding named only the actor and model-start fields. It is the same false claim from the same proxy — on the pre-correction dispatcher a claude run that stopped on an unresolvable binary reported `permission_mode_requested=default`, a mode requested of a child that was never created — and the red run above shows it. **Codex accepted it as part of frozen finding 1** at the closure check, so it is no longer open.

Deferred and untouched, as the correction boundary requires: lease failure recovery; missing-result blocking; crash-boundary injection and the full write-order/recovery contract; the reader/validator and hostile-result parsing; families A–C, M, N; Change sets B–D; the full dispatcher and Gate SA regression matrices; live trials; adoption review.

Candidate deferrals, recorded and **not** implemented:

- `permission_mode_requested` is still read back from the launch path's shape rather than recorded at launch, so it would drift if a future edit changed the literal `--permission-mode default` without touching the producer. Carried unchanged from the accepted unit; it is Change set B's permission-transport work.
- `changed_paths_since_launch` is still computed whenever `HOP_BASELINE_READY` is set, so at the new `stage=launch` it reports a delta measured against a baseline no actor ever ran against. The arithmetic is honest and the value is what the operator is shown; the field *name* is loose in a case that did not exist when it was written. Newly noticed in this round, so it is a deferral, not a second correction.

## Blocker

None.

## Next action

Codex: run the closure check on the final tightly-bounded fix only — is the residual part of frozen finding 2 resolved (an unestablished lease holder is no longer reported as another holder), and did this fix break its focused surface? Nothing else is reopened: finding 1 is settled, the `permission_mode_requested` fork gate is accepted, and both candidate deferrals below are preserved unchanged.

Pre-fix commit `4053e320af97ed3fdb2b9fbe5df9f36f88e5e2c6`; the final-fix commit is the one carrying this revision of this file, so it cannot name its own hash — read it as `HEAD` on `session/2026-08-16-dispatcher-last-fixes`. Committed paths: `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, and this task state file — only those three; `logs/friction-log.md` remains modified and uncommitted as instructed. No broad regression block was rerun, as the boundary required.
