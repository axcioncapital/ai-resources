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

Standard. Implementation mode. Unit 34 — preserve the first durable terminal pin cause

Named reason for the loop: the objective spans multiple bounded implementation and proof units, must survive session boundaries, and requires independent Codex assessment before it can count as complete.

## Brief

Unit 33 is accepted at `c3abd77866473fa56958ac588d3f938188992fe9` with disposition `SAFE AS IMPLEMENTED`: controlled counters prove a terminal-specific first finalization can fail, the `die 38` retry can succeed, and the shared funnel consumes exactly once without recursion. The altered variant exposed a separate durable-evidence defect: `die_terminal_untrusted()` pins again after `die_terminal_unprovable()` already pinned, overwriting the first finalization-failure cause with the later semantic-mismatch cause. Preserve the first durable cause while still reporting the later refusal truthfully now.

Current position: the approved plan is content-bound at `e9a6fd8bc51992a1ce8f6e09dcf95b273dd07240` (plan blob `43c44e01703c8622482d93d80407ddc1c83e038a`) against baseline `2451e3df5b8616e035a39a679799738a975b642e`; Change set A remains in progress after 33 accepted units. This repair is required by plan § 5's truthful owner/lease evidence, durable ordering and deterministic recovery requirements, and by Gate SA's actionable-stop contract: the lease record outlives the run and must not replace the initiating failure with a later symptom. The existing `die_funnel_unprovable()` already preserves an earlier pin as verified repository precedent; that implementation is context, not a requirement to copy its mechanism.

Dominant deliverable: when a consumer refusal occurs after the run has already pinned its leases, preserve the first durable pin cause and make the later refusal's operator wording truthful about where its evidence was recorded.
Evidence required in this hop: one targeted red/green nested retry-success alteration plus one ordinary unpinned consumer-refusal control and one fail-closed mutation control for the preservation behavior.
Evidence explicitly deferred: any broader pin-library redesign; changes to `die_funnel_unprovable()`; a complete Change set A gap audit; the focused-case selector; remaining Change set A; Change sets B–D; live trials; final regression; adoption review; merge, push, deployment and destructive cleanup.
Primary edit begins after: promote Unit 33's altered retry-success scenario into one focused permanent assertion and quote the red — both leases remain held, but their surviving pin cause contains only the later `outcome-mismatch`, the original finalization-failure cause is gone, and the later refusal falsely says its cause was recorded on both leases.

Required outcome:

- On an ordinary consumer refusal where no earlier pin exists, preserve the accepted behavior: pin both leases with the bounded consumer-gate cause, exit 38, avoid advertising the refused artifact, and state truthfully that the cause is recorded.
- On the measured nested path where `die_terminal_unprovable()` already pinned the finalization-failure cause, the later consumer refusal must not rewrite either lease's durable cause. The original cause remains byte-for-byte present on both leases; the later mismatch remains visible in stderr and the run log; both leases remain held; and the operator wording distinguishes the preserved durable cause from the later evidence rather than claiming the latter replaced it.
- Keep the retry-success path bounded exactly as Unit 33 measured: two genuine finalization attempts, one funnel-consumer invocation, exit 38, no repeated consumption or finalization, no refused-result advertisement, and next dispatcher exit 17.
- Use the existing lease/pin ownership boundary. Do not add a second pin store, cause stack, journal, parser, result field, or per-terminal refusal owner, and do not change the first-cause precedence already used by the funnel's finalization-failure transfer.

Check against the repository before editing:

1. Verify `die_terminal_untrusted()` still calls `pin_lock_terminal` unconditionally, while `die_funnel_unprovable()` checks the existing pinned state and preserves the earlier cause. Verify the lease library writes one durable terminal cause rather than an append-only history. If any premise differs, hand back before changing behavior.
2. Verify Unit 33's temporary altered scenario can be reduced into the existing case-50 funnel region without adding a general fixture framework or changing production solely for observability. Reuse existing helpers where sufficient; keep the permanent evidence focused on the overwrite.
3. Add the nested-path assertion first and reproduce the red on the committed Unit 32 implementation. The red must fail on durable cause precedence and truthful wording, not on retry setup, exit, retention or termination.

Required fail-capable evidence:

- Quote red and green for the nested altered retry-success path. Green must show the original finalization-failure cause survives on both leases, the later bounded mismatch remains in stderr and the run log, the later message no longer claims that mismatch replaced the pin cause, both leases stay retained, no artifact is advertised, the run exits 38 once through each distinct refusal without recursion, and the next dispatcher exits 17.
- Run one existing ordinary unpinned semantic-refusal control from the focused case-50 seam and show its bounded mismatch cause is still written to both leases with the accepted cause-recorded wording. This distinguishes preservation from accidentally suppressing all consumer pins.
- Add one fail-closed mutation control that removes only the new already-pinned preservation behavior while leaving the consumer, finalizers, one-shot flag, exit and lease retention intact. It must match exactly once, differ, parse, and restore the overwrite plus false cause-recorded claim.
- Run only the directly affected case-50 region through a faithful temporary slicer outside the repository, plus `bash -n` on both shell files. Do not run case 57, another case region or the full dispatcher suite in this hop.
- Report the implementation commit and exact changed paths. Only `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, and this task state may change; `logs/friction-log.md` remains pre-existing noise and must not be staged or committed.

Capability subset: baseline only — inspect the approved plan and accepted pin/funnel seams; edit only the consumer-refusal pin preservation, its focused case-50 evidence and this state; run the named focused local checks and shell syntax validation; make the local handback commit. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No external service, production action or operator-reserved capability is needed.

Completion condition: one committed repair preserves the first durable terminal pin cause on the nested retry-success refusal while ordinary unpinned consumer refusals still record their own cause; focused red/green and the mutation control distinguish those paths, wording remains truthful, only the three permitted paths change, and the state returns with `turn: codex`.

Stop and hand back if preserving the first cause requires a new durable store, changing the lease schema/library contract, losing the later refusal from the run log, weakening ordinary consumer pinning, or changing another terminal owner. Challenge a false premise rather than widening.

## Latest result

Inspected (2026-08-18):

- Claim (1): HOLDS on all three parts. `die_terminal_untrusted()` called `pin_lock_terminal` unconditionally as its first statement. `die_funnel_unprovable()` guards its own pin with `if [ "${WL_LEASE_PINNED:-0}" -eq 0 ]` and, when already pinned, says the earlier evidence is preserved unchanged. The lease library writes one durable cause and not a history: `wl_lease__pin_owned` does `"$@" >"$wl_d/survivors"` — a truncating write, per lease — and `wl_lease_pin_terminal` sets `WL_LEASE_PINNED=1` before writing, so the flag is available to a second caller. Precedence therefore has to be decided at the call site; no schema or library change could express it.
- Claim (2): HOLDS — the scenario reduced into the existing case-50 region with one focused fixture builder and no general framework, and production was not changed for observability. The fixture forces **by code rather than by counter**: the operator terminal finalizes at code 0 and the re-entry finalizes at code 38, so failing exactly the code-0 attempt forces the first failure and lets the retry succeed with no counter state to get wrong. Unit 33's probe counters are not needed permanently — the surviving record's `code=38` is the observable that only exists if the first attempt failed and the second succeeded, and case 50m asserts it.
- Claim (3): HOLDS — the nested assertions were added first and the red reproduced on the committed Unit 32 implementation, failing on exactly the two defect halves and nothing else (below).
- Packaging lines: HOLDS — all four present for Implementation mode; `Dominant deliverable:` names one deliverable.

Result: a consumer refusal that arrives after the run has already pinned no longer rewrites the durable cause. `die_terminal_untrusted()` now applies the same first-cause precedence the funnel's failure transfer already used — pinning its own bounded consumer-gate cause when nothing is pinned, and otherwise leaving the earlier cause byte-for-byte intact — and its recovery sentence stops claiming this refusal's cause was recorded on the leases when it was not, saying instead that the earlier evidence is preserved and that this message and the run log are where this refusal is recorded. No second pin store, cause stack, journal, parser, result field or per-terminal refusal owner was added; `die_funnel_unprovable()` is untouched; `dispatch.sh` changed 26 lines, almost all of them the explanation.

Evidence: a marker-driven slice of the case-50 region was run three times against the same dispatcher.

- Baseline (pre-edit `dispatch.test.sh` from `HEAD`, unchanged dispatcher): `pass=153 fail=0`, no missing helper or unbound variable.
- Red (assertions added, production unchanged): `pass=162 fail=3`, and the failures are the defect itself, not setup. The durable half: `first cause absent`, with the surviving lease reading `terminal result unprovable: the promised terminal result under <log dir> was refused before release: outcome-mismatch` — the finalization failure that started the incident gone. The wording half: `cause-recorded claims=2 preserved-wording=0`. The third failure is M40 reporting `matched=0 ... the control cannot run`, which is the mutation control correctly refusing to run against a dispatcher that does not yet carry the behaviour. Everything else in 50m passed at red — exit 38, the retry's own code-38 record, both refusals exactly once, no advertisement, the mismatch present in the run log, next dispatcher 17 — so the red is on cause precedence and wording alone.
- Green (production changed): `pass=166 fail=0` = 153 + 13.

Green shows, on the nested path: both leases retained still carrying the **first** finalization-failure cause and not the later mismatch; the later mismatch and its `outcome-mismatch` token still present in the run log and not only on stderr; exactly one `Both run leases are retained with that cause recorded` claim in the whole run — the earlier refusal's, which is legitimate — alongside the new `remain retained under the cause recorded before this refusal` wording; the surviving record still the retry's own `code=38`; each of the two distinct refusal sentences reported exactly once, so nothing recurred; no refused-result advertisement; exit 38; next dispatcher 17.

The ordinary unpinned control is the distinguishing half, and it is asserted at both existing case-50 semantic refusals: `50k — a post-hop 22 whose record claims COMPLETED — with no earlier pin, the refusal still states that its own cause was recorded` and the same for the pre-hop 18, with their bounded `outcome-mismatch` / `code-mismatch` causes still written to both leases. Without it, "preserve the first cause" could have been implemented as "stop recording consumer causes at all", which is the opposite failure and identical from the exit code alone.

M40 is the fail-closed mutation control: it neutralises only the precedence test (`if [ "${WL_LEASE_PINNED:-0}" -eq 0 ]` becomes `if true`), requiring that selector to have matched exactly once, the pin call and the funnel's own precedence to survive, and the mutant to differ and parse. Under it the later cause overwrites the first again and the refusal claims it was recorded — `claims=2` — while the run still refuses at 38 with both leases held, so case 50m is fail-capable on both halves of the defect and on neither of the behaviours that were already correct.

`bash -n` passed on both shell files. Slicer fidelity: the baseline slice passed 153/153 with no missing helpers, and both changed hunks in `dispatch.test.sh` (`+6206,7` and `+6318,173`) fall inside the sliced case-50 region (5385-6490), so the focused run covers the whole test change. Case 57, other case regions and the full suite were not run, as the brief directed.

Changed paths: `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, and this state file. `logs/friction-log.md` was left unstaged.

## Blocker

None.

## Next action

Codex: assess Unit 34. The first durable terminal cause now survives a later consumer refusal while ordinary unpinned refusals still record their own, both halves proven red-to-green with a fail-closed control that restores each. The still-open deferral on the harness's missing focused-case selector remains for disposal.
