# Risk Check — 2026-05-14

## Change

End-time gate — all in-class changes landed this session in nordic-pe-macro-landscape-H1-2026:

(1) ai-resources/docs/agent-tier-table.md — appended qc-gate (sonnet) and verification-agent (sonnet) to main table; added new "Project-local agent copies" subsection with execution-agent (sonnet) and improvement-analyst (opus) for nordic-pe project copies. Commit 8d6dc9f in ai-resources repo.

(2) .claude/commands/status.md → .claude/commands/project-status.md — git mv rename. Commit 2cba686.

(3) reference/skills/report-compliance-qc/SKILL.md — deleted via git rm. Commit c498c1b.

(4) .claude/settings.local.json — new file (gitignored): {"env": {"CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING": "1"}}. No permissions block.

(5) .claude/settings.json — added check-claim-ids.sh to PostToolUse(Write) hooks group (5th hook); added check-permission-sanity.sh to first SessionStart hooks group (5th hook). Commit 86eafc8.

(6) .claude/hooks/check-skill-size.sh — deleted. Commit 86eafc8.

No Model Selection section added to CLAUDE.md (operator decided not to declare a default).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/agent-tier-table.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/.claude/commands/project-status.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/.claude/commands/status.md — not yet present (renamed)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/reference/skills/report-compliance-qc/SKILL.md — not yet present (deleted)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/.claude/settings.local.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/.claude/settings.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/.claude/hooks/check-claim-ids.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/.claude/hooks/check-permission-sanity.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/.claude/hooks/check-skill-size.sh — not yet present (deleted)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** All six changes are individually clean and consistent with prior-session risk-check guidance, but two residual stale-reference items in `ai-resources/workflows/research-workflow/` and a stale `status.md` reference inside the active `run-report.md` should be tracked as follow-up.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Change (1) agent-tier-table.md is an on-demand reference, not always-loaded — its front-of-file note states "When to read this file: When adding a new agent…not needed for every turn" (agent-tier-table.md line 3). Adding 4 rows (~600 bytes) has no per-turn cost.
- Change (2) command rename — `/project-status` is on-demand; cost unchanged from `/status`.
- Change (3) skill deletion — removes ~5KB from disk; no ongoing cost change since the skill was already orphaned (no longer referenced by run-report.md in the project, which now points to canonical at `/ai-resources/skills/report-compliance-qc/SKILL.md`, run-report.md line 62).
- Change (4) settings.local.json — `env` key only; no `@import`, no hook, no permission block. Adaptive-thinking flag is a runtime toggle, not a token-cost item.
- Change (5) two new hooks. `check-claim-ids.sh` is silent unless `[CITATION NEEDED]` tags appear in pipeline paths `analysis/chapters|cluster-memos|report/chapters|execution/research-extracts` (script lines 10, 19) — pay-as-used. `check-permission-sanity.sh` runs once per SessionStart and is silent when defaultMode is `bypassPermissions` and the deny-floor entries are present (script lines 48–69). settings.json verified: `defaultMode: "bypassPermissions"` is set (line 32) and both `Bash(rm -rf *)` and `Bash(sudo *)` are in the deny array (lines 24–25). Net per-session token impact <10 tokens (silent path).
- Change (6) deletion of unwired script — pure cleanup, zero ongoing cost.

### Dimension 2: Permissions Surface
**Risk:** Low

- Change (4) settings.local.json contains no `permissions` block (verified — only `env` key) so it does not shadow settings.json's permissions. This is exactly the configuration the `check-permission-sanity.sh` nudge logic green-lights (script lines 47–49).
- Change (5) does not alter the `permissions` block in settings.json. Hook additions do not widen the tool-permission surface; they only register callbacks within already-allowed shell execution.
- No `allow`/`deny`/`defaultMode` changes anywhere this session.

### Dimension 3: Blast Radius
**Risk:** Medium

