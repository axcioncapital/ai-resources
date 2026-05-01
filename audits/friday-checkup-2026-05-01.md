# Friday Checkup — 2026-05-01

## Tier
monthly (auto-detected — first Friday of May; mixed-tier execution by operator request: ai-resources full monthly, others light/weekly)

## Scopes audited
- ai-resources (full monthly: audit-repo, improve, coach, token-audit, permission-sweep workspace-wide)
- project repo-documentation (light/weekly: coach only — audit-repo skipped per non-deployment, improve skipped per missing log)
- project obsidian-pe-kb (light/weekly: coach only — audit-repo skipped per non-deployment, improve skipped per missing log)
- knowledge-bases (custom workspace-root scope: all checks auto-skipped — no repo-health-analyzer deployed, no improvement-log, 0 wrapped sessions)

**Mixed-tier rationale:** Operator scoped this run to keep duration ≤ ~120 min. W2.x (G–K) checks deferred entirely. /audit-claude-md skipped per spec (workspace not selected; light tier on projects).

## Prioritized findings (rolled up across all scopes)

### CRITICAL
None.

### HIGH

1. **[ai-resources/token-audit] H1 (CARRIED FORWARD)** — Research-workflow prose-pipeline subagent returns violate output-to-disk pattern. Three sub-pipeline subagents return 60–200+ line findings to main session. Carried unchanged from 2026-04-24. Schedule a dedicated session.
2. **[ai-resources/token-audit] H2** — Split answer-spec-generator (487 lines) and research-plan-creator (466 lines) into per-mode SKILL.md. ~33,000 tokens/year recoverable.
3. **[workflow settings] `{{WORKSPACE_ROOT}}` placeholder** — `workflows/research-workflow/.claude/settings.json` has unfilled template placeholder under `additionalDirectories`. Flagged independently by `/audit-repo` AND `/permission-sweep` (recurrence signal).

4. **[W2.2/QS-6] 33/39 canonical commands missing H1 title** — QS-6 requires `# /command-name` as first body line. Only 6 commands comply. Systemic bulk-fix needed across ai-resources canonical command library.
5. **[W2.2/DR-1] nordic-pe project missing shared-manifest.json** — 3 command files (prime.md, wrap-session.md, note.md) are project-local copies, not symlinks. Without a manifest, auto-sync can't classify them. Create manifest and declare explicitly.

### MEDIUM

6. **[ai-resources/audit-repo] research-extract-verifier missing model/effort frontmatter** — workspace rule requires explicit tier declaration. Quick fix.
7. **[ai-resources/token-audit] M1** — Add `Read(audits/**)` and `Read(reports/**)` to `.claude/settings.json`. Closes the H2-residual gap from 2026-04-24.
8. **[ai-resources/token-audit] M2** — Split ai-resource-builder (415 lines, 3 modes).
9. **[ai-resources/audit-repo] answer-spec-generator at 476 lines** — same skill as H2 above; cross-referenced.

### Improvement opportunities (LOW)

8. **[ai-resources/audit-repo Minor]** — 11 skills lack trigger phrasing in description; 7 lack exclusion phrasing. Sweep.
9. **[ai-resources/audit-repo Minor]** — 2 orphaned skills (`fund-triage-scanner`, `prose-refinement-writer`) — keep or move to `deprecated/`.
10. **[ai-resources/audit-repo Minor]** — Stale `Read(archive/**)` deny pattern (now redundant with broader patterns).
11. **[ai-resources/token-audit] L1** — Delete orphan `usage/usage-log.md` (227 lines, pre-migration artifact).
12. **[permission-sweep] 9 ADVISORY** — gitignore drift (`Read(archive/**)` in deny but `archive/` not in `.gitignore` across 9 files).

### Resolved since 2026-04-24

- **MAX_THINKING_TOKENS=10000** now set in `ai-resources/.claude/settings.json` env (was M1 in token-audit-2026-04-24).
- **Read() deny coverage expanded** from 1 pattern to 5 patterns (was H2 in token-audit-2026-04-24 — partial close; `audits/`, `reports/` still uncovered).
- **Coach prior recommendation** (push design forks from session notes to decisions.md) **substantially acted on** — decisions/session rose from ~1 to 3.25.

