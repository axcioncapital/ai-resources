# Session Plan — 2026-07-19

## Intent
Re-gate thread 12's closed-set `--assertion` redesign via `/risk-check`, and if cleared, make `/mission check` read the validation contract before ticking and add the `update` verb, then tick threads 5, 11 and 13.

## Model
opus (deciding — design adjudication under a standing RECONSIDER, three unresolved architectural questions) — match

## Verified facts — carried forward with the instrument that produced each

> Per the 2026-07-18 S12-3cd telemetry recommendation: facts established by execution must reach every
> downstream artifact and brief, or they get re-derived at cost. Each line is `fact → instrument`.

1. **3 active mission contracts, not 5** → `git ls-files logs/missions templates/mission-contract.md`:
   `promote-rw-canonical.md`, `repo-health-backlog-2026-07.md`, `research-workflow-deploy-fitness.md`
   active; 3 more under `archive/`; 1 stray non-contract (`settings-path-portability/patrik-heads-up.md`).
   **The redesign's open question (c) cites "5 mission files + template" — that scope is not reproducible
   against the current tree.** Correct migration surface is **3 active + template = 4 files**, and
   possibly 2 + template (see fact 2). This makes the schema-field alternative materially cheaper than
   the redesign assumed, which is a direct input to (c).
2. **`promote-rw-canonical.md` exists in BOTH the active dir and `archive/`** → same `git ls-files` output.
   This is the likely explanation for its missing `status:` line (the "unhandled edge case" of
   `improvement-log.md:60`): an un-deleted copy of an already-archived mission, not a schema gap.
   **To be confirmed by diff, not assumed.**
3. **Thread 12's assertion IS inferable, even though undeclared** → `repo-health-backlog-2026-07.md:58`,
   acceptance assertion 5: *"A mission thread can be ticked off through a sanctioned path that does not
   require a hand-edit the mission contract forbids."* The redesign's statement that no thread declares
   an assertion is true as written (no declared *field*), but the mapping is derivable by a reader. This
   is a direct input to question (b).
4. **The live contradiction that will serve as the execution test still holds** → threads 1 and 2 sit
   `- [x]` (`:78-79`) while acceptance assertion 1 (`:54`, "Step 3 scan returns under 40 lines") is
   unmet — this session's own `/prime` Step 3 scan returned ~51.7 KB of output.
5. **Consumer inventory — do NOT re-derive** → carried from S12-3cd scratchpad, method `find` + `[ -L ]`:
   `mission.md` is carried by 19 paths (18 symlinks, 1 real, zero drift copies).
6. **RECONSIDER stands unchallenged** → `audits/risk-checks/2026-07-18-mission-check-evidence-citation-and-update-verb.md`;
   the re-score agent stalled at 600s and wrote no verdict (report mtime + `## Verdict` grep, S12-3cd).

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/mission.md` (86 lines — Step 5 `check`, target of the fix)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md` (lines 40–63 — the carried redesign, commit `64edc8a`)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/missions/repo-health-backlog-2026-07.md` (lines 49–69 validation contract; `## Open threads`)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/risk-checks/2026-07-18-mission-check-evidence-citation-and-update-verb.md` (the standing RECONSIDER)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scratchpads/2026-07-19-00-30-scratchpad.md` (carried state)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/templates/mission-contract.md` (only if (c) resolves toward migration)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` (risk-check change classes)

## Findings / Items to Address

1. **`check` never reads the validation contract** — `mission.md:66` reads only `## Open threads`, flips
   the checkbox, and per `:71` changes "nothing else". It has already produced a false tick in this very
   mission (threads 1 and 2 ticked against an unmet assertion). *Source: thread 12, mission file `:140`.*
2. **No `update` verb exists** — `mission.md:4` exposes `create|list|read|check|close`, while `:12` forbids
   hand-editing `## Open threads`. Revising a thread list is therefore unsanctioned, and has been done by
   hand twice. **Already cleared by the prior gate** as "well-justified and not the concern."
   *Source: `improvement-log.md:46`.*
3. **The filed remedy is unimplementable as written** — it says "refuse-or-warn when *the named assertion*
   is unmet"; no thread declares an assertion. Problem reality scored Low. Build from the redesign, not
   the thread text. *Source: `improvement-log.md:50`.*
4. **The rejected design must not be re-proposed** — `check --evidence` was presence-only (never re-ran
   the command, never re-opened the `file:line`), making it "another checklist", forbidden by this
   mission's non-negotiable at `:63`. *Source: `improvement-log.md:48`.*
5. **Three open questions the stalled re-score never answered** — (a) does closed-set `--assertion` escape
   the checklist finding, or is `none` an escape hatch every ticker takes? (b) is tick-time mapping a real
   substitute for a declared schema field, or does it relocate the same unverified claim? (c) is the
   schema-field migration the honest fix being avoided? *Source: `improvement-log.md:58`.*
6. **Status-less mission edge case** — `promote-rw-canonical.md` has no `status:` line; invisible to
   `/mission list` (`:48` filters `status: active`) and `/prime` Step 1d. Neither current verbs nor the
   redesign define behaviour against it. *Source: `improvement-log.md:60`.* See verified fact 2 — the
   likely resolution is deletion of a duplicate, not a schema change.
