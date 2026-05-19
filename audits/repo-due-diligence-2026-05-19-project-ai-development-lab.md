# Repo Due Diligence — 2026-05-19
Workspace: Axcion AI
Repo: projects/ai-development-lab
Scope: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab
Depth: full
Commit: 17b377f
Previous audit: None (first audit for this scope)

---

## Section 1: Structural Inventory

### 1.1 Directory Tree (2 levels deep from AUDIT_ROOT)

```
projects/ai-development-lab/
├── CLAUDE.md
├── .claude/
│   ├── agents/          (23 files: 1 local, 21 symlinks to ai-resources, 1 relative symlink)
│   ├── commands/        (58 files: 2 local, 55 symlinks to ai-resources, 1 relative symlink — note: system-owner is in agents)
│   ├── settings.json
│   └── shared-manifest.json
├── logs/
│   ├── decisions.md
│   ├── pipeline-log.md
│   └── session-notes.md
├── output/
│   ├── architecture-proposal-v1.md
│   ├── integration-test/
│   │   └── .gitkeep
│   └── memos/
│       └── .gitkeep
├── pipeline/
│   ├── architecture.md
│   ├── context-pack.md
│   ├── decisions.md
│   ├── implementation-log.md
│   ├── implementation-spec.md
│   ├── pipeline-state.md
│   ├── project-plan.md
│   ├── ref-extraction.md
│   ├── ref-grilling.md
│   ├── ref-memo-template.md
│   ├── ref-step7-brief.md
│   ├── repo-snapshot.md
│   ├── session-guide.md
│   ├── sources.md
│   ├── technical-spec.md
│   └── test-results.md
└── transcripts/
    └── .gitkeep
```

Total files (including hidden, excluding directories): 111 entries at full depth.
Placeholder files (empty .gitkeep): 3 — `output/integration-test/.gitkeep`, `output/memos/.gitkeep`, `transcripts/.gitkeep`.

Section summary: inventory complete / no delta (first audit)

---

### 1.2 Hooks Registered

Source: `.claude/settings.json` (no `.claude/settings.local.json` found in AUDIT_ROOT).

| Trigger | Type | Command | Timeout | Status Message |
|---------|------|---------|---------|----------------|
| SessionStart | command | Walk up from `$CLAUDE_PROJECT_DIR` to find `ai-resources/.claude/hooks/auto-sync-shared.sh`; execute if found | 10s | "Syncing shared commands from ai-resources..." |
| SessionStart | command | Walk up from `$CLAUDE_PROJECT_DIR` to find `ai-resources/.claude/hooks/check-permission-sanity.sh`; execute if found | 5s | "Permission sanity check..." |

Hook scripts live at (outside AUDIT_ROOT — not audited for content, only existence verified):
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/auto-sync-shared.sh` — exists, executable
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/check-permission-sanity.sh` — exists, executable

Section summary: 2 hooks catalogued / no delta

---

### 1.3 Commands Inventory

**Project-local commands (regular files):**

| File | Model | Description |
|------|-------|-------------|
| `analyze-transcript.md` | sonnet | Pipeline entry: validates transcript, runs extraction/grilling/analysis/memo compilation, two operator gates, appends pipeline-log |
| `produce-handoff.md` | sonnet | Composes seed-context.md from an approved Do-Now memo and prints instructions for Patrik to run /context-builder manually |

**Symlinked commands from ai-resources (55 symlinks):**

analyze-workflow.md, architecture-review.md, audit-claude-md.md, audit-critical-resources.md, audit-repo.md, clarify.md, cleanup-worktree.md, coach.md, consult.md, create-skill.md, deploy-kb.md, explain.md, fix-symlinks.md, friction-log.md, friday-act.md, friday-checkup.md, friday-journal.md, friday-so.md, graduate-resource.md, implementation-triage.md, improve-skill.md, improve.md, innovation-sweep.md, log-sweep.md, migrate-skill.md, monday-prep.md, note.md, open-items.md, permission-sweep.md, prime.md, produce-handoff.md (symlink — note: a regular-file produce-handoff.md also exists, so there is no actual duplicate; this symlink is not present), project-consultant.md, qc-pass.md, recommend.md, refinement-deep.md, refinement-pass.md, repo-dd.md, request-skill.md, resolve-improvement-log.md, resolve.md, risk-check.md, route-change.md, save-session.md, scope.md, session-guide.md, session-plan.md, session-start.md, so-monthly.md, summary.md, sync-workflow.md, systems-review.md, token-audit.md, triage.md, update-claude-md.md, usage-analysis.md, wrap-session.md

All 55 command symlinks resolve — targets exist in ai-resources.

Section summary: 57 command files total (2 local, 55 symlinked) / no delta

---

### 1.4 Agents Inventory

**Project-local agent (regular file):**

| File | Model | Description |
|------|-------|-------------|
| `ai-engineer.md` | opus | AI engineering best-practices evaluator: feasibility, 2026+ practice alignment, implementation shape (AI engineering terms only). Does NOT assess Axcíon repo fit or name component types. |

**Symlinked agents from ai-resources (21 symlinks, all absolute-path except system-owner):**

