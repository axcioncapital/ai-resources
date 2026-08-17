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

Standard. Implementation mode. Unit 23 — make launched interruption produce trusted evidence

Named reason for the loop: the objective spans multiple bounded implementation and proof units, must survive session boundaries, and requires independent Codex assessment before it can count as complete.

## Brief

Patrik invoked `$realign` before the prior Unit 23 discovery produced an accepted result. That discovery is dropped: it required a complete map and architectural disposition for every pre-run exit before implementing any one terminal, although the approved Change set A contract and live `on_signal()` path already establish one independent failure with a bounded correction. This unit returns to the last accepted point, Unit 22 at `c3af91551be9c2a18de3f9ba42cb10ddd87c0dfd`, and advances one observable Gate SA outcome: an interruption after an actor has launched must produce and consume trusted terminal evidence before any releasable lease is released.

Dominant deliverable: one trusted terminal-result integration for SIGINT or SIGTERM received after an actor process has launched.
Evidence required in this hop: one targeted red/green interruption case proving the launched-actor path changes from no trusted result to exactly one accepted `INTERRUPTED` result before release, plus one focused negative control proving the new integration is load-bearing.
Evidence explicitly deferred: interruption before run identity or before actor launch; the general pre-run evidence boundary; usage, infrastructure and lease-refusal result migration; the wider signal/descendant matrix; semantic outcome/next-action tuple validation; dedicated permission-result rows; status and resume; crash-boundary and hostile-input matrices; Change sets B–D; live trials; adoption review; the full synchronous regression gate; merge, push, deployment and destructive cleanup.
Primary edit begins after: a focused fixture interrupts one launched disposable actor and quotes the current red observable—exit 28 occurs through `on_signal()`, but no run-bound terminal result is accepted before the release path.

Required outcome:

- For a run with established `RUN_ID` and a launched actor, SIGINT or SIGTERM still stops the actor tree, never retries the request, and exits through a terminal classification that truthfully represents interruption.
- Exactly one versioned run-bound terminal result is finalized from the post-teardown facts and reports at least `outcome=INTERRUPTED`, `code=28`, the actual actor-launch/model-request availability facts, state/HEAD/worktree facts, capture/log paths, and the observed pinned-or-releasable lease condition.
- The existing accepted result path—producer, path/structure/identity validation, and consumer gate—remains the single owner. Do not add a second result parser, signal-only schema, evidence location or lifecycle reader.
- A cleanly stopped actor permits release only after the promised result has been consumed successfully. Uncertain teardown continues to pin the applicable lease; result publication or consumption that cannot be proved must not fall through to the ordinary exit-28-and-release behavior.
- Preserve existing interruption wording, no-retry behavior, descendant termination and pinned-lease semantics except where a minimal wording adjustment is required to report the trusted result or fail-closed classification honestly.
- Do not solve the earlier timing windows in this unit. A signal before run identity or before actor launch remains explicitly deferred rather than approximated, and this unit must not claim that every interruption path is now covered.

Check against the repository before editing:

1. Verify in the live `dispatch.sh` that `on_signal()` still performs teardown and partial-effect reporting, then calls `release_lock` and exits 28 without finalizing and consuming the accepted terminal result. If that premise is false, hand back rather than creating a second integration.
2. Verify the accepted `finalize_terminal_result()`, `consume_terminal_result()`, terminal-unprovable path and pinned-beats-release lease behavior are callable on the launched-actor signal timing being tested. If safe reuse requires a new shared parser, schema or state store, stop.
3. Locate the smallest existing Case 27 fixture that launches an actor, delivers SIGTERM or SIGINT and observes exit 28. Extend one focused slice; do not rerun or redesign the full signal/descendant matrix before the primary edit.
4. Treat the approved plan's Change set A terminal-result list, durable ordering and every-terminal acceptance as governing. The abandoned discovery brief and Unit 4's historical map are background only; neither may add requirements.

Required fail-capable evidence:

- Quote the targeted red before the edit and focused green after it, including result count, `outcome`, `code`, actor-launch fact, completion sentinel, consumer acceptance and lease disposition.
- Include one mutation or negative control that removes or bypasses only the new interruption-result integration and makes the targeted proof fail while the interruption fixture still reaches exit 28.
- Show that clean teardown releases only after consumption, while an existing pinned-teardown control remains pinned; do not rerun the broad descendant matrix.
- Show the result-publication/consumption failure route cannot silently release and report an ordinary successful exit 28.
- Run shell syntax checks and only the focused interruption/result slice plus directly affected regression controls. Report why any broader suite is deferred.
- Report the implementation commit and exact changed paths. Only `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, and this task state may change; `logs/friction-log.md` remains pre-existing session noise and must not be staged or committed.

Capability subset: baseline only — inspect the approved plan and accepted dispatcher/test seams; edit only the two spike files and this task state; run focused local tests and shell syntax checks; make the local handback commit. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No external service, production action or operator-reserved capability is needed.

Completion condition: one committed implementation makes a launched-actor SIGINT/SIGTERM terminal produce and consume exactly one trusted interruption result before any releasable lease is released; targeted fail-capable evidence and the focused controls are green; no earlier interruption window or deferred terminal family is claimed complete; only the three permitted paths change; and the task returns with `turn: codex`.

Stop and hand back if the launched-actor signal path cannot safely reuse the accepted result producer/consumer; if correct ordering requires a new schema, parser, state store or material architecture change; if the targeted fixture cannot distinguish publication, consumption and release order; or if the work requires covering pre-run interruption windows in the same unit. Challenge a false premise rather than widening.

## Latest result

Accepted Unit 22 at `c3af91551be9c2a18de3f9ba42cb10ddd87c0dfd` (2026-08-17): `CURRENT SEMANTICS TRUTHFUL`. Disposable Git cases proved default porcelain collapses multiple files under a new untracked directory to one status entry while `--untracked-files=all` reports each file. The complete consumer trace proved `worktree_foreign_paths` is used only for non-empty and whole-listing comparisons, never as an exact-value decision; a foreign directory created during a launched hop still trips the fail-closed guard because every admitted hop begins from an empty foreign baseline. The strongest repository statement defines the helper's unit as working-tree lines, and no approved plan, schema, test or consumer defines an individual-file count.

Accepted limitation: `worktree_foreign_paths` and `worktree_allowlisted_dirty_paths` are adjacent same-suffix fields whose counts are not comparable for collapsed untracked directories, and the record does not state their units. This is a presentation/naming limitation only: both values are truthful under their producers' documented units and no Gate SA decision consumes the numeric relationship. No behavior change is authorized from it.

Deferred without implementation: possible record-level unit clarification; the separate `carry-turn.sh` allowed-line collapse; and the conservative, default-unreachable untracked-ancestor straddle case. The abandoned discovery version of Unit 23 produced no accepted result and is not part of task progress.

Inspected (2026-08-17), against the live files at `fe80eccf`:

- Claim (1) — `on_signal()` tears down and reports, then releases and exits 28 without the accepted result path: **HOLDS**. `dispatch.sh:2381-2421` ran `terminate_actor_tree` / `report_teardown` (guarded on `ACTOR_PGID`), appended `partial_effect_block`, printed to stderr and `RUN_LOG`, then `release_lock; exit 28`. Searched the whole function for `finalize_terminal_result` and `consume_terminal_result`: no match. The premise is true, so no second integration was created.
- Claim (2) — the accepted producer, consumer, unprovable paths and pinned-beats-release behaviour are callable at launched-actor signal timing: **HOLDS**. `finalize_terminal_result()` `:747`, `consume_terminal_result()` `:1963`, `die_terminal_unprovable()` `:1869`, `die_terminal_untrusted()` `:1883`, `release_lock()` `:1980` are all defined far above the hop loop, so all are in scope once an actor has been forked. The outcome table at `:583` already maps `28) INTERRUPTED`, so **no schema, parser, evidence location or lifecycle reader was added** — the code path reuses the existing owner exactly as the three accepted code-zero seams do.
- Claim (3) — smallest existing Case 27 fixture: **HOLDS**. Case 27 `dispatch.test.sh:1908` launches a simulated actor, delivers SIGTERM and asserts exit 28. Extended that one slice; the broad descendant matrix was neither redesigned nor rerun before the primary edit.
- Claim (4) — plan governs: **HOLDS**. Change set A required behaviour 3 lists "actor timeout, interruption, or failure" among the terminal classes that must finalize exactly one result (`plan:151`); durable ordering item 6 requires a lease released only after the terminal result exists (`plan:196`). The abandoned discovery brief added no requirement here.

Result: an interruption **after an actor has been forked** now finalizes and consumes exactly one trusted `INTERRUPTED` terminal result before any releasable lease is released. Two guarded lines were added to `on_signal()`, reusing the accepted producer and consumer unchanged. Interruption wording, no-retry behaviour, descendant termination and pinned-lease semantics are untouched. Windows before the first fork are deliberately left on the old path and are asserted to stay there.

Evidence:

**The production change.** `dispatch.sh` is **purely additive — 36 insertions, 0 deletions**, of which six lines are executable and the rest is the comment recording why:

```
[ "${ACTOR_PROCESS_STARTED:-0}" -eq 1 ] && { finalize_terminal_result 28 || die_terminal_unprovable "the interruption terminal after a launched actor"; } # interruption terminal finalization
[ "${ACTOR_PROCESS_STARTED:-0}" -eq 1 ] && consume_terminal_result "the interruption terminal after a launched actor" # interruption terminal consumption
if [ -n "$RESULT_FILE" ]; then
  printf '  terminal result: %s\n' "$RESULT_FILE" >&2
  [ -n "${RUN_LOG:-}" ] && printf '  terminal result: %s\n' "$RESULT_FILE" >>"$RUN_LOG"