- Change (1) tier-table is reference-only; no callers depend on its contents at runtime. Zero downstream-code impact.
- Change (2) `/status` → `/project-status`. Grep for `status.md` and `/status` references found stale tokens in inactive paths only: `logs/session-plan.md` lines 18, 30 and `logs/session-notes.md` lines 60, 68, 95, 98, 102, 104, 121 — all reflective journal entries, not callers. Notably also stale in `ai-resources/audits/repo-due-diligence-2026-05-12-project-nordic-pe-macro-landscape-H1-2026.md` (audit document, historical record). No active command, hook, or skill file in the project invokes `/status`.
- Change (3) skill deletion. Grep for `report-compliance-qc` across the project found ONE active runtime reference: `projects/nordic-pe-macro-landscape-H1-2026/.claude/commands/run-report.md` line 62 — this references the **canonical** path `/ai-resources/skills/report-compliance-qc/SKILL.md` (not the deleted local copy). Verified canonical exists at `ai-resources/skills/report-compliance-qc/SKILL.md`. So deletion of the local copy does not break run-report.md.
- **Residual stale references found:** `ai-resources/workflows/research-workflow/SETUP.md` lines 77, 83 still document "Skip if a local copy already exists (knowledge-file-producer, report-compliance-qc)" / "Local skills (`knowledge-file-producer`, `report-compliance-qc`) remain as real directories." These are SETUP.md template instructions for *new* projects spun from the research-workflow template, NOT for nordic-pe specifically. They contradict the new "use canonical only" convention this session established. Also `ai-resources/workflows/research-workflow/reference/skills/report-compliance-qc/SKILL.md` and `ai-resources/workflows/research-workflow/.claude/commands/run-report.md` (line 62) — the template copies remain in the workflow template. Not a blast hit to nordic-pe, but a documentation-drift hit at the workflow template level that future projects will inherit.
- Change (5) hook wiring: settings.json's PostToolUse(Write) group already had 4 hooks (auto-commit, log-write-activity, detect-innovation, auto-qc-nudge); 5th is additive. SessionStart first group already had 4 hooks (checkpoint loader, template-drift, auto-sync-shared, check-archive); 5th is additive. Hook ordering within a matcher group is sequential per Claude Code semantics — added hooks run last, no impact on existing hook outputs.
- Change (6) check-skill-size.sh deletion: grep confirms no references in settings.json, no shell scripts in the project source it, no commands invoke it. Pure removal, zero callers.

Enumeration of blast-radius checks performed:
- `status.md` / `/status` regex: 13 stale doc references; 0 active callers in nordic-pe project.
- `report-compliance-qc` regex: 1 active reference in nordic-pe (run-report.md line 62, points to canonical, not deleted local copy); 4 references in `ai-resources/workflows/research-workflow/` (template-level, follow-up needed).
- `check-skill-size` regex: 0 active callers anywhere in the project; only historical audit mentions.

### Dimension 4: Reversibility
**Risk:** Low

