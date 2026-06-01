# Session Plan — 2026-06-01

## Intent
Fix all tracked open items except inbox briefs: (1) flip decisions.md Item 10 → friday-act auto-triage APPLIED; (2) run /log-sweep on over-threshold logs; (3) decide CLAUDE.md mirror-block leanness and record to decisions.md; (4) Option 2 structural marker fix — session-scoped `CLAUDE_SESSION_MARKER` env var, as a /risk-check-gated wave — which closes both open friction items (TOCTOU concurrent-session races + wrap-session Step 3.5 guard false-positive).

## Model
opus — match (active: claude-opus-4-8[1m]). The hard part is deciding/designing: the mirror-block keep-trim judgment and the Option 2 read/write contract across 9 consumers are synthesis-under-ambiguity work. The lighter items (Item 10 flip, /log-sweep) ride along.

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/decisions.md` — Item 10 flip target + mirror-block decision record
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md` — the 2026-05-29 marker-clobber entry (Option 2 spec, blast radius, Option-1 rejection result)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/log-sweep.md` — /log-sweep procedure
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/CLAUDE.md` + workspace `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md` — mirror-block leanness target
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md` — marker writer (Steps 8a/8b/8c.3) — Option 2
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md` — Step 3.5 marker detector — Option 2
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-start.md` — Step 0.5 mtime guard — Option 2
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-marker.md` — canonical marker contract (9 consumers) — Option 2
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` — structural change classes (Option 2 risk-check)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/risk-checks/2026-06-01-wrap-session-step35-clobber-suspicion-sanity-check.md` — Option-1 gating report + rejection outcome

## Findings / Items to Address
1. **Item 10 flip** (decisions.md) — friday-act auto-triage fix shipped `11dfd92` but decisions.md Item 10 still reads "deferred." QC surfaced this in S2. 1-line disposition flip to APPLIED. *(Verify exact entry first — engine flagged decisions.md has multiple Item-10-like entries; confirm the friday-act general-plan #10 target.)*
2. **/log-sweep** — Monday-prep 2026-W23 flagged 5 project `session-notes.md` over the 200-line threshold (348/234/527/523/597) + ai-resources `improvement-log.md` at 221. Run /log-sweep across over-threshold scopes; archive per its procedure.
3. **Mirror-block leanness** (CLAUDE.md) — Monday-prep flagged Input File Handling / Compaction / Session Boundaries / Commit-Push blocks duplicated verbatim across project CLAUDE.md files (~430–720 tok/turn each). No rule governs keep-vs-trim. Decide with rationale; record to decisions.md. Deliverable = the recorded decision (trim *execution* across 11 files is a separate task unless the decision is trivially quick).
4. **Option 2 marker fix** (structural) — root-cause fix for the marker-clobber class. Replace the shared-mutable `.session-marker` file-as-identity-oracle with a per-process `CLAUDE_SESSION_MARKER` env var set at /prime, immune to file clobber. Closes friction-log entries: (a) TOCTOU concurrent-session races (#1 chronic problem, "3–4× in 5 days"); (b) wrap-session Step 3.5 guard false-positive. improvement-log Option-1 was VALIDATED-REJECTED 2026-06-01 (no clean file-only signal exists); Option 2 is the escalation. Blast radius = 9 marker-contract consumers per docs/session-marker.md. **Design is proposal-level only — the read/write contract must be designed at the plan-time /risk-check before touching consumers.**

**Side finding (this session):** the marker-scoped plan filename `session-plan-SN.md` is day-relative-N but NOT date-scoped — today's S3 collided with the stale 2026-05-29 S3 plan. Same root class as Item 4 (marker is `DATE SN` but derived artifacts drop the date). Fold into Item 4's design consideration if cheap; otherwise log.

## Execution Sequence
1. **Wave 1 — Item 10 flip.** Grep decisions.md for the friday-act auto-triage Item 10; confirm target; flip disposition → APPLIED with `11dfd92` reference. *Verify:* decisions.md Item 10 reads APPLIED; no other Item-10 entry mis-edited.
2. **Wave 2 — /log-sweep.** Invoke /log-sweep on over-threshold scopes. *Verify:* archived logs back under threshold; archive files written; no active-log content lost.
3. **Wave 3 — Mirror-block decision.** Read the duplicated blocks across project CLAUDE.md files; weigh keep (opened-without-parent-context strategy) vs trim (token cost). Decide; record a dated decision entry in decisions.md. *Verify:* decisions.md carries the new decision with rationale + alternatives considered.
4. **Wave 4 — Option 2 marker fix (GATED).** (a) Design the `CLAUDE_SESSION_MARKER` read/write contract + per-marker file / append-only history; (b) run plan-time `/risk-check` — **on RECONSIDER/NO-GO, pause and surface**; (c) on GO, implement across the 9 consumers (prime.md writers, wrap-session.md detector, session-start.md guard, session-marker.md contract, + remaining readers); (d) `/qc-pass` on the edits; (e) end-time `/risk-check` before commit. *Verify:* env-var path immune to file clobber; both friction entries marked closed; /risk-check GO; /qc-pass GO.

## Scope Alternatives
- **Min:** Waves 1–3 only (the safe/maintenance items); defer Option 2 to its specced dedicated session. *(This was the recommended split; operator chose "do everything now.")*
- **Recommended (operator-chosen):** All four waves this session, Option 2 staged last as a gated structural wave with its own plan-time /risk-check.
- **Max:** Recommended + execute the mirror-block *trim* across all 11 project files if Wave 3 decides "trim" and context allows; else log the trim as a follow-up.

## Autonomy Posture
Gated — Waves 1–3 run under full autonomy (additive/maintenance/decision-record). Wave 4 is structural and pauses at the plan-time /risk-check verdict.

**Stop points:**
- Wave 4 plan-time `/risk-check` verdict: on RECONSIDER or NO-GO, pause and surface; retain design on disk for revision.
- If /log-sweep (Wave 2) surfaces anything it cannot safely archive, pause rather than force.

## Risk
Run `/risk-check` after the Wave 4 design is drafted (plan-time gate) — Option 2 touches structural change classes: cross-cutting canonical-command edits (prime/wrap-session/session-start), a new env-var-based automation with shared-state effects, and a 9-consumer blast radius per docs/session-marker.md. Run `/risk-check` again before the Wave 4 commit (end-time gate). Waves 1–3 are below the structural threshold (single-file decision-record appends + a maintenance command run) — no risk-check needed for those.
