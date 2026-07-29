UNIT: 2026-07-29-review-layer-consolidation-build-4
STREAM: 2026-07-29-review-layer-consolidation
PHASE: build
SLICE: S4 — Consumer/migration evidence, guidance and decision record
REPO: ai-resources
BASE: c1b4435
NEXT: Prove

RETROSPECTIVE RECOVERY BRIEF — NOT AN ORIGINAL ARTIFACT

This brief was written on 2026-07-29 during a `/work-loop` Step 1 reconciliation,
AFTER the S4 implementation had already landed at commit 8840672. It did not exist
when the unit ran, and the brief-first ordering rule of `docs/work-loop.md`
§ Artifacts was NOT satisfied for this unit. Nothing here should be read as
evidence that it was.

The unit was run with brief and evidence combined into `…-build-4.evidence.md`,
following the same choice made in Build-3. See that unit's recovery brief for why
the reasoning does not survive the contract.

Written under operator authorization, to restore reachability only. Its scope is
transcribed from the G1-approved `…-shape.plan-v3.md` § 3 S4 — the approved slice
definition — and NOT back-derived from what the evidence reports was done. Where
the two differ, plan-v3 governs and the difference is a real finding; one such
difference is recorded below.

BRIEF
Implement slice S4 of the G1-approved package (`…-shape.plan-v3.md` § 3 S4).
Plan-v3 is immutable and is not edited by this unit. S4 is the stream's last Build
slice; it carries no new policy and no new removals — it realigns the guidance
layer to what S1–S3 already changed, and records the decision.

SCOPE — layer-4 guidance restated from the old rule, per plan-v3 § 3 S4:
`docs/session-rituals.md` · `docs/weekly-cadence.md` · `docs/weekly-session-guide.md` ·
`docs/friday-cadence-runbook.md` · `docs/operator-maintenance-cadence.md` ·
`docs/onboarding-daniel.md` · `docs/onboarding-daniel-cheatsheet.md` ·
`.claude/commands/monday-prep.md:266-267`.
NOT TOUCHED: `docs/materiality-bar.md` — the finding floor survives intact.

SCOPE — one append-only entry in `logs/decisions.md`, recording:
- the `/risk-check` reversal from plan-v2's KEEP, and why that argument was circular;
- the deletion deferrals on consumer grounds, with the 26-consumer count and the
  whole-directory symlink;
- the eight real separate project files (six diverged) that canonical edits cannot reach;
- `positioning-research`'s locally wired nudge hooks;
- the plan-v3 § 6 sequenced follow-up.
An entry in an existing log — NOT a registry, layer or gate.

EVIDENCE REQUIRED
- Per-file replacement count for each guidance file, every replacement matched.
- The decision-log entry written, append-only, dated.
- Final falsifier sweep across all nine plan-v3 § 9 falsifiers, at whole-stream scope.
- All twelve consumer counts re-derived with `find -L` and compared to plan-v3 § 8.
- Falsifier 8 at full scope, dispositioning every surviving hit.
- Explicit statement of what is NOT delivered and remains a § 6 follow-up.

FALSIFIED IF
Any plan-v3 § 9 falsifier fires; or `docs/materiality-bar.md` is edited; or an
excluded file is touched; or the decision record becomes a new registry, layer or
gate rather than one log entry; or the claim recorded exceeds plan-v3 § 4's
approved claim as bounded by § 0 Correction 1 and § 6.

KNOWN DEVIATION FROM THIS SCOPE, visible in the evidence
Plan-v3 § 3 S4 lists eight guidance files including `docs/weekly-cadence.md`. The
evidence reports seven files and does not list `weekly-cadence.md` among them. The
recovery brief records the approved scope as approved; whether that file needed no
change or was missed is NOT resolved here and is left as a question for Prove,
which is the unit that judges the result against Shape's criteria. It is stated
rather than quietly reconciled.
