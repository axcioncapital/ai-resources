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
| 1 | Useful context preparation | — | — | — |
| 2 | Alignment with the approved project plan | — | — | — |
| 3 | State recovery | — | — | — |
| 4 | One bounded correction | — | — | — |
| 5 | The Direct Work bypass | — | — | — |
| 6 | Operator intervention | — | — | — |
| 7 | Clean fresh-session continuation | — | — | — |

**At least one Standard-lane unit must need a session handoff mid-task** (Proposal `:96`). That unit
is what exercises rows 3 and 7 for real. It cannot be done inside a single session — it requires a
genuine session boundary.

## Limitations to watch

The six disclosed limitations the candidate carries (`step-6-candidate-review.md` § 8.5). Several name
"the pilot" as their reopening trigger, so this is where they are tested for real. Watch, do not
pre-emptively fix.

| # | Limitation | Reopening trigger | Observed? |
|---|---|---|---|
| 1 | Folder creation from a genuinely absent `logs/work-loop/` is untested | A fresh checkout | — |
| 2 | Most opening briefs were hand-written fixtures | Codex opening a real unit retires this | — |
| 3 | Slice 2's menu task's first pass and assessment block are fixture material | — | — |
| 4 | The writing standard's internal tension is unresolved | Pilot use shows the boundary is unclear or causes drift | — |
| 5 | Core § 6 rule 2 contradicts core § 7 for the file-identity case | A unit where the ambiguity produces a wrong action, or the first core revision | — |
| 6 | Behavioural evidence is largely historical | The pilot is the real test | — |

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

**Status:** selected 2026-08-01, **blocked before opening** — see friction point 1.

- **Task id:** *(not yet allocated)*
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
- **Lane:** not yet classified — that is Codex's call at admission, not Claude's.
- **State file:** not yet opened.
- **Opened by:** intended to be Codex, for real *(which would retire limitation 2)*.

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
(an OBSTRUCTION classification is the one judgment that must not be made unilaterally). Awaiting the
decision on how to proceed.

### Verdicts

*(none yet — the unit has not run)*

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
