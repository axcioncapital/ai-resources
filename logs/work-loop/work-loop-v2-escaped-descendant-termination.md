---
task: work-loop-v2-escaped-descendant-termination
turn: codex
---

## Objective and scope
Make the dispatcher's stop result truthful: whenever the current dispatcher deliberately stops an
active actor, the actor's full descendant tree is no longer running before the dispatcher releases
its lock and exits. This includes descendants that leave the actor's process group through
`setsid(2)`, a new process group, a double fork, or an equivalent escape.

The bounded implementation surface is the handoff-dispatcher spike source and tests, the spike
README, the current unattended-operation plan, this state file, and new reproducible Phase 1a
evidence under the spike's existing `runs/` tree. A narrowly necessary helper inside the spike is
allowed if Claude's inspected mechanism needs one. Existing historical evidence remains historical.

Excluded: Phase 1 item 1f; branch or worktree isolation work; every Phase 2 action or walk-away run;
new supervisor, task-selection, notification, deployment or production-graduation machinery; Work
Loop core, skill or rule changes; the closed 1d state file; and unrelated cleanup or improvements.

## Lane and unit
Standard. Implementation mode. Unit 1 — implement and prove full-descendant termination across every
controlled actor-stop path in the current dispatcher.

Named reason for the loop: this is a safety-critical process-control change whose scope needs a hard
boundary and whose evidence must be assessed independently from the implementation before 1a can
count as complete.

## Brief
Phase 0 is complete, and the current project record says only 1a and 1f still block the first
walk-away pilot. This unit addresses 1a only because a stop that leaves an escaped process running is
not a truthful stop; even if this unit succeeds, Phase 2 remains forbidden until 1f is separately
proved.

### Required outcome

Select and implement an evidence-backed termination mechanism that covers the active actor and its
entire descendant tree, including descendants outside the actor process group. Apply it to every
controlled stop path the current dispatcher uses for an active actor. Do not begin from a prescribed
mechanism: inspect the current Darwin process behaviour, identify the actual guarantees and race
boundaries of the available mechanism, and choose the smallest design that can satisfy and prove the
outcome.

The descendant tree must be gone before the dispatcher reports that teardown completed, releases the
task lock, or exits. If the host cannot establish or verify that result, the dispatcher must not make
a stronger claim than the evidence supports, and this unit must stop rather than weakening the
objective.

### Governing authority and source dispositions

- **Governing operator direction for this unit:** deliver Phase 1 item 1a as full-descendant
  termination, leave the mechanism to Claude's repository and OS inspection, preserve every existing
  stop and safety semantic named below, hold 1f outside scope, and do not run Phase 2.
- **Governing project plan:**
  `plans/work-loop-v2-v0.2/unattended-operation-plan-v0.2.md`, which supersedes v0.1. Its status block
  and § 1a define the escaped-descendant defect and make all Phase 1 prerequisites gate Phase 2. Its
  earlier process-group fix is verified repository background, not a settled solution to the escaped
  descendant problem it explicitly leaves blocking.
- **Applicable Work Loop contract:** `.agents/skills/work-loop-v2/SKILL.md`,
  `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`, and the core's authoritative approved
  direction in `plans/work-loop-v2-mvp/work-loop-v2-mvp-proposal-v0.4.md`. They govern verification,
  evidence, the one state-file interface and Claude's responsibility to commit; they do not choose a
  process-termination mechanism.
- **Applicable repository rules:** the parent workspace `CLAUDE.md` and this repository's
  `CLAUDE.md`. Preserve concurrent work, verify files from the filesystem, commit the bounded result,
  do not push, and do not add a second review.
- **Authoritative current-state record:**
  `logs/work-loop/work-loop-v2-contained-unattended-profile.md` is closed at `turn: operator`. It
  establishes 1d as complete and records exactly two blockers before this unit: 1a and 1f. Do not
  edit that closed record.
- **Historical evidence, not authority for the new mechanism:**
  `plans/work-loop-v2-v0.2/handoff-automation-spike/runs/probe-interruption-2026-08-07.md`, its script
  and raw capture, and `runs/phase0-attended-launcher-proof-2026-08-07.md`. They prove why the current
  group-based teardown exists and that it works for in-group descendants. They do not prove escaped
  descendants terminate.

### Verify these claims before changing anything

Treat each item as a repository claim, not as permission to assume it is still true. Re-read the
active checkout immediately before editing because it is moving evidence, and preserve concurrent
changes.

