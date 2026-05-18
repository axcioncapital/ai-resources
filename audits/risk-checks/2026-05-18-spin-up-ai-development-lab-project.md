# Risk Check — 2026-05-18

## Change

Proposed structural change: spin up a new Axcíon Claude Code project — projects/ai-development-lab/ — per the approved spec at projects/project-planning/output/ai-development-lab/tech-spec-v3.md and approved plan at projects/project-planning/output/ai-development-lab/project-plan-v1.md.

Change set (touches multiple change classes per ai-resources/docs/audit-discipline.md):
1. New project directory: projects/ai-development-lab/ with full scaffold (CLAUDE.md, .claude/{agents,commands,settings.json}, pipeline/, transcripts/, output/, logs/)
2. New project-local sub-agent: .claude/agents/ai-engineer.md (Opus, tools: Read/Grep/Glob/Write scoped to output/**)
3. New project-local slash commands: .claude/commands/analyze-transcript.md (Sonnet, orchestrates extraction → grilling → ai-engineer Task → system-owner Task → memo) and .claude/commands/produce-handoff.md (Sonnet, composes seed + prints next-step instructions)
4. New symlink: .claude/agents/system-owner.md → ai-resources/.claude/agents/system-owner.md (canonical agent consumed as-is)
5. New project settings.json with: allow list including Task tool (required for sub-agent dispatch); explicit read for ai-resources/docs/repo-architecture.md (load-bearing for Step 7 routing context); deny list covering rm/git push/git reset --hard + write blocks on transcripts/, pipeline/, ai-resources/
6. New pipeline reference docs (built in Phase 2-3): pipeline/ref-extraction.md, pipeline/ref-grilling.md, pipeline/ref-memo-template.md
7. Auto-sync symlinks from ai-resources/.claude/{commands,agents}/* will populate via SessionStart hook once shared-manifest.json is added

Context: this is the plan-time risk-check gate (before /new-project ingestion) per principles.md § DR-8 + risk-topology.md § 3 two-gate firing model. The spec passed structural QC twice (v2 + v3 both 0/0/0). The system-owner caught blockers in v2 that v3 fixed: programmatic /consult invocation replaced with direct Task dispatch (per toolkit-relationship.md § 1), pipeline/ref-axcion-context.md deleted (per principles.md § DR-5/AP-7 — no duplicated grounding), ai-engineer scope-boundary tightened (no Axcíon component-type naming), Task added to allow list, citation requirement (per principles.md § QS-4) added to memo Recommendation.

Open risk: per-run cost of system-owner Task dispatch (~27K tokens grounding base per invocation; flagged as OQ-12 to measure in Phase 4.2). No caching layer in v1.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/output/ai-development-lab/tech-spec-v3.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/output/ai-development-lab/project-plan-v1.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/ — not yet present (target directory)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/.claude/agents/ai-engineer.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/.claude/agents/system-owner.md — not yet present (will be symlink)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/.claude/commands/analyze-transcript.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/.claude/commands/produce-handoff.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/.claude/settings.json — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/CLAUDE.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/pipeline/ref-extraction.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/pipeline/ref-grilling.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/pipeline/ref-memo-template.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/system-owner.md — exists (symlink target)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/consult.md — exists (canonical brief structure reference for Step 7)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/repo-architecture.md — exists (load-bearing read for Step 7)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md — exists (change-class source)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/auto-sync-shared.sh — exists (the SessionStart hook that will auto-populate shared commands/agents into the new project once shared-manifest.json is added)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Standard new-project pattern that closely mirrors `projects/axcion-ai-system-owner/` (symlink to canonical agent, shared-manifest opt-out, project-local commands), but two material risks demand pre-landing mitigations — per-run `system-owner` Task dispatch cost (~27K tokens × N runs, unbounded in v1) and the deferred shared-manifest.json that gates auto-sync of every ai-resources command/agent into the project.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- New project CLAUDE.md is always-loaded for sessions in `projects/ai-development-lab/` only — not workspace-wide. Per the spec (tech-spec-v3.md § 3 "Root CLAUDE.md content"), it targets ≤120 lines of lean orientation with pipeline methodology kept in `pipeline/ref-*.md` (loaded on-demand). This isolates per-turn cost to lab sessions and is in line with the workspace CLAUDE.md scoping rule (CLAUDE.md § "CLAUDE.md Scoping").
- The `ai-engineer` sub-agent is invoked once per pipeline run (tech-spec-v3.md § 7 Step 6) — pay-as-used, not always-loaded. `model: opus` for judgment-heavy evaluation is consistent with agent-tier-table guidance per spec § 4.
- The `system-owner` Task dispatch in Step 7 reads `repo-architecture.md` (~5K tokens of routing context) + spawns a fresh `system-owner` subagent that reads `principles.md` + `system-doc.md` + `blueprint.md` + `risk-topology.md` + `repo-architecture.md` — quote from tech-spec-v3.md § 9: "approximately 27K tokens of grounding base per invocation." This is per-pipeline-run cost. For the stated cadence (one transcript per few days) this is bounded; for higher cadence or for ideas that produce repeated re-runs (Gate 1 resumption), it compounds without a caching layer.
- The expected per-run is roughly 27K (system-owner grounding) + ai-engineer context (extraction + grilling, low single-digit K) + memo synthesis. No always-loaded delta to workspace-wide sessions.
- OQ-12 (tech-spec-v3.md § 10) explicitly defers measurement to Phase 4.2 findings — accepting unknown unit economics into v1 with a fallback "propose scoped grounding reads as a System Owner project change."
- Once `shared-manifest.json` is added to the project, the auto-sync hook (ai-resources/.claude/hooks/auto-sync-shared.sh lines 70-93) will symlink every non-excluded ai-resources command/agent into the new project. This adds NO always-loaded cost — commands/agents are not loaded until invoked — but it does expand the on-demand surface visible from the lab project.

### Dimension 2: Permissions Surface
**Risk:** Medium

- The spec's settings.json (tech-spec-v3.md § 4 lines 285-318) is appropriately narrow:
  - `Read(./**)`, `Read(../../ai-resources/.claude/agents/**)`, `Read(../../ai-resources/docs/**)`, `Read(../../ai-resources/skills/**)`, `Read(../../CLAUDE.md)`, `Read(../../ai-resources/CLAUDE.md)` — bounded reads, no `Read(../../**)` wildcard.
  - `Write(./output/**)` and `Write(./logs/pipeline-log.md)` are tightly scoped — writes are confined to project output and the named log file.
  - Deny list explicitly covers `Bash(rm:*)`, `Bash(git push:*)`, `Bash(git reset --hard:*)`, `Write/Edit(./transcripts/**)`, `Write/Edit(./pipeline/**)`, and `Write/Edit(../../ai-resources/**)`. The deny list materially reduces the blast radius of any execution error.
- New capability allow-listed: `Task` (tech-spec-v3.md § 4 line 298). This is a new allow entry but is required for the architecture — the pipeline dispatches `ai-engineer` (Step 6) and `system-owner` (Step 7) via Task. Without it, every run would prompt for permission. Adding `Task` to a project allow list is consistent with existing project patterns (e.g., `projects/project-planning/` and `projects/axcion-ai-system-owner/` allow agent dispatch). Risk is bounded because the sub-agents themselves have constrained tools.
- `Bash(ls:*)` and `Bash(stat:*)` allow-listed — narrow read-only Bash glob patterns, consistent with the canonical permission-template approach (ai-resources/docs/permission-template.md referenced from repo-architecture.md § Canonical homes).
- One material gap: the spec's settings.json does NOT include the SessionStart hook entry that registers `auto-sync-shared.sh` (referenced in the change description as item 7). Without that hook entry, no auto-sync happens regardless of whether `shared-manifest.json` is added. Either both (manifest + hook registration in settings.json) land together, or neither — partial state means the project silently misses canonical ai-resources commands/agents.
- The spec's `Read(../../ai-resources/skills/**)` is the broadest read entry. Skills are static files, not executable — risk is low; but it widens the read surface beyond what the pipeline actually needs (Step 7 only reads `repo-architecture.md` + what `system-owner` reads transitively).
- No deny rule is removed; no scope escalation (project → user); no destructive Bash widened. Net: the change adds one new capability allow (Task) and one specific load-bearing read (`repo-architecture.md`), with a meaningful deny list. Both are narrow.

### Dimension 3: Blast Radius
**Risk:** Medium

- Direct file scope: new directory tree under `projects/ai-development-lab/` only. Grep across `ai-resources/`: zero existing references to `ai-development-lab` or "AI Development Lab" (verified via `grep -rln "ai-development-lab\|AI Development Lab" ai-resources/`). No existing component currently depends on this project.
- Downstream consumer: only Patrik's manual flow. `/produce-handoff` (tech-spec-v3.md § 7 Command 2 Step 5) prints instructions for Patrik to run `/context-builder` from `projects/project-planning/` — no programmatic cross-project invocation, no auto-write into other projects. The lab respects the cross-project boundary (tech-spec-v3.md § 9 "Why no direct invocation").
- Shared infrastructure touched:
  - `ai-resources/.claude/agents/system-owner.md` is symlinked into the new project. The symlink is read-only consumption — does NOT modify the canonical agent. Same pattern as `projects/axcion-ai-system-owner/.claude/agents/` which symlinks many canonical agents (verified: `claude-md-auditor.md`, `collaboration-coach.md`, etc., all symlinked from ai-resources).
  - `ai-resources/docs/repo-architecture.md` is read per pipeline run as Step 7 routing context. Read-only — no modification.
  - `ai-resources/.claude/hooks/auto-sync-shared.sh` will fire on SessionStart for this project once `shared-manifest.json` is present. The hook is idempotent (auto-sync-shared.sh line 76: "[ -e "$target" ] || [ -L "$target" ] && continue" — never overwrites). No risk to existing projects.
- Contract changes: none. The `system-owner` agent's invocation contract is encapsulated in its agent definition; the lab's Step 7 brief replicates `consult.md` Step 4's structure verbatim (tech-spec-v3.md § 7 Step 7d). If `consult.md` evolves, the lab's Step 7 needs a mirror update — tech-spec-v3.md § 9 flags this: "if `consult.md` Step 4 structure changes, mirror it."
- Existing components that could be affected: 0 commands currently depend on or invoke anything in `projects/ai-development-lab/` (does not exist yet). Grep across `ai-resources/.claude/commands/*.md` for `ai-development-lab`: zero matches.
- Indirect blast-radius vector: the auto-sync hook will symlink ~50 ai-resources commands and ~20 agents into the new project once the manifest lands. None modifies existing projects, but it exposes the lab project to every canonical command (including `/wrap-session`, `/friday-checkup`, `/improve`, etc.). Some of those commands write to `ai-resources/logs/**` — but the new project's settings.json denies `Write(../../ai-resources/**)` (tech-spec-v3.md § 4 line 313-314), which would BLOCK those writes if invoked from the lab. This is a real cross-coupling concern: a routine session command run from the lab project may fail or partially complete because of the deny rule.
- Enumeration of cross-coupling points (per ai-resources/.claude/commands/ list):
  - `/wrap-session` and `/usage-analysis` write to logs in the project's own `logs/` or `ai-resources/logs/usage-log.md` (per ai-resources/CLAUDE.md § Session Telemetry: "Run /usage-analysis at the end of every substantive session. Output goes to logs/usage-log.md"). The deny rule `Write(../../ai-resources/**)` blocks the latter target if it tries to write back to ai-resources/logs/.
  - `/friction-log` writes to logs/friction-log.md — needs verification of which scope.
  - `/risk-check` itself writes to ai-resources/audits/risk-checks/ — invoking it from inside the lab would hit the deny rule.
  - `/innovation-sweep`, `/log-sweep`, `/permission-sweep` — all write to ai-resources/audits/ or ai-resources/logs/, all blocked.

### Dimension 4: Reversibility
**Risk:** Low

- Revert is clean: `rm -rf projects/ai-development-lab/` plus a git revert of the commit that created it fully restores prior state. The project is self-contained — no edits to existing files outside the new directory.
- The symlink to `ai-resources/.claude/agents/system-owner.md` is a forward dependency only: deleting the project deletes the symlink, but the canonical target file is untouched.
- No write into `ai-resources/` happens because of this change — the spec's settings.json explicitly denies `Write/Edit(../../ai-resources/**)` (tech-spec-v3.md § 4 lines 313-314).
- No log append-only mutation: `pipeline-log.md` lives inside the new project's `logs/`, not in shared ai-resources logs. Revert removes it entirely.
- No git push, no Notion write, no external API call attached to the project creation itself.
- Once auto-sync hook fires on first session, the project's `.claude/{commands,agents}/` will contain ~50-70 symlinks pointing into ai-resources. Reverting the project removes those symlinks (they live in the deleted directory). Ai-resources is untouched.
- Minor cleanup: if Patrik has already invoked `/analyze-transcript` and produced one or more runs in `output/memos/`, those would also be removed by the revert — but that is expected output of the project and not residual state.
- One edge case: if `pipeline-log.md` has been committed across multiple sessions and built up disposition history, revert undoes all entries cleanly because the file lives in-project. No stale entries propagate forward.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Coupling #1: `consult.md` Step 4 brief structure.** Tech-spec-v3.md § 7 Step 7d hard-codes the verbatim brief structure replicating `consult.md` Step 4. If `consult.md` evolves (e.g., the brief structure changes, a new field is added, the routing-context format shifts), the lab's `/analyze-transcript` Step 7 will be silently stale. There is no automated check that mirrors the two structures. The spec flags this (§ 9 "if `consult.md` Step 4 structure changes, mirror it") but offers no enforcement mechanism. This is the highest-risk coupling because the contract is undocumented from `consult.md`'s side — `consult.md` does not know it has a downstream mirror.
- **Coupling #2: `system-owner` agent's read map.** The Task dispatch in Step 7 assumes `system-owner` will read `principles.md` + `system-doc.md` + `blueprint.md` + `risk-topology.md` + `repo-architecture.md` (tech-spec-v3.md § 9 per-run cost note). The 27K-token figure depends on that read map. If `system-owner`'s grounding read map expands (e.g., adds a new reference), the per-run cost grows silently. The spec does not pin a version or hash of system-owner.md.
- **Coupling #3: `repo-architecture.md` size and shape.** Step 7b reads the full file as `ROUTING_CONTEXT` (tech-spec-v3.md § 7 Step 7b). If repo-architecture.md grows substantially (currently ~250 lines per the read at /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/repo-architecture.md), every pipeline run's Step 7 cost scales linearly with it. There is no truncation or section-extraction logic.
- **Coupling #4: Auto-sync hook and shared-manifest.json.** Change-description item 7 says "Auto-sync symlinks from ai-resources/.claude/{commands,agents}/* will populate via SessionStart hook once shared-manifest.json is added." This is deferred — the project ships without the manifest. Until the manifest lands AND the SessionStart hook entry is added to project settings.json, the lab is in a partial state: project-local commands work, canonical ai-resources commands (e.g., `/wrap-session`) do NOT auto-sync. Spec § 2 setup instructions (tech-spec-v3.md § 2 lines 121-134) do not mention `shared-manifest.json` creation as a Phase 1 step. The change description acknowledges the deferral but does not bind it to a phase.
- **Coupling #5: Deny rule vs. shared command writes.** The spec's `Write(../../ai-resources/**)` deny rule (tech-spec-v3.md § 4 line 313-314) blocks writes that several canonical commands depend on — `/usage-analysis` writing to `ai-resources/logs/usage-log.md` (per ai-resources/CLAUDE.md § Session Telemetry); `/risk-check`, `/innovation-sweep`, `/log-sweep`, `/friday-checkup` all writing to `ai-resources/audits/` or `ai-resources/logs/`. Once auto-sync populates these commands into the lab project, invoking any of them from a lab session would silently hit the deny and either fail or partially complete. This is a functional overlap collision between the new project's settings.json and existing canonical commands' write contracts.
- **Coupling #6: Manual disposition + memo immutability discipline.** Tech-spec-v3.md § 8 "Run directory lifecycle" relies on operator discipline (immutability is "a discipline rule, not a technical lock"). Pipeline-log.md disposition column is updated manually. If the operator's discipline drifts (e.g., editing a completed memo), no system catches it.
- **Coupling #7: ai-engineer ↔ system-owner scope boundary.** The spec adds a runtime boundary check (tech-spec-v3.md § 7 Step 6 "Boundary check") that scans for Axcíon component-type words in ai-engineer output. This is a soft check (logs and proceeds, does not halt). Reliance on the agent's system prompt to honor the boundary is genuine — there is no test-driven enforcement.

## Mitigations

Required before landing (paired with the Coupling #1, #4, #5 High-risk concerns):

- **Mitigation for Coupling #4 (auto-sync deferral):** Land `shared-manifest.json` AND the SessionStart hook entry in `.claude/settings.json` in the same commit as the project scaffold (Phase 1, work unit 1.1). Use the existing `projects/axcion-ai-system-owner/.claude/shared-manifest.json` as the template — that project's manifest is the closest analog (also symlinks system-owner.md as a local agent). Do not ship Phase 1 without these two files, otherwise the project starts in partial state where canonical commands are invisible.
- **Mitigation for Coupling #5 (deny rule blocks canonical command writes):** Before landing the settings.json deny list, enumerate the canonical commands that would auto-sync into the lab and identify which ones write to `ai-resources/`. At minimum: `/usage-analysis`, `/risk-check`, `/innovation-sweep`, `/log-sweep`, `/permission-sweep`, `/friday-checkup`, `/friday-act`, `/wrap-session`. For each, decide whether (a) the lab project legitimately needs to invoke it (carve a narrow allow exception in settings.json — e.g., `Write(../../ai-resources/audits/risk-checks/**)` if `/risk-check` should be runnable from the lab); (b) the lab opts out via `shared-manifest.json` commands.local entry (preferred for commands not relevant to lab operation); or (c) accept the deny and document in CLAUDE.md that these commands must be run from another project. Apply the audit-discipline.md § "Applying Audit Recommendations" top-3-commands check before locking settings.json.
- **Mitigation for Coupling #1 (consult.md Step 4 mirror staleness):** In `pipeline/ref-grilling.md` (or a new `pipeline/ref-step7-brief.md`), add a one-line "mirror source" reference: "This brief structure mirrors `ai-resources/.claude/commands/consult.md` Step 4 as of {YYYY-MM-DD}. Verify alignment when `consult.md` changes." Add to the Phase 4.2 integration test checklist: "Re-read `consult.md` Step 4; confirm `/analyze-transcript` Step 7d brief structure still matches." This is a manual mirror-discipline contract — not enforcement, but a flag the operator can act on.
- **Mitigation for Coupling #2 (system-owner read map drift) — optional but recommended:** In `pipeline/ref-memo-template.md`, add the OQ-12 cost-measurement field to the memo metadata block (per-run token cost observed). When Phase 4.2 measures actual cost and finds it ≥ acceptable, set a threshold in `pipeline-log.md` Notes column. If cost drifts upward in future runs, the log surfaces it.
- **Mitigation for Coupling #3 (repo-architecture.md growth):** No action required for v1 (file is currently ~250 lines and reads cheaply). Add to Phase 4.2 findings: record `repo-architecture.md` size at first run; flag if it grows >50% between runs.
- **Mitigation for Dimension 2 (Task allow + shared-manifest combined surface):** When Phase 1 lands, validate that the project's effective allow list (settings.json + auto-synced canonical commands' implicit needs) does not silently widen permissions beyond intent. Run `/permission-sweep` against the new project after Phase 1 commit to confirm drift baseline.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from tech-spec-v3.md / project-plan-v1.md / system-owner.md / consult.md / repo-architecture.md / audit-discipline.md / auto-sync-shared.sh / CLAUDE.md, and ls output for `projects/axcion-ai-system-owner/.claude/agents/`). No training-data fallback was used. Files tagged `not yet present` (the lab project directory and all child files) were evaluated based on the explicit spec content; the spec is dense enough that no INCOMPLETE dimension flag was needed.
