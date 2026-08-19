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

Standard. Discovery mode. Unit 29 — establish bounded-execution coverage

Named reason for the loop: the approved objective spans multiple bounded implementation, proof and operating-trial units, must survive session boundaries, needs its scope held against overengineering, and requires independent Codex assessment before it counts as complete.

## Brief

Unit 28 is accepted at `a4b8645a3ecd1ca02c191cd1d3c55cfdaab08e4b`. Permission denial now stops with one read-only takeover result, status names the exact restart, and an explicit `acceptEdits` invocation starts a distinct revalidated run without dispatcher task-state mutation or automatic replay. The approved minimum release contract's second item is bounded execution: no replay after model start, finite normal/correction hop ceilings, one whole-run deadline, and zero nested AI by default.

These controls substantially predate this task. Rebuilding them without first establishing current coverage would be waste. This one state-only discovery checks only minimum-contract item 2 and returns either `COVERED` or one concrete missing behavior; it is not a broad acceptance map and may not create tests or implementation.

Dominant deliverable: determine whether minimum-contract item 2 is already covered, or identify its one smallest release-blocking gap.
Evidence required in this hop: bounded producer/control/test trace for the four retained controls; existing fail-capable focused evidence only; exact current limitation where a control is requested or observed rather than prevented.
Evidence explicitly deferred: all implementation and new tests; runtime-preflight item 3; concise status/takeover item 4; live trials; full regression; adoption; pre-existing harness fragility; capture-volume decision; merge, push, deployment and destructive cleanup.

Required outcome:

- Establish whether any post-start timeout, failure, missing result, denial or partial-effect path can automatically launch/replay another model request in the same run. Distinguish an explicit operator-started new run from automatic replay.
- Establish the enforced normal ceiling for implementation → assessment → closure and the separate one-correction/one-reassessment corridor, including what happens before an excess launch.
- Establish that every live multi-hop run has one finite whole-run deadline and that exhaustion stops before another launch.
- Establish the strongest default nested-AI control separately for Claude and Codex actor paths. Distinguish requested prevention, observed descendants and unknown status; do not promote observation to prevention.
- For each control, identify the production owner and nearest existing fixture/mutation capable of failing. Reuse accepted evidence where it directly settles the claim; run only a narrow existing slice where inspection cannot.
- Return exactly one verdict: `COVERED`; `IMPLEMENTABLE GAP — <one smallest target>`; or `RUNTIME CAPABILITY GAP — <exact limitation>`. If several symptoms share one missing enforcement seam, name that seam. If independent material gaps exist, stop and report that the minimum-contract item cannot remain one implementation unit.

Check against repository:

1. Inspect only the launch loop, retry/restart branches, hop/deadline admission guards, nested-actor deny/census logic and their nearest existing cases. Do not reopen Change set A or Unit 28.
2. Do not run the full dispatcher suite, create a case selector, add fixtures, mutate production, or fix the three pre-existing harness failures.
3. Verify the current approved plan records Patrik's approval against commit `cfd5868183f0bc0afa762e080fa6ff78979d539a`, blob `244f793cb190863b963d0026cf64e235954c248b`, without changing it.

Required fail-capable evidence:

- Name exact guards/branches and existing cases for each retained control, including the behavior an excess or missing control would produce.
- Quote any existing negative control/mutant that would fail if replay, ceiling, deadline or nested status were weakened; do not construct another.
- State plainly where Codex and Claude differ and whether that difference satisfies the approved lean Gate SA.
- Report exact focused commands/counts if any command runs. A reasoned no-run disposition is valid where accepted existing evidence and code/test inspection settle the claim.
- Confirm only this state file changed and was committed; leave `logs/friction-log.md` unstaged.

Capability subset: baseline read-only investigation plus committing this state file. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No source/test/plan edits, new fixtures, full suite, model/network, merge, push, deployment or destructive cleanup.

Completion condition: one committed state-only handback returns the bounded-execution verdict with enough existing fail-capable evidence for Codex either to accept minimum-contract item 2 as covered or open one concrete implementation target, then sets `turn: codex`.

