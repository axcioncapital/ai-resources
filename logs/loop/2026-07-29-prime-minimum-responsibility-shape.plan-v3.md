UNIT: 2026-07-29-prime-minimum-responsibility-shape
STREAM: 2026-07-29-prime-minimum-responsibility
PHASE: shape
REPO: ai-resources
BASE: aa7a56d
NEXT: operator — G1 (scope and package)

PLAN v3

Supersedes v2 (`aa7a56d`) and v1 (`9be8bb0`), both retained immutable. Written in response to
review-2 (`…-shape.review-2.md`), which returned **not ready for G1** with four material and three
minor findings.

**All seven verified against live files; all seven correct; none rejected.** Review-2 also confirmed
four v2 decisions, which are carried unchanged. Per review-2's closing instruction this plan is
adjudicated under the existing unit and goes to G1 **without a third review round** — with one
finding (F5) carried to G1 as a blocking operator decision, because nothing in the rulebook resolves it.

---

## 0 · What review-2 changed

**F1 inverted my own v2 fix, and it was right.** v2 moved `/session-start` Step 2.5 *before* Step 2.4
to put validation ahead of the gate. Verified against the live file, that creates the exact hole 2.5
exists to close: `files_inferred` is set at **Step 2** (`session-start.md:106`) and *cleared* at
**Step 2.4** (`:243`), which replaces `(inferred)` with engine-generated concrete paths. Validate
first and those paths reach disk having never met the shape and existence tests. v3 restores the
original order and inserts the gate **after** 2.5 instead.

**F1's second half is a silent-approval hole, and it is the most dangerous thing found in three
rounds.** `session-start.md:253`: on `engine-skipped` / `engine-error`, Step 2.4 does **not** re-emit.
v2 built auto mode's only approval gate on that re-emit. So on two of four engine outcomes — including
every project without a root `CLAUDE.md` — auto mode would have written a mandate, a manifest and a
plan, then executed, **with no approval gate at all.** v3 makes the gate unconditional.

**F5 is confirmed and it blocks Slice 2.** v2 claimed the artifact disposition returns into this
stream's Prove evidence. That is invented. `develop-ai-resource.md:157` — direct invocation ends in
*its own* operator choice (Ship · Revise · Defer · Delete). `:159` — only **upstream mode** returns a
disposition. `:163` — "**Return address is the record, not the calling unit.**" A non-capability
stream has no record (`docs/work-loop.md:123`). There is no compliant path, so this goes to the
operator at G1 rather than being papered over. § 7.

**F6's arithmetic corrections are both right**, and one was mine mis-summing my own table.

---

## 1 · Corrected architecture

### Order — validation sits with the values closest to the write

```
/prime 8c                        /session-start                        /session-plan
────────────────────────────     ─────────────────────────────────     ──────────────────────
1 resolve PICKED_ITEMS
2 done-condition check
3 plan-mode guard
4 cross-repo mission guard
5 marker → header → mtime ······ (8h; pre-gate by necessity)
6 mission auto-bind, DIRECT
7 compose MANDATE_TEXT
8 derive STRUCTURAL_RISK only
9 invoke ──────────────────────► Step 2   parse · no echo · no wait
                                 Step 2.4 discover pack · enrich · clear files_inferred
                                 Step 2.5 validate ── ORIGINAL POSITION RESTORED (F1)
                                 ═══ GATE ═══ fires on ALL FOUR engine outcomes (F1)
                                        mandate + pack/status + structural risk
                                        go / edit / abort
                                        on edit → apply → re-run 2.5 → re-render (one round)
                                 Step 3   write mandate     ┐
                                 Step 3.5 write manifest    │ none of this runs on abort
                                 Step 4   chain ──────────────────────► Step 0 {plan:overwrite}
                                                            │           Steps 1-6 derive INTENT,
                                                            │             model, autonomy
                                                            │           Step 7 write plan
                                 ◄──────────────────────────────────────Step 8 {gate:auto}:
10 ◄─────────────────────────────────────────────────────── ┘             "Plan written. Returning
11 /risk-check if STRUCTURAL_RISK                                          to /prime." NO execute
12 execute
```

**F1 resolved on both halves.** Validation runs after discovery, so it sees what will actually be
written. The gate follows validation, so it shows a validated mandate. An `edit` re-runs Step 2.5
before re-rendering — **gate edits are revalidated, never written raw.** One edit round, matching
today's `8c.6` parser, which already allows exactly one.

