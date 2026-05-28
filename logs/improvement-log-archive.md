# Improvement Log — Archive

### 2026-04-18 — Promote `[HEAVY]` self-enforcement flag to PreToolUse hook with exempt-command bypass
- **Status:** applied 2026-04-18 (Tier 3 hardening session)
- **Category:** Audit-recurrence prevention (automation)
- **Friction source:** 2026-04-18 token audits — Tier 3 gap. The `[HEAVY]` flag in workspace CLAUDE.md → Session Guardrails was a self-enforcement rule with no hook backing. Audit reviewer noted: "if `[HEAVY]` proves unreliable as a self-enforcement rule, promote it to a `PreToolUse` hook in a dedicated session." This entry closes that gap.
- **Implementation:**
  - `ai-resources/.claude/hooks/check-heavy-tool.sh` — Python-backed bash hook reading PreToolUse JSON envelope. Fires on Read/Grep/Bash. Heuristics: Read on text file >500 lines without `limit`; Grep without `glob`/`type`/sufficient `head_limit`; Bash patterns matching recursive ls, unscoped find, unbounded git log. Output via `hookSpecificOutput.additionalContext` — non-blocking.
  - Exemption mechanism: parses `transcript_path` JSONL, extracts most recent real user prompt (not tool_result), matches against the 14 exempt commands per workspace CLAUDE.md Session Guardrails. If exempt, exits 0 without warning.
  - Registered in `ai-resources/.claude/settings.json` under `hooks.PreToolUse` with matcher `"Read|Grep|Bash"`.
- **Verified:** smoke-tested 7 cases (heavy Grep, targeted Grep, recursive ls, safe ls, large Read no-limit, large Read with-limit, exemption via synthetic transcript) — all match expected behavior.

### 2026-04-18 — Extend Stop hook with usage-log telemetry-freshness check
- **Status:** applied 2026-04-18 (Tier 3 hardening session)
- **Category:** Audit-recurrence prevention (automation)
- **Friction source:** 2026-04-18 token audit R14 (telemetry baseline). The `/usage-analysis` discipline relied on me prompting at `/wrap-session` and the operator not dismissing reflexively. Without it, future audits cannot measure whether R1–R13 fixes moved the needle.
- **Implementation:**
  - Existing inline Stop hook command (innovation-registry check) replaced with a script invocation: `ai-resources/.claude/hooks/check-stop-reminders.sh`.
  - Script combines two checks: (1) innovation-registry detected-entry count (preserved verbatim from prior inline command), (2) `usage/usage-log.md` having a `### YYYY-MM-DD` entry for today. Both reminders concatenated into one `systemMessage`. Always exits 0.
  - QC review preferred this over the original UserPromptSubmit-on-`/wrap-session` design — Stop hook fires at the natural reminder point and avoids adding a second hook event.
- **Verified:** smoke-tested with current state — innovation count emits, today's usage entry already present so telemetry portion correctly suppressed.

### 2026-04-18 — Canonical project CLAUDE.md template (compaction + session-boundary defaults, no workspace-rule duplication)
- **Status:** applied 2026-04-18 (Prevention Session 2)
- **Verified:** 2026-04-18 — confirmed by operator
- **Category:** Audit-recurrence prevention
- **Friction source:** 2026-04-18 token-audit R10 (ai-resources) + R8 (buy-side). Every new project CLAUDE.md ships without `## Compaction` and `## Session Boundaries` sections, and every new project that was created via `/new-project` under the 2026-04-13 decision includes duplicated workspace rules (File Verification, Commit Rules) that pay per-turn token cost.
- **Proposal:**
  - Update the CLAUDE.md template used by `/new-project` to include default `## Compaction` and `## Session Boundaries` sections (borrow wording from ai-resources/CLAUDE.md).
  - Reconcile with the 2026-04-13 decision (copy Commit Rules into every project CLAUDE.md). Option A: keep the short-form mirror but audit that the project-level copy doesn't drift. Option B: replace with a one-line pointer — "Commit and file-verification rules: see workspace CLAUDE.md." Requires verifying that Claude Code consistently loads the workspace CLAUDE.md via `additionalDirectories` before the operator experiences commit-asking friction again. The 2026-04-13 decision's rationale ("inheritance evidently does not surface the rule prominently enough") may still hold — if so, keep the short-form copy but add a drift-check to `/repo-dd` questionnaire.
  - Update the research-workflow template's CLAUDE.md at `ai-resources/workflows/research-workflow/CLAUDE.md` so deployed projects inherit.
  - Apply the new workspace CLAUDE.md "CLAUDE.md Scoping" rule when reviewing project templates: skill-methodology and workflow-methodology content that lives in project CLAUDE.md should be moved to the right home (SKILL.md or workflow reference docs).
- **Target files:**
  - `ai-resources/.claude/commands/new-project.md` and its pipeline stages
  - `ai-resources/workflows/research-workflow/CLAUDE.md` (template)
  - Any CLAUDE.md template referenced by `/deploy-workflow`

### 2026-04-18 — Canonical project settings.json template (Read(...) deny block + Sonnet default in /new-project)

- **Status:** applied 2026-04-18 (Prevention Session 2)
- **Verified:** 2026-04-18 — confirmed by operator
- **Category:** Audit-recurrence prevention
- **Friction source:** 2026-04-18 token-audit R1 (both audits) and R4 (buy-side). Every new project ships without `Read(...)` denies and without a Sonnet default. The audit catches these findings on every project; preventing them at project-creation time would eliminate the recurrence.
- **Proposal:**
  - Update `/new-project` pipeline's post-enrichment stage to write `.claude/settings.json` with a sensible `permissions.deny` block. Minimum: `Read(archive/**)`. Research-workflow-derived projects should also get `Read(output/**)`, `Read(parts/**/drafts/**)`, `Read(usage/**)`, `Read(**/*.archive.*)`, `Read(**/deprecated/**)`, `Read(**/old/**)`.
  - Update the same stage to write `.claude/settings.local.json` with `{"model": "sonnet"}` as default.
  - Update the research-workflow template's `.claude/settings.json` at `ai-resources/workflows/research-workflow/.claude/settings.json` so `/deploy-workflow` propagates the canonical state.
  - Apply the "Applying Audit Recommendations" rule (workspace CLAUDE.md) when finalizing the deny list — list the top-3 commands each path affects and confirm no regression before committing the template.
- **Target files:**
  - `ai-resources/.claude/commands/new-project.md` (pipeline orchestrator)
  - `ai-resources/workflows/research-workflow/.claude/settings.json` (template)
  - Any pipeline-stage-N agent that writes project `.claude/settings.json`

### 2026-04-18 — Extend Model Tier rule to cover agents; publish a tier table

- **Status:** applied 2026-04-18 (Prevention Session 1)
- **Verified:** 2026-04-18 — confirmed by operator
- **Category:** Audit-recurrence prevention
- **Friction source:** 2026-04-18 token-audit §7.6 + §8 practice 7 + R2 Phase 1 (same-day fix session). Workspace `CLAUDE.md` "Model Tier" section (lines 185–193) governs **commands only**. The current agent fleet ships as 10 Opus / 5 inherit (= Opus) / 3 Sonnet / 0 Haiku — no rule prevents a new agent from defaulting to Opus when the work is mechanical. R2 Phase 1 (splitting `token-audit-auditor` into mechanical/judgment variants) is the kind of retrofit a rule would prevent. R12 (`repo-dd-auditor` Opus→Sonnet) is another.
- **Proposal:**
  - Extend workspace `CLAUDE.md` → Model Tier to include an Agents subsection mirroring the Commands one: *"New agent definitions must declare `model:` explicitly. Tier by work type: Haiku for mechanical measurement / file census / format checks; Sonnet for structured factual work (questionnaire-driven audits, fact extraction); Opus for judgment (QC, refinement, synthesis, triage, critique, workflow-stage-3b architecture)."*
  - Publish a concrete **Agent Tier Table** in the same section listing the current fleet with correct tier (18 agents per audit §5.1 / post-fix inventory: 10 Opus, 4 Sonnet — adding `repo-dd-auditor` after R12, 1 Haiku — adding `token-audit-auditor-mechanical` after R2 Phase 1, 3 inherit-from-default). Mark migration candidates.
  - Add a one-line maintenance note: *"When adding a new agent, place it in the table. When changing an agent's tier, update the table in the same commit."*
  - Add a one-line pointer to `ai-resources/CLAUDE.md`: "Agent model tiering: see workspace CLAUDE.md → Model Tier." No duplication.
