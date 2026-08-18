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

Standard. Discovery mode. Unit 4 — adjudicate missing-runtime and authentication terminal results

Named reason for the loop: the approved objective spans multiple bounded implementation, proof and operating-trial units, must survive session boundaries, needs its scope held against overengineering, and requires independent Codex assessment before it counts as complete.

## Brief

Unit 3 is accepted at `b59d316685dbcf1ee618f095d23fc9c695e30a2f`: the content-based prior-evidence exception and all of its state, freeze and fingerprint machinery were removed; the current run's stable evidence location remains narrowly allowlisted; same-location sequential use passed; different or forged pre-existing directories fail closed before actor launch; and the focused regression passed `233/0`. The next plan-ordered gap is Change set A's first still-unsettled admitted terminal class, missing runtime or authentication. Unit 35 classified it as a proof gap at the older call order, but Units 1–2 moved run/evidence initialization and changed that evidence boundary, so building from the old classification would risk fixing behavior that may already be correct.

Dominant deliverable: determine whether every currently reachable admitted missing-runtime or authentication terminal route already produces exactly one valid run-bound terminal result, and identify the first concrete remaining gap.
Evidence required in this hop: a bounded current-route adjudication plus the smallest local focused probe capable of distinguishing a valid single result from no, duplicate, malformed or unbound evidence.
Evidence explicitly deferred: implementation or permanent regression tests for any discovered gap; invalid-state/ownership and later terminal classes; complete runtime preflight from Change set B; the dead `RUN_ID` checkout discriminator; Unit 1's fixture limitation; the focused-case selector; all remaining Change set A clauses; Change sets B–D; live trials; final regression; adoption review; merge, push, deployment and destructive cleanup.

Required outcome:

- Inspect only the current missing-runtime/authentication routes in `dispatch.sh`: every relevant `die 31`, the actor-binary `die 20` routes, and any actual authentication-readiness check or authentication-specific route that exists. Do not rebuild Unit 35's full terminal-class matrix.
- For each reachable route, establish whether it is before or after run admission, whether an actor/model request can have started, how it reaches terminal finalization and consumption, and whether the lease is released or pinned only after a valid result.
- Distinguish Change set A's terminal-result obligation from Change set B's future complete-runtime-preflight obligation. Absence of a complete preflight is not itself this unit's defect; a reachable admitted stop that lacks one truthful result is.
- Run only the smallest local sandbox probe needed to test one representative admitted missing-runtime route. It must launch no real Claude or Codex actor, require no real authentication or network, and leave production and test files unchanged.
- End with one of two findings: `BEHAVIOR GAP`, naming the earliest exact route that lacks the result contract; or `PROOF GAP ONLY`, naming which reachable behavior works but lacks durable regression proof. If authentication readiness has no current route, state that bounded absence separately and assign it to the plan clause that owns it rather than pretending it was exercised.
- Do not design or implement the repair in this unit.

Check against the repository:

1. Verify accepted Unit 35 commit `f8efcd70…` classified missing runtime/authentication as `GAP (proof)` because `die 31` / `die 20` had no committed result assertion at the then-current order, and verify Units 1–2 changed admission and run/evidence initialization afterward. If either premise differs, hand back.
2. Verify the current dispatcher comment that the shared `die()` funnel covers post-admission missing runtime/authentication against actual call order; do not accept the comment as proof.
3. Search the complete current dispatcher and focused test file, bounded to missing actor binaries, unattended/runtime gates, authentication readiness, codes 31 and 20, and result assertions for those paths. State the exact searched patterns and surfaces for any absence.
4. Treat the approved plan as governing: Change set A requires exactly one result for admitted missing-runtime/authentication terminals; Change set B separately owns complete runtime preflight. Do not silently merge them.

Required fail-capable evidence:

- Return a compact route table with exact current symbols/locations, admission status, producer/consumer path, actor-start fact, lease disposition and existing proof or absence.
- Run one focused local fixture for a representative admitted missing-runtime stop and report the exact command and assertions: expected nonzero class, exactly one `.result`, schema/path/identity/semantic validity, truthful `actor_launched` and `model_request_started`, and no real actor invocation. Explain how the probe would fail if the result were missing, duplicated, malformed or not run-bound.
- For authentication readiness, cite either the exact current route and its evidence or a bounded absence search. Do not use a real credential failure or network call as proof.
- Confirm no dispatcher, test or documentation file changed; only this state file may be committed. Leave pre-existing `logs/friction-log.md` noise unstaged.

Capability subset: baseline only — read the approved plan, accepted Unit 35/Units 1–3 evidence, dispatcher and focused tests; create only temporary local sandbox data outside tracked paths; run one local focused probe with a fake or deliberately missing actor binary; update and commit only this task state. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No real model launch, authentication attempt, network, external service or operator-reserved capability is permitted.

Completion condition: one committed discovery handback classifies the current missing-runtime/authentication terminal-result boundary as `BEHAVIOR GAP` or `PROOF GAP ONLY`, identifies the exact next bounded target, changes no production/test/documentation file, and returns this state with `turn: codex`.

