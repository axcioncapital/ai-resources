---
task: project-progression-live-continue-proof
turn: codex
---

## Objective and scope
Resolve the one material finding frozen by the fresh-context Codex review on 2026-08-06: the live
Work Loop v2 project-progression candidate demonstrates the static shape and classification of a
`Continue`, but does not yet demonstrate Codex producing the hand-off and Claude executing the next
unit. Preserve the operator-approved design direction: owner-first routing, native project phases,
the seven-state spine only as a fallback diagnostic, `Continue` for multi-unit tasks, and no
standalone protocol, universal lifecycle, second state system, or new Claude-command lifecycle logic.

The operator explicitly authorises candidate `6ba4c3f` as the implementation baseline and overrides
the Work Loop v2 no-self-hosting rule for this bounded project-progression task. That permission is
not adoption of the candidate.

Scope: the `cont`/`rout` evidence in `logs/scripts/work-loop-v2-slice-1.test.sh`; the minimum existing
fixture surface, or one minimum fixture of an existing kind, needed for a genuine two-unit proof;
`plans/work-loop-v2-mvp/project-progression-candidate-review.md`; the factual project-progression
status notes in `logs/decisions.md` and `logs/missions/work-loop-v2-mvp.md`; and this state file.

Excluded by Codex's framing decision: changes to `.agents/skills/work-loop-v2/SKILL.md`,
`plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`, or
`.claude/commands/work-loop-v2.md` unless the live proof exposes a blocking defect in one of them;
the unrelated `3.1a` closed-set failures; a standalone project-progression protocol; a universal
lifecycle; any second state system or review layer; installation and propagation; the broader v0.2
rework; the historical Step 6 acceptance record; candidate adoption; pushing; and unrelated cleanup.
Reason: none is needed to test the cross-actor `Continue` seam, and this task is the bounded
self-hosting exception the operator authorised.

## Lane and unit
Standard. Unit 1 — establish the falsifiable first half of one genuine two-unit `Continue` proof.
Named reason for the loop: the correction necessarily crosses a Codex assessment and a later Claude
execution, so it must survive an actor and unit boundary, and its evidence must be assessed separately
from whoever constructs it.

## Brief
The candidate is authorised as a baseline, not adopted. Its current 28/28 `cont`/`rout` block proves
static protocol discrimination; this unit starts the smallest live proof needed to settle the one
remaining material finding without changing runtime policy merely to satisfy a test.

Required outcome for Unit 1:

1. Establish a minimum, safe two-step test surface using an existing fixture kind where possible.
   Complete and prove only its first observable step, leaving one bounded second step for a later
   unit of this same task.
2. Add or prepare change-specific evidence that is RED until both of these later facts exist in
   repository evidence: Codex authored a valid tokenless `Continue` hand-off after accepting Unit 1,
   and Claude then executed Unit 2 through `/work-loop-v2` and handed back falsifiable evidence.
   The check must not become green from hand-authored explanatory text or from the static
   `classify_state()` oracle alone.
3. Hand Unit 1 back to Codex after the first step and the RED evidence surface are real. Do not write
   the `Continue` hand-off on Codex's behalf, do not execute Unit 2, and do not claim the frozen
   finding resolved. Codex will assess Unit 1 and, if it is acceptable, author the actual next-unit
   hand-off.
4. Leave the live skill, core, Claude command, candidate verdict, and adoption status unchanged in
   this unit. A blocking runtime defect discovered by the proof is a hand-back, not permission to
   repair or redesign it.

Plan justification: `logs/missions/work-loop-v2-mvp.md` places project progression in the post-MVP
v0.2 thread and requires a constructed behavioral test for the `Continue` seam. This unit is the
smallest step toward that unmet condition because a real Codex-to-Claude transition cannot be
manufactured in one Claude invocation.

Governing sources and dispositions:

- The operator's current `yes`: governing permission to use `6ba4c3f` as the baseline and to
  self-host this bounded task; not permission to adopt, install, or expand it.
- `logs/decisions.md` § `Work Loop v2 project-progression proposal`: governing design direction and
  four operator corrections.
- `logs/missions/work-loop-v2-mvp.md`, post-MVP project-progression thread: authoritative current
  project placement and the behavioral-test obligation.
