# Token Audit — 2026-05-18
Scope: current working directory
AUDIT_ROOT: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources
Previous audit: None matching empty-scope pattern; most recent comparable: `token-audit-2026-05-02-ai-resources.md`

---

## 0. Pre-Flight Summary

**Session metrics:** `/cost` and `/context` not available in this execution environment.

**Session telemetry:** `session-usage-analyzer` skill located; historical data found at `logs/usage-log.md` (422 lines, entries through 2026-05-16). Used in Section 5.

**Read(pattern) deny-rule verdict: MEDIUM**

Covered directories: `archive/**`, `logs/*-archive-*.md`, `inbox/archive/**`, `**/deprecated/**`, `**/old/**`

Missing expected coverage (actionable gap): `audits/working/**` — recommended since 2026-05-01 decisions log ("right fix is `Read(audits/working/**)` only"), not yet implemented. The `audits/working/` directory now contains 90+ files from prior audit runs (per-workflow working notes, session coaching reports, diff files, permission-sweep summaries). These load as stale context when Claude Code explores the `audits/` directory during active sessions.

`reports/**` coverage also absent. Full `audits/**` or `reports/**` deny would break active workflows; targeted `Read(audits/working/**)` is the correct fix.

Full notes: `audits/working/audit-working-notes-preflight.md`

---

## 1. CLAUDE.md Audit

**File:** CLAUDE.md (ai-resources root)
**Line count:** 90
**Estimated tokens:** 967 words × 1.3 ≈ 1,257 tokens
**Sections/headings:** 14
**Subdirectory CLAUDE.md files found:** `workflows/research-workflow/CLAUDE.md`

**Per-session cost:** ~1,257 tokens loaded every turn of every session. Over a 2–3 hour session with 30–50 turns: ~37,710–62,850 tokens spent on CLAUDE.md loading alone.

**Findings:**

| # | Finding | Severity | Lines affected | Recommendation |
|---|---------|----------|---------------|----------------|
| 1 | "What This Repo Contains" section is descriptive/informational — lists directory names and purposes. Not behavioral; doesn't change Claude's actions. | LOW | 1–18 | Convert to a pointer: "Directory layout: see `docs/repo-layout.md`" (3 lines vs 18). Saves ~200 tokens per session. |
| 2 | Commit Rules section (lines 71–77) explicitly acknowledges it duplicates workspace CLAUDE.md. The duplication is justified (ai-resources opened without parent workspace context), but still loads every session even when workspace CLAUDE.md is present. | LOW | 71–77 | Acceptable tradeoff; no change required unless workspace-open detection becomes feasible. |
| 3 | No aspirational filler detected. All behavioral sections are imperative. | — | — | PASS |
| 4 | Compaction instructions present (lines 79–86). | — | — | PASS |
| 5 | No clearly skill-eligible content blocks — sections are pointer-style (3–5 lines each), not inline methodology. | — | — | PASS |
| 6 | `workflows/research-workflow/CLAUDE.md` exists as subdirectory CLAUDE.md. This file loads when working in the research-workflow directory — not a main-session concern but worth measuring separately if that workflow is audited. | LOW | n/a | No action for ai-resources root audit. Flag for research-workflow audit (Section 4). |

**Overall assessment:** CLAUDE.md is well-managed at 90 lines. The only material savings opportunity is the 18-line descriptive header (Finding 1, ~200 tokens/session). No HIGH or MEDIUM findings.

---

## 2. Skill Census

**Total skills found:** 70 (68 main library in `skills/` + 2 reference copies in `workflows/research-workflow/reference/skills/`)
**Total lines:** 13,509 | **Total words:** 105,577 | **Estimated tokens across all skills:** ~137,250

**Size distribution:**
- Under 50 lines: 1 skill
- 50–150 lines: 47 skills (focused, efficient)
- 150–300 lines: 19 skills (medium, compression candidates)
- Over 300 lines: 7 skills (HIGH — large token cost when loaded)

**Top 10 largest skills:**

| Rank | Skill | Lines | Words | Finding |
|------|-------|-------|-------|---------|
| 1 | answer-spec-generator | 487 | 3,691 | HIGH — ~4,798 tokens; content-dense |
| 2 | research-plan-creator | 466 | 3,508 | HIGH — ~4,560 tokens; content-dense |
| 3 | ai-resource-builder | 415 | 3,101 | HIGH — ~4,031 tokens; 3 modes in one skill (create/improve/QC); medium split candidate |
| 4 | evidence-to-report-writer | 334 | 3,428 | HIGH — ~4,456 tokens; multi-step writer |
| 5 | workflow-evaluator | 318 | 2,513 | HIGH — ~3,267 tokens |
| 6 | ai-prose-decontamination | 316 | 4,352 | HIGH — ~5,658 tokens; highest token density in library |
| 7 | workflow-system-critic | 302 | 2,361 | HIGH — ~3,069 tokens; borderline threshold |
| 8 | summary | 299 | 2,954 | MEDIUM — ~3,840 tokens; near-HIGH boundary |
| 9 | prose-formatter | 289 | 3,198 | MEDIUM — ~4,157 tokens; near-HIGH |
| 10 | prose-refinement-writer | 269 | 3,325 | MEDIUM — ~4,323 tokens; dense |

**Description quality issues:**

| Skill | Issue | Severity |
|-------|-------|----------|
| workflow-consultant | Description lacks explicit trigger conditions | MEDIUM |
| prompt-creator | Description functional but vague on activation scope | MEDIUM |
| session-guide-generator | Trigger conditions not stated in description | MEDIUM |

**Redundancy flags:** None detected — all 68 main library skills have distinct purposes.

**Dead skills:** None detected.

**Workflow reference copies:** `workflows/research-workflow/reference/skills/` holds copies of `knowledge-file-producer` and `report-compliance-qc` with no frontmatter (0% frontmatter). These are intentional reference copies for the deployed workflow, but missing `model:` and `effort:` fields. Document as reference-only or restore frontmatter.

**Findings summary:** 13 total (7 HIGH, 4 MEDIUM, 2 LOW). All HIGH findings are oversized skills; their size is justified by content complexity. `ai-resource-builder` (3 modes combined) is the only medium-priority split candidate.

Full notes: `audits/working/audit-working-notes-skills.md`

---

## 3. Command File Census

**Total main commands (.claude/commands/):** 57
**Total workflow commands (research-workflow/.claude/commands/):** 24
**Total across repo:** 81

Command files are not loaded every session — they load only when their slash command is invoked. Per-invocation cost is the relevant metric. HIGH finding threshold: >500 tokens of loaded external context beyond the command file itself.

**Top 15 commands by size (.claude/commands/ only):**

