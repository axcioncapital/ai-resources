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

Standard. Implementation mode. Unit 21 — repair unattended version-gate terminal result

Named reason for the loop: the objective spans multiple bounded implementation and proof units, must survive session boundaries, and requires independent Codex assessment before it can count as complete.

## Brief

Unit 20 is accepted at `da53be1c80efe3942d10f4492a94d20fa6117acb`. Unit 19 exposed a separate Change set A defect: the existing `--unattended` version gate finalizes exit 31 before two worktree-fact helpers are defined, producing command-not-found errors and empty result fields. The approved plan requires every terminal class to produce exactly one valid, truthful result, so this unit repairs only that early terminal boundary without enabling unattended use or making any Gate U claim.

Dominant deliverable: the `--unattended` version-gate refusal finalizes one valid terminal result with truthful populated worktree facts and no undefined-function error.
Evidence required in this hop: one targeted pre-edit reproduction of exit 31 with the two command-not-found errors and empty worktree fields; the same fixture green after repair with exact field values; focused controls proving terminal ordering, no-model semantics, and later terminal behavior remain unchanged; shell syntax evidence.
Evidence explicitly deferred: a separate mutation or historical control for this repair; dedicated permission-result rows for other post-hop and between-hop terminals; validator-side outcome-token or semantic-tuple whitelisting; case 50a's planted-lookalike standalone control; remaining terminal families A–C and M; status and resume; crash and hostile-input matrices; Change sets B–D; live trials; adoption review; full synchronous regression gate; merge, push, deployment, and destructive cleanup.
Primary edit begins after: add and run the smallest targeted fixture that reaches the production `--unattended` version gate without an external model request, and quote the failing before-state: exit 31, both undefined-helper diagnostics, and both affected worktree fields empty. Do not run a broad baseline first.

Required outcome:

- The existing version-gate refusal still exits with its accepted code, outcome, stage, reason and next-action vocabulary, but its finalized terminal result is schema-valid and reports truthful values for the two worktree fact fields that are currently empty.
- Finalization emits no `command not found`, unset-function, or secondary diagnostic from collecting those facts.
- Preserve the gate's position before any actor launch or model request. Preserve its refusal semantics and keep the existing unattended surface disabled or experimental; this repair is terminal evidence hygiene, not authorization or proof of unattended operation.
- Preserve one production owner for each worktree fact and the existing single terminal-result producer. Do not duplicate helper logic, add fallback lifecycle parsing, reconstruct facts from prose, or change the result schema or field vocabulary.
- Preserve `--status` as strictly read-only and preserve later terminals' accepted worktree values and finalization behavior.
- Use the smallest technical repair supported by repository evidence. Do not move unrelated preflight, lease, actor, or teardown boundaries merely to make the helpers visible.

Check against the repository before editing:

1. In `dispatch.sh`, verify the version gate still invokes the accepted exit-31 path before `foreign_worktree()` and `allowlisted_dirty()` are defined, and verify terminal finalization calls those functions before writing the two affected fields. Name the exact fields and line order in the handback. Stop if the cause has changed.
2. Verify the result is otherwise finalized exactly once and remains parseable enough to expose the empty fields; identify the existing schema or fixture check that can distinguish populated truthful values from empty presence-only values.
3. In `dispatch.test.sh`, locate the smallest existing version-gate or early-terminal fixture that can reach this production path without an actor or external model request. Reuse its established seams rather than constructing a broad terminal harness.
4. Verify the proposed repair leaves one production definition for each helper and does not make them callable through a second parser, sourced file, duplicated body, or dispatcher-private state.
5. Verify one nearby later terminal already exercises the same worktree facts after helper availability and can serve as the minimum regression control. If no proportionate control exists, report the smallest focused alternative rather than widening to the full terminal matrix.

Required fail-capable evidence:

- Quote the targeted red before production editing: exact exit code, both undefined-helper diagnostics, the exact two empty result fields, `model_started=no`, and proof no actor was launched.
- After editing, run the same fixture and report the exact populated field values, absence of the two diagnostics, unchanged exit/outcome/stage/reason/next-action values, exactly one terminal result, and unchanged no-model/no-actor facts.
- Run the smallest focused control for one later terminal that consumes the same worktree facts, and report its before/after values or accepted invariant.
- Prove by diff that the repair changes only helper availability or equivalent fact collection needed by this terminal; result schema, vocabulary, status, lease, actor-start and teardown surfaces remain unchanged.
- Run `bash -n` on every changed shell file. Do not run the full dispatcher suite in this hop; the synchronous full gate remains later plan work.
- Report the implementation commit and prove it changes only `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, and this task state file. `logs/friction-log.md` remains pre-existing session noise and must not be staged or committed.

Capability subset: baseline only — read the approved plan and accepted Unit 20 evidence; edit and locally test only `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` and `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`; update and locally commit those files plus this state file. The baseline deny set is required in full. Nothing is selected from the pre-authorizable set, which is empty today. No external model request and no operator-reserved capability are needed.

Completion condition: the production version-gate refusal finalizes exactly one valid result with truthful non-empty worktree facts and no undefined-helper diagnostic, while its refusal, no-model/no-actor ordering, later-terminal behavior, schema and fixed supervised-use boundary remain unchanged; only authorized files are committed; and the task returns with `turn: codex`.

Stop and hand back if the defect is no longer caused by helper availability; if truthful facts cannot be produced at this boundary without duplication, reconstruction or a new state owner; if the repair would enable or claim unattended use, alter terminal vocabulary, or move actor/lease/teardown boundaries; if the fixture requires an external model request; or if the required evidence cannot distinguish empty fields from truthful values. Challenge a false premise rather than broadening the unit.

## Latest result

Inspected (2026-08-17):

- Packaging lines: HOLDS — all four present for Implementation mode; `Dominant deliverable:` names exactly one.
- Claim (1): HOLDS, with one correction to the symptom (below). The `--unattended` gate runs at top level from `dispatch.sh:2829`, exiting 31 in **six** places (2834, 2841, 2848, 2853, 2854, 2861). `foreign_worktree()` was defined at 2949 and `allowlisted_dirty()` at 2996, both after. `finalize_terminal_result()` calls them at 787 and 788 and writes `worktree_foreign_paths` and `worktree_allowlisted_dirty_paths` from the result. The finalization funnel opens at `RUN_ID` (2647), so the affected set is exactly those six gate exits: the other early `die`s (13/14/15/26) sit inside `validate_state()`, a function called long after the definitions, and are unaffected.
- **Correction to the brief's symptom, established by running it.** The two fields were **not empty**. They read `0` — the command substitution returned an empty string and `count_lines()` turned it into `0`. That is worse than the brief describes: `0` is a positive, checkable claim that the tree held nothing foreign and nothing uncommitted, and it is false whenever the tree is dirty. The imprecision was mine, in Unit 19's deferral wording. The cause, the required outcome and the repair are unaffected, so this is recorded rather than handed back — but it changed the evidence design, because a clean-tree fixture would report `0` and pass against the broken build.
- Claim (2): HOLDS — the record is finalized exactly once (`results=1 partials=0`) and ends `result_complete=yes`, so the fields are present and readable. What distinguishes truthful from fabricated is not a schema check but a **dirty-tree fixture**: with one tracked file modified on each side of the allowlist, git reports 1 and 1, so `0` is provably wrong.
- Claim (3): HOLDS — case 32f (`dispatch.test.sh:3973`) is the smallest existing version-gate fixture: a fake `claude` binary reporting `2.1.218`, `expect_rc 31`, no actor and no model request. Case 50h reuses that route.
- Claim (4): HOLDS — the repair moves definitions only; `grep -c '^<name>() {'` returns exactly 1 for all eight functions in the moved section. No second parser, sourced file, duplicated body or dispatcher-private state.
- Claim (5): HOLDS — case 50b (`4868`) is the later terminal on the same two fields; it asserts `worktree_foreign_paths=1` at the pre-hop `die 18`, where the helpers already existed. It is the minimum regression control and is in the focused slice.

Result: the `# --- repository state` section — eight pure function definitions, including both helpers — is hoisted above the `--unattended` preflight, so the six `die 31` exits finalize against functions that exist. The refusal itself is untouched: same code, outcome, stage, reason and next-action vocabulary, same position before any launch or model request, and the unattended surface stays exactly as disabled as it was. This is terminal evidence hygiene, not authorization, and it makes no Gate U claim. A comment at the new position records the constraint the position now encodes — *this section must precede every top-level `die()` that can reach finalization* — so the defect cannot be reintroduced by moving it back or by adding a stopping preflight above it.

