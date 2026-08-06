---
task: project-progression-candidate-review-correction
turn: codex
---

## Objective and scope
Resolve exactly the two material findings from the independent Codex review so the corrected Work
Loop v2 project-progression candidate can receive its bounded closure check. The operator's current
decision — "authorized" — authorises this correction round only; it does not approve or adopt the
candidate.

Scope: `.agents/skills/work-loop-v2/SKILL.md`, the `cont`/`rout` evidence in
`logs/scripts/work-loop-v2-slice-1.test.sh`, `logs/work-loop/fixture-continue.md`, any additional
Continue fixture files strictly required to test the four frozen negative cases,
`plans/work-loop-v2-mvp/project-progression-candidate-review.md`, the factual status notes in
`logs/decisions.md` and `logs/missions/work-loop-v2-mvp.md`, and this state file.

Excluded by Codex's framing decision: the executable core, Claude command, original proposal,
installation work, the broader v0.2 rework, redesign of the unrelated `3.1a` closed-set checks,
live multi-unit operation, candidate approval or adoption, pushing, and unrelated cleanup. Reason:
none is required to resolve the two review findings, and the operator authorised only this bounded
round.

## Lane and unit
Standard. Unit 1 — one bounded correction round for the independent review's two frozen findings.
Named reason for the loop: this correction crosses the skill, fixtures, harness and authority/status
record, and its result must be assessed independently before it counts as resolved.

## Brief
The fresh-context review returned **Accept with corrections** after the recovery task closed. This
unit fixes only its two material findings, now, so the candidate can reach a clean artifact verdict
without crossing the still-open adoption gate.

Required outcome:

1. The Codex skill no longer copies the core-owned Continue state-transition mechanics. It points
   to core § 3 for those mechanics and retains only the skill-owned Codex judgment: justify the next
   unit against the objective, route the next owner first, and forbid using Continue to dodge closure
   or smuggle a correction. The harness must contain a negative assertion capable of detecting a
   future copy of those mechanics in the skill.
2. The constructed Continue evidence discriminates the valid shape from four non-Continue shapes:
   an ordinary Unit 1 opening, the exact close-token hand-off, the exact correction-token hand-off,
   and a malformed state file. It must establish that only the valid Continue satisfies all of the
   protocol's preconditions; a collection of affirmative greps over core prose is insufficient.

Governing sources and dispositions:

- Current operator decision, "authorized": governing permission for this one correction round; not
  permission to approve, adopt, install or expand the candidate.
- The independent fresh-context review returned in the current Codex session: governing assessment
  for this correction. Its two findings are frozen verbatim in `## Next action`; its other dimensions
  passed and are not reopened here.
- `logs/decisions.md` § `Work Loop v2 project-progression proposal`: governing accepted direction and
  four operator corrections. Preserve its original decision and authority history; update only its
  now-stale factual status note.
- `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`: governing mechanics and vocabulary;
  control artifact, excluded from edits.
- `plans/work-loop-v2-mvp/project-progression-candidate-review.md`: authoritative candidate pointer
  and review record. Record the independent verdict, its two findings, the operator's bounded
  correction authorisation, new evidence and current candidate pins without implying adoption.
- `logs/missions/work-loop-v2-mvp.md`: authoritative mission status; update only the stale statement
  that review is pending and the current bounded-correction status.
- `logs/work-loop/project-progression-candidate-recovery.md`: closed evidence for the prior four
  corrections; historical input, not reopened.
- `plans/work-loop-v2-v0.2/project-progression-protocol-original-proposal.md`: non-governing preserved
  background; excluded.

Check against the repository before changing anything:

1. Verify-first claim: `.agents/skills/work-loop-v2/SKILL.md`'s `**Continuing.**` paragraph currently
   repeats `record the accepted result`, `write the next unit's brief`, and `set turn: claude` from
   core § 3. Settle by opening both named paragraphs and comparing their operative instructions.
2. Verify-first claim: the harness's current `cont` block uses one positive fixture and no constructed
   negative fixtures for Unit 1, close, correction or malformed classification. Settle by opening
   `logs/work-loop/fixture-continue.md`, the full `cont` block, and searching `logs/work-loop/` only
   for Continue-classification fixtures and the two exact core-owned tokens.
3. Verify-first claim: `plans/work-loop-v2-mvp/project-progression-candidate-review.md` still says the
   independent review is pending and leaves § 5 empty. Settle by opening its status line and § 5.
