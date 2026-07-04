# Risk Check — 2026-07-04

## Change

Refactor /wrap-session for leanness. Change set:
(1) NEW ai-resources/logs/scripts/foreign-session-guard.sh — extract the ~250-line inline Step 3.5 foreign-session detector from wrap-session.md into a standalone script that emits a one-line/JSON verdict (FOREIGN, FOREIGN_CLASS, EXTRA_TODAY_MANDATES, EXTRA_PRIOR_MANDATES, plus the diagnostic GUARD line + grep output). BOTH wrap-session copies call it. Behavior must stay byte-identical to the current inline detector — same signals (today-header delta + mandate-line delta), same marker-aware attribution (per-id logs/.session-marker-${CLAUDE_CODE_SESSION_ID}, shared-marker fallback, NO_OWN_MARKER guard, clobber-safe recovery, PRIME_RAN legacy path), same FOREIGN_CLASS classifier (CONCURRENT/REMNANT/MIXED/UNKNOWN), same id-14 date-rollover grace window, same OWN_CONTENT_IN_HEAD discriminator.
(2) EDIT ai-resources/.claude/commands/wrap-session.md (canonical) — replace the inline Step 3.5 block with ~10 lines that call the script and interpret its verdict; flip the default to CORE-ONLY (scratchpad, archive check, guard, session note, decisions, commit+gated push, marker teardown) with all optional passes opt-in via flags (bare /wrap-session = core; /wrap-session full = all; selective +audit / +feedback / +coaching / +telemetry) — this REPLACES the current preflight two-question prompt; CUT Step 9 (shared command-drift ask) and Step 11 (/improve reminder); RELOCATE Step 10 (improvement-verify) to /friday-checkup; MERGE the mission (11.5) + blindspot (12a) + resolved-count nudges into one advisory line; fold Step 6 (ask about decisions) into Step 5; move the ~40-line value-audit rubric (Step 6.4) into the new reference doc that the audit subagent reads.
(3) EDIT workspace-root /.claude/commands/wrap-session.md — same changes (paired non-symlink copy; already drifted at 424 vs 488 lines; uses different step numbers — 4.4/4.5/4.6).
(4) NEW reference doc holding the session value-audit rubric (TYPE/VALUE/SCORE/GATE/OPPORTUNITY/DECISION/LESSON/RULE).
(5) EDIT session-start.md — add a telemetry-gap nudge that fires only if the PRIOR session left no usage-log entry (mitigates telemetry becoming opt-in; the usage-log baseline feeds token-audit).
(6) EDIT friday-checkup.md — absorb the relocated improvement-verify step.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/foreign-session-guard.sh — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md — exists (workspace-root non-symlink copy)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-start.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-checkup.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/check-archive.sh — exists
- new reference doc for the session value-audit rubric (path TBD) — not yet present

## Verdict

RECONSIDER

**Summary:** The guard-externalization and dead-step cuts are sound and pipeline-review-blessed, but the change as described bundles a high-coupling byte-identical extraction, a session-close behavior flip, and an unrecorded telemetry-rule revision into one unit — and omits two must-change consumers (ai-resources CLAUDE.md, docs/session-marker.md) — giving two irreducible/silent-failure Highs; unbundle and complete the scope before landing.

## Consumer Inventory

