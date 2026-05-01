# Workspace Health Report

**Date:** 2026-05-01
**Mode:** Full Audit
**Overall:** YELLOW

---

## Executive Summary

The ai-resources repo is in good structural health overall — file organization, CLAUDE.md size, command/agent integrity, and 2026 best-practices compliance all score GREEN. Two YELLOW areas hold the overall score back: (1) the Skill Inventory has one skill (`research-extract-verifier`) missing required `model:` and `effort:` frontmatter; (2) Settings & Permissions has an unresolved `{{WORKSPACE_ROOT}}` template placeholder in `workflows/research-workflow/.claude/settings.json` under `additionalDirectories`. Top action: add the tier frontmatter to `research-extract-verifier` and resolve or remove the workflow settings placeholder.

> **Caveat — context isolation not preserved.** This audit was executed as a single Claude session because the orchestration environment did not expose an Agent/Task tool to spawn isolated subagents. Per workspace QC Independence Rule, audit subagents are normally run with fresh context; here, all seven auditor "passes" ran in the same context. Findings are factual and verifiable from the cited paths, but the cross-auditor independence the spec calls for was not achieved. Treat this report as a credible factual snapshot rather than an independence-verified audit.

## Scores

| Area | Score | Critical | Important | Minor |
|------|-------|----------|-----------|-------|
| File Organization | GREEN | 0 | 0 | 0 |
| CLAUDE.md Health | GREEN | 0 | 0 | 0 |
| Skill Inventory | YELLOW | 0 | 2 | 6 |
| Commands & Subagents | GREEN | 0 | 0 | 0 |
| Settings & Permissions | YELLOW | 0 | 1 | 1 |
| 2026 Best Practices | GREEN | 0 | 0 | 1 |
| Context Health | GREEN | 0 | 0 | 2 |

## Findings

### Critical (Fix Now)

No critical findings.

### Important (Fix Soon)

- **[Skill Inventory] research-extract-verifier missing model and effort frontmatter**
  SKILL.md frontmatter does not declare `model:` or `effort:`. Per workspace rule, every skill must declare its tier explicitly so the harness can apply skill-level model allocation. The skill currently inherits the session model.
  *Location:* `skills/research-extract-verifier/SKILL.md`
  *Recommendation:* Add `model: sonnet` and `effort: medium` (or correct tier) to the SKILL.md frontmatter.

- **[Skill Inventory] answer-spec-generator approaching 500-line size threshold (476 body lines)**
  SKILL.md body is 476 lines, just under the 500-line Important threshold. Recommend reviewing for splittable content (e.g., move illustrative examples to a `references/` subdirectory).
  *Location:* `skills/answer-spec-generator/SKILL.md`
  *Recommendation:* Split or move portions to a references/ subdirectory.

