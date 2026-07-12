---
mission_id: w32-migration-execution
mission_name: Execute the W3.2 migration roadmap in ai-resources
status: active
started: 2026-07-09
---

<!--
  MISSION CONTRACT — a multi-session goal that individual sessions serve.
  Scaffolded by `/mission create`. Frozen at creation like a /contract-check contract:
  the Goal / In-Out scope / Definition of done sections are the north star and should
  not drift session-to-session. Only `status` (frontmatter) and `## Open threads` are
  meant to change over the mission's life, both edited via `/mission` — never hand-edited
  from inside a working session, and never written to by /session-start.

  "Sessions served" is NOT stored here — `/mission read` renders it live by scanning
  logs/session-notes.md for the `Mission: {mission_id}` mandate bullet.
-->

## Goal

Every W3.2 roadmap item whose implementation home is `ai-resources` is built, verified, and closed — each one only after its packet (`axcion-ai-system-redesign/output/implementation-prep/packets/`) has passed its required gates.

## In scope / Out of scope

- **In:** Implementing/verifying roadmap items from `axcion-ai-system-redesign/window-outputs/W3.2-migration-roadmap.md` (Phases 0–4, 46 items) whose "Impl. home" is `ai-resources` — the majority: Phase 0 defect fixes, Phase 2 command dedup/merges, Phase 3 federation work, etc.
- **Out:** user-layer settings changes (RT1, R2, R5 — different implementation home, not this repo); any roadmap item without a gate-passed packet yet; `ai-resources` maintenance unrelated to a W3.2 roadmap item.

## Validation contract

> Written now, at mission creation — before any implementation session. Defines "done" and "on-mission" independently of how the work gets done, so a fresh-context check (`/drift-check`, `/contract-check`, `/qc-pass`) can judge against it rather than against a session's own account of itself.

**Acceptance assertions** — concrete statements that must ALL be true when the mission is complete:
- [ ] Every `ai-resources`-homed W3.2 item has a `verified` packet and a matching register row in `axcion-ai-system-redesign/output/implementation-prep/remediation-register.md`.
- [ ] Every closed item has a rollback plan that was either exercised or explicitly waived (logged).
- [ ] Every closed item met its packet's §8 verification-level floor (mechanical/functional/mandate/independent/real-world, per target-arch §2.8).

**Non-negotiables** — boundaries no session may cross, even if locally convenient:
- No roadmap item is implemented without an existing gate-passed packet (steering-function Rule 1 — no raw finding becomes work).
- SO-flagged items (SO-coordination `needed` in the register) get SO review before execution, not after.
- Risk-check-class items pass `/risk-check` before execution, not retroactively.

**Off-mission signals** — what drift looks like for THIS mission (feeds `/drift-check`):
- `ai-resources` work with no W3.2 roadmap ID attached to it.
- Implementing a change whose packet doesn't exist yet, or exists but hasn't passed its listed gates.
- Editing a protected zone (`ai-resources/docs/protected-zones.md`) without the required review.

## Open threads

