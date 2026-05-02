# Token Audit — 2026-05-02
Scope: ai-resources repo
AUDIT_ROOT: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources
Previous audit: token-audit-2026-05-01-ai-resources.md

## 0. Pre-Flight Summary

- **`/cost` and `/context`:** Not available in this execution environment (interactive-only commands).
- **Session telemetry:** `session-usage-analyzer` skill present; `ai-resources/logs/usage-log.md` (376 lines) holds recent in-scope entries through 2026-05-01. Section 5 runs inline (single in-scope log file, narrow scope).
- **Read(pattern) deny-rule check (Step 0.3) — Verdict: MEDIUM.** Five `Read(...)` denies present in `ai-resources/.claude/settings.json` (covering `archive/`, `**/deprecated/**`, `**/old/**`, `inbox/archive/**`, `logs/*-archive-*.md`). Missing coverage on expected dirs `audits/`, `reports/`, `logs/` (broad), `inbox/` (broad). The `audits/` and `reports/` gaps are intentional carve-outs (decisions log 2026-05-01: blanket denies break `/friday-act`, `/risk-check`, `/token-audit`); the right fix is *narrower* coverage (e.g., `Read(audits/working/**)`). Carry forward to Sections 6 and 7.
- **Working notes:** `audits/working/audit-working-notes-preflight.md`.

## 1. CLAUDE.md Audit

**Files in scope:**

| File | Lines | Words | Est. tokens (×1.3) | Loaded every turn? |
|------|-------|-------|--------------------|--------------------|
| `ai-resources/CLAUDE.md` | 92 | 950 | ~1,235 | Yes |
| `ai-resources/workflows/research-workflow/CLAUDE.md` | 128 | 1,140 | ~1,482 | No (deploy-time template; loaded only in deployed projects) |

**Cross-scope context (out of audit scope but loaded every turn here):**

| File | Lines | Words | Est. tokens (×1.3) |
|------|-------|-------|--------------------|
| Workspace-root `CLAUDE.md` | 219 | 3,202 | ~4,163 |

Combined per-turn cost in an ai-resources session: ~5,398 tokens (workspace + ai-resources). Over a 30–50 turn session: ~162k–270k tokens spent purely on CLAUDE.md loading.

**Findings:**

| # | Finding | Severity | Lines/file | Recommendation |
|---|---------|----------|------------|----------------|
| 1 | Workspace `CLAUDE.md` at 219 lines exceeds Anthropic's <200-line guideline (within ±15% threshold band — ambiguous classification, see §10) | MEDIUM (boundary) | workspace `CLAUDE.md`:1–219 | Consider migrating two least-broadly-applicable sections to a skill or pointer doc: (a) "QC → Triage Auto-Loop" (~30 lines, applies to QC-running sessions but already mirrored in `qc-pass.md` / `refinement-pass.md` skills) and/or (b) "QC Independence Rule" (~15 lines, deep methodology). Goal: drop below 200 lines without losing behavioral coverage. |
| 2 | "Commit Rules" section in `ai-resources/CLAUDE.md` (lines 65–73) duplicates workspace `CLAUDE.md` "Commit behavior" by intent (file documents the duplication on lines 71–73). Net cost ~150 tokens × every turn = ~4.5k–7.5k tokens per session for the duplicate copy. | LOW | `ai-resources/CLAUDE.md`:65–73 | Keep — duplication is explicitly justified for project-only sessions where workspace CLAUDE.md isn't loaded. Cost is small and replacement (a one-line pointer) defeats the stated purpose. |
| 3 | `ai-resources/CLAUDE.md` size and shape are within guidance | — | — | No change. |
| 4 | Compaction instructions present in both loaded CLAUDE.md files (workspace `Pre-compact checkpoint` + `Post-compact resumption — trust the summary`; ai-resources `Compaction` section) | — | workspace 73–74; ai-resources 81–88 | No change — safeguard satisfied. |
| 5 | research-workflow CLAUDE.md is a template (`{{PROJECT_TITLE}}` placeholders) — only loaded in deployed projects, not in ai-resources sessions | — | template | No change. |

**Aspirational vs. behavioral content scan:** No purely aspirational sections detected in either loaded CLAUDE.md. Both are dense behavioral guidance.

**Skill-eligible content scan:** Workspace `CLAUDE.md` "QC → Triage Auto-Loop" (lines ~125–135) is the strongest migration candidate — it describes a procedure that activates only when a QC subagent returns findings, yet costs ~400 tokens per turn always-loaded. Already partially mirrored in `qc-pass.md` and `refinement-pass.md` slash-command files. See Finding 1.

## 2. Skill Census

**Total skills:** 71 (69 canonical + 2 workflow-reference copies)
**Total lines:** 14,483
**Total estimated tokens (×1.3):** ~164,000 (full corpus — only loaded when individually invoked, not at session start)

**Size distribution:**
- 7 skills over 300 lines (HIGH — all justified by domain complexity)
- 41 skills in the 50–300 line range
- The remaining 23 are under 50 lines

**Top finding (HIGH, all justified):** 7 skills exceed the 300-line guideline but each carries its own justification — multi-phase workflow instructions, opus-tier judgment skills, multi-evidence-type writers, system-level critique. Subagent reports no defects (description quality, frontmatter, redundancy, dead skills) on any of these. Together they account for ~29k tokens or ~18% of the all-skills corpus.

**MEDIUM:** 0 — no quality defects detected.

**LOW:** 1 — workflow-reference copies (`knowledge-file-producer`, `report-compliance-qc`) lack `model:`/`effort:` declarations; cosmetic drift, not a token issue.

**Quality gates:**
- Frontmatter: 100% (all 71 skills have YAML frontmatter with trigger-rich descriptions).
- Description quality: no vague triggers detected.
- Redundancy: no clear overlaps detected.
- Dead skills: none detected.

**Full notes:** `audits/working/audit-working-notes-skills.md`. Summary: `audits/working/audit-summary-skills.md`.

## 3. Command File Census

**Total command files:** 43 in `ai-resources/.claude/commands/`
**Total lines:** 5,418
**Total words:** 44,242 (≈57,500 tokens corpus-wide — only one command body loads per invocation)

**Top 10 by word count:**

