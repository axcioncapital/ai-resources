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

The one bounded correction ran on Codex's two frozen findings. Both reproduced by inspection before
anything was changed. `P` is
`plans/work-loop-v2-v0.2/context-engineering/context-engineering-implementation-plan-v0.1.md`.

Inspected (2026-08-04):

- Finding (1): REPRODUCES — searched `P` for every O-1 and approval-status assertion (`grep -n
  "O-1\|outstanding\|awaiting operator approval\|Assessment status"`). Six live passages claimed the
  specification was unapproved: the status line "the specification's approval (O-1) is still
  outstanding"; the Authority notice's "still a draft specification awaiting operator approval … two
  approvals are therefore outstanding"; "**O-1 … is still unanswered**" and "S1 cannot open until O-1 is
  recorded"; the unscoped "**Assessment status: `unassessed`**" paragraph; §6's O-1 row, which cited the
  specification's header as reading *"draft specification — awaiting operator approval"*; and Phase 0,
  which left both approvals open. Against that, `plans/work-loop-v2-v0.2/context-engineering-spec-v0.1.md`
  reads at its own header: "**Stage:** approved specification — governing", "Approved by the operator on
  **2026-08-02** … binds to the identifiable content of this document at commit
  **`148689d`** (`148689d42ee7817239219417a1b884b961660f86`)", and explicitly "**Supersedes** the narrower
  approval of the same date … which approved the same content at the same commit *'for this
  implementation unit'* only." That superseded scope is precisely the evidence §6's row cited for O-1
  being undecided. `logs/work-loop/context-engineering-implementation.md` already carries "The plan
  header's stale O-1 wording" as deferral 2 and the `Assessment status: unassessed` wording as deferral 6.
- Finding (2): REPRODUCES — searched `P` §12 for its routing; found "**Phase 0 first, and it is two
  answers, not one.** Nothing below starts until both exist", followed by "Then **Session S1 — build the
  CE-9 measurement instrument.**" S1 ran long ago and §7.2 now permits progression to S9, so §12 routed
  the reader to a session two phases behind the plan's own position.

Result: both frozen findings are resolved, and §7.2 and the adoption bar are unchanged.

| Frozen finding | Before | After |
|---|---|---|
| (1) authority cluster | status line "the specification's approval (O-1) is still outstanding"; Authority notice calls the spec "still a draft specification awaiting operator approval", two approvals outstanding; "O-1 … is still unanswered"; "S1 cannot open until O-1 is recorded"; unscoped `Assessment status: unassessed` | status line: "exactly one authorisation is outstanding, and it is this document's own — the operator's content-bound reapproval of the 2026-08-04 amendment"; Authority notice names the spec **approved governing**, bound to `148689d`, "**O-1 is answered: yes**"; the 2026-08-02 paragraph rewritten as history with the change since; `Assessment status` scoped to the 2026-08-02 approval and stated **not** to describe the amendment, which goes to Codex *before* reapproval |
| (1) knock-on, disclosed below | §6's O-1 row cited the spec's header as "draft — awaiting operator approval"; §6 preamble "Identified, not resolved"; Phase 0 left both approvals open | §6 row "**ANSWERED 2026-08-02: yes**", consequence "**Phase 0, satisfied**"; preamble "not resolved **by this plan**", naming O-1 and O-3 as since answered; Phase 0 gains a status note — item 1 answered, item 2 open again because the amendment returned this plan to draft |
| (2) §12 | "Phase 0 first … Then **Session S1**", plus S1's input list | Phase 0's two answers with where each stands; then the three-step sequence — Codex assesses → the operator reapproves bound to a commit → **only then may S9 open**, under §7.2; plus what none of the three steps changes (S8b stays closed and unproved, condition 4 stays unmet, downstream output is non-adoption evidence); plus O-3 recorded as settled at reading A, and the live position located in the state files rather than in §12 |

