# Session Plan — S1 (2026-06-04)

## Intent
Execute AI-strategy Slot 1 (closure sweep / DECIDE) leanly — batch-decide the trivial items in one verdict table, spend real judgment only on the three items that warrant it (E7, E8, F6), execute the genuinely one-line closures, and record the "closure before detection" principle.

## Model
opus (deciding work — conflict adjudication + principle authoring) — match (active: claude-opus-4-8[1m]).

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/ai-strategy/ai-operator-roadmap.md` — Slot 1 spec.
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/ai-strategy/candidate-backlog.md` — §D pure-decisions bucket.
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/ai-strategy/working/candidate-backlog-notes.md` — row detail for E2–E10 (read only the E-rows).
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/ai-strategy/principles-base.md` — target for the principle.
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/ai-strategy/implementation-tracker.md` — Slot 1 status surface.

## Findings / Items to Address
**Tier 1 — trivial, batch-decide (one verdict + one-line rationale each, no formal card):**
1. E1 — doc-scanner-agent → graduate (already decided; record + optionally run `/graduate-resource`).
2. F1 — retire `/produce-handoff` (superseded by `/develop-memo`).
3. F2 — superseded-header housekeeping (low blast radius).
4. E2–E10 — for each: graduate-now / generalise-first (park with a recorded next action) / park. Quick decision; generalisation *execution* is deferred, not done here.

**Tier 2 — warrants real judgment (the only items that get scrutiny):**
5. E7 — nordic-pe auto-commit hook vs workspace Commit Rules → adjudicate + record the fix.
6. E8 — obsidian-pe-kb model field in settings vs no-model rule → adjudicate + record the fix.
7. F6 — 16 verbatim CLAUDE.md "Session Boundaries" copies → pointers. Decide CONVERT vs leave; **structural, `/risk-check` before any edit.**

**Tier 3 — adoption step:**
8. Record the "closure before detection" principle into `principles-base.md`.

## Execution Sequence
1. **Read the E-rows** in the working notes (E2–E10 detail only) + skim §D. *Verify:* enough detail to assign each E-item a verdict.
2. **Build the Tier-1 verdict table** — one row per trivial item (E1, F1, F2, E2–E10): verdict + one-line rationale + (if any) next action. *Verify:* no Tier-1 item left undecided.
3. **Execute the one-line closures** that are safe and in-scope (E1 record/graduate, F1 retire, F2 clean). *Verify:* done on disk or explicitly deferred with a reason.
4. **Adjudicate E7 + E8** against their conflicting rules; record verdict + concrete fix. **Stop point** before editing the hook/settings — confirm the resolution first. *Verify:* each names the rule it resolves.
5. **Decide F6.** Record CONVERT-vs-leave verdict; if CONVERT, **run `/risk-check`** before any edit; execute only on GO, else record routed-not-executed. *Verify:* risk-check verdict logged if conversion chosen.
6. **Write the principle** into `principles-base.md`, ID consistent with the file's convention. *Verify:* present and well-formed.
7. **Update the tracker** — mark Slot 1 status, append changelog line, note where verdicts live. *Verify:* tracker reflects per-item status.
8. **`/qc-pass`** on the principle + verdict table before declaring complete.

## Scope Alternatives
- **Lean (recommended):** Tier-1 batch table + one-line closures, real adjudication of E7/E8, decide F6 (defer its edit behind `/risk-check`), write the principle. The honest "near-zero build" reading.
- **Decide-only:** record verdicts for all 18 + principle, execute nothing (even E1/F1/F2 deferred). Use if you'd rather review the table before any action lands.
- **Heavier:** also execute F6's 16-file conversion and the E2–E10 generalisations this session — not recommended for a closure sweep; defer to later slots.

## Autonomy Posture
Gated — only at the three Tier-2 items. Tier-1 batch decisions and the principle proceed without per-item pauses.

**Stop points:**
- Before editing the E7 hook / E8 settings (confirm the resolution).
- Before executing F6's conversion (`/risk-check` first; execute only on GO).

## Risk
Tier-1 items carry no structural risk. Structural classes live only in E7 (hook), E8 (settings), F6 (cross-cutting CLAUDE.md). Run `/risk-check` before any of those three edits; Tier-1 needs none.
