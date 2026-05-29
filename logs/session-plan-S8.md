# Session Plan — S8 — 2026-05-29

## Intent

Apply the structured `/improve-skill` improvement pipeline (or a direct-edit fallback) to `/friday-act` so the three per-item disposition prompts in the "follows" sub-steps auto-triage by default. Defaults: HIGH-risk → `f` (fix-now), MED → `d` (defer), LOW → `s` (skip). After the auto-triage string is computed, the operator sees it and either presses Enter to accept or pastes a corrected string. The change covers all three prompts (Step 3 tactical follow-ups, Step 3.5d SO-derived, Step 3.5f journal-derived) so override mechanics are uniform.

This implements S6 Wave 6 item #16 — operator's explicit directive: *"next time triage the follows AUTOMATICALLY for me!!"*.

## Model

Recommended: **opus** — match.

Why: deciding work. The plan involves designing the predicate semantics (default → disposition mapping), choosing the override UX shape, deciding how the auto-triaged string is recorded in `RESULTS` for Step 5 logging (does it look like an operator paste? does it carry a `triage_source: auto-default` tag?), and editing flow logic in a load-bearing weekly cadence command. Sonnet would handle the mechanical edits fine but would not catch the second-order effects on Step 5 logging or maintenance-observations.md formatting.

## Source Material

- `.claude/commands/friday-act.md` — the command body to modify. Lines 118–149 (Step 3 tactical loop), 152–204 (Step 3.5 SO-derived + journal-derived). The three operator-paste prompts that auto-triage replaces: line 137 (Step 3 disposition string), line 185 (Step 3.5d invokes "items 14–15c logic"), line 203 (Step 3.5f same loop).
- `.claude/commands/improve-skill.md` — the pipeline vehicle. Need to confirm Stage 0 accepts a command-file target vs. SKILL.md only; if it rejects, fall back.
- `skills/ai-resource-builder/SKILL.md` — referenced by `/improve-skill` for skill format and improvement sequence. Read to understand the improvement-pipeline shape before invoking.
- `.claude/agents/friday-act-16a-summarizer.md` — Step 3.5 delegates to this subagent; not modified, but the auto-triage edit must not break its output contract.
- `logs/session-plan-S6.md` (line 57) — S6 Wave 6 item #16 brief; deferral rationale; operator directive verbatim.
- `docs/audit-discipline.md` — `/risk-check` change classes (used in the fallback path).
- `logs/decisions.md` — recent dispositions; reference for the default-predicate rationale (the HIGH→f / MED→d / LOW→s pattern claim).
- `output/context-packs/command-20260529-7b2a4/pack.md` — context engine pack; missing-context items and conflict already triaged at the auto-mode gate.

## Findings / Items to Address

### F1 — Three operator-paste prompts share one disposition vocabulary
All three prompts use `{f,d,s}` and the same length-match-or-reprompt validation pattern. The auto-triage edit must apply uniformly to all three to preserve operator predictability — a half-auto, half-manual shape would be worse than today.

### F2 — Default-predicate rationale is implicit, not codified
Lines 137–139 list the three letters but give no guidance on *when* each is appropriate. The auto-triage default (HIGH→f, MED→d, LOW→s) embeds a judgment that should be visible in the command body itself — both for the operator (so the default is auditable) and for downstream readers (the same vocabulary is referenced in Step 3.5d, 3.5f without re-listing the meanings).

### F3 — Override UX must preserve today's safety net
Today's per-item paste is a hard checkpoint — the operator cannot miss it. Auto-triage with "press Enter to accept" weakens this. The override prompt must (a) show the computed string clearly with the predicate mapping inline, (b) display each item's risk label alongside its assigned letter so the operator can spot a misclassified item, and (c) accept the same `^[fds]+$`-length-matched re-paste path that exists today.

### F4 — RESULTS-structure parity
Step 3 line 146 appends `FIX_NOW_ITEMS` with `source: checkup`; Step 3.5d line 185 with `source: so-derived`; Step 3.5f line 203 with `source: journal-derived`. Adding a `triage_source: {auto-default | operator-override}` field would make Step 5 logging visible — *"this week, 6 of 8 items used the auto-default; 2 overridden"* is a useful observability signal and trivial to thread through. Recommended.

### F5 — Empty/zero-item case
If a prompt has zero items (e.g., no SO-derived items pasted in 16b), the auto-triage step should no-op silently — not display "Auto-triaged: " (empty string) and not prompt for override.

### F6 — Vehicle ambiguity (engine conflict)
`/improve-skill` targets SKILL.md per its frontmatter and Stage 0 validation. `friday-act.md` is a command. Two possible reads:
  - **Vehicle as-named:** operator wants the `/improve-skill` *pipeline structure* applied even if Stage 0 needs a manual override. This requires either patching `/improve-skill` Stage 0 to accept commands (out of scope, larger refactor) or invoking it and accepting the rejection as a no-op.
  - **Vehicle as-shorthand:** operator named `/improve-skill` because it was the natural command name to gesture at "structured command improvement"; the real intent is the *outcome*, not the literal pipeline.

  Tactical resolution: attempt `/improve-skill friday-act` first; if Stage 0 rejects, fall back to direct edit of `friday-act.md` with an inline `/risk-check` before the edit. Both paths produce the same end-state.

## Execution Sequence