The alternative I rejected: moving the `--unattended` preflight block downward instead. It would have been a smaller diff, but it relocates executable preflight with real ordering semantics, and the brief forbids moving preflight boundaries to make helpers visible. Moving definitions has no ordering semantics at all.

Evidence:

- **Targeted red, before the production edit, on a fixture where `0` is falsifiable.** Ground truth from git: `M logs/work-loop/gate-facts-task.md` and `M other.txt` — one allowlisted, one foreign. Against the pre-repair dispatcher: `exit=31`, two diagnostics — `dispatch.sh: line 787: foreign_worktree: command not found` and `line 788: allowlisted_dirty: command not found` — `worktree_foreign_paths = [0]`, `worktree_allowlisted_dirty_paths = [0]`, alongside `model_request_started = [no]`, `actor_launched = [no]`, no argv file (nothing launched), `results=1 partials=0`, `result_complete = [yes]`.
- **Green after the repair, same fixture.** `exit=31`, **zero** diagnostics, `worktree_foreign_paths = [1]`, `worktree_allowlisted_dirty_paths = [1]` — matching git exactly. `outcome=UNATTENDED_UNAVAILABLE`, `code=31`, `stage=pre-hop`, `actor_launched=no`, `model_request_started=no`, `next_action=operator-restore-contained-profile-prerequisites`, `results=1 partials=0` — every one unchanged.
- **The new case is fail-capable, proven by running it against the pre-repair build.** Case 50h scores **2 failures** there — `finalization emits no undefined-function diagnostic` and `both worktree facts match the dirty tree git reports` — while all nine refusal-semantics assertions stay green. That split is the point: the case isolates the repair rather than re-testing the terminal. The counts are compared against values read from `git status`, not against literals, so the case cannot drift into asserting its own expectation.
- **Later-terminal regression control.** Case 50b, which consumes the same two fields after helper availability, is fully green including `50b — the foreign path it stopped on is counted, not blanked`. Unchanged before and after.
- **Focused slice: 97 pass / 0 fail** against the repaired dispatcher (50b, 50d, 50h, 60a–c, 60h, 60i). The same slice against the pre-repair dispatcher: 95 pass / 2 fail, both in 50h.
- **The production change is a pure relocation plus one comment, proven by diff.** Comparing sorted non-blank content between `HEAD` and the working tree: **0 lines removed or altered**, 21 lines added — all of them the new comment block. Each of the eight moved functions has exactly one definition. `TERMINAL_RESULT_REQUIRED`, `result_permission_mode_requested()`, both `CUR_ACTOR=""` sites, `ACTOR_PROCESS_STARTED=1`, all three `LAUNCHED_ACTOR` sites, `STATUS_MODE`, `release_lock` and `terminate_actor_tree` all appear the same number of times before and after, so schema, vocabulary, status, lease, actor-start and teardown surfaces are untouched.
- **Shell syntax.** `bash -n` clean on both changed files.
- **Full suite not rerun**, as the brief directs.

Deferrals recorded, not implemented:

1. **No mutation control for this repair** — the brief deferred it. Case 50h's fail-capability is instead evidenced by running it against the pre-repair dispatcher, which is the same demonstration by a cheaper route but is not a permanent control.
2. **The other five `die 31` exits are not separately covered.** Case 50h drives the version-gate exit at 2853. The platform check, the two binary/version-read refusals, the unusable-version case and the profile-write failure share the one repaired cause and the one finalization path, so a per-exit row would be five fixtures for one fact — but that is a packaging judgment, not a proven equivalence.
3. **`git status --porcelain` collapses untracked directories**, so a fixture that creates the first file under an untracked tree sees `?? plans/` counted as one foreign path rather than the file. Case 50h sidesteps it by dirtying tracked files. Whether `foreign_worktree()` should pass `--untracked-files=all` like its sibling `allowlisted_dirty()` does is a real question about the production helper, outside this unit.

## Blocker

None.

## Next action

Codex: assess Unit 21. The questions are whether hoisting the definition section is the right repair against the rejected alternative of moving the preflight, whether the corrected symptom (`0`, not empty) changes anything in the plan's valid-result requirement, and whether deferrals 2 and 3 — the five uncovered sibling exits and the `foreign_worktree()` untracked-directory reading — should be packaged as units.
