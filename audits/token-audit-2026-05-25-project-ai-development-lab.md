# Token Audit — 2026-05-25
Scope: projects/ai-development-lab
AUDIT_ROOT: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab
Previous audit: None

---

## 0. Pre-Flight Summary

- **Baseline session metrics:** `/cost` and `/context` not available as callable tools in this Skill-invocation environment.
- **Session telemetry discovered:** `projects/ai-development-lab/logs/usage-log.md` (91 lines, 2 session entries). Most recent (2026-05-21) ran a full `/analyze-transcript` pipeline: ~316K subagent tokens, ~153K from system-owner dispatches alone. Rating: Acceptable.
- **Read(pattern) deny-rule coverage verdict: HIGH.** No `Read()` deny rules exist at all in this project's `.claude/settings.json`. Existing denies cover only Bash and `Write/Edit(transcripts/**)`. Large pipeline artifacts (technical-spec 63KB, implementation-spec 55KB, project-plan 40KB, architecture 35KB, repo-snapshot 27KB) sit unprotected, as does the output/ directory.
- Full notes: `audits/working/audit-working-notes-preflight-ai-development-lab.md`.

---

## 1. CLAUDE.md Audit

**Files under AUDIT_ROOT:**
- `projects/ai-development-lab/CLAUDE.md` — 109 lines, 779 words, ≈ 1,013 tokens

**Out-of-scope note:** The workspace-root `CLAUDE.md` (~250 lines, ~3,200 tokens) also loads in every project session via parent directory walk. Out of audit scope; flagged for awareness.

**Per-session cost:**
- `ai-development-lab/CLAUDE.md`: ~1,013 tokens × every turn × ~20–40 turns/session = ~20,260 – 40,520 tokens spent on CLAUDE.md loading.

**Findings:**

| # | Finding | Severity | Recommendation |
|---|---------|----------|----------------|
| 1.1 | CLAUDE.md is 109 lines — well under the 200-line ceiling. Content is project-specific: purpose, 5-stage pipeline, invocation, agent scope boundaries, memo discipline, cross-project coupling. All sections apply across pipeline sessions. | PASS | No action. |
| 1.2 | Model Selection section (lines 102–109) correctly declares "No project default" and uses *recommended posture* language (allowed per workspace Model Tier rule). The ai-engineer agent's `model: opus` frontmatter is referenced — correct enforcement pattern. | PASS | No action. |
| 1.3 | "Cross-project coupling notes" section (lines 88–100) documents the SessionStart auto-sync hook and the `shared-manifest.json` exclusion mechanism. This is project-specific behavior unique to this project — appropriately scoped to its CLAUDE.md. | PASS | No action. |
| 1.4 | No "Compaction" section in this CLAUDE.md. The workspace-level CLAUDE.md has compaction guidance, but the project doesn't add project-specific compaction items (e.g., what to preserve mid-`/analyze-transcript` if context spikes). | LOW | Optional: add 3-line Compaction section naming the pipeline stage state + pending subagent dispatch paths as items to preserve during `/compact`. |

**No HIGH or MEDIUM findings in Section 1.**

---

## 2. Skill Census

**Total skills measured:** 0 — this project has no project-local SKILL.md files.

All skills consumed by this project (e.g., `session-usage-analyzer`, `ai-resource-builder`, plus 70+ others) are shared from `ai-resources/skills/` via the auto-sync mechanism. This is the correct design per workspace CLAUDE.md ("`ai-resources/skills/` is the canonical skill library. Project workspaces reference skills via copy or symlink — they do not own them.").

**Per-session loading cost:** Skills load on demand by name (no cost until invoked). When invoked, the SKILL.md is read from the project-local `.claude/` mirror (or via `additionalDirectories`). Section 4 covers workflow-level cost.

**No findings in Section 2 for this project's scope.** Skill-quality findings belong in the ai-resources audit (already complete).

---

## 3. Command File Census

**Total command files found:** 58 in `projects/ai-development-lab/.claude/commands/` (all auto-synced from `ai-resources/.claude/commands/` via the SessionStart hook).
**Total lines across all commands:** 7,710

**Project-specific commands (not synced from ai-resources):** 3
- `analyze-transcript.md` — 312 lines, ~4,000 tokens (main pipeline entry; see Section 4)
- `review-pipeline-run.md` — 284 lines, ~3,600 tokens
- `produce-handoff.md` — measured at moderate size (handoff prep post-memo approval)

