---
task: context-engineering-plan-deviation
turn: codex
---

## Objective and approved scope

Amend the Context Engineering implementation plan so progression may continue beyond the closed,
unproved S8b only under the operator's explicit Route 3 deviation, without representing the missing
evidence as obtained or making adoption available.

Scope: the minimum material edit to
`plans/work-loop-v2-v0.2/context-engineering/context-engineering-implementation-plan-v0.1.md` and this
state file. Excluded: reopening or editing either S8b record; manufacturing or substituting S8b evidence;
changing runtime files or trials; starting S9, S10, Phase 4, or any adoption decision; and resolving
unrelated plan staleness or deferrals.

## Lane and unit

Standard. Unit 1 — draft and evidence the material plan amendment.

Named reason for the loop: the scope and authority boundary must be bounded before progression, and the
material amendment needs assessment by someone other than its author before it can be approved.

## Brief

Route 3 is the operator-authorized response to the current progression block: permit continued learning
and hardening while S8b remains closed and unproved. This unit changes the plan before any downstream
session starts, and it preserves the plan's evidence honesty and content-bound approval rules. The result
must be a draft amendment for Codex assessment and later explicit operator approval, not an implied
approval from the route choice alone.

**Required outcome.** Make the smallest coherent amendment that permits progression to S9 and, after the
plan's ordinary session-by-session decisions, later non-adoption phases despite the missing S8b proof.
Keep the following invariant explicit throughout: S8b remains closed; its causal post half, passing Direct
Work check, and post-integration false-premise refusal remain unmet; the missing evidence is not a
limitation that can support adoption; and Phase 6 adoption condition 4 remains unmet unless a separate,
explicitly authorized proof task later establishes it.

**Authority and source dispositions.**

- Governing operator decision: on 2026-08-04 the operator selected Route 3, explicitly authorizing a
  material deviation so work may continue while S8b stays skipped. This authorizes preparation of the
  amendment; it does not pre-approve wording that did not yet exist and does not authorize adoption.
- Governing plan until amended:
  `plans/work-loop-v2-v0.2/context-engineering/context-engineering-implementation-plan-v0.1.md`, approved
  against `e1ce895b3da1387bae7ce50623afc3875cb050ba`. Its S8b exit, S9 precondition, Phase 3 exit, later
  phase progression, and Phase 6 adoption conditions must be reconciled as one material claim cluster.
  Because the edit changes sequence and exit conditions, the edited plan returns to draft and requires
  explicit content-bound operator reapproval after Codex assessment.
- Authoritative current state:
  `logs/work-loop/context-engineering-s8b-seam-proof.md` says S8b is closed unproved and may be proved only
  in a new explicitly authorized task;
  `logs/work-loop/context-engineering-s8a-entrypoint-classification.md` records reading A and the accepted
  classification with its observation gap; and
  `logs/work-loop/context-engineering-implementation.md` says the implementation is live but not adopted.
  These records constrain the amendment and are not edited by this unit.
- Governing workflow: `.agents/skills/work-loop-v2/SKILL.md` and
  `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`. Claude implements and commits; Codex later
  assesses; the operator alone approves the amended plan.

**Codex framing decisions.** Limit this amendment to progression under explicit evidence debt and preserve
the existing adoption bar. Reason: the operator selected continuation while skipping S8b, but did not
authorize calling the capability adopted without S8b proof. Permit later phases only as evidence-gathering,
review, correction, integration, or hardening work whose results remain non-adoption evidence while
condition 4 is unmet. Do not turn the exception into a general waiver mechanism or a reusable process.

**Verification claims Claude must check before editing.**

1. The approved plan currently bars S9 until all three S8b fail-capable checks and their failing runs are
   recorded; check the S9 precondition and the S8b evidence/exit text.
2. Phase 3 exit currently requires the behavioural seam proof before Phase 4; check the complete Phase 3
   exit cluster and every later phase entry that depends on it.
3. Phase 6 currently makes behavioural seam proof a non-waivable adoption condition; check the adoption
   table and the text rejecting adoption-with-limitations.
4. The three closed records support the current-state statements above. If any claim is false, record the
   inspected surface and finding, set `turn: codex`, and stop without editing the plan.

**Evidence required.** Return a compact before/after disposition for every load-bearing plan passage
affected by the deviation: S8b exit, the S9 precondition, Phase 3 exit, any Phase 4/5 progression premise,
and Phase 6 adoption condition 4. The result must fail assessment if any passage still silently blocks the
authorized progression, if any passage implies the missing evidence exists, if the amendment makes
adoption available while condition 4 is unmet, or if the plan still presents the materially edited content
as approved. Show that the diff is limited to the plan and this state file and that no live runtime,
closed-record, or trial file changed in this unit.

