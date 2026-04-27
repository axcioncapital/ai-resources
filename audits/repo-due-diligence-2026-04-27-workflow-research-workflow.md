# Repo Due Diligence Audit — 2026-04-27
Repo: ai-resources/workflows/research-workflow
Scope: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow
Commit: dd19aea (HEAD of ai-resources repo at audit time)
Previous audit: None

---

## Section 1: Inventory

### 1.1 Slash Commands

| Name | Defined In | Files Referenced |
|------|-----------|-----------------|
| `/audit-repo` | `.claude/commands/audit-repo.md` | `reference/skills/repo-health-analyzer/agents/` (7 agent files) |
| `/audit-structure` | `.claude/commands/audit-structure.md` | `reference/file-conventions.md`, `reference/stage-instructions.md` |
| `/create-context-pack` | `.claude/commands/create-context-pack.md` | `/ai-resources/skills/context-pack-builder/SKILL.md`, `preparation/` task plans |
| `/friction-log` | `.claude/commands/friction-log.md` | `logs/friction-log.md` |
| `/improve` | `.claude/commands/improve.md` | `logs/friction-log.md`, `logs/improvement-log.md`, `improvement-analyst` agent |
| `/inject-dependency` | `.claude/commands/inject-dependency.md` | `logs/session-notes.md`, `execution/research-prompts/{section}/session-plan.md`, `execution/raw-reports/`, `execution/research-prompts/` |
| `/intake-reports` | `.claude/commands/intake-reports.md` | `execution/research-prompts/{section}/session-plan.md`, `execution/raw-reports/` |
| `/note` | `.claude/commands/note.md` | `logs/friction-log.md`, `logs/workflow-observations.md` |
| `/prime` | `.claude/commands/prime.md` | `logs/session-notes.md`, `checkpoints/` directories |
| `/produce-architecture` | `.claude/commands/produce-architecture.md` | `parts/part-2-service/`, `parts/part-3-strategy/`, `output/part-2-prose/`, `output/part-3-prose/`, `/ai-resources/skills/research-structure-creator/SKILL.md`, `/ai-resources/skills/architecture-qc/SKILL.md`, `context/project-brief.md`, `context/content-architecture.md` |
| `/produce-formatting` | `.claude/commands/produce-formatting.md` | prose file in `output/`, `/ai-resources/skills/prose-formatter/SKILL.md`, `/ai-resources/skills/h3-title-pass/SKILL.md`, `/ai-resources/skills/formatting-qc/SKILL.md`, `/ai-resources/skills/document-integration-qc/SKILL.md`, `output/{part}/style-reference.md`, `output/{part}/architecture.md` |
| `/produce-knowledge-file` | `.claude/commands/produce-knowledge-file.md` | `report/chapters/`, `report/{section}-architecture.md`, `reference/skills/knowledge-file-producer/SKILL.md` |
| `/produce-prose-draft` | `.claude/commands/produce-prose-draft.md` | `parts/part-2-service/` or `parts/part-3-strategy/`, `output/{part}/architecture.md`, `/ai-resources/skills/decision-to-prose-writer/SKILL.md`, `/ai-resources/skills/chapter-prose-reviewer/SKILL.md`, `/ai-resources/skills/prose-compliance-qc/SKILL.md`, `/ai-resources/skills/ai-prose-decontamination/SKILL.md`, `context/prose-quality-standards.md`, `/ai-resources/style-references/*.md` |
| `/qc-pass` | `.claude/commands/qc-pass.md` | `qc-reviewer` agent |
| `/refinement-pass` | `.claude/commands/refinement-pass.md` | `refinement-reviewer` agent |
| `/review` | `.claude/commands/review.md` | `report/chapters/`, `report/architecture/{section}/{section}-architecture.md`, `report/style-reference/{section}/{section}-style-reference.md`, `analysis/section-directives/`, `execution/scarcity-register/`, `analysis/cluster-memos/`, `analysis/chapters/`, `/ai-resources/skills/chapter-review/SKILL.md`, `qc-gate` agent |
| `/run-analysis` | `.claude/commands/run-analysis.md` | `analysis/cluster-memos/`, `/ai-resources/skills/gap-assessment-gate/SKILL.md`, `/ai-resources/skills/section-directive-drafter/SKILL.md`, `/ai-resources/skills/analysis-pass-memo-review/SKILL.md`, `/ai-resources/skills/editorial-recommendations-generator/SKILL.md`, `/ai-resources/skills/editorial-recommendations-qc/SKILL.md`, `/ai-resources/prompts/supplementary-research/S0–S4 prompt files`, `logs/qc-log.md` |
| `/run-cluster` | `.claude/commands/run-cluster.md` | `execution/research-extracts/{section}/`, `/ai-resources/skills/cluster-analysis-pass/SKILL.md`, `/ai-resources/skills/cluster-memo-refiner/SKILL.md`, `logs/qc-log.md` |
| `/run-execution` | `.claude/commands/run-execution.md` | `preparation/answer-specs/`, `preparation/research-plans/`, `execution/manifest/`, `execution/research-prompts/`, `execution/raw-reports/`, `execution/research-extracts/`, `execution/extract-verification/`, `execution/supplementary/`, `execution/scarcity-register/`, `execution/checkpoints/`, multiple skills in `/ai-resources/skills/` |
| `/run-preparation` | `.claude/commands/run-preparation.md` | `preparation/task-plans/`, `preparation/research-plans/`, `preparation/answer-specs/`, `preparation/checkpoints/`, multiple skills in `/ai-resources/skills/`, `CLAUDE.md` |
| `/run-report` | `.claude/commands/run-report.md` | `analysis/chapters/`, `execution/scarcity-register/`, `analysis/section-directives/`, `analysis/cluster-memos/`, `execution/research-extracts/`, `analysis/editorial-review/`, `report/architecture/`, `report/chapters/`, `report/checkpoints/`, `report/style-reference/`, `logs/qc-log.md`, multiple skills in `/ai-resources/skills/` |
| `/run-synthesis` | `.claude/commands/run-synthesis.md` | `analysis/cluster-memos/`, `analysis/section-directives/`, `execution/scarcity-register/`, `analysis/chapters/`, `/ai-resources/skills/cluster-synthesis-drafter/SKILL.md`, `logs/qc-log.md` |
| `/status` | `.claude/commands/status.md` | Stage directories, `logs/qc-log.md`, `logs/session-notes.md` |
| `/update-claude-md` | `.claude/commands/update-claude-md.md` | `CLAUDE.md` |
| `/verify-chapter` | `.claude/commands/verify-chapter.md` | `report/chapters/`, `execution/research-extracts/`, `.claude/hooks/check-claim-ids.sh`, `reference/sops/` (fact verification prompt), `execution-agent`, `/ai-resources/skills/evidence-prose-fixer/SKILL.md`, `logs/decisions.md`, `report/checkpoints/`, `logs/qc-log.md` |
| `/workflow-status` | `.claude/commands/workflow-status.md` | `reference/stage-instructions.md`, `/ai-resources/skills/workflow-evaluator/SKILL.md`, `/ai-resources/skills/` directory listing, `verification-agent` |
| `/wrap-session` | `.claude/commands/wrap-session.md` | `logs/session-notes.md`, `logs/decisions.md`, `logs/innovation-registry.md`, `logs/scripts/check-archive.sh` |

