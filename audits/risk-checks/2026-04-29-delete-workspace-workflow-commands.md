# Risk Check — 2026-04-29

## Change

End-of-session change set for 2026-04-29, repo-documentation project. The only in-class structural change is the deletion of four workspace-root slash commands as part of the workflows/ folder deprecation:

- `.claude/commands/document-workflow.md` (DELETED)
- `.claude/commands/improve-workflow.md` (DELETED)
- `.claude/commands/new-workflow.md` (DELETED)
- `.claude/commands/status.md` (DELETED)

Context: these four commands operated on the workspace-root `workflows/` folder structure, which is no longer actively used. The decision to deprecate the workflows/ folder was made earlier in the session (logged as Decision #21 in `projects/repo-documentation/logs/decisions.md`). The corresponding entries in `projects/repo-documentation/output/phase-1/components/commands.md` were marked `Status: deprecated`. The `workflows/` folder itself still exists at workspace root — the operator will run `rm -rf workflows/` manually in terminal post-session (workspace permissions block rm -rf from Claude Code).

These four commands were workspace-root only (not in `ai-resources/.claude/commands/`), so their deletion does not affect the canonical shared command library or any other project. They are not auto-synced. No project depends on them.

Other session changes (out of scope for risk-check change classes per `ai-resources/docs/audit-discipline.md`): edits to Phase 1 documentation artifacts inside `projects/repo-documentation/output/phase-1/`; updates to `projects/repo-documentation/references/documentation-structure.md`; log appends to `projects/repo-documentation/logs/session-notes.md` and `logs/decisions.md`.

No changes in scope: hook edits (none), permission changes (none), cross-cutting CLAUDE.md edits (none), new commands/skills (none added — only deletions), new symlinks (none), new automation with shared-state effects (none).

## Referenced files

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/document-workflow.md` — not yet present (deleted)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/improve-workflow.md` — not yet present (deleted)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/new-workflow.md` — not yet present (deleted)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/status.md` — not yet present (deleted)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/output/phase-1/components/commands.md` — exists (updated; not in-scope class but referenced for context)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Pure deletion of four workspace-root, non-auto-synced commands; risk profile is low across four dimensions, with one Medium concern around three downstream `/status` references in `ai-resources/` that may have intended the deleted local command rather than the Claude Code built-in.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Pure deletion. No content added to any always-loaded file. Verified: workspace `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md` and project `projects/repo-documentation/CLAUDE.md` not edited (CHANGE_DESCRIPTION: "cross-cutting CLAUDE.md edits (none)").
- No new hooks; CHANGE_DESCRIPTION explicitly: "hook edits (none)".
- Removed files were workspace-root commands — invoked on-demand only when the operator types `/document-workflow`, `/improve-workflow`, `/new-workflow`, `/status`. Pay-as-used cost; no auto-load.
- Net effect on per-session token cost: marginally negative (slash-command discovery surface shrinks by 4 entries).

### Dimension 2: Permissions Surface
**Risk:** Low

- No permission entries added or removed. CHANGE_DESCRIPTION: "permission changes (none)".
- Workspace `.claude/settings.json` reviewed (read-only): unchanged. The `defaultMode: bypassPermissions` posture and the existing allow-list are unaffected by file deletions.
- No new tool patterns introduced — deletion only.

### Dimension 3: Blast Radius
**Risk:** Medium

Files touched directly: 4 command files deleted; 1 documentation registry already updated (`projects/repo-documentation/output/phase-1/components/commands.md`, entries 525–594, all four marked `Status: deprecated` with the "Removed 2026-04-29" line).

Inbound reference enumeration (grep across `ai-resources/.claude`, `ai-resources/skills`, `ai-resources/workflows`, `ai-resources/docs`, plus all project workspaces, excluding the historical `ai-resources/audits/` files and the `repo-documentation` artifacts that already mark these deprecated):

- `/document-workflow` — **0 active operational references** in `ai-resources/.claude/`, `ai-resources/skills/`, `ai-resources/workflows/`, `ai-resources/docs/`. All hits are historical audits (`ai-resources/audits/repo-due-diligence-2026-04-{06,11,12}.md`, `innovation-registry.md`, `session-notes-archive-2026-04.md`) — read-only history, not callers.
- `/improve-workflow` — **0 active operational references**. Same pattern: only audit history.
- `/new-workflow` — **0 active operational references**. Only audit history and innovation-registry tracking.
- `/status` — **3 active operational references in `ai-resources/`**:
  - `ai-resources/.claude/commands/deploy-workflow.md:348` — "Run /status to verify the project loads correctly"
  - `ai-resources/skills/workspace-template-extractor/SKILL.md:108` — "Validation steps (run `/status`, run `/run-preparation`)"
  - `ai-resources/workflows/research-workflow/SETUP.md:153` — "Run `/status` — confirm it returns a coherent project summary"
  - Plus `ai-resources/skills/workflow-system-critic/SKILL.md:73` lists `/status` as a "utility command — expected, not a finding"

  Whether these refer to the deleted workspace command or to a Claude Code built-in `/status` is ambiguous on text alone. The deleted command's purpose ("Show current status of all workflow projects" — `commands.md:590`) plausibly matches the SETUP.md "coherent project summary" phrasing. This is the medium-risk locus.

- Contract: workspace-root command-set was already documented in the project registry as a tier; the deprecated entries remain in `commands.md` with a removal-date marker. Backwards-compatible documentation update.

- No project's `.claude/commands/` references these files (verified — only `projects/nordic-pe-landscape-mapping-4-26/.claude/commands/status.md` exists, which is a project-local copy, not a reference). Workspace-root commands are not auto-synced (CHANGE_DESCRIPTION: "They are not auto-synced. No project depends on them.").

Risk classified Medium because of the 3 active `/status` references in `ai-resources/` whose target is ambiguous between the deleted local command and the built-in.

### Dimension 4: Reversibility
**Risk:** Low

- All four deletions are tracked git operations. `git revert` of the deletion commit fully restores the four files to their pre-deletion content.
- No state propagated beyond the local repo: no `git push` is part of the change (commit-only; push is a separate operator-gated step per workspace `Commit behavior` rule).
- No external writes, no hooks fired, no automation triggered.
- One incidental cleanup if reverted: the `Status: deprecated` markers in `projects/repo-documentation/output/phase-1/components/commands.md` (lines 534, 549, 564, 592) would need to be reverted to `Status: draft` to remain consistent. Trivial — one Edit per entry, or a paired revert of the documentation commit.
- The `workflows/` directory itself remains on disk (operator runs `rm -rf` manually post-session per CHANGE_DESCRIPTION). Until that runs, even the deleted commands' rationale is partially recoverable from the still-present folder content.

### Dimension 5: Hidden Coupling
**Risk:** Low

- No new contract introduced. Deletions remove existing surface; they do not add markers, parse formats, or filename conventions.
- Established convention assumed: workspace-root commands are not auto-synced (CHANGE_DESCRIPTION: "not auto-synced") — confirmed by inspection of the workspace command-set and by the project registry's three-tier model (`commands.md:12`: "ai-resources/.claude/commands/ (39 canonical) + workspace root .claude/commands/ (7 workspace-specific) + project .claude/commands/ (1 project-local)"). Tier separation explicit.
- No silent auto-firing — slash commands are explicitly invoked.
- No functional overlap created. The `/status` ambiguity flagged in Dimension 3 is a documented-reference issue, not coupling created by this change — the references existed before deletion and the change merely makes the local command unavailable as a candidate target.
- The registry update at `projects/repo-documentation/output/phase-1/components/commands.md` is the explicit documentation companion to the change — contract is named at the change site.

## Mitigations

- **Mitigation for Dimension 3 (Blast Radius):** Resolve the `/status` reference ambiguity at the three active sites in `ai-resources/`. Read each site (`ai-resources/.claude/commands/deploy-workflow.md:348`, `ai-resources/skills/workspace-template-extractor/SKILL.md:108`, `ai-resources/workflows/research-workflow/SETUP.md:153`), determine whether the intent was the deleted workflow-`status` command or the Claude Code built-in `/status`, and either (a) keep the reference as-is if the built-in was meant, or (b) replace the reference with a description of the verification step (e.g., "verify the project loads correctly" without naming a slash command) if the deleted local command was meant. Document the decision in a turn summary or commit message. Apply before landing the workflows/ folder removal `rm -rf` in the post-session terminal step.

## Recommended redesign

(Not applicable — verdict is PROCEED-WITH-CAUTION.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references from grep output (e.g., `commands.md:534/549/564/592` for the deprecated entries; `deploy-workflow.md:348`, `workspace-template-extractor/SKILL.md:108`, `research-workflow/SETUP.md:153` for the `/status` references), settings.json read showing no permission changes, decisions.md line 28 for Decision #21 confirming operator approval, and CHANGE_DESCRIPTION verbatim quotes. No training-data fallback used.
