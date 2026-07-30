EVIDENCE
UNIT: 2026-07-29-prime-minimum-responsibility-land
STREAM: 2026-07-29-prime-minimum-responsibility
PHASE: land
REPO: ai-resources
BASE: 8655e54
NEXT: Claude — open the successor stream

**Capability:** prime-runtime-delegation

## Premise verification

```
PREMISE: confirmed — the Prove unit is genuinely closed
  · ran: grep -c "^Status: complete" on prove.evidence.md; read the record's frontmatter and Units row
  · observed: 1 match. active_unit read `none` at aa02f87/9dad997; the Units row records
    "close — G2 release DECLINED" with commits cb11500, e8809f2.

PREMISE: confirmed — `revise` is in the ACTIVE set
  · ran: grep -oE "in-development|continue-trial|revise|paused" templates/capability-record.md | sort -u
  · observed: all four returned. `revise` is ACTIVE, so § Resume order Tier 3 keeps matching this
    record and the capability does not silently drop out of resume.

PREMISE: confirmed — the mission is active and its assertion is unmet and visible
  · ran: grep -nE "^status:|300" logs/missions/lean-prime-2026-07.md
  · observed: `status: active`. The validation contract still reads "`wc -l` on canonical `prime.md`
    returns **≤300**, re-derived live at close, not carried from a plan", and its checkbox is
    unticked. Nothing was softened; the failure stays visible as directed.

PREMISE: confirmed — no stream artifact is uncommitted at close
  · ran: git status --short logs/loop/ | wc -l
  · observed: 0.
```

**No load-bearing premise rejected.**

---

## Lifecycle decision — HOLD. `status: revise`

Not adopted, not rejected. The capability continues under an ACTIVE status.

**Why not adopt.** The Prove unit closed with release declined at G2. The extraction's call site is
broken in 31 of the 32 roots that carry it; thirteen of nineteen criteria are `unassessed`.

**Why not reject.** The defect is a locator seam, not the capability. Four slices landed and are sound
in substance: `prime.md` 635 → 413 (−222), the allocator extracted to a script that passes its own suite
19/0, and thirteen orientation regions compressed with rationale relocated to five existing documents.
Reverting would discard all of that to fix one path. The operator's direction is explicit that the
retained work is kept.

**What `revise` buys.** The record stays in the ACTIVE set, so a bare `/work-loop` keeps resuming this
capability until it is genuinely finished. `adopted` would end it at a broken state; `paused` would
require a `reopen_trigger:` and misdescribe work that is proceeding immediately.

---

## What this stream achieved, and what it did not

**Achieved.** `prime.md` 635 → 413 (−222 lines, −22,778 chars per read across the symlinked consumers).
Marker allocation extracted from 147 lines of prompt prose to a 15-line call site plus a tested script.
`prime-allocator.test.sh` repointed from an awk scrape of markdown to the real executable, holding 19/0.
Auto mode's approval gate delegated to `/session-start`.

**Not achieved.** The ≤300 target — 413, short by **113**. F-CITE — one dangling citation to a removed
step. C2's no-renumbering constraint — breached, 7 ids removed and 3 minted. And the extraction does not
execute anywhere except `ai-resources`.

**The honest summary: a real reduction that does not yet run.** Both facts are carried forward; neither
is netted against the other.

---

## Root cause, carried to the successor

The recommendation the stream was working from asked for **one executing owner performing the complete
atomic session-entry sequence**, called once by `/prime`. What shipped owns **one third** of that
sequence — Step 8k allocates the marker and explicitly "does NOT touch `session-notes.md`", leaving the
header append and the mtime write in the prompt, which still references `session-notes.md` 17 times.

The defect is what a half-move looks like: a partial owner, reached by a path that resolves in one root
out of thirty-two. The successor stream completes the move rather than patching the path — a corrected
locator on a one-third owner would still leave the other two thirds in the prompt.

---

## Successor stream — what it inherits

Opened as a new stream, not a continuation of this one: this stream's Shape plan is falsified and its
approved slice list is spent.

**Inherited as settled, not reopened:** the ≤300 target · the six-responsibility architecture · the
retirement list · the move-out list · the retain-and-compress list · Codex as sole reviewer.

**Inherited as work:**
1. Correct the script-location / session-entry seam; prove it from a real project-consumer root.
2. Complete the session-entry owner so it performs marker + header + mtime as one atomic unit.
3. Execute the remaining removals and move-outs.
4. Re-run behavioural verification from project consumers.

**Not inheritable.** The thirteen `unassessed` criteria cannot be carried. Every dispatch criterion must
be re-run from a real project-consumer root against the then-current package, and F-DUP needs an
explicit list of its eight declarations committed before it can be measured at all.

---

LIMITATIONS:

- **This brief is Claude-authored**, composed from the operator's written direction rather than framed
  by Codex. The unit has had no independent framing. Accepted because the decision it records is an
  operator decision, not an analytical result — but it is a real weakness of the unit and is recorded
  rather than glossed.
- **No independent review on this unit.** Land carries no review under the challenged route
  (`docs/work-loop.md` § The challenged route — Frame, Build and Land carry none). The last independent
  judgement on this capability is the Prove unit's `review-1`.
- **The successor stream's scope is stated but not yet costed.** No line budget, slice list or
  falsification criteria exist for it. Those are its Shape unit's deliverable and are deliberately not
  pre-empted here — this unit opens the stream, it does not design it.
- **`docs/session-marker.md:339`'s dangling citation and the C2 renumbering breach are left unrepaired**
  and are carried as inherited work. Repairing them here would be an edit outside this unit's stated
  scope.
- **The 413 figure is HEAD-relative-adjacent, not HEAD.** It is `prime.md` at `8b49da2`; HEAD is 411
  after the unrelated retirement commit `38981e5`. Both are above 300 and neither is an endpoint.

Status: complete

---

## CLOSE

```
CLOSE
UNIT: 2026-07-29-prime-minimum-responsibility-land
OUTCOME: close
COMMITS: 8655e54 (unit opened) · this commit (decision, stream close, artifact deletion)
```

**What closed.** The Land phase and, with it, the stream `2026-07-29-prime-minimum-responsibility`.
Capability `prime-runtime-delegation` set to `status: revise` — ACTIVE, resumable, not adopted.

**The stream closes with this unit.** Every `logs/loop/2026-07-29-prime-minimum-responsibility-*` file
is deleted in this same commit per `docs/work-loop.md` § Artifacts. All are recoverable from git; the
SHAs are written into the record's `## Pointers` before deletion.

**Mission `lean-prime-2026-07` stays `active`** with its ≤300 assertion unticked. `/work-loop` is not
the writer of mission files and does not touch it.