| File | Symlink Type | Resolved |
|------|-------------|---------|
| `claude-md-auditor.md` | absolute | yes |
| `collaboration-coach.md` | absolute | yes |
| `critical-resource-auditor.md` | absolute | yes |
| `dd-extract-agent.md` | absolute | yes |
| `dd-log-sweep-agent.md` | absolute | yes |
| `execution-agent.md` | absolute | yes |
| `findings-extractor.md` | absolute | yes |
| `improvement-analyst.md` | absolute | yes |
| `innovation-triage-auditor.md` | absolute | yes |
| `log-sweep-auditor.md` | absolute | yes |
| `permission-sweep-auditor.md` | absolute | yes |
| `qc-reviewer.md` | absolute | yes |
| `refinement-reviewer.md` | absolute | yes |
| `repo-dd-auditor.md` | absolute | yes |
| `risk-check-reviewer.md` | absolute | yes |
| `system-owner.md` | relative (`../../../../ai-resources/.claude/agents/system-owner.md`) | yes |
| `token-audit-auditor-mechanical.md` | absolute | yes |
| `token-audit-auditor.md` | absolute | yes |
| `triage-reviewer.md` | absolute | yes |
| `workflow-analysis-agent.md` | absolute | yes |
| `workflow-critique-agent.md` | absolute | yes |

All 22 agents (1 local + 21 symlinks) resolve successfully.

Section summary: 22 agent files catalogued / no delta

---

### 1.5 Skills Referenced

No `skills/` directory exists in AUDIT_ROOT. No SKILL.md files found. No skill symlinks or copies found in `.claude/` or elsewhere under AUDIT_ROOT.

None found — checked: full `find` of AUDIT_ROOT for files matching `*SKILL.md` and directories named `skills/`; no results.

Section summary: 0 skills / no delta

---

### 1.6 Workflow Templates

No workflow template files found under AUDIT_ROOT. The `pipeline/` directory contains reference docs (`ref-*.md`) and planning artifacts from the `/new-project` pipeline, not workflow templates in the ai-resources workflow-template sense.

None found — checked: all files in `.claude/` and `pipeline/` for workflow template structure (step-based YAML frontmatter, trigger definitions). None matched.

Section summary: 0 workflow templates / no delta

---

### 1.7 Symlinks

All symlinks in AUDIT_ROOT:

**Agents (22 total symlinks):**

| Source Path | Target Path | Resolved | Target Exists |
|-------------|-------------|----------|---------------|
| `.claude/agents/ai-engineer.md` | (regular file — not a symlink) | — | — |
| `.claude/agents/claude-md-auditor.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/claude-md-auditor.md` | yes | yes |
| `.claude/agents/collaboration-coach.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/collaboration-coach.md` | yes | yes |
| `.claude/agents/critical-resource-auditor.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/critical-resource-auditor.md` | yes | yes |
| `.claude/agents/dd-extract-agent.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/dd-extract-agent.md` | yes | yes |
| `.claude/agents/dd-log-sweep-agent.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/dd-log-sweep-agent.md` | yes | yes |
| `.claude/agents/execution-agent.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/execution-agent.md` | yes | yes |
| `.claude/agents/findings-extractor.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/findings-extractor.md` | yes | yes |
| `.claude/agents/improvement-analyst.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/improvement-analyst.md` | yes | yes |
| `.claude/agents/innovation-triage-auditor.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/innovation-triage-auditor.md` | yes | yes |
| `.claude/agents/log-sweep-auditor.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/log-sweep-auditor.md` | yes | yes |
| `.claude/agents/permission-sweep-auditor.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/permission-sweep-auditor.md` | yes | yes |
| `.claude/agents/qc-reviewer.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/qc-reviewer.md` | yes | yes |
| `.claude/agents/refinement-reviewer.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/refinement-reviewer.md` | yes | yes |
| `.claude/agents/repo-dd-auditor.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/repo-dd-auditor.md` | yes | yes |
| `.claude/agents/risk-check-reviewer.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/risk-check-reviewer.md` | yes | yes |
| `.claude/agents/system-owner.md` | `../../../../ai-resources/.claude/agents/system-owner.md` (relative) | yes | yes |
| `.claude/agents/token-audit-auditor-mechanical.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/token-audit-auditor-mechanical.md` | yes | yes |
| `.claude/agents/token-audit-auditor.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/token-audit-auditor.md` | yes | yes |
| `.claude/agents/triage-reviewer.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/triage-reviewer.md` | yes | yes |
| `.claude/agents/workflow-analysis-agent.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/workflow-analysis-agent.md` | yes | yes |
| `.claude/agents/workflow-critique-agent.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/workflow-critique-agent.md` | yes | yes |

**Commands (55 symlinks — all absolute-path):** All 55 command symlinks target `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/<name>.md`. All resolve. All targets exist.

**Observation — mixed symlink path styles:** 20 of 21 agent symlinks and all 55 command symlinks use absolute paths. The `system-owner.md` agent symlink uses a relative path (`../../../../ai-resources/.claude/agents/system-owner.md`). Both resolve correctly on the current machine. The architecture document (`output/architecture-proposal-v1.md` § 2.2) explicitly specifies the relative 4-level-up form for the system-owner symlink.

Section summary: 76 symlinks catalogued; all resolve; all targets exist; 1 relative-path symlink (system-owner) among 75 absolute-path symlinks / no delta

---

## Section 2: CLAUDE.md Health

### 2.1 Line Count and Token Estimate

`CLAUDE.md` line count: **101 lines**.
Approximate token estimate: ~750–850 tokens (markdown prose at ~7–8 words/line average).

