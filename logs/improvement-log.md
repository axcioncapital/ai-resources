# Improvement Log

## Schema

Each entry is a `### YYYY-MM-DD — {title}` block. Fields:

- **Status:** `logged` | `proposed` | `pending` | `applied YYYY-MM-DD`
  *De facto convention: all current unresolved entries use `logged (pending)` as a combined compound state. The `/friday-checkup` [STALE] detection rule (added 2026-05-06) matches this compound form — not `pending` alone. If entries are normalized to the single-token schema in future, update the [STALE] match string in `friday-checkup.md` Step 6 accordingly.*
- **Verified:** present when Status is `applied` and the operator has confirmed the fix is live. Both `Status: applied` AND `Verified:` are required for `/resolve-improvement-log` to classify an entry as resolved.
- **Age:** auto-computed from the header date by `/resolve-improvement-log`; surfaced when > 6 weeks without resolution.
- **Review-cycle:** for items not yet resolved — records the last review date and disposition (e.g., `reviewed 2026-04-24, deferred to next quarterly`).
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

### 2026-05-28 — /session-start Step 0.5 mtime guard misses foreign writes that arrive DURING the Mandate Confirmation wait

- **Status:** logged — superseded by the broader 2026-05-28 entry below ("Concurrent sessions cause TOCTOU races on shared log files"); Phase 1 of the broader entry applied 2026-05-28. The narrow Step 2.5 patch proposed here is no longer the recommended fix; the structural per-session-marker approach replaces it. Retained for trace-history of how the problem was first observed.
- **Category:** session-issue
- **Source:** Surfaced live during axcion-brand-book session 2026-05-28 — operator explicitly attributed the trigger to "I start concurrent sessions."
- **Friction source:** /session-start Step 0.5 runs the concurrent-session mtime guard exactly once, immediately after Step 0's session-notes.md read and before Step 1 reads the mandate. It compares `SESSION_NOTES_MTIME` against `PRIME_MTIME` (or against `NOW - 120s` fallback) at that single instant. Today the guard returned `DELTA=0` (clean) at Step 0.5; Step 1 used the supplied mandate verbatim; Step 2 echoed the Mandate Confirmation block and waited for the operator's `y`. During that wait, the operator started a second /prime session, selected a different menu task (task 3 — backfill `_appendix/rejected_directions.md`), and that concurrent /prime wrote a `**Work (redirected via /prime task selection):**` line to logs/session-notes.md. The operator's `y` then arrived in the original session against the original (specimen) mandate echo — but session-notes.md by then contained the redirect line for the backfill task. The original session would have proceeded to Step 3 and written the specimen mandate alongside the foreign redirect line if the operator had not corrected the path via AskUserQuestion. Reproduction is reliable whenever a foreign session writes to session-notes.md between Step 0.5 (clean) and Step 3 (write).
- **Proposal:** Add a second mtime check at Step 3 immediately before locating today's header for the mandate-line write — call it "Step 2.5 — Re-check mtime guard at write time." Capture `WRITE_TIME_MTIME = stat session-notes.md` and compare to the `SESSION_NOTES_MTIME` value already captured in Step 0.5 (must persist that value into Step 3's scope). If `WRITE_TIME_MTIME > SESSION_NOTES_MTIME`, a foreign write happened during the Mandate Confirmation wait → surface a conflict block before applying the operator's confirmation: re-read the last ~20 lines of session-notes.md, show the diff to the operator, offer (1) proceed with the originally-confirmed mandate, (2) re-echo a new Mandate Confirmation reflecting whatever the foreign write redirected to, (3) stop. Default on no-response = (3) stop. Edits confined to `ai-resources/.claude/commands/session-start.md` (new Step 2.5 between Step 2 and Step 3). **/risk-check change class:** YES (canonical-command body edit; /session-start runs at every session start) — run /risk-check as advisory gate before landing. Secondary consideration: today's Step 0.5 tuning notes call out the 120s threshold and freshness window but do not anticipate the during-Step-2 window. Update the tuning-notes block in Step 0.5 to forward-reference the new Step 2.5 so operators reading Step 0.5 understand its coverage limit.
- **Target files:** `ai-resources/.claude/commands/session-start.md` (insert Step 2.5 between Step 2 and Step 3; update Step 0.5 tuning notes to forward-reference Step 2.5). Also worth considering: a one-line companion note in `ai-resources/.claude/commands/prime.md` Step 8a.3 reminding that the marker-write at Step 8a.3.a does not protect /session-start's Step 2 confirmation window.

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

