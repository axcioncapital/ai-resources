# Friday Checkup — 2026-06-05

## Tier
monthly (auto-detected — DOW=5, DAY≤7)

## Scopes audited
- ai-resources
- workspace root
- project axcion-ai-system-owner
- project interpersonal-communication
- project marketing-positioning
- project nordic-pe-screening-project
- project project-planning
- project repo-documentation
- project research-pe-regime-shift-advisory-gap

## Prioritized findings (rolled up across all scopes)

### CRITICAL
1. **[permission-sweep] `ai-resources/.claude/settings.local.json` has a `permissions` block with no `defaultMode`** — it shadows the parent's `bypassPermissions`, causing permission prompts in every ai-resources session. Directly defeats the zero-prompt working mode. The same file's allow list also has only 5 narrow Bash entries (no bare Edit/Write/Bash). Two CRITICAL findings, one file.

### HIGH
2. **[audit-claude-md] Stale push-rule CONTRADICTION in 2 project CLAUDE.md files** — `marketing-positioning` and `research-pe` Commit Rules still say "pushing is a manual operator step" (the pre-2026-05-29 inverted rule), contradicting the current gated-batch push rule. Corrupts wrap-session push behavior.
3. **[audit-claude-md — SYSTEMIC] Every project CLAUDE.md carries a bloated, stale `Input File Handling` block + duplicated `Commit Rules`** — verbatim dup of workspace `File Write Discipline`, plus a stale anchor citing a workspace "Input File Handling section" that no longer exists (renamed). Root cause = the `/new-project` CLAUDE.md template. Aggregate ~6,400+ tokens/turn recoverable across the 8 files; per-file 430–1,250 tok/turn.
4. **[token-audit — SYSTEMIC] Missing `Read(...)` deny coverage for stale audit/log/report/working dirs** — workspace root has ZERO `Read()` deny rules; ai-resources and research-pe partial. `.gitignore` blocks commit but NOT read. Highest-leverage token lever (literature cites 40–70% per-request context reduction). Harness-config → operator-gated.
5. **[W2.3 integrity] 3 ERROR atomic-index count mismatches** in `vault/components/_index.md` (Commands 48≠49, Agents 37≠45, Projects 7≠11) — index counts drifted from registry reality.
6. **[improve/W2.4] `/wrap-session` push gate has no pre-push pull** — concurrent-machine push rejection is structurally guaranteed; pairs with the no-reconciliation-policy gap (no `pull.rebase` set). Cross-machine git divergence at 2 logged occurrences, trending.
7. **[improve] Sessions started outside `/prime` bypass marker-numbering AND the mandate ceremony** — wrap has nothing to grade; multi-stage pipelines (e.g. axcion-core-messaging) run with no `**Mandate:**` block → low-confidence wrap. Cheap fix: `/clarify` + pipeline-entry mandate nudge.
8. **[improve] `session-plan-S{n}.md` filename omits the date → cross-day marker reuse collides** (seen 3× — instruction-fix candidate). Date-qualify to `session-plan-{YYYY-MM-DD}-S{N}.md`.

### MEDIUM
9. **[improve] Manual raw-report intake corrupts UTF-8 (mojibake) every Step 2.2b** (research-pe) — add a `scripts/fix-mojibake.sh` normalization step.
10. **[W2.4 — recurrence CONFIRMED] `improvement-analyst` archive de-dup blocked by `Read(logs/*archive*.md)` deny** — the analyst could NOT read `improvement-log-archive.md` this run; de-dup ran against the active log only. Reroute via Bash/grep or pass archived titles in payload.
11. **[audit-repo] research-pe Skill Inventory YELLOW** — 2 project-local skills (`knowledge-file-producer`, `report-compliance-qc`) missing `model:`/`effort:` frontmatter (clears to GREEN when fixed).
12. **[audit-claude-md] Stale model-version pins** — `nordic-pe` + `project-planning` Model Selection sections pin `claude-opus-4-7` (now 4.8); de-version to tier, not point-version.
13. **[principles W2.2] 25 warn / 0 error** — DR-1 project-local hook duplicates without a manifest exception (research-pe 14 local hooks, buy-side 5); DR-3 misplaced workspace-root harness skills + nested-KB CLAUDE.md.
14. **[token-audit] workspace `harness/.claude/commands/` duplicates canonical commands as real files** alongside root symlinks → drift risk.
15. **[coach — robustness] collaboration-coach agent misrouted on 3 of 9 scopes** — abandoned its assigned project root for a richer corpus (ai-resources / buy-side) when local logs looked sparse. Re-ran all 3 with hard path-anchoring; correct analyses obtained. Worth a guardrail in the coach command.

