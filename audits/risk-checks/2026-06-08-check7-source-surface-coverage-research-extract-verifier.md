# Risk Check — 2026-06-08

## Change

Proposed change: Add a new "Check 7 — Source-Surface Coverage" to the research-extract-verifier skill (SKILL.md), which is a canonical skill symlinked from ai-resources/skills/research-extract-verifier into this project at reference/skills/. Editing it writes to canonical and affects all research projects consuming the skill.

What Check 7 does: It fires ONLY when an extract is about to receive a scarcity verdict — i.e., when Check 4 (Coverage Verdict) returns THIN or MISSING, OR Check 6 (Stop Condition) returns EVIDENCE-CEILING-REACHED (closing condition 3 or 4). For those cases only, it cross-references the report's Source Log against the Named-Source Appendix + source-exhaustion ladders in reference/source-class-hierarchy.md: for the evidence need behind that component, were the expected top-of-ladder named public surfaces actually searched? If a top-of-ladder surface was NOT searched, the scarcity verdict is treated as possible FALSE scarcity → FLAG, routing back to Step 2.2/2.3 for a targeted supplementary pass rather than accepting scarcity. If all expected surfaces were searched and nothing was found, scarcity is confirmed (accept, no flag). Adds one new FLAG trigger to Verdict Logic and a small output field. Does NOT run on COVERED extracts (cost containment).

Purpose: closes a false-scarcity failure mode (THIN/Gated asserted when the real cause was an unsearched surface) — directly relevant to the paywall-heavy dispersion/fee questions. Fix-spec #2 (audits/2026-06-08-workflow-v2-fix-spec.md §3.1).

