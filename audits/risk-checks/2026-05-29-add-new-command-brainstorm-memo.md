# Risk Check — 2026-05-29

## Change

Add a new project-local slash command `/brainstorm-memo` to projects/ai-development-lab/.claude/commands/brainstorm-memo.md (model: opus). It turns one or more pipeline decision memos into a prioritized brainstorm doc grounded in a single system-owner Task dispatch, written to output/brainstorms/. Declared in .claude/shared-manifest.json commands.local[] so the auto-sync hook does NOT propagate it workspace-wide. Also adds a "How to invoke" line to the lab CLAUDE.md. Built from spec output/specs/2026-05-29-brainstorm-memo-command-spec.md.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/.claude/commands/brainstorm-memo.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/.claude/shared-manifest.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/output/specs/2026-05-29-brainstorm-memo-command-spec.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/.claude/commands/develop-memo.md — exists (sibling reference)

## Verdict

GO

**Summary:** A pay-as-used, project-local, on-demand command with a well-specified contract, no permission changes, and a clean single-tree revert; the only non-Low dimension is a Medium for the durable brainstorm-doc output that revert leaves behind.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The command file itself is not always-loaded — slash commands load only when invoked. The new `brainstorm-memo.md` is on-demand, pay-as-used; no per-session or per-tool-call token cost. (Evidence: it is a `.claude/commands/*.md` file, mirroring `develop-memo.md` which is invoked only on demand.)
- The CLAUDE.md change is a single "How to invoke" line. The spec's §9 checklist scopes it as one line "alongside `/analyze-transcript` and `/develop-memo`" (spec lines 239–240). Adding ~1 line to the always-loaded lab CLAUDE.md is well under the ~50-token Medium threshold.
- No new hook is registered. The existing SessionStart auto-sync hook (lab settings.json) already runs; this change adds nothing to it. The manifest entry is read by the hook but adds no per-session cost beyond the existing `jq` read already performed (`auto-sync-shared.sh` line 50).
- The command's own runtime cost (one system-owner Task dispatch, ~60–90K tokens per spec line 132) is incurred only when the operator invokes it — a per-use cost, not an always-loaded cost. Spec already flags this with `[HEAVY]`/`[COST]` (spec line 132).

### Dimension 2: Permissions Surface
**Risk:** Low

- No permission entries are added, removed, or widened. The lab settings.json already grants `Write`, `Edit`, `Task`, etc. (lab settings.json `allow[]`), and `additionalDirectories` already includes the workspace root.
- Output target `output/brainstorms/` is inside the project's existing writable tree; the directory already exists and holds `2026-05-29-context-ideas.md` (verified via `ls`). No new Write path needs authorizing.
- The command does NOT touch the denied paths: `transcripts/**` (deny) and the specific `pipeline/*.md` and `output/*proposal-v1.md` Read-denies (lab settings.json `deny[]`) are unrelated to this command's read set (memo.md + siblings).
- The single Task dispatch (system-owner) uses the already-allowed `Task` tool and an already-symlinked agent (`system-owner` in manifest `agents.local[]`). No new tool family or external/MCP capability.

### Dimension 3: Blast Radius
**Risk:** Low

- Files touched directly: 3 — the new `brainstorm-memo.md` (create), `shared-manifest.json` (add one array element), and lab `CLAUDE.md` (add one line). All within `projects/ai-development-lab/`.
- Callers/dependents grep results:
  - `grep -rn "brainstorm-memo" ai-resources/` → 0 matches. No canonical resource references this command; no cross-repo coupling.
  - `grep -rn "brainstorm-memo" projects/ai-development-lab/` → matches are confined to `logs/` (session-notes, decisions, scratchpads, session-plan) and the spec itself. These are records/plans, not runtime callers — none import or dispatch the command.
  - `grep -rn "output/brainstorms" projects/ai-development-lab/` → references in the spec, the origin doc, `.obsidian/workspace.json` (IDE tab state), and logs. No command or agent reads `output/brainstorms/` as input. The new doc is a leaf output with zero downstream consumers.
