# Risk Check — 2026-05-18

## Change

Pass B — combined F5 and F4 for nordic-pe improvement-log.

F5: Edit `ai-resources/.claude/hooks/auto-sync-shared.sh` — add drift-reconciliation mode. For each command/agent target that already exists AND is a regular file (not a symlink), compute `diff` against the canonical source. If different, emit a SessionStart `additionalContext` warning message: "TEMPLATE DRIFT: <name>.md in project differs from canonical. Run /sync-workflow or replace with symlink." Do NOT auto-replace — operator approves replacement via /sync-workflow.

F4: Create `projects/nordic-pe-macro-landscape-H1-2026/.claude/hooks/backup-session-plan.sh` — a PreToolUse Write hook that copies the prior `logs/session-plan.md` to `logs/.session-plan-history/YYYY-MM-DD-HHMM.md` before each new write. Wire into project's `.claude/settings.json` PreToolUse Write matcher scoped to `logs/session-plan.md` path only.

## Referenced files

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/auto-sync-shared.sh` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/.claude/hooks/backup-session-plan.sh` — not yet present
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/.claude/settings.json` — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** F4 is cleanly isolated and low-risk; F5 modifies a SessionStart hook that runs in every deployed project and overlaps in purpose with the existing `check-template-drift.sh`, creating real blast-radius and hidden-coupling concerns that need explicit mitigation before landing.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- F5 adds a per-session `additionalContext` emission when drift is detected. The hook walker at `projects/nordic-pe-macro-landscape-H1-2026/.claude/settings.json` line 150 runs `auto-sync-shared.sh` on every SessionStart of every project that opts in via `shared-manifest.json` — message will be emitted on every session that has drifted files until resolved. Repeat message likely accrues ~50–150 tokens per affected session until operator runs `/sync-workflow`.
- F5 also adds per-session compute cost (one `diff` per pre-existing target file). For projects with ~37 commands and ~17 agents (per `repo-due-diligence-2026-04-27-project-repo-documentation.md` line 359), that's up to 54 diffs per SessionStart — measurable but bounded by the 10s timeout in `settings.json` line 151.
- F4 is a PreToolUse hook scoped to one path (`logs/session-plan.md`). Fires only on Write to that exact file — pay-as-used, no ambient cost.
- F4 wiring adds one matcher block to `.claude/settings.json`; no always-loaded CLAUDE.md content added.

### Dimension 2: Permissions Surface
**Risk:** Low

- Nordic-pe `settings.json` line 4 already grants `Bash(*)` and line 19 grants `Write`, with `defaultMode: bypassPermissions` (line 32). No new allow/deny entries required for either F4 or F5.
- F4's hook performs `cp` on a `logs/` path inside the project — within already-authorized scope.
- F5's `diff` invocation is read-only and within already-authorized scope.

### Dimension 3: Blast Radius
**Risk:** High

- `auto-sync-shared.sh` is invoked from every deployed project's SessionStart hook via the parent-walker idiom (verified at `projects/nordic-pe-macro-landscape-H1-2026/.claude/settings.json` line 150). Grep found the same wiring in `buy-side-service-plan/.claude/settings.json`, `personal/travel-os/.claude/settings.json`, `project-planning/.claude/settings.json` — at least 4 projects affected, likely more (innovation-sweep-2026-05-16.md line 36 calls this idiom "the canonical project template").
- `check-template-drift.sh` (lines 27–47) already performs the same diff-against-canonical computation but against `workflows/$TEMPLATE/.claude/` rather than `ai-resources/.claude/commands|agents/`. Both hooks now run in the same SessionStart chain (settings.json lines 144 and 150) — operator will see two separate drift messages with overlapping but non-identical scope. This is a contract-change in spirit: existing operators have a mental model of "one drift message from check-template-drift.sh"; F5 changes that.
- F4 is fully isolated: one new script file under nordic-pe, one new matcher block in one settings.json. Zero other projects affected.
- Audits already flag drift files explicitly: `repo-health-ai-resources-2026-04-24.md` line 11 names 4 byte-identical command drift files in `workflows/research-workflow/.claude/commands/`. F5 will surface these on every research-workflow-derived project's SessionStart until cleaned up — potentially noisy across multiple projects simultaneously.

### Dimension 4: Reversibility
**Risk:** Low

- F5 is a single-file edit to `auto-sync-shared.sh`. `git revert` cleanly restores prior behavior. No persistent state created — drift messages are ephemeral session output.
- F4 creates a sibling file `backup-session-plan.sh` and edits `settings.json`. `git revert` removes the settings.json change but leaves the new script file untracked if it's tracked, or removed if tracked — clean either way. The hook also creates `logs/.session-plan-history/YYYY-MM-DD-HHMM.md` files on every Write — these accumulate as ephemeral byproduct that revert does not delete. Operator can `rm -rf logs/.session-plan-history/` as a one-step cleanup.
- Neither change pushes state beyond local repo. No external writes.

### Dimension 5: Hidden Coupling
**Risk:** High

- F5 functionally overlaps with `check-template-drift.sh` (Dimension 3 detail): both run on SessionStart, both emit `additionalContext` drift messages, but they read from different canonical sources (`ai-resources/.claude/commands|agents/` vs `workflows/$TEMPLATE/.claude/`). Two systems will now both report on overlapping file sets (e.g., a command symlinked from ai-resources that also lives in a workflow template). The CHANGE_DESCRIPTION does not document this overlap or define which message takes precedence.
- F5's new behavior is undocumented in `auto-sync-shared.sh` header comments (lines 2–14). Operators reading the script will see "Walks ai-resources/.claude/{commands,agents}/ and symlinks every file..." without learning that it also reports drift. The contract change (script now has two responsibilities: sync + drift-report) is not surfaced at the change site per the CHANGE_DESCRIPTION.
- F4 wires into PreToolUse Write — the matcher must be path-scoped at the hook level (the matcher field per settings.json line 75 matches by tool name, not path). The CHANGE_DESCRIPTION says "matcher scoped to `logs/session-plan.md` path only" but Claude Code matcher semantics scope by tool, not path — path-filtering happens inside the hook script via `jq -r '.tool_input.file_path'`. Pre-existing hooks at lines 66 and 79 demonstrate this pattern. If F4's wiring assumes matcher-level path scoping, the hook will fire on every Write tool call (cost spike) until the path filter is moved inside the script.
- F4 introduces a new directory convention `logs/.session-plan-history/` that no other tooling knows about. Not load-bearing for any caller, but `check-archive.sh` (referenced in settings.json line 156) may eventually need to know about this directory to avoid archiving its contents.

## Mitigations

- **Dimension 3 (F5 blast radius):** Before landing F5, deduplicate against `check-template-drift.sh`. Either (a) put the drift-reconciliation logic inside `check-template-drift.sh` (which already does the diff work) and leave `auto-sync-shared.sh` single-purpose, or (b) explicitly document in both scripts which canonical source each checks and add a guard so the two messages don't both fire for the same file. Operator runs one deployed project (e.g., nordic-pe) end-to-end after the change to confirm only one drift message surfaces per drifted file.
- **Dimension 5 (F5 hidden coupling):** Update the header comment block in `auto-sync-shared.sh` (lines 2–14) to document the new drift-reconciliation responsibility and the message format. The contract becomes self-describing at the change site.
- **Dimension 5 (F4 matcher semantics):** Verify the F4 wiring uses tool-name matcher `"Write"` plus an in-script path filter pattern (mirroring settings.json line 66 and 79 idioms), NOT a path-scoped matcher value. If the implementation as described assumes matcher-level path scoping, rewrite the hook to filter via `jq -r '.tool_input.file_path'` before doing any work.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references from `auto-sync-shared.sh`, `check-template-drift.sh`, nordic-pe `settings.json`, and 4 grep'd audit reports). No training-data fallback was used.
