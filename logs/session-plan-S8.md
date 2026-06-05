# Session Plan — S8 (2026-06-04)

## Intent
Run 3 picked menu items in order: (1) fix the `/wrap-session` Step 3.5 clobber false-negative guard bug across both wrap-session copies; (2) build defect-capture wiring session 2 — a `/log-defect` capture command + a recurrence-scan step in `/friday-checkup`; (3) decide the `.claude/` directory git-hygiene / tracking model and record the decision.

## Model
opus (`claude-opus-4-8[1m]`) — match. Item 4 is a decision (deciding → opus); items 1–2 are command design with a load-bearing parse contract (closer to deciding than mechanical). No `/model` switch.

## Source Material
- **Item 1:** `logs/improvement-log.md` L295–301 (clobber false-negative entry, recommended structural fix); L242–250 (id-14 date-rollover edit just applied — same Step 3.5 block); L214–224 (Option 2′ per-id keying history); `.claude/commands/wrap-session.md` Step 3.5 MARKER-resolution block (L80–156); workspace-root `/.claude/commands/wrap-session.md` (paired sibling); `docs/session-marker.md` (canonical contract).
- **Item 2:** `docs/defect-to-fix-loop.md` (loop, firing model, deferred-wiring §session-2 L42–47); `logs/defect-log.md` (schema, 7 classes, prepend-most-recent-at-top, recurrence rule); `.claude/commands/friday-checkup.md` (gate-calibration suppression-check precedent — where the scan lands).
- **Item 4:** `logs/session-notes.md` S6/S7 carryover ("14-repo CLAUDE.md git-hygiene + `.claude/` tracking-model decision; highest-value carryover"); `auto-sync-shared.sh` (symlink-emission + drift-detection — binding constraint); `.gitignore` state across project repos; `docs/` any tracking-model reference.

## Findings / Items to Address