Sections (9 headings):
1. `## Purpose`
2. `## Pipeline`
3. `## How to invoke`
4. `## Out of scope`
5. `## Reference docs`
6. `## Agent scope boundary`
7. `## Memo discipline`
8. `## Cross-project coupling notes`
9. `## Model selection`

Section summary: 1 item measured / no delta

---

### 2.2 Behavioral Rules Enumerated

All behavioral rules stated in `CLAUDE.md`:

1. The lab ingests external transcripts and runs them through a five-stage pipeline (Input → Extraction → Grilling → Analysis → Decision).
2. The lab does NOT execute implementation.
3. One transcript → one pipeline run → one decision memo.
4. Start a pipeline run with `/analyze-transcript transcripts/<filename>`.
5. Prepare handoff (after approval) with `/produce-handoff output/memos/<run-dir>/memo.md`.
6. Out of scope: executing implementation plans; rebuilding context-pack/plan/spec skills; modifying system-owner; building non-transcript input adapters in v1.
7. Reference docs to read before pipeline work: `pipeline/ref-extraction.md`, `pipeline/ref-grilling.md`, `pipeline/ref-memo-template.md`, `pipeline/ref-step7-brief.md`.
8. `output/architecture-proposal-v1.md` — read once during Phase 0 build; do not re-litigate.
9. `ai-engineer` does NOT assess Axcíon repo fit and does NOT name Axcíon component types.
10. `system-owner` does NOT assess AI engineering merit.
11. If agent scopes overlap in practice, surface to Patrik — do not silently arbitrate.
12. Memos are durable artifacts — once `memo.md` is written, do not edit it.
13. The `Relevancy` field is fixed text in v1 (verbatim text stated).
14. Memo total length target: ≤2 pages (~700 words).
15. Recommendation reasoning must cite verbatim the specific `system-owner` claim it rests on.
16. Memo Metadata records per-run token cost observed during system-owner Task dispatch.
17. Canonical ai-resources commands auto-sync into this project via SessionStart hook.
18. `shared-manifest.json` declares project-local files that must NOT be synced over.
19. `Write` permission to ai-resources/ is allowed — required for canonical commands.
20. Project-specific guards on `transcripts/` and `pipeline/` writes are retained.
21. No project default model. Select via `/model` per session.
22. `ai-engineer` agent declares `model: opus` in frontmatter — tier is fixed regardless of session model.

Section summary: 22 behavioral rules enumerated / no delta

---

### 2.3 Contradictions with Workspace Root CLAUDE.md

No contradictions found. Checked all nine CLAUDE.md sections against workspace root CLAUDE.md rules:

- **Model selection:** Project CLAUDE.md states "No project default. Select via `/model` per session." This is consistent with workspace root CLAUDE.md "Model Tier" rule prohibiting `model` declarations in settings.json and CLAUDE.md. The section explicitly labels itself "recommendations only" consistent with the workspace rule allowing a "Model Selection" section for recommended posture.
- **Skill library:** No skill creation or modification claimed in project CLAUDE.md.
- **Write discipline:** Project states `Write` to ai-resources is allowed — consistent with workspace "Cross-Model Rules" and "Skill Library" rule that edits to skills go to ai-resources directly.
- **CLAUDE.md Scoping:** Project CLAUDE.md contains only pipeline-specific operational rules, invocation procedures, and cross-project coupling notes. No skill methodology, workflow methodology, or verbatim workspace rule duplication detected.

None found — checked all 22 behavioral rules against workspace CLAUDE.md rules.

Section summary: 0 contradictions flagged / no delta

---

### 2.4 Dead References

| Reference in CLAUDE.md | Referenced Path | Exists |
|------------------------|----------------|--------|
| `pipeline/ref-extraction.md` | `pipeline/ref-extraction.md` | YES |
| `pipeline/ref-grilling.md` | `pipeline/ref-grilling.md` | YES |
| `pipeline/ref-memo-template.md` | `pipeline/ref-memo-template.md` | YES |
| `pipeline/ref-step7-brief.md` | `pipeline/ref-step7-brief.md` | YES |
| `output/architecture-proposal-v1.md` | `output/architecture-proposal-v1.md` | YES |
| `transcripts/` directory | `transcripts/` | YES (contains `.gitkeep`) |
| `output/memos/{date}-{slug}/memo.md` | `output/memos/` | YES (directory with `.gitkeep`) |
| `logs/pipeline-log.md` | `logs/pipeline-log.md` | YES |
| `.claude/settings.json` | `.claude/settings.json` | YES |
| `shared-manifest.json` | `.claude/shared-manifest.json` | YES |
| `.claude/agents/ai-engineer.md` | `.claude/agents/ai-engineer.md` | YES |
| `projects/project-planning/` (external) | `projects/project-planning/` | YES (workspace-level, outside AUDIT_ROOT) |
| `/context-builder`, `/plan-draft`, `/spec-draft` (external commands) | `projects/project-planning/.claude/commands/` | YES — all three exist |

**Cross-project reference integrity:** CLAUDE.md line 9–10 references `/context-builder`, `/plan-draft`, `/spec-draft` in `projects/project-planning/`. All three commands exist at `projects/project-planning/.claude/commands/context-builder.md`, `plan-draft.md`, `spec-draft.md`. These are outside AUDIT_ROOT — recorded as external references, verified accessible.

