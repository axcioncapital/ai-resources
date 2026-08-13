---
task: spike-live-transport
turn: operator
---

## Outcome

Unit 1 accepted. `plans/work-loop-v2-v0.2/handoff-automation-spike/README.md` was created and now
explains the spike so a later operator can use it without reading the scripts: its purpose,
`dispatch.sh` invocation with every option and default, the three run modes, the live launch
commands, a worked example, all 15 declared exit codes with the modes each can be returned in, the
mode-specific meaning of exit `0`, the allowed turn transitions, `dispatch.test.sh` invocation and
summary semantics, the safety boundaries, and what the spike does not establish.

The task itself was a Work Loop v2 transport fixture, not a backlog item. It carried one real
Codex → Claude → Codex sequence through the handoff dispatcher so that live product transport could
be observed rather than assumed.

## Decisions that matter

- The README documents the dispatcher's **observed, mode-specific** behaviour and names the source
  inconsistencies as inconsistencies, rather than presenting either side as the universal contract.
- **Deferral — `dispatch.sh` line 31 overstates exit `0`.** It gives exit `0` a single meaning, but
  `--help` and a valid `--dry-run` also return `0` without reaching `turn: operator`. Not fixed
  because `dispatch.sh` is explicitly excluded from this unit's scope.
- **Deferral — `--help` output is truncated.** It prints the header with `sed -n '2,45p'`, so it
  omits exit code `25` and the lines 48–49 note qualifying exit `0`. Found during the unit and
  handled as a deferral rather than a hand-back: it did not falsify any premise the README needed,
  because the complete declared set stays inspectable in the source, and the README surfaces the
  mismatch. Same excluded-file reason as above.
- **No automatic follow-up unit is opened for either defect.** This task is a transport fixture, not
  evidence of demand, so prioritising any later script fix is the operator's call.

## Evidence

README commit `6de0bd2d574ab817e149022eb0b8cb4f0206f45c` — one repository file changed for the unit,
`plans/work-loop-v2-v0.2/handoff-automation-spike/README.md`. This state file was committed
separately as protocol work.

Falsifiable checks, all run: exact-path absence check before creation (`No such file or directory`,
exit 1); an exit-code comparison against the dispatcher-declared set that was first proved capable
of failing on a mutated README (`RESULT: FAIL`, rc=1, reporting `omitted by README : 25` and
`invented by README: 99`) and then passed on the real file (`RESULT: PASS`, rc=0, both sets
`0 10 11 12 13 14 15 16 17 20 21 22 23 24 25`); and the README's own non-live verification commands
— `bash dispatch.test.sh` → exit 0, `pass=33 fail=0  (all cases SIMULATED — no live product
transport)`, and `bash dispatch.sh --help` → exit 0.

## Accepted limitations

- Both `dispatch.sh` documentation defects remain in the file (line 31; the truncated `--help`
  window).
- `dispatch.test.sh` is a simulated harness. It proves controller behaviour, not live product
  transport.
- This task produced **one** transport observation. It is not evidence of production readiness,
  concurrency safety, repeat reliability, unattended operator-decision handling, or work quality.