7. **Declared residual to carry, not hide** — `check` will still not execute the cited evidence command
   (arbitrary-argv hazard; and per S11-637 a child process does not inherit the session's shell
   shadowing, so an executed check can report clean against a blind shell). *Source: `improvement-log.md:57`.*

## Execution Sequence

1. **Confirm the `promote-rw-canonical` duplicate** — diff the active copy against `archive/`. *Verify:*
   diff output; if identical or a strict subset, the edge case resolves by deleting the active copy and
   question (c)'s surface drops to 2 active + template. If they differ materially, it is a real
   status-less mission and must be decided explicitly. **This runs first because it changes (c)'s scope.**
2. **Compose the `/risk-check` brief** — carry verified facts 1–6 into the brief so the reviewer scores
   the design rather than rebuilding the inventory (S7-bb5's recommendation, applied in S12-3cd for a
   measured 42 → 18 tool-use drop). State the three open questions as the questions to answer, and hand
   over the corrected (c) scope. *Verify:* brief contains the consumer count and the corrected file count,
   neither re-derived by the reviewer.
3. **Run `/risk-check`** on the closed-set `--assertion` design plus the `update` verb. *Verify:* a written
   verdict on disk with an explicit answer to (a), (b) and (c). **A stall is not a verdict** — if the agent
   returns nothing, treat it as nothing and stop (this exact failure ended S12-3cd).
4. **Branch on the verdict.**
   - **RECONSIDER / NO-GO** → stop. Build nothing. Record the verdict, update the `improvement-log.md`
     entry with what the gate settled, leave threads unticked. *Verify:* no edit to `mission.md`.
   - **GO / PROCEED-WITH-CAUTION** → continue to step 5, applying every stated mitigation.
5. **Implement `check`** — parse `## Validation contract` separately from `## Open threads` (they both use
   `- [ ]`, so a whole-file scan collides — `improvement-log.md:53`); enumerate assertions 1..N; require
   `--assertion <N|none>`; `none` requires `--why`; record the mapping + evidence under the ticked thread.
   *Verify by execution:* running `check` against this mission's live contradiction (thread 1 vs unmet
   assertion 1) must refuse-or-warn. **Declare the expected result before running** — S12-3cd's harness
   returned a false PASS because BSD `sed` lacks `\|` alternation and the check silently never matched.
6. **Implement `update`** — revises a thread list without a hand-edit, with the frozen-section
   byte-identity guard the prior gate cleared. *Verify by execution:* an `update` run changes
   `## Open threads` and leaves Goal / scope / Validation contract byte-identical.
7. **Tick threads 5, 11, 13, and 12** through the new sanctioned path. *Verify:* four `- [x]` flips, each
   with its recorded assertion mapping; `/prime` Step 1d no longer offers them.
8. **Close the log entry** — flip `improvement-log.md`'s carried-redesign entry, citing the gate report.
   Per the mission's non-negotiable at `:66`, flipping the entry is part of the fix, not follow-up.

## Scope Alternatives

- **Min** — ship the `update` verb alone (already gate-cleared) and tick the threads by hand-free path;
  defer the `check` redesign entirely. *Rejected as the default:* thread 12 says "fix both together", and
  ticking through an unfixed `check` is the behaviour the mission exists to end.
- **Recommended** — re-gate the closed-set `--assertion` design; on clearance build both verbs and tick.
  Bounded by the gate, and the gate is the point.
- **Max** — the schema-field migration: add a declared `serves-assertion:` field to the 3 active contracts
  plus `templates/mission-contract.md`, and have `check` read the declared field instead of asking at tick
  time. **Verified fact 1 makes this materially cheaper than the redesign assumed (4 files, not 6), and
  verified fact 3 makes it more honest** — the mapping already exists in readers' heads and is being
  re-derived per tick. This is exactly what question (c) asks, and it should be live at the gate rather
  than pre-rejected as "too invasive" on a file count that was wrong.

## Autonomy Posture
Gated

**Stop points:**
- After `/risk-check` returns: RECONSIDER or NO-GO → stop, build nothing, do not argue the gate down or
  route around it (mandate `Stop if`).
- If a re-score or the gate agent stalls and returns no verdict → treat as nothing, never as approval. Stop.
- If a concurrent session is found mid-edit on `logs/improvement-log.md`.
- Before any edit to `templates/mission-contract.md` or a second/third mission contract (i.e. if the max
  scope is selected at the gate) — that widens the blast radius and the operator should see it.

## Risk
Run `/risk-check` after this plan is approved (plan-time gate). Run it again before commit (end-time gate),
unless the end-time skip test provably applies and the skip is documented in the wrap note.

Structural classes touched: **new command verb** (`update`) and **changed behaviour of an existing
command** (`check`) on a file distributed to **19 paths by symlink** (verified fact 5) — a change here
reaches every project checkout at once. The max scope additionally edits a **template** consumed at
scaffold time, and **three frozen mission contracts** whose freeze is itself the design contract at
`mission.md:12` — amending a frozen file is the sharpest edge in this plan and is why it carries its own
stop point.

Not an environment-fit risk: the work product is a slash command invoked in-session, not a terminal
launcher, so the VS Code-launch baseline does not bite here.
