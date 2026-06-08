# Improvement Log

## Schema

Each entry is a `### YYYY-MM-DD — {title}` block. Fields:

- **Status:** `logged` | `proposed` | `pending` | `applied YYYY-MM-DD`
  *De facto convention: all current unresolved entries use `logged (pending)` as a combined compound state. The `/friday-checkup` [STALE] detection rule (added 2026-05-06) matches this compound form — not `pending` alone. If entries are normalized to the single-token schema in future, update the [STALE] match string in `friday-checkup.md` Step 6 accordingly.*
- **Verified:** present when Status is `applied` and the operator has confirmed the fix is live. Both `Status: applied` AND `Verified:` are required for `/resolve-improvement-log` to classify an entry as resolved.
- **Age:** auto-computed from the header date by `/resolve-improvement-log`; surfaced when > 6 weeks without resolution.
- **Review-cycle:** for items not yet resolved — records the last review date and disposition (e.g., `reviewed 2026-04-24, deferred to next quarterly`). **This is the canonical "park" mechanism for ROI-deferred low-value items** (per workspace `CLAUDE.md` § Working Principles, structural-fix rule): a low-value item is parked by stamping `Review-cycle: reviewed {date}, deferred to {concrete trigger}`, which resets the `/friday-checkup` stale-scan clock to the review date. The deferral target must be **concrete** — a date, a quarter, or a named event — never "later"/"someday" (a park with no real trigger never drains; `/resolve-improvement-log` Step 3b rejects a vague trigger). A parked item stays in the **active** log and re-surfaces (the stale-scan re-flags it ~21 days after the review date, and the monthly `/friday-checkup` park-drain force-reviews the oldest parks); parking is **not** archival. Reserve archival for genuinely dead items.
- **Category:** broad classification (e.g., `Audit-recurrence prevention`, `command/skill`).
- **Proposal:** the proposed change.
- **Target files:** files to be edited when executed.

Resolved entries (Status: applied + Verified) are archived to `improvement-log-archive.md` via `/resolve-improvement-log`.

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

### 2026-05-25 — Canonical scope-selection pattern doc (parked)
- **Status:** logged (pending)
- **Category:** process
- **Friction source:** cross-reference of friction 09:07 against existing /monday-prep and /friday-checkup scope-selection idioms — three different encodings across sibling commands
- **Proposal:** Create `docs/scope-selection-pattern.md` (reference the `/friday-checkup` Step 3 lines 82–95 as canonical pattern) and add a one-line pointer in `ai-resources/CLAUDE.md` under a "Command Conventions" section. Prevents the next audit-class command from inventing a fourth encoding. Triage verdict: park — N=2 pattern occurrences, premature to formalize; Finding 1 covers the concrete friction. Revisit when a third command needs the pattern.
- **Target files:** `docs/scope-selection-pattern.md` (new), `ai-resources/CLAUDE.md`

### 2026-05-25 — Pattern to watch: operator-caught review-class gaps (2 occurrences)
- **Status:** logged (pending)
- **Category:** process
- **Friction source:** friction-log 09:13 (B7 always-loaded skip) and 09:53 (risk-check existing-command exemption) — both caught by operator post-execution, not by /qc-pass or the plan
- **Proposal:** If the pattern recurs in the next 1–2 sessions (3+ total instances), add either (a) a review principle to `skills/ai-resource-builder/references/review-principles.md` ("When a command audits layer N, verify the candidate list includes the always-loaded layer above N") or (b) a /qc-pass checklist item for plan-time risk-class enumeration. Current count: 2 in one session — at watch threshold, below escalation threshold. No action this round.
- **Target files:** `skills/ai-resource-builder/references/review-principles.md` or qc-pass protocol (if escalated)

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

### 2026-05-28 — extract change-shape classifier to shared reference (eliminate two-end contract)

