# Session Plan — 2026-05-27

## Intent
Fix the friction-log misclassification rule in `ai-resources/CLAUDE.md` so `/session-plan` re-invocations stop being recorded as hook events in `logs/friction-log.md`.

## Class
execution

## Model
sonnet — → /model sonnet  (active session is `claude-opus-4-7[1m]`; recommended tier for this work is sonnet — mechanical CLAUDE.md edit after a bounded investigation)

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/CLAUDE.md` — fix target (always-loaded; locate the misclassification rule)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/friction-log.md` — evidence of the 3 misclassification incidents (read recent entries to identify the misfiring pattern)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friction-log.md` — the `/friction-log` slash command (defines what gets recorded)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/friction-log-auto.sh` — the auto-capture hook (likely source of the "hook event" recording)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` — structural-change-class reference (CLAUDE.md edit is an always-loaded change → `/risk-check` may apply)

## Findings / Items to Address
(none — intent does not reference a prior report; the 3 incidents are documented in `logs/friction-log.md` itself, to be read in Step 1 below)

## Execution Sequence
1. **Diagnose the misclassification.** Read recent entries in `logs/friction-log.md` to identify the 3 incidents where `/session-plan` re-invocations were recorded as hook events. Capture the exact entry pattern (header form, classification label) so the fix targets the right rule. Verify: at least one concrete entry pattern documented before proceeding.
2. **Locate the governing rule.** Read `ai-resources/CLAUDE.md` and `.claude/commands/friction-log.md` and `.claude/hooks/friction-log-auto.sh` to identify which rule produces the "hook event" classification for `/session-plan` re-invocations. Verify: the misclassifying rule is named (line number / section) before proceeding.
3. **Run `/risk-check` (plan-time gate).** CLAUDE.md is always-loaded; even a small rule edit qualifies under the audit-discipline change-class list. Run the gate, capture the verdict + any mitigations, only proceed if `GO` or `PROCEED-WITH-CAUTION`.
4. **Apply the fix.** Edit `ai-resources/CLAUDE.md` (or the secondary surface identified in Step 2, if the governing rule lives in the command/hook). Edit must be the minimum change that excludes `/session-plan` re-invocations from the "hook event" classification without breaking the broader friction-log capture. Verify: edit is byte-minimal, single-rule scope.
5. **Run `/qc-pass` on the edit.** Verify: the edited rule no longer matches `/session-plan` re-invocations; the rule still correctly catches the cases it was originally written for.
6. **Wrap.** Commit, annotate the source improvement-log entry if one exists, prompt operator for `/wrap-session`.

## Scope Alternatives
Single scope — no alternatives. The operator framed this as a small fix; the four sequence steps are mandatory and there is no "stretch" or "minimal" variant. If Step 2 reveals the fix surface is NOT `CLAUDE.md` but a command or hook, that is a fact-correction within the same scope (not a scope expansion).

## Autonomy Posture
Full autonomy.

**Stop points:**
- After Step 2 diagnosis if the fix surface turns out to be something other than `CLAUDE.md` (operator stated the fix is in `CLAUDE.md`; a fact-correction here is a load-bearing assumption-gate issue) — surface the finding, recommend the corrected surface, proceed unless operator overrides.
- After Step 3 `/risk-check` if verdict is `STOP` or `REVISIT-SCOPE`.

## Risk
The edit touches `ai-resources/CLAUDE.md`, which is always-loaded into every session in this repo. Per `docs/audit-discipline.md`, cross-cutting CLAUDE.md edits are a structural change class.

Run `/risk-check` after the plan is approved (plan-time gate). Run it again before commit (end-time gate) — unless the skip criteria in memory `feedback_end_time_risk_check_skip` apply (plan-time gate covered with mitigations applied AND drift bounded AND QC-clean), in which case document the skip in the wrap note.
