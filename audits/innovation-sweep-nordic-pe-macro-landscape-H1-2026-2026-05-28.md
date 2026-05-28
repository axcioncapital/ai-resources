# Innovation Sweep — nordic-pe-macro-landscape-H1-2026 — 2026-05-28

## Summary

- Total items scanned: ~63 across 7 active categories (Cat 4 Skills and Cat 6 Scripts: no directory; Cat 7 Style references folded into Cat 5).
- **Graduate (new resource): 17**
- **Backport (local has improvements): 1**
- **Accept fork (project intentionally diverged): 9**
- **Keep local (project-specific): 13**
- **Already graduated (no action): 24**
- **Loose ends needing operator triage: 2**
- **Registry status:** found (15 active entries; statuses include `triaged:project-specific`, `triaged:graduate`, `triaged:already-canonical`, `graduated`). Read-only — sweep did not modify.

## Action checklist

**Phase 3 plan items confirmed (no new action — already on the roadmap):**
- [ ] FX-E1 — `Run /graduate-resource .claude/hooks/backup-session-plan.sh` (target: `ai-resources/.claude/hooks/`)
- [ ] FX-E2 — `Manually review settings.json PreToolUse[Edit] decision:block pattern → ai-resources/docs/permission-template.md`

**New Phase 3 candidates surfaced by this sweep — FX-D1-pattern symlink swap (7 commands):**
- [ ] `Run /graduate-resource .claude/commands/audit-structure.md`
- [ ] `Run /graduate-resource .claude/commands/inject-dependency.md`
- [ ] `Run /graduate-resource .claude/commands/produce-knowledge-file.md`
- [ ] `Run /graduate-resource .claude/commands/review-chapter.md`
- [ ] `Run /graduate-resource .claude/commands/run-preparation.md`
- [ ] `Run /graduate-resource .claude/commands/verify-chapter.md`
- [ ] `Run /graduate-resource .claude/commands/workflow-status.md`

**New graduation candidates (genuinely new generic resources):**
- [ ] `Run /graduate-resource .claude/commands/project-status.md` (generic stage-aware status reporter → research-workflow commands)
- [ ] `Run /graduate-resource .claude/agents/qc-gate.md` (generic QC-reviewer subagent → ai-resources agents)
- [ ] `Run /graduate-resource .claude/agents/verification-agent.md` (generic re-derivation subagent → ai-resources agents)
- [ ] `Run /graduate-resource .claude/hooks/check-claim-ids.sh` (citation-tag check → research-workflow hooks; tied to research-workflow paths)
- [ ] `Manually copy reference/sops/research-executor-generic-v2.md → ai-resources/workflows/research-workflow/reference/sops/` (generic research-executor SOP — generalized v2)
- [ ] `Manually section-edit lines 46–48 of project CLAUDE.md ("Review Presentation") into workspace CLAUDE.md` (generic QC-output presentation rule)
- [ ] `Manually section-edit lines 93–95 of project CLAUDE.md ("Session Boundaries") into workspace CLAUDE.md` (generic /clear discipline rule)
- [ ] `Manually section-edit lines 59–61 of project CLAUDE.md ("Command Conventions") into ai-resources canonical reference` (frontmatter-vs-Usage-line convention)
- [ ] `Manually backport diff at ai-resources/audits/working/diff-agent-execution-agent.md.diff → ai-resources/.claude/agents/execution-agent.md` (project version generalizes "Axcíon Research Workflow" → "research workflows" — small prose generalization worth backporting)

**Loose ends needing operator triage:**
- [ ] **`produce-architecture.md`** — inventory state vs CLAUDE.md state disagree (CLAUDE.md claims symlink, inventory shows non-symlink 9866-byte local file). Verify on-disk state before deciding action.
- [ ] **`reference/sops/fact-verification-prompt.md`** — DIVERGENT_WORKFLOW but no diff captured in this run; re-run a focused diff against canonical SOP to decide Backport vs Accept-fork.

## Findings by category

### Commands

