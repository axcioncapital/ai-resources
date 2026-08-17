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

Standard. Discovery mode. Unit 9 — locate the first terminal-result consumer

Named reason for the loop: the objective spans multiple bounded implementation and proof units, must survive session boundaries, and requires independent Codex assessment before it can count as complete.

## Brief

Change set A remains active. Unit 8 is accepted at `3fb45c1e45b1f6aebe4366a14dddb1180acb37dd`: the real `CLOSED` and `BLOCKED_OPERATOR` terminal seam now writes one complete result before release, and an unprovable terminal retains both leases through the shared lease owner. The next load-bearing unknown is not how to build another validator, but which real production boundary must first consume the promised result before any Work Loop advance; locating that boundary now keeps the next implementation vertical and prevents a detached wrapper.

Dominant deliverable: one decision-ready evidence map identifying the single real production boundary where a run-bound terminal result must first be consumed before any further Work Loop advance.
Evidence required in this hop: trace the actual supervised invocation and transition path far enough to identify the first legitimate consumer, the dispatcher-owned expectations available there, who owns finite waiting, and the existing canonical route by which missing or refused evidence can block instead of advance; return one smallest justified implementation unit or a precise premise/authority conflict.
Evidence explicitly deferred: implementing the consumer or any wait; semantic tuple validation; terminal families A–C, M, and the remaining N sites; status rendering; resume; moving run identity earlier; crash-boundary recovery; hostile-input matrices beyond what is needed to identify the consumer boundary; Change sets B–D; broad regressions; live trials; adoption review; merge, push, deployment, and destructive cleanup.

Required outcome: inspect without implementation and establish where the accepted result path becomes an input to a real supervised control decision. The answer must name (1) the production caller or boundary, (2) the exact promised artifact path and independently owned expected task, checkout, run, and evidence-root values available there, (3) the finite wait owner and a bound shorter than its actor timeout, (4) the valid state transition or legal `BLOCKED_OPERATOR` route coupled to acceptance or refusal, and (5) whether the accepted path, structural, and identity validators compose there without a second parser, lifecycle reader, terminal store, or detached trust layer.

Governing authority and settled evidence:

- The content-bound-approved plan governs: Change set A required behavior items 5–7, trusted-field ownership, durable ordering, and § 8's vertical-behavior and one-production-owner rules.
- Units 5–8 are accepted. Do not redesign or re-prove the atomic producer, structural parser, expected-identity boundary, completion/takeover terminal seam, or terminal-unprovability lease pin.
- Realignment already removed a proposed detached classification-tuple validator. Semantic validation remains deferred until a real consumer proves the exact semantics it needs.

Check against the repository:

1. Verify that `validate_terminal_result_path()`, `validate_terminal_result()`, and `validate_terminal_result_identity()` still have no production caller in `handoff-automation-spike/dispatch.sh`; distinguish test-only use from production consumption.
2. Search the tracked supervised dispatcher surfaces under `plans/work-loop-v2-v0.2/handoff-automation-spike/` for any caller, wrapper, or transition that currently waits for or consumes `$LOG_DIR/$RUN_ID.result`; bound any absence claim to that surface and the result-path/validator names searched.
3. Trace the actual supported supervised launch and post-exit path named by the plan and repository documentation. Do not nominate `--status`, a test harness, raw-log reconstruction, or a new wrapper merely because it is convenient; show that the chosen boundary actually controls whether the Work Loop advances.
4. Establish which actor or process owns the consumer's timeout and how a missing, late, structurally refused, or identity-refused result reaches canonical state without inventing state prose, a second lifecycle reader, or Gate ST recovery machinery. If no current boundary can do that inside Gate SA, hand back the exact gap instead of designing around it.

Required fail-capable evidence:

- quote the production-call search that would name a caller if one existed, separating it from test-only calls;
- show the concrete invocation/return/transition path that makes the recommended boundary real, or show the bounded searched surface proving no such path currently exists;
- list the independently owned expectations available at that boundary and identify any one that is not yet available rather than sourcing it from the artifact;
- demonstrate how the proposed future focused case could read differently for a valid expected result, a missing result, and a wrong-identity result without implementing that case now; and
- report the pre-unit and handback commits and prove this state file is the only changed path.

Capability subset: baseline read/search and read-only Git history inside the approved plan, accepted task history, and tracked supervised dispatcher surfaces; edit only this task state and make the local handback commit. The baseline deny set is required in full. Nothing is selected from the pre-authorizable set, which is empty today. No operator-reserved capability is needed.

Completion condition: one local commit returns the evidence map and exactly one smallest justified next implementation unit—or a precise premise/authority conflict—without changing dispatcher, helper, test, documentation, or plan files, then hands back with `turn: codex`.

Stop and hand back without widening if the first legitimate consumer cannot be located within the tracked supervised surfaces, the needed independently owned expectations are unavailable there, or missing-result blocking would require a second state system, policy engine, general recovery layer, Gate ST machinery, or an operator-owned architecture decision. Challenge a false premise rather than inventing a consumer.

## Latest result

