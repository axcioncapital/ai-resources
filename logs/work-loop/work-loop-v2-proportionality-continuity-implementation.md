---
task: work-loop-v2-proportionality-continuity-implementation
turn: operator
---

## Outcome

The accepted Work Loop v2 proportionality-and-continuity blueprint is implemented and accepted across
its S1–S7 sequence, in the governed dependency order, each slice separately committable with its own
proof case. The task's exit condition is met.

- **S1** — Work Loop v2 skill: activation narrowed, and the executable core read sequenced first.
- **S2** — executable core § 3: the *good enough, proceed* clause, making the 85–90% bar checkable
  rather than a matter of taste.
- **S3** — verification ownership, prose evidence, and a proportional inspection record.
- **S4** — checkout binding, isolation policy and fresh-task hand-off, with the cwd-first finding
  corrected in a follow-up round.
- **S5** — artifact-free project orientation.
- **S6** — post-compaction reorientation: four preservation pointers in `AGENTS.md` § *Compaction*,
  exactly one `SessionStart`/`compact` hook registration, and a small read-only fail-open script,
  made durably trackable by a narrow `.gitignore` negation ladder rather than a force-add.
- **Unit 6A** — P-7's live trial, run from Codex after a real root compaction; durable reorientation
  observed, and verified on the repository side.
- **S7** — dispatcher runtime evidence made collision-proof per plan § 4.8: the no-`--log-dir` default
  evidence directory is now bound to the checkout being driven, and run IDs no longer collide across
  same-second runs of the same task from different checkouts.

## Decisions that matter

1. **S6 entered normal operation at the core § 3 85–90% bar.** Its unregistered compaction control did
   not run: the extra operator trial and a temporary unregistration were disproportionate once live
   durable recovery, pointer retention, single-task orientation and deterministic fail-open behaviour
   had all been observed.
2. **S7's measured exit-`18` boundary is accepted as a written limitation, not a correction.** When
   the whole ancestor above the checkout-local evidence directory is untracked, git collapses the path
   and the pre-hop allowlist stops the run safely before any actor launches. The real repository shape
   passes. Both proposed fixes would change a guard or widen its allowlist beyond § 4.8.
3. **The third README edit is in scope.** S7 made the old allowlist claim newly reachable, so
   documenting the measured boundary truthfully is part of shipping the changed default.
4. **Removal of the now-unused `SPIKE_DIR` is deferred.** It is cleanup outside § 4.8 and is not
   required for correctness.
5. **Previously recorded deferrals are preserved:** an ordinary unnamed request still activates Work
   Loop v1; the Work Loop v2 skill's 340-line harness ceiling is stale/red and exceeded; any future
   P-4 run requires explicit isolated-checkout authority; the § 4.6 orientation paragraph may
   optionally be split for readability; and accepted plan § 4.9's `PostCompact` rationale needs
   correcting against current documentation, though its conclusion is unchanged.
6. **The .gitignore change reopened the 2026-07-13 non-tracking decision for exactly three files**, on
   the operator's explicit choice (a). The rest of the Codex mirror stays ignored and unmaintained;
   tracking those three does not adopt Codex.

## Evidence

**S7 implementation commit:** `23b6e3d` — *implement: work-loop-v2 S7 — collision-proof dispatcher
runtime evidence*. **Closing commit:** the commit carrying this record, *close: work-loop-v2
proportionality and continuity — S1–S7 implemented and accepted*.

**Earlier slice commits, for traceability:** `c27236e` (S1), `5680a44` (S2), `520f98e` (S3),
`b500c29` and `520ab51` (S4 and its correction), `309a1c0` (S5), `43b5743`, `42f3d7f` and `a4ce4c8`
(S6, its narrow tracking rule, and its record correction), `d641555`, `2829915` and `8cf2614`
(Unit 6A's witness preparation, restart and registered live result).

**P-5 and P-6 passed as matched red-to-green cases.** One harness was run twice — against the pre-S7
dispatcher extracted from `HEAD`, then against the changed one — on disposable git checkouts outside
this repository. P-5: checkout B's default evidence moved from the script's own directory to
checkout B. P-6: two same-task runs started in the same second from different checkouts stopped
sharing a run id, and their run logs, hop captures and unattended-settings files went from one file
each to two, counted by three separate globs rather than inferred from a single filename.

**All four controls held on both sides:** an explicit `--log-dir` still wins; `--status` names the
same directory a real run writes to; run-log names still begin with the timestamp and sort
chronologically; and a second dispatcher on the same checkout and task is still refused at exit `17`.

**The unchanged `dispatch.test.sh` reported 368 pass / 0 fail** before and after the change, identical
case by case. Its own case 0 points the suite at an absent dispatcher and asserts that the suite
fails, so that result is not a harness passing with its subject removed.

Every actor in the S7 harness and in the suite is a fake binary or a simulated command. This is
controller-logic evidence; none of it proves live product transport.

S6's deterministic witnesses and its red-before/green-after tracking table are in commit `42f3d7f`'s
state record. Unit 6A's live result, including the two hidden values recovered from disk after a real
root compaction, is in `8cf2614`.

## Accepted limitations

1. **S4's skill-fetch reads precede its `pwd` instruction.** No durable project or state read, and no
   mutation, sits before that instruction.
2. **P-4 remains unexecuted** under the operator's saved-Local-only constraint. No simulation replaces
   it.
3. **S6 proves durable recovery, not hook causality.** No hook-specific injection was separately
   visible after the registered compaction, and no unregistered control ran, so the trial does not
   show that the hook fired or that the outcome would differ without it.
4. **S7 carries a fail-closed untracked-ancestor boundary.** Where the whole ancestor above the
   checkout-local evidence directory is untracked, git collapses the dispatcher's own new evidence to
   a shorter path than the allowlist entry matches, and the pre-hop gate stops the run at exit `18`
   before any actor launches. It prints a recoverable next action, and it is documented in the spike
   README beside the paragraph it qualifies.

The Phase 2 descendant-supervision blockers are deliberately not listed here. They belong to their own
task records, and S7 did not change them.
