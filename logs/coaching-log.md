# Coaching Log

Coaching feedback captured via `/coach`. Newest entries at the bottom.

### 2026-04-24
**Coverage:** 35 sessions (2026-04-06 through 2026-04-23)

| Dimension | Rating | Trend |
|-----------|--------|-------|
| Iteration Efficiency | Healthy | ↑ |
| Decision Patterns | Watch | → |
| QC Disposition | Healthy | ↑ |
| Delegation Effectiveness | Healthy | → |
| Workflow Evolution | Healthy | ↑↑ |

**The One Thing:** Push a subset of material design decisions from session notes to `decisions.md` with the same rigor used for the ones already logged. ~40% of session design forks are described only in session notes; a 60-second pre-wrap pass closes the gap.
**Prior recommendation status:** N/A (first coaching run — baseline)

### 2026-05-01
**Coverage:** 12 sessions (2026-04-27 through 2026-05-01) + 35 coaching-data entries (2026-04-06 through 2026-04-28)

| Dimension | Rating | Trend |
|-----------|--------|-------|
| Iteration Efficiency | Healthy | → |
| Decision Patterns | Watch | → (sub-pattern shifted) |
| QC Disposition | Healthy | → |
| Delegation Effectiveness | Healthy | → |
| Workflow Evolution | Healthy | ↑↑ |

**The One Thing:** Treat your interruption-impulse as a deliberate review gate, not a correction. `editorial-disagreement` gate fired 5/5 changed across visible window — every pushback produced a structural rule change or scope correction. State the impulse explicitly before issuing the directive so rationale is captured at generation time rather than retrofitted through triage.
**Prior recommendation status:** Substantially acted on — decisions/session rose from ~1 to 3.25 (3.25× increase); 65% of new decisions enumerate alternatives.

---

### 2026-05-08

**Coverage:** 13 sessions (2026-05-01 → 2026-05-07), 9 decisions, 8 QC cycles. Coaching-data lags session-notes — only 1 entry post-2026-05-01 baseline, friction-log dormant since 2026-04-18.

**Findings**

| Dimension | Rating | Trend | Note |
|-----------|--------|-------|------|
| Iteration Efficiency | Watch | ↓ | Design-class artifacts: 5 REVISE in 8 QC cycles. Execution sessions: pass cleanly. |
| Decision Patterns | Healthy | ↑ | 8/9 decisions enumerate alternatives. M1-revert exemplifies the "challenge upstream rec, log principle" pattern. |
| QC Disposition | Watch | → | First-pass quality on plans/commands has slipped. All findings applied; no DISAGREE. |
| Delegation Effectiveness | Healthy | → | H5 subagent + risk-check pattern continues. No scope drift. |
| Workflow Evolution | Watch | mixed | Forward velocity high (/monday-prep, weekly-cadence, /deploy-kb shipped); backward resolution stalled (5 improvement-log entries pending 10–16 days; friction-log dormant 3+ weeks). |

