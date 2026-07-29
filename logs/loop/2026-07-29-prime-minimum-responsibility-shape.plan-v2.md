UNIT: 2026-07-29-prime-minimum-responsibility-shape
STREAM: 2026-07-29-prime-minimum-responsibility
PHASE: shape
REPO: ai-resources
BASE: 4c54344
NEXT: Codex — review-2 of this PLAN, then G1

PLAN v2

Supersedes `…-shape.plan.md` (v1, `9be8bb0`), which is retained immutable. Written in response to
review-1 (`4c54344`), which returned **not ready for G1** with six material and two minor findings.

**All eight findings were verified against the live files and all eight are correct.** None is
rejected. Three of them changed the architecture rather than the wording, which is why this is v2 and
why it returns for review-2. Adjudication is § 8.

---

## 0 · What review-1 changed

**The v1 line budget was wrong, and the error was measurable rather than arguable.** F3 said the gate
block alone exceeded its 16-line allowance "several times over." Measured: **8c.6 spans lines
696–755 = 60 lines.** Every 8c sub-step was then re-measured from live anchors and the 18 spans sum
to 236 exactly. The v1 figure of 64 for all of 8c was not reachable — 8c.6 alone consumes it.

That single correction propagates: v1's ~297 becomes **308** under honest budgets, which **misses the
target**. Recovering it required re-siting the approval gate (§ 1), which in turn resolved F1 and F2.
So the three findings are one finding seen from three sides.

**F5 resolves more simply than either v1 or review-1 framed it.** Both assumed a capability record
was needed. `develop-ai-resource.md:38` defines a **neither-field** route: a brief carrying neither
`**Capability:**` nor `**Settled upstream:**` is "ordinary direct invocation … the common case and
produces no output." This is a *non-capability* stream (`docs/work-loop.md:123` — challenged
non-capability work has no record by design), so it takes that route. No record, no labels, no
provenance check. The v1 requirement for a capability record was an error.

**A pre-existing defect in `prime.md` surfaced, not only a defect in v1.** F2 caught that
"abort … without writing anything" (`prime.md:8c.6`) coexists with a marker/header/mtime write at
`8c.3`, which runs *before* the gate. Both cannot be true, and that contradiction is **in the shipped
command today** — v1 inherited it rather than introducing it. It is corrected in § 1 and recorded in
§ 8 as a defect the review found in the object under work.

---

## 1 · The architecture change — one owner and one order for gate, context and mandate

Review-1 F2's demand: *one coherent owner and order for context discovery, the single approval gate,
the exact approved mandate payload, and abort/write behaviour.*

**v1 was incoherent.** It moved context discovery into `/session-start`, which runs *after* `/prime`'s
gate — so the gate could no longer show the pack it shows today, and nothing guaranteed the approved
mandate equalled the written one.

**v2 relocates the gate to where the information already is.** `/session-start` Step 2.4 already
performs exactly this shape: it enriches the mandate from the context pack and **re-emits the
confirmation block for the operator**. That re-emit *is* an approve-mandate-plus-pack gate. Auto mode
does not need a second one built in `/prime`; it needs that one to also carry the plan fields.

### The order

```
/prime 8c                          /session-start                      /session-plan
─────────────────────────────      ──────────────────────────────      ─────────────────
1  resolve PICKED_ITEMS
2  done-condition check
3  plan-mode guard
4  cross-repo mission guard
5  marker → header → mtime  ······ (8h; pre-gate BY NECESSITY — see below)
6  mission auto-bind, DIRECT
7  compose MANDATE_TEXT
8  derive 3 plan fields
9  invoke ──────────────────────►  Step 1  capture {gate:auto} + payload
                                   Step 2  parse, NO echo, NO wait
                                   Step 2.5 self-check ── MOVED BEFORE THE GATE (F1)
                                   Step 2.4 discover pack
                                   ══ THE GATE ══ mandate + pack + plan fields
                                                  go / edit / abort ── ONE STOP
                                   Step 3   write mandate      ┐
                                   Step 3.5 write manifest     │ nothing here runs on abort
                                   Step 4   chain ───────────────────►  Step 0 {plan:overwrite}
                                                               │        Step 7 write plan
10 ◄─────────────────────────────────────────────────────────── ┘        Step 8 no token → proceed
11 /risk-check if STRUCTURAL_RISK
12 execute
```