Blast radius: all projects that consume research-extract-verifier from canonical ai-resources. Reuses existing machinery (Source Log, Named-Source Appendix, the existing FLAG→Step 2.2/2.3 routing already used by Check 6's INCOMPLETE-RESEARCH path). Net-new: one conditional check + one FLAG trigger, gated to only fire on scarcity verdicts.

Edit mechanism: direct Edit to SKILL.md (operator's session recipe), followed by independent /qc-pass before commit.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/research-extract-verifier/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap/reference/source-class-hierarchy.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap/audits/2026-06-08-workflow-v2-fix-spec.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A well-scoped, cost-contained additive check that reuses existing machinery and serves OP-12 (closure), but it makes a *canonical* skill depend at runtime on a *project-fill* reference structure (Named-Source Appendix + named ladders) that is absent or differently-shaped in at least one live consuming project (buy-side-service-plan has no source-class-hierarchy.md at all) — a real hidden-coupling / blast-radius risk that must be mitigated with a graceful-degradation guard before landing.

## Consumer Inventory

Search terms: `research-extract-verifier`, `extract-verification`, `Step 2.4`, `EVIDENCE-CEILING-REACHED` (Check 6 → Check 7 contract marker), `Named-Source Appendix` / `Source-Exhaustion Ladder` (the reference structure Check 7 reads at runtime). Logs, archives, audits, repo-snapshots, and pipeline/diagnostic artifacts excluded as non-live (they record the skill name, they do not invoke or parse its contract). Rows below are live consumers only.

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/workflows/research-workflow/.claude/commands/run-execution.md (Step 2.4, line 116–124) — canonical command that reads the skill and extracts "its verification checks and verdict logic" | invokes | no |
| ai-resources/.../research-pe-regime-shift-advisory-gap/.claude/commands/run-execution.md (project copy of the Step 2.4 invoker) | invokes | no |
| ai-resources/.../buy-side-service-plan/.claude/commands/run-execution.md (live consuming project, Step 2.4) | invokes | no |
| (archived) archive/nordic-pe-macro-landscape-H1-2026/.claude/commands/run-execution.md | invokes | no (archived) |
| projects/research-pe-regime-shift-advisory-gap/reference/source-class-hierarchy.md (the Named-Source Appendix + ladders Check 7 reads at runtime) | imports | no (this project — present and well-formed) |
| ai-resources/workflows/research-workflow/reference/source-class-hierarchy.template.md (canonical template; ladders are `{{LADDER_NAME}}` placeholders + "Project fills" — Named-Source Appendix present as a section) | imports | yes-if-propagated (template carries placeholder ladders, not concrete named surfaces) |
| buy-side-service-plan/reference/ (NO source-class-hierarchy.md exists — `find` returned nothing) | imports | yes (missing runtime dependency for Check 7 in a live consumer) |
| ai-resources/workflows/research-workflow/reference/quality-standards.md (defines EVIDENCE-CEILING-REACHED + Research Stop Conditions that Check 6 emits and Check 7 keys off) | parses | no |
| ai-resources/skills/research-extract-creator/SKILL.md (Step 2.3 — receives the FLAG→re-extract / supplementary routing Check 7 reuses) | co-edits | no (routing already exists for Check 6's INCOMPLETE-RESEARCH path) |
| research-pe-regime-shift-advisory-gap/execution/extract-verification/1.1/*.md (existing extract-verification outputs in `extract-verification-{letter}.md` format) | parses | no (new output field is additive; existing reports not re-validated) |

**Total: 10 distinct live consumers, 2 must-change** (buy-side-service-plan's missing source-class-hierarchy.md; and the canonical template if the structure is propagated). The skill SKILL.md being edited is the change target, not a consumer. The runtime reference dependency (`source-class-hierarchy.md` Named-Source Appendix + ladders) is the load-bearing coupling: present in this project, absent in buy-side-service-plan, placeholder-only in the canonical template.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Pay-as-used: the skill is invoked only at Step 2.4, on operator demand, once per research session (2–4 questions) — not always-loaded, not a per-tool-call hook, not an `@import` in any CLAUDE.md. Evidence: SKILL.md lines 10–14 ("Step 2.4 in Stage 2. Use when Patrik provides a raw Deep Research report…").
- No content added to workspace or project CLAUDE.md; no SessionStart/Stop/PreToolUse hook registered by this change.
- Check 7 is gated to fire only on THIN/MISSING (Check 4) or EVIDENCE-CEILING-REACHED (Check 6) extracts — COVERED extracts skip it (CHANGE_DESCRIPTION: "Does NOT run on COVERED extracts (cost containment)"). The added in-context reasoning is a small conditional plus one output field — well under the ~50-token always-loaded threshold and not always-loaded at all.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow`/`ask`/`deny` change. The skill already reads project reference docs and writes a verification report to the working directory (SKILL.md "Output Protocol", line 206–208); Check 7 reads `reference/source-class-hierarchy.md`, which the same workflow already reads at Step 2.0b / via `research-prompt-creator` (run-execution.md line 41). No new tool family, no new Write path, no external API, no scope escalation.

### Dimension 3: Blast Radius
**Risk:** Medium

- Grounded in the Step 1.5 inventory: 10 live consumers, 2 must-change. The skill is consumed by the canonical workflow command and ≥2 live project copies (this project + buy-side-service-plan) plus the archived nordic project — editing canonical reaches all of them (CHANGE_DESCRIPTION: "Editing it writes to canonical and affects all research projects consuming the skill").
- Contract change is backwards-compatible at the *output* level: Check 7 adds one FLAG trigger and one output field. Existing `extract-verification-{letter}.md` consumers (`parses` row) tolerate an added field; no caller must re-parse a changed schema. The new FLAG reuses the existing FLAG→Step 2.2/2.3 routing already used by Check 6's INCOMPLETE-RESEARCH path (SKILL.md line 149) — no new routing contract.
- The must-change consumers are the *runtime reference dependency*, not the callers: buy-side-service-plan invokes the verifier at Step 2.4 but has no `source-class-hierarchy.md` (find returned nothing), and the canonical template carries placeholder ladders. The inventory surfaced this gap, which CHANGE_DESCRIPTION did not anticipate ("Reuses existing machinery (… Named-Source Appendix …)" assumes the appendix exists everywhere). That gap is the blast-radius finding — see Dimension 5 for the coupling mechanism. Scored Medium not High because the new check is gated (fires only on scarcity verdicts) and degrades to a no-op rather than a hard error if the reference is absent *provided a guard is added* (see Mitigations).

### Dimension 4: Reversibility
**Risk:** Low

- Single-file edit to one SKILL.md. `git revert` of the commit fully restores prior behavior; no sibling files, no data/log mutation, no settings.json change, no state pushed beyond the repo.
- The only residue would be any `extract-verification-{letter}.md` reports produced while Check 7 was live (they would contain the extra field and possibly extra FLAGs) — but those are session outputs in project working dirs, not state the skill carries forward; a revert leaves them as harmless historical artifacts, not stale contract entries. No automation fires between landing and revert (no hook registered).

### Dimension 5: Hidden Coupling
**Risk:** High

- **Canonical skill → project-fill reference structure.** Check 7 hard-depends at runtime on two structures inside `reference/source-class-hierarchy.md`: the **Named-Source Appendix** and the **named source-exhaustion ladders** with "top-of-ladder" surfaces (CHANGE_DESCRIPTION: "cross-references the report's Source Log against the Named-Source Appendix + source-exhaustion ladders"). In this project both exist and are concrete (source-class-hierarchy.md lines 33–119: four named ladders + a Named-Source Appendix). But the **canonical template** (`workflows/research-workflow/reference/source-class-hierarchy.template.md`) carries the ladders as `{{LADDER_NAME}}` / `{{LADDER_STEP_N}}` placeholders under a "Project fills" instruction (template lines 32–39) — so the structure Check 7 keys off is *project-fill content, not a canonical guarantee*. A canonical check cannot assume project-fill content has a specific shape in every consuming project.
- **Confirmed-absent in a live consumer.** buy-side-service-plan consumes the verifier at Step 2.4 (its run-execution.md is an inventory row) but has **no `source-class-hierarchy.md` at all** (`find ../projects/buy-side-service-plan -iname "*source-class*"` returned nothing; its reference/ dir lists file-conventions, quality-standards, stage-instructions, etc. — no source-class file). In that project Check 7 would attempt to read a non-existent file or appendix on every scarcity verdict. Without an explicit guard, behavior is undefined: best case a silent skip, worst case a hard failure or an invented appendix (a QS-4 / AP-2 training-data-fill risk — the verifier inferring "expected surfaces" it cannot read).
- **Implicit cross-check dependency on ladder naming.** Check 7 must map an evidence need → the correct named ladder → its top-of-ladder surface. That mapping convention is not documented in SKILL.md and lives only in each project's source-class-hierarchy.md, whose ladder names and ordering differ per project (this project's ladders: Returns/Dispersion, Regulation/Political, Capability/Hiring, General-Claim). A canonical check silently relying on a project-specific naming/ordering convention is the hidden-coupling pattern.
- This is multiple implicit dependencies on project-fill conventions that are absent in at least one live consumer and undocumented at the change site → High.

### Dimension 6: Principle Alignment
**Risk:** Low

- **OP-12 (closure before detection) — served, not violated.** Check 7 is new *detection* (it detects false-scarcity), but it ships *with* a working closure channel: the existing FLAG → Step 2.2/2.3 supplementary-pass routing (SKILL.md line 149, reused per CHANGE_DESCRIPTION). Detection behind a working closure channel is exactly what OP-12 licenses. Counts *for* the change.
- **OP-9 / DR-7 / AP-7 (speculative abstraction) — not triggered.** The check has a confirmed present consumer and a confirmed live failure mode (fix-spec §3.1: "Thin/Gated asserted when the real cause was an unsearched surface," named as exposure on the paywall-heavy dispersion/fee questions). It is not built for an absent Phase-2 consumer; it reuses existing machinery rather than generalizing ahead of need.
- **OP-5 (advisory vs enforcement) — stays advisory.** The verifier "verifies — it does not fix" (SKILL.md line 28); Check 7 adds a FLAG that *routes*, it does not auto-correct or auto-search. No silent advisory→enforcement upgrade.
- **DR-8 — honored.** The change is being run through `/risk-check` at plan-time as required for skill-logic changes; the fix-spec tags it RISK-CHECK: yes (fix-spec line 55).
- **DR-2 / AI-resource-creation discipline — watch item, not a violation.** CHANGE_DESCRIPTION states "direct Edit to SKILL.md," whereas workspace CLAUDE.md and the fix-spec's own landing discipline (fix-spec line 28: "skill methodology edits follow ai-resource-creation.md (use /improve-skill, don't hand-hack)") prefer routing canonical skill edits through `/improve-skill`. This is a process-path note, not a principle misalignment of the change's substance; flagged for the operator, does not raise the dimension.
- principles-base.md was readable; IDs cited from it directly.

## Mitigations

- **Dimension 5 (High) — graceful-degradation guard (required before landing).** Add an explicit precondition at the top of Check 7: if `reference/source-class-hierarchy.md` is absent, OR it has no Named-Source Appendix, OR the evidence need maps to no named ladder, then Check 7 **does not run** and records `Source-surface coverage: not-checked (no source-class ladder available)` in the output — never invents expected surfaces (guards QS-4 / AP-2). This converts the buy-side-service-plan absent-file case and any future bare-project case from undefined behavior into a documented no-op, reducing the coupling from High to Low. State this fallback in SKILL.md itself so the contract is documented at the change site (closes the "undocumented convention" sub-finding).
- **Dimension 5 (High) — document the ladder-mapping contract.** In SKILL.md, state how Check 7 maps an evidence need to a named ladder and what "top-of-ladder surface" means, so the check does not silently depend on each project's ladder naming/ordering. Where the mapping is ambiguous, the check marks the surface `unverifiable` rather than asserting it was unsearched (mirrors the existing Check 2/Check 3 "unverifiable" pattern, SKILL.md lines 87, 214).
- **Dimension 3 (Medium) — propagate the structure to the canonical template, or scope the check.** Either (a) fill the canonical `source-class-hierarchy.template.md` with a concrete Named-Source Appendix + at least one worked ladder so future deployed projects inherit the structure Check 7 needs, or (b) explicitly note in SKILL.md that Check 7 is a no-op in projects whose source-class-hierarchy.md lacks named ladders. Pairs with the guard above.
- **Process (advisory) — route via `/improve-skill`.** Per fix-spec §1 landing discipline and workspace CLAUDE.md AI-resource-creation rule, land the SKILL.md edit through `/improve-skill` rather than a raw hand-edit, then `/qc-pass` (independent context) before commit. Not a risk mitigation per se, but the canonical path that carries the QC gates.

## Recommended redesign

(Omitted — verdict is PROCEED-WITH-CAUTION, not RECONSIDER. The High on Dimension 5 has a viable paired mitigation, the graceful-degradation guard, that reduces it to Low.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence: SKILL.md line references (10–14, 28, 149, 206–208); source-class-hierarchy.md lines 33–119 (named ladders + appendix); canonical template lines 32–39 (placeholder ladders); `find` returning no source-class file in buy-side-service-plan; run-execution.md lines 41, 116–124 (Step 2.4 invocation); fix-spec lines 28, 49–55; principles-base.md IDs (OP-12, OP-9, DR-7, AP-7, OP-5, DR-8, DR-2). No training-data fallback was used on any read.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

**Full advisory on disk:** projects/axcion-ai-system-owner/output/consultations/consult-2026-06-08-risk-check-second-opinion-check-7-source-surface.md

**Concur with PROCEED-WITH-CAUTION; graceful-degradation guard is the right primary mitigation** — but the dimension review's central premise is partly wrong on the facts, which shrinks the flagged risk.

**Not a new coupling class — it already exists in this same skill.** Canonical `research-extract-verifier` already reads project-local `reference/source-class-hierarchy.md` at runtime today: Check 6 (Stop Condition Verification) cites it directly (SKILL.md lines 118, 131) and feeds the same FLAG → Step 2.2/2.3 route Check 7 reuses. Check 7 deepens an existing coupling; it does not introduce a novel one. Size the work as "harden an existing coupling," not "contain a new dependency."

**The one genuine escalation Check 7 adds:** Check 6 reads ladder *classes* loosely; Check 7 reads appendix *contents* (specific named surfaces) and flips a scarcity verdict on their absence — the first literal coupling to the appendix's exact shape. The guard must cover divergent-shape, not only absence.

**Risks the dimension review missed / mis-sized:**
1. Blast radius likely **over**-stated — the named worst-case consumer (buy-side-service-plan) does not appear to run this skill's pipeline at all; a non-consumer is not blast radius. [CITATION NEEDED — confirm before relying.]
2. Mitigation 3 partly already done — the canonical template **already** carries the ladder + appendix structure (template lines 28–72). The real gap: the template never declares that a *verifier check* reads the appendix, so a project filler doesn't know the appendix shape is now a two-end contract.
3. Under-named structural risk: **drift on a two-end string contract** — once Check 7 reads named appendix headings, a renamed heading silently degrades it. Match on evidence-need / ladder *rows*, not free-text headings, so divergence degrades to "unverifiable" rather than mis-firing.

**Mitigation 4 is non-optional, not advisory:** canonical skill edit is DR-2 + DR-8 gated (`/risk-check` then independent `/qc-pass`); route via `/improve-skill`, do not hand-edit.

**Right answer:** land Check 7 with the hardened guard in the same `/improve-skill` edit (mark unmappable surfaces "unverifiable", record "not-checked" on absence, never invent surfaces, match on rows not headings); document the appendix-is-read-by-a-verifier contract in both template and SKILL.md; skip re-propagating structure that already exists.
