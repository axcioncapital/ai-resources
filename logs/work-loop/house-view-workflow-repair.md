---
task: house-view-workflow-repair
status: active
turn: codex
---

## Objective and scope

Implement the operator-approved House View workflow repair in
`plans/house-view-workflow-repair-plan-2026-08-20.md`: preserve the proven fail-closed authority
controls, repair the review path only where the historical feasibility test supports it, and run at
most one bounded successor pilot. The authorization follows the plan's recommended sequence: Moves
0–2 first; Moves 3–4 proceed only if Move 2 passes. Move 0 is complete through the closed
`canonical-rw-l4-integrated-pilot` task.

This task is bound to the current checkout. Excluded throughout: reviving the rejected
precision-components proposal, generic deployment or synchronization, a second consumer or pilot,
new review/governance machinery, push, merge, and deployment.

## Lane and unit

Standard. Implementation mode. Unit 1 — fix final-thesis evidence isolation.

Named reason for the loop: the approved repair has a hard feasibility decision after Moves 1–2,
will span several independently assessed units if it passes, and must stop rather than drift into
the additional machinery the operator rejected.

## Brief

The failed L4 task is closed, so the smallest useful repair step is Move 1's known validator defect.
This unit fixes only that executable defect and records the operator's approval of the exact repair
plan now being implemented; reviewer experiments and workflow changes remain later units.

Governing authority:

- Operator decision, 2026-08-20: `Let's begin implementation of the plan. Start work loop. Let's do
  it in this worktree, don't overcomplicate it.` This approves the recommended authorization in the
  current repair plan: Moves 0–2 first, with Moves 3–4 conditional on Move 2 passing.
- Approved semantic content: `plans/house-view-workflow-repair-plan-2026-08-20.md` at pre-approval
  SHA-256 `1b9700666c62a2cbfae3b5b3a4daa7669d503dcc617c8b3c7f9bd3b11bb22ad4`.
- Canonical Work Loop v2 governs execution and assessment. The closed L4 record is historical
  evidence and does not authorize reviving its rejected proposal.

Required outcome:

1. Record approval in the repair plan's header as administrative metadata, explicitly binding it to
   the SHA-256 above. Do not alter the approved semantic body.
2. Add one targeted five-thesis mutation case in the existing judgment-contract test file. Thesis 5
   must contain no claim ID while `## Provisional verdict` or later content does contain one; capture
   evidence that this case passes incorrectly before the production edit.
3. Make the smallest production correction so every thesis block ends at the next thesis or the next
   level-two section, preventing the final thesis from borrowing later citations.
4. Show the targeted mutation is refused after the correction and the existing judgment-contract
   regression suite remains green.

Check these claims against the repository before editing:

1. `plans/house-view-workflow-repair-plan-2026-08-20.md` still has the exact SHA-256 above and still
   says it is proposed and awaiting approval. If not, stop and hand back the mismatch.
2. In `workflows/research-workflow/logs/scripts/check-judgment-contract.sh`, the per-thesis AWK block
   currently closes only when another `### Thesis ` heading appears, so its final block can continue
   into `## Provisional verdict` and later sections.
3. In `workflows/research-workflow/logs/scripts/check-judgment-contract.test.sh`, V11 removes the
   citation from Thesis 2 and does not exercise an uncited final thesis followed by a cited verdict.
4. The focused existing regression owner is
   `workflows/research-workflow/logs/scripts/check-judgment-contract.test.sh`.

Scope: the repair-plan approval header, the contract validator, its focused test file, and this state
file. Do not change lifecycle, authority, approval, promotion, challenge, or downstream behavior.
Do not touch `audits/house-view-workflow-repair-decision-report-2026-08-20.md`,
`logs/innovation-registry.md`, the consumer checkout, or any other pre-existing working-tree change.

Dominant deliverable: correct final-thesis evidence isolation in the judgment-contract validator.
Evidence required in this hop: the targeted mutation's incorrect pre-fix result, its correct
post-fix refusal, the existing focused suite result, the bounded diff, and the commit hash.
Evidence explicitly deferred: the manual historical reviewer experiment and all Moves 3–4 work.
Primary edit begins after: the targeted five-thesis mutation demonstrably passes incorrectly against
the unmodified production validator.

Capability subset: baseline-only local work — read and inspect; edit only the scoped files; run the
focused local test; and make the local commit owned by Claude. Nothing from the empty
pre-authorizable set and no operator-reserved capability is selected. No network, push, merge,
deployment, credential access, destructive operation, or nested AI invocation is needed.

