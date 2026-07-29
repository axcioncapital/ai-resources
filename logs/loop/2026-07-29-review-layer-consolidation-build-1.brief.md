UNIT: 2026-07-29-review-layer-consolidation-build-1
STREAM: 2026-07-29-review-layer-consolidation
PHASE: build
SLICE: S1 — Governing review/risk policy and proportionality
REPO: ai-resources
BASE: 31b77ff8f1873e91373a8e940586aad07632bd09
NEXT: Claude

BRIEF
Implement slice S1 of the G1-approved package in
`logs/loop/2026-07-29-review-layer-consolidation-shape.plan-v3.md` § 3.
Plan-v3 is immutable and is not edited by this unit.

G1 VERDICT
Approved with one binding ordering correction. No slice cut. Scope, four-slice
package and target operating rule (plan-v3 § 1) approved as written.

G1 BINDING CONDITION — transition-gate ordering
Recorded here because plan-v3 is immutable. This condition **supersedes
plan-v3 § 7's** instruction to run the legacy gate "after S4's edits exist".
That instruction was wrong: it would require all four slices to sit uncommitted
at once, contradicting the one-commit-per-slice ordering in plan-v3 § 3 and the
one-unit-per-slice rule in `docs/work-loop.md:96`.

1. Run the legacy end-time `/risk-check` **after S1's actual edits exist on disk
   and before the S1 commit.**
2. Its payload and evidence must **distinguish the executed S1 diff from the
   approved but still-unexecuted S2–S4 package.** The gate reviews what exists.
   Do not describe S2–S4 edits as executed, and do not let the reviewer infer
   they are.
3. **After S1 lands, S2–S4 follow the newly approved proportional policy** —
   deterministic verification during Build, and the risk-aware Codex review at
   Prove before release/merge. No further `/risk-check` runs in this stream.
4. This is an **explicit policy transition, not a waiver** of the current
   end-time gate. The gate is honoured once, on real executed changes, and the
   run is recorded in this unit's evidence.
5. Plan-v3 § 7's second half stands unchanged: the **plan-time gate is not run
   and not silently skipped** — two full Codex plan reviews served its stated
   purpose (`docs/audit-discipline.md:75`) on this exact design, and that
   decision is recorded rather than absent.

SCOPE
Governing documents only. No command files, no hooks, no settings.json — those
are S2. Eight files, per plan-v3 § 3 S1:
- `docs/qc-independence.md` — rewrite as the plan-v3 § 1 rule
- `docs/audit-discipline.md` — § Risk-check change classes, When to fire,
  Verdict semantics, Invocation semantics
- `docs/autonomy-rules.md:19` — Rule #9
- `docs/work-loop.md` — `:65` and the route table's independent-review column
- `docs/protected-zones.md` — Required-review column, six cells
- `docs/repo-architecture.md:217` — Q5
- `docs/ai-resource-creation.md` — `:19`, `:25`, `:46`
- `skills/ai-resource-builder/SKILL.md` — Step 6

RETAINED, EXPLICITLY (plan-v3 § 3 S1)
Context isolation; mechanical-mode acceptance; the materiality-floor pointer;
halt-and-surface rekeyed to an unresolved material finding; the 2026-07-03
class-boundary clarification; the premise-verification precondition (migrated
into the Codex review brief); § Subagent Proportionality; the Consumer-Inventory
Gate and Misinterpretation Check in `ai-resource-builder`; the generalization-
residue check.

EVIDENCE REQUIRED
- Before/after for each of the eight files.
- `grep -rn 'second post-edit QC\|triage + fix passes\|QC-PENDING\|two-gate\|plan-time gate' docs/ skills/`
  → hits only in files S2 owns, `logs/loop/`, and the plan-v3 § 6 follow-up set.
  Same grep at BASE as positive control.
- Consumer predicates from plan-v3 § 9 falsifier 1, both shapes, both
  positive-controlled.
- The `/risk-check` verdict for the S1 diff, with its scope line quoted.
- No file created outside `logs/loop/2026-07-29-review-layer-consolidation-*`.

FALSIFIED IF
Any plan-v3 § 9 falsifier fires; or an S2–S4 file is edited in this unit; or the
legacy gate is run before S1's edits exist, after the S1 commit, or on a payload
that presents unexecuted S2–S4 work as executed.
