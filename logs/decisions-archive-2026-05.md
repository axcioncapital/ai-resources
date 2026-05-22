# Decision Journal — Archive 2026-05

## 2026-05-02 — Revert token-audit M1 (Read(audits/working/**) deny rule)

**Context.** Token-audit 2026-05-02 M1 recommended adding `Read(audits/working/**)` to the ai-resources deny list to prevent "future sessions from reading stale working notes during exploration." Implemented in commit 9992cf2; end-time `/risk-check` flagged a load-bearing conflict.

**Decision.** Revert M1. The deny rule blocks two existing main-session reads that operate within the same session that produces the working notes:
- `/innovation-sweep` Step 7.27 (`commands/innovation-sweep.md:134`) — main session reads the just-written `WORKING_NOTES_PATH` to render the triage report.
- `/audit-critical-resources` Step 26 (`commands/audit-critical-resources.md:200`) — main session iterates each per-resource working-notes file to extract per-resource sections for the final report.

**Rationale.** The audit's premise — that working notes are "intermediate artifacts not consumed by active commands" — was wrong. Both commands legitimately read working notes within the same session. A blanket deny would break both workflows on next invocation. The audit's protective value (situational, MEDIUM) is outweighed by the operational cost of broken commands.

**Alternatives considered.**
- *Scope deny rule narrowly (e.g., `Read(audits/working/scratch/**)`).* Rejected: would require migrating files from working/ to working/scratch/ and updating both command paths. Net cost > revert.
- *Update both commands to consume working-notes via a synthesis subagent (mirror H5 pattern).* Deferred: structural refactor of two commands; not within scope of this fix session. May revisit if a future audit re-flags working/ as a token-cost issue.
- *Keep the rule and document the conflict.* Rejected: silent breakage on the next /innovation-sweep or /audit-critical-resources run.

**Follow-up.** If working/ ever becomes large enough to warrant exclusion, the right pattern is the H5-style subagent delegation, not a blanket deny rule.

---



**Context.** /permission-sweep 2026-05-01 flagged a CRITICAL Rule 4 finding: "allow list missing entries" for ai-resources/.claude/settings.json. The report itself noted a bypass-mode caveat.

**Decision.** Finding is a false positive. No changes to settings.json. Auditor Rule 4 needs a bypass-mode exception.

**Rationale.** `defaultMode: bypassPermissions` is the agreed operator setup (per memory feedback_zero_permission_prompts.md). Under bypass mode, the allow list is a secondary safety layer, not the primary enforcement mechanism. The auditor's "missing entries" rule does not model this design. The correct fix is an auditor rule exception, not a file change.

**Alternatives considered.**
- *Add all flagged allow entries.* Rejected: redundant under bypass mode; adds noise to an intentionally minimal list; contradicts operator's zero-permission-prompt posture.

---

## 2026-05-02 — MCP servers culled to github-only

**Context.** Session evaluated 16 installed MCP plugins against actual Axcion workflow usage. Claude Code loads every enabled plugin's tool schema on every turn regardless of use — each plugin consumes context permanently.

**Decision.** Keep only github. Disable all 15 others (asana, context7, discord, fakechat, firebase, gitlab, greptile, imessage, laravel-boost, linear, playwright, serena, supabase, telegram, terraform) by renaming their `.mcp.json` to `.mcp.json.disabled`.

**Rationale.** Operator confirmed only github is actually used in Axcion sessions. 15 unused plugins were loading tool schemas into context on every turn with zero benefit. Disabling is reversible — rename `.mcp.json.disabled` back to `.mcp.json` to re-enable any plugin.

**Alternatives considered.**
- *Keep linear:* considered given Axcion uses Linear for task tracking. Operator declined — not accessed via Claude Code sessions.
- *Keep all and rely on ≤10 guideline:* rejected — guideline is from source document, not authoritative; actual usage confirmed 15 of 16 unused.

---

## 2026-05-02 — Context engineering checks: token-audit Section 8 vs. alternatives

**Context.** Operator found Anthropic's context engineering article and wanted to incorporate its best practices into the audit infrastructure. Three structural options were considered: (1) standalone context-audit command, (2) new section in friday-checkup, (3) extending token-audit Section 8.

**Decision.** Extend token-audit Section 8 (Best Practices Comparison). Added items 13–15 covering inter-skill trigger disambiguation, structured agent/skill prompts, and few-shot examples. Protocol bumped to v1.3.

**Rationale.** Token-audit already runs monthly via friday-checkup; extending Section 8 gives automatic friday cadence coverage with no structural changes to either command. Section 8 is already an "article-derived best practices" checklist — the new items fit the existing pattern exactly. Creating a standalone command or new friday-checkup section would add maintenance surface for the same analytical work.

**Alternatives considered.**
- *Standalone /context-audit command.* Rejected: separate command to maintain; same coverage achievable by extending token-audit.
- *New §L section in friday-checkup.* Rejected: requires friday-checkup edits; token-audit already runs monthly there.
- *Extend token-audit + add to friday-checkup.* Rejected: redundant; token-audit already wired in.

## 2026-05-02 — Cluster analysis gate granularity

**Context:** Rewriting /run-cluster to use parallel subagents required choosing whether the operator review gate stays per-cluster (one pause per cluster as each memo is produced) or consolidates to per-section (one pause after all clusters complete).

**Decision:** Per-section gate. All refined cluster memos reviewed together at the end of /run-cluster.

**Rationale:** Parallel subagents produce all memos simultaneously, so per-cluster gating would require an artificial serialization that defeats the parallelism benefit. Per-section review is also more coherent — the operator sees all analytical threads at once before deciding whether to proceed. This matches the existing pattern in /run-synthesis. Operator confirmed without modification.

**Alternatives considered:**
- *Per-cluster gate (status quo).* Rejected: incompatible with parallel execution; would require sequential dispatch with artificial waits.
- *Hybrid: per-section but with early-abort option.* Not needed — if a cluster memo has issues, the operator reviews them all anyway and can redirect before /run-analysis.

---

## 2026-05-07 — Alternatives-selection format for Bird & Bird lunch prep

**Context:** Preparing conversational answers to 7 questions for a relationship-building lunch with a Bird & Bird senior associate. Initial approach: produce full drafted answers in one pass. Operator reviewed a first draft and switched approach mid-session.

**Decision:** Produce 3 alternative framings (A/B/C) per question instead of a single draft. Operator selects the framing that matches their natural voice; a final assembly pass combines the choices.

**Rationale:** Full drafts are in the assistant's voice and require significant rewriting to feel natural. The alternatives format treats the operator as the voice owner and the assistant as a framing generator — faster to calibrate, less rewriting, more likely to produce answers the operator can actually use at lunch. Operator requested this explicitly.

**Alternatives considered:**
- *Full draft + revision loop.* Rejected: requires the operator to identify what sounds wrong, which is harder than choosing between concrete alternatives.
- *Open-ended questions to surface the operator's voice first.* Not raised — operator moved directly to the alternatives format.

---

## 2026-05-07 — Q5 scoped to successes only

**Context:** Q5 as originally posed was two-part: "which workflows have you successfully handed over to AI, and which ones did you try to automate but ended up pulling back from?" The initial draft flagged the second half as needing a real example from the operator.

**Decision:** Answer only the first half. Drop "which ones did you try to automate but ended up pulling back from" from scope.

**Rationale:** Operator directed this explicitly. The successes half can be answered confidently from the service model design; the failures half requires lived operational experience that may not yet exist at this stage of the business. Answering only the first half avoids a gap that could undermine credibility at the lunch.

**Alternatives considered:**
- *Keep both halves, leave second half with placeholder.* Rejected by operator — unnecessary scope for this meeting.

---

## 2026-05-02 — Quality log location for cross-project extract tracking

**Context:** Adding a cross-project extract quality log raised the question of where it lives: inside ai-resources/logs/ (portfolio-level, one file) vs inside each deployed project's own logs/ directory (local, per-project).

**Decision:** Local log at `workflows/research-workflow/logs/research-quality-log.md`. Each deployed project writes its own quality log; cross-project aggregation is manual when needed.

**Rationale:** Workspace CLAUDE.md prohibits editing ai-resources skill files from project workspaces. While log-append is a different operation, putting the log in ai-resources would introduce a new cross-repo write convention that needs explicit policy exception. Local logging keeps each project self-contained and requires no policy change. The cost is that cross-project comparison requires manually aggregating individual project logs.

**Alternatives considered:**
- *ai-resources/logs/research-quality-log.md.* Rejected: requires cross-repo write from project sessions; introduces new convention that contradicts existing "no editing ai-resources from project workspaces" posture.

## 2026-05-05 — Weekly cadence: full `/audit-claude-md` on Monday (guarded)

**Context:** Designing the Monday infrastructure check. Initial plan used a lightweight CLAUDE.md pointer scan (grep for broken `@`-references only). Operator stated intent was "audit CLAUDE.md for the projects I will be working on this week."

**Decision:** Use the full `/audit-claude-md project <name>` command, guarded by a dual condition: skip if CLAUDE.md was not modified in the last 14 days AND is under 100 lines. Both conditions must hold to skip.

**Rationale:** The pointer scan would miss redundancy, staleness, token bloat, and misplacement — the real maintenance value. The guard prevents the Opus subagent from firing on unchanged, small files where the cost exceeds the benefit.

