# Usage Log

Token efficiency tracking. Each entry records one session's resource usage and waste patterns.

**Ratings:** Efficient | Acceptable | Wasteful

<!-- entries below -->

### 2026-07-09 | Wasteful

**Task:** Executed W3.2 roadmap item R1 (spine-schemas kernel doc) for the `w32-migration-execution` mission — discovered a missing implementation packet mid-flight, ran a two-pass System Owner consult (shaping + independent review) to draft and approve it, then wrote and QC'd the deliverable and committed across three repos.

| Metric | Value |
|--------|-------|
| Exchanges | 3 (+2 async subagent-completion continuations) |
| Files read | ~20 (re-reads: 4) |
| Files written/edited | 8 (6 by main session, 2 by subagents) |
| Tool calls | ~89 (Bash ~42, Read ~20, Edit ~13, Write ~4, Agent ~2, Skill ~6, AskUserQuestion ~1) |
| Subagents | 2 |
| Rework cycles | 1 |

**Findings:**
- session-notes.md read/tailed 5× and usage-log.md accessed 3× (including a 348-line full read at wrap) with no edits between most reads (Re-reads, Major) — this reverses the trend from the immediately preceding log entry (Efficient) and matches the pattern of the earlier Wasteful outlier two entries back, so this is a regression, not stability.
- decisions.md and remediation-register.md each read twice across the session with no intervening edits (Re-reads, Moderate).
- Two Opus system-owner subagents (~147k and ~173k tokens, ~320k combined) each independently re-grounded against overlapping W2.3/target-architecture source material rather than sharing a pre-built context pack — likely structurally necessary for author≠reviewer independence, but still the dominant redundant-read cost of the session (Context bloat, Major).
- Large cross-project design docs (W2.3, 443 lines; repo-architecture.md, 266 lines full; W3.2, 298 lines) read substantially in the main thread to support packet drafting (Context bloat, Moderate).
- Wrap-time commit blocked 3× by the foreign-staging pre-commit hook because a scope-relevant file wasn't declared, requiring an AskUserQuestion, a footprint edit, and 3 retries (Rework, Moderate — 1 cycle, systemic across 3 repos).
- `/mission close-thread` invoked as an unsupported subcommand, producing one unusable Skill dispatch plus an operator explanation (Tool overhead, Minor).
- Prime-time log tails (session-notes.md, decisions.md, usage-log.md) and later corpus reads (W2.3, W3.2, repo-architecture.md) ran as independent sequential calls with no dependency between them (Missed parallelization, Minor).

**Recommendation:** Before dispatching a second (review) System Owner pass that must stay author-independent, pre-build a shared grounding/citation extract from the overlapping source docs (W2.3 + target-arch) once, and hand identical excerpts to both the shaping and review subagents — preserves the independence requirement while eliminating duplicate corpus re-derivation.

**Estimated savings:** If ~15-20% of each subagent's token spend is redundant corpus-grounding overlap (against 147k and 173k actuals), that's roughly 20-35k tokens per subagent, ~40-70k tokens for this session's two-pass consult. Two-pass SO consults recur periodically (not every session) — over a 10-20 session horizon with a handful of similar two-pass invocations, cumulative savings land in the low-to-mid hundreds-of-thousands of tokens range. Order-of-magnitude only.

**Additional levers (ROI-ranked):**
- Cache prime/mid-session/wrap tails of session-notes.md, decisions.md, and usage-log.md instead of re-tailing at each checkpoint: ~1-2k tokens saved per avoided re-read × recurs almost every session (prime + wrap pattern) → ~5-8k/session, but compounds to ~75-120k over 10-20 sessions — smaller per-session than the primary lever but more consistently recurring.
- Declare mission-log files in the session's scope footprint proactively before the wrap commit sequence to avoid the foreign-staging hook rejecting the same file 3×: ~3-6k tokens/session, but only fires when a mid-session file falls outside the declared footprint, so lower expected frequency than the primary lever.
- Verify supported `/mission` subcommands before invoking to avoid the wasted `close-thread` dispatch: ~1-2k tokens, minor and infrequent — smallest lever here.
- Batch independent prime-time and corpus-research reads into parallel tool calls: negligible direct token savings (informational/latency-focused per the framework), included for completeness rather than cost impact.

### 2026-05-29 | Efficient

**Task:** /prime auto-mode multi-item session (operator typed `auto 1,3,4,5`): shipped FL-1+FL-6 friction-log hook unification + C-1+C-2 /consult Function A/B return-size contract + project-local agent symlink swap + improvement-log entry on the System Owner observation. Item 4 closed as no-op (0 eligible entries); Item 5 deferred per Context constraint rule (a concurrent S6 session built it in parallel).

| Metric | Value |
|--------|-------|
| Exchanges | ~14 |
| Files read | ~16 (re-reads: 2 — session-notes.md ×3 across wrap sequence; improvement-log.md offset re-read after full) |
| Files written/edited | 16 (8 source files + 8 logs/notes/scratchpads/risk-checks) |
| Tool calls | ~58 (Bash ~22, Edit ~14, Read ~10, Write ~3, Agent ~6, AskUserQuestion ~2, Skill ~3, TodoWrite ~5) |
| Subagents | 7 (risk-check-reviewer ×2, system-owner ×2 direct via Agent, qc-reviewer ×2, project-consultant ×1 abandoned, plus this analyzer) |
| Rework cycles | 0 |

**Findings:**
- **Verbose passthrough — Moderate (~6–8k tokens).** Both SO advisories returned full text (~3–4k each) into main session. Recurring drip flagged in 5+ prior entries. This session's C-1 fix (≤30-line return + full-to-disk) addresses the pattern — takes effect on the NEXT /consult invocation, so this telemetry's drip is the terminal instance.
- **Subagent overhead — Minor.** One abandoned project-consultant spawn when `Skill("consult")` mis-resolved (/consult not surfaced as a Skill this session). Architectural, not session-level. Fallback to direct Agent(system-owner) worked cleanly.
- **Redundant reads — Minor.** logs/session-notes.md tail re-read 3× across wrap sequence at different offsets (Step 1 tail, Step 3.5 guard grep, Step 4 positioning Edit). Both load-bearing — wrap requires post-write positioning checks. logs/improvement-log.md re-read at offset after full read for Verified-line edit.
- **Rework — None.** Each item shipped first-pass: risk-check → SO advisory → mitigations applied → QC GO → commit. The C-1 design revision (drop conditional-write threshold per OP-3/DR-6/AP-7) happened pre-execution — design-time, not artifact rework.
- **Trend vs last 3 entries (Acceptable / Acceptable / Acceptable):** First Efficient in the window. Heavy ≠ wasteful when each subagent is structurally earned (2 risk-checks for risk-gated changes + 2 QCs + 2 SO advisories + 1 analyzer). The SO advisory drip — flagged in 5+ consecutive prior entries — terminates here because the C-1 fix shipped this session caps return size at the source.

**Recommendation:** No action needed. Validate at next /consult invocation that the ≤30-line return contract holds and main-session pass-through is bounded.

**Estimated savings:** N/A for this session — no primary recommendation. Forward-looking: the C-1 fix shipping this session removes ~3–4k tokens per future /consult Function A/B invocation (~6–12k/week at current frequency, ~30–60k over the next 10–20 sessions). That saving accrues to future sessions, not this one.

**Additional levers (ROI-ranked):**
- **Surface /consult as a harness Skill (~2–3k tokens/session when SO second opinion fires).** /risk-check Step 4a invokes /consult automatically on non-GO verdicts. With /consult not in the skill list this session, fallback to direct Agent(system-owner) works but cost one abandoned project-consultant spawn the first time. Architectural fix at the harness layer; recurring on any non-GO /risk-check.
- **Consolidate logs/session-notes.md tail reads during /wrap-session (~500–800 tokens/wrap).** Steps 1, 3.5, and 4 all tail-read the same file at different offsets. A single read at wrap-start with in-memory positioning would collapse three reads to one. Wrap-only lever; modest per-session but every-session.
- **/wrap-session Step 3.5 verbosity (~1–2k tokens/wrap).** ~80-line inline Bash for the foreign-session guard is rendered into the prompt every wrap. Could be a helper script invocation (`bash logs/scripts/foreign-session-guard.sh`) returning just the GUARD output line. Per-wrap saving, accumulates across all wraps.

### 2026-05-29 | Acceptable

**Task:** Designed and built Context Engine MVP end-to-end across two phases (schema doc + Opus context-discovery agent + /build-context manual command in Phase 1; auto-fire wiring in /session-start and /prime with PROCEED-WITH-CAUTION mitigations in Phase 2). Heavy iterative design cycle: /clarify×2 → /scope×4 → plan + plan-QC → Phase 1 build → /risk-check → Phase 1 amendments → Phase 2 build → wrap.

| Metric | Value |
|--------|-------|
| Exchanges | ~25 |
| Files read | ~15 (re-reads: 2 — prime.md ×2, session-start.md ×2 at different offsets) |
| Files written/edited | ~18 (8 new files, 10+ edits/appends) |
| Tool calls | ~95 |
| Subagents | ~8 (system-owner ×3, qc-reviewer ×3, Explorer ×2, collaboration-coach ×1, risk-check-reviewer ×1) |
| Rework cycles | 4 (scope v1→v2→v3→v3.1, plan REVISE — all on planning artifacts, none on code) |

**Findings:**
- Rework on planning artifacts: 4 cycles before code written (Major by count, but mitigated — caught structural errors pre-build, no code thrown away). (Rework — Major)
- Re-reads of prime.md and session-start.md at different offsets, ~1200 lines total context spent on two files (Moderate — could have read full file once each given multi-step edits planned in both). (Re-reads — Moderate)
- Tool overhead acceptable: ~95 calls supporting 4 scope versions + 4 QC passes + 2 phases of edits + risk-check + system-owner second opinion (Minor — high call count but each call load-bearing). (Tool overhead — Minor)
- Strong parallelization: 4 distinct parallel-agent launches (qc+drift, Explorer ×2, system-owner background). Pre-flight verification dropped 3 deliverables from scope v3.1 → final, preventing downstream waste. (Parallelization — informational, positive)
- Trend: improvement vs same-day Entry 1 (Wasteful, TOCTOU session); on par with same-day Entry 2 (Acceptable); rework volume similar to Entry 1 but contained to planning surface, not code.

**Recommendation:** When a planned edit sequence on a single command file already exceeds 2 steps at scope-finalization time, read the file once in full (or in one wide offset window covering all target steps) rather than narrowing offsets per-edit. prime.md and session-start.md were each read twice at non-overlapping offsets — a single ~400-line read would have covered both edit sites with no waste.

**Estimated savings:** ~3-5k tokens per session on multi-edit-target sessions (prime.md ~375 lines × ~5 tokens/line × 1 avoided re-read ≈ 2k; session-start.md ~250 lines ≈ 1.3k; overhead ≈ 1k). Over 10-20 sessions where multi-step edits on a single command/skill file recur (every 2-3 sessions per pipeline-edit pattern), ≈ 15-50k tokens saved.

