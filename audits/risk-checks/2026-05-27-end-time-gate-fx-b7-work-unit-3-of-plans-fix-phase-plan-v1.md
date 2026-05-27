# Risk Check — 2026-05-27

## Change

END-TIME GATE — FX-B7 (Work Unit 3 of plans/fix-phase-plan-v1.md). Re-evaluating the same change after mitigations + system-owner additions applied. Original plan-time verdict: PROCEED-WITH-CAUTION (Blast radius High, Hidden coupling High, Usage cost Medium). All 4 mitigations + 3 system-owner additions applied during execution.

CHANGE AS EXECUTED:
1. Added `## Project Config` schema block (12 fields) to `ai-resources/workflows/research-workflow/CLAUDE.md` between `## Operator Profile` (line 15) and `## Confidentiality Boundaries` (line 40). CLAUDE.md grew 131 → 152 lines. The schema block opens with a load-bearing forward-contract disclaimer (system-owner addition 1) visible on every always-loaded session.
2. Created new `docs/` directory in canonical workflow + wrote `docs/project-config-schema.md` (113 lines on disk) containing: forward-contract disclaimer + rollback rule; single-source-of-truth rule for `Country set`; canonical parse format with reference regex; 12 fields documented with per-consumer "Reads" sub-bullets; consumer fan-out summary table; field naming conventions; GR-2 migration triggers.
3. Appended GR-2-default-anchor decision entry to project `logs/decisions.md` (lines 497–519) with DR-7 sequencing justification, rollback rule, GR-2 migration triggers, and FX-B1 contract-inheritance rule.
4. Updated project `plans/fix-phase-plan-v1.md` Work Unit 4 with two new bold paragraphs: FX-B1 contract-inheritance rule (per-parser-batch /risk-check) and FX-B7 rollback dependency.
5. Appended improvement-log entry flagging risk-topology.md workflow-template CLAUDE.md row gap (Friday cadence follow-on).

No consumer parsers were added — schema is a forward contract as planned.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/docs/project-config-schema.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/decisions.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/plans/fix-phase-plan-v1.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/risk-checks/2026-05-27-add-project-config-schema-block-12-declarative-fields-per.md — exists (plan-time report)

## Verdict

GO

**Summary:** All four plan-time mitigations and three system-owner additions are verifiably present on the landed artifacts. Blast radius drops from High to Low (no consumer touched; forward-contract disclaimer at always-loaded surface; per-consumer fan-out documented); Hidden coupling drops from High to Low (single-source-of-truth rule landed for `Country set`; one canonical parse format documented with reference regex). Reversibility stays Low; Permissions stays Low; Usage cost stays Medium (the always-loaded disclaimer adds ~80 tokens on top of the original ~150-token schema block, but the cost is bounded to one active deployment and FX-B7 has an explicit rollback rule).

## Mitigation + Addition verification

Verified directly on the landed artifacts before re-rating dimensions:

| Item | Landed? | Evidence |
|---|---|---|
| **Mitigation 1** — defer wiring 6 consumers to FX-B1+ | ✅ | `grep -rn "Project Config\|project-config" ai-resources/.claude/commands/ ai-resources/skills/` returns zero hits; `git status` in ai-resources shows no modifications to `produce-*.md` or the 4 named skill SKILL.md files; only the two FX-B7 artifacts changed. |
| **Mitigation 2** — per-consumer field-fan-out | ✅ | `docs/project-config-schema.md` lines 43–56 — field table includes "Reads (future consumers)" column with per-field consumer sub-bullets. Lines 60–79 — consumer fan-out summary table (per-consumer-by-field view). Line 81 — "if you edit one, edit the other" coherence rule. |
| **Mitigation 3** — single source of truth for `Country set` | ✅ | `docs/project-config-schema.md` lines 11–20 — explicit "Single source of truth — `Country set`" section. Declares CLAUDE.md canonical, `reference/source-class-hierarchy.md § Project Country Set` derived mirror. Reinforced inline in field-3 row at line 47 ("**Canonical** — `reference/source-class-hierarchy.md § Project Country Set` is the derived mirror"). |
| **Mitigation 4** — canonical parse format | ✅ | `docs/project-config-schema.md` lines 24–37 — "Canonical parse format" section. Lines 31–33 — Python-style reference regex `^\*\*(?P<label>[A-Z][A-Za-z- ]+):\*\*\s+(?P<value>.+?)(?:\s+#\s+(?P<comment>.+))?$`. Line 35 — single-section assumption documented. Line 37 — "one canonical pattern reduces 6 implicit dependencies to 1 explicit one" rationale. |
| **Addition 1** — forward-contract disclaimer at TOP of CLAUDE.md block | ✅ | `ai-resources/workflows/research-workflow/CLAUDE.md` line 21 — disclaimer is the first line under `## Project Config`, ahead of the schema block itself. Quote: "Forward contract — no live consumer reads this block yet (as of canonical landing 2026-05-27)." Always-loaded surface, not buried in load-on-demand doc. |
| **Addition 2** — DR-7 sequencing justification + rollback rule in decisions.md | ✅ | `projects/nordic-pe-macro-landscape-H1-2026/logs/decisions.md` line 497 — entry "2026-05-27 — FX-B7 GR-2-default-anchor: Project Config schema lives in canonical CLAUDE.md (forward contract)". Line 503 — "Rationale (DR-7 sequencing justification — load-bearing)" paragraph naming FX-B1 as first consumer-builder. Line 505 — "Rollback rule" paragraph (1–2 session delay acceptable; 4+ session delay or fix-phase abandonment triggers revert review). |
| **Addition 3** — FX-B1 inherits-contract + per-parser-batch /risk-check in fix-phase-plan-v1.md Work Unit 4 | ✅ | `plans/fix-phase-plan-v1.md` line 139 — "FX-B1 contract-inheritance rule (added 2026-05-27 per FX-B7 GR-2-anchor decision)" bold paragraph. Names the 4 parser batches (Stage 5 commands × 3; Stage-2 skills × 3; country-parity-checker; Bundle-2 reference docs); requires plan-time `/risk-check` per batch. Line 141 — "FX-B7 rollback dependency" paragraph reinforces the rollback trigger. |

All seven items present on disk.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- Plan-time rating was Medium (~150-200 tokens added to always-loaded surface). End-time CLAUDE.md is 152 lines vs. pre-change 131 lines (`wc -l`), so the actual delta is 21 lines / ~250 tokens — slightly above plan-time estimate because the forward-contract disclaimer (Addition 1) added ~80 tokens on top of the schema block itself. Stays in Medium band.
- The disclaimer at line 21 is the cost driver for Addition 1 specifically. It's the right architectural choice (always-loaded surface > load-on-demand for "no consumer reads this yet" signal), but it does carry per-session token cost on every research-workflow deployment.
- `docs/project-config-schema.md` (113 lines on disk) is load-on-demand only — no always-loaded cost. Confirmed by checking it's not imported from CLAUDE.md (CLAUDE.md line 38 references it as "For full field documentation… read `docs/project-config-schema.md`" — pointer, not import).
- Cost is bounded: only one active research-workflow deployment today (nordic-pe-macro-landscape-H1-2026). The buy-side-service-plan deployment is frozen at pre-Bundle-1 shape per `decisions.md` 2026-05-26 entry and does not receive canonical updates.
- Bounded by rollback rule (Addition 2): if FX-B1 doesn't land within fix-phase window, schema reverts → token cost drops to zero. The cost is not committed indefinitely.

### Dimension 2: Permissions Surface
**Risk:** Low

- No edits to any `.claude/settings.json` or `.claude/settings.local.json`. Confirmed by `git status` — no `settings*.json` files in the changed set.
- No `allow` / `ask` / `deny` rule additions, removals, or scope changes.
- No new tool families introduced. The change is markdown content (CLAUDE.md edit + new docs file) + a new directory (`docs/`). No executable surface.
- Matches plan-time Low rating; no change.

### Dimension 3: Blast Radius
**Risk:** Low (dropped from High at plan-time)

