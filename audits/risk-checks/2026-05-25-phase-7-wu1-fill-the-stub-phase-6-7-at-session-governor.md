# Risk Check — 2026-05-25

## Change

Phase 7 WU1 — fill the `STUB [PHASE-6/7]:` at session-governor SKILL.md Phase B step 21 with the v1 maturation threshold check. The replacement reads `active_hardenings` count from `mandate.json` (already loaded at Phase A), logs a `judgment_call` event to `session-log.json` with all five schema-required fields (`judgment_type: "maturation_threshold_check"`, `resolution: "no_promotions_v1"`, `unit_id`, `workflow_name`, `rationale`), then continues. No registry write, no promotion. Also updates the governor's Build Status section and Stub Marker Index to reflect Phase 7 completion of step 21.

WU3 batches a roadmap update (`harness/prep/harness-roadmap.md` — mark Phase 7 ✅, advance current-focus preamble to Phase 8, record SHA). WU2 is a live two-session test run by the operator — no code changes in WU2 beyond any DP-3 fix-forward if the live test exposes a pre-existing Phase 2 or Phase 3 bug (notably the mandate-parser `status: "active"` filter divergence already flagged in the plan).

Files in scope: `.claude/skills/session-governor/SKILL.md` (primary), `harness/prep/harness-roadmap.md` (WU3 only). Conditionally `.claude/skills/mandate-parser/SKILL.md` if WU2 surfaces the predicted filter bug.

Plan: `harness/logs/session-plan.md`.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/skills/session-governor/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/skills/mandate-parser/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness/prep/harness-roadmap.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness/logs/session-plan.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness/schemas/session-log-schema.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness/schemas/hardening-registry-schema.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/Project Plans/agent-harness/project-plan-v3.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** WU1 itself is a contained, in-place STUB→prose edit on the governor skill with one new `judgment_type` token added to the session-log event stream; the elevated risk is Hidden Coupling (a new `judgment_type` taxonomy value entering an emergent, reused-across-sessions namespace, plus the documented mandate-parser `status: "active"` filter divergence that WU2 may trip on) and the conditional WU2 fix-forward into a second always-loaded skill.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The governor SKILL.md is always loaded on harness sessions only — the description frontmatter at lines 3–10 binds invocation to "Phase B (the Main Work Loop) of Agent Harness sessions … Load @.claude/references/harness-rules.md before invoking this skill." Not auto-loaded on every workspace session.
- WU1 is a STUB→prose swap at one location (Phase B step 21, currently lines 372–374, two-line stub); the v1 implementation per plan lines 49–63 adds the `judgment_call` description with five fields. Net change is roughly neutral to small positive (estimated <40 tokens added once Build Status bullet at line 36 and Stub Marker Index row at line 731 are updated to mark as filled rather than stubbed). No `@import` chain, no new hook registration, no new auto-load skill.
- The prior Phase 6 plan-time risk check (`ai-resources/audits/risk-checks/2026-05-25-plan-time-risk-check-on-the-phase-6-failure-mode-detector.md` line 138) already flagged "by Phase 8, the governor SKILL.md will deserve a token-audit — the current trajectory accumulates without an explicit ceiling." WU1 is a small marginal addition consistent with that trajectory, not a step-change.
- WU3 edits `harness/prep/harness-roadmap.md` — a prep document, not auto-loaded; zero ongoing token cost.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `.claude/settings.json` or `.claude/settings.local.json` changes named in `CHANGE_DESCRIPTION`.
- No new tool invocation patterns: the new code path reads `mandate.json` (already in must-read tier per governor Phase A1 line 89) and appends a `judgment_call` event to `session-log.json` (already an append-only writer the governor uses throughout Phase B, e.g., line 214 `work_unit_started`, line 318 `qc_finding`).
- No deny rules touched, no scope escalation, no cross-repo writes, no external API calls.

### Dimension 3: Blast Radius
**Risk:** Medium

