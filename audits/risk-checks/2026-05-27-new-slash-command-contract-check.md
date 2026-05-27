# Risk Check — 2026-05-27

## Change

end-time gate on new slash command /contract-check at ai-resources/.claude/commands/contract-check.md

Change summary: A new operator-invoked slash command that resolves an "original contract" (from $ARGUMENTS path/text or auto-detected from logs/contracts/, logs/session-plan.md, session-notes mandate block, project briefs, workflow intake, or inbox) and an artifact (auto-detected from git uncommitted/today's changes or operator-asked), then delegates a fresh-context general-purpose subagent to compare them and return CONTRACT-ALIGNED / MINOR-DRIFT / MAJOR-DRIFT. Pure read + subagent delegation. Modifies no files. Commits nothing. Lives at ai-resources/.claude/commands/contract-check.md.

No hooks added. No settings.json changes. No agent file added (uses general-purpose subagent). No CLAUDE.md edit. No edit to existing commands. Single new file.

Context: Plan-time risk-check was not run separately — the architectural judgment was performed via /consult to the System Owner, which confirmed the gap and recommended the build path. The new command follows the canonical /drift-check pattern (slash command + fresh-context general-purpose subagent). QC pass returned REVISE with 5 findings; all 5 resolved inline (description trimmed, QS-2 references replaced with direct pointers, confirmation prompt dropped per Decision-Point Posture, dual-argument branch removed, .claude/* exclusion conditional removed, trailing $ARGUMENTS removed).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/contract-check.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/drift-check.md — exists

## Verdict

GO

**Summary:** Pure operator-invoked, read-only, no-write slash command that mirrors the established `/drift-check` pattern; the only elevated dimension is hidden coupling (one undocumented dependency on a not-yet-created `logs/contracts/` directory) and that risk stays at Low because the auto-detect fall-through is explicitly designed to handle absence.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The command is pay-as-used — it is operator-invoked only, not auto-loaded. Evidence: `contract-check.md:6` describes it as "operator-triggered" and `:193` ("today it is operator-triggered"); no SessionStart / PreToolUse / Stop / UserPromptSubmit hook is added per change description.
- No `@import` is added to an always-loaded file. Change description: "No CLAUDE.md edit. No edit to existing commands."
- No new subagent file is added; reuses the `general-purpose` subagent ephemerally per invocation. Evidence: `contract-check.md:107` ("Spawn one general-purpose subagent (fresh context)").
- The 194-line command body (`wc -l` on contract-check.md = 194) only loads when invoked.
- No skill is registered, so no broad keyword auto-load fires.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json` change. Change description: "No settings.json changes."
- The command uses Read, Bash (`git status --short`, `git log`, `[ -f ... ]`), and Task (subagent spawn) — all already-authorized tool families in the repo per the existence of peer commands like `/drift-check` which use the same surface (`drift-check.md:51-52`).
- No `deny` rule removed; no `allow` widened.

### Dimension 3: Blast Radius
**Risk:** Low

- Single new file: `ai-resources/.claude/commands/contract-check.md`. `git status --short` confirms only `?? .claude/commands/contract-check.md` for this artifact.
- Grep for `contract-check` across `ai-resources/`: 1 file hits (the command itself). Grep across workspace `CLAUDE.md` and `ai-resources/CLAUDE.md`: 0 hits. No downstream callers exist yet.
- Grep for `drift-check` across `.claude/commands/` and `docs/`: 4 files (contract-check.md, drift-check.md, session-plan.md, session-start.md) — confirms the canonical pattern is wired into session-plan and session-start. The new `/contract-check` adds NO equivalent wiring (no edit to session-start.md or session-plan.md per change description). Future integration is noted as deferred (`contract-check.md:192-193`).
- No contract change: this introduces a new command, doesn't change any existing command's input/output schema, headings, or invocation syntax.
- The disk-notes contract from `ai-resources/CLAUDE.md` § Subagent Contracts is honored — `contract-check.md:154` caps subagent output at 25 lines, and `:167` explicitly justifies skipping the disk-notes file ("the verdict is short by construction").

### Dimension 4: Reversibility
**Risk:** Low

- Single untracked file. `git status --short` shows `?? .claude/commands/contract-check.md`. A clean `rm` (or, once committed, `git revert`) fully removes it; no sibling files, no log-file appends, no directory structures created at install time.
- No state propagates beyond the repo: no push, no Notion write, no external API.
- No hook registration means there is no firing window between landing and revert during which side effects could accumulate.
- Operator muscle memory cost on revert is bounded — the command is brand new, so revert simply removes a capability that no other workflow yet depends on.

### Dimension 5: Hidden Coupling
**Risk:** Low

- One implicit dependency on a not-yet-created directory: `contract-check.md:48` references `REPO_ROOT/logs/contracts/` as the first auto-detect source. The directory does not currently exist (`ls .../logs/contracts/` returns "No such file or directory"). However, the auto-detect is explicitly designed to fall through to (b) session-plan, (c) mandate block, (d) project briefs, (e) workflow intake, (f) inbox, and (g) a clear abort message — the contract source explicitly carries the gap as deferred future work (`:192`: "Freeze-baseline at /scope time (deferred)... Until that lands, auto-detect order in Step 2 falls back through session-plan, mandate-block, and project briefs"). The dependency is documented at the change site, not silent.
- One overlap with `/drift-check`: both commands consume the `session-notes.md` bottom-most-block mandate convention. The overlap is intentional and explicitly named in the new command's preamble (`contract-check.md:8`: "the artifact-content drift complement to `/drift-check` (which watches session trajectory)"). Two commands now read the same source for related but distinct purposes; the boundary is documented and not silent.
- No silent auto-firing: command is operator-invoked only, with no hook registration, so it never fires in unexpected contexts.
- The mandate-block parsing rule ("last bottom-most `## {DATE}` entry") is established convention from `drift-check.md:26` and is consistent with the `session-notes.md uses append-to-end` operator memory — no new convention introduced.
- The 800-line artifact truncation rule (`contract-check.md:101`) is a new local convention but is documented in the subagent brief at the change site itself.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references from contract-check.md and drift-check.md, grep counts across `ai-resources/`, verbatim quotes from CHANGE_DESCRIPTION, and `git status --short` output). No training-data fallback was used.
