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

Inspected (2026-08-16):

- Claim (1): HOLDS — checkout `ai-resources-durable-state`, branch `session/2026-08-14-durable-state`, `git rev-parse HEAD` = `a53c6b5f1169351f1482129a5593119eb5f13943`; `work-loop-state.sh validate --task work-loop-v2-durable-state-system` = `ACTIVE_CLAUDE` exit 0; `work-loop-owner.sh check --depth repo` = `PROCEED` (this checkout already declares the task); `work-loop-capability.sh check` = `READY`, all five components; searched the Git common directory `ai-resources/.git/work-loop-dispatch-locks` for `task-*.lock` and `checkout-*.lock` — no match, so both shared leases are free (only a historical `refusals/` record from `cross-transport-concurrency-correction` is present, which pins nothing). No competing actor.
- Claim (2): HOLDS — `git merge-base --is-ancestor` returns true for all ten accepted implementation/proof commits: T1 `bc5e9add`, T2 `a1c81caf`, T3 `bd04704f`, T4 `f3eec25d`, T5 `e2823253` + `8560e632`, T6 `096b8985` + `96ff6786`, T7 `c650d2a1` + correction `1223fda5`. Baseline `814f305b56d87b2c8453ce0ca41a769873526521` is an ancestor of HEAD and is exactly `git merge-base main HEAD`, so the candidate range is `814f305b..HEAD` — 123 files, +17472/−1180. That is the range the independent assessment judged.
- Claim (3): HOLDS — the diff and the runtime dependency graph were inspected before the regression set was chosen; the rerun/import reasoning is in the regression table below.

Result: Tracer bullet 8 is executed as an Adoption unit and returns **revise**, not ready for the operator's landing decision. The representative lifecycle, reuse and negative controls are all green and they close the one gap the independent reviewer could not evidence, but the assessment verdict is `Correct` and one final check is red. Both stop conditions in the brief fire, so nothing was self-corrected.

**Representative end-to-end demonstration — 44 passed, 0 failed.** One bounded temporary repository with its own Git object store, carrying the shipped candidate surfaces (validator, owner helper, capability check, Reorient skill, compact hook plus its `SessionStart`/`compact` registration, the `.owner` ignore rule, the Claude entry command). Observations, in order:

1. *Admission* — `claim --depth repo` → `PROCEED` exit 0; `.owner` holds exactly `representative-lifecycle-proof`, one line, one field, untracked under the live ignore rule; validator → `ACTIVE_CLAUDE` exit 0; committed at `97194e8`.
2. *Claude entry and handback* — the three real gates ran in order: capability `READY`, validator `ACTIVE_CLAUDE`, ownership `PROCEED`. A decoy second record also at `turn: claude` was present throughout and changed nothing; an unnamed task id was refused (exit 13) rather than resolved by scanning. Handback committed at `feae411`, validator → `ACTIVE_CODEX`, declaration survived the handoff. Searched `work-loop-state.sh`, `work-loop-owner.sh`, `work-loop-capability.sh` and `.codex/hooks/work-loop-reorient.sh` for `session-notes.md|prime-session-entry.sh|compact-summary|session-marker` — no match, so no legacy session state entered the path.
3. *Closure ordering* — valid `CLOSED` record, validator → `CLOSED`, declaration still held; closing commit `201c1e4` lands with `.owner` still in place; only then `clear` exit 0 removes it. The closing commit is an ancestor of HEAD at the moment the clear ran, so the committed-before-cleared order is observed, not asserted.
4. *Reuse* — a different task claimed the same checkout: `PROCEED` exit 0, declaration renamed, new record `ACTIVE_CLAUDE`, prior record still `CLOSED`, repo-depth check exit 0 with no stale-state `AMBIGUOUS`.
5. *Wrong-order controls, all refusing* — a second task claiming an occupied checkout → `REFUSE` exit 3, declaration unchanged; an **uncommitted** valid `CLOSED` record → still `REFUSE` exit 3 at repo depth (HEAD does not carry the closing record), which is the nearest discriminator for "clear before committed closure"; `clear` against another task's declaration → refused exit 3, declaration survived; a record with no `status:` → exit 15; `closed` status over a surviving active body → exit 16; an unregistered compact hook → capability `INCOMPLETE`, not `READY`.

**The demonstration is fail-capable, proved by mutation, not asserted.** Substituting a validator that always answers `ACTIVE_CLAUDE` turns it red at 37/7; substituting an owner helper that never refuses turns it red at 36/8. The seven and eight failures are the lifecycle and refusal assertions respectively, so the green run binds to real behaviour at both seams.

