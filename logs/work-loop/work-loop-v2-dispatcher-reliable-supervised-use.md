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

Standard. Discovery mode. Unit 33 — measure terminal-unprovable retry re-entry

Named reason for the loop: the objective spans multiple bounded implementation and proof units, must survive session boundaries, and requires independent Codex assessment before it can count as complete.

## Brief

Unit 32 is accepted at `db3b5059d7450c48de7a55eaa1eb07b57808c8b0`: the shared run-bound nonzero funnel now consumes its finalized artifact before advertisement and release, derives expectations from its own code plus the sole outcome mapping, and uses a proven one-shot bound so consumer refusal cannot recurse. Clean 22/18 endings, two semantic mismatches, M39, and the five-consumer composition assertion are coherent and fail-capable. One affected interaction remains reasoned but unmeasured: a terminal-specific finalization attempt fails, `die_terminal_unprovable()` re-enters `die 38`, and that retry succeeds before the new funnel consumer runs.

Current position: the approved plan is content-bound at `e9a6fd8bc51992a1ce8f6e09dcf95b273dd07240` (plan blob `43c44e01703c8622482d93d80407ddc1c83e038a`) against baseline `2451e3df5b8616e035a39a679799738a975b642e`; Change set A remains in progress after 32 accepted units. Plan § 5 requires every terminal class to produce exactly one valid result and release only after trusted evidence, so this newly affected retry-success path must be measured before the result boundary can be treated as settled. Unit 32's extra case-57 run is accepted as surplus directly relevant evidence, not as permission to widen later briefs; the focused-selector improvement remains deferred outside Gate SA.

Dominant deliverable: establish from a controlled execution whether the first-finalization-fails, retry-finalization-succeeds path terminates safely through exactly one shared-funnel consumption.
Evidence required in this hop: one controlled clean retry-success execution and one controlled altered-result execution that proves the new consumer is actually reached on that retry.
Evidence explicitly deferred: any production or permanent test change; a complete Change set A gap audit; the focused-case selector; remaining Change set A; Change sets B–D; live trials; final regression; adoption review; merge, push, deployment and destructive cleanup.

Named unknown and required evidence:

- Using the committed `dispatch.sh` as the source, construct only a temporary, fail-closed fixture outside the repository that forces an existing terminal-specific finalizer to fail exactly once and allows the `die 38` retry to succeed. Prefer the existing operator terminal unless repository evidence shows another accepted terminal isolates the path more truthfully. The fixture must match its injection point exactly once, differ, parse, record the number of finalizer and funnel-consumer invocations, and leave tracked repository files untouched.
- In the clean run, prove the first finalization failed and the second succeeded; the dispatcher exits 38; exactly one complete run-bound result exists with `outcome=TERMINAL_UNPROVABLE` and `code=38`; the funnel consumer runs exactly once and accepts; the result is advertised once; no consumer-refusal wording or mismatch token appears; both leases remain retained under the finalization-failure cause; and the next dispatcher is refused with 17.
- In a paired temporary variant, alter only the retry-created result after successful finalization and before funnel consumption. Prove the funnel consumer is reached and refuses the altered artifact exactly once with the matching bounded semantic token, does not advertise it, retains both leases, and still terminates at 38 rather than recurring.
- Separate repository facts from the conclusion: quote the controlled counters and observable terminal/result/lease facts, then return exactly one disposition — `SAFE AS IMPLEMENTED`, `DEFECT REPRODUCED`, or `UNESTABLISHED` — with the smallest justified next move. Do not treat reasoning, the existing persistent-failure case 57, or absence of a hang as proof of the retry-success path.
- Inspect but do not edit the production one-shot flag, funnel call, `die_terminal_unprovable()` re-entry, finalizer early return and existing persistent-failure controls. If the temporary forcing mechanism cannot distinguish first failure from retry success, return `UNESTABLISHED` rather than widening.

Capability subset: baseline only — inspect the accepted plan and committed funnel/finalization seams; create and run bounded temporary fixtures outside the repository; update and commit only this task state with the evidence. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No external service, production edit or operator-reserved capability is needed.

Completion condition: the controlled clean and altered executions establish one of the three named dispositions for the retry-success re-entry, all counters and terminal/result/lease observations are quoted, no tracked file except this state changes, and the state returns with `turn: codex` for reframing.

Stop and hand back if the path cannot be forced without changing production or permanent tests, if the fixture cannot prove which finalization attempt succeeded, if consumption cannot be observed independently of finalization, or if the evidence points outside the approved Gate SA boundary. Challenge a false premise rather than implementing from a Discovery unit.

## Latest result

Unit 33 is a Discovery unit; nothing was implemented and no production or permanent test file changed. The probe is temporary, lives outside the repository, and reports `tracked files touched by the probe: 0`.

Inspected (2026-08-18):

