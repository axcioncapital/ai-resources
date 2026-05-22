# Workspace Health Report

**Date:** 2026-05-22
**Mode:** Full Audit
**Overall:** GREEN

---

## Executive Summary

The global-macro-analysis project is healthy across all seven audited areas with no Critical or Important findings. All 59 symlinks resolve, both CLAUDE.md files are well within size limits, all 3 skills and 16 agents have complete frontmatter, and cross-reference integrity is intact. Top recommendation: optionally extract the two inline PreToolUse hooks into versioned `.claude/hooks/` script files for easier maintenance — the only non-trivial improvement opportunity.

## Scores
| Area | Score | Critical | Important | Minor |
|------|-------|----------|-----------|-------|
| File Organization | GREEN | 0 | 0 | 1 |
| CLAUDE.md Health | GREEN | 0 | 0 | 0 |
| Skill Inventory | GREEN | 0 | 0 | 1 |
| Commands & Subagents | GREEN | 0 | 0 | 1 |
| Settings & Permissions | GREEN | 0 | 0 | 1 |
| 2026 Best Practices | GREEN | 0 | 0 | 2 |
| Context Health | GREEN | 0 | 0 | 1 |

## Findings

### Critical (Fix Now)

No critical findings.

### Important (Fix Soon)

No important findings.

### Improvement Opportunities

- **[File Organization] Nested CLAUDE.md in macro-kb/ not explicitly registered by parent CLAUDE.md**
  macro-kb/CLAUDE.md exists as a self-declared "In-vault Operating Contract". The nearest ancestor (project root CLAUDE.md) states "All content lives in macro-kb/" but contains none of the registration phrases (sub-workspace, nested CLAUDE.md, own CLAUDE.md, intentional, expected to load) naming the macro-kb/ directory. The macro-kb/CLAUDE.md is clearly intentional — it cross-references `../CLAUDE.md` and declares deliberate divergence from the obsidian-kb-builder schema — so this is a low-severity documentation gap, not a misplacement.
  *Location:* `projects/global-macro-analysis/macro-kb/CLAUDE.md`
  *Recommendation:* Add one line to the project root CLAUDE.md noting that macro-kb/ carries its own operating-contract CLAUDE.md, so audit tooling treats it as intentional.

- **[Skill Inventory] ai-resource-builder SKILL.md body exceeds 300 lines**
  The ai-resource-builder skill (symlinked into the project from ai-resources) has a SKILL.md body of 403 lines, above the 300-line advisory threshold and below the 500-line Important threshold. This is a shared library skill, not project-owned.
  *Location:* `skills/ai-resource-builder/SKILL.md`
  *Recommendation:* Advisory only — consider splitting reference-heavy sections into bundled reference files. Any change must be made in ai-resources, not the project.

- **[Commands & Subagents] 13 project-local kb-* commands lack a literal Usage: line**
  All 13 kb-* commands have YAML frontmatter (`model:` field) followed by a descriptive first content line in the form `/kb-name [$ARGUMENTS] — description`, plus Scope and Argument sections. They self-document well but carry no literal `Usage:` convention line. The prior 2026-04-11 report flagged this as Important; the command-auditor's own rubric scores a missing Usage line as Minor, so it is reclassified down here. The commands have since gained `model:` frontmatter — an improvement over the prior audit state.
  *Location:* `projects/global-macro-analysis/.claude/commands/kb-*.md`
  *Recommendation:* Optionally add a `Usage: /kb-name [args]` line under the frontmatter for convention consistency. Low effort; the current first line already conveys the same information.

- **[Settings & Permissions] PreToolUse hooks use inline jq/grep commands rather than script files**
  The project settings.json defines two PreToolUse hooks (Write and Edit matchers) enforcing KB hard rules 1 and 3 (theme-folder write/edit guards). Both are long inline shell pipelines embedded directly in the JSON command field rather than referencing a script in `.claude/hooks/`. Functional and with no broken-script risk, but inline hooks are harder to maintain, version, and test.
  *Location:* `projects/global-macro-analysis/.claude/settings.json`
  *Recommendation:* Advisory — consider extracting the two inline hook pipelines into `.claude/hooks/` script files.

