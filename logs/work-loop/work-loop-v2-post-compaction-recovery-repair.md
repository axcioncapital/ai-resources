---
task: work-loop-v2-post-compaction-recovery-repair
status: active
turn: codex
---

## Objective and scope

Implement the post-compaction recovery repair plan, including operator-approved Amendment 1: preserve the Work Loop contract while preventing unnecessary immediate context refill after compaction, restore the `$realign` / `$reorient` boundary, make active-state result rollover reliable, and prove the repaired behavior.

Scope is Units 0–4 and the completion condition in `plans/work-loop-v2-v0.2/work-loop-v2-post-compaction-recovery-repair-implementation-plan-v0.1.md`. Preserve its exclusions: do not split the executable core; add no model default, hook, parser, state field, registry, cache, summary file, recovery daemon, universal state-size gate, provisional 12/16 KB launch policy, or unrelated optimization; do not change Work Loop roles, lifecycle, admission, courier permissions, or dispatcher exit codes.

## Lane and unit

Standard. Implementation mode. Unit 3 — make active-state rollover reliable.

Units 0–2 are accepted. Unit 2 repaired the recovery / realignment boundary at `e0b1944b`; Units 3–4 remain before the plan's completion condition can be met.

Named reason for the loop: the repair spans multiple bounded implementation and proof units, must survive hand-offs, and requires assessment independent of the implementer before it counts as complete.

## Brief

This unit proves and, only if the failing evidence requires it, repairs the active-state rollover behavior approved in plan §§ 3.4 and 4 Unit 3. It is next because recovery now reaches the correct task with bounded context, but that task is not yet reliable unless a normal hand-back replaces its preceding accepted result instead of preserving history.

Dominant deliverable: A normal Work Loop hand-back replaces the preceding accepted result in active state.
Evidence required in this hop: one fail-capable incident-shaped rollover control, this invocation's real state transition, final validator and field checks, and exact before/after `## Latest result` excerpts.
Evidence explicitly deferred: the representative post-compaction operating case and independent review in Unit 4.
Primary edit begins after: the targeted rollover assertion rejects a controlled mutant of a disposable valid active-state copy that retains both the preceding accepted result and a new result.

Required outcome: create the disposable control required by plan Unit 3, add the smallest durable regression protection to an existing test surface, make a command correction only if the evidence shows the current replacement instruction is insufficient, and use this Claude invocation itself as the required normal Work Loop hand-back. The final active state must contain the exact new-result marker named by plan Unit 3 only inside the replaced `## Latest result`, contain no occurrence of the preceding marker currently recorded there, validate successfully, and preserve a valid current brief, blocker and next action without adding a historical result block elsewhere.

Governing authority: the operator-approved plan content at `d72cf199`, operator-approved Amendment 1 at `a366c295` as factually corrected in the plan, plan §§ 3.4, 4 Unit 3, 7–9, the canonical executable core, and repository `AGENTS.md`. The task state is authoritative current position: Units 0–2 are accepted; Units 3–4 remain.

Claims to check against the live repository before editing:

1. `.claude/commands/work-loop-v2.md` Step 5 currently says that active state is current truth and instructs Claude to replace the previous result rather than append. Quote that exact before-state and treat it as the current candidate mechanism, not as proof the behavior works.
2. Search the existing Work Loop test scripts under `logs/scripts/work-loop-*.test.sh` for the two exact Unit 3 markers and for a rollover assertion that scopes both presence and absence to `## Latest result`. The prepared search found no marker-based rollover case; confirm that result and select only the smallest existing test surface that can host it.
3. This task validates as `ACTIVE_CLAUDE` before execution, and its `## Latest result` carries exactly one preceding-result marker. Establish the exact before excerpt and marker count before rewriting it.
4. A disposable state copy or inline fixture can demonstrate the assertion's fail capability without creating another state interface or retaining a fixture under `logs/work-loop/`. If this cannot be done within an existing harness and temporary local files, stop and hand back rather than adding a new harness or permanent task record.

