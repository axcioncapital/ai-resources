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
- [ ] Implement **R3 Pass 2** — the 3-section wrap-note cut (`Files Created` / `Files Modified` / `Decisions Made` → `files_changed` / `decisions_refs`, taking the default note 8 → 5) + repoint `session-feedback-collector`'s note-grep input signals at the manifest with absent-manifest fallback. **Gated on Pass 1 having demonstrably fired on real sessions.** Status 2026-07-12: the full lifecycle (start-stub → running `files_changed` → close+validate at wrap) is now proven end-to-end on **one** real session (`logs/runs/2026-07-12-S1.json`: `stop_reason=completed`, `outcome=DELIVERED`, 15 files). **Gate is open but thin** — that one run was self-verified by the session that wrote the code, which is the weakest possible evidence. Before starting Pass 2, confirm 2–3 *ordinary* wraps (sessions not paying attention to the manifest) also produced **closed** manifests (`stop_reason`/`outcome` non-null in `logs/runs/*.json`). Shipping the cut against a flaky close path means a session loses its file/decision record from *both* surfaces.
- [x] **M-A Phase 0 defect batch — packet written + M-A1 / M-A2b / M-A3b / M-A3c shipped and verified (2026-07-12 S2).** Packet: `packets/M-A-phase0-defects.md`. Two `/risk-check` RECONSIDERs and one `/qc-pass` AGREE-WITH-FIXES; every gate caught a real defect the session had missed. Headline: **`tweak.md` was *executing* `git push`** at two sites — every `/tweak` run pushed mid-session, violating the gated-push rule. The push contradiction is now closed across **all four** live copies for the first time (the roadmap named two). Carve-out from the deferred instruction-leanness campaign, by explicit operator decision (`logs/decisions.md` 2026-07-12 S2).
- [ ] **M-A remainder (small):** **M-A2a** — declare tiers at the command-side / inline-spawn sites (`/plan-draft`, wrap 6.4 spawn, drift/contract subagents, skill-eval subagents, RRP investigator, WF10); the agent-side half was already done (42/42). **M-A4** — reconcile `docs/agent-tier-table.md` + `skills/CATALOG.md` against the 42-agent ground truth. **M-A3a** — duplicate startup-context injection is **not reproducible** from static state; needs transcript telemetry, and must not be "fixed" speculatively.
- [ ] **Separate question (not R3):** the Session Value Audit has fired ~2× in 31 sessions. Whether it earns its keep is an `/implementation-triage` call — do not let a migration kill it by side effect.

> **Method lesson, 2026-07-12 (S2) — worth carrying into every future packet.** The session ran a currency check on all four M-A rows and confirmed each finding was live. It was still not enough: `/risk-check` caught that a **9-day-old sibling campaign had already scoped the identical push fix** with richer mitigations. A currency check must ask **two** questions — *"is the defect still live?"* **and** *"does a plan for this fix already exist?"* Verifying the finding without scanning for sibling efforts lets two plans converge on one file, and the weaker one lands first. Three further lessons: **grep the invariant stem, never the templated form** (a `"model"`-with-quotes grep missed a banned declaration written as prose); **a test that cannot fail is not a test** (the planned "does the commit succeed?" check would have passed with the bug live); and **a `[det]` "mechanical" tag is a hypothesis, not a warrant** — both M-A3 infra items carried judgment-bearing hidden coupling that a deterministic diff-and-copy would have shipped broken.

> **Gate record, 2026-07-12 (R3).** `/risk-check` → **RECONSIDER**; SO consulted per this mission's non-negotiable ("SO-flagged items get SO review before execution"). Both caught that the R3 packet's central justification was false. Scope redesigned, not overridden (`principles.md § DR-8`). **Removed from the mission entirely:** extending the R1 kernel doc (`DR-7` — no consumer reads the proposed fields) and rewiring `/friday-checkup`'s roll-up.

**Dropped 2026-07-09 (S2), operator directive.** **F1** (federation-schemas kernel doc) and **PJ** (propagation join) were removed from active work. PJ hard-depends on F1's `canonical_sources` schema (`packets/PJ-propagation-join.md` § Prerequisites), so dropping F1 orphaned it. Both register rows read `dropped`; the W3.2 roadmap is unchanged, so the items remain recoverable from the design record. Rationale and the hand-edit exception: `logs/decisions.md` (2026-07-09). Note: this edit was made in-session because `/mission` has no remove-thread action — see the same decisions entry.
