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

The approved outcome remains one integrated candidate that passes lean Gate SA and an independent `ADOPT` review. Current position on 2026-08-19: minimum-contract item 1 is accepted at `a4b8645a3ecd1ca02c191cd1d3c55cfdaab08e4b`; Unit 29 is accepted at `f36218980fa9fc00224088594ce59e9ea0a0e913`; Unit 30's first handback at `8921bba25bb071bb9f829d9f93a6116b4a74334e` correctly stopped on a false premise before implementation; item 2 remains incomplete. This reissued unit implements only the same smallest ready gap: every live multi-hop run must have one finite whole-run deadline and refuse to launch when that required bound is absent or exhausted.

Plan justification and source disposition: the governing approved plan is `plans/work-loop-v2-v0.2/work-loop-v2-dispatcher-reliable-supervised-use-implementation-plan-v0.1.md`, content-bound to commit `cfd5868183f0bc0afa762e080fa6ff78979d539a`, blob `244f793cb190863b963d0026cf64e235954c248b`. Its minimum release contract item 2, Change set B and Gate SA all require a finite whole-run deadline for live multi-hop execution. Unit 29's accepted handback is verified repository reality for the current gap: the mechanism works when supplied, but deadline admission is optional. No source here changes the approved outcome, boundary or exclusions.

Dominant deliverable: make a finite whole-run deadline an admission requirement for every live multi-hop dispatcher run.
Evidence required in this hop: one targeted pre-edit failure for a live multi-hop invocation without the required deadline; the same focused case passing after the edit; retained focused evidence that an expired deadline refuses the next launch and that teardown overrun is reported truthfully; exact command counts.
Evidence explicitly deferred: automatic-replay prevention; normal/correction corridor separation; nested-AI prevention/reporting; runtime-preflight item 3; concise status/takeover item 4; live trials; full regression; adoption; the three pre-existing harness failures; capture-volume decisions; merge, push, deployment and destructive cleanup.
Primary edit begins after: the existing no-deadline live multi-hop case is shown failing against the approved requirement—it currently accepts the invocation or launches where the required result is refusal before actor launch.

Required outcome:

- A live dispatcher run capable of carrying more than one hop cannot start without an explicit finite whole-run deadline.
- Missing or invalid deadline input is a pre-admission usage refusal: exit 10 with clear stderr, no actor launch, no run identity, no owner or lease, no mutation and no durable evidence. This is the accepted Change set A boundary, not a new implementation choice.
- A supplied finite deadline remains one whole-run clock across every hop and any eligible retry; exhaustion stops before another actor launch.
- Read-only status and operator-facing text describe the requirement and remaining bound truthfully. Do not claim the old `max_hops * timeout` figure is a whole-run deadline.
- Existing single-hop attended carry behavior remains unchanged unless the approved plan's "live multi-hop" boundary demonstrably includes it; report that boundary from current executable behavior and the plan rather than broadening it by preference.

Check against repository before editing:

1. Verify Unit 29's claim in `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` that the deadline is currently optional and that every existing expiry guard stops before another launch. Treat the line numbers in Unit 29 as pointers, not authority.
2. Verify the nearest existing deadline cases in `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, including the case asserting no-deadline behavior, the expired-clock pre-launch refusal, and teardown-overrun arithmetic. Reuse or minimally adapt those cases; do not create a new test framework or broad selector.
3. Preserve the parser/admission boundary already established by Change set A: deadline presence and syntax are invocation-input checks before admission. Do not move them below admission or create a durable result for their refusal.
4. Verify any directly affected invocation documentation. Edit it only if the public contract would otherwise become false.

Required fail-capable evidence:

- Quote the targeted failure before the production edit and show that it fails because a live multi-hop run without a deadline is accepted or launched.
- After the edit, show the same case refusing pre-admission with exit 10, clear stderr, zero actor launches, no run identity, no owner or lease, no mutation and no evidence, plus the focused existing expiry and teardown-overrun cases still passing.
- Show that a valid finite deadline still admits the run and remains shared across hops rather than resetting per hop.
- Report exact commands, pass/fail counts and changed paths. Explain any meaningful regression check that cannot be run; do not substitute a ceremonial grep.
- Confirm the approved plan is unchanged, only task-scoped source/test/directly affected documentation plus this state file are committed, and `logs/friction-log.md` remains unstaged.

Codex framing decision: item 2 is split by independent enforcement surface, starting with the deadline because Unit 29 established it as a self-contained mechanism whose enforcement already exists after admission. This ordering is not an operator requirement and does not settle the later retry, corridor or nested-AI designs.

Capability subset: baseline only — read, focused local tests, edits within `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, its focused test file, directly affected dispatcher invocation documentation, this state file, and local commits. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No full suite, live model, network, merge, push, deployment, destructive cleanup or operator-reserved capability is authorized.

