# Token Audit — 2026-05-25
Scope: projects/axcion-ai-system-owner
AUDIT_ROOT: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner
Previous audit: None

---

## 0. Pre-Flight Summary

- **Baseline session metrics:** `/cost` and `/context` not available as callable tools in this Skill-invocation environment.
- **Session telemetry discovered:** `projects/axcion-ai-system-owner/logs/usage-log.md` (35 lines — newer project, few sessions logged).
- **Read(pattern) deny-rule coverage verdict: MEDIUM at root, HIGH at vault.**
  - Root `.claude/settings.json`: covers `Read(archive/**)`, `Read(**/*.archive.*)`, `Read(**/deprecated/**)`, `Read(**/old/**)`. Misses `audits/` (n/a here), `logs/`, `reports/` (n/a), `inbox/` (n/a), `output/`.
  - Vault `vault/.claude/settings.json`: **zero `Read()` denies**.
  - Large pipeline artifacts (~200 KB in `pipeline/`) and output advisory subtrees (`output/` 6 subdirs) sit unprotected.
- Full notes: `audits/working/audit-working-notes-preflight-axcion-ai-system-owner.md`.

---

## 1. CLAUDE.md Audit

**Files under AUDIT_ROOT:**
- `projects/axcion-ai-system-owner/CLAUDE.md` — 57 lines, 636 words, ≈ 827 tokens
- `projects/axcion-ai-system-owner/vault/CLAUDE.md` — 80 lines, 553 words, ≈ 719 tokens

**Out-of-scope note:** Workspace-root `CLAUDE.md` (~3,200 tokens) also loads via parent-walk; out of project-scope audit but contributes to per-turn cost.

**Per-session cost:**
- `axcion-ai-system-owner/CLAUDE.md`: ~827 tokens × every turn × 20–40 turns = ~16,500 – 33,000 tokens/session
- `vault/CLAUDE.md` only loads in vault-scoped sessions.

**Findings:**

| # | Finding | Severity | Recommendation |
|---|---------|----------|----------------|
| 1.1 | Root CLAUDE.md is 57 lines — exceptionally lean, well under the 200-line ceiling. Content is project-defining (persona, scope boundaries, grounding paths, model selection). All sections apply across SO sessions. Compaction + Session Boundaries sections present. | PASS | No action. |
| 1.2 | Model Selection section correctly cites workspace Model Tier rule and the per-agent/per-command `model: opus` frontmatter pattern. Strong adherence to the no-default rule. | PASS | No action. |
| 1.3 | "Out of Scope at v1" section (lines 28-32) explicitly bounds scope (no autonomous action, no writes outside output/, no toolkit replacement, no operational state, no skill symlinks). Excellent scope discipline. | PASS | No action. |
| 1.4 | Vault CLAUDE.md (80 lines) is also lean. Project-specific knowledge base operating instructions. | PASS | No action. |

**No HIGH, MEDIUM, or LOW findings in Section 1.** CLAUDE.md hygiene is exemplary for this project.

---

## 2. Skill Census

**Total skills measured:** 0 — this project has no project-local SKILL.md files.

All skills consumed via `ai-resources/skills/` (the canonical library) per workspace convention. The Project explicitly notes "No skill symlinks at v1" — uses `additionalDirectories` permission grant for cross-project reads instead.

**No findings in Section 2 for this project's scope.** Skill-quality findings belong in the ai-resources audit (already complete).

---

## 3. Command File Census

**Total command files found:** 57 in `.claude/commands/` (all synced from ai-resources via SessionStart hook; 0 project-local).

The shared-manifest mechanism excludes 4 ai-resources commands from auto-sync: `deploy-workflow.md`, `drift-check.md`, `new-project.md`, `resolve-repo-problem.md` (presumably not relevant to System Owner project).

**System Owner-specific commands (in ai-resources, used by this project):** `/consult`, `/architecture-review`, `/implementation-triage`, `/systems-review`, `/friday-so`, `/so-monthly`. All declare `model: opus` in frontmatter.

**Top 10 by line count (all shared, identical to ai-resources audit):**

| Command | Lines | Project relevance |
|---|---|---|
| friday-act | 435 | Used in cross-project Friday cadence |
| friday-checkup | 411 | Used in cross-project Friday cadence |
| monday-prep | 330 | Used in cross-project Monday cadence |
| friday-journal | 326 | Used in cross-project Friday cadence |
| permission-sweep | 324 | Workspace-level utility |
| repo-dd | 318 | Used by System Owner inputs (`/architecture-review` reads repo-dd outputs) |
| log-sweep | 303 | Workspace-level utility |
| innovation-sweep | 272 | Workspace-level utility |
| fix-symlinks | 249 | Workspace-level utility |
| audit-critical-resources | 245 | Used by System Owner inputs |

