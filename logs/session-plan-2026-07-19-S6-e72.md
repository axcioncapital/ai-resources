# Session Plan — 2026-07-19 S6-e72

## Intent

Run three picked menu items in order: (1) make the destructive-liveness test harness hermetic so its pass/fail signal is trustworthy; (2) diagnose by execution why session markers survive a clean wrap despite two wired controls, and land the fix if it sits in-repo; (3) redesign what the `/prime` Step 3 scan emits so it fits its 40-line budget. Mission: `repo-health-backlog-2026-07`.

## Model

**opus** — matches the active session model. Items 2 and 4 are root-cause and design work, not mechanical edits: item 2's cause is not yet known, and item 4's two obvious remedies are both explicitly forbidden, so a third approach must be designed. Item 1 alone would justify sonnet; the bundle does not.

## Source Material

- `logs/improvement-log.md` — 2026-07-19 HIGH entry: harness rot (item 1), with the four false-signal cases named.
- `logs/friction-log.md` L821 — SessionEnd teardown failure (item 2), including the falsified "crashed sessions" hypothesis.
- `logs/missions/repo-health-backlog-2026-07.md:158` — thread 15 (item 4), with the two forbidden remedies stated.
- `logs/scripts/test-destructive-liveness.sh` (120 lines) — read in full this session.
- `~/.claude/hooks/cleanup-session-marker.sh` (143 lines) — read in full this session.
- `.claude/hooks/detect-concurrent-session.sh` (205 lines) — prune logic located at `:182`, degrade path at `:187-192`.
- `~/.claude/hooks/cleanup-session-marker.log` — the self-probe instrument; **1 line total**, read this session.

## Findings / Items to Address

### Item 1 — harness hermeticity

- `$WT` (`:6`) points at `ai-resources-research-workflow`, an **external worktree that no longer exists as an occupied checkout**. The five LIVE-TARGET cases (`:95-99`) and both `-C FORM` cases (`:107-108`) assert exit 2 against it. The file's own header comment (`:9-12`) predicted precisely this rot.
- The harness reports **12 PASS / 5 FAIL → "RED — do not ship"** and, per last session's finding, *neither number is trustworthy*: the FAILs are environmental, and some PASSes are green-by-vacuum.
- **The four `ovr()` cases (`:82-85`) are sound and must not be disturbed** — they assert on the `OVERRIDE ACCEPTED` branch, not on exit codes, precisely to avoid ambient-state dependence. `:64-66` forbids converting them. They are the model for the repair, not a target of it.
- SELF-TARGET (`:88-89`) inherits the live `logs/` directory, so its expectations depend on this session's own marker state.
- Fix shape: synthesize an occupied checkout inside `$TMP` (real repo, checked-out branch, un-wrapped per-id marker, uncommitted work) and give SELF-TARGET a controlled marker environment. **Do not re-point `$WT` at another real worktree** (same rot, fresh expiry) and **do not adjust expected values to reach green**.

### Item 2 — marker teardown

- **Both controls are wired.** `cleanup-session-marker.sh` at SessionEnd (`~/.claude/settings.json:141,146`); `detect-concurrent-session.sh` at SessionStart (`:78`). So "not registered" is falsified — the failure is at delivery or at execution.
- **The self-probe log holds exactly one line, from 13:41 today, for a different project** (`axcion-communication-system`), reading `NOOP marker-absent`. The log is bounded at 100 lines, so this is not truncation.
- **Therefore: ai-resources sessions S1-e58 … S5-dd5 (five sessions today) produced zero log lines.** The hook writes a line on every path *except* Guard 2 (`:127-129`, silent `exit 0`). Two live hypotheses: (a) SessionEnd is not delivered for most session exits; (b) it is delivered but Guard 2 fails silently. For ai-resources, cwd would contain `logs/`, so (b) is unlikely — **(a) is the leading hypothesis**, and the one log line's payload carries a `reason` key, suggesting exit-reason-dependent delivery.
- **The backstop is also not firing.** `detect-concurrent-session.sh:182` does `rm -f` provably-dead markers, but only when lsof grounds liveness; `:187-192` degrades to warn-without-prune otherwise. The three 2026-07-18 markers survived every session start today, including this one.
- **Mandate cap applies:** if the cause lands in the unversioned `~/.claude/hooks/cleanup-session-marker.sh`, record the diagnosis and stop. If it lands in `detect-concurrent-session.sh` or `wrap-session.md` (both in-repo), fix it.
- **Out of scope by mandate:** hand-deleting the three stale markers. They are the evidence.

### Item 4 — `/prime` Step 3 emit cost

