# Session Plan — 2026-07-19

## Intent
Redesign `/prime` Step 3's improvement-log scan to emit compact unresolved-HIGH summaries instead of raw `grep -B6` output, bringing it back under the command's own stated <40-line budget, and delete the stale "30 of 87" prose at `prime.md:221`.

## Model
opus — match (deciding, not doing: the two obvious remedies are both ruled out, so the work is designing a third approach under constraint, plus judging a suppression-visibility tradeoff).

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md` — Step 3 at `:200-226`; the edit target
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md` — the scan's subject and the measurement target (read-only)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/missions/repo-health-backlog-2026-07.md` — thread 15 (this work), threads 1/2 (the composing fixes)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` — structural change classes / risk-check gate
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/repo-architecture.md` — symlink topology (28 consumer paths)

## Findings / Items to Address

1. **The scan is 6.2× its stated budget and has grown since thread 15 was written.** Measured this session by execution: the `grep -nE -B6` at `prime.md:206` returns **247 lines / 56,508 chars** against the command's own `<40-line` budget. Thread 15 (`repo-health-backlog-2026-07.md`, thread 15) records 222 lines / 47,753 chars — so it has grown ~11% in lines and ~18% in chars since that measurement. Instrument: the scan itself, run in this checkout against this checkout's log. Repo-scoped claim, repo-scoped instrument.

2. **Cause is two correct fixes composing — do not reopen either.** Threads 1 and 2 both landed. The log now holds **111 entries / 1,419 lines** with a near-complete Severity backfill; that backfill created 24 `medium-high` + 7 `high` = **31 matching entries**, each dragging a 7-line `-B6` window. The scan is not broken; it is succeeding at a design that does not scale.

3. **Both obvious remedies are already foreclosed.** `prime.md:217` explicitly forbids narrowing `-B6` (at `-B4` the header is lost on multi-line-status entries). The drain has already run — 0 resolved-unarchived entries. The remaining lever is the **emit** side, not the read side.

4. **NEW — found by measurement this session: two HIGH entries are structurally invisible to the current scan.** `improvement-log.md:765` and `:1140` write `- **Severity:** **high**` (bolded value). The anchor `^-? ?\*\*Severity:\*\* *(high|...)` expects `high` immediately after the space and sees `**high**` instead, so it does not match. Both are genuine HIGH entries (marker-collision; wrong-mandate shape). This is a live re-instance of thread 2's defect class ("a third of the backlog is structurally invisible to `/prime`"), created by the same free-text-severity-value problem. A parser-based emit step fixes it for free; a grep-based one cannot.

5. **The stale prose at `prime.md:221` is confirmed false.** It asserts "As of 2026-07-18, 30 of 87 entries carry no `Severity` field." The log now holds 111 entries and the unclassified count is **0–1** (my parser conflated a literal severity value of `none` with a missing field — to be disambiguated cleanly at implementation rather than asserted now). Either way the "30 of 87" figure is falsified by its own fix. Thread 15 asks for its deletion.

6. **The load-bearing risk this change introduces, stated up front.** Step 3 today emits raw text and instructs the *model* to apply the resolved/LOW/MED filter in-head. Moving that filter into a script means the model no longer sees what was dropped. If the filter is wrong, backlog items become silently invisible — **the exact failure mode of thread 2 and of the repo's most-logged pattern (inert safeguard / silent false negative)**. This is the design's central tradeoff and the thing `/risk-check` must score. Mitigation carried into the design: the emit step prints a **suppression census** (`N entries filtered: X resolved, Y low/med, Z unclassified`) so what is dropped is always visible, per the repo's own "No silent caps" principle.

## Execution Sequence

1. **Re-measure the baseline cleanly and record it.** Re-run scan 1 and capture lines/chars; disambiguate the unclassified count (missing `Severity` field vs. literal value `none`) with a parser that distinguishes them. *Verify:* two figures written down before any edit — the before-figure and the true unclassified count. No estimates.

2. **Write the replacement emit step as a standalone script first, outside `prime.md`.** A python3 parser that splits on `^#{2,3} \d{4}-\d{2}-\d{2}`, extracts header/Status/Severity per entry, normalizes the severity value (strip `**`, `~~`, trailing `*(backfill…)` notes, and `med` → `medium`), applies the unresolved-HIGH filter, and emits one compact line per survivor plus a suppression census. *Verify:* run against the live log; output is ≤40 lines; the two bolded-`high` entries at `:765`/`:1140` now appear; the census numbers sum to 111.

