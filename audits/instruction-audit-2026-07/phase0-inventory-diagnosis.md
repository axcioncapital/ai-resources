# Phase 0 — Instruction System Inventory & Diagnosis (frozen working artifact)

**Date:** 2026-07-03
**Scope:** Full instruction-bearing corpus — the 2 always-loaded `CLAUDE.md` files, the ~40 docs they reference, and the 84 commands / 80 skills / 40 agents in `ai-resources/`.
**Status:** Frozen as of Phase 0. This is the diagnostic baseline the rest of the campaign edits against — do not silently update; re-run the relevant section if repo state has materially changed.

---

## 1. Always-on layer map

**Total always-loaded footprint: 309 lines** — root `CLAUDE.md` (231 lines / ~2,610 words) + `ai-resources/CLAUDE.md` (78 lines / ~823 words).

### 1.1 Root `CLAUDE.md` — section inventory (231 lines)

| # | Section | Lines | Type | Target doc |
|---|---|---|---|---|
| 1 | What This Workspace Is For | 1–5 | inline | — |
| 2 | Projects | 7–11 | inline | — |
| 3 | Axcíon's Tool Ecosystem | 13–21 | inline | — |
| 4 | Cross-Model Rules | 23–25 | summary + pointer | `docs/cross-model-rules.md` |
| 5 | Skill Library | 27–29 | inline | — |
| 6 | AI Resource Creation | 31–33 | summary + pointer | `docs/ai-resource-creation.md` |
| 7 | Placement Discipline | 35–48 | inline (full) | — |
| 8 | Design Judgment Principles | 50–53 | inline + pointer | `docs/analytical-output-principles.md` |
| 9 | QC Independence Rule | 55–61 | pointer + substantial inline rule | `docs/qc-independence.md` |
| 10 | Contract-Conformance Check | 63–74 | inline (full) | — |
| 11 | Blind-Spot Scan Gate | 76–78 | inline (full, dense) | — |
| 12 | Assumptions Gate | 80–82 | inline (full) | — |
| 13 | Completion Standard | 84–86 | inline (full) | — |
| 14 | Requirements-Doc Default | 88–92 | inline (full) | — |
| 15 | Working Principles (6 bullets) | 94–102 | mixed | `docs/compaction-protocol.md`, `docs/session-boundaries.md` |
| 16 | Chat Communication Style | 104–112 | inline (full) | — |
| 17 | File Write Discipline | 114–116 | one-liner + pointer | `docs/file-write-discipline.md` |
| 18 | Autonomy Rules (10-item list) | 118–133 | inline full list + pointer | `docs/autonomy-rules.md` |
| 19 | Decision-Point Posture | 135–137 | inline (full), no pointer | — |
| 20 | QC → Triage Auto-Loop | 139–141 | pure pointer | `docs/qc-independence.md` § QC→Triage |
| 21 | Session Guardrails | 143–154 | inline (4 flags) + pointer | `docs/session-guardrails.md` |
| 22 | Plan Mode Discipline | 156–160 | pointer + 1 inline line | `docs/plan-mode-discipline.md` |
| 23 | CLAUDE.md Scoping | 162–169 | inline (full) | — |
| 24 | Model Tier | 171–177 | inline full rule + pointer | `docs/agent-tier-table.md` |
| 25 | Model Escalation | 179–188 | inline full + pointer (exception) | `docs/autonomy-rules.md` § Model Escalation |
| 26 | Adaptive Thinking Override | 190–192 | inline (full) | — |
| 27 | File verification and git commits (4 sub-sections) | 194–222 | mostly inline; last sub-section pointer | `docs/commit-discipline.md` |
| 28 | Delivery | 224–226 | inline (full) | — |
| 29 | Agent Harness | 228–230 | pointer (conditional load) | `.claude/references/harness-rules.md` |

### 1.2 `ai-resources/CLAUDE.md` — section inventory (78 lines)

| # | Section | Lines | Type | Target doc |
|---|---|---|---|---|
| 1 | What This Repo Contains | 1–12 | inline | — |
| 2 | How I Work | 14–16 | inline + internal pointer | → own § Commit Rules |
| 3 | Skill Creation and Improvement | 18–20 | pointer | `skills/ai-resource-builder/SKILL.md` |
| 4 | Model Selection | 22–24 | inline restatement + pointer | root `CLAUDE.md` § Model Tier |
| 5 | Subagent Contracts | 26–34 | inline (full) | — |
| 6 | Session Telemetry | 36–40 | inline (full) | — |
| 7 | Maintenance Cadence | 42–46 | inline + pointer | `.claude/commands/friday-checkup.md`, `audits/pipeline-review-registry.md` |
| 8 | Permission Management | 48–50 | inline + pointer | `docs/permission-template.md` |
| 9 | General Session Rules | 52–56 | inline (full) | — |
| 10 | Git Rules | 58–62 | inline + internal pointer | → own § Commit Rules |
| 11 | Commit Rules | 64–68 | inline restatement + pointer | root `CLAUDE.md` § File verification and git commits |
| 12 | Compaction | 70–77 | inline (full, project-specific) | — |

