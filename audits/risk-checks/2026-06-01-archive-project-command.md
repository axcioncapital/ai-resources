# Risk Check — 2026-06-01

## Change

New command ai-resources/.claude/commands/archive-project.md — a capstone command that removes a finished project's skill symlinks and moves the whole project folder (including its independent .git repo) outside the active workspace to ~/Claude Code/Axcion AI Archive/{name}/, after a blocking pre-archive checklist (clean tree, pushed, no pending graduations) and a mandatory operator confirmation gate. Writes a permanent index at ai-resources/logs/archived-projects.md and a restore manifest. Assess the structural risk of adding this command.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/archive-project.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/archived-projects.md — not yet present

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A well-guarded operator-invoked command whose only elevated dimension is reversibility — the move out of the workspace plus the append-only permanent index cannot be undone by `git revert` alone, but the command's own manifest + un-archive recipe is a viable paired mitigation.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Pay-as-used command, never auto-loaded. It is a slash command under `.claude/commands/`, invoked manually one project per run (`Input: $ARGUMENTS — the project directory name ... Required`, line 11). No SessionStart/Stop/PreToolUse/UserPromptSubmit hook is registered.
- Adds nothing to always-loaded CLAUDE.md and declares no `@import`. The workspace CLAUDE.md and ai-resources CLAUDE.md are unchanged by this artifact (grep for `archive-project` returns only the command file itself).
- `model: sonnet` frontmatter (line 2) — orchestration/mechanical tier, the cheap tier, consistent with the repo's tiering rule for log-append/dispatch commands.

### Dimension 2: Permissions Surface
**Risk:** Low

- No settings.json `allow`/`ask`/`deny` edits are part of this change (grep of both settings layers shows no archive-related entries; the change is a single command file).
- Every operation the command runs is already authorized. ai-resources `.claude/settings.json` allows `Bash(*)` and `defaultMode: bypassPermissions` (verbatim: `"Bash(*)"`, `"defaultMode": "bypassPermissions"`). The `mv`, `find -type l -delete`, `git`, and `cp` calls need no new grant.
- The denied pattern `Bash(rm -rf *)` (present in both ai-resources and workspace settings) is never invoked — the command explicitly refuses the destructive fallback: `Never fall back to cp -r && rm -rf.` (line 227) and uses plain `mv` (line 224) plus `find ... -delete` for symlinks only (line 208).
- No scope escalation (no project→user settings move), no MCP, no external API. The only "external" effect is a filesystem move to a sibling directory on the same machine.

### Dimension 3: Blast Radius
**Risk:** Low

Enumeration (grep/glob across `ai-resources/`):
- `grep -rl "archive-project"` → 1 file: `.claude/commands/archive-project.md` (self only). No other command, skill, agent, hook, or doc references it. Zero external callers.
- `grep -rl "archived-projects"` → 1 file (self only). The new permanent index has no readers other than this command.
- `grep -rl "unarchive-project"` → 1 file (self only). Confirms the documented design choice "There is no /unarchive-project — the manifest IS the restore recipe" (line 9); no caller expects an unarchive command.
- Downstream commands the command names all exist on disk: `/graduate-resource` (`.claude/commands/graduate-resource.md` present), `/fix-symlinks` (present), `/log-sweep` (present). No dangling references.
- The command reads project-local conventions (`logs/innovation-registry.md`, `reference/skills/` symlink dir, `logs/usage-log.md`) but writes only to the archived project, the new index, and a working manifest under `audits/working/` (which exists). It does not modify any shared command/skill/hook contract.
- No contract change: it introduces a new index/manifest format consumed only by itself; no existing schema, heading, or invocation syntax is altered.

### Dimension 4: Reversibility
**Risk:** High

