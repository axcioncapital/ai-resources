# Risk Check — 2026-04-29

## Change

New slash command `/session-plan` added to `ai-resources/.claude/commands/session-plan.md`. Paired change: one row added to `ai-resources/docs/repo-architecture.md` logs table. The command reads `logs/session-notes.md`, writes `logs/session-plan.md` (overwrite), and emits operator guidance. No hook edits, no permission changes, no symlinks, no shared-state automation.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-plan.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/repo-architecture.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/session-notes.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/session-plan.md — not yet present

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Pay-as-used operator-invoked command with no permission, hook, or automation surface; principal residual risk is hidden coupling to the post-`/prime` orientation flow (overlap with `/prime`'s model-comparison and session-header logging) and a shared filename `session-plan.md` already used by the research-workflow execution stage.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Command is operator-invoked on demand — frontmatter + body of `session-plan.md` only loads when the operator types `/session-plan`. No always-loaded file is touched. Evidence: change description states "No hook edits ... no shared-state automation", and the command lives under `.claude/commands/` which is on-demand-loaded per the architecture doc (line 93: "Operator-invoked, on-demand").
- The repo-architecture row addition is one line to a load-on-demand doc (`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/repo-architecture.md` lines 199–209 logs table), not an always-loaded file. Confirmed by the file's own header (line 3): "When to read this file: Whenever you propose adding, moving, or restructuring an AI resource".
- No `@import` chain in always-loaded CLAUDE.md introduced. Workspace CLAUDE.md and `ai-resources/CLAUDE.md` are not modified per the change description.
- New auto-distributed surface: the auto-sync hook (`repo-architecture.md` lines 119–126) symlinks every new command under `.claude/commands/` into every project — but symlinks do not consume tokens unless invoked. Net per-session cost remains zero unless operator types `/session-plan`.

### Dimension 2: Permissions Surface
**Risk:** Low

- Change description explicitly states: "no permission changes". No `settings.json` `allow` / `ask` / `deny` edits.
- Command actions (Read `logs/session-notes.md`, Write `logs/session-plan.md`) are within already-established repo patterns — `Read(logs/**)` and `Write(logs/**)` are used by existing commands (`/wrap-session`, `/prime`, `/coach`, `/friday-checkup`) without per-command authorization friction. Evidence: `wrap-session.md:23, 25, 67`, `prime.md:7, 57`.

### Dimension 3: Blast Radius
**Risk:** Medium

- Direct files touched: 2 (the new command file; one row in `repo-architecture.md`).
- Grep for `session-plan` across `ai-resources/.claude/`, `docs/`, and both CLAUDE.md files returned **0 hits** — no caller currently expects a `logs/session-plan.md`. Caller-coupling at introduction time is zero.
- However, the filename `session-plan.md` is already used by the **research-workflow execution stage** at a different path (`workflows/research-workflow/.claude/commands/intake-reports.md:16`, `inject-dependency.md:20`, `run-execution.md:41,49,67,79`; `reference/file-conventions.md:35`). Those references are scoped to `execution/research-prompts/{section}/session-plan.md`, NOT `logs/session-plan.md`, so functional collision is avoided — but operator vocabulary now overloads the term "session plan" across two distinct purposes (orchestration vs. research execution). Total grep references to the filename across the repo: ~10 (in research-workflow audit reports + commands). All are in the workflow-scoped path, not `logs/`.
- Auto-sync hook (`repo-architecture.md:119`) will symlink `session-plan.md` into every project's `.claude/commands/` on next session start. That is the intended behavior of the canonical-command pipeline, not a contract change — but it does mean the new command is immediately available in every project, including ones whose operators have not yet seen it. No backwards-incompatibility for existing commands.
- No existing command's contract changes. `/prime` (`prime.md:7, 57`) keeps reading and appending to `logs/session-notes.md`; `/wrap-session` keeps appending entries; `coach-reminder.sh` and `auto-qc-nudge.sh` keep their `session-notes.md` references intact.

### Dimension 4: Reversibility
**Risk:** Low

- Both new files (`session-plan.md` command + `logs/session-plan.md` output) are net-new. `git revert` on the command file fully removes it.
- The `logs/session-plan.md` output is **overwrite each session** (per change description and plan reference), so it is not an append-only log mutation — no stale entries accumulate that revert cannot clean. A revert leaves the file as the last-overwritten content; deleting the file is a single-step cleanup.
- The `repo-architecture.md` row addition is a single-row markdown edit fully reversible by `git revert` of the same commit.
- No external state propagation (no git push triggered, no Notion write, no hook registration).
- Auto-sync side effect: once symlinked into projects, removing the canonical command still leaves dangling symlinks until next SessionStart. Minor cleanup, not state loss. This is the standard behavior for any command removal under the existing symlink topology (`repo-architecture.md:121`: "Existing files at the target are never overwritten ... including broken symlink").

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Functional overlap with `/prime`.** `/prime` already (a) reads last entry of `session-notes.md` (prime.md:7), (b) compares active session model vs. project default and emits a `→ /model` hint (prime.md:30–33), (c) logs a session entry header to `session-notes.md` once the operator names the work (prime.md:57). The proposed `/session-plan` re-does steps (a) and partially (b) per the plan reference ("recommends model tier vs active session model") and adds new responsibilities (autonomy posture, structural-class risk pre-screen, source material listing, `/resolve` reminder). Two commands now both inspect session intent and recommend model tier — risk of subtly diverging logic if either is later edited. Coupling is real but documented at the change site (the new command's own body) only if the command makes its post-`/prime` ordering explicit.
- **Vocabulary collision** with `workflows/research-workflow`'s `session-plan.md` (see Dimension 3). Operators reading audit reports like `audits/repo-due-diligence-2026-04-27-workflow-research-workflow.md:20` will see "session-plan.md" referring to two different artifacts. Distinct paths prevent functional breakage but the term is now overloaded.
- **Implicit ordering contract.** Plan reference says the command "runs after `/prime`". This is an unenforced operator discipline — nothing in the command body can verify `/prime` already ran this session. If operator invokes `/session-plan` cold (no `/prime`), behavior depends on whether the new command's body handles the "no recent session-notes entry" case. This is a coupling whose contract should be documented at the change site.
- **`/resolve` reminder coupling.** Plan reference says the command "reminds operator about `/resolve`". `/resolve` (`resolve.md:9`) requires a recent QC-review block in conversation context. If `/session-plan` is invoked in a fresh session without QC findings present, the reminder fires into a context where `/resolve` would error. Low-severity hidden contract.
- **Risk-class assessment overlap.** Plan reference says the command "assesses structural-class risk." This overlaps with `/risk-check` (the operator-invoked structural risk gate documented in `audit-discipline.md:15–35`). Two paths now produce structural-risk signals. If `/session-plan` outputs anything stronger than a "consider /risk-check at plan-time" pointer, the overlap can mislead operators who substitute the orientation pre-screen for the actual plan-time gate.
- One implicit dependency on `session-notes.md` *append-direction* discipline (memory item `feedback_session_notes_append_direction.md`: "new entries go at END of file"). If `/session-plan` infers intent from the "last entry," it implicitly relies on `/wrap-session`'s append-to-end discipline. This is an established repo convention (wrap-session.md:25) — not new — but worth surfacing as the contract the new command depends on.

## Mitigations

- **Dimension 3 (Blast Radius — Medium):** Add a one-line clarifier to the new command's frontmatter or first paragraph explicitly disambiguating `logs/session-plan.md` (orchestration output) from `workflows/research-workflow/.../session-plan.md` (research-execution artifact). Minimum: a sentence in the command body that names the path it writes ("This command writes `logs/session-plan.md` — not to be confused with the research-workflow's per-section `session-plan.md`."). Mitigation reduces operator-vocabulary risk without touching either side's path.
- **Dimension 5 (Hidden Coupling — Medium, primary):** State the post-`/prime` ordering as an explicit precondition in the command body (e.g., "Step 0: confirm a `## YYYY-MM-DD` header was added to `session-notes.md` this session; if not, instruct operator to run `/prime` first and stop"). Without this guard, the command silently re-implements `/prime`'s state-read behavior in inconsistent contexts.
- **Dimension 5 (Hidden Coupling — Medium, secondary):** Make the `/resolve` reminder conditional on QC-block detection in context (mirror `/resolve`'s own gate at `resolve.md:9`). If no QC findings present, omit the reminder. Prevents misdirected reminders into sessions where `/resolve` would error.
- **Dimension 5 (Hidden Coupling — Medium, tertiary):** Bound the structural-risk pre-screen output to a pointer ("If you plan to touch a class listed in `audit-discipline.md`, run `/risk-check` after the plan is approved.") rather than an evaluation. Avoids substitution risk vs. the canonical `/risk-check` gate.
- **Dimension 5 (Hidden Coupling — Medium, drift control):** Add a one-line note in `/prime`'s body — or in `docs/session-rituals.md` if ritual-doc edits are out of scope here — pointing to `/session-plan` as the optional next step. Prevents the two commands' model-comparison logic from drifting silently because the relationship is undocumented.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION, plan reference text the operator passed in, and referenced files). No training-data fallback was used on fetch/read failures.