Completion condition: one committed implementation handback proves that every live multi-hop run requires a finite whole-run deadline at pre-admission and stops before another launch when it expires, without creating evidence for invalid invocation input, changing single-hop behavior or reopening deferred item-2 gaps, then sets `turn: codex`.

Stop and hand back on a false premise, any need to move deadline validation below the accepted admission boundary, need for a second parser or state system, scope outside the named dispatcher surface, inability to produce fail-capable focused evidence, or any operator-reserved decision.

## Latest result

Inspected (2026-08-19):

- Packaging lines: HOLD — all four present for Implementation mode; `Dominant deliverable:` names one deliverable.
- Claim (1): HOLDS — re-read `dispatch.sh`. The deadline was optional (`DEADLINE=""` in the defaults; validation only inside `if [ -n "$DEADLINE" ]`; `DEADLINE_AT` empty when unset; startup printed `deadline=none`). All four expiry guards stop before another launch and none fires when `DEADLINE_AT` is empty: pre-launch, post-124, pre-retry and retry-124, each a `die_hop 29` above its `launch_actor`.
- Claim (2): HOLDS — searched `dispatch.test.sh`. Case 28 carries the teardown-overrun arithmetic (`deadline 3 + poll 1 + grace 5 + slack 2`), 28b the expired-clock pre-launch refusal (`--deadline 1 --max-hops 200` → exit 29, `deadline_remaining_seconds:0`), 28c the no-deadline case, 28d the syntax cases. All were adaptable in place; no new framework and no broad selector was created.
- Claim (3): HOLDS as reissued — the parser/admission boundary is preserved. The new check is an invocation-input check above `check_evidence_location`, exits 10, and reaches no terminal-result producer.
- Claim (4): HOLDS — `README.md` and the `dispatch.sh` header (which `--help` prints) both documented the deadline as optional, so the public contract would have become false. Both were edited, minimally.

Result: a live multi-hop dispatcher run now requires a finite whole-run deadline and is refused before admission without one.

- `dispatch.sh` — one new guard: `MODE = live` and `MAX_HOPS > 1` and no `--deadline` → `STOP [10]`, naming the mode, the hop ceiling and the `max_hops * timeout` figure it replaces, and pointing at `--deadline S` or `--carry-one`. Placed **below** the task-id grammar and **above** `check_evidence_location`. Below, because case 68a requires `--task -foo` to keep answering 12: path safety is about what an invocation could reach, this check only about how long it could take. Above, because the accepted Change set A boundary requires an invalid invocation to take no lease and write no evidence — which is also why this refusal files no terminal result.
- Exempt shapes, read from the script's own two values: `--carry-one` and `--max-hops 1` (already bounded by `--timeout`), `--actor-cmd`, `--dry-run`, `--status`. Single-hop attended carry is therefore unchanged, which is bullet 5's boundary reported from executable behavior rather than broadened.
- `dispatch.test.sh` — new case 28e, plus `--deadline 300` added at the eight pre-existing live multi-hop call sites (four `run_dispatch` calls in case 22, two in case 50d, case 60h row 6, and the M4 mutant in case 50f). 300s against those cases' `--timeout 20` clamps nothing, so none of them changes what it tests.
- `README.md` — the option table, the `--deadline` section (requirement plus the four-row exemption table), the exit-10 row, and the `--unattended` synopsis.

Evidence:

- **The failing case, before the production edit.** `Case 28e` run against the unmodified `dispatch.sh`: `pass=5 fail=6`. The red is the required one — `FAIL 28e — a live run with --max-hops 2 and no --deadline is refused` (`expected exit 10, got 22`), and, decisively, `FAIL 28e — no actor was launched` with the child's own argv printed back: `-p /work-loop-v2 needs-deadline --output-format stream-json --verbose --permission-mode default --disallowedTools ...`. A run identity, an evidence directory and four artifacts were created. That is the brief's `Primary edit begins after:` condition: the invocation was accepted and launched where refusal was required.
- **The same case after the edit:** `pass=11 fail=0`. Refused at exit 10, no launch, no run identity, no evidence directory, neither lease taken, and the checkout byte-for-byte unchanged by `tree_manifest`.
- **The case cannot pass by refusing everything** — four controls, each asserting only `not 10`: the same live multi-hop run *with* `--deadline 60` clears the gate (exit 22), `--carry-one` clears it (22), an explicit `--max-hops 1` clears it (22), and `--dry-run` clears it (0). Case 28c independently holds the simulated no-deadline path at exit 0.
- **Retained focused cases, all after the edit.** Case-28 family (28, 28b, 28c, 28d, 28e): `pass=62 fail=0` — this is where the expired-clock pre-launch refusal and the teardown-overrun arithmetic are proved, and 28b's `--deadline 1 --max-hops 200` is also what shows one clock spanning hops rather than resetting per hop. Case 22: `pass=18 fail=0`. Case 50: `pass=120 fail=0`. Case 60h: `pass=40 fail=0`. Case 68a/68b: `pass=47 fail=0`. **298 assertions, 0 failures.**
- **Exact commands.** `bash -n dispatch.sh` and `bash -n dispatch.test.sh` (both clean); focused runs built by concatenating the harness's own helper prologue (lines 1–361) with one case region and its pass/fail summary, run as `DISPATCH_BIN=$PWD/dispatch.sh REPO_ROOT=<checkout> bash <runner>`. The runners live in the session scratchpad and are not committed.
- **The regression search was exhaustive, not sampled**, and it is what found the two real breaks. Every line in `dispatch.test.sh` carrying `--checkout` was extracted with continuations joined, then filtered to live multi-hop invocations without a deadline. The first pass keyed on `$DISPATCH_BIN` and **missed the M4 mutant**, which invokes a *copy* of the dispatcher — case 50 caught it as a live failure, and the rescan on `--checkout` found it by construction. Remaining hits on that list are other programs (`carry-turn.sh`, the ownership helper), the absent-dispatcher falsifiability case, and case 68a, which is verified green.
- **A meaningful check that was not run, and why.** The full suite was not run: the brief defers full regression, and it carries three pre-existing failures unrelated to this unit. What replaced it is the static enumeration above plus every case region that statically could be affected — which is a stronger claim about this change than a full green would have been, because it names why each site is or is not in scope rather than resting on absence of failure.
- **Repository facts.** The approved plan is unchanged (`git diff` empty against it). Committed paths are `dispatch.sh`, `dispatch.test.sh`, `README.md` and this state file. `logs/friction-log.md` is modified in the tree and was left unstaged.

Observation for Codex, not a blocker: the brief content-binds the plan to commit `cfd58681`, blob `244f793c`, but the plan's current blob at HEAD is `b6e239f8` — it moved at `a4b8645a`, the Unit 28 commit this same brief records as accepted. So the citation is one accepted commit stale. It is immaterial here: `diff` of every `deadline` line across the two blobs is empty, so the requirement this unit implemented is identical in both. Worth correcting in the next brief so the binding keeps meaning something.

Deferral noticed and not done: `run_dispatch` still supplies no default deadline, so every future live multi-hop case must add the flag itself, as the eight adapted sites now do. Making the helper supply one would be a smaller diff and is the wrong trade — it would hide the requirement from every case written afterwards, and no case could then test its absence.

## Blocker

None.

## Next action

Codex: assess Unit 30 against the reissued required outcome — the requirement binds live multi-hop only, refuses pre-admission at exit 10 with no durable result, leaves single-hop attended carry unchanged, and is proved by a targeted case that failed before the edit and by 298 focused assertions after it. Then decide which of item 2's three remaining gaps opens next: automatic-replay prevention, normal/correction corridor separation, or nested-AI prevention and reporting.
