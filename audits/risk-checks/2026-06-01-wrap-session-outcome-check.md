# Risk Check — 2026-06-01

## Change

Plan-time gate for: adding a "did Claude do the job, and do it well?" outcome check to /wrap-session. Single-file change to the canonical command ai-resources/.claude/commands/wrap-session.md: (1) add a 4th opt-in preflight toggle ("Session outcome check") and extend the shorthand parser to four items (incl. a legacy clause: existing "yy"/"nn" covers items 1-2 and re-asks 3-4, no silent default); (2) add a new gated Step 6.4 (placed before the existing Step 6.5 feedback collection) that — when toggled on and the session is non-trivial — resolves the session mandate via /contract-check's existing priority chain (frozen contract -> session-plan -> session-notes mandate block -> fallback to the session's stated task with a low-confidence label), then spawns a FRESH-CONTEXT general-purpose subagent with an INLINE brief (mirroring contract-check.md Step 4 — NO new named agent file) that judges two dimensions and returns <=20 lines: COMPLETION (DELIVERED/PARTIAL/MISSED) and EXECUTION quality (OPTIMAL/ACCEPTABLE/SUBOPTIMAL, with a load-bearing evidence guard — SUBOPTIMAL must cite concrete evidence else default ACCEPTABLE); the subagent may inspect actual changed files / today's git log to verify the self-authored note; (3) the wrap writes the returned verdict as an "### Outcome" block into today's session-notes.md entry (after ### Decisions Made, before ### Risky actions); (4) update the Step 4 note-schema bullet list to document the new ### Outcome block; (5) revise the cost-budget note to reflect both optional subagent steps (~4-8 combined). Advisory only — neither COMPLETION:MISSED nor EXECUTION:SUBOPTIMAL blocks the commit or push. NO new agent file, NO new log, NO new data store, NO staging-list change (session-notes.md is already always-staged and already wrap-authored). Canonical wrap-session.md is symlinked by ~16 project copies (auto-propagates). The workspace-root non-symlink copy is NOT edited (deferred, tracked in improvement-log).

Design properties relevant to risk:
- The only file written by the new step is session-notes.md, which the wrap ALREADY authors (Step 4) — this is not a new shared-state writer to a previously-untouched log (contrast the just-shipped feedback collector, which added writers to friction-log/improvement-log).
- No new agent definition; reuses contract-check.md's inline general-purpose subagent pattern and its Step 2 mandate-resolution chain (referenced, not duplicated).
- Advisory, opt-in (4th preflight toggle), never blocks.
- This is the second feature added to wrap-session in the same session; the first (feedback collector, commit d2cc3cd) added Step 6.5 + a 3rd toggle. Step 6.4 sits immediately before 6.5.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/contract-check.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/session-notes.md — exists

## Verdict

GO

**Summary:** A self-contained, advisory, opt-in addition to a command the operator already gates per-session, writing only to a log the wrap already authors and reusing an existing subagent pattern — no permission, blast-radius, or coupling concern rises above Low except a single Medium per-session token cost that is opt-in and bounded.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- The new content lives in `wrap-session.md`, which is a slash command, not an always-loaded file — it loads only when `/wrap-session` is invoked, not on every turn. No CLAUDE.md / `@import` / SessionStart-hook cost is added. Evidence: file is at `.claude/commands/wrap-session.md` with `model: sonnet` frontmatter (wrap-session.md:1-3); it is operator-invoked, not auto-loaded.
- When toggled ON in a non-trivial session, Step 6.4 spawns one fresh-context subagent that reads the mandate + may inspect changed files / today's git log. The CHANGE_DESCRIPTION revises the cost note to "~4-8 combined" tool calls for both optional subagent steps. The existing budget note already accounts for Step 6.5 ("add ~2–4 when Step 6.5 feedback collection runs", wrap-session.md:13); adding a second optional subagent roughly doubles the optional-pass overhead.
- The cost is per-session and gated behind the 4th preflight toggle (operator opt-in each wrap) and a trivial-session skip — it is not incurred unless explicitly enabled. This is pay-as-used, not always-on, which would normally read Low. Rated Medium because, unlike a purely on-demand command, this rides inside a command the operator runs at the end of essentially every session, so the marginal subagent spawn is offered routinely rather than rarely.
- No skill description / broad trigger keyword is added; no frequently-spawned named subagent brief is expanded (the brief is inline and only materializes when toggled).

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json` / `settings.local.json` change is described. CHANGE_DESCRIPTION explicitly states "NO new agent file, NO new log, NO new data store, NO staging-list change."
- The spawned subagent uses the general-purpose Task capability and Read/Bash(git log)/Read-changed-files — the same capability surface `/contract-check` already exercises (contract-check.md:5 `allowed-tools: Bash(git *), Read, Task`; Step 4 spawns a general-purpose subagent, contract-check.md:114). No new tool family or external API is introduced.
- session-notes.md is already in the wrap's always-staged list (wrap-session.md:309) and already wrap-authored (Step 4, wrap-session.md:244) — no new write target or staging widening.

### Dimension 3: Blast Radius
**Risk:** Low

- Direct files touched: 1 (`wrap-session.md`). The workspace-root non-symlink copy is explicitly NOT edited (deferred, tracked in improvement-log) — consistent with the existing MIRROR NOTE deferral for the Step 6.5 feature (wrap-session.md:258-261).
- Symlink propagation enumerated: `find … -name wrap-session.md -type l` returns 16 symlinks; all readlink targets resolve to the canonical `ai-resources/.claude/commands/wrap-session.md`. Editing canonical auto-propagates to all 16. Non-symlink copies: 3 total `wrap-session.md` files; the two non-symlinks are the workspace-root copy and `workflows/research-workflow/.claude/commands/wrap-session.md` — the workspace-root one is the named deferred copy.
- New contract introduced: an `### Outcome` block in today's session-notes entry, placed after `### Decisions Made`, before `### Risky actions`. Checked all session-notes consumers for a positional/section-name collision: `grep -rln "### Outcome"` returns zero existing uses — no name clash. `/open-items` keys on the `Open Questions` section only (open-items.md:40); `/prime` extracts summary / next steps / open questions (prime.md:30) — none parse the `Decisions Made → Risky actions` interval positionally, so an inserted block between them does not displace a field any consumer reads. The wrap's own foreign-session detector keys on `^## YYYY-MM-DD` headers and `^**Mandate:**` lines (wrap-session.md:65-73) — neither signal is a `### ` subheading, so the new block does not perturb the guard's counts.
- The Step 6.5 feedback collector inserts its `### Session Assessment` block after `### Risky actions`, before `### Next Steps` (wrap-session.md:270). The new `### Outcome` block sits earlier (after Decisions Made, before Risky actions), so the two additive blocks do not contend for the same anchor.
- Contract change is backwards-compatible and additive (new optional section; no removed/renamed field). Reference scan context: 209 markdown files mention `wrap-session`, 34 mention `contract-check` — but these are documentation cross-references, not parsers of the new block; no caller requires modification to keep working.

### Dimension 4: Reversibility
**Risk:** Low

- The command edit is a single-file change; `git revert` of the wrap-session.md commit fully restores the prior command, and the symlinks auto-track the reverted canonical file (no per-symlink cleanup).
- The only runtime side effect is an `### Outcome` block appended inside a session-notes entry the wrap already creates in the same commit — reverting the command before the next wrap leaves no orphaned writer. Any Outcome blocks written by intervening wraps are ordinary append-only log content (advisory text), not state other tooling depends on; they carry forward harmlessly, the same way `### Session Assessment` blocks already do.
- No automation fires between landing and revert (no hook/cron/symlink registration added). No state propagates beyond git (no push/external write introduced by the change itself).
- Distinct from the just-shipped feedback collector, this adds NO new writer to a previously-untouched log — so there is not even the one-extra-cleanup-step (stale friction/improvement-log entries) that would have pushed a log-mutating change to Medium.

### Dimension 5: Hidden Coupling
**Risk:** Low

- Implicit dependency on `/contract-check`'s Step 2 mandate-resolution chain (frozen-contract → session-plan → session-notes mandate block → fallback). This dependency is real but documented at the change site: the CHANGE_DESCRIPTION says it resolves "via /contract-check's existing priority chain … (referenced, not duplicated)." The chain itself is verifiable at contract-check.md:48-77. Coupling is to a stable, documented, in-repo convention, not a silent one. The fallback ("session's stated task with a low-confidence label") means the step degrades gracefully when no contract resolves rather than failing.
- The inline subagent brief mirrors contract-check.md Step 4 (contract-check.md:114-172) rather than introducing a new contract shape — the fresh-context, no-conversation-view, return-<=N-lines pattern is the established one.
- Functional-overlap check: the new Step 6.4 (COMPLETION + EXECUTION judgment) and the existing Step 6.5 feedback collector (per-session signals routed to friction/improvement logs) judge different things and write different blocks (`### Outcome` vs `### Session Assessment`) at different anchors — no two-systems-handling-the-same-concern overlap. Both are independently gated.
- The `### Outcome` block is a new convention callers would need to honor IF they parsed it; the change documents it in the Step 4 note-schema bullet list (CHANGE_DESCRIPTION item 4), satisfying the "documented at the change site" bar. No current consumer parses it (grep: zero existing `### Outcome` references), so no honor-the-contract obligation is created downstream today.
- The EXECUTION evidence guard (SUBOPTIMAL must cite concrete evidence else default ACCEPTABLE) is a self-contained mitigation against ungrounded negative verdicts, reducing the risk of a misleading advisory.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.
