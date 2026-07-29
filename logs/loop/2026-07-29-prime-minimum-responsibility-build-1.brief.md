BRIEF
UNIT: 2026-07-29-prime-minimum-responsibility-build-1
STREAM: 2026-07-29-prime-minimum-responsibility
PHASE: build
REPO: ai-resources
BASE: 31080b0
NEXT: Claude — implement Slice 1

**Claude-authored**, not Codex-framed. Build units carry no review (`docs/work-loop.md:96`), and
this brief's content is fully determined by the G1-approved plan — it introduces no new framing.
Unit id names the **slice**, not the execution position: Slice 3 will be `-build-3`, so the
unit↔slice mapping stays unambiguous when execution order (1 → 3 → 2 → 4 → 5) diverges from slice
number.

Need: implement **Slice 1** of plan-v3 — re-site auto mode's single approval gate out of `/prime`
Step 8c into `/session-start`'s existing enrich-then-confirm flow, and delegate the mandate,
manifest and plan writes to their owners. `/prime` 8c goes 236 → 55 lines. Slice 1 carries the
whole verdict: if it fails, the ≤300 target is unreachable and the stream should stop rather than
spend four more slices.

Scope: Slice 1 only, exactly as specified at plan-v3 § 1 and § 3. Ten actionable files. No other
slice, no renumbering of any `/prime` step, no touching Step 1a's git cross-check or Step 3's
`medium-high` tier.

Premises to verify:
- `prime.md` is 830 lines and untouched; both worktrees clean on the three command files.
- `session-start.md` sets `files_inferred` at `:106` and clears it at `:243`; `:253` suppresses
  re-emit on `engine-skipped`/`engine-error`; `session-plan.md:239` emits "Begin execution".
- The Slice 1 file census is complete **for files needing an edit**.

Falsified if: `/prime` 8c does not reach ≤55 lines without moving work into a new `/prime` step;
any engine outcome can reach a mandate/manifest/plan write with no operator gate; engine-derived or
gate-edited values reach disk without re-running Step 2.5; `/session-plan` under `{gate:auto}` emits
"Begin execution"; any structural edit precedes `/risk-check`; or any `/prime` step is renumbered.