- **Target files:**
  - `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md` (Model Tier section — extend)
  - `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/CLAUDE.md` (one-line pointer)

### 2026-04-18 — Codify subagent-summary cap + /usage-analysis discipline in ai-resources CLAUDE.md

- **Status:** applied 2026-04-18 (Prevention Session 1)
- **Verified:** 2026-04-18 — confirmed by operator
- **Category:** Audit-recurrence prevention
- **Friction source:** 2026-04-18 token-audit §9.3 safeguards #3 (subagent return-size cap) and #7 (mandatory `/usage-analysis` at wrap) + R14. Neither is written down as a rule. §7.3 confirms the two-file output-to-disk pattern is in place, but no convention enforces the **summary length cap** (30 lines for Sections 2/5/6, 20 for Section 4 in `token-audit-auditor` — lives in one agent's body, not as a shared convention). R14 (telemetry baseline) depends on a discipline the operator must sustain; without it, future audits can't measure the impact of R1–R13.
- **Proposal:**
  - Add a short **Subagent Contracts** section to `ai-resources/CLAUDE.md`: summary files cap at 30 lines (20 when per-unit invocations proliferate, e.g., per-workflow or per-chapter); full notes path returned; main session reads summary only. Reference the existing implementations: `token-audit-auditor`, `token-audit-auditor-mechanical` (post-R2 Phase 1), `repo-dd-auditor`, `session-usage-analyzer`.
  - Add a **Session Telemetry** subsection stating that `/usage-analysis` should run at the end of every substantive session. Wire the prompt into `/wrap-session` (queued as R14 implementation) — operator can dismiss with one-letter confirmation if the session was trivial.
  - Do NOT extend this rule to project-level CLAUDE.md files — it's ai-resources-scope discipline, not per-project.
- **Target files:**
  - `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/CLAUDE.md` (two new sections)
  - `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md` (add `/usage-analysis` prompt at end)

### 2026-04-18 — Add three questionnaire items to /repo-dd

- **Status:** applied 2026-04-18 (Prevention Session 3)
- **Verified:** 2026-04-18 — confirmed by operator
- **Category:** Audit-recurrence prevention (detection)
- **Friction source:** 2026-04-18 token-audit §9.3 safeguards #2 (agent-tier drift) and #6 (CLAUDE.md task-type-instruction bloat). The audit itself had to do this work ad hoc; `/repo-dd` should catch drift on every cycle so a future `/token-audit` is rarely the first to see it. Adding a new-project-parity check closes the loop on the pending canonical-template entries above — projects created before the template lands need detection until they're retrofitted.
- **Proposal:** Add three items to `ai-resources/audits/questionnaire.md`:
  1. **Agent model tier drift:** for each `.claude/agents/*.md` under the audit scope, does the `model:` field match the Agent Tier Table in workspace CLAUDE.md? List mismatches.
  2. **CLAUDE.md task-type bloat:** does any CLAUDE.md file contain task-type-specific instructions (skill-methodology, workflow-methodology, creation sequences) that should be migrated to SKILL.md or workflow reference docs per workspace CLAUDE.md → "CLAUDE.md Scoping" rule? List candidates.
  3. **New-project settings parity:** for each project under `projects/`, does `.claude/settings.json` contain the canonical `Read(...)` deny list (minimum: `Read(archive/**)`)? Does `.claude/settings.local.json` declare `model: sonnet`? List projects missing either.