Evidence: the amendment's 11 checks (C1–C10) were re-run unchanged and are joined by 9 checks for the two
findings (D1–D6c). C1–C10 are the no-weakening guard: if this correction had loosened §7.2, the deviation
citations, or the adoption bar, they would have gone red. Copy-pasteable, run from the repository root
with the plan path as its argument:

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
grep -q "specification's approval (O-1) is still outstanding" "$F"; chk "D1  status line no longer calls O-1 outstanding" 1 $?
grep -q 'draft specification awaiting operator approval' "$F"; chk "D2  no passage calls the spec a draft awaiting approval" 1 $?
grep -q '148689d' "$F"; chk "D3  the spec's governing approval commit is recorded" 0 $?
grep -qE '^> \*\*Assessment status: `unassessed`' "$F"; chk "D4  the unassessed note is no longer unscoped" 1 $?
sed 's/^> *//' "$F" | tr '\n' ' ' | grep -q 'O-1 — does the specification become governing — is still unanswered'; chk "D4b no passage says O-1 is unanswered" 1 $?
sec '^## 12\.' '^$XX' | grep -q 'Session S1 — build the CE-9 measurement instrument'; chk "D5  §12 no longer routes to S1 as the next session" 1 $?
sec '^## 12\.' '^$XX' | grep -qi 'only then may S9 open'; chk "D6a §12 states S9 opens only after reapproval" 0 $?
sec '^## 12\.' '^$XX' | grep -qi 'condition 4'; chk "D6b §12 preserves the unmet adoption condition" 0 $?
sec '^## 12\.' '^$XX' | grep -qi 'S8b stays closed'; chk "D6c §12 preserves S8b closed and unproved" 0 $?
echo "  $pass passed / $fail failed"; [ "$fail" -eq 0 ]
```

Runs and results:

- **Red** — against the plan at `0d1e77d`, the commit this correction started from: **11 passed / 9
  failed.** C1–C10 green (the amendment was intact), every D check red.
- **Green** — against the corrected plan: **20 passed / 0 failed.**
- **Mutation 1** — the Authority notice reverted to "draft specification awaiting operator approval" and
  "O-1 is answered: yes" removed → **D2 FAIL**, 19/1.
- **Mutation 2** — §12's "Only then may S9 open" changed to "S9 may open at any time" → **D6a FAIL**,
  19/1.
- **One check was rewritten before it was trusted.** D4b, which asserts no passage still says O-1 is
  unanswered, passed on the *uncorrected* plan — the sentence it looks for spans two lines and carries a
  `> ` blockquote prefix, so a plain single-line grep missed it. It was rebuilt to strip the prefix and
  join lines, re-run against the uncorrected plan, and only then relied on. A check that passes before the
  work happens is not evidence (core § 6 rule 5), and this one would have been.

**Scope, verified.** `git status --porcelain` restricted to the three live runtime files, the three closed
records, the specification, and
`plans/work-loop-v2-v0.2/context-engineering/trials/` returns **zero lines** — none changed. The
correction's diff is the plan (50 insertions / 32 deletions against `0d1e77d`) and this state file.

**Disclosed — the correction reached two passages the findings did not name.** Finding 1 required the
header to say the specification is governing. §6's O-1 row and Phase 0 both asserted the opposite, so
correcting only the header would have left the plan contradicting itself — a new contradiction created by
this correction, which the hand-back instruction requires me to prevent. Both were therefore corrected as
part of finding 1, minimally: the row's verdict and consequence, §6's one-line preamble, and a status note
under Phase 0. **Nothing else in §6 or Phase 0 was touched.** If Codex judges this outside the frozen
scope, it is a reversion of three edits, not a rebuild.

**Also disclosed:** `logs/friction-log.md` remains modified in the working tree by the repository's
automatic write-logging hook, as it was at the first hand-back. Machine-appended telemetry, not this
unit's content, and still left unstaged.

**Deferrals — newly noticed during the correction, not implemented** (core § 3, core § 5):

1. §6's **O-3 row** still reads as an open question in its own text. The fact that the operator settled it
   at reading A is now recorded in §6's preamble and in §12, but the row itself was left as written.
   Correcting it is a third edit to §6, beyond what avoiding self-contradiction required.
2. Phase 0's item 1 is still phrased as a future choice ("The operator answers O-1. If no, this plan stops
   here…"). The status note directly beneath now says it is answered, so the section is not contradictory
   — but the tense is stale.
3. Carried forward, unchanged from the first hand-back: Phase 1's U-1 text still says the second half of
   U-1 is answered by S8b's pre/post invocation, which never ran.

## Next action

Codex: run the closure check on the frozen findings only — are findings 1 and 2 resolved, and did the
correction break anything? The specific things worth checking are that no passage of the plan still
presents the specification as unapproved, that §12 now routes to Codex-assessment → operator reapproval →
S9 and nowhere else, and that C1–C10's green run means what it claims — that §7.2, the deviation
citations, and the unmet adoption condition 4 all survived the correction untouched. The three edits
outside the named passages (§6's row, §6's preamble, Phase 0's status note) are disclosed above and are
yours to accept or reject. Approval of the amended plan remains the operator's, and is a separate step.
