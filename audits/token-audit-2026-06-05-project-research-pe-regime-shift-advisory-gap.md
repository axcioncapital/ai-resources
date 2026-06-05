# Token Usage Optimization Audit — projects/research-pe-regime-shift-advisory-gap

**Date:** 2026-06-05
**Scope:** `projects/research-pe-regime-shift-advisory-gap` (project-local)
**Protocol:** token-audit-protocol.md v1.3
**Previous audit (this scope):** None — first token audit at this scope.
**Cadence:** Friday-checkup diagnostic run — REVIEW-ONLY, not committed.

**Token-estimation caveat:** Counts are word × 1.3, a proxy with ±30% plausible drift vs. a real tokenizer. Severity thresholds are approximate; findings within ±15% of a threshold are noted in Section 10.

**Execution note:** No Task/agent-dispatch tool was available in this execution environment, so Sections 2, 4, and 6 (normally delegated to `token-audit-auditor-mechanical` / `token-audit-auditor`) were run inline using the batch-measure-then-selective-deep-read pattern. Read discipline was preserved; no full-file reads beyond the key pipeline command files.

---

### 0. Pre-Flight

**0.1 Baseline metrics:** `/cost` and `/context` not available in this execution environment. Non-blocking.

**0.2 Session telemetry:** `session-usage-analyzer` skill exists (`ai-resources/skills/session-usage-analyzer/SKILL.md`). Project usage log at `logs/usage-log.md` holds **1 entry** (2026-06-03, verdict "Efficient", no recommendation, 10-subagent fan-out judged prescribed not wasteful). Single data point — no comparison baseline. The `usage/` directory contains only `.gitkeep` (the canonical log lives in `logs/`).

**0.3 Read(pattern) deny-rule coverage — verdict: MEDIUM.**
Settings file: `.claude/settings.json` (no `settings.local.json`).
`permissions.deny` Read entries:
- `Read(archive/**)`
- `Read(**/*.archive.*)`
- `Read(logs/*-archive-*.md)`
- `Read(**/deprecated/**)`
- `Read(**/old/**)`

Covered: `archive/`, `deprecated/`, `old/`, archive-suffixed files, archived logs.
Expected but **missing**: `audits/`, live `logs/` (only `-archive-` subset denied), `reports/`, `output/`. All four directories exist and hold large generated content (see Section 6). More than 2 expected directories uncovered → **MEDIUM**.

**0.4 Output file:** This report, built incrementally.

---

### 1. CLAUDE.md Audit

**File:** `CLAUDE.md` (project-level)
**Line count:** 149
**Estimated tokens:** ~2,533 (1,949 words × 1.3)
**Headings:** 20 (19 H2 blocks)
**Subdirectory CLAUDE.md files:** none (only the project root file)
**Compaction instructions:** present (4 mentions)

**Per-session cost:** ~2,533 tokens every turn → ~76,000 tokens over a 30-turn session, ~127,000 over 50 turns.

**This section cites the dedicated CLAUDE.md audit run earlier this cycle** (`audits/claude-md-audit-2026-06-05-project-research-pe-regime-shift-advisory-gap.md`) rather than re-deriving. Headline verdict from that audit:

- **Findings: HIGH 5 / MED 6 / LOW 3.** Projected savings if HIGH+MED applied: **~1,150 tokens/turn (~45% of the file)** ≈ 34,500/session at 30 turns.
- The file is ~5× the ~500-token external-guidance target and breaches the behavior-only / ~80%-of-turns test in roughly half its blocks.

**Findings (carried from the claude-md audit — token relevance only):**

