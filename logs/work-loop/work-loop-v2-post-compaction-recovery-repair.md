---
task: work-loop-v2-post-compaction-recovery-repair
status: active
turn: codex
---

## Objective and scope

Implement the post-compaction recovery repair plan, including operator-approved Amendment 1: preserve the Work Loop contract while preventing unnecessary immediate context refill after compaction, restore the `$realign` / `$reorient` boundary, make active-state result rollover reliable, and prove the repaired behavior.

Scope is Units 0–4 and the completion condition in `plans/work-loop-v2-v0.2/work-loop-v2-post-compaction-recovery-repair-implementation-plan-v0.1.md`. Preserve its exclusions: do not split the executable core; add no model default, hook, parser, state field, registry, cache, summary file, recovery daemon, universal state-size gate, provisional 12/16 KB launch policy, or unrelated optimization; do not change Work Loop roles, lifecycle, admission, courier permissions, or dispatcher exit codes.

## Lane and unit

Standard. Implementation mode. Unit 4a — make Tracer 7 S9 deterministic.

Plan Units 0–3 are accepted. Unit 3 proved reliable active-state rollover at `fe61527c`. Plan Unit 4 remains open; this bounded prerequisite removes a known intermittent regression before the representative live proof and independent review.

Named reason for the loop: the repair spans multiple bounded implementation and proof units, must survive hand-offs, and requires assessment independent of the implementer before it counts as complete.

## Brief

This prerequisite is required because plan § 9 cannot complete while an existing Work Loop regression is intermittently red, and the known race would contaminate Unit 4's live proof. It is packaged separately from that proof under the Work Loop's sizing rule: deterministic S9 synchronization is one deliverable; operator-assisted recovery evidence and independent review remain later Unit 4 work.

Dominant deliverable: Tracer 7 scenario S9 releases only when the partial effect it immediately asserts is observable.
Evidence required in this hop: one deterministic pre-fix race reproduction, the focused post-fix S9 result, and one green full Tracer 7 run with every non-S9 scenario preserved.
Evidence explicitly deferred: Unit 4's operator-assisted post-compaction case, repository-read budget comparison, independent `code-review`, and the final full regression matrix.
Primary edit begins after: a controlled delay between S9's actor marker write and partial-effect write makes the current marker-based release fail deterministically.

Required outcome: remove the S9 synchronization race in `logs/scripts/work-loop-v2-tracer-7.test.sh` without changing the behavior being proved, the sentinel's production-like ordering, courier/dispatcher code, or another scenario. Preserve the assertion that the actor launched, but ensure the mid-hop partial-effect assertion is reached only once that effect is actually observable; record fail-capable red/green evidence, update the governing evidence record, and commit once.

Governing authority: the operator-approved plan content at `d72cf199`, operator-approved Amendment 1 at `a366c295` as factually corrected in the plan, plan §§ 4 Unit 4, 5–9, the canonical executable core, and repository `AGENTS.md`. The task state is authoritative current position: Units 0–3 are accepted; Unit 4 and the plan completion condition remain open.

Codex framing disclosure: `Unit 4a` is execution packaging inside approved Unit 4, not a plan amendment or a sixth plan unit. It changes no objective, scope, exclusion, acceptance condition, authority relationship, or order among plan Units 0–4; it separates a newly evidenced prerequisite repair from the live proof so two dominant deliverables are not placed in one hop.

Claims to check against the live repository before editing:

1. In `make_sentinel` inside `logs/scripts/work-loop-v2-tracer-7.test.sh`, the sentinel writes its launch marker before the `partial:*` branch writes `partial-effect.txt`. Confirm the exact ordering and whether any intervening operation can expose the marker first.
2. In scenario S9, the current gate waits for `S9MARK` and then immediately tests for `partial-effect.txt`. Confirm that this is the only release-to-assertion path and that the actor-launch assertion can remain valid when the gate is corrected.
3. Unit 3's recorded evidence reports the same S9 assertion at 162/1 on two of seven full runs and 163/0 on five, while Unit 3 changed only Slice 1, the plan and task state. Confirm from the test surface that the race is independent of the rollover change; do not re-investigate unrelated history.
4. The existing Tracer 7 harness can host a temporary controlled timing gap that forces the current release condition red and the corrected release condition green, without retaining a fixture or changing courier/dispatcher behavior. If not, stop and hand back rather than substituting repeated probabilistic runs for a failing case.

Implementation requirements:

- Construct the deterministic control in a temporary copy or existing temporary sandbox: widen the interval after the actor marker exists but before `partial-effect.txt` exists. Show the current marker-based S9 gate reaches the assertion too early and fails.
- Apply the smallest synchronization correction supported by that control. The requirement is behavioral—wait for the evidence S9 is about to assert—not a mandated line edit; preserve the independent marker evidence that proves the actor launched.
- Show the same controlled timing gap passes after the correction, with the carrier still live at contention, the losing courier still refused, the partial effect still surviving the failed hop, and every existing S9 assertion retained.
- Run one full Tracer 7 suite after the focused green. Report its exit and pass/fail count. Do not use repeated lucky green runs as the primary evidence, and defer the broader regression matrix to the final Unit 4 proof/review boundary.
- Update plan § 8 to mark Unit 3 accepted at `fe61527c`, preserve its recorded intermittent honestly, and add a concise Unit 4 prerequisite evidence entry or adjacent note for this repair. Do not alter approved conditions, earlier measurements, or Unit 4's required live proof and review.

