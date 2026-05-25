# Token Audit — 2026-05-25
Scope: projects/obsidian-pe-kb
AUDIT_ROOT: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/obsidian-pe-kb
Previous audit: None

---

## 0. Pre-Flight Summary

- **Baseline session metrics:** `/cost` and `/context` not available.
- **Session telemetry discovered:** `logs/usage-log.md` (62 lines, 2 session entries from 2026-04-21 and 2026-04-29 — both rated Acceptable; ~1 month old).
- **Read(pattern) deny-rule coverage verdict: MEDIUM.** 4 generic denies present (`archive/**`, `**/*.archive.*`, `**/deprecated/**`, `**/old/**`). The `Read(**/*.archive.*)` pattern requires a `.archive.` dot infix and does NOT match `logs/session-notes-archive-2026-04.md` (uses `-archive-` hyphen). Pipeline/ (~400KB frozen artifacts) and reports/ uncovered.
- Full notes: `audits/working/audit-working-notes-preflight-obsidian-pe-kb.md`.

---

## 1. CLAUDE.md Audit

**Files under AUDIT_ROOT:**
- `projects/obsidian-pe-kb/CLAUDE.md` — 33 lines, 443 words, ≈ 576 tokens

**Out-of-scope note:** Workspace-root `CLAUDE.md` (~3,200 tokens) loads in every session via parent-walk. The vault `CLAUDE.md` at `../../knowledge-bases/pe-kb-vault/` is a separate scope (loaded when sessions open at the vault root, not at this project root).

**Per-session cost:**
- `obsidian-pe-kb/CLAUDE.md`: ~576 tokens × every turn × 20–40 turns = ~11,500 – 23,000 tokens/session

**Findings:**

| # | Finding | Severity | Recommendation |
|---|---------|----------|----------------|
| 1.1 | CLAUDE.md is 33 lines — the leanest project CLAUDE.md in this audit set. Content is project-defining: layout, opening conventions, model selection, commit rules, dual-repo note for vault-vs-build separation. All sections apply across all sessions. | PASS | No action. |
| 1.2 | Model Selection section correctly cites the workspace Model Tier rule, declares no project default, and recommends posture (Sonnet 1M for KB ingestion, Opus for analytical synthesis). | PASS | No action. |
| 1.3 | Commit Rules section explicitly mirrors workspace canonical with a project-specific addition (line 33): "vault content lives in a separate git repo at `../../knowledge-bases/pe-kb-vault/` (remote: `obsidian-knowledge-base`). Do not stage vault paths from this repo." Load-bearing project-specific addition. | PASS | No action. |
| 1.4 | No Compaction section. Project sessions inherit workspace compaction guidance. | LOW | Optional: add 2-line Compaction note for KB ingestion sessions if telemetry shows context spikes during article-batch writes. |

**No HIGH or MEDIUM findings in Section 1.**

---

## 2. Skill Census

**Total skills measured:** 0 — no project-local SKILL.md files.

All skills consumed via `ai-resources/skills/` (workspace convention). Skill-quality findings belong in the ai-resources audit (already complete).

**No findings in Section 2.**

---

## 3. Command File Census

**Total command files:** 55 in `.claude/commands/` (all synced from ai-resources via SessionStart hook; **0 project-local**).

The shared-manifest excludes the same ai-resources commands as the other projects (`deploy-workflow`, `drift-check`, `new-project`, `resolve-repo-problem`).

**Top commands by line count: identical to ai-resources audit** — `friday-act` (435), `friday-checkup` (411), etc. No incremental analysis.

**Findings:**

| # | Finding | Severity | Recommendation |
|---|---|---|---|
| 3.1 | All 55 commands shared from ai-resources via auto-sync. Per-invocation costs identical to ai-resources audit. | INFO | See ai-resources audit recommendations. |

**Confidence: HIGH** — direct measurement.

---

## 4. Workflow Token Efficiency

**Workflows identified: 0 project-local workflows.**