- Direct file touches: 2 in ai-resources (`workflows/research-workflow/CLAUDE.md` modified; `workflows/research-workflow/docs/project-config-schema.md` created) + 3 in project (`logs/decisions.md`, `plans/fix-phase-plan-v1.md`, `logs/improvement-log.md`). All five verified via per-file Read.
- Mitigation 1 verified: `grep -rn "Project Config\|project-config" ai-resources/.claude/commands/ ai-resources/skills/` returns zero hits. No consumer parser exists; no command or skill was modified to read the schema. `git status` confirms only the two FX-B7 artifacts changed in ai-resources (plus session-notes.md, an unrelated narrative log).
- Mitigation 2 verified: `docs/project-config-schema.md` lines 43–56 (field table with "Reads" column) and lines 60–79 (consumer fan-out summary table) provide per-field and per-consumer fan-out views. Future parser authors can locate the field-to-consumer dependency in one place, not by re-deriving from prose.
- Forward-contract status (Addition 1) at CLAUDE.md line 21 explicitly tells every session "no automated reader sees it unless you've separately verified a consumer parser exists." This is the right always-loaded signal: a future contributor cannot accidentally assume consumers exist.
- The 6-consumer-fan-out concern that drove plan-time High is bounded by Addition 3 (per-parser-batch `/risk-check` gate before FX-B1 consumer wiring). The wiring-time risk is not eliminated, but it is gated — each batch gets its own plan-time check, not one rolled-up end-time gate. Plan-time rating accounted for the wiring risk as part of FX-B7's blast radius; end-time correctly reassigns that risk to FX-B1, where the per-batch gate enforces it.
- Single-consumer-template trap (plan-time concern) is structurally unchanged but bounded by rollback rule: if FX-B1 doesn't land, the schema reverts. The trap requires an idle schema; the rollback prevents indefinite idle state.

### Dimension 4: Reversibility
**Risk:** Low

- Two artifacts written: an edit (`git revert` cleanly restores prior CLAUDE.md) and a new directory + file (`git rm -r docs/` reverses cleanly post-commit). Plus three project-side log + plan edits that revert cleanly via `git revert`.
- No state propagated beyond the local repo: no `git push`, no external write, no hook registration, no symlink, no automation. Verified by checking `git status` — pre-commit working-tree state only.
- The GR-2-default-anchor decision entry in `logs/decisions.md` is an append-only log entry — `git revert` cleanly removes the lines without orphan references.
- Rollback rule (Addition 2) provides explicit revert criteria — if FX-B1 doesn't land in the plan window, the schema reverts. Operator knows the exact trigger, not a vague "we'll see."
- One residual concern: any caller authored after this change that reads `## Project Config` must also be rolled back. Mitigation 1 prevents this at landing time (no caller exists yet); Addition 3 ensures FX-B1's per-parser-batch gates make future callers visible to the same audit trail. Stays Low.
- Plan-time was Low; end-time stays Low.

### Dimension 5: Hidden Coupling
**Risk:** Low (dropped from High at plan-time)

- Plan-time High was driven by: (a) undocumented contract for 6 future parsers, (b) silent drift risk between `Country set` in CLAUDE.md and `reference/source-class-hierarchy.md § Project Country Set`, (c) no canonical parse format. All three are addressed.
- Mitigation 3 verified: `docs/project-config-schema.md` lines 11–20 declare CLAUDE.md canonical, source-class-hierarchy mirror, same-commit-update rule, and divergence-is-defect rule. Reinforced in field-3 row at line 47. The two-encoding silent-drift risk is now documented as a contract, not a happy-path assumption.
- Mitigation 4 verified: lines 24–37 document one parse pattern (regex at lines 31–33). Future parser authors who diverge from this pattern create silent contract drift — but they would be visibly diverging from a documented rule, not making an independent reasonable choice. This converts the 6-implicit-dependency surface to a 1-explicit-dependency surface.
- Addition 1 (forward-contract disclaimer at always-loaded surface) prevents the most likely coupling failure: a future contributor reading CLAUDE.md and assuming consumers exist because the schema is there. The disclaimer at line 21 says explicitly "zero of those consumers parse the block."
- Addition 3 (per-parser-batch `/risk-check`) prevents the second-most-likely coupling failure: FX-B1 landing 6 parsers in one rollup gate that misses cross-parser coupling between batches. Each batch gets its own plan-time evaluation.
- No silent auto-firing in unexpected contexts (no hook registered, no skill auto-trigger). No functional overlap with existing mechanisms beyond `Country set`, which is explicitly resolved.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references on the landed artifacts (CLAUDE.md line 21 forward-contract disclaimer; schema doc lines 11–20, 24–37, 43–56, 60–79; decisions.md lines 497–519; fix-phase-plan-v1.md lines 139–141; improvement-log.md lines 159–169); `wc -l` confirming CLAUDE.md grew 131 → 152 lines; `git status` confirming only the two FX-B7 artifacts changed in ai-resources; `grep -rn "Project Config\|project-config"` confirming zero consumer-parser hits across `.claude/commands/` and `skills/`. Each of the four mitigations and three additions verified individually on disk before being marked landed. No training-data fallback was used on fetch/read failures.