| # | Finding | Severity | Lines | Recommendation |
|---|---------|----------|-------|----------------|
| 1 | `Project Context` (~520t) reference-grade depth (nine-part architecture, evidence-calibration) duplicates `reference/stage-instructions.md` / `quality-standards.md` | HIGH | block | Trim to short orientation + pointer |
| 2 | `Project Config` (~430t) — 120-word prose preamble wraps a 13-field block; prose restates `docs/project-config-schema.md`, fires only on Stage-5 commands | HIGH | block | Keep fenced fields, drop prose to pointer |
| 3 | `Input File Handling` (~430t) duplicates workspace `File Write Discipline` (a 2-line pointer) + carries a **stale self-reference** to a workspace section that no longer exists | HIGH | block | Compress to pointer + one bright-line |
| 4 | `Commit Rules` duplicates workspace `Commit behavior`/`Push behavior` AND carries **stale push semantics** ("do not push / manual operator step" = pre-2026-05-29 inverted rule) that contradicts the canonical gated-push rule | HIGH | block | Replace with pointer; fixes a behavioral contradiction, not just tokens |
| 5 | Misplaced workflow-methodology blocks (`Skill Dependency Chain`, `Workflow Status Command`, `Utility Commands`, `Autonomy Rules` tag table) | MED | blocks | Move to `reference/stage-instructions.md` / command frontmatter |

Note finding #4 is a token win **and** a correctness fix — the stale block silently corrupts wrap-session push behavior. Treat as the priority CLAUDE.md edit.

---

### 2. Skill Census (scope-relevant)

**Repo-wide total:** 91 SKILL.md files (the canonical library lives in `ai-resources/skills/`; this project references them via symlinked commands, it does not own them). A project-scope audit measures the skills the pipeline actually invokes, not the whole library.

**Size distribution (repo-wide, top of distribution):**
- Over 300 lines: 6 skills (`session-governor` 795L, `answer-spec-generator` 487L, `research-plan-creator` 466L, `failure-mode-detector` 437L, `ai-resource-builder` 432L, `ai-prose-decontamination` 411L)
- 150–300 lines: ~30 skills
- Under 150: the remainder

**Pipeline-invoked skills (from run-* command bodies) — largest:**

| Skill | Lines | Words | Note |
|-------|-------|-------|------|
| `evidence-to-report-writer` | 393 | 4,206 | Stage 4 chapter draft — loaded per chapter via subagent (isolated context, not main session) |
| `cluster-memo-refiner` | 324 | 3,401 | Stage 3 — subagent |
| `citation-converter` | 286 | 3,014 | Stage 4 — subagent |
| `section-directive-drafter` | 280 | 2,815 | Stage 4 analysis — subagent (per cluster) |
| `research-prompt-creator` | 251 | 4,642 | Stage 2 — subagent |

**Assessment:** Every large pipeline skill is loaded **inside a subagent** (the run-* commands read the SKILL.md and pass its content to a dispatched sub-agent), so the skill body never sits in the main session beyond the dispatch turn. This is the correct on-demand pattern; the >300-line sizes are a library-quality concern (belongs to an `ai-resources`-scope audit), **not** a project-scope token drain. No project-scope HIGH/MED skill findings. The 6 over-300-line skills are flagged LOW here and deferred to the canonical-library audit.

**Description quality / frontmatter / redundancy:** Not re-assessed at project scope — these are properties of the canonical library, owned by the `ai-resources` token audit. No project-local skills exist (`.claude/skills/` in the *project* holds none; the `session-governor`/`failure-mode-detector` etc. above are workspace-root `.claude/skills/`, outside this audit root).

---

### 3. Command File Census

**Total commands in `.claude/commands/`:** 89 — **69 symlinks** to `ai-resources/.claude/commands/` (canonical, shared) + **20 real project-local files** (the research pipeline).

The 69 symlinks cost nothing extra at project scope: they resolve to canonical files audited at `ai-resources` scope, and a command file only enters context when invoked. The project-owned 20 are the audit surface here.

**Project-local command files:**