- **[2026 Best Practices] No @import pattern in CLAUDE.md files**
  Neither the project CLAUDE.md (80 lines) nor macro-kb/CLAUDE.md (35 lines) uses @imports. Both are monolithic but small — well below the 200-line threshold where the pattern becomes worthwhile.
  *Location:* `projects/global-macro-analysis/CLAUDE.md`
  *Recommendation:* Advisory — adopt @imports proactively only if either CLAUDE.md grows past ~150 lines.

- **[2026 Best Practices] Two PreToolUse hooks are inline pipelines rather than versioned scripts**
  Cross-cutting maintainability note (also surfaced by settings-auditor). Using hooks for mechanical write-guard checks is correct best practice, but embedding them inline rather than in `.claude/hooks/` script files reduces maintainability and testability.
  *Location:* `projects/global-macro-analysis/.claude/settings.json`
  *Recommendation:* Advisory — extract the two inline hook pipelines into `.claude/hooks/` script files.

- **[Context Health] No high-impact configuration files changed in the last 10 commits**
  Recent-change risk scan shows all activity in the last 10 commits is knowledge-base content (middle-east-escalation theme deepening: populate, review, synthesize, gap-audit runs). No CLAUDE.md, settings.json, SKILL.md, agent, or command files were modified. There is no recent structural drift to spot-check — the configuration layer is stable. Informational only.
  *Location:* `projects/global-macro-analysis/`
  *Recommendation:* No action needed.

## Detailed Analysis

### File Organization
Clean project layout: CLAUDE.md, macro-kb/, skills/, .claude/, pipeline/, logs/, reports/. All 3 skill directories (ai-resource-builder, intake-processor, repo-health-analyzer) are symlinks into ai-resources/skills with valid SKILL.md targets. All 59 symlinks resolve correctly with zero breakage — 40 command symlinks, 16 agent symlinks, 3 skill-directory symlinks. 2 CLAUDE.md files. The macro-kb/ knowledge base holds 42 theme folders plus _meta/_staging/_sources/_decisions/_inbox infrastructure directories. Metrics: 3 skill dirs, 59 symlinks, 0 broken, 2 CLAUDE.md files.

### CLAUDE.md Health
Project CLAUDE.md: 80 lines, ~1,053 estimated tokens — well under the 200-line / 4,000-token threshold. macro-kb/CLAUDE.md: 35 lines, ~302 tokens — concise. Neither uses @imports but both are small enough not to need them. No dead references, no secrets patterns. Both have orientation sections ("What This Is" / "Purpose"). The two levels are consistent rather than contradictory — macro-kb/CLAUDE.md explicitly defers the 6 hard rules and 2 operator gates to the parent CLAUDE.md.

### Skill Inventory
3 skills, all symlinks into ai-resources/skills. All have valid SKILL.md with complete frontmatter: name, description, model, and effort. intake-processor (sonnet/medium, 139-line body), repo-health-analyzer (opus/high, 42-line body), ai-resource-builder (opus/high, 403-line body — over the 300-line advisory threshold). All three are referenced elsewhere in the workspace, so none are orphaned. Metrics: 3 skills, 1 over 300 lines, 0 over 500 lines, 0 orphaned, 0 missing tier frontmatter.

### Commands & Subagents
53 commands total: 13 project-local kb-* commands plus 40 symlinked shared commands (38 from ai-resources, 2 from the axcion-ai-system-owner project). 16 agents, all symlinked from shared scopes. All command and agent symlinks resolve correctly with no dead targets. The one command-to-skill reference (kb-ingest loading skills/intake-processor/SKILL.md) is valid. No duplicate command names, no dead references. All 16 agents carry complete frontmatter (name, description, tools, model). The 13 kb-* commands now have `model:` frontmatter (12 sonnet, kb-synthesize on opus).