| Command | Lines | Words | Est. tokens | External file loads | Cascading? |
|---------|-------|-------|-------------|---------------------|------------|
| new-project.md | 608 | 6,083 | ~7,908 | Agent files (6), buy-side CLAUDE.md precedent | HIGH — triggers 6 pipeline-stage subagents |
| friday-act.md | 425 | 4,193 | ~5,451 | audit-discipline.md, friday-checkup report, friday-journal report | HIGH — reads 3+ external docs per run |
| friday-checkup.md | 410 | 3,543 | ~4,606 | Multiple agent existence checks, project CLAUDE.md files | HIGH — triggers 8+ subagents |
| friday-journal.md | 326 | 3,780 | ~4,914 | workspace CLAUDE.md, ai-resources CLAUDE.md, project CLAUDE.md files | HIGH — reads 3–5 CLAUDE.md files inline |
| deploy-workflow.md | 353 | 2,088 | ~2,714 | Workflow template files | MEDIUM |
| repo-dd.md | 318 | 2,714 | ~3,528 | repo-dd-auditor, dd-extract-agent, dd-log-sweep-agent | HIGH — 3 subagent chain |
| permission-sweep.md | 324 | 2,042 | ~2,655 | settings.json files across projects | MEDIUM |
| log-sweep.md | 303 | 1,756 | ~2,283 | log-sweep-auditor per project | HIGH — N subagents (one per project) |
| monday-prep.md | 314 | 1,314 | ~1,708 | Project CLAUDE.md files, symlink checks | MEDIUM |
| innovation-sweep.md | 272 | 1,871 | ~2,432 | innovation-triage-auditor | MEDIUM |
| fix-symlinks.md | 249 | 964 | ~1,253 | Project directories | MEDIUM |
| audit-critical-resources.md | 245 | 1,708 | ~2,220 | critical-resource-auditor | MEDIUM |
| cleanup-worktree.md | 165 | 2,814 | ~3,658 | worktree-cleanup-investigator/SKILL.md (~4,703 tokens) | HIGH — skill load + QC/triage subagents |
| session-plan.md | 197 | 1,321 | ~1,717 | harness-rules.md reference | LOW |
| token-audit.md | 197 | 1,437 | ~1,868 | token-audit-protocol.md (~4,000 tokens) | HIGH — loads full protocol |

**High-cost commands (loading >500 tokens of external context beyond command file):**

| Command | What it loads externally | Estimated total context cost | Recommendation |
|---------|--------------------------|------------------------------|----------------|
| token-audit.md | token-audit-protocol.md (~4,000 tokens) | ~5,868 tokens | Protocol load is necessary; consider whether the protocol can be trimmed. |
| cleanup-worktree.md | worktree-cleanup-investigator/SKILL.md (~4,703 tokens) | ~8,361 tokens combined | Combined ~8,361 tokens is the largest per-invocation load for a utility workflow. |
| friday-journal.md | workspace CLAUDE.md + ai-resources CLAUDE.md + 1–3 project CLAUDE.md files (~1,500–4,000 tokens) | ~6,414–8,914 tokens | Multiple CLAUDE.md reads are necessary for currency-drift check; but project CLAUDE.md reads are conditional (only named projects) — already optimized. |
| new-project.md | Agent files + buy-side precedent CLAUDE.md | Command alone is ~7,908 tokens | At 608 lines, the command itself is the cost. Splitting into a brief dispatcher + referenced sub-spec would reduce per-invocation loading. |

**Top 5 cascading load chains:**

1. **friday-checkup → 8+ subagents:** permission-sweep-auditor, log-sweep-auditor, improvement-analyst, repo-dd-auditor, doc-scanner-agent, principles-checker-agent, collaboration-coach. Each subagent has its own context window; main session receives summaries.
2. **new-project → 6 pipeline-stage agents:** pipeline-stage-3a through pipeline-stage-5 + session-guide-generator. Sequential chain where each stage's output feeds the next.
3. **log-sweep → N×log-sweep-auditor:** One subagent per project in scope. For 10 projects, 10 subagent invocations.
4. **repo-dd → repo-dd-auditor → dd-extract-agent → dd-log-sweep-agent:** 3-level chain in deep/full tier.
5. **cleanup-worktree → worktree-cleanup-investigator → qc-reviewer → triage-reviewer:** 3 sequential subagents, plus possible 2nd QC pass.

**Key finding:** The command library is well-structured for delegation — most large commands are orchestrators that push work into subagents. The primary concern is the 5 commands over 300 lines (new-project, friday-act, friday-checkup, friday-journal, deploy-workflow) whose per-invocation command-file cost exceeds 2,500 tokens before any external loads.

---

## 5. Session Patterns & Configuration

**Session telemetry available:** Yes — `logs/usage-log.md` (422 lines, 2 substantive entries reviewed: 2026-05-16 Wasteful + 2026-05-16 Acceptable)

**Key patterns from telemetry:**

1. **Read-before-Write failure (recurring structural pattern):** `session-plan.md` Write-before-Read failure logged in 4 consecutive Friday-cluster sessions. Each failure generates ~1 failed Write + 1 corrective Read + 1 retry Write = ~3 unnecessary tool calls per occurrence. Estimated 2–3k tokens/session overhead. Usage log recommends wiring a mechanical Read preamble into `/session-plan` skill body — model-side discipline has not resolved this in 4+ sessions.

2. **Log-trio re-read pattern (every Friday session):** `session-notes.md`, `decisions.md`, and `usage-log.md` re-read 2× per session (at prime and at wrap). Combined re-read cost estimated at ~3–4k tokens/session. Usage log recommends caching at `/prime` to avoid repeat reads.

3. **Subagent context bleed (2026-05-16 Wasteful):** 3 subagents independently re-read all 7 dirty files ≈ ~2,400 duplicate lines. Root cause: subagent prompts did not include pre-computed file contents. Compounding from operator-inserted second QC pass that duplicated in-plan-mode QC nearly verbatim (~additional ~1,000–2,000 tokens).

4. **TodoWrite overhead:** ~6 status-tick calls per complex session when 3 checkpoints (open/mid/wrap) would suffice. Minor per-session cost (~400–600 tokens).

**Configuration audit:**

| Setting | Current value | Recommended | Impact |
|---------|--------------|-------------|--------|
| Default model | Not set (operator-selects via `/model`) | Correct per workspace rules | n/a — rule is followed |
| Subagent model | Not set globally; per-command/agent frontmatter used | Correct per workspace rules | n/a |
| MAX_THINKING_TOKENS | **10,000** (set in settings.json `env` block) | 10,000 for routine tasks | **Resolved** — prior audit M1 fixed |
| Autocompact threshold | Not set | 80% | LOW — default may suffice; no failure observed |
| MCP servers active | Google Drive (user-level config, not repo-controlled) | Disable unused servers | LOW — Google Drive appears in deferred tools; if not used in ai-resources sessions, session model loads its tool definitions unnecessarily |