**Why this answers F2 on all four points.**

- **Context discovery has one owner:** `/session-start` Step 2.4. `/prime` 8c.4.5 is deleted, not
  duplicated.
- **The gate has one site**, and it sits *after* discovery, so the pack and its readiness state are
  disclosed exactly as today.
- **The approved payload is the written payload — structurally, not by promise.** The block the
  operator approves is rendered from the same parsed state Step 3 writes, with the self-check already
  applied. There is no re-parse between approval and write, which is the seam v1 created.
- **Abort semantics are now honest.** Everything inside `/session-start` (mandate, manifest, plan)
  follows the gate, so `abort` writes none of it.

**The one pre-gate write, stated plainly rather than glossed.** `8h` writes the marker, the
marker-bearing header and `.prime-mtime` before the gate, and this is **not** a design choice that
could go the other way: `/session-start` Step 3 (`session-start.md:330`) and `/session-plan` Step 0
(`session-plan.md:24-26`) both **hard-fail** without a resolved marker and a marker-bearing header.
The delegate cannot run without them.

So the gate text changes from a false absolute to a true statement:

> Reply `abort` to stop. No mandate, plan or manifest is written. This session's header in
> `logs/session-notes.md` has already been created and remains.

**This corrects a live defect in `prime.md`, and Build must not reproduce the old wording.**

### The mechanism — `{gate:auto}`, one token, same shape as the two already in the chain

Captured by `/session-start` Step 1's existing token loop. Absent → every other caller behaves
exactly as today. Present → four effects:

| Effect | Site | Why |
|---|---|---|
| Suppress Step 2's echo and its wait | Step 2 | The gate is the 2.4 re-emit; echoing twice would be two stops |
| Run Step 2.5 **before** Step 2.4 | Step 2.5 | So the gate shows a validated mandate, and an auto-fix is disclosed *in* the gate rather than after it — **resolves F1's first branch** |
| Render the re-emit as the **approval gate**: append the plan-field block, accept `go`/`edit`/`abort` | Step 2.4 | One stop carrying mandate + pack + plan |
| Forward `{plan:overwrite}` to `/session-plan` | Step 4 | **Resolves F1's second branch** — see below |

The plan fields (`RECOMMENDED_MODEL`, `AUTONOMY_POSTURE`, `STRUCTURAL_RISK`, `DIRECT`) travel as a
payload on the token. `/prime` derives them at 8c.8 in ~6 lines **by citing** `session-plan.md:86-93`,
`:128-147`, `:153-165` — an application of three documented heuristics, not a copy of a schema.

**F1's second branch — `/session-plan` Step 0 same-session re-invocation.** Under auto mode a
pre-existing `logs/session-plan-{date}-{marker}.md` means a re-dispatch within one session. v2
resolves it by declaration rather than by prompt: `/session-start` Step 4 forwards `{plan:overwrite}`,
which `/session-plan` Step 0 consumes as a pre-selected option 2. Rationale: the operator approved
*this* mandate at the gate seconds earlier, so re-asking which plan to keep is the per-stage prompt
auto mode exists to avoid. **Cost, disclosed:** a re-dispatch silently overwrites the prior
same-session plan. Acceptable because that plan was never approved for execution — its session
aborted or was re-picked. `/prime` 8a and 8b pass no such token and keep the three-option prompt.

**Named second-stop exceptions — exactly two, both pre-existing, both retained.** Auto mode's "one
stop" has never been unconditional. (1) The cross-repo mission guard (`prime.md:623`), already
documented as "a deliberate single-condition exception". (2) A Step 2.5 re-ask that survives its one
auto-fix attempt (`session-start.md:291`). Both are error paths, not per-stage prompts. Naming them
is the honest version of the "one stop" claim, and both are proved (§ 6, P-EXC1/P-EXC2).

---

## 2 · Line budget — re-derived, honest, and it does not clear the target on its own

Every 8c sub-step measured from live anchors. Non-8c targets revised upward where review-1 F3
challenged them.

