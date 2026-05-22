# Workspace Health Report

**Date:** 2026-05-22
**Mode:** Full Audit
**Overall:** GREEN

---

## Executive Summary

The ai-resources repository is in strong health: all seven audit areas scored GREEN with zero Critical and zero Important findings. The 71-skill library, 57 commands, 27 agents, and 14 hooks are structurally intact — every skill has valid tier frontmatter, every command and hook reference resolves, and QC independence and context isolation are consistently enforced. The only items surfaced are nine Minor cleanups; the highest-value one is confirming whether two apparently-orphaned skills (`fund-triage-scanner`, `prose-refinement-writer`) are still intended to be in the library.

## Scores

| Area | Score | Critical | Important | Minor |
|------|-------|----------|-----------|-------|
| File Organization | GREEN | 0 | 0 | 1 |
| CLAUDE.md Health | GREEN | 0 | 0 | 0 |
| Skill Inventory | GREEN | 0 | 0 | 3 |
| Commands & Subagents | GREEN | 0 | 0 | 0 |
| Settings & Permissions | GREEN | 0 | 0 | 0 |
| 2026 Best Practices | GREEN | 0 | 0 | 1 |
| Context Health | GREEN | 0 | 0 | 3 |

## Findings

### Critical (Fix Now)
No critical findings.

### Important (Fix Soon)
No important findings.

### Improvement Opportunities

- **[File Organization] .DS_Store committed at repo root** / A macOS .DS_Store file (6148 bytes) is present at the ai-resources root. .gitignore exists; verify .DS_Store is ignored and not tracked. / *Location:* `.DS_Store` / *Recommendation:* Ensure .DS_Store is in .gitignore and remove from tracking if committed.

- **[Skill Inventory] Two skills appear orphaned (no command/agent/CLAUDE.md reference)** / `fund-triage-scanner` and `prose-refinement-writer` are not referenced by any command, agent, or CLAUDE.md file — they appear only in historical log entries. They may be intentionally standalone or invoked ad hoc. (`formatting-qc` and `jargon-gloss` initially looked orphaned but ARE referenced by research-workflow commands — not orphans.) / *Location:* `skills/fund-triage-scanner/, skills/prose-refinement-writer/` / *Recommendation:* Confirm these two skills are still intended to be in the library; if obsolete, archive them.

- **[Skill Inventory] Four skills omit exclusion conditions in their description** / `workflow-consultant`, `workflow-creator`, `workflow-documenter`, and `workspace-template-extractor` have trigger conditions but no "Do NOT use for" exclusions. Exclusions sharpen routing when skills have adjacent siblings (the four workflow-* skills are themselves a cluster). / *Location:* `skills/workflow-consultant/SKILL.md, skills/workflow-creator/SKILL.md, skills/workflow-documenter/SKILL.md, skills/workspace-template-extractor/SKILL.md` / *Recommendation:* Add a short "Do NOT use for" clause to each, pointing at the sibling skill that handles the adjacent case.

- **[Skill Inventory] Five skills exceed 300 body lines** / `answer-spec-generator` (476), `research-plan-creator` (452), `ai-resource-builder` (403), `ai-prose-decontamination` (393), and `evidence-to-report-writer` (335) are over the 300-line advisory threshold. None exceed the 500-line restructuring threshold. / *Location:* `skills/answer-spec-generator/SKILL.md` and four others / *Recommendation:* Optional — consider moving worked examples or sub-procedures to references/ files for the largest two.

- **[2026 Best Practices] Both CLAUDE.md files are monolithic (no @import pattern)** / The ai-resources root CLAUDE.md (90 lines) and the research-workflow template CLAUDE.md (128 lines) use no @import references. Both are well under the ~200-line threshold where the pattern matters. Advisory only. / *Location:* `CLAUDE.md, workflows/research-workflow/CLAUDE.md` / *Recommendation:* No action required at current size; adopt @import only if either file grows past ~200 lines.

- **[Context Health] Recent high-impact change: implementation-project-planner SKILL.md (commit 9dd536d)** / Updated with harness-ready field guidance (CR-15). Referenced by skills/CATALOG.md and cross-referenced by architecture-designer, session-guide-generator, spec-writer. / *Location:* `skills/implementation-project-planner/SKILL.md` / *Recommendation:* Informational — verify sibling cross-references still align with the new field guidance.

- **[Context Health] Recent high-impact change: jargon-gloss skill + wrapper command (commit 1e5db1d)** / Newly-added skill wired to research-workflow commands produce-jargon-gloss.md and produce-prose-draft.md (Phase 6). Both references resolve. / *Location:* `skills/jargon-gloss/SKILL.md, workflows/research-workflow/.claude/commands/produce-jargon-gloss.md` / *Recommendation:* Informational — spot-check on first production use.

- **[Context Health] Recent high-impact change: session-start.md and new-project.md commands** / session-start.md received a boundary fix (69e1597); new-project.md received an auto-git-init feature (9764d7f). All downstream references resolve. / *Location:* `.claude/commands/session-start.md, .claude/commands/new-project.md` / *Recommendation:* Informational — referenced commands are intact.

## Detailed Analysis

