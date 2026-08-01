# Session Plan — 2026-08-01

## Intent
Run pilot unit 3 of the Work Loop v2 MVP (Step 7) as a deliberate mid-task session-handoff test — Codex opens the unit, Claude checks its premises and implements partway, then this session stops so a fresh session finishes from the state file and Git alone.

## Model
opus — match (session is running Opus 5). The work is judgment-heavy: checking premises by execution, judging what falls inside Codex's stated objective, and deciding where a genuine mid-task boundary lies.

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` — the loop's governing rules (§ 2 admission, § 3 unit cycle, § 4 state file, § 6 safety, § 7 stop-and-ask)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/step-7-pilot-log.md` — pilot conditions table, limitations, standing constraints, § Unit 3 (status: not opened)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/work-loop-v2.md` — Claude's half (Admission, Steps 1–6, de-escalation, correction rounds)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.agents/skills/work-loop-v2/SKILL.md` — Codex's half
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/check-foreign-staging.sh` — the candidate unit's target (canonical copy)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.codex/hooks/check-foreign-staging.sh` — the divergent fork awaiting a fix/delete/park decision
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/work-loop-v2-slice-1.test.sh` — the 136-assertion acceptance harness (regression check)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md:1548-1588` — the candidate defect and its second-gate outcome
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/qc-independence.md` — review sizing
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` — structural change classes
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/missions/work-loop-v2-mvp.md` — mission contract

## Findings / Items to Address

1. **Three pilot conditions are still untested and unit 3 is the last chance to exercise them** — condition 3 (state recovery), 5 (Direct Work bypass), 7 (clean fresh-session continuation). Both prior units ran start-to-finish in one session and both were admitted to the loop. Source: `step-7-pilot-log.md:37-50` (conditions table, all three marked **owed**).

2. **The candidate defect is real and already designed — do not redesign it.** `check-foreign-staging.sh` resolves a gated `git add` against the workspace-root repo when the command runs inside a nested project repo, producing a false BLOCK on six workspace-root paths the command could never stage. Source: `improvement-log.md:1548-1576`.

3. **The buildable path is named, and the entry's own Proposal is partly dangerous.** The Proposal's closing sentence — *"prefer the soft warn over the hard block"* — was rejected by both gates: it risks reopening the fail-open that `979ed01` closed on this same file. The named path instead generalizes the existing `cd X && <verb>` parsing at `check-foreign-staging.sh:521-526` to resolve the repo toplevel, with **any unparseable shape failing closed**. Source: `improvement-log.md:1578-1588` (§ SECOND GATE OUTCOME).

4. **Two facts in that backlog entry are stale — verify before building on them.** (a) Its "re-run `/risk-check`" instruction points at a command retired 2026-07-30; under the current rule this is a high-consequence change taking one risk-aware Codex review, which the loop's own closure check already provides. (b) Its `.codex/` fork measurement (464 lines vs 668 canonical) was taken 2026-07-19 and is six weeks old. Re-measure, do not quote.

5. **The unit-2 session deliberately rejected this candidate, and its reason still stands.** `check-foreign-staging.sh` gates every commit in this repo, and this session commits through it. A broken edit could block the very commit that preserves the handoff state — the one artifact this session exists to produce. Source: `session-notes.md` S11 § Decisions Made. Mitigated by sequencing (item 5 below), not by ignoring it.

6. **Condition 5 needs its own small request — the unit cannot carry it.** The Direct Work bypass fires only when a request is *refused* admission (`work-loop-v2-executable-core-v0.1.md:40-51`). The tokenizer defect is not small and reversible, so it will be admitted. A separate small request must be routed to exercise this row.

7. **Codex opens the unit; Claude cannot.** Opening is Codex's role (`core § 1`), and Codex cannot write `.git`, so Claude commits what Codex writes. This session's first output is therefore a prompt for the operator to run, not a file.

## Execution Sequence

1. **Verify the premise before Codex opens.** Reproduce the nested-repo false BLOCK by execution. Re-measure the `.codex/` fork's real divergence.
   *Verify:* the defect reproduces and is recorded, or is disproven and handed back rather than built on. Fork line counts re-derived, not quoted.

2. **Hand the operator the Codex opening prompt.** Name the objective and the repo. Do **not** tell Codex where to write the state file — routing must come from the resource, per the Slice 1 precedent.
   *Verify:* prompt delivered in chat; no path hint in it.

3. **Receive Codex's opening brief and commit it.**
   *Verify:* `logs/work-loop/<task-id>.md` exists on disk with `turn:` pointing at Claude; Claude commits it; `git log --diff-filter=A` confirms Codex authored the content and ran no git command.

4. **Check premises against Codex's brief, record them in the state file.**
   *Verify:* every load-bearing claim checked by execution, not recall. A false claim triggers the command's Step 3 hand-back and stops the unit — it does not get worked around.

5. **Commit the state file, then implement partway.** Sequencing is load-bearing: the state file lands **before** the first edit to `check-foreign-staging.sh`, so a broken hook cannot trap the handoff. Write fixture (iii) red first — it must prove both directions (a parsed compound `cd` resolves without a false block; a deliberately unparseable form fails closed).
   *Verify:* fixture shown failing before the fix; state file already committed at the moment the hook is first edited; the 136-assertion harness still green.

6. **Stop deliberately, mid-unit.**
   *Verify:* the state file's `## Next action` and `turn:` are specific enough that a fresh session can resume from it and Git alone — tested by reading it as if with no memory of this session. `step-7-pilot-log.md` § Unit 3 updated with status and condition verdicts. Nothing the handoff needs is left uncommitted.