Completion condition: the plan approval is content-bound without semantic edits, the targeted case
proves RED before and GREEN after the smallest parser correction, the existing focused suite passes,
and the scoped result is committed with this state file handed back at `turn: codex`.

Stop and hand back without implementing if a checked premise is false, the approved plan's semantic
body has changed, the defect cannot be reproduced, the fix requires changing another contract, or
the required regression evidence cannot be produced. Challenge a false or stale premise; do not
improvise around it.

## Latest result

Inspected (2026-08-20):

- Claim (1): HOLDS — `shasum -a 256 plans/house-view-workflow-repair-plan-2026-08-20.md` returned
  `1b9700666c62a2cbfae3b5b3a4daa7669d503dcc617c8b3c7f9bd3b11bb22ad4`, matching the brief exactly;
  searched the same file for `Status:` and found line 3 reading
  `**Status:** Proposed — revised after realignment, awaiting operator approval`.
- Claim (2): HOLDS — read the `BARE_THESIS` AWK block at
  `workflows/research-workflow/logs/scripts/check-judgment-contract.sh:188-202`. Its only block-closing
  rules were `/^### Thesis /` and `END`; searched the block for any `/^## /` or section-boundary rule
  and found none, so the final thesis block continued into `## Provisional verdict` and later content.
- Claim (3): HOLDS — read `check-judgment-contract.test.sh` end to end. V11 (line 135) strips
  `[Q1-C11]` from Thesis 2 only; searched all 19 cases for one mutating the last thesis or building a
  five-thesis fixture and found none — the base fixture carries three theses and every case starts
  from it.
- Claim (4): HOLDS — `check-judgment-contract.test.sh` is the only test file beside the validator and
  runs it directly via `CHECK="${CHECK_OVERRIDE:-$HERE/check-judgment-contract.sh}"`.

Result: the final-thesis evidence-isolation defect is fixed, and the operator's approval of the repair
plan is recorded as content-bound header metadata with the plan's semantic body byte-unchanged.

Evidence:

1. **RED before the production edit.** Added V11b to `check-judgment-contract.test.sh`: a five-thesis
   fixture whose Thesis 4 cites `[Q2-A03]`, whose Thesis 5 cites nothing, and whose
   `## Provisional verdict` cites `[Q1-C05]`. Run against the *unmodified* validator the suite reported
   `FAIL V11b … expected exit 6, got 0` and exited `1` (19 passed, 1 failed) — the validator accepted a
   brief whose last thesis rested on the verdict's citation.
2. **GREEN after the smallest correction.** Added one line to the AWK block,
   `/^## / { close_block(); n = 0; next }`, so a thesis block ends at the next thesis *or* the next
   level-two section. Rerun: `V11b … (exit 6)`, suite `20 passed, 0 failed`, exit `0`.
3. **No regression.** All 19 pre-existing cases still pass, including V19, the falsifiability control
   that reruns the whole series against an always-exit-0 stub and asserts the series fails. V19 passing
   after the change is what rules out the fix having been absorbed by a weakened suite.
4. **Approved body unchanged.** Reversing exactly the two header lines this unit added regenerates the
   file at SHA-256 `1b9700666c62a2cbfae3b5b3a4daa7669d503dcc617c8b3c7f9bd3b11bb22ad4` — the brief's
   pre-approval hash — proving the edit is confined to administrative metadata.
5. **Bounded diff.** Four files, all inside the brief's scope: the repair plan's header (2 lines
   replacing 1), the validator (+1 executable line, +5 comment lines), the test file (+10 lines), and
   this state file. The two pre-existing unrelated working-tree edits —
   `logs/innovation-registry.md` and `.agents/skills/work-loop-v2/references/unit-framing.md` — and the
   untracked `audits/house-view-workflow-repair-decision-report-2026-08-20.md` were left unstaged and
   unmodified, as the brief required.

Commit: the single commit titled `update: house-view-workflow-repair — Unit 1 fixed final-thesis
evidence isolation and bound the plan approval`, on branch `session/2026-08-19-rw-l4-integration`,
carrying exactly the four files listed above and no others. It is named by title rather than by hash
because the hash of a commit cannot be written inside that same commit.

Deferred, not implemented: none noticed in this unit. The manual historical reviewer experiment
(Move 2) and all Moves 3–4 work remain deferred by the brief's own packaging.

## Blocker

None.

## Next action

Codex: assess Unit 1 — whether the final-thesis correction and its RED-then-GREEN evidence satisfy
Move 1, and whether the content-bound approval header is the right record. Then open Unit 2 (the
Move 2 manual reviewer feasibility experiment) or correct once.
