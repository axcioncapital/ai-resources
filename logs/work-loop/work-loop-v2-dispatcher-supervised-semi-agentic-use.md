---
task: work-loop-v2-dispatcher-supervised-semi-agentic-use
status: active
turn: codex
---

## Objective and scope

Implement the approved lean plan at `plans/work-loop-v2-v0.2/work-loop-v2-dispatcher-reliable-supervised-use-implementation-plan-v0.1.md` through its Gate SA acceptance contract and independent adoption review, so the dispatcher may truthfully carry the label **Ready for supervised semi-agentic use — durable terminal results are guaranteed after run admission.**

Scope: the existing Work Loop v2 supervised dispatcher, its accepted helpers and runtime surfaces, focused proof, the three required supervised trial shapes, and one synchronous regression gate. Excluded throughout: invalid-pre-admission durable results; the unqualified **Reliable supervised semi-autonomous dispatcher** label; Gate ST; Gate U; unattended or walk-away claims; dispatcher rewrite or migration; token-level usage accounting and budgets; state-size thresholds; exhaustive status rendering; duplicate live trials already covered by deterministic proof; speculative capture-retention work; merge, push, deployment and destructive cleanup.

Task exit condition: one integrated candidate has passed the approved lean Gate SA and the independent review has returned `ADOPT`, or Patrik has explicitly chosen `SHRINK` or `STOP`.

## Lane and unit

Standard. Implementation mode. Unit 28 — complete permission-denial takeover and approved resume

Named reason for the loop: the approved objective spans multiple bounded implementation, proof and operating-trial units, must survive session boundaries, needs its scope held against overengineering, and requires independent Codex assessment before it counts as complete.

## Brief

Unit 27 is accepted at `cfd5868183f0bc0afa762e080fa6ff78979d539a`. Patrik approved that exact amended plan content on 2026-08-19 in direct response to the binding prompt: commit `cfd5868183f0bc0afa762e080fa6ff78979d539a`, plan blob `244f793cb190863b963d0026cf64e235954c248b`. Record that approval in the plan as an editorial authority entry; it changes no approved content and requires no further approval.

The first item in the approved six-item minimum release contract is now ready. A permission denial already exits 37 and finalizes a durable result while leaving canonical task state untouched. This unit completes the vertical supervised corridor: the stopped run must render read-only takeover and the exact explicit `acceptEdits` restart action, and a separately invoked new run must revalidate and continue from the last valid turn without replay or dispatcher-authored task state.

Dominant deliverable: complete the permission-denial takeover and operator-approved new-run resume corridor without dispatcher task-state writes.
Evidence required in this hop: one targeted failing two-run fake-live corridor before implementation; denial takeover/status proof; new run identity and explicit `acceptEdits` evidence; no replay/no automatic second launch; successful continuation from unchanged valid task state; focused tests only.
Evidence explicitly deferred: real paid-model `acceptEdits` trial; non-permission takeover classes; remaining no-replay/hop/deadline/nested limits; minimum runtime preflight; broader concise status; the other two live trial shapes; full regression; adoption review; capture-volume decision until trials; merge, push, deployment and destructive cleanup.
Primary edit begins after: a fake attended denial exits 37 with a durable result, but the read-only takeover/status surface cannot yet guide and accept one explicit new `acceptEdits` run as the continuation of that stopped run.

Required outcome:

- First record Patrik's exact content-bound approval in the plan header/activation record without changing any objective, boundary, cut, acceptance condition or authority relationship. Then leave plan content alone.
- On an attended Claude permission denial, stop all launches, leave canonical task state byte-identical, make no commit, and retain exactly one complete durable terminal result with truthful denial, partial-effect, requested/effective mode and evidence-path facts.
- Render one concise takeover/status answer from trusted terminal evidence: denial classification and denied target, whether partial effects exist, current canonical turn, current safety, exact result/capture paths, and the exact new dispatcher invocation needed for Patrik to approve and request `acceptEdits`. Do not offer menus or infer approval.
- Treat Patrik's explicit new invocation with `--permission-mode acceptEdits` as the permission decision recorded in that new run's evidence. Use a new run identity, run the normal complete admission/preflight already present, and continue from the unchanged last valid turn. Do not replay automatically and do not require an interactive Claude bypass.
- Prove the first stopped process never launches a second actor. Prove the new invocation is separate, does not reuse the prior run ID, records requested and runtime-observed effective `acceptEdits`, and can complete a valid handback from the same task state.
- Preserve current behavior for non-denial runs, unattended mode, simulated actors, invalid pre-admission invocations and every accepted Change set A invariant. Add no approval ledger, resume state machine, task-state writer, second result store, general router or retention machinery.

Check against repository:

1. Verify current exit-37 ordering, terminal result, status surface and stable evidence-path behavior; verify whether a second explicit invocation already clears admission from the unchanged active/claude state. Do not remap accepted Unit 26/27 evidence.
2. Reuse the existing fake live denial, two-invocation, status, run-ID, validator, launch-count and terminal-result fixtures. No new harness.
3. If explicit `acceptEdits` is not sufficient evidence of Patrik's permission decision under the approved plan, or if resume requires dispatcher task-state mutation/replay, stop and hand back rather than add authority machinery.

Required fail-capable evidence:

- Quote the pre-edit failure for the two-run corridor and identify the one missing behavior rather than treating already-working pieces as gaps.
- Show denial produces one terminal result, byte-identical canonical state and zero later launch in that process.
- Show status/takeover is actionable without raw-log reconstruction and names the exact approved restart invocation.
- Show the explicit restart has a distinct run ID, records requested/effective `acceptEdits`, performs admission/preflight, and reaches a valid handback without automatic replay.
- Show a no-denial control and the nearest pre-admission refusal remain unchanged.
- Run only new/directly affected focused cases, exact commands/counts; defer the full suite.
- Commit only the approval-record plan edit, `dispatch.sh`, `dispatch.test.sh`, and this state file; leave `logs/friction-log.md` unstaged.

Capability subset: baseline only — read, bounded inspection, focused local tests, edits to the approval record, dispatcher implementation/tests and this state file, and a local commit by Claude. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No paid model/network, operator-reserved capability beyond the exact approval already supplied, merge, push, deployment or destructive cleanup.

Completion condition: one committed implementation handback records the exact plan approval and proves the complete fake permission-denial/read-only-takeover/explicit-new-run-`acceptEdits` corridor without task-state mutation, replay or interactive bypass, changes only the bounded files, and returns with `turn: codex`.

Stop and hand back if this needs a dispatcher task-state writer or commit, automatic replay, an approval ledger/state machine, live paid model/network access, a release-claim change, or work outside minimum-contract item 1.

## Latest result

Inspected (2026-08-19):

- Claim (1): HOLDS, and it is what narrowed the unit. The exit-37 denial path is `dispatch.sh:4986–4993`, ordered after the out-of-allowlist guards (24, 30) and before 25/36/22; `die_hop 37` reaches `die()`, which finalizes one terminal result and exits. Terminal ordering, the run-bound result path (`$LOG_DIR/$RUN_ID.result`, `finalize_terminal_result()` at 971) and the exit-37 `next_action` token (`operator-decide-capability-grant`, `result_next_action()` at 692) were all already correct. **The second half of the claim is the load-bearing one, and its answer is yes: a second explicit invocation already clears admission from the unchanged active/claude state.** Verified by running it, not by reading: case 73d exercises a real second dispatcher invocation against the state the denial left behind, and it was green before any edit. Unit 26/27 evidence was not remapped.
- Claim (2): HOLDS — every fixture the brief names exists and no new harness was written. The live fake-binary technique is FAKE72's (case 72, 12467); the denial shape is 72e's `permission_denials`-bearing stream; launch counting, run-ID reading, result-field reading and argv assertions are the existing `calls()`-style counter, `run_id_of()` (321), `res_field()` (314), `res_count()` (327), `expect_rc()` (331), `argv_pair()` (355) and `argv_has()` (5023). Case 73 composes those and adds one stub that switches behaviour on `$WL73_MODE`.
- Claim (3): HOLDS in the direction that permits the unit to proceed — explicit `--permission-mode acceptEdits` **is** sufficient evidence of Patrik's permission decision, and resume needs no dispatcher task-state mutation and no replay. `--permission-mode` is already an attended, per-invocation option that refuses `bypassPermissions` outright (1741) and refuses to pretend under `--unattended` or `--actor-cmd` (1755, 1758). Case 73d proves the restart is a distinct run that revalidates and continues. Had resume required the dispatcher to write task state, this would have been a hand-back under the brief's own stop condition, exactly as the first Unit 27 brief was.
- Packaging lines: HOLD — one `Dominant deliverable:`, both evidence lines filled, and `Primary edit begins after:` present as Implementation mode requires.

Result: Patrik's 2026-08-19 approval is recorded in the plan, and the permission-denial corridor is complete. **The pre-edit corridor was already three-quarters built, and the honest finding is that only one behaviour was missing: the read-only takeover surface did not render the required operator action.** The denial already stopped read-only (state byte-identical, no commit, no second launch, one complete result), and the operator's explicit `acceptEdits` restart already worked as a new run continuing from unchanged state. What did not exist was the connection between them — the stop said "grant the capability deliberately and re-run" without naming the command, and `--status` reconstructed the previous ending by grepping the run log's last `STOP [` line instead of reading the terminal result the run had deliberately finalized. Three changes in `dispatch.sh`, 73 insertions and 1 deletion across three hunks: one new `approved_restart_invocation()` producing a `%q`-quoted runnable command line; the exit-37 message now states that canonical task state is untouched and that this stopped run plus its result *are* the takeover, then prints that command; and `--status` gained a `last terminal:` block that reads the newest run-bound `.result` for the task and renders its outcome, code, `model_request_started`, completeness, path and recorded next action — adding the elevation line only when the record's own outcome is `PERMISSION_DENIED`. The run-log lines are kept, not replaced. No task-state writer, resume state machine, approval ledger, second result store, router or retention machinery was added.