| Step | Now | v1 target | **v2 target** | Disposition · owner of what leaves |
|---|---:|---:|---:|---|
| preamble | 12 | 10 | 10 | retain |
| 0 Pull latest | 58 | 14 | **20** | retain, slimmed. F3: repo detection + behind-check + 5 result cases + unpushed do not fit 14. Rationale → `docs/commit-discipline.md` |
| 1 Session notes | 24 | 16 | 16 | retain, slimmed |
| 1a Cross-check | 69 | 20 | **21** | git half **retained** (reference implementation). Concurrency half → `detect-concurrent-session.sh` + `/concurrent-session-check` |
| 1b Scratchpad | 12 | 10 | 10 | retain |
| 1c Plan position | 39 | 12 | 12 | cite `/project-next-steps` Step 2 |
| 1d Mission scan | 19 | 10 | 10 | retain, slimmed; mechanics → `/mission` |
| 2 next-up | 4 | 4 | 4 | retain |
| 3 Urgent scan | 39 | 20 | 20 | rationale → `docs/heavy-read-discipline.md`. **`medium-high` tier untouched** |
| 4 Exception checks | 12 | 10 | 10 | retain + remove F2-stale prose |
| 5 Build menu | 20 | 18 | 18 | retain |
| 6 Output brief | 39 | 24 | 24 | compressed |
| 7 Classify reply | 9 | 9 | 9 | **untouched** (unloseable) |
| 8m Mission binding | 9 | 8 | 8 | retain |
| **8k Marker allocation** | **147** | 12 | **12** | **integrate** `logs/scripts/prime-marker.sh`; rationale → `docs/session-marker.md` |
| 8a Numbered dispatch | 50 | 15 | **23** | F3: guards + 8h call + bind + invoke + both-route pause do not fit 15 |
| 8b Free-text dispatch | 32 | 11 | **14** | F3 |
| **8c Auto mode** | **236** | 64 | **57** | **delegate** — gate re-sited (§ 1) |
| **8h** marker→header→mtime *(new)* | 0 | 10 | 10 | consolidate three copies into one |
| **Total** | **830** | 297 | **308** | |

**308 misses the target by 8 lines. Stated as the plan's own result, not buried.**

### 8c, measured then budgeted

| Sub-step | Now | v2 | Disposition |
|---|---:|---:|---|
| 8c.1 resolve items | 9 | 8 | retain |
| 8c.1.5 done-condition check | 15 | 10 | retain — load-bearing |
| 8c.2 plan-mode guard | 2 | 2 | retain |
| 8c.2.5 cross-repo guard | 2 | 2 | retain — named exception |
| 8c.3 marker/header/mtime | 19 | 2 | → 8h |
| 8c.3.5 mission auto-bind | 2 | 2 | retain |
| 8c.3.6 DIRECT | 2 | 2 | retain |
| 8c.4 derive mandate fields | 8 | 4 | → `/session-start` Step 2 (compose `MANDATE_TEXT` only) |
| 8c.4.5 context discovery | 34 | 0 | → `/session-start` Step 2.4 |
| 8c.5 derive plan fields | 6 | 6 | retain — cited heuristics, not a schema |
| **8c.6 approval gate** | **60** | **4** | → `/session-start` Step 2.4 re-emit (§ 1) |
| 8c.6.5 files-in-scope check | 9 | 0 | → `/session-start` Step 2.5 |
| 8c.7 write mandate | 17 | 0 | → `/session-start` Step 3 |
| 8c.7.5 run-manifest | 23 | 0 | → `/session-start` Step 3.5 |
| 8c.8 write plan | 11 | 0 | → `/session-plan` Step 7 |
| 8c.9 risk-check | 6 | 6 | retain — autonomy-rules gate |
| 8c.10 execute | 8 | 8 | retain |
| 8c.11 completion | 1 | 1 | retain |
| header | 2 | 2 | |
| **8c total** | **236** | **57** | |

**Disclosed cost in another file:** `/session-start` grows by roughly **+25 lines** (token capture,
three suppression/reorder clauses, the plan-field block appended to the 2.4 re-emit). It goes ~405 →
~430. That is real and it is not hidden by the `prime.md` count. It is the price of one owner for the
gate, and it removes ~180 lines of duplication from `prime.md`.

