# Workspace Health Report

**Date:** 2026-05-16
**Mode:** Full Audit
**Target:** `ai-resources/`
**Overall:** YELLOW

---

## Executive Summary

The ai-resources repository is in good structural health with no Critical or Important findings across all seven audit areas. The single most useful improvement is adding explicit trigger and exclusion language to 14 skills whose descriptions lack it — this is a low-effort, high-impact fix that improves routing reliability across the entire 70-skill library. Secondary priorities are cleaning up two hardcoded absolute paths in settings files and reviewing two orphaned skills that no longer appear to be referenced anywhere.

---

## Scores

| Area | Score | Critical | Important | Minor |
|------|-------|----------|-----------|-------|
| File Organization | GREEN | 0 | 0 | 1 |
| CLAUDE.md Health | GREEN | 0 | 0 | 0 |
| Skill Inventory | YELLOW | 0 | 0 | 4 |
| Commands & Subagents | GREEN | 0 | 0 | 1 |
| Settings & Permissions | YELLOW | 0 | 0 | 3 |
| 2026 Best Practices | GREEN | 0 | 0 | 2 |
| Context Health | GREEN | 0 | 0 | 3 |
| **TOTAL** | **YELLOW** | **0** | **0** | **14** |

---

## Findings

### Critical (Fix Now)

None.

### Important (Fix Soon)

None.

### Improvement Opportunities (Minor)

**Skill Inventory**
1. **8 skills missing trigger conditions in description** — architecture-qc, decision-to-prose-writer, formatting-qc, knowledge-file-completeness-qc, report-compliance-qc, research-prompt-qc, session-usage-analyzer, workflow-system-critic. Routing agents may not resolve these reliably. Add `Use when:` or `Triggers on:` language.
2. **6 skills missing exclusion conditions in description** — analysis-pass-memo-review, editorial-recommendations-generator, workflow-consultant, workflow-creator, workflow-documenter, workspace-template-extractor. Add `Do NOT use for:` clauses to prevent misrouting.
3. **7 skills over 300 lines** — answer-spec-generator (487), research-plan-creator (466), ai-resource-builder (415), evidence-to-report-writer (334), workflow-evaluator (318), ai-prose-decontamination (316), workflow-system-critic (302). None exceed the 500-line Important threshold. answer-spec-generator and research-plan-creator are the priority candidates for content extraction into references/ files.
4. **2 orphaned skills** — fund-triage-scanner and prose-refinement-writer are not referenced in any commands, agents, CLAUDE.md files, or other skill files. Verify intent — archive if no longer needed.

**Settings & Permissions**
5. **Hardcoded absolute paths in permission entries** — `.claude/settings.json` contains `Edit(/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/**)` and `Write(/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/**)`. research-workflow settings.json also hardcodes the path in `additionalDirectories`. Will break if workspace moves.
6. **Empty settings.local.json** — `.claude/settings.local.json` exists but contains only `{}`. Either add intended local overrides or delete it.
7. **Redundant permission entries between root and research-workflow settings** — Most allow/deny entries in research-workflow settings are identical to root. Consider trimming duplicates to reduce maintenance surface.

**Commands & Subagents**
8. **Command convention undocumented** — 79 of 84 command files use YAML frontmatter (not a `Usage:` line). This is consistent and intentional, but not documented anywhere as the workspace standard. Document in CLAUDE.md or a commands README.

**File Organization**
9. **CATALOG.md in skills/ directory** — `skills/CATALOG.md` is a markdown file in the skills directory alongside skill folders. Minor structural anomaly; not a naming violation.