**Completion condition.** The plan is internally coherent about the Route 3 exception, visibly draft
pending content-bound approval, preserves the closed S8b facts and adoption block, and is handed back to
Codex with fail-capable evidence for assessment.

**Stop conditions.** Stop and hand back if making progression coherent necessarily waives an adoption
condition, requires reopening S8b, or requires deciding a risk or scope question beyond the operator's
Route 3 choice. Challenge any false premise rather than improvising past it.

## Latest material result

Inspected (2026-08-04) — every claim checked against the plan as it stood at `4db05c1`, the commit this
unit started from. `P` below is
`plans/work-loop-v2-v0.2/context-engineering/context-engineering-implementation-plan-v0.1.md`.

- Claim (1): HOLDS — searched `P` for the S9 precondition and the S8b exit/evidence text; found the boxed
  note "S9 cannot start until S8b's three fail-capable checks have run and their failing runs are on
  record", and S8b's exit "all three behavioural checks passed with their failing runs recorded".
  S8b's evidence list numbers the three behavioural checks 1–3 (pre/post at the real entrypoint, Direct
  Work, false-premise refusal) and the structural checks 4th, so "three" is consistent across both
  passages.
- Claim (2): HOLDS — searched `P` for the complete Phase 3 exit cluster and every later phase entry;
  found three required exit conditions, of which 3 is "The seam is proved behaviourally … and the
  candidate review has run after that evidence exists". The dependent entries are S9's `Inputs`
  ("S8b's behavioural evidence"), S9 `Next:` → Phase 4, S10 `Next:` → Phase 4, S11's `Inputs` ("the
  accepted candidate"), and §7's rule that "a phase exits when its exit condition is demonstrated".
- Claim (3): HOLDS — searched `P` for the Phase 6 adoption table and the adoption-with-limitations text;
  found condition 4 "The seam is proved behaviourally, with failing runs on record | S8b", and the
  paragraph "'Adopt with stated limitations' is deliberately not an option for conditions 1–5", reinforced
  by §11's rule that a limitation "can never record an unmet adoption condition — the five in Phase 6's
  table".
- Claim (4): HOLDS — read all three closed records in full.
  `logs/work-loop/context-engineering-s8b-seam-proof.md` states S8b closed without the proof, lists the
  three unmet checks as accepted limitations, and says "S8b may be proved later only by a new explicitly
  authorised task; this closed task is not reopened".
  `logs/work-loop/context-engineering-s8a-entrypoint-classification.md` records O-3 reading A, the
  classification accepted after one bounded correction, and the unrun observer recipe as a written
  evidence gap. `logs/work-loop/context-engineering-implementation.md` states "Adoption is not claimed.
  The implementation is live; it does not satisfy the plan's adoption conditions."

Result: the plan carries the Route 3 deviation as one named exception. A new §7.2 states the operator's
2026-08-04 decision, names the three owed checks, bounds what the deviation permits (S9, then Phases 4–5
subject to the plan's ordinary decisions) and what it does not (no evidence claimed, no adoption, no
reopening of S8b, no reusable waiver), and says why the debt is deliberately not listed in §11. Six
load-bearing passages were qualified to point at it, and the header returns the document to draft.

| Passage | Before | After |
|---|---|---|
| Header / approval block | `Stage: plan of record`, approved against `e1ce895` | `RETURNED TO DRAFT — 2026-08-04`; `e1ce895` retained as prior approval and stated not to cover this content; the Route 3 edit described; reapproval owed after Codex assessment |
| §7.2 | did not exist | the deviation, its three owed checks, its limits, and how it stops being needed |
| S8b exit | exit condition only | exit condition unchanged, plus `Exit status, 2026-08-04 — not met`, progression past it permitted by §7.2 "and nothing else" |
| S9 `Inputs` | "S8b's behavioural evidence" listed as an input | that input marked as not existing; replaced by S8b's closing record and the retained pre-integration red run, with the reviewer told the seam is unproved |
| S9 precondition (boxed note) | "S9 cannot start until S8b's three fail-capable checks have run" | reasoning retained, deviated from once; S9's acceptance can say the candidate reads correctly, never that the seam works; its output is non-adoption evidence |
| Phase 3 exit | three conditions, all required | conditions unchanged; condition 3 marked not met, Phase 3 exited "for progression purposes only", conditions 1–2 unaffected |
| Phase 4 entry / Phase 5 entry | no entry qualification | each entered under §7.2; results are non-adoption evidence; Phase 5 adds that an out-of-sequence S8b proof is owed again if a later fix touches the seam (§5.2) |
| Phase 6 condition 4 | "S8b" | "S8b — **unmet as of 2026-08-04** (§7.2)", establishable only by a separate authorised proof task, "neither establishes it nor waives it"; plus a paragraph that the deviation does not convert condition 4 into a limitation |
| §11 limitations | rule naming entrypoint coverage and O-3 as unlistable | the same rule extended to the seam-proof debt, pointing at §7.2 — no row added |