| Item | Match status | Verdict | Rationale | Registry status |
|---|---|---|---|---|
| `audit-structure.md` | IDENTICAL_WORKFLOW | Graduate (symlink swap) | Byte-identical with canonical; FX-D1 pattern. | n/a |
| `create-context-pack.md` | DIVERGENT_WORKFLOW | Already graduated | FX-A6 standalone-consumer note already canonical; stale fork. | triaged:already-canonical |
| `inject-dependency.md` | IDENTICAL_WORKFLOW | Graduate (symlink swap) | Byte-identical; FX-D1 pattern. | n/a |
| `intake-reports.md` | DIVERGENT_WORKFLOW | Already graduated | FX-A1 `model:opus` already canonical; stale fork. | triaged:already-canonical |
| `produce-architecture.md` | NOT_IN_AI_RESOURCES | **Loose end** | CLAUDE.md says symlink, inventory says local 9866-byte file — state disagreement. | n/a |
| `produce-knowledge-file.md` | IDENTICAL_WORKFLOW | Graduate (symlink swap) | Byte-identical; FX-D1 pattern. | n/a |
| `project-status.md` | NOT_IN_AI_RESOURCES | Graduate (new) | Generic stage-aware status reporter; no project-specific terms. | n/a |
| `review-chapter.md` | IDENTICAL_WORKFLOW | Graduate (symlink swap) | Byte-identical; FX-D1 pattern. | n/a |
| `run-analysis.md` | DIVERGENT_WORKFLOW | Already graduated | Bundle 1 fail-safe gate-clearance already canonical; stale fork. | graduated |
| `run-cluster.md` | DIVERGENT_WORKFLOW | Already graduated | Bundle 1 Pass 3 entry-point framing already canonical; stale fork. | graduated |
| `run-execution.md` | DIVERGENT_WORKFLOW | Already graduated | Bundle 1 Pass 1+2 framing + Step 2.0b already canonical; stale fork. | graduated |
| `run-preparation.md` | IDENTICAL_WORKFLOW | Graduate (symlink swap) | Byte-identical; FX-D1 pattern. | n/a |
| `run-report.md` | DIVERGENT_WORKFLOW | Already graduated | Bundle 2a S-16 chapter-draft marker already canonical; stale fork. | triaged:already-canonical |
| `run-synthesis.md` | DIVERGENT_WORKFLOW | Already graduated | Bundle 1 fail-safe gate-clearance already canonical; stale fork. | graduated |
| `update-claude-md.md` | DIVERGENT_WORKSPACE | Accept fork | Diff is one leading blank line (cosmetic); not worth backport. | n/a |
| `verify-chapter.md` | IDENTICAL_WORKFLOW | Graduate (symlink swap) | Byte-identical; FX-D1 pattern. | n/a |
| `workflow-status.md` | IDENTICAL_WORKFLOW | Graduate (symlink swap) | Byte-identical; FX-D1 pattern. | n/a |
| `produce-formatting-v1-template.md.bak` | NOT_IN_AI_RESOURCES (.bak) | Keep local | Pre-FX-D1 fork archive; CLAUDE.md documents intentional retention. | n/a |
| `produce-prose-draft-v1-template.md.bak` | NOT_IN_AI_RESOURCES (.bak) | Keep local | Pre-FX-D1 fork archive; CLAUDE.md documents intentional retention. | n/a |

### Agents

| Item | Match status | Verdict | Rationale | Registry status |
|---|---|---|---|---|
| `execution-agent.md` | DIVERGENT_WORKSPACE | **Backport** | Project version generalizes "Axcíon Research Workflow" → "research workflows" + trailing newline. | n/a |
| `improvement-analyst.md` | DIVERGENT_WORKSPACE | Accept fork | Canonical is newer (has Recurrence Escalation Protocol + archive-handling extensions); project copy stale. | n/a |
| `qc-gate.md` | NOT_IN_AI_RESOURCES | Graduate (new) | Generic QC-reviewer subagent; criteria-routing table generic; no project-specific terms. | n/a |
| `verification-agent.md` | NOT_IN_AI_RESOURCES | Graduate (new) | Generic re-derivation subagent; one Axcíon mention easily genericized at graduation. | n/a |

### Hooks

| Item | Match status | Verdict | Rationale | Registry status |
|---|---|---|---|---|
| `auto-qc-nudge.sh` | IDENTICAL_WORKSPACE | Already graduated | Byte-identical with canonical. | n/a |
| `auto-resolve-nudge.sh` | IDENTICAL_WORKSPACE | Already graduated | Byte-identical. | n/a |
| `backup-session-plan.sh` | NOT_IN_AI_RESOURCES | Graduate (FX-E1) | Already named in Phase 3 plan Step 4 FX-E1 — confirmation, not a new candidate. | n/a |
| `check-claim-ids.sh` | NOT_IN_AI_RESOURCES | Graduate (new) | Citation-tag check; target = research-workflow hooks (tied to analysis/chapters paths + CITATION NEEDED tag). | n/a |
| `check-heavy-tool.sh` | IDENTICAL_WORKSPACE | Already graduated | Byte-identical. | n/a |
| `check-permission-sanity.sh` | IDENTICAL_WORKSPACE | Already graduated | Byte-identical. | n/a |
| `check-stop-reminders.sh` | IDENTICAL_WORKSPACE | Already graduated | Byte-identical. | n/a |
| `coach-reminder.sh` | IDENTICAL_WORKSPACE | Already graduated | Byte-identical. | n/a |
| `detect-innovation.sh` | IDENTICAL_WORKSPACE | Already graduated | Byte-identical. | n/a |
| `friction-log-auto.sh` | IDENTICAL_WORKSPACE | Already graduated | Byte-identical. | n/a |
| `friday-checkup-reminder.sh` | IDENTICAL_WORKSPACE | Already graduated | Byte-identical. | n/a |
| `improve-reminder.sh` | IDENTICAL_WORKSPACE | Already graduated | Byte-identical. | n/a |
| `log-write-activity.sh` | IDENTICAL_WORKSPACE | Already graduated | Byte-identical. | n/a |

