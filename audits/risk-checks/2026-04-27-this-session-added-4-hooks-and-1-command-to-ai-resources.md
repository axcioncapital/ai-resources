# Risk Check — 2026-04-27

## Change

This session added 4 hooks and 1 command to ai-resources canonical: coach-reminder.sh (PostToolUse Write nudge), friction-log-auto.sh (PreToolUse Skill), log-write-activity.sh (PostToolUse Write logger), improve-reminder.sh (PostToolUse Write nudge), and save-session.md command. These are new shared resources that deploy to all future projects via /new-project and /deploy-workflow. Hook registration in ai-resources/.claude/settings.json is pending operator approval (Autonomy Rule #8).

## Referenced files

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/coach-reminder.sh` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/friction-log-auto.sh` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/improve-reminder.sh` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/log-write-activity.sh` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/save-session.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/settings.json` — exists (registration changes pending)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The graduated artifacts themselves are well-guarded and cheap to fire, but the change description misclassifies two hook events (PostToolUse vs. Stop), and the deployment path through `/new-project` / `/deploy-workflow` will leave hooks copied-but-unregistered in every future project unless registration semantics are decided up front.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- Per-Write overhead is bounded for `coach-reminder.sh`: `jq` parse + filename regex check + early exit when path does not match `session-notes\.md` (line 13). On typical Writes the script exits at line 13 — single `jq` + one `grep` per Write, ~5–10ms.
- `improve-reminder.sh` is even cheaper per-call: `jq` + one `grep -qE` on a path regex (`improve-reminder.sh:16`), then exit. Sentinel `/tmp/claude-improve-reminded-$PPID` (line 8) means at most one fire per session.
- `friction-log-auto.sh` runs only on `Skill` invocations (PreToolUse Skill matcher), not every tool call. Fast path exits at line 23 when the command file lacks `friction-log: true`. Today only one canonical command has that flag (`/cleanup-worktree.md`), so most Skill invocations exit fast.
- `log-write-activity.sh` runs per Write/Edit but exits early when `$PROJECT_DIR/logs/friction-log.md` is absent (line 26) or the file lacks `#### Write Activity` (line 27). For projects without an active friction session this is `[ -f ]` + `grep -q` — sub-millisecond.
- `save-session.md` is on-demand only — invoked by `/save-session`, no ongoing token cost. Its body is ~60 lines (`save-session.md:1–60`); only loaded when the operator runs the command.
- Net: full per-tool-call hook stack on Write is `coach-reminder` + `improve-reminder` + `log-write-activity`. Each does one `jq` + one `grep`. On idle Writes the marginal session cost is small but non-zero, and it scales with Write volume across every deployed project.
- The CHANGE_DESCRIPTION misclassifies `coach-reminder.sh` and `improve-reminder.sh` as PostToolUse Write nudges. In `projects/buy-side-service-plan/.claude/settings.json` they are registered under **Stop**, not PostToolUse (settings.json lines 79–101). Stop fires once at session end — far cheaper than per-Write. If the canonical registration follows the source project's convention (Stop), per-call cost claims here are conservative.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow` / `ask` / `deny` changes in `ai-resources/.claude/settings.json` are described or implied. Hooks invoke `bash $CLAUDE_PROJECT_DIR/.claude/hooks/...`; the existing canonical settings already authorize `Bash(*)` (line 39).
- The hooks read `$CLAUDE_PROJECT_DIR/logs/...` and write to logs/sentinels in `/tmp/`. These paths fall inside the existing `Edit(logs/**)` / `Write(logs/**)` allow rules (lines 19–20).
- `/tmp/` writes (sentinel files in `coach-reminder.sh:7`, `improve-reminder.sh:8`) are not constrained by the settings allowlist (Bash subprocess writes), so no new permission entry is needed.
- No external API calls, no cross-repo writes, no MCP server access introduced.

### Dimension 3: Blast Radius
**Risk:** Medium

- Direct files touched: 4 hooks + 1 command in `ai-resources/.claude/`. Plus a pending edit to `ai-resources/.claude/settings.json` (registration).
- Deployment vectors enumerated: `/new-project` (`new-project.md`, 527 lines) and `/deploy-workflow` (`deploy-workflow.md`, 325 lines). Both reference hook copying.
  - `deploy-workflow.md:92–101` shows the hook-copy loop — every file under `ai-resources/.claude/hooks/` (except 3 excluded) is copied into the deployed project. The 4 graduated hooks will be copied automatically.
  - `deploy-workflow.md:118–124` warns: hooks copied without `settings.json` entries will not fire — registration is a manual step.
  - `new-project.md:209` describes the SessionStart auto-sync hook for commands/agents — this means `save-session.md` will automatically symlink into every project on next session start.
- Existing project settings.json files: 9 found under `projects/*/.claude/settings.json`. The buy-side-service-plan settings.json registers all four hooks; the other 8 do not. Until registration is added to either each project's settings.json or to ai-resources canonical, those 8 projects will receive copied hook files without activation.
- Contract dependencies (greps within `ai-resources/`):
  - `coaching-log.md` referenced by 1 canonical command (`coach.md`) and `repo-dd.md` log sweep. Hook gracefully handles absence (`coach-reminder.sh:23 if [ -f "$COACHING_LOG" ]`).
  - `friction-log: true` frontmatter found in 1 canonical command (`cleanup-worktree.md`) and 13 buy-side-service-plan commands. Hook gracefully handles absence.
  - `session-notes.md` is a workspace convention but not universally present in every project. Hook handles via `2>/dev/null || echo "0"` (`coach-reminder.sh:20`).
  - `friction-log.md`, `improvement-log.md`, `coaching-log.md` — none of these are required by the hooks; all are gated by `[ -f ]` checks.
- The CHANGE_DESCRIPTION's event-classification mismatch (PostToolUse vs. Stop for two of the hooks) means the registration plan is not yet pinned down. Operator decisions during registration will determine actual fan-out.

### Dimension 4: Reversibility
**Risk:** Medium

- Removing the hooks from `ai-resources/.claude/hooks/` is a clean `git revert` — the files are tracked.
- Removing registration from `ai-resources/.claude/settings.json` is also a clean revert.
- Sentinel files in `/tmp/` (`/tmp/claude-coach-reminded-$PPID`, `/tmp/claude-improve-reminded-$PPID`) auto-clean on OS reboot but persist across sessions on the same boot. Manual cleanup possible but typically unnecessary — they're idempotent markers.
- Append-only mutations: `friction-log-auto.sh` appends a session block to `$PROJECT_DIR/logs/friction-log.md` (lines 42–53); `log-write-activity.sh` appends per-Write entries (line 35). These entries are not removed by reverting the hooks — they remain in any project where the hooks fired. Cleanup requires manually editing each project's `friction-log.md`.
- Once `/deploy-workflow` runs against a project, the four hook scripts are physically **copied** (not symlinked — `deploy-workflow.md:92` says "Hooks (copy — not symlinked)"). Reverting the canonical files does **not** retract them from already-deployed projects. Each project must be cleaned individually.
- The `save-session.md` command is symlinked via the auto-sync SessionStart hook (`new-project.md:209`), so revert + next session start will retract it from active projects automatically — easier path.
- Net: reverting the hooks is a multi-step rollback if any project has already deployed them. Reverting the command is clean.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Event classification mismatch in the change description.** CHANGE_DESCRIPTION states `coach-reminder.sh (PostToolUse Write nudge)` and `improve-reminder.sh (PostToolUse Write nudge)`. Source project registration in `projects/buy-side-service-plan/.claude/settings.json` lines 79–101 places **both under `Stop`**, not PostToolUse. Whichever registration the operator picks for ai-resources canonical will determine fire frequency and side-effect timing — and they are materially different (per-Write vs. once-at-session-end). Documenting the wrong intent in the change record is a hidden-coupling failure: future readers will not know which event was registered or why.
- **`save-session.md` references `/logs/scratchpads/{...}` (line 7) with a leading slash.** This is an absolute path, not a project-relative path. No project in the workspace currently has `/logs/scratchpads/` at the filesystem root. The intended convention is presumably `logs/scratchpads/` (project-relative). Calling this out: the contract is ambiguous as written and a fresh project will resolve `/logs/scratchpads/` against `/` (filesystem root), which will fail silently or write outside the project.
- **`improve-reminder.sh` line 16 hardcodes a path regex** `/(approved|output|report/chapters|final/modules)/`. These directory names are research-workflow / draft-pipeline-shaped — not universal project conventions. A fresh advisory or planning project that does not produce files under those directories will never see the reminder, and the operator will not know why. The regex is undocumented at the change site.
- **`friction-log-auto.sh` line 16 assumes `$PROJECT_DIR/.claude/commands/$SKILL_NAME.md` exists** when a Skill is invoked. After `/new-project` deployment, commands are *symlinked* into the project (per `new-project.md:209`), so the `[ -f ]` check works through symlinks — but this is implicit, not documented in the hook itself.
- **No corresponding documentation update is described.** The CHANGE_DESCRIPTION mentions hook registration in `ai-resources/.claude/settings.json` is pending, but does not mention updating `ai-resources/CLAUDE.md`, `docs/permission-template.md`, or any operator-facing documentation explaining what these hooks do, when they fire, and how to disable them per-project. Future operators encountering the hooks will have to read the script bodies to understand behavior.
- **Functional overlap potential:** `coach-reminder.sh`, `improve-reminder.sh`, and the existing canonical `check-stop-reminders.sh` (registered under Stop in ai-resources canonical settings.json line 79–88) all attach to session-end events. If `coach-reminder.sh` and `improve-reminder.sh` register under Stop alongside `check-stop-reminders.sh`, three Stop-event hooks will run sequentially and may emit overlapping messages. The interaction is not described.
- The innovation-sweep audit (`audits/innovation-sweep-buy-side-service-plan-2026-04-27.md` lines 22, 173) explicitly flags `hooks.PreToolUse[matcher=Skill]` settings-pattern graduation as a separate decision. Graduating the hook script without a paired registration spec leaves a half-finished migration.

## Mitigations

- **Hidden coupling — fix the event-classification record before registering.** Before editing `ai-resources/.claude/settings.json`, correct the CHANGE_DESCRIPTION (and the session note that records this work) to state the actual events: `coach-reminder.sh` Stop, `improve-reminder.sh` Stop, `friction-log-auto.sh` PreToolUse Skill, `log-write-activity.sh` PostToolUse Write+Edit. The settings.json registration block must match.
- **Hidden coupling — fix the absolute-path in `save-session.md`.** Change `/logs/scratchpads/{...}` to `logs/scratchpads/{...}` (project-relative) in line 7 before any project picks up the symlinked command. Verify no other absolute-rooted log paths in the file.
- **Hidden coupling — document the path-regex in `improve-reminder.sh`.** Either add a comment listing the assumed directory names and noting they are research-workflow-shaped, OR move the regex into a project-overridable env var. Operator decision; the documented version is acceptable.
- **Hidden coupling — disambiguate Stop-hook stacking.** Before registering `coach-reminder.sh` and `improve-reminder.sh` under Stop in canonical settings.json, confirm interaction with the existing `check-stop-reminders.sh` Stop hook. Either fold the two new reminders into `check-stop-reminders.sh`, or add explicit ordering/dedup so the operator does not see three messages on session end.
- **Blast radius — declare the registration deployment policy.** Decide once: do projects deployed via `/deploy-workflow` get the new hook entries auto-merged into their `settings.json`, or do operators register per-project? `deploy-workflow.md:118–124` currently says manual registration. If that stays, document in the deploy-workflow runbook that these four hooks ship copied-but-unregistered and require operator action; otherwise extend the deploy step to register them. The current half-state silently breaks the "deploys to every project" intent stated in the CHANGE_DESCRIPTION.
- **Reversibility — note the append-only log entries.** Add a one-line note to the session note that revert leaves friction-log.md and improvement-log.md entries behind; if the hooks fire in projects before being reverted, those projects need manual log cleanup.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.
