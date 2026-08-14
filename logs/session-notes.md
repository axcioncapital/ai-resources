# Session Notes

> Archive: [session-notes-archive-2026-08.md](session-notes-archive-2026-08.md)

## 2026-08-12 — Work Loop v2 bounded-execution: correction round and task closure

### Summary
Ran Claude's half of Work Loop v2 twice against task `work-loop-v2-bounded-execution-verification`
— first the one bounded correction round on Codex's three frozen findings, then the closing record
after Codex returned its close verdict. Two of the three findings were real and are fixed (the exit
taxonomy in the canonical Work Loop skill, and four statements that wrongly claimed nothing is
denied without `--claude-deny`). The third did not reproduce: the 15 failing 27-series harness cases
were control assertions probing whether the host permits process-group inspection, not a merged
regression, and the full integrated harness is green at `pass=454 fail=0` in the normal supported
environment. The task closed as technically verified and cleared for its separately authorised
single attended pilot — which is explicitly not part of this task.

### Decisions Made
**Correction round (commit `07bcf96`)**
- Corrected `SKILL.md:277` and `:289` to name exit `37` as the permission dead end, and added `35`
  as the ownership stop with its own remedy plus a pre-2026-08-11 reading note. SKILL.md was the
  only live instruction surface still carrying the wrong mapping — the other three
  bounded-execution surfaces and `docs/parallel-sessions-playbook.md` were already correct.
- Made no repair for finding 2. The reviewers' failures were control assertions, not dispatcher
  behaviour, and every one passes here. Repairing a non-defect was rejected.
- Corrected four deny-policy statements (`dispatch.sh:36`, `dispatch.sh:1382`, `README.md:183`,
  `README.md:973`) to say that `none` means the operator supplied no extra rule. The default deny
  set was neither widened nor removed and no containment claim was added.
- Included the ownership codes `33`,`34`,`35` in SKILL.md's stop-code list rather than only removing
  the wrong `35`. Naming `35` correctly prevents a future reader re-deriving the retired mapping;
  the alternative (leave `35` unmentioned) would have been silent rather than wrong.

**Closure (commit `86aace2`)**
- Wrote Codex's close verdict into the core § 4 closing record without re-judging it, per the
  command's closing rules. Cleared the checkout declaration in the same move, so the checkout is
  free for the next task.

**Process decisions**
- Discarded two harness runs because `dispatch.sh` was edited while they were in flight; run 3 is
  the only clean one. Reporting a green suite from a mixed run would not have been honest evidence.
- Declined to add a harness assertion pinning the corrected `claude_deny=none` wording. The
  correction boundary excluded case 31b and limited the method to static inspection plus one
  integrated harness run; recorded as a deferral in the closing record instead.

### Risky actions
None. No destructive git operation, no push, no external write. The two commits are local. The
`work-loop-owner.sh clear` at closure removes a gitignored declaration and is a no-op on a checkout
that holds none.

### Findings Declined
- **Edited `dispatch.sh` while a ~1h harness run was in flight, twice** — cost two discarded runs.
  Declined rather than queued: it is a session-craft lesson with no repo artifact to fix, and the
  practice (freeze the files under test before starting a long suite) is recorded in the session
  scratchpad where the next session will read it.
- **Backgrounded `sleep N; check` returned its task id instantly**, so progress polling ran
  immediately instead of waiting — I believed I was polling every 30 minutes while polling every few
  seconds. Declined for the same reason: no artifact to fix, and the working idiom (a backgrounded
  `until ! pgrep -f "<proc>"; do sleep 20; done`, which fires one notification on exit) is in the
  scratchpad.

Findings: 3 — queued 1 (severity: medium), declined 2. 1 + 2 = 3.

### Next Steps
The next operational step is the **single bounded attended pilot** defined by the governing plan.
It is separately authorised and was explicitly excluded from this task — the task closed at
*technically verified*, not *operationally resolved*. Do not read the closed state file as pilot
authorization.

