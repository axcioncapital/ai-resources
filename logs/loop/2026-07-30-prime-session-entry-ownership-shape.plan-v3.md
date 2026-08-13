PLAN v3
UNIT: 2026-07-30-prime-session-entry-ownership-shape
STREAM: 2026-07-30-prime-session-entry-ownership
PHASE: shape
REPO: ai-resources
BASE: bc8edd6
NEXT: operator — G1

**Capability:** prime-runtime-delegation

Supersedes `…shape.plan-v2.md`, which is immutable and retained (as is v1). v3 exists because review-2
returned **REVISE BEFORE G1** with four material findings; § 8 records the disposition of each, plus one
defect this unit found while verifying them that review-2 did not raise.

Object under work: `.claude/commands/prime.md`, **411 lines** at HEAD.

**No third review is planned.** `docs/work-loop.md` § The challenged route permits a closure round only
when corrections changed what the prior verdict rested on. The v3 corrections are exactly the four
required corrections review-2 named, so a further round would be a chain. G1 is next.

---

## 0. Three budgets, four script owners

| Budget | What it counts | Status |
|---|---|---|
| **A — `/prime` lines** | `wc -l .claude/commands/prime.md` | **the ≤300 target** |
| **B — other model-read prompts** | net lines added to `wrap-session.md`, `session-plan.md`, `session-start.md` | **disclosed, not targeted** |
| **C — script lines** | `.sh` files | **free** — executed, never read into a model's context |

**Budget C covers four script owners, not three** (review-2, minor): `prime-session-entry.sh` **extended**
from the existing `prime-marker.sh`, and three **new** — `promote-findings.sh`, `prime-sync.sh`,
`prime-collect.sh`. `prime-allocator.test.sh` is a fifth surface, extended, and is test code.

**Result: A = 188 against ≤300. B = +48. C = four script owners.**

**B is four times v2's figure, and v2's +12 was wrong** — it was computed before the receiving owners were
inspected. Review-2 M1 predicted this precisely. The trade is still delegation and not relocation: **223
lines leave `/prime` and 48 arrive elsewhere, a ratio of 4.6 : 1**, and every added line is a
responsibility that provably had no other owner (§ 1 S6).

Every subtraction is an exact count of lines that exist today; every addition is drafted in full (§ 6) and
counted by script. **Three hand-counts in this stream have now been wrong** — v1's 11/28/16 against an
actual 12/31/17, v1's 192 against 186, and v2's 13/19 for §§ 6.1/6.3, which counted the plan's own fence
line as `/prime` content. The last of those is why A moves 186 → 188 with no design change.

---

## 1. What will be done, in order

Six slices, one Build unit each. **All six are mandatory.**

### S1 — Complete the session-entry owner and fix the locator **(release blocker)**

Evidence at two levels. **Observed:** one real consumer failure, `logs/improvement-log.md:2211-2219`
(`axcion-systems-builder`, manual absolute-path workaround). **Inferred:** that 31 further roots would
fail is a deterministic filesystem inference from the census (32 roots carry the call, 1 holds the
script), not 31 observed executions.

1. Extend `logs/scripts/prime-marker.sh` into `logs/scripts/prime-session-entry.sh`, taking `WORK_DESC`
   as `$1` and performing **marker → header append → mtime stamp** as one sequence. The script already
   *reads* `logs/session-notes.md` (`:83`, `:86`); this extends an existing reader into a writer.
2. Locate the script **absolutely** via the `AI_RESOURCES` literal `prime.md` already defines, leaving
   **cwd** as the consumer repository — so it writes into the *calling* repo's `logs/` and resolves from
   all 32 roots.
3. Collapse Steps 8k and 8h into the single retained identifier **8h**; `8k` is retired.
4. Repoint the 6 `8k` citations **semantically** (§ 4).
5. Retain `prime-allocator.test.sh` and **add** the session-entry tests (§ 5).

**The failure/recovery model — rewritten on the real write sequence (review-2 M4).** v2's table opened
with "marker write fails → nothing written". That is false. `prime-marker.sh:140-156` performs **four**
persistent writes before the header is ever touched:

| # | Write | Site |
|---|---|---|
| 1 | `mkdir "$CLAIMS/${TODAY}-S${N}"` — the atomic claim | `:144` |
| 2 | `> "$CLAIMS/${TODAY}-S${N}/owner"` — debug breadcrumb | `:146-147` |
| 3 | `> logs/.session-marker` — the shared marker | `:156` |
| 4 | `> logs/.session-marker-${CLAUDE_CODE_SESSION_ID}` — the per-id identity oracle | `:158` |

So the real partial states are six, not three:

| Failure after | State left behind | Consequence | Recovery |
|---|---|---|---|
| 1 | claim dir, no breadcrumb | claim held by nobody; `mkdir` on that N fails forever | next run bumps to N+1 — **one number burned per occurrence, permanently** |
| 2 | claim + breadcrumb, no marker files | as above | as above |
| 3 | shared marker written, **per-id marker absent** | **this session is invisible to `detect-concurrent-session.sh`**, which keys on `logs/.session-marker-*` (`:158`, `:162`) — and every *other* session's marker now reads as foreign | next `/prime` writes both |
| 4 | both markers, no header | marker allocated, `session-notes.md` unchanged | next run allocates N+1 and writes its own header |
| header append | header present, `.prime-mtime` stale | `/session-start` Step 0.5 reads a stale mtime and reports a foreign write — **visible, not silent** | next run restamps |
| mtime stamp | complete | — | — |

**State 3 is the one v2 could not see and is the most consequential**, because it degrades a *different*
subsystem's correctness rather than this one's. It is named here and tested by F-RECOVER.

**"Single complete owner", not "atomic".** The word is withdrawn; the table above plus F-RECOVER is what
replaces it. **The table is a state model, not evidence** — review-2 M4 is right that it cannot stand in
for execution. § 5 therefore executes one injected failure and marks the rest **unassessed** rather than
claiming them proven.

### S2 — Retire the removals that need no new owner

Pure deletions: multi-item auto mode (`auto 1,3`; `auto`/`auto N` retained), `STRUCTURAL_RISK` derivation
(8c.8) and its disclosure (8c.11), the legacy `QC-PENDING` bullet, model-alignment reporting (mismatch
nudge **and** the plain `Model:` line), and the log-trio prefetch (`:61-62`).

Sub-step identifiers inside 8c are **preserved, not renumbered** — see § 4.

Also assigned here: **`session-plan.md:99`**, which cites "`/prime` Step 4's model-alignment check".