**Additional levers (ROI-ranked):**
- Collapse scope iteration via earlier architecture-check: 4 scope versions cost ~15-20k tokens in QC + agent output. A pre-scope architecture sanity check (Explorer agent surveying host commands + mechanism constraints before scope v1) could compress to 2 versions. ~10-15k saved per design-heavy session — biggest lever but only fires on novel-infrastructure sessions (~1/week).
- Defer Phase 1 amendments until after risk-check completes: schema doc + agent were each amended post-Phase-2-risk-check. Folding all mitigations into a single Phase 1 → risk-check → Phase 1-final → Phase 2 sequence would save 1-2 edit roundtrips (~1-2k tokens). Smaller than primary but recurs on every multi-phase build.
- session-notes.md tail-read pattern (carried from Entry 2): 2 tail reads + 1 offset read in this session ≈ 600 tokens. Cumulative across sessions still warrants the structural fix flagged 4+ entries running. Smaller per-session than primary but compounds across every session.
- Plan-file incremental edits (~6 edits applied inline to apply QC fixes): batching all 5 plan-QC findings into a single edit would save 4-5 edit-call overhead (~1k tokens). Smallest lever; minor habit shift.

### 2026-05-29 | Wasteful

**Task:** Implemented TOCTOU mitigation atomic Phase 2+3 across the ai-resources repo — wired marker-scoped `.session-marker` consumer logic into 3 writers and 5 readers plus 5 orphan-consumer narrative updates, traversing 4 verdict gates and 2 SO advisories before a 22-file atomic commit.

| Metric | Value |
|--------|-------|
| Exchanges | ~30 |
| Files read | ~22 (re-reads: 3 — prime.md 2x, session-plan.md 3x, open-items.md 2x, risk-check report 2x) |
| Files written/edited | 22 (commit) + 8 wrap-time |
| Tool calls | ~95 |
| Subagents | 7 invocations (5 distinct kinds) |
| Rework cycles | 5 |

**Findings:**
- **Rework — Major.** 5 distinct rework cycles (task pivot 1→2→1→2, spec redesign, spec inventory addendum, subagent timeout retry, QC REVISE cycle). Three of the five are Major-class on their own (>1 cycle on same artifact class: spec body iterated twice on the same defect — incomplete inventory).
- **Tool overhead — Major.** ~25 Bash calls (~10-15 inherent to wrap/Mitigation 4 verification, the rest greps + status checks). Compounds with 2 ToolSearch invocations (~2k tokens each) for deferred tools repeatedly hit across sessions.
- **Rework — Major (subagent waste).** Risk-check-reviewer Round 2 socket timeout: 18 min wall-clock + ~10-20k tokens of subagent context with zero output. Retry needed.
- **Context bloat — Moderate.** prime.md (~339 lines) read 2x and session-plan.md (~293 lines) read 3x for different sections — sectional re-reads on large command files. Targeted offset reads could have avoided ~600+ lines of duplicate context.
- **Rework — Moderate (recursive defect class).** Same inventory-completeness defect fired in Round 1 AND Round 2 risk-checks — spec author understated affected files by 4 both times. Already logged to maintenance-observations.md as a separate recommendation.
- Trend vs last 3 entries: **regression** — breaks a 4-session Acceptable streak; rework dominant pattern (previously flagged) now escalated to Major.

**Recommendation:** Add a pre-spec inventory grep checklist to the `/risk-check` plan-time protocol when the change class is "consumer rewire across multiple files." Before submitting the spec for risk-check, the spec author must run a documented grep sweep for (a) all consumers of the renamed/removed paths, (b) all narrative references in docs/, (c) all references in agent definitions — and paste the grep output into the spec's Inventory section. This would have caught both Round 1 and Round 2 inventory misses without consuming a risk-check subagent cycle.

**Estimated savings:** ~30-50k tokens per recurrence. Derivation: one full risk-check-reviewer cycle (~10-15k tokens main + ~10-20k subagent context) + SO advisory (~5-10k) + spec addendum drafting (~3k) + extra edit cycles (~5-10k). Over a 10-20 session horizon — if this consumer-rewire pattern recurs even 3-4 times (likely given the TOCTOU/permission-template/architectural-rewire backlog) — savings of **~90-200k tokens**.

**Additional levers (ROI-ranked):**
- **Targeted offset reads on large command files (~5-10k tokens/session).** Smaller than primary but recurs every session that touches multiple sections of prime.md / session-plan.md / session-start.md. A simple discipline rule ("re-reading a >250-line command file for a different section = use `offset`+`limit`") would have saved ~600 lines of re-read context this session alone.
- **Subagent timeout circuit-breaker (~10-20k tokens/recurrence).** Add a 5-min wall-clock soft cap to risk-check-reviewer with an explicit "if you've made >15 tool calls without writing the report, write a partial report and exit" instruction in the agent body. Smaller than primary because timeouts are rare, but a single occurrence wastes 18 min + ~20k tokens.
- **Pin friction-log + improvement-log + decisions.md tails into /prime read (~800-1.5k tokens/session).** Recurring lever flagged 8+ times across telemetry — would have surfaced the dirty-working-tree state and the prior TOCTOU spec context at /prime time, possibly avoiding the task 1→2→1→2 pivot (~5 min of mandate-writing waste). Smaller per-session but compounds across every session.
- **Pre-prime git-status freshness check (~2-5k tokens/recurrence).** Stale env-snapshot at /prime caused the task-pivot rework. A 1-line `git fetch && git status` refresh at /prime Step 1a before presenting the task menu would have shown the dirty state was already committed. Smaller than primary but addresses a discrete recurring failure mode.

### 2026-05-29 | Acceptable

**Task:** Applied 17 of 32 non-structural findings from 4 cycle-2 pipeline-review memos (pipeline-review, consult, contract-check, friction-log) across 3 commits; 13 deferred per each memo's Recommended-next-session line. End-time `/risk-check` returned GO; System Owner Phase 6 advisory surfaced 3 follow-up actions.

| Metric | Value |
|--------|-------|
| Exchanges | ~10 |
| Files read | ~18 (re-reads: 1 — `session-notes.md` 3× at different ranges across /prime → Phase 3 → wrap) |
| Files written/edited | 14 (5 command + registry, 4 memo Applied/Deferred blocks, 3 log files, 1 scratchpad + risk-check report by subagent) |
| Tool calls | ~75 (Edit ~22, Read ~14, Bash ~18, Agent ×4, Skill ~6, TodoWrite ~8, Write ×2) |
| Subagents | 4 (qc-reviewer ×2 — Wave 1 mechanical GO, Wave 2 full REVISE → fixed inline; risk-check-reviewer — GO; system-owner — advisory) |
| Rework cycles | 1 (CC-5 abort block: proposed → REVISE → fixed in 1 Edit; recovered in-pass without re-QC) |

**Findings:**
- **Re-reads — Moderate:** `logs/session-notes.md` (~482 lines) read 3× at different ranges (tail at /prime, full at Phase 3 doc-writing, partial at wrap edit). On a multi-phase session where session-notes is a write target throughout, repeated full-range reads accumulate ~12k extra tokens vs reading once and tracking write position in-context. Same class as the recurring "tail-read-pattern" lever logged across multiple prior entries.
- **Tool overhead — Minor:** Mid-session add of `disable-model-invocation: true` to consult.md blocked the editing session's own Skill-tool invocation of /consult at Phase 6, causing 1 failed Skill call. Worked around by spawning system-owner directly via Task. Cost ~1 wasted call; novel pattern (two-end contract self-block per System Owner Q4 analysis).
- **Tool overhead — Minor:** 2 operator-denied Edits (C-5, C-6 consult.md leanness) caught at tool-denial gate — no corrupted artifact, just 2 wasted Edit attempts. Could have been compressed if the first deny were interpreted as "skip the leanness pass on consult.md" rather than "deny just this one."
- **Subagent contracts — Clean:** Zero re-output duplication across 4 subagents. risk-check-reviewer wrote its own report file; qc-reviewer and system-owner verdicts displayed inline only. Subagent disk-notes contract honored throughout.
- **Trend vs last 3 entries (Acceptable / Acceptable / Acceptable):** stable Acceptable. Tool count higher (~75 vs ~38 prior) but proportional to scope (17 findings applied vs 8-item fix-plan). The session-notes re-read pattern continues to surface as the dominant recurring lever — now flagged in 4+ consecutive entries without structural fix.

**Recommendation:** Track `session-notes.md` write position in-context during long multi-phase sessions — read tail once at /prime (already done by R4 pre-fetch), then track planned insert offsets through phase boundaries rather than re-reading. The /prime R4 lever pre-fetches the trio but doesn't carry the offsets through to wrap; that's where the gap lives.

**Estimated savings:** session-notes.md is ~482 lines (~6k tokens); reading it 3× = ~18k tokens this session vs ~6k if pinned once at /prime and tracked via offsets. Saves ~12k/session on multi-phase sessions (3+ phases touching session-notes). Over 10–20 such sessions, ~120–240k tokens. Comparable in horizon size to the R6 coaching-data tail-read lever already shipped — same class of fix.

**Additional levers (ROI-ranked):**
- **Pre-flight check for `disable-model-invocation` self-block (~1–2k tokens/incident; novel pattern, recurrence uncertain).** Add to `ai-resource-builder` skill or /improve-skill: when adding `disable-model-invocation: true` to a command, warn that the editing session itself will lose Skill-tool access to that command for the rest of the session. Smaller than the primary lever in per-session tokens but eliminates the friction class entirely and avoids the diagnostic round-trip the operator absorbed this session.
- **Inline Applied/Deferred-block staging during Wave 2/3, not at wrap (~500–800 tokens/multi-memo-session).** Append per-finding disposition to each memo as each finding is applied/deferred rather than batching at Phase 3 wrap-time. Reduces the wrap-time edit burst from 4 sequential Edits to 4 incremental ones during execution. Saves the wrap-time context switch + 4 re-reads of memo tails. Smaller than the primary because it only fires on multi-memo application sessions.
- **Memo application sessions: skip the /session-plan + /qc-pass-on-plan ceremony when memos serve as the de-facto plan (~3–5k tokens/applicable-session, recurring lever).** This is the same lever logged in the 2026-05-29 fix-plan-execution entry ("Codify the skip planning-chain when input IS the plan pattern"). Memos play the same role as fix-plans here — paste-ready, /qc-pass'd at generation time. Documenting the pattern so future memo-application sessions skip the planning-chain by default would amortize across both classes. Same lever, second class confirmed — DR-7 trigger.

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

### 2026-05-25 | Acceptable

**Task:** Friction-driven cleanup session targeting three verified-open fixes; only Wave 2 landed (unified `deploy-workflow.md:209` to read canonical permissions from `templates/project-settings.json.template`). Waves 0 and 1 deferred due to uncertain orphan-artifact ownership and active concurrent-session interference.

| Metric | Value |
|--------|-------|
| Exchanges | ~16 |
| Files read | ~22 (re-reads: 3 — `session-notes.md` ×3 at tail, `session-plan.md` ×2 at QC + consumer check, `audits/risk-checks/2026-05-25-wave-2-...md` ×2 full reads) |
| Files written/edited | 8 |
| Tool calls | ~54 (Bash ~30, Read ~12, Edit ~6, Write 1, Agent 5) |
| Subagents | 5 (qc-reviewer ×2, risk-check-reviewer ×1, system-owner ×1, session-usage-analyzer ×1) |
| Rework cycles | 2 (session-plan pass-01 → pass-02 → pass-03, both substantive QC REVISE) |