---

## 3 · Slices

Vertical; each leaves the repo working and is independently revertible; one Build unit and one
pathspec-staged commit each.

### Slice 1 — Re-site the gate and delegate auto mode · 8c 236 → 57 · **required**

Implements § 1 in full. Do this first: if it fails, the target is unreachable and the stream should
stop rather than spend three further slices.

**Files (9)** — corrected census per F4:

| Path | Change |
|---|---|
| `.claude/commands/prime.md` | 8c rewritten to § 1's order; the false "writes nothing" abort text corrected |
| `.claude/commands/session-start.md` | Step 1 `{gate:auto}` capture; Step 2 suppression; **Step 2.5 reordered before 2.4**; Step 2.4 renders the gate; Step 4 forwards `{plan:overwrite}` (~+25 lines) |
| `.claude/commands/session-plan.md` | Step 0 consumes `{plan:overwrite}` as pre-selected option 2 |
| `docs/context-pack-schema.md` | repoint 4 × `Step 8c.4.5` → `/session-start` Step 2.4; retire `auto-prime` |
| `.claude/agents/context-discovery.md` | repoint 2 × `Step 8c.4.5`; drop `auto-prime` |
| **`.claude/commands/build-context.md`** | **F4** — `:17` cites `/prime` Step 8c.4.5 |
| **`.codex/agents/context-discovery.toml`** | **F4** — `:2`, `:14`, `:217` cite Step 8c.4.5 and `auto-prime`. **Three sites, not one** |
| **`.claude/hooks/check-foreign-staging.sh`** | **F4** — `:471` cites Step 8c.7; `:606` cites Step 8c |
| `docs/session-marker.md` · `logs/scripts/run-manifest.sh` | repoint `Step 8c.7` → `/session-start` Step 3 |

**Rollback:** `git revert`. All 28 symlinked consumers follow instantly — they are symlinks, so there
is no redistribution step. The `session-start.md` and `session-plan.md` additions are inert without
the tokens, so a partial revert degrades to today's behaviour rather than to a broken state.

### Slice 2 — Integrate the marker allocator · 8k 147 → 12 · **required, dependency-gated**

**This slice integrates an artifact; it does not author one.** Per F5 and
`develop-ai-resource.md:38`, `logs/scripts/prime-marker.sh` is authored and qualified by
`/develop-ai-resource` under **ordinary direct invocation** — no capability record, no
`**Capability:**` / `**Settled upstream:**` labels, no provenance check, because this is a
non-capability stream (`docs/work-loop.md:123`).

**Ownership, unambiguous:**

| Concern | Owner |
|---|---|
| Authoring + qualifying `prime-marker.sh` | `/develop-ai-resource`, its own commit |
| Integrating it into `/prime` 8k | this stream, Slice 2 |
| Relocating the 88 rationale lines | this stream, Slice 2 → `docs/session-marker.md` |
| Repointing the test to the shipped script | this stream, Slice 2 |
| Artifact disposition (fit for purpose?) | returns into this stream's **Prove evidence** — there is no record to return to |

**Rollback, corrected per F5:** reverting Slice 2 removes the **integration** — the `prime.md` call
block, the test repoint, the doc repoint — and **leaves `prime-marker.sh` in place**, because this
stream did not create it. v1's claim that the revert deletes the script was wrong.

**The tripwire is already built.** `prime-allocator.test.sh:17-37` extracts the allocator out of
`prime.md` by awk and hard-exits `2` with `FATAL: allocator extraction from prime.md failed` if the
anchors move. Repointing it from extraction to direct invocation is part of this slice.

**Preserve verbatim — the fail-safe invariant** (`prime.md:400-407`): `HIGH` is seeded from the
marker file *before* any scan, and every scan only ever *raises* it. An implementation that scans
first and consults the marker file second is a destructive regression. Named test case P-SEED.

