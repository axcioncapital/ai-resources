# Session Notes

> Archive: [session-notes-archive-2026-05.md](session-notes-archive-2026-05.md)

## 2026-05-11 — Created /explain command

### Summary
Created a new `/explain` slash command that re-explains Claude's most recent meaningful output, decision, or pending ask in plain English. The command went through the full design pipeline: /clarify, /scope, plan-mode exploration, /qc-pass (GO verdict), plan fixes, and implementation. The command is live in ai-resources and available in all projects via --add-dir.

### Files Created
- `.claude/commands/explain.md` — New slash command: three-section plain-English re-explanation (What I just did / What I decided / What I need from you), CEFR B2 with jargon glossing, hidden-state surfacing

### Files Modified
- `logs/session-notes-archive-2026-05.md` — auto-created by wrap-session log archive (10 entries archived from session-notes.md)

### Decisions Made
- **Command design:** Three fixed sections (What I just did / What I decided / What I need from you); empty sections use "Nothing — {reason}" rather than being omitted — directed by operator via /clarify + /scope
- **Language level:** CEFR B2 baseline with jargon glossed on first use (not a lower reading level) — operator chose option C in /clarify
- **Hidden state:** Surface load-bearing silent actions (files written, subagents, silent decisions) but cap at relevant ones — operator-directed recommendation accepted
- **QC fixes applied:** "skills list" → "slash-command list" in verification step; moved behavioral rule ("do not re-do the work") from Step 3 language rules into Step 4 no-side-effects section

### Next Steps
- Push: `git push` when ready
- /wrap-session is complete; run /usage-analysis separately if needed later

### Open Questions
- None

## 2026-05-11 — Bundle 3: CLAUDE.md fixes for axcion-ai-system-owner, global-macro-analysis, repo-documentation

**Mandate:** Apply CLAUDE.md audit findings to three projects (axcion-ai-system-owner, global-macro-analysis, repo-documentation) — each project: /risk-check + edit + /qc-pass + commit — done when all three committed.
- Out of scope: /new-project template rename, Bundle 1/2/4/5 items
- Files in scope: three project CLAUDE.md files + supporting references + ai-resources risk-check reports + logs
- Stop if: risk-check returns RECONSIDER on any project

### Summary
Applied CLAUDE.md audit findings across three projects, saving ~1,410 tokens per turn from always-loaded surface. Each project received plan-time /risk-check, edits, /qc-pass, and commit. The /new-project template collision (section name "Input File Handling" vs canonical "File Write Discipline") was discovered in Projects 1 and 3; resolved via mitigation option (b) — defer template update, document in decisions.md, add inline divergence notes. Decisions.md entry written to ai-resources/logs/ with trigger conditions and affected file list.

### Files Created
- `projects/axcion-ai-system-owner/references/project-layout.md` — ASCII tree moved out of always-loaded CLAUDE.md; header marks it as not loaded by the agent
- `projects/repo-documentation/references/phase-2-cadence.md` — Phase 2 cadence contract (triggering command, tier gate, subagents, findings destination, hard rule); moved from always-loaded CLAUDE.md
- `ai-resources/audits/risk-checks/2026-05-11-axcion-ai-system-owner-claude-md-cleanup.md` — PROCEED-WITH-CAUTION (Blast Radius Medium, Hidden Coupling Medium)
- `ai-resources/audits/risk-checks/2026-05-11-global-macro-analysis-claude-md-cleanup.md` — GO (all dimensions Low)
- `ai-resources/audits/risk-checks/2026-05-11-repo-documentation-claude-md-cleanup.md` — PROCEED-WITH-CAUTION (Reversibility High, Hidden Coupling High)

### Files Modified
- `projects/axcion-ai-system-owner/CLAUDE.md` — 94→58 lines: renamed section, moved layout tree, compressed Grounding/Toolkit blocks, dropped Compaction scratchpad sentence
- `projects/global-macro-analysis/CLAUDE.md` — 83→78 lines: deleted duplicate Commit Rules block, trimmed Command Scope Table, compressed Overview and Operational Notes
- `projects/repo-documentation/CLAUDE.md` — 54→36 lines: renamed section, deleted duplicate Commit Rules block, trimmed Project Layout, trimmed Compaction, fixed ".." typo, added divergence note
- `ai-resources/logs/decisions.md` — appended 2026-05-11 entry: deferred /new-project template rename (11 occurrences + grep probe at line 480)
- `ai-resources/logs/session-plan.md` — Bundle 3 plan (intent, class, model, source material, autonomy posture, risk); stop-point framing fixed per QC finding
- `ai-resources/logs/session-notes.md` — mandate line + Class: execution line written