Note: The following commands are listed in `shared-manifest.json` as "shared" (expected to arrive via auto-sync from `ai-resources/.claude/commands/`) but have local copies present: `/qc-pass`, `/refinement-pass`, `/note`, `/update-claude-md`. Commands listed as shared but with no local copy: `analyze-workflow`, `clarify`, `coach`, `refinement-deep`, `scope`, `triage`.

Section summary: 27 commands catalogued / no previous audit

---

### 1.2 Hooks

All hooks are defined in `.claude/settings.json`.

| Trigger | Hook | What It Does | Files Referenced |
|---------|------|-------------|-----------------|
| PreToolUse — Skill | `friction-log-auto.sh` | Auto-starts a friction log session when a command with `friction-log: true` frontmatter fires; deduplicates within 30-minute window | `logs/friction-log.md`, `.claude/commands/{skill}.md` |
| PreToolUse — Edit | inline `jq` command | Checks if the file being edited is in `report/chapters/` or `final/modules/`; if yes, emits a block decision with bright-line rule reminder | None (inline) |
| PostToolUse — Write | inline git auto-commit | For files in `preparation/`, `execution/`, `analysis/`, `report/`, attempts `git add + git commit` with stage-tagged message | None (inline) |
| PostToolUse — Write | `log-write-activity.sh` | Appends file write events to the active friction log session's Write Activity section | `logs/friction-log.md` |
| PostToolUse — Write | `detect-innovation.sh` | Detects writes to `.claude/commands/`, `.claude/agents/`, `.claude/hooks/`; appends entry to innovation registry | `logs/innovation-registry.md` |
| PostToolUse — Edit | `log-write-activity.sh` | Same as Write trigger | `logs/friction-log.md` |
| PostToolUse — Edit | `detect-innovation.sh` | Same as Write trigger | `logs/innovation-registry.md` |
| SessionStart | inline checkpoint loader | Reads most recent checkpoint file and emits section/stage context as `additionalContext` | Checkpoint files in `{stage}/checkpoints/` |
| SessionStart | `check-template-drift.sh` | Walks parent directories to find `ai-resources/.claude/hooks/check-template-drift.sh` and runs it | `ai-resources/.claude/hooks/check-template-drift.sh` |
| SessionStart | `auto-sync-shared.sh` | Walks parent directories to find `ai-resources/.claude/hooks/auto-sync-shared.sh` and runs it | `ai-resources/.claude/hooks/auto-sync-shared.sh` |
| SessionStart | `check-archive.sh` | Runs log archive check; emits system message if files exceed 1.5x threshold | `logs/scripts/check-archive.sh` |
| Stop | inline checkpoint reminder | Checks for checkpoint files written in last 120 minutes; emits reminder if none found | Checkpoint files |
| Stop | inline wrap-session reminder | Checks `logs/session-notes.md` for today's date; emits reminder if session not wrapped | `logs/session-notes.md` |
| UserPromptSubmit | inline decision logger | Checks transcript for gate/bright-line keywords; appends operator input to `logs/decisions.md` | `logs/decisions.md` |

Section summary: 14 hook entries catalogued across 5 trigger types / no previous audit

---

### 1.3 Template Files

| File Path | Used By | Last Commit Date |
|-----------|---------|-----------------|
| `CLAUDE.md` | Deployed as project CLAUDE.md after placeholder substitution per SETUP.md | 2026-04-21 |
| `reference/stage-instructions.md` | `/run-preparation`, `/run-execution`, `/run-cluster`, `/run-analysis`, `/run-synthesis`, `/run-report`, `/workflow-status`, `/audit-structure`; loaded via `@reference` | 2026-04-09 |
| `reference/file-conventions.md` | `/audit-structure`; loaded via `@reference` in deployed projects | 2026-04-03 |
| `reference/quality-standards.md` | Referenced contextually by pipeline commands | 2026-04-09 |
| `reference/style-guide.md` | Default starting point for `output/{part}/style-reference.md` in deployed projects | 2026-04-03 |
| `SETUP.md` | Operator setup guide; not loaded at runtime | 2026-04-25 |

Note: All six files contain `{{PLACEHOLDER}}` markers. `CLAUDE.md`, `reference/stage-instructions.md`, `reference/file-conventions.md`, `reference/quality-standards.md`, and `reference/style-guide.md` are intentional placeholder-bearing templates. `SETUP.md` references placeholders as documentation of what to fill in.

Section summary: 6 template files catalogued / no previous audit

---

### 1.4 Scripts

