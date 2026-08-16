---
task: work-loop-v2-durable-state-system
status: active
turn: codex
---

## Objective and scope

Implement the frozen Work Loop v2 durable-state plan sequentially until the accepted state system is demonstrated end to end and ready for the operator's landing decision.

Scope is the capabilities, migration order, eight tracer bullets, assessment gates, and completion proof in `plans/work-loop-v2-v0.2/work-loop-v2-durable-state-system-implementation-plan-v0.1.md`. The plan's explicit exclusions remain excluded; repository evidence may challenge a factual premise or expose a safety contradiction, but may not silently redesign the accepted architecture.

## Lane and unit

Standard. Adoption mode. Unit 10 — Tracer bullet 8: demonstrate cutover readiness and return the final landing recommendation.

Named reason for the loop: the multi-unit state-system cutover now needs one representative end-to-end demonstration and an assessment independent of its builder before the implementation task can close and the operator can decide whether to land the branch.

## Brief

Tracer bullet 7 is accepted after its one narrowed correction: all nine scenarios pass, and scenario 6 now proves migration from committed, validated source state without copying a live record. Tracer bullet 8 is the final readiness gate in the frozen plan: establish whether the complete candidate is good enough to present for landing, without adding more machinery or reopening proportional evidence already accepted.

**Required outcome:** Demonstrate one representative Work Loop lifecycle through the real candidate interfaces, obtain an independent bounded assessment against the frozen Fixed Point and success condition, run proportional final regression checks, and return one explicit lifecycle recommendation: ready for the operator's landing decision, revise, continue the trial, or stop. Do not merge, push, land, or close this implementation task in this unit; Codex must assess this evidence and issue the close verdict first.

**Governing authority and source disposition:**

- The frozen implementation plan governs: the Fixed Point, all fixed decisions and exclusions, Tracer bullet 8, the Proof Matrix, the success condition, rollback boundary, and Execution and Assessment Rules.
- The canonical executable core governs roles and closure ordering. The current validator, owner helper, Reorient, Claude entry, both couriers, shared lease helper, legacy isolation, and capability readiness check govern their own runtime seams.
- Accepted Tracer 1–7 commits and state handbacks are authoritative evidence for already-proven component and operational outcomes. Import them by commit and result; do not rerun a passed proof merely to make the final count larger.
- Operator decision, 2026-08-16: Tracer 7's existing fresh-session/Reorient and concurrency evidence is proportionate. Additional top-level live-agent or actor-level duplication is ceremony and is not part of this unit.
- Admissions remain generally paused. A single bounded representative fixture/task used only for this final proof is permitted by Tracer 8; it is not a reopening of ordinary admissions.
- The three existing deferrals remain outside this unit unless the independent assessment proves one defeats the Fixed Point: no atomic migration verb/runbook; the less-helpful replica refusal message; and explicit owner `clear` not independently checking committed closure.

**Verify first against the repository:**

1. Reconfirm the exact checkout/task, HEAD `a53c6b5f`, `ACTIVE_CLAUDE`, unique repository-depth ownership, complete capability readiness, and free shared leases. Stop on ambiguity, a competing actor, or a different HEAD.
2. Establish that the accepted Tracer 1–7 implementation/proof commits, including Tracer 7 correction `1223fda5`, are ancestors of the candidate. Identify the fixed baseline `814f305b56d87b2c8453ce0ca41a769873526521` and the exact candidate range the independent assessment will judge.
3. Inspect the current diff and runtime dependency graph before choosing the smallest final regression set. Treat unchanged, already-accepted proof as imported evidence; rerun only final checks that are load-bearing for integration or whose inputs changed after their accepted result.

**Representative end-to-end demonstration:**

Use one bounded temporary repository or linked checkout with the shipped candidate surfaces; create no permanent second state system and leave no owner/lease residue. Demonstrate, with fail-capable observations:

1. controlled admission creates a task-only owner and valid `ACTIVE_CLAUDE` record;
2. the real Claude-entry/owner/validator/courier seams admit the correct actor, commit its handback, and yield `ACTIVE_CODEX` without scanning or legacy session state;
3. the assessment/close-token seam leads to one valid `CLOSED` record, with the closing commit present before the owner is cleared;
4. the closed checkout is reusable and a different task can claim it without stale-state ambiguity;
5. one wrong-order control (clear before committed closure, malformed/active holder, or equivalent nearest discriminator) refuses rather than falsely proving reuse.

Do not simulate Codex's judgment as evidence. Use this implementation task's actual accepted Codex assessments and Claude handbacks for the role split; use the representative proof for the mechanical lifecycle and reuse seams. The actual implementation-task closing write remains the next move after Codex accepts this unit.

**Independent bounded assessment:** Have a reviewer independent of the implementation work judge the candidate diff against the frozen Fixed Point, seven success conditions, exclusions, and rollback boundary. Keep it bounded to material landing blockers: lifecycle correctness, unique durable truth, fail-closed ambiguity, closure ordering, recovery, shared live leases, legacy isolation, and absence of excluded machinery. The verdict must be `Pass`, `Correct`, or `Escalate`, with evidence tied to exact paths/commits. If it is not `Pass`, do not self-correct inside this Adoption unit; return the findings to Codex.

**Boundary:** This is a readiness proof and assessment, not another implementation pass. Add no runtime feature, fallback, second helper/store, telemetry, convenience tooling, migration automation, cleanup automation, Phase 2 worktree behavior, or soak test. Do not invoke nested Claude or Codex actors, broaden permissions, merge, push, land, close the current implementation task, or clear its owner. Leave hook-written `logs/friction-log.md` and `logs/innovation-registry.md` uncommitted and outside any commit.

**Required evidence:**

- Report the representative task's exact state classifications, owner values, relevant commits, closure-before-clear ordering, new-task claim, negative-control refusal, and cleanup/no-residue result.
- Map each Fixed Point success condition to the accepted proof commit or the new representative observation that satisfies it; a short table is enough and should not reproduce old reports.
- Return the independent assessment's exact reviewer boundary, verdict, material findings if any, and evidence. Separate repository observations from reviewer claims.
- Report the final proportional regression commands/counts/exits and why each was rerun or imported. Do not rerun the whole history without a changed seam.
- Report the candidate diff boundary and show no legacy fallback parser, second state store, duplicate lease helper, or excluded machinery entered it.
- Give the operator the proof set, known accepted limitations/deferrals, and rollback boundary: before landing, withhold the isolated branch; after landing, deliberate Git revert plus explicit restoration of any open record/owner pair from known pre-cutover evidence.
- Report exact changed paths/commit for this unit, if any, and validate the handback as `ACTIVE_CODEX`.

**Completion condition:** Return the representative lifecycle/reuse proof, independent verdict, proportional final regression evidence, exclusions check, proof set, accepted limitations, and rollback boundary with `status: active` and `turn: codex`. End with one recommendation: ready for the operator's landing decision, revise, continue the trial, or stop. Confirm the implementation task and its owner remain open for Codex's close verdict, admissions remain paused, and nothing was merged, pushed, or landed.

**Stop conditions:** Stop and hand back exact evidence if a premise is false; the representative lifecycle cannot be shown at the real candidate seams; the independent assessment is `Correct` or `Escalate`; a success condition remains unsupported; a final check is red; or proceeding requires implementation, nested models, an excluded mechanism, operator-reserved capability, merge, push, landing, or current-task closure.

Capability subset: baseline only — read and inspect repository state/history, run local tests and bounded local processes, create a temporary repository/worktree for the representative proof, write the result to this state file, and make the local handback commit. Nothing is selected from the pre-authorizable set, which is empty today. No operator-reserved capability is needed.

