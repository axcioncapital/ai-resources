# Risk Check — 2026-05-18

## Change

Pass A — combined edits to `ai-resources/.claude/commands/session-plan.md` for nordic-pe Findings F2, F3, F6.

F2: Edit Step 0 — after the date-header check, also check whether `logs/session-plan.md` exists AND was modified within the last 6 hours. If yes, emit a prompt listing the existing plan's intent and three options (keep / overwrite / write to pass2). Default on no response: option 3.

F3: Edit Step 1 — replace the `"Inferred intent: {INTENT}"` display line with a variant that includes the source-file last-modified timestamp and offers `"continue"` as a fourth option to keep the existing plan.

F6: Edit Step 7 — before inserting `Class: {CLASS}` under today's header in session-notes.md, check whether a `Class: ` line already exists under that header. If yes, replace the value; do not insert a duplicate.

## Referenced files

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-plan.md` — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Three localized in-file edits to a single command — low surface area for cost/permissions/reversibility, but F2 + F3 together introduce overlapping re-entry guards (6-hour mtime check vs. "continue" option) and F2's default-on-no-response (option 3 = write to pass2) sets a new implicit naming contract for `session-plan-pass2.md` that no downstream caller knows about.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- All three edits are inline expansions of an existing command file (`session-plan.md`, currently 197 lines per Read). The command is invoked on-demand, not auto-loaded — adding ~10–20 lines to its body has no per-session token impact unless `/session-plan` runs.
- No CLAUDE.md edit, no `@import`, no hook registration, no new subagent. Frontmatter `model: opus` unchanged (file line 2).
- `/session-plan` is invoked at most once per session (per `prime.md` line 95 and `session-start.md` line 107 — both name it as a "Next:" step, not a per-tool-call hook).

### Dimension 2: Permissions Surface
**Risk:** Low

- F2 adds a Read of `logs/session-plan.md` mtime — `logs/session-plan.md` is already Read by `open-items.md` (line 41) and Write-targeted by Step 7 of `session-plan.md` itself (line 145). No new path family.
- F2 option 3 writes to `logs/session-plan-pass2.md` (a sibling under `logs/`). The change description does not specify the exact filename — assumed from "pass2" wording. `logs/` is an established write target for session-plan flow. No new permission category needed.
- F6 uses `Edit` against `logs/session-notes.md` — already the target of Step 7's existing `Edit` (line 183 "Use `Edit` to insert `Class: {CLASS}`"). Same path, same tool.
- No `deny` rule touched; no scope escalation.

### Dimension 3: Blast Radius
**Risk:** Medium

- Files touched directly: 1 (`session-plan.md`).
- Grep for `session-plan` references inside `ai-resources/`: 14 files (5 commands + 9 docs).
  - Commands referencing `/session-plan` or `logs/session-plan.md`: `prime.md` (line 95), `session-start.md` (line 107), `monday-prep.md` (lines 256–267, including the `session-plan-next.md` scaffold), `open-items.md` (lines 41, 67–68, 83). None of these read step-internal behavior — they only know `/session-plan` exists and writes `logs/session-plan.md`. F2/F3/F6 do not change that contract.
  - Docs: `weekly-cadence.md`, `session-rituals.md`, `repo-architecture.md`, `weekly-session-guide.md`, `autonomy-rules.md`, `operator-maintenance-cadence.md`, `onboarding-daniel.md`, `onboarding-daniel-cheatsheet.md`. These are operator-facing — they describe the command but do not depend on its step-internal sequence.
- `Class: ` grep in `logs/`: 4 files (`session-notes.md` 5 occurrences, `session-notes-archive-2026-05.md`, `session-plan.md`, plus the command itself). The F6 idempotency check only affects future inserts under today's header — no caller reads or writes prior `Class:` lines.
- **Caller impact requiring modification:** none identified. All references treat `/session-plan` as a black box that produces `logs/session-plan.md`.
- **New file class:** F2's "pass2" option introduces `logs/session-plan-pass2.md` (or similar). `open-items.md` line 41 globs `logs/session-plan.md` literally — it will NOT pick up `logs/session-plan-pass2.md` unless updated. Not a breakage (pass2 plans will simply not surface in `/open-items`), but a quiet regression in the open-items coverage. Counts as one downstream caller affected.

### Dimension 4: Reversibility
**Risk:** Low

- All three edits are in-place modifications to one file. `git revert` restores the prior text fully.
- F2's option 3 writes a new file (`logs/session-plan-pass2.md`) only if invoked. Revert of the command does not remove any pass2 files that were created in the interim — but these are operator-generated content under `logs/` that the operator can keep or delete independently. No state propagates outside the repo.
- F6's idempotency check only affects how `Class: ` is written under today's header. Revert restores the original "insert without check" behavior; any duplicate `Class:` lines created post-revert are trivially fixable.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Overlap between F2 and F3 re-entry semantics.** F2 detects a recent `logs/session-plan.md` (mtime < 6h) at Step 0 and offers keep/overwrite/pass2. F3 then ALSO offers a "continue" option at Step 1 to keep the existing plan. Operator who picks "keep" at F2 — does the flow exit, or does it fall through to F3 where they confront a similar choice again? The change description does not specify F2's keep-branch behavior (does it stop, or proceed to display intent in Step 1?). If F2 stops on keep, F3's "continue" option is reachable only via F2's "overwrite" or "pass2" branches, which is contradictory. This is an undocumented contract between two newly-coupled steps.
- **`logs/session-plan-pass2.md` filename contract is undocumented.** F2 mentions "write to pass2" but does not specify the exact filename. `open-items.md` line 41 (T1/T3 tier rules) and `monday-prep.md` (which writes `logs/session-plan-next.md`) both touch the `logs/session-plan*.md` namespace. Two adjacent conventions (`-pass2`, `-next`) without a documented naming rule is a coupling hazard for future maintenance.
- **F2's "default on no response: option 3" silently creates a file when the operator is non-responsive.** This auto-fires in a context (the operator simply doesn't answer) that does not feel like an explicit choice. If the operator re-invokes `/session-plan` shortly after a prior session, the silent default produces a pass2 file rather than the operator's likely intent (overwrite the prior plan they just finished). This is a hidden behavior gradient.
- **F6 contract (idempotent `Class: ` insert) is documented at the change site itself** — the new check lives in Step 7 alongside the original insert logic. This part of the change is self-contained.

## Mitigations

- **Dimension 3 (Blast Radius — open-items coverage):** Update `ai-resources/.claude/commands/open-items.md` line 41 to glob `logs/session-plan*.md` (or explicitly list both `session-plan.md` and `session-plan-pass2.md`) in the same commit as F2. Without this, pass2 plans drop off the open-items surface silently.
- **Dimension 5 (Hidden Coupling — F2/F3 re-entry overlap):** Specify F2's keep-branch behavior explicitly in the edit: "If operator picks `keep`, exit `/session-plan` without proceeding to Step 1." This removes the ambiguity about whether F3's "continue" option is reachable after F2's "keep". Equivalent alternative: drop F3's "continue" option since F2 already covers that semantic.
- **Dimension 5 (Hidden Coupling — filename contract):** Pin the exact pass2 filename in the F2 edit (e.g., `logs/session-plan-pass2.md`) and add a one-line comment in Step 0 noting the parallel `monday-prep.md` `session-plan-next.md` convention so the two adjacent names are visible to future maintainers.
- **Dimension 5 (Hidden Coupling — silent default):** Reconsider the "default on no response: option 3" rule. A safer default for an operator who is mid-session and didn't read the prompt is option 1 (keep) — it preserves the existing plan rather than silently spawning a pass2 file. If the design intent really is "fork on no response", document the rationale inline in Step 0 so the next maintainer sees why.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: `session-plan.md` line counts and section anchors (lines 11, 22, 34, 145, 183), grep results across `.claude/commands/` and `docs/` (14 referencing files), `logs/session-notes.md` `Class:` line counts (5 occurrences), and caller-file line references (`prime.md` 95, `session-start.md` 107, `open-items.md` 41, `monday-prep.md` 256–267). No INCOMPLETE dimensions; no training-data fallback used.
