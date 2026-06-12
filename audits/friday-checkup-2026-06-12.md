# Friday Checkup — 2026-06-12

## Tier
weekly (auto-detected)

## Scopes audited
- ai-resources
- workspace
- project marketing-positioning
- project nordic-pe-screening-project
- project positioning-research
- project project-planning

## Prioritized findings (rolled up across all scopes)

1. **[HIGH]** `permission-sweep` — Stale Daniel-machine path in `projects/interpersonal-communication/knowledge-base/.claude/settings.json` `additionalDirectories` (`/Users/danielniklander/...` does not exist on this machine → ai-resources symlinks fail for this nested KB).
2. **[HIGH-operational]** `permission-sweep` — `knowledge-bases/strategic-os` and `knowledge-bases/marketing-communication` settings missing `defaultMode: bypassPermissions` AND `additionalDirectories` entirely (permission prompts fire + ai-resources symlinks won't resolve in KB sessions). *(Auditor rated these ADVISORY; findings-extractor flagged them HIGH on operational impact — both views recorded; treat as do-soon.)*
3. **[IMPORTANT]** `audit-repo:positioning-research` — `knowledge-file-producer` SKILL.md missing `model:`/`effort:` frontmatter (canonical: `model: opus` / `effort: high`).
4. **[IMPORTANT]** `audit-repo:positioning-research` — `report-compliance-qc` SKILL.md missing `model:`/`effort:` frontmatter (canonical: `model: sonnet` / `effort: medium`).
5. **[ATTENTION]** working-tree — substantive **uncommitted** edit to the safety hook `ai-resources/.claude/hooks/check-foreign-staging.sh` (66 insertions / 10 deletions; self-labelled "Symptom B fix (2026-06-12)" — the heredoc/glob false-fire defect). Provenance unconfirmed (prior-today or concurrent session). Needs operator disposition before commit. See Tactical follow-ups.

Clean: `audit-repo:ai-resources` (GREEN, 0 HIGH/CRITICAL), `log-sweep` (dry-run inventory, no HIGH/CRITICAL), Stage-5 anchor consistency (PASS — empty diff).

## Per-scope summary

### ai-resources
- /audit-repo: **GREEN** overall, 0 Critical / 0 Important / 6 Minor (top: 2 byte-identical workflow command copies → convert to symlinks) → snapshot `audits/repo-health-ai-resources-2026-06-12.md`
- /improve: 0 new findings — all current friction already escalated/logged (40+ existing entries cover it) → `logs/improvement-log.md`
- /coach: ran (13 sessions) → entry appended to `logs/coaching-log.md`. Delegation=Watch (collector append-only risk), Decisions=Strong↑.

### workspace
- /audit-repo: skipped (no repo-health-analyzer deployed at workspace root)
- /improve: 3 new findings (schema-read-before-draft rule; schema-conformance hook; session-plan state-file preconditions) → triage at /friday-act
- /coach: ran (2 net-new sessions) → entry appended to `logs/coaching-log.md`. The One Thing: re-route reusable judgment calls into `decisions.md` (journal stale since 2026-05-26).

### project marketing-positioning
- /audit-repo: skipped (no repo-health-analyzer deployed)
- /improve: 5 new findings (broken remote / ~17 unpushed; deferred QC of research-workflow-contract.md never closes; concurrent-session churn; late tier-C reversal cascade convention; intra-day session numbering) → triage at /friday-act
- /coach: ran (15 sessions) → entry appended. The One Thing: hold first lock of scope-invalidating tier-C decisions for Daniel's joint presence.

### project nordic-pe-screening-project
- /audit-repo: skipped (no repo-health-analyzer deployed)
- /improve: 3 new findings (E4/family-office carve-out re-litigated per-fund; qc-reviewer unlaunchable under 1M model; ~21 unpushed / stale "no remote" Open Question) → triage at /friday-act
- /coach: ran (14 sessions) → entry appended. The One Thing: settle untested premises first. Prior rec acted on (v4.5 lock + autonomous run).

### project positioning-research
- /audit-repo: **YELLOW**, 0 Critical / 2 Important / 4 Minor → snapshot `audits/repo-health-project-positioning-research-2026-06-12.md`
- /improve: 3 new findings (chapter-draft churn / no outline-lock; mixed pipeline + workspace-infra session; memory written mid-execution) → triage at /friday-act
- /coach: ran (14 sessions) → coaching-log.md **created** (first run). The One Thing: one-line improvement-log entry per landed/parked item (tracking scattered across 5 files).

### project project-planning
- /audit-repo: skipped (no repo-health-analyzer deployed)
- /improve: 2 new findings (pipeline-entry commands set no mandate baseline → drift/contract checks blind; CLAUDE.md "How It Works" omits /session-start prereq) → triage at /friday-act
- /coach: ran (11 sessions; no new since 2026-06-05) → entry appended. The One Thing: clear or formally park one carry-forward backlog item per session open.

## Tactical follow-ups

### Audit-repo structural
- [ ] Add `model:`/`effort:` frontmatter to positioning-research `knowledge-file-producer` SKILL.md (opus/high) — risk: med
- [ ] Add `model:`/`effort:` frontmatter to positioning-research `report-compliance-qc` SKILL.md (sonnet/medium) — risk: med
- [ ] Reconvert positioning-research `refinement-pass.md` + `update-claude-md.md` to symlinks (byte-identical drift copies of canonical) — risk: low
- [ ] Replace 2 byte-identical workflow command copies in ai-resources with symlinks (per ai-resources audit top action) — risk: low

### Permission-sweep (report: `audits/permission-sweep-2026-06-12.md`)
- [ ] Fix stale Daniel-machine path in `projects/interpersonal-communication/knowledge-base/.claude/settings.json` `additionalDirectories` — risk: high
- [ ] Add `defaultMode: bypassPermissions` + `additionalDirectories` to `knowledge-bases/strategic-os` and `knowledge-bases/marketing-communication` settings — risk: med
- [ ] Add `Edit(**/.claude/**)` + `Write(**/.claude/**)` companion globs to `projects/axcion-brand-book` and `projects/ai-development-lab` settings — risk: low
- [ ] Review `projects/axcion-brand-book` deny glob `0[1-8]_*.md` silently overriding explicit allows for `02_color.md` / `03_typography.md` — risk: med
- [ ] (deferred) Migrate `additionalDirectories` out of 17 tracked project `settings.json` into `settings.local.json` — pending /new-project alignment — risk: low

### Log-sweep (report: `audits/log-sweep-2026-06-12.md`) — dry run, 320 logs inventoried
- [ ] Archive 3 oversized `session-notes.md` (ai-resources 543L/15 entries; marketing-positioning 726L/18; positioning-research 574L/17) — date-guard validation required before actual archival — risk: low

### Improve findings → triage at /friday-act (16 new across 5 scopes; full text in each scope's analysis above)
- [ ] workspace: schema-read-before-draft rule; schema-conformance hook (→ /pipeline-review); session-plan state-file preconditions — risk: med
- [ ] marketing-positioning: resolve broken remote / ~17 unpushed (decide remote vs local-only, record in CLAUDE.md); close deferred QC of research-workflow-contract.md via QC-PENDING mechanism; late tier-C reversal cascade convention — risk: med
- [ ] nordic-pe: record E4/family-office carve-out precedents in locked-criteria.md; pre-flight note for 1M-context QC sessions; drain ~21 unpushed + retire stale "no remote" Open Question — risk: med
- [ ] positioning-research: outline-lock micro-step for synthesis drafting; defer infra/canonical edits out of pipeline sessions (session-boundaries doc); confirm mid-execution memory correction is durable — risk: low/med
- [ ] project-planning: pipeline-entry mandate-baseline nudge; CLAUDE.md /session-start prerequisite line — risk: low

### Session issues (investigated, fix-ready for /friday-act)
- [ ] [SESSION-ISSUE] "Step 3.5 CONCURRENT block strands a no-own-marker session" (2026-06-04) — decide: fix / defer / close — risk: med
- [ ] [SESSION-ISSUE] "ai-resources cross-machine push divergence (non-fast-forward)" (2026-06-09) — decide: fix / defer / close — risk: med
- [ ] [SESSION-ISSUE] "system-owner agent reports 'Full advisory on disk' without write" (2026-06-10) — decide: fix / defer / close — risk: med
- [ ] [SESSION-ISSUE] "Unmarked /clarify-first session risks false-CONCURRENT write" (2026-06-10) — decide: fix / defer / close — risk: med
- [ ] [SESSION-ISSUE] "check-foreign-staging.sh: two naive-matching false-fires" (2026-06-11) — decide: fix / defer / close — risk: med

### Working tree
- [ ] **Disposition the uncommitted `check-foreign-staging.sh` edit** (66+/10− "Symptom B fix 2026-06-12") — confirm provenance, QC, then commit or revert. This appears to already implement part of the carried-over P3 defect fix. — risk: med
- [ ] `/cleanup-worktree` — ai-resources working tree dirty: 5 modified, 8 untracked (most are this checkup's own audit outputs + session-plan files) — risk: med
- [ ] `git push` — ai-resources: 4 unpushed commit(s) (gated to /wrap-session) — risk: med

## All reports generated
- `audits/repo-health-ai-resources-2026-06-12.md` (snapshot)
- `audits/repo-health-project-positioning-research-2026-06-12.md` (snapshot)
- `audits/permission-sweep-2026-06-12.md`
- `audits/log-sweep-2026-06-12.md`
- `audits/working/log-sweep-cross-scope-2026-06-12.md` (working notes)
- Coaching-log appends: ai-resources, workspace, marketing-positioning, nordic-pe-screening-project, project-planning; positioning-research coaching-log.md created
- This report: `audits/friday-checkup-2026-06-12.md`

---
*Section presence: weekly tier → Tactical follow-ups only (Policy-level observations and Architectural retrospective omitted by tier).*