- [x] Write **R1** (spine-schemas kernel doc: run-manifest/defect/escalation/verification/taxonomy) — prerequisite for R3 and R4. **Done 2026-07-09** (`ai-resources/docs/spine-schemas.md`, commit `98c7466`; register row `verified`). Checkbox ticked 2026-07-12 — it had lagged the work because `/mission` has no thread-level check-off action (see the `improvement-log.md` entry, 2nd occurrence).
- [x] Implement **R3 Pass 1** (durable run-manifest: `run-manifest.sh` + start-stub at both mandate-confirmation points + advisory close/validate at wrap) per `packets/R3-run-manifest.md`. **Done + verified 2026-07-12** — level 1+2, **24/24**; regression suite `logs/scripts/run-manifest.test.sh`; live manifest `logs/runs/2026-07-12-S1.json` (full lifecycle: start-stub → running `files_changed` → closed at wrap). Independent `/qc-pass` → AGREE-WITH-FIXES, all 5 applied.
- [ ] **R3 Pass 2 — BLOCKED (gate closed 2026-07-12 S4). Do not start; the prerequisite below is not met.** The cut (`Files Created` / `Files Modified` / `Decisions Made` → `files_changed` / `decisions_refs`, note 8 → 5) + repointing `session-feedback-collector`'s note-grep signals at the manifest.
  - **The old gate said:** confirm 2–3 *ordinary* wraps produced **closed** manifests. **On that test the gate PASSES** — S1, S2, S3 all closed (`stop_reason=completed`, `outcome=DELIVERED`), two of them ordinary. **Do not act on that.**
  - **That test was a proxy, and it is wrong.** Pass 2 does not depend on the manifest *closing*; it depends on the manifest **carrying the payload** the retired sections carry. Measured on payload: `files_changed` populates reliably (15 / 16 / 9), but **`decisions_refs` is empty on every ordinary session** — S2 `[]` while making 5 decisions, S3 `[]` while making 2. Only S1 populated it, and S1 is the session that *wrote R3* — the one datapoint that cannot count as evidence.
  - **Root cause:** `wrap-session.md` **never calls** `run-manifest.sh --decisions-ref`. The script supports the append (L247–249, L302–304); the wrap flow simply does not use it. The field is dead on arrival.
  - **Had Pass 2 shipped today**, S2's five decisions and S3's two would have had no home in the manifest — the wrap note's `### Decisions Made` deleted, the replacement empty. Exactly the both-surfaces data loss the two-pass split exists to prevent.
  - **Reopen only when BOTH prerequisites below are met.** P1 is now closed; **P2 is open**, so Pass 2 stays BLOCKED. *(The original one-condition framing of this gate was itself incomplete — see the S5 method lesson.)*
    - **P1 — `decisions_refs` is actually written, and proven by payload. ✅ CLOSED 2026-07-12 (S5).** `wrap-session` now passes `--decision-ref` at close in **both** paired copies (canonical Step 12d + workspace-root Step 4.7). Ref format is defined **once** in `docs/spine-schemas.md` § 1 and referenced (not restated) by both copies, so they cannot drift on it: `logs/decisions.md#{slug-of-header-text}` — *not* `{date}-{marker}`, which plan-time `/risk-check` proved **collides on real data** (two distinct `## 2026-07-12 (S4)` entries flatten to one anchor). Proven by payload on this session's own manifest: `logs/runs/2026-07-12-S5.json` carries 2 refs, both resolving to real headers, with a negative control confirming the check can fail. Repeatable checker: `logs/scripts/check-decision-refs.sh`. **Still wanted before Pass 2:** the same payload result on 1–2 further *ordinary* wraps — S5 is one datapoint and it is the session that built the wiring, so it carries the same "cannot count as its own evidence" caveat that disqualified S1.
    - **P2 — every decision the wrap note carries must have a manifest-referenceable home. ❌ OPEN, untouched.** Found in S5; the original gate never asked this. Wrap **Step 5** appends to `decisions.md` **only** for decisions carrying "analytical or scoping judgment" — it explicitly says *"skip if all decisions were routine."* Routine decisions therefore live **only** in the wrap note's `### Decisions Made` block — **exactly what Pass 2 deletes.** Since `decisions_refs` can only point at what reaches `decisions.md`, wiring P1 alone does **not** make Pass 2 safe: a routine-decision session would still lose its record from both surfaces. Closing P2 means changing the decision-recording contract itself (Step 5's skip-if-routine rule) — its own structural change, its own gate, its own session. Recorded: `logs/decisions.md` 2026-07-12 (S5); independently confirmed by `/risk-check` Dimension 6.
  - **Method lesson (S4):** a gate must test the property the downstream change *depends on*, not a proxy that correlates with it.
  - **Method lesson (S5) — the same error, one level up.** S4 replaced a bad test (`stop_reason`) with a good one (`decisions_refs` payload) and still under-specified the gate, because it never asked what *else* the wrap note carries that the manifest would have to absorb. Having found the right property to test, check that it is the **only** one. Closing *a* prerequisite is not closing *the* prerequisite.
