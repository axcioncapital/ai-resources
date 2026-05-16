# Workspace Health Report

**Date:** 2026-05-16
**Mode:** Full Audit
**Overall:** YELLOW

---

## Executive Summary

The ai-resources repository is in good health with no Critical or Important findings across any of the seven audit areas. The two YELLOW areas (Skill Inventory and Settings & Permissions) contain only Minor findings: 8 skills missing trigger-condition language in their descriptions, 2 orphaned skills with no external references, hardcoded absolute paths in two settings files, and redundant permission entries duplicated between parent and child settings. Cross-reference integrity is clean — all 70 skills exist, all 25 pipeline-referenced skills resolve, all 15 hook scripts are present and executable, and no dead agent or command references were found.

## Scores

| Area | Score | Critical | Important | Minor |
|------|-------|----------|-----------|-------|
| File Organization | GREEN | 0 | 0 | 0 |
| CLAUDE.md Health | GREEN | 0 | 0 | 0 |
| Skill Inventory | YELLOW | 0 | 0 | 4 |
| Commands & Subagents | GREEN | 0 | 0 | 1 |
| Settings & Permissions | YELLOW | 0 | 0 | 3 |
| 2026 Best Practices | GREEN | 0 | 0 | 2 |
| Context Health | GREEN | 0 | 0 | 3 |

## Findings

### Critical (Fix Now)

No critical findings.

### Important (Fix Soon)

No important findings.

### Improvement Opportunities

**Skill Inventory**

1. **8 skills missing trigger conditions in description** — architecture-qc, decision-to-prose-writer, formatting-qc, knowledge-file-completeness-qc, report-compliance-qc, research-prompt-qc, session-usage-analyzer, workflow-system-critic have no "use when" / "trigger when" language in their description fields. May affect routing reliability.

2. **6 skills missing exclusion conditions in description** — analysis-pass-memo-review, editorial-recommendations-generator, workflow-consultant, workflow-creator, workflow-documenter, workspace-template-extractor have no "do not use for" / "never" language. Routing agents cannot determine what these skills are not for.

3. **7 skills over 300 lines (none over 500)** — answer-spec-generator (487 lines), research-plan-creator (466), ai-resource-builder (415), evidence-to-report-writer (334), workflow-evaluator (318), ai-prose-decontamination (316), workflow-system-critic (302). Several already offload content to references/ directories.

4. **2 orphaned skills** — fund-triage-scanner and prose-refinement-writer are not referenced in any command, agent, CLAUDE.md file, or other skill file outside their own directories.

**Commands & Subagents**

5. **53 of 56 ai-resources commands lack a Usage: line** — The workspace convention uses YAML frontmatter (model:, effort:) instead of a Usage: line. Only deploy-workflow.md, sync-workflow.md, and project-consultant.md have Usage: lines. Consistent across the library but not documented as an intentional choice.

**Settings & Permissions**

6. **Hardcoded absolute paths in two settings files** — `.claude/settings.json` lines 20–21 contain `Edit(/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/**)` and `Write(/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/**)`. `workflows/research-workflow/.claude/settings.json` line 35 contains `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo` in additionalDirectories. Will break if workspace moves.

7. **Empty settings.local.json** — `.claude/settings.local.json` contains only `{}`. No permissions, hooks, or env vars defined.

8. **17 redundant allow + 7 redundant deny entries between ai-resources and workflow settings** — Large overlap between `.claude/settings.json` and `workflows/research-workflow/.claude/settings.json` permission lists. Changes to root permissions will not auto-propagate to the workflow settings.

**2026 Best Practices**

9. **Command convention (frontmatter vs. Usage: line) is undocumented** — The workspace consistently uses frontmatter instead of Usage: lines, but this design choice is not documented in CLAUDE.md or any commands README.