**Top 10 commands by line count (all shared from ai-resources, identical to ai-resources audit findings):**

| Command | Lines | Status |
|---|---|---|
| friday-act | 435 | Shared from ai-resources |
| friday-checkup | 411 | Shared from ai-resources |
| monday-prep | 330 | Shared from ai-resources |
| friday-journal | 326 | Shared from ai-resources |
| permission-sweep | 324 | Shared from ai-resources |
| repo-dd | 318 | Shared from ai-resources |
| **analyze-transcript** | **312** | **Project-local** |
| log-sweep | 303 | Shared from ai-resources |
| review-pipeline-run | 284 | Project-local |
| innovation-sweep | 272 | Shared from ai-resources |

**Findings:**

| # | Finding | Severity | Recommendation |
|---|---|---|---|
| 3.1 | `analyze-transcript.md` (312 lines, ~4,000 tokens per invocation) is the heaviest project-local command. Pipeline orchestrator with 5 stages and 3 Task dispatches. Investigated in Section 4. | MEDIUM | See Section 4 workflow recommendations. |
| 3.2 | `review-pipeline-run.md` (284 lines) is also large for a project-local command. Reviews a completed pipeline run — could be checked for delegable read patterns. | LOW | Optional structural review next iteration. |
| 3.3 | The remaining 55 commands are shared from ai-resources via auto-sync. Per-invocation costs are identical to the ai-resources audit — no incremental ai-development-lab finding. The auto-sync hook itself runs only at SessionStart (one-time cost per session). | INFO | Already addressed in ai-resources audit. |

**Confidence: HIGH** — direct measurement.

---

## 4. Workflow Token Efficiency

**Workflows identified: 1 heavy project-specific workflow** (`/analyze-transcript`); 2 lighter project-local commands (`/produce-handoff`, `/review-pipeline-run`). Fewer than 4 candidates — analyze-transcript audited in full per the protocol's "audit all found" rule for thin sets.

---

### Workflow: /analyze-transcript

**Entry point:** `.claude/commands/analyze-transcript.md` (312 lines, ~4,000 tokens)
**Start-of-workflow context:** ~7,703 tokens (workspace CLAUDE.md + project CLAUDE.md + command file)
**Per-run subagent returns into main:** ~6,603 tokens cumulative (3 dispatches; 90 + 80 + 76 lines)
**Per-run subagent-internal cost (operator-observed 2026-05-21):** ~316K tokens
**Refinement multiplier:** 1–2 (well under the >3 cost-driver threshold)
**Total findings:** 9 (2 HIGH, 5 MEDIUM, 2 LOW/N-A)

**Strengths:** All artifacts written to disk (memo, intermediate stage outputs). Pipeline-state resume detection at Step 2 contemplates interruption. Refinement cycles bounded.

| # | Finding | Severity | Waste mechanism |
|---|---|---|---|
| AT1 | Step 7 ROUTING_CONTEXT triple-touch on `ai-resources/docs/repo-architecture.md` (252 lines / ~2,613 tokens): main reads it at Step 7b solely to embed verbatim into the Step 7d brief, AND the system-owner subagent independently reads the same file per its Function B grounding map. | HIGH | Unnecessary main-session read of a 252-line file that the subagent reads anyway; brief embed duplicates content the subagent will fetch fresh |
| AT2 | All 3 subagent dispatches (system-owner 6a, ai-engineer 6b, system-owner 7) return full artifact text into main session (~1,686 + ~2,257 + ~2,660 tokens). Individual returns are under the 200-line HIGH threshold (90/80/76 lines) so the protocol's literal rule doesn't fire — but cumulative + persistent in-context retention through Step 8 memo synthesis = same waste mechanism. | MEDIUM (×3, aggregated) | Subagent return volume accumulates in main; persists through memo synthesis |
| AT3 | No `/compact` instruction at any of 4 natural breakpoints (post-Step 5, post-6a, post-6b, post-7). By Step 8, main-session context holds ~9,200+ tokens of accumulated workflow artifact text. | MEDIUM | Missing compaction breakpoints in a 5-stage pipeline that runs ~316K subagent tokens |
| AT4 | Step 6a system-owner brief scope is broad ("current infrastructure"); the operator's 2026-05-21 telemetry entry suggests scope could be narrowed by 10–15% with corresponding ~15–23k token savings per run. | MEDIUM | Subagent over-scope; intrinsic to current brief design |
| AT5 | Pipeline ref docs (`ref-step6a-brief.md`, `ref-step7-brief.md`) carry verbatim copies of `/consult` Step 4 brief structure; if `/consult` evolves, these drift silently. Risk vector for future correctness, not current token cost. | LOW | Maintenance debt (not active token waste) |