**Findings:**

| # | Finding | Severity | Recommendation |
|---|---|---|---|
| 3.1 | All 57 commands shared from ai-resources via auto-sync. Per-invocation costs identical to ai-resources audit (already addressed). No project-local commands authored — this project consumes infrastructure, doesn't author it. | INFO | Already in ai-resources audit recommendations. |
| 3.2 | The 6 System Owner commands (consult, architecture-review, etc.) are project-defining but live in ai-resources. This is by design (workspace-level commands callable from anywhere). | INFO | No action. |

**Confidence: HIGH** — direct measurement.

---

## 5. Session Patterns & Configuration

**Session telemetry available: PARTIAL.** `logs/usage-log.md` is only 35 lines with 1 logged session (2026-05-20, rated Wasteful). Newer project; telemetry inference is limited.

**Key telemetry observation (2026-05-20):**
- The single session attempted a self-evaluation in **plan mode**. The `system-owner` subagent (~100–105 K tokens) was dispatched during plan mode where it could not write to disk; the entire run was discarded and regenerated from scratch in run 2. **~100K tokens lost to a single plan-mode/disk-write incompatibility.**
- The recommendation in the log entry is project-specific and clear: do not dispatch heavy write-producing subagents inside plan mode. Either exit plan mode first, or have the subagent return text for main-session disk write.
- Other smaller findings: 3× session-notes.md re-reads (same Read-before-Write pattern as ai-resources); failed Edit on non-unique anchor.

**Configuration audit:**

