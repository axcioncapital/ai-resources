# Risk Check — 2026-06-02

## Change

Converted 11 shared general commands in projects/research-pe-regime-shift-advisory-gap/.claude/commands/ from frozen regular-file copies to relative symlinks pointing at ai-resources/.claude/commands/. The commands: prime, session-plan, note, wrap-session, audit-repo, friction-log, improve, consult, qc-pass, refinement-pass, update-claude-md. Research-pipeline commands (run-*, produce-*, create-context-pack, intake-reports, review-chapter, verify-chapter, workflow-status, audit-structure, inject-dependency, status) were deliberately left as template-local regular files because they have no general-library counterpart. Symlinks use the relative form `../../../../ai-resources/.claude/commands/{cmd}.md`, matching the convention already used by 55 other command symlinks in this same project and by every other project in the workspace. Changes already committed in two commits this session; this is the end-time gate evaluating the executed change set before the wrap commit and push.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap/.claude/commands/prime.md — exists (now symlink)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap/.claude/commands/wrap-session.md — exists (now symlink)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/ — exists (symlink targets)

## Verdict

GO

**Summary:** A reversal of drift onto the canonical library via the workspace's already-dominant symlink convention; all targets and runtime dependencies verified present, no permission or always-loaded-cost surface touched, and the change is git-reversible.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded file is modified. The 11 changed entries are slash commands — pay-as-invoked, loaded only when the operator runs them, not on every turn. No CLAUDE.md, no `@import`, no SessionStart/Stop/PreToolUse hook is added by this change.
- The two heaviest commands resolve to large bodies (`prime.md` 438 lines, `wrap-session.md` 365 lines per `wc -l`), but these costs are incurred only at session start / session end when the operator explicitly invokes them — not per-turn. The change does not alter invocation frequency.
- Net cost direction is neutral-to-favorable: the prior frozen copies were the same command-class artifacts; replacing a drifted copy with the canonical body changes content but not the load trigger.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `.claude/settings.json` or `settings.local.json` is touched by this change. `git diff --name-only HEAD~2 HEAD` returns only `.claude/commands/wrap-session.md` (the workspace-root independent copy edited separately this session); no settings file appears.
- No new `allow`/`ask` entry, no `deny` narrowing, no scope escalation (project → user). Symlinking a command file does not itself grant any tool capability; the resolved command's own permission needs are unchanged from the canonical version every other project already runs.
- `prime.md` and `wrap-session.md` both carry `model: sonnet` frontmatter (verified `head`) — no prohibited model-default in settings, consistent with workspace § Model Tier.

### Dimension 3: Blast Radius
**Risk:** Low

- Direct touch: 11 symlink files in one directory, all verified resolving (`readlink` + `-e` test passed for all 11; all 11 canonical targets confirmed present in `ai-resources/.claude/commands/`).
- Convention enumeration (grep/find counts): this project's command dir now holds 67 symlinks out of 87 `.md` entries; the workspace has 888 command symlinks under `projects/*/.claude/commands/`. The change moves 11 outliers onto the path the overwhelming majority already follow — it reduces divergence rather than introducing a new pattern.
- Contract dependents of the heaviest command verified present project-side: `wrap-session.md` invokes `logs/scripts/check-archive.sh` and `logs/scripts/split-log.sh` (both exist at `projects/research-pe-regime-shift-advisory-gap/logs/scripts/`) and launches the `session-feedback-collector` agent (exists at the project's `.claude/agents/`). The library version was confirmed a superset retaining pipeline-specific Stage Entry / innovation-registry / log-archive steps.
- No caller requires modification: slash-command invocation syntax (`/prime`, `/wrap-session`, …) is unchanged; resolution is transparent to callers.

### Dimension 4: Reversibility
**Risk:** Low

- Each of the 11 changes is a git-tracked file-type swap (regular file → symlink) in a single directory. `git revert` of the two session commits restores the prior blobs cleanly within the working tree; alternatively a single symlink can be replaced with a re-checked-out copy.
- No data/log mutation, no append-only registry write, no external push is part of this change. The prior frozen content is recoverable from git history.
- Caveat (does not raise the level): the change is already committed and the wrap will push. After push, rollback still works via `git revert` — the change does not propagate state outside git (no Notion write, no external API), so post-push reversibility remains a clean git operation.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The one real coupling — `wrap-session` depending on project-side scripts and the feedback-collector agent — was checked and is satisfied: `check-archive.sh`, `split-log.sh`, and `session-feedback-collector.md` all exist project-side. The library command references the scripts by relative path (`logs/scripts/...`), which resolves against the project cwd, so symlinking the command does not break the path.
- Relative symlink form (`../../../../ai-resources/...`) matches the established convention (888 workspace symlinks use it); no new filename or parse-marker contract is introduced.
- The library `wrap-session` adds marker-scoped session headers paired with the already-symlinked `prime` — the pairing is intra-library and both halves now resolve to canonical, so the contract is internally consistent rather than split across a drifted copy. No silent auto-firing in unexpected contexts; commands fire only on explicit operator invocation.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (readlink resolution checks on all 11 symlinks, `ls`/`find` confirmation of canonical targets and project-side runtime dependencies, `git diff --name-only` on the session commits, `wc -l` line counts, and grep of wrap-session dependency references). No training-data fallback was used on fetch/read failures.
