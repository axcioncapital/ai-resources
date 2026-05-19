# Risk Check — 2026-05-19

## Change

Added a new `jargon-gloss` skill at `ai-resources/skills/jargon-gloss/SKILL.md` (detection + auto-rewrite of undefined domain-specific terms with parenthetical glosses on first mention; PE-vocab whitelist; sentence-split rule >35 words; bright-line carve-outs). Added a new standalone wrapper command `/produce-jargon-gloss` in two locations: `ai-resources/workflows/research-workflow/.claude/commands/produce-jargon-gloss.md` (canonical) and `projects/nordic-pe-macro-landscape-H1-2026/.claude/commands/produce-jargon-gloss.md` (project copy). Modified `/produce-prose-draft` in both the canonical workflow template (added Phase 6 Jargon Gloss, renumbered handoff to Phase 7) and the project copy (added Phase 4 Jargon Gloss, renumbered handoff to Phase 5) — both delegate to the new skill via sonnet sub-agent, mirroring the existing decontamination phase override pattern. Updated `projects/nordic-pe-macro-landscape-H1-2026/reference/stage-instructions.md` Step 5.3 entry to reflect the new third chained skill. The build was scope-approved, QC-passed (GO with 3 minor wording fixes applied), and is queued for commit.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/jargon-gloss/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/produce-jargon-gloss.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/.claude/commands/produce-jargon-gloss.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/produce-prose-draft.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/.claude/commands/produce-prose-draft.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/reference/stage-instructions.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The change adds well-scoped pay-as-used machinery (skill + wrapper command + two phase insertions), but two structural risks elevate it above clean GO — a dual-copy command divergence surface (canonical template + project copy must stay in sync) and a downstream-compatibility question for already-produced R1 prose now in scope for retroactive gloss runs.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The new SKILL.md is 275 lines (`wc -l ai-resources/skills/jargon-gloss/SKILL.md` → 275); it is loaded only when `/produce-prose-draft` or `/produce-jargon-gloss` runs, not on every session. No `@import` into an always-loaded CLAUDE.md.
- No SessionStart, Stop, PreToolUse, or UserPromptSubmit hook is added — confirmed by absence of any hook-related mentions in CHANGE_DESCRIPTION and absence of new entries in `.claude/settings.json` (the change description names only skill/command/reference files).
- The two `produce-jargon-gloss.md` wrapper commands (88 lines canonical, 84 lines project) load on slash-command invocation only — pay-as-used.
- The `produce-prose-draft.md` files grew (239 lines canonical, 141 lines project) — they are slash-command files, not always-loaded; cost is per-invocation of an already-multi-phase pipeline command, where one more delegated phase is a marginal addition.
- The Stage 5.3 entry in `stage-instructions.md` gained ~2 lines (`reference/stage-instructions.md` line 112) — `stage-instructions.md` is read on stage entry, not every turn (per its own header at line 3: "Not needed for every turn"), so the added tokens are not on every-turn cost.

### Dimension 2: Permissions Surface
**Risk:** Low

- No new `allow`, `ask`, or `deny` entries in any `.claude/settings.json` — the change description names no settings files, and the skill `## Runtime Recommendations` states "Tools: Requires Read and Write (or Edit) against the prose file and the change-log path" (SKILL.md line 255), which are already-authorized capabilities in the project (the existing `/produce-prose-draft` pipeline already writes prose files and sidecar logs to the same `prose_output_dir`).
- The new subagent is launched via the existing `general-purpose` agent type with `model: "sonnet"` — same launch pattern already used by Phase 3 (decontamination) in `produce-prose-draft.md` line 180. No new agent type registered.
- No external API calls, no MCP server access, no cross-repo writes.

### Dimension 3: Blast Radius
**Risk:** Medium

