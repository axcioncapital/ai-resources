# Session Plan — 2026-06-08

## Intent
Execute the 5-item fix plan at `audits/fix-plans/fix-repo-issues-2026-06-08-1052.md` — items 4+5 (log annotations) first, then 1, 2, 3 with `/qc-pass` after each.

## Model
sonnet (doing — spec-following edits, each item names the exact change) — → /model sonnet (advisory; currently on opus-4-8[1m]). Item 1's QC-rule clarification has a light judgment element; opus is acceptable if the operator prefers not to switch.

## Source Material
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/fix-plans/fix-repo-issues-2026-06-08-1052.md (the plan being executed)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/resolve-improvement-log.md (FADING-GATE / annotation schema reference)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/friction-log.md (item 4 — 3 annotations)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap/logs/friction-log.md (item 5 — 4 annotations; item 2 — 1 annotation)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/logs/friction-log.md (item 1 — annotation)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/qc-pass.md and ai-resources/docs/qc-independence.md (item 1 — clarify QC scope)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap/.claude/commands/run-analysis.md (item 2 — Step 2.2b encoding step)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/commit-discipline.md (item 3 — explicit-staging rule)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/logs/friction-log.md (item 3 — annotation)

## Findings / Items to Address
1. **[ai-resources, item 4] FADING-GATE cleanup** — annotate 3 ai-resources friction-log entries whose fixes already shipped (S6(a) concurrent-session guards → 2bc89d9; S6(b) done-condition check → friday-act sweep; NO_OWN_MARKER → dd618d4). Log-hygiene only, no QC. *(plan §Items, item 4)*
2. **[research-pe, item 5] FADING-GATE cleanup** — annotate 4 research-pe friction-log entries (S3 PAUSE → 2add1f2; S2 cross-day → 6be1d77; S5 citation → 1021bfe; S1 concurrent-checkout → 93abf16). Log-hygiene only, no QC. *(plan §Items, item 5)*
3. **[workspace, item 1] QC verbatim-purity false REVISE** — add 1–3 sentences to the QC scope instruction (qc-pass.md or qc-independence.md) carving out plan-mandated additions from the verbatim-purity REVISE trigger; annotate workspace friction-log ~line 7. QC required. *(plan §Items, item 1)*
4. **[research-pe, item 2] UTF-8 intake normalization** — add a Step 2.2b encoding-normalization instruction to run-analysis.md (iconv/Python errors='replace') so non-ASCII intake content is not silently corrupted; annotate research-pe friction-log (S4 2026-06-02). QC required. *(plan §Items, item 2)*
5. **[ai-development-lab, item 3] concurrent-commit staging rule** — add an explicit-path staging rule to ai-resources/docs/commit-discipline.md (no broad `git add .`/`-A`; stage by explicit path; inspect `git status --short` first); annotate ai-development-lab friction-log ~line 10. QC required. *(plan §Items, item 3)*

## Execution Sequence
1. **Item 4** — Read ai-resources/logs/friction-log.md; locate the 3 entries; append the exact `[FADING-GATE] verified 2026-06-08 …` lines from plan §item 4. *Verify:* 3 annotation lines present, each directly after its entry.
2. **Item 5** — Read research-pe friction-log.md; locate the 4 entries; append the exact annotation lines from plan §item 5. *Verify:* 4 annotation lines present.
3. **Commit** items 4+5 (log-hygiene batch). *Verify:* commit lands; staged by explicit path.
4. **Item 1** — Read workspace friction-log ~line 7 for context; decide qc-pass.md vs qc-independence.md as the edit target; add the carve-out sentences; annotate the friction-log entry. Run `/qc-pass`. *Verify:* QC GO; carve-out reads cleanly; annotation present.
5. **Item 2** — Read research-pe friction-log S4 entry; open run-analysis.md; add Step 2.2b encoding instruction; annotate the entry. Run `/qc-pass` (confirm it doesn't alter valid UTF-8). *Verify:* QC GO; step explicit about the normalization tool.
6. **Item 3** — Read ai-development-lab friction-log ~line 10; edit ai-resources/docs/commit-discipline.md staging section; annotate the entry. Run `/qc-pass`. *Verify:* QC GO; rule names explicit-path staging.
7. **Commit** items 1, 2, 3 (per item or as one batch with /qc-pass clean). *Verify:* commits land.

## Scope Alternatives
- **Min:** items 4+5 only (log-hygiene, no QC) — closes the annotation-gap that reconcile-at-read surfaced.
- **Recommended:** all 5 items — full plan execution as written.
- **Max:** all 5 + `/contract-check` near wrap (multi-repo, 7 files) before the push gate.

## Autonomy Posture
Full autonomy — each item is additive and fully specified by the plan; `/qc-pass` is the in-line quality gate for items 1–3.

**Stop points:**
- A QC DISAGREE verdict on an editorial decision (item 1's carve-out wording, per Autonomy Rule #4).
- Item 1's edit-target choice (qc-pass.md vs qc-independence.md) if the context read makes neither a clean fit — surface and proceed with the better fit otherwise.

## Risk
No structural change classes apparent — the edits are additive clarifications to existing docs/commands and log annotations; none reorder operations against shared state. Run `/risk-check` if item 1's scope expands into changing the QC verdict logic itself rather than clarifying its scope note.