### Decisions Made
- **Deferred /new-project template rename**: renaming "Input File Handling" → "File Write Discipline" in /new-project template deferred; 11 occurrences + idempotency grep (line 480) too large for Bundle 3 scope. Documented in decisions.md with trigger + affected file list.
- **decisions.md placement (Projects 1+3)**: placed divergence note entry in ai-resources/logs/decisions.md (cross-cutting log) since /new-project is ai-resources property — QC reviewer flagged as assumption, accepted.
- **Session plan QC fix**: moved stop-point directive from "Stop points:" bullet to Autonomy Posture body per QC finding.

### Next Steps
- Push all four repos: ai-resources, axcion-ai-system-owner, global-macro-analysis, repo-documentation
- Verify: was inbox/w24-improvement-loop-closure-brief.md → inbox/archive/ rename (swept into commit b41e0f6) intentional? This brief was slated for Bundle 4.
- Deferred: /new-project template rename (trigger: next template touch or /permission-sweep template-class pass) — see decisions.md 2026-05-11
- Remaining bundles: Bundle 1 (permission-sweep 4C+5H), Bundle 2 (settings items 5+6), Bundle 4 (inbox brief builds), Bundle 5 (week items 9–11)

### Open Questions
- Was the w24-improvement-loop-closure-brief.md archive move intentional (parallel session action swept into b41e0f6)? **Answered in next session (Bundle 4) — yes, intentional and correct: brief was already implemented 2026-05-08.**

## 2026-05-11 — Bundle 4: W2.4 fulfilled (discovery), plain-English brief review
Class: investigation/discovery (no new build)
**Mandate:** Start Bundle 4 (inbox brief builds) per the W20 week mandate. Done when: surfaced state of each remaining inbox brief AND identified which need real build sessions vs. cleanup-only.
- Out of scope: Bundles 1+2+3+5 (concurrent or prior sessions); pushing to remote; full builds of `/repo-review` or `/codex-dd` (operator-touch decision points → separate sessions)
- Files in scope: `inbox/` (all briefs); `logs/session-notes.md`
- Stop if: scope expands past discovery into full build work without operator intent

