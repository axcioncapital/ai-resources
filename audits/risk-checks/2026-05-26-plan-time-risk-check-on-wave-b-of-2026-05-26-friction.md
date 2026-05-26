# Risk Check — 2026-05-26

## Change

Plan-time risk-check on Wave B of 2026-05-26 friction-cleanup session.

**Proposed change:** Expand `/open-items` Step 1 friction-log filter rule (line 35 in `ai-resources/.claude/commands/open-items.md`) from a single-criterion exclusion (`Resolved:` field) to a three-criterion exclusion:
1. Has a `Resolved:` field with non-empty value (not `no`/`pending`) — existing behavior, unchanged
2. Has an inline `[FADING-GATE] verified` annotation on the entry — captures the annotation pattern used in 5 entries in today's Wave 0 + prior [FADING-GATE] sessions
3. Has a matching improvement-log entry with `Status: applied` + non-empty `Verified:` that references the friction-log entry's timestamp via `**Friction source:** friction-log <HH:MM>` or `friction-log <HH:MM>` text in the body — captures the existing improvement-log convention where applied+verified entries already back-reference their source friction entries

**Why:** Today's `/open-items` report surfaced 14 unresolved friction items, but at least 3 of those (the 2026-05-25 09:07/09:13/09:53 entries) are already applied+verified in improvement-log. They show up as unresolved because the friction-log doesn't use `Resolved:` markers. The plan reviewer (qc-pass) correctly flagged that introducing a new `Resolved:` convention to friction-log is premature; the cleaner fix is to teach `/open-items` to cross-check against improvement-log status. Also captures the [FADING-GATE] annotation pattern that today added 5 entries of.

**Touch surface:** One file, one line edit — `ai-resources/.claude/commands/open-items.md` line 35 (the friction-log row in the Step 1 source table). No other files. No new commands or hooks. No shared-state writes (the command is Read-only).

**Blast radius:**
- `/open-items` invocations only — no downstream command depends on `/open-items` output programmatically
- Output presentation only — no file mutations, no audit-cycle effects, no agent-tier changes
- Bounded scope: changes WHICH friction entries get surfaced, not WHAT the command does

**Reversibility:** Trivially reversible — revert the line. No dependent state created.

