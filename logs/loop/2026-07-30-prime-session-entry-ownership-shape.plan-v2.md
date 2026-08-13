PLAN v2
UNIT: 2026-07-30-prime-session-entry-ownership-shape
STREAM: 2026-07-30-prime-session-entry-ownership
PHASE: shape
REPO: ai-resources
BASE: 6cf5f4f
NEXT: Codex — review-2, then Claude holds G1

**Capability:** prime-runtime-delegation

Supersedes `…shape.plan.md` (v1), which is immutable and retained. v2 exists because review-1 returned
**REVISE BEFORE G1** with six material findings; § 8 records the disposition of each.

Object under work: `.claude/commands/prime.md`, **411 lines** at HEAD, byte-identical to the Frame unit's
object (`git diff 8c573af HEAD -- prime.md` → empty).

---

## 0. Three budgets, not one

v1 carried a single number and review-1 was right that it hid two different things. Delegation is only
real if the lines leaving `/prime` do not quietly reappear somewhere else that is also read by the model.
So v2 counts three separately:

| Budget | What it counts | Status |
|---|---|---|
| **A — `/prime` lines** | `wc -l .claude/commands/prime.md` | **the ≤300 target** |
| **B — other model-read prompts** | lines added to `wrap-session.md` and any other command a model reads at run time | **disclosed, not targeted** — must stay small and be justified |
| **C — script lines** | `.sh` files | **free** — never model-read; excluded from any target by design |

A move that lowers A by raising B is a relocation, not a delegation. B is reported at every gate so that
trade is visible rather than assumed.

The method that produced the v1 numbers is unchanged and is the point of this plan: every **subtraction**
is an exact count of lines that exist today, taken from a computed region map; every **addition** is
drafted in full (§ 6) and counted **by script**. v1's first hand-count of three blocks read 11/28/16 and
was wrong by 1–3 lines each — the same error class that produced the predecessor's 413. Nothing here is
hand-counted.

**Result: A = 186, against ≤300. B = +12 lines. C = three scripts.**

---

## 1. What will be done, in order

Six slices, one Build unit each. **All six are mandatory.** v1 called S6 "slack only"; review-1 (M1)
correctly identified that as drift — it would let S1–S5 hit the line target while leaving the retired
post-dispatch responsibilities in place, passing the proxy and failing the mandate.

### S1 — Complete the session-entry owner and fix the locator **(release blocker)**

Evidence, at two distinct levels — review-1 (Premise dimension) was right that v1 blurred them:

- **Observed.** One real consumer failure: `logs/improvement-log.md:2211-2219` records the
  `axcion-systems-builder` `/prime` failure and the manual absolute-path workaround.
- **Inferred.** That 31 further roots would fail is a deterministic filesystem inference from the census
  (32 roots carry the call, 1 holds the script), not 31 observed executions.

Additionally the owner performs one third of the sequence it was given: marker only; the header append
and the mtime stamp stayed in the prompt.

1. Extend `logs/scripts/prime-marker.sh` into `logs/scripts/prime-session-entry.sh`, taking `WORK_DESC`
   as `$1` and performing **marker → header append → mtime stamp** as one sequence. The script already
   *reads* `logs/session-notes.md` (`:83`, `:86`); this extends an existing reader into a writer.
2. Locate the script **absolutely** via the `AI_RESOURCES` literal `prime.md` already defines, leaving
   **cwd** as the consumer repository — so it writes into the *calling* repo's `logs/` and resolves from
   all 32 roots.
3. Collapse Steps 8k and 8h into the single retained identifier **8h**; `8k` is retired.
4. Repoint the 6 `8k` citations **semantically** (§ 4) and fix the dangling `8c.2` citation.
5. Retain `prime-allocator.test.sh` and **add** the session-entry tests below.

**"Single complete owner", not "atomic".** Review-1 (M2, second reservation) was right: v1 used *atomic*
while leaving partial states undefined. The word is withdrawn. What replaces it is a defined
failure/recovery semantic, which is the property that actually matters:

| Failure point | State left behind | Recovery on the next `/prime` |
|---|---|---|
| marker write fails | nothing written | script exits non-zero, caller `\|\| exit 1` aborts before any header |
| header append fails after marker write | `logs/.session-marker` holds `${TODAY} S${N}`; no header | next run allocates `S${N+1}` and writes its own header — the burned marker number is the only cost |
| mtime stamp fails after append | header present, `.prime-mtime` stale | `/session-start` Step 0.5 reads a stale mtime and reports a foreign write — visible, not silent |

