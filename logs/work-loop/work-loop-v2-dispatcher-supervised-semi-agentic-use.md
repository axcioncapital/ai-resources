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

Standard. Implementation mode. Unit 30 — require a whole-run deadline

Named reason for the loop: the approved objective spans multiple bounded implementation, proof and operating-trial units, must survive session boundaries, needs its scope held against overengineering, and requires independent Codex assessment before it counts as complete.

## Brief

The approved outcome remains one integrated candidate that passes lean Gate SA and an independent `ADOPT` review. Current position on 2026-08-19: minimum-contract item 1 is accepted at `a4b8645a3ecd1ca02c191cd1d3c55cfdaab08e4b`; Unit 29 is accepted at `f36218980fa9fc00224088594ce59e9ea0a0e913`; item 2 is not complete because Unit 29 established four independent gaps. This unit implements only the smallest ready gap: every live multi-hop run must have one finite whole-run deadline and refuse to launch when that required bound is absent or exhausted.

Plan justification and source disposition: the governing approved plan is `plans/work-loop-v2-v0.2/work-loop-v2-dispatcher-reliable-supervised-use-implementation-plan-v0.1.md`, content-bound to commit `cfd5868183f0bc0afa762e080fa6ff78979d539a`, blob `244f793cb190863b963d0026cf64e235954c248b`. Its minimum release contract item 2, Change set B and Gate SA all require a finite whole-run deadline for live multi-hop execution. Unit 29's accepted handback is verified repository reality for the current gap: the mechanism works when supplied, but deadline admission is optional. No source here changes the approved outcome, boundary or exclusions.

Dominant deliverable: make a finite whole-run deadline an admission requirement for every live multi-hop dispatcher run.
Evidence required in this hop: one targeted pre-edit failure for a live multi-hop invocation without the required deadline; the same focused case passing after the edit; retained focused evidence that an expired deadline refuses the next launch and that teardown overrun is reported truthfully; exact command counts.
Evidence explicitly deferred: automatic-replay prevention; normal/correction corridor separation; nested-AI prevention/reporting; runtime-preflight item 3; concise status/takeover item 4; live trials; full regression; adoption; the three pre-existing harness failures; capture-volume decisions; merge, push, deployment and destructive cleanup.
Primary edit begins after: the existing no-deadline live multi-hop case is shown failing against the approved requirement—it currently accepts the invocation or launches where the required result is refusal before actor launch.

Required outcome:

- A live dispatcher run capable of carrying more than one hop cannot start without an explicit finite whole-run deadline.
- Missing or invalid deadline input refuses before actor launch and produces the durable result required by the already-accepted post-admission boundary; if the existing admission boundary classifies this input as pre-admission, stop and hand back the authority conflict rather than silently choosing a side.
- A supplied finite deadline remains one whole-run clock across every hop and any eligible retry; exhaustion stops before another actor launch.
- Read-only status and operator-facing text describe the requirement and remaining bound truthfully. Do not claim the old `max_hops * timeout` figure is a whole-run deadline.
- Existing single-hop attended carry behavior remains unchanged unless the approved plan's "live multi-hop" boundary demonstrably includes it; report that boundary from current executable behavior and the plan rather than broadening it by preference.

Check against repository before editing:

1. Verify Unit 29's claim in `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` that the deadline is currently optional and that every existing expiry guard stops before another launch. Treat the line numbers in Unit 29 as pointers, not authority.
2. Verify the nearest existing deadline cases in `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, including the case asserting no-deadline behavior, the expired-clock pre-launch refusal, and teardown-overrun arithmetic. Reuse or minimally adapt those cases; do not create a new test framework or broad selector.
3. Verify the parser/admission boundary already established by Change set A before deciding whether missing deadline is a pre-admission refusal or an admitted terminal result. If that boundary conflicts materially with the required outcome above, hand back the conflict without implementing.
4. Verify any directly affected invocation documentation. Edit it only if the public contract would otherwise become false.

Required fail-capable evidence:

- Quote the targeted failure before the production edit and show that it fails because a live multi-hop run without a deadline is accepted or launched.
- After the edit, show the same case refusing before actor launch with the expected exit/result classification, plus the focused existing expiry and teardown-overrun cases still passing.
- Show that a valid finite deadline still admits the run and remains shared across hops rather than resetting per hop.
- Report exact commands, pass/fail counts and changed paths. Explain any meaningful regression check that cannot be run; do not substitute a ceremonial grep.
- Confirm the approved plan is unchanged, only task-scoped source/test/directly affected documentation plus this state file are committed, and `logs/friction-log.md` remains unstaged.

Codex framing decision: item 2 is split by independent enforcement surface, starting with the deadline because Unit 29 established it as a self-contained mechanism whose enforcement already exists after admission. This ordering is not an operator requirement and does not settle the later retry, corridor or nested-AI designs.

Capability subset: baseline only — read, focused local tests, edits within `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, its focused test file, directly affected dispatcher invocation documentation, this state file, and local commits. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No full suite, live model, network, merge, push, deployment, destructive cleanup or operator-reserved capability is authorized.

Completion condition: one committed implementation handback proves that every live multi-hop run has a required finite whole-run deadline and stops before another launch when it expires, without changing single-hop behavior or reopening deferred item-2 gaps, then sets `turn: codex`.

Stop and hand back on a false premise, an admission-boundary conflict, need for a second parser or state system, scope outside the named dispatcher surface, inability to produce fail-capable focused evidence, or any operator-reserved decision.

## Latest result

Inspected (2026-08-19):

- Packaging lines: HOLD — Implementation mode carries all four lines; `Dominant deliverable:` names exactly one deliverable.
- Claim (1): HOLDS — read `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`. The deadline is optional: `DEADLINE=""` at the defaults block (line 321), validation runs only inside `if [ -n "$DEADLINE" ]` (lines 1717-1720), `DEADLINE_AT` stays empty when unset (lines 3788-3789), and startup prints `deadline=none — upper bound is max_hops * timeout` (line 3800). Every expiry guard stops before another launch and none of them fires when `DEADLINE_AT` is empty: pre-launch at line 4936, post-124 at 4968, pre-retry at 4988, retry-124 at 4999 — all `die_hop 29`, all before the corresponding `launch_actor`.
- Claim (2): HOLDS — searched `dispatch.test.sh` for `deadline`. Case 28c (line 4277) is the no-deadline case, asserting exit 0 and the `deadline=none` line. Case 28b (lines 4180-4226) is the expired-clock pre-launch refusal, `--deadline 1 --max-hops 200`, exit 29 with `deadline_remaining_seconds:0`. Case 28 (lines 4089-4117) carries the teardown-overrun arithmetic, bounding elapsed time at `deadline 3 + poll 1 + grace 5 + slack 2`. These are adaptable in place; no new framework is needed.
- Claim (3): FALSE — the required outcome's second bullet cannot be satisfied without reopening the already-accepted Change set A boundary. Read the set-A producer contract at `dispatch.sh` lines 496-506: the durable terminal result hangs off `die()`, which covers the nine post-admission nonzero families, and it explicitly "does NOT cover the families that exit by another route: usage and argument refusal and checkout/lease-infrastructure failure exit directly before a run id exists." Read the admission boundary at lines 1868-1892: a run is admitted only once task, checkout and evidence location are established, and "before that point an invalid invocation must launch no actor, take no owner or lease, mutate nothing and write no evidence." Every existing invocation-input check sits above that line and exits 10 with no durable result — including the existing `--deadline` value check at lines 1717-1720. A missing or invalid `--deadline` is therefore classified pre-admission by the boundary already in force, where a durable result is not merely absent but forbidden — and this task's own `## Objective and scope` excludes invalid-pre-admission durable results.
- Claim (4): HOLDS — read `handoff-automation-spike/README.md` (option table line 39, the `--deadline` section at lines 197-215, exit-code row 29 at line 616) and the `dispatch.sh` header block (lines 24-25, 185). All of it currently documents the deadline as optional and defaulted to none. Nothing was edited: the public contract only becomes false once the requirement lands, and the requirement did not land.

