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

Standard. Implementation mode. Unit 12 — prove initial state-validation results

Named reason for the loop: the approved objective spans multiple bounded implementation, proof and operating-trial units, must survive session boundaries, needs its scope held against overengineering, and requires independent Codex assessment before it counts as complete.

## Brief

Unit 11 is accepted at `ceec75f76cb0507261facc85d0d49963b9c64fcb`: the ownership-stop family now has permanent exactly-one-complete-result proof for codes `33`, `34` and `35`. One shared-funnel mutation is sufficient because it falsifies the common guarantee while each real branch separately proves its truthful fields; a per-branch mutation matrix would add ceremony without testing another production seam. The absent-helper `owner_declared=none` ambiguity remains folded into the already recorded ownership display-policy deferral rather than being tracked twice.

The next smallest necessary gap is the initial state-validation boundary already exercised by cases 2 and 4. These three terminals are admitted runs — run identity, external evidence and both leases exist before `validate_state` — but the permanent cases currently prove only exit/no-launch or read-only behavior, not the durable result required by Change set A.

Dominant deliverable: add permanent exactly-one-complete-result proof to the three existing initial state-validation fixtures: missing state (`13`), identity mismatch (`14`) and malformed initial turn (`15`).
Evidence required in this hop: one focused scratch mutation red for the new state-result assertions; green assertions in existing cases 2 and 4 for unique atomic completion, truthful outcome/code and pre-hop facts, no actor/model start, the shared bounded repair action, both leases held at finalization and released afterwards; syntax and only those two focused cases.
Evidence explicitly deferred: malformed-terminal code `26`; every post-hop or actor-launch code-`15` path; additional code-`13` validator-missing/unreadable subbranches; result proof for permission code `37` and budget code `29`; the three uncovered evidence-location refusal branches; other identifier/token bounds; every other Change set A clause; the full dispatcher suite; Change sets B–D; live trials; final regression; adoption review; historical-probe cleanup; merge, push, deployment and destructive cleanup.
Primary edit begins after: in scratch, express the intended result assertions against one of the existing cases 2/4 fixtures and show they fail against one narrowly mutated dispatcher copy that preserves the state-validation exit but suppresses or corrupts its terminal result. Do not add a permanent per-code mutation matrix and do not edit production to manufacture the red.

Required outcome:

- Extend case 2's identity-mismatch branch and both case 4 branches without replacing their existing assertions. Each must prove exactly one finalized result, no unfinalized temporary, the completion sentinel, `stage=pre-hop`, `actor=none`, `actor_launched=no`, `model_request_started=no`, and `next_action=operator-repair-state-file-then-rerun`.
- Prove each fixture's own outcome/code pair: `STATE_MISSING/13`, `IDENTITY_MISMATCH/14`, and `BAD_TURN/15`. Also assert the state and ownership facts that production can truthfully know at this point; derive those values from the live producer path rather than guessing from this brief.
- Prove both task and checkout leases read as held by this run at finalization and are gone from the filesystem afterwards. Preserve case 2's byte-identical-state check and all existing no-launch checks.
- Reuse `res_field`, `res_count`, `part_count` and the established compact assertion idioms. Add no generalized exit-code matrix, second schema checker, new test framework or production helper. A small local test-only helper is permitted only if it removes real repeated assertions inside these three fixtures and does not create a new contract.
- If the assertions expose wrong production behavior, hand back the exact defect. Do not combine a dispatcher repair with this proof unit.

Check against the repository:

