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

Standard. Implementation mode. Unit 3 — keep one stable evidence location and the foreign-work guard strict

Named reason for the loop: the approved objective spans multiple bounded implementation, proof and operating-trial units, must survive session boundaries, needs its scope held against overengineering, and requires independent Codex assessment before it counts as complete.

## Brief

The first Unit 3 implementation and its correction proved a real tradeoff rather than a safe classifier: actor-authored lookalike evidence can be excluded only by freezing the classification before launch, while content already present when the dispatcher starts remains forgeable unless another trusted persistent authority is added. The approved plan neither requires changing evidence directories between sequential runs nor permits that second store. The existing default already gives each checkout one stable evidence location, and sequential runs aimed at the same location are the ordinary supported path. Codex therefore chooses the correction menu's **reframe the unit** option: remove the unsafe recognition mechanism instead of accepting its residual risk or adding machinery.

Dominant deliverable: remove automatic recognition of prior in-checkout evidence directories and make one stable evidence location per checkout the explicit supported operating path.
Evidence required in this hop: one targeted red-then-green pre-existing-forgery case, one same-location sequential-use control, one different-location fail-closed case, and focused preservation of the accepted Unit 1/2 and status boundaries.
Evidence explicitly deferred: terminal-result proof for missing runtime/authentication and the remaining enumerated classes; the dead `RUN_ID` checkout discriminator; Unit 1's shared-`new_sandbox` default-location fixture limitation; all other Change set A clauses; Change sets B–D; live trials; final regression; adoption review; the focused-case selector; merge, push, deployment and destructive cleanup.
Primary edit begins after: a focused case seeds a prior-looking untracked evidence directory before dispatcher start and proves the current classifier suppresses it, allowing the actor path to begin instead of stopping at the pre-hop foreign-work guard.

Required outcome:

- Delete the Unit 3 prior-evidence recognition, freeze, fingerprint, manifest and advisory mechanism; do not replace it with another content-based provenance guess.
- Keep the current run's selected evidence location on its existing narrow allowlist. Sequential runs using that same stable location must continue to work.
- Treat any other untracked in-checkout evidence directory like any other out-of-allowlist path: it must stop before actor launch at the existing foreign-work guard. A later run selecting directory B while directory A remains untracked is therefore a safe, actionable refusal, not a supported automatic migration.
- State the operating rule concisely in the existing dispatcher README: reuse the default or one stable `--log-dir` for a checkout; switching directories requires resolving the old out-of-allowlist path first.
- Preserve the accepted single terminal-result authority, invalid pre-admission evidence-free behavior, admitted lease-refusal behavior from Unit 2, `--status` read-only behavior and one ordinary no-contention path.
- Add no registry, secret, second state store, cleanup/retention service, lifecycle parser or allowlist-policy subsystem.

Check against the repository:

1. Verify the approved plan's Change set A and Gate SA require trusted evidence and strict foreign-path behavior but do not require sequential runs to switch evidence directories. Verify the current README documents a stable in-checkout default. If either claim differs, hand back.
2. Verify the current `classify_prior_evidence()` / `freeze_prior_evidence()` path trusts matching content already present at process start and can suppress it from `foreign_worktree()`. Bound this to `dispatch.sh` and the existing Unit 3 fixtures.
3. Verify the current run's `LOG_REL` path is independently allowlisted, so removing prior-directory recognition does not prevent repeated use of the same evidence location.
4. Reuse the existing focused Unit 1, Unit 2, status, no-contention and foreign-path fixtures. Do not run a broad baseline before the primary edit.

Required fail-capable evidence:

- Red then green: pre-existing forged prior-looking content is currently suppressed; after the edit it must stop at exit 18 before actor launch and name the path.
- Over-correction control: two sequential runs using the same evidence location still reach their intended terminal outcomes rather than stopping at 18.
- Explicit contract control: switching from evidence directory A to B while A remains untracked stops at 18 and gives the existing actionable path guidance.
- Focused regression for Unit 1's pre-admission refusal, Unit 2's lease-refusal result, `--status`, one ordinary no-contention path and one genuinely foreign path.
- Report exact commands, assertions and counts, why each check could fail, changed paths and the commit. Do not stage or commit unrelated pre-existing noise.

