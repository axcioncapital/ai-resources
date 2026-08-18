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

Standard. Implementation mode. Unit 3 — keep prior run evidence from blocking the next run

Named reason for the loop: the approved objective spans multiple bounded implementation, proof and operating-trial units, must survive session boundaries, needs its scope held against overengineering, and requires independent Codex assessment before it counts as complete.

## Brief

Unit 2 is accepted at `e54e8b227ec890aef5542a85183eff87f3c493ce`: an admitted task- or checkout-lease refusal now produces exactly one run-bound terminal result through the accepted producer/consumer contract and no standalone refusal artifact; targeted red was `11/15`, green `26/0`, and the focused regression slice passed `208/0`. Its case-12h rewrite is accepted as entailed by Patrik's approved boundary: an admitted run now initializes evidence before lease acquisition, so the earlier byte-identical-checkout assertion could not remain authoritative. Unit 2 also exposed a concrete sequential-use defect: evidence written by one admitted run under log directory A is seen by a later run using directory B as foreign working-tree content, causing a false exit 18 before any actor launch.

Dominant deliverable: prevent durable evidence from a prior admitted dispatcher run from being misclassified as foreign work solely because a later valid run selects a different evidence directory.
Evidence required in this hop: one targeted red-then-green two-run sequence using distinct evidence directories, plus one negative control proving a genuinely foreign path still stops at the existing guard.
Evidence explicitly deferred: terminal-result proof for missing runtime/authentication and the remaining enumerated classes; the dead `RUN_ID` checkout discriminator; Unit 1's shared-`new_sandbox` default-location fixture limitation; all other Change set A clauses; Change sets B–D; live trials; final regression; adoption review; the focused-case selector; merge, push, deployment and destructive cleanup.
Primary edit begins after: a focused sequence in one sandbox where an admitted lease-refused run writes its valid terminal evidence under log directory A and a subsequent otherwise-valid no-contention run using directory B stops at exit 18 specifically because A's evidence is classified as foreign.

Required outcome:

- A prior admitted run's durable dispatcher-owned evidence must not, by itself, cause a later valid run using a different evidence directory to stop as foreign work.
- Preserve the foreign-work guard: an unrelated or actor-created path outside the current task's allowlist must still be detected and must still stop through the existing classification.
- Do not blanket-ignore arbitrary user-selected directories, all untracked content, or a broad parent such as `plans/`; the distinction must remain narrow enough that the negative control can fail.
- Keep each run writing only to its selected evidence location and preserve the accepted single terminal-result authority.
- Preserve invalid pre-admission evidence-free behavior, admitted lease-refusal behavior from Unit 2, `--status` read-only behavior, and the ordinary no-contention path.
- Add no evidence registry, second state store, cleanup service, retention service, lifecycle parser or general allowlist-policy subsystem.

Check against the repository:

1. Verify Unit 2 commit `e54e8b22…` and its focused evidence still support acceptance: exactly one result for admitted lease refusal, no standalone refusal artifact, no actor/model launch, and a valid no-contention control. If that premise differs, hand back.
2. Verify the disclosed defect against the current `dispatch.sh` and `dispatch.test.sh`: current-run evidence is excluded through the current `LOG_REL`/allowlist path, while prior admitted-run evidence under a different selected directory reaches the foreign-work check and can cause exit 18. Bound the claim to those files and one focused reproduction; do not widen into a general repository scan.
3. Reuse the existing two-run real-holder/no-contention fixtures, terminal-result helpers and foreign-path negative controls where sufficient. Do not run a broad baseline before the primary edit.
4. Treat the exact narrow identification mechanism as Claude's technical judgment inside the approved envelope. If safely distinguishing prior dispatcher evidence requires a broad ignore rule, persistent registry, second authority store or material policy change, hand back the precise false premise instead of weakening the guard.

Required fail-capable evidence:

- Show the targeted A-then-B sequence failing before the primary edit with the second run stopping at 18 and naming only the first run's dispatcher evidence as foreign, then passing afterward far enough to prove the false stop is gone.
- Show a negative control in which a genuinely foreign path still produces the existing nonzero foreign-work outcome. A check that merely observes the second run no longer exits 18 is insufficient.
- Show focused regression for Unit 1's pre-admission refusal, Unit 2's lease-refusal result, `--status`, and one ordinary no-contention path.
- Report exact commands, assertions and counts, why each check could fail, changed paths, and the commit. Do not stage or commit unrelated pre-existing noise.

Capability subset: baseline only — read and inspect the governing plan, accepted task evidence, dispatcher, focused tests and necessary local history; edit only the dispatcher, its focused tests and this task state; run local focused tests; and make the local commit required by the Work Loop. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No network, external service, production action or operator-reserved capability is needed.

Completion condition: one committed implementation handback proves that prior durable dispatcher evidence under log directory A no longer causes an otherwise-valid later run using directory B to false-stop as foreign work, while a genuine foreign path still stops, the accepted admission/lease/status controls remain green, and this state returns with `turn: codex`.

Stop and hand back if the premise is false; if the sequence cannot isolate prior dispatcher evidence as the cause; if the only repair broadly suppresses unrelated working-tree facts or adds persistent machinery; or if satisfying it requires changing the approved evidence-location contract or another operator-owned policy. Challenge the brief rather than widening it.

