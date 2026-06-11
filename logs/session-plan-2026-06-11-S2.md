# Session Plan — 2026-06-11

## Intent
Run independent /qc-pass on the P1–P4 concurrent-session coverage build (check-foreign-staging.sh P3 logic; three settings.json P1/P2 registration dedup; workspace-root wrap-session.md P4 port), then on GO commit across the three affected repos and complete the four post-commit follow-ups. Do NOT commit before QC passes.

## Model
opus (judgment QC of an architectural change) — match (session model is Opus-class). Subagent reachability confirmed this session via the context-discovery probe (the S1 1M-credit gate did not fire).

## Source Material
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scratchpads/2026-06-11-12-22-scratchpad.md — QC-PENDING scratchpad; authoritative resume instructions + drafted QC scope
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/session-plan-2026-06-11-S1.md — the approved P1–P4 build plan
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/risk-checks/2026-06-11-build-deferred-concurrent-session-coverage-fix-p1-p4.md — plan-time risk-check (PROCEED-WITH-CAUTION) + SO commentary (R1/R2/R3)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/2026-06-10-concurrent-session-coverage-audit.md — original coverage audit (P1–P5 plan)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/qc-independence.md — QC methodology incl. Subagent-unavailable fallback
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/output/context-packs/qc-20260611-a7c2e/pack.md — engine context pack (untracked)

## Findings / Items to Address
1. QC scope (a) — check-foreign-staging.sh P3: new BLOCK branch must sit AFTER the L72–91 gated-verb early exit [BLOCKING] (scratchpad § Resume With).
2. QC scope (b) — P3 `_live_foreign_session()` self-excludes by session_id (scratchpad § Resume With).
3. QC scope (c) — empty session_id degrades to warn+allow, not block (scratchpad § Resume With).
4. QC scope (d) — header FAIL-OPEN comment matches the new split behavior; today-comparison `content.split(" ")[0] == today` correctly matches `YYYY-MM-DD SX` marker content (scratchpad § Resume With).
5. QC scope (e) — JSON validity + exactly-one registration per hook across ~/.claude/settings.json (P1+P2 ADD), ai-resources/.claude/settings.json (DELETE), projects/positioning-research/.claude/settings.json (DELETE) — atomic dedup, no double-fire, no zero-coverage window (scratchpad § Decisions / SO atomic-landing).
6. QC scope (f) — workspace-root .claude/commands/wrap-session.md P4: verbatim port of canonical Step 13, runs last, no duplicate step (scratchpad § Resume With).
7. Post-commit R1 — Daniel handoff note: user-level absolute paths do NOT reach Daniel's clone; he must register both hooks in his own ~/.claude/settings.json (risk-check report, load-bearing residual).
8. Post-commit R2 — orphan projects/research-pe-regime-shift-advisory-gap/.claude/hooks/detect-concurrent-session.sh: note as deliberately-unregistered or delete (risk-check report).
9. Post-commit R3 — log that P3 now hard-stops on the no-footprint+concurrent shape → higher-consequence known interaction with the deferred intra-project /prime race (docs/risk-topology.md marker row).
10. Post-commit — flip the improvement-log.md umbrella PENDING entry (concurrent-session coverage, 2026-06-10) → resolved; note P3/P4 done, P5 still deferred.
11. Post-commit — delete logs/scratchpads/2026-06-11-12-22-scratchpad.md so the QC-PENDING block drains.

## Execution Sequence
1. Spawn the independent QC subagent (qc-reviewer) with the drafted scope (items 1–6) + the five artifact paths. Verify: subagent returns a verdict; if it dies on the credit gate, STOP and defer via /handoff per the mandate's stop-condition.
2. On GO → commit (i) ai-resources repo: check-foreign-staging.sh P3 + settings.json dedup + risk-check report + session logs (notes/plan/decisions). Verify: commit lands; files match working-tree state.
3. Commit (ii) workspace-root parent repo: .claude/commands/wrap-session.md P4. Verify: commit lands in the parent repo, not ai-resources.
4. Commit (iii) positioning-research repo: settings.json dedup with a clear standalone message. Verify: commit lands. (~/.claude/settings.json is gitignored/per-machine — never committed.)
5. Write follow-ups: R1 Daniel note (improvement-log + coverage-audit Related section), R2 orphan-hook disposition, R3 risk-topology note, umbrella entry flip. Verify: each file shows the edit.
6. Delete the scratchpad. Verify: file gone; /prime stops surfacing QC-PENDING.
7. End-time /risk-check decision: plan-time gate (S1) covered the executed scope with mitigations applied; if no scope expansion occurred, document the skip per the end-time-skip rule in the wrap note.

## Scope Alternatives
- Min: QC only — if verdict is not GO, stop after Step 1 (commit-block stands, log findings, /handoff).
- Recommended: QC → 3-repo commit → all four follow-ups + scratchpad deletion (full mandate).
- Max: also resolve any MINOR QC findings inline before commit (single /resolve round), then proceed as recommended.

## Autonomy Posture
Gated

**Stop points:**
- QC verdict — non-GO blocks all commits (operator informed, /handoff if deferral needed).
- QC subagent unreachable — stop, defer via /handoff (do not self-QC-and-commit).
- Push — none this session mid-stream; batched to /wrap-session per workspace rules.

## Risk
Plan-time /risk-check already ran in S1 (PROCEED-WITH-CAUTION, SO concurred, mitigations applied — audits/risk-checks/2026-06-11-build-deferred-concurrent-session-coverage-fix-p1-p4.md). This session adds no new structural scope — it QCs and lands the already-gated change set. End-time gate: decide skip-vs-refire at commit per the end-time-skip rule (skip only if scope unexpanded and mitigations intact); document the decision in the wrap note.
