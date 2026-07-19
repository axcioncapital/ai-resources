# Session Plan — 2026-07-18

## Intent
Fix `/mission check` to read the validation contract before ticking and add the missing `update` verb, then verify-and-tick the threads that fix unblocks, then make `/permission-sweep` evaluate the merged layer stack.

## Model
opus — match (session is `claude-opus-4-8[1m]`). The hard part is *deciding*: refuse-or-warn semantics must be designed so `check` stops producing false ticks **without** becoming the new gate this mission's non-negotiable at `:63` forbids. The `update` verb is a new write capability on a file the design contract calls frozen — also judgment, not execution.

## Verified facts (established by execution this session — carry these forward; do not re-derive)

| Fact | Instrument that produced it |
|---|---|
| `/mission check` never opens `## Validation contract`; item 20 says "Change nothing else" | `grep -n "Validation contract" .claude/commands/mission.md` — hits at `:3,8,12,39,42,54,71,72`, none inside Step 5 (`check`, items 17–21) |
| Dispatch accepts `create\|list\|read\|check\|close` — no `update` | `mission.md:27`, `:4` argument-hint |
| `mission.md` is a real file **only** in ai-resources; 18 symlink consumers, **zero drift copies** | `find … -name mission.md -path "*/commands/*"` + `[ -L ]` per hit |
| `permission-sweep-auditor.md` likewise real-once, 25 symlink consumers, zero drift copies | same method |
| `permission-sweep-auditor.md:67` is per-file (`"For each file, apply the detection rulebook"`); `defaultMode` appears once at `:147`, as a report field only | `grep -n "For each file\|defaultMode\|merged\|effective" .claude/agents/permission-sweep-auditor.md` |
| Rules 5/6 are pure allow-array predicates, no merge, no `defaultMode` | `sed -n '380,400p' docs/permission-template.md` |
| The CRITICAL it emitted was false **twice over** — parent grants `Bash(*)` at `settings.json:4` AND sets `bypassPermissions` at `:32`; local sets it again at `:9` | `grep -n "bypassPermissions\|\"Bash(\*)\"" .claude/settings.json .claude/settings.local.json` |
| **Thread 13's work is already complete** — all five entries flipped with cited evidence in `d03971e` | `git show --stat d03971e` + `grep -nE "^- \*\*Status:\*\* \*\*RESOLVED" logs/improvement-log.md` → hits at `:775, :796, :844, :883, :972` |
| Mission state: 11 unchecked / 5 checked of 16 threads | `grep -cE "^- \[[ x]\] \*\*[0-9]+\." logs/missions/repo-health-backlog-2026-07.md` |

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/mission.md` (86 lines — the edit target)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/missions/repo-health-backlog-2026-07.md` (the contract `check` must learn to read)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md` (thread 13 verification target)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/2026-07-18-verified-backlog-triage.md` (evidence trail all five flipped entries cite)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/permission-sweep-auditor.md` (thread 5 edit target)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/permission-template.md` (Rules 5/6, lines ~380–400)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` (structural change classes)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-marker.md` (marker contract, for any writer-contract wording)

## Findings / Items to Address