Before the pilot: nothing outstanding from this session. Two commits await the wrap push gate.

### Open Questions
None.

## 2026-08-12 — axcion-harness v0.2 live trial: Work Loop v2 Units 3–5, task closed

### Summary
Ran Claude's half of Work Loop v2 for task `axcion-harness-v0-2-live-trial` across three units in
this isolated worktree checkout. Unit 3 forensically established that the prior session's interrupted
live actor left no repository effect and no surviving process. Unit 4 diagnosed the real blocker as
one over-narrow `--allow-path` argument rather than a carrier or hook defect, and designed the
smallest safe correction. The operator then ran the canonical `carry-turn.sh` launcher directly,
three separate live hops (`claude → codex`, `codex → claude`, `claude → operator`), all `exit=0`.
Codex accepted Unit 5's evidence and closed the task, judging the project plan's Phase 2 attended
vertical-slice exit condition met.

### Decisions Made
- **Unit 4 correction: widen the carrier's `--allow-path` at the invocation, not in code.** Verified
  read-only by reproducing the carrier's own `foreign_worktree()` filter against live `git status`
  before recommending it; the carrier already supported repeatable `--allow-path` values and its own
  failure message named this fix. No launcher, hook, or test file was touched.
- **The second ambient writer (`detect-innovation.sh` → `logs/innovation-registry.md`) was found and
  left unfixed, deliberately.** It is silent for state-file-only units and would only reproduce the
  same false-stop shape once a future unit edits a `.claude/commands|agents|hooks/` file. Recorded as
  a deferral in the Unit 4 handback; not carried into the closing record as an open item — flagged
  here so it isn't lost.
- **Operator ran both live carrier invocations directly**, on Claude's recommendation, rather than
  Claude launching them — no-retry risk (one shot, no second attempt authorized) and evidence purity
  (the brief named the operator as launcher; Codex needed to be able to trust the carrier's own
  screen, not a nested Claude session's).
- Task closed by Codex's verdict, not Claude's — Claude wrote and committed the closing record per
  Work Loop v2's role split (Codex assesses and closes, Claude never decides closure).

### Outcome
Outcome check skipped (not requested).

### Session Value Audit — 80/20 Review
Skipped (not requested).

### Risky actions
None — the only actions taken by Claude were read-only repository inspection and committing exactly
the task's own state file, by exact pathspec, each unit. The two live actor launches (Unit 5 and the
close) were run by the operator directly, outside Claude's process, per the brief's own boundary.

### Next Steps
Task `axcion-harness-v0-2-live-trial` is closed — no further Work Loop action is pending on it.
Three items remain operator-owned and were deliberately left undecided by the closing record: (1)
whether to fix the second ambient-writer deferral (`detect-innovation.sh`) now or wait for a unit
that trips it; (2) integration into `main`, push, and worktree removal/retention for this trial
checkout; (3) whether a further phase of Harness v0.2 work opens as a new Work Loop task.

### Open Questions
None.

## 2026-08-13 — Axcíon Harness v0.2 goes live for normal attended pilot use

### Summary
Direct-route session (no `/prime`/`/session-start`) running Claude's half of Work Loop v2 task
`axcion-harness-v0-2-go-live` across two units and closure, via `/work-loop-v2` invoked three times.
Unit 1 rewired the live Codex Work Loop skill's attended courier route from the spike dispatcher to
the canonical carrier `scripts/axcion-harness-v0.2/carry-turn.sh`. Unit 2 (Adoption-mode discovery)
inspected the accepted evidence and recommended adopting the carrier for normal attended pilot use.
The operator accepted and issued the close verdict; Claude wrote the closing record. Net effect: the
live Work Loop v2 instructions now actually select the canonical carrier for an attended carry, for
the first time.