**The One Thing:** For design-class sessions (new plan/command/brief), spend the first 5 minutes writing the constraint set: target users, output shape, what it replaces, what it explicitly does NOT do, which paths/commands it references. The 2026-05-05 cluster spent 2 QC rounds discovering verifiable filesystem facts (`/systems-review` doesn't exist, harness path is workspace-root). The 2026-05-07 mid-session approach pivot is the same shape — format constraint discovered late.

**Prior recommendation status:**
- 2026-05-01 "interruption-impulse as deliberate review gate" — substantially acted on (M1-revert decision is the textbook case).
- 2026-04-24 "decisions.md rigor" — acted on (89% of decisions enumerate alternatives).
- New gap opened on design-session first-pass quality (verifiable factual errors caught in QC).

---

### 2026-05-08b

**Coverage:** 12 sessions (2026-05-02 → 2026-05-08), 14 decisions, 8 QC cycles. Coaching-data: 4 new entries since prior run. qc-log.md absent; friction-log 1 new event (2026-05-08).

**Findings**

| Dimension | Rating | Trend | Note |
|-----------|--------|-------|------|
| Iteration Efficiency | Watch | mixed | Dominant driver shifted from "verifiable factual errors" to "under-read upstream artifacts before disposition." |
| Decision Patterns | Healthy | ↑ | 100% alternatives-considered; plan-approval gate changed 42% of the time (highest-leverage review point). |
| QC Disposition | Watch | → | First-pass REVISE ratio unchanged (5/8). Prior recommendation not measurably acted on. |
| Delegation Effectiveness | Healthy | → | H5 + risk-check pattern continues. J16 correctly kept main-session. |
| Workflow Evolution | Watch | mixed | 4 commands shipped; same 5 improvement-log entries pending + 1 new orphan. |

**The One Thing:** Match read scope to disposition consequence. Before any step that produces a disposition or schema binding to an existing artifact (sibling command, consumer regex, prior advisory), read that artifact fully and quote its load-bearing lines into working notes. This is the "constraint set" advice made specific: quoted text from upstream artifacts, not summaries.
**Prior recommendation status:**
- 2026-05-08 "constraint set first 5 minutes" — partially acted on (mechanism diagnosed more precisely, no ritual change yet visible).
- 2026-05-01 "interruption-impulse as deliberate review gate" — held (stable).
- 2026-04-24 "decisions.md rigor" — held (100% alternatives-considered this window).
**Promotion candidates:** 2 flagged (decisions.md rigor, interruption-impulse gate) — Promotion candidates section absent from agent output; follow-up needed to make section fire reliably.

### 2026-05-16
**Coverage:** 16 session-notes entries (2026-04-25 → 2026-05-16); 35 coaching-data entries (2026-04-06 → 2026-05-11); 7 decisions; ~55 QC cycles (qc-log absent — reconstructed)

| Dimension | Rating | Trend |
|-----------|--------|-------|
| Iteration Efficiency | Healthy | ↑ |
| Decision Patterns | Watch | → |
| QC Disposition | Healthy | ↑ |
| Delegation Effectiveness | Healthy | → |
| Workflow Evolution | Watch | mixed |

**The One Thing:** Before invoking a synthesis/orientation command (`/prime`, `/consult`, `/friday-act` 30-line peeks), name the load-bearing claim it will produce; if a sub-300-line targeted Read could verify that claim directly, do the Read first. Same root cause behind 2026-05-08 `/consult` 95k-token burn, 2026-05-08 SO-advisory under-read, and 2026-05-11 `/prime` Bundles 1/2/5 stale-state misreport.
**Prior recommendation status:** 2026-05-08b "match read scope to disposition consequence" — partially acted on; recurred 2026-05-11 as `/prime` Next-Steps staleness (third occurrence, promoted to RECURRING in improvement-log).
**Promotion candidates:** 2 — (1) decisions.md rigor (100% alternatives-considered held); (2) interruption-impulse-as-review-gate (Bundle 4 W2.4 abandon-design-when-shipped is textbook). Full notes: audits/working/coaching-ai-resources-2026-05-16.md

### 2026-05-16 (friday-checkup weekly)
**Coverage:** 13 session-notes entries (2026-05-11 → 2026-05-16) + 40+ coaching-data entries (2026-04-06 → 2026-05-11)

| Dimension | Rating | Trend |
|-----------|--------|-------|
| Iteration Efficiency | Healthy | ↑ |
| Decision Patterns | Watch | → |
| QC Disposition | Healthy | ↑ |
| Delegation Effectiveness | Healthy | → |
| Workflow Evolution | Watch | mixed |

**The One Thing:** Run one dedicated `/resolve-improvement-log` execution session against the three 2026-05-16 entries (session-start confirmation token, /prime single-snapshot RECURRING, /session-plan sparse template). All three have execution-ready Proposal blocks. The `/prime` issue is now its third occurrence — promoted to RECURRING. A fourth occurrence would be a coaching failure, not a system failure.
**Prior recommendation status:** 2026-05-16 prior recommendation "name the load-bearing claim before synthesis/orientation commands" — partially acted on (operator caught /prime Next-Steps staleness mid-session, but structural fix remains logged-pending; same root cause repeated).
**Promotion candidates:** 3 — (1) Mandate + class + scope discipline (constraint-set first; ready to graduate from habit to template field); (2) decisions.md alternatives-considered rigor (held 86–100% across 4 cycles); (3) interruption-impulse as deliberate review gate (editorial-disagreement gate 100% change-rate). Bright-line-review gate flagged as rubber-stamp (78% confirm) — recommend naming the specific bright-line before invoking. Full output retained in agent run context.

### 2026-05-20
**Coverage:** 51 sessions (2026-04-11 → 2026-05-20), 44 coaching-data entries, ~110 gate outcomes — doubled as the harness A7 verification pass

| Dimension | Rating | Trend |
|-----------|--------|-------|
| Iteration Efficiency | Healthy | → |
| Decision Patterns | Watch | → |
| QC Disposition | Healthy | → |
| Delegation Effectiveness | Healthy | → |
| Workflow Evolution | Watch | mixed |

**The One Thing:** When invoking a bright-line gate (`/risk-check`, or any pause framed as a structural-review beat), state the specific bright-line being checked in one sentence first; if you cannot name it, say "proceed" immediately. `bright-line-review` is the only rubber-stamp gate in the corpus (83% confirm, up from 78% on 2026-05-16) and the one prior recommendation that did not land. Every other gate is well-calibrated (`plan-approval`/`qc-disposition` ~53–55% change rates; `editorial-disagreement` 5/5).
**Prior recommendation status:** 2026-05-16 (friday-checkup) "run a dedicated `/resolve-improvement-log` session" — acted on (6-entry improvement-sprint + archive cleared the backlog stall). 2026-05-16 "name the load-bearing claim before synthesis commands" — not measurably acted on; the bright-line rubber-stamp persists and is now The One Thing.
**Promotion candidates:** 3 — (1) decisions.md alternatives-considered rigor (held 86–100% across 5 cycles; graduate to a template field via `/improve`); (2) interruption-impulse as review gate (editorial-disagreement 5/5; encode in Decision-Point Posture); (3) mandate + class + scope discipline — already routed to harness A7 Constraint 1; the Governor build (Track B) will graduate it.
**A7 verification:** Constraints 1–3 in `harness/prep/a7-scope-note.md` tested against the corpus — Constraint 1 CONFIRMED, Constraints 2–3 CONFIRMED-WITH-REFINEMENT. Scope note updated v1→v2.

### 2026-05-22
**Coverage:** 10 session-notes entries (2026-05-11 → 2026-05-22), 44 coaching-data entries

| Dimension | Rating | Trend |
|-----------|--------|-------|
| Iteration Efficiency | Healthy | → |
| Decision Patterns | Watch | → |
| QC Disposition | Healthy | → |
| Delegation Effectiveness | Healthy | → |
| Workflow Evolution | Watch | mixed |

**The One Thing:** Name the bright-line before you review it. When `/risk-check` or any structural-review pause fires, state the specific bright-line in one sentence first; if you cannot name one, say "proceed" and reclaim the time. `bright-line-review` is the only gate that does not earn its review cost (~79–83% confirm across 4 cycles) and is the recommendation that has survived three coaching cycles unactioned.
→ Codified 2026-05-28 in skills/ai-resource-builder/references/review-principles.md (fix-plan wave-1).
**Prior recommendation status:** 2026-05-20 One Thing (name the bright-line) — not measurably acted on; carried forward again. decisions.md alternatives-rigor held (14/14). 2026-05-16 backlog-sprint held (no new stall), but 2 pre-sprint improvement-log entries remain unresolved and 4 new ones were added 2026-05-22 — Workflow Evolution stays Watch.
**Promotion candidates:** 2 — (1) decisions.md alternatives-considered rigor (held 6 consecutive cycles; graduate to a decisions.md template field via `/improve`); (2) interruption-impulse as deliberate review gate (editorial-disagreement + challenge-disposition 7/7 changed; encode in Decision-Point Posture).

### 2026-05-29
**Coverage:** 15 sessions (2026-05-27 → 2026-05-28)

| Dimension | Rating | Trend |
|-----------|--------|-------|
| Iteration Efficiency | Solid | → |
| Decision Patterns | Strong | ↑ |
| QC Disposition | Strong | ↑ |
| Delegation Effectiveness | Solid | → |
| Workflow Evolution | Mixed | → |

**The One Thing:** Stage push-gate-class structural removals earlier in the day, not late. Today's push-gate removal (commit `50977b3`) and parallel Wave 2/3 executions produced the `ea93d62` commit-attribution swap where a parallel Wave 3 session absorbed your Wave 2 prime.md edits — the friction class you're still working to eliminate (TOCTOU on shared files) was actively biting your own concurrent sessions while you fixed it. Serialize structural-class changes that touch shared infra (push rules, marker writes, session-notes headers) ahead of execution sweeps.
**Prior recommendation status:** Acted on — 2026-05-22 "name the bright-line" codified 2026-05-28 in `review-principles.md § All Reviews` (wave-1 id-20, commit `f598ee1`), closing a 3-cycle carryover. decisions.md alternatives-rigor held (10/10 in window, each with 3+ alternatives enumerated). id-31 Phase 1 structural fix shipped against the TOCTOU class flagged in prior cycles.
**Promotion candidates:** 2 — (1) decisions.md alternatives-considered rigor (held 7 consecutive cycles, 10/10 this window — graduate to a decisions.md template field via `/improve`); (2) bright-line-naming principle (codified 2026-05-28 — graduate from coaching habit to structural rule check via `/improve`).
