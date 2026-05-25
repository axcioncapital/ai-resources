# Session Plan — 2026-05-25

## Intent
Verify and complete partial R1 — add fallback-passthrough rule to existing `friday-act-16a-summarizer.md` agent and update stale Notes lines 418–419 in `friday-act.md` — done when: agent has explicit verbatim-passthrough instruction on both fallback paths; `friday-act.md` Notes lines 418–419 updated to reflect subagent delegation; two-cycle paste-decision validation completed; both file edits committed.

## Class
execution

## Model
sonnet — match (claude-sonnet-4-6[1m] active)

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/friday-act-16a-summarizer.md` — the agent file to edit (fallback-note lines 29, 34)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-act.md` — command file (Notes lines 418–419 to update)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/risk-checks/2026-05-25-plan-time-risk-check-on-token-audit-r1-fix-to-friday-act-step-16a.md` — approved design spec + Architectural Commentary (3 mitigations + system-owner refinements)

## Findings / Items to Address

R1 is partially shipped. Two gaps remain before it can be considered complete:

1. **Mitigation 3 — verbatim fallback-passthrough rule missing from agent** (`friday-act-16a-summarizer.md` lines 29, 34). Current text: "capture the first 30 lines with a fallback note." Required addition (per risk-check Architectural Commentary § Mitigations — third mitigation): agent must explicitly instruct that when section-match fails, the fallback note is returned verbatim — no paraphrase, no inference about what the missing section probably contained. Source: risk-check report line 120–121.

2. **Notes lines 418–419 in `friday-act.md` still describe pre-subagent inline-read cost** ("50–200 lines … 100–400 lines per scoped project … ~500–1500 lines"). These lines were written before Step 16a was delegated to the subagent; the figures are now stale and misleading. Source: risk-check report line 55–59 ("Two callers in the Notes section … should be updated to reflect the delegation").

3. **Two-cycle paste-decision validation** (pre-landing operator check, not a file edit). Per Architectural Commentary line 127: compare paste-decisions against two prior friday-checkup cycles (2026-05-22 + one earlier) to confirm the subagent summary preserves the same signal the old inline display provided. Source: risk-check Architectural Commentary § Recommended actions item 4.

## Execution Sequence

1. **Edit `friday-act-16a-summarizer.md`** — at each fallback-note instruction (lines 29, 34), append the verbatim-passthrough rule: "Return this fallback note verbatim in the summary — do not paraphrase it, do not infer what the missing section probably contained."
   - Verification: re-read both lines to confirm the instruction is present and unambiguous.

2. **Edit `friday-act.md` Notes lines 418–419** — replace the pre-subagent inline-read cost description with a delegation-aware note: Step 16a now delegates reads to `friday-act-16a-summarizer`; per-session context cost is bounded by the subagent's ≤30-line summary cap rather than the raw section content.
   - Verification: re-read the Notes block to confirm the stale figures are gone and the delegation is clearly described.

3. **Commit both edits together** — single commit covering both file changes, message: `update: friday-act R1 completion — fallback-passthrough rule + stale Notes update`.

4. **Two-cycle paste-decision validation** — surface to operator: mentally run the subagent summary output against the 16b paste-decision step using `friday-checkup-2026-05-22.md` and one prior cycle. Confirm operator would surface the same SO-derived items from the summary as from the old full-section display. If validation passes, R1 is complete. If it reveals signal loss, the agent schema needs expansion before landing.

## Scope Alternatives
Single scope — no alternatives. Both file edits are required by the approved design; neither is optional.

## Autonomy Posture
Full autonomy

**Stop points:** None. Both edits are small, well-specified, and reversible. Two-cycle validation in Step 4 is surfaced to operator for awareness but does not require a pause gate — it is a confirmation step, not a judgment fork.

## Risk
No new structural change classes introduced — agent file and command file were already created/edited in the prior session that shipped the dispatch wiring. End-time `/risk-check` is skippable per documented skip rule (plan-time gate already ran with PROCEED-WITH-CAUTION verdict + all 3 mitigations applied; commits already bounded; no drift). Document skip in wrap note.
