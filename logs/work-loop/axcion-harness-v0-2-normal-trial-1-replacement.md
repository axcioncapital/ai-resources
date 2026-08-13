---
task: axcion-harness-v0-2-normal-trial-1-replacement
turn: operator
---

## Outcome

The Work Loop v2 Slice 1–3 regression harness has a trustworthy `3.1a` baseline again, accepted
without a correction round. The two `3.1a` inventory assertions no longer measure the growing
`logs/work-loop/` directory against a hand-maintained closed set. They measure the one identifiable
commit that performed the direct fix, so genuine task records opened by later tasks can no longer
create false reds, while the signal the block exists for — the Direct Work scenario opening an
additional state file — stays durable and fail-capable by path. `KNOWN_WORKLOOP_FILES` and
`unexpected_worklog_files()` are gone. The suite moved from 292 passed / 3 failed to 299 passed / 1
failed.

The source improvement-log entry `The 3.1a closed-set assertion reddens on normal repository growth`
was updated accurately, marked `applied 2026-08-13`, and records that its own proposed `fixture-`
prefix mechanism was rejected rather than adopted — ignoring every non-fixture file would also ignore
`logs/work-loop/arbitrary-state.md`, the exact case the block was strengthened to catch.

**This execution does not count as Axcíon Harness v0.2 Normal Trial 1.** The code work is good enough,
but the operating evidence shows the operator invoked `/work-loop-v2` directly; the canonical attended
carrier was not used, and process freshness could not be verified. The run therefore establishes
neither the pilot's transport claim nor reduced manual transport through the released carrier. Codex
records this as a limitation in its own framing of the trial, not as a Claude implementation finding,
and it cannot be repaired retroactively by a correction round.

## Decisions that matter

- **The inventory is scoped to a commit, not to the directory.** The direct-fix commit is found by
  content rather than a pinned hash (`git log -S'Status: in acceptance use' -- fixture-target-2.md` →
  `317c5dd`, unique in this history), and the check asks whether that commit added anything under
  `logs/work-loop/`. Later task records are irrelevant by construction; a file the direct request
  opens is still reported by path, whatever it is named.
- **The prefix-only mechanism was rejected on evidence.** 4 of the 29 entries in the old closed set
  carried no `fixture-` prefix, and 36 genuine task records were being reported as unexpected. A
  prefix rule would have erased the detector's purpose.
- **Both directions are covered by durable paired controls** in the scoped script, not by an ad hoc
  shell demonstration: a throwaway repository whose direct-fix commit opens a state file (asserted
  against that exact path), and a pre-existing genuine task record that must not be reported. A live
  control additionally requires the count of genuine records opened since the direct fix to be above
  zero, so the green cannot be vacuous.
- **Deferral — broader scenario coverage is separate work.** The removed whole-directory inventory
  incidentally noticed a stray state file created by any Slice-3 scenario, not only the Direct Work
  one. Restoring that breadth, if wanted, is separately framed work — most likely one commit-scoped
  check per scenario — and is not part of this accepted Direct Work assertion repair.
- **No correction round was needed.** Codex accepted the implementation as delivered.

## Evidence

- `9972f21` — the implementation commit, carrying all three changed paths, subject
  `work-loop: axcion-harness-v0-2-normal-trial-1-replacement Unit 1 — scope the 3.1a inventory to the
  direct-fix commit`. It resolves with `git log -1 --grep 'scope the 3.1a inventory'`; the subject is
  unique in this history. Changed paths: `logs/scripts/work-loop-v2-slice-1.test.sh`,
  `logs/improvement-log.md`, and this state file. No incidental hook write was committed;
  `logs/friction-log.md` was already modified when the session began and was left untouched.
- Suite before: `passed: 292   failed: 3` — the two `3.1a` inventory assertions plus
  `ridx  the skill stays under its 340-line ceiling`. After: `passed: 299   failed: 1`, the `ridx`
  failure alone. `work-loop-v2-core-resolver.test.sh`: 4 passed / 0 failed.
- Fail-capability proven by mutation, run from copies in a scratch directory so the tracked script was
  never mutated: forcing the simulated direct fix to open no state file turned
  `3.1a  control: a state file opened by the direct fix is reported, by path` red (298/2); pointing
  `DIRECT_FIX_COMMIT` at `8434f34`, a commit that did add work-loop files, turned
  `3.1a  no state file was opened for the direct request`,
  `3.1a  the direct fix touched the two targets and nothing else in logs/work-loop/` and
  `3.1a  control: genuine task records opened since the direct fix, and it still passes` red (296/4).
- The closing commit carries this record.

## Accepted limitations

- **The suite still exits 1.** The pre-existing `ridx  the skill stays under its 340-line ceiling`
  assertion remains red, unchanged by this unit and outside this block — it counts lines in a skill
  file. This unit restores the `3.1a` baseline, not a globally green suite.
- **This run is not Normal Trial 1.** The attended carrier was not used and process freshness is
  unverified, so the pilot's transport claim is untouched by it. The representative-task evidence the
  Phase 3 adoption decision needs still has to be gathered through the canonical carrier.