### Summary
Discovery-only session. The W2.4 improvement-loop closure brief turned out to be already fulfilled — commits `cd279d2` + `0ab0231` from 2026-05-08 shipped the Step 3c "No Active Friction Detection" path in `/resolve-improvement-log` and archived the 3 target stale entries on the same day the brief was filed. Concurrent Bundle 3 session moved the brief to `inbox/archive/` in commit `b41e0f6` at 10:51 today — confirmed intentional (answers Bundle 3's open question). No new build work for W2.4. Bundle 4 scope reduced from 3 briefs to 2 (`/repo-review`, `/codex-dd`). Provided plain-English explanations of both remaining briefs per operator follow-up. Telemetry + coaching skipped per preflight.

### Files Created
- None.

### Files Modified
- `logs/session-notes.md` — this entry (Bundle 4 wrap + Bundle 3 open-question resolution noted inline)
- `inbox/w24-improvement-loop-closure-brief.md` → `inbox/archive/w24-improvement-loop-closure-brief.md` (rename already committed by concurrent Bundle 3 session in `b41e0f6`; my `git mv` was a no-op)

### Decisions Made
- **Skipped W2.4 Monday design step.** The 2026-05-08 systems-review roadmap prescribed `/risk-check` + plan-mode + `/qc-pass` for Monday. With the build already shipped, running the design step would produce a design doc for non-existent work. Honored the prior implementation rather than redoing it.
- **Env-flag gap (`W24_ARCHIVE_ENABLED`) deferred.** Brief specified an env-flag rollback; implementation uses the existing `[y/n/select]` confirmation gate. The gate is documented as load-bearing ("Confirmation is load-bearing"). Adding an auto-archive override that bypasses the gate touches a deliberate trust choice and deserves dedicated `/risk-check` + design, not a casual follow-up.
- **Detection-mechanism difference accepted.** Brief proposed friction-log cross-reference within 21-day recency window; implementation uses intra-entry phrase signals. Simpler approach worked (3 entries archived successfully); no need to switch.
- **`/repo-review` and `/codex-dd` builds deferred.** Both warrant dedicated sessions: `/repo-review` is judgment-heavy with multiple operator-decision points (pipeline-test scope, criticality methodology, output schema); `/codex-dd` requires interactive `codex login` status check + throwaway cost-probe before first real run.

### Next Steps
- Push pending commits (operator manual step) — ai-resources is ahead of origin
- `/repo-review` dedicated session — design pass first (decide pipeline-test approach: worktree isolation vs. mock vs. skip; decide criticality scoring method; check whether `/systems-review` already covers friction synthesis question); brief is ~1 month old, validate scope before building
- `/codex-dd` dedicated session — Step 1 (`codex login` status) + Step 2 (throwaway probe to estimate cost/latency); brief is ~1 month old, Codex CLI surface may have shifted
- Env-flag `W24_ARCHIVE_ENABLED` (open consideration only): if operator wants steady-state auto-archive, design with `/risk-check` first

### Open Questions
- None.

## 2026-05-11 — Push 3 repos + /prime Next Steps staleness friction
Class: cleanup/maintenance
**Mandate:** Push pending commits on the three repos identified during /prime. Done when: all four repos reconciled with origin AND any blockers resolved.
- Out of scope: any new build work; inbox brief builds (still 2 pending)
- Files in scope: working trees of ai-resources, axcion-ai-system-owner, global-macro-analysis, repo-documentation; `logs/friction-log.md`
- Stop if: push fails or remote state diverges unexpectedly

### Summary
Cleanup session. /prime's brief reported Bundles 1+2+5 as "remaining" and ai-resources as "ahead of origin" — both wrong. Operator caught both errors. Investigation revealed /prime Step 1 copies "Next Steps" verbatim from the bottom session-notes entry; when same-day parallel sessions wrap out of order, that bottom entry's Next Steps was authored mid-execution and is stale at prime time. Friction-log entry written naming the failure mode and fix candidates. Verified actual push state across all four repos: ai-resources already pushed; axcion-ai-system-owner 4 commits ahead with 3 untracked duplicate command files; global-macro-analysis 2 commits ahead; repo-documentation never pushed (empty remote). Deleted 3 byte-identical duplicate command files in axcion-ai-system-owner (friday-journal.md, monday-prep.md, session-start.md — all unmodified copies of canonical ai-resources versions). Pushed all three remaining repos including first-push for repo-documentation with `-u origin main`. Committed friction-log update.

### Files Created
- None.

### Files Modified
- `ai-resources/logs/friction-log.md` — appended /prime "Next Steps" staleness entry (committed `6968f72`)
- `ai-resources/logs/session-notes.md` — this entry (wrap)

### Files Deleted
- `projects/axcion-ai-system-owner/.claude/commands/friday-journal.md` (untracked duplicate)
- `projects/axcion-ai-system-owner/.claude/commands/monday-prep.md` (untracked duplicate)
- `projects/axcion-ai-system-owner/.claude/commands/session-start.md` (untracked duplicate)

### Remote Pushes
- `axcion-ai-system-owner`: 4 commits pushed (`2466840..c241f78`)
- `global-macro-analysis`: 2 commits pushed (`52806c9..bd3336a`)
- `repo-documentation`: first push to empty remote, upstream tracking set (`main → origin/main`)
- `ai-resources`: already pushed before session started

### Decisions Made
- **Delete 3 duplicate command files in axcion-ai-system-owner.** They were byte-identical to the canonical ai-resources versions with no project-specific modifications. Operator-memory rule ("shared resources belong in ai-resources, project workspaces reference via copy or symlink, do not own them") applied. No information loss — pure duplicates.
- **First-push for repo-documentation.** Remote `axcioncapital/repo-documentation-2` existed but was empty. Used `-u origin main` to establish upstream tracking on the first push.

### Next Steps
- 2 inbox briefs still pending dedicated build sessions: `repo-review-brief.md`, `codex-second-opinion-brief.md`
- Consider `/improve` to analyze the /prime Next Steps staleness friction logged this session (recommended fix path: cross-check Next Steps items against git log since the entry's timestamp)
- Optional cleanup: add `.DS_Store` to global-macro-analysis `.gitignore`

### Open Questions
- None.

## 2026-05-11 — /open-items backlog-visibility command

### Summary
Created `/open-items`, a new slash command that scans the current project folder for unresolved items (friction, inbox briefs, next-up queue, applied-but-unverified improvements, deferred decisions, open session questions, session-plan checkboxes) and produces a tiered inline report. Default mode shows full detail for Tier 1 + Tier 2, with Tier 3 (low-signal backlog) as counts only. `/open-items full` expands Tier 3. A `[PRIORITY]` override section surfaces any item marked `[BLOCKING]` / `[HIGH]` / `[CRITICAL]` / `[URGENT]` regardless of source tier. Symlinked into 8 qualifying projects. Added a reminder line to `/prime` so the command surfaces every session.

### Files Created
- `ai-resources/.claude/commands/open-items.md` — canonical command file
- 8 project-level symlinks at `projects/<name>/.claude/commands/open-items.md` → ai-resources canonical (axcion-ai-system-owner, buy-side-service-plan, corporate-identity, global-macro-analysis, nordic-pe-landscape-mapping-4-26, obsidian-pe-kb, project-planning, repo-documentation)

### Files Modified
- `ai-resources/.claude/commands/prime.md` — added `**Backlog check:** Run /open-items …` line to the status block so the command surfaces every session

### Decisions Made
- **Three-tier signal classification, not flat list.** Operator raised the "dust corners under the sofa" concern after QC. Adopted Tier 1 (likely-action) / Tier 2 (awaiting trigger) / Tier 3 (counts only) instead of a flat dump. Tier 3 expanded only via `/open-items full`. Hard exclusions for `[LOW]` / `someday` / `nice-to-have` / `deferred indefinitely` / `*archive*.md`.
- **Universal `[PRIORITY]` override.** Items carrying `[BLOCKING]` / `[HIGH]` / `[CRITICAL]` / `[URGENT]` float to the top regardless of source tier — so explicit priority marking always wins.
- **Recency filter at 14 days.** session-plan checkboxes and session-notes Open Questions older than 14 days drop to Tier 3 (count only). Avoids forgotten-but-not-deleted items consuming attention.
- **Symlink fan-out to 8 of 9 projects.** Skipped `meeting-prep` because it has no `.claude/commands/` and no `logs/`. Matches existing pattern for shared commands like `friction-log.md`, `prime.md`, `wrap-session.md`.
- **QC revisions applied before approval:** expanded source list to include `next-up.md`, `session-plan.md`, `friction-log.md`; dropped uninstructed workspace-root detection branch; tightened match rules; explicit archive-file exclusion.

### Next Steps
- Run `/open-items` from a real project folder to see the tiered output in practice
- Consider whether `/new-project` should auto-add the open-items symlink for newly created projects
- 2 inbox briefs still pending: `repo-review-brief.md`, `codex-second-opinion-brief.md`

### Open Questions
- None.

## 2026-05-16 — /usage-analysis + /session-start + /session-plan (telemetry + session setup)
Class: execution
**Mandate:** Weekly /friday-checkup across ai-resources, workspace, interpersonal-communication, nordic-pe-macro-landscape-H1-2026, project-planning (off-schedule Saturday run) — done when: consolidated checkup report written to ai-resources/audits/friday-checkup-2026-05-16.md and all sub-reports recorded in RESULTS
- Out of scope: (none stated)
- Files in scope: ai-resources/audits/friday-checkup-2026-05-16.md, audit snapshot files, improvement-log.md (per scope), coaching-data.md (per scope), permission-sweep and log-sweep reports, logs/session-notes.md
- Stop if: (none stated)

## 2026-05-16 — Add git pull + unpushed-commits check to /prime

### Summary
Automated the manual "pull at session start" rule by adding Step 0 to /prime. The new step pulls the cwd repo and ai-resources (when different), reports results inline in the Prime brief, and surfaces any local unpushed commits as a visible reminder before they get forgotten. Plan was QC'd (REVISE verdict) and revised to address four findings before implementation. Replaced a legacy standalone prime.md in one project with a symlink so all 10 projects now share the canonical command.

### Files Modified
- `ai-resources/.claude/commands/prime.md` — added Step 0 (git pull with result table + unpushed-commits check) and `**Pulled:**` line in the Prime brief
- `projects/nordic-pe-landscape-mapping-4-26/.claude/commands/prime.md` — replaced 30-line standalone copy with symlink to ai-resources/.claude/commands/prime.md

### Decisions Made
- **Attachment point:** Add to /prime (one-step session-orientation entry point) rather than a SessionStart hook. Rationale: /prime is already the deliberate orientation command; a hook would fire even on `/clear`-continuations.
- **Pull scope:** Always pull cwd repo + ai-resources when different. Covers project sessions (project + ai-resources), workspace-root sessions (workspace + ai-resources), and ai-resources sessions (ai-resources only).
- **Standalone prime.md handling:** Replace nordic-pe-landscape-mapping-4-26's custom prime.md with a symlink to align with the other 9 projects.
- **Unpushed-commits visibility:** Added after operator raised concern that git pull could mask forgotten pushes. The pull itself is safe (never overwrites local commits), but the brief was misleading — now shows `up to date — N unpushed` when applicable.
- **QC fixes (4):** workspace-root IS a git repo (verified); explicit do-not-renumber instruction; precise result table for `up to date` / `updated` / `skip (no upstream configured)` / `failed`; `GIT_TERMINAL_PROMPT=0` to prevent credential hangs.

### Next Steps
- Push 3 commits when ready: 2 in ai-resources (prime Step 0 + unpushed check), 1 in nordic-pe-landscape-mapping-4-26 (symlink swap)
- Next session: /prime will exercise the new Step 0 — verify the brief format renders correctly

### Open Questions
- None.

## 2026-05-16 — /friday-journal — ingest and process 15 journal entries
Class: execution
**Mandate:** Run /friday-journal on ai-journal.md — done when: report written to audits/friday-journal-2026-05-16.md, QC passed, active section archived.

### Summary
Ran /friday-journal on a freshly populated ai-journal.md. Active section was initially empty from a prior archived run; 15 entries were written via a /clarify → /scope pass during the session (entries covered session-start hook chain, decision-point posture strengthening, friday-act/friday-journal improvements, new-project pipeline fixes, and /resolve-improvement-log wiring). /friday-journal generated a 15-item implementation report, ran mechanical pre-check (pass), QC subagent (REVISE verdict), and disposition loop (4 kept, 1 revised, 1 flagged for risk-check). Active section archived to ## Archive — 2026-05-16.

### Files Created
- `audits/friday-journal-2026-05-16.md` — /friday-journal implementation report, 15 items (high: 4, med: 8, low: 3)
- `audits/working/journal-qc-2026-05-16.md` — QC working notes from qc-reviewer subagent

### Files Modified
- `logs/ai-journal.md` — 15 entries written to active section then archived under ## Archive — 2026-05-16; active section cleared

### Decisions Made
- **QC finding 3 (research-plan-creator target):** REVISED — item relabelled as skill target; Files updated to `skills/research-plan-creator/SKILL.md`. Prior item incorrectly pointed at a command path that doesn't exist.
- **QC finding 4 (/new-project risk-class):** FLAGGED for /risk-check — shared-state automation class; `**Risk-check required:**` bullet added to Item context.
- **QC findings 5+6 (composite alternative, sibling redundancy):** KEPT separate — independent dispositioning by /friday-act is the right granularity; QC and refinement passes have distinct purposes.
- **Entry #10 (/friday-act input scope):** Logged as "expand spec's required reads" rather than operator-side pre-step — operator noting 3 rounds of correction means the burden should not stay with operator.

### Next Steps
- Commit this session's files: `audits/friday-journal-2026-05-16.md`, `audits/working/journal-qc-2026-05-16.md`, `logs/ai-journal.md`, `logs/session-notes.md`, `logs/decisions.md`
- Run `/friday-act` — report auto-loads as journal source alongside checkup
- Push when ready

### Open Questions
- None.

## 2026-05-16 — fix /prime Step 2 innovation-count grep (BSD grep BRE false positive)

### Summary
Single targeted fix to /prime Step 2. The innovation-count grep used `\|` escapes which BSD grep on macOS treats as BRE alternation, causing the pattern to match every pipe-starting table row (returning 98 instead of 0). Replaced with a column-scoped awk command that correctly checks the Status column value.

### Files Created
- None.

### Files Modified
- `.claude/commands/prime.md` — Step 2 innovation-count: replaced broken grep pattern with `awk -F'|' 'NR>2 && $5~/^ detected $/{c++}END{print c+0}'`

### Decisions Made
- None beyond the bug fix itself.

### Next Steps
- Push: 2 commits pending (`9ff8b05` session wrap, `d3c27ff` prime fix)
- Run `/friday-act` — friday-journal report is ready to consume

### Open Questions
- None.

## 2026-05-16 — /friday-checkup (weekly tier, off-schedule Saturday)

### Summary
Off-schedule Saturday run of `/friday-checkup` weekly tier across 5 scopes (ai-resources, workspace, interpersonal-communication, nordic-pe-macro-landscape-H1-2026, project-planning). Diagnostic-only per operator directive — no fixes applied. Top critical: nordic-pe-macro-landscape-H1-2026 references a missing `context/` directory in `produce-prose-draft.md` and `produce-architecture.md`. Permission-sweep returned 0 critical / 4 high / 1 medium; log-sweep flagged a single archive candidate (`usage-log.md` 652 lines). Coach run produced 3 fresh coaching-log entries (1 appended, 2 created from baseline). 22 tactical follow-ups consolidated for `/friday-act`.

### Files Created
- `audits/friday-checkup-2026-05-16.md` — consolidated weekly checkup report
- `audits/permission-sweep-2026-05-16.md` — dry-run report
- `audits/log-sweep-2026-05-16.md` — dry-run report
- `audits/repo-health-ai-resources-2026-05-16.md` — cadence snapshot
- `audits/repo-health-project-nordic-pe-macro-landscape-H1-2026-2026-05-16.md` — cadence snapshot
- `audits/working/permission-sweep-2026-05-16.md` + `.summary.md` — full notes + ≤30-line summary
- `audits/working/log-sweep-ai-resources-2026-05-16.md`
- `audits/working/log-sweep-project-interpersonal-communication-2026-05-16.md`
- `audits/working/log-sweep-project-nordic-pe-macro-landscape-H1-2026-2026-05-16.md`
- `audits/working/log-sweep-project-project-planning-2026-05-16.md`
- `projects/nordic-pe-macro-landscape-H1-2026/logs/coaching-log.md` — baseline coach entry
- `projects/project-planning/logs/coaching-log.md` — baseline coach entry

### Files Modified
- `ai-resources/logs/session-notes.md` — mandate line for this session + this wrap entry
- `ai-resources/logs/session-plan.md` — overwritten with friday-checkup plan
- `ai-resources/logs/coaching-log.md` — appended 2026-05-16 entry
- `ai-resources/reports/repo-health-report.md` — refreshed by `/audit-repo` (prior archived as `repo-health-report-2026-05-16.md`)
- `projects/nordic-pe-macro-landscape-H1-2026/reports/repo-health-report.md` — refreshed by `/audit-repo`

### Decisions Made
- **Diagnostic-only run.** No improvement-log findings applied; all 6 analyst findings were already logged from a prior session today (de-dup hit). Continued through Steps C–G without remediation. Rationale: operator stated "diagnostic only" early in the run.
- **Skip H-1 and M-1 permission-sweep findings.** Both recommend adding to deny list; conflicts with stored operator policy (`feedback_zero_permission_prompts`: never add to deny list; bypassPermissions floor is the agreed setup).
- **/coach run across 3 eligible scopes in parallel.** ai-resources, nordic-pe-macro, project-planning all met ≥5 sessions threshold; interpersonal-communication (4) and workspace (no session-notes) skipped.
- **Off-schedule Saturday run accepted as weekly tier.** /friday-checkup last ran 2026-05-08 (8 days ago, within the 10-day recovery window); operator overrode the off-schedule prompt with `weekly`.

### Next Steps
- Run `/friday-act` to triage the 22 tactical follow-ups in `audits/friday-checkup-2026-05-16.md` (1 critical, 6 high, 13 medium/low, 2 deferred-by-policy)
- Top-priority items for /friday-act: (1) resolve nordic-pe-macro missing `context/` directory; (2) push 6 unpushed ai-resources commits; (3) apply 4 HIGH permission-sweep fixes (gitignore + additionalDirectories); (4) run `/improve` against nordic-pe-macro session-plan hook overwrite (3 deferred occurrences); (5) run `/resolve-improvement-log` session against ai-resources logged-pending entries
- Optional: cleanup-worktree on workspace root (21 deletions of `projects/personal/*` accumulating)

### Open Questions
- None.

## 2026-05-16 — Prohibit model defaults workspace-wide (settings.json AND CLAUDE.md)

### Summary
Operator reported that declaring a model in settings.json or as a default in CLAUDE.md prevents in-session `/model` switches from taking effect. Extended the existing "no model in settings.json" rule (originally 2026-05-08) to also cover CLAUDE.md — model defaults are now prohibited at every config layer workspace-wide. The only permitted mechanism for declaring a tier outside the live session is per-command, per-agent, and per-skill `model:` YAML frontmatter. Removed all model defaults from settings + CLAUDE.md, updated repo documentation, rewrote the related memory note.

### Files Created
- None.

### Files Modified
- `.claude/settings.json` — removed `"model": "sonnet[1m]"` (workspace root)
- `projects/buy-side-service-plan/.claude/settings.local.json` — emptied to `{}`
- `projects/project-planning/.claude/settings.local.json` — emptied to `{}`
- `projects/obsidian-pe-kb/.claude/settings.local.json` — emptied to `{}`
- `projects/obsidian-pe-kb/.claude/settings.json` — removed `"model"` field
- `projects/interpersonal-communication/vault/.claude/settings.json` — removed `"model"` field
- `ai-resources/workflows/research-workflow/.claude/settings.json` — removed `"model"` field
- `ai-resources/skills/obsidian-kb-builder/templates/scaffold/settings.json` — removed `"model"` field (template; propagates to new vaults)
- `CLAUDE.md` — workspace-level § Model Tier rewritten with explicit prohibition + rationale; per-skill frontmatter added to permitted mechanisms
- `ai-resources/CLAUDE.md` — § Model Selection rewritten with prohibition pointer
- `projects/buy-side-service-plan/CLAUDE.md` — Model Selection rewritten as recommended-posture only
- `projects/project-planning/CLAUDE.md` — Model Selection rewritten as recommended-posture only
- `projects/obsidian-pe-kb/CLAUDE.md` — Model Selection rewritten as recommended-posture only
- `projects/interpersonal-communication/CLAUDE.md` — Model Selection rewritten as recommended-posture only
- `projects/global-macro-analysis/CLAUDE.md` — Model Selection rewritten as recommended-posture only
- `projects/personal/travel-os/CLAUDE.md` — Model Selection rewritten as recommended-posture only
- `ai-resources/docs/permission-template.md` — removed `"model": "sonnet"` from canonical Layer C template; key-assertion flipped to "no `model` field" with rationale
- `ai-resources/docs/audit-discipline.md` — model-default audit recommendations must be rejected outright, not run through the discipline
- `ai-resources/docs/autonomy-rules.md` — Autonomy Rule #8 no longer lists model-default changes (prohibited outright, not gateable)
- `ai-resources/docs/onboarding-daniel.md` — "Set up your model tier" rewritten as "Select your session model" (per-session via `/model`)
- `ai-resources/docs/repo-architecture.md` — project directory map annotated "no default model — prohibited"
- `ai-resources/.claude/commands/deploy-workflow.md` — canonical-merge no longer adds `model: sonnet[1m]`; uses `del(.model)` to strip pre-existing model fields on deploy
- `~/.claude/projects/.../memory/feedback_no_model_in_settings_json.md` — rewritten to cover settings.json AND CLAUDE.md, clarifies per-command/agent/skill frontmatter remains permitted

### Decisions Made
- **Scope of prohibition.** Extended from settings.json-only (prior rule, 2026-05-08) to also cover CLAUDE.md, per operator directive. Rationale: same downstream effect — both layers block in-session `/model` switches.
- **Recommended-posture preserved in project CLAUDE.md.** Operator did not direct removal of the per-project Model Selection sections; rewrote them as recommendation-only ("lean Opus for plan drafting; Sonnet for routine edits") rather than deleting. This preserves project-specific tier guidance without asserting a default.
- **Skills added to permitted mechanisms** (operator correction mid-session: "Yes, and its also allowed for skills"). Initial draft only mentioned commands + agents; expanded to commands + agents + skills across workspace CLAUDE.md, ai-resources CLAUDE.md, and the memory note.
- **deploy-workflow merge procedure now strips a pre-existing `model` field** via `del(.model)` rather than just not setting one. Catches drift from older deploys that ran the previous merge logic.

### Next Steps
- Push the upcoming commit (operator approval required).
- Verify `/model` switches work as expected in the next session start.
- Optional `/friday-act` candidate: scan archived/historical audit files for stale "add canonical model baseline" recommendations and tag them as superseded.

### Open Questions
- None.

### End-time risk-check
Skipped. Change scope was operator-directed end-to-end with a mid-session correction (skills added to permitted mechanisms) already incorporated. Touched classes: cross-cutting CLAUDE.md edits, settings edits, one shared command edit (`deploy-workflow.md`). All changes are reversible config/doc edits; no hook execution paths, no permission allow/deny shifts, no symlinks. Operator directive was explicit and tightly scoped. Coaching + telemetry both declined in preflight.

## 2026-05-16 — Innovation sweep: 6 projects, 7 graduate candidates identified

### Summary
Ran a full innovation triage sweep across 6 selected projects (axcion-ai-system-owner had 0 local resources and was skipped; 5 projects active). Used /clarify and /scope to structure the request before entering plan mode, then spawned 5 parallel `innovation-triage-auditor` subagents. Classified 101 items total and produced a consolidated triage report with 7 graduate candidates, 8 loose ends, 40 already-graduated, and 46 keep-local verdicts. Key finding: nordic-pe's 17 "local" commands turned out to be byte-identical research-workflow deploys — the upstream inventory had missed the `ai-resources/workflows/research-workflow/` path. Updated the innovation registry with 23 new entries.

### Files Created
- `audits/innovation-sweep-2026-05-16.md` — consolidated triage report with graduate candidates, loose ends, verdict summary table
- `audits/working/innovation-sweep-2026-05-16/global-macro-analysis/notes.md` — per-project working notes (gitignored)
- `audits/working/innovation-sweep-2026-05-16/interpersonal-communication/notes.md` — per-project working notes (gitignored)
- `audits/working/innovation-sweep-2026-05-16/nordic-pe-macro-landscape-H1-2026/notes.md` — per-project working notes (gitignored)
- `audits/working/innovation-sweep-2026-05-16/obsidian-pe-kb/notes.md` — per-project working notes (gitignored)
- `audits/working/innovation-sweep-2026-05-16/repo-documentation/notes.md` — per-project working notes (gitignored)

### Files Modified
- `logs/innovation-registry.md` — 23 new entries appended (7 graduate, 8 loose-end, 8 keep-local/already-graduated)

### Decisions Made
- **Project selection:** Operator selected projects 1 (axcion-ai-system-owner), 4 (global-macro-analysis), 5 (interpersonal-communication), 7 (nordic-pe-macro-landscape-H1-2026), 8 (obsidian-pe-kb), 10 (repo-documentation)
- **Verdict bar:** "anything that looks generalizable" (operator-directed, not usage-proven)
- **Scope:** Triage only — no actual graduation executed this session
- **Implementation:** Consolidated into one report (not per-project); parallel subagents rather than sequential /innovation-sweep skill invocations

### Next Steps
- Graduate G1 (SessionStart upward-walk pattern) → `ai-resources/docs/permission-template.md`: run `/graduate-resource` or edit permission-template.md directly
- Graduate G2 (deny-archive permissions shape) → same target
- Graduate G3–G5 (decision-logger, checkpoint-nag, five-hook taxonomy) → workflow-level settings reference
- Graduate G6 (compaction "trust the summary" rule) → `ai-resources/docs/compaction-protocol.md`
- **Fix LE4 (urgent):** Delete or repoint broken symlink `obsidian-pe-kb/.claude/commands/resolve-improvements.md` → `resolve-improvement-log.md`
- **Fix LE5 (urgent):** Remove `model` field from `obsidian-pe-kb/.claude/settings.json`
- Decide on loose ends LE1–LE3, LE6–LE8 (today-drill, auto-commit policy, friction-log-trigger, compaction scratchpad)

### Open Questions
- LE3 (auto-commit hook): conflicts with workspace Commit Rules — intentional exception or remove?
- LE2 (CLAUDE.md §Autonomy Rules from nordic-pe): graduate to workspace docs or keep project-local?

### End-time risk-check
Skipped — session touched no structural change classes (no hooks, no permission changes, no CLAUDE.md edits, no commands/skills/symlinks). Files produced were audit outputs and a registry log append only.