- **Primary edit site:** `.claude/skills/session-governor/SKILL.md` at three regions (per plan lines 51–62): (a) step 21 body at line 372–374, (b) Build Status "What this skill does NOT do" bullet at line 36, (c) Stub Marker Index row at line 731. Also touches the marker family legend at line 54 (the rescope is already mostly done by Phase 6 per scratchpad line 18; WU1 finalizes the "step 21" reference into past tense). Four discrete edit locations in a single skill, all documented in the plan.
- **Component dependency check (grep across `.claude/`, `harness/`, `ai-resources/`):** session-governor is referenced by 6 components — `.claude/references/harness-rules.md:7`, `.claude/commands/session-report.md:9`, `.claude/skills/mandate-parser/SKILL.md:29`, `.claude/skills/session-reporter/SKILL.md:8`, `.claude/skills/prompt-hardener/SKILL.md:85`, `.claude/skills/failure-mode-detector/SKILL.md:5,22`, `.claude/skills/verification-playbook/SKILL.md:5,21,257`. None of these references depend on step 21's behavior specifically — they cite Phase A/B/D handoff, Phase D triggers, Phase B step 6 (prompt assembly), or Phase B step 11/12 (verification + harden). Step 21 is downstream of all of them and emits a log event none of them consume.
- **Contract surface introduced:** one new `judgment_type` token — `"maturation_threshold_check"`. Per `harness/schemas/session-log-schema.md` line 72, "the `judgment_type` categories are not pre-defined — they emerge from session experience. But they must be reused consistently." This adds one entry to the emergent taxonomy. `resolution: "no_promotions_v1"` is also new but is a free-form string per schema lines 56–68 (no enum).
- **`promotion_candidate_flagged` event type defined but not used.** `harness/schemas/session-log-schema.md` line 41 declares the event type "learning layer maturation trigger" but Phase 7 v1 explicitly does not emit it (plan lines 39–47: "No promotion logic in v1"). The change keeps that schema entry dormant rather than retiring it — small documentation drift the plan accepts, not blocking.
- **WU3 roadmap update** is single-file (`harness/prep/harness-roadmap.md`) — narrowly scoped, no caller dependency.
- **WU2 conditional touch on `mandate-parser/SKILL.md`** — if the live test surfaces the documented `status: "active"` filter divergence (plan lines 67–69; mandate-parser line 128 vs. hardening-registry-schema line 22), the fix-forward edits a second always-loaded harness skill. Plan explicitly names this as a stop point (plan lines 99–100: "any Phase 7 live test bug requiring a fix in Phase 2 or Phase 3 (DP-3 principle — flag to operator before applying fix-forward)"). The divergence is real and pre-existing; WU1 alone does not create it but Phase 7 verification is what surfaces it.

### Dimension 4: Reversibility
**Risk:** Low