- `plans/work-loop-v2-mvp/work-loop-v2-mvp-proposal-v0.4.md`: governing plan; its no-self-hosting rule
  is overridden only for this named task by the current operator decision.
- `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`: governing task and `Continue`
  mechanics for this authorised run; candidate runtime control, excluded from change unless the
  proof exposes a blocker.
- `.agents/skills/work-loop-v2/SKILL.md`, `logs/scripts/work-loop-v2-slice-1.test.sh`, and the
  Continue fixtures: verify-first candidate material, not authority for their own acceptance.
- `plans/work-loop-v2-mvp/project-progression-candidate-review.md`: candidate/status record, not
  evidence that the candidate is approved or adopted.
- `plans/work-loop-v2-v0.2/project-progression-protocol-original-proposal.md`: preserved,
  non-governing background.

Check against the repository before changing anything:

1. Verify-first claim: a full run of `bash logs/scripts/work-loop-v2-slice-1.test.sh` currently
   reports 175 passed, 2 failed, exit 1, while every `cont`/`rout` assertion passes. Report the full
   totals and the change-specific totals separately.
2. Verify-first claim: the current `cont` block and `classify_state()` read fixture structure,
   tokens, and lexical acceptance, but do not establish that Codex authored a `Continue` hand-off or
   that Claude executed its next unit. Settle by reading the complete block and naming the evidence
   surface each assertion actually reads.
3. Verify-first claim: `logs/work-loop/fixture-continue.md` is an open, constructed Unit 2 state with
   no Unit 2 result or evidence, so its current contents prove state shape rather than completed
   execution. Settle from the file and its relevant repository history; if immutable history already
   proves both actors performed the complete transition, stop and hand that evidence back instead.
4. Verify-first claim: the first four defects listed in
   `plans/work-loop-v2-mvp/project-progression-candidate-review.md` § 2a are absent from the live
   candidate: no `delivery unit`, Unit 1 is excluded from tokenless Continue recognition, the valid
   fixture has no `Continue` pseudo-token, and the full harness is not described as green.
5. Verify-first claim: the candidate record no longer says the independent review is pending; it
   says artifact closure is pending, while the older
   `logs/work-loop/project-progression-candidate-review-correction.md` still contains an unexecuted
   close hand-off based on the earlier, narrower review. Treat that hand-off as superseded by this
   current operator-authorised review; do not execute or rewrite that task during Unit 1.

Required evidence for Unit 1:

- An inspection line for every claim, including claims that hold.
- A before/after check for the first fixture step that reads differently depending on whether Claude
  performed it.
- The exact RED result of the prepared live-seam evidence, showing which missing later fact keeps it
  red. A check that passes from this brief, fixture prose, or classifier output is invalid.
- A focused read showing no runtime control or authority/status record changed in Unit 1.
- One commit containing only this state file and the minimum Unit 1 test surfaces.

Completion condition: complete only the genuine first unit and its RED measurement surface; record
the result and evidence here; set `turn: codex`; commit; and stop. Do not continue, correct runtime,
close the task, update the candidate verdict, or make an adoption decision. The next move belongs to
Codex because only Codex may accept Unit 1 and author the tokenless next-unit hand-off being tested.

Stop if any premise is false in a way that changes the unit, the proof would require invented Claude
command lifecycle logic or a second state system, the first step cannot be isolated from runtime
changes, the evidence cannot distinguish hand-authored state from the real actor sequence, or a
control artifact must change. Hand back what the repository shows rather than improvising.

## Latest result
Inspected (2026-08-06) — all five claims checked against the live repository before anything changed:

- **Claim (1): HOLDS** — ran `bash logs/scripts/work-loop-v2-slice-1.test.sh` from the repo root:
  `passed: 175   failed: 2`, exit 1. Change-specific level reported separately: the `cont`/`rout`
  block is **28/28**, every assertion passing. The 2 failures are the disclosed `3.1a` closed-set
  reds (`no state file was opened for the direct request`; `every task-state file present is one
  this build created deliberately`).
