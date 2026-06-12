# Session Plan — 2026-06-12 S7

## Intent
Run 3 picked menu items in order: (1) re-sync the 10 dormant project-local `split-log.sh` copies from the fixed canonical; (2) run `/log-sweep` to confirm the brand-book decisions file archives cleanly live; (3) verify the content-conservation tripwire guardrail-candidate entry in `improvement-log.md`.

## Model
Recommended: sonnet (doing-tier — mechanical propagation + verification). Session proceeds on the active model; no switch required.

## Source Material
- `logs/maintenance-observations.md` — 2026-06-12 S6 dormant-copy drift note (item 1 source).
- `logs/scratchpads/2026-06-12-13-30-scratchpad.md` — S6 Resume With list (items 1 & 3 source).
- `logs/session-notes.md` S6 entry — Next Steps (item 4 source).
- `output/context-packs/incident-20260612-7b2e4/pack.md` — context pack (concrete file list, 10 copies enumerated).
- Canonical reference: `logs/scripts/split-log.sh` at commit `1ca4c1c` (fence-aware + preamble-preserving).
- `.claude/commands/log-sweep.md` — sweep mechanics for item 2's run.

## Findings / Items to Address

### Item 1 — Dormant split-log.sh copy re-sync
- The context engine enumerated **10** project-local copies (maintenance note estimated ~14): buy-side-service-plan, obsidian-pe-kb, global-macro-analysis, project-planning, interpersonal-communication, nordic-pe-screening-project, ai-development-lab, axcion-brand-book, research-pe-regime-shift-advisory-gap, positioning-research.
- All carry pre-fix logic (no fence-awareness, preamble deletion on rewrite, possibly `mapfile` bash-3.2 incompatibility).
- Disposition decided at the gate: **re-sync** (overwrite with canonical), not delete. Rejected alternative: deletion — risks breaking project-local sweep invocation, saves nothing.
- The template copy `workflows/research-workflow/logs/scripts/split-log.sh` was already synced at S6 — not in this item's set.
- Each project dir may be its own git repo — commit per repo where so; explicit-path staging only (4 concurrent sessions live).
- Skip-and-surface rule: any repo whose `split-log.sh` has foreign uncommitted changes is skipped and reported, not overwritten.

### Item 3 — /log-sweep live confirmation
- S6 verified the fix on an **isolated copy** of `axcion-brand-book/logs/decisions.md`; the live confirmation was deferred to "next sweep."
- Run `/log-sweep` scoped to the brand-book project (narrow scope — full 16-scope sweep is out of mandate).
- Expected: the decisions file splits cleanly (S6 isolated test: 19/10 split, 88=88 content lines, template preserved).
- Mandate stop-if applies here: wrong boundaries or data-loss shape on the live file → stop and surface.
- Ordering note: run AFTER item 1 so the brand-book local copy (if it is the one invoked) is already fixed.

### Item 4 — Content-conservation tripwire entry verification
- S6's wrap says the guardrail-candidate was already routed: "Routed: 1→improvement-log (content-conservation tripwire, appended by main session)."
- Likely zero-work verification (same shape as S6's item 3). Grep `improvement-log.md` for the entry; if present → item closes; if absent → append it per the S6 session-assessment text (split-log.sh lacks a fail-loud content-conservation tripwire; both loss paths caught only by manual testing; severity low).

## Execution Sequence

### Stage 0 — Risk-check (pre-execution gate)
`/risk-check` on item 1 (shared-state automation propagation across 10 project repos). GO → proceed; RECONSIDER/NO-GO → pause auto mode, retain mandate + plan.

### Stage 1 — Item 1: copy re-sync
1. Verify canonical `logs/scripts/split-log.sh` is clean at `1ca4c1c` state.
2. For each of the 10 project copies: check foreign-dirty state (skip-and-surface if dirty); `cp` canonical over it; verify byte-identity (`cmp`).
3. Commit per containing repo, explicit paths only, message `update: split-log.sh — re-sync from canonical (fence-aware + preamble-preserving, 1ca4c1c)`.

### Stage 2 — Item 3: live sweep confirmation
4. Run `/log-sweep` scoped to axcion-brand-book. Confirm `decisions.md` archives cleanly (entry boundaries correct, no content loss — line-count conservation check).
5. On any data-loss shape: STOP per mandate stop-if.

### Stage 3 — Item 4: tripwire entry verification
6. Grep `logs/improvement-log.md` for the content-conservation tripwire entry. Present → close item. Absent → append entry and commit.

### Stage 4 — Close-out
7. `/qc-pass` on the substantive change set (item 1 propagation + any item 4 append).
8. Report mandate completion; remind `/wrap-session`; push stays batched (9+ unpushed commits).

## Scope Alternatives
- **Narrower:** items 3+4 only (verification-only session, no propagation). Rejected at gate — leaves the dormant-copy drift open for another week and the operator picked item 1 explicitly.
- **Wider:** also restore the 2 lost marketing-positioning preamble lines (menu item 2) — NOT picked; stays out of scope. Also full 16-scope `/log-sweep` — out of mandate, the confirmation needs only the brand-book scope.

## Autonomy Posture
Gated for item 1's structural class (shared-state automation propagation — risk-check at Stage 0); full autonomy otherwise. Single approval gate already passed (operator `go`). Concurrency discipline: 4 live foreign sessions in this checkout — explicit-path staging everywhere, skip-and-surface on foreign-dirty targets.

## Risk
- **Shared-state automation across 10 repos** (item 1) — mitigated: byte-identity verification per copy, per-repo commits, risk-checked at Stage 0.
- **Live-log mutation** (item 3) — mitigated: mandate stop-if, line-count conservation check, S6's 19/19 isolated test as prior evidence.
- **Concurrent-session collision** — 4 live sessions; mitigated: explicit-path staging, foreign-dirty skip rule.
- **Copy-count drift** — engine found 10 vs note's ~14; Stage 1 re-enumerates via find before copying so no copy is silently missed.
