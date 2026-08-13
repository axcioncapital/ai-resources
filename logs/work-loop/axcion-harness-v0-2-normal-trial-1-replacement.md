---
task: axcion-harness-v0-2-normal-trial-1-replacement
turn: codex
---

## Objective and scope

Complete the replacement Normal Trial 1 for Axcíon Harness v0.2 by restoring a trustworthy green
baseline to the Work Loop v2 Slice 1–3 regression harness without weakening its ability to detect an
unexpected state file created by the Direct Work scenario.

Scope: `logs/scripts/work-loop-v2-slice-1.test.sh`, this state file, and the source improvement-log
entry `The 3.1a closed-set assertion reddens on normal repository growth` only if the completed
evidence supports updating its status. Excluded: changing Work Loop behaviour, changing task-state
files, editing fixtures, deleting or renaming historical task records, unrelated test cleanup,
deployment, push, and any broader redesign of the regression suite. Hook-written
`logs/friction-log.md` or `logs/innovation-registry.md` changes are permitted incidental effects, not
implementation targets.

The task exits when the bounded repair has completed implementation, handback, Codex assessment, and
closure with evidence sufficient to count it—or explicitly refuse to count it—as Normal Trial 1.

## Lane and unit

Standard. Implementation mode. Unit 1 — remove legitimate-task false reds from the `3.1a` assertions
while preserving their unexpected-state-file failure signal.

Named reason for the loop: this regression instrument protects the live Work Loop contract; its
repair needs a bounded failing case and independent assessment before the suite can again be trusted,
and the unit is intended to provide representative small-code operating evidence for the attended
harness pilot.

## Brief

This is the replacement for the first candidate, which correctly stopped when its premise proved
false. It is worth doing now because the attended harness is live for pilot use, the remaining
adoption question requires representative real tasks, and a permanently red regression suite makes
subsequent Work Loop changes harder to assess reliably. The unit is one code change with one
proportionate evidence set.

**Required outcome.** Make legitimate accumulated Work Loop task records irrelevant to the Direct
Work assertion, while retaining a fail-capable check that detects the specific bad behaviour: the
Direct Work scenario opening an additional state file. Claude owns the implementation mechanism.

**Authority and source disposition.**

- Governing operator direction: the current approval of the recommended replacement Normal Trial 1.
- Authoritative current pilot state to verify:
  `logs/work-loop/axcion-harness-v0-2-go-live.md` should show normal attended pilot use is live and
  final adoption remains open pending representative tasks.
- Non-governing background: `plans/axcion-harness-v0.2/mvp-plan.md` describes a small code task with
  tests as one representative shape, but its own header labels it proposed; do not promote it to
  governing authority.
- Verify-first source material: the improvement-log entry titled `The 3.1a closed-set assertion
  reddens on normal repository growth` reports recurring false reds and proposes classifying fixtures
  by the `fixture-` prefix. Its diagnosis and proposal do not govern. In particular, do not adopt a
  mechanism that merely ignores every non-fixture file: that would also ignore the unexpected
  non-fixture state file the assertion was strengthened to catch.

**Check against the repository before editing.**

1. In `logs/scripts/work-loop-v2-slice-1.test.sh`, inspect the complete `3.1a` block and confirm what
   `KNOWN_WORKLOOP_FILES`, `unexpected_worklog_files`, and the two affected assertions currently
   measure.
2. Run the existing full suite before editing and record the exact pass/fail total and the names of
   every failing assertion. The load-bearing premise is that legitimate accumulated task records make
   one or both `3.1a` inventory assertions fail; if that is not the current failure, hand back rather
   than fixing a stale diagnosis.
3. Bound the live inventory claim to `logs/work-loop/*.md`: identify which files the harness itself
   treats as fixtures and which are genuine task records. Do not infer fixture identity solely from
   the improvement log's proposed prefix rule without checking all harness references.
4. Confirm from the comments and assertion history in the `3.1a` block that an arbitrary additional
   state file previously passed the older filename-word check and that the current detector was meant
   to close that false-pass class.

**Boundaries and framing decisions.** I selected the `3.1a` repair as one observable deliverable and
excluded adjacent red assertions or general suite cleanup. I rejected the source entry's prefix-only
mechanism as a requirement because, on the live shape, ignoring all non-fixture files would appear to
erase the detector's purpose. This is a framing constraint on observable behaviour, not a prescribed
technical design.

**Required evidence.**

- The unmodified suite demonstrates the current legitimate-task false red before implementation.
- After implementation, the full suite exits green, or any unrelated/environment-dependent failure
  is separated with exact output and shown unchanged by this unit.
- A paired fail-capability control adds or simulates one unexpected state file attributable to the
  Direct Work scenario and proves the repaired `3.1a` check fails for that file. The evidence must
  identify the unexpected path; an exit-code-only or self-matching grep is insufficient.