| Command | Lines | Words | Loads external context? | Est. cost when invoked |
|---------|-------|-------|-------------------------|------------------------|
| produce-prose-draft | 242 | 2,969 | refs skills + reference docs by path | ~3,850t self |
| run-execution | 191 | 2,261 | reads SKILL.md + extracts into subagents | ~2,940t self |
| run-analysis | 199 | 1,665 | subagent-delegated reads | ~2,165t self |
| produce-formatting | 154 | 2,262 | path-passed style refs | ~2,940t self |
| run-report | 117 | 1,582 | subagent-delegated + path carve-out | ~2,055t self |
| run-sufficiency | 129 | 1,295 | subagent-delegated | ~1,685t self |
| produce-architecture | 101 | 1,345 | path-passed | ~1,750t self |
| audit-structure | 148 | 1,018 | — | ~1,325t self |
| run-preparation | 70 | 608 | subagent | ~790t self |
| run-cluster | 48 | 513 | subagent | ~667t self |
| run-synthesis | 52 | 523 | subagent | ~680t self |
| intake-reports | 51 | 492 | reads raw reports verbatim (opus) | ~640t + raw report payload |
| (8 smaller: produce-jargon-gloss, produce-knowledge-file, review-chapter, verify-chapter, workflow-status, create-context-pack, inject-dependency, status) | <100 each | — | mostly subagent/path | <1,300t each |

**High-cost commands (>500 tokens external context):** None load large files *into the main session*. Every run-* command reads SKILL.md content and passes it to a dispatched sub-agent (the command body explicitly says "Launch a sub-agent. Pass it: the skill content…"), so the skill payload lands in the subagent's context, not main. The one exception is the **intake path** (`intake-reports` + `run-execution` Step 2.2b), which reads raw research reports (~5K words each) verbatim into the main session — but this is a fidelity requirement (opus-pinned, no summarization), and the reports are immediately written to disk, then downstream steps consume them via subagents.

**Redundant / cascading loading:** No double-loading of CLAUDE.md content observed. The run-* commands form a clean cascade (preparation → execution → cluster → sufficiency → analysis → synthesis → report) where each stage hands off via disk artifacts + checkpoints, not via context carry. `/compact` breakpoints are placed between stages.

---

### 4. Workflow Token Efficiency (HIGH-VALUE SECTION)

**Workflows identified (the research pipeline):** `run-preparation` → `run-execution` (Stage 2) → `run-cluster` + `run-sufficiency` (Stage 3 Pass 3) → `run-analysis` + `run-synthesis` (Stage 4 Pass 4) → `run-report` (Stage 4 production). Plus the `intake-reports` raw-report entry path and `produce-*` finishing commands. Audited the four highest-reference: **run-report, run-execution, run-analysis, intake-reports.**

All estimates are **structural inferences** from command instructions and file-loading patterns — only 1 telemetry data point exists (Section 0.2).

#### Workflow: run-report (Stage 4 chapter production — the core of this project)

**Architecture (from the command body):** Fully subagent-driven. Step 4.0 loads inputs; Step 4.1 (architecture) + 4.1b (QC) delegate; Step 4.2 runs a per-chapter loop where each chapter goes through draft (a) → review (b) → compliance-QC (c) → write/checkpoint (d) → operator pause (e) → revision-applier (f) → citation-converter (j), every stage a separate sub-agent.

**Strengths (no findings):**
- Subagents write to disk and return summaries/checkpoints, not full prose into main session.
- `/compact` breakpoints after each chapter and after the architecture/QC steps.
- Explicit **per-dispatch model pinning** (`opus`/`sonnet` aliases at 200K) to clear the 1M-context credit gate — a deliberate token/cost safeguard.
- **Path-passing carve-out (FX-C1):** reference docs (`quality-standards.md`, `style-guide.md`) passed by PATH not content, so the same reference isn't injected N×3 across the chapter loop. This is exactly the right token-economy move.

**Finding 4-A (HIGH — but a write-churn / process cost, not main-session context):** The PostToolUse Write hook auto-commits every artifact under `report/` (and `preparation|execution|analysis`). Combined with the heavily subagent-driven per-chapter loop, this produces a large volume of `Auto-commit [report]: …` intermediate commits — **41 of the last 50 commits** in this repo are hook auto-commits. This already caused a documented defect: the `citation-converter` subagent read the git log and **misclassified hook-generated intermediate commits as "prior session" output**, leading to wrong inferences about what the current session produced (friction-log line 428; no artifact harm, operator-verified). Waste mechanism: any subagent given git-log tool output must wade through and reason about dozens of auto-commit lines, and at least one did so incorrectly.

#### Workflow: run-execution (Stage 2)