- Direct files touched: 6 (1 new skill, 2 new wrapper commands, 2 modified produce-prose-draft files, 1 modified stage-instructions.md).
- Grep enumeration across the workspace for `jargon-gloss` (find + xargs grep) returns 10 hits — but 8 of these are the 6 changed files plus 4 project log files (`friction-log.md`, `innovation-registry.md`, `session-notes.md`, `decisions.md`), which are append-only working records, not dependent callers. Actual dependent-caller count: **0 outside the changed set**.
- Grep for `produce-prose-draft` returns matches in `stage-instructions.md` (the Step 5.3 line updated as part of this change) and in `CLAUDE.md` (project CLAUDE.md § Stage 5 Polish Commands, line 65 of project CLAUDE.md unchanged but references the command by name — compatible with the update because the command name and invocation form `/produce-prose-draft r{N}` are preserved).
- Contract change — backwards-compatible: `/produce-prose-draft` adds one phase (Phase 4 in project copy / Phase 6 in canonical), renumbers handoff (Phase 5 / Phase 7). The slash-command invocation surface (`/produce-prose-draft r{N}` and `/produce-prose-draft {section}`) is unchanged. The output file path `R{N}-prosed.md` is unchanged. The new sidecar `gloss-additions-log.md` is additive — no caller currently expects it absent.
- Two-location command divergence surface: the wrapper `/produce-jargon-gloss` exists in both `ai-resources/workflows/research-workflow/.claude/commands/` (canonical, 88 lines) and `projects/nordic-pe-macro-landscape-H1-2026/.claude/commands/` (project copy, 84 lines). They are not symlinked (the project file is a real file with `-rw-r--r--` perms, not a symlink — confirmed by `ls -la projects/.../.claude/commands/produce-jargon-gloss.md`). The same divergence already exists for `/produce-prose-draft` and `/produce-formatting` (per project CLAUDE.md § Stage 5 Polish Commands, line 65 noting "adapted from the canonical research-workflow template for this project's report-based document model"). This is an established pattern, not new — but the surface is now wider by one more dual-copy command pair.
- Stage 5.3 contract in `stage-instructions.md` line 112 now names "three chained skill" (prose-refinement-writer + ai-prose-decontamination + jargon-gloss) — operators reading the stage instructions after this change need to know the chain has grown. The stage instructions file is read on stage entry, so the new contract reaches every R1/R2/R3 producer turn.
- No caller requires modification to keep working — confirmed by grep results: existing `/produce-prose-draft`, `/produce-formatting`, `/produce-architecture` references in project files reference the commands by slash-form and continue to function. Pre-gloss-phase R1 prose at `report/produced/1.1/R1/R1-prosed.md` exists (per find result) — it works as-is; the change description provides `/produce-jargon-gloss r1` as the retroactive bridge (mentioned in both wrapper command files lines 11–13).

### Dimension 4: Reversibility
**Risk:** Medium

