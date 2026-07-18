# Friday Act Plan — 2026-07-17 — deploy-gate-decision

**Source report:** friday-checkup-2026-07-17.md (weekly tier, recovery run)
**Journal report:** (none — freshest is 2026-05-29, outside the 7-day window)
**Generated:** 2026-07-17
**Items:** 1

> **Cluster 2 (System Owner triage). The one decision worth making this week.**
> The research-workflow deploy-gate premise ("fix canonical before deploying") has been proven wrong
> on 3 consecutive mission threads (threads 1, 2, 5 — each classified a blocker by the same audit
> reasoning, each falsified by execution). This is the `/coach` "One Thing" and the mission's own
> S13-raised open question. AP-9 / AP-11: the premise IS the defect — decide it before opening thread 3.
> Safe to run now (a decision touching the mission-contract file only; **not** DR-10-blocked).

## Items

### 1. [med] Decide the research-workflow deploy-gate before opening mission thread 3
- **Source:** checkup
- **Risk-check required:** no
  - (A decision. Any canonical workflow/command edits it *authorizes* carry their own `/risk-check` at that time — the decision itself is not a structural change class.)
- **W2.4 auto-draft:** no
- **Mission:** research-workflow-deploy-fitness (`logs/missions/research-workflow-deploy-fitness.md`) — bind this session to the mission at `/prime`/`/session-start` so `/drift-check` measures against the validation contract.
- Detail: the mission now has **ZERO demonstrated deployment blockers** (threads 1, 2, 5 all falsified by execution; S13 correction in the mission file). Decide explicitly: **(a)** deploy the Sector Intelligence pilot now against the current canonical template and complete threads 3/4/6/7/8 as post-deployment improvements, or **(b)** keep the "fix canonical before deploying" sequence and name *which specific thread* is the real gate (with executed evidence, not audit reasoning). Record the decision in `logs/decisions.md` and update the mission's `## Open threads` "At deployment" section. This unblocks the whole mission — do not open thread 3 until this is settled.

## Execution notes
- Commit the decision record separately (workspace commit-behavior rules).
- This item produces a **decision + records**, not a code change — the friday-act output contract (plan-only) is satisfied by making the decision in the follow-up session and recording it; any code the decision authorizes is separate, risk-checked work.
- Run `/wrap-session` when done.
