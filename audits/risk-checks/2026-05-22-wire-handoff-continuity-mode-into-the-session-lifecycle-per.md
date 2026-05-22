# Risk Check — 2026-05-22

## Change

Wire /handoff continuity mode into the session lifecycle, per System Owner advisory (decisions.md 2026-05-22 Decision 3). Four file edits in ai-resources:

1. `.claude/commands/wrap-session.md` — add a new Step 0.5 (after Step 0 lockfile touch, before Step 1 log-append): invoke `/handoff` no-args continuity mode inline to write a full session-state scratchpad to `logs/scratchpads/`. One Write call; counts toward the existing ~25-tool-call wrap cost budget. Skippable for trivial sessions.

2. `.claude/commands/prime.md` — add a new Step 1b (after Step 1a cross-check, before Step 2): detect the most recent `logs/scratchpads/*-scratchpad.md`, compare its date to the last session-notes entry, surface path + first Resume With line in the brief as a new `**Resumable scratchpad:**` field. NOT auto-resume — the Step 6 operator-direction wait is preserved.

3. `skills/handoff/SKILL.md` — update the "Do NOT use for end-of-session wrap" boundary (description frontmatter + "Do NOT use for" section) to reflect that `/wrap-session` now runs continuity mode internally as Step 0.5.

4. `.claude/commands/handoff.md` — minor clarifying line consistent with the SKILL.md boundary update.

Both /wrap-session and /prime are canonical pipeline commands that sync to all 7 projects via the auto-sync hook. No hook edits, no settings.json edits, no permission changes, no new files. handoff SKILL.md and command already exist (shipped commit 75f2e53).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/handoff/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/handoff.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Self-contained pipeline-text edits across four already-existing files with no permission or hook changes; the elevated risk is a single Medium-blast-radius concern — the new `**Resumable scratchpad:**` field and the implicit reliance on filename-sort ordering for scratchpad detection propagate to all 7 projects via the auto-sync symlink hook, but both are mitigable with one explicit instruction.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded file is touched. The change edits two command files (`wrap-session.md`, `prime.md`), one SKILL.md, and one command file — none of these load on every turn. Command bodies load only when the command is invoked; `skills/handoff/SKILL.md` has `disable-model-invocation: true` (SKILL.md line 13) so it loads only on explicit `/handoff` invocation.
- No new hook is registered — the change description states "No hook edits" and the four edited files are all command/skill text, confirmed by reading each.
- Per-invocation cost of `/wrap-session` rises by one inlined `/handoff` continuity run (one Write call plus context-extraction reasoning). The change explicitly bounds this: "One Write call; counts toward the existing ~25-tool-call wrap cost budget" — and `wrap-session.md` line 13 already enforces a 25-tool-call ceiling. The added Step 0.5 is "Skippable for trivial sessions," matching the existing trivial-session skip pattern in Step 12 (`wrap-session.md` line 71).
- `/prime` cost rises by one Glob/directory scan of `logs/scratchpads/` plus one Read of the newest scratchpad's first lines — a small bounded read at session start, not a per-turn cost.
- No `@import` added; no subagent brief expanded; no skill description broadened in a way that changes auto-load behavior (the SKILL.md description edit narrows/clarifies a boundary, it does not add trigger keywords).

### Dimension 2: Permissions Surface
**Risk:** Low

- Change description explicitly states "no settings.json edits, no permission changes." Confirmed: none of the four referenced files is a settings file.
- No new tool family is introduced. `/handoff` continuity mode requires only `Write` (SKILL.md line 269: "Tools required: Write (output file)"), already exercised by `/wrap-session` for log appends and by the pre-existing `/save-session` path that writes the same scratchpad format to the same `logs/scratchpads/` directory.
- The `logs/scratchpads/` write target already exists and already contains scratchpads (`2026-05-08-15-08-scratchpad.md`, `2026-05-22-11-53-scratchpad.md`, `2026-05-22-14-00-scratchpad.md`) — no new write path is being authorized.
- No `deny` rule removed or narrowed; no scope escalation; no cross-repo or external capability added.

### Dimension 3: Blast Radius
**Risk:** Medium