## Per-scope summary

### ai-resources

- **/audit-repo:** YELLOW overall. 0 Critical, 3 Important, 10 Minor. Snapshot: `audits/repo-health-ai-resources-2026-05-01.md`. Canonical report: `reports/repo-health-report.md` (prior archived to `reports/repo-health-report-2026-04-24.md`). Caveat: subagents ran in single session because Agent tool wasn't exposed in that environment — findings factual but cross-auditor independence not achieved.
- **/improve:** 0 findings. Both friction-log entries already applied+verified in archive (2026-04-22). Pattern to watch: no friction logged since 2026-04-18 despite active sessions; verify at next `/wrap-session`.
- **/coach:** ran (12 sessions + 35 coaching-data entries). Healthy across 4 of 5 dimensions; Decision Patterns in **Watch** (sub-pattern shifted from under-logging to gate-skip meta-decisions and high-signal interrupt pattern). **The One Thing:** treat your interruption-impulse as a deliberate review gate — `editorial-disagreement` gate fires 5/5 changed across visible window. Prior recommendation substantially acted on. Log: `logs/coaching-log.md`.
- **/audit-claude-md (monthly):** SKIPPED — workspace scope not selected (consistent with command spec).
- **/token-audit (monthly):** 2 HIGH (1 carried forward), 3 MEDIUM, 2 LOW. Two prior findings resolved (MAX_THINKING_TOKENS, Read() coverage). Report: `audits/token-audit-2026-05-01-ai-resources.md`. Best-practices maturity: 9/12 implemented, 2 partial.

### project repo-documentation

- **/audit-repo:** SKIPPED — repo-health-analyzer skill not deployed at this scope.
- **/improve:** SKIPPED — no `logs/improvement-log.md` (project tracks improvements at ai-resources layer by design).
- **/coach:** ran (16 sessions). Healthy across 3 dimensions; **Delegation Effectiveness in Watch** (session-boundary discipline blurred on 2026-04-30 — duplicate "Repo owner agent documentation layer" header at line 418/469). Workflow Evolution N/A by design. **The One Thing:** insert `/clear` between scope changes when chaining sessions in one terminal. Baseline run (first /coach for this project). Log: `projects/repo-documentation/logs/coaching-log.md` (created).

### project obsidian-pe-kb

- **/audit-repo:** SKIPPED — repo-health-analyzer skill not deployed.
- **/improve:** SKIPPED — no `logs/improvement-log.md`.
- **/coach:** ran (11 sessions: 7 active + 4 archived). Healthy across 2 dimensions; **3 dimensions in Watch** (Decision Patterns, Delegation Effectiveness, Workflow Evolution — all signal under-capture: structured `decisions.md` only logs 6 of ~30+ decisions made; `improvement-log.md` does not exist). **The One Thing:** promote tactical recurrences into rules within the same project, not at end-of-phase — tag-selection corrections (3 batches) and post-QC reference-cleanup (2 batches) recurred without elevation. Baseline run. Log: `projects/obsidian-pe-kb/logs/coaching-log.md` (created).

### knowledge-bases (workspace-root scope)

- **All checks SKIPPED** — no repo-health-analyzer deployed, no improvement-log, 0 wrapped sessions in `logs/session-notes.md`. CLAUDE.md exists but customized scope did not include /audit-claude-md.
- **Recommendation:** at next checkup that includes monthly tier, deploy at least repo-health-analyzer or run `/audit-claude-md` standalone against `knowledge-bases/CLAUDE.md`.

### project repo-documentation (W2.x — steps G/H/I/J/K, run 2026-05-01 session 2)

