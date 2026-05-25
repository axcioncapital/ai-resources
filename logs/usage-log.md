# Usage Log

<!-- entries below -->

### 2026-05-25 | Acceptable

**Task:** Item 8 Sequencing Session 2 — extracted canonical project settings + CLAUDE.md sections from inline `/new-project` literals into shared `ai-resources/templates/`, rewired `/new-project` to consume them, aligned research-workflow CLAUDE.md, and updated architecture map. 5 commits shipped after plan-time PROCEED-WITH-CAUTION → end-time GO.

| Metric | Value |
|--------|-------|
| Exchanges | ~15 |
| Files read | ~15 (re-reads: 4 files re-read; session-notes.md ×4, improvement-log.md ×3, new-project.md ×5+ overlapping sections, decisions.md ×2, usage-log.md ×2) |
| Files written/edited | 7 created + 5 modified + logs/reports = ~15 write targets |
| Tool calls | ~80-90 |
| Subagents | 4 (risk-check-reviewer ×2, system-owner, qc-reviewer) |
| Rework cycles | 3 (1 substantive QC-driven revision; 2 concurrent-modification re-read cycles) |

**Findings:**
- `.claude/commands/new-project.md` read 5+ times across overlapping sections with shifting line numbers after edits (Re-reads — Major). File is 698 lines; section reads accumulated to ~250-300 lines with substantial overlap.
- `logs/session-notes.md` read 4 times (prime tail, section locate, append-point tail, recheck tail) — R4 log-trio pre-fetch did not suppress the wrap-time append-point re-read (Re-reads — Moderate). Recurring pattern across multiple sessions.
- 3 rework cycles total: 1 substantive (bash substitution → python3 + mustache swap, including header.md rewrite) + 2 concurrent-session Edit/Write-after-modification cycles on session-plan.md and improvement-log.md (Rework — Moderate). Write-before-Read failure on session-plan.md now flagged in 5 of 6 recent sessions.
- `system-owner` advisory (~80 lines) returned in tool result AND appended verbatim to plan-time risk-check report via heredoc — load-bearing duplication, but architecturally justified (report needs to be self-contained on disk) (Tool overhead — Minor).
- Trend vs last 7 entries (6 Acceptable, 1 Efficient): stable Acceptable rating; concurrent-session interference is escalating (2 incidents this session vs typical 0-1) and session-plan.md Write-before-Read remains unresolved.

**Recommendation:** Pin `.claude/commands/new-project.md` content on first section read during multi-edit sessions, OR read the full file once upfront when planned edits span ≥3 sections — avoids the line-number-shift re-read cascade that drove this session's largest re-read cost.

**Estimated savings:** ~3,000-5,000 tokens per multi-edit command-file session. Derivation: 5+ overlapping section reads at avg ~80 lines each ≈ 400 lines re-read; collapsing to one upfront 698-line read + edits saves ~3 redundant section fetches (~240 lines × ~15 tokens/line ≈ 3,600 tokens). Multi-edit command-file sessions occur ~4-6×/month → ~15-30k tokens/month savings.

**Additional levers (ROI-ranked):**
- **Resolve session-plan.md Write-before-Read recurring failure (Highest ROI).** Estimate: ~1,500-2,500 tokens/session × 4-5 sessions/week = ~6-12k tokens/week. Bigger than primary because it fires nearly every session and the fix is structural (skill-level Read-before-Write enforcement in /session-plan), not behavioural.
- **Concurrent-session interference mitigation.** Estimate: ~1,000-2,000 tokens per incident × 1-2 incidents/session this week. Comparable to primary in single-session impact but harder to fix without harness-level locking; surface as friction-log entry rather than per-session lever.
- **session-notes.md wrap-time append-point re-read.** Estimate: ~200-400 tokens/session × every session = ~1-2k tokens/week. Smaller per-session than primary but extremely frequent; fix is teaching wrap-session to append via heredoc without re-reading append point (file is append-only by design).
- **subagent verbatim re-output of system-owner advisory.** Estimate: ~1,200 tokens this session, but architecturally justified (report-on-disk needs self-containment). Lower ROI — would need a different report structure (link instead of inline) and that trades convenience for tokens.

### 2026-05-25 | Acceptable

**Task:** Diagnostic backlog bundle session — stopped at R1 plan-time gate per operator (option 1) due to concurrent session collision; Wave 1.2 workspace innovation-registry committed (`5fc5da9`); Wave 1.1 + 1.3 found already-resolved [FADING-GATE]; R1 plan-time `/risk-check` + `/consult` second opinion produced PROCEED-WITH-CAUTION report committed (`724c27a`), R1 execution deferred.

| Metric | Value |
|--------|-------|
| Exchanges | ~8-10 |
| Files read | ~18 (re-reads: 0 — same-file reads were distinct ranges) |
| Files written/edited | 8 (1 wasted Write — session-plan.md superseded by concurrent session) |
| Tool calls | ~45-50 |
| Subagents | 2 (risk-check-reviewer + system-owner) |
| Rework cycles | 1 minor (concurrent-modification Edit retry) |