**Architecture:** Subagent-driven (manifest → prompts → QC → extract creation → extract verification), disk-first, `/compact` after each step. Parallel sub-agents for independent sessions.

**Finding 4-B (MEDIUM):** The raw-report intake (Step 2.2b, shared with `intake-reports`) reads operator-pasted Research Execution GPT / Perplexity output verbatim into the main session. Per friction-log line 97, this path reliably corrupts UTF-8 (€, en/em dashes, Nordic diacritics → mojibake) and requires **manual per-file repair on every one of 7 sessions** — re-done by hand each intake. Waste mechanism is operator-time + rework turns, not raw token loading (the verbatim read is a correctness requirement). The intake path lacks a built-in encoding-normalization step. Note: the verbatim read itself is **necessary** (opus-pinned, fidelity-critical) and correctly disk-routed afterward — not a delegable read.

#### Workflow: run-analysis (Stage 4 analysis)

**Architecture:** Subagent-driven (gap assessment → section directives per cluster → memo review → editorial recs → QC → auto-approve). `/compact` after each step. Step 5d auto-delegates editorial approval (no operator pause) — a deliberate turn-saver. No findings — clean disk-first pattern.

#### Workflow: intake-reports

Covered under 4-B (same Step 2.2b path). Opus-pinned, verbatim, disk-routed. Correct fidelity posture; encoding-normalization gap is the only issue.

**Section 4 findings table:**

| # | Finding | Severity | Waste mechanism | Recommendation |
|---|---------|----------|-----------------|----------------|
| 4-A | Hook auto-commit churn (41/50 commits) pollutes git log; subagents reading git log mis-scope current vs prior work | HIGH | Subagent reasoning over dozens of `Auto-commit` lines; one documented misclassification | Filter `Auto-commit ` prefix in any subagent given git-log scope (e.g., citation-converter Step 0); OR squash/quiet hook commits |
| 4-B | Raw-report intake lacks encoding-normalization; manual UTF-8 repair every intake (7× this section) | MEDIUM | Per-file manual repair, rework turns | Add an encoding-normalization step (e.g., a sanitize pass) to the Step 2.2b intake before verbatim write |

---

### 5. Session Patterns & Configuration

**Session telemetry available:** Partial — 1 entry (see 0.2). Insufficient for trend analysis. All findings structural.

| Setting | Current value | Recommended | Impact |
|---------|--------------|-------------|--------|
| Default model | NOT SET in settings.json | (leave unset — workspace rule prohibits a model field) | Correct. Per-command frontmatter tiers (`model: sonnet` on run-*, `model: opus` on intake-reports) handle tiering. No action. |
| Subagent model | Per-dispatch override in run-report (opus/sonnet 200K) | Keep | Clears 1M-context credit gate; deliberate. No action. |
| MAX_THINKING_TOKENS | not set (`env: {}`) | 10,000 for routine; higher for analysis | LOW — workspace recommends `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING=1` in `settings.local.json` for analytical projects; this project has no `settings.local.json`. Minor. |
| Autocompact threshold | not set | 80% | Commands embed explicit `/compact` breakpoints, so reliance on autocompact is low. No action. |
| MCP servers active | not observable from repo context | — | n/a |

**Hooks (token implications):**
- **PostToolUse Write → auto-commit** — root cause of Finding 4-A. Also runs `log-write-activity.sh` + `detect-innovation.sh` on every Write/Edit (3 hooks per write). These are fast shell scripts (5–15s timeout), no context cost, but the auto-commit churn has the downstream git-log effect noted above.
- PreToolUse Edit → bright-line block (report prose guard) — correct safeguard, no token cost.
- SessionStart (4 hooks: checkpoint-load, template-drift, auto-sync-shared, check-archive) — inject small `additionalContext`/`systemMessage` strings; minor per-session cost.
- Stop (2): checkpoint + wrap reminders. UserPromptSubmit (1): decision logging.

No hook returns large output into context. The only token-relevant hook effect is indirect (git-log pollution → 4-A).

---

### 6. File Handling Patterns