### Skills

n/a — project has no `skills/` directory.

### Prompts & spec docs

| Item | Match status | Verdict | Rationale | Registry status |
|---|---|---|---|---|
| `reference/file-conventions.md` | DIVERGENT_WORKFLOW | Accept fork | Project instantiation of `{{PROJECT_TITLE}}` template; project-tunable. | n/a |
| `reference/known-limits.md` | NOT_IN_AI_RESOURCES | Accept fork | Project instantiation of canonical `known-limits.template.md` (FX-B5 forward-contract). | n/a |
| `reference/language-search-blocks.md` | NOT_IN_AI_RESOURCES | Accept fork | FX-B2 today created canonical template; this is per-project [sv,fi,no] instance. | n/a |
| `reference/quality-standards.md` | DIVERGENT_WORKFLOW | Accept fork | Project instantiation of canonical template; project-tunable evidence calibration. | n/a |
| `reference/source-class-hierarchy.md` | NOT_IN_AI_RESOURCES | Accept fork | Project instantiation of canonical FX-B5 template; Nordic-PE source taxonomy. | n/a |
| `reference/stage-5-paths.md` | NOT_IN_AI_RESOURCES | Accept fork | Project instantiation of canonical FX-B1 template; per-project path-config values. | n/a |
| `reference/stage-instructions.md` | DIVERGENT_WORKFLOW | Accept fork | Project pinned to pre-Bundle-1 shape per documented v6 decision; intentional divergence. | n/a |
| `reference/style-guide.md` | DIVERGENT_WORKFLOW | Accept fork | Project instantiation of canonical template with project voice. | n/a |
| `reference/skills/specifying-output-style/SKILL.md` | symlinked | Already graduated | Project consumes canonical via directory symlink. | n/a |
| `reference/sops/evidence-pack-compressor-gpt.md` | IDENTICAL_WORKFLOW | Already graduated | Byte-identical with canonical SOP. | n/a |
| `reference/sops/fact-verification-prompt.md` | DIVERGENT_WORKFLOW | **Loose end** | Diff not in this run's working set; re-run focused diff to decide. | n/a |
| `reference/sops/research-executor-gpt.md` | IDENTICAL_WORKFLOW | Already graduated | Byte-identical with canonical SOP. | n/a |
| `reference/sops/research-executor-generic-v2.md` | NOT_IN_AI_RESOURCES | Graduate (new) | Generic research-executor SOP (no Nordic-PE terms); generalized v2. Target: research-workflow SOPs. | n/a |

### Scripts

n/a — project has no `scripts/` directory.

### Style references

n/a — folded into Prompts & spec docs (Cat 5).

### CLAUDE.md sections

| Section header | Line range | Verdict | Rationale | Proposed target |
|---|---|---|---|---|
| Project Context | 3 | Keep local | Project mandate, scope, drivers. | keep-local |
| Project Config | 21 | Accept fork | FX-B7 canonical schema instance; project-tunable values. | keep-local |
| Operator Profile | 42 | Keep local | Names operator; project-level governance. | keep-local |
| Review Presentation | 46 | Graduate (new) | Generic QC-output rule (verdict + path, no inline prose); not in workspace. | workspace |
| Workflow Overview | 50 | Keep local | Pointer block specific to this project's `reference/` set. | keep-local |
| Command Conventions | 59 | Graduate (new) | Frontmatter-vs-Usage-line convention; complements Model Tier rule. | ai-resources |
| Cross-Model Rules | 63 | Already graduated | Workflow-overlay on workspace canonical; mostly redundant. | keep-local |
| Autonomy Rules | 69 | Already graduated | Workflow-execution overlay on workspace Autonomy Rules. | keep-local |
| Friction Logging | 79 | Keep local | Hook-attribution rule references specific project hooks. | keep-local |
| File Verification and Git Commits | 85 | Already graduated | Pointer mirror of workspace canonical. | keep-local |
| Compaction | 89 | Already graduated | Pointer + project-specific extension. | keep-local |
| Session Boundaries | 93 | Graduate (new) | Generic `/clear` discipline rule; not in workspace or ai-resources. | workspace |
| Stage 5 Polish Commands | 97 | Keep local | Project's Stage 5 symlink wiring, threshold override. | keep-local |
| Input File Handling | 107 | Already graduated | Verbatim mirror of workspace canonical (project CLAUDE.md states this). | keep-local |
| Commit Rules | 120 | Already graduated | Verbatim mirror of workspace canonical (project CLAUDE.md states this). | keep-local |