| Rank | Command | Lines | Words | Est. tokens (×1.3) | Loads external context? |
|------|---------|-------|-------|--------------------|-------------------------|
| 1 | `new-project.md` | 527 | 5,279 | ~6,863 | Subagent-delegated (pipeline-stage-3a/3b/3c/4/5) — minimal main-session load |
| 2 | `friday-checkup.md` | 391 | 3,009 | ~3,912 | Reads project CLAUDE.md (40 lines) + session-notes (20 lines) per active project; subagent-delegates audits |
| 3 | `cleanup-worktree.md` | 165 | 2,814 | ~3,658 | **Reads `worktree-cleanup-investigator/SKILL.md` (247 lines, 3,618 words ≈ 4,700 tokens) into main session** |
| 4 | `repo-dd.md` | 314 | 2,680 | ~3,484 | Subagent-delegated (repo-dd-auditor + dd-extract-agent + dd-log-sweep-agent) — main session reads structured extract only |
| 5 | `deploy-workflow.md` | 353 | 2,081 | ~2,705 | Shell-driven; minimal main-session reads |
| 6 | `permission-sweep.md` | 323 | 2,005 | ~2,607 | Subagent-delegated (permission-sweep-auditor) |
| 7 | `friday-act.md` | 246 | 1,931 | ~2,510 | Reads `audits/friday-checkup-{date}.md` from prior session |
| 8 | `innovation-sweep.md` | 272 | 1,871 | ~2,432 | Subagent-delegated (innovation-triage-auditor) |
| 9 | `audit-critical-resources.md` | 245 | 1,708 | ~2,220 | Subagent-delegated (critical-resource-auditor) |
| 10 | `improve-skill.md` | 158 | 1,538 | ~2,000 | Reads target SKILL.md + reference files |

**High-cost commands (loading >5,000 tokens of effective main-session context including command body + cascaded reads):**

| Command | Body | Cascading load | Combined main-session cost | Recommendation |
|---------|------|----------------|----------------------------|----------------|
| `/cleanup-worktree` | ~3,658 tokens | `worktree-cleanup-investigator/SKILL.md` ~4,700 tokens (main-session, not subagent) | ~8,360 tokens | Convert the SKILL.md read to a subagent invocation, or split the SKILL.md into a thin orchestrator + per-step on-demand reads. Skill is structured for main-session execution; refactor is non-trivial. |
| `/new-project` | ~6,863 tokens | Subagent-delegated | ~6,900 tokens (just the command body) | Body itself is large but pipeline orchestration justifies size. Consider extracting Stage 1/2 prompts into separate `pipeline-stage-1.md` / `-2.md` files (current pattern for stages 3–5) to defer their load until needed. |
| `/friday-checkup` | ~3,912 tokens | Per-project CLAUDE.md (40 lines) + session-notes tail (20 lines) — bounded | ~4,200 tokens for 1 active project | Body length is justified by tier-detection logic. No quick win. |

**Findings:**

| # | Finding | Severity | Recommendation |
|---|---------|----------|----------------|
| 1 | `/cleanup-worktree` reads `worktree-cleanup-investigator/SKILL.md` in full into main session (~4,700 tokens cascaded load on top of ~3,660 token command body) | MEDIUM | Refactor: either (a) move the investigator's procedural body into a subagent and have the command pass the path + context, or (b) use on-demand `Read(line range)` patterns for sections that aren't needed in every invocation. Risk: moderate — the skill is currently main-session by design (mandatory plan mode + named confirmation phrases require operator-visible execution). |
| 2 | `/new-project` command body at 5,279 words — by far the largest single command file | LOW (justified) | Already follows the orchestrator pattern (delegates Stages 3a–5 to dedicated agents). Could split orchestrator prose into staged loads, but ROI is low — the command is invoked rarely. |
| 3 | Total command corpus 5,418 lines / 44k words is balanced — no command bodies were unjustifiably oversized aside from cascading-load issue | — | No action. |
| 4 | `/friday-checkup` and `/friday-act` are paired commands carrying overlapping context-setup logic (~6,400 tokens combined) | LOW | Already split intentionally (Friday session 1 = audit, session 2 = fixes). No action needed. |

## 4. Workflow Token Efficiency

**Workflows audited (top 5 by reference frequency):** `research-workflow`, `/new-project`, `/repo-dd`, `/cleanup-worktree`, `friday-cadence` (paired `friday-checkup` + `friday-act`).

Workflow-summary aggregate: **43 findings across the 5 workflows** (8 HIGH + 1 HIGH-boundary, 24 MEDIUM, 9 LOW + 1 LOW–MEDIUM).

### 4.1 — research-workflow

**Findings:** 15 (5 HIGH, 7 MEDIUM, 3 LOW). Full notes: `audits/working/audit-working-notes-workflow-research-workflow.md`. Summary: `audits/working/audit-summary-workflow-research-workflow.md`.

| # | Finding | Severity | Waste mechanism |
|---|---------|----------|-----------------|
| F1 | Subagent return contract enforced at only 6/50 launch sites (~12%); ~44 sites use unbounded "Return: ..." instructions | HIGH | Subagent outputs return verbose into main session |
| F2 | `run-report.md` Step 4.0 pre-loads ~30,000+ tokens (all extracts, memos, directives, recommendations) into main session, held resident for ~30+ subsequent dispatches | HIGH | Massive single-step main-session load |
| F3 | research-workflow CLAUDE.md `@`-imports four reference files (~6,197 tokens) on every turn despite a "load when working" instruction the `@` mechanism cannot honor; per-turn cost ~7,679 tokens | HIGH (boundary) | Permanent context loaded for stage-bound content |
| F7 | `/review-chapter` and `/verify-chapter` load 7+ inputs in main session before delegating | HIGH | Pre-delegation main-session reads |
| F8 | Chapter prose returned full to main session (`run-report.md` 4.2a) | HIGH | Subagent return-volume |
| F15 | `run-cluster.md` command file still implements content-pass sequential pattern; `stage-instructions.md` Step 3.2 specifies path-pass parallel | MEDIUM | Command-vs-spec divergence |

### 4.2 — /new-project

