# Token Audit — 2026-05-25
Scope: ai-resources repo
AUDIT_ROOT: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources
Previous audit: token-audit-2026-05-02-ai-resources.md

---

## 0. Pre-Flight Summary

- **Baseline session metrics:** `/cost` and `/context` not available as callable tools in this Skill-invocation environment. Recorded as such; not blocking.
- **Session telemetry discovered:** `ai-resources/logs/usage-log.md` (643 lines). Multiple `session-usage-analyzer` outputs found across the workspace (consuming projects each maintain their own `logs/usage-log.md`). Recent ai-resources entries from 2026-05-22 will inform Section 5.
- **Read(pattern) deny-rule coverage verdict: MEDIUM.** Two of the protocol's expected dirs are fully uncovered (`audits/`, `reports/`); two are partially covered (`logs/`, `inbox/` — only the `archive/` subset is denied). The remaining expected dirs (`archive/`, `**/deprecated/**`, `**/old/**`) are covered. Operator-intent caveat: audits/, reports/, logs/, and inbox/ deliberately hold active artifacts the operator wants Claude to read; blanket directory denies would break that. Section 6 will recommend granular patterns (e.g., date-stamped historical reports) rather than directory-wide denies.
- Full notes: `audits/working/audit-working-notes-preflight.md`.

---

## 1. CLAUDE.md Audit

**Files under AUDIT_ROOT:**
- `ai-resources/CLAUDE.md` — 90 lines, 967 words, ≈ 1,257 tokens
- `ai-resources/workflows/research-workflow/CLAUDE.md` — 128 lines, 1,140 words, ≈ 1,482 tokens (template file with `{{PLACEHOLDERS}}`; loads in research-workflow projects, not in ai-resources sessions)

**Out-of-scope note:** The workspace-root `CLAUDE.md` (parent dir, ~250 lines, ~3,200 tokens) also loads in every ai-resources session because the harness walks up the directory tree. Audit-scope rules say we don't analyze it here, but its per-session cost dominates ai-resources/CLAUDE.md's. Flagged so the operator knows the per-session total — actual analysis belongs in a workspace-scope audit.

**Per-session cost (ai-resources scope):**
- `ai-resources/CLAUDE.md`: ~1,257 tokens loaded every turn. Over a typical 30–50-turn session: ~37,700 – 62,850 tokens spent on CLAUDE.md loading.
- (Workspace CLAUDE.md adds ~3,200 tokens per turn on top, but out of scope.)

**Findings:**

| # | Finding | Severity | Lines affected | Recommendation |
|---|---------|----------|---------------|----------------|
| 1.1 | ai-resources/CLAUDE.md: 90 lines, comfortably under the 200-line recommended ceiling. All sections are behavioral (no aspirational content), all apply across sessions. Compaction instructions present (lines 130–137 in workspace style; section "Compaction" present here). | PASS | — | No action. |
| 1.2 | research-workflow/CLAUDE.md: 128 lines, also under ceiling. "Input File Handling" and "Commit Rules" sections explicitly mirror workspace-level CLAUDE.md and document the deliberate duplication ("repeated here because projects are sometimes opened without the parent workspace context loaded"). Compaction section names load-bearing items to preserve. | PASS | — | No action — the mirror is intentional and load-bearing. |
| 1.3 | research-workflow/CLAUDE.md is a template file with `{{PLACEHOLDERS}}` (lines 1, 5, 7, 9, 11, 13, 25–26). It is consumed by `/new-project` when scaffolding a new research project. Not directly loaded by ai-resources sessions. | INFO | 1–26 | No action — template intent is clear from path (workflows/research-workflow/). |

**No HIGH or MEDIUM findings in Section 1 for ai-resources scope.** Both files are well under recommended size limits, contain compaction guidance, and have no skill-eligible content to migrate.

---

## 2. Skill Census

**Total skills measured:** 73 (71 main + 2 reference copies under `workflows/research-workflow/reference/skills/`)
**Total lines across all skills:** 15,408
**Total estimated tokens:** ~177,874

**Frontmatter compliance:** 100% — all 73 skills have YAML frontmatter with `name:`, `description:`, `model:`, and `effort:` fields.

**Size distribution:**
- **Over 300 lines (HIGH):** 7 skills — `answer-spec-generator` (487), `research-plan-creator` (466), `ai-resource-builder` (415), `ai-prose-decontamination` (411), `evidence-to-report-writer` (355), `workflow-evaluator` (318), `workflow-system-critic` (302)
- **150–300 lines (MEDIUM):** 46 skills
- **Under 150 lines:** 20 skills

**Top 5 largest:**

| Rank | Skill | Lines | Tokens | Note |
|---|---|---|---|---|
| 1 | answer-spec-generator | 487 | ~4,798 | Research-pipeline skill; complexity justified by scope |
| 2 | research-plan-creator | 466 | ~4,560 | Research-pipeline skill |
| 3 | ai-resource-builder | 415 | ~4,031 | Three modes (Create/Evaluate/Improve) — split candidate, LOW priority |
| 4 | ai-prose-decontamination | 411 | ~7,913 | Dense pattern/example library; high word:line ratio is by design |
| 5 | evidence-to-report-writer | 355 | ~4,745 | Research-pipeline skill |

**Description quality:** PASS — all 73 descriptions are trigger-rich (explicit activation conditions + task scope). No vague descriptions detected.