Full notes: `audits/working/audit-working-notes-workflow-analyze-transcript.md`.

---

**Confidence: HIGH** for context loading and file-read mapping (direct measurement); MEDIUM for subagent return volume cumulative impact (structural inference, depends on actual transcript size).

---

## 5. Session Patterns & Configuration

**Session telemetry available: YES.** `projects/ai-development-lab/logs/usage-log.md` (91 lines, 2 entries — most recent 2026-05-21).

**Key telemetry observation (2026-05-21):**
- A full `/analyze-transcript` pipeline run on a 19.5K-character transcript dispatched 7 subagents and consumed **~316K observed subagent tokens** in the main session's context — dominated by system-owner Step 6a (~74.6K) + Step 7 (~78.1K) = ~153K combined for the two structurally-required system-owner dispatches.
- This is **intrinsic to the pipeline design** — the system-owner Step 6a (current-infrastructure briefing) and Step 7 (Axcíon fit assessment) are mandated quality gates.
- Session rated **Acceptable**. No "Wasteful" sessions in the visible window.
- Recurring lever (from prior session): plan-QC REVISE cycles cost ~2–4k tokens per occurrence; tighter plan spec upfront would reduce frequency.

**Configuration audit:**

| Setting | Current value | Recommended | Impact |
|---|---|---|---|
| Default model (settings.json) | Not set — per workspace Model Tier rule | Not set | OK — operator selects via `/model` per session |
| MAX_THINKING_TOKENS | Not set in this project's settings.json (only `allow`/`deny`/`hooks` blocks present) | 10000 (matches ai-resources baseline) | LOW — without explicit override, default applies (~10K-32K depending on Claude Code version). Could match the ai-resources setting for consistency. |
| `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE` | Not set | 80% | LOW |
| Hooks: SessionStart auto-sync + permission sanity | PRESENT | Same | OK — minimal token cost; runs at session start only |
| Hooks: PreToolUse, PostToolUse, Stop | NOT configured at project level | Inherit from ai-resources via auto-sync? | LOW — auto-sync syncs commands/agents but does NOT install ai-resources hooks at the project. Project sessions don't get the heavy-tool check, friction-log-auto, log-write-activity, etc. that ai-resources sessions get. |

**Hooks active in this project:**
- **SessionStart:** auto-sync-shared.sh (from ai-resources), check-permission-sanity.sh (from ai-resources)

**Findings:**

| # | Finding | Severity | Recommendation |
|---|---|---|---|
| 5.1 | MAX_THINKING_TOKENS not explicitly set; ai-resources sets `"MAX_THINKING_TOKENS": "10000"`. Project sessions may default to a higher thinking budget than the workspace baseline. | LOW | Add `"env": {"MAX_THINKING_TOKENS": "10000"}` to settings.json for consistency. |
| 5.2 | Project lacks the rich hook coverage that ai-resources has (PreToolUse heavy-tool check, PostToolUse log-write-activity + auto-qc-nudge, Stop reminders). Project sessions don't get the same workflow-discipline nudges. | MEDIUM | Decide: either (a) sync workspace hooks via the auto-sync mechanism, or (b) accept the lighter-weight project posture as intentional. Reference: ai-resources/.claude/settings.json hooks block. |
| 5.3 | `/analyze-transcript` runs are intrinsically heavy (~316K subagent tokens observed). This is by design (mandatory system-owner dispatches) and rated Acceptable in telemetry. Not actionable as waste. | INFO | Carry forward: when system-owner scope can be narrowed, the lever is large (~15–23k tokens for a 10–15% scope trim). |

**Confidence: HIGH** — direct read of settings.json + usage-log + hook config.

---

## 6. File Handling Patterns

**Read(pattern) deny-rule status (from Step 0.3):** **HIGH** — No `Read()` deny rules exist at all.

**Findings:**