- **W2.1 doc-scanner (step G):** 7 added, 2 removed, 1 modified. Report: `projects/repo-documentation/output/phase-2/w2-1-doc-scan-2026-05-01.md`
  - Added: innovation-triage-auditor (agent), doc-scanner-agent (agent), principles-checker-agent (agent), system-developer-agent (agent), innovation-sweep (command), session-guide project-local (command — verify symlink), vault CLAUDE.md (claude-md-file)
  - Removed: pipeline-stage-2, pipeline-stage-2-5 (both workspace-root agents — likely superseded; investigate)
  - Modified: repo-health-analyzer Model field: sonnet → opus (live file declares opus)
- **W2.2 principles-checker (step H):** 15 findings — 7 errors, 8 warnings. Report: `projects/repo-documentation/output/phase-2/w2-2-principles-2026-05-01.md`
  - DR-1 (3 errors): nordic-pe project missing shared-manifest.json; 3 command files are project-local copies not symlinks (prime.md, wrap-session.md, note.md)
  - DR-3 (5 warnings): SKILL.md outside ai-resources canonical path (nordic step-1, buy-side reference/skills); sub-project CLAUDE.md; vault CLAUDE.md (intentional); resolve-improvements.md missing from disk
  - QS-6 (4 errors): 33/39 canonical commands missing H1 `# /command-name` title — highest-impact finding; also 3 nordic commands with no frontmatter/H1
  - QS-6 (3 warnings): 39/39 canonical commands missing name:/description: frontmatter (policy decision needed); project-planning local commands (6 files, no frontmatter)
- **W2.3 maintenance consolidator (step I):** Vault integrity scan (kb-integrity run inline). 3 findings — 1 error, 2 warnings. Report: `projects/repo-documentation/output/phase-2/w2-3-maintenance-2026-05-01.md`; integrity report at `vault/_integrity-report-2026-05-01.md`
  - Error: hooks.md count mismatch (_index.md says 14, live file has 16)
  - Warning (×2): architecture/repo-state.md and architecture/risk-topology.md not referenced in _master-index.md (added 2026-04-30 but master-index not updated)
- **W2.4 improvement-analyst (step J):** No findings. Friction log has only 2 entries (2026-04-18), both verified-applied in archive. Report: `projects/repo-documentation/output/phase-2/w2-4-improvements-2026-05-01.md`
- **K projects-layer refresh:** All 7 project entries updated in projects.md and repo-state.md (tracked + vault equivalents). Material changes: buy-side Phase updated (pre-execution → execution); corporate-identity Model populated (Opus 4.7); obsidian-pe-kb Phase updated (vault relocated, 5 gates pending); repo-documentation Phase current.

### Workspace-wide: /permission-sweep --dry-run

- 20 settings files scanned across 5 layers. **1 CRITICAL, 1 HIGH, 9 ADVISORY.**
- CRITICAL (Rule 4) carries an operator-context caveat: `defaultMode: bypassPermissions` IS set in ai-resources, and per operator memory bypass mode is the agreed setup. The "missing allow entries" finding may be a rule-template mismatch with the bypass-mode design rather than a true gap. **Operator review needed before remediation.**
- HIGH duplicates the workflow-settings `{{WORKSPACE_ROOT}}` placeholder finding from `/audit-repo`.
- Report: `audits/permission-sweep-2026-05-01.md` (dry-run, not applied).

## Tactical follow-ups

