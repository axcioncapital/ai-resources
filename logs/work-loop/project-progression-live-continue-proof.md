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
Standard. Unit 2 — execute the second fixture step after Codex's accepted Unit 1 hand-off.
Named reason for the loop: the correction necessarily crosses a Codex assessment and a later Claude
execution, so it must survive an actor and unit boundary, and its evidence must be assessed separately
from whoever constructs it.

## Brief
Unit 1 is accepted: its first fixture step is real and its seam checks are honestly red on the
missing actor sequence. Unit 2 now performs the one bounded next step that turns that sequence into
observable evidence, without changing project-progression runtime policy.

Required outcome:

1. Verify that this file is a valid tokenless `Continue` hand-off: `turn: claude`; `## Lane and
   unit` names Unit 2; `## Latest result` affirmatively records Unit 1's acceptance; and `## Next
   action` begins with neither core protocol token. Verify that
   `logs/work-loop/fixture-target-3.md` has `Seam-step-1: current` and `Seam-step-2: stale` before
   changing anything.
2. Preserve immutable repository evidence of this exact Codex-authored hand-off before overwriting
   it with Claude's result. The evidence must later show a `turn: claude` Continue-classifying Unit 2
   state strictly after Unit 1's `turn: codex` hand-back and strictly before Unit 2's hand-back.
3. Change only `Seam-step-2` in `logs/work-loop/fixture-target-3.md` from stale to current. Leave
   `Seam-step-1`, the harness, the live skill, core, Claude command, candidate/status records, and
   every other fixture unchanged.
4. Hand Unit 2 back with falsifiable evidence, set `turn: codex`, and preserve the result in
   repository history. The final harness evidence must show all five `seam` assertions passing,
   `cont`/`rout` still 28/28, and the full suite at 180 passed / 2 disclosed unrelated `3.1a`
   failures, exit 1. Report different observed totals honestly rather than forcing this expectation.

Plan justification: the post-MVP project-progression thread requires a behavioral test of the
`Continue` seam. This is the smallest next unit because Codex has now performed the assessment and
handoff that Unit 1 deliberately could not manufacture, leaving only Claude's one-line execution and
hand-back to complete the cross-actor evidence.

Governing sources and dispositions remain those in `## Objective and scope`: the current operator
decision authorises this bounded self-hosted proof but not adoption; the approved plan and decision
record govern direction; the core governs the hand-off; the live runtime artifacts remain excluded
controls. The Unit 1 seam block and `fixture-target-3.md` are verified candidate evidence surfaces.

Required evidence:

- An inspection line for the hand-off shape and both target lines before mutation.
- Repository history that distinguishes the Unit 1 hand-back, this Codex-authored Unit 2 hand-off,
  and Claude's later Unit 2 hand-back as ordered states rather than one constructed blob.
- A before/after check proving only `Seam-step-2` changed and that `Seam-step-1` stayed current.
- The full harness totals, the `cont`/`rout` result, and all five `seam` results reported separately.
- A focused read showing no excluded runtime control or authority/status record changed.

Adjacent work held outside Unit 2 by Codex's framing decision: the newly discovered
`classify_state()` wrong-turn gap. The live seam block is protected by its own `turn: claude`
conjunct, so the gap does not block this unit; it remains candidate-evidence correction work for the
next assessment and must not be fixed silently here.

Completion condition: preserve this hand-off in repository evidence, execute only the second fixture
step, record the result and evidence here, set `turn: codex`, commit, and stop. Do not fix the
classifier gap, update the candidate verdict, close the task, adopt the candidate, or touch excluded
controls.

Stop if the hand-off cannot be preserved distinctly from the execution hand-back without changing a
control artifact, if either target-line premise is false, if the seam checks can pass without the
ordered actor sequence, or if any required work escapes the one-line Unit 2 boundary. Hand back the
evidence rather than improvising.

## Latest result
Inspected (2026-08-06) — the hand-off shape and both target premises checked before anything changed:

- **Claim (1a): HOLDS** — searched this file for `^turn:`; found `turn: claude`, the value that makes
  this Claude's move.
- **Claim (1b): HOLDS** — read `## Lane and unit`; found `Standard. Unit 2 — execute the second
  fixture step after Codex's accepted Unit 1 hand-off.`
- **Claim (1c): HOLDS** — read `## Latest result` as Codex left it; found the affirmative acceptance
  `Unit 1 accepted at assessment: …`, and an independent Codex reproduction of 177 passed / 5 failed.
- **Claim (1d): HOLDS** — matched the first non-blank line of `## Next action` against
  `^(Close the task:|Correct once — frozen findings:)`; **no match** (it opened `Claude: preserve this
  Codex-authored tokenless Unit 2 hand-off…`). Tokenless, and with 1c's precondition satisfied, a
  Continue. Confirmed mechanically: a read-only probe extracting `classify_state()` from the harness
  returned `CONTINUE` for this file as Codex left it.
- **Claim (1e): HOLDS** — searched `logs/work-loop/fixture-target-3.md` for `^Seam-step-1: current`;
  found it on line 4.
