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

### The final tightly-bounded fix — core § 3 menu choice, not a second correction

Codex's closure check accepted finding 1's evidence-backed stop and finding 3's private marker, and
named two remaining gaps in findings 2 and 4. Only those two were worked. Finding 1 was not reopened,
no supervisor was selected, 1f was not touched and Phase 2 was not run.

### Gap 1 — the survivor branch, now tested

Case 27k pinned the lock for a sweep that could not *look*. The survivor path — the sweep looks,
**finds** a live descendant and cannot clear it — is a different branch (`TEARDOWN_SURVIVORS` rather
than `TEARDOWN_UNKNOWN`) and had no case. **Case 27L** builds it without mocking `kill`: a root-owned
pid is alive, `ps` confirms it, and `kill` from a non-root uid returns `EPERM`. It is injected into
the census through a stubbed `lsof`, which is the handle that reports marker holders, so the
dispatcher genuinely treats it as a descendant. Two guards, because the case makes the dispatcher
signal a pid it did not create: it refuses to run as root, **and** it re-checks that the pid really
is unsignallable first. It also asserts afterwards that the process is still alive.

**The branch itself was already correct — 12 of the case's 13 assertions pass against the pre-fix
dispatcher.** The survivor is reported, named in the warning, written to the `survivors` file, the
lock is pinned, and a second dispatcher gets exit 17. Reported plainly rather than dressed up as a
red-to-green result.

**The thirteenth assertion found a real defect, and a consequential one.** `--status` re-checked each
recorded survivor with a bare `kill -0`. That fails both when a process is gone and when it is alive
but not ours to signal — and a survivor left behind by a stopped actor is quite likely to be the
second. So `--status` printed *"none of the recorded pids is alive now; the lock is safe to remove"*
while pid 242 was running. That is the pinned lock advising its own removal. It now uses the same
three-valued `pid_state()` the lock's own check uses and reports an uninspectable pid as
**STILL ALIVE NOW (cannot inspect, so treat as running)**.

### Gap 2 — every discovery-failure route distinguished and tested

One case per materially distinct route, each asserting the same three things: no success line, a
reason naming the route, and a pinned lock.

| case | route | against the pre-fix dispatcher |
|---|---|---|
| 27j | `lsof` absent (retained control) | already correct |
| 27m | `ps -ax` **failing** | already correct |
| 27p | tree marker missing | already correct |
| 27n | `pgrep` **failing at runtime** | **RED — read as "the actor has no children"** |
| 27o | `lsof` **failing at runtime** | **RED — read as "nobody holds the marker"** |
| 27q | actor shares the dispatcher's process group | **RED — the guard could not fire at all** |

Three routes were already right and their cases are regression protection, not proof of a fix. The
other three were wrong:

- **`pgrep` failing.** Its exit code is three-valued — 0 matches, 1 no matches, ≥2 pgrep itself
  failed — and the code discarded it, so a broken ancestry walk was indistinguishable from a
  childless actor.
- **`lsof` failing.** `lsof -t` exits 1 both when nobody holds the file and when it could not look,
  so the exit code cannot separate them; only stderr can, and stderr was going to `/dev/null`.
- **The process-group collision guard was dead code.** It compared the caller's argument — the
  actor's *pid* — against the dispatcher's *pgid*. Those are different kinds of number and can match
  only by coincidence, so the guard could never fire in the one situation it was written for: `set
  -m` failing and the actor joining the dispatcher's group. It now reads the actor's real group.

Also corrected under this gap: `census_pid` (formerly `signallable_pid`) collapsed three answers into
two, treating any `ps -p` failure as "not live". It now returns *alive*, *gone*, or *cannot tell*, and
counts an alive-but-unsignallable pid as a **survivor** rather than dropping it — a descendant we may
not signal is still a descendant that is running.

**All four defects are the same mistake in different places: an inability to look, recorded as a look
that found nothing.** That is the mistake this whole item is about, which is why Codex was right that
executable coverage was mandatory rather than a permissible deferral.

### Evidence

- **Matched red pair, same 368 assertions in both runs.** Red: the current test file against the
  pre-fix dispatcher at `5dd1d60` — **355 pass, 13 fail**. Green: the same file against the final
  fix — **368 pass, 0 fail**.
- **The 13 red failures are exactly the four defects** — 1 for `--status` (27L), 4 each for 27n, 27o
  and 27q — and every control passed on the red run, including each stub's own control proving the
  tool really was broken and still on `PATH` (failure, not absence).
- **Non-regression:** the full suite is green, including exit codes 21/28/29, the deadline arithmetic
  (28, 28b–28d), the lock lifecycle (27, 30, 30d–30f), the attended and `--unattended` paths
  (32-series), and cases 27b–27k unchanged in meaning. Every new case reaps its own processes; 27L
  additionally asserts the root-owned process it borrows is untouched.
- **The probe is unchanged and was not re-run.** It measures *reach*, and this fix changed no handle
  and no reach. Its record carries a dated note saying where the degraded-route evidence now lives.
  Stating that is more honest than re-running it to produce an identical table.
- **Changed paths:** `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`,
  `.../dispatch.test.sh`, `.../README.md`, `.../runs/probe-escaped-descendants-2026-08-07.md`,
  `plans/work-loop-v2-v0.2/unattended-operation-plan-v0.2.md`, and this state file. No Work Loop core,
  skill, command or unrelated state file was touched. `HEAD` moved several times under this unit from
  a concurrent session (`5dd1d60` → `43b5743`), touching only its own Work Loop skill and state files;
  `dispatch.sh` is byte-identical across that range, so the red baseline is unaffected.
- **Final-fix commit `7aaae68`.** Correction round was `5dd1d60`; round 1 was `cd87e5b` / `145a7b3`.

### Deferral, recorded and not done

The teardown cost is disclosed but not tuned — worst case ~13s, deadline overrun bound ~9s. If 1a is
ever closed by a creation-time supervisor, both should be re-derived rather than inherited. The
earlier deferral about partial degraded-path coverage is now **discharged**, not carried: that was
this fix.

## Blocker
**Unchanged, and not reopened by this fix. Phase 1 item 1a cannot be completed under this brief's
authority.** Reaching a fully detached daemon requires the inherited-working-directory handle, which
also reaches unrelated processes and so reintroduces finding 3's bystander kills. Closing 1a needs a
creation-time supervisor — a new subsystem and new authority, which this unit's scope excludes and
which is an operator decision. 1a remains a Phase 2 blocker alongside 1f, and Phase 2 stays forbidden.

## Next action
Codex: closure check on this final fix only — are the two named gaps resolved, and did the fix break
anything? Per core § 3 this fix gets no new broad review, and findings 1 and 3 are settled.

Gap 1 is claimed resolved with one honest qualification: the survivor branch was **already correct**
and its case is largely regression protection, but writing the case exposed a genuine `--status`
defect that is now fixed. Gap 2 is claimed resolved for all six routes, three of which were already
correct and three of which were red.

Worth Codex's attention specifically: case 27L makes the dispatcher send TERM and KILL to a
root-owned pid it did not create. That is deliberate — it is the only way to get "alive but
unclearable" without mocking `kill`, and it is the same device case 30d already uses — but it is
double-guarded (non-root only, and the pid re-checked as unsignallable first), and the case asserts
the borrowed process survives. If that trade is judged wrong, say so and the case can be dropped for
a weaker one rather than defended.

One deferral is recorded above; the previous deferral about degraded-path coverage is discharged.
