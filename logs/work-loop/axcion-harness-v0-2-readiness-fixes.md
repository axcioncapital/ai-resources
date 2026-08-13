---
task: axcion-harness-v0-2-readiness-fixes
turn: operator
---

## Outcome

Units 1–6 of the supervised-readiness work were implemented and accepted: checkout-wide single-writer
enforcement, the corrected permission-dead-end exit code, the mandatory nested-actor deny set on every
Claude hop, the per-run attended `acceptEdits` permission mode, the trial-programme sizing and
disposition discovery, and per-hop actor and nested-actor observation on both the run log and the
terminal `RESULT` line.

Unit 7 — the single authorised live attended smoke test in this checkout — stopped safely and is
**not** accepted as successful carrier-operation evidence. The carrier launched one top-level Claude
actor; the actor exited after one second because the local Claude CLI reported `Not logged in ·
Please run /login`. The carrier classified that deterministically as `ACTOR_FAILED` (exit 20),
preserved `turn: claude`, observed no permission denial, attributed no repository change to the hop,
and reported `actors=1 nested=unobserved`. That is failure-handling evidence, not successful
live-operation evidence. The operator stopped the trial programme rather than spend further time on
setup or ceremony.

The retained result is **implemented attended-carrier hardening that remains unproven in successful
representative live operation**. This task does not claim "Ready for supervised semi-agentic use",
and no result here claims unattended readiness.

## Decisions that matter

- **The readiness label is refused.** The assessment's compound "Ready for supervised semi-agentic
  use" label is not claimed, because the authoritative-current-position refusal requirement was
  disposed of as out of scope and remains unmet, and because no successful live trial exists.
- **The trial programme was stopped, not completed.** The operator rejected a separate trial checkout
  and the full multi-trial programme as excessive ceremony, authorised exactly one live hop in this
  existing checkout, and authorised no retry after it stopped. Unit 5's sizing finding — a minimum of
  13 carrier invocations across five trial tasks, realistically more if corrections occur — stands as
  the measure of what was not done.
- **Two earlier trial tasks closed without counting.** `axcion-harness-v0-2-normal-trial-1` closed on
  a false premise before its unit began; its replacement closed after restoring the 3.1a baseline.
  Neither counts as Normal Trial 1.
- **Observation is reported as observation, never as containment.** `nested=0` states that nothing was
  seen by that rule, in that group, during that window; a census that could not run reports
  `unobserved`, never `0`. Nothing in Unit 6 prevents nesting — the mandatory `--disallowedTools` set
  is a separate claim.

Deferrals recorded and not done, with their reasons:

- Wrapper- and interpreter-launched nested actors are not observed. Closing that gap means matching
  the whole argv rather than the executable name, trading a blind spot for false positives; it needs
  its own design decision and was outside Unit 6's "smallest honest observation" scope.
- The `RESULT` line now carries eleven fields. A documented field order or a parsing helper would be
  worth having if it grows further; two added fields did not justify one.
- Carried from earlier units: older-option missing-value parser loops; the undocumented CLI `default`;
  no equivalent nested deny on the Codex actor path; exit-taxonomy divergence; the `jq`
  permission-evidence dependency; default allowlist review; hook-owned `logs/friction-log.md` dirt;
  cosmetic temporary-lock formatting; and Work Loop courier/taxonomy divergence.

## Evidence

Accepted implementation commits:

- Unit 1 — `e2ac00d96cbc0a65c9883517a505a4250debf8c4` (checkout-wide live writer lock)
- Unit 2 correction — `bb0af1b298668a917fe9e39b61a0278fba363d3b` (permission dead end is exit 37)
- Unit 3 — `53dc76c13b91ed5df4a2c12b590066e8e80754e6`, correction
  `51b140a02a0031107960e78bd0b802fbc0363ecd` (mandatory nested-actor deny set, both rule forms)
- Unit 4 — `e04a8f095e4dfdd058e707d4247cd9572208a907` (per-run attended `acceptEdits` mode)
- Unit 5 — discovery `9c0163f38ebd533ca34a3edbd158f9eb3b233567`, correction
  `43bd68e8c72abdd2ef9da21b5b16826983f7389b` (discovery unit; no implementation commit)
- Unit 6 — `908f3617f19916fa57aaa0d0359dcfbdde2399e0` (per-hop actor and nested-actor census),
  accepted at `36cb4da7cb7e2d5a75e47d25f0a89bf50ed30b3e`

Test evidence for Unit 6, fail-capable and reproducible from the repository:
`./carry-turn.test.sh` returned `passed: 268 failed: 17` against the unmodified carrier with section
16 written first, and `passed: 285 failed: 0` after the implementation, so no pre-existing assertion
was traded away. `./carry-turn.test.sh --prove-failure` returned `passed: 40 failed: 0` with three new
mutants (census removed, top-level-actor exclusion removed, unrun census reported as `0`), each
carrying a control assertion showing the hop still launched.

Prior trial closing records: `bd515c8799f1bee97a77344a0f69760fac4bb7df`
(`axcion-harness-v0-2-normal-trial-1`) and `725ce57bb2405107aab49483582bb2e8dffff8ee`
(`axcion-harness-v0-2-normal-trial-1-replacement`).

Unit 7 capture:
`logs/harness-runs/20260813T183945-13694-axcion-harness-v0-2-readiness-fixes.claude.out`, with its
companion `.log`. Both exist in this checkout and are untracked — `logs/harness-runs/` has never been
committed in this repository, so the capture is a working-tree artifact, not a committed one.

## Accepted limitations

- **Authoritative-current-position refusal is unmet.** It was disposed of as out of scope for this
  task and was not implemented. It is the specific reason the supervised-readiness label cannot be
  claimed.
- **No successful live-operation evidence exists.** One attended hop was attempted; it stopped at a
  local Claude CLI authentication prerequisite. Repeat reliability, operator burden and general
  readiness are all unevidenced. The single stop does supply evidence that the carrier classifies an
  actor failure deterministically, preserves the turn, and attributes no repository change.
- **Process observation has known blind spots**, all disclosed in the carrier's own header: a nested
  actor started through a wrapper or interpreter (a `#!/bin/bash` script named `claude` reports `comm`
  as `/bin/bash`); a renamed or copied binary; a process that starts and exits between two ~1s
  samples; a process that leaves the group via `setsid` or a daemonising launcher; and anything after
  the hop ends.
- **Nothing here prevents nesting.** The census observes; the mandatory `--disallowedTools` set is the
  separate preventive claim, and the Codex actor path still carries no equivalent deny.
- **Unattended operation is out of scope and unclaimed.** So are `bypassPermissions`, external
  actions, automatic push or merge, strategic routing, portfolio scheduling, and any permission
  widening beyond the per-run attended `acceptEdits` authority approved on 2026-08-13.