Implementation requirements:

- Build a disposable valid active-state control with the exact old and new markers required by plan Unit 3. Demonstrate that the rollover assertion fails on the incident-shaped mutant where both remain and passes only when the latest-result section is replaced; remove the disposable state after proof.
- Scope marker assertions to the `## Latest result` body, not the whole file, so text in a brief or plan cannot satisfy them. The check must also reject a historical result block elsewhere in the active state.
- Add the smallest durable regression protection to one existing Work Loop test surface. Do not add a semantic parser, state field, global size rule, new harness, or stored task fixture.
- Treat the command's current replace instruction as sufficient unless the focused evidence or this real transition proves otherwise. If it is sufficient, leave the command unchanged and say so; if it is not, make only the smallest command-side correction the failing case supports.
- This invocation is the one normal Claude Work Loop hand-back required by the plan. Do not invoke Claude or Codex inside it. Replace this `## Latest result` completely with the current Unit 3 result and evidence, including the exact new-result marker from plan Unit 3, then set `turn: codex`, keep `status: active`, and write the assessment request under `## Next action`.
- After that write, assert on the actual task state: validator exit 0; `status: active`; `turn: codex`; new marker present in `## Latest result`; preceding marker absent from the whole state file; current brief, blocker and next action valid; and no second or historical result block. Run the focused test and the proportionate existing regressions named by the affected surface.
- Update plan § 8 to mark Unit 2 accepted and record Unit 3's exact failing control, real transition, validator result, before/after excerpts and regression evidence. Do not alter any approved acceptance condition, scope, sequence, settled decision or prior measurement.

Codex framing decision: edits are limited to the single smallest existing Work Loop test file that can host the rollover control; `.claude/commands/work-loop-v2.md` only if fail-capable evidence requires a behavior-producing correction; the governing plan's § 8 evidence/status maintenance; this state file; temporary disposable files removed before commit; and incidental repository telemetry written by existing hooks. Hold the core, Codex Work Loop skill and references, `$realign`, `$reorient`, hooks, validators, owner helpers, dispatcher, Unit 4 and unrelated cleanup outside this unit.

Capability subset: baseline only—read/search/history inspection, local tests, task-scoped edits, temporary disposable local files, and a local commit by Claude. Nothing is selected from the pre-authorizable set, which is empty today. No operator-reserved capability is needed. Do not push, merge, deploy, access credentials, destructively alter shared state, or invoke nested Claude/Codex actors.

Required evidence must be able to fail: retain the assertion's incident-shaped mutant result; show its clean replacement control; quote the actual task's before and after latest-result bodies; report scoped marker counts, heading counts, validator classification, frontmatter, current-field validity and absence of a historical result block; and show focused plus affected regression exits. A whole-file grep for the new marker is invalid because governing text may name it; section-scoped extraction is required.

Completion condition: every plan Unit 3 requirement is satisfied; the disposable control distinguishes append from replacement and leaves no task fixture behind; this real hand-back replaces rather than appends; the actual state validates as active/codex with the new marker only in its current result and the preceding marker nowhere; the current brief, blocker and next action remain valid; no historical result block exists; any command edit is strictly supported by the failing case; plan § 8 records the evidence and Unit 2 acceptance; task-scoped changes are committed once by Claude; and the state returns with `turn: codex` for assessment.

Stop and hand back if a claim above is false in a way that changes the outcome; the real transition cannot be proved without a nested actor; an existing harness cannot host a fail-capable control; a parser, new state field, new harness, persistent fixture, core change or excluded surface is required; the command needs a broader redesign; or the plan's acceptance conditions or authority relationships would change.

## Latest result

