# Session Plan — 2026-05-25 (pass4)

> Pass4 used because `session-plan.md` (15:00, concurrent session — diagnostic backlog Wave 1), `session-plan-pass2.md` (14:15, concurrent session #1), and `session-plan-pass3.md` (14:32, just-wrapped diagnostic backlog wave) are all held by today's concurrent or just-closed sessions. Pass4 preserves all three.

## Intent
SF1 broad — eliminate main↔subagent file-read duplication across the 5 remaining workflows identified in the 2026-05-25 token-audit set (axcion-ai-system-owner R1: `/consult`, `/architecture-review`, `/systems-review`; ai-resources `/friday-act` FA1+FA2; ai-development-lab `/analyze-transcript` AT1).

## Class
execution

## Model
sonnet — → /model sonnet (active model is `claude-opus-4-7[1m]`; mechanical edits per defined audit specs do not need Opus tier)

## Source Material

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/token-audit-2026-05-25-ai-resources.md` — FA1, FA2 findings + R1 implementation block (search "FA1", "FA2")
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/token-audit-2026-05-25-project-axcion-ai-system-owner.md` — CON2, AR1, SR1 findings + R1 implementation block (search "R1", line ~296)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/token-audit-2026-05-25-project-ai-development-lab.md` — AT1 finding + R2 implementation block (search "AT1", line ~108 + line ~259)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/CLAUDE.md` — § Subagent Contracts (30-line summary cap, notes-to-disk, brief-by-path convention)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` — § Risk-check change classes (gate-class lookup for commands-edit)

**Files to edit (5 workflows):**
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-act.md` — Step 16a (FA1 + FA2)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/.claude/commands/consult.md` — CON2
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/.claude/commands/architecture-review.md` — AR1
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/.claude/commands/systems-review.md` — SR1
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/.claude/commands/analyze-transcript.md` — AT1

## Findings / Items to Address

1. **R1.a — `/consult` (CON2)** — Source: SO audit line ~296. Main session reads reference file(s) at Step 3 (or Step 2) only to forward to the `system-owner` subagent that re-reads the same file per its Function B grounding map. **Fix:** Replace main Read with pass-by-path in the subagent brief — brief specifies the file path; subagent reads it directly.

2. **R1.b — `/architecture-review` (AR1)** — Source: SO audit line 236. Main session reads 2–4 large audit files (~16–27K tokens total) at Step 3, then re-embeds them verbatim in the Step 4 subagent brief. **Fix:** Remove main Reads; change Step 4 brief to reference files by path only.

3. **R1.c — `/systems-review` (SR1)** — Source: SO audit line 256. Step 2 reads `systems-thinking-for-claude-code.md` (401 lines, ~7,254 tokens) in main session as a presence check; subagent re-reads anyway. **Fix:** Replace main `Read` with `Glob` or `test -f` for existence check only.

4. **FA1+FA2 — `/friday-act` Step 16a** — Source: ai-resources audit lines 210–211. Step 16a reads SO Advisory + Systems Review full sections (~4,600 tokens) AND per-project `session-notes.md` + `friction-log.md` (~2,600–15,600 tokens) in main session as pure display-for-paste, no main-session reasoning. **Fix:** Delegate to a pre-summarizing subagent that writes to disk + returns ≤30-line summary (per Subagent Contracts).

5. **AT1 — `/analyze-transcript` Step 7** — Source: ai-development-lab audit line 108 + line ~259. Triple-touch on `repo-architecture.md` (252 lines / ~2,613 tokens): main reads it at Step 7b solely to embed verbatim into the Step 7d brief, AND the system-owner subagent independently reads the same file. **Fix:** (a) Remove the Step 7b main-session Read; (b) Change Step 7d brief to reference the file by path only.

## Execution Sequence

1. **Pre-flight `/risk-check` (plan-time gate)** — 5 commands across 3 projects + ai-resources is a multi-command-edit class. Run `/risk-check` on the bundled plan before any edits. Verification: GO verdict or PROCEED-WITH-CAUTION with mitigations applied.

2. **Switch model.** Run `/model sonnet` if Opus still active. Verification: model line in next response shows Sonnet.

3. **R1.c — `/systems-review` SR1** (smallest change first — single Read→Glob swap). Verification: file edit completed; grep confirms no `Read(systems-thinking-for-claude-code.md)` remains in main-session Step 2.

4. **Commit R1.c.** Single-file commit: `update: systems-review — SR1 main-session presence check switched to Glob`.

5. **R1.a — `/consult` CON2.** Apply pass-by-path. Verification: subagent brief now contains file path; no main-session Read of the same file.

6. **Commit R1.a.** Single-file commit.

7. **R1.b — `/architecture-review` AR1.** Apply pass-by-path to 2–4 audit files. Verification: main-session reads removed; brief contains paths only.

8. **Commit R1.b.**

9. **AT1 — `/analyze-transcript`.** Remove Step 7b main Read of `repo-architecture.md`; update Step 7d brief to reference by path. Verification: grep for `repo-architecture.md` in main-session steps returns nothing; brief contains path reference.

10. **Commit AT1.** Single-file commit.

11. **FA1+FA2 — `/friday-act` Step 16a** (largest change — adds a pre-summarizing subagent dispatch). May warrant its own `/risk-check` end-time gate if implementation diverges from audit spec. Verification: Step 16a no longer reads SO Advisory / Systems Review / per-project session-notes in main; new subagent writes summary to disk; main reads summary path only.

12. **Commit FA1+FA2.**

13. **End-time `/risk-check` (bundled)** — verify the 5-commit set against the original `/risk-check` plan-time scope. Skip per § End-time skip rule only if plan-time was GO with no mitigations AND no drift across the 5 commits. FA1+FA2 likely forces end-time gate to run regardless (new-subagent-dispatch class).

14. **`/wrap-session`.**

## Scope Alternatives

- **min** — Drop FA1+FA2 (largest, highest risk; introduces a new subagent dispatch). Ship the 4 quick-win edits only (R1.a/b/c + AT1). 4 commits, ~20 min.
- **recommended** — All 5 as sequenced above. 5 commits, ~40–55 min.
- **max** — All 5 + S3 convention codification (add a "brief-by-path-not-by-content" line to `projects/axcion-ai-system-owner/references/grounding.md` or `toolkit-relationship.md`, per audit recommendation lines 399–402). Adds 1 small docs commit.

Default if context becomes constrained mid-session: drop to **min**, defer FA1+FA2 to a follow-up session.

## Autonomy Posture
Gated

**Stop points:**
- Before edit #1 (after `/risk-check` plan-time gate completes — verify verdict and apply any mitigations)
- After each per-workflow commit (verify no regression in the just-touched file before moving to the next workflow — a 1-grep verification per finding is sufficient)
- Before FA1+FA2 implementation (largest change — confirm subagent dispatch design matches audit spec before writing)
- Before `/wrap-session` (run end-time `/risk-check` unless skip rule applies)

## Risk
Run `/risk-check` after this plan is approved (plan-time gate). Structural change classes touched: **multi-command edit across multiple scopes**, **new subagent dispatch (FA1+FA2)**. Run `/risk-check` again before commit for FA1+FA2 specifically (new-subagent class explicitly requires both gates per audit-discipline.md).

**Tripwire awareness:** AT1 edits `repo-architecture.md` reads — NOT edits to the file itself, so no shared-state-reorder concern. None of the planned edits touch `compaction-protocol.md` (the collision-risk file flagged in the prior session's scratchpad).