**Findings:**
- **Rework — Major:** Session-plan proposal required TWO substantive QC REVISE cycles before execution. Pass-01 listed 2 friction items already shipped; pass-02 listed 4 different items already shipped. Root cause: friction-log not marked `Resolved:` after fixes shipped, so the friction-log was a stale outstanding-work signal. The verify-against-source sweep between pass-02 and pass-03 was the right move (would have shipped redundant work otherwise) but ~5-6 small verification reads were spent proving items already done.
- **Re-reads — Moderate:** `audits/risk-checks/2026-05-25-wave-2-...md` full-read happened twice — once grep-style for QC validation, once full-read pre-`/consult` dispatch. The full-read pre-dispatch was arguably redundant since the risk-check-reviewer subagent's return summary contained the verdict.
- **Re-reads — Minor:** `session-notes.md` accessed 3× via tail probes (5/10/3 line tails). Standing recurring pattern — flagged in 4+ of the last 6 entries; mid-reads here were load-bearing concurrent-collision detection, not waste.
- **Tool overhead — Minor:** `system-owner` ~80-line advisory appended verbatim to risk-check report via Bash heredoc — load-bearing for report self-containment, but the same flag has recurred in 3 of the last 6 entries.
- **Context bloat — Minor:** `docs/repo-architecture.md` (255 lines) full-read for `/consult` routing context; deterministic per-`/consult` cost, not session-specific.
- **Trend:** Stable vs last 3 entries (all Acceptable). The friction-log freshness gap is a NEW class of rework driver not previously logged — distinct from the session-notes / session-plan recurrences. Concurrent-session interference (4 incidents this session) continues to escalate (compare: 2 incidents in 2026-05-25 Item 8 Sequencing entry).

**Recommendation:** Add a verify-against-source pass to `/session-plan` before the first QC dispatch — when plan items reference friction-log entries, the planner reads the target file(s) and confirms the fix is genuinely outstanding before listing the item. Two QC REVISE cycles this session BOTH flagged already-shipped friction items; a 60-second pre-QC verify pass would have collapsed both into one clean proposal.

**Estimated savings:** ~6,000-9,000 tokens per multi-item friction-driven session. Derivation: 1 avoided qc-reviewer subagent invocation (~3-4k brief + ~3k return) + 1 avoided plan rewrite cycle (~5-6 verification reads × ~30 lines + revised proposal ~1.5k) ≈ 7-8k tokens. Friction-driven sessions occur ~2-3×/week → ~14-24k/week, ~60-100k over 10-20 session horizon.

**Additional levers (ROI-ranked):**
- **Mark friction-log entries `Resolved:` at ship time (Highest ROI).** Estimate: ~2-3k tokens/session × ~2-3 friction-driven sessions/week ≈ ~5-10k/week. Bigger than primary in horizon terms because it fixes the root cause (stale signal) rather than the symptom (planner trusting it). One-line discipline; structural fix would be a wrap-session hook that prompts for friction-log disposition on items touched this session.
- **Trust risk-check-reviewer return summary; skip the full-read of the on-disk report pre-`/consult`.** Estimate: ~1,500-2,500 tokens/session when `/risk-check` → `/consult` chain fires (~100-line full re-read avoided). Smaller than primary because the chain fires only on PROCEED-WITH-CAUTION verdicts (~1 in 3 risk-checks); horizon ~5-10k over 10-20 sessions.
- **Pin friction-log + improvement-log + decisions.md tails at `/prime` into a single consolidated read; reuse at `/session-plan` and `/wrap-session`.** Estimate: ~800-1,500 tokens/session. Smaller than primary per-session but extremely frequent (every session). Recurring lever — flagged in 5+ prior entries; not yet shipped.
- **Concurrent-session detection moved to a deterministic preflight signal instead of accidental tail-discovery during reads.** Estimate: ~200-400 tokens/session, but structural value (deterministic collision flag) exceeds the token figure. Lowest ROI in pure tokens; highest in cognitive-load reduction. Flagged in 3+ recent entries with escalating frequency.

### 2026-05-26 | Acceptable

**Task:** Implementation of 3 pre-drafted concurrent-session-detection plans across 3 waves (Plan 3 docs update → Plan 1 mechanical sibling-entry sweep in /prime Step 1a → Plan 2 live mtime guard in /session-start Step 0.5 + /prime marker writes). 3 commits shipped after operator-caught mid-session mandate expansion.

| Metric | Value |
|--------|-------|
| Exchanges | ~30 |
| Files read | ~14 (re-reads: prime.md ×3 different sections, session-start.md ×3 different sections, session-notes.md ×4 tail) |
| Files written/edited | 11 |
| Tool calls | ~70 (Bash ~35, Read ~12, Edit ~13, Write ~4, Agent 7) |
| Subagents | 7 (qc-reviewer ×4, risk-check-reviewer ×2, system-owner ×1 via /consult) |
| Rework cycles | 1 (Wave 2 QC REVISE — 2 small fixes self-resolved per QC → Triage Auto-Loop) |

**Findings:**
- **Re-reads — Moderate.** `prime.md` and `session-start.md` each read 3× at different offsets across Wave 1 + Wave 2 edits (line numbers shifted after intermediate edits, forcing re-Reads). Same pattern flagged on 2026-05-25 new-project.md (Major there at 5+ reads on a 698-line file); this session is a smaller magnitude — prime.md ~155 lines, section-bounded — but the failure mode is identical: multi-section edits on a single command file produce overlapping section reads.
- **Rework — Minor (self-caught, load-bearing).** Wave 2 mitigation-4 live bash test caught the TODAY_EPOCH bug (BSD `date` filled current HH:MM:SS without explicit time component) BEFORE QC. Cost: 1 fix-Edit. This is the mitigation working as designed — flagged as Minor because the test ran but the initial draft was wrong; the structural lesson is "always test bash date logic with explicit `00:00:00`".
- **Rework — Minor (operator-caught, content-review-gate working).** Operator caught a missing plan (Plan 3) right before session-plan.md write. Required backfilling mandate + replanning. Cost: 1 mandate edit + 1 plan regeneration. Not waste — the content-review gate worked, changed outcome. Structural lesson: pre-plan mandate verification could be tighter when implementing pre-drafted plans (count plans against handoff explicitly).
- **Concurrent-session interference — handled correctly, no waste this session.** Brand-book improvement-log.md was untracked from a parallel session — annotation Edit recognized as cross-session interference, commit deferred, file left in working tree. Wave 2 staging used file-by-file (not `git add .`) to avoid sweeping in a concurrent risk-check report. Plan 2 is the structural fix for exactly this class of failure — and a second concurrent session wrapped to session-notes.md DURING this implementation, validating the work in real time.
- **Prior-flagged patterns absent this session:** No verbatim SO output duplication into risk-check report (used subagent return summary directly, per 2026-05-25 recommendation). No usage-log.md head-200 read at /prime. Both confirm prior recommendations propagated.
- **Trend vs last 3 entries (all Acceptable):** Stability with mild improvement — same rating, but two prior-flagged levers (SO inline duplication, usage-log full-Read at prime) did not fire this session. session-notes.md tail re-reads persist but were all load-bearing concurrent-collision checks, not routine waste. Net direction: improving within the Acceptable band.

**Recommendation:** Pin `prime.md` and `session-start.md` content on first section read when a session has ≥2 planned edits on the same command file. Same fix as 2026-05-25 new-project.md recommendation, generalized: for any multi-edit command-file session, read the full file once upfront (or pin first-read content) and edit against the pinned view to avoid the line-number-shift re-read cascade.

**Estimated savings:** ~2,000-3,500 tokens per multi-edit command-file session. Derivation: 6 redundant section reads (prime.md ×3 + session-start.md ×3) at avg ~50 lines each ≈ 300 lines re-read at ~10-12 tokens/line ≈ 3,000-3,600 tokens; collapsing to one upfront full Read of each (~155 lines × 2 = 310 lines) is net-equivalent to one section-read each, saving ~4 redundant section fetches per session. Multi-edit command-file sessions occur ~3-5×/month → ~6-18k tokens/month savings. Smaller per-session than 2026-05-25 (file is half the size) but the pattern is recurring.

**Additional levers (ROI-ranked):**
- **Bash date arithmetic — explicit `00:00:00` time component as standing rule (~500-1,500 tokens when bug fires).** Smaller per-session than primary but a one-shot fix: add "always pass explicit time component to BSD `date -j -f`" to a relevant doc or comment in the new /session-start Step 0.5 code. Prevents the entire class of bug; mitigation 4 catches it post-hoc but a pre-write check is cheaper.
- **Mandate verification against handoff when implementing pre-drafted plans (~800-1,500 tokens when miss fires).** This session's content-review gate caught the missing Plan 3, but the structural fix is /session-plan reading the handoff's plan inventory at Step 0 and cross-checking against the proposed mandate. Smaller than primary because pre-drafted-plan sessions are infrequent, but the catch was operator-caught this time — automating it would close the loop.
- **session-notes.md tail-N standardization (~150-300 tokens/session, every session).** Smallest per-session lever but most frequent. Standing recommendation across multiple prior entries; Plan 2's mtime guard is adjacent to this work but does not solve it directly. Lowest ROI per session but highest cumulative across the 10-20 horizon.
- **Subagent return-summary use vs report full-Read (already shipped this session).** Negative-cost — already applied. Calling out as the pattern of the prior session's recommendation propagating. No further action.

### 2026-05-27 | Acceptable

**Task:** High-priority sweep from friction-log + improvement-log — 3 clusters shipped (wrap-session foreign-session guard with risk-check + QC fixes, 3 verified-done friction items annotated, 2 small docs entries resolving R3a + contract-check deferrals) plus a /resolve-repo-problem side investigation that returned benign (symlinks, not new commits).

| Metric | Value |
|--------|-------|
| Exchanges | ~25 |
| Files read | ~12 (re-reads: vault/ vs output/phase-1/ for risk-topology.md + system-doc.md after gitignore discovery) |
| Files written/edited | ~8 |
| Tool calls | ~70-80 (Bash ~40, Read ~12, Edit ~15, Write ~3, Agent 5) |
| Subagents | 5 (risk-check-reviewer, system-owner via /consult, qc-reviewer, /resolve-repo-problem investigator, session-usage-analyzer) |
| Rework cycles | 1 (Cluster 1 QC REVISE — 2 findings fixed inline) |

**Findings:**
- **Rework — Moderate.** Cluster 3 docs edits initially landed in `vault/` then required re-application to `output/phase-1/` after discovering vault/ is gitignored downstream. Cost: ~4 redundant Edits + ~2 verify Reads ≈ ~1.5-2k tokens. Root cause: vault-vs-output canonical-source ambiguity not checked before first edit. Structural fix: a one-line "which path is the canonical source?" verify before editing any file under a `vault/` or mirror-shaped directory.
- **Rework — Minor (load-bearing).** Cluster 1 QC REVISE caught 2 critical findings (bash `grep -c` zero-match arithmetic bug; header-reuse blind spot). Cost: ~2 inline Edits. Not waste — QC working as designed; the bash-grep-zero-match bug is the same class as the 2026-05-26 BSD `date` arithmetic catch, suggesting bash-edge-case live-test discipline is still drifting.
- **Tool overhead — Minor.** /resolve-repo-problem side investigation was triggered by a self-raised "concurrent-session activity" alarm before Cluster 1 commit; the alarm turned out benign (12 of 13 "new commands" were symlinks). The investigation itself produced a useful improvement-log entry (symlink-check-first diagnostic), but the trigger was a false positive — a `ls -la` check on the suspect paths upfront would have resolved it without spawning a subagent. ~3-4k tokens spent on investigation overhead.
- **Trend:** Stable vs last 3 entries (all Acceptable). The vault-vs-output rework is a NEW class not previously logged. The bash-edge-case live-test pattern (BSD date 2026-05-26; grep -c zero-match here) is now recurring — promote from session-specific lesson to standing discipline.

**Recommendation:** Add a canonical-source verify step before editing any file under a mirror-shaped path (`vault/`, `output/phase-N/`, deployed `.claude/` symlinks). One-line check: "is this path gitignored, a symlink, or a mirror copy?" before the first Edit. Would have prevented Cluster 3's full edit-then-redo cycle.