- WU1 is a single-file in-place edit to `.claude/skills/session-governor/SKILL.md` — `git revert` cleanly restores the prior STUB text. No sibling files created, no log-file mutations baked into the change itself.
- WU3 is a single-file in-place edit to `harness/prep/harness-roadmap.md` — `git revert` cleanly reverts the Phase 7 row update.
- The new code path will emit `judgment_call` events to `harness/session/session-log.json` at runtime once exercised (an append-only log per schema line 7). If the change is reverted, the appended log entries remain in the log file (append-only by design — schema explicitly says "All components (during session, append-only)"). This is the standard append-only-log reversibility caveat that applies to every governor edit; it does not elevate the risk because (a) the entries are well-formed by design, (b) the schema's `judgment_type` taxonomy is explicitly emergent (schema line 72), and (c) no other component reads or branches on `maturation_threshold_check` — it is a pure record.
- The conditional WU2 fix-forward (if it fires) edits `mandate-parser/SKILL.md` — also single-file, also cleanly revertible. The plan correctly routes this as a separate stop point so it lands as its own commit, preserving revert granularity.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Emergent `judgment_type` taxonomy.** `harness/schemas/session-log-schema.md` lines 70–72 — "categories are not pre-defined — they emerge from session experience. But they must be reused consistently: if 'constraint_conflict_resolution' is used in session 1, the same category name should be used in session 5 for the same class of judgment." This is an implicit cross-session contract: future Phase 7 (or v2 promotion) work that wants to log maturation-related decisions must reuse `maturation_threshold_check` rather than coin a sibling like `maturation_check` or `promotion_assessment`. The contract is documented at the change site (governor SKILL.md note at lines 375–379 already names the five-field schema requirement) but the new token itself is not added to any canonical taxonomy registry — it lives only as a string in step 21's body.
- **Documented pre-existing divergence likely to surface in WU2.** Plan lines 67–69 names this: `mandate-parser/SKILL.md:128` filters `hardening-registry.json` on `status: "active"` — a field that does NOT exist in `harness/schemas/hardening-registry-schema.md` (line 13–26 schema lists `effectiveness` and `session_status`, no `status`). If the live test exposes session N+1 loading zero hardenings, the root cause is this filter, not Phase 7's new step 21. The coupling is between two phase boundaries and was missed during Phase 2 — it does not originate with WU1, but WU2 is the first session where it will be runtime-exercised against non-empty registry data.
- **Dormant `promotion_candidate_flagged` event.** `session-log-schema.md:41` declares the event type but Phase 7 v1 leaves it unused (plan lines 44–47). This is a benign hidden contract: any v2 maturation engine must use exactly this string (it is declared, just not yet emitted). The change does not document this in the governor skill — a future reader may not realize step 21's `judgment_call` is the v1 substitute for the schema-declared `promotion_candidate_flagged` event. Mild coupling, surfaced only at v2 time.
- **`unit_id` ambiguity at step 21 unresolved at plan time.** Plan line 56: "`unit_id: <current active_unit.id>` (or `null` if step 21 runs outside a unit context — confirm during implementation)". Step 21 is reached inside the per-unit loop body (governor SKILL.md line 200 "For each unit:" through step 23 "Next unit or stop"), so `active_unit` is always defined at step 21 — but the plan note suggests the implementer may pick `null`. Picking `null` would diverge from the schema's required-string discipline (schema line 62–64 lists `unit_id` as `"string"`); picking the active unit id would correctly record the per-unit firing. This is a small judgment call hidden inside WU1 that is not unambiguously specified.
- No silent auto-firing — step 21 fires only inside the Phase B unit loop, never outside it.
- No functional overlap with existing mechanisms — step 21 is the only call site for `maturation_threshold_check`; nothing else writes that token.

## Mitigations

- **Hidden coupling (Dimension 5) — judgment_type token consistency.** When implementing WU1, add a one-line cross-reference in the governor's step 21 body or footnote: "Token `maturation_threshold_check` is the v1 substitute for the schema-declared `promotion_candidate_flagged` event (session-log-schema.md line 41); v2 promotion logic should emit `promotion_candidate_flagged` directly and retire this token." This makes the v1↔v2 contract visible to any future reader, satisfying schema line 72's reuse-consistently rule.

- **Hidden coupling (Dimension 5) — `unit_id` field choice.** Resolve the plan's open question (plan line 56) explicitly in the implementation: set `unit_id` to `active_unit.id`. Step 21 runs inside the per-unit loop (governor SKILL.md "For each unit:" at line 200, step 23 closes the loop at line 395), so `active_unit` is always populated at step 21 entry. This matches the schema's `unit_id: "string"` requirement and is the consistent choice with how other in-loop `judgment_call` sites are described (e.g., the schema note at governor SKILL.md lines 375–379).

- **Blast radius (Dimension 3) — pre-commit grep verification.** Before committing WU1, run `grep -n "STUB \[PHASE-6/7\]:" .claude/skills/session-governor/SKILL.md` and confirm: (a) no live STUB at step 21 (current line 372 should now describe v1 behavior), (b) Marker Family Legend (line 54) and Stub Marker Index (line 731) entries describe the marker as **filled** rather than as a deferred stub. This is the verification plan line 63 already lists; mitigation here is to ensure it runs before the WU1 commit, not after.

- **Blast radius (Dimension 3) — WU2 fix-forward gating.** The plan correctly names WU2's pre-existing-bug-fix as a stop point (plan lines 99–100). Mitigation: if WU2 surfaces the `status: "active"` filter divergence, the fix-forward into `mandate-parser/SKILL.md:128` must land as its own commit separate from WU1 and WU3 — preserving revert granularity per Dimension 4. Do not batch the mandate-parser fix into a multi-file commit with the governor change.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.

---

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

# Pre-change advisory — Phase 7 WU1 STUB-fill

## Concur with verdict: yes, with one caveat

**PROCEED-WITH-CAUTION is correct.** The verdict matches the evidence base: blast radius is bounded (one in-place edit to a workspace-local skill, plus a roadmap note), reversibility is clean (`git revert` restores prior STUB text), and the elevated risk lives in two places — an emergent `judgment_type` taxonomy that has no canonical registry, and a documented Phase 2 filter-divergence WU2 may trip on. The risk-check correctly classifies Dimensions 3 and 5 as Medium rather than Low.

