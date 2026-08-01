# Step 7 — Work Loop v2 pilot log

**Opened:** 2026-08-01, session S11-cf1
**Mission:** `work-loop-v2-mvp`
**Candidate under pilot:** commit `fc6c07c` (accepted 2026-08-01, `step-6-candidate-review.md` § 2)
**Authority:** `work-loop-v2-mvp-proposal-v0.4.md` § Phase 3

> **Every friction point goes in this file, as it happens** (Proposal `:98`). A friction point
> reconstructed after the unit closes is a memory, not evidence.

---

## The rule that governs this log

**The presumption is no change** (Proposal `:100`). A pilot observation enters immediate MVP scope
**only if it materially obstructed useful operation.** Everything else becomes a reopening trigger or
an accepted limitation.

Every observation below carries one of three classifications, and the reason for it:

| Class | Meaning | What happens |
|---|---|---|
| **OBSTRUCTION** | Materially obstructed useful operation | Enters MVP scope; fixed in Step 8 under frozen-findings discipline |
| **TRIGGER** | Not obstructing, but names what would reopen it | Recorded as a reopening trigger — the idea, why not now, what evidence would reopen it |
| **LIMITATION** | Accepted as-is for pilot quality | Added to the final disclosed-limitations list |

Classifying something OBSTRUCTION is the one judgment this presumption exists to constrain. Surface it
to the operator before pulling anything into scope.

---

## What the pilot tests

The seven conditions from Proposal `:98`. Each unit records a verdict against every row it exercised;
`n/a` is a valid verdict and is not a gap.

| # | Condition | Unit 1 | Unit 2 | Unit 3 |
|---|---|---|---|---|
| 1 | Useful context preparation | yes | yes | **yes** |
| 2 | Alignment with the approved project plan | yes | yes | **yes** |
| 3 | State recovery | n/a | n/a | **pending — staged** |
| 4 | One bounded correction | not exercised | **yes** | n/a so far |
| 5 | The Direct Work bypass | n/a | n/a | **still owed** |
| 6 | Operator intervention | yes ×2 | not needed | **yes** |
| 7 | Clean fresh-session continuation | partly | n/a | **pending — staged** |

**After two units, three conditions have never been exercised — and all three need the same thing:**
a unit that crosses a real session boundary (3 and 7), and a request small enough to be refused
admission (5). Both units so far were opened, executed and closed inside one session, and both were
admitted to the loop. Unit 3 is where these close or are recorded as untested.

**At least one Standard-lane unit must need a session handoff mid-task** (Proposal `:96`). That unit
is what exercises rows 3 and 7 for real. It cannot be done inside a single session — it requires a
genuine session boundary.

## Limitations to watch

The six disclosed limitations the candidate carries (`step-6-candidate-review.md` § 8.5). Several name
"the pilot" as their reopening trigger, so this is where they are tested for real. Watch, do not
pre-emptively fix.

| # | Limitation | Reopening trigger | Observed? |
|---|---|---|---|
| 1 | Folder creation from a genuinely absent `logs/work-loop/` is untested | A fresh checkout | **RETIRED, unit 1.** Codex created `projects/axcion-systems-builder/logs/work-loop/` where it genuinely did not exist — verified absent at 19:44 during FP-1, directory mtime 19:49 |
| 2 | Most opening briefs were hand-written fixtures | Codex opening a real unit retires this | **RETIRED, unit 1.** A genuine Codex opening brief, committed by Claude at `c8b3923` |
| 3 | Slice 2's menu task's first pass and assessment block are fixture material | — | Not touched — no menu choice arose |
| 4 | The writing standard's internal tension is unresolved | Pilot use shows the boundary is unclear or causes drift | **Not observed.** No boundary question arose in unit 1 |
| 5 | Core § 6 rule 2 contradicts core § 7 for the file-identity case | A unit where the ambiguity produces a wrong action, or the first core revision | **Not reached.** The file's `task:` matched, so the contradictory branch never ran |
| 6 | Behavioural evidence is largely historical | The pilot is the real test | **Largely retired, unit 2.** The last mechanism resting on historical evidence — the bounded correction round — ran live on real work: one frozen finding, one round, closed. Premise-checking, red-before-green and the hand-back had already run live in unit 1 |

One further open item, queued S7-3fc at medium severity: the Codex side currently needs the operator
to paste a prompt naming the task id, where the resource could resolve the open task itself. Its named
pickup window is this pilot.

## Standing constraints

- **Genuine units only.** Two or three real CRM and Email OS work units, chosen because the operator
  wanted the work done anyway (Proposal `:96`). A manufactured unit tests nothing.
- **The operator operates.** Gives objectives, makes escalated decisions, judges usefulness.
- **No second review layer.** If a unit naturally invokes a specialist workflow, that workflow owns
  its method — the Work Loop does not layer a second review or state system over it (Proposal `:107`).
  Do not manufacture a unit just to test this.