**Read(pattern) deny-rule status (from 0.3): MEDIUM.**
Covered: `archive/`, `deprecated/`, `old/`, archived logs.
Missing expected coverage: `audits/`, live `logs/`, `reports/`, `output/`.

**Generated-content directory sizes (project):**

| Dir | .md files | Total words | Read-deny covered? |
|-----|-----------|-------------|--------------------|
| execution/ | 42 | ~104,900 | NO (raw-reports, extracts, manifests) |
| report/ | 85 | ~86,800 | NO (architecture, chapters, checkpoints) |
| analysis/ | 46 | ~72,400 | NO |
| logs/ | 43 | ~47,300 | only `-archive-` subset |
| preparation/ | 13 | ~22,600 | NO |
| reference/ | 16 | ~20,900 | NO (legitimately read — canonical inputs) |
| output/ | 4 | ~3,370 | NO |
| reports/ | 1 | ~1,300 | NO |

**Largest individual files:** `logs/session-notes.md` (11,034 words), `report/architecture/1.1/1.1-architecture.md` (8,349), `logs/session-notes-archive-2026-06.md` (6,899 — *this one IS archive-denied*), `logs/decisions.md` (5,188), seven `execution/research-extracts/1.1/*.md` (4,300–5,150 each), seven `execution/raw-reports/1.1/*.md` (4,350–5,060 each).

**Assessment:** `execution/`, `analysis/`, and `report/` hold ~264,000 words of generated/intermediate content across 173 files, none of it Read-deny-covered. These are intermediate pipeline artifacts (raw reports, extracts, cluster memos, chapter drafts, checkpoints) that a future session's Glob/Grep/Read could surface unnecessarily. `logs/session-notes.md` at 11K words is the single largest unguarded file Claude might read during exploration. The active `report/chapters/` and current-section `analysis/` are arguably "should read" during live pipeline work, but raw-reports, checkpoints, and prior-section artifacts are "should not."

**Findings:**

| # | Finding | Severity | Recommendation |
|---|---------|----------|----------------|
| 6-A | `execution/` (raw-reports, extracts, checkpoints — ~105K words) not Read-deny-covered | MEDIUM | Add `Read(execution/raw-reports/**)` and `Read(execution/checkpoints/**)` and `Read(**/checkpoints/**)` denies — these are never primary inputs |
| 6-B | `logs/` live files (session-notes 11K words, decisions 5K) readable during exploration | MEDIUM | Add `Read(logs/session-notes*.md)` deny (wrap-session reads it by explicit path, not exploration) |
| 6-C | `report/checkpoints/**` and `analysis/checkpoints/**` (~dozens of intermediate files) | LOW | Add `Read(**/checkpoints/**)` deny (single pattern covers all stages) |
| 6-D | No deprecated/draft clutter detected beyond what archive-denies already cover | — | None |

---

### 7. Missing Safeguards

| Safeguard | Status | Severity if missing | Recommendation |
|-----------|--------|---------------------|----------------|
| `Read(pattern)` deny rules covering stale/large dirs | **Partial** | HIGH | Extend denies to `execution/`, `logs/` live, `**/checkpoints/**`, `audits/`, `reports/`, `output/` (Section 6) |
| Custom compaction instructions in CLAUDE.md | **Present** | MED | CLAUDE.md has a Compaction block (overlaps workspace; see Section 1) |
| Subagent output-to-disk pattern | **Present** | — | All run-* commands write to disk + return summaries/checkpoints. Strong. |
| Context-window monitoring guidance | **Partial** | LOW | `/compact` breakpoints embedded in commands; no explicit `/context` guidance, but compaction is enforced structurally |
| Session boundaries for workflows | **Present** | — | Commands specify fresh-session prerequisites (e.g., run-report "expects a fresh session after run-synthesis") |
| Model selection guidance | **Present** | — | Per-command frontmatter + per-dispatch override; correct |
| File read scoping | **Present** | — | Subagents receive content not paths (context isolation); path carve-out for reference docs |
| Output length constraints | **Present** | — | Subagent returns are summaries/checkpoints |
| Effort-level guidance | **Absent** | LOW | No `/effort` config; low impact given compaction discipline |
| Hook-based output truncation | **Absent** | LOW | Hooks emit small strings only; no large-output hooks to cap |
| Audit/output artifact isolation | **Partial** | MED | Generated artifacts (`report/`, `execution/`, `analysis/`) not Read-deny isolated (Section 6) |

