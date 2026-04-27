# Session Notes

> Archive: [session-notes-archive-2026-04.md](session-notes-archive-2026-04.md)

## 2026-04-24 — Fix working tree (cleanup pass)

## 2026-04-24 — Commission v4 Batch 1 — /risk-check command + agent + audit-discipline + workspace CLAUDE.md edit

Plan: `/Users/patrik.lindeberg/.claude/plans/here-s-an-idea-i-memoized-bumblebee.md`
Scope: Batch 1 only (not Batches 2–5).

### Summary

Built `/risk-check` as a pre-execution gate for structural change classes (hook edits, permission changes, cross-cutting CLAUDE.md edits, new commands/skills, new symlinks, automation with shared-state effects). The command takes a free-text change description, delegates to an Opus subagent (`risk-check-reviewer`) with fresh context, and produces a verdict — GO / PROCEED-WITH-CAUTION / RECONSIDER — across five risk dimensions (usage cost, permissions surface, blast radius, reversibility, hidden coupling). Landed the authoritative class list and verdict semantics in `docs/audit-discipline.md`, and added a new pause-trigger #9 to workspace `CLAUDE.md` Autonomy Rules. QC cycle: REVISE → 3 Do fixes applied (OMIT-contract validation, `AI_RESOURCES` path ordering, mitigation-count alignment) → post-edit QC GO. Functional verification ran on a synthetic PreToolUse logging hook, producing PROCEED-WITH-CAUTION with three paired mitigations.

### Files Created

- `ai-resources/.claude/commands/risk-check.md` — the `/risk-check` command (Opus); 6 steps, 21 items; input validation → path setup → subagent spawn → structural validation (enforces OMIT contract + `max(1, NUM_HIGH)` mitigation count per verdict) → operator summary → no-auto-commit semantics
- `ai-resources/.claude/agents/risk-check-reviewer.md` — supporting subagent (Opus); 9 steps; evaluates 5 dimensions with heuristic Low/Medium/High thresholds; synthesizes verdict; writes structured report; returns ≤20-line summary with `REPORT:` last-line marker
- `ai-resources/audits/risk-checks/2026-04-24-add-a-new-pretooluse-hook-that-logs-every-write-tool.md` — dogfood report from functional verification (PROCEED-WITH-CAUTION; 3 Medium dimensions; 3 paired mitigations)

### Files Modified

- `ai-resources/docs/audit-discipline.md` — added `## Risk-check change classes` section (authoritative class list + verdict semantics + invocation semantics + overlap with top-3 analysis); extended the "When to read this file" line
- `CLAUDE.md` (workspace root, separate repo) — added pause-trigger #9 to `## Autonomy Rules` listing the risk-check change classes and verdict honor rule; explicit note that #8 and #9 can both apply to audit-derived permission changes
- `ai-resources/logs/session-notes.md` — this entry

### Decisions Made

Pre-execution (operator-confirmed at batch opening):
- Assumption sign-offs per plan handoff notes: accepted defaults for `/friday-act` name, `audits/risk-checks/` subdirectory, change classes list, coaching-log untouched

Design (during build):
- Subagent-writes-report pattern (main session reads returned summary + validates structure) — matches ai-resources CLAUDE.md Subagent Contracts convention
- Command does NOT auto-commit the report — operator bundles it with the change commit if wanted. Separates the pre-execution gate from the change itself.
- No auto-firing hook for `/risk-check` (no SessionStart / Stop / PreToolUse). Operator-invoked or inline-invoked by other commands (e.g., `/friday-act` in Batch 2). Rationale: auto-firing would over-escalate on ordinary edits.