### Clean / no findings
- **Stage 5 anchor consistency (M):** PASS — declared == referenced, zero drift.
- **audit-repo ai-resources:** GREEN, 0 critical/important.
- **W2.2 principles:** 0 error-tier violations (skills 78/78, agents 35/35 clean).
- **No** [STALE], [DEFECT-RECURRENCE], [FRICTION-DORMANT], or [FADING-GATE] items this cycle.

## Per-scope summary

### ai-resources
- /audit-repo: GREEN, 0 crit/0 imp, 4 minor (3 research-workflow command files should be symlinks not copies) → `audits/repo-health-ai-resources-2026-06-05.md`
- /improve: 1 finding (per-item done-condition check for auto-multi-item bundles) → review-only
- /coach: ran (13 sessions) → appended to `logs/coaching-log.md`. The One Thing: serialize same-day shared-infra sessions.
- /audit-claude-md: covered by workspace scope (per spec)
- /token-audit: 0 HIGH/3 MED/3 LOW (~stale working/ + reports readable, no Read deny) → `audits/token-audit-2026-06-05-ai-resources.md`. Positive: MAX_THINKING_TOKENS + AUTOCOMPACT override now both set.

### workspace root
- /audit-claude-md: 3 HIGH/7 MED/4 LOW, ~470 tok/turn (git push/commit rule in 3 places) → `audits/claude-md-audit-2026-06-05-workspace-only.md`
- /coach: ran (14 sessions) → The One Thing: close recurring backlogs (innovation-registry, project-planning migration) — schedule on 3rd recurrence.
- /token-audit: 1 HIGH/4 MED/4 LOW — NO Read() deny rules at root; harness/.claude/commands duplicates → `audits/token-audit-2026-06-05-workspace.md`

### project axcion-ai-system-owner
- /audit-claude-md: 3 HIGH/4 MED/2 LOW, ~560 tok/turn (Input File Handling 31% of file)
- /coach: ran (8 sessions) → plan-mode pre-flight before heavy write-subagent dispatch (not yet re-tested)
- /token-audit: DEFERRED (content/advisory; CLAUDE.md covered above)

### project interpersonal-communication
- /audit-claude-md: 3 HIGH/3 MED/2 LOW, ~620 tok/turn (Input File Handling 42% + stray "Ninja" token line 7)
- /improve: 2 findings (wrap-push pre-pull; pull.rebase policy) — both HIGH, shared cross-machine root
- /coach: ran (13 sessions) → keep review attention at QC+Assumptions gates; stop over-reading content-review
- /token-audit: DEFERRED

### project marketing-positioning
- /audit-claude-md: 4 HIGH/6 MED/3 LOW, ~1,250 tok/turn (push-rule CONTRADICTION; largest savings)
- /improve: 3 findings (sessions-outside-/prime bypass mandate; context engine --add-dir false-missing; concurrent-staging attribution)
- /coach: INSUFFICIENT DATA — Stage 4 content scaffold ran in an UNMERGED worktree (`worktree-agent-ab9fa135d0fd661f6`); logs/CLAUDE.md/output absent in live checkout. **Merge or re-run before coaching can accrue.**
- /token-audit: DEFERRED

### project nordic-pe-screening-project
- /audit-claude-md: 4 HIGH/5 MED/2 LOW, ~760 tok/turn (stale Opus 4.7 pin)
- /coach: ran (13 work items / 8 headers) → set an exit condition for criteria validation (5 versions v4→v4.4 in one day)
- /token-audit: DEFERRED

### project project-planning
- /audit-claude-md: 2 HIGH/4 MED/2 LOW, ~620 tok/turn (Model "Opus 4.7" → de-version)
- /improve: 2 findings (open multi-stage pipelines with /session-start; wrap-confidence recovery path)
- /coach: ran (11 sessions) → open every multi-stage pipeline with /session-start
- /token-audit: DEFERRED

### project repo-documentation
- /audit-claude-md: 3 HIGH/3 MED/2 LOW, ~430–490 tok/turn (Input File Handling 44% + within-file dup)
- /coach: ran (1 new session) → confirm no concurrent session writing before /archaeology scan
- W2.1 doc-scan: 192 added / 10 removed / 0 modified → `output/phase-2/w2-1-doc-scan-2026-06-05.md`
- W2.2 principles: 0 error / 25 warn / 1 info → `output/phase-2/w2-2-principles-2026-06-05.md`
- W2.3 maintenance + integrity: 3 ERROR atomic-index mismatches → `output/phase-2/w2-3-maintenance-2026-06-05.md` + `vault/_integrity-report-2026-06-05.md`
- W2.4 improvements: 5 findings → `output/phase-2/w2-4-improvements-2026-06-05.md`
- Projects-refresh (L): `vault/projects/projects.md` + `vault/architecture/repo-state.md` refreshed
- /token-audit: DEFERRED