**Files (5):** `.claude/commands/prime.md` · `logs/scripts/prime-allocator.test.sh` ·
`docs/session-marker.md` (absorb rationale; repoint 3 × `Step 8k`) · `logs/scripts/run-manifest.sh`
(repoint 1 × `Step 8k`) · (`logs/scripts/prime-marker.sh` — pre-existing, not created here).

### Slice 3 — Consolidate marker → header → mtime · **required**

The sequence is written three times (8a.3.a, 8b.3.a, 8c.3). Write it once as **8h**.

**Depends on Slice 1 only.** Review-1 F5 is correct that v1's dependency on Slice 2 was spurious:
8h calls whatever allocator exists, inline or extracted, so consolidation does not wait on
extraction. **Files (1):** `.claude/commands/prime.md`. **Rollback:** revert.

### Slice 4 — Slim the orientation steps by citing owners · **required**

Steps 0, 1, 1a (concurrency half), 1c, 1d, 3, 6. Rationale moves to two **existing** docs:
Step 0's pull-strategy narrative → `docs/commit-discipline.md`; Step 3's bounded-scan
anti-regression rationale → `docs/heavy-read-discipline.md`. Includes deleting `prime.md:281`, which
calls the wrong branch "normal" and cites `/new-project` step 11a, deleted 2026-07-27.

**Must not be touched:** Step 1a's git cross-check (`docs/backlog-reconciliation.md:65`, `:111`) and
Step 3's `medium-high` tier (narrowing it is a policy change needing reciprocal edits to
`wrap-session.md` Step 12e and `session-feedback-collector.md` plus a `logs/decisions.md` record).

**Files (3):** `.claude/commands/prime.md` · `docs/commit-discipline.md` ·
`docs/heavy-read-discipline.md`. **Rollback:** revert.

### Slice 5 — Headroom compression · **CONTINGENT BUT MANDATORY** (F3)

**No longer droppable.** Slices 1–4 project to **308**, which misses the target. This slice is the
recovery path and review-1 was right to demand it be one.

**Trigger, mechanical:** after Slice 4 lands, run `wc -l .claude/commands/prime.md`.

| Live count | Action |
|---|---|
| **> 300** | Slice 5 **runs**. Not optional, not a judgement call |
| ≤ 300 | Slice 5 is skipped and the skip is recorded with the measured count |

**Content:** Step 1b → cite-only (10 → 6) · Step 1c → pure citation of `/project-next-steps`
(12 → 4) · Step 6 exception-line block, single-condition advisories → cited (24 → 20). **Buys ~12 →
projected ~296.**

**Falsification exit — the part that makes this a plan and not a hope.** If the live count still
exceeds 300 after Slice 5, **the plan is falsified.** Do not cut further to force the number: every
remaining line is either a retained responsibility or a load-bearing rationale, and cutting into
those is how a leanness exercise becomes a regression. Report the measured count and return to the
operator at G2 with the target missed and the residue itemised.

---

## 4 · Sequencing and rollback

```
/develop-ai-resource ──► prime-marker.sh qualified ──┐
                                                     ▼
Slice 1 ──► Slice 3 ──► Slice 2 ──► Slice 4 ──► measure ──► Slice 5 (if > 300) ──► measure
```

Slice 1 first and independent. Slice 3 needs only Slice 1 (F5). Slice 2 needs Slice 1 landed *and*
the artifact qualified; it is placed after Slice 3 so the shared 8h call site is final before the
allocator moves. Slice 4 after 3. Slice 5 gated on measurement.

**Whole-stream rollback:** revert the slice commits in reverse order; `prime.md` returns byte-for-byte
and all 28 symlinked consumers follow with no redistribution. `prime-marker.sh` survives, correctly —
it belongs to `/develop-ai-resource`.

**Pre-Build check, mandatory before every slice.** A live git worktree `ai-resources-2` exists on
branch `session/2026-07-29-2` (created 12:24 2026-07-29, clean, at `aa0e266`). A concurrent session
editing `prime.md` there would produce a merge conflict on a 28-consumer file. Run
`git -C ai-resources worktree list`, then `git status` in every listed checkout; on any uncommitted
`prime.md` change, **stop and report**.

---

## 5 · Proof design

