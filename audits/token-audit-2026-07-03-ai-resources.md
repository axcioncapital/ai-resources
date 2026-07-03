# Token Usage Optimization Audit — ai-resources repo

**Date:** 2026-07-03
**Scope:** ai-resources repo (`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`)
**Protocol:** token-audit-protocol.md v1.3
**Previous audit:** token-audit-2026-06-05-ai-resources.md (delta noted per section)
**Cadence:** Friday-checkup (quarterly) run — DIAGNOSTIC ONLY, not committed.

> Token estimates use word count × 1.3 (±30% proxy caveat). Severity thresholds are approximate. Findings within ±15% of a threshold are flagged in Section 10.

---

## 0. Pre-Flight

**0.1 Baseline metrics:** `/cost` and `/context` not available in this automated cadence environment. Non-blocking — audit's own token cost not self-measured (Section 10).

**0.2 session-usage-analyzer data:** Skill present at `skills/session-usage-analyzer/SKILL.md`. Active log `logs/usage-log.md` (~90 KB, 583 lines, through ~2026-06-10) present; two archive logs are deny-covered. ai-resources scope (narrower than workspace) → Section 5 runs inline.

**0.3 Read(pattern) deny-rule coverage — VERDICT: MEDIUM** (unchanged from 2026-06-05)

Settings scanned: `.claude/settings.json` (deny populated), `.claude/settings.local.json` (deny EMPTY), `workflows/research-workflow/.claude/settings.json` (workflow-local, out of main scope), and NEW `output/deploy-test-scratch-2026-06-12/.claude/settings.json` (scratch-project settings inside output/).

Read(...) deny rules in `.claude/settings.json` (6 total):
`Read(archive/**)`, `Read(logs/*-archive-*.md)`, `Read(inbox/archive/**)`, `Read(**/deprecated/**)`, `Read(**/old/**)`, `Read(logs/*archive*.md)`.

| Expected dir | Coverage |
|---|---|
| archive/ | Covered |
| deprecated/, old/ | Covered |
| logs/ | Partial (archive files only; active logs readable) |
| inbox/ | Partial (archive subdir only) |
| audits/ | **Not covered** |
| reports/ | **Not covered** |
| output/ | **Not covered — NEW** (output/ now present in ai-resources; prior audit recorded it as "not present") |
| drafts/ | n/a (no drafts dir) |

>2 expected dirs lack coverage → MEDIUM. **Operator-intent caveat (4th audit to note):** `audits/`, `reports/`, `logs/`, `inbox/` deliberately hold active artifacts the operator wants Claude to read; blanket directory denies would break that. Section 6 recommends granular patterns (date-stamped historical reports, `working/` subdir) rather than directory-wide denies.

Working notes: `audits/working/audit-working-notes-preflight-2026-07-03.md`.

---

## 1. CLAUDE.md Audit

**Files in scope:**
| File | Lines | Words | Est. tokens | Headings |
|---|---|---|---|---|
| `CLAUDE.md` (ai-resources) | 77 | 823 | ~1,070 | 13 |
| `workflows/research-workflow/CLAUDE.md` | 155 | 1,611 | ~2,094 | 20 (workflow-local, loads only in workflow context) |
| `output/deploy-test-scratch-2026-06-12/CLAUDE.md` | — | — | — | scratch (not a live session-loaded CLAUDE.md — see Section 6) |

