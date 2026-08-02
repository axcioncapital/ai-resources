---
task: context-engineering-implementation
turn: codex
---

## Objective and approved scope
Implement and prove the governing Context Engineering specification according to the approved implementation
plan, one evidence-gated session at a time. Phase 1 is complete: S1 established a measurable CE-9 recovery
instrument, and S2 established explicit-file carriage.

Governing specification: `plans/work-loop-v2-v0.2/context-engineering-spec-v0.1.md`, approved against
`148689d42ee7817239219417a1b884b961660f86`. Plan of record:
`plans/work-loop-v2-v0.2/context-engineering/context-engineering-implementation-plan-v0.1.md`, approved
against `cc635d4`.

## Current lane and unit
Standard. Bounded plan correction authorised by the operator after S3's valid pre-revision run falsified
the all-five-red premise. S3 candidate revision and green remain stopped until the corrected plan is
assessed and reapproved against its exact content.

Named reason for the loop: the implementation spans multiple sessions, its scope must remain bounded across
S1–S12, and each result needs assessment by someone other than its builder before progression.

## Brief
**Why:** S3's clean pre-revision run proves that the approved plan's “behaviourally empty” and all-five-red
claims are false on the fixed case: four Slice A behaviours already pass and only CE-3 fails. The operator
authorised the recommended bounded correction; the evidence rule must change before implementation so the
success criterion does not change quietly.

**Scope:** edit only
`plans/work-loop-v2-v0.2/context-engineering/context-engineering-implementation-plan-v0.1.md` and this
canonical state file. Correct only the materially affected §4.4 candidate contract, Phase 2 cycle, and S3
Slice A evidence/exit language. Preserve the Slice A family, seeded input, actor model, four counts,
candidate-only variable, isolation contract, later sessions, and all other plan scope.

The corrected contract must state:

1. “No CE content” means no explicit family instructions; it does not establish behavioural absence where
   the existing Work Loop skill or executable core already produces the specified result.
2. A clean pre-revision pass is baseline evidence, not contamination. It cannot be relabelled red or
   discarded merely to manufacture causality, and the seed cannot be tuned after the result.
3. For S3, retain the recorded baseline-green evidence for CE-1, CE-2/CE-17 clause 2, CE-15, and CE-17
   clause 1; require genuine red–green causality for CE-3; and require the unchanged green run to show CE-3
   passing plus no regression in the four baseline-green behaviours.
4. The candidate revision still makes all five Slice A behaviours explicit and adds no later family. The
   completed evidence record must distinguish pre-existing baseline behaviour from behaviour caused by the
   candidate revision rather than claiming all five were made green by it.
5. S3 exits only when the same seed passes all five behaviours, the four counts meet their existing
   targets, the CE-3 red and green primary outputs remain inspectable, and the four baseline-green cases
   remain green.

Because this changes a material exit condition, follow the plan's content-bound approval rule: make the
corrected plan a draft pending reapproval of its exact committed content, while preserving the prior
approval as history. Do not use this unit to repair the separately deferred stale O-1 header text.

**Evidence capable of failing:** show the exact plan passages changed; demonstrate that no later phase,
family assignment, actor, count target, seeded-input rule, or candidate/runtime file changed; and show that
the corrected wording cannot be read as all-five red–green causality. Stop if the correction requires a
specification change or expands beyond the three named plan surfaces.

## Latest material result
```
Inspected (2026-08-02):
- Red artifact: HOLDS — the recorded pre-revision output exists at the handback path and hashes
  688baf120ad75068fbdb74cc267e496930cef91822f6a8af8eef4484779c2b0f, matching the record; 76 lines.
- Plan asserts behavioural absence from textual absence: HOLDS — searched the plan for the §4.4
  candidate contract; found at :206-209, "because Phase 2's red runs depend on those behaviours
  being absent."
- Plan asserts the first red run genuinely fails: HOLDS — searched Phase 2 for `behaviourally
  empty`; found at :625-628, naming CE-1, CE-2, CE-3, CE-15 and CE-17's clauses.
- S3 exit requires all-five causality: HOLDS — searched S3 for `Exit:`; found at :656, with
  :650-655 requiring "the red run first" and failing "a green run with no recorded red run".
- Content-bound approval rule exists: HOLDS — searched the header for `Approval binds to content`;
  found at :13-17, returning the plan to draft on a material edit to exit conditions.
- Prior approval is commit-bound: HOLDS — searched the header for `Approved commit`; found
  cc635d4, dated 2026-08-02.
```

**Result: the bounded correction is applied to the three named surfaces, and the plan is back to draft
pending content-bound reapproval. It is not complete across the plan** — four further passages still
assert the falsified rule, every one of them outside the three surfaces this brief allowed. They are in
`## Unresolved blocker` and only Codex can decide them.

**Evidence — the exact passages changed.** `git diff -U0` reports nine hunks and no others. Old line
numbers:

| Old lines | Surface | What changed |
|---|---|---|
| `:3-4` | Header stage line | `approved as the plan of record` → **`draft pending reapproval`**, materially edited 2026-08-02. |
| `:24-28` | Approval block | Current status `DRAFT — reapproval outstanding`; the prior approval retained verbatim as history, still bound to `cc635d4`; the material edit and its cause recorded beneath. |
| `:206-213` | §4.4 candidate contract | "No CE content" redefined as a claim about the candidate's *text*, not the thread's behaviour, because the candidate is a revision of the live skill and the executable core already produces some results. A clean pre-revision pass declared baseline evidence, not contamination — not relabellable, not discardable, seed not tunable after the result. **Baseline green** and **caused green** defined; a slice proves causality for the second and no-regression for the first. |
| `:619-631` | Phase 2 cycle | Cycle block now reads "record the result, per case" instead of "it fails, recorded" / "it passes, recorded". The pre-revision run is recorded per case, not assumed red. A slice proves causality only for cases it can show failing first; an all-green pre-revision run is a finding handed back, not a proof. |
| `:642` | S3 candidate change | One clause added: a baseline-green behaviour is still written into the candidate explicitly. Family assignment itself untouched. |
| `:650-656` | S3 evidence and exit | The recorded four-green/one-red result written in as the pre-revision evidence; the four retained as baseline green and protected from relabelling or re-seeding; **CE-3 named as the one case owing red-then-green**; exit now requires all five passing, CE-3 causal with both primary outputs inspectable, the four baseline cases unregressed, and the four counts met. |

**Evidence — nothing else moved, and the check can fail.** `grep -n 'all five behaviours demonstrated
red-then-green'` matched **twice** before the correction (S3 `:656`, S6 `:815`) and matches **once** now
(S6 only, `:862`). That single surviving match is the control: the pattern form still matches this file, so
the S3 disappearance is a real edit and not an unreadable-input artifact. `grep -c 'behaviourally empty
carriage'` went **1 → 0**, with `grep -c 'red-then-green'` returning 8 as its control.

**Evidence — what was preserved.** Verified by inspection after the edit: the Slice A family header is
unchanged (`:672`, CE-17 clauses 1–2, CE-1, CE-2, CE-3, CE-15); all four count targets survive verbatim
(`:696-699` — passes 1, operator context actions 0, artifacts 1, orientation ≤3); the §7.0 actor table's S3
row is byte-unchanged (`git diff` on it returns zero hunks), so lead and observer are as approved; and
`git status` lists exactly one plan file changed. `git diff --stat` over `.agents/skills/`, `trials/`, the
specification, `plans/work-loop-v2-mvp/` and `.claude/` is **empty** — no candidate, runtime, spec or
command file changed. No hunk falls past old line `:656`, so S3b and every later session, phase and exit
are untouched. The seeded input rule lives in this file's brief, which the correction did not edit.

**Deferrals carried, unchanged:** candidate-marker wording in plan §7; the plan header's stale O-1 status;
F-10's stale specification line count; S1's range-based scope check not duplicated into its scenario file;
removal of obsolete `wl-root-7f3a` after the operator confirms it is idle. The valid red root and its
primary output are preserved and untouched.

## Unresolved blocker
**The falsified rule survives in four passages outside the three surfaces this brief allowed me to edit.**
Each was found by inspection after the correction; none was changed. The plan is internally contradictory
until Codex decides them, and the first one makes S3's corrected exit unreachable.

1. **`:895` — Phase 2 exit.** "every behaviour except CE-17 clause 3 demonstrated **red-then-green**
   against a constructed failing case." S3's corrected exit cannot satisfy this: four of its five
   behaviours are baseline green and have no red run to show. **This is the material one** — as it stands,
   Phase 2 can never exit even if every slice succeeds.
2. **`:621-622` — S2, how behavioural emptiness is established.** "**S3's red run failing is the
   evidence.** If S3's red run comes back green, the first diagnosis is a contaminated bootstrap, not a
   candidate that already works, and Phase 2 returns to S2 rather than recording a behaviour as proved."
   This is the direct opposite of corrected point 2, and it is the rule that would send the completed S3
   run back to Phase 1 as contamination.
3. **`:640` — Phase 1 exit.** "…contains the carriage mechanism and no CE behaviour — which is what makes
   S3's first red run capable of failing." Same inference from textual absence to behavioural absence that
   §4.4 now rejects.
4. **`:418` — §7.0 actor table, S3 row.** Observer checks "the red-then-green record and the four counts".
   Minor and descriptive, but it names the wrong record shape for S3.

Also noted, not proposed for correction: `:573` repeats the same reasoning as historical rationale for an
S2 drafting decision, and `:350` / `:552` ("a bootstrap that cannot fail") remain **valid as written** —
they describe a candidate *declared* to carry behaviours it is then required to lack, which is a different
failure and is untouched by this result. Slices B, C and D keep their own all-five/all-three red-then-green
exits at `:792`, `:822` and `:862`; those behaviours have not been run and this result does not falsify
them.

## Next action
Codex: assess the bounded correction, then decide the blocker. Two questions, in order.

1. **Is the correction right on the three named surfaces?** Does the corrected §4.4 contract, Phase 2 cycle
   and S3 evidence/exit language state the five required points, preserve everything the brief named as
   preserved, and stay unreadable as all-five red–green causality? The evidence and its controls are above.
2. **What happens to the four surviving passages?** They are outside the three surfaces this brief allowed,
   so correcting them was not mine to do. Codex decides: widen the correction to name them, accept the
   contradiction as a written limitation, or reframe. **`:895` needs an answer either way** — Phase 2's exit
   as written cannot be satisfied by the corrected S3, so leaving it stands the build on a condition no
   session can meet.

The plan is a draft pending reapproval bound to the commit carrying this correction, not to `cc635d4`.
Reapproval is the operator's, not Codex's, and it should not be sought until question 2 is settled — a
second material edit would return the plan to draft again.

S3's candidate revision, the green root and `trials/slice-a-evidence.md` remain stopped.