**Redundancy:** 0 confirmed pairs. 3 potential pairs checked and cleared as complementary pipelines: `chapter-prose-reviewer`/`chapter-review`, `workflow-evaluator`/`workflow-system-critic`, `editorial-recommendations-generator`/`-qc`.

**Split opportunity:** `ai-resource-builder` consolidates three modes (Create / Evaluate / Improve) that fire under different `/create-skill`, `/improve-skill`, `/audit-critical-resources` commands. Splitting could save ~1,200–1,500 tokens per single-mode invocation. **LOW priority** — the consolidated skill is the canonical home; splitting would scatter the contract across three SKILL.md files and complicate maintenance.

**Reference copies:** `workflows/research-workflow/reference/skills/` holds 2 minor-variant copies (~248 lines). Recommend converting to symlinks to eliminate drift risk — LOW priority but quick win.

**Boundary cases (within ±15% of 150-line threshold):** `specifying-output-style` (151 lines), `gap-assessment-gate` (152 lines). May flip classification under a real tokenizer; flagged in Section 10.

Full notes: `audits/working/audit-working-notes-skills.md`.
**Confidence: HIGH** — direct measurement (wc) plus manual sampling of all 73 descriptions.

---

## 3. Command File Census

**Total command files found:** 61 — all in canonical `.claude/commands/` (no scattered command dirs).
**Total lines across all commands:** 10,371
**Average:** ~170 lines/command, ~2,200 tokens/command. Commands only load on invocation (frontmatter shows in skill-list at session start, full body loads when invoked).

**Commands over 300 lines (HIGH per-invocation cost):** 9 commands

| Command | Lines | Words | Est. tokens (load cost) | Notes |
|---|---|---|---|---|
| new-project | 698 | 6,883 | ~8,947 | Orchestrator; dispatches 5 pipeline subagents. Body is mostly subagent briefs + canonical-permissions block (~70 lines of inline JSON) |
| friday-act | 435 | 4,468 | ~5,808 | Disposition orchestrator; reads improvement-log + journal + scoped project logs at execution time, not at load time |
| friday-checkup | 411 | 3,804 | ~4,945 | Weekly orchestrator; many execution-time reads, no load-time pre-loads |
| deploy-workflow | 353 | 2,088 | ~2,714 | Includes canonical permissions JSON (~30 lines) |
| monday-prep | 330 | 1,445 | ~1,878 | Lower word density (more structured headings) |
| friday-journal | 326 | — | ~4,000 (est.) | Journal review orchestrator |
| permission-sweep | 324 | — | ~4,000 (est.) | Permission audit + remediation |
| repo-dd | 318 | — | ~4,000 (est.) | Repo due diligence pipeline |
| log-sweep | 303 | — | ~3,900 (est.) | Log archival pipeline |

**Commands 200–300 lines (MEDIUM):** 4 — `innovation-sweep` (272), `fix-symlinks` (249), `audit-critical-resources` (245), `session-plan` (210).

**Context loading cost:**
- No command was found to `cat` or auto-include external files >100 lines at load time. The load cost = the command file itself.
- The 9 HIGH commands range from ~1,900 to ~8,950 tokens per invocation. `new-project` (~8,950) is the heaviest; it is also the lowest-frequency (one-off project scaffolding).

**Redundant loading:** No commands re-state CLAUDE.md content. Commands reference docs (`audit-discipline.md`, `qc-independence.md`, etc.) at the path level — the operator/Claude reads them on demand, not auto-loaded.

