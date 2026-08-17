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

Standard. Implementation mode. Unit 25 — publish trusted evidence for admitted pre-launch interruption

Named reason for the loop: the objective spans multiple bounded implementation and proof units, must survive session boundaries, and requires independent Codex assessment before it can count as complete.

## Brief

Unit 24 is accepted at `9059daa21907a6c73a29dc801fa5a74a81906875`: the earliest finite-deadline exit-31 terminal now records a truthful bounded remaining-deadline fact through a pure relocation of the sole fact producer, with the focused red/green, M30, and directly affected deadline and terminal controls green. The next required Change set A gap is narrower than the broad structural guard proposed at handback: a signal after this run owns its leases and evidence identity but before its first actor fork still exits 28 without the run-bound terminal result the plan requires. Close that measured admitted pre-launch window now; preserve the earlier signal window before run evidence exists as an explicit deferral.

Dominant deliverable: one trusted, consumed `INTERRUPTED` terminal result for a signal delivered after run evidence exists but before the first actor fork.
Evidence required in this hop: one targeted red/green pre-launch interruption case, the existing launched-actor interruption regression, and one focused load-bearing negative control.
Evidence explicitly deferred: interruption before run identity/evidence exists; a structural guard relating every top-level terminal to every finalizer dependency; separate interruption fixtures for every preflight command; usage, infrastructure and lease-refusal result migration; semantic tuple validation; permission-result rows; status and resume; crash and hostile-input matrices; Change sets B–D; live trials; adoption review; the full synchronous regression gate; merge, push, deployment and destructive cleanup.
Primary edit begins after: quote the existing Case 27r-deferred red—exit 28 and no actor fork are correct, but zero terminal results are published even though this run has already created its run identity and evidence location.

Required outcome:

- A SIGINT or SIGTERM delivered after `RUN_ID` and the run evidence path exist, but before `run_bounded()` forks an actor, finalizes and consumes exactly one trusted `INTERRUPTED` / code-28 result before a releasable lease is released.
- The record truthfully distinguishes this window from Unit 23: `stage=pre-hop`, `actor_launched=no`, and `model_request_started=no`; it carries this run's exact task, checkout, run, log, owner/lease and available state/worktree facts, and ends with `result_complete=yes`.
- No actor launches, nothing is retried, the interruption wording remains honest for a pre-launch stop, and a clean pre-launch stop releases only after the exact promised artifact passes the accepted path, structure and identity consumer.
- Reuse the existing terminal producer, validators and consumer. Add no second signal handler, result producer, parser, lifecycle reader, result path, wait loop or recovery state.
- Preserve Unit 23's launched-actor teardown, evidence and pinning behavior unchanged. Preserve the pre-run signal window before run identity/evidence exists without inventing a result or converting it into an unprovable code-38 ending.
- Do not implement the proposed all-terminal structural ordering guard in this unit. It is an adjacent prevention improvement, not evidence required to close this measured terminal gap.

Check against the repository before editing:

1. Verify the current handler publishes and consumes an interruption result only when `ACTOR_PROCESS_STARTED=1`, while Case 27r-deferred delivers its signal after both leases and run evidence exist but before the first fork. Name the exact ordering evidence. If the fixture actually lands before run identity/evidence, hand back rather than broadening it.
2. Verify every producer/consumer dependency and required field used in that admitted pre-launch window is already callable and has a truthful bounded value or an accepted explicit unavailable token. If publication would fabricate a field, require a second owner, or depend on a post-fork fact, stop and hand back.
3. Verify the accepted consumer can authenticate the exact promised pre-launch artifact without waiting or scanning, and that its refusal path pins before any release. Do not create a pre-launch-specific consumer.
4. Verify the signal window before run evidence exists remains distinguishable and outside this unit. The plan's atomic terminal-result and release-order requirements govern; Unit 23/24 evidence and the current fixture are verify-first repository facts, not authority to widen scope.

Required fail-capable evidence:

- Quote the targeted red before the production edit and green after it. The red must retain exit 28 and no actor launch but show zero results; the green must show exactly one result, zero partial artifacts, the pre-hop/no-launch/no-model tuple, the completion sentinel, accepted consumer passage, and release only after consumption.
- Assert the result's task, checkout, run/log path, owner/lease observations and available state/worktree facts against independent fixture facts. Do not infer trust from `result_complete=yes` alone.
- Add one mutation control that removes only the new pre-launch eligibility/integration and makes the focused case return to exit 28 with no result while the launched-actor path remains present. The selector must match exactly, produce a different parseable dispatcher, and fail closed if it cannot.
- Keep Unit 23's launched-actor interruption, publication-failure/pinning and no-retry cases green, plus only the directly affected focused interruption slice. Run `bash -n` on both changed shell files; do not rerun the full dispatcher suite.
- Report the implementation commit and exact changed paths. Only `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, and this task state may change; `logs/friction-log.md` remains pre-existing noise and must not be staged or committed.

Capability subset: baseline only — inspect the approved plan and accepted dispatcher/test seams; edit only the two spike files and this state; run focused local checks and shell syntax validation; make the local handback commit. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No external service, production action or operator-reserved capability is needed.

Completion condition: one committed implementation makes the admitted pre-launch signal window publish and consume exactly one truthful run-bound interruption result before release; the targeted red/green and load-bearing control pass; the launched-actor and pre-evidence boundaries remain truthful and unchanged; only the three permitted paths change; and the task returns with `turn: codex`.

Stop and hand back if Case 27r-deferred does not actually run after evidence identity exists; if any required terminal fact would have to be guessed; if the existing producer/consumer cannot safely serve this window; if preserving the earlier pre-evidence boundary requires a new state or recovery mechanism; or if the implementation would absorb the broad structural guard or another terminal family. Challenge a false premise rather than widening.

## Latest result

Inspected (2026-08-17):

- Packaging lines: HOLDS — all four present for Implementation mode, `Dominant deliverable:` naming exactly one deliverable.
- Claim (1): HOLDS — pre-edit `dispatch.sh:2448-2449` published and consumed only under `[ "${ACTOR_PROCESS_STARTED:-0}" -eq 1 ]`; searched the whole file for `ACTOR_PROCESS_STARTED` and found the flag raised only at `run_bounded()`. Case 27r-deferred's stall is the ownership check, which is top-level code below `RUN_ID`/`RUN_LOG` and below `acquire_lock`. Measured, not inferred: an instrumented replay of the fixture showed, at the instant before the signal, the run log already on disk in `$d/runs`, both the task and checkout lease directories present, and `initial: turn=claude ...` already printed (so `validate_state` had returned) — then exit 28, `results=0`, `partials=0`, both leases released. The fixture lands after evidence identity and before the first fork, as the brief states.
- Claim (2): HOLDS at the window the fixture measures, and the repair is what makes it hold across the window the brief names. Every field the record needs there resolves to a real value or an accepted bounded token — `ST_TURN`/`ST_CLASS` set by `validate_state`, `OWNER_STATUS` initialised to `unchecked`, `changed_paths_since_launch` to `unavailable` with no hop baseline, `deadline_remaining_seconds` to `none` with no deadline — and nothing needed is a post-fork fact. But the brief's stated boundary starts at `RUN_ID`, and the record's four working-tree/deadline producers (`foreign_worktree`, `allowlisted_dirty`, `partial_effect_paths`, `remaining_seconds`) were all defined *below* the block that raises `RUN_ID`. Publishing from anywhere in that sub-window would have emitted `worktree_foreign_paths=0` from a function that did not exist — the Unit 21/24 defect one window over. Repaired by relocation rather than by narrowing the boundary; see Result.
- Claim (3): HOLDS — `consume_terminal_result()` derives the promised path as `$LOG_DIR_ABS/$RUN_ID.result` from two values the run already owns, with no listing, newest-file pick or wait; searched the function and its three validators for any scan or sleep and found none. Every refusal leaves through `die_terminal_untrusted()`, which calls `pin_lock_terminal` before `die 38`, so the pin precedes any release. No pre-launch-specific consumer was added — the same call serves both windows.
- Claim (4): HOLDS — the guard requires `RUN_ID` and `LOG_DIR`, which is the finalizer's own precondition, so a signal before run identity exists still takes the old path: no record, no `die_terminal_unprovable`, no code 38. Searched `on_signal` for any other publication route and found only the two marked lines.

Result: the admitted pre-launch interruption window now finalizes and consumes exactly one trusted run-bound `INTERRUPTED` result before either lease is released. Three production changes, all in `dispatch.sh`. First, the `repository state` section (nine pure function definitions, including `remaining_seconds()`) was relocated above the run-evidence block — a pure move, verified by an identical sorted line multiset against the pre-edit file, so from the instant `RUN_ID` exists every fact producer the record calls is defined. Second, both integration lines in `on_signal()` were re-guarded from `ACTOR_PROCESS_STARTED` to `[ -n "${RUN_ID:-}" ] && [ -n "${LOG_DIR:-}" ]` — the finalizer's own condition, so the guard and the producer cannot disagree — with the terminal label chosen from the fork fact so a refusal names the window it fired in. Third, the stop message was split on the same fork fact: a pre-launch stop no longer claims "the actor was killed mid-hop; it may have left a partial effect" about a process the run never forked, and the location reads "before the first hop launched" instead of "between hops". `RUN_LOG` gained an empty default, because the new guard makes the one-statement window between the `RUN_ID` and `RUN_LOG` assignments reachable by a handler that reads `$RUN_LOG` unguarded under `set -u`. No second handler, producer, parser, lifecycle reader, result path, wait loop or recovery state was added, and no readiness flag.

Evidence: Case 27r-deferred was retargeted in place as **Case 27u** — same sandbox, same slow-ownership-helper stall, same 3-second signal, only the expectation moved. Against the pre-edit dispatcher it is **8 pass / 32 fail**: exit 28, no teardown line and no actor call log (correct), but zero results, every record field empty, and the mid-hop wording printed. Against the edited dispatcher it is **40 pass / 0 fail**: exactly one result and zero partials; `stage=pre-hop`, `actor_launched=no`, `model_request_started=no`, `actor=none`, `hop=0`; `checkout`, `run`, `run_log`, `state_file`, `lease_task_dir` and `lease_checkout_dir` each matched against the fixture's own independently computed value rather than read back off the record; `owner_declared=none` and `owner_check=unchecked` matched against what the sandbox actually declares; both leases observed **held** immediately before the signal and **gone** after, with no `*.consume` scratch left, which is the accepted gate having run and returned; `result_complete=yes` as the last line; and the operator pointed at this run's own `.result`.

The anti-fabrication assertion is the load-bearing one: two foreign paths are planted and the record's `worktree_foreign_paths` is compared against a git ground truth this harness computes itself, after the stall is installed. It reads `3` against a truth of `3`. A record published without the relocation would read `0` — a positive, plausible, false claim of a clean tree — so the hoist is fail-capable through the case rather than merely asserted.

**Case 27v (M31)** is the mutation control. Deletion could not isolate this unit, because both windows now travel the same two lines, so the mutant *reverts* each guard to Unit 23's fork condition by literal `awk` substitution and nothing else. It fails closed on a match count other than two, on a mutant that does not differ, does not parse, or has lost either integration marker. Both halves are measured on that one mutant: the pre-launch fixture falls back to exit 28 with **zero** results, and 27r's launched fixture still publishes **exactly one** — so the control removes the widening and not the seam.

Regressions, all green and unchanged: the whole case-27 interruption family **183/0**, which carries 27r's launched-actor evidence, 27s's publication-failure and pinning at exit 38, and 27t's M29 deletion control; the case-50 terminal-record family **131/0**; case 28 with case 31 **25/0**. `bash -n` clean on both changed files.

Changed paths: `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, and this task state file. `logs/friction-log.md` was left untouched and unstaged.

Deferrals recorded, not done: (a) the signal window *before* `RUN_ID` exists still exits 28 with no result — unchanged, and no case asserts it, exactly as the brief deferred; (b) the broad structural guard relating every top-level terminal to every finalizer dependency; (c) nothing asserts the section ordering *directly* — 27u proves it through the foreign count, which is real evidence but indirect, and a structural assertion would be the cheaper long-term protection; (d) the `RUN_LOG` default closes a one-statement race that no deterministic test can reach, so it carries no case of its own.

## Blocker

None.

## Next action

Codex: assess Unit 25 — the admitted post-evidence, pre-fork interruption window now publishes and consumes one trusted run-bound result before release, proven by a red/green on the retargeted fixture, a revert-style mutation control measured on both windows, and the directly affected interruption, terminal-record and deadline regressions. Judge whether the relocation of the fact-producer section above the run-evidence block is accepted as part of this unit or should be recorded as its own decision, and whether the four deferrals above are carried forward as recorded.
