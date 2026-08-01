# Work Loop v2 MVP — Step 5, Slice 2: red-green evidence

**Status:** **Slice 2 complete.** All four behaviours (2.1–2.4) green against constructed failing
cases. Continuity exercised by a genuinely fresh session; the bounded correction and its exit menu
exercised through real Codex judgment calls, not scripted ones.

**Session:** S7-3fc (2026-08-01) — a session that did not build the command and had no
conversational memory of the Slice 1 sessions.

**Commits:** `d1891c7` (2.1 fixture + red), `6e9add5` (2.1 green), `38f01e3` (2.2 fixture + red),
`79be420` (2.2 green), `a4ff7ac` (correction shape in both artifacts + fixture + red), `c740fe3`
(seeded implementation), `6a208e8` (Codex assessment committed), `a429a63` (bounded correction),
`2dae52b` (menu fixture + red), `9a9c696` (partial hand-back), `88b2df9` (2.3 closure), `22e987d`
(2.4 closure).

**Harness:** `logs/scripts/work-loop-v2-slice-1.test.sh`, extended from 34 to **78 assertions**,
exit 0 only when all pass. Every new assertion was observed failing before its behaviour ran.

---

## The red-green record

| Point | Result |
|---|---|
| Baseline (Slice 1 only) | 34 passed, 0 failed |
| 2.1 red (fixture opened, unit not run) | 38 passed, 8 failed |
| 2.1 green (fresh-session run) | 46 passed, 0 failed |
| 2.2 artifact-level red (no identity check in command) | 54 passed, 1 failed |
| 2.2 run-level red (pre-edit command mutates foreign file) | 52 passed, 3 failed |
| 2.2 green (rejection, zero writes) | 55 passed, 0 failed |
| 2.3/2.4 red (correction round not yet run) | 59 passed, 11 failed |
| After menu fixture red + partial hand-back | 64 passed, 14 failed |
| After Codex closure of the correction task | 73 passed, 5 failed |
| **Final** | **78 passed, 0 failed** |

## Behaviour 2.1 — a fresh session continues from the state file and Git alone

`fixture-slice2-fresh.md` was opened with a hand-written brief and committed untouched. This
session then ran `/work-loop-v2 fixture-slice2-fresh` for real: checked both claims by inspection,
implemented the unit (one `Continuity:` line into the target), wrote failing-capable evidence
(`grep -c '^Continuity:'` — 0 at the opening commit, 1 after), handed back `turn: codex`, committed.

**What makes the freshness claim true:** this session's only knowledge of the command, the core and
the fixtures came from reading the repository — it did not write the command and the Slice 1
sessions' conversations were not available to it. This closes Slice 1's recorded limitation 2 ("the
command was executed by the same session that wrote it") and stands in for the declined Slice 1
review, per the operator's settled decision (`logs/missions/work-loop-v2-mvp.md`, Step 5 Slice 1
entry).

**Limitation:** 2.1 ran first in the session, but the same session went on to implement 2.2–2.4.
The pickup was fresh; the whole session was not exclusively an exercise session.

## Behaviour 2.2 — a stale or foreign state file is rejected read-only

`fixture-slice2-foreign.md` carries `task: fixture-slice2-other` — a deliberate mismatch with its
filename. **Red was shown at two layers:** the command text carried no identity check (1 assertion
failing), and the pre-edit command, executed against the foreign file, wrote its inspection record
into it before any rejection could occur (3 assertions failing). The red-run mutation was halted at
that first write and reverted — carrying the defective run to an implemented, committed unit would
have polluted history to prove a point already proven.

The fix: Step 1 now validates identity read-only before anything else (core § 6 rule 2). The green
run rejected the file with a plain-words report naming both values and left **zero trace**: no
inspection record, no turn flip, no commit — `git diff` empty, byte-identical to HEAD.

**The file-identity field is now proven** — `step-4-slice-plan.md:63-65`'s "treat the field as
unproven" no longer applies.

## Behaviour 2.3 — exactly one bounded correction, the closure check defers what it newly notices

`fixture-slice2-correction.md`'s unit was implemented with **seeded defects** (a `###` heading where
the brief demanded `##`, a missing `Scope: frozen` line, and an evidence check too weak to see
either) and handed to Codex without being told any of this. Codex's real assessment froze two
findings — the missing line, and the evidence gap — and wrote them into the state file in the
`Correct once — frozen findings:` shape with `turn: claude`, exactly per the resource.

The correction reproduced both findings by inspection first, resolved both (the heading fix read as
part of the "complete end-of-file shape" finding 2 names — stated in the hand-back, not silently
assumed), and produced evidence failing at both prior states (opening commit and seeded commit
`c740fe3`) and passing after. A genuinely attractive adjacent fix — the target's `Status:` line
still naming Slice 1 — was recorded as a **candidate deferral, not implemented**.

Codex's closure check closed the task and recorded that deferral in the closing record with the
reason ("not eligible for another correction round"). The harness asserts **exactly one** committed
correction hand-off across the file's history — a second round would make the count 2 and fail.

## Behaviour 2.4 — one menu choice, on value and risk, when the correction was not enough

The correction task could not demonstrate 2.4 — its correction resolved everything. So 2.4 got its
own constructed failing case: `fixture-slice2-menu.md`, a mid-correction state whose frozen findings
contain one finding resolvable in scope and one naming an **excluded file** (real Slice-1-only
wording in `fixture-slice1-true.md`). The correction resolved the in-scope finding, refused the
excluded one (core § 6 rule 4 — a hand-back, not a judgement call), and handed back **partly
resolved**, honestly, with the unchanged grep count as evidence of the refusal.

Codex's closure check made the real judgment: chose **accept as a written limitation** — named as a
menu choice, argued on value (low: the sibling record is historical and accurate for its time) and
risk (scope violation, weakened traceability), explicitly rejecting further fix, reframe or scope
expansion. No third round was opened; the harness's single-round count held.

**Fixture-material disclosure:** the menu task's first pass and its assessment block were
hand-authored fixture material (same precedent as Slice 1's hand-written briefs); the correction
hand-back and Codex's closure were real moves. The closure prompts named the situation ("could not
fully resolve the frozen findings") but not the required structural response — the deferral
discipline and the menu came from the resource.

---

## Deferrals recorded this slice

1. **Bare Codex invocation** (operator request, this session): let `$work-loop-v2` resolve the open
   task itself — pick the single file whose `turn:` is `codex`, ask when several qualify — so the
   operator types one short line instead of pasting a prompt. New resource behaviour; belongs to the
   Step 6 review or the pilot, not to a mid-flight slice.
2. **The target's `Status:` line still names Slice 1** — deferred by Codex at the correction task's
   closure; still open.
3. **`fixture-slice1-true.md`'s historical Slice-1 wording** — accepted as a written limitation at
   the menu task's closure (not strictly a deferral; recorded here so the list is complete).

## Limitations

1. **Slice 2's opening briefs were hand-written fixtures**, as Slice 1 Claude-side's were. Codex
   opening (1.1) was proven in Slice 1 and not re-exercised here.
2. **2.1's fresh session then implemented the rest of the slice** (see behaviour 2.1 above).
3. **Codex needed one re-run for the menu closure** — the first "done" hand-back left the file
   untouched on disk; the re-run wrote it correctly. Verified by checking disk, which is the
   protocol working as designed; noted as a transport observation for the pilot.
4. **Slice 1's folder-creation limitation stands** — `logs/work-loop/` existed throughout; creation
   from an absent folder remains untested.
