# Decision Journal

> Archive: [decisions-archive-2026-05.md](decisions-archive-2026-05.md)

## 2026-05-11 — Defer /new-project template rename: Input File Handling → File Write Discipline

**Context.** During Bundle 3 (CLAUDE.md fixes for three projects), the audits identified that the workspace canonical section name is `## File Write Discipline` (not `## Input File Handling`), and renamed the corresponding section in two projects (`axcion-ai-system-owner`, `repo-documentation`). The `/new-project` template emitter (`ai-resources/.claude/commands/new-project.md`) still emits `## Input File Handling` in 11 places and uses `grep -q '^## Input File Handling'` (line 480) as an idempotency probe. This creates a three-way naming state: workspace canonical = "File Write Discipline" / two project CLAUDE.md files = "File Write Discipline" / `/new-project` template = "Input File Handling".

**Decision.** Defer the `/new-project` template update. Captured under Bundle 3's risk-check mitigation option (b): bound Bundle 3 scope to project CLAUDE.md edits; do not touch `/new-project` template emission in the same session. The two affected projects carry an inline note explaining the intentional divergence.

**Rationale.** Bundle 3's mandate explicitly scoped to three CLAUDE.md files. Touching `/new-project` in the same session would have expanded scope to 11 occurrences across the template body, plus the idempotency grep, plus retesting the template emission flow — large enough to justify its own session. The deferred-update follow-up: when a future session edits `/new-project` for an unrelated reason, or is dedicated to template hygiene, align the section name then.

**Trigger for action.** Next `/new-project` template touch session OR next `/permission-sweep` template-class audit pass (whichever comes first). Update all 11 occurrences + the grep idempotency check + verify `/new-project` smoke-test still passes.

**Affected files for the future fix.**
- `ai-resources/.claude/commands/new-project.md` — lines 367, 388, 391, 402, 439, 450, 479, 480, 481, 483, 510
- After fix: the inline divergence note in `projects/repo-documentation/CLAUDE.md` § File Write Discipline can be removed.

**Alternatives considered.**
- *Apply the template update in this Bundle 3 session:* Rejected. Scope expansion (12+ extra targets, plus retest) exceeds the session mandate and the bundle's risk-check verdict explicitly chose option (b).
- *Leave the template inconsistent indefinitely:* Rejected. The divergence is documented in two places (this entry + inline CLAUDE.md note in `repo-documentation`) so the deferred work is discoverable.

---

## 2026-05-08 — Ship session-class classification as Step 1 only (defer downstream rules)

**Context.** Operator proposed a session-class declaration mechanism (design vs execution vs mixed) for `/session-plan` to fix asymmetric failure modes — design sessions accumulate rework when constraints surface late, execution sessions pass cleanly. Full proposal included a five-rule package (constraint-set, path verification, higher QC expectations, heavier risk-check bias for design; trust-the-plan, first-pass-clean, skip-constraint-set for execution). The operator's own writeup recommended a phased rollout: ship the classification prompt only, run for a week, layer rules after.

**Decision.** Implement only Step 1: the classification prompt in `/session-plan` plus persistence to `session-plan.md` and `session-notes.md`. Defer all downstream class-specific rules (constraint-set, path verification, frontmatter declarations on existing commands, QC-expectation adjustments) until after a one-week observation window.

**Rationale.** Cost of a five-rule package on day one: high — five rules to debug simultaneously if the classification itself turns out to be wrong. Cost of Step 1 alone: minimal — one prompt, two writes, fully reversible by editing one file. Observability gain: Step 1 produces the data (`Class:` lines in session-notes) that lets the operator and downstream coaching see whether the classification feels natural before committing to rule wiring. Matches the operator's stated preference (memory: prefers automated infrastructure that fires automatically over disciplines maintained by hand) but also matches the proposal's own "smallest first move" framing.

**Alternatives considered.**
- *Ship the full five-rule package now:* Rejected. Higher debugging surface, harder to roll back, and the proposal itself recommended phased rollout.
- *Add frontmatter class declarations to existing commands now (skip the prompt for known-class commands):* Deferred. The prompt is universal; frontmatter is an optimization that can land in week 2 once the classification taxonomy is validated.

---

## 2026-05-08 — Fading-gate detection: [FADING-GATE] items need no /friday-act intercept

**Context.** Implementing the gate-health monitoring feature (deferred from the autonomy-posture-change session). Original plan included a dedicated triage handler in `/friday-act` that would intercept `[FADING-GATE]` items and present the three remediation options (retire / lower-frequency / recalibrate) before writing to `improvement-log.md`. QC pass flagged the insertion point was underspecified — specifically, how `[FADING-GATE]` items would be excluded from the standard `f/d/s` prompt to avoid double-disposition.