**`STRUCTURAL_RISK`'s downstream consumers go with it**, and one of them is already dead:
`session-start.md:336-338` renders a `**Risk-check** → Will run before execution begins` block gated on
that field — but `/risk-check` was **retired 2026-07-30** (workspace `CLAUDE.md` § Independent Review
Rule). The field's only rendered consumer advertises a command that no longer exists, so deleting it
removes stale machinery rather than live behaviour. Sites: `session-start.md:89`, `:301`, `:336-338`,
`:349`.

### S3 — Establish the promotion owner, *then* retire Step 3

Step 3 is the only path by which a severity-tagged finding reaches the task menu.

`logs/scripts/promote-findings.sh` sweeps every open `high` / `medium-high` / `critical` / `urgent` entry
in this repo's `friction-log.md` and `improvement-log.md` and appends each to `logs/next-up.md`.

**The stamp-the-source design is withdrawn (review-2 M2), and the reason is stronger than the race.**
v2 stamped `<!-- promoted -->` into the source entry. Beyond the check-then-act race review-2 describes,
that write is **forbidden by an existing rule**: `docs/commit-discipline.md` § Maintenance-owned in-place
mutations confines in-place mutation of these two logs to dedicated single-purpose sessions and states
that *"an ordinary work session appends only; it never reaches into an existing entry"* — and names this
exact drift as what the rule guards against (*"a new command that 'helpfully' flips a status as a
side-effect of ordinary mid-session work would violate it"*). `/wrap-session` is an ordinary work session.
The v2 design would have been the rule's first violation.

**Replacement — identity in the destination, plus a lock:**

| Concern | Mechanism |
|---|---|
| Identity | A **content-derived promotion id** (hash of source path + entry header text) recorded in the `next-up.md` line. Stable across archiving and line-number drift, which a stored line number is not. |
| Check-then-act | A repo-local lock, `mkdir logs/.promote.lock` — the same atomic-mkdir primitive already proven in `prime-marker.sh:144`. Lock held → exit 0 silently; the holder covers the same entries. |
| Source logs | **Never written.** Read-only scan. |
| Self-healing | Each run also de-duplicates `next-up.md` by promotion id, so a duplicate arriving via a git union of two checkouts is removed by the next sweep in either tree. |

Called from `/wrap-session` **after** the feedback-collector step, so the session's own findings are
written first.

**The never-wrapped case is a stated limitation, not coverage (review-2 M2).** Findings from a session
that never wrapped are promoted by the next wrap **in that repository**; if no further wrap ever occurs
there, they are never promoted. Today's Step 3 re-greps at every `/prime`, which is more frequent than
wrap. **This is a real reduction in reachability and is accepted deliberately**, not claimed away.
*Rejected alternative:* also call the sweep from `/prime`, restoring parity for ~2 lines of Budget A. It
was rejected because it puts a write back into the orientation path this stream exists to make read-only,
and the residual delay is bounded by the operator's own wrap habit. **Trigger to adopt it:** any finding
observed to sit unpromoted for more than one week.

Order within the slice is fixed: **build the owner → run it → verify the queue → only then delete
Step 3.** Then update the **8 live citations** naming Step 3 as the reachability channel
(`session-feedback-collector.md:126`, `improve.md:60`, `leverage-idea.md:218`,
`resolve-improvement-log.md:33`, `resolve-incident.md:199`, `resolve-repo-problem.md:139`,
`ai-resources/.claude/commands/wrap-session.md:294`, workspace `.claude/commands/wrap-session.md:287`),
and write the `logs/decisions.md` record that `prime.md:194` requires.

### S4 — Move git synchronisation out

`logs/scripts/prime-sync.sh` owns fetch, the behind-check, the pull, rebase-conflict abort, the four
result classifications and the unpushed count, for the cwd repo and `ai-resources`. Step 0 becomes a call
and **keeps its identifier** (2 citations in `docs/commit-discipline.md`).

### S5 — Move mechanical state collection out

`logs/scripts/prime-collect.sh` owns the bounded `session-notes.md` last-entry read, the merged
multi-repo commit scan, the newest-scratchpad selection, the plan-position cascade, the active-mission
scan, `next-up.md`, **`CWD_REPO`** and **`TELEMETRY_GAP`**. Steps 1, 1a, 1b, 1c, 1d keep their
identifiers and become thin judgement steps.

**`CWD_REPO` is now a counted part of the interface (review-2 M3).** v2's 8g consumed it and no drafted
block produced it — today it comes from Step 0, which S4 replaces with a sync call that returns only
`SYNC`. The cross-repo mission guard could not have executed as v2 was written. It is now the first
labelled block the collector returns and is always present.

**`LIVE_FOREIGN` stays out of the contract.** `.claude/hooks/detect-concurrent-session.sh` emits
`{"systemMessage": …}` and persists nothing (0 persistent write sites; positive control:
`prime-marker.sh` has 11), so a later shell process cannot read it. `/prime` consumes the hook's message
from context in its judgement layer and issues no scan. F-HOOK distinguishes consumption from a rescan.

### S6 — Transfer everything after dispatch **(mandatory)**

**v2 claimed one receiving owner needed one line. That was the plan's largest error (review-2 M1).** The
receiving commands do not merely fail to own the transferred behaviour — they explicitly hand control
*back* to steps this stream deletes. Verified at HEAD:

| Site | What it says today | What S6 does to its target |
|---|---|---|
| `session-start.md:452` | direct route returns to `/prime` 8a.3.d (lean go-prompt) / 8b.3.d (begins execution) | **both deleted** |
| `session-start.md:465` | `{gate:auto}` makes `/session-plan` return to `/prime`; 8c.11 owns review sizing, 8c.12 owns execution start | **all three deleted** |
| `session-plan.md:235-239` | AUTO_GATE → "Returning to /prime", explicitly does not begin execution | **target deleted** |
| `session-plan.md:241-245` | POST_PLAN_GATE → pause "belongs to the caller"; `/prime` 8a.d owns it | **target deleted** |
| `session-start.md:349` | "`/prime` owns `STRUCTURAL_RISK` alone" | **field deleted (S2)** |

With v2's Step 9 in place, **three routes would dead-end**: numbered-direct, free-text-direct, and auto
on both routes. This is the hidden coupling S6 exists to remove, and it is why S6 is a real edit to two
receiving commands rather than a transfer table.

What actually changes, drafted at §§ 6.6–6.8:

| Leaves `/prime` | Receiving owner | Owner change |
|---|---|---|
| Post-plan pause **and its `go` continuation** (8a.3.d) | `/session-plan` Step 8 POST_PLAN_GATE branch | **Yes** — the pause was already emitted there; the `go` continuation was not |
| Execution start (8b.3.d, 8c.12) | `/session-plan` Step 8, all three branches | **Yes** — AUTO_GATE branch inverted from "return without executing" to "execute" |
| Autonomy posture, guardrail flags, between-item summaries, compaction checkpoints (8c.12) | `/session-plan` § Post-plan execution (new shared section) | **Yes** |
| Wrap reminder (8c.13) | same shared section, reached from both terminal owners | **Yes** — v2 assigned this to `/session-start` alone, which the auto route never reaches |
| Direct-route terminal behaviour (8a.3.c, 8b.3.c, 8c.10) | `/session-start` Step 4 direct branch | **Yes** — it becomes the direct route's terminal owner and now **branches on `{gate:post-plan}` instead of ignoring it** |
| Review-sizing disclosure (8c.11) | **none — deleted with `STRUCTURAL_RISK`** (S2) | n/a |
| Plan-file existence prompt | `/session-plan` Step 0 via `{plan:overwrite}` | **No** — already implemented |

**One behavioural reversal is deliberate and load-bearing.** `session-start.md:452` today says to *ignore*
`{gate:post-plan}` on the direct route. After S6 that token is the **only** thing distinguishing a
numbered pick from free-text once `/prime` stops at dispatch, so the direct branch must key on it. A Build
unit that leaves the ignore-instruction in place produces a direct route that never pauses.

`/prime` ends at dispatch; a new terminal **Step 9 — Stop** makes that explicit and testable.

---

## 2. What it touches

| Surface | Slice | Nature | Budget |
|---|---|---|---|
| `.claude/commands/prime.md` | S1–S6 | object under work | **A** |
| `logs/scripts/prime-session-entry.sh` (from `prime-marker.sh`) | S1 | extended: reader → writer | C |
| `logs/scripts/prime-allocator.test.sh` | S1 | retained + extended | C |
| `logs/scripts/promote-findings.sh` | S3 | new | C |
| `logs/scripts/prime-sync.sh` | S4 | new | C |
| `logs/scripts/prime-collect.sh` | S5 | new | C |
| `.claude/commands/wrap-session.md` | S3 | +16 — promotion call site | **B** |
| `.claude/commands/session-plan.md` | S6 | +17 — Step 8 rewritten, three branches | **B** |
| `.claude/commands/session-plan.md` | S2 | 1 citation repointed (`:99`) | — |
| `.claude/commands/session-start.md` | S6 | +18 — Step 4 direct branch becomes terminal owner | **B** |
| `.claude/commands/session-start.md` | S2 | −3 — `STRUCTURAL_RISK` block; 3 further in-line removals | **B** |
| `docs/session-marker.md` | S1 | 6 × `8k` semantic repoint | — |
| `ai-resources/CLAUDE.md` § Session Telemetry | S5 | stale parenthetical (§ 4) | — |
| 8 files citing `/prime` Step 3 | S3 | re-homed to the promotion owner | — |
| `logs/next-up.md` · `logs/decisions.md` | S3 | receives promoted items · one record | — |
| `development/prime-runtime-delegation.md` | S1 | `prime-marker.sh` references updated | — |
| 29 consumer checkouts | S1 | via symlink — no per-consumer edit | — |

Added since v2 (review-2 M1, M3): the `session-plan.md` Step 8 rewrite, the `session-start.md` Step 4
rewrite, the four `STRUCTURAL_RISK` sites, and the `CLAUDE.md` telemetry parenthetical.

**Not touched:** the two genuinely distinct 33-line `prime.md` variants (`workflows/research-workflow`,
`axcion-sector-intelligence`); the `ai-resources-work-loop` worktree copy; `logs/missions/*`.

---

## 3. Budgets — every cell script-counted

Region map computed by parsing top-level step headers (`^\d+[a-z]?\. `) and differencing successive
positions; region sum + preamble = 411, matching `wc -l` exactly.

### Budget A

| Region | Now | After | Basis |
|---|---:|---:|---|
| preamble | 10 | 10 | carried unchanged |
| Step 0 — pull | 44 | 12 | § 6.1, script-counted |
| Steps 1 + 1a–1d — collection | 115 | 36 | § 6.2, script-counted |
| Step 2 — next-up | 2 | 2 | carried unchanged |
| Step 3 — urgent-log triage | 26 | 0 | whole-region deletion, exact |
| Step 4 — exception checks | 8 | 5 | lines 200–202 deleted, exact |
| Step 5 — menu | 16 | 15 | `[urgent]` bullet deleted, exact |
| Step 6 — brief template | 34 | 32 | model lines 227–228 deleted, exact |
| Step 7 — classify reply | 9 | 8 | multi-item bullet 261 deleted, exact |
| Steps 8k + 8h — session entry | 42 | 18 | § 6.3, script-counted |
| Steps 8m + 8g + 8a + 8b + 8c + 9 — dispatch | 105 | 50 | § 6.4, script-counted |
| **Total** | **411** | **188** | |

**Budget A = 188 against ≤300. Slack: 112 lines. 223 lines leave `/prime`.**

### Budget B

| Surface | Before | After | Δ |
|---|---:|---:|---:|
| `wrap-session.md` — promotion call site (§ 6.5) | 0 | 16 | **+16** |
| `session-plan.md` — Step 8, lines 235–251 (§ 6.6) | 17 | 34 | **+17** |
| `session-start.md` — Step 4 direct branch, lines 445–452 (§ 6.7) | 8 | 26 | **+18** |
| `session-start.md` — `STRUCTURAL_RISK` block, lines 336–338 (§ 6.8) | 3 | 0 | **−3** |
| **Net** | | | **+48** |

Three further `STRUCTURAL_RISK` removals (`:89`, `:301`, `:349`) are within-line and change no line count.

**A falls 223; B rises 48.** B is disclosed at every remaining gate. A fall in A bought by a rise in B
beyond +48 is a **finding at G2**, not a pass.

---

## 4. C2 renumbering — decided, corrected, and fully assigned

**Decision, unchanged and endorsed by review-1 Q2: preserve the identifier of every retained step;
repoint the citations of every retired identifier in the slice that retires it; never renumber to close a
gap.** Renumbering would convert 38 zero-cost sites into must-touch sites on a surface where a missed edit
fails silently.

**v2's own drafted text violated this policy (review-2 M1), and v3 fixes the draft rather than the
policy.** v2 § 6.4 renumbered 8c's sub-steps to 1–4, putting dispatch at `8c.4` while § 4 simultaneously
listed `8c.9` as retained with zero sites to touch. Both could not be true. § 6.4 now keeps **8c.9** as
dispatch and leaves **4–8 as a deliberate gap**, which is exactly what the policy prescribes.

**A defect this unit found while verifying review-2, which review-2 did not raise.** v2 § 4 and the
evidence file both record `docs/session-marker.md:339` as a **dangling** citation to a *removed* Step
8c.2, scheduled for "fix" in S1. It is not dangling. `prime.md` 8c.2 is the **per-item done-condition
presence-check**, and `session-marker.md:339` sits in § Auto-mode done-condition check citing it as the
step that "holds the mechanism" — a correct, mutual cross-reference. The premise was recorded confirmed on
a partial observation: the grep proved the *string* was present, never that its target was absent.
**Fixing it would have broken a correct citation.** The row is withdrawn, and § 6.4 keeps the
done-condition check at 8c.2 so the citation stays correct. This is the one place a positive control was
missing from the premise work, and it is recorded in the evidence file as such.

| Identifier | Sites | Fate | Slice |
|---|---:|---|---|
| `0`, `1`, `1a`, `1b`, `1c`, `1d` | 21 | retained → **0 to touch** | — |
| `8`, `8a`, `8m`, `8h` | 11 | retained → **0 to touch** | — |
| `8c.2` (done-condition) | 1 | **retained — not dangling; v2's row withdrawn** | — |
| `8c.9` (dispatch) | 7 | **retained via the numbering gap → 0 to touch** | — |
| `3` | 8 | retired → repoint to the promotion owner | **S3** |
| `8k` | 6 | retired → **semantic** repoint (below) | **S1** |
| `8c.5` (session-entry write) | 1 | retired → becomes 8c.3 (`session-start.md:353`) | **S1** |
| `8c.11`, `8c.12` | 2 lines | **deleted** → resolved by the S6 ownership transfer, not a repoint | **S6** |
| `4` (model check) | 1 | retired → `session-plan.md:99` | **S2** |
| **Total** | **58** | **18 touched, 40 untouched** | |

**58, not 54.** v2's enumeration missed the `8c.5`, `8c.11` and `8c.12` sites entirely and miscounted
`8c.9` as a single site when 7 lines carry it.

**Outside the step-identifier surface**, and therefore invisible to the grep that produced this table:
`ai-resources/CLAUDE.md` § Session Telemetry says *"`/prime` already reads that log during orientation"* —
true today via the log-trio prefetch, stale once S2 deletes it. The nudge obligation itself survives; only
the parenthetical describing *how* `/prime` reads becomes wrong. Assigned to S5.

**The six `8k` citations are not a find-and-replace.**

| Site | What it actually says | Correct target |
|---|---|---|
| `session-marker.md:61` | `/prime`'s shared step allocates the marker | `prime-session-entry.sh` |
| `session-marker.md:67` (×2) | allocation is `/prime`-only | `prime-session-entry.sh` |
| `session-marker.md:228` | the shared sub-step in `prime.md` | Step **8h** |
| `session-marker.md:229` | 8h performs the sequence, 8k the allocation | collapse to Step **8h** |
| `session-marker.md:322` | marker grammar lives there | the **canonical protocol section**, not a step |

---

## 5. What would falsify this plan

Each criterion names what must be **run** and what must be **observed**. A criterion that cannot be run is
recorded `unassessed` — never `pass`.

### Stream-level

- **F-LINES.** `wc -l .claude/commands/prime.md` > 300 after S1–S6. Budget B reported alongside; a rise
  beyond the drafted +48 is a **finding**, not a pass.
- **F-ROUTES.** Any of the three retained routes — numbered selection, free-text intent, single-item
  `auto` — fails when exercised **from a named real project-consumer root**, not `ai-resources` and not a
  fixture.
- **F-LOCATOR.** A `/prime` from a consumer root fails to resolve a script, or writes marker / header /
  mtime into `ai-resources` instead of the calling repo. Both halves observed. **Run once from a path
  containing a space** — the workspace path already contains one.

### F-BEHAVE — the retained-behaviour register

A bounded register of behaviours that must survive, each bound to one named observation. Scope is the
retained routes and guards, **not** every line. **Rows R1–R7 are new in v3**, added because review-2 R3
was right that a route's *downstream outcome* is what proves ownership transferred — B14's "nothing
follows" cannot establish that anything picked the work up.

| # | Retained behaviour | Observation that confirms it |
|---|---|---|
| B1 | numbered selection reaches `/session-start` with `{gate:post-plan}` | run `1` from a consumer root; observe the token in the dispatch |
| B2 | free-text reaches `/session-start` **without** the token | run a sentence; observe the token absent |
| B3 | single-item `auto` holds exactly one gate | run `auto`; observe one approval stop, not two |
| B4 | `N auto` is read as auto mode, not bare-number selection | run `2 auto`; observe auto branch |
| B5 | plan-mode guard writes nothing | run in plan mode; observe no marker, no header, no mtime |
| B6 | cross-repo mission guard fires before any write | pick a foreign-repo mission item; observe the stop precedes the write |
| B7 | wrong menu number asks once and re-classifies | run `9` on a 6-item menu |
| B8 | empty menu renders the no-tracked-next-steps line | run in a repo with no candidates |
| B9 | `Where we are:` block omitted when no plan exists | run in `ai-resources`; observe no empty block |
| B10 | mission binding auto-binds from a `[mission:<id>]` item without prompting | run such an item |
| B11 | mission binding skips silently when no missions are active | run in a repo with none |
| B12 | telemetry-gap nudge still fires on a real gap | run against a session-notes date absent from `usage-log.md` |
| B13 | done-condition check holds an item with no deliverable | run `auto` on an activity-only item |
| B14 | `/prime` stops at dispatch and begins no work | run any route; observe no execution turn follows |
| **R1** | numbered × **engineered** → plan written, pause emitted, execution begins on `go` | run `1` in an engineered repo; observe pause, reply `go`, observe execution |
| **R2** | numbered × **direct** → no plan file, lean mandate-review pause, execution begins on `go` | run `1` in a direct-route repo; observe the lean prompt, not the plan prompt |
| **R3** | free-text × **engineered** → plan written, execution begins with no second confirmation | run a sentence; observe no pause |
| **R4** | free-text × **direct** → no plan file, execution begins immediately | run a sentence in a direct-route repo |
| **R5** | auto × **engineered** → one gate, plan written, execution begins without returning anywhere | run `auto`; observe execution starts after the plan write |
| **R6** | auto × **direct** → one gate, no plan file, execution begins | run `auto` in a direct-route repo |
| **R7** | explicit `auto N` resolves to item N | run `auto 3`; observe item 3 selected |
| **R8** | the wrap reminder is emitted on **every** terminal path | run R1–R6; observe `Mandate complete…` in each |

**F-BEHAVE is falsified** if any row cannot be observed, or is observed to differ from its pre-change
behaviour. R1–R8 are the criteria S6 exists to satisfy; B14 alone is insufficient and is retained only as
the negative half.

### S1-specific

- **F-ENTRY.** After **one** call to `prime-session-entry.sh`: (a) `logs/.session-marker` **and** the
  per-id marker written; (b) `## ${TODAY} — Session ${MARKER}` present in `logs/session-notes.md` with
  `WORK_DESC` beneath it; (c) `logs/.prime-mtime` written. All four artifacts, or falsified.
- **F-ORDER.** `stat -f %m` truncates to whole seconds, so "mtime after append" is not a valid oracle
  inside one second. Two checks that do not depend on clock resolution: (i) the appended header
  **contains `${MARKER}`**, possible only if allocation preceded the append; (ii) `.prime-mtime` equals
  the file's mtime read **after** the append at **sub-second resolution** (`stat -f %Fm`), and the test
  appends a second entry to prove the comparison can fail.
- **F-RECOVER — one injected failure, and an explicit unassessed list (review-2 M4).** Inject the failure
  **after write 4 and before the header append** — the state the S1 table calls the dangerous retry path.
  Observe: both marker files present, no header, and a subsequent `/prime` allocates `S${N+1}` and
  completes. **The other five partial states are recorded `unassessed`**, not proven. Naming them is a
  state model; only this one is executed. **Reopens if** any unassessed state is observed in real use, or
  if state 3 (per-id marker missing) is ever seen — its blast radius reaches
  `detect-concurrent-session.sh`, so it would justify its own test.
- **F-TESTS.** `prime-allocator.test.sh` is **retained and extended**. It must hold its 19 existing
  assertions **and** add: fresh-header append, same-marker reinvocation, exact `WORK_DESC` text,
  mtime-after-append at sub-second resolution, and the F-RECOVER injection. Green is load-bearing only if
  shown able to fail: mutate the fail-safe seed, observe red, restore, observe green.

### S3-specific

- **F-BACKLOG (migration).** Every item the pre-change Step 3 would have surfaced appears in
  `next-up.md` afterwards. Enumerate the pre-change emit, then diff.
- **F-LOOP (continuation).** Write a **new** qualifying finding after the change, run the owner, observe
  it reach `next-up.md`. Run the owner **again**; observe no duplicate.
- **F-PROMOTE-RACE (new, review-2 M2).** Run **two sweeps simultaneously** — `promote-findings.sh &
  promote-findings.sh & wait` — against a log holding one unpromoted qualifying finding. Observe
  **exactly one** entry in `next-up.md` and **zero** modifications to either source log
  (`git diff --stat` on the two logs must be empty). Positive control: remove the lock and observe the
  duplicate appear, confirming the test can detect the race it is written for.
- **F-NO-SOURCE-WRITE.** Inspect `promote-findings.sh` for any write to `friction-log.md` or
  `improvement-log.md`. Any hit falsifies, regardless of behaviour — the constraint is
  `docs/commit-discipline.md` § Maintenance-owned in-place mutations, not just the race.

### S5-specific

- **F-HOOK.** The concurrent-session advisory still fires when a foreign session is live, **and**
  `prime-collect.sh` issues no marker-file scan of its own — verified by inspecting the script for any
  `logs/.session-marker-*` read. Consumption and rescan produce the same advisory, so the criterion tests
  the mechanism, not just the output.
- **F-CWDREPO (new, review-2 M3).** `prime-collect.sh` returns a `CWD_REPO` block naming the calling
  repository, observed from a consumer root that is not `ai-resources`. Falsified if absent — 8g's
  cross-repo guard cannot run without it.

### F-DUP — the duplication register

| # | Site (HEAD) | Owner it defers to | Expected fate | Check |
|---|---|---|---|---|
| D1 | `:28` | `commit-discipline.md` § Orientation pull | → `prime-sync.sh` (S4) | behind-check still skips a pull on an up-to-date repo |
| D2 | `:64–65` | `heavy-read-discipline.md` § Step 1 | → `prime-collect.sh` (S5) | last-entry read still anchored on `^## [0-9]` |
| D3 | `:71` | `backlog-reconciliation.md` | scan → collector; classification stays (S5) | merged set still spans cwd + ai-resources + siblings |
| D4 | `:122` | `session-marker.md` § Concurrent detection | → hook message in judgement layer (S5) | F-HOOK |
| D5 | `:135` | `project-next-steps.md` Step 2 | → `prime-collect.sh` (S5) | position-before-spine inversion preserved |
| D6 | `:135` | `heavy-read-discipline.md` § Step 1c | → `prime-collect.sh` (S5) | plan file still bounded-read, never full-read |
| D7 | `:187` | `heavy-read-discipline.md` § Step 3 | **deleted with Step 3** (S3) | section no longer cited by any live file |
| D8 | `:194` | `wrap-session` 12e · collector `:138` · `improvement-log:13` | **deleted with Step 3** (S3) | the three writer contracts repointed |
| D9 | `:274` | `session-marker.md` protocol | → `prime-session-entry.sh` (S1) | F-ENTRY + F-ORDER |
| D10 | `:336`/`:361`/`:395` | `session-marker.md` § Direct-route | **leaves with S6** | R2, R4, R6 |
| D11 | `:375` | `session-marker.md` § Auto-mode done-condition | **stays in `/prime`** at 8c.2 | B13 |
| D12 | `:399` | `audit-discipline.md` | **deleted with `STRUCTURAL_RISK`** (S2) | no live `/prime` reference remains |

---

## 6. Drafted replacements — the budget's measured cells

Build applies these; it does not re-invent them. Counts are produced by parsing this file, not by hand.
**Outer fences are plan notation and are not counted** — v2's error at §§ 6.1 and 6.3.

### 6.1 — Step 0 replacement · Budget A · **12 lines**

````markdown
0. **Sync.** Run the sync owner from the repository root. It fetches, skips the pull when the repo is not
   behind, pulls with `--rebase --autostash`, aborts and restores on a conflicted rebase, classifies the
   outcome and counts unpushed commits — for this repo and for `ai-resources`. The behind-check removes an
   incident class; the four result shapes and the autostash-pop case: `docs/commit-discipline.md`
   § Orientation pull.

   ```bash
   AI_RESOURCES="/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources"
   SYNC=$(bash "$AI_RESOURCES/logs/scripts/prime-sync.sh")   # one line per repo: {repo} {result}
   ```

   Never stop on a sync failure. Step 6 shows `SYNC` only as an exception.
````

### 6.2 — Steps 1 / 1a / 1b / 1c / 1d replacement · Budget A · **36 lines**

````markdown
1. **Collect state.** Run the collector from the repository root. It performs every bounded read
   orientation needs — the last `session-notes.md` entry, the merged multi-repo commit set since that
   entry's date, the newest `logs/scratchpads/*-scratchpad.md`, the plan-position cascade, active
   missions, `logs/next-up.md`, the calling repository's identity, and the telemetry-gap test. Read
   bounds live in the collector, not here: `docs/heavy-read-discipline.md` § Bounded-read recipes.

   ```bash
   STATE=$(bash "$AI_RESOURCES/logs/scripts/prime-collect.sh")
   ```

   `STATE` carries labelled blocks — `CWD_REPO`, `LAST_ENTRY`, `NEXT_STEPS`, `COMMITS`, `SCRATCHPAD`,
   `POSITION`, `MISSIONS`, `NEXT_UP`, `TELEMETRY_GAP`. `CWD_REPO` is always present and names the calling
   repository; Step 8g's cross-repo guard consumes it. Any other block being absent means that source does
   not exist here: skip it silently, add no brief line, spend no menu slot. **Concurrent-session liveness
   is NOT collected here** — the SessionStart hook already reported it in this session's context; read
   that, and issue no scan. **The log-trio prefetch is gone**; `TELEMETRY_GAP` is a boolean the collector
   derives from its own bounded `usage-log.md` read, so the nudge survives without `/prime` reading either
   log (`ai-resources/CLAUDE.md` § Session Telemetry requires the nudge; it never required the prefetch).

1a. **Judge which Next Steps are done.** For each `NEXT_STEPS` bullet, test whether any `COMMITS` subject
   carries its distinctive keywords. Match → likely-DONE; keep it out of the menu. No match → still open;
   it becomes a carryover candidate. When in doubt, still-open. `/prime` never edits `session-notes.md`,
   so the operator can always check the source. The scan and its fall-through posture belong to
   `docs/backlog-reconciliation.md`; the classification is judgement and stays here.

1b. **Scratchpad.** When `SCRATCHPAD` is present, the first content line of its `## Resume With` section
   is a strong candidate for menu item 1, tagged `[carryover]`. No brief line of its own; never
   auto-resumes — the operator decides by picking it.

1c. **Plan position.** When `POSITION` is present, render it as the `Where we are:` block and derive a
   one-line readiness verdict from it plus the open questions in `LAST_ENTRY`. When absent — the normal
   shape in any repo without a plan — omit the block entirely rather than showing empty labels. The full
   readiness check belongs to `/project-next-steps`, not here.

1d. **Missions.** `MISSIONS` lists active missions as `{id, name, repo, open_threads[]}`. Carry it to
   Steps 5 and 6 and to the Step 8m binding sub-step. Empty is the common case: no prompt, no line, no item.
````

### 6.3 — Steps 8k + 8h replacement · Budget A · **18 lines**

````markdown
8h. **Session entry (shared sub-step — referenced by 8a / 8b / 8c).** One owner performs the complete
   sequence — allocate the marker, append this session's marker-bearing header, stamp the mtime — in that
   order. The order is load-bearing and is enforced inside the script rather than restated here. Takes one
   parameter, `WORK_DESC`. Run it after the caller's guards and before `/session-start`.

   ```bash
   MARKER_LINE=$(bash "$AI_RESOURCES/logs/scripts/prime-session-entry.sh" "$WORK_DESC") || exit 1
   TODAY="${MARKER_LINE%% *}"; MARKER="${MARKER_LINE#* }"
   ```

   **Located absolutely; runs against the current repository.** cwd owns the `logs/` it writes, so each
   checkout keeps its own marker sequence and the call resolves from every consumer, not only
   `ai-resources`. If any step fails the script exits non-zero and `|| exit 1` stops the branch before the
   next write; re-running `/prime` recovers, at the cost of one burned marker number. Marker grammar, the
   header shape and the ordering rule live in the script beside the code they guard, with
   `logs/scripts/prime-allocator.test.sh` as the tripwire. **Never reinline this logic:** code inside an
   executable prompt is validated by reading rather than by running, which is the defect the extraction
   fixed. Canonical protocol: `docs/session-marker.md`.
````

### 6.4 — Steps 8m / 8g / 8a / 8b / 8c and the new Step 9 · Budget A · **50 lines**

````markdown
8m. **Mission binding (shared sub-step — 8a / 8b / 8c).** Skip entirely when `MISSIONS` is empty. Run
   after the branch's guards and before `/session-start`. If the picked item is `[mission:<id>]`-sourced →
   `MISSION_ID = <id>`, auto-bound, no prompt. Otherwise emit one line listing the active missions and
   accept a number or `none`; default `none`. Carry it into the dispatch args as `{mission:<id>}`, which
   `/session-start` Step 1 strips and writes as the mandate's mission bullet.

8g. **Guards (shared sub-step — 8a / 8b / 8c).** Two, in this order, before any write.
   1. **Plan mode.** If a plan-mode reminder is in context, write nothing and output
      `{TASK_TEXT} noted. You're in plan mode — nothing written. Exit plan mode and re-send to proceed.`
      Then stop.
   2. **Cross-repo mission.** If the picked item is `[mission:<id>]`-sourced and that mission's repo (from
      `MISSIONS`) ≠ `CWD_REPO` (from `STATE`, Step 1), stop before any write: say the mission lives in
      `{repo}`, that setting it up here would write into the wrong repository, and that `here` overrides.
      Wait. On `here` proceed; on anything else stop, having written nothing. Same-repo picks skip
      silently. Derive the repo from `MISSIONS`, never from 8m — this guard must fire before 8h writes.

