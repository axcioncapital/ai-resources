# Session Plan — 2026-08-01

## Intent
Resume Work Loop v2 pilot unit 3 from `logs/work-loop/foreign-staging-target-repo.md` and Git alone, settle the PreToolUse hook cwd question by execution, implement the smallest resolver in `.claude/hooks/check-foreign-staging.sh`, and record unit 3's outcome and its verdict on pilot conditions 3 and 7 in `plans/work-loop-v2-mvp/step-7-pilot-log.md`.

## Model
opus — match (active session model is Opus 5). The hard part is deciding: reading a defect's real mechanism, choosing the smallest correct resolver, and judging whether a harness assertion is genuine evidence or passes for the wrong reason.

## Source Material

**Primary — the handoff test's only permitted input, read FIRST and alone:**
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/work-loop/foreign-staging-target-repo.md`
- Git history (`git log`, `git show` on the three unit-3 commits: `f2f1992`, `2135c0c`, `94dcfda`)

**Secondary — opened only AFTER step 1 records its sufficiency verdict:**
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/check-foreign-staging.test.sh`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/check-foreign-staging.sh`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/step-7-pilot-log.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/work-loop-v2.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/qc-independence.md` (review sizing)

**Deliberately EXCLUDED from this session:**
- `logs/scratchpads/2026-08-01-21-30-scratchpad.md` — the prior session's continuity scratchpad. It exists and would help, and that is exactly why it must stay shut: unit 3's whole purpose is to prove a fresh session can finish from the state file and Git alone. Opening the scratchpad answers the pilot question by cheating on it. If the state file proves insufficient, the honest move is to record the gap as a **finding against the state-file schema**, then open the scratchpad and say so — not to open it quietly.

## Findings / Items to Address

1. **The defect under test** — `check-foreign-staging.sh` resolves a gated `git add` against the wrong repo when the command runs inside a nested project repo, producing a false BLOCK that widening the footprint cannot clear. Source: `logs/improvement-log.md` (promoted to `logs/next-up.md`, id `8c600934fdd0`).
2. **An unrecorded second failure mode** — the prior session found a *silent-pass* case the original defect entry does not mention. Source: state file `logs/work-loop/foreign-staging-target-repo.md`; pilot log § Unit 3. Confirm it from the state file, not from this line.
3. **FP-9 — two of six harness assertions (C2, C6) pass against a dead no-op hook**, proven with a stub swap. The named remedy is a positive-identity assertion on C2. Source: pilot log § Unit 3 § Friction points. A harness with an undisclosed blind spot is not evidence; this must be either fixed or restated as a disclosed limitation.
4. **Open blocking question — hook process cwd.** Whether a PreToolUse hook's process cwd equals the Bash tool's cwd or the project root is unsettled, and the resolver's correct shape depends on the answer. Source: prior session's `### Next Steps`, item 1. Must be settled **by execution**; inference here is what produced the defect.
5. **Pilot conditions 3 and 7 stand at PENDING**, deliberately — the prior session refused to verdict them because only the resuming session can prove the handoff worked. Source: pilot log § Unit 3. This session is that proof, and it must verdict them on observed evidence, not on having arrived.
6. **Condition 5 (Direct Work bypass) remains owed and is out of scope** — it waits for a genuinely small real fix. Source: mission `work-loop-v2-mvp` § Open threads. Do not manufacture a unit to force it.

## Execution Sequence

1. **Cold recovery from the state file alone.** Read `logs/work-loop/foreign-staging-target-repo.md` plus the three unit-3 commits. Write a short sufficiency verdict into the state file: could a session that had read nothing else resume from this? Name every gap found.
   *Verify:* a written verdict exists in the state file, naming gaps or explicitly stating none, before any secondary file is opened. This is condition 3's evidence and it cannot be produced retroactively.
   *Disclosed contamination:* `/prime` loaded the prior session's `session-notes.md` entry into this context at orientation, which includes a summary of unit 3. The handoff test is therefore **partially contaminated by design of the orientation path** — that is itself a finding about the pilot's method, and it must be recorded rather than glossed.

2. **Re-verify the premise by execution.** Run `logs/scripts/check-foreign-staging.test.sh` against the unmodified hook.
   *Verify:* the recorded 4 red / 2 green reproduces. If it comes back all-green, the mandate's second stop condition fires — hand back, do not build.

3. **Settle the hook-cwd question.** Determine by execution whether a PreToolUse hook's process cwd is the Bash tool's cwd or the project root. This needs a throwaway probe hook registered in `~/.claude/settings.json`. **STOP AND ASK THE OPERATOR FIRST.** If a non-config-mutating probe turns out to be possible, prefer it and skip the ask.
   *Verify:* an observed cwd value printed by a real hook invocation, quoted in the state file. An argument about what cwd "should" be does not satisfy this step.

4. **Implement the smallest resolver** in `.claude/hooks/check-foreign-staging.sh`, meeting Codex's four required behaviours, failing closed on any wide-`git add` shape it cannot parse.
   *Verify:* `logs/scripts/check-foreign-staging.test.sh` reports 6/6 green.

5. **Prove the harness can still fail.** Re-run against a dead-hook stub. Address FP-9's C2 blind spot — fix it with a positive-identity assertion, or record it as a disclosed limitation with the reason.
   *Verify:* the stub run reports failure, and the count of assertions that survive the stub is stated explicitly.

6. **Record the outcome.** Write unit 3's result and an evidenced verdict on pilot conditions 3 and 7 into `plans/work-loop-v2-mvp/step-7-pilot-log.md`; write the closing record into the state file.
   *Verify:* both files carry the verdict with evidence pointers, not assertions.

7. **Hand back to Codex.** Codex opened this unit, so Codex closes it — set the state file to `turn: codex` and give the operator the paste-ready prompt.
   *Verify:* state file at `turn: codex`, committed; prompt delivered in chat.

## Scope Alternatives

- **Min** — steps 1–2 only. Correct outcome if the premise fails to reproduce: record the disproof, hand back, stop. Also the correct outcome if the probe hook is declined and no other execution-based route to the cwd answer exists.
- **Recommended** — steps 1–7. The full unit, closed by Codex.
- **Max** — recommended, plus fixing FP-9's C2 positive-identity assertion properly rather than disclosing it as a limitation. Take this only if steps 1–6 land with context to spare; a rushed assertion is worse than a stated blind spot.

## Autonomy Posture
**Gated** — one named stop point, everything else runs through.

**Stop points:**
- **Before touching `~/.claude/settings.json`** to register the throwaway probe hook (step 3). This is a harness-config change — a named pause trigger in workspace `CLAUDE.md` § Autonomy Rules. Ask, and state what will be added and how it will be removed.
- If the harness comes back green against the unmodified hook (step 2) — the defect is gone; hand back rather than build.

## Risk
Structural change class touched — this work is high-consequence, so its one independent review is briefed **risk-aware** (`ai-resources/docs/qc-independence.md` § Risk-aware review). No separate gate runs.

Classes named, not adjudicated here:
- **Hook edit.** `check-foreign-staging.sh` gates every commit in this repo. A resolver that is wrong in the fail-open direction removes the guard silently for every future session; wrong in the fail-closed direction blocks commits nobody can clear.
- **Harness-config change.** A temporary registration in `~/.claude/settings.json` is a user-level settings mutation. It must be removed at the end of step 3, and its removal verified by reading the file back — not assumed.
- **Reviewer is Codex**, per the Work Loop v2 role split and the mission's non-negotiables. No Claude-side QC pass runs in addition.

Environment-fit check: not applicable — the work product is a hook and a test script, both invoked by the harness rather than by an operator-typed launch.