3. **Falsification test — declare expectations BEFORE running.** Construct fixture entries the filter must *reject* (a resolved HIGH, a LOW) and must *accept* (a `**high**`, an un-dashed `**Severity:**`, a `medium-high`). Write the expected verdict for each down first, then run. *Verify:* every case lands as declared. A test whose expectations are written after the run proves nothing — this is the S12-3cd BSD-`sed` lesson and it is why this step exists.

4. **`/risk-check` — plan-time gate.** Structural class: `prime.md` is carried by **28 paths (25 symlinks, 3 real files)**, so this reaches every project. Supply the consumer inventory, the before-figure, and finding 6's suppression risk as the scored question. *Verify:* a verdict recorded under `audits/risk-checks/`. **On RECONSIDER or NO-GO: stop, record, build nothing.**

5. **On GO only — land the change in `prime.md` Step 3** and delete the stale "30 of 87" prose at `:221`. Keep the friction-log scan (scan 2) unchanged — it is already bounded by `head -n 40` and its file has no Severity schema to parse. *Verify:* re-read the edited region; the `-B6` prohibition note at `:217` is either preserved or deliberately superseded with a stated reason, not silently dropped.

6. **Measure the after-figure by execution against the live log.** *Verify:* ≤40 lines, recorded next to the before-figure. An unmeasured fix does not satisfy the mandate's exit condition.

7. **Check the 3 real (non-symlink) `prime.md` copies for drift.** 25 of 28 paths update for free; 3 do not. *Verify:* each real copy is either byte-identical post-edit or explicitly noted as a known fork.

8. **Commit.** Do not tick thread 15 — thread 12 (`/mission check`) is still RECONSIDER'd, so no tick is honest yet.

## Scope Alternatives

- **Min** — delete the stale prose at `:221` only. Costs almost nothing, fixes nothing; the 56KB scan survives. Rejected as the primary target: it satisfies the letter of one clause and leaves the actual defect live and growing.
- **Recommended** — steps 1–8 above: parser-based emit step with a visible suppression census, the bolded-severity invisibility fixed as a side effect, stale prose deleted, measured before and after.
- **Max** — additionally normalize the severity vocabulary *in the log itself* (31 `medium`, 15 `low *(backfill…)`, 2 `**high**`, 1 `~~medium~~`, 4 `med`) so the parser needs no normalization layer. Rejected for this session: it is a log-hygiene pass over 111 entries, it touches a file a concurrent session may edit, and the parser can absorb the variance today. Route to `/friday-act`.

## Autonomy Posture
**Gated** — one hard stop at the `/risk-check` verdict (step 4). Everything before it is analysis and a throwaway script; everything after it is contingent on the verdict.

**Stop points:**
- **Step 4 — `/risk-check` verdict.** On RECONSIDER or NO-GO: stop, record the verdict, build nothing. Do not argue the gate down and do not route around it. Thread 12 has been RECONSIDER'd twice in two sessions by arguing; the pattern here is that arguing loses.
- **Step 3 — falsification test fails.** If a declared expectation does not hold, stop and diagnose rather than adjusting the expectation to match the output.
- **Step 6 — after-figure cannot be measured reproducibly.** An unmeasurable fix is not a fix; this mission exists to end exactly that.

## Risk

Run `/risk-check` after the plan is approved (plan-time gate). The end-time gate may be skippable per the workspace skip test if the executed set is a strict subset of what was gated and the commits land before wrap — apply the test explicitly rather than assuming.

**Structural class — confirmed, two ways.** (a) New/changed automation with shared-state effects: this edits what an orientation command *emits* from a shared, monotonically-growing log. (b) The `/session-plan` Step 6 tripwire: the change relocates a filter from the model's reasoning into a script, which reorders operations against shared state. The "existing-command refactor" framing does **not** exempt it.

**Blast radius:** 28 paths carry `prime.md` (25 symlinks, 3 real files) — every project in the workspace orients through this step.

**Named risks:**
- **Suppression invisibility (the primary one, finding 6).** A script-side filter can hide backlog items the model would previously have seen. Mitigated by the suppression census, but the mitigation is only as good as the census being read — score it at the gate rather than assuming it.
- **Shell-quoting fragility.** The Bash tool runs under **zsh**, and this step embeds a multi-line python3 heredoc. The repo has two logged incidents of zsh-vs-bash divergence in `prime.md` itself (an unmatched glob crashing under `NOMATCH`; `path` as a tied parameter). Any embedded script must be validated **by execution in the real shell**, never by review.
- **Environment-fit:** not applicable — the work product is a command file, not a launcher or terminal-triggered executable.