- The skill file, both wrapper commands, and the produce-prose-draft modifications are clean `git revert` targets — single-file edits in tracked locations, no generated state in the change itself.
- Two append-only log entries already exist that name the change: `projects/nordic-pe-macro-landscape-H1-2026/logs/innovation-registry.md`, `decisions.md`, `session-notes.md`, `friction-log.md` all contain "jargon-gloss" references (confirmed by find+grep). `git revert` of the change commits will not remove these log entries — they are append-only and will carry forward as historical record. This is a Medium-grade rollback footprint, not High, because the log entries do not actively drive future behavior; they document history.
- If `/produce-jargon-gloss` is run between landing and revert, the targeted prose files (e.g., `R1-prosed.md`) will be overwritten in place by the skill (per SKILL.md line 188: "When the caller passes the same path as the input, the glossed prose overwrites the input file"). The pre-gloss content is recoverable from git history of the prose file itself, but operators may not realize the prose file was overwritten — a small per-use cleanup cost if the change is later reverted.
- The wrapper command runs against existing prose drafts (R1 is already produced per `report/produced/1.1/R1/R1-prosed.md` existence and per the wrapper's "When to use" line 12 explicitly naming this retroactive case). A revert after retroactive runs would require either re-running `/produce-prose-draft r1` to regenerate R1 without gloss, or reverting the prose file itself from git history. One additional step beyond pure code revert.
- No external state propagation (no git push assumed, no Notion write, no API POST). The change is queued for commit, not pushed.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Dual-copy synchronization contract** (implicit, undocumented in the changed files themselves but documented at project CLAUDE.md line 65). The canonical workflow command `ai-resources/workflows/research-workflow/.claude/commands/produce-jargon-gloss.md` and the project copy `projects/nordic-pe-macro-landscape-H1-2026/.claude/commands/produce-jargon-gloss.md` are independent files (not symlinked — confirmed by file permissions). Future edits to one must propagate to the other manually. Comparing the two: canonical 88 lines vs project copy 84 lines — they already diverge intentionally (the canonical version handles generic section identifiers; the project copy hard-codes `r1`/`r2`/`r3` and the report path `report/produced/1.1/R{N}/`). This pattern is established for `/produce-prose-draft` and `/produce-formatting` already (per project CLAUDE.md line 65), but each new dual-copy command adds maintenance surface.
- **Style-reference dependency at fixed path.** The project copy of `produce-jargon-gloss.md` hard-codes the style reference path at line 32 (`report/style-reference/1.1/1.1-style-reference.md`). If this path changes or the file is moved, the wrapper command silently passes a non-existent absolute path to the subagent. The skill itself is non-blocking on missing style reference (SKILL.md line 47: "When absent, the skill uses neutral analytical phrasing for glosses"), so the silent failure mode degrades gloss tone rather than blocking. Mitigated by the established convention of locked style references for this project.
- **Subagent task-brief contract for sonnet override.** Both wrapper commands and `/produce-prose-draft` instruct the subagent to override the skill's declared `model: opus` to sonnet (canonical produce-prose-draft.md line 207, project produce-prose-draft.md line 107). This is the same pattern already used for decontamination (canonical line 180) — the contract is consistent across phases. The pattern is not documented at the skill level beyond SKILL.md line 257 ("Calling commands may override to Sonnet for pattern-based execution... The `produce-prose-draft` pipeline applies the Sonnet override at the command layer"), which is an explicit acknowledgment — Low coupling risk on this axis.
- **Bright-line rule override** declared three times (canonical phase 6 line 214, project phase 4 line 114, both wrapper commands phase 2). This is the same pattern as Phase 5 decontamination's bright-line override. The override semantics are stated inline in each location; no new contract beyond the existing override pattern. Low coupling on this axis.
- **Idempotency contract** (SKILL.md lines 58, 150–152). The skill claims to detect pre-existing parenthetical/em-dash/appositive glosses within a 10-word window and skip them. This is an implicit contract with whatever upstream phase produces the prose — if a future writer skill produces glosses in a non-standard form (e.g., footnote-style definition instead of inline parenthetical), the idempotency check could miss them and double-gloss. Documented at the change site (SKILL.md § Idempotency check), so this is Medium coupling rather than High — the contract is explicit, just narrow.
- **No silent auto-firing.** The new phase fires only when `/produce-prose-draft` runs (already an explicit operator action) or when `/produce-jargon-gloss` runs (explicit). No SessionStart, no PreToolUse, no implicit triggers.

## Mitigations

- **Mitigation for Dimension 3 (Blast Radius — Medium):** Before any future change to either `/produce-jargon-gloss` copy, diff the two files (`diff ai-resources/workflows/research-workflow/.claude/commands/produce-jargon-gloss.md projects/nordic-pe-macro-landscape-H1-2026/.claude/commands/produce-jargon-gloss.md`) and propagate intended changes to both. The project CLAUDE.md § Stage 5 Polish Commands (line 65) is already the documentation site for this synchronization contract — extend that paragraph (or add a one-line note in either wrapper command file's header) to explicitly name `/produce-jargon-gloss` alongside `/produce-prose-draft` and `/produce-formatting` so the synchronization expectation is visible at the file level, not only in project CLAUDE.md.
- **Mitigation for Dimension 4 (Reversibility — Medium):** When invoking `/produce-jargon-gloss` retroactively against an already-produced prose file (the change description's stated use case for R1), git-commit the pre-gloss state of the target prose file before running. This ensures a clean rollback target if the gloss pass is later reverted or the operator wants to compare. The wrapper command notes the change-log produces `gloss-additions-log.md` (project wrapper line 33) — adding a one-line pre-flight commit by the operator before the run reduces revert cost.
- **Mitigation for Dimension 5 (Hidden Coupling — Medium):** Add a one-line cross-reference at the top of each wrapper command file pointing to its sibling copy (canonical ↔ project), so the next editor of either file sees the dual-copy fact without needing to load project CLAUDE.md. Format: `<!-- Companion file: {absolute-or-relative-path} — keep behavior consistent. -->`. Place under the YAML frontmatter and above the first prose paragraph.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references from the six referenced files, `wc -l` line counts, `ls -la` permission inspection confirming non-symlink status, `find + xargs grep` enumeration counts for `jargon-gloss` and `produce-prose-draft`, and verbatim quotes from SKILL.md, the two wrapper commands, and the two `produce-prose-draft.md` files). No training-data fallback was used on fetch/read failures.
