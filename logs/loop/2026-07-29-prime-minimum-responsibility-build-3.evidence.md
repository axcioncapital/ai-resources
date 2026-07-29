EVIDENCE
UNIT: 2026-07-29-prime-minimum-responsibility-build-3
STREAM: 2026-07-29-prime-minimum-responsibility
PHASE: build
REPO: ai-resources
BASE: bd4097a
NEXT: operator — Slice 2 is blocked on the capability-record route; see Finding 3 before Slice 4

Status: complete

---

## Premise verification (step 4)

| Premise | What was run | What was observed |
|---|---|---|
| The sequence is written three times and the copies are equivalent | Read all three in full (`8a.3.a`, `8b.3.a`, `8c.5`) | **Confirmed.** All three: 8k for the marker → `grep -Fxq` header-existence check → reuse on exit 0 / create on exit 1 → `logs/.prime-mtime` write, in that order. They differ in **exactly one** respect: the work-description line (`TASK_TEXT` for 8a and 8b; picked-item text or `Auto multi-item: …` for 8c). That difference became 8h's single parameter, `WORK_DESC` |
| 8c.5 after Slice 1 is the same sequence 8c.3 was before it | Read 8c.5 against the pre-Slice-1 8c.3 | Confirmed — Slice 1 renumbered and condensed the prose but did not alter the write sequence |
| No external file cites `8a.3.a` / `8b.3.a` by number | Re-specified P-CITE (build-1 § R1) | **Rejected — two external citations exist.** See Finding 3 |
| Step id `8h` is unused | `git grep -nE '\b8h\b'` over tracked active surfaces | Empty — free to allocate |
| Allocator tripwire holds | `bash logs/scripts/prime-allocator.test.sh` | **19 passed, 0 failed** — 8k's awk extraction anchors untouched |

## Finding 3 — the plan's 1-file census for Slice 3 was wrong; it is 3 files

**Material. Disposition: `fixed`.**

Plan-v3 § 3 states Slice 3 is **"Files (1): `.claude/commands/prime.md`"**. The re-specified P-CITE
sweep found two external consumers of the sub-step numbers this slice dissolves:

- `.claude/commands/session-start.md:51` — Step 0.5 told the reader that `logs/.prime-mtime` is
  "the mtime `/prime` wrote after its today's-header append in Step 8a.3.a, 8b.3.a, or 8c.3". All
  three ids stop existing in this slice. Repointed to Step 8h.
- `docs/session-marker.md:229` — described the 2026-07-17 allocator de-duplication and asserted
  "there is now nothing to keep in sync across branches", which was true of the *allocator* and false
  of the sequence wrapped around it. Updated to record both consolidations and both edit points.

**This is the same defect class as build-1's Finding 1, caught one slice earlier and by the fixed
method.** R1's `git grep` sweep surfaced both sites before implementation rather than after, which is
the behaviour the re-specification was adopted for.

## What was implemented

| File | Change |
|---|---|
| `.claude/commands/prime.md` | **New shared Step 8h — `Session-entry write`** (27 lines, defined once at `:513`), taking `WORK_DESC` as its one parameter. The three call sites collapse to one line each (`:551` 8a, `:580` 8b, `:615` 8c.5). Carries the ordering rationale that was previously stated twice and implied once |
| `.claude/commands/session-start.md` | `:51` repointed to Step 8h |
| `docs/session-marker.md` | `:229` updated — records that the *allocator* was consolidated into 8k (2026-07-17) and the *sequence around it* into 8h (2026-07-29), and names both as the single edit points |

**No `/prime` step was renumbered.** `8m`, `8k`, `8a`, `8b`, `8c` all keep their identifiers; `8h` is
newly allocated into a free slot. The two surviving mentions of `8a.3.a` / `8b.3.a` (at `prime.md:538`
and `session-marker.md:229`) are deliberate historical notes recording what was consolidated — not
live citations.

## Verification

