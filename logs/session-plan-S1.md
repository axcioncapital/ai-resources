# Session Plan — S1 (2026-06-05)

## Intent
Apply the four System-Owner-prioritized fixes from the 2026-06-05 monthly `/friday-checkup` by running `/friday-act`. Auto mode, single approval gate already cleared.

## Model
opus (`claude-opus-4-8[1m]`) — match. `/friday-act` is a deciding+doing cadence: triage judgment plus structural harness fixes. No `/model` switch needed.

## Source Material
- `audits/friday-checkup-2026-06-05.md` — consolidated monthly checkup report (the findings `/friday-act` triages).
- `projects/axcion-ai-system-owner/output/friday-advisories/friday-advisory-2026-06-05.md` — System Owner advisory naming the four fixes to sequence first.
- `logs/session-notes.md` (S1 mandate) — this session's scope.

## Findings / Items to Address
The System Owner advisory prioritizes four systemic fixes, in order:
1. **`ai-resources/.claude/settings.local.json` permission-floor restore** [CRITICAL] — the permission floor was defeated (shadowing); restore it so bypass/floor holds.
2. **Push-rule contradiction correction** — `marketing-positioning` + `research-pe` project CLAUDE.md files carry push rules that contradict the canonical gated-batched push rule.
3. **`/new-project` CLAUDE.md template fix** — the template seeds per-project CLAUDE.md bloat; patch it to stop the recurrence. Touches harness config → internal `/risk-check` gate.
4. **`Read()` deny extension** — extend the deny rule (highest-leverage token lever). Touches harness config → internal `/risk-check` gate.

## Execution Sequence
1. Invoke `/friday-act`. It reads the checkup report + advisory, runs its own triage, and presents its triage/fix plan.
2. `/friday-act` applies fixes in its prioritized order, hitting its internal `/risk-check` gates on items 3 and 4 (harness config).
3. On each internal gate verdict: GO → apply; RECONSIDER/NO-GO → pause auto mode, retain state, surface to operator.
4. `/friday-act` runs its own verify step and produces its session record.

## Scope Alternatives
- **Full (default):** all four prioritized fixes applied this session.
- **Minimal subset:** only the CRITICAL permission-floor restore (item 1) + the two push-rule corrections (item 2) — the non-structural, no-internal-gate fixes — deferring items 3–4 (harness config) to a dedicated risk-checked session. Available if a gate stalls or context tightens.

## Autonomy Posture
Gated. Item touches structural change classes (permission restore, harness template, deny-list). Risk-checking is delegated to `/friday-act`'s own per-fix internal gates rather than a redundant standalone auto-mode `/risk-check`. On any internal NO-GO, auto mode pauses with state retained.

## Risk
- **Double-gating avoided:** standalone auto-mode `/risk-check` skipped; `/friday-act`'s internal gates govern items 3–4. If `/friday-act` does NOT gate a structural fix internally, surface and pause before applying.
- **Concurrency:** 7 sibling same-day sessions already wrapped; marker file was stale (yesterday S8), reset to S1 cleanly. No live concurrent session detected.
- **Pre-existing working-tree state:** `audits/friday-checkup-2026-06-05.md` is staged-uncommitted from a prior session; the divergent-branch state (4 unpushed local + 1 unmerged remote) is unresolved. `/friday-act` fixes are independent of these, but the divergence must be reconciled before the eventual push.
