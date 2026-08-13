# S3b — shadow slice observation record

**What this is.** The separate observation record for Context Engineering S3b. It records how the S3
candidate's brief performed on one genuine Standard-lane unit of real repository work, carried out in a
different project. It records the observation only. It changed nothing about that unit, and that unit is
closed.

**Date:** 2026-08-03. **Lane:** Standard. **Task:** `context-engineering-implementation`, unit S3b.

---

## 1. What this proves, and what it does not

**This is the isolated shadow proof. It is not the integrated proof.**

The genuine unit ran in its own repository against a brief the S3 candidate produced. What the record below
supports is a usability observation: on this one unit, the brief was sufficient for real work to begin and
finish correctly. That is the whole claim.

It does **not** prove CE-17 clause 3. It does **not** prove integrated delivery. Nothing here was carried
through the real Codex-to-Claude path without an operator in the middle — see § 6, which is the reason this
proof is called isolated. A later integrated proof is a separate unit with separate evidence, and this
record must not be cited as a substitute for it.

## 2. The genuine unit

| | |
|---|---|
| Task id | `crm-derived-answer-authority` |
| Task path | `projects/axcion-systems-builder/logs/work-loop/crm-derived-answer-authority.md` |
| Repository | `axcion-systems-builder` (its own git repository, separate from `ai-resources`) |
| Lane and unit | Standard, unit 1 |

**Objective, as approved in that unit's own state file:** make derived answers from the synthetic CRM
sandbox reliable when narrative prose conflicts with structured interaction rows, and reconcile the known
Contact D1 contradiction so the erroneous "four silent approaches" answer cannot recur. Approved scope was
the CRM sandbox interface contract plus the synthetic D1 narrative surfaces that had to change; the only
non-sandbox artifact was that task's own state file.

**Its two commits, in `axcion-systems-builder`:**

| Commit | Purpose |
|---|---|
| `385594769bc138e10e317a6c4ba9f5393a957a09` (`3855947`) | Implementation — `OPERATING.md` §12 plus seven D1 prose corrections across four record surfaces, five sandbox files and the state file, 2026-08-03 09:55:07 +0300 |
| `a0ae38499215ea25ae01d3d5f02181c88a5d7599` (`a0ae384`) | Closing state — Codex closed the task without a correction round; the state file reduced to the four-field closing record, 2026-08-03 10:01:20 +0300 |

## 3. Claude's sufficiency verdict

Quoted verbatim. **Provenance: the operator's direct 2026-08-03 relay of the genuine `axcion-systems-builder`
session.** This is an attributed quotation of that session, not a repository-derived fact — the session was
not wrapped, so no repository surface in either project holds its own words.

> "Was the candidate-produced brief sufficient? Yes. I asked nothing back. No premise failed. I went from
> reading the brief to running the first inspection with no gap I had to guess across, and the unit finished
> in one pass with no correction round."

**Three of the quotation's five assertions are independently corroborated by the repository**, and one is
not corroborable in either direction. The split is stated here rather than smoothed over, because the
provenance of each part is what a later reader will need:

| Assertion | Standing |
|---|---|
| "I asked nothing back" | **Corroborated** — see § 4, ask-back count |
| "No premise failed" | **Corroborated** — the state file at `3855947` records all five of its claims as `HOLDS`, with `## Unresolved blocker` reading `None` |
| "finished in one pass with no correction round" | **Corroborated** — `a0ae384`'s message states it, and the state file's entire history is exactly two commits, implementation then closure, with no correction commit between them |
| "the brief was sufficient" | **Attributed only** — a judgment the running session alone could make |
| "no gap I had to guess across" | **Attributed only** — same class |

## 4. The two counts

**Questions Claude had to ask that the brief should have answered: 0.**

*Derivation — repository-derived.* Handing a question back under the executable core § 7 requires writing
the finding into the state file, setting `turn: codex`, and committing. In `axcion-systems-builder`,
`git log -- logs/work-loop/crm-derived-answer-authority.md` returns exactly two commits, `3855947` then
`a0ae384`: implementation, then closure. There is no hand-back commit between them and none before them.
The state file as at `3855947` carries `## Unresolved blocker: None`, and its `## Next action` asks Codex to
assess the finished unit — not to resolve a blocker. **This count can fail:** a single hand-back commit, or
any non-empty blocker at `3855947`, would refute it.

**Operator context-assembly actions, from stating the objective through Claude beginning correct work: 0**
(excluding the initial objective statement and the Claude trigger, both excluded by the metric's own
definition).

*Derivation — not repository-derived.* No repository surface records what the operator did between those
two points. The count is **attributed to Codex's live task exchange**, which shows the only operator actions
in that window were stating the objective and triggering Claude. It is reported here on that authority and
labelled as such. **This count cannot fail against the repository** — that limitation is stated rather than
hidden, and it is a genuine weakness of this record, not a formality.

## 5. Four negative usability findings — constraints for S4–S7

These are **constraints to carry into S4–S7**. They are not new behaviours, and they are not changes to the
candidate. Each is stated with the attempt that found it, so the finding can be checked rather than taken on
trust. All four were available; all four are listed.

**Finding 1 — an "exactly these surfaces" claim combined with an instruction to search for more must say
what happens when the search finds the same defect inside an already-allowed file.**

Same-defect findings inside the allowed set may be corrected; a new file, or a different defect, requires
hand-back.