**The gate is unconditional.** Under `{gate:auto}` it fires on all four engine outcomes: the pack
section is populated on `success-enriched` / `success-insufficient`, and replaced by a one-line status
(`Context pack: skipped — {reason}` / `failed — {cause}`) on the other two. This is **not** "reuse the
existing re-emit" — two outcomes have no existing re-emit, and that gap is what made v2 unsafe.

### F2 — one owner per plan field, and a non-executing return

| Field | Sole owner | Shown at the gate? |
|---|---|---|
| `RECOMMENDED_MODEL` | `/session-plan` Step 2 | **No** — disclosed by `/session-plan` after the plan write |
| `AUTONOMY_POSTURE` | `/session-plan` Step 5 | **No** — same |
| `STRUCTURAL_RISK` | **`/prime` 8c.8** | **Yes** — it decides whether `/risk-check` runs, and `/prime` owns that call at 8c.9 |
| `DIRECT` | `/prime` 8c.6 (canonical predicate) | Yes |

v2 had `/prime` deriving all four for display while `/session-plan` re-derived three for the file —
two owners, and an `edit` could leave `/prime`'s copy stale. v3 removes the duplication by removing
the display, not by adding synchronisation.

**Operator-experience delta, disclosed and carried to G1 (§ 7.2):** model tier and autonomy posture
move from *before* approval to *after* it. Structural risk — the field that changes what happens
next — stays before. On `edit`, `/prime` re-derives `STRUCTURAL_RISK` from the corrected `work_scope`
before re-rendering, closing the staleness path F2 named.

**Control flow.** `session-plan.md:239` default branch emits "Begin execution" — so with only
`{plan:overwrite}` the chain would start work before `/prime`'s `/risk-check`. v3 adds a third Step 8
branch: under `{gate:auto}`, emit `Plan written to {OUTPUT_TARGET}. Returning to /prime.` and **return
without executing**. P-RETURN and P-RISKORDER prove it.

---

## 2 · Budget — corrected arithmetic (F6)

**v2 mis-summed its own 8c table: the rows total 59, not 57** — I omitted the 2-line header. v3 also
drops model/autonomy derivation from 8c.8 (F2), which returns 4 lines.

| | v2 stated | v3 corrected |
|---|---:|---:|
| 8c subtotal | 57 ✗ | **55** (rows 53 + header 2; 8c.8 6 → 2 per F2) |
| All other steps | 251 | 251 |
| **Projected after Slices 1–4** | 308 ✗ | **306** |
| Slice 5 recovery | "~12" ✗ | **16** (1b −4 · 1c −8 · 6 −4, as itemised) |
| **Projected after Slice 5** | 296 | **290** |

**306 after Slices 1–4 still misses the target; 290 after Slice 5 clears it with 10 lines of slack.**
Slice 5 remains contingent-but-mandatory with the same measured trigger and the same falsification
exit (§ 3, Slice 5) — review-2 confirmed that floor as correct.

**Growth in the delegates, re-estimated per F7.** v2's `+25` did not cover the four-outcome gate,
revalidation, payload serialization or the non-executing return.

| File | Now | After | Δ |
|---|---:|---:|---:|
| `.claude/commands/prime.md` | 830 | 290 | **−540** |
| `.claude/commands/session-start.md` | 405 | ~447 | **+42** |
| `.claude/commands/session-plan.md` | 247 | ~254 | **+7** |
| **Net** | | | **−491** |

`+42` itemised: token capture 3 · Step 2 suppression 2 · four-outcome gate render 18 · gate parser
and edit-revalidation loop 12 · payload serialization 3 · Step 4 forwarding 4.

---

## 3 · Slices

Unchanged from v2 except where noted. Review-2 confirmed the ordering `1 → 3 → 2 → 4` and the Slice 5
floor.

**Slice 1 — re-site the gate and delegate auto mode · required.** Now also: gate fires on all four
engine outcomes; Step 2.5 keeps its original position; edit-revalidation loop; `/session-plan` Step 8
non-executing return. **Files (10)** — v2's nine plus `.claude/commands/session-plan.md`, which needs
both the `{plan:overwrite}` consumption and the new Step 8 branch. Rollback: `git revert`; the
delegate additions are inert without the tokens, so a partial revert degrades to today's behaviour.

