# Implementation Report — repo-dd Findings (projects/personal)

**Date drafted:** 2026-05-11
**Scope audited:** `projects/personal`
**Source audit:** `ai-resources/audits/repo-due-diligence-2026-05-11-project-personal.md`
**Source extract:** `ai-resources/audits/working/dd-extract.md`
**Implementation:** **Deferred to next session.** No fixes applied this session.

---

## Summary

The factual audit produced **10 findings** against `projects/personal`:

- 4 require operator decisions (1 MEDIUM, 3 LOW) — covered below
- 4 are informational (no action)
- 2 dismissed by operator at triage (FINDING-6 model declaration mismatch, FINDING-7 settings.json untracked) — not addressed in this report
- 0 are mechanical auto-fixes

This report converts the 4 remaining operator findings into an ordered, runnable fix plan. Each fix block records the current state, the available options, a recommended option, the files to touch, the exact action, and verification. Next session's operator should review each block, mark APPLY or DEFER, and execute.

---

## Pre-Flight Checklist (next session)

- [ ] Open this report and the audit (`repo-due-diligence-2026-05-11-project-personal.md`)
- [ ] Set model: `/model opus` (decisions on duplications and snapshot freezing involve judgment)
- [ ] Mark each fix below APPLY or DEFER
- [ ] Run `/risk-check` before applying any fix that touches shared resources (specifically FINDING-4)
- [ ] Apply fixes in priority order (MEDIUM → LOW)
- [ ] After each change, verify by reading the modified file
- [ ] Commit per scope:
  - Fixes inside `projects/personal/` — one commit
  - Fixes inside `ai-resources/` (if FINDING-4 applied) — separate commit with its own scope note
- [ ] Push (manual operator step)
- [ ] Run `/wrap-session` when complete

---

## Fix Plan

### Fix 1 — FINDING-4 (MEDIUM): Add log-sweep-auditor to agent-tier-table.md

**Current state.** `log-sweep-auditor` (declared tier: haiku) exists in `ai-resources/.claude/agents/` and is symlinked into `projects/personal/.claude/agents/`. The canonical tier table at `ai-resources/docs/agent-tier-table.md` does not list it.

