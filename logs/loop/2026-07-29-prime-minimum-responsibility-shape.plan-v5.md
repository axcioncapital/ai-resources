PLAN — v5 (AMENDMENT, supersedes v4's § 4 arithmetic and § 5 options)
UNIT: 2026-07-29-prime-minimum-responsibility-shape
STREAM: 2026-07-29-prime-minimum-responsibility
PHASE: shape (amendment to a closed unit — same governance caveat as v4 § 6a)
REPO: ai-resources
BASE: 8d7af92
NEXT: Claude — resume Build Slice 2 under this amendment

**Plan-v4 is immutable and is not edited.** This document supersedes its § 4 arithmetic and § 5
option set. Everything else in v4 — the § 1 baseline, the § 2 rule, the § 3 itemisation, the § 6
governance items — stands unchanged and is not restated here.

**No implementation edit was made by this document.** It is measurement and package amendment only.

---

## 0 · Why v4 needs amending

Plan-v4 was written **before** the qualification it depended on returned. Its § 5 offered three
options and its § 4 arithmetic rested on two cells that the qualification then disproved.

`/develop-ai-resource` returned on 2026-07-29 (unit `…-build-2`, disposition recorded as **D3** in
`projects/axcion-ai-system-owner/development/prime-runtime-delegation.md`). Its verdict:

> **One deterministic script qualified — `logs/scripts/prime-marker.sh`, owning marker allocation
> only. Step 1a's git cross-check and Step 1d's mission scan were qualified and DECLINED for v1**,
> each with a named reopening trigger.

Two consequences follow, and both move the numbers the wrong way.

---

## 1 · Option (ii) is foreclosed. Only the allocator is delegable in v1.

Plan-v4 § 5 option (ii) read: *"Hold Slice 4 and cash F10 properly — route Step 1a's cross-check and
Step 1d's mission scan to executing owners … It enlarges Slice 2's scope from one artifact to three."*

**That option no longer exists for this mission revision.** D3 weighed all three responsibilities and
they came apart on evidence:

| Responsibility | D3 verdict | Why | Reopens when |
|---|---|---|---|
| **Marker allocation (8k)** | **build** | The only one with an executing consumer *already forced to scrape it out of markdown* — and that scrape has already failed in the way that matters (2026-07-14: "12 passed, 0 failed" against a stale copy holding none of that session's fix) | — |
| **Step 1d mission scan** | **decline** | Its whole justification was that `mission.md:47–48` duplicates it. **That premise is false** — `mission.md` *cites* `/prime`; it carries no such shell. What remains is 19 lines with no executing consumer and no logged defect | a second consumer needs `ACTIVE_MISSIONS`, or Step 1d acquires a logged defect |
| **Step 1a git cross-check** | **decline** | Its scan half is deterministic, but its classification half is explicitly judgement (`prime.md:121–125`) — distinctive-keyword matching, generic-token dropping, and a conservative "when in doubt, still-open" floor. That half cannot leave the prompt; splitting it puts a seam mid-step to move ~15 lines | the classification is itself specified deterministically, or a second consumer needs the merged commit-subject set |

**So F10's 66 lines are not merely uncashed — they are uncashable in v1.** Plan-v4 named them "the
single biggest line saving available" and correctly said cashing them requires the scans to become
*executed by an owner*. The qualification has now answered whether they can be: **one can, two
cannot.** This is a real finding, not a shortfall in effort — a judgement-bearing scan inside an
executable prompt is in the right place.

---

## 2 · Two of plan-v4's own budget cells rested on a premise that has since been rejected

Plan-v4 § 3 gave Step 1d a rationale destination of *"`.claude/commands/mission.md:47–48` **already
carries the identical repo enumeration and `logs/missions/*.md` active-only scan** — cite it rather
than restate"*, and budgeted **A = 12 / B = 6** against it.

Build-2 premise **P1b** tested exactly that claim and **rejected** it:

> Run: search of `.claude/commands/mission.md` for `for d in` / `for repo in` /
> `rev-parse --show-toplevel` / `logs/missions/*.md` / `WORKSPACE_ROOT`, plus a direct read of `:40–60`.
> Observed: **REJECTED.** `mission.md` contains **no shell** implementing this. Line 47 is a single
> prose sentence that *cites* `/prime`. The dependency runs the **opposite** way from the claim.

There is therefore **no citation destination for Step 1d**, and its budget must rise to what rationale
removal alone can reach. Same correction applies to Budget B's Step 1a cell (16), which assumed
relocating executable shell into `docs/backlog-reconciliation.md` — a route plan-v4 § 2 itself calls
the not-recommended fate, and which D3 has now additionally declined as a script.

| Cell | v4 | v5 | Basis for the change |
|---|---:|---:|---|
| Step 1d — Budget A | 12 | **16** | citation destination does not exist (P1b); only rationale moves |
| Step 1d — Budget B | 6 | **16** | same; B had no additional lever here |
| Step 1a — Budget B | 16 | **54** | = Budget A's preserved figure. Executable relocation is the disrecommended fate; script delegation declined by D3 |
| **Orientation total — A** | **275** | **279** | +4 |
| **Orientation total — B** | **172** | **220** | +48 |

---

## 3 · Slice 2 is now MEASURED, not projected

Plan-v4's LIMITATIONS flagged this exact exposure: *"Slice 2's −135 is carried from plan-v3,
unverified. It rests on 8k reaching 12 lines after extraction … If the integrated call site needs
more than 12, every 'after Slice 2' figure above moves up."* It does, slightly.

| | Value | How derived |
|---|---:|---|
| Step 8k live region, before | `prime.md:366–512` = **147** lines, **11,130** chars | `sed -n '366,512p' \| wc -l` / `wc -c` |
| Step 8k call site, after | `prime.md:366–380` = **15** lines, **2,293** chars | same, post-edit |
| **Slice 2 reduction** | **−132** lines | 147 − 15 |
| `prime.md` after Slice 2 | **503** | `wc -l`, measured post-edit — not arithmetic |

The call site is 15 rather than plan-v3's assumed 12 because it retains two things that are *rules*
under § 2, not rationale: the **caller contract** paragraph (the marker → header → mtime ordering that
`/session-start` Step 3 and `/session-plan` Step 0 both depend on), and the **do-not-reinline**
instruction, without which a later editor may reasonably paste the block back.

**Orientation-cost delta, the figure that matters more than `wc -l`:** the 11,130-char prose region is
read by **29 consumers** (28 symlinks + 1 canonical, derived by `find … -name prime.md -path '*/commands/*'`
partitioned by `-L`); the 2,293-char call site replaces it, for **−8,837 chars per read**. The
script's own 10,143 chars are **executed, never model-read** — which is the whole point of the
substitution and the reason `wc -l` understates the win.

**Correction against this document's own first draft.** It was drafted at a 14-line call site and
−133; applying it revealed the splice had consumed the blank line separating 8k from 8h, and restoring
that separator made the true figures 15 and −132. Both were corrected here before this plan was
committed. The record's earlier `~4-line call site → ~493` projection (D3, § Current phase) is
superseded: **the real call site is 15 lines and the real result is 503.**

---

## 4 · Revised arithmetic

| | Budget A (behaviour-preserving) | Budget B (aggressive ceiling) |
|---|---:|---:|
| `prime.md` now | 635 | 635 |
| Less Slice 2 (**measured, landed**) | −132 | −132 |
| **After Slice 2** | **503** | **503** |
| Orientation 356 → | 279 | 220 |
| Less merged Slice 4+5 (estimated) | −77 | −136 |
| **After Slice 4** | **426** | **367** |
| **≤430 waypoint** | **met**, by 4 | **met**, by 63 |
| **≤300 mission target** | missed by **126** | missed by **67** |

**The ≤300 target remains FALSIFIED, and by a wider margin than v4 reported.** Plan-v4 put Budget B
within **16** lines of the target; correcting the two rejected-premise cells puts it **67** short. The
"missed by a small margin" reading in v4 § 4 does not survive this amendment — it was an artefact of
budgeting two cells against a duplication that does not exist.

**Per the operator's 2026-07-29 scoping of plan-v4's conclusion**, this is *"≤300 is falsified for the
current relocation-only package"* — **not** *"≤300 is impossible"*. The mission's ≤300 acceptance
assertion stays **frozen** and is **not** renegotiated to fit this result (D2). If the mission closes
with the target unmet, it is recorded unmet.

---

## 5 · What remains open

- **The ≤430 waypoint is now reachable under Budget A** — 426, with 4 lines of margin. That is the
  one figure that improved, and only because Slice 2 is real rather than projected. **4 lines is
  not a safe margin** against eleven un-drafted regions carrying ±15; treat the waypoint as
  *plausibly* reachable under A, not as secured.
- **Slice 4 is unchanged in scope** and is **not** authorised by this amendment. Per the operator's
  standing instruction this unit stops after Build-2 closes; Slice 4 needs its own unit.
- **Independent review of the qualified artifact is still outstanding** (D3's gate note). `/risk-check`,
  `/qc-pass` and subagent dispatch are **operator-declined** for this session and this document —
  recorded as **declined**, never as passed, satisfied or waived.

---

## LIMITATIONS

- **The eleven un-drafted regions from v4 § 3 are still un-drafted.** Only Steps 0 and 1a were reduced
  to concrete replacement text before counting. This amendment corrects three cells against measured
  evidence and inherits the rest of v4's apportionment, including its ±15-line uncertainty. That
  uncertainty does not change either verdict: Budget A's 125-line gap and Budget B's 66-line gap both
  exceed it comfortably.
- **Only Slice 2 is measured by execution.** The Slice 4 figures remain structural estimates. No
  `/prime` has been run down any dispatch branch to confirm the call site behaves in production —
  Slice 2's evidence rests on the deterministic suites, not on a live orientation.
- **The −10,390 char/read figure counts characters, not tokens.** The direction is not in doubt; the
  magnitude in tokens was not measured.
- **This amendment has had no independent review**, extending rather than closing the unreviewed
  surface v4 already carried.
- **The governance gap v4 § 6a recorded is unresolved and now applies twice.** `docs/work-loop.md`
  still defines no path for amending a G1-approved package mid-Build; this is the second such
  amendment written under the same chosen-not-prescribed shape. Logged at
  `logs/improvement-log.md` (2026-07-29, `medium-high`).