1. **Thread 12a — `check` ticks blind.** `mission.md` Step 5 (items 17–21) matches a substring against `## Open threads`, flips `- [ ]` → `- [x]`, and item 20 explicitly forbids touching anything else. The `## Validation contract` is never opened. *Live proof inside this mission:* threads 1 and 2 are `[x]` while the acceptance assertion they exist to satisfy — *"the `/prime` Step 3 scan returns under 40 lines"* (`:54`) — measures 222. Source: mission thread 12.
2. **Thread 12b — no `update` verb.** `mission.md:4,27` expose five verbs; revising a thread list therefore requires the hand-edit `:12` forbids. Done twice already (this mission's S10-163 repopulation; `research-workflow-deploy-fitness` S10). Source: mission thread 12 "sibling defect".
3. **Thread 13 — already satisfied, needs verification + tick, not work.** `d03971e` flipped all five entries (`:775, :796, :844, :883, :972`) each citing a commit or `file:line`. Blocked from ticking only by item 1. Source: mission thread 13 + this session's execution check.
4. **Thread 11 — already satisfied, needs tick.** Work shipped in `028c15a`; S11-637 deliberately left it unticked pending thread 12. Source: mission thread 11 closing note.
5. **Thread 5 — `/permission-sweep` judges files in isolation.** `permission-sweep-auditor.md:67` iterates per-file; Rules 5/6 (`permission-template.md:388,392`) are allow-array predicates that never consult the merged stack or `defaultMode`. It emitted a false CRITICAL that reached the 2026-07-17 friday-checkup as an actionable HIGH. Source: mission thread 5.
6. **Second-order payoff on item 5, not in the thread:** `audits/friday-plans/2026-07-17-permissions.md` item 1 rests on that same false CRITICAL. Fixing the auditor defuses a queued bad fix before it ships. Source: improvement-log 2026-07-14 entry, "⚠ that plan's item 1 rests on a false CRITICAL".

## Execution Sequence

1. **Design thread 12's semantics, then `/risk-check`.** Decide refuse-or-warn shape for `check` and the write contract for `update`. Constraint: must not become a gate (mission non-negotiable `:63`). *Verify:* design stated in one paragraph naming which acceptance assertion a given thread maps to and what happens when the mapping is absent. Then run `/risk-check` — new write capability on a frozen-contract file, 18 symlink consumers. **Stop point: RECONSIDER or NO-GO halts here.**
2. **Edit `mission.md`.** Add contract-reading to Step 5; add the `update` verb. *Verify:* `command grep -n "Validation contract" mission.md` shows a hit inside Step 5; `mission.md:27` dispatch lists `update`.
3. **Prove the fix by execution against this mission's own live contradiction.** Attempt `check` on a thread whose assertion is unmet. *Verify:* it refuses-or-warns. Pre-change it would have flipped silently — the check must FAIL before the fix and PASS after, or it proves nothing (S11-637's canary lesson).
4. **Verify thread 13's five flips independently, then tick 11, 12, 13 via the new path.** *Verify:* each of `:775, :796, :844, :883, :972` carries a citation that resolves; ticks land through `/mission check`, not a hand-edit.
5. **Thread 5 — merged-layer evaluation.** Edit `permission-sweep-auditor.md` to compute effective permissions across the layer stack before Rules 5/6 fire; restate Rules 5/6 in `permission-template.md` as merged-effective predicates. *Verify:* re-run the rule against `ai-resources/.claude/settings.local.json` — the previously-emitted CRITICAL must no longer fire, and a genuine gap must still fire (test both directions).
6. **Commit; end-time `/risk-check` per the skip test.** State the skip test explicitly before dispatching rather than after.

## Scope Alternatives

- **Min** — thread 12 only (items 1–3). Lands the unblocker; leaves four threads tickable-but-unticked.
- **Recommended** — items 1–6. Closes threads 11, 12, 13 and 5; four of eleven open threads. Chosen: thread 13's collapse from "work" to "verify" freed the context that makes thread 5 affordable in the same session.
- **Max** — add thread 16(a) (`check-destructive-liveness.sh:207` accepts an override flag that never binds to the destructive verb — cheap, stops accepting inert overrides). Take only if items 1–6 land with clear context remaining; do **not** start it late.

## Autonomy Posture
Gated

**Stop points:**
- After step 1's `/risk-check` — RECONSIDER or NO-GO halts the session; mandate and plan stay on disk.
- Before the `logs/improvement-log.md` read-modify-write in step 4 — three foreign sessions are live in this checkout and that file takes in-place edits, not atomic appends. Re-check `git status --short -- logs/improvement-log.md` immediately before touching it.
- If thread 5's two-direction test cannot be made to fail pre-fix, stop and redesign the test — a check that passes both ways is worthless.

## Risk
Run `/risk-check` after the plan is approved (plan-time gate). Run it again before commit (end-time gate).

**Classes touched:** (a) new verb = new write capability on a mission file, which `/prime` Step 1d and `/drift-check` both read — automation with shared-state effects; (b) `mission.md` and `permission-sweep-auditor.md` each reach 18 and 25 consumers by symlink. **Tripwire check:** step 2 changes *what `check` writes and when it declines to write* against a cross-session artifact — the "existing-command refactor" framing does not exempt it.

**Mitigating fact, verified not assumed:** both targets have zero drift copies — every consumer is a symlink to the single real file. No lockstep multi-file edit is required, unlike the `session-plan.md` case in S7-bb5.

**Environment-fit:** not applicable — no executable or launcher is produced.

**Standing hazard from this mission's own record:** two consecutive sessions found a thread's filed premise wrong or already-satisfied. Thread 5's premise was verified this session; thread 12's was too. Do **not** extend to thread 16(a) without verifying its premise by execution first.