- **Status:** no-op / already-resolved (closed 2026-06-05 S13) — superseded by the 2026-05-29 refactor: the classifier was extracted to `docs/change-shape-classifier.md` and both `/consult` (Step 2, L48/52) and the `project-manager` agent (Phase 3, L63/65) already read it as a one-end contract with provenance lines. This entry (dated 2026-05-28) predates its own fix by one day. Surfaced again by the S13 diagnostics scan (id-16); risk-check RECONSIDER flagged that re-homing into repo-architecture.md would re-introduce two-source drift (DR-7/AP-7) — DROPPED. No code change. 3rd "diagnostics scan surfaced an already-resolved item" instance on 2026-06-05.
- **Category:** Audit-recurrence prevention / architectural deduplication
- **Source:** project-manager agent + /pm command landing 2026-05-28 — System Owner Function-B advisory (risk-check second opinion) named this as the architecturally correct v1.1+ state. The change-shape classifier list (Files / Commands / Agents / Models / Folder structure / Hooks / Workflows / Project boundaries / Permissions) is currently duplicated verbatim in `ai-resources/.claude/commands/consult.md` Step 2 and `ai-resources/.claude/agents/project-manager.md` Phase 3 (under `structure (change-shaped)`). The duplication is a **two-end contract per `risk-topology.md § 5`** — silent drift between the two copies causes routing inconsistency between `/consult` and `/pm`.
- **Mitigation in place at v1:** both files carry an explicit two-end-contract comment naming the sibling file. Comments decay per `principles.md § QS-7` — this is a stopgap, not the architectural fix.
- **Proposal:** extract the change-shape classifier to a shared reference doc that both commands `Read` at runtime. Candidate location: `ai-resources/docs/repo-architecture.md` § new "Change-shape classifier" subsection (it's a routing concept and lives naturally alongside repo-architecture's Q5 classifier reference). Both `consult.md` Step 2 and `project-manager.md` Phase 3 then become "read this section; apply the list" instead of carrying verbatim copies. Per `principles.md § DR-7` — generalize on confirmed second-consumer evidence (PM is the second consumer; the trigger is met).
- **Target files (when executed):** `ai-resources/docs/repo-architecture.md` (add classifier subsection); `ai-resources/.claude/commands/consult.md` (replace verbatim list with Read-and-apply reference); `ai-resources/.claude/agents/project-manager.md` (same).
- **Triage cadence:** next Friday `/friday-act` wave.

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

### 2026-05-28 — Architecture-gap report loop (SO advisory item #3)

- **Status:** logged (pending)
- **Category:** Placement-discipline / feedback-loop closure
- **Source:** SO advisory (`/route-change` → `/placement` rename session, 2026-05-28). `/placement` Step 14 surfaces architecture gaps (cases where `docs/repo-architecture.md` does not cover a proposed change) as a recommendation field in chat. Currently those gap reports live and die in chat — no aggregation, no Friday-act consumption.
- **Proposal:** When `/placement` populates the `**Architecture gap:**` field, also append a structured entry to `ai-resources/logs/maintenance-observations.md` under a new "Architecture gaps surfaced" subsection within the current week's session block. Friday-act consumes the section, decides whether `docs/repo-architecture.md` needs amendment, and dispositions accordingly.
- **Risk if left undone:** placement recommendations degrade silently as the architecture map staleness accumulates. The feedback loop named in workspace CLAUDE.md § Placement Discipline (friction-log as the upgrade signal) only catches *misses*, not *gaps*.
- **Target files (when executed):** `ai-resources/.claude/commands/placement.md` Step 14 (add maintenance-observations append after chat output); `ai-resources/logs/maintenance-observations.md` schema (document the new subsection); `ai-resources/.claude/commands/friday-act.md` (add the new subsection to its consumption sweep).
- **Triage cadence:** next monthly `/friday-act` wave (low priority — slow signal, low blast radius).

### 2026-05-28 — Track /placement skip-rate in gate-calibration (SO advisory item #4)

- **Status:** logged (pending)
- **Category:** Placement-discipline / fading-gate observability
- **Source:** SO advisory (`/route-change` → `/placement` rename session, 2026-05-28). The `gate-calibration.md` system (shipped 2026-05-18) tracks high-confirmation gates and surfaces `[FADING-GATE]` candidates in monthly `/friday-checkup`. `/placement` is exactly the kind of gate that's easy to "remember" early and skip when work is flowing — its skip-rate should be observable.
- **Proposal:** Add `/placement` to the gate-calibration tracking surface. Each session start, the gate-calibration mechanism increments either an "invoked" or "skipped" counter for `/placement`. The skip detection: when a file is created in a new top-level directory or new artifact category (the triggers listed in workspace CLAUDE.md § Placement Discipline) AND `/placement` was not invoked during the session, mark a skip. Monthly checkup surfaces a fading-gate candidate when skips exceed invocations for two consecutive months.
- **Risk if left undone:** placement-discipline drift is invisible until an audit catches a misplaced file. Today the operator has no way to see whether `/placement` is actually being used or being silently skipped.
- **Target files (when executed):** `ai-resources/docs/gate-calibration.md` (add `/placement` to tracked gates); a new SessionStart or Stop hook to detect file-creation events satisfying the trigger conditions; `ai-resources/.claude/commands/friday-checkup.md` Step 6 (consume the new tracking signal).
- **Triage cadence:** quarterly `/friday-act` wave — depends on the gate-calibration system maturing; low priority.