Behavioural, executed against the shipped file. Rebuilt per F6; the four criteria F6 named as having
evidence problems are replaced rather than patched.

**Fixture:** a scratch clone plus a fixture project carrying `**Execution route:** direct`, so
direct-route and engineered cases run without touching live projects.

| # | Proves | Method | Falsified if |
|---|---|---|---|
| P-LINES | ≤300 | `wc -l`, re-derived live at close, after Slice 5's trigger check | > 300 |
| **P-DUP** | No duplicated logic | **Structural, not phrase-matching (F6):** assert `prime.md` contains **zero** invocations of `context-discovery`, **zero** `**Mandate:**` write templates, **zero** run-manifest `start` calls, **zero** `session-plan-*.md` write templates. Positive control: each assertion must fire on the pre-change file (4/4) | any hit, or control does not fire 4/4 |
| **P-CITE** | No dangling citations | **Repo-wide (F4):** `grep -rn` for every removed identifier (`8c.4.5`, `8c.6`, `8c.6.5`, `8c.7`, `8c.7.5`, `8c.8`, `8k`, `auto-prime`) across the whole repo **excluding `.git` and `logs/`** — hooks and `.codex/` included. Positive control: the same search on the pre-change tree returns the full known set | any live reference to a removed identifier survives |
| P-MENU | Menu renders | real `/prime` in the fixture | no menu |
| P-NUM · P-FREE · P-AUTO | Three input paths dispatch | one real dispatch each | any fails to dispatch |
| **P-1GATE** | Auto stops **exactly once** | real `auto 1,3`; count operator stops | 0 or ≥2 |
| **P-EXC1** | Cross-repo guard still stops | auto-pick a mission whose repo ≠ `CWD_REPO` | no stop |
| **P-EXC2** | Step 2.5 re-ask still reachable | auto-dispatch with a deliberately underivable `exit_condition` | silently proceeds with an invalid mandate |
| **P-PAYLOAD** | Approved == written | diff the gate block's mandate fields against the `**Mandate:**` line and its bullets on disk | any field differs |
| **P-PACK** | Pack disclosed at the gate | auto-dispatch in a project with a `CLAUDE.md` routing map; assert pack path + readiness appear **in** the gate block | pack absent from the gate |
| **P-PACK4** | All four engine outcomes | enriched · insufficient · skipped · failed (force each) | any outcome blocks, or is undisclosed |
| **P-ABORT** | Abort writes nothing but the header | reply `abort`; assert no mandate line, no plan file, no manifest; assert the header **does** exist | any of the three written, or the header claim is wrong |
| **P-EDIT** | `edit` path | reply `edit`, correct one field, then `go`; assert the correction reaches disk | correction lost |
| **P-REINVOKE** | Same-session re-dispatch | auto-dispatch twice; assert no three-option prompt and the plan overwritten | prompts, or writes `-pass2` |
| P-8AGATE · P-8BNOGATE | 8a still stops, 8b still does not | one dispatch each | either inverts |
| P-ARTIFACTS | Marker grammar and artefacts | after each dispatch assert `logs/.session-marker`, per-id marker, `## {date} — Session {MARKER}`, `.prime-mtime`, `logs/runs/{date}-{MARKER}.json` | any absent or misnamed |
| P-DIRECT · P-ENG | Both routes | fixture direct project + engineered project | direct writes a plan, or engineered does not |
| P-RISK | risk-check branch | auto-pick a structural item; assert `/risk-check` fires and RECONSIDER pauses | does not fire, or verdict ignored |
| P-RANGE | Out-of-range auto | `auto 9` on a 6-item menu | proceeds instead of re-asking |
| P-MISSION | Binding survives | auto-pick a `[mission:*]` item; assert `- Mission:` on the mandate line | bullet absent |
| **P-FAIL** | Guards fire at the **new seam** (F6) | invoke the `/prime`→`/session-start` seam with the marker deleted; assert `/session-start` Step 3 hard-fails | fails open |
| P-ALLOC | Allocator unregressed | `prime-allocator.test.sh` against the **running** implementation | not 19/0 |
| **P-SEED** | Fail-safe invariant (F6) | **Executable:** with a marker file reading `S7` and every scan source empty, assert the allocated marker is `S8`, not `S1`. Positive control: the same harness against a deliberately scan-first mutant must yield `S1` | allocates `S1`, or the mutant control does not fail |
| P-NOIMPORT | No prose moved to an always-loaded prompt | grep `@`-imports in workspace + project `CLAUDE.md`; diff both | either grew, or anything landed in `harness-rules.md` |
| **P-QUAL** | No unqualified artifact (F7) | `prime-marker.sh` traceable to a `/develop-ai-resource` run. **Positive control:** the same search shape, run against a known-qualified existing resource, must return a hit | script exists with no qualification trail, or the control returns nothing |

