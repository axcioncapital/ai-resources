PLAN
UNIT: 2026-07-30-prime-session-entry-ownership-shape
STREAM: 2026-07-30-prime-session-entry-ownership
PHASE: shape
REPO: ai-resources
BASE: 4826796
NEXT: Codex — review this plan, then Claude holds G1

**Capability:** prime-runtime-delegation

Object under work: `.claude/commands/prime.md`, **411 lines** at HEAD, byte-identical to the Frame
unit's object (`git diff 8c573af HEAD -- prime.md` → empty).

---

## 0. What this plan fixes about the last one

The predecessor stream promised ≤300 and delivered 413. The cause was not ambition; it was a budget in
which **fifteen of seventeen regions were estimates**, so the shortfall was invisible until Build had
spent the slice list. This plan is built so that failure mode cannot repeat:

- Every **subtraction** is an exact count of lines that exist today, taken from a computed region map
  (§ 3), not from reading.
- Every **addition** is a call site **drafted in full below** (§ 6) and counted with `wc -l`, not sized
  by feel.
- Every region this plan does **not** touch is carried at **its full current size**. The budget claims
  no compression it has not written. Steps 5, 6, 7, 8m, 8a, 8b, 8c and the preamble are all carried at
  100% — any compression there is upside the budget does not spend.

The resulting figure is therefore a **ceiling, not a target**: **237 lines**, against a ≤300 requirement,
with 63 lines of unspent slack. If the one optional slice is dropped entirely, the target is still met.

---

## 1. What will be done, in order

Six slices, one Build unit each. Order is by *risk retired per line changed*, not by file order.

### S1 — Complete the session-entry owner and fix the locator **(release blocker)**

The G2 decline rested on one fact: `bash logs/scripts/prime-marker.sh` is a repository-relative path,
and the script exists in exactly 1 of the 32 roots that carry the call. Additionally the owner performs
one third of the sequence it was asked to own — marker only; the header append and the mtime stamp stayed
in the prompt.

1. Extend `logs/scripts/prime-marker.sh` into `logs/scripts/prime-session-entry.sh`, taking `WORK_DESC`
   as `$1` and performing **marker → header append → mtime stamp** as one sequence. The script already
   *reads* `logs/session-notes.md` (`:83`, `:86`) for its same-day increment scan, so this extends an
   existing reader into a writer rather than introducing a new dependency.
2. Change the call site to locate the script **absolutely** via the `AI_RESOURCES` literal `prime.md`
   already defines, while leaving **cwd** as the consumer repository — so the script writes into the
   *calling* repo's `logs/`, which is the correct ownership, and resolves from all 32 roots.
3. Collapse Steps 8k and 8h into the single retained identifier **8h**. `8k` is retired.
4. Repoint the 6 live citations of `Step 8k` and the 1 dangling citation of `Step 8c.2`
   (`docs/session-marker.md:339`) in the same commit.
5. Repoint `logs/scripts/prime-allocator.test.sh` at the new script and hold it at 19/0.

**Why first:** it is the only slice that closes the release blocker, it is the smallest of the three
move-outs, and every later slice inherits the absolute-locator pattern from it.

### S2 — Retire the removals that need no new owner

Pure deletions, no replacement component: multi-item auto mode (`auto 1,3`; `auto`/`auto N` retained),
`STRUCTURAL_RISK` derivation and its disclosure sub-step, the legacy `QC-PENDING` bullet, and
model-alignment reporting (both the mismatch nudge and the plain `Model:` line).

**Sub-step identifiers inside 8c are preserved, not renumbered** — deleting 8c.8 and 8c.11 leaves gaps
rather than shifting 8c.9, whose identifier `session-start.md` cites four times.

### S3 — Retire Step 3 and re-home its backlog channel

Step 3 is the *only* path by which a `HIGH` / `medium-high` finding reaches the task menu. Deleting it
without re-homing that traffic would silently remove the mechanism eight other files depend on. So this
slice is ordered: **promote first, delete second.**