**Estimated savings:** ~1,500-2,500 tokens per docs-edit session that touches mirror-shaped paths. Derivation: ~4 redundant Edits avoided (~400-500 tokens each in tool overhead + ~50-100 lines diff context) ≈ 2k tokens; plus 1-2 verify Reads avoided (~500 tokens). Mirror-path edits occur ~1-2×/week → ~3-5k/week, ~30-50k over 10-20 session horizon.

**Additional levers (ROI-ranked):**
- **Bash-edge-case live-test discipline as standing rule (~1,500-3k tokens when bug fires).** BSD date arithmetic (2026-05-26) and `grep -c` zero-match (this session) are both shell-quirk classes that escape paper review. Add a "any new bash logic in a command body is live-tested with edge-case inputs before commit" line to a relevant doc. Bigger than primary in horizon terms because shell quirks recur and each missed bug costs a QC REVISE cycle.
- **Symlink-check-first preflight in /resolve-repo-problem investigator (~2-4k tokens when triggered).** Already logged this session as a Quick Patch in improvement-log; horizon savings ~5-10k if the same false-positive class recurs 2-3×. Smaller than primary because /resolve-repo-problem fires less frequently than docs edits.
- **Trust /consult subagent return summary; skip full-read of system-owner advisory (~1-2k tokens/session when chain fires).** Same recurring lever flagged in 2026-05-25 and 2026-05-26 entries. Not yet structurally addressed. Smaller per-session but cumulative across the chain.
- **Pin friction-log + improvement-log + decisions.md tails into a consolidated /prime read (~800-1.5k tokens/session, every session).** Recurring lever — flagged in 6+ prior entries. Lowest per-session but highest frequency; structural fix would close a standing pattern.

### 2026-05-28 | Acceptable

**Task:** Executed 7 of 8 items in the `/fix-repo-issues` plan (`audits/fix-plans/fix-repo-issues-2026-05-28-1121.md`) — judgment-heavy on items 7 (same-session MISMATCH short-circuit with plan-time /risk-check + /qc-pass) and 8 (id-06 deferred by operator); 7 commits shipped across 3 repos (ai-resources, axcion-brand-book, nordic-pe-macro-landscape-H1-2026).

| Metric | Value |
|--------|-------|
| Exchanges | not reported |
| Files read | ~10 |
| Files written/edited | ~15 (7 commits across 3 repos) |
| Tool calls | ~70 (Bash ~35, Read ~10, Edit ~12, Write ~3, Agent 2, Skill 5, TodoWrite 6, AskUserQuestion 1) |
| Subagents | 2 (risk-check-reviewer, qc-reviewer) |
| Rework cycles | 1 (item 7 QC REVISE — 1 finding fixed inline without re-QC per `feedback_minimal_infra_subset`) |

**Findings:**
- **Tool overhead — Minor.** Bash ~35 is high for a 7-item execution session — driven by multi-repo git ops (status/fetch/commit chains across 3 repos × ~3-4 ops each). Cross-repo execution is inherently bash-heavy; per-repo state probing dominated. Not addressable without restructuring the plan into repo-batched waves.
- **Rework — Minor (load-bearing).** Item 7 QC REVISE caught a real freshness-window gap in the stale-marker logic (1 finding). Fix applied inline without re-QC per established memory rule for minimal-infra deltas. Working as designed — not waste.
- **Decision-point posture held.** 5 inline operator decisions made (id-04 plan default override, id-02 marker shape choice, id-02 end-time /risk-check skip, id-02 inline QC fix, id-06 deferral signaled to operator) — no opinion-seeking asks; consistent with `feedback_decision_point_posture`.
- **Concurrent session detected.** At /prime time `ai-resources` had 22 unpushed commits; at wrap time only 1 (parallel terminal pushed mid-session). Working tree carries foreign edits (consult.md, friday-checkup.md, agent-tier-table.md) untouched by this session — structural pattern, not waste. Today's shipped same-session short-circuit (item 7) directly addresses the recurring MISMATCH false-positive that prompted this fix plan (4× recurrence in brand-book project).
- **Re-reads — None flagged.** No repeat reads of the same file at the same offset reported.
- **Trend vs last 3 entries:** Stable Acceptable. Single-cycle rework with a load-bearing QC catch matches the 2026-05-27 pattern; subagent count (2) is leaner than recent multi-item sessions (5+); 7 commits across 3 repos demonstrates high per-call leverage.

**Recommendation:** When executing a multi-item plan that spans ≥3 repos, batch the per-repo state-probe sequence (fetch + status + push-check) into a single bash invocation per repo at session start, and cache the result for the wrap-time verify pass — avoids the ~3-4 separate bash calls per repo × 3 repos that drove this session's bash-heavy count.

**Estimated savings:** ~1,200-2,000 tokens per multi-repo execution session. Derivation: 3 repos × (3-4 redundant bash status probes - 1 consolidated probe) ≈ 6-9 calls avoided × ~150-200 tokens each ≈ 1.2-1.8k tokens. Multi-repo execution sessions occur ~1-2×/week → 5-15k tokens over 10-20 sessions. Smaller than recent recommendations because cross-repo state probing is inherently bash-heavy; consolidation only trims, not eliminates.

**Additional levers (ROI-ranked):**
- **Trust /consult subagent return summary; skip full-read of system-owner advisory (~1-2k tokens/session when chain fires).** Same recurring lever flagged in 2026-05-25, 2026-05-26, and 2026-05-27 entries — now 4-session recurrence without structural fix. Bigger than primary in horizon terms because the /risk-check → /consult chain fires more often than multi-repo execution sessions.
- **Same-session short-circuit shipped this session itself (~3-5k tokens/session when MISMATCH false-positive fires).** Item 7 directly closes the recurring brand-book pattern (4× recurrence). Not a future lever — already shipped; counts as resolved structural waste.
- **Codify the inline-QC-fix-without-re-QC rule into wrap-session preflight (~5-8k tokens when applicable).** Already memory-feedback'd; per `feedback_minimal_infra_subset` Patrik will drop low-value QC re-cycles. Formalizing once saves every applicable session — smaller per-session than primary but one-shot.
- **Pin friction-log + improvement-log + decisions.md tails into a consolidated /prime read (~800-1.5k tokens/session, every session).** Recurring lever — flagged in 7+ prior entries now. Lowest per-session but highest frequency; structural fix would close a standing pattern.

### 2026-05-28 | Acceptable

**Task:** Evaluated a 7-file spec bundle for a 5-phase Incident-Resolution & Change-Safety System and shipped the MVP — 1 new slash command (`/resolve-incident`), 2 governance docs, 1 operational log, 1 audit subdir, and a deprecation note on `/resolve-repo-problem`. Single commit, 520 insertions across 8 files.

| Metric | Value |
|--------|-------|
| Exchanges | ~14 |
| Files read | 16 (re-reads: 1 — session-notes.md tail read twice, different regions) |
| Files written/edited | ~13 (5 new + 8 edited; plus 3 log appends via heredoc) |
| Tool calls | ~58 (Bash ~22, Read ~10, Write ~7, Edit ~15, Skill ×2, Agent ×5, AskUserQuestion ×4, ExitPlanMode ×1) |
| Subagents | 5 |
| Rework cycles | 2 |

**Findings:**
- **Rework — Major:** Two rework cycles on the same workstream — plan file required 7 QC fixes (4 self-resolve + 3 operator-judgment via AskUserQuestion), then command body required 4 mitigations + 2 system-owner additions after PROCEED-WITH-CAUTION risk-check. Both cycles applied inline without re-QC, which contained cost, but the underlying signal is that the spec's scope ambiguity ("evaluate and write MVP plan") was carried into planning rather than resolved upfront. Tighter pre-clarify scope-fixing would have collapsed one cycle.
- **Missed parallelization — Minor:** Four early planning reads (risk-check.md, resolve-repo-problem.md, repo-architecture.md, templates/README.md) ran sequentially with no dependency; same pattern in /decide repo-discovery reads. Informational only.
- **Context bloat — Minor:** /consult invocation pulled the full system-owner advisory text into main-session context — same recurring lever flagged in 2026-05-25, 2026-05-26, 2026-05-27, 2026-05-28 telemetry. Sub-30-line return is the subagent contract; advisory output exceeds it by design.
- **Tool overhead — Minor:** Bash count (~22) inflated by /wrap-session protocol (foreign-session guard + archive check + heredoc appends to three logs). Inherent to wrap; not addressable per-session.
- **Trend:** Stable — fourth consecutive Acceptable rating (2026-05-25 ×2, 2026-05-26, 2026-05-28), with rework remaining the dominant pattern across the streak.

**Recommendation:** When operator hands a multi-file spec bundle with ambiguous build scope ("evaluate and write plan"), front-load a hard MVP-cut decision in /clarify Step 1 — not in /decide — so the plan file enters /qc-pass with scope already bounded. Rework on planning artifacts is the largest recurring loss across the last 4 sessions; resolving scope before plan-drafting collapses the QC-fix cycle.

**Estimated savings:** ~6–10k tokens/session in avoided plan-file QC rework (7 Edits × ~500 tokens each + 1 triage subagent ~3k + AskUserQuestion overhead ~1–2k). Over a 10–20 session horizon at the current ~1-in-3 multi-file-spec rate: ~20–60k tokens, plus collapse of one risk-check mitigation round on the downstream artifact when scope is tighter.

**Additional levers (ROI-ranked):**
- **Parallelize planning-phase reads (~3–5k/session):** The four planning reads + four /decide discovery reads are dependency-free. Batching all 8 into 2 parallel Read calls saves the inter-call overhead. Smaller than the primary because token cost per sequential Read is modest; the lever is wall-clock and orchestration cleanliness more than token volume.
- **Cap /consult advisory return (~2–4k/session):** The system-owner subagent's full advisory text gets surfaced into main session — apply the standard sub-30-line summary contract from `ai-resources/CLAUDE.md` § Subagent Contracts. Smaller than the primary because /consult fires less often than planning rework, but it's the recurring lever across 4 of the last 5 telemetry entries — fixing it once collapses a chronic drip.
- **Pre-Edit batching for repo-architecture.md updates (~1–2k/session):** Three sequential Edits applied to the same file (subdir + tree row + table row). A single multi-line Edit covering all three would halve the tool-call overhead. Smallest lever — narrow scope and only triggers when adding a new resource type — but a clean win when it applies.

### 2026-05-29 | Acceptable

**Task:** Executed the 8-item fix plan at `audits/fix-plans/fix-repo-issues-2026-05-29-1108.md` end-to-end across 4 repos (ai-resources + 3 projects) — all 8 items applied, 4 commits shipped this session; deliberately skipped `/session-start` + `/session-plan` because the fix-plan was the approved plan.

| Metric | Value |
|--------|-------|
| Exchanges | ~3 |
| Files read | ~6 (re-reads: 0 substantive) |
| Files written/edited | 14 (8 modified across 4 repos + 6 new — scratchpad + 2 scripts × 2 projects + W1 plan/context; fix-plan source newly tracked) |
| Tool calls | ~38 (Bash ~20, Edit ~9, Read ~6, Write ×1, AskUserQuestion ×1, Agent ×1) |
| Subagents | 1 (qc-reviewer on id-08 → GO) |
| Rework cycles | 0 |