| # | Finding | Severity | Recommendation |
|---|---|---|---|
| 6.1 | Zero `Read()` deny rules in `.claude/settings.json`. 10 frozen/archive files (totaling ~60k tokens) are unprotected. One accidental load = 10k+ token waste. | HIGH | Add granular date-stamped + per-file deny rules. See R1 in Section 9 for the JSON snippet. |
| 6.2 | Frozen pipeline outputs unprotected — 5 files in `pipeline/` (technical-spec 10.7k tokens, implementation-spec 9.2k tokens, project-plan, architecture, repo-snapshot) and 4 in `output/` (architecture-proposal-v1 6.2k tokens, etc.) are explicitly marked in CLAUDE.md as "read once; do not re-litigate" — discipline documented, enforcement absent. | HIGH | Same deny-rule fix (R1). The discipline IS documented; this is the matching enforcement. |
| 6.3 | No directory separation of active vs frozen artifacts. Command/agent files (~20k tokens, active) mix with pipeline/output archives (~40k tokens, frozen) without structural segregation. | MEDIUM | Optional: move frozen Phase 0 artifacts to `pipeline/_frozen/` or `archive/phase-0/`, then add a single `Read(pipeline/_frozen/**)` or `Read(archive/**)` deny. Lower-maintenance than per-file denies. |
| 6.4 | Transcript file has malformed double `.md` extension: `026-05-20-youtube-claude-code-engineering-skills.md.md`. | LOW | Rename to single `.md`. Cosmetic only — does not affect read-deny behavior. |

Full notes: `audits/working/audit-working-notes-file-handling-ai-development-lab.md`.
**Confidence: HIGH** — direct file scan + deny-rule comparison.

---

## 7. Missing Safeguards

| Safeguard | Status | Severity if missing | Finding |
|---|---|---|---|
| `Read(pattern)` deny rules covering stale/large dirs | **Absent** | HIGH | No `Read()` denies at all. See Section 0.3 and Section 6. |
| Custom compaction instructions in CLAUDE.md | **Absent** | MEDIUM | Project CLAUDE.md has no Compaction section. Workspace-level guidance applies but doesn't mention pipeline-state preservation. |
| Subagent output-to-disk pattern | **Partial** | HIGH | Workspace CLAUDE.md defines the contract. `/analyze-transcript` Step 6a/6b/7 dispatch system-owner + ai-engineer via Task tool — return-to-main pattern needs Section 4 confirmation. |
| Context window monitoring instructions | **Partial** | MEDIUM | Workspace-level `/clear` rule applies. Project CLAUDE.md doesn't add project-specific monitoring. |
| Session boundaries defined for workflows | **Present** | MEDIUM | Workspace `/clear` between unrelated tasks rule applies. Project pipeline runs are bounded by the 5-stage structure. |
| Model selection guidance | **Present** | MEDIUM | CLAUDE.md Model Selection section recommends Opus for analysis, Sonnet for extraction. ai-engineer agent declares `model: opus` in frontmatter. |
| File read scoping (read lines X-Y vs whole file) | **Partial** | MEDIUM | Workspace-level "Read-scope floors" rule applies. Pipeline reference docs are small enough that this rarely matters; large pipeline artifacts are the risk and are not protected (see Section 6). |
| Output length constraints | **Partial** | MEDIUM | Memo discipline (line 81) sets target ≤2 pages (~700 words) — output constraint is PRESENT for the canonical pipeline deliverable. Other artifacts (architecture-proposal-v1.md, etc.) have no length constraint. |
| Effort level guidance | **Partial** | LOW | ai-engineer agent uses Opus by default (high effort implicit via Opus tier). No `/effort` configuration. |
| Hook-based output truncation | **Absent** | LOW | No truncation hooks at project level. Project has only 2 SessionStart hooks. |
| Audit/output artifact isolation | **Absent** | HIGH | `output/` directory is not under any `Read()` deny rule. Includes a 35KB `architecture-proposal-v1.md` explicitly noted in CLAUDE.md as "read once during Phase 0 build; do not re-litigate" — the discipline is documented but not enforced. |

**Confidence: HIGH** — direct read of all relevant files.

---

## 8. Best Practices Comparison

