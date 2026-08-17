---
task: work-loop-v2-post-compaction-recovery-repair
status: active
turn: codex
---

## Objective and scope

Implement the post-compaction recovery repair plan, including operator-approved Amendment 1: preserve the Work Loop contract while preventing unnecessary immediate context refill after compaction, restore the `$realign` / `$reorient` boundary, make active-state result rollover reliable, and prove the repaired behavior.

Scope is Units 0–4 and the completion condition in `plans/work-loop-v2-v0.2/work-loop-v2-post-compaction-recovery-repair-implementation-plan-v0.1.md`. Preserve its exclusions: do not split the executable core; add no model default, hook, parser, state field, registry, cache, summary file, recovery daemon, universal state-size gate, provisional 12/16 KB launch policy, or unrelated optimization; do not change Work Loop roles, lifecycle, admission, courier permissions, or dispatcher exit codes.

## Lane and unit

Standard. Implementation mode. Unit 2 — repair the recovery / realignment boundary.

Units 0 and 1 are accepted. Unit 0 restored the lost Work Loop behavior at `072438b3`; its green Slice 1 evidence also fulfilled Unit 1's unchanged outstanding acceptance condition for the split implemented at `66688592`.

Named reason for the loop: the repair spans multiple bounded implementation and proof units, must survive hand-offs, and requires assessment independent of the implementer before it counts as complete.

## Brief

This unit restores the boundary approved in plan §§ 3.2, 3.3 and 4 Unit 2: degraded or uncertain context belongs to `$reorient` before `$realign` performs any judgment. It is next because Units 0 and 1 have restored and progressively disclosed the Work Loop contract that both skills must now follow; active-state rollover and representative live proof remain later units.

Dominant deliverable: `$realign` delegates degraded-context recovery before judgment, and `$reorient` performs the approved bounded recovery cascade.
Evidence required in this hop: targeted red/green branch-order, no-verdict, no-state-edit, exact-task, no-hook and refusal checks; green Tracer 7; and preserved `REORIENTED` output and actor-correct `Next:` contract.
Evidence explicitly deferred: active-state result rollover (Unit 3) and representative live proof plus independent review (Unit 4).
Primary edit begins after: focused Unit 2 assertions fail against the current `$realign` / `$reorient` instructions, including the current `$realign` order that reads Work Loop authority before testing uncertain task or checkout identity.

Required outcome: implement the exact recovery and realignment behavior in plan §§ 3.2–3.3, extend the existing Tracer 7 recovery scenario with the deterministic controls named in plan Unit 2, preserve healthy-context `$realign` behavior and the existing `$reorient` output shape, record fail-capable evidence in plan § 8, and commit the unit once.

Governing authority: the operator-approved plan content at `d72cf199`, operator-approved Amendment 1 at `a366c295` as factually corrected in the plan, plan §§ 3.2, 3.3, 4 Unit 2, 7–9, the canonical executable core, and repository `AGENTS.md`. The task state is authoritative current position: Units 0 and 1 are accepted; Units 2–4 remain.

Claims to check against the live repository before editing:

1. `.agents/skills/realign/SKILL.md` currently runs `pwd`, loads the complete Work Loop skill and resolves its core before its uncertain-identity branch invokes `$reorient`; quote the exact before-state and show that the new focused branch-order check detects this wrong order.
2. `.agents/skills/reorient/SKILL.md` currently loads Work Loop authority before resolving the exact task and describes a broader plan-read cascade than plan § 3.2; identify the exact clauses that must change, including the direct `references/core-resolution.md` read and task-first targeted-plan sequence.
3. Scenario 8 in `logs/scripts/work-loop-v2-tracer-7.test.sh` already exercises the real compaction hook, a misleading compacted summary, and durable classification. Inspect the complete scenario and adjacent helpers to establish which required Unit 2 controls are absent before extending it; do not duplicate coverage it already supplies.
4. The existing harness can provide fail-capable instruction and route evidence without invoking nested Claude or Codex actors. If any required claim can only be demonstrated by nested model execution or by a check that passes whatever happened, stop and hand back rather than substituting ceremonial evidence.

Implementation requirements:

- In `$realign`, place a compaction/context-degradation/uncertain task-or-checkout branch before Work Loop authority loading. That branch invokes `$reorient` immediately, emits none of the four realignment verdicts, edits no task state, reconstructs no decision at risk, and ends the realignment pass whether recovery succeeds or fails.
- Preserve healthy-context `$realign`: it still loads Work Loop authority before judging a live proposed move and retains its existing four verdicts and compact output contract. Add no hook, automatic trigger, persistent store, or verdict.
- In `$reorient`, encode plan § 3.2's bounded sequence: `pwd` alone; exact preserved task or strictly validated `.owner`; complete lean Work Loop skill; `references/core-resolution.md`, its exact resolver, and the complete printed core; exact task; governing plan authority/header plus the exact task-named sections; justified widening within that plan only when needed and recorded; directly named remaining sources only; stop when the seven recovery facts and actor-correct next move are established.
- Preserve the current seven-field `REORIENTED` shape, read-only behavior, validator refusal behavior, blocked/closed stopping rules, and actor-correct `Next:` contract. Do not require the routing index for an established task, batch large reads, forbid a genuinely necessary full-plan read, or treat compacted memory as authority.
- Extend Tracer 7's existing recovery scenario rather than creating a new harness. Cover the exact preserved task among multiple open task files, a misleading compacted summary, durable facts hidden in the task and its named plan section, explicit `$reorient` with no hook, and validator-refusal plus blocked-task controls that stop instead of resuming. Keep the test focused on the approved behavior; do not build a general skill interpreter or invoke an AI actor.
- Update only plan § 8's Unit 0/Unit 1 acceptance labels or adjacent status prose needed to reflect this assessment, and fill Unit 2's evidence entry with the resulting red/green proof. Do not alter any acceptance condition, scope, sequence, settled decision, or prior measured evidence.

Codex framing decision: edits are limited to `.agents/skills/reorient/SKILL.md`, `.agents/skills/realign/SKILL.md`, the recovery assertions and directly needed fixture/helper lines in `logs/scripts/work-loop-v2-tracer-7.test.sh`, the governing plan's § 8 evidence/status maintenance, this state file, and incidental repository telemetry written by existing hooks. Hold the executable core, Work Loop skill and references, Claude command, compaction hook, dispatcher, state validator, owner helper, Units 3–4, and every unrelated optimization outside this unit.

Capability subset: baseline only—read/search/history inspection, local tests, task-scoped edits, and a local commit by Claude. Nothing is selected from the pre-authorizable set, which is empty today. No operator-reserved capability is needed. Do not push, merge, deploy, access credentials, destructively alter shared state, or invoke nested Claude/Codex actors.

Required evidence must be able to fail: show the focused assertions red against the unchanged pre-edit skills and green after; demonstrate that wrong branch order, an emitted realignment verdict, a state mutation, summary-selected identity, absent explicit recovery, and resume-on-refusal/blocked fixtures are each rejected; run the full existing Tracer 7 suite to exit 0; show the state fixture is byte-identical across the `$realign` recovery branch; and show the `REORIENTED` shape and `Next:` checks remain green. Phrase-presence alone is insufficient unless paired with a wrong-order or negative fixture that the same check rejects.

Completion condition: every plan Unit 2 requirement is implemented; the focused checks are red before and green after; existing Tracer 7 remains green; `$realign` recovery changes no task state and produces no realignment verdict; `$reorient` preserves its output and actor-correct hand-off; plan § 8 records the evidence and accepted prior units accurately; task-scoped changes are committed once by Claude; and this state file returns with `status: active` and `turn: codex` for assessment.

Stop and hand back if a claim above is false in a way that changes the required outcome; a required control needs a new harness, hook, parser, state field, core change, nested AI actor, or excluded surface; healthy-context `$realign` cannot be preserved; the output/Next contract must change; the plan's acceptance conditions or authority relationships would change; or fail-capable evidence cannot be produced.

## Latest result

Inspected (2026-08-17) — the brief's four claims, checked before any edit:

- Claim (1): HOLDS — read `.agents/skills/realign/SKILL.md` § *1. Pause the proposed move*. It ran `pwd`, then "Read the complete `work-loop-v2` skill … follow its current executable-core resolution" at line 31, and only reached "If that identity or checkout binding is uncertain, stop this pass and invoke `$reorient`" at line 39. Authority was loaded eight lines before uncertain identity was tested. The new branch-order check is a line-position predicate and was red against that exact before-state.
- Claim (2): HOLDS — read `.agents/skills/reorient/SKILL.md`. Step 1 read the complete Work Loop skill and followed "its executable-core resolver" (line 18) before Step 2 resolved the task (line 35); searched the whole file for `references/core-resolution.md`, no match, so the post-split resolver reference was never named. Step 3's cascade item 3 read "The governing approved project plan or specification named by that state" — the whole document, against plan § 3.2's authority/header-plus-named-sections with recorded widening. No routing-index bound, no batching bound, no full-read allowance.
- Claim (3): HOLDS — read scenario 8 of `logs/scripts/work-loop-v2-tracer-7.test.sh` end to end plus its helpers (`new_base`, `open_record`, `closed_record`, `classify`, `declare_owner`, and scenario 7's `s7.route`). It already executes the real SessionStart compaction hook against a misleading summary, proves the hook launders no ghost task id or lifecycle claim, and re-derives the durable classification, with a control proving a real write does move it. Absent, and therefore added: multiple open task files, hidden durable facts in a task-named plan section, a hook-absent control, and blocked/validator-refusal stop controls.
- Claim (4): HOLDS — the harness proves instruction properties by reading the skills as artifacts and route behaviour by executing a literal cascade script in an `env -i` process, exactly as `s7.route` already does. No nested Claude or Codex actor was invoked; the only actors in the file remain the existing sentinel binaries passed through the transports' own `--claude-bin` / `--codex-bin` seam.

Result: `$realign` now tests degraded context before it loads any Work Loop authority and hands straight to `$reorient`, emitting no verdict, editing no task state and ending the pass; `$reorient` now resolves the exact task first, then names `references/core-resolution.md` and its resolver, reads the plan's authority header plus only the sections the task names, records any widening, and carries the routing-index, no-batching and full-read-allowed bounds from plan § 3.2. Tracer 7's scenario 8 gained the instruction contract and the five named route controls. Healthy-context `$realign` behaviour, its four verdicts, `$reorient`'s seven `REORIENTED` fields, both `Next:` contracts and `$reorient`'s read-only posture are unchanged and asserted as preserved. No hook, trigger, parser, state field or new harness was added.

Evidence: `work-loop-v2-tracer-7.test.sh` went from exit 1 — 148 passed / 14 failed, the 14 being the entire instruction contract — to exit 0, 162 passed / 0 failed. The two branch-order checks are line-position predicates, each paired with a wrong-order fixture built by exchanging the two anchor lines, so both phrases are present and only the sequence is wrong; the same predicate rejects it. Each clause check is paired with the pre-edit artifact at HEAD, where the clause is genuinely absent, and a clause green in both states is reported as a failure. The five route controls ran: among three open task files the route returned `s8-real-task` and named neither decoy; it recovered `NA-s8-real-task` and `DURABLE-FACT-S8` from the task-named plan section plus the plan's authority header while `DECOY-FACT-S8` never came back; the checkout carried no compaction hook, so recovery was explicit; a `BLOCKED_OPERATOR` task stopped at `STOP:5` and a validator-refused record at `STOP:4`, both exiting non-zero rather than resuming. The task state was byte-identical across the recovery pass by SHA-256, with a control proving the comparison notices a real write. Full regression, all exit 0: Tracer 7 162/0, Tracer 6 74/0, Slice 1 396/0, core-resolver 5/0, state 100/0, owner 133/0, lease 136/0, capability 81/0, session-preflight 60/0.

Two predicate defects were found and fixed in the harness during the red phase, both mine and neither in the artifacts: the phrase checks were line-based while the prose legitimately wraps, and seven patterns beginning with `-` were being read by `grep` as options. Both were corrected before the edit, which is why the recorded red baseline is 14 rather than the 15 and 21 the intermediate runs showed.

## Blocker

None.

## Next action

Codex: assess Unit 2 — the recovery / realignment boundary, the wrong-order and pre-edit controls behind the instruction contract, the five executed route controls, the preserved output contracts, and plan § 8's Unit 2 entry with the Unit 0 and Unit 1 acceptance labels.
