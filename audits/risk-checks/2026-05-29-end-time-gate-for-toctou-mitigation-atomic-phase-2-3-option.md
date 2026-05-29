# Risk Check — 2026-05-29

## Change

End-time gate for TOCTOU mitigation atomic Phase 2+3 (Option A) — pre-commit verification. Plan-time gate (Round 2 atomic spec) returned PROCEED-WITH-CAUTION with 4 mitigations; SO concurred + recommended extend-to-16; QC pass returned REVISE with 4 findings all addressed inline (1 BREAK-risk regex bug in backup-session-plan.sh fixed; 3 narrative drift fixes applied). Cumulative atomic commit covers 16 files: 14 modified + 1 new docs/session-marker.md + 1 git rm logs/session-plan.md + 1 git add logs/session-plan-S3.md. All 4 Round 2 mitigations applied. Marker-resolution read-test ran — zero orphan bare logs/session-plan.md refs remain in any consumer body.

The four QC fixes that landed after the plan-time gate:
1. backup-session-plan.sh regex broadened from `(-[a-zA-Z0-9]+)?` to `(-[a-zA-Z0-9]+){0,2}` — closes BREAK risk where `session-plan-S1-pass2.md` would be silently un-backed-up.
2. weekly-cadence.md line 78 — narrative reference updated to marker-scoped path; added to docs/session-marker.md doc-references registry.
3. open-items.md lines 68 + 83 — Tier-3 output template phrasing updated for consistency.
4. session-plan.md Step 1 narrative (lines 41 + 45) rewritten — stale framings removed; replaced with "Step 0 always sets UPCOMING_INTENT as a forward-pass" framing matching the new Step 0.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/risk-checks/2026-05-29-plan-time-gate-for-toctou-mitigation-atomic-phase-2-3.md — exists (plan-time PROCEED-WITH-CAUTION baseline)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/backup-session-plan.sh — exists (regex fix verification)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/toctou-phase-2-and-3-atomic-spec.md — exists (spec; table-only review per scope)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-plan.md — exists (Step 0 + Step 1 spot-check)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-marker.md — exists (registry verification)

## Verdict

GO

**Summary:** All four QC-fix edits are clean as delta-deltas against the plan-time PROCEED-WITH-CAUTION baseline. Atomic landing eliminates Round 2's High Blast Radius (every named orphan consumer is in the commit), and the four QC fixes introduce no new risk surface — regex broadening is bounded and does not over-match relative to the prior regex, Step 1 narrative is internally consistent with Step 0, and the doc-references registry now includes weekly-cadence.md.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Delta is content-only (regex character-class widening + narrative substitutions + one registry bullet). No new always-loaded content, no new hook, no new subagent, no new skill trigger keyword introduced by the four QC fixes vs the plan-time baseline.
- docs/session-marker.md is still on-demand reference (not `@import`ed) — registry expansion adds ~8 lines under "Doc references" subsection (verified at session-marker.md:101-111). Pay-per-read, not always-loaded.
- session-plan.md Step 1 narrative rewrite is a wash on token count (replaced stale paragraphs with new framing of similar length — verified at session-plan.md:41-45).

### Dimension 2: Permissions Surface
**Risk:** Low

- Zero permission deltas in the four QC fixes. No new tool family invoked; no allow/deny edits; no scope escalation. Plan-time baseline was already Low on this dimension.

### Dimension 3: Blast Radius
**Risk:** Low

- Plan-time verdict scored High on Blast Radius due to 6 orphan consumers not in the spec's 10-file list. SO advisory + Round 2 Mitigation 1 extended the commit to 14 files; final atomic commit covers 16 files (14 modified + new docs/session-marker.md + git rm logs/session-plan.md + git add logs/session-plan-S3.md per CHANGE_DESCRIPTION). Every named orphan is now in the commit. The two SO-flagged narrative-drift items (`backup-session-plan.sh` comment, `heavy-read-discipline.md:45`) are also addressed — backup-session-plan.sh comment text verified updated at lines 3-7, 14-19 (current text references "marker-scoped variants per docs/session-marker.md" and explains the regex bounds); docs/session-marker.md:110 registry includes heavy-read-discipline.md.
- The four QC-fix edits themselves are each scoped to a single file (no cascading caller changes). Verified zero downstream callers depend on the modified internal narrative text in session-plan.md Step 1 or the open-items.md Tier-3 template phrasing — these are display strings, not contract surfaces.
- Marker-resolution read-test outcome per CHANGE_DESCRIPTION: zero orphan bare-path refs remain in any consumer body. Plan-time M4 (read-test) discharged.

