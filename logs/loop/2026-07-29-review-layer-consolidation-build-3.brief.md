UNIT: 2026-07-29-review-layer-consolidation-build-3
STREAM: 2026-07-29-review-layer-consolidation
PHASE: build
SLICE: S3 — Specialist dispositions and protected-safeguard verification
REPO: ai-resources
BASE: e410328
NEXT: Claude — Build-4 (S4)

RETROSPECTIVE RECOVERY BRIEF — NOT AN ORIGINAL ARTIFACT

This brief was written on 2026-07-29 during a `/work-loop` Step 1 reconciliation,
AFTER the S3 implementation had already landed at commit c1b4435. It did not exist
when the unit ran, and the brief-first ordering rule of `docs/work-loop.md`
§ Artifacts was NOT satisfied for this unit. Nothing here should be read as
evidence that it was.

The unit was run with brief and evidence combined into
`…-build-3.evidence.md`, on the stated reasoning that S3 is mostly verification
and a separate brief would be ceremony. That reasoning does not survive the
contract: § Resume order and every row of § Reconciliation index on briefs, so a
unit with no brief is unreachable by the loop regardless of how well it is
documented. The unit's work was sound; its bookkeeping was not.

Written under operator authorization, to restore reachability only. Its scope is
transcribed from the G1-approved `…-shape.plan-v3.md` § 3 S3 — the approved slice
definition — and NOT back-derived from what the evidence reports was done.
Where the two differ, plan-v3 governs and the difference is a real finding; one
such difference is recorded in the evidence and repeated below.

BRIEF
Implement slice S3 of the G1-approved package (`…-shape.plan-v3.md` § 3 S3).
Plan-v3 is immutable and is not edited by this unit.

SCOPE — edits, per plan-v3 § 3 S3:
- `docs/reconcile-report-template.md` — remove the `CONTRACT_CHECK_RESULT` field,
  the paired consumer of the automatic `/contract-check` S2 removed.
- `.claude/commands/refinement-deep.md`, `.claude/commands/resolve.md` —
  **retirement deferred** on consumer grounds. Both become operator-invoked-only
  in fact once S2 removes their automatic callers. NEITHER IS DELETED. One status
  line each.

SCOPE — verification, which is this slice's substance, per plan-v3 § 3 S3:
- Every surviving evaluator in plan-v3 § 5 confirmed against the live file:
  invocation route and unique output, against the § 5 test that removing it would
  remove the command's own purpose.
- Every protected safeguard proven byte-identical (plan-v3 § 9 falsifier 5).
A thin edit set is the correct outcome here — most specialist decisions are
decisions not to change something.

PROTECTED — must be byte-identical after this unit:
Six protected hooks incl. `check-destructive-liveness.sh` · every `allow`/`ask`/
`deny` entry in settings.json · `cleanup-worktree.md` Section 4 hard gates and
named confirmation phrases, Section 7 bias counters 1/2/4, Steps 13 and 13b ·
`execution-protocol.md` §§ 7-13 · `friday-journal.md` Steps 5.4, 5.6, 5.7 ·
`promote-workflow.md` P4 anti-clobber, P6, P5.4 push gate · `docs/materiality-bar.md`.

EVIDENCE REQUIRED
- Per-file before/after for each edited file.
- `CONTRACT_CHECK_RESULT` fully removed — grep across `docs/` and `.claude/`
  returning zero hits, with the pre-edit hit list as the positive control.
- Surviving-evaluator table: route verified by hit count in the live caller, plus
  the unique output each produces.
- Protected-set proof: `git diff` over each protected path empty.
- No new component created to replace anything removed.
- Consumer counts unchanged.

FALSIFIED IF
Any plan-v3 § 9 falsifier fires; or a protected item above differs; or a policy
doc S1 owns is edited here; or `refinement-deep.md` or `resolve.md` is deleted
rather than annotated; or any canonical command or agent is deleted (S3 deletes
nothing); or an excluded file is touched.

KNOWN DEVIATION FROM THIS SCOPE, already recorded in the evidence
plan-v3 § 3 S3 located `CONTRACT_CHECK_RESULT` in `docs/reconcile-report-template.md`.
It is not there. The live consumers were `.claude/agents/reconcile-reviewer.md:23,43`
and `.claude/commands/reconcile.md:58,68`, and those are what the unit edited; the
template needed no edit. The field is fully removed either way. This is an
inventory error in the approved plan, not a scope change — recorded here so the
recovery brief does not silently present the plan as having been accurate.
