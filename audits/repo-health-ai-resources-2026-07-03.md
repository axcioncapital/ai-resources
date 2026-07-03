# Workspace Health Report

**Date:** 2026-07-03
**Mode:** Full Audit
**Overall:** GREEN

---

## Executive Summary

The `ai-resources` repo is in strong health: across all seven audited areas there are **zero Critical and zero Important findings** — every finding is Minor or advisory. The library is mature and well-utilized (84 canonical commands, 80 skills, 40 canonical agents) with deliberate 3-tier model assignment, lean load-on-demand CLAUDE.md cores, context-isolated QC subagents, filesystem-first verification, and mechanical-only advisory hooks. The single highest-value cleanup is deleting the gitignored `output/deploy-test-scratch-2026-06-12/` directory — one action clears four of the recurring Minor findings across File Organization, CLAUDE.md, Commands, and Settings. Nothing blocks normal operation.

## Scores

| Area | Score | Critical | Important | Minor |
|------|-------|----------|-----------|-------|
| File Organization | GREEN | 0 | 0 | 1 |
| CLAUDE.md Health | GREEN | 0 | 0 | 0 |
| Skill Inventory | GREEN | 0 | 0 | 5 |
| Commands & Subagents | GREEN | 0 | 0 | 1 |
| Settings & Permissions | GREEN | 0 | 0 | 3 |
| 2026 Best Practices | GREEN | 0 | 0 | 2 |
| Context Health | GREEN | 0 | 0 | 4 |

## Findings

### Critical (Fix Now)

No critical findings.

### Important (Fix Soon)

No important findings.

### Improvement Opportunities

- **[2026 Best Practices] One gitignored scratch dir is the single root cause behind 4 of 5 Wave-1 auditors' minor findings**
  `output/deploy-test-scratch-2026-06-12/` (confirmed gitignored) is a leftover deploy-test scaffold containing a nested CLAUDE.md, its own `.claude/settings.json`, SETUP.md, and a full project tree. It independently tripped four Wave-1 auditors: file-org (undocumented nested CLAUDE.md), claude-md (counted a 3rd CLAUDE.md), command (leftover scratch snapshot), and settings (unexpanded `{{WORKSPACE_ROOT}}` template var). Four findings, one root cause — visible only cross-auditor. Because it is gitignored, repo integrity is intact, but it recurs as noise every audit cycle.
  *Location:* `output/deploy-test-scratch-2026-06-12/`
  *Recommendation:* One-time cleanup — delete (or relocate to a scratchpad) `output/deploy-test-scratch-2026-06-12/`. Single action clears 4 recurring Minor findings. If it must be retained as a deploy-test reference, add a one-line README noting its purpose so future auditors classify it as intentional.

- **[File Organization] Undocumented nested CLAUDE.md in gitignored test-scratch directory**
  A CLAUDE.md exists at `output/deploy-test-scratch-2026-06-12/CLAUDE.md` — a `{{PROJECT_TITLE}}` template placeholder produced as a deploy-workflow test artifact. Intent check: the nearest ancestor (TARGET root `CLAUDE.md`) contains none of the intent markers and does not name the directory, so it is flagged per the check. Mitigating: the entire `output/` tree is gitignored, so this is untracked scratch, not tracked repo structure.
  *Location:* `output/deploy-test-scratch-2026-06-12/CLAUDE.md`
  *Recommendation:* Low materiality — resolved by the same scratch-dir deletion above. No tracked-repo impact.

- **[Skill Inventory] 9 skills are not referenced by any command, agent, CLAUDE.md, or sibling skill**
  No functional reference found for: `claude-code-workflow-builder`, `formatting-qc`, `fund-triage-scanner`, `journal-thinking-clarifier`, `journal-wiki-improver`, `knowledge-file-completeness-qc`, `prose-refinement-writer`, `workflow-consultant`, `workspace-template-extractor`. Their only external mention is `projects/axcion-website/pipeline/repo-snapshot.md` (an inventory dump, not a consumer). Likely intentional — several are workflow-embedded skills whose driving commands or Chat-based processes live outside `ai-resources/.claude/commands/`.
  *Location:* `skills/{9 skills listed}/`
  *Recommendation:* Confirm each is reachable via its intended workflow/command. If a driving command was never deployed, either deploy it or retire the skill.