| File Path | What It Does | What Calls It |
|-----------|-------------|--------------|
| `.claude/hooks/check-claim-ids.sh` | PostToolUse script; counts `[CITATION NEEDED]` tags in pipeline artifact files; emits warnings to stderr (non-blocking) | Called directly by `/verify-chapter` (Step 1b) via `echo '...' | bash "$CLAUDE_PROJECT_DIR/.claude/hooks/check-claim-ids.sh"` |
| `.claude/hooks/detect-innovation.sh` | PostToolUse script; detects writes to `.claude/` subdirectories; appends to `logs/innovation-registry.md` | SessionSettings.json PostToolUse Write/Edit hooks |
| `.claude/hooks/friction-log-auto.sh` | PreToolUse script; auto-starts friction log session for friction-log-enabled commands | settings.json PreToolUse Skill hook |
| `.claude/hooks/log-write-activity.sh` | PostToolUse script; appends file write events to friction log | settings.json PostToolUse Write/Edit hooks |
| `logs/scripts/check-archive.sh` | Log archive manager; reads `session-notes.md`, `decisions.md`, `friction-log.md`; archives entries exceeding threshold via `split-log.sh` | settings.json SessionStart hook, `/wrap-session` Step 7 |
| `logs/scripts/split-log.sh` | Splits append-only log files at `## ` headers; moves older entries to archive file | Called by `check-archive.sh` |

Section summary: 6 scripts catalogued / no previous audit

---

### 1.5 Skills

The research-workflow template contains 2 local skill directories under `reference/skills/`:

| Skill | Has SKILL.md |
|-------|-------------|
| `reference/skills/knowledge-file-producer/` | Yes |
| `reference/skills/report-compliance-qc/` | Yes |

Both have `SKILL.md` files. All other skills used by this workflow are expected to reside in `ai-resources/skills/` and be symlinked into `reference/skills/` via the setup procedure (SETUP.md Step 6). No skills are missing their SKILL.md within AUDIT_ROOT.

Section summary: 2 local skills catalogued, both have SKILL.md / no previous audit

---

### 1.6 Uncategorized Items

| File | Category Assignment |
|------|---------------------|
| `.claude/settings.json` | Settings file |
| `.claude/shared-manifest.json` | Workflow infrastructure (declares which commands/agents are local vs. shared for auto-sync) |
| `.gitignore` | Standard git file (contains only `.DS_Store`) |
| `logs/innovation-registry.md` | Log file (empty table; header only) |
| `reference/sops/research-executor-gpt.md` | SOP document for Research Execution CustomGPT |
| `reference/sops/evidence-pack-compressor-gpt.md` | SOP document for Evidence Pack Compressor CustomGPT |

All 30 `.gitkeep` files in empty stage directories are expected scaffolding.

Section summary: 6 uncategorized items catalogued / no previous audit

---

### 1.7 Symlinks

No symlinks found anywhere in the research-workflow directory tree (confirmed via `find ... -type l`).

Section summary: 0 symlinks / no previous audit

---

## Section 2: CLAUDE.md Health

### 2.1 CLAUDE.md Size and Sections

128 lines. 16 distinct sections.

Section headings:
1. `## Project Context`
2. `## Operator Profile`
3. `## Workflow Overview`
4. `## Skill Dependency Chain`
5. `## Workflow Status Command`
6. `## Utility Commands`
7. `## Cross-Model Rules`
8. `## Autonomy Rules`
9. `## Context Isolation Rules`
10. `## Friction Logging`
11. `## Citation Conversion Rule`
12. `## Bright-Line Rule (All Fix Steps)`
13. `## Input File Handling`
14. `## File Verification and Git Commits`
15. `## Commit Rules`
16. `## Compaction`
17. `## Session Boundaries`

Note: There is also a title line `# {{PROJECT_TITLE}}` (the H1 heading).

Section summary: 0 issues flagged / no previous audit

---

### 2.2 Dead References in CLAUDE.md

| Reference | Status |
|-----------|--------|
| `@reference/stage-instructions.md` (line 11) | File exists at `reference/stage-instructions.md` — valid |
| `workflow-evaluator` skill (line 38) | Exists at `/ai-resources/skills/workflow-evaluator/SKILL.md` — valid when resolved against workspace root |
| `reports/repo-health-report.md` (line 42, `/audit-repo` description) | No `reports/` directory in template. Directory is not created by template setup. Exists as a runtime artifact in deployed projects. No git history item — not a renamed or moved file. |
| `ai-resources/skills/` (line 38) | Valid path when workspace root is the parent |

Dead reference found: `reports/repo-health-report.md` mentioned in the `/audit-repo` description (line 42) — the `reports/` directory is not part of the template's scaffolded directory structure and is not mentioned in SETUP.md or file-conventions.md.

Section summary: 1 issue flagged / no previous audit

---

### 2.3 Contradictions in CLAUDE.md

None found — checked all 16 sections for conflicting directives. The `## Autonomy Rules` section (pause when `[Operator]` tagged) and `## Bright-Line Rule` section (pause before modifying report prose) are additive, not contradictory.

Section summary: 0 issues flagged / no previous audit

---

### 2.4 Convention Violations

| Convention Defined | Files That Violate It |
|-------------------|----------------------|
| `## Commit Rules` (line 109): "Do not run `git status`, `git diff`, or `git status --short` as pre-commit checks" | None found in commands within AUDIT_ROOT — checked all 27 command files for git status/diff calls |
| `## Context Isolation Rules`: "Sub-agents receive content from the main agent, not file paths" | The exception for large reference files is correctly stated. No violation found in commands read during this audit |

None found — checked all stated conventions against actual command files.

Section summary: 0 issues flagged / no previous audit

---

### 2.5 Partially-Present Features

| Feature | What Exists | What Is Missing |
|---------|-------------|----------------|
| `/verify-chapter` confidentiality check (CLAUDE.md line 8 of verify-chapter.md) | The command exists and references "Confidentiality Boundaries" in CLAUDE.md | CLAUDE.md template contains no "Confidentiality Boundaries" section. The section must be added by operators during project setup; SETUP.md does not mention it. |
| `/audit-repo` health report output | Command exists and references `reports/repo-health-report.md` | No `reports/` directory in template; not mentioned in SETUP.md setup steps. |

Section summary: 2 issues flagged / no previous audit

---

### 2.6 Task-Type-Specific Content in CLAUDE.md

The workspace CLAUDE.md "CLAUDE.md Scoping" rule states that skill methodology, workflow methodology, and single-artifact-type conventions belong in SKILL.md or workflow reference docs rather than in CLAUDE.md.

| Section | Line Count | Task Type |
|---------|-----------|-----------|
| `## Bright-Line Rule (All Fix Steps)` | 11 lines | Workflow methodology (applies to specific fix steps: 4.2, 5.2, 5.7, `/verify-chapter`). The same rule is also stated in `reference/quality-standards.md`. |
| `## Citation Conversion Rule` | 4 lines | Workflow methodology (bibliography rule for cited chapters). Not present in `reference/stage-instructions.md` or `reference/quality-standards.md`. |
| `## Context Isolation Rules` | 8 lines | Workflow execution methodology (sub-agent content passing rules). |

