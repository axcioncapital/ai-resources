EVIDENCE
UNIT: 2026-07-29-prime-minimum-responsibility-prove
STREAM: 2026-07-29-prime-minimum-responsibility
PHASE: prove
REPO: ai-resources
BASE: 8b49da2
NEXT: Codex — G2 post-implementation review

**Capability:** prime-runtime-delegation

**Object judged:** `prime.md` at **`8b49da2`** (stream end), not HEAD. HEAD (`f4cf656`) is 411 lines only
because the unrelated retirement commit `38981e5` also edited `session-plan.md` (30 lines) and
`session-start.md` (6). Testing HEAD could not attribute a dispatch failure to this stream versus that
retirement.

**Checkouts used.** All dispatch-class work ran in a scratch fixture created with
`mktemp -d` at `/var/folders/cd/hdqdzkks7zb67xvd7pglm8ym0000gn/T/axcion-prove-WaHq6T`, per the brief's
requirement that the battery never run in a working checkout. Read-only greps and `git show` ran against
the `ai-resources` working checkout. `prime-allocator.test.sh` runs in its own internal sandbox.

---

## Step 4 — premise verification

```
PREMISE: confirmed — `…shape.plan.md` § 6 is still the operative criteria table
  · ran: grep -n "^## " on shape.plan{,-v2,-v3,-v4,-v5}.md, then read each falsification section
  · observed: the per-criterion table (F-LINES … F-QUAL) exists ONLY in plan.md § 6. plan-v2 § 6 and
    plan-v3 § 5 are whole-plan falsification prose with no table; plan-v4 § 6 is "Two governance items";
    plan-v5 has no § 6. No revision amended, replaced or deleted the table.
  · QUALIFICATION (not a rejection): plan-v3 § 5 states "Unchanged from v2, plus:" and adds four
    whole-plan conditions the brief does not carry — P-GATE4, P-VALIDATE, P-EDITVALID, P-RISKORDER.
    P-RISKORDER ("falsified if any structural edit precedes /risk-check") is unsatisfiable as written:
    `/risk-check` was retired 2026-07-30 (`38981e5`). Recorded, not adjudicated here.
  · SECOND QUALIFICATION: the brief says "eighteen criteria". The table carries **nineteen** — two rows
    hold multiple criteria (F-NUM · F-FREE · F-AUTO = 3; F-DIRECT · F-ENG = 2). The brief's derived split
    ("four carried, fourteen remaining") is likewise off: actual is 4 carried, 12 dispatch-requiring,
    3 grep-requiring. Arithmetic only — it changes no criterion's content and nothing was skipped.

PREMISE: confirmed — F-DUP's positive control fires on the pre-change file
  · ran: grep -cE '[Mm]irrors|verbatim|keep the two in sync|keep them in sync|kept in sync|duplicat|
    identical to|copy of|same shape as' on `git show 50cead2:.claude/commands/prime.md`
  · observed: 13 hits at 13 distinct lines. The control fires — the grep can detect the thing it looks for.
  · LIMITATION: § 6 names only three of the eight declarations plus "…", so the plan's exact pattern is
    not reconstructible from the artifact. A documented superset was used. It returns 13 on the control
    rather than the plan's 8, so it is conservative (over-inclusive), never under-inclusive.

PREMISE: confirmed — F-CITE's § 0 C2 grep across the 14 files still resolves
  · ran: per-file extraction of `Step N` tokens from all 14 C2 files at 8b49da2, each checked against
    prime.md@8b49da2; plus a positive control asserting a known-removed id is reported DANGLING
  · observed: 60 citations checked; control fired correctly on 8c.4.5 and 8c.7. The check resolves —
    and it found a real dangling citation (see F-CITE below).

PREMISE: confirmed — F-NOIMPORT: neither CLAUDE.md grew and nothing landed in harness-rules.md
  · ran: wc -l on `git show 50cead2:CLAUDE.md` vs `8b49da2:CLAUDE.md`; `git diff 50cead2 8b49da2 --
    .claude/references/harness-rules.md`; `git log --since=2026-07-29` on the workspace-root repo for
    `CLAUDE.md` and `.claude/references/harness-rules.md`; `@`-import scan of CLAUDE.md@8b49da2
  · observed: ai-resources/CLAUDE.md 81 → 81 (delta 0). harness-rules.md diff empty. Workspace
    CLAUDE.md touched only by `dc30c9d` (the 2026-07-30 QC retirement), not by any stream commit;
    workspace harness-rules.md has no commit since 2026-07-29. Zero `@`-imports added.
```

**No load-bearing premise rejected. The unit proceeds.**