1. Verify Unit 11 commit `ceec75f7…` changes only this state file and the two existing ownership test cases, reports case 12d `42/0`, case 50e `19/0`, scratch mutant `2/11` versus real `13/0`, and leaves only `logs/friction-log.md` unstaged. Treat that accepted evidence as settled and do not rerun it.
2. Verify the approved revised plan's Change set A and Gate SA require every admitted invalid-state terminal to finalize exactly one durable atomic truthful result.
3. Verify run identity/evidence and both leases are established before the initial `validate_state` call, so codes `13`, `14` and the initial code `15` are admitted-run terminals. If any fixture is actually pre-admission, stop and hand back the false premise.
4. Search the complete current test surface for permanent result assertions covering `STATE_MISSING`, `IDENTITY_MISMATCH`, `BAD_TURN` and their shared repair action. Verify cases 2 and 4 are the missing proof surface; if equivalent proof already exists, hand back rather than duplicate it.
5. Derive the truthful `turn_at_terminal`, `state_class`, state-hash and `owner_check` values for each branch from `validate_state`, `die` and the terminal-result producer. Do not pin a value the dispatcher cannot honestly know.

Required fail-capable evidence:

- Quote one narrow scratch mutation red and the matching real-dispatcher green before the test edit. It must preserve the expected state-validation exit while making at least the unique/completeness or truthful outcome assertions fail. Reuse the accepted shared-funnel mutation technique if suitable; do not commit three mutants.
- Quote the focused green totals for case 2 and case 4 and enumerate the three result records' outcome/code, uniqueness/completeness, pre-hop/no-model facts, truthful state/ownership facts, held-at-finalization facts and released-afterwards facts.
- Run `bash -n` on `dispatch.test.sh` and execute only cases 2 and 4 with the minimum harness prologue needed. Do not run case 22, the ownership cases, Unit 10 or the full suite.
- Confirm the committed diff contains only this state file and focused additions inside cases 2 and 4. `dispatch.sh`, the state validator and both lease/owner helpers must remain byte-identical; leave `logs/friction-log.md` unstaged.

Capability subset: baseline only — read the approved plan, accepted Unit 11 evidence, the existing state-validation/result producer and cases 2/4; edit focused test assertions; create and execute one scratch mutant; run local syntax and focused tests; and commit the test and this task state. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No model launch, authentication attempt, network, external service or operator-reserved capability is permitted.

Completion condition: one committed test-only handback permanently proves exactly one truthful complete result for the three existing initial state-validation terminals, changes no production file, and returns with `turn: codex`.

Stop and hand back if any fixture is pre-admission, equivalent permanent proof already exists, the assertions expose a production defect, or meaningful proof requires a generalized matrix, new production contract or production change. Challenge the brief rather than widening it.

## Latest result

Inspected (2026-08-18):

- Claim (1): HOLDS — `git show ceec75f7 --name-only` lists exactly this state file and `dispatch.test.sh`, three hunks (`@@ -722`, `@@ -751`, `@@ -5973`), all inside the two ownership cases. The `42/0`, `19/0` and `2/11` vs `13/0` figures are read from the accepted record and were not rerun. Unstaged at unit start: only `logs/friction-log.md` and this state file carrying Codex's brief.
- Claim (2): HOLDS — approved blob `c7857d5f`, three independent statements. Item 3, line 148: "Atomically finalize **exactly one** terminal result for: … invalid state or ownership". Change-set acceptance, line 216: "Every admitted-run terminal class produces **exactly one valid result**." Gate SA, line 404: "every terminal path after run admission produces **one durable atomic result with truthful** actor-start and before/after facts."
- Claim (3): HOLDS — the ordering is read from the file, not assumed. `wl_lease_init` at 1789, `RUN_ID`/`RUN_LOG` at 3221-3222, the **first** `validate_state` call at 4070, the ownership helper at 4096. So all three terminals fire below run identity, the evidence location and both leases, and **above** the ownership check. None is pre-admission; the brief's premise stands. (The later `validate_state` calls at 4192 and 4398 are the post-hop paths this brief defers.)
- Claim (4): HOLDS, and there is nothing to duplicate — searching the complete test surface for `STATE_MISSING`, `IDENTITY_MISMATCH`, `BAD_TURN` and `operator-repair-state-file-then-rerun` returns **zero matches**. Cases 2 and 4 are the missing proof surface, and between them they carried six assertions: exit 14, byte-identical state file, no launch; exit 13; exit 15; no launch.
- Claim (5): HOLDS, and the values were **derived by probing the live producer**, not taken from the brief. All three record `turn_at_terminal=unavailable` and `state_class=unavailable`, because `validate_state` dies before `ST_TURN` or `ST_CLASS` is assigned — production states this intent one branch further down, refusing to "guess at state". All three record `owner_check=unchecked`, because ownership runs below them; `dispatch.sh` marks that value as deliberately **not** a synonym for `unavailable`, which is reserved for the check being unrunnable. All three record `state_sha256_before/after=unavailable`, `stage=pre-hop`, `actor=none`, `hop=0`, and the shared `next_action=operator-repair-state-file-then-rerun`.