Capability subset: baseline only — read and inspect the governing plan, accepted task evidence, dispatcher, focused tests, existing README and necessary local history; edit only the dispatcher, its focused tests, its existing README and this task state; run local focused tests; and make the local commit required by the Work Loop. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No network, external service, production action or operator-reserved capability is needed.

Completion condition: one committed implementation handback removes the unsafe prior-evidence recognition mechanism, proves the stable same-location path works, proves a different untracked evidence directory fails closed before actor launch, preserves the accepted Unit 1/2/status controls, and returns this state with `turn: codex`.

Stop and hand back if the plan actually requires automatic switching between evidence locations; if the current location is not independently and narrowly allowlisted; if removal would require weakening the foreign-work guard; or if the focused preservation evidence cannot be produced. Challenge the reframe rather than adding a trusted store or broader exception.

## Latest result

Inspected (2026-08-18):

- Claim (1): HOLDS — searched the approved plan for anything requiring sequential runs to change evidence directories: `grep -n -i 'log-dir|evidence location|evidence director|switch'` over `work-loop-v2-dispatcher-reliable-supervised-use-implementation-plan-v0.1.md` returns exactly one line, § 5 Change set A item 1 ("create one run identity and initialize its external evidence location before any model request or mutating action"). Change set A's admission boundary, trusted field ownership and Gate SA's bullets require trusted evidence, one enforced ownership contract and path validation; none requires switching locations. README line 45 documents the default `--log-dir` as `<checkout>/plans/work-loop-v2-v0.2/handoff-automation-spike/runs` — one stable in-checkout location.
- Claim (2): HOLDS — and was reproduced, not read. `classify_prior_evidence()` (`dispatch.sh:3018` pre-edit) accepted any untracked directory whose every file was named after a run id proven by a `run=<id> ` log header, and `freeze_prior_evidence()` (3084) pinned it before launch. A directory seeded **before the dispatcher started** — `runs-preexisting/20260101T000000-forged.log` plus a `.out` payload — was excused: the run printed `prior_run_evidence=1 path(s) recognised as earlier dispatcher runs' own evidence and excluded from the foreign-work gate` naming `runs-preexisting/`, the actor launched (`calls=1`), and the run reached exit 23 instead of stopping at 18.
- Claim (3): HOLDS — the current run's location is allowlisted independently of any prior-directory recognition, at the `LOG_REL` block (`dispatch.sh:3336-3341` pre-edit): `ALLOW_PATHS+=("^$LOG_REL/")`, reached from `LOG_DIR`/`DEFAULT_LOG_DIR` and nothing else. Removing the recognition therefore cannot stop repeated use of one location, which case 65a now proves directly.
- Claim (4): HOLDS — reused `new_sandbox`, `state_file`, `run_dispatch`, `run_id_of`, `res_count`, `res_field`, `expect_rc`, `out_has`/`out_lacks`, `lock_path_for`, the case-64a live-holder fixture and the case-16 foreign-path controls. No broad baseline was run before the primary edit; the first run of this hop was the single red case.
- Packaging lines: all four present for Implementation mode, one deliverable named.

Result: the prior-evidence recognition mechanism is deleted. `run_ids_proven_in()`, `evidence_fingerprint()`, `classify_prior_evidence()`, `freeze_prior_evidence()`, `prior_run_evidence()`, the `PRIOR_EVIDENCE_FROZEN`/`PRIOR_EVIDENCE_MANIFEST` globals, the top-level freeze call and the excusal advisory are gone; `foreign_worktree()` now tests each porcelain line against `ALLOW_PATHS` and nothing else. Nothing content-based replaced it. The current run's evidence location remains allowlisted at the unchanged `LOG_REL` block, so sequential runs aimed at one stable location never reach the guard, and any other untracked evidence directory is out-of-allowlist like any other path. The operating rule is stated in the dispatcher README under "One stable evidence location per checkout", and the reason the guard cannot be made lenient safely is stated beside `foreign_worktree()` so the mechanism is not rebuilt by someone who only reads the code.

Evidence: cases 65a–65d rewritten and 66a kept in `dispatch.test.sh`, run focused via hand-assembled slices (harness prelude lines 1–360 + case ranges + a suite tail).