---

## 🔴 F-DISPATCH — the stream's result does not run in 28 of 29 consumers

This is the unit's controlling result. It was found before the behavioural battery and it stops the battery.

**What was run.** Step 8k of `prime.md@8b49da2:278-282` declares `logs/scripts/prime-marker.sh` the
executing owner and gives the caller this exact line, to be run "from the repository root":

```bash
MARKER_LINE=$(bash logs/scripts/prime-marker.sh) || exit 1
```

Two fixtures were built and the identical command run in each, with the same
`CLAUDE_CODE_SESSION_ID` exported:

| Fixture | Root mirrors | Command | Exit | stdout | Marker files written |
|---|---|---|---:|---|---|
| **consumer** | a project consumer's `logs/scripts/` (copied verbatim from `projects/axcion-design-studio`) | as above | **127** | *(empty)* — `bash: logs/scripts/prime-marker.sh: No such file or directory` | **none** |
| **control** | `ai-resources`, which owns the script | as above | **0** | `2026-07-30 S1-pro` | `.session-marker` + `.session-marker-prove-fixture-49973` |

Same command, same environment, same session id. **Only the root differs.** That isolates the fault to
the repo-relative path and rules out a defect in the script itself.

**Consequence.** `|| exit 1` terminates the dispatch. Step 8k runs on *every* non-plan-mode dispatch and
is the shared sub-step referenced by 8a, 8b and 8c, so all three branches abort before the marker is
allocated — and therefore before the header-existence check, the header append and `logs/.prime-mtime`.

**Census, with a positive control.** 28 project consumers carrying `.claude/commands/prime.md` were
checked for `logs/scripts/prime-marker.sh`:

- `prime-marker.sh` present: **0 of 28.**
- Control `check-archive.sh` present: **27 of 28** (absent only in `axcion-crm`). The check demonstrably
  detects a present file, so the 0/28 is evidence, not an empty grep.

**Provenance.** Slice 2 landed the extraction at `6a81121` (2026-07-29). The stream's single real-use
test ran in `ai-resources`, which is the one root where the path resolves — which is why the fault
survived Build.

**Not repaired here.** The brief is explicit: *"Report the failure; do not repair `/prime` inside this
unit."* Zero edits were made to `prime.md` or to any script.

### Criteria this blocks — stopped and marked `unassessed`, never passed

Twelve of the nineteen criteria require a real dispatch that reaches or passes Step 8k. In a project
consumer none of them can be reached; in `ai-resources` they would run, but a result from the single
root where the defect is invisible cannot establish that the stream's result is fit to release.

`F-MENU` · `F-NUM` · `F-FREE` · `F-AUTO` · `F-1GATE` · `F-8AGATE` · `F-8BNOGATE` · `F-ARTIFACTS` ·
`F-DIRECT` · `F-ENG` · `F-MISSION` · `F-FAIL` — **all `unassessed`.**

---

## Criteria measured

| # | Verdict | What was run → what was observed |
|---|---|---|
| **F-LINES** | **FALSIFIED** *(carried)* | `git show 8b49da2:.claude/commands/prime.md \| wc -l` → **413**. Threshold ≤ 300; **shortfall 113**. Per D2 the frozen assertion is not renegotiated. The ≤430 waypoint is met by 17. Recorded falsification — not re-opened. |
| **F-DUP** | **pass** | Superset grep on prime.md@8b49da2 → 4 hits, each read in full: `:287` "(mirrors 8m's Wiring note)" — a cross-reference to a caller contract; `:297` "matches … `${MARKER}` verbatim" — describes `grep -Fx` semantics; `:305` "no duplicate same-day header" — names a *superseded* rule; `:373` "Deduplicate while preserving first-seen order" — auto-mode input parsing. **None is a copied schema.** Control fired at 13 on the pre-change file. |
| **F-CITE** | **FALSIFIED** | `docs/session-marker.md:339` reads *"Cited by `/prime` Step 8c.2, which holds the mechanism"*. `8c.2` occurs **2×** in prime.md@50cead2 and **0×** at 8b49da2. The citation is dangling, and it is **still live at HEAD**. Control: the same check correctly reported the removed 8c.4.5 and 8c.7 as DANGLING. Six further flags were inspected and are false positives — `session-start.md` Step 2.6 and `wrap-session.md` Step 6.5/7a cite their own steps; `repo-architecture.md:246` Step 7a cites `/drift-check`; `session-start.md`'s Step 8c.9 citation is **valid** (8c.9 occurs 5× at 8b49da2). |
| **F-NOIMPORT** | **pass** | See premise 4. Both always-loaded prompts unchanged; nothing landed in `harness-rules.md`; no `@`-imports added. |
| **F-ALLOC** | **pass** | `bash logs/scripts/prime-allocator.test.sh` re-run live today against the running implementation → **`RESULT: 19 passed, 0 failed (all allocator runs executed under ZSH)`**. |
| **F-SEED** | **pass** *(carried)* | Fail-safe seed ordering intact at `prime-marker.sh:67-81`; it is the mutation build-2's control used to force a red run. Not re-derived this unit. |
| **F-QUAL** | **pass** *(carried)* | `prime-marker.sh` traces to the `/develop-ai-resource` disposition recorded as D3. Not re-derived this unit. |

