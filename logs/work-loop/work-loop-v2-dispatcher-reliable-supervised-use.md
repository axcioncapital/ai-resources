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

Standard. Implementation mode. Unit 26 — bind terminal outcome and code to caller expectations

Named reason for the loop: the objective spans multiple bounded implementation and proof units, must survive session boundaries, and requires independent Codex assessment before it can count as complete.

## Brief

Unit 25 is accepted at `c21b2d4d82117bf70e01c2286f1d8401ade08ad7`: an admitted signal after run identity but before the first fork now finalizes and consumes one truthful interruption result before lease release, and the necessary pure-fact relocation is accepted because the planted dirty-tree control proved the previous ordering would fabricate `worktree_foreign_paths=0`. The accepted validator seam still states its next missing trust question: structure and task/checkout/run identity can pass while `outcome` and `code` contradict the terminal the caller expected. Build and prove that one standalone semantic boundary now; following the Work Loop packaging rule, do not integrate its first consumer in this unit.

Dominant deliverable: one read-only production semantic validator that binds a parsed terminal result's `outcome` and `code` to caller-supplied expectations.
Evidence required in this hop: one targeted red/green standalone validator case using a real producer artifact, plus one focused load-bearing control.
Evidence explicitly deferred: integration into `consume_terminal_result()` or any other consumer; semantic validation of stage, actor/start, state, Git, permission, deadline, usage, owner/lease, next-action or lifecycle tuples; the interruption window before run identity; the broad structural ordering guard; usage, infrastructure and lease-refusal result migration; permission-result rows; status and resume; crash and hostile-input matrices beyond this validator case; Change sets B–D; live trials; adoption review; the full synchronous regression gate; merge, push, deployment and destructive cleanup.
Primary edit begins after: quote a focused pre-edit case in which the existing path → structure → identity composition accepts a promised artifact whose task, checkout and run are correct but whose `outcome` and/or `code` contradict caller-supplied expected values.

Required outcome:

- The dispatcher owns one standalone read-only semantic boundary that accepts the exact parsed artifact only when its `outcome` and `code` equal independent expectations supplied by the caller.
- A real producer result passes with its independently established expected pair. A structurally valid artifact with only the outcome wrong is refused with one bounded token, and one with only the code wrong is refused with a distinct bounded token.
- The boundary consumes the fields captured by the existing single structural parse and remains pinned to that parse's exact artifact snapshot. It must not reopen, source, evaluate, rescan or independently parse the result.
- Do not add a second code-to-outcome table or derive either expected value from the artifact. Expectations come from the caller; the producer's existing `result_outcome()` remains the sole code-to-symbol owner.
- Keep path safety, structure, task/checkout/run identity and semantic agreement as separate questions with one owner each. This unit proves the new question standalone and does not make a terminal advance, release a lease or choose a route.
- Keep the validator inside the existing production validator region if that is the minimum one-owner placement supported by repository evidence. Do not add a new library, CLI, schema version, parser, state field or evidence path.

Check against the repository before editing:

1. Verify the current structural pass parses each artifact once, publishes only accepted task/checkout/run identity fields plus its exact snapshot, and does not retain outcome/code for a later semantic comparison. Verify the identity boundary compares no semantic field. If either semantic comparison already exists, hand back.
2. Reproduce the named red on the existing three-gate composition using a real producer artifact altered only in outcome/code while preserving structure, promised path and task/checkout/run identity. If another existing guard already refuses it for the intended semantic reason, hand back.
3. Verify `result_outcome()` remains the sole production code-to-outcome mapping and identify its callers. The new boundary may compare two caller expectations; it must not copy or partially restate that map.
4. Verify the marker-delimited extraction used by focused validator cases executes the dispatcher's production text rather than a harness copy, and can exercise the new boundary without adding a consumer route.
5. Treat the approved plan's trusted-field ownership, one-parser and hostile-input requirements as governing. Existing validator comments and tests are verify-first repository evidence; they do not authorize widening into full semantic tuple validation.

Required fail-capable evidence:

- Quote the focused red before the production edit and green after it. The red must show the current safe path/structure/identity gates accepting the semantically wrong but otherwise valid promised artifact; the green must show the unchanged real producer artifact accepted and outcome-only and code-only mismatches rejected with distinct bounded tokens.
- Prove the expected pair is established independently of the artifact under test. Do not read an expectation from the same record and compare it back to itself.
- Prove the artifact is parsed once and the semantic check is bound to the accepted snapshot; a check invoked without the required prior parse, against a different artifact, or after replacement must refuse rather than reuse stale captured fields.
- Add one focused mutation/control that disables only the new semantic boundary and makes the mismatch assertions accept while the artifact still passes path, structure and identity. The selector must match exactly, produce different parseable production text and fail closed if it cannot run.
- Keep the existing structural/path/identity validator slice green and run only the directly affected terminal-validator controls plus `bash -n` on both shell files. Do not integrate `consume_terminal_result()` and do not run the full dispatcher suite.
- Report the implementation commit and exact changed paths. Only `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, and this task state may change; `logs/friction-log.md` remains pre-existing noise and must not be staged or committed.

Capability subset: baseline only — inspect the approved plan and accepted dispatcher/test seams; edit only the two spike files and this state; run focused local checks and shell syntax validation; make the local handback commit. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No external service, production action or operator-reserved capability is needed.

Completion condition: one committed standalone production boundary compares the once-parsed result's outcome and code to independent caller expectations, accepts the real expected pair, rejects each one-field mismatch with a bounded reason, remains snapshot-bound and read-only, passes the focused load-bearing control and existing validator regressions, changes only the three permitted paths, and returns with `turn: codex` without consumer integration.

Stop and hand back if outcome/code already have an equivalent semantic owner; if the expected values cannot be supplied independently; if adding the check requires reparsing the artifact, duplicating `result_outcome()`, changing the schema or integrating a consumer; if snapshot binding cannot be preserved; or if the unit would expand into another semantic field family. Challenge a false premise rather than widening.

## Latest result

Inspected (2026-08-17):

- Packaging lines: HOLD — `## Lane and unit` records Implementation mode, so all four lines are required; all four are present, `Dominant deliverable:` names exactly one deliverable, and `Evidence explicitly deferred:` is non-empty.
- Claim (1): HOLDS — read `dispatch.sh` 1059–1181 (the structural pass). One `while IFS= read` loop over one open, bracketed by `wl2_tr_sha`/`wl2_tr_fid` before and after; its `case "$key"` captured only `task`, `checkout`, `run`, and it published only `TR_SOURCE`/`TR_TASK`/`TR_CHECKOUT`/`TR_RUN`/`TR_SHA`/`TR_FID` — no outcome or code was retained. Read 1213–1265 (the identity boundary): its only comparisons were `TR_TASK`, `TR_CHECKOUT`, `TR_RUN` against caller arguments, no semantic field. `grep -n 'outcome-mismatch\|code-mismatch\|semantic' dispatch.sh dispatch.test.sh` returned only prose comments, so no equivalent owner existed.
- Claim (2): HOLDS (red reproduced) — see the pre-edit quote below.
- Claim (3): HOLDS — `grep -n 'result_outcome' dispatch.sh dispatch.test.sh` found one definition (534), one production caller (`finalize_terminal_result` at 825, `tr_kv outcome "$(result_outcome "$code")"`), and one prose reference (3882). No test called it before this unit.
- Claim (4): HOLDS — `dispatch.test.sh` 5961–5968 defines `VAL_BEGIN`/`VAL_END` and `extract_validator()`, which `awk`s the region out of `$DISPATCH_BIN` itself and sources it; `dispatch.sh` carries exactly one `:begin` (911) and one `:end` (1266). Cases 51–54 reach the boundaries through that lift with no CLI, status or transition route, so a fourth boundary is reachable the same way with no consumer added.
- Claim (5): HOLDS — the plan's trusted-field-ownership, one-parser and hostile-input requirements were treated as governing; the unit stayed on outcome/code and added no other semantic field family.

Result: `dispatch.sh` now owns a fourth standalone read-only boundary, `validate_terminal_result_semantics()`, inside the existing marker-delimited validator region. It compares the once-parsed record's `outcome` and `code` against two expectations the caller supplies, after re-establishing the same preconditions the identity boundary uses (gate-before-parse, parse-of-this-artifact, not-a-symlink, file identity, digest). The single structural pass now also captures `TR_OUTCOME`/`TR_CODE` — same parse, same acceptance-only publication — so nothing reopens, sources, rescans or re-parses the artifact. No second code-to-outcome table: `result_outcome()` remains the sole map and the new function knows no symbols. No consumer was integrated; `consume_terminal_result()` is byte-identical.

