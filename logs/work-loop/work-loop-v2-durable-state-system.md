---
task: work-loop-v2-durable-state-system
status: active
turn: codex
---

## Objective and scope

Implement the frozen Work Loop v2 durable-state plan sequentially until the accepted state system is demonstrated end to end and ready for the operator's landing decision.

Scope is the capabilities, migration order, eight tracer bullets, assessment gates, and completion proof in `plans/work-loop-v2-v0.2/work-loop-v2-durable-state-system-implementation-plan-v0.1.md`. The plan's explicit exclusions remain excluded; repository evidence may challenge a factual premise or expose a safety contradiction, but may not silently redesign the accepted architecture.

## Lane and unit

Standard. Implementation mode. Unit 9 — Tracer bullet 7: prove checkout binding, migration, and live concurrency.

Named reason for the loop: this is the next ordered slice of the frozen multi-unit migration; it must combine the explicit-status/task-only-owner system with the already accepted shared-lease work and independently assess the resulting ownership, migration, and concurrency proof before final end-to-end demonstration.

## Brief

Unit 8 / Tracer bullet 6 is accepted after its one correction: all nine deterministic lifecycle and recovery scenarios now pass, including fail-closed ownership for a complete but uncommitted closing reduction. Tracer bullet 7 is next because the frozen plan now requires the combined checkout-binding, explicit-migration, and live-actor-exclusion outcomes before final cutover readiness can be demonstrated.

**Required outcome:** Produce one coherent, fail-capable operational proof of all nine ownership, migration, and concurrency scenarios assigned to Tracer bullet 7. Import the accepted Phase 1 evidence where its seam remains applicable after the durable-state cutover, and narrowly refresh only evidence whose seam materially changed.

**Governing authority and source disposition:**

- The frozen implementation plan governs: Fixed decisions 2, 3, 6–11, and 13–15; Capabilities B, D, and E; Tracer bullet 7; its Proof Matrix assignments; and Execution and Assessment Rules.
- The closed Phase 1 record `logs/work-loop/work-loop-v2-cross-transport-concurrency-phase-1.md` is authoritative implementation evidence for the accepted shared-lease controller and its live case 23, including its recorded operator decision and limitations. It does not by itself prove applicability after the explicit-status/task-only-owner cutover; verify that against the current seams.
- The current executable core, validator, owner helper, Reorient, attended carrier, unattended dispatcher, and shared lease helper govern their own runtime contracts. Reuse them; add no fallback lifecycle parser, duplicate lease helper, second state store, automatic ambiguity resolver, or general test framework.
- Admissions remain paused. Tracer bullet 8, final independent assessment, closure of this implementation task, merge, push, landing, and production adoption are adjacent work deliberately held outside this unit because the frozen plan assigns them later.

**Verify first against the repository:**

1. Reconfirm the exact checkout/task, HEAD `83745c35`, `ACTIVE_CLAUDE`, unique repository-depth ownership, complete readiness, and free shared leases. Stop on ambiguity, a competing actor, or a different HEAD.
2. Establish the exact integrated Phase 1 commits and live evidence from `logs/work-loop/work-loop-v2-cross-transport-concurrency-phase-1.md`, the shared refusal record it names if still present, `logs/scripts/work-loop-lease.sh` and its test, and the current carrier/dispatcher implementations and tests. For each imported claim, state why the durable-state cutover did or did not change the covered seam; do not rerun accepted live evidence merely to obtain a new count.
3. Bound the current combined-proof inventory to `logs/scripts/work-loop-state.sh`, `logs/scripts/work-loop-owner.sh`, `.agents/skills/reorient/SKILL.md`, `.claude/commands/work-loop-v2.md`, the shared lease helper, both couriers and their existing tests, the Tracer 6 harness, and any existing migration fixtures directly cited by those surfaces. For each Tracer 7 scenario, identify the existing evidence and the precise composing/live gap. Any absence claim must name this searched surface and pattern.
4. Verify whether each required live observation can be produced through existing top-level transport or non-model fixture seams without launching Claude or Codex from inside the current Claude hop. Nested model invocation is unsupported and prohibited; if a required outcome genuinely needs operator-coordinated top-level actors or another capability not available in this unit, return the exact gap rather than simulating or weakening the scenario.