### 2026-05-28 — Tighten Placement Discipline trigger to constraint-on-Write checklist (SO advisory item #5)

- **Status:** logged (pending)
- **Category:** CLAUDE.md polish / always-loaded surface tightening
- **Source:** SO advisory (`/route-change` → `/placement` rename session, 2026-05-28). The current workspace CLAUDE.md § Placement Discipline trigger list (lines 39–42) reads as four prose bullets describing when to run `/placement`. SO suggested converting to a stricter "before any `Write` whose target path is not already in scratch context this session, ask: …" — makes the gate harder to skip rhetorically by reframing it as a constraint on Write actions rather than a procedure to remember.
- **Proposal:** Rewrite workspace CLAUDE.md § Placement Discipline trigger list as a constraint-on-Write checklist. Keep the "skip when" bullet list intact. Net token delta probably <0 (constraint phrasing is usually tighter than procedural).
- **Risk if left undone:** low — cosmetic vs. structural. Current prose is functional and operator already invokes `/placement` consistently. SO classified this as item #5 (lowest in the ranked list) for that reason.
- **Target files (when executed):** `~/Claude Code/Axcion AI Repo/CLAUDE.md` § Placement Discipline only.
- **Triage cadence:** opportunistic — bundle with the next workspace CLAUDE.md edit pass; do not schedule standalone.

### 2026-05-29 — /risk-check 5-dimension shape does not catch design-internal principle drift

- **Status:** logged (pending)
- **Category:** Audit-recurrence prevention / risk-check shape
- **Source:** System Owner Function-B advisory on Item 3 (C-1+C-2) plan-time /risk-check — `audits/risk-checks/2026-05-29-c-1-c-2-consult-return-size-cap-project-local-symlink.md § Architectural Commentary`. The SO noted that the C-1 design as briefed to /risk-check contained a conditional-write threshold ("≤30 lines → skip on-disk write") that conflicts with three vault principles (OP-3 loud-failure, DR-6 outputs-go-to-`output/`, AP-7 speculative-abstraction) — but the risk-check-reviewer did not surface this as a finding. Reason: the five dimensions (usage cost, permissions, blast radius, reversibility, hidden coupling) evaluate downstream impact, not design-internal principle conformance.
- **Friction source:** Pattern observed across recent sessions — the SO second opinion catches principle drift that the risk-check-reviewer misses. The SO second opinion is currently mandatory only on non-GO verdicts; GO verdicts on principle-drifted designs would ship undetected. Adjacent earlier pattern: TOCTOU Phase 2+3 Round 2 inventory miss (same defect class — same-day pre-spec grep checklist entry above already captures the inventory side). This entry is the principle-conformance side.
- **Proposal:** Add a sixth dimension (or a Step 7 final check) to the risk-check-reviewer rubric — "Principle alignment of the proposed design's internal choices." Reviewer reads the small set of vault principles (or a digest) and flags any internal design choice that conflicts with them. Alternative A: extend the pre-spec checklist (from the sibling 2026-05-29 entry above) to mandate the spec author runs a principle-conformance check on the proposed design before /risk-check is invoked. Alternative B (lightest touch): leave the gap as-is and escalate the SO second-opinion step to fire on GO verdicts too, not just non-GO — so principle conflicts get a second pass at zero extra ceremony.
- **Target files (when executed):** `ai-resources/.claude/agents/risk-check-reviewer.md` (add Dimension 6 or Step 7); possibly `ai-resources/.claude/commands/risk-check.md` (Alternative B — extend Step 4a to fire on GO verdicts too); possibly `ai-resources/skills/ai-resource-builder/SKILL.md` (Alternative A — pre-spec checklist).
- **Triage cadence:** next Friday `/friday-act` wave. Likely small implementation; high recurrence frequency on structural-change sessions.

