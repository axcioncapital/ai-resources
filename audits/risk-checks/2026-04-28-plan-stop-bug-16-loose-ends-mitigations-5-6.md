# Risk Check — 2026-04-28

## Change

Plan-time risk-check on the three-track plan at `/Users/patrik.lindeberg/.claude/plans/next-let-s-do-another-transient-walrus.md`.

**Track 1 (high priority — bug fix in ai-resources canonical):** Move `coach-reminder.sh` and `improve-reminder.sh` from PostToolUse[Write|Edit] (currently lines 60–71) to a new Stop entry in `ai-resources/.claude/settings.json`, alongside the existing `check-stop-reminders.sh` Stop entry. The graduation commit `07cc6d6` placed them under PostToolUse by mistake; intent is session-end nudges. Mirrors the buy-side reference pattern at `projects/buy-side-service-plan/.claude/settings.json:115–130`. Single-file structural fix.

**Track 2 — 16 loose-end items from the 2026-04-27 innovation-sweep audit of `projects/buy-side-service-plan/`:**
- Apply-now (2 items): #7 graduate `save-session.md` to ai-resources (prerequisite: fix the absolute-path bug at `/logs/scratchpads/{...}` from mitigation #2 of the 2026-04-27 risk-check first); #9 rename `projects/buy-side-service-plan/.claude/agents/qc-reviewer.md` to `qc-reviewer-buy-side.md` to disambiguate from canonical (prerequisite: caller grep-sweep of `projects/buy-side-service-plan/`).
- Operator-decision (14 items): mix of extracts to ai-resources (`challenge.md`, `content-review.md`), keep-locals (`compile-wiki.md`, `draft-section.md`, `lint-wiki.md`, `service-design-review.md`+`service-designer.md`, `prose-quality-standards.md`), CLAUDE.md edits at project level (Cross-Model Rules L25–30, Adaptive Thinking Override L45–48, Context Isolation Rules), workspace-level CLAUDE.md additions (Cross-Model Rules, Adaptive Thinking Override propose extraction up), file-status verifications (`review.md`, `strategic-critic.md`), and hook-pattern reviews (PostToolUse[Write] taxonomy, Stop checkpoint-recency, Stop sentinel verification).

**Track 3 — Deferred mitigations from the 2026-04-27 risk-check:**
- #5 deploy-workflow registration policy: Option A (auto-merge canonical hook entries via jq deep-merge — reverses current `deploy-workflow.md:118–124` policy; Option A requires its own `/risk-check`) vs Option B (keep manual; emit a checklist).
- #6 revert log persistence note: pure docs — append a note to `deploy-workflow.md` Hooks section and a 1-line header comment to `coach-reminder.sh` and `improve-reminder.sh`.