---

### 8. Best Practices Comparison (May 2026)

| # | Practice | Status | Gap | Priority |
|---|----------|--------|-----|----------|
| 1 | CLAUDE.md under 200 lines | Partial | 149 lines but ~2,533 tokens, ~5× target; ~45% trimmable (Section 1) | HIGH |
| 2 | Read(pattern) deny rules configured | Partial | Archive/deprecated covered; live generated dirs not (Section 6) | MEDIUM |
| 3 | Skills use on-demand loading | Implemented | Pipeline skills loaded inside subagents, never resident in main | — |
| 4 | Subagents for heavy reads | Implemented | Every run-* stage delegates; parallel for independent units | — |
| 5 | Strategic `/compact` at breakpoints | Implemented | Explicit `▸ /compact` markers between every stage/chapter | — |
| 6 | `/clear` between unrelated tasks | Implemented | Commands declare fresh-session prerequisites | — |
| 7 | Model selection per task type | Implemented | Frontmatter tiers + per-dispatch overrides (opus/sonnet 200K) | — |
| 8 | Extended thinking budget controlled | Not implemented | MAX_THINKING_TOKENS unset; no settings.local.json | LOW |
| 9 | Unused MCP servers disabled | Not observable | — | — |
| 10 | Output-to-disk for subagents | Implemented | Checkpoints + summaries, full output to disk | — |
| 11 | Precise prompts over vague | Implemented | Commands specify exact paths, fields, return shapes | — |
| 12 | Session notes pattern | Implemented | `logs/session-notes.md` + wrap-session ritual + SessionStart checkpoint load | — |
| 13 | Similar-trigger skills disambiguated | Not assessed (library-scope) | Owned by ai-resources audit | — |
| 14 | Agent/skill prompts use structured sections | Implemented (spot) | run-* commands use headed Step sections + delegate/QC tags | — |
| 15 | Few-shot examples where useful | Implemented (spot) | Commands embed verbatim-emit blocks and marker contracts | — |

This pipeline is, structurally, a strong implementation of token best-practices. The two real gaps are CLAUDE.md bloat (always-loaded, every turn) and Read-deny coverage of generated dirs.

---

### 9. Optimization Plan

#### 9.1 Executive Summary

This is the first token audit at this project's scope. The research pipeline itself is **well-engineered for token economy**: it is disk-first and subagent-driven end to end, every stage hands off via checkpoints rather than context carry, `/compact` breakpoints sit between stages, large skills load only inside subagents, and model tiering is pinned per dispatch (clearing the 1M-context credit gate). Sections 3–5 surface no main-session context drains in the pipeline design.

The token cost concentrates in two places. First, the **always-loaded project CLAUDE.md** — 149 lines but ~2,533 tokens, roughly 5× the external-guidance target, with ~45% trimmable per this cycle's dedicated CLAUDE.md audit (HIGH 5 / MED 6 / LOW 3). One of those HIGH items (`Commit Rules` stale push semantics) is also a behavioral-correctness bug that silently corrupts wrap-session push behavior, so it should be fixed regardless of token math. Second, **file-handling hygiene**: `execution/`, `analysis/`, `report/`, and live `logs/` hold ~264K words of intermediate generated content across ~170 files, none Read-deny-covered, so future-session exploration can surface them.

The largest *operational* drain is indirect: the PostToolUse auto-commit hook produces ~80% auto-commits in recent history (41/50), and a downstream subagent reading the git log already misclassified those intermediate commits as prior-session work. Estimated combined impact of the HIGH+MED recommendations: ~1,150 tokens/turn from CLAUDE.md trimming (~34,500/session) plus reduced exploration risk and one removed defect class.

#### 9.2 Prioritized Recommendations

**HIGH**

