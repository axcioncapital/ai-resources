---
task: work-loop-v2-dispatcher-reliable-supervised-use
status: active
turn: codex
---

## Objective and scope

Implement `plans/work-loop-v2-v0.2/work-loop-v2-dispatcher-reliable-supervised-use-implementation-plan-v0.1.md` through its complete Gate SA acceptance contract and independent adoption review, while preserving the plan's fixed supervised-use boundary.

Scope: the existing Work Loop v2 supervised dispatcher, its accepted helpers and runtime surfaces, focused proof, live trials, and the synchronous regression gate named by the plan. Excluded throughout: Gate ST, Gate U, unattended or walk-away release claims, dispatcher rewrite or language migration, merge, push, deployment, destructive cleanup, and every other exclusion in plan §§ 4 and 7.

Task exit condition: one integrated candidate has passed Gate SA and the independent review has returned `ADOPT`, or Patrik has explicitly chosen `SHRINK` or `STOP`.

## Lane and unit

Standard. Implementation mode. Unit 6 — validate the v1 terminal-result structure.

Named reason for the loop: the objective spans multiple bounded implementation and proof units, must survive session boundaries, and requires independent Codex assessment before it can count as complete.

## Brief

Change set A remains the active plan phase. Unit 5 is accepted across `ae2bc22bdfc66bff8e7b43a429e2ac3027cf6bdf`, `4053e3204abb511341045cd7d925d5cd35181082`, and `ede08a4102fab5f6c0562544baa04c8f48f050b7`: the existing D–L `die()` funnel now writes one atomic dispatcher-owned v1 terminal result, and the final closure check accepted the unavailable-holder correction without reopening the frozen findings. Build only the standalone structural validator for that exact v1 artifact now; first-consumer integration and dispatcher progression remain later units.

Dominant deliverable: one bounded read-only structural validator for the existing `work-loop-v2-dispatcher-terminal-result` version 1 artifact.
Evidence required in this hop: a targeted red/green case proves one real Unit-5-produced v1 result is accepted while a duplicate singleton field is rejected with a bounded machine-readable reason; focused negative controls prove the same validator rejects an unknown version and an incomplete or non-final record.
Evidence explicitly deferred: semantic cross-field validation; run/task/checkout/path identity matching; integration into a dispatcher transition, status, wait loop, or any other first consumer; finite producer-consumer waiting; missing-result blocking; fake run-bound result consumption; terminal families A–C, M, and N; moving run identity earlier; durable crash-boundary injection and the full write-order/recovery contract; the wider hostile identifier/path/encoding matrix; Change sets B–D; the full dispatcher and Gate SA regression matrices; live trials; adoption review; adjacent routing defects; merge, push, deployment, and destructive cleanup.
Primary edit begins after: add and run one focused case that presents the current real v1 producer output plus a copy carrying a duplicate `outcome=` singleton to the intended validator surface, and quote the red showing that no production validator exists yet or the duplicate is not rejected.

Required outcome: the dispatcher has one production validator that reads a named result artifact without executing or sourcing its content and returns an unambiguous accept/reject outcome with one bounded reason token. At this unit's structural boundary it must enforce a finite artifact bound, the exact recognized version and schema, the complete required v1 singleton-key set, one occurrence of each singleton, the bounded `key=value` line grammar, and the final `result_complete=yes` sentinel. It must reject rather than normalize or partially accept an unknown version, duplicate or missing singleton, malformed line, premature/missing completion sentinel, or artifact outside its declared size/line/value bounds.

This is a producer dependency, not yet a consumer: do not make a valid result advance the loop, do not wait for a result, do not choose a result path from actor prose or a directory scan, and do not infer semantic truth merely because the structure validates. The validator must remain read-only with respect to the artifact, canonical task state, Git, ownership, leases, logs, captures, and runtime evidence.

Governing authority and settled evidence:

- The content-bound-approved implementation plan governs, specifically Change set A required behavior items 2, 5–7, the trusted-field-ownership and hostile-input boundaries, and § 8's one-production-owner rule. Gate SA and all fixed exclusions remain unchanged.
- Unit 5's producer and its field names are accepted evidence. Do not redesign the schema or rerun Unit 5's producer, ownership, or lease proof before the primary edit; use the real producer fixture already present in case 50 as the valid control.
- The Work Loop packaging rule requires the shared validator and its first consumer to be separate dominant deliverables. This unit therefore ends with an independently proved validator that no dispatcher route consumes yet.
- Codex's framing decision: semantic value and path-identity validation are held back because combining structure, meaning, and first-consumer integration would exceed one focused evidence set. The split preserves the plan's full acceptance contract; it does not narrow it.

