---
task: spike-live-transport
turn: codex
---

## Objective and scope

**This is a Work Loop v2 spike fixture, not a genuine backlog task.** It exists to carry one real
Codex → Claude → Codex sequence through the handoff dispatcher under
`plans/work-loop-v2-v0.2/handoff-automation-spike/`, so that live product transport can be observed
rather than assumed. A later reader should not treat it as evidence of demand for the work below.

The work itself is real and small: write `plans/work-loop-v2-v0.2/handoff-automation-spike/README.md`
so the spike explains itself — what it is, how to run `dispatch.sh` and `dispatch.test.sh`, what the
exit codes mean, and what it deliberately does not prove.

Scope: that one file. Excluded: `dispatch.sh` and `dispatch.test.sh` themselves, anything outside
`plans/work-loop-v2-v0.2/handoff-automation-spike/`, any hook or settings file, the executable core,
the proposal, the investigation report, and any production installation.

## Lane and unit

Standard. Unit 1 — write the spike README.

Named reason for the loop: the unit is being run to prove that two products can carry a turn between
them without operator transport, which requires the sequence itself to be assessed by the other
model rather than accepted from the builder. The state file must therefore survive between two
separate non-interactive processes.

## Brief

This fixture exists to obtain one real Codex → Claude → Codex transport observation, and the
README is the smallest real scoped output that makes the spike intelligible to a later operator.
It is due now because Unit 1 is open and the directly named spike directory currently presents only
the implementation artifacts. No content-bound approved project plan is identified in the task
material; the operator's instruction to take this exact task and the state-file scope govern this
unit, without granting broader authority to adjacent planning material.

Required outcome: create
`plans/work-loop-v2-v0.2/handoff-automation-spike/README.md` as a concise operator-facing guide that
accurately explains the spike's purpose, how to invoke `dispatch.sh` for a named checkout and task,
how to run `dispatch.test.sh`, what every declared dispatcher exit code means in each applicable
mode, and what the spike, the simulated harness, dry-run mode, and even one live run do not
establish. For exit `0`, distinguish successful command completion from the narrower live/simulated
loop outcome: `--help` and a valid `--dry-run` also return `0`, while a completed loop-mode run
returns `0` only after reaching `turn: operator`.

Source dispositions and constraints:

- Governing current decision: the operator named task `spike-live-transport`, fixed this state-file
  path, required this Work Loop turn, and prohibited Codex from running git. The state file's
  Objective and scope is authoritative current scope for the unit.
- Governing workflow: `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` and the invoked
  `work-loop-v2` skill govern the handoff, evidence, stopping, and commit responsibilities. Claude
  owns repository verification, implementation, evidence, and every commit.
- Verified repository reality returned by Claude, not governing intent: `dispatch.sh` line 31's
  single meaning for exit `0` conflicts with the observed `--help` and `--dry-run` paths, which also
  return `0` without reaching `turn: operator`. The README must describe the mode-specific observed
  behavior and identify the narrower line-31 statement as a source inconsistency, not silently
  present either side as the universal contract. Re-check the relevant paths before writing; stop
  if they no longer produce the returned result.
- Verify-first repository reality, not governing intent: `dispatch.sh` and `dispatch.test.sh` are
  otherwise the sources for the README's command syntax, modes, exit codes, safety boundaries, and
  test claims. Describe only behavior those files support.
- Codex framing decision: repository implementation scope is the new README only, because that is
  the smallest observable unit and the state file expressly excludes changes to the spike code and
  adjacent system. Updating this state file and committing it is protocol work, not an expansion of
  implementation scope.
- Deliberately held outside this unit: changes to `dispatch.sh`, `dispatch.test.sh`, `ps-sampler.sh`,
  hooks, settings, workflows, plans, reports, production installation, and any claim that this README
  or the simulated harness itself proves live cross-product transport. This preserves the fixture's
  stated boundary; do not turn newly noticed improvements into this unit. In particular, correcting
  the stale or overbroad exit-`0` header in `dispatch.sh` is deferred because that file is explicitly
  excluded; the README must surface the inconsistency so the deferral does not make the guide false.

Check against the repository before writing:

1. Verify that
   `plans/work-loop-v2-v0.2/handoff-automation-spike/README.md` is absent by checking that exact path.
   If it exists, stop and hand back rather than overwrite an unexamined file.
2. In `dispatch.sh`, verify the public invocation, options, default values, run modes, declared
   exit-code set, and operational boundaries against the usage comments and argument/routing logic.
   Reproduce or otherwise directly verify that `--help`, a valid `--dry-run`, and a loop-mode run
   reaching `turn: operator` return `0`, while only the loop-mode path establishes that final turn.
   The already surfaced line-31 mismatch is no longer a stop condition; any different material
   mismatch is a false premise and must be handed back rather than silently resolved.
3. In `dispatch.test.sh`, verify the documented test invocation and the explicit boundary between
   simulated controller evidence and live product transport, using the file's setup, case labels,
   and final result semantics.
4. Verify any statement about what a live run proves against the dispatcher evidence it actually
   records. Label inference as inference; do not present one successful run as proof of production
   readiness, concurrency safety, general reliability, or unattended operator-decision handling.

Required evidence must be capable of failing:

- Show the exact-path absence check from before creation and a post-change read-back demonstrating
  that the README contains all required content categories.
- Run an automated comparison that fails if the README omits or invents a numeric exit code relative
  to the dispatcher-declared exit-code table, and report the compared sets.
- Run the README's non-live verification commands, including `bash dispatch.test.sh`, and report
  their exit status and final pass/fail summary. Do not claim this simulated result as live transport.
- Report the repository paths changed and the commit identifier so scope and commit ownership are
  auditable.

Completion condition: the README is accurate against both scripts, the falsifiable checks pass,
only the README plus this state-file protocol update are changed for the unit, Claude has committed
the work, and the state file returns with the latest result and evidence summarized under
`## Latest result`, `turn: codex`, and one assessment action under `## Next action`.

Stop and hand back without implementation if a checked premise other than the explicitly accepted
line-31 inconsistency is false, an accurate guide would require changing an excluded file, the
evidence cannot be produced, or the requested content would need a claim stronger than the scripts
support. Claude may challenge any false or stale premise; do not improvise past it.

## Latest result

Inspected (2026-08-05):

- Claim (1): HOLDS — checked the exact path
  `plans/work-loop-v2-v0.2/handoff-automation-spike/README.md` with `ls` before creating anything;
  `No such file or directory`, exit 1. The directory held only `dispatch.sh`, `dispatch.test.sh`,
  `ps-sampler.sh` and `runs/`. Nothing was overwritten.
- Claim (2): HOLDS as reframed. Re-ran all three exit-`0` paths rather than recalling them.
  `bash dispatch.sh --help` → 0. A valid `--dry-run` in a throwaway sandbox checkout → 0, with the
  state file left byte-identical (`git status --porcelain` empty for it); a `--dry-run` against a
  `turn: operator` file also → 0 and says automation is terminal there. A simulated loop-mode run
  that reached `turn: operator` → 0. Falsifiable control: a loop-mode run that never reached
  `turn: operator` returned **24**, not 0 — the simulated actor's `git add -A` swept the run-log
  directory outside the allowlist and the dispatcher stopped on it. (I had predicted 23; the run
  stopped earlier, on a different guard. Either way non-zero, which is what the control tests.)
  The declared exit-code set (`0 10 11 12 13 14 15 16 17 20 21 22 23 24 25`) matches the routing
  logic. Options, defaults, modes, transitions, lock and allowlist all check out against the source.
- Claim (3): HOLDS — `dispatch.test.sh` documents `bash dispatch.test.sh` and
  `DISPATCH_BIN=/path/to/dispatch.sh bash dispatch.test.sh` (lines 12–13) and honours `DISPATCH_BIN`
  at line 18. The simulated/live boundary is stated in the header (lines 4–6), enforced by every
  case running through `--actor-cmd`, proved falsifiable by Case 0 (points the suite at an absent
  dispatcher and asserts it fails), and restated in the final summary line. Re-ran it: exit 0,
  `pass=33 fail=0  (all cases SIMULATED — no live product transport)`. The count moved 29 → 33
  because cases 13 and 13b were added since the previous inspection.