**Findings:**
- **Tool overhead — Moderate.** Fix-plan id-04 / id-07 specified provisioning only `check-archive.sh`, but the smoke-test exits non-zero without its sibling `split-log.sh`. Cost: ~5 calls (re-run after missing-file error, then provision + re-test). Same waste class as the 2026-05-26 BSD `date` / 2026-05-27 `grep -c` bash-edge-case discoveries — but here the gap is in the FIX-PLAN spec, not in command body. Structural fix: fix-plan templates that provision scripts must enumerate sibling dependencies the smoke-test invokes.
- **Concurrent foreign-session collision — recurring, not preventable mid-session.** Foreign commit `b1df69f` absorbed this session's nordic-pe-macro improvement-log edits, costing ~3 diagnostic calls when `git add` produced nothing to commit. Third recurrence in 3 days. The shipped same-session short-circuit (2026-05-28) does not cover this class; the durable fix remains TOCTOU Phases 2–4 (parked).
- **Spec deviation handled cleanly — no waste.** Id-08 fix-plan said "append a Caveats section" but line 351 actively sanctioned the rejected pattern; inverted line 351 in place instead. Discovered during normal read (no extra cost); `/qc-pass` GO confirmed.
- **Planning-chain skip — net positive.** Free-text-intent path (no `/session-start` + `/session-plan`) on a paste-ready fix-plan saved ~6–8 calls and ~3–5k tokens vs. the auto-chain. Comparison vs. 2026-05-28 fix-repo-issues entry (same shape, same source command): ~3 exchanges + ~38 calls here vs. ~14 exchanges + ~58 calls there. Validates the pattern: when the input artifact IS a complete plan, the planning chain is overhead.
- **Trend vs last 3 entries (Acceptable / Acceptable / Acceptable):** stable Acceptable. 1 Moderate finding (split-log.sh spec gap) holds the rating at Acceptable per strict framework, despite the leading indicators (0 rework, lean call count, single subagent with GO) that would otherwise push to Efficient. Net direction: positive — the planning-chain skip removed the dominant rework class of the prior streak, but a new structural gap class (fix-plan spec incompleteness) emerged in its place.

**Recommendation:** Update fix-plan templates that provision multi-script log infrastructure to enumerate sibling script dependencies the smoke-test invokes. This is the highest-leverage fix because it converts the "Moderate" finding here into a "0 findings" rating next time the pattern fires, and the same class shows up across other plan templates.

**Estimated savings:** ~2–4k tokens/session when the smoke-test gap fires (avoided re-run + dependency-discovery diagnostic), ~10–20k over a 10–20 session horizon at the current rate (~1-in-5 sessions touch new-project script provisioning).

**Additional levers (ROI-ranked):**
- **Codify the "skip planning-chain when input IS the plan" pattern (~3–5k tokens/session when applicable).** This session demonstrated the saving; the pattern is currently undocumented. A one-line addition to fix-plan / session-start guidance ("if the operator hands a paste-ready, /qc-pass'd plan, the free-text-intent path is preferred over the planning chain") would propagate. Fires ~1–2×/week on fix-plan execution sessions → ~5–10k/week, ~50–100k over 10–20 sessions.
- **TOCTOU Phases 2–4 — durable fix for the foreign-session-absorption class (~3–5k tokens/incident).** Third recurrence in 3 days; parked because it requires structural staging discipline. Per-incident cost is modest but recurrence rate is accelerating; horizon ~30–60k over 10–20 sessions if recurrence stays at current pace.
- **Pin friction-log + improvement-log + decisions.md tails into a consolidated /prime read (~800–1.5k tokens/session, every session).** Recurring lever — flagged in 8+ prior entries now. Lowest per-session, highest frequency, still not structurally addressed.

### 2026-05-29 | Acceptable

**Task:** Friday-checkup-2026-05-29 bundle execution at Recommended scope (Waves 1+2+3+4) — Wave 2 cluster dropped after /risk-check RECONSIDER on 3 stale-premise settings.json edits (saved 3 NO-OP commits); M1 git-guards applied stand-alone; Wave 3 extracted change-shape classifier doc; Wave 4 ITEM A deferred via /decide, ITEM B shipped with risk-check mitigations + QC REVISE inline fixes. 5 commits across ai-resources + repo-documentation.

| Metric | Value |
|--------|-------|
| Exchanges | ~10 |
| Files read | ~25 (re-reads: 1 — `session-notes.md` tail ×4-5 across /prime + /session-start guard + wrap guard + mandate-line lookup) |
| Files written/edited | ~22 (5 new — 2 risk-check reports, change-shape-classifier.md, /pm investigation notes, session-plan-S6.md, scratchpad; ~17 edits across consult.md, project-manager.md, graduate-resource.md ×2, ai-resource-creation.md, 2 decisions.md files, ~/.claude/settings.json, maintenance-observations.md, 3 vault/components files ×5, session-notes.md ×2, coaching-data.md) |
| Tool calls | ~70 (Read ~18, Edit ~14, Write ~5, Bash ~22, Skill ~7, Agent ~3, AskUserQuestion ×1, TodoWrite ~6, ToolSearch ×1) |
| Subagents | 3 (risk-check-reviewer ×2 — Wave 2 RECONSIDER, Wave 4 PROCEED-WITH-CAUTION + 9 mitigations; qc-reviewer ×1 — Wave 4 ITEM B REVISE → 3 wording fixes inline) |
| Rework cycles | 1 (Wave 4 ITEM B QC REVISE → 3 wording-level fixes applied inline, no second QC pass per minimal-infra-subset rule) |

**Findings:**
- **Re-reads — Moderate.** `session-notes.md` tail re-read 4-5× across /prime header detect, /session-start guard, /wrap-session guard, mandate-line lookup, and wrap append point. Recurring R4 telemetry pattern flagged in 6+ prior entries — log-trio pre-fetch at /prime ships the tail once but downstream guard steps re-read it. Each read ~30-50 lines ≈ ~1.5-3k tokens cumulative this session.
- **Tool overhead — Minor (load-bearing skips).** Decision-Point Posture saved multiple /consult Step 4a invocations, /decide Step 6 QC subagent skip, and a second post-edit /qc-pass skip — each documented with rationale. Net ~20-30k tokens saved by skipping ceremony where the verdict was deterministic. Not waste; called out as a positive pattern that should persist.
- **Tool overhead — Minor.** /decide evidence-grounding step on Wave 4 ITEM A discovered the mechanical-mode rubric already exists in qc-reviewer.md (lines 22-41) — plan item #2 framed it as needing definition. Avoided ~10-15k of redundant spec work; the discipline of evidence-grounding before spec drafting paid out cleanly.
- **Risk-check ROI re-confirmed — Major positive.** Wave 2 RECONSIDER on 3 stale-premise settings.json edits saved ~15-25k tokens of NO-OP commit overhead (3 commits each with end-time check + verification + concurrent-session collision risk) at ~5-10k cost. Net ~10-20k saved on a single /risk-check invocation; biggest single ROI event of the session.
- **Concurrent-session marker collision — Minor structural.** Wrap pre-write guard's marker-aware OWN attribution misfired (saw concurrent S9 as own); staging will ship S9's header line under this session's commit. Attribution muddled, content preserved. Not blocking but a recurring concurrent-session class flagged in 4+ prior entries; structural fix pending.
- **Vault linter modifications mid-session — Informational.** Two system-reminders surfaced linter activity on vault/components/projects.md + agents.md after pastes. Did not revert per reminder instructions. Possible Friday-cadence observation if recurring.
- **Trend vs last 3 entries (Acceptable / Acceptable / Acceptable):** stable Acceptable. Risk-check ROI on the stale-premise catch is the standout efficiency win this session; session-notes.md tail re-read pattern continues to surface as the dominant recurring lever — now flagged in 6+ consecutive entries without structural closure.

**Recommendation:** Cache `session-notes.md` tail content at /prime into a session-context variable, then have /session-start guard, /wrap-session guard, and mandate-line lookup read from the cached variable rather than re-tailing the file. R4 already pre-fetches the trio at /prime; the gap is that downstream guard steps don't reuse the pre-fetched content — they re-tail. A small structural change at the wrap/start guard layer (pass cached tail through, or skip re-read if the file mtime is unchanged since /prime) closes the recurring leak.

**Estimated savings:** session-notes.md tail ~30-50 lines × ~10 tokens/line × 4-5 reads = ~1.5-3k tokens/session. Multi-phase sessions (most Friday-cadence + bundle execution sessions) recur 3-5×/week → ~6-15k tokens/week, ~60-150k over 10-20 session horizon. Same magnitude class as the R6 coaching-data tail-read lever already shipped; this is the natural follow-on.

**Additional levers (ROI-ranked):**
- **Codify "Decision-Point Posture skip rationale" as a documented saving pattern (~5-10k tokens/session when applicable).** This session saved ~20-30k by skipping /consult / /qc-pass / QC subagent at deterministic decision points with documented rationale. Risk: skipping by default erodes the QC layer. Mitigation: document the trigger conditions explicitly (verdict deterministic + assumptions-gate clean + no contract-level ambiguity). Bigger than primary in horizon terms but requires discipline framing to avoid over-skip.
- **/risk-check stale-premise pre-flight check (~10-20k tokens/recurrence).** Wave 2 RECONSIDER caught 3 of 4 settings.json edits already shipped by concurrent same-day commits. Adding a "git log since plan-write timestamp" check at /risk-check Step 1 — surfacing recent commits that may have invalidated the plan's premises — would catch this class deterministically rather than relying on subagent judgment. Smaller frequency than primary but huge per-occurrence saving.
- **Evidence-grounding before spec drafting in /decide (~10-15k tokens/applicable-session).** This session's /decide call on Wave 4 ITEM A discovered the mechanical-mode rubric already existed via grep. Making "grep target docs for the concept the spec proposes to introduce" a Step 0 in /decide (and adjacent spec-drafting workflows) would amortize across novel-spec sessions. Smaller frequency than primary; high per-occurrence.
- **Concurrent-session marker OWN/FOREIGN attribution fix (~1-2k tokens/wrap when collision fires; structural cleanliness > tokens).** Marker collision misfired this wrap; attribution muddled but content preserved. Lowest per-occurrence in tokens but standing pattern flagged in 4+ prior entries. Structural fix at the wrap-guard layer would close the recurring class.

## 2026-06-01 (S2) — Monday-prep follow-up: push-policy fix + context-engine eval + marker-clobber rejection

