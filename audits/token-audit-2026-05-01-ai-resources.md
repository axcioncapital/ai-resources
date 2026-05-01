# Token Audit — 2026-05-01

Scope: ai-resources repo
AUDIT_ROOT: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources
Previous audit: token-audit-2026-04-24-ai-resources.md (7 days prior)

---

## 0. Pre-Flight Summary

- **0.1** `/cost`, `/context` not available in this execution environment.
- **0.2** session-usage-analyzer telemetry available at `logs/usage-log.md`.
- **0.3 Read(pattern) deny rule verdict: MEDIUM** (improved from 2026-04-24 — coverage expanded from 1 deny pattern to 5).
  - Covered: `archive/**`, `logs/*-archive-*.md`, `inbox/archive/**`, `**/deprecated/**`, `**/old/**`
  - Still uncovered: `audits/`, `reports/`, full `logs/`, full `inbox/`
  - Full notes: `audits/working/audit-working-notes-preflight.md`

---

## 1. CLAUDE.md Audit

**Files found (2):**
- `./CLAUDE.md` (root)
- `./workflows/research-workflow/CLAUDE.md` (workflow scope, loaded only in that workflow)

| File | Lines | Words | Est. tokens (×1.3) | Sections |
|---|---|---|---|---|
| Root CLAUDE.md | 92 | 950 | ~1,235 | 14 |
| Workflow CLAUDE.md | 128 | 1,140 | ~1,482 | — |

**Per-session cost:** Root CLAUDE.md ≈ 1,235 tokens per turn. Over a 30–50 turn session ≈ 37,000–62,000 tokens spent on CLAUDE.md loading alone. Workflow CLAUDE.md only loads when working in `workflows/research-workflow/`.

**Assessments:**
1. **Size:** PASS — 92 lines is well under Anthropic's 200-line guideline.
2. **Essentials-only:** Root CLAUDE.md content is workspace-level (not session-type-specific). Pointer to `harness-rules.md` defers conditional content correctly.
3. **Skill-eligible content:** None. Content is cross-cutting workspace policy.
4. **Redundancy with skills:** None observed. Some sections duplicate workspace-level CLAUDE.md (e.g., commit rules) by design — repeated as fallback for sessions opened without parent workspace context.
5. **Compaction instructions:** Present (`## Compaction` section).
6. **Aspirational vs. behavioral:** All behavioral. No "we value X" prose.

**Findings:** None at HIGH/MEDIUM severity. PASS.

---

## 2. Skill Census

**Total skills:** 73 (17,277 lines, ~197,791 tokens across all skills)

**Findings:** 10 total — 3 HIGH, 5 MEDIUM, 2 LOW

| Tier | Skills | Notes |
|---|---|---|
| HIGH | answer-spec-generator (487 lines), research-plan-creator (466 lines), ai-resource-builder (415 lines, 3-mode skill) | Oversized; load full content on every invocation |
| MEDIUM | evidence-to-report-writer (334), workflow-evaluator (318), ai-prose-decontamination (5,658 tokens), chapter-prose-reviewer vs prose-compliance-qc ambiguity, 8 vague descriptions | |
| LOW | Frontmatter gaps (3% of skills), file duplication in reference copies | |

**Annual waste estimate:** ~46,000–50,000 tokens/year recoverable (combining HIGH skill splits).

**Boundary-case skills (±15% of threshold):** evidence-to-report-writer, workflow-evaluator, ai-prose-decontamination — flagged low-confidence in Section 10.

**Delta vs. 2026-04-24:** answer-spec-generator (was 485 → now 487) and ai-resource-builder (was 401 → now 415) both grew slightly. research-plan-creator newly flagged at HIGH. H3 from prior audit (split multi-mode skills) is still pending.

Full notes: `audits/working/audit-working-notes-skills.md`

---

## 3. Command File Census

**Total command files:** 43 in root `.claude/commands/`, +14 in `workflows/research-workflow/.claude/commands/` = 57 total

**Top 5 by size (root commands):**
| Command | Lines |
|---|---|
| new-project.md | 527 |
| friday-checkup.md | 390 |
| deploy-workflow.md | 353 |
| permission-sweep.md | 323 |
| repo-dd.md | 314 |

**Cost note:** Slash-command files load only when invoked, not per-turn. Larger commands (e.g., `new-project.md`) cost their content tokens once per invocation. None of the top 5 read external files at >100 lines (they reference paths, not load content).

**Findings:** None at HIGH severity. Top commands are appropriately heavyweight for their orchestration role. **MINOR:** `new-project.md` at 527 lines is large enough that splitting Stage 0–2 vs Stage 3–6 into a referenced runbook would reduce per-invocation cost (~25–30% savings on that command). Defer until usage frequency justifies.

---

## 4. Workflow Token Efficiency

