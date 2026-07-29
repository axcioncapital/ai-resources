PLAN — v4 (AMENDMENT)
UNIT: 2026-07-29-prime-minimum-responsibility-shape
STREAM: 2026-07-29-prime-minimum-responsibility
PHASE: shape (amendment to a closed unit — see § 6)
REPO: ai-resources
BASE: fe00955
NEXT: operator — approve, amend or reject before any Build unit opens

**No implementation edit was made.** Nothing in `.claude/commands/prime.md` or any other object under
work was touched. This document is measurement and package amendment only.

---

## 0 · What this amends and why

Plan-v3 § 3 defines **Slice 4** ("slim the orientation steps by citing owners") and **Slice 5**
("headroom compression", contingent). Build-3's Finding 4 measured the trajectory and found the
remaining line demand concentrated almost entirely in Slice 4, at a magnitude the plan never
itemised — § 2's budget table carried "all other steps" as a single aggregate row of 251.

This amendment does what Finding 4 said was owed **before** Slice 4 opens:

1. Merges Slice 5's orientation compression into Slice 4 (both target the same steps — 1b, 1c, 6).
2. Expands Slice 4's explicit scope to the whole orientation region, Steps 0–7 plus the preamble.
3. Itemises every affected step: live lines, replacement budget, responsibility retained, rationale
   destination, expected reduction.
4. Tests the result against a **≤430** waypoint after Slice 4, which leaves ~5 lines of margin once
   Slice 2 removes its projected 135.

**Preserved by instruction, and honoured in every budget below:** Step 1a's git cross-check, Step 3's
`medium-high` menu-reach behaviour, Step 7's reply classifier. **Slice 3 is closed and is not
reopened.** Slice 4 may run before the blocked Slice 2 — orientation compression does not depend on
allocator extraction.

**Verdict, stated up front: the ≤300 target is FALSIFIED.** § 4 gives the measured basis. Under the
behaviour-preserving budget `prime.md` lands at **554** after Slice 4 (**419** after Slice 2); under
an aggressive budget that relocates executable rules into reference docs it lands at **451**
(**316** after Slice 2). Neither reaches the ≤430 waypoint, and neither reaches ≤300.

---

## 1 · Measured baseline — every line accounted for

`wc -l .claude/commands/prime.md` = **635**. Region boundaries derived from
`grep -nE "^[0-9]+[a-z]?\. "`, not from the plan.

| Region | Lines | Count |
|---|---|---:|
| Preamble (frontmatter, Principle, Output discipline, Execution discipline) | 1–12 | 12 |
| Step 0 — Pull latest | 13–70 | 58 |
| Step 1 — Read session-notes | 71–94 | 24 |
| Step 1a — Cross-check + concurrent-session signals | 95–163 | 69 |
| Step 1b — Resumable scratchpad | 164–175 | 12 |
| Step 1c — Plan position | 176–214 | 39 |
| Step 1d — Active missions | 215–233 | 19 |
| Step 2 — next-up.md | 234–237 | 4 |
| Step 3 — Urgent-problem scan | 238–276 | 39 |
| Step 4 — Exception checks | 277–288 | 12 |
| Step 5 — Task menu | 289–308 | 20 |
| Step 6 — Brief template | 309–347 | 39 |
| Step 7 — Reply classifier | 348–356 | 9 |
| **Orientation subtotal (Slice 4 + merged Slice 5 scope)** | **1–356** | **356** |
| 8m mission binding | 357–365 | 9 |
| 8k marker allocation *(Slice 2: → 12)* | 366–512 | 147 |
| 8h session-entry write *(Slice 3, landed)* | 513–539 | 27 |
| 8a · 8b · 8c dispatch branches | 540–635 | 96 |
| **Dispatch subtotal** | **357–635** | **279** |

Orientation 356 + dispatch 279 = 635. ✓ Independently confirms Build-3 Finding 4's 356.

**Required cut.** 635 − 430 = **205 lines**, all from a 356-line region → orientation must reach
**151**, a 57.6% cut.