**Alternatives considered:**
- *Lightweight scan every Monday.* Rejected: misses the token-cost and redundancy signals that make the audit valuable.
- *Full audit unconditionally.* Rejected: Opus-tier subagent on every Monday is too heavy when CLAUDE.md hasn't changed.

## 2026-05-05 — Weekly cadence: `/so-monthly` not `/systems-review` for monthly Friday slot

**Context:** Designing the monthly Friday slot. Initial draft used `/systems-review` as the command name. QC pass identified this as incorrect — `/systems-review` does not exist as a deployed command.

**Decision:** Replace `/systems-review` with `/so-monthly` (project-local at `projects/axcion-ai-system-owner/.claude/commands/so-monthly.md`). This is the correct command for the monthly systems-level review function.

**Rationale:** `/so-monthly` is the deployed command. It reads the past month's Friday advisories and deferred items, aborts automatically on weekly tier, and writes to `output/monthly-reviews/`. Verified by reading the command file directly.

**Alternatives considered:**
- *Create `/systems-review` as a new command.* Rejected: `/so-monthly` already serves the stated purpose. Creating a duplicate would add unnecessary infrastructure.

## 2026-05-08 — /friday-act reads SO outputs same-Friday with manual paste

**Context:** This week's /systems-review on (4 projects + operator-maintenance-cadence) named Loop 3 (System Owner outputs → action) as open: today's /friday-so advisory and /systems-review report were not consumed by /friday-act, so their findings were orphaned from the Friday Session 2 action loop. Operator directed closing the loop.

**Decision:** Patch /friday-act to read the freshest System Owner outputs same-Friday (Shape A) and accept actionable items via manual paste (option b). Specifically: Step 1.5 locates the freshest friday-advisory (newest by `(date, vN-as-int)` where vN suffix is parsed as integer) and the freshest systems-review (newest by date, with mtime fallback for same-day matches), filtered to ≥ checkup date and ≤ 7 days old. Step 3.5 displays the first 30 lines of each available file and prompts the operator to paste actionable items as `[risk] {text}` for the same disposition loop as checkup-derived items.

**Rationale:**
- *Same-Friday over cross-week absorb (Shape A over Shape B):* Cross-week absorption (in /friday-checkup) would introduce a 7-day delay between SO advisory production and action. The systems-review explicitly flagged delay-shortening as the right direction (LP 9 — "when delay can't be shortened, slow the rate of change; here we *can* shorten the delay"). Same-Friday closing matches the operator's mental model: today's action session sees today's analysis.
- *Manual paste over auto-extract (option b over option a):* The SO outputs are prose (executive summary, narrative leverage points), not structured tables. Auto-extracting "candidate items" would require a parser tied to the producer's current prose conventions — shape-fragile coupling that would silently break the day someone changes the executive-summary format. Manual paste preserves operator judgment over what's actionable and decouples /friday-act from producer-side prose drift.

**Alternatives considered:**
- *Shape B (cross-week absorb in /friday-checkup):* Rejected — introduces 7-day delay; contradicts systems-review LP 9.
- *Auto-extract from SO outputs:* Rejected — parsing fragility, shape-coupling risk, and the SO outputs are intentionally prose for operator interpretation, not machine extraction.

---

## 2026-05-08 — /friday-journal report shape: flat-regex Items block over heading-blocks

**Context:** The new `/friday-journal` command produces a report consumed by `/friday-act` Step 3.5. The first plan draft used heading-plus-multi-field blocks per item (target / outcome / priority / files / approach as separate fields under each `### Item N` heading). QC flagged that this would force a parser change in `/friday-act` to extract dispositionable lines.

**Decision:** Restructure the report so `## Items` is a flat list — each line matches the existing `^\[(high|med|low)\] .+$` regex one-for-one, sorted high → med → low. Operator-readable detail (files, effort, recommended approach, source entry) lives in a parallel `## Item context` section that the parser ignores. The directive text in `## Items` and the heading in `## Item context` MUST be identical so the two halves stay coupled.

**Rationale:**
- *Zero parser change in /friday-act:* Step 3.5's existing regex applies unchanged. The journal report is structurally interchangeable with a paste-buffer of `[risk] {text}` lines — same shape, same disposition loop, same risk-check gate.
- *Schema-contract pattern mirrors checkup→act:* The existing producer (`/friday-checkup`) and consumer (`/friday-act`) pair already uses an explicit callout naming the regex on both sides. Same pattern reused here — callout block in `friday-journal.md` Step 5 sub-step 14 references `friday-act.md` Step 3.5 sub-step 16f, and vice versa. Producer-side schema drift is caught at edit time because the bi-directional reference forces the editor to see both ends.
- *Detail preserved without parser noise:* Operator-readable context (effort, files, approach, source-entry verbatim) still ships in the same report — just below the data contract, not embedded in it.

**Alternatives considered:**
- *Heading-blocks (original draft):* Rejected — forces a new parser in `/friday-act` Step 3.5 specifically to extract dispositionable lines from multi-field blocks; couples consumer to producer's prose layout.
- *Two separate report files (data + context):* Rejected — locator complexity, dual auto-load logic, and the operator only needs one file open per Friday.

---

## 2026-05-08 — Same-day collision handling for friday-journal: overwrite-with-prompt over -vN suffix

**Context:** `/friday-journal` writes to `audits/friday-journal-YYYY-MM-DD.md`. If invoked twice on the same Friday (e.g., operator added a new entry mid-Friday and re-ran), there will be two reports for the same date. The repo's established pattern for analytical revisions is `vN.md` alongside `v1.md` (workspace CLAUDE.md "Working Principles").

**Decision:** Use overwrite-with-prompt instead of `-vN` suffix. On collision: prompt operator `(o)verwrite | (a)bort`. On `o`: replace existing file. On `a`: leave previous report standing.

**Rationale:**
- *Lex-sort tiebreaker is broken by `-`:* `/friday-act` Step 1.5 locator sorts files by parsed date, and on date-tie falls back to lex-order. The character `-` (0x2D) sorts before `.` (0x2E) in ASCII, so `friday-journal-2026-05-08-v2.md` lex-sorts BEFORE `friday-journal-2026-05-08.md`. Result: `/friday-act` would pick the v1 file — the older, superseded one — and silently ignore the v2.
- *Single canonical file per day removes the ambiguity:* No suffix scheme means no tiebreaker logic to get wrong. The locator's existing single-glob path stays correct.
- *Operator gate on overwrite preserves recovery:* The (o/a) prompt makes the destructive step explicit. Git working tree is the recovery path if the operator regrets.

**Alternatives considered:**
- *`-vN` suffix (workspace convention):* Rejected — breaks `/friday-act` Step 1.5 locator due to ASCII sort order. Would require adding tiebreaker logic specifically for journal reports, which the consumer already handles for SO advisories via `(date, vN-as-int)` parsing — not worth duplicating for a report that has no operator-driven need for revision history.
- *Append-mode (merge new items into existing report):* Rejected — would require a partial parser/merger; risk of duplicate items if operator re-adds the same journal entry; complicates the archive step.
- *No change (leave Loop 3 open):* Rejected — operator explicitly directed closing the loop.

## 2026-05-08 — /friday-act plan-branching architecture

**Context:** `/friday-act` now receives fix-now items from four sources (checkup, friday-so, systems-review, friday-journal). The volume on heavy Fridays exceeds what one implementation session can carry. A plan-branching refactor was scoped through /clarify → /scope → 2× /qc-pass → plan approval.

**Decision:** Remove inline execution from `/friday-act` entirely. All fix-now items are collected into `FIX_NOW_ITEMS` across all three disposition loops (Steps 3, 3.5 SO-derived, 3.5 journal-derived), then written to plan files under `audits/friday-plans/` by new Step 3.6. Threshold: ≤ 4 items → one `{date}-consolidated.md`; > 4 → one `{date}-{area-slug}.md` per file/area group. The `/risk-check` change-class gate and W2.4 `(a)/(b)` sub-disposition are both deferred to execution time (follow-up session), annotated in the plan file.

**Rationale:**
- *Single execution model over threshold-conditional dual path:* Maintaining two paths (inline for light Fridays, plan-only for heavy) doubles bug surface and creates a week-to-week mental model flip. A single always-plan-only path is simpler and produces an audit-trail artifact even on light Fridays.
- *Area-slug split over source-split or risk-split:* Minimizes context-switching cost per follow-up session — each plan covers one file/area, so the executor doesn't jump between unrelated subsystems.
- *Gate deferred to execution time:* /risk-check runs are Opus-tier and heavy. Running them during /friday-act disposition would compound the session weight the refactor was designed to reduce.

**Alternatives considered:**
- *Threshold-conditional with inline path preserved:* Rejected — dual-path maintenance, arbitrary threshold behavior, doesn't fully solve heavy-Friday problem.
- */risk-check at plan-write time:* Rejected — adds Opus subagent load during disposition; gate is more useful immediately before execution when the operator has full context.
- *W2.4 sub-disposition at queue time:* Rejected — operator prefers to decide auto-draft vs. manual at execution time when they can see the full plan.

## 2026-05-08 — Drop `entry_count ≤ items_generated` from Step 5.4 consistency check

**Context:** /friday-journal Step 5.4 originally included a frontmatter consistency rule: `entry_count ≤ items_generated`. Today's run had 32 journal entries → 31 items (3 drops, 4 merges, 4 splits). The inequality fired as a false failure — drops+merges outnumbered splits, flipping the expected relation.

