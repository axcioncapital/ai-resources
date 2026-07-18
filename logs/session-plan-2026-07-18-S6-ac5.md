# Session Plan — 2026-07-18

## Intent
Verify by execution whether mission threads 2, 4 and (stretch) 8 of `repo-health-backlog-2026-07` are still real and unfixed, then fix only those confirmed real — recording a cited decline reason for any found already-fixed, inert, or mis-diagnosed.

## Model
opus — match (active session is `claude-opus-4-8[1m]`)

The hard part is judging whether each backlog claim is still true, not executing a known fix. Thread 4 in particular requires designing a discriminating permission test and reasoning about layered settings precedence. Prior evidence that this is judgment work, not mechanical work: S5-531 found 2 of its 3 items mis-diagnosed in the backlog, and S4-8c3 dropped 12 of 22 candidates on verification.

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/missions/repo-health-backlog-2026-07.md` — the mission contract; threads 2, 4, 8 verbatim, plus the validation contract each fix is graded against
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md` — thread 2's subject; also carries thread 4's diagnosis and its falsifying data
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md` — Step 3 is the scan thread 2 says cannot reach 30 entries; the anchor regex is the thing under test
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/mission.md` — `/mission check` is the ONLY sanctioned way to tick a thread; hand-editing `## Open threads` is forbidden by the contract at `:12`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/settings.json` — ai-resources deny list
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/settings.json` — workspace-root deny rule at `:27`
- `/Users/patrik.lindeberg/.claude/settings.json` — user-level deny rule at `:47`; read to confirm, write only if thread 4 proves it necessary
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/permission-template.md` — canonical permission shapes; thread 4's structural home if the fix lands
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/friday-plans/2026-07-17-permissions.md` — the queued fix the mission says targets the WRONG rule; must be read before it is either run or retired
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` — risk-check change classes; permission edits are class-gated
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/run-manifest.sh` — thread 8 subject (stretch)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/run-manifest.test.sh` — thread 8 regression suite; has no midnight case (stretch)

## Findings / Items to Address

1. **Thread 2 — 30 improvement-log entries carry no `Severity` field, so the `/prime` Step 3 scan can never reach them.** (`repo-health-backlog-2026-07.md:79`.) The thread as written asks to widen the severity anchor; S5-531 established by execution that widening gains only 2 entries, both MED, and that the real gap is the 30 field-less entries — which no anchor can reach by construction. `/prime` Step 3 now reports the count in one bounded line (`prime.md`, third scan). **Open question this session must answer first: is the count still 30, and does an entry with no Severity field represent work that should reach the task menu at all?** The mission's acceptance assertion (`:55`) demands every entry be reachable *or provably out of scope by a stated rule* — the second branch may be the correct close.
2. **Thread 4 — `git checkout` is denied by name; the queued fix targets a rule the log's own data falsifies.** (`repo-health-backlog-2026-07.md:81`.) Denied at `~/.claude/settings.json:47` and workspace-root `.claude/settings.json:27` as `"Bash(git checkout *)"`. The logged diagnosis blames archive `Read()` deny patterns; that is falsified by the log's own record that `git add <archive>` and `git show ":N:<archive>"` both named the denied path and ran fine. `audits/friday-plans/2026-07-17-permissions.md` would ship against those Read patterns and leave git still blocked. **Load-bearing unknown, stated in the thread itself: does a `Read()` deny actually block a Bash command that merely names the path?** The fix design depends on the answer, so the test comes before any edit.
3. **Thread 8 (stretch, not committed) — `run-manifest.sh` cannot close a manifest across midnight.** (`repo-health-backlog-2026-07.md:85`.) `:156` re-derives `DATE` per invocation; `:166-168` trusts the marker only if dated today; `:171` dies otherwise. Reproduced once in a sandbox (start-stub dated 07-17, close on 07-18 → exit 2, stub never finalized). No midnight case exists in `run-manifest.test.sh`. Note this session already exercised `run-manifest.sh start` successfully, so the start path is sound; only the cross-midnight close is in question.

## Execution Sequence

1. **Thread 2 — verify.** Re-run the `/prime` Step 3 unclassified counter against the live log; re-derive the field-less entry count independently (do not trust the 30 from `/prime`'s own output — derive it a second way). Sample the field-less entries to classify what they actually are: genuinely open work, already-resolved records, or non-actionable notes. *Verification criterion: a count reproduced by two independent commands, plus a read of at least 5 sampled entries, with output pasted.*
2. **Thread 2 — decide and act.** If the field-less entries are genuinely open work → give them Severity fields. If they are predominantly records/notes → the honest close is a stated scope rule (mission assertion `:55` second branch), not 30 invented severities. Back up `improvement-log.md` to `scratchpad/backup/` before any bulk edit — `git checkout` is denied here, so git is not a reliable undo (this is thread 4's own consequence, live). *Verification criterion: post-edit Step 3 scan re-run, before/after line counts recorded.*
3. **Thread 4 — verify the blocking rule empirically.** Run `git checkout` in a harmless form and observe whether it is blocked. Separately test whether a `Read()` deny blocks a Bash command naming that path — the thread's stated unknown. Read all three settings layers and determine which rule actually fires and at which layer. *Verification criterion: the blocking rule identified by file:line with the observed block pasted; the Read-deny question answered yes or no by execution, not inference.*
4. **Thread 4 — design the fix, then gate it.** Permission edits are a structural change class → `/risk-check` before any settings write (Autonomy Rule #9). If the fix requires writing `~/.claude/settings.json`, STOP: that file is unversioned and outside any repo, and its backup design is carved out to thread 3's gated session. *Verification criterion: `/risk-check` verdict recorded; on GO, the block re-tested after the edit and shown to be gone.*
5. **Thread 4 — retire or correct the queued friday-act plan.** `audits/friday-plans/2026-07-17-permissions.md` is queued against the wrong target; leaving it runnable means a future session ships a no-op believing it fixed this. *Verification criterion: the plan file either corrected or explicitly marked superseded, with the reason.*
6. **Close the loop on both threads.** Tick via `/mission check` only — never by hand (`mission.md:12`). Flip the matching `improvement-log.md` entries; the mission's non-negotiable at `:66` makes flipping the entry part of the fix, not follow-up. *Verification criterion: `/mission read` shows the intended state.*
7. **Thread 8 (stretch, only if context allows).** Reproduce the midnight failure before touching the script; add the regression case to `run-manifest.test.sh` first, watch it fail, then fix. *Verification criterion: red-before/green-after, per the mission's standing rule.*

## Scope Alternatives

- **Min:** Thread 4 only (verify + fix the git-checkout block). It is the item with live operator friction — 5 logged occurrences, once freezing two sessions mid-merge — and it is blocking normal git work today.
- **Recommended:** Threads 2 and 4, verified then fixed, with both mission checkboxes and both improvement-log entries reconciled. This is the committed scope.
- **Max:** Add thread 8 (midnight manifest) if context allows after threads 2 and 4 are closed. Explicitly stretch — it is a rare, non-blocking defect, and taking it should never come at the cost of leaving 2 or 4 half-finished.

## Autonomy Posture
Gated

**Stop points:**
- Before ANY write to a settings file — `/risk-check` runs first (permission changes are a structural class per `audits/discipline`; Autonomy Rule #9).
- If thread 4's fix requires writing `~/.claude/settings.json` — hard stop, that is thread 3's carved-out scope and needs a backup design first.
- Before the bulk edit to `improvement-log.md` — take the backup first; git is not a reliable undo here.
- On any `/risk-check` verdict of RECONSIDER or NO-GO.
- If verification shows a thread is NOT real — stop fixing it, record the decline with cited output, and move on. Do not fix a defect that has already been fixed.

## Risk

Run `/risk-check` after the plan is approved (plan-time gate) and again before commit (end-time gate) — **for thread 4 specifically**, which edits permission deny rules across settings layers. That is a named structural change class.

Thread 2's bulk log edit is not a structural class, but it is a destructive edit to durable operator-facing content, and `git checkout` being denied (thread 4's own subject) means git cannot be relied on to undo it. Take a file backup before editing — the same precaution S5-531 took for the same reason.

Environment-fit check: not applicable — no launcher or terminal-triggered executable is planned. Thread 8's subject is an existing script invoked by commands already in the harness.

**Standing hazard for this session, from the mission's own non-negotiables:** every claim that a thread is fixed must cite a command and its output. This mission exists partly because logged claims went stale unnoticed. The failure mode to guard against is not "I forget to check" — it is that a plausible recollection is indistinguishable from an observation from the inside (`improvement-log.md`, 2026-07-14). Paste the output; do not summarize it from memory.