**Per-session cost:** The ai-resources CLAUDE.md costs ~1,070 tokens per turn. Over a 30–50 turn session, ~32,000–53,500 tokens purely on CLAUDE.md loading. (The workspace-root CLAUDE.md also loads every session but is outside this scope's audit root.)

**Assessment:**
1. **Size:** 77 lines — well under the 200-line recommendation, and 21 lines LEANER than the prior audit's 98. PASS.
2. **Essentials-only:** All 13 sections apply across most session types in this repo (repo conventions, skill creation, commit/push, session telemetry, maintenance cadence, permission management, compaction). No workflow-specific blocks that belong in a skill.
3. **Skill-eligible content:** None. The Skill Creation section is a 2-line pointer to `ai-resource-builder/SKILL.md`, not inlined methodology — correct pattern.
4. **Redundancy with skills:** Commit/Push rules point to workspace `CLAUDE.md` as canonical ("Full commit/push behavior … is canonical in workspace CLAUDE.md") rather than re-inlining them — a pointer, not a duplicate. Model Selection likewise points to workspace rule. Correct.
5. **Compaction instructions:** Present (lines 70–77 — inbox brief path, pipeline-stage id, pending subagent-output paths). PASS.
6. **Aspirational vs behavioral:** All content is behavioral/directive. No aspirational filler.

**Findings:**

| # | Finding | Severity | Lines | Recommendation |
|---|---|---|---|---|
| 1 | No HIGH/MED/LOW findings. CLAUDE.md is lean (77 lines), behavioral, has compaction guidance, no skill-eligible content, uses pointers instead of duplication. | — | — | No action. |

**Delta from 2026-06-05:** Improved — CLAUDE.md dropped 98 → 77 lines (~24% leaner) with no loss of behavioral coverage; the prior version's inlined commit/push block is now a canonical pointer. Prior audit also reported no Section 1 findings; this run is cleaner still.

---

## 2. Skill Census

*(Delegated to `token-audit-auditor-mechanical`, SECTION=2. Full notes: `audits/working/audit-working-notes-skills.md`. Main session read the summary only.)*

**Total skills found:** 81 canonical skills (up from 80 on 2026-06-05, +1).
**Total lines across all skills:** 17,472.
**Total estimated tokens across all skills:** ~168,200 words × 1.3 ≈ 218,660 tokens (full corpus — NOT a per-session cost; skills load on demand, one or a few per session).

**Size distribution:**
- Under 50 lines: 0 skills
- 50–150 lines: 22 skills
- 150–300 lines: 50 skills
- Over 300 lines: 9 skills

**Frontmatter compliance:** 100% (81/81 have `name:` + `description:`). **Trigger-rich descriptions:** 100%.

**Skills over 300 lines (mechanical HIGH per the protocol's load-cost size rule):** 9 skills, ~51,148 tokens combined (23% of the library). Densest remains `ai-prose-decontamination` (411 lines, ~7,913 tokens — the single highest per-load skill). Per main-session judgment these are justified multi-pass methodologies with trigger-rich descriptions, not verbosity — **the mechanical HIGH is a size-load classification, not an actionable finding.** No split required.

**Description quality issues:** None (0). **Missing frontmatter:** None (0). **Redundancy flags:** 0 confirmed. **Dead skills:** None (0 — no `old`/`deprecated`/`v1`/`archive` naming; all referenced or part of active pipelines).

**Findings:**

| # | Finding | Severity (actionable) | Recommendation |
|---|---|---|---|
| S2-1 | 9 skills exceed 300 lines (mechanical load-cost HIGH when invoked), but all are justified multi-pass methodologies with trigger-rich descriptions. | LOW (no action) | No split required. Monitor `ai-prose-decontamination` (densest, 411 lines) for example compression if it grows. |
| S2-2 | No vague descriptions, no missing frontmatter, no confirmed redundancy, no dead skills. 100% frontmatter + trigger-rich compliance across all 81. | — | No action. |

**Delta from 2026-06-05:** Skill count 80 → 81 (+1). Over-300 count 8 → 9 (+1). Still 100% frontmatter + trigger-rich, still 0 redundant/dead. Total corpus grew ~16,973 → 17,472 lines. No regression; the +1 skill introduced no dead/vague/redundant entries.

---

## 3. Command File Census

**Total command files:** 84 — all in canonical `.claude/commands/` (no scattered command dirs). Up from 72 on 2026-06-05 (+12 commands).

**Aggregate size:** ~13,192 lines / ~124,193 words across all command bodies (~161,000 est. tokens if all loaded — but commands load on-demand, one per invocation, so this is NOT a per-session cost).

**Top command files by size:**

| Command | Lines | Words | Loads external context |
|---|---|---|---|
| new-project.md | 663 | 5,562 | Reads project CLAUDE.md precedents; copies template fragments (on-demand) |
| prime.md | 566 | 8,251 | Tail-reads session-notes + log-trio (decisions, usage-log) |
| friday-act.md | 491 | 5,010 | Per-project log reads (delegable) |
| wrap-session.md | 483 | 7,980 | Inlines /usage-analysis flow; reads usage-log.md; delegates to session-feedback-collector |
| friday-checkup.md | 452 | 4,861 | Reads improvement-log, friction-log, per-project coaching-data; delegates scans |
| fix-symlinks.md | 390 | 1,857 | Scans projects/ symlinks (NEW command) |
| archive-project.md | 370 | 2,562 | — |
| deploy-workflow.md | 349 | 2,381 | Workflow reference docs |
| monday-prep.md | 340 | 1,570 | — |
| session-start.md | 339 | 3,905 | Auto-fires context-discovery (Step 2.4) |
| permission-sweep.md | 337 | 2,291 | Delegates to permission-sweep-auditor |
| friday-journal.md | 326 | 3,780 | AI-journal source |
| repo-dd.md | 318 | 2,714 | Delegates to repo-dd-auditor subagents |

**Assessment:**
1. **Context loading cost:** Commands read specific named files (protocol, reference docs, log tails) on invocation — appropriate on-demand loading, not bulk `cat`. The high-cost pattern remains per-project log reads in the Friday-cadence commands (`friday-act`, `friday-checkup`), which read multiple per-project files in the main session; most delegate scans to subagents (findings-extractor, fading-gate-scanner, friday-act-16a-summarizer) — a net improvement in delegation posture vs earlier audits. Same standing finding carried to Section 4/9.
2. **Redundant loading:** No command re-loads CLAUDE.md content (already in context). `prime`'s log-trio pre-fetch is a deliberate optimization, not redundancy — but telemetry shows the pre-fetched `session-notes.md` tail is re-read downstream at /session-start and /wrap-session guards (the R4 lever — see Section 5).
3. **Cascading loads:** The Friday cadence (`friday-checkup` → `friday-journal`/`friday-act`) chains multiple per-project scans. `friday-checkup` (452 lines) + `friday-act` (491 lines) load ~24,000+ tokens in command bodies alone across a full Friday session, plus per-project log reads. Largest cumulative chain — flagged in Section 9. Grew modestly (+40 lines combined) since prior audit but delegation offsets it.

**High-cost commands (>500 tokens external context on invocation):**

| Command | What it loads | Est. cost | Recommendation |
|---|---|---|---|
| prime | session-notes tail + log-trio (decisions, usage-log) | ~2–4k tokens; tail re-read 4–5×/session downstream | R4 lever — cache tail in-context (Section 5/9) |
| friday-checkup | improvement-log + friction-log + per-project coaching-data (up to 9 files) | pattern-match reads in main; most scans now delegated | Delegation posture improved; monitor |
| friday-act | per-project logs across active projects | 2,600–15,600 tokens; 16a summarizer delegates | Delegation offsets (carryover) |
| token-audit | token-audit-protocol.md (~640 lines, held once) | ~6,000 tokens, one-time | Acceptable — protocol held in context, not re-read |

**Delta from 2026-06-05:** Command count grew 72 → 84 (+12; incl. fix-symlinks, resolve-incident and others). No new high-cost bulk-`cat` patterns introduced; the Friday-cadence delegable-read finding persists but delegation to scanner subagents has increased. No regression.

---

## 5. Session Patterns & Configuration

**Session telemetry available:** Yes — `logs/usage-log.md` (~90 KB, 583 lines, active) plus deny-covered archives. ai-resources scope → run inline.

**Key patterns from recent telemetry (last ~5 substantive entries, through 2026-06-10):**
- **Recurring lever (R4): `session-notes.md` tail re-read 4–5× per multi-phase session** (across /prime header-detect, /session-start guard, /wrap-session guard, mandate lookup, append point). Now flagged in **8+ consecutive** usage-log entries without structural closure. ~1.5–3k tokens/session, ~6–15k/week. Structural (workflow-design), not config. The recommended fix (cache the /prime-fetched tail in-context; have downstream guards reuse it rather than re-tail) is the highest-frequency open lever in the log.
- **Positive: Decision-Point Posture + /risk-check skips** repeatedly saved ~20–30k tokens/session by avoiding deterministic ceremony (skipped /consult Step 4a, /decide QC-subagent, second /qc-pass where verdict was deterministic). Called out as a pattern to keep, not waste.
- **Positive: /risk-check stale-premise catch** (2026-06-01 S1) — a Wave 2 RECONSIDER on 3 stale settings.json edits saved ~10–20k tokens of NO-OP commit overhead; biggest single ROI event in the window.
- **Positive: context-discovery engine skipped** when a brief pre-enumerates sources (~2–3k/session saved).
- **Non-token structural signal: subagent shared-log write discipline.** The `session-feedback-collector` subagent failed its write step in two consecutive sessions (2026-06-10 S1 destructive overwrite recovered from HEAD; S3 no-write, returned signals inline). This is a data-integrity class, not token waste, but it recurs — noted for Section 9 safeguards / cross-referenced to improvement-log.

**Configuration audit:**

| Setting | Current value | Recommended | Impact |
|---|---|---|---|
| Default model | NOT SET (correct — operator selects via `/model`) | Must stay unset per workspace no-model rule | Correct posture; do not add |
| Subagent model | NOT SET (per-agent frontmatter only) | Per-agent frontmatter only | Correct (no settings default) |
| MAX_THINKING_TOKENS | **10000** (SET) | 10000 for routine | Optimal — matches recommendation |
| Autocompact threshold | **CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=80** (SET) | 80% | Implemented (prior R10 resolved; holds) |
| MCP servers active | Not observable from repo context | Disable unused | N/A this scope |

**Hooks:** 17 hook scripts present in `.claude/hooks/`; 10 wired in `.claude/settings.json` — PreToolUse (check-heavy-tool, friction-log-auto), PostToolUse (log-write-activity, auto-qc-nudge, friction-log-auto), Stop (check-stop-reminders, coach-reminder, improve-reminder, auto-resolve-nudge), SessionStart (friday-checkup-reminder). All are lightweight nudge/log hooks with small stdout. None truncate tool output (no output-cap hook — see Section 7). No token-cost concern from hooks themselves.

**Delta from 2026-06-05:** Config unchanged and still optimal — `MAX_THINKING_TOKENS=10000` and `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=80` both hold (no regression on the prior-resolved R10). Model correctly remains unset. The R4 session-notes re-read lever has now accumulated to 8+ consecutive flags — the standing structural lever the last several audits keep surfacing; still unshipped. New non-token signal this cycle: subagent shared-log write-discipline failures (feedback-collector, 2 consecutive sessions).

---

## 6. File Handling Patterns

*(Delegated to `token-audit-auditor-mechanical`, SECTION=6. Full notes: `audits/working/audit-working-notes-file-handling.md`. Main session read the summary only, then applied protocol-correct severity — see note below.)*

**Read(pattern) deny-rule status (from Step 0.3):** MEDIUM
Covered directories: `archive/`, `inbox/archive/`, `**/deprecated/`, `**/old/`, `logs/*archive*.md` (archive logs only).
Missing expected coverage: `audits/` (holds current + ~40 historical reports), `reports/` (historical), `output/` (**NEW — 114 files**), active `logs/`, active `inbox/`.

**Severity-reconciliation note:** The mechanical subagent flagged 5 findings as HIGH (`audits/working/` and `output/` uncovered). Per the protocol's Section 6 severity table, **HIGH fires only when NO `Read(...)` deny rules exist at all** — six deny rules DO exist here, so the protocol-correct severity for "large output files in an uncovered directory" is **MEDIUM per directory**. The main session re-classifies these to MEDIUM (consistent with the prior three audits, which called the same `audits/working/` finding MEDIUM). The over-classification is logged in Section 10.

**Large readable files / directories (uncovered by any Read() deny):**

| File / cluster | Size | Should Claude read this? | Parent covered by Read() deny? |
|---|---|---|---|
| `logs/session-notes-archive-*` + `decisions-archive-*` (largest files in repo, ~1.3M+ bytes) | very large | No (archives) | **Yes** (`logs/*archive*.md`) — correct, most impactful coverage |
| `logs/usage-log-archive-*` | ~140 KB | No | **Yes** — correct |
| `audits/working/*` (stale subagent scratch notes; largest surfaced: `log-sweep-*` 7,767 w, `toctou-phase-2-3-atomic-spec` 6,108 w) | large cluster | No (superseded scratch) | **No** |
| `output/context-packs/*` (18 pack dirs) + `output/deploy-test-scratch-2026-06-12/` (full scratch project) — 114 files, ~760 KB total | large cluster | No (generated scratch / test project) | **No — NEW this cycle** |
| `audits/repo-due-diligence-*.md`, `audits/token-audit-2*.md` (~40 historical reports) | several × 600–935 lines | No (prior reports) | **No** |
| `reports/repo-health-report-*.md` | several hundred each | No (prior reports) | **No** |
| Active `logs/*.md` (improvement-log 15,137 w, decisions 13,754 w, usage-log 12,869 w, friction-log 8,185 w, session-notes 6,780 w) | large | **Intentional yes** (active logs operator wants readable) | No (by design) |

**Assessment:**
1. **Archives are correctly protected** — the `logs/*archive*.md` denies cover the three largest files in the repo (session-notes and decisions archives). Right pattern, most impactful coverage.
2. **`audits/working/` and the NEW `output/` tree are the main remaining exposure.** Stale subagent scratch notes + 114 generated output/context-pack files are readable during Glob/Grep/Read exploration. Operator-intent caveat: `audits/` also holds the *current* audit and active registries, so a blanket `Read(audits/**)` deny would break legitimate reads — use granular patterns.
3. **`output/` is a fresh output class** (prior audit recorded output/ as "not present"). It holds only generated context-packs and a dated test-project scaffold — none of which an active command needs to read.
4. **Active logs uncovered by design** — operator wants active intake + logs readable; not a finding.

**Findings:**

| # | Finding | Severity | Recommendation |
|---|---|---|---|
| F6-1 | `audits/working/` (stale subagent scratch notes) is readable — no `Read()` deny covers it. | MEDIUM | Add `Read(audits/working/**)` — directory holds only superseded scratch by design; no active command reads from it (subagents WRITE there; writes aren't blocked by Read denies). Highest-value granular deny. |
| F6-2 | **NEW:** `output/` (114 files, ~760 KB — 18 context-pack dirs + `deploy-test-scratch-2026-06-12/` project) is readable; no deny covers it. | MEDIUM | Add `Read(output/**)` (or granular `Read(output/context-packs/**)` + `Read(output/deploy-test-scratch-*/**)`). Also consider deleting/archiving the dated deploy-test scratch project (hygiene). |
| F6-3 | ~40 historical dated reports in `audits/` + historical reports in `reports/` are readable. | MEDIUM | Add granular dated-report denies (`Read(audits/repo-due-diligence-*.md)`, `Read(audits/token-audit-2*.md)`, `Read(reports/repo-health-report-*.md)`) — NOT directory-wide — so current artifacts stay readable. Verify no active command greps historical reports before landing. |
| F6-4 | Active `logs/` and `inbox/` uncovered. | LOW | Intentional — operator wants active logs + intake readable. No action; documented exception. |

**Delta from 2026-06-05:** Same MEDIUM deny-rule verdict and same operator-intent caveat. **New exposure this cycle:** the `output/` tree (114 files) did not exist at the prior audit — it is the one genuinely new file-handling finding (F6-2). `audits/working/` remains the standing top granular-deny candidate. No regression; standing + one new deferred item.

---

## 7. Missing Safeguards

| Safeguard | Status | Severity if missing | Recommendation |
|---|---|---|---|
| `Read(pattern)` deny rules covering stale/large dirs | **Partial** | HIGH | Archives well-covered (largest files protected). Add `Read(audits/working/**)`, `Read(output/**)` (or granular subpaths), + granular dated-report denies (F6-class). |
| Custom compaction instructions in CLAUDE.md | **Present** | MEDIUM | Lines 70–77 (ai-resources) + workflow CLAUDE.md. No action. |
| Subagent output-to-disk pattern | **Present** | HIGH | Codified in CLAUDE.md Subagent Contracts (30/20-line caps); token-audit + repo-dd + friday-cadence scanner agents state it explicitly. No action. (Note: WRITE-mechanism discipline for shared-log-appending subagents is a separate open item — Section 5.) |
| Context-window monitoring guidance | **Present** | MEDIUM | Workspace CLAUDE.md "Context constraint deferral" + `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=80`. No action. |
| Session boundaries (`/clear` between tasks) | **Present** | MEDIUM | Workspace CLAUDE.md Session Boundaries → session-boundaries.md. No action. |
| Model selection guidance | **Present** | MEDIUM | Per-command/agent/skill frontmatter tiering (no settings default, by design). No action. |
| File-read scoping (read lines X–Y) | **Present** | LOW | Workflow commands use "read first N lines"/path-passing; /prime tail-reads. No action. |
| Output-length constraints | **Present** | LOW | Subagent summary caps (30/20 lines) enforced in agent bodies. No action. |
| Effort-level guidance | **Absent** | LOW | No `/effort` config or equivalent. Low impact at this scope; not recommended (would add CLAUDE.md weight for marginal gain). |
| Hook-based output truncation | **Absent** | LOW | 17 hook scripts present; none cap tool-output size. Low value — subagent disk-write pattern already prevents the main waste path. Not recommended. |
| Audit/output artifact isolation | **Partial** | MEDIUM | Outputs ARE in dedicated dirs (`audits/`, `audits/working/`, `reports/`, and NEW `output/`) but those dirs lack `Read()` denies. Granular denies close this. **Worsened this cycle:** the new `output/` tree (114 files) adds a fresh uncovered output class. |

---

## 8. Best Practices Comparison

| # | Practice | Status | Gap | Priority |
|---|---|---|---|---|
| 1 | CLAUDE.md under 200 lines | Implemented | 77 lines | — |
| 2 | Read(pattern) deny rules configured | Partial | Archives covered; `audits/working/`, `output/`, dated reports uncovered | MEDIUM |
| 3 | Skills use on-demand loading | Implemented | All skills carry frontmatter + trigger-rich descriptions (Section 2) | — |
| 4 | Subagents for heavy reads | Implemented | research-workflow + audit pipelines delegate; **this audit itself delegated Sections 2/4/6 to subagents** (the subagent tool IS available this cycle — an environment change vs the 2026-06-05 run which ran inline) | — |
| 5 | Strategic `/compact` at breakpoints | Implemented | Explicit `▸ /compact` markers in workflow commands | — |
| 6 | `/clear` between unrelated tasks | Implemented | Session Boundaries rule | — |
| 7 | Model selection per task type | Implemented | Frontmatter tiering (analytical=opus, dispatch/mechanical=sonnet/haiku) | — |
| 8 | Extended thinking budget controlled | Implemented | MAX_THINKING_TOKENS=10000 | — |
| 9 | Unused MCP servers disabled | Not observable | N/A from repo context | — |
| 10 | Output-to-disk for subagents | Implemented | Subagent Contracts + 30/20-line caps (write-mechanism discipline is a separate open item) | — |
| 11 | Precise prompts | Implemented | Commands give exact file paths + line ranges | — |
| 12 | Session-notes pattern | Implemented | /handoff + session-notes.md + /prime load | — |
| 13 | Similar-trigger skills disambiguated | Implemented | 76 of ~80 SKILL.md files carry "Do NOT trigger / use X for" discriminators | — |
| 14 | Agent/skill prompts use structured sections | Implemented | Spot-checked agents: 7–31 headings each | — |
| 15 | Few-shot examples where useful | Partial | 25 of 40 agent files contain explicit example blocks (up from ~4 noted in prior audit); most others rely on rubrics | LOW |

---

## 4. Workflow Token Efficiency

*(Delegated to `token-audit-auditor`, SECTION=4. The async dispatch was slow (~12 min) — it completed after the orchestrator step was capped, so this section was composed from the definitive fresh summary. Full notes: `audits/working/audit-working-notes-workflow-research-workflow.md`. No telemetry available → all run-volume / session-count / refinement-multiplier / return-size figures are structural inferences.)*

**Active workflows audited:** 1 — `research-workflow` (the single active workflow under `workflows/`; 31 commands, 4 agents, 16 reference files). **Findings: 11 — HIGH 4, MEDIUM 5, LOW 2.**

**HIGH findings (workflow relays large delegable content through the main session instead of disk-write-and-return-path):**

| # | Finding | Evidence | Recommendation |
|---|---|---|---|
| W4-H1 | `evidence-to-report-writer` returns the FULL chapter draft to main (>200L est.) | run-report St4.2a — while the sibling `run-synthesis` St2 writes the same artifact class to disk and returns only a path/summary | Bring St4.2a to the sibling's disk-write-and-return-path pattern |
| W4-H2 | `execution-agent` (wired via `/verify-chapter` St4) returns the full GPT-5/Perplexity response VERBATIM to main (>200L) AND writes it to disk — the return duplicates the disk write | run-execution / verify-chapter | Return a path + capped summary, not the verbatim response |
| W4-H3 | Large delegable OPERAND reads relayed through main | run-report St4.0 (six categories) + St4.1b re-read; run-analysis St1 (all memos); run-synthesis St1; run-execution St2.3 (all raw reports); produce-architecture Ph2+Ph3 (drafts double-read) | Path-pass the operands (the workflow's own carve-out already permits it in run-report/produce-*) |
| W4-H4 | Large reference docs (quality-standards 260L, source-class-hierarchy 106L, known-limits 105L) content-passed ×N | run-cluster St2.2 / run-execution St2.1+2.3 | Path-pass per the workflow's existing carve-out (run-report/produce-* already do) |

**Key MEDIUMs:** run-cluster (0 `/compact`) and run-sufficiency (0 `/compact` across 5 phases); refinement multiplier >3 + ~7–8 sessions/section (BY-DESIGN); skill-content-into-main pervasive; qc-gate Read-only forces all verdicts through main.
**PASS:** strong disk-write discipline overall; `produce-prose-draft` / `produce-formatting` are capped-summary exemplars.
**Severity note (→ Section 10):** W4-H3/H4 apply the protocol's literal "delegable→HIGH" rule; the isolation-rule rationale is the mechanism, not a severity reducer — so these stand as HIGH per protocol, but the operator may weigh them as design-intentional relays.

**Follow-up:** the 4 HIGH findings are workflow-design changes to `research-workflow` → route to a dedicated research-workflow optimization session (not a settings fix). Logged to the checkup Tactical follow-ups.

---

## 9. Optimization Plan

### 9.1 Executive Summary

ai-resources's **core infrastructure** is in strong token health — the CLAUDE.md core is lean (77 lines, 24% leaner than the prior audit), the 81-skill / 84-command library is 100% frontmatter-compliant with on-demand loading, and config (MAX_THINKING_TOKENS=10000, autocompact 80%, no model default) is optimal and unregressed. The **4 HIGH findings are all confined to one workflow** — `research-workflow` relays large delegable content (full chapter drafts, verbatim GPT-5/Perplexity responses, large operand/reference reads) through the main session instead of the disk-write-and-return-path pattern its siblings already use (Section 4, W4-H1…H4). Outside that workflow the actionable surface is a cluster of **MEDIUM** `Read()` deny-rule gaps (a genuinely new `output/` tree of 114 files, `audits/working/`, ~40 historical dated reports) and one **standing structural lever** (R4 session-notes tail re-read) that several consecutive audits have surfaced without a fix landing.

### 9.2 Prioritized Recommendations

**HIGH-1 — `research-workflow`: convert main-session content relays to disk-write-and-return-path (W4-H1…H4).**
- *Issue:* 4 HIGH relays — `evidence-to-report-writer` returns full chapter drafts (W4-H1); `execution-agent` returns verbatim GPT-5/Perplexity responses AND writes them to disk (W4-H2, duplicated); large operand reads relayed through main across run-report/analysis/synthesis/execution + produce-architecture (W4-H3); large reference docs content-passed ×N where the workflow's own carve-out already permits path-passing (W4-H4).
- *Evidence:* Section 4 (`audits/working/audit-working-notes-workflow-research-workflow.md`).
- *Waste mechanism:* main-session context bloat — the workflow's siblings (`run-synthesis`, `produce-prose-draft`, `produce-formatting`) already do the disk-write-and-return-path / capped-summary pattern, so these are inconsistencies within one workflow, not a missing capability.
- *Fix:* bring W4-H1/H2 to the sibling disk-write pattern; path-pass the W4-H3/H4 operands + reference docs per the existing carve-out.
- *Risk:* Medium — workflow-design change to a live research pipeline; regression-test one chapter end-to-end before rollout. **Route to a dedicated research-workflow optimization session, not a settings fix.**
- *Est. savings:* per-run main-context reduction on the heaviest research artifacts (>200L relays × multiple stages × 7–8 sessions/section by design) — the largest single-workflow lever in this scope.
- *Caveat (Section 10):* W4-H3/H4 apply the protocol's literal "delegable→HIGH" rule; some relays may be design-intentional — operator weighs at the optimization session.

**MEDIUM-1 — Add granular `Read()` deny rules (F6-1/2/3).**
- *Issue:* `audits/working/` (stale scratch), the NEW `output/` tree (114 files, ~760 KB — 18 context-pack dirs + a dated deploy-test scratch project), and ~40 historical dated reports are readable during Glob/Grep/Read exploration.
- *Evidence:* Sections 0.3, 6 (F6-1/2/3), 7.
- *Waste mechanism:* incidental reads of superseded scratch/generated files during exploration.
- *Fix:* add `Read(audits/working/**)`, `Read(output/**)` (or granular `Read(output/context-packs/**)` + `Read(output/deploy-test-scratch-*/**)`), and granular dated-report denies (`Read(audits/repo-due-diligence-*.md)`, `Read(audits/token-audit-2*.md)`, `Read(reports/repo-health-report-*.md)`). NOT directory-wide on `audits/` — the current audit + active registries must stay readable.
- *Risk:* Low-Medium — a too-broad deny could block a legitimate active-artifact read; the granular patterns avoid this. **Verify no active command greps historical reports before landing.** This is a settings/permissions change → route via `/permission-sweep` or an operator-directed settings edit (a `/risk-check` change class).
- *Est. savings:* modest per-turn (exploration hygiene); primary value is exposure reduction, not raw tokens.

**MEDIUM-2 — Delete/archive the `output/deploy-test-scratch-2026-06-12/` scratch project (hygiene).**
- *Issue:* a full dated test-project scaffold sits under `output/`; also flagged by Check A (repo-health) as the single highest-value cleanup (clears 4 recurring Minor findings).
- *Fix:* delete or archive it. Pairs with MEDIUM-1's `output/` deny.
- *Risk:* Low (gitignored scratch). Confirm it is not an input to any live test before deleting.

**STRUCTURAL-1 (standing) — R4: cache the /prime-fetched session-notes tail in-context.**
- *Issue:* `session-notes.md` tail is re-read 4–5× per multi-phase session (/prime header-detect, /session-start guard, /wrap-session guard, mandate lookup). Flagged in **8+ consecutive** usage-log entries without closure.
- *Evidence:* Section 5; usage-log through 2026-06-10.
- *Est. savings:* ~1.5–3k tokens/session, ~6–15k/week.
- *Fix:* have downstream guards reuse the /prime-fetched tail rather than re-tailing. Workflow-design change (not config) → dedicated session.
- *Note:* highest-frequency open lever in the telemetry; recommend it be the next efficiency fix scheduled.

**LOW — monitor items (no action):** 9 skills >300 lines (justified multi-pass methodologies); few-shot example coverage 25/40 agents (up from ~4); Friday-cadence command-body size (delegation offsets growth).

### Positives to keep (not waste)
- **Decision-Point Posture + /risk-check skips** save ~20–30k tokens/session by avoiding deterministic ceremony.
- **/risk-check stale-premise catches** (e.g. 2026-06-01 RECONSIDER on 3 stale settings edits) — biggest single-event ROI in the window.
- **Subagent delegation** is now the audit's own default (this run delegated Sections 2/6 to subagents).

---

## 10. Self-Assessment

- **Audit token cost:** not self-measured (`/cost`/`/context` unavailable in the automated cadence environment — Section 0.1).
- **Protocol gaps / deviations this run:**
  1. **Section 4 completed late (async lag, not a stall).** The per-workflow `token-audit-auditor` dispatch ran ~12 min and returned AFTER the orchestrator step was capped; an interim conclusion that it had "stalled without writing" (based on a mid-run file-check that saw only stale 2026-05-18 copies) was **premature** — the subagent then completed and overwrote the stale copies with fresh, definitive measurements, which this section now uses. No fabrication occurred at any point (stale data was never composed in). Lesson (→ friction): don't declare an async subagent stalled from a single mid-run file-check; verify against its completion signal.
  2. **Section 6 mechanical over-classification reconciled** — the mechanical subagent flagged 5 findings as HIGH; per the protocol's Section 6 severity table HIGH fires only when NO `Read()` deny rules exist at all (six exist here), so the main session re-classified to MEDIUM per directory (consistent with the prior three audits).
  3. **Not committed** — per the Friday-checkup orchestrator's no-commit rule (the standalone /token-audit Step 17 commit was deliberately skipped).
- **Per-section confidence:** Sections 0,1,2,3,5,6,7,8 — HIGH (measured + reconciled against the 2026-06-05 delta). Section 4 — HIGH on the single active workflow, but all run-volume/session-count figures are structural inferences (no telemetry). Section 9 — HIGH (synthesizes completed sections). 
- **Threshold-boundary flags:** token counts are word×1.3 (±30%); no finding sits within ±15% of a severity threshold in a way that would flip its class. The over-300-line skill count (9) is a mechanical size classification, not an actionable HIGH.
- **Context note:** this quarterly run absorbed a concurrent-session collision recovery mid-cadence (a second /friday-checkup was live in the same checkout and was stopped by the operator); the token-audit ran as sole owner afterward.