**Hooks (token impact assessment):**

| Hook | Event trigger | Fires per session | Token impact |
|------|--------------|-------------------|--------------|
| check-heavy-tool.sh | PreToolUse Read\|Grep\|Bash | ~35–50× (every Bash/Read call) | Minimal — returns empty unless threshold met; shell overhead per call |
| friction-log-auto.sh | PreToolUse Skill | ~1–6× per session | Minimal — short output |
| log-write-activity.sh | PostToolUse Write\|Edit | ~10–25× per session | Minimal — appends to log file, no context output |
| auto-qc-nudge.sh | PostToolUse Write\|Edit | ~10–25× per session | LOW — may emit systemMessage on significant artifacts |
| check-stop-reminders.sh | Stop | 1× per session | LOW — emits reminder if conditions met |
| coach-reminder.sh | Stop | 1× per session | LOW — may emit systemMessage |
| improve-reminder.sh | Stop | 1× per session | LOW — may emit systemMessage |
| auto-resolve-nudge.sh | Stop | 1× per session | LOW — emits nudge if QC findings pending |
| friday-checkup-reminder.sh | SessionStart | 1× per session | LOW — fires on Fridays/Mondays only |

**Assessment:** `check-heavy-tool.sh` firing on every `Read|Grep|Bash` call is the highest-frequency hook — at 35–50 invocations per complex session. If each returns a non-empty systemMessage even 10% of the time, that's 3–5 systemMessages per session. Hook chain itself runs in ~5ms (timeout configured) with no direct token output unless threshold met. Net impact: LOW, but worth monitoring if tool-call overhead becomes measurable.

---

## 6. File Handling Patterns

**Read(pattern) deny-rule status (from Step 0.3):** MEDIUM
Covered directories: `archive/**`, `logs/*-archive-*.md`, `inbox/archive/**`, `**/deprecated/**`, `**/old/**`
Missing expected coverage: `audits/` (actionable gap: target `audits/working/**` only), `reports/**`

**Findings (5 total — 0 HIGH, 3 MEDIUM, 2 LOW):**

| # | Finding | Severity | Recommendation |
|---|---------|----------|----------------|
| 1 | `audits/` directory not covered — 14 unprotected report files (~106k words, ~138k estimated tokens) may load during exploration | MEDIUM | Add `Read(audits/working/**)` to settings.json deny rules. The 14 top-level report files (token-audit, friday-checkup, permission-sweep, etc.) are intentionally readable for active workflows; only `working/` subdir needs protection. |
| 2 | `audits/working/` not covered — 89 intermediate working-note files (~11k lines) accumulate unprotected; known gap since 2026-05-01 | MEDIUM | **Implement the 2026-05-01 recommended fix:** add `"Read(audits/working/**)"` to settings.json deny rules. Quick win — was explicitly deferred and now overdue. |
| 3 | `reports/` directory not covered — 7 unprotected report files (~13k words) | MEDIUM | Add `Read(reports/**)` to deny rules if reports are archived outputs not needed for active sessions. |
| 4 | Prior audit working-notes files accumulate in `audits/working/` with no archival mechanism | LOW | Implement a periodic purge or move older working-notes to a dated archive subdirectory covered by the archive deny rule. |
| 5 | `logs/usage-log.md` (422 lines) and `logs/session-notes.md` are intentionally readable but are the largest live log files — candidates for archival when they exceed entry-count threshold | LOW | Covered by existing log management (`split-log.sh`). No new action needed. |

Full notes: `audits/working/audit-working-notes-file-handling.md`
*(Note: subagent wrote to `audit-working-notes-file-handling-section6.md` — full path confirmed in summary)*

---

## 7. Missing Safeguards

| Safeguard | Status | Severity if absent | Recommendation |
|-----------|--------|-------------------|----------------|
| `Read(pattern)` deny rules covering stale/large directories | **Partial** — rules exist but `audits/working/**` and `reports/**` uncovered | MEDIUM | Add `"Read(audits/working/**)"` and `"Read(reports/**)"` to settings.json deny rules |
| Custom compaction instructions in CLAUDE.md | **Present** — lines 79–86 of CLAUDE.md specify what to preserve during `/compact` | — | PASS |
| Subagent output-to-disk pattern | **Present** — Subagent Contracts section in CLAUDE.md; implemented in token-audit-auditor, repo-dd-auditor, log-sweep-auditor; 30-line summary cap enforced | — | PASS |
| Context window monitoring instructions | **Absent** — no `/context` or `/cost` guidance in CLAUDE.md or skills; no instruction to monitor context usage mid-session | MEDIUM | Add brief guidance to CLAUDE.md or session-plan skill: "Run `/context` at workflow midpoints if session is heavy." Low token cost to add; prevents blind context exhaustion. |
| Session boundaries defined for workflows | **Present** — CLAUDE.md Session Boundaries section instructs `/clear` between unrelated tasks; individual workflows have wrap steps | — | PASS |
| Model selection guidance | **Present** — extensive coverage in workspace CLAUDE.md (Model Tier + Model Escalation sections); per-skill `model:` frontmatter used | — | PASS |
| File read scoping (read lines X–Y vs. entire file) | **Partial** — some skills specify targeted reads (e.g., "read first 20 lines" in Section 2 protocol); not universal across all command files | LOW | Add a read-scoping note to command files that read large reference files (e.g., friday-act reads audit-discipline.md — read lines rather than full file). |
| Output length constraints | **Partial** — subagent contracts have 30-line summary caps; skills don't universally constrain response length | LOW | Add output-length instructions to the 3 skills with vague descriptions flagged in Section 2 (workflow-consultant, prompt-creator, session-guide-generator). |
| Effort level guidance | **Absent** — no `/effort` configuration or equivalent effort-scaling instructions | LOW | Low-priority: workspace operates at consistent complexity; effort flags rarely needed. Note for future consideration. |
| Hook-based output truncation | **Absent** — no hooks that cap tool output size | LOW | LOW priority: current hook suite is already comprehensive; adding truncation hooks adds complexity risk. |
| Audit/output artifact isolation | **Partial** — `audits/` and `reports/` directories exist as dedicated folders but `audits/working/**` not covered by deny rule | MEDIUM | See Finding #2 in Section 6 — `Read(audits/working/**)` is the specific fix. |

---

## 8. Best Practices Comparison

