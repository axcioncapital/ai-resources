---
task: work-loop-v2-proportionality-continuity-implementation
turn: codex
---

## Objective and scope

Implement the accepted Work Loop v2 proportionality-and-continuity plan as separately assessed,
independently committable slices. The task exit condition is that the accepted plan's S1–S7 changes
are implemented in their governed dependency order with their proof cases, or a verified blocker is
handed back rather than worked around.

The current unit is **S3 only**: assign verification once, make prose/documentation evidence
non-ceremonial, and make the premise-inspection record proportional without weakening premise
checking. Excluded are S4–S7, changes to S1 or S2, every path not expressly allowed below,
installation or propagation, worktrees, branches, pushes, and adjacent cleanup.

## Lane and unit

Standard. Implementation mode. Unit 3 — accepted plan slice S3: verification ownership, prose
evidence and the proportional inspection record.

Named reason for the loop: this unit changes both actors' runtime instructions and the acceptance
harness that guards their shared evidence contract; its negative controls must be assessed
independently before checkout and continuity work begins.

## Brief

S2 is accepted, so the proportionality standard now has one owner in core § 3. S3 is next because it
turns that standard into concrete actor behavior: Claude checks once, Codex assesses, and neither
prose evidence nor premise records grow into ceremony. Implement only S3 and return its controlled
P-2, P-3 and P-3a evidence to Codex.

### Governing sources and current-state dispositions

- Core § 3 *Continuing* governs this continuation: S2 is accepted and the task exit condition remains
  unmet.
- `logs/work-loop/work-loop-v2-proportionality-continuity-plan.md` is the closed, content-bound
  acceptance record.
- `plans/work-loop-v2-v0.2/work-loop-v2-proportionality-continuity-implementation-plan-v0.1.md`
  governs this unit: § 4.4, § 4.5, § 5 S3, § 6 P-2/P-3/P-3a, § 7 and § 9.
- `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` is read-only authority. Its accepted
  S2 clause owns the 85–90% target, minimum necessary work, consequence-scaled evidence and no
  perfection pass. S3 points to that owner and does not copy it.
- `.agents/skills/work-loop-v2/SKILL.md` owns Codex's verification-assessment division.
- `.claude/commands/work-loop-v2.md` owns Claude's premise-record behavior and prose/documentation
  evidence behavior. It currently lacks the pointer to core § 3 noted during S2; add a pointer while
  editing its S3-owned text, without restating the four proportionality rules.
- `logs/scripts/work-loop-v2-slice-1.test.sh` follows the command contract; it does not define it.
  Existing cases 1.2a and 2.1 carry load-bearing claims and must remain valid. S3 adds the missing
  opposite case for a no-premise prose unit.
- Current in-flight state is moving. At framing time,
  `project-progression-candidate-review-correction` is the only other task at `turn: claude` and its
  close verdict confines it to its own state file; `work-loop-v2-escaped-descendant-termination`,
  `work-loop-v2-intake-router` and `work-loop-v2-production-readiness-policy` are at `turn: codex`.
  Re-read all four before editing. A newly authorized writer on the skill, command or harness is a
  stop.

### Allowed paths

- `.agents/skills/work-loop-v2/SKILL.md`
- `.claude/commands/work-loop-v2.md`
- `logs/scripts/work-loop-v2-slice-1.test.sh`
- the minimum necessary no-premise prose fixture or fixtures under `logs/work-loop/`
- this state file

Do not edit the executable core. Do not generalize the harness beyond the S3 proof cases or repair
unrelated existing failures.

### Required outcome

1. In the skill's **Assessing the result** section, state the division once: **Claude runs the checks
   and reports the evidence; Codex assesses that evidence.** Re-running a reported check is
   duplicated testing, not diligence.
2. Permit Codex to reproduce a check only when it says which of these accepted conditions applies:
   (a) the reported result and quoted output are internally inconsistent; (b) the evidence cannot
   fail as written, in which case Codex names the defect rather than substituting a better check;
   (c) the claim is consequential or hard to reverse and a wrong acceptance would be expensive; or
   (d) the unattended path reported a repository fact Codex may read directly—`turn:`, commit or
   exit code—which is reading the file, not re-running Claude's check. Preserve the existing
   unattended distinction between repository facts and model claims.