- [ ] Resolve `{{WORKSPACE_ROOT}}` placeholder in `workflows/research-workflow/.claude/settings.json` — risk: med (flagged by 2 independent auditors)
- [ ] Add `model: sonnet` and `effort: medium` to `skills/research-extract-verifier/SKILL.md` frontmatter — risk: low (1-line fix)
- [ ] Add `Read(audits/**)` and `Read(reports/**)` to `ai-resources/.claude/settings.json` — risk: low (closes residual H2 gap)
- [ ] Schedule a dedicated session for H1 (research-workflow prose-pipeline subagent return refactor) — risk: high (recurring, structural)
- [ ] Decide on H2 skill splits (answer-spec-generator + research-plan-creator + ai-resource-builder) — risk: med (structural, ~36,000 tokens/year savings)
- [ ] Decide on the 2 orphaned skills (`fund-triage-scanner`, `prose-refinement-writer`) — risk: low (keep or move to `deprecated/`)
- [ ] Sweep description quality on 11 trigger-gap + 7 exclusion-gap skills — risk: low (low-stakes prose pass)
- [ ] Delete orphan `usage/usage-log.md` (227 lines, pre-migration artifact) — risk: low (1-command delete)
- [ ] Operator review: `/permission-sweep` CRITICAL finding bypass-mode caveat — risk: med (do not blanket-apply remediation; verify intent first)
- [ ] `/cleanup-worktree` — working tree dirty (7 modified, 10 untracked). Run AFTER reviewing this checkup's reports — this session itself contributed audit files. — risk: med
- [ ] Verify at next `/wrap-session`: friction-log not populated since 2026-04-18 despite continued activity — confirm whether sessions have been smooth or operator-logging has lapsed — risk: low (signal calibration)
- [ ] Apply Coach's One Thing: state interruption-impulse explicitly when it surfaces — risk: low (behavior change, no code)
- [ ] Apply repo-documentation Coach's One Thing: `/clear` between scope changes — risk: low (workflow discipline)
- [ ] Apply obsidian-pe-kb Coach's One Thing: promote tactical recurrences to rules within-project — risk: low (workflow discipline)

**W2.1 doc-scan follow-ups:**
- [ ] Paste 4 new agent entries (innovation-triage-auditor, doc-scanner-agent, principles-checker-agent, system-developer-agent) into `output/phase-1/components/agents.md` and `vault/components/agents.md`; populate all 12 fields; link innovation-triage-auditor ↔ innovation-sweep — risk: low
- [ ] Verify `projects/repo-documentation/.claude/commands/session-guide.md` — if symlink to canonical, no additional registry entry needed; if separate file, paste command entry — risk: low
- [ ] Paste innovation-sweep command entry and vault CLAUDE.md claude-md-file entry into both registries — risk: low
- [ ] Investigate pipeline-stage-2 and pipeline-stage-2-5 (absent from live filesystem); if superseded by ai-resources canonical pipeline agents, mark Status: deprecated in agents.md — risk: med
- [ ] Fix repo-health-analyzer Model field in both registries: `sonnet` → `opus` — risk: low

**W2.2 principles violations follow-ups:**
- [ ] Create `shared-manifest.json` for `projects/nordic-pe-landscape-mapping-4-26/`; declare prime, wrap-session, note under `commands.local` if intentionally project-specific — risk: high (DR-1 error)
- [ ] Bulk fix: add `# /command-name` H1 title to 33 ai-resources canonical commands missing it — risk: high (QS-6 systemic; run `/friday-act` to dispatch to system-developer-agent)
- [ ] Investigate `ai-resources/.claude/commands/resolve-improvements.md` — listed in registry but not on disk; check git history — risk: med (DR-3 warn)
- [ ] Update DR-3 allowed-locations list in principles.md to include `vault/CLAUDE.md` as a documented intentional exception — risk: low
- [ ] Policy decision: adopt `name:` + `description:` frontmatter for canonical commands (39/39 currently missing), or document that command frontmatter is intentionally minimal — risk: med

**W2.3 kb-integrity follow-ups:**
- [ ] Fix `vault/components/_index.md` Hooks row: 14 → 16 (two hooks added since initialization) — risk: low
- [ ] Add `architecture/repo-state.md` and `architecture/risk-topology.md` to `vault/_master-index.md` (work-layer documentation added 2026-04-30; master-index not updated at that time) — risk: low

## Policy-level observations