**Findings:**
- Concurrent-session write collision on `logs/session-plan.md` — file written by this session was immediately overwritten by the parallel Item 8 session, and an Edit on `logs/session-notes.md` failed mid-flight requiring re-Read + retry (Rework, Moderate). This is the same recurring pattern logged at friction-log 14:10 today; structural fix needed, not a per-session efficiency lever.
- Full-file Read on `skills/session-usage-analyzer/SKILL.md` (161 lines) consumed for this analysis is structurally required by the /usage-analysis spec (Context bloat, Minor — informational only).
- Trend vs last 3 entries: stability — Acceptable rating matches the prior 2 entries; R4 + R6 + R10 suppression of the historical re-read pattern continues to hold (re-reads = 0 again this session, matching the 2026-05-25 Efficient entry's pattern).

**Recommendation:** Resolve the `logs/session-plan.md` concurrent-write collision structurally — either per-session-ID plan filename (e.g., `session-plan-{timestamp}.md`) or a lock-file convention. This is the second consecutive session day where the single-file shared plan path caused wasted writes + Edit-retry rework, and it's already logged in friction-log. Per-session pathing eliminates the entire failure mode.

**Estimated savings:** ~800-1,500 tokens per affected session (1 wasted Write + 1 Edit retry round-trip + concurrent-modification recovery Read). Affects ~1-2 of every 10 sessions where parallel work runs — 10-20 session horizon: ~2,000-4,500 tokens saved, plus elimination of the cognitive overhead of detecting + recovering from the collision mid-mandate-write.

**Additional levers (ROI-ranked):**
- Plan-write deferral until after Assumptions-Gate passes — would have avoided the wasted `session-plan.md` Write here since the gate fired pre-mandate and the plan was already on disk. Saves ~1 Write per gated session (~300-500 tokens). Smaller than primary because it only addresses the symptom, not the underlying single-path collision.
- `docs/repo-architecture.md` full-Read (252 lines) for /consult routing — consider extracting a routing-only digest (first ~50 lines or a dedicated `repo-routing.md`) for /consult preflight. Saves ~150-200 lines per /consult invocation (~1,500-2,000 tokens). Smaller than primary in horizon terms because /consult fires less frequently than concurrent-session collisions.
- `.claude/agents/log-sweep-auditor.md` full-Read (184 lines) to verify FADING-GATE resolution — gate-verification could grep for the specific heuristic signature instead of reading the full agent. Saves ~150 lines per verification (~1,200-1,800 tokens). Smaller than primary because FADING-GATE checks are bounded by friday-checkup cadence (~1-2 per week).

### 2026-05-25 | Acceptable

**Task:** Three-item improvement-log fix session (Items A/E/F) per session-plan. Item A rewrote `permission-sweep-auditor` Step 4a with two-signal template-class detection and restored a regressed template file; Items E and F were caught as already-done by drift ([FADING-GATE]).

| Metric | Value |
|--------|-------|
| Exchanges | ~20 |
| Files read | ~17 (re-reads: 2 — `session-notes.md` 3-4×, `improvement-log.md` 3×) |
| Files written/edited | 9 |
| Tool calls | ~50 (Read ~15, Edit ~10, Write 1, Bash ~12, Skill ~6, Agent 3, TodoWrite 4) |
| Subagents | 3 (risk-check-reviewer, system-owner, qc-reviewer) |
| Rework cycles | 2 small (Write-without-Read on session-plan; unscoped Rule 14 add + revert) |

**Findings:**
- **Re-reads (Moderate):** `logs/improvement-log.md` read 3× across 3 sequential Edit calls (one per item annotation). A single Read + batched Edits would have saved 2 reads of ~135 lines each (~270 lines redundant).
- **Re-reads (Moderate):** `logs/session-notes.md` accessed 3-4× during /prime + session-start via tail/offset/line-count probes (~400 lines total accessed on a ~530-line file). Recurring pattern — flagged in 3 of the last 5 entries.
- **Tool overhead (Minor):** 3-4 separate `git log` calls investigating commit `0514590`; could have been one consolidated call with combined flags. Three permission-denied attempts on `improvement-log-archive.md` confirm QW1 deny rule is working but cost ~3 wasted Bash calls.
- **Rework (Minor):** Write-without-Read on `session-plan.md` (1 extra Read); unscoped Rule 14 row added then reverted (1 extra Edit). Both small, self-caught.
- **Trend:** Stable-to-improving vs last 3 entries — same `session-notes.md` re-read pattern persists (flagged 2026-05-22 Acceptable entry), but no major rework, no failed subagents, and the verify-first posture caught 2 of 3 items as [FADING-GATE] before edits were attempted — saving 1-2 hours of unnecessary work.

**Recommendation:** Batch `improvement-log.md` edits — Read once, perform all 3 Edits in sequence, then commit. The session-notes tail-read anti-pattern is already a standing recommendation across 3 prior entries; this session's contribution is the multi-Edit batching gap.

**Estimated savings:** ~2 redundant reads of `improvement-log.md` at ~135 lines each ≈ 270 lines ≈ ~1.5-2k tokens this session. The session-notes re-read pattern adds another ~3-4k (already counted in prior entries). Per-session: ~1.5-2k from the new batching lever. 10-20 session projection: 15-40k over the next month given improvement-log annotation work continues at current cadence.

**Additional levers (ROI-ranked):**
- **Session-notes tail-read fix** (~5k/session, 50-100k over 10-20 sessions) — bigger than primary because it fires every /prime + /wrap-session, not just multi-item edit days. Standing recommendation since 2026-05-22; not yet shipped.
- **Consolidated git-log investigation calls** (~500-800 tokens/session when commit forensics fires) — smaller than primary because forensics sessions are rare (1-in-5), but trivially fixable by passing `--all --oneline` + grep filters in one call.
- **[FADING-GATE] verify-before-edit posture** (negative-cost — saves entire item executions) — already applied this session for Items E and F. Generalize to: before any improvement-log item, read the actual target file first; if already-done, annotate-only. This session demonstrated the value; codifying it into session-plan stage instructions would compound across all future improvement-log sessions.

### 2026-05-22 | Wasteful

**Task:** Designed and built a manual session-issue investigation capability — extended `/resolve-repo-problem` with a new inline AUTO mode and `/friday-checkup` Step 6. Routed through /clarify → plan mode → QC ×2 → /risk-check → /consult, then descoped from 6 files to 2, implemented, committed, and wrapped.

| Metric | Value |
|--------|-------|
| Exchanges | ~17 |
| Files read | ~17 (re-reads: 4 — friday-checkup.md ×3, plan file ×2) |
| Files written/edited | ~11 |
| Tool calls | ~74 total |
| Subagents | 9 |
| Rework cycles | 2 major (descope, wrap-stage tail-read failures) |

**Findings:**
- Rework — Major: The full 6-file design was QC'd twice, risk-checked, and consulted, then 67% cut by operator decision. All evaluation effort on the 4 dropped files (new hook, settings.json, CLAUDE.md, session-guardrails.md) was wasted — approximately 2 QC subagents + 1 risk-check subagent + 1 consult subagent evaluated a design that did not ship.
- Rework — Major: Wrap-stage log files (session-notes.md ~453 lines, decisions.md ~392 lines, coaching-data.md ~482 lines) were first read via Bash `tail`, which does not satisfy Edit's read-first gate, forcing 3 full Read-tool re-reads (~1327 lines total) before the Edit calls could proceed. This is the same pattern flagged in the majority of prior log entries; it has not been resolved.
- Re-reads — Moderate: friday-checkup.md read 3× at different offsets (grep scan + two partial ranges). Could have been resolved in a single targeted read.
- Context bloat — Moderate: Three large wrap-stage log files read in full (session-notes.md, decisions.md, coaching-data.md — ~1327 lines combined) when only append-point location was needed; targeted offset reads at the file END would suffice.

**Regression vs prior 3 entries:** This session is a clear regression — the prior 3 entries are all Acceptable; this session hits two Major findings, both from patterns that have been flagged repeatedly across the full log without resolution.

**Recommendation:** Fix the wrap-stage tail-read anti-pattern at the source: the wrap-session skill or command must explicitly instruct the agent to use the Read tool (not Bash tail) on log files before editing them, and to use `offset` to read only the last ~50 lines rather than full files. This single fix eliminates the 3-full-read forced-retry cycle (~1327 lines wasted per session) and is the same recommendation that has appeared in multiple prior entries without being actioned.

**Estimated savings:** ~1,300–1,400 tokens per session avoided by replacing 3 full re-reads with 3 offset reads. Over 10–20 sessions: ~13,000–28,000 tokens. Estimate is conservative — it covers only the forced re-reads, not the original tail calls themselves.

**Additional levers (ROI-ranked):**
- **Scope-gate before full QC pipeline** — When a design spans many files, run a lightweight feasibility or scope check (operator confirm or single-question clarify) before committing to QC ×2 + risk-check + consult. In this session, ~4 subagent invocations evaluated files that were ultimately dropped; blocking that work upstream saves the largest variable cost per session. Rough saving: 4 subagent round-trips ≈ 2,000–5,000 tokens per occurrence; higher ROI than the wrap-fix when scope reversals occur.
- **friday-checkup.md multi-read consolidation** — Read once with a sufficient window rather than three separate scans. Saving: ~200–400 tokens per occurrence; smaller than wrap-fix but zero-effort to implement via a single read call.
- **Subagent advisory de-duplication** — The /consult advisory (~60 lines) was returned in the tool result AND re-written verbatim into the risk-check report file. If the spec mandates the write, pass only a file-path reference back to the main session rather than re-emitting the full text. Saving: ~60 lines × ~1.5 tokens ≈ ~90 tokens per occurrence; informational, lowest ROI of the four levers.

### 2026-05-22 | Acceptable

**Task:** Rewrote the `/prime` command into a slim, scannable brief ending in a 1–3 task menu with number-invoke chaining and a plan-mode guard. Scoped via `/clarify`, planned in plan mode, QC'd twice (plan + implementation).

| Metric | Value |
|--------|-------|
| Exchanges | ~8 |
| Files read | 11 (re-reads: 1 file ×3) |
| Files written/edited | 6 |
| Tool calls | ~45 |
| Subagents | 4 |
| Rework cycles | 2 |

**Findings:**
- Re-reads (Moderate): `session-notes.md` (~392 lines) read 3×. The first read used offset 1 / limit 5, which hit the file START — but the wrap append point is at the END. That forced a full ~392-line re-read, then a ~120-line tail re-read after a concurrent-session edit. ~512 lines of content streamed across the 3 reads. This is the dominant historical pattern in the log (tail-then-full / repeated offset scans on `session-notes.md`).
- Tool overhead (Minor): 1 wasted Edit on `session-notes.md` from a concurrent `/open-items` session modifying the file mid-wrap, plus 1 recovery re-read — collision cost, not a process flaw.
- Rework: 2 QC→fix cycles (plan REVISE → 4 fixes; implementation REVISE → 1 fix). Both expected QC discipline, not waste.
- Trend: stable vs the last 3 entries — two Acceptable, one Efficient; the `session-notes.md` re-read recurs again here, consistent with the broader log's dominant pattern rather than an improvement or regression.

**Recommendation:** Fix the wrap-step `session-notes.md` read to target the file END directly — use a negative-offset / tail read (or a length probe then offset = total − N) instead of offset 1. This eliminates the START-miss that forces the full ~392-line re-read every wrap.

**Estimated savings:** ~390 lines (~5K tokens) per wrap session by replacing the full re-read with a single ~120-line tail read. Across 10–20 sessions: ~50K–100K tokens. Derivation: full 392-line read avoided; ~120-line tail read retained.

**Additional levers (ROI-ranked):**
- Read `session-notes.md` once at session start with a correct tail-targeted read and cache the append point — avoids both the wrap re-read and any mid-session re-scan. ~5–8K tokens/session; bigger than primary because it also covers non-wrap re-scans, but requires the append point to stay valid across the session.
- Concurrency guard on the wrap edit: detect `session-notes.md` mtime change before the Edit and re-read only the tail delta, not the whole file. ~1–2K tokens/collision; smaller than primary because collisions are intermittent, not every session.
- Bound the largest pure inputs: `usage-log.md` (~558 lines) and `decisions.md` (~356 lines) are read in full but only appended-to / scanned — tail or section reads would trim ~3–4K tokens/session; smaller than primary because they are single reads, not repeated ones.

### 2026-05-22 | Acceptable

**Task:** Executed the 5-item journal-commands `/friday-act` plan — added a "Between-gate summaries" rule to the workspace CLAUDE.md, a Stage 3b→3c Architecture Gate to `/new-project`, a Step 4a system-owner second-opinion to `/risk-check`, and created two advisory commands (`/drift-check`, `/resolve-repo-problem`); ran plan-time `/risk-check` and `/qc-pass`, then wrapped.

| Metric | Value |
|--------|-------|
| Exchanges | ~5 |
| Files read | ~9 (re-reads: 0) |
| Files written/edited | ~9 (3 edited, 4 created, 2 appended) |
| Tool calls | ~43 total |
| Subagents | 2 |
| Rework cycles | 1 |

**Findings:**
- **Rework — Moderate:** `/qc-pass` returned REVISE on the "skill (Skill tool)" invocation wording, forcing a re-edit of 2 command files and a follow-up commit (0a3beba). One cycle on a wording-class issue; the QC ran after the affected files were committed, so the fix landed as a separate correction commit rather than inline. Catchable upstream — "Run a wording self-check on tool-invocation phrasing before committing command files, or move `/qc-pass` ahead of the commit."
- **Context bloat — Minor:** `new-project.md` read at ~681 lines for an edit that touched one section and one wording region. The full read was justified by the Architecture Gate insertion needing surrounding-stage context, but it dominated the read budget; partial section-scoped reads suffice when the insertion point is already known.
- **Tool overhead — Minor:** ~13 Bash calls on a 5-item edit-and-commit session — driven by EOF-safe `cat >>` appends and a mid-file header search forced by 3+ concurrent sessions writing `session-notes.md`. Concurrent-session-induced, not a design fault.
- Trend: stable vs. the last 3 entries (Acceptable / Efficient / Acceptable) — same recurring class as the prior `/friday-act` entry today (a QC pass running after commit rather than inline, producing a correction commit). The session-notes re-read pattern flagged repeatedly this month did NOT recur here — reads were disciplined, no file read in full twice.

**Recommendation:** Run a wording-class self-check on tool-invocation phrasing (Skill / Agent / command references) before committing new or edited command files — the single REVISE this session was a phrasing issue a pre-commit self-check would have caught, converting a separate correction commit into a clean first commit.

**Estimated savings:** A post-commit wording correction costs the QC re-read of the 2 affected command files (~110 + ~107 lines ≈ ~3k tokens), the re-edits (~1k), and a second commit's overhead (~1k) — roughly 5k tokens per occurrence. If wording REVISEs recur on even 1-in-3 command-authoring sessions, that is ~1.5k/session amortized, or ~15–30k over a 10–20 session horizon — plus the avoided risk of imprecise invocation wording shipping in a new command.

**Additional levers (ROI-ranked):**
- Section-scope the `new-project.md` read when the insertion point is pre-identified — the ~681-line file was read in full for a 2-region edit; reading only the Stage 3b–3c neighborhood plus the target wording region saves ~500+ lines (~6–8k tokens) on every `/new-project` edit session. Larger than the primary because it is a deterministic per-edit-session saving, not a probabilistic rework avoidance.
- Pre-identify the `session-notes.md` append header once at `/prime` and pin it, so the wrap append does not require a mid-file header search under concurrent-session contention — ~1–2k/session. Smaller than the primary; concurrent-write contention is the real driver and pinning only partly mitigates it.

### 2026-05-22 | Acceptable

**Task:** Ran /prime then the full weekly-tier /friday-checkup across 9 scopes (ai-resources, workspace, 7 projects) — /audit-repo ×3, /improve ×3, /coach ×7, permission-sweep + log-sweep dry-runs, doc-scan, maintenance consolidation + /kb-integrity — then /wrap-session.

| Metric | Value |
|--------|-------|
| Exchanges | not reported |
| Files read | ~9 (re-reads: not reported) |
| Files written/edited | ~30+ |
| Tool calls | ~90 |
| Subagents | ~31 |
| Rework cycles | 3 |

**Findings:**
- **Rework — Major:** 3 rework instances on a multi-scope checkup — 2 collaboration-coach subagents failed on first invocation (path mis-resolution) and required re-runs (~62K + ~26K tokens spent on the failed attempts ≈ ~88K wasted), and findings-extractor over-escalated a MEDIUM finding to CRITICAL, forcing a main-session correction. The coach path failures are the dominant cost: "/coach subagent path mis-resolution required 2 re-runs — pin the resolved scope path in the coach dispatch brief so the worker does not re-resolve it."
- **Tool overhead — Moderate:** /audit-repo lead agents reported the Agent/Task tool unavailable in their environment and ran all 7 auditor checklists inline instead of via sub-auditors — a deviation from the designed sequential-subagent flow. Not waste in tokens directly, but it collapses the intended isolation boundary and concentrates context in the lead agents.
- **Context bloat — Minor:** ~31 subagents and ~30+ artifacts on a single session; scale is structural to a 9-scope weekly checkup, not a design fault, but it sits at the [COST] threshold and is the natural ceiling for this command.
- Trend: regression vs. the last 3 entries (Efficient / Wasteful / Acceptable) on the rework axis — the coach path mis-resolution is a new failure class not seen in the prior /friday-checkup entries this month, distinct from the recurring session-notes re-read pattern.

**Recommendation:** Pass the already-resolved absolute scope path into each collaboration-coach subagent's dispatch brief, so the worker consumes a verified path rather than re-resolving it — this eliminates the path mis-resolution class that cost 2 wasted subagent runs (~88K tokens) this session.

**Estimated savings:** 2 failed coach subagents ≈ ~62K + ~26K = ~88K tokens this session. At ~1 weekly /friday-checkup with a 7-scope coach fan-out, even a 1-in-3 recurrence rate projects ~290K–590K tokens over 10–20 checkup sessions. Order-of-magnitude — the failed-attempt token figures are operator-reported, the recurrence rate is estimated.

**Additional levers (ROI-ranked):**
- Add a registered-subagent / tool-availability precheck before /audit-repo lead agents dispatch sub-auditors — if the Agent tool is unavailable the lead should know upfront rather than discovering it mid-run; saves the wasted dispatch attempts and makes the inline fallback a deliberate path (~5–10K tokens/checkup). Smaller than primary because the inline fallback still completed the work; it is a correctness/isolation fix more than a token fix.
- Tighten the findings-extractor severity rubric so MEDIUM findings cannot escalate to CRITICAL without an explicit trigger condition — eliminates the main-session correction round-trip (~2–4K tokens/checkup). Smaller than primary because it is a single sporadic misclassification, not a deterministic per-scope failure.
- Cache the log-trio (session-notes + decisions + usage-log) at /prime into one consolidated read and reuse at /wrap-session — recurring lever across all Friday-cluster sessions (~3–4K tokens/session). Lower ROI here because this checkup's re-read count was not reported, but the pattern is structural.

### 2026-05-22 | Efficient

**Task:** Ran /prime to orient the session (pulled repos, read session notes, decisions log, innovation registry, inbox, and working tree state), then ran /usage-analysis. No substantive edits or writes performed.

| Metric | Value |
|--------|-------|
| Exchanges | 2 |
| Files read | 4 (re-reads: 0) |
| Files written/edited | 0 |
| Tool calls | 9 |
| Subagents | 1 |
| Rework cycles | 0 |

**Findings:**
None — session was efficient. The heaviest read (usage-log.md, ~451 lines) was required by the skill spec and cannot be avoided. All other reads were proportionate to the orientation task. Compared to the last 3 entries (all Acceptable), this session represents an improvement — the minimal scope of a prime-only session naturally eliminates the waste categories that recurred in heavier sessions.

**Recommendation:** No action needed.

**Estimated savings:** N/A — no recommendation.

**Additional levers (ROI-ranked):**
No additional levers — session was efficient.

### 2026-05-16 | Wasteful

**Task:** Ran /prime then full /cleanup-worktree workflow over ai-resources working tree. Investigation found 9 dirty paths (7 untracked audit/report artifacts after operator committed 2 modified files externally mid-flow); produced 8-section plan, 1st QC + triage + MINOR-1 revision, operator-inserted /qc-pass (GO), then 2 topical commits.

| Metric | Value |
|--------|-------|
| Exchanges | ~10 |
| Files read | ~20 (re-reads: 7 — session-notes.md ×3, decisions.md ×4) |
| Files written/edited | 4 (plan + 2 logs + coaching-data) |
| Tool calls | ~59 |
| Subagents | 3 (qc-reviewer ×2 + triage-reviewer ×1) |
| Rework cycles | 3 (plan v1→v2; 2 Edit-before-Read failures; mid-flow tree drift re-orient) |

**Findings:**
- Re-reads — Major (3 subagents each independently re-read all 7 dirty files ≈ ~800 lines × 3 = ~2,400 duplicate lines; the operator-inserted /qc-pass on revised plan duplicated the in-plan-mode 1st QC nearly verbatim)
- Re-reads — Moderate (session-notes.md ×3, decisions.md ×4 — Bash tail then Read-before-Edit recurrence of 2026-05-11 pattern)
- Rework — Moderate (Edit's read-first gate failed twice because Bash tail does not satisfy it; mid-flow working-tree drift forced plan §2 re-orientation)
- Tool overhead — Minor (TodoWrite ×5 incremental ticks; ExitPlanMode ×2 with one rejection)
- Trend: regression vs. last 3 entries (2 Acceptable + 1 Efficient); re-read pattern on session-notes/decisions persists for 3rd consecutive wasteful occurrence.

**Recommendation:** Add a "QC re-read budget" to /cleanup-worktree — pass the already-investigated file contents (or a path-keyed digest) into the qc-reviewer + triage-reviewer + post-revision /qc-pass via the plan body itself, so subagents review the plan against the digest rather than independently re-reading all dirty files each pass.

**Estimated savings:** ~2,400 lines of duplicate dirty-file reads across 3 subagents ≈ ~20-30k tokens this session. Over 10-20 cleanup-worktree sessions: ~200-600k tokens. Order-of-magnitude.

**Additional levers (ROI-ranked):**
- Skip operator-inserted /qc-pass when in-plan-mode 1st QC + triage already passed with MINOR-only verdict on a quick-tier plan — saves a full qc-reviewer subagent (~10-15k tokens/session); larger than session-log re-read fix because it eliminates an entire subagent invocation, not just file reads.
- Cache session-notes.md + decisions.md tail at session open into a single Read call, reuse at wrap — saves ~3-5k tokens/session; smaller than primary because per-file lines are short, but this is now a 4th-recurrence structural pattern and worth a /prime-level fix.
- Prefer Read over Bash tail when an Edit is anticipated downstream — eliminates the 2 wasted Edit-before-Read failures (~1-2k tokens/session); smallest of the three but the cheapest to fix (single rule in CLAUDE.md or skill preamble).

### 2026-05-16 | Acceptable

**Task:** Proposed, QC'd, and executed a 6-item improvement-log sprint targeting recurring friction in session infrastructure (prime, session-start, session-plan, monday-prep, consult, friday-act + workspace CLAUDE.md). Each item: read → edit → pre-commit /qc-pass → commit.

| Metric | Value |
|--------|-------|
| Exchanges | ~32 |
| Files read | 18 (re-reads: 1) |
| Files written/edited | 13 |
| Tool calls | ~63 |
| Subagents | 11 |
| Rework cycles | 2 (session plan only) |

**Findings:**
- **Rework — Moderate:** Session plan required 2 QC REVISE cycles before approval (friday-so.md conditional underspecified, item #4 new file underspecified, QC sequencing inverted, item #6 commit boundary unclear). Catchable at draft time with a tighter plan-authoring checklist.
- **Re-reads — Minor:** `decisions.md` read twice (~140 lines total) at different offsets to find append point; tail read at wrap start would have sufficed.
- **Tool overhead — Minor:** `prime.md` received 3 sequential Edit calls where the symbol fix could have been bundled with prior edits had it been caught at draft time.

**Recommendation:** Add a plan-draft self-check pass before invoking the first /qc-pass — specifically targeting the four recurring REVISE triggers (conditional underspecification, new-file scope, QC sequencing, commit boundary clarity). Would have eliminated 1 of 2 REVISE cycles here.

**Estimated savings:** ~3-5K tokens per session where session plan needs REVISE (one fewer plan-QC round = subagent + plan re-read + diff edit). At ~1 multi-item plan session/week: ~30-50K tokens over 10 sessions, ~60-100K over 20 sessions.

**Additional levers (ROI-ranked):**
- Cache `decisions.md` tail at session open (saves ~1 read/session ≈ 1-2K tokens, ~20-40K over 20 sessions)
- Bundle pre-commit Edit calls per file when multiple small fixes target the same file (~500-1K tokens per avoided Edit round-trip, ~10-20K over 20 sessions)

### TREND — 2026-04-21 to 2026-05-08

| Rating | Count |
|--------|-------|
| Efficient | 2 |
| Acceptable | 11 |
| Wasteful | 2 |

**Dominant pattern:** Re-reads on session-notes.md and small ledger files (decisions.md, innovation-registry.md, coaching-data.md) via tail-then-full or repeated offset scans — flagged in 12 of 15 entries, with no improvement by end of period.
**Trend direction:** Stable — ratings held Acceptable across most sessions with isolated Efficient and Wasteful spikes; the same re-read and /coach return-bloat patterns appeared at period start and end without resolution.
**Top recommendation:** Wire /collaboration-coach to write full analysis to a working-notes file on disk and return only a ≤20-line summary to the main session — appeared as primary recommendation in three separate entries and as a top-ranked additional lever in a fourth.


### 2026-05-16 | Wasteful

**Task:** Executed /friday-act Tier 1 + Tier 2 implementation from 7 plan files; pre-validated each target before editing, finding most items already resolved; net work included 12 commits, .gitignore additions, permission-template.md edits, SKILL.md frontmatter, settings normalizations, symlink fix, and session-plan writing with QC.

| Metric | Value |
|--------|-------|
| Exchanges | ~28 |
| Files read | ~22 unique (re-reads: 5 instances across 4 files) |
| Files written/edited | 14 |
| Tool calls | ~89 |
| Subagents | 2 |
| Rework cycles | 1 |

**Findings:**
- Re-reads (Major): session-notes.md read 3x (~415 lines each) — prime, session-start precondition check, wrap append-point; cumulative cost ~1,200 lines re-read on a single file
- Re-reads (Major): usage-log.md accessed 2x (~726 lines) — head for date-guard then full read for usage analysis; file exceeds 500-line threshold making this a major flag
- Re-reads (Moderate): permission-template.md read 2x (~300 lines) — source read then editing read
- Re-reads (Moderate): decisions.md read 2x (~124 lines) — prime context then wrap append-point
- Tool overhead (Moderate): permission-template.md edited in 3 separate Edit calls that could have been batched into 1–2 calls; pattern adds round-trip overhead without benefit
- Tool overhead (Moderate): TodoWrite called ~8 times for status updates across the session; most updates were incremental status ticks that could be collapsed to 2–3 checkpoints

**Recommendation:** Cache session-notes.md and decisions.md read results at session open into a single consolidated read, and reuse those cached values at wrap time without re-reading — eliminating the 3x session-notes and 2x decisions re-read patterns that have now recurred across at least three consecutive sessions.

**Estimated savings:** session-notes 3x re-read saves ~830 lines × 2 excess reads ≈ 1,660 lines; decisions 2x saves ~124 lines × 1 excess read ≈ 124 lines; usage-log 2x saves ~726 lines × 1 excess read ≈ 726 lines; combined per-session saving ≈ 2,500 lines (~3,500–5,000 tokens at mixed prose density). Over 10–20 sessions: 35,000–100,000 tokens.

**Additional levers (ROI-ranked):**
- Batch permission-template.md edits into a single Edit pass with all changes pre-planned — saves 1–2 round-trips per session that touches this file (~200–400 tokens each occurrence)
- Collapse TodoWrite status-tick calls from ~8 to 3 checkpoint updates (open, mid-session, close) — saves ~5 tool-call round-trips per session (~500–800 tokens)
- For usage-log.md date-guard check, read only the last 20 lines (tail offset) instead of head then full read — saves ~700 lines on the second access (~1,000 tokens)

### 2026-05-16 | Acceptable

**Task:** Off-schedule Saturday `/friday-checkup` (diagnostic-only) across 5 scopes; produced consolidated report with 22 follow-ups, 4 HIGH permission findings, 3 fresh coaching entries. No fixes applied.

| Metric | Value |
|--------|-------|
| Exchanges | ~14 |
| Files read | 11 unique (re-reads: 2 — session-notes x3, decisions x2) |
| Files written/edited | 12 |
| Tool calls | ~46 |
| Subagents | 11 |
| Rework cycles | 2 |

**Findings:**
- **Re-reads (Moderate):** session-notes.md read 3x (prime / session-start precondition / wrap append-point) — recurring pattern across multiple sessions; same file, same lines.
- **Rework (Moderate):** session-plan.md Write failed Read-before-Write gate — third recurrence of this exact failure in recent sessions (2026-05-11 log entries flagged the same pattern).
- **Rework (Moderate):** Agent call used unregistered subagent_type "repo-health-analyzer" before falling back to general-purpose — one wasted Agent invocation.
- **Missed parallelization (Moderate):** 2 repo-health-analyzer instances (ai-resources + nordic-pe-macro) ran sequentially; each internally spawns 7 sub-auditors so wall-clock cost was material. Coach (3x) and log-sweep (4x) were correctly parallelized — repo-health was the outlier.

**Recommendation:** Fix the recurring session-plan.md Read-before-Write failure at the harness level — add a pre-Write Read of session-plan.md to the `/session-plan` skill's preamble, OR convert the session-plan write to an Edit-with-fallback-to-Write pattern. Three identical failures in five sessions means model-side discipline isn't holding; it needs a structural fix.

**Estimated savings:** ~3 tool calls per recurrence (1 failed Write + 1 corrective Read + 1 retry Write → 1 Read + 1 Edit). At observed ~1 recurrence per 2 sessions, projected savings over 10–20 sessions: 15–30 tool calls + 5–10 operator-visible error states. Parallelizing the 2 repo-health-analyzer calls saves ~1 sequential wait per checkup (~10–15 min wall-clock per `/friday-checkup`); over 10–20 sessions at ~1 checkup per week, ~2–4 wall-clock hours.

**Additional levers (ROI-ranked):**
- Cache session-notes.md tail in main-session memory across prime → session-start → wrap (eliminates 2 of 3 reads per session; recurs every session).
- Add a registered-subagent-name precheck to Agent dispatch, OR rename the general-purpose call path so `repo-health-analyzer` resolves correctly — eliminates the retry class of waste entirely.
- Batch the two repo-health-analyzer Agent calls in a single message — one-line fix, immediate win on every multi-scope checkup.
- Consider tightening `/friday-checkup` to emit a single combined repo-health spawn for all named scopes rather than one per scope (architectural, lower ROI but eliminates the parallelization decision point).

### 2026-05-08 | Acceptable

**Task:** Built new `/friday-journal` command (~200 lines, model: opus, 7 steps) plus `logs/ai-journal.md` template, integrated into `/friday-act` via four edits (Steps 1.5/3/3.5/5 + Notes), and updated `weekly-cadence.md` and `operator-maintenance-cadence.md` (F3.5 rows). Plan-time and end-time `/risk-check` gates passed; committed as c3b1c15.

| Metric | Value |
|--------|-------|
| Exchanges | ~25 |
| Files read | ~12 (re-reads: 2 — friday-act.md ×2 across step edits, weekly-cadence.md ×2 plan→edit) |
| Files written/edited | 8 (4 created, 4 modified) |
| Tool calls | ~60 |
| Subagents | 5 (qc-reviewer ×3, risk-check-reviewer ×2) |
| Rework cycles | 3 (plan v1→v2 post-QC, plan v2→v3 post-QC, friday-journal.md v1→v2 post-QC) |

**Findings:**
- **Rework — Major:** Plan artifact required 2 QC REVISE cycles (v1→v2→v3) before ExitPlanMode approval; friday-journal.md required 1 QC REVISE cycle (variable rename JOURNAL_PATH→JOURNAL_SOURCE, entry-splitting clarification, same-day collision handling). 3 rework cycles total across 2 artifacts. Each REVISE surfaced real fixes, not arbitrary rejections, but the plan needing two passes suggests the v1 spec missed structural issues a tighter outline-first pass would have caught.
- **Tool overhead — Moderate:** Mid-session /fewer-permission-prompts diagnosis fired on unrelated permission-prompt friction — root-caused to deny-list in `ai-resources/.claude/settings.json`, logged to ai-journal.md, but did not fix this session. Pure context drift from main task; ~2–3k tokens spent on a tangential diagnosis logged for later /risk-check + remediation rather than executed in-flight or deferred entirely.
- **Re-reads — Minor:** friday-act.md read across 4 separate step-edit cycles (Steps 1.5/3/3.5/5 + Notes); weekly-cadence.md read at plan-time then again at edit-time. Tail-then-section pattern recurring.
- **Subagent volume — Acceptable:** 5 subagents (3 QC + 2 risk-check) is on-protocol — QC→Triage Auto-Loop convergence behavior, not waste. Both /risk-check gates fired correctly (plan-time PROCEED-WITH-CAUTION with 4 mitigations, end-time GO confirming mitigations applied).

Stable relative to last 3 entries (Wasteful 2026-05-08 / Acceptable 2026-05-05 / Acceptable 2026-05-01) — same Acceptable rating as the two pre-checkup sessions; the multi-cycle plan QC matches the rework pattern in 2026-05-05 (3 in-context plan revisions before disk write).

**Recommendation:** Before invoking the first /qc-pass on a plan artifact, run a self-check against the QC rubric (governance, commit-window, scope, structural completeness) — same lever flagged in 2026-04-21 and 2026-05-05 entries. Two plan REVISE cycles in this session each surfaced single-class structural issues a self-check would have caught upstream, converting two external QC subagent rounds into one.

**Estimated savings:** ~6–8k tokens per plan-heavy session by collapsing two QC REVISE cycles into one. Derivation: 1 avoided qc-reviewer subagent invocation (~3k brief + ~3–4k return) plus 1 avoided plan rewrite cycle (~150 lines × ~13 tokens/line ≈ 2k). Over 10–20 plan-heavy sessions: ~60–160k tokens. Recurring pattern flagged third session running.

**Additional levers (ROI-ranked):**
1. **Defer mid-session tangential diagnoses (~2–3k/session):** When an unrelated friction surface (here: permission prompts) fires during a substantive build, log it to a friction or journal file and resume — do not spawn a diagnostic command (/fewer-permission-prompts) inline. Saves the full diagnostic round-trip cost; smaller than primary because tangential firings are sporadic, not deterministic.
2. **Pin friday-act.md once before multi-step edits (~1.5–2k/session):** ~70-line command file read across 4 step-edit cycles instead of pinned after first full Read. Smaller than primary because individual Reads are cheap but the pattern recurs on every multi-step infra-command edit session.
3. **Outline-first plan drafting (~3–5k/session):** Same lever flagged in 2026-04-21 — write plan v1 to ~90% completeness with QC-anticipated structure (governance, commit-window, scope, mitigations) before first QC. Eliminates one full plan rewrite per QC REVISE; bigger than the per-file pin lever, smaller than the primary because primary captures both QC cycles' worth of avoidable cost.

### 2026-05-08b | Acceptable

**Task:** Implemented /friday-journal output-validation gate (Steps 5.4 + 5.5 in friday-journal.md) from an approved plan; updated qc-reviewer.md description; archived 32 ai-journal entries; ran gate as a catch-up on today's existing report (7 findings applied, 12 risk-check flags added); drafted 8-suggestion improvement spec for /friday-journal.

| Metric | Value |
|--------|-------|
| Exchanges | ~30 |
| Files read | ~10 (friday-journal.md ×2, qc-reviewer.md, ai-journal.md, friday-journal-2026-05-08.md, spec file, wrap logs) |
| Files written/edited | 7 (friday-journal.md, qc-reviewer.md, ai-journal.md, friday-journal-2026-05-08.md, improvement-spec, session-notes.md, decisions.md) |
| Tool calls | ~50 |
| Subagents | 2 (qc-reviewer: plan REVISE ×1, catch-up gate ×1) |
| Rework cycles | 1 (plan QC: REVISE → 6 fixes → operator approved) |

**Findings:**
- **Rework — Minor:** Plan received 1 QC REVISE with 6 items (rubric-override clarification, qc-reviewer contract, items_generated frontmatter field, r-disposition regex constraint, ls→Glob fix, heading-match set-equality). All were legitimate corrections; single-cycle convergence. Lower rework cost than the prior 2026-05-08 session (3 cycles across 2 artifacts).
- **Deliberate cost — Acceptable:** Catch-up gate run on already-generated report was operator-approved and proved value (12 risk-class flags caught that original generation missed). ~10 exchanges; expected for a non-routine catch-up.
- **Auto-compaction ×2:** Platform fired auto-compact twice during this session. Operator noted this in conversation. Not a session-efficiency issue — root cause is Claude Code's compaction threshold logic, not session design. Tracked as open question for investigation.
- **Improvement spec overhead — Minor:** 8-suggestion spec written at operator's explicit request. Per-suggestion analysis was thorough but produced a directly actionable artifact. Consistent with session scope.

**Recommendation:** No new pattern identified beyond those flagged in prior entries. The catch-up gate run was a one-time cost that surfaced real value; the auto-compaction issue warrants investigation as a platform-level concern.

**Estimated savings:** ~3–4k tokens/session by self-checking plans against QC rubric before first subagent QC invocation (recurring lever). No new session-specific lever identified.

---

### 2026-05-08c | Wasteful

**Task:** /friday-act Session 2 — dispositioned 43 items (12 checkup + 31 journal) from the 2026-05-08 friday-checkup and friday-journal reports into 15 fix-now / 35 defer / 1 skip. Produced 7 plan files under `audits/friday-plans/`.

| Metric | Value |
|--------|-------|
| Exchanges | ~45 |
| Files read | ~20 (re-reads: 4 — SO advisory ×2 under-read→full; improvement-log.md ×3 across 3 projects) |
| Files written/edited | 15 |
| Tool calls | ~84 (Read ×30, Edit ×20, Bash ×20, Write ×8, Agent ×6) |
| Subagents | 6 (qc-reviewer ×2, triage-reviewer ×3, memory-write ×1) |
| Rework cycles | 4 (session plan QC REVISE ×1; prioritization QC REVISE ×1; SO advisory under-read correction ×1; improvement-log under-read correction ×1) |

**Findings:**
- **Rework — Major (recurring):** 3 revision passes required — initial disposition, SO advisory full-read correction, improvement-log correction — compounded scope beyond initial plan. Two passes were operator-caught under-reads, not QC-surfaced. Pattern: partial read treated as sufficient when file required full read for coverage. Third session in current window with multi-cycle rework driven by incomplete initial reads.
- **Re-reads — Major:** SO advisory read twice (30-line under-read then full read after operator challenge); improvement-log.md read across 3 separate project directories sequentially. Under-reads that required full re-reads on large files (SO advisory est. >200 lines) represent the most costly re-read pattern in recent log history.
- **Context bloat — Moderate:** 43-item disposition processed across ~45 exchanges — largest /friday-act execution yet; auto-compact fired mid-session, indicating context ceiling was reached. Scale-driven bloat, partially structural (large input scope), partially addressable by batching plan file writes earlier.
- **Tool overhead — Minor:** 6 subagents for a disposition + plan-file session within normal range for this scope; memory-write subagent adds minor overhead but appropriate for cross-session persistence.

Regression from prior 2026-05-08 entries (Acceptable / Acceptable) — first Wasteful rating in the current Friday cluster. Two MAJOR findings from operator-caught under-reads and multi-cycle rework distinguish this from the prior Acceptable sessions today.

**Recommendation:** When a file is referenced in the input scope (SO advisory, improvement-log entries) and the disposition task requires evaluating its content, default to a full read on first access — not a 30-line or section-scoped read. The cost of an under-read correction (re-read + rework + operator friction) exceeds the cost of the avoided full read in every case logged this session.

**Estimated savings:** ~8–12k tokens per /friday-act session. Derivation: 2 under-read corrections × (full re-read ~200 lines × ~13 tokens/line ≈ 2.6k) + rework cycle per correction (~2 exchanges × ~1.5k tokens/exchange) ≈ ~10k tokens of avoidable cost. Over 10–20 /friday-act sessions: ~80–200k tokens.

**Additional levers (ROI-ranked):**
1. **Write plan files to disk earlier in large-disposition sessions (~5–8k tokens/session):** With 43 items across 7 plan files, plan content accumulated in-context before first disk write, contributing to auto-compact trigger. Writing plan files incrementally as each thematic group is dispositioned reduces peak context load.
2. **Batch improvement-log reads into one pass per project at session start (~2–3k tokens/session):** improvement-log.md across 3 project directories read sequentially mid-session. A single orchestrated read pass at disposition start avoids mid-session context re-entry overhead.
3. **Scope gate on /friday-act input size (~15k tokens/large-session):** 43-item input triggered auto-compact; prior /friday-act sessions handled 14 items (Acceptable). A scope gate splitting sessions >25 items into two sub-sessions would prevent auto-compact context loss and reduce per-session rework risk.

### 2026-05-08d | Wasteful

**Task:** Ran /session-plan + QC pass on the plan + /systems-review (Function E) on full AI infrastructure. Produced a systems-thinking diagnosis with 5 leverage points and a W2.4 weekly implementation roadmap.

| Metric | Value |
|--------|-------|
| Exchanges | ~15 |
| Files read | 15 (re-reads: 7 on session-notes.md, 2 on decisions.md, 2 on session-plan.md, 2 on coaching-data.md, 2 on improvement-log.md) |
| Files written/edited | 6 |
| Tool calls | ~39 total |
| Subagents | 3 |
| Rework cycles | 1 |

**Findings:**
- logs/session-notes.md read 7 times across the session — 5 reads at progressively larger offsets during /prime to locate the most recent entry, then 2 more during /wrap-session. This is a Major re-reads finding (3x+ on a file with repeated offset scanning). Fix: on /prime, read from a large offset first (e.g., last 100 lines via Bash tail) rather than scanning forward from offset 0. (Re-reads — Major)
- logs/session-plan.md Write failed on first attempt because the file had not been read first; required an extra Read then retry Write round-trip. (Rework — Moderate)
- Trend: The prior three sessions rated Acceptable, Acceptable, Wasteful — this session is also Wasteful, indicating no improvement on the re-read pattern that triggered the previous Wasteful rating.

**Recommendation:** Replace the /prime session-notes.md forward-scan pattern with a single Bash tail call (e.g., `tail -n 100`) to locate the most recent entry in one call, eliminating the 5-read offset progression that dominates waste in lightweight sessions.

**Estimated savings:** ~6k tokens/session (4 surplus session-notes.md reads × ~1.5k tokens avg). Over 15 sessions: ~90k tokens.

**Additional levers (ROI-ranked):**
1. **Read-before-write discipline check at session start (~1–2k tokens/session):** Write failure on session-plan.md cost 1 extra Read + 1 failed Write call. At 15 sessions: ~15–30k tokens — smaller than primary but fully preventable.
2. **Batch /wrap-session reads into parallel Bash calls (~1–2k tokens/session):** decisions.md, coaching-data.md, improvement-log.md, session-notes.md tail currently run sequentially. Parallelizing saves marginal context overhead (~15–30k over 15 sessions).
3. No additional material levers — subagent volume (3) appropriate to session type; remaining reads non-redundant.

### 2026-05-11 — /monday-prep W20 cadence (8/11 mandate items)

| Metric | Value |
|--------|-------|
| Exchanges | ~12 |
| Files read | 12+ (re-reads: session-notes.md x4, decisions.md x2, innovation-registry.md x2) |
| Files written/edited | 9 (4 Write, 2 Edit, 3 subagent-created) |
| Tool calls | Read x12, Bash x20, Write x4, Edit x2, Agent x3 (~41 total) |
| Subagents | 3 (permission-sweep-auditor, risk-check-reviewer, qc-reviewer) |
| Rework cycles | 1 |

**Rating:** Acceptable

**Findings:**
- session-notes.md read 4 times across session stages (Minor)
- session-plan.md Write failed on first attempt — file not Read before Write (Moderate)
- Mid-session compaction caused fresh-context re-orientation overhead (Minor)

**Recommendation:** Read session-plan.md before any Write attempt; enforce Read-before-Write discipline on log files touched at multiple stages.

**Estimated savings:** ~2,000–4,000 tokens if rework cycle and compaction re-orientation overhead eliminated.

---

### 2026-05-11 | Wasteful

**Task:** Applied permission-sweep Bundle 1 (4 CRITICAL + 5 HIGH settings fixes across 4 settings files in 3 repos) and Bundle 2 (jq `{{PLACEHOLDER}}` strip fix in 3 commands + INTENTIONAL-TEMPLATE classification in 2 reference files), as W20 monday-prep deferred fixes.

| Metric | Value |
|--------|-------|
| Exchanges | ~25 |
| Files read | 18+ (re-reads: 4 settings files ×2 each = 8 duplicate reads; session-notes.md ×3) |
| Files written/edited | 11 |
| Tool calls | ~53 total (Read ×18, Edit ×13, Bash ×22) |
| Subagents | 0 |
| Rework cycles | 1 (Write failed — file not Read before attempt; required re-read before retry) |

**Findings:**
- Settings files each read twice: first via Bash `cat` for context gathering, then again via Read tool to satisfy Edit's read-first requirement — 4 double-reads × ~85 lines avg = ~340 lines duplicated (Re-reads, Moderate)
- session-notes.md read 3 times across prime, session-plan precondition check, and wrap append-point find (Re-reads, Moderate)
- Write failed on first attempt because file was not Read before Write — required re-read and retry, adding at least 2 wasted tool calls (Rework, Moderate)
- Concurrent session wrote to session-notes.md between reads, causing an Edit conflict that forced another re-read before retry (Tool overhead, Minor)

**Recommendation:** Use Read tool (not Bash `cat`) for initial context-gathering on settings files — satisfies Edit's read-first requirement in one pass. Cache session-notes.md content across prime/session-plan/wrap rather than re-reading each time.

**Estimated savings:** ~3,700 tokens/session from eliminating double-reads (~37,000–74,000 over 10–20 sessions).

### 2026-05-11 | Wasteful

**Task:** Applied CLAUDE.md audit findings to three project CLAUDE.md files (axcion-ai-system-owner, global-macro-analysis, repo-documentation), each with /risk-check → edit → /qc-pass → commit. Extracted overflow methodology to reference files; ~1,410 tokens saved from always-loaded surfaces. Deferred /new-project template rename with decisions.md entry.

| Metric | Value |
|--------|-------|
| Exchanges | ~22 |
| Files read | 15+ (re-reads: session-notes.md ×4+, decisions.md ×2, repo-documentation CLAUDE.md ×2, session-plan.md ×2) |
| Files written/edited | 13 |
| Tool calls | ~50 total (Read ×15, Edit ×8, Write ×2, Bash ×18, Agent ×7) |
| Subagents | 7 (risk-check-reviewer ×3, qc-reviewer ×4) |
| Rework cycles | 2 (session-plan.md Write failed — file not Read before Write; session-plan QC REVISE — stop-point framing fix + re-QC) |

**Findings:**
- **Re-reads — Major (recurring):** session-notes.md read 4+ times across prime, session-start precondition, session-plan precondition, wrap append-point, and Write error recovery. Third consecutive session flagging this pattern with no observed improvement.
- **Rework — Moderate (recurring):** session-plan.md Write failed because the file was not Read before the Write attempt — same failure mode recorded in two prior sessions this week. Rework cycle 2 (QC REVISE on session plan) required stop-point framing fix and re-QC pass.
- **Re-reads — Moderate:** repo-documentation CLAUDE.md read twice (pre-edit + post-compaction resume); decisions.md read twice (prime and wrap). Compaction-triggered re-reads partially structural.

Stability vs. prior entries — no improvement on session-notes.md re-read or Read-before-Write patterns; both have appeared in every session logged this week.

**Recommendation:** Enforce Read-before-Write discipline as a mechanical pre-condition for session-plan.md and all log files: always issue the Read call in the same step as the decision to Write, before any other tool call intervenes. Eliminates the recurring Write-failure rework cycle that has now appeared in three consecutive sessions.

**Estimated savings:** ~2–3k tokens/session from eliminating Write-failure rework cycle. Over 15 sessions: ~30–45k tokens. Secondary gain: session-notes.md re-read reduction adds ~4–6k tokens/session.

**Additional levers (ROI-ranked):**
1. **Tail-based session-notes.md access at /prime (~4–6k tokens/session):** Replace forward-scan reads with single `tail -n 100` call; over 15 sessions: ~60–90k tokens saved.
2. **Post-compaction state restoration from summary only (~2–3k tokens/session):** Compaction summary sufficient for resumption; re-reads of decisions.md + project CLAUDE.md post-compaction add ~1–2k tokens each.
3. **Parallelize independent risk-check subagent launches (~1–2k tokens/session):** Three independent project risk-checks can batch in one Agent call.

### 2026-05-16 | Efficient

**Task:** Ingested 15 AI journal entries via /clarify → /scope refinement, then ran /friday-journal: generated 15-item implementation report, passed mechanical pre-check, ran QC subagent (REVISE verdict), dispositioned 6 findings (4 kept, 1 revised, 1 flagged for risk-check), archived active section.

| Metric | Value |
|--------|-------|
| Exchanges | ~20 |
| Files read | `logs/ai-journal.md` (~113 lines, ×1), `audits/friday-checkup-2026-05-08.md` (~98 lines, ×1), `skills/session-usage-analyzer/SKILL.md` (~60 lines partial, ×1), `logs/usage-log.md` (~30 lines tail, ×1), `logs/session-notes.md` (~5 lines tail, ×2 — prime + wrap), `logs/decisions.md` (~5 lines tail, ×1), `logs/innovation-registry.md` (~20 lines + grep, ×1), `logs/improvement-log.md` (grep, ×1) |
| Files written/edited | `logs/ai-journal.md` (edited ×2 — entries written, then active section cleared + archive appended), `audits/friday-journal-2026-05-16.md` (created), `audits/working/journal-qc-2026-05-16.md` (created by subagent), `logs/session-notes.md` (appended), `logs/coaching-data.md` (appended) |
| Tool calls | ~29 total (Read ×8, Bash ×15, Edit ×4, Write ×1, Agent ×1) |
| Subagents | 1 (qc-reviewer for /friday-journal Step 5.5) |
| Rework cycles | 2 minor targeted edits post-QC disposition (relabel research-plan-creator entry + add risk-check bullet) — expected per skill design |

**Findings:**
- Re-reads — Minor: `logs/session-notes.md` read ×2 (prime + wrap); expected pattern, not unplanned
- False positive grep — Minor: /prime innovation-count grep matched all pipe-starting table rows (98 hits) rather than "detected" status rows only; caused a misread that required correction; no material cost but signals grep pattern fragility
- /clarify pre-pass — Positive: ambiguity eliminated before /friday-journal ingestion; no scope drift or mid-task reorientation

Stability vs. prior entries — Significant improvement over 2026-05-11 (Wasteful, ~50 tool calls, 7 subagents, 4+ re-reads). This session held re-reads to one expected double-read, subagent count to 1, and rework to planned post-QC disposition edits. Tool call volume (~29) is well below the prior session's ~50.

**Recommendation:** Fix the /prime innovation-count grep pattern to filter only rows with "detected" status (column-scoped match) so the 98-hit false positive does not recur.

**Estimated savings:** Minimal headroom remaining at this efficiency level; grep fix prevents a small correction loop (~2–3 Bash calls) per session.

**Additional levers (ROI-ranked):**
1. Harden innovation-count grep to column-scoped match — eliminates false-positive correction loop each /prime run
2. Consolidate session-notes.md tail read at prime into a shared state note so the wrap read is a confirmed append-point, not a re-read — saves one Read per session

### 2026-05-16 | Efficient

**Task:** Innovation triage sweep across 6 projects to identify project-local Claude Code resources worth graduating to the shared ai-resources library. Spawned 5 parallel innovation-triage-auditor subagents, classified 101 items, and appended 23 entries to the innovation registry.

| Metric | Value |
|--------|-------|
| Exchanges | 15 |
| Files read | 13 (re-reads: 1) |
| Files written/edited | 9 |
| Tool calls | ~35 total |
| Subagents | 7 |
| Rework cycles | 0 |

**Findings:**
- Re-read: `session-notes.md` read twice (once for append point, once during wrap) — minor, small file (5 lines each read), negligible cost. (Re-reads — Minor)
- Stable vs. prior entries — Efficient, consistent with 2026-05-16 friday-checkup/journal session and recovering from the Wasteful 2026-05-14 session; parallel-dispatch sessions with pre-computed inventory piped to worker agents track efficient.

**Recommendation:** No action needed.

**Estimated savings:** N/A — no recommendation.

**Additional levers (ROI-ranked):**
No additional levers — session was efficient.

### 2026-05-16 | Acceptable

**Task:** Ran /friday-act against the 2026-05-16 weekly checkup report. Dispositioned 46 items across 3 sources into 28 fix-now / 18 deferred, wrote 7 plan files to audits/friday-plans/, applied 3 targeted edits after a QC-reviewer subagent returned a REVISE verdict.

| Metric | Value |
|--------|-------|
| Exchanges | 15 |
| Files read | 10 (re-reads: 1) |
| Files written/edited | 10 |
| Tool calls | ~35 total |
| Subagents | 1 |
| Rework cycles | 1 |

**Findings:**
- Re-reads: maintenance-observations.md read twice (append point + format check) — Minor. Combine into a single tail read.
- Rework: QC-reviewer returned REVISE; 3 edits applied across 2 plan files — Moderate. Risk-check flag misclassification and missing execution-note caveats could be caught by a pre-write checklist.

**Recommendation:** Add a pre-write checklist for plan files — confirm risk-check flag eligibility and caveat requirements before writing each artifact rather than catching gaps in the QC pass.

**Estimated savings:** ~3–5k tokens/session in rework overhead avoided; ~1–2k from combining maintenance-observations reads.

### 2026-05-16 | Acceptable

**Task:** Tier 3 /friday-act execution — 8 plan items across 4 waves from two 2026-05-16 plan files; 7 shipped across 6 commits, 1 deferred after plan-time risk-check returned PROCEED-WITH-CAUTION on a SessionStart hook chain.

| Metric | Value |
|--------|-------|
| Exchanges | ~30 |
| Files read | ~15 unique (re-reads: 4 — session-notes.md ×2, decisions.md ×2, usage-log.md ×2, session-plan.md ×1 post-Write-failure) |
| Files written/edited | ~13 |
| Tool calls | ~80 (Read ×15, Edit ×18, Bash ×20, Write ×3, Agent ×4, Skill ×6, TodoWrite ×6) |
| Subagents | 4 (qc-reviewer ×1, risk-check-reviewer ×3) |
| Rework cycles | 3 (session-plan QC REVISE → 2 fixes; Write-before-Read failure on session-plan.md; typo in /new-project verification step) |

**Findings:**
- Re-reads — Moderate (recurring): session-notes.md ×2 (start mandate + wrap), decisions.md ×2 (prime + wrap), usage-log.md ×2 (ls/wc check then full read at wrap). Same lever flagged in every Friday-cluster session this month — no improvement observed.
- Rework — Moderate (recurring): session-plan.md Write failed because file was not Read before Write — fourth consecutive Friday-cluster session logging this exact failure mode despite repeat recommendations in prior entries.
- Rework — Minor: /new-project edited in 3 separate Edit calls (main addition + typo fix + report section) when the typo could have been caught by a self-check before first Edit.
- Tool overhead — Minor: TodoWrite called ×6 across the session — incremental status ticks that could collapse to 3 checkpoints (open / mid-waves / wrap).
- Positive: 4-wave staged execution with risk-check gating produced clean deferral on the one high-coupling item (SessionStart hook chain) — gates worked as designed; no in-class GO items were rushed.

Stability vs. prior entries — improvement over the 2026-05-16 Tier 1+2 Wasteful entry (~89 calls, 5 re-read instances) but no regression-fix on the session-plan Read-before-Write pattern that has now appeared in 4 consecutive Friday-cluster sessions; rating held at Acceptable rather than climbing to Efficient because the recurring patterns persist.

**Recommendation:** Wire a mechanical Read-before-Write preamble into the /session-plan skill itself — issue the Read call as the first action of the skill body, not as a model-side discipline. Four identical failures in five Friday sessions confirms this is a structural fix, not a behavioral one.

**Estimated savings:** ~2–3k tokens/session from eliminating the Write-failure rework cycle (1 failed Write + 1 corrective Read + 1 retry Write → 1 Read + 1 Write). At observed ~1 recurrence per Friday-cluster session, projected ~10–20k tokens over 5–10 Friday sessions. Secondary savings from cached session-notes + decisions ledger reads at session open: ~3–4k tokens/session × 10–20 sessions = ~30–80k tokens.

**Additional levers (ROI-ranked):**
1. **Cache the log-trio (session-notes + decisions + usage-log) at /prime into a single consolidated read** (~3–4k tokens/session): three small ledger files re-read across prime → start → wrap on every Friday session; pinning content at first read eliminates 3 re-reads per session — larger than primary because it recurs across more session types than the session-plan Write failure.
2. **Batch /new-project edits into a single Edit pass with all changes pre-planned** (~500–800 tokens/session): 3 Edit calls on one file when a single combined Edit (with the typo caught in a self-check pre-pass) would suffice — smaller than primary because per-file batching opportunities are sporadic, not deterministic.
3. **Collapse TodoWrite status-tick calls from ~6 to 3 checkpoints** (~400–600 tokens/session): same lever flagged in prior Tier 1+2 entry today; recurs in every multi-wave execution session.

### 2026-05-18 | Acceptable

**Task:** Ran full /token-audit protocol (Sections 0–10) against ai-resources repo, deploying 7 background subagents, then extracted all research-workflow findings to a separate report via ~15 targeted Edit calls.

| Metric | Value |
|--------|-------|
| Exchanges | ~25 |
| Files read | `audits/token-audit-protocol.md` (~641 lines, ×1); `CLAUDE.md` (90 lines, ×1); `.claude/settings.json` (~60 lines, ×1); `logs/usage-log.md` (422 lines, tail ×1 + full ×1 — **re-read**); `logs/session-notes.md` (5 lines tail ×2 — **minor re-read**); `audits/working/audit-working-notes-preflight.md` (×1); 7 subagent summary files (~20 lines avg, ×1 each); `skills/session-usage-analyzer/SKILL.md` (partial 40 lines, ×1); `logs/improvement-log.md` (partial, ×1); `logs/coaching-data.md` (tail, ×1); `logs/decisions.md` (tail, ×1); `logs/innovation-registry.md` (grep only, ×1) |
| Files written/edited | `audits/token-audit-2026-05-18.md` — Write ×1 + Edit ×33 (~530 lines final); `audits/token-audit-2026-05-18-research-workflow.md` — Write ×1 (~110 lines); `audits/working/audit-working-notes-preflight.md` — Write ×1; `logs/session-notes.md` — Edit ×1 + bash append ×1; `logs/coaching-data.md` — bash append ×1 |
| Tool calls | Bash ~30, Read ~20, Write ~5, Edit ~33, Agent 7 |
| Subagents | 7 (all background; 2 mechanical for skill census + file handling; 5 Opus for workflow audits: Friday Cadence, /new-project, /repo-dd, /cleanup-worktree, research-workflow; all returned summary files only per Subagent Contracts) |
| Rework cycles | 0 failures; research-workflow extraction (~15 Edits) was clean operator-directed work, not failure recovery |

**Findings:**
- Re-read — `logs/usage-log.md` read twice (tail + full): tail read at prime was insufficient; full read required during log-append; consolidate to a single tail read at prime when the write target is confirmed early.
- Minor re-read — `logs/session-notes.md` tail read twice (prime + wrap append point): low cost but avoidable; a single read at prime with path cached is sufficient for the append.
- Edit volume — 33 Edit calls on a single report file: driven by incremental section writing pattern (18 calls) plus operator-directed extraction (15 calls); no failures, but the extraction pass could be batched more aggressively (fewer, larger Edit calls per section block).

Stability vs. prior entries: This session is cleaner than the 2026-05-16 cleanup-worktree session (59 tool calls, 3 subagent re-read redundancies, Write-before-Read failure) and roughly comparable to the friday-act Tier 3 session (~80 tool calls, 4 subagents). Subagent delegation was fully disciplined — all 7 agents returned only summary files, no inline content. The two re-reads are minor and follow the same usage-log pattern seen in prior sessions; no new failure modes introduced.

**Recommendation:** Cache the `logs/usage-log.md` read result at prime (single tail, ~20 lines) and reuse for the write-append; eliminate the second full read by confirming the write target path before the first read.

**Estimated savings:** ~200–400 tokens per session (usage-log double-read elimination).

**Additional levers (ROI-ranked):**
1. Batch large-report Edit calls more aggressively — when an extraction pass is known upfront to span N sections, write larger replacement blocks rather than one Edit call per section; target ≤8 calls for a 15-section extraction.
2. Confirm operator-directed extraction scope before starting — a single clarifying exchange at the start of the extraction pass would reduce Edit count if scope is ambiguous.

### 2026-05-22 | Acceptable

**Task:** Ran `/friday-act` for the 2026-05-22 weekly checkup — dispositioned 27 items into 8 grouped plan files, ran an innovation sweep and an independent QC pass that found and fixed 4 incorrect risk-check annotations.

| Metric | Value |
|--------|-------|
| Exchanges | ~7 |
| Files read | ~13 (re-reads: 2 — `session-notes.md` full re-read after concurrent modification; `audit-discipline.md` change-class section read twice) |
| Files written/edited | 14 (8 plan files, 6 log files) |
| Tool calls | ~55 (Bash ~26, Edit ~10, Write ~9, Read ~6, Agent ×2, Skill ×2) |
| Subagents | 2 (`innovation-triage-auditor`, `qc-reviewer`) |
| Rework cycles | 3 (1 major, 2 minor) |

**Findings:**
- QC ran post-commit rather than inline — independent `/qc-pass` found 4 incorrect risk-check annotations after the 8 plan files were already committed, forcing a follow-up correction commit. `/friday-act` has no QC step. (Rework, Major — output corrected after commit; root cause is a missing inline gate, not the QC pass itself.)
- `session-notes.md` required a full re-read mid-wrap after a concurrent `/friday-act execution` session modified the file, plus an Edit redo. (Re-reads, Moderate — 1 full re-read; concurrent-session-induced, not avoidable by pinning alone.)
- `audit-discipline.md` "Risk-check change classes" section read twice — first `sed` read truncated, re-read with `awk`. (Re-reads, Minor — wrong read range on first attempt.)
- First git commit attempt failed because a gitignored `audits/working/` path was staged — 1 retry. (Tool overhead, Minor — 1 wasted call.)
- Rating is stable vs the last 3 entries — `Acceptable` for the third consecutive Friday-cadence/audit session, with the same recurring friction class (process gap surfaced in a Friday session, recommendation = wire a mechanical step into the command).

**Recommendation:** Add an inline QC step to `/friday-act` — run the QC pass on the disposition plan files before the commit, not after. This eliminates the post-commit correction-commit rework cycle that is the central friction of the session.

**Estimated savings:** A post-commit correction cycle costs the QC re-read of 8 plan files (~150 lines each ≈ 1.2k), 5 corrective Edits (~2k), plus a second commit's overhead (~1k) — roughly 4k tokens per occurrence. Friday-act runs weekly; if annotation errors recur even half the time, that is ~2k/session amortized, or ~20–40k over a 10–20 session horizon — plus the avoided risk of a wrong annotation shipping unnoticed.

**Additional levers (ROI-ranked):**
- Cache the log-trio (`session-notes.md`, `decisions.md`, `coaching-data.md` tails) at `/prime` so `/friday-act` and `/wrap-session` reuse the primed read instead of re-tailing — `session-notes.md` alone was touched ~5 times; ~3–5k/session. Larger than a single re-read fix because it spans the whole session, but smaller than the primary because it is reads, not a rework cycle. (Recurs as a recommendation in the 2026-05-16 and 2026-05-18 entries — worth wiring once.)
- Use a precise read range for `audit-discipline.md`'s change-class section (or pin the section path) to avoid the truncated-first-read pattern — ~1–2k/session. Small and isolated.
- Stage commits with explicit file paths rather than directory globs to avoid catching gitignored `audits/working/` content — saves the failed-commit retry, ~0.5–1k/occurrence. Smallest lever; a one-line habit change.

### 2026-05-22 | Acceptable

**Task:** Ran `/prime` to orient, then a full `/cleanup-worktree` pass on the `ai-resources` working tree — investigated 14 dirty paths, wrote an 8-section cleanup plan with two QC passes plus a triage pass, and committed all 14 paths in 3 topical commits.

| Metric | Value |
|--------|-------|
| Exchanges | ~7 |
| Files read | ~21 (re-reads: 0 full — `session-notes.md` read across different ranges only) |
| Files written/edited | 5 |
| Tool calls | ~45 |
| Subagents | 3 |
| Rework cycles | 1 (minor — 1 wasted call) |

**Findings:**
- `logs/coaching-data.md` (~489 lines) read in FULL for a single append-only edit — a tail read of the closing section would have sufficed. (Context bloat, Moderate — single large file, near the >500-line Major threshold)
- Edit on `session-notes.md` failed because the file was not Read in-session first → one corrective Read → retry. One wasted call. This reproduces the recurring Read-before-Write failure flagged in the last 3 entries. (Rework, Moderate — 1 cycle)
- 3 subagents (`qc-reviewer` → `triage-reviewer` → `qc-reviewer`) ran sequentially. Dependency chain is genuine — QC2 reviews the triage-revised plan — so no parallelization was possible. (Missed parallelization, Minor — informational, not actionable)
- Trend vs. last 3 entries: stable at Acceptable — the Read-before-Write failure recurs for a second consecutive session, but the `/cleanup-worktree` protocol ran clean with QC inline (no post-commit rework, unlike the 2026-05-22 `/friday-act` entry).

**Recommendation:** Wire Read-before-Write into the wrap step that touches `session-notes.md` — pre-fetch `session-notes.md` (with `decisions.md` and `usage-log.md`) at `/prime` so the file is already in context when the wrap edit runs. This is the same lever recommended in the last 3 entries and the failure recurred here.

**Estimated savings:** The failed Edit plus corrective Read costs ~1 wasted tool round-trip — roughly ~1.5k tokens per occurrence (failed-call overhead + redundant Read of a ~500-line file). It recurs in ~3 of the last 4 sessions, so ~1k–1.5k/session amortized; over a 10–20 session horizon, ~10k–30k tokens, plus removal of a recurring friction point.

**Additional levers (ROI-ranked):**
- Tail-read `logs/coaching-data.md` instead of full read — the file is append-only and only the closing section is needed before an append. Reading ~80 closing lines instead of ~489 saves ~400 lines (~5k–6k tokens) per session that appends coaching data. Bigger single-shot saving than the primary, but fires less often (only coaching-append sessions).
- Cache the log-trio (`session-notes` + `decisions` + `usage-log`) at `/prime` — this session re-touched `session-notes.md` and `usage-log.md` at wrap. ~2k–3k tokens/session of avoided re-fetch. Smaller than the coaching-data lever and overlaps with the primary Recommendation's pre-fetch.
- Confirm the 12-file risk-check batch read stays parallel as that directory grows — it was efficient here (one parallel batch, ~1,200 lines). No saving now; a guard against future regression if the batch is ever split into sequential reads.

### 2026-05-25 | Acceptable

**Task:** Ran a 4-scope `/token-audit` sweep across `ai-resources`, `projects/ai-development-lab`, `projects/axcion-ai-system-owner`, and `projects/obsidian-pe-kb`, with `/handoff` between each audit and a consolidated cross-audit summary delivered inline.

| Metric | Value |
|--------|-------|
| Exchanges | ~22 |
| Files read | ~30 (re-reads: 1 — session-notes.md after concurrent-modification collision) |
| Files written/edited | ~14 (4 audit reports totaling 1,669 lines, 5 scratchpads, 4 pre-flight working notes, 1 friction-log entry, 1 session-notes entry, 1 coaching-data entry) |
| Tool calls | ~70–80 main-session total |
| Subagents | 13 (Section 2 skill census ×1; Section 4 workflow audits ×8 across the 4 scopes; Section 6 file-handling ×4) |
| Rework cycles | 0 (one Edit retry on session-notes.md from concurrent-write collision — collision cost, not rework on substantive work) |

**Findings:**
- **Tool overhead — Moderate:** Audit #4 (obsidian-pe-kb) ran the full 4-scope template despite having 0 local skills, 0 local commands, 0 local workflows — only Section 6 needed a real dispatch. The other sections still consumed read budget (settings.json + CLAUDE.md + usage-log + command listings + protocol re-read context) before resolving to "nothing local." A pre-scope dry-probe (count of local resources per section) would have collapsed audit #4 to a single Section 6 subagent + minimal preamble, saving roughly 40–50% of that audit's read overhead.
- **Context bloat — Minor:** The token-audit-protocol was read once but referenced implicitly across 4 audits; pre-flight working notes for each project were re-checked against existing prior reports (3 archive checks). Proportionate to a multi-scope sweep but at the upper end of justifiable per-audit context.
- **Missed parallelization — Informational:** Subagents within each audit were dispatched in parallel (3–4 at a time, as designed), but the 4 audits themselves ran sequentially with `/handoff` between each. The handoff between scopes is by design (state isolation, prevent cross-audit context bleed) — not a fix candidate, called out only because it dominates wall-clock without dominating tokens.
- **Friction-driven cost:** `/token-audit` scope-selection required 3 rounds of AskUserQuestion (logged at 09:07) before scope was named. Each round consumed an exchange and an operator turn; the desired UX (list-all-projects-with-numbers, reply-with-numbers) would have collapsed scope selection to one exchange.
- **Convergent findings as analytical value:** The 4 audits surfaced the same waste patterns (main↔subagent file duplication, Read() deny gaps, missing /compact breakpoints) in most scopes. The consolidated cross-audit summary captured this convergence — the cross-scope read is what produced novel signal, not any individual audit. Worth noting because it argues for the multi-scope sweep as a structural pattern even when per-audit findings repeat.
- **Trend:** improvement vs. the last 3 entries (Wasteful / Acceptable / Acceptable) — no Major findings, 0 rework cycles on substantive work, disciplined re-read count (1 forced re-read from a known concurrent-write class, not the session-notes tail-read pattern that recurred across most of the recent log).

**Recommendation:** Add a pre-scope dry-probe to `/token-audit` — before dispatching the full per-section subagent fan-out, count the local resources each section targets (skills/, commands/, workflows/, agents/) and skip sections with zero local resources. In this session, audit #4 (obsidian-pe-kb) would have collapsed from 4 sections to 1, eliminating ~3 sections worth of preamble reading + section structuring across an audit that had no substantive findings to surface.

**Estimated savings:** Per audit on a sparse scope (0 local resources in 3 of 4 sections), avoiding 3 sections' preamble reads + protocol re-reference ≈ 800–1,200 tokens/scope. For a 4-scope sweep with one sparse scope, ~1k tokens this session; for sweeps over the full project portfolio where ~2–3 scopes may be sparse (utility / KB / inactive projects), ~2–4k per sweep. Over 10–20 sweep sessions: ~20–80k tokens. Order-of-magnitude — actual savings depend on how often sparse scopes are included in the audit set.

**Additional levers (ROI-ranked):**
- **Fix `/token-audit` scope-selection UX** — Replace the 3-round AskUserQuestion sequence with a single list-projects-with-numbers prompt that accepts a comma-separated number reply. Saves 2 round-trips per multi-scope invocation (~500–1,000 tokens/session) plus operator friction. Smaller than the primary in tokens but eliminates the friction class logged in this session and likely recurring on every multi-scope `/token-audit`.
- **Bundle the per-audit pre-flight working notes into a single cross-audit context object** — Each of the 4 audits independently checked archives for existing pre-flight notes; a single index read at sweep start (rather than per audit) would consolidate 4 archive checks into 1. Saves ~300–500 tokens/sweep; structurally smaller than the primary because the pre-flight check is already cheap.
- **Cache the token-audit-protocol read across the sweep** — Read once at sweep start, pin in the main session's context for all 4 audits rather than letting each audit re-reference it implicitly. Saves ~200–400 tokens/sweep; lowest ROI of the three because the protocol is short and only one explicit re-read occurred — but zero-effort to implement at the sweep orchestrator level.

### 2026-05-25 | Efficient

**Task:** Executed diagnostic-backlog wave 1 from the 2026-05-25 token-audit sweep — shipped R3 (`/create-skill` output-to-disk), R4 (`/prime` log-trio pre-fetch), R6 (`/wrap-session` coaching-data tail-read), R10 (`CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=80`), and R7 (`fading-gate-scanner` subagent + `/friday-checkup` delegation) across 3 commits; R9 deferred after pre-flip verify.

| Metric | Value |
|--------|-------|
| Exchanges | ~12 |
| Files read | ~14 (re-reads: 1 — `logs/session-notes.md` tail re-read at wrap point after initial /prime tail) |
| Files written/edited | 13 (5 created, 8 modified) |
| Tool calls | ~50–60 main-session total (Read, Edit, Write, Bash for verify + commit, plus 5 subagent dispatches) |
| Subagents | 5 (`qc-reviewer` ×1; `risk-check-reviewer` ×3 — Phase 3 bundle + R7 plan-time + R7 end-time; `session-usage-analyzer` ×1) |
| Rework cycles | 1 (QC REVISE on proposed mandate → 3 findings fixed in a single revision pass, no second QC cycle) |

**Findings:**
- **Pre-execution QC caught 3 spec errors before any file write** — the mandate-stage `/qc-pass` flagged a wrong target path for R6, a phantom evaluator-agent file for R3, and a negative-offset Read assumption; all 3 corrected in a single revision. This is the inline-QC posture the prior `/friday-act` (2026-05-22) entry recommended, now operating correctly. (Rework, Minor — 1 cycle, caught before execution; no waste downstream.)
- **Minor re-read** — `logs/session-notes.md` tail read at `/prime` and again at wrap append point. Same recurring pattern flagged in the last 4 entries; R4 (log-trio pre-fetch at `/prime`) just shipped this session and should suppress it from the next entry forward. (Re-reads, Minor — 1 tail re-read.)
- **Concurrent-session naming friction** — both `session-plan.md` and `session-plan-pass2.md` were held by concurrent sessions, forcing `session-plan-pass3.md`. No token cost (one filename probe), logged to friction-log for `/improve` next session.
- **Subagent discipline held** — 5 dispatches, all returned ≤30-line summaries per the Subagent Contract; main-session context stayed bounded despite high dispatch count. No subagent output was re-read for context expansion.
- **Trend vs. last 3 entries** (Acceptable / Acceptable / Acceptable): improvement to Efficient. Two factors: (a) inline QC caught spec errors before execution rather than post-commit, eliminating the recurring rework-cycle class; (b) R4 + R6 + R10 directly target re-read and context-bloat patterns the prior 4 entries kept flagging — so this session both runs cleaner and ships the suppression for the recurring waste.

**Recommendation:** No action needed.

**Estimated savings:** N/A — no recommendation.

**Additional levers (ROI-ranked):**
- No additional levers — session was efficient. (Worth noting: the 3 shipped fixes — R4 log-trio pre-fetch, R6 coaching-data tail-read, R10 autocompact override — should produce measurable savings starting next session; track in subsequent entries to confirm the recurring re-read pattern collapses.)

### 2026-05-25 | Acceptable

**Task:** Fixed the `/mandate` (informal name for `session-start.md` Step 2) confirmation rendering — replaced the static plain-text echo block with Markdown rendering instructions (bold labels, semantic icons, tables for ≥3 files, synthesized Summary, context-adaptive section label) plus two HTML guard comments protecting the Step 2↔Step 3 parse-contract boundary. Workflow: `/clarify` → `/recommend` ×2 → `/qc-pass` → `/consult` (System Owner Function B) → ExitPlanMode → execute → commit `5b59abc`.

| Metric | Value |
|--------|-------|
| Exchanges | ~14 |
| Files read | ~10 (re-reads: 0 substantive — tail reads only at wrap) |
| Files written/edited | 9 (1 command file, 1 improvement-log, 1 plan, 3 wrap logs, 1 scratchpad, 2 memory files) |
| Tool calls | ~45 main-session total |
| Subagents | 4 (Explore ×2, qc-reviewer ×1, system-owner ×1) |
| Rework cycles | 1 (QC REVISE → 3 fixes applied in one pass; no second QC) |

**Findings:**
- **Tool overhead — Moderate:** Plan-mode iteration produced 5+ Edits on the plan file (Status field fix, output-shape framing, append-location, System Owner additions wave 1, System Owner additions wave 2, template tweaks from /recommend round 2) when 2 batched Edits could have covered the same surface. (Tool overhead, Moderate — ~3 wasted round-trips against a ~200-line plan file.)
- **Missed parallelization — Moderate:** Two Explore agents ran serially. Explore #1 surfaced the load-bearing gap (no `/mandate.md`); Explore #2 was confirmation of a negative. Either could have been one Explore with broader initial scope, or two parallel Explores covering different breadths. (Missed parallelization, Moderate — 1 unnecessary serial subagent dispatch.)
- **Rework — Minor:** 1 QC REVISE cycle, all 3 findings fixed in a single revision pass; one ExitPlanMode rejected by operator (routed to /qc-pass) — process branch, not waste. (Rework, Minor — well-contained.)
- **Operator-injected gates added structural quality:** `/qc-pass` + `/consult` between plan and execute added two review layers that caught Status-field schema mismatch, framing ambiguity, two-end parse-contract risk, and derivation-reliability concerns — all before any production file was touched. Net positive, but contributes to the iteration count.
- **Trend vs last 3 entries (Acceptable / Acceptable / Efficient):** regression from Efficient. The prior Efficient session was a low-iteration shipping session; this one was a plan-iteration-heavy rendering-spec session with two operator gates. The regression is iteration-pattern-driven, not new waste classes.

**Recommendation:** Batch plan-mode edits — when iterating on a plan during the plan workflow, consolidate related changes into one Edit per coherent wave rather than per-finding micro-edits. The 5+ plan-file Edits this session covered ~3 logically coherent waves (QC fixes / System Owner additions / template tweaks); batching into 3 Edits eliminates ~2 round-trips.

**Estimated savings:** Each plan-file Edit ≈ ~200–400 token round-trip on a ~200-line plan. Going from 5 Edits → 3 Edits saves ~400–800 tokens per plan-iteration-heavy session. Plan-iteration-heavy sessions occur perhaps ~1 in 3 → ~150–300 tokens/session amortized → ~1.5k–6k over a 10–20 session horizon. Order-of-magnitude; smaller than recent primary recommendations because plan-iteration sessions are episodic.

**Additional levers (ROI-ranked):**
- **Bundle confirmation-of-negative Explore queries into the original query** — Explore #2 was "confirm Explore #1 found nothing standalone elsewhere." If Explore #1's brief had said "if you don't find X at expected path, search broadly," the second dispatch would be unneeded. Saves ~1k–2k tokens/occurrence; recurs whenever an Explore returns an ambiguous negative. Bigger than the primary because subagent dispatches cost more than Edit round-trips.
- **Pre-emptively name common divergences in the verification-render step** — Before posting the rendered sample for confirmation, scan the new template against the user's target spec and call out divergences inline rather than letting the operator catch them via a second `/recommend`. Saves one round of operator gate (~500–800 tokens). Smaller than the primary because it only fires when a render-vs-spec gap exists.
- **Use Explore's "very thorough" breadth flag on first dispatch when scope is genuinely uncertain** — Initial Explore used default breadth; the gap discovery suggested "very thorough" would have surfaced the negative finding in one call. Saves ~600–1k tokens/occurrence; recurs only on ambiguous-scope queries. Smallest lever — narrow trigger condition.