1. Sweep `logs/friction-log.md` and `logs/improvement-log.md` for open `high` / `medium-high` /
   `critical` / `urgent` items and promote each into `logs/next-up.md` as an unchecked item — the
   authoritative task source Step 2 already reads.
2. Delete Step 3 (26 lines) and Step 5's `[urgent]` candidate bullet.
3. Update the **8 live citations** that describe Step 3 as the reachability channel:
   `session-feedback-collector.md:126`, `improve.md:60`, `leverage-idea.md:218`,
   `resolve-improvement-log.md:33`, `resolve-incident.md:199`, `resolve-repo-problem.md:139`,
   `ai-resources/.claude/commands/wrap-session.md:294`, workspace `.claude/commands/wrap-session.md:287`.
4. Write the `logs/decisions.md` record. `prime.md:194` requires one for merely *narrowing* the
   `medium-high` tier; retiring the scan outright is the stronger change and inherits the requirement.

**This is the one slice with a behaviour consequence the operator should see stated plainly:** after it,
nothing auto-surfaces a severity-tagged finding at orientation. Reaching the menu becomes an explicit act
of promotion into `next-up.md`. That is the operator's decided architecture — an authoritative task
source instead of triage-at-orientation — and it is named here as a consequence, not re-argued.

### S4 — Move git synchronisation out

`logs/scripts/prime-sync.sh` owns fetch, the behind-check, the pull, rebase-conflict abort, the four
result classifications and the unpushed count, for the cwd repo and `ai-resources`. Step 0 becomes a
call. Identifier `0` is retained (2 citations in `docs/commit-discipline.md`).

### S5 — Move mechanical state collection out

`logs/scripts/prime-collect.sh` owns: the bounded `session-notes.md` last-entry read, the merged
multi-repo commit scan, the newest scratchpad selection, the plan-position cascade, the active-mission
scan, `next-up.md`, and — instead of rescanning — the concurrent-session result the SessionStart hook
already computes. Steps 1, 1a, 1b, 1c, 1d keep their identifiers and become thin judgement steps over the
collector's labelled output. **The judgement halves stay in the prompt**: which Next Steps are done, the
readiness verdict, and menu candidacy. This is the split D3 already found to be the correct seam for
Step 1a — the scan is mechanical, the keyword classification is not.

### S6 — Move post-dispatch out, then compress the retained half **(slack only)**

Everything after successful dispatch, plus the planning / direct-route / approval-token machinery, moves
to `/session-start` and `/session-plan`; the retained dispatch half is compressed. **The budget assigns
this slice zero credit.** If it is dropped entirely, ≤300 is still met. It is listed so the scope is
honest, not because the target depends on it.

---

## 2. What it touches

| Surface | Slices | Nature |
|---|---|---|
| `.claude/commands/prime.md` | S1–S6 | the object under work |
| `logs/scripts/prime-session-entry.sh` (from `prime-marker.sh`) | S1 | extended: reader → writer |
| `logs/scripts/prime-allocator.test.sh` | S1 | repointed; must hold 19/0 |
| `logs/scripts/prime-sync.sh` | S4 | new |
| `logs/scripts/prime-collect.sh` | S5 | new |
| `docs/session-marker.md` | S1 | 6 × `8k` + 1 dangling `8c.2` repointed |
| 8 files citing `/prime` Step 3 | S3 | re-homed to `next-up.md` |
| `logs/next-up.md` | S3 | receives promoted HIGH items |
| `logs/decisions.md` | S3 | one record |
| 29 consumer checkouts | S1 | via symlink — no per-consumer edit |

**Not touched:** the two genuinely distinct 33-line `prime.md` variants (`workflows/research-workflow`,
`axcion-sector-intelligence`); the `ai-resources-work-loop` worktree copy; `logs/missions/*`.

---

## 3. The measured line budget

Region map computed from `prime.md` at HEAD by parsing top-level step headers (`^\d+[a-z]?\. `) and
differencing successive header positions; region sum + preamble = 411, matching `wc -l` exactly.

