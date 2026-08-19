---
task: work-loop-v2-dispatcher-supervised-semi-agentic-use
status: active
turn: codex
---

## Objective and scope

Implement the approved lean plan at `plans/work-loop-v2-v0.2/work-loop-v2-dispatcher-reliable-supervised-use-implementation-plan-v0.1.md` through its Gate SA acceptance contract and independent adoption review, so the dispatcher may truthfully carry the label **Ready for supervised semi-agentic use — durable terminal results are guaranteed after run admission.**

Scope: the existing supervised dispatcher, focused proof, three supervised trial shapes, and one synchronous regression gate. Excluded: invalid-pre-admission durable results; Gate ST/U; unattended or walk-away claims; rewrite/migration; token usage budgets; state-size thresholds; exhaustive status; duplicate live proof; speculative retention work; merge, push, deployment and destructive cleanup.

Task exit condition: one integrated candidate has passed the approved lean Gate SA and the independent review has returned `ADOPT`, or Patrik has explicitly chosen `SHRINK` or `STOP`.

## Lane and unit

Standard. Implementation mode. Unit 31 — prevent automatic post-launch replay

Named reason for the loop: the approved objective spans multiple bounded implementation, proof and operating-trial units, must survive session boundaries, needs its scope held against overengineering, and requires independent Codex assessment before it counts as complete.

## Brief

The approved outcome remains one integrated candidate that passes lean Gate SA and an independent `ADOPT` review. Current position on 2026-08-19: minimum-contract item 1 is accepted at `a4b8645a3ecd1ca02c191cd1d3c55cfdaab08e4b`; Unit 30 is accepted at `52add0fd93bcc700d01cd568fe71e1be91031ad0`; item 2 now has its whole-run deadline control but still lacks automatic-replay prevention, separate normal/correction ceilings and nested-AI prevention/reporting. This unit implements only automatic-replay prevention after an actor has launched.

Plan justification and source disposition: governing authority is the approved content of `plans/work-loop-v2-v0.2/work-loop-v2-dispatcher-reliable-supervised-use-implementation-plan-v0.1.md` at commit `cfd5868183f0bc0afa762e080fa6ff78979d539a`, blob `244f793cb190863b963d0026cf64e235954c248b`. Its minimum release contract item 2, Change set B and Gate SA require that no started model request is automatically retried and permit retry only for a named, mechanically proven zero-model preflight failure with unchanged facts. The working file's HEAD blob moved during accepted Unit 28 bookkeeping; verify before acting that its retry contract is semantically identical to the approved blob, and stop on a material difference rather than treating the mutable path as newly approved.

Dominant deliverable: prevent every automatic replay after an actor process has launched.
Evidence required in this hop: one targeted pre-edit failure showing a nonzero actor exit with unchanged repository facts launches the actor twice; the same case after the edit showing exactly one launch and truthful takeover; focused protection for timeout, partial-effect and explicit-new-run boundaries; exact command counts.
Evidence explicitly deferred: normal/correction corridor separation; nested-AI prevention/reporting; runtime-preflight item 3; concise status/takeover item 4; live trials; full regression; adoption; pre-existing harness failures; capture-volume decisions; merge, push, deployment and destructive cleanup.
Primary edit begins after: the nearest existing crash-retry case is made to require one launch and shown failing because the current dispatcher performs an automatic replay.

Required outcome:

- Once the dispatcher has launched an actor process for a hop, any nonzero exit, timeout, missing result, denial or partial-effect condition ends that run without automatically launching the request again.
- Retry remains permissible only for a named condition that is mechanically proven to occur before any model request and before actor launch, with state, HEAD, index, working tree, authority and runtime facts unchanged. If no current condition meets that proof, zero automatic retries is the correct lean result; do not infer "no model started" from repository immutability, exit status or missing actor output.
- An explicit operator-started new run after takeover remains distinct and unaffected; it must not be implemented as replay inside the stopped run.
- The durable terminal result and operator-facing action truthfully describe the single failed launch and takeover. Remove or revise any retry-specific run-log, capture or status claim that would otherwise become false.
- Preserve the already-correct no-retry behavior for timeout and partial effects, and do not reopen Unit 30's deadline contract.

Check against repository before editing:

1. Verify Unit 29's claim against the current launch/retry loop in `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`: repository-effect equality currently permits a retry after a forked actor returns nonzero, while pre-fork failures exit by another path. Treat Unit 29's line numbers as pointers.
2. Verify the nearest existing cases in `dispatch.test.sh`, especially the case that currently expects one `1r` retry after a pre-edit crash and the case proving partial effects prevent retry. Search the dispatcher test surface for every assertion or artifact name tied to automatic retry; bound the change to those direct consumers.
3. Verify any directly affected dispatcher documentation and edit it only where the public contract would otherwise become false.
4. Preserve the accepted admission, deadline, terminal-result, owner and lease ordering. Stop if eliminating replay requires a second state system, reconstructing missing truth or weakening an accepted invariant.

