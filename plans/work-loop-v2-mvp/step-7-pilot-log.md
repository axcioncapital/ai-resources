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

**Status:** not yet opened — awaiting operator selection of a genuine unit.

- **Task id:** —
- **Owning project:** —
- **Objective (operator's words):** —
- **Lane:** —
- **State file:** `logs/work-loop/—`
- **Opened by:** — *(Codex opening this for real retires limitation 2)*

### Friction points

*(none yet)*

### Verdicts

*(none yet)*

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