| # | Practice | Status | Gap description | Priority |
|---|----------|--------|-----------------|----------|
| 1 | CLAUDE.md under 200 lines | **Implemented** — 90 lines | None | — |
| 2 | `Read(pattern)` deny rules configured | **Partial** — rules exist; `audits/working/**` and `reports/**` missing | Key gap: 89 working-notes files in audits/working/ accessible | HIGH |
| 3 | Skills use on-demand loading | **Implemented** — skill descriptions loaded as index; full content only on trigger | Trigger-quality: 95.6% trigger-rich, 3 marginal | MEDIUM (fix descriptions) |
| 4 | Subagents for heavy reads | **Implemented** — Subagent Contracts in CLAUDE.md; token-audit, repo-dd, log-sweep use it | Cleanup-worktree subagents redundantly re-read dirty files (observed in usage log) | MEDIUM |
| 5 | Strategic `/compact` at breakpoints | **Partial** — compaction instructions in CLAUDE.md; no explicit breakpoints in most command files | Large workflows (new-project, friday-checkup) have no mid-workflow /compact trigger | MEDIUM |
| 6 | `/clear` between unrelated tasks | **Implemented** — Session Boundaries in CLAUDE.md | — | — |
| 7 | Model selection per task type | **Implemented** — workspace CLAUDE.md Model Tier + per-skill `model:` frontmatter | Operator-selected at session start per design | — |
| 8 | Extended thinking budget controlled | **Implemented** — `MAX_THINKING_TOKENS=10000` set in settings.json | Resolved from prior audit (M1) | — |
| 9 | Unused MCP servers disabled | **Partial** — user-level Google Drive MCP active; not repo-controlled | If Google Drive not used in ai-resources sessions, tool definitions add per-request overhead | LOW |
| 10 | Output-to-disk pattern for subagents | **Implemented** — Subagent Contracts enforced; 30-line summary cap | Observed violation in 2026-05-16 cleanup-worktree (subagents re-read files independently) | MEDIUM |
| 11 | Precise prompts over vague ones | **Implemented** — workflow command files have specific, action-oriented instructions | — | — |
| 12 | Session notes pattern | **Implemented** — `/wrap-session`, `session-notes.md`, `/prime` with cross-check | Log-trio re-read pattern (prime + wrap) is a known inefficiency | MEDIUM |
| 13 | Skills with similar triggers disambiguated | **Partial** — 3 skills have marginal descriptions lacking explicit trigger conditions (workflow-consultant, prompt-creator, session-guide-generator) | Missing "TRIGGER when: X / SKIP: Y" language | LOW |
| 14 | Agent/skill prompts use structured sections | **Partial** — spot-check of 4 agent files shows structured sections (headers, numbered steps, schema tables) in most; some older skills use flat prose | Evidence: token-audit-auditor uses clear section headers; ai-resource-builder uses numbered sequences. A few small utility skills lack structure. | LOW |
| 15 | Few-shot examples present where useful | **Partial** — larger skills (ai-resource-builder, answer-spec-generator) include examples; smaller utility skills generally don't | Not a systematic gap — most utility skills don't need examples | LOW |

---

## 4. Workflow Token Efficiency

**Workflows identified:** Friday Cadence, /new-project, /repo-dd, research-workflow, /cleanup-worktree

---

#### Workflow: /new-project Pipeline

**Context loading chain:**
1. CLAUDE.md loads (~1,257 tokens)
2. new-project.md invoked → ~7,908 tokens (command alone — largest single command)
3. 6 pipeline-stage agents instantiated sequentially → ~3,078 tokens additional context per stage

**Total estimated start-of-workflow context:** ~12,243 tokens (before any file reads)

**File reads during execution:**

| File | Size | Read in main/subagent | Necessary / Delegable? |
|------|------|-----------------------|------------------------|
| `projects/buy-side-service-plan/CLAUDE.md` | ~80 lines | **Main session** (Step 11a — model-ID precedent lookup) | Delegable — could be a grep for the model string or inlined as a constant |
| Various project CLAUDE.md files | Variable | Main session (new project scaffold) | Necessary |
| Agent definition files (6) | ~70 lines avg | Pre-flight check only | Necessary (existence check, not full read) |

**Subagent pattern:**

| Subagent | Returns to main? | Return size |
|----------|-----------------|-------------|
| pipeline-stage-3a through 3c | Via task files | ≤30-line summary each |
| pipeline-stage-4, 5 | Via task files | ≤30-line summary each |
| session-guide-generator (optional) | Via task files | ≤30-line summary |

**Findings (7 total — 1 HIGH, 3 MEDIUM, 1 LOW):**

| # | Finding | Severity | Waste mechanism | Recommendation |
|---|---------|----------|----------------|----------------|
| 1 | Command file 608 lines (~7,908 tokens); ~65% (~392 lines) is Post-Pipeline Enrichment content | HIGH | Entire command body loads every invocation; 392 lines of enrichment content not needed until post-pipeline | Extract Post-Pipeline Enrichment into a separate reference doc or dedicated `/post-project-enrich` command loaded only when enrichment is needed |
| 2 | 4 canonical CLAUDE.md sections duplicated inline in command body (Input File Handling, Commit Rules, Compaction, Session Boundaries — ~140–150 lines) | MEDIUM | ~30% of file is verbatim content already present in CLAUDE.md; double-loads on every invocation | Replace with pointers to CLAUDE.md sections |
| 3 | Step 11a reads `projects/buy-side-service-plan/CLAUDE.md` in main session for model-ID precedent | MEDIUM | Unnecessary full-file read for a single string value | Replace with inline constant or `grep` for model string |
| 4 | No enforced `/compact` breakpoints between 6 pipeline stages | MEDIUM | Each stage adds context; by Stage 5, accumulated context is substantial | Add mandatory `/compact` after Stage 3 (heaviest read stage) |
| 5 | ~50 lines of verbatim jq glue embedded inline in command body | LOW (boundary) | Adds token cost; could be a reusable script | Move to `scripts/` and reference by path |

Full notes: `audits/working/audit-working-notes-workflow-new-project.md`

---

#### Workflow: /repo-dd

**Context loading chain:**
1. CLAUDE.md (~1,257 tokens)
2. repo-dd.md → ~3,528 tokens (command, boundary vs HIGH threshold)
3. repo-dd-auditor agent invoked (fresh context — no main-session carryover)

**Total estimated start context:** ~4,785 tokens

**Subagent pattern:**

| Subagent | Returns to main? | Return size |
|----------|-----------------|-------------|
| repo-dd-auditor | Writes DD_REPORT to disk; returns path + bounded summary | ≤30 lines |
| dd-extract-agent | Writes EXTRACT_PATH to disk | ≤30 lines |
| dd-log-sweep-agent (deep+full only) | Writes to disk | ≤30 lines |

**Findings (6 total — 1 HIGH, 1 MEDIUM, 4 LOW):**