### Decisions Made
- **Unit 1 route change** — Codex-framed, Claude-implemented, Codex-accepted: attended courier
  invocation in `.agents/skills/work-loop-v2/SKILL.md` moved from
  `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` to
  `scripts/axcion-harness-v0.2/carry-turn.sh`, with exact `--checkout`/`--task` inputs and a
  per-task-derived four-line `--allow-path` set. Unattended routing to the spike dispatcher preserved
  unchanged, in its own subsection.
- **Unit 2 lifecycle recommendation, operator-accepted** — adopt for normal attended pilot use, single
  checkout/single writer, one hop per invocation; not unattended, not concurrent, not final Phase 3
  adoption. Three Unit 1 deferrals ruled: untracked `logs/harness-runs/` accumulation and absent
  route-regression check are nonblocking pilot limitations; absent carrier-level cross-worktree
  ownership check is nonblocking *only* for single-checkout/single-writer use.
- **Operator ruling on the new finding** — the `logs/innovation-registry.md` ambient-writer gap
  (a second hook-owned path the documented allow-path omits) is a safe-stop limitation, not a release
  blocker: an affected task stops before launch, nothing runs or changes. Routed as small Direct Work
  for later, not fixed this session.
- **Closure** — operator issued the close verdict; routine decisions on record shape (four-heading
  closing record, ownership-declaration clear) were Claude's per core § 3/§ 4, not separately flagged.

### Outcome
Outcome check skipped (not requested).

### Risky actions
None. Every route-check assertion was verified against both the pre-change file (must fail) and the
post-change file (must pass) before being trusted; two existing regression suites
(`work-loop-v2-core-resolver.test.sh`, `work-loop-v2-slice-1.test.sh`) were re-run and their result
counts compared before/after rather than assumed unaffected.

### Findings Declined
None — no findings surfaced this session beyond the two already queued as deferrals inside the
closed Work Loop task record itself (the innovation-registry allow-path gap and the intermittent
stale-marker staging tripwire), which live in `logs/work-loop/axcion-harness-v0-2-go-live.md`'s
closing record rather than in `improvement-log.md`, per the task's own disposition.

### Next Steps
- Start routing real pilot tasks through `/work-loop-v2` using the now-live attended carrier
  (`scripts/axcion-harness-v0.2/carry-turn.sh`) to accumulate the Phase 3 real-task evidence set
  (`plans/axcion-harness-v0.2/mvp-plan.md` § Real-task proof).
- Small Direct Work, low urgency: add `^logs/innovation-registry\.md$` as a fourth fixed
  `--allow-path` line in `.agents/skills/work-loop-v2/SKILL.md` § *Courier mode*.
- Not urgent: revisit `logs/harness-runs/` (gitignore, or move `--log-dir` outside the repo) before
  final Phase 3 adoption.

### Open Questions
None.
## 2026-08-13 — Work Loop v2 compaction-survivability repair, Units 4–6 and closure

### Summary

Ran Claude's half of Work Loop v2 units 4–6 for task `work-loop-v2-compaction-survivability-repair`,
then closed the task on Codex's verdict. Unit 4 extracted the routing-index lookup content into one
referenced file and aligned the acceptance harness's guard to it. Unit 5 corrected the instruction
layer's overbroad "Codex never runs git" wording to state the real boundary (never mutates; read-only
permitted and bounded). Unit 6 was a read-only discovery that mapped deployment surfaces and
overturned a brief premise: the three candidate "projects" are one repository in three worktrees, and
the Work Loop is currently unrunnable in any of them because a required helper script is absent.

### Decisions Made

- Unit 4: accepted Boundary A (SKILL.md L366–465) as the extraction scope; index checks repointed to
  the new reference file, the 13 frontmatter/behavior/admission checks rebound to `SKILL.md`, ceiling
  re-based 340 → 116. Committed `a22b54b`.
- Unit 5: corrected 8 wording sites across two files to state Claude-only Git mutation/commit
  ownership with Codex's read-only inspection permission explicitly bounded against displacing
  Claude's evidence duty. Committed `891a991`.