Inspected (2026-08-17):
- Claim (1): HOLDS — searched `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` for `validate_terminal_result`; found only the three definitions (lines 913, 964, 1118) and one comment (line 1115), no call site. `dispatch.test.sh` carries 35 references, all inside the simulated harness — test-only use, no production consumption.
- Claim (2): HOLDS — searched every tracked spike surface (`dispatch.sh`, `dispatch.test.sh`, `README.md`, `parallel-isolation-check.sh`, `parallel-landing-qc.sh`, `parallel-sampler.sh`, `ps-sampler.sh`) and the shared helpers (`logs/scripts/work-loop-state.sh`, `work-loop-owner.sh`, `work-loop-lease.sh`) for `.result`, `RUN_ID.result`, `RESULT_FILE` and the three validator names. Producer side only: `dispatch.sh` writes the artifact (lines 671–781), builds the promised path inside the uncalled validator (line 944), and prints the path (lines 1189–1190, 3517). Nothing waits for or consumes it; `--status` performs no result read.
- Claim (3): HOLDS — the supported supervised launch is the README's foreground invocation (`caffeinate -i bash dispatch.sh --checkout <abs> --task <id>`; README "Running the dispatcher" and the supervised recipe near lines 456–539). In-run advance re-reads the canonical state file after every actor exit. Every terminal funnels to exactly two release seams, both ordered finalize → `release_lock` → exit: `die()` (dispatch.sh 1173–1194) and the operator terminal (3480–3519). Cross-run advance is the next dispatcher invocation, gated by `acquire_lock` (exit 17 on held or pinned leases, 1634–1672), the owner declaration (exits 33–35), and `validate_state`. Lease release is therefore the control point that decides whether the Work Loop can advance; `--status` is read-only and controls nothing.
- Claim (4): HOLDS — at the pre-release seam the dispatcher process itself owns all waiting, and the wait is zero: consumption is a synchronous same-process read of an artifact it just renamed into place, bounded by the validator caps (65536 bytes, 200 lines, 512 per value), strictly inside the 900 s actor timeout. A missing or refused result reaches durable blocked state through the already-canonical route: `pin_lock_terminal` → exit 38 retains both leases with the truthful cause (1738–1768), and the next dispatcher is refused `pinned` at `acquire_lock` (1647, 1658). No state prose, no second lifecycle reader, no Gate ST machinery.

Packaging lines: present and valid for Discovery mode — one dominant deliverable, no `Primary edit begins after:`.

Result: the evidence map is decision-ready. The first legitimate terminal-result consumer is inside the dispatcher itself, at the terminal release seam, where `release_lock` today fires on nothing more than the producer's own return code.

(1) Boundary: the operator-terminal release seam (dispatch.sh 3516–3518, the exit-0 completion/takeover path; same seam family as `die()` 1187–1192). Releasing the leases is what permits the next dispatcher run, so consuming the promised artifact there — after `finalize_terminal_result` reports success and before `release_lock` — is the first point where the accepted result path is an input to a real advance decision. The alternative boundary, next-run admission consuming the previous run's result, fails the independent-expectations requirement: no dispatcher-owned durable record carries the previous run's identity (lease holder metadata records pid/task/checkout/program, not run), so the expected run value would have to come from the artifact or from directory listing — the trust inversion the ownership contract forbids — or a new durable last-run pointer would have to be invented, which is new state machinery outside this change set.
(2) Promised path and expectations: `$LOG_DIR/$RUN_ID.result` (written at line 671). At the seam, `$TASK`, `$CHECKOUT`, `$RUN_ID`, and the evidence root `$LOG_DIR` are live variables of the same process that made the promise — all four expected values independently owned and available; none missing, none sourced from the artifact.
(3) Finite wait owner: the dispatcher; the bound is zero — synchronous, size-capped read, shorter than any actor timeout.
(4) Transition: acceptance → `release_lock` → exit with the terminal code, next dispatcher may acquire. Refusal — missing, structurally refused, or identity-refused — → the existing exit-38 retention route with the refusal token in the recorded cause; both leases pinned, next dispatcher refused 17. Canonical task state untouched in both branches; no invented prose.
(5) Composition: the three validators compose at that seam with one parse and no second parser — path gate (913) before any byte is read, structural reader (964) captures TR_TASK/TR_CHECKOUT/TR_RUN plus TR_SHA/TR_FID from the accepted bytes, identity boundary (1118) compares those captures against the owned expectations. One production owner, no second lifecycle reader, no detached trust layer; the producer's own comment (lines 803–804) reserves exactly this consumer as its own unit.

Known residual named, not designed around: `die()` at 1187 ignores `finalize_terminal_result`'s return code — only the operator terminal is fail-closed today. That is the deferred terminal-families work this brief already lists; the proposed unit below does not depend on it.

Proposed Unit 10, smallest justified implementation unit: at the operator-terminal release seam, consume the promised artifact before release — run path → structural → identity validation against the four owned expectations after successful finalization; on any refusal take the exit-38 retention route with the refusal token in the recorded cause; only on acceptance, `release_lock`. The future focused case reads differently per outcome without being implemented now: a valid expected record → exit 0, leases released, next acquire succeeds; a missing record (removed between finalize and release) → exit 38, leases pinned, next dispatcher exit 17; a wrong-identity record (structurally valid bytes carrying another run's identity swapped at the path) → exit 38 with the identity mismatch token recorded. The branches differ in exit code, refusal token, and lease state, so each assertion can fail independently; mutation control: delete the consumption gate and the wrong-identity case exits 0 again.

Evidence: pre-unit commit `3fb45c1e45b1f6aebe4366a14dddb1180acb37dd`; the handback commit is the single commit on top of it touching only this state file. `git status` before the handback commit showed exactly two modified paths: this state file (the uncommitted Unit 9 brief plus this record) and `logs/friction-log.md`, which carries only pre-existing hook-generated write-activity lines and is left uncommitted. No dispatcher, helper, test, documentation, or plan file changed — before this unit the searches above named no production consumer; had one existed, Claim (1) or (2) would have returned a caller line instead.

## Blocker

None.

## Next action

Codex: assess the Unit 9 evidence map — the first consumer boundary at the operator-terminal release seam, the four independently owned expectations available there, the zero-wait ownership answer, the exit-38 refusal route, and the single-parse validator composition — and decide whether proposed Unit 10 (consume the promised artifact at that seam before `release_lock`) becomes the next implementation brief, or reframe.
