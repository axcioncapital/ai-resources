# Token-Usage Efficiency Audit — Axcíon AI Workspace (full)

**Scope:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo` (workspace root)
**Scope slug:** workspace
**Date:** 2026-06-05
**Protocol:** token-audit-protocol v1.3
**Mode:** Friday-checkup cadence — DIAGNOSTIC ONLY. No commit; report stays unstaged.
**Previous workspace-scope audit:** None (first workspace-scoped run).

> **Token-estimation caveat.** Token counts are word count × 1.3, a proxy with ~±30% drift vs. a real tokenizer. Severity thresholds tied to line/token counts are approximate; findings within ±15% of a boundary are flagged in Section 10.

> **Scope boundary (important).** The workspace root's `.claude/commands/` (62 files) and `.claude/agents/` are **symlinks into `ai-resources/.claude/`**. Their content is audited under the **ai-resources scope** (separate run this cycle) and is NOT re-deep-audited here. This audit covers: the workspace-root `CLAUDE.md` (§1), the 6 workspace-root-owned harness skills under `.claude/skills/` (§2, kept light), the symlinked command surface as pointers (§3), workspace-root session/config patterns (§5), workspace-root file-handling and read-protection (§6), and cross-cutting safeguards (§7).

---

## 0. Pre-Flight

- **0.1 Baseline metrics:** `/cost` and `/context` not available in this execution environment. Non-blocking; the audit's own token cost is not measured (Section 10).
- **0.2 Session telemetry:** `session-usage-analyzer` skill present (`ai-resources/skills/session-usage-analyzer/SKILL.md`). Workspace-root in-scope telemetry: `logs/usage-log.md` (2 entries) + `harness/logs/usage-log.md`. Thin (≤3 entries) → Section 5 runs inline, no delegation.
- **0.3 Read(pattern) deny coverage:** **HIGH** — workspace-root `.claude/settings.json` `permissions.deny` contains only `Bash(...)` rules; **zero `Read(...)` entries**. `settings.local.json` has no deny array. No directory is read-protected. (Detail re-used in §6 and §7.)
- **0.4 Output:** this file, written incrementally.

Full pre-flight notes: `ai-resources/audits/working/audit-working-notes-preflight-workspace.md`.

---

## 1. CLAUDE.md Audit

**File:** `CLAUDE.md` (workspace root)
**Line count:** 217
**Estimated tokens:** 2222 words × 1.3 ≈ **2,889 tokens**
**Headings:** 33
**Subdirectory CLAUDE.md files found:** 24 across the workspace (1 per project + per vault), e.g. `ai-resources/CLAUDE.md`, `projects/*/CLAUDE.md`, `knowledge-bases/*/CLAUDE.md`. Each is a separate scope; only the root file is in scope here.

**Per-session cost:** ~2,889 tokens on every turn of every workspace-root session. Over a 30–50-turn session that is ~87K–144K tokens spent purely on root-CLAUDE.md loading (before any project CLAUDE.md, which loads on top in project sessions).

**Assessment:**
- **Size (217 lines):** Just over Anthropic's 200-line guidance — MEDIUM by line count, but only ~2,889 tokens, modest in absolute terms. Borderline (within ±15% of the 200 threshold) — see §10.
- **Essentials test:** Strong. Nearly every section applies across all/most session types (autonomy, commit/push, QC, model tier, guardrails, decision-point posture). This is a genuinely cross-cutting file.
- **Skill-eligible content:** None material. The file is almost entirely short behavioral rules + pointers to `ai-resources/docs/*` for detail — the correct lean pattern. Detailed methodology lives in the referenced docs, not inline.
- **Redundancy with skills:** Low. Pointers, not duplication.
- **Compaction instructions:** PRESENT (line 85 — pointer to `compaction-protocol.md`). Safeguard satisfied.
- **Aspirational vs behavioral:** Almost all behavioral. Minor descriptive framing in "What This Workspace Is For" / "Axcíon's Tool Ecosystem" (lines 3–21, ~19 lines) — orienting context, low-value-per-token but not wrong.

**Findings:**

| # | Finding | Severity | Lines | Recommendation |
|---|---------|----------|-------|----------------|
| 1.1 | 217 lines, slightly over 200-line guidance; ~2,889 tokens/turn | LOW | whole file | Optional trim. The file is already lean (pointer pattern). Tool Ecosystem block (15–21) could compress to 2 lines or move to a doc pointer, saving ~10 lines. Not worth structural work. |
| 1.2 | Orienting/descriptive prose in opening sections | LOW | 3–21 | Leave as-is or compress Tool Ecosystem list. Marginal. |

CLAUDE.md is in good shape: lean, behavioral, pointer-based, compaction-aware. No HIGH/MEDIUM findings.

---

## 2. Skill Census (workspace-root-owned only — LIGHT)

Per the scope mandate, the canonical skill library lives under `ai-resources/skills/` (audited separately). The workspace root owns **6 real skills** under `.claude/skills/` — the Agent Harness phase skills. These are audited here.

**Total root-owned skills:** 6
**Total lines:** 2,359
**Total estimated tokens:** ~17,800 words × 1.3 ≈ **~23,100 tokens** (only loaded when a harness session invokes the relevant phase skill — on-demand, not per-session).

**Size distribution:** Under 50: 0 · 50–150: 0 · 150–300: 3 (prompt-hardener 220, verification-playbook 268) + session-reporter 304 straddles · 300+: 4 (session-governor 795, failure-mode-detector 437, mandate-parser 335, session-reporter 304).

| Rank | Skill | Lines | Words | Finding |
|------|-------|-------|-------|---------|
| 1 | session-governor | 795 | 6944 | HIGH by raw threshold; justified — full Phase-B state-machine spec. Loaded once per harness session. |
| 2 | failure-mode-detector | 437 | 2973 | HIGH by raw threshold; dense detection/registry logic. |
| 3 | mandate-parser | 335 | 2342 | HIGH by raw threshold; Phase-A startup spec. |
| 4 | session-reporter | 304 | 2104 | HIGH by raw threshold (barely); Phase-D reporting spec. |
| 5 | verification-playbook | 268 | 1866 | MEDIUM (150–300). |
| 6 | prompt-hardener | 220 | 1571 | MEDIUM (150–300). |

**Description quality:** All 6 have trigger-rich, specific descriptions (exact phase, exact caller, exact trigger event, write-ownership). No vague descriptions. No missing-frontmatter cases for `name`/`description`.

| Skill | Issue | Severity |
|-------|-------|----------|
| mandate-parser | Lacks `model:` frontmatter (the other 5 declare `model:`) | LOW |

**Redundancy:** None. The 6 skills are sequential, non-overlapping harness phases (A→B→D + Phase 5/6 sub-skills). No dead skills (all referenced by harness commands + harness-rules.md).

**Note on size HIGHs:** The four 300+-line skills are flagged HIGH by the protocol's raw line threshold, but each is a single-purpose harness phase specification loaded on-demand, not per-turn. Real per-session impact is bounded to harness sessions only. These are MEDIUM-in-practice, not session-wide HIGH drains. They are also candidates the **ai-resources scope** would not see (they live at workspace root) — flagged here so they aren't missed, but compression is a refinement task, not a token emergency.

---

## 3. Command File Census (symlink surface — pointer audit)

**Total command files at workspace root:** 62, **all symlinks** into `ai-resources/.claude/commands/` (and a few into `ai-resources/skills/*/command.md`, e.g. `audit-repo.md → repo-health-analyzer/command.md`).

**Audit treatment:** Command *content* (load chains, external-file reads, cascading loads) is audited under the **ai-resources scope**, where the real files live. Re-auditing them here would double-count. This section confirms the symlink surface is intact and notes structural observations only.

| Observation | Detail |
|-------------|--------|
| Symlink integrity | Spot-checked: `analyze-workflow.md`, `architecture-review.md`, `audit-claude-md.md`, `clarify.md`, `audit-repo.md` all resolve to valid `../../ai-resources/...` targets. No broken symlinks observed in the listing. |
| Duplicate command surface | `harness/.claude/commands/` holds a **parallel real (non-symlink) set** of several commands (prime.md, friday-act.md, friday-checkup.md, wrap-session.md, session-start.md). These are harness-local copies, not symlinks — a divergence risk (two sources for prime/friday-act/wrap-session). See §6 / §7. |
| Largest symlinked commands | `new-project.md` 665, `prime.md` 452, `friday-act.md` 451, `friday-checkup.md` 424, `wrap-session.md` 359 — all audited under ai-resources scope for load-chain cost. |

**Finding:**

| # | Finding | Severity | Recommendation |
|---|---------|----------|----------------|
| 3.1 | `harness/.claude/commands/` duplicates several commands as real files (prime, friday-act, friday-checkup, wrap-session, session-start) that also exist as canonical symlinks at root. Two sources of truth → drift risk + double maintenance. | MEDIUM | Confirm whether the harness set is intentionally divergent (harness-specific variants) or stale copies. If variants, document the split; if stale, replace with symlinks. Investigate under a maintenance session, not this diagnostic. |

---

## 4. Workflow Token Efficiency

**Workspace-root-owned workflows:** **None.** Canonical workflow templates live under `ai-resources/workflows/` (audited under the ai-resources scope). The only workflow-named directory at root is `harness/test-workflows/` — a test fixture (minimal-markdown), not an active production workflow. **Section 4 is N/A for this scope.** No findings.

---

## 5. Session Patterns & Configuration

**Session telemetry available:** Thin. `logs/usage-log.md` has 2 dated entries (2026-05-18 "Wasteful", 2026-05-21 "Acceptable"). Both pre-date this scope's config and reference ai-resources skill work, not workspace-root patterns. Insufficient for trend analysis — findings below are structural.

**Configuration audit:**

| Setting | Current value | Recommended | Impact |
|---------|--------------|-------------|--------|
| Default model (settings.json) | **Not set** (correct — workspace prohibits `"model"` field) | Per-command/skill `model:` frontmatter only | Compliant with Model Tier rule. Do NOT add. |
| Subagent model | Not set in settings; governed by per-agent `model:` frontmatter (agent-tier-table) | Haiku/Sonnet per agent | Compliant. |
| MAX_THINKING_TOKENS | **10000** (root settings.json env) | 10000 routine | GOOD — matches best practice item 8. |
| Autocompact threshold | Not set (`CLAUDE_AUTOCOMPACT_PCT_OVERRIDE` absent) | 80% optional | Minor — default behavior; PreCompact/PostCompact hooks already log events. |
| MCP servers | Not observable from repo context (user-home settings inaccessible) | Disable unused | Not assessable this scope. |
| defaultMode | bypassPermissions (settings.json + settings.local.json) | — | Operator-agreed floor (memory: zero-permission-prompts). Compliant. |
| HARNESS_DEBUG / HARNESS_OVERHEAD_TARGET_PCT | false / 15 | — | Harness telemetry config; no context cost. |

**Hooks (root `.claude/settings.json`):**
- `SessionStart` → `logs/scripts/check-archive.sh --warn-only` (log-size nudge)
- `PreCompact` → `.claude/hooks/precompact.sh` (compaction logging)
- `PostCompact` → `.claude/hooks/postcompact.sh`
- `SubagentStop` → `.claude/hooks/subagent-stop.sh` (subagent output verification)

All four are wrapped `2>/dev/null; exit 0` with 10s timeouts — **non-blocking, no stdout into context**. No token-cost concern. Token-positive: the archive-warn hook actively pushes toward smaller log files, and SubagentStop supports the output-to-disk verification pattern.

**Finding:** Configuration is clean. No HIGH/MEDIUM config findings. `MAX_THINKING_TOKENS=10000` and the compaction-logging hooks are best-practice-aligned.

---

## 6. File Handling Patterns

**Read(pattern) deny-rule status (from §0.3): HIGH.**
Covered directories: **none.**
Missing expected coverage: `audits/`, `logs/`, `reports/`, `inbox/`, `archive/`, `output/`, `drafts/`, `*deprecated*/*old*`.

**Critical clarification:** The workspace `.gitignore` excludes `archive/`, all nested `projects/*`, `knowledge-bases/`, and `ai-resources/` from *commits* — but **`.gitignore` does NOT block `Read`/`Glob`/`Grep`**. Read-protection is a separate mechanism (`permissions.deny → Read(...)`), and it is entirely absent. So during exploration, Claude can freely read stale archives, old session notes, prior reports, and harness state JSON.

**Large files in workspace-root non-project areas (by line count):**

| File | Lines | Should Claude read this? | Covered by Read() deny? |
|------|-------|--------------------------|--------------------------|
| logs/session-notes-archive-2026-04.md | 821 | No (archive) | No |
| logs/session-notes-archive-2026-05.md | (archive) | No | No |
| logs/session-notes.md | 590 | Sometimes (handoff tail) | No |
| harness/logs/session-notes.md | 499 | No (harness-internal) | No |
| harness/session/session-log.json | 336 | No (machine state) | No |
| reports/child-cycle-landing-diagnostic-2026-05-28.md | 321 | No (prior report) | No |
| logs/decisions.md | 315 | Sometimes (active) | No |

**Findings:**

| # | Finding | Severity | Recommendation |
|---|---------|----------|----------------|
| 6.1 | **No `Read(...)` deny rules at workspace root** — every archive/log/report/harness-state file is readable during Glob/Grep/Read exploration. Highest-leverage finding in this audit: affects every exploratory session. | HIGH | Add a `permissions.deny` block with `Read(...)` entries to root `.claude/settings.json` covering: `logs/session-notes-archive-*.md`, `logs/*-archive-*`, `reports/**`, `harness/logs/**`, `harness/session/**`, `harness/reports/**`, `archive/**`, and any `*deprecated*`/`*old*` paths. Mirror the canonical shape in `ai-resources/docs/permission-template.md`. **Harness-config change → operator-gated per Autonomy Rule 8 (audit-discipline.md); diagnostic only this cycle — recommend, don't apply.** |
| 6.2 | Archived session-notes (821-line 2026-04 archive + 2026-05 archive) sit in `logs/` readable. The archive split is good hygiene; the missing read-deny undercuts it. | MEDIUM | Same fix as 6.1 — deny `logs/*archive*`. |
| 6.3 | `harness/` carries substantial internal state (session-log.json 336, reports/, reviews/, learning/) with no read-protection — harness-internal files could be pulled into a non-harness session. | MEDIUM | Deny `harness/logs/**`, `harness/session/**`, `harness/reports/**`, `harness/reviews/**` for non-harness sessions (or scope at the harness `.claude` layer). |
| 6.4 | `reports/` holds prior diagnostic outputs (child-cycle-landing 321) readable during exploration. | MEDIUM | Deny `reports/**`. |

---

## 7. Missing Safeguards

| Safeguard | Status | Severity if missing | Recommendation |
|-----------|--------|---------------------|----------------|
| `Read(pattern)` deny rules covering stale/large dirs | **Absent** | HIGH | Add Read() deny block (see §6.1). Single highest-value fix for this scope. |
| Custom compaction instructions in CLAUDE.md | **Present** | — | Line 85 pointer to compaction-protocol.md; reinforced by PreCompact/PostCompact hooks. |
| Subagent output-to-disk pattern | **Present** | — | ai-resources Subagent Contracts (notes-to-disk + ≤30-line summary); SubagentStop hook verifies. |
| Context-window monitoring instructions | **Partial** | LOW | CLAUDE.md has "Context constraint deferral" (line 87) but no explicit `/context`/`/cost` guidance. Behavioral-deferral equivalent present; literal command guidance absent. |
| Session boundaries defined | **Present** | — | "Prefer /clear over dirty context" (line 86) + session-boundaries.md. |
| Model selection guidance | **Present** | — | Model Tier + Model Escalation sections; per-frontmatter tiering mandated. |
| File read scoping (lines X-Y vs whole file) | **Present** | — | "Read-scope floors" (line 88) — floors-not-ceilings rule. |
| Output length constraints | **Present** | — | Subagent summary caps (20/30 lines) in ai-resources Subagent Contracts; this audit's own COMPACT return cap. |
| Effort level guidance | **Partial** | LOW | MAX_THINKING_TOKENS=10000 set (a hard budget); no per-task `/effort` guidance. Acceptable. |
| Hook-based output truncation | **Partial** | LOW | Hooks exist but none truncate tool output; all are `2>/dev/null` (suppress hook stdout, not tool output). Low value to add. |
| Audit/output artifact isolation | **Absent (read-deny side)** | MEDIUM | Audit outputs land in `ai-resources/audits/` and `reports/`, but neither is covered by a Read() deny — future sessions can read prior audits. Fold into §6.1 fix. |

---

## 8. Best Practices Comparison (May 2026)

| # | Practice | Status | Gap | Priority |
|---|----------|--------|-----|----------|
| 1 | CLAUDE.md < 200 lines | Partial | 217 lines; lean/pointer-based, ~2,889 tokens | LOW |
| 2 | Read(pattern) deny rules configured | **Not implemented** | Zero Read() denies at root (§6.1) | **HIGH** |
| 3 | Skills use on-demand loading | Implemented | Harness skills load per-phase; rich descriptions | — |
| 4 | Subagents for heavy reads | Implemented | ai-resources Subagent Contracts mandate it | — |
| 5 | Strategic /compact at breakpoints | Implemented | compaction-protocol.md + PreCompact/PostCompact hooks | — |
| 6 | /clear between unrelated tasks | Implemented | session-boundaries rule (line 86) | — |
| 7 | Model selection per task type | Implemented | Model Tier (frontmatter tiering); no settings default (correct) | — |
| 8 | Extended-thinking budget controlled | Implemented | MAX_THINKING_TOKENS=10000 | — |
| 9 | Unused MCP servers disabled | Not observable | User-home settings inaccessible this scope | — |
| 10 | Output-to-disk for subagents | Implemented | Subagent Contracts + SubagentStop hook | — |
| 11 | Precise prompts over vague | Implemented | CLAUDE.md mandates exact-target prompts; commands are structured | — |
| 12 | Session-notes pattern | Implemented | session-notes.md (append-to-end), /handoff, /wrap-session | — |
| 13 | Similar-trigger skills disambiguated | Implemented (root scope) | 6 harness skills are non-overlapping sequential phases | — |
| 14 | Agent/skill prompts use structured sections | Implemented | Harness skills + harness-rules.md use headed/structured sections | — |
| 15 | Few-shot examples where useful | Not assessed (root scope) | Harness skills are spec-style; example-presence is an ai-resources-scope concern | — |

**Single gap of consequence: practice 2 (Read deny rules) — HIGH.** Everything else is implemented or correctly not-applicable.

---

## 9. Optimization Plan

### 9.1 Executive Summary

The Axcíon AI workspace root is in strong token-hygiene shape. CLAUDE.md is lean and pointer-based (217 lines, ~2,889 tokens/turn), `MAX_THINKING_TOKENS` is budgeted at 10,000, compaction and session-boundary safeguards are present, and the subagent output-to-disk pattern is enforced with hook verification. The command/agent surface is symlinked into `ai-resources/` (audited there), so this scope's real owned surface is small: one CLAUDE.md, six harness skills, and the workspace-root config + file-handling layer.

The one consequential finding is the **complete absence of `Read(...)` deny rules** in the workspace-root `.claude/settings.json`. Combined with the fact that `.gitignore` does not block reads, this means every exploratory Glob/Grep/Read can pull in stale archives (an 821-line April session-notes archive plus a May one), prior reports, and harness-internal state (session-log.json, harness/logs, harness/reports) into context. This is the highest-leverage optimization available for this scope because it affects every session that explores the tree, and it is a one-time settings edit.

Secondary items are a command-surface duplication between `harness/.claude/commands/` and the canonical symlinks (drift/maintenance risk), and four harness skills that exceed the 300-line raw threshold (justified as phase specs, on-demand-loaded — refinement, not emergency). Implementing the Read-deny block is the only HIGH-impact change and is estimated to cut per-exploratory-session context risk materially (best-practice literature cites 40–70% per-request context reduction from well-configured deny rules, though the realized figure here depends on how often exploration touches the unprotected dirs).

### 9.2 Prioritized Recommendations

**HIGH**

| Field | Content |
|---|---|
| **Issue** | No `Read(...)` deny rules at workspace root; archives/logs/reports/harness-state freely readable during exploration. |
| **Evidence** | `.claude/settings.json` `permissions.deny` = `[Bash(rm -rf *), Bash(sudo *), Bash(git reset --hard *), Bash(git checkout *)]` — zero Read() entries. Large unprotected files: `logs/session-notes-archive-2026-04.md` (821), `logs/session-notes.md` (590), `harness/logs/session-notes.md` (499), `harness/session/session-log.json` (336), `reports/child-cycle-landing-diagnostic-2026-05-28.md` (321). `.gitignore` does not block reads. |
| **Waste mechanism** | Exploratory Glob/Grep/Read loads stale archival + machine-state content into context; repeats per exploring session. |
| **Estimated savings** | **HIGH** — affects every exploratory session; protected content runs to thousands of lines. |
| **Implementation steps** | Add to root `.claude/settings.json` `permissions.deny`: `Read(logs/*archive*)`, `Read(logs/session-notes-archive-*.md)`, `Read(reports/**)`, `Read(harness/logs/**)`, `Read(harness/session/**)`, `Read(harness/reports/**)`, `Read(harness/reviews/**)`, `Read(archive/**)`, `Read(**/*deprecated*)`, `Read(**/*old*)`. Mirror canonical shape in `ai-resources/docs/permission-template.md`; validate via `/permission-sweep`. |
| **Risk** | Over-broad globs could deny-read an active file (e.g., a non-archive note matching `*old*`). Scope patterns precisely; test with a read after applying. Do not deny `logs/decisions.md` or the live `logs/session-notes.md` tail. |
| **Dependencies** | Harness-config change → **operator-gated (Autonomy Rule 8, audit-discipline.md)**. DIAGNOSTIC cycle: recommend only, do not apply. Coordinate with `/permission-sweep` so layers stay consistent. |
| **Category** | Structural change (settings edit + glob design + cross-layer consistency). |

**MEDIUM**

| Field | Content |
|---|---|
| **Issue** | `harness/.claude/commands/` duplicates canonical commands as real files (prime, friday-act, friday-checkup, wrap-session, session-start). |
| **Evidence** | `harness/.claude/commands/prime.md` (452), `friday-act.md` (451), `friday-checkup.md` (424), `wrap-session.md` (409), `session-start.md` (317) exist as real files alongside root symlinks of the same names into ai-resources. |
| **Waste mechanism** | Two sources of truth → divergence + double maintenance; risk a session loads a stale harness variant. |
| **Estimated savings** | MEDIUM — maintenance/drift cost, not per-turn token cost. |
| **Implementation steps** | Determine intent: if harness variants are deliberate, document the split in `harness/README.md`; if stale, replace with symlinks into ai-resources. |
| **Risk** | Replacing intentional harness-specific variants with symlinks would break harness behavior. Investigate before acting. |
| **Dependencies** | Maintenance session; not this diagnostic. |
| **Category** | Structural change. |

**LOW**

| Field | Content |
|---|---|
| **Issue** | (a) CLAUDE.md 217 lines (over 200); (b) `mandate-parser` lacks `model:` frontmatter; (c) four harness skills exceed 300 lines. |
| **Evidence** | CLAUDE.md 217/2222w; `mandate-parser/SKILL.md` frontmatter has `name`+`description`, no `model:`; session-governor 795, failure-mode-detector 437, mandate-parser 335, session-reporter 304. |
| **Waste mechanism** | (a) marginal per-turn; (b) tier-inheritance ambiguity; (c) on-demand load cost in harness sessions only. |
| **Estimated savings** | LOW. |
| **Implementation steps** | (a) Optionally compress Tool Ecosystem block (lines 15–21). (b) Add explicit `model:` to mandate-parser frontmatter per Model Tier "never inherit" rule. (c) Defer skill compression to a refinement pass — these are single-purpose phase specs. |
| **Risk** | Minimal. |
| **Dependencies** | None. |
| **Category** | Quick win (b); optional (a, c). |

### 9.3 Safeguard Proposals

1. **Read-deny block** (the §6.1 fix) — add the `Read(...)` deny array to root `.claude/settings.json`, scoped to archives/reports/harness-state. This is itself the primary recurrence-prevention safeguard. Operator-gated.
2. **`/permission-sweep` cross-layer pass** — after adding root Read-denies, run `/permission-sweep` so the workspace, ai-resources, and project layers stay consistent against `permission-template.md`.
3. **Harness command-source decision record** — log a decision in `logs/decisions.md` documenting whether `harness/.claude/commands/` is a deliberate variant set or should be symlinked, to stop the drift from recurring silently.

### 9.4 Implications for Future Opus 4.7 Upgrade

- The Read-deny gap (§6.1) is **upgrade-independent** but more valuable post-upgrade: a larger/more capable model exploring an unprotected tree pulls more stale context per session. Fix before upgrade.
- `MAX_THINKING_TOKENS=10000` is already set — revisit the budget at upgrade time if Opus 4.7 changes default thinking economics.
- No settings-level `"model"` default exists (correct) — upgrade requires no settings change; the operator selects the model via `/model` per the Model Tier rule.
- Harness skill sizes (§2) are loaded per-phase; a model upgrade does not change their per-session cost profile, so no upgrade-blocking dependency there.

### 9.5 Assumptions and Gaps

- **`/cost` and `/context` unavailable** in this execution environment — the audit's own token cost is unmeasured, and no live per-session telemetry could be captured.
- **Command/agent content not measured here** — deliberately deferred to the ai-resources scope (the symlink targets). If the ai-resources audit did not run this cycle, the command load-chain analysis (§3) has a gap.
- **MCP servers not observable** — user-home `~/.claude/settings.json` inaccessible from this scope; practice 9 unassessed.
- **Telemetry too thin for trends** — only 2 workspace-root usage-log entries; Section 5 findings are structural, not observed-usage-derived.
- **Read-deny realized savings** rely on the assumption that exploratory sessions actually touch the unprotected dirs; the 40–70% figure is from best-practice literature, not measured for this repo.

---

## 10. Self-Assessment

1. **Audit token cost:** Not measurable — `/cost` unavailable. Audit ran inline (no subagent delegation) given the small owned surface (1 CLAUDE.md, 6 skills, config); delegation overhead would have exceeded the read cost.
2. **Protocol gaps / improvisations:**
   - The protocol assumes a single-repo scope; this workspace root is mostly **symlinks into ai-resources + gitignored nested repos**. I treated symlinked commands/agents as pointers (content audited under ai-resources scope) and audited only the 6 real workspace-root skills — per the mandate. Protocol could add explicit "symlinked-surface" handling guidance.
   - The pre-flight working-notes filename collided with a prior-scope file; I suffixed it `-workspace` to avoid clobbering. Protocol's fixed `audit-working-notes-preflight.md` path should be scope-suffixed when multiple scopes are audited in one cycle.
   - `.gitignore`-vs-`Read()` distinction is critical here and worth a protocol callout (gitignore does not block reads).
3. **Confidence levels:**
   - §1 CLAUDE.md — **HIGH** (full file read + measured).
   - §2 Skills — **HIGH** (measured + frontmatter read).
   - §3 Commands — **MEDIUM** (symlink integrity spot-checked, not exhaustively; content deferred to ai-resources scope).
   - §5 Config — **HIGH** (settings files read directly).
   - §6/§7 File-handling & safeguards — **HIGH** (deny array read directly; large-file scan measured).
   - §8 Best practices — **HIGH** for owned surface; **MEDIUM** where deferred to ai-resources.
4. **Threshold-boundary findings (±15%):**
   - CLAUDE.md 217 lines vs 200 boundary (8.5% over) — MEDIUM/LOW boundary; classified LOW given low absolute token count.
   - `session-reporter` 304 lines vs 300 boundary (1.3% over) — HIGH/MEDIUM boundary; effectively MEDIUM.
   These may flip classification under a real tokenizer.

---

*End of audit. DIAGNOSTIC ONLY — report unstaged, no commit (Friday-checkup cadence).*