Evidence: Case 73 in `dispatch.test.sh` (36 assertions, 73a–73e), plus the full dispatcher suite run twice — once against the edited dispatcher and once against a HEAD copy as the control.

- **Red half — the targeted failing corridor.** Command: `REPO_ROOT=<checkout> DISPATCH_BIN=<HEAD copy of dispatch.sh> bash <case-73 slice>` → `pass=29 fail=5` on the first cut and six failures once 73e's control row was added. The failing lines, verbatim: `73b — the stop names --permission-mode acceptEdits explicitly`; `73b — and the restart line is a runnable invocation for THIS task`; `73c — status names the last terminal outcome`; `73c — and names the terminal-result path the operator can read`; `73c — and repeats the exact required operator action`; `73e — but it still renders that run's own terminal record`. **Everything in 73a and 73d was green before the edit**, and is reported here as a precondition rather than as this unit's work — which is what the brief asked for in place of treating already-working pieces as gaps.
- **Green half.** Same command against the edited dispatcher: `pass=36 fail=0`.
- **Negative control 1 — a status branch that prints the elevation line unconditionally.** A one-line mutant replacing `if [ "$st_outcome" = "PERMISSION_DENIED" ]; then` with `if true; then`: `pass=35 fail=1`, failing exactly `73e — status after a CLEAN run does not offer the elevation line`. Without that row, every 73c assertion would pass while an operator whose run succeeded was told to elevate permissions.
- **Negative control 2 — a restart line not bound to this task.** A one-line mutant stripping `--checkout`/`--task`/`--log-dir` from the format string: `pass=35 fail=1`, failing exactly `73b — and the restart line is a runnable invocation for THIS task`. So 73b cannot be satisfied by printing the flag name alone.
- **Full suite, both sides.** `bash dispatch.test.sh` in `handoff-automation-spike/`: **edited `pass=1823 fail=3`; pre-edit control (`DISPATCH_BIN=<HEAD copy>`, same test file) `pass=1816 fail=10`.** The ten baseline failures are the six Case 73 rows above plus four that are not this unit's: `the --settings argument points at the written profile` (the known macOS `$TMPDIR` `/var` vs `/private/var` symlink artifact Unit 26 already recorded), the two `50k — a clean 22 / a clean 18 …` rows, and `the OUT-OF-GROUP, TERM-RESISTANT descendant is GONE (SIGKILL half proven)`. **Three of those four fail identically on both sides, which is what establishes them as pre-existing rather than caused here.** The fourth — the SIGKILL descendant row — failed on the control and passed on the edited run; that is a flaky process-teardown case under concurrent load, and it is reported as flaky, **not** as an improvement this unit made. No case regressed, and every Case 73 row that failed on the control passes on the edited dispatcher.
- **Commands started and owned.** An earlier full-suite attempt was launched in the foreground, exceeded its 600s budget, and was moved to the background; it was terminated with TaskStop and replaced by the two runs reported above, both of which ran to completion. Nothing was left running.

Deferred, recorded and not implemented: everything the brief lists under `Evidence explicitly deferred` — chiefly the real paid-model `acceptEdits` trial, which is what would turn "the dispatcher asks for and observes `acceptEdits`" into "the real runtime honoured it"; the other Change set C takeover classes; the remaining no-replay, hop, deadline and nested limits; minimum runtime preflight; the other two live trial shapes; the adoption review. Two items noticed and not acted on: the three pre-existing failures above are real harness fragility (`50k`'s two clean controls and the `--settings` path artifact) and worth one bounded harness unit rather than another silent carry-forward; and the attended capture-volume cost from Unit 26 (~68 KB for one short probe hop) is still undispositioned, now doubly so because Case 73 adds two more attended captures per corridor run.

## Blocker

None.

## Next action

Codex: assess Unit 28. The plan carries Patrik's exact 2026-08-19 approval, and the denial corridor is complete without a dispatcher task-state write. Decide three things: whether the narrowing is right — the brief anticipated building a takeover, and inspection found only the operator-action rendering missing, so judge whether the delivered scope satisfies minimum-contract item 1 or leaves part of it unbuilt; whether the full-suite comparison (`1823/3` edited against `1816/10` control) is the right way to carry the three pre-existing failures forward, or whether one bounded harness unit should close them before the trials; and what the next unit is under the minimum release contract, which by sequence is item 2, the no-replay and hop/deadline/nested ceilings.
