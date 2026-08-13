# Work Loop v2 MVP — Step 5, Slice 3: red-green evidence

**Status:** **Slice 3 complete.** All four behaviours (3.1–3.4) green against constructed failing
cases. Admission, de-escalation and mid-unit deferral are Claude-side moves and were run for real;
every closing and assessment call was made by Codex, including one that refused to close.

**Session:** S8-7c0 (2026-08-01).

**Commits:** `8434f34` (fixtures + red), `f0b06c1` (both artifacts), `317c5dd` (3.1a Direct Work),
`0d10ad7` (3.2 de-escalation), `937e7ea` (3.3 hand-back), `0ce289f` (Codex closes 3.3),
`026d26d` (3.4 first pass), `10e08d2` (Codex freezes a correction), `cab88dd` (bounded correction),
`149c812` (harness rework), `7a97348` (Codex closes the correction), `6df5794` (close task opened),
`00e113d` (close unit), `e66cd1d` (Codex closes at pilot quality), `59cabcd` (final harness fix).

**Harness:** `logs/scripts/work-loop-v2-slice-1.test.sh`, extended from 78 to **136 assertions**,
exit 0 only when all pass. Every new assertion was observed failing before its behaviour ran.

---

## The red-green record

| Point | Result |
|---|---|
| Baseline (Slices 1–2) | 78 passed, 0 failed |
| Slice 3 red (fixtures opened, nothing run) | 82 passed, 46 failed |
| After both artifacts carry the behaviours | 101 passed, 27 failed |
| After 3.1a Direct Work | 105 passed, 23 failed |
| After 3.2 de-escalation and closure | 116 passed, 12 failed |
| After 3.3 hand-back and Codex's closure | 122 passed, 6 failed |
| After the 3.4 correction round and its closure | 126 passed, 9 failed¹ |
| After the close task's unit | 129 passed, 6 failed |
| After Codex closed at pilot quality | 134 passed, 1 failed |
| **Final** (assertion corrected, see 3.4) | **136 passed, 0 failed** |

¹ The failure count rises here because the harness was reworked mid-slice — the 3.4 block was
split into two tasks (below), adding nine assertions that no run had yet satisfied.

## The scope decision this slice had to make

The slice plan gives Slice 3 no split point and does not say whether admission, de-escalation and
mid-unit deferral belong to the Claude command, the Codex resource, or both. **Decision: both, and
asymmetrically** — each side carries the part it can act on. Claude's command gained an `Admission`
section (Direct Work default, named reason, the refusal), a `De-escalating` section, and the
deferral rule inside Step 4. The Codex resource gained an `Admission` section (refuse to open on
felt importance; write the named reason into the file it opens) and one line in its assessment
section closing a task found smaller than assumed. The ground: the Slice-2-era scope-exclusion
lines being replaced existed in both artifacts, so both had promised the behaviour.

## Behaviour 3.1 — the admission test routes correctly

**(a) A two-file reversible fix is Direct Work.** Both fixture targets carried stale `Status:`
lines. The request was made and handled directly: two files edited, said out loud, **no state file
opened** — the harness asserts the positive fixes first and the absence of a new task file second
(an absence-only assertion would pass before anything ran).

**(b) "This feels significant" is refused.** Both artifacts carry the refusal rule.

**Closed on live evidence 2026-08-01, session S9-6ba (Step 6).** ~~Limitation: the live Codex
refusal was offered to the operator and not run, so 3.1(b) rests on artifact-level evidence plus
the absent file, not on an observed refusal. This is the weakest evidence in the slice.~~ Codex was
given the request and **refused admission on its own**, with nothing in the request or the prompt
naming the admission rule. It recorded in `logs/work-loop/fixture-step6-admission.md` that "this
feels significant" is "explicitly not a qualifying reason under the executable core", declined to
choose Direct Work because the request was not bounded enough, set `turn: operator`, and routed the
request back for either a narrow reversible fix or a concrete named reason. No brief, no lane and
no unit were written. Committed `6e3afa1`.

The harness assertion changed with the evidence: the old absence test
(`! ls logs/work-loop/ | grep -qi 'significant'`) became meaningless once the request itself had to
be carried by a state file, and was replaced by seven substance assertions read from history
(`07afcc4`), six of which were proven to go red against a task that *was* opened with a brief.

**Two findings came out of this run, both carried into the Step 6 review:**
1. Codex could not see a chat-pasted request at all — the first attempt returned "no task visible".
   Root cause and options: `issue-codex-request-intake.md`. Second occurrence of this class.
2. Codex's reply ended `**Next:** run /work-loop-v2 in Claude` while the file it had just written
   said `turn: operator` — the two disagree. `SKILL.md:22` supplies that exact line as its only
   worked example of the required Next instruction.

