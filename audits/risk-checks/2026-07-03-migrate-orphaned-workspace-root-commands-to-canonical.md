# Risk Check — 2026-07-03

## Change

Migrate 2 orphaned real command files from workspace-root .claude/commands/ into the canonical ai-resources/.claude/commands/ library, plus their dependencies: (1) run-qc.md → ai-resources/.claude/commands/run-qc.md (its dependency, skills/workflow-evaluator/SKILL.md, already lives in ai-resources, so this is a straight copy); (2) validate.md → ai-resources/.claude/commands/validate.md, together with its dependent agent output-validator.md → ai-resources/.claude/agents/output-validator.md (currently only exists at workspace-root .claude/agents/output-validator.md), plus registering the new agent in ai-resources/docs/agent-tier-table.md. Separately, decide whether workspace-root .claude/commands/update-md.md is a redundant duplicate of the canonical ai-resources/.claude/commands/update-claude-md.md (both edit a CLAUDE.md file; update-md.md is generic/workspace-root-scoped, update-claude-md.md is described as project-CLAUDE.md-scoped) — outcome is either delete update-md.md as superseded, keep both, or migrate-and-merge. Also: correct a stale improvement-log.md entry ("2026-07-03 — Workspace-root .claude/commands/ is neither subset nor superset of canonical") to reflect that 2 of the "5 root-only commands" it names (harness-start.md, session-report.md) are NOT orphans — they are the intentional operator-facing entry points of a self-contained, already-documented "Agent Harness" subsystem (workspace CLAUDE.md § Agent Harness) with workspace-root-only skill dependencies (.claude/skills/mandate-parser, session-governor, session-reporter) and should stay workspace-root-scoped, not migrate. Also annotate two friction-log.md entries (2026-06-09 S5, 2026-06-10 S1, about a session-feedback-collector destructive-overwrite hazard) as resolved — verified live that commit 0ee6177 already removed the Write tool from that agent's toolset and added an append-only-only Constraint E, so the hazard is fixed and these entries are stale.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/run-qc.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/validate.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/update-md.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/harness-start.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/session-report.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/agents/output-validator.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/run-qc.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/validate.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/output-validator.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/update-claude-md.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/agent-tier-table.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/friction-log.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/session-feedback-collector.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A well-placed, principle-aligned curation-and-cleanup change (DR-1/DR-3/OP-12) whose only elevated risk is process, not design: three Medium dimensions all trace to editing two shared append-only logs in place while a concurrent S2 session is live in the same checkout, plus one un-annotated parallel claim in friction-log line 222.

## Consumer Inventory

Note — the three canonical targets (`ai-resources/.claude/commands/run-qc.md`, `.../validate.md`, `ai-resources/.claude/agents/output-validator.md`) are tagged `not yet present`; I verified they do not exist in canonical yet (`ls` on both dirs: only `update-claude-md.md` present in commands, no `output-validator` in agents). Their contribution is evaluated from the existing **workspace-root source files I read** (identical content will be copied) plus the described copy intent. The inventory below covers consumers of the change targets and of the contract each migrated file introduces into canonical.

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/.claude/agents/output-validator.md (new canonical) — referenced by canonical validate.md | co-edits | yes |
| ai-resources/docs/agent-tier-table.md (add output-validator row) | co-edits | yes |
| ai-resources/logs/friction-log.md line 222 (2026-07-02 secondary finding — parallel "migrate all 5" claim) | documents | no (gap — see D3/D5) |
| ai-resources/skills/claude-code-workflow-builder/SKILL.md:75 ("requires slash command at `.claude/commands/run-qc.md`") | documents | no |
| ai-resources/skills/prompt-creator/SKILL.md:10 ("use update-claude-md") | documents | no (only under merge outcome) |
| ai-resources/docs/onboarding-daniel-cheatsheet.md:44 (`/update-claude-md` row) | documents | no (only under merge outcome) |
| ai-resources/docs/session-rituals.md:126 (`/update-claude-md`) | documents | no (only under merge outcome) |
| ai-resources/.claude/commands/placement.md:44 (points to agent-tier-table.md) | documents | no |
| ai-resources/docs/repo-architecture.md:262 (agent-tier-table.md line item) | documents | no |
| /Users/.../Axcion AI Repo/CLAUDE.md:175 (agent-tier-table.md pointer) | documents | no |
| workspace-root .claude/skills/{mandate-parser, session-governor, session-reporter} — depended on by harness-start.md / session-report.md | imports | no (confirmed workspace-root-only; harness stays put) |