- **Dependency:** The canonical-template entries above (settings + CLAUDE.md) must land first for item 3 to have a stable reference. Entry A (Agent Tier Table) must land first for item 1 to have a reference.
- **Target files:**
  - `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/questionnaire.md`
  - Downstream if needed: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/repo-dd-auditor.md` and `.claude/commands/repo-dd.md` for question-layout surfacing.

### 2026-04-18 — Pre-commit skill-size warning hook (informational, non-blocking)

- **Status:** applied 2026-04-18 (Prevention Session 3)
- **Verified:** 2026-04-18 — confirmed by operator
- **Category:** Audit-recurrence prevention (automation)
- **Friction source:** 2026-04-18 token-audit §2.1 + §9.3 safeguard #4. Eight skills exceed 300 lines; two exceed 480. Nothing warns at commit time that a SKILL.md is growing past the recommended threshold — bloat is only caught at the next audit, by which point compressing is a bigger session.
- **Proposal:**
  - Add a pre-commit hook under `ai-resources/.claude/hooks/` (e.g., `check-skill-size.sh`) that measures any staged `SKILL.md` file and emits an **informational** warning when line count > 300. Non-blocking — warning text only, exit 0.
  - Register it in `ai-resources/.claude/settings.json` alongside the existing hook block. Verify no path conflict with the existing `check-skill-validation.sh`-style hook.
  - Keep it lightweight: single bash script, `wc -l` on each staged SKILL.md, stderr warning, no external deps.
- **Risk:** Low. Informational output only; operator can ignore.
- **Target files:**
  - `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/check-skill-size.sh` (new)
  - `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/settings.json` (hook registration)

### 2026-04-18 — /wrap-session directory-wildcard git add sweeps up concurrent-session files

- **Status:** applied 2026-04-18 (structural fix only in `wrap-session.md` step 12–13 — durable workspace CLAUDE.md concurrent-session rule remains pending)
- **Verified:** 2026-04-18 — confirmed by operator
- **Category:** Concurrency safety / command discipline
- **Friction source:** Prevention Session 1 (2026-04-18 night) wrap. `/wrap-session` step 13 specifies `git add logs/ skills/ prompts/ .claude/` — directory-level wildcards. A parallel `/improve-skill repo-dd-auditor` session was running in the same repo with uncommitted work under `.claude/agents/` and `.claude/commands/`. The wrap commit swept up 4 parallel-session files (`dd-extract-agent.md`, `dd-log-sweep-agent.md`, `.claude/commands/repo-dd.md`, `logs/innovation-registry.md`) under a commit message that described only the Prevention Session 1 work. Unwound via `git reset --soft HEAD~1` + selective `git restore --staged` + re-commit. Fix was clean (unpushed), but attribution slippage and toe-stepping both real. Operator had explicitly said at session start "don't step your toes here."
- **Root cause:** `/wrap-session` was written assuming one session is the sole writer of the directories it stages. Assumption holds for Axcíon's typical single-session workflow; breaks the moment two sessions run concurrently. Directory wildcards are "narrower than `git add -A`" but still not narrow enough to respect concurrency.
- **Proposal:**
  - **Structural fix:** update `/wrap-session` step 13 to stage explicit file paths derived from the Files Created / Files Modified sections the command just wrote into the session note. The command already enumerates its own artifacts — use that enumeration at commit time instead of directory wildcards. Default file set: `logs/session-notes.md logs/decisions.md logs/coaching-data.md` + any additional files listed in the Files Created/Modified sections.
  - **Durable rule:** add a short section to workspace `CLAUDE.md` (under Git Rules or Commit-boundary sequencing) stating: when the operator has disclosed a concurrent session on the same repo, `git add` must enumerate explicit file paths — directory wildcards (`git add logs/`, `git add .claude/`) are prohibited until the concurrent session wraps. Makes "don't step on toes" a checkable rule.
  - **Optional safeguard:** before staging in `/wrap-session`, run `git status --short` and cross-reference the modified-file list against the session's Files Modified section. If the status list contains files not in Files Modified, flag and ask the operator before staging. (Tension: workspace CLAUDE.md says "do not run `git status` as a pre-commit check." Carve an exception for the concurrency-detection case, or accept that the enumerate-explicit-paths fix alone is sufficient.)
- **Target files:**
  - `ai-resources/.claude/commands/wrap-session.md` — change step 13 staging command
  - `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md` — new Git Rules subsection on concurrent-session staging discipline
- **Dependency:** None. Can be implemented standalone; fits the Prevention Session sequence as a small bundle with the existing Session 2 (templates) or Session 3 (detection).
- **Risk:** Low. Structural fix is a 2-line change. Durable rule adds ~5 lines to workspace CLAUDE.md. Neither touches active-workflow code.

### 2026-04-18 — Prime Step 2 innovation-registry grep pattern
- **Status:** applied
- **Verified:** 2026-04-22 — confirmed via setup-scan-2026-04-21 report ("Considered and rejected" section) which verified the fix against current `.claude/commands/prime.md` lines 8–9 (pipe-delimited grep pattern present)
- **Category:** command
- **Friction source:** friction-log.md session 2026-04-18 entry 1 — registry with 5 `detected` rows reported 0 at Prime
- **What changed:** `.claude/commands/prime.md` Step 2 rewritten to specify the pipe-delimited table format and correct grep pattern (`^\|[^|]*\|[^|]*\|[^|]*\| detected \|`); explicit note not to use list/YAML/JSON patterns.

### 2026-04-18 — Prime git-status freshness check
- **Status:** applied
- **Verified:** 2026-04-22 — confirmed via setup-scan-2026-04-21 report which verified the fix against current `.claude/commands/prime.md` line 20 (git-status freshness check) and line 36 (new working-tree output block)
- **Category:** command
- **Friction source:** friction-log.md session 2026-04-18 entry 2 — Prime reported phantom loose ends from stale env snapshot (files already committed)
- **What changed:** `.claude/commands/prime.md` gains Step 4a (live `git status --short` + `git diff --stat HEAD` verification when env snapshot is non-empty) and a new `**Working tree:**` line in the Step 5 output block.

### 2026-04-22 — Hook inventory + validation (SC-02 reframe)

- **Status:** logged (pending)
- **Category:** command/skill
- **Source:** `ai-resources/reports/setup-improvement-scan-2026-04-21.md:50–58` (SC-02). Original scan framing was "6 hooks deployed 2026-03-28 remain unvalidated"; the 2026-04-22 setup-scan fix session could not verify that 6-hook baseline in git history and deferred the item.
- **Reframe:** broader and more actionable — inventory every currently deployed hook across the workspace and verify each fires correctly in a test session. Phase 1 exploration on 2026-04-22 counted 29 hook files:
  - 6 under `ai-resources/.claude/hooks/`
  - 6 under workspace-root `.claude/hooks/`
  - 13 across `projects/*/.claude/hooks/` (buy-side-service-plan, nordic-pe-landscape-mapping-4-26, project-planning)
  - 4 in the research-workflow template at `ai-resources/workflows/research-workflow/.claude/hooks/`
- **Proposed change:** one-off inventory session, or a new `/validate-hooks` command (or `hook-validator` skill) that: (a) enumerates each hook by path and declared trigger (SessionStart / PreToolUse / PostToolUse / Stop / pre-commit); (b) checks whether it is actually wired via the nearest `settings.json`; (c) in a test session, triggers each hook type and confirms it fires. Priority order: high-value hooks first — SessionStart context loader, `auto-sync-shared.sh`, `check-heavy-tool.sh`, pre-commit `skill-size`.
- **Deferred reason:** scope estimated ~1 hour; no active friction driving urgency. Better handled as a dedicated maintenance session than bundled into a scan-fix session.
- **Archived reason:** no active friction (W2.4 — 2026-05-08).
- **Target files (when executed):** potentially new — `ai-resources/.claude/commands/validate-hooks.md` or `ai-resources/skills/hook-validator/SKILL.md`.

### 2026-04-28 — Stop[hook 0] checkpoint-recency: design generic version

- **Status:** logged (pending)
- **Category:** command/skill
- **Source:** 2026-04-27 innovation-sweep audit (`ai-resources/audits/innovation-sweep-buy-side-service-plan-2026-04-27.md` § Findings #14). Buy-side `.claude/settings.json` Stop[hook 0] runs `find -mmin -120` against `*/checkpoints/*checkpoint*` and emits a "no checkpoint written this session" warning if none is found. Pattern is reusable but the path glob is project-pipeline-specific.
- **Disposition (2026-04-28 plan):** defer as graduate-candidate. Pattern is reusable; not urgent.
- **Archived reason:** no active friction (W2.4 — 2026-05-08).
- **Proposal:** factor out a generic Stop hook `check-checkpoint-recency.sh` under `ai-resources/.claude/hooks/` that takes the path glob as an env var (e.g., `CHECKPOINT_GLOB`) so projects with different artifact path conventions can configure it. Buy-side becomes a 1-line settings.json env override.
- **Target files (when executed):**
  - `ai-resources/.claude/hooks/check-checkpoint-recency.sh` (new)
  - `ai-resources/.claude/settings.json` Stop block (registration)
  - `projects/buy-side-service-plan/.claude/settings.json` Stop block (env var override)

### 2026-04-28 — Extract challenge.md pattern as generic /critique-draft

- **Status:** logged (pending)
- **Category:** command/skill
- **Source:** 2026-04-27 innovation-sweep audit (#1 of 16 loose ends). Buy-side `.claude/commands/challenge.md` invokes the project's strategic-critic agent on a draft and routes the verdict (ROBUST / CHALLENGED / EXPOSED) through the QC → Triage auto-loop. Audit said "registry says triaged:project-specific; classifier agrees but strategic-critic wrapper might generalize."
- **Disposition (2026-04-28 plan):** "Extract pattern" — but the actual extract requires designing a generic strategic-critic agent (or accepting an agent name as input) which doesn't exist yet. Logged here for a future dedicated session rather than executed inline.
- **Archived reason:** no active friction (W2.4 — 2026-05-08).
- **Proposal:** design a generic `/critique-draft` command in `ai-resources/.claude/commands/` that takes (a) a draft file path and (b) an agent name. The command runs the agent on the draft, surfaces the verdict, and routes through QC → Triage based on the verdict's severity tier. The buy-side `challenge.md` then becomes a thin wrapper specifying its strategic-critic agent + verdict-mapping.
- **Target files (when executed):**
  - `ai-resources/.claude/commands/critique-draft.md` (new)
  - Possibly a generic `ai-resources/.claude/agents/strategic-critic.md` if the verdict format is to be standardized
  - `projects/buy-side-service-plan/.claude/commands/challenge.md` (refactor as wrapper)

### 2026-04-28 — Bulk backfill of model: and effort: to all 69 skills

- **Status:** applied 2026-04-28
- **Verified:** 2026-04-28 — bulk QC (4 grep checks in the verification block below, all 0 results); commits `a533595`, `a4f32e8`
- **Category:** bulk-backfill-exception (per `docs/ai-resource-creation.md` § Bulk-backfill Exception)
- **Files modified:** 69 — all `skills/*/SKILL.md`
- **Fields added:** `model:` and `effort:` (2-line insert per file, after `description:` in frontmatter; body untouched)
- **Tier mapping source:** `audits/working/skills-tier-inventory-2026-04-28.md` (69 skills: 38 opus/high, 30 sonnet/medium, 1 haiku/low)
- **Bulk QC verification (substitutes for 69 per-file passes):**
  - `grep -rL "^model:"  skills/*/SKILL.md` → 0 results
  - `grep -rL "^effort:" skills/*/SKILL.md` → 0 results
  - `grep -rh "^model:"  skills/*/SKILL.md | grep -vE ":(opus|sonnet|haiku)$"` → 0 lines
  - `grep -rh "^effort:" skills/*/SKILL.md | grep -vE ":(low|medium|high)$"` → 0 lines
- **Commits:** `a533595` (Phase A pipeline foundation), `a4f32e8` (Phase C bulk sweep)
- **Exception justification:** 69 per-file pipeline runs would produce identical fix passes with no QC signal. One-time mechanical frontmatter insert only; no body changes. Documented in `docs/ai-resource-creation.md` before execution.

### 2026-05-16 — /session-start confirmation token is ambiguous and silently accepts corrections as confirmations
- **Status:** applied 2026-05-16
- **Verified:** 2026-05-16 — commit 9a58073 (update: session-start.md — explicit confirmation token + parser rules)
- **Category:** command
- **Friction source:** 2026-05-11 friction entry 1 — operator replied `c. Next /session-plan` meaning "confirm; next session will be /session-plan"; Claude parsed `c.` as a correction to field c ("Done when").
- **Proposal:** Edit `.claude/commands/session-start.md` Step 2: (1) prompt becomes `"Reply 'confirm' (or 'y') to accept, or list field corrections in the form 'b: <new text>'. Bare single letters other than 'y' are treated as ambiguous and re-asked."`; (2) add rejection rule for `^[a-z]\.?(\s|$)` matches that are not exactly `y` — re-ask once with the valid forms listed; (3) parser rule: correction syntax requires `<letter>:` (colon, not period) followed by replacement text on the same line.

### 2026-05-16 — /prime trusts a single state snapshot — third occurrence; promote to recurrence-fix
- **Status:** applied 2026-05-16
- **Verified:** 2026-05-16 — commit 480d5b0 (update: prime.md — cross-check Next Steps against git log)
- **Category:** instruction-fix (RECURRING)
- **Friction source:** 2026-05-11 friction entry 4 — /prime reported Bundles 1, 2, 5 as "deferred" when commits `f44684b`, `851a15d`, `62bf33f` had shipped them. Third instance in the same family (Apr-18 #1 and #2 archived/verified).
- **Proposal:** Edit `.claude/commands/prime.md`: (1) new Step 1a — when extracting Next steps, parse source-entry timestamp; run `git log --since="<entry-timestamp>" --pretty=%s` and flag each bullet that matches a commit subject/body as `(likely DONE — commit <hash>)`; (2) sibling-entry sweep — if `logs/session-notes.md` has additional `## <today's date>` entries after the source, warn `"Multiple same-day session entries exist (parallel wraps possible). Next-Steps inherited from <Bundle X>; review against entries: <list>."`; (3) add top-of-file principle: `"Prime never asserts state from a single source. Each surfaced next-step / status claim must be cross-checked against git log since the claim's source timestamp."`