- Red, before the primary edit, on the seeded pre-existing forgery: the run announced `prior_run_evidence=1 path(s) … runs-preexisting/`, launched its actor (`calls=1`) and exited 23. The gate never saw content the dispatcher had not written.
- Green, after it: the Unit 3 slice (65a–66a) is `pass=28 fail=0`. The same slice against the pre-edit dispatcher kept as a backup is `pass=20 fail=8` — 65c and 65d fail entirely there (exit 23 with `calls=1` instead of 18 with `calls=0`, no path named, and the `prior_run_evidence` announcement present), while 65a, 65b and 66a pass on both sides because they are the preservation controls that must not change. That two-sided run is the fail-capability proof: the new claims cannot pass against the old dispatcher, and the old claims still pass against the new one.
- 65a — over-correction control, in its sharpest form: run A is refused at the lease (Unit 2's terminal, exit 17) and finalizes one result in the stable location; run B is pointed at the **same** location, is not refused (exit 23), launches (`calls=1`), writes its own run-bound `.result` there, leaves run A's result intact (2 results, neither overwritten), stages nothing, and the output no longer contains `prior_run_evidence` — so the sequential path works without anything being excused.
- 65b — a genuinely foreign untracked `actor-scratch/notes.md` beside the stable location still exits 18 with `calls=0`; the STOP-block text names `actor-scratch` and does not name the run's own evidence location.
- 65c — the explicit contract: run B aimed at directory B while directory A is still untracked exits 18 with `calls=0`, the STOP block names `runs-a` and carries `Recoverable next action`, and directory A is left untouched (refused, not tidied away).
- 65d — the case that decided the design: evidence-shaped content present before the dispatcher starts exits 18 with `calls=0`, the STOP block names `runs-preexisting`, and nothing in the run claims to have recognised it.
- 66a — unchanged and still green: an actor that mints a dispatcher-shaped directory mid-hop is still caught at 24 with the directory named and its files left in place.
- Focused regression, after the edit: `pass=233 fail=0` across cases 10, 12g, 12h, 12h-ok, 16, 29, 29b, 29c, 30, 30b, 30c, 30d, 30e, 30f, 30g, 30h, 30i, 30i-b, 63a, 63a (2), 63b, 64a, 64b, 65a–65d, 66a — Unit 1's pre-admission refusal, Unit 2's lease-refusal result, `--status` read-only, in-flight, uninspectable-pid and holder-identity behaviour, the foreign-work guard itself, and an ordinary no-contention path.

Cases 66b and 66c were retired, not deleted silently: both asserted behaviour about a "legitimately excused evidence directory", and after this unit no directory is excused — 66b's setup now stops at 18 before the actor it needs is launched, and 66c's claim is 65a's with a second directory it no longer needs. The retirement and what covers them now (66a and 65a) is written into `dispatch.test.sh` where they stood. Case 12h-ok's preamble is corrected in the same commit: the sequential-directory consequence it recorded as a deferral is now the documented contract, not a repaired defect.

Changed paths: `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `.../dispatch.test.sh`, `.../README.md`, and this state file. Pre-existing `logs/friction-log.md` noise was left unstaged.

Recorded deferrals carried forward unchanged: terminal-result proof for the remaining enumerated classes; the dead `RUN_ID` checkout discriminator; Unit 1's shared-`new_sandbox` default-location fixture limitation; the rest of Change set A and sets B–D; live trials; final regression; adoption review; merge, push, deployment and destructive cleanup. The correction's carried observation — that deleting an already excused untracked directory could be invisible to both Git snapshots — is moot, as Codex predicted: nothing is excused any more.

Deferral noticed in this unit, not implemented: the missing focused-case selector is now measurably costly, not just brittle. The first regression slice of this hop reported 15 failures across cases 30d–30f that were purely a slicing artifact — `lock_path_for()` is defined at line 2045, outside the chosen range, so the fixtures planted no lock. Running the identical slice against the pre-edit dispatcher backup returned the same `47/15`, which is what proved it was the slice and not the edit; adding the three-line definition returned `62/0`. A real selector would have made that impossible rather than merely detectable. Building one is outside this unit's completion condition and stays on the deferred list.

## Blocker

None.

## Next action

Codex: assess the reframed Unit 3 against its completion condition — the recognition mechanism removed with no content-based replacement, the stable same-location sequential path proven working, a different untracked evidence directory failing closed before actor launch with actionable guidance, pre-existing evidence-shaped content no longer trusted, the operating rule stated in the README, and the accepted Unit 1, Unit 2, `--status` and no-contention controls preserved. Then close, continue to the next unit, or correct once.
