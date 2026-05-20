# Risk Check — 2026-05-20

## Change

END-TIME GATE for harness A7 Part 2 — Phase 2 re-activation. The executed change set diverged from the plan-time risk-check (which assessed re-enabling a SessionStart hook; the operator redirected mid-session to a harness-entry-trigger design instead). Assess the ACTUAL executed change set:

1. .claude/hooks/session-start.sh — dropped crash-detection indicator 1 (uncommitted changes -> crash_detected=true), which fired on nearly every session given a routinely-dirty working tree. The two surviving indicators (stale in_progress current-state.json; incomplete session-log.json) were renumbered 1 and 2. Added a 3-line explanatory comment. Net: the script no longer false-positives on normal working state. The script's behavior is otherwise unchanged (still writes harness/session/startup-state.json, still exits 0).

2. .claude/skills/mandate-parser/SKILL.md — Step 1 retitled "Generate and read startup state"; it now runs `bash .claude/hooks/session-start.sh` at harness entry, then reads startup-state.json. Prerequisites item 2 and the Output Summary table updated to match. session-start.sh is NO LONGER wired as a SessionStart hook anywhere — crash detection runs only when the mandate-parser skill is invoked (a real harness session), not on every workspace session.

3. ai-resources/.claude/commands/session-start.md — one boundary-note line corrected: session-start.sh is described as run by the mandate-parser skill at harness entry (its Step 1), not as an auto-firing SessionStart hook.

4. harness/prep/harness-roadmap.md — A7 Part 2 marked complete; Open Decision #3 resolved; Phase 2 status set to Done. Documentation only.

5. .claude/settings.json — NO net change. A SessionStart hooks block was added then reverted within the session; the committed file is unchanged from HEAD. No hooks are enabled in the workspace.

Stale harness session state (startup-state.json, mandate.json, session-log.json — all untracked) was deleted as part of the reset; no tracked-file impact. harness/learning/mandate-history.jsonl received a validation entry that was then removed (restored to its original 1 line).

Net effect vs. the plan-time assessment: the workspace-wide auto-firing SessionStart hook is NOT introduced. Crash detection is now opt-in per harness session. The plan-time risk-check's top concern (High hidden coupling — hook fires every session, mandate-parser detours into crash recovery on a dirty tree) is structurally eliminated by this design. All 3 Phase 2 sufficiency criteria were validated against the minimal-markdown test workflow before this gate.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/hooks/session-start.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/skills/mandate-parser/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-start.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness/prep/harness-roadmap.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/settings.json — exists

## Verdict

GO

**Summary:** The executed change set is a contained, opt-in redesign that structurally eliminates the plan-time risk-check's only High concern (a workspace-wide auto-firing hook) — every dimension lands Low, with the single Medium-leaning concern (append-only learning-log mutation) confirmed reverted to baseline.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No content added to an always-loaded file. Workspace `CLAUDE.md` and `ai-resources/CLAUDE.md` are not in the diff (`git diff --stat HEAD` lists only `session-start.sh`, `mandate-parser/SKILL.md`, two `innovation-registry.md` files, and `harness-roadmap.md`).
- No auto-load hook is registered. Committed `.claude/settings.json` has no `hooks` block — only `permissions` and `env` keys (`.claude/settings.json:1-38`). The CHANGE_DESCRIPTION states the SessionStart block "was added then reverted within the session; the committed file is unchanged from HEAD" — confirmed: `session-start.sh` does not appear in any `settings.json` (grep for `SessionStart` across all settings files returns only `ai-resources/.claude/settings.json`, whose SessionStart hook targets `friday-checkup-reminder.sh`, not `session-start.sh`).
- `session-start.sh` now runs only when the `mandate-parser` skill is invoked — i.e., only in real harness sessions, not per-session workspace-wide. This is pay-as-used: cost is incurred once per harness session, not once per every Claude Code session opened in the workspace.
- The `mandate-parser` SKILL.md edit adds ~7 lines to Step 1 and Prerequisites (`SKILL.md:42`, `SKILL.md:68-74`, `SKILL.md:318`). SKILL.md loads only when the skill is invoked — not always-loaded — so the added tokens are scoped to harness sessions, not every turn.
- The hook script itself emits a one-line `additionalContext` message (`session-start.sh:64`) — negligible, and only when the script runs inside a harness session.

### Dimension 2: Permissions Surface
**Risk:** Low