**Caveat on governance frame.** The Axcion Claude Code system principles formally describe the harness but do not govern its internals (`system-doc.md` § 1.1 — "harness/ is now described in scope … but remains *governed separately*"). The repo-architecture map confirms `harness/` is a separate concern from the ai-resources canonical library (`repo-architecture.md` § Top-level layout). The risk-check is therefore advisory against principles like DR-8 (`principles.md § DR-8`) but not strictly binding the way it would be for a cross-cutting CLAUDE.md edit. Treat the four mitigations as load-bearing on the harness's own internal contracts, not on workspace governance.

## The four recommended mitigations — assessment

**Mitigation 1 (cross-reference `maturation_threshold_check` → `promotion_candidate_flagged`): adopt.** The schema-line-72 reuse-consistently rule is a soft cross-session contract; without a comment at the call site, the v1↔v2 substitution is invisible to future readers. This is the textbook "loud failure over silent continuation" application at the contract layer (`principles.md § OP-3`). Single-line note at step 21 body; cost negligible, future-clarity high.

**Mitigation 2 (`unit_id: active_unit.id`, not null): adopt — and this is the right call substantively.** Step 21 sits inside the per-unit loop body (governor SKILL.md line 200 onward per the risk-check), so `active_unit` is always defined. Picking `null` would violate the schema's `"string"` requirement on `unit_id` and would silently drop the per-unit attribution. The plan's open question (plan line 56) is the kind of "load-bearing interpretation" the workspace autonomy rules say to resolve explicitly before commit (`principles.md § OP-3`, CLAUDE.md Autonomy Rule 6). The risk-check resolves it correctly — record it in the implementation.

**Mitigation 3 (pre-commit grep `STUB \[PHASE-6/7\]:`): adopt.** This is straightforward verify-before-announcing-complete discipline (`principles.md § QS-3`). The marker-family legend (line 54) and Stub Marker Index (line 731) must also flip — not just the call site at step 21. Three checks, not one.

**Mitigation 4 (WU2 fix-forward as its own commit): adopt — non-negotiable.** Batching the mandate-parser fix into a multi-file commit with the governor change destroys revert granularity. The plan already routes this through DP-3, which is the right structural choice. The risk-check is reinforcing what the plan got right; do not let WU2 momentum collapse this into a single commit.

## One risk the dimension review undersold

**Schema-event taxonomy is not just a soft contract — it is the same shape as a "two-end contract" that `risk-topology.md § Signals that elevate a change to structural risk` calls out by name** ("Change modifies a string literal matched by another component"). Right now nothing else consumes `maturation_threshold_check`, so the consumer end is empty — but Phase 6's `failure-mode-detector` and the verification playbook both emit to `session-log.json` and any future reader, auditor, or v2 promotion engine will scan that log by `judgment_type` value. Once Phase 7 lands and the token is in production logs, **retiring it cleanly later requires a log-migration story** that nobody has written. This is not a Medium-risk concern for WU1 itself; it is a deferred liability the v2 promotion work will inherit.

The right answer is to escalate Mitigation 1 from "footnote" to **canonical taxonomy entry**: write the token into a short taxonomy section of `harness/schemas/session-log-schema.md` (or a sibling `session-log-taxonomy.md`) at the same time WU1 lands, with the cross-reference to `promotion_candidate_flagged` baked in. The schema itself already says (line 72) "they must be reused consistently" — a registry is the mechanism that makes consistent reuse possible. The current state is the taxonomy lives in scattered call sites; one more scattered call site is the path toward a recurring v2 problem (`principles.md § OP-11` — surface tacit conventions before they drift).

This is harness-internal scope (governed separately, per `system-doc.md § 1.1`), so the operator's call — but the dimension review treated it as Medium-Hidden-Coupling when it is closer to "Phase 7 is the right moment to formalize the contract."

## Position

**Concur with PROCEED-WITH-CAUTION. Adopt all four mitigations as written. Escalate Mitigation 1 from inline footnote to a schema-side taxonomy entry in the same commit as WU1** — this closes the deferred v2 liability before it accrues runtime log volume.