**Decision.** Either (a) add a row to the tier table now (touches `ai-resources/`, outside this audit's scope), or (b) defer to an ai-resources-scoped audit/cleanup pass.

**Recommended option:** **(b) defer.** The fix is one row but it modifies a workspace canonical doc, which would mix two scopes in this session's commits. Better to handle in a focused ai-resources sweep where related tier-table gaps can be addressed together.

**If APPLY:**
- Run `/risk-check` first (touches a canonical doc referenced by other workspaces)
- Files to touch: `ai-resources/docs/agent-tier-table.md` — add one row: `log-sweep-auditor | haiku | (one-line description from the agent file)`
- Commit separately with scope: `audit: tier-table sync — add log-sweep-auditor entry`

**Risk:** Low if applied carefully. Tier table is referenced by audits; adding a row does not invalidate existing rows.

---

### Fix 2 — FINDING-2 (LOW): Decide CLAUDE.md Input File Handling duplication

**Current state.** `projects/personal/CLAUDE.md § Input File Handling` is a verbatim duplicate of the workspace-canonical section. The duplicate self-declares with the rationale: "projects sometimes opened without parent workspace context loaded."

**Decision.** Either (a) keep verbatim duplication (current state), or (b) replace with a one-line pointer to the workspace section.

**Recommended option:** **(a) keep.** The self-declared rationale is valid for this project: it is often opened without workspace context (when running iPhone trip workflows), and the input-handling rule is load-bearing for the verbatim-save behavior used by the personalization spine. Drift risk between the duplicate and the canonical is the cost; ergonomic safety on solo-project opens is the benefit.

**If APPLY (option b):**
- Files to touch: `projects/personal/CLAUDE.md` — replace the section with a pointer: `## Input File Handling\nSee workspace CLAUDE.md § Input File Handling.`
- Verification: Read CLAUDE.md and confirm the pointer.

**Risk:** Medium if applied. If the project is opened without the workspace CLAUDE.md loaded (the very condition the duplication addresses), the rule is silently inactive. Apply only if you are confident the workspace CLAUDE.md always loads.

---

### Fix 3 — FINDING-3 (LOW): Decide CLAUDE.md Commit Rules duplication

**Current state.** Same shape as FINDING-2. `projects/personal/CLAUDE.md § Commit Rules` is a verbatim duplicate of the workspace-canonical section, with the same self-declared rationale.

**Decision.** Same as Fix 2 — keep or replace with pointer.

**Recommended option:** **(a) keep.** Same reasoning as Fix 2. Commit Rules are load-bearing across every session; safer to duplicate than to risk silent rule-loss.

**If APPLY (option b):** Same shape as Fix 2 — replace with a pointer to workspace § Commit Rules.

**Risk:** Medium if applied. Same reasoning as Fix 2.

---

### Fix 4 — FINDING-8 (LOW): Update or freeze pipeline/repo-snapshot.md placeholders

**Current state.** `projects/personal/pipeline/repo-snapshot.md` lines 58–59 mark `profile/universal-traveler-profile.md` and `profile/travel-principles.md` as `EMPTY PLACEHOLDER`. Both files are now populated (301 and 444 lines respectively). The marker reflects the snapshot's state at Stage 3a, before Phase 0 completion.

**Decision.** Either (a) update the snapshot to reflect current state, or (b) freeze it as a historical pipeline artifact and add a header note.

**Recommended option:** **(b) freeze + note.** Pipeline outputs (`repo-snapshot.md`, `context-pack.md`, etc.) are point-in-time inputs to the project-creation pipeline. Updating them retroactively breaks their value as a historical record. Adding a one-line note at the top documents the staleness.

**If APPLY (option b):**
- Files to touch: `projects/personal/pipeline/repo-snapshot.md` — prepend a header note: `> Frozen 2026-04-XX (pipeline run date). Profile files marked EMPTY PLACEHOLDER below were populated 2026-05-11 — see profile/ directory for current state.`
- Verification: Read the top of the file.

**If APPLY (option a):**
- Files to touch: `projects/personal/pipeline/repo-snapshot.md` — replace the `EMPTY PLACEHOLDER` markers with current line counts.
- Verification: Read lines 58–59.

**Risk:** Low. The file is a working/reference artifact, not load-bearing.

---

## INFO findings (no action)

- **FINDING-1** — `/daily-program` and `/tomorrow-spar` commands not yet built (explicitly marked Future in CLAUDE.md "Workflow References").
- **FINDING-5** — `dossier-orchestrator` not in tier table (project-local agent, by design).
- **FINDING-9** — `red-team.md` has 5 of 8 phase sections empty (expected pre-operational stub).
- **FINDING-10** — Pipeline files, `logs/session-plan.md`, and all 75 `.claude/` symlinks untracked (working artifacts / by design).

---

## Risk Notes

- **FINDING-4** touches `ai-resources/docs/agent-tier-table.md` — outside this audit's scope. Recommended deferral keeps commit scopes clean.
- **FINDING-2** and **FINDING-3** affect always-loaded CLAUDE.md. If either is changed, run `/audit-claude-md` afterward to confirm the project's load remains coherent.
- All four fixes together are low-to-medium risk in aggregate. None touches hooks, none changes permissions, none introduces new automation.

---

## Next-Session Entry Point

Begin next session with:

1. `/prime`
2. `/session-start` with mandate: "Apply approved repo-dd fixes for projects/personal per implementation report."
3. `/session-plan` (will recommend opus)
4. Read this file and the audit
5. Mark APPLY/DEFER per fix
6. Execute approved fixes in priority order

End-state success: approved fixes applied and verified, commits made per scope, audit report and this implementation report committed (already done in the previous session per its commit step).
