# Risk Check — 2026-05-29

## Change

Modify /friday-act Step 3 (tactical follow-ups loop) and Step 3.5d/3.5f (SO-derived + journal-derived loops) to compute a default disposition string from each item's risk label (HIGH→f, MED→d, LOW→s), display the string with a per-item risk×letter mapping table, and let the operator press Enter to accept or paste a corrected `{f,d,s}+` string. Today: all three prompts are hard operator-paste checkpoints. After: auto-triage default with an inline override path; same downstream validation regex; new optional `triage_source: {auto-default | operator-override}` field on `FIX_NOW_ITEMS` for Step 5 logging. No other commands touched; no hooks; no settings.json; no CLAUDE.md.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-act.md — exists

## Verdict

GO

**Summary:** Single-file edit to one command's prompt UX; preserves the downstream `FIX_NOW_ITEMS` schema and validation regex, adds one optional field, touches no shared infra.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- `/friday-act` is invoked once per Friday cadence — not auto-loaded, not hook-triggered. Adding ~30–80 lines of in-prompt mapping-table + default-string logic to a weekly command incurs no per-session token cost on other workflows. Evidence: `friday-act.md` is under `.claude/commands/` (line 1 `model: sonnet`), invoked by operator on demand.
- No `@import` chain, no SessionStart/Stop/PreToolUse hook is added — change description says "no hooks; no settings.json; no CLAUDE.md."
- The added `triage_source` field on `FIX_NOW_ITEMS` is in-memory state during the command run; only surfaces in Step 5 logging output to `maintenance-observations.md` (one line of subtotal text per session block).

### Dimension 2: Permissions Surface
**Risk:** Low

- Change description explicitly states "no settings.json." No new Bash patterns, no Write paths, no tool capabilities introduced. The command already writes to `maintenance-observations.md` and `audits/friday-plans/` (lines 298, 227 of `friday-act.md`); no new write target.

### Dimension 3: Blast Radius
**Risk:** Low

- Direct file touch: 1 (`ai-resources/.claude/commands/friday-act.md`).
- Callers of `/friday-act`: grep for `friday-act` across `ai-resources/.claude/` returns 1 producer-side schema-contract reference in `friday-journal.md` (line 319, 326), 1 sibling reference in `fix-repo-issues.md` (line 278), 1 delegated subagent (`friday-act-16a-summarizer.md`). None of these interact with the Step 3 / 3.5d / 3.5f disposition UX — they integrate at the `## Items` regex (`^\[(high|med|low)\] .+$`) which the change explicitly preserves ("same downstream validation regex").
- `FIX_NOW_ITEMS` shape consumers: only Step 3.6 (sub-steps 16g–16l) in the same file consume it (lines 212–268). Adding an optional `triage_source` field is additive and backwards-compatible — the existing fields (`source`, `risk`, `text`, `risk_check_required`, `w2_4_source`) are untouched per the change description, and Step 5 logging at line 310 already iterates `RESULTS` for subtotals.
- `maintenance-observations.md` schema (lines 298–329 of `friday-act.md`): adding a subtotal line for `triage_source` counts is an additive append to an already-evolving session-block schema; the file's own intro (line 16) defers schema authority to `/friday-act`.
- No contract break: the regex `^\[(high|med|low)\] .+$` (line 154, 183, 192) is the producer-consumer seam with `/friday-journal`. Change preserves it.

### Dimension 4: Reversibility
**Risk:** Low

- Single-file edit. `git revert` on the commit restores prior behavior fully.
- The new `triage_source` field appears only in in-memory `FIX_NOW_ITEMS` (transient) and possibly one new subtotal line in `maintenance-observations.md` session blocks written by post-change runs. Revert leaves any post-change session blocks with the extra line intact, but those are append-only historical records — stale subtotal lines in past blocks don't break anything (the file's own intro at line 16 says "Do not hand-edit prior session blocks").
- No state propagates beyond the local repo by this change (no push, no external API, no Notion write triggered by `/friday-act` Step 3 / 3.5).

### Dimension 5: Hidden Coupling
**Risk:** Low

- The risk→letter mapping (HIGH→f, MED→d, LOW→s) is a new convention internal to the command. It is documented at the change site (Step 3 prompt + per-item mapping table per change description). No silent reliance on an undocumented convention.
- The override path uses the same `{f,d,s}+` paste shape the command already validates today (line 142: "Validate length matches item count and characters are in `{f,d,s}`"). Override = same code path; no second validator.
- No auto-fire in unexpected contexts — operator still confirms (Enter or paste). The change reduces friction at an existing checkpoint; it does not add a new silent mutation.
- `triage_source` is new but it is a single optional field on an in-memory struct consumed only by Step 5 logging in the same file. Not exported to other commands.
- One mild caveat to note (not risk-elevating): the default mapping (HIGH→f, MED→d, LOW→s) is a more conservative default than the rule sketched in `logs/decisions.md` Item 10 referenced by `logs/session-plan-S8.md` line 38 ("HIGH=f, MED=f unless duplicate/low-value, LOW=d unless decision/chain-blocking, then f"). Change description chose the simpler risk-only mapping. This is a design choice, not a coupling risk — but the operator should be aware the default will route fewer MED items to `f` than the original sketch contemplated, meaning more operator overrides on MED items if the original sketch reflects actual practice.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references to `friday-act.md` lines 118–270, `friday-journal.md` line 319/326, `fix-repo-issues.md` line 278, `maintenance-observations.md` line 16, `logs/session-plan-S8.md` lines 38/73, and grep counts across `ai-resources/.claude/`). No training-data fallback was used on fetch/read failures.