- **[Skill Inventory] 7 skills exceed 300 body lines (none exceed 500)**
  Body lines: answer-spec-generator (477), research-plan-creator (477), ai-resource-builder (432), ai-prose-decontamination (394), evidence-to-report-writer (374), cluster-memo-refiner (351), handoff (325). None cross the 500-line restructure threshold; average across all 80 skills is 203 lines.
  *Location:* `skills/answer-spec-generator/SKILL.md and 6 others`
  *Recommendation:* Optionally move stable detail (templates, examples, long tables) into `references/` files to keep the always-loaded body lean. Advisory only.

- **[Skill Inventory] 11 descriptions lack a canonical trigger or exclusion clause**
  8 descriptions lack an explicit "use when" trigger phrase (architecture-qc, formatting-qc, grill-me, knowledge-file-completeness-qc, report-compliance-qc, research-prompt-qc, session-usage-analyzer, workflow-system-critic) — most use "Use after…" or "Invoked by /command", so the trigger is present in spirit but not canonical form. 3 lack a "do NOT use for" exclusion clause (workflow-creator, workflow-documenter, workspace-template-extractor).
  *Location:* `skills/architecture-qc/SKILL.md and others`
  *Recommendation:* For model-routed skills, add explicit "Use when… / Do NOT use for…" phrasing to sharpen routing. Pipeline/subagent-only skills can be left as-is. No functional impact.

- **[Skill Inventory] jargon-gloss uses a non-canonical model/effort pairing (opus/medium)**
  All 80 skills carry valid `model:`/`effort:` values; 79 use a canonical pairing (opus/high, sonnet/medium, or haiku/low). `jargon-gloss` is opus/medium, outside the canonical set. The skill is a single-pass gloss rewrite with domain judgment, so it plausibly wants opus — but effort should resolve to high (if judgment-led) or the pairing should move to sonnet/medium.
  *Location:* `skills/jargon-gloss/SKILL.md`
  *Recommendation:* Reconcile to a canonical pairing: opus/high if the jargon judgment is load-bearing, or sonnet/medium if it is bounded structured execution.