7. **Exercise condition 5 with a separate small request.** Route one genuinely small, reversible request at `/work-loop-v2` and confirm it is refused admission and done as Direct Work.
   *Verify:* no state file is created for it (`core:136` — a refused request opens no file).

## Scope Alternatives

- **Min** — steps 1–4 and 6: Codex opens, Claude checks premises, stops right after the premise check. Conditions 3 and 7 still get exercised, because the handoff is real; condition 5 runs separately via step 7.
- **Recommended** — min plus step 5 (a partial implementation with one red fixture). A handoff mid-*implementation* is a truer test of state recovery than a handoff mid-*premise-check*, because there is real partial work to describe.
- **Max** — recommended plus step 7 and a decision on the `.codex/` fork's fate. The fork decision belongs to Codex's objective-setting, so it is only in scope if Codex puts it there.

## Autonomy Posture
Gated.

**Stop points:**
- **Before step 2 → 3:** hard dependency, not a choice. Codex must be run by the operator; Claude cannot open the unit. If Codex cannot be driven this session, record it and stop — do not have Claude stand in for it (the mandate's `stop_if`).
- **Before the first edit to `check-foreign-staging.sh` (step 5):** confirm the state file is committed first. This is the mitigation for finding 5 and the reason unit 2 rejected this candidate.
- **At the deliberate stop (step 6):** Claude proposes where the boundary falls and shows what a fresh session would read; the operator confirms it is a genuine mid-task point rather than a tidy finish.

## Risk
Structural change class touched — hook edits and automation with shared-state effects (`check-foreign-staging.sh` gates every commit in this checkout). This work is high-consequence, so its one independent review is briefed **risk-aware** (`docs/qc-independence.md` § Risk-aware review). No separate gate runs. In this build that review is Codex's closure check on the unit, which the mission's non-negotiables already designate as the only permitted review layer — do not add a second.

Named hazard specific to this session's shape: the artifact under edit is the guard that gates the commit preserving the handoff state. Sequencing (state file committed before the hook is touched) is the mitigation, and it is a stop point above rather than a note.

Stale-instruction hazard: the backlog entry tells the next session to re-run `/risk-check`, a command retired 2026-07-30. Do not attempt it and do not invent a stand-in.