Result: **the three initial state-validation terminals now have permanent exactly-one-complete-result proof. Cases 2 and 4 went from 6 assertions to 67, all green, and `dispatch.sh`, the state validator and both lease/owner helpers are byte-identical to HEAD.**

**What changed, and only this.** `dispatch.test.sh` +110/-0, three hunks: the shared helper plus case 2's result block (`@@ -395`, `@@ -406`) and case 4's two branches (`@@ -517`). `git diff --quiet` passes individually on `dispatch.sh`, `work-loop-state.sh`, `work-loop-lease.sh` and `work-loop-owner.sh`. No exit-code matrix, no second schema checker, no new framework, no production helper.

**The one local helper, and why it qualifies.** `assert_state_terminal` carries the fifteen assertions the three fixtures genuinely share and takes the two that distinguish them — outcome and code — as arguments. It creates no contract: everything a fixture must prove on its own (its run id, the `state_file` path it names, the cross-branch comparison) stays at the call site. Mid-file helper definitions are established here, not invented: `plant_lease` (1448), `tree_outside_logs` (1557), `mk_stubborn` (2372) and others already do it.

Evidence:

- **The scratch mutation red, before the test edit, with the exit preserved.** The intended assertions were expressed against case 2's own fixture and run against a dispatcher copy whose die funnel cannot publish: **`pass=1 fail=15`**. The one pass is the important one — `PASS MUTANT — the state-validation exit is preserved`: the run **still exits 14**. Every assertion cases 2 and 4 already had would pass against that mutant, including the byte-identical-state check, while the record is gone. The fifteen failures are `results=0`, an empty sentinel read, and thirteen `got: <absent>` field reads. Against the real dispatcher the same block scored **`pass=16 fail=0`**.
- **No new mutant was committed, and that is a decision rather than an omission.** The brief allows one and forbids three. The seam these assertions depend on is the shared die funnel, and the suite already carries two permanent controls that cut exactly that line — M1 (case 50c) and M41 (case 12d, added last unit). A third copy of the same cut would add a way for three controls to disagree about one line, not a new failure mode. The scratch red above is this hop's fail-capability evidence; the standing controls are the permanent ones. If Codex wants a committed control anchored inside case 2 or 4, it is a one-line addition.
- **Cases 2 and 4, green: `pass=67 fail=0`.** Each of the three records proves: exactly one finalized result with no unfinalized temporary beside it; `result_complete=yes` as the last line; its own outcome/code pair — `IDENTITY_MISMATCH/14`, `STATE_MISSING/13`, `BAD_TURN/15`; `stage=pre-hop`, `actor=none`, `actor_launched=no`, `model_request_started=no`, `hop=0`; the shared `next_action=operator-repair-state-file-then-rerun`; the four truthful unobserved facts (`turn_at_terminal`, `state_class`, both state hashes) as `unavailable`; `owner_check=unchecked`; both `lease_*_at_finalization=held-by-this-run`; and both lease directories gone from the filesystem afterwards.
- **What the `unavailable` and `unchecked` assertions actually pin.** Not placeholder text — the claim is that the record reports what it could not observe **as unobserved instead of inventing it**. Code 15 is the case that shows this is a real observation rather than a constant: there the state file **exists and is readable**, and the dispatcher still refuses to name a classification, because the validator never returned one it recognises.
- **Each record names the file the operator must repair**, asserted per fixture against that sandbox's own canonical path. That is what makes the shared repair instruction actionable rather than merely correct — including for code 13, where the file is missing but still has a path.
- **The two case-4 branches are compared against each other**, not only against their own literals — the check a producer emitting one constant outcome would fail while both per-fixture assertions still passed. Both values are guarded non-empty first, so two absent reads cannot compare equal and report distinctness for records that were never written.
- **A defect of my own, found and fixed inside the unit.** The cross-branch comparison was first written to read the code-13 record after case 4 had already rebound `d` to a second sandbox — so it read a nonexistent path, and it also left a bare `[ ... ]` test whose result was discarded. It would have passed while proving nothing. The values are now carried out of the first sandbox into `OUTCOME_13`/`CODE_13` before the rebind, and the comparison is a real assertion.
- **Route and syntax.** `bash -n` clean on `dispatch.test.sh`. Only the helper, case 2 and case 4 were executed, extracted by line range over the harness prologue with `DISPATCH_BIN`/`REPO_ROOT` pinned. Case 22, the ownership cases, Unit 10 and the full suite were **not** run, as the brief requires. All probes and mutants live outside the tracked tree.
- **Final scope, by inspection.** `git status --porcelain` shows this state file, `dispatch.test.sh`, and the pre-existing unstaged `logs/friction-log.md`, untouched and left unstaged.

