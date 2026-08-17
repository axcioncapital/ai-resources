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

Standard. Implementation mode. Unit 20 — prove launched-actor fact is load-bearing

Named reason for the loop: the objective spans multiple bounded implementation and proof units, must survive session boundaries, and requires independent Codex assessment before it can count as complete.

## Brief

Unit 19 is accepted at `35fdf3a50c0db677ba6283f2efa5479b203a5901`: its clear-on-entry/set-at-fork `LAUNCHED_ACTOR` boundary is justified because it records an actual fork without allowing a previous hop to answer for a later pre-fork stop. The approved plan requires fail-capable proof for dispatcher-owned runtime facts, and Work Loop packaging deliberately split this negative control from the primary repair. This unit adds only the permanent mutation control that proves the accepted permission result depends on that fact.

Dominant deliverable: one permanent mutation control proves that neutralizing the accepted `LAUNCHED_ACTOR` fact breaks the focused permission-mode behavior.
Evidence required in this hop: the targeted mutant fails for the live attended Claude post-hop row while the unmodified production dispatcher stays green; the control itself fails closed if its mutation no longer applies exactly once or if it observes no targeted failure; focused syntax and regression evidence for the added control.
Evidence explicitly deferred: the newly found `--unattended` version-gate terminal that finalizes before worktree helpers exist; dedicated rows for the other post-hop and between-hop permission-result terminals; validator-side outcome-token or semantic-tuple whitelisting; case 50a's planted-lookalike standalone control; terminal families A–C and M; status and resume; crash and hostile-input matrices; Change sets B–D; live trials; adoption review; merge, push, deployment, and destructive cleanup.
Primary edit begins after: create the smallest temporary mutant that neutralizes only the Unit 19 `LAUNCHED_ACTOR` publication or consumption seam, run the existing focused live-attended Claude permission case against it, and quote the specific failing assertion showing `default` became `none`. Do not run a broad baseline first.

Required outcome:

- `dispatch.test.sh` permanently constructs or applies a narrowly identified mutant that neutralizes only the accepted launched-actor fact, exercises the production permission-result seam, and passes only when the mutant is detected by the expected focused behavioral failure.
- The mutation control must distinguish causal failure from fixture breakage: it proves the intended source transformation applied exactly once, the mutant remained syntactically runnable, and the observed failure is the live attended Claude requested-mode assertion rather than an unrelated setup or parser failure.
- The unmodified dispatcher remains green for the same focused rows, including live Claude success, live Codex, simulated Claude, unattended Claude, the in-flight failure terminal, and the later-hop pre-fork stop.
- Keep Unit 19's production implementation, result schema, field vocabulary, actor clear, signal handling, lifecycle parsing, status path, and terminal behavior unchanged. No production edit is expected or authorized by this unit.
- Add no general mutation framework, helper, second test runner, second state store, or wider terminal matrix. Reuse the smallest existing test seam that repository evidence supports.

Check against the repository before editing:

1. In `dispatch.sh`, verify commit `35fdf3a5…` still has one `LAUNCHED_ACTOR` clear on launch entry, one publication at the actual fork, and one permission-producer read, with no other consumer. Hand back if that accepted boundary has changed.
2. In `dispatch.test.sh`, verify case 60h still reaches the production producer over a live fake-Claude fork with no external model request and that neutralizing `LAUNCHED_ACTOR` makes its live attended Claude requested-mode assertion fail specifically from `default` to `none`.
3. Inspect only the existing mutation-control and dispatcher-fixture surfaces in `dispatch.test.sh` needed to choose the smallest established pattern. Verify that a mutant dispatcher can be selected without changing production code or making an external model request.
4. Verify the proposed control can prove its source mutation applied exactly once and can reject a syntax-broken or non-running mutant separately from the expected behavioral failure. If the current harness cannot distinguish those conditions without new production machinery, stop and hand back.

Required fail-capable evidence:

- Before the test edit, quote the temporary mutant command/result: exact one-site mutation, clean mutant syntax, and the existing focused assertion failing because the live attended Claude result reports `none` instead of `default`.
- After the edit, run the new mutation control and the smallest focused unmodified slice covering case 60h's six guard rows. Report exact pass/fail counts and identify the expected mutant failure the control observed.
- Demonstrate that a no-op mutation or a mutation that applies zero/multiple times makes the control fail rather than pass vacuously; use the smallest one-shot check supported by the existing test pattern.
- Run `bash -n` on `dispatch.test.sh`. Do not rerun the full dispatcher suite in this hop; Unit 19's accepted `965/0` is settled, and the complete synchronous regression gate remains later plan work.
- Report the implementation commit and prove it changes only `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` and this task state file. `dispatch.sh` must be unchanged; `logs/friction-log.md` remains pre-existing session noise and must not be staged or committed.

Capability subset: baseline only — read the approved plan and accepted Unit 19 evidence; edit and locally test only `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`; update and locally commit that file plus this state file. The baseline deny set is required in full. Nothing is selected from the pre-authorizable set, which is empty today. No external model request and no operator-reserved capability are needed.

Completion condition: the permanent mutation control detects a one-site neutralization of `LAUNCHED_ACTOR` through the specific live attended Claude permission failure, rejects vacuous or malformed mutation evidence, leaves the unmodified focused rows green, changes no production file or deferred terminal family, and returns the task with `turn: codex`.

Stop and hand back if neutralizing the fact does not produce the expected targeted failure; if the mutant cannot reach the production producer without an external model request; if a permanent control requires production changes or a new framework; if the accepted Unit 19 boundary changed; or if the required evidence cannot distinguish causal behavioral failure from fixture or syntax failure. Challenge a false premise rather than broadening the unit.

## Latest result

Inspected (2026-08-17):

- Packaging lines: HOLDS — all four present for Implementation mode; `Dominant deliverable:` names exactly one; `Evidence explicitly deferred:` is populated.
- Claim (1): HOLDS — `grep -n 'LAUNCHED_ACTOR' dispatch.sh` returns six lines: the declaration at 439, comment text at 661 and 666, the producer read at 674, the fork publication at 3348, and the launch-entry clear at 3448. That is one clear, one publication, one read and no other consumer. `git diff HEAD -- dispatch.sh` is empty, so the accepted Unit 19 boundary at `35fdf3a5…` is byte-for-byte what is on disk.
- Claim (2): HOLDS — verified by running, not by reading. The temporary mutant below made case 60h's live attended Claude row fail specifically `default` → `none`, while that row's live/carried/post-hop precondition assertion stayed green.
- Claim (3): HOLDS — read both existing mutation surfaces. Case 50c's M1 (`dispatch.test.sh:4930–4946`) is the exact-whole-line pattern with `hits`/`differs`/`parses` as three separately reported variables; case 60f's M27 (`7234–7281`) is the marker-delete pattern and defines its own `MUT60` directory rather than sharing 50c's. Both select a mutant by writing a transformed copy of `$DISPATCH_BIN` and invoking it, so no production edit and no external model request is involved. Case 60i follows the M1 discipline and the per-case directory convention.
- Claim (4): HOLDS — M1 already proves the harness can separate the three conditions, because it reports `matched N lines, want exactly 1; differs=… parses=…` in one diagnostic. No new production machinery is needed.

Result: `dispatch.test.sh` gains case 60i and mutant M28, which neutralizes exactly one line — the `LAUNCHED_ACTOR` publication at the fork — and proves case 60h's accepted `default` depends on it. The publication was chosen over the producer read deliberately: deleting the read would remove the guard entirely and make the function answer `default` for Codex too, failing 60h for a reason other than the one under test. No production file was touched, and no framework, helper, second runner or wider matrix was added.

Evidence:

- **Targeted red, before the test edit.** The temporary mutant, built from the exact production line `  LAUNCHED_ACTOR="${CUR_ACTOR:-}"`: `exact-line hits: 1`, `DIFFERS: yes`, `PARSES: yes`, and `diff` showing the single changed line `3348c3348  <   LAUNCHED_ACTOR="${CUR_ACTOR:-}"  >   :`. Running the existing focused slice against it: **52 pass / 2 fail**, with the quoted assertion `FAIL 60h — the carried terminal reports the requested mode: default / got: none — the launch argv carried --permission-mode default (case 31b)`. The second red is the in-flight failure terminal, which reads the same fact. Row 1's precondition assertion — `60h — the row really is a live, carried, post-hop Claude terminal` — stayed **green** under the mutant, which is what distinguishes a causal behavioural failure from fixture breakage.
- **Green after the edit.** Focused slice against the unmodified dispatcher: **60 pass / 0 fail** (54 previously + 6 new). The six new assertions: the three guard-falsifiability one-shots, the M28 construction guard, the M28 behavioural row, and the paired unmutated control.
- **The control observes the targeted failure, not a crash.** M28's behavioural assertion is one condition covering six values: the mutant run must still exit 0, and still report `mode=live`, `outcome=CARRY_ONE_COMPLETE`, `stage=post-hop`, `actor_launched=yes` — everything 60h's precondition row checks — while `permission_mode_requested=none`. A mutant that merely broke the fixture fails this row rather than passing it.
- **The paired unmutated run.** The same fake-Claude fixture and flags against `$DISPATCH_BIN` reports `default`, so the row above cannot be satisfied by a fixture that returns `none` for reasons of its own. The two runs are one line of source apart.
- **Vacuous mutation is rejected, three one-shot checks, no dispatcher runs.** A selector matching nothing yields a byte-identical script (`hits=0`, `differs=no`), which both guard tests reject; a duplicated seam counts `2`, which the `hits==1` test rejects, proving the counter distinguishes 1 from 2 rather than merely from 0; and replacing the same line with a dangling `if` is rejected by `bash -n`, proving the parse condition rejects separately from any behaviour.
- **The control fails closed, proven by running it against a dispatcher that lacks the seam.** Pointed at `35fdf3a5^` (the pre-Unit-19 dispatcher, where `grep -Fxc` for the seam returns `0`), the slice goes **53 pass / 5 fail** and case 60i reports `FAIL 60i — M28 mutant matched the publication exactly once, differs, and still parses / matched 0 lines, want exactly 1; differs=no parses=yes — the control cannot run`. It stops rather than silently passing against an unmutated script.
- **Shell syntax.** `bash -n dispatch.test.sh` clean. `dispatch.sh` is unchanged, so it needed none.
- **Full suite not rerun**, as the brief directs. Unit 19's accepted `965/0` stands.

Deferrals recorded, not implemented:

1. **`--unattended` version-gate terminal** (`die 31` at `dispatch.sh:2853` finalizing before `foreign_worktree()` at 2949 and `allowlisted_dirty()` at 2996 exist) — Codex has already dispositioned this to a later Change set A unit. Untouched.
2. **NEW, small: the parse-guard one-shot is seam-dependent.** `60i — an unparseable replacement is rejected by the parses test` builds its broken mutant from the same selector, so when the seam is absent it goes red alongside the others rather than continuing to demonstrate the parse guard in isolation. That is fail-closed and therefore acceptable, but it means the check measures "the substitution produced an unparseable script" rather than "`bash -n` rejects unparseable scripts" independently. Making it seam-independent would need its own fixture, which is more machinery than this unit authorizes.
3. All other recorded deferrals stand as Codex dispositioned them.

## Blocker

None.

## Next action

Codex: assess Unit 20. The questions are whether neutralizing the publication rather than the producer read is the right mutation site, whether the six new assertions discharge the fail-capability requirement without the control becoming a framework, and whether deferral 2 is worth a unit or is correctly accepted as-is.