Check against the repository before editing:

1. Verify `finalize_terminal_result()` still produces only schema `work-loop-v2-dispatcher-terminal-result`, version `1`, with a fixed singleton field set and `result_complete=yes` last; if Unit 5's accepted bytes changed, hand back rather than designing against memory.
2. Search `dispatch.sh` for any existing production result reader or validator. The current verified surface contains the producer and test-only `res_field()` reads but no production validator; if a production owner already exists, hand back with the exact overlap rather than creating a second parser.
3. Verify the structural validator can remain inside `dispatch.sh` and be exercised through the focused test without adding a second source/test path or a CLI/status/transition consumer. If that premise is false, hand back with the narrow-helper evidence under plan § 8 instead of silently expanding the unit.

Required fail-capable evidence:

- quote the targeted red before the primary edit and the focused green after it;
- show the unchanged real producer result is accepted, so the validator is compatible with the artifact Unit 5 actually writes rather than a hand-built happy-path sample alone;
- show separate rejections and bounded reason tokens for duplicate singleton, unknown version, and incomplete/non-final artifact;
- include one mutation or negative control that would fail if the validator accepted the duplicate or merely grepped for the expected version/sentinel;
- show the validator neither sources/evals input nor mutates the artifact or any dispatcher control surface;
- report the pre-unit and handback commits and exact committed paths; and
- prove only `dispatch.sh`, `dispatch.test.sh`, and this task state changed. `logs/friction-log.md` remains outside the unit and must stay untouched and uncommitted.

