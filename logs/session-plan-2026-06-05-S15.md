# Session Plan — 2026-06-05 (S15)

## Intent
Execute all 4 items in the `/fix-repo-issues` 2026-06-05 fix plan in order: log-hygiene first (item 1, no QC), then the 3 harness command/skill fixes (items 2–4, each QC'd), then update friction/improvement logs. Auto-mode single-gate bundle.

## Model
Opus 4.8 — match. The bulk is doing-tier mechanical editing, but items 2–4 touch concurrent-session detection logic, the prime input-classifier, and session-marker initialization — judgment-bearing harness edits where a subtle error silently breaks gate behavior. Higher tier justified.

## Source Material
- Fix plan: `audits/fix-plans/fix-repo-issues-2026-06-05-1918.md` (4 items, 7 scopes scanned, 8 reconciled-done)
- Item 1 target: `logs/improvement-log.md` (3 applied entries: id-14, id-15, diagnostics-lag resolution)
- Item 2 target: `.claude/commands/wrap-session.md` Step 3.5 (workspace-root mirror confirmed MISSING — single-file edit) + `logs/friction-log.md` annotation
- Item 3 target: `.claude/commands/prime.md` Step 7 classifier + `projects/marketing-positioning/logs/friction-log.md` annotation
- Item 4 target: `.claude/commands/clarify.md` preamble (no `skills/clarify/SKILL.md` — command file only) + `projects/research-pe-regime-shift-advisory-gap/logs/friction-log.md` annotation
- Schema reference: `.claude/commands/resolve-improvement-log.md` (Verified-field placement)

## Findings / Items to Address

### Item 1 — Verified fields (id-11/12/13) [no QC]
Three `Status: applied` improvement-log entries lack a `**Verified:**` line. Add the line immediately after `**Status:** applied` per the canonical schema:
- id-14 entry → `**Verified:** 2026-06-05 — confirmed via commit 2bc89d9 …`
- id-15 entry → `**Verified:** 2026-06-05 — confirmed via commit 2bc89d9 …`
- diagnostics-lag resolution entry → `**Verified:** 2026-06-05 — confirmed via commit 23c9143 …`
Log-hygiene only; no behaviour change. Run `/resolve-improvement-log` after to confirm archival eligibility (do not necessarily archive — verify qualification).

### Item 2 — wrap-session Step 3.5 chained-task false-positive (id-05) [QC]
FOREIGN-count logic counts same-day marker-bearing headers not equal to this session's marker. Auto-mode chained tasks append multiple work-description lines under ONE marker header, so that is not the failure mode — the failure is that the guard must read this session's own MARKER from `logs/.session-marker` (or the per-session-id file) and exclude `## YYYY-MM-DD — Session {MARKER}` headers matching the current marker. Edit: anchor the FOREIGN computation to the resolved current MARKER. Workspace-root mirror MISSING → single-file edit. QC scope: confirm legitimate concurrent-session (different-marker) detection is preserved.

### Item 3 — prime Step 7 N-auto parser (marketing id-02) [QC]
`N auto` (e.g. `2 auto`) is currently parsed as a bare-number selection, silently skipping auto-mode. Add a classifier branch before the bare-number check: trimmed input matching `^[1-6]\s+auto$` re-classifies to `auto N` → Step 8c. Inline comment noting `N auto` ≡ `auto N`. (This session hit the exact bug — `2 auto`.) QC scope: confirm the new branch does not shadow existing valid classifier paths.

### Item 4 — /clarify marker-trio preamble (research-pe id-09) [QC]
A session started via `/clarify` without prior `/prime` writes markerless entries to `session-notes.md`. Add a preamble step: read `logs/.session-marker`; if absent/stale, run the marker-trio init (`.session-marker`, per-session-id file, `## YYYY-MM-DD — Session S{N}` header append), then write `logs/.prime-mtime`. QC scope: confirm no double-create when `/clarify` runs after `/prime`.

## Execution Sequence
1. **Item 1** — read `resolve-improvement-log.md` schema; locate the 3 entries; insert `**Verified:**` lines. No QC.
2. **Item 2** — edit `wrap-session.md` Step 3.5 FOREIGN logic; `/qc-pass`; resolve; annotate `logs/friction-log.md` `[FADING-GATE] verified 2026-06-05`; flip any matching improvement-log entry.
3. **Item 3** — edit `prime.md` Step 7 classifier; `/qc-pass`; resolve; annotate marketing-positioning friction-log.
4. **Item 4** — edit `clarify.md` preamble; `/qc-pass`; resolve; annotate research-pe friction-log; log improvement-log note if a deferred entry exists.
5. **Close** — run `/resolve-improvement-log` to confirm item-1 entries qualify for archival; commit per logical batch (log-hygiene batch + per-command-fix batches, operator preference = batched).
Between-gate one-line summary emitted at each item boundary (no operator pause — single gate covers all).

## Scope Alternatives
- **Full (planned):** all 4 items + log updates + QC. Recommended.
- **Lean:** items 1 + 3 only (log hygiene + the parser fix that this session demonstrably needs) — drops the two lower-frequency harness fixes (wrap-session FOREIGN edge, clarify markerless start) to a later session. Available if risk-check flags the harness edits.
- **Minimal:** item 1 only (log hygiene, zero structural risk).

## Autonomy Posture
Gated — structural class (shared harness command/skill edits). `/risk-check` runs before execution per Autonomy Rule #9. The single auto-mode approval gate already disclosed this. QC each command/skill edit before declaring it complete.

## Risk
- **Structural:** true. Three of four items edit shared harness files (`wrap-session.md`, `prime.md`, `clarify.md`) whose behaviour affects every session.
- **Blast radius:** prime parser and wrap FOREIGN-count are on the hot path of session start/end; a regression is high-visibility but caught by the per-item `/qc-pass`.
- **Reversibility:** high — all edits are localized command-file changes, revertable per commit.
- **Mitigations:** per-item QC; lean/minimal scope alternatives held in reserve if risk-check downgrades.