Stop and hand back if the question requires a new fixture, live model, source edit, broad audit, or an authority decision rather than current repository evidence.

## Latest result

Inspected (2026-08-19):

- Claim (1) — scope constraint, honoured: inspection stayed inside the launch loop (`dispatch.sh:4890-5012`), the retry branch (`4974-5011`), the hop and deadline admission guards (`4901-4938`), the nested deny set (`355-394`) and the launch argv (`4490-4654`), plus their nearest existing cases. Change set A and Unit 28 were not reopened.
- Claim (2) — scope constraint, honoured: no command was run against `dispatch.test.sh`, no case selector, fixture, mutation or production edit was created, and the three pre-existing harness failures were not touched. Read-only `grep`/`sed`/`git` only.
- Claim (3): HOLDS — `git rev-parse cfd58681…:plans/work-loop-v2-v0.2/work-loop-v2-dispatcher-reliable-supervised-use-implementation-plan-v0.1.md` returns `244f793cb190863b963d0026cf64e235954c248b`, exactly the blob the plan's § 3 status line, § 2 amendment header, activation item 6 and approval record all name. `git diff cfd58681… --` on that path returns 6 insertions / 6 deletions, all six being the draft→approved bookkeeping lines; no objective, boundary, cut, acceptance condition or authority relationship differs. The plan was not changed by this unit.

Result: **NOT COVERED. Minimum-contract item 2 cannot remain one implementation unit** — its four controls fail on four independent surfaces, and no single enforcement seam produces them. Codex must split item 2 or re-scope it.

- **(a) No automatic replay after a model request starts — GAP, wrong guard fact.** The crash-retry branch (`dispatch.sh:4980-5008`) relaunches the actor whenever the child exits nonzero and the repository is byte-unchanged (state sha256, HEAD, foreign worktree, committed-ness). That condition tests *repository effect*, not *model-request start*. Every nonzero status reaching it came from a forked child: all four pre-fork failures in `launch_actor()` (`4516`, `4527`, `4559`, `4652`) call `die`, and `run_bounded()` returns the child's own `wait` status (`4433-4436`). The dispatcher itself concedes it cannot establish the fact the plan keys on — `finalize_terminal_result()` sets `started=unavailable` whenever `MODE = live` (`1034`), with the comment "a live fork is not [a model request] either… whether it did is in the child's own stream events, and nothing in this dispatcher reads them". So in live mode a `claude`/`codex` child that issued a model request, then exited nonzero without touching the repository, is automatically relaunched. Plan Change set B requires retry "only [for] a named, mechanically proven zero-model preflight failure", and its acceptance line requires "No started request is retried in timeout, failure, missing-result, denial, or partial-effect cases" — the *failure* case is the one that fails. Timeout (`4967-4972`) and partial-effect (`5006`) are correctly not retried.
- **(b) Finite normal and correction hop ceilings — GAP, corridor absent.** There is one flat counter: `MAX_HOPS=4` (`319`), operator-settable to any positive integer via `--max-hops` (`1689`, `1714-1715`), pinned to 1 only under `--carry-one` (`1730`). It is enforced pre-launch at `4901-4902` (`die 23`). There is no three-hop normal corridor and no separate correction corridor: `grep -n 'Correct once\|frozen findings\|Close the task' dispatch.sh` returns nothing, and the only `stage` values are `pre-hop|launch|post-hop` (`1021-1036`) — launch position, not Work Loop stage. The dispatcher therefore cannot tell a correction hop from a normal one, so "correction cannot exceed its separate ceiling" is unenforceable as built.
- **(c) One whole-run deadline — GAP, mechanism complete but not required.** `DEADLINE=""` by default (`321`); `DEADLINE_AT` stays empty (`3788-3789`) and `remaining_seconds()` returns `2147483647` (`3670`), so every deadline guard (`4936`, `4968`, `4989`, `4999`) is skipped. Nothing at admission requires a deadline for a live multi-hop run. Where a deadline *is* given, the control is sound and proven. Additionally, the no-deadline log line advertises "upper bound is max_hops * timeout" (`3800`) and that figure is understated by up to 2×: with no deadline the retry re-launch takes a fresh unclamped `effective_timeout` (`4485-4488`, `4992`), so the true default worst case is 4 × 2 × 900 s ≈ 7200 s, not 3600 s.
- **(d) Zero nested AI by default — GAP, Claude-only, and unrecorded.** `NESTED_ACTOR_DENY` (`389-394`) reaches only the attended Claude branch (`4623-4646`); it is deliberately excluded from `--unattended` (`4564-4580`, a settled separate boundary). The Codex branch launches `codex exec --sandbox workspace-write -C <checkout> --json` (`4520-4522`) with **no** nested-actor refusal of any kind — the asymmetry is not published in `README.md` § *The default nested-actor deny set* (`438-470`), which describes the Claude path and the unattended exclusion only. Whether `codex exec` can carry an equivalent refusal was **not** established here and remains unknown status, not "impossible". Separately, neither requested nested policy nor observed descendants appears in the terminal result: `TERMINAL_RESULT_REQUIRED` (`1172`) has no such field, and the census (`2704-2900`) exists for teardown, so no path stops on observed or uncertain expansion. Plan Change set B's fallback ("publish the exact limitation and stop on observed or uncertain expansion") is therefore also unmet.

