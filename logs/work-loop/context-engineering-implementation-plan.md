---
task: context-engineering-implementation-plan
turn: codex
---

## Objective and approved scope
Produce one self-contained, execution-ready **draft implementation plan** for
`plans/work-loop-v2-v0.2/context-engineering-spec-v0.1.md`. The plan must guide the later
implementation across fresh sessions and make progression depend on observable evidence.

Write the plan to
`plans/work-loop-v2-v0.2/context-engineering/context-engineering-implementation-plan-v0.1.md`.
It remains non-governing until the operator explicitly approves it. This unit plans only: do not
implement Context Engineering, change the specification's approval status, or edit any Work Loop
runtime artifact.

## Lane and unit
Standard. Unit 1 — inspect the live implementation surface and draft the implementation plan.

Named reason for the loop: the plan must survive several later sessions, the implementation scope
needs bounding before work starts, and Codex must assess the result independently before it counts as
ready for operator approval.

## Brief
Why: the specification is behaviourally detailed but deliberately does not authorize or sequence its
implementation. The operator needs a durable plan that lets each later session take one bounded,
observable slice without reconstructing design history or prematurely wiring the live Work Loop.

The brief's five original claims were checked by inspection in the prior round and all held; the record
is in Git at `1238ef1`. This round is the one bounded correction under core §3, so its evidence is the
reproduction of the frozen findings, below.

**Operator scope decision after external review:** supersede the narrow final-fix boundary and reframe
the remaining work as one consolidated revision of this still-unapproved plan. This is an explicit
operator-owned scope change, not a finding silently entering a closure check.

## Latest material result

**Final bounded fix (2026-08-02) — core §3 menu, option "permit one final tightly-bounded fix."**
Not a second correction round: `## Next action` carried no `Correct once — frozen findings:` token, and
findings 2–6 stayed closed and untouched.

**Reproduced first, before editing.** Codex's regression is real. §4.4 (`:184`) fixes the candidate as
*"one file: `trials/candidate/SKILL.md`"*, while S2 (`:532`) named a second file
`trials/candidate/carriage-a-instructions.md`, and S2's repository-output clause (`:563-565`) said that if
the indirect carriage won, `SKILL.md` keeps its pointer and the families are written into the referenced
instruction file. Under that branch Phase 2 opens with **two** files, contradicting §4.4 and the operator's
preserved one-file constraint. Confirmed by reading both passages, not by recall.

**What the fix did.** S2 now validates **one inline, mechanism-only candidate** —
`trials/candidate/SKILL.md`, probe text in its own body — against the existing non-CE probe and the
negative control. The indirect-versus-inline competition, the carriage table, `carriage-a-instructions.md`
and every branch that could leave a referenced instruction file are gone. Claude authors the file, the
operator drives the two runs, Claude observes the briefs. **If inline delivery fails, U-1 escalates** — the
exit clause states in terms that no branch adds an indirection file or a second carriage. Three things were
deliberately kept: S8b still owns installed discovery (the honest limit that S2 cannot answer it), S3's red
run remains the semantic-emptiness control, and the `grep -c 'CE-'` check stays necessary-not-sufficient.

**One consequence stated rather than smoothed over.** The plan no longer tests whether an instruction
survives one level of indirection — nothing in the build answers that now. S2 says so in its own text, and
§9's *"runtime packaging decision as a constraint fixed now"* row was reconciled to match: S2 selects no
packaging option, but the one-file constraint does fix the **trial's** construction as inline, so
indirection is untested by this build rather than decided against.

Reconciled beyond S2 itself, and nothing else: §4.3's carriage bullet, §7.0's S2 actor row (three fixture
files/three runs → one file/two runs), Phase 1's boxed escalation note, the Phase 1 exit line, S3's inputs
line, and the two §9 rows above. Findings 2–6, all prior corrections, the deferral below and every standing
boundary are preserved. `.agents/skills/wl2-probe/SKILL.md` was not deleted.

Evidence:

- **The regression is gone, by absence.** In the plan: `carriage-a-` → **0** (was 3); `carriage-b-` → **0**
  (was 1); `losing carriage` → **0** (was 2); `three fixture|three runs|three threads` → **0** (was 4);
  `both carriages|two carriages|two candidates|two candidate shapes` → **1** (was 4), and the single
  survivor is the drafting-history sentence that records the rejected design, not a live branch.
  **Fails if** any of those returns above zero, or if the remaining hit stops being the history sentence.
- **The invariant is stated, by presence.** `*What survives:* **exactly one file**` → **1**;
  `No branch adds an indirection file or a second carriage` → **1**;
  `the only file in `trials/candidate/`` → **1**; and S2's evidence list gains a check that
  `trials/candidate/` contains exactly one file. **Fails if** any drops to 0.
- **`referenced instruction file` → 1** (was 2) — and the survivor is the prohibition (*"There is no second
  carriage and no referenced instruction file"*), not an instruction to create one. **Fails if** the
  remaining hit becomes constructive again.
- **Findings 2–6 unmoved, checked not assumed.** `author — Claude` **1**; `Negative control` **1**;
  `it is relevant if all three hold` **0**; `Under reading B additionally` **1**;
  `committed as ordinary Direct Work, outside this plan` **0**; `genuine Standard-lane unit` **1**;
  the freshness row `**It is not.**` **1**. **Fails if** any moves.
- **Counts unmoved.** `**Yes**` cells **10**; `ten of the fourteen sessions` **1** and
  `nine of the fourteen` **0**; `^- \*Actors:` lines **14**; seeded-subcase lines **13**; §8 map **17**
  behaviour rows; §9 boundary audit **17** rows; CE-1…CE-17 present with no gaps; the escape-hatch grep
  `stated limitation\|with stated limitations` still exactly **1**, and it is still the prohibition.
  **Fails if** any count moves. File length **1279 → 1280** lines — the one added line is a rewrap of the
  Phase 1 exit sentence, not new material.
- **Committed paths.** Exactly two: the plan and this state file. The pre-existing unrelated working-tree
  changes (`logs/friction-log.md`, `logs/session-notes.md`, `logs/runs/2026-08-02-S5-8ee.json`) were not
  staged. **Fails if** `git show --stat` lists a third path.

**Prior round, for reference only** (full record in Git at `cf52736`): all six frozen findings were
reproduced and corrected; Codex's closure check found findings 2–6 resolved with no material regression,
and finding 1 only partly resolved — which is what this fix closes.

**One deferral, recorded and not done** (core §5 — noticed during F-3's inspection, outside the frozen
findings): `.agents/skills/wl2-probe/SKILL.md` is still on disk. Its own body reads *"Throwaway Step 2
transport probe. Delete me."*, and `step-2-transport-seam-conclusions.md:110` records the probe as
reverted. It is a leftover from the transport probe, not part of this plan. Not deleted here — deleting a
file is outside a plan-correction unit's scope, and it belongs to whoever owns the Step 2 cleanup.

## Unresolved blocker
None.

## Next action
Codex: the final closure check — **on this one-file-candidate fix only** (core §3, *If the correction was
not enough*). It is not another broad review, and no closed finding reopens.

1. Is the one-file invariant restored — does every successful S2 outcome leave exactly
   `trials/candidate/SKILL.md` and nothing beside it?
2. Did this fix cause a material regression?

Two things to weigh while answering, disclosed rather than smoothed over:

- **The indirection question is now untested, not answered.** Removing the competition removed the only
  place the plan checked whether an instruction survives one level of indirection. S2 states this, and §9's
  packaging row was reconciled to say the trial's construction is fixed as inline while no packaging option
  is selected for the runtime. If Codex judges that §9 row now overclaims, say so — it is the one place
  where the fix touched a boundary-audit claim rather than S2's own text.
- **Section §9's two edited rows were the only reconciliations outside Phase 1 and §7.0.** Both were direct
  references to the removed competition, so leaving them would have left the plan self-contradictory. If
  that is judged wider than the bounded fix allowed, it is a scope call, not a fact question.

Anything newly noticed is a **deferral**, not another round. The deferral above
(`.agents/skills/wl2-probe/SKILL.md`) is still open and still belongs to whoever owns the Step 2 cleanup.
The plan remains a **draft**; Phase 0's two operator approvals are still outstanding.