**Decision.** No `/friday-act` change. `[FADING-GATE]` items are treated as standard medium-risk tactical follow-ups, flowing through the existing Step 3 `f/d/s` loop unchanged. When dispositioned `f`, Step 3.6 generates a plan file. The three-option pick (retire / lower-frequency / recalibrate) and the `improvement-log.md` write happen in the plan-file execution session, not during `/friday-act` triage.

**Rationale.** Reading `/friday-act` in full showed the Step 3 `f/d/s` loop already handles all tactical items generically — there is no per-tag dispatch, and none is needed. `[FADING-GATE]` items contain the three-option prompt in their text (`"Pick: retire / lower-frequency / recalibrate"`), which is visible in the plan file the execution session receives. Adding an intercept in `/friday-act` would require specifying which sub-step intercepts the item, how to exclude it from the standard prompt, and how to route the chosen disposition — all overhead that the existing plan-file pattern handles for free.

**Alternatives considered.**
- *New intercept in /friday-act Step 3:* Rejected. Adds control-flow complexity (intercept point, exclusion from f/d/s, inline improvement-log write) for no practical gain — the plan file is sufficient context for the execution session.
- *New sub-step in /friday-act Step 3.5 (SO-derived / journal-derived additions):* Rejected. Same overhead; [FADING-GATE] items are checkup-derived, not SO-derived.

---
- *Write only to `session-plan.md`, not `session-notes.md`:* Rejected. Downstream rules need a persistent grep target; session-plan.md is overwritten each session and can't carry historical signal.

## 2026-05-11 — Abandon /session-plan to recover from session-mandate drift

**Context.** Session started with operator intent: run /prime → /session-start → /monday-prep. During /session-start mandate confirmation, operator replied `c. Next /session-plan` meaning "confirm; next session will be /session-plan." Claude parsed `c.` as a correction to field c ("Done when") and silently baked /session-plan into the current session's mandate. Cadence ran through Phase D successfully, then /session-plan was invoked. Mid-/session-plan, operator detected the drift ("we have completely drifted off to something else") and halted execution.

**Decision.** Recovery option 1: abandon /session-plan for this session, log the two instruction gaps in friction-log, wrap normally. /monday-prep is the work; it is done.

**Rationale.** Three recovery options were considered: (1) abandon /session-plan, (2) write a session-plan.md scaffolded for a future session, (3) treat scratchpads-convention as legitimate work and execute now. Option 1 matches what the operator actually intended (/monday-prep was the session). Option 2 produces an artifact for a session we may not run with this framing. Option 3 doubles down on the drift. Option 1 also preserves the discovered instruction gaps as friction-log evidence for a separate fix-session.

**Alternatives considered.**
- *Continue /session-plan and execute the scratchpads-convention work:* Rejected. The work item is real but it was not the session's intent; conflating drifted-intent with operator-intent erodes the trust contract.
- *Continue /session-plan but stop after writing session-plan.md (Option 2):* Rejected. The session-plan file would describe a future session we may run with a different framing; better to write that file fresh when actually starting that work.
- *Roll back monday-prep commits and re-run:* Rejected. /monday-prep ran correctly through Phase D; the drift was only in the trailing /session-plan invocation, which produced no committed artifact.

## 2026-05-11 — Scratchpads gitignore convention

**Context:** /monday-prep surfaced that `logs/scratchpads/` was untracked with two stale files in the working tree. Decision: track or gitignore?

**Decision:** Gitignore. Added `logs/scratchpads/` to `.gitignore` and removed the two stale files from git index.

**Rationale:** Scratchpads are ephemeral session state — same lifecycle as `audits/working/` notes (already gitignored). Tracking them adds noise without value; gitignoring keeps the pattern consistent.

**Alternatives considered:** Track all scratchpads (rejected — ephemeral state does not belong in history); track selectively by naming convention (rejected — adds manual discipline overhead).

---

## 2026-05-11 — Settings items 5+6 deferred: scope expanded, redesign required

**Context:** Week mandate items 5+6 were a two-part fix (deploy-workflow.md jq snippet + permission-sweep-auditor template-class rule). /risk-check returned PROCEED-WITH-CAUTION with 4 required mitigations, and the proper scope expanded to 5 files (not 2) because the fix requires updating the canonical permission-template.md and the permission-sweep command as well.

**Decision:** Defer to dedicated session. Risk-check report is the execution brief.

**Rationale:** Applying the change without the mitigations would introduce a worse regression than the bug it fixes (over-stripping legitimate additionalDirectories entries). The proper 5-file scope + 4 mitigations is a self-contained unit of work — better done fresh than rushed at session end.

**Alternatives considered:** Apply items 5+6 anyway with partial mitigations (rejected — PROCEED-WITH-CAUTION verdict is binding until mitigations are confirmed applied).