- Unit 6 (discovery, no implementation): reframed the deployment scope from "three projects" to "one
  repository, three worktrees"; surfaced a hard blocker (`logs/scripts/work-loop-owner.sh` absent from
  every project checkout); explained the two previously-unexplained skill links as hand-made
  2026-08-10 fixes masking a missing manifest declaration; left the user-vs-repo hook precedence
  question open. Committed `2e9952a`.
- Operator/Codex: resolved the hook-precedence question (user and repository hooks aggregate, so the
  later user-level registration must replace or suppress the repo-level one); approved closing this
  branch-bound task and promoting its committed work to `ai-resources/main` (no push), with
  installation and the representative compaction proof continuing in a new main-bound Work Loop task.
- Closed the task: reduced the state file to the four-section closing record, cleared the checkout's
  `.owner` lease, committed `486ad78`.

### Outcome

Outcome check skipped (not requested).

### Risky actions

None.

### Next Steps

1. Merge this branch's committed work (`a22b54b`, `891a991`, `2e9952a`, `486ad78`) into
   `ai-resources/main` — required before any project checkout reads the corrections, since project
   skill links and the stable hook carrier path resolve into `main`.
2. Open a new, main-bound Work Loop v2 task for: installing `logs/scripts/work-loop-owner.sh` into the
   three project checkouts; declaring `reorient` (and the missing `skills` block on the two session
   branches); adding the 5-field AGENTS.md preservation contract plus its canonical template fragment
   and `/new-project` consumer; writing `~/.codex/hooks.json` with a single-effective-trigger
   `SessionStart`/`compact` entry; and running the representative compaction proof against
   `axcion-systems-builder` (main worktree).
3. Do not copy or reopen the now-closed state file for this task.

### Open Questions

None — the one open unknown from Unit 6 (hook precedence) was resolved by Codex before closure.

### Findings Declined

- Whether the Git-boundary wording should get a permanent regression assertion in the acceptance
  harness — declined as a standalone improvement-log item; it is an open design choice already
  surfaced and left to Codex's judgment inside the now-closed task record, not a repo defect.

### Review status

All skill and harness edits this session (Units 4–5) were made under the Work Loop v2 protocol, whose
own mechanism requires Codex's independent assessment of every unit before it is accepted or closed —
each unit here was assessed and, for Unit 5, correction-round-eligible before acceptance. That
assessment is the independent review this session's structural edits received; no separate review was
sought or needed.

## 2026-08-13 — Replacement Normal Trial 1: 3.1a regression repaired, run not accepted as the trial

### Summary
Ran the replacement candidate for Axcíon Harness v0.2 Normal Trial 1 end to end through
`/work-loop-v2` against `logs/work-loop/axcion-harness-v0-2-normal-trial-1-replacement.md`: Claude
implemented Unit 1, Codex assessed and closed with no correction round. The `3.1a` block in
`logs/scripts/work-loop-v2-slice-1.test.sh` no longer reddens on ordinary repository growth — it is
now scoped to the single commit that performed the direct fix rather than the whole live
`logs/work-loop/` directory — while the unexpected-state-file failure signal it exists to protect
stays durable and provably fail-capable by path. Suite moved 292 passed / 3 failed → 299 passed / 1
failed (the remaining failure is the pre-existing, unrelated `ridx` line-count ceiling). Codex's close
verdict explicitly rules this execution does not count as Normal Trial 1: the canonical attended
carrier was not used and process freshness could not be verified.

### Decisions Made
- **Rejected the improvement-log entry's proposed `fixture-`-prefix mechanism** as the repair
  mechanism. Checked by inspection: 4 of the 29 entries in the old closed set carried no `fixture-`
  prefix, and adopting the prefix rule would ignore every non-fixture file — including
  `logs/work-loop/arbitrary-state.md`, the exact unexpected-state-file case the `3.1a` block was
  strengthened to catch. Scoped the check to the direct-fix commit instead.
- **Codex's close decision:** accept the implementation without a correction round, but rule the
  execution does not count as Normal Trial 1 — a framing limitation on this run, not an implementation
  finding, and explicitly not repairable by a correction round.