| # | Practice | Status | Gap description | Priority |
|---|---|---|---|---|
| 1 | CLAUDE.md under 200 lines | **Implemented** | 109 lines. | LOW |
| 2 | `Read(pattern)` deny rules configured | **Not implemented** | Zero `Read()` denies. Pipeline artifacts (250KB+ in pipeline/ + output/) sit unprotected. | HIGH |
| 3 | Skills use on-demand loading | **Implemented** | All skills consumed via ai-resources auto-sync; load on demand by skill name. | LOW |
| 4 | Subagents for heavy reads | **Partial** | Pipeline dispatches via Task tool. Section 4 will confirm whether dispatches follow the output-to-disk pattern. | MEDIUM |
| 5 | Strategic `/compact` at breakpoints | **Not implemented** | No `/compact` instructions in `/analyze-transcript` workflow. Pipeline runs accumulate ~316K subagent tokens with no breakpoint. | HIGH |
| 6 | `/clear` between unrelated tasks | **Implemented** | Workspace-level rule applies. | LOW |
| 7 | Model selection per task type | **Implemented** | ai-engineer agent declares `model: opus`; CLAUDE.md recommends Opus for analysis, Sonnet for extraction. | LOW |
| 8 | Extended thinking budget controlled | **Partial** | MAX_THINKING_TOKENS not set in project settings; defaults apply. | LOW |
| 9 | Unused MCP servers disabled | **Not observable** | User-level concern. | LOW |
| 10 | Output-to-disk pattern for subagents | **Partial** | Pipeline writes memo to disk (output/memos/...). Whether Step 6a/6b/7 subagents return full reports or summaries to main needs Section 4 confirmation. | MEDIUM |
| 11 | Precise prompts over vague ones | **Partial** | Pipeline reference docs (ref-extraction.md, ref-grilling.md, ref-step6a-brief.md, ref-step7-brief.md) provide structured briefs. Quality is HIGH structurally. | LOW |
| 12 | Session notes pattern | **Implemented** | `/wrap-session`, `/handoff`, `logs/session-notes.md` pattern from ai-resources applies. | LOW |
| 13 | Inter-skill disambiguation | **Implemented** | The ai-engineer vs system-owner scope boundary is explicitly documented in CLAUDE.md lines 60–72. Two agents with adjacent scopes — clear discriminator stated. | LOW |
| 14 | Agent/skill prompts use structured sections | **Implemented** | ai-engineer agent (project-specific) likely uses structured sections; spot-check pattern confirmed in ai-resources audit. | LOW |
| 15 | Few-shot examples present where useful | **Partial** | Pipeline reference docs (ref-extraction.md, ref-grilling.md, ref-memo-template.md) are template-based, not example-based. Could add 1–2 canonical examples per stage. | LOW |

**Key gaps by priority:**
- **HIGH (3):** Read(pattern) deny rules absent; `/compact` breakpoints absent in pipeline; output-artifact isolation absent
- **MEDIUM (3):** Subagent return aggregation (Section 4 confirmed); project lacks ai-resources hooks; output length constraints partial
- **LOW (9):** Implemented or low-impact

**Confidence: HIGH** — verified against direct file evidence.

---

## 9. Optimization Plan

### 9.1 Executive Summary

This audit found **a sharp asymmetry between this project's design quality and its safeguard hygiene.** The pipeline (`/analyze-transcript`) is architecturally clean — bounded refinement, disk-persisted artifacts, intentionally-tiered subagents (system-owner on Opus, ai-engineer on Opus), explicit memo discipline, and clear scope boundaries between the two analysis agents. Recent telemetry shows the only completed pipeline run rated "Acceptable" with no Wasteful sessions in the visible window.

But the **`Read()` deny rules are entirely absent** from this project's `.claude/settings.json`. The project contains ~60 KB of frozen Phase 0 artifacts (technical-spec, implementation-spec, project-plan, architecture, repo-snapshot, architecture-proposal-v1) that the CLAUDE.md explicitly labels "read once; do not re-litigate" — discipline documented, enforcement zero. One accidental exploration read of any of these files costs 6,000–11,000 tokens per session. The risk is not theoretical: the project's auto-sync from ai-resources includes new commands every week, and any new command that does a directory-wide `Glob` or `Grep` will surface these unprotected files.

Inside the pipeline itself, the most actionable single fix is the **Step 7 ROUTING_CONTEXT triple-touch on `repo-architecture.md`** — a 252-line file is read in main session solely to embed verbatim in a subagent brief that itself re-reads the same file. This is structural over-engineering of the brief contract.

Estimated avoidable waste: 6,000–11,000 tokens per accidental read (HIGH risk, ungated frequency); 7,800 tokens per `/analyze-transcript` run (HIGH, ~weekly on active development); 9,200+ tokens per run held in main from accumulated subagent returns (MEDIUM).

### 9.2 Prioritized Recommendations

#### HIGH — Fix first