## 2026-05-16 — Automate "git pull at session start" via /prime Step 0

**Context:** The "Pull the latest from GitHub at the start of each session" rule in ai-resources/CLAUDE.md was documentation, not automation. Operator was forgetting it in project sessions, risking stale code edits and stale skill definitions.

**Decision:** Add a new Step 0 to /prime that pulls the cwd repo and (when different) ai-resources, reporting results in the Prime brief. Also surfaces local unpushed commits to prevent the inverse failure mode (forgetting to push at session end).

**Rationale:** /prime is the canonical orientation entry point and is already run consistently — the gap was content, not adoption. A SessionStart hook would fire even on `/clear`-continuations and lack the repo-detection context /prime has. Pulling cwd + ai-resources together handles all three session contexts (project / workspace root / ai-resources) without per-project configuration. Unpushed-commits visibility addresses the operator's concern that git pull alone could let a forgotten push linger silently.

**Alternatives considered:** SessionStart hook running git pull (rejected — fires too broadly, lacks context, and /prime adoption was already consistent).

## 2026-05-16 — Skip permission-sweep H-1 and M-1 findings (deny-list conflict)

**Context.** `/permission-sweep --dry-run` returned 1 HIGH (`Bash(git push *)` allow→deny in workspace Layer B) and 1 MEDIUM (empty user-level deny list — canonical specifies `["Bash(rm -rf *)", "Bash(sudo *)"]`).

**Decision.** Both findings recorded as flagged-deferred in the consolidated report. Do not apply during `/friday-act`.

**Rationale.** Both findings recommend adding entries to a deny list. This conflicts with the stored operator policy (`feedback_zero_permission_prompts`): "never add to deny list; bypassPermissions floor + CLAUDE.md model-side rules is the agreed setup." Applying canonical-template values blindly would override a deliberate operator setup choice.

**Alternatives considered.**
- *Apply the canonical denies anyway:* Rejected — operator policy is explicit and recent.
- *Update the canonical template to reflect operator's chosen setup:* Out of scope for diagnostic-only session; logged as potential `/friday-act` candidate to align template with policy.

---

## 2026-05-16 — Extend model-default prohibition from settings.json to also cover CLAUDE.md

**Context.** Existing rule (2026-05-08, `feedback_no_model_in_settings_json`) prohibited declaring a `"model"` field in any `.claude/settings.json`. Operator now reports that declaring a default model in `CLAUDE.md` produces the same downstream effect: in-session `/model` switches don't take effect reliably. Operator directive: "remove the default model in settings.json or claude.md. Also note somewhere that model default IS NOT ALLOWED in settings.json or claude.md ANYWHERE in the workspace."

**Decision.** Extend the prohibition to cover both settings.json AND CLAUDE.md at every layer (user, workspace, ai-resources, project, vault). Per-command, per-agent, and per-skill `model:` YAML frontmatter remains the only permitted mechanism for declaring a tier outside the live session. Project-level `Model Selection` sections may describe *recommended posture* only (e.g., "lean Opus for plan drafting; Sonnet for routine edits") — never assert a default.

**Rationale.** Same root cause (operator cannot reliably override via `/model` when a default is declared upstream). Treating CLAUDE.md and settings.json identically under the rule eliminates the loophole and makes the prohibition memorable as a single line. Recommended-posture text preserved because operator wants project-specific tier guidance to remain accessible — just not asserted as a binding default.

**Alternatives considered.**
- *Delete project CLAUDE.md `Model Selection` sections entirely.* Rejected — operator directed removal of the *default*, not removal of guidance. Recommended-posture text is useful onboarding signal for project-tier judgment.
- *Restrict prohibition to settings.json only.* Rejected — operator directive explicitly named CLAUDE.md as a second affected layer.
- *Strip model frontmatter from commands/agents/skills as well.* Rejected — frontmatter is the operator's preferred declaration mechanism. Operator confirmed mid-session: "commands can have frontmatter… Yes, and its also allowed for skills."

---

## 2026-05-16 — Reject audit finding: hardcoded absolute paths in ai-resources Layer C settings.json