**Slice 2 — integrate the marker allocator · required · BLOCKED on the F5 decision (§ 7.1).**
Unchanged otherwise: this stream *integrates*, `/develop-ai-resource` authors; reverting removes the
integration and leaves the script; `prime-allocator.test.sh` is repointed in the same slice; the
fail-safe seed invariant is preserved and proved by P-SEED.

**Slice 3 — consolidate marker → header → mtime · required.** Depends on Slice 1 only.

**Slice 4 — slim the orientation steps by citing owners · required.** Includes deleting the stale
`prime.md:281` prose. Step 1a's git cross-check and Step 3's `medium-high` tier are not touched.

**Slice 5 — headroom compression · contingent but mandatory.** Trigger: `wc -l` after Slice 4.
`> 300` → runs. `≤ 300` → skipped, with the measured count recorded. **Recovery is 16 lines**
(1b 10→6, 1c 12→4, 6 24→20). **Falsification exit unchanged:** if the live count still exceeds 300
after Slice 5, report falsification at G2 — do not cut further.

---

## 4 · Proof design — corrections only

Full table as v2, with these changes:

| # | Change | Finding |
|---|---|---|
| **P-CITE** | Search domain corrected. Exclude `.git`, `logs/loop/`, `logs/runs/`, `logs/session-notes*`, `logs/session-plan-*`, `logs/improvement-log*`, `logs/decisions*`, `logs/friction-log*`, `logs/usage-log*`, `audits/`, `plans/`. **`logs/scripts/` is INCLUDED** — it holds live consumers (`run-manifest.sh` cites Steps 8c.7 and 8k) that the slices themselves modify. Positive control on the pre-change tree must return the full known set | **F3** |
| **P-PACK4** | Injection method named, all four deterministic. `enriched` / `insufficient`: fixture project whose routing map yields each. `skipped`: run in a repo with no root `CLAUDE.md` — skip condition 3, `session-start.md:215`. `error`: point `subagent_type` at a stub agent whose body returns `**Pack:** (none — engine failed) — fixture`. **Each of the four must also produce a gate** (F1) | **F4** |
| **P-VALIDATE** *(new)* | Auto-dispatch in a project where the engine returns a **non-existent** path. Assert Step 2.5's existence test rejects it *after* enrichment. Positive control: the same fixture with 2.5 disabled must let the bad path reach disk | **F1** |
| **P-EDITVALID** *(new)* | At the gate, `edit` `files_in_scope` to a non-existent path. Assert re-validation fires and the bad path never reaches disk | **F1** |
| **P-GATE4** *(new)* | Assert a gate appears on all four engine outcomes. Positive control: on the pre-change file, `skipped` and `error` produce no re-emit | **F1** |
| **P-RETURN** *(new)* | Assert `/session-plan` under `{gate:auto}` returns to `/prime` without emitting "Begin execution" | **F2** |
| **P-RISKORDER** *(new)* | Auto-pick a structural item; assert `/risk-check` runs **before** the first structural edit. Positive control: a RECONSIDER verdict must halt with no edit made | **F2** |
| **P-FIELDS** *(new)* | Assert model and autonomy in the written plan derive from `/session-plan` and appear nowhere in the gate block; assert `STRUCTURAL_RISK` at the gate equals the value driving 8c.9. After an `edit` to `work_scope`, assert the re-rendered risk reflects the correction | **F2** |
| P-PAYLOAD | Extended: compares mandate fields **and** `STRUCTURAL_RISK` | **F2** |

---

## 5 · Falsification

Unchanged from v2, plus: the plan is falsified if any engine outcome reaches a write without a gate
(P-GATE4); if engine-derived or gate-edited values reach disk unvalidated (P-VALIDATE, P-EDITVALID);
or if any structural edit precedes `/risk-check` (P-RISKORDER).

---

## 6 · Adjudication of review-2

| # | Disposition | Basis |
|---|---|---|
| F1 ordering hazard + no gate on 2 of 4 outcomes | `fixed` | Verified `:106`, `:243`, `:253`. v2's reorder was wrong and is reverted; the gate is now unconditional. Three new proofs |
| F2 two plan-field owners + premature execution | `fixed` | Verified `session-plan.md:239`. One owner per field by removing the display, not by syncing. Step 8 gains a non-executing branch. Four proofs |
| F3 P-CITE excludes live code | `fixed` | Correct — `logs/scripts/` holds consumers the slices modify. Domain narrowed to historical artifacts only |
| F4 P-PACK4 not executable | `fixed` | Four deterministic injection methods named |
| **F5 no compliant artifact-return path** | **`operator`** | Verified `:157`, `:159`, `:163`. v2's Prove-evidence return was invented. No rulebook path exists → G1 (§ 7.1) |
| F6 arithmetic | `fixed` | Both correct. 8c = 55 (not 57), total 306, Slice 5 recovery 16, final 290 |
| F7 growth understated | `fixed` | Re-estimated +42 / +7, itemised |