| # | Region | Now | After | Δ | Basis of the "after" cell |
|---|---|---:|---:|---:|---|
| 1 | Step 0 — pull | 44 | 13 | **−31** | call site drafted § 6.1 · counted 12 + 1 separator |
| 2 | Steps 1 + 1a + 1b + 1c + 1d — collection | 115 | 32 | **−83** | call site + retained judgement drafted § 6.2 · counted 31 + 1 |
| 3 | Step 3 — urgent-log triage | 26 | 0 | **−26** | whole-region deletion, exact |
| 4 | Step 4 — model-alignment bullet | 8 | 5 | **−3** | lines 200–202 deleted, exact |
| 5 | Steps 8k + 8h — session entry | 42 | 18 | **−24** | call site drafted § 6.3 · counted 17 + 1 |
| 6 | Step 7 + 8c.1 — multi-item auto bullets | — | — | **−2** | lines 261, 371 deleted, exact |
| 7 | 8c.8 + 8c.11 — `STRUCTURAL_RISK` | — | — | **−2** | two whole sub-steps deleted, exact |
| 8 | Step 6 — model lines | — | — | **−2** | lines 227, 228 deleted, exact |
| 9 | Step 5 — `[urgent]` candidate bullet | — | — | **−1** | line 211 deleted, exact |
| | **Total** | | | **−174** | |

**411 − 174 = 237.** Rounded against this plan's own interest: **≤240**.

The three "after" cells were **counted by script, not by hand** — a first hand-count of the same three
blocks read 11 / 28 / 16 and was wrong by 1–3 lines each, which is the identical error class that produced
the predecessor's 413. The counts above come from parsing the fenced blocks out of this file and taking
`len(split('\n'))`, plus one blank separator line per block.

Carried at **full current size**, with no compression credited: preamble (10), Step 2 (2), Step 4 residue
(5), Step 5 (15), Step 6 (32), Step 7 (8), Step 8m (9), Step 8a (33), Step 8b (17), Step 8c (43).

**Slack against ≤300: 63 lines.** For the target to be missed, the drafted call sites would have to come
in more than **2× larger** than drafted, or a removal would have to be blocked outright. Both are
falsifiable at Build, per slice, by `wc -l` — see § 5.

---

## 4. The C2 renumbering reconciliation — decided

**Decision: preserve the identifier of every retained step. Repoint the citations of every retired
identifier, in the same slice that retires it. Never renumber to close a gap.**

Measured basis — the live citation surface is **54 sites across 17 files** (excludes `audits/` and
`logs/`, which are historical records, not live contracts; the enumerating grep was positive-controlled
against the known dangling `8c.2`):

| Identifier | Live citations | Fate under this plan |
|---|---:|---|
| `0` | 2 | retained (thin call) → 0 to touch |
| `1` | 4 | retained → 0 |
| `1a` | 9 | retained → 0 |
| `1b` | 2 | retained → 0 |
| `1c` | 1 | retained → 0 |
| `1d` | 3 | retained → 0 |
| `3` | 8 | **retired** → 8 to repoint (S3) |
| `4` | 2 | retained; 1 cites the removed model check → 1 to repoint |
| `8` / `8a` / `8m` | 12 | retained → 0 |
| `8c.9` | 4 | retained (gaps left at 8c.8 / 8c.11) → 0 |
| `8h` | 2 | retained → 0 |
| `8k` | 6 | **retired** into `8h` → 6 to repoint (S1) |
| `8c.2` | 1 | already dangling → 1 fixed (S1) |
| | **54** | **16 touched, 38 untouched** |

Renumbering to a clean sequence would convert all 38 zero-cost sites into must-touch sites — 38 edits
across 17 files bought for cosmetic tidiness, on a surface where a missed edit fails silently. Gaps in
the numbering cost nothing a reader notices.

---

## 5. What would falsify this plan

Judged at Prove against these criteria, each naming what must be **run** and what must be **observed**.
A criterion whose check cannot be run is recorded `unassessed` — never `pass`.

### Stream-level

- **F-LINES.** `wc -l .claude/commands/prime.md` > 300 after S1–S5. Falsifies the budget.
- **F-ROUTES.** Any of the three retained routes — numbered selection, free-text intent, single-item
  `auto` — fails when exercised **from a real project-consumer root** (not `ai-resources`, not a
  fixture). Each must be run and observed to reach `/session-start` with the right mandate.