**Active workflows:** `workflows/research-workflow/` (primary). No other workflow directories present in ai-resources scope.

**Carry-forward from 2026-04-24:** H1 finding identified 3 sub-pipeline subagent returns (produce-prose-draft Phase 3, produce-formatting Phase 2, produce-formatting Phase 3) returning 60–200+ line findings to main session.

**Delta check:** 20+ workflow command files modified since 2026-04-24 (per `git log`). Spot check on `produce-prose-draft.md` and `produce-formatting.md` recommended in a dedicated re-audit; not re-measured this run to keep audit cost bounded per operator's mixed-tier scope.

**Standing finding:** H1 (Rework research-workflow prose-pipeline subagent returns to output-to-disk pattern) — **carried forward at HIGH severity until verified in a dedicated workflow re-audit.**

---

## 5. Session Patterns & Configuration

**Session telemetry:** Available — `logs/usage-log.md` (323 lines, up from 122 on 2026-04-24, indicating active telemetry capture).

**Configuration audit:**

| Setting | Current value | Verdict |
|---|---|---|
| Default model | Sonnet 1M (declared in project CLAUDE.md) | PASS |
| MAX_THINKING_TOKENS | **10000** (set in `.claude/settings.json` env) | **PASS — RESOLVED from 2026-04-24 M1 finding** |
| Autocompact threshold | not set (default) | LOW — recommendation pending |
| MCP servers | Google Drive (active per system context); workspace-level | OK |
| Hooks (PreToolUse/PostToolUse/Stop/SessionStart) | 14 hooks active in `.claude/hooks/` | PASS — used for nudges, dedup, telemetry |
| CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING | not set in ai-resources `.claude/settings.local.json` | OK — ai-resources is execution-tier; project CLAUDE.md does not require override |

**Delta vs. 2026-04-24:** MAX_THINKING_TOKENS finding M1 (1-line settings.json add) **resolved**. Telemetry capture rate increased materially (323/122 ≈ 2.6× the entries).

---

## 6. File Handling Patterns

**Read(pattern) deny-rule status (from Step 0.3):** MEDIUM (improved from HIGH in earlier audits, partial improvement from 2026-04-24).

**Currently covered:** `archive/**`, `logs/*-archive-*.md`, `inbox/archive/**`, `**/deprecated/**`, `**/old/**`

**Still uncovered:** `audits/**`, `reports/**`, full `logs/`, full `inbox/`

**Standing findings:**
- **MEDIUM** — `audits/**` directory accumulates ~13 prior audit reports + working notes (~76k tokens). Broad Glob/Grep can still pull these into context.
- **MEDIUM** — `reports/**` similar accumulation pattern.
- **LOW** — `usage/usage-log.md` orphan (227 lines from 2026-04-18 pre-migration) **still present**. Canonical at `logs/usage-log.md` (323 lines).

**Recommendation:** Add `Read(audits/**)`, `Read(reports/**)` to root settings (1-line each). Delete `usage/usage-log.md`.

---

## 7. Missing Safeguards

| Safeguard | Status | Severity if missing |
|---|---|---|
| `Read(pattern)` deny rules | **Partial** (MEDIUM verdict) | HIGH if Absent |
| Custom compaction instructions in CLAUDE.md | Present | — |
| Subagent output-to-disk pattern | Present (codified in `## Subagent Contracts`) | — |
| Context window monitoring instructions | Present (Session Guardrails `[COST]` flag, `[HEAVY]` flag) | — |
| Session boundaries for workflows | Present (`## Session Boundaries`, `## Compaction`) | — |
| Model selection guidance | Present (Model Tier, Model Escalation, Adaptive Thinking Override) | — |
| File read scoping | Partial — relied on agent judgment, not explicit rule | LOW |
| Output length constraints | Present in CLAUDE.md "Tone and style" + skills | — |
| Effort-level guidance | Present (operational frontmatter, agent-tier table) | — |
| Hook-based output truncation | Not implemented | LOW |
| Audit/output artifact isolation | Partial — `audits/` and `reports/` dirs exist but lack `Read()` deny coverage (from §6) | MEDIUM |

---

## 8. Best Practices Comparison

| # | Practice | Status | Priority |
|---|---|---|---|
| 1 | CLAUDE.md under 200 lines | Implemented (92 lines) | — |
| 2 | Read(pattern) deny rules configured | Partial (5 of 9 expected dirs covered) | MEDIUM |
| 3 | Skills use on-demand loading | Implemented | — |
| 4 | Subagents for heavy reads | Implemented (codified) | — |
| 5 | Strategic /compact at breakpoints | Implemented (`## Compaction`) | — |
| 6 | /clear between unrelated tasks | Implemented (`## Session Boundaries`) | — |
| 7 | Model selection per task type | Implemented (Model Tier table) | — |
| 8 | Extended thinking budget controlled | **Implemented (NEW: MAX_THINKING_TOKENS=10000)** | — |
| 9 | Unused MCP servers disabled | Not observable from repo context | — |
| 10 | Output-to-disk pattern for subagents | Implemented (codified in `## Subagent Contracts`) | — |
| 11 | Precise prompts over vague ones | Partial — guidance in skills, no centralized rule | LOW |
| 12 | Session notes pattern | Implemented (Prime, /wrap-session) | — |

