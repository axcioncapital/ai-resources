# Risk Check — 2026-05-21

## Change

Checkpoint B — run the minimal-markdown test workflow end-to-end against the Phase 3 session-governor skeleton. First live run of two built skills (mandate-parser, then session-governor). Effects: (1) creates harness runtime state — harness/session/{startup-state,mandate,session-log,current-state}.json — and appends to harness/learning/{learnings.json, mandate-history.jsonl}; (2) the governor makes ~3 git commits, one per test-workflow output file (harness/test-workflows/minimal-markdown/output/{unit-1,unit-2,unit-3}.md); (3) spawns ~3 general-purpose sub-agents, one per unit; (4) conditionally edits .claude/skills/session-governor/SKILL.md if the run surfaces a governor defect. Known hazard: a stale in_progress current-state.json left at session end would false-fire the next mandate-parser crash check (mandate-parser Step 1 / session-start.sh). No new permissions, no hook changes, no shared-command edits. Also exercises a manual /compact event mid-run to test the governor's Phase C rehydration.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/skills/session-governor/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/skills/mandate-parser/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/hooks/session-start.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness/session/ — directory exists; no runtime *.json present yet
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness/learning/learnings.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness/learning/mandate-history.jsonl — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness/test-workflows/minimal-markdown/output/ — directory exists; empty
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/references/harness-rules.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A first-run execution (not an infrastructure build) of two already-QC'd skills; risk concentrates in two Medium dimensions — a stale `in_progress` state that would false-fire the next session's crash check, and a conditional skill edit that, if it occurs, escalates blast radius — both with concrete paired mitigations.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The change is an *execution* of existing skills, not a content addition. No edit to any always-loaded file is in scope unless the conditional defect-fix path fires (see Dimension 3). Neither `CLAUDE.md` (workspace, `/Users/.../Axcion AI Repo/CLAUDE.md`) nor repo `CLAUDE.md` (`ai-resources/CLAUDE.md`) is touched.
- No hook is registered or modified — CHANGE_DESCRIPTION states "no hook changes." `session-start.sh` is invoked *as a script by mandate-parser Step 1* (`SKILL.md:74` — `bash .claude/hooks/session-start.sh`), not registered as a `SessionStart` hook (`session-start.sh:2` comment and `mandate-parser/SKILL.md:42` both state it is deliberately not hook-wired). No per-session or per-tool-call auto-load cost is added.
- No `@import` is added to an always-loaded file. The `@.claude/references/harness-rules.md` load is on-demand per the harness-rules header (`harness-rules.md:3-16`) — it loads only for this harness session, which is the intended pay-as-used pattern.
- The ~3 `general-purpose` sub-agents are spawned on demand for this one run (`session-governor/SKILL.md:239` Phase B step 7); they are not a recurring per-session cost.

### Dimension 2: Permissions Surface
**Risk:** Low

- CHANGE_DESCRIPTION states "No new permissions." Confirmed against `.claude/settings.json`: `allow` already grants `Bash(*)`, `Write`, `Edit`, `Agent`, `Skill`, plus `Write`/`Edit` globs covering the whole repo tree. Every action the run needs — bash for git commits and `session-start.sh`, sub-agent spawn, skill invocation, writes under `harness/` — is already authorized.
- The git commits are within the existing permission envelope: `deny` lists `Bash(git push*)`, `git reset --hard *`, `git checkout *` (`settings.json` deny block) — the run performs `git add` + `git commit` only (`session-governor/SKILL.md:284` step 18), none of which is denied. No push is in scope.
- No `deny` rule is removed or narrowed; no settings file is edited; no scope escalation (project → user) occurs.

### Dimension 3: Blast Radius
**Risk:** Medium