**Scenarios required by the frozen plan:**

1. Stale owner: committed `CLOSED` clears; missing, malformed, active, blocked, and complete-but-uncommitted closed targets do not.
2. Two concurrent worktrees with different tasks proceed, while non-owner replicas refuse.
3. Multiple owner claims and multiple unowned open copies both fail closed.
4. Two actors attempt the same task and exactly one task lease succeeds.
5. Attended/unattended collision contends through the same task and checkout leases.
6. Explicit task migration ends with exactly one owner; an injected interruption leaves visible fail-closed ambiguity.
7. A bounded fresh-session live recovery reconstructs the same status, turn, latest result, blocker, and next action.
8. A bounded live compaction/Reorient recovery proves that empty or misleading conversational state cannot override durable state and returns the same validator classification.
9. A bounded cross-courier live proof preserves state and partial-effect evidence.

Each scenario must carry a negative control or deliberately injected failure that distinguishes the accepted outcome from the wrong one. Imported Phase 1 evidence may satisfy a scenario only when the current seam is unchanged and that applicability is itself shown; otherwise run the narrow affected proof.

**Implementation boundary:** Add only the smallest existing-style composing proof or failpoint needed for gaps that remain after import. Temporary repositories/worktrees and bounded live local processes are permitted by the frozen plan. Do not create one framework per scenario, invoke nested models, broaden actor permissions, implement Phase 2 worktree automation, permit concurrent writing of one task, add automatic ambiguity resolution or cleanup, or run a soak test. Leave hook-written `logs/friction-log.md` and `logs/innovation-registry.md` uncommitted and outside the commit.

**Required evidence:**

- Give an exact scenario-by-scenario report: real seam, imported/new evidence, applicability argument, setup or failpoint, negative control, observed classifications/exits/lease or owner state, and verdict.
- For scenarios 2–5 and 9, identify the simultaneous processes/transports and show the decisive task and checkout lease observations, actor-launch result, preserved state, and partial-effect evidence. A sequential approximation is not a live concurrency proof.
- For scenario 6, show the owner set before, during the injected interruption, and after successful migration, including the fail-closed ambiguous state and final unique owner.
- For scenarios 7 and 8, show field-level equality for status, turn, latest result, blocker, and next action plus validator classification; distinguish durable observations from conversational/model claims.
- Report which Phase 1 cases were imported without rerun, which seams required narrow refresh, and why. Report exact focused-proof and directly affected regression counts/exits, the implementation commit, and exact changed paths.
- Demonstrate that Tracer 8, Phase 2, excluded machinery, runtime redesign unrelated to a revealed defect, friction log, and innovation registry did not enter the commit, and that the handback validates `ACTIVE_CODEX`.

**Completion condition:** Commit the bounded Tracer 7 proof and return all nine scenario verdicts with applicable Phase 1 evidence accounted for, `status: active`, and `turn: codex`. State whether a runtime defect or unsupported live-proof gap was exposed; confirm admissions remain paused, nothing was merged, pushed, or landed, and Tracer bullet 8 has not started.

**Stop conditions:** Stop and hand back exact evidence if a load-bearing premise is false; an imported Phase 1 claim is no longer applicable; a required scenario lacks a real seam, simultaneous observation, or fail-capable discriminator; a live result would require nested model invocation or unavailable operator coordination; producing the proof requires an excluded mechanism, operator-reserved capability, runtime redesign outside this unit, or broader scope; or any expected outcome is red.

Capability subset: baseline only — read and inspect repository state/history, run local tests and bounded local processes, create temporary repositories/worktrees, edit task-scoped proof/test surfaces, and make the local coherent commit. Nothing is selected from the pre-authorizable set, which is empty today. No operator-reserved capability is needed; if the live proof requires one, stop rather than assume it.

## Latest result

Inspected (2026-08-16):