- **F-LOCATOR.** A `/prime` from a consumer root fails to resolve any of the three scripts, or writes a
  marker / header / mtime into `ai-resources` instead of the calling repo. Both halves must be observed:
  resolution succeeded **and** the writes landed in the caller's `logs/`.
- **F-RULES.** Any executable rule present at `411` is absent afterwards without being re-homed to a
  named owner. Method: extract every invocation and assignment before and after, diff, and account for
  every delta. **The check must first be shown able to fail** — run it against a copy with one known rule
  deleted and confirm it reports that deletion.

### S1-specific — the complete sequence, not just the marker

- **F-ENTRY.** After **one** call to `prime-session-entry.sh`, any of the three effects is missing:
  (a) `logs/.session-marker` and the per-id marker written; (b) `## ${TODAY} — Session ${MARKER}`
  present in `logs/session-notes.md` with `WORK_DESC` beneath it; (c) `logs/.prime-mtime` equal to
  `session-notes.md`'s mtime **after** the append. All three observed, or the slice is falsified. This is
  the criterion the predecessor could not state, because its owner only ever did (a).
- **F-ORDER.** The three effects occur out of order — provable by a header lacking `${MARKER}`, or a
  `.prime-mtime` earlier than the append.
- **F-TRIPWIRE.** `bash logs/scripts/prime-allocator.test.sh` is not 19 passed / 0 failed against the new
  script — **and** the suite must be shown able to fail, by mutating the fail-safe seed and observing a
  red run, exactly as the 2026-07-29 control did.

### S3-specific

- **F-BACKLOG.** Any item that would have reached the menu through Step 3 before the change does not
  appear in `logs/next-up.md` after it. Enumerate the pre-change Step 3 emit, then diff against
  `next-up.md`.

### F-DUP successor — the enumerated declaration register

The predecessor recorded F-DUP `unassessed` because its plan asserted "eight duplication declarations"
and never listed them, so no check could bind to them. **This plan enumerates them literally.** Each is a
place where `prime.md` states content another file owns; after every slice, each row must still resolve
to a live owner, or be gone along with the text that needed it.

| # | Declaration site (HEAD) | Owner it defers to |
|---|---|---|
| D1 | `:28` | `docs/commit-discipline.md` § Orientation pull |
| D2 | `:64–65` | `docs/heavy-read-discipline.md` § Bounded-read recipes → Step 1 |
| D3 | `:71` | `docs/backlog-reconciliation.md` (declares `/prime` the *reference implementation*) |
| D4 | `:122` | `docs/session-marker.md` § Concurrent-session detection |
| D5 | `:135` | `project-next-steps.md` Step 2 → `skills/session-guide-generator/SKILL.md` Step 2 |
| D6 | `:135` (second clause) | `docs/heavy-read-discipline.md` § Bounded-read recipes → Step 1c |
| D7 | `:187` | `docs/heavy-read-discipline.md` § Bounded-read recipes → Step 3 |
| D8 | `:194` | `wrap-session.md` Step 12e · `session-feedback-collector.md:138` · `improvement-log.md:13` |
| D9 | `:274` | `docs/session-marker.md` (marker protocol, canonical) |
| D10 | `:336` / `:361` / `:395` | `docs/session-marker.md` § Direct-route detection |
| D11 | `:375` | `docs/session-marker.md` § Auto-mode done-condition check |
| D12 | `:399` | `docs/audit-discipline.md` (structural change classes) |

**Twelve, not eight.** The predecessor's "eight" was never enumerated and so was never verifiable; this
register replaces it rather than reconciling with it. Expected fates: D3 and D4 move into
`prime-collect.sh` (S5); D7, D8 and their text are deleted with Step 3 (S3); D9 folds into the
session-entry script (S1); D12 is deleted with `STRUCTURAL_RISK` (S2); D1 moves into `prime-sync.sh`
(S4); D2, D5, D6 move into `prime-collect.sh` (S5); D10, D11 stay.