---

## 2 · The rule that governs every budget below

> **An executable rule stays in `prime.md`. Only rationale moves.**

A *rule* is anything `/prime` must evaluate, run, or produce: a shell command, a branch condition, a
value carried to a later step, a literal output line. *Rationale* is why the rule exists — the
incident that produced it, the alternative rejected, the "do not simplify this" warning.

This is not a stylistic preference. It follows from the mission's own non-negotiable — *"Behaviour-
preserving. A smaller `/prime` that behaves differently fails this mission. Size is the target;
behaviour is the constraint, and the constraint outranks the target."*

**Why a rule cannot be delegated to a reference doc the way a responsibility can.** Slices 1 and 3
delegated to `/session-start` and `/session-plan` — *commands, which execute*. The owner actually
runs the logic, so `prime.md` shrinks and the behaviour survives. A reference doc does not execute.
A rule moved into `docs/*.md` has exactly two fates:

- `/prime` reads the doc at orientation to run the rule → `wc -l` falls, **token cost does not**. This
  is the mission's own named off-mission signal ("the cut looks achieved and the token cost is
  unchanged or worse") in a different shape.
- `/prime` does not read it → **the rule silently stops firing.** Behaviour loss.

Both budgets are therefore reported. **Budget A** relocates rationale only. **Budget B** additionally
relocates executable shell into owner docs and is shown to establish the ceiling, not to recommend it.

---

## 3 · Itemised replacement budget

Rationale destinations are **existing** documents only. No new document is created to hold displaced
prose. Where a destination needs a new *section*, that is noted — an added section in an existing doc,
never a new file.