**None of the three partial states is silent**, and all three are cleared by re-running `/prime`. That is
the claim F-RECOVER tests; it is not asserted here.

### S2 — Retire the removals that need no new owner

Pure deletions: multi-item auto mode (`auto 1,3`; `auto`/`auto N` retained), `STRUCTURAL_RISK` derivation
and its disclosure sub-step, the legacy `QC-PENDING` bullet, model-alignment reporting (mismatch nudge
**and** the plain `Model:` line).

**Sub-step identifiers inside 8c are preserved, not renumbered** — deleting 8c.8 and 8c.11 leaves gaps
rather than shifting 8c.9, which `session-start.md` cites four times.

Also assigned to this slice, and missing from v1 entirely (review-1 M4): **`session-plan.md:99`**, which
cites "`/prime` Step 4's model-alignment check" — the check this slice deletes.

### S3 — Establish the promotion owner, *then* retire Step 3

Step 3 is the only path by which a severity-tagged finding reaches the task menu. Review-1 (M2) was right
that v1's one-time migration preserved today's queue and not the loop.

**v1's `/wrap-session` proposal was weaker than v1 realised, and this is the correction.** Promotion at
wrap alone loses every finding written in a session that never wraps — today's Step 3 re-greps at *every*
`/prime`, so such findings are still found later. That is a regression, not a relocation.

The owner is therefore a **backward-looking, idempotent sweep**, not a this-session hook:

`logs/scripts/promote-findings.sh` — sweeps **every** open `high` / `medium-high` / `critical` / `urgent`
entry in this repo's `friction-log.md` and `improvement-log.md` that is **not already promoted**, and
appends each to this repo's `logs/next-up.md` as an unchecked item carrying its source path and line.

That single design answers all four coverage questions review-1 raised:

| Question | Answer |
|---|---|
| Which repo's `next-up.md`? | The repo the finding was logged in. Logs and `next-up.md` are both per-repo; no cross-repo write. |
| Promotion after findings are final? | Called from `/wrap-session` **after** the feedback-collector step, so the session's own findings are written first. |
| Duplicates? | Each promoted entry is stamped `<!-- promoted -->` in its source log; the sweep skips stamped entries. Idempotent by construction — running it twice promotes nothing twice. |
| A session that never wraps? | **Covered.** The sweep is backward-looking, so the *next* wrap in that repo picks up the missed entries. A skipped wrap costs a delay, not a loss. |

Order within the slice is fixed: **build the owner → run it → verify the queue → only then delete
Step 3.** Then update the **8 live citations** describing Step 3 as the reachability channel
(`session-feedback-collector.md:126`, `improve.md:60`, `leverage-idea.md:218`,
`resolve-improvement-log.md:33`, `resolve-incident.md:199`, `resolve-repo-problem.md:139`,
`ai-resources/.claude/commands/wrap-session.md:294`, workspace `.claude/commands/wrap-session.md:287`) to
name the promotion owner, and write the `logs/decisions.md` record that `prime.md:194` requires.

**Budget B is spent here:** the `/wrap-session` call site, drafted at § 6.5, is **11 lines**. With the one
line added to `session-start.md` in S6, that is the entire cost of the relocation — +12 model-read lines
against 225 removed from `/prime`.

### S4 — Move git synchronisation out

`logs/scripts/prime-sync.sh` owns fetch, the behind-check, the pull, rebase-conflict abort, the four
result classifications and the unpushed count, for the cwd repo and `ai-resources`. Step 0 becomes a call
and **keeps its identifier** (2 citations in `docs/commit-discipline.md`).

### S5 — Move mechanical state collection out

`logs/scripts/prime-collect.sh` owns the bounded `session-notes.md` last-entry read, the merged
multi-repo commit scan, the newest-scratchpad selection, the plan-position cascade, the active-mission
scan and `next-up.md`. Steps 1, 1a, 1b, 1c, 1d keep their identifiers and become thin judgement steps.

**`LIVE_FOREIGN` is removed from the collector's contract — v1 promised an output it could not
produce.** Review-1 (M3) is confirmed independently: `.claude/hooks/detect-concurrent-session.sh` emits
`{"systemMessage": …}` on stdout and persists **nothing** (0 persistent write sites; positive control:
`prime-marker.sh` has 11). A later shell process cannot read a transient message.