**2026 Best Practices**
10. **2 orphaned skills** (cross-reference with Skill Inventory finding #4 above).
11. **Command convention undocumented** (cross-reference with Commands finding #8 above).

**Context Health**
12. **intake-processor SKILL.md updated — spot-check project-consultant.md** — intake-processor was updated to v2 (commit 06987e9). The project-consultant command references it. Verify the command still accurately describes the skill's current behavior.
13. **prime command updated twice recently** — prime.md received Step 0 git pull additions in two commits. References to /prime in friday-checkup, session-start, and other commands may describe pre-Step-0 behavior.
14. **wrap-session updated in both scopes** — wrap-session.md was updated in both root and research-workflow scopes. Verify the stage-boundary verification note is coherent in both contexts.

---

## Detailed Analysis

### File Organization — GREEN
Repo structure is clean. All 70 skill directories use lowercase kebab-case naming. Both symlinks (workflows/research-workflow/.claude/commands/session-plan.md and consult.md) resolve to valid targets in .claude/commands/. The two CLAUDE.md files are at expected locations (repo root and workflows/research-workflow/). One non-directory artifact (CATALOG.md) exists inside skills/ — informational only.

**Metrics:** 70 skill dirs, 2 symlinks, 0 broken symlinks, 2 CLAUDE.md files.

### CLAUDE.md Health — GREEN
Both CLAUDE.md files are well within size and quality thresholds. Root CLAUDE.md is 90 lines (~1,207 tokens); research-workflow CLAUDE.md is 128 lines (~1,520 tokens). Neither uses @imports, but their small size makes this unnecessary. Both have orientation sections. No secrets patterns found. No contradictions between the two files — they cover different scopes. No dead import references.

**Metrics:** 2 files analyzed, 0 dead imports, 0 secrets patterns.

### Skill Inventory — YELLOW
70 skills total, all with valid SKILL.md, all with model:/effort: frontmatter populated. No orphaned skill directories. No dead internal file references. Seven skills exceed the 300-line Minor threshold; none exceed 500 lines. Trigger-overlap Jaccard scores across all 70×69 pairs are below the 60% Important threshold (highest pair: execution-manifest-creator ↔ research-prompt-creator at 0.41). Two skills (fund-triage-scanner, prose-refinement-writer) are not referenced outside their own directories. Fourteen skills (8 + 6) lack explicit trigger or exclusion language in descriptions.

**Metrics:** 70 skills, avg 205 lines, 7 over 300 lines, 0 over 500 lines, 2 orphaned, 0 missing tier frontmatter.

### Commands & Subagents — GREEN
84 command files (56 in .claude/commands/, 28 in workflows/research-workflow/.claude/commands/) and 31 agent definitions. Both command symlinks valid. All skill and agent references in commands resolve correctly — apparent dead references (doc-scanner-agent, principles-checker-agent in friday-checkup.md) are self-guarded optional checks; strategic-critic.md in sync-workflow.md is inside a template example block. Nine command name collisions between root and research-workflow scopes are all intentional overrides (divergent content); zero drift copies detected. All agents have complete frontmatter (name, description, tools, model).

**Metrics:** 84 commands, 31 agents, 2 command symlinks, 0 agent symlinks, 0 dead references, 9 intentional overrides, 0 drift copies.

### Settings & Permissions — YELLOW
Three settings files, all valid JSON with proper permissions structure. All hook scripts referenced in settings files exist and are executable (14 scripts in .claude/hooks/, plus check-archive.sh in research-workflow). No stale path references. Hook types are all valid. Three minor findings: two hardcoded absolute paths in allow entries, one empty settings.local.json, and significant redundancy between root and research-workflow permission lists.

**Metrics:** 3 files, 0 invalid JSON, 0 missing hook scripts, 2 hardcoded absolute paths.

### 2026 Best Practices — GREEN
Subagent isolation is correctly implemented in QC commands (qc-pass, triage, refinement-pass, refinement-deep all spawn subagents). Context isolation is followed — audit-claude-md and cleanup-worktree explicitly pass content, not file paths, to subagents. Filesystem-first verification is enforced in CLAUDE.md and multiple commands. Model tiering is appropriate: 15 opus agents for judgment work, 7 sonnet for execution, 5 haiku for mechanical tasks. The workspace shows strong maturity signals: 14 hook scripts for mechanical enforcement, QC auto-loop with subagent isolation, session telemetry, Friday cadence automation, and error-driven learning evidenced in canonical rule mirroring.

**Metrics:** 84 commands, 70 skills, 31 agents. Subagent isolation: compliant. Context isolation: compliant. Filesystem verification: compliant. Import pattern: not adopted (not needed given CLAUDE.md sizes).

### Context Health — GREEN
All cross-references between CLAUDE.md files, skills, commands, agents, and hooks are intact. CLAUDE.md references to ai-resource-builder and workflow-evaluator are valid. All 36 pipeline skill references in research-workflow commands resolve. All 15 hook scripts are present and executable. Five high-impact files changed in recent commits: intake-processor/SKILL.md (v2 update), prime.md (two commits adding Step 0 git pull), and wrap-session.md in both scopes. All three are spot-check advisories (Minor), not broken references.

**Metrics:** 44 command references checked, 0 dead, 15 hook scripts checked, 0 missing, 5 recent high-impact changes.

---

## Prioritized Recommendations

**1. Add trigger/exclusion language to 14 skills (Skill Inventory, Minor)**
The #1 bang-for-effort fix. 8 skills lack trigger conditions; 6 lack exclusion conditions. A quick `/improve-skill` pass on each adds the missing language. This reduces routing ambiguity across the entire skill library.
*Skills needing trigger language:* architecture-qc, decision-to-prose-writer, formatting-qc, knowledge-file-completeness-qc, report-compliance-qc, research-prompt-qc, session-usage-analyzer, workflow-system-critic.
*Skills needing exclusion language:* analysis-pass-memo-review, editorial-recommendations-generator, workflow-consultant, workflow-creator, workflow-documenter, workspace-template-extractor.

**2. Fix hardcoded absolute paths in settings.json (Settings, Minor)**
Two permission entries in `.claude/settings.json` hardcode `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/**`. These will break if the workspace moves. Replace with `$CLAUDE_PROJECT_DIR`-relative references or document the dependency.

**3. Review answer-spec-generator and research-plan-creator for content extraction (Skill Inventory, Minor)**
At 487 and 466 lines respectively, these two skills are approaching the Important threshold. Both already have references/ directories. A focused extraction pass could reduce each by 50-100 lines with minimal disruption.

**4. Resolve two orphaned skills (Skill Inventory, Minor)**
fund-triage-scanner and prose-refinement-writer have no references outside their own directories. Decision needed: archive them (move to an `/archived/` sub-folder), or add references in appropriate commands if still needed.

**5. Spot-check recently updated files (Context Health, Minor)**
Three recent-change advisories: (a) verify project-consultant.md accurately describes the updated intake-processor v2; (b) check commands that describe /prime behavior reflect the new Step 0; (c) confirm wrap-session.md stage-boundary note is appropriate in both root and research-workflow scopes.