| Region | Live | Responsibility retained in `prime.md` | Rationale destination | **A** | **B** |
|---|---:|---|---|---:|---:|
| Preamble | 12 | Frontmatter; the Principle; plain-English output rule; the batching instruction | Merge "Output discipline" + "Execution discipline" into one line; the three ordering dependencies are already restated at their own steps | **10** | **10** |
| **0** Pull | 58 | Git-root + `AI_RESOURCES` derivation; behind-check code and its 3 outcomes; the pull command; mid-rebase detect → abort → record → continue; autostash-pop detection (3 OR-signals); 4 exit-code cases; unpushed-count clause; do-not-stop | `docs/commit-discipline.md` — **new § Orientation pull** (doc currently has no pull section): the 2026-07-14 S5→S8 incident (`:30–40`), why `--rebase --autostash` is explicit (`:44–46`), why a half-rebased repo at session start is an incident (`:56–57`) | **42** | **15** |
| **1** session-notes | 24 | The 2-call grep→offset read recipe; the log-trio tails; the telemetry-gap flag and its emit condition | `docs/heavy-read-discipline.md` — why a fixed last-N window is unreliable, why the `^## [0-9]` anchor is safe, the token-audit R4 provenance | **16** | **14** |
| **1a** Cross-check | 69 | **PRESERVED:** anchor derivation, the merged multi-repo `--since` scan, likely-DONE / still-open classification, git-failure fall-through. Plus `SIBLING_COUNT`, the read-only `FOREIGN_SHARED` status check, `LIVE_FOREIGN_HERE`, and the two Step-6 carries | `docs/backlog-reconciliation.md` (already carries the scan **verbatim** at § The git cross-check mechanism, and § Keyword-match tolerance / § Classification / § Fall-through) — takes the dual-repo blindspot rationale, the sibling-extension explanation, the cost note. `docs/session-marker.md` § Concurrent-session detection — takes the multiple-same-day-headers-is-normal note and the hook-vs-step liveness explanation | **54** | **16** |
| **1b** Scratchpad | 12 | Glob, mtime selection, QC-PENDING precedence + date-supersession exemption, the date comparison, the menu-candidate hand-off, the commit-block advisory | `docs/qc-independence.md` § Subagent-unavailable fallback — the QC-PENDING commit-block rationale; the filename-timestamp-skew explanation | **9** | **7** |
| **1c** Plan position | 39 | The 3-case cascade, spine→single-file resolution, the bounded grep+offset read, path-1 no-git-call rule, path-2 one-git-call ceiling, readiness verdict, `PROJECT_POSITION` | `.claude/commands/project-next-steps.md` Step 2 (already the cited cascade source) — the deliberate position-before-spine inversion and its reason. `docs/heavy-read-discipline.md` — the "never a full Read" cost argument and the 2026-07-19 900-line verification | **29** | **16** |
| **1d** Missions | 19 | The active-only scan and `ACTIVE_MISSIONS` shape; the carries to Steps 5, 6, 8 | `.claude/commands/mission.md:47–48` **already carries the identical repo enumeration and `logs/missions/*.md` active-only scan** — cite it rather than restate | **12** | **6** |
| **2** next-up | 4 | Read, collect unchecked items, absent-is-normal | Merge the two paragraphs | **3** | **2** |
| **3** Urgent scan | 39 | **PRESERVED:** all three bounded scans verbatim, including the `medium-high` severity anchor; the include/exclude filter with `medium-high` named in the include clause; the policy-change rule (narrowing requires `wrap-session.md` 12e + `session-feedback-collector.md` + a `decisions.md` record in the same commit) | `docs/heavy-read-discipline.md` — the ~50–60k-per-orientation cost history, the `-B6` window sizing, the two anchor widenings (2026-07-18, 2026-07-19) and the backtick exclusion, the count-not-content design essay, the 2026-07-24 near-miss narrative | **30** | **22** |
| **4** Exceptions | 12 | Working-tree recheck; model line always carried; pull-result exception; phase-README scan | Collapse the 4-case model ladder to 2 lines (one tier named → compare; anything else → plain line, never a nudge). Workspace `CLAUDE.md` § Model Tier already owns the no-defaults rule and the `/new-project` step-11a deletion | **9** | **7** |
| **5** Menu | 20 | All five candidate sources and their tags; the same-repo mission filter; rank order; the 6-item cap; the conversion rules; the no-dedupe rule | Drop the two worked examples (the conversion rules carry the instruction); compress the cross-repo defense-in-depth note | **16** | **14** |
| **6** Brief | 39 | **The 32-line fenced template is the command's output contract** — every ⚠/◎ line is a real emit case. Collapse the 6 rendered menu lines to 2 + an "up to 6" note (line 344 already states the rule); keep the omit-when-unset rules | Nothing relocatable: an output template read from a doc would be read every session | **36** | **34** |
| **7** Classifier | 9 | **PRESERVED ENTIRE** — all six branches, the `N auto`-before-bare-number ordering, the ambiguity re-ask | — | **9** | **9** |
| **Orientation total** | **356** | | | **275** | **172** |

---

## 4 · The arithmetic, and the falsification

| | Budget A (behaviour-preserving) | Budget B (aggressive ceiling) |
|---|---:|---:|
| Orientation now | 356 | 356 |
| Orientation after merged Slice 4+5 | 275 | 172 |
| Reduction | **−81** | **−184** |
| `prime.md` after Slice 4 | **554** | **451** |
| **≤430 waypoint** | missed by **124** | missed by **21** |
| Less Slice 2 (8k 147 → 12) | −135 | −135 |
| `prime.md` after Slice 2 | **419** | **316** |
| **≤300 mission target** | missed by **119** | missed by **16** |

**Neither budget reaches ≤430. Neither reaches ≤300. Per the instruction governing this amendment,
the ≤300 plan is declared falsified before any editing.**

Note that Budget B lands within 21 lines of the waypoint and 16 of the target — Build-3's Finding 4
estimated 184–200 for Slice 4 and Budget B's −184 sits at the bottom of that range. **The target is
missed by a small margin, not a large one.** That matters for what happens next (§ 5): this is a
target that needs re-setting, not a mission that needs abandoning.

### Three independent findings behind the shortfall

