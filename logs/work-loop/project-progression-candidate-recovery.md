---
task: project-progression-candidate-recovery
turn: codex
---

## Objective and scope
Bring the unapproved Work Loop v2 project-progression candidate to a review-ready,
evidence-honest state without treating it as approved. The operator's current decision
authorises this bounded recovery task; it does not approve or adopt candidate `6ba4c3f`.

Scope: the project-progression changes in the Codex skill, executable core, acceptance
harness, Continue fixture and candidate/review record; the existing decision and mission
records only where needed to keep the authority status accurate; this state file.
Excluded by Codex's framing decision: Claude's command, the preserved original proposal,
CRM or Systems Builder workflows, the broader v0.2 rework, installation work, candidate
acceptance, pushing, and unrelated cleanup. Reason: those are not needed to recover and
test this one candidate.

## Lane and unit
Standard. Unit 1 — correct the candidate's authority, vocabulary, Continue-seam and
evidence defects, then hand the result to Codex. Named reason for the loop: this is a
cross-artifact capability change whose scope must remain frozen and whose result needs
independent Codex assessment before it can count as review-ready.

## Brief
This unit restores the approval boundary that was crossed and corrects the material defects
found in the first Codex check. It advances the accepted project-progression direction under
the existing post-MVP v0.2 mission thread, while leaving adoption entirely undecided.

Required outcome:

- The candidate and its record state truthfully that implementation happened before scope
  approval, and that the operator has now authorised only this bounded recovery task—not
  candidate approval or adoption.
- The Codex skill uses the executable core's pinned vocabulary. It introduces no undefined
  `delivery unit` kind; change-producing work is described using the core's existing unit and
  execution-brief language.
- The core's no-token Continue mechanics cannot also classify an ordinary first-unit opening
  as Continue, and the fixture does not create an undocumented `Continue —` pseudo-token.
- The evidence record distinguishes the change-specific passing assertions from the full
  harness result and makes no claim that the full harness is green while its two known
  baseline assertions fail.
- The candidate remains explicitly pending independent Codex review.

Governing sources and dispositions:

- Current operator decisions: "I didn't approve the candidate yet" and "Let's do a work
  loop." These govern. They authorise recovery through this task, not approval of the
  candidate.
- `logs/decisions.md` § `Work Loop v2 project-progression proposal`: governing accepted
  direction and four corrections; its statement that implementation scope was not approved
  remains authoritative history.
- `logs/missions/work-loop-v2-mvp.md` project-progression thread: authoritative current
  mission placement and scope boundary.
- `docs/qc-independence.md`: governing review sizing; this remains one coherent normal-
  consequential candidate unless new repository evidence proves otherwise.
- `plans/work-loop-v2-mvp/project-progression-candidate-review.md`: current candidate record
  and evidence claim, not approval authority.
- `plans/work-loop-v2-v0.2/project-progression-protocol-original-proposal.md`: preserved
  non-governing background only.

Check against the repository before changing anything:

1. Verify-first claim: `logs/decisions.md` still says implementation scope was not approved.
   Settle by opening the project-progression decision entry and quoting its operative status.
2. Verify-first claim: `logs/missions/work-loop-v2-mvp.md` still gates implementation on
   operator scope approval. Settle by opening that mission thread.
3. Verify-first claim: `plans/work-loop-v2-mvp/project-progression-candidate-review.md` still
   identifies candidate `6ba4c3f`, says review is pending, and calls the deterministic result a
   `harness green run`. Settle by opening the candidate record and verifying all three points.
4. Verify-first claim: `.agents/skills/work-loop-v2/SKILL.md` uses `delivery unit`, while the
   executable core's § 5 vocabulary does not define that term. Settle by searching both named
   files for the exact phrase and vocabulary row.
5. Verify-first claim: the core says a tokenless `Next action` carrying a new brief is Continue,
   while `logs/work-loop/fixture-continue.md` begins its `Next action` with `Continue —`.
   Settle by opening both exact surfaces.
6. Verify-first claim: the full harness currently returns 164 passes and 2 known failures,
   while the new `cont` and `rout` assertions pass. Settle by running
   `bash logs/scripts/work-loop-v2-slice-1.test.sh` and recording its exit code and totals.

Required evidence:

- An inspection line for every claim above, including claims that hold.
- A post-change harness run reporting the full totals and exit code honestly, plus the
  change-specific `cont`/`rout` result separately.
- A focused read showing the skill uses only pinned vocabulary, the Continue paragraph no
  longer overlaps ordinary Unit 1 opening, the fixture has no pseudo-token, and the candidate
  record remains pending review with accurate evidence wording.
- A commit containing only this unit's in-scope files and this state file.

Completion condition: implement only this correction unit, write the result and evidence here,
set `turn: codex`, commit, and stop. Do not review or approve the candidate. The live multi-unit
Continue proof and final Codex candidate review are adjacent work deliberately held outside Unit 1;
Codex will decide the next justified unit after assessing this hand-back.

Stop if any verify-first claim is false in a way that changes the correction scope, if the work
would require an excluded file, or if preserving the unapproved status conflicts with another
current operator decision. Hand the evidence back rather than improvising.

## Latest result
Inspected (2026-08-06):
- Claim (1): HOLDS — searched `logs/decisions.md` for the project-progression entry; found it at
  line 393, headed "adopt with revisions, implementation scope not yet approved", with "Operator's
  final verdict … **Do not** approve implementation scope".
- Claim (2): HOLDS — searched `logs/missions/work-loop-v2-mvp.md` for the progression thread; found
  the post-MVP entry ending "Implementation gated on operator scope approval of the concrete
  proposal (session S3-92e)."