- **Status:** logged (pending)
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

### 2026-05-29 — Pre-spec consumer-inventory grep checklist (SO advisory, TOCTOU Phase 2+3 rollout)

- **Status:** logged (pending)
- **Category:** Audit-recurrence prevention / spec-authoring discipline
- **Source:** System-owner Function-B advisory on Round 2 risk-check of TOCTOU Phase 2+3 atomic spec — `audits/risk-checks/2026-05-29-plan-time-gate-for-toctou-mitigation-atomic-phase-2-3.md` § Architectural Commentary § Position § Process observation. Same observation parked at `logs/maintenance-observations.md` § "2026-05-29 — Pre-spec consumer-inventory checklist (TOCTOU Phase 2+3 rollout)"; promoted here so it surfaces in `/friday-checkup` Step 6 (rather than only on quarterly maintenance-observations sweep).
- **Friction source:** TOCTOU Phase 2+3 spec authoring under-counted affected files by 4 in Round 1 (Phase 2-only spec) and another 4 in Round 2 (atomic spec). Same defect class — under-counted consumers of a renamed/removed path — repeated across rounds. Both rounds returned PROCEED-WITH-CAUTION; reviewer correctly caught both misses, but each round cost a full risk-check invocation + SO advisory + operator decision-loop turn. The pattern generalises: spec authors enumerate obvious consumers (commands explicitly named in the source-authority proposal) and miss orphan consumers (docs tables, scaffolding lists, narrative references in unrelated docs, operator-facing chat strings inside command bodies).
- **Proposal:** Add a pre-spec grep checklist to skill docs — likely `ai-resources/skills/ai-resource-builder/SKILL.md` (the resource-creation skill that hosts /create-skill, /improve-skill, /migrate-skill) and/or a new `ai-resources/docs/spec-authoring-checklist.md` referenced from `audit-discipline.md`. Checklist: "Before writing a structural-change spec that renames or removes a path, run `grep -rn '<old-path>' .claude/ docs/ skills/ workflows/ templates/ CLAUDE.md` and enumerate every consumer in the spec's affected-file list. The grep is mechanical; the inventory miss is consistent across spec authors." Mechanical inventory closes the loop BEFORE risk-check, preserving the PROCEED-WITH-CAUTION verdict for genuinely structural concerns.
- **Risk if left undone:** Recursive PROCEED-WITH-CAUTION verdicts continue as an inefficient signal class — every rename/removal spec re-spawns the inventory-miss cost. Two rounds observed this session is a clear pattern.
- **Target files:** `ai-resources/skills/ai-resource-builder/SKILL.md` (add pre-spec checklist subsection) OR `ai-resources/docs/spec-authoring-checklist.md` (new, referenced from `audit-discipline.md`) — placement decision deferred to the implementation session.
- **Triage cadence:** Friday weekly cadence — small implementation footprint, high recurrence frequency on structural-change sessions.

### 2026-05-29 — /resolve-improvement-log Step 7b conflicts with archive read-deny

- **Status:** logged (pending)
- **Category:** session-issue
- **Source:** /resolve-repo-problem 2026-05-29
- **Friction source:** `/resolve-improvement-log` Step 7b prescribes a merge-and-sort archive path that reads existing archive entries and rewrites the archive in chronological order. `ai-resources/.claude/settings.json` line 32 denies `Read(logs/*archive*.md)`, blocking that read. Today's invocation worked by accident — the newest entry naturally appended to the end — but the skill silently breaks the moment an earlier-dated entry needs archiving. The same deny affects `improve.md` + `improvement-analyst` archive de-dup scans.
- **Proposal:** Apply Option 1 (recommended by /resolve-repo-problem subagent). Rework Step 7b in `.claude/commands/resolve-improvement-log.md` to chronological-append-only — drop the "read archive + merge + sort + rewrite" simpler-implementation language; specify append-to-end as the canonical path. The active log's outgoing order IS the canonical chronological order; archive-time IS the entry order. No settings change, no /risk-check gate (same-command logic edit). The `improvement-analyst` archive de-dup scan remains broken and should be logged as a separate follow-up.
- **Target files:** `ai-resources/.claude/commands/resolve-improvement-log.md` Step 7b (rewrite the archive procedure).
- **Notes:** /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/2026-05-29-resolve-the-resolve-improvement-log-skill-cannot-complete.md