**Findings:** 8 (0 HIGH, 5 MEDIUM, 2 LOW, 1 PASS). Full notes: `audits/working/audit-working-notes-workflow-new-project.md`.

Top 3:
1. **MEDIUM** — Five pipeline-stage agents (3a/3b/3c/4/5) lack an explicit return-size cap; only `session-guide-generator` declares "under 30 lines."
2. **MEDIUM (boundary)** — Orchestrator file is 527 lines / ~6,863 tokens with canonical blocks duplicated ~3× (reference text + heredoc + printf fallback) → ~60–90 redundant lines.
3. **MEDIUM** — No `/compact` breakpoint declared between pipeline stages; full 6-subagent run accumulates returns + gate exchanges without structural compaction prompt.

Other: Stage 3a inventory output structurally enables large-table echo (MEDIUM-boundary). Stages 3b and 3c both Read `repo-snapshot.md` — subagent-side duplication on opus tier (LOW). Model tiering correct (orchestrator + 3a/4/5/6 sonnet; 3b/3c opus) — PASS.

### 4.3 — /repo-dd

**Findings:** 8 (0 HIGH, 3 MEDIUM, 1 LOW, 4 PASS). Output-to-disk pattern correctly implemented across all 3 subagents. Full notes: `audits/working/audit-working-notes-workflow-repo-dd.md`.

Top 3:
1. **MEDIUM** — No `/compact` or `/clear` instruction at the three natural tier boundaries (Steps 7, 12, 14). Only reactive "inform operator if context high" at lines 127, 236.
2. **MEDIUM** — `/repo-dd` runs Opus throughout (`model: opus`) including mechanical Steps 22–24 (apply fixes + verify) and Steps 62–66 (existence/symlink/file-pair pipeline tests). Subagents correctly tiered; main session is not.
3. **MEDIUM (boundary)** — Step 63 template-sync diffs each canonical-vs-deployed file pair in the main session with no subagent delegation; cumulative cost depends on deployed-project count.

Estimated main-session workflow loads: standard ~5,000 tokens; deep +~1,000; full +6,000–9,000 (DEEP_REPORT re-read at Step 67) plus variable Step 63 file-pair reads.

### 4.4 — /cleanup-worktree

**Findings:** 6 open (2 HIGH, 1 HIGH-boundary, 2 MEDIUM, 2 LOW). 3 prior HIGH findings from 2026-04-18 audit are now RESOLVED (subagent verbatim I/O fixed structurally). Full notes: `audits/working/audit-working-notes-workflow-cleanup-worktree.md`.

Top 3:
1. **HIGH** — `worktree-cleanup-investigator/SKILL.md` (247 lines / ~4,703 tokens) loaded in full at command Step 3.6. Re-eval: ~80–110 lines are load-bearing (Invocation Contract, Bias Counters, Failure Behavior); ~130–160 lines are non-load-bearing (Workflow overview duplicates command Steps 1–12; "When to Use" / "Cross-References" / Example / Validation Loop / Runtime Recs are discovery- or post-execution-only). **Estimated savings if split: ~2,500–3,000 tokens per invocation.**
2. **HIGH (boundary)** — `execution-protocol.md` at 337 lines / ~5,912 tokens; 12% over the 300-line threshold (within ±15% boundary). Grew ~27 lines since prior audit.
3. **HIGH** — Reference files (`decision-taxonomy.md` 230 lines + `execution-protocol.md` 337 lines = ~8,547 tokens combined) "on-demand" loading degrades for typical 10–14 path session because trigger points span Steps 5/6/7/9/11; cumulative load approaches full file by mid-workflow.

Pre-plan main-session context: ~20,500–22,300 tokens / 6 files. Total session-start: ~24,500–30,000 tokens.

**Re-eval of operator's question (whether SKILL.md must be main-session in full):** Design rationale (mandatory plan mode, named confirmation phrases, operator-visible execution) justifies main-session loading of ~80–110 SKILL.md lines, **NOT** the full 247. **Split is feasible.**

### 4.5 — friday-cadence (friday-checkup + friday-act)

**Findings:** 6 (1 HIGH, 4 MEDIUM, 1 LOW–MEDIUM boundary). Full notes: `audits/working/audit-working-notes-workflow-friday-cadence.md`.

Top 3:
1. **HIGH** — Step 7.16 reads ~893 lines / ~10,300 tokens of sub-reports into main session for headline extraction; delegable to a findings-extractor subagent.
2. **MEDIUM** — No `/compact`, `/clear`, or scratchpad breakpoints despite long single-session orchestration (6+ sub-commands + 3 orchestrator-spawned agents).
3. **MEDIUM** — Step 6.recurrence does cross-report textual matching against prior `friday-checkup-*.md` archives in the main session; cost grows linearly with archive count.

Workflow start cost: friday-checkup ~9,310 tokens / friday-act ~7,910 tokens (workspace CLAUDE.md is the dominant per-turn share — re-confirms the §1 finding on the 219-line workspace CLAUDE.md). Subagent return discipline: `doc-scanner-agent` and `principles-checker-agent` write-to-disk correctly; `improvement-analyst` returns full markdown inline (pattern-mismatch, low absolute cost). Refinement multiplier: 1 — PASS.

## 5. Session Patterns & Configuration

**Session telemetry available:** Yes. `ai-resources/logs/usage-log.md` (376 lines) holds entries from 2026-04-21 through 2026-05-01 — ~10 entries. Pattern: most sessions classified "Acceptable", two "Efficient", one "Wasteful" (2026-04-21). The 2026-05-01 monthly /friday-act entry quantifies false-positive overhead at ~16k tokens per Friday cycle, attributable to auditor rules that don't model bypass-mode posture or template-class files.

**Configuration audit:**