8a. **Numbered selection.** Resolve the number to its menu item → `TASK_TEXT`. Run 8g, then 8m, then 8h
   with `WORK_DESC = TASK_TEXT`. Dispatch: invoke `/session-start` with
   `"{gate:post-plan} {mission:<id>, if bound} TASK_TEXT"`. **`{gate:post-plan}` is mandatory on this
   branch** — `/session-start` Step 1 captures it, Step 4 forwards it (engineered) or branches on it
   (direct), and `/session-plan` Step 8 holds the pause and owns the `go` continuation. Without it the
   session begins executing a plan nobody approved (`logs/improvement-log.md` 2026-07-18). Then Step 9.

8b. **Free-text intent.** Resolve the operator's stated work → `TASK_TEXT`, keeping any inline scope bound.
   Run 8g, then 8m, then 8h with `WORK_DESC = TASK_TEXT`. Dispatch: invoke `/session-start` with
   `"{mission:<id>, if bound} TASK_TEXT"`. **Pass no `{gate:post-plan}` token** — its absence is what lets
   this branch proceed without a second confirmation, and that is 8b's only structural difference from 8a.
   Then Step 9.

8c. **Auto mode.** `auto` → menu item 1; `auto N` or `N auto` → item N. One item only.
   1. Validate N against the rendered menu range; on a miss ask once and re-classify. Empty menu →
      `No tracked next steps — auto mode needs a task. Tell me what to work on.` and stop.
   2. **Done-condition check.** The picked item must carry an observable deliverable — a file written, an
      item checked off, a count reached. An item naming only an activity ("review X", "look into Y") whose
      source line supplies no target fails: hold it, write nothing, and ask for a restatement carrying a
      deliverable. Rationale: `docs/session-marker.md` § Auto-mode done-condition check.
   3. Run 8g, then 8h with `WORK_DESC` = the picked item's text, then 8m in auto-bind-only mode — set
      `MISSION_ID` from a `[mission:<id>]` item without prompting, because auto mode holds one gate.
      *(Sub-steps 4–8 retired 2026-07-30; the numbering gap is deliberate — § 4.)*
   9. **Dispatch.** Invoke `/session-start` with
      `"{gate:auto} {plan:overwrite} {mission:<id>, if bound} {MANDATE_TEXT}"`, where `MANDATE_TEXT` is the
      picked item's work plus its deliverable and any stated bound. `/session-start` holds the single
      approval gate and, on `go`, writes the mandate and the manifest and reaches `/session-plan`, which
      writes the plan and begins execution. `{plan:overwrite}` pre-answers `/session-plan` Step 0 so the
      chain does not stop to ask. On `abort` nothing further is written; the session entry from 8h remains
      because it precedes the gate — say so. Then Step 9.