Section summary: 3 sections flagged as task-type-specific methodology / no previous audit

---

## Section 3: Dependency References

### 3.1 Command File References

| Slash Command | Referenced File | File Exists |
|--------------|----------------|-------------|
| `/audit-repo` | `reference/skills/repo-health-analyzer/agents/` (7 files) | N — `repo-health-analyzer` is not in the template's local `reference/skills/`; only 2 skills are local. Requires symlink setup per SETUP.md Step 6. After setup: `/ai-resources/skills/repo-health-analyzer/agents/` directory exists (Y). |
| `/audit-structure` | `reference/file-conventions.md` | Y |
| `/audit-structure` | `reference/stage-instructions.md` | Y |
| `/create-context-pack` | `/ai-resources/skills/context-pack-builder/SKILL.md` | Y (in ai-resources) |
| `/inject-dependency` | `logs/session-notes.md` | N (runtime artifact, created at first use) |
| `/produce-architecture` | `parts/part-2-service/` | N (not in template; project-specific directory) |
| `/produce-architecture` | `parts/part-3-strategy/` | N (not in template; project-specific directory) |
| `/produce-architecture` | `context/project-brief.md` | N (not in template; project-specific file) |
| `/produce-architecture` | `context/content-architecture.md` | N (not in template; project-specific file) |
| `/produce-architecture` | `/ai-resources/skills/research-structure-creator/SKILL.md` | Y |
| `/produce-architecture` | `/ai-resources/skills/architecture-qc/SKILL.md` | Y |
| `/produce-formatting` | `/ai-resources/skills/prose-formatter/SKILL.md` | Y |
| `/produce-formatting` | `/ai-resources/skills/h3-title-pass/SKILL.md` | Y |
| `/produce-formatting` | `/ai-resources/skills/formatting-qc/SKILL.md` | Y |
| `/produce-formatting` | `/ai-resources/skills/document-integration-qc/SKILL.md` | Y |
| `/produce-knowledge-file` | `report/{section}-architecture.md` | N — path inconsistency: canonical path per file-conventions.md is `report/architecture/{section}/{section}-architecture.md` |
| `/produce-knowledge-file` | `reference/skills/knowledge-file-producer/SKILL.md` | Y |
| `/produce-prose-draft` | `context/prose-quality-standards.md` | N (not in template; project-specific file) |
| `/produce-prose-draft` | `/ai-resources/skills/decision-to-prose-writer/SKILL.md` | Y |
| `/produce-prose-draft` | `/ai-resources/skills/chapter-prose-reviewer/SKILL.md` | Y |
| `/produce-prose-draft` | `/ai-resources/skills/prose-compliance-qc/SKILL.md` | Y |
| `/produce-prose-draft` | `/ai-resources/skills/ai-prose-decontamination/SKILL.md` | Y |
| `/qc-pass` | `qc-reviewer` agent (shared, via auto-sync) | Y (exists in ai-resources) |
| `/refinement-pass` | `refinement-reviewer` agent (shared, via auto-sync) | Y (exists in ai-resources) |
| `/review` | `/ai-resources/skills/chapter-review/SKILL.md` | Y |
| `/run-analysis` | `/ai-resources/prompts/supplementary-research/S0–S4 prompt files` | Y (5 files exist at `/ai-resources/prompts/supplementary-research/`) |
| `/run-cluster` | `/ai-resources/skills/cluster-analysis-pass/SKILL.md` | Y |
| `/run-cluster` | `/ai-resources/skills/cluster-memo-refiner/SKILL.md` | Y |
| `/run-execution` | `/ai-resources/skills/answer-spec-qc/SKILL.md` | Y |
| `/run-execution` | `/ai-resources/skills/execution-manifest-creator/SKILL.md` | Y |
| `/run-execution` | `/ai-resources/skills/research-prompt-creator/SKILL.md` | Y |
| `/run-execution` | `/ai-resources/skills/research-prompt-qc/SKILL.md` | Y |
| `/run-execution` | `/ai-resources/skills/research-extract-creator/SKILL.md` | Y |
| `/run-execution` | `/ai-resources/skills/research-extract-verifier/SKILL.md` | Y |
| `/run-execution` | `/ai-resources/skills/supplementary-query-brief-drafter/SKILL.md` | Y |
| `/run-execution` | `/ai-resources/skills/supplementary-research-qc/SKILL.md` | Y |
| `/run-execution` | `/ai-resources/skills/supplementary-evidence-merger/SKILL.md` | Y |
| `/run-preparation` | `/ai-resources/skills/task-plan-creator/SKILL.md` | Y |
| `/run-preparation` | `/ai-resources/skills/research-plan-creator/SKILL.md` | Y |
| `/run-preparation` | `/ai-resources/skills/answer-spec-generator/SKILL.md` | Y |
| `/run-preparation` | `/ai-resources/skills/answer-spec-qc/SKILL.md` | Y |
| `/run-report` | `/ai-resources/skills/research-structure-creator/SKILL.md` | Y |
| `/run-report` | `/ai-resources/skills/architecture-qc/SKILL.md` | Y |
| `/run-report` | `/ai-resources/skills/evidence-to-report-writer/SKILL.md` | Y |
| `/run-report` | `/ai-resources/skills/chapter-prose-reviewer/SKILL.md` | Y |
| `/run-report` | `reference/skills/report-compliance-qc/SKILL.md` | Y |
| `/run-report` | `/ai-resources/skills/citation-converter/SKILL.md` | Y |
| `/run-synthesis` | `/ai-resources/skills/cluster-synthesis-drafter/SKILL.md` | Y |
| `/verify-chapter` | `.claude/hooks/check-claim-ids.sh` | Y |
| `/verify-chapter` | `reference/sops/` (fact verification prompt) | Partial — `reference/sops/` contains `research-executor-gpt.md` and `evidence-pack-compressor-gpt.md`. No file is explicitly named a "fact verification prompt." The command reads from `reference/sops/` without naming a specific file. |
| `/verify-chapter` | `/ai-resources/skills/evidence-prose-fixer/SKILL.md` | Y |
| `/verify-chapter` | `execution-agent` | Y (local agent) |
| `/workflow-status` | `reference/stage-instructions.md` | Y |
| `/workflow-status` | `/ai-resources/skills/workflow-evaluator/SKILL.md` | Y |
| `/workflow-status` | `verification-agent` | Y (local agent) |
| `/wrap-session` | `logs/scripts/check-archive.sh` | Y |

