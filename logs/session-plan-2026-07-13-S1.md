# Session Plan — 2026-07-13 S1

## Intent

Run two picked menu items for mission `w32-migration-execution`, in order: (1) close **R3 Pass 2 prerequisite P2** — the decision-recording contract — via a gate-passed packet; (2) run `/implementation-triage` on the **Session Value Audit** worth-doing question and record the verdict.

## Model

`opus` — matches the active session model (`claude-opus-4-8[1m]`).

Item 1 is a *deciding* task, not a *doing* task: the deliverable is a judgment about which of three mutually-exclusive contract shapes to adopt, each with different blast radius on a shared append-only log and a paired command. Item 2 is an explicit judgment call (`/implementation-triage`). Higher-cognitive-load tier governs the bundle.

## Source Material

- `logs/missions/w32-migration-execution.md` — the two open threads (P2; Session Value Audit).
- `.claude/commands/wrap-session.md` Step 5 + workspace-root `.claude/commands/wrap-session.md` Step 4 — the decision-append rule, in both paired copies.
- `projects/axcion-ai-system-redesign/output/implementation-prep/packets/R3-run-manifest.md` § Execution split — Pass 2's scope and its two-prerequisite gate.
- `projects/axcion-ai-system-redesign/output/implementation-prep/remediation-register.md` — R3 row.
- `docs/spine-schemas.md` § 1 — run-manifest schema; `decisions_refs` ref format.
- `logs/decisions.md` 2026-07-12 (S5) — the decision that named P2.
- `output/context-packs/command-20260713-c4b1e/pack.md` — context pack (`sufficient_to_plan: true`, `sufficient_to_implement: false`).

## Findings / Items to Address

### Item 1 — R3 Pass 2 prerequisite P2 (decision-recording contract)

**The defect, restated precisely.** R3 Pass 2 deletes three wrap-note blocks, one of which is `### Decisions Made`, and replaces it with the run-manifest's `decisions_refs`. But `decisions_refs` can only point at entries that reach `logs/decisions.md`, and wrap **Step 5** (canonical) / **Step 4** (root mirror) appends to `decisions.md` *only* for decisions carrying "analytical or scoping judgment" — it explicitly says **"skip if all decisions were routine."** So a session whose decisions were all routine records them **only** in the block Pass 2 deletes. Both surfaces lost.

**A real divergence the fix must resolve (surfaced by the context pack).** The two paired copies do not currently agree on this step: canonical Step 5 **appends**; the root mirror Step 4 **asks the operator first** ("Should I log any of these decisions to the decision journal?"). Any P2 fix lands on exactly this line, so reconciling the two is unavoidable — it cannot be deferred.

**Three candidate contract shapes.** The packet will carry all three; `/risk-check` adjudicates.

- **Option A — append everything.** Delete the skip-if-routine rule; every decision reaches `decisions.md`. *Cost:* `decisions.md` stops being a curated analytical journal and becomes a mixed log. It is read by `/prime` via `tail -10` — routine entries would push analytical ones out of that window, degrading orientation. Real, recurring, load-bearing cost.
- **Option B — two-tier home.** Keep `decisions.md` curated; give routine decisions a manifest home (e.g. a `decisions_inline` array beside `decisions_refs`). *Cost:* requires an R1 kernel-schema change, and **no consumer would read the new field** — which is precisely the `DR-7` anti-pattern that got a kernel extension **dropped from this very mission** at the 2026-07-12 R3 gate. Presumptively rejected; carried only so the gate can rule on it explicitly.
- **Option C — narrow Pass 2 instead (RECOMMENDED).** Do not change the decision-recording contract at all. Narrow **Pass 2** to cut only `### Files Created` + `### Files Modified` → `files_changed`, and **retain `### Decisions Made`** in the note. Default note goes **8 → 6**, not 8 → 5.
  - *Why this is the strong option:* P2 exists **only** because Pass 2 deletes the block. Retain the block and the prerequisite dissolves — no contract change, no kernel change, no new failure surface on a shared append-only log.
  - *What it costs:* one block of leanness. That block is small (a few bullets). The bulk of wrap-note length is the Files Created/Modified lists (S5's note listed ~19 files), so Option C captures most of the leanness win at none of the data-loss risk.
  - *Precedent:* R3's scope has already been correctly narrowed once at a gate (2026-07-12 RECONSIDER killed the packet's false "11-section" premise and dropped the kernel extension). Narrowing again on evidence is consistent, not a retreat.

**The mission's non-negotiables bind here.** "No roadmap item is implemented without an existing gate-passed packet" and "risk-check-class items pass `/risk-check` **before** execution, not retroactively." P2 has **no packet**. So the sequence is design → packet → gate → implement, and a RECONSIDER/NO-GO is this mandate's `stop_if` — redesign, do not override.

**Note the scope boundary.** Whichever option lands, **Pass 2 itself does not ship this session.** P1's evidence is still a single self-built datapoint (S5 wrote the wiring), and the mission wants the same payload result on 1–2 further *ordinary* wraps. Closing P2 unblocks Pass 2's gate; it does not open it.