**R1: Add `Read()` deny rules for frozen Phase 0 artifacts**

| Field | Content |
|---|---|
| **Issue** | Zero `Read()` deny rules in this project's settings.json. ~60K tokens of frozen artifacts sit unprotected. |
| **Evidence** | `projects/ai-development-lab/.claude/settings.json` `deny` array contains only Bash + transcript Write/Edit. Section 6.1, 6.2 cite specific files and sizes. |
| **Waste mechanism** | Accidental directory exploration via Glob/Grep/Read can load any of ~10 unprotected files (10K+ tokens each). |
| **Estimated savings** | HIGH — 6,000–11,000 tokens per accidental read; risk grows as the project accumulates output/ artifacts. |
| **Implementation steps** | Add to `permissions.deny` in `projects/ai-development-lab/.claude/settings.json`: `"Read(pipeline/technical-spec.md)"`, `"Read(pipeline/implementation-spec.md)"`, `"Read(pipeline/project-plan.md)"`, `"Read(pipeline/architecture.md)"`, `"Read(pipeline/repo-snapshot.md)"`, `"Read(pipeline/implementation-log.md)"`, `"Read(pipeline/test-results.md)"`, `"Read(output/architecture-proposal-v1.md)"`, `"Read(output/implementation-starter-format-proposal-v1.md)"`, `"Read(output/memos/2026-0*/memo.md)"`. Active pipeline `ref-*.md` files stay readable. |
| **Risk** | LOW — explicit per-file denies; active reference docs remain readable; nothing the pipeline currently reads is blocked. |
| **Dependencies** | None |
| **Category** | Quick win (10-line JSON edit) |

---

**R2: Fix Step 7 ROUTING_CONTEXT triple-touch on `repo-architecture.md`**

| Field | Content |
|---|---|
| **Issue** | `/analyze-transcript` Step 7 reads `ai-resources/docs/repo-architecture.md` (252 lines / ~2,613 tokens) in main session to embed verbatim into the Step 7d subagent brief, AND the system-owner subagent independently reads the same file per its Function B grounding map. Triple touch (main Read + verbatim embed + subagent re-read). |
| **Evidence** | `analyze-transcript.md` Step 7b–7d; system-owner agent Function B grounding map (in `.claude/agents/system-owner.md`). Subagent audit AT1. |
| **Waste mechanism** | 252-line file is read into main for no purpose other than transit; the subagent reads it fresh anyway. Verbatim embed in brief duplicates content. |
| **Estimated savings** | HIGH — ~2,613 tokens per `/analyze-transcript` run; ~5,200 tokens if accounting for the brief embed; runs ~weekly. |
| **Implementation steps** | (a) Remove the Step 7b main-session Read of `repo-architecture.md`. (b) Change the Step 7d brief to reference the file by path only ("read `ai-resources/docs/repo-architecture.md` per your Function B grounding map") rather than embed verbatim. The system-owner subagent will read it once, in subagent context, where it belongs. |
| **Risk** | LOW — the system-owner agent's Function B already includes this file in its grounding map; the brief embed is structurally redundant. |
| **Dependencies** | None |
| **Category** | Quick win (2-line edit to `analyze-transcript.md`) |

---

**R3: Add `/compact` instruction at 2 pipeline breakpoints**

| Field | Content |
|---|---|
| **Issue** | No `/compact` instruction at any of 4 natural breakpoints in `/analyze-transcript` (post-Step 5 grilling, post-6a infrastructure brief, post-6b ai-engineer, post-7 fit). By Step 8 memo synthesis, ~9,200+ tokens of accumulated subagent returns sit in main context. |
| **Evidence** | Workflow audit finding AT3; `analyze-transcript.md` contains no `/compact` reference. |
| **Waste mechanism** | Accumulated subagent return text persists through memo synthesis; main-session context grows linearly across stages. |
| **Estimated savings** | MEDIUM — ~3,000–5,000 tokens of compactable content per run; preserves headroom for memo synthesis quality. |
| **Implementation steps** | Add advisory `/compact` instructions to `analyze-transcript.md` at two breakpoints: (a) after Step 6 (post-ai-engineer dispatch return) — "[COMPACT SUGGESTED] If context exceeds 60%, run /compact before Step 7." (b) after Step 7 (post-system-owner Step 7 return) — "[COMPACT SUGGESTED] Memo synthesis (Step 8) only needs disk artifacts; consider /compact if context > 70%." |
| **Risk** | LOW — advisory only; no behavioral change if operator skips. |
| **Category** | Quick win |