- **Files written by the run (all git-untracked or fixture outputs):** `harness/session/{startup-state,mandate,session-log,current-state}.json` — confirmed git-untracked: `.gitignore:2` ignores `harness/session/*` (only `.gitkeep` is tracked; `git ls-files harness/session/` returns only `.gitkeep`). `harness/test-workflows/minimal-markdown/output/{unit-1,unit-2,unit-3}.md` — `.gitignore:6` ignores `output/*`, BUT the governor explicitly `git add`s and commits them anyway (step 18); a force-add over `.gitignore` is required for the commit to capture the file. Appends to `harness/learning/learnings.json` (currently `[]`) and `harness/learning/mandate-history.jsonl` (currently 1 line) — both git-tracked.
- **Conditional shared-component edit:** effect (4) — "conditionally edits `.claude/skills/session-governor/SKILL.md` if the run surfaces a governor defect." `session-governor/SKILL.md` is a referenced caller-bearing component (see enumeration). If this path fires, blast radius rises: a skill edit during an execution session is a contract change to a Phase-3 build artifact and should route through `/improve-skill` per workspace `CLAUDE.md` AI Resource Creation rules, not be patched ad hoc mid-run.
- **Caller enumeration (grep across `.claude/` + `ai-resources/`):**
  - `session-governor` referenced in: `.claude/references/harness-rules.md`, `.claude/skills/mandate-parser/SKILL.md`, `.claude/skills/session-governor/SKILL.md`, and 5 prior risk-check audit files. Live callers = 2 (harness-rules.md load list; mandate-parser handoff at Step 10). Audit files are historical records, not callers.
  - `mandate-parser` referenced in: `.claude/references/harness-rules.md`, `.claude/hooks/session-start.sh`, both harness SKILL.md files, `ai-resources/.claude/commands/session-start.md`, plus audit/report files. Live callers = ~3.
  - `current-state.json` referenced in: both harness SKILL.md files, `harness-rules.md`, `session-start.sh`, and harness schema/log files (`write-ownership.md`, `current-state-schema.md`). The crash-detection coupling at `session-start.sh:32` (`grep -q '"in_progress"'`) is the load-bearing one.
  - `session-start.sh` referenced in: `mandate-parser/SKILL.md` (the invoker), plus roadmap/log/report files.
- **No contract change** to subagent input schema, log shapes, or invocation syntax — the run *exercises* existing contracts; it does not redefine them. The 3 git commits are designed behavior per Phase 3 sufficiency criteria (`session-governor/SKILL.md:284-296`). Blast radius is Medium (not Low) only because of the conditional skill-edit path and the deliberate `unit-2` Stop-blocker override; if the skill edit does not fire and the override is logged, effective blast radius is Low.

### Dimension 4: Reversibility
**Risk:** Medium