Section summary: 7 issues flagged (4 project-specific missing directories/files expected to be created at deploy time, 1 path inconsistency in produce-knowledge-file, 1 ambiguous sops reference, 1 repo-health-analyzer requires symlink setup) / no previous audit

---

### 3.2 Command Output Chains

| Output Command | Feeds Into |
|----------------|-----------|
| `/run-preparation` | Outputs Task Plan, Research Plan, Answer Specs → consumed by `/run-execution` |
| `/run-execution` | Outputs Research Extracts → consumed by `/run-cluster` |
| `/run-cluster` | Outputs Cluster Memos → consumed by `/run-analysis` |
| `/run-analysis` | Outputs Section Directives, Editorial Decisions → consumed by `/run-synthesis` |
| `/run-synthesis` | Outputs Chapter Drafts → consumed by `/run-report` |
| `/run-report` | Outputs Report Chapters (cited) → consumed by `/produce-knowledge-file` |
| `/produce-architecture` | Outputs architecture.md → consumed by `/produce-prose-draft` |
| `/produce-prose-draft` | Outputs prose draft → consumed by `/produce-formatting` |
| `/intake-reports` | Files raw reports → triggers `/run-execution` |
| `/inject-dependency` | Updates session prompts → used by `/run-execution` Stage 2.2a |
| `/prime` | Reads session state → orientation for any next command |
| `/review` | Outputs chapter review → informs fix steps within `/run-report` |
| `/verify-chapter` | Outputs fact verification → informs corrections within `/run-report` |
| `/wrap-session` | Writes session notes → read by `/prime` next session |
| `/improve` | Analyzes friction → proposes changes to commands/hooks/CLAUDE.md |

Section summary: 15 chains identified / no previous audit

---

### 3.3 Files Referenced by More Than One Command

| File | Referenced By |
|------|--------------|
| `reference/stage-instructions.md` | `/audit-structure`, `/workflow-status`, CLAUDE.md (@ reference), all run-* commands read it via CLAUDE.md context |
| `reference/file-conventions.md` | `/audit-structure`, CLAUDE.md (@ reference in deployed projects) |
| `execution/scarcity-register/{section}/{section}-scarcity-register.md` | `/run-cluster`, `/run-analysis`, `/run-synthesis`, `/run-report`, `/review` |
| `logs/qc-log.md` | `/run-cluster`, `/run-analysis`, `/run-synthesis`, `/run-report`, `/review`, `/verify-chapter` |
| `logs/session-notes.md` | `/prime`, `/status`, `/wrap-session`, SessionStart hook (checkpoint loader) |
| `logs/decisions.md` | CLAUDE.md Bright-Line Rule (write target), `/wrap-session`, UserPromptSubmit hook, `/verify-chapter` |
| `logs/friction-log.md` | `/friction-log`, `/note`, `/improve`, `friction-log-auto.sh`, `log-write-activity.sh` |
| `logs/innovation-registry.md` | `detect-innovation.sh`, `/wrap-session` |
| `analysis/cluster-memos/{section}/` | `/run-cluster`, `/run-analysis`, `/run-synthesis`, `/run-report` |
| `analysis/section-directives/{section}/` | `/run-analysis`, `/run-synthesis`, `/run-report`, `/review` |
| `report/architecture/{section}/{section}-architecture.md` | `/run-report`, `/review`, CLAUDE.md (@ reference in deployed projects) |
| `/ai-resources/skills/answer-spec-qc/SKILL.md` | `/run-execution`, `/run-preparation` |
| `/ai-resources/skills/chapter-prose-reviewer/SKILL.md` | `/run-report`, `/produce-prose-draft` |
| `CLAUDE.md` | All commands (always loaded), `/update-claude-md`, `/run-preparation` (CLAUDE.md update step) |

Section summary: 14 multi-referenced files identified / no previous audit

---

### 3.4 Files Ranked by Downstream References

| Rank | File | Reference Count | Referenced By |
|------|------|----------------|--------------|
| 1 | `CLAUDE.md` | All 27 commands + 14 hooks | Every session, all commands |
| 2 | `reference/stage-instructions.md` | ~8 | `/audit-structure`, `/workflow-status`, all run-* pipeline commands, CLAUDE.md context |
| 3 | `logs/qc-log.md` | 6 | `/run-cluster`, `/run-analysis`, `/run-synthesis`, `/run-report`, `/review`, `/verify-chapter` |
| 4 | `execution/scarcity-register/{section}/...` | 5 | `/run-cluster`, `/run-analysis`, `/run-synthesis`, `/run-report`, `/review` |
| 5 | `analysis/cluster-memos/{section}/` | 4 | `/run-cluster`, `/run-analysis`, `/run-synthesis`, `/run-report` |
| 6 | `analysis/section-directives/{section}/` | 4 | `/run-analysis`, `/run-synthesis`, `/run-report`, `/review` |
| 7 | `logs/session-notes.md` | 4 | `/prime`, `/status`, `/wrap-session`, SessionStart hook |
| 8 | `logs/friction-log.md` | 5 | `/friction-log`, `/note`, `/improve`, `friction-log-auto.sh`, `log-write-activity.sh` |
| 9 | `report/architecture/{section}/...` | 3 | `/run-report`, `/review`, `/produce-formatting` |
| 10 | `logs/decisions.md` | 4 | Bright-Line Rule, `/wrap-session`, UserPromptSubmit hook, `/verify-chapter` |

Section summary: 0 issues flagged / no previous audit

---

### 3.5 Symlink Coverage Check

No symlinks exist in `.claude/commands/` or `.claude/agents/` within AUDIT_ROOT. This check is not applicable.

Section summary: N/A — no symlinks present / no previous audit

---

### 3.6 Projects Referencing ai-resources Without Coverage