1. In `dispatch.sh`, search for `terminate_actor_group`, `on_signal`, `run_bounded`, `ACTOR_PGID`,
   `return 124`, and exits `21`, `28`, and `29`. Verify the complete current set of paths that stop an
   active actor, and verify which paths share teardown rather than trusting this brief's summary.
2. In `dispatch.test.sh`, inspect cases 27, 27b and 28. Verify that case 27b currently treats a
   `setsid` descendant's survival as the expected boundary, while the ordinary grandchild in case 27
   dies with the actor group. Search the full test file for every other termination assertion before
   deciding the regression matrix.
3. In `unattended-operation-plan-v0.2.md`, the spike `README.md`, and
   `work-loop-v2-contained-unattended-profile.md`, verify the status surface for `1a`, `1f`, `Phase
   2`, `284/0`, `21/0`, and `32b3239`. If the status no longer reduces to exactly two blockers before
   this unit, stop and hand back the conflict.
4. Verify from the bounded governing surfaces — the current operator direction in this brief, plan
   § 1a, and `logs/decisions.md` entries related to unattended operation — whether any mechanism for
   terminating escaped descendants has already been settled. The checked surface is specifically
   `setsid`, `descendant`, `process group`, `process tree`, `termination`, and `kill`. The framing
   premise is that the required behaviour is settled but the mechanism is not; if that premise is
   false, cite the controlling decision and follow it or hand back the conflict.
5. Verify that the named scoped files in the active Claude checkout have not moved underneath this
   brief. Do not overwrite, revert, or re-create concurrent work. A compatible concurrent edit must
   be preserved and integrated; an incompatible one is a hand-back, not a reason to force the unit
   through.

### Behaviour that must remain true

- External interruption remains terminal. `SIGINT` and `SIGTERM` stop the run, launch no later actor,
  release the lock exactly once after teardown, exit `28`, name the task/hop/state path, warn about a
  possible partial effect, and retry nothing.
- Per-actor timeout still terminates the active actor, exits `21`, and is not retried.
- Global deadline still starts at script startup, clamps every initial launch and retry, terminates a
  still-running actor at expiry, exits `29`, states that budget exhaustion is not completion, and is
  not retried. Do not silently relax the documented hard-clock bound; if truthful tree teardown
  changes its bounded overrun, measure and document the exact new bound rather than hiding it.
- The TERM-then-KILL intent remains: cooperative processes get a bounded clean-exit opportunity and
  resistant descendants do not survive the escalation. The mechanism may change; the observable
  intent may not.
- The lock remains held throughout teardown and is cleaned up once. No second dispatcher is admitted
  while any descendant from the stopped actor remains alive.
- Exit codes and their meanings remain stable, especially `21`, `28`, and `29`. Attended,
  `--carry-one`, simulated and contained `--unattended` launches retain their current behaviour apart
  from the stronger truthful teardown.
- Retry prohibitions, state-file authority, partial-effect handling, global deadline, allow-path and
  committed-path checks, Git-hazard guards, PID/status safety, unattended containment, operator-turn
  terminality, and every unrelated test remain intact.

### Scope and framing decisions

- **Codex framing decision:** keep the implementation unit to the dispatcher, its regression
  protection, truthful spike documentation, the plan's current status, and the evidence needed to
  decide 1a. Reason: these form one observable safety result; changing code without correcting the
  current warning would leave the repository contradicting itself.
- **Codex framing decision:** permit a narrowly necessary helper only inside the existing spike.
  Reason: the mechanism is Claude's choice, so the brief must not force a one-file design while still
  preventing a new subsystem.
- **Codex framing decision:** leave the Work Loop skill and core outside this unit. Reason: Phase 3
  documentation is complete and neither source currently settles the process mechanism. If the
  implementation would make a statement there materially false, stop and hand back rather than
  widening scope silently.
- **Codex framing decision:** leave 1f and Phase 2 outside even if 1a becomes green. Reason: 1f is an
  independent proof obligation, and the plan forbids the pilot until every Phase 1 prerequisite is
  complete.

Do not rewrite the old interruption record or its raw capture to make the past look different. Add
new dated evidence for the new result and update only current-status or current-behaviour documents.
Do not change unrelated product files, rules, hooks, settings, containment policy, branch state or
worktree structure. Do not push.

### Required evidence — it must be able to fail

1. **Matched red evidence.** Run the exact new termination assertions against the unchanged
   pre-unit dispatcher and show them fail for the escaped-descendant defect. The red must identify a
   surviving escaped descendant or another directly relevant termination failure; a missing binary,
   syntax error, altered fixture, or grep of brief text is not a valid red.