**Maturity:** 9 fully implemented, 2 partial, 1 not observable. **Significant improvement** from 2026-04-24 (8 fully implemented at that time).

---

## 9. Optimization Plan

### 9.1 Executive Summary

ai-resources continues to mature. Two findings from 2026-04-24 were resolved or partially resolved: MAX_THINKING_TOKENS=10000 is now set (M1 closed), and `Read(pattern)` deny coverage expanded from 1 pattern to 5 (H2 partially closed). Skill bloat persists — 3 HIGH-tier oversized skills, with answer-spec-generator and research-plan-creator both >450 lines. The research-workflow subagent-return refactor (H1 from prior audit) is the highest-value carry-forward and warrants a dedicated session. The MEDIUM `Read(audits/**)` and `Read(reports/**)` gaps are quick wins (1-line edits each).

### 9.2 Prioritized Recommendations

#### HIGH

**H1 (carried forward) — Rework research-workflow prose-pipeline subagent returns to output-to-disk.** Same as 2026-04-24 H1; no progress observed. Schedule a dedicated session.

**H2 — Split answer-spec-generator (487 lines) and research-plan-creator (466 lines) into per-mode SKILL.md.** Annual savings ~33,000 tokens combined. Structural change.

#### MEDIUM

**M1 — Add `Read(audits/**)` and `Read(reports/**)` to `.claude/settings.json`.** 1-line each; closes the H2-residual gap from 2026-04-24. Quick win.

**M2 — Split ai-resource-builder (415 lines, 3 modes) into per-mode skills.** ~3,375 tokens/year savings. Structural change.

**M3 — Address ai-prose-decontamination (5,658 tokens) — content review for compaction.** Boundary-case finding (±15% threshold).

#### LOW

**L1 — Delete orphan `usage/usage-log.md` (227 lines, pre-migration artifact).** Quick win (1 command).

**L2 — Add `Autocompact threshold` setting if a tested optimum exists.** Low certainty; gather telemetry first.

### 9.3 Safeguard Proposals

- **Settings hardening:** Promote the `permission-sweep` workflow's `Read()` patterns from workflow-scope to root `.claude/settings.json`. Current root has 5 patterns; could grow to 7 by adding `audits/**`, `reports/**`.
- **Skill split convention:** Add a check to `/create-skill` that flags skills above 300 lines for split-pattern review at creation time.

### 9.4 Implications for Future Opus 4.7 Upgrade

- HIGH-tier skill splits reduce per-invocation cost — same Opus 4.7 dollar value as Sonnet, but the relative savings is greater because of the higher per-token cost.
- H1 (workflow subagent return refactor) — Opus 4.7 cost amplifies main-session bloat; this fix becomes more load-bearing on the upgraded model.
- MAX_THINKING_TOKENS=10000 should be re-tuned post-upgrade (Opus 4.7 may benefit from higher budgets on judgment work).

### 9.5 Assumptions and Gaps

- Section 4 (workflow audit) was not re-measured this run; H1 carried forward unchanged. Operator informed; bounded scope per mixed-tier checkup.
- Telemetry-driven validation of skill-split savings is not yet feasible (insufficient pre/post comparison data).
- ADAPTIVE_THINKING override status not deeply audited; ai-resources is execution-tier so the omission is consistent with project policy.

---

## 10. Self-Assessment

1. **Audit token cost:** `/cost` not available in this execution environment. Section 4 was not re-measured to bound cost.
2. **Protocol gaps:** None new since v1.2.
3. **Confidence ratings:**
   - Section 0 (Pre-Flight): HIGH (direct file/config evidence)
   - Section 1 (CLAUDE.md): HIGH
   - Section 2 (Skill Census): HIGH (subagent-measured)
   - Section 3 (Command Census): HIGH
   - Section 4 (Workflow): MEDIUM (not re-measured this run; carry-forward from prior audit)
   - Section 5 (Sessions/Config): HIGH
   - Section 6 (File Handling): HIGH
   - Section 7 (Missing Safeguards): HIGH
   - Section 8 (Best Practices): HIGH
4. **Threshold-boundary findings:** `evidence-to-report-writer` (334 lines), `workflow-evaluator` (318 lines), `ai-prose-decontamination` (5,658 tokens) — all within ±15% of MEDIUM/HIGH boundaries. May reclassify under a real tokenizer.

---