**Task:** Acted on 3 Monday-prep 2026-W23 items. (#1) 11-file project CLAUDE.md push-policy fix (11 repo commits). (#2) Context-Engine Phase 1 eval — PASS, promote. (#3) Marker-clobber guard Option 1 — implemented, risk-checked, dry-run-REJECTED, reverted, escalated to Option 2.

| Metric | Value |
|--------|-------|
| Exchanges | ~9 |
| Files read | ~22 (5 context packs, 2 wrap-session.md, build-context.md, settings.json, permission-template.md, friday-act.md, session-notes/improvement-log tails, 11 project CLAUDE.md windows) |
| Files written/edited | ~28 (11 project CLAUDE.md, eval report, 2 risk-check reports + 2 appends, session-plan-S2, improvement-log ×2, session-notes ×2, decisions, coaching, usage-log, scratchpad, 4 wrap-session.md edits+reverts) |
| Tool calls | ~62 (Bash ~22, Edit ~22, Read ~9, Write ~3, Skill ×6, Agent ×8, AskUserQuestion ×3) |
| Subagents | 8 (risk-check-reviewer ×2, qc-reviewer ×2, Explore ×1, context-discovery ×2, system-owner ×1) |
| Commits | 14 (11 project repos + 65b1f70 + 9ba4bef + wrap) |
| Rework cycles | 2 (context-eval QC REVISE → 3 fixes; marker-clobber implement → dry-run reject → revert) |

**Findings:**
- **High subagent count (8) — mostly load-bearing.** 2 risk-checks gated genuine structural changes; 2 QC passes each caught a real defect (eval-report overclaim on "verified every spot-check"; and the marker-clobber dry-run rejection). The marker-clobber dry-run was the single highest-ROI event: it prevented shipping a guard that looked fixed but reproduced the original silent false-negative. Not ceremony — the validation layer working.
- **Marker-clobber: ~3 subagents + a full implement/revert cycle spent to reach a REJECT.** Net output was a finding + escalation, not a shipped patch. This is correct (better than shipping broken), but signals the improvement-log's "Option 1, no risk-check needed, ~15 lines" framing under-scoped the problem by a wide margin — the reactive patch is undeliverable. Lever: when an improvement-log entry proposes a reactive patch over a known shared-mutable-oracle bug, flag at triage that the structural fix may be the only viable path before a session invests an implement cycle.
- **session-notes.md tail re-read pattern recurs** (R4 lever) — read at /prime, re-read at wrap guard. Same standing pattern flagged 7+ entries.
- **Decision-Point Posture saved asks** — picked recommended options at multiple junctures (engine-skip rationale, end-time risk-check skip) with inline rationale rather than operator prompts.

**Recommendation:** Add a triage heuristic to `/resolve-repo-problem` / improvement-log intake: when a proposed fix is a *reactive detector* over a *shared-mutable-state oracle* bug, tag it "validate-before-invest — structural fix may be the only viable path" so a future session dry-runs the signal before a full implement cycle. Would have saved ~3 subagents + an implement/revert here.

## 2026-06-01 (S6) — parallel-sessions-playbook.md authored via canonical doc path

**Task:** Authored `ai-resources/docs/parallel-sessions-playbook.md` — a universal scope-agnostic playbook for parallel multi-session Claude Code work — from an inbox brief via the canonical doc path. Stress-tested the contested n=1 framing via a system-owner consult, resolved all 7 of the brief's Known Weaknesses, ran independent QC (GO, one cosmetic fix), committed and pushed.

| Metric | Value |
|--------|-------|
| Exchanges | ~9 |
| Files read | ~11 (parallel-sessions-playbook-brief.md, session-marker.md, autonomy-rules.md, ai-resource-creation.md, detect-concurrent-session.sh, session-notes.md windows ×2, decisions.md tail, usage-log.md tail, coaching-data.md tail) |
| Files written/edited | ~8 (parallel-sessions-playbook.md new ~224 lines, session-plan-S6.md overwrite, session-notes.md ×3 appends, decisions.md ×1, coaching-data.md ×1, scratchpad new, inbox brief archived via git rename) |
| Tool calls | ~30 (Bash ~16, Edit ~6, Read ~5, Write ~3) |
| Subagents | 4 (system-owner framing consult, qc-reviewer GO, general-purpose outcome check, session-feedback-collector) |
| Rework cycles | 0 (one cosmetic QC fix; one git-add retry on gitignored path — trivial) |

**Findings:**
- **Clean single-pass authoring — positive.** First-draft QC returned GO. Zero substantive rework. System-owner consult resolved the contested n=1 framing pre-draft, preventing a likely REVISE cycle post-QC. The front-loaded consult earned its cost.
- **Context-discovery engine deliberately skipped — positive.** The brief pre-enumerated all source files; skipping the engine was correct and saved ~2–3k tokens vs auto-firing it. First confirmed example of a session where the brief made the engine redundant.
- **session-notes.md tail re-read pattern recurs (R4 lever)** — tail read at /prime, re-read at wrap for positioning. Standing pattern flagged 8+ entries across the log. No structural fix yet.
- **Wrap Step 3.5 date-rollover false-positive — Minor.** Own marker stayed on prior day across midnight; the guard fired a REMNANT false-alarm. Resolved via operator confirmation in one exchange, no content loss. Architectural (clock-boundary race in the marker-write step), not session-level waste.
- **Trend vs last 3 entries (Efficient / Acceptable / Acceptable):** Efficient — lowest rework count in recent window, lowest exchange count for a doc-authoring session. Subagent count (4) proportional and load-bearing.

**Recommendation:** No action needed for this session. The standing R4 lever (session-notes.md tail re-read across /prime → wrap) continues to accumulate across 8+ entries without a structural fix. If a `/wrap-session` edit that reads the file in Step 1 and carries the position in-context is not shipped within the next 2 sessions, escalate as a standing debt item.

**Estimated savings:** N/A for this session — no primary rework. Forward-looking: the date-rollover false-positive in Step 3.5 is architectural; if the marker timestamp is written at /prime (before midnight) and wrap fires the next calendar day, the guard will misfire on every overnight session. A one-line fix (compare marker content against git log or use a grace window) would eliminate the class. Low frequency but zero-cost to fix.

**Additional levers (ROI-ranked):**
- **Ship the R4 structural fix (session-notes.md tail in-context tracking, ~800–1.5k tokens/wrap).** Now flagged 8+ consecutive entries. The per-session saving is modest but it compounds across every session and the fix is a single /wrap-session edit. Highest-ROI unshipped lever in the log.
- **Wrap Step 3.5 date-rollover guard: add a grace window or compare against git log rather than calendar date (~0 tokens/fix, prevents per-overnight false-positive).** Operator confirm absorbed the false-positive this session, but overnight sessions will hit it every time until fixed.
- **Brief-as-source-enumeration skip-signal for context-discovery engine (~2–3k tokens/applicable session).** This session confirmed the pattern: when a brief pre-enumerates all source files, the engine is redundant. Consider adding a `sources-complete: true` flag to the brief schema so /session-start can skip the engine auto-fire without a judgment call.

## 2026-06-10 (S1) — Concurrent-session isolation Fix 1: SessionStart precision-fix (re-scoped mid-session)

**Task:** Shipped Fix 1 of the concurrent-session isolation fix-plan (picked via `/prime 1 auto`). RE-SCOPED mid-session (operator-approved) from a "forceful SessionStart block" to a "soft precision-fix" after an authoritative finding that SessionStart hooks cannot block. Rewrote `detect-concurrent-session.sh` (per-id-marker liveness discriminator + old-CLI fallback, still non-blocking), added `/wrap-session` Step 13 marker teardown, updated 2 docs, re-synced 2 byte-identical project hook copies. 3 commits across 3 repos.

| Metric | Value |
|--------|-------|
| Exchanges | ~10 (approx) |
| Files read | ~12 (approx; re-reads: 0 flagged) |
| Files written/edited | ~12 (approx; hook ×2 edits + header, 2 project copies, wrap-session.md, session-marker.md ×3, parallel-sessions-playbook.md, session-notes ×several, decisions, coaching, friction-log restore+append, improvement-log ×2, session-plan, scratchpad, risk-check report) |
| Tool calls | ~45 (approx; Bash-heavy — pulls, marker setup, dry-run harness, syntax checks, copy syncs, log appends) |
| Subagents | 5 (risk-check-reviewer, system-owner 2nd-opinion, claude-code-guide mechanism probe, qc-reviewer APPROVE, general-purpose outcome-check) + session-feedback-collector (hit a write incident) |
| Rework cycles | 1 (self-caught fallback-boundary bug in dry-run, pre-QC) |

**Findings:**
- **Mid-session re-scope on a platform-capability finding — load-bearing, not waste.** The "SessionStart hooks cannot block" finding inverted the fix's whole posture (forceful block → soft precision-fix) before any code shipped. Caught early via the system-owner 2nd-opinion + claude-code-guide mechanism probe; cost ~2 subagents but prevented shipping a guard built on a false capability assumption. This is the validation layer working, same class as the 2026-06-01 marker-clobber dry-run REJECT.
- **Subagent write incident — Moderate (Tool overhead / rework).** The session-feedback-collector subagent hit a destructive-overwrite incident at wrap; recovered by restoring the clobbered file from HEAD and re-routing the feedback signals by hand. Cost: a restore + manual re-append cycle. Recurring shared-mutable-file write-discipline class (cf. concurrent-session marker collisions flagged 4+ prior entries) — a subagent writing a whole-file overwrite to an append-only log is the same failure shape the workspace already guards against for the main session but not for spawned agents.
- **Dry-run caught its own bug — positive.** The fallback-boundary bug in `detect-concurrent-session.sh` surfaced in the 7-scenario dry-run harness before QC, so the qc-reviewer pass saw clean code and returned APPROVE. Self-caught rework is the cheap kind; the dry-run harness paid for itself.
- **Trend vs last 3 entries (S2 Acceptable / S6 Efficient / this):** Acceptable — held off Efficient by the collector write incident (1 Moderate). Otherwise lean: 0 flagged re-reads, single self-caught rework cycle, subagent count (5) proportional to a re-scoped structural change requiring risk-check + capability verification + QC.

**Recommendation:** Apply the main-session append-only write discipline to spawned subagents that touch shared logs. The session-feedback-collector (and any subagent writing to coaching-data / friction-log / decisions) should be contracted to APPEND via heredoc, never whole-file Write — mirror the `File Write Discipline` rule into the subagent's own body. Highest-leverage because it closes a destructive-loss class (not just a token leak) and the same fix template covers every log-appending subagent.

**Estimated savings:** The incident cost ~2–4k tokens this session (HEAD restore + diff inspection + manual re-append). Token saving is secondary; the real cost averted is data loss — a clobbered append-only log not caught at wrap is unrecoverable from context. At the current rate (collector fires ~1×/substantive session), a one-line contract change prevents ~1 destructive-overwrite risk per session, ~10–20 averted over the horizon.

**Additional levers (ROI-ranked):**
- **Marker-teardown discipline now in wrap Step 13 (~0 tokens/fix, prevents stale-marker false-positives).** This session added the per-id marker teardown; the adjacent lever is verifying teardown actually runs on abnormal exit (crash / compaction-kill) where wrap never fires — a stale per-id marker would then mislead the next same-checkout session's liveness discriminator. Low frequency, high cleanliness value.
- **Capability-assumption pre-flight for hook fix-plans (~10–20k tokens/recurrence).** The re-scope cost ~2 subagents because the fix-plan assumed SessionStart could block. A one-line "verify the hook event's blocking capability against the platform doc before drafting the fix" check at fix-plan intake would catch this class deterministically. Low frequency but large per-occurrence — same shape as the 2026-06-01 "validate-before-invest" lever.
- **Byte-identical hook-copy sync (~0.5–1k tokens/session when it fires).** Two project hook copies re-synced by hand after the canonical edit. A sync helper (or a single source-of-truth + symlink) would remove the manual copy step. Smallest lever — narrow trigger — but a clean win whenever a shared hook changes.

## 2026-06-10 (S3 cont.) — Concurrent-session coverage micro-audit (verdict: PARTLY FIXED)

### 2026-06-10 | Efficient

**Task:** Concurrent-session coverage micro-audit — evidence-traced the full concurrent-session fix campaign against recorded incidents and inspected the live solution (2 hooks, settings wiring, wrap Step 13). Verdict PARTLY FIXED: the commit-time block (`check-foreign-staging.sh`) works but is wired only in the ai-resources checkout (0/15 project repos, not workspace-root, not user-level). Produced audit memo + tiered P1–P4 fix plan; operator deferred the build.

| Metric | Value |
|--------|-------|
| Exchanges | ~6 |
| Files read | ~10 (re-reads: 1 — `wrap-session.md` ×2 for Step 13 verification) |
| Files written/edited | ~8 (audit memo ~201 lines new, scratchpad, improvement-log entry, decisions entry, session-notes append + 2 edits, coaching entry) |
| Tool calls | ~30 (Bash-heavy — grep/git wiring inventory across 15 project settings, repo-list, marker checks) |
| Subagents | 4 (qc-reviewer → GO; general-purpose outcome-check → DELIVERED/OPTIMAL; session-feedback-collector → could not write [toolset lacked Edit/Bash], returned signals inline; this usage analyzer) |
| Rework cycles | 0 (one QC-driven MINOR fix, not a rework cycle) |

**Findings:**
- **Clean lean audit session — positive.** Advisory-only output, no destructive writes, zero rework. QC returned GO on first pass and the outcome-check rated DELIVERED/OPTIMAL. The Bash-heavy tool count (~30) was load-bearing: the verdict's core claim (0/15 project repos wired) required mechanically inventorying the wiring across all 15 project settings rather than asserting it — evidence-traced, not assumed.
- **QC was genuinely independent and verified factual fidelity against logs — positive.** The operator's explicit ask was whether the fix is permanently complete; the qc-reviewer checked the audit's incident-trace claims against the recorded logs rather than rubber-stamping.
- **Candidate friction signal correctly withheld — positive (discipline).** A "Step 3.5 template mangled" observation was verified to be a harness context-injection *display* artifact, not a file defect, and kept out of the friction log.
- **session-feedback-collector could not write (toolset lacked Edit/Bash) — Minor (recurring subagent-contract class).** The collector returned its signals inline instead, so no data was lost this time. Same shared-log subagent-write fragility flagged in the S1 entry (there a destructive overwrite; here a no-write). Confirms the S1 recommendation (contract log-appending subagents explicitly for their write path) is still unshipped.
- **Trend vs last 3 entries (S2 Acceptable / S6 Efficient / S1 Acceptable):** Efficient — lowest write footprint and zero rework in the recent window.

**Recommendation:** Fix the session-feedback-collector's tool contract so it can write its own append to the shared log (Edit/Bash in its toolset, append-via-heredoc per the S1 recommendation). Highest-leverage: the collector has now failed its write step in two consecutive substantive sessions (S1 destructive overwrite, this session no-write) — the same one-line fix closes both the data-loss shape and the no-write shape.

**Estimated savings:** ~1–2k tokens/session in manual signal re-routing when the collector fails its write, plus the averted data-loss risk that is the real cost. ~10–20k over a 10–20 session horizon, dominant value loss-prevention. Order-of-magnitude only.

**Additional levers (ROI-ranked):**
- **Capability/deployment-surface pre-flight for fix-plans (~10–20k tokens/recurrence).** This audit's verdict is downstream of a fix campaign that under-scoped its deployment surface. An "enumerate every settings layer the fix must touch (user / workspace / ai-resources / all N project repos) before declaring done" check at fix-plan intake would prevent the coverage-gap class. Lower frequency, large per-occurrence.
- **Codify "verify display artifact vs file defect before logging friction" (~1–3k tokens/session when applicable).** Make the file-first check a one-line intake rule in friction-log / `/note` guidance.
- **Pin the audit-memo path in the umbrella PENDING improvement-log entry (~0 tokens/fix).** Prevents a future build session re-running the ~15-repo grep inventory. (Already done — the entry names the audit doc as authoritative.)

## 2026-07-03 — Quarterly /friday-checkup (ai-resources + workspace + 6 projects) with mid-run concurrent-session collision recovery

### 2026-07-03 | Acceptable

**Task:** Quarterly `/friday-checkup` across ai-resources + workspace + 6 projects (audit-repo GREEN, `/improve` 11 findings, `/coach` 2 hubs, 6 project CLAUDE.md audits, token-audit ai-resources-only, inline log-sweep, W2.4 report, Stage-5 anchor PASS), with a live concurrent-`/friday-checkup` collision folded in mid-run. Diagnostic-only — no fixes applied. Independent outcome-check: DELIVERED / EXECUTION ACCEPTABLE (8/10).

| Metric | Value |
|--------|-------|
| Exchanges | not reported (≥7 AskUserQuestion gates listed: recovery/tier/scope/trim/coach-scope/collision/preflight) |
| Files read | not reported — heavy (6 project CLAUDE.mds, logs, prior reports, one shared claude-md guidance file); re-reads: 0 flagged |
| Files written/edited | ~10+ (approx; consolidated checkup report, improvement-log ×11 findings, session-notes, usage-log, subagent working-notes; diagnostic-only — no fixes) |
| Tool calls | not reported — heavy (many Bash git cross-checks / log inventories / guards, Reads, Edits, ≥7 AskUserQuestion) |
| Subagents | ~16 (1 repo-health lead → 7 auditors, 7 improvement-analysts, 2 collaboration-coaches, 6 claude-md-auditors, 1 token-audit orchestrator + sub-auditors, 1 outcome-check, 1 telemetry) |
| Rework cycles | 1 substantive (premature subagent TaskStop, self-corrected) + 2 minor (concurrent-collision fold, Edit-before-Read retry); 0 data-loss |

**Findings:**
- **Premature TaskStop of a slow-but-healthy subagent — Moderate (Tool overhead).** A token-audit Section-4 auditor ran ~12 min, was misjudged as stalled and TaskStop'd, then completed with real findings. No data lost, but the intervention was wasted and risked killing a healthy subagent mid-write — the same shared-write / subagent-contract data-loss class flagged in the S1/S3 entries. Lever: document expected runtime for known-slow auditors so a long-runner isn't misread as stalled.
- **Concurrent-session collision handled by folding, not redoing — positive (efficiency).** The operator stopped the other `/friday-checkup`; this session resumed as sole owner and folded in its 2 committed artifacts (permission-sweep + a claude-md-audit) rather than re-running them. Correct recovery; avoided ~2 duplicated audit reruns. Recovery cost was contained (1 AskUserQuestion + git cross-checks).
- **Fan-out well-parallelized and context-disciplined — positive.** ~16 subagents mostly ran as parallel same-type batches (7 auditors, 7 analysts, 6 claude-md-auditors, 2 coaches), each writing notes to disk and returning summaries per the subagent contract — so context stayed bounded despite the scale.
- **Operator scope trims actively managed cost — positive.** Deferred 6 project coaches and the workspace token-audit, and skipped the findings-extractor (data already in context), to hold the documented 1M-credit exhaustion risk. Reused one shared claude-md guidance file across all 6 project audits instead of reloading it per-agent.
- **Edit-before-Read retry on session-notes after a bash append — Minor (Tool overhead).** One trivial tool-order retry; no cost beyond the retry.
- **Trend vs last 3 entries (S6 Efficient / S1 Acceptable / S3-cont Efficient):** slight regression to Acceptable, but proportional to scale — a quarterly fan-out of ~16 subagents plus an external collision, not a discipline slip; the two Moderate findings are contained and self-corrected.

**Recommendation:** Document an expected-runtime band for known-slow fan-out subagents (token-audit Section-4 is the recurring example, ~12 min) — e.g., a one-line "do not TaskStop a Section-4 / mechanical auditor before ~15 min absent a hard error" note in the token-audit / fan-out orchestration guidance. Highest-leverage because it prevents both the wasted intervention and the real risk (killing a healthy subagent mid-write, an unrecoverable data-loss class the log already tracks in S1/S3).

**Estimated savings:** A premature-TaskStop event costs ~2–4k tokens (monitoring turns + the TaskStop call + re-verifying the subagent actually finished). Frequency ~1 per 3–4 substantive fan-out sessions with a known-slow auditor → ~6–12k over a 10–20 session horizon. Token saving is modest; the dominant value is loss-prevention — a TaskStop that lands mid-write on an append-only notes file is unrecoverable from context. Order-of-magnitude only.

**Additional levers (ROI-ranked):**
- **Codify the concurrent-collision "fold, don't redo" recovery step (~20–40k tokens/collision).** This session avoided re-running 2 committed audit artifacts by folding the stopped session's commits. Making "on collision recovery, inventory the other session's committed artifacts and fold rather than re-run" an explicit `/friday-checkup` (and parallel-sessions-playbook) recovery step would repeat this saving deterministically. Largest per-occurrence, but low frequency — collisions are rare.
- **Shared-guidance-file reuse across parallel same-type auditors (~3–6k tokens/fan-out).** One claude-md guidance file was reused across 6 auditors instead of each reloading it. Codifying "hand parallel same-type agents a single shared reference path, not per-agent inline copies" as a fan-out orchestration default generalizes to every multi-auditor command. Moderate frequency, moderate per-occurrence.
- **Operator scope-trim as a first-class cost lever (~10–30k tokens/large session).** The deferrals (6 project coaches, workspace token-audit, findings-extractor skip) held a real 1M-credit exhaustion risk. Surfacing a "trimmable scope" menu at fan-out planning time (before spawning) rather than mid-run would let the operator trim before the tokens are spent. Broad applicability; savings scale with session size.

### 2026-07-03 | Wasteful

**Task:** Ran `/friday-act` against the quarterly checkup report — triaged 21 tactical items into 8 QC'd plan files, archived 5 stale improvement-log entries, then ran `/wrap-session` including a mid-wrap foreign-session guard fire requiring a standalone recovery commit.

| Metric | Value |
|--------|-------|
| Exchanges | 14 (+11 AskUserQuestion structured gates) |
| Files read | 13 (re-reads: 5 files — session-notes.md, decisions.md, usage-log.md, improvement-log.md, friction-log.md; 1 of the 13 was a nonexistent-file attempt) |
| Files written/edited | 19 |
| Tool calls | ~123 total (Bash ~55, Read ~20, Edit ~15, Write ~11, AskUserQuestion 11, Agent 4, Skill 6, ScheduleWakeup 1) |
| Subagents | 4 |
| Rework cycles | 1 (tool-execution retry — sed chain denied and re-issued as 5 separate calls; not artifact-level rework) |

**Findings:**
- Re-reads (Major): logs/improvement-log.md (~627 lines / ~46k tokens) was traversed 3-4 times via 4 different mechanisms (2 Read calls, a grep pass, and a Python `open()` pass) for a single classification task; logs/session-notes.md (~640 lines by session end) was re-read/re-scanned 4+ times during the wrap sequence (Step 1 grep+offset, Step 3.5 guard greps x2, tail checks).
- Re-reads (Moderate, secondary): logs/decisions.md, logs/usage-log.md, and logs/friction-log.md were each read twice (once during /prime pre-fetch, once later in the session).
- Tool overhead (Moderate): a chained 5-part sed Bash call was denied by a permission heuristic and had to be re-issued as 5 separate single-line calls; a wrap-time recovery commit unexpectedly swept in 3 pre-staged files, requiring 3 follow-up git show/diff calls to verify benign content.
- Rework (Minor): a malformed disposition string appeared in one AskUserQuestion prompt (contradicted its own option description) but was self-caught with no user-facing redo — a near-miss, not a realized cycle.
- Missed parallelization: none observed — three long-running subagents (157s/258s/497s) were awaited via ScheduleWakeup/notification rather than polled.
- Trend: regression — the prior three entries were Acceptable (same-day quarterly checkup), Efficient (S6), Acceptable (S1); this is the first Wasteful rating in that run, driven by the Major re-read flag on two large log files.

**Recommendation:** Consolidate multi-pass processing of large log files (especially logs/improvement-log.md) into a single read/extraction pass — when a file must be both read for content and programmatically classified, use one mechanism (a single Python pass, or one grep+Read combo) rather than layering Read x2 + grep + python `open()` on the same file.

**Estimated savings:** Roughly 15,000-25,000 tokens this session — ~5-7k from improvement-log.md's extra grep+python passes beyond its first full read (~46k tokens), ~6-10k from session-notes.md's 4+ partial wrap-time re-scans, ~3-9k from the second reads of decisions.md/usage-log.md/friction-log.md, plus ~2k from the sed-chain retry and swept-file verification overhead. Over a 10-20 session horizon (if the resolve-improvement-log + wrap-session combo recurs at similar frequency), this projects to roughly 150,000-400,000 tokens.

**Additional levers (ROI-ranked):**
- Cache session-notes.md content from its first wrap-time read and reuse it for subsequent guard checks (Step 3.5 x2, tail checks) instead of re-querying the file — ~6-10k tokens/session, applies to every /wrap-session run with a guard-fire scenario.
- Replace separate full-tail-then-grep passes on decisions.md/usage-log.md/friction-log.md with a single targeted grep -A/-B call — ~1-3k tokens per file when applicable.
- Batch multi-append log operations (like the 5 sed appends) as one heredoc/script file rather than a chained command likely to trip the permission heuristic — ~2k tokens/session, low-frequency (only fires on multi-append log operations).

### 2026-07-12 (S5) | Wasteful

**Task:** Wired both paired copies of `wrap-session.md` to write the run-manifest's `decisions_refs` at close — the blocking prerequisite for R3 Pass 2 (mission `w32-migration-execution`). Two gate-driven redesigns (QC REVISE → slug algorithm moved from prose into code; risk-check RECONSIDER → two silent-failure paths closed + 11 regression assertions). Landed 18 files across 3 repos. Ran past midnight into 2026-07-13.

| Metric | Value |
|--------|-------|
| Exchanges | ~5 (initial direction, mandate confirm, one "continue", wrap) |
| Files read | ~12 (re-reads: 0 genuine — but 2 files needed a second paged `Read` after hitting the 25k page cap: `improvement-log.md` 506 L, `friction-log.md` 329 L) |
| Files written/edited | ~19 (~14 Edit + 5 Write; 18 committed across 3 repos — ai-resources `3e3d0fe` 15, workspace root `54007f1` 1, redesign `f44411b` 2) |
| Tool calls | ~75 (Bash ~35, Edit ~14, Read ~12, Write ~5, Skill 5, Agent 4) |
| Subagents | 5 (risk-check-reviewer ×3 — plan-time ~152k/258s, end-time ~140k/471s, re-gate ~127k/346s; qc-reviewer ×1 ~74k/283s; telemetry ×1) — ~493k subagent tokens |
| Rework cycles | 2 artifact-level (both gate-caught, same artifact set) + 1 tool-execution retry |

**Findings:**
- **Rework (Major).** Two redesign cycles on the same artifact set (`spine-schemas` § 1 + both `wrap-session.md` copies): (1) `/qc-pass` REVISE forced the slug algorithm out of prose and into a code module; (2) end-time `/risk-check` RECONSIDER forced two silent-failure paths closed in that new module. Cycle 2 existed only because cycle 1 created the code — the chain compounded. **Cycle 1 was foreseeable:** the repo already held 3 orphaned hand-authored refs on disk as direct evidence that a prose recipe hand-executed by a model does not hold. Handing a deterministic string transform to a model as prose was unsound at design time, not merely in hindsight.
- **Context bloat (Moderate).** ~65k tokens of orientation reading: `improvement-log.md` (506 L) and `friction-log.md` (329 L) both read in **full** at `/prime`, both exceeding the 25k page cap. `friction-log.md` was never referenced again — its full load (~25–30k) was 100% waste. `improvement-log.md` was afterwards only targeted-Edited, so its full read was never needed either. `decisions.md` was correctly handled by grep/tail — the right pattern existed in-session and was not applied to its two larger siblings.
- **Subagent cost (Moderate).** ~493k subagent tokens on a change landing 18 files. Each gate was individually rule-mandated — plan-time (structural class), end-time (executed set grew materially past the plan-time set: `run-manifest.sh` moved from "no change" to modified, plus 2 new scripts), re-gate (required by RECONSIDER's own guidance). But the *sequence* is downstream of the rework finding: the executed-set growth that made the end-time check mandatory traces directly to the cycle-1 redesign. A sound first design plausibly collapses three risk-checks to two.
- **Tool overhead (Minor).** One malformed `git commit -- <paths> -m "msg"` — the `-m` after the `--` separator parsed as a pathspec; commit failed and was re-issued. One wasted call.
- **Positive — empirical failure-mode testing earned its cost.** Module-deleted / python3-absent / symlink-invocation / garbage-marker / non-UTF-8 probes cost a handful of Bash calls and found 2 real defects (one self-found: the checker tracebacked on a missing module). Best ROI in the session. The midnight rollover surfaced a third bug for free (the checker derived the date from the clock, not the session marker).
- **Trend:** second consecutive Wasteful. The large-log read class is a **repeat of the prior entry's own Major finding and Recommendation** — partially applied (`decisions.md` targeted) but never shipped for `improvement-log.md` / `friction-log.md`. The character differs (2026-07-03 was process sloppiness; this is design cost with the gates working correctly), but the rubric does not credit a good outcome.

**Recommendation:** Convert `/prime`'s reads of `improvement-log.md` and `friction-log.md` from full `Read` to targeted extraction (grep for open/PENDING status + `tail -N`), exactly as `decisions.md` is already handled. Primary over the design-time fix below: deterministic, fires on **every** session, one line to implement, and it is the second consecutive entry to flag it — the prior recommendation is still unshipped.

**Estimated savings:** ~50–60k tokens/session at orientation — `friction-log.md` ~25–30k (fully unreferenced → 100% recoverable) plus `improvement-log.md`'s full read reduced to a targeted extract, and it removes both page-cap continuation calls. Over 10–20 sessions: ~500k–1.2M tokens. Order-of-magnitude only.

**Additional levers (ROI-ranked):**
- **Design-time determinism check (~150–280k tokens/occurrence).** Add a plan-time rule: if a step requires a model to hand-execute a *deterministic transform* (slug derivation, ID generation, path normalization), it must be code, not a prose recipe. This is the root of the entire rework chain — it would have avoided cycle 1 (~15–25k main-session) *and* plausibly one of the three risk-checks (~130–150k). Lower frequency, harder to enforce; ~2–4 firings over 10–20 sessions.
- **Right-size the risk-check chain for gate-caused re-gating (~127–150k/occurrence).** A "re-gate scope" mode that re-scores only the *delta* rather than re-running a full six-dimension review over the whole change. Fires on any RECONSIDER.
- **Keep the big logs under the page cap at the source (~5–8k/session).** Both are append-only and archived; a tighter archive threshold would remove the second paged read entirely. Bank only if the archival cadence is already being touched.

### 2026-07-13 (S3) | Efficient

**Task:** Executed the authoritative repo-redesign report: verified RR-01 + RR-02 against their completion conditions, shipped RR-03 (the wrap-note cut) across both paired `wrap-session.md` copies + 4 downstream readers, archived the superseded W3.2 mission. One `/risk-check` (operator-prompted after I wrongly decided to skip it) caught a real defect and forced a structural mitigation.

| Metric | Value |
|--------|-------|
| Exchanges | ~6 (prime, mission-conflict redirect, "start executing", "risk check?", "note to friction-log", wrap) |
| Files read | ~8 (targeted; no full reads of `improvement-log.md` / `friction-log.md` — the prior 2 entries' Major finding, applied) |
| Files written/edited | 13 (6 RR-03 targets + report + risk-check report + 4 logs + manifest) |
| Tool calls | ~40 (Bash ~26, Edit ~11, Read ~4, Agent 1, Skill 3) |
| Subagents | 1 (`risk-check-reviewer`, ~174k / 445s) |
| Rework cycles | 1 (the risk-check mitigation — gate-caught, not self-caught) |

**Findings:**
- **The near-miss is the headline, and it was caught by the operator, not by me (Major, process).** I decided to skip `/risk-check` on a change touching two paired command copies and two agents symlinked into 14–21 projects, reasoning from the report's *"No approval gates"* and RR-03's *"ship it in one pass."* The report's own line 39 says in bold the gates are **not** waived. I let a document's rhetorical direction override its explicit text. The operator's one-line question (*"Are you running risk check on these too?"*) was the highest-ROI intervention of the session: the gate returned PROCEED-WITH-CAUTION and found a defect my own workspace-wide grep had missed — `positioning-research` runs a *forked* wrap with no manifest, so the repointed readers would have silently zeroed its file signal. **Cost of the gate: ~174k subagent tokens. Cost of shipping the bug: a silently degraded coaching instrument across an unknown number of future sessions, in the exact projects least likely to be noticed.** The gate paid for itself outright.
- **Positive — the prior two entries' Recommendation finally shipped, and it worked.** Both 2026-07-12 (S5) and its predecessor flagged the same Major finding: `/prime` full-reading `improvement-log.md` (506 L) and `friction-log.md` (329 L), ~50–60k tokens/session, `friction-log.md` 100% unreferenced. This session hit that exact trap once at `/prime` (a 204 KB persisted-output dump), **noticed it in-flight, and re-issued as targeted greps** — then stayed on targeted extraction for the rest of the session. Third consecutive entry to raise it; first to act on it. **Convert to a `/prime` edit rather than relying on in-session recovery** — I only caught it because I had just read the telemetry that named it.
- **Positive — verification before ceremony.** RR-01 and RR-02 arrived with commits but no verification. Checking them cost ~4 Bash calls and confirmed both; had either failed, RR-03 would have been built on sand. Cheap, and it is the report's own operating rule (evidence before queue entry) applied to its own results table.
- **Positive — the reviewer's mitigation was improved, not accepted.** It proposed syncing `positioning-research` onto canonical. I checked `shared-manifest.json`, found `wrap-session` classed `"local"` — so *every* template-deployed project forks it by design — and chose a reader-level fallback instead. Accepting the reviewer's fix verbatim would have left the next project broken. **A gate's finding is authoritative; its proposed remedy is not.**
- **Minor — 2 permission denials on compound Bash** (`&&`-chained `git mv` + `ls`). Split into single commands; ~3 wasted calls. Pattern: chained shell with `;`/`&&` and quoted `===` echoes trips the permission matcher.
- **Trend: breaks a two-session Wasteful streak.** Not because nothing went wrong — a real defect was nearly shipped — but because the miss was caught at the gate, the fix was structural rather than patched, and the token profile stayed lean (one subagent, targeted reads, no rework spiral).

**Recommendation:** Ship the `/prime` fix that three consecutive telemetry entries have now named — convert the `improvement-log.md` / `friction-log.md` reads from full `Read` to grep-for-open-status + `tail -N`, exactly as `decisions.md` is already handled. It is one line, fires every session, and this session demonstrated that *knowing about it* is not a substitute for *fixing it* (I walked into it anyway and recovered only by luck of having just read the telemetry).

**Estimated savings:** ~50–60k tokens/session at orientation; ~500k–1.2M over 10–20 sessions. Unchanged from the prior two entries — because it is unchanged work.

**Second lever (new, from this session's near-miss):** the report's anti-ceremony framing is a **live re-reading hazard** for any future session executing from it. The `decisions.md` entry now states the rule (*a plan may retire its own gates; it cannot waive a standing workspace rule*), but a rule in the decision journal is not read at execution time. Cheapest durable fix: one line in the report itself, at RR-03's "ship it in one pass," clarifying that this means *do not re-derive the P1/P2 prerequisite*, **not** *skip `/risk-check`*. ~10 tokens; prevents a repeat of a defect that a 174k-token gate had to catch.
