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
