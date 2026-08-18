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

Correction round on the one frozen finding. Reproduced first, by inspection: `run_ids_proven_in()` read a file in the working tree, and the actor has write access to the working tree, so the receipt was self-authenticating. `git status --porcelain` also collapses an untracked directory to one line whatever is beneath it, so an excused directory was a second hiding place the finding did not name. Both were then reproduced as failing cases before any edit.

Result: the classifier no longer runs while an actor can influence what it reads.

- `classify_prior_evidence()` (the former `prior_run_evidence()`) is now called exactly once, from `freeze_prior_evidence()` at the top level, after the allowlist is final and before the dry-run block and the hop loop — a point no actor of this run has reached. Nothing an actor writes afterwards can enter the set, because the set is closed before the actor exists.
- Each excused path is pinned to an `evidence_fingerprint()`: every non-directory file beneath it, sorted, each paired with its content hash, hashed to one line. `prior_run_evidence()` now requires both membership in the frozen set *and* a still-matching fingerprint, re-checked on every call — so one edit, one added file or one removed file inside an excused directory takes it back out and in front of the gate. The fingerprint is what makes the post-hop delta (`die_hop 24`) able to see through the collapsed porcelain line.
- The freeze is called from the top level, not lazily from `foreign_worktree()`: that function is always read through `$(...)`, so a freeze taken inside it would be discarded with the subshell and retaken post-hop, with the actor's writes already in the tree.
- An unfrozen run excuses nothing. A terminal reached before the freeze — argument refusal, lease refusal, state error — reports prior evidence as out-of-allowlist, which is true and is the fail-closed direction.
- The run now says out loud which paths it excused and pins them, so a path removed from the gate's view is never removed silently.

Evidence: new cases 66a–66c, red before the edit and green after; the finding's own controls.

- Red: `pass=9 fail=2`. 66a — an actor that mints `runs-forged/` with a lookalike `run=<id>` header and only `<id>.*` siblings mid-hop was excused, the post-hop delta saw nothing, and the run finished at 23 instead of 24. 66b — with a genuine `runs-a/` excused, an actor appending to its run log was likewise invisible and the run finished at 23.
- Green: `pass=11 fail=0`. Both now stop at `24`, with `calls=1` so the stop is about what the actor did, the stop naming the directory, and the minted files left in place for the operator.
- 66c is the over-correction control: the same two-run, two-directory sequence with the tamper removed must still pass. It does — exit 23, `calls=1`. Deleting the excuse entirely satisfies 66a and 66b and fails 66c.
- Closure-check regression, after the correction: `pass=137 fail=0` across cases 10, 12g, 12h, 12h-ok, 16, 29, 29b, 29c, 30, 30b, 30c, 63a, 63a (2), 63b, 64a, 64b, 65a–65d, 66a–66c. Unit 3's A-then-B success case, the genuine-foreign controls, and Unit 1's pre-admission refusal, Unit 2's lease-refusal result and `--status` boundaries are all intact.

Partly resolved, and stated rather than implied. The finding named "an actor **or pre-existing foreign process**". The actor half is closed structurally, by the freeze. The pre-existing half is **not**, and cannot be by any rule that reads the working tree: establishing provenance for content that was already there when the dispatcher started requires a secret the dispatcher holds and the writer cannot forge, and the only forms of that are the persistent registry or second authority store the brief excludes. Content already satisfying the classifier at freeze time is therefore trusted. What bounds the residue is composition, not the classifier: a forgery left by a previous hop's actor was outside *that* run's frozen set, so that run stopped at 24 and said so. The residue is a forgery arriving from outside the loop entirely, or from a hop killed before its post-hop delta ran. If Codex judges that residue unacceptable, the precise false premise to hand back is that the brief's exclusion of a persistent store and the requirement of provenance against pre-existing content cannot both hold.

Test-assertion change, disclosed: 65b's `does NOT name runs-a` assertion scanned the whole run output and started failing on the new advisory line — the dispatcher truthfully naming what it excused. It now scans only the `STOP [18]` block, which is the list of paths the operator is sent to act on. The behaviour it checks is unchanged; 65a gained two assertions that the advisory line is present and names the path.

Changed paths: `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, and this state file. Pre-existing `logs/friction-log.md` noise left unstaged.

Deferral noticed in this round, not implemented: an actor that **deletes** an excused directory outright is not seen by the post-hop delta — git reports nothing at all for an emptied untracked directory, so the line is absent from both snapshots. It hides nothing of the actor's own work, which is what the finding is about, so it is recorded rather than fixed here.

Deferrals carried forward: the dead `RUN_ID` checkout discriminator; Unit 1's shared-`new_sandbox` default-location fixture limitation; the focused-case selector (the slices above are still assembled by hand from line ranges); and the remaining Gate SA work named in the Unit 3 brief.

## Blocker

None.

## Next action

Codex: the closure check on frozen finding 1 only — whether actor-authored lookalike evidence can still suppress the foreign-work guard, and whether the correction broke Unit 3's A-then-B success case, the genuine-foreign controls, or the accepted Unit 1/2 admission, lease-refusal and status boundaries. The pre-existing-content residue is disclosed above with the premise Codex would need to reopen if it is not acceptable.