### Stage 1 — Read `/improve-skill` Stage 0 to determine vehicle viability (~5 reads)

1. Read `.claude/commands/improve-skill.md` Stage 0 / Stage 1.
2. Determine whether the pipeline can accept `friday-act` (a command target) without modification.
3. Branch: if YES → Stage 2A. If NO → Stage 2B.

### Stage 2A — `/improve-skill friday-act` route (preferred)

1. Invoke `/improve-skill friday-act`.
2. Let the pipeline's internal stages run: brief intake, current-state read, change proposal, internal `/risk-check`, edit application.
3. Pass the F1–F5 findings to the pipeline as the change-proposal input.
4. The pipeline produces an edited `friday-act.md`.
5. Proceed to Stage 3 (QC).

### Stage 2B — Direct-edit fallback (only if Stage 2A blocked)

1. Run `/risk-check` inline with the change description: "modify behavior of /friday-act Step 3 + 3.5 disposition prompts to auto-triage by default with operator override."
2. On RECONSIDER / NO-GO → pause auto mode, surface the verdict, retain the plan on disk per Step 8c.9 rule.
3. On GO → proceed to edit `friday-act.md`:
   - Insert a shared "auto-triage" sub-step before line 142 (the Step 3 wait-for-operator-paste line) that computes the default disposition string from the item list's risk labels, displays it with mapping legend + per-item risk×letter table, and waits for Enter-or-paste.
   - Add a parallel auto-triage sub-step to Step 3.5d (before "items 14–15c logic") and Step 3.5f (before "Feed them into the same disposition loop").
   - Add `triage_source` field to `FIX_NOW_ITEMS` per F4.
   - Document the default predicate (HIGH→f, MED→d, LOW→s) and the override mechanic in a new ## subsection or inline at line 137.
4. Proceed to Stage 3 (QC).

### Stage 3 — `/qc-pass` on edited `friday-act.md`

1. Invoke `/qc-pass` with scope: "auto-triage edit to friday-act.md Step 3 + 3.5".
2. Verdict handling per QC → Triage Auto-Loop rules (workspace CLAUDE.md → qc-independence.md).
3. On GO → Stage 4. On DISAGREE / fixes needed → resolve via `/resolve` then re-QC. Loop cap per workspace rules.

### Stage 4 — Commit

1. Stage `friday-act.md` (plus any peripheral edits the pipeline or fallback produced).
2. Commit message: `update: friday-act — Step 3 + 3.5 auto-triage default with operator override (S6 Wave 6 #16)`.
3. Do not push — push is gated to `/wrap-session`.

### Stage 5 — Update S6 Wave 6 status

1. Append a note to `logs/session-plan-S6.md` near item #16 indicating it was implemented in S8 (preserves traceability for future Friday cadences).

## Scope Alternatives

- **Smaller scope (only Step 3, not 3.5):** Skip the SO-derived + journal-derived prompts. Cuts work by ~40% but breaks F1's uniformity argument — half-auto, half-manual is worse than today's all-manual. Reject unless the pipeline route blocks on bandwidth.
- **Larger scope (also patch `/improve-skill` Stage 0 to accept commands):** Would resolve F6 cleanly but expands scope to a different command and triggers a separate `/risk-check`. Reject — out of scope, but log as a friction-log entry if the fallback fires.
- **Configurable predicates (operator settings.json overrides for HIGH/MED/LOW defaults):** Cleaner long-term but introduces a settings shape that needs design. Defer to a future improvement pass; the inline default is sufficient for now.

## Autonomy Posture

**Full autonomy** if Stage 2A runs (`/improve-skill` internal `/risk-check` covers the structural-change check per S6 brief).

**Gated** if Stage 2B fires — the inline `/risk-check` at Stage 2B.1 is an explicit checkpoint. Auto mode pauses on RECONSIDER/NO-GO; operator decides whether to revise the change or abort.

Either way, the `/qc-pass` at Stage 3 is a normal autonomy-rule pause (DISAGREE verdict requires operator review per workspace Autonomy Rules #4).

## Risk

- **Behavior change in a cadence command (medium).** `/friday-act` runs weekly. A subtle bug in the auto-triage string computation could mis-disposition an item the operator would have caught with the manual paste. Mitigation: F3's display-the-string-with-per-item-risk-table makes mis-classification immediately visible; F5's empty-case handling avoids silent no-ops; QC pass catches edit-level errors.
- **Operator habituation (low).** "Press Enter to accept" defaults invite habit. Mitigation: the per-item risk×letter table forces eyes-on-screen review before accepting. Not eliminated, just reduced.
- **Override-string validation drift (low).** The override path must reuse today's exact `^[fds]+$`-length-matched validation; otherwise it diverges from the producer-side contract Step 3.5 line 154 documents. Mitigation: explicit reuse, not re-implementation, in the edit.
- **Vehicle-rejection cost (low).** If Stage 2A fails fast, Stage 2B adds one inline `/risk-check` call but is otherwise the same edit. Wasted reads bounded to `/improve-skill` Stage 0 (~50 lines).
- **Cross-resource interaction (low).** `friday-act-16a-summarizer` agent output feeds Step 3.5d; the auto-triage edit must not change the summary's consumed shape. Mitigation: the edit changes what happens *after* the summary is displayed, not the summary itself.