| # | Finding | Severity | Waste mechanism | Recommendation |
|---|---------|----------|----------------|----------------|
| 1 | `audits/` directory lacks Read() deny rule — 30+ historical /repo-dd reports globbable from main session | HIGH | Prior reports (up to 935 lines / 23 KB) may be read by Glob/Grep during exploration, loading stale context | Add `Read(audits/working/**)` to deny rules (same fix as Section 6 Finding 2) |
| 2 | Full-tier template-sync test (Step 63) reads canonical/deployed file pairs in main session | MEDIUM | Aggregate cost scales with deployment surface | Delegate pair-reads to a subagent or batch via grep rather than full reads |
| 3 | EXTRACT_PATH read 3× in deep+full tier (Steps 14/33/62) | LOW (boundary) | Triple read of same file; justified by intervening /compact checkpoints but boundary-dependent | If /compact checkpoints are ever dropped, consolidate reads |

PASS: Subagent return contracts — all three agents write to disk and return bounded summaries. EXTRACT_PATH pattern saves ~7,000+ tokens per deep run vs reading full DD_REPORT. /compact checkpoints defined at Steps 30 and 60.

Full notes: `audits/working/audit-working-notes-workflow-repo-dd.md`

---

#### Workflow: /cleanup-worktree

**Context loading chain:**
1. CLAUDE.md (~1,257 tokens)
2. cleanup-worktree.md → ~3,658 tokens
3. worktree-cleanup-investigator/SKILL.md → ~4,703 tokens (auto-loaded by skill trigger)
4. execution-protocol.md reference → ~5,912 tokens (337 lines, loaded across Steps 5/6/7/9/11)

**Estimated floor per invocation:** ~8,361 tokens (command + skill, before references)
**Realistic ceiling with references:** ~16,908 tokens main-session before per-path reads

**Subagent pattern:**

| Subagent | Returns to main? | Return size |
|----------|-----------------|-------------|
| qc-reviewer (1st QC, always) | ≤20 lines | Correct |
| triage-reviewer (always) | ≤20 lines | Correct |
| qc-reviewer (2nd QC, skippable) | ≤20 lines | Correct |

**Findings (5 total — 1 HIGH boundary, 2 MEDIUM, 2 LOW):**

| # | Finding | Severity | Waste mechanism | Recommendation |
|---|---------|----------|----------------|----------------|
| 1 | `execution-protocol.md` reference file 337 lines / ~5,912 tokens — 12.3% above 300-line HIGH threshold | HIGH (boundary) | Loaded cumulatively across 5 trigger points per typical run | Consider splitting the reference into an execution section (needed per-run) and a design-rationale section (rarely needed) |
| 2 | Mandatory command + skill = ~8,361 tokens per invocation | MEDIUM | SKILL.md at 247 lines includes skill-discovery and post-execution content not needed per-turn | Audit SKILL.md for sections that could be moved to a reference doc |
| 3 | Plan-mode content (8-section schema, 10–14 paths = ~1,000–2,500 tokens) lives in main-session context | MEDIUM | Non-delegable by design — agent IS plan author; inherent to plan-mode architecture | Accept as structural; no fix recommended |
| 4 | QC auto-loop fires every run (2–3 subagents minimum, up to 5 worst case) | LOW | Cumulative subagent overhead per cleanup run | Quick-tier skip rule (already implemented) mitigates this significantly |
| 5 | Combined cost ~8,361 tokens loads on every invocation regardless of tree size | LOW | Small cleanups (1–2 paths) pay same floor cost as large cleanups | Low-priority; benefit of consistent workflow exceeds cost optimization here |

PASS: Compact breakpoints present (Steps 4/7 conditional). Subagents correctly write to disk and return summaries.

Full notes: `audits/working/audit-working-notes-workflow-cleanup-worktree.md`

---

#### Workflow: Friday Cadence

**Scope:** 4 commands run in sequence: `/friday-checkup` (410L), `/friday-so` (58L), `/friday-journal` (326L), `/friday-act` (425L)

**Context loading chain:**
1. CLAUDE.md (~1,257 tokens)
2. friday-checkup.md → ~4,606 tokens (triggers 8+ subagents; writes checkup report to disk)
3. friday-so.md → ~390 tokens (BUT reads full checkup report ~300–500 lines inline)
4. friday-journal.md → ~4,914 tokens (reads full checkup report + 3–5 CLAUDE.md files inline)
5. friday-act.md → ~5,451 tokens (reads SO Advisory + Systems Review + per-project log bundles in Step 16a alone: ~500–1,500 lines)

**Total estimated single-session context load:** ~30,000–50,000+ tokens across a full Friday cadence run

**Findings (11 total — 5 HIGH, 5 MEDIUM, 1 LOW):**

| # | Finding | Severity | Waste mechanism | Recommendation |
|---|---------|----------|----------------|----------------|
| 1 | `/friday-so` reads full checkup report (~300–500 lines) inline to pass to system-owner agent — passthrough pattern | HIGH | Full report loaded into main session only to be forwarded; agent could receive the file path instead | Pass checkup report path to system-owner agent rather than reading content into main context; same for architecture-review file |
| 2 | `/friday-act` Step 16a reads SO Advisory + Systems Review target sections + per-project log bundles — command itself notes "~500–1,500 lines additional context in Step 16a alone" | HIGH | Documented in-command — no mitigation exists | Delegate Step 16a bundle assembly to a subagent; return a structured extract rather than raw log sections |
| 3 | `/friday-journal` Step 4 reads full checkup report ("matches /friday-so depth; not header-only") | HIGH | Same delegable-reads pattern as findings 1/2; three commands independently load the same checkup report | Create a checkup-extract file during `/friday-checkup` that all downstream commands can read instead of the full report |
| 4 | `improvement-analyst` agent in `/friday-checkup` §K has no return-size cap — breaks the canonical 30-line contract | HIGH | Uncapped return to main session; agent response can be arbitrarily long | Add explicit `max 30 lines` cap to improvement-analyst agent definition |
| 5 | `/friday-act` system-owner advisory echo: SO Advisory content echoed back to main session as chat text rather than read-from-disk | HIGH | Inline chat echo of potentially long advisory document | Have `/friday-act` read SO Advisory from disk at Step 3 rather than requesting operator-paste |
| 6 | Only 1 `/compact` checkpoint across the entire 4-command cadence | MEDIUM | A full Friday cadence run with 8+ subagents accumulates substantial context; single compact may be insufficient | Add compact checkpoints between `/friday-checkup` → `/friday-so` and after `/friday-journal` |
| 7 | Refinement multiplier ~9 sessions/monthly cycle — exceeds the >3 MEDIUM threshold | MEDIUM | Intentional (atomic commits per item) but structural token overhead is real | Accept as design tradeoff; note for Opus 4.7 upgrade |
| 8 | `/friday-checkup` triggers 8+ subagents in parallel; no explicit token budget guidance | MEDIUM | Multiple Opus subagents running concurrently with uncapped context | Add per-subagent context budget guidance |
| 9–11 | Additional MEDIUM/LOW findings (subagent compliance, inline loading patterns) | MEDIUM/LOW | See full notes for details | |

