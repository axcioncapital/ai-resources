# Session Plan — 2026-08-01

## Intent
Make the Work Loop v2 v1-retirement decision (the hard boundary at pilot start), then open the Phase 3 pilot — start the pilot log and run the first genuine CRM or Email OS work unit through the MVP.

## Model
opus — match (active session model is Opus 5). The hard part is deciding, not doing: a retirement
call on a live system, plus judgment on whether a pilot observation is material obstruction or a
reopening trigger.

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/work-loop-v2-mvp-proposal-v0.4.md` — authority. Decision 4 (retirement at pilot start), § Phase 3 (pilot conduct), § pilot presumption.
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/step-6-candidate-review.md` — § 8.5, the six disclosed limitations the pilot carries.
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/README.md` — authority order; decisions taken after v0.4.
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` — the rules both runtime artifacts link to.
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/work-loop-v2.md` — the MVP under pilot (Claude side).
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.agents/skills/work-loop-v2/SKILL.md` — the MVP under pilot (Codex side).
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/work-loop.md` — v1 runtime contract; retirement target.
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/work-loop-spec.md` — v1 spec; retirement target.
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/work-loop.md` — v1 command; retirement target.
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.agents/skills/work-loop/SKILL.md` — v1 Codex resource; retirement target.
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/missions/work-loop-v2-mvp.md` — validation contract, Step 7 threads.
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` — structural change classes.
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/qc-independence.md` — review sizing.

## Findings / Items to Address

Six disclosed limitations the pilot inherits (`step-6-candidate-review.md` § 8.5). Each is already
accepted for pilot quality — the job here is to watch for them, not to fix them.

1. **Folder creation from a genuinely absent `logs/work-loop/` is untested** — the folder existed through all three slices, so the case was unconstructible. Bites only on a fresh checkout. (§ 8.5 item 1)
2. **Most opening briefs were hand-written fixtures** — Codex genuinely opening a unit is proven in Slice 1 and the Step 6 admission run only. **Pilot unit 1 should be opened by Codex for real**, which retires this. (§ 8.5 item 2)
3. **Slice 2's menu task's first pass and assessment block are fixture material** — its correction hand-back and closure are real. (§ 8.5 item 3)
4. **The writing standard's internal tension is unresolved** — "never restate the core" vs. requiring stop conditions to name their on-stop behaviour. *Reopening trigger: pilot use shows the boundary is unclear or causes drift.* (§ 8.5 item 4)
5. **Core § 6 rule 2 contradicts core § 7 for the file-identity case** — rule 2 says report and change nothing; § 7 says write the question into the state file and commit. The command resolves it toward changing nothing. *Reopening trigger: a pilot unit where the ambiguity produces a wrong action, or the first core revision for any reason.* (§ 8.5 item 5)
6. **Behavioural evidence is largely historical** — most harness assertions read outcomes from git history rather than re-running the prompts. *Reopening trigger: the pilot is the real test.* (§ 8.5 item 6)

Governing constraints for this session:

7. **Decision 4 — v1 retirement is decided at pilot start, no later** (`work-loop-v2-mvp-proposal-v0.4.md:38`). The choice is archive-immediately vs. archive-after-pilot-success. Two active Work Loop systems must not drift indefinitely. This is a hard boundary and does not slip past pilot start.
8. **The pilot presumption is no change** (`work-loop-v2-mvp-proposal-v0.4.md:100`). A pilot observation enters MVP scope only if it *materially obstructed useful operation*. Everything else becomes a reopening trigger or an accepted limitation. This rule is what makes the loop learn through use rather than speculation.
9. **Phase 3 requires genuine work units** (`work-loop-v2-mvp-proposal-v0.4.md:96`). Two or three real CRM and Email OS units, operator giving objectives and judging usefulness. A manufactured unit tests nothing.
10. **One queued medium finding is a live pilot input** — the Codex side currently needs the operator to paste a prompt naming the task id; the resource could resolve the open task itself. Logged S7-3fc; its named pickup window is the Step 6 review or this pilot.

## Execution Sequence

1. **Read the six limitations and Decision 4 in full.** Verify: § 8.5 and Proposal `:38`/`:96`/`:100` read directly, not from this plan's summaries. *This plan's summaries are a working index, not the source.*
2. **Draft the v1 retirement decision.** Establish by inspection what v1 actually still consists of and what depends on it (`docs/work-loop.md`, `docs/work-loop-spec.md`, `.claude/commands/work-loop.md`, `.agents/skills/work-loop/SKILL.md`, plus any live `logs/loop/` state and any consumer referencing them). Verify: every named dependant is confirmed by grep, not recalled. Present the two options with a recommendation.
3. **[STOP POINT] Operator settles the retirement decision.** Verify: the choice is stated by the operator, not inferred. Write `plans/work-loop-v2-mvp/step-7-v1-retirement-decision.md` recording the decision, its basis and what executing it will involve in Step 8. Record in `logs/decisions.md`. Commit.
4. **Open the pilot log.** Write `plans/work-loop-v2-mvp/step-7-pilot-log.md` with the seven things Phase 3 tests (`:98` — useful context preparation, alignment with the approved project plan, state recovery, one bounded correction, the Direct Work bypass, operator intervention, clean fresh-session continuation) as standing columns, plus a section per unit. Verify: the file exists and names all seven.
5. **[STOP POINT] Operator picks pilot unit 1** — a genuine unit from `projects/axcion-crm` or `projects/axcion-systems-builder-email-os`, and states its objective as operator. Verify: the unit is real work the operator wanted done anyway. If none is available, this is the mandate's first `stop_if`.
6. **Run unit 1 through the MVP.** Prefer Codex opening the unit for real (retires limitation 2). Verify: a task-state file exists at `logs/work-loop/{task-id}.md`; the unit reached a closing record; every friction point is written into the pilot log as it happens, not reconstructed after.
7. **Classify each pilot observation** against constraint 8 — material obstruction (enters scope) vs. reopening trigger vs. accepted limitation. Verify: each observation carries an explicit classification and its reason. Do not fix anything in-session that is not material obstruction.
8. **Tick the mission's Step 7 threads to what actually closed, with evidence.** Verify: the frozen contract prefix is byte-identical before and after; the retirement thread and the pilot thread are ticked separately and only as far as evidence supports. Units 2–3 and the handoff remain open.

## Scope Alternatives

- **Min** — steps 1–4 only: settle and record the retirement decision, open the pilot log. Closes the hard boundary; pilot deferred. Take this if the retirement decision proves contested or if no genuine unit is available.
- **Recommended** — steps 1–8: retirement decision plus pilot unit 1 run end-to-end and classified.
- **Max** — recommended plus a second pilot unit, if unit 1 runs clean and context allows. The mid-task session-handoff test is **not** available at any scope: it requires a session boundary by construction.

## Autonomy Posture

Gated.

**Stop points:**
- Before writing the retirement decision — the choice between archive-now and archive-after-pilot-success is the operator's, per Decision 4. I bring the dependency inspection and a recommendation.
- Before running pilot unit 1 — the operator names the unit and its objective. Phase 3 makes them the operator of the loop; I cannot invent the work.
- If a pilot observation looks like material obstruction — surface it before pulling anything into MVP scope, since that is the one judgment the pilot presumption exists to constrain.
- Before any edit to a v1 artifact. This session **decides** the retirement; Step 8 **executes** it. An edit to `docs/work-loop.md` or `.claude/commands/work-loop.md` this session would be out of mandate.

## Risk

Structural change classes touched: **a live command's retirement** (`/work-loop` and its Codex resource), **shared-state log surfaces** (`logs/work-loop/` gains a real, non-fixture unit; `logs/loop/` is v1's live surface), and **a real project mutated by the pilot unit** in `projects/axcion-crm` or `projects/axcion-systems-builder-email-os`. This work is high-consequence, so its one independent review is briefed **risk-aware** (`ai-resources/docs/qc-independence.md` § Risk-aware review). No separate gate runs.

Two specific hazards, named for the reviewer rather than adjudicated here:

- **v1 is still live.** `docs/work-loop.md` globs `logs/loop/{STREAM}-*` in its own reconciliation (the reason v2 state files were placed at `logs/work-loop/` in Step 3). A retirement executed carelessly in Step 8 could orphan live v1 state. This session only decides; the decision doc must name what Step 8 has to check.
- **The pilot writes into a real project.** Unit 1 is genuine work, so its changes are real changes with real blast radius, governed by that project's own rules — not by this mission's. The Work Loop must not layer a second review or state system over a specialist workflow the unit invokes (`work-loop-v2-mvp-proposal-v0.4.md:107`).

No environment-fit check applies — the work products are documents and a task-state file, not launch-gated tooling.
