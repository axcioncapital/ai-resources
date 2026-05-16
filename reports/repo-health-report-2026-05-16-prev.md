# Workspace Health Report

**Date:** 2026-05-08
**Mode:** Full Audit
**Overall:** RED

---

## Executive Summary

The ai-resources repo is structurally sound and operationally mature, but a single Critical issue pulls the overall score to RED: a broken symlink for `/consult` in the research-workflow template, introduced in commit fba2cc4, uses a 3-level relative path that falls one directory level short. Any deployed research-workflow project will fail at runtime when `/consult` is invoked. The fix is a one-line symlink correction. Beyond this, the workspace scores GREEN on CLAUDE.md health, and YELLOW on skill inventory, settings, and best practices — all manageable minor issues with no blocking impact.

## Scores

| Area | Score | Critical | Important | Minor |
|------|-------|----------|-----------|-------|
| File Organization | RED | 1 | 0 | 0 |
| CLAUDE.md Health | GREEN | 0 | 0 | 0 |
| Skill Inventory | YELLOW | 0 | 0 | 4 |
| Commands & Subagents | RED | 1 | 0 | 2 |
| Settings & Permissions | YELLOW | 0 | 1 | 1 |
| 2026 Best Practices | YELLOW | 0 | 1 | 1 |
| Context Health | RED | 1 | 0 | 2 |

*Note: The Critical findings in File Organization, Commands & Subagents, and Context Health all refer to the same underlying issue — the broken consult.md symlink — counted once in the Prioritized Recommendations.*

---

## Findings

### Critical (Fix Now)

- **[File Organization / Commands & Subagents / Context Health] Broken symlink: consult.md in research-workflow commands**
  The symlink at `workflows/research-workflow/.claude/commands/consult.md` points to `../../../.claude/commands/consult.md`. Walking three levels up from `workflows/research-workflow/.claude/commands/` reaches `workflows/` — not the repo root. The correct relative path is `../../../../.claude/commands/consult.md` (four levels). The file exists at `.claude/commands/consult.md` but is unreachable through the symlink. Introduced in commit fba2cc4 ('chore: symlink /consult into research-workflow template'). Any deployed research-workflow project calling `/consult` will fail.
  *Location:* `workflows/research-workflow/.claude/commands/consult.md`
  *Recommendation:* `cd workflows/research-workflow/.claude/commands && ln -sf ../../../../.claude/commands/consult.md consult.md`. Verify with `readlink -f` afterward.

---

### Important (Fix Soon)