- **`{{WORKSPACE_ROOT}}` placeholder is a recurring finding** — flagged by both `/audit-repo` and `/permission-sweep` this run. If the file is meant to be a `/deploy-workflow` template, document that explicitly and exclude from settings audits to prevent re-flagging. Otherwise, resolve.
- **H1 (research-workflow subagent returns) is recurring** — same finding from 2026-04-24 token-audit. Recurrence is the canonical trigger for policy-level review per `/friday-checkup` spec. Action: schedule the dedicated refactor session within the next 2 weeks or accept the carry-forward as a known tech-debt item.
- **knowledge-bases scope has no checkup infrastructure** — no repo-health-analyzer, no improvement-log, 0 wrapped sessions in logs. Either the scope is not active enough to warrant infrastructure deployment, or session telemetry isn't being captured. Operator decision.
- **Project-level coaching reveals a uniform pattern: structured logs under-capture decisions** — both repo-documentation (`decisions.md` lacks tactical decisions) and obsidian-pe-kb (`improvement-log.md` does not exist) show the same shape ai-resources had at 2026-04-24 baseline. Worth surfacing as a workspace-wide convention — perhaps via a slash command or hook nudge — rather than per-project rediscovery.
- **Friction-log not populated since 2026-04-18 despite 14+ commits** — either workflow has stabilized (positive signal) or operator-logging has lapsed (workflow infrastructure has no signal to act on). Monitor.

## All reports generated

- `audits/repo-health-ai-resources-2026-05-01.md` (cadence snapshot of audit-repo)
- `reports/repo-health-report.md` (canonical; updated by /audit-repo)
- `reports/repo-health-report-2026-04-24.md` (prior, auto-archived by /audit-repo)
- `audits/token-audit-2026-05-01-ai-resources.md` (token-audit report)
- `audits/working/audit-working-notes-preflight.md` (token-audit Section 0)
- `audits/working/audit-working-notes-skills.md` + `audit-summary-skills.md` (token-audit Section 2)
- `audits/permission-sweep-2026-05-01.md` (permission-sweep dry-run report)
- `audits/working/permission-sweep-2026-05-01.md` + `permission-sweep-2026-05-01.md.summary.md` (permission-sweep notes)
- `logs/coaching-log.md` (appended; 2nd entry)
- `projects/repo-documentation/logs/coaching-log.md` (created; 1st entry — baseline)
- `projects/obsidian-pe-kb/logs/coaching-log.md` (created; 1st entry — baseline)

**W2.x reports (G–K, session 2):**
- `projects/repo-documentation/output/phase-2/w2-1-doc-scan-2026-05-01.md` (W2.1 drift report)
- `projects/repo-documentation/output/phase-2/w2-2-principles-2026-05-01.md` (W2.2 violations report)
- `projects/repo-documentation/output/phase-2/w2-3-maintenance-2026-05-01.md` (W2.3 maintenance summary)
- `projects/repo-documentation/vault/_integrity-report-2026-05-01.md` (kb-integrity, gitignored)
- `projects/repo-documentation/output/phase-2/w2-4-improvements-2026-05-01.md` (W2.4 — no findings)
- `projects/repo-documentation/output/phase-1/components/projects.md` (K — projects registry updated)
- `projects/repo-documentation/output/phase-1/repo-state.md` (K — repo state updated)

## Notes

- **Mixed-tier execution:** This run combined monthly (ai-resources) and weekly (other scopes) checks per operator's pre-flight request. The standard `/friday-checkup` command does not natively support per-scope tier mixing — execution adapted while preserving the monthly report structure.
- **Skipped checks (auto):** repo-documentation /audit-repo (no skill), repo-documentation /improve (no log), obsidian-pe-kb /audit-repo (no skill), obsidian-pe-kb /improve (no log), knowledge-bases /audit-repo + /improve + /coach (no skill / no log / 0 sessions). All recorded in per-scope summaries above.
- **W2.x (G–K) completed in session 2** (2026-05-01) after the main checkup run. G/H/I/J/K findings appended to this report. See W2.x reports section in "All reports generated."
- **Commit behavior:** Per `/friday-checkup` Step 18, all files land unstaged for operator review at session wrap. Note conflict with `/token-audit` Step 17 (commit) — orchestrator no-commit rule takes precedence per workspace CLAUDE.md.
- **Plan QC gap (carried from 2026-04-24):** ai-resources scope when workspace not selected → ai-resources CLAUDE.md gets no direct audit. Same gap as prior run; consider revising `/audit-claude-md` command spec.