This question asks about projects or repos outside AUDIT_ROOT that reference ai-resources. The `settings.json` within AUDIT_ROOT lists `additionalDirectories: ["/Users/patrik.lindeberg/Claude Code/Axcion AI Repo"]`. The workspace root covers `ai-resources/` as an ancestor-path prefix match. Coverage is present for deployed projects that use this template's `settings.json`.

The one confirmed deployed project using this template (`projects/buy-side-service-plan/`) does not have a `"model"` declaration at the top level of its `.claude/settings.json` (confirmed: field is absent). This is outside AUDIT_ROOT but noted for cross-reference completeness as the questionnaire requires.

Section summary: 0 issues flagged within AUDIT_ROOT / no previous audit

---

## Section 4: Consistency Checks

### 4.1 Skill Structural Pattern

The 2 local skills both follow the standard SKILL.md structure (frontmatter with `name`, `description`; body with Role, Scope, Input, Output sections). No deviation detected.

Section summary: 0 issues flagged / no previous audit

---

### 4.2 Slash Command Definition Pattern

27 commands examined. Patterns:

- 7 commands have YAML frontmatter (`friction-log: true` marker): `produce-architecture`, `produce-formatting`, `produce-prose-draft`, `review`, `run-analysis`, `run-cluster`, `run-execution`, `run-preparation`, `run-report`, `run-synthesis`, `verify-chapter`. (11 total with frontmatter.)
- 16 commands have no frontmatter: `audit-repo`, `audit-structure`, `create-context-pack`, `friction-log`, `improve`, `inject-dependency`, `intake-reports`, `note`, `prime`, `produce-knowledge-file`, `qc-pass`, `refinement-pass`, `status`, `update-claude-md`, `workflow-status`, `wrap-session`.

No `model:` frontmatter declarations are present in any command file. The workspace CLAUDE.md states "Analytical commands declare `model: opus` in YAML frontmatter. Orchestrator/dispatch commands and log-append commands declare `model: sonnet`." No commands in this template declare model in frontmatter. This is a systematic absence across all 27 commands.

Section summary: 1 systematic pattern absence flagged (no model: declarations in any command frontmatter) / no previous audit

---

### 4.3 Skill Template Comparison

N/A — No skill creation template file exists. Skills are created via `/create-skill` which references `ai-resources/skills/ai-resource-builder/SKILL.md` for format standards. The 2 local skills (`knowledge-file-producer`, `report-compliance-qc`) both predate any template modifications (last commit 2026-04-03) and conform to the standard SKILL.md format pattern.

---

### 4.4 Naming Convention Inconsistencies

| Item | Convention | Actual | Assessment |
|------|-----------|--------|------------|
| `produce-architecture`, `produce-prose-draft`, `produce-formatting` commands | Not listed in `shared-manifest.json` | Present in `.claude/commands/` | 3 commands are absent from shared-manifest (neither local nor shared classification) |
| `usage-analysis` | Listed in `shared-manifest.json` as "local" | File does not exist in `.claude/commands/` | Missing file for manifest-declared local command |
| `run-cluster` output path for cluster memos | `file-conventions.md` requires `analysis/cluster-memos/{section}/{section}-cluster-NN-memo.md` | Command writes to `analysis/cluster-memos/cluster-$ARGUMENTS-memo.md` (no section prefix, no section subdirectory) | Path inconsistency between command and conventions |
| `produce-knowledge-file` architecture reference | `file-conventions.md` and `run-report.md` use `report/architecture/{section}/{section}-architecture.md` | `produce-knowledge-file` uses `report/{section}-architecture.md` | Path inconsistency |

Section summary: 4 inconsistencies flagged / no previous audit

---

### 4.5 Directory Structure Violations

The template defines a directory structure in `reference/file-conventions.md` and `reference/stage-instructions.md`. Comparing the template scaffold against that definition:

| Expected Directory | Present in Template |
|-------------------|-------------------|
| `preparation/task-plans/` | Y (.gitkeep) |
| `preparation/research-plans/` | Y (.gitkeep) |
| `preparation/answer-specs/` | Y (.gitkeep) |
| `preparation/checkpoints/` | Y (.gitkeep) |
| `execution/manifest/` | Y (.gitkeep) |
| `execution/research-prompts/` | Y (.gitkeep) |
| `execution/raw-reports/` | Y (.gitkeep) |
| `execution/research-extracts/` | Y (.gitkeep) |
| `execution/extract-verification/` | Y (.gitkeep) |
| `execution/supplementary/` | Y (.gitkeep) |
| `execution/scarcity-register/` | Y (.gitkeep) |
| `execution/checkpoints/` | Y (.gitkeep) |
| `analysis/cluster-memos/` | Y (.gitkeep) |
| `analysis/section-directives/` | Y (.gitkeep) |
| `analysis/gap-assessment/` | Y (.gitkeep) |
| `analysis/editorial-review/` | Y (.gitkeep) |
| `analysis/gap-supplementary/` | Y (.gitkeep) |
| `analysis/chapters/` | Y (.gitkeep) |
| `analysis/checkpoints/` | Y (.gitkeep) |
| `report/architecture/` | Y (.gitkeep) |
| `report/style-reference/` | Y (.gitkeep) |
| `report/chapters/` | Y (.gitkeep) |
| `report/checkpoints/` | Y (.gitkeep) |
| `report/enrichment/` | Y (.gitkeep) |
| `final/modules/` | Y (.gitkeep) |
| `reference/skills/` | Y |
| `reference/sops/` | Y |
| `reference/templates/` | Y (.gitkeep) |
| `reference/scoping-notes/` | Y (.gitkeep) |
| `logs/` | Y |
| `output/knowledge-files/` | Y (.gitkeep) |

Not present in template but referenced by 3 commands (`/produce-architecture`, `/produce-prose-draft`, `/produce-formatting`):
- `parts/part-2-service/`
- `parts/part-3-strategy/`
- `output/part-2-prose/`
- `output/part-3-prose/`

Not present in template but referenced by CLAUDE.md (`/audit-repo` description):
- `reports/`

Not present in template but referenced by `produce-prose-draft` and `produce-architecture`:
- `context/` (SETUP.md Step 7 marks it as Optional)

