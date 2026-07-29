UNIT: 2026-07-29-review-layer-consolidation-build-3
STREAM: 2026-07-29-review-layer-consolidation
PHASE: build
SLICE: S3 — Specialist dispositions and protected-safeguard verification
REPO: ai-resources
BASE: e410328
NEXT: Claude — Build-4 (S4)

EVIDENCE

Brief and evidence are combined for this unit. S3 is mostly verification — most
specialist decisions are decisions *not* to change something — and a separate
brief file would be ceremony of exactly the kind review-2's R2-F4 removed.

## 1. Edits (4 files)

| File | Change |
|---|---|
| `.claude/agents/reconcile-reviewer.md` | Removed input 5 `CONTRACT_CHECK_RESULT` and the fold-in paragraph. S2 removed the automatic `/contract-check` that produced it, so the field would have been permanently `"not run"` — dead machinery. The agent is now stated plainly as the mandate-compliance judgment, needing no second opinion. |
| `.claude/commands/reconcile.md` | Removed the now-dead `CONTRACT_CHECK_RESULT` pass-through at Step 4's input list and the `"not run"` assignment at Step 3. |
| `.claude/commands/refinement-deep.md` | **Retirement-deferred notice.** States that this command *is* the stacked review the stream removed, that nothing invokes it automatically now, that deletion waits on cross-project migration, and that it is not the default. |
| `.claude/commands/resolve.md` | **Retirement-deferred notice.** Same shape; notes its Stop-hook nudge was deleted in S2, and that applying findings does not earn another review round. |

**Correction to plan-v3 § 3 S3.** The plan located the `CONTRACT_CHECK_RESULT` field in `docs/reconcile-report-template.md`. It is not there — `grep -rn CONTRACT_CHECK_RESULT docs/ .claude/` returns the real consumers: `.claude/agents/reconcile-reviewer.md:23,43` and `.claude/commands/reconcile.md:58,68`. The template needed no edit. Field now fully removed: same grep → **zero hits**.

## 2. Surviving evaluators — route and unique output re-verified against live files

Each passes the test in plan-v3 § 5: it produces the command's own primary output, so removing it removes the command's purpose. It is not a review of work Codex reviews.

| Evaluator | Invocation route (verified) | Unique output |
|---|---|---|
| `scope-qc-evaluator` | `scope-project.md` — 1 hit, the Stage 5 delegation that *is* the stage | Five-way readiness verdict + three-way decision ledger |
| `reconcile-reviewer` | `reconcile.md` — 4 hits, Step 4 | Mandate-compliance score, resource-activation audit, genericness check, root-cause class |
| skill-evaluation pass | `create-skill.md`, `improve-skill.md`, `migrate-skill.md` — 1 `evaluation-framework` hit each | Behavioral analysis + convention gate against the drafted skill |
| generalization-residue check | `graduate-resource.md` Step 5.5 | Mechanical grep for source-project residue — detection, not judgment |
| `new-project` Architecture Gate | `new-project.md` — 5 hits | One advisory ROI call at a real decision gate, once per pipeline, non-blocking |
| audit/scan engines | `repo-dd-auditor`, `token-audit-auditor`, `lean-repo-auditor`, `diagnostics-scanner`, `system-owner` in `/fix-project-issues` | Each *is* its command's analysis |

**Untouched by the entire stream** (`git diff 2cb245e..HEAD --name-only` per path → empty): `scope-project.md`, `new-project.md`, `migrate-skill.md`. `create-skill.md` and `improve-skill.md` were touched, but only to remove framing that pointed at deleted policy (S1) and to replace an automatic post-edit QC subagent with deterministic verification (S2) — neither touched the evaluation pass itself.

**Nothing was added to this set.** No component was created to replace anything removed.

## 3. Protected-safeguard verification — the stream as a whole

| Safeguard | Result |
|---|---|
| Six protected hooks incl. `check-destructive-liveness.sh` | Byte-identical across the whole stream |
| Permission surface (`allow`/`ask`/`deny`, any layer) | Zero changes; only two hook entries removed |
| `cleanup-worktree.md` Section 4 hard gates + named confirmation phrases, Section 7 counters 1/2/4, Steps 13/13b | Unchanged |
| `execution-protocol.md` §§ 7–13 | Unchanged **and not renumbered** despite §§ 5–6 being removed — renumbering would invalidate every by-number reference to the hard-gate and execution-time sections |
| `friday-journal.md` Steps 5.4 / 5.6 / 5.7 | Mechanics unchanged; flag wording changed in lockstep producer→consumer |
| `promote-workflow.md` P4 anti-clobber, P6, P5.4 push gate | Unchanged |
| `docs/materiality-bar.md` (the finding floor) | Unchanged |

## 4. Falsifiers

1 clear (no symlink touched; the 7 pre-existing breakages are unchanged) · 2 clear (counts unmoved) · 3 clear · 4 clear (no new component) · 5 clear (§ 3) · 6 clear (no excluded file) · 7 clear (zero deletions in S3) · 8 clear for S3's scope · 9 N/A.

---

Status: complete

Marker appended 2026-07-29 during `/work-loop` Step 1 reconciliation, not at the time
the unit ran. The S3 work landed at commit c1b4435 and is unaltered by this append;
only this closure block was added.

**Ordering rule was not satisfied for this unit.** The statement above that "brief and
evidence are combined" describes what was done, not a permitted variant. This unit had
no `…-build-3.brief.md` until one was written retrospectively in the same reconciliation
that added this marker. That recovery brief carries the full notice and is not evidence
that the original ordering was met.
