---
task: context-engineering-implementation
turn: operator
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
Standard. Both plan-correction rounds pass Codex's closure check. The plan is internally consistent and
remains a draft pending exact-content reapproval; S3 candidate revision and green remain stopped. One final
tightly bounded administrative fix is open because the state does not name the commit to reapprove.

Named reason for the loop: the implementation spans multiple sessions, its scope must remain bounded across
S1–S12, and each result needs assessment by someone other than its builder before progression.

## Brief
**Why:** S3's clean pre-revision run proves that the approved plan's “behaviourally empty” and all-five-red
claims are false on the fixed case: four Slice A behaviours already pass and only CE-3 fails. The operator
authorised the recommended bounded correction; the evidence rule must change before implementation so the
success criterion does not change quietly.

**Initial scope:** edit only
`plans/work-loop-v2-v0.2/context-engineering/context-engineering-implementation-plan-v0.1.md` and this
canonical state file. Correct only the materially affected §4.4 candidate contract, Phase 2 cycle, and S3
Slice A evidence/exit language. Preserve the Slice A family, seeded input, actor model, four counts,
candidate-only variable, isolation contract, later sessions, and all other plan scope.

The operator subsequently authorised the one correction round in `## Next action`; that frozen list is the
only widening of this initial scope.

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
**Codex closure decision:** findings 1–4 are resolved. The accepted three-surface contract remains intact;
the actor, seed, counts, family assignment, later-slice rules, candidate, runtime files, and trial evidence
are unchanged. The remaining historical phrasing at plan line 573 is the explicit deferral named by the
freeze, not an executable contradiction.

**The commit to reapprove — `e1ce895b3da1387bae7ce50623afc3875cb050ba`.** That commit carries the fully
corrected plan content Codex accepted: round 1's three surfaces and round 2's frozen four, together. The
prior approval binds to `cc635d4` and does not cover this content.

*Verified byte-unchanged at the time of recording.* `git diff --stat e1ce895 -- <plan>` is empty, and the
plan's blob hash is `8517a7ef871ace5141b50e3ff16e5264913c9e1a` both in that commit and in the working tree.
The check can fail: `git hash-object` on a one-byte input returns a different hash (`c1b0730e…`), so
identical hashes are a real match and not a constant. No plan edit was made in this unit — `git status`
lists only this state file and the hook-written friction log.

**Round 1 — the three-surface correction — is accepted by Codex** and stands unchanged: §4.4's candidate
contract, the Phase 2 cycle, and S3's evidence and exit language implement all five authorised points,
preserve the family, actors, fixed seed, counts, isolation contract and later sessions, and do not
overclaim all-five red–green causality.

**Round 2 — the frozen four-passage correction — is applied.** All four findings reproduced by inspection
before anything was edited, and all four are resolved.

```
Reproduced (2026-08-02), before editing:
- Finding 1: REPRODUCES — searched the plan for `Phase 2 exit`; found at :895, "every behaviour
  except CE-17 clause 3 demonstrated red-then-green against a constructed failing case".
- Finding 2: REPRODUCES — searched S2 for `contaminated bootstrap`; found at :621-623, "S3's red
  run failing is the evidence … Phase 2 returns to S2".
- Finding 3: REPRODUCES — searched Phase 1 exit for `no CE behaviour`; found at :640, "which is
  what makes S3's first red run capable of failing".
- Finding 4: REPRODUCES — searched the §7.0 table for the S3 row; found at :418, observer checks
  "the red-then-green record and the four counts".
```

**Result: the plan is now internally consistent on the baseline-green rule.** No passage still infers
behavioural absence from textual absence, and no exit condition is unreachable. The plan remains a draft
pending exact-content reapproval; the blocker that stopped reapproval is cleared.

**Evidence — round 1, the three named surfaces** (accepted by Codex; unchanged by round 2). `git diff -U0`
at that commit reported nine hunks and no others. Old line numbers:

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