---

## Additional finding — C2's no-renumbering constraint was violated

Not one of the nineteen F-criteria, but a constraint the Shape plan declared **"prohibited, not merely
risky"** (`shape.plan.md` § 0 C2: *"every retained step keeps its current identifier … No step is
renumbered."*). Step identifiers are a published interface cited by 14 files, three of them shell scripts.

`grep -oE "8c\.[0-9]+(\.[0-9]+)?" | sort -u`, pre-change (`50cead2`) versus stream end (`8b49da2`):

- **Removed (7):** `8c.2` · `8c.3.5` · `8c.4.5` · `8c.7` · `8c.7.5` · `8c.8` · `8c.10`
- **Newly minted (3):** `8c.9` · `8c.11` · `8c.12` — none existed pre-change
- **Retained (4):** `8c.3` · `8c.4` · `8c.5` · `8c.6`

The `8c` sub-step space was **renumbered**, not merely delegated. F-CITE's single dangling citation is
the visible symptom; the constraint breach is the cause, and it is the reason a citation sweep after any
future slice cannot be assumed sufficient.

---

## Verdict against the plan's whole-plan falsification clause

`shape.plan.md` § 6 closes: *"The plan is falsified as a whole if the projection exceeds 300; … or any
dispatch path lacks a behavioural proof and a rollback."*

Both limbs are met. The projection exceeded 300 (413, by 113). **Every** dispatch path lacks a
behavioural proof — not because the proofs were skipped, but because the paths do not execute in the
consumers they were built for.

**Recommendation to the operator at G2: decline release.**

---

LIMITATIONS:

- **Twelve criteria are `unassessed`, not passed and not failed.** They were deliberately not run in
  `ai-resources`, where Step 8k resolves, because a green result from the one root that hides the defect
  would be misleading. The stream has therefore **never** had a `/prime` execute its compressed
  orientation text end-to-end in a project consumer — the gap the Prove unit was opened to close remains
  open, now for a known reason.
- **F-SEED and F-QUAL are carried from Build, not re-derived here.** Accepted: both are static
  properties of files this unit confirmed unchanged, and re-deriving them could not have changed a
  verdict already controlled by F-DISPATCH.
- **F-DUP used a superset pattern.** The plan's exact eight declarations are not enumerated in § 6, so
  the plan's precise grep is not reproducible from the artifact. The substitute is over-inclusive and its
  control fires; a residual duplication phrased outside all nine alternates would still be missed.
- **The consumer fixture mirrors `logs/scripts/` only**, not a full project checkout. Sufficient to
  isolate the 8k abort — the failure occurs at process launch, before any other project state is read —
  but it does not exercise the surrounding branch logic, which is exactly what the twelve unassessed
  criteria would have covered.
- **The 28-consumer census counted `logs/scripts/prime-marker.sh` by presence.** It did not verify that
  each consumer's `.claude/commands/prime.md` resolves to the canonical file; the two intentional 33-line
  variants (`workflows/research-workflow`, `axcion-sector-intelligence`) may not reach Step 8k at all.
  This can only understate the blast radius, never overstate it.
- **`docs/session-marker.md:339` was left unrepaired**, as were the renumbering and the 8k path. The
  brief forbids repair inside this unit. Each is a finding for adjudication, not an outstanding task.
- **The scratch fixture was NOT deleted.** Removal was attempted at unit end and the operator declined
  the permission prompt. It survives at
  `/var/folders/cd/hdqdzkks7zb67xvd7pglm8ym0000gn/T/axcion-prove-WaHq6T` and holds no confidential
  material — only two synthetic `logs/scripts/` trees and two allocated test markers. Stated here
  because § Artifacts requires any surviving `WORKDIR` to be named with its reason.
- **`prime.md@8b49da2:409` still invokes `/risk-check`**, retired 2026-07-30 by `38981e5`. Correct at
  the SHA under judgement and outside this unit's scope; noted so the Land unit does not rediscover it.