| Setting | Current value | Recommended | Impact |
|---------|---------------|-------------|--------|
| Default model (ai-resources) | `claude-sonnet-4-6[1m]` (set in `ai-resources/.claude/settings.local.json`) | Sonnet 1M for execution; Opus opt-in for judgment | PASS |
| Default model (workspace root) | unset; inherits via `--add-dir` from ai-resources project default | Sonnet | PASS |
| Subagent model tier | Per-agent declaration enforced by workspace CLAUDE.md `Model Tier → Agents` rule | Haiku for mechanical, Sonnet for factual, Opus for judgment | PASS — verified across workflow audits |
| MAX_THINKING_TOKENS (user-home) | 20,000 | 10,000 routine; 20k–32k for judgment | MEDIUM — global is 2× the project-level value; see Finding 1 |
| MAX_THINKING_TOKENS (ai-resources) | 10,000 | 10,000 | PASS |
| MAX_THINKING_TOKENS (workspace root) | 10,000 (set 2026-05-02) | 10,000 | PASS |
| Autocompact threshold | `autoCompactWindow=950000` (user-home) | Workspace under 1M-context model: 800–950k window OK | PASS — appropriate for `[1m]` model |
| `DISABLE_NON_ESSENTIAL_MODEL_CALLS` | `1` (user-home, added 2026-05-02) | enabled | PASS — pending behavioral verification |
| `DISABLE_AUTOUPDATER` | `1` (user-home) | enabled | PASS |
| MCP servers active | `github` only (15 others disabled 2026-05-02) | Only used servers | PASS — recent cull |
| `defaultMode` | `bypassPermissions` (all layers) | bypassPermissions per operator memory | PASS |
| `effortLevel` | `xhigh` (user-home) | xhigh acceptable for analytical workspace | PASS |

**Hooks (15 total in `ai-resources/.claude/hooks/`):**

| Hook | Purpose | Token impact |
|------|---------|--------------|
| `check-heavy-tool.sh` | PreToolUse on Read/Grep/Bash — heavy-tool detection | Low (5s timeout, brief output) |
| `friction-log-auto.sh` | PreToolUse on Skill — friction tracking | Low |
| `log-write-activity.sh` | PostToolUse on Write/Edit | Low |
| `auto-qc-nudge.sh` | PostToolUse on Write/Edit — QC reminder | Low |
| `auto-resolve-nudge.sh` | Stop hook — QC findings nudge | Low |
| `coach-reminder.sh`, `improve-reminder.sh` | Stop hooks — periodic nudges | Low |
| `check-stop-reminders.sh` | Stop hook — wrap-session reminder | Low |
| `friday-checkup-reminder.sh` | SessionStart — Friday cadence | Low |
| Others (`check-skill-size.sh`, `check-permission-sanity.sh`, `check-template-drift.sh`, `auto-sync-shared.sh`, `detect-innovation.sh`, `pre-commit`) | Maintenance/safety | Low |

No hooks observed truncating tool output or capping subagent return volume. **No output-truncation hook present.** This is a missing safeguard (carry to Section 7).

**Findings:**