- Files touched directly: 4 (`wrap-session.md`, `prime.md`, `skills/handoff/SKILL.md`, `handoff.md`).
- Both `wrap-session.md` and `prime.md` are canonical commands auto-synced to downstream projects. Confirmed by reading `.claude/hooks/auto-sync-shared.sh` (lines 72–82): the SessionStart hook symlinks every `ai-resources/.claude/commands/*.md` into each project that has a `shared-manifest.json`. Because downstream copies are *symlinks* to the canonical file (line 80, `ln -s "$src" "$target"`), the edit propagates to every linked project with no per-project edit — projects read the new behavior on their next session. The "all 7 projects" figure in the change description is consistent with this mechanism; the change does not need to touch any project file.
- Reference enumeration (grep across `ai-resources`, `.md` files):
  - `wrap-session` — 14 non-audit/non-log references including `.claude/commands/` (audit-claude-md, audit-critical-resources, cleanup-worktree, friday-act, friday-checkup, innovation-sweep, log-sweep, new-project, permission-sweep, repo-dd, resolve-improvement-log, session-start, token-audit), workspace `CLAUDE.md`, and docs (session-rituals, weekly-session-guide, operator-maintenance-cadence, onboarding-daniel). These reference `/wrap-session` as the wrap entry point; none depends on its internal step numbering, so adding Step 0.5 does not break them.
  - `/prime` — referenced by `.claude/commands/` (new-project, repo-dd, session-plan, session-start) and docs (session-rituals, session-guardrails, weekly-session-guide). `session-plan.md` and `session-start.md` chain after `/prime`; none parses `/prime`'s output-block schema, so adding a `**Resumable scratchpad:**` line is additive and backwards-compatible.
  - `handoff` / `scratchpad` — `skills/handoff/SKILL.md`, `.claude/commands/handoff.md`, `.claude/commands/save-session.md` (deprecated stub redirecting to `/handoff`), `.claude/commands/cleanup-worktree.md`, `.claude/commands/new-project.md`. The scratchpad format/location contract is owned by `handoff/SKILL.md`; this change does not alter the scratchpad format, only when continuity mode fires.
- Contract changes introduced: (a) `/prime` output block gains a new `**Resumable scratchpad:**` field — additive, backwards-compatible (no caller parses the block). (b) `/wrap-session` gains Step 0.5 — internal step renumbering only; no external caller references step numbers. (c) `handoff/SKILL.md` "Do NOT use for" boundary changes — this is the one substantive contract edit: the current SKILL.md line 10 says "Do NOT trigger for end-of-session wrap" and lines 45–47 say end-of-session wrap → use `/wrap-session`. After the change, `/wrap-session` *contains* a continuity-mode call, so the boundary text must be reworded carefully to avoid a self-contradiction (the skill says "don't use for wrap" while wrap now uses it internally).
- Shared infra touched: the auto-sync symlink path. Because downstream copies are symlinks, no project-local file is modified and no project requires manual migration — this keeps blast radius at Medium rather than High.
- No caller requires modification to keep working — all consuming commands and docs treat `/wrap-session` and `/prime` as opaque entry points.

### Dimension 4: Reversibility
**Risk:** Medium