3. In the Claude command's **Implementation** mode instruction, make prose, documentation and
   instruction-file changes the ordinary case where no meaningful automated regression check
   exists. Their evidence is the changed text quoted against what it replaced plus one line saying
   why no automated check distinguishes success from failure. A check that greps for a word the
   brief already supplied is not evidence; point to the Codex-side rule rather than restating it.
   Executable artifacts—scripts, hooks and test harnesses—still require a failing case.
4. Add a concise pointer from the Claude command to core § 3's accepted proportionality judgment.
   Do not copy S2's four statements.
5. Amend command Step 2 so premise checking remains mandatory wherever a load-bearing claim could
   change the work, with one inspection line for every such claim including the ones that hold.
   Direct Work opens no state file and therefore no record. A simple prose/documentation change with
   no meaningful premise to test may omit the `Inspected (YYYY-MM-DD):` block and instead carry one
   line saying there was no load-bearing premise to check.
6. State the deciding question without creating a new tier: **would being wrong about a premise here
   change the work?** A small prose change can still require inspection if it rests on a file,
   location or other claim; a rewrite whose only premise is the current text visible in the change
   does not.
7. Add no proportionality field, tier label, justification field, checklist or other per-run
   replacement. Absence of the inspection block is the lighter path.
8. Extend the harness with the minimum no-premise prose fixture case. Keep cases 1.2a and 2.1
   unchanged in meaning because their fixtures do carry claims.

### Check against the repository before acting

1. Verify `pwd -P` is exactly
   `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`. A mismatch stops; never copy
   this state file between checkouts.
2. Validate this state file read-only against core § 4: identity, `turn: claude`, exact active
   headings and one-task/one-file location.
3. Re-read the current skill's **Assessing the result** section. Verify it still lacks the
   verification-ownership block and that the existing unattended repository-fact/model-claim rule
   remains available to preserve.
4. Re-read the command's Step 2 and **The unit's mode** section. Verify Step 2 still requires an
   inspection record on every run, the Implementation bullet treats the no-regression case only as
   an unnamed exception, executable artifacts still require meaningful failing evidence through
   core § 6, and the command still lacks a core § 3 proportionality pointer.
5. Inspect harness cases 1.2a and 2.1 and their fixtures. Verify both fixtures carry load-bearing
   claims and the cases correctly require an inspection record.
6. Search `logs/work-loop/` and the harness for a no-premise prose fixture and for behavior that
   legitimately omits the inspection block. Bound the absence claim to those surfaces and patterns.
7. Re-read the current turns, scopes and next actions of the four in-flight tasks named above.
   Confirm no other actor is now authorized to edit an S3 target and no live unattended dispatcher
   owns this task.
8. Check every allowed target for overlapping uncommitted work before editing. Preserve compatible
   concurrent changes; hand back an incompatible overlap rather than overwriting it.
9. Confirm S3 can be completed using only the allowed paths and without changing core § 6's
   fail-capable evidence rule.

### Required evidence

- One inspection line for every claim above, including claims that hold.
- **P-2, duplicated verification:** use two representative Codex assessments. A consistent hand-back
  whose reported check is already sufficient must not trigger a re-run. An internally inconsistent
  hand-back must trigger reproduction under condition 1. Report which condition applies whenever
  reproduction occurs; an unconditional “never reproduce” rule fails the control.
- **P-3, prose ceremony:** show a documentation-only unit returning the old text, the new text and
  the one-line reason no automated check distinguishes them, with no brief-supplied-word grep.
  Control it with an executable shell-script unit that still returns a real failing case. A rule
  that lets the executable unit skip the failing case fails.
- **P-3a, proportional inspection record:** before the change, the no-premise prose fixture must fail
  because the command/harness requires an `Inspected` block universally. After the change, that
  fixture must contain the one-line no-premise statement and no `Inspected` block; a claims-bearing
  fixture must still contain one line for every claim, including those that hold.
- Include P-3a's third control: inspect the resulting command, state shape and fixture to prove no
  new mandatory field, tier, proportionality statement, justification or checklist appears on every
  run.
- Show cases 1.2a and 2.1 retain their outcomes, and report the focused S3 result separately from the
  full harness result. Report unrelated existing failures honestly; do not widen scope to make the
  suite green.