**Why running risk-check:** Approved session plan called for plan-time `/risk-check` on this wave. Wave B touches automation-of-judgment surface (friction-log filtering decides what's surfaced to the operator), even though it's a query-display command rather than a state-mutating one.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/open-items.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/friction-log.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md — exists

## Verdict

GO

**Summary:** Single-line edit to one source-table row in a read-only, on-demand slash command, with no permission, hook, or shared-state effects; both new exclusion criteria are grounded in conventions already present in the referenced files.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- `/open-items` is on-demand only — not auto-loaded. Evidence: `open-items.md:1-3` declares only `model: sonnet` frontmatter; no `SessionStart`/`PreToolUse`/`Stop` hook registration in the file.
- The edit is confined to one line in the Step 1 source table (`open-items.md:35`) — the command is read only when `/open-items` is explicitly invoked. No always-loaded `CLAUDE.md`, no `@import` chain, no subagent brief is touched. (Verified against workspace `CLAUDE.md` and `ai-resources/CLAUDE.md` — neither imports `open-items.md` nor mentions it as auto-loaded.)
- Per-invocation token delta from the rule expansion is on the order of ~30–60 tokens in command instructions (two added clauses + qualifying text), and the command runs on Sonnet, not Opus. No ongoing per-turn cost.
- Cross-check against existing context: the 2026-05-11 plan-time risk-check on `/open-items` itself reached the same conclusion ("command is invoked on demand … not auto-loaded", `audits/risk-checks/2026-05-11-open-items-command-and-symlinks.md:39`). The rule expansion does not change that posture.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `.claude/settings.json` or `.claude/settings.local.json` changes are part of this edit (CHANGE_DESCRIPTION explicitly: "One file, one line edit — `ai-resources/.claude/commands/open-items.md` line 35 … No other files").
- Command stays read-only: `open-items.md:31` already states "Use `Read` (and `Grep` where helpful) — do not write or edit any source file." The new criteria are evaluated by reading additional rows of `improvement-log.md`, which the command already reads (`open-items.md:38` — improvement-log is already a Step 1 source). No new tool family, no new path glob, no new external API.
- No `deny` rule narrowed or removed; no allow widened.

### Dimension 3: Blast Radius
**Risk:** Low

- Files touched directly: 1 (`ai-resources/.claude/commands/open-items.md`).
- Callers of `/open-items` (enumeration):
  - `ai-resources/.claude/commands/prime.md:118` — emits the literal string `Full backlog & inbox: /open-items` as advisory output. Does not parse `/open-items` output.
  - `ai-resources/.claude/commands/new-project.md:536, 545` — lists `open-items` in canonical command install set; does not parse output.
  - Various `audits/` and `audits/working/` files — historical/diagnostic references, not callers.
  - Total non-historical references: 3, none programmatic. No caller consumes the command's output as structured input.
- Contract surface affected: the change narrows which entries are surfaced (filter expansion), but the output shape (`### Unresolved friction` section with `<entry title> — [logs/friction-log.md]...` bullets per `open-items.md:59-60`) is unchanged. Backwards-compatible from any reader's perspective — items disappear from a free-text section, no schema change.
- No shared infrastructure touched: no hook, no log mutation, no `CLAUDE.md` edit, no scripts/.

### Dimension 4: Reversibility
**Risk:** Low

- One-line edit (CHANGE_DESCRIPTION: "Trivially reversible — revert the line. No dependent state created."). Verified: `open-items.md:35` is a single table-row line, no sibling files created.
- Command is read-only — no log entries, no archived state, no committed downstream artifacts are produced by `/open-items` runs in the window between landing and a potential revert. Verified: `open-items.md:16` ("No file output").
- No automation (hook, cron, symlink) is added that could fire between landing and revert.
- Operator muscle-memory cost: the visible behavior change is "fewer items in the Unresolved friction section." Reverting reintroduces the prior items; no command name/flag changes, no learned workflow to unlearn.

### Dimension 5: Hidden Coupling
**Risk:** Low

- New parsing contract is named explicitly at the change site (CHANGE_DESCRIPTION enumerates the three criteria, including the exact match-text patterns `[FADING-GATE] verified` and `friction-log <HH:MM>`).
- Both new criteria are grounded in conventions already present in the referenced files:
  - `[FADING-GATE] verified` annotation: 6 occurrences confirmed in `friction-log.md` (grep count: `grep -c "FADING-GATE\] verified" friction-log.md` → 6). Lines 7, 8, 16, 25, 31, 47.
  - `Friction source: friction-log <HH:MM>` cross-reference: confirmed at `improvement-log.md:87` ("friction-log 09:07"), `:94` ("friction-log 09:13"), `:101` ("friction-log 09:53"), `:108` ("friction 09:07"), `:115` ("friction-log 09:13 ... 09:53"). The 3 example entries the change targets (09:07/09:13/09:53) all carry both `Status: applied` and a non-empty `Verified:` line (`improvement-log.md:85-89, 92-96, 99-103`).
- No silent auto-firing in unexpected contexts: command runs only on explicit `/open-items` invocation.
- No functional overlap with existing mechanisms: `/resolve-improvement-log` archives improvement-log entries on Status:applied+Verified; this change does not duplicate that — it consumes the same convention (read-only) to filter a *different* source file's display. The two mechanisms operate on different files with the same underlying signal; this is convergent, not overlapping.
- Minor implicit dependency: the third criterion assumes friction-log entries are timestamped `**HH:MM**` and improvement-log entries reference them as `friction-log HH:MM` or `friction-log <HH:MM>`. Both conventions are present today and named in the change. If a future friction-log entry omits the timestamp prefix, that entry won't qualify under criterion 3 (it can still qualify under criterion 1 or 2). Graceful degradation, no breakage.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references (`open-items.md:1-3, 16, 31, 35, 38, 59-60`; `friction-log.md` lines 7, 8, 16, 25, 31, 47; `improvement-log.md` lines 85-89, 92-96, 99-103, 108, 115), grep count (`grep -c "FADING-GATE\] verified" friction-log.md` → 6), enumerated caller references (`prime.md:118`, `new-project.md:536/545`), and cross-check against the prior `/open-items` plan-time risk-check (`audits/risk-checks/2026-05-11-open-items-command-and-symlinks.md:39`). No INCOMPLETE dimensions. No training-data fallback used.
