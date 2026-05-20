# Risk Check — 2026-05-20

## Change

Re-enable the SessionStart hook event in /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/settings.json (plan-time gate for harness A7 Part 2 — Phase 2 re-activation). The file currently has NO `hooks` block — all 6 hook events were removed at commit 178b293 (2026-04-28, "disabled agent harness hooks"). The proposed change restores ONLY the SessionStart event, verbatim from commit 178b293~1. That event contains 3 hooks across 2 groups: (1) an inline awk command that loads the last logs/session-notes.md entry into session context at startup; (2) .claude/hooks/sync-shared-resources.sh — symlinks any new ai-resources/.claude commands/agents into the workspace .claude/ tree; (3) .claude/hooks/session-start.sh — harness crash detection (3 indicators: uncommitted changes, in_progress current-state.json, incomplete session-log.json) and writes harness/session/startup-state.json. The other 5 hook events (SubagentStop, Stop, PreCompact, PostCompact, UserPromptSubmit) stay disabled — they belong to later harness phases. The hook fires automatically at the start of every Claude Code session opened anywhere in this workspace while the harness is still work-in-progress. Note: crash-detection indicator 1 (uncommitted changes) will fire crash_detected=true on nearly every session given normal working-tree state.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/settings.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/hooks/sync-shared-resources.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/hooks/session-start.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness/session/startup-state.json — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Restoring a verbatim SessionStart hook is mostly low-risk infrastructure, but two hazards elevate it — a self-confirmed crash-detection false-positive that will fire `crash_detected=true` on nearly every session, and the symlink side effect that `git revert` does not unwind.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- The hook fires once per session (SessionStart), not per tool call — the cheaper of the auto-load classes. CHANGE_DESCRIPTION: "fires automatically at the start of every Claude Code session opened anywhere in this workspace."
- Hook 1 (awk) injects the last `logs/session-notes.md` entry via `tail -60` of the most recent `## ` block into `additionalContext` (`178b293~1:.claude/settings.json`, SessionStart group 1, hook 1). Up to ~60 lines of session-notes prose loaded into context every session — a recurring, non-trivial per-session token cost (well above the ~50-token Medium calibration point, but bounded and once-per-session, not per-turn).
- Hook 3 (`session-start.sh`) injects a one-line `additionalContext` message (`session-start.sh:67`) — negligible token cost.
- Hook 2 (`sync-shared-resources.sh`) injects context only when `linked > 0` (`sync-shared-resources.sh:29-31`) — zero cost on the steady-state run where nothing new needs linking.
- No `@import` chain, no always-loaded CLAUDE.md edit, no subagent brief expansion. The cost is the once-per-session ~60-line notes injection.

### Dimension 2: Permissions Surface
**Risk:** Low

- The change adds a `hooks` block; it does not touch the `permissions` block. Current `settings.json` already grants `Bash(*)` (`.claude/settings.json:17`) and `defaultMode: bypassPermissions` (`.claude/settings.json:26`) — the hook commands (`awk`, `ln`, `git status`, `grep`, `mkdir`, `cat`) all fall inside already-authorized capability.
- No `allow`/`ask` entry added, no `deny` rule removed or narrowed. The four `deny` entries (`.claude/settings.json:28-32`) are unaffected.
- No scope escalation (project → user), no new external/cross-repo capability. `sync-shared-resources.sh` writes symlinks only inside the same workspace `.claude/` tree (`sync-shared-resources.sh:23`); `session-start.sh` writes only inside `harness/session/` (`session-start.sh:49-50`) — both inside the existing `Write(/Users/.../Axcion AI Repo/**)` grant (`.claude/settings.json:22`).
- Per user memory `feedback_permissive_config_philosophy.md`: the repo is intentionally permissive — this dimension carries no elevated weight here because no permission line changes at all.

### Dimension 3: Blast Radius
**Risk:** Medium

- Direct files touched: 1 (`.claude/settings.json` — add `hooks` block). The two hook scripts and `startup-state.json` already exist on disk (`ls .claude/hooks/` shows `session-start.sh` and `sync-shared-resources.sh` present; `harness/session/startup-state.json` present) — re-enabling does not modify them.
- Downstream contract consumer — `mandate-parser` skill: `.claude/skills/mandate-parser/SKILL.md` reads `harness/session/startup-state.json` at Step 1 (line 70) and branches on `crash_detected` at Step 2 (line 78: "If crash_detected=true, do NOT proceed to /clarify. Run crash recovery first."). The skill already tolerates the file being absent (SKILL.md:76, 300 — "If startup-state.json is absent, generate a session_id... set crash_detected=false"). Re-enabling the hook makes the file *present and fresh* — within the skill's expected contract, so backwards-compatible. But see Hidden Coupling: a fresh file with `crash_detected=true` flips the skill into crash-recovery mode.
- Grep enumeration across `ai-resources`, `.claude`, `harness`:
  - `startup-state.json` — 10 referencing files (mandate-parser SKILL.md, session-start command, harness roadmap/reports, session-log.json, two session-notes logs, a prior risk-check).
  - `session-start.sh` — 4 referencing files (mandate-parser SKILL.md, session-start command, friction-log, a prior risk-check).
  - `sync-shared-resources.sh` — 1 referencing file (a 2026-04-12 repo-dd audit) — effectively isolated.
- Contract shape unchanged: the hook writes the same `startup-state.json` schema (`session_id`, `timestamp`, `session_source`, `crash_detected`, `crash_reasons`) the current on-disk file already uses (`startup-state.json:1-7`). No section heading, frontmatter, or invocation-syntax change.
- The 5 other hook events stay disabled, so no SubagentStop/Stop/PreCompact/PostCompact/UserPromptSubmit caller is activated. Blast contained to SessionStart consumers only.