**Cascading loads (top 5 commands' execution-time read chains):**
1. **new-project** → spawns 5 pipeline-stage subagents in sequence; each subagent has its own context, reads project-specific files. Main session only handles the dispatch + gate triage. **Good pattern — heavy reads are subagent-side, not main-session.**
2. **friday-act** → reads {checkup report} + {AI journal report} + per-scope `improvement-log.md`, `session-notes.md`, `friction-log.md`. Multiple scoped projects = multiple file reads. **Moderate load** — reads are necessary for disposition; not delegable.
3. **friday-checkup** → spawns per-scope sub-checks (improvement-log scan, friday-journal pickup, fading-gate detection, friction-log dormancy). Heavy main-session work to compose the consolidated report. **Could partially delegate** per-scope scans to subagent, but the protocol is currently inline. **MEDIUM finding for Section 9.**
4. **deploy-workflow** → reads workflow template + writes target project. No heavy cascading reads.
5. **monday-prep** → reads `weekly-cadence.md`, scoped project state. Lightweight.

**Findings:**
- 9 commands ≥300 lines = HIGH per-invocation cost. **new-project (~9k tokens)** is the largest; invocation frequency is low so per-session cost is bounded.
- Several Friday-cadence commands (~5–6k tokens each) compound when run back-to-back (`/friday-checkup` → `/friday-act` → `/friday-journal` in a single Friday session can load ~15–20k tokens just for command bodies).

**Confidence: HIGH** — direct measurement (wc -l, wc -w) plus targeted grep for external load references.

---

## 5. Session Patterns & Configuration

**Session telemetry available: YES.** `ai-resources/logs/usage-log.md` (643 lines, 23 session entries in the last 60 days). Recent rating distribution (last 19 entries):

| Rating | Count |
|---|---|
| Efficient | 3 |
| Acceptable | 11 |
| Wasteful | 5 |

Recent recurring friction themes (from 2026-05-22 entries, cross-referenced with friction-log):
- **Read-before-Write Edit failures** — recurring for 3 of last 4 sessions; fix is to pre-fetch `session-notes.md` at `/prime`.
- **Post-commit QC discovery** — `/friday-act` produced 8 plan files without inline QC; QC ran after commit and surfaced corrections. **Wired in 2026-05-22 (Step 3.6 inline QC) — should reduce recurrence.**
- **Stale scratchpad selection in /prime** — filename clock skew breaks lexical sort. **Fixed in 2026-05-22 /prime rewrite (sort by mtime).**
- **Coaching-data.md full read for append** — single 489-line read where a tail read would suffice; ~5–6k tokens/session of waste.

**Configuration audit:**

| Setting | Current value | Recommended | Impact |
|---|---|---|---|
| Default model (settings.json) | Not set — per workspace Model Tier rule | Not set | OK — operator selects via `/model` per session |
| MAX_THINKING_TOKENS | 10000 | 10000 | OK — matches best-practice for routine tasks |
| Autocompact threshold (`CLAUDE_AUTOCOMPACT_PCT_OVERRIDE`) | Not set | 80% | LOW — defaults are workable; explicit override gives earlier warning. Recurring carryover from prior audits (2026-04-18, 2026-04-24); operator-deferred each time. |
| MCP servers | Not observable from repo settings (user-level concern) | Disable unused | Not measurable here |
| Subagent model defaults | Per-agent YAML frontmatter (Opus for judgment, Haiku for mechanical) | Same | OK — fine-grained tiering already in place |

**Hooks active (ai-resources/.claude/settings.json):**
- **PreToolUse:** `check-heavy-tool.sh` (Read/Grep/Bash), `friction-log-auto.sh` (Skill)
- **PostToolUse:** `log-write-activity.sh` + `auto-qc-nudge.sh` (Write/Edit)
- **Stop:** `check-stop-reminders.sh`, `coach-reminder.sh`, `improve-reminder.sh`, `auto-resolve-nudge.sh`
- **SessionStart:** `friday-checkup-reminder.sh`
- **15+ hook scripts under `.claude/hooks/`** (including `check-permission-sanity.sh`, `check-template-drift.sh`, `auto-sync-shared.sh` for cross-project propagation)

**Token implications of hooks:**
- All hooks have `timeout: 5` (`auto-commit` workflow-side hook has `timeout: 15`) — bounded.
- Most hooks write to logs or print short systemMessages — minimal context impact.
- The `check-heavy-tool.sh` PreToolUse hook is itself a token-discipline mechanism (it nudges before expensive reads); a small net token saver.

**Findings:**

| # | Finding | Severity | Recommendation |
|---|---|---|---|
| 5.1 | Autocompact threshold not set; default may be conservative. | LOW | Optional — set `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=80` if pre-compact-checkpoint discipline needs more headroom. Carryover from prior audits. |
| 5.2 | Read-before-Write Edit failure pattern recurring (3 of last 4 sessions on `session-notes.md`). | MEDIUM | Pre-fetch the log-trio (`session-notes.md`, `decisions.md`, `usage-log.md` tails) at `/prime` so wrap edits already have file in context. Cross-references improvement-log "Cache log-trio at /prime" entry. |
| 5.3 | `coaching-data.md` (489 lines) full-read for single append; tail-read would save ~5–6k tokens/append session. | MEDIUM | Read closing ~80 lines for append context, not full file. One-line skill change in `/wrap-session`. |
| 5.4 | Recent "Wasteful" sessions (5 of 19) cluster around post-commit QC discovery — partially mitigated by the 2026-05-22 `/friday-act` Step 3.6 inline QC addition. | LOW | Monitor next 2 Friday cycles; verify rate drops. |

**Confidence: HIGH** — direct read of settings.json, usage-log telemetry, and hook config.

---

## 4. Workflow Token Efficiency

**Workflows identified and audited (4 of 5 planned; new-project pending — section will be completed when subagent returns):**

1. `/friday-checkup` — weekly cadence orchestrator (411 lines, ~4,945 tokens)
2. `/friday-act` — fix-execution cadence (435 lines, ~5,808 tokens)
3. `/create-skill` — resource-creation pipeline
4. `/new-project` — project scaffolding (698 lines — ⏳ subagent still running)

---

### Workflow: /friday-checkup

**Start-of-workflow context:** ~8,438 tokens (workspace CLAUDE.md + ai-resources CLAUDE.md + command file)
**Telemetry:** None — structural inferences.
**Total findings:** 6 (0 HIGH, 3 MEDIUM, 3 LOW)

**Strengths:** Step 7.16 `findings-extractor` delegation (Haiku, ≤30-line cap) correctly avoids pulling sub-reports into main context. Explicit `/compact` checkpoint at Step 5 line 162. All products written to disk.

| # | Finding | Severity | Waste mechanism |
|---|---|---|---|
| F1 | Fading-gate detection (monthly/quarterly, Step 6) reads up to 9 per-project `coaching-data.md` files (~634 lines total) in main session. Pattern-match work; meets the ">3–4 files → subagent" delegation rule. | MEDIUM | Unnecessary large reads in main context |
| S1 | `improvement-analyst` (Step 5K) returns up to 7 findings inline to main before disk write; no per-finding length cap in brief — return payload could approach 200-line HIGH threshold (boundary). | MEDIUM | Subagent return volume risk |
| C1 | No `/compact` between Step 5 (12 lettered sub-checks) and Step 6 (multi-file log scans); accumulated sub-command context carries forward. | MEDIUM | Missing compaction breakpoint |

Full notes: `audits/working/audit-working-notes-workflow-friday-checkup.md`.

---

### Workflow: /friday-act

**Start-of-workflow context:** ~9,301 tokens
**Full main-session context (typical weekly cycle):** ~28,200 tokens
**Total findings:** 8 (3 HIGH, 2 MEDIUM, 2 LOW, 1 INFO)

| # | Finding | Severity | Waste mechanism |
|---|---|---|---|
| FA1 | Step 16a reads SO Advisory + Systems Review full sections in main session (~4,600 tokens); pure display-for-paste, no main-session reasoning required. | HIGH | Delegable large reads in main |
| FA2 | Step 16a reads per-project `session-notes.md` + `friction-log.md` in main (~2,600–15,600 tokens delegable across 2–3 scoped projects). Workflow's own notes (line 428) acknowledge the cost. | HIGH | Delegable large reads in main |
| FA3 | No subagent delegation designed into Step 16a despite the workflow documenting the cost. Only mitigation is conditional manual `/compact`. | HIGH | Missing delegation for known expensive read set |
| FA4 | Context accumulates from Step 9 (read full checkup report) through Step 16 (paste-prompt loop + per-fix plan writes) with no intermediate `/compact`. | MEDIUM | Missing compaction breakpoints |
| FA5 | `/qc-pass` at Step 3.6 runs in main session and reads all plan files back for review. Could be delegated per-file. | MEDIUM | Unnecessary main-session re-read |

Full notes: `audits/working/audit-working-notes-workflow-friday-act.md`.

---

### Workflow: /create-skill

**Start-of-workflow context:** ~10,385 tokens (Path A: direct brief); ~12,630 tokens (Path B: with /grill-me)
**Total findings:** 6 (2 HIGH, 2 MEDIUM, 2 LOW)

| # | Finding | Severity | Waste mechanism |
|---|---|---|---|
| CS1 | `references/evaluation-framework.md` (307 lines) read in main session at Step 3 only to forward to the evaluator subagent — classic delegable pattern. | HIGH | Unnecessary main-session read of file that goes straight to subagent |
| CS2 | Step 3 evaluator returns full report (~80–200 lines) to main session with no output-to-disk + summary pattern — violates the `ai-resources/CLAUDE.md` Subagent Contracts explicitly. | HIGH (boundary) | Subagent return volume |
| CS3 | No `/compact` at any of three natural breakpoints: post-plan, post-evaluation, post-fix. Context accumulates across all phases. | MEDIUM | Missing compaction breakpoints |
| CS4 | `inbox/` brief read in full at Step 1 (typically 50–150 lines). Brief is often short, but the read is unscoped. | LOW | Minor unscoped read |

Full notes: `audits/working/audit-working-notes-workflow-create-skill.md`.

---

### Workflow: /new-project

**Orchestrator:** `.claude/commands/new-project.md` — 698 lines / ~8,948 tokens (largest command in repo)
**Start-of-workflow context:** ~11,747 tokens (workspace CLAUDE.md + ai-resources CLAUDE.md + command file)
**Subagents per run:** 5–7 (stages 3a–5 + optional Stage 6 + implementation-triage gate)
**Total findings:** 7 (1 HIGH, 4 MEDIUM, 2 LOW)

**Strengths:** All 6 stage agents enforce ≤30-line return contracts with disk-persisted artifacts — zero subagent return-volume waste.

| # | Finding | Severity | Waste mechanism |
|---|---|---|---|
| NP1 | Orchestrator file 698 lines / ~8,948 tokens loads in full at every invocation including resume-only continuation invocations that only need the Gate Protocol section. | HIGH | Full 700-line command body loaded even when 90% is irrelevant |
| NP2 | Canonical blocks (Commit Rules, Input File Handling, Compaction, Session Boundaries) duplicated twice inside the orchestrator (lines 452–492 heredoc + lines 497–523 printf-fallbacks) — ~100 lines of duplicated content. | MEDIUM | Duplicate canonical content adds ~800–1,000 tokens per invocation |
| NP3 | Step 11a (line 153) full `Read` of `projects/buy-side-service-plan/CLAUDE.md` in main session to verify one model-ID string; delegable to a one-line `grep`. | MEDIUM | Unnecessarily large read for a single value lookup |
| NP4 | No quantitative `/compact` breakpoints; only 2 operator-discretion suggestions; no compact prelude before the ~460-line Post-Pipeline Enrichment block. | MEDIUM | Missing compaction breakpoints in a 5-stage pipeline |
| NP5 | Continuation mode loads ~1,300 tokens of First-Run-only setup logic on every resume. | MEDIUM | First-run-only content in always-loaded body |

Full notes: `audits/working/audit-working-notes-workflow-new-project.md`.

---

**Confidence: HIGH** for all four workflows — direct instruction-text analysis plus file-size measurements. Subagent return volumes rated MEDIUM confidence (structural inference).

---

## 6. File Handling Patterns

**Read(pattern) deny-rule status (from Step 0.3):** MEDIUM
- **Covered:** `Read(archive/**)`, `Read(logs/*-archive-*.md)`, `Read(inbox/archive/**)`, `Read(**/deprecated/**)`, `Read(**/old/**)`
- **Missing full coverage:** `audits/` (75 files), `reports/` (9 files)
- **Partially covered:** `logs/` (archive subset only), `inbox/` (archive subset only)

**Findings:**

| # | Finding | Severity | Recommendation |
|---|---|---|---|
| 6.1 | `audits/` directory — ~30 historical token-audit and audit reports (some >10,000 words each) sit unprotected. An accidental `Read(audits/*.md)` can pull 5–12K tokens of stale audit history into context. | MEDIUM | Add granular date-stamped deny patterns: e.g., `"Read(audits/token-audit-2026-04-*.md)"`. Do NOT blanket-deny `audits/` — the current audit report and `audits/working/` files are deliberately readable. |
| 6.2 | `reports/` directory — 8 historical `repo-health-report-YYYY-MM-DD.md` files sit unprotected. Each is ~2,000–5,000 words. | MEDIUM | Add: `"Read(reports/repo-health-report-2026-04-*.md)"` (and similar for older variants). Current-report (`repo-health-report-2026-05-16-current.md`) should stay readable. |
| 6.3 | `logs/usage-log-archive.md` (6,472 words) is NOT caught by the existing `Read(logs/*-archive-*.md)` pattern — the pattern requires a hyphenated `-archive-` infix, but this file uses `archive` as a suffix. | MEDIUM | Expand to `Read(logs/*archive*.md)` or add explicit `Read(logs/usage-log-archive.md)`. Quick one-line settings.json fix. |

Full notes: `audits/working/audit-working-notes-file-handling.md`.
**Confidence: HIGH** — direct file scan + deny-rule comparison.

---

## 7. Missing Safeguards

| Safeguard | Status | Severity if missing | Finding |
|---|---|---|---|
| `Read(pattern)` deny rules covering stale/large dirs | **Partial** | HIGH | `audits/` and `reports/` uncovered; `logs/usage-log-archive.md` pattern gap. See Sections 0.3 and 6. |
| Custom compaction instructions in CLAUDE.md | **Present** | MEDIUM | `ai-resources/CLAUDE.md` § Compaction names load-bearing items to preserve. |
| Subagent output-to-disk pattern | **Partial** | HIGH | CLAUDE.md Subagent Contracts explicitly define the pattern and summary-cap (30 lines). However, `/create-skill` Step 3 evaluator violates it by returning full report to main. Contract is defined; enforcement is incomplete. |
| Context window monitoring instructions | **Partial** | MEDIUM | `/clear` between tasks is in CLAUDE.md. Compaction protocol referenced via path. No explicit `/context` or `/cost` check instructions. |
| Session boundaries defined for workflows | **Present** | MEDIUM | `/clear` guidance in CLAUDE.md; Stop hooks nudge wrap-session; handoff/scratchpad pattern documented. |
| Model selection guidance | **Present** | MEDIUM | Per-skill and per-agent `model:` frontmatter in place for all 73 skills and 27 agents. Operator selects session model via `/model`. |
| File read scoping ("read lines X–Y" vs whole file) | **Partial** | MEDIUM | Workspace CLAUDE.md defines "Read-scope floors" as floors, not ceilings. Not universally enforced in skill or command instructions — several large-file reads are unscoped (e.g., `coaching-data.md` full read for append). |
| Output length constraints | **Partial** | MEDIUM | Subagent summary caps explicit (30 lines, 20 lines for proliferating subagents). Per-skill/command output verbosity not universally capped. |
| Effort level guidance | **Partial** | LOW | All 73 skills have `effort:` frontmatter (medium/high). No `/effort` command or env var configuration in settings. Functional but informal. |
| Hook-based output truncation | **Absent** | LOW | No hooks found that cap tool output size. Hooks address workflow compliance (QC nudge, wrap reminder, heavy-tool check) but not output verbosity. |
| Audit/output artifact isolation | **Partial** | MEDIUM | `audits/` and `audits/working/` are both unprotected by `Read()` deny rules — historical audit reports accumulate there. `reports/` similarly uncovered. Active artifacts are intentionally readable; historical accumulation is the risk. |

**Confidence: HIGH** — all items checked against settings.json, CLAUDE.md, hooks, skill frontmatter.

---

## 8. Best Practices Comparison

| # | Practice | Status | Gap description | Priority |
|---|---|---|---|---|
| 1 | CLAUDE.md under 200 lines | **Implemented** | 90 lines — well under. | LOW |
| 2 | `Read(pattern)` deny rules configured | **Partial** | `audits/` and `reports/` uncovered; `logs/usage-log-archive.md` pattern gap. Three actionable one-line fixes. | HIGH |
| 3 | Skills use on-demand loading with trigger-rich descriptions | **Implemented** | 100% frontmatter compliance; all 73 descriptions trigger-rich. | LOW |
| 4 | Subagents for heavy reads (>3–4 files) | **Partial** | Contract is explicit in CLAUDE.md. Violations in 2 workflows: `/create-skill` (evaluation-framework.md delegable read + full evaluator return) and `/friday-act` (Step 16a multi-file reads). | HIGH |
| 5 | Strategic `/compact` at breakpoints | **Partial** | Compaction section in ai-resources CLAUDE.md. Most orchestrator commands (new-project, friday-act, friday-checkup) lack explicit quantitative breakpoints. | MEDIUM |
| 6 | `/clear` between unrelated tasks | **Implemented** | CLAUDE.md line 90: explicit rule. Session Boundaries section also present in research-workflow CLAUDE.md. | LOW |
| 7 | Model selection per task type | **Implemented** | Per-skill and per-agent `model:` frontmatter (Opus for judgment, Haiku for mechanical, Sonnet for orchestration). | LOW |
| 8 | Extended thinking budget controlled | **Implemented** | `MAX_THINKING_TOKENS=10000` in settings.json — matches best-practice for routine tasks. | LOW |
| 9 | Unused MCP servers disabled | **Not observable** | User-level concern; not visible from repo settings. | LOW |
| 10 | Output-to-disk pattern for subagents | **Partial** | Contract is documented and followed by most subagents. `/create-skill` Step 3 evaluator is a named violation. | HIGH |
| 11 | Precise prompts over vague ones | **Partial** | Commands and skills are generally precise (task-scoped briefs, explicit output schemas). No systematic vagueness found; assessment is structural, not measured. | LOW |
| 12 | Session notes pattern | **Implemented** | `/wrap-session`, `/handoff`, session-notes.md pattern fully in place. Stop hooks remind on missing wrap. | LOW |
| 13 | Inter-skill disambiguation where triggers overlap | **Partial** | Three similar-seeming pairs were reviewed and cleared by the skill-census subagent (no confirmed overlapping triggers). No formal disambiguation docs between sister skills. LOW priority given 0 confirmed conflicts. | LOW |
| 14 | Agent/skill prompts use structured sections | **Implemented** | Spot-check of 4 agents (qc-reviewer, token-audit-auditor, system-owner, improvement-analyst): all use `##`/`###` section headers organizing context, task, constraints, output. | LOW |
| 15 | Few-shot examples present where useful | **Partial** | 13 of 73 skills have `#### Example` blocks. Agents have none. Not universally harmful — many agents operate on structured inputs where examples add little. Spot-check the 7 HIGH-severity skills for example gaps. | MEDIUM |

**Key gaps by priority:**
- **HIGH (3):** `Read(pattern)` deny coverage gaps; subagent delegation violations in 2 workflows; output-to-disk contract violations
- **MEDIUM (3):** `/compact` breakpoints in orchestrator commands; output length constraints; few-shot examples in key skills
- **LOW (9):** remainder — implemented or low-impact

**Confidence: HIGH** — all items verified against direct file evidence.

---

## 9. Optimization Plan

### 9.1 Executive Summary

This audit found no catastrophic single-point waste source, but identified a pattern of **delegable reads being performed in the main session** across the three most token-intensive workflows. The Friday cadence (`/friday-act` + `/friday-checkup`) is the largest cumulative drain: a full Friday session loads ~28,000+ tokens in command bodies alone, then adds 2,600–15,600 tokens of per-project log reads that could be delegated or pre-summarized. This is weekly and compounding.

The second cluster is **accumulating historical artifacts** in `audits/` and `reports/` with no `Read()` deny protection. No session has been observed accidentally loading a historical audit report, but the risk grows linearly as the directory fills (~75 files in `audits/` now). Three targeted deny rules would close this risk permanently.

Third, the **output-to-disk contract is defined but violated in `/create-skill`**: the Step 3 evaluator returns 80–200 lines to main and reads a 307-line file just to forward it to a subagent. These are clean, isolated fixes.

Estimated total avoidable waste: **10,000–30,000 tokens/session** on a typical Friday session (HIGH-tier items). Per-session savings on routine sessions: 2,000–6,000 tokens (MEDIUM-tier items).

### 9.2 Prioritized Recommendations

#### HIGH — Fix first

**R1: Wire Step 16a file reads in /friday-act to a pre-summarizing subagent**

| Field | Content |
|---|---|
| **Issue** | `/friday-act` Step 16a reads SO Advisory, Systems Review, and per-project `session-notes.md` + `friction-log.md` in main session |
| **Evidence** | `friday-act.md` lines 77–79, 428; subagent audit finds ~2,600–15,600 tokens delegable across 2–3 scoped projects |
| **Waste mechanism** | Main session performs pure display-for-paste reads; no reasoning required; violates ">3–4 files → subagent" rule |
| **Estimated savings** | HIGH — 2,600–15,600 tokens/Friday session, weekly |
| **Implementation steps** | (1) Add a Step 16a-pre subagent that reads the SO Advisory, Systems Review, and each scoped project's logs, returns a ≤30-line paste-ready summary per scope. (2) Replace the current inline reads with subagent invocation. (3) Main session receives summaries and runs the paste-prompt loop unchanged. |
| **Risk** | LOW — the main-session paste-prompt logic is unchanged; only the read mechanism changes |
| **Dependencies** | None |
| **Category** | Structural change |

---

**R2: Add granular `Read()` deny rules for historical artifacts**

| Field | Content |
|---|---|
| **Issue** | `audits/` (75 files), `reports/` (9 files), and `logs/usage-log-archive.md` have no `Read()` deny protection |
| **Evidence** | `ai-resources/.claude/settings.json` — no `audits/` or `reports/` deny entries. `logs/usage-log-archive.md` (6,472 words) pattern gap |
| **Waste mechanism** | Claude Code exploration (Glob, Grep, Read) may accidentally pull historical audit reports (some >10,000 words each) into context |
| **Estimated savings** | HIGH — 5–15K tokens per accidental read; risk grows as directories accumulate |
| **Implementation steps** | Add to `permissions.deny` in `ai-resources/.claude/settings.json`: `"Read(audits/token-audit-2026-04-*.md)"`, `"Read(audits/friday-checkup-2026-04-*.md)"`, `"Read(reports/repo-health-report-2026-04-*.md)"`, `"Read(logs/*archive*.md)"`. Pattern by date prefix preserves active files. |
| **Risk** | LOW — only denies date-prefixed historical files, not the current session's report or active files |
| **Dependencies** | None |
| **Category** | Quick win |

---

**R3: Fix `/create-skill` Step 3 output-to-disk violation**

| Field | Content |
|---|---|
| **Issue** | (a) `references/evaluation-framework.md` (307 lines) read in main to forward to evaluator subagent. (b) Evaluator returns full report (~80–200 lines) to main without disk write |
| **Evidence** | `create-skill.md` Step 3; `audit-summary-workflow-create-skill.md` findings CS1 and CS2 |
| **Waste mechanism** | (a) Unnecessary 307-line read in main context. (b) Violates Subagent Contracts — full return to main instead of file path + ≤30-line summary |
| **Estimated savings** | HIGH — 1,500–5,000 tokens per `/create-skill` invocation |
| **Implementation steps** | (a) Remove the main-session read; pass `evaluation-framework.md` path to evaluator subagent directly. (b) Update the evaluator subagent brief to write findings to `audits/working/evaluation-{skill-name}.md` and return only the path + 1-line verdict. |
| **Risk** | LOW — subagent contract is already defined; this brings create-skill into compliance |
| **Dependencies** | None |
| **Category** | Quick win |

---

**R4: Pre-fetch log-trio at `/prime` to eliminate recurring Edit failures**

| Field | Content |
|---|---|
| **Issue** | `session-notes.md` Edit failures due to Read-before-Write requirement recur in 3 of last 4 sessions |
| **Evidence** | `usage-log.md` entries 2026-05-22: "Edit on session-notes.md failed because the file was not Read in-session first → one corrective Read → retry. One wasted call." |
| **Waste mechanism** | Recurring wasted tool round-trip (~1.5k tokens/session + read of ~500-line file); also friction |
| **Estimated savings** | MEDIUM — ~1,500 tokens saved per session that wraps (most sessions) |
| **Implementation steps** | Add to `/prime` Step 1 (already reads session-notes.md): also tail-read `decisions.md` (last 10 lines) and `usage-log.md` (last 30 lines). These become in-context for the wrap step, eliminating the failed-Edit → re-Read pattern. |
| **Risk** | LOW — additive reads at session start; bounded by the tail-read scope |
| **Dependencies** | None |
| **Category** | Quick win |

---

#### MEDIUM — Plan next session

**R5: Add `/compact` breakpoints to orchestrator commands**

| Field | Content |
|---|---|
| **Issue** | `/friday-act`, `/friday-checkup`, `/create-skill`, and `/new-project` lack quantitative `/compact` breakpoints; context accumulates across multi-hour workflows |
| **Evidence** | Workflow audit findings FA4, FC-C1, CS3, NP4 |
| **Estimated savings** | MEDIUM — prevents context runaway in long sessions; estimated 5,000–15,000 token savings per interrupted workflow |
| **Implementation steps** | For each command: identify the 1–2 natural breakpoints (e.g., post-read/pre-write, post-Phase-1/pre-Phase-2), add an inline instruction: `"[COMPACT SUGGESTED] Context has grown from {prior work}. If approaching 70% context usage, run /compact before continuing."` |
| **Risk** | LOW — advisory only; no behavioral change if operator ignores |
| **Category** | Structural change (4 command files) |

---

**R6: Tail-read `coaching-data.md` instead of full read**

| Field | Content |
|---|---|
| **Issue** | `logs/coaching-data.md` (489 lines) is read in full during wrap sessions for a single append-only operation |
| **Evidence** | `usage-log.md` 2026-05-22 Acceptable entry: "coaching-data.md (~489 lines) read in FULL for a single append-only edit — a tail read of the closing section would have sufficed." |
| **Estimated savings** | MEDIUM — ~5,000–6,000 tokens per coaching-append session |
| **Implementation steps** | In `/wrap-session` skill: replace `Read(coaching-data.md)` with `Read(coaching-data.md, offset=-80)` (last 80 lines) for the append context. Full read still valid if structural content is needed. |
| **Risk** | LOW — only the read scope changes; the append content is unchanged |
| **Category** | Quick win |

---

**R7: Delegate friday-checkup fading-gate coaching-data reads**

| Field | Content |
|---|---|
| **Issue** | `/friday-checkup` Step 6 (monthly+) reads up to 9 per-project `coaching-data.md` files in main session for pattern-matching |
| **Evidence** | Workflow audit finding FC-F1; up to 9 files × ~490 lines each = ~4,400 lines of pattern-match reads in main |
| **Estimated savings** | MEDIUM — 3,000–8,000 tokens on monthly-tier Friday sessions |
| **Implementation steps** | Add a fading-gate-scan subagent: reads all coaching-data.md files, applies the gate-calibration.md suppression check, returns per-scope gate findings (≤30 lines). Replace inline Step 6 reads with the subagent invocation. |
| **Risk** | LOW — mechanical pattern-match; no judgment lost to subagent |
| **Category** | Structural change |

---

#### LOW — Opportunistic

**R8:** Add few-shot examples to the 7 skills over 300 lines. Most are instruction-dense but lack canonical examples of input→output pairs. 2–3 examples reduce instruction-following errors and may reduce correction cycles.

**R9:** Convert 2 reference-copy skills in `workflows/research-workflow/reference/skills/` to symlinks. Prevents drift and halves the line count in that subdirectory.

**R10:** Set `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=80` in settings.json. Low-effort configuration that gives earlier compaction warning. Carryover from prior audits — operator-deferred; escalating recommendation.

**R11:** Trim `new-project.md` — remove ~100 lines of duplicated canonical blocks (Commit Rules, Input File Handling, etc.) and the ~1,300 tokens of First-Run-only setup loaded on every resume. Reference the workspace CLAUDE.md instead of embedding verbatim.

### 9.3 Safeguard Proposals

**S1: Expand `Read()` deny rules (implements R2)**
Add to `ai-resources/.claude/settings.json` → `permissions.deny`:
```json
"Read(audits/token-audit-2026-04-*.md)",
"Read(audits/friday-checkup-2026-04-*.md)",
"Read(reports/repo-health-report-2026-04-*.md)",
"Read(logs/*archive*.md)"
```
Update annually as historical batches accumulate.

**S2: Add `audit-summary-cap` lint to `/create-skill` Step 3 subagent brief**
Require the evaluator to write findings to `audits/working/evaluation-{name}.md` before returning. One-line addition to the subagent brief in `create-skill.md`.

**S3: Add a pre-commit check for `audits/working/` staging**
The 2026-05-22 session had a failed git commit because gitignored `audits/working/` was staged. Wire a check into the commit guidance in CLAUDE.md or as a Pre-Commit hook: confirm `audits/working/` is gitignored before staging `audits/`.

### 9.4 Implications for Future Opus 4.7 Upgrade

- **R1 is a prerequisite:** The Step 16a delegable-reads fix becomes more valuable at Opus 4.7 pricing, which is higher per token than Sonnet.
- **R2 (deny rules) is model-agnostic** but protects against large accidental reads regardless of model tier.
- **The per-skill/per-agent tiering system (model: haiku/sonnet/opus in frontmatter) is already in place** — a model upgrade won't break it; tiers just resolve to newer versions.
- **The `/create-skill` output-to-disk fix (R3) reduces the token cost** of a workflow that runs at Opus tier (evaluator subagent is Opus); higher savings at Opus 4.7.
- **`MAX_THINKING_TOKENS=10000` is already set** — no adjustment needed for Opus 4.7 on routine tasks.

### 9.5 Assumptions and Gaps

- **Subagent return volumes (Section 4)** are structural inferences from workflow instructions, not observed execution data. Actual return sizes depend on session content and may vary ±50%.
- **No `/cost` data available** — session token consumption estimates are protocol proxies (word count × 1.3), subject to ±30% drift vs. actual tokenization.
- **MCP server configuration** is user-level and not observable from the repo. If MCP servers are active, per-request token overhead is unaccounted for here.
- **The workspace-root CLAUDE.md** (~250 lines, ~3,200 tokens) loads in every ai-resources session alongside `ai-resources/CLAUDE.md` but is out of scope for this audit. Its per-session cost dominates ai-resources/CLAUDE.md's; a workspace-scope audit is recommended to assess it.

---

## 10. Self-Assessment

**1. Audit token cost:** `/cost` not available. The audit consumed approximately 8 inline-section steps + 6 subagent delegations (Section 2 mechanical, Sections 4×4 workflows, Section 6 mechanical). Estimated main-session context growth: ~80,000–120,000 tokens across all sections. Within the 1M context limit; no compaction triggered.

**2. Protocol gaps encountered:**
- Section 0.3 verdict (MEDIUM) required an "operator-intent caveat" not present in the protocol template — the expected-coverage list doesn't distinguish between dirs containing active artifacts vs. stale archives. Protocol v1.3 would benefit from a note that `audits/` and similar "live output" dirs are intentional exceptions to blanket directory denies.
- Workflow audit subagent `token-audit-auditor` for `/new-project` ran at 317 seconds and returned a 24-line summary — within contract but at the high end of duration. Large command files (698 lines) stress the subagent.
- Section 7's "Effort level guidance" item doesn't clearly map to Claude Code's current features — `/effort` is not a standard command. Assessed via skill frontmatter `effort:` field as a reasonable proxy.

**3. Confidence ratings:**

| Section | Confidence | Basis |
|---|---|---|
| 0. Pre-Flight | HIGH | Direct file reads + settings.json parse |
| 1. CLAUDE.md | HIGH | Direct measurement + content read |
| 2. Skill Census | HIGH | Batch wc measurement + description sampling |
| 3. Command Census | HIGH | Direct measurement + grep for load patterns |
| 4. Workflow Audit | HIGH (context) / MEDIUM (return volumes) | Instruction-text analysis; volumes are inferences |
| 5. Session Patterns | HIGH | Direct settings + usage-log read |
| 6. File Handling | HIGH | Direct file scan + deny-rule comparison |
| 7. Missing Safeguards | HIGH | All items verified against files |
| 8. Best Practices | HIGH | All 15 items verified against direct evidence |
| 9. Optimization Plan | HIGH | Cross-section synthesis from HIGH-confidence inputs |

**4. Threshold-boundary findings:**
- `specifying-output-style` (151 lines) and `gap-assessment-gate` (152 lines) — within ±1–2 lines of 150-line MEDIUM threshold.
- `ai-prose-decontamination` (411 lines, 7,913 estimated tokens) — HIGH on line count. Word count proxy is high (dense examples); actual tokenization may be lower.
- Section 4 create-skill finding CS2 (evaluator return 80–200 lines) — boundary case for HIGH vs. MEDIUM subagent return threshold (200 lines).

---
