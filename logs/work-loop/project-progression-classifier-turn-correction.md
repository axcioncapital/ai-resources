---
task: project-progression-classifier-turn-correction
turn: codex
---

## Objective and scope
Correct one material evidence defect in the Work Loop v2 project-progression candidate: a
Continue-shaped active state must not classify as `CONTINUE` unless its frontmatter says
`turn: claude`. Keep the correction inside the deterministic harness and bring the current
candidate-review record up to date; do not change runtime behaviour or adopt the candidate.

Scope: `logs/scripts/work-loop-v2-slice-1.test.sh`,
`plans/work-loop-v2-mvp/project-progression-candidate-review.md`, and this task-state file.
Excluded by Codex framing: the skill, executable core, Claude command, existing fixture meaning,
live-seam contract, the two known `3.1a` failures, installation/propagation, adoption, and every
unrelated working-tree change. No protocol token, lifecycle state, artifact kind, review layer or
runtime policy may be added.

## Lane and unit
Standard. Unit 1 — make the Continue classifier turn-sensitive and update the candidate record.
Named reason for the loop: the candidate's evidence must be assessed by the actor that did not
build the correction before it can support an adoption decision.

## Brief
This unit removes the one material evidence gap deferred by the completed live Continue proof. It
is needed now because the candidate is otherwise ready to return to the operator, and it follows
the approved direction by tightening only the existing harness rather than adding machinery.

Required outcome: `classify_state()` still recognises the valid `turn: claude` Continue fixture,
but an otherwise equivalent state at `turn: codex` or `turn: operator` cannot return `CONTINUE`.
The current candidate-review record must truthfully describe the completed live seam, this bounded
correction, the actual full-suite result, and the remaining authority boundary: reviewed evidence
is not adoption.

Governing sources:
- The operator's 2026-08-06 decision in this session authorises this one separate bounded
  correction and the necessary no-self-hosting exception. It does not authorise adoption,
  installation, propagation or adjacent fixes.
- `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` governs roles, Continue semantics,
  the one state interface, and evidence quality.
- `.agents/skills/work-loop-v2/SKILL.md` governs this brief, assessment and closure.
- `logs/work-loop/project-progression-live-continue-proof.md` is authoritative current evidence:
  the cross-actor seam passed and the wrong-turn classifier gap was explicitly deferred.
- `logs/decisions.md` section "Work Loop v2 project-progression proposal" remains the approved
  design direction. Candidate `6ba4c3f` is an authorised implementation baseline, not adopted
  behaviour.

Check against the repository before changing anything:
1. Verify in `logs/scripts/work-loop-v2-slice-1.test.sh` that the current classifier accepts a
   legal turn generally but does not require `turn: claude` before returning `CONTINUE`. Settle the
   claim by exercising the classifier against otherwise valid Continue-shaped states at all three
   legal turn values, not by prose inspection alone.
2. Verify that the live `seam` block separately requires `turn: claude`, so this defect did not
   invalidate the completed live proof. Settle the claim from the actual seam predicates.
3. Verify the candidate-review record's statements and evidence totals against the current files
   and a full harness run; do not carry stale status wording or stale totals forward.
4. Verify the working tree and preserve all changes outside the three scoped files. Do not fold
   `logs/friction-log.md` or the older candidate-correction task into this unit.

Required evidence:
- Add the minimum falsifiable coverage needed to distinguish the valid Claude-turn Continue from
  otherwise equivalent Codex-turn and operator-turn states. Avoid a new persistent fixture unless
  it is strictly necessary; the choice of mechanism is Claude's.
- Show the new wrong-turn assertion or assertions RED against the pre-fix classifier, then GREEN
  after the correction.
- Run the full harness after the correction and report exact pass/fail totals and exit status.
  Report the `cont`/`rout` and `seam` blocks separately. The two disclosed `3.1a` failures may remain;
  do not relabel the full suite green and do not fix or suppress them.
- Show that the valid Continue, opening, close, correction, malformed and unaccepted-later-unit
  classifications did not regress.
- Report the exact files changed and the commit.

Completion condition: both wrong-turn cases are unable to classify as `CONTINUE`, the existing
candidate-specific and live-seam evidence remains green, the candidate-review record is current
and authority-honest, and no excluded surface changed. Write the result and evidence here, set
`turn: codex`, commit the scoped work, and stop for assessment.

Stop and hand back without improvising if the turn-sensitive correction requires a runtime/core/
skill change, if either wrong-turn case cannot be made falsifiably red first, if the live seam
regresses, if any failure outside the two known `3.1a` failures remains, or if a governing source
contradicts this brief. Challenge a false premise or stale direction rather than widening scope.

## Latest result
Inspected (2026-08-06) — all four claims checked against the live repository before anything changed:

- **Claim (1): HOLDS** — settled by exercising the classifier, not by reading it. A read-only probe
  extracted `classify_state()` from `logs/scripts/work-loop-v2-slice-1.test.sh` and ran it against
  three states derived from `logs/work-loop/fixture-continue.md` with only the frontmatter turn
  rewritten. Result: `claude → CONTINUE`, `codex → CONTINUE`, `operator → CONTINUE`. The classifier
  required a *legal* turn (line 740 matches `claude|codex|operator`) and nothing more — it never read
  which one.