None found — checked all file path references in CLAUDE.md against filesystem.

Section summary: 0 dead references / no delta

---

### 2.5 Verbatim or Near-Verbatim Duplication of Workspace CLAUDE.md

No verbatim or near-verbatim duplication detected. The CLAUDE.md contains project-specific pipeline rules, operational procedures, and agent scope boundaries that are unique to this project. The workspace CLAUDE.md has no corresponding pipeline-description, memo-discipline, or agent-scope-boundary sections.

None found — checked all nine CLAUDE.md sections against workspace CLAUDE.md content.

Section summary: 0 duplication instances / no delta

---

### 2.6 Stale Sections

No stale sections found. All referenced files exist, all referenced workflow states exist (pipeline is in post-build operational phase), and all command references are valid.

**Observation — Phase 4.2 integration test not yet executed:** CLAUDE.md line 51 references `pipeline/ref-step7-brief.md` which states a "Phase 4.2 integration test checklist item" (re-verify `consult.md` Step 4 against Step 7d mirror before declaring v1 shippable). `pipeline/session-guide.md` confirms this check is pending as of session 1. The CLAUDE.md reference is not stale — the doc exists and the pending state is expected. The integration test has not been run.

None found — checked all referenced files and states.

Section summary: 0 stale sections / no delta

---

## Section 3: Dependency References

### 3.1 Commands and Referenced Files

**`/analyze-transcript` (`.claude/commands/analyze-transcript.md`):**

| Referenced File | Exists |
|----------------|--------|
| `pipeline/ref-extraction.md` | YES |
| `pipeline/ref-grilling.md` | YES |
| `pipeline/ref-memo-template.md` | YES |
| `pipeline/ref-step7-brief.md` | YES |
| `ai-resources/docs/repo-architecture.md` (read at Step 7b) | YES — 252 lines |
| `output/memos/{run}/extraction.md` (written by command) | NO — created at runtime; directory contains only `.gitkeep` |
| `output/memos/{run}/grilling.md` (written by command) | NO — created at runtime |
| `output/memos/{run}/analysis-ai-engineer.md` (written by command) | NO — created at runtime |
| `output/memos/{run}/analysis-system-owner.md` (written by command) | NO — created at runtime |
| `output/memos/{run}/memo.md` (written by command) | NO — created at runtime |
| `logs/pipeline-log.md` (appended at Step 10) | YES |
| `output/integration-test/findings.md` (lazily created at Step 6 on boundary violation) | NO — `.gitkeep` only; created lazily |
| `ai-resources/docs/repo-architecture.md` (external, read via additionalDirectories) | YES |
| agents dispatched: `ai-engineer` (Task), `system-owner` (Task) | YES (local file and symlink both resolve) |

All static file references exist. Runtime-created files are absent by design (no pipeline runs have been executed). `output/integration-test/findings.md` is absent — this is expected per spec ("lazily created" if a boundary violation occurs at Step 6).

**`/produce-handoff` (`.claude/commands/produce-handoff.md`):**

| Referenced File | Exists |
|----------------|--------|
| `logs/pipeline-log.md` | YES |
| `output/memos/<run>/memo.md` (input, provided at runtime) | NO — no runs executed yet |
| `output/memos/<run>/handoff/seed-context.md` (written by command) | NO — created at runtime |

All static file references exist. Runtime artifacts absent by design.

Section summary: 0 broken static references; all absent files are runtime-created / no delta

---

### 3.2 Command Chain Map

| Upstream | Output | Consumed By |
|----------|--------|-------------|
| `/analyze-transcript` | `output/memos/{run}/memo.md`, `logs/pipeline-log.md` | `/produce-handoff` (memo.md as input); Patrik manually |
| `/produce-handoff` | `output/memos/{run}/handoff/seed-context.md` | Patrik manually runs `/context-builder` in `projects/project-planning/` |

The chain is: transcript file → `/analyze-transcript` → `memo.md` → (Patrik approval) → `/produce-handoff` → `seed-context.md` → (Patrik manual step) → `/context-builder` in project-planning.

No programmatic cross-command invocation. CLAUDE.md line 63 explicitly states system-owner is dispatched via the `Task` tool from `/analyze-transcript` Step 7 — not via `/consult`.

Section summary: 1 command chain mapped / no delta

---

### 3.3 Files Referenced by More Than One Command/Hook/CLAUDE.md

| File | Referenced By |
|------|---------------|
| `pipeline/ref-extraction.md` | `/analyze-transcript` Step 3; CLAUDE.md § Reference docs |
| `pipeline/ref-grilling.md` | `/analyze-transcript` Steps 4 and 5; CLAUDE.md § Reference docs |
| `pipeline/ref-memo-template.md` | `/analyze-transcript` Step 8; CLAUDE.md § Reference docs |
| `pipeline/ref-step7-brief.md` | `/analyze-transcript` Step 7d (mirror-source note); CLAUDE.md § Reference docs |
| `logs/pipeline-log.md` | `/analyze-transcript` Step 10; `/produce-handoff` Step 2 and 6; CLAUDE.md § Pipeline item 5 |
| `.claude/agents/system-owner.md` | `/analyze-transcript` Step 7 (Task dispatch); CLAUDE.md § Agent scope boundary |
| `.claude/agents/ai-engineer.md` | `/analyze-transcript` Step 6 (Task dispatch); CLAUDE.md § Agent scope boundary |
| `ai-resources/docs/repo-architecture.md` | `/analyze-transcript` Step 7b; `output/architecture-proposal-v1.md` § 4.5 (baseline note) |
| `output/memos/{run}/memo.md` | `/analyze-transcript` Step 8 (writes); `/produce-handoff` Step 1 (reads) |
| `.claude/shared-manifest.json` | SessionStart `auto-sync-shared.sh` hook; CLAUDE.md § Cross-project coupling notes |

