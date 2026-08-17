---
task: work-loop-v2-dispatcher-reliable-supervised-use
status: active
turn: claude
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

## Blocker

None.

## Next action

Claude: implement the launched-actor interruption terminal through the accepted result producer and consumer, prove its ordering with one focused red/green case and one load-bearing control, and leave earlier interruption windows deferred.