Harness-level configuration (pause-trigger #8 gate — completed):
- Top-3-commands-affected analysis for workspace `CLAUDE.md` edit: `/create-skill`, `/new-project`, `/friday-checkup` (+`/friday-act` when Batch 2 lands). None blocked or degraded — edit is additive.

QC-driven fixes (routine auto-loop, applied after triage):
- Enforce OMIT contract in command Step 4 (verdict GO → neither optional section has content; PROCEED-WITH-CAUTION → no Recommended redesign; RECONSIDER → no Mitigations)
- Resolve `AI_RESOURCES` path-ordering (moved path extraction from Step 1 to Step 2 after `AI_RESOURCES` is defined)
- Mitigation-count alignment: command now requires `max(1, NUM_HIGH)` mitigation bullets for PROCEED-WITH-CAUTION, mirroring the agent's "≥1 per High dimension" generation rule
- Park: agent's unused `Bash` tool grant (low consequence); slug-truncation edge case documentation (fallback already works)

Commit split:
- Two commits — `ai-resources` (`178f127`) and workspace parent (`03ec193`) — because the batch spans two repos. Each commit references the other in its body. Plan's "one commit per batch" adjusted to "one commit per batch per repo."

### Next Steps

- **Push** `ai-resources` `178f127` and workspace parent `03ec193` (both on `main`) — requires operator approval.
- **Batch 2** in a fresh session: `/friday-act` command + tier-differentiated `/friday-checkup` output (weekly tactical / monthly policy / quarterly architectural). Plan handoff notes say this is the largest batch — full session on its own. Inline `/risk-check` invocation on risky fixes is the primary dogfood hook.
- **First real `/risk-check` invocation** in a new session will resolve the named `risk-check-reviewer` subagent_type directly (agent registration happens at session start; this session used `general-purpose` with the agent body inlined for verification).
- **Pacing:** plan handoff says don't attempt more than 2 batches per session. Batch 2 alone is a full session.

### Open Questions

- None. Remaining batches (2–5) have their own sign-off gates at the top of each batch per plan handoff notes.

## 2026-04-25 — Working-tree drift prevention (5 fixes landed)

### Summary

Followup to the 2026-04-24 cleanup-worktree session, which uncovered four benign-but-symptomatic issues tracing to two structural gaps: session-end hygiene (uncommitted edits and unstaged finished files surviving across sessions) and canonical-state drift (settings.json deny entries silently regressing; denied scratchpad directory not gitignored). Operator also flagged that they ran /cleanup-worktree while a concurrent Claude Code session was active and asked for a programmatic guardrail. Designed and landed five preventative fixes (F1–F5); G1/G3/G4 deferred as opportunistic.

### Files Created

- `audits/risk-checks/2026-04-25-f2-add-a-concurrent-session-detection-and-abort-to-cleanup.md` — risk-check report on F2 (verdict RECONSIDER → operator-disclosure redesign)
- `audits/risk-checks/2026-04-25-f3-g5-two-bundled-edits-to-workspace-claude-md.md` — risk-check report on F3+G5 (verdict PROCEED-WITH-CAUTION; G5 dropped per recommendation)
- `audits/working/qc-f2-cleanup-worktree-disclosure-2026-04-25.md` — post-edit QC report for F2 (gitignored)

### Files Modified

- `.claude/commands/cleanup-worktree.md` — F2: mandatory operator-disclosure prompt at Step 1; refuses to run if another Claude Code session is active (commit d2d1b15)
- `../CLAUDE.md` (workspace root) — F3: extends "Concurrent-session staging discipline" to name /cleanup-worktree and /permission-sweep as the dangerous commands (commit bcf45a9 in workspace-root repo)
- `.claude/hooks/check-permission-sanity.sh` — F4: SessionStart hook now asserts safety-floor deny entries Bash(rm -rf *) and Bash(sudo *); nudges if missing (commit 5a45d37)
- `docs/permission-template.md` — F5: adds Rule 14 to detection rulebook (gitignore-vs-deny parity for Read denies); ADVISORY severity (commit 8fd7435)
- `.claude/agents/permission-sweep-auditor.md` — F5: rule count 13→14 in three places (commit 8fd7435)
- `.claude/commands/wrap-session.md` — F1+G2: new Step 13a working-tree dirt check; surfaces dirty paths not produced this session, asks per-path disposition (commit/defer-WIP/ignore), nudges toward /cleanup-worktree if any deferred (commit 064e371)
- `logs/session-notes.md` — wrap entry appended; auto-archived by check-archive.sh (3 older entries moved out)
- `logs/session-notes-archive-2026-04.md` — archive file extended with 3 older April entries by check-archive.sh
- `logs/decisions.md` — wrap entry appended (5-point design-choices)
- `logs/coaching-data.md` — wrap entry appended

### Decisions Made

- **F2 redesign — operator disclosure over pgrep.** /risk-check returned RECONSIDER on the original mechanical-pgrep design (pgrep returned 12 matches in a single Claude Code session due to helper processes). Adopted the recommended redesign (option 1 in the report): a Step 1 disclosure prompt aligned with the existing CLAUDE.md "Concurrent-session staging discipline" pattern.
- **G5 dropped as redundant.** F3 already documents the rule in the discipline section; adding /cleanup-worktree to Autonomy Rules pause-triggers would duplicate without adding load-bearing semantics. Risk-check report flagged this redundancy.
- **F5 severity ADVISORY (plan said HIGH).** Existing rulebook taxonomy: HIGH = Delete/Edit prompts; this is hygiene (no live or future prompt). ADVISORY fits the existing severity structure.
- **Stop after the core five.** G1 (stale-edit SessionStart hook), G3 (cleanup-worktree marker file), G4 (friday-checkup stale-work item) deferred. Core five cover both failure classes from the 2026-04-24 incident; G items are nice-to-have additions.
- **Reduced /risk-check ceremony mid-session.** Operator pushback on overcomplication. After F3+G5 risk-check, skipped /risk-check on F4 and F5 — both small extensions to existing files (validation lines added to a hook, new check class added to an auditor), not new structural infrastructure.

### Next Steps

- **Push when ready** — workspace-root has commit `bcf45a9`; ai-resources has commits `d2d1b15`, `c52807e`, `5a45d37`, `8fd7435`, `064e371`. Two repos to push.
- Optionally pick up G1 / G3 / G4 in a future session if the core five turn out to be insufficient.
- F1 (wrap-session dirt check) is being exercised right now — this is the first invocation of /wrap-session after F1 landed. If anything in Step 13a feels off, log it as friction.

### Open Questions

- None.

## 2026-04-25 — /risk-check trigger model: per-change → two-gate

### Summary

Operator flagged that `/risk-check` was firing too frequently mid-session under the per-change rule and burning tokens. Designed a two-gate model — plan-time (after plan approval, if the plan touches a structural class) and end-time (once before commit, batched across all in-class changes the session actually made) — replacing per-change firing. Edits landed across workspace `CLAUDE.md`, `ai-resources/docs/audit-discipline.md`, and `.claude/commands/risk-check.md`. Ran the new policy on itself (end-time gate); verdict PROCEED-WITH-CAUTION required two paired mitigations, both applied (workspace CLAUDE.md trim + `/wrap-session` Step 13b reminder).

### Files Created

- `audits/risk-checks/2026-04-25-change-risk-check-trigger-semantics-from-per-change-to-two.md` — risk-check report on the two-gate change set (verdict PROCEED-WITH-CAUTION; two mitigations required, both applied)

### Files Modified

- `../CLAUDE.md` (workspace root, separate git repo) — pause-trigger #9 reworded twice: first to two-gate semantics with full prose; then trimmed to ~95 words after end-time `/risk-check` flagged always-loaded surcharge. Detail moved to `audit-discipline.md`.
- `docs/audit-discipline.md` — added "When to fire (two-gate model)" subsection under § Risk-check change classes; defines plan-time/end-time payloads and skip rules for unplanned/no-touch sessions.
- `.claude/commands/risk-check.md` — added "Two intended call sites per session" block above invocation semantics.
- `.claude/commands/wrap-session.md` — added Step 13b end-time `/risk-check` gate (between dirt check Step 13a and commit). Note: this edit was inadvertently swept into the concurrent session's wrap commit `26d9c7f` rather than being staged here. The change landed correctly; commit-message narrative is incomplete.
- `audits/permission-sweep-2026-04-24.md` — pre-existing untracked file from 2026-04-24, committed with this session per operator disposition (c).
- `audits/risk-checks/2026-04-24-workspace-claude-md-chat-communication-style.md` — pre-existing untracked file from 2026-04-24, committed with this session per operator disposition (c).
- `workflows/research-workflow/.claude/settings.json` — pre-existing modification from 2026-04-24, committed with this session per operator disposition (c).

### Decisions Made

- **Adopted two-gate model** over per-change firing. Rationale: per-change pattern multiplied tokens during structural-change sessions without proportionate signal. Two gates preserve early design-risk catch and end-of-session drift catch while bounding firings to ≤2 per session. Complementary to the concurrent session's decision #5 ("Reduced /risk-check ceremony for small edits") — that decision narrows trigger *classes*; this decision changes firing *cadence* within those classes.
- **Trimmed workspace CLAUDE.md pause-trigger #9** to ~95 words (matching prior baseline length) after end-time `/risk-check` flagged always-loaded token surcharge. Prose detail moved to `audit-discipline.md`.
- **Added `/wrap-session` Step 13b** as the operator-tactile prompt for the end-time gate. Smallest viable mechanism so the two-gate model isn't dependent solely on operator memory.
- **Declined post-edit `/qc-pass`** on the policy edits — operator chose direct wrap. Mechanical-mode rubric doesn't apply (policy edit, not substitution); operator judged trimmed CLAUDE.md and Step 13b are well-bounded enough to commit without external QC.

### Next Steps

- **Push** ai-resources commit (forthcoming) and workspace-root `CLAUDE.md` commit (forthcoming) — two repos, two pushes, requires operator approval per Autonomy Rules.
- Watch the next 3–5 sessions under the new policy: confirm plan-time gate is firing post-approval (not per-change), and `/wrap-session` Step 13b actually surfaces the end-time gate in real wraps.
- Re-evaluate at next `/token-audit` whether the always-loaded surcharge nets positive given session mix.

### Open Questions

- The concurrent session's commit `26d9c7f` swept this session's `wrap-session.md` edit (Step 13b) into its commit. The edit landed correctly but commit narrative is incomplete. Decide later whether to leave-as-is or note in a follow-up commit.

## 2026-04-25 — Commission Batch 2: /friday-act + tier-differentiated /friday-checkup output


### Summary

Executed Commission Batch 2 per the approved plan at `/Users/patrik.lindeberg/.claude/plans/here-s-an-idea-i-memoized-bumblebee.md`. Built `/friday-act` (Session 2 of the Friday cadence) and added tier-differentiated output sections to `/friday-checkup` as the data contract `/friday-act` consumes. First real dogfood of `/risk-check` against a structural change set under the new two-gate model — verdict PROCEED-WITH-CAUTION with three Mediums, mitigations applied. Session committed as `6e80a7d`.

### Files Created

- `.claude/commands/friday-act.md` — Session 2 command (locate freshest report → 10-day staleness guard → tier-aware parse → tactical-fix loop with inline /risk-check gate → policy review monthly+ → quarterly retrospective → operator observations + 7-axis posture targets)
- `logs/maintenance-observations.md` — append-only ledger seeded with header schema; written by /friday-act Steps 5–6
- `audits/risk-checks/2026-04-25-commission-batch-2-friday-act-and-tier-differentiated-output.md` — end-time /risk-check report

### Files Modified

- `.claude/commands/friday-checkup.md` — Step 6/7 extended with three tier-differentiated output sections (Tactical follow-ups all tiers, Policy-level observations monthly+, Architectural retrospective quarterly only); renamed `## Operator follow-ups` → `## Tactical follow-ups`; added section-presence-by-tier data contract paragraph for /friday-act parsing
- `logs/decisions-archive-2026-04.md` — auto-archive output (17 entries archived, 3 kept) from check-archive.sh during this wrap

### Decisions Made

- **Plan-time /risk-check skipped.** Original commission plan was QC'd + triaged in 2026-04-24 session; end-time gate alone covers the executed change set. Documented in commit body.
- **Three /risk-check Medium-risk dimensions accepted with paired mitigations.** Blast radius (no-op acceptable per report), Reversibility (attestation only), Hidden coupling (one-line cross-reference comment added at /friday-act Step 2 → friday-checkup.md Step 7 schema-contract paragraph).
- **Tactical-fix queue scoped to standard items only at MVP.** /friday-act consumes only the standard tactical items (resolve-improvements, cleanup-worktree, quarterly follow-ups) plus risk-graded extras; richer ingestion of `## Prioritized findings` deferred to Batch 3+ refinement if usage shows the queue is too narrow.
- **No /wrap-session edit.** Plan called for `/wrap-session` to be untouched; maintenance-observations.md appends are caught by the existing Step 13a dirt check rather than added to the always-staged list.
- **Coaching-log untouched.** 7 autonomy axes live in /friday-act output (forward-looking weekly posture); coaching-log keeps its 5 backward-looking session-pattern dimensions. Honored prior 2026-04-24 design decision.

### Next Steps

- **Push** ai-resources commits (`16d05a4`, `6e80a7d`) and workspace-root `bcf45a9` (from prior session) — two repos, requires operator approval.
- **Batch 3** (durability supplements: hook stale-state detection + /friday-checkup Step 0 recovery + /friday-act freshness-check refactor). Half-session sized; Sonnet-suitable per earlier model recommendation.
- After first real `/friday-act` invocation, watch whether the tactical-fix queue feels too narrow — if so, fold sub-report findings into Tactical follow-ups in a follow-up edit (deferred from this batch).
- Pacing constraint from plan: ≤2 batches per session. Batches 3+4 pair well in a single Sonnet session.

### Open Questions

- None.

## 2026-04-25 — Commission Batch 3+4: Friday cadence durability + maintenance ledger aging

### Summary

Executed commission Batches 3 and 4 from the `bumblebee` plan. Batch 3 added non-Friday stale-state detection to the `friday-checkup-reminder.sh` hook and inserted Step 0 (Skipped-Friday Recovery) into `/friday-checkup`. Batch 4 added a Schema section to `improvement-log.md` and inserted step 3b (stale-pending surfacing with per-item disposition) into `/resolve-improvements`. One plan item dissolved: Batch 3's planned `friday-act.md` edit was already correctly implemented by Batch 2 (audits-directory listing + 10-day threshold). Risk-check end-time gate returned GO on all five dimensions.

### Files Created

- `audits/risk-checks/2026-04-25-batch-3-batch-4-changes-commission-plan-execution.md` — risk-check end-time gate report (verdict GO)

### Files Modified

- `logs/session-notes-archive-2026-04.md` — 3 entries auto-archived by check-archive.sh at wrap

- `.claude/hooks/friday-checkup-reminder.sh` — added non-Friday branch: emit systemMessage warning if last `audits/friday-checkup-*.md` is > 10 days old (commit 7f3f5ce)
- `.claude/commands/friday-checkup.md` — inserted Step 0 (Skipped-Friday Recovery) before Step 1: derives last-run date from audits listing; if > 10 days, offers recover-now (a) or defer (b) (commit 7f3f5ce)
- `logs/improvement-log.md` — inserted Schema section after the title documenting all field conventions (Status / Verified / Age / Review-cycle / Category / Proposal / Target files) (commit 89447ea)
- `.claude/commands/resolve-improvements.md` — inserted step 3b: identify Pending entries with header date > 42 days, surface with r/e/c/k disposition; step 8 summary extended with stale-pending count (commit 89447ea)

### Decisions Made

- **Batch 3 `friday-act.md` edit dissolved.** Plan called for replacing Step 1's freshness-check logic to derive from audits-directory listing. Batch 2 already implemented this pattern correctly (`ls -1 audits/friday-checkup-*.md | sort | tail -1` + 10-day check). No retroactive fix needed; 10-day threshold is now consistent across all three touchpoints (hook / `/friday-checkup` Step 0 / `/friday-act` Step 1).
- **Three commits for two batches.** Batch 3 and Batch 4 committed separately per plan discipline (one commit per batch); risk-check report committed as a standalone audit commit rather than appended to either batch commit.
- **End-time `/risk-check` gate covered both batches in a single invocation.** Hook edit (Batch 3) triggered the gate; command edits (Batch 4) bundled in per the two-gate model. Verdict GO — all dimensions Low.

### Next Steps

- **Push** — three new commits (`7f3f5ce`, `89447ea`, `6073b63`) plus earlier unpushed commits from prior sessions (workspace-root `bcf45a9`; ai-resources commits from 2026-04-24/25 sessions). Two repos, two pushes, requires operator approval.
- **Batch 5** — Stage 1 repo architecture: `docs/repo-architecture.md` + `/route-change` command. Half-to-full session. Read the bumblebee plan (assumption 7 and assumption 2 confirmation prompts at batch open).
- **Permission prompts on `.claude/**` paths** — surfaced this session. Consider running `/fewer-permission-prompts` to add an allowlist covering `Edit(.claude/commands/*.md)`, `Edit(.claude/hooks/*.sh)`, etc.

### Open Questions

- None.

## 2026-04-25 — Zero-permission-prompt policy: bypassPermissions + autoMode.allow hardening

### Summary

Operator surfaced friction with `.claude/**` permission prompts (auto-mode classifier prompting on `.claude/commands/*.md` edits). Diagnosed root cause (auto mode was active and exited mid-session, dropping into default-prompt). Operator stated explicit, repeated directive: zero permission prompts in any future session, regardless of risk. Reconfigured user-level settings.json for maximally permissive operation: `defaultMode: "bypassPermissions"`, empty deny list, plus `autoMode.allow` natural-language rules as defense-in-depth in case `/auto` ever activates. Nothing in this repo was modified — all work is in `~/.claude/`.

### Files Created

- `~/.claude/projects/-Users-patrik-lindeberg-Claude-Code-Axcion-AI-Repo-ai-resources/memory/feedback_zero_permission_prompts.md` — feedback memory codifying the zero-prompt policy, with explicit "do not suggest /auto, /plan, or deny-list additions" guidance.
- `~/.claude/plans/proceed-imperative-hanrahan.md` — minimal plan file for the autoMode.allow hardening (created under harness-forced plan mode, per CLAUDE.md Plan Mode Discipline minimal-plan rule).

### Files Modified

- `~/.claude/settings.json` — `defaultMode: "bypassPermissions"`, `deny: []`, added top-level `autoMode.allow` block with $defaults + 3 natural-language rules. (User-level, not in repo.)
- `~/.claude/projects/.../memory/MEMORY.md` — replaced old `feedback_permission_prompts.md` index entry with new `feedback_zero_permission_prompts.md` entry.
- `~/.claude/projects/.../memory/feedback_permission_prompts.md` — DELETED (superseded by zero-prompts memory; old guidance to "suggest /fewer-permission-prompts at wrap" conflicted with new policy).

### Decisions Made

- **Zero permission prompts as account-level policy.** Operator explicitly accepted the tradeoffs (no harness brake on rm -rf, sudo, force-push, etc.; CLAUDE.md model-side Autonomy Rules + git as compensating controls). Policy applies to ALL Claude Code projects on this machine, not just ai-resources.
- **`bypassPermissions` over `auto`.** First attempt set `defaultMode: "auto"` — operator pushed back; auto mode's classifier IS what was prompting. Bypass mode is the maximally permissive setting. Reverted.
- **Defense-in-depth via `autoMode.allow`.** Added customization so even if `/auto` activates by accident, the classifier won't prompt on `.claude/**` or bash commands. Belt-and-suspenders for the operator's explicit zero-prompt requirement.
- **Behavioral rule for future sessions:** do not suggest `/auto` or `/plan` modes — both can re-introduce classifier-driven prompts. Bypass mode is the floor.

### Next Steps

- **Verify the change at next session start.** New session should boot in bypass mode with no prompts. If a `.claude/**` edit prompts in any new session, the autoMode.allow rule wording needs adjustment.
- **Concurrent session disposition** — see Open Questions below.

### Open Questions

- **Concurrent Claude Code session likely active.** Three commits (`7f3f5ce`, `89447ea`, `6073b63`) landed during this session, and 4 dirty paths exist that weren't from this session: `.claude/commands/friday-act.md`, `.claude/commands/wrap-session.md`, `logs/session-notes-archive-2026-04.md`, `logs/session-notes.md`. Session-notes.md already contained a complete session entry written by the concurrent session before this entry was appended. Wrap deferred staging until operator dispositions per dirt-check (Step 12a).

## 2026-04-25 — Per-project model routing: canonical doc + classifier hook + frontmatter coverage

### Summary

Implemented a complete per-project model routing architecture across 6 git repos. Replaced the workspace-wide model default with a per-project rule (each project's CLAUDE.md declares its own default in a Model Selection section). Created `ai-resources/docs/model-routing.md` as the single canonical source; rewrote `model-classifier.sh` to be project-aware; added explicit `model:` frontmatter to all ai-resources slash commands; added a Model Escalation rule paralleling the QC Auto-Loop; added a model brief to `/prime`; and added Model Selection scaffolding to `/new-project`. All Sonnet identifiers use the `[1m]` suffix to force 1M context (bare `claude-sonnet-4-6` resolves to 200k — operator correction codified to memory).

### Files Created

- `ai-resources/docs/model-routing.md` — canonical routing doc (three-tier rule, decision question, examples table, cost ratios, project-default architecture, identifier forms)
- `ai-resources/audits/risk-checks/2026-04-25-per-project-model-routing.md` — risk-check report (verdict PROCEED-WITH-CAUTION, 5 dimensions, 6 mitigations)
- `~/.claude/projects/.../memory/feedback_sonnet_1m_suffix.md` — memory: Sonnet identifiers must use `[1m]` suffix

### Files Modified

**Workspace repo:**
- `CLAUDE.md` — Model Tier section rewrite (per-project rule + pointer); added Model Escalation section
- `.claude/hooks/model-classifier.sh` — JSON heredoc payload rewritten (project-aware, Sonnet 1M fallback, binary classifier excluding Haiku at session level); jq-validated
- `.claude/commands/{document-workflow,improve-workflow,new-workflow,run-qc,status,update-md,validate}.md` — prepended `model: sonnet` frontmatter (7 workspace-only commands)
- `projects/corporate-identity/CLAUDE.md` — Model Selection revised: removed "inherits workspace" language; declares Opus 4.7 explicitly

**ai-resources sub-repo:**
- `CLAUDE.md` — Model Preference (Opus 4.6 default) replaced with Model Selection (Sonnet 1M default, `claude-sonnet-4-6[1m]`)
- `docs/permission-template.md` — `"sonnet"` → `"sonnet[1m]"`; reference updated to model-routing.md
- `.claude/commands/deploy-workflow.md` — merge script `"sonnet"` → `"sonnet[1m]"`; canonical default updated; prepended frontmatter
- 22 commands (`audit-repo`, `clarify`, `cleanup-worktree`, `deploy-workflow`, `friction-log`, `friday-act`, `friday-checkup`, `graduate-resource`, `new-project`, `note`, `prime`, `qc-pass`, `recommend`, `refinement-pass`, `request-skill`, `scope`, `session-guide`, `sync-workflow`, `triage`, `update-claude-md`, `usage-analysis`, `wrap-session`) — prepended `model: sonnet` frontmatter
- `.claude/commands/prime.md` — added Step 4b model brief; modified Step 5 status block to include Model line
- `.claude/commands/new-project.md` — added Step 11a Model Selection scaffolding before Stage 3a; pre-flight identifier verification

**Project sub-repos:**
- `projects/global-macro-analysis/CLAUDE.md` — added Model Selection (Sonnet 1M, mixed)
- `projects/nordic-pe-landscape-mapping-4-26/CLAUDE.md` — added Model Selection (Sonnet 1M, mixed)
- `projects/obsidian-pe-kb/CLAUDE.md` — added Model Selection (Sonnet 1M, mixed)
- `projects/project-planning/CLAUDE.md` — added Model Selection (Opus 4.7)
- `projects/project-planning/.claude/agents/{plan-evaluator,spec-evaluator}.md` — `claude-opus-4-6` → `claude-opus-4-7`

**Memory:**
- `memory/MEMORY.md` — added entry for `feedback_sonnet_1m_suffix.md`

### Decisions Made

- **Per-project default architecture chosen over workspace-wide default.** Each project declares its own default; sessions outside any project fall back to Sonnet 1M. Resolves three-way conflict (workspace CLAUDE.md said Sonnet, ai-resources said Opus 4.6, hook said Opus).
- **Haiku stays at agent tier only.** Session-level classifier remains binary (Sonnet vs Opus); Haiku invoked through agent frontmatter for mechanical-measurement subagents.
- **Sonnet `[1m]` suffix mandatory in full-form identifiers.** Bare `claude-sonnet-4-6` silently resolves to 200k context; operator-confirmed correction. Codified to memory as durable rule.
- **Project task profiles set via 4-question batch:** global-macro / nordic-pe / obsidian-pe-kb = Mixed (Sonnet 1M default, Opus opt-in for synthesis); project-planning = Opus 4.7 (plan/spec drafting is judgment-heavy by definition).
- **Plan QC: two independent qc-reviewer passes** (full plan → conditional pass → rework → second QC → pass) before operator approval.
- **/risk-check at plan-time produced PROCEED-WITH-CAUTION verdict.** 6 mitigations applied: jq-validate hook, update permission-template/deploy-workflow pointers, ask operator for 4 missing project defaults, exact insertion line ranges in Changes 6/7, fix project-planning agent identifiers, capture per-project CLAUDE.md appends in session note (this section satisfies mitigation #6).

### Next Steps

- **Create per-project `.claude/settings.local.json` files** (gitignored, per-machine) so the harness applies the declared CLAUDE.md defaults:
  - `projects/project-planning/.claude/settings.local.json` → `{"model": "claude-opus-4-7"}`
  - `projects/global-macro-analysis/.claude/settings.local.json` → `{"model": "claude-sonnet-4-6[1m]"}`
  - `projects/nordic-pe-landscape-mapping-4-26/.claude/settings.local.json` → `{"model": "claude-sonnet-4-6[1m]"}`
  - `projects/obsidian-pe-kb/.claude/settings.local.json` → `{"model": "claude-sonnet-4-6[1m]"}`
  - Optional: workspace `.claude/settings.json` add `"model": "sonnet[1m]"` for fallback consistency
- **Smoke tests** (interactive): open fresh sessions in workspace root, ai-resources, buy-side-service-plan; run `/prime` in each; verify Model line in status block and hook behavior on first free-form prompt.

### Open Questions

None.

## 2026-04-25 — Applied per-project model routing (settings.local.json + workspace fallback)

### Summary

Followed up the prior session's per-project model routing implementation by applying it on disk. Created four per-project `settings.local.json` files (gitignored, per-machine) declaring each project's default model — `claude-opus-4-7` for project-planning; `claude-sonnet-4-6[1m]` for global-macro-analysis, nordic-pe-landscape-mapping-4-26, obsidian-pe-kb. Added `"model": "sonnet[1m]"` to workspace-root `.claude/settings.json` so the workspace fallback is declared rather than implicit. Tracked workspace-root file change is in the parent `Axcion AI Repo` git tree (separate from the ai-resources repo this session is running in), which is currently very dirty — flagged for operator disposition rather than auto-committing across an unrelated dirt zone.

### Files Created

- `projects/project-planning/.claude/settings.local.json` — Opus default (`claude-opus-4-7`); gitignored
- `projects/global-macro-analysis/.claude/settings.local.json` — Sonnet 1M default (`claude-sonnet-4-6[1m]`); gitignored
- `projects/nordic-pe-landscape-mapping-4-26/.claude/settings.local.json` — Sonnet 1M default; gitignored
- `projects/obsidian-pe-kb/.claude/settings.local.json` — Sonnet 1M default; gitignored

### Files Modified

- `Axcion AI Repo/.claude/settings.json` (parent workspace, NOT ai-resources) — added `"model": "sonnet[1m]"` at top of root object; declares the workspace fallback explicitly
- `logs/session-notes-archive-2026-04.md` — auto-archive triggered during /wrap-session (4 entries archived from session-notes.md, 10 kept)
- `logs/improvement-log.md` — appended new entry: `2026-04-25 — Make /wrap-session leaner` (5-point proposal, derived from this wrap's mid-flight friction)

### Decisions Made

- **Workspace-root commit deferred to operator.** The tracked `.claude/settings.json` edit lives in the parent `Axcion AI Repo` git tree, not the ai-resources subrepo. The parent tree is currently very dirty (many untracked dirs including `ai-resources/`, `projects/`, `workflows/`). Did not auto-commit per the single-repo dirt-check rule (`feedback_dirt_check_scope.md`); presented the commit as an operator-directed step instead.
- **Verified gitignore coverage before writing.** Confirmed all four `settings.local.json` paths match either the global gitignore (`/Users/patrik.lindeberg/.config/git/ignore` line 1: `**/.claude/settings.local.json`) or the project's own `.gitignore` (nordic-pe-landscape-mapping-4-26). No accidental tracking risk.

### Next Steps

- Operator to decide whether to commit the parent-workspace `.claude/settings.json` change in isolation (`git add` with explicit path enumeration) or batch it with a parent-workspace cleanup later.
- Smoke test the routing: open a fresh session in `projects/project-planning/` (expect Opus 4.7), and one in any of the three Sonnet 1M projects (expect Sonnet 1M); confirm the harness picks up the per-project default before any prompt.
- No follow-up work needed on the ai-resources side — the canonical routing doc, classifier hook, and frontmatter coverage already shipped on 6d879f8 / fd3523e.

### Open Questions

- WIP: `ai-resources/docs/repo-architecture.md` (deferred 2026-04-25; not produced this session). Already documented as Batch 5 deferral in the 2026-04-25 Commission Batch 5 (partial) entry above — must land with `/route-change` in next session's Batch 5 commit. No action needed from this session.

## 2026-04-27 — Created /innovation-sweep + innovation-triage-auditor

### Summary

Built and shipped `/innovation-sweep` — a project-end audit command that scans a completed project across nine artifact categories (commands, agents, hooks, skills, prompts, scripts, style references, CLAUDE.md sections, settings patterns) plus a "divergent forks" meta-category, name-matches each item against `ai-resources/`, and spawns an Opus classifier subagent that assigns one of six verdicts (Already-graduated, Graduate, Backport, Accept-fork, Keep-local, Loose-end). Read-only against the project's `logs/innovation-registry.md`; output is a one-shot dated triage report under `audits/innovation-sweep-{project}-YYYY-MM-DD.md`. Operator runs `/graduate-resource` per applicable item; report produces manual-placement instructions for the categories `/graduate-resource` cannot handle. Plan went through full QC → Triage Auto-Loop (two post-edit passes); end-time `/risk-check` verdict: **GO**.

### Files Created

- `ai-resources/.claude/commands/innovation-sweep.md` (272 lines) — orchestrator command, `model: opus`.
- `ai-resources/.claude/agents/innovation-triage-auditor.md` (196 lines) — Opus classifier subagent, `tools: Read, Bash, Glob, Grep, Write`.
- `ai-resources/inbox/innovation-sweep-plan.md` — durable archive of the approved plan (source: `~/.claude/plans/1-all-of-these-valiant-blum.md`).

### Files Modified

- `ai-resources/logs/innovation-registry.md` — auto-appended by `detect-innovation.sh` for the two new files; manually triaged in the wrap (4 entries from today → `triaged:graduate`).
- `ai-resources/logs/session-notes.md` — this entry.

### Decisions Made

**`/innovation-sweep` design:**
- **Read-only registry contract** — the sweep never writes to the project's `innovation-registry.md`. Avoids the dedup race with `detect-innovation.sh` (registry's only writer) and keeps the registry from being bloated by sweep findings. Operator can manually add registry rows after reviewing the report.
- **Per-category action paths** — categories 1–3 (commands, agents, hooks) invoke `/graduate-resource` because that command only handles those three types; categories 4–9 produce manual-placement instructions ("copy folder to `ai-resources/skills/`", "section-edit into workspace CLAUDE.md", etc.). Verified at design time against `graduate-resource.md` lines 11–16.
- **Filename includes project slug** — `innovation-sweep-{project}-{date}.md` to prevent same-day collisions across projects.
- **Working notes intentionally ephemeral** — written to `audits/working/` which is gitignored; only the dated report file is committed. Mirrors the `/audit-critical-resources` and `/audit-claude-md` pattern.
- **No registry creation on missing-registry projects** — sweep runs anyway, flags missing-registry status in the report, but does not create one. Keeps the sweep non-destructive.
- **Parked to v2:** symlinked-skills detection (Category 4); pre-extracted JSON parsing for `settings.json` (Category 9). Address only if first-run output shows real false-positive rates.

**QC fixes from the auto-loop:**
- Resolved registry-mutation contradiction by committing to read-only.
- Specified project-path resolution as required argument or `AskUserQuestion` picker (dropped erroneous `$CLAUDE_PROJECT_DIR` reference).
- Added explicit `tools:` declaration to subagent frontmatter.
- Reconciled Step 9 commit description with `.gitignore` reality (only the dated report is committed; working notes are gitignored).
- Dropped scope-creep items (cross-reference edit to `docs/ai-resource-creation.md`, future `--backport` flag).

**Innovation triage at wrap:**
- All four `detected` entries from today → `triaged:graduate`. The two new files (innovation-sweep, innovation-triage-auditor) are already canonical (created directly in `ai-resources/`). The two research-workflow entries (`produce-knowledge-file.md`, `run-cluster.md`) are also already canonical — they live in `ai-resources/workflows/research-workflow/` which is the canonical home for workflow-template commands.

### Next Steps

- **Push when ready** — operator action; nothing is auto-pushed.
- **First real run on the buy-side service plan project** — `/innovation-sweep projects/buy-side-service-plan` will exercise the classifier against a real 57-row registry. Compare verdicts against existing triage decisions to calibrate heuristics.
- **Park v2 refinements** — address only if the first run produces low-precision output on Category 4 (skills) or Category 9 (settings).

### Open Questions

None. Working tree has substantial dirt from concurrent research-workflow work + a `/repo-dd` audit run earlier today; left untouched per operator direction ("only commit what we did this session"). Sort that state out in a separate session, likely via `/cleanup-worktree`.

## 2026-04-27 — repo-dd deep audit on workflows/research-workflow

### Summary

Ran `/repo-dd` at deep tier on the canonical research-workflow template (`ai-resources/workflows/research-workflow/`). Subagent factual audit produced 11 findings (F1–F11); operator delegated autonomous resolution via `/recommend`. All 11 fixes applied and committed. Deep operational assessment produced 10 prioritized findings (1 Critical, 3 High, 4 Medium, 2 Low) — documented in the deep report; operator deferred resolution to a future session.

### Files Created

- `audits/repo-due-diligence-2026-04-27-workflow-research-workflow.md` — 46KB factual audit, 11 findings
- `audits/repo-dd-deep-2026-04-27-workflow-research-workflow.md` — deep operational assessment, 10 findings
- `workflows/research-workflow/.claude/commands/review-chapter.md` — chapter review command (renamed from `review.md` per F11)
- `workflows/research-workflow/reference/sops/fact-verification-prompt.md` — placeholder stub for `/verify-chapter` (F8)
- `workflows/research-workflow/reports/.gitkeep` — scaffolds missing `reports/` directory (F6)
- `~/.claude/projects/.../memory/project_research_workflow_critical_items.md` — captures top-2 deep-audit items for next session
- `logs/session-notes-archive-2026-04.md` — auto-archive output (3 entries archived, 10 kept) from check-archive.sh during this wrap

### Files Modified

- `workflows/research-workflow/.claude/settings.json` — F3: model identifier `sonnet[1m]` → `claude-sonnet-4-6[1m]`
- `workflows/research-workflow/.claude/shared-manifest.json` — F5: removed `usage-analysis`; F9: added `produce-architecture`/`produce-formatting`/`produce-prose-draft` as local; F11: `review` → `review-chapter`
- `workflows/research-workflow/.claude/commands/run-cluster.md` — F1: cluster-memo paths corrected to `{section}/{section}-cluster-$ARGUMENTS-memo.md`; F4: `model: sonnet`
- `workflows/research-workflow/.claude/commands/produce-knowledge-file.md` — F2: architecture path corrected to `report/architecture/{section}/{section}-architecture.md`; F4: `model: opus`
- All other 25 command files in the template — F4: explicit `model:` frontmatter (`opus` for analytical/audit/produce-/review-/verify-; `sonnet` for `run-`/intake/prime/wrap/note orchestrators)
- `workflows/research-workflow/CLAUDE.md` — F7: added `## Confidentiality Boundaries` stub; F10: replaced full `Context Isolation Rules`, `Citation Conversion Rule`, `Bright-Line Rule` sections with single-line pointers to `reference/stage-instructions.md`
- `workflows/research-workflow/SETUP.md` — F7: split `## 8. Optional: Customize SOPs` into `8. Required: Configure Confidentiality Boundaries`, `8b. Required: Populate Fact-Verification Prompt`, `8c. Optional: Customize SOPs`
- `workflows/research-workflow/reference/stage-instructions.md` — F10: appended `## Context Isolation Rules`, `## Citation Conversion Rule`, `## Bright-Line Rule`

### Files Deleted

- `workflows/research-workflow/.claude/commands/review.md` — renamed to `review-chapter.md` (F11)

### Decisions Made

- **Audit scope and depth:** ai-resources/workflows/research-workflow at "deep" tier (operator selection — deep tier produces operational judgment in addition to factual findings).
- **Autonomous resolution of all 11 OPERATOR findings via `/recommend`** — operator delegated per-item judgment to Claude.
  - F4 model-tier classification by command class — orchestrators/log-append (`run-*`, `intake-*`, `prime`, `wrap-session`, `note`, `friction-log`, etc.) → `sonnet`; analytical/audit/produce-/review-/verify- → `opus`. Source rule: workspace `CLAUDE.md` § Model Tier.
  - F7 Confidentiality Boundaries treated as required (not optional) — stubbed in CLAUDE.md and gated in SETUP.md, since "no confidentiality constraints" is itself a load-bearing project-level choice.
  - F10 methodology placement — full bright-line / citation / context-isolation methodology moved to `stage-instructions.md` (read on stage entry); CLAUDE.md retains pointers only. Source rule: workspace `CLAUDE.md` § CLAUDE.md Scoping.
- **Deep-audit recommendations: documented but not fixed** — operator deferred 10 findings to a future session. Top-2 (Critical: hard-coded `additionalDirectories`; High: missing `research-question-batcher` skill) captured in memory for resumption.

### Next Steps

- Address the 10 deep-audit findings in a fresh session, starting with Critical and High items. Memory pointer: `project_research_workflow_critical_items.md`.
- Resolve dirty working-tree state outside this session: `.claude/hooks/detect-innovation.sh` (operator-applied template-maintenance fix today) + `.claude/settings.json` (permission-list dedup from 2026-04-25). Either commit standalone or roll into next `/cleanup-worktree`.
- Confirm whether F4 model-frontmatter additions need to propagate to deployed copies of research-workflow (no deployed copies exist in `projects/` today — likely no propagation needed).
- Run `/risk-check` at the start of next session before applying the Critical/High deep-audit fixes — they touch `additionalDirectories` (deployment-affecting) and SETUP.md (operator-onboarding).

### Open Questions

None.