Stop and hand back if the representative route cannot be exercised without a real actor, credential or network; if the admitted boundary is ambiguous; if the probe would require source mutation; or if resolving the question requires implementing Change set B's full runtime package. Challenge the premise rather than widening the unit.

## Latest result

Inspected (2026-08-18):

- Claim (1a): HOLDS — read `git show f8efcd70:logs/work-loop/work-loop-v2-dispatcher-reliable-supervised-use.md`; its row 2 does classify "missing runtime or authentication" as **GAP (proof)** and states the reason as "no committed assertion reads a result for 31 or 20".
- Claim (1b): **FALSE** — that stated reason was already untrue at `f8efcd70` itself. Searched `git show f8efcd70:plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` for `code:31` and `code:20`; found three committed result assertions — line 5692 `"code:20"` (case 50d), lines 5961 and 6058 `"code:31"` (cases 50h, 50i). Unit 35 searched only for the form `res_field … code)" = N`, which matches 11 sites today and none of these three: 50d/50h/50i write their field assertions in the `for pair in "code:31"` loop form. The class-2 classification rests on a search-shape miss, not on the call order Units 1–2 changed.
- Claim (1c): HOLDS — Units 1–2 did change admission and run/evidence initialization afterward. `48d0459d` adds `check_evidence_location()` above the leases; `e54e8b22` moves `acquire_lock` below the run-evidence block and deletes the standalone refusal apparatus. Both are real; neither is what makes class 2 covered, because it was covered before them.
- Claim (2): HOLDS — the comment at `dispatch.sh:470-480` claims `die()` is the shared funnel for nine post-admission families including missing runtime/auth. Checked against actual call order rather than accepted as prose: `LOG_DIR` at `3143`, `RUN_ID` at `3172`, `acquire_lock` at `3263`, and every class-2 terminal below them — `die 31` at `3379, 3386, 3393, 3398, 3399, 3406`, `die 20` at `3870, 3881`. All are post-admission, so `finalize_terminal_result()`'s own guard at `769` (`[ -n "$RUN_ID" ] && [ -n "$LOG_DIR" ]`) is satisfied at each. The comment is accurate for this class.
- Claim (3): HOLDS — searched the whole of `dispatch.sh` for `die 31`, `die 20`, `die_hop 20`, `STOP \[31`, `STOP \[20`, `exit 31`, `exit 20`, and case-insensitively for `auth|credential|login|logged.?in|api.?key|ANTHROPIC|OPENAI|session.?token|whoami|unauthorized|401` outside comments; and the whole of `dispatch.test.sh` for `expect_rc … 31|20`, `code:31`, `code:20` and `code)" = `. Results are the route table below.
- Claim (4): HOLDS — plan line 151 puts "missing runtime or authentication" under Change set A item 3 (exactly one finalized terminal result); plan line 252 puts "actor binaries and authentication readiness" under Change set B § Complete runtime preflight. They are kept separate below.

Result: **NEITHER `BEHAVIOR GAP` NOR `PROOF GAP ONLY` FITS — the missing-runtime half of class 2 is already covered in behavior *and* in committed fail-capable proof, and the authentication half has no route to adjudicate.** The unit's framing rests on claim (1b), which is false, so the two offered labels do not describe what is there. Reporting one of them would be inventing a gap.

Route table — every currently reachable class-2 terminal:

| Route | Site (`dispatch.sh`) | Admission | Actor/model started | Path to finalization | Lease | Committed proof |
|---|---|---|---|---|---|---|
| `--unattended` platform gate | 3379 | after (`RUN_ID` 3172, lock 3263) | no fork; only `--version` on the named binary | `die()` 1365 → `finalize_terminal_result` 769 → four validators → advertise | released after a valid result | case 50h |
| `--unattended` version unresolvable / unreadable / under-version / unusable | 3386, 3393, 3398, 3399 | after | same | same | same | cases 50h, 50i |
| `--unattended` profile write failure | 3406 | after | same | same | same | same gate, same funnel |
| codex binary not executable | 3870 | after | `HOP_BASELINE_READY` raised, no fork | same | same | case 50d |
| claude binary not resolvable | 3881 | after | same | same | same | case 50d (claude path) |
| `die_hop 20` actor exited nonzero | 4339, 4344 | after | yes — actor really ran | same | same | plan class 6, not class 2 |

Authentication readiness — bounded absence, stated separately as the brief requires: **no authentication route exists anywhere in the dispatcher.** Searched all 4507 lines of `dispatch.sh`, outside comments, for `auth`, `credential`, `login`, `logged in`, `api key`, `ANTHROPIC`, `OPENAI`, `session token`, `whoami`, `unauthorized`, `401`. One hit only, and it is not a check: `3425`, a `say` line reporting `CLAUDE_CODE_SUBPROCESS_ENV_SCRUB=1`. Code 31 is `UNATTENDED_UNAVAILABLE` (platform, version, profile) and code 20 is `ACTOR_FAILED` (binary); neither tests a credential. Nothing was exercised for authentication and nothing is claimed. This absence belongs to **Change set B § Complete runtime preflight**, plan line 252 ("actor binaries and authentication readiness"), not to Change set A item 3 — a class with no reachable terminal cannot owe a terminal result.