- **Claim (2): HOLDS** — read the complete `cont` block (harness lines 680–814) and named the
  evidence surface of every assertion. Four read core prose (`$CORE_F`), three read skill prose
  (`$SKILL_F`), eight read `fixture-continue.md`'s own text, and six call `classify_state()` on a
  fixture path. **No assertion reads git history, commit ordering, commit authorship, or any record
  of an actor sequence.** Every fixture the block reads was hand-authored by Claude in a single
  earlier sitting, so the whole block would be green on a candidate where the Codex→Claude seam had
  never run once. That is the frozen finding, confirmed by inspection rather than accepted on
  report.
- **Claim (3): HOLDS** — `fixture-continue.md` is an open, constructed Unit 2 state: `## Latest
  result` narrates Unit 1's acceptance and carries **no Unit 2 result and no Unit 2 evidence**, and
  `fixture-target-2.md` shows no unit-2 edit from it. Its history is two commits, `6ba4c3f` and
  `4fb2ce7`, both written by Claude inside the same session as the candidate itself. **The
  stop-and-hand-back branch of this claim did not fire:** immutable history does not prove both
  actors performed the transition — it proves one actor constructed a picture of it.
- **Claim (4): HOLDS** — all four § 2a defects absent from the live candidate. `delivery`: zero
  occurrences in `SKILL.md` (searched the whole file, case-insensitive). The core's tokenless
  precondition is present at line 113 (`accepted result from a previous unit of the same task`).
  The fixture's `## Next action` matched no `^Continue[ ]*(—|-|:)` pseudo-token. The record's only
  "green" hits are its own account of correcting that overstatement; it states `The full harness
  **does not pass**`.
- **Claim (5): HOLDS, with one detail the brief did not state.** The candidate record's status line
  says the review has **run** and returned Accept with corrections; its only `pending independent`
  hit is line 225, the record of correcting that stale sentence. The older correction task does
  carry an unexecuted close hand-off — **but only in the working tree.** `git show
  HEAD:logs/work-loop/project-progression-candidate-review-correction.md` still opens `## Next
  action` with `Codex: the final tightly-bounded fix is done…`; the `Close the task:` token is
  uncommitted. So the hand-off this brief calls superseded is not yet durable in history. Left
  untouched and uncommitted, as instructed.

Result: Unit 1 established the two-step surface, performed only its first step, and left a live-seam
evidence surface that is **red on exactly the two facts that do not yet exist**.

1. **The two-step surface** is `logs/work-loop/fixture-target-3.md` — one minimum fixture of an
   existing kind (the same kind as `fixture-target.md` and `fixture-target-2.md`), carrying two
   stale reference lines, one per unit. It was created with **both** lines stale so that step 1's
   check was genuinely red before Claude touched it. Registered in `KNOWN_WORKLOOP_FILES` — the
   documented friction for adding a fixture, not a widening to hide a red.
2. **Unit 1's observable step**: `Seam-step-1` brought current. `Seam-step-2` deliberately untouched
   and reserved for Unit 2.
3. **The live-seam evidence** is a new `seam` block reading the **commit history of this task's own
   state file**, in order. It requires three facts to coincide: a hand-back commit at `turn: codex`;
   a later commit at `turn: claude` whose blob classifies CONTINUE and opens Unit 2; and a later
   commit still, back at `turn: codex`, in which `fixture-target-3.md`'s **second** line is current
   at that commit.

Evidence: `bash logs/scripts/work-loop-v2-slice-1.test.sh` from the repo root.

- **RED before Unit 1's step**, with the seam block already present and both fixture lines stale:
  `passed: 176   failed: 6`, exit 1 — four seam assertions red, including `seam  unit 1 brought the
  first step current`.
