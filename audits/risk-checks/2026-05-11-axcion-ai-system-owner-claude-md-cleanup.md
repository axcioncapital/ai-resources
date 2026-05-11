# Risk Check — 2026-05-11

## Change

Proposed structural change: edit `projects/axcion-ai-system-owner/CLAUDE.md` to apply HIGH+MEDIUM+1 LOW findings from `audits/working/audit-claude-md-project-axcion-ai-system-owner.md`. Specifically:

(1) Rename "Input File Handling" block to "File Write Discipline" — fixes broken canonical-rule citation (workspace section is named "File Write Discipline", not "Input File Handling"). Same rule semantics, correct section name only.

(2) Replace Project Layout block (33-line ASCII tree, ~190 tokens) with a new `references/project-layout.md` file containing the tree, and a one-line pointer in CLAUDE.md. Net: same content, moved off always-loaded surface.

(3) Replace Grounding Paths block (~180 tokens enumerating v2 vault files) with a one-line pointer to `references/grounding.md` § 1 (which already contains the canonical enumeration). Net: deduplication.

(4) Trim Toolkit Relationship block (~135 tokens). Drop the five-mechanism enumeration (already in `references/toolkit-relationship.md` § 1). Keep locked-decision header + pointer.

(5) Trim Compaction block. Drop the closing "prefer writing a short session-state scratchpad... over lossy auto-summarization" sentence (covered by workspace compaction-protocol.md). Keep project-specific preservation list.

Net effect: ~390 tokens saved per turn from always-loaded surface; one broken reference fixed; one new file created (`references/project-layout.md`). No skill, command, agent, hook, permission, settings, or workflow changes. No semantic changes to active rules.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/audit-claude-md-project-axcion-ai-system-owner.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/references/grounding.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/references/toolkit-relationship.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/references/project-layout.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/compaction-protocol.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A token-cost-reducing refactor with all five sub-changes confined to one project's CLAUDE.md and references directory; the only material risk is a naming-coupling collision with the `/new-project` command which still emits "Input File Handling" as a canonical section header for new projects.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Change reduces always-loaded token footprint by ~390 tokens/turn — direct quote from CHANGE_DESCRIPTION ("Net effect: ~390 tokens saved per turn") and audit estimate (`audit-claude-md-project-axcion-ai-system-owner.md` line 120: "Per-turn saving: ~390 tokens").
- The new `references/project-layout.md` file is not always-loaded; it is reference data created for future on-demand reads only. No hook, no auto-import, no @-reference into CLAUDE.md.
- No new SessionStart/Stop/PreToolUse hook, no skill, no auto-loaded import chain. The only edits are to one project's always-loaded CLAUDE.md, all of which reduce its weight.
- Negative cost change (savings); strictly improves Dimension 1.

### Dimension 2: Permissions Surface
**Risk:** Low

- CHANGE_DESCRIPTION states verbatim: "No skill, command, agent, hook, permission, settings, or workflow changes."
- No allow/ask/deny entries touched. No widening of `Write`, `Bash`, `Read` patterns. No scope movement between settings layers.
- The `system-owner` agent's existing Write scope (`projects/axcion-ai-system-owner/output/` per CLAUDE.md line 35) is unchanged; the new `references/project-layout.md` is created in a separate operator-driven edit, not via the agent.

### Dimension 3: Blast Radius
**Risk:** Medium

- Files touched directly: 2 (one edit to `projects/axcion-ai-system-owner/CLAUDE.md`; one new file `references/project-layout.md`).
- Callers / dependent components grepped across the repo:
  - `Input File Handling` literal string appears in 24 locations (grep across workspace), mostly in audit reports (historical) and in `ai-resources/.claude/commands/new-project.md` (11 occurrences — lines 367, 388, 391, 402, 439, 450, 479, 480, 481, 483, 510). The `/new-project` command emits `## Input File Handling` as a canonical section header that NEW projects receive, and uses `grep -q '^## Input File Handling'` (line 480) as the idempotency check.
  - `axcion-ai-system-owner/CLAUDE.md` is referenced from `pipeline/architecture.md` (line 41), `pipeline/project-plan.md`, and three context-pack versions under `projects/project-planning/output/` — all of these are pipeline-history artifacts, not live callers. No active command or agent reads this file by path.
  - `references/grounding.md` and `references/toolkit-relationship.md` are read by the `system-owner` agent on every invocation (per their own headers and `grounding.md` § 1). Trimming CLAUDE.md does not change those reference files — only the CLAUDE.md pointer text. Agent behavior is preserved.
- Contract changes: section heading rename `## Input File Handling` → `## File Write Discipline` is a contract-shape change. No active caller in `.claude/commands/` or `.claude/agents/` greps for the project-side `## Input File Handling` header (the `new-project` grep at line 480 targets newly-created project CLAUDE.md files in OTHER projects, not this one). But: a future `/new-project` re-run, a future `/permission-sweep`, or a future audit (`/audit-claude-md`) that searches for "Input File Handling" as a canonical project-section header will not find it here — they will find the new heading instead, or report drift.
- Project-specific block edits (Project Layout, Grounding Paths, Toolkit Relationship trim, Compaction trim) are isolated: no external file currently parses these block contents.
- The `system-owner` agent body and command bodies do not read the project CLAUDE.md by path — they rely on harness auto-loading. Editing CLAUDE.md content does not break any explicit read.