- Claim (1): HOLDS — checkout `ai-resources-durable-state` on `session/2026-08-14-durable-state`; `git rev-parse HEAD` is `83745c35`, the briefed value; `work-loop-state.sh validate` prints `ACTIVE_CLAUDE`; `work-loop-owner.sh check --depth repo` prints `PROCEED` with this checkout the sole declarant and `logs/work-loop/.owner` holding exactly `work-loop-v2-durable-state-system`; `work-loop-capability.sh check` prints `READY` on all five components; the shared lease root `…/ai-resources/.git/work-loop-dispatch-locks/` holds no `task-*.lock` or `checkout-*.lock`, so both leases are free. No competing actor: `git worktree list` shows 17 registered checkouts, none declaring this task.
- Claim (2): HOLDS — `git merge-base --is-ancestor f3b4e1b1 HEAD` succeeds, so Phase 1 is integrated. `git diff f3b4e1b1..HEAD -- logs/scripts/work-loop-lease.sh logs/scripts/work-loop-lease.test.sh` is empty: the shared lease seam is byte-identical to its state at Phase 1 closure, so its controller cases and the live case-23 lease behaviour import unchanged. The durable refusal record Phase 1 names is still present at `…/.git/work-loop-dispatch-locks/refusals/20260815T154142-30771-cross-transport-concurrency-correction.refusal` and its two lines match the record's quotation exactly, including `actor_launched=no`. The cutover **did** change the transports: `git diff f3b4e1b1..HEAD` shows `dispatch.sh` +244 and `carry-turn.sh` +120, both now reading lifecycle through `logs/scripts/work-loop-state.sh` (`STATE_BIN_REL` at dispatch.sh 1870, carry-turn.sh 475) instead of parsing `turn:`. So the *live cross-transport observation* sits on changed code and was re-taken; the lease library underneath it was not.
- Claim (3): HOLDS — every named inventory surface exists and was read: `logs/scripts/work-loop-state.sh`, `work-loop-owner.sh`, `work-loop-lease.sh`, `.agents/skills/reorient/SKILL.md` (route 2 at lines 53–72), `.claude/commands/work-loop-v2.md`, `scripts/axcion-harness-v0.2/carry-turn.sh` + `.test.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` + `.test.sh`, and `logs/scripts/work-loop-v2-tracer-6.test.sh`. Absence claim, with its searched surface and pattern: `grep -n "migrate" logs/scripts/work-loop-owner.sh` returns no match and the helper's own usage line names only `{check|claim|clear}` — there is **no migration verb**, so scenario 6 is proven through the frozen plan's explicit sequence (clear at the source, claim at the target) rather than through a command that does not exist. `grep -rn "tracer-7" logs/scripts/` returned nothing before this unit, so no Tracer 7 proof surface existed.
- Claim (4): HOLDS, and no capability gap was found — every required live observation is producible without nested model invocation. The dispatcher accepts `--claude-bin` / `--codex-bin` (dispatch.sh usage block) and the carrier accepts the same two while **refusing** `--actor-cmd` outright (carry-turn.sh 360–361), so both transports run as real top-level programs with a sentinel binary in the actor's place — the seam `carry-turn.test.sh` already uses at lines 585 onward. Both take their leases and run ownership admission *before* any actor launch, so the contention under test happens entirely inside the real transport process. `.codex/hooks/work-loop-reorient.sh` is an ordinary executable fed JSON on stdin, so the compaction seam is live too. No operator-coordinated top-level actor and no operator-reserved capability was needed.

Result: Tracer bullet 7 is proven. One new file, `logs/scripts/work-loop-v2-tracer-7.test.sh` (942 lines), executes all nine scenarios against real seams and returns **106 passed, 0 failed, exit 0**, stable across two consecutive runs. Scenarios 2, 4, 5 and 9 are genuinely simultaneous, not sequential: each rendezvouses its processes on a gate file and asserts the decisive observation while the other side is proven still running (`kill -0` on the live carrier pid, and the lease directory present on disk at the moment of refusal). Scenario 5 re-takes the Phase 1 case-23 observation under the durable-state contract — a real `carry-turn.sh` holding both leases while a real `dispatch.sh` is refused at exit 17 before any actor launch, naming the attended holder, writing a durable refusal record carrying `actor_launched=no` and `holder_program=carry` under the sandbox lease root, and creating nothing inside the checkout. Scenario 6 shows the owner set before (one declaration), at both injected cut points (zero declarations with two replicas → `AMBIGUOUS` exit 4 from both sides; two declarations → `AMBIGUOUS` naming the double claim), and after (exactly one, in the target, with the source refusing and naming it). Scenarios 7 and 8 compare all five fields plus the validator classification, read by an `env -i` process with an empty environment and by a real dispatcher hop.

