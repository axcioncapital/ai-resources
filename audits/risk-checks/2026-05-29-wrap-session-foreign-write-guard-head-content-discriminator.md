# Risk Check — 2026-05-29

## Change

**Proposed change.** Add a HEAD-content discriminator to the Step 3 foreign-write guard in `ai-resources/.claude/commands/wrap-session.md` and its paired workspace-root copy at `.claude/commands/wrap-session.md`. Currently the `FOREIGN < 0` edge case (lines ~94-99, ~185 in ai-resources copy; ~130 in workspace-root copy) always logs a diagnostic chat note `"Note: prime-mtime marker present but expected own-content absent in WT — proceeding"` because the documented enumeration of causes misses the common case of mid-session commits shipping `logs/session-notes.md` to HEAD. The change:

1. Add ~4 bash lines after the FOREIGN-computation block: compute `OWN_CONTENT_IN_HEAD=1` when `HEAD_HEADERS >= 1` AND `HEAD_MANDATES >= 1`, else 0. Add `OWN_CONTENT_IN_HEAD=${OWN_CONTENT_IN_HEAD}` to the GUARD echo line for diagnostics.
2. Rewrite the edge-case paragraph: when `FOREIGN < 0` AND `OWN_CONTENT_IN_HEAD=1` → proceed silently with no chat note (the mid-session-commit case — common). When `FOREIGN < 0` AND `OWN_CONTENT_IN_HEAD=0` → proceed to Step 4 with a brief one-line note logging the discrepancy (plan-mode `/prime`, manual prune, or skipped `/session-start` — rare).
3. Update the documented cause enumeration in line 185 to add "mid-session commit shipped today's content to HEAD" as the 4th and primary cause.
4. Apply paired changes to workspace-root copy (`.claude/commands/wrap-session.md` ~line 130) — paired-contract files per the PAIRED CONTRACT block.

**Why.** The current edge case fires routinely (whenever a mid-session commit includes session-notes.md, which is common in active development), generating misleading chat noise about an abnormal state when the guard correctly determined no foreign-write risk exists. The documented cause enumeration is incomplete — none of the three listed causes match the common path.

**Functional safety.** The change only modifies the FOREIGN<0 path (which already proceeds silently to Step 4 in all cases). The foreign-write detection paths (FOREIGN >= 1 with CONCURRENT/REMNANT/MIXED branching) are untouched. Worst-case failure mode of the discriminator: false-silencing of a genuinely odd FOREIGN<0 state — we'd lose a diagnostic note but still proceed to Step 4 as today. No new foreign-content risk introduced.

**Scope.** Two paired files (ai-resources + workspace-root). ~10 lines bash + ~5 lines doc per file. No new subagents, no permission changes, no schema changes.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md — exists

## Verdict

GO