- **Claim (1f): HOLDS** — searched the same file for `^Seam-step-2:`; found `Seam-step-2: stale`, the
  pre-mutation state Unit 2 requires.
- **Claim (1g): HOLDS** — ran the full harness before touching anything: `passed: 177   failed: 5`,
  exit 1, reproducing Codex's stated baseline exactly. `cont`/`rout` 28/28. The five reds were the two
  disclosed `3.1a` closed-set failures and the three seam facts that did not yet exist.

Result: the cross-actor `Continue` seam ran for real. Codex's hand-off was preserved as its own commit
before Claude overwrote it, Unit 2 changed exactly one line, and all five `seam` assertions are now
green off ordered repository history rather than off any single constructed blob.

1. **The hand-off is durable and separate.** Commit `4750fb5` carries this state file exactly as Codex
   wrote it — `turn: claude`, Unit 2 open, Unit 1 recorded accepted — and nothing else. Claude's
   result was written only afterwards, into a later commit.
2. **Unit 2's whole work** was `Seam-step-2: stale` → `current` in `logs/work-loop/fixture-target-3.md`.
   `git diff` on that file shows one hunk and no other line moved; `Seam-step-1` is untouched.
3. **No prose can have produced this.** The seam block reads frontmatter, headings, protocol tokens and
   file content *at named commits*. Fact 2 requires a `turn: claude` CONTINUE-classifying commit opening
   Unit 2, strictly after a `turn: codex` hand-back. Fact 3 requires a still-later `turn: codex` commit
   at which the target's second line is current.

Evidence: `bash logs/scripts/work-loop-v2-slice-1.test.sh` from the repo root, run three times across
the unit — the numbers move only when the underlying fact comes into existence.

- **Before anything (the Unit 1 hand-back was the newest commit):** `passed: 177   failed: 5`, exit 1.
  Seam facts 2, 3 and distinctness all RED.
- **After committing Codex's hand-off unchanged, working tree otherwise identical:**
  `passed: 178   failed: 4`. Only `seam  Codex accepted unit 1 and authored a tokenless Continue
  hand-off` flipped. Nothing in the working tree had changed between those two runs — **the assertion
  flipped because a commit Codex authored came into existence, which is precisely what it claims to
  measure.**
- **After Unit 2's one-line edit and this hand-back commit:** `passed: 180   failed: 2`, exit 1. All
  five `seam` assertions PASS. `cont`/`rout` **28/28**, unchanged throughout. The 2 remaining reds are
  the pre-existing, disclosed, unrelated `3.1a` closed-set failures — **the suite does not pass, and
  this unit does not claim it does.**
- **The check can still fail, and was shown failing twice in this very run** — at 5 reds, then at 4.
  It is not a check that would have passed whatever happened.
- **Controls unchanged, verified by execution.** `git status --porcelain` is empty for
  `.agents/skills/work-loop-v2/SKILL.md`,
  `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`, `.claude/commands/work-loop-v2.md`,
  `plans/work-loop-v2-mvp/project-progression-candidate-review.md`, `logs/decisions.md`,
  `logs/missions/work-loop-v2-mvp.md` and `logs/scripts/work-loop-v2-slice-1.test.sh`. The harness
  itself was **not** edited in Unit 2 — the seam block written in Unit 1 was left exactly as it was and
  simply ran against new history. No candidate verdict and no adoption status was touched.

**Deferral, carried forward and still not implemented.** The `classify_state()` wrong-turn gap Codex
held outside this unit: it will call a structurally valid Continue-shaped file `CONTINUE` whether the
turn is `claude`, `codex` or `operator`. Unit 2 did not touch it, as instructed. It did not endanger
this proof, because the seam block carries its own `turn: claude` conjunct — but that conjunct is the
compensation, not a fix. Still candidate-evidence correction work for a later assessment.

**What this unit does not claim.** It does not close the frozen finding — that is Codex's assessment.
It does not make the candidate adopted, installed or verdict-changed. It does not resolve the two
`3.1a` reds. And the green state is now demonstrated end-to-end by execution, which retires Unit 1's
open question about fact 3's reachability: fact 3's positive arm is no longer theoretical.

## Blocker
None.

## Next action
Codex: assess Unit 2 and decide whether the frozen finding from the 2026-08-06 review is now settled.

The evidence to weigh: the seam went from 5 harness reds to 2 across three runs, with each flip tied to
a fact coming into existence — fact 2 to a commit you authored, fact 3 to Claude's one-line execution
and hand-back. The full suite is 180 passed / 2 failed, exit 1, the 2 being the disclosed unrelated
`3.1a` closed-set reds.

Two things still need your judgment:

1. **Whether the task's exit condition is met** and the task closes, or whether a further unit is
   justified. If it closes, the close token and the closing record's content are yours to write into
   `## Next action`; Claude writes and commits the reduction.
2. **Where the `classify_state()` wrong-turn gap goes** — it is still open, still unfixed, and still
   outside every unit's frozen scope so far. It is a real gap in candidate evidence.

Not done and not decided here: the candidate verdict, adoption, the older correction task's
uncommitted close hand-off in the working tree, and the two `3.1a` reds. All untouched.
