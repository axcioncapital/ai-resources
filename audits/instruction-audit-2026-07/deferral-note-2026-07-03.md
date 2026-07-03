# Deferral Note — Instruction-Leanness Campaign

**Date:** 2026-07-03
**Status:** Investigation complete. **All implementation deferred to a future session.** No instruction-system file was changed this session.

## What this campaign is
Audit and lean out the Axcíon instruction system (the 2 always-loaded `CLAUDE.md` files, the docs they load, and the command/skill/agent corpus) for modern high-capability models — remove duplication, resolve contradictions, move mechanism-detail out of always-on context, relax over-firing gates (per-item approved). Approved via `/clarify` → `/scope`.

- **Approved plan:** `~/.claude/plans/make-an-investigation-clarify-vast-robin.md`
- **Locked choices:** full-corpus scope; relax gates too (per-item approval); governed pipeline (`/risk-check` + independent `/qc-pass`); fresh manual audit.

## Investigation artifacts produced this session (kept in tree)
- `phase0-inventory-diagnosis.md` — always-on-layer map, corpus survey, gate register (frozen baseline).
- `phase0-tier3-currency-check.md` — Tier-3 archive candidates + verdicts.
- `../risk-checks/2026-07-03-phase-1-claude-md-duplication-contradiction-fixes.md` — Phase 1 risk-check (verdict PROCEED-WITH-CAUTION, 5 mitigations).
- SO advisory: `projects/axcion-ai-system-owner/output/consultations/consult-2026-07-03-phase-1-instruction-leanness-risk-check-second-opinion.md`.

## What happened / why deferred
Phase 1 (fix push contradiction + collapse always-on duplicates) began editing. It was stopped by the operator: some edits (two command files — `graduate-resource.md`, `resolve-incident.md`) went beyond the approved `/scope` file list. **All 4 edited files were reverted** to their committed state:
- `docs/autonomy-rules.md`, `docs/session-rituals.md` (were in scope), `.claude/commands/graduate-resource.md`, `.claude/commands/resolve-incident.md` (were NOT in scope).

## Two corrections the deferred session MUST carry
1. **Operator correction — 3 docs are DEAD, not LIVE** (overrides the Tier-3 currency check, which wrongly inferred them active from git history): `operator-maintenance-cadence.md`, `onboarding-daniel.md`, `onboarding-daniel-cheatsheet.md`. Treat as archive/delete candidates. Confirm doc-liveness with the operator, never by git-history inference.
2. **Scope discipline** — do not fold extra files into an approved edit set on the strength of a risk-check/SO recommendation alone. If the risk-check surfaces additional in-class files (it found 2 command copies of the push contradiction), re-confirm the expanded file list with the operator before editing — a chat mention is not approval.

## Phase 1 edit set (for whoever resumes), unchanged from the risk-check
- Push contradiction — canonical = gated/batched (workspace `CLAUDE.md` § Push behavior). Stale copies to align: `docs/autonomy-rules.md` line ~12; `docs/session-rituals.md` § Before Committing; `.claude/commands/graduate-resource.md`; `.claude/commands/resolve-incident.md`. (Re-confirm the command-file copies are in scope first — see correction 2.)
- Collapse duplicates to single-canonical + named-section pointer: Decision-Point Posture, Autonomy 10-item list (root keeps a shortlist that preserves each gate's *trigger conditions*), QC-unreachable rule.
- **Do NOT collapse** the `ai-resources/CLAUDE.md` Model-Tier and commit/push restatements to bare pointers — they are deliberate DR-5 mirrors (project sessions can add-dir into `ai-resources/` without loading workspace-root `CLAUDE.md`; a bare pointer would let the highest-stakes rules go dark). Tighten, don't remove.
- Fix `docs/session-boundaries.md` stale provenance claim.
- Apply the 5 risk-check mitigations + SO amendments; run independent context-isolated `/qc-pass`; `/contract-check` at wrap.

## How to resume
Fresh session → `/prime` → read the approved plan + this note → confirm the Phase 1 file list (with the 2 corrections) → proceed under the governed pipeline.