- Show the command points to core § 3 while neither runtime restates S2's four statements.
- Quote the relevant old/new skill and command text. For these instruction changes, that comparison
  is implementation evidence; the harness and representative cases are the fail-capable behavioral
  evidence.
- Report the exact changed paths and the commit. Confirm no S4–S7 target, executable core or unrelated
  state file changed.

Completion: implement only S3, record the inspections and P-2/P-3/P-3a evidence under
`## Latest result`, set `turn: codex`, and commit only the allowed paths by explicit pathspec. Do not
begin S4 or assess your own result.

Stop and hand back if the checkout mismatches; this state file is malformed or stale; a governing
premise is false; another writer now owns or has modified an S3 target; proportionality cannot be
implemented without a new mandatory per-run artifact; a meaningful negative control cannot be
produced; an excluded file is required; or an operator-owned scope, authority or risk decision is
needed.

## Latest result

Inspected (2026-08-07):

- **Claim (1): HOLDS** — `pwd -P` returned exactly
  `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`.
- **Claim (2): HOLDS** — `task:` matches the filename, `turn:` was `claude`, the active headings are
  core § 4's exact five plus `## Brief`, and this is the task's only file.
- **Claim (3): HOLDS** — the skill's § *Assessing the result* was two paragraphs and carried no
  verification-ownership block. Settled by the harness rather than by reading alone: the three new
  `prop  the skill …` assertions were **red** against the unchanged file. The unattended
  repository-fact / model-claim rule was present at line 117 and was preserved verbatim.
- **Claim (4): HOLDS, all four parts.** Step 2 read "The record appears even when nothing is wrong";
  the Implementation bullet ended at "rather than inventing one that cannot fail (core § 6 rule 5)"
  with no named standard case; executable artifacts were covered only through core § 6; and
  `grep -c 'good enough, proceed'` over the command returned **0**. All four were red assertions
  before the change.
- **Claim (5): HOLDS** — opened both fixtures. `fixture-slice1-true.md` carries two claims, the second
  an absence claim naming surface and pattern (`searched … fixture-target.md … for the pattern
  ^Status:`). `fixture-slice2-fresh.md` carries two claims in the same shape. Both cases correctly
  require a record, so neither may be relaxed.
- **Claim (6): HOLDS** — searched `logs/work-loop/` for filenames matching `prose|no-?premise` — no
  match; and searched `logs/scripts/work-loop-v2-slice-1.test.sh` for
  `no.?premise|no load-bearing premise` — no match. The absence is bounded to those two surfaces and
  those patterns, and asserts nothing beyond them.
- **Claim (7): HOLDS on the load-bearing part; the enumeration moved again during the unit.**
  `work-loop-v2-escaped-descendant-termination` was at `turn: codex` when the brief was framed, is
  now back at `turn: claude` in a correction round, and moved `dispatch.sh` and `dispatch.test.sh`
  while this unit ran. Its scope excludes "Work Loop core, skill or rule changes" and repeats that as
  a framing decision, so **it does not own any S3 target**. `project-progression-candidate-review-correction`
  remains confined to its own state file. `work-loop-v2-intake-router` and
  `work-loop-v2-production-readiness-policy` are at `turn: codex` and claim nothing here. No
  dispatcher run owns this task — `pgrep -fl dispatch.sh` returned nothing at the time of editing.
- **Claim (8): HOLDS** — `git status --porcelain` on all three existing allowed targets was empty
  before editing. No concurrent change was overwritten or absorbed.
- **Claim (9): HOLDS** — S3 was completed inside the allowed paths. Core § 6 rule 5 is untouched and
  still reads "**Evidence must be able to fail.** If the check would pass whatever happened, it is
  not evidence. Build the failing case first, then show it passing." The core file is unchanged since
  S2's commit `5680a44`.

Result: the verification division, the prose-evidence rule, the proportional inspection record and
its harness protection are implemented. Four files changed.

**Change 1 — the skill's § *Assessing the result* (§ 4.4).** Added after the existing first
paragraph, which is unchanged:

> "**Claude runs the checks and reports the evidence. You assess that evidence.** Re-running a check
> Claude has already run and reported is duplicated testing, not diligence.
>
> You may reproduce a check only under one of these four conditions, and you say which one applies
> when you do: 1. **Internally inconsistent evidence** … 2. **Evidence that cannot fail as written**
> (core § 6 rule 5) … Name the defect; do not quietly substitute a better check. 3. **A consequential
> or hard-to-reverse claim** (core § 7) … 4. **A repository fact you can read directly** — `turn:`,
> the commit, the exit code … Reading the file is not re-running Claude's check.
>
> **If none of the four applies, you do not run the check** — not a shortened version of it, and not
> "just to be sure". Opening a file to read a repository fact is fine. Re-executing the grep, script
> or test Claude already ran and quoted … is the duplication this rule names …"

The unattended repository-fact / model-claim rule follows, unchanged, as § 4.4 requires.

**Change 2 — the command's Implementation bullet (§ 4.5).** The existing sentence is kept and the
standard case is named. Old ended at: "Where no meaningful regression check exists, say so and say
why, rather than inventing one that cannot fail (core § 6 rule 5)." New continues: "**A prose,
documentation or instruction-file change is the ordinary instance of that case, not an exception to
argue for.** Its evidence is the changed text quoted against what it replaced, plus one line on why
no automated check would distinguish success from failure. A check that greps for a word the brief
already supplied is not evidence — the Codex skill names that as the commonest way a unit looks done
and is not. **Where the artifact is executable** — a script, a hook, a test harness — the failing case
is still required, unchanged."

**Change 3 — the core § 3 pointer**, in Step 4: "**How much work, and how much evidence, is core
§ 3's *good enough, proceed* judgment.** Read it there; it is not restated here." Deliberately
contentless — naming the four statements here is what the no-duplication control forbids.

**Change 4 — Step 2 becomes proportional (§ 4.5).** The universal clause "The record appears even
when nothing is wrong" is removed from the per-claim rule, which otherwise stands verbatim. Added
below it: premise checking is not proportional, the record is; the two cases that legitimately
produce no record (Direct Work; a simple prose or documentation change with no load-bearing premise,
which instead writes one line saying so); the deciding question — "**would being wrong about a
premise here change the work?**", explicitly not a size test; and "**Nothing replaces the absent
record.** No proportionality statement, no tier label, no justification field, no checklist."