---

## 6 · Falsification

The plan is falsified if: `wc -l` exceeds 300 after Slice 5; any of the auto / mandate / context /
plan / manifest schemas remains copied in `/prime` (P-DUP, structural); state moves to another prompt
without a single owner (P-PAYLOAD, P-PACK); an unqualified artifact is required (P-QUAL); or any
changed dispatch or failure path lacks a behavioural proof and a rollback.

---

## 7 · Open items for G1

1. **Owner ack for the `/session-start` growth.** ~405 → ~430 lines. `prime.md` loses ~180 lines of
   duplication; one delegate gains ~25. Net workspace change is strongly negative, but it is a real
   increase in a second always-reachable command.
2. **`{plan:overwrite}` silently overwrites a same-session plan** (§ 1). Recommendation: accept — the
   overwritten plan was never approved for execution.
3. **Retire `INVOCATION_MODE: auto-prime`?** Recommendation: retire; `/session-start` passes
   `auto-session-start` for both callers. Four sites across two files.
4. **Slice 5's floor.** If the count still exceeds 300 after Slice 5, the plan is falsified and
   returns to you rather than cutting further. Confirm that is the behaviour you want.
5. **Reported, not asked — the `/work-loop` scope-conflict defect.** Per F8, this is **not** an
   operator authorization question: `work-loop.md`'s own rule says the contract wins, and
   `docs/work-loop.md:44` permits settled corrections to existing commands. Authority is already
   resolved. The contradictory `work-loop.md:247` text is a separate defect, routed on its own.
6. **Reported — a live defect in `prime.md` found by review-1.** `8c.6` promises `abort` "without
   writing anything" while `8c.3` writes the marker, header and mtime before the gate. Corrected in
   Slice 1.
7. **Reported — a contract gap.** `docs/work-loop.md:48` routes an artifact's disposition back
   "through the **capability record**", but a **non-capability** stream has no record by design
   (`:123`). v2 returns the disposition into this stream's Prove evidence. The contract does not say
   to do that; it simply does not cover the case. Routed as a `/work-loop` contract defect.

LIMITATIONS:
- **Fifteen of nineteen per-step budgets remain apportioned from reading prose**, not derived by
  rewriting. 8c's is now measured sub-step by sub-step and 8k's rests on the 88/54 comment split;
  the rest are estimates and are still the most likely source of a miss. Slice 5 exists because of
  this, and its falsification exit exists because Slice 5 may not be enough.
- **308 → 296 depends on Slice 5 delivering ~12 lines.** That figure is itself apportioned.
- **`{gate:auto}` is designed and not exercised.** Its four effects are reasoned from reading
  `session-start.md`; no run has shown that suppressing Step 2's wait and reordering 2.5 before 2.4
  leaves the rest of the command intact. **Reordering two steps inside a 405-line command that six
  readers depend on is the single largest unproven assumption in this plan.**
- **The +25-line `/session-start` estimate is not derived from a draft.**
- **P-PACK4 requires forcing an engine failure**, and no mechanism for doing so deterministically has
  been identified.
- **Slice 4's relocation targets were chosen by topical fit**, not by confirming those two docs have
  a section that naturally receives the material.
- **The concurrent-worktree risk is a pre-Build check, not a resolution.** Whether a session is live
  in `ai-resources-2` was not determined; its marker directory is empty, which is suggestive, not
  conclusive.
- **review-1 was adjudicated by the same hand that wrote v1.** Every finding was verified against
  live files before acceptance, but the judgement that all eight are correct is my own.