- The four file edits are pure text edits to existing tracked files — a `git revert` of the landing commit restores all four to their prior state cleanly within the working tree.
- One residual-state concern: between landing and a potential revert, any `/wrap-session` run executes the new Step 0.5 and writes a scratchpad to `logs/scratchpads/`. A `git revert` of the command-text change does NOT delete those generated scratchpad files — they are data artifacts, not part of the reverted commit. This is the same already-accepted behavior as the pre-existing `/save-session` path, and stray scratchpads are harmless (they are read-only inputs to `/prime`), but revert is therefore not a single-step full restoration: leftover scratchpads remain and `/prime`'s detection logic — if also reverted — simply stops reading them.
- No settings.json change, so no cached permission state to clean up.
- No state pushed beyond the local repo by the change itself (commit/push remains a separate operator step per the repo Commit Rules).
- The auto-sync hook is symlink-based: after a revert, the symlinks in downstream projects continue pointing at the (now-reverted) canonical file, so the revert propagates automatically with no per-project cleanup. This is a reversibility *strength* of the symlink design.
- Net: revert works but is not perfectly clean — generated scratchpads persist. One extra cleanup step (delete stray scratchpads, or simply leave them as harmless) — Medium.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Scratchpad detection relies on filename-sort order.** `/prime` Step 1b is to "detect the most recent `logs/scratchpads/*-scratchpad.md`." The scratchpad filename convention is `{YYYY-MM-DD}-{HH-MM}-scratchpad.md` (SKILL.md line 60). "Most recent" is correct only if detection sorts lexically by filename (which equals chronological order for this naming scheme) OR sorts by mtime. The current directory contents expose the trap directly: `2026-05-22-11-53-scratchpad.md` has mtime `May 22 11:54` while `2026-05-22-14-00-scratchpad.md` has mtime `May 22 11:25` — the file whose *name* says 14:00 was actually written *earlier* than the file whose name says 11:53. Filename-sort and mtime-sort disagree on this exact directory today. The change description does not specify which ordering Step 1b uses. This is an implicit dependency on an unstated convention and will silently surface the wrong scratchpad if the wrong sort is chosen.
- **Non-`-scratchpad.md` files in the directory.** `logs/scratchpads/` also contains `2026-05-08-w24-implementation-plan.md`, which does not match the `*-scratchpad.md` glob. Step 1b's stated glob `*-scratchpad.md` correctly excludes it — but this only works if the glob is honored exactly; a looser `*.md` scan would pick up the stray plan file. The contract (glob pattern) must be stated precisely in the `prime.md` edit.
- **Boundary self-contradiction risk in `handoff/SKILL.md`.** The skill currently tells the model "Do NOT trigger for end-of-session wrap … use `/wrap-session` instead" (SKILL.md lines 10, 45–46). After the change, `/wrap-session` Step 0.5 *invokes* continuity mode. If the boundary rewording is imprecise, the SKILL.md will simultaneously say "don't use for wrap" and be used by wrap — a contract that callers (and the model's own trigger logic) cannot honor coherently. The change description names this edit (item 3) but the new wording is not provided, so its correctness cannot be verified here — see INCOMPLETE note below.
- **Functional overlap with the deprecated `/save-session` path.** `save-session.md` is a deprecated stub that redirects to `/handoff` and writes the identical scratchpad format to the identical directory; 11 project symlinks still point at it. After this change, three things can write scratchpads to `logs/scratchpads/`: explicit `/handoff`, the deprecated `/save-session` redirect, and the new `/wrap-session` Step 0.5. This is not a conflict (all write distinct timestamped files, no shared mutable target) but it is overlapping purpose — the operator should be aware that `/wrap-session` now produces a scratchpad on every non-trivial wrap, which will accumulate in `logs/scratchpads/` over time with no stated retention/cleanup policy.
- **Partial INCOMPLETE:** the exact new wording for the `handoff/SKILL.md` boundary and `handoff.md` clarifying line is not provided in `CHANGE_DESCRIPTION`. Items 3 and 4 are evaluated on described intent only; their correctness against the self-contradiction risk above cannot be verified from the inputs.

## Mitigations

- **Dimension 3 (Blast Radius):** In the `handoff/SKILL.md` edit (item 3), reword the boundary so it is internally consistent — state that `/wrap-session` runs continuity mode *internally as Step 0.5* and that the operator should not separately invoke `/handoff` for an end-of-session wrap, rather than the current absolute "Do NOT use for end-of-session wrap." Verify the reworded `description` frontmatter and "Do NOT use for" section do not contradict the new `/wrap-session` behavior before landing. Apply the same consistency check to the `handoff.md` clarifying line (item 4).
- **Dimension 5 (Hidden Coupling):** In the `prime.md` Step 1b edit, state the scratchpad-detection rule explicitly and unambiguously: sort `logs/scratchpads/*-scratchpad.md` matches lexically by filename (which equals chronological order for the `YYYY-MM-DD-HH-MM-scratchpad.md` convention) and pick the last — do NOT sort by filesystem mtime, because mtime and filename order can disagree (confirmed today: `2026-05-22-14-00-scratchpad.md` has an earlier mtime than `2026-05-22-11-53-scratchpad.md`). Also keep the glob exactly `*-scratchpad.md` so the stray `2026-05-08-w24-implementation-plan.md` is excluded. Document this detection contract inline in `prime.md` at the change site.
- **Dimension 5 (Hidden Coupling) / Dimension 4 (Reversibility):** Note in the landing commit message that `/wrap-session` now generates a scratchpad on every non-trivial wrap, and that `logs/scratchpads/` has no automatic retention policy — flag whether `check-archive.sh` or `/log-sweep` should later be extended to prune old scratchpads, so accumulation is a tracked decision rather than silent drift.

## Recommended redesign

(Not applicable — verdict is PROCEED-WITH-CAUTION.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence: full reads of all four referenced files, the auto-sync hook (`auto-sync-shared.sh`), the deprecated `save-session.md` stub, `decisions.md` 2026-05-22 Decision 3, and the live `logs/scratchpads/` directory listing (mtime-vs-filename ordering conflict observed directly); grep counts across `ai-resources` for `wrap-session`, `/prime`, `handoff`, and `scratchpad` references; and the `audit-discipline.md` Risk-check change classes section. The exact new wording for SKILL.md/handoff.md edits (items 3–4) was not provided and is flagged INCOMPLETE under Dimension 5; this was factored into the verdict. No training-data fallback was used on any read.
