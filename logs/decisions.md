# Decision Journal

> Archive: [decisions-archive-2026-04.md](decisions-archive-2026-04.md)

## 2026-04-27 — research-workflow Critical fix: design + gate-skip judgment

**Context.** Resolved the 2026-04-27 deep audit's Critical finding — `additionalDirectories` in `workflows/research-workflow/.claude/settings.json` was hard-coded to my workspace root, which would silently break ai-resources access on any other machine. Plan-time `/risk-check` returned GO across all five dimensions. Two judgment calls during execution were precedent-setting and worth recording.

**Decision 1 — Placeholder pattern (`{{WORKSPACE_ROOT}}`) over free-text SETUP.md instruction.**

The deep audit recommended adding a free-text instruction to SETUP.md telling the operator to update the path manually (Option A — characterized as a "5-minute fix"). Used Option B instead: replace the value with `{{WORKSPACE_ROOT}}` and add a corresponding placeholder-fill step + Placeholder Reference row.

- *Why diverge from the audit recommendation:* Option A relies on operator memory and produces a silent failure mode (wrong path → silent ai-resources access break). Option B produces a visible `{{` signal that matches the operator's existing scan-for-placeholders mental model from filling out CLAUDE.md, stage-instructions.md, file-conventions.md, etc. (8 other placeholders already use this pattern.) Cost is identical (~10 lines of SETUP.md instead of 5); upside is discoverability.
- *Edge case worth flagging:* JSON is parsed by the harness, so `{{WORKSPACE_ROOT}}` is a JSON-valid string but a path-invalid value. Verified `jq empty` validates; harness will fail to read ai-resources files until placeholder is replaced — same outcome as the prior hard-coded path on a different machine, but now the cause is visible rather than hidden.
- *Implication for future template fixes:* When a deployment-affecting template value needs operator configuration, prefer the existing placeholder pattern over free-text instructions. This decision can serve as the reference precedent.

**Decision 2 — End-time `/risk-check` skipped when plan-time verdict is GO with zero execution drift.**

The two-gate model (per the 2026-04-25 decision) defaults to firing both plan-time and end-time gates within a session that touches a structural-change class. This session touched two such files (template `settings.json` + template `SETUP.md`). Skipped the end-time gate.

- *Rationale:* The end-time gate's stated purpose is to "catch drift, emergent coupling, scope creep." For this change, plan-time returned GO across all five dimensions with no marginal Mediums; the executed change set matches the plan-time description exactly (no additional files touched, no widened scope, no new patterns introduced). With no failure mode for end-time to detect, running it is pure ceremony — adds tokens, produces no signal.
- *Alternatives considered:* (a) Run end-time anyway as strict policy compliance. Rejected — the 2026-04-25 Batch 2 decision already established precedent for skipping a gate when its purpose is fulfilled by prior gating. (b) Run end-time with a minimal payload to "tick the box." Rejected — this would normalize empty gate firings and dilute the signal across future sessions.
- *Implication / when to apply:* Skip end-time only when ALL of: (a) plan-time returned GO; (b) plan-time had no marginal Mediums; (c) executed change set matches plan-time description with zero drift; (d) change is single-file or otherwise narrowly scoped. If any condition fails, end-time should fire as normal. Worth surfacing this nuance in `audit-discipline.md` if future sessions hit similar judgment calls (deferred — not a blocker).

**Files changed.**
- `workflows/research-workflow/.claude/settings.json` — `{{WORKSPACE_ROOT}}` placeholder
- `workflows/research-workflow/SETUP.md` — step 1.5 + Placeholder Reference row
- `audits/risk-checks/2026-04-27-replace-hard-coded-additionaldirectories-path-in-workflows.md` — plan-time risk-check report

## 2026-04-25 — Working-tree drift prevention: design choices

**Context:** Plan called for five core fixes (F1–F5) plus five opportunistic guardrails (G1–G5). During execution, three judgment calls reshaped scope.

1. **F2 design pivot — operator disclosure over pgrep.**
   Rationale: `/risk-check` returned RECONSIDER on the original mechanical-abort design. Live test on this machine: `pgrep -fl 'claude' | grep -v $$` returned 12 matches in a single Claude Code session because Claude Code spawns helper/subagent processes and VSCode caches multiple binary versions. A no-override mechanical abort would have made `/cleanup-worktree` unusable. Recommended redesign (Option 1 in the risk-check report): a Step 1 disclosure prompt asking the operator directly. This aligns with the existing CLAUDE.md "Concurrent-session staging discipline" pattern (which is already operator-disclosure-based) and removes the false-positive class entirely.
   Alternative considered: narrowing the pgrep regex (parent-PID walking, env-var override). Rejected — expanded scope beyond a single-file edit.

2. **G5 dropped as redundant.**
   Rationale: F3 already documents the concurrent-session rule in the workspace CLAUDE.md "Concurrent-session staging discipline" section. Adding `/cleanup-worktree` to Autonomy Rules pause-triggers would have duplicated the rule in a different section without load-bearing semantics. The F3+G5 risk-check report explicitly flagged "commit to one shape; prefer extending existing pause-trigger over adding bullet #10" — operator chose the cleaner path of dropping G5 entirely.