PASS: `findings-extractor` and `qc-reviewer` are compliant (≤30-line caps).

Full notes: `audits/working/audit-working-notes-workflow-friday-cadence.md`

---

#### Workflow: Research Workflow

**Scope:** Multi-stage pipeline — `/run-preparation`, `/run-execution`, `/run-analysis`, `/run-synthesis`, `/run-report` (plus per-chapter produce commands)

**Key structural finding:** The research workflow has the highest token load of any workflow in the repo — not from command file size, but from data-handling patterns that pass content (not paths) through the main session.

**Top findings (18 total — 6 HIGH, 9 MEDIUM, 3 LOW):**

| # | Finding | Severity | Waste mechanism | Recommendation |
|---|---------|----------|----------------|----------------|
| 1 | `/run-report` Step 4.0 loads 6 large input categories (chapter drafts, scarcity register, section directives, cluster memos, research extracts, editorial recommendations) into main session, then passes content to downstream subagents | HIGH | Content passed in memory rather than by path; subagents could read files directly | Refactor Step 4.0 to pass file paths to subagents, not file content; let subagents read directly (as `/produce-prose-draft` already does) |
| 2 | `/run-report` Step 4.2a per-chapter writer subagents return "chapter draft content" to main session — plausibly >200 lines, ~20 such calls per section | HIGH | Subagent return contract violation; chapter drafts are large text blocks | Per-chapter writers should write draft to disk and return path only (same pattern as `/produce-prose-draft`) |
| 3 | `/run-execution` Step 2.3 reads ALL raw research reports into main session before delegating to per-session extract subagents | HIGH | Large delegable read; main session bears the full load of all raw reports | Delegate raw report reads to extract subagents directly; pass file paths only |
| 4 | `/run-analysis` Step 1 reads all refined cluster memos into main session | HIGH | Delegable batch read in main context | Pass paths to analysis subagents; they read what they need |
| 5 | `/run-execution` Step 2.1b QC redundantly reads all prompts + specs + plan in main session | HIGH | Reads that are available to subagents already | Consolidate QC reads into a subagent or skip the redundant pass |
| 6 | `/run-report` Step 4.1b re-reads all 6 categories from Step 4.0 | HIGH (boundary) | Double-load of same content within the same command invocation | Cache Step 4.0 reads; do not re-read |
| 7 | `/run-cluster` has 0 `/compact` instructions despite iterating over multiple clusters | MEDIUM | Context accumulates across cluster iterations with no reset | Add `/compact` after each cluster or batch |
| 8 | `/run-report` has only 3 compacts for 13 delegate calls | MEDIUM | Insufficient compaction for a 13-subagent orchestration pass | Add compact breakpoints every 3–4 delegate calls |
| 9–18 | Additional MEDIUMs: repeated re-reads of cluster memos/extracts across stages; refinement multiplier 8–12 per section; command file verbosity | MEDIUM/LOW | See full notes | |

PASS: `/produce-prose-draft` implements the best token pattern in the repo — absolute-path subagent reads, output-to-disk, ≤20-line return caps. This pattern should be adopted across all `/run-*` commands.

Full notes: `audits/working/audit-working-notes-workflow-research-workflow.md`

---

## 9. Optimization Plan

### 9.1 Executive Summary

This audit found 47 total findings across all sections — concentrated in two areas: (1) file-protection gaps (audits/working/ not covered by deny rules, 89 working-notes files exposed) and (2) workflow data-handling patterns that pass content rather than paths through main session contexts. The CLAUDE.md and skill library are well-managed; the primary inefficiencies are structural to the Friday Cadence and Research Workflow designs.

The highest-priority action is also the quickest: adding `"Read(audits/working/**)"` to the deny rules in settings.json. This was recommended in the 2026-05-01 decisions log and has been deferred for two audit cycles. With 89 working-notes files now accumulated, the context-leak risk is material.

The largest structural token drain is in the Research Workflow — the `/run-*` commands load large content batches into main session context and pass content (not file paths) to subagents. The `/produce-prose-draft` command already implements the correct pattern; extending it to the other `/run-*` commands would be the highest-ROI structural change in the repo.

Implementing all HIGH recommendations is estimated to reduce per-session token consumption by 30–60% for research and Friday cadence sessions.

### 9.2 Prioritized Recommendations

#### HIGH Priority

**H1 — Add `Read(audits/working/**)` to deny rules** *(Quick win)*

| Field | Content |
|-------|---------|
| Issue | `audits/working/` contains 89 working-notes files not protected by Read() deny rules |
| Evidence | `audits/working/` — 89 files confirmed; 2026-05-01 decisions log explicitly recommended this fix |
| Waste mechanism | Claude Code Glob/Grep exploration loads stale per-audit working notes, coaching files, diff files into context |
| Estimated savings | HIGH — eliminates ~89-file context leak; audits/working likely grows over time |
| Implementation | Add `"Read(audits/working/**)"` to `permissions.deny` in `.claude/settings.json` |
| Risk | LOW — working notes are intermediate artifacts, not needed by any active workflow |
| Dependencies | None |
| Category | Quick win |

**H2 — Add `Read(reports/**)` to deny rules** *(Quick win)*

| Field | Content |
|-------|---------|
| Issue | `reports/` directory not covered — 7 report files accessible during exploration |
| Evidence | Section 6 finding #3 — ~13k words in reports/ |
| Waste mechanism | Prior reports loaded as stale context |
| Estimated savings | MEDIUM–HIGH |
| Implementation | Add `"Read(reports/**)"` to `permissions.deny` |
| Risk | LOW — verify no active workflow reads from reports/ during execution |
| Dependencies | None |
| Category | Quick win |

**H3 — Cap improvement-analyst agent return size** *(Quick win)*

| Field | Content |
|-------|---------|
| Issue | `improvement-analyst` agent in `/friday-checkup` has no return-size cap — violates the canonical 30-line Subagent Contracts rule |
| Evidence | Section 4 Friday Cadence finding #4; agent definition at `.claude/agents/improvement-analyst.md` |
| Waste mechanism | Uncapped agent return loads full improvement analysis into main session context |
| Estimated savings | HIGH — agent can return hundreds of lines; affects every Friday session |
| Implementation | Add `max 30 lines` return constraint to improvement-analyst agent definition |
| Risk | LOW — summary cap only; agent writes full notes to disk per existing Subagent Contracts pattern |
| Dependencies | None |
| Category | Quick win |