Section summary: 10 multiply-referenced files identified / no delta

---

### 3.4 Downstream Reference Ranking (Top 10)

| Rank | File | Reference Count | Referenced By |
|------|------|-----------------|---------------|
| 1 | `pipeline/ref-extraction.md` | 2 | `/analyze-transcript`, `CLAUDE.md` |
| 1 | `pipeline/ref-grilling.md` | 3 | `/analyze-transcript` (×2 steps), `CLAUDE.md` |
| 1 | `pipeline/ref-memo-template.md` | 2 | `/analyze-transcript`, `CLAUDE.md` |
| 1 | `pipeline/ref-step7-brief.md` | 2 | `/analyze-transcript`, `CLAUDE.md` |
| 2 | `logs/pipeline-log.md` | 3 | `/analyze-transcript`, `/produce-handoff` (×2), `CLAUDE.md` |
| 3 | `.claude/agents/system-owner.md` | 2 | `/analyze-transcript`, `CLAUDE.md` |
| 3 | `.claude/agents/ai-engineer.md` | 2 | `/analyze-transcript`, `CLAUDE.md` |
| 3 | `ai-resources/docs/repo-architecture.md` | 2 | `/analyze-transcript`, `output/architecture-proposal-v1.md` |
| 3 | `output/memos/{run}/memo.md` | 2 | `/analyze-transcript` (writes), `/produce-handoff` (reads) |
| 3 | `.claude/shared-manifest.json` | 2 | SessionStart hook, `CLAUDE.md` |

Note: with only two local commands and a focused pipeline, reference fan-out is low. The top-referenced item by step-count is `logs/pipeline-log.md` (4 total step-references across two commands plus CLAUDE.md). The pipeline reference docs are each referenced in exactly 2 places.

Section summary: top 10 ranked / no delta

---

### 3.5 Symlink Target Coverage in `permissions.additionalDirectories`

`permissions.additionalDirectories` in `.claude/settings.json` contains one entry:
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo`

All agent and command symlinks target paths under `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/`. The workspace root (`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo`) is a string-prefix ancestor of all symlink targets. All 76 symlinks are covered.

None found — all symlink targets are covered by the `additionalDirectories` entry.

Section summary: 0 uncovered symlinks / no delta

---

### 3.6 Projects Referencing ai-resources Without additionalDirectories Coverage

This project (`projects/ai-development-lab`) references ai-resources via:
- Command symlinks (55 symlinks to ai-resources/.claude/commands/)
- Agent symlinks (21 symlinks to ai-resources/.claude/agents/)
- SessionStart auto-sync hook reading ai-resources/.claude/hooks/
- `/analyze-transcript` Step 7b reading `ai-resources/docs/repo-architecture.md`

`additionalDirectories` entry `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo` covers all ai-resources paths (workspace root is parent of ai-resources/).

None found — checked all ai-resources references against additionalDirectories.

Section summary: 0 uncovered ai-resources references / no delta

---

## Section 4: Consistency Checks

### 4.1 Skills Structural Pattern

N/A — no skills exist in AUDIT_ROOT.

Section summary: 0 items / no delta

---

### 4.2 Slash Command Definition Pattern

Both local commands (`.claude/commands/analyze-transcript.md` and `.claude/commands/produce-handoff.md`) follow the same pattern:
- YAML frontmatter with `---` delimiters containing: `description:`, `model:`, `argument-hint:`
- Description line below frontmatter
- `Argument $ARGUMENTS = ...` specification line
- `---` separator
- Numbered step sections with `## Step N: ...` headings
- Error handling table at end (`analyze-transcript` only; `produce-handoff` uses a "Hard constraint" section instead)

Deviation: `/produce-handoff` has no error handling table (only a "## Hard constraint" section). `/analyze-transcript` has a full error handling matrix. This difference is structural — the two commands have different complexity levels (10 steps vs. 6 steps).

Section summary: 2 local commands checked; 1 structural difference in error handling format / no delta

---

### 4.3 Skills vs. Template Comparison

N/A — no skill creation template files exist. Skills are created via `/create-skill` which references ai-resource-builder/SKILL.md for format standards.

Section summary: N/A / no delta

---

### 4.4 Naming Convention Consistency

Within AUDIT_ROOT:
- Commands use kebab-case: `analyze-transcript.md`, `produce-handoff.md` — consistent with ai-resources convention.
- Agent uses kebab-case: `ai-engineer.md` — consistent.
- Reference docs use `ref-{topic}.md` pattern: `ref-extraction.md`, `ref-grilling.md`, `ref-memo-template.md`, `ref-step7-brief.md` — internally consistent.
- Run output directories use `{YYYY-MM-DD}-{idea_slug}` pattern per command spec.
- Log file: `pipeline-log.md` — consistent with project convention.

No naming convention inconsistencies found within AUDIT_ROOT.

Section summary: 0 naming inconsistencies / no delta

