# Friday Checkup — 2026-07-03

## Tier
quarterly (auto-detected — Friday, day ≤ 7, month ∈ {01,04,07,10})

> **Run notes (read before triaging):**
> - **Concurrent-session recovery.** A second `/friday-checkup` was running live in this same checkout and had already committed two audit artifacts (`claude-md-audit-2026-07-03-project-axcion-ai-system-redesign`, `permission-sweep-2026-07-03`). The operator stopped it; this session resumed as sole owner and **folded those two committed artifacts into this report** rather than redoing them.
> - **Operator scope trims (efficiency, credit-budget management):** `/coach` limited to the two hub scopes (ai-resources + workspace); `/token-audit` limited to ai-resources (workspace deferred). Both trims are logged as follow-ups below.
> - **`/permission-sweep` (Check F)** was satisfied by the concurrent session's committed workspace-wide sweep (once-per-run, nothing changed since) — not re-run.
> - **`/log-sweep` (Check G)** was run as an inline line-count inventory (dry-run equivalent) rather than a per-scope auditor fan-out, given the budget.
> - **Findings rolled up directly** from in-context subagent returns (the `findings-extractor` step was unnecessary — all sub-report findings were already in main-session context).

## Scopes audited
- ai-resources (always)
- workspace root (CLAUDE.md via the concurrent session's committed audit)
- project axcion-copy-factory
- project interpersonal-communication
- project marketing-positioning
- project nordic-pe-screening-project
- project obsidian-pe-kb
- project project-planning
- _(project axcion-ai-system-redesign — CLAUDE.md audited by the concurrent session; folded in)_

---

## Prioritized findings (rolled up across all scopes)

### CRITICAL — permission prompts firing right now (permission-sweep, 5 findings)
1. **[CRITICAL] `projects/management-os/.claude/settings.local.json`** — local-override missing `"defaultMode": "bypassPermissions"`; disables bypass for the whole project. Fix: add the setting.
2. **[CRITICAL] `projects/positioning-research/.claude/settings.local.json`** — same missing-bypass shadowing the parent (Rule 1) AND a single-command bash allowlist (Rule 5). Any new bash command prompts. Fix: add `defaultMode` + `Bash(*)` (or drop the block).
3. **[CRITICAL] `projects/axcion-brand-book/.claude/settings.json`** — broad allow rules don't cover nested `.claude/` (glob quirk); edits inside nested `.claude/` still prompt. Fix: add `Edit(**/.claude/**)` + `Write(**/.claude/**)`.
4. **[CRITICAL] `ai-resources/.claude/settings.local.json`** — narrow 4-command bash allowlist; any new bash command prompts. Fix: `Bash(*)` or drop the local block so the parent applies.

### HIGH
5. **[HIGH] `research-workflow` relays large delegable content through the main session** (token-audit Section 4, W4-H1…H4). `evidence-to-report-writer` returns full chapter drafts; `execution-agent` returns verbatim GPT-5/Perplexity responses *and* writes them to disk (duplicated); large operand + reference-doc reads relayed through main where the workflow's own carve-out already permits path-passing. Sibling stages (`run-synthesis`, `produce-prose-draft`) already do the disk-write-and-return-path pattern — these are inconsistencies within one workflow. → dedicated research-workflow optimization session.
6. **[HIGH] Systemic project-CLAUDE.md duplication (25 HIGH across all 6 project audits).** Every project CLAUDE.md restates the same workspace blocks — **Input File Handling, Commit Rules, Session Boundaries, Compaction** — which already load via ancestor-walk, each justified by a **false "opened without parent context" rationale**. This is one **template/scaffolding root cause**, not 6 independent problems. Combined ~6,170 tokens/turn recoverable across the 6 projects. → fix the project-CLAUDE.md scaffold template so future projects don't inherit it.
7. **[HIGH] Workspace-root grant (`additionalDirectories`) missing in 9 projects** (permission-sweep Rule 8) — ai-resources symlinks may not resolve when those projects are opened standalone: axcion-ai-system-redesign, axcion-design-studio, axcion-copy-factory, axcion-website, marketing-positioning, project-planning, nordic-pe-screening-project, axcion-ai-system-owner (+ vault). Fix: add the grant to each project's `settings.local.json`.
8. **[HIGH] Workspace CLAUDE.md over the 200-line target** (230 lines; concurrent session's workspace+redesign audit, 5 HIGH) — a cluster of rare-firing gate blocks carry full trigger/skip mechanics inline where a one-line trigger + pointer would serve.
9. **[HIGH] Workspace-root git remote broken** — `axcioncapital/workspace-root.git` returns "Repository not found"; workspace commits are unpushable every session. High-impact / trivial fix (flagged 2026-06-16, still open). (coach + improve)

### MEDIUM
10. **[MEDIUM] ai-resources `Read()` deny-rule gaps** (token-audit F6-1/2/3): `audits/working/`, the NEW `output/` tree (114 files, ~760 KB), and ~40 historical dated reports are readable. Add granular denies (not directory-wide). Route via `/permission-sweep` / operator settings edit.
11. **[MEDIUM] `output/deploy-test-scratch-2026-06-12/` scratch project** should be deleted/archived — also flagged by Check A as the single highest-value ai-resources cleanup (clears 4 recurring Minor findings).
12. **[MEDIUM] R4 standing structural lever** — `session-notes.md` tail re-read 4–5×/session; flagged 8+ consecutive audits without closure. ~6–15k tokens/week. → cache the /prime-fetched tail; downstream guards reuse it.
13. **[MEDIUM] Permission hygiene** (permission-sweep): `additionalDirectories` grant sits in tracked `settings.json` in 11 projects (belongs in gitignored `.local`); 17 projects deny `Read(archive/**)` with no matching `.gitignore` entry; the `permission-template.md` intentional-narrow exception list is stale (`obsidian-pe-kb/vault` file no longer exists).

_(Full per-scope HIGH/MEDIUM/LOW lists are in the per-scope reports listed under "All reports generated.")_

---

## Per-scope summary

### ai-resources
- **/audit-repo:** GREEN — 0 Critical, 0 Important; all findings Minor. Highest-value cleanup: delete `output/deploy-test-scratch-2026-06-12/`. → `audits/repo-health-ai-resources-2026-07-03.md`
- **/improve:** 4 new findings logged (staging-hook parser; subagent-spawn fallback; /tech-consult orphan; workspace-root command-dir reconcile) → `logs/improvement-log.md`
- **/coach:** ran (14 sessions) — Decision Patterns Strong↑, Delegation/Workflow-Evolution Watch. One Thing: wire new commands' invocation path as a plan done-condition (stop shipping memory-dependent orphans). → `logs/coaching-log.md`
- **/token-audit:** 4 HIGH (research-workflow relays), MEDIUM deny-rule gaps + R4 lever; core (CLAUDE.md 77 lines, 81 skills, 84 commands, config) strong & unregressed. → `audits/token-audit-2026-07-03-ai-resources.md`

### workspace root
- **/improve:** 3 new findings (broken git remote; shared-state schema read rule; QC→triage cap-exhaustion escalation) → `logs/improvement-log.md`
- **/coach:** ran (7 net-new sessions) — Decision Patterns Act↓ (decisions.md newest still 2026-05-26; reusable calls stranded in session-notes). One Thing: promote rule-setting calls into decisions.md at wrap. → `logs/coaching-log.md`
- **/audit-claude-md:** (concurrent session) 5 HIGH / 12 MEDIUM / 6 LOW — 230 lines over target; ~1,035 tok/turn savings available. → `audits/claude-md-audit-2026-07-03-project-axcion-ai-system-redesign.md`
- **/token-audit:** DEFERRED (see follow-ups).

### project axcion-copy-factory
- **/improve:** clean (no new findings). **/coach:** deferred (hub-only trim).
- **/audit-claude-md:** 4 HIGH / 8 MEDIUM / 4 LOW; ~1,900 tok/turn — largest project CLAUDE.md (277 lines). Source Routing Map (Move) + workspace-mirror blocks (Trim/Delete). → `audits/claude-md-audit-2026-07-03-project-axcion-copy-factory.md`

### project interpersonal-communication
- **/improve:** clean. **/coach:** deferred.
- **/audit-claude-md:** 7 HIGH / 5 MEDIUM / 2 LOW; ~770 tok/turn — 4 root blocks each fail several tiers (Input File Handling ~45% of file). → report path below.

### project marketing-positioning
- **/improve:** 2 new (prime same-day S{N} collision fallback; context-discovery cross-workspace false-negative) → project `logs/improvement-log.md`
- **/coach:** deferred. **/audit-claude-md:** 3 HIGH / 8 MEDIUM / 3 LOW; ~1,100 tok/turn. → report path below.

### project nordic-pe-screening-project
- **/improve:** clean. **/coach:** deferred.
- **/audit-claude-md:** 4 HIGH / 7 MEDIUM / 3 LOW; ~800 tok/turn. → report path below.

### project obsidian-pe-kb
- **/improve:** skipped (no friction-log). **/coach:** deferred.
- **/audit-claude-md:** 3 HIGH / 3 MEDIUM / 1 LOW; ~700 tok/turn. → report path below.

### project project-planning
- **/improve:** 2 new (prime out-of-repo mission menu filter; plan-draft mandate-baseline nudge) → project `logs/improvement-log.md`
- **/coach:** deferred. **/audit-claude-md:** 4 HIGH / 4 MEDIUM / 2 LOW; ~900 tok/turn (incl. intake-methodology paragraphs). → report path below.

---

## Weekly Session Value Review

_Window: sessions since the last checkup (2026-06-12). 7 real value-audit blocks (one "skipped per preflight" excluded); scores 8–9 throughout._

### Highest-value sessions
- 2026-07-01 — `/scope-project` complex-build scoping pipeline (ai-resources) — A / 9
- 2026-06-29 — requirements-ledger + confidence-scored handoff plan (ai-resources) — A / 9
- 2026-07-02 — 60-subsector bottom-up taxonomy + deterministic classifier (nordic-pe) — A / 9

### Lowest-yield sessions
- 2026-07-02 — Web Copy page brief (axcion-copy-factory) — A / 8 — the one block naming an "avoidable same-session rework loop."

### Session types to repeat
- consult-then-verify-against-filesystem on corpus-dependent plans (caught a load-bearing SO grounding error).
- plan-then-build-with-front-loaded-gates (zero rework on the scope-project build).
- locked-boundaries → fan-out → deterministic-assemble on taxonomy work.

### Session types to constrain or batch
- Page/section authoring — front-load a one-line scope-confirm (page type + "focus" definition) **before** authoring v1, to avoid rev-2 section churn (copy-factory "Repeat with constraints").

### Session types to stop
- (none — no DECISION reached "Redesign before repeating" or "Stop" this window)

### One operating rule change
- **Lock page/section type before authoring page-scope structure.** Add a one-line upfront scope-confirm to page-scope planning. (Sole RULE-candidate that earned it; matches the copy-factory improvement-log entry — a real recurring rework cost.)

---

## Tactical follow-ups
- [ ] Fix the 4 CRITICAL permission-prompt settings gaps (management-os, positioning-research ×2, axcion-brand-book, ai-resources local) — risk: high
- [ ] Add the workspace-root `additionalDirectories` grant to the 9 projects missing it (Rule 8) — risk: high
- [ ] research-workflow: bring the 4 HIGH content-relays (W4-H1…H4) to the disk-write-and-return-path pattern — dedicated optimization session — risk: high
- [ ] Fix the systemic project-CLAUDE.md scaffold template (Input File Handling / Commit Rules / Session Boundaries / Compaction duplication) so new projects don't inherit it; then trim the 6 existing project files — ~6,170 tok/turn — risk: med
- [ ] Fix the broken workspace-root git remote (`axcioncapital/workspace-root.git` not found) — risk: high
- [ ] Trim the workspace CLAUDE.md rare-firing gate blocks to trigger+pointer form (230 → under 200 lines) — risk: med
- [ ] Add ai-resources granular `Read()` denies (`audits/working/**`, `output/**` or subpaths, dated-report patterns) — verify no active command greps historical reports first — risk: med
- [ ] Delete/archive `output/deploy-test-scratch-2026-06-12/` (also Check A's #1 cleanup) — risk: low
- [ ] `/log-sweep` (apply) — ai-resources over threshold: `improvement-log.md` (626), `usage-log.md` (583), `session-notes.md` (521); + `audits/working/` Cat-D age candidates — risk: low
- [ ] Ship the R4 lever (cache /prime-fetched session-notes tail; 8+ consecutive audits) — risk: med
- [ ] `/resolve-improvement-log` — check ai-resources improvement-log for resolved entries pending archive — risk: low
- [ ] **DEFERRED this run — `/token-audit workspace`** (operator trim; run in a dedicated session) — risk: low
- [ ] **DEFERRED this run — `/coach` for the 6 project scopes** (axcion-copy-factory, interpersonal-communication, marketing-positioning, nordic-pe, obsidian-pe-kb, project-planning) — hub-only trim — risk: low
- [ ] **DEFERRED — re-run `/token-audit ai-resources` Section 4 with synchronous dispatch** if a definitive multi-workflow result is wanted (this run completed Section 4 for the single active workflow, late/async) — risk: low
- [ ] Permission hygiene (permission-sweep MEDIUM/ADVISORY): relocate `additionalDirectories` from tracked→`.local` in 11 projects; reconcile `Read(archive/**)` denies with `.gitignore` in 17 projects; refresh the stale `permission-template.md` exception list — risk: med
- [ ] Triage the W2.4 improvement findings at `/friday-act` (same 4 as the ai-resources improvement-log 2026-07-03 entries) — risk: med
- [ ] **[QUARTERLY] `/repo-dd deep`** per scope (ai-resources + active projects) — risk: low
- [ ] **[QUARTERLY] `/analyze-workflow research-workflow`** (the single workflow under `workflows/`) — risk: low

---

## Policy-level observations
- **Systemic project-CLAUDE.md template duplication (recurring, high-leverage).** All 6 audited project CLAUDE.md files independently duplicate the same 4 workspace blocks with the same false "opened without parent context" justification — the signature of a scaffold template (`/new-project` project-CLAUDE.md fragment or `templates/`) that bakes in the duplication. A single template fix prevents recurrence across all future projects. **Source:** the 6 claude-md audits (recurring).
- **`--add-dir` registration gap — 3rd instance, escalate.** "File access without command/agent-type registration" now spans 2026-06-16 + both 2026-07-02 friction entries. If a 4th lands, escalate to a single instruction-level fix (documented spawn-step fallback) rather than continuing per-surface patches. **Source:** /improve (ai-resources), recurring.
- **Adoption lag > build rate (both coach scopes agree).** ai-resources and workspace coaching both flag: capabilities shipped faster than adopted (`/tech-consult` orphan; improvement-logs all `logged (pending)`, 0 applied); `decisions.md` stale (workspace newest 2026-05-26). Quarter signals corroborate: **290 risk-check reports** and **81 commands added** this quarter. **Source:** /coach ×2 + retrospective signals (recurring — 2nd consecutive cycle on the stale-decisions.md finding).
- **Deferred quality: token-audit workspace + 6 project coaches** were trimmed for budget this run — not evidence of health, just uncollected. Weigh at `/friday-act`.

---

## Architectural retrospective (quarterly)

**Substrate questions:**
- *What's the repo drifting toward?* A very large, fast-growing capability surface (84 commands / 80 skills / 40 agents) with strong per-artifact discipline but a widening **build-vs-adopt gap** — new commands ship faster than they are wired into pipelines or retired.
- *What's accumulating without a forcing function to remove it?* (a) **290 risk-check reports** in one quarter — heavy gate ceremony with no archival/pruning cadence; (b) `output/` generated artifacts (114 files, new this cycle) with no `Read()` deny or cleanup; (c) `logged (pending)` improvement-log entries that accrue but rarely reach `applied`; (d) stranded reusable decisions in session-notes that never reach `decisions.md`.
- *Which boundary felt fuzziest this quarter?* The `--add-dir` boundary — what a project session can *access* (files) vs. *invoke* (commands/agent types). Three friction instances this quarter; the fix keeps being deferred.

**Quarter-over-quarter signals (directional; filename/git counts):**
- `/risk-check` reports filed this quarter: **290** (the entire risk-checks folder is this-quarter-dated — no older files, so either the practice scaled hard this quarter or older reports were pruned).
- New commands added this quarter: **~81** (git adds; inflated by moves/restructuring, but directionally the library was largely (re)built this quarter — the token-audit's cleaner delta is 72→84 = +12 since 2026-06-05).
- Library totals now: 84 commands / 80 skills / 40 agents.

**Quarterly follow-ups (also under Tactical):**
- `/repo-dd deep` — ai-resources + each active project scope
- `/analyze-workflow research-workflow` — the single workflow under `workflows/`

---

## All reports generated
- `audits/repo-health-ai-resources-2026-07-03.md` (+ live `reports/repo-health-report.md`)
- `audits/claude-md-audit-2026-07-03-project-axcion-copy-factory.md`
- `audits/claude-md-audit-2026-07-03-project-interpersonal-communication.md`
- `audits/claude-md-audit-2026-07-03-project-marketing-positioning.md`
- `audits/claude-md-audit-2026-07-03-project-nordic-pe-screening-project.md`
- `audits/claude-md-audit-2026-07-03-project-obsidian-pe-kb.md`
- `audits/claude-md-audit-2026-07-03-project-project-planning.md`
- `audits/claude-md-audit-2026-07-03-project-axcion-ai-system-redesign.md` _(concurrent session; workspace + redesign; committed)_
- `audits/token-audit-2026-07-03-ai-resources.md`
- `audits/permission-sweep-2026-07-03.md` _(concurrent session; workspace-wide; committed)_
- `projects/repo-documentation/output/phase-2/w2-4-improvements-2026-07-03.md`
- Improvement-log appends: `ai-resources/logs/improvement-log.md` (+4), workspace `logs/improvement-log.md` (+3), `projects/marketing-positioning/logs/improvement-log.md` (+2), `projects/project-planning/logs/improvement-log.md` (+2)
- Coaching-log appends: `ai-resources/logs/coaching-log.md`, workspace `logs/coaching-log.md`
- Working notes: `audits/working/audit-*-2026-07-03.md`, `audits/working/audit-summary-workflow-research-workflow.md`

---

_Generated by `/friday-checkup` (quarterly). Diagnostic + review only — no fixes applied. Findings direct next week's work; triage at `/friday-act`. Commit at `/wrap-session`._