9. **Stop.** `/prime` ends at dispatch. Execution, the autonomy posture, the post-plan pause and its `go`,
   guardrail flags, between-item summaries and the wrap reminder all belong to `/session-start` and
   `/session-plan`. Do not begin work here, and do not chain into `/wrap-session`.
````

### 6.5 — `/wrap-session` promotion call site · **Budget B · +16**

````markdown
**Promote findings to the task queue.** After the feedback-collector step, run the promotion owner. It
sweeps every open `high` / `medium-high` / `critical` / `urgent` entry in this repo's `friction-log.md`
and `improvement-log.md`, and appends each one not already queued to `logs/next-up.md` as an unchecked
item carrying its source path and a content-derived promotion id.

   ```bash
   bash "$AI_RESOURCES/logs/scripts/promote-findings.sh"   # lock-serialised; safe to run concurrently
   ```

**It never writes the source logs.** Promotion identity lives in the destination, which keeps the sweep
inside `docs/commit-discipline.md` § Maintenance-owned in-place mutations — that rule forbids an ordinary
work session from reaching into an existing entry in these logs, and a `<!-- promoted -->` stamp would be
exactly that. It is **backward-looking**: findings from a session that never wrapped are picked up by the
next wrap **in that repository**; if no further wrap ever occurs there, they are never promoted. That is a
real reduction against the retired `/prime` Step 3, which re-grepped at every orientation. Replaces
`/prime` Step 3, retired 2026-07-30.
````

