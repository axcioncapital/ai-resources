---
task: work-loop-v2-readiness-handoff-race
turn: codex
---

## Objective and scope

Prevent Codex from treating one temporarily stale Work Loop task-state snapshot as proof that Claude did not complete a hand-off. The correction must preserve the task file and its committed history as authoritative, while making Codex reconcile an operator's explicit `y` / `ur turn` claim with a conflicting visible state before it reports a mismatch.

Scope: the Work Loop v2 operator-shorthand authority, Codex-side handling, and proportionate regression coverage. Excluded: checkout binding, ownership transfer, courier or dispatcher implementation, polling or notification services, new state, the Claude-side execution flow, and unrelated Work Loop repairs.

## Lane and unit

Standard. Implementation mode. Unit 1 — reconcile a claimed hand-off before concluding absence.

Named reason for the loop: this changes a shared hand-off contract, needs a bounded implementation, and must be assessed by someone other than its implementer before it counts as corrected.

Repository-problem qualification: Lane A, test-backed. This is a bounded instruction-layer behavior with an existing authority and harness; the prior shorthand change did not attempt the exact reconciliation behavior. Stop and hand back if inspection instead finds hidden coupling, ambiguous authority, or a required new mechanism that makes it structural.

## Brief

The operator experienced two cases where Codex treated a momentary `turn: claude` read as proof that Claude had not completed work, even though the hand-off commit became visible immediately afterward. Commit `4800329c` partially addressed the incident by defining `y` / `ur turn`, but current research found that it did not add the conflict recheck or evidence-limited response. This unit closes only that gap and adds no transport or state machinery.

### Governing context

- `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` § 4 owns operator-shorthand semantics and the authority of the task-state file.
- `.agents/skills/work-loop-v2/SKILL.md` owns Codex's concrete response to `y` / `ur turn`.
- `logs/scripts/work-loop-v2-slice-1.test.sh` is the existing Work Loop v2 regression surface.
- `.claude/commands/work-loop-v2.md` is an inspection-only consistency surface for this unit. Do not edit it unless inspection proves the Codex-side correction cannot be made coherent without doing so; in that case, stop and hand back the conflict rather than widening scope.
- The preserved incident report is `/Users/patrik.lindeberg/.codex/attachments/0749297b-af62-4192-9006-ebdf25ddda94/pasted-text.txt`. Treat its proposed remedy as a claim to verify against the live repository, not as authority over the executable core.

### Check against the repository before acting

1. **Partial-fix claim:** inspect commit `4800329c` and the current core and Codex skill. Confirm that they recognize `y` / `ur turn` but still permit a mismatch to be reported after one state-file read, without checking the latest commit affecting that exact task file, rereading once immediately, or constraining the response to a discrepancy rather than a claim about Claude's activity.
2. **Absence claim:** search the current checkout, all local refs, registered worktrees, and uncommitted copies of the core, Codex skill, Claude command, and harness for an equivalent complete correction. Preparation on 2026-08-14 searched 15 local branches, 3 remote refs, and 18 worktrees and found none; revalidate enough live state to catch work that landed after that scan. If an equivalent fix or an active owner is now present, change no implementation file and hand back the exact ref, checkout, task, or diff.
3. **Authority claim:** confirm core § 4 remains the semantic owner of shorthand and the Codex skill remains the procedural owner. If authority has moved or conflicts, stop rather than duplicate the rule.
4. **Regression-gap claim:** confirm `logs/scripts/work-loop-v2-slice-1.test.sh` has no case that fails when Codex performs only one read or overclaims what Claude did.
5. **Isolation claim:** run the repository-depth ownership check required by the Claude Work Loop command and confirm no overlapping uncommitted edits exist in the three implementation surfaces. Preserve every unrelated change.

### Required outcome