The correct reading of "consume the existing hook result" is therefore: **the hook's message is already
in the model's context at session start, so `/prime` consumes it in its judgement layer and issues no
scan at all.** This is strictly less work than v1 proposed, not more. F-HOOK (§ 5) is written to
distinguish consumption from a rescan, so a silent reintroduction of the scan fails the criterion.

### S6 — Transfer everything after dispatch **(mandatory)**

Review-1 (M1): v1 called this optional, gave it no drafted text, and omitted `session-start.md` and
`session-plan.md` from the touched surfaces. All three are corrected.

What leaves `/prime`, and to whom:

| Leaves | Current site | Receiving owner | Owner change needed? |
|---|---|---|---|
| The post-plan pause and `go` prompt | 8a.3.d | `/session-plan` Step 8, via the `{gate:post-plan}` token | **No** — already implemented; the token is the mechanism |
| Direct-route branching | 8a.3.c, 8b.3.c, 8c.10 | `/session-start` Step 4 | **No** — already owns `DIRECT` evaluation and the skip |
| Execution start, autonomy posture, guardrail flags, between-item summaries | 8b.3.d, 8c.12 | `/session-plan` (posture) + `/session-start` (dispatch) | **No** — both already state this |
| Plan-file existence prompt | 8a.3.c, 8b.3.c | `/session-plan` Step 0 | **No** — `{plan:overwrite}` already pre-answers it |
| Mandate-completion / wrap reminder | 8c.13 | `/session-start` | **Yes — one line to add** |

**Only one receiving owner needs a change**, which is why this slice is a transfer rather than a rebuild.
`/prime` ends at dispatch; a new terminal **Step 9 — Stop** makes that explicit and testable.

---

## 2. What it touches

| Surface | Slice | Nature | Budget |
|---|---|---|---|
| `.claude/commands/prime.md` | S1–S6 | object under work | **A** |
| `logs/scripts/prime-session-entry.sh` (from `prime-marker.sh`) | S1 | extended: reader → writer | C |
| `logs/scripts/prime-allocator.test.sh` | S1 | retained + extended (not merely repointed) | C |
| `logs/scripts/promote-findings.sh` | S3 | new | C |
| `logs/scripts/prime-sync.sh` | S4 | new | C |
| `logs/scripts/prime-collect.sh` | S5 | new | C |
| `.claude/commands/wrap-session.md` | S3 | +11 lines, the promotion call site | **B** |
| `.claude/commands/session-start.md` | S6 | +1 line (wrap reminder) | **B** |
| `.claude/commands/session-plan.md` | S2 | 1 citation repointed | — |
| `docs/session-marker.md` | S1 | 6 × `8k` semantic repoint + 1 dangling `8c.2` | — |
| 8 files citing `/prime` Step 3 | S3 | re-homed to the promotion owner | — |
| `logs/next-up.md` | S3 | receives promoted items | — |
| `logs/decisions.md` | S3 | one record | — |
| `development/prime-runtime-delegation.md` | S1 | `prime-marker.sh` references updated | — |
| 29 consumer checkouts | S1 | via symlink — no per-consumer edit | — |

Added since v1 on review-1 (M1, M4): `session-start.md`, `session-plan.md`, `wrap-session.md`,
`promote-findings.sh`, the capability record.

**Not touched:** the two genuinely distinct 33-line `prime.md` variants (`workflows/research-workflow`,
`axcion-sector-intelligence`); the `ai-resources-work-loop` worktree copy; `logs/missions/*`.

---

## 3. Budget A — the `/prime` line budget

Region map computed by parsing top-level step headers (`^\d+[a-z]?\. `) and differencing successive
positions; region sum + preamble = 411, matching `wc -l` exactly.

| Region | Now | After | Basis of the "after" cell |
|---|---:|---:|---|
| preamble | 10 | 10 | carried unchanged |
| Step 0 — pull | 44 | 13 | § 6.1 drafted, script-counted |
| Steps 1 + 1a + 1b + 1c + 1d — collection | 115 | 33 | § 6.2 drafted, script-counted |
| Step 2 — next-up | 2 | 2 | carried unchanged |
| Step 3 — urgent-log triage | 26 | 0 | whole-region deletion, exact |
| Step 4 — exception checks | 8 | 5 | lines 200–202 deleted, exact |
| Step 5 — menu | 16 | 15 | `[urgent]` bullet deleted, exact |
| Step 6 — brief template | 34 | 32 | model lines 227–228 deleted, exact |
| Step 7 — classify reply | 9 | 8 | multi-item bullet 261 deleted, exact |
| Steps 8k + 8h — session entry | 42 | 19 | § 6.3 drafted, script-counted |
| Steps 8m + 8a + 8b + 8c — dispatch | 105 | 49 | § 6.4 drafted, script-counted |
| **Total** | **411** | **186** | |

