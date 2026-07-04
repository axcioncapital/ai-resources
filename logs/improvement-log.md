# Improvement Log

## Schema

Each entry is a `### YYYY-MM-DD — {title}` block. Fields:

- **Status:** `logged` | `proposed` | `pending` | `applied YYYY-MM-DD`
  *De facto convention: all current unresolved entries use `logged (pending)` as a combined compound state. The `/friday-checkup` [STALE] detection rule (added 2026-05-06) matches this compound form — not `pending` alone. If entries are normalized to the single-token schema in future, update the [STALE] match string in `friday-checkup.md` Step 6 accordingly.*
- **Verified:** present when Status is `applied` and the operator has confirmed the fix is live. `/resolve-improvement-log` classifies an entry as resolved via two tiers (Step 3, since 2026-06-12 S9): **tier 1 (strict)** — both `Status: applied` AND a `Verified:` line; **tier 2 (convention)** — the `**Status:**` line itself contains `resolved`/`RESOLVED` followed by a `YYYY-MM-DD` date (a `resolved` token inside proposal prose does not qualify). Both tiers archive identically; tier-2 classifications are tagged `[convention]` for operator spot-check. *(This preamble line is the lockstep pair of the command's Step 3 rule — S9 widened the command and deferred this edit while a concurrent session owned the file; applied 2026-06-12 S11.)*
- **Age:** auto-computed from the header date by `/resolve-improvement-log`; surfaced when > 6 weeks without resolution.
- **Review-cycle:** for items not yet resolved — records the last review date and disposition (e.g., `reviewed 2026-04-24, deferred to next quarterly`). **This is the canonical "park" mechanism for ROI-deferred low-value items** (per workspace `CLAUDE.md` § Working Principles, structural-fix rule): a low-value item is parked by stamping `Review-cycle: reviewed {date}, deferred to {concrete trigger}`, which resets the `/friday-checkup` stale-scan clock to the review date. The deferral target must be **concrete** — a date, a quarter, or a named event — never "later"/"someday" (a park with no real trigger never drains; `/resolve-improvement-log` Step 3b rejects a vague trigger). A parked item stays in the **active** log and re-surfaces (the stale-scan re-flags it ~21 days after the review date, and the monthly `/friday-checkup` park-drain force-reviews the oldest parks); parking is **not** archival. Reserve archival for genuinely dead items.
- **Category:** broad classification (e.g., `Audit-recurrence prevention`, `command/skill`).
- **Proposal:** the proposed change.
- **Target files:** files to be edited when executed.

Resolved entries (Status: applied + Verified) are archived to `improvement-log-archive.md` via `/resolve-improvement-log`.

---

### 2026-07-04 — Indicative-run mode for `/reconcile` against un-ratified scaffolder drafts (SO deferral)
- **Status:** logged (pending)
- **Category:** command/skill
- **Severity:** low
- **Provenance:** `/reconcile-activate` build, 2026-07-04. Risk-check SO second opinion (`audits/risk-checks/2026-07-04-reconcile-activate-command-and-reconcile-step2-draft-gate.md` § Architectural Commentary, risk 2). The build shipped a hard-abort DRAFT-gate: `/reconcile` refuses to run until the two scaffolded reference files are ratified (all `{{AUTHOR:}}` placeholders replaced + the banner deleted). SO concurred with shipping hard-abort but flagged that, for the ~20 dormant projects, an abort keeps `/reconcile` behind authoring work — the same friction it aims to cure — and proposed a softer indicative mode.
- **Proposal:** Evaluate a flagged indicative mode: instead of aborting on an un-ratified rubric/map, `/reconcile` runs and stamps the verdict `UNRATIFIED — indicative only`, so the operator sees value before authoring (OP-12, closure-activating). Keep the ratification-required gate on any authoritative/report-write path so indicative output can never be mistaken for a ratified judgment. Requires its own `/risk-check` — blast radius reaches `reconcile-reviewer` + `reconcile-verdict-definitions.md` + multiple `/reconcile` steps. **Trigger:** only worth building once adoption data shows the hard-abort is actually parking projects — i.e. `/reconcile-activate` has run on ≥2 projects and at least one operator stalls at the ratify step. If the scaffolder alone unblocks adoption, close as DROP.
- **Target files:** (only if built) `ai-resources/.claude/commands/reconcile.md`; `ai-resources/.claude/agents/reconcile-reviewer.md`; `ai-resources/docs/reconcile-verdict-definitions.md`.
- **Review-cycle:** monthly

### 2026-07-04 — Revisit the A11 observability reporter once the closure channel is proven (PARKED — reminder)
- **Status:** parked — OVERTAKEN as a now-build; held on a named-event trigger
- **Category:** ai-strategy / observability (strategic-os roadmap Slot 3)
- **Review-cycle:** reviewed 2026-07-04, deferred to → **the Slot-4 closure channel is built AND demonstrably clearing its queue** — concretely, `/friday-act` ratified as the closure channel with its recurring-item leak fixed under an error-budget→forced-decision rule. Named-event park per the schema rule; surfaces at every Friday checkup until that event fires.
- **Source:** SO consult 2026-07-04 (`projects/axcion-ai-system-owner/output/consultations/consult-2026-07-04-june-strategy-items-a11-observability-and-op12-closure.md`); operator decision to park **with a reminder** (this entry is the reminder).
- **Why parked (not built now):** The `A11` "sasabi" unprompted read-only state reporter (strategic-os roadmap Slot 3) has no consumer today — the closure channel (Slot 4) and the autonomous owner (Slot 8) it was meant to feed do not exist. Operator-triggered legibility is already delivered by the Friday cadence (`/friday-checkup`→`/friday-so`→`/systems-review`) + `/open-items` + `repo-state.md`. Building unprompted detection ahead of a working closure channel is itself the detection-ahead-of-closure move `OP-12` counsels against — so the reporter must wait behind Slot 4.
- **When the trigger fires:** re-evaluate whether an unprompted auto-feed reporter still earns its place (it may, if it cuts operator attention by pushing findings into the now-clearing closure channel instead of a manual `/friday-checkup` run) — or whether the Friday cadence already covers it permanently. Then update strategic-os `implementation-tracker.md` Slot 3 + `candidate-backlog.md` §B.1 accordingly.
- **Cross-ref:** strategic-os `ai-strategy/implementation-tracker.md` Slot 3 (parked, same trigger) + `ai-strategy/candidate-backlog.md` §B.1 (A11 OVERTAKEN). Companion strategic finding from the same consult (not this entry's scope): the highest-leverage next move is to build/fix the Slot-4 closure channel itself.

### 2026-07-03 — Keep the System Owner's vault grounding current on a weekly cadence
- **Status:** logged (pending)
- **Category:** cadence / infrastructure (Friday cadence + System Owner grounding freshness)
- **Friction source:** repo-documentation friction-log 2026-07-03. The System Owner grounds every advisory on `projects/repo-documentation/vault/` (`axcion-ai-system-owner/references/grounding.md` §1–2), but the vault silently drifted from live: component registry last full-refreshed 2026-04-28; last W2.1 doc-scan (2026-06-05) reported 192 unpasted adds; `repo-state.md`'s component dimension predated the current 620-component inventory (2026-07-03 `/archaeology`). The operator had to manually notice and request the refresh — there is no forcing function keeping the vault (and therefore the SO) current, and no signal when grounding is stale. Operator goal: repo documentation updated **every Friday**, and the SO always has access to the latest.
- **Proposal:** (structural — `/risk-check` at both gates before landing; do NOT apply ad-hoc)
  1. **Weekly vault-state refresh.** Move the `repo-state.md` refresh (currently `/friday-checkup` Step K, monthly tier) and the W2.1 doc-scan to the **weekly** tier so the vault re-syncs against live every Friday, not monthly. Confirm the weekly-tier cost delta is acceptable (doc-scan is read-only + one report write; repo-state refresh reads each project's session-notes).
  2. **Paste-backlog stale-gate.** Add a `/friday-checkup` check that surfaces the component-registry paste backlog: if the latest W2.1 doc-scan reports > N unpasted adds, OR `repo-state.md` `last_updated` is older than ~8 days, emit a `[STALE-VAULT]` flag in the checkup report plus a non-skippable `/friday-act` line to paste. Closes the "report produced but never pasted" gap (the actual 192-add failure).
  3. **(Option) SO grounding-staleness self-label.** Have the `system-owner` agent (or the six SO consumer command bodies) read `repo-state.md` `last_updated` at grounding time and prepend a one-line `[grounding as of {date} — N days old]` note when it exceeds a threshold, so a stale SO answer is self-labeled rather than silently authoritative.
- **Target files:** `ai-resources/.claude/commands/friday-checkup.md` (move Step K + W2.1 to weekly tier; add the stale-gate check); `ai-resources/.claude/commands/friday-act.md` (non-skippable paste line when `[STALE-VAULT]` fires); `projects/repo-documentation/vault/architecture/repo-state.md` (Step K writes it weekly); optionally `ai-resources/.claude/agents/system-owner.md` + the six SO consumer command bodies (option 3). Confirm exact step names via a read of `friday-checkup.md` at build time.
- **Note:** interim mitigation already applied 2026-07-03 — `repo-state.md` §5 (Component Inventory) hand-refreshed to the current 620-component state (334 shared/canonical + 286 project-specific) so the SO has current headline grounding now; this entry is the durable fix so it doesn't recur. Component registry (`components/*.md`) full re-paste still pending at next `/friday-act`.

---

### 2026-06-29 — Build the 3 deferred `/new-project` functions (#5, #4, #14) when the first operational system build starts
- **Status:** logged (pending)
- **Category:** command/skill (deferred pipeline/business-systems builds — parked on a trigger, not a date)
- **Review-cycle:** reviewed 2026-06-29, deferred to → **the first Axcíon operational system (CRM / email machinery / buyer-mandate DB / LinkedIn machinery / website infra / Management OS) entering a `/new-project` build.** This is the relevance trigger for all three. (Named-event park per the schema rule; surfaces at every Friday checkup until that event fires.)
- **Friction source:** none — this is a deliberate ROI/timing park, not a defect. The build was evaluated and approved (decisions.md 2026-06-29 ×2; SO advisory `consult-2026-06-29-newproject-layer-placement.md`); only the *timing* is deferred. Operator asked to be reminded ("I will forget").
- **Proposal:** When the trigger fires, re-open the decision and build in order:
  1. **#5 Data Model Steward** (foundation) — canonical entity dictionary; home is a dedicated business-systems project *vault* via `/deploy-kb`, NOT `ai-resources/` (OP-10 / DR-1). Standing up the project fires `/placement` (new top-level dir). ~1 session.
  2. **#4 Interface Contract Generator** — needs #5's vocabulary; home is `projects/project-planning/` as a conditional output consumed by `/new-project` Stage 3b. Build only when a real project needs a cross-system contract (second-consumer gate). ~1 session.
  3. **#14 Operating Loop Designer** — independent quick-win; extend Stage 6 / `session-guide-generator`. Edits the `/new-project` critical command (Critical-tier, 3 consumers) → **`/risk-check` at both gates**. ~half a session.
- **Target files (at build time):** `ai-resources/.claude/commands/new-project.md` (#14 Stage 6 extension); `ai-resources/.claude/agents/session-guide-generator.md` (#14); `projects/project-planning/` (#4); new business-systems vault via `/deploy-kb` (#5). Confirm exact locations via `/placement` at build time.
- **Note:** plan memo lives outside the repo at `~/.claude/plans/frolicking-tinkering-manatee.md` — re-read it (or this entry + the two decisions.md 2026-06-29 entries) when resuming.

---

### 2026-06-18 — Purge `[1m]` / 1M-context model declarations causing subagent failures
- **Status:** logged (pending) — items 1–2 done 2026-07-03: the 3 `settings.local.json` `"model"` lines verified already gone (item 1 moot); 5 project-planning evaluator agents changed `claude-opus-4-7` → `opus` (item 2; the 6th match, innovation-triage-auditor, is a symlink to canonical which already reads `opus`). Item 3 (careful 1M-concept rewrite across ~9 command/hook files) remains — needs its own scoped session per this entry's own note.
- **Category:** infrastructure (harness config / model declarations)
- **Friction source:** axcion-website session 2026-06-18 — subagents fail to spawn in several projects. Traced to model IDs carrying the `[1m]` (1M-context) suffix and/or a stale version (`claude-opus-4-7`). The 1M-context variant needs separate usage credits; when unavailable the spawn errors. Operator goal: remove `[1m]`/1M-context usage across the harness so subagents spawn reliably on the operator-selected session model. Two scope/rule conflicts were surfaced and resolved during clarify: (a) the `model` field in `settings.local.json` violates the workspace Model Tier rule — resolved to **delete the line entirely** (not strip the suffix); (b) most `[1m]` strings in commands are load-bearing logic, not prose — operator confirmed **rewrite to remove the 1M-context concept**, not literal find-replace. Failure-causing files sit OUTSIDE axcion-website (in sibling projects), so scope was expanded to the whole footprint.
- **Proposal:**
  1. **Settings (the real fix, gitignored — local-machine change):** delete the `"model"` line from `projects/axcion-ai-system-owner/.claude/settings.local.json`, `projects/buy-side-service-plan/.claude/settings.local.json`, `projects/project-planning/.claude/settings.local.json`. Restores `/model` override and complies with workspace `CLAUDE.md` § Model Tier.
  2. **Agents (the real fix):** in `projects/project-planning/.claude/agents/` — `plan-evaluator.md`, `spec-evaluator.md`, `plan-drift-evaluator.md`, `spec-drift-evaluator.md`, `context-evaluator.md` — change `model: claude-opus-4-7` → `model: opus` (clean tier name auto-tracks current Opus).
  3. **Commands / hook (cleanup toward no-1M goal — careful rewrite, not find-replace):** remove the 1M-context concept and `[1m]`/`200k` window logic from `ai-resources/.claude/commands/{session-plan,prime,new-project,qc-pass}.md`, `projects/nordic-pe-macro-landscape-H1-2026/.claude/commands/session-plan.md`, the `[1m]` prose in `ai-resources/.claude/agents/innovation-triage-auditor.md`, the `200k` mentions in `projects/ai-development-lab/.claude/commands/analyze-transcript.md`, and the `sonnet[1m]` / "Sonnet 1M" recommendation in `.claude/hooks/model-classifier.sh`. Each occurrence needs judgment — several state "bare `claude-sonnet-4-6` resolves to 200k", so the surrounding logic must be reworked, not just the literal stripped.
- **Target files:** 3 `settings.local.json` (above); 5 project-planning agent `.md`; `ai-resources/.claude/commands/session-plan.md`, `prime.md`, `new-project.md`, `qc-pass.md`; `projects/nordic-pe-macro-landscape-H1-2026/.claude/commands/session-plan.md`; `ai-resources/.claude/agents/innovation-triage-auditor.md`; `projects/ai-development-lab/.claude/commands/analyze-transcript.md`; `.claude/hooks/model-classifier.sh`.
- **Note:** items 1–2 are the actual subagent-failure fix (small, low-risk); item 3 is broader cleanup. Could split: do 1–2 first as a quick fix, schedule 3 as the careful pass. Run `/scope` at execution time to lock per-occurrence treatment before editing.

---

### 2026-06-16 — /new-project: register command/agent symlinks for standalone-openable projects
- **Status:** logged (pending)
- **Category:** command/skill (pipeline spec-coverage gap)
- **Friction source:** axcion-website Stage 4 build (S1, 2026-06-16) set up the project harness (`.claude/hooks/` + `.claude/settings.json`) but created no `.claude/commands/` or `.claude/agents/`. Because the project has its own `settings.json`/`CLAUDE.md`, it is meant to be opened as its own session root — and Claude Code resolves slash-commands only from the opened folder's `.claude/commands/` (it does not climb to a parent's `.claude/`). Result: every `/command` returned "Unknown command" when the project was opened directly. A second session diagnosed it and hand-replicated the workspace-root symlink pattern. Build itself was spec-correct — the 31-op spec simply never included symlink registration; the `/new-project` pipeline runs from workspace root (where commands resolve), so the gap was invisible at build time and only surfaced on a standalone open.
- **Proposal:** Add a harness-scaffold operation to `/new-project` that registers the shared command/agent symlinks into `<project>/.claude/commands/` and `<project>/.claude/agents/`, mirroring the committed workspace-root pattern — relative symlinks into `ai-resources/.claude/{commands,agents}/`, depth-adjusted for the project's nesting (e.g. `../../../../ai-resources/...` for a `projects/<name>/` project). Gate on "project gets its own settings.json" (i.e., intended to be opened as its own session root). Verify links resolve (0 broken) as part of the step.
- **Target files:** `ai-resources/.claude/commands/new-project.md` (add the symlink-registration op to the harness-scaffold stage); optionally a reusable registration fragment under `ai-resources/templates/` if warranted.

---

## Triage — 2026-05-22 (friday-act improvement-log plan, item 1)

Read-only triage of the 4 entries logged this friday-checkup cycle. No fixes executed.

- **Friction logging stub entry ("note this")** — MED. Bundle with the 2 entries below — all 3 touch `note.md` / `friction-log.md`; one ~1 h session. — **SHIPPED 2026-05-22 commit `3a7ad4c`; archived.**
- **/note + /friction-log incompatible session-header formats** — MED-HIGH. Load-bearing fix of the trio: the format mismatch makes `/note friction:` append duplicate blocks and silently drop write-activity capture. Do first in the bundled session. — **SHIPPED 2026-05-22 commit `3a7ad4c`; archived.**
- **No trigger/context on manual friction entries** — MED. Bundle with the 2 above. — **SHIPPED 2026-05-22 commit `3a7ad4c`; archived.**
- **workflow-diagnosis / improvement-analyst boundary doc** — MED, dependent. Do inside the `/create-skill` run that fulfills `inbox/workflow-diagnosis.md` — not standalone. — **Still pending** (entry retained below as `### 2026-05-22 — workflow-diagnosis skill brief overlaps improvement-analyst`).

Queue: one bundled `note.md` / `friction-log.md` session for the 3 friction-logging entries; the boundary-doc entry rides with the workflow-diagnosis skill build.

**Annotation 2026-05-25:** Three of four entries shipped same-day (2026-05-22, commit `3a7ad4c` — unified session headers, stub detection, context capture). Triage block retained as historical record of the friday-act planning process. Only the workflow-diagnosis boundary-doc entry remains active.

---

### 2026-05-25 — Extract shared rendering convention doc
- **Status:** logged (pending)
- **Category:** infrastructure
- **Friction source:** /session-start rendering fix (mandate confirmation) — current rendering rules (icon set + bold-label discipline + section-structure rules) are inlined in `session-start.md` Step 2 with a `<!-- TODO: extract to shared rendering convention -->` marker. One consumer today; deferred per DR-7 (generalize only when a second confirmed consumer exists).
- **Proposal:** When a second consumer appears (e.g., another confirmation-output command, or a friction event around `/prime` rendering inconsistency), extract the rules to `ai-resources/docs/rendering-conventions.md` and reference from `session-start.md` (replacing the inlined block) and `prime.md`. Side note: `/prime`'s output template currently uses plain-text labels (not bold inline) — minor inconsistency to harmonize in the same extraction session.
- **Target files:** `ai-resources/.claude/commands/session-start.md`, `ai-resources/.claude/commands/prime.md`, new `ai-resources/docs/rendering-conventions.md`

### 2026-05-28 — /pm forward-looking handling: re-evaluate after 3 paste cycles into /session-start

- **Status:** logged (pending)
- **Category:** command/skill
- **Source:** project-manager agent + /pm command landing 2026-05-28 — System Owner Function-B advisory flagged the design choice. Per `principles.md § DR-7` (generalize only on confirmed second-consumer evidence), v1 ships with forward-looking project-content handling (mandate generation, session-plan suggestions) inside `/pm`, with the operator manually pasting the verdict into `/session-start` or `/session-plan`. The architecturally cleaner answer — having `/session-start` and `/session-plan` natively read constitution docs — was deferred for lack of second-consumer evidence.
- **Trigger:** after the operator has used `/pm` for forward-looking questions (mandate or session-plan shapes) **three or more times** (counted by manual paste-into-`/session-start` cycles), re-evaluate whether forward-looking logic should move from PM into `/session-start` and `/session-plan` natively. Friday cadence review.
- **Proposal:** if the paste-step is recurring without complaint, status-quo is fine — close as `applied (no-op confirmed)`. If the paste-step is causing friction (forgotten paste, copy errors, divergence between PM verdict and final mandate), extract forward-looking logic into `/session-start` and `/session-plan` natively (they would invoke project-manager internally, or grow their own constitution-doc read).
- **Target files (when triggered):** `ai-resources/.claude/commands/session-start.md`, `ai-resources/.claude/commands/session-plan.md`, possibly `ai-resources/.claude/agents/project-manager.md` (Phase 3 forward-looking branch).

### 2026-05-28 — investigate sub-subagent dispatch (Task-from-agent) limitation

- **Status:** logged (pending)
- **Category:** command/skill / runtime-limitation
- **Source:** project-manager agent BLOCKING gate trace test (2026-05-28). The PM agent was designed to spawn `system-owner` via the `Task` tool for structure-general escalation. The trace test surfaced that the agent reports `Task` is not in its available toolset — despite the frontmatter declaring `tools: - Task`. Sub-subagent dispatch (agent → agent via Task) does not work in the current Claude Code runtime, regardless of frontmatter declaration. PM gracefully degrades to its DISPATCH FAILED fallback (per `principles.md § OP-3` loud failure rule), telling the operator to run `/consult` directly for structure questions.
- **Impact:** PM ships in degraded mode for structure escalation. Project-content advisory (retrospective + forward-looking — the primary use cases) works as designed. Structure-general questions emit a clear "run /consult directly" output instead of seamlessly folding in a system-owner consultation.
- **Investigation tasks:**
  1. Verify whether the tool name in agent frontmatter should be `Task` (current convention across system-owner.md, qc-reviewer.md, etc.) or `Agent` (the runtime-exposed tool name in main-session context). Check Claude Code documentation / release notes.
  2. If the convention is correct but Claude Code doesn't yet support sub-subagent dispatch, file a feature request upstream or accept the limitation as architectural (agents are leaf nodes; only commands and main session can spawn agents).
  3. If sub-subagent dispatch IS supported via a different mechanism (e.g., a wrapper, a different SDK call), update PM's Phase 4 to use the working pattern.
  4. Decide between three v1.1 design options: (a) seamless sub-subagent dispatch if supportable; (b) restructure PM to never attempt escalation (Phase 4 removed; structure questions always emit "/consult redirect"); (c) accept degraded mode as designed and update docs.
- **Proposal:** time-box the investigation to one Friday-act wave (~1 h). If sub-subagent dispatch can be made to work cleanly, ship the fix. If not, redesign PM Phase 4 to always emit the "/consult redirect" output deterministically (remove the conditional dispatch attempt; same operator-facing experience, simpler agent body).
- **Target files (when executed):** `ai-resources/.claude/agents/project-manager.md` (Phase 4); `ai-resources/.claude/commands/pm.md` (notes section if behavior changes); possibly `ai-resources/docs/agent-tier-table.md` notes column.
- **Triage cadence:** next Friday `/friday-act` wave.

### 2026-05-28 — /pm internal QC step: data-gated review after 3 invocations (pass-rate + verbatim-shape contract)

- **Status:** logged (pending)
- **Category:** command/skill / data-gated simplification
- **Source:** End-time `/risk-check` 2026-05-28 (PROCEED-WITH-CAUTION verdict). The `/pm` command Step 4 includes an internal QC pass via `qc-reviewer` with pass cap of 2. This was a **plan divergence** — the approved plan said no internal QC, mirroring `/consult`; the operator added the QC step mid-implementation because PM "will be solving quite important issues." The risk-checker promoted D1 Usage cost Low → Medium because each `/pm` invocation now lights up the High-tier `qc-reviewer` agent (per `risk-topology.md § 1`), with worst-case 4 Opus calls per invocation (PM → qc-reviewer → revised PM → qc-reviewer). System-owner end-time Function-B advisory concurred and asked that this v1.1 review entry name the verbatim-shape contract on `qc-reviewer` output (GO / REVISE / FLAG FOR EXTERNAL QC) explicitly so future audits catch drift if qc-reviewer's verdict tokens change.
- **Two coupled risks to track:**
  1. **QC pass-rate.** If the first-pass QC verdict is GO on >90% of invocations, the QC step is largely noise — the data points to removing it. If it surfaces real REVISE findings >30% of the time, it earns the cost. Operator should sample after first 3 invocations.
  2. **Verbatim-shape contract on qc-reviewer output.** `/pm` Step 5 parses `qc-reviewer`'s output for the tokens `GO`, `REVISE`, `FLAG FOR EXTERNAL QC` (exact strings). If `qc-reviewer.md` ever changes those token names or output structure, `/pm` Step 5 silently misclassifies the verdict. This is an implicit two-end contract — name it explicitly in this entry per `risk-topology.md § 1 — qc-reviewer agent` (High tier, every-pm-call dependency). Mitigation option for v1.1: extract the verdict-token list into a sibling reference doc both `qc-reviewer.md` and `/pm` Step 5 read, OR add a defensive shape check in `/pm` Step 5 that falls back to "GO" if the verdict token is unrecognized (loud-failure variant per `principles.md § OP-3`).
- **Trigger:** after the operator has used `/pm` three or more times, review the first-pass qc-reviewer pass-rate. Friday cadence.
- **Decision matrix (when triggered):**
  - **Pass-rate ≥90% on first pass** → QC step is mostly noise; consider removing Step 4 and converging back to /consult precedent. Document the data and rationale in the closure.
  - **Pass-rate 60–90%** → QC step is earning some signal; keep it but consider relaxing pass cap (currently 2) to 1, OR adding a fast-path that skips QC for retrospective questions (which are more constrained than forward-looking).
  - **Pass-rate <60%** → QC step is essential; PM rulings are routinely degraded without it. Keep as-is. Investigate why PM's first-pass quality is low (may indicate constitution-doc grounding issues, not QC necessity).
- **Verbatim-shape contract check (always, regardless of pass-rate):** review whether `qc-reviewer.md` has changed its verdict tokens or output shape since 2026-05-28. If yes, update `/pm` Step 5 parser in lockstep.
- **Target files (when executed):** `ai-resources/.claude/commands/pm.md` (Step 4 / Step 5 — possibly remove QC step, relax pass cap, or update verdict parser); possibly `ai-resources/.claude/agents/qc-reviewer.md` (if verdict-token shape stabilizes via shared reference doc).
- **Triage cadence:** next Friday `/friday-act` wave, gated on ≥3 `/pm` invocations having occurred.

### 2026-05-28 — B-04 deferred companion: extract S-04 from execution-manifest-creator

- **Status:** logged (pending)
- **Category:** Cross-skill contract enforcement / half-extracted-state prevention
- **Source:** FX-B2 plan-time `/risk-check` System Owner Function-B advisory (2026-05-28) — `audits/risk-checks/2026-05-28-fx-b2-extract-swedish-finnish-norwegian-language-search.md § Architectural Commentary § Risk the Dimension Review Did Not Surface`. FX-B2 landed S-04 extraction on the `research-prompt-creator` skill (lines 143–166 → loader stanza; Self-Check line ~242 → Project-Config-driven), with per-language term content moved to `ai-resources/workflows/research-workflow/reference/language-search-blocks.template.md` + per-project `reference/language-search-blocks.md`. After FX-B2, S-04 has three canonical surfaces — `research-prompt-creator/SKILL.md` (now generalized), `execution-manifest-creator/SKILL.md` (still hardcoded with Nordic countries in its routing table), and `docs/project-config-schema.md` field 5 (the `Languages:` declaration). There is no automated check that S-04 contracts agree across all three surfaces (W2.2 accountability automation does not yet exist per `system-doc.md § 2.3, § 4.5`).
- **Risk if left undone:** Drift-without-detection at system scale (`principles.md § OP-3, § OP-11`). The half-extracted state is invisible technical debt — a future audit will surface "execution-manifest-creator still hardcodes Sweden/Norway/Finland" as a "you missed this" finding (AP-11 territory).
- **Proposal:** Apply the same FX-B3/B4/B5/B6/B2 extraction pattern to `execution-manifest-creator/SKILL.md` — move country-routing values out of the canonical skill into a per-project fillable reference (likely paired with the same `Languages:` / `Country set:` Project Config fields that drive `research-prompt-creator`). Use FX-B2's 3-case absent-file contract as precedent.
- **Sibling consideration (flagged by FX-B2 QC out-of-scope observation):** `research-prompt-creator/SKILL.md § S-03 (Country-Parity Enforcement Gate)` — at the time of the FX-B2 commit, line 142 still hardcodes `Sweden block → Norway block → Finland block → pan-Nordic synthesis last` and lists SVCA / Bolagsverket / NVCA / Brønnøysund / FVCA / PRH as example sources. This is S-03 (country routing), not S-04 (language blocks), so FX-B2 left it untouched — but it is the same "Nordic project content baked into a canonical skill" pattern. When B-04 is scheduled, evaluate whether the S-03 country-routing chunk in `research-prompt-creator` itself should be extracted in the same wave (likely as a `reference/country-routing.md` per-project file paired with the existing `Country set:` Project Config field). Defer-or-bundle decision belongs to the Friday-cadence triage.
- **Trigger (whichever fires first):**
  - The next research project declares `Languages:` with a non-Nordic set OR `Country set:` outside `[SE, NO, FI, DK]` (the current canonical-skill-hardcoded set).
  - Next Friday `/friday-checkup` cadence.
  - Operator explicitly raises it.
- **Target files (when executed):** `ai-resources/skills/execution-manifest-creator/SKILL.md` (loader stanza replacing hardcoded country routing); new `ai-resources/workflows/research-workflow/reference/{routing-or-country-set}.template.md` (canonical fillable); project-side instance file(s) for nordic-pe + buy-side + any future research projects.
- **Triage cadence:** next Friday `/friday-act` wave; treated as the Phase 2 follow-on companion to FX-B2.

### 2026-05-28 — placement-verifier four-pipeline extension (deferred Stage B scope)

- **Status:** logged (pending)
- **Category:** Placement-discipline / canonical-pipeline coverage
- **Source:** `/route-change` → `/placement` rename + verifier session (2026-05-28). SO advisory item #1 (post-write placement verifier) shipped lean — `docs/placement-verifier.md` procedure + integration into `/graduate-resource` only. Four other canonical creation pipelines (`/create-skill`, `/improve-skill`, `/migrate-skill`, `/new-project`) were deliberately left untouched per SO `Architectural Commentary § M1` and `principles.md § DR-7` (generalize on confirmed second-consumer evidence, not by analogy).
- **Risk if left undone:** placement misses inside the four un-integrated pipelines remain silent — same leak the verifier exists to close. Acceptable at v1 because `/graduate-resource` is the highest-leverage placement decision; other pipelines have stronger structural defaults (skill scaffolds always land in `skills/<name>/`; project scaffolds always land in `projects/<name>/`).
- **Proposal:** Extend the placement-verifier integration into a second pipeline when ANY of these fire: (a) an observed placement miss inside `/create-skill`, `/improve-skill`, `/migrate-skill`, or `/new-project` surfaces in `friction-log.md` (the canonical signal for placement misses per workspace CLAUDE.md § Placement Discipline); (b) the `/graduate-resource` verifier integration generates ≥2 MISMATCH events in a Friday-checkup window (indicates the pattern is load-bearing); (c) operator dispositions this in a Friday-act wave on judgment alone. When triggered, integrate one pipeline at a time — DR-7 / AP-7 still bites if all four are added pre-emptively.
- **Target files (when executed):** `ai-resources/.claude/commands/{create-skill | improve-skill | migrate-skill | new-project}.md` (one at a time) — add Step Xa (plan-time gate) and Step Yb (end-time gate) mirroring `/graduate-resource` Steps 3a and 5a. No changes to `docs/placement-verifier.md` itself (already designed to support any pipeline).
- **Triage cadence:** opportunistic — gated on the three triggers above, not on a fixed cadence.

### 2026-05-28 — Extract Q1–Q8 placement logic into shared SKILL.md (SO advisory item #2)

- **Status:** logged (pending)
- **Category:** Placement-discipline / DR-7 shared-judgment surface
- **Source:** SO advisory delivered as part of the `/route-change` → `/placement` rename session (2026-05-28). Original advisory recommended a shared SKILL.md that both `/placement` and the verifier consume; operator chose to ship only item #1 first.
- **Proposal:** Extract the Q1–Q8 placement heuristics currently embedded in `docs/repo-architecture.md § Placement heuristics` into a shared `skills/placement-classification/SKILL.md`. Both `/placement` and `docs/placement-verifier.md` then `Read` the SKILL.md instead of carrying their own classification logic. DR-7 trigger: `/placement` (consumer 1), `placement-verifier.md` (consumer 2) — second consumer is confirmed and the bar is met.
- **Risk if left undone:** classification logic remains split between `/placement`'s Step 3 (Q1–Q8 walk) and `placement-verifier.md`'s canonical-home lookup. Drift between the two is currently unguarded — a future edit to one could leave the other behind.
- **Target files (when executed):** new `ai-resources/skills/placement-classification/SKILL.md`; `ai-resources/.claude/commands/placement.md` Step 3 (Read-and-apply the SKILL.md); `ai-resources/docs/placement-verifier.md` Method (Read-and-apply the SKILL.md); `ai-resources/docs/repo-architecture.md § Placement heuristics` (becomes a pointer to the SKILL.md rather than the source of truth).
- **Triage cadence:** next Friday `/friday-act` wave that also touches `/placement` or `placement-verifier.md`, OR when item #1's four-pipeline extension fires (above) — that extension's second integration is the natural moment to extract the shared skill.

### 2026-06-04 — Graduation verdicts recorded at wrap without the second-consumer test (DR-7/AP-7); stale GRADUATE propagates until a later gate catches it
- **Status:** logged (pending)
- **Category:** principle-drift
- **Provenance:** wrap-collector (machine-authored) 2026-06-04
- **Friction source:** wrap-collector 2026-06-04 — principle-drift (S6 § Decisions + § Outcome). The S5-wrap recorded a GRADUATE verdict for E1 (`doc-scanner-agent`) that skipped the DR-7/AP-7 second-consumer test; `doc-scanner-agent` is N=1 (genuinely project-local to repo-documentation), and `auto-sync-shared.sh` would have fanned it out as symlinks into ~10 unrelated projects. S6's Stage-0 `/risk-check` + system-owner caught the stale verdict and reversed it to KEEP-LOCAL. This is the second same-day instance of a stale graduation/resolution verdict — E4 (`resolve-improvement-log`) carried a stale GRADUATE caught and corrected to CONFIRMED-DONE in S5. Same defect class: a graduate/resolve verdict is written into the strategic-os Slot-1 records at wrap time without applying the second-consumer (DR-7) or ground-truth (already-shipped) check, so the wrong verdict propagates across sessions until a downstream gate happens to re-examine it.
- **Proposal:** When a session records a GRADUATE verdict for a candidate resource into the AI-strategy Slot-1 records (`slot-1-decisions.md` / `implementation-tracker.md`), require the DR-7/AP-7 second-consumer test be explicitly applied and noted in the verdict line — count distinct real consumers and name `auto-sync-shared.sh` symlink fan-out as the blast-radius constraint. Candidate placements: a one-line gate in `/graduate-resource` plan-time (the canonical graduation pipeline — confirm it already enforces the second-consumer test and that this bypass was a wrap-time record-only shortcut, not a pipeline gap), and/or a checklist note in the AI-strategy slot-closure convention so a "GRADUATE" verdict cannot be written without the consumer count. Two same-day instances (E4, E1) make this a pattern, not a one-off.
- **Target files:** (to be determined at disposition) — likely `ai-resources/.claude/commands/graduate-resource.md` (verify/strengthen the plan-time second-consumer gate); possibly the AI-strategy slot-closure convention doc under `projects/strategic-os/ai-strategy/` that governs how GRADUATE verdicts are recorded.

### 2026-06-04 — Step 3.5 CONCURRENT block strands a no-own-marker session whose work is already committed (remediation-ergonomics gap)
- **Status:** logged (pending) — **Friday-act 2026-06-05 (session-harness #5) triage verdict: DEFER.** Consistent with this entry's own classification: the recommended wrap-lite fix is Structural (/risk-check change class — it restructures the Step 3.5 CONCURRENT shared-state staging logic across both `wrap-session.md` copies). Out of scope for a multi-item friday-act sweep; hold for a dedicated /risk-check session per the proposal below.
- **Category:** session-issue
- **Source:** /resolve-repo-problem AUTO mode 2026-06-04
- **Friction source:** During the /fix-repo-issues 1942 wrap (a no-/session-start session: `/prime` brief → `/fix-repo-issues` → execute → `/wrap-session`, so NO per-id marker, NO mandate, authored NO `## … — Session` header), the Step 3.5 guard correctly fired CONCURRENT (FOREIGN=1) because a concurrent S8 session's today-header + mandate (line 480) were uncommitted in `logs/session-notes.md`. The guard behaved correctly — this was the **first live validation** of the no-own-marker fix `003f8ba` (id-34): NO_OWN_MARKER=1 → OWN_SUBTRACT=0 → S8's content flagged foreign instead of a silent false-negative. Residual issue: this session's own work was already committed (ai-resources `376df95`, research-pe `84f1416`) and it had nothing of its own to add to `session-notes.md` beyond the wrap note, yet it cannot complete its wrap rituals (session note, Step 6.4 outcome, Step 6.5 feedback collection) without staging the contended `session-notes.md`. The only offered remediation ("wrap the other session first") couples wrap ordering and can strand the blocked session indefinitely if the concurrent session is mid-task.
- **Proposal (recommended — Structural; /risk-check change class):** Add a "wrap-lite" sub-path to the Step 3.5 CONCURRENT branch for the specific case `NO_OWN_MARKER=1 AND the session's own work is already committed AND FOREIGN_CLASS=CONCURRENT`: let the session complete its wrap WITHOUT staging `session-notes.md` — skip the Step 4 session-note append (its state is already preserved in the continuity scratchpad written at Step 0.5 + its own commit messages), still run Step 6.4/6.5 against its committed files, and commit only its own already-modified files. This unblocks the wrap without the forbidden union-commit and without the wrap-ordering dependency. A heavier alternative (if losing the structured note is unacceptable): write the wrap note to a per-session sidecar `logs/session-notes-pending/{session-id}-{ts}.md` that `/prime` or the next wrap merges into `session-notes.md`. Distinct from id-34 (2026-06-04, the DETECTION fix — now committed `003f8ba` and live-validated here; its improvement-log entry should be flipped to applied+Verified by the S8 wrap that landed it) and from id-36 (the same-day unwrapped-notes accumulation pattern, watch-only) — this entry is about the REMEDIATION path for the now-correctly-detected no-marker CONCURRENT case, not detection or accumulation. Touches both `wrap-session.md` copies → /risk-check before landing.
- **Target files:** `ai-resources/.claude/commands/wrap-session.md` Step 3.5 (CONCURRENT branch — add the no-own-marker wrap-lite sub-path); `/.claude/commands/wrap-session.md` (workspace-root paired sibling per PAIRED CONTRACT); possibly `docs/session-marker.md` (document the wrap-lite path for no-marker sessions).

---

### 2026-06-05 — id-39 — Read() deny rules: workspace-root scope design (deferred)

*(Header normalized 2026-07-03 S7 from a malformed `## id-39 —` h2 to the schema's dated h3 form — the malformed level made `^### ` entry counts non-deterministic, friction 2026-07-03 S1.)*

- **Status:** pending
- **Severity:** MED
- **Category:** token-efficiency / settings
- **Source:** friday-act 2026-06-05 settings-permissions plan item 2; deferred at S3 execution
- **Friction source:** Proposed `Read(audits/**)`, `Read(logs/scratchpads/**)`, `Read(projects/*/output/**)` deny rules at workspace-root settings.json were flagged by /risk-check (PROCEED-WITH-CAUTION, hidden-coupling High): `audits/**` pattern was deliberately retired 2026-04-28 and would break active auditor summary reads; `logs/scratchpads/**` would break `/prime` scratchpad resume. ai-resources settings.json already has partial Read() deny coverage; workspace root has zero.
- **Proposal (recommended):** Design workspace-root Read() deny rules that mirror the ai-resources pattern (archive dirs, deprecated, old) WITHOUT covering active working dirs (audits/working, logs/scratchpads, any dir that /prime, /wrap-session, or auditor subagents read at runtime). Candidate safe additions: `Read(logs/*-archive-*.md)`, `Read(**/deprecated/**)`, `Read(**/old/**)`. Extend research-pe coverage to match. Run /permission-sweep --dry-run first to see what current gaps exist. Full scope design should confirm no overlap with dirs any active command reads.
- **Target files:** `/.claude/settings.json` (workspace root), `projects/research-pe-regime-shift-advisory-gap/.claude/settings.json`
- **Blocked by:** scope design work (need to audit which dirs are safe to deny)

### 2026-06-05 — Concurrent-session collision: structural fix progress + §9.2 namespacing DECISION (S8)
- **Status:** Mode-A structural fix SHIPPED S8 (2nd batch). `/new-worktree-session` command built + the SessionStart hook sharpened into an auto-nudge (batched /risk-check GO, `audits/risk-checks/2026-06-05-new-worktree-session-command-plus-hook-nudge.md`). Option B.1 (Mode-B namespacing) **DECLINED** — see §9.2 decision below. Remainder still deferred. Supersedes the prior "deferred structural program" framing of this entry.
- **Category:** session-issue / marker-contract
- **Source:** `audits/2026-06-05-concurrent-session-collision-diagnostics-fix.md` § 6–§ 9 (authoritative design home; do NOT re-derive — read the report).
- **§9.2 DECISION — per-session log namespacing (Option B.1) DECLINED 2026-06-05 (S8).** The report's "central B decision" (namespacing vs. file-ownership-map discipline) is resolved AGAINST namespacing, on evidence gathered via a full writer/reader blast-radius map: (1) **Mode B has not actually occurred** — every collision in the report §3 recurrence table is Mode A (same-checkout), not shared-bookkeeping. (2) The workspace already disambiguates the shared `session-notes.md` by marker-bearing header (`## … — Session S{N}`) — a simpler model than per-file namespacing — and the other append-only logs append atomically (heredoc/printf). (3) Namespacing would touch ~8 shared logs + ~8 consumers that assume a single consolidated file (Friday cadence, `/prime` scan, `/open-items`, `/resolve-improvement-log`, `fix-repo-issues-scanner`…), and its required merge-back reconciliation step is itself a race-prone shared write — it reintroduces the very class it aims to remove. (4) Low-regret to decline — if a real Mode-B collision is ever confirmed, namespacing can be built then. **Mode B stays covered by:** the existing marker/header model + the file-ownership-map discipline (`parallel-sessions-playbook.md` §§ 2–3) + the already-logged `improvement-log.md` read-during-rewrite append-discipline fix (the one genuine Mode-B-adjacent hazard, and an append-not-rewrite fix, not a namespacing fix). **Reopen trigger:** a confirmed shared-log collision under worktrees.
- **Done this session (S8 2nd batch):**
  - **Item 3 — `/new-worktree-session` command: SHIPPED** (was "deferred fast-follow"). Sonnet orchestration wrapper around `git worktree add … -b session/{date}-{unit} main`; cites the playbook as authority; reuses `/cleanup-worktree` + `/monday-prep` for teardown/inventory.
  - **Item 4 (partial) — same-checkout NUDGE: SHIPPED.** The hook now emits a SHARP /new-worktree-session nudge when count≥2 AND a today-marker exists in this checkout (heuristic same-checkout signal), SOFT warning otherwise. The PRECISE lsof/cwd detector remains deferred (brittle) — only the nudge, not full detection, landed.
  - **Project-local hook copy: SYNCED** (was the "immediate follow-up"). `projects/research-pe-regime-shift-advisory-gap/.claude/hooks/detect-concurrent-session.sh` brought byte-identical to canonical (diff empty). Note: that copy is not wired into its own settings.json (pre-existing per 2026-06-02 DD), so the sync prevents advice drift without changing live behavior there.
- **Still deferred (each needs its own `/risk-check`):**
  1. **Option B.1 — per-session log namespacing** — DECLINED (see §9.2 above); reopen only on a confirmed Mode-B collision.
  2. **Option B.2 — `.gitignore` the transient markers workspace-wide** (`git rm --cached logs/.prime-mtime logs/.session-marker` + `.gitignore`; likely every project). (Report § 6 Option B.2.)
  4. **Full A.2 — same-checkout-vs-separate-worktree DETECTION** via `lsof`/cwd (the nudge shipped; precise detection did not). (Report § 7 Phase 1 step 4.)
  5. **Phase 3 — retire now-redundant guards** ONLY after worktrees validate (Phase 4). Never bundle with the structural changes. (Report § 7 Phase 3.)
  - Plus (separate entries): reader-side NO_OWN_MARKER hardening; the `improvement-log.md` read-during-rewrite append-discipline fix.
- **Target files:** see report § 6–§ 9 per remaining item.

### 2026-06-05 — Research-workflow canonical fix F1: sync-on-entry / deployment-freshness discipline (DEFERRED)
- **Status:** deferred — requires dedicated canonical-change session
- **Category:** workflow / template-maintenance
- **Source:** `projects/research-pe-regime-shift-advisory-gap/audits/post-project-review-canonical-fix-plan-2026-06-05.md` § F1
- **Why deferred:** Heavy scope (spans `sync-workflow.md` freshness-report mode, `run-preparation.md` Step 0 gate, SessionStart drift nudge escalation, and a new `docs/sync-and-authority.md` authority rule doc); requires `/risk-check` + `/graduate-resource`; F3 depends on the authority doc this creates. Prerequisite: verify `/sync-workflow` can classify drift direction (canonical-ahead vs project-ahead) before encoding the authority rule.
- **Proposal:** Open a dedicated canonical-change session. Implement: (1) `/sync-workflow` freshness-report mode; (2) `run-preparation.md` Step 0 soft gate (detect template drift → require sync-or-acknowledge once, at Stage 1 entry); (3) escalate SessionStart drift nudge to acknowledged prompt for research-pipeline sessions; (4) new `docs/sync-and-authority.md` declaring which side wins when project stage-instructions and canonical skills disagree. F3 lands after F1's authority doc.
- **Review-cycle:** monthly

### 2026-06-05 — Research-workflow canonical fix F3: cluster-memo-refiner check-count declared contract (DEFERRED)
- **Status:** deferred — depends on F1's authority doc
- **Category:** workflow / skill-contract
- **Source:** `projects/research-pe-regime-shift-advisory-gap/audits/post-project-review-canonical-fix-plan-2026-06-05.md` § F3
- **Why deferred:** Couples to F1 — the declared contract references F1's sync-and-authority.md doc. F1 must land first.
- **Proposal:** After F1 ships: make the refiner check-count a declared contract in `cluster-memo-refiner/SKILL.md` — checks 8–10 (permission-class, country-parity, source-conflict) run only when no downstream `/run-sufficiency` phase owns them; a project declares ownership in its stage-instructions. Default: checks 1–10 (no behavior change for existing consumers).
- **Review-cycle:** monthly

### 2026-06-05 — Research-workflow canonical fix F5: confirm 1M gate mechanism + add Step 0 pre-dispatch guard (DEFERRED)
- **Status:** deferred — empirical investigation precondition unresolved
- **Category:** workflow / session-model-policy
- **Source:** `projects/research-pe-regime-shift-advisory-gap/audits/post-project-review-canonical-fix-plan-2026-06-05.md` § F5
- **Why deferred:** The operating rule is contradicted: S6 found per-dispatch `model:` override insufficient (only `/model` switch cleared the gate), but S8 and S1 both cleared the gate via per-dispatch overrides. The fix plan says not to encode a guard on top of an unconfirmed mechanism. Investigation must precede the edit.
- **Proposal:** Dedicated investigation session: confirm empirically whether per-dispatch `model: opus/sonnet` override clears the 1M-context credit gate from a live `[1m]` session. If confirmed, the fix is: (a) correct the run-report.md policy block to reflect confirmed behavior + (b) add a Step 0 pre-dispatch check that warns if a dispatch lacks an explicit model: pin. If not confirmed, add a Step 0 hard stop ("switch to standard-context model via `/model` before continuing"). Requires `/risk-check` (model-policy / harness-adjacent change).
- **Hint from S8+S1:** Both sessions cleared the gate via per-dispatch overrides, supporting "override works." S6 contradiction may have been a different session state — worth checking whether the S6 session had a non-standard alias configuration.
- **Review-cycle:** monthly


### 2026-06-08 — Move feedback-collector dedup off every wrap onto the Friday cadence (DEFERRED)
- **Status:** deferred — separate redesign session
- **Category:** wrap-pipeline / cost-structure
- **Source:** plan `let-s-figure-out-a-reflective-lovelace.md` Follow-ups item 1; SO consult 2026-06-08 (transcript item 3). Companion to the shipped grep-first dedup fix (commit 9f66e6f).
- **Why deferred:** Bigger redesign than the contained grep-first fix already landed. The contained fix removes most of the per-wrap cost; this would remove the rest by structure. Touches where the dedup-and-route work lives, not just how it reads.
- **Proposal:** Have `/wrap-session` Step 6.5 drop a cheap raw "signals" stub per session (no cross-corpus dedup), and have the weekly Friday cadence do the expensive dedup-and-route once over all the week's stubs at once. Pays the dedup tax once/week instead of once/session. Requires `/risk-check` (canonical agent + wrap-command change) and a decision on where the stub store lives.
- **Review-cycle:** monthly

### 2026-06-08 — .claude/ git-hygiene Option B (W24 item 2) — PARKED (broken premise)
- **Status:** parked — premise incoherent; re-open only if a concrete churn or storage pain is observed
- **Category:** git-hygiene / symlink-topology
- **Source:** W24 mandate item 2 (decisions-archive-2026-06.md, commit 2d1e11d). Investigated 2026-06-08 S3; SO advisory consult-2026-06-08-git-hygiene-option-b-review.md.
- **Why parked:** (1) Premise is a no-op: `.gitignore` stops git tracking but does not remove files from disk; the sync hook never overwrites an existing target (`repo-architecture.md § Symlink topology rule 1`), so a gitignored-but-still-present file is skipped forever. The "regenerate at SessionStart" mechanism only works if the target is absent — which requires `git rm --cached` + disk delete first, making this a structurally heavier change than the W24 framing implied. (2) Problem is not material: churn across 13 project repos is 1–7 commits/90d, all intentional work (local command builds, one-time bulk syncs, fork graduations) — not auto-generated noise. (3) Zero broken symlinks across 12/13 projects; the one broken symlink in research-pe-regime-shift-advisory-gap is a `/fix-symlinks` job. (4) The 2026-06-04 risk-check returned RECONSIDER on this exact change class; executing without re-gating is disallowed (DR-8). (5) SO confirmed: park it unless/until churn is a felt operational problem.
- **Proposal:** If re-opened: (1) Rewrite premise to real sequence — `git rm --cached` → delete from disk → `.gitignore` → let hook re-symlink. (2) Run plan-time `/risk-check` (own gate, not the 2026-06-04 one). (3) Pilot on one project (pick one with no real tracked files in .claude — e.g., marketing-positioning or nordic-pe-screening). (4) Validate hook re-creates symlink on next session start before rolling out. (5) Update `repo-architecture.md § Symlink topology` in the same commit.
- **Review-cycle:** quarterly

### 2026-06-08 — Option B: promote the cross-class collapse rule to the canonical research-workflow template (DEFERRED)
- **Status:** deferred — canonical-tier contract change; deserves its own `/risk-check` envelope + a template-fitness pass (NOT a tail-end rider on the project-local Option A landing)
- **Category:** research-workflow / canonical-template-promotion / claim-permission-chassis
- **Source:** the #23 Option-A landing (2026-06-08 S2). Risk-check `2026-06-08-strengthen-the-canonical-triangulation-packets-rule-in-the.md` (PROCEED-WITH-CAUTION) + system-owner second opinion both recommended Option A now / Option B deferred. **This entry is the OP-11 "log the divergence loudly" requirement — without it, the Option-A landing would be silent canonical drift.**
- **The divergence (what is now out of sync):** the project-local `projects/research-pe-regime-shift-advisory-gap/reference/quality-standards.md § Source-Diversity Matrix` carries the strengthened cross-class collapse clause; the canonical copies do NOT. Four canonical surfaces still on the same-class-only formulation:
  1. `ai-resources/workflows/research-workflow/reference/quality-standards.md:137` (rule shape — needs the cross-class clause).
  2. `ai-resources/workflows/research-workflow/reference/claim-permission.template.md:35` (the `(canonical)`-marked rule text).
  3. project-local `reference/claim-permission.template.md:35` (the project's own template copy — also still weak; only the project's *live* quality-standards.md was edited).
  4. The two canonical SKILLs (`research-extract-creator` consumption note, `cluster-memo-refiner` Check 9 example) are ALREADY split-aware (edited S2) — they describe the per-project split, so they do NOT need re-editing for Option B; verify they remain accurate when the template gains the rule.
- **Proposal:** Dedicated template-promotion session: (a) re-`/risk-check` framed for the canonical blast radius (every future research-workflow instantiation gains the stronger rule); (b) edit the two canonical `research-workflow/reference/` copies + the two `claim-permission.template.md` copies in lockstep so the rule shape matches across all four; (c) run a template-fitness pass (does the rule read correctly for a project that has NOT yet authored extracts?); (d) confirm the split-aware SKILL wording still parses once the template default flips. `/qc-pass` + commit.
- **Review-cycle:** monthly

### 2026-06-08 — PreToolUse commit-block hook for QC-PENDING architectural changes (parked)
- **Status:** logged (pending)
- **Category:** Audit-recurrence prevention
- **Source:** System Owner advisory (2026-06-08) on the QC-unreachable architectural-commit-block design. SO recommended a reactive rule + wrap-time guard now, and parking the hook (AP-7/DR-7 — speculative complexity at v1).
- **Proposal:** Build a `PreToolUse(Bash)` hook that blocks `git commit` when an unresolved `**QC-PENDING:**` scratchpad in `logs/scratchpads/` names an artifact present in the staged set. NOT built at v1 — the shipped layers cover the gap without a hook: the `qc-independence.md` escalation clause (reactive), the handoff QC-PENDING convention, `/prime` Step 1b recognition + supersession-exemption, and the `/wrap-session` Step 12c commit guard. A commit-block hook adds a permission-surface and a maintenance burden that is only justified if the layers above prove insufficient.
- **Target files:** `.claude/hooks/` (new hook), `.claude/settings.json` (PreToolUse registration)
- **Review-cycle:** reviewed 2026-06-08, deferred to recurrence of the QC-PENDING limbo gap — i.e. a self-QC'd or un-QC'd architectural change reaching commit despite the reactive rule + wrap guard, logged in `friction-log.md`. Graduate the hook only on that concrete trigger.

### 2026-06-09 — fix-spec Milestone 4: two explicit follow-ups (canonical-template propagation + #24 register-template promotion) (DEFERRED)
- **Status:** logged (pending)
- **Category:** canonical-template-sync + cross-tier-coupling
- **Source:** System Owner second opinion (2026-06-09 S1) on the Milestone 4 `/risk-check` (PROCEED-WITH-CAUTION). SO §3(iii): editing 3 canonical files while 11 are already drift-flagged means the close-out is where the risk concentrates; SO §3(i): a canonical skill (`execution-manifest-creator`) now depends on a *project-local* #24 register not carried by the canonical template — graceful-absent demotes it from guarantee to best-effort.
- **Proposal:** (1) **Canonical-template propagation** — the Milestone 4 edits to `execution-manifest-creator/SKILL.md` (+ `references/manifest-template.md`) and `research-prompt-creator/SKILL.md` are canonical symlinked-skill edits; propagate to consuming projects via `/sync-workflow`, NOT hand-copy. The canonical-template propagation is itself a drift-creation event for the 11-file drift already flagged on this project. (2) **#24 register-template promotion** — promote an empty `## Known-Unavailable-Evidence Register` slot into `ai-resources/workflows/research-workflow/reference/known-limits.template.md` so the canonical skill's #24 dependency is a structural guarantee, not best-effort. Until then, the graceful-absent skip + loud degraded-mode note (shipped this session) is the interim mitigation.
- **Target files:** consuming-project skill symlinks (via `/sync-workflow`); `ai-resources/workflows/research-workflow/reference/known-limits.template.md`
- **Review-cycle:** monthly

### 2026-06-09 — refresh-project-state: two forward structural hardenings for the confidentiality read-surface (DEFERRED)
- **Status:** logged (pending)
- **Category:** workflow-hardening + new-change-class
- **Source:** refresh-project-state Session 2 (land + wire + validate), 2026-06-09 S1. Surfaced during GO-gate G1/G2 reframing after a Claude Code permission-mechanics finding (deny rules are per-session not per-path; subagents inherit the parent session's settings; `additionalDirectories` grants access without loading the target's deny list). System-owner consult (`projects/axcion-ai-system-owner/output/consultations/consult-2026-06-09-g1-g2-gate-reframing-refresh-project-state.md`) directed both items OUT of the landing session (each is a new `/risk-check` change class — bundling them would be scope expansion past the confirmed task, DR-7/AP-7). Session landed G1 as Option C (workspace-root Read-deny + command self-verify-abort) and G2 as detect-and-contain; these two are the deferred structural upgrades.
- **Proposal:**
  1. **Path-aware PreToolUse Read-block hook (the genuinely-structural G1).** A `PreToolUse` hook that inspects the actual `file_path` per Read call and blocks `*deal-*`/`*client-*`/`*confidential*` regardless of session root — the per-call enforcement the session-level deny only approximates. Idiomatic to this repo (cf. `check-heavy-tool.sh`, `warn-settings-change.sh` per-call inspection; `blueprint.md § 3.4`). The same hook would also harden G2's write boundary (the single-writer orchestrator is currently a *soft contract* under bypassPermissions, not enforced). New hook-edit change class (`risk-topology.md § 3`) → own `/risk-check`, own session. NOTE the known limit: a filename-token hook does not close the dominant threat (client names embedded in normally-named files) — that stays with the scrub-verifier.
  2. **Manifest-driven snapshot read-set (higher-leverage).** Have the orchestrator hand each `project-state-snapshot-agent` an explicit safe file list instead of broad Read access — shrinks the broad-Read surface structurally rather than patching it with a deny/hook. Per system-owner, the higher-leverage of the two. Connects to the scrub-verifier's already-optional "known-entity list" input (Pass A) — a manifest could feed both ends.
- **Target files:** `ai-resources/.claude/hooks/` (new hook, item 1); `ai-resources/.claude/commands/refresh-project-state.md` + `ai-resources/.claude/agents/project-state-snapshot-agent.md` (item 2)
- **Review-cycle:** monthly

### 2026-06-09 — check-foreign-staging.sh fails open for footprint-less sessions (latent concurrency gap) (PENDING)
- **Status:** logged (pending)
- **Category:** guardrail-candidate
- **Severity:** low
- **Provenance:** wrap-collector (machine-authored, manually re-appended after a collector write incident) 2026-06-09
- **Friction source:** wrap-collector 2026-06-09 — safety / guardrail-gap (S5)
- **Proposal:** The new PreToolUse(Bash) staging tripwire (Fix 2, S5 — `check-foreign-staging.sh`) fails open when a session has no resolvable footprint (no marker, no `- Files in scope:` bullet, or an `(inferred)`/`(none stated)` bullet) — so a primed-but-not-planned or inferred-footprint session, the highest-risk concurrency scenario, gets no foreign-staging protection. Consider a complementary minimum guard (e.g., warn-and-pause when a gated git verb runs with no concrete footprint AND another session marker is present), or fold footprint-presence into the Fix 1 blocking SessionStart path. Same blind spot `concurrent-session-check.md` documents as its #1 failure.
- **Target files:** `.claude/hooks/check-foreign-staging.sh`; cross-ref `.claude/hooks/detect-concurrent-session.sh` (Fix 1).
- **Review-cycle:** monthly

### 2026-06-10 — Unmarked /clarify-first session risks false-CONCURRENT wrap guard in a shared checkout (PENDING)
- **Status:** logged (pending)
- **Category:** session-issue
- **Severity:** low
- **Provenance:** main-session (observed live at /wrap-session Step 3.5) 2026-06-10
- **Friction source:** /wrap-session Step 3.5 foreign-session guard 2026-06-10 — a session begun directly with `/clarify` (no `/prime`/`/session-start`) writes no per-id marker (`logs/.session-marker-${CLAUDE_CODE_SESSION_ID}`). At wrap it resolves `NO_OWN_MARKER=1`. In this incident the shared marker said `S2` and an earlier same-day session-id (`b9ae39e9`, which did the Fix 4(a) work) still owned the only per-id marker + the `## 2026-06-10 — Session S2` header. The wrap escaped a false STOP ONLY because that prior S2 content was already committed (`ADDED_HEADERS/MANDATES=0 → FOREIGN=0`). Had the prior same-operator work been uncommitted in the shared checkout, the guard would have mis-classified the operator's own sequential prior work as a CONCURRENT foreign collision and STOPPED the wrap — a false positive.
- **Proposal:** The `NO_OWN_MARKER=1` STOP path in `wrap-session.md` Step 3.5 does not yet use the new per-id liveness signal (Fix 1, 2026-06-10) to tell a genuinely-live concurrent session apart from an already-wrapped/committed same-day sibling in the same checkout. Recommended fix: before declaring CONCURRENT for a no-own-marker session, check whether the foreign per-id marker corresponds to genuinely-uncommitted today-content (live) vs content already in HEAD (benign sequential, e.g. a restart that changed CLAUDE_CODE_SESSION_ID but kept the same `S{N}` day-slot). If all today-content is in HEAD, proceed instead of STOP. This is a /risk-check change class (canonical command edit, auto-synced to ~20 sites) — gate before landing. Lower-effort alternative: have the no-own-marker wrap append its note under a distinct `(cont.)` header rather than contesting the existing `S{N}` header, and document that /clarify-first sessions are unmarked by design (clarify.md Step 0 already nudges this).
- **Target files:** `ai-resources/.claude/commands/wrap-session.md` (Step 3.5 NO_OWN_MARKER branch); cross-ref `ai-resources/.claude/hooks/detect-concurrent-session.sh` (Fix 1 per-id liveness signal) + `ai-resources/docs/session-marker.md`.
- **Review-cycle:** monthly

### 2026-06-10 — Pre-build environment-fit check for launch/runtime-gated tooling
- **Status:** pending
- **Category:** session-feedback
- **Severity:** low
- **Provenance:** wrap-collector (machine-authored, hand-routed by main session — collector hit Constraint E on improvement-log) 2026-06-10 S3
- **Friction source:** S3 built `scripts/cc-worktree.sh`, a terminal launcher, which shipped inert because the operator launches via the VS Code extension (open folder/window), not a terminal. The mismatch was discoverable upfront with one question; it surfaced only after the build, risk-check, QC, and commit. Wasted-build churn partly mandate-inherited (option b was an explicit operator `go`).
- **Proposal:** Add a lightweight pre-build environment-fit check for tooling whose value is gated on launch/runtime environment (terminal vs VS Code extension, shell, OS entrypoint). Natural homes: `/scope` or `/session-plan` — when the work product is an executable/launch artifact, prompt "what environment does the operator trigger this in?" before building. Fold in the `feedback_vscode_launch.md` auto-memory fact (Patrik = VS Code launch) so the check can self-answer for known cases.
- **Target files:** candidates `ai-resources/.claude/commands/scope.md`, `ai-resources/.claude/commands/session-plan.md`; cross-ref auto-memory `feedback_vscode_launch.md`.
- **Review-cycle:** monthly

### 2026-06-12 — Non-/prime session start writes no per-id marker → per-id-marker guards fall back to clobberable shared marker
- **Status:** logged (pending)
- **Category:** guardrail-candidate
- **Severity:** low
- **Provenance:** wrap-collector (machine-authored) 2026-06-12
- **Friction source:** wrap-collector 2026-06-12 — safety / guardrail-gap (S4 cont., /log-sweep cross-project archival)
- **Proposal:** S4 launched directly via `/log-sweep` (no `/prime`/`/session-start`), so it never wrote its per-id marker `logs/.session-marker-${CLAUDE_CODE_SESSION_ID}`. `check-foreign-staging.sh` then fell back to the shared `logs/.session-marker`, which a concurrent session (editing `.claude/settings.json`) kept rewriting — blocking S4's ai-resources commit 3x until S4 hand-wrote the missing per-id marker mid-run. Per-id-marker establishment should not be `/prime`-only: any session-start path that may commit in a shared checkout (`/log-sweep`, `/clarify`, `/friday-*`) should establish the deterministic per-id marker the staging/concurrency guards consume, so they never degrade to the shared marker. Generalizes the same root cause as the 2026-06-10 "Unmarked /clarify-first session risks false-CONCURRENT wrap guard" entry — different consumer (that is `/wrap-session` Step 3.5 false-STOP at wrap; this is `check-foreign-staging.sh` block-thrash at mid-session commit). Operator-flagged candidate in S4 Next Steps.
- **Target files:** (to be determined at disposition) — candidate: a shared session-marker-establishment primitive consumed at every session-start path; `ai-resources/.claude/hooks/check-foreign-staging.sh`; cross-ref `ai-resources/docs/session-marker.md` + the 2026-06-10 unmarked-/clarify entry + the 2026-06-09 footprint-less fail-open entry.
- **Review-cycle:** monthly

### 2026-06-12 — split-log.sh tripwire propagation to 11 deployed copies (named trigger)
- **Status:** logged (pending)
- **Category:** propagation
- **Severity:** medium
- **Provenance:** risk-check 2026-06-12 S10 residual risk #1 (SO second opinion, consult-2026-06-12-risk-check-2nd-opinion-s10-fix-batch.md)
- **Proposal:** The 11 deployed project-local `split-log.sh` copies (re-synced 2026-06-12 S7, f84f601) do not yet carry the S10 conservation tripwire — non-uniform-guarantee window until re-synced. **Named trigger: the next `/sync-workflow` run OR the next Friday cadence session, whichever comes first.** Re-sync is mechanical (S7's 11-target list + cmp byte-identity per copy); exclude the frozen archive copy per the S7 decision.
- **Deprioritized (operator, 2026-06-12 S11):** the operator marked this item "not important anymore" during the S11 prime menu. Note: the named trigger technically fired in S11 (a `/sync-workflow` run on positioning-research happened that session) but propagation was NOT executed per the operator's deprioritization. Entry stays pending at lowered priority; treat the next Friday cadence as a soft trigger only — confirm with the operator before executing.
- **Target files:** the S7 11-copy target list (see decisions.md 2026-06-12 S7 entry); canonical source `ai-resources/logs/scripts/split-log.sh`
- **Review-cycle:** weekly

### 2026-06-12 — Mission promote-rw-canonical close findings: SETUP.md stale copy-path + 2 project down-ports + unanchored archive/ gitignore (PENDING)
- **Status:** logged (pending) — item 1 done 2026-07-03 (SETUP.md Step 1 path corrected: the template IS `ai-resources/workflows/research-workflow/`; copy-from-workspace-root clarified). Item 0 done 2026-07-03 S7 (`.gitignore` anchored to `/archive/`, gated in the S7 batched risk-check, commit `c9b4fe0`; enumeration confirmed both mission-archive records were already tracked and nothing else newly exposed — `audits/working/archive/` stays ignored via its parent rule, `inbox/archive/` via its own line). Item 2 done 2026-07-03 S7 (`friction-log-auto.sh` down-ported byte-identical + PostToolUse `Bash|Write|Edit|Agent|Skill` wiring added; positioning-research commit `d931d29`). Only item 3 remains (positioning-research `run-execution.md` Check 4 — update available, project's choice when to take it).
- **Category:** template-defect + propagation
- **Severity:** low
- **Provenance:** S11 mission-close deploy-test + /sync-workflow run (2026-06-12)
- **Proposal:** Four follow-ups from the mission-close verification. (0) **`.gitignore` L42 `archive/` is unanchored** — it matches any `archive/` directory at any depth, not just the top-level one its comment names, so `logs/missions/archive/` (the mission-close destination prescribed by `/mission` Step 5) is silently gitignored; the closed-mission record had to be force-added (`git add -f`) in S11 to stay tracked. Fix candidate: anchor to `/archive/` — but first enumerate nested `archive/` dirs the unanchored pattern currently (perhaps intentionally) ignores; a gitignore edit is a structural change, gate it. (1) **SETUP.md Step 1 copy path is stale:** it reads `cp -r workflows/active/research-workflow/project-template/ ...` but neither `workflows/active/` nor a `project-template/` subdir exists — the template IS `ai-resources/workflows/research-workflow/` itself. A new deployer following Step 1 verbatim fails at the first command. Fix: correct the path and clarify that the whole directory is the template. (2) **positioning-research's `friction-log-auto.sh` lacks the C6 repair** (pre-C6 PreToolUse-only version, 1 "Friction Events" ref vs canonical's 4) — friction events from tool errors are not auto-captured in that project's sessions. Down-port from canonical (also needs the project's settings.json PostToolUse wiring — check before copying). (3) **positioning-research's `run-execution.md` lacks canonical's Check 4** (sampled scarcity-verdict independence check) — update available, project's choice when to take it.
- **Target files:** `ai-resources/workflows/research-workflow/SETUP.md` (Step 1); `projects/positioning-research/.claude/hooks/friction-log-auto.sh` + that project's `settings.json` (item 2); `projects/positioning-research/.claude/commands/run-execution.md` (item 3)
- **Review-cycle:** monthly

### 2026-06-12 — Routine-Yield Review in /pipeline-review: deferred build, named trigger (TRACK-FIRST)
- **Status:** logged (pending)
- **Category:** deferred-build
- **Severity:** low
- **Provenance:** use-case investigation 2026-06-12 (audits/use-case-routine-task-improvement-2026-06-12.md § 6)
- **Proposal:** The Routine Task Improvement System investigation closed TRACK-FIRST: the session-level 80/20 system (wrap-session Step 6.4 + friday-checkup item 14.5, both shipped 2026-06-12) must accumulate evidence before any routine-level build. **Named trigger: the first monthly-tier `/friday-checkup` after ≥3 Weekly Session Value Review sections exist (≈4 weeks).** At that point evaluate two questions from the accumulated roll-ups: (a) do the same recurring session types draw Batch/Redesign/Stop decisions ≥2–3 times without resolution? (b) does drag fail to attribute to a specific routine because data is session-grained? If either holds → build the trimmed SO shape: one monthly Routine-Yield Review section in `/pipeline-review` (comparative routine ranking, decision menu incl. Merge/Reduce-cadence/Automate, two guardrail rules, one-improvement-only; maintenance machinery mandatory in the ranking — registry targets already exist). If neither holds → close as DROP. Route the decision through `/friday-so`, which also owes the deferred SO confirmation of the inline TRACK-FIRST call (SO re-consult was credit-gate-blocked on 2026-06-12).
- **Target files:** (only if trigger fires) `ai-resources/.claude/commands/pipeline-review.md`; `ai-resources/audits/pipeline-review-registry.md` (mandatory-inclusion note)
- **Review-cycle:** monthly

### 2026-06-13 — Reusable `/create-requirements-doc` command (operator request)
- **Status:** logged (pending)
- **Category:** command/skill
- **Severity:** medium
- **Provenance:** operator request, marketing-positioning S3 (2026-06-13). Hand-built four requirements/scaffolding docs this session (5b/5c intake forms, target-client-profile creation guide, 7c Daniel review pack); operator asked for a reusable command so the pattern is repeatable.
- **Proposal:** Build a reusable `/create-requirements-doc` command (lives in `ai-resources/.claude/commands/`, graduated via `/request-skill` → `/create-skill`). Purpose: when Claude needs information, context, or a decision from the operator (or another Axcíon project) to proceed, it drafts the *scaffolding* — an operator-fillable doc that states exactly what is needed and why — so there is "something to work with" rather than an open-ended chat ask. **Operator design intent (load-bearing):** (1) **multi-stage** — e.g. gap-identification → scaffold-draft → self-check against "what do I actually need to proceed" → operator-fillable structure; (2) **QC-gated** — independent `/qc-pass` on the draft so the operator is confident the scaffolding is *exactly* what Claude needs to proceed successfully (the recurring failure mode this prevents: a requirements doc that asks for the wrong things, or misses a field, so the filled-in version still doesn't unblock the work); (3) honors the project "flag gaps, never invent" discipline — the command produces empty structure only, never invented content; (4) supports two recipients — the operator, or another Claude/Axcíon project (a cross-project information request). Pairs with the new workspace `CLAUDE.md` § "Requirements-Doc Default" rule (added same session) — that rule mandates the *behavior*; this command is the *tool* that implements it, so once shipped the rule should point at it.
- **Target files:** `ai-resources/.claude/commands/create-requirements-doc.md` (new); workspace `CLAUDE.md` § Requirements-Doc Default (repoint to the command once shipped); possibly a short `ai-resources/docs/` reference for the multi-stage contract.
- **Review-cycle:** monthly

### 2026-06-27 — Canonical-doc citations to `logs/decisions.md YYYY-MM-DD` go stale at monthly archival
- **Status:** logged (pending)
- **Category:** stale-reference / class-defect
- **Severity:** medium
- **Provenance:** mission `settings-path-portability` Group 3 close-out, 2026-06-27 S3. `permission-template.md:146` cited "(See logs/decisions.md 2026-05-16.)" as the authority for an "intentional and canonical" assertion. The 2026-05-16 entry was real but had since been moved to `logs/decisions-archive-2026-05.md` by monthly archival, so the live `decisions.md` no longer holds it. The risk-check SO second opinion and a first-draft session note both mis-read the stale citation as a PHANTOM (non-existent) entry; only an end-gate workspace grep found it in the archive. A stale citation that reads as "phantom" risks an analyst concluding a prior decision was fabricated, when it was merely archived.
- **Proposal:** Treat date-stamped `logs/decisions.md YYYY-MM-DD` citations as a maintainability hazard whenever the cited month is older than the current archival horizon. Options to evaluate at a Friday cadence: (a) when `/resolve-improvement-log` or the monthly decisions archival moves entries to `decisions-archive-YYYY-MM.md`, scan canonical docs (`docs/*.md`, especially `permission-template.md`) for citations to that month and rewrite them to point at the archive file; (b) adopt a stable citation form (e.g., a decision ID or a permalink to the archive) instead of a bare `decisions.md YYYY-MM-DD`; (c) add a lightweight `/friday-checkup` check that greps canonical docs for `decisions.md YYYY-MM-DD` citations whose date predates the live file's earliest entry and flags them as stale. Pick the lowest-cost structural option; do not chase all citations now.
- **Target files:** (only if a fix is chosen) `ai-resources/logs/decisions-archive-*.md` reconciliation step in `/resolve-improvement-log` or the archival routine; `ai-resources/.claude/commands/friday-checkup.md` (optional stale-citation scan); `ai-resources/docs/permission-template.md` already corrected this session.
- **Review-cycle:** monthly

### 2026-07-03 — Workspace-root .claude/commands/ is neither subset nor superset of canonical (5 root-only commands)
- **Status:** logged (pending)
- **Category:** config / curation
- **Friction source:** friction-log 2026-07-02 (command-library secondary finding)
- **Proposal:** Workspace-root `.claude/commands/` (63) is missing 27 canonical commands AND holds 5 real command files that exist only there (`harness-start`, `run-qc`, `session-report`, `update-md`, `validate`) plus a redundant alias. So any project symlinked to the canonical library silently loses those 5 root-only commands. Fix: migrate the 5 real root-only command files into `ai-resources/.claude/commands/` (or confirm-and-delete as deprecated), so the canonical library is the true superset and per-project symlinks are complete. Shared workspace state — sequence deliberately.


### 2026-07-04 — foreign-session-guard.sh GUARD echo omits EXTRA_TODAY/PRIOR_MANDATES referenced by REMNANT/MIXED messages
- **Status:** logged (pending)
- **Category:** diagnostics / incomplete-message
- **Severity:** low
- **Provenance:** independent qc-reviewer pass on the 2026-07-04 wrap-session leanness refactor. **Pre-existing, NOT introduced by the refactor** — the guard extraction was verified byte-identical to the pre-refactor inline block (0 diffs); the pre-refactor `echo "GUARD: ..."` line already omitted these two variables. Confirmed gap, deferred as out-of-scope for the leanness change.
- **Detail:** `logs/scripts/foreign-session-guard.sh` computes `EXTRA_TODAY_MANDATES` / `EXTRA_PRIOR_MANDATES` inside the `FOREIGN>=1` classifier block, but the `GUARD:` diagnostic echo does not emit them. Both wrap-session copies' REMNANT and MIXED remediation templates render those values to the operator (e.g. `EXTRA_PRIOR_MANDATES=N`), so on a REMNANT/MIXED STOP the model cannot fill them precisely from stdout. The `FOREIGN` count itself IS echoed, so the STOP fires correctly and the grep output is shown — only the precise extra-mandate count is missing from the message. Rare path (concurrent + prior-day-orphan states).
- **Proposal:** Add `EXTRA_TODAY_MANDATES=${EXTRA_TODAY_MANDATES:-0} EXTRA_PRIOR_MANDATES=${EXTRA_PRIOR_MANDATES:-0}` to the `GUARD:` echo line in `logs/scripts/foreign-session-guard.sh` so the REMNANT/MIXED messages are fully populatable. One-line, low-risk (the vars default 0 when FOREIGN<1). Do in a dedicated small session, not folded into unrelated work.
- **Target files:** `ai-resources/logs/scripts/foreign-session-guard.sh` (GUARD echo line).
- **Review-cycle:** monthly