**Decision:** Remove the inequality entirely. Step 5.4 now only checks `items_generated == count of ## Items lines`. `entry_count` vs `items_generated` divergence is not an error condition — it is the expected outcome of splits, merges, and drops.

**Rationale:** The original rule assumed entries always expand into more items. In practice, drops and merges contract the count. The only invariant that actually matters is schema consistency: the `items_generated` frontmatter field must match the literal count of `## Items` lines in the file.

**Alternatives considered:**
- *Keep inequality with bounds:* No clean bounds exist — ratio is unspecified and could be any value depending on how many entries were dropped/merged.

## 2026-05-08 — Reuse qc-reviewer for /friday-journal gate vs. create dedicated agent

**Context:** /friday-journal Step 5.5 needed an output-validation subagent for journal-specific concerns (contradictions, currency drift, already-done, vagueness, risk-class).

**Decision:** Reuse existing `qc-reviewer` agent; pass journal focus areas as scope context in the spawn prompt. No new agent file.

**Rationale:** qc-reviewer's 6-dimension rubric (Request Match, Scope Creep, Risky Assumptions, Things That Could Break, Simpler Alternative, Sibling Redundancy) maps naturally onto journal-output concerns — proven by running a manual /qc-pass today that caught real issues. A new agent would duplicate agent scaffolding without unique value. Journal-specific focus areas steer *what* the rubric looks for, not *how* it evaluates.

**Alternatives considered:**
- *New `friday-journal-qc` agent:* Rejected — code duplication, additional maintenance surface, no capability gained.

---

## 2026-05-08 — {{WORKSPACE_ROOT}} placeholder: operator decision deferred to execution

**Context:** `research-workflow/.claude/settings.json` contains literal `{{WORKSPACE_ROOT}}` in `additionalDirectories`. This is a 3-cycle recurrence (v1 monthly checkup, v1 SO advisory, 2026-05-08 checkup). Prior /friday-act revision auto-picked "replace with absolute path" without surfacing the operator decision.

**Decision:** Restore as an explicit operator (a)/(b) choice at execution time — not pre-resolved in the plan file. (a) document as a `/deploy-workflow` template marker + add audit exclusion; (b) replace with absolute path as deployed copy.

**Rationale:** SO Rec 2 calls out OP-3 (loud failure over silent continuation) — three cycles without deciding reinforces an anti-pattern. Auto-picking removes the operator's ability to declare intent about whether this file is a template source or a deployed instance.

**Alternatives considered:**
- *Auto-pick (b):* Rejected — prior /friday-act revision did this and operator corrected it; decision belongs to operator.

---

## 2026-05-08 — Settings plan items 5+6 coupled: must land together

**Context:** Settings plan has item 5 (fix {{WORKSPACE_ROOT}} symptom in research-workflow settings) and item 6 (fix permission-sweep-auditor template-class classification = the upstream reason the recurrence repeats every cycle).

**Decision:** Items 5 and 6 must land together in the same execution session.

**Rationale:** Item 6 is the durable fix — the auditor cannot distinguish template source from deployed instance, so without it, the recurrence continues regardless of what item 5 decides about the placeholder. Landing 5 alone clears this cycle but guarantees a fourth occurrence.

**Alternatives considered:**
- *Land 5 first, 6 in a later session:* Rejected — leaves root cause intact for at least one more cycle, extending the 3-cycle anti-pattern.

## 2026-05-08 — /log-sweep: build new command vs extend check-archive.sh

**Context:** Operator asked whether to build a new log-archival command or rely on existing infra (`check-archive.sh`, `split-log.sh`, `/resolve-improvement-log`, `dd-log-sweep-agent`). Phase 1 inventory: 188 log files / 3.2 MB workspace-wide; `audits/working/` alone has 82 files / ~1 MB with no policy; `coaching-data.md` excluded from `check-archive.sh` due to `### ` headers; `usage-log.md`, `innovation-registry.md`, `session-plan.md`, `friction-log.md` and per-project `projects/*/logs/` dirs all uncovered.

**Decision:** Build `/log-sweep` as a wrapping orchestrator (new command + new auditor subagent + new helper script). Do not modify `check-archive.sh` or `split-log.sh`.

**Rationale:** Existing infra is solid but partial — `check-archive.sh` is hard-bound to `ai-resources/logs/` (`PROJECT_DIR` resolved from script location at line 12), covers only 2 of 16 active log files, and explicitly excludes `coaching-data.md`. Per-file scripts cannot be retrofitted into cross-project bulk inventory without changing their `/wrap-session` contract. Wrapping (subprocess calls + new helper for gap categories) preserves the existing contracts while extending coverage to all gap files and all `projects/*/logs/` dirs.

**Alternatives considered:**
- *Refactor `check-archive.sh` to take a scope argument:* Rejected — risks breaking `/wrap-session` contract; no benefit over wrapping.
- *Do nothing — current bloat is on-demand only (no auto-loading) and active logs are healthy:* Rejected — `audits/working/` has 82 ungoverned files, `coaching-data.md` and `usage-log.md` grow unbounded, and the 2026-05-01 token-audit explicitly flagged `audits/**` and `logs/` as MEDIUM-priority uncovered risk. Doing nothing leaves a known gap.
- *Per-file rotation rules baked into individual writers (e.g., `usage-analysis` self-rotates):* Rejected — distributes archival logic across many writers, defeats centralization, and doesn't address `audits/working/` (which has no single writer).

## 2026-05-08 — Concurrent-session guardrail: composite defense D+C+F vs single-option approaches

**Context:** J16 investigation into concurrent-session guardrail design for `projects/global-macro-analysis/`. Race manifested 2026-05-07 14:28 when `/kb-synthesize` archive `cp` captured another session's content. Six options evaluated: A (flock-lock), B (active-sessions.json), C (warn-only SessionStart hook), D (in-command SHA check), E (PreToolUse mtime hook), F (detect-and-recover only).

**Decision:** Composite defense — Layer 1: Option D (in-command SHA-256 check in `/kb-synthesize` and `/kb-review`); Layer 2: Option C (warn-only SessionStart hook); Layer 3: Option F (git recovery documented in CLAUDE.md). Pilot in `projects/global-macro-analysis/` only; 4-week post-pilot review before graduation.

**Rationale:** No single option is sufficient. D prevents the actual race (captures SHA at Read, recomputes before Bash cp/Write, aborts on mismatch). C provides cheap awareness for accidental concurrent-session situations. F is already in place implicitly; making it explicit costs nothing. The composite covers prevention + detection + recovery at low total implementation cost (~2.5 hours + one bundled /risk-check).

**Alternatives considered:**
- *Option A (flock-style advisory lock):* Rejected. Claude Code's PreToolUse hook fires per-call, not per-session — cannot hold a lock across multiple tool calls. Stale-lock recovery on crash is more confusing than the original race.
- *Option B (active-sessions.json stamp):* Rejected. TOCTOU race (check passes, Session B starts after check); stale entries on crash; per-tool JSON read overhead. No advantage over C without taking on A's lifecycle costs.
- *Option E (PreToolUse mtime hook):* Rejected. Must track which files the current session wrote to avoid false positives on its own writes — converges to Option B's complexity for marginal gain over D.
- *Option D alone:* Insufficient — doesn't raise operator awareness at session-start, when operator still has time to close the second terminal.

## 2026-05-08 — STALE detection deduplication across three commands

**Context:** Plan #3 initially proposed adding warm-pending age detection to both friday-act and friday-checkup, while also adding it to resolve-improvement-log. QC surfaced that this would create triple overlap: friday-checkup already had >28-day STALE detection; plan added a new tier at >21 days; friday-act warm-pending would duplicate friday-checkup's signal.

**Decision:** Option B — lower the existing friday-checkup STALE threshold from >28 to >21 days (one-token edit), and drop the proposed warm-pending duplicate in friday-act. Warm-pending informational tier lives only in resolve-improvement-log (where it has no overlap).

**Rationale:** Three separate checks for the same signal (stale improvement entries) across three commands creates maintenance surface and operator confusion about which check is authoritative. Single-source signal with aligned thresholds is cleaner. The one-token edit to friday-checkup is lower risk than a new tier block.

**Alternatives considered:**
- *Option A (keep all three tiers):* Rejected — triple overlap; which check fires depends on which command runs first; thresholds would drift.
- *Option C (remove friday-checkup STALE detection entirely, rely on resolve-improvement-log):* Rejected — friday-checkup is the weekly health scan; removing its stale detection degrades its coverage.

## 2026-05-08 — Promotion candidates: single-cycle scope only

**Context:** Plan #2 asked the collaboration-coach to flag recommendations rated "acted on" as graduation candidates. Initial draft was silent on whether to track across cycles (e.g., "this recommendation was acted on in cycle 3, still relevant in cycle 5"). QC flagged the ambiguity as a false-positive risk.

**Decision:** Single-cycle surface only — scan the most recent coaching-log.md entry only; do not match recommendations across entries or track cross-cycle identity. A recommendation that was acted on in a prior cycle but not surfaced in the current entry is not flagged.

**Rationale:** Cross-cycle identity matching requires stable recommendation text (which drifts), and would surface stale recommendations that may no longer apply. Single-cycle surface is simpler, lower false-positive risk, and sufficient — the operator sees graduation candidates at the moment they're fresh.

