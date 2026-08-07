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

Inspected (2026-08-07):
- Claim (1): HOLDS — searched `dispatch.sh` for `terminate_actor_group`, `on_signal`, `run_bounded`,
  `ACTOR_PGID`, `return 124`, `die 21/28/29`. **Two** call sites stop an active actor and both went
  through one shared sweep: `on_signal` (traps at `:520-521`, INT and TERM both routed to it) and
  `run_bounded`'s timeout branch. The timeout and the deadline are **not** separate teardown paths —
  they share `run_bounded`'s single `return 124`, which the loop then maps to `die 21` or `die 29`
  depending on whether the clock had expired. The brief's summary was correct.
- Claim (2): HOLDS — read `dispatch.test.sh` cases 27, 27b, 28. Case 27b asserted the `setsid`
  descendant **survives** ("the OUT-OF-GROUP descendant survives — the documented limit holds");
  case 27's ordinary grandchild dies with the group. Searched the full file for every other
  termination assertion: only `expect_rc 21` at `:219` and `:344`, `expect_rc 29` at `:840`/`:877`,
  and cases 27/27b assert anything about stopping. **No existing case asserted descendant state on
  the timeout or deadline paths, and there was no SIGINT case at all** — both gaps are now filled.
- Claim (3): HOLDS — searched `unattended-operation-plan-v0.2.md`, spike `README.md` and
  `work-loop-v2-contained-unattended-profile.md` for `1a`, `1f`, `Phase 2`, `284/0`, `21/0`,
  `32b3239`. The status reduced to exactly two blockers before this unit (1a, 1f), suite 284/0,
  live probe 21/0, final-fix commit `32b3239` present in the closed 1d record. No conflict.
- Claim (4): HOLDS — searched `logs/decisions.md` and plan § 1a for `setsid`, `descendant`,
  `process group`, `process tree`, `termination`, `kill`. `decisions.md` returns **no** termination
  decision (its apparent `kill` hits are the substring inside "skill"). Plan § 1a's *"reuse the
  TERM-then-KILL sweep"* is the superseded v0.1 minimum shape, and the note above it records the
  result as still partial. **The required behaviour is settled and the mechanism was not** — the
  brief's framing premise is correct.
- Claim (5): HOLDS — `git status --short` before editing showed none of the scoped files modified;
  the working copy of `dispatch.sh` was byte-identical to `HEAD` (sha256 `c5bef2a7…`). A concurrent
  session moved `HEAD` `b9d4dee` → `085db35` during this unit, touching only `logs/` files outside
  this scope. Nothing was overwritten or reverted.

Result: **Phase 1 item 1a is implemented and proved.** Every controlled stop path now terminates the
actor's descendant tree across three handles and **verifies** the result before the lock is released
or the process exits.

*Dispatcher observations (what was measured):*
- Four candidate handles were probed on this host. Process group: misses `setsid`, misses orphans.
  Recursive PPID walk: reaches `setsid`, misses a double-forked orphan (ppid becomes 1 before any
  stop). Environment tag: **cannot read SIP-protected platform binaries** — `/bin/sleep` and
  `/bin/bash` both refuse, a user-installed `python3` does not. Inherited fd on the hop log: reaches
  all three shapes. kqueue `NOTE_TRACK`: **`[Errno 45] Operation not supported`**.
- Live stop, observed as process state rather than as a signal the dispatcher claims to have sent:
  at +3s a TERM-resistant escapee was **ALIVE and the lock was still HELD**; at +8s it was gone, lock
  still held; at +13s the dispatcher exited `28` and released the lock, with every descendant GONE
  and no pid holding the hop file.

*Claude's interpretation (what it means):* the objective's four named escapes — `setsid`, a new
process group, a double fork, and equivalents — are all covered, and the ordering the objective
actually demanded (tree gone **before** lock release and exit) is directly observed rather than
argued. The mechanism needs no root, no daemon, no new authority and no new subsystem: the inherited
descriptor was already there because `launch_actor` redirects every actor to the hop file.