- **Measured live this session: 343 lines** against a 40-line budget (8.6×). Thread 15 records 222 (2026-07-18) — it has grown ~55% in one day. The thread text is stale and must be corrected with this figure.
- Cause is two *correct* fixes composing: threads 1 and 2 landed, the Severity backfill created 21 new `medium-high` entries, and the `-B6` window now carries them all.
- **Both obvious remedies are forbidden:** narrowing `-B6` (`prime.md:219` — *corrected from thread 15's `:217`, which is the un-dashed-variant note*) and draining the log again (exhausted; the drain caused the growth).
- Required approach: change what the scan **emits**, not what it reads — parse entries and emit compact unresolved-HIGH summaries.
- **Risk-check class:** `prime.md` is distributed to every project by symlink.
- **The load-bearing exclusion is at `prime.md:223`**, not the `:206-221` range: the backtick in `logs/improvement-log.md:13` is what keeps the log's own vocabulary-declaration line out of the task menu, and `\*{0,2}` matches zero asterisks then fails on it. A redesign that loses this injects a phantom urgent item into every consumer's menu.
- ⚠ **Thread 15's instruction "delete the stale '30 of 87' prose at `prime.md:221`" is MIS-CITED — that prose is not in `prime.md`.** Explicit-path grep for `of 87|of 88|30 of 8[0-9]` over `prime.md` returns zero (explicit path, so immune to the thread-11 search blindness). The "30 of 88" text lives in `logs/improvement-log.md:13`, where it is a correct historical note, not stale prose. **Drop this sub-task and correct the thread text.**

## Execution Sequence

### Stage 1 — Item 1: harness hermeticity
1. Build a `$TMP` fixture generator: init a repo, create and check out a branch, write an un-wrapped per-id marker into its `logs/`, leave an uncommitted file.
2. Re-point the LIVE-TARGET and `-C FORM` cases at the synthesized checkout; give SELF-TARGET a controlled marker environment.
3. **Falsification gate — non-negotiable:** run every case against a deliberately broken copy of the hook and confirm each FAILS. A case that passes against broken code is inert and must be rewritten, not accepted.
4. Run against the real hook; expect green *for the right reason*. Do not adjust expectations to reach green.

### Stage 2 — Item 2: marker teardown
1. Determine the log file's birth time (`stat -f %SB`) to establish whether one line means one fire ever or a recent reset.
2. Confirm lsof availability and whether `detect-concurrent-session.sh`'s prune path (`:182`) is reachable for the three stale markers — this decides whether the backstop is broken or merely degraded.
3. Establish SessionEnd delivery empirically rather than by reading: instrument or observe the next clean exit.
4. Route by cause: in-repo (`detect-concurrent-session.sh`, `wrap-session.md`) → fix; unversioned global hook → record the diagnosis and stop per the mandate cap.
5. Correct the false trustworthiness claim at `close-worktree-session.md:127-131` regardless of route — it asserts the teardown is harness-enforced and reliable, which the evidence contradicts.

### Stage 3 — Item 4: Step 3 emit redesign
1. Design the emit-side transform (parse entries → compact unresolved-HIGH summary lines) against the live 343-line output.
2. Verify the design preserves the schema-anchor lessons already load-bearing at `prime.md:219` (the `-B6` sizing) and `prime.md:223` (the backtick exclusion that keeps `improvement-log.md:13`'s vocabulary declaration out of the menu).
3. Run `/risk-check` before landing (symlink-distributed file).
4. On GO: land, re-measure, and confirm under 40 lines with no hit on an applied/resolved/declined entry. Correct thread 15's stale 222 figure to the live measurement, and correct its mis-cited `:221` sub-task rather than executing it.

## Scope Alternatives

- **Full bundle (planned).** All three items. Risk: item 2's cause is unknown and may consume disproportionate budget.
- **Narrowed.** Items 1 and 4 only; item 2 reduced to the diagnosis already captured in this plan's Findings, filed to `improvement-log.md`. Reachable at any point — items 1 and 4 are independent of item 2.
- **Minimum viable.** Item 1 alone. It is the stated blocker on trustworthy work on `check-destructive-liveness.sh`, and it is self-contained.

## Autonomy Posture

**Gated.** Two structural triggers: item 4 edits `prime.md` (symlink-distributed to every project), and item 2 may touch a globally-registered hook. `/risk-check` runs before execution per workspace Autonomy rule #9. On RECONSIDER or NO-GO for an item, record the verdict and build nothing on that item — do not argue the gate down.

## Risk

- **Item 1's repair could itself be inert.** This harness has already produced two can-never-fail drafts in two sessions. The Stage 1 falsification gate is the countermeasure and is not optional.
- **Item 2 may not be fixable in-repo.** If SessionEnd delivery is a CLI behaviour rather than a script defect, the honest outcome is a recorded diagnosis, not a fix. Accepting that is the mandate cap, not a failure.
- **Item 4 touches the file every project loads at orientation.** A regression here degrades every session's task menu. The existing anchor comments at `:206-221` encode two prior defects; the redesign must not reintroduce either.
- **Bundle risk.** Three items, two structural-class. If item 2 consumes the design budget, fall to the Narrowed alternative rather than rushing items 1 or 4.