**Alternatives considered:**
- *Cross-cycle tracking:* Rejected — recommendation text is not normalized; matching on fuzzy prose across entries is error-prone and would require a separate normalization step.

---

## 2026-05-08 — Settings item 5 ({{WORKSPACE_ROOT}} placeholder): option (a) template marker

**Context.** 2026-05-08 friday-act settings plan item 5 — `additionalDirectories` in `ai-resources/workflows/research-workflow/.claude/settings.json` contains literal `{{WORKSPACE_ROOT}}`. 3-cycle recurrence per SO Rec 2; OP-3 forbade auto-picking. Two options: (a) keep literal + document as template marker + auditor exclusion, (b) replace with absolute path.

**Decision.** Option (a) — keep `{{WORKSPACE_ROOT}}` literal. Pair with item 6 expanded to also fix `/deploy-workflow` so it substitutes `{{WORKSPACE_ROOT}}` at deploy time (Step 7 substitution, not Step 4 append).

**Rationale.** `ai-resources/workflows/research-workflow/` is template-shaped by construction (CLAUDE.md filled with unsubstituted `{{...}}` placeholders; canonical-homes table marks `ai-resources/workflows/<name>/` as template home). Replacing the placeholder with an absolute path locks the template to one operator's filesystem layout — violates DR-1 (shared resources are reusable) and propagates the same recurrence to future template-shaped settings.json files. (a) pays the auditor + deploy-workflow fix cost once and closes the recurrence class.

**Alternatives considered.**
- *Option (b) absolute path:* Rejected. Faster today but specializes a template into a deployed copy. Future templates with workspace-root placeholders hit the same recurrence; auditor never learns the structural rule.

**Application deferred.** Items 5+6 application is NOT in today's session scope. Item 6 expanded scope per /consult finding (auditor classification + `/deploy-workflow` Step 7 substitution + permission-template doc note). Application requires `/risk-check` (Permission change + agent-definition edit). Schedule a separate session.

---

## 2026-05-08 — W2.4 before W2.2/W2.3 — systems-review sequencing

**Context.** `/systems-review` (full AI infrastructure, 2026-05-08) identified the binding constraint as operator attention budget on the act-on-findings stage. Five leverage points were surfaced; LP-4 (self-organization via W2.4 improvement loop) was highest-leverage. W2.2 (principles checker) and W2.3 (maintenance subagents) share design DNA with W2.4 and were candidates for concurrent design.

**Decision.** Ship the smallest viable W2.4 improvement-loop slice this week (target: 2026-05-12). Do not start W2.2 or W2.3 design until W2.4 has run successfully for two Friday cycles (earliest: 2026-05-22).

**Rationale.** W2.4 directly relieves the binding constraint by converting manual improvement-log closure into an automated close step. Starting W2.2 or W2.3 in the same window adds design surface without adding closure capacity — making the constraint worse, not better. Per `principles.md § DR-7` (no speculative abstraction): ship one slice, validate the pattern, then generalize. The systems review confirmed W2.4 is the right first target: the improvement-log pile-up is visible, the test target (3 "no active friction" entries) is concrete, and the rollback path is simple (config flag).

**Alternatives considered.**
- *Design W2.2 + W2.3 + W2.4 together:* Rejected. Violates DR-7; none ships faster; no second consumer exists yet to justify generalization.
- *Start W2.2 (principles checker) first:* Rejected. W2.2 affects live enforcement — higher blast radius, more design complexity. W2.4 is safer to test the pattern.
- *Continue friday-act backlog only, defer all W2.x:* Rejected. The systems review is unambiguous that backlog burn-down without closure automation just extends the constraint linearly; W2.4 is the leverage move.

---

## 2026-05-08 — Eliminate opinion-seeking pauses (autonomy posture change)

**Context.** Operator surfaced friction: Claude pauses too often mid-session to ask "what do you recommend?" at decision points. ~95% rubber-stamp acceptance. Two distinct interventions surfaced — (a) change Claude's default posture so it stops asking opinion questions, (b) build a confirm-rate tracking mechanism inside /friday-checkup to retire fading workflow gates (e.g., content-review fired 30 times, confirmed 28 unchanged in global-macro). Operator chose to land (a) now and defer (b).

**Decision.** Workspace-wide posture change: at decision points (multi-option, plan-mode approach selection, skill stage gates), Claude picks the recommended option and proceeds. [AMBIGUOUS] no longer blocks by default — flags the assumption, attempts self-resolution from project files, blocks only if irreconcilable. Assumptions Gate states recommended resolution and proceeds. Loosened autonomy gates #6 and #10. Hard gates 1-5, 7-9 (destructive git, external writes, prompt injection, etc.) preserved unchanged.

**Rationale.** Soft pauses where Claude already has a clear recommendation produce friction without value — QC passes catch real problems, not these gates. Operator trusts Claude's judgment and will intervene if something looks off. The change is conservative: hard gates remain; new posture only governs cases where Claude has a defensible recommendation. Plan-time QC pass surfaced and addressed 3 coverage gaps (Assumptions Gate prose, Session Guardrails summary line, session-guardrails preamble) before commit.

**Alternatives considered.**
- *Bundle posture change + gate-audit mechanism:* Rejected. Gate-audit needs design work (tracking convention, data location, friday-checkup integration) and would expand scope significantly. Posture change is self-contained and ready now; gate-audit is meaningful enough to warrant its own session.
- *Loosen all 10 autonomy gates:* Rejected. Hard gates 1-5, 7-9 protect against irreversible / external / shared-state actions where the operator must consent. Loosening them would trade acceptable friction for unacceptable blast radius.
- *Hook-based enforcement instead of CLAUDE.md rules:* Rejected. Per existing operator preference (no model field in settings.json, model-side rules preferred), CLAUDE.md is the right surface for posture changes. Hooks would add fragility without value here.

---

## 2026-05-08 — Skip end-time /risk-check on the autonomy posture change