- **[Commands & Subagents] Leftover deploy-test-scratch snapshot under output/**
  `output/deploy-test-scratch-2026-06-12/.claude/` holds a full real-file copy of the research-workflow template (31 commands + 4 agents), all non-symlink and gitignored. Its 11 basename overlaps with the canonical `.claude/commands/` are a frozen test snapshot, not maintenance drift (excluded from scope/collision metrics for that reason).
  *Location:* `output/deploy-test-scratch-2026-06-12/`
  *Recommendation:* Delete the dated deploy-test-scratch directory when convenient (same action as the cross-cutting cleanup above). No integrity impact — gitignored, not deployed, no dead links.

- **[Settings & Permissions] Four Bash allow entries subsumed by Bash(*) in parent settings.json**
  `.claude/settings.local.json` allows 4 specific Bash patterns (mkdir/ls/bash -n/cp) that are fully covered by `Bash(*)` in the sibling `settings.json` AND moot under `defaultMode: bypassPermissions`. All referenced paths exist — not stale, just redundant permission-prompt residue.
  *Location:* `.claude/settings.local.json`
  *Recommendation:* Clear the redundant allow list (or delete the file); no functional loss.

- **[Settings & Permissions] Unexpanded template placeholder `{{WORKSPACE_ROOT}}` in scratch settings**
  `output/deploy-test-scratch-2026-06-12/.claude/settings.json` has the literal token `{{WORKSPACE_ROOT}}` in `permissions.additionalDirectories`, a deploy-time placeholder never substituted, resolving to no real directory. The path is a gitignored disposable scratch dir; the clean source template (`workflows/research-workflow/.claude/settings.json`) has no `additionalDirectories` key and is unaffected.
  *Location:* `output/deploy-test-scratch-2026-06-12/.claude/settings.json`
  *Recommendation:* Delete the stale scratch directory rather than patch the placeholder (same action as the cross-cutting cleanup).

- **[Settings & Permissions] `Read(archive/**)` deny has no matching directory inside ai-resources scope**
  The deny entry anchors to the ai-resources root, where no `archive/` directory exists (an `archive/` exists at the workspace root, so not declared stale — but within an ai-resources session the pattern matches nothing). Benign: `defaultMode: bypassPermissions` makes the deny list non-operative. Sibling denies `Read(inbox/archive/**)` and `Read(logs/*archive*.md)` are fine.
  *Location:* `.claude/settings.json`
  *Recommendation:* No action required; note only. If tidying, confirm whether an ai-resources-local `archive/` was ever intended and drop the entry if not.

- **[2026 Best Practices] workflow-analysis-agent on opus leans structural (advisory, low-confidence)**
  Of 40 canonical agents the tiering is otherwise textbook (haiku=mechanical, sonnet=structural/dispatch/scan, opus=judgment/synthesis). The one borderline case is `workflow-analysis-agent` (opus), whose job — "inventories and traces a workflow's deployed infrastructure" — is more structural than synthetic. Counter-argument: end-to-end relationship tracing carries real judgment and it feeds the opus workflow-critique-agent, so a shared tier is defensible.
  *Location:* `.claude/agents/workflow-analysis-agent.md`
  *Recommendation:* Optional — if a future token audit shows this agent's reasoning is shallow relative to cost, consider sonnet. Low marginal value; defensible as-is.

- **[Context Health] Recent high-impact change: /scope-project pipeline batch — cross-refs internally consistent**
  Commit `c47f55e` landed `scope-project.md`, three `scope-*` agents, and `skills/project-scoping/SKILL.md` as one batch. Downstream trace: the command references all three agents (all present); agents, skill, `docs/agent-tier-table.md`, and `docs/control-pack-schema.md` mutually cross-reference. Every reference resolves — no dangling link introduced.
  *Location:* `.claude/commands/scope-project.md; .claude/agents/scope-*.md; skills/project-scoping/SKILL.md`
  *Recommendation:* Informational — spot-check the scope-project agent-tier assignments against `docs/agent-tier-table.md` if that command is edited again.

- **[Context Health] Recent high-impact change: auto-sync-shared.sh hook edited — consumed by research-workflow SessionStart**
  `.claude/hooks/auto-sync-shared.sh` was modified in commit `c47f55e`. It is invoked by `workflows/research-workflow/.claude/settings.json` SessionStart via a parent-directory-traversal guard. Verified: the script exists and carries the executable bit, so the guarded call still fires.
  *Location:* `.claude/hooks/auto-sync-shared.sh`
  *Recommendation:* Informational — no action; the executable bit and path are intact.

- **[Context Health] Documented-deferred pipeline sub-agent: counter-search-runner referenced but intentionally not built**
  `workflows/research-workflow/reference/stage-instructions.md` (Pass 3) and run-sufficiency reference a `counter-search-runner` sub-agent with no skill/agent on disk. This is NOT a broken link: stage-instructions.md explicitly labels it a "Deferred Pass 3 phase (later bundle)" with documented graceful degradation. Surfaced only so a future auditor does not re-flag it.
  *Location:* `workflows/research-workflow/reference/stage-instructions.md:100`
  *Recommendation:* Informational — leave as-is until the source-pipeline later bundle builds it; the deferral is disclosed at the reference site.

- **[Context Health] Most recent commits touched audit/log files only — no live cross-referenced artifact changed**
  The last three commits modified only `audits/` and `logs/` files (claude-md audit report, friction-log, risk-check record). None altered a live CLAUDE.md, SKILL.md, settings.json, agent, or command, so no downstream trace is required. The only high-impact structural change in the last 10 commits is the `c47f55e` scope-project batch (traced above).
  *Location:* `audits/`, `logs/`
  *Recommendation:* Informational — no downstream artifacts depend on these audit/log files.

## Detailed Analysis

### File Organization
Healthy structure: `.claude/` (with `commands/` + `settings.json`), `skills/`, and a root `CLAUDE.md` all present. All 81 symlinks resolve to existing readable targets (0 broken). All 80 skill directories are kebab-case and contain a `SKILL.md` (no orphans by folder structure). Both nested `.claude/` directories contain `commands/` + `settings.json`. Of 3 CLAUDE.md files, the root and `workflows/research-workflow/CLAUDE.md` (an intentional workflow-template fragment) are expected; the only flag is one undocumented nested CLAUDE.md inside the gitignored deploy-test-scratch dir.
*Metrics:* 80 skill dirs · 81 symlinks (0 broken) · 3 CLAUDE.md files.

### CLAUDE.md Health
Zero findings. All 3 CLAUDE.md files sit well under size thresholds (77 / 155 / 155 lines; ~1,097 / ~2,148 / ~2,148 tokens). None use `@import`/`@file` include syntax — they rely on prose load-on-demand "See X" pointers, all of which resolve on disk. No secrets detected. Each has a top-level heading plus an orientation section. No cross-level contradictions. (The two nested files are byte-identical because the deploy-test-scratch copy is a template snapshot of the research-workflow template — expected.)
*Metrics:* 3 files · largest 155 lines / ~2,148 tokens · 0 @imports · 0 dead imports · 0 secrets.

### Skill Inventory
80 skills, all structurally sound: every SKILL.md is present with a non-empty `name` and `description` and a valid `model:`/`effort:` pairing (0 missing tier frontmatter), and every internal `references/`/`scripts/` path resolves on disk (zero dead internal references; `ai-resource-builder`'s illustrative paths correctly treated as meta-skill documentation). Highest trigger-overlap pair reaches only Jaccard 0.41, far below the 0.60 ambiguous-routing threshold. Five Minor items: 7 oversized bodies (300–500 lines), 9 skills orphaned within repo scope, 11 descriptions missing a canonical trigger/exclusion clause, and 1 non-canonical tier pairing (jargon-gloss opus/medium).
*Metrics:* 80 skills · avg 203.1 body lines · 7 over 300 · 0 over 500 · 9 orphaned · 0 missing tier frontmatter · top overlap Jaccard 0.41.

### Commands & Subagents
GREEN. Every command symlink resolves (4 workflow command symlinks point into the canonical `.claude/commands/`, intentional shared-sync; 0 agent symlinks; 0 broken links). All 44 agents (command-auditor slice) have complete frontmatter (name/description/tools/model), names match filenames. All 13 live skill references and all command→agent references resolve. 84/84 canonical commands declare a `model:` tier (100%). The 7 research-workflow command basename collisions are byte-divergent intentional overrides (`name_collisions_drift = 0`). One Minor (leftover scratch snapshot); three informational notes (library-wide convention of frontmatter + opening sentence rather than a literal `Usage:` line; two template-placeholder skill references that are not real; auditor/agent cross-references all resolving) recorded so future audits don't re-flag them.
*Metrics:* 84 canonical commands (ai-resources 84 · workflow 31) · 44 agents · 4 command symlinks · 0 agent symlinks · 0 dead references · name_collisions_total 7 · drift 0 · intentional_overrides 7.

### Settings & Permissions
All 4 settings files are valid JSON with well-formed `permissions` objects and intact hook wiring — every referenced hook script exists and all hook types are valid, with no hardcoded absolute paths (all use `$CLAUDE_PROJECT_DIR` or relative walk-ups). `defaultMode: bypassPermissions` in all files (the operator's documented setup) renders allow/deny lists advisory. Three Minor cleanup-only items: redundant Bash allow entries in `settings.local.json`, an unexpanded `{{WORKSPACE_ROOT}}` placeholder in the disposable scratch settings, and a `Read(archive/**)` deny matching nothing inside ai-resources.
*Metrics:* 4 settings files · all valid JSON · main settings.json: 17 allow / 8 deny / 10 hooks · all hook scripts resolve.

### 2026 Best Practices
GREEN — meets or exceeds 2026 best practice on every cross-cutting axis. **Positive practices confirmed:** context-isolated subagent QC with conversation history explicitly withheld (qc-reviewer, refinement-reviewer, triage-reviewer, risk-check-reviewer, scope-qc-evaluator, expert-check-reviewer, plus the 8 auditor agents bundled in this skill); zero git status/diff used for self-verification (filesystem-first rule actively re-taught in-code); deliberate 3-tier model assignment matching the documented agent-tier-table; 18 mechanical advisory hooks (nudge, not enforce); lean load-on-demand CLAUDE.md cores (more token-efficient than @import for this workspace's shape). Two Minor items: the compound scratch-dir root cause (BP-1) and one soft model-tier edge (workflow-analysis-agent, BP-2).
*Maturity signals:* command:skill ratio ~1.05 with high agent adoption · full context-isolated QC stack · rich session rituals (/prime, /session-start, /session-plan, /wrap-session, /handoff, /mission) · error-driven evolution (23 files with provenance markers tying rules to past incidents) · audit system itself packaged as a shareable skill.

### Context Health
Cross-reference integrity is intact across CLAUDE.md, skills, commands, agents, hooks, and the research-workflow pipeline. Every CLAUDE.md skill pointer (9) resolves with no purpose-vs-description contradictions; all 30 distinct pipeline skill references and all workflow-command skill/agent references (32) resolve on disk; every hook script referenced in the four settings files exists AND carries the executable bit (14 checked, 0 missing, 0 non-executable — the auditor's value-add over Wave 1). The only non-resolving skill-shaped token (`counter-search-runner`) is explicitly documented as a deferred later-bundle sub-agent with graceful degradation, not a broken link. All findings Minor/informational; the sole structural change in the last 10 commits is the `c47f55e` /scope-project batch, whose cross-references were verified mutually consistent.
*Metrics:* 9 skill refs checked (0 dead) · 32 command refs checked (0 dead) · 30 pipeline steps checked (0 mismatches) · 14 hook scripts checked (0 missing) · 6 recent high-impact changes.

## Prioritized Recommendations

1. **Delete `output/deploy-test-scratch-2026-06-12/`** — one action clears 4 recurring Minor findings (file-org nested CLAUDE.md, command scratch snapshot, settings `{{WORKSPACE_ROOT}}` placeholder, and one of the 3 counted CLAUDE.md files). Gitignored throwaway with no tracked-repo impact. Effort: Low. Area: cross-cutting (File Org / Commands / Settings / Best Practices).
2. **Clear the redundant Bash allow list in `.claude/settings.local.json`** — 4 entries fully subsumed by `Bash(*)` and moot under bypassPermissions; safe to clear or delete the file. Effort: Low. Area: Settings & Permissions.
3. **Confirm the 9 orphaned skills are reachable via their intended workflows/commands** — retire any whose driving command was never deployed, or deploy the missing command. Effort: Medium. Area: Skill Inventory.
4. **Reconcile `jargon-gloss` to a canonical model/effort pairing** — opus/high if the jargon judgment is load-bearing, else sonnet/medium. Effort: Low. Area: Skill Inventory.
5. **Optional routing/leanness polish** — normalize the 11 skill descriptions to canonical "Use when… / Do NOT use for…" phrasing, and optionally externalize detail from the 7 skills over 300 body lines. Advisory, no functional impact. Effort: Medium. Area: Skill Inventory.

---

*Generated by repo-health-analyzer v2 (sequential mode). Auditors: 7 run, 0 skipped. Auditors ran as isolated subagents (dispatched as `general-purpose` subagents with each auditor's instructions passed as content, since the named auditor agent types are not registered in this runtime); Wave 1 sequential, Wave 2 parallel.*
