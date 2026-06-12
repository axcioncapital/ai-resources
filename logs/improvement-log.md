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

### 2026-06-08 — research-extract-creator pre-existing convention-gate items (5) (DEFERRED)
- **Status:** deferred — orthogonal to the #23 field change
- **Category:** skill-convention-gate
- **Source:** cold evaluation during the #23 `/improve-skill` pass (2026-06-08 S1). All pre-existing; none introduced by the `independence basis` field.
- **Why deferred:** Orthogonal to the scoped #23 field; folding them in would mix pre-existing cleanup with a scoped canonical change.
- **Proposal:** (1) **C12 — freshness-year rot (Major):** the Evidence Freshness table hard-codes literal years (CURRENT 2025–2026, etc.) in the always-loaded body and contradicts its own "project-agnostic rolling window" parenthetical; replace with relative anchors resolved from the project `Current period` config, or isolate as a date-stamped snapshot. (2) **C14 — no worked example (Major):** add one fully-populated example claim block (all fields incl. a proxy + a multi-channel case). (3) **C13 — no Runtime Recommendations section (Major):** add one narrating the sonnet/medium choice + context-loading. (4) **Issue 4 — template output-contract gap (Minor, consequential):** `references/extract-template.md` omits the `evidence_date`/freshness-class and evidence-lens fields that SKILL.md treats as canonical per-claim outputs; add them so the literal template isn't lossy. (5) **C6/C7/C8 — frontmatter (Minor):** document `disable-model-invocation` / `allowed-tools` / `paths` decisions (skill writes a side-effect conflict-log file). Route via `/improve-skill`.
- **Review-cycle:** monthly

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

### 2026-06-09 — Mid-session commit can stage a sibling session's session-notes.md content (no mid-session foreign-content guard) (PENDING)
- **Status:** logged (pending)
- **Category:** concurrent-session-collision + commit-discipline
- **Source:** Observed live, 2026-06-09 S1. Two concurrent sessions ran on the same project (S1 = ai-resources Milestone-4 skill edits; S2 = project-only thesis delivery-readiness QC), correctly scoped to disjoint WORK files. During S1 execution, a mid-session project commit staged `logs/session-notes.md` while S2's marker-bearing header (`## 2026-06-09 — Session S2`) + mandate were already in the working tree — so S1's mid-session commit shipped S2's header+mandate into HEAD. Harmless this time (session-notes.md is append-only + marker-disambiguated; S2's content is legitimate and its own wrap Step 3.5 guard returned FOREIGN=0), but it is a real contamination surface: a sibling session's content lands under the wrong session's commit with no detection.
- **Gap:** `/wrap-session` Step 3.5 has a foreign-session pre-write guard on `session-notes.md`, but there is NO equivalent guard at **mid-session commit** time. Any mid-session `git add logs/session-notes.md` (or other shared marker-disambiguated/edit-in-place logs) can sweep concurrent-session content with no warning.
- **Proposal (operator-requested, for Friday cadence):** Make a mid-session commit refuse to stage `logs/session-notes.md` when a sibling session's heading is present. Layer options to weigh at implementation (run `/risk-check` — this is a commit-path change):
  1. **Documented discipline (lightest, structural):** mid-session/work commits never stage `logs/session-notes.md` — it is *wrap-owned*; only `/wrap-session` (which has the Step 3.5 guard) stages it. The /prime-written mandate line sits uncommitted until wrap. Update `ai-resources/docs/commit-discipline.md` + the project/workspace "Commit behavior" rule. No new permission surface.
  2. **Reusable guard helper:** extract the Step 3.5 foreign-content detector into a small shared script and call it before any commit that stages session-notes.md (mid-session or wrap). DRY, but needs a caller.
  3. **PreToolUse(Bash) hook** that blocks `git commit` staging session-notes.md when a foreign today-header/mandate is present. Strongest, but adds a permission surface + maintenance burden — the team has deferred similar hooks (cf. the QC-PENDING commit-block hook, parked at v1 pending recurrence). Recommend NOT defaulting to this unless options 1–2 prove insufficient.