Search terms: `foreign-session-guard.sh` (new script basename → 0 existing refs), `wrap-session.md` (basename), the contract markers the guard parses (`^## YYYY-MM-DD` today-header, `^**Mandate:**`, `logs/.session-marker`, `logs/.prime-mtime`), the relocated rubric heading (`### Session Value Audit`), and the telemetry contract (`usage-log`, "/usage-analysis at the end of every substantive session").

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/.claude/commands/wrap-session.md (canonical) | co-edits / invokes | yes |
| /.claude/commands/wrap-session.md (workspace-root, non-symlink) | co-edits / invokes | yes |
| ai-resources/.claude/commands/friday-checkup.md | co-edits (absorbs relocated Step 10) + parses `### Session Value Audit` roll-up | yes |
| ai-resources/.claude/commands/session-start.md | co-edits (adds telemetry-gap nudge) + writer of the header/`**Mandate:**`/`.prime-mtime` the guard parses + symmetric Step 0.5 counterpart | yes |
| ai-resources/logs/scripts/foreign-session-guard.sh (NEW) | change target — no consumers yet; its JSON contract will be consumed by the 2 wrap copies | n/a |
| new reference doc (rubric, path TBD, NEW) | imports — read by the wrap Step 6.4 audit subagent brief | n/a |
| ~18 project symlinks → canonical wrap-session.md (harness, ~16 projects, archive, kb-vault) | imports (symlink) | no (auto-follow canonical) |
| ai-resources/.claude/hooks/check-foreign-staging.sh | parses the same `^## YYYY-MM-DD — Session ${MARKER}` header + marker contract | no (byte-identical preserves it) |
| ai-resources/.claude/hooks/detect-concurrent-session.sh | parses per-id `.session-marker` (liveness) | no |
| ai-resources/.claude/hooks/backup-session-plan.sh | parses `.session-marker` | no |
| ai-resources/.claude/commands/prime.md | writer of headers / `.session-marker` / `.prime-mtime` the guard parses | no (contract preserved) |
| ai-resources/.claude/commands/concurrent-session-check.md | parses `- Files in scope:` mandate bullet | no |
| ai-resources/CLAUDE.md | documents "run /usage-analysis at the end of every substantive session" + "/wrap-session prompts for this automatically" | yes (NOT in change set — see Blast Radius / Dim 6) |
| ai-resources/docs/session-marker.md | documents the two-end contract registry incl. Step 3.5 + marker lifecycle | yes (NOT in change set — registry moves when the guard externalizes) |
| 3 divergent 33-line wrap-session variants (positioning-research, ai-resources/workflows/research-workflow, output/deploy-test-scratch) | documents (independent lightweight copies; do NOT call the guard) | no (pre-existing debt, not this change) |

Total: 14 distinct consumer rows plus the 2 new targets. Must-change = 4 named in the change set (both wrap copies, friday-checkup, session-start) + 2 unlisted-but-required (ai-resources CLAUDE.md, docs/session-marker.md). The new script has no consumers yet — the inventory covers the two-end string contract it must preserve. The ~18 symlinks mean a canonical regression reaches every project's session-close.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- `/wrap-session` is operator-invoked, not auto-loaded — externalizing the guard and cutting steps reduces per-invocation cost, it does not add ongoing token cost. Evidence: prior risk-check confirms "command is fired by operator (`/wrap-session`), not by SessionStart/PreToolUse hooks … only `check-stop-reminders.sh` and `detect-innovation.sh` mention wrap-session and they only emit reminder text" (audits/risk-checks/2026-05-28-wrap-session-step-3-5-concurrent-remnant-mixed-classifier.md:46).
- Net direction is leaner: ~250 inline Bash lines move to a script (pay-as-run), plus Steps 9/10/11 and the two-question preflight are removed from the body.
- Only additive per-session cost is change (5): the telemetry-gap nudge in `session-start.md` (a conditional usage-log grep + one advisory line) — runs once per session but is small. No always-loaded CLAUDE.md token growth is described (a CLAUDE.md telemetry-rule edit, if added per Dim 6, would reword not grow it).

### Dimension 2: Permissions Surface
**Risk:** Low

- No settings.json / permission changes described. The new script runs via `bash logs/scripts/foreign-session-guard.sh` — the same Bash-invocation pattern already used for `logs/scripts/check-archive.sh` (wrap-session.md:31: `CLAUDE_PROJECT_DIR="$(pwd)" bash logs/scripts/check-archive.sh`). No new tool family, no glob widening, no `deny` narrowing, no scope escalation.

### Dimension 3: Blast Radius
**Risk:** High

