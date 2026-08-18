---
task: work-loop-v2-dispatcher-supervised-semi-agentic-use
status: active
turn: codex
---

## Objective and scope

Implement the approved revised plan at `plans/work-loop-v2-v0.2/work-loop-v2-dispatcher-reliable-supervised-use-implementation-plan-v0.1.md` through its complete revised Gate SA acceptance contract and independent adoption review, so the dispatcher may truthfully carry the label **Ready for supervised semi-agentic use — durable terminal results are guaranteed after run admission.**

Scope: the existing Work Loop v2 supervised dispatcher, its accepted helpers and runtime surfaces, focused proof, the required live trials, and the synchronous regression gate named by the plan. Excluded throughout: durable results for invalid pre-admission invocations; the unqualified **Reliable supervised semi-autonomous dispatcher** label; Gate ST; Gate U; unattended or walk-away release claims; a dispatcher rewrite or language migration; merge, push, deployment, destructive cleanup; and every other exclusion in plan §§ 4 and 7.

Task exit condition: one integrated candidate has passed the revised Gate SA and the independent review has returned `ADOPT`, or Patrik has explicitly chosen `SHRINK` or `STOP`.

## Lane and unit

Standard. Implementation mode. Unit 2 — give admitted lease refusal one terminal result

Named reason for the loop: the approved objective spans multiple bounded implementation, proof and operating-trial units, must survive session boundaries, needs its scope held against overengineering, and requires independent Codex assessment before it counts as complete.

## Brief

Unit 1 is accepted at `48d0459dfed6e5db8d20084cd55dbafe6ebb136d`: unusable evidence locations now refuse before admission, with red `18/4`, green `22/0`, and a focused valid-path regression slice at `52/0`. The revised admission boundary is therefore established for this input class. The next plan-ordered gap is an invocation whose task, checkout and evidence location are already trusted but whose lease is refused: it is an admitted run, so the approved plan requires exactly one run-bound terminal result rather than the dispatcher's older standalone refusal artifact.

Dominant deliverable: make an admitted task- or checkout-lease refusal finalize exactly one valid run-bound terminal result through the accepted terminal-result contract.
Evidence required in this hop: one targeted red-then-green real-holder case proving the admitted refusal changes from the standalone refusal path to one schema-valid terminal result, plus one proportionate no-contention control showing an admitted run still proceeds beyond lease acquisition.
Evidence explicitly deferred: terminal-result proof for missing runtime/authentication and the other enumerated classes; the dead `RUN_ID` checkout discriminator unless live implementation evidence makes it load-bearing for this seam; the Unit 1 `new_sandbox` default-location fixture limitation; all other Change set A clauses; Change sets B–D; live trials; final regression; adoption review; the focused-case selector; merge, push, deployment and destructive cleanup.
Primary edit begins after: a focused valid, admitted invocation contending with a real task or checkout lease, demonstrating that the current route writes the standalone `.refusal` artifact and does not finalize the versioned run-bound terminal result required by the revised plan.

Required outcome:

- Once task, checkout and evidence location are trusted, establish one dispatcher-owned run identity and its external evidence location before asking for a task or checkout lease.
- If either lease is refused, launch no actor or model request and finalize exactly one structurally and semantically valid terminal result through the existing single producer/finalizer contract.
- Record truthful pre-launch facts, including the refusal outcome and code, task, checkout, run identity, evidence paths, state and HEAD facts available at the boundary, actor/model-start status, owner/lease condition, and the exact next action required.
- Do not also write the older standalone `.refusal` record for this admitted terminal. One admitted ending gets one terminal-result authority, not two competing durable records.
- Keep invalid pre-admission invocations evidence-free, preserve `--status` as strictly read-only, and preserve the valid no-contention path beyond lease acquisition.
- Do not repair unrelated terminal classes, introduce a second schema or producer, or widen into a general run-initialization rewrite.

Check against the repository:

1. Verify the governing plan remains the approved revised content bound to commit `849d08000292005d6a522454552f7025b89a34ba`, blob `c7857d5fb7956533c1047a8f449ba09f43186f9e`, and that Change set A requires run identity/evidence before mutating action plus exactly one result for admitted lease refusal. Hand back any authority discrepancy.
2. Verify Unit 1 commit `48d0459d…` establishes evidence-location trust before lease acquisition and does not itself move run identity or alter lease refusal. Cite the current production locations rather than remembered line numbers.
3. Verify the accepted Unit 35/36 evidence against the current dispatcher: lease refusal still routes through `acquire_lock`/the exit-17 refusal path before `RUN_ID`, and the durable artifact it writes is not the versioned terminal-result schema. Bound this check to `dispatch.sh`, `dispatch.test.sh`, and the accepted commits `f8efcd70…` and `e53e6592…`.
4. Inspect the existing terminal-result producer, consumer, outcome mapping and focused lease fixtures before choosing the implementation. Reuse them where sufficient; do not create a parallel finalizer, parser, schema or refusal store.
5. Treat placement, call ordering and reuse of existing functions as Claude's technical judgment inside the approved envelope. If the current producer cannot truthfully represent a pre-lease terminal without a material schema or architecture change, hand back the precise false premise rather than widening.

