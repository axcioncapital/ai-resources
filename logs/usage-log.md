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
