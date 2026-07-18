# Session Plan — 2026-07-18

## Intent
Fix `run-manifest.sh` so a session wrapping after midnight closes its own start-stub instead of dying or writing a second manifest, and add the missing midnight case to the test harness. (Mission `repo-health-backlog-2026-07`, thread 8.)

## Model
opus — match. Borderline: the edit itself is small and sonnet-shaped, but it must not weaken a guard added earlier the same day for an observed incident, and that judgment is the hard part.

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/run-manifest.sh` — the defect (`:156`, `:166-168`, `:171-173`) and the same-day identity guard (`:175-194`)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/run-manifest.test.sh` — 291 lines, `ck`/`ckv` idiom, PASS/FAIL counters; no midnight case
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/spine-schemas.md` — § 1, the manifest schema and its closed-outcome set
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-marker.md` — the marker contract (read-only; changing it is out of scope)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md` — Step 253 documents omitting both flags on purpose, which is what makes the bug reachable
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/missions/repo-health-backlog-2026-07.md` — thread 8 and the mission's non-negotiables

## Findings / Items to Address

1. **Reproduced by execution this session, not read off the file.** Sandbox at `scratchpad/midnight-01`: start-stub pinned to `2026-07-17`, then `close --outcome …` with no flags on `2026-07-18` → `EXIT=2`, `run-manifest.sh: could not resolve the session marker`. The stub `2026-07-17-S9-abc.json` remains on disk with `outcome=None` permanently. Exactly the failure thread 8 describes.
2. **The split-manifest half also reproduced.** `close --marker "S9-abc"` without `--date` → wrote a **second** manifest `2026-07-18-S9-abc.json` while `2026-07-17-S9-abc.json` stayed null-outcome. One session, two records, neither correct.
3. **Third symptom, not in thread 8: the error message names the wrong cause.** The `--marker`-only path prints *"no start-stub existed (session skipped mandate confirmation)"* — but a start-stub **did** exist, under yesterday's date. A wrong diagnosis printed confidently is how this stays invisible at 00:10 when nobody is reading closely.
4. **Root cause, three lines.** `:156` re-derives `DATE` from `date` at each invocation; `:166-168` accepts a marker line only if it is prefixed with that freshly-derived date; `:172` dies otherwise. Nothing carries the *session's own* start date forward.
5. **No midnight coverage in the test harness** — `grep -niE "midnight|cross-day|yesterday|date.*roll"` over `run-manifest.test.sh` returns nothing. Confirms thread 8.
6. **⚠ The hazard thread 8 does not name, and the reason this needs a gate.** `run-manifest.sh:175-194` carries a **session-identity cross-check added 2026-07-18 — earlier today** — for a live incident (S4-8c3): the shared `logs/.session-marker` can hold *another* session's marker at the same date, and `close` would silently overwrite that session's record. The naive fix here ("stop requiring the marker to be dated today") would re-open exactly that hole, and would do so against a guard whose ink is not dry. **Design constraint: the relaxed date match must be permitted only via the per-session-id marker `logs/.session-marker-$CLAUDE_CODE_SESSION_ID`, which by construction belongs to this session. The shared-file path keeps its today-only rule.**
7. **Out of scope by mandate:** the marker grammar and `docs/session-marker.md`. If the fix cannot be done without touching them, stop — that is thread-3/marker territory with its own gate.

## Execution Sequence

**Stage 0 — Plan-time gate.**
Run `/risk-check`. Justified, not stacked: the change edits automation that writes cross-session durable state, and it interacts with a safety guard added the same day (finding 6). Hand the reviewer the reproduction transcript and finding 6 as *given state* so it scores the design rather than rediscovering the bug (S7-bb5 telemetry).
*Verify:* verdict recorded. NO-GO, or a second RECONSIDER, halts per the mandate.

**Stage 1 — Write the failing test first.**
Add a midnight case to `run-manifest.test.sh` in the existing `ck`/`ckv` idiom, covering all three reproduced symptoms: no-flag close across midnight, `--marker`-only close across midnight, and the identity-guard case (a foreign same-dated shared marker must still be refused).
*Verify:* the new cases **FAIL** against the current script. A test that passes before the fix proves nothing — this is the mission's own lesson from thread 1, whose acceptance test was green both ways.

**Stage 2 — Fix the resolver.**
Carry the session's start date forward rather than re-deriving it: resolve `DATE` from the per-id marker's own date when that marker identifies this session, so `close` targets the stub `start` actually wrote. Preserve the today-only rule on the shared-file path per finding 6.
*Verify:* Stage 1's cases go **green**; the full existing 291-line suite still passes with zero regressions.

**Stage 3 — Correct the misleading message (finding 3).**
When a stub exists under a different date, say so. Do not report "no start-stub existed."
*Verify:* re-run the `--marker`-only sandbox case and read the emitted text.

**Stage 4 — Close the loop.**
Tick thread 8 via `/mission update` (the sanctioned path; hand-editing is forbidden by the mission contract). Flip the improvement-log entry citing the reproduction and what shipped. Commit. Do not push.
*Verify:* `/mission read` shows thread 8 checked; the log entry no longer reads open.

## Scope Alternatives

- **Min** — Stages 1–2 only: failing test, then resolver fix. Closes the defect; leaves the misleading message in place.
- **Recommended** — Stages 0–4. Adds the gate, the message correction, and the loop-closing the mission requires ("close the log entry when the fix lands" is a non-negotiable, not follow-up).
- **Max** — additionally audit the other `logs/scripts/` consumers of the marker oracle for the same re-derive-the-date pattern. Deferred: speculative until one is shown to have it, and the mission's honest-scoping rule (thread 10) says verify before fixing breadth.

## Autonomy Posture
Gated

**Stop points:**
- After Stage 0 — `/risk-check` verdict.
- If the fix cannot avoid touching the marker grammar or `docs/session-marker.md` — stop and surface; that is a different thread with a different gate.
- If Stage 1's tests pass before the fix — stop. It means the test does not exercise the defect, and shipping on it would repeat thread 1's non-discriminating-test failure.

## Risk

Run `/risk-check` after approval (plan-time gate). End-time gate is skippable per the standing rule **only if** plan-time covers it with mitigations applied and scope does not widen; document the skip in the wrap note if taken.

Structural class touched: **automation with shared-state effects** — `run-manifest.sh` writes cross-session durable records under `logs/runs/`. No permission surface, no hook registration, no new always-loaded content, no new component. Blast radius is bounded: the script has two callers (`/session-start` Step 3.5, `/prime` Step 8c.7.5) and both treat it as advisory — `principles.md § OP-5`, nothing reads the manifest yet, so a regression degrades telemetry rather than blocking work.

**The live risk is not breaking the script — it is quietly weakening the same-day identity guard at `:175-194`.** Finding 6 states the constraint that prevents it. `/blindspot-scan` is **not** run: this plan wires no new runnable infrastructure (no new command, skill, agent, hook, or symlink), so the narrow post-plan trigger does not fire and firing it anyway would be gate-stacking against the workspace's explicit rule.