1. When the operator says `y` or `ur turn` and the exact task file plus its latest affecting commit already agree that `turn: codex`, Codex proceeds normally.
2. When the operator's hand-off claim conflicts with visible repository state, Codex checks the latest commit affecting that exact task file and rereads the file once immediately. This is one bounded reconciliation, not polling, waiting, retrying Claude, or overriding `turn:`.
3. If the sources converge on `turn: codex`, Codex proceeds. If they still do not converge, Codex reports only the discrepancy and the resulting inability to assess—for example: `Your message says Claude completed the handoff, but it is not yet visible in this checkout. I cannot assess it until those sources converge.`
4. Codex must not infer or state that Claude has not completed the work unless specific process evidence establishes that separate claim. The durable source may prove what is visible and whose recorded turn it is; one snapshot does not prove Claude's live activity.
5. Preserve all existing boundaries: the task file and committed history remain authoritative; shorthand never overrides `turn:`; multiple matching tasks still require disambiguation; no new state field, artifact, service, watcher, courier behavior, repeated polling, or delay is introduced.
6. Put the semantic rule in the core and the minimum concrete procedure on the Codex side without copying whole procedures or creating competing authority.

### Implementation and evidence

Dominant deliverable: Work Loop v2 reconciles a claimed Claude hand-off once before Codex concludes that the durable hand-off is not visible.

Evidence required in this hop: add a focused regression block to `logs/scripts/work-loop-v2-slice-1.test.sh`, show it failing against the pre-change source for the diagnosed gap, then passing after the narrow core and Codex-skill correction; run the surrounding Work Loop v2 harness and report its actual pass/fail totals and exit code; show the final diff is limited to the authorized implementation surfaces plus this task file; quote the resulting persistent-conflict response and demonstrate that the contract still forbids shorthand from overriding `turn:`.

Evidence explicitly deferred: None.

Primary edit begins after: the focused readiness-race assertions fail against the current source because the one-read mismatch path, immediate reread, exact task-file commit check, and evidence-limited discrepancy response are not yet required.

Use the correction ladder in order: removal; simplification; restore the intended path; consolidate authority; narrow fix; new control. A narrow authority clarification plus regression protection is expected; if the confirmed cause requires more, stop and hand back.

Completion condition: the live premise check still shows the exact fix absent and unowned elsewhere; the targeted case is red before and green after; the core and Codex skill express one coherent bounded reconciliation; existing shorthand and Work Loop tests remain green apart from any explicitly preserved pre-existing failure; no excluded mechanism or file is changed; and Claude writes the result, executed evidence, rollback (`git revert <implementation-commit>` after integration), limitations, and commit into this state file for Codex assessment.

Stop conditions: any checked premise is false; equivalent work is present or active elsewhere; target files have overlapping uncommitted edits; the change requires a polling service, event channel, dispatcher/courier change, new state, or more than one immediate reread; authority is ambiguous; a safe failing case cannot represent the incident; or implementation would cross the stated scope. On a stop, change no implementation file, record exactly what was inspected and found, set `turn: codex`, commit the state-file hand-back only, and stop.

## Latest result

Inspected (2026-08-14):

- Claim (1) partial fix: HOLDS — read `git show 4800329c` in full and the current core § 4 *Operator shorthand* plus `.agents/skills/work-loop-v2/SKILL.md` § *The seam*. The commit adds shorthand recognition to both. Searched both files for `reread` / `latest commit affecting` / `discrepancy` / `converge`: no match. SKILL.md read literally "with none, report the mismatch" — one read, then a reported mismatch, which is the gap.
- Claim (2) absence: HOLDS — searched every local and remote ref (`git for-each-ref refs/heads refs/remotes`, 14 local branches + 3 remote refs) for `reread|latest commit affecting|cannot assess it until|converge` in the core, the Codex skill and the harness: zero hits. Repeated the same search across all 18 registered worktree working trees: zero hits. `git status --short` across those worktrees for the three surfaces plus the Claude command: no uncommitted copy anywhere. No equivalent fix and no active owner.
- Claim (3) authority: HOLDS — core § 4 carries the shorthand semantics (line 287); SKILL.md § *The seam* carries the procedure (line 166). Searched `.claude/commands/work-loop-v2.md` for `shorthand` / `ur turn`: three hits, all input-normalization that cites core § 4 rather than restating the rule. No competing owner.
- Claim (4) regression gap: HOLDS — searched `logs/scripts/work-loop-v2-slice-1.test.sh` for `reread|readiness|race|converge|latest commit|discrepancy|one read|single read` and for `shorthand|ur turn`: zero matches in 1673 lines. No assertion fails on a single read or an overclaim.
- Claim (5) isolation: HOLDS — `work-loop-owner.sh check --depth repo` returned PROCEED (this checkout already declares this task). `git status --short` on the four surfaces was empty before work began.
- Packaging lines: HOLDS — `## Lane and unit` records Implementation mode; all three universal lines present, `Primary edit begins after:` present as Implementation requires, `Dominant deliverable:` names exactly one deliverable, `Evidence explicitly deferred: None.` The completion condition asks for a built result, which matches the recorded mode.