- The core operation moves a whole directory OUTSIDE the git-tracked workspace: `mv "$PROJ" "$DEST"` where `DEST="$(dirname "$WORKSPACE")/Axcion AI Archive/${NAME}"` (lines 38–39, 224). `git revert` inside the workspace cannot restore a directory that was moved to a sibling path the workspace repo does not track — and the command refuses to run if the parent repo tracks the project (lines 58–62), so by construction there is no parent-repo commit to revert.
- The index write is an append-only mutation of a permanent log: `Append-to-END. The index is permanent — never rolled by check-archive.sh.` (line 253). A revert of the index commit leaves the move itself untouched, and conversely re-running cannot cleanly de-append.
- Symlinks are physically deleted before the move: `find "$SYMLINK_DIR" -maxdepth 1 -type l -delete` (line 208). Restoring them requires re-running `ln -s` per the manifest table, not a git operation.
- State propagates beyond the local workspace by design: Step 2(b) blocks unless the project is pushed to a remote (`No upstream/remote tracking branch ... push to a remote first`, lines 82–84). The pushed remote state is real external state.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- One known staging-contract coupling, and it is documented at the change site rather than hidden: the command itself warns that `/wrap-session`'s enumerated stage list does not cover the new index — `Stage {INDEX} explicitly — /wrap-session's enumerated stage list does not cover it.` (line 291). Confirmed against `wrap-session.md` line 340, whose always-staged list enumerates specific log files and does not include `archived-projects.md`. So the index will not be auto-staged by a wrap; the operator must stage it. Documented = Medium, not High.
- Implicit dependency on the project convention `reference/skills/` as the symlink home (line 131). If a project keeps skill symlinks elsewhere, only stray links are counted (not removed) and move with the folder (lines 144–146, 299) — a benign degradation, not silent breakage.
- Implicit dependency on the innovation-registry marker strings `triaged:graduate` and `graduated` for the pending-graduation gate (lines 93–96). If the registry's marker convention changes, this gate silently mis-counts. This is a real convention dependency on another component's output format.
- No silent auto-firing: the command is operator-invoked with a mandatory `[y/n]` gate (line 198) and a `--dry-run` mode (line 14). No hook ordering or cross-session side effect.
- No functional overlap: scope note explicitly disjoint from `/log-sweep` (logs) and `/wrap-session` (sessions) (line 9).

## Mitigations

- **Reversibility (High → Medium):** Treat the per-project restore manifest as the operative rollback artifact, and verify it exists before confirming the gate. The command already writes `$MANIFEST` BEFORE any destruction (Step 3, lines 149–171) with a full symlink restore table and an explicit un-archive recipe (`mv "{DEST}" "{PROJ}"` → `ln -s` per row → `/fix-symlinks --dry-run`), copies it into the moved project as `.archive-manifest.md` (line 250), and the no-remote BLOCK (lines 82–84) guarantees a pushed remote copy survives. Operator action before landing: in the first real (non-dry-run) invocation, confirm the manifest file is present and the remote is reachable at the Step 4 gate, and keep the index commit and any project-side commits as separate commits so the move and the index append can be reasoned about independently.
- **Reversibility (supporting):** Before first production use, run once with `--dry-run` on the target project to confirm the plan, symlink count, and destination path are correct without destroying anything (line 197 stops the flow on dry-run).
- **Hidden coupling (Medium, optional hardening):** When landing, add a one-line note in `/wrap-session`'s staging section (or accept the in-command warning at line 291 as sufficient) so the permanent index is reliably staged and not lost as an untracked file after an archive run.

## Recommended redesign

N/A — verdict is PROCEED-WITH-CAUTION.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references into archive-project.md, grep counts across ai-resources/, verbatim quotes from the command and settings.json, and confirmation that referenced dependency commands and the audits/working/ directory exist). The index file `archived-projects.md` is tagged not-yet-present and was not read; its risk contribution was assessed from the command's described write behavior (Step 8) per protocol. No training-data fallback was used.

## Architectural Commentary

_System-owner second opinion (`/consult` not deployed — obtained via the `system-owner` agent, Function B pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION. Full advisory: `projects/axcion-ai-system-owner/output/consultations/consult-2026-06-01-risk-check-second-opinion-archive-project.md`._

**Concurs with PROCEED-WITH-CAUTION.** The one genuine hazard is the one the verdict names: the move leaves git tracking and the index is permanent, so `git revert` cannot restore state. Reversibility rides entirely on the command's own manifest + remote backup, not on git. A move-out-of-tree crosses into shared-state territory.

**The three mitigations are the right path and are already satisfied by the build:**
1. Manifest-before-destruction (Step 3) + no-remote hard BLOCK (Step 2b) + separate index/project commits — satisfied.
2. `--dry-run` stops before any mutation (Step 4) — supported.
3. Index staging — Step 9 emits the explicit staging note (correct for v1; do not build `/wrap-session` integration yet). Residual risk is operator-dependent.

**Risk the dimension review missed — dangling static back-references:**
- `/fix-symlinks`, `/log-sweep`, `/friday-checkup`, and the auto-sync hook enumerate `projects/*/` live, so they self-heal after a move — no dangling reference there.
- Two canonical grounding docs hard-list active projects by name and will silently assert an archived project is still active: `projects/repo-documentation/vault/risk-topology.md` (§ dependency chains / reverse map) and `repo-state.md` (§ active projects). Neither is touched by the command; both refresh only at the monthly Friday cadence. **Resolution applied:** Step 9 staging note extended to name both docs as going stale on archive (one-line addition, not a redesign).
- Innovation-registry provenance is already handled by checklist gate (f).

**Position:** proceed. Land it with the staging-note addition (applied); first real run as `--dry-run`. The end-time `/risk-check` (DR-8) still applies before commit — the verdict under review is plan-time.