- Claim (4): HOLDS as a constraint — re-grepped `dispatch.sh` for everything a run records (`say`
  at lines 167–171, 300, 311–312, 322, 326, 338, 345, 352–353, 363, 385–386, 399, 407, 432, plus
  per-hop `$RUN_ID.hop$hop.$actor.out` at line 296). A run records: run id, mode, task, checkout,
  state path, hop/timeout settings, allowlist, and per hop the before/after sha256, `turn:`, HEAD,
  actor exit status, duration and transition verdict. Nothing recorded speaks to concurrency,
  repeat reliability, production installation or unattended operator-decision handling, so the
  README does not claim those.

**One newly found defect, handled as a deferral rather than a hand-back — flagging the judgment
for assessment.** `--help` prints the header with `sed -n '2,45p'` (line 93), so its output stops
at line 45. It therefore omits exit code `25` (line 46) *and* the lines 48–49 note that qualifies
exit `0`. Verified: the codes visible in `--help` output are `0 10 11 12 13 14 15 16 17 20 21 22
23 24` — one short of the source's declared set. This is a second instance of exactly the class the
brief already accepted for line 31: a stale documentation surface inside `dispatch.sh`, which this
unit is forbidden to change. I surfaced it in the README instead of silently resolving it, and
generated the README's exit-code table from the source header rather than from `--help`. If Codex
judges this a "different material mismatch" under the brief's stop clause, this unit is the thing
to reject.

Result: `plans/work-loop-v2-v0.2/handoff-automation-spike/README.md` created (185 lines) and
committed. It covers the spike's purpose, `dispatch.sh` invocation with every option and default,
the three run modes, the live launch commands, a worked example, all 15 declared exit codes with
the modes each can be returned in, the exit-`0` mode distinction, the allowed turn transitions,
`dispatch.test.sh` invocation and summary semantics, the safety boundaries, and a "what this does
not establish" section. Both `dispatch.sh` source inconsistencies are surfaced in the README and
marked as deferred fixes to an excluded file.

Evidence:

- **Absence before, content after.** Pre-creation `ls` on the exact path returned `No such file or
  directory` (exit 1). Post-change the checker below reads the committed file back and matches 13
  required content categories.
- **Exit-code comparison, capable of failing.** A checker (kept in the session scratchpad, outside
  the repo, so the unit's scope stays the one README file) extracts the declared set from
  `dispatch.sh` lines 31–49 and the documented set from the README table and requires equality.
  Failing case built first: run against a mutated copy of the README with code `25` deleted, a fake
  code `99` inserted and one required sentence removed → `RESULT: FAIL`, rc=1, reporting
  `omitted by README : 25` and `invented by README: 99`. Run against the real README → `RESULT:
  PASS`, rc=0, with both sets printed identical:
  `0 10 11 12 13 14 15 16 17 20 21 22 23 24 25`.
- **Non-live verification commands from the README, actually run.** `bash dispatch.test.sh` → exit
  0, `pass=33 fail=0  (all cases SIMULATED — no live product transport)`. `bash dispatch.sh --help`
  → exit 0. This is simulated controller evidence only and is **not** a live-transport result.
- **Paths changed and commit ownership.** One repository file changed for the unit:
  `plans/work-loop-v2-v0.2/handoff-automation-spike/README.md`, in commit
  `6de0bd2d574ab817e149022eb0b8cb4f0206f45c`. This state file is committed separately as protocol
  work. Nothing was staged before either commit. `dispatch.sh`, `dispatch.test.sh`, `ps-sampler.sh`
  and `logs/friction-log.md` were already modified or untracked in the working tree before this
  unit began and were **not** touched, staged or committed by it.

## Blocker

None.

## Next action

Codex: assess Unit 1. Two things need a verdict beyond the ordinary closure check — (a) whether
routing the newly found `--help` truncation into a README disclosure plus a deferral was right, or
whether it should have stopped the unit as a different material mismatch under the brief's stop
clause; and (b) whether the two deferred `dispatch.sh` fixes (line 31's overbroad exit-`0`
sentence, and widening the `--help` sed window past line 45) should be carried as a follow-up unit
or left to the operator. Then close, correct once, or stop.
