# Session Plan — 2026-05-29

## Intent
Apply findings from the 4 cycle-2 pipeline-review memos (pipeline-review, consult, contract-check, friction-log) to their respective command targets — leanness, brokenness, and in-scope recommended-next-session items.

## Model
opus — match (active is `claude-opus-4-7[1m]`; judgment-per-finding work suits opus tier).

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/pipeline-reviews/pipeline-review-2026-05-29.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/pipeline-reviews/consult-2026-05-29.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/pipeline-reviews/contract-check-2026-05-29.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/pipeline-reviews/friction-log-2026-05-29.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/pipeline-review.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/consult.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/contract-check.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friction-log.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/note.md` (sibling consumer of friction-log contract)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/pipeline-review-registry.md` (re-tier row)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` (structural-class checklist for deferral decisions)

## Findings / Items to Address

Per-memo numbered list. Each item is classified `apply` (in scope this session) or `defer` (surfaced as reasoned skip, structural or out-of-scope per memo's own Recommended-next-session framing).

### pipeline-review memo (`audits/pipeline-reviews/pipeline-review-2026-05-29.md`)

1. **PR-1 [apply, Brokenness Substantive]** — Frontmatter divergence (memo § Brokenness, line 23): add `description:`, `disable-model-invocation: true`, `argument-hint: [pipeline-path]` to `.claude/commands/pipeline-review.md`.
2. **PR-2 [apply, Leanness]** — Collapse duplicate "Registry contract" block (lines 17–27 of pipeline-review.md) to 2-line pointer per memo § Leanness #2.
3. **PR-3 [defer, Cross-resource Substantive]** — Post-memo `/qc-pass` gate in Step 6 (memo § Cross-resource #3). Reorders operations against shared-state (registry bump) → structural change class per audit-discipline.md tripwire; requires `/risk-check`. Defer to dedicated session per memo's own Recommended-next-session framing ("if context allows" as second item).
4. **PR-4 [apply, Brokenness Minor]** — Step 4.17/17.1/17.5 numbering collision (memo § Brokenness #3): renumber to 17 → 17.1 → 17.5 → 18a/18b/18c.
5. **PR-5 [apply, Leanness]** — Collapse Step 2 cadence-late prose duplicate citation at line 62 (memo § Leanness #1, ~80 tokens).
6. **PR-6 [apply, Leanness]** — Drop Notes tail bullets 1–3 (memo § Leanness #4); keep bullet 4 (operator-actionable "skipped >2× per quarter" trigger).
7. **PR-7 [apply, Brokenness Minor]** — Downgrade Notes tail bullet "skipped >2× per quarter" to advisory wording with no false enforcement claim (memo § Brokenness #4).
8. **PR-8 [defer, Innovation]** — Quarterly self-reflection row (memo § Innovations #1). Registry row addition, low marginal value this cycle.
9. **PR-9 [defer, Innovation]** — Throughput-queue surfaced in shortlist prompt (memo § Innovations #2). Requires new cross-memo aggregation logic; out of scope.
10. **PR-10 [defer, Innovation]** — Per-pipeline tier-eligibility column (memo § Innovations #3). Low-leverage prompt-only change.
11. **PR-11 [defer, Innovation]** — Currency-check URL set reference-table extraction (memo § Innovations #4). Couples with deferred MCP/hooks scope extension; defer until trigger fires.

### consult memo (`audits/pipeline-reviews/consult-2026-05-29.md`)

12. **C-1 [defer, Innovation Substantive]** — Cap advisory return at contract floor (memo § Innovations #1). Touches canonical `.claude/agents/system-owner.md` Phase 5 (six-consumer shared agent per memo § Cross-resource #2) → structural change class → `/risk-check` plan-time required. Defer to dedicated session per memo's own Recommended-next-session framing.
13. **C-2 [defer, Brokenness Substantive]** — Project-local agent copy drifts from canonical (memo § Brokenness #1). Cleanest fix is symlink replacement, which touches the agent-discovery surface for `projects/axcion-ai-system-owner/` sessions → structural change class. Defer; pair with C-1 in same dedicated session per memo's Recommended-next-session line.
14. **C-3 [apply, Brokenness Substantive at system level]** — Frontmatter currency (memo § Brokenness #3): add `disable-model-invocation: true` + `argument-hint:` to `consult.md`. `description` field is already present.
15. **C-4 [apply, Leanness]** — Drop "Notes for the executor" tail (memo § Leanness #1, ~80 tokens).
16. **C-5 [apply, Leanness]** — Compress Step 1 empty-arguments error block (memo § Leanness #2, ~30 tokens).
17. **C-6 [apply, Leanness]** — Inline Step 4 brief conditional append (memo § Leanness #3, clarity gain).
18. **C-7 [defer, Innovation structural]** — Merge `/consult` and `/pm` change-shape definition into shared snippet (memo § Innovations #2). Per memo's own DR-7 counter-argument: defer until drift observed; current state clean.

### contract-check memo (`audits/pipeline-reviews/contract-check-2026-05-29.md`)

19. **CC-1 [apply, Brokenness Substantive]** — Add `argument-hint: "[contract-path-or-inline-text]"` to frontmatter (memo § Brokenness #1).
20. **CC-2 [apply, Brokenness Minor]** — Add `allowed-tools` frontmatter field (memo § Brokenness #2).
21. **CC-3 [apply, Innovation Minor]** — Echo contract-type (`hard`/`soft`) on Step 5 verdict header line (memo § Innovations #2).
22. **CC-4 [apply, Innovation Minor]** — Pre-emit `[HEAVY]` notice when 800-line truncation fires (memo § Innovations #3).
23. **CC-5 [apply, Innovation Minor]** — Align Step 3 item 7 "Zero candidates" prose to explanatory shape (memo § Innovations #1).
24. **CC-6 [apply, Leanness Minor]** — Compress Step 2 item 4 path heuristic enumeration to 3 items (memo § Leanness #1, ~80 tokens).
25. **CC-7 [apply, Leanness Minor-Moderate]** — Tighten Step 2 item 5 cascade prose into 6-row table (memo § Leanness #2, ~250 tokens).
26. **CC-8 [defer, Leanness structural]** — Subagent-brief externalization to `docs/contract-check-subagent-brief.md` (memo § Leanness #3). New doc file + revised command body → structural change class → `/risk-check` per DR-8. Defer per memo's own Recommended-next-session framing.

### friction-log memo (`audits/pipeline-reviews/friction-log-2026-05-29.md`)

27. **FL-1 [defer, Innovation Substantive structural]** — Unify session-header shape across all three writers (memo § Innovations #1). Touches `.claude/hooks/friction-log-auto.sh` (hook edit) + downstream `friction-log.md` Step 2 + `note.md` Step A.2 (cross-cutting two-end contract repair) → structural change class. `/risk-check` required per memo. Defer to dedicated session per memo's Recommended-next-session line.
28. **FL-2 [apply, Brokenness Minor]** — Drop leading slash on `/logs/friction-log.md` in `friction-log.md` lines 19 and 32 (memo § Brokenness #2). One-line cosmetic.
29. **FL-3 [apply, Brokenness Minor]** — Frontmatter currency (memo § Brokenness #3): add `description:`, `argument-hint:`, `disable-model-invocation: true` to `friction-log.md`.
30. **FL-4 [defer, Brokenness Minor]** — Stub-check rule duplication with `/note` (memo § Brokenness #4). Per memo's own DR-7 counter-argument: defer until second drift signal appears.
31. **FL-5 [apply, Cross-resource registry]** — Re-tier friction-log row in `audits/pipeline-review-registry.md` from weekly to quarterly (memo § Cross-resource #5). One-line registry edit; memo explicitly endorses ("System Owner recommendation was right").
32. **FL-6 [defer, Innovation Minor docs]** — Promote `friction-log: true` frontmatter to documented convention (memo § Innovations #2). Docs-only; couples with FL-1's hook context; defer.

## Execution Sequence

Three apply-waves + one defer-documentation wave. Phase boundaries get `/qc-pass`.

### Phase 1 — Frontmatter + cosmetic (Wave 1: PR-1, PR-4, C-3, CC-1, CC-2, FL-2, FL-3, FL-5)
1. Edit `pipeline-review.md` frontmatter (PR-1) + renumber Step 4.17 collision (PR-4). Verification: `grep ^description: pipeline-review.md` returns one line; the renumbered sequence has no duplicate Step numbers.
2. Edit `consult.md` frontmatter (C-3). Verification: `grep "disable-model-invocation:" consult.md` returns the new line.
3. Edit `contract-check.md` frontmatter (CC-1 + CC-2). Verification: `grep "argument-hint:\|allowed-tools:" contract-check.md` returns both new lines.
4. Edit `friction-log.md`: drop leading slashes lines 19/32 (FL-2) + frontmatter (FL-3). Verification: `grep "/logs/friction-log" friction-log.md` returns zero lines.
5. Edit `audits/pipeline-review-registry.md`: move friction-log row from weekly section to quarterly section (FL-5). Verification: registry's `friction-log.md` row sits under quarterly block.
6. `/qc-pass` on the Wave 1 edits. On GO: commit `wave 1 frontmatter + cosmetic`.

### Phase 2 — Leanness fixes (Wave 2: PR-2, PR-5, PR-6, PR-7, C-4, C-5, C-6, CC-3, CC-4, CC-5, CC-6, CC-7)
7. Edit `pipeline-review.md`: collapse Registry-contract duplicate (PR-2), trim Step 2 cadence-late prose (PR-5), drop Notes tail bullets 1–3 (PR-6), downgrade "skipped >2× per quarter" to advisory wording (PR-7). Verification: file diff shows the trims; net token reduction ≥350 tokens.
8. Edit `consult.md`: drop Notes tail (C-4), compress Step 1 empty-args block (C-5), inline Step 4 brief conditional (C-6). Verification: file diff shows trims; ~110-token reduction.
9. Edit `contract-check.md`: echo contract-type on Step 5 verdict header (CC-3), surface truncation notice on Step 3 item 8 (CC-4), align Step 3 item 7 to explanatory shape (CC-5), compress Step 2 item 4 path heuristic (CC-6), tighten Step 2 item 5 cascade to table (CC-7). Verification: file diff shows each change; net token reduction ~330 tokens.
10. `/qc-pass` on the Wave 2 edits. On GO: commit `wave 2 leanness fixes`.

### Phase 3 — Document deferred items (Wave 3: PR-3, PR-8..PR-11, C-1, C-2, C-7, CC-8, FL-1, FL-4, FL-6)
11. For each memo with deferred items, append a one-line status note to the memo body's `## Recommended next session` section (or as a new `## Deferred to dedicated session` block) naming the item IDs and the deferral rationale (structural class / `/risk-check` required / DR-7 counter-argument). This preserves the memo as the audit-trail-grade source; subsequent reviewers see what was applied vs deferred from this session.
12. Append a `### Summary / ### Decisions / ### Next Steps` block to today's session-notes entry capturing the per-memo apply/defer split and the deferred items as carryover for dedicated sessions.