| Field | Content |
|---|---|
| **Issue** | Project CLAUDE.md is ~2,533 tokens, loaded every turn; ~45% is trimmable (duplication of workspace canon, reference-grade depth, misplaced workflow methodology). |
| **Evidence** | 149 lines / ~2,533 tokens; `audits/claude-md-audit-2026-06-05-project-research-pe-regime-shift-advisory-gap.md` (HIGH 5/MED 6/LOW 3). Biggest blocks: `Project Context` ~520t, `Project Config` ~430t, `Input File Handling` ~430t. |
| **Waste mechanism** | Per-turn always-loaded context. ~1,150 tok/turn recoverable. |
| **Implementation steps** | Apply the per-block verdicts in the claude-md audit: trim `Project Context` to orientation+pointer; reduce `Project Config` prose to a pointer over `docs/project-config-schema.md`; collapse `Input File Handling` to pointer + one bright-line; replace `Commit Rules` with a pointer; move workflow-methodology blocks to `reference/stage-instructions.md`. |
| **Estimated savings** | HIGH — ~1,150 tok/turn (~34,500/session at 30 turns). |
| **Risk** | Over-trimming a project-specific rule that has no workspace equivalent. Mitigate by keeping the project-delta lines the claude-md audit marks "partial-keep." |
| **Dependencies** | None. |
| **Category** | Structural change (separate edit session; do NOT execute here — diagnostic run). |

| Field | Content |
|---|---|
| **Issue** | `Commit Rules` block states the pre-2026-05-29 "do not push / manual operator step" rule, contradicting the canonical gated-push rule. |
| **Evidence** | claude-md audit Tier 3 (contradiction, HIGH); MEMORY.md `feedback_push_gated`. |
| **Waste mechanism** | Not tokens primarily — behavioral corruption of wrap-session push. Listed HIGH because it's a correctness bug plus a duplicate-block token cost. |
| **Implementation steps** | Replace the block with a one-line pointer to the workspace `Push behavior` / `Commit behavior` sections. |
| **Estimated savings** | HIGH (correctness) / LOW (tokens, ~110t). |
| **Risk** | None — aligns project to canon. |
| **Dependencies** | Folds into the CLAUDE.md-trim edit above. |
| **Category** | Quick win. |