4. Verify-first claim: the factual status notes in `logs/decisions.md` and
   `logs/missions/work-loop-v2-mvp.md` still say independent review is pending. Settle by opening the
   exact project-progression entries.
5. Verify-first claim: before this correction, the full harness reports 167 passed, 2 failed, exit 1,
   and the candidate-specific `cont`/`rout` block is 20/20. Settle by running
   `bash logs/scripts/work-loop-v2-slice-1.test.sh` and reporting both levels separately.
6. Verify-first claim: the executable core and Claude command need no change to resolve either
   finding. Settle after claims 1–2 by identifying which owning artifact is deficient; stop if either
   excluded control would have to change.

Required evidence:

- An inspection line for each claim above, including claims that hold.
- RED-before/GREEN-after evidence for every new assertion: against the current deficient candidate,
  the new ownership-duplication guard and negative classification cases must expose the two findings;
  after correction, the valid Continue case alone must classify as Continue and all four negative
  cases must not.
- Evidence that the classification checks read state structure and protocol tokens/preconditions,
  not merely the presence of explanatory sentences in the core or brief.
- A post-change full-harness run with totals and exit code reported honestly, plus the complete
  `cont`/`rout` result separately. Do not call the full suite green while unrelated failures remain.
- A focused read showing that the skill defers mechanics to core § 3, the negative assertion catches
  mechanics duplication, each negative case fails Continue for its distinct reason, and the candidate
  record/status notes remain explicit that approval and adoption have not occurred.
- Evidence that the executable core and Claude command are unchanged controls.
- One commit containing only this task's in-scope files and this state file.

Completion condition: implement only the two frozen corrections, update the candidate and current
status records truthfully, write the evidence here, set `turn: codex`, commit, and stop. Do not conduct
the closure check, approve or adopt the candidate. Codex will assess only whether findings 1 and 2
are resolved and whether the correction broke something.

Stop if a verify-first claim is false in a way that changes the frozen scope, if either excluded
control must change, if meaningful classification evidence cannot be produced without live operation,
or if any required change would imply candidate approval/adoption. Hand the evidence back rather than
improvising.

## Latest result
Inspected (2026-08-06) — both frozen findings reproduced before anything was changed:

- **Finding 1: REPRODUCES.** Opened both paragraphs. Skill line 119 read "record the accepted
  result, write the next unit's brief, and set `turn: claude` — the mechanics are core § 3's",
  against core lines 108–110 "Codex records the accepted result as the last material result …
  writes the next unit's brief (step 3) … and sets `turn: claude`". The same operative triple in
  both. Worth naming precisely: the skill *pointed at* core § 3 **and** restated it, which is the
  worst of the two shapes — a reader has no signal that one of the two copies is authoritative.
- **Finding 2: REPRODUCES.** `ls logs/work-loop/ | grep -i continue` returned exactly one file,
  `fixture-continue.md`. Searched `logs/work-loop/` for the two exact core-owned tokens: the only
  hit was this live task's own state file — zero constructed negative fixtures existed.
- **Claim (3): HOLDS** — candidate record line 3 said review PENDING and § 5 line 173 read
  "(pending — filled when the review runs)".
- **Claim (4): HOLDS** — `logs/decisions.md` carried "pending independent Codex review";
  `logs/missions/work-loop-v2-mvp.md` carried "independent Codex review is still pending".
- **Claim (5): HOLDS** — pre-correction run: `passed: 167   failed: 2`, exit 1; `cont`/`rout` 20/20.
- **Claim (6): HOLDS** — finding 1 is a defect in the skill's paragraph and finding 2 in the
  fixtures and harness. Neither excluded control had to change, and neither did: verified by
  execution, `git status --porcelain` is empty for both
  `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` and
  `.claude/commands/work-loop-v2.md`, and their blobs are unchanged (`8f30da6c`, `125de530`).

Result: both frozen findings corrected, and nothing else implemented.

1. **Finding 1.** The `**Continuing.**` paragraph now defers every mechanic to core § 3 by
   reference and carries only the skill-owned judgment: justify the next unit against the objective,
   route the next move by owner first, and treat Continue as an acceptance — so it neither dodges
   closure nor disguises a correction. A negative assertion guards the paragraph against a future
   re-copy.
2. **Finding 2.** A `classify_state()` discriminator was added to the harness, plus four
   constructed negative fixtures. It reads the state file's own structure — frontmatter validity,
   core § 4's exact active headings, the two core-owned protocol tokens, and the Continue
   precondition — and reads no core or skill prose at all.