Required fail-capable evidence:

- Show the targeted real-holder case failing before the primary edit because it produces the standalone refusal record and no valid run-bound terminal result, then passing after the edit with exactly one valid result carrying the lease-refusal meaning and pre-launch facts.
- Include controls that would fail on zero results, duplicate results, malformed or identity-unbound results, actor/model launch, or survival of the competing standalone refusal artifact.
- Show one focused no-contention control that would fail if an admitted invocation could no longer proceed beyond lease acquisition.
- Run only the focused relevant regression slice in this hop. Report exact commands, assertions and counts, why each could fail, changed paths, and the commit. Do not stage or commit unrelated pre-existing noise.

Capability subset: baseline only — read and inspect the governing plan, accepted task evidence, dispatcher, focused tests and necessary local history; edit only the dispatcher, its focused tests and this task state; run local focused tests; and make the local commit required by the Work Loop. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No network, external service, production action or operator-reserved capability is needed.

Completion condition: one committed implementation handback proves that a valid admitted invocation refused by either task or checkout lease produces exactly one valid run-bound terminal result and no competing standalone refusal artifact, launches no actor/model, preserves pre-admission and read-only-status boundaries, keeps a valid no-contention path reachable, and returns this state with `turn: codex`.

Stop and hand back if a load-bearing premise is false; if fail-capable proof cannot distinguish the standalone refusal from the terminal-result contract; if the existing schema cannot represent this boundary truthfully without a material plan or architecture change; or if satisfying it requires combining unrelated terminal classes or a dispatcher rewrite. Challenge the brief rather than widening it.

## Latest result

Inspected (2026-08-18):

- Claim (1) authority: HOLDS — the plan's status line still reads `ACTIVE, APPROVED BY PATRIK ON 2026-08-18`, bound to commit `849d08000292005d6a522454552f7025b89a34ba`, and `git rev-parse 849d0800:<plan path>` returns `c7857d5fb7956533c1047a8f449ba09f43186f9e`.
- Claim (1) Change set A content: HOLDS — searched the plan for `admission`/`terminal`; line 146 states the admission boundary, line 148 requires "After admission, create one run identity and initialize its external evidence location before any model request or mutating action", and the enumerated list at 150-160 names `lease refusal` as a class owing exactly one atomically finalized terminal result. Line 174 keeps `--status` strictly read-only.
- Claim (2) Unit 1 scope: HOLDS — `git show --stat 48d0459d` lists exactly `dispatch.sh`, `dispatch.test.sh` and this state file. In the current dispatcher, `check_evidence_location()` is defined at 1568 and called at 1605, above the lease; Unit 1 moved no run identity and altered no lease refusal.
- Claim (3) call order before this unit: HOLDS at current locations — `acquire_lock` was *called* at 2807, `RUN_ID` assigned at 3214 and `LOG_DIR` created at 3189, so every exit-17 refusal happened before a run identity existed. Its durable artifact was the standalone `.refusal` file written by `open_refusal_record`/`refuse_17` (then at 1867-1929) under `$WL_LEASE_ROOT/refusals`, whose format is a bespoke `terminal-record …` line — not the versioned `terminal_result_version=1` / `schema=work-loop-v2-dispatcher-terminal-result` record `finalize_terminal_result` writes.
- Claim (4) reuse: HOLDS, and no parallel machinery was needed — `result_outcome` already maps `17 → LOCK_HELD` (line 596) and `result_next_action` already maps `17 → wait-for-lease-holder` (line 647); `die()` already finalizes, transfers to the unprovability exit on failure, runs the consumer gate, prints the result path and releases (1365-1426); `result_lease_status` already reports `held-by-other`. The focused fixtures reused are case 12h's real-holder pattern and the harness's `res_field`/`run_id_of`/`res_count`/`part_count`.
- Claim (5) mechanism: HOLDS as Claude's judgment inside the envelope. No new producer, parser, schema, exit code or store was created; one was removed.

Result: an admitted run refused at either lease now finalizes exactly one run-bound terminal result through the existing single producer/consumer contract, and files no second durable record.