Evidence — the pre-edit red, on the unmodified three-gate composition, using a real producer artifact one field apart:

```
producing run exit: 22
artifact says: outcome=NO_TRANSITION code=22
independent expectation: outcome=NO_TRANSITION code=22
wrong-outcome fixture says: outcome=COMPLETED code=22
three-gate verdict on the wrong-OUTCOME artifact: 0 ok
wrong-code fixture says: outcome=NO_TRANSITION code=0
three-gate verdict on the wrong-CODE artifact:    0 ok
three-gate verdict on the UNCHANGED artifact:     0 ok
```

All three were accepted identically, so path, structure and identity could not distinguish the genuine terminal from a record of a different one. The expected pair was derived without the artifact: `22` is the exit status the producing process returned, and `NO_TRANSITION` came from `result_outcome` lifted as production text and driven by that status.

Green, after the edit, in the focused slice (harness prologue + cases 50–54 + new case 61) — `pass=224 fail=0`:

```
61a — the expected outcome/code pair is derived with the artifact absent (NO_TRANSITION/22)
61a — the unchanged real producer result is accepted for the terminal the caller expected
61b — a record claiming another terminal's OUTCOME is rejected            [outcome-mismatch]
61b — a record claiming another terminal's CODE is rejected with a DISTINCT token  [code-mismatch]
61b — the wrong-outcome record passes path, structure and identity, so only meaning can reject it
61b — the wrong-code record passes path, structure and identity, so only meaning can reject it
61c — the semantic check refuses an artifact whose path the safety gate never cleared  [path-unchecked]
61c — the semantic check refuses when the parse that ran read a different file         [unvalidated]
61c — a record replaced after the parse is refused, not answered from captured fields  [artifact-replaced]
61c — a record rewritten in place after the parse is refused                           [artifact-changed]
61c — an unsupplied expected outcome/code is refused rather than treated as any        [no-expectation]
61c — the semantic boundary's text carries no outcome symbols and no second mapping
61c — semantic validation changes nothing in the checkout
61d — M32 matched exactly the two comparisons, differs from the dispatcher, and still parses
61d — M32: without the comparisons the wrong-outcome record is accepted (61b is fail-capable)
61d — M32: without the comparisons the wrong-code record is accepted (61b is fail-capable)
```

Independence is proved rather than asserted: 61a moves the artifact aside, derives the pair, and asserts the artifact was absent while it was derived. Snapshot binding is proved in both directions — a different file at the same promised path returns `artifact-replaced`, the same file with appended bytes returns `artifact-changed`. The load-bearing control M32 deletes exactly the two comparison lines from `dispatch.sh` (asserted: 2 matched, 0 left, differs, `bash -n` still parses, otherwise it fails closed and says so), re-lifts the region, and both mismatched records are accepted again. The existing validator slice (cases 51–54, including M11–M17) stayed green in the same run, and `bash -n` passes on both shell files.

One harness defect was found and fixed inside this unit: M32's guard used `grep -c ... || printf '0'`, and since `grep -c` prints its count and exits 1 at zero, the fallback appended a second zero and the control could never run (observed `left=0\n0`, `pass=221 fail=1`). Replaced with `|| true` inside the substitution.

Changed paths: `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, and this state file. `logs/friction-log.md` was left dirty and unstaged as instructed.

Deferrals noticed and not done: the semantic boundary is not wired into `consume_terminal_result()`, and case 56e's composition assertion still pins three boundaries rather than four — both belong to the integration unit. No other semantic field family (stage, actor/start, state, Git, permission, deadline, usage, owner/lease, next-action, lifecycle) was touched. No external, operator-reserved or containment capability was claimed.

## Blocker

None.

## Next action

Codex: assess Unit 26 — one standalone snapshot-bound `validate_terminal_result_semantics()` with the focused red/green, the M32 control, the 50–54 validator slice green at `pass=224 fail=0`, and no consumer integration. Decide close, continue, correct once, or stop.