**Context.** Two `/audit-repo` runs flagged `Edit(/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/**)` and `Write(/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/**)` in `ai-resources/.claude/settings.json` as "hardcoded absolute paths — will break if workspace moves." The 2026-05-16 friday-act plan (ai-resources-maintenance #5) carried this as a Tier 2 fix item.

**Decision.** Reject the audit finding without action. The paths are intentional and canonical: they ARE the Layer C pattern documented in `ai-resources/docs/permission-template.md`. Do not change them.

**Rationale.** Claude Code permission pattern matching is literal — no env-var expansion, no relative-path resolution. The `Edit(/Users/.../...)` form is the only mechanism that covers sessions making absolute-path edits to cross-project files. Replacing with env-vars would silently break permission matching. Future audit runs that re-flag these paths should be dismissed using this entry as precedent. Note added to `permission-template.md` Layer C key assertions to suppress future re-flagging.

**Alternatives considered.**
- *Replace with env-var references:* Rejected. Claude Code permission engine does not expand env-vars inside pattern strings; substitution would silently break the permission grant.
- *Replace with relative paths:* Rejected. Permission patterns are evaluated against the file system at tool-call time; relative paths from the settings file's directory would not match absolute-path edits made by the session.

---

## 2026-05-16 — Defer SessionStart hook chain (journal-improvements #1) to dedicated design session

**Context.** Wave 4 of Tier 3 friday-act execution. Plan-item #1 (journal-improvements) asked for a SessionStart hook chain that auto-runs /session-plan → /qc-pass → /scope after the mandate is captured. Plan-time `/risk-check` returned PROCEED-WITH-CAUTION with 6 required mitigations: specify qc-pass handoff schema; declare authority between session-plan.md vs /scope output (functional overlap); paired doc updates to 4 files (prime.md, session-rituals.md, weekly-session-guide.md, operator-maintenance-cadence.md); reconcile with qc-independence.md (pause-on-findings vs non-blocking exception); reconsider opt-in vs opt-out semantics; add inline rationale at new Step 8 explaining the reversal of "do not auto-invoke /qc-pass automatically." Hidden-coupling dimension rated HIGH.

**Decision.** Defer the item to a dedicated design session. Commit the risk-check report (`audits/risk-checks/2026-05-16-session-start-auto-chain.md`) as the deferred-item record, but do not implement.

**Rationale.** Applying 6 mitigations across 4 paired doc files mid-session would compound scope creep on the already-heavy Wave 4. The session-plan's stop point ("if a wave's target file diverges materially from what the plan-file spec assumes: pause and reassess before editing") fits exactly: the plan-item asked for a "SessionStart hook" but Claude Code hooks (shell scripts on lifecycle events) cannot directly invoke slash commands — the implementation requires command-spec edits, not hook wiring. That divergence + the hidden-coupling rating + the 4 paired doc updates means the change is large enough to deserve its own scope, plan, and operator-visible decision on chain semantics (opt-in vs opt-out, blocking vs non-blocking on QC findings, authority between session-plan and /scope).

**Alternatives considered.**
- *Implement the command-spec-only path now, defer the paired docs:* Rejected — risk-check identified the paired-doc updates as a required mitigation, not optional. Landing the chain without the doc reconciliation creates drift between runtime behavior and documented behavior.
- *Implement the literal SessionStart hook (settings.json):* Rejected — Claude Code hooks fire on every session including ad-hoc sessions where the chain is unwanted. A blanket hook injects the chain instruction everywhere; the operator opt-out mechanism would need a separate marker file or env-var check inside the hook. Both add complexity without proportional benefit.
- *Skip the risk-check and ship:* Rejected — plan-item explicitly required risk-check, and the verdict's HIGH hidden-coupling rating is a real signal, not bureaucratic friction.

---

## 2026-05-16 — Retire nordic-pe-macro produce-* commands (option b, not restore context/)

**Context.** Friday-act 2026-05-16 plan item nordic-pe-macro #1 flagged the `context/` directory as missing — three command files (`produce-prose-draft.md`, `produce-architecture.md`, `produce-formatting.md`) reference `context/prose-quality-standards.md`, `context/content-architecture.md`, and `context/project-brief.md`. The plan offered two paths: (a) restore the files if prose production is still in scope, or (b) document in CLAUDE.md that the commands are retired. Operator decision required.

**Decision.** Path (b): retire the three commands by adding a "Retired Commands" section to project CLAUDE.md. Files left on disk for archival.

**Rationale.** Investigation showed the three commands reference a `parts/part-2-service/` and `parts/part-3-strategy/` document structure that does not exist anywhere in the project — only the three commands themselves reference those paths. The active prose workflow uses `report/chapters/1.1/` with the three-report + Implications Brief structure documented in the project plan. Most recent prose-work session (per `logs/session-notes.md`) edited 17 chapter files under `report/chapters/1.1/` — none of the produce-* commands were invoked. Conclusion: the produce-* commands are artifacts from a project shape that was planned at some point but never adopted.

**Alternatives considered.**
- *Restore the three context files:* Rejected. The directory structure they assume (`parts/part-2-service/`) does not exist; restoring them would not make the commands operational without also creating the parts/ structure, which the project plan does not call for.
- *Delete the three command files:* Rejected as too aggressive. Retirement-via-CLAUDE.md preserves them on disk for archival reference while clearly signaling "do not invoke."
- *Investigate whether parts/part-2-service/ is a planned-but-not-yet-built phase:* Considered. Read the active task plan v3 and research plan v3 — neither references Part 2/Part 3 service/strategy structure. Project plan is consistent with three-report + Brief end-state.

---

## 2026-05-16 — Drop friday-act plan item 5 as moot (target project does not exist)

**Context.** Friday-act 2026-05-16 plan item permission-sweep #2 (H-4) asked for `additionalDirectories` blocks to be added to two project settings.json files: `projects/nordic-pe-landscape-mapping-4-26/.claude/settings.json` and `projects/interpersonal-communication/.claude/settings.json`.

**Decision.** Drop the item without applying. Record in plan execution as superseded.

**Rationale.** On-disk verification: `projects/nordic-pe-landscape-mapping-4-26/` does not exist (likely deleted or renamed since the plan was generated). The second target (`projects/interpersonal-communication/.claude/settings.json`) already contains `additionalDirectories: ["/Users/patrik.lindeberg/Claude Code/Axcion AI Repo"]`. The current `/permission-sweep` report itself (`audits/permission-sweep-2026-05-16.md`) confirms: "Rule 8 (missing or stale additionalDirectories in project files): All Layer D files contain `additionalDirectories: [...]`. No violations." Both ends of the plan item are already resolved by other means.

**Alternatives considered.**
- *Apply the change to interpersonal-communication anyway:* Rejected — the canonical value is already present; applying it would be a no-op edit.
- *Search for a renamed version of nordic-pe-landscape-mapping-4-26:* Considered briefly. The only matching project is `nordic-pe-macro-landscape-H1-2026`, which has its own settings.json with the canonical block already. No drift to remediate.

---

## 2026-05-16 — Skip end-time /risk-check per operator memory rule

**Context.** Session executed two in-class structural changes (both edits to `projects/nordic-pe-macro-landscape-H1-2026/CLAUDE.md`: Retired Commands section + Command Conventions section). Per `ai-resources/docs/audit-discipline.md` § When to fire, the two-gate model nominally requires an end-time `/risk-check` batched across in-class changes.

**Decision.** Skip the end-time gate. Document the skip in this entry and in the session-notes wrap.

**Rationale.** Per operator memory `feedback_end_time_risk_check_skip`: skip when plan-time covered with mitigations applied AND commits already shipped AND drift bounded. All three conditions met. (a) Plan-time gate: item 3 received explicit `/risk-check` (verdict GO, all five dimensions Low, no mitigations required); item 1 was plan-classified `Risk-check required: no` by the friday-act plan author and the change was a doc-only retirement note. (b) Commits shipped: both edits committed during execution (`ed91e61`, `20fa6fc` in the nordic-pe-macro repo). (c) Drift bounded: both edits land exactly the content planned — no scope creep, no behavior changes, no new automation. The end-time gate's value is catching drift and emergent coupling; with zero of either, the gate produces no signal.

**Alternatives considered.**
- *Run the end-time gate anyway:* Rejected. The memory rule exists precisely to suppress ceremonial gate-firing on bounded doc-only changes. Running it would consume an additional subagent invocation without producing useful risk signal.

---

## 2026-05-16 — Apply quick-tier 2nd-QC skip on /cleanup-worktree plan

**Context.** `/cleanup-worktree` over ai-resources working tree. Plan classified 7 untracked audit/report artifacts as decision-1 (`commit`); zero hard gates. 1st QC pass returned MINOR-ONLY (2 nits: line-count value error + transparent phrasing note). Triage classified MINOR-1 as must-fix value substitution and MINOR-2 as history-only no-edit. After revision applying MINOR-1, the quick-tier 2nd-QC skip rule from `ai-resources/skills/worktree-cleanup-investigator/references/execution-protocol.md` § 6 became eligible.

**Decision.** Skip the 2nd QC pass per the quick-tier rule. Surface to operator verbatim per `cleanup-worktree.md` Step 9: "2nd QC skipped per quick-tier rule — zero hard gates, zero new file-content claims in revision." Then proceed to `ExitPlanMode`.

**Rationale.** Both preconditions verified satisfied: (a) Section 4 hard-gate count = 0 — every dirty path is decision-1; no destructive operations exist; (b) revision Section 8 introduced 0 new file-content claims — MINOR-1 was a value substitution of an existing claim (line count for the same file already present in the pre-revision plan), MINOR-2 had no edit. The two failure surfaces the 2nd QC exists to catch (under-specified hard-gate abort scope, fabricated revision claims) are both absent. The skip is the rule's intended application — calibrated exemption, not a weakening. Triage subagent explicitly confirmed eligibility was preserved by the MINOR-1 framing.

**Alternatives considered.**
- *Run the 2nd QC anyway:* Rejected. The quick-tier rule is a load-bearing optimization; defaulting to "run anyway" defeats its purpose and adds ~30s of subagent latency on every cleanup with trivial revisions. The skip is logged and operator-notified — auditability is preserved.
- *Adopt MINOR-2's optional rewording to "1 underlying critical issue counted across 3 areas":* Rejected. Per triage, adopting it would introduce a new characterization absent from the pre-revision plan, technically forfeiting quick-tier eligibility. The original phrasing already mirrors the prev report's own header normalization at line 25 — no fabrication, no precision loss worth the eligibility cost.

---

## 2026-05-16 — Skip find-template.sh for /cleanup-worktree paths in audits/ and reports/

**Context.** `/cleanup-worktree` bias counter 2 (`SKILL.md` lines 128–134) mandates running `scripts/find-template.sh` for any path that could plausibly have a canonical template elsewhere in ai-resources. The command spec at `cleanup-worktree.md` Step 4 step 10 enumerates trigger categories: `.claude/commands/*.md`, `.claude/agents/*.md`, `.claude/hooks/*`, plus paths mirroring `skills/`, `prompts/`, `workflows/`, `scripts/`, `docs/`. The 7 dirty paths this session lived in `audits/risk-checks/` and `reports/` — neither in the explicit trigger list.

**Decision.** Skip `find-template.sh` for all 7 paths. Document the skip as Bias Counter 2 in plan Section 7 with explicit zero-list and justification, so the audit trail is clear.

**Rationale.** `audits/risk-checks/` and `reports/` are append-only working-state directories — per-instance records of changes/audits, intrinsically unique-by-timestamp, not templated content categories. Running the script on these paths would return `NO_TEMPLATE_FOUND` for all 7 files and add zero signal. The bias counter exists specifically because text-only "check both X and Y" instructions failed in the originating session for paths that DO have templated equivalents (`.claude/commands/*.md`). It is calibrated to that risk surface, not blanket "run on every dirty path." Documenting the skip in Section 7 with explicit reasoning maintains the audit-trail property the counter creates.

**Alternatives considered.**
- *Run find-template.sh on all 7 paths anyway:* Rejected. The script would return `NO_TEMPLATE_FOUND` (the script walks ai-resources subdirectories looking for files of matching basename and category; uniquely-named timestamped audit artifacts have no plausible match). Running it would be ceremonial — adds tool calls without producing signal — and would weaken the counter's selectivity over time (audits that fire on irrelevant paths get tuned out).
- *Run it on one representative path as a sanity demonstration:* Rejected. The same logic applies: would return `NO_TEMPLATE_FOUND`, adds no signal. The plan's explicit zero-list with justification is a stronger audit artifact than a single demonstrative run.


## 2026-05-18 — B8 line-count threshold produces false positives; split-log.sh uses entry count

**Context.** Monday-prep B8 check flagged 6 files as over-threshold (>200 lines): `global-macro-analysis/logs/session-notes.md` (447), `nordic-pe-macro/logs/session-notes.md` (411), `nordic-pe-macro/logs/friction-log.md` (612), `project-planning/logs/session-notes.md` (263), `repo-documentation/logs/session-notes.md` (419), `ai-resources/logs/maintenance-observations.md` (232). All were listed as W21 item 5 "manual archive batch." During /log-sweep, none were archived.

**Decision.** Treat B8 flags as informational rather than actionable when files are under the split-log.sh entry-count threshold. No archival applied.

**Rationale.** `split-log.sh` counts `## ` header entry blocks (not total lines) and exits 0 if total entries ≤ KEEP (10). The flagged files have ≤10 dated `## ` entries — long because individual entries are detailed prose, not because there are many of them. Archiving would remove substantive recent content, not trim stale old entries. The B8 >200-line threshold in monday-prep is a useful rough signal but is not the same as the tool's actual trigger condition.

**Alternatives considered.**
- *Manually trim prose within entries:* Valid for files that feel unwieldy; leave to operator judgment rather than automated archival.
- *Update B8 to count `## ` entries instead of lines:* Preferred direction. Open question logged in session-notes.

## 2026-05-18 — Log-sweep auditor misclassifies 2 file types as Cat A2

**Context.** /log-sweep run 2026-05-18 across 10 scopes. Auditor returned 3 Cat A2 over-threshold files. Two were false positives.

**Decision.** Skip both false positives. Apply split-log.sh only to the 1 genuine over-threshold file (`global-macro-analysis/macro-kb/_meta/changelog.md`).

**Rationale.** (a) `nordic-pe-macro/logs/session-notes-archive-2026-05.md`: an archive file matching the `*-archive-*.md` exclusion pattern in the /log-sweep Step 16 `find` prune. The auditor subagent's internal discovery did not respect this exclusion — applying split-log.sh to an archive would create a nested archive. (b) `global-macro-analysis/pipeline/source-docs/operations-manual-v1.3.md`: a documentation file with section headers (`## 1. Three Input Lanes`), not a dated log with `## YYYY-MM-DD` entries. The auditor's Cat A2 classification heuristic does not distinguish section headers from date headers.

**Alternatives considered.**
- *Apply split-log.sh to both and let it handle gracefully:* Rejected. For (a), split-log.sh has no archive-file guard — it would re-archive an archive. For (b), it would split documentation at arbitrary section boundaries, corrupting the file structure.
- *File a bug / improvement against the auditor:* Valid. The archive-file exclusion gap and the section-vs-dated-header distinction are both worth fixing in a future /improve-skill session.

## 2026-05-18 — F2 default: keep current plan (not pass2) on no response

**Context.** /session-plan F2 implementation. Original improvement-log proposal specified "default on no response = option 3 (pass2)." Risk-check pass A raised M4: a non-responsive operator more likely wants to preserve the existing plan than create a silent fork file.

**Decision.** Changed F2 default to option 1 (keep current plan). Operator sees the prompt; silence = keep.

**Rationale.** Pass2 is the right escape hatch when the operator wants both the old and new plan, but it's an active choice, not a safe default. Silent forking on timeout would create files that persist beyond the session and might confuse future /open-items scans.

**Alternatives considered.**
- *Keep option 3 as default:* Rejected. Surprising behavior; creates persistent artifacts silently.
- *No default (require explicit choice):* Rejected. Blocking the session on no response is worse than a safe fallback.

---

## 2026-05-18 — F4 added to risk-check pass B (audit-discipline conflict resolved)

**Context.** Session plan initially classified F4 (new project-local hook + settings.json wiring) as not requiring /risk-check. QC pass surfaced conflict: `audit-discipline.md` bright-line lists hook edits and settings.json edits as required risk-check change classes.

**Decision.** Extended pass B to cover F4 alongside F5. No operator carve-out invoked.

**Rationale.** Per CLAUDE.md conflict rule: "conflicts must be surfaced, not silently resolved." The operator directive (F4 = low risk, no gate) was overridden by audit-discipline's bright-line. The correct resolution is to apply the gate. Risk-check confirmed PROCEED-WITH-CAUTION with 3 mitigations (one of which — M3 — corrected a misunderstanding about how Claude Code hook matchers work).

**Alternatives considered.**
- *Honor operator directive, skip gate:* Rejected. Bright-line rule exists precisely to catch project-local hook additions that seem low-risk but have blast-radius effects.

## 2026-05-22 — /handoff architecture and automation path

**Context.** Designing the `/handoff` skill — unified session-state command replacing `/save-session` — and deciding on automation strategy.

**Decision 1: Command → skill, no subagent.**
Subagent-based architecture was proposed (Plan agent) but rejected. A subagent starts with no session context, making it incapable of compressing the current session's conversation into a scratchpad. The skill must run in the main session. System Owner ruled: command shape per `repo-architecture.md` Q2/Q3.

**Decision 2: Unified two-mode design (no-args continuity, with-args fork).**
Rather than two separate commands (`/save-session` for continuity, new `/handoff` for forking), one unified command with mode driven by args presence. Simplifies operator mental model: one command for all "compress context for another session" needs. Output location follows from mode: no-args → `logs/scratchpads/` (persistent); with-args → `/tmp/` (ephemeral).

**Decision 3: Automation via /wrap-session + /prime integration, SessionStop hook deferred.**
Hooks are shell scripts — cannot generate AI-produced scratchpad content. The right automation is: (a) add `/handoff` (no args) as Step 0.5 in `/wrap-session` (planned exits), (b) add scratchpad detection to `/prime` to close the loop at session start. SessionStop hook for unplanned exits deferred until observed as recurring friction. System Owner ruling: unplanned-exit gap is deliberately left open, not an oversight.

**Alternatives considered.**
- *SessionStop hook (Option B):* Not buildable for full scratchpad — hooks are shell scripts, no Claude reasoning. A minimal marker file is possible but lower-value; deferred.
- *`/clear` interception (Option C):* Dead — `/clear` is a slash command, PreToolUse hooks don't fire on slash commands.
- *PostToolUse compaction hook (Option D):* Redundant — `[COST]` flag already covers this. A hook would add noise mid-work.

## 2026-05-22 — grill-me scope: single skill, no docs-layer variant

**Context.** Evaluating whether to build `grill-me` (plain interview) or `grill-with-docs` (interview + shared vocabulary layer via context.md + ADRs).

**Decision.** Build `grill-me` only. Defer `grill-with-docs` until the plain version is validated in practice.

**Rationale.** The docs layer requires maintaining a `context.md` glossary across sessions — infrastructure that doesn't exist yet. Running plain grilling first surfaces whether vocabulary gaps are actually painful before investing in the maintenance overhead. Don't build infrastructure for a problem not yet confirmed.

**Alternatives considered.**
- *Build both as sibling skills:* Rejected — doubles the surface area before either has been validated.
- *Build one skill with auto-detection (docs-layer if context.md exists):* Rejected — adds complexity to a skill whose value is its simplicity.

---

## 2026-05-22 — grill-me integration: command level, not SKILL.md bodies

**Context.** Deciding where to add the /grill-me pointer in the project planning and skill creation workflows.

**Decision.** Add pointer to the command pipeline files (`/context-builder`, `/create-skill` Step 1), not to the SKILL.md bodies.

**Rationale.** SKILL.md bodies define skill behavior; command files define invocation flow. A pointer to a prior step belongs in the command, not the skill — it's orchestration logic, not skill logic. Adding it to SKILL.md would blur the separation and load the pointer into every context where the skill is referenced, not just the invocation context.

**Alternatives considered.**
- *Pointer in SKILL.md:* Rejected — wrong layer; skill methodology vs. command orchestration.
- *Pointer in CLAUDE.md:* Rejected — CLAUDE.md is for cross-session rules, not workflow reminders.

## 2026-05-22 — Risk-check change-class scope: command-file edits and agent-definition edits

**Context.** `/friday-act` Step 15a annotates each fix-now plan item with whether it touches a `/risk-check` change class. The initial annotations marked 4 items `yes`: editing the project-local `session-plan.md`, editing the `log-sweep-auditor` agent definition, and editing `new-project.md` and `risk-check.md`. The `/friday-journal` report itself had asserted "deterministic match: command edit" for the two command edits. An independent `/qc-pass` flagged all 4 as incorrect.

**Decision.** Corrected all 4 to `no`. The canonical change-class list in `audit-discipline.md` § Risk-check change classes is: hook edits, `settings.json` permission changes, cross-cutting CLAUDE.md edits, **new** commands or skills, new symlinks, shared-state automation. Editing an **existing** command file is not "new commands or skills." Agent-definition edits are not on the list at all.

**Rationale.** The canonical list is the bright-line authority; `/friday-act` Step 15a re-derives the change class rather than inheriting upstream claims — the journal report's "command edit" assertion was not backed by the list, and propagating it was the error. Per the CLAUDE.md conflict rule, the agent-definition case was surfaced rather than silently resolved: the canonical list omits agent definitions, but improvement-log entry 2026-04-28 (status `logged (pending)`, unratified) argues agent-definition edits are Autonomy Rule #9 changes. `log-sweep.md` #1 was left `no` per the current canonical text, with the question surfaced to the operator as an open question.

**Alternatives considered.**
- *Keep all 4 as `yes` (extra gate is harmless):* Rejected. The annotation should reflect the canonical spec; over-gating trains operators to ignore the gate.
- *Flip the 3 command edits but silently keep the agent-def edit `yes`:* Rejected — that silently resolves the conflict. Surfaced it to the operator instead.

## 2026-05-22 — Placement of four governance rules in workspace CLAUDE.md

**Context.** Operator proposed five governance rules (item 4 was a session directive, not a rule) and asked where each should live — project-specific CLAUDE.md or workspace-wide. Three proposed new section headers (`## Quality Control`, `## Workflow / Approval Gates`, `## Session Management`) overlapped existing sections, and two rules conflicted with existing content. Resolved via `/clarify` → `/recommend`.

**Decision.** All four rules go to the workspace-level CLAUDE.md, each folded into the closest existing section rather than added as new parallel sections: QC trigger → `## QC Independence Rule`; post-plan approval gate → `## Plan Mode Discipline`; context-constraint deferral → `## Working Principles`; repo-status verification → new `### Repo-status reporting` subsection under `## File verification and git commits`. Item 2 scoped to plan-mode only. Item 3 reframed as a heuristic (literal `~30%` / `ExitPlanMode` dropped per operator).

**Rationale.** The rules are cross-project governance, so workspace-level per the CLAUDE.md Scoping rule. Folding into existing sections avoids token bloat in an already-large always-loaded file and removes the contradiction surface that parallel sections would create. Item 2 scoped narrowly because a global "wait for explicit approval" rule would contradict the Autonomy Rules and Decision-Point Posture; the plan-mode scoping reinforces existing behavior without overriding autonomy. `/qc-pass` confirmed GO with no conflicts.

**Alternatives considered.**
- *Create the three new sections as the operator named them:* Rejected — duplicates existing QC / plan-mode / session sections and adds always-loaded token weight.
- *Apply item 2 globally:* Rejected — contradicts the Autonomy Rules ("full autonomy") and Decision-Point Posture ("pick and proceed").
- *Keep literal `~30%` threshold:* Rejected by operator — not reliably self-measurable; kept as a heuristic instead.