2. **Green simulated regression evidence.** Run the same assertions against the implementation and
   then the full `dispatch.test.sh` suite. Cover every distinct controlled actor-stop path found in
   verification: external interruption (both signal traps, unless their exact shared routing is
   proved and specifically asserted), per-actor timeout, and global-deadline expiry. Each relevant
   path must prove that an ordinary nested descendant and a descendant that leaves the actor process
   group are gone before dispatcher exit and lock release. Include a TERM-resistant descendant so
   the KILL half is not merely prose.
3. **Guard the evidence itself.** A positive control must show the test can distinguish an in-group
   child from an escaped child and that it observes real process survival before the stop. Failed
   cases must clean up every process and lock they create; no probe may leave the very escaped
   process this unit exists to prevent.
4. **Effective OS evidence.** Where the simulated harness or a test double cannot establish Darwin's
   real process ancestry, session escape, re-parenting or termination result, run a separate
   reproducible OS-level probe and retain its script and raw capture under the existing `runs/`
   evidence tree. Observe the effective post-stop process state, not merely which signal the
   dispatcher requested. Label actor transport honestly: an `--actor-cmd` probe can be simulated
   transport while still being real OS process evidence; do not call it live product transport.
5. **Non-regression evidence.** Record the shipping full-suite result and focused checks for the
   preserved exit codes, retry prohibitions, lock lifecycle, deadline semantics, attended path, and
   all existing safety guards. If any existing test is changed rather than merely supplemented,
   explain why its old expectation was the defect rather than deleting inconvenient coverage.
6. **Repository result.** Provide the implementation commit, the exact changed-path list, the red and
   green commands/results, and the durable evidence paths in this state file. Separate dispatcher
   observations from Claude's interpretation.

### Completion condition

Complete this unit only when all controlled stop paths verified from the current dispatcher leave no
actor descendant running, including a nested `setsid` or equivalent escapee; the matched red and
green evidence is reproducible; the full suite is green; and preserved semantics have not weakened.

If those conditions hold, update the plan and README truthfully: 1a is complete, 1f is the only
remaining Phase 2 blocker, and Phase 2 is still forbidden and has never run. Write a concise result
and evidence summary into this state file, set `turn: codex`, and commit the complete bounded change
including the state file. Do not close the task; Codex must assess the evidence first.

### Stop conditions

Stop and hand back with `turn: codex` without improvising if a verify-first claim is false; the
mechanism would require root access, a persistent daemon, new broad authority, a new dependency, a
protocol/core change, or work outside the stated boundary; a race or platform limit prevents a
truthful full-tree guarantee; the failing case cannot be reproduced; effective OS evidence cannot be
made safe and self-cleaning; or any preserved deadline, interruption, retry, lock, exit-code,
attended or safety behaviour would need to weaken.

## Latest result

### The four frozen findings, reproduced by inspection first

All four were reproduced against the pre-round dispatcher (`5680a44`, extracted read-only), before
anything was corrected.

- **Finding 1: REPRODUCES.** Read `dispatch.sh:491-496` (the residual comment) and
  `dispatch.test.sh` case 27h. Case 27h deliberately builds a descendant that closes its inherited
  descriptors, asserts it **survives** the stop, and passes. Confirmed live again in this round's
  probe Part B: the daemon is `ALIVE` after the dispatcher exits 28. Codex's reading is correct — the
  success sentence was narrowed, the objective was not.
- **Finding 2: REPRODUCES.** Read `dispatch.sh:679-699` (`on_signal`) and `:1176-1199`
  (`run_bounded`). `terminate_actor_tree` and `report_teardown` both return a value; both call sites
  discard it. `on_signal` falls through to `release_lock` at `:698` and `exit 28` at `:699`
  regardless; the timeout branch returns 124 and the EXIT trap at `:702` releases the lock. Searched
  the whole file for any other consumer of those return values — none.
- **Finding 3: REPRODUCES, BY EXECUTION.** `dispatch.sh:561` censuses `lsof -t -- "$out"` on the
  **public** hop log, and `signallable_pid` (`:519-525`) filters only this dispatcher's own ancestry
  plus liveness — it never establishes descent. New case 27i parks an unrelated `tail -f` on that
  log; against the pre-round dispatcher it is **killed** (`pid 51936 was killed — teardown is
  signalling processes it does not own`, and the shell reports `Terminated: 15`).
- **Finding 4: REPRODUCES.** `report_teardown` (`:632-654`) prints `teardown verified` and returns 0
  whenever `TEARDOWN_SURVIVORS` is empty, with no reference to `FD_HANDLE`; the `lsof`-absent NOTE at
  `:648-652` sits inside the survivors branch only. `actor_tree_census` also returns empty — not
  unknown — on a failing `ps` (`:543`), absent `pgrep` (`:551`), a missing output file (`:560`) and a
  self-pgid match (`:538`). Case 27j confirms by execution: with `lsof` off `PATH`, the pre-round
  dispatcher prints `teardown verified`.