**H4 — Fix `/friday-so` and `/friday-journal` checkup report passthrough** *(Structural change)*

| Field | Content |
|-------|---------|
| Issue | Three Friday commands independently read the full checkup report inline (~300–500 lines each read) — passthrough to subagents |
| Evidence | Section 4 Friday Cadence findings #1, #3; `/friday-so` reads full report to embed in agent brief; `/friday-journal` Step 4 reads same report |
| Waste mechanism | Same 300–500 line document loaded 3× across the cadence; subagents receive content not paths |
| Estimated savings | HIGH — eliminate ~900–1,500 lines of redundant reads per Friday run |
| Implementation | (1) Add `checkup-extract.md` generation step at end of `/friday-checkup` — a 50-line structured summary for downstream commands; (2) Update `/friday-so`, `/friday-journal`, `/friday-act` to read the extract, not the full report |
| Risk | MEDIUM — requires coordinated changes to 4 command files |
| Dependencies | None; checkup-extract is additive |
| Category | Structural change |

**H5 — Refactor `/run-report` and `/run-execution` to pass file paths, not content** *(Structural change)*

| Field | Content |
|-------|---------|
| Issue | Research workflow `/run-report` Step 4.0 loads 6 large input categories into main session and passes content to subagents; Step 4.2a per-chapter subagents return full drafts to main |
| Evidence | Section 4 Research Workflow findings #1, #2; `/produce-prose-draft` already implements the correct pattern |
| Waste mechanism | Main session acts as a content relay — loads large batches only to forward them to subagents that could read directly |
| Estimated savings | HIGH — each research section run may save 10,000–50,000 tokens |
| Implementation | Refactor Steps 4.0/4.2a: pass absolute file paths to subagents; subagents read directly per `/produce-prose-draft` pattern; per-chapter writers write draft to disk + return path |
| Risk | MEDIUM — path-passing requires subagents to have reliable absolute paths (already established in produce-prose-draft) |
| Dependencies | None — model for correct implementation already exists |
| Category | Structural change |

**H6 — Refactor `/run-execution` to delegate raw report reads** *(Structural change)*

| Field | Content |
|-------|---------|
| Issue | `/run-execution` Step 2.3 reads ALL raw research reports into main session before delegating |
| Evidence | Section 4 Research Workflow finding #3 |
| Waste mechanism | All raw reports loaded in main context when subagents could read only the ones they need |
| Estimated savings | HIGH — raw report batch can be 5,000–20,000+ tokens |
| Implementation | Delegate report reads to extract subagents directly; pass file paths only from main |
| Risk | MEDIUM |
| Dependencies | H5 (same pattern change) |
| Category | Structural change |

**H7 — Split `/new-project.md` to remove post-pipeline enrichment** *(Structural change)*

| Field | Content |
|-------|---------|
| Issue | Command at 608 lines; ~65% (~392 lines) is Post-Pipeline Enrichment content not needed until after pipeline completes |
| Evidence | Section 4 /new-project finding #1; Section 3 command census (largest command) |
| Waste mechanism | ~5,139 tokens of post-pipeline content loaded on every /new-project invocation even when pipeline fails early or is never completed |
| Estimated savings | HIGH — reduces per-invocation load from ~7,908 to ~2,769 tokens |
| Implementation | Extract post-pipeline steps into a `/post-project-enrich` command or `new-project-enrich.md` reference loaded only on completion |
| Risk | MEDIUM — must ensure enrichment steps are not accidentally skipped |
| Dependencies | None |
| Category | Structural change |

#### MEDIUM Priority

**M1 — Wire mechanical Read preamble into `/session-plan` skill** *(Quick win)*

| Field | Content |
|-------|---------|
| Issue | Write-before-Read failure on `session-plan.md` logged 4+ consecutive Friday sessions |
| Evidence | `logs/usage-log.md` 2026-05-16 Acceptable entry; usage log recommendation |
| Waste mechanism | Each failure = 1 failed Write + 1 corrective Read + 1 retry Write (~2–3k tokens/session) |
| Estimated savings | MEDIUM — 4 recurrences confirmed; ~10–20k tokens projected over 5–10 sessions |
| Implementation | Add `Read(session-plan.md)` as first step of `/session-plan` skill body, not as behavioral discipline |
| Risk | LOW |
| Dependencies | None |
| Category | Quick win |

**M2 — Inline `/new-project` canonical CLAUDE.md duplicate sections** *(Quick win)*

| Field | Content |
|-------|---------|
| Issue | 4 CLAUDE.md sections duplicated verbatim in new-project.md (~140–150 lines, 30% of command) |
| Evidence | Section 4 /new-project finding #2 |
| Waste mechanism | Double-load on every invocation when CLAUDE.md is already in context |
| Estimated savings | MEDIUM — ~1,950 tokens per invocation |
| Implementation | Replace verbatim blocks with brief pointers: "See CLAUDE.md §Input File Handling" |
| Risk | LOW — CLAUDE.md is always loaded |
| Dependencies | None |
| Category | Quick win |

**M3 — Replace Step 11a model-ID lookup with inline constant** *(Quick win)*

| Field | Content |
|-------|---------|
| Issue | `/new-project` reads `buy-side-service-plan/CLAUDE.md` to extract model string |
| Evidence | Section 4 /new-project finding #3 |
| Waste mechanism | Full-file read for a single string value |
| Estimated savings | LOW–MEDIUM — eliminates one ~80-line read per invocation |
| Implementation | Inline the canonical model strings as constants in the command |
| Risk | LOW — update constants when model IDs change |
| Dependencies | None |
| Category | Quick win |

**M4 — Add `/compact` breakpoints to Friday Cadence and Research Workflow** *(Structural change)*

| Field | Content |
|-------|---------|
| Issue | Only 1 /compact across the entire 4-command Friday cadence; /run-cluster has 0; /run-report has 3 for 13 delegate calls |
| Evidence | Section 4 Friday Cadence finding #6; Research Workflow finding #8 |
| Waste mechanism | Context accumulates across multi-hour sessions without reset; auto-compaction fires at 80%+ creating non-deterministic truncation |
| Estimated savings | MEDIUM — prevents runaway context accumulation in long sessions |
| Implementation | Add explicit `/compact` trigger after /friday-checkup completion; add compact after each /run-cluster iteration |
| Risk | LOW — compaction is safe; custom CLAUDE.md compaction instructions preserve critical context |
| Dependencies | None |
| Category | Structural change |

**M5 — Cache log-trio at `/prime` to eliminate re-reads** *(Quick win)*