- No contract change to any existing component. The command consumes the existing memo run-artifact schema (memo.md + `infrastructure-briefing.md` / `analysis-system-owner.md` / `analysis-ai-engineer.md`) read-only, and the spec's Step 2 includes a skip-if-missing fallback (spec lines 97–101), so it does not impose a new required-input contract on the pipeline.
- Auto-sync hook impact: the manifest entry SUPPRESSES propagation. `auto-sync-shared.sh` syncs canonical ai-resources files INTO projects (one-way, downstream) and skips any name in `commands.local[]` (line 86: `in_list "$name" "$LOCAL_COMMANDS" && continue`). There is no path by which a project-local command propagates workspace-wide — the change description's stated intent is structurally correct. Blast radius is contained to the lab project.

### Dimension 4: Reversibility
**Risk:** Medium

- The three landing edits revert cleanly via git: deleting `brainstorm-memo.md`, removing the manifest array element, and removing the CLAUDE.md line are all single-tree changes a `git revert` restores fully.
- One extra cleanup step exists: the command's purpose is to WRITE durable docs to `output/brainstorms/{date}-{slug}.md`. Per spec memo/versioning discipline these are durable artifacts (spec §8 Q4 uses `-v2` suffix rather than overwrite, spec lines 223–224). If the command is reverted after it has run, any brainstorm docs it produced remain on disk and must be removed manually — git revert of the command file does not remove outputs the command generated. This is the classic "revert leaves generated artifacts" Medium case.
- No state propagates beyond git at landing time: no push-only side effect, no external API write, no Notion write inherent to the change. (The workspace commit rule auto-pushes, but the commit is a normal additive commit, revertible by a follow-up revert commit.)
- The manifest is a small JSON array; removing one element is mechanical and low-risk. No cached permission state or operator-remembered flag is introduced beyond the new command name itself.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The command's contracts are documented at the change site. The output schema (7 fixed sections, idea-ID convention) is fully specified in spec §5 (lines 153–184), and the build checklist requires it be reproduced in the command body (spec line 233–234). The slug/collision convention, multi-memo cap, and tier-vocabulary rules are resolved in spec §8 with build defaults (lines 215–227) and pinned in `logs/session-plan.md` line 32.
- One implicit dependency on an established repo convention: the command reads sibling run artifacts by hardcoded filename (`infrastructure-briefing.md`, `analysis-system-owner.md`, `analysis-ai-engineer.md`) produced by `/analyze-transcript`. This is an existing, stable convention (the same filenames `/develop-memo` depends on — see develop-memo.md Step 1 lines 30–37), and the spec's skip-if-missing fallback (spec lines 97–101) degrades gracefully rather than coupling hard. Single documented dependency on an established convention → Low/Medium boundary; rated Low because the fallback removes the silent-failure mode.
- No silent auto-firing: the command runs only on explicit `/brainstorm-memo` invocation, not on any hook event. The manifest entry is read by the SessionStart hook but only to SKIP the file — no new auto-fire behavior is introduced.
- No functional overlap with existing mechanisms. The spec explicitly distinguishes it from `/develop-memo` (breadth/idea-menu vs. depth/build-plan; spec lines 24–27, 203–206) and the lab CLAUDE.md Agent-scope boundary already governs the system-owner consult shape. The system-owner consult mirrors the established `/consult` Step 4 / `/analyze-transcript` Step 7 brief pattern rather than inventing a new dispatch contract (spec lines 126–132).

## Mitigations

(Omitted — verdict is GO. Note the Medium reversibility item is informational, not blocking: if the command is ever reverted, manually delete any `output/brainstorms/*.md` docs it generated, since git revert of the command file will not remove its outputs.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references to the spec, develop-memo.md, lab settings.json, shared-manifest.json, and auto-sync-shared.sh; verbatim grep counts for `brainstorm-memo` and `output/brainstorms`; directory listing confirming `output/brainstorms/` exists). No training-data fallback was used on any read. The new command file is `not yet present`; its contribution to every dimension was evaluated from the described intent in CHANGE_DESCRIPTION cross-checked against the build spec, which is on disk and complete.