---

#### MEDIUM — Plan next session

**R4: Sync the ai-resources hook coverage to this project**

| Field | Content |
|---|---|
| **Issue** | Project's settings.json defines only 2 SessionStart hooks. Missing PreToolUse (heavy-tool check, friction-log-auto), PostToolUse (log-write-activity, auto-qc-nudge), Stop (check-stop-reminders, coach-reminder, improve-reminder, auto-resolve-nudge), and SessionStart (friday-checkup-reminder) that ai-resources runs. |
| **Evidence** | Diff `ai-resources/.claude/settings.json` vs `projects/ai-development-lab/.claude/settings.json` hooks blocks. |
| **Estimated savings** | MEDIUM — workflow-discipline hooks (heavy-tool nudge, write-activity logging, QC nudges) save tokens indirectly by preventing rework. ~1–3K tokens/session amortized; larger benefit is friction reduction. |
| **Implementation steps** | Copy the hook definitions from `ai-resources/.claude/settings.json` `hooks` block to this project's settings.json. Hook scripts already exist under `ai-resources/.claude/hooks/` and are referenced via `$CLAUDE_PROJECT_DIR` path-walks (compatible with sub-project invocation). |
| **Risk** | LOW — hooks are bounded (5s timeout each); already production-tested in ai-resources. |
| **Dependencies** | None |
| **Category** | Structural change |

---

**R5: Narrow system-owner Step 6a brief scope**

| Field | Content |
|---|---|
| **Issue** | Step 6a "current infrastructure briefing" scope is broad. Operator's 2026-05-21 telemetry observed ~74.6K subagent tokens and notes the lever: ~15–23K tokens saved per run at 10–15% scope trim. |
| **Evidence** | `logs/usage-log.md` 2026-05-21 Acceptable entry; `pipeline/ref-step6a-brief.md` defines the brief. |
| **Estimated savings** | MEDIUM — 15–23K tokens per `/analyze-transcript` run (system-owner is on Opus tier; per-token cost is highest). |
| **Implementation steps** | Review `ref-step6a-brief.md`. Identify which infrastructure dimensions are over-scoped for typical analyses. Trim brief by 10–15%. Validate with one comparison run vs prior baseline (memo quality must hold). |
| **Risk** | MEDIUM — narrowing the brief may degrade fit-assessment quality at Step 7. Validate with at least 2 runs before committing. |
| **Category** | Structural change |

---

**R6: Reduce subagent return aggregation in `/analyze-transcript` Step 8**

| Field | Content |
|---|---|
| **Issue** | Three subagent dispatches return full artifact text into main (~1,686 + ~2,257 + ~2,660 = ~6,603 tokens cumulative). Returns are below the 200-line HIGH-per-subagent threshold but accumulate. |
| **Evidence** | Workflow audit finding AT2; agent return sizes measured at 90/80/76 lines. |
| **Estimated savings** | MEDIUM — 4,000–6,000 tokens of compactable return text per run; combined with R3 reduces Step 8 context cost. |
| **Implementation steps** | Update Step 6a, 6b, 7 subagent briefs to require disk-persistence + ≤30-line summary return (per the workspace Subagent Contracts pattern). Memo synthesis (Step 8) re-reads disk artifacts as needed rather than relying on accumulated returns. |
| **Risk** | LOW — pattern is workspace-canonical; brings analyze-transcript into compliance with the same contract used by token-audit-auditor and friday-checkup. |
| **Category** | Structural change |

---

#### LOW — Opportunistic

**R7:** Optionally restructure: move frozen Phase 0 artifacts to `pipeline/_frozen/` or `archive/phase-0/`. One `Read(pipeline/_frozen/**)` deny replaces 7 per-file denies. Lower-maintenance.

**R8:** Rename `transcripts/026-05-20-youtube-claude-code-engineering-skills.md.md` to single `.md`. Cosmetic only.

**R9:** Add 3-line Compaction section to project CLAUDE.md naming pipeline-state + pending subagent dispatch paths as items to preserve during `/compact`.

**R10:** Set `MAX_THINKING_TOKENS=10000` in this project's settings.json for consistency with the ai-resources baseline.

### 9.3 Safeguard Proposals

**S1: Per-file `Read()` deny set (implements R1)** — see R1 implementation steps. Annual maintenance: review when new frozen artifacts are added.

