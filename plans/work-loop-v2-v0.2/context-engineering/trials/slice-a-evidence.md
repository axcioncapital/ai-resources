# Slice A — evidence record (S3)

Behaviours under test: CE-17 clauses 1–2, CE-1, CE-2, CE-3, CE-15.
Governing sources: specification §2, §4.1, Family 1, CE-15; plan of record §7 S3 and §4.4.

**Headline: CE-3 is demonstrated red-then-green. The other four were baseline green before the revision
and remain green — they are not caused by it.** Stating otherwise is the §4.4 overclaim this record is
required to avoid.

---

## 1. The same input, twice

Both runs received a byte-identical prompt. The only substitution between them was the root path; the
operator's request below was pasted verbatim in each, with nothing added.

> Prepare the next Harbourview Work Loop unit. It must correct the wrong arrival hour and identify every
> confirmation affected since 2026-06-14, even though identifying all of them is the inconvenient half of
> the objective. I do not remember where the Harbourview material lives in this repository. I also do not
> know which repository surface parses the availability timestamp; establish that by inspection rather
> than guessing. Once the affected set is known, whether guests should be contacted in this unit or later
> remains my decision.

The request's three stated unknowns are what cases CE-1, CE-2 and CE-3 measure.

## 2. The candidate was the sole behavioural variable

Both evaluation roots were built from baseline `32d3c26` by the same six-step rule, outside the shared
checkout, each with no `.git`, both installed Work Loop skills removed, the four answer-key files removed,
and every file containing the live-checkout path literal deleted (17 → 0, positive control returning 1).

*Proved by direct comparison, not by assertion.* Before the green run, `diff -rq` between the two roots
returned exactly two lines: the candidate differed, and `logs/work-loop` existed only in red (that root's
own produced output). After the green run it returns exactly two lines again — the candidate, and the two
now-differing outputs. File counts: 541 red, 541 green. Every other file in the two roots is byte-identical.

| | Red run | Green run |
|---|---|---|
| Root | `wl-root-4c8d` | `wl-root-9e2b` |
| Candidate SHA-256 | `956c76f37230fb2a6b4d1605afecdcb4edd64a5828803464c29a0c9689720868` | `5b3f591b9525bc2046494184e9968bf6f46735ad78f0c01c2c78cb4cb6896679` |
| Primary output SHA-256 | `688baf120ad75068fbdb74cc267e496930cef91822f6a8af8eef4484779c2b0f` | `bbd92af73f77dfe0a4ead47e2a57fdc541e65ad19329f6583e8dd0a4c06e2a57` |
| Output path in root | `logs/work-loop/harbourview-arrival-hour.md` | `logs/work-loop/harbourview-arrival-hour.md` |

The revision itself is one pure insertion: `diff` of the live skill against the revised candidate returns
one hunk, **8 lines inserted, 0 deleted, 0 modified**. Neither run modified its candidate — both hashes are
unchanged after the runs.

Both primary outputs remain independently inspectable in their own roots, and preserved copies are held at
`…/scratchpad/s3-primary-outputs/{red,green}-harbourview-arrival-hour.md` with the hashes above.

## 3. Per-case result

Line numbers cite the primary outputs.

**CE-3 · Resolvable uncertainty becomes a discovery unit — RED → GREEN. Caused by the revision.**
*Red (fails):* the unit is an implementation unit — "Unit 5 — correct arrival-hour handling and establish
the complete affected-confirmation set" (red:21) — with discovery demoted to an internal gate: "If both
discovery gates hold, reproduce the wrong-hour behaviour with a failing check, then make the smallest
change" (red:49–51). Its own preparation had already established that no implementation or record corpus
existed — "it found no Harbourview implementation or confirmation ledger beyond the four CE-9 source
fixtures" (red:42–44) — and the unit was still framed as implement-with-gates rather than
discover-then-reframe. Having the evidence and not reframing on it is the failure, not merely the wording.
*Green (succeeds):* "Unit 1 — discover the actual parser and authoritative confirmation-record surface …
so Codex can reframe the corrective unit without guessing" (green:12); "This unit is read-only discovery:
do not implement the correction" (green:21); "Reframe from the evidence or stop; do not invent missing
paths, fields, time-zone semantics, or records" (green:29). CE-3's succeeds-if shape — establish X, inspect
Y, return evidence, then reframe or stop — appears in that order, with a checkable completion condition
(green:56) and explicit stop conditions (green:58).