Section summary: 4 directory gaps flagged (parts/, output/part-N-prose/, reports/; context/ flagged as optional in SETUP.md but required by 2 commands) / no previous audit

---

### 4.6 Command Syntax and Path Validation

All 27 command files are valid markdown. Path resolution issues identified in Q3.1 above. Additional syntax observations:

- `/verify-chapter` Step 1b shows a bash command pattern using `echo '{"tool_input":{"file_path":"CHAPTER_PATH"}}' | bash "$CLAUDE_PROJECT_DIR/.claude/hooks/check-claim-ids.sh"`. The hook script reads `cat` from stdin and uses `jq -r '.tool_input.file_path // empty'` — matching the input format.
- The PreToolUse Edit hook in `settings.json` uses a complex inline shell pipeline with `jq` but does not reference an external script file.
- The PostToolUse Write auto-commit hook in `settings.json` uses an inline shell pipeline that performs `git add` and `git commit` inside a subshell.

Section summary: 0 syntax failures; 4 path resolution issues already captured in Q3.1 / no previous audit

---

### 4.7 Duplicate or Conflicting Command Names

No duplicate command names found. None of the 27 commands match known built-in Claude Code commands (`/clear`, `/compact`, `/model`, `/cost`, `/doctor`, `/permissions`, `/review`, `/vim`).

Note: `/review` matches a built-in Claude Code command name. The local `/review` command (Step 35 in the commands list) is a project-specific chapter review command. Claude Code built-in `/review` also exists. These may conflict depending on Claude Code version behavior.

Section summary: 1 potential name conflict flagged (`/review` matches a Claude Code built-in) / no previous audit

---

### 4.8 Agent Model Tier Compliance

| Agent File | Declared Model | Agent Tier Table Entry | Assessment |
|------------|---------------|----------------------|------------|
| `execution-agent.md` | `sonnet` | Table: `sonnet` (API-call dispatcher) | Match |
| `improvement-analyst.md` | `opus` | Table: `opus` (friction-pattern analysis) | Match |
| `qc-gate.md` | `sonnet` | Not in table (local to research-workflow, not in `ai-resources/.claude/agents/`) | Not in table; sonnet for structured QC evaluation is consistent with Sonnet-tier work type |
| `verification-agent.md` | `sonnet` | Not in table (local to research-workflow) | Not in table; sonnet for independent re-derivation verification is consistent with Sonnet-tier |

The agent tier table (`ai-resources/docs/agent-tier-table.md`) covers `ai-resources/.claude/agents/` only and does not list the 4 local agents in this template. No tier mismatch on the 2 table-covered agents. The 2 table-absent local agents (`qc-gate`, `verification-agent`) are not violations of the tier assignment rule; they are absent from the table which covers a different scope.

Section summary: 0 tier mismatches; 2 agents absent from tier table (out of scope for table) / no previous audit

---

### 4.9 Project Settings Baseline Check

No `projects/` directories exist within AUDIT_ROOT (the research-workflow template is not a project; it is a template). This check is N/A for AUDIT_ROOT.

N/A — no project directories under AUDIT_ROOT.

---

## Section 5: Context Load

### 5.1 Estimated Context at Session Start

When a session opens in a deployed research-workflow project:

| File | Approximate Lines |
|------|-----------------|
| Workspace CLAUDE.md (`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md`) | ~175 lines |
| ai-resources CLAUDE.md | ~120 lines |
| research-workflow CLAUDE.md (project CLAUDE.md, filled-in version) | 128 lines |
| SessionStart hook — checkpoint loader output (conditional, JSON) | ~3 lines |
| SessionStart hook — check-template-drift.sh output (conditional) | ~2–5 lines |
| SessionStart hook — auto-sync-shared.sh output (conditional) | ~2–5 lines |
| SessionStart hook — check-archive.sh output (conditional) | ~2 lines |

Estimated total: approximately 425–435 lines loaded at session start (excluding conditional hook outputs). The `@reference/stage-instructions.md` reference in CLAUDE.md line 11 is not auto-loaded at session start; it is loaded on demand when a command references it.

Section summary: ~430 lines estimated context load / no previous audit

---

### 5.2 CLAUDE.md Sections Not Referenced by Any Command or Operational Instruction

| Section | Approximate Lines | Assessment |
|---------|-----------------|-----------|
| `## Operator Profile` | 3 lines | Sets context for Claude about who the operator is; not referenced by any specific command. Functions as persistent framing. |
| `## Session Boundaries` | 2 lines | Advises `/clear` over dirty-context continuation; not referenced by any command but applies to operator behavior. |

All other sections are referenced by at least one command or hook.

Section summary: 2 sections not referenced by commands (both are behavioral framing, not dead weight) / no previous audit

---

### 5.3 CLAUDE.md Line Count at Last 5 Commits

| Date | Commit Hash | Message | Line Count |
|------|------------|---------|-----------|
| 2026-04-21 | a746f65 | update: produce-prose-draft + research-workflow CLAUDE.md — pass reference files by absolute path | 128 lines |
| 2026-04-18 | 9d3cecc | update: R13 closeout — move skill-chain from ai-resources/CLAUDE.md to research-workflow/CLAUDE.md | 127 lines |
| 2026-04-18 | 39c99bc | batch: ai-resources — canonical project templates (prevention session 2) | 118 lines |
| 2026-04-15 | 850e153 | Add Input File Handling rule to new-project and research-workflow templates | 105 lines |
| 2026-04-13 | 7a93b74 | update: CLAUDE.md — add explicit Commit Rules section | 93 lines |

Section summary: 0 issues flagged / no previous audit

---

## Section 6: Drift and Staleness

### 6.1 Files Not Modified in 90 Days But Still Referenced

90-day cutoff date: 2026-01-27 (90 days before 2026-04-27).

All files in AUDIT_ROOT were committed between 2026-04-03 and 2026-04-25. No file has a last commit date before 2026-01-27. None found — checked all 51 non-.gitkeep files against git log dates.

Section summary: 0 issues flagged / no previous audit

---

### 6.2 TODO, FIXME, PLACEHOLDER, and Similar Markers