**Residual, and it is a real limitation, not a rounding.** A descendant that *also* closes or
redirects both inherited descriptors escapes all three handles and survives — a conventional daemon
does exactly this. Rather than weaken the objective silently, the teardown **verifies and names
survivors**, and its success line is scoped: *"no descendant reachable by group, ancestry or
inherited descriptor"*. Case 27h builds that exact shape, asserts it survives, and **fails if the
wording is ever widened**. This is the one judgment in the unit that is Codex's to assess: whether a
scoped-and-verified claim closes 1a, or whether the fd-closing shape reopens it.

**Disclosed cost, per the brief's instruction not to relax the hard clock silently.** Worst-case
teardown ~6s → ~13s; the `--deadline` overrun bound ~6s → ~9s
(`1s poll + TERM_GRACE_SECS 5 + KILL_SETTLE_SECS 2 + census`). Case 28's `DEADLINE_CEILING` moved
11 → 14 and still asserts the arithmetic, not a round number.

**Deferral, recorded and not done (core § 5):** there is no test for the `lsof`-absent path, where
the dispatcher degrades to two handles and prints a `NOTE:` saying so. Exercising it means shadowing
`lsof` on `PATH` for the dispatcher subprocess while leaving `git`, `ps` and `awk` resolvable — a
harness change wider than this unit's boundary. The degradation is disclosed at runtime, not silent.

Evidence: the failing case was built first and run against the **unchanged pre-unit dispatcher**
preserved from `085db35`.
- **Matched red pair: 301 pass, 24 assertions changed to 8 fail** — the same current test file
  against the pre-unit `dispatch.sh`. All 8 failures are escaped-descendant survivals or teardown
  claims that could not be made: 27b (TERM-resistant escapee survived; no verified-teardown line),
  27c (orphan survived), 27d (SIGINT escapee survived), 27e (both escapees survived the timeout
  path), 27f (escapee survived the deadline path), 27h (success line not scoped). The controls all
  passed on the red run, including **27g**, which shows a group-only kill reaches an in-group child
  and does **not** reach the escapee — so 27b–27f cannot be passing trivially.
- **Green: 309 pass, 0 fail** — the same file against the implementation. Same 309 assertions in
  both runs.
- **Effective OS evidence:** `runs/probe-escaped-descendants-2026-08-07.md`, script
  `runs/probes/escaped-descendants-2026-08-07.sh`, raw capture
  `runs/probes/escaped-descendants-2026-08-07.raw.txt`. Simulated transport (`--actor-cmd`), real
  Darwin processes — the record states both rather than merging them. Self-cleaning; a post-run
  sweep confirmed no leaked process and no stray lock.
- **Non-regression:** full suite green, including the preserved exit codes (21/28/29 asserted in
  27e/27b/27f), the deadline semantics (28, 28b–28d), the lock lifecycle (27, 30), the attended and
  `--unattended` paths (32-series), retry prohibitions and every existing guard. One existing case
  was **changed rather than supplemented**: case 27b's expectation is inverted, because its old
  expectation — that an escaped descendant survives — *was* the defect 1a describes. Its coverage is
  not deleted; case 27h now guards the boundary that genuinely remains.
- **Changed paths:** `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`,
  `.../dispatch.test.sh`, `.../README.md`, `.../runs/probe-escaped-descendants-2026-08-07.md`,
  `.../runs/probes/escaped-descendants-2026-08-07.sh`,
  `.../runs/probes/escaped-descendants-2026-08-07.raw.txt`,
  `plans/work-loop-v2-v0.2/unattended-operation-plan-v0.2.md`, and this state file.
- Commit id recorded below once it exists.

## Blocker
None.

## Next action
Codex: assess whether the evidence supports closing Phase 1 item 1a. The one judgment this unit
deliberately leaves open is whether a **scoped and verified** teardown claim closes 1a, given the
measured residual — a descendant that also closes both inherited descriptors survives, and case 27h
pins that. The alternative reading is that the residual reopens 1a. Also assess the disclosed cost
(deadline overrun bound ~6s → ~9s), the inversion of case 27b, and the recorded deferral (no test for
the `lsof`-absent degraded path). 1f remains the only other Phase 2 blocker; Phase 2 has never run
and stays forbidden.