- **[Settings & Permissions] Stale deny entry: Read(archive/**) references non-existent directory**
  The ai-resources `.claude/settings.json` deny list includes `Read(archive/**)`, but there is no `archive/` directory at the ai-resources root. This entry is harmless but is dead weight.
  *Location:* `.claude/settings.json` line 14
  *Recommendation:* Remove the `Read(archive/**)` entry from the deny list.

- **[2026 Best Practices] CLAUDE.md files are monolithic — no @import pattern used**
  Neither `CLAUDE.md` (92 lines) nor `workflows/research-workflow/CLAUDE.md` (128 lines) uses `@import` to separate detailed instructions into reference files. Both are below the 200-line threshold today, but as the workspace grows this pattern should be established before it becomes a maintenance burden.
  *Location:* `CLAUDE.md`, `workflows/research-workflow/CLAUDE.md`
  *Recommendation:* Extract stable procedural rules (commit rules, file write discipline, QC rules) into `@imported` reference files under `docs/`. Begin with whichever file grows next.

---

### Improvement Opportunities

- **[Commands & Subagents] session-plan.md uses absolute-path symlink (fragile on workspace move)**
  `workflows/research-workflow/.claude/commands/session-plan.md` uses an absolute path pointing to the current machine's home directory. This will break if the workspace is cloned to another machine or moved to a different path.
  *Location:* `workflows/research-workflow/.claude/commands/session-plan.md`
  *Recommendation:* Convert to relative path: `../../../../.claude/commands/session-plan.md`.

- **[Commands & Subagents] 43 of 52 commands lack a Usage: or #-heading convention line**
  Most commands use YAML frontmatter followed by bare prose — no `Usage:` line or `# /command-name` heading. This is a style inconsistency, not a functional issue, but reduces discoverability.
  *Location:* `.claude/commands/` (43 files)
  *Recommendation:* Adopt a consistent convention: `Usage:` line for commands that accept `$ARGUMENTS`, `# /command-name` heading for commands that don't.

- **[Settings & Permissions] Research-workflow template has unfilled {{WORKSPACE_ROOT}} placeholder**
  `workflows/research-workflow/.claude/settings.json` contains `{{WORKSPACE_ROOT}}` in `additionalDirectories`. If `/deploy-workflow` does not substitute this, deployed projects will have a literal placeholder string instead of a valid path.
  *Location:* `workflows/research-workflow/.claude/settings.json` line 35
  *Recommendation:* Verify `/deploy-workflow`'s placeholder replacement step covers this field. Add a post-deploy validation that checks for remaining `{{` tokens.

- **[Skill Inventory] 7 skills exceed the 300-line size guideline**
  Skills over 300 lines: ai-prose-decontamination (316), ai-resource-builder (415), answer-spec-generator (487), evidence-to-report-writer (334), research-plan-creator (466), workflow-evaluator (318), workflow-system-critic (302). None reach the 500-line Important threshold.
  *Location:* `skills/` (7 files)
  *Recommendation:* For the largest three (answer-spec-generator at 487, research-plan-creator at 466, ai-resource-builder at 415): extract procedural reference tables or examples into bundled `references/` subdirectories.

- **[Skill Inventory] 9 skills missing trigger conditions in description**
  Skills with no detectable trigger keywords (`use when`, `trigger`, `run when`, `invoke when`, `when you`, `when to`) in their frontmatter description: architecture-qc, decision-to-prose-writer, formatting-qc, knowledge-file-completeness-qc, report-compliance-qc, research-prompt-qc, session-usage-analyzer, workflow-system-critic.
  *Location:* Frontmatter of 9 SKILL.md files
  *Recommendation:* Add a `Use when:` or `Trigger when:` clause to each description. Prioritize skills involved in pipeline routing.

- **[Skill Inventory] 14 skills missing exclusion conditions in description**
  Skills with no detectable exclusion keywords in frontmatter description: analysis-pass-memo-review, editorial-recommendations-generator, workflow-consultant, workflow-creator, workflow-documenter, workspace-template-extractor, and 8 others (overlap with the missing-trigger list above).
  *Location:* Frontmatter of 14 SKILL.md files
  *Recommendation:* Add `Do NOT use for...` clause to each description. Focus on skills that could be confused with adjacent skills (e.g., `editorial-recommendations-generator` vs `editorial-recommendations-qc`).

- **[Skill Inventory] 22 skills appear to have no external references in ai-resources scope**
  Skills with no references in `.claude/commands/` or `CLAUDE.md` within ai-resources: architecture-designer, claude-code-workflow-builder, curiosity-hub-article-writer, fund-triage-scanner, implementation-project-planner, implementation-spec-writer, journal-thinking-clarifier, journal-wiki-creator, journal-wiki-improver, journal-wiki-integrator, knowledge-file-completeness-qc, project-implementer, project-tester, prose-refinement-writer, spec-writer, specifying-output-style, workflow-consultant, workflow-creator, workflow-documenter, workflow-system-analyzer, workflow-system-critic, workspace-template-extractor. Many are referenced via CATALOG.md and cross-skill descriptions.
  *Location:* `skills/` (22 directories)
  *Recommendation:* Advisory review — many are project-specific skills or workflow-development skills invoked from project-level commands outside this repo. Retain unless confirmed unused.

- **[2026 Best Practices] Context isolation pattern is inconsistent across commands**
  Some commands pass content to subagents (correct pattern per CLAUDE.md subagent contracts); others pass file paths for subagents to read. The path-passing cases are mostly justified (cleanup-worktree: subagent reads and writes the plan file; analyze-workflow: analysis files are large), but the inconsistency creates a risk of future commands defaulting to path-passing without justification.
  *Location:* `.claude/commands/` (multiple files)
  *Recommendation:* Document the decision rule in CLAUDE.md subagent contracts: content-passing is default; path-passing is acceptable only when (a) the file is session-generated and the subagent also writes to it, or (b) the file exceeds reasonable content-passing size. Add a comment to each path-passing command explaining which condition applies.

- **[Context Health] friday-checkup.md changed recently — spot-check 5 dependent commands**
  Commit c17fd2d modified `friday-checkup.md` (STALE detection, G+I weekly retiering, Step K Phase-1 sunset). Five commands depend on it: `so-monthly.md`, `monday-prep.md`, `risk-check.md`, `permission-sweep.md`, `consult.md`.
  *Location:* `.claude/commands/friday-checkup.md` (commit c17fd2d)
  *Recommendation:* Spot-check `so-monthly.md`, `monday-prep.md`, and `friday-act.md` for output format compatibility with the new STALE detection fields.

- **[Context Health] system-owner agent added recently — validate before first production use**
  `system-owner.md` was added in commit 4dcb73e. Five commands use it: `so-monthly.md`, `implementation-triage.md`, `architecture-review.md`, `friday-so.md`, `systems-review.md`. No dead references found, but the agent and all dependent commands are newly added and untested in this repo.
  *Location:* `.claude/agents/system-owner.md` (commit 4dcb73e)
  *Recommendation:* Run one end-to-end test of `/friday-so` or `/consult` (after fixing the symlink) to validate the system-owner agent produces expected output.

---

## Detailed Analysis

### File Organization

The ai-resources repo has clean structure: all expected directories exist (`.claude/`, `.claude/commands/`, `skills/`, `reports/`, `workflows/`), `CLAUDE.md` is present, and all 70 skill directories use valid kebab-case naming. Zero orphaned skill directories. Two CLAUDE.md files are in expected locations (repo root and research-workflow template root).

Two symlinks exist. One (session-plan.md) works via absolute path. One (consult.md) is broken due to a 3-level relative path that should be 4 levels. This is the only structural issue.

**Metrics:** 70 skill dirs, 2 symlinks, 1 broken symlink, 2 CLAUDE.md files.

---

### CLAUDE.md Health

Both CLAUDE.md files are well within health thresholds. The repo-level file is 92 lines (~1,266 tokens) and the research-workflow template is 128 lines (~1,520 tokens). Both have clear orientation sections and proper heading structure. No @import patterns (not required at current sizes). No hardcoded secrets. No contradictions between levels.

**Metrics:** 2 files, 0 dead imports, 0 secrets found.

---

### Skill Inventory

70 skills, all with valid SKILL.md files, valid frontmatter, kebab-case naming, and complete `model:` + `effort:` declarations. No dead internal references — all bundled `references/`, `scripts/`, and `assets/` paths that are operationally referenced resolve to existing files. No trigger-overlap pairs exceed 60% Jaccard similarity.

Minor issues: 7 skills over 300 lines (none over 500), description gaps (triggers and exclusions) in roughly 10-20% of skills, and 22 skills with no references within ai-resources scope (likely referenced from project workspaces).

**Metrics:** 70 total skills, 205 average lines, 7 over 300 lines, 0 over 500 lines, 0 missing model/effort fields.

---

### Commands & Subagents

81 total commands across two scopes (52 ai-resources, 29 research-workflow), 26 agents. All agent frontmatters are complete (name, description, tools, model). No dead skill references in any command (all apparent dead references were in example tables or documentation contexts). No dead agent references. Ten name collisions between scopes are all intentional project-level overrides (0 byte-identical drift).

One Critical finding: consult.md broken symlink. One Minor: session-plan.md absolute-path symlink. One Minor: 43/52 commands lack a Usage:/heading convention line.

---

### Settings & Permissions

Three settings files across two scopes. All valid JSON, all with proper `permissions` structures. All hook scripts referenced in settings files exist on disk and are executable. No hardcoded absolute paths in hook commands. The research-workflow settings uses `$CLAUDE_PROJECT_DIR` correctly. Two broad `Bash(*)` patterns are design choices, not findings.

One Important: stale `Read(archive/**)` deny entry. One Minor: unfilled `{{WORKSPACE_ROOT}}` template placeholder in research-workflow settings.

---

### 2026 Best Practices

High maturity: QC pipeline uses properly isolated subagents (`qc-reviewer`, `triage-reviewer`, `refinement-reviewer`). Filesystem-first verification is explicitly codified in CLAUDE.md rules and followed. Model tiering is consistent across 26 agents (haiku for mechanical, sonnet for execution, opus for judgment). The 14-hook automation layer covers mechanical checks, session rituals, and write activity tracking.

Two gaps: no @import pattern adopted (Important), and context isolation pattern is inconsistently documented across commands (Minor).

**Maturity signals:** 14 hooks, 5 session ritual commands, tiered QC pipeline, compound audit system, Friday cadence automation, session telemetry system, 0 command drift.

---

### Context Health

All CLAUDE.md-to-skill references are valid. All command-to-skill references are valid (apparent dead references confirmed as documentation/example contexts). All pipeline stage skill references intact. All 13 hook scripts present and executable. The only cross-reference integrity failure is the consult.md symlink (already documented).

Recent-change scan: 10 high-impact files changed in last 10 commits. The system-owner agent and 5 dependent commands are newly added and should be spot-checked before heavy production use.

---

## Prioritized Recommendations

1. **Fix consult.md symlink depth** — Broken symlink causes runtime failure in any deployed research-workflow project. One-line fix: recreate with 4-level relative path. Effort: Low. Area: File Organization / Commands / Context Health.

2. **Remove stale Read(archive/**) deny entry** — Dead configuration entry in `.claude/settings.json`. Minor cleanup. Effort: Low. Area: Settings & Permissions.

3. **Convert session-plan.md symlink to relative path** — Prevents breakage on workspace move or clone. Effort: Low. Area: Commands & Subagents.

4. **Verify {{WORKSPACE_ROOT}} substitution in /deploy-workflow** — Add post-deploy validation to catch unfilled placeholders. Effort: Low. Area: Settings & Permissions.

5. **Add trigger/exclusion clauses to 9 skills missing triggers and 14 missing exclusions** — Improves routing reliability. Focus on skills involved in pipeline steps. Effort: Medium. Area: Skill Inventory.

6. **Spot-check friday-checkup dependents after c17fd2d** — Verify so-monthly.md, monday-prep.md, friday-act.md handle new STALE detection output fields. Effort: Low. Area: Context Health.

7. **Run end-to-end test of system-owner agent chain** — Validate /friday-so or /consult produces expected output. Effort: Low. Area: Context Health.

8. **Document context isolation decision rule in CLAUDE.md subagent contracts** — Clarify when path-passing is acceptable vs. content-passing is required. Effort: Low. Area: 2026 Best Practices.

9. **Begin @import pattern for CLAUDE.md files** — Extract stable procedural rules into reference files. Start with the next file that grows past 120 lines. Effort: Medium. Area: 2026 Best Practices.

10. **Split the 3 largest skills** — answer-spec-generator (487), research-plan-creator (466), ai-resource-builder (415) are candidates for extracting procedural tables into bundled references/. Effort: Medium. Area: Skill Inventory.

---

*Generated by repo-health-analyzer v2 (sequential mode). Auditors: 7 run, 0 skipped.*