| Check | What was run | What was observed |
|---|---|---|
| Allocator tripwire | `bash logs/scripts/prime-allocator.test.sh` | **19 passed, 0 failed** |
| 8h defined once, called three times | `grep -n "^8h\."` and `grep -n "Step 8h"` | One definition (`:513`), three call sites (`:551`, `:580`, `:615`) |
| No step renumbered | `grep -n "^8[a-z]\."` | `8m 8k 8h 8a 8b 8c` — pre-existing ids unchanged |
| No stale sub-step citations | Re-specified P-CITE sweep | Only the two intentional historical notes remain |
| Line count | `wc -l` | `prime.md` **642 → 635** |

## Finding 4 — measured trajectory puts the ≤300 target at risk, and the risk sits entirely in Slice 4

**Material. Disposition: `operator` — it bears on whether the remaining slices are worth running as
planned, which is not this unit's call.**

Measured composition of `prime.md` at 635 lines:

| Region | Lines |
|---|---:|
| Steps 0–7 (orientation half, before the dispatch block) | **356** |
| `8k` marker allocation | 147 |
| `8c` auto mode (post-Slice-1) | 47 |
| `8a` · `8b` · `8h` · `8m` | 33 · 17 · 27 · 9 |

Slice 2 takes `8k` from 147 → 12, i.e. **−135**, landing `prime.md` at **500**. Reaching ≤300 then
requires **−200 more**, and plan-v3 budgets Slice 5 to recover only **16** (itemised: 1b −4, 1c −8,
6 −4). **So Slice 4 alone must deliver roughly 184–200 lines — a 52–56% cut of the 356-line
orientation half.**

Against plan-v3 § 2's budget table, which projected "all other steps" at **251** after Slices 1–4:
the measured non-`8c` total today is **588**, falling to **453** after Slice 2. Hitting 251 needs
Slice 4 to cut **202 lines**. The plan never itemised that figure — § 2 carried it inside a single
aggregate row, and plan-v3's own LIMITATIONS records that "fourteen of nineteen per-step budgets
remain apportioned from reading prose".

This is **not a falsification** — Slice 4's method is to move rationale prose into two existing docs,
and the orientation half is prose-heavy, so a cut of that size is not arithmetically impossible. But
it is now the single largest unverified assumption in the stream, it is concentrated in one slice,
and it is measured rather than estimated. Worth a decision **before** Slice 4 is opened rather than
after it lands short.

## LIMITATIONS

- **Nothing was executed. No behavioural proof was run.** Every check is structural — the three
  copies were compared by reading, not by running `/prime` down each branch. The claim that 8h is
  behaviour-preserving rests on textual equivalence plus the single identified parameter.
- **The 2026-07-17 allocator de-duplication was harness-verified** (risk-check
  `2026-07-17-dedupe-prime-session-marker-allocator`); **this consolidation was not.** The same class
  of change got a weaker verification than its predecessor, because Build carries no gate. If any
  branch's marker/header/mtime behaviour regresses, it will surface at Prove, not here.
- **`WORK_DESC` is a documentation-level parameter, not an enforced one.** Nothing checks that a
  caller supplies it; a future branch that calls 8h without it would write a header with no work
  description and nothing would complain.
- **The 8a-specific prose was condensed, not just relocated.** 8a.3.a previously carried a
  "must happen before step c" note and the foreign-session explanation inline; both now live in 8h,
  and 8a's call site keeps only the precondition sentence. Equivalent in content, shorter in form —
  but a reader of 8a alone now has one more hop to make.
- **Not re-checked:** whether `/session-start` Step 0.5's freshness logic still reads correctly given
  that all three branches now stamp the mtime from a single code path. Reasoned as unchanged (same
  writes, same order), not demonstrated.

## CLOSE

**Outcome:** `close` — Slice 3 landed. The marker → header → mtime sequence is written once, as
Step 8h, and called by all three dispatch branches.

**Commits:** `bd4097a` (brief) · this unit's implementation commit.

**What closed:** the Build unit `2026-07-29-prime-minimum-responsibility-build-3`.

**Stream:** **stays open.** Two findings go to the operator before it continues: **Slice 2 remains
blocked** on the approved capability-record route for `prime-marker.sh` (open
`projects/axcion-ai-system-owner/development/prime-marker-allocator.md`, hand off to
`/develop-ai-resource` in upstream mode), and **Finding 4** puts a measured 184–200-line demand on
Slice 4 that the plan did not itemise.