---

## 7 · G1 package — decisions required

### 7.1 · BLOCKING — how does `prime-marker.sh` get qualified? (F5)

Slice 2 cannot start until this is settled. Slice 2 is worth **135 lines**; without it the projection
is ~425 and the target fails outright.

| Option | Mechanics | Cost |
|---|---|---|
| **A — capability record** (recommended) | Open `projects/axcion-ai-system-owner/development/prime-marker-allocator.md`, hand off in upstream mode, disposition returns to the record | The record calls harness plumbing a "capability", which it is not. One extra file, maintained to a terminal status |
| **B — accept the extra stop** | Ordinary direct invocation; the operator takes Ship/Revise/Defer/Delete inside `/develop-ai-resource` | One operator stop outside this route's three. Review-2 reads that as a contract breach; I read the three-stop rule as governing `/work-loop`'s own gates, not another command's. **The disagreement is unresolved and is why this is your call** |
| **C — drop Slice 2** | Allocator stays inline | Target fails by ~125 lines. Not recommended |

**Recommendation: A.** It is the only option with a defined return address, and the record's cost is
one file. B is defensible but rests on a reading review-2 rejects.

### 7.2 · Operator-experience delta — model and autonomy move after approval

The gate will show mandate + context pack + structural risk. Model tier and autonomy posture appear
*after* approval, from `/session-plan`. This is the price of one owner per field (F2). Confirm
acceptable, or say so and I will re-open F2 with a synchronisation design instead.

### 7.3 · Confirmations carried from review-2

`{plan:overwrite}` silently overwrites a same-session plan · retire `INVOCATION_MODE: auto-prime` ·
Slice 5's falsification floor · slice order `1 → 3 → 2 → 4 → measure → 5`.

### 7.4 · Reported, not asked — three defects found across the three rounds

1. **`prime.md` 8c.6** promises `abort` writes nothing while `8c.3` writes marker/header/mtime
   pre-gate. Live defect; corrected in Slice 1.
2. **`.claude/commands/work-loop.md:247`** forbids editing `/prime`; the contract permits settled
   corrections. Authority already resolved by the command's own conflict rule; the text is a defect,
   routed separately.
3. **`docs/work-loop.md:48`** routes artifact disposition "through the capability record" that a
   non-capability stream cannot have (`:123`). This is the gap behind 7.1 and needs a contract fix
   regardless of which option is chosen.

### 7.5 · The slice list Build will execute

Slice 1 (10 files) → Slice 3 (1) → Slice 2 (5, gated on 7.1) → Slice 4 (3) → measure → Slice 5 (1) →
measure. Each is one Build unit, one commit, pathspec-staged, `git revert`-reversible. Pre-Build
worktree check before every slice.

LIMITATIONS:
- **Fourteen of nineteen per-step budgets remain apportioned from reading prose.** 8c is measured
  sub-step by sub-step; 8k rests on the measured 88/54 comment split. The rest are estimates, and
  Slice 5 plus its falsification exit exist because of that.
- **306 → 290 depends on Slice 5 delivering 16 lines.** Itemised, not derived by rewriting.
- **`{gate:auto}` has never been exercised.** Its effects are reasoned from reading `session-start.md`.
  Restoring Step 2.5's position removes v2's largest hazard, but **inserting an unconditional gate
  between 2.5 and 3 in a 405-line command with six readers is now the largest unproven assumption.**
- **The +42 / +7 estimates are not derived from a draft.**
- **No third review round.** Per review-2's instruction this goes to G1 adjudicated but
  **unreviewed since the F1/F2 corrections** — and those corrections changed the architecture again.
  The gate re-siting has been reviewed twice; *this* version of it has been reviewed zero times.
- **F5 option B rests on my own reading of the three-stop rule, which review-2 rejects.** I have not
  resolved that disagreement; I have surfaced it.
- **Every review finding was adjudicated by the hand that wrote the plan.** Each was verified against
  live files first, but the judgement that all seven are correct is mine.