Scenario by scenario — seam, evidence source, discriminator, observation, verdict:

| # | Real seam | Evidence | Negative control / failpoint | Observed | Verdict |
|---|---|---|---|---|---|
| 1 | `work-loop-owner.sh check/claim --depth repo` + validator, six fixtures | new | the committed-`CLOSED` row must PROCEED while five others refuse | `PROCEED` (0) for committed closed and `claim` really replaces the declaration; `REFUSE` for missing record, active, blocked and uncommitted-closed; `AMBIGUOUS` (4) for a malformed declaration, which survives `clear` | PASS |
| 2 | owner helper at repo depth over three **real linked worktrees**, two checks run through one gate file | new | the declared owner must still PROCEED on the same task while a replica exists | both simultaneous checks `PROCEED` and both entered the gate; an undeclared worktree holding a replica `REFUSE`s naming the owning checkout; a beta-leased checkout `REFUSE`s naming beta | PASS |
| 3 | owner helper at repo depth, two worktrees | new | one declaration must be `PROCEED`/`REFUSE`, never `AMBIGUOUS` | two claims → `AMBIGUOUS` (4) from both sides; two unowned copies → `AMBIGUOUS` naming replication; `claim` refuses to resolve it and writes nothing | PASS |
| 4 | shipped `work-loop-lease.sh` sourced unmodified by two **real concurrent processes** on one gate | new (library imported unchanged) | after release a third run must acquire the same lease | exactly one `rc=0`, loser `rc=2` naming `resource=task`, lease directory present on disk during the refusal, third run `rc=0` | PASS |
| 5 | **real `carry-turn.sh` and real `dispatch.sh`** as top-level programs, one task, one checkout | narrow refresh of Phase 1 case 23 | with the leases free the same dispatcher invocation must not exit 17, and the sentinel must be shown able to launch and write its marker | carrier live (`kill -0`) with both leases held; dispatcher exit **17**, refusal names an attended holder, no sentinel marker, checkout byte-identical before/after, durable refusal record with `actor_launched=no` and `holder_program=carry`; carrier then exits 0 and the turn moves to `ACTIVE_CODEX`; control run not 17 and marker written | PASS |
| 6 | owner helper `clear`/`claim` across two real worktrees, per the frozen migration sequence | new | the completed migration must be unique, and a foreign `clear` must not remove the target's declaration | before `src=s6-task dst=(none)`; cut point A `src=(none) dst=(none)` → `AMBIGUOUS` (4) both sides; cut point B two declarations → `AMBIGUOUS` naming the double claim; after `src=(none) dst=s6-task`, target `PROCEED`, source `REFUSE` naming the target; foreign `clear` leaves the target's declaration intact | PASS |
| 7 | `env -i` fresh process running Reorient route 2 + **real dispatcher hop** handing the state path to its actor | new | change the committed record and the same reader must return the changed value | all five fields equal the committed record, `classification=ACTIVE_CLAUDE` equals the validator; the actor saw `status: active` and the committed latest result; after the edit the reader returns `NA-CHANGED` and the two reads differ | PASS |
| 8 | **real `.codex/hooks/work-loop-reorient.sh`** fed a misleading compacted summary + a real dispatcher hop whose actor claims closure on stdout | new | an actor that really writes must move the classification | hook exits 0, emits the real checkout, names no task id and repeats no lifecycle claim from the summary, and says not to continue from it; the durable route returns the validator's classification and the durable task, not the ghost; the misleading actor ran and changed nothing; the writing actor did change it | PASS |
| 9 | **real carrier** whose actor writes a partial effect then fails, **real dispatcher** contending mid-hop | new | with the leases free the same dispatcher invocation must not exit 17 | partial effect visible on disk mid-hop; dispatcher exit **17**, no actor, working tree unchanged by the loser; carrier exits non-zero; partial file and uncommitted state edit both survive; record still `ACTIVE_CLAUDE` with a non-empty working diff; task lease released; control not 17 | PASS |