---

### 4.5 Directory Structure Pattern Violations

The architecture document (`output/architecture-proposal-v1.md` § 2.3) defines the expected directory scaffolding:
- `transcripts/.gitkeep` — present ✓
- `output/memos/.gitkeep` — present ✓
- `output/integration-test/` — present ✓
- `output/architecture-proposal-v1.md` — present ✓

**Finding:** `pipeline/decisions.md` and `pipeline/implementation-log.md` are not listed as project components in the architecture document component table (§ 2.1). These files were created as part of the `/new-project` build pipeline (Stage 3b decisions log, Stage 4 implementation log) and are planning artifacts rather than operational components. The architecture document component table lists 11 new files + 1 symlink; the actual project contains additional planning artifacts in `pipeline/`:

Files in `pipeline/` not in the architecture component list (C1–C11):
- `pipeline/architecture.md` — Stage 3b output (the architecture document itself)
- `pipeline/context-pack.md` — Stage 3a planning context
- `pipeline/decisions.md` — Stage 3b decisions log
- `pipeline/implementation-log.md` — Stage 4 build log
- `pipeline/implementation-spec.md` — Stage 3c implementation spec
- `pipeline/pipeline-state.md` — /new-project pipeline state tracker
- `pipeline/project-plan.md` — Stage 3a project plan
- `pipeline/repo-snapshot.md` — Stage 3a repo snapshot
- `pipeline/session-guide.md` — Stage 6 session guide
- `pipeline/sources.md` — Stage 3a sources
- `pipeline/technical-spec.md` — planning technical spec
- `pipeline/test-results.md` — Stage 5 test results

These 12 files are all `/new-project` pipeline planning artifacts. They are present per CLAUDE.md "Reference docs" section which lists only the four `ref-*.md` files as runtime operational references.

Section summary: 0 violations of operational directory structure; 12 `/new-project` planning artifacts present in `pipeline/` alongside the 4 operational reference docs / no delta

---

### 4.6 Command Definition Syntax and Path Resolution

| Command | YAML Frontmatter Valid | All Referenced Paths Resolve |
|---------|----------------------|------------------------------|
| `analyze-transcript.md` | YES — `description:`, `model: sonnet`, `argument-hint:` present | YES — all four `pipeline/ref-*.md` files exist; `ai-resources/docs/repo-architecture.md` exists; agents exist |
| `produce-handoff.md` | YES — `description:`, `model: sonnet`, `argument-hint:` present | YES — `logs/pipeline-log.md` exists; runtime-created paths are not static references |

Section summary: 0 syntax failures; 0 path resolution failures / no delta

---

### 4.7 Duplicate Command Names or Built-in Conflicts

No local commands share names with ai-resources symlinked commands. The two local commands (`analyze-transcript`, `produce-handoff`) are listed in `shared-manifest.json` as project-local and are excluded from auto-sync.

Checked `analyze-transcript` and `produce-handoff` against all 55 symlinked command names: no collision found. Neither name matches known Claude Code built-in commands.

None found — checked all local command names against symlinked command names and Claude Code built-in command set.

Section summary: 0 duplicates or built-in conflicts / no delta

---

### 4.8 Agent Model Tier vs. Agent Tier Table

`ai-resources/docs/agent-tier-table.md` lists all canonical ai-resources agents. The `ai-engineer` agent is project-local and **not listed in the agent tier table**.

| Agent | File Type | Declared Tier | Expected Tier per Table | Assessment |
|-------|-----------|--------------|------------------------|------------|
| `ai-engineer` | project-local (regular file) | `opus` (frontmatter line 4) | NOT IN TABLE | Missing from agent tier table |
| `system-owner` | symlink to ai-resources | `opus` (target frontmatter line 4) | `opus` per table | Match |

**Finding:** `ai-engineer.md` is a project-local agent not listed in `ai-resources/docs/agent-tier-table.md`. The agent tier table's "Project-local agent copies" section covers only `projects/nordic-pe-macro-landscape-H1-2026`. The `ai-engineer` agent in `projects/ai-development-lab` is absent from the table entirely. The agent's declared tier (opus) is consistent with the table's Opus criteria ("judgment work: QC, refinement, synthesis, triage, critique, architectural design, strategic evaluation") given its feasibility-evaluation role, but the entry is missing.

Section summary: 1 issue flagged (ai-engineer missing from agent tier table) / no delta

---

### 4.9 Settings.json vs. Canonical Baseline

**Canonical baseline** from `ai-resources/.claude/commands/new-project.md` `CANONICAL_PERMS` block (line 310):

```
deny: ["Bash(git push*)", "Bash(rm -rf *)", "Bash(sudo *)", "Read(archive/**)", "Read(**/*.archive.*)", "Read(**/deprecated/**)", "Read(**/old/**)"]
```

**Project `.claude/settings.json` deny entries:**
```
["Bash(git push*)", "Bash(rm -rf *)", "Bash(sudo *)", "Write(./transcripts/**)", "Edit(./transcripts/**)", "Write(./pipeline/**)", "Edit(./pipeline/**)" ]
```

**Missing canonical deny entries:**
- `Read(archive/**)` — absent
- `Read(**/*.archive.*)` — absent
- `Read(**/deprecated/**)` — absent
- `Read(**/old/**)` — absent