**Budget A = 186, against ≤300. Slack: 114 lines.**

Every "after" cell is either an exact deletion of lines that exist today or a `len(split('\n'))` count of
text drafted in § 6. No cell is an estimate, and no compression is credited that has not been written.

**Budget B = +11** (`wrap-session.md` § 6.5) **+1** (`session-start.md` wrap reminder) **= +12 lines** to
model-read prompts, against **−225** removed from `/prime`. **Budget C** — three scripts — is excluded by
design: `.sh` files are executed, never read into a model's context.

---

## 4. C2 renumbering — decided, and now fully assigned

**Decision, unchanged from v1 and endorsed by review-1 (Q2): preserve the identifier of every retained
step; repoint the citations of every retired identifier in the slice that retires it; never renumber to
close a gap.** Renumbering would convert 38 zero-cost sites into must-touch sites on a surface where a
missed edit fails silently.

Review-1 (M4) was right that v1 decided the policy and then left part of the work unassigned. Every one
of the 54 live citation sites now has an owning slice:

| Identifier | Sites | Fate | Slice |
|---|---:|---|---|
| `0`, `1`, `1a`, `1b`, `1c`, `1d` | 21 | retained → **0 to touch** | — |
| `8`, `8a`, `8m`, `8h`, `8c.9` | 18 | retained → **0 to touch** | — |
| `3` | 8 | retired → repoint to the promotion owner | **S3** |
| `8k` | 6 | retired → **semantic** repoint (below) | **S1** |
| `4` (model check) | 1 | retired → `session-plan.md:99` | **S2** |
| `8c.2` | 1 | already dangling → fix | **S1** |
| **Total** | **54** | **16 touched, 38 untouched** | |

**The six `8k` citations are not a find-and-replace.** Review-1 (M4) was right: they say different things
and need different targets.

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
recorded `unassessed` — never `pass`. The predecessor left thirteen in that state; the changes below
target exactly that failure mode.

### Stream-level

- **F-LINES.** `wc -l .claude/commands/prime.md` > 300 after S1–S6. Budget B is reported alongside; a fall
  in A bought by a rise in B larger than the drafted +12 is a **finding**, not a pass.
- **F-ROUTES.** Any of the three retained routes — numbered selection, free-text intent, single-item
  `auto` — fails when exercised **from a named real project-consumer root**, not `ai-resources` and not a
  fixture. Each must be observed to reach `/session-start` carrying the right mandate.
- **F-LOCATOR.** A `/prime` from a consumer root fails to resolve a script, or writes marker / header /
  mtime into `ai-resources` instead of the calling repo. Both halves observed. **Run once from a path
  containing a space** — review-1's permissions point; the workspace path already contains one.

### Replacing F-RULES — the retained-behaviour register

v1's F-RULES asked to "extract every executable rule" from mixed Markdown prose. Review-1 (M6) was right
that this is not well-defined, and that its positive control proved only that the extractor notices one
deletion chosen in advance. It is withdrawn.

**F-BEHAVE** replaces it: a bounded register of the behaviours that must survive, each bound to one named
observation. Scope is the retained routes and guards — **not** every line.

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

**F-BEHAVE is falsified** if any row cannot be observed, or is observed to differ from its pre-change
behaviour. B14 is the criterion S6 exists to satisfy.

### S1-specific

- **F-ENTRY.** After **one** call to `prime-session-entry.sh`: (a) `logs/.session-marker` and the per-id
  marker written; (b) `## ${TODAY} — Session ${MARKER}` present in `logs/session-notes.md` with
  `WORK_DESC` beneath it; (c) `logs/.prime-mtime` written. All three, or falsified. The predecessor's
  owner only ever did (a), which is why it could not state this.