**F8 — Step 6's floor is a hard one, and plan-v3's budget for it was unreachable.** Plan-v3's Slice 5
line budgets its steps at their *post-Slice-4* sizes: `1b 10→6`, `1c 12→4`, `6 24→20`. Working
backwards, Slice 4 was assumed to take Step 6 from **39 → 24**. Step 6 is 7 lines of instruction plus
a **32-line fenced output template**, and every line of that template is a distinct emit case (model,
working tree, pull, autostash conflict, shared-file advisory, concurrent-session nudge, phase
READMEs, QC-PENDING commit-block, telemetry gap, active missions, the `Where we are` block, the menu,
the input prompt, the `/open-items` footer). Reaching 24 requires deleting emit cases; reaching the
Slice 5 figure of 20 requires deleting more. Both are behaviour changes, not compression. Measured
floor is 34–36.

**F9 — Step 1c's combined budget of 4 lines is below its irreducible shell.** Plan-v3's Slice 5 puts
Step 1c at **4 lines**. Step 1c contains two mandatory code blocks (the bounded grep + offset read;
the path-2 `date -r` + single `git log`) totalling 8 lines of shell before any prose. Measured floor
is 16 even under Budget B.

**F10 — the two largest apparent wins are duplications that cannot be cashed without cost.**
`docs/backlog-reconciliation.md` § The git cross-check mechanism carries `/prime` Step 1a's merged
scan **verbatim**, and `.claude/commands/mission.md:47–48` carries Step 1d's repo enumeration and
active-only mission scan **verbatim**. Together these are the single biggest line saving available
(Budget B takes 1a from 69→16 and 1d from 19→6, −66 combined). But `prime.md` is an *executable
prompt*: citing the doc means reading it at orientation to run the scan. `docs/backlog-reconciliation.md`
is 111 lines and `mission.md` is 140 — reading either to recover 66 lines of `prime.md` is a net token
loss, and not reading them means the scans stop firing. **The duplication is real; the win is not.**
Cashing it properly requires the scans to become *executed by an owner* (a script or a command), which
is Slice 2's route, not Slice 4's.

---

## 5 · What the falsification does and does not mean

**It does not refute the mission's premise.** `/prime` genuinely was 830 lines doing work that
belonged elsewhere; Slices 1 and 3 have already delegated 195 of them to owners that execute, with the
allocator tripwire green at 19/0 after each. That work stands.

**What is refuted is the number.** ≤300 was set at mission creation from a reading-derived estimate —
plan-v3's own LIMITATIONS records that "fourteen of nineteen per-step budgets remain apportioned from
reading prose". This is the first measurement of the orientation region against named, existing owner
documents, and it says the reachable floor with behaviour intact is **≈419**, or **≈316** if
executable rules are relocated into docs at a token cost that defeats the purpose.

**Three options for the operator.** Recommendation is (i).

- **(i) Re-set the target to ≤430 and run merged Slice 4+5 under Budget A** — a real, behaviour-safe
  −81 on the orientation region, landing 554 → 419 after Slice 2. Honest, verifiable, preserves every
  named constraint. Requires amending the mission's first acceptance assertion, which is a `/mission`
  write and an operator act.
- **(ii) Hold Slice 4 and cash F10 properly** — route Step 1a's cross-check and Step 1d's mission scan
  to *executing* owners (scripts, qualified through `/develop-ai-resource` alongside `prime-marker.sh`,
  which is already blocked on the same route). This is the only path that recovers those 66 lines
  without paying for them in reads. It enlarges Slice 2's scope from one artifact to three.
- **(iii) Accept Budget B and land ~316** — closest to the original number, but it relocates executable
  rules into reference docs. This violates the mission's behaviour-preserving non-negotiable unless
  every relocated rule is read at orientation, in which case the token cost rises while `wc -l` falls.
  **Not recommended.**

---

## 6 · Two governance items this amendment must record