- **Claim (2): HOLDS** — read the actual seam predicates. `seam_continue_commit()` carries
  `seam_turn_is "$c" claude` as a required conjunct (harness line 885), and `seam_turn_is()` matches
  `^turn:[[:space:]]*claude[[:space:]]*$` against the blob at that commit. The seam therefore never
  depended on the classifier's turn-blindness, and the defect did not invalidate the completed live
  proof.
- **Claim (3): HOLDS — the record was stale in four specific places**, found by comparing it against
  the current files and a full harness run (`passed: 180   failed: 2`, exit 1, before any change):
  the status header still said the closure check was Codex's next move, though that check is done and
  the live-proof task has since closed; § 1's harness blob was `7974b597` against a live
  `git hash-object` of `9dd86e2c`; § 2b stated the change-specific result as `20/20` in the present
  tense against a live 28/28; and nothing in the record described the live seam at all.
- **Claim (4): HOLDS** — `git status --porcelain` showed exactly two pre-existing modifications
  outside this unit, `logs/friction-log.md` and
  `logs/work-loop/project-progression-candidate-review-correction.md`, plus this task's own untracked
  state file. Both were left untouched and unstaged; the commit was made by explicit pathspec over the
  three scoped files only.

Result: `classify_state()` is now turn-sensitive. A Continue-shaped state at `turn: codex` or
`turn: operator` can no longer classify as `CONTINUE`, and the candidate record describes the live
seam, this correction, and the real suite totals.

1. **The fix** is one predicate in the tokenless branch: `turn: claude` is required before `CONTINUE`,
   because core § 3's Continue *is* the move that passes the next unit to Claude. A wrong turn falls
   through to `OPENING` — the verdict the classifier already uses when a tokenless state fails the
   precondition. **No new verdict, protocol token, lifecycle state, artifact kind or review layer was
   added**, and no runtime file was touched.
2. **The coverage is derived, not stored.** The wrong-turn states are produced inside the harness from
   the valid fixture by rewriting only the frontmatter turn. Two reasons, both stated in the code: the
   only difference from a real Continue is then the thing under test, and a derived state cannot drift
   away from the fixture it comes from. No new persistent fixture, so the `3.1a` closed set was not
   widened.
3. **Three assertions, and the third is a control that earns its place.** Without
   `the derived state at turn: claude is still the valid Continue`, the two wrong-turn checks could
   have passed because the derivation corrupted the file rather than because the turn was rejected.

Evidence: `bash logs/scripts/work-loop-v2-slice-1.test.sh` from the repo root.

- **RED first, with the assertions added and the classifier not yet fixed:** `passed: 181   failed: 4`,
  exit 1. `cont  a Continue-shaped state at turn: codex is not a Continue` and the `turn: operator`
  twin both FAILED. Stated plainly: the control assertion passed in this run too — it is a control, not
  a flip, and claiming three reds would be false.
- **After the one-predicate fix:** `passed: 183   failed: 2`, exit 1. Both wrong-turn assertions green.
- **Blocks reported separately.** `cont`/`rout`: **31 pass / 0 fail** (28 before, plus these 3).
  `seam`: **5 pass / 0 fail** — the live cross-actor proof did not regress.
- **No classification regressed.** All six pre-existing verdict assertions are green — valid Continue →
  CONTINUE, first-unit opening → OPENING, close token → CLOSE, correction token → CORRECT, malformed →
  MALFORMED, later-unit-without-acceptance → OPENING — as is the assertion that the four negatives stay
  four *distinct* verdicts, which is what stops a blanket-reject classifier from satisfying the new
  checks.
- **The two `3.1a` closed-set failures remain, untouched and unsuppressed.** The full suite exits 1 and
  is **not** green; this unit does not relabel it.

Files changed, and only these three: `logs/scripts/work-loop-v2-slice-1.test.sh` (the predicate plus
the three assertions and their reasoning), `plans/work-loop-v2-mvp/project-progression-candidate-review.md`
(status header, harness blob hash, the `fixture-target-3.md` row, the stale `20/20` present tense, and
new § 5a for the live seam and § 5b for this correction), and this state file.

**Noticed and not implemented.** The candidate record now has three sequential correction narratives
(§ 2a, § 5, § 5a/§ 5b) and reads as an accumulating history rather than a current-state record. Not
touched here: restructuring it is well outside a bounded classifier correction, and the record is a
review artifact whose shape is Codex's and the operator's call. Recorded for placement, not fixed.

## Blocker
None.

## Next action
Codex: assess this bounded correction on its own terms — does requiring `turn: claude` before
`CONTINUE` match core § 3's Continue, is the derived-state mechanism honest coverage rather than a
convenience, and is the candidate record now current and authority-honest?

Two things for your judgment:

1. **Whether the correction closes the deferred gap** and this task closes, or whether the fall-through
   to `OPENING` for a wrong-turn state is the wrong verdict and something else is wanted. Note the
   constraint that shaped it: a distinct verdict would have been a new lifecycle state, which this
   task's scope forbids.
2. **Where the record's accumulating-history shape goes**, if anywhere — recorded above as noticed and
   deliberately not acted on.

Not done and not decided here: adoption, installation, propagation, the two `3.1a` reds, the older
candidate-correction task, and the unrelated working-tree changes. All untouched.