Result: the bounded reconciliation is implemented. Core § 4 gained the semantic rule — on a conflict between the operator's shorthand claim and visible state, the receiving actor reconciles once (latest commit affecting that exact task file, then one immediate reread), proceeds if the sources converge, and otherwise reports only the discrepancy and the resulting inability to assess; no actor may state that the other has not completed its work without specific process evidence. `.agents/skills/work-loop-v2/SKILL.md` gained the concrete Codex procedure and the verbatim evidence-limited response, deferring to core for the rule ("Core § 4 owns the rule; this is the procedure"). The dead "with none, report the mismatch" clause was removed — it was the exact licence the incident used. No new state field, frontmatter key, artifact, watcher, courier or polling behaviour was added; the only occurrences of polling/waiting/retrying in the diff are prohibitions.

Evidence:

- Focused block `race` (13 assertions) added to `logs/scripts/work-loop-v2-slice-1.test.sh`.
- Red before: the final harness run against the pre-change core and skill (a detached `HEAD` worktree, with only the new harness copied in) failed all 10 new-behaviour assertions and passed the 3 preservation guards — `passed: 348   failed: 10`. The guards are meant to pass in both states; the 10 are the diagnosed gap.
- Green after: `bash logs/scripts/work-loop-v2-slice-1.test.sh` → `passed: 358   failed: 0`, exit `0`. Baseline before this unit was `passed: 345   failed: 0`, exit `0` — no pre-existing failure, and none introduced.
- Two assertions were corrected during the unit and are recorded rather than hidden: one matched a generic "exactly as core § 4 requires" already present in an unrelated dispatcher paragraph (it passed pre-change, so it proved nothing) and was re-keyed to text unique to this rule; one preservation guard spanned a line break. Three phrase assertions normalize whitespace before matching, so prose was not reflowed to suit a line-based grep.
- Persistent-conflict response, quoted from SKILL.md: "Your message says Claude completed the handoff, but it is not yet visible in this checkout. I cannot assess it until those sources converge."
- Boundaries preserved and re-derived: core § 4 still lists exactly 5 active content fields (`grep -c` = 5); "never permission to override `turn:`" now appears twice in core (lines 290, 299); the multiple-matching-task disambiguation clause is unchanged in SKILL.md.
- Diff limited to `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` (+18), `.agents/skills/work-loop-v2/SKILL.md` (+14/-1), `logs/scripts/work-loop-v2-slice-1.test.sh` (+49) and this task file. `.claude/commands/work-loop-v2.md` was inspection-only and is unchanged.
- Rollback: `git revert <implementation-commit>` after integration.

Limitations and deferrals:

- `logs/friction-log.md` is modified in the working tree by an ambient hook that logs write activity, not by this unit. It was deliberately left out of the commit. Recorded as a deferral: the ambient-writer interaction is already a known open item and is not this unit's scope.
- The negative-control worktree at `.../scratchpad/nc-wt` is still registered. `check-destructive-liveness.sh` refused to remove it because it holds the copied harness as uncommitted work and the guard cannot distinguish a scratch copy from a live session. The guard is correct to leave that to the operator; the directory is in the session scratchpad and `git worktree prune` clears the registration once it is gone. No repository content depends on it.

## Blocker

None.

## Next action

Codex: assess the implemented reconciliation against the six required outcomes and the stated evidence — in particular that the rule sits in core with only the procedure on the Codex side, that the one-recheck bound was not widened into waiting or polling, and that the removal of the "with none, report the mismatch" clause did not drop a case the shorthand still needs to handle.