This project has no project-specific commands or workflows. It uses standard ai-resources commands (`/wrap-session`, `/audit-repo`, `/repo-dd`, etc.) for build/maintenance, plus the standard Friday/Monday cadence commands. All these were audited in the ai-resources audit (see `audits/token-audit-2026-05-25-ai-resources.md` Section 4).

The vault content (where KB ingestion/query workflows actually run) lives in a separate repo at `../../knowledge-bases/pe-kb-vault/` and is NOT in this audit scope.

**No new Section 4 findings for this project's scope.** All workflow optimizations from the ai-resources audit (R1–R7 there) apply to this project too when those commands are invoked here.

**Confidence: HIGH** — verified by command-file diff against ai-resources (0 project-local files).

---

## 5. Session Patterns & Configuration

**Session telemetry available: LIMITED.** `logs/usage-log.md` (62 lines, 2 sessions, ~1 month old). Project usage has been intermittent.

**Telemetry observations:**
- **2026-04-21 (Acceptable):** Resume-after-idle session. Findings: plan-QC discipline miss, agent-registry drift, sequential orchestrators that could be parallelized. Recommended: enforce mandatory pre-ExitPlanMode QC.
- **2026-04-29 (Acceptable):** B.2 article writing (18 wiki articles). Key finding: **model-tier mismatch** — ran on Opus 4.7 (1M) for execution-tier work that the project CLAUDE.md routes to Sonnet 1M. ~30–60% per-token cost overrun on the writing portion. Recommendation: honor the project-level model-tier declaration; use Sonnet for KB ingestion (execution-tier), Opus for analytical synthesis.

**Configuration audit:**

| Setting | Current value | Recommended | Impact |
|---|---|---|---|
| Default model (settings.json) | Not set — per workspace Model Tier rule | Not set | OK |
| MAX_THINKING_TOKENS | Not set | 10000 | LOW — defaults apply |
| `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE` | Not set | 80% | LOW |
| `additionalDirectories` | workspace root | Same | OK |
| Hooks: SessionStart auto-sync | PRESENT | Same | OK |
| Hooks: SessionStart permission-sanity | NOT PRESENT | Add | LOW — other projects have it; this one doesn't |
| Hooks: PreToolUse, PostToolUse, Stop | Absent | Inherit from ai-resources | MEDIUM — same gap as other projects |