Net: 2 files touched; ~0 active code-path callers; 1 latent caller class (audit scripts / `/new-project` template idempotency) that uses the old section name as a convention but does not retroactively edit this project's CLAUDE.md. Medium because the section rename diverges from the workspace-wide section-name convention currently embedded in `/new-project`.

### Dimension 4: Reversibility
**Risk:** Low

- Single-file edit to `projects/axcion-ai-system-owner/CLAUDE.md` — `git revert` of the commit cleanly restores prior content.
- One new file `references/project-layout.md` — `git revert` removes it (it is created in the same commit; revert undoes both the edit and the add).
- No data file mutated (no innovation-registry, session-notes, improvement-log, archives).
- No settings.json change. No hook registered. No external write (push, Notion, API).
- No automation fires between edit and revert; the change is passive text.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- Naming-convention coupling with `/new-project`: the `new-project.md` command body (line 480) uses `grep -q '^## Input File Handling'` as the canonical idempotency probe for the file-write-discipline section in project CLAUDE.md files. The workspace CLAUDE.md uses `## File Write Discipline` (line 67). The repo currently lives with this mismatch (workspace renamed, `/new-project` template still emits the old name). This change adopts the workspace-aligned name in one project's CLAUDE.md without updating `/new-project` — creating a third state: workspace = "File Write Discipline"; `/new-project` template = "Input File Handling"; this project = "File Write Discipline". Future `/audit-claude-md` runs or `/new-project` idempotency checks that assume one canonical name will see drift.
- The audit working note itself (`audit-claude-md-project-axcion-ai-system-owner.md` line 145) recommends renaming to match the workspace — confirming the workspace section name is the intended canonical anchor. So the change is moving toward correctness, but it surfaces (not introduces) coupling between the project and the `/new-project` template that was previously implicit.
- The five-mechanism enumeration removal (sub-change 4) silently relies on the `system-owner` agent already reading `references/toolkit-relationship.md` on every invocation — confirmed by the file's own header (line 3: "Read by the agent on every invocation."). Documented at the change site if the new CLAUDE.md retains the pointer line. Low coupling risk for this sub-change.
- The grounding paths dedup (sub-change 3) silently relies on `references/grounding.md` § 1 containing the same v2 vault enumeration — confirmed by reading `grounding.md` lines 9–21 (vault path table present and complete). Documented if pointer text names the section.
- The Project Layout move (sub-change 2) introduces a new file convention (`references/project-layout.md`) not declared anywhere in the agent grounding or in any command body. The agent does NOT read this file (per `grounding.md` § 5 "What is NOT in the Grounding Base"). That is intentional — layout is operator-facing reference, not agent grounding. The pointer in CLAUDE.md must make this clear or future readers may assume the agent loads it.
- No silent auto-firing in unexpected contexts; no overlap with existing mechanisms beyond the naming-collision above.

Medium because of the naming-collision with `/new-project` template emission (sub-change 1). Sub-changes 2–5 are Low-coupling on their own.

## Mitigations

- **Dimension 3 / Dimension 5 (sub-change 1, section rename):** When applying the rename, either (a) also update `ai-resources/.claude/commands/new-project.md` to emit `## File Write Discipline` as the canonical section name (11 occurrences across lines 367, 388, 391, 402, 439, 450, 479, 480, 481, 483, 510) and update the grep idempotency check on line 480 to match — OR (b) leave `/new-project` untouched and add a one-line note in the operator-facing wrap message that the workspace canonical name has diverged from the `/new-project` template, and the template update is deferred. Option (a) is the structurally cleaner mitigation; option (b) is acceptable if scope is intentionally bounded to the one project at this time. Either way, the divergence must not be left implicit.
- **Dimension 5 (sub-change 2, new project-layout.md file):** In the one-line CLAUDE.md pointer that replaces the ASCII tree, explicitly state that `references/project-layout.md` is operator-facing reference (not agent-read) — e.g., "Filesystem layout: see `references/project-layout.md` (operator reference; not loaded by the agent)." Prevents future readers from assuming the agent grounds in it.

## Recommended redesign

(Omitted — verdict is PROCEED-WITH-CAUTION.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence: workspace CLAUDE.md line 67 (`## File Write Discipline` confirmed as the actual section name); `new-project.md` lines 367/388/391/402/439/450/479/480/481/483/510 (11 occurrences of "Input File Handling" in the canonical project-template emitter); `audit-claude-md-project-axcion-ai-system-owner.md` line 120 (~390 tokens saving estimate); `grounding.md` lines 9–21 and § 5 (vault enumeration present; layout files not in grounding base); `toolkit-relationship.md` line 3 ("Read by the agent on every invocation"); `compaction-protocol.md` line 7 (pre-compact scratchpad rule covered at workspace level); and grep results for cross-project references to the affected files. No training-data fallback used.