- No permission changes. The committed `.claude/settings.json` is unchanged from HEAD (`git status --porcelain` shows `.claude/settings.json` is NOT in the modified set — the modified tracked files are `session-start.sh`, `mandate-parser/SKILL.md`, both `innovation-registry.md` files, and `harness-roadmap.md`).
- No `allow` / `ask` entry added; no `deny` rule removed or narrowed. The `permissions` block (`.claude/settings.json:2-34`) retains all four `deny` rules including `Bash(git reset --hard *)`, `Bash(git checkout *)`, `Bash(git push*)`.
- The new invocation `bash .claude/hooks/session-start.sh` (`SKILL.md:72`) is already authorized — `Bash(*)` is in the workspace `allow` list (`.claude/settings.json:17`). The script writes only inside `harness/session/` (`session-start.sh:46-55`), inside the existing `Write(/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/**)` grant (`.claude/settings.json:22`).
- No scope escalation (project → user), no new external or cross-repo capability. The change actually *narrows* the de facto execution surface relative to the plan-time design: a SessionStart hook would have run automatically on every workspace session; the executed design runs the script only on explicit skill invocation.

### Dimension 3: Blast Radius
**Risk:** Low

- Direct tracked files touched: 5 (`git diff --stat HEAD`) — `.claude/hooks/session-start.sh` (-13/+8 net behavior), `.claude/skills/mandate-parser/SKILL.md` (+11/-4), `harness/logs/innovation-registry.md` (+1, log append), `harness/prep/harness-roadmap.md` (+14/-14, documentation), `logs/innovation-registry.md` (+5, unrelated log append from prior sessions, not part of this change). The `ai-resources/.claude/commands/session-start.md` boundary-note correction described in item 3 is already present on disk (`session-start.md:10` reads "run by the `mandate-parser` skill at harness entry (its Step 1)") — it does not appear in `git diff` and was committed in an earlier commit (`5721461`/`14a4eb9`).
- Callers of `session-start.sh` enumerated via grep across workspace + `ai-resources`: 8 referencing files. Of these, only ONE is a live caller — `mandate-parser/SKILL.md` (Step 1, `SKILL.md:72`). The rest are documentation / logs / prior risk-checks: `harness-roadmap.md` (roadmap doc), `harness/reports/2026-05-08-prep-components-fit-review.md` and `-fix-plan.md` (historical reports), `logs/innovation-registry.md` and `harness/logs/innovation-registry.md` (registry logs), `logs/session-plan.md` and `logs/session-notes.md` (session logs), and two `ai-resources/audits/risk-checks/` files (prior risk-checks). None of the documentation references requires modification to keep the system working — they describe state, they do not invoke it.
- No SessionStart hook registration references `session-start.sh` in any `settings.json` (grep for `SessionStart` in all `settings.json`/`settings.local.json` returns `ai-resources/workflows/research-workflow/.claude/settings.json` and `ai-resources/.claude/settings.json`; the latter's SessionStart hook command is `bash $CLAUDE_PROJECT_DIR/.claude/hooks/friday-checkup-reminder.sh` — a different script). So zero hook-registration callers depend on `session-start.sh`.
- Contract change check — the crash-detection contract: `session-start.sh` writes `startup-state.json` with keys `session_id`, `timestamp`, `session_source`, `crash_detected`, `crash_reasons` (`session-start.sh:48-54`). The indicator renumbering (1/2/3 → 1/2) is internal to the script's comments; the output JSON schema is unchanged. `crash_reasons` token values (`stale_in_progress_state`, `incomplete_session_log`) are unchanged (`session-start.sh:34,41`). The only removed token is `uncommitted_changes`. `mandate-parser` Step 2 crash-recovery does not branch on specific `crash_reasons` token values — it reads `crash_detected` (boolean) and presents `crash_reasons` as a free-text string (`SKILL.md:76-80`, `SKILL.md:84-109`). The contract is backwards-compatible: a consumer parsing `startup-state.json` sees the same shape; only one possible reason string is no longer emitted.
- `mandate-parser` is referenced by 16 files (grep), but the SKILL.md edit (Step 1 retitle + Prerequisites update) is internal to the skill — it changes how Step 1 obtains `startup-state.json` (now generates it rather than assuming a hook produced it). No external caller of the skill passes `startup-state.json` in; the skill produces it itself. No caller modification required.

### Dimension 4: Reversibility
**Risk:** Low

- The four substantive tracked edits (`session-start.sh`, `mandate-parser/SKILL.md`, `harness-roadmap.md`, and the `harness/logs/innovation-registry.md` append) are all in-tree text changes that `git revert` of the landing commit restores fully. No sibling files or directories were created that a revert would orphan.
- `.claude/settings.json` requires no rollback — it was reverted within the session and the committed file matches HEAD (`git status --porcelain` confirms `.claude/settings.json` is not in the modified set). The plan-time risk-check's Dimension 4 Medium concern (a hook overwrites tracked `startup-state.json`, leaving the working copy diverged after a settings revert) does not apply here: no hook is registered, and the stale `startup-state.json` / `mandate.json` / `session-log.json` were all untracked (CHANGE_DESCRIPTION) and deleted as part of the reset — deleting untracked files has zero tracked-file impact and nothing for `git revert` to clean.
- `harness/learning/mandate-history.jsonl` is an append-only learning log — the one file class that a `git revert` cannot cleanly undo (a revert would not necessarily strip an appended JSONL line if other lines landed after it). The CHANGE_DESCRIPTION states a validation entry was appended then removed, "restored to its original 1 line." Verified: `wc -l harness/learning/mandate-history.jsonl` returns `1`, and `git status --porcelain` does NOT list `mandate-history.jsonl` as modified — the file is at its committed baseline. The append-only-mutation risk was incurred during validation and already neutralized; nothing carries forward.
- No state pushed beyond the local repo (no `git push`, no Notion write, no external API POST). No new automation (hook, cron, symlink) was added that could fire between landing and a potential revert — the executed design specifically removes the auto-firing hook rather than adding one.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The plan-time risk-check's top concern was High hidden coupling: a SessionStart hook firing on every workspace session, causing `mandate-parser` to detour into crash recovery on a routinely-dirty tree. The executed design structurally eliminates this — `session-start.sh` is not wired as a hook anywhere (grep confirms no `settings.json` registers it), and the false-positive indicator (uncommitted changes) is deleted from the script (`session-start.sh:24-43` — old indicator 1's `git status --porcelain` branch is gone; the diff shows the `-` lines removed). Both halves of the plan-time coupling are addressed.
- No silent auto-firing in unexpected contexts. The script now runs only via explicit `bash .claude/hooks/session-start.sh` in `mandate-parser` Step 1 (`SKILL.md:72`) — a deterministic, operator-visible invocation inside a skill the operator chose to run.
- The new contract (the script runs at harness entry rather than at hook time) is documented at every relevant site, not just one: `mandate-parser/SKILL.md` Prerequisites item 2 (`SKILL.md:42`) and Step 1 body (`SKILL.md:74`) both state the script is "not a `SessionStart` hook"; the Output Summary table notes `startup-state.json` is "Written by `session-start.sh`, invoked in Step 1" (`SKILL.md:318`); the script's own header comment block explains the dropped indicator (`session-start.sh:24-27`); `ai-resources/.claude/commands/session-start.md:10` boundary note describes it as "run by the `mandate-parser` skill at harness entry (its Step 1)... Not a `SessionStart` hook." The contract is named at the change site, satisfying the Low rubric.
- Functional-overlap check: `session-start.md:9-12` documents three session-start mechanisms (the `.sh` script, the `/session-start` command, the `mandate-parser` skill). The executed change does not add a fourth — it clarifies the boundary of an existing one and removes the auto-firing ambiguity. The three-mechanism overlap pre-exists this change and is explicitly documented; this change reduces rather than increases the overlap surface (the script is now unambiguously a sub-step of the skill, not an independent auto-firing actor).
- One residual coupling, Low severity: `mandate-parser` Step 1 hard-codes the relative path `.claude/hooks/session-start.sh` (`SKILL.md:72`). If the skill is ever invoked with a working directory other than the project root, the relative path breaks. The script itself defends its own paths via `CLAUDE_PROJECT_DIR` / `git rev-parse` (`session-start.sh:7`), but the *invocation* in SKILL.md does not. This is a pre-existing convention (harness skills assume project-root cwd) and Step 1 already has a fallback (`SKILL.md:82` — "If the script fails or `startup-state.json` is absent, generate a session_id... set crash_detected=false"), so a cwd mismatch degrades gracefully rather than failing hard. One implicit dependency on an established repo convention, with a documented fallback at the change site — Low.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, `git diff`/`git status`/`grep`/`wc` output, verbatim quotes from CHANGE_DESCRIPTION and referenced files). No training-data fallback was used on fetch/read failures. No dimension was marked INCOMPLETE — the executed change set was fully observable on disk and in the working-tree diff.
