---
task: work-loop-v2-handoff-dispatcher
turn: operator
---

## Outcome

A successful throwaway tracer bullet. A task-scoped external dispatcher carried one exact Work Loop
task serially through **seven live actor launches and six allowed Codex/Claude state transitions**,
stopped at `turn: operator`, and kept Codex from moving HEAD on any of its hops. It ships with a
focused harness reporting `pass=34 fail=0`, covering routing, filename/frontmatter identity,
timeout, hop limit, no-op transitions, foreign repository state, and the operator stop.

The evidence is good enough for this bounded task. Its completion condition required the live
single-task seam or a precisely evidenced product boundary — not production readiness.

Two behaviours crossed the seam live without prompting: the child Claude refused a brief resting on
a false claim and handed back, and Codex's close token reached Claude, which wrote the closing
record and stopped with zero further launches.

## Decisions that matter

- **Reciprocal product Stop hooks remain rejected as the orchestrator.** The dispatcher, not a hook,
  owns validation, routing, process lifetime and the next launch.
- **The current `turn:` field is proven only as a temporary spike seam.** It is not promoted to
  permanent architecture; the v0.2 direction to shed turn flags and bookkeeping still stands.
- **Nothing was installed or widened.** No hook, daemon, settings change, schema change, production
  installation, dangerous permission bypass, or parallel-loop authorisation was made. The child
  inherited the project's existing `defaultMode: bypassPermissions`; this unit did not author it.
- **Two deviations were justified within the stated boundary, and stated rather than absorbed.** The
  live fixture's state file sits at its canonical `logs/work-loop/` location because both live
  entrypoints resolve that path — a fixture inside the spike directory is unreachable by the products
  under test. And `logs/friction-log.md` was allowlisted for the live run only, by explicit launch
  argument, because a PostToolUse hook appends to it constantly; the dispatcher's built-in allowlist
  is unchanged.
- **Deferral — the worktree-per-task spike.** Not started, because this task excluded parallel
  operation.
- **Deferral — wider crash-recovery proof.** The unit established only one successful restart from
  disk plus the essential uncommitted-handback guard.
- **Deferral — production hook or daemon triggering.** Held until the remaining proof gates pass and
  the operator approves.
- **Deferral — the truncated `--help` window in `dispatch.sh`.** Cosmetic; the complete exit-code set
  stays inspectable in the source and in the README.

## Evidence

Commit `edbfbd2` carries the unit: `plans/work-loop-v2-v0.2/handoff-automation-spike/` with
`dispatch.sh`, `dispatch.test.sh`, `ps-sampler.sh` and the `runs/` live-run records
(`live-console.txt`, `live-console-2.txt`, `live-ps-samples*.txt`). Commit `94b440b` carries the
first controller and harness.

`bash dispatch.test.sh` → exit 0, `pass=34 fail=0`. Case 0 points the suite at an absent dispatcher
and asserts it fails, so a green run means something.

The controlled fixture ran the loop end to end and closed at `turn: operator`: commits `fc252ef`
(false-premise hand-back), `6de0bd2` (`README.md`, written entirely through the transported loop),
`8ad98c4` (unit done) and `47ebab8` (closing record) — none of them made by a person carrying a turn.

## Accepted limitations

- Single task and single checkout only. No claim of same-checkout concurrency or multi-worktree
  safety.
- Crash recovery is only partially proven — one restart from disk, plus the uncommitted-handback
  guard.
- Repeat reliability is limited to the two recorded runs.
- No unattended genuine core § 7 risk decision was exercised. `turn: operator` was reached by a
  normal close, never by a risk stop.
- No hook-driven, daemon-driven, or production deployment behaviour exists.
- The spike depends on the currently installed product binaries (`codex-cli 0.146.0-alpha.9.2`,
  Claude Code `2.1.220`) and was not authorised to install, upgrade, authenticate, or widen
  permissions.