| Field | Content |
|-------|---------|
| Issue | session-notes.md, decisions.md, usage-log.md re-read 2× per Friday session (prime + wrap) |
| Evidence | `logs/usage-log.md` — flagged in multiple consecutive entries |
| Waste mechanism | Repeat reads of same files within same session (~3–4k tokens/session) |
| Estimated savings | MEDIUM — ~30–80k tokens projected over 10–20 Friday sessions |
| Implementation | Design `/prime` to load log-trio into a single consolidated context read; reference from memory at wrap instead of re-reading |
| Risk | LOW |
| Dependencies | None |
| Category | Quick win |

#### LOW Priority

**L1 — Fix 3 skill descriptions with marginal trigger quality**
Update `workflow-consultant`, `prompt-creator`, `session-guide-generator` with explicit trigger conditions. Low impact but prevents misfire. Quick win (3 file edits).

**L2 — Trim CLAUDE.md "What This Repo Contains" section**
Convert 18-line directory listing to a pointer (`See docs/repo-layout.md`). Saves ~200 tokens/session.

**L3 — Add context monitoring guidance**
Add brief note to CLAUDE.md or session-plan skill: "Run `/context` at workflow midpoints in heavy sessions."

**L4 — Restore frontmatter to workflow reference skill copies**
`workflows/research-workflow/reference/skills/` — add `name:` and `description:` frontmatter to knowledge-file-producer and report-compliance-qc copies.

### 9.3 Safeguard Proposals

1. **`Read(audits/working/**)` deny rule** — Add immediately to `.claude/settings.json` `permissions.deny`. Prevents 89-file stale context leak. (Implements H1.)

2. **Checkup-extract file pattern** — Modify `/friday-checkup` to write a 50-line structured summary extract at completion. All downstream Friday commands read the extract, not the full report. (Implements H4, reduces H3 risk.)

3. **Return-cap enforcement for improvement-analyst** — Add the same return-cap language to the improvement-analyst agent that token-audit-auditor, repo-dd-auditor, and log-sweep-auditor already have. Low effort, high safeguard value. (Implements H3.)

4. **Path-passing protocol in research workflow** — Document as a standing instruction in `workflows/research-workflow/CLAUDE.md`: "Subagents receive file paths, not content. Content loading in main session is prohibited." Reference `/produce-prose-draft` as the canonical implementation. (Supports H5/H6.)

### 9.4 Implications for Opus 4.7 Upgrade

- H7 (split /new-project) is a prerequisite for efficient Opus 4.7 use — at 608 lines, the command is expensive on any model tier; split before upgrading.
- H5/H6 (research workflow path-passing) should be implemented before upgrading research sessions to Opus 4.7 — the content-passing pattern costs proportionally more on Opus.
- MAX_THINKING_TOKENS=10000 (already set) may need re-tuning — Opus 4.7 extended-thinking budget may differ from prior Opus versions.
- `improvement-analyst` return cap (H3) is critical on Opus 4.7 — uncapped Opus outputs are substantially more expensive than uncapped Sonnet outputs.
- Friday Cadence compact breakpoints (M4) are a prerequisite for Opus 4.7 Friday runs — longer Opus outputs accumulate context faster.

### 9.5 Assumptions and Gaps

- **Research workflow execution telemetry absent:** All research workflow estimates are structural inferences from command file inspection, not observed session data. Actual token costs per research section run are unknown. A single instrumented research session would produce far more accurate estimates.
- **Friday Cadence timing not measured:** The cadence estimate of 30,000–50,000+ tokens per full run is structural; actual measured sessions may be lower if /compact fires appropriately mid-session.
- **Subagent return sizes estimated, not measured:** Claims about subagent return volumes (e.g., per-chapter writers returning >200 lines) are structural inferences from the command design. The improvement-analyst and system-owner cases are confirmed via design inspection.
- **`audits/working/` file sizes not individually measured:** Section 6 reports ~89 files and ~11k lines total; individual file sizes vary. The exposure is real but token cost per exploration varies.
- **Token estimation caveat applies throughout:** All estimates use word count × 1.3. Findings near a threshold boundary (±15%) are lower-confidence and flagged accordingly.

---

## 10. Self-Assessment

**Audit token cost:** `/cost` not available. This audit involved 7 subagent delegations (2 mechanical, 5 Opus workflow audits) plus substantial inline work. Estimated main-session context: large (protocol load ~4,000 tokens + all subagent summaries + incremental report writes).

**Protocol gaps encountered:**
1. The previous `audit-working-notes-preflight.md` file existed from prior audit runs, blocking the Write tool until Read was performed first. Protocol should note this risk for all working-notes files.
2. SCOPE_SLUG empty vs "ai-resources" distinction creates PREVIOUS_AUDIT mismatch — no empty-scope prior exists despite 3 comparable ai-resources-scoped audits. Protocol could define a cross-scope comparison option.
3. The 7-subagent launch required careful ordering (Section 6 and Section 2 mechanical subagents + 5 workflow Opus subagents in parallel). The [COST] flag fired as expected; protocol correctly anticipates this for full workflow audits.

**Confidence ratings by section:**

| Section | Confidence | Basis |
|---------|-----------|-------|
| 0. Pre-Flight | HIGH | Direct settings.json read + file measurements |
| 1. CLAUDE.md | HIGH | Direct file read + word count measurements |
| 2. Skill Census | HIGH | Batch measurements + subagent full-content reads of oversized skills |
| 3. Command Census | HIGH | Batch measurements + targeted grep for external loads |
| 4. Workflow Efficiency | MEDIUM–HIGH | Subagent reads of all relevant command/agent files; research workflow estimates are structural inferences (see 9.5) |
| 5. Session Patterns | HIGH | Direct usage-log read (2 substantive entries); configuration confirmed from settings.json |
| 6. File Handling | HIGH | Subagent scan + deny-rule cross-reference |
| 7. Missing Safeguards | HIGH | Direct inspection; reuses Step 0.3 finding |
| 8. Best Practices | HIGH | All items directly verifiable from audit evidence |
| 9. Optimization Plan | MEDIUM | Savings estimates are structural inferences; research workflow estimates have no telemetry baseline |

**Threshold-boundary findings (within ±15% of severity boundary):**
- Section 4 /cleanup-worktree: `execution-protocol.md` at 337 lines — 12.3% above the 300-line HIGH threshold. Classified HIGH (boundary).
- Section 4 /repo-dd: command at 318 lines — within 6% of 300-line HIGH threshold for Section 3. Classified MEDIUM for command census (not a skill).
- Section 4 research workflow: `/run-report` Step 4.1b re-reads — classified HIGH (boundary) due to pattern similarity with confirmed HIGH cases.
- Section 2: `summary/SKILL.md` at 299 lines — 1 line below HIGH threshold. MEDIUM finding.