*How it was found.* The brief asserted the affected surfaces were "exactly these" four files
(`3855947` state file, brief line 40) while simultaneously instructing a search of the whole sandbox for
additional contradictions (claim 3, line 46). The search duly found two more — `firms/firm-d.md:6` and
`:65` — inside the already-allowed file. The brief gave no rule for that case, so Claude had to decide alone
whether correcting them was in scope or a scope change requiring hand-back (its Claim (3) record, line 96),
and it referred the judgment to Codex in its `## Next action` (line 189). Codex ratified it afterwards in the
closing record (line 16). The decision was correct; the brief should not have required it.

**Finding 2 — where established section numbers carry external citations, the brief must state that
existing numbering has to stay stable, or must put citation repair inside scope.**

*How it was found.* The brief required a new authority rule in `OPERATING.md` but said nothing about
numbering. Claude found that the sandbox and the external `axcion-crm` stage documents both cite
`OPERATING.md` §3, §9 and §11, so inserting a section would have silently falsified citations in files the
unit was forbidden to edit. It appended §12 instead, with pointers from §1 and §8 (`3855947` state file,
line 100), and Codex recorded the reasoning in the closing record (line 14). The constraint was real and
discoverable, but the brief left it to be discovered.

**Finding 3 — a request for the "minimum structural distinction" needs a checkable floor as well as a
ceiling.**

*How it was found.* Required outcome 4 asked for "the minimum structural distinction needed" and forbade a
sandbox-wide commentary migration (`3855947` state file, line 31). That is a ceiling with no floor: it says
how much is too much and never how little is too little. Claude marked two commentary blocks, could not
tell from the brief whether two satisfied "minimum", and had to hand the question to Codex explicitly
(line 189). A floor — "at minimum, every block that carried the false claim" — would have made it checkable.

**Finding 4 — a negative scan's searched surface must match its pass condition.**

Historical rationale quoting a wrong phrase is not a stale record claim, and must not make an otherwise
correct record-surface scan impossible to pass.

*How it was found.* Evidence requirement 4 demanded a search of "all of `cases/crm/sandbox/`" for
`third and fourth`, `four silent` and `never replied`, passing "only if no stale D1 claim remains"
(`3855947` state file, line 81). But the fix itself quotes `four silent approaches` inside §12's own
rationale, in order to forbid it — so the scan as literally specified could never return empty once the unit
succeeded. Claude scoped the scan to record surfaces, then disclosed the single whole-tree hit rather than
excluding it silently (line 144), and Codex accepted the distinction in the closing record (line 19). The
pass condition and the searched surface had been written against each other.

## 6. Integration friction — disclosed separately

**This is not context assembly, and it is not counted in § 4's operator-action count of 0.** It is recorded
here on its own so that neither hides the other.

After work began, the Codex↔Claude turns were carried manually by the operator. The two models did not
exchange the state file through an integrated path; a person moved each turn between them. That is real
pre-integration friction, and it is the specific reason § 1 calls this an isolated proof rather than an
integrated one.

The distinction matters and is worth stating plainly: § 4's zero says the operator did not have to *assemble
context* for Claude — the brief carried what was needed. It does not say the operator did nothing. Reporting
the manual turn-carrying inside the context-assembly count would have understated the brief's performance;
omitting it entirely would have overstated the system's.

## 7. Evidence

**Separation of the real unit from this record — by repository and by purpose.**

| | Real unit | This shadow record |
|---|---|---|
| Repository | `axcion-systems-builder` | `ai-resources` |
| Commits | `3855947` implementation, `a0ae384` closure | this record's commit, plus the earlier hand-back `358508d` |
| Purpose | Change the CRM sandbox's records and interface contract | Record an observation about the brief that produced that change |
| Contents | Five sandbox files and its own state file | This file and the canonical task-state file |

No file of the real unit was read into this one as content, no commit spans both repositories, and the real
unit's state was not revised. The two are separated by repository and by purpose, not merely by convention.

**The candidate is unchanged.**

```
$ shasum -a 256 plans/work-loop-v2-v0.2/context-engineering/trials/candidate/SKILL.md
5b3f591b9525bc2046494184e9968bf6f46735ad78f0c01c2c78cb4cb6896679
```

Identical to the hash recorded in the brief. The candidate was read from during this unit and written to at
no point.

**Only this record and the canonical state changed here.** This unit's commit in `ai-resources` contains
exactly two paths: `plans/work-loop-v2-v0.2/context-engineering/trials/shadow-slice-record.md` and
`logs/work-loop/context-engineering-implementation.md`. The specification, the implementation plan, the S3
evidence, the candidate, the executable core, runtime files, fixtures and trial roots are untouched, and S4
is not opened.

## 8. Limitations

- The sufficiency verdict and the "no gap I had to guess across" judgment are an **attributed relay**, not a
  repository fact. The genuine session was never wrapped, so its own account exists nowhere in either
  repository. A wrapped session would have been the stronger source, and this record is weaker for its
  absence.
- The operator-context-assembly count of 0 rests on Codex's observation of its own task exchange. It cannot
  be checked against any repository surface, and no check in this record can refute it.
- **One unit is one unit.** This record supports a usability observation about a single Standard-lane task in
  a single project. It is not a sample, and it does not establish that the candidate's briefs are generally
  sufficient.
- The four findings in § 5 are constraints for S4–S7. Whether they are correctly scoped as constraints
  rather than candidate defects is Codex's assessment to make, not this record's to assert.