**(a) This is a material post-G1 package amendment, and `docs/work-loop.md` defines no path for one.**
G1 approved a slice list at the end of the Shape unit; that unit is **closed** (`31080b0`). § Artifacts
gives plans a `-vN` revision mechanism but binds each artifact to its unit, and § The challenged route
places G1 "at the end of the Shape unit" with no re-arming procedure once Build has begun. So there is
no defined answer to *how a G1-approved package is amended mid-Build*. This document takes the
conservative reading — write the amendment as the Shape unit's `plan-v4`, make no implementation edit,
and return to the operator for explicit approval before any Build unit opens — but that shape is
**chosen, not prescribed.** The gap is logged to `improvement-log.md` so it outlives this stream's
artifact deletion.

**(b) The mission's first non-negotiable is unmet, and two Build units have already run against it.**
`logs/missions/lean-prime-2026-07.md` requires: *"The scope conflict at `.claude/commands/work-loop.md:247`
('Never edits `/prime`') versus `docs/work-loop.md` § Execution boundary must be resolved by an
**explicit operator decision recorded in `logs/decisions.md`** before any unit edits `prime.md`. It
survived two Codex review rounds unnoticed on the closed allocator stream; it may not be settled by
silence a third time."* A grep of `logs/decisions.md` returns **no such entry**. Plan-v3 § 7.4 item 2
disposed of it as *"authority already resolved by the command's own conflict rule; the text is a defect,
routed separately"* — which is a self-resolution by the hand writing the plan, the exact settlement mode
the non-negotiable forbids. Slices 1 and 3 edited `prime.md` under it. **Not fixed here** — it needs an
operator decision in `logs/decisions.md`, and `.claude/commands/work-loop.md:247` still reads "Never
edits `/prime`" today.

---

## LIMITATIONS

- **The replacement budgets are drafted-and-counted for Steps 0 and 1a only.** Those two are 127 of
  356 lines and were reduced to concrete replacement text before being counted. The other eleven
  regions are apportioned by applying § 2's rule line-by-line to text read in full — better grounded
  than plan-v3's aggregate row, but not drafted. A ±15-line error across the eleven would not change
  the verdict under Budget A (124 lines short) and would not close Budget B's 21-line gap either.
- **Nothing was executed.** No `/prime` run, no dispatch, no behavioural check. Every figure is
  structural: `wc -l`, `grep -n` boundaries, and reading. The claim that a given block is a "rule" and
  another is "rationale" is a judgement applied consistently, not a measurement.
- **The relocation destinations were checked for existence and topical fit, not for capacity.**
  `docs/commit-discipline.md` has **no** pull-related section today, so Step 0's rationale needs a new
  section in it (an existing doc gaining a section — not a new file, but more than a paste).
  `docs/session-marker.md` § Concurrent-session detection documents the *hook*
  (`detect-concurrent-session.sh`), **not** `prime.md`'s inline `SIBLING_COUNT` / `FOREIGN_SHARED` /
  `LIVE_FOREIGN_HERE` logic — so Budget B's 1a relocation would *add* ~25 lines to a doc already at 385.
- **Budget B's token claim is reasoned, not measured.** No token counts were taken for
  `docs/backlog-reconciliation.md` (111 lines) or `mission.md` (140 lines) versus the `prime.md` lines
  they would replace. The direction of the inequality is not in doubt at those sizes; the magnitude is
  not established.
- **The ≤430 waypoint was supplied, not derived here.** It is checked, not independently justified.
  Its arithmetic (430 − 135 = 295, ~5 lines of margin) is confirmed correct against the measured 8k
  size of 147.
- **Slice 2's −135 is carried from plan-v3, unverified.** It rests on 8k reaching 12 lines after
  extraction. 8k's live size of 147 is measured and confirmed here; the residual 12 is not. If the
  integrated call site needs more than 12, every "after Slice 2" figure above moves up.
- **This amendment has had no independent review.** Plan-v3 reached G1 unreviewed after its F1/F2
  corrections; this document extends that unreviewed surface rather than closing it.