| # | Finding | Severity | Recommendation |
|---|---------|----------|----------------|
| 1 | User-home `MAX_THINKING_TOKENS=20000` is 2× the project-level setting (10,000); applies when running outside the ai-resources project context (e.g., workspace-root sessions before the 2026-05-02 alignment, or any other project that doesn't override) | LOW (mostly mitigated by the 2026-05-02 workspace alignment) | Optional: lower user-home to 10,000 to make 20k an explicit per-agent opt-in for judgment work; matches project-level convention. |
| 2 | `DISABLE_NON_ESSENTIAL_MODEL_CALLS=1` is set in user-home (2026-05-02) but env-var name is unconfirmed and silent-fail behavior makes verification non-trivial | INFO | Watch for behavioral signals this session and next 2–3 sessions; if no observable change, treat as low-impact and don't sink time chasing it. |
| 3 | Hook layer has 15 active hooks but none cap tool output or subagent return volume; reactive reminders only | MEDIUM | See Section 7 — output-truncation hook is a flagged missing safeguard. |
| 4 | MCP servers: 15 disabled in 2026-05-02 cull leaves only `github`; substantial per-turn savings already realized | PASS | No action — recent fix. |
| 5 | Autocompact threshold is appropriate for the 1M-context model | PASS | No action. |

## 6. File Handling Patterns

**Read(pattern) deny-rule status (carried from §0):** **MEDIUM** — Read(...) denies exist but coverage misses 4+ expected directories. The `audits/` and `reports/` gaps are intentional carve-outs per 2026-05-01 decision; the `audits/working/**` gap is unintentional.

**Covered directories:** `archive/**`, `**/deprecated/**`, `**/old/**`, `inbox/archive/**`, `logs/*-archive-*.md`.
**Intentionally not covered:** `audits/`, `reports/` (needed by `/friday-act`, `/risk-check`, `/token-audit`).
**Unintentionally not covered:** `audits/working/**` (intermediate audit artifacts).

**Findings (from Section 6 subagent — 6 total):**

| # | Finding | Severity | Recommendation |
|---|---------|----------|----------------|
| 1 | `audits/working/**` (15+ files, 290–602 lines each) discoverable to Read/Grep/Glob; intermediate audit artifacts that shouldn't be read by future sessions | MEDIUM | Add `Read(audits/working/**)` to `ai-resources/.claude/settings.json` deny list. Aligns with operator constraint (does not break /friday-act etc.). |
| 2 | Active session logs (`logs/decisions.md`, `logs/session-notes.md`, `logs/usage-log.md`) growing unbounded; combined ~24k tokens | MEDIUM | Add rotation: when each exceeds 600 lines, archive bottom-N to `*-archive-YYYY-Q[1-4].md` (already covered by deny rule). Existing `check-archive.sh` script handles bottom-10 keep-tail; tune threshold. |
| 3 | 11 prior audit reports (~92k tokens total) in `audits/` remain intentionally readable | MEDIUM | No action — trade-off accepted for `/friday-act` etc. cross-report comparison. Re-evaluate if archive grows substantially. |
| 4 | Other findings — see full notes | LOW | — |

**Full notes:** `audits/working/audit-working-notes-file-handling.md`. Summary: `audits/working/audit-summary-file-handling.md`.

## 7. Missing Safeguards

| Safeguard | Status | Severity if missing | Recommendation |
|-----------|--------|---------------------|----------------|
| `Read(pattern)` deny rules in `.claude/settings.json` covering stale/large directories | **Partial** | HIGH | Carry §0/§6 finding — add `Read(audits/working/**)`; the broader `audits/`/`reports/` gaps are intentional carve-outs and stay open. |
| Custom compaction instructions in CLAUDE.md | **Present** | MEDIUM | Both workspace `CLAUDE.md` (Pre-/Post-compact rules) and ai-resources `CLAUDE.md` (Compaction section) document expected behavior. |
| Subagent output-to-disk pattern | **Present (partial enforcement)** | HIGH | ai-resources `CLAUDE.md → Subagent Contracts` documents the contract. Enforcement is uneven: `repo-dd-auditor`, `token-audit-auditor*`, `cleanup-worktree` agents comply; many of the research-workflow's 50 launch sites do NOT (Section 4 F1). |
| Context window monitoring instructions | **Partial** | MEDIUM | `/cost`/`/context` not referenced in CLAUDE.md; reactive "inform operator if context high" appears in `/repo-dd` only. |
| Session boundaries defined for workflows | **Present** | MEDIUM | ai-resources `CLAUDE.md → Session Boundaries` and `Compaction` sections cover this. |
| Model selection guidance | **Present** | LOW | Workspace `CLAUDE.md → Model Tier`; per-agent `model:` declarations enforced. |
| File read scoping (lines X–Y vs entire file) | **Partial** | LOW | `repo-dd` uses targeted Reads; many other commands read in full. |
| Output length constraints | **Partial** | MEDIUM | Subagent contracts cap summaries at 20–30 lines, but main-session output verbosity is unconstrained. |
| Effort level guidance | **Present** | LOW | `effortLevel: xhigh` set in user-home; reasonable for analytical workspace. |
| Hook-based output truncation | **Absent** | MEDIUM | No hook caps tool output. With 15 active hooks already in place, this is implementable but adds complexity; lower priority than the deny-rule + subagent return-cap fixes. |
| Audit/output artifact isolation | **Partial** | MEDIUM | `audits/working/**` is the gap (Finding §6.1). |

**Top safeguard gaps to fix:**

1. **`Read(audits/working/**)` deny rule** — closes the unintended gap from §0/§6 without breaking active workflows.
2. **Subagent return-volume contract enforcement in research-workflow** — formalize the existing "Return: ..." instructions across the 44 non-compliant launch sites; biggest single token-saving lever in the audit.
3. **Output-truncation hook** — defer to a later iteration; complexity vs. return is unfavorable today.

## 8. Best Practices Comparison

| # | Practice | Status | Gap | Priority |
|---|----------|--------|-----|----------|
| 1 | CLAUDE.md under 200 lines | Partial | Workspace at 219 (boundary); ai-resources at 92 (PASS) | MEDIUM |
| 2 | `Read(pattern)` deny rules configured | Partial | Five denies present; `audits/working/**` gap unintended | MEDIUM |
| 3 | Skills use on-demand loading | Implemented | All 71 skills correctly use frontmatter + on-demand body load (Section 2 PASS) | — |
| 4 | Subagents for heavy reads | Implemented | Top workflows (`/repo-dd`, `/token-audit`, `/cleanup-worktree`) delegate; research-workflow has 88% non-compliant launch sites | HIGH |
| 5 | Strategic `/compact` at breakpoints | Partial | `/repo-dd` and `/new-project` lack tier-boundary `/compact` markers; research-workflow has compact directives but inconsistently applied | MEDIUM |
| 6 | `/clear` between unrelated tasks | Implemented | ai-resources `CLAUDE.md → Session Boundaries` documents the rule | — |
| 7 | Model selection per task type | Implemented | Per-agent declaration enforced; PASS in workflow audits. `/repo-dd` runs Opus on mechanical steps (Section 4 F2) — single exception | LOW |
| 8 | Extended thinking budget controlled | Implemented | `MAX_THINKING_TOKENS` set at all repo layers (10k); user-home is 20k (LOW finding) | LOW |
| 9 | Unused MCP servers disabled | Implemented | 15 of 16 disabled 2026-05-02; only `github` retained | — |
| 10 | Output-to-disk pattern for subagents | Partial | Documented; enforced unevenly (research-workflow F1) | HIGH |
| 11 | Precise prompts over vague ones | Implemented | Skills and commands give detailed instructions; no broad "fix the auth bug" prompts observed | — |
| 12 | Session notes pattern | Implemented | `logs/session-notes.md`, `decisions.md`, `usage-log.md` are the pattern; `/wrap-session` enforces it | — |

**Headline gaps:** #2 (deny rule), #4 (subagent delegation in research-workflow), #5 (`/compact` breakpoints), #10 (subagent return discipline).

## 9. Optimization Plan

### 9.1 — Executive Summary

The ai-resources repo is in solid shape on the static fundamentals — 71 skills with full frontmatter compliance and trigger-rich descriptions, 43 command files at appropriate sizes, configuration aligned with April 2026 best practices, MCP-server cull already executed (2026-05-02), `MAX_THINKING_TOKENS` aligned across project layers. The 2026-05-01 audit's HIGH finding on subagent verbatim I/O in `/cleanup-worktree` is now RESOLVED structurally.

The remaining token-waste surface is concentrated in two places:

1. **research-workflow execution discipline.** The pipeline has 50 subagent launch sites; 44 of them (88%) lack an explicit return-size cap, and `run-report.md` Step 4.0 pre-loads ~30,000+ tokens of analysis artifacts into main session and holds it resident through ~30+ subsequent dispatches. The CLAUDE.md `@`-imports four reference files (~6,200 tokens) on every turn despite a "load when working" comment the `@` mechanism cannot honor. These three findings together are responsible for the lion's share of avoidable per-session cost in the heaviest workflow.

2. **Workflow-level compaction and SKILL-load discipline.** `/cleanup-worktree` loads `worktree-cleanup-investigator/SKILL.md` (4,700 tokens) in full when only ~80–110 lines are load-bearing. Several workflows (`/new-project`, `/repo-dd`, `friday-cadence`) lack `/compact` breakpoints between natural tier boundaries. `/repo-dd` runs Opus on mechanical fix-application and pipeline-test steps. `/friday-checkup` Step 7.16 reads ~10,300 tokens of sub-reports for headline extraction (delegable).

**Estimated savings if all HIGH and HIGH-boundary recommendations land:** approximately 20,000–40,000 tokens per heavy-workflow session (research-workflow Stage 4, `/cleanup-worktree`, `/friday-checkup`), plus a small per-turn reduction (~400–600 tokens) on the workspace `CLAUDE.md` boundary fix. Combined with the already-realized MCP cull, the trajectory is favorable.

### 9.2 — Prioritized Recommendations

#### HIGH (>1,000 tokens/turn or >10,000 tokens/session)

##### H1 — Enforce subagent return-size caps across research-workflow launch sites

| Field | Content |
|-------|---------|
| **Issue** | 44 of 50 (88%) subagent launch sites in research-workflow lack explicit return-size caps; "Return: ..." instructions are unbounded. |
| **Evidence** | Section 4.1 F1 (audit-working-notes-workflow-research-workflow.md). `run-report.md` Step 4.2a returns "chapter draft content" verbatim. |
| **Waste mechanism** | Subagent outputs return verbose into main session, accumulating per-stage cost. |
| **Estimated savings** | HIGH — multiple thousand tokens per Stage-2/3/4 run. |
| **Implementation steps** | Add a one-line cap to each launch site's prompt: `Return ≤20-line summary + path to full output written to disk.` Audit each launch site's existing return contract; update inconsistent ones. Optional: add a research-workflow-specific subagent contract block to `workflows/research-workflow/CLAUDE.md` so the rule travels with deployed copies. |
| **Risk** | Low. Existing compliant sites (6/50) prove the pattern works. Risk is regression in cases where the launch site already worked because of an implicit short-output convention. Mitigation: keep the caps to "≤N lines" rather than rewriting the contract entirely. |
| **Dependencies** | None. |
| **Category** | Quick win (per-launch-site edits) but volume-wise = structural. |

##### H2 — Refactor research-workflow `run-report.md` Step 4.0 pre-load

| Field | Content |
|-------|---------|
| **Issue** | `run-report.md` Step 4.0 pre-loads all extracts, memos, directives, recommendations (~30,000+ tokens) into main session, held resident for ~30+ subsequent dispatches per Stage 4. |
| **Evidence** | Section 4.1 F2 (audit-working-notes-workflow-research-workflow.md). |
| **Waste mechanism** | Massive single-step load held over many subsequent operations. |
| **Estimated savings** | HIGH — 20,000+ tokens per Stage 4 invocation. |
| **Implementation steps** | (a) Move the pre-load into a subagent that produces a structured index file (paths + headlines) and returns only the index path; (b) downstream dispatches re-read specific extracts/memos on demand, not from main session. |
| **Risk** | Medium. Step 4.0 is the entry point for chapter writing; refactor must preserve writer access to source material. |
| **Dependencies** | Should follow H1 (uniform return contract) so the refactored step inherits the same discipline. |
| **Category** | Structural change. |

##### H3 — Stop research-workflow CLAUDE.md `@`-imports

| Field | Content |
|-------|---------|
| **Issue** | `workflows/research-workflow/CLAUDE.md` `@`-imports four reference files (~6,197 tokens) on every turn. `@` is unconditional — the comment "load when working" cannot make it conditional. |
| **Evidence** | Section 4.1 F3 (audit-working-notes-workflow-research-workflow.md). |
| **Waste mechanism** | Permanent context cost for stage-specific content that only applies during certain stages. |
| **Estimated savings** | HIGH (boundary) — ~6,200 tokens per turn in deployed research-workflow projects. |
| **Implementation steps** | Replace `@`-imports with prose pointers (`When entering Stage X, Read reference/stage-x.md`). Update `stage-instructions.md` to enumerate the per-stage required reads. |
| **Risk** | Low. Pointer pattern is already used elsewhere in the repo. |
| **Dependencies** | None. |
| **Category** | Quick win. |

##### H4 — Split `worktree-cleanup-investigator/SKILL.md`

| Field | Content |
|-------|---------|
| **Issue** | `/cleanup-worktree` loads the full 247-line SKILL.md (~4,700 tokens) but only ~80–110 lines are load-bearing during execution. |
| **Evidence** | Section 4.4 F1 (audit-working-notes-workflow-cleanup-worktree.md). |
| **Waste mechanism** | Cascading load of non-load-bearing content (workflow overview duplicating command Steps 1–12; "When to Use" / "Cross-References" / Example / Validation Loop / Runtime Recs). |
| **Estimated savings** | HIGH — ~2,500–3,000 tokens per `/cleanup-worktree` invocation. |
| **Implementation steps** | Split into `SKILL.md` (load-bearing: Invocation Contract, Bias Counters, Failure Behavior, plan-mode requirement, named confirmation phrases) and `reference/cleanup-context.md` (workflow overview, examples, runtime recs). Update `cleanup-worktree.md` Step 3.6 to Read only `SKILL.md` in full and cite reference path on demand. |
| **Risk** | Medium. Skill must remain self-explanatory at first invocation; the discovery sections matter for new operators. Mitigation: keep a short "Reference" pointer in the trimmed SKILL.md. |
| **Dependencies** | None. |
| **Category** | Structural change. |

##### H5 — Delegate `/friday-checkup` Step 7.16 sub-report extraction

| Field | Content |
|-------|---------|
| **Issue** | Step 7.16 reads ~893 lines / ~10,300 tokens of sub-reports into main session for headline extraction. |
| **Evidence** | Section 4.5 (audit-working-notes-workflow-friday-cadence.md). |
| **Waste mechanism** | Main-session bulk read where a subagent could return ≤30 headlines + paths. |
| **Estimated savings** | HIGH — ~10,000 tokens per `/friday-checkup`. |
| **Implementation steps** | Add a `findings-extractor` subagent (haiku tier — mechanical extraction); pass it the sub-report paths; receive a ≤30-line summary back. |
| **Risk** | Low. Paired with already-existing subagent patterns in the same command. |
| **Dependencies** | None. |
| **Category** | Quick win. |

#### MEDIUM (500–1,000 tokens/turn or 3,000–10,000 tokens/session)

##### M1 — Add `Read(audits/working/**)` to ai-resources deny list

| Field | Content |
|-------|---------|
| **Issue** | `audits/working/` (15+ files, 290–602 lines each) is discoverable by Read/Grep/Glob; intermediate audit artifacts shouldn't be read by future sessions. |
| **Evidence** | Section 6 Finding 1; Section 0 deny-rule check. |
| **Waste mechanism** | Future sessions may read stale working notes during exploration; corrupts subsequent audits. |
| **Estimated savings** | MEDIUM — situational; protects against accidental reads. |
| **Implementation steps** | Edit `ai-resources/.claude/settings.json` `permissions.deny`: add `"Read(audits/working/**)"`. |
| **Risk** | Very low. Active token-audit and other-audit subagents pass paths explicitly; they don't rely on Glob discovery. |
| **Dependencies** | None. |
| **Category** | Quick win. |

##### M2 — Add `/compact` breakpoints between pipeline stages in `/new-project`, tier boundaries in `/repo-dd`, and Friday cadence

| Field | Content |
|-------|---------|
| **Issue** | Three workflows lack structural compaction prompts: `/new-project` between Stages 3a/3b/3c/4/5; `/repo-dd` at standard→deep→full tier boundaries (Steps 7, 12, 14); `/friday-checkup` and `/friday-act` at sub-command boundaries. |
| **Evidence** | Sections 4.2 (new-project finding 3), 4.3 (repo-dd finding 1), 4.5 (friday-cadence finding 2). |
| **Waste mechanism** | Accumulated returns + gate exchanges held resident across long workflows. |
| **Estimated savings** | MEDIUM — depends on workflow length; ≥3,000 tokens/session for full `/repo-dd full`. |
| **Implementation steps** | Add `▸ /compact` directive lines (already a research-workflow convention) at the named breakpoints. Optionally instrument with a hook that fires a system-message reminder when a step transition is detected. |
| **Risk** | Low. `/compact` is non-destructive and operator-controlled. |
| **Dependencies** | None. |
| **Category** | Quick win. |

##### M3 — Add subagent return caps to `/new-project` pipeline-stage agents

| Field | Content |
|-------|---------|
| **Issue** | Five pipeline-stage agents (3a/3b/3c/4/5) lack explicit return-size caps; only `session-guide-generator` declares "under 30 lines." |
| **Evidence** | Section 4.2 finding 1 (audit-working-notes-workflow-new-project.md). |
| **Waste mechanism** | Variable return volume; orchestrator absorbs whatever the agent emits. |
| **Estimated savings** | MEDIUM — caps regression risk; precise savings depend on agent output. |
| **Implementation steps** | Add `Return: ≤30-line summary + path` to each of the 5 agent definitions. |
| **Risk** | Low. Mirrors the existing convention. |
| **Dependencies** | None. |
| **Category** | Quick win. |

##### M4 — Drop `/repo-dd` from Opus to Sonnet for mechanical steps

| Field | Content |
|-------|---------|
| **Issue** | `/repo-dd` runs Opus throughout (`model: opus`) including mechanical Steps 22–24 (apply fixes + verify) and Steps 62–66 (existence/symlink/file-pair pipeline tests). |
| **Evidence** | Section 4.3 finding 2. |
| **Waste mechanism** | Opus tier on tasks that don't need judgment work; per-turn cost premium. |
| **Estimated savings** | MEDIUM — model-tier delta on multiple steps per invocation. |
| **Implementation steps** | Either (a) split the command's frontmatter to allow tier-switch directives mid-flow (not natively supported — requires wrapper), or (b) accept that the command runs Opus end-to-end and document the trade-off. Option (a) is structural; option (b) is no-op. |
| **Risk** | Medium for option (a) — tier-switch is unconventional; option (b) is no-risk. |
| **Dependencies** | None. |
| **Category** | Structural change (option a) or document-only (option b). |

##### M5 — Resolve `run-cluster.md` command vs `stage-instructions.md` divergence

| Field | Content |
|-------|---------|
| **Issue** | `run-cluster.md` implements a content-pass sequential pattern; `stage-instructions.md` Step 3.2 specifies path-pass parallel. |
| **Evidence** | Section 4.1 finding F15 (audit-working-notes-workflow-research-workflow.md). |
| **Waste mechanism** | Spec-vs-implementation drift; sequential execution where parallel was specified. |
| **Estimated savings** | MEDIUM — depends on per-cluster work volume. |
| **Implementation steps** | Update `run-cluster.md` to match the spec (pass paths, dispatch parallel). |
| **Risk** | Low. Spec is the canonical version. |
| **Dependencies** | Should be done with H1 to keep return contracts uniform. |
| **Category** | Quick win. |

##### M6 — Workspace `CLAUDE.md` size: bring under 200 lines

| Field | Content |
|-------|---------|
| **Issue** | Workspace `CLAUDE.md` at 219 lines (boundary; ±15% threshold band). Loaded every turn of every workspace session. |
| **Evidence** | Section 1 finding 1. |
| **Waste mechanism** | Small per-turn cost (~80 tokens × 30–50 turns × every session). |
| **Estimated savings** | MEDIUM cumulative — per-turn delta is small but applies to every session. |
| **Implementation steps** | Migrate "QC → Triage Auto-Loop" or "QC Independence Rule" content to a slash-command-specific doc (`qc-pass.md` already mirrors part of it). Goal: <200 lines without losing behavioral coverage. |
| **Risk** | Medium. Content is broadly applicable; migration must not drop coverage. |
| **Dependencies** | None. |
| **Category** | Structural change. |

#### LOW (<500 tokens/turn or occasional)

- **L1** — Workflow-reference skill copies (`knowledge-file-producer`, `report-compliance-qc`) lack `model:`/`effort:` declarations. Cosmetic; clarify symlink-vs-copy intent. Section 2 LOW.
- **L2** — `/new-project` orchestrator file (527 lines) has ~60–90 redundantly duplicated lines (canonical blocks across reference text + heredoc + printf fallback). Section 4.2 finding 2. Refactor candidate.
- **L3** — User-home `MAX_THINKING_TOKENS=20000` is 2× project-level (10k). Section 5 finding 1. Optional alignment.
- **L4** — Active session logs (`logs/decisions.md`, `logs/session-notes.md`, `logs/usage-log.md`) growing toward 600 lines. Tune `check-archive.sh` thresholds. Section 6 finding 2.

### 9.3 — Safeguard Proposals

1. **Add `Read(audits/working/**)` deny rule.** File: `ai-resources/.claude/settings.json`. One-line addition. (M1)
2. **Add a workflow-level subagent return-cap convention.** File: `ai-resources/CLAUDE.md → Subagent Contracts`. Add a sentence: "Every Agent-tool launch site must specify a return cap (e.g., ≤20-line summary + path). Launch sites without an explicit cap are non-compliant." Carries to `workflows/research-workflow/CLAUDE.md` template via deployment. Underwrites H1.
3. **Extend `check-archive.sh` to surface log-rotation candidates.** Already exists for `session-notes.md`; tune threshold to fire at 600 lines for `decisions.md` and `usage-log.md`. (L4)
4. **Optional output-truncation hook.** PostToolUse on `Agent` matcher; if the agent's return exceeds N lines, truncate with a notice. Lower priority — complexity outweighs near-term benefit. Defer.

### 9.4 — Implications for Future Opus 4.7 Upgrade

- **H1, H2, H3** — Per-turn baseline cost matters more on Opus 4.7 (higher per-token spend). These three become higher ROI post-upgrade.
- **H4** — Cleanup-worktree skill split is independent of model version; ROI is constant.
- **M4** — Once Opus 4.7 is available, the `/repo-dd` Opus-throughout finding becomes more expensive. Consider option (a) (structural tier-switch) before upgrade.
- **M6** — Workspace `CLAUDE.md` size becomes more expensive per-turn at higher model tiers.

### 9.5 — Assumptions and Gaps

- **Token estimates use word-count × 1.3.** Drift of ±30% is plausible vs. real tokenizer (per protocol caveat). Findings within ±15% of severity thresholds (workspace CLAUDE.md at 219 lines, `execution-protocol.md` at 337 lines) carry boundary tags and are flagged in §10.
- **No subagent-level token telemetry available.** Per-launch-site cost estimates are structural inferences from file content + workflow design, not observed.
- **`DISABLE_NON_ESSENTIAL_MODEL_CALLS=1` behavior unverified.** Env-var name was speculative when added 2026-05-02; treat as `[NEEDS VERIFICATION]`.
- **`/cost` and `/context` not invokable in execution context.** Audit token cost (§10.1) cannot be measured directly.
- **2026-05-01 audit findings reused where structurally unchanged.** The 5 workflow audits were re-run fresh; the carryovers (workspace CLAUDE.md size, MCP cull verification, MAX_THINKING_TOKENS alignment) are explicit in §5/§8.

## 10. Self-Assessment

### 10.1 Audit token cost

Not measured — `/cost` was not invokable in this execution context. Approximate qualitative estimate: ~600k–800k tokens including 5 parallel Opus workflow subagents (~158k + 96k + 82k + 86k + 83k = ~505k from Section 4 alone, per subagent total_tokens reports), plus 2 mechanical subagents (~62k + ~50k) and main-session orchestration. This is a heavy-but-expected cost for a full Section-0–10 audit; the protocol exempts /token-audit from `[HEAVY]` and `[COST]` flags accordingly.

### 10.2 Protocol gaps encountered

- **Section 0.3 grep regex** runs on macOS BSD grep where `\|` in BRE is alternation, not literal pipe. The protocol's example pattern `^\|[^|]*\|...` may misbehave on macOS — used direct file inspection instead. Worth a v1.3 footnote ("on BSD grep, prefer `grep -E`" or use `awk` for column parsing).
- **Section 4 boundary "active workflows":** the protocol enumerates "referenced in CLAUDE.md, invoked by slash command, or documented in a workflow doc." This casts a wide net — every slash command is technically a "workflow." Used the same top-5 set as the prior audit (research-workflow, /new-project, /repo-dd, /cleanup-worktree, friday-cadence) for continuity and comparability. Worth specifying selection criteria more tightly.
- **Subagent prior-content overwrite:** The working-notes files persist across audits; the protocol assumes overwrite. Made explicit in subagent briefs (`audit-working-notes-skills.md (overwrite — prior content was for the 2026-05-01 audit)`). Worth codifying.

### 10.3 Confidence ratings

| Section | Confidence | Rationale |
|---------|-----------|-----------|
| 0 — Pre-flight | HIGH | Direct file reads of all settings.json files; deny rules confirmed. |
| 1 — CLAUDE.md | HIGH (boundary on workspace 219-line finding) | Direct measurement; size finding is at boundary band. |
| 2 — Skills | HIGH | Subagent measured 100% of 71 skills with batch script + frontmatter check. |
| 3 — Commands | HIGH | Direct measurement of all 43 commands; cascading-load pattern verified by reading top-5. |
| 4 — Workflows | MEDIUM (HIGH for measured loads, MEDIUM for inferred per-launch-site cost) | All 5 workflows audited fresh by independent subagents; per-site savings estimates are structural inferences, not observed. |
| 5 — Configuration | HIGH | Direct file reads of repo-local + user-home settings; usage-log telemetry available. |
| 6 — File handling | HIGH | Subagent measured all in-scope large files. |
| 7 — Safeguards | HIGH | Direct file inspection. |
| 8 — Best practices | HIGH for implemented items; MEDIUM for #11/#12 (structural assessment only per protocol). |
| 9 — Optimization plan | MEDIUM | Savings estimates carry the §9.5 caveats. |

### 10.4 Threshold-boundary findings (within ±15% of classification thresholds)

- **Workspace `CLAUDE.md` at 219 lines** (200-line MEDIUM threshold; 9.5% over). Could classify as PASS or MEDIUM depending on tokenizer drift. Tagged `MEDIUM (boundary)` in §1.
- **`execution-protocol.md` at 337 lines** (300-line HIGH threshold; 12% over). Tagged `HIGH (boundary)` in §4.4.
- **`Read(pattern)` deny-rule MEDIUM verdict** is structurally on the boundary because most missing coverage is intentional carve-out. Documented in §0/§6.
- **research-workflow CLAUDE.md `@`-imports finding** — listed as HIGH on absolute per-turn cost (~6,200 tokens) but tagged boundary because of model-tokenizer drift uncertainty.
- **`/repo-dd` Step 63 file-pair diff** — severity MEDIUM (boundary), depending on deployed-pair count.