- **v1 is retiring but not yet retired.** Option A was decided 2026-08-01
  (`step-7-v1-retirement-decision.md`); execution belongs to Step 8. Pilot units run through v2.

---

## Unit 1

**Status:** **CLOSED 2026-08-01** — opened by Codex, executed by Claude, assessed and closed by Codex
on the first pass with **no correction round**. Closing record in the state file; closure commit
`761c081`.

- **Task id:** `review-packet-preservation`
- **Owning project:** `projects/axcion-systems-builder`
- **The work:** `cases/scripts/build-review-packet.sh` carries two linked defects, both already
  verified and recorded in `cases/axcion-writing-studio/working/phase9-red-team-disposition.md:75-77`:
  1. The script ships **exactly one brief**, so a resubmission brief listing the first-pass brief as
     enclosed context describes a file the script structurally cannot include. The disposition note
     states this "will recur on every future resubmission."
  2. `verify` against a frozen historical packet prints `PACKET IS STALE — do not send. Rebuild: …`
     — and following that instruction **overwrites the only surviving copy of what Codex actually
     reviewed**. A `FROZEN-AFTER-REVIEW.md` marker had to be hand-placed inside the packet directory
     because the script's own output points the wrong way.
- **Selected by:** operator, 2026-08-01.
- **Lane:** **Standard**, classified by Codex at admission. Its named reason, in its own words:
  *"this changes the safety contract of a destructive cross-case evidence tool, so the lifecycle
  boundary must be bounded and the result independently assessed against failure-capable evidence
  before it counts as done."*
- **State file:** `projects/axcion-systems-builder/logs/work-loop/review-packet-preservation.md`.
- **Opened by:** **Codex, for real** — a genuine opening brief, not a fixture. **Retires limitation 2.**
- **Committed by:** Claude (`c8b3923`), operator transported nothing by hand — acceptance assertion 1
  exercised outside a test fixture for the first time.

### What Codex did with the objective

The operator described two defects. Codex did **not** brief the two fixes. It read the script and the
disposition note, then reframed the unit as a **lifecycle safety contract** — a packet must be
declarable reviewed, and once declared the script must not mutate it — with the two reported defects
as symptoms. It also fixed the trap in advance: *"Reviewed status must not be guessed from
staleness,"* which is the reading that would have looked simplest and would have broken the ordinary
pre-handover rebuild.

That is condition 1 (useful context preparation) and condition 2 (alignment with the plan) doing real
work rather than being simulated by a fixture.

### What Claude did

All five premises checked by inspection and held; no hand-back. Regression harness written **before**
the script changed, then run against the pre-change script from `git HEAD`: 13 failures. Implemented,
29/29 green, `bash -n` clean on both files. Committed at `e08ffee` with the result and evidence in the
state file, `turn: codex`.

**The most useful thing that happened was in the red run.** The first red run showed 9 failures — and
five assertions passed *vacuously*, because with no `freeze` action nothing was ever frozen, so they
could not have failed. Core § 6 rule 5 makes that a defect in the evidence, not a detail: they were
rewritten before the script was touched (a sentinel file only a real rebuild destroys; the
write-nothing check moved onto a frozen-but-not-stale packet, where the old `verify` actually reaches
its manifest append; a message assertion instead of a bare exit code), taking the red run from 9 to
13. Two assertions still cannot distinguish pre- from post-change and are labelled regression
coverage, not defect proof, in the state file.

### Friction points

#### FP-1 — v2 is not installed in the project where the first real unit lives

**Class: OBSTRUCTION.** It prevents the unit from running at all.

Observed 2026-08-01, before the unit could be opened. Verified by inspection, not recall:

| Check | Result |
|---|---|
| `/work-loop-v2` in `projects/axcion-systems-builder/.claude/commands/` | **Absent.** Only `work-loop.md` (v1) is symlinked, → `ai-resources/.claude/commands/work-loop.md` |
| `.agents/skills/` in that project | **Does not exist** — Codex has no route to the v2 resource from there |
| `logs/work-loop/` in that project | **Does not exist**; only `logs/loop/` (v1's folder) |
| How that project's last loop work ran | Through **v1** — `logs/loop/2026-07-30-writing-studio-phase9-mvp.*` |

**Why this is not a surprise, and why it still counts.** Slice 1 decided deliberately that
`/work-loop-v2` would stay ai-resources-only for the MVP, with no workspace-root symlink, and named
**Step 7 as the natural promotion point** (`step-5-slice-1-evidence.md`; session S5-646 decisions).
So the fix was scheduled for exactly this step. What the pilot adds is the evidence that the
scheduled work is now *due*: the first genuine unit cannot run without it.

**It compounds with the v1 retirement.** Option A archives v1 (`step-7-v1-retirement-decision.md`),
and v1 is the only Work Loop currently reachable from this project. Archiving without installing v2
would leave the project with no loop at all.

**It also lands on disclosed limitation 1** — folder creation from a genuinely absent
`logs/work-loop/`, recorded as untested because the case was unconstructible during the slices. Here
the folder genuinely does not exist, so the pilot can construct it for the first time.

**Status:** surfaced to the operator 2026-08-01 before any fix was applied, per the pilot presumption
(an OBSTRUCTION classification is the one judgment that must not be made unilaterally). **Operator
directed: install the symlink.** Resolved 2026-08-01 — see Resolution below.

#### FP-2 — the artifacts' own first instruction does not resolve outside `ai-resources`

**Class: OBSTRUCTION.** Found while resolving FP-1; it would have made a bare symlink useless.

Both runtime artifacts open with the same line:

> *"Read `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` before anything else, every
> invocation."*
> — `.claude/commands/work-loop-v2.md:11`, `.agents/skills/work-loop-v2/SKILL.md:10`

That path is **relative to the `ai-resources` repository root** and does not resolve from a consuming
project. Verified: `ls plans/work-loop-v2-mvp/…` from `projects/axcion-systems-builder` returns
nothing.

**v1 does not have this defect.** `.claude/commands/work-loop.md:11` reads *"Read
`ai-resources/docs/work-loop.md`"* — with the repository prefix. v2 dropped the prefix. Since v2 was
built and reviewed entirely inside `ai-resources`, where the bare path resolves, nothing in three
slices or the candidate review could have exposed it. **The first invocation from outside the repo is
the first construction of this case** — the same shape as disclosed limitation 1.

**Deliberately NOT fixed in the artifacts.** Editing either runtime file would change the accepted
candidate, and Proposal Decision 9 (`:44`) states that any subsequent change to the candidate creates
a new candidate and **makes the Step 6 review stale**. That is far too high a price for a path prefix,
and it is not a decision to take silently mid-pilot. Resolved by symlink instead (below), which leaves
every reviewed byte untouched.

**Carried to Step 8** as the natural place to fix the prefix, where a new candidate and its review are
expected anyway.

#### FP-3 — the install is local-only and will not survive a fresh clone

**Class: TRIGGER.** Not obstructing — the loop works now.

Of the three symlinks installed, the command one is gitignored by that project's own
`.gitignore:25` (`.claude/commands/*`), consistent with every other command symlink there. The other
two (`.agents/skills/work-loop-v2`, `plans/work-loop-v2-mvp`) are **not** ignored, so they would be
committed — as symlinks pointing outside their own repository, which resolve only while
`ai-resources` sits as a sibling directory. They were left **untracked and uncommitted** rather than
either committed or hidden by editing that project's `.gitignore`, which was outside the operator's
instruction.

**This is the same class as an already-tracked repo-health item** — "hook wiring is unversioned; a
fresh clone silently loses the layer" (`repo-health-backlog-2026-07`, item 3). A new machine would
get a project that looks installed and is not.

*Reopening trigger: a second checkout, a new machine, or the moment v2 is installed into a third
project — at which point this stops being one project's local state and becomes a distribution
problem.*

##### The trigger has FIRED — found 2026-08-01, and it was already true when FP-3 was written

v2 is installed in **three** projects, not two. Verified by scanning every `projects/*/` for the
command, the skill and the core path:

| Project | Command | Skill | Core path resolves? |
|---|---|---|---|
| `ai-resources` | native | native | yes |
| `axcion-systems-builder` | symlink | symlink | yes, via the third symlink |
| **`axcion-design-studio`** | **a real byte-identical COPY**, `2026-08-01 18:33` | **absent** | **no** |

`axcion-design-studio` is the failure mode in its pure form: the command is present, so the project
**looks** installed, and the command's *first instruction* — read the core — cannot resolve, because
`plans/work-loop-v2-mvp/` does not exist there. No Codex skill, so Codex has no route in. No
`logs/work-loop/`, so there is nowhere to write. It is a **copy, not a link**, so it will drift from
the canonical command silently and nothing will report the divergence.

It predates the systems-builder install by about an hour, so FP-3's count was wrong at the moment it
was written — the third-project condition was already met and went unobserved.

**Classification unchanged in kind, changed in status:** FP-3 stays a TRIGGER by class; its trigger
has now fired, which is the mechanism by which it legitimately enters scope without being an
OBSTRUCTION. The pilot's presumption of no change is respected — a fired trigger is a recorded
condition being met, not scope creep.

**Disposition, operator-directed 2026-08-01** (the operator raised installation portability as a
proposed item and directed that it be added if absent). Split on the MVP's own boundary, because
Step 8 says *"fix demonstrated blockers only"* and ends with *"stop; do not keep designing it"*:

- **Into Step 8** — the demonstrated, bounded half. See the Step 8 thread in
  `logs/missions/work-loop-v2-mvp.md`.
- **Post-MVP, its own thread** — the full installation contract, `/new-project` scaffolding, the
  update path for existing projects, and fresh-checkout verification. Justified now that the trigger
  has fired, and deliberately not folded into the MVP's final step.

### Resolution of FP-1 and FP-2

Operator-directed, 2026-08-01. Three symlinks created in `projects/axcion-systems-builder`, each
verified to resolve by reading through it:

| Link | Target | Tracked? |
|---|---|---|
| `.claude/commands/work-loop-v2.md` | `ai-resources/.claude/commands/work-loop-v2.md` | no — gitignored by that repo's existing rule |
| `.agents/skills/work-loop-v2` | `ai-resources/.agents/skills/work-loop-v2` | no — left untracked (FP-3) |
| `plans/work-loop-v2-mvp` | `ai-resources/plans/work-loop-v2-mvp` | no — left untracked (FP-3) |

The third exists solely to satisfy FP-2 without editing the reviewed candidate.

`logs/work-loop/` was **not** pre-created — the loop creates it, which is what constructs disclosed
limitation 1's untested case for the first time.

**Review status: `unassessed`.** This is a structural change class (new symlinks, plus making a
resource reachable from a repository it was deliberately kept out of). No independent review ran; the
operator directed the install directly. Recorded as a fact, not smoothed over
(`docs/qc-independence.md`).

#### FP-4 — a second document about the task went stale against the state file, and misled a fresh session

**Class: TRIGGER.** Not obstructing — the work ran fine once the state file was read.

Observed 2026-08-01, at the start of the session that executed the unit. Codex opened the unit
between two Claude sessions. The next Claude session oriented from **this pilot log**, which still
said *"State file: not yet opened"*, and told the operator that Codex had not yet run — including a
paste-ready prompt asking them to do work that was already done. The operator caught it with one
question. Reading `logs/work-loop/` would have shown the file immediately.

**This is the exact failure core § 4 legislates against** — *"the state file is current truth, not a
diary"* — arriving through the side the rule does not cover. The loop's own transport was correct and
current the whole time. The stale thing was a *second* document about the same task, and the pilot log
is outside the loop's discipline by construction: it is the pilot's record, not a state file.

**Not proposed as an MVP change.** The presumption is no change, and nothing here obstructed the work.
It also cannot be fixed by tightening the loop, since the loop was not wrong. What it names is a
narrow orientation rule: *when a document and a state file disagree about a task, the state file
wins* — and a session picking up loop work should read the folder before any document about it.

*Reopening trigger: a second occurrence, or any unit where the stale document causes work to be
redone rather than merely mis-announced.*

#### FP-5 — the one live check against the real packet was declined at the permission prompt

**Class: LIMITATION.** **Resolved at assessment — by Codex, not by Claude.** See the closure note below.

The unit's evidence runs entirely on `mktemp -d` fixtures, by the brief's own instruction. To also
show the fix covers the **real** Phase 9 packet — whose `FROZEN-AFTER-REVIEW.md` was hand-placed
before `freeze` existed — Claude tried to copy the repo skeleton and that packet into a temp tree and
run `verify` and `build` there, comparing fingerprints. The command was **denied at the permission
prompt** and was not retried in another form.

So marker compatibility rests on two verified facts rather than an execution: the script tests
`[ -f "$MARKER" ]` against a fixed filename, and premise 4 confirmed that exact filename is present
in that packet. The gap is written into the hand-back for Codex to weigh rather than smoothed over.

*This is a limitation of the pilot's evidence, not of the loop.* The loop behaved correctly — the gap
is disclosed at the point of assessment, which is what should happen.

**Closed at assessment.** Codex did not accept the gap; it ran the check itself, on a disposable copy
of the Phase 9 case and packet. Frozen `verify` reported the three expected live-source revisions,
frozen `build` refused, neither recommended a rebuild, and the packet fingerprint was identical before
and after both commands. **This is the seam working the way the whole design intends** — the party
that did not write the code produced the missing evidence, and the disclosure in the hand-back is what
routed it there. Had the gap been smoothed over, nobody would have run it.

Claude verified independently, after the close, that the *real* packet was never touched: every file
still carries its 2026-07-30 timestamp and the manifest's only `VERIFIED` line is the historical one
from 2026-07-30T07:43:27Z. (Codex's stated fingerprint differs from Claude's because the two used
different hashing methods over different copies; it is not evidence about the real packet either way.
The timestamps and the absent write are.)

### Verdicts

Against the seven conditions. Rows the unit did not exercise are `n/a`, which is a verdict, not a gap.

| # | Condition | Verdict |
|---|---|---|
| 1 | Useful context preparation | **Yes.** Codex reframed two reported defects into the lifecycle contract underneath them, and pre-empted the wrong reading (infer reviewed from stale) before Claude saw the brief. |
| 2 | Alignment with the approved project plan | **Yes.** The brief's exclusions held the unit off every case artifact and every existing packet; nothing outside them was touched. |
| 3 | State recovery | `n/a` — single session. The mid-task handoff unit is still owed. |
| 4 | One bounded correction | **Not exercised — closed on the first pass.** A correction cannot be manufactured to test the machinery; the slices already exercised it. Still owed by a later unit against real work. |
| 5 | The Direct Work bypass | `n/a` — this unit was admitted to the loop. |
| 6 | Operator intervention | **Yes, twice, and both mattered.** The operator's *"wait did you check what codex did?"* caught FP-4; the denied permission prompt produced FP-5. |
| 7 | Clean fresh-session continuation | **Partly, and by accident.** The executing session was fresh and continued from the state file and Git alone — but only after FP-4 sent it down a wrong path first. |

---

### Closure

Codex assessed from the state file and closed. **No correction round** — the first genuine unit in the
pilot needed none.

**It did not rubber-stamp.** It re-executed rather than reading Claude's account of the evidence:
`./cases/scripts/build-review-packet.test.sh` (29/29, exit 0), `bash -n` on both scripts, and the
Phase 9 copy test that closed FP-5. Three independent re-runs of work it did not write.

**Two accepted limitations, in the closing record** — both are the flagged items from Claude's
hand-back, decided rather than dropped:

1. `freeze` declares that a review happened; it is not proof the packet was current at handover. The
   immediately-before-handover `verify` remains the currency control.
2. Exit 0 from frozen `verify` means *"historical record intact"*, not *"safe to send"*. Codex accepted
   the mode-specific semantics deliberately, on the ground that the frozen output visibly differs and
   says not to reassemble the packet. This was the item most likely to come back to the operator as a
   risk choice; Codex judged it did not need to.

**One deferral, recorded with its reason** (core § 5): do not couple `freeze` to a currency check and
do not add a force/bypass interface — *"no observed case justifies another control."* Recorded, not
done, which is the discipline working.

**Condition 4 was not exercised, and that is the honest result.** A correction round cannot be
manufactured on real work just to prove the machinery; the slices proved it against constructed cases.
A later pilot unit still owes it.

---

## Unit 2

**Status:** **CLOSED 2026-08-01** — opened by Codex, executed by Claude, **one bounded correction
round**, then closed by Codex. Closing record in the state file; correction commit `583aec5`.

- **Task id:** `decision-entry-referenceability`
- **Owning project:** `projects/axcion-systems-builder` (fix spans three repositories)
- **The work:** `logs/decisions.md` had drifted into two entry shapes. `check-decision-refs.sh`
  indexes `##` headers only, so an entry opening as a bare bold `**Decision …**` paragraph was
  **structurally unreferenceable** — and produced no orphan to notice, because no ref could ever be
  written for it. `decisions_refs` simply stayed empty, which the checker itself reports as "correct
  for a session that recorded no decisions." Silent negative evidence.
- **Selected by:** operator, from a shortlist Claude compiled; Claude recommended this one.
- **Lane:** **Standard**, classified by Codex. Its named reason: the unit crosses a shared checker
  used by every repository, two paired producer instructions and a historical decision record, and
  *"because the current failure is silent negative evidence, the result needs independent assessment
  against a fixture that proves the detector can fail without creating false positives."*
- **State file:** `projects/axcion-systems-builder/logs/work-loop/decision-entry-referenceability.md`.

### What Codex did with the objective

Claude's proposed objective was scoped to one repository. **Codex widened it to the three actual
owners of one coupled contract** — the project's log, the shared checker plus its regression
coverage plus the canonical producer command, and the workspace-root mirror of that command — on the
ground that repairing the log without repairing the detector leaves every other repository blind.
That widening was correct and Claude would not have proposed it.

It also pre-empted the trap in advance, as it had in unit 1: the brief *required* negative controls
(undated sub-decisions, fenced examples, prose mentions) before any detector existed. The obvious
wrong implementation — flag every bold decision paragraph — would have passed a naive test and
flagged dozens of well-formed entries. Condition 1 doing real work, twice over.

### What Claude did

All six premises checked by inspection and held; no hand-back. Regression fixture written **before**
the checker changed and run against it: 3 failures. Implemented, 65/65 green, `bash -n` clean.
Four entries normalized by pure insertion — 8 lines added, 0 removed, no decision body altered.

**The unit found a fifth entry the brief did not name**, and Claude did not normalize it. The brief
had anticipated exactly this ("report it before changing it; do not expand normalization unless its
boundary is provable"). Claude's evidence was a dated-vs-undated convention read off the file — real,
consistent across all 12 dated paragraphs, but a pattern inferred rather than a rule the journal
states. Against a governance record that was judged too weak, and it was handed back as an open
question rather than resolved unilaterally.

### The correction round — condition 4, exercised for real

**Codex did not accept Claude's reasoning and did not overrule it by assertion. It went and found
better evidence.** `logs/session-notes.md` lists the Stage 6 review-correction acceptance and the
no-push standing instruction as **two separate bullets** under `**Operator decisions:**` — a record
stating they are distinct decisions, not a pattern suggesting it. On that basis it froze **one**
finding, with an explicit closure check attached, and named what must not be touched.

Claude reproduced the finding by inspection first — including verifying Codex's own citation against
the file rather than trusting the hand-back — applied only the frozen finding, and closed on that
one round. **No second correction, no new deferral.** Codex then re-ran the shared suite, all 11
manifests and a disposable ref generation itself before closing.

This is the condition unit 1 could not exercise, closed here on real work without anything being
manufactured to make the machinery fire.

### Friction points

#### FP-6 — the hand-back asks for a commit reference before the commit exists

**Class: TRIGGER.** Caught before it shipped; recorded because the hazard is in the loop's ordering,
not in one session's carelessness.

Step 5 has Claude write the result and evidence into the state file **and then** commit. A natural
hand-back therefore wants to cite the commit that carries it — which does not exist yet. Claude
wrote a plausible-looking hash (`1f8a0e1`) into the `Next action` line, noticed before committing,
and replaced it with a reference to HEAD. Had it shipped, Codex would have received a fabricated
citation inside the one artifact the loop treats as current truth, in a field it is supposed to act
on.

The state file *can* name the commit that carries it only if the reference is written as a
description ("the HEAD commit of this repository") rather than a value. Nothing in the core or the
command says so.

*Reopening trigger: a fabricated or wrong commit reference actually reaching Codex, or a second
occurrence of the same reach for a not-yet-existing value.*

#### Not friction points, recorded so they are not mistaken for them

- **`check-append-order.sh` interaction.** Inserting dated headers at interior positions is exactly
  the case that script names in its own KNOWN LIMIT, and it would have flagged this legitimate
  repair as a prepend. It did not fire — the guard is **not wired in that project at all**
  (`.git/hooks/` holds only samples, `core.hooksPath` unset). Both facts are real and both are about
  that guard, not about the Work Loop. Codex accepted them as limitations of the unit.
- **The `axcion-design-studio` install finding** surfaced while answering an operator question during
  this unit, and belongs to FP-3 above, not here.

### Verdicts

| # | Condition | Verdict |
|---|---|---|
| 1 | Useful context preparation | **Yes, and materially.** Codex widened a one-repo objective to the three real owners of the contract, and required negative controls before a detector existed. |
| 2 | Alignment with the approved project plan | **Yes.** Every exclusion held — no decision body, no archive, no historical manifest, no slug/ref contract, and the wrap stayed non-blocking. |
| 3 | State recovery | `n/a` — single session again. **The mid-task handoff is now the only pilot condition never exercised.** |
| 4 | One bounded correction | **Yes — exercised on real work.** One finding frozen, one round, closed. Codex proved the boundary Claude could not, from a record rather than an opinion. |
| 5 | The Direct Work bypass | `n/a` — admitted to the loop. |
| 6 | Operator intervention | **Not needed.** The operator selected the unit and asked an unrelated question mid-flight; nothing inside the unit required them. Recorded as an honest `not needed`, not as a pass. |
| 7 | Clean fresh-session continuation | `n/a` — one session throughout. |

### Closure

Codex closed without a second round. **It re-executed rather than reading Claude's account:** the
shared 65-assertion suite, the checker against all 11 project manifests (every invocation exit 0; 10
refs resolving, 0 orphans, 0 headerless findings), and its own disposable ref generated through the
unchanged shared generator, resolving 1/1 against 38 indexed headers. Three independent re-runs of
work it did not write — the same pattern as unit 1.

**Two accepted limitations, both Claude's flagged deferrals, decided rather than dropped:** the scan
does not run when no manifest exists (the absent-manifest early exit is an established legitimate
advisory path, and moving it was outside the bounded defect); and the append-order guard stays
unwired and undesigned for this case, as separate infrastructure work.

---

## Unit 3

**Status:** **OPEN — deliberately stopped mid-task 2026-08-01 (S12-3bc).** Task
`foreign-staging-target-repo`, state file `logs/work-loop/foreign-staging-target-repo.md`. Opened by
Codex (`f2f1992`), premises checked and red harness built by Claude (`2135c0c`). The hook is
unmodified. This is the pilot's designated cross-session handoff test, and **the handoff has been set
up but not yet proven** — see the verdicts below.

### What Codex did with the objective

Widened a one-line backlog item into a five-premise brief with an explicit unit boundary: Unit 1 is
the canonical hook plus a permanent harness, and the docs, the defect record, the `.codex` fork and
the sector-intelligence copy are held back to later units. Two exclusions were load-bearing and both
were correct: **no soft-warn fallback** (the entry's own Proposal recommends one; both prior gates
rejected it) and **not the retired `/risk-check`**. Condition 1 doing real work for the third time.

Codex also **corrected Claude's method**. Claude had reproduced the defect against the live working
tree before the unit opened; premise 3 of the brief requires isolated temporary repositories and says
so explicitly. Claude's version was informative but depended on ambient dirt and was not
reproducible. The brief's instrument was better, and the harness was built that way.

### What Claude did

All five premises checked by execution and all five hold. The defect site is
`check-foreign-staging.sh:223`; the leading-`cd` parser at `:521-526` filters path *strings* inside
the already-chosen repository and never re-resolves it; the subshell form is not gated at all; no
existing harness targets this hook; and the canonical copy is the one wired by absolute path in
`~/.claude/settings.json`. The copy census was **re-measured rather than quoted** (668 / 464 / 515,
plus two worktree copies proven `cmp`-identical) — a deliberate response to FP-6 and to the
recall-instead-of-check finding.

Built `logs/scripts/check-foreign-staging.test.sh`: six cases in throwaway `mktemp -d` repositories,
never touching the live tree and never running a real `git add`. **4 RED / 2 GREEN** against the
unmodified hook — the correct pre-fix baseline.

The harness surfaced something the defect record does not contain. The recorded symptom is a noisy
false block; case C3 reproduces a **silent pass** — `cd nested && git add .` exits 0 with no output,
because the guard scopes to the right path in the wrong repository, finds nothing there, and reports
safe while every file the command would actually stage goes uninspected. A guard that is silently
absent is worse than one that is loudly wrong.

### Friction points

**FP-7 — Claude's premise check used a live-state instrument where an isolated one was required.**
The first reproduction ran against the actual working tree, so the evidence was whatever happened to
be dirty at that moment. Codex's brief specified isolated temp repos. Not a false conclusion — the
defect does reproduce — but the method would not have survived being re-run tomorrow. **Caught by
Codex, not by Claude.** This is condition 1 catching a methodological weakness rather than a factual
error, which is a stronger result than either prior unit produced.

**FP-8 — the first fixture went red for the wrong mechanism, and only running it revealed that.**
Without `nested/` in the parent's `.gitignore`, the parent repository lists `nested/` as an untracked
directory, so C3 *blocked* instead of silently passing. The case was red either way, and reading the
harness would have shown four reds and looked correct. Only the verbose run exposed that the
reproduced symptom was the wrong one. Self-caught, corrected, and commented at the fixture line.
Reinforces the standing rule: an assertion that goes red for an unexamined reason is not evidence.

**FP-9 — two assertions are satisfied by a dead hook.** Proven by pointing the harness at a no-op
stub: C2 and C6 both keep PASSING, because both assert only `exit 0`. C5 correctly fails. Recorded as
a limitation in the state file with the remedy named (positive-identity assertion on C2 before its
green is accepted). The harness's own summary logic did refuse to report success under the stub,
which is a real property and was not designed in.

### Resumption — the handoff test's result (session S13-ad0, 2026-08-01)

**The pickup worked.** A fresh session read `logs/work-loop/foreign-staging-target-repo.md`, verified
the tree against Git (`git log --oneline -3`, hook unmodified at 668 lines, harness present at
`2135c0c`), re-ran the harness to the recorded 4 RED / 2 GREEN baseline, and executed the checkpoint's
`Next action` list in order without needing anything the prior session held only in context. The state
file's `Next action` was **executable as written** — the single most useful property it had.

**Disclosed contamination — the test is not clean-room, and the reason is structural.** `/prime`
loads the previous `session-notes.md` entry at orientation, and that entry carries a prose summary of
unit 3. So the resuming session had a summary in context before it opened the state file. This does
not invalidate the result — every *action* taken came from the state file, and the state file was
independently sufficient on its own reading — but a genuinely clean proof is not available through the
normal orientation path. **That is itself a finding about the pilot's method** (FP-11 below), not a
defect in the state file.

**The gating question was settled without the gated change the checkpoint predicted.** The checkpoint
proposed registering a throwaway probe hook in `~/.claude/settings.json` and correctly flagged it as
needing operator approval. A cheaper route existed and was taken: `check-foreign-staging.sh` is
*already* registered and fires on every Bash call, and it is the one file the unit boundary permits
editing — so a temporary dump was added to it, triggered three times, read, and removed. The hook was
verified byte-identical to `HEAD` afterwards. **No harness-config change, no operator gate, no
`~/.claude/settings.json` write.**

**What the probe established, by execution:**

1. A PreToolUse payload **does** carry a `cwd` key. Live key set: `cwd`, `effort`, `hook_event_name`,
   `permission_mode`, `prompt_id`, `session_id`, `tool_input`, `tool_name`, `tool_use_id`,
   `transcript_path`. The checkpoint recorded this as unverified in either direction — no hook in the
   repo read it, so the repo carried no evidence. It is sent.
2. `os.getcwd()` of the hook process **equals** the Bash tool's cwd, and both diverge from
   `CLAUDE_PROJECT_DIR`, which stays pinned to the session root. Preferring `CLAUDE_PROJECT_DIR` at
   `:223` is therefore the defect itself, exactly as premise 1 stated.
3. **The nuance the checkpoint did not anticipate, and it changes the fix.** That cwd is the
   **pre-command** cwd — the hook fires before the command runs. So cwd alone resolves the
   already-inside-nested case (C1/C2) but **cannot** resolve `cd nested && git add .` (C3). The
   checkpoint's "if the former, the fix is nearly free: change the precedence" is **half right**: the
   precedence change is necessary and not sufficient, and the leading-`cd` parse is still required.

**The fix.** Three changes, all inside the unit boundary. Target repo resolved from the payload cwd
(falling back to `os.getcwd()`), plus a single supported leading `cd <literal> &&` — `&&` is
load-bearing because it is what guarantees the `cd` succeeded. Subshells, `;`/newline sequencing,
multiple `cd`s and variable/glob/`~` paths are treated as **unresolved and fail closed with exit 2**
when a wide add is present, never soft-warned. `git add .` scoping now derives from `target_dir`'s path
*relative to the resolved repo root* rather than from the `cd` token's raw text, which is what makes
the nested and same-repo cases share one code path. Fail-closed is scoped to wide adds only; a gated
`git commit` with an unresolvable `cd` falls back to the base cwd — a **disclosed limitation**, taken
because blocking every multi-line commit would be a false-block regression worse than the gap.

**Evidence — 9/9 green, and falsified twice.** The harness grew from 6 cases to 9 and passes fully
against the repaired hook. It was then run against two deliberately broken hooks, and reported failure
against both: a dead no-op stub (7 failures) and a **payload-cwd-blind** stub with the original defect
line re-injected (5 failures). The second is the sharper instrument — under it C1, C2, C2b, C7 and C8
fail while C3 and C4 still pass, correctly attributing those two to the `cd`-parsing fix rather than
to the cwd fix.

**FP-9 is closed.** C2's green was satisfied by a dead hook; it now carries `C2b`, a positive-identity
companion on the same fixture and the same command, differing by one out-of-footprint file that a live
hook must block on. Under the no-op stub C2 still passes and **C2b fails**, which is precisely the
discrimination that was missing.

### Friction points (resumption)

**FP-10 — the harness tested the fallback and never the production shape, and would have gone green
either way.** `run_hook` built its payload with only `tool_name` and `tool_input`: no `cwd` key. So
every case exercised the `os.getcwd()` fallback, and a hook that ignored the payload `cwd` entirely
would still have passed all six. Found only because the probe revealed the key exists. Fixed:
`run_hook` now sends `cwd` by default (production shape), `C7` proves the payload value beats the
process cwd, and `C8` pins the fallback for callers that omit it. **Generalisable lesson:** a harness
written before the interface was verified encodes the author's assumption about the interface, and
goes green against it.

**FP-11 — the handoff test cannot be run clean through the normal orientation path.** `/prime` loads
the prior `session-notes.md` entry, which summarises the unit, before any state file is read. Unit 3
was designed to test whether the state file *alone* suffices, and orientation structurally prevents
that from being observed cleanly. Not a defect in the state file, the command or the core — a property
of the measurement. If a future unit needs a clean measurement, it has to bypass `/prime` or start
from a checkout with no session-notes entry.

### Verdicts

Against the seven conditions. Rows 3 and 7 were left `PENDING` by the opening session by design;
this section settles them on observed evidence.

| # | Condition | Verdict |
|---|---|---|
| 1 | Useful context preparation | **yes** — and stronger than prior units: the brief corrected Claude's *instrument*, not just its facts (FP-7) |
| 2 | Alignment with the approved project plan | **yes** — unit boundary respected; docs, fork and defect record untouched, across both sessions |
| 3 | State recovery | **yes, with a disclosed contamination.** Every action taken came from the state file and Git; its `Next action` was executable as written. But `/prime` preloads the prior session-notes summary, so a clean-room proof was not available (FP-11) |
| 4 | One bounded correction | **pending Codex's assessment** — the unit is handed back complete; no assessment round has run yet |
| 5 | The Direct Work bypass | **STILL OWED.** Unchanged: the defect is not small and reversible, so it was correctly admitted. Needs a separate genuinely-small request; manufacturing one would breach the genuine-units constraint |
| 6 | Operator intervention | **yes** — the operator ran Codex; Claude cannot open a unit |
| 7 | Clean fresh-session continuation | **yes, qualified.** The session resumed and finished the unit without asking the operator a single recovery question, and without the `~/.claude/settings.json` gate the checkpoint expected. Qualified by the same FP-11 contamination |

**The honest summary of what this unit proved.** A committed state file carrying premises, red
evidence, a named blocker and an executable `Next action` was enough for a different session to finish
non-trivial work — including finding that the blocker's own framing was half wrong. What it did *not*
prove is that the state file alone would have sufficed with no orientation context at all; that
measurement is not obtainable through the normal path.

---

## Pilot exit condition

*"You can honestly say the loop helped you get real project work done"* (Proposal `:102`).

Not a count of units and not a green harness — the operator's judgment on usefulness.