**Hooks active in this project:**
- **SessionStart:** auto-sync-shared.sh only (lighter than axcion-ai-system-owner's 2 hooks, which also have permission-sanity)

**Findings:**

| # | Finding | Severity | Recommendation |
|---|---|---|---|
| 5.1 | Hook coverage thinnest among the 3 audited projects — only 1 SessionStart hook (auto-sync). Missing permission-sanity check that other projects have. | LOW | Add the second SessionStart hook block from other projects' settings.json. One-time settings.json edit. |
| 5.2 | Same workspace-hook-coverage gap as ai-development-lab and axcion-ai-system-owner. | MEDIUM | Carryover from ai-development-lab audit R4 — workspace-wide decision. |
| 5.3 | Telemetry is sparse (2 entries) and ~1 month old. Project usage may have lulled; resume sessions are at risk for model-tier and plan-QC patterns surfaced in the 2 entries. | INFO | Run `/usage-analysis` after the next session to refresh the telemetry baseline. |
| 5.4 | The 2026-04-29 model-tier mismatch is an operator-side discipline issue (CLAUDE.md recommended Sonnet; operator ran Opus). Not an infrastructure finding — but reinforces that the recommended-posture text in CLAUDE.md needs operator follow-through. | INFO | Optional: post-prompt nudge or hook that reminds about recommended model tier at SessionStart. |

**Confidence: HIGH** for configuration; LOW for behavior recurrence (sparse telemetry).

---

## 7. Missing Safeguards

| Safeguard | Status | Severity if missing | Finding |
|---|---|---|---|
| `Read(pattern)` deny rules covering stale/large dirs | **Partial** | MEDIUM | 4 generic denies present; pipeline/, reports/, logs/-archive-* (pattern miss) uncovered. |
| Custom compaction instructions in CLAUDE.md | **Absent** | MEDIUM | Project CLAUDE.md has no Compaction section. Workspace-level applies. |
| Subagent output-to-disk pattern | **Present** | HIGH | Workspace CLAUDE.md contract applies; no project-local subagents to violate. |
| Context window monitoring instructions | **Partial** | MEDIUM | Workspace `/clear` rule applies. |
| Session boundaries defined for workflows | **Present** | MEDIUM | Workspace rule applies. |
| Model selection guidance | **Present** | MEDIUM | CLAUDE.md recommends Sonnet for KB ingestion, Opus for analytical synthesis. Recent telemetry shows the recommendation was not honored in 1 of 2 sessions (operator-side). |
| File read scoping | **Partial** | MEDIUM | Workspace floors apply. |
| Output length constraints | **Partial** | MEDIUM | No project-level constraints; KB article writes are bounded by template structure. |
| Effort level guidance | **Partial** | LOW | Implicit via model-tier guidance. |
| Hook-based output truncation | **Absent** | LOW | No project hooks for truncation. |
| Audit/output artifact isolation | **Partial** | MEDIUM | `pipeline/` (frozen Phase 0, ~400KB), `reports/` (~28KB) unprotected. `logs/session-notes-archive-2026-04.md` pattern miss. |

**Confidence: HIGH** — direct evidence.

---

## 8. Best Practices Comparison

| # | Practice | Status | Gap description | Priority |
|---|---|---|---|---|
| 1 | CLAUDE.md under 200 lines | **Implemented** | 33 lines — leanest of the 4 projects audited today. | LOW |
| 2 | `Read(pattern)` deny rules configured | **Partial** | 4 generic denies; pipeline/ + reports/ + logs/-archive-* gap. | HIGH |
| 3 | Skills use on-demand loading | **Implemented** | All via ai-resources. | LOW |
| 4 | Subagents for heavy reads | **Implemented** | No project-local workflows; ai-resources patterns apply. | LOW |
| 5 | Strategic `/compact` at breakpoints | **Partial** | No project-specific breakpoints. KB article-batch writes could benefit from `/compact` between batches. | MEDIUM |
| 6 | `/clear` between unrelated tasks | **Implemented** | Workspace rule. | LOW |
| 7 | Model selection per task type | **Implemented (CLAUDE.md) / Operator-side gap** | CLAUDE.md recommends Sonnet for KB ingestion. 1 of 2 logged sessions ran on Opus instead — operator-side discipline issue. | MEDIUM |
| 8 | Extended thinking budget controlled | **Partial** | MAX_THINKING_TOKENS not set. | LOW |
| 9 | Unused MCP servers disabled | **Not observable** | User-level. | LOW |
| 10 | Output-to-disk pattern for subagents | **Implemented** | No project-local subagents. | LOW |
| 11 | Precise prompts over vague ones | **Implemented** | Standard ai-resources commands. | LOW |
| 12 | Session notes pattern | **Implemented** | `logs/session-notes.md` (34KB — large, active) + archive `session-notes-archive-2026-04.md`. Pattern in active use. | LOW |
| 13 | Inter-skill disambiguation | **Implemented** | All shared from ai-resources. | LOW |
| 14 | Agent/skill prompts use structured sections | **Implemented** | All shared from ai-resources. | LOW |
| 15 | Few-shot examples present where useful | **Implemented** | All shared from ai-resources. | LOW |

**Key gaps by priority:**
- **HIGH (1):** Read(pattern) deny rules gaps (pipeline/, reports/, logs archive pattern bug)
- **MEDIUM (3):** Operator-side model-tier discipline; project hook coverage; KB-ingestion compaction breakpoints
- **LOW (11):** Implemented or not applicable

**Confidence: HIGH** — verified.

---

## 6. File Handling Patterns

**Read(pattern) deny-rule status (from Step 0.3):** MEDIUM.

**Findings:**

| # | Finding | Severity | Recommendation |
|---|---|---|---|
| 6.1 | Frozen Phase 0 pipeline artifacts (12 files, 52.9K words) in unprotected `pipeline/` directory. Estimated ~69K tokens exposure if all accidentally loaded. Includes explicitly versioned files (`implementation-spec-v1.md`, `architecture-v1.md`) — clear "v1" markers without enforcement. | HIGH | Add per-file or glob denies. Suggested: `"Read(pipeline/*.md)"` with explicit allow-list for the 1–2 files that ARE load-bearing (`pipeline-state.md` if used; `decisions.md` if active). Simpler alternative: `"Read(pipeline/*-v[0-9].md)"` for versioned files only, then per-file denies for the unversioned frozen ones. |
| 6.2 | `logs/session-notes-archive-2026-04.md` (4.1K words / ~33KB) escapes the existing `Read(**/*.archive.*)` deny because the file uses `-archive-` infix, not `.archive.` dot suffix. Pattern bug — this is the only logs-archive file in this project but the pattern miss is structural. | MEDIUM | Add explicit `"Read(logs/*archive*.md)"` (looser glob — catches both infix and suffix patterns) OR add the specific file: `"Read(logs/session-notes-archive-*.md)"`. **Same pattern bug exists in ai-resources** (see ai-resources audit R2). |
| 6.3 | Generated reports in `reports/` (3 files, ~28KB) unprotected. The 12KB `repo-health-report.md` is most likely to be accidentally read during repo exploration. | MEDIUM | Add `"Read(reports/repo-health-report*.md)"` and `"Read(reports/decomposition-audit-pass*-2026-04-*.md)"` (date-stamped). |
| 6.4 | Active `session-notes.md` is 34KB / 4,160 lines — very large, but actively in-use. Reading the tail (~80 lines) for append is sufficient for most wrap operations; full-read should be conditional. | MEDIUM | Cross-project pattern: skill-level fix in `/wrap-session` to default to tail-read. Carryover from ai-resources audit R6. |
| 6.5 | No archive/ directory at project root (handled by ai-resources convention of `logs/*-archive-*.md` files in place). | LOW | No action — by design. |

Full notes: `audits/working/audit-working-notes-file-handling-obsidian-pe-kb.md`.
**Confidence: HIGH** — direct file scan.

---

## 9. Optimization Plan

### 9.1 Executive Summary

This is **the smallest and lowest-maintenance project of the 4 audited** — no project-local skills, no project-local commands, no project-local workflows. It is primarily a build/maintenance metadata holder; the vault content (where real ingestion/query workflows live) is in a SIBLING repo (`knowledge-bases/pe-kb-vault/`), out of audit scope. The CLAUDE.md is 33 lines — the leanest in the audit set.

The findings cluster cleanly into **just two areas**:

1. **`Read()` deny gaps on the frozen Phase 0 pipeline** (~400KB / 12 files including explicit `v1` versioned files) plus a **pattern-miss bug** that leaves `logs/session-notes-archive-2026-04.md` exposed. The pipeline artifacts have been frozen since mid-April and are no longer load-bearing; per-file denies are the right shape.

2. **Operator-side model-tier discipline** — the 2026-04-29 telemetry entry recorded a ~30–60% per-token cost overrun because a B.2 article-writing session ran on Opus when CLAUDE.md recommends Sonnet for KB ingestion. This is an operator-discipline issue, not infrastructure; the CLAUDE.md guidance is correct. Workspace-wide may benefit from a SessionStart hook that surfaces the recommended-model line.

Estimated avoidable waste: 5,000–11,000 tokens per accidental pipeline-artifact read (HIGH risk, ungated frequency); 30–60% per-token cost overrun on KB-ingestion sessions if Opus is selected (operator-side, MEDIUM).

### 9.2 Prioritized Recommendations

#### HIGH — Fix first

**R1: Add `Read()` deny rules for the frozen Phase 0 pipeline + fix archive pattern miss**

| Field | Content |
|---|---|
| **Issue** | `pipeline/` holds ~400KB / 12 frozen artifacts including explicit `v1` versioned files. `logs/session-notes-archive-2026-04.md` is not caught by the `Read(**/*.archive.*)` pattern (infix vs suffix). |
| **Evidence** | Section 6.1, 6.2; settings.json `permissions.deny`. |
| **Waste mechanism** | Accidental Glob/Grep/Read can load any of 12 pipeline files (5–11K+ tokens each). Archive log can also be loaded. |
| **Estimated savings** | HIGH — 5,000–11,000 tokens per accidental read; risk does not decay since pipeline is frozen permanently. |
| **Implementation steps** | Add to `projects/obsidian-pe-kb/.claude/settings.json` `permissions.deny`: `"Read(pipeline/implementation-spec.md)"`, `"Read(pipeline/implementation-spec-v1.md)"`, `"Read(pipeline/project-plan.md)"`, `"Read(pipeline/technical-spec.md)"`, `"Read(pipeline/architecture.md)"`, `"Read(pipeline/architecture-v1.md)"`, `"Read(pipeline/session-guide.md)"`, `"Read(pipeline/context-pack.md)"`, `"Read(pipeline/repo-snapshot.md)"`, `"Read(pipeline/implementation-log.md)"`, `"Read(pipeline/test-results.md)"`, `"Read(pipeline/decomposition-plan.md)"`, `"Read(logs/*archive*.md)"` (broader glob — catches both infix and suffix), `"Read(reports/repo-health-report*.md)"`, `"Read(reports/decomposition-audit-pass*-2026-04-*.md)"`. Keep `pipeline/pipeline-state.md`, `pipeline/decisions.md`, `pipeline/next-vault-session-runbook.md` readable. |
| **Risk** | LOW — explicit per-file denies; only frozen content blocked. |
| **Dependencies** | None |
| **Category** | Quick win (15-line JSON edit) |

---

#### MEDIUM — Plan next session

**R2: Add a SessionStart hook (workspace-wide) that surfaces the recommended model tier**

| Field | Content |
|---|---|
| **Issue** | The 2026-04-29 KB-ingestion session ran on Opus despite CLAUDE.md recommending Sonnet — ~30–60% per-token cost overrun on the article-writing portion. Operator-discipline issue; the CLAUDE.md guidance is correct but not surfaced at session start. |
| **Evidence** | `logs/usage-log.md` 2026-04-29 entry. |
| **Estimated savings** | MEDIUM — 30–60% cost reduction on KB-ingestion sessions if the recommendation is honored. Frequency: depends on KB ingestion cadence (currently dormant; may resume). |
| **Implementation steps** | Add a SessionStart hook that reads the active CLAUDE.md (project-level), extracts the `## Model Selection` section's "Recommended posture" line, and prints it as a systemMessage. Apply workspace-wide via the ai-resources hook mechanism so all projects benefit. |
| **Risk** | LOW — advisory print only; no behavioral enforcement. |
| **Category** | Structural change (workspace-level) |

---

**R3: Add the permission-sanity SessionStart hook to this project**

| Field | Content |
|---|---|
| **Issue** | This project has only 1 SessionStart hook (`auto-sync-shared.sh`). Other projects (axcion-ai-system-owner, ai-development-lab) also have `check-permission-sanity.sh`. This project missed the second hook. |
| **Evidence** | Section 5.1; diff against other projects' settings.json. |
| **Estimated savings** | LOW — permission-sanity is a workflow discipline hook, not a token saver directly. But consistency matters; the hook is small. |
| **Implementation steps** | Copy the second SessionStart hook block from `projects/axcion-ai-system-owner/.claude/settings.json` to this project's settings.json. |
| **Risk** | LOW |
| **Category** | Quick win |

---

**R4: Sync ai-resources rich hook coverage (carryover from cross-audit)**

Same recommendation as ai-development-lab R4 and axcion-ai-system-owner S5.4. Workspace-wide decision: add PreToolUse, PostToolUse, Stop hooks from ai-resources to all project settings. Affects this project too.

---

#### LOW — Opportunistic

**R5:** Tail-read `session-notes.md` (4,160 lines, 34KB) for wrap-time append. Cross-project; handled by ai-resources R6 (`/wrap-session` skill fix). When that ships, this project benefits automatically.

**R6:** Set `MAX_THINKING_TOKENS=10000` in this project's settings.json for consistency with ai-resources.

**R7:** Add 2-line Compaction section to project CLAUDE.md naming "current KB ingestion batch" and "next-vault-session-runbook" as items to preserve during `/compact`. Optional — only if telemetry shows context spikes during batch writes.

**R8:** Run `/usage-analysis` after the next session to refresh the telemetry baseline (currently 2 entries, ~1 month old).

### 9.3 Safeguard Proposals

**S1: Per-file `Read()` deny set (implements R1)** — see R1. Pipeline is frozen and will not change; deny set is set-and-forget.

**S2: SessionStart model-tier nudge hook (implements R2)** — workspace-wide hook that reads project CLAUDE.md's recommended-posture line at session start.

### 9.4 Implications for Future Opus 4.7 Upgrade

- **R1 (deny rules) is model-agnostic** but protects more aggressively at higher per-token costs.
- **R2 (model-tier nudge) becomes higher-priority** at Opus 4.7 — the cost of an operator-side tier mismatch scales with model price. A Sonnet→Opus mistake on a 50-article ingestion run is the kind of single mistake that justifies the hook.
- **The project's CLAUDE.md correctly avoids the `"model"` field** in settings.json and the "default model" assertion in CLAUDE.md text — model upgrades resolve automatically.

### 9.5 Assumptions and Gaps

- **Telemetry is very sparse** (2 entries, ~1 month old). The 2 logged sessions are representative of the project's two phases (resume-audit and B.2 article writing). Other modes (vault setup, KB query, decomposition) may have additional patterns not captured.
- **Vault content is out of scope.** The actual KB ingestion/query workflows run at `knowledge-bases/pe-kb-vault/` and were not audited. Recommendations here apply only to the build/maintenance metadata in this project.
- **MCP servers not observable** from repo settings.
- **The 2026-04-29 model-tier overrun is operator-side** — recommendations focus on infrastructure nudges, not discipline enforcement.

---

## 10. Self-Assessment

**1. Audit token cost:** `/cost` not available. Smallest audit of the 4 — only 1 subagent dispatch (Section 6). Estimated main-session context growth: ~20,000–30,000 tokens.

**2. Protocol gaps encountered:**
- **Section 4 at "no project-local workflows" scope.** This project has 0 project-local commands or workflows. The protocol's Section 4 doesn't explicitly address "no workflows to audit"; handled with a 1-paragraph N/A note. Protocol could add: "If 0 project-local workflows are identified, mark Section 4 as N/A with a one-paragraph note pointing to the ai-resources audit for inherited workflow analysis."
- **Cross-project hook coverage pattern.** This is the third project audited today with the same MEDIUM finding about missing ai-resources hook coverage. The protocol audits per-project; the underlying decision is workspace-wide. Worth noting as a meta-finding for the consolidated summary.

**3. Confidence ratings:**

| Section | Confidence | Basis |
|---|---|---|
| 0. Pre-Flight | HIGH | Direct read |
| 1. CLAUDE.md | HIGH | Direct measurement + full content read |
| 2. Skill Census | HIGH | Trivially confirmed (0 skills) |
| 3. Command Census | HIGH | Trivially confirmed (0 project-local commands) |
| 4. Workflow Audit | HIGH | Trivially confirmed (0 project-local workflows) |
| 5. Session Patterns | HIGH (config) / LOW (behavior recurrence) | 2 sparse usage-log entries |
| 6. File Handling | HIGH | Direct file scan |
| 7. Missing Safeguards | HIGH | Verified |
| 8. Best Practices | HIGH | Verified |
| 9. Optimization Plan | HIGH | Cross-section synthesis |

**4. Threshold-boundary findings:** None. All findings comfortably above or below severity thresholds.

---