### 6.6 — `/session-plan` Step 8 replacement (lines 235–251) · **Budget B · 17 → 34 (+17)**

````markdown
**If `AUTO_GATE` is set** — reached through auto mode's chain (`/prime` 8c.9 → `/session-start` Step 4 →
here). Auto mode's single approval was taken at `/session-start` Step 2.6 and it covers execution, so this
branch does not pause. Emit:

> Plan written to `{OUTPUT_TARGET}` ({autonomy posture}). Begin execution.

Then **begin execution** under that posture and run § Post-plan execution below. *(Ownership moved here
2026-07-30: this branch previously returned to `/prime` 8c.11 / 8c.12, which no longer exist.)*

**If `POST_PLAN_GATE` is set** — the invoking branch declared a post-plan approval gate. Emit:

> Plan ready — review `{OUTPUT_TARGET}`. Reply `go` to start execution.

Then **stop and wait for the operator.** On `go`, begin execution under the declared posture and run
§ Post-plan execution. On anything else, do not start. *(The pause was always emitted here; the `go`
continuation moved here 2026-07-30 from `/prime` 8a.3.d.)*

**If `POST_PLAN_GATE` is unset** (the default — free-text intent via `/prime` 8b, a direct
`/session-plan` invocation, or `/session-start` invoked outside a gated branch), emit:

> Plan written to `{OUTPUT_TARGET}` ({autonomy posture}). Begin execution.

Then begin execution immediately and run § Post-plan execution. Do NOT emit a review handoff and do NOT
pause for operator confirmation.

**§ Post-plan execution — shared by all three branches, and by `/session-start` Step 4's direct route.**
Run the picked work in the operator-given order without pausing between items; emit a one-line
between-gate summary at each item boundary (workspace `Between-gate summaries`). Follow
`docs/compaction-protocol.md` checkpoints on long work and the workspace `Context constraint deferral`
rule rather than rushing to close. Surface `[SCOPE]` / `[HEAVY]` / `[AMBIGUOUS]` / `[COST]`. Size the
independent review to the change per `docs/qc-independence.md` — none fires automatically. Commit
directly per the workspace `Commit behavior` rule. On mandate completion emit `Mandate complete. Run
/wrap-session to capture telemetry and journal the session. Push pending — let me know when to push.` and
do not auto-invoke `/wrap-session` — the operator decides when to wrap.
````

### 6.7 — `/session-start` Step 4 direct branch (lines 445–452) · **Budget B · 8 → 26 (+18)**

````markdown
**Direct-route branch (Commit 2, 2026-07-23) — evaluate FIRST.** Compute `DIRECT` via the canonical
predicate (`docs/session-marker.md` § Direct-route detection — read the project-root `CLAUDE.md` for an
exact `**Execution route:** direct` line; `DIRECT=0` for engineered / absent / malformed / wrong-case). If
`DIRECT=1`, do **not** chain-invoke `/session-plan` and do **not** write a plan file — a direct-route
project gets no mandatory plan. Emit exactly:

```
Mandate written → logs/session-notes.md
Direct route — no auto-plan. `/session-plan` is opt-in (run it explicitly if this session needs a durable plan).
```

**This branch is the direct route's terminal owner.** There is no `/session-plan` hop behind it, so the
pause or the execution start belongs here. Branch on the token Step 1 captured:

- **`POST_PLAN_GATE` set** (a numbered pick) — emit `Mandate written — review it in
  logs/session-notes.md (this session's ## ${TODAY} — Session ${MARKER} block). Reply `go` to start
  execution, or run /session-plan first if you want a durable plan.` Then wait. On `go`, begin execution.
- **`POST_PLAN_GATE` unset** (free-text, or `/session-start` invoked directly) — begin execution
  immediately; the operator stating the work is the go signal.

Either way, run `/session-plan` § Post-plan execution for the posture, guardrail flags, between-item
summaries and the wrap reminder. *(Ownership moved here 2026-07-30 from `/prime` 8a.3.d / 8b.3.d. The
pre-2026-07-30 instruction to **ignore** `{gate:post-plan}` on the direct route is deliberately reversed:
with `/prime` stopping at dispatch, this token is the only thing that still distinguishes a numbered pick
from free-text on this route.)* Everything below Step 4 applies to the **engineered route (`DIRECT=0`)
only.**
````