### Phase 4 — Wrap
13. Commit Phase 3 documentation. Total expected commits: 3 (Wave 1, Wave 2, Phase 3 docs).
14. Remind operator to run `/wrap-session`.

## Scope Alternatives

- **Min:** Wave 1 only (Phase 1: PR-1, PR-4, C-3, CC-1, CC-2, FL-2, FL-3, FL-5). Frontmatter + cosmetic across all 4 commands + registry re-tier. ~1 commit. Lowest risk, highest signal-per-token for surface conformance.
- **Recommended:** Wave 1 + Wave 2 + Phase 3 documentation (Phases 1–4 above). 19 of 32 findings applied; 13 deferred with rationale. ~3 commits. Highest realistic in-session completion of the mandate's "applied or surfaced with reasoned skip" exit condition.
- **Max:** Recommended + pull C-2 (project-local agent copy symlink fix) into the same session — small structural touch, mechanical, no contract surface change (per memo § Recommended-next-session "clean parallel fix in the same session"). Requires `/risk-check` plan-time on the symlink change. Would push session commits to 4 and add ~10–15 min for the risk-check gate.

## Autonomy Posture

Full autonomy. Phase-boundary `/qc-pass` gates apply. No per-finding operator prompts.

**Stop points:**
- After Phase 1 `/qc-pass` if verdict is NEEDS-WORK on any Wave 1 edit → triage and re-edit; do not advance to Phase 2.
- After Phase 2 `/qc-pass` if verdict is NEEDS-WORK on any Wave 2 edit → triage and re-edit; do not advance to Phase 3.
- If any in-scope finding turns out to require `/risk-check` on closer inspection (e.g., its blast radius is wider than the memo suggested), re-classify as defer and surface in Phase 3 documentation rather than implement.

## Risk

No structural change classes in the Recommended scope (Waves 1+2 are frontmatter, cosmetic, in-place trim work — no hook edits, no permission changes, no canonical-agent edits, no new symlinks, no automation-with-shared-state reordering). Run `/risk-check` ONLY if scope expands to pull a deferred item into the session (Max scope's C-2 symlink fix; or any in-scope finding that on inspection touches shared-state ordering — see Stop Points). The deferred items themselves do not need `/risk-check` this session because they are not being applied — they are surfaced for future dedicated sessions per each memo's own Recommended-next-session framing.