- Changes (1), (2), (3), (5), (6) are all in committed git history (commits 8d6dc9f, 2cba686, c498c1b, 86eafc8). Single `git revert <sha>` per change cleanly restores prior state.
- Change (4) settings.local.json is gitignored (verified: `~/.config/git/ignore` matches `**/.claude/settings.local.json`). To roll back: delete the file or remove the `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING` env entry. No git history complication.
- No external pushes this session (verified: project repo's most recent push status would have to be confirmed by operator, but no commands in this set wrote to Notion, external APIs, or non-git state).
- No automation fired between change-landing and the gate: hooks added in change (5) only run on PostToolUse(Write) for pipeline paths or SessionStart on next session start — not retroactive.
- Change (3) is a `git rm` of a file; revert restores the file. No log mutation.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- Change (1) tier-table addition declares the project-local copies of `execution-agent` and `improvement-analyst` as the only project-local agents. However, filesystem enumeration shows three project-local agents (real files, not symlinks): `execution-agent.md`, `improvement-analyst.md`, AND `qc-gate.md` and `verification-agent.md` (also real files per `ls -la`). The two newly added entries to the canonical table (qc-gate, verification-agent) are correct as canonical agents, but the "Project-local agent copies" subsection only enumerates 2 of 4 project-local real-file agents. `qc-gate.md` and `verification-agent.md` exist as real files in `projects/nordic-pe-macro-landscape-H1-2026/.claude/agents/` (not symlinks per `ls -la` output). This creates a documentation gap: the new subsection's stated purpose ("Tracked here to satisfy F-9 of the 2026-05-12 repo-dd audit") implies completeness but lists only half.
- Change (3) introduces an implicit new contract: nordic-pe project now relies on the canonical `ai-resources/skills/report-compliance-qc/SKILL.md` being kept stable. This is implicit, not documented. The workspace SKILL-source-of-truth rule (workspace CLAUDE.md "Do NOT edit skill files from project workspaces — make changes in the ai-resources repo directly") covers this, but the project CLAUDE.md does not mirror it for this specific skill — it relies on the workspace rule.
- Change (5) `check-permission-sanity.sh` is structurally coupled to settings.json's deny-floor convention (`Bash(rm -rf *)`, `Bash(sudo *)`). Verified: both are present in settings.json deny array (lines 24–25). If a future settings.json edit removes either, the hook fires on every session start. Coupling is well-documented inside the script (lines 53–63), so this is a Medium not High — the convention is named at the source.
- Change (5) `check-claim-ids.sh` couples to specific path conventions (`/analysis/chapters/`, `/analysis/cluster-memos/`, `/report/chapters/`, `/execution/research-extracts/`) — these match the workflow's `reference/stage-instructions.md` conventions per the project. If pipeline directory structure changes, the hook silently no-ops. Coupling is named at the hook site (script line 10).
- Change (2) `/project-status` rename: no command-level coupling broken because the project never had downstream invokers; stale references in `logs/` are journal entries. Coupling is clean.

### Prior risk-check alignment

The prior session risk-check (`ai-resources/audits/risk-checks/2026-05-14-session-resolve-deferred-repo-dd-findings.md`) flagged `check-skill-size.sh` wiring as the highest-risk item with a specific mitigation: "Do NOT wire `check-skill-size.sh` as a PreToolUse or PostToolUse hook. Either (a) keep the script unwired but documented as a manual pre-commit utility, or (b) move it under `.claude/hooks/pre-commit`." The operator chose a third path: delete the script entirely (commit 86eafc8). This is consistent with the recommendation and arguably the cleanest resolution since no `.claude/hooks/pre-commit` infrastructure exists in the project. The mitigation was honored.

## Mitigations

- **Mitigation for Dimension 3 (Blast Radius — workflow-template drift):** Open a follow-up to update `ai-resources/workflows/research-workflow/SETUP.md` (lines 77, 83) and remove or update `ai-resources/workflows/research-workflow/reference/skills/report-compliance-qc/` so new projects spun from the template inherit the "use canonical only" convention. This is template-level cleanup, not a nordic-pe blocker.
- **Mitigation for Dimension 5 (Hidden Coupling — incomplete tier-table subsection):** Update `ai-resources/docs/agent-tier-table.md` "Project-local agent copies" subsection to include `qc-gate` and `verification-agent` (both are real files in `projects/nordic-pe-macro-landscape-H1-2026/.claude/agents/`, not symlinks per filesystem check). Without this, the subsection's stated purpose (satisfy F-9) is half-met. One-line table edit.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references (agent-tier-table.md lines 3, 31, 41, 45–53; project settings.json lines 24, 25, 32, 73–107, 133–166; project settings.local.json lines 1–5; check-claim-ids.sh lines 10, 19; check-permission-sanity.sh lines 35–69; project run-report.md line 62; ai-resources CLAUDE.md lines 29–30; workspace CLAUDE.md "Skill Library" section); filesystem state checks (settings.local.json gitignored per `~/.config/git/ignore`; project agents dir shows `qc-gate.md` and `verification-agent.md` as real files via `ls -la`; check-skill-size.sh absent from hooks dir); grep counts (status.md: 13 stale doc refs, 0 active; report-compliance-qc: 1 active runtime ref pointing to canonical, 4 template-level refs in ai-resources/workflows; check-skill-size: 0 active callers); git log evidence (commits 8d6dc9f, 2cba686, c498c1b, 86eafc8); cross-reference with prior risk-check (2026-05-14-session-resolve-deferred-repo-dd-findings.md). No training-data fallback was used on fetch/read failures.
