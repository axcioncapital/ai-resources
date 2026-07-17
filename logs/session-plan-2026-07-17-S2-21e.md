# Session Plan — 2026-07-17 (S2-21e)

## Intent

Run three urgent telemetry-/gate-integrity backlog fixes in order: (1) align the usage-log writer with its tail-reader (PREPEND → APPEND-at-tail); (2) add a pre-dispatch premise-verification step to the `/risk-check` and `/consult` gate paths; (3) harden `system-owner` — the last reviewer that can state a fabricated count with full confidence. All three are `[urgent]` items in `logs/improvement-log.md`; each closes by an actual-file-text edit verified against the running file, not a code-read.

## Model

Opus 4.8 (1M context) — match. Item 1 is mechanical; items 2 and 3 are gate-design judgment (blast radius across symlinked gate commands, and the architectural authority's output contract). Higher-cognitive-load tier governs the bundle → opus.

## Source Material

- `logs/improvement-log.md` — 2026-07-15 entry (usage-log writer PREPEND vs tail-reader; item 1).
- `logs/improvement-log.md` — 2026-07-14 entry "Gates are dispatched onto UNVERIFIED premises" (item 2).
- `logs/improvement-log.md` — 2026-07-14 entry "The premise check was administered to the two agents that weren't sick: system-owner fabricated a count" (item 3).
- Verified edit targets: `.claude/commands/usage-analysis.md:58`; `skills/session-usage-analyzer/SKILL.md:118,122`; `.claude/commands/risk-check.md:84-91` (Step 3 spawn); `.claude/commands/consult.md:88-107` (Step 4 delegate); `.claude/agents/system-owner.md:95-121` (Phase 5 output contract); `docs/audit-discipline.md:36-62` (When to fire / semantics).
- `logs/scripts/check-usage-log-format.sh` — the existing guard; premise-verified to enforce APPEND-AT-TAIL, so item 1's fix aligns with it.

## Findings / Items to Address

### Item 1 — usage-log writer instructs PREPEND, reader reads the tail
- `usage-analysis.md:58`: "insert the new entry directly below the `<!-- entries below -->` marker (above all existing entries)" — a PREPEND. Reader (`/prime` Step 1, `tail -n 30`) reads the tail. Writer and reader disagree; a literal follow re-creates the 2026-07-14 (S2) bug on every capture.
- `SKILL.md:118` ("to insert at the top of the log after the marker") and `SKILL.md:122` ("Inserts the trend summary below the `<!-- entries below -->` marker") repeat the prepend for the TREND maintenance entry.
- Guard confirmation: `check-usage-log-format.sh` enforces append-at-tail; TREND headers (`### TREND — …`) are excluded from its dated-header checks (2 & 4), so appending the trend entry at the tail does not trip the guard.
- Fix: change all three to APPEND-at-the-end (tail). Smallest correct fix; no reader change (reader design out of scope, per the entry's own note).

### Item 2 — gates dispatched onto unverified premises
- `risk-check.md:84` (Step 3 spawn) and `consult.md:88` (Step 4 delegate) hand a change description / question straight to an expensive reviewer with no step that checks the description's own claims first. Root cause behind ~360k of review reasoning from a plan carrying five factual errors.
- Fix (structural, not a new command): a pre-dispatch premise step — run every script the payload cites, open every line it cites, re-derive every count; any failing claim is corrected in the change description before the subagent sees it. Insert as a numbered step immediately before the spawn in both commands. Add a short gate-scope note to `audit-discipline.md` so the discipline is documented where the gate rules live.

### Item 3 — system-owner is the one reviewer still unhardened
- `c3c0334` added Dimension 7 / premise checks to `risk-check-reviewer` and `qc-reviewer` but not `system-owner`. It fabricated a 27× count this session and built four conclusions on it.
- Fix: port the premise-check clause into `system-owner.md`'s Phase 5 output contract — every count, path, and quoted line must cite the command that produced it; an uncited claim is marked a guess and may not carry a conclusion; state the *primitive* used, not just the number (`[ -f ]` follows symlinks; a glob cannot see a report named after its subject). Mirror the `risk-check-reviewer` "your re-derivation wins" wording + its converse. Add a one-line pointer in `consult.md`'s Step 4 dispatch brief.

## Execution Sequence

### Stage 1 — Item 1 (usage-log writer)
1. Edit `usage-analysis.md:58` PREPEND → APPEND-at-tail.
2. Edit `SKILL.md:118` and `:122` PREPEND → APPEND-at-tail for the TREND entry.
3. Re-read both to confirm; status-flip the 2026-07-15 improvement-log entry to applied.

### Stage 2 — Item 2 (pre-dispatch premise check)
4. Insert a premise-verification step before `risk-check.md` Step 3's spawn (item 11).
5. Insert the mirror step before `consult.md` Step 4's delegate.
6. Add a gate-scope note to `audit-discipline.md`. Status-flip the 2026-07-14 entry.

### Stage 3 — Item 3 (harden system-owner)
7. Add the premise-check / cite-the-command / state-the-primitive clause to `system-owner.md` Phase 5 output contract.
8. Add the one-line pointer to `consult.md` Step 4 brief. Status-flip the 2026-07-14 entry.

### Stage 4 — Verify + commit
9. `/qc-pass` posture: inline re-read of every edited file against the mandate; run `check-usage-log-format.sh` if usage-log shape is touchable. Commit the batch. Do NOT push (batched to wrap).

No per-item operator pause — the single approval gate covers all three. Between stages, emit a one-line between-gate summary.

## Scope Alternatives

- **Minimal:** item 1 only (one-line writer fix, lowest risk, existing guard already backstops it). Drops the two gate-hardening items that carry the real blast radius.
- **As planned (recommended):** all three — they are the session's three open HIGH/urgent items and share a single theme (writer/reader and gate/premise integrity).
- **Maximal:** also fold in the adjacent 2026-07-14 `warn-settings-change.sh` fail-open and the grep-gitignore audit-blindness items. Rejected — out of the picked set; separate risk profiles.

## Autonomy Posture

Full autonomy for the edits, gated by one pre-execution `/risk-check` on the combined set (structural class: canonical gate-command + agent-contract edits, symlinked across checkouts). No separate qc-reviewer stacked on top — inline re-read + the risk-check is the verification tier (Subagent Proportionality; do not stack gates).

## Risk

- **Blast radius:** items 2 and 3 change `/risk-check`, `/consult`, and `system-owner` behavior across all checkouts that use them. Additive and strictly safer (more verification), high reversibility (git-tracked command/agent files). This is why the plan-time `/risk-check` runs.
- **Item 1:** lowest risk; aligns with an existing guard.
- **Premise self-check applied:** every cited line/behavior above was re-read from the running files before this plan and before the risk-check — the exact discipline item 2 encodes, applied to this plan.
- **STRUCTURAL_RISK = true** → `/risk-check` before execution; on RECONSIDER/NO-GO, pause and retain plan + mandate for revision.