### 2026-05-16 — /session-plan template produces sparse plans that fail as standalone execution briefs
- **Status:** applied 2026-05-16
- **Verified:** 2026-05-16 — commit 3894195 (update: session-plan.md — Step 7 template: Findings, Execution Sequence, Scope Alternatives)
- **Category:** rule / command
- **Friction source:** 2026-05-11 friction entry 3 — drift-fix session plan ended up as a pointer to the drift report; operator said "why is there so little information in the session plan?"
- **Proposal:** Edit `.claude/commands/session-plan.md` Step 7 template to add three required sections before the QC trigger: `## Findings / Items to Address` (numbered list with source-doc anchor; minimum 1, no upper limit), `## Execution Sequence` (numbered steps with per-item verification), `## Scope Alternatives` (min / recommended / max, or "Single scope — no alternatives"). Add Step 7 precondition: if `INTENT` references a separate report/spec/drift file, the Findings section MUST inline one-line summaries of each item — bare link invalid. End-of-Step-7 self-check: "If the plan is fewer than 25 lines or contains a bare link as its only description of work items, expand before writing."

### 2026-05-16 — /session-plan vs /monday-prep C15 conflate "current session" and "next session" semantics
- **Status:** applied 2026-05-16
- **Verified:** 2026-05-16 — commit e41c890 (update: monday-prep C15 + weekly-cadence — scope separation, no inline /session-plan)
- **Category:** command / process
- **Friction source:** 2026-05-11 friction entry 2 — /monday-prep C15 invokes `/session-plan` inline meaning "plan the *next* work session," but `/session-plan` Step 0 verifies today's `/prime` ran and Step 5 talks about "this session's autonomy posture" — both assume active session.
- **Proposal:** Edit `.claude/commands/monday-prep.md` C15: replace the inline `/session-plan` invocation with a scaffold write. Print: `"Write a next-session planning scaffold to logs/session-plan-next.md? (y/n)"`. On `y`, write a stub file containing only the `## Intent` line populated from the week mandate's first work item, plus a one-line note: `"Run /session-plan in the next session to fill out this scaffold."` Do NOT call `/session-plan` from inside `/monday-prep`. Add a one-paragraph note to `docs/weekly-cadence.md` (create if absent) explicitly stating: week mandate (Monday) is week-scope; per-session plan is session-scope; they are written in separate sessions.

### 2026-05-16 — /consult invoked when targeted Read would have answered
- **Status:** applied 2026-05-16
- **Verified:** 2026-05-16 — commit 2e71e1a (update: consult.md — Step 0 Read-first gate + reservation note)
- **Category:** rule
- **Friction source:** 2026-05-08 friction entry 18:26 — `/consult` burned ~95k tokens and 2.5 min on Opus when a 5-min targeted Read of `/deploy-workflow.md` would have answered the same question.
- **Proposal:** Edit `.claude/commands/consult.md` to add a Step 0 precondition gate: `Before invoking /consult, answer: (a) Have I already given a recommendation on this question? (b) If yes, is there a single file (≤ 300 lines) whose contents would either confirm or refute it? If both = yes: do the Read first. Only invoke /consult if the Read surfaces a genuine ambiguity or a load-bearing conflict that cannot be resolved from the file.` Also add a one-line entry to the `/consult` usage rationale: "Reserve for genuinely contested or load-bearing system-shape questions, not for verification of already-confident recommendations."

### 2026-05-16 — /friday-act spec's "30-line peek" treated as ceiling instead of floor on heavy-disposition days
- **Status:** applied 2026-05-16
- **Verified:** 2026-05-16 — commit 6888a4a (update: read-scope floors — workspace CLAUDE.md § Working Principles + friday-act.md Step 16a)
- **Category:** rule / command
- **Friction source:** 2026-05-08 friction entry 14:05 — Claude read the SO advisory + systems-review spec as "first 30 lines peek" and made claims it could not verify. Operator said "this was supposed to be your job as well" — judgment about reading scope was Claude's.
- **Proposal:** Edit `.claude/commands/friday-act.md` (and `.claude/commands/friday-so.md` if it uses the same pattern) to add explicit "Read-scope is a floor, not a ceiling" note in the initial read step: `The N-line peek below is the minimum read scope. If you intend to make disposition claims about the document's contents (e.g., "the priority filter mirrors all 12 items"), you MUST read the relevant sections in full first. Spec-literal compliance does not substitute for judgment about how much context a downstream claim requires.` Add related entry to workspace `CLAUDE.md` under "Design Judgment Principles" or "Working Principles": `"Read-scope floors. When a command specifies a minimum read scope (e.g., 'first 30 lines'), treat it as a floor. Expand when downstream claims are load-bearing — judgment about adequate context is yours, not the spec's."`

### 2026-05-22 — Friction logging produced an unusable stub entry ("note this")

- **Status:** applied 2026-05-22
- **Verified:** 2026-05-22 — fix shipped in commit `3a7ad4c` (B2: stub detection in `note.md` + `friction-log.md`); confirmed by operator
- **Category:** process
- **Friction source:** friction-log.md session 2026-05-18 10:00 — the only friction event is the literal text `note this.` (logged via `/note friction:` or `/friction-log`)
- **Proposal:** Add a post-capture stub-detection step to `.claude/commands/note.md` Step A (friction routing) and `.claude/commands/friction-log.md` Step 3. After appending the entry, if the logged text is under ~15 characters or matches a placeholder pattern (`^(note this|todo|tbd|fixme|xxx|\.\.\.)\.?$` case-insensitive), append a bracketed reminder on the same line — `[STUB — expand before next /improve]` — and print one chat line: `Logged as a stub. Add detail with another /note friction: ... when you have a moment.` Keeps capture frictionless (still logs immediately, no blocking question) but flags the entry so the operator and the next `/improve` run both see it is incomplete. Effort trivial; impact medium; first occurrence. Batch with the next entry — both touch `note.md`.
- **Target files:** `ai-resources/.claude/commands/note.md`, `ai-resources/.claude/commands/friction-log.md`

### 2026-05-22 — /note friction: and /friction-log write incompatible session-header formats