**Evidence — round 2, the frozen four.** `git diff -U0` since the round-1 commit reports **five hunks and
no others**, at `:418`, `:617`, `:621-623`, `:640-641` and `:895-896` — the four frozen passages, with
`:617` being the paragraph heading of finding 2's own passage. No sixth hunk exists, so nothing outside the
freeze was touched.

| Finding | Passage | What it says now |
|---|---|---|
| 1 | Phase 2 exit `:895` | Every behaviour except CE-17 clause 3 **demonstrated against its constructed failing case** — red-then-green where the pre-revision run was red, preserved baseline evidence plus no regression where it was already green, each recorded as one or the other and neither presented as the other. Clause 3 stays excluded, word for word. |
| 2 | S2 emptiness `:617-632` | Split into three claims: the grep proves textual emptiness only; textual emptiness is **all S2 can establish**, because the candidate is a revision of the live skill and the core already produces some results; a clean pre-revision result is baseline green under §4.4, and Phase 2 returns to S2 **only on evidence of actual contamination** — the candidate's own text or the seed carrying the behaviour in. |
| 3 | Phase 1 exit `:649-654` | The candidate carries "the carriage mechanism and **no explicit CE instruction**", which makes a slice's pre-revision run a real measurement rather than a formality. States outright that it does **not** establish any behaviour is absent. |
| 4 | §7.0 S3 row `:418` | Observer checks "the per-case pre-revision and post-revision record (which cases were baseline green, which were caused green) and the four counts". |

**Evidence — the check can fail, and what it returns.** Searching the plan for the four inference
phrases — `S3's red run`, `S3's first red run`, `red run capable`, `no CE behaviour` — returned four
matches before round 2 and returns **one** now: `:573`, the historical rationale Codex explicitly excluded
from the freeze. `grep -c "red run"` returns 6 as the control, so the pattern form still matches this file
and the drop is a real edit. Round 1's contract is intact: `every behaviour except CE-17 clause 3` still
matches once; S3's four count targets still match verbatim; §7.0's operator-load sentence has zero diff
hunks.

**Not touched, by the freeze:** `:573`'s historical rationale for an S2 drafting decision, which repeats
the old framing while describing why an earlier draft was rejected — carried as a deferral, not silently
dropped. `:350` / `:552` ("a bootstrap that cannot fail") stay as written; they describe a different
failure. Slices B, C and D keep their own exits. No candidate, runtime, fixture, spec, command or evidence
file changed — `git status` lists one plan file and this state file.

**Deferrals carried, unchanged:** candidate-marker wording in plan §7; the plan header's stale O-1 status;
F-10's stale specification line count; S1's range-based scope check not duplicated into its scenario file;
removal of obsolete `wl-root-7f3a` after the operator confirms it is idle; and `:573`'s stale framing. The
valid red root and its primary output are preserved and untouched.

## Next action
Operator: reapprove the corrected plan, or decline it. Nothing proceeds until this is recorded.

**The exact wording to give, if reapproving:**

> I reapprove `context-engineering-implementation-plan-v0.1.md` as the plan of record, bound to commit
> `e1ce895b3da1387bae7ce50623afc3875cb050ba`, dated 2026-08-02.

The commit hash is what makes it an approval of *content* rather than of a filename — the plan's own rule
(header, *Approval binds to content*), and the reason the material edit returned it to draft.

**What reapproval does and does not do.** It restores this plan as the plan of record. It does **not**
authorise implementation: O-1 — whether the specification becomes governing — is still unanswered, and the
plan states that nothing starts until both approvals exist. S3's candidate revision, the green root and
`trials/slice-a-evidence.md` stay stopped either way.

**Declining** returns the task to Codex to reframe S3, with the corrected plan left as a draft.

Writing the approval line into the plan header is a separate unit and was not done here — this fix was
bounded to recording the hash. No further review is owed on the correction.
