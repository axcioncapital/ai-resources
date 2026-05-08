# Decision Journal

> Archive: [decisions-archive-2026-04.md](decisions-archive-2026-04.md)

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
