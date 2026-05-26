# Risk Check — 2026-05-26

## Change

PLAN-TIME GATE. Planned settings.json edit: add two allow entries — `Write(./brand-book/00_foundation.md)` and `Edit(./brand-book/00_foundation.md)` — to `.claude/settings.json` allow list in the axcion-brand-book project. Purpose: unblock `/draft-module 00_foundation` Phase 1 v0.1 draft write, which is currently denied by the broad `Write(./brand-book/*.md)` + `Edit(./brand-book/*.md)` deny rules. The broad deny rules stay intact — only the single file (00_foundation.md) is lifted. Operator selected this option (Option A — minimal scope) via AskUserQuestion. Pattern parallels the prior session's permission refactor (2026-05-26 wrap entry `281ed32`) which lifted brand-book/_scoping/ and pipeline/module-status.md by enumerating allow lines. Reversibility: trivial (remove two lines). Blast radius: writes to one single file in one project. No hook, command, skill, symlink, CLAUDE.md, or shared-state automation touched.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-brand-book/.claude/settings.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-brand-book/brand-book/00_foundation.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-brand-book/brand-book/_scoping/ — exists (referenced as prior-pattern parallel)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-brand-book/pipeline/module-status.md — exists (referenced as prior-pattern parallel)

## Verdict

GO

**Summary:** Two narrow per-file allow entries in one project's settings.json — exact prior-art parallel exists, deny rules remain intact, reversibility is two-line removal, no shared infra touched.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded file is touched — CHANGE_DESCRIPTION explicitly states "No hook, command, skill, symlink, CLAUDE.md, or shared-state automation touched."
- Two new allow lines in `.claude/settings.json` add ~70 bytes; settings.json is parsed by the harness, not loaded into the model token context per turn.
- No new hook registered, no auto-load skill added, no `@import` chain extended. Verified by reading settings.json — hooks block (lines 63–86) is unchanged; only the allow array (lines 4–27) gains two entries.

### Dimension 2: Permissions Surface
**Risk:** Low

- Additions are scoped to a single file path each: `Write(./brand-book/00_foundation.md)` and `Edit(./brand-book/00_foundation.md)`. No glob expansion, no new tool family, no scope escalation (project layer, not user layer).
- The broad deny rules (`Write(./brand-book/*.md)`, `Edit(./brand-book/*.md)` — settings.json lines 52–53) remain intact. Claude permission resolution evaluates allow-then-deny per Anthropic harness semantics; the new narrow allow takes precedence only for the exact file path.
- Pattern is an exact replay of the established convention in lines 21–26 of settings.json: `Write(./brand-book/_scoping/**)`, `Write(./brand-book/_appendix/**)`, `Write(./pipeline/module-status.md)`, all already enumerated through the same allow-with-broad-deny mechanism. Prior-art commit `281ed32` ("Permission settings refactored during the session — deny patterns narrowed to enumerate protected files") confirms operator awareness and validates the pattern.
- No `deny` entry removed or narrowed. No `Bash(*)` widening (Bash(*) already exists at line 5, unchanged).

### Dimension 3: Blast Radius
**Risk:** Low

- Files touched: exactly 1 — `projects/axcion-brand-book/.claude/settings.json`.
- Downstream consumers of brand-book settings.json: bound to this project only. The `additionalDirectories` entry (line 60) makes the workspace root reachable for reads, but the allow/deny rules govern only writes inside this project's working tree.
- The newly-permitted target `brand-book/00_foundation.md` does not yet exist (confirmed via `ls brand-book/` — only `_appendix/` and `_scoping/` present). No contract change for any caller: `/draft-module` is the sole intended writer per `pipeline/module-status.md` lines 40–48, and that command is expected to produce this file as its first v0.1 output.
- No hook, no skill, no command frontmatter, no symlink, no shared-manifest entry touched. No `session-guide-generator` schema implications (it consumes `module-status.md`, which is unaffected).

### Dimension 4: Reversibility
**Risk:** Low

- Revert mechanism: remove two lines from `.claude/settings.json`. Clean `git revert` of the single-file change fully restores prior state.
- No log mutation, no external write, no Notion push, no operator muscle memory burden (the two new allow lines are inert until `/draft-module 00_foundation` actually runs).
- No automation can fire between landing and revert that would propagate state — settings.json edits take effect on next tool call within the same session; there is no daemon, cron, or hook reacting to the allow list itself. The SessionStart `check-permission-sanity.sh` hook (line 79) reads settings.json but does not mutate downstream state based on what it finds.

### Dimension 5: Hidden Coupling
**Risk:** Low

- No new contract introduced. The allow-list entry is a plain harness permission string; the harness's allow/deny resolution semantics are the only "contract" involved, and they predate this change.
- No implicit dependency on undocumented convention. The pattern is documented by direct prior art in the same file (lines 21–26) and recorded in commit `281ed32`'s message.
- No auto-firing in unexpected contexts. Allow entries are passive — they only enable, they do not trigger work.
- No functional overlap with existing mechanisms. There is no second permission system or alternative gating layer competing for the same file.
- The `brand-book/00_foundation.md` target file being `not yet present` is expected by design — the whole purpose of this permission lift is to permit its creation by `/draft-module`. No assumption made about the file's content is load-bearing for this risk evaluation.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: settings.json read in full (lines 1–87, with specific line references to allow array 4–27, deny array 28–58, hooks block 63–86); `module-status.md` read for downstream-consumer mapping; `brand-book/` directory listed via `ls` to confirm `00_foundation.md` is not yet present and that only `_appendix/` + `_scoping/` siblings exist; prior-art commit `281ed32` inspected via `git show` for parallel-pattern confirmation. No training-data fallback was used.