- Claim (3): HOLDS on all three points — opened
  `plans/work-loop-v2-mvp/project-progression-candidate-review.md`: `6ba4c3f` at lines 11 and 63,
  "review PENDING … not yet run" at line 3, "the harness green run" at line 57.
- Claim (4): HOLDS — searched `.agents/skills/work-loop-v2/SKILL.md` for `delivery unit`; found one
  occurrence, line 43. Searched the executable core for `delivery` (case-insensitive, whole file
  including the § 5 vocabulary table); no match — the term is undefined.
- Claim (5): HOLDS — opened both surfaces: core § 3 *Continuing* stated "There is no continue
  token. A `Next action` that opens with neither the close token nor the correction token, and
  carries a new brief, is a continue"; `logs/work-loop/fixture-continue.md` line 34 opened its
  `## Next action` with `Continue — unit 1 is accepted…`.
- Claim (6): HOLDS — ran `bash logs/scripts/work-loop-v2-slice-1.test.sh` before any change:
  `passed: 164   failed: 2`, exit 1; the two failures are `3.1a  no state file was opened for the
  direct request` and `3.1a  every task-state file present is one this build created deliberately`;
  every `cont` and `rout` assertion passed.

Result: All six claims held, so the correction unit ran. Four defects corrected, each in the
artifact that owned it, plus three harness assertions added so the corrections are enforced rather
than remembered.

1. **Vocabulary.** The skill's routing section no longer uses the undefined `delivery unit`. It now
   classifies in the core's own terms — an **execution brief** for a change, a **discovery unit**
   for evidence — citing core § 3 step 4. Zero occurrences of `delivery unit` remain in the skill.
2. **Continue precondition.** The core's tokenless rule previously matched every ordinary Unit 1
   opening (new brief, neither token). § 3 *Continuing* now states the precondition explicitly: a
   continue requires an accepted result from a previous unit of the same task; without it the same
   shape is an ordinary opening, and it says why writing `Continue` as a token is wrong twice over.
3. **Fixture pseudo-token.** `fixture-continue.md`'s `## Next action` no longer opens with
   `Continue —`. It now reads "Claude: check claim (1), then implement unit 2 on the brief above",
   so the fixture demonstrates a continue through its precondition — the corrected rule — rather
   than through a marker the protocol does not have.
4. **Evidence honesty and authority status.** The candidate record gained a § 0 stating plainly
   that implementation preceded scope approval and that the operator has authorised only this
   bounded recovery task — not approval, adoption or installation; a § 2a listing the four
   corrections; and a § 2b giving the real harness totals in a table. The phrase "harness green
   run" is gone (0 occurrences); § 3's sizing verdict now cites the 20/20 change-specific block and
   says outright that a green full suite does not exist. § 1 re-pins the candidate by current blob
   hash with the pre-recovery blobs alongside, and marks `6ba4c3f` as superseded. The mission
   thread and the `logs/decisions.md` entry each carry a status note recording that the approval
   gate was crossed and what the operator has since authorised; neither rewrites its original
   verdict.

Evidence: `bash logs/scripts/work-loop-v2-slice-1.test.sh` from the repo root.

- Before the corrections, with the three new assertions already present: `passed: 164   failed: 5`,
  exit 1. The three additions were red — `cont  the fixture invents no continue pseudo-token`,
  `cont  the core's tokenless rule excludes a task's first unit`, `rout  routing uses only the
  core's pinned unit vocabulary` — alongside the two `3.1a` baseline reds.
- After the corrections: `passed: 167   failed: 2`, exit 1. All three additions green; the
  `cont`/`rout` block is 20/20.
- **The full suite does not pass and this hand-back does not claim it does.** The two remaining
  failures are the pre-existing `3.1a` closed-set reds, caused by real task-state files created
  after `KNOWN_WORKLOOP_FILES` was last widened — including this task's own state file. They were
  deliberately **not** widened away: editing the closed set to turn a red green is the exact
  failure that assertion exists to catch. They are unrelated to this capability and are disclosed,
  not fixed.
- The three new assertions were shown failing before the artifacts were corrected, so they can read
  differently depending on whether the work happened (core § 6 rule 5).
- Focused reads confirming each correction: `delivery unit` count in the skill = 0; the
  precondition sentence present at core line 113; the fixture's `## Next action` carries no
  pseudo-token; the candidate record still states "not approved, not adopted" and "pending
  independent Codex review"; "harness green run" count = 0.

Deferrals — noticed during this unit, not implemented:
- **The `3.1a` closed-set assertion degrades as real tasks accumulate.** Every genuine task-state
  file makes it redder, so it now reports normal repository growth as a failure. It needs a real fix
  (distinguish fixtures from live task files, rather than widening a hand-maintained list), which is
  a change to the harness's design and outside this unit's scope.
- **`/work-loop-v2`'s direct-invocation shape skips session-marker allocation**, so the staging
  tripwire blocks the commit until a marker is allocated by hand. Already logged at `high` in
  `logs/improvement-log.md` (2026-08-06); recorded again here because it was hit during this unit.

## Blocker
None.

## Next action
Codex: assess the recovery unit. The candidate is review-ready and evidence-honest by this unit's
own account — judge whether that holds, then decide the next justified unit. The live multi-unit
Continue proof and the independent candidate review are the adjacent work this unit deliberately
held back. Two questions this unit could not settle for you: whether the § 0 authority statement is
sufficient for a reviewer arriving with no context, and whether the corrected core precondition
closes the first-unit ambiguity without opening a new one at the boundary between a continue and a
correction.
