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

Standard. Implementation mode. Unit 1 — refuse unusable evidence locations before admission

Named reason for the loop: the approved objective spans multiple bounded implementation, proof and operating-trial units, must survive session boundaries, needs its scope held against overengineering, and requires independent Codex assessment before it counts as complete.

## Brief

The previous task closed after Patrik chose `SHRINK`; its accepted discovery established that malformed invocations cannot safely produce run-bound results. Patrik then approved revised plan content `849d08000292005d6a522454552f7025b89a34ba` (plan blob `c7857d5fb7956533c1047a8f449ba09f43186f9e`), with the approval recorded at `b6a20ed0`, making the admitted-run boundary authoritative. The first implementation gap is narrower than a result-system redesign: current evidence-location failure is reached only after lease acquisition, while the revised plan requires an invalid pre-admission invocation to take no owner or lease and write no evidence.

Dominant deliverable: make an unusable or untrusted evidence location refuse before run admission, without acquiring an owner or lease and without writing evidence.
Evidence required in this hop: one targeted red-then-green case that detects pre-refusal lease acquisition or evidence mutation, plus one proportionate valid-path control showing the later admitted-run path still remains reachable.
Evidence explicitly deferred: admitted-run identity initialization; durable lease-refusal results; the dead `RUN_ID` checkout discriminator; result-proof gaps for the other terminal classes; all other Change set A clauses; Change sets B–D; live trials; final regression; adoption review; the focused-case selector; merge, push, deployment and destructive cleanup.
Primary edit begins after: a focused failing invocation with valid task and checkout inputs but an unusable evidence location, where the fixture can fail specifically because the current dispatcher reaches lease acquisition or evidence mutation before refusing.

Required outcome:

- Refuse an unusable or untrusted requested/default evidence location before run admission with clear stderr and a nonzero exit.
- On that refusal, launch no actor, acquire no owner or task/checkout lease, mutate no task or repository state, and write no run evidence or terminal result.
- Establish only the evidence-location validation needed for this boundary. Do not create an argument-free evidence root, a refusal store, a second result type, a second lifecycle parser, or any durable record for a non-run.
- Preserve `--status` as strictly read-only and preserve the behavior of a valid invocation beyond this boundary.
- Keep this as one boundary correction. Do not also move admitted-run identity creation, redesign lease refusal, repair unrelated terminal-class proof, or widen into another change set.

Check against the repository:

1. Verify the revised plan remains ACTIVE and content-bound to commit `849d08000292005d6a522454552f7025b89a34ba`, blob `c7857d5fb7956533c1047a8f449ba09f43186f9e`, with approval recorded at `b6a20ed0`; verify its admission boundary explicitly requires invalid pre-admission invocations to take no owner or lease, mutate nothing and write no evidence. If that authority differs, hand back the discrepancy.
2. Verify the accepted Unit 36 evidence at `e53e6592583a6b16b83b2853e21f439d7029ef49`: in `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, task and checkout become trusted and paths are derived before `acquire_lock`, but requested/default log-directory creation and canonicalization currently occur only after `acquire_lock`. Cite the current locations rather than relying on these remembered line numbers.
3. Inspect the focused fixtures in `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` and reuse their existing mechanisms where sufficient. Do not run a broad baseline before the primary edit; the accepted discovery commits already establish the call-order defect.
4. Treat the exact implementation mechanism as Claude's technical judgment inside the approved envelope. Any new persistent architecture, evidence root or schema is outside this unit.

Required fail-capable evidence:

- Show the targeted case failing before the primary edit for the specific pre-admission side effect, then passing afterward with the expected stderr/nonzero refusal and zero actor, owner, lease, mutation and evidence effects.
- Show one focused valid-path control that would fail if the boundary change prevented a legitimate invocation from reaching the existing admitted-run path.
- Run only the focused relevant regression slice in this hop. Report exact commands, assertions and counts, and identify why each check could have failed.
- Report the production and test paths changed and the commit. Do not stage or commit unrelated pre-existing noise.

Capability subset: baseline only — read and inspect the governing plan, accepted task evidence, dispatcher, focused tests and necessary local history; edit only the dispatcher, its focused tests and this task state; run local focused tests; and make the local commit required by the Work Loop. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No network, external service, production action or operator-reserved capability is needed.

Completion condition: one committed implementation handback proves that an unusable evidence location is refused before run admission with no actor, owner/lease, repository mutation or evidence write, while a focused valid-path control still reaches the existing admitted-run path, and returns this state with `turn: codex`.

Stop and hand back if the premise is false; if a fail-capable test cannot observe the claimed pre-admission effects; if the change requires a new evidence root, result schema, lifecycle reader or operator-owned architecture decision; or if satisfying it requires combining admitted-run initialization or lease-result work into this unit. Challenge the brief rather than widening it.

## Latest result

Inspected (2026-08-18):

- Claim (1) authority: HOLDS — `plans/work-loop-v2-v0.2/work-loop-v2-dispatcher-reliable-supervised-use-implementation-plan-v0.1.md` line 4 reads `**Status:** ACTIVE, APPROVED BY PATRIK ON 2026-08-18 AGAINST IDENTIFIED REVISED CONTENT`, bound to commit `849d08000292005d6a522454552f7025b89a34ba`; `git rev-parse 849d0800:<plan path>` returns `c7857d5fb7956533c1047a8f449ba09f43186f9e`; `git log --oneline -1 b6a20ed0` is `update: dispatcher plan — record revised approval`, and `git diff 849d0800 HEAD -- <plan path>` shows that commit changing only the status line, the Gate-item-6 row and the approval paragraph.
- Claim (1) admission boundary: HOLDS — searched the plan for `admission`; line 146 states "Before that point, invalid usage or arguments must launch no actor, acquire no owner or lease, mutate nothing, write no evidence, print a clear error to stderr and exit nonzero", and lines 219 and 407 repeat it as an acceptance condition.
- Claim (2) call order: HOLDS, at current locations rather than the remembered ones — in `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` before the edit: task id trusted at 1503-1509, checkout canonicalized at 1511-1514, `DEFAULT_LOG_DIR` derived at 1530 and `STATE_FILE` at 1533; `acquire_lock` is called at 2742; the requested/default log directory is first created at 3113 (`mkdir -p "$LOG_DIR"`) and canonicalized at 3118. Creation and canonicalization are therefore 371 lines *below* lease acquisition.
- Claim (3) fixtures: HOLDS — searched `dispatch.test.sh` for existing mechanisms; `tree_manifest` (306), `lock_root_for`/`task_lock_for`/`checkout_lock_for` (207-222), `calls` (292), `expect_rc` (314), `out_has` (326) and case 12h's real-holder pattern (1287-1421) were all sufficient, so the new case introduces no new harness machinery. No broad baseline was run before the primary edit.
- Claim (4) mechanism: HOLDS as Claude's judgment inside the envelope — no new persistent architecture, evidence root, refusal store, result type or lifecycle parser was created, and no new exit code was invented (the existing `10 BAD_USAGE` is reused).

Result: an unusable or untrusted run-evidence location is now refused at admission, before any lease is asked for. `dispatch.sh` gains `check_evidence_location()` and one guarded call placed with the task and checkout trust checks (immediately after `DEFAULT_LOG_DIR`/`STATE_FILE`, ~1543), skipped only in `--status` mode exactly as `acquire_lock` is. It refuses a symlink that does not resolve to a directory, an existing non-directory, an unwritable existing directory, and a missing location whose nearest existing ancestor is not a writable directory — each with `STOP [10]` naming the requested path, and a nonzero exit. It checks only; creation and canonicalization stay at 3112-3118, because only an admitted run may write inside the checkout (case 12h). `--status` is unchanged and still read-only.

Evidence: the new focused cases 63a, 63a(2) and 63b in `dispatch.test.sh` (9863-10045), run as a slice assembled from the committed suite text (prelude lines 1-343 plus the case bodies) with `REPO_ROOT=<checkout> DISPATCH_BIN=<checkout>/plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh bash <slice>`.

- Red, against the unmodified `dispatch.sh`: `pass=18 fail=4`. The four failures are the defect itself — (a) "no lease was ever acquired — the shared lease root was never created" failed because the refusal at `mkdir` had already run `acquire_lock`, which creates `$WL_LEASE_ROOT` (`logs/scripts/work-loop-lease.sh` 518) and which release never removes (677-678), so its existence in a sandbox that never admitted a run is a one-way record; (b) with a real second dispatcher holding the lease, the invalid invocation exited **17**, not 10; (c) it filed a refusal record for that non-run — refusal count moved from 0 to 1; (d) the refusal named the parent directory, not the requested location.
- Green, against the edited `dispatch.sh`: `pass=22 fail=0`. All four flipped; nothing else moved.
- Focused regression slice — cases 12h, 12h-ok, 63a, 63a(2), 63b, taken from the committed suite text: `pass=52 fail=0`. 12h still proves the exit-17 refusal writes its durable record under the shared lease root and nothing into the checkout, and that `--status` creates no log directory and files no refusal; 12h-ok still proves an admitted run creates and uses the requested log directory.

Why each check could have failed: 63a's lease-root assertion fails whenever anything reaches `acquire_lock` before the refusal (it did, before the edit); 63a(2)'s exit-code and refusal-count assertions fail whenever the invalid invocation consults the lease at all (both did); 63b fails whenever the boundary rejects a legitimate location — a "must already exist" check would fail its first leg, and a check placed before `DEFAULT_LOG_DIR` resolution would fail its default leg. 63b passed before the edit as well, which is what makes it a control rather than a second copy of 63a.

Paths changed: `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` (production), `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` (focused tests), and this state file. `logs/friction-log.md` was already modified before this hop and was deliberately left unstaged.

Deferral noticed during the unit, recorded and not done: case 63b's default-location leg can assert only that the run wrote its own header into the default directory, not that a hop completed, because `new_sandbox` creates `plans/…/handoff-automation-spike` without committing anything under it — so `git status` reports `?? plans/`, which the default allowlist pattern `^plans/work-loop-v2-v0\.2/handoff-automation-spike/` does not match, and the pre-hop gate stops at 18 for a reason unrelated to this boundary. Fixing the fixture would touch `new_sandbox`, which every case in the suite shares, and that is outside this unit.

## Blocker

None.

## Next action

Codex: assess whether the pre-admission evidence-location refusal boundary is accepted on this evidence, and either continue with the next unit of the revised Gate SA scope or name frozen findings.