- **Status:** applied 2026-05-22
- **Verified:** 2026-05-22 — fix shipped in commit `3a7ad4c` (B1: session-header unification in `note.md`); confirmed by operator
- **Category:** command
- **Friction source:** structural pattern — cross-referencing `note.md`, `friction-log.md`, and `friction-log-auto.sh` against the actual `friction-log.md` file
- **Proposal:** `friction-log.md` and `friction-log-auto.sh` write `## Session — {date}` + `### Friction Events` + `#### Write Activity`; `note.md` Step A writes `### Session: {date} — Manual entry` + `#### Friction Events` (colon, heading-level shift, wrong hash count). Consequence: `/note friction:` never detects an auto-created session block (auto writes `### Friction Events`, note.md looks for `#### Friction Events`), always appends a second differently-formatted block; and `log-write-activity.sh` keys on `#### Write Activity`, which `note.md` never writes — so `/note`-initiated sessions capture no write activity. Fix: make `note.md` Step A emit the exact same block as the other two writers (`## Session — {YYYY-MM-DD HH:MM}` / `### Friction Events` / `#### Write Activity`); change Step A step 2 to detect `### Friction Events` (three hashes), step 3 to append before `#### Write Activity`. Effort trivial; impact medium; first occurrence. Pairs with the entry above.
- **Target files:** `ai-resources/.claude/commands/note.md`

### 2026-05-22 — No mechanism ties a friction entry to the session/command that produced it

- **Status:** applied 2026-05-22
- **Verified:** 2026-05-22 — fix shipped in commit `3a7ad4c` (B3: context-capture suffix in `note.md` + `friction-log.md`); confirmed by operator
- **Category:** process
- **Friction source:** friction-log.md session 2026-05-18 10:00 — manual entry has no `**Trigger:**` line, unlike auto-created sessions which `friction-log-auto.sh` stamps with `**Trigger:** /skill-name`
- **Proposal:** Manually-started friction sessions (`/note friction:`, `/friction-log`) record no context for what command/workflow stage was running. Add lightweight context capture to `note.md` Step A and `friction-log.md` Step 3: before appending, run `git log -1 --pretty=%H` and grep for the most recent `## <today>` header in `logs/session-notes.md`; append a `(context: <last-commit-short-hash>, <session-note-title-if-any>)` suffix. If neither available, append `(context: none captured)`. One grep + one `git log -1` — cheap, stays non-blocking. Gives every future analysis a Location anchor even for one-line operator notes. Effort small; impact medium; first occurrence.
- **Target files:** `ai-resources/.claude/commands/note.md`, `ai-resources/.claude/commands/friction-log.md`

### 2026-04-25 — Make /wrap-session leaner

- **Status:** applied 2026-05-25
- **Verified:** 2026-05-25 — sub-1 through sub-4 landed in commit `a9d3321`; QC pass returned GO verdict (qc-reviewer on sonnet override; opus saturated). Executed 1 day ahead of the 2026-05-26 booking. The paired permission-sweep-auditor entry remains booked for 2026-05-26.
- **Review-cycle:** BOOKED 2026-05-22 — dedicated session targeted for **2026-05-26** (W22), paired with the 2026-04-28 permission-sweep-auditor entry below (~1.5–2 h combined). Not deferred again: two review cycles (2026-05-18, 2026-05-22) have now passed without execution; a third deferral is exactly the cycle-waste this booking exists to break. Scope when executed: port sub-1 through sub-4 (sub-5 is obsolete); sub-2 (reorder archive before session-note append) is the highest-leverage change.
- **Category:** command/skill
- **Source:** Mid-wrap conversation 2026-04-25 — operator asked why /wrap-session was taking so long. Audit of the wrap's actual tool-call count surfaced ~3-4 round-trips of avoidable cost.
- **Friction observation:** A typical /wrap-session reads 3 full log files (innovation-registry, improvement-log, friction-log) when single greps would do, and runs the archive AFTER appending today's entry, which forces a freshness-failure re-read of session-notes.md when the archive trims it.
- **Proposal:**
  1. **Replace full-file Reads with greps in steps 7, 9, 10.** Step 7 (innovation triage): grep for `| detected |` in `logs/innovation-registry.md`. Step 9 (improvement verification): scan for entries with `Status: applied` missing a `Verified:` line via awk/grep. Step 10 (friction reminder): grep for today's date (`$(date +%Y-%m-%d)`) in `logs/friction-log.md`. Saves ~150 lines of content streaming through context per wrap.
  2. **Reorder Step 11 (archive) BEFORE Step 3 (append session note).** Archive script rewrites session-notes.md when threshold exceeded; appending FIRST then archiving causes Edit-after-archive freshness invalidation, forcing a re-read of ~60 lines of the just-written note. Archive operates only on existing entries — running it before today's note is written is safe and avoids the re-read entirely.
  3. **Drop the wc -l + Read pattern in steps 1-2.** Spec says "last 5 lines only" but a `wc -l` probe before tail-reading is redundant. Tail-read directly with a known offset.
  4. **Drop the file-existence inventory before content reads.** Six `if -f` checks pre-empting reads in the current flow — let Read error on the rare missing case rather than pre-checking each.
  5. **Auto-pass dirt check when all dirty paths match Files Created/Files Modified verbatim.** Step 12a currently only short-circuits on empty git-status. Extending the silent-skip rule to "all matched" would skip the operator prompt for clean wraps where every dirty path was produced this session and is already enumerated. **Obsolete (2026-04-28):** Step 12a removed entirely; auto-pass refinement no longer applicable.
- **Target files (when executed):**
  - `ai-resources/.claude/commands/wrap-session.md`

### 2026-04-28 — permission-sweep-auditor: classify template sources, skip Rule 8

- **Status:** applied 2026-05-25
- **Verified:** 2026-05-25 — agent edit shipped in this session. Step 4a rewritten with two-signal template-class detection (path-class + value-class); SILENCE behavior replaces the previous ADVISORY downgrade because ADVISORY was empirically insufficient (see "Regression incident" below). `permission-template.md` § Intentional-template exceptions updated to mirror the new logic. Template file `workflows/research-workflow/.claude/settings.json` line 34 restored from hardcoded path to `{{WORKSPACE_ROOT}}` placeholder. Risk-check verdict was PROCEED-WITH-CAUTION (report: `audits/risk-checks/2026-05-25-edit-ai-resources-claude-agents-permission-sweep-auditor-md.md`); system-owner second opinion concurred and added the silencing recommendation.
- **Review-cycle:** BOOKED 2026-05-22 — executed 2026-05-25, one day before the booked date.
- **Regression incident (2026-05-11):** Between this entry being logged (2026-04-28) and the booked execution (2026-05-26), the exact failure mode this entry warned about occurred. A `permission-sweep Bundle 1` session (commit `0514590`) treated the `{{WORKSPACE_ROOT}}` placeholder as an actionable Rule 8 violation despite the ADVISORY tag, and replaced it with a literal absolute path — breaking the template. This incident demonstrates that downgrading to ADVISORY is insufficient protection; the placeholder case is now SILENCED entirely (no finding at any severity), and the path-class signal actively detects the regression mode (template file whose placeholders have been replaced).
- **Open sub-question resolved:** Agent-definition edits are NOT explicitly named in the `/risk-check` change-class list per `docs/audit-discipline.md` lines 19-24. However, this particular change has audit-cycle effects (every future `/permission-sweep` and `/friday-checkup --dry-run` uses the new logic), so `/risk-check` was invoked discretionarily. Verdict PROCEED-WITH-CAUTION; system-owner second opinion concurred.
- **Category:** Audit-recurrence prevention
- **Source:** `/permission-sweep` run 2026-04-27 / 2026-04-28 (report at `ai-resources/audits/permission-sweep-2026-04-27.md`). Auditor flagged `ai-resources/workflows/research-workflow/.claude/settings.json` line 35 (`"additionalDirectories": ["{{WORKSPACE_ROOT}}"]`) as a HIGH Rule 8 violation ("stale `additionalDirectories`") because the value is an unfilled placeholder. The placeholder is intentional — the most recent commit on that file (`81cb6c2 update: research-workflow template — additionalDirectories placeholder + SETUP step`) explicitly added it as a deploy-time fill-in consumed by `/deploy-workflow` / `/new-project`. Replacing it with a resolved path would corrupt new deployments. Auditor cannot currently distinguish template source from deployed instance.
- **Friction observation:** Held finding will re-fire on every future `/permission-sweep` run (including weekly `/friday-checkup --dry-run`) until the auditor learns to skip it. Each re-fire wastes operator attention on a non-issue and risks accidental "fix" by a future agent.
- **Proposal:**
  - Update `ai-resources/.claude/agents/permission-sweep-auditor.md` to add a template-class classification step before applying Rule 8. Heuristic: any file whose path matches `**/workflows/*/.claude/settings.json` (template source under the workflow library) is template-class; for template-class files, skip Rule 8 entirely or accept `{{...}}` placeholder values as PASS rather than HIGH. Optionally also detect `{{...}}` Mustache placeholders in any allow/deny entry as a secondary template-class signal.
  - Apply via `/risk-check` per Autonomy Rules pause-trigger #9 (agent-definition edit is a harness-level structural change). Confirm no regression on the 2 currently-scanned files before landing.
