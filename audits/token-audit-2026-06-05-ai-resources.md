# Token Usage Optimization Audit — ai-resources repo

**Date:** 2026-06-05
**Scope:** ai-resources repo (`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`)
**Protocol:** token-audit-protocol.md v1.3
**Previous audit:** token-audit-2026-05-25-ai-resources.md (delta noted per section)
**Cadence:** Friday-checkup run — DIAGNOSTIC ONLY, not committed.

> Token estimates use word count × 1.3 (±30% proxy caveat). Severity thresholds are approximate. Findings within ±15% of a threshold are flagged in Section 10.

---

## 0. Pre-Flight

**0.1 Baseline metrics:** `/cost` and `/context` not available in this automated cadence environment. Non-blocking.

**0.2 session-usage-analyzer data:** Skill present at `skills/session-usage-analyzer/SKILL.md`. Active log `logs/usage-log.md` (~81 KB) present; two archive logs are deny-covered. ai-resources scope → Section 5 inline.

**0.3 Read(pattern) deny-rule coverage — VERDICT: MEDIUM** (unchanged from 2026-05-25)

Settings scanned: `.claude/settings.json` (deny populated), `.claude/settings.local.json` (deny empty), `workflows/research-workflow/.claude/settings.json` (workflow-local, out of main scope).

Read(...) deny rules in `.claude/settings.json`:
`Read(archive/**)`, `Read(logs/*-archive-*.md)`, `Read(logs/*archive*.md)`, `Read(inbox/archive/**)`, `Read(**/deprecated/**)`, `Read(**/old/**)`.

| Expected dir | Coverage |
|---|---|
| archive/ | Covered |
| deprecated/, old/ | Covered |
| logs/ | Partial (archive files only; active logs readable) |
| inbox/ | Partial (archive subdir only) |
| audits/ | **Not covered** |
| reports/ | **Not covered** |
| drafts/ | n/a (no drafts dir) |
| output/ | n/a (not present in ai-resources) |

>2 expected dirs lack coverage → MEDIUM. **Operator-intent caveat (carried from prior audit):** `audits/`, `reports/`, `logs/`, and `inbox/` deliberately hold active artifacts the operator wants Claude to read; blanket directory denies would break that. Section 6 recommends granular patterns (date-stamped historical reports) rather than directory-wide denies.

Working notes: `audits/working/audit-working-notes-preflight-2026-06-05.md`.

---

## 1. CLAUDE.md Audit

**Files in scope:**
| File | Lines | Words | Est. tokens | Headings |
|---|---|---|---|---|
| `CLAUDE.md` (ai-resources) | 98 | 1,141 | ~1,483 | 14 |
| `workflows/research-workflow/CLAUDE.md` | (workflow-local) | — | — | — |

