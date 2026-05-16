# Risk Check — 2026-05-16

## Change

End-time gate — item #6 as executed: added "Read-scope floors" bullet (one line, ~28 tokens) to workspace CLAUDE.md § Working Principles stating minimum read scopes are floors not ceilings; added explicit floor-not-ceiling note to friday-act.md Step 16a extending the lead paragraph. All three plan-time mitigations applied: (1) CLAUDE.md bullet kept to ≤30 tokens; (2) placed under Working Principles per mitigation; (3) trigger named explicitly. friday-so.md not touched (pattern not present). This is the only class-crossing change in the session.

## Referenced files

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-act.md` — exists

## Verdict

GO

**Summary:** Single short bullet added to workspace CLAUDE.md plus one extension paragraph in a single command; all three plan-time mitigations honored, no callers affected, clean revert.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Workspace CLAUDE.md is always-loaded. The added bullet at line 56 reads: "**Read-scope floors.** Minimum read scopes in commands are floors, not ceilings — expand when a downstream claim depends on content past the read window." Word count ≈ 22 words / ~28 tokens — within the ≤30-token mitigation cap stated in CHANGE_DESCRIPTION.
- friday-act.md Step 16a extension is in a command file, not always-loaded; runs only when `/friday-act` fires (weekly cadence). No per-session or per-tool-call hook touched.
- No new `@import`, no new SessionStart/PreToolUse/Stop hook, no broad-trigger skill description added.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json` / `settings.local.json` referenced in CHANGE_DESCRIPTION; no `allow` / `ask` / `deny` entry mentioned. Change is content-only in CLAUDE.md and a single command's prose.
- No new tool invocation pattern (Bash, Write path, MCP) introduced. The new bullet is descriptive guidance, not a permission grant.

### Dimension 3: Blast Radius
**Risk:** Low

- Two files touched directly: workspace `CLAUDE.md` (1 bullet added under § Working Principles at line 56); `ai-resources/.claude/commands/friday-act.md` (extension to Step 16a lead paragraph at line 158).
- friday-act.md Step 16a already contained the phrase "The section-target spec below is a minimum read floor: if you intend to assert what an advisory contains … you must read the relevant sections in full before asserting — spec-literal compliance does not substitute for judgment about how much context a claim requires." (lines 158). The new principle reinforces existing in-file guidance — no new contract introduced.
- No schema, heading, or input/output contract changed. friday-act.md Step 16a still emits the same operator-facing display structure; the journal-derived item regex contract (Step 3.5 schema callout) is untouched.
- friday-so.md explicitly not touched per CHANGE_DESCRIPTION ("pattern not present"). No other consumer of "read floors" semantics identified.

### Dimension 4: Reversibility
**Risk:** Low

- Both edits are single-file content additions; `git revert` of the commit cleanly removes both the CLAUDE.md bullet and the friday-act.md sentence.
- No sibling files created, no log/registry/data file mutated, no external push, no automation registered. Nothing for git to leave behind.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The CLAUDE.md bullet states an explicit principle ("floors, not ceilings") and is self-contained — no parse marker, no filename convention, no YAML key introduced.
- friday-act.md Step 16a extension is co-located with the existing minimum-read-floor language at the same step; the new guidance reinforces rather than overlaps a separate mechanism. No second system fires on the same trigger.
- Workspace CLAUDE.md § Working Principles is the documented home for cross-session principles of this shape (companion to "When iterating, create a new version file…" at line 54 and "Compaction protocol…" at line 55). Placement matches existing convention.
- No silent auto-firing — the principle is read-on-load, advisory, and applied by Claude's judgment during command execution, not by any hook.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (verbatim quotes and line numbers from `CLAUDE.md` lines 52–56 and `friday-act.md` lines 158, 417–419 token-cost notes; verbatim quote of plan-time mitigations from CHANGE_DESCRIPTION). No training-data fallback was used.