**Context.** Session touched cross-cutting CLAUDE.md (a structural change class gated by /risk-check per autonomy rule #9). End-time /risk-check is the default; skip rule requires plan-time covered with mitigations + commits shipped + drift bounded.

**Decision.** Skip end-time /risk-check. Document the skip in the wrap note.

**Rationale.** Plan-time was not run as a formal /risk-check, but the plan-time QC pass effectively covered the same ground — surfaced 3 coverage gaps (Assumptions Gate prose, Session Guardrails summary, preamble), all addressed before commit. Drift bounded to the 4 files specified in the plan. Commits already shipped clean. Direction of change is conservative (loosens existing rules, no new gates / hooks / automation / shared-state effects). Spirit of the skip-rule memory satisfied; ceremonial /risk-check at this point would not surface new findings.

**Alternatives considered.**
- *Run /risk-check anyway:* Rejected. The change is already shipped, and /risk-check at this stage would catch design risks that plan-time QC already addressed. No new findings expected.
- *Roll back commits and run /risk-check pre-commit:* Rejected. The commits are clean and the plan was QC'd. Rolling back would introduce more risk than it removes.

---
## 2026-05-11 — Defer /new-project template rename: Input File Handling → File Write Discipline

**Context.** During Bundle 3 (CLAUDE.md fixes for three projects), the audits identified that the workspace canonical section name is `## File Write Discipline` (not `## Input File Handling`), and renamed the corresponding section in two projects (`axcion-ai-system-owner`, `repo-documentation`). The `/new-project` template emitter (`ai-resources/.claude/commands/new-project.md`) still emits `## Input File Handling` in 11 places and uses `grep -q '^## Input File Handling'` (line 480) as an idempotency probe. This creates a three-way naming state: workspace canonical = "File Write Discipline" / two project CLAUDE.md files = "File Write Discipline" / `/new-project` template = "Input File Handling".

**Decision.** Defer the `/new-project` template update. Captured under Bundle 3's risk-check mitigation option (b): bound Bundle 3 scope to project CLAUDE.md edits; do not touch `/new-project` template emission in the same session. The two affected projects carry an inline note explaining the intentional divergence.

**Rationale.** Bundle 3's mandate explicitly scoped to three CLAUDE.md files. Touching `/new-project` in the same session would have expanded scope to 11 occurrences across the template body, plus the idempotency grep, plus retesting the template emission flow — large enough to justify its own session. The deferred-update follow-up: when a future session edits `/new-project` for an unrelated reason, or is dedicated to template hygiene, align the section name then.

**Trigger for action.** Next `/new-project` template touch session OR next `/permission-sweep` template-class audit pass (whichever comes first). Update all 11 occurrences + the grep idempotency check + verify `/new-project` smoke-test still passes.

**Affected files for the future fix.**
- `ai-resources/.claude/commands/new-project.md` — lines 367, 388, 391, 402, 439, 450, 479, 480, 481, 483, 510
- After fix: the inline divergence note in `projects/repo-documentation/CLAUDE.md` § File Write Discipline can be removed.

**Alternatives considered.**
- *Apply the template update in this Bundle 3 session:* Rejected. Scope expansion (12+ extra targets, plus retest) exceeds the session mandate and the bundle's risk-check verdict explicitly chose option (b).
- *Leave the template inconsistent indefinitely:* Rejected. The divergence is documented in two places (this entry + inline CLAUDE.md note in `repo-documentation`) so the deferred work is discoverable.

---

## 2026-05-08 — Ship session-class classification as Step 1 only (defer downstream rules)

**Context.** Operator proposed a session-class declaration mechanism (design vs execution vs mixed) for `/session-plan` to fix asymmetric failure modes — design sessions accumulate rework when constraints surface late, execution sessions pass cleanly. Full proposal included a five-rule package (constraint-set, path verification, higher QC expectations, heavier risk-check bias for design; trust-the-plan, first-pass-clean, skip-constraint-set for execution). The operator's own writeup recommended a phased rollout: ship the classification prompt only, run for a week, layer rules after.

**Decision.** Implement only Step 1: the classification prompt in `/session-plan` plus persistence to `session-plan.md` and `session-notes.md`. Defer all downstream class-specific rules (constraint-set, path verification, frontmatter declarations on existing commands, QC-expectation adjustments) until after a one-week observation window.

**Rationale.** Cost of a five-rule package on day one: high — five rules to debug simultaneously if the classification itself turns out to be wrong. Cost of Step 1 alone: minimal — one prompt, two writes, fully reversible by editing one file. Observability gain: Step 1 produces the data (`Class:` lines in session-notes) that lets the operator and downstream coaching see whether the classification feels natural before committing to rule wiring. Matches the operator's stated preference (memory: prefers automated infrastructure that fires automatically over disciplines maintained by hand) but also matches the proposal's own "smallest first move" framing.

**Alternatives considered.**
- *Ship the full five-rule package now:* Rejected. Higher debugging surface, harder to roll back, and the proposal itself recommended phased rollout.
- *Add frontmatter class declarations to existing commands now (skip the prompt for known-class commands):* Deferred. The prompt is universal; frontmatter is an optimization that can land in week 2 once the classification taxonomy is validated.

---

## 2026-05-08 — Fading-gate detection: [FADING-GATE] items need no /friday-act intercept

**Context.** Implementing the gate-health monitoring feature (deferred from the autonomy-posture-change session). Original plan included a dedicated triage handler in `/friday-act` that would intercept `[FADING-GATE]` items and present the three remediation options (retire / lower-frequency / recalibrate) before writing to `improvement-log.md`. QC pass flagged the insertion point was underspecified — specifically, how `[FADING-GATE]` items would be excluded from the standard `f/d/s` prompt to avoid double-disposition.

**Decision.** No `/friday-act` change. `[FADING-GATE]` items are treated as standard medium-risk tactical follow-ups, flowing through the existing Step 3 `f/d/s` loop unchanged. When dispositioned `f`, Step 3.6 generates a plan file. The three-option pick (retire / lower-frequency / recalibrate) and the `improvement-log.md` write happen in the plan-file execution session, not during `/friday-act` triage.

**Rationale.** Reading `/friday-act` in full showed the Step 3 `f/d/s` loop already handles all tactical items generically — there is no per-tag dispatch, and none is needed. `[FADING-GATE]` items contain the three-option prompt in their text (`"Pick: retire / lower-frequency / recalibrate"`), which is visible in the plan file the execution session receives. Adding an intercept in `/friday-act` would require specifying which sub-step intercepts the item, how to exclude it from the standard prompt, and how to route the chosen disposition — all overhead that the existing plan-file pattern handles for free.

**Alternatives considered.**
- *New intercept in /friday-act Step 3:* Rejected. Adds control-flow complexity (intercept point, exclusion from f/d/s, inline improvement-log write) for no practical gain — the plan file is sufficient context for the execution session.
- *New sub-step in /friday-act Step 3.5 (SO-derived / journal-derived additions):* Rejected. Same overhead; [FADING-GATE] items are checkup-derived, not SO-derived.

---
- *Write only to `session-plan.md`, not `session-notes.md`:* Rejected. Downstream rules need a persistent grep target; session-plan.md is overwritten each session and can't carry historical signal.

## 2026-05-11 — Abandon /session-plan to recover from session-mandate drift

**Context.** Session started with operator intent: run /prime → /session-start → /monday-prep. During /session-start mandate confirmation, operator replied `c. Next /session-plan` meaning "confirm; next session will be /session-plan." Claude parsed `c.` as a correction to field c ("Done when") and silently baked /session-plan into the current session's mandate. Cadence ran through Phase D successfully, then /session-plan was invoked. Mid-/session-plan, operator detected the drift ("we have completely drifted off to something else") and halted execution.

**Decision.** Recovery option 1: abandon /session-plan for this session, log the two instruction gaps in friction-log, wrap normally. /monday-prep is the work; it is done.

**Rationale.** Three recovery options were considered: (1) abandon /session-plan, (2) write a session-plan.md scaffolded for a future session, (3) treat scratchpads-convention as legitimate work and execute now. Option 1 matches what the operator actually intended (/monday-prep was the session). Option 2 produces an artifact for a session we may not run with this framing. Option 3 doubles down on the drift. Option 1 also preserves the discovered instruction gaps as friction-log evidence for a separate fix-session.

**Alternatives considered.**
- *Continue /session-plan and execute the scratchpads-convention work:* Rejected. The work item is real but it was not the session's intent; conflating drifted-intent with operator-intent erodes the trust contract.
- *Continue /session-plan but stop after writing session-plan.md (Option 2):* Rejected. The session-plan file would describe a future session we may run with a different framing; better to write that file fresh when actually starting that work.
- *Roll back monday-prep commits and re-run:* Rejected. /monday-prep ran correctly through Phase D; the drift was only in the trailing /session-plan invocation, which produced no committed artifact.

## 2026-05-11 — Scratchpads gitignore convention

**Context:** /monday-prep surfaced that `logs/scratchpads/` was untracked with two stale files in the working tree. Decision: track or gitignore?

**Decision:** Gitignore. Added `logs/scratchpads/` to `.gitignore` and removed the two stale files from git index.

**Rationale:** Scratchpads are ephemeral session state — same lifecycle as `audits/working/` notes (already gitignored). Tracking them adds noise without value; gitignoring keeps the pattern consistent.

**Alternatives considered:** Track all scratchpads (rejected — ephemeral state does not belong in history); track selectively by naming convention (rejected — adds manual discipline overhead).

---

## 2026-05-11 — Settings items 5+6 deferred: scope expanded, redesign required

**Context:** Week mandate items 5+6 were a two-part fix (deploy-workflow.md jq snippet + permission-sweep-auditor template-class rule). /risk-check returned PROCEED-WITH-CAUTION with 4 required mitigations, and the proper scope expanded to 5 files (not 2) because the fix requires updating the canonical permission-template.md and the permission-sweep command as well.

**Decision:** Defer to dedicated session. Risk-check report is the execution brief.

**Rationale:** Applying the change without the mitigations would introduce a worse regression than the bug it fixes (over-stripping legitimate additionalDirectories entries). The proper 5-file scope + 4 mitigations is a self-contained unit of work — better done fresh than rushed at session end.

**Alternatives considered:** Apply items 5+6 anyway with partial mitigations (rejected — PROCEED-WITH-CAUTION verdict is binding until mitigations are confirmed applied).

## 2026-05-16 — Automate "git pull at session start" via /prime Step 0

**Context:** The "Pull the latest from GitHub at the start of each session" rule in ai-resources/CLAUDE.md was documentation, not automation. Operator was forgetting it in project sessions, risking stale code edits and stale skill definitions.

**Decision:** Add a new Step 0 to /prime that pulls the cwd repo and (when different) ai-resources, reporting results in the Prime brief. Also surfaces local unpushed commits to prevent the inverse failure mode (forgetting to push at session end).

**Rationale:** /prime is the canonical orientation entry point and is already run consistently — the gap was content, not adoption. A SessionStart hook would fire even on `/clear`-continuations and lack the repo-detection context /prime has. Pulling cwd + ai-resources together handles all three session contexts (project / workspace root / ai-resources) without per-project configuration. Unpushed-commits visibility addresses the operator's concern that git pull alone could let a forgotten push linger silently.

**Alternatives considered:** SessionStart hook running git pull (rejected — fires too broadly, lacks context, and /prime adoption was already consistent).

## 2026-05-16 — Skip permission-sweep H-1 and M-1 findings (deny-list conflict)

**Context.** `/permission-sweep --dry-run` returned 1 HIGH (`Bash(git push *)` allow→deny in workspace Layer B) and 1 MEDIUM (empty user-level deny list — canonical specifies `["Bash(rm -rf *)", "Bash(sudo *)"]`).

**Decision.** Both findings recorded as flagged-deferred in the consolidated report. Do not apply during `/friday-act`.

**Rationale.** Both findings recommend adding entries to a deny list. This conflicts with the stored operator policy (`feedback_zero_permission_prompts`): "never add to deny list; bypassPermissions floor + CLAUDE.md model-side rules is the agreed setup." Applying canonical-template values blindly would override a deliberate operator setup choice.

**Alternatives considered.**
- *Apply the canonical denies anyway:* Rejected — operator policy is explicit and recent.
- *Update the canonical template to reflect operator's chosen setup:* Out of scope for diagnostic-only session; logged as potential `/friday-act` candidate to align template with policy.

---

## 2026-05-16 — Extend model-default prohibition from settings.json to also cover CLAUDE.md

**Context.** Existing rule (2026-05-08, `feedback_no_model_in_settings_json`) prohibited declaring a `"model"` field in any `.claude/settings.json`. Operator now reports that declaring a default model in `CLAUDE.md` produces the same downstream effect: in-session `/model` switches don't take effect reliably. Operator directive: "remove the default model in settings.json or claude.md. Also note somewhere that model default IS NOT ALLOWED in settings.json or claude.md ANYWHERE in the workspace."

**Decision.** Extend the prohibition to cover both settings.json AND CLAUDE.md at every layer (user, workspace, ai-resources, project, vault). Per-command, per-agent, and per-skill `model:` YAML frontmatter remains the only permitted mechanism for declaring a tier outside the live session. Project-level `Model Selection` sections may describe *recommended posture* only (e.g., "lean Opus for plan drafting; Sonnet for routine edits") — never assert a default.

**Rationale.** Same root cause (operator cannot reliably override via `/model` when a default is declared upstream). Treating CLAUDE.md and settings.json identically under the rule eliminates the loophole and makes the prohibition memorable as a single line. Recommended-posture text preserved because operator wants project-specific tier guidance to remain accessible — just not asserted as a binding default.

**Alternatives considered.**
- *Delete project CLAUDE.md `Model Selection` sections entirely.* Rejected — operator directed removal of the *default*, not removal of guidance. Recommended-posture text is useful onboarding signal for project-tier judgment.
- *Restrict prohibition to settings.json only.* Rejected — operator directive explicitly named CLAUDE.md as a second affected layer.
- *Strip model frontmatter from commands/agents/skills as well.* Rejected — frontmatter is the operator's preferred declaration mechanism. Operator confirmed mid-session: "commands can have frontmatter… Yes, and its also allowed for skills."

---

## 2026-05-16 — Reject audit finding: hardcoded absolute paths in ai-resources Layer C settings.json

**Context.** Two `/audit-repo` runs flagged `Edit(/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/**)` and `Write(/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/**)` in `ai-resources/.claude/settings.json` as "hardcoded absolute paths — will break if workspace moves." The 2026-05-16 friday-act plan (ai-resources-maintenance #5) carried this as a Tier 2 fix item.

**Decision.** Reject the audit finding without action. The paths are intentional and canonical: they ARE the Layer C pattern documented in `ai-resources/docs/permission-template.md`. Do not change them.

**Rationale.** Claude Code permission pattern matching is literal — no env-var expansion, no relative-path resolution. The `Edit(/Users/.../...)` form is the only mechanism that covers sessions making absolute-path edits to cross-project files. Replacing with env-vars would silently break permission matching. Future audit runs that re-flag these paths should be dismissed using this entry as precedent. Note added to `permission-template.md` Layer C key assertions to suppress future re-flagging.

**Alternatives considered.**
- *Replace with env-var references:* Rejected. Claude Code permission engine does not expand env-vars inside pattern strings; substitution would silently break the permission grant.
- *Replace with relative paths:* Rejected. Permission patterns are evaluated against the file system at tool-call time; relative paths from the settings file's directory would not match absolute-path edits made by the session.

---

## 2026-05-16 — Defer SessionStart hook chain (journal-improvements #1) to dedicated design session

**Context.** Wave 4 of Tier 3 friday-act execution. Plan-item #1 (journal-improvements) asked for a SessionStart hook chain that auto-runs /session-plan → /qc-pass → /scope after the mandate is captured. Plan-time `/risk-check` returned PROCEED-WITH-CAUTION with 6 required mitigations: specify qc-pass handoff schema; declare authority between session-plan.md vs /scope output (functional overlap); paired doc updates to 4 files (prime.md, session-rituals.md, weekly-session-guide.md, operator-maintenance-cadence.md); reconcile with qc-independence.md (pause-on-findings vs non-blocking exception); reconsider opt-in vs opt-out semantics; add inline rationale at new Step 8 explaining the reversal of "do not auto-invoke /qc-pass automatically." Hidden-coupling dimension rated HIGH.

**Decision.** Defer the item to a dedicated design session. Commit the risk-check report (`audits/risk-checks/2026-05-16-session-start-auto-chain.md`) as the deferred-item record, but do not implement.

**Rationale.** Applying 6 mitigations across 4 paired doc files mid-session would compound scope creep on the already-heavy Wave 4. The session-plan's stop point ("if a wave's target file diverges materially from what the plan-file spec assumes: pause and reassess before editing") fits exactly: the plan-item asked for a "SessionStart hook" but Claude Code hooks (shell scripts on lifecycle events) cannot directly invoke slash commands — the implementation requires command-spec edits, not hook wiring. That divergence + the hidden-coupling rating + the 4 paired doc updates means the change is large enough to deserve its own scope, plan, and operator-visible decision on chain semantics (opt-in vs opt-out, blocking vs non-blocking on QC findings, authority between session-plan and /scope).

**Alternatives considered.**
- *Implement the command-spec-only path now, defer the paired docs:* Rejected — risk-check identified the paired-doc updates as a required mitigation, not optional. Landing the chain without the doc reconciliation creates drift between runtime behavior and documented behavior.
- *Implement the literal SessionStart hook (settings.json):* Rejected — Claude Code hooks fire on every session including ad-hoc sessions where the chain is unwanted. A blanket hook injects the chain instruction everywhere; the operator opt-out mechanism would need a separate marker file or env-var check inside the hook. Both add complexity without proportional benefit.
- *Skip the risk-check and ship:* Rejected — plan-item explicitly required risk-check, and the verdict's HIGH hidden-coupling rating is a real signal, not bureaucratic friction.

---

## 2026-05-16 — Retire nordic-pe-macro produce-* commands (option b, not restore context/)

**Context.** Friday-act 2026-05-16 plan item nordic-pe-macro #1 flagged the `context/` directory as missing — three command files (`produce-prose-draft.md`, `produce-architecture.md`, `produce-formatting.md`) reference `context/prose-quality-standards.md`, `context/content-architecture.md`, and `context/project-brief.md`. The plan offered two paths: (a) restore the files if prose production is still in scope, or (b) document in CLAUDE.md that the commands are retired. Operator decision required.

**Decision.** Path (b): retire the three commands by adding a "Retired Commands" section to project CLAUDE.md. Files left on disk for archival.

**Rationale.** Investigation showed the three commands reference a `parts/part-2-service/` and `parts/part-3-strategy/` document structure that does not exist anywhere in the project — only the three commands themselves reference those paths. The active prose workflow uses `report/chapters/1.1/` with the three-report + Implications Brief structure documented in the project plan. Most recent prose-work session (per `logs/session-notes.md`) edited 17 chapter files under `report/chapters/1.1/` — none of the produce-* commands were invoked. Conclusion: the produce-* commands are artifacts from a project shape that was planned at some point but never adopted.

**Alternatives considered.**
- *Restore the three context files:* Rejected. The directory structure they assume (`parts/part-2-service/`) does not exist; restoring them would not make the commands operational without also creating the parts/ structure, which the project plan does not call for.
- *Delete the three command files:* Rejected as too aggressive. Retirement-via-CLAUDE.md preserves them on disk for archival reference while clearly signaling "do not invoke."
- *Investigate whether parts/part-2-service/ is a planned-but-not-yet-built phase:* Considered. Read the active task plan v3 and research plan v3 — neither references Part 2/Part 3 service/strategy structure. Project plan is consistent with three-report + Brief end-state.

---

## 2026-05-16 — Drop friday-act plan item 5 as moot (target project does not exist)

**Context.** Friday-act 2026-05-16 plan item permission-sweep #2 (H-4) asked for `additionalDirectories` blocks to be added to two project settings.json files: `projects/nordic-pe-landscape-mapping-4-26/.claude/settings.json` and `projects/interpersonal-communication/.claude/settings.json`.

**Decision.** Drop the item without applying. Record in plan execution as superseded.

**Rationale.** On-disk verification: `projects/nordic-pe-landscape-mapping-4-26/` does not exist (likely deleted or renamed since the plan was generated). The second target (`projects/interpersonal-communication/.claude/settings.json`) already contains `additionalDirectories: ["/Users/patrik.lindeberg/Claude Code/Axcion AI Repo"]`. The current `/permission-sweep` report itself (`audits/permission-sweep-2026-05-16.md`) confirms: "Rule 8 (missing or stale additionalDirectories in project files): All Layer D files contain `additionalDirectories: [...]`. No violations." Both ends of the plan item are already resolved by other means.

**Alternatives considered.**
- *Apply the change to interpersonal-communication anyway:* Rejected — the canonical value is already present; applying it would be a no-op edit.
- *Search for a renamed version of nordic-pe-landscape-mapping-4-26:* Considered briefly. The only matching project is `nordic-pe-macro-landscape-H1-2026`, which has its own settings.json with the canonical block already. No drift to remediate.

---

## 2026-05-16 — Skip end-time /risk-check per operator memory rule

**Context.** Session executed two in-class structural changes (both edits to `projects/nordic-pe-macro-landscape-H1-2026/CLAUDE.md`: Retired Commands section + Command Conventions section). Per `ai-resources/docs/audit-discipline.md` § When to fire, the two-gate model nominally requires an end-time `/risk-check` batched across in-class changes.

**Decision.** Skip the end-time gate. Document the skip in this entry and in the session-notes wrap.

**Rationale.** Per operator memory `feedback_end_time_risk_check_skip`: skip when plan-time covered with mitigations applied AND commits already shipped AND drift bounded. All three conditions met. (a) Plan-time gate: item 3 received explicit `/risk-check` (verdict GO, all five dimensions Low, no mitigations required); item 1 was plan-classified `Risk-check required: no` by the friday-act plan author and the change was a doc-only retirement note. (b) Commits shipped: both edits committed during execution (`ed91e61`, `20fa6fc` in the nordic-pe-macro repo). (c) Drift bounded: both edits land exactly the content planned — no scope creep, no behavior changes, no new automation. The end-time gate's value is catching drift and emergent coupling; with zero of either, the gate produces no signal.

**Alternatives considered.**
- *Run the end-time gate anyway:* Rejected. The memory rule exists precisely to suppress ceremonial gate-firing on bounded doc-only changes. Running it would consume an additional subagent invocation without producing useful risk signal.

---

## 2026-05-16 — Apply quick-tier 2nd-QC skip on /cleanup-worktree plan

**Context.** `/cleanup-worktree` over ai-resources working tree. Plan classified 7 untracked audit/report artifacts as decision-1 (`commit`); zero hard gates. 1st QC pass returned MINOR-ONLY (2 nits: line-count value error + transparent phrasing note). Triage classified MINOR-1 as must-fix value substitution and MINOR-2 as history-only no-edit. After revision applying MINOR-1, the quick-tier 2nd-QC skip rule from `ai-resources/skills/worktree-cleanup-investigator/references/execution-protocol.md` § 6 became eligible.

**Decision.** Skip the 2nd QC pass per the quick-tier rule. Surface to operator verbatim per `cleanup-worktree.md` Step 9: "2nd QC skipped per quick-tier rule — zero hard gates, zero new file-content claims in revision." Then proceed to `ExitPlanMode`.

**Rationale.** Both preconditions verified satisfied: (a) Section 4 hard-gate count = 0 — every dirty path is decision-1; no destructive operations exist; (b) revision Section 8 introduced 0 new file-content claims — MINOR-1 was a value substitution of an existing claim (line count for the same file already present in the pre-revision plan), MINOR-2 had no edit. The two failure surfaces the 2nd QC exists to catch (under-specified hard-gate abort scope, fabricated revision claims) are both absent. The skip is the rule's intended application — calibrated exemption, not a weakening. Triage subagent explicitly confirmed eligibility was preserved by the MINOR-1 framing.

**Alternatives considered.**
- *Run the 2nd QC anyway:* Rejected. The quick-tier rule is a load-bearing optimization; defaulting to "run anyway" defeats its purpose and adds ~30s of subagent latency on every cleanup with trivial revisions. The skip is logged and operator-notified — auditability is preserved.
- *Adopt MINOR-2's optional rewording to "1 underlying critical issue counted across 3 areas":* Rejected. Per triage, adopting it would introduce a new characterization absent from the pre-revision plan, technically forfeiting quick-tier eligibility. The original phrasing already mirrors the prev report's own header normalization at line 25 — no fabrication, no precision loss worth the eligibility cost.

---

## 2026-05-16 — Skip find-template.sh for /cleanup-worktree paths in audits/ and reports/

**Context.** `/cleanup-worktree` bias counter 2 (`SKILL.md` lines 128–134) mandates running `scripts/find-template.sh` for any path that could plausibly have a canonical template elsewhere in ai-resources. The command spec at `cleanup-worktree.md` Step 4 step 10 enumerates trigger categories: `.claude/commands/*.md`, `.claude/agents/*.md`, `.claude/hooks/*`, plus paths mirroring `skills/`, `prompts/`, `workflows/`, `scripts/`, `docs/`. The 7 dirty paths this session lived in `audits/risk-checks/` and `reports/` — neither in the explicit trigger list.

**Decision.** Skip `find-template.sh` for all 7 paths. Document the skip as Bias Counter 2 in plan Section 7 with explicit zero-list and justification, so the audit trail is clear.

**Rationale.** `audits/risk-checks/` and `reports/` are append-only working-state directories — per-instance records of changes/audits, intrinsically unique-by-timestamp, not templated content categories. Running the script on these paths would return `NO_TEMPLATE_FOUND` for all 7 files and add zero signal. The bias counter exists specifically because text-only "check both X and Y" instructions failed in the originating session for paths that DO have templated equivalents (`.claude/commands/*.md`). It is calibrated to that risk surface, not blanket "run on every dirty path." Documenting the skip in Section 7 with explicit reasoning maintains the audit-trail property the counter creates.

**Alternatives considered.**
- *Run find-template.sh on all 7 paths anyway:* Rejected. The script would return `NO_TEMPLATE_FOUND` (the script walks ai-resources subdirectories looking for files of matching basename and category; uniquely-named timestamped audit artifacts have no plausible match). Running it would be ceremonial — adds tool calls without producing signal — and would weaken the counter's selectivity over time (audits that fire on irrelevant paths get tuned out).
- *Run it on one representative path as a sanity demonstration:* Rejected. The same logic applies: would return `NO_TEMPLATE_FOUND`, adds no signal. The plan's explicit zero-list with justification is a stronger audit artifact than a single demonstrative run.


## 2026-05-18 — B8 line-count threshold produces false positives; split-log.sh uses entry count

**Context.** Monday-prep B8 check flagged 6 files as over-threshold (>200 lines): `global-macro-analysis/logs/session-notes.md` (447), `nordic-pe-macro/logs/session-notes.md` (411), `nordic-pe-macro/logs/friction-log.md` (612), `project-planning/logs/session-notes.md` (263), `repo-documentation/logs/session-notes.md` (419), `ai-resources/logs/maintenance-observations.md` (232). All were listed as W21 item 5 "manual archive batch." During /log-sweep, none were archived.

**Decision.** Treat B8 flags as informational rather than actionable when files are under the split-log.sh entry-count threshold. No archival applied.

**Rationale.** `split-log.sh` counts `## ` header entry blocks (not total lines) and exits 0 if total entries ≤ KEEP (10). The flagged files have ≤10 dated `## ` entries — long because individual entries are detailed prose, not because there are many of them. Archiving would remove substantive recent content, not trim stale old entries. The B8 >200-line threshold in monday-prep is a useful rough signal but is not the same as the tool's actual trigger condition.

**Alternatives considered.**
- *Manually trim prose within entries:* Valid for files that feel unwieldy; leave to operator judgment rather than automated archival.
- *Update B8 to count `## ` entries instead of lines:* Preferred direction. Open question logged in session-notes.

## 2026-05-18 — Log-sweep auditor misclassifies 2 file types as Cat A2

**Context.** /log-sweep run 2026-05-18 across 10 scopes. Auditor returned 3 Cat A2 over-threshold files. Two were false positives.

**Decision.** Skip both false positives. Apply split-log.sh only to the 1 genuine over-threshold file (`global-macro-analysis/macro-kb/_meta/changelog.md`).

**Rationale.** (a) `nordic-pe-macro/logs/session-notes-archive-2026-05.md`: an archive file matching the `*-archive-*.md` exclusion pattern in the /log-sweep Step 16 `find` prune. The auditor subagent's internal discovery did not respect this exclusion — applying split-log.sh to an archive would create a nested archive. (b) `global-macro-analysis/pipeline/source-docs/operations-manual-v1.3.md`: a documentation file with section headers (`## 1. Three Input Lanes`), not a dated log with `## YYYY-MM-DD` entries. The auditor's Cat A2 classification heuristic does not distinguish section headers from date headers.

**Alternatives considered.**
- *Apply split-log.sh to both and let it handle gracefully:* Rejected. For (a), split-log.sh has no archive-file guard — it would re-archive an archive. For (b), it would split documentation at arbitrary section boundaries, corrupting the file structure.
- *File a bug / improvement against the auditor:* Valid. The archive-file exclusion gap and the section-vs-dated-header distinction are both worth fixing in a future /improve-skill session.

## 2026-05-18 — F2 default: keep current plan (not pass2) on no response

**Context.** /session-plan F2 implementation. Original improvement-log proposal specified "default on no response = option 3 (pass2)." Risk-check pass A raised M4: a non-responsive operator more likely wants to preserve the existing plan than create a silent fork file.

**Decision.** Changed F2 default to option 1 (keep current plan). Operator sees the prompt; silence = keep.

**Rationale.** Pass2 is the right escape hatch when the operator wants both the old and new plan, but it's an active choice, not a safe default. Silent forking on timeout would create files that persist beyond the session and might confuse future /open-items scans.

**Alternatives considered.**
- *Keep option 3 as default:* Rejected. Surprising behavior; creates persistent artifacts silently.
- *No default (require explicit choice):* Rejected. Blocking the session on no response is worse than a safe fallback.

---

## 2026-05-18 — F4 added to risk-check pass B (audit-discipline conflict resolved)

**Context.** Session plan initially classified F4 (new project-local hook + settings.json wiring) as not requiring /risk-check. QC pass surfaced conflict: `audit-discipline.md` bright-line lists hook edits and settings.json edits as required risk-check change classes.

**Decision.** Extended pass B to cover F4 alongside F5. No operator carve-out invoked.

**Rationale.** Per CLAUDE.md conflict rule: "conflicts must be surfaced, not silently resolved." The operator directive (F4 = low risk, no gate) was overridden by audit-discipline's bright-line. The correct resolution is to apply the gate. Risk-check confirmed PROCEED-WITH-CAUTION with 3 mitigations (one of which — M3 — corrected a misunderstanding about how Claude Code hook matchers work).

**Alternatives considered.**
- *Honor operator directive, skip gate:* Rejected. Bright-line rule exists precisely to catch project-local hook additions that seem low-risk but have blast-radius effects.

## 2026-05-22 — /handoff architecture and automation path

**Context.** Designing the `/handoff` skill — unified session-state command replacing `/save-session` — and deciding on automation strategy.

**Decision 1: Command → skill, no subagent.**
Subagent-based architecture was proposed (Plan agent) but rejected. A subagent starts with no session context, making it incapable of compressing the current session's conversation into a scratchpad. The skill must run in the main session. System Owner ruled: command shape per `repo-architecture.md` Q2/Q3.

**Decision 2: Unified two-mode design (no-args continuity, with-args fork).**
Rather than two separate commands (`/save-session` for continuity, new `/handoff` for forking), one unified command with mode driven by args presence. Simplifies operator mental model: one command for all "compress context for another session" needs. Output location follows from mode: no-args → `logs/scratchpads/` (persistent); with-args → `/tmp/` (ephemeral).

**Decision 3: Automation via /wrap-session + /prime integration, SessionStop hook deferred.**
Hooks are shell scripts — cannot generate AI-produced scratchpad content. The right automation is: (a) add `/handoff` (no args) as Step 0.5 in `/wrap-session` (planned exits), (b) add scratchpad detection to `/prime` to close the loop at session start. SessionStop hook for unplanned exits deferred until observed as recurring friction. System Owner ruling: unplanned-exit gap is deliberately left open, not an oversight.

**Alternatives considered.**
- *SessionStop hook (Option B):* Not buildable for full scratchpad — hooks are shell scripts, no Claude reasoning. A minimal marker file is possible but lower-value; deferred.
- *`/clear` interception (Option C):* Dead — `/clear` is a slash command, PreToolUse hooks don't fire on slash commands.
- *PostToolUse compaction hook (Option D):* Redundant — `[COST]` flag already covers this. A hook would add noise mid-work.

## 2026-05-22 — grill-me scope: single skill, no docs-layer variant

**Context.** Evaluating whether to build `grill-me` (plain interview) or `grill-with-docs` (interview + shared vocabulary layer via context.md + ADRs).

**Decision.** Build `grill-me` only. Defer `grill-with-docs` until the plain version is validated in practice.

**Rationale.** The docs layer requires maintaining a `context.md` glossary across sessions — infrastructure that doesn't exist yet. Running plain grilling first surfaces whether vocabulary gaps are actually painful before investing in the maintenance overhead. Don't build infrastructure for a problem not yet confirmed.

**Alternatives considered.**
- *Build both as sibling skills:* Rejected — doubles the surface area before either has been validated.
- *Build one skill with auto-detection (docs-layer if context.md exists):* Rejected — adds complexity to a skill whose value is its simplicity.

---

## 2026-05-22 — grill-me integration: command level, not SKILL.md bodies

**Context.** Deciding where to add the /grill-me pointer in the project planning and skill creation workflows.

**Decision.** Add pointer to the command pipeline files (`/context-builder`, `/create-skill` Step 1), not to the SKILL.md bodies.

**Rationale.** SKILL.md bodies define skill behavior; command files define invocation flow. A pointer to a prior step belongs in the command, not the skill — it's orchestration logic, not skill logic. Adding it to SKILL.md would blur the separation and load the pointer into every context where the skill is referenced, not just the invocation context.

**Alternatives considered.**
- *Pointer in SKILL.md:* Rejected — wrong layer; skill methodology vs. command orchestration.
- *Pointer in CLAUDE.md:* Rejected — CLAUDE.md is for cross-session rules, not workflow reminders.

## 2026-05-22 — Risk-check change-class scope: command-file edits and agent-definition edits

**Context.** `/friday-act` Step 15a annotates each fix-now plan item with whether it touches a `/risk-check` change class. The initial annotations marked 4 items `yes`: editing the project-local `session-plan.md`, editing the `log-sweep-auditor` agent definition, and editing `new-project.md` and `risk-check.md`. The `/friday-journal` report itself had asserted "deterministic match: command edit" for the two command edits. An independent `/qc-pass` flagged all 4 as incorrect.

**Decision.** Corrected all 4 to `no`. The canonical change-class list in `audit-discipline.md` § Risk-check change classes is: hook edits, `settings.json` permission changes, cross-cutting CLAUDE.md edits, **new** commands or skills, new symlinks, shared-state automation. Editing an **existing** command file is not "new commands or skills." Agent-definition edits are not on the list at all.

**Rationale.** The canonical list is the bright-line authority; `/friday-act` Step 15a re-derives the change class rather than inheriting upstream claims — the journal report's "command edit" assertion was not backed by the list, and propagating it was the error. Per the CLAUDE.md conflict rule, the agent-definition case was surfaced rather than silently resolved: the canonical list omits agent definitions, but improvement-log entry 2026-04-28 (status `logged (pending)`, unratified) argues agent-definition edits are Autonomy Rule #9 changes. `log-sweep.md` #1 was left `no` per the current canonical text, with the question surfaced to the operator as an open question.

**Alternatives considered.**
- *Keep all 4 as `yes` (extra gate is harmless):* Rejected. The annotation should reflect the canonical spec; over-gating trains operators to ignore the gate.
- *Flip the 3 command edits but silently keep the agent-def edit `yes`:* Rejected — that silently resolves the conflict. Surfaced it to the operator instead.

## 2026-05-22 — Placement of four governance rules in workspace CLAUDE.md

**Context.** Operator proposed five governance rules (item 4 was a session directive, not a rule) and asked where each should live — project-specific CLAUDE.md or workspace-wide. Three proposed new section headers (`## Quality Control`, `## Workflow / Approval Gates`, `## Session Management`) overlapped existing sections, and two rules conflicted with existing content. Resolved via `/clarify` → `/recommend`.

**Decision.** All four rules go to the workspace-level CLAUDE.md, each folded into the closest existing section rather than added as new parallel sections: QC trigger → `## QC Independence Rule`; post-plan approval gate → `## Plan Mode Discipline`; context-constraint deferral → `## Working Principles`; repo-status verification → new `### Repo-status reporting` subsection under `## File verification and git commits`. Item 2 scoped to plan-mode only. Item 3 reframed as a heuristic (literal `~30%` / `ExitPlanMode` dropped per operator).

**Rationale.** The rules are cross-project governance, so workspace-level per the CLAUDE.md Scoping rule. Folding into existing sections avoids token bloat in an already-large always-loaded file and removes the contradiction surface that parallel sections would create. Item 2 scoped narrowly because a global "wait for explicit approval" rule would contradict the Autonomy Rules and Decision-Point Posture; the plan-mode scoping reinforces existing behavior without overriding autonomy. `/qc-pass` confirmed GO with no conflicts.

**Alternatives considered.**
- *Create the three new sections as the operator named them:* Rejected — duplicates existing QC / plan-mode / session sections and adds always-loaded token weight.
- *Apply item 2 globally:* Rejected — contradicts the Autonomy Rules ("full autonomy") and Decision-Point Posture ("pick and proceed").
- *Keep literal `~30%` threshold:* Rejected by operator — not reliably self-measurable; kept as a heuristic instead.

## 2026-05-22 — check-concurrent-session hook: HEAD-SHA marker, diverging from the plan's mechanism

**Context.** The 2026-05-22 friday-act `check-concurrent-session` plan specified a `PreToolUse` hook for `global-macro-analysis` using `git status --porcelain` + file-mtime comparison against a session-start marker. On reading the project, the existing concurrent-session infrastructure surfaced: `/kb-synthesize` Step 0 already runs `git status --short macro-kb/{theme}/`, Step 5 does a SHA-256 before/after abort, CLAUDE.md already has a recovery note, and two PreToolUse hooks already guard `macro-kb` writes for staging-discipline.

**Decision.** Built the hook with a **HEAD-SHA session-marker** mechanism, not the plan's `git status`+mtime mechanism. A SessionStart `--init` mode records `git rev-parse HEAD` to `.claude/.session-head-marker`; check mode warns (`ask`) when HEAD has moved with commits touching the target theme since the marker. Surfaced as phase-spec staleness per the Assumptions Gate and proceeded with the improved design rather than asking. `/risk-check` returned PROCEED-WITH-CAUTION; the system-owner second opinion concurred with the verdict and explicitly endorsed the divergence. All 5 risk-check mitigations + 3 system-owner contract constraints applied; 9 execution tests pass; QC GO. Committed `4edbf0d`.

**Rationale.** The plan's `git status` check duplicates `/kb-synthesize` Step 0 and inherits its blind spot — a parallel session that has *committed* leaves a clean working tree, so `git status` sees nothing. The plan's own recorded failure mode ("stale `/prime` read + a wrap commit landing mid-session", leaked 3×) is exactly a concurrent *commit*. The HEAD-SHA marker detects commits; the git-status mechanism cannot. A documented duplication that shares a known weakness is worse than a single mechanism that closes it.

**Alternatives considered.**
- *Build the plan's literal `git status`+mtime mechanism:* Rejected — duplicates `/kb-synthesize` Step 0 and shares its committed-change blind spot.
- *Defer the whole plan as redundant:* Rejected — the existing infra has a real gap (concurrent commits); the 3×-recurring friction is unaddressed without a new mechanism.
- *Emit `{"decision":"deny"}` instead of `ask`:* Rejected — `deny` would cross `global-macro-analysis` Hard Rule 6 (no automation that removes the operator from the judgment loop). The hook surfaces, it does not enforce; any future change to `deny` must re-trigger `/risk-check`.

---
