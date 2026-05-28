# Risk Check — 2026-05-28

## Change

Proposed change: Extend `/session-plan` Step 0 MISMATCH branch with a wrap-state check per nordic-pe-macro-landscape-H1-2026 `logs/improvement-log.md` id-13 (`/session-plan` Step 0 mis-fires concurrent-session collision after prior sessions wrap). Edit ONE file: `ai-resources/.claude/commands/session-plan.md` (canonical; nordic project's session-plan is a symlink to canonical).

**Current state.** Step 0 MISMATCH branch (lines 56-60 region) treats any MATCH-comparison failure as "concurrent-session active" and auto-routes the new plan to `pass2.md`. The friction case: a PRIOR session already wrapped (e.g., yesterday's session, wrap commit landed), its `session-plan.md` still on disk within the 6-hour mtime window. New session today gets a different intent — MISMATCH fires → pass2 routing — but the prior session is NOT live. Result: pass2 file written instead of overwriting the dead plan. Friction observed 2× in 24h.

**Proposed fix.** After MISMATCH is determined but before auto-pass2 routing, run a wrap-state check on the existing plan's date:

1. Extract `PLAN_DATE` from existing `logs/session-plan.md`'s `# Session Plan — {DATE}` header.
2. Probe TWO wrap signals (either positive → "session wrapped"):
   - **Signal A** (session-notes wrap marker): grep `logs/session-notes.md` for a `^## {PLAN_DATE}` header that ALSO contains both `^### Summary` and `^### Next Steps` subsections within its block (block = up to the next `^## ` header). Use awk single-pass.
   - **Signal B** (git wrap commit): `git log --grep="^session: ${PLAN_DATE}" --oneline 2>/dev/null` returns at least one commit.
3. Branching:
   - **EITHER signal positive** → prior session wrapped → MISMATCH override: treat as MATCH-Option-2 (plain overwrite of `logs/session-plan.md`). Emit one-line note: `Prior session for {PLAN_DATE} has wrapped (wrap-signal: {A | B | A+B}). Overwriting session-plan.md instead of routing to pass2.`
   - **NEITHER signal positive** → preserve current MISMATCH → pass2 routing.

**Why safe.** The wrap signal is dual: A is local file presence; B is git history presence. False-positive requires BOTH to fire spuriously, which is implausible for a non-wrapped session (the wrap writes both signals together). False-negative (signal misses a real wrap) preserves current behavior (pass2 routing) — no regression.

**Phase scoping:** Step 0 MISMATCH branch only. No changes to MATCH branch, sub-step 0 SAME_SESSION override, Step 1+ logic, or pass2 file format. `/drift-check` known-debt note (line 64 region) unchanged.

**Concurrent-session context:** no concurrent session expected (Wave 2 wrapped earlier). Will re-read session-plan.md from disk right before applying.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-plan.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/session-notes.md — exists (read target of Signal A)

## Verdict

GO

**Summary:** Targeted, conservative MISMATCH-branch extension with dual-signal wrap detection that fails closed to existing behavior; canonical-file edit propagates via 14 confirmed symlinks; no permissions / hooks / always-loaded content touched.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The change is confined to one slash command's Step 0 logic, which runs only when `/session-plan` is invoked — not an auto-loading hook, not an `@import`, not a CLAUDE.md insertion. Evidence: edit target is `ai-resources/.claude/commands/session-plan.md` (lines 56-60 region per CHANGE_DESCRIPTION), a slash command invoked on demand.
- Added prose is ~10-20 lines of inline logic spec within an already-large Step 0 block (267 lines total in session-plan.md). The command is not auto-spawned and carries no SessionStart, PreToolUse, or Stop hook footprint (grep `ai-resources/.claude/hooks/` for `session-plan` returns only `backup-session-plan.sh`, which writes-time backs up the file, not the command).
- The new logic runs only when MISMATCH fires inside an existing `session-plan.md` is within the 6-hour mtime window — a conditional sub-branch of an already-conditional branch. Per-invocation cost is one awk scan of `session-notes.md` (~500 lines locally) and one `git log --grep` call. Both are cheap and only fire on the narrow MISMATCH path.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `.claude/settings.json` edits requested. No `allow`/`ask`/`deny` change named.
- The new Bash invocations (`git log --grep`, awk) fall under categories already permitted on the bypass-permissions floor described in user MEMORY ("Zero permission prompts — bypassPermissions is the floor"). No new tool family introduced.
- No cross-repo or external-API capability added. The `git log` runs against the current project repo only.

### Dimension 3: Blast Radius
**Risk:** Medium

- Direct file count: 1 file edited (`ai-resources/.claude/commands/session-plan.md`).
- Symlink fan-out: 14 project copies of `session-plan.md` are symlinks to the canonical file. Verified via `ls -la`: `nordic-pe-macro-landscape-H1-2026`, `axcion-brand-book`, `ai-development-lab`, `strategic-os`, `obsidian-pe-kb`, `buy-side-service-plan`, `nordic-pe-screening-project`, `project-planning`, `interpersonal-communication`, `axcion-ai-system-owner`, `repo-documentation`, `global-macro-analysis`, `corporate-identity`, `personal/travel-os` — all point at the canonical path. Every project session that invokes `/session-plan` will see the new behavior at next invocation.
- Downstream consumers grep'd across `ai-resources/`:
  - **commands** referencing session-plan logic / files: 10 hits — `monday-prep.md`, `decide.md`, `session-plan.md`, `open-items.md`, `contract-check.md`, `drift-check.md`, `session-start.md`, `prime.md`, `new-project.md`, `pm.md`.
  - **agents**: 2 hits — `project-manager.md` (treats session-plan as paste target, not parser), `fix-repo-issues-scanner.md` (reads `session-plan.md` for checkbox lines + uses mtime — both unaffected by Step 0 routing logic).
  - **hooks**: 1 hit — `backup-session-plan.sh` (PreToolUse Write hook that backs up the file before overwrite; per nordic-pe improvement-log entry 2026-05-22, the regex now matches both `session-plan.md` AND `session-plan-pass2.md` — both paths are protected).
  - **skills**: 1 hit — `handoff/SKILL.md` (mentions session-plan as a universal entry point, not parser).
  - **docs**: ~14 hits — all are command-description prose (e.g., `repo-architecture.md` lines 218-219 document both `session-plan.md` and `-pass2.md` as artifacts; `compaction-protocol.md` line 21 names it as a checkpoint target). None parse Step 0's branching logic.
- Behavior contract change for downstream callers: this change makes the MISMATCH branch more permissive (overwrite when the existing plan's session has wrapped) — i.e., it produces *fewer* `session-plan-pass2.md` files. `/open-items` (lines 41-42) reads both `session-plan.md` and `session-plan-pass2.md`, so reducing pass2 creation reduces noise — no negative impact. `/drift-check` (line 18, 28) reads `session-plan.md` as mandate; the change is favourable to it (the canonical plan is more likely to reflect the current session). `/prime` Step 8c.8 (line 323) duplicates Step 0's MISMATCH MATCH logic verbatim; this duplicate is NOT updated by the proposed change. After the change, `/prime` and `/session-plan` will have DIVERGENT collision-detection behavior — `/prime` still routes to pass2 on stale-but-wrapped prior plans, `/session-plan` overrides. This is the contract-drift call-out: existing identical logic at `prime.md:323-325` will be left behind unless the operator chooses to land that companion edit later.
- Recurrence vs novelty: per id-13 in nordic-pe improvement-log, the friction has occurred 2× in 24h. The proposed change targets the root cause; it does not invent a new mechanism but extends an existing branch.

### Dimension 4: Reversibility
**Risk:** Low

- Single canonical-file edit; `git revert` on the commit restores prior text fully. Symlinks resolve to whatever canonical contains, so reverting canonical reverts all 14 fan-out paths atomically.
- No log/registry mutations proposed inside this change. No external POST. No new file created. No hook re-registered.
- Operator muscle memory: the change makes `/session-plan` *more* permissive on a narrow path, not less — operators who currently understand "MISMATCH → pass2" will continue to see pass2 on the genuine-collision path; only the stale-wrapped-plan path silently behaves better. No new flag, no new prompt shape (the override emits a one-line note, not a new prompt). Rollback does not require re-training.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Coupling A (session-notes format contract):** Signal A grep depends on the wrap entry format `^### Summary` + `^### Next Steps` under `^## {PLAN_DATE}`. Verified format match in ai-resources `logs/session-notes.md` (lines 14, 40, 50, 71, 82, 111, 128, 145, 166, 172, 188, 230, 250, 263, 308, 322, 356, 391, 427, 440 — `Summary`/`Next Steps` consistently present) AND in nordic-pe `logs/session-notes.md` (lines 8, 52, 62, 107, 128, 170, 188, 216, 240, 270 — same pattern). The format is the canonical wrap-session output; documented in `/wrap-session` mechanics. Coupling is real but rests on an established convention — not a new contract.
- **Coupling B (git commit-subject contract):** Signal B greps for `^session: {DATE}` in commit subjects. Verified format in `git log --grep="^session:"` for ai-resources: 10/10 recent matches conform (`session: 2026-05-28 — ...`). The wrap-session command is the producer; this is also an established convention. Edge case: not every session ends with a commit (e.g., wrap-without-commit sessions described in nordic-pe session-notes line 188-190 around the friction-log carryover), so Signal B can false-negative — but Signal A then carries the signal, and false-negative on both preserves current behavior per the proposal's "Why safe" clause.
- **Coupling C (duplicate logic in `/prime`):** Step 8c.8 of `ai-resources/.claude/commands/prime.md` (lines 323-325) replicates the MISMATCH-routes-to-pass2 contract: *"if `logs/session-plan.md` already exists and was modified within the past 6 hours, read its `## Intent` line as `EXISTING_INTENT` ... **MISMATCH** → write to `logs/session-plan-pass2.md` instead."* This is the same algorithm the proposed change extends — but the change touches only `session-plan.md`, leaving `prime.md` Step 8c.8 untouched. After landing, the two collision-detection paths diverge silently. The change-description's "Edit ONE file" framing does not flag this divergence. This is the principal hidden-coupling finding: an existing repository convention (Step 8c.8 mirrors Step 0) is broken by the change in a way that the change site does not document.
- **Coupling D (`backup-session-plan.sh` interaction):** Per nordic-pe improvement-log id 2026-05-22 (`backup-session-plan.sh does not back up alternate-target plan files`, applied 2026-05-28), the hook now backs up both `session-plan.md` and `session-plan-pass2.md` writes. With the proposed change reducing pass2 creation on the wrapped-prior-session path, the hook will instead see a `session-plan.md` overwrite — already covered by its regex. Coupling is benign.
- Net assessment: Coupling A and B are grounded in established conventions, documented at the change site (per the proposal's signal definitions). Coupling C is undocumented at the change site and produces a real divergence with `/prime` Step 8c.8 — this is what pushes the dimension above Low.

## Mitigations

The verdict is GO, so this section is informational only — not required to land the change. The Coupling C finding above is worth surfacing as a follow-on improvement-log entry: "After landing the `/session-plan` Step 0 wrap-state check, `/prime` Step 8c.8 retains the original MISMATCH-to-pass2 algorithm and is now out of sync. Companion fix: mirror the wrap-state check into `prime.md` Step 8c.8, OR have Step 8c.8 delegate to `/session-plan` Step 0 by invocation instead of duplicating the logic." Not blocking for this change — surfacing only.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references in `session-plan.md` and `prime.md`; grep counts across `ai-resources/.claude/commands/`, `agents/`, `hooks/`, `skills/`, `docs/`; symlink enumeration via `ls -la` across 14 project paths; wrap-format verification via grep across two `session-notes.md` files; commit-subject verification via `git log --grep`. No training-data fallback used.