- Directly edits 2 real files that must stay in lockstep (canonical + workspace-root wrap copies) and creates 2 new files, plus edits session-start.md and friday-checkup.md = 6 files. The two wrap copies are a non-symlink PAIRED CONTRACT that has already drifted (424 vs 488 lines — confirmed by `find`); every change doubles the hand-sync surface.
- The canonical copy is consumed by ~18 symlinks across ~16 projects, the harness, an archive, and the kb-vault (enumerated via `find … -name wrap-session.md`). A regression in the guard or the flipped default reaches every project's session-close — the change's own risk context states this.
- Must-change consumers from the inventory: 4 named (both wrap copies, friday-checkup, session-start). Two additional must-change consumers are NOT in the change set and are a blast-radius finding: (a) `ai-resources/CLAUDE.md` states wrap "prompts for [telemetry] automatically" and "Run /usage-analysis at the end of every substantive session" — flipping telemetry to opt-in contradicts an always-loaded rule left un-edited; (b) `docs/session-marker.md` is the registered two-end-contract home for the Step 3.5 guard and marker lifecycle (referenced across dozens of audits) and must move/point to the externalized script.
- Contract cross-references (`parses` rows): the guard's string literals are a two-end contract shared with `check-foreign-staging.sh`, `detect-concurrent-session.sh`, session-start Step 0.5, and `prime.md`. The byte-identical requirement keeps these compatible (must-change = no) — but concentrates the regression risk in one ~250-line transcription.
- Grounding: consumer count is high (14 rows) with 4 named must-change + 2 unlisted must-change; shared session-close infrastructure is touched in a way that affects every workflow that ends with `/wrap-session`. High.

### Dimension 4: Reversibility
**Risk:** Medium

- Most of the change is git-revertible within the tree: the 4 edited files revert cleanly and the 2 new files are removed by revert. But the change spans two repos (ai-resources + workspace root) so a rollback must touch both.
- Append-only-log residue that a revert cannot undo: once the flipped default ships to the ~18 symlinks, any session that wraps core-only and skips telemetry/coaching leaves a permanent hole in `logs/usage-log.md` and `logs/coaching-data.md` for that session — a later revert cannot backfill the missing entries (the session is gone). This is the append-only-mutation-a-revert-cannot-cleanly-undo case.
- Operator behavior propagates: `/wrap-session` now does less by default; the old always-prompt muscle memory must be relearned (bare vs `full` vs `+telemetry`). Revert restores the command but not the intervening skipped-telemetry gap. One-plus cleanup step beyond git → Medium.

### Dimension 5: Hidden Coupling
**Risk:** High

- Multiple implicit dependencies, several with silent-failure modes:
  - **Two-end string contract.** The externalized guard's correctness rests on literals (`^## ${TODAY}` header, `^**Mandate:**`, `logs/.session-marker`, `logs/.prime-mtime`) shared with `check-foreign-staging.sh`, `detect-concurrent-session.sh`, session-start Step 0.5, and prime.md. A subtle transcription divergence during the ~250-line extraction desyncs the contract silently — reintroducing the exact false-negative the guard exists to prevent (foreign session notes clobbered under this session's commit; the failure mode logged 2026-05-27, wrap-session.md:51). The PAIRED CONTRACT comment currently lives inline in both wrap copies; externalization must carry it into the script.
  - **Symmetric counterpart desync.** session-start Step 0.5 shares the `.prime-mtime` marker with the wrap-side guard (session-start.md:51–54; wrap-session.md:213–223). The change must not let the externalized wrap detector drift from the session-start guard's read of the same marker.
  - **Telemetry compensation chain.** Flipping telemetry to opt-in creates a new dependency: change (5)'s session-start nudge must fire reliably to protect the token-audit baseline (CLAUDE.md: usage-log "is the baseline that future token audits measure against"). If the nudge's usage-log key/grep drifts, the baseline erodes silently.
  - **Rubric label split.** friday-checkup's Weekly Session Value Review greps the `### Session Value Audit` heading and `TYPE:/SCORE:/DECISION:/RULE:` labels in session-notes (friday-checkup.md:334–341). Moving the ~40-line rubric to a reference doc (change 4) is safe only if the audit subagent keeps emitting byte-identical labels — a new source(doc)/consumer(friday-checkup) drift surface with no symlink between them. Because the reference doc is `not yet present`, this contract is evaluated from stated intent only.
- Multiple implicit dependencies + silent failure mode → High.

### Dimension 6: Principle Alignment
**Risk:** Medium