Evidence: one local sandbox probe, no real actor, no credential, no network. Fake `claude` answering `--version` with `2.1.218` (below the unattended minimum) and recording any real invocation; a non-existent `codex` binary path. Command: `bash probe-u4.sh` from the session scratchpad, reading `dispatch.sh` and copying `work-loop-{owner,lease,state}.sh` into throwaway git sandboxes under `$TMPDIR`.

- **A — admitted missing-runtime (`die 31`): 20/20.** Exit 31; the argv sink is empty, so nothing was launched; exactly one `.result` and zero `.result.partial`; the artifact sits at the announced run-bound path and its own `run`, `task` and `checkout` fields match what was requested; `schema=work-loop-v2-dispatcher-terminal-result`, `terminal_result_version=1`, last line `result_complete=yes`; `outcome=UNATTENDED_UNAVAILABLE`, `code=31`, `stage=pre-hop`, `actor_launched=no`, `model_request_started=no`, `next_action=operator-restore-contained-profile-prerequisites`; both leases released; no `command not found` diagnostic. The dispatcher advertised that exact path, which means its own path, structure, identity and semantic validators all accepted the record.
- **B — admitted missing-binary (`die 20`): 10/10.** Exit 20; exactly one run-bound `.result`; `outcome=ACTOR_FAILED`, `code=20`, `stage=launch`, `actor_launched=no`, `model_request_started=no`, `result_complete=yes`; both leases released.
- **How it would fail** — three mutants, run through the same assertions, `42 passed / 15 failed` overall with every failure belonging to a mutant:
  - **C1, result path no longer run-bound** (`$LOG_DIR/$RUN_ID.result` → `$LOG_DIR/terminal.result`): 12 of A's assertions go red. The run exits 38 not 31, the announced path holds nothing, every field reads absent, the advertisement is replaced by a `STOP [38] … did not pass the consumer gate (unreadable)` refusal, and **both leases are retained, not released** — which is also what proves A's lease assertion is not vacuous.
  - **C2, finalization disabled** (`return 1` at the top of `finalize_terminal_result`): zero results exist and the run exits 38 instead of 31 — so A's "exactly one result" assertion can fail.
  - **C3, semantic forgery** (`code=` rewritten to `0` after publication, before consumption): the record no longer says `code=31`, and the production consumer catches it — exit 38 `TERMINAL_UNPROVABLE` rather than a falsely-reported 31.

Two corrections to my own probe were forced by its first runs and are disclosed rather than smoothed over: it asserted a non-existent `schema_version` field (the real fields are `schema` and `terminal_result_version`), and its lease-path helper pointed at the wrong root, so the lease assertion passed vacuously until C1 exposed it. Both were fixed before the reported run; the numbers above are from the corrected probe.

Exact next bounded target, as the brief asks: not this class. The earliest genuinely unproven class remains what Unit 35 found by the same search — its rows 3, 5 and 9 (invalid state/ownership `13/14/15/26/33/34/35`, permission denial `37`, budget exhaustion `29`). Those rows carry the same search-shape risk as row 2 and should be re-searched in both assertion forms before any repair is scoped.

No production, test or documentation file was changed: `git status --porcelain` shows only this state file and the pre-existing unstaged `logs/friction-log.md`. Only this state file is staged.

## Blocker

Claim (1b) is false, and it is the premise the unit was built on. The brief frames Unit 4 as re-adjudicating a possibly-stale Unit 35 classification — "Unit 35 classified it as a proof gap at the older call order, but Units 1–2 moved run/evidence initialization and changed that evidence boundary". The inspection shows the classification was not stale; it was wrong when written, for an unrelated reason. Cases 50d, 50h and 50i already existed at `f8efcd70` and already asserted a run-bound `code:20` / `code:31` result; Unit 35's search matched only `res_field … code)" = N` and missed the loop form those three use.

Two consequences Codex owns:

1. **This unit's two permitted findings are both unavailable.** The truthful finding is that the missing-runtime half of class 2 needs no repair and no new proof, and the authentication half has no route and belongs to Change set B. Neither is `BEHAVIOR GAP` nor `PROOF GAP ONLY`.
2. **Unit 35's terminal-class matrix is not safe to plan from as it stands.** Its rows were produced by a search that provably misses one of the two assertion forms in use. Rows 3, 5 and 9 are the remaining `GAP (proof)` claims and rest on the same method.

## Next action

Codex: decide (a) whether to accept this unit's finding that Change set A item 3 is already satisfied for the missing-runtime terminals — behavior and committed fail-capable proof both present — and that authentication readiness reassigns to Change set B § Complete runtime preflight with no Change set A debt; and (b) whether to re-verify Unit 35's remaining `GAP (proof)` rows (invalid state/ownership, permission denial, budget exhaustion) against both assertion forms before scoping any repair, since the row-2 finding was produced by the same single-form search. Do not treat this hand-back as authorization to implement anything.