- Routine: both closing writes (Claude's Unit 1 hand-back, the final closing-record reduction) ran the
  Step 1.5 ownership check first; both returned PROCEED.

### Outcome
Outcome check skipped (not requested).

### Session Value Audit — 80/20 Review
Skipped (not requested).

### Risky actions
None. Both commits were preceded by a passing ownership check; no gate was skipped; no destructive or
external action was taken.

### Session Assessment
Feedback collection skipped (not requested).

### Findings Declined
- Broader per-scenario stray-state-file coverage (the removed whole-directory `3.1a` inventory
  incidentally noticed a stray state file opened by any Slice-3 scenario, not only Direct Work) — not
  queued. Already recorded as a deferral with its reason in the closed task's Decisions that matter;
  it is optional future scope, not a defect, and has no named consequence today.

### Next Steps
Continue the pilot toward Phase 3 adoption evidence: the next Normal Trial 1 attempt should run
through the canonical attended carrier (`scripts/axcion-harness-v0.2/carry-turn.sh`) rather than a
direct `/work-loop-v2` invocation, so process freshness and reduced manual transport can actually be
demonstrated. `plans/axcion-harness-v0.2/mvp-plan.md` still needs three to five representative tasks
before the adopt/shrink/stop decision.

### Open Questions
None.

## 2026-08-13 — Close axcion-harness-v0-2-readiness-fixes: Units 1-6 accepted, no successful live trial

### Summary
Ran the Claude half of the final Work Loop v2 unit on `axcion-harness-v0-2-readiness-fixes`. The
state file's `## Next action` carried Codex's close verdict, so this was a closing write: checked
file identity, ran the repo-depth ownership check (PROCEED), verified every commit reference and the
Unit 7 evidence path resolve on disk, reduced the file to the closing record, cleared the checkout's
ownership declaration, and committed. The task is now closed.

### Decisions Made
None made this turn — the close verdict was Codex's, recorded in the inherited `## Next action`.
Writing the closing record was execution of that verdict, not a new decision.

### Outcome
Outcome check skipped (not requested).

### Risky actions
None.

### Findings Declined
- `logs/friction-log.md` dirty again — not queued. Already an accepted deferral on the readiness
  task's own list ("hook-owned `logs/friction-log.md` dirt"); no new consequence surfaced this
  session.

### Next Steps
No follow-on unit is open for this task. A future push on the attended carrier's supervised
readiness — closing the authoritative-current-position refusal gap, or running a real live trial —
starts as a fresh admission decision (Direct Work or a new Work Loop v2 task), not a reopening of
this closed file.

### Open Questions
None.

## 2026-08-13 — Merged 59 commits into ai-resources, resolved the improvement-log conflict, pushed

### Summary

Unplanned session, opened by a question relayed out of a concurrent `axcion-si-worktrees` session:
ai-resources had unpushed commits it had not authored and would not push blind. Investigated all of
them (7 at first look, 8 after that session committed a ninth finding mid-investigation) — all
operator-authored, all but one touching `logs/improvement-log.md` only, all pure appends. The material
finding was one the concurrent session had not surfaced: after `git fetch`, the repo was **8 ahead and
59 behind**, so any push would have been rejected as non-fast-forward.

The concurrent session recommended deferring the whole merge to Friday, reasoning from `.gitattributes`
(which deliberately excludes `improvement-log.md` from `merge=union` because that file takes prepend
writes and in-place status flips). Measuring the actual range showed the hazard was absent from it:
remote +207/−0, local +177/−0 — pure additions on both sides, no overlapping entries, so "keep both
sides" was mechanical rather than judged. That measurement was relayed back, independently verified by
the concurrent session, and its recommendation withdrawn. Merged as `b2a7032`, verified against both
parents, pushed `375e61d..b2a7032`. Repo is now 0 ahead / 0 behind.

Also traced the improvement-log heading-level divergence the concurrent session flagged. Its stated
premise — that `/prime` builds its task menu by grepping these entries — was wrong; `/prime` touches the
file only as a `git status` pathspec. The real consumers, and the real (smaller) impact, are queued as a
finding.

### Decisions Made

- **Merge now rather than defer to Friday**, against the concurrent session's recommendation — on the
  grounds that the drop risk was measurable and measured at zero, and that deferring only raises the
  cost (the next in-place status flip on either side turns a mechanical resolution into a hand-resolved
  one). Logged to `logs/decisions.md`.
- **Split the deferral rather than accept or reject it whole** — the analytical half (reading the 59
  merged commits for retirements bearing on today's findings) stays deferred to Friday; only the
  mechanical half was pulled forward.
- **Resolved the conflict by removing the three marker lines and nothing else** — no reflow, no
  reordering, no heading normalisation folded in — so the merge commit stays exactly verifiable against
  a stated line count.
- **Did not fix the heading divergence in-session**, though it was diagnosed here: it is an in-place
  edit to the one file with a live concurrent writer, which is the hazard `.gitattributes` excludes it
  for. Queued instead.
- **Used the correct local path for the Step 6.6 promotion sweep** rather than the command's hardcoded
  literal, which points at a non-existent account on this machine. Queued as a finding.

### Risky actions

Pushed to `origin/main` (operator-approved, explicit `y`). Merge touched a log file with a live
concurrent writer in another checkout — mitigated by resolving mechanically and verifying against both
parents before committing. No force-push, no history rewrite, no deletion. The Step 6.6 promotion sweep
would have failed silently on the documented path; it was run on the corrected path instead and
promoted 4 findings that would otherwise have stayed unreachable.

### Findings Declined

- **Six untracked July files in `audits/`** (one lean-repo report, five risk-checks) — surfaced to the
  operator twice this session. This is an operator housekeeping decision (commit or gitignore), not a
  system defect, and the only consequence is `git status` noise. Declined rather than queued.

### Next Steps

1. `/fix-repo-issues` or a dedicated session for the two findings queued today — heading normalisation
   (run only when ai-resources has no other live writer) and the `wrap-session.md` hardcoded path.
2. Friday: read the 59 merged commits for retirements bearing on the `/qc-pass`, `/risk-check`,
   `/resolve`, `/refinement-deep` follow-through findings logged today by the concurrent session.
3. Decide on the six untracked `audits/` files.

### Open Questions

## 2026-08-14 — Closed eval-v0-3-restart via /work-loop-v2

### Summary
Ran the Claude half of the final Work Loop v2 unit on `eval-v0-3-restart`. The state file's
`## Next action` carried Codex's close verdict, so this was a closing write: resolved the task from
the one non-fixture state file at `turn: claude`, ran the repo-depth ownership check (PROCEED),
reduced the file to the closing record (Outcome / Decisions that matter / Evidence / Accepted
limitations), cleared the checkout's ownership declaration, and committed. The task is now closed.
Outcome recorded: **PARTIAL** on the first live EV-3/CE-9 paired trial — Layer A held, Layer B did
not fully hold on the full-objective and current-state dimensions.

### Decisions Made
None made this turn — the close verdict was Codex's, recorded in the inherited `## Next action`.
Writing the closing record was execution of that verdict, not a new decision.

### Outcome
Outcome check skipped (not requested).

### Risky actions
None.

### Next Steps
No follow-on unit is open for this task. Adoption of the EV-3/CE-9 procedure remains a later,
separate operator decision based on the recorded PARTIAL operating evidence — not a reopening of
this closed file. Two prior deferrals stay parked: account-side plugin-catalogue repopulation and
unreported reasoning-effort parity, both to reopen only if later evidence makes either consequential.

### Open Questions
None.

## 2026-08-14 — Work Loop v2: closed eval-v0-3-partial-fixes, corrected CE-9 continuation-integrity gap

### Summary
Ran Claude's half of the Work Loop v2 unit `eval-v0-3-partial-fixes`, then the closing invocation once
Codex assessed and closed it. The task corrected the two misses the prior `eval-v0-3-restart` PARTIAL
result exposed: a continuation brief must carry the approved project objective and the exact
authoritative current-state position into the brief itself, not only establish them internally. Fixed
with two wording insertions in `.agents/skills/work-loop-v2/SKILL.md` (four changed lines), proved with
eight new red-then-green assertions added to `logs/scripts/work-loop-v2-slice-1.test.sh` before the edit
landed (302/6 red, 308/0 green; baseline 300/0), and checked against the preserved Run B transcript
read-only — both duties failed under the pre-fix contract, as expected. No CE-9 command, scenario or
model turn ran, per the operator's explicit prohibition on rerunning the trial.

### Decisions Made
- **Codex's close verdict, not a Claude decision:** the scope-section deferral raised at hand-back
  (whether `## Scope of this version` needed a dated entry) was closed as **not owed**, not carried
  forward — that section records capability additions, and this correction implements already-approved
  CE-9 meaning rather than adding one.
- **Codex corrected the evidence count in the closing record:** the committed diff carries eight new
  CE-9 assertions total (six carry-duty, two over-correction guards); the exact-once check is one of
  those eight, not a ninth. Applied verbatim into the closing record.
- Routine: two commits made directly on the state file and the corrected surface, per the Work Loop v2
  core's "Claude makes every commit" rule — no separate approval sought for either.

### Outcome
Outcome check skipped (not requested).

### Risky actions
None.

### Next Steps
No follow-on unit is open. `eval-v0-3-partial-fixes` is closed (`turn: operator`); the checkout's
`logs/work-loop/.owner` lease was cleared in the same closing write, so this checkout is free for the
next task. Whether the EV-3/CE-9 procedure is adopted for routine use remains a later, separate operator
decision grounded in the recorded PARTIAL evidence — not something this correction reopens.

### Open Questions
None.

## 2026-08-14 — Work Loop v2 unit-packaging and hop-termination fix, three-round independent review

### Summary
A pasted incident report described a real 2026-08-14 Work Loop v2 failure: a helper-plus-first-consumer
unit timed out at 902 seconds, and a correctly narrowed follow-up unit spent 593 seconds re-establishing
accepted baseline evidence and exited having changed nothing after Claude ended the hop on a progress
note ("waiting for the baseline run to finish"). Ran `/develop-ai-resource` to qualify and build a fix.
Verdict: improve two existing resources, not build a new one. Edited `.agents/skills/work-loop-v2/SKILL.md`
(Codex side — new split triggers, a rule against front-loaded baseline evidence, and mode-dependent
packaging lines required inside every brief) and `.claude/commands/work-loop-v2.md` (Claude side — a hop
must end in a written outcome or an explicit refusal, never a progress note; required evidence cannot be
silently downgraded to a deferral). The operator ran three rounds of independent review in place of the
unreachable Codex reviewer, each on both a Standards and a Spec axis; every finding across all three
rounds was adopted. Shipped as commit `16de1622`.

### Decisions Made
- **Route through `/develop-ai-resource` rather than straight to `/improve-skill`**, because the
  system-fit question (core doc vs. skill vs. command — which artifact should own the anti-progress-only-
  termination rule) was genuinely open, not settled. Confirmed by inspection: neither the core doc, the
  skill, nor the command had any prior coverage of background-process termination.
- **Ship two edits, not a new resource.** Rejected "restate the guidance more strongly" as sufficient —
  the existing § *Size the unit against the clock* guidance was already the 2026-08-11 fix for the same
  failure class, and this incident is that fix recurring. The structural half (mode-dependent packaging
  lines Claude checks and refuses on) is what makes this attempt different from the last one.
- **Round 1 fixes (operator review):** written-state contradiction between "every invocation ends in
  written state" and refusal-must-change-nothing — corrected to split the invariant by admission status.
  Enforcement widened from checking one packaging line to all four. Harness evidence added (37 new checks,
  negative-control-verified against pre-change files). 500-line SKILL.md budget breach — corrected
  attribution (pre-existing at 552 lines, not caused by this session) and parked rather than fixed inline.
- **Round 2 fixes (operator review):** the mandatory `Primary edit begins after:` line was made
  mode-dependent (Implementation only) after the operator caught that Discovery/Adoption units make no
  primary edit and would have been permanently deadlocked by the requirement. Outcome list rewritten as
  generic rather than an incomplete enumeration that had silently dropped closing/correction/de-escalation.
  Refusal invariant corrected from "no state file was opened" to "no state-file write" (identity/ownership
  checks necessarily read the file). Claude may not unilaterally downgrade required evidence to a deferral.
  Improvement-log entry rebuilt to the full schema (Category/Severity/Proposal/Review-cycle with a concrete
  trigger). **Self-caught in this round, not by the operator:** the harness's own pre-existing regression
  check failed because the fix's wording invented "Adoption unit" as a new unit kind — Adoption is a mode
  fitted onto the existing discovery-unit kind per core § 3. Corrected throughout.
- **Round 3 (bounded cleanup per explicit operator instruction, no new tests, no further broad review):**
  "Four lines" renamed to "mode-dependent packaging lines" to match the mode-dependent count. Implementation's
  fourth line now accepts a quoted before-state where no meaningful failing test exists (matches core § 3's
  existing refusal of ceremonial tests for prose/documentation changes). `Evidence explicitly deferred:`
  formally defined to take `None.` rather than being droppable. Written outcomes scoped explicitly to
  invocations that pass the refusal gates. Operator accepted the resulting 580-line SKILL.md overrun
  explicitly, recorded in `improvement-log.md`. Runtime proof deferred to the next real dispatched hop.

### Risky actions
None — no destructive, irreversible, or external action was taken. Push was not run mid-session (correctly
deferred to this wrap per the gated-push rule).

### Findings Declined
None — every finding raised in this session's three review rounds was adopted; nothing was declined.

### Next Steps
Run `/work-loop-v2` on the next real unit (the open `work-loop-v2-concurrency-repair-proposal` task, or
whichever the operator opens next) to get the first genuine runtime evidence that the new packaging-line
enforcement and hop-termination rule hold under an actual dispatched hop — the harness only proves the
rules are worded as intended, not that Claude obeys them live. Expect one handback: the currently open
task predates the new contract and carries no packaging lines, so it will bounce once as a false premise
before Codex repackages it — that is the new contract working, not a defect.

### Open Questions
None.

## 2026-08-14 — Closed Work Loop v2 task: readiness-handoff-race

### Summary
Ran Claude's half of one Work Loop v2 unit via `/work-loop-v2`, on Codex's close verdict for task `work-loop-v2-readiness-handoff-race`. Two live state files carried `turn: claude`; since neither the operator's shorthand nor an explicit task id was given, listed both and asked which — operator confirmed the readiness-handoff-race task with its close verdict text. Validated file identity, ran the repo-depth ownership check (PROCEED), reduced the state file to the four-heading closing record, cleared the checkout's task declaration, and committed.

### Decisions Made
Routine: proceeded with the closing invocation exactly as Codex's `Close the task:` verdict specified — no re-judgment of the verdict, per the executable core's "Codex closes, Claude writes and commits" division.

### Risky actions
None.

### Next Steps
Operator decision pending: merge `session/2026-08-14-work-loop-v2-fixes` into `main` (23 unpushed commits, branch is READY FOR OPERATOR-AUTHORIZED MERGE per the closing report) — not something this command performs. Two residual items flagged in the closing record: (1) `logs/friction-log.md` carries an ambient hook-driven modification excluded from every commit in this task; (2) the negative-control scratch worktree at `.../scratchpad/nc-wt` is still registered — remove the directory and run `git worktree prune` when convenient.

### Open Questions
None.