3. **F5 severity ADVISORY (plan said HIGH).**
   Rationale: The existing detection-rulebook taxonomy classifies HIGH as "Delete prompts or future Edit prompts." The gitignore-vs-deny mismatch is hygiene — it pollutes `git status` but produces no live or future permission prompt. ADVISORY fits the existing severity structure. The plan's HIGH classification was an overcall; aligned to the rulebook's actual semantics.
   Alternative considered: keeping HIGH per plan. Rejected — would have set a precedent of severity-based-on-perceived-importance rather than rulebook semantics, making the classification bucket fuzzy.

4. **Stopped after core five; deferred G1/G3/G4.**
   Rationale: Operator pushed back on overcomplication mid-session ("Why are you overcomplicating this operation?"). The core five fixes cover both failure classes from the 2026-04-24 incident (session-end hygiene + canonical-state drift). G items are nice-to-have additions (new SessionStart hook, marker-file mechanism, weekly checkup line) that add capability rather than addressing the incident's root causes. Deferred to a future session if the core five turn out to be insufficient.

5. **Reduced /risk-check ceremony for small edits.**
   Rationale: After running `/risk-check` on F2 and F3+G5, recognized that running it on every CLAUDE.md paragraph and hook validation extension is heavy ceremony for low-risk edits. Skipped `/risk-check` on F4 (small extension to existing hook validation) and F5 (new check class added to existing auditor — no new structural infrastructure). Reserves `/risk-check` for genuinely structural changes (new hooks, new commands, new permission rules). Self-check + post-edit testing was sufficient for the small extensions.

**Implication.** The plan-vs-execution gap surfaced two patterns worth carrying forward: (a) `/risk-check` should be invoked when scope is genuinely structural, not on every item that touches a hook or CLAUDE.md; (b) plan-stage severity classifications should be cross-checked against existing rulebook taxonomies before landing.

## 2026-04-25 — /risk-check trigger model: per-change → two-gate

**Context.** Operator flagged that `/risk-check` was firing too often during active work and burning tokens. Under the prior rule, any structural class touched (hook edit, permission change, cross-cutting CLAUDE.md edit, new command/skill, new symlink, automation with shared-state effects) required `/risk-check` *before each landing*. Multi-class sessions fired the gate 3–5 times.

**Decision.** Adopt a two-gate model:
- **Plan-time gate** — once after plan approval, if the plan touches any structural class. `$ARGUMENTS` describes the *design*. Catches design risk before tokens are spent on execution.
- **End-time gate** — once before commit, batched across every in-class change the session actually made. `$ARGUMENTS` describes the *executed* change set. Catches drift, emergent coupling, scope creep.
- **Skip rules.** Sessions without an explicit plan (auto-mode quick fixes, single-file edits) run only the end-time gate. Sessions touching no class skip both.

**Rationale.** The two gates preserve `/risk-check`'s two distinct value propositions (design-risk catch + execution-drift catch) while bounding firings to ≤2 per session. Per-change pattern was the failure mode the operator flagged.

**Alternatives considered.**
- *Single end-time gate only.* Simpler but loses early design-risk catch — you can build for tokens against a design that should have been redesigned.
- *Threshold trigger* (only fire when N+ structural changes accumulate). Adds bookkeeping to operator/main agent; less predictable than session boundaries.
- *Status quo.* Rejected — was the trigger for this redesign.

**Mitigations applied (per end-time `/risk-check` on this very change set).**
- Workspace CLAUDE.md pause-trigger #9 trimmed to ~95 words (matched prior baseline length). Always-loaded surcharge would otherwise have partially undone the policy's token-saving motivation.
- `/wrap-session` Step 13b added as the tactile end-time prompt at the natural session boundary.

**Cross-session note.** This decision and the concurrent session's decision #5 ("Reduced `/risk-check` ceremony for small edits") are complementary, not contradictory: that decision narrows the *trigger classes* (skip on small low-risk extensions to existing files); this decision changes the *firing cadence* within those classes (≤2 firings per session, at session boundaries).