**Per-session cost:** The ai-resources CLAUDE.md costs ~1,483 tokens per turn. Over a 30–50 turn session, ~44,000–74,000 tokens purely on CLAUDE.md loading. (Note: the workspace-root CLAUDE.md also loads in every session but is outside this scope's audit root.)

**Assessment:**
1. **Size:** 98 lines — well under the 200-line recommendation. PASS.
2. **Essentials-only:** All sections apply across most session types in this repo (skill creation, commit/push rules, session telemetry, maintenance cadence, permission management). No workflow-specific blocks that belong in a skill.
3. **Skill-eligible content:** None. The Skill Creation section is a 2-line pointer to `ai-resource-builder/SKILL.md`, not inlined methodology — correct pattern.
4. **Redundancy with skills:** Commit/Push rules are intentionally duplicated from workspace CLAUDE.md (lines 73–85 self-document this: "repeated here because projects are sometimes opened without the parent workspace context loaded"). Deliberate, justified.
5. **Compaction instructions:** Present (lines 87–94). PASS.
6. **Aspirational vs behavioral:** All content is behavioral/directive. No aspirational filler.

**Findings:**

| # | Finding | Severity | Lines | Recommendation |
|---|---|---|---|---|
| 1 | No HIGH/MED/LOW findings. CLAUDE.md is lean (98 lines), behavioral, has compaction guidance, no skill-eligible content. | — | — | No action. |

**Delta from 2026-05-25:** Unchanged — prior audit also reported no Section 1 findings.

---

## 3. Command File Census

**Total command files:** 72 — all in canonical `.claude/commands/` (no scattered command dirs). Up from 61 on 2026-05-25 (+11 commands).

**Aggregate size:** ~11,246 lines / ~99,167 words across all command bodies (~129,000 est. tokens if all loaded — but commands load on-demand, one per invocation, so this is not a per-session cost).

**Top command files by size:**

| Command | Lines | Words | Loads external context |
|---|---|---|---|
| new-project.md | 665 | 5,434 | Reads project CLAUDE.md precedents; copies template fragments (on-demand) |
| prime.md | 452 | 5,647 | Tail-reads session-notes + log-trio (decisions, usage-log last 30 lines) |
| friday-act.md | 451 | 4,393 | Per-project log reads (delegable) |
| friday-checkup.md | 424 | 4,118 | Reads improvement-log, friction-log, per-project coaching-data |
| wrap-session.md | 409 | 5,953 | Inlines /usage-analysis flow; reads usage-log.md |
| archive-project.md | 370 | 2,562 | — |
| monday-prep.md | 340 | 1,570 | — |
| deploy-workflow.md | 337 | 2,202 | Workflow reference docs |
| friday-journal.md | 326 | 3,780 | AI-journal source |
| repo-dd.md | 318 | 2,714 | Delegates to repo-dd-auditor subagents |
| session-start.md | 317 | 3,435 | — |
| token-audit.md | 220 | 1,534 | Reads token-audit-protocol.md (one-time, held in context) |

**Assessment:**
1. **Context loading cost:** Commands read specific named files (protocol, reference docs, log tails) on invocation — appropriate on-demand loading, not bulk `cat`. The high-cost pattern is per-project log reads in the Friday-cadence commands (`friday-act`, `friday-checkup`), which read multiple per-project files in the main session rather than delegating. This is the same finding carried forward — covered in Section 4 (workflow audit) and Section 9.
2. **Redundant loading:** No command re-loads CLAUDE.md content (it's already in context). `prime`'s log-trio pre-fetch (R4 from 2026-05-25) is a deliberate optimization, not redundancy.
3. **Cascading loads:** The Friday cadence (`friday-checkup` → `friday-journal`/`friday-act`) chains multiple per-project scans. `friday-checkup` (424 lines) + `friday-act` (451 lines) load ~28,000+ tokens in command bodies alone across a full Friday session, plus per-project log reads. Largest cumulative chain — flagged in Section 4/9.

**High-cost commands (>500 tokens external context on invocation):**

| Command | What it loads | Est. cost | Recommendation |
|---|---|---|---|
| friday-checkup | improvement-log + friction-log + per-project coaching-data (up to 9 files) | ~4,400+ lines pattern-match reads in main | Delegate per-project scans to subagent (carryover MED) |
| friday-act | per-project logs across active projects | 2,600–15,600 tokens | Delegate or pre-summarize (carryover) |
| token-audit | token-audit-protocol.md (~640 lines, held once) | ~6,000 tokens, one-time | Acceptable — protocol held in context, not re-read |

**Delta from 2026-05-25:** Command count grew 61 → 72. No new high-cost loading patterns introduced; the Friday-cadence delegable-read finding persists.

---

## 2. Skill Census

**Total skills found:** 80 (78 under `skills/` + 2 reference copies under `workflows/research-workflow/reference/skills/`).
**Total lines across all skills:** 16,973
**Total estimated tokens across all skills:** ~155,828 words × 1.3 ≈ 202,576 tokens (full corpus — NOT a per-session cost; skills load on demand, one or a few per session).

Run via inline batch-then-selective-read (no subagent tool available in this execution environment; protocol Execution Notes permit inline at narrow scope / as fallback).

**Size distribution:**
- Under 50 lines: 0 skills
- 50–150 lines: 22 skills
- 150–300 lines: 50 skills
- Over 300 lines: 8 skills

**Skills over 300 lines (HIGH per protocol's load-cost threshold):**

| Rank | Skill | Lines | Words | Assessment |
|---|---|---|---|---|
| 1 | answer-spec-generator | 487 | 3,691 | Trigger-rich description; multi-pass spec methodology. Length justified by scope. |
| 2 | research-plan-creator | 466 | 3,508 | Trigger-rich; sequenced research-question generation. Justified. |
| 3 | ai-resource-builder | 432 | 3,250 | Canonical skill-builder (8-layer framework + create/improve/evaluate). Justified — high reuse. |
| 4 | ai-prose-decontamination | 411 | 6,087 | Five-pass decontamination; word-dense (6,087 words = highest token load of any skill). Candidate for example compression review. |
| 5 | evidence-to-report-writer | 393 | 4,206 | Trigger-rich; report-narrative transform. Justified. |
| 6 | cluster-memo-refiner | 324 | 3,401 | Ten structured checks; close to threshold. |
| 7 | workflow-evaluator | 318 | 2,513 | Just over threshold. |
| 8 | workflow-system-critic | 302 | 2,361 | Just over threshold (boundary — see Section 10). |

**Assessment:** All 8 over-300 skills have trigger-rich descriptions with explicit "Use when" / "Do NOT trigger" discriminators — no vague-description triggering risk. Length is driven by genuine multi-pass methodology, not verbosity. The only skill flagged for a possible content-compression review is `ai-prose-decontamination` (6,087 words — by far the densest), where canonical examples could plausibly be trimmed. This is LOW priority because the skill loads on demand only during prose work.

**Description quality issues:** None. All 80 skills have YAML frontmatter with `name:` and `description:`; all spot-checked descriptions are trigger-rich.

**Missing frontmatter:** None (all 80 pass the name+description check).

**Redundancy flags:** 0 confirmed. The two reference copies (`knowledge-file-producer`, `report-compliance-qc` under `research-workflow/reference/skills/`) are intentional workflow-bundled copies, not stray duplicates — they are slightly smaller than the canonical `skills/` versions and travel with the deployable workflow. Prior-audit's three checked pairs (`chapter-prose-reviewer`/`chapter-review`, `workflow-evaluator`/`workflow-system-critic`, `editorial-recommendations-generator`/`-qc`) remain complementary (generator vs. QC, or analyzer vs. critic) — descriptions state distinct triggers.

**Dead skills:** None detected (no `old`/`deprecated`/`v1`/`archive` naming; all referenced or part of active pipelines).

**Findings:**

| # | Finding | Severity | Recommendation |
|---|---|---|---|
| S2-1 | 8 skills exceed 300 lines (load-cost HIGH when invoked), but all are justified multi-pass methodologies with trigger-rich descriptions. | LOW (no action) | No split required. Monitor `ai-prose-decontamination` (densest) for example compression if it grows. |
| S2-2 | No vague descriptions, no missing frontmatter, no confirmed redundancy, no dead skills. | — | No action. |

**Delta from 2026-05-25:** Skill count 73 → 80 (+7). Prior audit reported 0 confirmed redundancy and similar size profile. No regression; the +7 new skills did not introduce dead skills or vague descriptions.


## 4. Workflow Token Efficiency

**Workflows identified:** 1 active — `research-workflow` (8 references across CLAUDE.md + commands). Only one workflow exists under `workflows/`, so per the protocol's "<4 → audit all" rule, this is the complete set. Run inline (no subagent tool in this execution environment).

### Workflow: research-workflow

**Structure:** 31 workflow-local commands, a `reference/` library (stage-instructions, quality-standards, file-conventions, stage-5 phase docs, SOP files, templates), and 2 bundled reference-copy skills. Workflow CLAUDE.md is 155 lines with compaction guidance (4 `/compact` references).

**Context loading chain (per stage command):**
1. Workflow CLAUDE.md (~155 lines, ~2,300 tokens) — loads with the workflow context.
2. Stage command body (e.g., `produce-prose-draft` 242 lines, `run-analysis` 199 lines).
3. On invocation: reads `reference/stage-5-paths.md` (path-config) + relevant template — lightweight, lazy (Phase 0 explicitly says "Do NOT read source files yet").

**File-handling discipline — STRONG (best-practice model):**

| Pattern | Evidence | Verdict |
|---|---|---|
| Path-passing, not content-passing | `stage-instructions.md:77` — "Main agent passes extract paths (not content) to one sub-agent per cluster; each sub-agent reads its own extracts" | Exemplary |
| Large reference files passed by path | `stage-instructions.md:179` — style-reference/prose-quality-standards passed by absolute path "avoids duplicating ~1,200 lines across main + each subagent brief" | Exemplary |
| Subagents return summaries, not full output | `run-analysis.md:39,59,69,78` — each sub-agent "Write[s] to {path}. Return: output file path, [structured summary]" (gap inventory / file inventory / decision counts) | Exemplary |
| Checkpoints carry state across compaction | `run-analysis.md:40,61,70` — checkpoint written from returned summary, then `▸ /compact` | Exemplary |
| Explicit `/compact` markers at boundaries | `stage-instructions.md:160` — "Commands include explicit `▸ /compact` markers at natural boundaries — typically after a step that loaded a skill file and wrote its output" | Exemplary |
| Parallel sub-agents for independent units | `run-analysis.md:60` — "Launch sub-agents in parallel for independent clusters" | Exemplary |

**Subagent pattern:**

| Subagent purpose | Returns to main? | Return size |
|---|---|---|
| Gap assessment (run-analysis Step 2) | Path + gap inventory only | Small (structured list) |
| Per-cluster directives (Step 4) | Path + scarcity refs + key decisions | Small |
| Editorial review (Step 5) | Path + decisions surfaced + flags | Small |
| Prose draft subagents (produce-prose-draft) | Write to prose_output_dir; 3–5 launches/section | Small (skill content passed, output to disk) |

**Findings:**

| # | Finding | Severity | Waste mechanism | Recommendation |
|---|---|---|---|---|
| W4-1 | No token-waste findings. The workflow already implements every best-practice token pattern: path-passing, write-to-disk + summary-only returns, explicit `/compact` at skill-load boundaries, parallel isolation. | — | — | No action. This workflow is the reference model for the repo's other delegating commands. |

**Delta from 2026-05-25:** Prior audit also found research-workflow clean; the largest cumulative drain identified was the Friday cadence (`/friday-act` + `/friday-checkup`), which are top-level commands, not this workflow. No regression.


## 5. Session Patterns & Configuration

**Session telemetry available:** Yes — `logs/usage-log.md` (~81 KB, active) plus deny-covered archives. ai-resources scope → run inline.

**Key patterns from recent telemetry (last ~5 sessions):**
- **Recurring lever (R4): `session-notes.md` tail re-read 4–5× per multi-phase session** (across /prime header-detect, /session-start guard, /wrap-session guard, mandate lookup, append point). Flagged 8+ consecutive entries. ~1.5–3k tokens/session, ~6–15k/week. Structural (workflow), not config. Still unshipped — highest-frequency open lever.
- **Positive: Decision-Point Posture + /risk-check skips** saved ~20–30k tokens/session by avoiding deterministic ceremony — called out as a pattern to keep, not waste.
- **Positive: context-discovery engine skipped** when brief pre-enumerates sources (~2–3k/session saved).

**Configuration audit:**

| Setting | Current value | Recommended | Impact |
|---|---|---|---|
| Default model | NOT SET (correct — operator selects via `/model`) | Must stay unset per workspace no-model rule | Correct posture; do not add |
| Subagent model | NOT SET | Per-agent frontmatter only | Correct (no settings default) |
| MAX_THINKING_TOKENS | **10000** (SET) | 10000 for routine | Optimal — matches recommendation |
| Autocompact threshold | **CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=80** (SET) | 80% | Now implemented (prior R10 resolved) |
| MCP servers active | Not observable from repo context | Disable unused | N/A this scope |

**Hooks:** 16 hooks across PreToolUse / PostToolUse / Stop / SessionStart (log-write-activity, detect-concurrent-session, coach-reminder, auto-sync-shared, check-skill-size, check-stop-reminders, check-permission-sanity, check-template-drift, improve-reminder, backup-session-plan, and others). All are lightweight nudge/log hooks. None truncate tool output (no output-cap hook present — see Section 7). No token-cost concern from hooks themselves; their stdout is small.

**Delta from 2026-05-25:** **Two config improvements landed.** `MAX_THINKING_TOKENS=10000` and `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=80` are now both set — the prior audit's R10 (operator-deferred autocompact override) is RESOLVED. Model correctly remains unset.

## 6. File Handling Patterns

**Read(pattern) deny-rule status (from Step 0.3):** MEDIUM
Covered directories: `archive/`, `inbox/archive/`, `**/deprecated/`, `**/old/`, `logs/*archive*.md` (archive logs only).
Missing expected coverage: `audits/` (active dir, holds 40 historical reports), `reports/` (11 reports), `inbox/` (active), `logs/` (active non-archive logs).

**Large readable files (top, by line count; deny-covered archives excluded from concern):**

| File / cluster | Lines | Should Claude read this? | Parent covered by Read() deny? |
|---|---|---|---|
| `logs/session-notes-archive-2026-05.md` (5,187) + 2026-04 (3,370) | 8,557 | No (archives) | **Yes** (`logs/*archive*.md`) — correct |
| `logs/decisions-archive-*` (1,814 + 752) | 2,566 | No | **Yes** — correct |
| `logs/usage-log-archive-2026-05.md` (856) | 856 | No | **Yes** — correct |
| `audits/repo-due-diligence-*.md` (~30 files, 600–935 lines each) | ~20,000+ | No (prior reports) | **No** |
| `audits/token-audit-2*.md` (historical) | several × 640+ | No (prior reports) | **No** |
| `audits/working/*.md` (226 files) | ~24,700 | No (stale subagent working-notes) | **No** |
| `reports/repo-health-report-*.md` (11 files) | several hundred each | No (prior reports) | **No** |

**Assessment:**
1. **Archives are correctly protected** — the `logs/*archive*.md` denies cover the three largest files in the repo (the session-notes and decisions archives, ~11,000 lines). This is the right pattern and the most impactful coverage.
2. **`audits/` and `audits/working/` are the main remaining exposure.** 40 historical audit reports + 226 working-notes files (~45,000 lines combined) are readable during Glob/Grep/Read exploration. Most are stale (dated, superseded). However — operator-intent caveat: `audits/` is also where the *current* audit (this file) and active pipeline-review/registry artifacts live, so a blanket `Read(audits/**)` deny would break legitimate reads.
3. **Workspace hygiene:** `audits/working/` (226 files) is the strongest candidate for granular denial — it holds only superseded subagent scratch notes by design, none of which an active command needs to read.

**Findings:**

| # | Finding | Severity | Recommendation |
|---|---|---|---|
| F6-1 | `audits/working/` (226 files, ~24,700 lines of stale subagent scratch notes) is readable — no `Read()` deny covers it. | MEDIUM | Add `Read(audits/working/**)` — the directory holds only superseded scratch notes; no active command reads from it. Highest-value granular deny. |
| F6-2 | Historical dated reports in `audits/` and `reports/` (40 + 11 files) are readable. | MEDIUM | Add date-stamped granular denies (e.g., `Read(audits/repo-due-diligence-*.md)`, `Read(audits/token-audit-2*.md)`, `Read(reports/repo-health-report-*.md)`) rather than directory-wide denies, to preserve reads of current artifacts. |
| F6-3 | `inbox/` (active) and `logs/` (active non-archive) uncovered. | LOW | Intentional — operator wants active intake + logs readable. No action; documented exception. |

**Delta from 2026-05-25:** Same MEDIUM verdict and same operator-intent caveat. `audits/working/` growth (now 226 files) strengthens the case for F6-1 as the top granular-deny candidate. No regression; this is a standing, deferred item.


## 7. Missing Safeguards

| Safeguard | Status | Severity if missing | Recommendation |
|---|---|---|---|
| `Read(pattern)` deny rules covering stale/large dirs | **Partial** | HIGH | Archives well-covered (largest files protected). Add `Read(audits/working/**)` + granular dated-report denies (F6-1/F6-2). |
| Custom compaction instructions in CLAUDE.md | **Present** | MEDIUM | Lines 87–94 (ai-resources) + workflow CLAUDE.md (4 refs). No action. |
| Subagent output-to-disk pattern | **Present** | HIGH | Codified in CLAUDE.md Subagent Contracts (30/20-line caps); 18/34 agents state it explicitly; research-workflow exemplary. No action. |
| Context-window monitoring guidance | **Present** | MEDIUM | Workspace CLAUDE.md "Context constraint deferral" rule + `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=80`. No action. |
| Session boundaries (`/clear` between tasks) | **Present** | MEDIUM | CLAUDE.md Session Boundaries (line 96–98) → session-boundaries.md. No action. |
| Model selection guidance | **Present** | MEDIUM | Per-command/agent/skill frontmatter tiering (no settings default, by design). No action. |
| File-read scoping (read lines X–Y) | **Present** | LOW | Workflow commands use "read first 50 lines"/path-passing; /prime tail-reads. No action. |
| Output-length constraints | **Present** | LOW | Subagent summary caps (30/20 lines) enforced in agent bodies. No action. |
| Effort-level guidance | **Absent** | LOW | No `/effort` config or equivalent. Low impact at this scope; not recommended (would add CLAUDE.md weight for marginal gain). |
| Hook-based output truncation | **Absent** | LOW | No hook caps tool-output size. Low value — subagent disk-write pattern already prevents the main waste path. Not recommended. |
| Audit/output artifact isolation | **Partial** | MEDIUM | Outputs ARE in dedicated dirs (`audits/`, `audits/working/`, `reports/`) but those dirs lack `Read()` denies (F6-1/F6-2). Granular denies close this. |

## 8. Best Practices Comparison

| # | Practice | Status | Gap | Priority |
|---|---|---|---|---|
| 1 | CLAUDE.md under 200 lines | Implemented | 98 lines | — |
| 2 | Read(pattern) deny rules configured | Partial | Archives covered; `audits/working/` + dated reports uncovered | MEDIUM |
| 3 | Skills use on-demand loading | Implemented | 80 skills, all frontmatter, trigger-rich descriptions | — |
| 4 | Subagents for heavy reads | Implemented | research-workflow + audit pipelines delegate; this scope lacked the subagent tool but pattern is codified | — |
| 5 | Strategic `/compact` at breakpoints | Implemented | Explicit `▸ /compact` markers in workflow commands | — |
| 6 | `/clear` between unrelated tasks | Implemented | Session Boundaries rule | — |
| 7 | Model selection per task type | Implemented | Frontmatter tiering (analytical=opus, dispatch=sonnet) | — |
| 8 | Extended thinking budget controlled | Implemented | MAX_THINKING_TOKENS=10000 | — |
| 9 | Unused MCP servers disabled | Not observable | N/A from repo context | — |
| 10 | Output-to-disk for subagents | Implemented | Subagent Contracts + 30/20-line caps | — |
| 11 | Precise prompts | Implemented | Commands give exact file paths + line ranges | — |
| 12 | Session-notes pattern | Implemented | /handoff + session-notes.md + /prime load | — |
| 13 | Similar-trigger skills disambiguated | Implemented | "Do NOT trigger for…" clauses in descriptions (e.g., answer-spec-generator) | — |
| 14 | Agent/skill prompts use structured sections | Implemented | Spot-checked agents: 7–18 headings each | — |
| 15 | Few-shot examples where useful | Partial | 4 agents contain explicit example blocks; most rely on rubrics not examples | LOW |

## 9. Optimization Plan

### 9.1 Executive Summary

This audit found no HIGH-severity token-waste source at ai-resources scope. The repo is in strong shape on every per-session lever: CLAUDE.md is lean (98 lines, behavioral, with compaction guidance), all 80 skills carry trigger-rich frontmatter with no dead/redundant skills, the lone workflow (research-workflow) is an exemplary model of token discipline (path-passing, write-to-disk + summary-only subagent returns, explicit `/compact` markers), and two prior-deferred config levers — `MAX_THINKING_TOKENS=10000` and `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=80` — are now both implemented (resolving the prior audit's R10).

The single standing opportunity is **file-handling exposure in `audits/`**: 226 stale subagent working-note files (~24,700 lines) plus ~40 historical dated reports are readable during Glob/Grep/Read exploration because no `Read()` deny covers them. The fix is granular (not directory-wide) denies, to preserve legitimate reads of current artifacts. This is a MEDIUM, standing/deferred item — the same finding the last three audits raised, with the working-notes count now larger.

The other recurring signal is structural, not config: telemetry shows `session-notes.md` is tail-read 4–5× per multi-phase session (the "R4" lever, flagged in 8+ usage-log entries). This is a workflow-design item for /wrap-session and /prime, outside this audit's deny-rule remit, and is tracked in the usage-log and improvement-log already.

### 9.2 Prioritized Recommendations

**MEDIUM tier (quick wins first):**

**R1 — Add `Read(audits/working/**)` deny**
| Field | Content |
|---|---|
| Issue | 226 stale subagent scratch-note files (~24,700 lines) in `audits/working/` are readable during exploration. |
| Evidence | Section 6 F6-1; `audits/working/` file count = 226, total ~24,700 lines; Step 0.3 shows no covering deny. |
| Waste mechanism | Glob/Grep/Read may surface and load superseded scratch notes into context during unrelated tasks. |
| Estimated savings | MEDIUM — directory holds only superseded scratch by design; no active command reads it. |
| Implementation | Add `"Read(audits/working/**)"` to `.claude/settings.json` `permissions.deny`. |
| Risk | None — no active command reads from `audits/working/`. (Audit subagents WRITE there; writes aren't blocked by Read denies.) |
| Dependencies | None. |
| Category | Quick win. |

**R2 — Add granular dated-report denies**
| Field | Content |
|---|---|
| Issue | ~40 historical reports in `audits/` + 11 in `reports/` are readable; most are stale/superseded. |
| Evidence | Section 6 F6-2; large-file scan shows 600–935-line repo-dd/token-audit reports uncovered. |
| Waste mechanism | Exploration reads of prior dated reports add stale context. |
| Estimated savings | MEDIUM. |
| Implementation | Add `"Read(audits/repo-due-diligence-*.md)"`, `"Read(audits/token-audit-2*.md)"`, `"Read(reports/repo-health-report-*.md)"` to deny. Use dated/prefixed globs — NOT `Read(audits/**)` — so the current audit and active registries stay readable. |
| Risk | A future command that legitimately reads a prior dated report would be blocked; low likelihood. Verify no active command greps historical reports before landing. |
| Dependencies | None. |
| Category | Structural change (needs the verify-no-active-reader check). |

**LOW tier:**

**R3 — Monitor `ai-prose-decontamination` for example compression** (411 lines / 6,087 words, densest skill). Loads on demand only; no action now, watch for growth. (Section 2 S2-1.)

### 9.3 Safeguard Proposals
- **Deny-rule maintenance hook (optional):** a periodic check that flags any new top-level output directory lacking a `Read()` deny would catch the `audits/working/` class proactively. Low priority — `/permission-sweep` and this audit already surface it.

### 9.4 Implications for Future Opus 4.7 Upgrade
- CLAUDE.md is already lean — no migration prerequisite.
- `MAX_THINKING_TOKENS=10000` is set; revisit the budget if Opus 4.7 changes thinking-token economics.
- Subagent disk-write discipline is codified — no rework needed.
- No deny-rule change is a migration blocker; R1/R2 are independent of model version.

### 9.5 Assumptions and Gaps
- **No subagent tool in this execution environment.** Sections 2, 4, 5, 6 were run inline (protocol Execution Notes permit inline at narrow scope / as fallback). Token estimates for those sections are structural, not from delegated measurement; findings are unaffected (all measurements are direct `wc` counts).
- `/cost` and `/context` unavailable → audit's own token cost not measured (Section 10).
- MCP-server config not observable from repo context.
- Token counts use word × 1.3 proxy (±30%); see Section 10 threshold-boundary list.

## 10. Self-Assessment

1. **Audit token cost:** Not measurable (`/cost` unavailable in this environment).
2. **Protocol gaps:** (a) Section 0.3's expected-coverage list still doesn't distinguish "live output" dirs (`audits/`, `reports/`) from stale archives — the MEDIUM verdict needs an operator-intent caveat every run (third audit to note this; protocol v1.4 candidate). (b) The delegation instructions assume a Task/subagent tool is available; the protocol should state the inline-fallback explicitly for environments without it.
3. **Confidence levels:**
   - Section 0 (deny rules): HIGH — parsed settings directly.
   - Section 1 (CLAUDE.md): HIGH — read in full.
   - Section 2 (skills): HIGH — batch `wc` + selective description reads.
   - Section 3 (commands): HIGH — measured all 72.
   - Section 4 (workflow): HIGH — read stage-instructions + run-analysis + produce-prose-draft directly.
   - Section 5 (config): HIGH — parsed settings + read telemetry.
   - Section 6 (file handling): HIGH — direct line-count scan.
   - Sections 7–8: HIGH — direct checks.
4. **Threshold-boundary findings (±15% of a severity threshold):**
   - `workflow-system-critic` (302 lines) and `workflow-evaluator` (318 lines) sit just over the 300-line HIGH threshold — under a real tokenizer they may fall to MEDIUM. Both flagged LOW-action regardless (justified methodology), so classification does not change the recommendation.
   - `cluster-memo-refiner` (324 lines) similarly near-boundary.

---

**End of audit.** Diagnostic only — not committed (Friday-checkup cadence).