Inspected (2026-08-17):
- Claim (1): HOLDS — read `.claude/commands/work-loop-v2.md` Step 5; line 344 states verbatim "The state file is current truth, not a diary (core § 4): replace the previous result rather than appending to it." Treated as the candidate mechanism, not as proof.
- Claim (2): HOLDS — searched all nine `logs/scripts/work-loop-*.test.sh` for both plan Unit 3 markers; grep exit 1, no match in any file. No marker-based rollover case existed. Smallest hosting surface selected: `work-loop-v2-slice-1.test.sh`, which already carries the state-file field contract and a section-scoped `latest_of` reader at line 1528.
- Claim (3): HOLDS — validator printed `ACTIVE_CLAUDE`; the `## Latest result` body carried exactly one preceding-result marker (section-scoped count 1, whole-file count 1) and zero new-result markers.
- Claim (4): HOLDS — `work-loop-v2-slice-1.test.sh` already builds disposable controls under `mktemp -d` at lines 507 and 1854. No new harness or persistent fixture was needed.

Note on this record's own wording: both markers are named literally in the plan § 8 evidence and in the test file, and are referred to descriptively here, so that the new marker below is the only literal marker in active state and the preceding one does not survive anywhere in it.

Result: Unit 3 is implemented. A fail-capable rollover control was added to `work-loop-v2-slice-1.test.sh` and no command correction was made, because the evidence does not support one — Step 5's replace instruction is already present and this hand-back replaced the preceding result under it unchanged. Nine checks were added; the suite moved 396/0 to 405/0. Plan § 8 records Unit 2 ACCEPTED at `e0b1944b` and the full Unit 3 evidence. DISTINCTIVE-NEW-RESULT

Evidence: Four disposable valid active states in a temp dir — `clean` (result replaced) PASSES; `append` (the incident shape, both results in `## Latest result`) is REJECTED; `parked` (preceding result moved to a `## Previous results` block) is REJECTED; `stale` (result never rewritten, new marker present only in `## Objective and scope`) is REJECTED. `stale` proves the section scoping is load-bearing: a whole-file grep for the new marker returns 1 hit and would pass, the section-scoped read returns 0 and fails. An executed control shows why the protection must be behavioural — the incident-shaped `append` record classifies `ACTIVE_CODEX`, identical to `clean`; only `parked` is caught by the validator (`STOP [16] unsupported top-level heading`). The two Step 5 contract checks were proved fail-capable against a mutant command with the instruction line removed: PASS on the actual command, FAIL on the mutant. No control was retained under `logs/work-loop/`. This state file is the real transition: before, `## Latest result` held the Unit 2 acceptance plus one preceding-result marker; after, it holds only this result, the new marker appears once and only here, the preceding marker is absent from the whole file, the validator returns `ACTIVE_CODEX` exit 0, the six active headings are unchanged and no historical result block exists. Suites: Slice 1 405/0 exit 0; state, owner and capability exit 0. Tracer 7 exits 0 at 163/0 on five of seven runs and intermittently 162/1 — see the deferral below.

Deferral (noticed mid-unit, not implemented): Tracer 7's S9 check "the partial effect is visible on disk during the hop" is intermittently red — observed 162/1 on two of seven runs, 163/0 on the other five. It is a pre-existing race inside Tracer 7's own sandbox and not caused by this unit: the sentinel writes its marker file (`work-loop-v2-tracer-7.test.sh:276`) before it writes `partial-effect.txt` (line 293), while the test releases from `wait_for_file "$S9MARK" 45` on the marker alone and checks for the partial effect immediately, so under load the check loses the race. The fix would be to wait on the partial effect rather than the marker. Not done here because Tracer 7 is Unit 2's surface and this unit's framing holds the dispatcher, courier and their harness outside its scope; changing S9's synchronisation would be an unbriefed edit to an accepted unit's evidence surface. This unit's own changed files do not participate in S9, which runs entirely against a temporary sandbox checkout.

## Blocker

None.

## Next action

Codex: assess Unit 3 — make active-state rollover reliable. Judge whether the rollover control is genuinely fail-capable and correctly scoped, whether leaving `.claude/commands/work-loop-v2.md` unchanged is the right reading of plan § 3.4's "smallest correction supported by the failing case", and whether this hand-back satisfies the real-transition requirement. Then close, continue to Unit 4, correct once, or stop.