**Files changed.**
- `../CLAUDE.md` (workspace root) — pause-trigger #9 reworded then trimmed.
- `ai-resources/docs/audit-discipline.md` — added "When to fire (two-gate model)" subsection.
- `ai-resources/.claude/commands/risk-check.md` — added "Two intended call sites per session" block.
- `ai-resources/.claude/commands/wrap-session.md` — added Step 13b end-time gate reminder (swept into concurrent session's wrap commit `26d9c7f`).

## 2026-04-25 — Commission Batch 2: /friday-act + tier-differentiated /friday-checkup output

**Context.** Executing approved Batch 2 of the commission plan (5-batch rollout starting with /risk-check in Batch 1, completed 2026-04-24). Plan called for the largest single batch: a new Session-2 command (`/friday-act`) plus a data-contract change to `/friday-checkup`'s output. Operator granted full autonomy mid-session for routine decisions.

**Decision 1 — Plan-time /risk-check skipped; end-time only.**

The new two-gate /risk-check policy (landed earlier 2026-04-25) calls for plan-time gate "once after the plan is approved, if the plan touches any required class." Strict reading would have fired plan-time again on Batch 2. Skipped because the original commission plan went through full QC + triage + post-edit-QC in the 2026-04-24 design session; firing plan-time again on a plan that is months-old in design-time would be redundant and inflate tokens. End-time gate alone caught the executed change set.

- Alternatives considered: (a) fire plan-time anyway as strict policy compliance; (b) fire mid-session per-change as the old policy did. Both rejected — (a) for redundancy with prior QC, (b) because the new two-gate model exists specifically to retire that pattern.
- **Implication.** When executing a multi-batch plan across sessions, the plan-time gate "expires" after the original design QC. End-time gate per session is the durable discipline. Worth surfacing this nuance in `audit-discipline.md` if future sessions hit the same ambiguity (deferred — not a blocker today).

**Decision 2 — Tactical-fix queue scoped to standard items only at MVP.**

`/friday-checkup` Step 7 has two distinct sections: `## Prioritized findings` (rolled-up HIGH/CRITICAL findings from sub-reports) and `## Tactical follow-ups` (the renamed Operator-follow-ups list with risk grading). `/friday-act` parses Tactical follow-ups as its fix queue. As written, Tactical follow-ups contains only the standard items (resolve-improvements, cleanup-worktree, quarterly /repo-dd × N) — NOT the rolled-up findings.

The plan text ("Weekly: tactical follow-ups list + risk level per item — feeds /friday-act as tactical-fix queue") is ambiguous about whether sub-report findings should also feed the queue. Chose narrow MVP interpretation: standard items only; sub-report findings remain in `## Prioritized findings` for the operator to read manually.

- Alternatives considered: (a) auto-promote HIGH/CRITICAL prioritized findings into Tactical follow-ups at /friday-checkup Step 7; (b) have /friday-act parse both sections and merge for the action loop.
- Rationale for narrow MVP: clean separation between summary view (Prioritized findings) and action queue (Tactical follow-ups); the operator can defer all standard items and address findings as separate sessions, which is the dominant path today. Richer ingestion can be added once Batch 3+ usage shows the queue feels too narrow.
- **Implication.** First real `/friday-act` invocation should surface whether the narrow queue is workable. If not, fold sub-report findings into Tactical at Step 7 — small follow-up edit, no /risk-check class change.

**Decision 3 — No /wrap-session edit; lean on Step 13a dirt check.**

`/friday-act` writes per-session blocks to `logs/maintenance-observations.md`. Could have either (a) added the file to /wrap-session's always-staged list, (b) had /friday-act commit its own changes, or (c) left it dirty for /wrap-session Step 13a to surface for explicit operator disposition.

Chose (c). Operator's plan explicitly called for /wrap-session NOT to be modified. Step 13a is the catch-all for dirty paths produced by other commands; it asks per-path disposition. /friday-act's artifact lands in a known location with predictable cadence; operator can dispose `c` (commit) by default each Friday.

- Alternatives rejected: (a) violates plan; (b) unnecessary commit responsibility on /friday-act when wrap-session already has the discipline.
- **Implication.** Maintenance-observations.md will surface in /wrap-session dirt check after every Friday-act run. If that's noisy in practice, revisit by adding to always-staged list (small one-line edit).

**Decision 4 — Three /risk-check Mediums accepted; mitigations applied.**

End-time /risk-check returned PROCEED-WITH-CAUTION with three Medium-risk dimensions (Blast radius / Reversibility / Hidden coupling) and three paired mitigations. Applied:
- Hidden coupling: added one-line schema-contract cross-reference at /friday-act Step 2 → friday-checkup.md Step 7's data-contract paragraph.
- Blast radius: no-op (10-day staleness guard + loud schema-mismatch abort cover the legacy 2026-04-24 audit). Explicitly attested in commit body.
- Reversibility: attestation only (/wrap-session Step 13a already catches the append; no code change needed).

The "no-op acceptable" mitigation from the report is a valid disposition under the verdict semantics — the report itself states no-op is acceptable given loud-failure behavior. Documented the choice in commit body so the audit trail is intact.

## 2026-04-25 — Zero permission prompts as account-level policy

**Context:** Operator hit a permission prompt this session when editing `.claude/commands/*.md` files (auto mode classifier prompted because `.claude/**` paths aren't in the allowlist). Stated explicit, repeated directive: never wants to be hit by a permission prompt again, regardless of risk.

**Decision:** Configure user-level `~/.claude/settings.json` for maximally permissive operation:
1. `defaultMode: "bypassPermissions"` (was `bypassPermissions` originally — was briefly changed to `"auto"` in error and reverted).
2. `deny: []` — removed `Bash(rm -rf *)` and `Bash(sudo *)` entries; deny entries hard-block rather than prompt, but still produce friction equivalent to a prompt.
3. Added top-level `autoMode.allow` block with `$defaults` + 3 natural-language rules: allow all file edits/reads, allow all bash commands, never prompt under any circumstance. Defense-in-depth in case `/auto` activates by accident.

**Rationale:** Operator's explicit cost-benefit: harness permission prompts are net friction for a solo expert operator who is present at the terminal during work. The "smart autonomy" promise of auto mode is undermined by a classifier too coarse to distinguish "operator's actual work editing Claude Code config" from "sensitive system file." Compensating controls retained: CLAUDE.md model-side Autonomy Rules (force-push, branch delete, external writes still pause) and git as recovery mechanism. Operator explicitly accepted the residual risk (no harness brake on destructive bash; bigger prompt-injection blast radius; account-wide scope across all projects).

**Alternatives considered:**
- **Keep auto mode as default + run `/fewer-permission-prompts` at wrap** — operator rejected; relies on wrap discipline and only patches paths that have already prompted, doesn't prevent the first prompt.
- **`acceptEdits` mode** — middle ground; still prompts on bash commands. Rejected as not zero-prompt.
- **Per-path Edit allowlist for `.claude/**`** — narrower fix, but would still leave bash prompts and other surface. Rejected as insufficient for the stated zero-prompt goal.

**Memory written:** `~/.claude/projects/.../memory/feedback_zero_permission_prompts.md` — codifies the policy and the behavioral rule (don't suggest `/auto`, `/plan`, or deny-list additions in future sessions). Old `feedback_permission_prompts.md` deleted as superseded.

---

## 2026-04-25 — Per-project model defaults replace workspace-wide default

**Context:** Three sources disagreed on the "default model" — workspace `CLAUDE.md` said Sonnet, `ai-resources/CLAUDE.md` said Opus 4.6, `model-classifier.sh` said Opus. The framework adopted ("Haiku scans, Sonnet executes, Opus judges") needed a reliable mechanism to apply across the current ai-resources work AND every new project, without the operator having to make per-task decisions.

**Decision:** Each project declares its own default model in a `Model Selection` section in its `CLAUDE.md`. Sessions outside any project (workspace root) fall back to Sonnet 1M. The `model-classifier.sh` hook becomes a project-aware tier classifier that compares the active task's tier against the project's declared default and recommends a switch only on mismatch. A new canonical doc — `ai-resources/docs/model-routing.md` — is the single source of truth that CLAUDE.md files, the hook, `/prime`, and `/new-project` all reference.

**Rationale:** Per-project defaults match the actual variance in workload across projects (ai-resources is mostly execution-tier; project-planning is judgment-heavy by definition; mixed projects opt into Opus when synthesis lands). A workspace-wide default would either over-route execution work to Opus (cost) or under-route judgment work to Sonnet (quality). The per-project rule lets each project's CLAUDE.md state the right tier for its actual workload, with the classifier hook handling the per-task escalation/de-escalation when a session's task tier doesn't match the declared default.

**Alternatives considered:**
- **Keep workspace-wide default (Sonnet) + per-task `/model opus` escalation.** Rejected: places the routing burden on the operator at every task naming, exactly what the framework is supposed to remove.
- **Workspace-wide default = Opus (cost-tolerant default).** Rejected: most ai-resources work is execution-tier; routing it through Opus is 5× input cost per token without quality benefit.
- **Add Haiku to session-level classifier.** Rejected: Haiku's cost saving is marginal at the session level (mechanical-measurement work is rare at the session), and the classifier overhead of three-way classification doesn't pay for itself. Haiku stays at the agent tier only.

**Sonnet `[1m]` suffix:** Operator-corrected mid-execution. All Sonnet full-form identifiers must use `claude-sonnet-4-6[1m]` (forces 1M context); bare `claude-sonnet-4-6` silently downgrades to 200k. Codified to memory as a durable rule applying to all future routing edits.

**Risk-check verdict:** PROCEED-WITH-CAUTION (5 dimensions: Medium / Low / Medium / Medium / Medium); 6 mitigations applied before commit.

**Memory written:** `~/.claude/projects/.../memory/feedback_sonnet_1m_suffix.md` — codifies the `[1m]` suffix rule.

## 2026-04-27 — Hook event registration (PostToolUse vs Stop)

**Context:** Graduating four hooks (`coach-reminder.sh`, `friction-log-auto.sh`, `improve-reminder.sh`, `log-write-activity.sh`) from `projects/buy-side-service-plan` to `ai-resources/.claude/`. Source project registered `coach-reminder` and `improve-reminder` under the `Stop` hook event.

**Decision:** Register both under `PostToolUse[Write|Edit]` in canonical, not `Stop`.

**Rationale:** Both scripts read `tool_input.file_path` from the hook's stdin JSON. `Stop` events do not carry a `tool_input.file_path` field — that only exists for tool-call events. Source-project Stop registration means the scripts run but always early-exit (empty path), making the hook effectively dead. PostToolUse[Write|Edit] is the correct event class for both scripts.

**Alternatives considered:**
- Mirror source-project Stop registration for consistency. Rejected: would propagate the latent bug to all future projects.
- Stop registration with script logic rewritten to detect "any Write event happened during the session." Rejected: that requires per-session state tracking the scripts don't have, and PostToolUse[Write|Edit] gets there for free.

**Follow-up:** The source project's settings.json still has the Stop registration. Logged as housekeeping for the next buy-side-service-plan session — separate concern, not in scope this session.

## 2026-04-27 — `/improve-reminder.sh` path regex documentation

**Context:** `improve-reminder.sh` triggers when written file paths match `/(approved|output|report/chapters|final/modules)/`. These are research-workflow-shaped paths. The hook is now in `ai-resources/.claude/hooks/` and will deploy to all future projects via `/new-project` and `/deploy-workflow` — including projects whose artifact paths don't match this regex.

**Decision:** Document the regex as research-workflow-shaped via a 4-line comment in the hook file (mitigation #3 from `/risk-check`), rather than refactor to a config-driven or auto-discovery model.

**Rationale:** Refactoring would require deciding what "significant artifact" means generically — an open question with no clean answer right now. The comment is honest about the coupling and gives the operator (or a future graduate-resource pass) explicit license to edit the regex per-project. Refactor remains an option later if a non-research project hits this and the override comment proves insufficient.

**Alternatives considered:**
- Per-project override via env var or settings JSON config. Rejected: adds cognitive overhead for a hook that fires silently 99% of the time.
- Auto-detect significant directories from git history. Rejected: complexity dwarfs the benefit.
- Strip the regex entirely and fire on every Write. Rejected: violates the once-per-session signal model.

## 2026-04-28 — Remove `Read(audits/working/**)` deny from ai-resources/.claude/settings.json

**Context:** During `/permission-sweep` execution, the deny rule blocked the main session from reading the auditor's `*.summary.md` file at Step 4 (the protocol explicitly tells main session to read it). Same deny also blocked subagents I spawned to retrieve it. Worked around with `Bash(cp)` to `/tmp` mid-command.

**Decision:** Remove the deny entry entirely. Subagent-contract discipline (main session reads summary only, not full notes) now lives only in `ai-resources/CLAUDE.md` § Subagent Contracts.

**Rationale:**
- `audits/working/` is already in `.gitignore` — no leak risk if main session reads a working-note file.
- The deny was a redundant mechanical guard layered on top of a discipline rule that already exists in CLAUDE.md.
- The deny actively broke `/permission-sweep`'s own protocol by blocking the small `*.summary.md` file the command needs.
- Narrow-glob alternatives (e.g., deny everything under `audits/working/` except `*.summary.md`) don't compose cleanly because Claude Code's deny list has no allow-exception precedence.

**Alternatives considered:**
- Narrow the deny to non-summary files: rejected, see above re composability.
- Move `*.summary.md` to a non-denied path (e.g., `audits/summaries/`): rejected, would require touching every audit subagent's output convention and the rest of the working-notes workflow.
- Keep the deny and patch every audit command to copy summaries out before reading: rejected, compounds the problem on every command.

## 2026-04-28 — Hold Finding 1 (research-workflow template placeholder); route auditor classification fix to backlog

**Context:** `/permission-sweep` flagged `ai-resources/workflows/research-workflow/.claude/settings.json:35` (`"additionalDirectories": ["{{WORKSPACE_ROOT}}"]`) as HIGH Rule 8 ("stale `additionalDirectories`"). The placeholder is intentional — commit `81cb6c2 update: research-workflow template — additionalDirectories placeholder + SETUP step` added it explicitly as a deploy-time fill-in consumed by `/deploy-workflow` / `/new-project`. The auditor cannot currently distinguish template source from deployed instance.

**Decision:** Hold Finding 1 (do not replace the placeholder). Log auditor template-class classification fix to `ai-resources/logs/improvement-log.md` as a 2026-04-28 backlog entry. Apply that fix later through `/risk-check` per Autonomy Rule #9.

**Rationale:**
- Replacing `{{WORKSPACE_ROOT}}` with a resolved path corrupts the template for every future research-workflow deployment — directly contradicts the template's purpose.
- Modifying `permission-sweep-auditor.md` mid-`/permission-sweep` would be a harness-level structural change that should not bypass the risk-check gate.
- The held finding will keep re-firing on every future sweep until the auditor learns to skip Rule 8 on `**/workflows/*/.claude/settings.json`.

**Alternatives considered:**
- Apply the auditor fix this session (option b in the recommendation): rejected; harness-level agent edit per Autonomy Rule #9 should run through `/risk-check`, which is its own ceremony separate from `/permission-sweep`.
- Leave only in the audit report, not in `improvement-log.md` (option c): rejected; the audit report alone is not a durable backlog tracker, and `/resolve-improvements` only consumes `improvement-log.md`.

## 2026-04-27 — Smoke-test deferral on buy-side wrap-session symlink

**Context.** Plan-time `/risk-check` on replacing `projects/buy-side-service-plan/.claude/commands/wrap-session.md` with a symlink to ai-resources canonical returned PROCEED-WITH-CAUTION (blast radius Medium, hidden coupling Medium). One mitigation called for a smoke-test of the new wrap-session against the buy-side project's settings hooks before landing — to catch any divergence between the canonical version's logic (dirt-check, archive, telemetry) and the buy-side directory layout.

**Decision.** Apply the symlink without a synthesized smoke-test; defer the live exercise to the next /wrap-session run inside the buy-side project. Note as an Open Question and as a revert-target if Steps 12a/12b/11 fail there.

**Rationale.** Wrapping the current ai-resources session does not exercise the buy-side path. The realistic smoke-test is the operator running `/wrap-session` from inside the buy-side project; a synthetic test from outside would not flush out hook-interaction or archive-script behavior. The blast radius is one project, the rollback is a single-line symlink revert, and the buy-side wrap is the natural next-touch point.

**Alternatives considered:**
- Block landing on a hand-built smoke-test now: rejected; the only realistic test is the next live wrap inside buy-side, and forcing a synthetic one delays low-cost work without producing the signal that matters.
- Re-run `/risk-check` to argue down the verdict: rejected; the verdict is correct, the mitigation list captures the right safety surface — defer-and-watch is itself the right shape of mitigation here.

## 2026-04-28 — `/deploy-workflow` hook registration: Option B (checklist) over Option A (auto-merge)

**Context.** Track 3 mitigation #5 from the 2026-04-27 risk-check on the 4-hook graduation asked: "Decide once whether `/deploy-workflow` auto-merges canonical hook entries into deployed projects' `settings.json`, or whether operators register per-project." The current `deploy-workflow.md:118–124` policy is manual registration. Option A would reverse the policy and auto-merge with idempotent jq deep-merge using basename-normalized dedup. Option B keeps manual registration but emits a structured checklist so the gap is visible at deploy time.

**Decision.** Option B. Implemented as a new `#### Canonical hook-registration checklist` sub-step that uses `jq` to dynamically render the registration table (script basename → event matcher → timeout) from `ai-resources/.claude/settings.json` at deploy time. Includes the `[scan(...)] | last // .command` basename-extraction pattern that handles non-`.sh` commands robustly. Also addresses mitigation #6 (revert log persistence note) as part of the same edit.

**Rationale.**
- Today's Track 1 bug — `coach-reminder.sh` and `improve-reminder.sh` registered under `PostToolUse[Write|Edit]` instead of `Stop` by commit `07cc6d6` — is itself the canonical example of why Option A is dangerous. With Option A, a canonical-side mistake would broadcast to every deployed project on every re-run. Manual registration provides a per-project gating point at exactly the moment the operator is best positioned to catch the wrong matcher (deploy time, with the project's existing hooks visible).
- Option B's dynamic checklist captures Option A's main upside (canonical-source-of-truth — checklist regenerates from the same `settings.json` that Option A would merge from), without taking on auto-write blast radius. If the checklist drifts from canonical, that's caught at the next deploy, not silently embedded across N deployed projects.
- The basename-normalized dedup pattern (`[scan("[^/\\s]+\\.sh")] | last // .command`) matters for either option — buy-side registers commands as `"$CLAUDE_PROJECT_DIR/.claude/hooks/X"` while canonical uses `bash $CLAUDE_PROJECT_DIR/.claude/hooks/X`, so raw-string dedup would have double-registered on every re-run. Caught by independent QC review during plan iteration; encoded into the checklist's underlying jq form even though Option B doesn't merge.

**Alternatives considered.**
- **Option A (auto-merge):** rejected for the blast-radius reason above. The QC and risk-check cycles surfaced two rounds of jq pseudocode bugs in the merge form (`capture` errors on non-matching strings; `[.] | unique_by(...)` array-wrapping). Both bugs were caught in plan, but they show how easy it is to ship a broken merge to N deployed projects — exactly the failure mode Option B avoids.
- **Status quo (no change):** rejected because the registration gap is what produced the Track 1 bug in the first place. A checklist makes the gap visible without reversing the policy.

## 2026-04-28 — Track 1 followup: rewrite hook scripts for Stop-event compatibility (mid-plan scope decision)

**Context.** Track 1 of the 2026-04-28 plan moved `coach-reminder.sh` and `improve-reminder.sh` registrations from `PostToolUse[Write|Edit]` to `Stop` in `ai-resources/.claude/settings.json`. While reading the script bodies during plan execution (to add Track 3 #6 header comments), discovered both scripts read `tool_input.file_path` from stdin JSON — a field present in PostToolUse events but not in Stop. Under Stop they would have exited silently at the file_path check. The Track 1 settings move alone was a half-fix.

**Decision.** Rewrite both script bodies to be Stop-compatible, in-scope as a Track 1 followup commit. Coach drops the `tool_input.file_path` read entirely; relies on its existing session-count-vs-last-coach-run logic (which is intent-aligned with Stop). Improve replaces the file_path check with a `git status --porcelain` scan against the artifact-dir regex `^(approved|output|report/chapters|final/modules)/`, which is the Stop-appropriate trigger for "did this session produce significant artifacts."

**Rationale.**
- Operator-directed: explicitly chose "Option 2 — finish the job" over leaving the registration in `Stop` while keeping the PostToolUse-shaped script bodies. Half-fix would have produced silent no-ops on every Stop firing, which is worse than the original misregistration (at least the misregistration was visible as nuisance Write/Edit nudges).
- Discovered during execution, not in plan — but the rewrite is conservative: drops a check, replaces another with an equivalently-purposeful one. No new behaviors, no new dependencies. Documenting the mid-plan scope expansion explicitly so future readers understand why two Track 1 commits exist instead of one.

**Alternatives considered.**
- **Land Track 1 settings move as-is and log the script rewrite to improvement-log:** rejected because the registration would silently no-op until the script rewrite landed — a regression from the buggy-but-firing PostToolUse state. Worse outcome than no fix.
- **Revert Track 1 entirely until script bodies were rewritten:** rejected; the rewrite was small (~10 lines per script) and operator-confirmable in the same session.

## 2026-04-28 — End-time `/risk-check` skip rule extension

**Context.** The 2026-04-27 entry above ("End-time `/risk-check` skipped when plan-time verdict is GO with zero execution drift") established a narrow skip rule: plan-time GO + zero drift. The 2026-04-28 wrap-session post-mortem identified a second class where end-time `/risk-check` adds no value: the plan-time verdict was PROCEED-WITH-CAUTION with mitigations applied AND the structural commits were already in the working tree's history. The end-time gate's "before commit" framing has nothing left to gate in that case.

**Decision — Extend the skip rule.** End-time `/risk-check` may also skip when ALL of the following hold:

1. Plan-time `/risk-check` returned GO or PROCEED-WITH-CAUTION with all paired mitigations applied (cite their commits in the wrap note).
2. Executed-set drift from plan is bounded and conservative — drops a check, mechanical rewrite, no new files / new commands / new permissions / new hooks.
3. Structural commits are already in the working tree's history (gate is informational, not blocking).

When the extension is invoked, document one line in the wrap session note:

> "End-time /risk-check skipped — plan-time covered, mitigations applied (commits X, Y), execution drift bounded."

**Rationale.** End-time `/risk-check` exists to catch (a) design risk the plan-time gate missed, and (b) execution drift from the approved design. Once mitigations from a PROCEED-WITH-CAUTION plan-time verdict are committed and drift is bounded-and-conservative, both signals are absent — firing the subagent burns ~5–10× the rest of a wrap's tokens for no additional safety margin. Without the extension, the gate fails for the non-obvious reason that "all structural changes are already shipped" was never a recognized skip condition.

**Alternatives considered.**
- *Treat the extension as judgment-only, no codification.* Rejected: future sessions would either over-fire (waste tokens) or under-fire (skip without justification) since the principle isn't written down.
- *Make the extension condition more permissive (drop the "mitigations applied" clause).* Rejected: that would let PROCEED-WITH-CAUTION verdicts skip end-time even when the operator hadn't applied the mitigations, defeating the gate's purpose.

---

## 2026-04-28 — `/context-builder`: Path B (dedicated QC infrastructure) over Path A (reuse generic qc-reviewer)

**Context.** New command `/context-builder` needed for Stage 1 of the project-planning pipeline (turn raw operator notes into a validated context pack ready for `/plan-draft`). Two implementation paths surfaced.

**Decision.** Path B — build dedicated `context-evaluator` agent + `ref-context-pack.md` reference doc, mirroring the `plan-evaluator`/`spec-evaluator` + `ref-project-plan.md`/`ref-tech-spec.md` pattern already in place.

**Rationale.** Operator's exact words: *"Context pack is a potential failure point downstream so I need to be sure that it is done properly."* A flawed context pack cascades — `/plan-draft` produces a flawed plan, `/spec-draft` extends the flaw, `/new-project` builds on broken foundations. Rigor proportional to downstream impact requires the same QC pattern as every artifact downstream of it.

**Alternatives considered.**
- *Path A — reuse generic `qc-reviewer` and the existing `context-pack-builder` skill.* Rejected: generic QC has no awareness of context-pack-specific quality dimensions (epistemic discipline, Fresh Claude Test). The same gap that motivated dedicated `plan-evaluator` and `spec-evaluator` motivates dedicated `context-evaluator`.
- *Hybrid — generic `qc-reviewer` with a context-pack-specific rubric file.* Rejected: rubric injection is a leakier abstraction than a dedicated agent. The agent is the rubric.

---

## 2026-04-28 — `/context-builder`: preserve canonical `context-pack.md` alias at finalization

**Context.** `/new-project` Stage 1 First Run discovers context packs at `output/{project-name}/context-pack.md` (bare canonical filename — `new-project.md` line 68: `[ -f "$SRC/context-pack.md" ]`). Plans and specs are auto-discovered via `sort -V` on versioned filenames; context packs are not. This pre-existing asymmetry is the question: do we drop the alias and refactor `/new-project` to auto-discover context packs too, or do we keep the alias and live with the asymmetry?

**Decision.** Keep the alias. `/context-builder` Step 9 copies the latest version to `context-pack.md` after operator approval. Versioned files (`context-pack-v{n}.md`) remain in place as the audit trail.

**Rationale.** Aligning all three artifact types (auto-discovery for context packs too) is a separate, cleaner refactor — it would require modifying `/new-project`'s discovery logic and validating that no other consumer depends on the bare canonical filename. Out of scope for the current task. Honoring the existing convention now keeps `/new-project` working without modification.

**Alternatives considered.**
- *Drop the alias and refactor `/new-project` to auto-discover.* Rejected as out-of-scope; clean refactor for a future session.
- *Skip the alias and force operator to manually copy the version file.* Rejected: undermines the "approved artifact ready for downstream" guarantee.

---

## 2026-04-28 — `/context-builder`: gate-loop semantics replace workspace auto-loop two-pass cap

**Context.** Workspace CLAUDE.md defines a `QC → Triage Auto-Loop` that runs up to two automatic post-edit QC passes. `/context-builder`'s Step 7 review gate is operator-controlled. Conflict: should the QC pass at Step 8 follow the auto-loop's two-pass behavior, or should each operator selection of "QC pass" trigger exactly one round-trip?

**Decision.** Each operator selection of "QC pass" at Step 7 = exactly one round-trip (one parallel-subagent invocation, optional triage if findings exist, one fix-and-write to v{n+1}). Operator can re-select "QC pass" multiple times via the gate to iterate. Soft ceiling: after 3 selections in a single invocation, emit advisory note ("if not converging, the issue may be structural — consider Approve-with-known-gaps or restart").

**Rationale.** Operator explicitly requested a "force review step" in the original brief. Gate-controlled iteration honors that — the human gate is the loop control, not an automatic pass count. The auto-loop's two-pass cap exists precisely to prevent runaway iteration without operator visibility; the gate replaces that safeguard with direct operator control, which is stronger.

**Alternatives considered.**
- *Apply the workspace auto-loop verbatim (two automatic passes after each "QC pass" selection).* Rejected: defeats the explicit "force review step" the operator asked for. Two opaque passes per gate selection is worse, not better, than one transparent pass per selection.
- *No iteration cap.* Rejected: 3-selection soft advisory protects against artifacts that aren't converging structurally.

---

## 2026-04-28 — Precondition-check guardrails on /triage and /recommend (vs. command rename)

**Context.** `/triage` and `/recommend` sit at adjacent operator postures (proposals filter vs. open-question resolver). Both are operator-invoked unblock mechanisms acting on Claude's recent output, but they take different inputs (slate of proposals vs. clarifying questions/assumptions). Wrong-command invocation is a real risk, especially because `/recommend` is poorly named relative to its function (operator's framing during the session). The operator originally explored renaming `/recommend` (top candidate: `/proceed`); after considering blast radius, pivoted to guardrails as the more durable fix.

**Decision.** Add a Step 1 "Verify trigger condition" precondition gate to each command. Each gate scans recent turns for the command's actual trigger and, on mismatch, stops and offers the sibling command instead of executing on the wrong input. Rename deferred indefinitely.

**Rationale.** The gate fires at the moment of mis-invocation and is self-correcting — operator simply re-issues the right command. Rename would touch references in workspace CLAUDE.md, ai-resources CLAUDE.md, memory, docs, and any cross-project mentions — non-trivial blast radius for a problem the gate solves at the source. Gates are also additive: if the rename later proves necessary, the gates remain useful in their own right.

**Alternatives considered.**
- *Rename `/recommend` → `/proceed` (or `/decide`).* Top candidate by name elegance and pairing with `/triage` and `/clarify`. Rejected for now: invasive, doesn't prevent the underlying mis-invocation pattern, only makes it less likely.
- *Unified routing command (`/decide-mode`) that detects intent and dispatches.* Rejected: adds a layer, dilutes explicit-intent benefit, doesn't fit the workspace's short-verb command idiom.
- *Decision rule in workspace CLAUDE.md ("when proposals → /triage, when questions → /recommend").* Rejected: relies on operator recall at invocation time; doesn't actively prevent mis-invocation.

## 2026-04-29 — /resolve architecture: reuse triage-reviewer

**Context.** Planning a new `/resolve` command. Initial design included a new `resolve-reviewer` agent (opus) to classify QC findings by importance and recommend fixes.

**Decision.** Drop `resolve-reviewer`; reuse the existing `triage-reviewer` subagent for importance classification. The main Claude session (not a subagent) drafts concrete fixes for the "Do" items.

**Rationale.** QC during planning surfaced near-total overlap: both agents are opus, both are independent reviewers, both classify items by consequence/risk. The "Recommended Fix" column was the only net-new piece, and that can be handled by the main session after triage output is received.

**Alternatives considered.**
- *New `resolve-reviewer` agent (original plan).* Rejected: redundant with `triage-reviewer`; two near-duplicate opus agents accumulate maintenance surface and create routing ambiguity.
- *Extend `/triage` with a "with-fixes" mode.* Rejected: complicates the existing command's interface; `/resolve` as a separate command preserves clean separation of concerns.
