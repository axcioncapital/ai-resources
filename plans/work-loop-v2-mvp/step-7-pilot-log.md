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
| 1 | Useful context preparation | yes | — | — |
| 2 | Alignment with the approved project plan | yes | — | — |
| 3 | State recovery | n/a | — | — |
| 4 | One bounded correction | not exercised | — | — |
| 5 | The Direct Work bypass | n/a | — | — |
| 6 | Operator intervention | yes ×2 | — | — |
| 7 | Clean fresh-session continuation | partly | — | — |

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
| 6 | Behavioural evidence is largely historical | The pilot is the real test | **Improving.** Premise-checking, red-before-green and the hand-back all ran live in unit 1 on real work |

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

**Status:** not opened.

---

## Unit 3

**Status:** not opened.

---

## Pilot exit condition

*"You can honestly say the loop helped you get real project work done"* (Proposal `:102`).

Not a count of units and not a green harness — the operator's judgment on usefulness.