- **Recommended default:** Option 1 (wrap-owns-session-notes discipline) — it removes the surface structurally with zero new machinery. Option 2 only if a mid-session session-notes commit is genuinely needed somewhere.
- **Also worth a line in the same fix:** the shared edit-in-place logs (`decisions.md`, `friction-log.md`, `improvement-log.md`) are the higher-severity lost-update surface under concurrency (a rewrite, not an append, can drop a sibling's line). The /prime concurrent-session advisory already *names* these; consider whether the same wrap-owns / sequence-the-wraps discipline should be documented for them too.
- **Target files:** `ai-resources/docs/commit-discipline.md`; workspace + project `CLAUDE.md` "Commit behavior" sections; optionally a shared guard script under `logs/scripts/` or `.claude/hooks/`.
- **Review-cycle:** monthly

### 2026-06-09 — ai-resources cross-machine push divergence (non-fast-forward) — normal git, correctly caught (PENDING)
- **Status:** logged (pending)
- **Category:** session-issue
- **Source:** /resolve-repo-problem 2026-06-09 (MANUAL)
- **Friction source:** At the /wrap-session push gate, `git fetch` found the remote 1 commit ahead while local was 3 ahead → non-fast-forward, push paused. Investigation: the remote commit `4392131 chore: commit leftover uncommitted artifacts from prior sessions` came from **Daniel's machine** and branched in parallel off shared ancestor `4cbc613`. NOT a concurrent-session-on-this-machine collision and NOT a real conflict — the two commit sets touch DISJOINT files (Daniel: archive + permission-sweep + a risk-check + execution-log.md; local: the Milestone-3/4 skills + improvement-log + a risk-check). `git merge-tree` confirms a clean merge, zero conflicts. The push gate's fetch-before-push divergence check worked exactly as designed — this is normal cross-machine git behaviour, correctly detected.
- **Proposal:** No fix needed for the divergence itself — resolve by `git fetch` then `git rebase origin/main` (clean replay, verified no conflicts; rewrites only never-pushed local commits, not autonomy-gated) then fast-forward push. Recommended option A from the triage notes. **Two light systemic angles for Friday review (do NOT over-engineer):** (1) the catch-all "commit leftover uncommitted artifacts from prior sessions" sweep commit is a mild hygiene anti-pattern — a broad untargeted snapshot makes provenance and conflict-reasoning harder; consider a note in `docs/commit-discipline.md` discouraging catch-all sweeps in favour of scoped commits. (2) This is the **cross-machine sibling** of the already-logged 2026-06-09 mid-session-commit / session-notes gap (same root lesson — uncommitted work accumulating across sessions/machines). Consider folding both into one commit-hygiene fix on the cadence rather than two. A pull/fetch-before-work step exists at /prime (Step 0) but cannot prevent a remote commit that lands mid-session; the end-of-session push-gate fetch is the correct and sufficient catch.
- **Target files:** `docs/commit-discipline.md` (optional hygiene note); cross-reference the 2026-06-09 mid-session-commit gap entry above.
- **Notes:** `audits/working/2026-06-09-resolve-ai-resources-remote-divergence-non-fast-forward.md`

### 2026-06-09 — /risk-check Step 17b mandates a /consult call that can never succeed model-side (guarded by disable-model-invocation) (CLOSED — STALE)
- **Status:** closed (stale) — RESOLVED 2026-06-12 (S9): premise verified false. The `disable-model-invocation` flag on `consult.md` was REVERTED 2026-06-10 (consult.md L7–12 carries an explicit do-not-re-add comment naming Step 17b as a designed caller); live /consult invocations in S9 and S10 confirmed the dispatch works. No edit to risk-check.md needed — the planned re-point was dropped at the S9 gate (see decisions.md 2026-06-12 S9).
- **Category:** skill-internal-contradiction + workflow-gate
- **Source:** Observed live, 2026-06-09 S3. The canonical `/risk-check` skill (Step 17b) instructs, for any non-GO verdict, "invoke `/consult` via the Skill tool" to obtain the system-owner second opinion. But `.claude/commands/consult.md` carries `disable-model-invocation`, so the Skill tool refuses it model-side (`Skill consult cannot be used with Skill tool due to disable-model-invocation`). The prescribed Step 17d fallback ("record the second opinion as unavailable and proceed; verdict stands") therefore fires on EVERY model-driven risk-check run — the mandated second opinion is structurally always unavailable. This session worked around it by invoking the underlying `system-owner` agent directly (operator-confirmed as the standing posture, 2026-06-09 S3), which produced a materially load-bearing advisory (rejected the risk-reviewer's top mitigation as a misread of an intentional contract; surfaced an F1→F3 sequencing dependency). The workaround should be the documented path, not an improvisation.
- **Gap:** Step 17b names a dispatch route (`/consult` via Skill tool) that the guard makes impossible; the second-opinion gate is silently degraded to no-op on every automated invocation.
- **Proposal (operator-requested, for Friday cadence):** Reconcile the dispatch. Options to weigh at implementation (this is a canonical-skill edit — run `/risk-check`):
  1. **Re-point Step 17b at the `system-owner` agent directly** (via the Agent tool with `subagent_type: system-owner`), mirroring the prompt template already in 17b. Removes the contradiction at the source; matches what `/consult` dispatches to anyway. Recommended default.
  2. **Update Step 17d** to specify "if `/consult` is guarded/unavailable, invoke the `system-owner` agent directly" rather than recording unavailable — makes the workaround the documented fallback without changing the primary path.
  3. Lift `disable-model-invocation` from `consult.md` — REJECTED on its face: the guard is deliberate (consult is operator-facing); removing it to satisfy risk-check would over-expose it elsewhere.
- **Recommended default:** Option 1 (re-point at the agent) — single source, no guard conflict, no new surface.
- **Target files:** `ai-resources/.claude/commands/risk-check.md` Steps 17b/17d (canonical skill body — verify whether risk-check is a skill SKILL.md or a command file before editing).
- **Review-cycle:** monthly

### 2026-06-09 — New pre-existing Minors surfaced by S3 cold-evals (cluster-memo-refiner ×3, execution-manifest-creator ×1) (DEFERRED)
- **Status:** logged (pending)
- **Category:** skill-convention-gate + skill-output-contract
- **Source:** Independent cold-evaluations during the 2026-06-09 S3 `/improve-skill` defect-cleanup pass. All pre-existing; none introduced by the S3 edits. Held back per scope discipline (outside the parked-defect scope the S3 session was chartered to clear) and logged here rather than folded in.
- **Proposal:**
  - **cluster-memo-refiner — (1) [Minor, Output Contract] No findings-report envelope template.** The full per-memo findings report is described prose-style ("one section per memo, sub-sections per check") with no concrete skeleton showing how per-check outputs + completion-criteria roll-up + blocking-gate verdicts assemble into one deliverable. Fix: add a short report-envelope skeleton (reuse the existing per-check Output formats as sub-section contents).
  - **cluster-memo-refiner — (2) [Minor, C17] 30%/40% blocking-gate constants lack in-skill rationale.** The `>30% NOT-SUPPORTED → CLUSTER-INSUFFICIENT` / `>40% → SECTION-INSUFFICIENT` thresholds appear as bare numbers (attributed to `quality-standards.md`, which mitigates but does not annotate). Fix: add a half-sentence noting they are the canonical thresholds owned by `quality-standards.md` and must be read from there if a project overrides (mirror the risk-tier sourcing).
  - **cluster-memo-refiner — (3) [Minor, C18] Hard-vs-soft reference-dependency split not declared.** Checks 8/9/10 hard-depend on `quality-standards.md` sections (`§ Claim-Permission Classes`, `§ Country Coverage Table`, `§ Source-Conflict Resolution Procedure`) with no documented fallback, while the risk-tier section is presence-gated. Fix: add a "Required reference sections" note distinguishing hard deps (halt-or-flag if absent) from the presence-gated optional ones.
  - **execution-manifest-creator — (4) [Minor, C14] No in-skill worked input→output example.** The output contract is specified by reference to `references/manifest-template.md` + column specs + Self-Check, but no end-to-end worked example (a question flowing Answer Spec → routing → session → source-plan row). Fix: confirm `manifest-template.md` carries at least one fully-worked example row (GPT + CustomGPT); if it is a blank skeleton, add a worked example there (keeps SKILL.md lean).
- **Target files:** `ai-resources/skills/cluster-memo-refiner/SKILL.md`; `ai-resources/skills/execution-manifest-creator/references/manifest-template.md`
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

### 2026-06-10 — Port /wrap-session Step 13 per-id teardown to the workspace-root wrap-session.md copy (PENDING)
- **Status:** logged (pending)
- **Category:** guardrail-candidate
- **Severity:** low
- **Provenance:** wrap-collector (machine-authored, manually re-appended after a collector write incident) 2026-06-10
- **Friction source:** wrap-collector 2026-06-10 — safety / guardrail-gap (S1)
- **Proposal:** Fix 1 (S1, 2026-06-10) added Step 13 to the canonical `ai-resources/.claude/commands/wrap-session.md` — a per-id session-marker teardown (`rm -f logs/.session-marker-${CLAUDE_CODE_SESSION_ID}`) that makes the per-id marker set a liveness signal for `detect-concurrent-session.sh`'s same-checkout false-fire fix. The workspace-root `/.claude/commands/wrap-session.md` is an independent non-symlink copy and does NOT yet have Step 13 (flagged in-code via MIRROR NOTE). Until ported, workspace-root sessions won't clean up their per-id markers at wrap, so the detector's same-checkout false-fire returns for workspace-root-launched sessions (a wrapped session's per-id marker persists → counts as "live" → SHARP nudge mis-fires). Port Step 13 to the workspace-root copy as its final step on the next sync. Latent degradation only (an occasional unnecessary soft nudge), no harm.
- **Target files:** `/.claude/commands/wrap-session.md` (workspace-root); cross-ref `ai-resources/.claude/commands/wrap-session.md` Step 13 + `ai-resources/.claude/hooks/detect-concurrent-session.sh`.
- **Review-cycle:** monthly

### 2026-06-10 — Harden session-feedback-collector to append-only (destructive-Write recurrence) (RESOLVED)
- **Status:** applied — RESOLVED 2026-06-12 (S9 batch, commit 0ee6177: `Write` removed from the agent's toolset, `Edit`+`Bash` added; Constraint E rewritten categorical append-only)
- **Verified:** 2026-06-12 — S9 independent /qc-pass GO; status flipped 2026-06-12 S11 after confirming the edit live in `.claude/agents/session-feedback-collector.md`
- **Category:** guardrail-candidate
- **Severity:** medium
- **Provenance:** main-session (escalated from friction-log on second occurrence) 2026-06-10
- **Friction source:** wrap-collector destructive-overwrite incidents — 2026-06-09 (S5, overwrote improvement-log.md) + 2026-06-10 (S1, overwrote friction-log.md)
- **Proposal:** The `session-feedback-collector` subagent has now destructively overwritten an append-only shared log via a whole-file `Write` in TWO consecutive substantive sessions (S5: `improvement-log.md` → `placeholder`; S1: `friction-log.md` → 1-line header), each time caught + restored from HEAD but only because the file was clean == HEAD at session start. This is a confirmed pattern, not a one-off. Harden the agent so it CANNOT whole-file-`Write` a shared log: (a) instruct the agent to append exclusively via `Bash` heredoc (`cat >> log <<'EOF'`) or `Edit` on a unique anchor, never `Write`; (b) optionally add a pre-write entry-count floor / line-count guard (mirror the `/improve` guard that `docs/commit-discipline.md § Shared-log write-path integrity` prescribes for the non-append logs) so a truncating write is refused before it lands. The agent already self-detects and refuses to reconstruct (good failure behavior) — the gap is purely that the destructive write happens at all. Also: the agent created a stray `.append-marker-tmp` scratch file (S1) — instruct it to use no on-disk scratch.
- **Target files:** `ai-resources/.claude/agents/session-feedback-collector.md`; cross-ref `docs/commit-discipline.md § Shared-log write-path integrity`.
- **Review-cycle:** weekly

### 2026-06-10 — system-owner agent reports "Full advisory on disk" without writing the file (PENDING)
- **Status:** logged (pending)
- **Category:** session-issue
- **Severity:** medium
- **Provenance:** main-session (observed live during a /clarify → SO-first design session) 2026-06-10
- **Friction source:** /consult → `system-owner` agent (Task) 2026-06-10 — three SO invocations this session each returned the verbatim `**Full advisory on disk:** {path}` lead line, but NONE of the three files were written (consultations dir had nothing newer than 2026-06-04). The agent's Phase 5 contract (`system-owner.md:87`) explicitly mandates the write ("Always write … using your `Write` tool"), so the instruction exists and is being skipped while the path-back line is still emitted. Separately, one pass falsely asserted `docs/change-shape-classifier.md` "is not there" when it exists and is canonical — a second-order grounding/hallucination symptom. Net consequence: the SO architectural audit trail is silently lost, and a load-bearing reconciliation argument was built on a false file-absence claim.
- **Proposal:** Root cause is a self-reported-path-with-no-verification gap: the `**Full advisory on disk:** {path}` line is a model claim, not a verified artifact, and instruction-strengthening alone already failed (Phase 5 says "Always write"). Recommended structural fix is caller-side verification — in `/consult` Step 5 (`.claude/commands/consult.md`), after the agent returns, check that the file at the returned path actually exists; if missing, persist the returned summary to that path (or re-invoke once). Apply the same post-return existence check to the other SO callers (`/architecture-review`, `/systems-review`, `/friday-so`, `/so-monthly`). This converts the path-back line from trust to verify and closes the lost-audit-trail gap regardless of why the agent skips the Write. Editing canonical commands is a /risk-check change class — gate before landing. The false file-absence claim is a separate grounding-reliability issue; note it but do not conflate — it is not fixed by the existence check.
- **Target files:** `ai-resources/.claude/commands/consult.md` (Step 5 post-return verification); cross-ref `ai-resources/.claude/agents/system-owner.md:87` (Phase 5 write contract) and the other SO-caller commands (`architecture-review.md`, `systems-review.md`, `friday-so.md`, `so-monthly.md`).
- **Review-cycle:** weekly

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

### 2026-06-12 — split-log.sh: no fail-loud content-conservation tripwire against silent data loss (RESOLVED)
- **Status:** resolved 2026-06-12 (S10, commit 39c2ba5) — shipped as the conservation tripwire; see the "split-log.sh content-conservation tripwire SHIPPED (S10)" entry below, which records the fix and explicitly resolves this entry. Status flipped 2026-06-12 S11.
- **Category:** guardrail-candidate
- **Severity:** low
- **Provenance:** wrap-collector (machine-authored, appended by main session — collector toolset lacked append primitive) 2026-06-12 S6
- **Proposal:** `split-log.sh` archival has no content-line-conservation check; both silent data-loss paths fixed this session (preamble deletion, fenced-header miscount) were caught only by manual isolated testing, not by the script itself. Add a pre-write assertion: count content lines of the input file and of (preamble + archive block + keep block); abort non-zero on mismatch before the `mv` lands. Fail-loud against the NEXT unknown loss path, not just the two now closed.
- **Target files:** `ai-resources/logs/scripts/split-log.sh`; `ai-resources/workflows/research-workflow/logs/scripts/split-log.sh` (lockstep)
- **Review-cycle:** monthly

### 2026-06-12 — /resolve-improvement-log resolved-classification rule matches zero real entries (strict `applied`+`Verified:` vs de facto `resolved` convention) (RESOLVED)
- **Status:** applied — RESOLVED 2026-06-12 (S9 batch, commit 0ee6177: two-tier Resolved classification added to `resolve-improvement-log.md` Step 3 — strict tier-1 plus `resolved YYYY-MM-DD` convention tier-2, with [strict]/[convention] presentation tags). The deferred lockstep preamble edit was applied 2026-06-12 S11 (see preamble Status schema note).
- **Verified:** 2026-06-12 — S9 independent /qc-pass GO; preamble lockstep confirmed in S11
- **Category:** session-feedback
- **Provenance:** wrap-collector (machine-authored) 2026-06-12
- **Friction source:** wrap-collector 2026-06-12 — autonomy-compounding / friction (S8)
- **Proposal:** `/resolve-improvement-log`'s strict resolved-classification rule (an entry must carry BOTH `Status: applied` AND a `Verified:` line — improvement-log.md preamble L9) matches zero entries in practice; the log's de facto convention marks completion as `resolved YYYY-MM-DD` and most done entries lack the `Verified:` line. The mismatch forced operator adjudication mid-run this session (S8 archived 12: 2 tier-1 strict-match, 9 tier-2 done-marked-without-Verified, 1 superseded watch item). Reconcile the rule with the convention so future runs classify without operator intervention — either teach `/resolve-improvement-log` to also accept the `resolved YYYY-MM-DD` form, or normalize the schema and update preamble + command in lockstep.
- **Target files:** (to be determined at disposition) — candidate: `ai-resources/.claude/commands/resolve-improvement-log.md` (classification rule); `ai-resources/logs/improvement-log.md` preamble L9 (Verified/Status schema); keep in lockstep.
- **Review-cycle:** monthly

### 2026-06-12 — split-log.sh content-conservation tripwire SHIPPED (S10)
- **Status:** applied
- **Resolved:** 2026-06-12 (S10, /fix-project-issues batch)
- **Category:** guardrail
- **Provenance:** /fix-project-issues 2026-06-12 S10 (id-31; SO advisory consult-2026-06-12-fix-project-issues-ai-resources.md)
- **What shipped:** Pre-write conservation assertion in `split-log.sh`: non-blank line conservation (keep + archive == entry region) + fence-aware header-count conservation (keep + archive headers == TOTAL). Aborts exit 1 BEFORE any write on mismatch. Verified by isolated fixture tests: top/bottom orders, fenced preamble, idempotent re-run, injected off-by-one bug → tripwire fired, files untouched. QC GO. Canonical + template copy byte-identical. This resolves the 2026-06-12 S6 "no fail-loud content-conservation tripwire" entry above.
- **Target files:** `ai-resources/logs/scripts/split-log.sh`; `ai-resources/workflows/research-workflow/logs/scripts/split-log.sh` (lockstep, cmp-verified)
- **Verified:** 2026-06-12 — in-session fixture tests (success/abort paths) + independent QC GO (same session, S10)

### 2026-06-12 — split-log.sh tripwire propagation to 11 deployed copies (named trigger)
- **Status:** logged (pending)
- **Category:** propagation
- **Severity:** medium
- **Provenance:** risk-check 2026-06-12 S10 residual risk #1 (SO second opinion, consult-2026-06-12-risk-check-2nd-opinion-s10-fix-batch.md)
- **Proposal:** The 11 deployed project-local `split-log.sh` copies (re-synced 2026-06-12 S7, f84f601) do not yet carry the S10 conservation tripwire — non-uniform-guarantee window until re-synced. **Named trigger: the next `/sync-workflow` run OR the next Friday cadence session, whichever comes first.** Re-sync is mechanical (S7's 11-target list + cmp byte-identity per copy); exclude the frozen archive copy per the S7 decision.
- **Deprioritized (operator, 2026-06-12 S11):** the operator marked this item "not important anymore" during the S11 prime menu. Note: the named trigger technically fired in S11 (a `/sync-workflow` run on positioning-research happened that session) but propagation was NOT executed per the operator's deprioritization. Entry stays pending at lowered priority; treat the next Friday cadence as a soft trigger only — confirm with the operator before executing.
- **Target files:** the S7 11-copy target list (see decisions.md 2026-06-12 S7 entry); canonical source `ai-resources/logs/scripts/split-log.sh`
- **Review-cycle:** weekly

### 2026-06-12 — reconcile-at-read misses already-done items behind opaque-subject commits (3 of 6 SO-vetted do-now stale)
- **Status:** logged (pending)
- **Category:** session-feedback
- **Provenance:** wrap-collector (machine-authored) 2026-06-12
- **Friction source:** wrap-collector 2026-06-12 — leanness/cost + autonomy-compounding (S10 § Decisions L511–512, § Next Steps L529)
- **Proposal:** The reconcile-at-read primitive (`docs/backlog-reconciliation.md` + `/fix-project-issues` Step 2.5, shipped 2026-06-05 S14 to resolve the dated-report-staleness recurrence) demotes already-done candidates by **keyword** match. In S10, 3 of 6 SO-vetted do-now items were still stale because their resolving commits carried opaque subjects (e.g. id-04 mirror-collapse shipped under "W24" 7d415fc; audit + fix landed same-day) that keyword reconcile did not catch — so dead candidates passed reconcile, reached SO vetting + batch risk-check, and were only dropped at apply. Distinct mechanism from the 2026-06-05 dated-report entry (already RESOLVED): that closed report-vs-live staleness; this is reconcile's keyword-blindness to commits that **touched the named target files** but don't name them in the subject. Direction (collector does not fix): consider augmenting reconcile-at-read to also scan `git log` for commits touching each candidate's cited target file/line since the source report's date, not subject keywords alone. Note flags it for an `/improve` look.
- **Target files:** (to be determined at disposition) — candidates: `ai-resources/docs/backlog-reconciliation.md`; `ai-resources/.claude/commands/fix-project-issues.md` Step 2.5; `ai-resources/.claude/commands/fix-repo-issues.md` Step 3.0 (lockstep).
- **Review-cycle:** monthly

### 2026-06-12 — Mission promote-rw-canonical close findings: SETUP.md stale copy-path + 2 project down-ports + unanchored archive/ gitignore (PENDING)
- **Status:** logged (pending)
- **Category:** template-defect + propagation
- **Severity:** low
- **Provenance:** S11 mission-close deploy-test + /sync-workflow run (2026-06-12)
- **Proposal:** Four follow-ups from the mission-close verification. (0) **`.gitignore` L42 `archive/` is unanchored** — it matches any `archive/` directory at any depth, not just the top-level one its comment names, so `logs/missions/archive/` (the mission-close destination prescribed by `/mission` Step 5) is silently gitignored; the closed-mission record had to be force-added (`git add -f`) in S11 to stay tracked. Fix candidate: anchor to `/archive/` — but first enumerate nested `archive/` dirs the unanchored pattern currently (perhaps intentionally) ignores; a gitignore edit is a structural change, gate it. (1) **SETUP.md Step 1 copy path is stale:** it reads `cp -r workflows/active/research-workflow/project-template/ ...` but neither `workflows/active/` nor a `project-template/` subdir exists — the template IS `ai-resources/workflows/research-workflow/` itself. A new deployer following Step 1 verbatim fails at the first command. Fix: correct the path and clarify that the whole directory is the template. (2) **positioning-research's `friction-log-auto.sh` lacks the C6 repair** (pre-C6 PreToolUse-only version, 1 "Friction Events" ref vs canonical's 4) — friction events from tool errors are not auto-captured in that project's sessions. Down-port from canonical (also needs the project's settings.json PostToolUse wiring — check before copying). (3) **positioning-research's `run-execution.md` lacks canonical's Check 4** (sampled scarcity-verdict independence check) — update available, project's choice when to take it.
- **Target files:** `ai-resources/workflows/research-workflow/SETUP.md` (Step 1); `projects/positioning-research/.claude/hooks/friction-log-auto.sh` + that project's `settings.json` (item 2); `projects/positioning-research/.claude/commands/run-execution.md` (item 3)
- **Review-cycle:** monthly

### 2026-06-12 — system-owner agent loses its grounding corpus when spawned from ai-resources (false Shape-1 halt)
- **Status:** logged (pending)
- **Category:** agent-defect
- **Severity:** medium
- **Provenance:** use-case investigation 2026-06-12, post-S11 session (audits/use-case-routine-task-improvement-2026-06-12.md § 7)
- **Proposal:** During a consultation in the 2026-06-12 post-S11 session, the `system-owner` agent globbed only the `ai-resources/` tree for its REQUIRED grounding corpus (`persona.md`, `grounding.md`, `toolkit-relationship.md`, etc.), declared it "verified-absent on disk," and fired its Shape-1 degraded mode (`[CITATION NEEDED]` advisory) — a false alarm. The corpus exists at `projects/axcion-ai-system-owner/references/` (workspace root). When spawned from an `ai-resources/` session, the agent's relative-path/glob resolution does not reach the workspace root. A second instance found the corpus once the prompt supplied the absolute path — so a prompt-side workaround exists, but the agent definition should resolve its grounding robustly (absolute path or upward walk, mirroring `auto-sync-shared.sh`'s idiom). Fix is an agent-definition edit → structural change class, gate per audit-discipline.
- **Target files:** `ai-resources/.claude/agents/system-owner.md` (grounding path resolution); possibly `projects/axcion-ai-system-owner/references/grounding.md` (read-map wording)
- **Review-cycle:** weekly