fi
```

Placed after the existing interruption message and **before** `release_lock`. Two design choices are load-bearing and were not defaults. The guard is `ACTOR_PROCESS_STARTED`, not `ACTOR_PGID`: the two differ between hops — `ACTOR_PGID` is cleared when a hop ends (`:3385`, `:3396`) while `ACTOR_PROCESS_STARTED` stays 1 (`:3361`) — and a between-hops signal is still an interruption after a launch. It is also the same fact the record's own `stage` and `actor_launched` derive from (`:769`), so the guard and the record cannot disagree. And each half is one self-contained line with its own marker, so a mutation control can delete either without leaving an orphaned block.

**Red, quoted on the pre-edit dispatcher** (focused slice, `9 pass / 13 fail`):

```
PASS  27r — still exits 28 INTERRUPTED, unchanged
FAIL  27r — exactly one finalized result, no partial left behind   results=0 partials=0
FAIL  27r — the record carries outcome=INTERRUPTED                 got:
FAIL  27r — the record carries code=28                             got:
FAIL  27r — the record ends with its completion sentinel           last:
PASS  27r — a clean teardown releases the lease after consumption
FAIL  27s — an unprovable interruption exits 38, NOT an ordinary 28   expected 38, got 28
FAIL  27s — the lease is retained, so a second dispatcher is refused  ...lock was released
FAIL  27t — M29 ... finalization matches=0 consumption matches=0 — the control cannot run
```

That is the brief's red observable exactly: exit 28 through `on_signal()`, no run-bound result accepted before release — and 27s shows the sharper half, a run whose result could not be published releasing its lease on an ordinary 28.

**Green, same slice, repaired dispatcher: `25 pass / 0 fail`.** All fifteen 27r rows pass, including `outcome=INTERRUPTED`, `code=28`, `stage=post-hop`, `actor_launched=yes`, `model_request_started=no`, `task=sig-evidence-task`, the `result_complete=yes` sentinel, one result with zero partials, no consumer scratch left behind, the evidence path reported to the operator, the lease released, and both unchanged-wording rows.

**The four cases added** (`dispatch.test.sh`, after case 27q):

- **27r** — the main red/green case. `model_request_started=no` is asserted deliberately: the actor is simulated, and a terminal that started claiming `yes` because a fixture hung would falsify the field a supervised-use claim rests on.
- **27r-deferred** — the scope claim, made checkable. A dispatcher held before its first launch (by a deliberately slow ownership helper) and then interrupted must **still exit 28 with no result**. It passed before the edit and after it, which is what proves this unit did not quietly cover the deferred window.
- **27s** — the fail-closed half. The evidence directory is made unwritable while the actor hangs, so finalization fails on a real failed write. Exit **38**, lease **retained**, and the operator told the ending could not be proved.
- **27t (M29)** — the mutation control. Removes only the two marker lines from a throwaway copy; fails closed on absence, duplication, a non-differing mutant or one that does not parse. Under the mutant: exit 28 still reached (so the fixture is not merely broken), **no result published**, and the lease **released on an unproven ending** — which is precisely the hole 27r closes.

**Regression controls, both green against the repaired dispatcher:**

- **The whole case-27 family — `141 pass / 0 fail`.** Includes the base release control (case 27) and every pinned-teardown control (27k, 27ka, 27kb, 27L), so "clean teardown releases after consumption, uncertain teardown stays pinned" is shown on the existing cases rather than a new one. The broad descendant matrix was run as a regression control only, not redesigned.
- **Cases 56 and 57 — `45 pass / 0 fail`.** The operator-terminal consumer family and the die-funnel unprovability family: the seam this unit adds a caller to.

`bash -n` clean on both changed files.

**Why the broader suite is deferred:** the brief scopes this hop to the focused interruption/result slice plus directly affected controls, and the three runs above are that surface. Two limits are disclosed rather than left implicit. First, cases 58b onward could not run inside the focused slice — they read `VAL_LIB`, a global assigned at `dispatch.test.sh:5591` in the case-50 region outside the sliced preamble; that is a harness-slicing limitation, not a failure, and 58a itself ran green. Second, the full suite was not rerun, so no claim is made about untouched families beyond the controls listed.

**Runtime profile.** Baseline capability subset only. Edits confined to the two permitted spike files and this state file; focused local test runs and `bash -n`; one local commit. No external service, no model request, no operator-reserved capability, and no effective sandbox or network containment is claimed for this host.

Deferrals recorded, none implemented:

1. **Interruption before the first fork stays uncovered** — both the pre-`RUN_ID` window and the post-`RUN_ID`-pre-launch window. Not approximated: `finalize_terminal_result()` refuses the former at its own run-identity guard (`:752`), and routing either through `die_terminal_unprovable` would convert a clean interruption into an unprovable-ending 38. Case 27r-deferred pins the current behaviour so the gap cannot close silently.
2. **The 38 failure path prints the partial-effect block twice** — once from `on_signal()` and once from `die()` (`:1264`), because the handler already appended it before transferring. Cosmetic, on the failure path only; not worth a wording change inside a unit whose brief says to preserve existing interruption wording.
3. **`remaining_seconds()` (`:3418`) is still defined below the `die 31` at `:2987`**, so an exit-31 terminal reached with `--deadline` set publishes an empty `deadline_remaining_seconds` beside `result_complete=yes`. Measured during the superseded discovery work and recorded in commit `fe80eccf`; it is Unit 21's defect class, live, and independent of this unit.

## Blocker

None.

## Next action

Codex: assess the launched-actor interruption integration. Two guarded lines in `on_signal()`, no new schema, parser, evidence location or lifecycle reader; focused slice `9/13` red to `25/0` green; case-27 family `141/0` and cases 56–57 `45/0` as directly affected regression controls; M29 proves the seam load-bearing; production diff purely additive at 36 insertions and 0 deletions. Decide whether the pre-launch interruption windows open as the next unit, or whether the `remaining_seconds` defect in deferral 3 takes priority.