- **[Settings & Permissions] Workflow settings.json contains unresolved template placeholder {{WORKSPACE_ROOT}}**
  `workflows/research-workflow/.claude/settings.json` has `additionalDirectories: ["{{WORKSPACE_ROOT}}"]`. Claude Code will not resolve `{{WORKSPACE_ROOT}}` as a real path; the entry is effectively dead.
  *Location:* `workflows/research-workflow/.claude/settings.json`
  *Recommendation:* Either remove the `additionalDirectories` entry (research-workflow lives inside ai-resources/, so it inherits ai-resources via Claude Code's default search) or substitute the placeholder with the real workspace root path. If this file is meant to be a template that gets copied during `/deploy-workflow`, document that explicitly and exclude it from settings audits.

### Improvement Opportunities

- **[Skill Inventory] ai-resource-builder over 300 lines (403 body lines)**
  Meta-skill that teaches skill structure; some length is intrinsic. Still consider whether reference splits would help.
  *Location:* `skills/ai-resource-builder/SKILL.md`
  *Recommendation:* Review for splittable content.

- **[Skill Inventory] evidence-to-report-writer over 300 lines (314 body lines)**
  Just over the threshold.
  *Location:* `skills/evidence-to-report-writer/SKILL.md`
  *Recommendation:* Review for splittable content; not urgent.

- **[Skill Inventory] research-plan-creator over 300 lines (452 body lines)**
  Body is 452 lines.
  *Location:* `skills/research-plan-creator/SKILL.md`
  *Recommendation:* Review for splittable content.

- **[Skill Inventory] 11 skills missing trigger phrases in description**
  Skills lacking 'use when', 'trigger', 'when you', 'when to', 'run when', or 'invoke when' phrasing in description. Affected: `architecture-qc`, `formatting-qc`, `knowledge-file-completeness-qc`, `report-compliance-qc`, `research-extract-verifier`, `research-prompt-qc`, `session-usage-analyzer`, `supplementary-evidence-merger`, `supplementary-query-brief-drafter`, `supplementary-research-qc`, `workflow-system-critic`.
  *Location:* `skills/*/SKILL.md (multiple)`
  *Recommendation:* Add explicit trigger phrasing to each description for routing reliability.

- **[Skill Inventory] 7 skills missing exclusion phrases in description**
  Skills lacking 'do not', 'never', 'not for', 'avoid', 'excludes' phrasing. Affected: `research-extract-verifier`, `supplementary-evidence-merger`, `supplementary-query-brief-drafter`, `workflow-consultant`, `workflow-creator`, `workflow-documenter`, `workspace-template-extractor`.
  *Location:* `skills/*/SKILL.md (multiple)`
  *Recommendation:* Add explicit exclusion clauses (when NOT to invoke) to each description.

- **[Skill Inventory] 2 orphaned skills (no references outside their own directory)**
  `fund-triage-scanner` and `prose-refinement-writer` are not referenced by any command, agent, CLAUDE.md, or other skill. May be intentional (kept for future use) but flagged for review.
  *Location:* `skills/fund-triage-scanner/`, `skills/prose-refinement-writer/`
  *Recommendation:* Confirm these skills are still needed or move to a `deprecated/` archive subdirectory.

- **[Settings & Permissions] Stale path pattern in root settings deny list (Read(archive/**))**
  The deny pattern `Read(archive/**)` targets a top-level `archive/` directory which does not currently exist in ai-resources/. Other archive-related deny patterns reference real paths.
  *Location:* `.claude/settings.json (deny list)`
  *Recommendation:* Either remove the entry or document it as a defensive guard for a future archive/ directory.

- **[2026 Best Practices] Repo-level CLAUDE.md does not use @import pattern**
  `CLAUDE.md` is 92 lines (well within budget) and does not use @import directives. Acceptable at current size; if growth continues, the @import pattern would keep the always-loaded core lean. The workflow CLAUDE.md already demonstrates the pattern well (4 @reference imports, all resolving correctly).
  *Location:* `CLAUDE.md`
  *Recommendation:* Continue keeping the core file under 200 lines; defer @import adoption until growth requires it.

- **[Context Health] Recent high-impact changes — friday-checkup and command renaming**
  Last 10 commits modified `.claude/commands/friday-checkup.md` (3 commits), `.claude/commands/friday-act.md`, and renamed `resolve-improvements` -> `resolve-improvement-log`. `session-plan.md` is new (commit ac4d2da). All active references to the renamed command have been updated; remaining `resolve-improvements` mentions live only in dated audit/risk-check archive files (point-in-time records).
  *Location:* `git log --oneline -10`
  *Recommendation:* Spot-check confirmed clean. Confirm `/session-plan` integration into `/prime` is fully wired (commit ac4d2da modified `.claude/commands/prime.md`, suggesting yes).

- **[Context Health] session-plan.md untracked symlink in workflow scope**
  Pre-session git status shows `workflows/research-workflow/.claude/commands/session-plan.md` as untracked (??). This is a symlink to the ai-resources source. The workflow-side symlink may be auto-created by `auto-sync-shared.sh` on SessionStart but is not yet committed.
  *Location:* `workflows/research-workflow/.claude/commands/session-plan.md`
  *Recommendation:* Either commit the symlink alongside the next workflow change, or confirm `auto-sync-shared.sh` recreates it deterministically and document that in the workflow CLAUDE.md.

## Detailed Analysis

### File Organization
File organization is healthy. Expected directories all present (`.claude/`, `skills/`, `workflows/`, `CLAUDE.md`). 69 skill directories, all kebab-case, all containing `SKILL.md`. Single symlink (`workflows/research-workflow/.claude/commands/session-plan.md`) resolves to a real file in `ai-resources/.claude/commands/`.

Key metrics: 69 skill dirs, 1 symlink (0 broken), 2 CLAUDE.md files.

### CLAUDE.md Health
Both CLAUDE.md files are well within size thresholds. The repo-level CLAUDE.md (92 lines) is concise and orientation-focused. The workflow CLAUDE.md (128 lines) uses `@reference/` imports for `stage-instructions.md`, `file-conventions.md`, `quality-standards.md`, and `style-guide.md` — all four import targets exist on disk. No secrets detected; both files have orientation sections. No contradictions surfaced between the two layers.

Per-file: `CLAUDE.md` 92 lines (~1,267 tokens, 0 imports). `workflows/research-workflow/CLAUDE.md` 128 lines (~1,520 tokens, 4 imports, 0 dead).

### Skill Inventory
Skill inventory is large (69 skills) and well-organized — all kebab-case, all have SKILL.md, no overlap pairs above the 60% Jaccard threshold (highest pair: `execution-manifest-creator` vs `research-prompt-creator` at 0.41). Three skills exceed 300 body lines but stay under 500. One Important finding: `research-extract-verifier` missing model/effort frontmatter. Two orphaned skills and modest description-quality drift (missing trigger or exclusion phrases) account for the rest of the minor findings.

Key metrics: 69 skills total, 4 over 300 lines (0 over 500), 2 orphaned, 1 missing tier frontmatter.

### Commands & Subagents
Commands and agents are healthy. 43 commands in `ai-resources/.claude/commands/`, 28 in `workflows/research-workflow/.claude/commands/`. 24 root agents and 4 workflow agents, all with complete frontmatter (name, description, tools, model). The single command symlink (`session-plan.md`) resolves correctly. Of 10 same-name commands across scopes, one (`session-plan`) is an intentional symlink and 9 differ in content — workflow-specific overrides per the auditor's intentional-override classification, not drift. Two apparent dead skill references investigated and confirmed false positives: `skills/overview` is part of an Anthropic docs URL (`https://platform.claude.com/.../agent-skills/overview`); `skills/old-skill-name` is illustrative example content inside a fenced markdown table in `sync-workflow.md`.

Key metrics: 71 commands total (43 ai-resources + 28 workflows), 28 agents, 1 command symlink, 0 dead refs, 0 drift collisions, 9 intentional overrides.

### Settings & Permissions
Three settings files, all valid JSON. All 9 hooks referenced from the root `settings.json` exist on disk and are executable. The workflow `settings.json` references workflow-local hook scripts that all exist. One Important finding: workflow settings has an unresolved `{{WORKSPACE_ROOT}}` template placeholder in `additionalDirectories`. Defensive `Bash(*)` patterns are intentional given the `bypassPermissions` default mode (operator's documented preference per memory).

Per-file analysis: `.claude/settings.json` (5 allow / 8 deny / 9 hooks / 1 stale), `.claude/settings.local.json` (model declaration only), `workflows/research-workflow/.claude/settings.json` (17 allow / 7 deny / 8 hooks / 1 stale).

### 2026 Best Practices
Workspace shows high best-practices maturity. Subagent isolation is documented and enforced via CLAUDE.md rules; context isolation, filesystem-first verification, and explicit model-tier declaration are in place. Hooks are used appropriately for mechanical reminders rather than judgment calls. The only practice gap is informational: repo-level CLAUDE.md does not use @imports, but its small size (92 lines) makes this defer-able.

Maturity signals: subagent contracts documented; QC Independence Rule with mechanical-mode rubric; risk-check change classes; Friday cadence automation; structural permission management; plan-mode discipline rule; Adaptive Thinking Override; per-command/per-agent model tier declarations (42 of 43 commands declare `model:`); hook-based session telemetry; explicit compaction preservation rules.

### Context Health
Cross-reference integrity is intact. All hook script references resolve to existing executable files in both root and workflow scopes. All 4 `@reference/` imports in `workflows/research-workflow/CLAUDE.md` resolve to real files. No genuine dead skill or agent references in commands. Recent 10-commit window shows churn concentrated in friday-checkup + command renames; the `resolve-improvements` -> `resolve-improvement-log` rename is clean across active code (remaining mentions are in dated audit archive files only).

Key metrics: 60 skill references checked (0 dead), 71 commands checked (0 dead), 13 hook scripts checked (0 missing), 7 high-impact changes in recent window.

## Prioritized Recommendations

1. **Add `model: sonnet` and `effort: medium` to `skills/research-extract-verifier/SKILL.md` frontmatter.** Without these, the skill silently inherits the session model and the harness cannot apply skill-level allocation. Effort: Low. Area: Skill Inventory.
2. **Resolve `{{WORKSPACE_ROOT}}` placeholder in `workflows/research-workflow/.claude/settings.json`.** Either remove the `additionalDirectories` entry or substitute the placeholder. As-is, the entry is dead config. Effort: Low. Area: Settings & Permissions.
3. **Confirm or archive the two orphaned skills (`fund-triage-scanner`, `prose-refinement-writer`).** If no longer used, move them under a `deprecated/` subdirectory; if kept for future use, leave them and accept the orphan flag. Effort: Low (decision-only). Area: Skill Inventory.
4. **Sweep description quality across the 11 + 7 skills missing trigger or exclusion phrasing.** Consistent description style improves routing reliability. Treat as a single batch pass via `/improve-skill` or a dedicated description-cleanup session. Effort: Medium (~30 minutes for the full set). Area: Skill Inventory.
5. **Remove the stale `Read(archive/**)` deny pattern from `.claude/settings.json`** or document it inline as a defensive guard. The path does not exist and other archive-specific patterns already cover the real cases. Effort: Low. Area: Settings & Permissions.

---

*Generated by repo-health-analyzer v2 (sequential mode). Auditors: 7 run, 0 skipped.*
*Caveat: Subagent context isolation not available in this run; all auditor passes executed in main session context. See Executive Summary.*