The seam is one ordering change plus one routing change. `[ "$STATUS_MODE" -eq 1 ] || acquire_lock` moved from above the `--status` branch to below the run-evidence block, so run identity and the evidence location exist before either lease is asked for while every mutating action — the unattended profile, the actor fork, the state read and write — stays below it, and `--status` still exits 0 above both and takes no lease. `acquire_lock`'s four refusals now leave through `die 17` instead of the bespoke `refuse_17`, so they reach the ordinary funnel; the operator wording is unchanged apart from `die()` supplying the `STOP [17] ` prefix. The exit-11 lease-infrastructure failure deliberately still exits directly: it is not one of Change set A's enumerated classes. The standalone refusal apparatus (`REFUSAL_DIR`, `open_refusal_record`, `r17`, `refuse_17`) is deleted, because two durable records for one ending can disagree and nothing here may choose between them.

Evidence: new focused cases 64a and 64b in `dispatch.test.sh`, run as a slice assembled from the committed suite text with `REPO_ROOT=<checkout> DISPATCH_BIN=<dispatcher> bash <slice>`.

- Red, against the pre-edit dispatcher extracted with `git show 48d0459d:…/dispatch.sh`: `pass=11 fail=15`. The refused run announced no run identity, finalized zero terminal results (`res_count=0`, the log directory did not exist), printed no `terminal result:` line, carried none of the eight meaning fields, was identity-bound to nothing, and filed a standalone refusal record — count moved 0 → 1.
- Green, against the edited dispatcher: `pass=26 fail=0`. All fifteen flipped: exactly one `.result` and zero `.result.partial`, at the run-bound path read from the run's own `run=` header and printed back by the refusal; `outcome=LOCK_HELD`, `code=17`, `result_complete=yes`, `actor_launched=no`, `model_request_started=no`, `stage=pre-hop`, `next_action=wait-for-lease-holder`, `lease_task_at_finalization=held-by-other`; `task`, `checkout` and `run` all naming this run; no refusal record; no actor; state file byte-identical; HEAD unmoved.
- Focused regression slice — cases 12, 12g, 12h, 12h-ok, 50a-50h, 63a, 63a(2), 63b, 64a, 64b, taken from the committed suite text: `pass=208 fail=0`.

Why each check could have failed: `res_count` fails on zero results (the pre-unit behaviour) and on duplicates (a second producer); `part_count` fails on an unfinalized temporary; the run id is *read* from the run's own header rather than composed here, so a result written under an invented id fails the path and `run=` assertions; the eight field assertions fail on a record that exists but describes the wrong ending; the refusal-count assertion fails if the deleted store came back; 64b fails if the moved lease call left an uncontended run unable to get past acquisition or leaked a lease. 64b passed before the edit too, which is what makes it a control.

Disclosed change to accepted evidence — not a silent one. Case 12h asserted the two things the operator's `SHRINK` decision reversed: that a refused run creates no evidence directory inside the checkout, and that the checkout is byte-identical afterwards. Both rested on "winning the lease is what admits a run", which the approved revised plan replaced. 12h is rewritten, not deleted: it now asserts that the refused run writes its own evidence location and *nothing else* in the working tree — the manifest and `git status` comparisons still run, with only that directory excluded — that the standalone refusal store is absent, that the refusal names its record, that the human refusal still reaches the run log, that no actor ran and nothing was committed. Its `--status` half is re-pointed at surfaces that now exist and is otherwise intact. If Codex reads this boundary move as outside the unit rather than entailed by it, that is the finding to freeze.

Deferrals noticed during this unit, recorded and not implemented:

1. A refused run's evidence directory now sits inside the checkout, and a dispatcher allowlists only the log directory *it* was pointed at — so a following run aimed at a **different** `--log-dir` reads the first one's evidence as out-of-allowlist and stops at 18 before launching. This is the second hazard the old case-12h comment predicted, and it is live again under the approved boundary. It is not the dominant deliverable and fixing it would widen into allowlist policy; case 12h-ok now points both runs at one evidence location, which is what an operator does, and carries a comment naming the consequence.
2. `LOCK_KEY` is assigned nowhere in `dispatch.sh`, so `RUN_ID`'s checkout discriminator expands to empty and run ids render with a doubled dash (`…T125603--42960-task`). Confirmed dead, as the brief's deferral list anticipated; it did not become load-bearing for this seam, because moving run identity earlier does not change a discriminator that was already empty.
3. Unit 1's `new_sandbox` default-location fixture limitation is carried forward unchanged.

Paths changed: `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, and this state file. `logs/friction-log.md` was already modified before this hop and was deliberately left unstaged.

## Blocker

None.

## Next action

Codex: assess whether the admitted lease-refusal terminal-result seam is accepted on this evidence — including whether the disclosed rewrite of case 12h's boundary assertions is entailed by the approved `SHRINK` or is a finding to freeze — and either continue with the next unit of the revised Gate SA scope or name frozen findings.