Total: 11 distinct consumers, 2 must-change (`output-validator` co-move into canonical agents + its `agent-tier-table.md` row) — both anticipated by CHANGE_DESCRIPTION. The 3 `update-claude-md` documentation consumers become must-change **only** if the deferred update-md decision resolves to migrate-and-merge. friction-log line 222 is a must-annotate gap the change does not name.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded file gains weight. `run-qc.md` and `validate.md` are pay-as-used slash commands (invoked on demand); neither is imported or auto-loaded — verified they carry no SessionStart/Stop/PreToolUse hook and no `@import`.
- `output-validator.md` is `model: opus` but spawned only by `/validate` on demand (validate.md:17 "Spawn the `output-validator` agent") — not a per-session or per-tool-call subagent. Its brief is compact (~53 lines, two-question format).
- `agent-tier-table.md` gains one row; that file is explicitly not always-loaded — its header states "Not needed for every turn" (agent-tier-table.md:3).
- Log edits (improvement-log.md, friction-log.md) add no runtime token cost.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json` / `settings.local.json` touched; no `allow`/`ask`/`deny` entry added, removed, or widened. CHANGE_DESCRIPTION names no settings file.
- The migrated `output-validator.md` declares a read-only toolset — `tools: Read, Grep, Glob` (output-validator.md:5-8) — narrower than most agents; no Bash/Write/external capability introduced.
- All writes land inside `ai-resources/` (canonical commands, agents, docs, logs) — within established placement patterns; no cross-repo or scope-escalating write.

### Dimension 3: Blast Radius
**Risk:** Medium

- Direct files touched: ~6–7 — new canonical `run-qc.md`, `validate.md`, `output-validator.md`; edits to `agent-tier-table.md`, `improvement-log.md`, `friction-log.md`; plus `update-md.md` (delete/keep/merge, undecided).
- Must-change consumers from the inventory: **2** — `output-validator.md` must co-land in `ai-resources/.claude/agents/` (canonical validate.md:17 references it by name) and `agent-tier-table.md` must gain its row. Both are anticipated by CHANGE_DESCRIPTION. Compatible, additive.
- No contract change: migrated commands keep identical invocation syntax (`/run-qc {path}`, `/validate $ARGUMENTS`); no parse marker, heading, or frontmatter schema changes. No existing caller breaks — the workspace-root originals stay in place, so any workspace-root session still resolves `/run-qc` and `/validate`; the migration is purely additive for canonical-symlinked projects.
- **Unanticipated consumer (gap):** `friction-log.md:222` (2026-07-02 secondary finding) carries the same "migrate the 5 real root-only command files into the canonical" recommendation that the improvement-log correction supersedes. The change corrects improvement-log line 574 but does not touch friction-log 222 — after landing, the two logs disagree on whether harness-start/session-report should migrate. That is a blast-radius finding the change did not name.
- Deferred update-md decision widens radius conditionally: a migrate-and-merge outcome pulls in the 3 `update-claude-md` documentation consumers (prompt-creator SKILL.md, onboarding cheatsheet, session-rituals); delete/keep leaves them untouched.

### Dimension 4: Reversibility
**Risk:** Medium

- The additive parts revert cleanly: `git revert` of the add-commit removes the three new canonical files and the agent-tier-table row; a delete of `update-md.md` (if chosen) is restored by revert. These alone would be Low.
- The elevating factor is the two **in-place edits to shared append-only logs** — `improvement-log.md` (rewrite the body of the 2026-07-03 "neither subset nor superset" entry, line 570-574) and `friction-log.md` (annotate the 2026-06-09 S5 / 2026-06-10 S1 collector entries, lines 168-172 / 177-182). A concurrent S2 session is live in the **same checkout**; S2's own `/wrap-session` Step 6.5 (session-feedback-collector) appends to both logs. If S2 appends between this change committing and any later revert, `git revert` of this change's log edits can conflict with or clobber S2's appends — the append-only-log-mutation-during-concurrent-write hazard already documented in this repo (friction-log 2026-06-09 S3: shared-staging-index entanglement).
- No state propagates beyond git (no push, no external write) — push is gated to wrap per workspace rules.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Agent-resolution dependency (documented at change site):** canonical `validate.md` will reference the `output-validator` agent by name (validate.md:17). If validate.md lands in canonical but `output-validator.md` is absent from `ai-resources/.claude/agents/` or missing its tier-table registration, `/validate` silently fails to spawn the agent in canonical-symlinked project sessions. CHANGE_DESCRIPTION names this dependency explicitly — one implicit dependency, documented.
- **Parallel-claim coupling (undocumented):** friction-log 222 and the improvement-log entry both encode the "migrate all 5" recommendation; correcting one without the other leaves them silently coupled and divergent (see D3).
- **Concurrent shared-log coupling (undocumented):** CHANGE_DESCRIPTION asserts "zero file overlap with S2's declared scope." True for S2's *edit* set — but `improvement-log.md` and `friction-log.md` are shared write surfaces that S2's wrap-collector appends to regardless of S2's declared edit scope. Declared-scope non-overlap is not log-file non-overlap. This is a silent coupling on shared state.
- **Coupling correctly avoided (credit):** the change keeps harness-start/session-report workspace-root because their skill dependencies (`mandate-parser`, `session-governor`, `session-reporter`) live only at workspace-root — verified: `ls` finds these three skills under `.../Axcion AI Repo/.claude/skills/` and **not** under `ai-resources/skills/`. Migrating those two commands would have broken skill resolution; the change avoids that coupling error.

### Dimension 6: Principle Alignment
**Risk:** Low

- **DR-1 / DR-3 (placement) — served, not violated.** Migrating generic, multi-project-serving commands (`/run-qc` = workflow QC, `/validate` = analytical-output validation) into `ai-resources/` is the direct application of DR-1 ("could this serve more than one project?") and DR-3 (component type → canonical home). Correct tier.
- **OP-12 (closure before detection) — actively served.** The change is closure/consolidation work: it completes a migration and retires two classes of stale log entries. It adds **no** new detection, scan, or finding-generator. Counts *for* the change under OP-12.
- **OP-9 / AP-7 / DR-7 (speculative abstraction) — not triggered.** No generalization for an absent consumer; `output-validator` already has a live consumer (`validate.md`). No "hooks for later." The Step 1.5 inventory shows real, present consumers.
- **OP-5 (advisory vs enforcement) — no upgrade.** `/validate` stays advisory — validate.md:23 "Do not auto-fix — validation findings require operator judgment." No enforcement authority introduced.
- **OP-10 (system boundary) — untouched.** No cross-tool coordination added.
- **QS-6 / GAP-1 / GAP-2 — respected.** Workspace-root is a legitimate tier (GAP-1 RESOLVED); the change migrates only the genuinely-canonical items and explicitly keeps the harness subsystem workspace-root, rather than over-enforcing a "everything must be canonical" rule.
- **OP-11 (loud, recorded revision) — served.** Correcting the improvement-log entry and annotating the friction-log entries is a loud, recorded correction of a prior record — exactly the OP-11 posture. The staleness claim is evidence-grounded: commit `0ee6177` is confirmed to have modified `session-feedback-collector.md`, and the live agent file has no `Write` tool (tools: Read/Glob/Grep/Edit/Bash) and carries the append-only "Constraint E" (session-feedback-collector.md:75) — so the two friction entries are genuinely stale.
- **DR-10 (process constraint, not a violation) — must be honored at landing.** The change lands during a disclosed concurrent session; DR-10 forbids directory-wildcard `git add` during concurrent sessions. Aligned as long as staging is file-specific (see Mitigations).

## Mitigations

- **Dimension 3 (blast radius):** In the same change, annotate `friction-log.md:222` (the 2026-07-02 secondary finding) to match the corrected improvement-log entry — mark harness-start/session-report as intentional Agent-Harness entry points, not migrate targets — so the two logs do not disagree on the recommendation.
- **Dimension 4 (reversibility):** Stage each added/edited file explicitly by path — no `git add -A`, `git add .`, or directory wildcards (DR-10, S2 is live in this checkout) — and land the migration as one focused commit so any later `git revert` targets only these paths and cannot entangle S2's concurrent log appends.
- **Dimension 5 (hidden coupling):** After copying `validate.md` into canonical, verify `output-validator.md` is present in `ai-resources/.claude/agents/` and has its `agent-tier-table.md` row before considering the change complete — otherwise `/validate` silently fails to spawn in canonical-symlinked project sessions. For both log edits, re-read the last ~10 lines and re-anchor immediately before each in-place Edit; if S2's wrap-collector has appended since your last read, re-verify the anchor still matches before writing.
- **Deferred update-md decision:** Resolve the delete/keep/merge outcome explicitly before landing. `delete` is a file deletion (revert-recoverable — note it in the commit); `migrate-and-merge` promotes the 3 `update-claude-md` documentation consumers to must-change (D3) and should re-run this check for that outcome. `keep both` is the lowest-radius outcome if the workspace-root-vs-project scope distinction is genuine.

## Recommended redesign

- Not applicable (verdict is PROCEED-WITH-CAUTION, not RECONSIDER).

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references (validate.md:17/23, output-validator.md:5-8, agent-tier-table.md:3, session-feedback-collector.md:75, friction-log.md:222/168-172/177-182, improvement-log.md:570-574, claude-code-workflow-builder/SKILL.md:75), `ls` verification of target-directory and skill-dependency locations, `git show --stat 0ee6177` confirming the collector-hardening commit, grep counts across active resource dirs and workspace root, and principle IDs cited from `projects/strategic-os/ai-strategy/principles-base.md` (DR-1, DR-3, DR-7, DR-10, OP-5, OP-9, OP-10, OP-11, OP-12, AP-7, QS-6, GAP-1/2). No training-data fallback was used on any read.