### Item 2 — Session Value Audit worth-doing question

**The thread's own premise is stale, and measuring it first changes the question.** The mission records "fired ~2× in 31 sessions" (~6%). Measured against the record: the audit shipped **2026-06-12**; since then there have been **54 sessions** and **7** `### Session Value Audit — 80/20 Review` blocks — **~13%**, roughly double the claimed rate. Still a minority of sessions, but the triage must run against the real number, not the logged one.

- The audit is written by wrap Step 6.4 (canonical) / 4.4 (root), advisory-only, and **never gates** a commit or push.
- Its one downstream consumer is `/friday-checkup`'s Weekly Session Value Review, which greps the heading and the `TYPE:`/`VALUE:`/`SCORE:`/… labels — so a decision to retire it has a named consumer to break.
- It was **already spared once**: the 2026-07-12 R3 RECONSIDER explicitly dropped "retiring `Outcome` / `Session Value Audit` / `Session Assessment`" from the plan. This triage is the deliberate re-opening of that question on its own merits — not a migration side-effect. That distinction is the thread's entire point ("do not let a migration kill it by side effect").
- **Verdict home (a gap the context pack flagged):** `/implementation-triage` is chat-only — it has no designated recording target. This session will record the verdict in `logs/decisions.md`, which also gives it a `decisions_refs` entry at wrap, and close the mission thread.

## Execution Sequence

### Stage 1 — Item 1: P2 packet + gate
1. Read both `wrap-session.md` copies at the decision-append step in full (canonical Step 5, root Step 4) — confirm the divergence and the exact edit surface.
2. Write `packets/P2-decision-recording-contract.md` in the redesign repo: problem statement, the three options above with costs, the paired-copy divergence, a recommendation (Option C), verification plan, and rollback.
3. Run `/risk-check` on the recommended change (structural class: shared-state append-only log + paired command copies + a decision-recording contract).
4. **Gate.** GO / PROCEED-WITH-CAUTION → implement. RECONSIDER / NO-GO → **stop, redesign** (this mandate's `stop_if`); record the redesign, leave P2 open with the reason logged, and continue to Stage 2.
5. On implement: land the change in **both** paired copies in lockstep; reconcile the append-vs-ask divergence; update `docs/spine-schemas.md` § 1 if the ref contract is touched.
6. Update `logs/missions/w32-migration-execution.md` (P2 thread), the remediation register R3 row, and `packets/R3-run-manifest.md` § Execution split.
7. Independent `/qc-pass` on the packet + the applied diff before commit.

### Stage 2 — Item 2: Session Value Audit triage
8. Run `/implementation-triage` on "does the Session Value Audit earn its keep?", supplying the corrected 7/54 (~13%) firing rate, the `/friday-checkup` consumer, and the prior spare-decision as inputs.
9. Record the verdict (WORTH-DOING / MARGINAL / NOT-WORTH-DOING) + rationale in `logs/decisions.md`; close the mission thread.
10. **Do not implement any resulting change this session** — a decision to retire or rework the audit touches `wrap-session` (both copies) *and* `/friday-checkup` (a Critical component) and would need its own packet and gate. The deliverable here is the verdict, not the action.

## Scope Alternatives

- **Reduced:** Item 1 stops at the packet + gate verdict (no implementation), Item 2 as planned. Lands if `/risk-check` returns RECONSIDER, or if context runs short.
- **As planned:** Item 1 designed, gated, implemented, verified; Item 2 triaged and recorded.
- **Expanded (explicitly rejected):** shipping R3 Pass 2 itself once P2 closes. Out of scope — P1's evidence is still thin, and the mission requires 1–2 further ordinary wraps first.

## Autonomy Posture

**Gated.** Structural change class: edits a decision-recording contract, touches a shared append-only log (`decisions.md`), and modifies a **paired** command that must stay in lockstep across two repos. `/risk-check` runs before any implementation, per the mission's own non-negotiable. `/qc-pass` on the packet and the applied diff before commit. Commits land locally; push is batched to wrap.

## Risk

- **Highest risk — silently making the wrap note *more* lossy while claiming to fix loss.** Option A's `decisions.md` bloat degrades `/prime`'s `tail -10` orientation window. Mitigation: the packet costs each option explicitly; the gate rules.
- **Paired-copy drift.** The two wrap copies already disagree at exactly the line being edited. A fix applied to one copy only would deepen a live divergence. Mitigation: lockstep edit; both copies verified by grep after the change.
- **Recommending Option C could read as scope-dodging.** It reduces Pass 2's payoff (8 → 6 rather than 8 → 5). Mitigation: it is put to `/risk-check` as a *recommendation*, not a decision — and the fallback options are carried in the packet, not buried.
- **Item 2's triage acting on a stale number.** The thread's "~2× in 31" is wrong (actually 7/54). Mitigation: corrected figure supplied to the triage as an explicit input, and the correction logged regardless of verdict.
- **Scope creep into Pass 2.** Closing P2 makes shipping Pass 2 feel available. It is not. Mitigation: named in `out_of_scope` on the mandate and in Scope Alternatives above.