Evidence: an 11-check script, run against the pre-edit plan (red), the amended plan (green), and two
deliberately weakened copies (each caught). C1–C7 assert the progression passages now cite the deviation
and that condition 4 is marked unmet; C8–C10 assert the adoption bar was **not** weakened — condition 4
still requires the seam proof, the adopt-with-limitations refusal is intact, and §11's table has no row
for the debt. Copy-pasteable, run from the repository root with the plan path as its argument:

```bash
F="$1"; pass=0; fail=0
sec() { awk "/$1/,/$2/" "$F"; }
chk() { if [ "$2" -eq "$3" ]; then echo "  PASS  $1"; pass=$((pass+1));
        else echo "  FAIL  $1"; fail=$((fail+1)); fi; }
grep -q 'RETURNED TO DRAFT' "$F"; chk "C1  header records the plan returned to draft" 0 $?
grep -q '^### 7.2 ' "$F"; chk "C2  a named Route 3 deviation section exists" 0 $?
sec '^\*\*Session S8b' '^\*\*Session S9' | grep -q '7\.2'; chk "C3  S8b exit cites the deviation" 0 $?
sec '^> \*\*The review follows the behavioural pass' '^\*\*Session S10' | grep -q '7\.2'; chk "C4  S9 precondition cites the deviation" 0 $?
sec '^\*\*Phase 3 exit' '^### Phase 4' | grep -q '7\.2'; chk "C5  Phase 3 exit condition 3 cites the deviation" 0 $?
sec '^### Phase 4' '^### Phase 5' | grep -q '7\.2'; chk "C6a Phase 4 entry cites the deviation" 0 $?
sec '^### Phase 5' '^### Phase 6' | grep -q '7\.2'; chk "C6b Phase 5 entry cites the deviation" 0 $?
grep '^| 4 |' "$F" | grep -qi 'unmet'; chk "C7  adoption condition 4 is marked unmet" 0 $?
grep '^| 4 |' "$F" | grep -q 'seam is proved behaviourally'; chk "C8  condition 4 still requires the seam proof" 0 $?
grep -q '"Adopt with stated limitations" is deliberately not an option' "$F"; chk "C9  the adopt-with-limitations bar is intact" 0 $?
sec '^## 11\.' '^## 12\.' | grep '^| ' | grep -qi 'seam'; chk "C10 no limitations-table row for the seam-proof debt" 1 $?
echo "  $pass passed / $fail failed"; [ "$fail" -eq 0 ]
```

Runs and results:

- **Red** — `git show 4db05c1:<P> > /tmp/pre.md; bash check.sh /tmp/pre.md` → **3 passed / 8 failed**
  (C1–C7 fail; C8–C10 pass). The checks could all have passed vacuously; they did not.
- **Green** — `bash check.sh <P>` on the amended plan → **11 passed / 0 failed**.
- **Mutation 1** — a limitations row "The behavioural seam proof was not obtained" inserted into §11's
  table → **C10 FAIL**, 10/1. The check catches the waiver-by-listing route.
- **Mutation 2** — the `**unmet as of 2026-08-04**` marker stripped from adoption condition 4 →
  **C7 FAIL**, 10/1. The check catches adoption being quietly made available.

Diff scope: `git status --porcelain` shows this state file and the plan, and nothing else that this unit
wrote. `git status --porcelain` restricted to the three live runtime files, the three closed records and
`plans/work-loop-v2-v0.2/context-engineering/trials/` returns **zero lines** — no runtime, closed-record
or trial file changed.

**Disclosed, because it is in the working tree and is not mine:** `logs/friction-log.md` is modified — 12
appended `Write Activity` timestamp lines written automatically by the repository's write-logging hook as
this unit edited the plan. It is machine-appended telemetry, not content this unit authored, and it is
**left unstaged and uncommitted**, outside the approved scope.

**Deferrals — noticed during this unit, deliberately not implemented** (core § 5):

1. Phase 1's U-1 text says the second half of U-1 "is answered by S8b's pre/post invocation at the live
   entrypoint". That run never happened, so that half of U-1 is in fact unanswered. Not edited: it is not
   one of the passages the brief named and it gates nothing downstream — §7.2's debt already covers the
   substance. Codex decides whether it needs its own line.
2. §12 "The exact next session" still names Phase 0 and S1 as what happens next, which the work has long
   passed. Left alone as unrelated plan staleness, which this task's scope excludes.

## Next action

Codex: assess the amendment. Is §7.2 the right shape and boundary for the Route 3 exception; are the
six qualified passages sufficient to unblock progression without any of them implying the missing evidence
exists; and does the plan now correctly present itself as draft pending the operator's content-bound
reapproval? Approval of the amended plan is the operator's, not this assessment's.