10. **2 orphaned skills (cross-reference of finding #4)** — fund-triage-scanner and prose-refinement-writer appear unused across the full workspace.

**Context Health**

11. **intake-processor SKILL.md updated — downstream reference may be stale** — Commit 06987e9 updated intake-processor to v2 (new entry contract fields and body sections). Referenced by `.claude/commands/project-consultant.md`. Worth a spot-check to verify the command's description of the skill still applies.

12. **prime.md updated twice — downstream callers may describe pre-Step-0 behavior** — prime.md received two commits adding Step 0 (git pull + unpushed commits display). Referenced by session-plan.md, save-session.md, session-start.md, repo-dd.md. Their descriptions of /prime may be stale.

13. **wrap-session.md updated in both scopes** — Commit 716c29c updated both `.claude/commands/wrap-session.md` and `workflows/research-workflow/.claude/commands/wrap-session.md`. The two are intentional divergent overrides. The stage-boundary verification note added should be verified for coherence in each scope context.

---

## Detailed Analysis

### File Organization

No findings. The ai-resources repository structure is clean: all 70 skill directories contain SKILL.md files, all skill folder names are valid lowercase kebab-case, both symlinks (`workflows/research-workflow/.claude/commands/session-plan.md` and `consult.md`) resolve to readable targets in `.claude/commands/`. Both CLAUDE.md files are in expected locations. No orphaned skill directories.

**Metrics:** 70 skill directories, 2 symlinks (0 broken), 2 CLAUDE.md files.

### CLAUDE.md Health

No findings. Both CLAUDE.md files are well within size limits — `CLAUDE.md` is 90 lines (~1,207 estimated tokens) and `workflows/research-workflow/CLAUDE.md` is 128 lines (~1,520 estimated tokens). Neither approaches the 200-line/4,000-token Important threshold. No @imports are used, which is appropriate given the file sizes. Both files have clear orientation sections, multiple headings, no dead references, and no hardcoded secrets. No direct contradictions found between the two files.

**Metrics:** 2 CLAUDE.md files; 0 dead imports; 0 secrets found; 0 contradictions.

### Skill Inventory

4 Minor findings. All 70 skills have SKILL.md files, valid kebab-case names, and complete `model:` and `effort:` frontmatter. No skills exceed the 500-line Important threshold. Seven skills exceed the 300-line Minor threshold. Jaccard trigger-overlap analysis shows no pairs exceed the 60% Important threshold (highest: execution-manifest-creator vs research-prompt-creator at 40.5%). Two orphaned skills (fund-triage-scanner, prose-refinement-writer) have no external references. Internal reference checks found all `references/`, `scripts/`, and `assets/` paths cited operationally in SKILL.md files exist on disk.

**Metrics:** 70 total skills; average 205 lines/skill; 7 over 300 lines; 0 over 500 lines; 2 orphaned; 0 missing tier frontmatter.

### Commands & Subagents

1 Minor finding. 56 commands in `.claude/commands/` and 28 in `workflows/research-workflow/.claude/commands/` (84 total). 27 agents in `.claude/agents/` and 4 in `workflows/research-workflow/.claude/agents/` (31 total). Both command symlinks resolve correctly. All agent frontmatter is complete (name, description, tools, model). No dead skill or agent references in commands — two apparent dead agent references in friday-checkup.md are self-guarded skip checks; one (strategic-critic) is inside a fenced template example block. 9 command name collisions between scopes are all intentional divergent overrides (0 drift).

**Metrics:** 84 total commands; 31 total agents; 2 command symlinks; 0 agent symlinks; 0 dead references; 0 drift collisions; 9 intentional overrides.

### Settings & Permissions

3 Minor findings. All 3 settings files are valid JSON with `permissions` structures. All hook scripts referenced in both settings files exist on disk and are executable. Hook types are valid (PreToolUse, PostToolUse, Stop, SessionStart, UserPromptSubmit). No stale path-based permission entries. Minor findings: hardcoded absolute paths in permission entries and additionalDirectories (fragile if workspace moves), empty settings.local.json (harmless artifact), and 24 redundant allow/deny entries duplicated between parent and child settings.

**Metrics:** 3 settings files; all valid JSON; 9 hooks in ai-resources settings; 11 hooks in workflow settings; 0 missing hook scripts.

### 2026 Best Practices

2 Minor findings. Subagent isolation is consistently implemented — QC and evaluation tasks spawn subagents with fresh context. Context isolation is compliant — commands pass content to subagents rather than file paths. Filesystem-first verification is enforced in CLAUDE.md and command files. Model tiering is appropriate: opus for judgment agents, sonnet for structured execution, haiku for mechanical tasks. No git status/diff used for output verification. Command-to-skill ratio (84 commands : 70 skills) is mature. 14 hook scripts enforce mechanical checks. Session ritual automation is comprehensive.

**Maturity signals found:** Hook-enforced mechanical checks; QC commands use subagent isolation; context isolation enforced in audit commands; git push denial in all settings; appropriate model tiering across 31 agents; 9 intentional workflow command overrides (not drift); error-driven CLAUDE.md rules; session telemetry and wrap-session hooks; Friday cadence automation.

### Context Health

3 Minor findings. All CLAUDE.md skill references are valid (`skills/ai-resource-builder/SKILL.md` and `workflow-evaluator` both exist). All 25 skills referenced in pipeline files (stage-instructions.md and run-*.md commands) exist on disk. All 15 hook scripts referenced in settings files exist and are executable. Three Minor informational findings from the recent-change risk scan: intake-processor SKILL.md updated to v2 (one downstream reference worth a spot-check), prime.md updated twice with a new Step 0 (referenced by ~4 commands that may describe stale behavior), wrap-session.md updated in both scopes.

**Metrics:** 3 CLAUDE.md skill references (0 dead, 0 mismatches); 44 command references (0 dead); 36 pipeline steps (0 mismatches); 15 hook scripts (0 missing); 5 recent high-impact changes.

---

## Prioritized Recommendations

1. **Add trigger and exclusion language to 14 skill descriptions** — 8 skills lack trigger conditions; 6 lack exclusion conditions. Affects routing reliability. Address during next skill improvement pass. Skills: architecture-qc, decision-to-prose-writer, formatting-qc, knowledge-file-completeness-qc, report-compliance-qc, research-prompt-qc, session-usage-analyzer, workflow-system-critic (triggers); analysis-pass-memo-review, editorial-recommendations-generator, workflow-consultant, workflow-creator, workflow-documenter, workspace-template-extractor (exclusions).

2. **Review 2 orphaned skills for archival or activation** — fund-triage-scanner and prose-refinement-writer have no references anywhere in the workspace. Confirm whether still needed; archive to reduce library noise if not.

3. **Replace hardcoded absolute paths in settings files** — `.claude/settings.json` Edit/Write permission entries and `workflows/research-workflow/.claude/settings.json` additionalDirectories contain `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo`. Document as fixed or replace before any workspace migration.

4. **Spot-check prime.md downstream callers for stale descriptions** — prime.md has a new Step 0 (git pull + unpushed commits). session-plan.md, save-session.md, session-start.md, and repo-dd.md may reference pre-Step-0 behavior.

5. **Document the frontmatter-over-Usage: command convention** — The workspace consistently uses YAML frontmatter instead of Usage: lines in commands. A note in CLAUDE.md or a commands README would make the convention explicit.

---
*Generated by repo-health-analyzer v2 (sequential mode). Auditors: 7 run, 0 skipped.*
