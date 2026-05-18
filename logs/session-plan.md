# Session Plan — 2026-05-18

## Intent
Implement nordic-pe Findings 2–7 — skill/command-level fixes to ai-resources canonical files and one project-local addition; F2/F3/F5/F6 require plan-time `/risk-check` before edits.

## Class
execution

## Model
sonnet — match

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-plan.md` (target of F2, F3, F6)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/auto-sync-shared.sh` (target of F5)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/.claude/hooks/` (new hook location for F4)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/CLAUDE.md` (target of F7)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md` (source of findings)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` (structural change classes)

## Findings / Items to Address

Source doc: `projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md` (entries dated 2026-05-16)

1. **F2 — /session-plan Step 0 mid-session re-invocation guard.** Edit Step 0 in `ai-resources/.claude/commands/session-plan.md`: after the date-header check, also check whether `logs/session-plan.md` exists AND was modified within the last 6 hours. If yes, emit a prompt listing the existing plan's intent and three options (keep / overwrite / write to pass2). Default on no response: option 3.
2. **F3 — /session-plan Step 1 stale Next Steps freshness check.** Edit Step 1 in `ai-resources/.claude/commands/session-plan.md`: replace `"Inferred intent: {INTENT}"` with a variant that includes the source-file last-modified timestamp and offers `"continue"` to keep the existing plan.
3. **F4 — Project-local session-plan backup hook.** Create `projects/nordic-pe-macro-landscape-H1-2026/.claude/hooks/backup-session-plan.sh` (PreToolUse Write) that copies prior `logs/session-plan.md` to `logs/.session-plan-history/YYYY-MM-DD-HHMM.md` before each new write. Wire into project's `.claude/settings.json` PreToolUse Write matcher.
4. **F5 — auto-sync-shared.sh drift-reconciliation mode.** Edit `ai-resources/.claude/hooks/auto-sync-shared.sh`: for each command/agent target that already exists AND is a regular file (not a symlink), compute `diff` against the source. If different, emit SessionStart `additionalContext` warning. Do NOT auto-replace.
5. **F6 — /session-plan Step 7 duplicate Class: fix.** Edit Step 7 in `ai-resources/.claude/commands/session-plan.md`: before inserting `Class: {CLASS}`, check whether a `Class: ` line already exists under today's header — replace value instead of inserting a duplicate.
6. **F7 — Chapter review presentation rule.** Add one-line rule to `projects/nordic-pe-macro-landscape-H1-2026/CLAUDE.md` under a "Review Presentation" section: "Chapter and section reviews surface only QC verdict, score, and file path — never paste full prose inline."

## Execution Sequence

1. **/risk-check pass A — combined session-plan.md edits (F2 + F3 + F6).** All three findings touch the same canonical command file. Single combined risk-check covers all three. Wait for verdict GO before proceeding. Verification: GO verdict file written under `audits/risk-checks/`.
2. **Implement F2 + F3 + F6 in one edit pass on `session-plan.md`.** Verification: file passes a self-read showing all three changes in expected sections (Step 0, Step 1, Step 7).
3. **Commit F2+F3+F6** with message `update: session-plan command — re-invocation guard + stale intent freshness check + duplicate Class fix (nordic-pe F2/F3/F6)`.
4. **/risk-check pass B — F5 + F4 combined.** F5 edits `auto-sync-shared.sh` (canonical shared hook); F4 creates a new project-local hook and wires `settings.json` PreToolUse Write. Both are risk-check change classes per `audit-discipline.md`. Single combined risk-check covers both. Wait for verdict before proceeding. Verification: GO/PROCEED-WITH-CAUTION verdict file written under `audits/risk-checks/`.
5. **Implement F5 in auto-sync-shared.sh.** Verification: shellcheck-clean; manual sanity test on one project — SessionStart `additionalContext` emits on drift, no auto-replace.
6. **Commit F5** with message `update: auto-sync-shared hook — drift-reconciliation warning mode (nordic-pe F5)`.
7. **Implement F4 — new backup-session-plan.sh hook in nordic-pe project.** Create hook script, make executable, wire into project's `.claude/settings.json` PreToolUse Write matcher scoped to `logs/session-plan.md` path only. Verification: script exists, executable bit set, settings.json validates as JSON, matcher pattern restricts to `logs/session-plan.md` (not a blanket Write catcher).
8. **Commit F4** with message `new: backup-session-plan hook (nordic-pe F4)`.
9. **Implement F7 — one-line rule in nordic-pe CLAUDE.md.** Verification: rule present under named section.
10. **Commit F7** with message `update: nordic-pe CLAUDE.md — chapter review presentation rule (nordic-pe F7)`.
11. **Update improvement-log.md** — mark all six entries `applied 2026-05-18` with brief change-applied notes; commit.
12. **End-time /risk-check skip evaluation.** Apply skip rule (plan-time covered + commits shipped + drift bounded) per memory `feedback_end_time_risk_check_skip`. Document skip or run gate.

## Scope Alternatives

- **Min:** F2 + F3 + F6 only (one file, one risk-check, one commit). Defers F4, F5, F7 to next session. Use if /risk-check pass A reveals unexpected complexity.
- **Recommended:** All six findings (F2–F7) in two risk-check passes and four commits.
- **Max:** Recommended + push all unpushed repos at end (requires operator approval per Autonomy Rule #2).

## Autonomy Posture

Gated.

**Stop points:**
- After /risk-check pass A verdict — pause if RECONSIDER; apply mitigations listed in report if PROCEED-WITH-CAUTION
- After /risk-check pass B verdict — pause if RECONSIDER; apply mitigations if PROCEED-WITH-CAUTION
- End-of-session — pause for push approval (Autonomy Rule #2)

## Risk

Run `/risk-check` after this plan is approved — two plan-time gates (pass A: combined F2+F3+F6 on session-plan.md; pass B: combined F5 on auto-sync-shared.sh + F4 new hook/settings.json). End-time gate evaluated per skip rule.

**F7:** No /risk-check required — single-line additive CLAUDE.md rule, project-local scope.

**F4 — [CONFLICT]:** Operator directive (session mandate) says F4 does not require plan-time /risk-check. However, F4 creates a new hook script and wires a PreToolUse Write entry into `.claude/settings.json` — both are risk-check change classes per `audit-discipline.md` (hook edits + settings.json edits). Resolution options: (a) extend pass B to cover F4 alongside F5 (recommended — one additional risk-check, minimal overhead), or (b) operator confirms the F4 carve-out explicitly and the plan proceeds as written. Proceeding with option (a) as the safer default; operator can correct before execution starts.