**Summary:** Tightly-scoped, evidence-grounded refinement of an existing edge-case branch — touches only the FOREIGN<0 silent-proceed path, introduces no new contracts or capabilities, and the paired-file sync is the only material consideration.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The change lands inside `/wrap-session` Step 3.5, an on-demand operator-invoked command — not auto-loaded into every session context. Confirmed by reading both copies: `wrap-session.md` is a slash-command file under `.claude/commands/`, not registered as a SessionStart / PreToolUse / Stop hook target. Evidence: `ai-resources/.claude/commands/wrap-session.md:1-3` is a YAML frontmatter for a slash command (`model: sonnet`); the workspace-root copy has no frontmatter and is invoked the same way.
- Per-invocation token cost adds ~4 bash lines (one int comparison + one echo extension) and ~5 lines of doc prose. Marginal cost per `/wrap-session` run is single-digit tokens. Frequency: ≤1 invocation per session. Verbatim from change description: *"~10 lines bash + ~5 lines doc per file. No new subagents, no permission changes, no schema changes."*
- No content added to always-loaded files (workspace CLAUDE.md, repo CLAUDE.md). Verified by reading both CLAUDE.md files in the system context — neither mentions the FOREIGN<0 path, nor does the change propose to.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow` / `ask` / `deny` entries added or modified — the change is purely a logic refinement inside an existing bash detector. Verbatim from change description: *"No new subagents, no permission changes, no schema changes."*
- The added bash uses only operators (`-ge`, `=`, `&&`) on shell variables already populated by existing detector lines (`HEAD_HEADERS`, `HEAD_MANDATES`). No new tool family invoked. Evidence: existing detector in `ai-resources/.claude/commands/wrap-session.md:65-71` already populates both variables via `git show HEAD:logs/session-notes.md | grep -c`.
- No settings-file scope change. The change touches only the two paired command files.

### Dimension 3: Blast Radius
**Risk:** Low

- Directly touches 2 files (paired copies). Enumeration:
  - `ai-resources/.claude/commands/wrap-session.md` line 185 (edge-case prose) and a ~4-line bash insertion before the GUARD echo at line 125.
  - `.claude/commands/wrap-session.md` line 130 (edge-case prose) and the same ~4-line bash insertion before the GUARD echo at line 84.
- Cross-repo references to `wrap-session`: 26 file matches via `grep -rln "wrap-session" --include="*.md" --include="*.sh"` across the workspace. Spot-checks of non-audit references (workspace CLAUDE.md, ai-resources CLAUDE.md, harness/prep/* docs, logs/* docs) confirm all are operator-facing invocation reminders ("run `/wrap-session` when done") or session-log entries — none parse the chat note text or depend on the FOREIGN<0 branch behavior.
- Cross-repo references to the diagnostic note text `prime-mtime marker present`: only 1 hit, the source line in `ai-resources/.claude/commands/wrap-session.md:185` itself. No external parser depends on the note's presence or wording. Evidence: `grep -rn "prime-mtime marker present" --include="*.md" --include="*.sh"` returned a single match.
- Cross-repo references to `FOREIGN < 0` / `OWN_CONTENT_IN_HEAD`: 2 hits, both inside risk-check audit reports (`audits/risk-checks/2026-05-28-wrap-session-step-3-5-concurrent-remnant-mixed-classifier.md:25` and the source line itself). No automation reads these names.
- No contract change. The detector's signature (FOREIGN_CLASS values, GUARD echo prefix, STOP message branches) is unchanged. The new `OWN_CONTENT_IN_HEAD` field is appended to the GUARD echo only — existing consumers (operator eyeballs) ignore unknown fields gracefully. Verbatim from change description: *"The foreign-write detection paths (FOREIGN >= 1 with CONCURRENT/REMNANT/MIXED branching) are untouched."*

### Dimension 4: Reversibility
**Risk:** Low

- Single-commit, single-pair edit. `git revert` of the commit fully restores prior behavior in both files. No sibling files created, no data/log mutations (the change does not touch `logs/`, `innovation-registry.md`, `decisions.md`, `session-notes.md`, archives, etc.). No settings.json change.
- No state propagated beyond the local repo (no automation auto-fires from the change site, no Notion/external write).
- No operator muscle memory cost — the only behavior-visible difference is *fewer* chat notes in the common path. Operators do not develop muscle memory around a diagnostic note's presence; reverting silently restores it.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The new `OWN_CONTENT_IN_HEAD` variable is computed from two variables already populated and consumed earlier in the same bash block (`HEAD_HEADERS` from `wrap-session.md:65`, `HEAD_MANDATES` from `wrap-session.md:71`). No silent dependency on a new source.
- The discriminator's semantics ("HEAD already has both today-header AND a mandate-line → this session's own content is in HEAD → FOREIGN<0 is the expected post-mid-session-commit state") aligns with the existing PAIRED CONTRACT block's documented signal model (header + mandate as the two independent signals). Evidence: ai-resources copy lines 50-52 list the same two signals; the new discriminator simply re-uses them in the HEAD direction.
- No new contract introduced for downstream consumers. The discriminator is internal to Step 3.5; STOP messages, FOREIGN_CLASS values, Step 4 entry conditions, and the `.prime-mtime` marker contract are unchanged.
- No functional overlap. `/session-start` Step 0.5 mtime guard (named in the PAIRED CONTRACT block) operates on a different signal (file mtime), not HEAD content — no double-handling of the same concern.
- Paired-file sync is an existing convention already enforced by the PAIRED CONTRACT comment block at canonical lines 41-45 and workspace-root lines 12-17. The change description explicitly names step 4 *"Apply paired changes to workspace-root copy..."*, so the sync requirement is acknowledged in the change itself rather than left implicit. Not a hidden coupling.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.