| Setting | Current value | Recommended | Impact |
|---|---|---|---|
| Default model (settings.json) | Not set — per workspace Model Tier rule | Not set | OK |
| MAX_THINKING_TOKENS | Not set in project settings | 10000 (match ai-resources) | LOW — defaults apply |
| `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE` | Not set | 80% | LOW |
| `additionalDirectories` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo` (workspace root) | Same | OK — required for cross-project reads (system-owner reads `repo-documentation/vault/`) |
| Hooks: SessionStart auto-sync + permission sanity | PRESENT | Same | OK |
| Hooks: PreToolUse, PostToolUse, Stop | NOT configured at project level | Inherit from ai-resources? | LOW — same gap as ai-development-lab |
| Vault settings hooks | NONE (just permissions) | None needed for KB scope | OK |

**Hooks active in this project:**
- **SessionStart (root):** auto-sync-shared.sh, check-permission-sanity.sh
- **Vault:** no hooks

**Findings:**

| # | Finding | Severity | Recommendation |
|---|---|---|---|
| 5.1 | Plan-mode + heavy-subagent + required-disk-write = ~100K token waste (single observed incident, but the pattern is structural and likely to recur). | HIGH | Document explicitly in System Owner CLAUDE.md: "Do not dispatch `system-owner` agent inside plan mode if the deliverable requires disk write. Exit plan mode first." Optional: add a PreToolUse hook that blocks Task tool dispatches in plan mode for the `system-owner` agent. |
| 5.2 | MAX_THINKING_TOKENS not set — defaults apply. ai-resources sets it to 10000 for consistency. | LOW | Add `"env": {"MAX_THINKING_TOKENS": "10000"}`. |
| 5.3 | Telemetry is sparse (1 session). Cannot infer recurrence rates. The /usage-analysis cadence may not yet be established for this project. | INFO | Operator action: run `/usage-analysis` at the end of System Owner sessions to build a usable telemetry baseline. |
| 5.4 | Same hook gap as ai-development-lab (workspace hook coverage not inherited). | MEDIUM | Carryover from ai-development-lab audit R4. |

**Confidence: HIGH** for configuration; MEDIUM for behavior/recurrence inference (limited telemetry).

---

## 6. File Handling Patterns

**Read(pattern) deny-rule status (from Step 0.3):** MEDIUM at root, HIGH at vault.

**Findings:**

| # | Finding | Severity | Recommendation |
|---|---|---|---|
| 6.1 | Vault has zero `Read()` deny rules. `vault/.claude/settings.json` deny array is Bash-only. Vault contains a 5,580-word research file (`vault/research/systems-thinking-for-claude-code.md`) and accumulating `vault/inbox/`, `vault/findings/` content. Structural risk for future vault expansion. | HIGH | Add minimum vault-scope denies: `Read(archive/**)`, `Read(**/*.archive.*)`, `Read(**/deprecated/**)`, `Read(**/old/**)` (mirror root settings). Optional: `Read(research/*.md)` if research docs become large enough to risk accidental load. |
| 6.2 | Pipeline directory unprotected. 34,000 words (~44 KB tokens by proxy) of Phase 0 design artifacts (implementation-spec, project-plan, architecture, repo-snapshot, context-pack) entirely unprotected. These are completed Phase 0 outputs — no longer load-bearing. | MEDIUM | Add per-file denies: `Read(pipeline/implementation-spec.md)`, `Read(pipeline/project-plan.md)`, `Read(pipeline/architecture.md)`, `Read(pipeline/repo-snapshot.md)`, `Read(pipeline/context-pack.md)`, `Read(pipeline/implementation-log.md)`, `Read(pipeline/test-results.md)`. Keep `decisions.md`, `sources.md`, `pipeline-state.md` readable. |
| 6.3 | Output directory unprotected. 18,000+ words of generated advisory outputs (`output/self-evaluations/`, `output/systems-reviews/`, `output/session-evaluations/`, `output/architecture-reviews/`, `output/friday-advisories/`, `output/monthly-reviews/`) in unprotected `output/` tree. Historical advisories should not be re-loaded. | MEDIUM | Add date-stamped denies for historical advisories: `Read(output/self-evaluations/self-eval-2026-04-*.md)`, similar for other subdirs. Or simpler: `Read(output/*/202?-0[1-4]-*.md)` for anything older than current month. Active/recent advisories stay readable. |
| 6.4 | Logs directory unprotected. Active `logs/usage-log.md`, `logs/session-notes.md`, etc. need to be readable; archives need to be denied. The root settings have no logs/archive pattern. | MEDIUM | Add `Read(logs/*-archive-*.md)` (mirror ai-resources pattern). |
| 6.5 | Active `.claude/` files (commands, agents) are appropriately readable. No finding. | N/A | No action. |

Full notes: `audits/working/audit-working-notes-file-handling-axcion-ai-system-owner.md`.
**Confidence: HIGH** — direct file scan.

---

## 7. Missing Safeguards

| Safeguard | Status | Severity if missing | Finding |
|---|---|---|---|
| `Read(pattern)` deny rules covering stale/large dirs | **Partial** | HIGH | Root has 4 denies (archive, deprecated, old, *.archive.*); vault has zero; output/, pipeline/, logs/ uncovered. |
| Custom compaction instructions in CLAUDE.md | **Present** | MEDIUM | Root CLAUDE.md § Compaction names load-bearing items. |
| Subagent output-to-disk pattern | **Partial** | HIGH | `system-owner` agent writes to `output/` subdirs. But the 2026-05-20 plan-mode incident shows the pattern breaks under plan-mode constraints. |
| Context window monitoring instructions | **Partial** | MEDIUM | Workspace `/clear` rule applies. No project-specific monitoring. |
| Session boundaries defined for workflows | **Present** | MEDIUM | `/clear` rule + scoped output dirs. Each SO command is intentionally bounded. |
| Model selection guidance | **Present** | MEDIUM | All 6 SO commands declare `model: opus` in frontmatter. CLAUDE.md cites the per-frontmatter approach. |
| File read scoping | **Partial** | MEDIUM | Workspace floors apply. SO agent's grounding map per `references/grounding.md` is structured but reads full files. |
| Output length constraints | **Partial** | MEDIUM | SO commands write to `output/` subdirs. No explicit length cap on advisory output. |
| Effort level guidance | **Partial** | LOW | All 6 SO commands use Opus tier (effort implicit). |
| Hook-based output truncation | **Absent** | LOW | No project-level truncation hooks. |
| Audit/output artifact isolation | **Partial** | HIGH | `output/` has 6 subdirs of advisory artifacts (~18 KB+ tokens). No `Read()` deny. Same problem as `audits/`/`reports/` in ai-resources. |

**Confidence: HIGH** — direct evidence.

---

## 8. Best Practices Comparison

| # | Practice | Status | Gap description | Priority |
|---|---|---|---|---|
| 1 | CLAUDE.md under 200 lines | **Implemented** | 57 + 80 lines (root + vault). Exemplary. | LOW |
| 2 | `Read(pattern)` deny rules configured | **Partial** | Root has 4 denies; vault has 0; output/pipeline/logs uncovered. | HIGH |
| 3 | Skills use on-demand loading | **Implemented** | All via ai-resources. | LOW |
| 4 | Subagents for heavy reads | **Partial** | system-owner agent's read pattern is structured (function-shape map). To be confirmed by Section 4 audits. | MEDIUM |
| 5 | Strategic `/compact` at breakpoints | **Not implemented** | SO commands are single-shot dispatches; less applicable. But the workspace-level compaction guidance applies and Section 4 will check. | MEDIUM |
| 6 | `/clear` between unrelated tasks | **Implemented** | Workspace rule + Session Boundaries section in CLAUDE.md. | LOW |
| 7 | Model selection per task type | **Implemented** | All 6 SO commands + system-owner agent declare `model: opus`. | LOW |
| 8 | Extended thinking budget controlled | **Partial** | MAX_THINKING_TOKENS not set in project settings. | LOW |
| 9 | Unused MCP servers disabled | **Not observable** | User-level. | LOW |
| 10 | Output-to-disk pattern for subagents | **Partial** | system-owner writes to output/; broke in plan mode (S5.1). | HIGH |
| 11 | Precise prompts over vague ones | **Implemented** | references/grounding.md, references/persona.md provide structured prompt context. | LOW |
| 12 | Session notes pattern | **Implemented** | Workspace pattern; only 1 entry in usage-log yet (newer project). | LOW |
| 13 | Inter-skill disambiguation | **Implemented** | The 6 SO commands have distinct slugs (`/consult`, `/architecture-review`, `/systems-review`, etc.) with clear scope boundaries documented in CLAUDE.md "Out of Scope" section. | LOW |
| 14 | Agent/skill prompts use structured sections | **Implemented** | system-owner agent uses structured sections (verified in ai-resources audit). | LOW |
| 15 | Few-shot examples present where useful | **Partial** | references/grounding.md, references/toolkit-relationship.md are structured but may lack canonical I/O examples. | LOW |

**Key gaps by priority:**
- **HIGH (3):** Vault Read() denies; output-artifact isolation; subagent output-to-disk pattern fragility under plan mode
- **MEDIUM (2):** /compact breakpoints (TBC); subagent delegation pattern (TBC by Section 4)
- **LOW (10):** Implemented or low-impact

**Confidence: HIGH** — verified.

---

## 4. Workflow Token Efficiency

**Workflows audited: 3** (`/consult`, `/architecture-review`, `/systems-review`). The remaining 3 System Owner commands (`/implementation-triage`, `/friday-so`, `/so-monthly`) are smaller-scope variants on the same dispatch pattern; findings transfer.

**Cross-workflow strengths:** All 3 workflows dispatch to a single Opus subagent (`system-owner`) — clean single-delegation pattern. `/systems-review` and `/architecture-review` write full reports to disk and return short summaries to main (output-to-disk PASS). Refinement multipliers all below the >3 threshold.

**Cross-workflow weakness — the same pattern recurs in all 3:** **Main session reads large reference files just to embed them into the subagent brief, then the subagent re-reads them.** This is the dominant token waste pattern across the entire project's workflow design.

---

### Workflow: /consult

**Entry:** `.claude/commands/consult.md` → `system-owner` agent (Opus, project-local)
**Start-of-workflow context:**
- Function A (general): ~24.6K tokens (CLAUDE.md stack + agent body + 4 references + principles.md + system-doc.md)
- Function B (change-shape): ~32.4K tokens (adds blueprint.md, risk-topology.md, repo-architecture.md)
**Total findings:** 6 (3 HIGH, 1 MEDIUM, 2 LOW)

| # | Finding | Severity | Waste mechanism |
|---|---|---|---|
| CON1 | `principles.md` (528 lines) AND `system-doc.md` (373 lines) both exceed the 300-line HIGH threshold, full-read on every `/consult` invocation. | HIGH | Two oversized references loaded every consultation |
| CON2 | `repo-architecture.md` duplicated: read in main session at Step 3, then passed verbatim into the agent brief at Step 4 — ~2.6K tokens held in two contexts simultaneously. | HIGH | Main + subagent context duplication |
| CON3 | Agent response returns verbatim to main session — no output-to-disk pattern for /consult (it's an interactive chat command). Function B briefs have no line cap; potential >200-line return is unbounded. | HIGH | Subagent return-volume risk |
| CON4 | No `/compact` instruction at natural breakpoints (post-Step 3 reference read, post-Step 5 response synthesis). | MEDIUM | Missing compaction breakpoints |
| CON5 | `systems-building-principles.md` placeholder read unconditionally (~233 tokens). | LOW | Trivial waste; informational |
| CON6 | `toolkit-relationship.md` read on every call but mainly relevant to Function B (~1,699 tokens). | LOW | Function-A invocations don't need it |

Full notes: `audits/working/audit-working-notes-workflow-consult.md`.

---

### Workflow: /architecture-review

**Entry:** `.claude/commands/architecture-review.md` → `system-owner` agent (Opus)
**Subagent grounding load (default):** ~20.4K tokens; worst-case ~22.5K
**With embedded audit content:** ~35K–47K total subagent context before generation
**Telemetry:** None — zero historical runs (`output/architecture-reviews/` empty)
**Total findings:** 3 (1 HIGH, 1 MEDIUM, 1 LOW)

| # | Finding | Severity | Waste mechanism |
|---|---|---|---|
| AR1 | Main session reads 2–4 large audit files (~16–27K tokens total) at Step 3, then re-embeds them verbatim in the Step 4 subagent brief. Files: `token-audit-*.md` (521 lines), `repo-due-diligence-*.md` (705+ lines), optional `workflow-analysis-*.md` (360 lines each). Pure pass-through with no main-session reasoning. Same pattern as /consult CON2. | HIGH | Main + subagent context duplication for delegable reads |
| AR2 | No `/compact` breakpoint defined in command body despite ~16–27K token main-session load by end of Step 3. | MEDIUM | Missing compaction breakpoint |
| AR3 | `repo-health-*.md` at 90 lines is within ±15% of the 100-line delegable threshold (boundary case). | LOW | Boundary marker |

**Pass items:** Subagent-return discipline (Executive Summary only, ~3–5 lines); output-to-disk pattern (full report to `output/architecture-reviews/`); refinement multiplier (2 sessions per run).

Full notes: `audits/working/audit-working-notes-workflow-architecture-review.md`.

---

### Workflow: /systems-review

**Entry:** `.claude/commands/systems-review.md` → `system-owner` agent (Opus)
**Main start-of-workflow context:** ~12,130 tokens
**Subagent default grounding load:** ~27,000 tokens (worst-case ~29K, declared in `references/grounding.md` § 4)
**Subagent return to main:** ~460–585 tokens (Binding Constraint + Leverage Point echo only; full report to disk)
**Total findings:** 3 (1 HIGH, 0 MEDIUM, 2 LOW)

| # | Finding | Severity | Waste mechanism |
|---|---|---|---|
| SR1 | Step 2 reads `systems-thinking-for-claude-code.md` (401 lines, ~7,254 tokens) in main session as a presence check; subagent re-reads the same file in Phase 1. Delegable — could be replaced with a Glob or `test -f` existence check. | HIGH | Main reads file solely as existence check; subagent re-reads anyway |
| SR2 | Subagent default-grounding load ~27K tokens (worst-case ~29K). Declared and accepted in `grounding.md` § 4; lives in subagent context, not main. | LOW | Cost is acknowledged; lives in subagent context |
| SR3 | Project CLAUDE.md (57 lines, ~827 tokens) loaded per-turn project-wide. Not workflow-specific. | LOW | Already counted in Section 1 |

**Pass items:** Subagent-return discipline; output-to-disk pattern.

Full notes: `audits/working/audit-working-notes-workflow-systems-review.md`.

---

**Cross-workflow synthesis:** The same waste pattern fires in **all 3 audited workflows**:
- `/consult` CON2: `repo-architecture.md` read in main + embedded verbatim in subagent brief
- `/architecture-review` AR1: 2–4 audit reports read in main + embedded verbatim in subagent brief
- `/systems-review` SR1: `systems-thinking-for-claude-code.md` read in main as presence check; subagent re-reads

The remediation is the same in all three cases: **main session passes file paths to the subagent brief; subagent reads the files directly.** Three separate command edits, identical mechanism. This pattern is the largest single optimization target for the project.

**Confidence: HIGH** for context loading and file-read mapping (direct instruction-text analysis + measurements). MEDIUM for subagent return volumes (structural inference; only `/consult` has unbounded return).

---

## 9. Optimization Plan

### 9.1 Executive Summary

This is **a project whose hygiene fundamentals are exemplary but whose runtime cost model is over-coupling main and subagent contexts.** The CLAUDE.md is 57 lines (workspace-best). The persona, scope, and out-of-scope sections are crisply documented. The model-tier discipline (every command + the agent declare `model: opus`) is rigorous. But the **workflow design has a single dominant waste pattern: main session reads reference files just to embed them verbatim into the subagent brief, then the subagent re-reads the same files** — it fires in all 3 audited workflows (CON2, AR1, SR1).

The second cluster is **plan-mode + heavy-subagent + required-disk-write fragility.** The single Wasteful session in telemetry (2026-05-20) lost ~100K tokens to this exact combination. The fix is documentation (CLAUDE.md note) or enforcement (PreToolUse hook).

The third cluster is **`Read()` deny rule gaps** — root settings cover the four archival patterns but miss `output/`, `pipeline/`, `logs/` and the vault entirely. The project has ~200KB of frozen Phase 0 pipeline artifacts and a 6-subdirectory output/ tree of advisory content, all unprotected.

Estimated avoidable waste:
- **Workflow main↔subagent duplication (cross-workflow pattern):** ~2.6K–27K tokens per invocation across `/consult`, `/architecture-review`, `/systems-review` (HIGH).
- **Plan-mode subagent dispatch incident:** ~100K tokens per occurrence (HIGH, low frequency expected).
- **Read() deny exposure:** ~5K–11K tokens per accidental load (HIGH risk).

### 9.2 Prioritized Recommendations

#### HIGH — Fix first

**R1: Eliminate the main-session-then-subagent file-read duplication pattern across all 3 workflows**

| Field | Content |
|---|---|
| **Issue** | Main session reads reference/audit files at Step 3 of `/consult` (repo-architecture.md), Step 3 of `/architecture-review` (token-audit-*.md + repo-due-diligence-*.md + workflow-analysis-*.md), and Step 2 of `/systems-review` (systems-thinking-for-claude-code.md), then either embeds them verbatim into the subagent brief or uses the read as a mere presence check — and the subagent reads them again in its own grounding map. |
| **Evidence** | Workflow audit findings CON2, AR1, SR1. |
| **Waste mechanism** | Duplicate file content in two contexts (main + subagent). Main never reasons over the content — it's pass-through. |
| **Estimated savings** | HIGH — ~2.6K tokens per `/consult` Function B run; ~16–27K tokens per `/architecture-review` run; ~7K tokens per `/systems-review` run. |
| **Implementation steps** | For each of the 3 commands: (a) Replace the Step 3 (or Step 2) Read with a pass-by-path: the subagent brief specifies the file path and instructs the subagent to read it directly. (b) For `/systems-review` Step 2 (presence check), replace `Read` with `Glob` or `test -f` — confirm existence without loading content. |
| **Risk** | LOW — the subagent already reads these files per its grounding map. Main reads are structurally redundant. |
| **Dependencies** | None |
| **Category** | Quick win (3 small command edits) |

---

**R2: Document the plan-mode + disk-write incompatibility in CLAUDE.md**

| Field | Content |
|---|---|
| **Issue** | The 2026-05-20 session lost ~100K tokens because the system-owner subagent was dispatched in plan mode where it couldn't write to disk. The pattern is structural and will recur. |
| **Evidence** | `logs/usage-log.md` 2026-05-20 Wasteful entry; ~100K tokens of subagent context discarded. |
| **Waste mechanism** | Plan mode disallows file writes; heavy subagent dispatches with disk-write deliverables fail silently and require full regeneration. |
| **Estimated savings** | HIGH per occurrence (~100K tokens). Frequency unknown — but the failure mode is non-obvious enough to warrant explicit documentation. |
| **Implementation steps** | Add to `projects/axcion-ai-system-owner/CLAUDE.md` a new section "Plan-Mode Constraints" (~5 lines): "Do not dispatch the `system-owner` agent inside plan mode if the deliverable requires disk write (`/architecture-review`, `/systems-review`, `/so-monthly`, `/friday-so`). Exit plan mode first, OR confirm the command is one of the chat-output-only commands (`/consult`, `/implementation-triage`)." |
| **Risk** | LOW — pure documentation. |
| **Dependencies** | Optional escalation: add a PreToolUse hook that blocks Task tool for system-owner in plan mode. |
| **Category** | Quick win (5-line CLAUDE.md addition) |

---

**R3: Add `Read()` deny rules — granular per-file + vault scope**

| Field | Content |
|---|---|
| **Issue** | Root has 4 generic denies; vault has 0; output/ (6 subdirs of historical advisories) and pipeline/ (~200KB frozen Phase 0) are unprotected. |
| **Evidence** | Section 6.1–6.4; Section 0.3. |
| **Waste mechanism** | Accidental directory exploration via Glob/Grep/Read can load any of ~15 unprotected files (5–11K+ tokens each). |
| **Estimated savings** | HIGH — 5,000–11,000 tokens per accidental read; risk compounds as output/ accumulates more advisories. |
| **Implementation steps** | Add to `projects/axcion-ai-system-owner/.claude/settings.json` `permissions.deny`: `"Read(pipeline/implementation-spec.md)"`, `"Read(pipeline/project-plan.md)"`, `"Read(pipeline/architecture.md)"`, `"Read(pipeline/repo-snapshot.md)"`, `"Read(pipeline/context-pack.md)"`, `"Read(pipeline/implementation-log.md)"`, `"Read(pipeline/test-results.md)"`, `"Read(logs/*-archive-*.md)"`, `"Read(output/*/202?-0[1-4]-*.md)"` (historical month rollover). For vault: add `"Read(archive/**)"`, `"Read(**/*.archive.*)"`, `"Read(**/deprecated/**)"`, `"Read(**/old/**)"` to `vault/.claude/settings.json` (mirror root). |
| **Risk** | LOW — denies target frozen and historical content only. Active references stay readable. |
| **Dependencies** | None |
| **Category** | Quick win (10–12 line JSON edit across 2 files) |

---

**R4: Cap `/consult` Function B subagent return at 200 lines + add post-Step-5 disk-write fallback**

| Field | Content |
|---|---|
| **Issue** | `/consult` Function B returns the agent response verbatim to main with no line cap; potential >200-line returns are unbounded. The other 5 SO commands have disk-write outputs; `/consult` is chat-only. |
| **Evidence** | CON3 finding. |
| **Waste mechanism** | Unbounded subagent return into main context. |
| **Estimated savings** | MEDIUM-HIGH — depends on actual return sizes; capping at 200 lines bounds the worst case. |
| **Implementation steps** | (a) In `system-owner` agent brief: add "Cap Function B responses at 200 lines; if longer, write to `output/consult-responses/{date}-{slug}.md` and return ≤30-line summary." (b) Update `/consult` Step 5 to handle both inline and disk-pointer return modes. |
| **Risk** | MEDIUM — operator UX changes when long responses go to disk. Validate that the operator still gets actionable information in the inline summary. |
| **Category** | Structural change |

---

#### MEDIUM — Plan next session

**R5: Split or trim `principles.md` (528 lines) and `system-doc.md` (373 lines)**

| Field | Content |
|---|---|
| **Issue** | Both files exceed the 300-line HIGH threshold and are full-read on every `/consult` invocation (~10K combined tokens). |
| **Evidence** | CON1 finding. |
| **Estimated savings** | MEDIUM — ~3,000–5,000 tokens per `/consult` (after a 30% trim or split). |
| **Implementation steps** | Review both files. Identify sections that fire only for specific function shapes (A/B/C/D/E); split into mode-specific reference files; load conditionally per function shape. Alternative: condense both files to ≤200 lines each, moving examples and rationale to a separate `_extended.md` that loads only on demand. |
| **Risk** | MEDIUM — reference content is load-bearing for agent reasoning; ensure trimmed content doesn't degrade output quality. Validate with 2 reference runs vs baseline. |
| **Category** | Structural change |

---

**R6: Add `/compact` breakpoints to `/consult` and `/architecture-review`**

| Field | Content |
|---|---|
| **Issue** | Both workflows lack `/compact` at natural breakpoints. `/consult` Function B loads ~32K tokens before the agent dispatch. `/architecture-review` loads ~16–27K tokens by end of Step 3. |
| **Evidence** | CON4, AR2 findings. |
| **Estimated savings** | MEDIUM — preserves main-session headroom for follow-up exchanges; bounded by R1 (which reduces the load that needs compacting). |
| **Implementation steps** | Add advisory `/compact` instructions: `/consult` post-Step 3 (post-references); `/architecture-review` post-Step 3 (post-audit-reads). Phrased as "[COMPACT SUGGESTED] If context exceeds 60%, run /compact before dispatching the agent." |
| **Risk** | LOW — advisory only |
| **Category** | Quick win |

---

#### LOW — Opportunistic

**R7:** Trim `toolkit-relationship.md` reads to Function B invocations only — currently loaded on every `/consult` call (~1,700 tokens). Conditional load.

**R8:** Remove `systems-building-principles.md` placeholder read (~233 tokens, file is empty/stub).

**R9:** Set `MAX_THINKING_TOKENS=10000` in this project's settings.json for consistency with ai-resources.

**R10:** Establish `/usage-analysis` cadence — currently only 1 entry in usage-log.md. Without telemetry, recurrence and cost estimates remain inference-based.

### 9.3 Safeguard Proposals

**S1: Plan-mode subagent-dispatch hook (implements R2)** — optional PreToolUse hook that detects Task tool dispatch in plan mode for the system-owner agent and surfaces a warning ("This subagent writes to disk; plan mode blocks it. Exit plan mode first.").

**S2: Per-file `Read()` deny set (implements R3)** — see R3 implementation. Annual maintenance: monthly review of new output/ subdirectory entries; add date-stamped denies as advisories age out of the review cycle.

**S3: Subagent-brief-by-path-not-by-content convention (implements R1)** — codify in `references/grounding.md` or `references/toolkit-relationship.md`: "Briefs MUST reference files by path, NEVER embed verbatim. The agent reads files itself per its function-shape map."

### 9.4 Implications for Future Opus 4.7 Upgrade

- **R1 (file-read duplication) becomes higher-impact** at Opus 4.7 pricing — system-owner is on Opus tier; the duplicated content costs Opus prices twice (main + subagent).
- **R5 (oversized references) similarly compounds** at Opus pricing.
- **R2 (plan-mode warning) is model-agnostic** but the loss per incident scales with model cost — at Opus 4.7, a single ~100K-token plan-mode re-run is the costliest single failure mode in the project.
- **The per-command `model: opus` frontmatter** is already in place — model tier resolves automatically.
- **R4 (return cap) becomes higher-priority** — unbounded returns are an Opus-pricing risk.

### 9.5 Assumptions and Gaps

- **Telemetry is sparse (1 session entry).** Most recurrence claims are structural inference, not observed. The 2026-05-20 incident is the only data point for "how things go wrong" in this project.
- **Subagent grounding-load figures** (~20–32K per function shape) come from the project's own `grounding.md` § 4 self-estimates, not direct token measurement. Treated as reliable upper bounds.
- **No `/cost` data available** in audit environment.
- **MCP servers not observable** from repo settings.
- **The 4 unaudited SO commands** (`/implementation-triage`, `/friday-so`, `/so-monthly`, `/friday-act`'s SO-derived flow) likely share the same patterns; R1, R3, R5 apply by extension but were not directly audited.

---

## 10. Self-Assessment

**1. Audit token cost:** `/cost` not available. Audit consumed ~7 inline-section steps + 4 subagent delegations (3 workflows + 1 file-handling) — heavier than audit #2 due to the 3 workflow dispatches. Estimated main-session context growth: ~60,000–80,000 tokens.

**2. Protocol gaps encountered:**
- **Section 4 cross-workflow synthesis.** This project's 3 audited workflows all share the same dominant waste pattern (main↔subagent duplication). The protocol audits each workflow in isolation, but the most actionable recommendation is cross-workflow. Handled with a "Cross-workflow synthesis" subsection at the bottom of Section 4 and a unified R1 in Section 9.
- **Plan-mode constraint detection.** The 2026-05-20 incident is a structural Claude Code constraint (plan mode + disk-write subagents) that isn't covered by the protocol's safeguard checklist. Added as S5.1 + R2.
- **Vault sub-scope.** This project has a sub-scope (`vault/`) with its own `.claude/settings.json`. The protocol's Section 0.3 handles multiple settings files but doesn't explicitly address scope-within-scope. Handled inline by reporting verdicts at both root and vault scope.

**3. Confidence ratings:**

| Section | Confidence | Basis |
|---|---|---|
| 0. Pre-Flight | HIGH | Direct read |
| 1. CLAUDE.md | HIGH | Direct measurement + full content read |
| 2. Skill Census | HIGH | Trivially confirmed (0 skills) |
| 3. Command Census | HIGH | Direct measurement; cross-referenced against ai-resources audit |
| 4. Workflow Audit | HIGH (file-read mapping) / MEDIUM (subagent return volumes, esp. /consult Function B) | Subagent audit reports + protocol mapping |
| 5. Session Patterns | HIGH (config) / MEDIUM (behavior recurrence) | Only 1 usage-log entry; recurrence is inference |
| 6. File Handling | HIGH | Direct file scan + deny-rule comparison |
| 7. Missing Safeguards | HIGH | Verified |
| 8. Best Practices | HIGH | Verified |
| 9. Optimization Plan | HIGH | Cross-section synthesis from HIGH-confidence inputs |

**4. Threshold-boundary findings:**
- CON1 `principles.md` 528 lines, `system-doc.md` 373 lines — both well above the 300-line HIGH threshold; not boundary cases.
- AR3 `repo-health-*.md` at 90 lines — within ±15% of the 100-line delegable threshold (LOW boundary marker).
- CON3 Function A response soft target (60 lines) — near the 200-line MEDIUM threshold; only matters if Function A returns drift past target.

---