- **Target files:**
  - `ai-resources/.claude/agents/permission-sweep-auditor.md`

### 2026-05-22 — workflow-diagnosis skill brief overlaps improvement-analyst — document the boundary before building

- **Status:** applied 2026-05-28
- **Verified:** 2026-05-28 — new `## Workflow-improvement surfaces` section added to `ai-resources/docs/ai-resource-creation.md` covering both surfaces: `improvement-analyst` (session-friction-driven, invoked via `/improve` + `/friday-checkup` Step K monthly/quarterly) and `workflow-diagnosis` skill / `/diagnose-workflow` command (artifact-defect-driven, not yet built — inbox brief at `inbox/workflow-diagnosis.md`). Includes trigger phrasing, input/surface differentiation, routing rule with anti-routing language, complementary-not-redundant clarification, and status note marking the command name `/diagnose-workflow` as provisional until `/create-skill` runs. /qc-pass verdict REVISE → fixes applied (provisional-name softening). Source: Wave 2 fix-plan item id-29.
- **Category:** process
- **Friction source:** resource brief `inbox/workflow-diagnosis.md` (requested 2026-05-19), Exclusions section — explicitly lists "Analyze session-level friction or process issues (that's `improvement-analyst` agent)" as a non-goal
- **Proposal:** The boundary between the planned `workflow-diagnosis` skill (artifact-defect-driven workflow fixes) and the `improvement-analyst` agent (session-friction-driven workflow fixes) currently lives only in the inbox brief's prose, which is archived to `inbox/archive/` once fulfilled. When `/create-skill` processes `inbox/workflow-diagnosis.md`, add a one-paragraph routing note to `ai-resources/docs/ai-resource-creation.md` (or a short `## Workflow-improvement surfaces` section) stating the split: `improvement-analyst` agent = session-friction-driven; `workflow-diagnosis` skill / `/diagnose-workflow` = artifact-defect-driven; with trigger phrasing for each. Documentation only, no new tooling. Sequence with the `/create-skill` run that fulfills the brief. Effort small; impact medium; first occurrence.
- **Target files:** `ai-resources/docs/ai-resource-creation.md`

### 2026-05-25 — /token-audit numbered project menu
- **Status:** applied
- **Category:** command
- **Friction source:** friction-log 09:07 — /token-audit scope-selection required 3 rounds of AskUserQuestion; desired UX: list all projects numbered upfront
- **What changed:** Replaced the empty-args branch in `/token-audit` Step 1 with a numbered scope menu (1=ai-resources, 2=workspace, 3a/3b/…=projects). Keyword args (`ai-resources`, `workspace`, `project <name>`) retained as power-user shortcuts. Menu pattern mirrors `/friday-checkup` Step 3.
- **Verified:** 2026-05-25 — confirmed by operator

### 2026-05-25 — /monday-prep B7 seeds always-loaded CLAUDE.md layer
- **Status:** applied
- **Category:** command
- **Friction source:** friction-log 09:13 — monday-prep B7 skips workspace CLAUDE.md and ai-resources/CLAUDE.md; operator caught during W22 monday-prep diagnostics
- **What changed:** Prepended a two-step always-loaded layer audit (workspace CLAUDE.md + ai-resources/CLAUDE.md) to the B7 block before the ACTIVE_PROJECTS loop. No skip exemption for the always-loaded layer (skip rule is projects-only). Invokes `/audit-claude-md workspace` and `/audit-claude-md ai-resources` respectively.
- **Verified:** 2026-05-25 — confirmed by operator

### 2026-05-25 — Risk-check rule clarified to cover reorders of existing shared-state ops
- **Status:** applied
- **Category:** rule
- **Friction source:** friction-log 09:53 — /wrap-session leaner refactor reordered archive-vs-append (shared-state ops); risk-check was skipped under "existing-command refactor" framing
- **What changed:** (a) Added clarifying clause to `docs/audit-discipline.md` line 24: reordering existing shared-state ops qualifies, not only new automation. (b) Added tripwire note to `session-plan.md` Step 6: "existing-command refactor" framing does NOT exempt from /risk-check when shared-state ops are reordered.
- **Verified:** 2026-05-25 — confirmed by operator

### 2026-05-26 — repo-architecture.md is stale on `knowledge-bases/` (top-level directory + canonical-homes row)
- **Status:** applied 2026-05-26
- **Verified:** 2026-05-26 — workspace-root tree gained `├── knowledge-bases/` entry; canonical-homes table gained `**Obsidian KB vault** (cross-project reuse)` row. `pe-kb-vault/` confirmed sole vault via `ls knowledge-bases/`.
- **Category:** documentation
- **Friction source:** `/consult` system-owner advisory during `/context-builder` for the `strategic-os` project (chat session 2026-05-26). Operator asked where a planned Karpathy-style Obsidian frameworks KB should be deployed via `/deploy-kb` — inside-project vs. standalone. System-owner flagged that `ai-resources/docs/repo-architecture.md` does not document the `knowledge-bases/` top-level directory (which exists at workspace root and contains `pe-kb-vault/`) and that the canonical-homes table has no row for "Obsidian KB vault" as an artifact type. Both gaps surfaced because `/deploy-kb` already offers `knowledge-bases/{name}/` as a first-class deployment option and one such vault is in active use. System-owner cited OP-11 (surfacing tacit principles) and `system-doc.md § 4.5` (documentation-accuracy open loop). Verdict: documentation-drift item, not a blocker for the strategic-os work; route to the next `/friday-checkup` cadence.
- **Proposal:** Single edit pass on `ai-resources/docs/repo-architecture.md`:
  (a) **§ Top-level layout (workspace-root tree).** Add `knowledge-bases/` as a documented top-level directory with a one-line description (e.g., "standalone Obsidian KB vaults intended for cross-project reuse, deployed via `/deploy-kb`").
  (b) **§ Canonical homes by artifact type.** Add a new row: `**Obsidian KB vault (cross-project reuse)** | `knowledge-bases/{name}/` | Deployed via `/deploy-kb` standalone option; project-scoped vaults instead live under `projects/{name}/vault/`.` Wording captures the implicit principle ("KB vaults intended for cross-project reuse live in `knowledge-bases/{name}/`") that is currently tacit.
  (c) **§ When this file needs to change.** No change needed — "new top-level directory" already qualifies.
  `repo-architecture.md` is documentation, not a CLAUDE.md or settings file, so `/risk-check` is not required by change-class. Light-touch verification: confirm `pe-kb-vault/` is the only existing standalone vault before writing the row.
- **Target files:** `ai-resources/docs/repo-architecture.md`

### 2026-05-27 — Concurrent-session wrap clobbers in-progress session's session-notes.md additions