- [x] **M-A Phase 0 defect batch — packet written + M-A1 / M-A2b / M-A3b / M-A3c shipped and verified (2026-07-12 S2).** Packet: `packets/M-A-phase0-defects.md`. Two `/risk-check` RECONSIDERs and one `/qc-pass` AGREE-WITH-FIXES; every gate caught a real defect the session had missed. Headline: **`tweak.md` was *executing* `git push`** at two sites — every `/tweak` run pushed mid-session, violating the gated-push rule. The push contradiction is now closed across **all four** live copies for the first time (the roadmap named two). Carve-out from the deferred instruction-leanness campaign, by explicit operator decision (`logs/decisions.md` 2026-07-12 S2).
- [x] **M-A remainder — CLOSED 2026-07-12 (S4).** The M-A Phase 0 batch is now complete.
  - **M-A2a — done** (commit `69b4bde`). Pinned `model: opus` at the **six** live inline `general-purpose` spawn sites: `drift-check:45`, `contract-check:114`, `resolve-repo-problem:41`, `create-skill:35`, `improve-skill:49`, `migrate-skill:52`. An un-pinned `general-purpose` spawn carries no tier and silently inherits the *session* model — so on a Sonnet/Haiku session these six judgment dispatches were quietly running under-tier. Not a new convention: `/qc-pass`, `/refinement-pass`, `/refinement-deep`, `/risk-check` and `/friday-journal` have pinned tiers at such sites since 2026-07-03; this extends the established rule to the sites that were missed. Verified 6/6, no `[1m]` suffixes, assertion proven falsifiable against a negative control.
  - **M-A2a — three roadmap-named sites were STALE, now dispositioned:** `/plan-draft` **does not exist** in `ai-resources/.claude/commands/`; `wrap-session.md` has **no inline spawn at all** (it dispatches *named* agents, which carry their own frontmatter — no gap); **WF10** is not an ai-resources command. Recorded rather than silently skipped — a silent skip is how a stale claim survives to the next audit as a "you missed this."
  - **M-A4 — done** (commit `960b104`). `agent-tier-table.md`: +5 missing rows (`diagnostics-scanner`, `expert-check-reviewer`, `lean-repo-auditor`, `project-state-scrub-verifier`, `project-state-snapshot-agent`); 2 rows **relocated, not deleted** (`qc-gate`, `verification-agent` were listed as canonical but are live *research-workflow* agents — deleting them would have destroyed a true record); nordic-pe section flagged stale (project is archived). 0 tier mismatches. `skills/CATALOG.md`: +20 skills (the header had said "60" since April while the library grew to **80**); 0 dead rows. Both asserted by script.
  - **M-A3a — remains deferred, correctly.** Duplicate startup-context injection is not reproducible from static state; it needs transcript telemetry and must not be "fixed" speculatively.
- [ ] **Separate question (not R3):** the Session Value Audit has fired ~2× in 31 sessions. Whether it earns its keep is an `/implementation-triage` call — do not let a migration kill it by side effect.

> **Method lesson, 2026-07-12 (S2) — worth carrying into every future packet.** The session ran a currency check on all four M-A rows and confirmed each finding was live. It was still not enough: `/risk-check` caught that a **9-day-old sibling campaign had already scoped the identical push fix** with richer mitigations. A currency check must ask **two** questions — *"is the defect still live?"* **and** *"does a plan for this fix already exist?"* Verifying the finding without scanning for sibling efforts lets two plans converge on one file, and the weaker one lands first. Three further lessons: **grep the invariant stem, never the templated form** (a `"model"`-with-quotes grep missed a banned declaration written as prose); **a test that cannot fail is not a test** (the planned "does the commit succeed?" check would have passed with the bug live); and **a `[det]` "mechanical" tag is a hypothesis, not a warrant** — both M-A3 infra items carried judgment-bearing hidden coupling that a deterministic diff-and-copy would have shipped broken.

> **Gate record, 2026-07-12 (R3).** `/risk-check` → **RECONSIDER**; SO consulted per this mission's non-negotiable ("SO-flagged items get SO review before execution"). Both caught that the R3 packet's central justification was false. Scope redesigned, not overridden (`principles.md § DR-8`). **Removed from the mission entirely:** extending the R1 kernel doc (`DR-7` — no consumer reads the proposed fields) and rewiring `/friday-checkup`'s roll-up.

**Dropped 2026-07-09 (S2), operator directive.** **F1** (federation-schemas kernel doc) and **PJ** (propagation join) were removed from active work. PJ hard-depends on F1's `canonical_sources` schema (`packets/PJ-propagation-join.md` § Prerequisites), so dropping F1 orphaned it. Both register rows read `dropped`; the W3.2 roadmap is unchanged, so the items remain recoverable from the design record. Rationale and the hand-edit exception: `logs/decisions.md` (2026-07-09). Note: this edit was made in-session because `/mission` has no remove-thread action — see the same decisions entry.