Principles-base read at `projects/strategic-os/ai-strategy/principles-base.md` (frozen-ID index; canonical text in repo-documentation vault).

- **DR-7 / OP-9 / AP-7 (speculative abstraction) — SATISFIED, counts *for* the change.** Externalizing the guard is licensed by a second confirmed consumer: both wrap copies call the new script today (two real consumers, not a Phase-2 hook). The prior pipeline review grounds it in DR-3 (scripts live in their canonical home) and names it the highest-ROI fix (audits/pipeline-reviews/wrap-session-2026-05-29.md:9,38–40). Placement of the script in `logs/scripts/` alongside `check-archive.sh` is DR-3-correct.
- **DR-3 (placement) — reference doc path TBD.** The rubric doc home (`docs/` vs `reference/`) is unresolved in the change; both are plausible but placement cannot be fully judged until fixed. Evaluated from intent only (file `not yet present`).
- **OP-11 / OP-3 (loud revision, never silent drift) — the load-bearing tension.** Flipping telemetry (and coaching/outcome/feedback) to opt-in contradicts an always-loaded rule: `ai-resources/CLAUDE.md` says "Run /usage-analysis at the end of every substantive session" and "/wrap-session prompts for this automatically." The change set does not list CLAUDE.md as edited, so as-described the command silently diverges from a documented always-loaded rule — the OP-11 silent-drift shape. This is legitimate *only* as a loud, recorded revision (edit the CLAUDE.md rule in lockstep). Mitigable, so Medium not High — but it must not land un-recorded.
- **OP-12 (closure before detection) — mild tension.** Change (5) adds a new detection (telemetry-gap nudge) whose finding is for a *prior* session that has already ended — the specific gap is unrecoverable, so the nudge is compensating behavior, not closure of what it detects. Not a clear violation (it prompts corrective behavior going forward), but it is new detection without an instance-closing channel; note it.
- **OP-2 / AP-4 — aligns.** Making routine core auto-run and gating only the optional passes behind flags removes a rubber-stamp-ish two-question preflight (AP-4) while keeping judgment passes opt-in — consistent with OP-2. The pipeline review's leanness fixes (strip Step 11, drop Step 9) are explicitly blessed (2026-05-29 review "Leanness fixes").
- **OP-5 — no enforcement upgrade.** The change relaxes an auto-prompt toward opt-in; it does not silently upgrade advisory to enforcement.

### Dimension 6 note
The single clear misalignment (OP-11 telemetry drift) is convertible to a loud recorded revision, so Dimension 6 is Medium, not High. It becomes an OP-11 violation only if the flip lands without updating the CLAUDE.md rule.

## Recommended redesign

- **Unbundle into three sequenced commits — the change is misclassified as one unit.** (A) Externalize the guard byte-identically (pipeline-review-blessed, DR-7-clean) as its own commit, independently QC'd via a mechanical diff of the extracted script against the current inline block so a transcription regression is isolated and bisectable before the ~18 symlinks serve it; carry the PAIRED CONTRACT comment into the script and update `docs/session-marker.md`. (B) Land the dead-step cuts (Step 9, Step 11) + Step 10 relocation to friday-checkup + nudge-merge as a separate low-risk commit. (C) Treat the core-only default flip as a distinct governance decision, not a leanness tweak.
- **Complete the scope before landing — add the two unlisted must-change consumers.** Edit `ai-resources/CLAUDE.md` in lockstep so the telemetry rule reflects opt-in (make it a loud OP-11 revision, not silent drift), and update `docs/session-marker.md` to point at the externalized guard. Fix the reference-doc home (DR-3) before writing it, and keep the `### Session Value Audit` / `TYPE/SCORE/DECISION/RULE` labels byte-identical so friday-checkup's roll-up grep still matches.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: `find`/`grep` counts of wrap-session copies, symlinks, and marker/header/rubric/telemetry consumers; verbatim line references in the two wrap-session copies, session-start.md, friday-checkup.md, check-archive.sh, ai-resources CLAUDE.md, and the 2026-05-29 pipeline review; principle IDs cited from `principles-base.md`. The reference doc and the guard script are `not yet present`; their contributions were evaluated from the described intent and flagged as such. No training-data fallback was used.