**Change 5 — the harness (§ 4.5, P-3a's harness half).** An 18-assertion `prop` block, plus
`logs/work-loop/fixture-noprem-prose.md` and its registration in `KNOWN_WORKLOOP_FILES`. Cases 1.2a
and 2.1 are untouched.

Evidence.

**P-3a — RED then GREEN, on the same assertions.** The fixture was first written in the shape the
**old** rule forces: a fabricated `Inspected (2026-08-07):` block listing two claims invented to fill
the format, on a unit whose brief says "Check against the repository: none." Against that fixture and
the unchanged command and skill, the new block ran **11 of 18 red**. After the four changes and
rewriting the fixture's record to the one-line no-premise form, the same 18 assertions are **green**.
Focused result: `prop` **18/18**. That red could only go green by the change happening — nothing in
the assertions greps a word the brief supplied at me.

Two of those assertions were **strengthened after their first red proved weak**, and that is worth
recording rather than hiding: `no Inspected block` and `says there was no load-bearing premise`
initially ran as whole-file greps and passed on the fixture's own *description of itself*. They are
now scoped to the `## Latest result` section through a `latest_of()` helper, which is the same
fixture-literal mistake the Continue block was corrected for earlier. Scoped, both went red as they
should have.

**P-3a's third control — nothing replaced the record.** `prop  nothing new became mandatory on every
run` asserts no `Proportionality|Tier|Record tier|Justification|Ceremony` label appears in the
fixture, and `prop  the command forbids a replacement artifact` asserts the command says so. The
fixture's active headings are core § 4's five; no field, tier or checklist was added anywhere. Read
directly off the committed files, in both directions.

**P-3 — the prose rule and its executable control, demonstrated by this unit itself.** S3 contains
both halves, so the control is not hypothetical:

- *The documentation half* — the skill and command changes. Their evidence is the old and new text
  quoted above plus this line: no automated check distinguishes correct instruction prose from
  incorrect instruction prose, because both are grammatical English in the same file.
- *The executable half* — the harness change. It returned a real failing case: 11 red assertions
  against the pre-change state, green after. **The relief did not leak into it.** A rule that let the
  harness change skip its failing case would have failed this control, and did not.

**P-2 — two representative Codex assessments, run as fresh `codex exec` tasks.** Two hand-backs were
constructed in the scratchpad, identical except for one line, both pointing at a real repository file
Codex could re-check. Observation is which commands each run executed.

| Case | Evidence given | Re-ran the reported check? | Named a condition? |
|---|---|---|---|
| Consistent, before the tightening | `grep -c` returns 1, was 0 | **Yes** — ran `rg -n '^Status:'` on the file | No |
| Consistent, after the tightening | same | **No** — read the file with `sed`, ran no grep | n/a |
| Internally inconsistent | result claims the line was added, quoted output says `0` | **Yes** | **Yes** — "Under the internal-inconsistency exception, I reproduced the check" |

The inconsistent case is the control that matters, and it passed on the first run: an unconditional
"never reproduce" rule would have wrongly suppressed it, and the rule as written triggered
reproduction and named condition 1 in Codex's own words. **The consistent case failed on first
observation** — Codex reached the right verdict *and* re-ran the check without citing anything. That
is why the rule gained its explicit negative sentence, and the re-run then read the file rather than
re-executing the grep, which is exactly the line that sentence draws.

**The limit on P-2, stated plainly:** this is one observation per condition, in headless `codex exec`
rather than the Codex app, and the tightening was made between the first and third runs. It shows the
rule is followable and that the inconsistent-evidence exception fires; it does not establish a rate.

**Cases 1.2a and 2.1 retain their outcomes** — all four 1.2a assertions and all twelve 2.1 assertions
pass, unchanged. Their fixtures carry real claims, so the per-claim rule still binds them.

**Focused and full results, separately, with the failures reported honestly.**

- Focused S3 result: `prop` **18 passed, 0 failed**.
- Full harness: **292 passed, 3 failed** (baseline before this unit: 274 passed, 3 failed — the same
  three).
- The three failures are pre-existing and none is fixed here, because the brief forbids repairing
  unrelated failures: two are the `3.1a` closed-set assertions, red because live task-state files
  exist alongside the fixtures; the third is `ridx  the skill stays under its 340-line ceiling`.
  **That third one deserves naming.** It is not caused by S1, S2 or S3: the skill went 331 → 381
  lines at commit `4c9aa0e`, the *unattended-operation* task's work, which added guidance without
  re-basing the guard. S3 adds 13 more lines, taking it to 394. The verdict does not change — it was
  already red — but the gap widens, and the guard is an implementation guard rather than operator
  authority. Re-basing or trimming it belongs to whoever owns that ceiling, not to S3.

**Pointer present, copy absent.** `grep 'good enough, proceed'` over the command returns the Step 4
line. Searching **both** runtimes for `85–90|85-90|minimum necessary work|scaled to consequence|
perfection pass` returns **no match in either**, after the change. The rule still lives only in
core § 3.

**Changed paths:** `.agents/skills/work-loop-v2/SKILL.md`, `.claude/commands/work-loop-v2.md`,
`logs/scripts/work-loop-v2-slice-1.test.sh`, `logs/work-loop/fixture-noprem-prose.md` (new), and this
state file. The executable core is unchanged since `5680a44`, and no S4–S7 target
(`AGENTS.md`, `.codex/hooks.json`, `.codex/hooks/`) was touched — all verified empty in
`git status`. `dispatch.sh` and `dispatch.test.sh` are dirty in the tree from the concurrent
escaped-descendant task and are **not** staged here.

**Deferrals carried forward, none implemented.**

1. From S1: an ordinary unnamed request still activates **Work Loop v1**. Outside this plan's targets.
2. New: the `ridx` 340-line ceiling is red and this unit widened the gap to 54 lines. Out of scope
   here; it needs its own decision about whether the guard is re-based or the skill is trimmed.

## Blocker

None.

## Next action

Codex: assess S3. Two judgments are yours. First, whether P-2 is sufficient given that the consistent
case only stopped re-running after the rule gained an explicit negative sentence, and that the whole
control is one observation per condition in headless `codex exec`. Second, what to do about the
`ridx` line ceiling, which S3 did not cause but did widen — deferral as recorded, its own unit, or a
re-based guard. Then close, continue to S4, or correct once.
