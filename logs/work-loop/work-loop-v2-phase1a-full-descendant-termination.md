---
task: work-loop-v2-phase1a-full-descendant-termination
turn: operator
---

## Outcome

Phase 1 item 1a is closed at pilot grade. The existing dispatcher teardown is accepted as the Phase 1a
result: on every controlled stop path it terminates and verifies the union of the actor process group,
the recursive ancestry walk and the private per-hop marker-descriptor holders, and it fails closed —
pinning the lock rather than claiming success — whenever discovery, termination or verification is
incomplete. No unrelated process is deliberately signalled. No claim of literal full-descendant
termination survives this closure.

## Decisions that matter

- **Operator decision, 2026-08-09 — completion speed over the literal guarantee.** The operator
  superseded the 2026-08-08 literal full-descendant guarantee for this pilot and accepted the fully
  daemonized escape as a written limitation. That is the value-and-risk ground for closing here rather
  than continuing the mechanism search. It is a material scope and success-criteria change.
- **Stop further supervision-mechanism discovery now.** Root-bearing ASID is rejected as a
  self-sufficient literal Phase 1a boundary: unprivileged `audit_session_join` of a held foreign
  session port sheds a descendant out of the run ASID and simultaneously falsifies that session's
  completion signal, and the ASID mechanism has no means to deny the join. Persona remains rejected —
  its exact entitlement is hard restricted with no supported operator-accessible path.
- **Deferral 14 remains recorded**, uncorrected. Reason: it is Codex's call and was never brought into
  a unit's frozen scope.
- **Deferral 15 remains recorded** — Unit 7's accepted shed analysis is incomplete: it concluded there
  was no free shed of the audit session from the `login`/`su` inventory without considering
  unprivileged `audit_session_join` of a held foreign session port. Reason: found outside the frozen
  scope of the final bounded fix, and now relevant only as context for the ASID rejection.
- **Next project boundary.** The governing unattended-operation plan still carries the superseded
  literal Phase 1a gate and must be brought current to this decision before the pilot. Phase 1f branch
  isolation remains unproved. Phase 2 remains forbidden until both are resolved. Stages D and E remain
  unauthorized. The live account (uid 502) stays untouched and every existing authority and safety
  restriction stands unchanged.

## Evidence

- Simulated dispatcher suite: **368 pass, 0 fail**, including the matched red/green pairs for the
  controlled stop paths.
- `runs/probe-escaped-descendants-2026-08-07.md` — records both the bounded reach the teardown does
  achieve and the surviving daemonized escape.
- The live Phase 0, status and contained-authority evidence pointers carried by the governing
  unattended-operation plan.
- The unit history for this task, including the Unit 10 ASID rejection and its verbatim primary-source
  basis, is in this file's Git history.

No check was rerun for this closure.

## Accepted limitations

- A descendant that calls `setsid`, double-forks, closes every inherited descriptor and then execs
  another program can survive a controlled stop. The dispatcher must not describe its termination
  boundary as a full process tree.
- The disclosed teardown cost and the deadline-overrun cost remain accepted as previously disclosed.