### 2026-06-02 — §8 grounding-absence self-resolved (proceed-degraded) instead of escalated; System Owner agent running ungrounded
- **Status:** logged (pending)
- **Category:** principle-drift
- **Provenance:** wrap-collector (machine-authored) 2026-06-02
- **Friction source:** wrap-collector 2026-06-02 — principle-drift (Assumptions-Gate-adjacent; from S6 § Decisions + § Outcome + § Next Steps)
- **Proposal:** Two coupled items. (1) Restore the absent System Owner grounding files (`persona.md`, `principles.md`, `grounding.md`, `risk-topology.md`, `blueprint.md` under `projects/axcion-ai-system-owner/`) — the agent is running degraded, so any consult-derived doctrine (e.g. S6's §8 decision hook) ships provisional `[CITATION NEEDED]` until the base is restored. (2) Add a cheap pre-consult existence check on the system-owner grounding files: when grounding is missing, surface "grounding missing — proceed degraded or pause?" as an explicit operator decision per the workspace Assumptions Gate (default to escalation on a structural concern, not self-resolution) rather than self-resolving to proceed-degraded. The S6 § Outcome itself names this as the "better path" — the grounding gap was knowable at consult time.
- **Target files:** `projects/axcion-ai-system-owner/` grounding files (restore); `ai-resources/.claude/commands/consult.md` and/or `ai-resources/.claude/agents/system-owner.md` (pre-consult grounding existence check + escalation prompt).

### 2026-06-04 — pattern to watch: same-day multi-session unwrapped-notes accumulation triggers wrap foreign-guard (3rd+ occurrence class)
- **Status:** logged (pending)
- **Category:** session-feedback
- **Provenance:** wrap-collector (machine-authored) 2026-06-04
- **Friction source:** wrap-collector 2026-06-04 — friction / process (S4 wrap fired the foreign-session pre-write guard CONCURRENT/FOREIGN=3 because S1/S2/S3 ran same-day and never wrapped, so their notes sat uncommitted in the working tree; resolved via operator-approved option-2 multi-session recovery commit, no content lost — the guard WORKED, this is an operational-pattern note not a guard defect)
- **Proposal:** Watch-only this round — do NOT build. The guard fired correctly and the recovery path (conscious union commit) is the designed behavior, so there is no guardrail gap to close. The signal is the operational pattern: running 4 same-day sessions (S1–S4) where the earlier three never run `/wrap-session` forces the last session to absorb a multi-session recovery commit at wrap. If this accumulation recurs (the recovery-commit-at-wrap path is hit 2+ more times), consider whether an unwrapped-session reminder or a lightweight per-session auto-commit-of-own-notes path would reduce the manual recovery burden. Cross-ref the existing TOCTOU/marker entries (Option 2′ SHIPPED 2026-06-01; date-rollover REMNANT 2026-06-02) — those address marker clobber + date-boundary detection accuracy, NOT the unwrapped-accumulation operational pattern, so this is a distinct watch-item, not a duplicate.
- **Target files:** (to be determined at disposition) — likely `ai-resources/.claude/commands/wrap-session.md` Step 3.5 / `prime.md` if escalated; none this round.
- **S5 follow-up (2026-06-04):** First recurrence of the accumulation pattern — S5 had to absorb the deferred S1/S2 *deliverable* commits (not just notes). Investigation this session found the accumulation is broader than session-notes: a workspace-wide `git status` survey showed **~16 repos** carrying uncommitted drift — mass deletions (`critical-resource-auditor.md`, `audit-critical-resources.md`, `route-change.md`), dozens of untracked `.claude/` command + agent library files, and `.session-marker` churn — most of it predating today's sessions. The S2 Session-Boundaries consolidation (16-repo conversion) was only the visible tip. S5 committed the ai-resources + strategic-os subsets cleanly (explicit paths, foreign drift untouched: commits `24eb6d8`, `2facf99`); the other 14 project-repo CLAUDE.md conversions remain uncommitted and entangled with the broader library drift. **Disposition recommendation:** this is no longer "watch-only" — the workspace-wide `.claude/` library drift across 16 repos is a standing git-hygiene debt that deserves a dedicated session (likely a `git status` sweep + per-repo explicit-path commit pass, or a decision on whether the per-project `.claude/` dirs should be committed at all vs. gitignored/symlinked from canonical). Not the unwrapped-notes guard problem — a separate, larger structural question about how project `.claude/` libraries are synced and tracked. **Target files:** none (diagnosis); a future session decides the `.claude/` sync/tracking model.

### 2026-06-04 — Graduation verdicts recorded at wrap without the second-consumer test (DR-7/AP-7); stale GRADUATE propagates until a later gate catches it
- **Status:** logged (pending)
- **Category:** principle-drift
- **Provenance:** wrap-collector (machine-authored) 2026-06-04
- **Friction source:** wrap-collector 2026-06-04 — principle-drift (S6 § Decisions + § Outcome). The S5-wrap recorded a GRADUATE verdict for E1 (`doc-scanner-agent`) that skipped the DR-7/AP-7 second-consumer test; `doc-scanner-agent` is N=1 (genuinely project-local to repo-documentation), and `auto-sync-shared.sh` would have fanned it out as symlinks into ~10 unrelated projects. S6's Stage-0 `/risk-check` + system-owner caught the stale verdict and reversed it to KEEP-LOCAL. This is the second same-day instance of a stale graduation/resolution verdict — E4 (`resolve-improvement-log`) carried a stale GRADUATE caught and corrected to CONFIRMED-DONE in S5. Same defect class: a graduate/resolve verdict is written into the strategic-os Slot-1 records at wrap time without applying the second-consumer (DR-7) or ground-truth (already-shipped) check, so the wrong verdict propagates across sessions until a downstream gate happens to re-examine it.
- **Proposal:** When a session records a GRADUATE verdict for a candidate resource into the AI-strategy Slot-1 records (`slot-1-decisions.md` / `implementation-tracker.md`), require the DR-7/AP-7 second-consumer test be explicitly applied and noted in the verdict line — count distinct real consumers and name `auto-sync-shared.sh` symlink fan-out as the blast-radius constraint. Candidate placements: a one-line gate in `/graduate-resource` plan-time (the canonical graduation pipeline — confirm it already enforces the second-consumer test and that this bypass was a wrap-time record-only shortcut, not a pipeline gap), and/or a checklist note in the AI-strategy slot-closure convention so a "GRADUATE" verdict cannot be written without the consumer count. Two same-day instances (E4, E1) make this a pattern, not a one-off.
- **Target files:** (to be determined at disposition) — likely `ai-resources/.claude/commands/graduate-resource.md` (verify/strengthen the plan-time second-consumer gate); possibly the AI-strategy slot-closure convention doc under `projects/strategic-os/ai-strategy/` that governs how GRADUATE verdicts are recorded.

### 2026-06-04 — Implement .claude/ shared-resource git-hygiene: gitignore synced symlinks + regenerate (Option B, decided S8)
- **Status:** logged (pending)
- **Category:** repo-hygiene
- **Source:** /prime auto S8 — Item 4 decision (decisions.md 2026-06-04 (S8))
- **Decision (made S8):** Option B — stop tracking the *synced shared* command/agent symlinks/copies in each project repo; gitignore them and let the `auto-sync-shared.sh` SessionStart hook regenerate the relative symlinks. Keep tracking per-project real files (`settings.json`, `shared-manifest.json`, manifest-`.local` project-owned commands/agents, project-owned hooks). Full rationale + evidence in `logs/decisions.md` 2026-06-04 (S8). Supersedes the "a future session decides the `.claude/` sync/tracking model" disposition in the S5-follow-up entry above.
- **Why gated (not done S8):** multi-repo structural change — `git rm --cached` of ~700 shared command/agent entries across 14 project repos + per-repo `.gitignore` patterns + a regenerate-verification pass. Real cross-repo blast radius; relies on the hook firing reliably. NOT covered by the S8 plan-time `/risk-check` (which scoped only Items 1–2). Requires its own `/risk-check` + a dedicated execution session.
- **Proposal (implementation, gated — Structural; /risk-check change class):** In each of the 14 project repos: (1) add `.gitignore` patterns for the synced shared files under `.claude/commands/` and `.claude/agents/` while NOT ignoring the manifest-`.local` project-owned ones (derive the keep-set from each project's `shared-manifest.json` `.local` lists + the `auto-sync-shared.sh` EXCLUDE lists); (2) `git rm --cached` the now-ignored symlinks/copies (working-tree files stay; the hook owns them); (3) verify regeneration by clearing + re-running a SessionStart in one repo first (pilot), confirm the hook re-emits the symlinks, before rolling to the rest; (4) reconcile the real-file copies (buy-side 22, research-pe 20, global-macro 13, strategic-os 9, project-planning 7, repo-documentation 1) — either `/sync-workflow`-replace with symlinks first or let them drop from tracking. Pilot one repo, QC, then batch. Sequence after a clean working tree (no entangled drift).
- **Target files:** `.gitignore` in each of the 14 project repos; the tracked `.claude/commands/*` + `.claude/agents/*` symlink/copy entries in each (untrack only); possibly a note in `docs/repo-architecture.md` § Symlink topology documenting the gitignore+regenerate model. No change to `auto-sync-shared.sh` itself (it already regenerates).

### 2026-06-04 — Step 3.5 CONCURRENT block strands a no-own-marker session whose work is already committed (remediation-ergonomics gap)
- **Status:** logged (pending) — **Friday-act 2026-06-05 (session-harness #5) triage verdict: DEFER.** Consistent with this entry's own classification: the recommended wrap-lite fix is Structural (/risk-check change class — it restructures the Step 3.5 CONCURRENT shared-state staging logic across both `wrap-session.md` copies). Out of scope for a multi-item friday-act sweep; hold for a dedicated /risk-check session per the proposal below.
- **Category:** session-issue
- **Source:** /resolve-repo-problem AUTO mode 2026-06-04
- **Friction source:** During the /fix-repo-issues 1942 wrap (a no-/session-start session: `/prime` brief → `/fix-repo-issues` → execute → `/wrap-session`, so NO per-id marker, NO mandate, authored NO `## … — Session` header), the Step 3.5 guard correctly fired CONCURRENT (FOREIGN=1) because a concurrent S8 session's today-header + mandate (line 480) were uncommitted in `logs/session-notes.md`. The guard behaved correctly — this was the **first live validation** of the no-own-marker fix `003f8ba` (id-34): NO_OWN_MARKER=1 → OWN_SUBTRACT=0 → S8's content flagged foreign instead of a silent false-negative. Residual issue: this session's own work was already committed (ai-resources `376df95`, research-pe `84f1416`) and it had nothing of its own to add to `session-notes.md` beyond the wrap note, yet it cannot complete its wrap rituals (session note, Step 6.4 outcome, Step 6.5 feedback collection) without staging the contended `session-notes.md`. The only offered remediation ("wrap the other session first") couples wrap ordering and can strand the blocked session indefinitely if the concurrent session is mid-task.
- **Proposal (recommended — Structural; /risk-check change class):** Add a "wrap-lite" sub-path to the Step 3.5 CONCURRENT branch for the specific case `NO_OWN_MARKER=1 AND the session's own work is already committed AND FOREIGN_CLASS=CONCURRENT`: let the session complete its wrap WITHOUT staging `session-notes.md` — skip the Step 4 session-note append (its state is already preserved in the continuity scratchpad written at Step 0.5 + its own commit messages), still run Step 6.4/6.5 against its committed files, and commit only its own already-modified files. This unblocks the wrap without the forbidden union-commit and without the wrap-ordering dependency. A heavier alternative (if losing the structured note is unacceptable): write the wrap note to a per-session sidecar `logs/session-notes-pending/{session-id}-{ts}.md` that `/prime` or the next wrap merges into `session-notes.md`. Distinct from id-34 (2026-06-04, the DETECTION fix — now committed `003f8ba` and live-validated here; its improvement-log entry should be flipped to applied+Verified by the S8 wrap that landed it) and from id-36 (the same-day unwrapped-notes accumulation pattern, watch-only) — this entry is about the REMEDIATION path for the now-correctly-detected no-marker CONCURRENT case, not detection or accumulation. Touches both `wrap-session.md` copies → /risk-check before landing.
- **Target files:** `ai-resources/.claude/commands/wrap-session.md` Step 3.5 (CONCURRENT branch — add the no-own-marker wrap-lite sub-path); `/.claude/commands/wrap-session.md` (workspace-root paired sibling per PAIRED CONTRACT); possibly `docs/session-marker.md` (document the wrap-lite path for no-marker sessions).

---

## id-39 — Read() deny rules: workspace-root scope design (deferred 2026-06-05)

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

### 2026-06-08 — Port grep-first dedup fix to the workspace-root wrap/collector copy (DEFERRED)
- **Status:** deferred — after the canonical fix proves out
- **Category:** paired-contract / sync
- **Source:** plan `let-s-figure-out-a-reflective-lovelace.md` Follow-ups item 2. Canonical fix landed in commit 9f66e6f (ai-resources copy only).
- **Why deferred:** The workspace-root `wrap-session.md` + its collector path are an independent non-symlink copy under a paired-contract note; the canonical fix intentionally did not touch them this session. Port once the canonical change proves out on a real wrap.
- **Proposal:** Apply the same grep-first/read-narrow dedup + archive-drop to the workspace-root copy of the collector + wrap Step 6.5 (or whichever copy that layer uses), keeping the two in sync per the paired-contract note. Verify against the same 4-point read-back used for the canonical fix.
- **Review-cycle:** monthly

### 2026-06-08 — Document producer-end of the Check-7 / Named-Source-Appendix two-end contract (DEFERRED)
- **Status:** deferred — small follow-up to the shipped Check 7 change
- **Category:** research-workflow / two-end-contract
- **Source:** Check 7 (Source-Surface Coverage) landed in `research-extract-verifier` (fix-spec #2, 2026-06-08 S1); risk-check `audits/risk-checks/2026-06-08-check7-source-surface-coverage-research-extract-verifier.md`; system-owner second opinion.
- **Why deferred:** The skill (consumer end) now reads `reference/source-class-hierarchy.md`'s evidence-need table + ladders + Named-Source Appendix and flips a scarcity verdict on appendix contents. The producer-end template (`workflows/research-workflow/reference/source-class-hierarchy.template.md`) carries the structure but does not yet state that a verifier check consumes the appendix — so a project filler doesn't know the appendix shape is now a contract. Scoped out of the skill commit deliberately.
- **Proposal:** Add a short note in `source-class-hierarchy.template.md` (and the project-local mirror if wanted): "Check 7 of research-extract-verifier reads the evidence-need rows, ladders, and Named-Source Appendix; keep row/ladder identities stable — renamed headings degrade Check 7 to `unverifiable`." Reference-doc edit; likely no `/risk-check` (no skill logic), but confirm.
- **Review-cycle:** monthly

### 2026-06-08 — research-extract-verifier description-frontmatter polish (5 pre-existing Minors) (DEFERRED)
- **Status:** deferred — separate description-polish pass
- **Category:** skill-frontmatter / convention-gate
- **Source:** cold evaluation during the Check 7 `/improve-skill` pass (2026-06-08 S1). All 5 are pre-existing, none introduced by Check 7.
- **Why deferred:** Orthogonal to the Check 7 change; folding them in would mix pre-existing cleanup with a scoped canonical change. Operator chose "commit Check 7, defer Minors."
- **Proposal:** (1) C2 — front-load trigger phrases into the first 250 chars of the description (currently descriptive-first; triggers sit past the window). (2) C3 — convert "Use when Patrik provides…" to third person and tighten the block under the 1024-char guideline (now ~1,358 chars after the Check 7 description sync). (3) C7 — consider an `allowed-tools: Read, Write` fence to mechanically enforce the no-external-evidence constraint. (4) C6 — document the `disable-model-invocation` / file-write side-effect decision. (5) Failure Behavior — add a bullet for internally-conflicting inputs (Answer Spec vs report contradiction → surface, do not silently pick). Route via `/improve-skill`.
- **Review-cycle:** monthly

### 2026-06-08 — .claude/ git-hygiene Option B (W24 item 2) — PARKED (broken premise)
- **Status:** parked — premise incoherent; re-open only if a concrete churn or storage pain is observed
- **Category:** git-hygiene / symlink-topology
- **Source:** W24 mandate item 2 (decisions-archive-2026-06.md, commit 2d1e11d). Investigated 2026-06-08 S3; SO advisory consult-2026-06-08-git-hygiene-option-b-review.md.
- **Why parked:** (1) Premise is a no-op: `.gitignore` stops git tracking but does not remove files from disk; the sync hook never overwrites an existing target (`repo-architecture.md § Symlink topology rule 1`), so a gitignored-but-still-present file is skipped forever. The "regenerate at SessionStart" mechanism only works if the target is absent — which requires `git rm --cached` + disk delete first, making this a structurally heavier change than the W24 framing implied. (2) Problem is not material: churn across 13 project repos is 1–7 commits/90d, all intentional work (local command builds, one-time bulk syncs, fork graduations) — not auto-generated noise. (3) Zero broken symlinks across 12/13 projects; the one broken symlink in research-pe-regime-shift-advisory-gap is a `/fix-symlinks` job. (4) The 2026-06-04 risk-check returned RECONSIDER on this exact change class; executing without re-gating is disallowed (DR-8). (5) SO confirmed: park it unless/until churn is a felt operational problem.
- **Proposal:** If re-opened: (1) Rewrite premise to real sequence — `git rm --cached` → delete from disk → `.gitignore` → let hook re-symlink. (2) Run plan-time `/risk-check` (own gate, not the 2026-06-04 one). (3) Pilot on one project (pick one with no real tracked files in .claude — e.g., marketing-positioning or nordic-pe-screening). (4) Validate hook re-creates symlink on next session start before rolling out. (5) Update `repo-architecture.md § Symlink topology` in the same commit.
- **Review-cycle:** quarterly

### 2026-06-08 — #23 deferred half: strengthen the Source-Diversity triangulation rule (chassis edit + /risk-check) (DEFERRED)
- **Status:** deferred — chassis edit deserves clean context + a /risk-check re-fire
- **Category:** research-workflow / claim-permission-chassis
- **Source:** fix-spec #23 §3.3; PM ruling 2026-06-08 S1 (verdict: this is a chassis edit, gate it); the orthogonal `independence basis` field already landed in research-extract-creator (commit pending this session).
- **Why deferred:** The independence DATA (the `independence basis` field) is now recorded per claim. The RULE that consumes it — extending the triangulation-packets rule in `reference/quality-standards.md § Source-Diversity Matrix` from "same source CLASS → one role" to "same UNDERLYING SOURCE/DATASET across different classes → one role" — is a CHASSIS edit (the triangulation-packets rule is marked `(canonical)` in both quality-standards.md:137 and claim-permission.template.md:35). Per the canonical-ordering rule (quality-standards.md:116, template:5) it requires a `/risk-check` re-fire. Not safe to land at the tail of a deep multi-subagent session.
- **Proposal:** Dedicated session: design the same-underlying-source collapse rule for `quality-standards.md § Source-Diversity Matrix`; `/risk-check` it (chassis edit, broad blast radius — both claim-permission-gate and cluster-memo-refiner Check 9 read this section); land it; then add a back-validation/migration pass over any extracts already produced with `independence basis` values (the field's interim values are unvalidated until the gate activates — noted in the skill). `/qc-pass` + commit.
- **Review-cycle:** monthly

### 2026-06-08 — Fix-spec §3.3 false-topology defect + standing unconsumed claim-permission.md gap (DEFERRED)
- **Status:** deferred — spec-author correction + a separate wiring decision
- **Category:** fix-spec-correctness / claim-permission-wiring
- **Source:** discovered during #23 implementation (2026-06-08 S1); confirmed by PM ruling.
- **Why deferred:** Two linked defects. (1) **Spec defect:** `audits/2026-06-08-workflow-v2-fix-spec.md` §3.3 instructs "instantiate reference/claim-permission.md, put the independence rule there, do NOT edit quality-standards.md." This is factually wrong against the deployed wiring — the diversity enforcers (claim-permission-gate SKILL.md:49-50/70/191; cluster-memo-refiner Check 9 SKILL.md:228) read the Source-Diversity Matrix from `quality-standards.md`, and `reference/claim-permission.md` does not exist and is unconsumed for the diversity check. Following §3.3 verbatim would enforce nothing. (2) **Standing wiring gap:** `quality-standards.md:133,137` point at `reference/claim-permission.md` for the project-fillable threshold/diversity tables, but that file was never instantiated — a chassis pointer to a non-existent file.
- **Proposal:** (a) Correct fix-spec §3.3 to target `quality-standards.md § Source-Diversity Matrix` (chassis, /risk-check'd) for the rule and keep only the `independence basis` field on research-extract-creator. (b) Separately decide whether `claim-permission.md` should ever be instantiated (the template lists refiner Check 9 / writer / Pass-3 emitter as intended consumers of its THRESHOLD tables — but the deployed refiner reads quality-standards.md, so either instantiate-and-rewire or remove the dangling pointer). Both are spec/architecture decisions, not in-session edits.
- **Review-cycle:** monthly

### 2026-06-08 — research-extract-creator pre-existing convention-gate items (5) (DEFERRED)
- **Status:** deferred — orthogonal to the #23 field change
- **Category:** skill-convention-gate
- **Source:** cold evaluation during the #23 `/improve-skill` pass (2026-06-08 S1). All pre-existing; none introduced by the `independence basis` field.
- **Why deferred:** Orthogonal to the scoped #23 field; folding them in would mix pre-existing cleanup with a scoped canonical change.
- **Proposal:** (1) **C12 — freshness-year rot (Major):** the Evidence Freshness table hard-codes literal years (CURRENT 2025–2026, etc.) in the always-loaded body and contradicts its own "project-agnostic rolling window" parenthetical; replace with relative anchors resolved from the project `Current period` config, or isolate as a date-stamped snapshot. (2) **C14 — no worked example (Major):** add one fully-populated example claim block (all fields incl. a proxy + a multi-channel case). (3) **C13 — no Runtime Recommendations section (Major):** add one narrating the sonnet/medium choice + context-loading. (4) **Issue 4 — template output-contract gap (Minor, consequential):** `references/extract-template.md` omits the `evidence_date`/freshness-class and evidence-lens fields that SKILL.md treats as canonical per-claim outputs; add them so the literal template isn't lossy. (5) **C6/C7/C8 — frontmatter (Minor):** document `disable-model-invocation` / `allowed-tools` / `paths` decisions (skill writes a side-effect conflict-log file). Route via `/improve-skill`.
- **Review-cycle:** monthly