| Item | Expected State | Actual State |
|------|---------------|-------------|
| `CLAUDE.md` lines 1, 5, 7, 9, 11, 13, 17 | Placeholders unfilled (template state) | `{{PROJECT_TITLE}}`, `{{PROJECT_DESCRIPTION}}`, `{{ANALYTICAL_LENS}}`, `{{CURRENT_SECTION}}`, `{{DOCUMENT_ARCHITECTURE}}`, `{{EVIDENCE_CALIBRATION}}`, `{{OPERATOR_NAME}}` present — intended template state |
| `reference/stage-instructions.md` lines 1, 7 | Placeholders unfilled (template state) | `{{PROJECT_TITLE}}` and `{{SECTION_SEQUENCE}}` present — intended template state |
| `reference/file-conventions.md` line 1 | Placeholder unfilled (template state) | `{{PROJECT_TITLE}}` present — intended template state |
| `reference/quality-standards.md` line 1 | Placeholder unfilled (template state) | `{{PROJECT_TITLE}}` present — intended template state |
| `reference/style-guide.md` line 1 | Placeholder unfilled (template state) | `{{PROJECT_TITLE}}` present — intended template state |
| `SETUP.md` | Placeholder documentation (not template markers) | `{{PLACEHOLDER}}` references are documentation/examples — not markers requiring substitution in SETUP.md itself |

All `{{PLACEHOLDER}}` markers are intentional template-state markers. No `TODO`, `FIXME`, or unintentional markers found.

Section summary: 0 issues flagged (all markers are intentional template placeholders) / no previous audit

---

### 6.3 Empty, Stub, or Boilerplate-Only Files

| File | Status |
|------|--------|
| `logs/innovation-registry.md` | 4 lines; contains header and empty table (`# Innovation Registry` + column headers). This is the expected template state — the table is populated at runtime by `detect-innovation.sh`. |
| 30 `.gitkeep` files | Expected scaffolding for empty directories. Not stub files in any problematic sense. |
| `reference/templates/` (directory with `.gitkeep`) | Empty template directory. No template files are provided. The SETUP.md and commands make no reference to populating `reference/templates/` with specific files. |

Section summary: 0 issues flagged / no previous audit

---

## Summary of All Findings

### Discrepancies

| # | Item | Expected State | Actual State |
|---|------|---------------|-------------|
| D1 | `run-cluster` cluster memo output path | `analysis/cluster-memos/{section}/{section}-cluster-NN-memo.md` (per file-conventions.md) | `analysis/cluster-memos/cluster-$ARGUMENTS-memo.md` (no section prefix, no section subdirectory) |
| D2 | `produce-knowledge-file` architecture reference path | `report/architecture/{section}/{section}-architecture.md` (per file-conventions.md and run-report.md) | `report/{section}-architecture.md` (no `architecture/` subdirectory) |
| D3 | `settings.json` model identifier | `"model": "claude-sonnet-4-6[1m]"` (per MEMORY entry for Sonnet 1M suffix) | `"model": "sonnet[1m]"` (bare identifier without model family prefix) |
| D4 | Command model declarations | Workspace CLAUDE.md requires analytical commands to declare `model: opus` and orchestrator commands `model: sonnet` in frontmatter | 0 of 27 commands declare a `model:` field in YAML frontmatter |

### Missing Items

| # | Item | Where Expected |
|---|------|---------------|
| M1 | `usage-analysis` command file | `.claude/commands/usage-analysis.md` (listed as "local" in `shared-manifest.json`) |
| M2 | `reports/` directory | Template scaffold (referenced by `/audit-repo` in CLAUDE.md and by the command itself) |
| M3 | "Confidentiality Boundaries" section | `CLAUDE.md` (referenced by `/verify-chapter` command) |
| M4 | Fact verification prompt file in `reference/sops/` | `/verify-chapter` Step 2.3 reads "fact verification prompt from `/reference/sops/`" — no file by that name exists; directory contains only `research-executor-gpt.md` and `evidence-pack-compressor-gpt.md` |
| M5 | `produce-architecture`, `produce-prose-draft`, `produce-formatting` in `shared-manifest.json` | `.claude/shared-manifest.json` (3 commands present in `.claude/commands/` but not catalogued in manifest) |

### Violations

| # | Item | Rule Violated |
|---|------|--------------|
| V1 | `## Bright-Line Rule`, `## Citation Conversion Rule`, `## Context Isolation Rules` sections in CLAUDE.md | Workspace CLAUDE.md "CLAUDE.md Scoping" rule: workflow-stage methodology belongs in workflow reference docs (stage-instructions.md or quality-standards.md), not in always-loaded CLAUDE.md |
| V2 | `/review` command name | Matches Claude Code built-in command name `/review` |

### Clean Checks

- All 34 skills referenced by commands in AUDIT_ROOT exist in `ai-resources/skills/` (100% skill reference integrity)
- All 5 supplementary research prompt files referenced by `/run-analysis` exist in `ai-resources/prompts/supplementary-research/`
- `check-template-drift.sh` and `auto-sync-shared.sh` referenced by SessionStart hooks both exist in `ai-resources/.claude/hooks/`
- All 4 local agent files have explicit `model:` frontmatter declarations
- `execution-agent` (sonnet) and `improvement-analyst` (opus) match their agent tier table entries
- No files older than 90 days within AUDIT_ROOT
- No broken symlinks (no symlinks exist)
- `additionalDirectories` in settings.json covers workspace root — ai-resources is accessible
- No TODO/FIXME markers; all `{{}}` markers are intentional template placeholders
- All hook scripts referenced by settings.json exist and are accessible
- `logs/scripts/check-archive.sh` and `logs/scripts/split-log.sh` both exist and are callable
- All SETUP.md required skills (except `research-question-batcher`) exist in `ai-resources/skills/`; `research-question-batcher` is listed in SETUP.md's required skills list but does not exist in `ai-resources/skills/` — this is a SETUP.md reference gap

Note on `research-question-batcher`: SETUP.md Step 6 lists it in the "Required skills (minimum set)" but no `research-question-batcher/` directory exists in `ai-resources/skills/`. All pipeline commands were checked — none reference this skill by name. It appears to be a stale entry in SETUP.md.

**Total findings: 11**
- Discrepancies: 4 (D1–D4)
- Missing items: 5 (M1–M5) + 1 SETUP.md stale skill reference
- Violations: 2 (V1–V2)
- Clean checks: 14 explicit checks passed