### Settings patterns

| Pattern | Verdict | Rationale | Proposed target |
|---|---|---|---|
| `PreToolUse[Edit]` `decision: block` bright-line guard (chapters + final/modules) | Graduate (FX-E2) | Already in Phase 3 plan Step 4 FX-E2. | `ai-resources/docs/permission-template.md` |
| `PostToolUse[Write]` auto-commit on pipeline-path writes | Keep local | Bespoke research-workflow pipeline shape. | keep-local |
| `UserPromptSubmit` GATE/bright-line/PAUSE keyword decision-logger | Graduate (new) | Generic operator-decision logging pattern. | `ai-resources/docs/permission-template.md` |
| `PostToolUse[Write]` 5-hook wiring taxonomy | Graduate (new) | Reusable taxonomy minus the project-specific entries. | ai-resources settings template |
| `permissions.allow/deny` archive/deprecated/old read-denies | Graduate (new) | Generic hygiene pattern. | `ai-resources/docs/permission-template.md` |
| `permissions.defaultMode: "bypassPermissions"` | Keep local | Project-level autonomy posture. | keep-local |
| `permissions.additionalDirectories` (workspace path) | Keep local | Hard-coded workspace path; per-project. | keep-local |

### Divergent forks (Category M)

| Item | Verdict | Diff path |
|---|---|---|
| `execution-agent.md` | Backport | `ai-resources/audits/working/diff-agent-execution-agent.md.diff` |
| Other DIVERGENT_WORKFLOW commands | Already-graduated (stale forks; no diff retained) | (working diffs available for inspection) |

## Registry context (read-only)

- Items already marked `graduated` in registry: 6 — Bundle 1 commands (run-sufficiency, run-analysis, run-synthesis, run-execution, run-cluster) + auto-sync-shared.sh hook. **All excluded from action checklist.**
- Items marked `triaged:project-specific`: 4 — wrap-session (×2 paths), produce-prose-draft, produce-formatting. **Excluded from action checklist** (project-specific by registry-recorded triage).
- Items marked `triaged:already-canonical`: 3 — run-report, intake-reports, create-context-pack. **Excluded from action checklist** (verdict aligned: already-graduated).
- Items marked `triaged:graduate` but action pending: 2 — produce-prose-draft + produce-jargon-gloss (older rows). Both since landed as symlinks per FX-D1; no further action.
- Disagreements between sweep verdict and registry status: **0 substantive.** One inventory-vs-CLAUDE.md state ambiguity (produce-architecture.md — loose-end).
- The sweep did not modify the registry. Operator may add rows manually after review.

## Triage against Phase 3 plan

**Verdict: no new candidates change the decision shape for plan Step 2 (GR-1) or Step 3 (GR-3).**

- Phase 3 plan's named graduation candidates (FX-E1, FX-E2, GR-1 enforcement skills, GR-3 knowledge-file-producer) — all confirmed in scope, no surprises.
- 17 new graduation candidates surfaced by this sweep are all **independent of GR-1/GR-3 decision shape**:
  - 7 commands = symlink swaps (FX-D1 pattern, no canonical-template-membership impact).
  - 3 agents/hooks/SOPs = generic resources targeting workspace or research-workflow homes (not workflow-template membership).
  - 3 CLAUDE.md sections = workspace/ai-resources promotions (not workflow-template membership).
  - 4 settings patterns = permission-template additions (not workflow-template membership).
- 1 backport (execution-agent.md prose) = small canonical-side edit, no scope impact.
- 2 loose ends require operator triage but neither blocks Step 2 / Step 3.

**Recommendation:** Phase 3 plan Steps 2 and 3 (GR-1 + GR-3) can proceed as planned. The 17 new graduation candidates can be sequenced into Cluster E (Step 4) or handled as a separate "Cluster E.5" mini-bundle of symlink swaps after Steps 2–3 close — operator's call.

## Working notes

Full per-item classifier rationale at `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/innovation-sweep-nordic-pe-macro-landscape-H1-2026-2026-05-28.md` (gitignored — local only).
