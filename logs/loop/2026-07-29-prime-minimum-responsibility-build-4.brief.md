BRIEF
UNIT: 2026-07-29-prime-minimum-responsibility-build-4
STREAM: 2026-07-29-prime-minimum-responsibility
PHASE: build
REPO: ai-resources
BASE: 6a81121
NEXT: Claude — execute merged Slice 4+5 under plan-v5 § 3 Budget A

**Capability:** prime-runtime-delegation

**Operator-authored, 2026-07-29** (verbatim conditions carried from the S3-060 authorization, given
after plan-v5 landed and build-2 closed). Supersedes nothing; this is the unit plan-v5 § 5 said Slice 4
would need.

Need: `prime.md` stands at **503** lines after Slice 2. The mission's ≤300 target is falsified for the
current relocation-only package (plan-v5 § 4, operator-scoped in `logs/decisions.md` 2026-07-29), but
the **≤430 waypoint is reachable under Budget A** at a projected 426. Merged Slice 4+5 is the only
remaining package that reaches it: relocate rationale out of the 13 orientation regions (1–356, which
Slice 2 did not touch and which still measure exactly as plan-v4 § 1 recorded), and delete the stale
prose at `:281` citing `/new-project` step 11a (deleted 2026-07-27).

Scope: orientation regions only — `prime.md:1–356`. Budget A, behaviour-preserving, per plan-v5 § 3
(which supersedes plan-v4's Step 1d cell: **A = 16**, not 12; orientation total **279**, not 275).
Rationale destinations are existing documents only; no new file is created.

Premises to verify:
- Orientation is still 356 lines and its region boundaries still match plan-v4 § 1. Re-derive by
  `grep -nE "^[0-9]+[a-z]?\. "`, not from the plan.
- Every Budget A rationale destination exists and can hold what is moved to it. Plan-v4 § 3 names
  `docs/commit-discipline.md` (**new § Orientation pull**), `docs/heavy-read-discipline.md`,
  `docs/backlog-reconciliation.md`, `docs/session-marker.md`, `docs/qc-independence.md`,
  `.claude/commands/project-next-steps.md`. Confirm each by reading, not by assuming.
- `prime.md:281` cites `/new-project` step 11a and calls the wrong branch "normal". Confirm before
  deleting.
- **Step 1d has no citation destination** — `mission.md` carries no such shell (build-2 P1b,
  REJECTED). Do not re-derive this and do not reopen it.

Preserve, non-negotiable: Step 1a's git cross-check · Step 1d's mission scan · Step 3's `medium-high`
severity handling and its policy-change rule · Step 7's reply classifier entire. Every executable rule
stays in `prime.md` (plan-v4 § 2); only rationale moves.

Falsified if: ≤430 cannot be reached without changing behaviour. **Then STOP and record the measured
shortfall — do not force the target.** A region that cannot be cut to its Budget A cell without losing
a rule is reported at its real figure, not trimmed to fit.

Also in scope, per operator directive 6: resolve `logs/scripts/prime-marker.test.sh`, retired but still
present and exiting 2, before Prove opens.

Gates: `/risk-check`, `/qc-pass` and all subagent dispatch are **operator-declined** for this unit —
recorded as declined, never as passed, satisfied or waived, and **not** encoded as a QC-PENDING
commit-block. Verification is by direct inspection and deterministic executable tests only. Do not open
Prove; that is the next unit.