Implementation commit `c650d2a1`, exactly two paths: `logs/scripts/work-loop-v2-tracer-7.test.sh` (new, 942 lines, mode 100755) and `logs/work-loop/work-loop-v2-durable-state-system.md`. No runtime file, no Tracer 8 surface, no Phase 2 file, no excluded machinery, and neither hook-written log entered it — `git show --stat` lists those two paths and nothing else, and `git status` still shows `logs/friction-log.md` and `logs/innovation-registry.md` modified and uncommitted.

Evidence: `bash logs/scripts/work-loop-v2-tracer-7.test.sh` → exit 0, 106/0, twice. Failing-first control: the harness's `WL_OWNER_BIN` override — the same device the shared lease suite's `WL_LEASE_LIB=` uses — pointed at the pre-correction helper extracted from `96ff6786^` gives **exit 1, 104 passed, 2 failed**, and the two failures are exactly S1's complete-but-uncommitted-closure row. Every other assertion passes against the older build, so that row is the only thing separating the two helpers. A second, suite-level falsifiability case (C0) substitutes a rubber-stamp owner helper, shows it approves the fixture S1 refuses, and shows the shipped helper refusing the identical fixture. Directly affected regressions, all exit 0: owner **122/0**, state **100/0**, lease **136/0**, carrier **457/0**, dispatcher **639/0**, Tracer 6 **74/0**, capability **77/0**, slice 1 **308/0**, session preflight **60/0**, core resolver **4/0**. `bash -n` on the new harness exits 0.

Imported without rerun: Phase 1's shared-lease controller cases 3, 4, 12, 16 and 22, and the stale-reclaim repair — the lease library is byte-identical since `f3b4e1b1`, so their seam is unchanged and re-running them would add a count and no evidence. Narrowly refreshed because the seam did change: the live cross-transport contention (Phase 1 case 23), because both transports were rewritten onto the validator after that closure. Not re-attempted, and still open: Phase 1 live case 24, the fan-out-two pair, which the operator decided on 2026-08-15 to skip on time grounds; Tracer 7 scenario 2 proves two concurrent worktrees with different tasks at the ownership seam, which is not the same claim, and nothing here treats it as a substitute.

No runtime defect was exposed and no unsupported live-proof gap was found. The one red result during development was a harness fault, not a product fault: the first S2 draft asserted that a replica's refusal names the owning checkout, while the helper — correctly, by design — runs the checkout half first and so refused for checkout occupancy instead. The harness now proves both refusals separately, each against the reason that actually produced it. No runtime file was changed.

New deferral from this unit: when a task's state file is replicated into a checkout that is already leased by a different task, the refusal names the occupying task and not the checkout where the replicated task actually lives. The behaviour is right and fails closed; only the operator-facing message is less helpful than it could be. Not fixed here because it is a message change in a production helper inside a proof unit that authorized no runtime file.

Carried forward from Unit 8, unchanged: explicit `work-loop-owner.sh clear --task {holder}` still does not test whether the closing record is committed. Nothing in Tracer 7 made that necessary — scenario 6's migration uses `clear` at the source deliberately and under the operator's own sequence, not as automatic recovery.

Admissions remain paused. Nothing was merged, pushed, or landed. Tracer bullet 8 has not started. `logs/friction-log.md` and `logs/innovation-registry.md` were left modified in the working tree and outside the commit.

## Blocker

None.

## Next action

Codex: assess Unit 9 / Tracer bullet 7. The exit condition to judge is whether every accepted ownership, migration and concurrency outcome is observed at a real seam with a fail-capable discriminator, and whether the Phase 1 import/refresh split is argued rather than assumed — specifically, whether the byte-identical lease library justifies importing its controller cases while the validator cutover justifies re-taking the live cross-transport observation. Then decide close, continue to Tracer bullet 8, or correct once.