- **Runtime state — fully reversible by deletion.** `harness/session/*.json` are git-untracked (`.gitignore:2`); they can be deleted freely with no git history to undo. CHANGE_DESCRIPTION confirms this.
- **The 3 git commits — reversible but multi-step.** Three separate commits land (one per unit, `session-governor/SKILL.md:284`). Undoing them requires 3 `git revert`s or a `git reset` — and `git reset --hard` is denied by `settings.json`, so rollback is `git revert` (3 commits) or a soft reset, both multi-step. The committed output files are also `.gitignore`d, so a revert leaves the working-tree copies behind unless separately deleted.
- **Append-only log mutations — not cleanly revertible.** `harness/learning/learnings.json` and `mandate-history.jsonl` are git-tracked and appended to (`session-governor/SKILL.md:298` step 20; `mandate-parser/SKILL.md:213` Step 8). A `git revert` of the commits that carry these appends would work, but if the appends land in a commit *alongside* a unit output file, reverting is entangled. These are exactly the data-file mutations the reversibility heuristic flags as carrying forward.
- **The stale-`in_progress` hazard is a reversibility failure mode.** If `current-state.json` is left non-terminal, the next harness session's `session-start.sh:32` detects it as `crash_detected=true` — this is state that "propagates" into the next session and cannot be undone by git alone (the file is untracked). It is a deletion, not a revert.
- No external write (no push, no Notion, no API POST) is in scope — `git push*` is denied and out of scope.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **The stale-`in_progress` coupling is real and named.** `session-start.sh:31-35` crash Indicator 1 greps `current-state.json` for `"in_progress"`; the governor writes that exact token at Phase B step 3 (`session-governor/SKILL.md:213`) and is meant to clear it to a terminal state at Phase D step 1 (`SKILL.md:561` — "no unit left in `in_progress`"). The coupling is documented at both ends, so it is a *known* hazard, not a hidden one — but it auto-fires in a *different, future* session, which is the cross-session side-effect the heuristic flags.
- **Indicator 2 — incomplete `session-log.json` — is a second, less-obvious instance of the same coupling.** `session-start.sh:38-43` also sets `crash_detected=true` if `session-log.json` exists, is non-empty, and lacks a `session_completed` event. The Phase 3 skeleton's Phase D explicitly does **not** write a `session_completed` / session-end event (`session-governor/SKILL.md:564-566` and `:572-576` — session-end logging is deferred to Phase 4). Therefore, even a *cleanly finished* Checkpoint B run will leave `session-log.json` without `session_completed`, and the **next** harness session's `session-start.sh` will report `crash_detected=true` via Indicator 2 regardless of how clean the `current-state.json` shutdown is. CHANGE_DESCRIPTION names only the `current-state.json` hazard (Indicator 1); the Indicator-2 false-fire is an undocumented consequence of running a Phase-3 skeleton whose Phase D is not yet complete.
- **The `unit-2` deliberate Stop-blocker override is a designed deviation from the skill contract.** `unit-2-defect-seed`'s `grep_absent '^\*\*'` exit criterion (`workflow-config.yaml` unit-2 exit_criteria) is designed to fail at governor step 22, which raises a Stop-mode blocker (`session-governor/SKILL.md:338-347`). The skill says a Stop halts the session; the plan overrides this to continue to unit-3. This operator override is sound for a test run but is a coupling between the plan's intent and the skill's documented Stop semantics — the override must be explicitly logged so it is not later read as a skill defect.
- **The conditional `/compact` exercises Phase C rehydration coupling.** The governor's Phase C depends on `current-state.json` being authoritative on disk (`session-governor/SKILL.md:520-548`, hard rule 4). This is a designed, documented dependency; the manual `/compact` mid-run is the intended test of it. No hidden coupling here — flagged only as the third deliberate deviation the run introduces.

## Mitigations

- **Dimension 3 (skill edit):** If the run surfaces a governor defect, do NOT patch `.claude/skills/session-governor/SKILL.md` inline mid-run. Record the defect as a `judgment_call` log entry / blocked-item, finish or halt the run, then apply the fix in a separate session via `/improve-skill` (workspace `CLAUDE.md` → AI Resource Creation). This keeps the execution session and the skill-edit session as separate, independently revertable commits.
- **Dimension 4 (reversibility) + Dimension 5 (stale `in_progress`):** At session end, before closing, verify `harness/session/current-state.json` has no unit in `in_progress` (Phase D step 1, `session-governor/SKILL.md:561`). If the run halted with a non-terminal state, manually set the active unit to a terminal state or delete the runtime `*.json` files (they are git-untracked, safe to delete) so the next harness session's `session-start.sh:32` does not false-fire crash recovery.
- **Dimension 5 (Indicator-2 false-fire):** Expect the next harness session to report `crash_detected=true` via `session-start.sh` Indicator 2 (`session-log.json` lacks `session_completed`) because the Phase-3 skeleton's Phase D does not write a session-end event. Either delete `harness/session/session-log.json` after Checkpoint B completes, or note this expected false-positive in the session report so the next session's mandate-parser crash recovery is understood as a known-skeleton artifact, not a real crash.
- **Dimension 3 (deliberate Stop override):** Log the `unit-2` exit-criteria Stop-blocker and the decision to continue to unit-3 as an explicit `judgment_call` entry (`judgment_type: "exit_criteria_failure"`) in `session-log.json`, so the override is visible as intended test behavior and not later mistaken for a governor defect.

## Recommended redesign

Not applicable — verdict is PROCEED-WITH-CAUTION.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, `.gitignore` and `git ls-files` output, `settings.json` permission blocks). No `not yet present` file was read. No training-data fallback was used on fetch/read failures.