Evidence: `bash logs/scripts/work-loop-v2-slice-1.test.sh` from the repo root.

- **RED before.** With all seven new assertions present against the uncorrected candidate:
  `passed: 168   failed: 8`, exit 1. Six of the seven were red — the four negative-classification
  cases, the discrimination check, and the mechanics-duplication guard. **The seventh was green on
  arrival and is reported as such rather than dressed up:** `cont  the valid Continue fixture
  classifies as CONTINUE` passed immediately, because the positive fixture was never the
  deficiency — the missing negatives were.
- **GREEN after.** `passed: 174   failed: 2`, exit 1. `cont`/`rout` is 27/27.
- **The full suite still does not pass, and this round does not claim it does.** The two failures
  are the pre-existing `3.1a` closed-set reds, untouched here and explicitly excluded from this
  round's scope. The four new fixtures **were** registered in `KNOWN_WORKLOOP_FILES`, which is that
  assertion's documented friction, not a widening to hide a red — the reds persist for the real task
  files that caused them.
- **The duplication guard can fail.** Extracted the pre-correction paragraph from
  `git show HEAD:.agents/skills/work-loop-v2/SKILL.md` and ran the guard's exact pattern against it:
  it matches, so the guard would have been red against the text it was written to catch.
- **The classification reads structure, not prose.** A probe applied the pre-correction `cont`
  block's fixture predicates to each new fixture and compared against `classify_state()`. Four
  negatives resolve to four distinct verdicts (OPENING / CLOSE / CORRECT / MALFORMED) versus
  CONTINUE for the valid case. `classify_state()` touches neither the core nor the skill, so no
  amount of documentation can turn a red green.

**A finding only partly as stated, reported rather than smoothed over.** Finding 2's stated
consequence was that the `cont` block "can stay green for a state the protocol defines as
non-Continue". The probe does not bear that out: applied as predicates, the old checks *reject* all
four negatives. The real defect is different and, I think, worse — the old block never classified
anything. Its predicates were bound to one file and tested that file's incidental strings, notably
the literal `Unit 2`. The probe shows the cost directly: a **valid** Continue at Unit 3, whose
result said "taken as good enough to move on" rather than "accepted", is rejected by the old
predicates. The block could not have accepted a non-Continue because it was never pointed at one; it
would instead have rejected valid Continues. Finding 2 is resolved either way — discrimination now
exists — but the consequence line in the frozen finding does not match what the repository shows.

**That probe also caught a defect in my own correction.** The first `classify_state()` keyed the
precondition on the literal word "accepted" and misclassified that same Unit-3 case as OPENING —
reproducing the fixture-literal failure I was correcting. Fixed before the green run: the
precondition now accepts either an explicit acceptance or a unit ordinal of 2+, both gated on a
non-placeholder result, and falls to OPENING when neither is present (conservative in the safe
direction). The probe is scratchpad-only; no fifth positive fixture was added, because the frozen
scope allows only fixtures required for the **four negative** cases.

Records updated truthfully, without implying adoption: the candidate record's status line, § 1 pins
(skill `8a88139c`, harness `3a79718d`, four new fixtures) and § 5 verdict; and the status notes in
`logs/decisions.md` and `logs/missions/work-loop-v2-mvp.md`. All three now say the review has run and
returned Accept with corrections, that one bounded round was authorised and applied, and that the
candidate remains **not approved and not adopted**.

Deferral — newly noticed, not implemented: the skill's **correction** paragraph ("A correction is
written into the state file…") also restates core-owned mechanics, including `set turn: claude`. My
first duplication guard was section-wide and caught it; I narrowed the guard to the `**Continuing.**`
paragraph rather than widen this round past its frozen scope. It is the same class as finding 1 and
is a candidate for a later unit.

## Blocker
None.

## Next action
Codex: run the closure check on the two frozen findings only — are findings 1 and 2 resolved, and
did the correction break anything? Two things need your judgment inside that check. First, finding
2's stated consequence did not reproduce (see the paragraph above); the finding is resolved on its
substance, but decide whether the discrepancy changes your verdict. Second, the correction-paragraph
duplication is recorded as a deferral rather than fixed, because fixing it would have widened the
frozen scope — confirm that was the right call or record it as an accepted limitation. Anything else
newly noticed is a deferral, not a second round.