**Independent bounded assessment — verdict `Correct`.** Reviewer boundary (reviewer's own words, recorded as their claim): both frozen authorities read in full; validator, owner helper, capability check, session preflight, entry command and Reorient skill read as code; the lease/ownership/terminal/post-hop regions of both couriers read; all five unit suites and both proof suites run; and — not taking green as proof — 16 validator cases, 10 ownership/closure-crash cases and one worktree-enumeration case built from scratch, plus all 74 tracked records validated. Not covered: real Claude/Codex model invocation (prohibited by this brief), Tracer 8 itself, lease-algorithm internals, `--unattended` effective sandbox policy. Dimensions 1, 2, 4, 5, 6, 7 and 8 returned clear; dimension 3 returned concern on one finding.

- **F1 (reviewer, material) — repository-depth ownership fails open on a worktree that is listed but cannot be entered.** `logs/scripts/work-loop-owner.sh:347-348` skips such a worktree with `continue`, so a live declaration held there becomes invisible. **Reproduced independently here, not taken on the reviewer's word:** in a throwaway repo where checkout B is a registered worktree of A and B declares task `T`, `check --checkout A --task T --depth repo` returns `REFUSE` exit 3 naming B; with B present but unreadable it returns `PROCEED` exit 0 reasoning "task 'T' has exactly one state file and it is in this checkout"; with B readable again it returns `REFUSE` exit 3. Git reported B as not prunable throughout, and no Git state changed between the three runs — only readability. The same function already treats a *whole-enumeration* failure as unestablished (`:336-340` returns `AMBIGUOUS`), so this per-worktree path is inconsistent with the fail-closed rule the function applies one screen earlier, and `git worktree list --porcelain` emits a `prunable` line that would separate the genuinely-gone case from this one. Consequence: two checkouts can end up durably declaring one task; it is noticed later, as a permanently `AMBIGUOUS` checkout, rather than at the moment the wrong claim was made. Live actor exclusion is not affected — the shared lease is rooted in the Git common directory and both couriers still contend — so this degrades durable binding, not live safety.
- **F2 (found here, material) — one final check is red, and it is red on correct behaviour.** `logs/scripts/work-loop-v2-slice-1.test.sh:1380-1381` asserts `[ "$(mode_of '$LIVE_TASK_F')" = Implementation ]` against this live task record. Unit 10 is legitimately `Adoption mode`, which is in the suite's own `ALLOWED_MODES` at `:1252`, so the suite reports **307 passed, 1 failed**. The assertion pins a literal where membership was meant: core § 3 states the three modes "are not a sequence" and that a unit may return to a mode an earlier one used, so this goes red every time a task legally changes mode, while pointing at nothing wrong. Its two neighbours at `:1376` and `:1393-1398` are already written as membership or rejection checks, so the fix is in-kind and inside the frozen plan. Not self-corrected: this is an Adoption unit and the brief excludes another implementation pass.

**Fixed Point success conditions — proof map.**

| # | Success condition | Satisfied by |
|---|---|---|
| 1 | every consumer classifies via the shared validator | T3 `bd04704f`; both couriers call `work-loop-state.sh` and `carry-turn.sh:660-662` `closing_record_ok()` reads the validator's `ST_CLASS` rather than the body; reviewer dimension 1 clear |
| 2 | records and declarations in the new shape, negative fixtures still failing for their reason | T2 `a1c81caf`; state suite 100/0; reviewer validated all 74 tracked records |
| 3 | fresh/compacted agent resumes from durable evidence without scanning | T6 `096b8985`, T7 `c650d2a1` S7/S8; **new** — demonstration 2, decoy record ignored and an unnamed id refused exit 13 |
| 4 | blocked, interrupted, ambiguous, stale-owner, closure-crash, migration and concurrent scenarios behave as specified | T6 74/0, T7 120/0 including migration scenario 6 at `1223fda5` — **except the ambiguity path in F1** |
| 5 | both couriers contend through one live-lease contract | T7 S9; lease suite 136/0; searched the repository for `work-loop-dispatch-locks` outside tests — only `logs/scripts/work-loop-lease.sh` |
| 6 | clean closure commits first, clears second, permits a new claim | **new** — demonstration 3, 4 and 5; this is the condition the reviewer named as not evidenced by the candidate range, and it is now evidenced |
| 7 | the operational proof suite passes at real command, recovery, ownership and courier seams | regression table below — **one red, F2** |

**Final proportional regression evidence, all at `a53c6b5f`.** Rerun: `work-loop-state` 100/0, `work-loop-owner` 122/0, `work-loop-capability` 77/0, `work-loop-lease` 136/0, `work-loop-session-preflight` 60/0, `work-loop-v2-core-resolver` 4/0, `work-loop-v2-tracer-6` 74/0, `work-loop-v2-tracer-7` 120/0, `carry-turn` 457/0, `dispatch` 639/0, `work-loop-v2-slice-1` **307/1**. Totals 2096 passed, 1 failed, plus the new demonstration 44/0. Each was rerun because it binds a surface that would land: the validator is the new lifecycle authority, the owner helper carries closure ordering and is where F1 sits, the capability check gates any checkout receiving the branch, the lease and both couriers changed inside the candidate, and slice-1 binds the entry command. `carry-turn` is notable — the plan recorded 274 passed / 11 failed at planning time from `ps` being unavailable in the Codex sandbox; here it is 457/0, so that limitation is environmental and now resolved. Imported rather than rerun: the Tracer 1–5 focused verifications, whose surfaces are unchanged since their accepted commits and are covered transitively by the state, owner and capability suites; and the Phase 1 live cross-courier lease proof, accepted under its own task and confirmed applicable in T7 S9.

**Exclusions check on `814f305b..HEAD` (own repository observation).** Searched the added lines of every runtime surface for `sqlite|database|registry|scheduler|heartbeat|event.?log|cron|telemetry|--json|worktree add`: the only hits are prose denying that the capability check is a registry, `codex exec --json` which is that product's output format rather than validator output, and `git worktree add -q` occurring **only** in three `.test.sh` sandboxes — so no Phase 2 automatic worktree creation entered the runtime. Exactly one file names the lease root, so there is no duplicate lease helper. No runtime consumer infers closure from `turn: operator`. Two pre-existing Phase 1 proof scripts, `parallel-landing-qc.sh` and `parallel-isolation-check.sh`, do parse `turn: operator` themselves; `git diff --stat 814f305b..HEAD` shows both unchanged by this candidate and neither is in the runtime path, so they are recorded as an observation, not a finding.

**Proof set for the operator, limitations and rollback boundary.** Proof set: implementation commits T1–T7 with their two corrections; deterministic proofs T6 74/0 and T7 120/0; the 2096-assertion final regression run; the 44-assertion representative lifecycle demonstration with its two mutation runs; and the independent assessment above. Accepted limitations carried forward unchanged, none defeated by the assessment: no atomic migration verb or runbook; one replica refusal message names checkout occupancy rather than the task's other owner; explicit `clear` does not itself verify committed closure — the guard sits at repo-depth staleness clearing, which demonstration 5 shows holding. Two limitations the reviewer added: no real Claude or Codex model has yet run under the new contract (nested model launch is prohibited by this brief, so the "live" proofs drive real courier processes with scripted actor commands), and Tracer 8 itself is not in the assessed range. Rollback boundary: **before landing**, rollback is withholding this isolated branch, and nothing outside it has changed; **after landing**, rollback is a deliberate Git revert of the cutover commits plus explicit restoration of any still-open record/owner pair from known pre-cutover evidence — no automated downgrade parser is retained, by design.

**Recommendation: revise.** Two material findings stand between the candidate and a landing decision — F1, a fail-open in the one dimension the architecture is built to fail closed on, and F2, a red final check. Neither is architectural: both are fixable inside the frozen plan, F1 by treating an unenterable non-prunable worktree the way the enclosing function already treats an unenumerable list, and F2 by asserting membership in `ALLOWED_MODES` instead of a literal. Everything else the readiness gate asks for is green.

**Unit boundary.** Changed and committed: `logs/work-loop/work-loop-v2-durable-state-system.md` only. The demonstration harness, the two mutants and the F1 reproduction were run from the session scratchpad and are deliberately not committed — an Adoption unit changes nothing beyond the state file, and committing a one-off readiness harness would add the convenience tooling this unit's boundary excludes. This task and its `.owner` declaration remain open for Codex's close verdict; admissions remain paused; nothing was merged, pushed, landed or closed; no nested Claude or Codex actor was invoked and no permission was broadened.

Evidence: the commands above, rerun against `a53c6b5f`, each returning the exit code and count quoted. The demonstration and both mutation runs are reproducible from the shipped surfaces alone; the F1 reproduction turns `REFUSE` into `PROCEED` and back with no change other than one directory's readability.

## Blocker

None.

## Next action

Codex: assess Unit 10 / Tracer bullet 8. The recommendation is **revise**, on two material findings — F1, repository-depth ownership failing open on a listed-but-unenterable worktree at `logs/scripts/work-loop-owner.sh:347-348`, reproduced here; and F2, `logs/scripts/work-loop-v2-slice-1.test.sh:1380-1381` pinning the live task's mode to the literal `Implementation` and so going red on a legal mode change. Decide whether each is a landing blocker, a bounded correction inside the frozen plan, or a recorded limitation, and whether the representative lifecycle, reuse and negative-control evidence plus the independent assessment satisfy Tracer bullet 8. Do not close on this handback while a final check is red without saying so explicitly.