**CE-1 · Nothing derivable is asked of the operator — baseline green, still green.**
The request said the operator does not remember where the Harbourview material lives. Neither run asked.
*Red:* cites `…/fixtures/ce-9/task-state.md` and `…/fixtures/ce-9/project-plan.md` (red:28–32).
*Green:* cites all three fixture sources with their roles (green:33–35). No regression.

**CE-2 / CE-17 clause 2 · Escalation reserved for genuine operator-owned decisions — baseline green, still
green.** The seed carries both a resolvable repository question (which surface parses the timestamp) and a
genuine intent question (whether guests are contacted now or later). In both runs only the genuine decision
returns, and the repository question is carried as a discovery target.
*Red:* "Do not contact or queue contact with any guest; that remains an operator decision after the set is
known" (red:53–54). *Green:* "Guest contact is not authorised by this brief: once the affected set is known,
the operator decides whether contact belongs in the corrective unit or in later work" (green:7). No regression.

**CE-15 · One execution handoff artifact, two audiences — baseline green, still green.**
Artifact count is filesystem-derived, not self-reported: each run created exactly one file in its root
(541 = 541, with `diff -rq` showing no other file came into being). Each opens with an orientation
paragraph within the sentence ceiling and continues into execution context.
*Red:* orientation at red:28–32, two sentences. *Green:* orientation at green:17, two sentences, answering
only why this unit, why now, and alignment (SD-3, SD-4). Green's remainder carries §4.1's required
contents — required outcome, prepared context, governing sources, scope, exclusions, required evidence,
claims to check, completion condition, stop conditions, and explicit permission to challenge false
premises (green:58). No regression.

**CE-17 clause 1 · One preparation pass — baseline green, still green.**
Each run terminated in exactly one execution or discovery brief with no iterative context interview, no
separate QC pass, and no preparation loop. No question was returned to the operator mid-pass in either.
No regression.

## 4. The four counts, re-derived

Measured against the green run.

| # | Count | Target | Result | How derived |
|---|---|---|---|---|
| 1 | Preparation passes | 1 | **1** | One fresh Codex task; one produced state file; no interview or second pass in the transcript of artifacts |
| 2 | Operator context actions beyond stating the objective, excluding genuine decisions | 0 | **0** | The operator pasted the prompt once. Nothing further was asked of them; the only operator-facing item is the guest-contact decision, which is a genuine decision and excluded by the count's definition |
| 3 | Artifacts describing the unit | 1 | **1** | Filesystem: root file count unchanged at 541, `diff -rq` against red shows only the candidate and the one output differ — no second artifact was created anywhere in the root |
| 4 | Orientation sentences | ≤3 | **2** | green:17 |

All four targets met.

## 5. Exit condition

Plan §7 S3 requires: all five behaviours pass against the revised candidate on the same seeded input;
CE-3 demonstrated red-then-green with both primary outputs inspectable; the four baseline-green behaviours
still green with no regression; all four counts at target.

**All four conditions are satisfied.** CE-3 is green with a recorded CE-3 red, so the slice does not fail
on the "green with no recorded red" condition.

## 6. What this does not prove

- **Only the isolated proof was obtained.** CE-17 clauses 1–2 were tested; **clause 3 — delivery without
  ferrying — was not**, and is owed at S11. Presenting this as the one-touch handoff would be the
  substitution the specification names explicitly.
- **Four of the five behaviours are not caused by the revision.** They were green against the
  behaviourally-adjacent pre-revision candidate. The revision's demonstrated causal effect is CE-3 alone;
  its effect on the other four is preservation, not causation.
- **The absence findings inside both briefs are the runs' own claims, not this record's.** Both correctly
  bounded them — green states its search "is an absence claim over that searched worktree surface, not a
  claim that the missing surfaces do not exist elsewhere" (green:36).

## 7. Owed

The fresh Codex task reference for the green run was not supplied at hand-back. The primary outputs and
their hashes are embedded above and both roots are preserved, so the evidence stands on the artifacts; the
task reference should still be recorded when available.