Required fail-capable evidence:

- Quote the targeted red result before the production edit: the actor launches twice where the new requirement permits exactly one launch.
- After the edit, show the same case produces exactly one launch, no retry capture/artifact, the expected nonzero/takeover terminal result and the correct next action.
- Show focused existing timeout and partial-effect cases still produce one launch and no retry, and show that a separately invoked new run remains possible only through the existing explicit admission path.
- Report exact commands, pass/fail counts and changed paths. Explain any meaningful regression check not run; do not substitute a ceremonial grep.
- Confirm the approved plan content is unchanged, only task-scoped dispatcher source/test/directly affected documentation plus this state file are committed, and `logs/friction-log.md` remains unstaged.

Codex framing decision: absent a mechanically proven zero-model preflight class, the minimum safe implementation is zero automatic retry after actor launch. This is a technical judgment inside the approved envelope, not an operator requirement and not permission to remove explicit new-run recovery.

Capability subset: baseline only — read, focused local tests, edits within `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, its focused test file, directly affected dispatcher documentation, this state file, and local commits. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No full suite, live model, network, merge, push, deployment, destructive cleanup or operator-reserved capability is authorized.

Completion condition: one committed implementation handback proves that a run never automatically replays after actor launch, while explicit operator-started recovery remains a new admitted run and accepted timeout, partial-effect and deadline behavior stays intact, then sets `turn: codex`.

Stop and hand back on a false premise, material plan-content difference, inability to distinguish a proposed safe preflight retry from actor launch, need for missing-truth reconstruction or a second state system, scope outside the named dispatcher surface, inability to produce fail-capable focused evidence, or any operator-reserved decision.

## Latest result

Inspected (2026-08-19):

- Plan equivalence: HOLDS — `git diff cfd58681 -- plans/work-loop-v2-v0.2/work-loop-v2-dispatcher-reliable-supervised-use-implementation-plan-v0.1.md` is 6 insertions / 6 deletions, all of them approval-status bookkeeping (draft→approved wording in the header, § 2 amendment note, activation item 6, and the § 5 minimum-release-contract heading). Searched the working blob `b6e239f8` for every retry and replay line: § *Retry and execution budgets* ("Never automatically retry after any model request starts"; the zero-model preflight proviso), the Gate SA line "No started request is retried in timeout, failure, missing-result, denial, or partial-effect cases", and release-claim lines 477 and 484 are byte-identical to approved blob `244f793c`. No material difference; the mutable path is not treated as newly approved.
- Claim (1): HOLDS — read `dispatch.sh` 5036–5074 (pre-edit). A nonzero actor exit whose state sha256, HEAD, foreign working tree and state-file committed-ness all matched the pre-launch baseline fell into `launch_actor "$before_turn" "${hop}r" "$eff_timeout"` — one automatic replay after the fork. Pre-fork failures leave by another path and never reach it: searched `launch_actor` for its own exits and found `die 20` on an unexecutable `CODEX_BIN`, `die 20` on an unresolvable claude binary, and `die 11` on a failed `cd` into the checkout, none of which return a status into that guard.
- Claim (2): HOLDS — read `dispatch.test.sh` case 15 (pre-edit, lines 2002–2020), which asserted exit 0, the run-log line `retrying this hop once`, exactly one `.hop1r.claude.out` capture, and `calls == 1`; and case 15b, which asserts exit 20 and `not retried` after a partial effect. Searched the whole dispatcher test surface for retry-tied assertions and artifact names — `grep -n -i "retry\|retried\|replay\|1r\b\|hop1r\|}r\"" dispatch.test.sh` — and found exactly three direct consumers: case 15, case 15b, and the `DIE29_HITS` site count at line 4344 that expected `4` (the two proved budget shapes plus their two retry variants). The other hits are the interruption/denial/budget no-retry promises (27r, 27u, 73b/73d) and the unrelated `die 38` finalization retry in case 50m, none of which the actor-replay path touches.
- Claim (3): HOLDS — searched `README.md` for retry and replay claims and found four that the change would falsify: the `--deadline` clamp line "Before every launch — including a retry", the exit-code table row for `20` ("is retried **once** first"), the case table rows for `15`/`15b`, and the safety bullet "One retry, and only from proven repository truth". The remaining hits (`28`, `29`, `37`, the interruption bullets) are no-retry promises that stay true.
- Claim (4): HOLDS — the admission, deadline, terminal-result, owner and lease ordering is untouched by this change: it edits one nonzero-exit branch inside the hop loop, below the pre-launch guards and above the post-hop classification, and adds no state. Verified after the edit that every exact-line mutant anchor the suite depends on still resolves — M41 die-funnel transfer `1`, M31 run-evidence guard `2`, M28 `LAUNCHED_ACTOR` `1`, the stream-json launch line present, `die 26` `1`, `die 37` `1`, one `remaining_seconds` definition. No second state system, no reconstructed truth, no weakened invariant.

Result: no dispatcher run automatically replays a hop once its actor process has launched. The one-shot crash retry is removed from `dispatch.sh`: a nonzero actor exit now ends the run at `die_hop 20` on both shapes — repository-unchanged and partial-effect — and the unchanged shape says in plain words that an unchanged repository does not prove the model request never started, that the dispatcher does not read the child's stream events and records `model_request_started=unavailable`, that canonical task state is untouched so the stopped run and its terminal result are the takeover, and that recovery is a re-run which starts a NEW run. Timeout (`21`), budget (`29`), interruption (`28`), denial (`37`) and partial-effect (`20`, `25`) behaviour is unchanged, and Unit 30's deadline contract is not reopened. Removing the replay removed the only two budget terminals a second launch could reach, so `die 29` now has two producer sites rather than four. Documentation was edited only where the public contract would otherwise have become false: the four README surfaces above, plus the exit-`20` header line and two dispatcher comments that described the retry branch.

Evidence: `bash focus.sh` extracts the real harness preamble plus whole case regions from `dispatch.test.sh` and runs them against `DISPATCH_BIN`, so the assertions are the suite's own.

- Targeted failing case, quoted before the production edit. Case 15 was rewritten to require exactly one launch, with a launch counter that increments before the fixture decides whether to crash — `.calls` could not do that job, because the flip that writes it is never reached by a crashing attempt, which is how the old case asserted "exactly one successful actor call" while two actors had run. Against the unedited `dispatch.sh`: `FAIL the crashed hop ends the run instead of replaying it — expected exit 20, got 0`; `FAIL the actor was launched exactly once — launches=2`; `FAIL no retry capture was written — a hop1r capture is present`; `pass=4 fail=7`.
- The same case after the edit: `pass=8` on case 15 — exit `20`, `launches=1`, no `retrying this hop once` in the run log, the stop says `NOT retried` and why, zero `.hop1r.` captures, `calls=0`, `turn: claude` exactly where the actor left it, and the terminal result recording the single launch (`actor_launched=yes`, `stage=post-hop`).
- Boundaries. Case 7 (actor exits nonzero → 20; actor exceeds timeout → 21, fired on wall clock), case 14 (an actor blocked on an approval is killed on the clock, the state file does not move), case 15b (partial effect → 20, one launch not two), and cases 28/28b/28c/28d/28e (both budget shapes, the `die 29` site count now `2`, no-deadline simulated behaviour, `--deadline` validation, and Unit 30's live multi-hop deadline requirement with all four of its controls) all pass: `pass=86 fail=0`.
- Explicit new run. New case 15c re-enters case 15's own sandbox — captured there, because case 15b reassigns `$d` in between — and starts a second dispatcher invocation through the ordinary admission path. It completes the hop (exit 0), the launch counter reads `2` across two runs rather than 2 inside one, there are two terminal results with distinct `run` identities, and the turn moves. Recovery is a separate admitted run, not a replay inside the stopped one.
- The no-retry promises that had to survive: cases 27r and 27u, the interruption terminals, `pass=55 fail=0`.
- Exact commands, all run from the spike directory with `DISPATCH_BIN`/`REPO_ROOT` pointed at this checkout: `bash focus.sh red15.sh 2002-2064` then `bash red15.sh` (the red baseline, `pass=4 fail=7`); `bash focus.sh green.sh 652-673 1968-2001 2002-2097 4159-4459` then `bash green.sh` (`pass=86 fail=0`); `bash focus.sh nr.sh 3483-3585 3586-3775` then `bash nr.sh` (`pass=55 fail=0`). 141 focused assertions pass, 0 fail. `bash -n` parses both `dispatch.sh` and `dispatch.test.sh`.
- Not run, and why: the full dispatcher suite, which `Evidence explicitly deferred:` defers for this hop. Its statically affected regions were run instead, and the static sweep above establishes that the three test consumers and the seven mutant anchors are the whole of the change's reach into it. No ceremonial grep was substituted for a check.
- Changed paths, task-scoped only: `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/README.md`, and this state file. The approved plan content is unchanged — it is not in the commit. `logs/friction-log.md` was already modified before this hop and remains unstaged.

## Blocker

None.

## Next action

Codex: assess Unit 31 — whether removing the post-launch replay, with recovery kept as an explicitly started new run, satisfies the automatic-replay half of minimum-contract item 2, and whether the deferred evidence was correctly deferred rather than downgraded.
