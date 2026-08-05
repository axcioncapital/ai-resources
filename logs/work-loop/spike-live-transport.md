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
how to run `dispatch.test.sh`, what every declared dispatcher exit code means, and what the spike,
the simulated harness, dry-run mode, and even one live run do not establish.

Source dispositions and constraints:

- Governing current decision: the operator named task `spike-live-transport`, fixed this state-file
  path, required this Work Loop turn, and prohibited Codex from running git. The state file's
  Objective and scope is authoritative current scope for the unit.
- Governing workflow: `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` and the invoked
  `work-loop-v2` skill govern the handoff, evidence, stopping, and commit responsibilities. Claude
  owns repository verification, implementation, evidence, and every commit.
- Verify-first repository reality, not governing intent: `dispatch.sh` and `dispatch.test.sh` are
  the sources for the README's command syntax, modes, exit codes, safety boundaries, and test
  claims. Describe only behavior those files support.
- Codex framing decision: repository implementation scope is the new README only, because that is
  the smallest observable unit and the state file expressly excludes changes to the spike code and
  adjacent system. Updating this state file and committing it is protocol work, not an expansion of
  implementation scope.
- Deliberately held outside this unit: changes to `dispatch.sh`, `dispatch.test.sh`, `ps-sampler.sh`,
  hooks, settings, workflows, plans, reports, production installation, and any claim that this README
  or the simulated harness itself proves live cross-product transport. This preserves the fixture's
  stated boundary; do not turn newly noticed improvements into this unit.

Check against the repository before writing:

1. Verify that
   `plans/work-loop-v2-v0.2/handoff-automation-spike/README.md` is absent by checking that exact path.
   If it exists, stop and hand back rather than overwrite an unexamined file.
2. In `dispatch.sh`, verify the public invocation, options, default values, run modes, success
   condition, declared exit-code set, and operational boundaries against the usage comments and
   argument/routing logic. Treat any mismatch between comments and behavior as a false premise and
   hand it back; do not silently choose one.
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

Stop and hand back without implementation if a checked premise is false, an accurate guide would
require changing an excluded file, the evidence cannot be produced, or the requested content would
need a claim stronger than the scripts support. Claude may challenge any false or stale premise;
do not improvise past it.

## Latest result

Inspected (2026-08-05):

- Claim (1): HOLDS — checked the exact path
  `plans/work-loop-v2-v0.2/handoff-automation-spike/README.md` with `ls`; no such file. The
  directory holds only `dispatch.sh`, `dispatch.test.sh`, `ps-sampler.sh` and `runs/`.
- Claim (2): FALSE — the declared exit-code *set* matches, but the declared *success condition* does
  not. See Blocker.
- Claim (3): HOLDS — `dispatch.test.sh` documents `bash dispatch.test.sh` and
  `DISPATCH_BIN=/path/to/dispatch.sh bash dispatch.test.sh` (lines 12–13) and honours `DISPATCH_BIN`
  at line 18. The simulated/live boundary is stated in the header (lines 4–6), enforced by every
  case running through `--actor-cmd`, proved falsifiable by Case 0 (points the suite at an absent
  dispatcher and asserts it fails), and restated in the final summary line. Ran it: exit 0,
  `pass=29 fail=0  (all cases SIMULATED — no live product transport)`.
- Claim (4): HOLDS as a constraint — searched `dispatch.sh` for everything a run records (`say`
  lines 163–167, 322, 358–359, 372, 380, 401 plus per-hop `$RUN_ID.hop$hop.$actor.out`). A run
  records: run id, mode, task, checkout, state path, hop/timeout settings, allowlist, and per hop
  the before/after sha256, `turn:`, HEAD, actor exit status, duration and transition verdict.
  Nothing recorded speaks to concurrency, repeat reliability, production installation or unattended
  operator-decision handling, so the README may not claim those.

Incidental confirmation of live transport: a `--dry-run` aimed at this task exited 17 (`another
dispatcher holds spike-live-transport`), i.e. this Claude process was itself launched by the live
dispatcher run holding the lock.

No repository change was made for this unit. `README.md` is still absent, nothing was staged before
this commit, and no file the brief named was modified.

## Blocker

Claim (2) is false on the success condition.

`dispatch.sh` line 31 states: `Exit codes — 0 is the ONLY success, and it means the loop reached
turn: operator.` Two code paths exit 0 without the loop reaching `turn: operator`:

- **`--dry-run`** (lines 324–329) — validates, reports the actor it *would* launch, launches
  nothing, exits 0. Observed in a throwaway sandbox: a state file at `turn: codex` produced
  `dry-run: would launch actor 'codex'` and `EXIT=0`, with the file still at `turn: codex`
  afterwards.
- **`-h|--help`** (line 89) — prints the usage block and exits 0. Observed: `HELP_EXIT=0`.

Why this stops the unit rather than being written around: the brief requires the README to state
what every declared exit code means and to describe only behaviour the scripts support. Exit 0 has
one meaning in live/simulated mode and a different one in `--dry-run` and `--help`, while the header
asserts a single meaning and marks it "ONLY". Documenting the header's version would be false for
two real paths; documenting the observed version would contradict the file's own stated contract.
Claim (2) instructs that a comment/behaviour mismatch is handed back rather than silently resolved,
so it is handed back.

The second horn matters for scope: if the comment is the intended contract and the code is what
diverges, the correction lands in `dispatch.sh` — which this unit's scope expressly excludes.

For completeness, the declared exit-code set itself is sound: every code in the header table
(0, 10–17, 20–24) is reachable in the body, and every `exit`/`die` in the body uses a declared code.
The mismatch is confined to what 0 *means*.

Noticed and deliberately not done (candidate deferrals, not part of this unit):

- The default `--allow-path` values (`^logs/work-loop/` and
  `^plans/work-loop-v2-v0\.2/handoff-automation-spike/`, lines 100–102) are not stated in the usage
  header, unlike the defaults for `--max-hops`, `--timeout`, `--codex-bin` and `--log-dir`. An
  omission, not a contradiction — but the README would otherwise be the first place it is written
  down.
- `die 15 "cannot launch actor"` (line 315) reuses the BAD_TURN code for a case the table describes
  as a bad `turn:` value; unreachable in practice, since `validate_state` already constrains the
  domain.

## Next action

Codex: decide how exit code 0 is to be documented, then reframe the unit.

Either (a) the observed behaviour is correct and the README documents 0 as success with its three
paths — loop reached `turn: operator`, `--dry-run` validated, `--help` — in which case say whether
the stale header line at `dispatch.sh:31` is left alone or recorded as a deferral; or (b) the header
is the intended contract, in which case the fix is in `dispatch.sh` and this unit's scope has to be
reopened by the operator before any work proceeds.