### Settings & Permissions
2 settings files, both valid JSON. settings.json: well-formed permissions object (17 allow, 7 deny), defaultMode bypassPermissions, 2 PreToolUse hooks enforcing KB hard rules 1 and 3. settings.local.json: empty object. No stale path-referencing permission entries — the deny entry `Read(archive/**)` targets a directory that does not yet exist but is a forward-looking guard documented in .gitignore, so it is intentional and not flagged. Hooks are inline (no missing-script risk). Broad pattern noted: `Bash(*)` in settings.json (design choice, informational).

### 2026 Best Practices
The project follows 2026 Claude Code best practices well. Hooks are used for mechanical write-guards (correct — mechanical enforcement, not judgment). Per-command model tiering is declared in frontmatter. Operator gates (kb-ingest Step 6, kb-review Step 5) keep the human in the judgment loop. Filesystem-first verification is used — kb-synthesize recomputes a sha256 hash before copying; git is used only for concurrency detection, not output verification. QC infrastructure (qc-reviewer, triage-reviewer agents) is symlinked in from the shared library. Maturity signals: operator gates, staging-only write discipline (CLAUDE.md + hook-enforced), append-only atomic-entry rule, error-driven evolution (concurrent-session recovery procedure, sha256 abort), per-command tiering, 42-theme structured KB. No compound or systemic problems found across the Wave 1 auditors. Metrics: 53 commands, 3 skills, 16 agents; import pattern not adopted (files too small to need it); subagent isolation, context isolation, and filesystem verification all compliant.

### Context Health
Cross-reference integrity is intact. All CLAUDE.md skill references resolve — intake-processor referenced from project CLAUDE.md, obsidian-kb-builder referenced comparatively in macro-kb/CLAUDE.md; both exist. The single command-to-skill reference (kb-ingest loading skills/intake-processor/SKILL.md) is valid and the skill's trigger conditions ("Trigger when the /kb-ingest command is run") align with how the command invokes it. All 9 pipeline-doc references to skills/intake-processor resolve. The two PreToolUse hooks are inline pipelines with no external script dependency, so no hook-script breakage is possible. No drift risk — the last 10 commits touched only KB content, leaving the configuration layer stable. Metrics: 5 skill references checked, 0 dead; 1 command reference checked, 0 dead; 9 pipeline steps checked, 0 mismatches; 0 hook scripts (inline); 0 recent high-impact changes.

## Prioritized Recommendations

1. **Extract the two inline PreToolUse hooks into `.claude/hooks/` script files.** — Inline hook pipelines are harder to version, test, and maintain than referenced scripts; this is the only improvement that touches behavior-critical infrastructure. Effort: Low. Area: Settings & Permissions.

2. **Add a one-line registration note to the project root CLAUDE.md for macro-kb/CLAUDE.md.** — Makes the intentional nested operating-contract explicit so future audit tooling does not re-flag it. Effort: Low. Area: File Organization.

3. **Optionally add `Usage:` lines to the 13 kb-* commands.** — Convention consistency with shared commands; the existing `/kb-name — description` first line already conveys the same information, so this is cosmetic. Effort: Low. Area: Commands & Subagents.

4. **Consider splitting ai-resource-builder's 403-line SKILL.md.** — Advisory; over the 300-line threshold. Must be done in ai-resources, not this project. Effort: Medium. Area: Skill Inventory.

5. **Adopt @imports if either CLAUDE.md grows past ~150 lines.** — No action needed now (80 and 35 lines); noted as a future trigger. Effort: Low. Area: 2026 Best Practices.

---
*Generated by repo-health-analyzer v2 (sequential mode). Auditors: 7 run, 0 skipped. Deviation: the Agent/Task tool was unavailable in this environment, so the lead agent executed each of the 7 auditors' checklists directly and inline, applying each auditor's procedure, scoring rubric, and false-positive screening as written.*