Codex framing decision: edits are limited to the S9 synchronization and directly necessary deterministic-control lines in `logs/scripts/work-loop-v2-tracer-7.test.sh`, plan § 8 evidence/status maintenance, this state file, temporary disposable files removed before commit, and incidental telemetry written by existing hooks. Hold the sentinel action ordering, attended carrier, dispatcher, other scenarios, all Work Loop skills and commands, core, hooks, validators, owner helpers, Unit 4 live fixture, review findings and unrelated cleanup outside this hop.

Capability subset: baseline only—read/search/history inspection, local tests, task-scoped edits, temporary disposable local files, and a local commit by Claude. Nothing is selected from the pre-authorizable set, which is empty today. No operator-reserved capability is needed. Do not push, merge, deploy, access credentials, destructively alter shared state, or invoke nested Claude/Codex actors.

Required evidence must be able to fail: quote the exact pre-fix ordering and release condition; show the controlled timing gap red before and green after; demonstrate the control would still fail if the gate were changed back to the marker; report focused S9 preservation and one full Tracer 7 exit/count; and confirm no temporary fixture remains. A sequence of ordinary reruns is diagnostic only and cannot replace the deterministic control.

Completion condition: the race is deterministically reproduced and removed; S9 waits on the partial effect it immediately asserts while separately preserving actor-launch evidence; no S9 assertion or scenario is weakened or removed; the focused control and full Tracer 7 suite are green; plan § 8 records Unit 3 acceptance and this repair; no disposable fixture remains; task-scoped changes are committed once by Claude; and this state returns with `status: active` and `turn: codex` for assessment.

Stop and hand back if a claim above is false in a way that changes the outcome; the failure is not a synchronization race; a fix requires changing the sentinel's action semantics, courier, dispatcher, another scenario, timeout policy, or an excluded surface; deterministic evidence cannot be produced; or the plan's acceptance conditions or authority relationships would change.

## Latest result

Inspected (2026-08-17):
- Claim (1): HOLDS — read `make_sentinel` in `logs/scripts/work-loop-v2-tracer-7.test.sh`. The launch marker is appended at line 276, unconditionally and before the `case` dispatch; `partial-effect.txt` is written at line 293 inside the `partial:*` branch. Between them the sentinel runs four command substitutions (the action-file read at 277, the three-deep `dirname` chain and `basename` at 278–279) and a function definition. Nothing can expose the effect before the marker, and that intervening work is the race window.
- Claim (2): HOLDS — searched scenario S9. `wait_for_file "$S9MARK" 45` at line 1178 is the only release-to-assertion path; the partial-effect test sat at line 1183, three lines later. The actor-launch assertion at 1179 reads the marker alone, so it stays valid when the gate is corrected — the marker is independent evidence that the actor launched.
- Claim (3): HOLDS — S9 runs entirely against a `new_base` sandbox under `mktemp`, which copies only the state, owner and lease helpers and creates an empty `logs/work-loop`. Grepping the harness for `slice-1` and for the task id returns no reference. None of Unit 3's three changed files is read by S9, so the race is independent of the rollover change. No unrelated history was re-investigated.
- Claim (4): HOLDS — the seam was reproduced outside the repository using the harness's own `wait_for_file` and `alive` copied verbatim, with no fixture retained and no courier or dispatcher behaviour touched.

Result: Unit 4a is implemented. The S9 release condition in `logs/scripts/work-loop-v2-tracer-7.test.sh` now waits for the partial effect it is about to assert, instead of releasing on the earlier launch marker. Nothing else changed: the sentinel's action ordering, the carrier, the dispatcher and every other scenario are untouched, and the assertion count is identical before and after, so no S9 assertion was weakened or removed.

Evidence: The deterministic control widened the marker-to-effect interval to a controlled 3s, giving each run an isolated directory and reaping each actor. The current marker-based gate failed 3 of 3 runs; the corrected gate passed 3 of 3. That isolation is load-bearing and is reported as part of the control: an earlier revision shared one directory, and a previous run's still-sleeping actor rewrote the effect, producing 1 red of 3 — luck rather than ordering. After the edit the full suite exits 0 at 163/0 with all thirteen S9 assertions green and all nine scenarios PASS; 163 is the same count the pre-fix green runs produced. The sequence that had reproduced the flake — `work-loop-owner.test.sh` immediately followed by Tracer 7, which returned 162/1 — now returns 163/0 on both of two consecutive runs. The corrected gate remains falsifiable, and that is proved rather than asserted: with an actor that launches but never writes the partial effect, the gate ends FAIL while the carrier is still live, so a real regression is caught and not waited out. The 8s bound sits inside the actor's 9s post-write hold, keeping "during the hop" the property under test. Plan § 8 records Unit 3 ACCEPTED at `fe61527c` with its intermittent preserved as recorded, plus this prerequisite's evidence. No disposable fixture remains in the repository.

## Blocker

None.

## Next action

Codex: assess Unit 4a — make Tracer 7 S9 deterministic. Judge whether the deterministic control genuinely discriminates the release condition rather than the run, whether waiting on the asserted evidence preserves the "during the hop" property the scenario exists to prove, and whether the repair stayed inside the synchronization seam. Then close, continue to Unit 4, correct once, or stop.