**Extra project-specific deny entries (not in canonical):**
- `Write(./transcripts/**)` — project-specific guard
- `Edit(./transcripts/**)` — project-specific guard
- `Write(./pipeline/**)` — project-specific guard
- `Edit(./pipeline/**)` — project-specific guard

**Canonical allow list** (from CANONICAL_PERMS): `["Bash(*)", "Read", "Edit", "Write", "MultiEdit", "Agent", "Skill", "TodoWrite", "Glob", "Grep", "WebFetch", "WebSearch", "NotebookEdit", "ToolSearch", "Edit(**/.claude/**)", "Write(**/.claude/**)", "Bash(rm *)"]`

**Project allow list:** `["Bash(*)", "Read", "Edit", "Write", "MultiEdit", "Agent", "Skill", "Task", "TodoWrite", "Glob", "Grep", "WebFetch", "WebSearch", "ToolSearch"]`

**Differences from canonical allow:**
- `Task` — in project, absent from canonical (addition)
- `NotebookEdit` — in canonical, absent from project
- `Edit(**/.claude/**)` — in canonical, absent from project
- `Write(**/.claude/**)` — in canonical, absent from project
- `Bash(rm *)` — in canonical, absent from project

**Model declaration:** No `"model"` field in `.claude/settings.json`. The canonical CANONICAL_PERMS block in `new-project.md` (line 310) also contains no `"model"` field. The workspace CLAUDE.md prohibits model declarations in settings.json. The questionnaire Q4.9 reference to `"model": "sonnet"` at line ~179 does not correspond to actual content in `new-project.md` at that line (line 179 is in the legacy pipeline-state migration section). No model declaration is present or required.

**Last commit touching `.claude/settings.json`:** 2026-05-19 (commit `7eb4ee9`)
**Last commit touching CANONICAL_PERMS block in `new-project.md`:** Not determinable — `new-project.md` has no git log output for the target repository's tracked history returned from this scope. The CANONICAL_PERMS block exists at line 310.

Section summary: 4 missing canonical deny entries; 1 addition (Task) and 4 absences vs. canonical allow entries / no delta

---

## Section 5: Context Load

### 5.1 Estimated Context at Session Start

| Source | Lines | Notes |
|--------|-------|-------|
| Workspace root `CLAUDE.md` | 164 | Auto-loaded by Claude Code for all sessions in this workspace |
| Project `CLAUDE.md` | 101 | Auto-loaded for all sessions in this project directory |
| SessionStart hook 1 (`auto-sync-shared.sh`) | 0 lines injected | Creates symlinks only; emits status message to hook output, not to context |
| SessionStart hook 2 (`check-permission-sanity.sh`) | 0 lines injected | Emits nudge if defaultMode missing; no context injection |
| **Total auto-loaded lines** | **265** | |

Approximate token estimate for CLAUDE.md pair: ~1,800–2,200 tokens combined (164 lines workspace + 101 lines project, mixed prose and structure).

No additional files are auto-loaded at session start. The hooks perform filesystem operations and may emit status messages but do not inject document content into the session context.

Section summary: 265 lines estimated context load / no delta

---

### 5.2 CLAUDE.md Sections Not Referenced by Any Command, Hook, or Agent

| Section | Line Range | Referenced By |
|---------|-----------|---------------|
| `## Purpose` | 3–13 | Not explicitly referenced by any command — serves as orientation for fresh sessions |
| `## Pipeline` | 15–31 | Referenced implicitly by `/analyze-transcript` (structure matches step numbering); CLAUDE.md is always-loaded so this orients every session |
| `## How to invoke` | 33–36 | Not referenced by any command — user-facing quick reference |
| `## Out of scope` | 38–44 | Not referenced by any command — behavioral constraint section |
| `## Reference docs` | 46–53 | Not referenced by any command — operator-facing read-map; individual files referenced by commands directly |
| `## Agent scope boundary` | 55–68 | Not directly referenced by any command file — behavioral constraint encoded here and in agent definitions |
| `## Memo discipline` | 70–81 | `/analyze-transcript` Step 8 references `pipeline/ref-memo-template.md` for memo schema; memo discipline rules here partially duplicate some memo template rules |
| `## Cross-project coupling notes` | 83–92 | Not referenced by commands — documentation for operator context |
| `## Model selection` | 94–101 | Not referenced by commands — operator guidance only |

Observation: All nine sections serve as session-orientation or behavioral-constraint content rather than command-referenced procedure. This is consistent with the workspace CLAUDE.md rule that project CLAUDE.md is "for cross-session project-specific rules only — content that applies to every turn."

The `## Memo discipline` section (lines 70–81) partially restates content also present in `pipeline/ref-memo-template.md`. Specifically: the Relevancy fixed text, the ≤700 word target, and the verbatim citation requirement appear in both places. This is partial duplication of methodology content across CLAUDE.md and a reference doc.

Section summary: 9 sections identified as not directly referenced by command files; 1 case of partial duplication between CLAUDE.md and pipeline/ref-memo-template.md / no delta

---

### 5.3 CLAUDE.md Line Count History (Last 5 Modifying Commits)

| Commit | Date | Lines | Summary |
|--------|------|-------|---------|
| `7eb4ee9` | 2026-05-19 | 101 | new: ai-development-lab project — full /new-project pipeline (stages 3a–6) |

Only one commit has modified `CLAUDE.md` (the creation commit). The project was created 2026-05-19. All files in the project share this creation date. No prior modification history exists.

