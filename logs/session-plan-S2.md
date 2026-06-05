# Session Plan — 2026-06-04

## Intent
Implement two AI-strategy deliverables: (1) blanket-convert duplicated "Session Boundaries" sections across all carrying CLAUDE.md files (~17) to a single source-of-truth doc plus pointer references — operator override of F6's selective verdict, /risk-check-gated before any edit; and (2) recorded housekeeping items only — E10 (fold the compaction-scratchpad note into compaction-protocol.md) and the F1 deprecated-stub tidy.

## Model
opus — match (active: claude-opus-4-8[1m]). Deliverable 1 is high-blast-radius design+judgment work (pointer pattern, single-source placement, loss-of-every-turn-loading risk); deliverable 2 is mechanical execution. Higher tier governs.

## Source Material
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/ai-strategy/slot-1-decisions.md (F6/E10/F1 verdicts; the record to update)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/ai-strategy/implementation-tracker.md (status surface to update)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/ai-strategy/candidate-backlog.md (F-series source detail)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md (structural-class + risk-check change classes)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/repo-architecture.md (placement of the new single-source doc)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/compaction-protocol.md (E10 fold target — must confirm it covers the scratchpad-before-/compact pattern)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md + ai-resources/CLAUDE.md + ~15 projects/*/CLAUDE.md carrying the "Session Boundaries" heading (conversion targets)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/CLAUDE.md (E10 source — Compaction scratchpad pattern)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/output/context-packs/architecture-20260604-7c1a4/pack.md (context pack)

## Findings / Items to Address
1. **Deliverable 1 — Session Boundary consolidation (candidate F6).** ~17 CLAUDE.md files carry a near-verbatim "Session Boundaries" section. Operator has **overridden** F6's recorded verdict — slot-1-decisions.md line 39 says "CONVERT but NOT a blanket find-replace; keep verbatim where it loads every turn" — and directed a **blanket** conversion to a single source-of-truth doc + pointer references. The genuine technical risk F6 named (a `CLAUDE.md` loads every turn; a pointer does NOT auto-load, so behaviour that must run every turn could silently stop loading) is real and must be put to /risk-check before any edit. Source: slot-1-decisions.md:39.
2. **Deliverable 2a — E10 fold.** repo-documentation `CLAUDE.md#Compaction` restates the "scratchpad-before-/compact" pattern that already lives canonically in `compaction-protocol.md`. Action: confirm the canonical doc covers it, then replace the project copy with a pointer. Source: slot-1-decisions.md:27.
3. **Deliverable 2b — F1 stub tidy.** `/produce-handoff` is retired (superseded by `/develop-memo`); a deprecated stub was left in place. Action: tidy the stub (clear, dated deprecation note pointing to the replacement). Source: slot-1-decisions.md:28.
4. **Record-keeping.** Update slot-1-decisions.md F6 row to mark it superseded-by-operator-override (with date + rationale), and update implementation-tracker.md status for the items closed/advanced this session.

## Execution Sequence
1. **Inventory & verbatim capture.** Grep every CLAUDE.md (workspace root, ai-resources, all projects/*, exclude archive/) for the "Session Boundaries" section; capture each file's exact section text and note any per-file variations. Verify: a complete file→content map exists; final count confirmed (supersedes the engine's dual-repo undercount of 2 and the doc's stated 16).
2. **Decide single-source location + pointer template.** Choose where the canonical Session Boundaries doc lives (default candidate: `ai-resources/docs/session-boundaries.md`) and the exact one-line pointer that replaces each section. Verify: location + pointer pattern written down and surfaced to operator. **[STOP POINT — operator confirms pointer pattern before any mass edit.]**
3. **/risk-check (plan-time gate).** Run on the blanket conversion; the "pointer does not auto-load every-turn behaviour" concern is the central risk dimension to surface. Verify: verdict captured. **[STOP POINT — RECONSIDER/NO-GO halts per mandate Stop-if.]**
4. **Create the single-source doc** with consolidated Session Boundaries content. Verify: file written; content is the superset of all captured variations.
5. **Convert each carrying CLAUDE.md** — replace its Session Boundaries section with the agreed pointer. Verify: every file in the step-1 map converted; count matches.
6. **E10 fold + F1 stub tidy.** Confirm compaction-protocol.md covers the scratchpad pattern; point repo-documentation CLAUDE.md at it; tidy the F1 stub. Verify: project copy is a pointer; stub carries a clean dated deprecation note.
7. **Record-keeping.** Update slot-1-decisions.md F6 row (override) + implementation-tracker.md status. Verify: both files reflect the override and progress.
8. **QC.** `/qc-pass` on the new single-source doc + a sample of pointer edits + the record updates. Verify: GO (or fixes applied).

## Scope Alternatives
- **Min:** Deliverable 1 only (boundary consolidation), defer E10/F1 to a later housekeeping turn.
- **Recommended:** Both deliverables as scoped here (boundary consolidation + E10 fold + F1 stub tidy) — matches the operator's "recorded-items-only" choice.
- **Max:** Not on the table — operator explicitly declined a fresh housekeeping scan beyond the recorded items.

## Autonomy Posture
Gated

**Stop points:**
- After Step 2: operator confirms the single-source doc location + pointer template before any CLAUDE.md is edited (cross-cutting always-loaded content).
- After Step 3: /risk-check verdict — RECONSIDER or NO-GO halts the session (mandate Stop-if).

## Risk
Structural change classes present: cross-cutting CLAUDE.md edits across ~17 files + change to always-loaded content + a new always-loaded-by-pointer doc. Run `/risk-check` after this plan is approved (plan-time gate, Step 3 above) and again before commit (end-time gate). Do not edit any CLAUDE.md before the plan-time /risk-check returns GO.