Capability subset: baseline only — read/search the approved plan and accepted Unit 5 producer, inspect local history only where a seam claim requires it, edit only `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, and this task state, run focused local checks, and make the local handback commit. The baseline deny set is required in full. Nothing is selected from the pre-authorizable set, which is empty today. No operator-reserved capability is needed.

Completion condition: one local commit implements the standalone v1 structural validator, the focused fail-capable proof is green, no dispatcher consumer or deferred semantic/path/result-wait behavior is integrated, no broad regression matrix is run, only the three permitted paths change, and the task hands back with `turn: codex`.

Stop and hand back without widening if an existing production parser owns the seam, Unit 5's live schema premise is false, structural validation cannot be isolated from semantic/consumer integration, a narrow helper or third implementation/test path is materially required, or any deferred terminal family, result consumer, plan change, or extra repository path becomes necessary. Challenge a false premise rather than building around it.

## Latest result

Inspected (2026-08-17):

- Claim (1): HOLDS — read `dispatch.sh:623-744`; `finalize_terminal_result()` still emits `terminal_result_version=$TERMINAL_RESULT_VERSION` (constant `1` at `dispatch.sh:454`) first, `schema=work-loop-v2-dispatcher-terminal-result` second, and `result_complete=yes` last, through single-line `tr_kv`/`tr_kv_or` writes into a `.partial` renamed with `mv -f`. A real run's artifact confirmed the live set is 41 singleton keys; Unit 5's accepted bytes are unchanged.
- Claim (2): HOLDS — searched `dispatch.sh` for `\.result`, `RESULT_FILE`, and every `^[a-z_]+\(\)` name matching `result|valid|parse|read`; the only matches are the producer, its `result_outcome`/`result_next_action`/`result_permission_mode_requested`/`result_lease_status` writers, and `validate_state()` (the task-state reader, not a result reader). No production result parser existed, so no second owner was created.
- Claim (3): HOLDS — searched `dispatch.test.sh` for `source`/`.` against `$DISPATCH_BIN`; the harness runs the dispatcher only as a subprocess, and `dispatch.sh:776-800` parses arguments and `exit`s at load, so it cannot be sourced. The validator therefore ships inside `dispatch.sh` between two comment markers and the focused case lifts that exact region into the sandbox and sources it. No repository source or test path was added, and no CLI, status or transition route reaches the function.

Result: `dispatch.sh` now carries `validate_terminal_result()` (with `TERMINAL_RESULT_SCHEMA`, the 41-key `TERMINAL_RESULT_REQUIRED` set, and byte/line/value bounds), placed beside the producer it reads. It returns `0` plus `ok`, or `1` plus exactly one bounded token — `unreadable`, `too-large`, `too-many-lines`, `malformed-line`, `value-too-long`, `bad-version-line`, `unknown-version`, `unknown-schema`, `unknown-field`, `duplicate-field`, `empty`, `incomplete`, `missing-field`. It rejects whole and never normalizes or partially accepts. No dispatcher route consumes it: nothing waits for a result, chooses a path from one, or reads meaning out of a passing verdict. Semantic and identity validation stay deferred as briefed, and the reader is read-only toward the artifact, task state, Git, ownership, leases, logs and captures.

Evidence — focused case 51 (added to `dispatch.test.sh`, run as a spliced preamble+case runner so no broad matrix executed), against pre-unit commit `ede08a4102fab5f6c0562544baa04c8f48f050b7`:

- Red before the primary edit: `pass=4 fail=21`. Headline failure `51a — a marker-delimited validator region exists in the dispatcher / no region between the markers in .../dispatch.sh — there is no production validator to exercise`, and the briefed duplicate case returned `expected '1 duplicate-field', got '127 '` — no such function.
- Green after: `pass=27 fail=0`.
- The valid control is a real run's output, not a hand-built sample: case 51a drives the dispatcher to its 22 terminal and validates the artifact `finalize_terminal_result()` actually wrote — accepted `0 ok`, unchanged.
- Anti-drift control: the validator's declared required set is compared against the keys the real run emitted, not against a list the harness restates; the two are identical (41 keys).
- Separate bounded rejections proved individually: `duplicate-field` (two `outcome=` lines), `unknown-version` (`=2`), `bad-version-line` (version present but not first), `unknown-schema`, `missing-field`, `malformed-line` (non-pair line, and a key outside the charset), `unknown-field`, `incomplete` (truncated record, sentinel present but not last, and `result_complete=no`), `too-large`, `value-too-long`, `empty`, `unreadable`.
- Mutation controls, both fail-capable: M9 deletes the duplicate-detection line from `dispatch.sh` and the same duplicate artifact is then accepted `0 ok`; M10 deletes the sentinel-is-last line and the reordered non-final record is then accepted `0 ok` — which is precisely what a grep for `result_complete=yes` would have shipped. Each control first asserts its `sed` changed the dispatcher, so a control that matched nothing fails rather than passing silently.
- Read-only proved against the whole sandbox checkout with `tree_manifest` before and after two validations — identical, so no artifact, state file, lease, ownership declaration, log or capture moved. No-execution proved twice: the validator's executable text (whole-line comments stripped) contains no `eval`, `source`, dot-source or backtick, and a planted `next_action=$(touch …)` value left its canary uncreated.
- Affected regression block: case 50, the producer this validator reads, `pass=102 fail=0` — unchanged from Unit 5's accepted figure.
- Committed paths: `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, and this state file. `git status` confirms `logs/friction-log.md` carries only its pre-existing modification, untouched by this unit and left uncommitted.

One framing decision worth Codex's eye: the brief's reject list did not name an unrecognized extra key, and the validator rejects it as `unknown-field`. The reasoning is that the version is exact and the required set complete, so a key this version does not define is a partial acceptance rather than a harmless extra — and it strengthens the hostile-input boundary against an actor-planted lookalike. If Codex reads that as widening, it is one line to remove.

Candidate deferral noticed and not implemented: the validator resolves its path with `[ -f ]`, which follows a symlink, so a symlink planted at the result path would be read through. That is path identity, which the brief explicitly defers to the consumer unit, so it is recorded here rather than built. The earlier accepted deferrals are unchanged: semantic cross-field validation; run/task/checkout/path identity; first-consumer integration, result waiting, missing/fake-result behavior; terminal families A–C, M, N; earlier run identity; durable crash-order and recovery; the wider hostile identifier/path/encoding matrix; Change sets B–D; full regressions, live trials and adoption review. The two Unit 5 candidate deferrals also stand: requested permission mode is still reconstructed from the launch shape pending Change set B, and `changed_paths_since_launch` is a loose field name at `stage=launch`.

## Blocker

None.

## Next action

Codex: assess Unit 6. The three briefed claims held and are recorded above; the standalone v1 structural validator is implemented, proved red-to-green with two mutation controls, and consumed by no dispatcher route. Judge whether it is good enough to move on, and rule on the one framing decision (rejecting an unrecognized extra key as `unknown-field`) and the one new candidate deferral (symlink resolution at the result path, held for the identity-owning consumer unit).