Section summary: 1 commit in history / no delta

---

## Section 6: Drift and Staleness

### 6.1 Files Unreferenced or Stale (>90 Days)

All files in AUDIT_ROOT were created on 2026-05-19. Current date is 2026-05-19. No files are older than 90 days.

None found — all files created on audit date 2026-05-19; no staleness possible.

Section summary: 0 stale files / no delta

---

### 6.2 TODO / FIXME / PLACEHOLDER Markers

| File | Line | Marker | Content |
|------|------|--------|---------|
| `output/architecture-proposal-v1.md` | 5 | Unfilled date placeholder | `**Approval:** Approved by Patrik on YYYY-MM-DD` |

No `TODO`, `FIXME`, or `PLACEHOLDER` text found in any other file. The `YYYY-MM-DD` placeholder in `output/architecture-proposal-v1.md` line 5 was identified and logged in the Stage 5 test results (`pipeline/test-results.md` WARN-1) as a non-blocking finding: "Stage 4 is explicitly prohibited from auto-filling it and left it for Patrik to complete."

Section summary: 1 unfilled placeholder found (`output/architecture-proposal-v1.md` line 5) / no delta

---

### 6.3 Empty, Stub, or Boilerplate-Only Files

| File | State |
|------|-------|
| `output/memos/.gitkeep` | Empty (0 bytes) — intentional placeholder |
| `output/integration-test/.gitkeep` | Empty (0 bytes) — intentional placeholder |
| `transcripts/.gitkeep` | Empty (0 bytes) — intentional placeholder |
| `logs/pipeline-log.md` | 4 lines — header row only (no data rows); contains table header but no pipeline run entries |
| `logs/decisions.md` | 19 lines — template/schema stub only (canonical shape definition block, no actual decision entries) |

**`logs/pipeline-log.md`** (4 lines): Contains header comment and empty table. No pipeline runs have been executed.

**`logs/decisions.md`** (19 lines): Contains only the canonical decision entry shape definition, no actual decisions. All project decisions are recorded in `pipeline/decisions.md` (11 entries: D1–D10 and HC-1). The `logs/decisions.md` file describes itself as "Cross-session decisions log" but contains only the template — all decisions to date are in the pipeline planning artifact, not here.

Section summary: 3 empty .gitkeep files (intentional); 2 stub log files with no operational content yet; 1 discrepancy (project decisions are in pipeline/decisions.md, not logs/decisions.md) / no delta

---

## Findings Summary

| # | Section | Severity | Finding |
|---|---------|----------|---------|
| F-1 | 1.7 | LOW | `system-owner.md` agent symlink uses a relative path (`../../../../ai-resources/.claude/agents/system-owner.md`) while all 20 other auto-synced agent symlinks and all 55 command symlinks use absolute paths. The symlink resolves correctly. The architecture document explicitly specifies the relative form. |
| F-2 | 4.8 | MEDIUM | Project-local agent `ai-engineer.md` is absent from `ai-resources/docs/agent-tier-table.md`. The declared tier (`opus`) is substantively consistent with the table's Opus criteria, but no entry exists for this agent. |
| F-3 | 4.9 | MEDIUM | Four canonical deny entries are absent from `.claude/settings.json`: `Read(archive/**)`, `Read(**/*.archive.*)`, `Read(**/deprecated/**)`, `Read(**/old/**)`. The project has additional project-specific deny entries for `transcripts/**` and `pipeline/**` not in the canonical baseline. |
| F-4 | 4.9 | LOW | Four canonical allow entries absent from `.claude/settings.json`: `NotebookEdit`, `Edit(**/.claude/**)`, `Write(**/.claude/**)`, `Bash(rm *)`. One extra allow entry present: `Task` (required by `/analyze-transcript` Step 6 and Step 7 which dispatch agents via the Task tool). |
| F-5 | 5.2 | LOW | `## Memo discipline` section in `CLAUDE.md` (lines 70–81) partially duplicates content in `pipeline/ref-memo-template.md`: the Relevancy fixed text, the ≤700 word target, and the verbatim citation requirement appear in both locations. |
| F-6 | 6.2 | LOW | `output/architecture-proposal-v1.md` line 5 contains unfilled date placeholder `YYYY-MM-DD` in `**Approval:** Approved by Patrik on YYYY-MM-DD`. Documented as expected and non-blocking in Stage 5 test results. |
| F-7 | 6.3 | INFO | `logs/decisions.md` contains only a template stub (no entries). All 11 project decisions (D1–D10, HC-1) are recorded in `pipeline/decisions.md` rather than `logs/decisions.md`. |
| F-8 | 4.5 | INFO | `pipeline/` directory contains 12 `/new-project` build pipeline artifacts (architecture.md, context-pack.md, decisions.md, implementation-log.md, implementation-spec.md, pipeline-state.md, project-plan.md, repo-snapshot.md, session-guide.md, sources.md, technical-spec.md, test-results.md) alongside the 4 operational reference docs (`ref-*.md`). These are planning artifacts from the creation pipeline and are not referenced by operational commands. |
| F-9 | 3.1 | INFO | `output/integration-test/findings.md` does not exist. Per `/analyze-transcript` Step 6 spec, this file is created lazily only when an ai-engineer boundary violation (naming Axcíon component types) is detected. No pipeline runs have been executed; absence is expected. |