- **F-ORDER — rebuilt.** v1's version was not a valid oracle, and review-1 (M5) was right about why:
  `stat -f %m` truncates to whole seconds, so "mtime after append" is indistinguishable from "before"
  inside one second. Replaced by two checks that do not depend on clock resolution: (i) the appended
  header **contains `${MARKER}`**, which is only possible if allocation preceded the append; (ii)
  `.prime-mtime` equals the file's mtime read **after** the append, compared at **sub-second resolution**
  (`stat -f %Fm`), and the test appends a second entry to prove the comparison can fail.
- **F-RECOVER.** Inject a failure at the header-append step with the marker already written; observe the
  state matches the S1 table, and that a subsequent `/prime` allocates `S${N+1}` and completes. **One
  injected failure, not a matrix** — the other two partial states are covered by the table and by
  F-ENTRY, and a full matrix is disproportionate to a fault whose worst case is visible at session start.
- **F-TESTS.** `prime-allocator.test.sh` is **retained and extended**, not repointed-and-declared-covered
  (review-1 M5). It must hold its 19 existing assertions **and** add: fresh-header append, same-marker
  reinvocation, exact `WORK_DESC` text, mtime-after-append at sub-second resolution, and the F-RECOVER
  injection. Green is load-bearing only if shown able to fail: mutate the fail-safe seed, observe red,
  restore, observe green.

### S3-specific

- **F-BACKLOG (migration).** Every item the pre-change Step 3 would have surfaced appears in
  `next-up.md` afterwards. Enumerate the pre-change emit, then diff.
- **F-LOOP (continuation).** Review-1 (M2) was right that migration alone proves nothing about the
  future. **Write a new qualifying finding after the change, run the owner, and observe it reach
  `next-up.md`.** Then run the owner **again** and observe it is *not* duplicated. Both halves, or the
  loop is not proven live.

### S5-specific

- **F-HOOK.** The concurrent-session advisory still fires when a foreign session is live, **and**
  `prime-collect.sh` issues no marker-file scan of its own — verified by inspecting the script for any
  `logs/.session-marker-*` read. Consumption and rescan produce the same advisory, so the criterion tests
  the mechanism, not just the output.

### F-DUP — the register, now with fates and behaviour checks

Review-1 (M6) was right that v1's register proved referential integrity only: that a cited section still
exists says nothing about whether the duplicated behaviour survived. Each row now carries an expected
fate **and** a check on that fate.

| # | Site (HEAD) | Owner it defers to | Expected fate | Check |
|---|---|---|---|---|
| D1 | `:28` | `commit-discipline.md` § Orientation pull | → `prime-sync.sh` (S4) | behind-check still skips a pull on an up-to-date repo |
| D2 | `:64–65` | `heavy-read-discipline.md` § Step 1 | → `prime-collect.sh` (S5) | last-entry read still anchored on `^## [0-9]`, not last-N-lines |
| D3 | `:71` | `backlog-reconciliation.md` | scan → collector; classification stays (S5) | merged set still spans cwd + ai-resources + siblings |
| D4 | `:122` | `session-marker.md` § Concurrent detection | → hook message in judgement layer (S5) | F-HOOK |
| D5 | `:135` | `project-next-steps.md` Step 2 | → `prime-collect.sh` (S5) | position-before-spine inversion preserved |
| D6 | `:135` | `heavy-read-discipline.md` § Step 1c | → `prime-collect.sh` (S5) | plan file still bounded-read, never full-read |
| D7 | `:187` | `heavy-read-discipline.md` § Step 3 | **deleted with Step 3** (S3) | section no longer cited by any live file |
| D8 | `:194` | `wrap-session` 12e · collector `:138` · `improvement-log:13` | **deleted with Step 3** (S3) | the three writer contracts repointed to the promotion owner |
| D9 | `:274` | `session-marker.md` protocol | → `prime-session-entry.sh` (S1) | F-ENTRY + F-ORDER |
| D10 | `:336`/`:361`/`:395` | `session-marker.md` § Direct-route | **leaves with S6** | `/session-start` Step 4 still evaluates `DIRECT` |
| D11 | `:375` | `session-marker.md` § Auto-mode done-condition | **stays in `/prime`** | B13 |
| D12 | `:399` | `audit-discipline.md` | **deleted with `STRUCTURAL_RISK`** (S2) | no live `/prime` reference remains |

**Twelve, not eight.** The predecessor asserted "eight declarations" and never listed them, so no check
could bind to them; this register replaces that claim rather than reconciling with it.

---

## 6. Drafted replacements — the budget's measured cells

Build applies these; it does not re-invent them. Counts are produced by parsing this file, not by hand.