### Result

**Findings 2, 3 and 4 are corrected. Finding 1 is not fixable inside this brief's authority and is
handed back as an evidence-backed stop, with 1a still blocking.** That is the branch finding 1
itself authorises.

**Finding 1 — not fixed, and why.** The probe was extended from four handles against three escape
shapes to **six against four**, adding the shape Codex named (double fork + `setsid` +
`closerange(0,1024)`). Measured on this host:

| handle | in-group | setsid | orphan | **detached daemon** |
|---|---|---|---|---|
| process group | reaches | MISSES | MISSES | MISSES |
| recursive PPID walk | reaches | reaches | MISSES | MISSES |
| environment tag (`ps -E`) | MISSES | reaches | MISSES | MISSES |
| inherited fd — public hop log | reaches | reaches | reaches | MISSES |
| inherited fd — private marker | reaches | reaches | reaches | MISSES |
| inherited **cwd** | reaches | reaches | reaches | **reaches** |

The `cwd` handle is the only one that reaches the daemon, so the whole question is whether it can be
used. It was measured, not argued: an unrelated process was parked in the same directory holding
nothing of the actor's, and the handle returned it — `handle 6 now returns [60077 60080 60081 60086
60087 60190]`, where `60190` is the bystander. **A handle broad enough to catch the daemon is broad
enough to kill the operator's shell — which is finding 3, the defect Codex just ruled out.** Findings
1 and 3 bound the outcome from opposite sides and no handle on this host satisfies both. Two further
candidates stay closed by measurement, not opinion: `ps -E` cannot read SIP-protected platform
binaries (`/bin/sleep` and `/bin/bash` both refuse; a user-installed `python3` does not), and kqueue
`NOTE_TRACK` returns `[Errno 45] Operation not supported`. Closing 1a needs a supervisor that tracks
descendants at creation time — cgroup-equivalent, launchd job or ptrace-class — each a new subsystem
and a new authority, and an operator decision rather than a bounded fix. **No broader mechanism was
improvised, 1f and Phase 2 were not touched, and the status claims round 1 made are reverted.**

**Finding 2 — corrected.** `report_teardown` now calls `pin_lock` on survivors *or* on an
unverifiable sweep: the lock is deliberately not released, a `survivors` file inside it records what
was left and why, `release_lock` no-ops when pinned (checked in one place, because every exit path
routes through it), `acquire_lock` refuses a second dispatcher with **exit 17** and prints the
reason, and `--status` gained a `PINNED LOCK` branch **before** the pid checks so it never calls a
pinned lock stale. Interruption, timeout, deadline, retry and exit-code semantics are unchanged — 27k
asserts the interrupted run still exits 28, and the 27b–27f/28-series cases still assert 21/28/29.

**Finding 3 — corrected.** The census handle moved from the public hop log to a **private per-hop
marker** `${out%.out}.tree`, opened on fd 9 immediately before the actor is backgrounded and closed
in the dispatcher immediately after, so the actor's tree inherits it and nothing else has a reason to
hold it. `ACTOR_OUT` became `ACTOR_MARKER`. Same reach, no bystanders — probe Part B shows the marker
held by nobody after teardown while the operator's `tail -f` still holds the hop log and is `ALIVE`.

**Finding 4 — corrected, and the first attempt at it was itself defective.** `CENSUS_UNKNOWN` /
`TEARDOWN_UNKNOWN` now distinguish *could not see* from *saw nothing*: absent `lsof` or `pgrep`, a
failing `ps`, a missing marker, or an actor sharing the dispatcher's own pgid all yield unknown, and
`report_teardown` gained a third state, `teardown UNVERIFIED` with the reason. **The version of this
carried into the round did not work**, and case 27j caught it: every call site read the census
through `census="$(actor_tree_census ...)"` — a **command substitution**, hence a subshell — so
`CENSUS_UNKNOWN` was assigned in a child that then exited, and the parent read the empty string it
had cleared a moment earlier. The degraded sweep still printed `teardown verified`, which is exactly
the defect finding 4 names. Fixed by returning results through globals (`CENSUS_PIDS`) instead of
stdout, removing the subshell at all six call sites so the two results cannot be separated again.

### Evidence

- **Matched red pair, same 325 assertions in both runs.** Red: the current test file against the
  pre-round dispatcher at `5680a44` — **317 pass, 8 fail**. Green: the same file against the
  correction — **325 pass, 0 fail**.
- **Each red failure is for its own reason, and the controls hold.** 27i: the unrelated hop-log
  reader is killed (finding 3). 27j: `teardown verified` printed with `lsof` absent, no reason
  given, lock not pinned (finding 4). 27k: a second dispatcher is admitted (got 22, expected 17), no
  `PINNED` in the refusal, `--status` does not report a pinned lock (finding 2). Every control passed
  on the red run — including 27g, which shows a group-only kill reaches an in-group child and does
  **not** reach the escapee, and 27j's own control confirming `lsof` really was off `PATH`.
- **Effective Darwin evidence, re-run and revised:**
  `runs/probe-escaped-descendants-2026-08-07.md`, script
  `runs/probes/escaped-descendants-2026-08-07.sh`, raw capture
  `runs/probes/escaped-descendants-2026-08-07.raw.txt`. Simulated transport (`--actor-cmd`), real
  Darwin processes — the record states both rather than merging them. Part B's post-stop state:
  actor GONE, setsid escapee GONE, double-fork orphan GONE, **detached daemon ALIVE**, **unrelated
  `tail -f` ALIVE**, marker held by nobody. Self-cleaning; Part A reports every shape GONE and Part B
  reaps the daemon and the bystander before exit.
- **Non-regression:** full suite green, including exit codes 21/28/29, the deadline semantics
  (28, 28b–28d), the lock lifecycle (27, 30), the attended and `--unattended` paths (32-series), and
  every existing guard. Case 27b stays inverted from round 1 — its old expectation *was* the defect.
- **Docs reverted to what is proved:** `unattended-operation-plan-v0.2.md` (1a row, Phase 2 row,
  suite arithmetic, the blockers table back to two, § 1a's note, the Phase 2 DO-NOT-RUN block, the
  exit-criteria line, open question 1) and spike `README.md` (DO-NOT-RUN block, Safety boundaries,
  the boundaries table, the exit-`28` row, the stop instruction, the suite figure).
- **Changed paths:** `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`,
  `.../dispatch.test.sh`, `.../README.md`, `.../runs/probe-escaped-descendants-2026-08-07.md`,
  `.../runs/probes/escaped-descendants-2026-08-07.sh`,
  `.../runs/probes/escaped-descendants-2026-08-07.raw.txt`,
  `plans/work-loop-v2-v0.2/unattended-operation-plan-v0.2.md`, and this state file. No Work Loop
  core, skill, command or unrelated state file was touched. A concurrent session moved `HEAD`
  `5680a44` → `b500c29` during this round, touching only its own S3 files; `dispatch.sh` is
  byte-identical at both commits, so the red baseline is unaffected.
- **Correction commit `5dd1d60`.** Round 1 was `cd87e5b` / `145a7b3`.

### Candidate deferrals, recorded and not done

- **Degraded-path coverage is partial.** Case 27j exercises the `lsof`-absent path. The other
  unknown-yielding conditions — absent `pgrep`, a failing `ps`, a missing marker, an actor sharing
  the dispatcher's pgid — are implemented and reachable but not each separately tested. Covering them
  means shadowing more tools on `PATH` per case, which is wider than this frozen round.
- **The teardown cost is now disclosed but not tuned.** Worst case ~13s, deadline overrun bound ~9s.
  If 1a is later closed by a supervisor, both should be revisited rather than inherited.

## Blocker
**Phase 1 item 1a cannot be completed under this brief's authority.** Full-descendant termination
requires reaching a fully detached daemon, and the only handle on this host that does so also reaches
unrelated processes, which reintroduces the bystander-kill defect of finding 3. Closing it needs a
creation-time supervisor (cgroup-equivalent, launchd job or ptrace-class) — a new subsystem and new
authority, which this unit's scope excludes and which is an operator decision. 1a therefore remains a
Phase 2 blocker alongside 1f, and Phase 2 stays forbidden.

## Next action
Codex: closure check on the four frozen findings only — are findings 1–4 resolved, and did the
correction break anything?

For finding 1 the question is not whether the daemon was killed; it was not, and the unit says so.
It is whether the **evidence-backed stop** is the resolution finding 1 authorised: the measurement
that the only sufficient handle over-reaches, the reverted status claims, and 1a retained as a
blocker. If instead the expectation was a broader mechanism, that is an operator decision about new
authority, not a second correction round.

Findings 2, 3 and 4 are claimed as resolved, with the red pair as the check. Note that finding 4's
first correction was itself defective and is described as such rather than smoothed over.

Two candidate deferrals are recorded above; neither is implemented.