Boundary reported from executable behavior, as the required outcome's fifth bullet asks: `MODE=live` when no `--actor-cmd` is passed (line ~1785), and `--dry-run` / `--status` set their own modes. Hop capacity is `MAX_HOPS`, default 4 (line 319), pinned to 1 by `--carry-one` (after `--max-hops` validation). So "live multi-hop" in current executable terms is `MODE=live` with `MAX_HOPS` greater than 1, and the attended single-hop carry (`--carry-one`) sits outside it. The approved plan's own wording (line 310) is "Require a finite whole-run deadline for every live multi-hop run" and it states no durable-result requirement for the refusal.

Result: no production edit was made and no targeted failing case was produced. Claim (3) fails before the `Primary edit begins after:` gate can be reached, so the unit does not begin. `git diff` is empty across `dispatch.sh`, `dispatch.test.sh` and `README.md`; only this state file changed.

Evidence: the conflict is fail-capable and would have read differently — had the set-A producer comment listed usage and argument refusal among the covered families, or had any existing invocation-input check sat below the admission boundary and produced a durable result, claim (3) would have held and the edit would have proceeded. Neither is the case: `grep -n 'exit 10' dispatch.sh` places every argument refusal above `check_evidence_location`, and the producer's own boundary paragraph names that exclusion in words.

## Blocker

Authority conflict between the brief's required outcome and the accepted Change set A admission boundary — handed back rather than resolved here, exactly as the brief's second required-outcome bullet and its stop condition direct.

The brief requires that missing or invalid deadline input "refuses before actor launch and produces the durable result required by the already-accepted post-admission boundary." Those two halves are jointly unsatisfiable for an invocation-input refusal under the boundary now in force:

- Refusing before actor launch, in the place every other input check occupies, puts the refusal pre-admission — where the accepted contract forbids writing evidence, and where the durable terminal-result producer does not reach.
- Producing a durable result requires the check to sit after admission, which means an invocation-input judgment answered only after both leases are held. The boundary comment at lines 1868-1880 names that as the specific defect it was written to remove: "an authority question answered after the leases are held has already had effects taken on its behalf."

The task's `## Objective and scope` excludes invalid-pre-admission durable results, and the approved plan asks only for the requirement itself, not for a durable result on refusal. So the cheapest resolution is likely a pre-admission usage refusal at exit 10 with no durable result — but that drops the brief's second bullet, and choosing which side gives way is Codex's framing decision, not Claude's silent repair.

Nothing else blocks the unit: claims (1), (2) and (4) hold, and the mechanism, the adaptable focused cases and the documentation surface are all where the brief said they would be.

Deferral noticed and not done: the startup line `deadline=none — upper bound is max_hops * timeout` (line 3800) is the operator-facing text the required outcome's fourth bullet targets. It is left untouched because it only becomes false once the requirement exists, and editing it now would document a rule the dispatcher does not enforce.

## Next action

Codex: decide which side of the conflict gives way, then reissue the unit.

1. Confirm or reject Claude's reading that a missing `--deadline` is an invocation-input refusal, and therefore pre-admission under the accepted Change set A boundary.
2. If confirmed, choose one: (a) drop the durable-result half of required-outcome bullet 2 and require a pre-admission usage refusal at exit 10, consistent with the plan's line 310 and this task's exclusion of invalid-pre-admission durable results; or (b) keep the durable result and state the authority under which an invocation-input check moves below the admission boundary, which reopens accepted Change set A work and needs its own justification.
3. Reissue the unit with bullet 2 settled. Everything else in the brief is verified and ready — the mechanism is self-contained, Cases 28, 28b and 28c are adaptable in place, and the live-multi-hop boundary is `MODE=live` with `MAX_HOPS` above 1, leaving `--carry-one` unchanged.