- The retry-success path exists as the brief describes. `dispatch.sh:4119` is `finalize_terminal_result 0 || die_terminal_unprovable # operator terminal finalization`; `die_terminal_unprovable()` pins and calls `die 38`; `finalize_terminal_result` returns early only when `RESULT_FINALIZED -eq 1`, which a *failed* first attempt does not set — so the second attempt is a genuine retry, not a no-op.
- The operator terminal isolates the path most truthfully and was used. It is the seam whose finalization failure is already an accepted case (57/55e), and it reaches the funnel with no actor, no signal and no carry to confound the counters.
- Forcing mechanism, fail-closed: four selectors were required to match exactly once in the committed `dispatch.sh` and did (`finalize-guard=1 consume-def=1 operator-finalization=1 funnel-transfer=1`), and both fixtures had to differ from the dispatcher, parse, and differ from each other — all confirmed before either run. The fixture makes `finalize_terminal_result` fail on its **first genuine attempt only** (the counter sits after the `RESULT_FINALIZED` early return, so no-op re-entries are not counted) and clears `RESULT_FILE` exactly as the production failure paths do; a second injection records every `consume_terminal_result` invocation with the expected pair it was handed. That second trace is what separates "the consumer ran" from "finalization happened" — the distinction the whole unit turns on, and one no exit code could establish.

Result: **`SAFE AS IMPLEMENTED`.**

Evidence — two controlled executions, counters and observables quoted rather than summarised.

Clean run (first finalization forced to fail, retry allowed to succeed):

```
exit=38
finalize_attempt=1 code=0
finalize_attempt=2 code=38
consume label=[the shared nonzero terminal for code 38] expected=TERMINAL_UNPROVABLE/38
finalize attempts=2  consume invocations=1
results on disk=1  partials=0
record: outcome=TERMINAL_UNPROVABLE code=38 last-line=result_complete=yes
advertised terminal-result lines=1
STOP[38] lines=1  unprovable-sentence=1  untrusted-sentence=0
leases: task=retained checkout=retained
pin cause: terminal result unprovable: the run could not finalize its terminal result under <log dir>
next dispatcher exit=17
```

Every clause the brief required of the clean run holds: the first finalization failed and the second succeeded (two attempts, at code 0 then code 38); exit 38; exactly one complete run-bound result with `outcome=TERMINAL_UNPROVABLE` and `code=38` and the completeness sentinel; the funnel consumer ran exactly once and accepted; the result was advertised once; no consumer-refusal wording and no mismatch token; both leases retained under the finalization-failure cause; next dispatcher 17.

Altered run (identical, plus the retry-created record altered after finalization and before funnel consumption):

```
exit=38
finalize_attempt=1 code=0
finalize_attempt=2 code=38
consume label=[the shared nonzero terminal for code 38] expected=TERMINAL_UNPROVABLE/38
finalize attempts=2  consume invocations=1
results on disk=1  partials=0
record: outcome=COMPLETED code=38
advertised terminal-result lines=0
STOP[38] lines=2  unprovable-sentence=1  untrusted-sentence=1
leases: task=retained checkout=retained
pin cause: terminal result unprovable: the promised terminal result under <log dir> was refused before release: outcome-mismatch
next dispatcher exit=17
```

This is the half that proves the consumer is genuinely reached on the retry rather than merely present: the same expected pair arrives, the altered artifact is refused exactly once (`untrusted-sentence=1`) with the matching bounded `outcome-mismatch` token, it is not advertised (`advertised terminal-result lines=0`), both leases stay retained, and the run terminates at 38 rather than recurring — `consume invocations=1` and `finalize attempts=2` are unchanged from the clean run, so the refusal's own `die 38` re-entry neither re-consumed nor re-finalized. The two `STOP [38]` lines are the two distinct refusals, one nested in the other, not one refusal repeated.

The evidence could have read differently: `consume invocations=0` would have meant the consumer is never reached on this path, and any count above 1 — or a third finalize attempt — would have been the recursion Unit 32's one-shot flag exists to prevent.

One secondary observation, newly reachable because of Unit 32 and **not implemented here**: on the altered run the lease pin records only the *later* cause. `pin_lock_terminal` is called twice — once by `die_terminal_unprovable`, then again by `die_terminal_untrusted` (`dispatch.sh:2038`) — and the second overwrites the first, so the surviving pin says the artifact was refused before release and drops the fact that finalization had already failed. It matters because the pin is what an operator reads when they later find a stuck lease, and its recovery action then points at repairing an interfering artifact when the true root cause was a failed write. `die_funnel_unprovable` guards exactly this case (`dispatch.sh:2077`, `if [ "${WL_LEASE_PINNED:-0}" -eq 0 ]`, preserving the earlier cause deliberately); `die_terminal_untrusted` has no such guard. Before Unit 32 this double-pin sequence was not reachable, because nothing consumed inside the funnel. Both sentences still reach the operator on stderr and in the run log, so nothing is lost from this run's output — only from the lease record that outlives it. This is reported for Codex to size, not acted on.

## Blocker

None.

## Next action

Codex: assess Unit 33 and reframe. The named unknown is settled — the first-failure/retry-success re-entry terminates safely through exactly one shared-funnel consumption, proven by counters in both a clean and an altered controlled execution. Decide whether the newly reachable pin-cause overwrite above earns its own unit or is accepted as a written limitation, and dispose of the still-open deferral on the harness's missing focused-case selector.
