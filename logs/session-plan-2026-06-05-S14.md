# Session Plan — 2026-06-05 — S14

## Intent
Run `/improve` to diagnose and route the recurring diagnostics-lag friction pattern into a concrete, worth-doing structural fix proposal. The pattern surfaced twice on 2026-06-05 (both `/fix-project-issues` runs scanned candidates that were already resolved, wasting SO-vetting effort on dead items). The candidate structural fix is a live-state reconciliation pass inside the diagnostics-scanner that culls already-resolved candidates *before* System Owner vetting.

## Model
opus (analytical — routing a friction pattern + judging the structural fix's worth). Active model is Opus 4.8 (1M) — match.

## Source Material
- `logs/friction-log.md` — the diagnostics-lag entries (2nd recurrence logged today).
- `logs/usage-log.md` — telemetry on the wasted SO-vetting cycles.
- `logs/session-notes.md` — S12 + 2nd-run `/fix-project-issues` entries describing the lag.
- `logs/improvement-log.md` — routing target; check for an existing diagnostics-lag entry to update rather than duplicate.
- `.claude/agents/diagnostics-scanner.md` — the agent the proposed fix would eventually edit (read-only this session; edit is a separate gated session).
- `.claude/commands/improve.md` + the improvement-analyst agent — the command being run.

## Findings / Items to Address
- The diagnostics-scanner produces candidates from dated reports without reconciling against live repo state, so already-applied/already-resolved items re-enter the SO-vetting funnel.
- Recurrence is now 2× in one day — crosses the threshold from incidental to structural.
- `/improve` should: (1) confirm the pattern from friction + usage telemetry, (2) name the structural fix (pre-vetting live-state reconciliation cull), (3) give an ROI / worth-doing read, (4) route it into `improvement-log.md` (update existing entry if present, else append).

## Execution Sequence
1. Run `/improve` (improvement-analyst) — let it review this session's and recent friction signals.
2. Confirm the analyst surfaces the diagnostics-lag pattern; if it does not, supply the friction-log + session-notes evidence so it routes the specific pattern.
3. Ensure the routed output names the concrete structural fix and an ROI note.
4. Route to `improvement-log.md` — check for an existing diagnostics-lag entry first (no duplicate); append/update.
5. `/qc-pass` on the routed improvement-log entry (concrete fix? ROI named? no duplicate?).
6. Commit `improvement-log.md` (+ any analyst-written friction note) directly.

## Scope Alternatives
- **Lean (chosen):** run `/improve`, route the pattern + fix proposal, stop before implementing the scanner edit.
- **Extended (rejected this session):** also implement the diagnostics-scanner live-state reconciliation pass — but that's a structural-class agent edit needing its own `/risk-check`; out of scope for a single auto-gate.

## Autonomy Posture
Full autonomy. Analysis + log append only; no structural class touched. Commit directly per workspace rules; push gated to wrap.

## Risk
Low. Concurrent session S13 owns the id-14/15/16 structural work (independent files). Only shared-state contact point is `logs/improvement-log.md` — if S13 also appends there, post-write integrity check before commit (the documented logs/ concurrency hazard). No structural edit this session; implementing the surfaced fix is deferred to a gated follow-up.
