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

Standard. Implementation mode. Unit 19 — preserve requested permission mode on carry-one success

Named reason for the loop: the objective spans multiple bounded implementation and proof units, must survive session boundaries, and requires independent Codex assessment before it can count as complete.

## Brief

Unit 18 is accepted at `5f807e489f5dd2548d3d1eff5c18961740c01cc1`. It established that `actor=none` is truthful after the in-flight actor is cleared, while `permission_mode_requested=none` is false on successful live attended Claude carry-one terminals because the value is available and was requested; this unit repairs only that reporting defect. The approved plan's Change set A requires truthful permission-mode evidence and dispatcher ownership of runtime facts, so this correction is the smallest justified next move before more terminal families are built.

Dominant deliverable: successful live attended Claude carry-one terminals preserve and report the permission mode actually requested for the launched hop.
Evidence required in this hop: one targeted pre-edit failure on the live-attended Claude post-hop result and its green result after the repair; focused controls showing Codex, simulated, unattended and pre-fork terminals retain their truthful values; proof that the accepted in-flight actor clear and `actor=none` post-hop semantics are unchanged; and shell syntax evidence.
Evidence explicitly deferred: the separate mutation control that neutralizes the new durable launched-actor fact; validator-side outcome-token or semantic-tuple whitelisting; a separate control for case 50a's planted-lookalike existence/shape assertions; terminal families A–C and M; status and resume; crash and hostile-input matrices; Change sets B–D; live trials; adoption review; merge, push, deployment, and destructive cleanup.
Primary edit begins after: add and run the smallest targeted case that reaches the production terminal-result producer after a successful live attended Claude hop without making an external model request, and quote the failing before-state `permission_mode_requested=none` where the plan requires the available requested mode `default`. Do not build or rerun a broad baseline first.

Required outcome:

- After a live attended Claude actor process starts and completes a valid carry-one transition, `permission_mode_requested` in the finalized result is `default`; if an accepted `acceptEdits` path is already reachable at this seam, preserve its requested token by the same single-owner contract rather than hard-coding `default`.
- A Codex carry-one result remains `permission_mode_requested=none`. Simulated and unattended Claude results remain `none`, and every pre-fork terminal remains `none` because no child permission mode has yet been requested.
- Preserve `actor=none` after the transition and preserve the existing clear of the in-flight actor before carry-one finalization. The signal handler must continue to name only a process that is actually terminable.
- Keep the existing result schema, field names, producer/consumer boundary, lifecycle parser, status path and terminal vocabulary unchanged. Add no second state store, parser, helper, or general historical-actor field.
- Use the smallest single-owner runtime fact that survives from the observed actor launch to terminal finalization. Unit 18's proposal to set one monotonic launched-actor fact at the existing launch funnel is a non-governing technical recommendation; Claude may choose an equally narrow mechanism if repository evidence supports it, but must explain any deviation.

Check against the repository before editing:

1. In `dispatch.sh`, verify Unit 18's accepted cause still holds: the permission producer uses the cleared in-flight actor as its Claude proxy, failure terminals finalize above that clear, and successful carry-one finalizes below it. Hand back if the cause or ordering changed.
2. Verify the existing launch funnel provides one dispatcher-owned point where the actor actually launched can be recorded without changing signal/teardown meaning, and that the first `ACTOR_PROCESS_STARTED` guard continues to dominate all permission-mode interpretation.
3. In `dispatch.test.sh`, locate case 50d's pre-fork controls and case 60's post-hop controls. Add only the focused live-attended success coverage and the minimum nearby assertions needed for the truthful-value matrix; do not redesign the terminal suite.
4. Verify no mechanical consumer currently routes, validates identity, recovers or releases leases from `permission_mode_requested`. If that premise is false, stop and hand back because this unit's reporting-only boundary no longer holds.

Required fail-capable evidence:

- Quote the targeted red before production editing: the successful live attended Claude post-hop result reports `none`, not the available requested mode. The test must exercise the production producer and distinguish live from simulated semantics without an external model request.
- After editing, run the smallest focused slice covering the new live Claude success row, the Codex row, case 50d's pre-fork rows, simulated and unattended controls, and case 60a's accepted `actor=none`. Report exact pass/fail counts and each field value.
- Prove the in-flight actor clear and signal-handler semantics are unchanged, and show the production diff is confined to preserving the launched actor's requested permission fact for result reporting.
- Run `bash -n` on every changed shell file.
- Report the implementation commit and prove it changes only `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, and this task state file. `logs/friction-log.md` remains pre-existing session noise and must not be staged or committed.

Capability subset: baseline only — read the approved plan and accepted Unit 18 evidence; edit and locally test only `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` and `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`; update and locally commit those files plus this state file. The baseline deny set is required in full. Nothing is selected from the pre-authorizable set, which is empty today. No external model request and no operator-reserved capability are needed.

Completion condition: every successful live attended Claude carry-one result truthfully preserves the requested permission mode while Codex, simulated, unattended and pre-fork rows retain their accepted values; actor-clear and signal/teardown truth are unchanged; targeted red/green and focused regression evidence pass; no deferred mutation control or wider schema work enters the unit; only permitted paths are committed; and the task returns with `turn: codex`.

Stop and hand back if the mode cannot be preserved without weakening the accepted actor clear, adding a second state owner or changing schema; if the focused live-attended test requires an actual external model request; if an existing mechanical consumer makes this more than a reporting correction; or if the required evidence cannot distinguish live, simulated, unattended and pre-fork semantics. Challenge a false premise rather than broadening the unit.

## Latest result

Inspected (2026-08-17):

- Packaging lines: HOLDS — all four present for Implementation mode; `Dominant deliverable:` names exactly one; `Evidence explicitly deferred:` is populated.
- Claim (1): HOLDS — read `dispatch.sh` end to end around the permission producer and the hop loop. `result_permission_mode_requested()` at line 638 gated on `[ "${CUR_ACTOR:-}" = "claude" ]` at line 641; `CUR_ACTOR` set at the hop loop's line 3764 and cleared at line 3933 under the comment "The hop is over and no actor is in flight"; every `die_hop` sits above 3933 and the carry-one `finalize_terminal_result 0` at line 3961 sits below it. Cause and ordering unchanged from Unit 18.
- Claim (2): HOLDS — `run_bounded()` is the single fork funnel (`ACTOR_PROCESS_STARTED=1` at line 3307, comment "THE ONE PLACE A CHILD IS FORKED"), and `grep -n 'run_bounded' dispatch.sh` shows its only four call sites are all inside `launch_actor()` (3407, 3417, 3499, 3520). Recording there touches neither `ACTOR_PGID`, `ACTOR_MARKER` nor `on_signal()`. The `ACTOR_PROCESS_STARTED` guard is still the first line of the producer and still dominates.
- Claim (3): HOLDS — case 50d's pre-fork controls at `dispatch.test.sh` lines 4993–5045 (codex and claude rows, both asserting `permission_mode_requested:none`); case 60's post-hop controls at lines 7028–7199 (60a's accepted `actor=none`, 60b's four transitions, 60c's over-fire controls).
- Claim (4): HOLDS — `grep -rn 'permission_mode_requested'` across the whole checkout returns five non-state-file hits: the producer (`dispatch.sh:638`), its one emission site (`dispatch.sh:804`), the required-field roster (`dispatch.sh:881`, a presence check with no value grammar), and two test assertions (`dispatch.test.sh:5025, 5041`). No routing, identity, recovery or lease consumer reads it. The reporting-only boundary holds.

Result: successful live attended Claude carry-one terminals now report `permission_mode_requested=default`, the mode the launch argv actually carried. One new dispatcher-owned runtime fact, `LAUNCHED_ACTOR`, records **which actor the most recent fork was for** — cleared on entry to `launch_actor()` (beside the existing `LAST_CAPTURE` publication) and set at the fork inside `run_bounded()` on the same line as `ACTOR_PROCESS_STARTED=1`, reading `CUR_ACTOR` because at that instant it is the actor being forked by definition. The producer's third guard now reads it instead of `CUR_ACTOR`; the other three guards, the schema, the field names, the producer/consumer boundary, the lifecycle parser, the status path and the terminal vocabulary are untouched, and no second state store, parser or helper was added.

Both halves of the new fact are load-bearing, which is why it is not the single monotonic global Unit 18 recommended. Setting it only at the fork is what stops a launch that died on its binary from claiming a mode no child received; clearing it on entry is what stops the previous hop's fork from answering for this one. `ACTOR_PROCESS_STARTED` cannot do either job past hop 1, because it stays `1` for the rest of the run — so a monotonic fact set at `launch_actor()` entry would have made an unresolvable claude binary on hop 2 report `default`. That deviation from the recommendation is the reason row 6 below exists.

Evidence:

- **Targeted red, before any production edit.** Focused slice **52 pass / 2 fail**. The quoted before-state: `FAIL 60h — the carried terminal reports the requested mode: default / got: none — the launch argv carried --permission-mode default (case 31b)`. Second red: `FAIL 60h — a pre-fork stop after an earlier fork requests no permission mode / hop=2 launched=yes perm=default`. The case reaches the production producer over a **live** hop — `mode=live`, a real fork of a fake `claude` binary, no external model request — asserted separately (`60h — the row really is a live, carried, post-hop Claude terminal`) so a row that never reached the live branch cannot pass for the wrong reason. `--actor-cmd` cannot distinguish the defect: it sets `MODE=simulated`, which the producer's second guard already answers `none` at.
- **Green after the repair.** Same focused slice **54 pass / 0 fail**. Field values, one row per guard: live attended Claude carried → `permission_mode_requested=default`, `actor=none`, `permission_mode_effective=unavailable`; live Codex carried → `none` (actor guard, at `mode=live`); simulated Claude carried → `none` (mode guard); live `--unattended` Claude carried → `none` (contained-profile guard); live attended Claude **failure** terminal at 22 → `default` with `actor=claude` (unchanged, above the clear); hop-2 pre-fork stop after a completed hop-1 fork → `none` (fork guard). Case 50d's two pre-fork rows and case 60a's accepted `actor=none` are inside the same slice and stayed green.
- **The in-flight clear and signal semantics are unchanged, proven by diff not by assertion.** Diffing every `CUR_ACTOR` site between `HEAD` and the working tree returns exactly one executable change — the guard line at 641 — with everything else in that diff being comment text. The hop-over clear (`CUR_ACTOR=""`, now line 3980) and its two-line comment are byte-identical; `on_signal()`'s `[ -n "$CUR_ACTOR" ] && where="during hop $CUR_HOP (actor '$CUR_ACTOR')"` is byte-identical; `tr_kv_or actor "${CUR_ACTOR:-}" none` is byte-identical. The signal handler still names only a process that is actually terminable. Case 60h row 5 is the behavioural half of the same claim: the failure terminal above the clear still reports `default` **and** `actor=claude`, so the clear is still what separates in-flight from not.
- **Confinement.** `LAUNCHED_ACTOR` is read at exactly one place, so the whole behavioural surface of this change is the single field `permission_mode_requested`, and claim (4) enumerates every reader of that field in the checkout.
- **Full regression, not only the slice.** `bash dispatch.test.sh` against the repaired dispatcher: **965 pass / 0 fail**, exit 0. Zero new failures anywhere in the suite.
- **Shell syntax.** `bash -n dispatch.sh` and `bash -n dispatch.test.sh` both clean.

Deferrals recorded, not implemented:

1. **The mutation control that neutralizes `LAUNCHED_ACTOR`.** The brief deferred it, and it is untouched here. Without it, case 60h proves the repair works but not that the new fact is the thing making it work.
2. **NEW — the `--unattended` version gate finalizes a broken record.** Found while building row 4. `die 31` fires at `dispatch.sh:2853`, but `foreign_worktree()` is defined at 2949 and `allowlisted_dirty()` at 2996, so finalization at that terminal runs before either function exists: the run printed `dispatch.sh: line 754: foreign_worktree: command not found` and `line 755: allowlisted_dirty: command not found`, and wrote the two worktree count fields empty. A different terminal family and a different field pair from this unit's boundary, so it is recorded rather than fixed. No test covers that terminal's record today.
3. **The wider truthfulness improvement this repair also delivers.** Beyond the carry-one terminal, every terminal that finalizes below the hop-over clear — the post-hop operator terminal and the between-hop stops (23, 19, 16, 18, 28, 29) — now reports the requested mode instead of `none`, and a later-hop pre-fork stop now reports `none` instead of `default`. All four are the same defect and the same single-owner fix; only the carry-one row and the pre-fork row are asserted. Whether the others deserve their own rows is Codex's packaging call.

## Blocker

None.

## Next action

Codex: assess Unit 19. The repair is one new runtime fact and one changed guard line; the questions are whether the clear-on-entry / set-at-fork pair is the right boundary given it deviates from Unit 18's monotonic recommendation, whether case 60h's six rows are sufficient without the deferred mutation control, and whether deferrals 2 and 3 should be packaged as units or left standing.