### Item 1 — wrap-session Step 3.5 clobber false-negative
- **Root cause (confirmed via improvement-log L295–301):** a session that runs `/prime` menu → a command → `/wrap-session` WITHOUT `/prime` task-selection or `/session-start` authors no `## … — Session ${MARKER}` header and writes no `logs/.session-marker-${CLAUDE_CODE_SESSION_ID}` per-id file. At wrap, the per-id path (L91–97) yields no MARKER, the loud fallback (L99–106) reads the *clobbered shared* `.session-marker` (pointing at a concurrent foreign session's marker), and the marker-aware path counts the foreign header as own (`OWN_HEADERS_SUBTRACT=1`) → `FOREIGN=0` false-negative. Option 2′ per-id keying only protects sessions that HAVE a per-id marker.
- **Fix (recommended in L300):** add a `NO_OWN_MARKER` guard — when `CLAUDE_CODE_SESSION_ID` is SET but the per-id file does NOT exist, this session authored zero tracked headers; force `OWN_HEADERS_SUBTRACT=0` / `OWN_MANDATES_SUBTRACT=0` and SKIP both the shared-marker loud fallback AND the `PRIME_RAN`/`.prime-mtime` path (both shared + clobber-vulnerable). Restrict the loud fallback to the genuine old-CLI case (`CLAUDE_CODE_SESSION_ID` unset). Net: a no-own-marker session claims no ownership → all added today-content flagged foreign → guard STOPs as designed.
- **Folds with id-14:** same Step 3.5 MARKER-resolution region in both copies. Edit both copies in lockstep (PAIRED CONTRACT).
- **Regression guard:** must not re-break (a) genuine concurrent-foreign detection, (b) legacy old-CLI PRIME_RAN path, (c) normal per-id-present marker-aware path, (d) id-14 date-rollover grace window.

### Item 2 — defect-capture wiring (session 2)
- **Two deferred items (`defect-to-fix-loop.md` L42–47):** (a) `/log-defect` capture command (new); (b) a recurrence-scan step.
- **`/log-defect`:** prepends one entry to `defect-log.md` (schema: most-recent-at-TOP — prepend, NOT append). Takes a defect description; classifies into exactly one of the 7 classes; scans the log for prior same-class entries to set Occurrence (1st / Nth) and the prior occurrence's date+location; sets Action (`captured` on 1st; on 2nd+ the entry must route — surface that the recurrence rule fires). Em-dash (U+2014) in the header. Log-append/dispatch command → `model: sonnet` frontmatter.
- **Scan step → `/friday-checkup`, not `/wrap-session`:** the firing model says recurrence scan + routing is fortnightly on the Friday cadence, gated (judgment work). Exact precedent: the gate-calibration suppression check that fires monthly+ inside `/friday-checkup`. The scan flags any class with a 2nd+ occurrence still tagged `captured`.
- **Out of scope:** routing the first real recurring defect class into a rule/eval/example (the loop's acceptance test) — depends on a real recurring defect existing; defer if none present. No backfill.

### Item 4 — `.claude/` git-hygiene / tracking-model decision
- **The question:** are per-project `.claude/` command/agent dirs committed as-is in each project repo, OR gitignored + symlinked from the canonical `ai-resources/.claude/`?
- **Binding constraint:** `auto-sync-shared.sh`'s symlink-emission + drift-detection behavior must be treated as a fixed input — the decision cannot contradict how that script already syncs shared resources.
- **Deliverable:** a recorded decision in `logs/decisions.md` (+ implementation only if the chosen direction is low-risk and in-scope; a structural implementation re-gates with its own `/risk-check`).
- **Note:** flagged repeatedly as "highest-value carryover." Decision-first; investigate current state (gitignore treatment, symlink-vs-copy, auto-sync behavior) before deciding.

## Execution Sequence

### Stage 0 — Plan-time `/risk-check` (gate, Autonomy rule #9)
Run `/risk-check` on the concrete structural edits landing this session (items 1 + 2: command edits + new command + `/friday-checkup` cadence edit; ~16-symlink blast radius via canonical wrap-session). On GO → proceed. On RECONSIDER/NO-GO → pause, retain plan+mandate.

### Stage 1 — Item 1: wrap-session Step 3.5 fix
1. Add `NO_OWN_MARKER` detection (var set + per-id file absent) after the per-id block.
2. Guard the loud fallback with `NO_OWN_MARKER=0`.
3. Restructure the `else` branch: `NO_OWN_MARKER=1` → claim-zero (skip PRIME_RAN); else → legacy PRIME_RAN path.
4. Mirror the identical edit to the workspace-root paired sibling.
5. One-line note in `docs/session-marker.md` documenting the no-own-marker → own-subtract=0 rule.
6. Validate the bash by execution across scenarios (no-own-marker clobber incident, normal per-id, old-CLI fallback, id-14 rollover) — bash-by-execution discipline.
7. `/qc-pass` on the edit; flip improvement-log L295–301 to applied+Verified.

### Stage 2 — Item 2: defect-capture wiring
1. Write `.claude/commands/log-defect.md` (`model: sonnet`): classify → scan-for-prior → prepend entry per schema.
2. Add a gated recurrence-scan step to `.claude/commands/friday-checkup.md` (mirror gate-calibration suppression-check shape).
3. Update `docs/defect-to-fix-loop.md` deferred-wiring §: mark the two items shipped; note scan lands in `/friday-checkup`.
4. `/qc-pass` on the new command + the scan step.

### Stage 3 — Item 4: `.claude/` git-hygiene decision
1. Inventory current state: `auto-sync-shared.sh` behavior, `.gitignore` treatment of `.claude/` across project repos, symlink-vs-copy reality.
2. Frame the decision (commit-as-is vs gitignore+symlink) against the `auto-sync-shared.sh` constraint; weigh per `/risk-check` dimensions.
3. Record the decision in `logs/decisions.md`. Implementation only if low-risk + in-scope; otherwise record the decision + a follow-up implementation item (re-gated).

## Scope Alternatives
- **Drop item 4 (run `auto 1,2`):** the two coupled wrap-session/defect builds only; item 4 (the large standing architectural decision) as its own focused session. Surfaced at the approval gate; operator chose all three.
- **Item 2 scan into `/wrap-session` instead of `/friday-checkup`:** rejected — firing model says recurrence scan is fortnightly Friday-cadence, gated; per-session `/wrap-session` would over-fire the judgment step.
- **Item 4 implement-now vs decide-now:** decide-now is the safe floor; a structural implementation re-gates.

## Autonomy Posture
**Gated.** All three touch structural change classes (command edits with ~16-symlink blast radius, a new command, a cadence-pipeline edit, a git-hygiene/tracking-model decision). Stage 0 `/risk-check` is the plan-time gate. Item 4's implementation, if structural, re-gates separately. Commit directly per workspace rule; push batched to wrap.

## Risk
- **Item 1:** highest blast radius — Step 3.5 is consumed by every `/wrap-session` + ~16 project symlinks via the canonical copy + the non-symlink workspace-root copy. Mitigation: bash-by-execution validation across all 4 scenarios before commit; lockstep both-copy edit; `/qc-pass`.
- **Item 2:** new command is additive (low); the `/friday-checkup` scan step edits a live cadence pipeline (medium) — keep it gated + mirror the proven gate-calibration shape.
- **Item 4:** decision-only this session bounds risk; any structural implementation re-gates.
- **Cross-item coupling:** items 1 and 2 do NOT both edit `/wrap-session` (item 2's scan lands in `/friday-checkup`), so no edit-conflict between stages.