## Latest result

Correction round on the two frozen findings. Both reproduced first, both corrected, and one of them corrected differently from the way the finding prescribed — on measured evidence, reported rather than applied quietly.

**Reproduced before touching anything.** Finding 1: the readability toggle returned `REFUSE` exit 3 → `PROCEED` exit 0 → `REFUSE` exit 3, with nothing changing between runs but whether one sibling worktree could be entered. Finding 2: `work-loop-v2-slice-1.test.sh` reported 307 passed, 1 failed, on `mode  the live task's own state file records exactly one legal mode`.

**Finding 1 — corrected, and one premise inside the finding is false.** The finding directed the fix to keep a gone/present distinction "based on the porcelain evidence", meaning git's `prunable` marker. That marker cannot carry the distinction, and the first attempt built on it failed in exactly the predicted way — the proof still returned `PROCEED` for the unreadable checkout. Measured against real git, five cases:

| worktree state | enterable | git reports prunable |
|---|---|---|
| healthy | yes | no |
| **present but unreadable** | no | **yes** |
| directory deleted | no | yes |
| moved away | no | yes |
| locked, then deleted | no | no |

Rows 2 and 3 are the two states the correction must separate, and `prunable` gives them the same answer — because git's marker is the result of stat-ing the worktree's gitdir target, and that stat fails identically for "gone" and for "cannot read". A rule keyed on it skips the unreadable checkout and reinstates the fail-open being removed.

What separates them is the filesystem: only row 2's path still exists. `logs/scripts/work-loop-owner.sh` now tries to enter each registered worktree first; on failure it treats the entry as genuinely gone **only** when the path does not exist *and* its parent is readable and searchable, and otherwise records it as uninspectable. Any uninspectable entry makes the whole repository-depth answer `AMBIGUOUS` exit 4, ahead of every other row, because no count is complete once one checkout could not be read. The parent test is load-bearing rather than defensive: `[ -e ]` answers false both for "not there" and for "cannot tell", so without it a worktree whose *parent* is unreadable would be read as gone — the same fail-open one directory up, and it is now covered. `prunable` is still parsed, and is used only to tell the operator what git thinks. Nothing new guards the mutation: `claim` and `clear` already stop on any verdict that is not `PROCEED`.

**Finding 2 — corrected as prescribed.** `logs/scripts/work-loop-v2-slice-1.test.sh:1380` now asserts the contract instead of one of its instances: the live open Standard record names exactly one mode, and that mode is a member of `ALLOWED_MODES`. Both halves are load-bearing — membership alone would accept a record naming two legal modes, exactly-one alone would accept a single invented mode. The missing, multiple and unknown controls are untouched, and a new negative control is derived from the live record itself, replacing its real mode with `Exploration` and requiring the same predicate to reject it. A membership check that never rejected anything would otherwise pass whatever the record said, which is how the literal it replaced stayed green for nine units while being wrong.

**Regression protection added, because the fix was otherwise invisible.** Finding 1's only proof was a scratchpad script, and every other assertion in the owner suite returns the same verdict before and after the change — which is precisely why the fail-open could return unnoticed. `logs/scripts/work-loop-owner.test.sh` gains T16 and T16b: a readable competitor still naming the real owner (so an `AMBIGUOUS`-for-everything helper cannot pass), the unreadable competitor returning `AMBIGUOUS` exit 4 and naming the checkout it could not read, a contested claim installing no declaration and leaving the holder's own untouched, and a genuinely deleted worktree still being skipped so the stricter rule cannot become blanket over-refusal.

Result: both frozen findings are resolved, and the correction broke nothing that this repository's own checks can detect.

Evidence:

- **Fail-capability, proved by running the corrected checks against the pre-correction helper**, not asserted. The new owner-suite cases go **4 red** on the old helper (`unreadable competitor — AMBIGUOUS`; the verdict naming that checkout; the contested claim refusing; no declaration installed) and green on the corrected one. The standalone five-mode proof goes **7 red** on the old helper, including a cascade where the old code installed a second declaration for a task another checkout already held — the durable double-claim the finding predicted, observed.
- **Focused proof, all five worktree failure modes plus an unreadable parent: 18 passed, 0 failed.** Readable competitor `REFUSE`/3; present-but-unreadable `AMBIGUOUS`/4; readable again `REFUSE`/3; contested claim exit 4 writing nothing, with both declarations intact; deleted, locked-then-deleted and moved-away all still skipped; unreadable parent `AMBIGUOUS` rather than skipped; healthy repository still `PROCEED`/0 with the claim installed.
- **Directly affected regressions, all at this working tree:** owner **133/0** (122 before, plus the 11 new cases), slice-1 **309/0** (307 restored, plus the new negative control), tracer-6 **74/0**, tracer-7 **120/0**, carry-turn **457/0**, dispatch **639/0**, and the Tracer 8 representative lifecycle demonstration **44/0**. Not rerun, and stated as imported: state, lease, capability, session-preflight and core-resolver — `git status` shows their surfaces untouched by this correction.
- **No behaviour change in the healthy repository.** Old and new helper compared side by side on five task ids in this checkout — `work-loop-v2-durable-state-system`, `autonomy-authority-capability`, `fixture-slice1-true`, `not-a-real-task`, `work-loop-v2-intake-router` — identical verdicts in every case. The stricter rule does not jam ordinary work.
- Diff: 4 files, 46 lines of non-comment code changed. `bash -n` clean on both changed scripts.

**The independent re-check is `unassessed`, by operator decision.** A bounded re-check of exactly these two questions — are the findings resolved, and did the correction break something — was dispatched to a reviewer independent of this work, and had not returned when the operator chose to hand back rather than wait. It is recorded `unassessed` rather than claimed: no independent judgment of this correction exists, and this handback does not imply one. If that reviewer returns after this commit, its verdict will be reported as a follow-up and not silently folded into an accepted result. Codex decides whether closure needs it.

Newly noticed, recorded as deferrals and **not** implemented:

- A worktree that git reports prunable but whose directory is still enterable is inspected, and a stale `.owner` inside it would be counted as a claimant and over-refuse. This behaviour is unchanged by the correction — the old code inspected it too — so it is neither caused nor fixed here, and it sits outside the frozen scope.
- The Tracer 8 representative lifecycle demonstration and the five-mode finding-1 proof remain uncommitted scratchpad harnesses; only the owner-suite cases became permanent. Whether the representative end-to-end demonstration deserves a committed home is a separate decision, and adding one would have been the convenience tooling Tracer 8's boundary excludes.

Changed and committed: `logs/scripts/work-loop-owner.sh`, `logs/scripts/work-loop-owner.test.sh`, `logs/scripts/work-loop-v2-slice-1.test.sh`, and this record. Admissions remain paused. Nothing was merged, pushed, landed, closed or cleared; no capability was broadened.

## Blocker

None.

## Next action

Codex: run the closure check on the two frozen findings only — are finding 1 and finding 2 resolved, and did the correction break something? Two things need your decision rather than mine.

First, finding 1 named `prunable` as the gone/present discriminator and that premise is false: git reports `prunable` for a worktree it merely cannot read as well as for one that is gone, measured across five cases in the record above. The defect the finding describes is fixed, but by the filesystem test rather than the mechanism the finding prescribed. Confirm that substitution is accepted, or say what else it should have been.

Second, the independent re-check is `unassessed` — it was dispatched and had not returned when the operator chose to hand back. Decide whether closure needs it before the verdict, or whether the fail-capability evidence in this record is enough. If a late verdict arrives it will be reported as a follow-up, not folded in.

Two deferrals are recorded above and are not implemented. Do not reopen the rest of Tracer 8.