### Dimension 4: Reversibility
**Risk:** Low

- Single atomic commit; `git revert <hash>` cleanly undoes all 16 files in one step. Plan-time baseline was Medium (due to `session-plan-S*.md` accumulation policy ambiguity); session-marker.md:79 now explicitly states "Tracking policy: `logs/session-plan-S*.md` files are tracked in git ... Not gitignored." Policy is documented in the canonical contract, closing the M6 mitigation.
- Rollback recipe (per plan-time evidence) named in commit message: `git revert <hash>; rm -f logs/.session-marker logs/session-plan-S*.md; re-run /prime`. Stays accurate under the 16-file commit shape — additional files added by the commit are also reverted in one operation.
- No QC-fix edit introduces a state mutation that survives revert (no log appends, no external writes, no symlink, no cached state).

### Dimension 5: Hidden Coupling
**Risk:** Low

- **Regex over-match analysis (focused question 2):** New regex `(^|/)logs/session-plan(-[a-zA-Z0-9]+){0,2}\.md$` verified at backup-session-plan.sh:20. Test trace:
  - `logs/session-plan.md` → matches (zero segments). Prior regex also matched. Under Option A this file is removed at commit; benign if a hypothetical write fires (the file-existence guard at line 25 short-circuits `cp` if SRC missing).
  - `logs/session-plan-S1.md` → matches (one segment). Desired.
  - `logs/session-plan-S1-pass2.md` → matches (two segments). Desired — the fix target.
  - `logs/session-plan-bundle5.md`, `-next.md`, `-pass2.md` legacy single-segment names → match (one segment). Already matched by prior `(-[a-zA-Z0-9]+)?` regex; no new behavior.
  - `logs/session-plan-S1-pass2-extra.md` (three segments) → does NOT match (`{0,2}` upper bound holds). Bounded correctly.
  - **No spurious backup churn introduced.** The broadening adds the two-segment case (`-S1-pass2.md` style) only. Existing legacy historical files in `logs/` (per plan-time inventory) are single-segment and were already matched.
- **Step 1 narrative consistency with Step 0 (focused question 3):** session-plan.md Step 0 verified at lines 28-32: "Determine UPCOMING_INTENT for Step 1 caching" with three branches (`$ARGUMENTS` non-empty / Next Steps scan / sentinel `(none derived)`). Step 1 at line 41 reads "Step 0 always sets UPCOMING_INTENT as a forward-pass to Step 1 (TOCTOU Phase 2+3 atomic — same-session re-invocation check completes; UPCOMING_INTENT is computed regardless of branch)." Step 1 at line 45 reads "If UPCOMING_INTENT is the sentinel `(none derived)` ... fall through to the manual-derivation block below." Both references match Step 0's actual mechanics. No stale "intent-comparison conflict detection" or "no prior plan within 6 hours" phrasing remains in lines 41-45. Internally consistent.
- **session-marker.md registry includes weekly-cadence.md (focused question 4):** Verified at session-marker.md:111: `- ai-resources/docs/weekly-cadence.md — Phase D scope-separation narrative.` Present under "Doc references (narrative, not consumers)" subsection. Registry completeness addresses plan-time Mitigation 2 (registry under-statement).
- **open-items.md template phrasing (QC fix 3):** Operator-facing display string change only ("session-plan" → "marker-scoped session-plan" / glob reference). No contract surface; no caller depends on this template text verbatim. Self-contained.
- **No new silent auto-firing.** No new hooks added. backup-session-plan.sh hook trigger condition unchanged (PreToolUse Write); only regex match domain widened by one segment-count.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: backup-session-plan.sh:14-20 (regex text + comment block verified post-fix); session-plan.md:28-32 (Step 0 UPCOMING_INTENT computation) and :41-45 (Step 1 cache-shortcut + sentinel fall-through); session-marker.md:79 (gitignore policy line), :101-111 (Doc references subsection including weekly-cadence.md at :111 and heavy-read-discipline.md at :110); plan-time risk-check report read in full for baseline comparison (Dim 3 High → Low delta, Dim 4 Medium → Low delta justified by atomic landing + tracking-policy line). Regex over-match test traced six concrete path examples spanning zero, one, two, and three trailing segments. No training-data fallback used.