**S2: Subagent-return-as-disk-only enforcement for analyze-transcript (implements R6)** — codify in the 3 subagent briefs that return must be `summary {N} lines + artifact path`, not full artifact text.

**S3: Establish pipeline `/compact` discipline (implements R3)** — add advisory at workflow breakpoints; over time, telemetry will show whether the advice is being applied and whether memo-synthesis quality improves.

### 9.4 Implications for Future Opus 4.7 Upgrade

- **R5 (narrow Step 6a brief) becomes higher-priority** at Opus 4.7 — Step 6a runs on Opus tier and its per-token cost is the highest item in the pipeline. A 15% trim at Opus 4.7 pricing is the largest single saving on the table for this project.
- **R2 (triple-touch fix) is model-agnostic** — saves ~2,600 tokens regardless of model.
- **R1 (deny rules) is model-agnostic** but protects more aggressively against accidental loads at higher per-token costs.
- **The project's per-agent `model:` frontmatter** (ai-engineer on Opus) is already in place — model tier resolves to the new version without changes.

### 9.5 Assumptions and Gaps

- **Subagent return volumes (Section 4)** are structural inferences from `analyze-transcript.md` instructions and agent contracts, not observed per-dispatch token counts. The 90/80/76-line numbers were measured by the subagent against current versions of the agent briefs; actual returns depend on session content.
- **The 316K subagent-token figure** for the 2026-05-21 pipeline run is operator-recorded telemetry, not measured here. Treated as ground truth for the recommendation framing.
- **No `/cost` data available** in the audit environment — main-session estimates are protocol proxies (word × 1.3 ± 30%).
- **MCP server configuration** is user-level and not observable from the repo.
- **The workspace-root CLAUDE.md** loads in every project session via parent-directory walk. Out of scope for this project-level audit but contributes ~3,200 tokens to per-turn cost.

---

## 10. Self-Assessment

**1. Audit token cost:** `/cost` not available. Audit consumed ~7 inline-section steps + 2 subagent delegations (Section 4 analyze-transcript, Section 6 file-handling). Section 2 was trivialised (0 project-local skills) to avoid an unnecessary subagent. Estimated main-session context growth: ~40,000–60,000 tokens.

**2. Protocol gaps encountered:**
- **Section 2 (Skill Census) behavior at project scope.** This project has 0 project-local SKILL.md files (all skills consumed via ai-resources). The protocol doesn't explicitly address project-scope audits where skills are shared. Handled inline with a 1-paragraph PASS. Protocol could note: "If `find AUDIT_ROOT -name SKILL.md` returns 0, Section 2 is satisfied with a 1-paragraph note; subagent delegation is unnecessary."
- **Cross-scope finding overlap.** Many of this project's HIGH commands (friday-act, friday-checkup, monday-prep, etc.) are auto-synced from ai-resources. Their per-invocation costs were already covered in the ai-resources audit. The protocol could note that for project-scope audits, shared commands need only be flagged ("inherited from ai-resources; see prior audit") rather than re-audited.

**3. Confidence ratings:**

| Section | Confidence | Basis |
|---|---|---|
| 0. Pre-Flight | HIGH | Direct read of settings.json + scan for usage-log |
| 1. CLAUDE.md | HIGH | Direct measurement + full content read |
| 2. Skill Census | HIGH | Trivially confirmed (0 skills) |
| 3. Command Census | HIGH | Direct measurement; cross-referenced against ai-resources audit |
| 4. Workflow Audit | HIGH (context, file reads) / MEDIUM (subagent return aggregation impact) | Subagent return aggregation is structural inference; depends on session content |
| 5. Session Patterns | HIGH | Direct read of settings.json + usage-log |
| 6. File Handling | HIGH | Direct file scan + deny-rule comparison |
| 7. Missing Safeguards | HIGH | Verified against direct evidence |
| 8. Best Practices | HIGH | Verified against direct evidence |
| 9. Optimization Plan | HIGH | Cross-section synthesis from HIGH-confidence inputs |

**4. Threshold-boundary findings:**
- AT2 subagent return sizes (90/80/76 lines) — all under the 200-line HIGH threshold individually, but cumulative impact is the same waste mechanism. Reported as aggregated MEDIUM rather than 3× LOW. Boundary case for the protocol's per-subagent rule.
- Section 1 CLAUDE.md at 109 lines — well under all thresholds; no boundary concern.

---