### 6.8 — `/session-start` `STRUCTURAL_RISK` removals · **Budget B · −3**

| Site | Today | Action | Δ |
|---|---|---|---:|
| `:336-338` | `{if STRUCTURAL_RISK is true:}` + `**Risk-check**` + the "will run before execution" line | **delete** — `/risk-check` was retired 2026-07-30; this block promises a command that does not exist | **−3** |
| `:89` | "…`/prime` hands over `STRUCTURAL_RISK` alongside the token for that block." | delete the sentence | 0 |
| `:301` | "…holds exactly one gate covering the mandate, the context-pack outcome and the structural risk." | drop the final clause | 0 |
| `:349` | "`/prime` owns `STRUCTURAL_RISK` alone, because it owns the review-sizing disclosure that field drives. One field, one owner — …" | delete both sentences | 0 |

---

## 7. Known weaknesses of this plan

- **Four scripts do not exist yet.** Their correctness is unproven until each slice's Build unit runs.
  S5 carries the most novel logic and is sequenced late for that reason.
- **`prime-collect.sh` is the largest behavioural surface this stream creates** — five steps and four read
  disciplines. If any slice fails F-BEHAVE, it is S5.
- **Budget B rose 4× on inspection of the receiving owners.** It could rise again if a Build unit finds a
  further hand-back this plan's grep did not reach. The grep covered `/prime`-step citations; a downstream
  command that returns to `/prime` *without naming a step identifier* would be invisible to it. Named, not
  closed.
- **Promotion reachability is genuinely reduced** (§ 1 S3). Accepted with a stated trigger, not fixed.
- **Five of six marker partial states remain unassessed** (§ 5 F-RECOVER). Proportionate, and explicitly
  labelled rather than claimed.
- **This brief and all three plans are Claude-authored.** The removal list is a transcribed operator
  decision. Verification establishes that each target *exists* and what removing it *costs* — never that
  removing it is correct.
- **One premise in this stream was confirmed on a partial observation** (the `8c.2` row, § 4). The class
  of error — grepping for a string's presence and concluding something about its referent — was not
  systematically swept for elsewhere in the premise set.

---

## 8. Disposition of review-2's findings

One correction pass. A third round would be a chain and is not planned.

| # | Finding | Disposition | Where |
|---|---|---|---|
| M1 | S6's receiving owners do not own the transferred behaviour | **fixed** — all five hand-backs verified at HEAD and reassigned; `/session-plan` Step 8 and `/session-start` Step 4 rewritten and counted; the `{gate:post-plan}` ignore-instruction reversed; `8c.9` preserved via a numbering gap; Budget B recounted **+12 → +48** | § 1 S6, § 3, § 4, §§ 6.6–6.8 |
| M2 | Promotion sweep is sequentially idempotent, not concurrency-safe | **fixed, and beyond the finding** — source stamping withdrawn not only for the race but because `docs/commit-discipline.md` § Maintenance-owned in-place mutations **forbids** it; replaced by destination-side content-derived ids + `mkdir` lock + self-healing dedupe; F-PROMOTE-RACE (two simultaneous sweeps, with a positive control) and F-NO-SOURCE-WRITE added; never-wrapped stated as a **limitation**, not coverage | § 1 S3, § 5, § 6.5 |
| M3 | Drafted text is not a complete valid `/prime` | **fixed in part, rejected in part.** `CWD_REPO`: **fixed** — now the collector's first labelled block, F-CWDREPO added. Telemetry: **rejected** — see below | § 1 S5, § 4, § 5, § 6.2 |
| M4 | The reduced failure test's recovery table is inaccurate | **fixed** — table rebuilt on the real four-write sequence at `prime-marker.sh:140-158`; six partial states, not three; the per-id-marker state and its `detect-concurrent-session.sh` blast radius named; one injected failure retained and the other five explicitly `unassessed` with a reopen trigger | § 1 S1, § 5 |
| R3 | F-BEHAVE lacks downstream route outcomes | **fixed** — eight rows added (R1–R8) covering each route × engineered/direct, explicit `auto N`, and the wrap reminder on every terminal path; B14 retained only as the negative half | § 5 |
| — | Budget C says "three scripts" | **fixed** — four script owners: one extended, three new; the test script named as a fifth | § 0 |
| — | (found by this unit, not raised in review-2) `8c.2` recorded as a dangling citation | **rejected** — `session-marker.md:339` correctly cites the live done-condition check at `prime.md` 8c.2. The premise was confirmed on the string's presence without testing its referent. The v2 row is withdrawn; "fixing" it would have broken a correct citation | § 4, § 7 |

### M3's telemetry half — rejected, with the evidence

Review-2 states the operator "directed removed" the telemetry read **and** nudge, making review-1's M4
unfixed. **The removal list covers the log-trio prefetch at `prime.md:61-62`; it does not cover the
telemetry-gap nudge at `:67`,** which is a separate paragraph. Rejecting the wider reading on evidence:

> `ai-resources/CLAUDE.md` § Session Telemetry: *"To protect the baseline against a forgotten flag,
> `/prime` nudges at the next session's start when the previous substantive session left no
> `logs/usage-log.md` entry."*

The nudge is a standing obligation this repo's `CLAUDE.md` places **on `/prime` by name**. Deleting it
would put the plan in conflict with a canonical rule, and no operator instruction recorded in this stream
retires that rule.

**What was genuinely unfixed, and is now fixed:** v2 deleted the prefetch while keeping the nudge, and
never said how the nudge would still get its input — it simply emitted `TELEMETRY_GAP` from the collector
with no statement of the split. That is the defect review-1's M4 named. § 6.2 now states it explicitly:
the prefetch is gone, and the collector derives `TELEMETRY_GAP` from its own bounded read. The stale
parenthetical in `CLAUDE.md` describing *how* `/prime` reads the log is assigned to S5 (§ 4).

**This is the one place v3 declines a review-2 instruction, so it is an explicit G1 item.** If the
operator's settled direction was in fact to remove the nudge as well, the `CLAUDE.md` rule must be retired
in the same slice, and B12 plus the `TELEMETRY_GAP` block come out of § 6.2 — a further reduction to
Budget A, not an obstacle.