- **After Unit 1's step**: `passed: 177   failed: 5`, exit 1. `seam  unit 1 brought the first step
  current` flipped green; the three cross-actor assertions stayed red. `cont`/`rout` unchanged at
  **28/28**. The 2 pre-existing `3.1a` reds are untouched and still disclosed — the suite does not
  pass and this unit does not claim it does.
- **The step-1 check reads differently depending on whether Claude performed it.** It was red, the
  one line changed, it went green. Nothing else moved between those two runs.
- **Which missing fact keeps each seam assertion red**, stated exactly: `Codex accepted unit 1 and
  authored a tokenless Continue hand-off` is red because no commit of this state file yet carries
  `turn: claude` with a CONTINUE-classifying blob opening Unit 2. `Claude then executed unit 2 and
  handed back with the target changed` is red because no commit yet carries `Seam-step-2: current`.
  The distinctness assertion is red because both of the above are.
- **The check cannot go green the cheap ways the brief names.** Prose cannot satisfy it: nothing in
  the block reads an explanation — only frontmatter, headings, protocol tokens, and file content at
  a given commit. `classify_state()` alone cannot satisfy it: it is one conjunct of one of three
  facts, the other two being commit ordering and a real edit to a different file.
- **Controls unchanged, verified by execution.** `git status --porcelain` is empty for
  `.agents/skills/work-loop-v2/SKILL.md`, `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`,
  `.claude/commands/work-loop-v2.md`, `plans/work-loop-v2-mvp/project-progression-candidate-review.md`,
  `logs/decisions.md` and `logs/missions/work-loop-v2-mvp.md`. No candidate verdict and no adoption
  status was touched.

**A defect in my own new code, found by my own probe and fixed before hand-back.** A read-only probe
extracted `classify_state()` and the seam helpers from the harness and ran them against real
history. It showed that `classify_state()` **never reads `turn:`** — it returned `CONTINUE` for
`project-progression-candidate-recovery.md` at commit `4fb2ce7`, a blob sitting at `turn: codex`.
That blob is a Claude hand-back, not a Codex hand-off. My first `seam_continue_commit` would
therefore have accepted a *Claude* commit as Codex's hand-off — the seam proving itself. Fixed:
`turn: claude` is now a required conjunct, because Codex's Continue hand-off is by definition the
move that passes the turn to Claude. Verified after the fix: the same blob is now rejected, and
`seam_continue_commit` over that whole history returns empty.

**Deferral — newly noticed, not implemented.** The `classify_state()` gap itself: it will call any
structurally-valid file CONTINUE regardless of whether `turn:` is `claude`, `codex` or `operator`.
The seam block no longer depends on that, but the classifier is candidate material now under review,
and its four negative fixtures do not cover a wrong-turn case. Not fixed here — it is outside this
unit's scope, it is a change to candidate runtime evidence, and this brief says a defect the proof
exposes is a hand-back rather than permission to repair. Recorded for Codex to place.

**What this unit did not prove, stated rather than implied.** Fact 2's positive arm is demonstrated
reachable against real history — `fixture-continue.md`'s blobs classify CONTINUE at `turn: claude`
at both its commits, so that conjunction is satisfiable by a real commit. Fact 3's positive arm is
**not** demonstrated, because no commit anywhere yet carries `Seam-step-2: current`. A fuller probe
that constructs a synthetic three-commit history and shows all five seam assertions going green was
attempted and **declined by the operator this session**, so end-to-end reachability of the green
state rests on the component evidence above, not on an executed end-to-end run. Codex should weigh
that before relying on the seam block as the finding's closure evidence.

## Blocker
None.

## Next action
Codex: assess Unit 1 — is the two-step surface plus the three-fact seam evidence the right shape to
settle the frozen finding, and is the RED state honest about what is missing?

Three things need your judgment, and none of them is Claude's to decide:

1. **Whether to accept Unit 1 and continue.** If you accept it, the next move is yours to author: a
   tokenless Continue hand-off opening Unit 2, at `turn: claude`, with the accepted result recorded.
   Claude must not write that hand-off — it is the object under test, and writing it here would make
   the proof circular. Unit 2's own work is one line: bring `Seam-step-2` current in
   `logs/work-loop/fixture-target-3.md`, then hand back.
2. **Where the `classify_state()` turn gap belongs** — deferral recorded against this task, a
   correction to the candidate, or a finding routed back to the candidate record. It is a real gap
   in candidate evidence, but it is outside this unit's frozen scope.
3. **Whether the unproven fact-3 reachability is acceptable** as described above, given the operator
   declined the synthetic-history probe. If it is not, say what would satisfy you instead — the
   alternative is a probe run in a throwaway repository, which needs operator permission.

Not done and not decided here: the candidate verdict, adoption, the older correction task's
uncommitted close hand-off, and the two `3.1a` reds. All untouched.
