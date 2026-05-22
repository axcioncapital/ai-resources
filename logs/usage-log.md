# Usage Log

<!-- entries below -->

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