### File Organization
File organization is healthy. 71 skill directories all contain SKILL.md and use lowercase kebab-case naming. Both symlinks (research-workflow command shares) resolve to readable targets. CLAUDE.md files are correctly placed at the ai-resources root and the research-workflow template root. Only a cosmetic .DS_Store note.
*Metrics:* 71 skill dirs, 2 symlinks (0 broken), 2 CLAUDE.md files.

### CLAUDE.md Health
Both CLAUDE.md files are healthy. The ai-resources root file (90 lines, ~1.3K tokens) and the research-workflow template (128 lines, ~1.5K tokens) are well within size thresholds. Both have orientation sections. No @imports, no dead references, no hardcoded secrets, no cross-level contradictions detected.
*Metrics:* 2 files; CLAUDE.md 90 lines / ~1289 tokens; research-workflow 128 lines / ~1520 tokens; 0 dead imports.

### Skill Inventory
Skill inventory is in strong shape. All 71 skills have a SKILL.md, valid name/description frontmatter, and complete model/effort tier declarations with valid values. Average body length is 194 lines; 5 skills exceed 300 lines but none exceed 500. No trigger overlap approaches the 60% concern threshold (highest pair is 0.41). No dead internal references after false-positive screening (the ai-resource-builder meta-skill's illustrative example paths and a grep trailing-period artifact in citation-converter were correctly excluded). Minor cleanup: 2 possibly-orphaned skills and 4 skills missing exclusion clauses.
*Metrics:* 71 skills, avg 194 lines, 5 over 300 lines, 0 over 500, 2 orphaned, 0 missing tier frontmatter.

### Commands & Subagents
Commands and subagents are healthy. 56 commands in ai-resources/.claude/commands and 30 in the research-workflow template (2 are symlinks to ai-resources sources, both resolving). All 31 agent definitions have complete frontmatter. All command Usage lines present. No dead skill references after false-positive screening. 11 command-name collisions between scopes: 2 are intentional symlinks and 9 are divergent project-specific overrides — zero unwanted drift.
*Metrics:* 86 commands, 31 agents, 2 command symlinks, 0 dead references, 11 name collisions (0 drift, 9 intentional overrides).

### Settings & Permissions
All settings files are valid JSON with well-formed permissions blocks. All 9 hook scripts referenced in .claude/settings.json exist and are executable; the research-workflow template's hooks use portable $CLAUDE_PROJECT_DIR paths with no missing scripts. No stale path-referencing permission entries. Bash(*) and bypassPermissions mode are intentional design choices (noted, not flagged). Neither live settings file declares a model field — compliant with the Model Tier rule.
*Metrics:* 3 settings files analyzed, all valid JSON; .claude/settings.json has 20 allow / 8 deny / 9 hooks; 0 stale entries.

### 2026 Best Practices
The workspace is in strong shape against 2026 Claude Code best practices. QC and evaluation tasks consistently run as isolated subagents with no conversation-history leakage; commands pass content to subagents; output verification uses the filesystem, not git. No git-status/diff verification anti-pattern. The only advisory note is that both in-scope CLAUDE.md files are monolithic, harmless at their current small size.
*Metrics:* 57 commands, 71 skills, 27 agents; subagent isolation, context isolation, and filesystem verification all compliant.

### Context Health
Cross-reference integrity is intact across the workspace. The single CLAUDE.md skill reference resolves; all 95 skill/agent references from commands resolve; all 9 referenced hook scripts exist and are executable; all 38 research-workflow pipeline step-to-skill references resolve. The recent-change scan found 6 high-impact files modified in the last 12 commits — all downstream references remain valid.
*Metrics:* 95 command references checked (0 dead), 9 hook scripts checked (0 missing), 38 pipeline steps checked (0 mismatches), 6 recent high-impact changes.

## Prioritized Recommendations

1. **Confirm or archive the two orphaned skills** — `fund-triage-scanner` and `prose-refinement-writer` have no live wiring; a stale skill in the library adds routing noise and audit overhead. Effort: Low. Area: Skill Inventory.
2. **Add exclusion clauses to the four workflow-* skills** — they form a sibling cluster, so missing "Do NOT use for" lines are the most likely real source of ambiguous routing in the library. Effort: Low. Area: Skill Inventory.
3. **Spot-check recently-changed skills on next live run** — `implementation-project-planner` (CR-15 field guidance) and `jargon-gloss` (new skill) changed in the last 12 commits; verify behavior on first production use. Effort: Low. Area: Context Health.
4. **Remove .DS_Store from the repo root** — confirm it is gitignored and untracked; cosmetic but trivial to fix. Effort: Low. Area: File Organization.
5. **Watch the five 300+ line skills** — no action needed now, but `answer-spec-generator` (476) and `research-plan-creator` (452) are the candidates to split first if they keep growing. Effort: Medium (deferred). Area: Skill Inventory.

---
*Generated by repo-health-analyzer v2 (sequential mode). Auditors: 7 run, 0 skipped. Note: the Agent/Task subagent tool was unavailable in this environment, so the lead agent executed all 7 auditors' checklists directly and inline rather than dispatching subagent processes; each auditor's procedure, scoring rules, and false-positive screening were applied as written.*
