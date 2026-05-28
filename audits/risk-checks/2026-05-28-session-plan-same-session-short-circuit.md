# Risk Check — 2026-05-28

## Change

Edit `ai-resources/.claude/commands/session-plan.md` Step 0 — add same-session short-circuit using `logs/.prime-mtime` marker. New sub-step 0 checks if `PLAN_MTIME > PRIME_MTIME` → sets `SAME_SESSION = true`. Sub-step 6 override forces MATCH result regardless of intent comparison when `SAME_SESSION` is true. This bypasses the silent-auto-pass2 routing on the MISMATCH branch when a same-session re-invocation has a genuinely-different intent (operator pivot mid-session). Edit is purely additive — sub-steps 1–5 unchanged, sub-step 6 MISMATCH path still active for foreign sessions. Affects: same-session re-invocation handling. Reverse impact: if `.prime-mtime` is missing or marker is unreliable, `SAME_SESSION = false` and fall-through to existing logic — no regression.

## Referenced files

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-plan.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-start.md` — exists
- `logs/.prime-mtime` — runtime artifact (per-session, gitignored, created by `/prime` Step 8a.3.a / 8b.1 / 8c.3)

## Verdict

**GO**

**Summary:** Additive same-session marker check inside an existing command file; the marker contract is already an established cross-command convention, the fall-through behavior on marker absence preserves prior semantics, and no other reader is affected.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The edit modifies `session-plan.md`, an on-demand operator-invoked slash command — not always-loaded content. Token cost is paid only when `/session-plan` is invoked, not per session or per turn.
- No SessionStart / Stop / PreToolUse / UserPromptSubmit hook is added; no `@import` chain is introduced; no skill description is broadened.
- The inserted body adds ~9 lines of sub-step 0 logic (lines 21–29 of `session-plan.md`) plus a ~3-line override paragraph (lines 39–40), inside a command that is invoked at most a handful of times per session. Marginal per-invocation cost is small and bounded.
- No subagent brief expansion; no new resource auto-loaded from elsewhere.

### Dimension 2: Permissions Surface
**Risk:** Low

- No change to any `.claude/settings.json`, `.claude/settings.local.json`, allow/ask/deny lists.
- The change uses `stat -f %m` / `stat -c %Y` and file reads that already exist in this command (sub-step `## Step 0` line 17 explicitly invokes `stat -f %m` / `stat -c %Y` / `date -r`) — no new tool family introduced.
- No new external API, MCP server, or cross-repo write.

### Dimension 3: Blast Radius
**Risk:** Low

- Single file edited: `ai-resources/.claude/commands/session-plan.md`.
- Marker contract (`logs/.prime-mtime`) is **read-only** in the new code: the edit consumes the marker, it does not write or rename it. The writer (`/prime` Step 8a.3.a / 8b.1 / 8c.3, evidenced in `prime.md` lines 152–157, 170–175, 188–193) is unchanged.
- Existing marker consumers enumerated via grep (`grep -rn "\.prime-mtime"` across the workspace):
  - `/prime` (writer; 3 paths — 8a.3.a, 8b.1, 8c.3) — not affected.
  - `/session-start` Step 0.5 (reader; `session-start.md` lines 51–56) — not affected; the new code consumes the same marker but does not alter it.
  - Workspace-root `.claude/commands/wrap-session.md` Step 1.5 (reader; lines 43–52) — not affected; consumes marker independently.
  - Canonical `ai-resources/.claude/commands/wrap-session.md` Step 3.5 (reader; lines 76–129) — not affected; same as above.
  - `projects/repo-documentation/output/phase-1/risk-topology.md` and vault copy — documentation only, not executable consumers.
- Contract shape: the marker is an integer epoch string. The new code reads it identically to existing consumers (`stat -f %m` then numeric compare). No contract change introduced.
- `/drift-check` (`drift-check.md` lines 18–48) reads `logs/session-plan.md` and `logs/session-notes.md` but does NOT consume `.prime-mtime`. The Known-debt note at `session-plan.md` line 63 mentions `/drift-check` would use prior session's plan as baseline on auto-pass2; the new override **reduces** that risk by surfacing the 3-option prompt instead of silently routing to pass2 — same-direction effect, no new drift-check coupling.
- Other consumers of `session-plan.md` as a file (e.g., `/decide`, `/open-items`, `/contract-check`, `/drift-check`) read the file's schema headers (`## Intent`, etc.); they do not read Step 0 logic. The schema is untouched.

### Dimension 4: Reversibility
**Risk:** Low

- Single-file textual edit in a command markdown file. `git revert` (or `git checkout HEAD~1 -- session-plan.md`) restores prior content fully.
- No log entries, registry rows, or sibling files created by the edit itself. The `.prime-mtime` marker is a per-session runtime artifact and is gitignored — reverting the command does not require touching it.
- No external write (no Notion push, no git push, no API POST). Local working tree is the only state changed.
- No automation / hook / cron / symlink added that could fire between the edit landing and a potential revert.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The marker contract (`.prime-mtime` is an epoch string written after the today-header append) is **explicitly documented** at the change site: sub-step 0 names the writer (`/prime Step 8a.3.a / 8b.1 / 8c.3`) verbatim. No undocumented assumption.
- The new code's fall-through behavior on marker absence (`SAME_SESSION = false` → existing logic runs) is named explicitly at line 23 — safe degradation is documented, not implicit.
- No silent auto-fire — the override only changes behavior inside a code path that already requires `/session-plan` to be invoked AND a prior plan to exist within 6 hours. No new context where the override could fire unexpectedly.
- No functional overlap with another mechanism: the override **closes** a documented gap (the Known-debt note at line 63 acknowledges the silent-auto-pass2 problem), it does not duplicate an existing check. `/session-start` Step 0.5 uses the same marker for a different question (foreign mandate write detection); these checks ask different questions over the same marker without conflict.
- The change uses the marker's existing semantics ("this session's `/prime` ran at T") without inventing a new interpretation. Reusing the existing contract — not extending it.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: verbatim quotes from `session-plan.md` lines 17, 21–29, 39–40, 63; `prime.md` lines 152–157, 170–175, 188–193; `session-start.md` lines 51–56; workspace-root `wrap-session.md` lines 43–52; canonical `wrap-session.md` lines 76–129; `drift-check.md` lines 18–48. Grep counts produced via `grep -rn "\.prime-mtime"` across the workspace (28+ documentation references, 4 executable consumers identified). No training-data fallback used.