### 2026-06-12 — Routine-Yield Review in /pipeline-review: deferred build, named trigger (TRACK-FIRST)
- **Status:** logged (pending)
- **Category:** deferred-build
- **Severity:** low
- **Provenance:** use-case investigation 2026-06-12 (audits/use-case-routine-task-improvement-2026-06-12.md § 6)
- **Proposal:** The Routine Task Improvement System investigation closed TRACK-FIRST: the session-level 80/20 system (wrap-session Step 6.4 + friday-checkup item 14.5, both shipped 2026-06-12) must accumulate evidence before any routine-level build. **Named trigger: the first monthly-tier `/friday-checkup` after ≥3 Weekly Session Value Review sections exist (≈4 weeks).** At that point evaluate two questions from the accumulated roll-ups: (a) do the same recurring session types draw Batch/Redesign/Stop decisions ≥2–3 times without resolution? (b) does drag fail to attribute to a specific routine because data is session-grained? If either holds → build the trimmed SO shape: one monthly Routine-Yield Review section in `/pipeline-review` (comparative routine ranking, decision menu incl. Merge/Reduce-cadence/Automate, two guardrail rules, one-improvement-only; maintenance machinery mandatory in the ranking — registry targets already exist). If neither holds → close as DROP. Route the decision through `/friday-so`, which also owes the deferred SO confirmation of the inline TRACK-FIRST call (SO re-consult was credit-gate-blocked on 2026-06-12).
- **Target files:** (only if trigger fires) `ai-resources/.claude/commands/pipeline-review.md`; `ai-resources/audits/pipeline-review-registry.md` (mandatory-inclusion note)
- **Review-cycle:** monthly