### 1.3 Duplication / contradiction findings

| Finding | Detail | Severity |
|---|---|---|
| **A. Push contradiction** | Root `CLAUDE.md` (Autonomy #2 + full "Push behavior" section) states push is gated/batched/y-n-confirmed. `docs/autonomy-rules.md` line 12 — the doc root cites as canonical — states push "proceeds autonomously after commit." Direct conflict on the highest-stakes action. | HIGH |
| **B. Decision-Point Posture orphan duplicate** | Stated in full independently in root `CLAUDE.md` (135–137, no pointer) AND `docs/autonomy-rules.md` (28–32). No cross-reference either direction. | MEDIUM |
| **C. Autonomy 10-item list duplicated, not delegated** | Full list in root `CLAUDE.md` (118–133) AND re-listed in full in `docs/autonomy-rules.md` (7–20), with the item-2 contradiction (finding A) baked into both copies. | MEDIUM |
| **D. QC-unreachable/commit-blocked rule restated in full twice** | Root `CLAUDE.md` line 61 states the full mechanic; `docs/qc-independence.md` line 12 restates it almost clause-for-clause. Elaboration-shaped but the operative rule is complete in both. | LOW |
| **E. Model Tier duplicated across both CLAUDE.md files** | Root (171–177) states the full prohibition; `ai-resources/CLAUDE.md` (22–24) restates the core sentence before pointing back. | LOW |
| **F. Commit/push stated inline 3×** | Root § File verification and git commits (canonical) + `ai-resources/CLAUDE.md` § Git Rules (58–62) + § Commit Rules (64–68), both restating before pointing to root. | MEDIUM |
| **G. Session Guardrails restated at scale** | Root (143–154) gives each flag a one-line def; `docs/session-guardrails.md` (89 lines) restates definitions in depth before adding real new content (exemptions, tuning). Legitimate elaboration, not pure duplication. | LOW (no action needed beyond trim) |
| **H. Stale provenance in `session-boundaries.md`** | Doc header claims it's pointed to from root, `ai-resources/CLAUDE.md`, and every project CLAUDE.md. Verified: only root points to it. | LOW (cosmetic fix) |

### 1.4 Sizes of pointed-to docs (selected)

| Doc | Lines | Words |
|---|---|---|
| `docs/session-boundaries.md` | 7 | 100 |
| `docs/analytical-output-principles.md` | 9 | 200 |
| `docs/cross-model-rules.md` | 13 | 191 |
| `docs/plan-mode-discipline.md` | 13 | 330 |
| `docs/file-write-discipline.md` | 12 | 294 |
| `docs/qc-independence.md` | 26 | 1,114 |
| `docs/compaction-protocol.md` | 34 | 530 |
| `docs/autonomy-rules.md` | 36 | 692 |
| `docs/ai-resource-creation.md` | 55 | 1,147 |
| `docs/audit-discipline.md` | 60 | 855 |
| `docs/commit-discipline.md` | 74 | 2,029 |
| `docs/defect-to-fix-loop.md` | 49 | 756 |
| `docs/agent-tier-table.md` | 93 | 976 |
| `docs/session-guardrails.md` | 89 | 1,011 |

None of these docs are force-read every session — all sit behind a pointer or explicit trigger. The always-on cost is strictly the 309 lines; the docs are pay-as-you-go except where findings B–F mean CLAUDE.md already pre-paid for content the docs also carry.

### 1.5 Project-level CLAUDE.md count
32 `CLAUDE.md` files repo-wide; 2 are always-loaded (analyzed above); 30 are project/vault-scoped and out of scope for this campaign.

---

## 2. Corpus survey (commands / agents / skills)

**Sizes:** Commands n=84, median 118.5 lines (longest: `new-project.md` 663, `prime.md` 566, `friday-act.md` 491, `wrap-session.md` 483, `friday-checkup.md` 452). Agents n=40, median 89 lines (longest: `risk-check-reviewer.md` 329, `permission-sweep-auditor.md` 235, `context-discovery.md` 235). Skills n=80, median 205 lines (longest: `research-plan-creator/SKILL.md` 491, `answer-spec-generator/SKILL.md` 487, `ai-resource-builder/SKILL.md` 443).

**Overlap clusters — all reviewed as intentional layering, not duplication:**
- QC/review family (`qc-pass`, `refinement-pass`, `refinement-deep`, `contract-check`, `drift-check`, `blindspot-scan`, `triage`, `resolve`) — each has an explicit "not for X, use Y" boundary in its own doc header. Distinct objects of review.
- Friday family (`friday-checkup`→`friday-so`→`friday-journal`→`friday-act`) — documented sequential pipeline; `monday-prep` and `pipeline-review` are separate cadences, thematically adjacent but distinct (naming-adjacency risk flagged, not a functional defect).
- Audit family (`audit-repo`, `token-audit`, `repo-dd`, `audit-claude-md`, `log-sweep`, `permission-sweep`) — distinct domains, but **near-identical procedural skeleton** (Scope→PathSetup→SanityCheck→Delegate→Verify→Commit→Summarize) reimplemented per file. This is the main cross-file duplication source in the corpus — targeted in Phase 4.
- Scoping/planning family (`scope`, `scope-project`, `session-plan`, `session-start`, `prime`, `clarify`, `grill-me`, `tech-consult`) — distinct trigger + output artifact each; mild overlap between `clarify`/`grill-me` and between `scope`/`session-plan`/`session-start`, each with an explicit boundary note.

**Procedural bloat concentrates in 4 places:**
1. Duplicated audit skeleton across the 6 audit-family commands (see above).
2. Dated provenance narration baked into executable steps — `prime.md` carries multiple inline `(source, YYYY-MM-DD)` fragments (verified format, e.g. line 51 `(token-audit R4, 2026-05-25)`; also lines 70/101/109/361/539/541) — changelog information living inside instruction text rather than git history.
3. Duplicated embedded templates — e.g. `new-project.md` carries two separate `# Decisions —` scaffolds (bare-table version ~L129, full narrative version inside a bash heredoc ~L503-521); some long skills carry both an abstract schema and 1-2 fully worked verbatim examples restating it.
4. Per-step "Report in the step output: ..." trailer ceremony repeated after nearly every numbered step in multi-stage orchestrator commands.

**Existing audit tooling (for cross-reference, not reuse per operator's fresh-manual-audit choice):** `/audit-claude-md` (127-line command + `claude-md-auditor` subagent, 186 lines) does redundancy/contradiction/staleness/misplacement/clarity judgment on CLAUDE.md specifically. `/token-audit` (220-line command) is a broader 10-section token-efficiency sweep across CLAUDE.md + skills + commands + workflows + sessions. Complementary, not redundant with each other or with this campaign.

---

## 3. Gate register

Full register of every distinct behavioral gate/ceremony, grouped:

- **A — Review/QC layer:** QC Independence (`/qc-pass`), post-edit QC 2nd pass, mechanical-mode QC, plan QC, QC-unreachable fallback (commit-blocking for architectural changes), QC→Triage Auto-Loop (self-firing), Materiality Bar, Refinement Pass/Deep, Triage, Resolve, Decide (mandatory built-in QC), Recommend, Expert-check.
- **B — Drift/Contract/Blindspot/Risk layer:** Contract-Conformance Check, Blind-Spot Scan Gate (self-firing), Assumptions Gate, Drift-Check, Risk-Check (two-gate: plan-time + end-time), Implementation-Triage, Change-Shape Classifier.
- **C — Autonomy/pause gates:** Autonomy Rules 1–10, unconditional-gate precedence, Decision-Point Posture, Model Escalation (partly self-firing), Plan Mode Discipline.
- **D — Session Guardrail flags:** `[HEAVY]`, `[SCOPE]`, `[AMBIGUOUS]`, `[COST]`, friction-log auto-hook (self-firing).
- **E — Session ceremony:** `/prime` orientation, session-marker system, mission binding, auto-mode gates, `/session-plan` self-check, `/wrap-session` preflight bundle (outcome check, feedback collection, foreign-session guard — several self-firing).
- **F — Placement/protected-zone:** Placement Discipline, Placement Verifier, Protected Zones, top-3-commands-affected check, risk-check two-gate model.
- **G — Commit/git discipline:** commit-directly rule, push gating, commit-boundary sequencing, foreign-staging tripwire hook (self-firing).
- **H — Output/communication:** Chat Communication Style, Completion Standard, Requirements-Doc Default, Between-Gate Summaries, File Write Discipline, Subagent Contracts, Session Telemetry, Maintenance Cadence, General Session Rules, Model Tier, Adaptive Thinking.
- **I — Harness-specific (Phase 3, conditional):** Agent Harness hard rules, Blocker Model.

**Stacking chains identified (the core over-build for a high-capability model):**
1. Post-artifact review stack — up to 8 independent gates can fire on one artifact.
2. Plan-time stack — up to 5 independent gates before execution of a single plan begins.
3. Wrap-time stack — multiple independent subagent dispatches converge at one session boundary (mostly legitimate).
4. `/prime auto` mega-stack — nests nearly the whole gate system behind one operator keystroke.
5. Audit-derived-change stack — 3 mandatory-review layers can stack on one Protected-Zone edit.
6. Decision-adjacent stack — up to 4 independent "is this decision safe" checks on one ambiguous point.

**Self-firing gates (no operator invocation needed):** Blind-Spot Scan, QC→Triage Auto-Loop, Session Guardrail flags, friction-log hook, foreign-staging tripwire hook, foreign-session pre-write guard, Between-Gate Summaries, Model Escalation (partial), Placement Verifier (within `/graduate-resource`), session-marker writing, Decision-Point Posture, Autonomy default posture (absence-of-gate).

---

## 4. Target architecture (approved direction, per Plan-agent design + `/scope` decisions)

Four tiers by when-loaded / whether-it-should-guide-execution:
- **Tier 0 — Always-on:** identity, project map, tool ecosystem, chat style, compressed autonomy + decision posture, model-tier prohibition, commit/push canonical, completion standard, subagent-contract. Target: root **231→~120 lines** (directional — completeness wins over the number), `ai-resources/` **78→~48 lines**.
- **Tier 1 — Task playbooks:** commands + skills; gate *mechanics* live here, loaded only when that gate fires.
- **Tier 2 — Reference docs:** read on demand via pointer (`autonomy-rules.md`, `qc-independence.md`, `session-guardrails.md`, `audit-discipline.md`, `protected-zones.md`, `commit-discipline.md`, etc.).
- **Tier 3 — Historical / must-not-guide-execution:** archived, not deleted — currency-checked in §5 below before any move.

Duplication resolution table, gate triage (KEEP-AS-IS / RELAX / CONSOLIDATE), and corpus-leanness approach are carried in the plan file (`/Users/patrik.lindeberg/.claude/plans/make-an-investigation-clarify-vast-robin.md`) and are not re-duplicated here.

---

## 5. Tier-3 currency check — result: no archiving warranted

Full findings: `phase0-tier3-currency-check.md` (companion file, subagent-produced).

**Audit result (pre-operator-correction):** all 10 candidate docs verdict **LIVE** — the subagent found none clearing the "genuinely dormant" bar, inferring status from git history + inbound doc links.

**⚠️ OPERATOR CORRECTION (2026-07-03, authoritative — overrides the audit):** the operator states three of these are old and no longer used:
- `operator-maintenance-cadence.md` — **DEAD**, not LIVE.
- `onboarding-daniel.md` — **DEAD**, not LIVE.
- `onboarding-daniel-cheatsheet.md` — **DEAD**, not LIVE.

These three are **archive/delete candidates** for the deferred session. The other 7 verdicts stand. Lesson for the deferred session: confirm doc-liveness with the operator, not by inferring from git history (the failure mode that produced the wrong verdicts). Nothing was archived or deleted this session — implementation deferred.

**New finding — Finding I (fold into Phase 1's duplication-resolution set, alongside Finding A):**
- **`session-rituals.md` push-gate contradiction.** The doc is structurally load-bearing (`/list-critical-resources` parses its headings) and states "push happens automatically" — a 2026-05-28 edit never reverted after the push rule flipped back to gated/batched on 2026-05-29. This directly contradicts the canonical rule, same defect class as Finding A, just a second surviving copy discovered post-Phase-0. **Canonical fix:** correct this line to match the gated/batched rule when Phase 1 fixes Finding A.

**Lower-priority corrections surfaced (bundle into Phase 1 as small opportunistic fixes, not new phases):**
- `operator-maintenance-cadence.md` — Backlog section 2/3 references ideas already shipped as `/log-sweep` / `/token-audit`; 3 Session-2 steps are missing versus newer sibling docs. Edit, don't archive.
- `onboarding-daniel.md` / `onboarding-daniel-cheatsheet.md` — both reference the deprecated `/save-session` (should be `/handoff`); cheatsheet says "5 risk dimensions" for `/risk-check` (now 6).
- `daniel-concurrent-session-hooks-setup.md` — closes an explicitly open residual (R1) from the 2026-06-11/12 hook migration; cannot confirm completion (Daniel's settings are machine-local) — leave as-is, not archivable.