- **Status:** applied 2026-05-27
- **Verified:** 2026-05-27
- **Category:** session-issue
- **Source:** `/resolve-repo-problem 2026-05-27`
- **Friction source:** Expected: this session's `/prime`-appended task header + `/session-start`-written mandate to remain in `logs/session-notes.md` through wrap. Actual: a concurrent `/contract-check` session's `/wrap-session` ran `git add logs/session-notes.md` (which stages the entire working-tree content, not just its own additions), shipping my uncommitted mandate lines under commit `14d2a04` — the contract-check session's wrap commit. My session subsequently saw no `session-notes.md` modifications and committed its work without a wrap entry. Plan 2's mtime guard (`/session-start` Step 0.5, shipped 2026-05-26) only covers the `/prime` → `/session-start` upstream window; the failure here is post-`/session-start`, in the concurrent-wrap window — Plan 2's symmetric blind spot.
- **Proposal:** Add a wrap-time pre-commit guard to `wrap-session.md` (the canonical `ai-resources/.claude/commands/wrap-session.md` plus the workspace-root Phase 3 copy). Before staging `logs/session-notes.md`, compare on-disk content to the session's own writes: detect any `## YYYY-MM-DD` headers or `**Mandate:**` lines authored by another session and stop with a chat prompt asking the operator to resolve (commit only own work, or commit the union). Symmetric counterpart to Plan 2 — closes the post-`/session-start` window the same way Plan 2 closed the pre-`/session-start` window. **/risk-check change class:** YES (canonical-command edit) — run `/risk-check` before landing.
- **Implementation 2026-05-27:** Shipped commits `6b1b018` (ai-resources canonical Step 3.5 + risk-check report) + `5157a5d` (workspace-root Phase 3 copy Step 1.5). Detection uses TWO independent signals — today-header count AND mandate-line count — so the guard catches both the separate-header incident shape (original 2026-05-27 commit `14d2a04` failure) AND the shared-header incident shape (when /prime's header-reuse rule means both concurrent sessions share one today-header but each writes a mandate line under it). Mechanical disambiguator via `.prime-mtime` marker existence + today-midnight epoch check; default-to-stop on FOREIGN >= 1; no union-reply branch. Risk-check verdict PROCEED-WITH-CAUTION with 5+2 mitigations applied (SO second opinion). QC verdict REVISE → 2 findings addressed (bash `grep -c` zero-match arithmetic bug + header-reuse blind spot via mandate-line signal); 1 finding deferred (marker semantics simplification — optional, non-blocking).
- **Target files:** `ai-resources/.claude/commands/wrap-session.md`, `~/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md` (Phase 3 wrap copy)
- **Notes:** `ai-resources/audits/working/2026-05-27-resolve-concurrent-session-overwrite-session-notes.md`; risk-check report `ai-resources/audits/risk-checks/2026-05-27-wrap-session-foreign-session-detection-guard.md`

### 2026-05-27 — Foreign-files-in-working-tree alarm — diagnostic refinement (symlink-check-first)

- **Status:** applied 2026-05-27
- **Verified:** 2026-05-27
- **Category:** session-issue
- **Source:** /resolve-repo-problem 2026-05-27
- **Friction source:** During this session's Cluster 1 commit, `git status` returned 12+ "untracked" `.claude/commands/*.md` files under workspace-root that appeared to be new command additions from a runaway session. Investigation revealed 12 of 13 are SYMLINKS to ai-resources canonical command bodies (already committed); only 1 (`harness-start.md`) is a real abandoned file from May 25. Separately, 4 ai-resources file modifications + 2 fx-c1 risk-checks appeared in working tree mid-session and committed 1 second after the Cluster 1 commit — a parallel session's commit-in-progress, not a concurrent-session contention. Net: false alarm, but the operator/Claude spent a /resolve-repo-problem cycle (~5 min + investigator subagent) to triage it.
- **Proposal:** Add a one-line diagnostic-shortcut to `docs/commit-discipline.md` (or workspace CLAUDE.md § Working Principles): when `git status` flags many `?? .claude/commands/*.md` files under workspace-root, run `find .claude/commands -type l -newer /dev/null | wc -l` (or equivalent) BEFORE escalating to /resolve-repo-problem — most will be symlinks to ai-resources canonical bodies. Separately, log the abandoned `harness-start.md` and the 2-day-old harness/* leftovers as candidates for `/cleanup-worktree` at next Friday cadence.
- **Implementation 2026-05-27:** Shipped commit `94e0cf2` (ai-resources) — new "Foreign-files diagnostic shortcut" subsection appended to `docs/commit-discipline.md` with the symlink-check command (`find .claude/commands -type l | wc -l`) and the rule to compare its count against the untracked-file count before escalating. Abandoned `harness-start.md` left as a separate `/cleanup-worktree` candidate.
- **Target files:** `docs/commit-discipline.md` OR workspace `CLAUDE.md` (add 1–2 sentence diagnostic-shortcut rule); `harness-start.md` abandoned file separately surfaced.
- **Notes:** `audits/working/2026-05-27-resolve-concurrent-session-foreign-files-cluster-1-investigation.md`

### 2026-05-28 — /fix-repo-issues scanner output lacks coverage-confidence transparency

- **Status:** applied 2026-05-28
- **Verified:** 2026-05-28 — confirmed by operator (operator selected "Option A" at the triage gate; edit shipped same session)
- **Category:** session-issue
- **Source:** `/resolve-repo-problem 2026-05-28`
- **Friction source:** Expected: /fix-repo-issues scanner summary self-evidently conveys what was scanned, what was excluded and why, and which items are fix-shaped vs build-shaped vs watch-shaped — so the operator can trust the "Plan-into-batch" tier without re-reading source logs. Actual: scanner returned 9 items with a Top-candidates list intermixing T1 fix items (id-04) with T1 inbox build briefs (id-01/02/03/05), the working-notes file held 16 exclusion bullets but the 30-line summary stripped them, and the operator had to push back ("Are you sure there's only one problem?") to trigger a manual cross-check across friction-log, improvement-log, and decisions.md. Trigger: `/fix-repo-issues` Step 1 (scanner invocation) + Step 3 (plan preview).
- **Proposal:** Apply Option A (Quick patch) — extend the scanner agent's return-summary template to include explicit lines for sources scanned, out-of-contract source classes, exclusion counts by category, deferred-but-not-triggered counterweight, and item-type classification (fix / build / watch); re-segment Top candidates by type before priority ranking. Bump the agent's 30-line summary cap to ~40 to accommodate the audit trail. Edit confined to `.claude/agents/fix-repo-issues-scanner.md` — no command-body change required. **/risk-check change class:** YES (canonical-agent body edit) — run `/risk-check` before landing per audit-discipline.md.
- **Implementation 2026-05-28:** Shipped commit `0c4544f` — single-file edit to `.claude/agents/fix-repo-issues-scanner.md`: new Step 5.5 (item-type classification: fix/build/watch by source, with priority-signal lift rule), new Step 5.6 (audit-trail counters), Step 6 working-notes schema gains `type` column + "By type" count + "## Coverage report" block, Step 7 return-summary gains Coverage block + per-type segmented Top candidates (Fix-shaped / Build-shaped / Watch-shaped), line cap bumped 30→40 consistently across 3 references. Risk-check verdict GO (all 5 dimensions Low; report `audits/risk-checks/2026-05-28-proposed-change-extend-the-return-summary-template-in-claude.md`); single-consumer agent; LLM-driven downstream consumption tolerates added blocks; `NOTES:` parse anchor preserved.
- **Target files:** `ai-resources/.claude/agents/fix-repo-issues-scanner.md` (Option A); optionally `ai-resources/.claude/commands/fix-repo-issues.md` Step 3 if Option B is chosen instead.
- **Notes:** `audits/working/2026-05-28-resolve-fix-repo-issues-scanner-coverage-confidence-gap.md`; risk-check report `audits/risk-checks/2026-05-28-proposed-change-extend-the-return-summary-template-in-claude.md`

### 2026-05-28 — wrap-session foreign-guard misfires on prior-day uncommitted remnant

- **Status:** applied 2026-05-28
- **Verified:** 2026-05-28 — `/wrap-session` Step 3.5 (canonical) + Step 1.5 (workspace-root paired copy) now classify FOREIGN content as CONCURRENT / REMNANT / MIXED / UNKNOWN via an awk classifier that walks `^## YYYY-MM-DD` headers and tags each `**Mandate:**` line with its enclosing date. STOP message branches per class — REMNANT offers a wrap-recovery commit path; MIXED orders resolution (orphan first, then concurrent); CONCURRENT keeps prior switch-terminal guidance; UNKNOWN safely defaults to CONCURRENT-shape. Risk-check verdict PROCEED-WITH-CAUTION (Blast radius + Hidden coupling Medium; D3 paired-files + D5 awk-regex / live-rehearsal / PRIME_RAN-assumption mitigations all applied inline; report `audits/risk-checks/2026-05-28-wrap-session-step-3-5-concurrent-remnant-mixed-classifier.md`). `/qc-pass` verdict GO. Classifier rehearsed against current `session-notes.md` (UNKNOWN, EXTRA=-1) and synthetic CONCURRENT/REMNANT/MIXED cases (all 3 classes verified).
- **Category:** session-issue
- **Source:** /resolve-repo-problem 2026-05-28
- **Friction source:** /wrap-session Step 3.5 foreign-session pre-write guard fired today (FOREIGN=1, mandate count 7 in WT vs 6 in HEAD). Working tree contains an orphan mandate from yesterday's W22 housekeeping session — that session ran /prime + /session-start but never invoked /wrap-session, leaving the mandate line unstaged. Today's guard treated the prior-day remnant as live foreign-session content and steered the operator toward the wrong remediation ("switch to the other terminal").
- **Proposal:** Patch Step 3.5 to parse the enclosing `## YYYY-MM-DD` header of each extra mandate and classify the delta as CONCURRENT (today-dated), REMNANT (prior-day), or MIXED. Branch the remediation text per class: CONCURRENT stays as-is; REMNANT offers a "commit the orphan as a standalone wrap-recovery commit" path; MIXED warns about both and asks the operator to pick. Update both `ai-resources/.claude/commands/wrap-session.md` Step 3.5 and the paired workspace-root copy. This is a /risk-check change class (cross-cutting workflow guard with shared-state semantics) — plan-time gate required.
- **Target files:** ai-resources/.claude/commands/wrap-session.md, ~/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md (paired copy per existing PAIRED CONTRACT comment block)
- **Notes:** audits/working/2026-05-28-resolve-wrap-session-foreign-guard-prior-day-remnant.md

### 2026-05-28 — /prime does not surface per-unit `work/{Wn}-{NAME}-README.md` files

- **Status:** applied 2026-05-28
- **Verified:** 2026-05-28 — new "Phase READMEs" bullet added to `/prime` Step 4 (Exception checks) scanning `work/` (one level deep) for files matching `W*-*-README.md`; captures paths only (not body). Surfaces in Step 6 brief output template as a new `⚠ Phase READMEs detected: {paths}` exception line. Bounded scan; skips silently if `work/` is absent. /qc-pass verdict REVISE → fixes applied (title-capture dropped to align with template). Optional paired warning in `/wrap-session` deferred — single-end fix lands first. Source: Wave 2 fix-plan item id-33.
- **Category:** command/skill
- **Source:** nordic-pe-screening-project W0 kick-off session 2026-05-28 — System Owner advisory (verdict accepted, see `projects/nordic-pe-screening-project/logs/decisions.md` row #3 and `logs/session-notes.md` 2026-05-28 wrap entry).
- **Friction source:** `/prime` reads `logs/session-notes.md` and carries forward its Next Steps verbatim, but does not scan `work/*.md` for phase-scoped README files that may overrule the general program rubric. In 2026-05-28's W0 kick-off, a 29-line `work/W0-SETUP-README.md` ("Layer 2 child cycle: No") was missed; `/prime` carried forward yesterday's "Open the W0 child cycle…" Next Step under the general "each phase opens a child cycle" rubric. Outcome: ~190k subagent tokens + ~3 h operator time spent producing a Layer 2 context pack that the README would have prevented at turn 1. AP-1 silent-conflict-resolution failure mode.
- **Proposal:** Add a step to `/prime` that scans the project's `work/` directory (if present) for `Wn-*-README.md` (or similar phase-README) files and surfaces their existence in the brief as an exception line. Surface only the presence (path + first-line title), not the content — read on demand at the start of the work unit, not at every `/prime`. Optional second proposal: have `/wrap-session` warn when a Next Steps line references a phase whose `work/Wn-README.md` exists, to catch silent-rubric-override at write time rather than next-session read time.
- **Target files:** ai-resources/.claude/commands/prime.md (primary); optionally ai-resources/.claude/commands/wrap-session.md (paired warning).

### 2026-05-28 — /session-plan Step 0 same-session short-circuit (4th-recurrence MISMATCH false-positive resolved)

- **Status:** applied 2026-05-28 — `ai-resources/.claude/commands/session-plan.md` Step 0 carries a new sub-step 0 (own-session marker check using `logs/.prime-mtime`) and a sub-step 6 override that forces MATCH (3-option keep/overwrite/pass2 prompt) regardless of intent comparison when `SAME_SESSION = true`. Fix-plan 2026-05-28-1121 item `[project-axcion-brand-book/id-02]`.
- **Verified:** 2026-05-28 — risk-check verdict GO (all 5 dimensions Low) at `audits/risk-checks/2026-05-28-session-plan-same-session-short-circuit.md`; QC verdict REVISE → applied finding-4 fix (stale-marker freshness window mirroring `/session-start` Step 0.5). Friction-log entry at `projects/axcion-brand-book/logs/friction-log.md` 2026-05-26 19:56 carries `[FADING-GATE] verified 2026-05-28` annotation.
- **Category:** session-orchestration / concurrent-session safety
- **Friction source:** Recurring MISMATCH false-positive in `/session-plan` Step 0 — Phase 3 lock following Phase 2 QC was classified as a "concurrent session collision" and auto-routed to `session-plan-pass2.md` without prompting, because the new intent string differed from the existing plan's intent. Logged 4× in brand-book project across 4 sequential same-day sessions (friction-log 2026-05-23, 2026-05-25, 2026-05-26 (twice), 2026-05-27). Original remediation proposal in brand-book usage-log 2026-05-26 named a heuristic ("detect wrap-format entry: `### Summary` + `### Next Steps` within today's `## ` block"); the executed fix uses the cleaner own-session marker (`logs/.prime-mtime`) introduced in May for `/session-start` Step 0.5.
- **Resolution path:** Two structural additions to `session-plan.md` Step 0:
  - **Sub-step 0** (new) — reads `logs/.prime-mtime` (mtime of `session-notes.md` at the moment `/prime` appended today's header — written by `/prime` Steps 8a.3.a / 8b.1 / 8c.3); compares to `session-plan.md`'s mtime. `PLAN_MTIME > PRIME_MTIME` → set `SAME_SESSION = true` (this session's `/prime` ran BEFORE the existing plan was written → must be this session's plan). Freshness window: marker older than today's start-of-day → treat as stale → `SAME_SESSION = false` (mirrors `/session-start` Step 0.5).
  - **Sub-step 6 override** — at the top of "Apply the result", check `SAME_SESSION`. If true, force MATCH regardless of sub-steps 1-5's intent comparison. The MATCH branch's 3-option prompt surfaces; operator chooses keep / overwrite / pass2 explicitly instead of getting silent-auto-pass2.
- **Coverage gaps documented:** Marker-missing case → falls through to existing intent comparison (no regression). Marker-stale case → same. Concurrent-foreign-write-after-this-session's-/prime case → would misclassify as same-session and surface the 3-option prompt instead of silent-auto-pass2 (operator still gets explicit choice; not a degradation). All three fall-through paths preserve the existing MISMATCH branch's foreign-session protection.

### 2026-05-28 — Mandate-alignment recovery: should `/session-start` be re-invoked when a session pivots immediately after `/prime`?

- **Status:** logged (pending)
- **Category:** session-issue / command-design
- **Source:** nordic-pe-macro-landscape-H1-2026 session 2026-05-28 — session opened with mandate "FX-B1+B2 implementation"; pivoted immediately to drafting `templating-plan-v2-resolution-plan.md` per operator direction. Recorded mandate diverged from actual work for the session's full duration.
- **Friction source:** Decision-point-posture pivots (operator-driven, non-drift) currently leave the recorded mandate stale. `/wrap-session` then journals work against a mandate that does not describe what happened. Downstream `/drift-check` and `/contract-check` would mis-classify the pivot as drift.
- **Proposal:** Consider adding a `/session-start --re-mandate` re-invocation path that the operator can fire mid-session when a pivot happens. Alternatively, document a "Pivot Acknowledged" annotation pattern in the session-notes body so `/wrap-session` can detect and journal the pivot explicitly.
- **Target files (when executed):** `ai-resources/.claude/commands/session-start.md` (optional re-mandate flag), `ai-resources/.claude/commands/wrap-session.md` (pivot-detection in Step 7a).
- **Triage cadence:** `/improve` consideration; not urgent.