### project research-pe-regime-shift-advisory-gap
- /audit-repo: YELLOW — 2 project-local skills missing model:/effort: frontmatter → `audits/repo-health-project-research-pe-regime-shift-advisory-gap-2026-06-05.md`
- /audit-claude-md: 5 HIGH/6 MED/3 LOW, ~1,150 tok/turn (push-rule CONTRADICTION; reference-grade prose in always-loaded CLAUDE.md)
- /improve: 3 findings (session-plan filename date; mojibake intake; subagent auto-commit-noise rule)
- /coach: ran (10 sessions) → clear the recurring-friction backlog (sync-workflow stale 13 sessions; bash-3.2 archive failure; session-plan collision)
- /token-audit: 3 HIGH/3 MED/2 LOW — CLAUDE.md trim, push-rule contradiction, auto-commit churn (41/50 commits) → `audits/token-audit-2026-06-05-project-research-pe-regime-shift-advisory-gap.md`

## Tactical follow-ups
- [ ] Fix `ai-resources/.claude/settings.local.json` — add `defaultMode` (or remove the shadowing permissions block) so `bypassPermissions` is restored; widen its allow list — risk: high
- [ ] Correct the stale push-rule in `marketing-positioning` + `research-pe` project CLAUDE.md (and re-issue from a corrected `/new-project` template) — risk: high
- [ ] Fix the `/new-project` CLAUDE.md template: drop the verbatim `Input File Handling` block (→ pointer), fix the stale workspace-section anchor, de-dup `Commit Rules` — stops the recurrence in all future projects — risk: high
- [ ] Add `Read(...)` deny rules at workspace root + extend ai-resources/research-pe deny coverage to stale audit/log/report/working dirs (harness-config — operator-gated per Autonomy Rule 8) — risk: high
- [ ] Bump the 3 stale `vault/components/_index.md` atomic-index counts (Commands/Agents/Projects) — risk: high
- [ ] Add a pre-push `git fetch` + rebase-prompt to the `/wrap-session` push gate; decide whether to set `pull.rebase=true` policy (via /risk-check) — risk: high
- [ ] Add a session-entry guard / retroactive-mandate synthesis so sessions started outside `/prime` still get a marker + mandate — risk: med
- [ ] Date-qualify the session-plan filename (`session-plan-{YYYY-MM-DD}-S{N}.md`) in session-marker.md + writers + glob consumers (seen 3×) — risk: med
- [ ] Add per-item done-condition presence-check before auto-multi-item bundles execute in `/prime` Step 8c (surfaced independently by ai-resources /improve + W2.4) — risk: med
- [ ] Add `scripts/fix-mojibake.sh` UTF-8 normalization to the research-workflow raw-report intake (Step 2.2b) — risk: med
- [ ] Reroute `improvement-analyst` archive de-dup to avoid the `Read(logs/*archive*.md)` deny (recurrence confirmed this run) — risk: med
- [ ] Add `model:`/`effort:` frontmatter to research-pe project-local skills `knowledge-file-producer` + `report-compliance-qc` (clears audit-repo to GREEN) — risk: low
- [ ] De-version the `claude-opus-4-7` pins in nordic-pe + project-planning Model Selection to tier "Opus" — risk: med
- [ ] Add a guardrail so the collaboration-coach agent anchors to its assigned project root (3/9 misrouted this run) — risk: med
- [ ] Merge or re-run the marketing-positioning Stage 4 scaffold stranded in worktree `worktree-agent-ab9fa135d0fd661f6` — risk: med
- [ ] Triage the 5 W2.4 findings + per-scope /improve findings at `/friday-act` — risk: med
- [ ] [SESSION-ISSUE] `/fix-symlinks` blind to "regular-file-where-symlink-expected" drift (2026-06-02) — decide: fix, defer, or close — risk: med
- [ ] [SESSION-ISSUE] Step 3.5 CONCURRENT block strands a no-own-marker session whose work is already committed (2026-06-04) — decide: fix, defer, or close — risk: med
- [ ] `/resolve-improvement-log` — ~5–6 applied+verified entries pending archive (log-sweep also flagged `improvement-log-archive.md` for split) — risk: low
- [ ] `/log-sweep` (real run) — 2 archival candidates: `improvement-log-archive.md` (508 lines) + `project-planning/logs/session-notes.md` (579 lines) — risk: low
- [ ] W2.1 registry maintenance at `/friday-act`: paste 192 Added drafts, resolve 10 Removed as rename/deprecate (NOT delete), confirm references-subset scope first — risk: low
- [ ] Investigate DR-1 project-local hook duplicates (research-pe 14, buy-side 5) — add manifest hooks exception or consolidate — risk: med
- [ ] `/cleanup-worktree` — both repos dirty (ai-resources 8 M / pre-existing drift beyond this run's reports; workspace-root 5 M incl. modified CLAUDE.md) — risk: med
- [ ] `git push` — ai-resources: 9 unpushed commits — risk: med

## Policy-level observations
- **`/new-project` CLAUDE.md template is the systemic root cause** of the per-project bloat: every project inherits a verbatim `Input File Handling` block (dup + stale anchor) and a duplicated `Commit Rules` block, two of which now carry a live push-rule contradiction. Fixing the template once stops the recurrence across all future projects and recovers ~6,400+ tokens/turn in aggregate. — source: /audit-claude-md (all 8 scopes) [recurring-class]
- **`Read(...)` deny coverage is systemically thin** — the workspace root has zero Read denies; gitignore protects commits but not reads, leaving stale audit/log/report/working content exposed to accidental exploration reads across every scope. Highest-leverage token lever. — source: /token-audit (workspace + ai-resources + research-pe)
- **Stale model-version pinning recurs as models advance** — project CLAUDE.md `Model Selection` sections pin point-versions (`claude-opus-4-7`). De-versioning to tier-only ("Opus") in the template would make this self-maintaining. — source: /audit-claude-md (nordic-pe, project-planning)
- **The permission floor is fragile to local-settings shadowing** — a project/repo `settings.local.json` with a `permissions` block but no `defaultMode` silently defeats the inherited `bypassPermissions`. Worth a structural guard (the `check-permission-sanity.sh` hook could detect a permissions-block-without-defaultMode shape). — source: /permission-sweep
- **Cross-scope coaching theme: deferred backlog not converting to dedicated sessions** — "The One Thing" in 5 of 9 scopes (ai-resources, workspace, nordic-pe, research-pe, buy-side). In-session discipline is strong; the leak is that recurring Open Questions / improvement-log items never get a dedicated mandate. The behavioral fix (schedule on 3rd recurrence) is the same recommendation recurring from 2026-05-29. — source: /coach (5 scopes) [recurring]

## All reports generated
- `audits/friday-checkup-2026-06-05.md` (this report)
- `audits/working/friday-checkup-2026-06-05-RESULTS.md` (running ledger)
- `audits/repo-health-ai-resources-2026-06-05.md`
- `audits/repo-health-project-research-pe-regime-shift-advisory-gap-2026-06-05.md`
- `audits/claude-md-audit-2026-06-05-workspace-only.md`
- `audits/claude-md-audit-2026-06-05-project-axcion-ai-system-owner.md`
- `audits/claude-md-audit-2026-06-05-project-interpersonal-communication.md`
- `audits/claude-md-audit-2026-06-05-project-marketing-positioning.md`
- `audits/claude-md-audit-2026-06-05-project-nordic-pe-screening-project.md`
- `audits/claude-md-audit-2026-06-05-project-project-planning.md`
- `audits/claude-md-audit-2026-06-05-project-repo-documentation.md`
- `audits/claude-md-audit-2026-06-05-project-research-pe-regime-shift-advisory-gap.md`
- `audits/token-audit-2026-06-05-ai-resources.md`
- `audits/token-audit-2026-06-05-workspace.md`
- `audits/token-audit-2026-06-05-project-research-pe-regime-shift-advisory-gap.md`
- `audits/permission-sweep-2026-06-05.md`
- `audits/log-sweep-2026-06-05.md`
- `projects/repo-documentation/output/phase-2/w2-1-doc-scan-2026-06-05.md`
- `projects/repo-documentation/output/phase-2/w2-2-principles-2026-06-05.md`
- `projects/repo-documentation/output/phase-2/w2-3-maintenance-2026-06-05.md`
- `projects/repo-documentation/output/phase-2/w2-4-improvements-2026-06-05.md`
- `projects/repo-documentation/vault/_integrity-report-2026-06-05.md`
- coaching-log.md appended in all 9 scopes
- vault narrative notes refreshed: `vault/projects/projects.md`, `vault/architecture/repo-state.md`

---

*Tier: monthly. Auto-run checks completed: audit-repo (2), improve (5), coach (9), audit-claude-md (8), token-audit (3 of 9 — 6 content scopes deferred with logging, CLAUDE.md-dominated cost already covered by Section D), permission-sweep (1), log-sweep (1), W2.1/W2.2/W2.3/W2.4 + projects-refresh, Stage-5 anchor check. Diagnostic only — no fixes applied, no commits made by the checkup. Findings direct next week's `/friday-so` advisory and `/friday-act` fixes.*