Every task opened this slice carries `Named reason for the loop:` in its opening commit — asserted
at the opening commit for all four tasks, not in the working tree.

## Behaviour 3.2 — work that turns out smaller de-escalates and closes

`fixture-slice3-deescalate` was opened assuming a multi-unit restructure. Inspection showed the
file is eleven lines with one section and the objective reduces to a single additive line. The task
**de-escalated**: reduced to the closing record with the reason and what was learned under
`## Decisions that matter`, `turn: operator`, and the work finished directly in the same commit.
The harness asserts the closing shape, that no active field survived, and that the fix itself
landed (`grep -c '^Deescalated-fix:'` — 0 at the opening commit, 1 after).

## Behaviour 3.3 — a mid-unit improvement is deferred, not implemented

The bait was seeded into the working area **before** the unit ran and committed there: a misspelled
`Note:` line ("teh", "obvios") sitting directly beside the insertion point. The unit added its one
line and left the bait untouched, recording it in the hand-back as a deferral with its reason. The
misspellings are both the temptation and the assertion anchor — a tidied line no longer matches, so
implementing the bait fails the block.

Codex then closed the task and **kept the deferral in the closing record**, which the harness
asserts separately: a deferral that vanishes at closure has silently disappeared after all.

**One harness defect was found and fixed here.** The hand-back assertions read the working tree, so
they broke the moment Codex's closure legitimately erased the live fields — the same lesson Slice 1
recorded for behaviour 1.1. They now read the hand-back at the commit that carried it.

## Behaviour 3.4 — a good-enough result with written limitations is closed, not corrected

**This behaviour took two tasks, and the first one failing is the most useful result in the slice.**

`fixture-slice3-limits` was designed as the close case. Its limitation 1 said the note reflected
only the runs committed so far — but the task's own objective demanded wording that covers *every*
Slice 3 run. Codex's real assessment caught the contradiction and **froze a correction instead of
closing**. That was the correct call: a limitation that contradicts the objective is a finding, not
an accepted limitation. The fixture was mis-designed, not the behaviour. The task then ran as a
clean 2.3-class round — one bounded correction, reproduced by inspection first, then closure with
the non-material phrasing difference accepted as a written limitation.

`fixture-slice3-close` was then designed properly: limitations that sit *beside* the objective
(the marker names the slice rather than its four behaviours; the line sits in a flat record list
rather than its own section). Codex closed it at pilot quality, **opened no correction round**, and
carried both limitations into `## Accepted limitations`. The harness asserts zero correction rounds
across the file's whole history — a correction would make that count 1 and fail.

**A second harness defect was found at the last assertion.** It required the limitations to be
bullet-shaped; Codex wrote them as prose. Nothing in the core or the slice plan fixes that format,
so the assertion was testing punctuation rather than behaviour. It now identifies each limitation
by a term only it uses, and was proven falsifiable by breaking one term and observing the failure.

---

## Fixture-material disclosure

- **The three Slice 3 opening briefs were hand-written**, as Slice 1's and Slice 2's were. Codex
  opening a unit is behaviour 1.1, proven in Slice 1 and not re-exercised here. The fourth task's
  brief (`fixture-slice3-close`) was also hand-written at the operator's direction after the Codex
  opening prompt did not land.
- **Every closing and assessment call was Codex's**, made from the state file without being told
  the required structural response: closing 3.3 with its deferral, refusing to close 3.4's first
  pass, closing it after one correction, and closing the clean case at pilot quality.

## Deferrals recorded this slice

1. **The `Note:` line's misspellings in `fixture-target-2.md`** — deferred mid-unit by 3.3, then
   deferred again by Codex at closure. Deliberately still open: it is 3.3's assertion anchor, and
   fixing it would weaken the test.
2. **Bare Codex invocation** (carried forward from Slice 2, still open) — let `$work-loop-v2`
   resolve the open task itself rather than requiring a pasted prompt. Belongs to Step 6 or the
   pilot.

## Limitations

1. ~~**3.1(b) has no live refusal**~~ — **CLOSED 2026-08-01, session S9-6ba.** Codex refused
   admission live and unprompted; see behaviour 3.1 above. Commit `6e3afa1`, harness `07afcc4`.
2. **This session built the command and then ran it.** Slice 2's fresh-session pickup (2.1) is what
   proves continuity; this slice did not re-exercise it.
3. **The 3.4 close task's brief was hand-written by the session that then ran the unit**, so its
   opening and execution share an author. Only the assessment was independent.
4. **Slice 1's folder-creation limitation stands** — `logs/work-loop/` existed throughout.
