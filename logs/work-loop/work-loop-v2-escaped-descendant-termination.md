---
task: work-loop-v2-escaped-descendant-termination
status: closed
turn: operator
---

## Outcome

**An evidence-backed stop, not completion of Phase 1a.**

The bounded work materially narrowed the escaped-descendant surface and made every teardown result
truthful. Reachable descendants are terminated across all controlled stop paths — both signal traps,
the per-actor timeout and the deadline. An incomplete census or a known survivor cannot print
success: it reports `teardown UNVERIFIED` or names the survivor, pins the task lock rather than
releasing it, and refuses a second dispatcher with exit `17`. `--status` preserves the alive / gone /
uninspectable distinction instead of collapsing it, so a pinned lock never advises its own removal.
The census uses a private per-hop marker descriptor rather than the public hop log, so an operator
running `tail -f` on a live run is no longer swept up and killed. Interruption, timeout, deadline,
retry and exit-code semantics are unchanged throughout.

**The governing outcome, stated plainly: a fully detached daemon still survives the stop.** A
descendant that double-forks, leaves the session and closes every inherited descriptor is reachable
by none of the implemented handles. The one available handle that does reach it — the inherited
working directory — also reaches unrelated processes sitting in the same directory, so using it would
reintroduce the bystander kills the private marker exists to prevent. Both halves are measured on
this host, not argued.

**Phase 1a therefore remains a Phase 2 blocker, alongside 1f. Phase 2 has never run and remains
forbidden.** No supervisor architecture was selected: creation-time supervision is a new subsystem
and a new authority, and that choice belongs to the operator.

## Decisions that matter

- **Round 1 claimed completion and that claim was rejected.** Narrowing the dispatcher's success
  *sentence* to the handles it had implemented is not the same as narrowing the *objective*. The
  status claims round 1 wrote into the plan and the spike README were reverted: 1a back to blocking,
  Phase 2 blockers back to two.
- **Codex used the core § 3 menu to permit one final tightly-bounded fix** after the correction
  round, accepting findings 1 and 3 at that checkpoint and requiring the remaining evidence for
  findings 2 and 4. The final check accepts those two gaps as resolved.
- **The recurring defect was one mistake in five places: an inability to look, recorded as a look
  that found nothing.** A degraded sweep printing `teardown verified`; a runtime-failing `pgrep` read
  as "no children"; a runtime-failing `lsof` read as "nobody holds the marker"; `--status` reporting
  a live-but-unsignallable survivor as gone; and `census_pid` treating any `ps -p` failure as "not
  live". Each is now three-valued — alive, gone, or cannot tell.
- **The process-group collision guard was dead code** and is fixed: it compared the actor's *pid*
  against the dispatcher's *pgid*, so it could not fire in the one situation it was written for.
- **The first attempt at the finding-4 fix did not work, and the harness caught it.** Every census
  call site read the result through a command substitution, so the unknown-reason was assigned in a
  subshell and discarded. Results now return through globals.
- **Case 27b's expectation was inverted rather than deleted** — its old expectation, that an escaped
  descendant survives, *was* the defect being removed. Case 27h now pins the boundary that genuinely
  remains.
- **Deferral, recorded and not done:** teardown costs about **13 seconds** worst-case, with about
  **9 seconds** of deadline overrun (`1s poll + TERM_GRACE_SECS 5 + KILL_SETTLE_SECS 2 + census`).
  These bounds should be re-derived, not inherited, if a creation-time supervisor later replaces
  discovery-time teardown.

## Evidence

- **Shipping simulated suite: 368 pass, 0 fail.** Matched pre-fix result on the same 368 assertions:
  **355 pass, 13 fail** (against `5dd1d60`). Final-fix commit **`7aaae68`**.
- **Earlier rounds:** correction commit `5dd1d60`, matched red pair **317 pass, 8 fail** against
  `5680a44`; round 1 `cd87e5b` and `145a7b3`.
- **Effective Darwin evidence:**
  `plans/work-loop-v2-v0.2/handoff-automation-spike/runs/probe-escaped-descendants-2026-08-07.md`,
  with script and raw capture under `runs/probes/`. Six handles measured against four escape shapes;
  simulated transport (`--actor-cmd`), real Darwin processes, stated separately rather than merged.
  Post-stop state observed directly: actor, `setsid` escapee and double-forked orphan all GONE; the
  detached daemon **ALIVE**; an unrelated `tail -f` **ALIVE**. Self-cleaning.
- **Coverage of the branches that carry the safety claims:** case 27h (the surviving shape, which
  also fails if the success wording is widened), 27i (bystander not signalled), 27L (a visible but
  unkillable survivor pins the lock), and 27j plus 27m–27q (one case per materially distinct
  discovery-failure route).
- **Rejected on measurement, not preference:** an environment tag cannot read SIP-protected platform
  binaries (`/bin/sleep`, `/bin/bash`), and kqueue `NOTE_TRACK` returns `[Errno 45] Operation not
  supported` on this host.

## Accepted limitations

- **The detached-daemon escape is accepted only as the truthful result of this bounded task — not as
  safe enough for Phase 2, and not as completion of 1a.** A descendant that double-forks, leaves the
  session and closes every inherited descriptor outlives the stop while the operator believes the run
  halted. It is narrower than what it replaced, where a single `setsid` was enough to escape, but
  narrower is not closed.
- **Closing it requires an operator decision** on a creation-time supervisor — a per-run
  cgroup-equivalent, a launchd job, or a ptrace-class supervisor. Each is a new subsystem and a new
  authority, and none was selected here.
- **The `--deadline` overrun bound is about 9 seconds**, and worst-case teardown about 13 seconds.
  Disclosed rather than silently absorbed.
- **All harness evidence is simulated transport.** The processes are real Darwin processes, but the
  actor is supplied through `--actor-cmd`; no live product transport was exercised in this task.