**No production defect was exposed.** Every value the new assertions read already carried the truthful thing the plan asks for, so this unit stayed test-only and nothing was handed back as a repair.

Deferrals recorded, not implemented (core § 5):

- **(a) `state_sha256_before=unavailable` is the weakest pin in the set, and it is worth naming.** For code 14 the state file exists and is readable, yet no hash is recorded, because the run died before any hop baseline was taken. That is honest today. But unlike `turn_at_terminal` and `state_class` — which the dispatcher structurally cannot know at that point — this one is merely not yet observed, so a future change that hashed the file earlier would make the assertion red for a *better* behaviour. Recorded so that, if it ever goes red, the answer is to update it rather than to reverse the improvement.
- **(b) Still deferred exactly as the brief sets them:** malformed-terminal code `26`; every post-hop or actor-launch code-`15` path (`validate_state` at 4192 and 4398); the additional code-`13` validator-missing and unreadable sub-branches (3508 and 3512, both real branches this unit did not reach); permission code `37`; budget code `29`.
- **(c) Unchanged:** the three uncovered `check_evidence_location()` refusal branches; other identifier and token bounds; every other Change set A clause; Change sets B–D; live trials including trial 8; the final synchronous regression; adoption review; the two stale historical probe scripts; and merge, push, deployment and destructive cleanup.

## Blocker

None.

## Next action

Codex: assess Unit 12. The three initial state-validation terminals now carry permanent exactly-one-complete-result proof — cases 2 and 4 go from 6 assertions to `67/0`, each record proving its own outcome/code, the shared repair action, the four truthful unobserved facts, `owner_check=unchecked`, and both leases held at finalization then released. Scratch red `1/15` versus real `16/0`, with exit 14 preserved under the mutant. `dispatch.sh` and all three helpers are byte-identical to HEAD and no production defect was exposed. Then decide three things. (a) Whether **committing no new mutant is accepted** — the shared funnel these assertions rest on already has two standing controls (M1 in case 50c, M41 in case 12d), so a third cut of the same line would add disagreement rather than a failure mode; if you want one anchored inside case 2 or 4, say so and it is a one-line addition. (b) Whether the **`assert_state_terminal` helper** stays — it removes fifteen genuinely repeated assertions across three fixtures and takes the distinguishing pair as arguments, but it is the first shared assertion helper in this suite and you may prefer the repetition. (c) Whether deferral (a) above matters — `state_sha256_before=unavailable` is pinned on a fact the dispatcher merely has not observed yet rather than structurally cannot know, so it would go red if the file were ever hashed earlier; and whether the next unit is the remaining result-proof gaps (`26`, `37`, `29`, the post-hop `15` paths and the two further code-`13` sub-branches) or something else in Change set A.
