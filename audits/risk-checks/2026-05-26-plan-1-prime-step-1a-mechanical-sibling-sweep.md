# Risk Check — 2026-05-26

## Change

Plan 1 — Replace the prose "Sibling-entry sweep" paragraph in /prime Step 1a with a discrete bash sub-step: `SIBLING_COUNT=$(grep -c "^## ${TODAY}" logs/session-notes.md 2>/dev/null || echo 0)`. Collapse the existing prose paragraph to a single explanatory line below the bash block. The Step 6 emission contract for the sibling-entry warning is preserved verbatim. Target: ai-resources/.claude/commands/prime.md. Full plan: ai-resources/plans/prime-step-1a-sibling-sweep.md with pre-filled risk-check brief.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/prime-step-1a-sibling-sweep.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/session-notes.md — exists

## Verdict

GO

**Summary:** Bounded prose-to-bash substitution inside one Step 1a sub-paragraph of `/prime`; no permission surface change, no callers affected, the Step 6 emission contract is preserved verbatim, and `git revert` of the single edit fully restores prior state.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The edit lives in `.claude/commands/prime.md` — a slash-command file that is loaded only when `/prime` is invoked at session start. It is not in workspace or repo `CLAUDE.md`, so no always-loaded token cost (verified: `prime.md` is under `.claude/commands/`, not referenced by `@import` in either CLAUDE.md).
- The change replaces a ~3-line prose paragraph (prime.md:50–51) with a ~4-line bash block plus a ~1-line collapsed explanatory sentence (plans/prime-step-1a-sibling-sweep.md:38–52). Net delta is small — on the order of +2–4 lines / ~30–60 tokens in a command file whose current size is 149 lines (verified via `wc -l`).
- Per-invocation runtime cost is one additional `grep -c` over `logs/session-notes.md`, which the file's Step 1 already reads. Output is a single integer. Negligible.

### Dimension 2: Permissions Surface
**Risk:** Low

- The bash command uses `grep -c` and `date`. Repo settings already declare `"Bash(*)"` in `.claude/settings.json` (verified: `grep -E "Bash\(\*" .claude/settings.json` returns `"Bash(*)"`). No new tool family, no glob widening, no deny-rule changes.
- No change to any settings file is part of this plan.

### Dimension 3: Blast Radius
**Risk:** Low

- Files touched directly: 1 (`.claude/commands/prime.md`). The plan is explicit that "other Step 1a content unchanged" (plan §Risk-check brief).
- Callers of `/prime`: enumeration via `grep -rln "/prime\b\|prime\.md" --include="*.md"` returned ~30 hits, but inspection shows these are documentation/log references (audits, plans, friction-log, session-notes), not orchestrating callers. `/prime` is a session-start command invoked by the operator, not chained by other slash-commands.
- Callers of the sibling-entry contract (`sibling-entry`, `same-day entries`, `parallel wraps possible`, `SIBLING_COUNT`): `grep -rln` returned 10 hits across plans, audits, command files, and logs. The only command-file consumer is `drift-check.md:28`, which has its own independent "multiple same-day entries — isolation rule" logic over `session-notes.md` + `session-plan.md` cross-check; it does not parse `/prime`'s emitted warning. The contract surface is therefore one producer (`/prime` Step 6) with no parsing consumer.
- Contract preserved: the Step 6 emission line is unchanged (plan acceptance criterion #3; verbatim quoted in prime.md:50–51 and re-quoted in the plan §Implementation). No downstream caller requires modification.

### Dimension 4: Reversibility
**Risk:** Low

- Single-file `Edit` to `prime.md`. `git revert` of the commit fully restores the prior prose paragraph in the same working tree — no sibling files, no log mutations, no settings changes, no external writes.
- No automation registered (no hook, cron, or symlink added). The change is text inside an on-demand command.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The new bash block depends on the existing `## YYYY-MM-DD` header convention in `logs/session-notes.md`. This convention is already load-bearing for the prose version of the same sweep (prime.md:50) and for Step 8a's "Do NOT create a second same-day header" rule (prime.md:137) — it is not a new implicit dependency.
- The `grep -c "^## ${TODAY}"` pattern matches both bare `## 2026-05-26` headers and the dash-suffixed form `## 2026-05-26 — Title` (verified live: returns 4 matches in current `session-notes.md`, including both bare and titled forms). This matches the prose intent ("Scan for additional `## <source-entry-date>` headers").
- No new contract introduced — the Step 6 emission line is the same as before. The bash count is an internal mechanical aid for setting the existing flag; no downstream consumer reads `SIBLING_COUNT` directly.
- No functional overlap with `/drift-check`'s same-day isolation rule — drift-check operates on `session-notes.md` + `session-plan.md` mandate cross-check, not on `/prime`'s warning emission.
- Minor implicit dependency worth noting: the bash uses bare `logs/session-notes.md` (relative path), which assumes `/prime` runs from the repo root containing `logs/`. The existing Step 1 prose already makes the same assumption (prime.md:30), so this is parity with current behavior, not a new coupling.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references in `prime.md` (lines 30, 50–51, 137), `drift-check.md` (line 28), `.claude/settings.json` (the `"Bash(*)"` entry), the plan file's Implementation and Risk-check brief sections, `wc -l` baseline (149 lines), and live grep of `^## 2026-05-26` against `session-notes.md` (4 matches confirming the pattern works). No training-data fallback used.