| Field | Content |
|---|---|
| **Issue** | Hook auto-commit churn pollutes git log; subagents reading git log mis-scope current vs prior work. |
| **Evidence** | 41/50 recent commits are `Auto-commit [...]`; friction-log line 428 documents the citation-converter misclassification. |
| **Waste mechanism** | Subagents reason over dozens of auto-commit lines; one documented incorrect inference. |
| **Implementation steps** | In any subagent/command that reads git log (notably `citation-converter` Step 0), filter out lines matching `^[a-f0-9]+ Auto-commit `. OR change the PostToolUse hook to amend/quiet intermediate commits. The filter is the lower-risk option. |
| **Estimated savings** | HIGH (removes a defect class) / MED (tokens — fewer log lines reasoned over). |
| **Risk** | Filtering could hide a genuine commit if a real commit ever used the `Auto-commit` prefix (it doesn't — prefix is hook-reserved). Low. |
| **Dependencies** | None. |
| **Category** | Quick win (prefix filter) or Structural (hook change). |

**MEDIUM**

| Field | Content |
|---|---|
| **Issue** | Read-deny coverage missing for generated dirs (`execution/`, live `logs/`, `**/checkpoints/**`, `reports/`, `output/`). |
| **Evidence** | Section 6: ~264K words across ~170 files, none denied except archive subsets. |
| **Waste mechanism** | Future-session Glob/Grep/Read can surface intermediate artifacts unnecessarily. |
| **Implementation steps** | Add to `.claude/settings.json` `permissions.deny`: `Read(execution/raw-reports/**)`, `Read(execution/checkpoints/**)`, `Read(**/checkpoints/**)`, `Read(logs/session-notes*.md)`. Leave `report/chapters/` and current-section `analysis/` readable (live inputs). |
| **Estimated savings** | MEDIUM — avoids occasional large unintended reads. |
| **Risk** | Over-denying a path the pipeline legitimately reads. Mitigate by denying only raw-reports + checkpoints + session-notes, not active chapter/analysis dirs. |
| **Dependencies** | None. |
| **Category** | Quick win. |

| Field | Content |
|---|---|
| **Issue** | Raw-report intake lacks encoding-normalization; manual UTF-8 repair every intake. |
| **Evidence** | friction-log line 97 — mojibake repair on all 7 sessions, re-done by hand each intake. |
| **Waste mechanism** | Rework turns + operator time per intake. |
| **Implementation steps** | Add a normalization step to `intake-reports` / run-execution Step 2.2b (e.g., a deterministic mojibake-fix pass before the verbatim write). |
| **Estimated savings** | MEDIUM (per-intake rework). |
| **Risk** | A normalization pass could alter genuinely-intended characters. Keep it conservative (known mojibake sequences only). |
| **Dependencies** | None. |
| **Category** | Structural change. |

**LOW**

- Set `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING=1` (and optionally `MAX_THINKING_TOKENS`) in a new `.claude/settings.local.json` — workspace recommends this for analytical projects. Minor per-request savings.
- The 6 over-300-line skills are a canonical-library concern; defer to the `ai-resources`-scope token audit.

#### 9.3 Safeguard Proposals

1. **Git-log prefix filter** in `citation-converter` (and any subagent reading git log): strip `Auto-commit ` lines before reasoning. Prevents recurrence of the documented misclassification (4-A).
2. **Extend `permissions.deny`** with the four Read patterns in 9.2 MEDIUM — durable isolation of intermediate artifacts.
3. **Encoding-normalization step** in the intake path — removes a recurring manual-repair burden (4-B).

#### 9.4 Implications for Future Opus 4.7 Upgrade

- The per-dispatch model pinning in run-report (opus/sonnet 200K aliases) is the seam an Opus 4.7 migration would touch — verify the alias→context mapping still clears the credit gate under the new model.
- CLAUDE.md trimming is a prerequisite, not a blocker: a leaner always-loaded file compounds favorably on any model.
- No upgrade dependency in the Read-deny or intake-normalization items — model-independent.

#### 9.5 Assumptions and Gaps

- **Telemetry:** Only 1 usage-log entry — all Section 4/5 "typical run" statements are structural inferences from command instructions, not observed token data.
- **No agent-dispatch tool** in this environment: Sections 2/4/6 ran inline rather than via the mechanical/workflow subagents. Read discipline preserved, but the protocol's two-file (notes+summary) delegation artifacts were not produced for those sections; findings are in this report directly.
- **Skill census** scoped to pipeline-invoked skills; full description-quality/redundancy assessment of the 91-skill library is owned by the `ai-resources`-scope audit.
- **CLAUDE.md** findings cited from the parallel claude-md audit, not independently re-derived (per the audit brief).

---

### 10. Self-Assessment

1. **Audit token cost:** `/cost` unavailable in this environment — not measured.
2. **Protocol gaps:** The protocol assumes an agent-dispatch tool is available for Section 2/4/6 delegation. In an environment without one, the main session must run those inline; the protocol's "if you hit context limits" guidance covers this implicitly but doesn't address a hard absence of the dispatch tool. Inline execution with batch-measure-first kept cost bounded.
3. **Confidence by section:**
   - Section 0, 3, 5, 6: **HIGH** — direct file/config measurement.
   - Section 1: **HIGH** — cited from a same-cycle dedicated audit + own line/token counts.
   - Section 2: **MEDIUM** — batch measurement direct; "loaded only in subagent" inferred from command bodies (which I read for the four main workflows).
   - Section 4: **HIGH** for run-report/run-execution (read in full) / **MEDIUM** for run-analysis/intake (read via targeted grep + head).
   - Section 7, 8: **MEDIUM** — structural synthesis of the above.
4. **Threshold-boundary findings:** CLAUDE.md at 149 lines sits below the 200-line MEDIUM line-count threshold but far above the token-cost target — the line-count metric understates cost here (dense blocks). Severity is driven by token cost (~2,533t), not line count, so no classification flip. The skill size distribution (6 skills >300 lines) is library-scope and flagged LOW at project scope by design, not by threshold proximity.