- A paired legitimate-record control proves adding or simulating a pre-existing genuine Work Loop
  task record does not make the Direct Work assertion fail.
- The regression coverage is durable in the scoped test script; do not rely only on an ad hoc shell
  demonstration that disappears after the run.
- The result identifies every changed path and distinguishes intended edits from incidental hook
  writes.
- The handback records the final commit and enough operating facts for Codex to assess the normal
  trial: whether a fresh Claude process reconstructed the unit from durable sources, whether manual
  actor-to-actor context was ferried, operator interventions observed during the hop, elapsed time if
  available, and any loss-of-control or recovery event. Do not invent unavailable facts.

**Completion condition.** Implement the bounded repair in the test script, add fail-capable durable
regression coverage for both controls, run the proportionate checks, update the source improvement
entry only if its stated problem is fully resolved by the evidence, commit the allowed result, write
the result and evidence into this state file, set `turn: codex`, and stop for assessment.

**Stop conditions.** Hand back without implementation if the live suite is not red for the stated
reason, no mechanism can distinguish the bad Direct Work artifact from legitimate accumulated task
records without changing another file or fixture contract, or the required controls cannot be made
fail-capable inside scope. Stop for the operator if the only viable repair would remove the Direct
Work assertion, weaken it to ignore arbitrary state files, or change the Work Loop protocol. Challenge
a false premise or stale direction rather than improvising past it.

## Latest result

Inspected (2026-08-13):

- Claim (1) — the `3.1a` block's current measurement: HOLDS. Read
  `logs/scripts/work-loop-v2-slice-1.test.sh:433-469` in full. `KNOWN_WORKLOOP_FILES` was a
  hand-maintained list of 29 filenames; `unexpected_worklog_files()` listed every entry of
  `ls logs/work-loop/` absent from that list; both `3.1a no state file was opened for the direct
  request` and `3.1a every task-state file present is one this build created deliberately` required
  that listing to be empty. So both measured the whole live directory, not the direct request.
- Claim (2) — the live suite is red for the stated reason: HOLDS. Ran the unmodified suite:
  `passed: 292   failed: 3`, exit 1. Failing assertions, exactly:
  `3.1a  no state file was opened for the direct request`,
  `3.1a  every task-state file present is one this build created deliberately`, and
  `ridx  the skill stays under its 340-line ceiling`. Reproducing `unexpected_worklog_files()` by hand
  returned 36 paths, every one a genuine Work Loop task record (e.g.
  `axcion-harness-v0-2-go-live.md`, `work-loop-v2-intake-router.md`) and none a Direct Work artifact.
  The third failure is a line-count check on a skill file, unrelated to this block.
- Claim (3) — fixture identity per the harness itself, bounded to `logs/work-loop/*.md`: HOLDS, and it
  contradicts the source entry's prefix rule. Searched the script for each non-prefixed entry of the
  closed set: `context-engineering-implementation.md`, `context-engineering-implementation-plan.md`,
  `context-engineering-s7-regression.md` and `foreign-staging-target-repo.md` occur exactly once each
  — inside `KNOWN_WORKLOOP_FILES` itself and in no assertion. They are genuine task records added to
  the allow-list to silence the red. The files the harness actually uses as fixtures are the
  `fixture-`-prefixed ones, each referenced by a real assertion.
- Claim (4) — the older filename-word check false-passed an arbitrary state file: HOLDS. The block's
  own comment at `:433-439` records the old predicate `! ls logs/work-loop/ | grep -qi 'direct'`, that
  it only inspects filenames, and that `logs/work-loop/arbitrary-state.md` was created and all 142
  assertions stayed green. The closed set was the answer to that false-pass class.
- Pilot-state claim — searched `logs/work-loop/axcion-harness-v0-2-go-live.md`: HOLDS. `## Outcome`
  states the harness is live for normal attended pilot use, and that final Phase 3 adoption is not
  claimed and remains open pending three to five representative tasks.

Result: Unit 1 implemented. The `3.1a` inventory no longer looks at the live directory. It is scoped
to the single commit that performed the direct fix — found by content, not by a pinned SHA
(`git log -S'Status: in acceptance use' -- fixture-target-2.md` → `317c5dd`, unique) — and asks
whether *that commit* added anything under `logs/work-loop/`. Legitimate task records opened by any
later task are therefore irrelevant by construction, while a state file opened by the direct request
is still caught by path, whatever it is named. `KNOWN_WORKLOOP_FILES` and `unexpected_worklog_files()`
are deleted; the detector is `worklog_added_in <repo> <commit>` plus `worklog_touched_in`, taking the
repository as an argument so the controls drive the same function rather than a look-alike.

The source entry's `fixture-`-prefix proposal was rejected on the evidence in claim (3): it would
ignore every non-fixture file, which is exactly `arbitrary-state.md`.

Evidence:

- Before: `passed: 292   failed: 3` (exit 1), the two `3.1a` inventory assertions plus `ridx`.
  After: `passed: 299   failed: 1` (exit 1). The one remaining failure is
  `ridx  the skill stays under its 340-line ceiling` — present before this unit, unchanged by it, and
  outside this block (it counts lines in a skill file). `work-loop-v2-core-resolver.test.sh`: 4 passed
  / 0 failed.
- Fail-capability control, durable in the script: `simulate_direct_fix` builds a throwaway git
  repository under `mktemp -d`, seeds a pre-existing genuine task record plus both targets, then makes
  one direct-fix commit. In the `opens-state-file` variant that commit also opens
  `logs/work-loop/arbitrary-state.md`, and the assertion requires the detector's output to equal that
  exact path — `3.1a  control: a state file opened by the direct fix is reported, by path`. It names
  the path; it is not an exit code and not a self-matching grep. The temporary repositories are
  removed at the end of the block, so nothing is written into the real `logs/work-loop/`.
- Legitimate-record control, durable, two forms. Simulated:
  `3.1a  control: a pre-existing genuine task record is not reported` — the `clean` variant carries
  `genuine-record.md` and the detector returns empty. Live:
  `3.1a  control: genuine task records opened since the direct fix, and it still passes` counts
  non-fixture files added to `logs/work-loop/` in `317c5dd..HEAD` and requires that count to be above
  zero, so the green above cannot be vacuous. It is 36 today.
- Both new checks were mutated and went red where predicted, which is what shows they can fail:
  (a) forcing the dirty simulation to open no state file →
  `FAIL 3.1a control: a state file opened by the direct fix is reported, by path` (298/2);
  (b) pointing `DIRECT_FIX_COMMIT` at `8434f34`, a commit that did add work-loop files →
  `FAIL 3.1a no state file was opened for the direct request`,
  `FAIL 3.1a the direct fix touched the two targets and nothing else in logs/work-loop/`,
  `FAIL 3.1a control: genuine task records opened since the direct fix, and it still passes` (296/4).
  Mutants were run from copies in a scratch directory; the tracked script was not mutated.
- New assertion beyond the repair: `3.1a  the direct fix touched the two targets and nothing else in
  logs/work-loop/`. The direct-fix commit's work-loop paths must be exactly `fixture-target.md` and
  `fixture-target-2.md`, so a renamed or otherwise altered state file is caught as well as an added one.

Changed paths — intended: `logs/scripts/work-loop-v2-slice-1.test.sh` (the repair and the controls),
`logs/improvement-log.md` (the source entry marked `applied 2026-08-13`, with the rejected prefix
mechanism recorded), and this state file. Incidental: none written by this unit. `logs/friction-log.md`
was already modified in the working tree when the session began and is deliberately left uncommitted
and untouched here.

Deferral, not done: the removed whole-directory inventory also happened to notice a stray state file
opened by any *other* Slice-3 scenario, not just the Direct Work one. The repair narrows the check to
the Direct Work behaviour it is named for, which is what the brief asked for. If broader cover is
wanted, it is a separate unit — most likely one commit-scoped check per scenario — and it is not
implemented here.

Final commit: the one commit of this unit, carrying all three changed paths, subject
`work-loop: axcion-harness-v0-2-normal-trial-1-replacement Unit 1 — scope the 3.1a inventory to the
direct-fix commit`. It is the head of branch `session/2026-08-13-readiness-fixes-2` at hand-back and
resolves with `git log -1 --grep 'scope the 3.1a inventory'`. Its hash is not written here because
recording a hash inside the commit that produces it cannot be done without a second commit; the
subject is unique in this history.

Operating facts for the normal-trial assessment:

- Reconstruction from durable sources: yes. The unit was rebuilt from this state file, the executable
  core at `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`, the test script, the go-live
  state file, the improvement-log entry and git history. No transcript or chat content from the prior
  candidate was needed or used.
- Fresh process: not verifiable from inside the session. The operator invoked `/work-loop-v2` in an
  interactive Claude Code session in VS Code; the visible conversation began with their handback
  message and the state-file path. Whether the process was newly launched is not something this side
  can confirm, and it is not claimed.
- Manual actor-to-actor context ferried: none beyond the state-file path in the operator's message.
- Operator interventions during the hop: one — the operator carried the turn by invoking the command.
  No permission prompt was denied and no further operator input was requested or given.
- Elapsed time: the checkout declared this task at 17:54 EEST and the hand-back was written at
  approximately 18:03 EEST on 2026-08-13, so roughly nine minutes.
- Loss of control or recovery events: none observed. The ownership check returned PROCEED, no gate
  fired, and no commit was refused.

## Blocker

None.

## Next action

Codex: assess Unit 1 against the required outcome — legitimate accumulated task records made
irrelevant to the Direct Work assertion, the unexpected-state-file failure signal retained and proven
fail-capable by path, both controls durable in the scoped script — and decide close, correct once, or
stop. Judge separately whether the operating facts above are enough to count this as Normal Trial 1.