### 6.1 — Step 0 replacement · Budget A

```markdown
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
```

### 6.2 — Steps 1 / 1a / 1b / 1c / 1d replacement · Budget A

```markdown
1. **Collect state.** Run the collector from the repository root. It performs every bounded read
   orientation needs — the last `session-notes.md` entry, the merged multi-repo commit set since that
   entry's date, the newest `logs/scratchpads/*-scratchpad.md`, the plan-position cascade, active
   missions and `logs/next-up.md`. Read bounds live in the collector, not here:
   `docs/heavy-read-discipline.md` § Bounded-read recipes.

   ```bash
   STATE=$(bash "$AI_RESOURCES/logs/scripts/prime-collect.sh")
   ```

   `STATE` carries labelled blocks — `LAST_ENTRY`, `NEXT_STEPS`, `COMMITS`, `SCRATCHPAD`, `POSITION`,
   `MISSIONS`, `NEXT_UP`, `TELEMETRY_GAP`. An absent block means that source does not exist here: skip it
   silently, add no brief line, spend no menu slot. **Concurrent-session liveness is NOT collected here**
   — the SessionStart hook already reported it in this session's context; read that, and issue no scan.

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
```

### 6.3 — Steps 8k + 8h replacement · Budget A

```markdown
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
   atomic claim, the header shape and the ordering rule live in the script beside the code they guard,
   with `logs/scripts/prime-allocator.test.sh` as the tripwire. **Never reinline this logic:** code inside
   an executable prompt is validated by reading rather than by running, which is the defect the extraction
   fixed. Canonical protocol: `docs/session-marker.md`.
```

### 6.4 — Steps 8m / 8a / 8b / 8c replacement, plus the new Step 9 · Budget A

```markdown
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
      `MISSIONS`) ≠ `CWD_REPO`, stop before any write: say the mission lives in `{repo}`, that setting it
      up here would write into the wrong repository, and that `here` overrides. Wait. On `here` proceed;
      on anything else stop, having written nothing. Same-repo picks skip silently. Derive the repo from
      `MISSIONS`, never from 8m — this guard must fire before 8h writes.

8a. **Numbered selection.** Resolve the number to its menu item → `TASK_TEXT`. Run 8g, then 8m, then 8h
   with `WORK_DESC = TASK_TEXT`. Dispatch: invoke `/session-start` with
   `"{gate:post-plan} {mission:<id>, if bound} TASK_TEXT"`. **`{gate:post-plan}` is mandatory on this
   branch** — `/session-start` Step 1 captures it, Step 4 forwards it, and `/session-plan` Step 8 branches
   on it to hand control back to the operator instead of auto-executing. Without it the session begins
   executing a plan nobody approved (`logs/improvement-log.md` 2026-07-18). Then go to Step 9.

8b. **Free-text intent.** Resolve the operator's stated work → `TASK_TEXT`, keeping any inline scope bound.
   Run 8g, then 8m, then 8h with `WORK_DESC = TASK_TEXT`. Dispatch: invoke `/session-start` with
   `"{mission:<id>, if bound} TASK_TEXT"`. **Pass no `{gate:post-plan}` token** — its absence is what lets
   this branch proceed without a second confirmation, and that is 8b's only structural difference from 8a.
   Then go to Step 9.

8c. **Auto mode.** `auto` → menu item 1; `auto N` or `N auto` → item N. One item only.
   1. Validate N against the rendered menu range; on a miss ask once and re-classify. Empty menu →
      `No tracked next steps — auto mode needs a task. Tell me what to work on.` and stop.
   2. **Done-condition check.** The picked item must carry an observable deliverable — a file written, an
      item checked off, a count reached. An item naming only an activity ("review X", "look into Y") whose
      source line supplies no target fails: hold it, write nothing, and ask for a restatement carrying a
      deliverable. Rationale: `docs/session-marker.md` § Auto-mode done-condition check.
   3. Run 8g, then 8h with `WORK_DESC` = the picked item's text, then 8m in auto-bind-only mode — set
      `MISSION_ID` from a `[mission:<id>]` item without prompting, because auto mode holds one gate.
   4. Dispatch: invoke `/session-start` with
      `"{gate:auto} {plan:overwrite} {mission:<id>, if bound} {MANDATE_TEXT}"`, where `MANDATE_TEXT` is the
      picked item's work plus its deliverable and any stated bound. `/session-start` holds the single
      approval gate and, on `go`, writes the mandate, the manifest and the plan. `{plan:overwrite}`
      pre-answers `/session-plan` Step 0 so the chain does not stop to ask. On `abort` nothing further is
      written; the session entry from 8h remains because it precedes the gate — say so. Then go to Step 9.

9. **Stop.** `/prime` ends at dispatch. Execution, the autonomy posture, review sizing, guardrail flags,
   between-item summaries and the wrap reminder all belong to `/session-start` and `/session-plan`. Do not
   begin work here, and do not chain into `/wrap-session`.
```

### 6.5 — `/wrap-session` promotion call site · **Budget B**

```markdown
**Promote findings to the task queue.** After the feedback-collector step, run the promotion owner. It
sweeps every open `high` / `medium-high` / `critical` / `urgent` entry in this repo's `friction-log.md`
and `improvement-log.md` that is not already stamped `<!-- promoted -->`, appends each to
`logs/next-up.md` as an unchecked item carrying its source path and line, and stamps the source.

   ```bash
   bash "$AI_RESOURCES/logs/scripts/promote-findings.sh"   # idempotent; safe to run twice
   ```

It is **backward-looking**: a session that never wrapped is picked up by the next wrap in that repo, so a
skipped wrap costs a delay, not a lost finding. This replaces `/prime` Step 3, retired 2026-07-30.
```

---

## 7. Known weaknesses of this plan

- **Three scripts do not exist yet.** Their correctness is unproven until each slice's Build unit runs.
  S5 carries the most novel logic and is sequenced late for that reason.
- **`prime-collect.sh` is the largest behavioural surface this stream creates** — five steps and four read
  disciplines. If any slice fails F-BEHAVE, it is S5.
- **This brief and plan are Claude-authored.** The removal list is a transcribed operator decision.
  Verification establishes that each target *exists* and what removing it *costs* — not that removing it
  is correct.
- **The promotion owner changes who is responsible for reachability.** Today the reader (`/prime`) finds
  findings; afterwards the sweep promotes them. The sweep is idempotent and backward-looking, so a missed
  run self-heals — but a finding written with no severity field is invisible to both designs, before and
  after. That pre-existing gap is not closed by this plan and is named rather than fixed.
- **B14 (`/prime` stops at dispatch) is the hardest row to observe**, because "nothing happened next" is a
  negative. It is checked by running each route and confirming the turn ends at the dispatch call, with a
  positive control: a deliberately reinstated post-dispatch instruction must make the row fail.

---

## 8. Disposition of review-1's findings

One correction pass, per `docs/work-loop.md` § The challenged route. A third round would be a chain and
is not planned.

| # | Finding | Disposition | Where |
|---|---|---|---|
| M1 | S6 optional though it is required architecture | **fixed** — S6 mandatory, transfer table, receiving owners named, B14 added | § 1 S6, § 2, § 5 |
| M2 | S3 migrates the backlog but breaks the future loop | **fixed, and beyond the finding** — owner is an idempotent backward-looking sweep, which also answers the never-wrapped case; F-LOOP added | § 1 S3, § 5 |
| M3 | Collector cannot consume a transient hook message | **fixed** — confirmed independently (0 persistent writes vs 11 in the positive control); `LIVE_FOREIGN` removed, F-HOOK added | § 1 S5, § 6.2 |
| M4 | Removal and citation inventories not closed | **fixed** — all 54 sites assigned; `8k` repointed semantically; `session-plan.md:99` assigned to S2; telemetry split stated; capability record added | § 2, § 4 |
| M5 | Test package does not prove the new owner | **fixed in part, reduced in part** — tests added, F-ORDER rebuilt on a sub-second oracle, "atomic" withdrawn for a defined recovery semantic. **One** injected failure, not a matrix: `deferred` on proportionality, reopening if a partial state is ever observed in real use | § 1 S1, § 5 |
| M6 | F-RULES and F-DUP cannot support their claims | **fixed in part, reduced in part** — F-RULES withdrawn for the 14-row F-BEHAVE register bound to route observations; every D-row gains a fate and a behaviour check. Bounded to routes and guards rather than an inventory of every rule, which review-1 itself argues is undefinable | § 5 |
| — | Budget A must be counted separately from additions elsewhere | **fixed** — three budgets; B disclosed at every gate | § 0, § 3 |
| — | Problem reality states observed and inferred separately | **fixed** | § 1 S1 |