**Change classes touched (per `ai-resources/docs/audit-discipline.md` § Risk-check change classes):** Hook edits; Permission/settings edits; Cross-cutting CLAUDE.md edits; New commands/skills; Automation with shared-state effects (Track 3 #5 Option A only).

**Out of scope:** auditor template-class classification fix (already backlogged); restoring `Read(audits/working/**)` deny.

## Referenced files

- /Users/patrik.lindeberg/.claude/plans/next-let-s-do-another-transient-walrus.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/settings.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/.claude/settings.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/.claude/agents/qc-reviewer.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/deploy-workflow.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/coach-reminder.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/improve-reminder.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/check-stop-reminders.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/save-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/.claude/commands/save-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md — exists (workspace always-loaded)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/innovation-sweep-buy-side-service-plan-2026-04-27.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/risk-checks/2026-04-27-this-session-added-4-hooks-and-1-command-to-ai-resources.md — exists

## Verdict

**PROCEED-WITH-CAUTION**

**Summary:** Track 1 is a clean, well-scoped bug fix; Tracks 2 and 3 #6 are largely safe; the load-bearing risk concentrates on Track 3 #5 Option A (auto-merge into deployed projects' settings.json — high blast radius and high hidden coupling) and on Track 2 #11/#12 which add cross-cutting workspace CLAUDE.md content (always-loaded across every project session). With paired mitigations applied — most importantly, the plan's own gate that Option A requires its own `/risk-check` before commit, plus an explicit ordering safeguard for Track 1 vs Track 3 #6 — the bundle proceeds.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- **Track 1** *reduces* per-Write cost: removes `coach-reminder.sh` + `improve-reminder.sh` from PostToolUse[Write|Edit] (currently `ai-resources/.claude/settings.json:60–71`) and reattaches both at Stop. Net change: −2 hook invocations per Write/Edit across all deployed projects; +2 hook invocations per session-end. Both hooks already self-dedupe per session (`coach-reminder.sh:7` `SESSION_MARKER`, `improve-reminder.sh:8`), so per-Write cost was already gated, but the misclassification still meant a `jq` + `grep` per Write — non-zero. Net direction is favorable.
- **Track 2 #11 (Cross-Model Rules) and #12 (Adaptive Thinking Override) propose moving content from `projects/buy-side-service-plan/CLAUDE.md` into workspace-root `CLAUDE.md`** — the always-loaded file. Cross-Model Rules at `projects/buy-side-service-plan/CLAUDE.md:25–30` is 6 lines (~150 tokens); Adaptive Thinking Override at L45–48 is 4 lines (~80 tokens). Combined ≈ 230 tokens added to every workspace session, every turn, in every project. This is the single largest ongoing-cost item in the plan.
- **Track 2 #7 (graduate `save-session.md`):** the canonical command file already exists at `ai-resources/.claude/commands/save-session.md` (60 lines). The graduation appears to already be complete — no new ongoing token cost from the command itself; commands are pay-as-used. The "graduate" action here is more about retiring the project copy in favor of the canonical symlink.
- **Track 2 #9 (rename qc-reviewer):** zero ongoing cost. Agents are loaded only when invoked.
- **Track 3 #6 (header comments + docs note):** ~3 lines added to `deploy-workflow.md` and 1 line each to two hooks. Documentation lives in command file and hook files — loaded on use, not always-loaded. Negligible.
- **Track 3 #5 Option A (auto-merge step):** adds a new step block to `deploy-workflow.md`, which loads only when `/deploy-workflow` runs. No always-loaded cost.
- The CHANGE_DESCRIPTION does not specify whether Track 2 #11/#12 will be deduplicated against existing workspace CLAUDE.md content (e.g., the workspace already covers Cross-Model in different shape via `## Axcíon's Tool Ecosystem` at lines 13–21). Without dedup, this is straight addition.

### Dimension 2: Permissions Surface
**Risk:** Low

- Track 1: zero permission changes — only the `.hooks` block of `ai-resources/.claude/settings.json` is touched. The `permissions.allow/deny` arrays at lines 3–19 are untouched.
- Track 2 (all items): no allow/ask/deny changes in any file.
- Track 3 #5 Option A: introduces a *behavior* (auto-write to deployed projects' `settings.json`) that is enabled by existing `Bash(*)` allow at `ai-resources/.claude/settings.json:7`. No new permission grants required to authorize the new behavior. Capability surface widens functionally, but settings-file allowlist does not change.
- Track 3 #6: pure docs, no permission impact.
- No deny-rule removals. No permission scope escalations. No new external-tool authorizations.

### Dimension 3: Blast Radius
**Risk:** High (driven entirely by Track 3 #5 Option A; absent #5 the rating would be Medium)

**Track 1 — narrow.** Single file touched (`ai-resources/.claude/settings.json`). Verified: 7 deployed-project `settings.json` files exist under `projects/*/.claude/settings.json` (`buy-side-service-plan`, `project-planning`, `nordic-pe-landscape-mapping-4-26`, `obsidian-pe-kb`, `repo-documentation`, `global-macro-analysis`, `corporate-identity`). Track 1 modifies the canonical file only — deployed projects have their own copies and are not affected directly. Each project will pick up the new event registration only on its own next `/deploy-workflow` or `/sync-workflow`. The wrapper hook `check-stop-reminders.sh` is referenced once at `ai-resources/.claude/settings.json:80` and handles only innovation-registry + usage-log checks (verified at hook lines 14–24) — does not call coach/improve. No collision.

**Track 2 #9 — bounded.** Grep on `projects/buy-side-service-plan/` returns 3 active wiring callers of `qc-reviewer`: `.claude/shared-manifest.json:49` (manifest entry), `.claude/commands/content-review.md:9` ("defined in .claude/agents/qc-reviewer.md"), and `.claude/commands/compile-wiki.md:59` ("via an independent `qc-reviewer` subagent"). Plus 4 documentation references in `context/` and `report/checkpoints/` (passive). Rename requires updating 3 wiring callers and probably 1 manifest entry; verbal references in context docs will silently keep working as long as the canonical agent name `qc-reviewer` still resolves elsewhere — but operator should update them to `qc-reviewer-buy-side` for clarity. The plan explicitly calls for the grep-sweep prerequisite.

**Track 2 #7 — bounded.** Two `save-session.md` files exist: canonical `ai-resources/.claude/commands/save-session.md` and project-local `projects/buy-side-service-plan/.claude/commands/save-session.md`. The canonical is **not** referenced by `wrap-session.md` or `prime.md` (verified by grep). Auto-sync via `auto-sync-shared.sh` and the project's `shared-manifest.json` will create symlinks on next SessionStart in projects that list it as shared. Risk is contained: the project file diverges from canonical only on the absolute-path bug (`/logs/scratchpads/` vs `logs/scratchpads/`).

**Track 2 #11/#12 — cross-cutting.** Workspace `CLAUDE.md` is loaded on every session in every project. Adding sections affects 7 deployed projects + ai-resources work + workflows work. Content is not behavioral but is always-loaded.

**Track 2 #15 — bounded.** Project-local CLAUDE.md edit only; no caller dependencies.

**Track 3 #5 Option A — wide.** Per `deploy-workflow.md:92–101`, `/deploy-workflow` already copies hooks into every new project. Option A adds a step that *writes* to deployed projects' `settings.json`. This is a state-mutating step against shared infra. Specifically:
- 7 existing project `settings.json` files become potential targets when operators re-run `/deploy-workflow` or `/sync-workflow`.
- The collision rule as specified — `(project_hooks + canonical_hooks) | unique_by(.command)` — deduplicates only on exact `.command` string match. The buy-side reference at `projects/buy-side-service-plan/.claude/settings.json:117–128` registers commands as `"$CLAUDE_PROJECT_DIR/.claude/hooks/improve-reminder.sh"` (no `bash` prefix) while the ai-resources canonical at `ai-resources/.claude/settings.json:62` uses `bash $CLAUDE_PROJECT_DIR/.claude/hooks/coach-reminder.sh`. **These two strings will not dedupe.** Re-running deploy with Option A against an existing project would result in *two* registrations of the same hook with different invocation prefixes. The "idempotent" verification step the plan describes (re-run, confirm no duplicates) will likely fail on the buy-side project unless the dedup key is normalized (e.g., dedup on basename-of-command-path, not full string).
- Option A also reverses an explicit policy at `deploy-workflow.md:118–124` ("Do NOT auto-modify `settings.json`"). Reversing a documented policy in a load-bearing command requires its own `/risk-check` — the plan acknowledges this at sequencing step 3.

**Track 3 #6 — narrow.** Header comments to two hooks (1 line each) + one note to `deploy-workflow.md`. Pure docs.

**Ordering hazard between Track 1 and Track 3 #6:** the plan sequences Track 1 first, then Track 3 #6 amends the same hook files (`coach-reminder.sh` and `improve-reminder.sh`). Track 3 #6 does NOT gate on Track 1 having shipped — both tracks touch the same files, but at orthogonal sites (settings.json registration vs hook file header). No content collision. However, if Track 1 is reverted later, Track 3 #6's header comments survive in the hook bodies — a small inconsistency but not a bug.

### Dimension 4: Reversibility
**Risk:** Medium

- **Track 1:** clean `git revert` on `ai-resources/.claude/settings.json`. Single-file JSON edit. Low.
- **Track 2 #7 (graduate save-session):** if the project copy is removed in favor of the canonical symlink, revert restores the project copy — clean. If the auto-sync hook has already resolved the symlink in a project, the symlink is recreated on next session — also clean. **However**, if the absolute-path bug is *not* fixed before graduation and the canonical `save-session.md` still has `/logs/scratchpads/{...}` (line 7), every project that runs `/save-session` after auto-sync will attempt to write to filesystem-root `/logs/scratchpads/` and fail. Revert returns to project-local copy but does not retract any artifacts created in `/logs/scratchpads/` (which would not exist anyway since writes would fail). Net: bug-fix prerequisite is critical; without it, graduation introduces a silent failure mode.
- **Track 2 #9 (rename qc-reviewer):** revert restores the old filename. Caller-side updates also revert. Clean.
- **Track 2 #11/#12 (extract to workspace CLAUDE.md):** clean revert at the file level. **However**, workspace CLAUDE.md is auto-loaded into every session — once it lands, Patrik and any session-running agents may begin acting on the new rules (e.g., Adaptive Thinking Override is a `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING=1` directive). Revert returns the rule but operator muscle-memory and any sessions that already adopted the env var setting will carry forward. Medium.
- **Track 2 #15:** project-local CLAUDE.md edit, clean revert.
- **Track 3 #5 Option A:** revert of `deploy-workflow.md` restores the manual-registration policy. **But** any deployed projects that have already had their `settings.json` auto-modified by Option A retain those modifications post-revert — git revert acts on the canonical file, not on already-modified deployed projects. Cleanup requires manual edit of each deployed project's `settings.json` to remove auto-merged entries. Medium-to-High depending on how many projects ran `/deploy-workflow` before revert. The plan does not specify a "dry-run mode" or "operator-confirm before write" beyond the existing Autonomy Rule #8 pause.
- **Track 3 #6 (docs):** clean revert. Low.

Net: Track 3 #5 Option A is the dominant reversibility hazard; everything else is clean or single-step.

### Dimension 5: Hidden Coupling
**Risk:** High (Track 3 #5 Option A) and Medium-High (Track 2 #11/#12 cross-CLAUDE.md content)

**Track 3 #5 Option A — multiple coupling concerns:**

- **Policy reversal at `deploy-workflow.md:118–124` is load-bearing.** The current explicit text "Do NOT auto-modify `settings.json` — hook registration requires knowing the matcher, event type, and timeout, which varies per hook" is a documented operator-facing safeguard. Option A reverses this without specifying how *future* hooks (which by definition have variable matchers) would be auto-registered safely. The deep-merge approach assumes canonical settings.json always carries the *intended* matcher/event/timeout for each hook — but Track 1 of this same plan exists *because the canonical settings.json had the wrong matcher*. Auto-merging the wrong matcher into deployed projects would have propagated the Track 1 bug to every deployed project that ran `/deploy-workflow` between commit `07cc6d6` and the Track 1 fix. The policy reversal therefore introduces a class of failure (canonical mistake → silent broadcast) that the manual-registration policy was specifically there to block.
- **Collision rule unsoundness (already grounded above).** `unique_by(.command)` on full-string command field will not dedupe `bash $CLAUDE_PROJECT_DIR/...` against `"$CLAUDE_PROJECT_DIR/..."` — the buy-side project will accumulate doubled hook registrations on each `/deploy-workflow` re-run. Not idempotent in practice despite the plan's claim.
- **Append-canonical-after-project ordering** is opaque to projects that have already designed their hook ordering around a specific sequence (e.g., `check-stop-reminders.sh` before nudges to keep reminder order stable). Auto-appending changes execution order silently.
- **`additionalDirectories` and other top-level keys** are not mentioned — Option A's deep-merge as specified (`.hooks` block only) is narrower than "deep-merge settings.json", but the plan text alternates between "deep-merge canonical hook entries" and "auto-merge canonical entries". Scope of the merge is ambiguous in the plan as written.

**Track 2 #7 — absolute-path bug as documented in the 2026-04-27 risk-check Mitigation #2.** The plan explicitly gates graduation on the bug being fixed first ("**Prerequisite:** confirm `save-session.md` absolute-path bug ... is resolved before graduating"). Per `ai-resources/.claude/commands/save-session.md:7` the path is **already** fixed to `logs/scratchpads/{YYYY-MM-DD}-...` (project-relative) — the canonical version is correct. The project-local copy at `projects/buy-side-service-plan/.claude/commands/save-session.md:7` still has the absolute-path bug `/logs/scratchpads/{...}`. So in fact the canonical (graduation target) is already correct; the prerequisite check should confirm this and the graduation is safe. This is a coupling concern only insofar as the plan reads as if the canonical needs the fix — verification reveals the canonical was fixed first. Low residual coupling.

**Track 2 #11/#12 — workspace CLAUDE.md cross-cutting addition:**

- Cross-Model Rules content at `projects/buy-side-service-plan/CLAUDE.md:25–30` references "Research Execution GPT" and "Stage 2/Stage 4" — vocabulary that is research-workflow-specific. Promoting this verbatim into workspace CLAUDE.md would inject research-workflow vocabulary into projects that are not research workflows (e.g., `corporate-identity`, `repo-documentation`). The promotion would either need to be paraphrased to be tool-generic, or it doesn't belong at workspace level. The plan does not specify how the promotion handles this.
- Adaptive Thinking Override at L45–48 sets `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING=1`. Workspace promotion makes this a global default. Operator may not have adopted it across all projects (e.g., lightweight projects may benefit from adaptive thinking). Coupling: the env-var setting affects every session, including ones the operator has not yet opted in.
- Workspace CLAUDE.md `## CLAUDE.md Scoping` (lines 138–147) explicitly states "Project-level CLAUDE.md is for cross-session project-specific rules only ... Do not put in project CLAUDE.md ... Canonical workspace rules". The dual question — what belongs in *workspace* CLAUDE.md — is implicit (cross-project rules). Track 2 #11/#12 fits the implicit answer only if the content actually applies cross-project. For Cross-Model Rules, that's questionable (research-workflow-specific vocabulary).

**Track 1 — minor coupling, well-managed:**

- The plan correctly identifies the wrapper-vs-individual-hook trade-off: "do not fold into the wrapper (`check-stop-reminders.sh` only handles innovation-registry + usage-log checks; folding adds invasive coupling)". Verified: `check-stop-reminders.sh:1–35` does not call coach/improve. Adding a *second* Stop entry alongside the existing one is the right pattern, as confirmed by the buy-side reference at `projects/buy-side-service-plan/.claude/settings.json:115–130`. No hidden coupling.
- Stacking three Stop hooks (existing `check-stop-reminders.sh` + new `coach + improve` pair) was flagged as a hidden-coupling concern in the 2026-04-27 risk-check (Mitigation #4: "disambiguate Stop-hook stacking ... add explicit ordering/dedup so the operator does not see three messages on session end"). The current plan replicates the buy-side ordering, which has been operating in production — but the plan does not explicitly address whether the operator's session-end UX is acceptable with three messages. Mitigation #4 from 2026-04-27 was applied (per the change-description note that #1–#4 were addressed), but the resolution is not visible in this plan's text. Suggest verifying #4 stayed addressed before landing Track 1.

**Track 1 vs Track 3 #6 ordering:** plan sequences Track 1 first, then Track 3 #6 amends the same two hook files. Track 3 #6 does not gate on Track 1 having shipped. Both touch orthogonal sites (settings.json registration vs hook header comment), so they don't collide functionally — however, if Track 1 ships and is later reverted while Track 3 #6 has also shipped, the hook files will retain a header comment about "Stop event" while the settings.json regression has put them back under PostToolUse. Inconsistency, not a bug.

## Mitigations

**For Track 3 #5 Option A (High blast radius + High hidden coupling):**

- **Honor the plan's existing `/risk-check` gate.** The plan already states at sequencing step 3: "If Option A: run `/risk-check` after drafting, before commit." This gate is the primary mitigation — do not waive it.
- **Fix the collision rule before any implementation.** Replace the `unique_by(.command)` dedup key with a normalized key — e.g., dedup on basename of the script path extracted from the command string, with hook-event + matcher as compound key. Verify against the actual buy-side project: re-running `/deploy-workflow` on `projects/buy-side-service-plan/` should produce zero duplicate registrations even though the canonical and project use different command-string prefixes.
- **Add a dry-run mode to the auto-merge step.** Operator confirms the merged JSON before write. The Autonomy Rule #8 pause is a good general protection but does not surface the diff — a dry-run that shows old vs new settings.json side-by-side gives the operator a chance to catch a propagated canonical-side error (e.g., an inverted-event-type bug analogous to Track 1's).
- **Re-verify the canonical settings.json is correct before each `/deploy-workflow`.** The Track 1 bug exists *because* canonical settings.json had the wrong event type. Auto-merge means a future canonical mistake auto-propagates. Add a verification step (perhaps part of the risk-check gate Option A already requires) that explicitly inspects the matcher/event-type/timeout values against intent before deploy.

**For Track 2 #11/#12 (Medium-to-High hidden coupling):**

- **Paraphrase or scope-narrow Cross-Model Rules before promotion.** Replace research-workflow-specific vocabulary ("Research Execution GPT", "Stage 2", "Stage 4") with tool-generic language ("evidence-producing CustomGPT", "research execution stage", "fact-checking stage") OR keep the rule project-local. Workspace CLAUDE.md must apply across non-research projects.
- **Operator opt-in for Adaptive Thinking Override.** Add a one-line conditional ("recommended for analytical/multi-step projects") rather than treating the env-var as a workspace default that loads on every session. Allows lightweight projects to skip the override.

**For Track 1 (residual minor coupling):**

- **Verify Stop-hook stacking order is deliberate before landing.** Re-read the 2026-04-27 risk-check Mitigation #4 closure note (or the relevant session note from `07cc6d6`); confirm the three-message-on-Stop UX was accepted. If unclear, run a manual session-end test in `buy-side-service-plan` first — the buy-side project already has the three-Stop layout in production and is the ground-truth reference.

**For Track 2 #9 (Bounded blast radius):**

- **Honor the plan's grep-sweep prerequisite.** Update the 3 wiring callers identified above (`shared-manifest.json:49`, `content-review.md:9`, `compile-wiki.md:59`) before removing the old filename. Documentation references in `context/` and `report/checkpoints/` are passive — leave them or update for clarity, but they are not blocking.

**For Track 2 #7 (Low residual coupling once verified):**

- **Verify the canonical save-session.md has the correct path before declaring graduation complete.** Per inspection, `ai-resources/.claude/commands/save-session.md:7` already uses the project-relative `logs/scratchpads/{...}` form — graduation is safe. The project-local copy at `projects/buy-side-service-plan/.claude/commands/save-session.md:7` still has the absolute-path bug. The graduation action retires the buggy project-local copy in favor of the correct canonical. State this explicitly in the commit so future readers see the bug-fix-first sequencing was honored.

## Recommended redesign

(Not required — verdict is PROCEED-WITH-CAUTION, not RECONSIDER. The mitigations above are sufficient.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references (`ai-resources/.claude/settings.json:60–71`, `:75–88`; `projects/buy-side-service-plan/.claude/settings.json:115–130`; `deploy-workflow.md:118–124`, `:92–101`; `coach-reminder.sh:7`; `improve-reminder.sh:8`; `save-session.md:7`; workspace `CLAUDE.md:138–147`); grep counts (3 wiring callers of `qc-reviewer` in buy-side-service-plan; 7 deployed-project settings.json files); verbatim quotes from CHANGE_DESCRIPTION and referenced files; cross-reference against the prior 2026-04-27 risk-check (Mitigations #2, #4 closure status). No training-data fallback was used.