**F-DUP is falsified if** any surviving declaration cites an owner section that no longer exists, or any
retired declaration leaves behind text that still needs it.

---

## 6. The drafted call sites — the budget's measured cells

These are the exact replacement texts the budget counts. They are drafted here so no cell is an estimate.
Build applies them; it does not re-invent them.

### 6.1 — Step 0 replacement · **12 lines + 1 separator**

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

### 6.2 — Steps 1 / 1a / 1b / 1c / 1d replacement · **31 lines + 1 separator**

```markdown
1. **Collect state.** Run the collector from the repository root. It performs every bounded read
   orientation needs — the last `session-notes.md` entry, the merged multi-repo commit set since that
   entry's date, the newest `logs/scratchpads/*-scratchpad.md`, the plan-position cascade, active
   missions, `logs/next-up.md`, and the concurrent-session result the SessionStart hook already computed.
   Read bounds live in the collector: `docs/heavy-read-discipline.md` § Bounded-read recipes.

   ```bash
   STATE=$(bash "$AI_RESOURCES/logs/scripts/prime-collect.sh")
   ```

   `STATE` carries labelled blocks — `LAST_ENTRY`, `NEXT_STEPS`, `COMMITS`, `SCRATCHPAD`, `POSITION`,
   `MISSIONS`, `NEXT_UP`, `LIVE_FOREIGN`, `FOREIGN_SHARED`, `TELEMETRY_GAP`. An absent block means that
   source does not exist here: skip it silently, add no brief line, spend no menu slot.

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

### 6.3 — Steps 8k + 8h replacement · **17 lines + 1 separator**

```markdown
8h. **Session entry (shared sub-step — referenced by 8a / 8b / 8c).** One owner performs the complete
   sequence — allocate the marker, append this session's marker-bearing header, stamp the mtime — in that
   order. The order is load-bearing and is now enforced inside the script rather than restated here.
   Takes one parameter, `WORK_DESC`. Run it after the caller's cross-repo mission guard and before
   `/session-start`.

   ```bash
   MARKER_LINE=$(bash "$AI_RESOURCES/logs/scripts/prime-session-entry.sh" "$WORK_DESC") || exit 1
   TODAY="${MARKER_LINE%% *}"; MARKER="${MARKER_LINE#* }"
   ```

   **The script is located absolutely; it runs against the current repository.** cwd owns the `logs/` it
   writes, so each checkout keeps its own marker sequence, and the call resolves from every consumer —
   not only `ai-resources`. Marker grammar, the atomic claim, the header shape and the ordering rule live
   in the script beside the code they guard, with `logs/scripts/prime-allocator.test.sh` as the tripwire.
   **Never reinline this logic:** code inside an executable prompt is validated by reading rather than by
   running, which is the defect the extraction fixed. Canonical protocol: `docs/session-marker.md`.
```

---

## 7. Known weaknesses of this plan

- **The three scripts do not exist yet.** Their internal size is not this plan's concern (script lines
  are never model-read), but their *correctness* is unproven until each slice's Build unit runs. S4 and
  S5 carry more novel logic than S1 and are deliberately sequenced last among the move-outs.
- **`prime-collect.sh` is the largest single behavioural surface** this stream creates: it subsumes five
  steps and four distinct read disciplines. If any slice is going to fail F-RULES, it is S5.
- **This brief and this plan are both Claude-authored.** The removal list is a transcribed operator
  decision, not analysis this stream performed. Verification establishes that each target *exists* and
  what removing it *costs* — not that removing it is correct.
- **The 32-root census counts roots carrying the call**, not roots where `/prime` is actually invoked.
  Two are archives or vaults. F-ROUTES therefore names a *real project-consumer* root explicitly, so the
  proof cannot be satisfied by a root nobody uses.
- **S3 changes operator-visible behaviour by design.** After it, severity-tagged findings no longer
  auto-surface at orientation. The promotion step re-homes today's open items; keeping the channel alive
  afterwards depends on writers using `next-up.md`, which this plan does not enforce.