### Dimension 4: Reversibility
**Risk:** Medium

- The `settings.json` edit itself reverts cleanly — `git revert` on the commit removes the `hooks` block in one step.
- **`sync-shared-resources.sh` side effect is not git-revertible.** Between landing and any revert, the hook creates symlinks under `.claude/commands/` and `.claude/agents/` (`sync-shared-resources.sh:23`). Those symlinks are untracked working-tree artifacts — `git revert` of the settings change does not delete them. Manual cleanup (identify and `rm` the new symlinks) is required to fully restore prior state.
- `session-start.sh` overwrites `harness/session/startup-state.json` on every fire (`session-start.sh:50`, `cat > ... << EOF`). The file is git-tracked (last committed content dated 2026-04-28). After the hook runs once, the working copy diverges; a revert of the settings change leaves the mutated `startup-state.json` in place — one extra step (`git checkout` of that file, or accept the new content) to clean up.
- No state propagates beyond the local repo — no `git push`, no Notion write, no external POST. The 5s timeout on each hook (`178b293~1:.claude/settings.json`) bounds runtime.
- Net: revert works but requires manual cleanup of (a) any symlinks created and (b) the mutated `startup-state.json` — multi-artifact, more than one extra step, hence Medium not Low.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Crash-detection false-positive — self-confirmed by the change author.** CHANGE_DESCRIPTION states: "crash-detection indicator 1 (uncommitted changes) will fire crash_detected=true on nearly every session given normal working-tree state." `session-start.sh:29-32` sets `CRASH_DETECTED="true"` whenever `git status --porcelain` is non-empty. The live working tree right now is dirty (`git status --porcelain` returns `M logs/innovation-registry.md` and `?? logs/session-plan.md`) — so the very next session would write `crash_detected=true`. This is not a latent risk; it is a near-certain misfire.
- **Silent auto-fire into an unexpected downstream branch.** `mandate-parser/SKILL.md:78-80` reacts to `crash_detected=true` by refusing to proceed to `/clarify` and running crash recovery first. Re-enabling the hook therefore couples *every* harness session that uses mandate-parser to a crash-recovery detour triggered by ordinary uncommitted work — a behavior change that is invisible from the `settings.json` edit site alone.
- **Indicator 3 compounds the misfire.** `session-start.sh:41-45` also sets `crash_detected=true` if `harness/session/session-log.json` exists, is non-empty, and lacks a `session_completed` event. `session-log.json` exists on disk (`ls harness/session/` — 2591 bytes, dated May 11). If it lacks that event, indicator 3 fires independently of the working-tree state — a second silent path to `crash_detected=true`.
- **Three session-start mechanisms overlap.** `ai-resources/.claude/commands/session-start.md` documents a "Boundary note — three session-start mechanisms exist": the `session-start.sh` hook, the `/session-start` command, and the `mandate-parser` skill. Re-enabling the hook activates one of three partially overlapping mechanisms; the boundary is documented in the command file but NOT at the `settings.json` change site — a reader of the settings diff cannot see the overlap.
- `harness-rules.md` confirms the harness is mid-build (it governs `SubagentStop`/`PreCompact`/`PostCompact` hooks that stay disabled) — re-enabling one event of an unfinished harness means the hook fires "while the harness is still work-in-progress" (CHANGE_DESCRIPTION), so the downstream mandate-parser coupling activates before the harness is fully validated.
- Multiple implicit dependencies + silent auto-fire into an unexpected branch + a self-confirmed near-certain misfire → High.

## Mitigations

- **Dimension 5 (Hidden Coupling) — fix the indicator-1 false-positive before landing.** Do not restore `session-start.sh` verbatim. Narrow indicator 1 so a routinely-dirty working tree does not equal "crash": either (a) drop indicator 1 entirely and rely on indicators 2+3 (stale `in_progress` state, incomplete `session-log.json`), which are genuine crash signals, or (b) gate indicator 1 on a stronger signal (e.g., uncommitted changes *plus* a stale `in_progress` unit). Land the hook-event re-enable and the script fix in the same commit so the misfire never reaches a live session.
- **Dimension 5 (Hidden Coupling) — verify the mandate-parser crash branch before activation.** Before opening the next harness session, confirm `harness/session/session-log.json` either contains a `session_completed` event or is intentionally reset, so indicator 3 does not independently force `crash_detected=true`. Then run one harness session and confirm `mandate-parser` does not detour into crash recovery on a clean run.
- **Dimension 3 (Blast Radius) — smoke-test the contract once.** After landing, open one workspace session, then read `harness/session/startup-state.json` and confirm all five schema fields are present and well-formed so the 10 downstream `startup-state.json` consumers (chiefly `mandate-parser`) receive the shape they expect.
- **Dimension 4 (Reversibility) — record the rollback steps in the landing commit message.** Note that a future revert must also (a) `rm` any symlinks `sync-shared-resources.sh` created under `.claude/commands/` and `.claude/agents/`, and (b) restore or accept `harness/session/startup-state.json`, since `git revert` of the settings change alone leaves both as stale working-tree artifacts.
- **Dimension 1 (Usage Cost) — accept or trim the per-session notes injection.** The awk hook loads up to ~60 lines of `session-notes.md` every session. If that recurring cost is unwanted, trim the `tail -60` to a smaller window in the same edit; otherwise accept it explicitly as the price of last-session handoff context.

## Recommended redesign

{Omitted — verdict is PROCEED-WITH-CAUTION.}

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION and referenced files, `git show 178b293~1` for the verbatim hook block, and a live `git status --porcelain` confirming the dirty working tree). No training-data fallback was used on fetch/read failures.