## Latest result

Inspected (2026-08-18):

- Claim (1): HOLDS — inspected `git show --stat e54e8b22` and the current sources; `acquire_lock` is called at `dispatch.sh:3237`, below the run-evidence block at 3078–3148, and searching `dispatch.sh` for `REFUSAL_DIR|open_refusal_record|refuse_17|r17` returns only the deletion note at 1820–1821, no live code. Cases 64a/64b re-ran green in this hop's regression slice: exactly one run-bound result for an admitted lease refusal, no standalone refusal record, `calls=0`, plus the no-contention control launching and releasing both leases.
- Claim (2): HOLDS — and was reproduced, not merely read. `foreign_worktree()` (`dispatch.sh:2926`, now 3018) tested each porcelain line against `ALLOW_PATHS` only; the current run's evidence directory is added to that array at the `LOG_REL` block (3128), and nothing else was. The targeted A-then-B sequence run against the pre-edit dispatcher stopped run B with `STOP [18] out-of-allowlist working-tree changes are already present before launching codex` naming exactly `?? runs-a/` — run A's own evidence and nothing else. `allow_paths` on that run read `^logs/work-loop/ ^plans/work-loop-v2-v0\.2/handoff-automation-spike/ ^runs-b/`. `dispatch.test.sh` recorded the same consequence as a deferral in case 12h-ok's preamble; that comment is corrected in this commit because the deferral is now closed.
- Claim (3): HOLDS — reused `new_sandbox`, `state_file`, `run_id_of`, `res_count`, `expect_rc`, `out_has`/`out_lacks`, the case-64a live-holder fixture and the case-16 foreign-path controls. No broad baseline was run before the primary edit.
- Claim (4): HOLDS — no broad ignore rule, registry, second authority store or policy change was needed; the mechanism below is a read of artifacts already written.
- Packaging lines: all four present for Implementation mode, one deliverable named.

Result: a working-tree path is no longer classified as foreign work when it is untracked and contains nothing but an earlier dispatcher run's own evidence. `run_ids_proven_in()` reads each `*.log` in the candidate directory and accepts its stem as a run id only when the file's first line is that run's own `run=<id> ` header; `prior_run_evidence()` then excuses the path only if it is untracked and every non-directory file under it is named `<proven id>.*`. One stranger anywhere inside puts the whole path back in front of the gate, and tracked paths are never excused. The classification is asked second, after `ALLOW_PATHS`, so it only ever reaches lines that were about to be reported. Identification is by the run log's header rather than by the `RUN_ID` name format, deliberately: `LOCK_KEY` is never assigned, so real ids come out as `20260818T152713--99177-<task>` with the discriminator missing, and that is a live deferral — a format-keyed rule would have to move in step with its repair.

Evidence: new cases 65a–65d in `dispatch.test.sh`, run focused via a hand-assembled slice (harness prelude lines 1–360 + the case range + the suite tail).

- Red, before the primary edit: `pass=17 fail=3`. Run B exited 18 over `?? runs-a/` with `calls=0`; 65b additionally failed because the stop named `runs-a` alongside the genuinely foreign `actor-scratch/`.
- Green, after it: `pass=20 fail=0`. Run B exits 23 (hop limit), `calls=1`, writes its own result under directory B, and leaves run A's evidence unmoved and unstaged.
- Negative controls, green on both sides of the edit and fail-capable: 65b — an unrelated untracked `actor-scratch/notes.md` beside the prior evidence still exits 18, launches nothing, names `actor-scratch` and (after the edit) no longer names `runs-a`; 65c — a non-artifact `actor-notes.md` placed *inside* the prior evidence directory still exits 18 and still names `runs-a`, which is what proves the directory is not blanket-ignored; 65d — a tracked, then modified, file inside that directory still exits 18. A check that only observed "run B no longer exits 18" would pass against deleting the gate; 65c and 65d cannot.
- Focused regression, after the edit: `pass=124 fail=0` across cases 10, 12g, 12h, 12h-ok, 16, 29, 29b, 29c, 30, 30b, 30c, 63a, 63a (2), 63b, 64a, 64b, 65a–65d — Unit 1's pre-admission refusal, Unit 2's lease-refusal result, `--status` read-only and in-flight behaviour, the foreign-work guard itself, and an ordinary no-contention path.

Changed paths: `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, and this state file. Pre-existing `logs/friction-log.md` noise was left unstaged.

Recorded deferrals carried forward: the dead `RUN_ID` checkout discriminator (now load-bearing for a second reason — it is why this unit identifies evidence by header rather than by name); Unit 1's shared-`new_sandbox` default-location fixture limitation; and the remaining Gate SA work named in the Unit 3 brief.

Deferral noticed in this unit, not implemented: the suite still has no case selector, so the focused slices above were assembled by hand from line ranges. That is brittle against any edit that moves a case, but building a selector is outside this unit's completion condition and is already on the deferred list.

## Blocker

None.

## Next action

Codex: assess Unit 3 — whether the header-proven, untracked-only, whole-directory-must-be-clean distinction is narrow enough to keep the foreign-work guard intact, and whether 65b–65d are the right controls for it.