Claude/Codex difference: only (d) is an actor-path asymmetry. (a), (b) and (c) apply identically to both actors. Against the approved lean Gate SA, (d)'s asymmetry is not satisfied on either limb — neither symmetric prevention nor the published-limitation fallback.

Evidence: no command was run against the suite; a reasoned no-run disposition applies, because the existing accepted cases pin each current behaviour by inspection and each would go red under the plan's required behaviour. `dispatch.test.sh` case 15 (`2006-2021`) asserts the pre-edit crash **is** retried once and that exactly one hop`1r` capture appears — it fails the moment a post-fork live retry is refused, which is the fix (a) needs. Case 15b (`2023-2031`) asserts the post-edit crash is **not** retried (exit 20, one launch) and is the fail-capable negative control that would go red if the partial-effect guard were weakened. Case 8 (`676-681`) asserts `--max-hops 2` yields exit 23 after exactly 2 launches — it proves the flat counter and would need rewriting for any corridor split, and nothing anywhere asserts a correction ceiling. Case 28c (`4277-4282`) asserts by name that "no --deadline keeps the old unbounded-by-clock behaviour" and passes today — it is the exact case that must go red for (c). Case 28b (`4174-4232`) proves an expired clock refuses the next hop pre-launch, and case 28 (`4089-4145`) pins the ~9 s teardown overrun arithmetic; both stay green under (c)'s fix. Case 40 (`5635-5665`) captures the literal child argv and asserts all four deny rules plus `--permission-mode default` reach it, and case 40b (`5667-5686`) that `--claude-deny` appends rather than replaces — both are fail-capable on argv, and both cover the Claude path only; `grep -n 'codex exec\|sandbox workspace-write' dispatch.test.sh` returns **no** match, so the Codex launch argv is asserted nowhere. Only this state file was changed and committed; `logs/friction-log.md` was left unstaged.

## Blocker

None.

## Next action

Codex: item 2 returned four independent gaps on four surfaces — (a) retry guard keys on repository effect rather than proven zero-model start, (b) no normal/correction corridor split and no stage awareness, (c) whole-run deadline optional at admission, (d) Codex path carries no nested-actor policy and nothing records or stops on it. Decide how to split or re-scope minimum-contract item 2, and open one concrete implementation target. Two decisions belong with that split: whether (b)'s corridor is selected at admission by a flag (Change set A forbids a second lifecycle parser, so reading the correction token from `## Next action` is not available), and whether (d) needs a runtime-capability check on `codex exec` before it can be sized.
