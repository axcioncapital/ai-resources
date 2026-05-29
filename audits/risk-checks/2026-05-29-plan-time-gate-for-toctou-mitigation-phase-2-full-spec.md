# Risk Check — 2026-05-29

## Change

Plan-time gate for TOCTOU mitigation Phase 2. Full spec: audits/working/toctou-phase-2-spec.md. Summary: marker-aware consumer logic added to /session-start Step 3 (locate today's header by marker), /prime Steps 8a.3.a / 8b.3.a / 8c.3 (write marker-bearing header `## YYYY-MM-DD — Session {marker}`, reorder marker-write to occur BEFORE session-notes append), /session-plan Step 0 (drop intent-comparison + wrap-state check + auto-pass2 routing — each session writes to private logs/session-plan-{marker}.md), /session-plan Step 7 (OUTPUT_TARGET = marker-scoped path, create logs/session-plan.md symlink → marker-scoped file for downstream Phase 3 backward compat). Each item carries a legacy-fallback path for marker-absent (pre-Phase-2) sessions; Phase 4 removes fallbacks. Single atomic commit covering 2a + 2b + 2c + 2d. Phase 1 precedent: commit ea93d62 (2026-05-28), risk-check GO. Structural classes touched: (a) shared-state automation across 3 command bodies, (b) cross-resource interaction pattern redesign, (c) symlink coupling between /session-plan and downstream Phase 3 readers.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/toctou-phase-2-spec.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-start.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-plan.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/session-plan.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/risk-checks/2026-05-28-prime-session-marker-phase-1-write-only.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Structurally sound TOCTOU mitigation with one elevated risk: the `session-plan.md` symlink introduces a last-writer-wins cross-session dependency that is intentionally accepted as a Phase 2 bridge — mitigable but not eliminable until Phase 3 lands.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Three command bodies edited; none are always-loaded (slash commands load on invocation only). `/prime` frontmatter `model: sonnet` (`prime.md`:2), `/session-start` `model: sonnet` (`session-start.md`:2), `/session-plan` `model: opus effort: high` (`session-plan.md`:2-4). No new always-loaded content.
- Net token change in `/session-plan` is a SAVING: spec § Item 2c claims "~95 lines of Step 0 collapse to ~30" (spec line 209). Verified against current state: Step 0 spans lines 11-106 today (95 lines).
- Three new `~10 line` bash blocks in `/session-start` Step 3, `/session-plan` Step 0, `/session-plan` Step 7 add the marker-read and symlink-write; `/prime` gets reordered (no net add). Conservative envelope: under 100 tokens net add across all three files, with `/session-plan` net negative.
- No new hooks, no new subagents, no new `@import`, no new skill trigger keywords.

### Dimension 2: Permissions Surface
**Risk:** Low

- New tool call: `ln -sfn` in `/session-plan` Step 7. The Bash tool family is already established for these commands (`stat`, `awk`, `cat`, `printf`, `echo > path` already used at `prime.md`:163-180 and `session-plan.md`:60). `ln` is a standard read-write operation against the same `logs/` tree already covered.
- New reads against `logs/.session-marker` — same file `/prime` Phase 1 already writes at the same path. No new path category.
- No `deny` rule removed, no scope escalation, no external API, no cross-repo write.

### Dimension 3: Blast Radius
**Risk:** Medium

- Direct file edits: 3 (session-start.md, session-plan.md, prime.md). Plus 1 logical state change: `logs/session-plan.md` flips from regular file → symlink via `git rm` + recreation.
- Downstream readers of bare `logs/session-plan.md` enumerated via `grep -rn "session-plan.md" .claude/commands/ .claude/agents/ skills/`:
  - `contract-check.md`:52 (reads file as CONTRACT_SOURCE)
  - `open-items.md`:41, :69 (reads checkboxes from file, links file)
  - `drift-check.md`:18, :28, :30, :48 (auto-detect mandate, conflict detection)
  - `fix-repo-issues-scanner.md`:40, :84, :93, :195 (scans checkboxes)
  - `prime.md`:185, :187, :223, :319, :321-322 (writes file in auto-mode 8c, references in 8a/8b prompts)
  - `new-project.md`:548 (templating reference)
  - 9 references across log-sweep, contract-check, drift-check identified by count
  
  Total: ~9 commands/agents touching the bare path. All would consume the symlink transparently during Phase 2; Phase 3 makes them marker-aware.
- One contract change: the today's-header pattern in `session-notes.md` flips from `## YYYY-MM-DD` (bare) to `## YYYY-MM-DD — Session ${MARKER}` for new sessions. Existing readers grep `^## ${TODAY}` (e.g., `prime.md`:60, `wrap-session.md`:63, :115) — the marker-bearing header still matches because the prefix is preserved. Verified: `grep -c "^## ${TODAY}"` matches both shapes.
- `wrap-session.md` Step 7a (line 212) scans for `**Mandate:**` between `## YYYY-MM-DD` headers — this regex remains compatible with marker-bearing headers because the prefix anchor `## YYYY-MM-DD` is unchanged.
- Hook impact: `backup-session-plan.sh` regex `'(^|/)logs/session-plan(-[a-zA-Z0-9]+)?\.md$'` matches `session-plan-S1.md`. Verified — `S1` is alphanumeric, suffix group `-S1` matches.
- Spec author's claim "touches 3 command files (session-start, prime, session-plan)" (spec line 358) UNDERSTATES blast radius — 9 dependent commands consume the bare path, even if transparently. Mitigated by symlink, not eliminated.

### Dimension 4: Reversibility
**Risk:** Medium

- Each of the 3 command edits is `git revert`able cleanly.
- The `git rm logs/session-plan.md` + symlink replacement creates a state-machine the revert does not cleanly undo: after revert, the symlink would need to be manually `rm`'d and the file content restored from history or rewritten. Per spec § Phase 2 commit composition step 1 (line 333), the file is `git rm`'d in the same commit that introduces the symlink-write logic. A `git revert` of that commit restores the file contents, but the on-disk state during the revert window depends on whether `/session-plan` has run after the revert.
- The marker-scoped files `logs/session-plan-S1.md`, `logs/session-plan-S2.md`, etc. are not gitignored. They will accumulate as commit artifacts going forward. The spec does not propose a gitignore entry for the `-S*.md` variants — possible future log bloat. (Not a revert blocker, but a forward-debt note.)
- Phase 1 set precedent for additive-only changes with full clean revert; Phase 2 is structurally one step beyond that — the file-to-symlink conversion is a one-way state change without a sibling rollback recipe in the spec.
- Loud-fallback paths (`[Step 3] Note:`, `[Step 0] Note:`) ensure marker-absent state degrades visibly — supports rollback observability if Phase 2 needs to be partially backed out.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Symlink last-writer-wins cross-session race** (spec § Item 2d, lines 309-311, self-acknowledged): if session A creates `logs/session-plan.md → session-plan-S1.md`, then session B's `/session-plan` overwrites the symlink to `session-plan-S2.md`, session A's downstream readers (drift-check, contract-check, wrap-session, qc-pass) see session B's plan. The spec accepts this as a Phase 2 bridge and points to Phase 3 for elimination. This is a NEW form of the same TOCTOU class that Phase 2 is supposed to ELIMINATE — it relocates the race from the file content to the symlink target.
- **Asymmetric phase coupling**: marker-aware writes land in Phase 2; marker-aware reads land in Phase 3. The two-phase split means Phase 2 ships with a known broken state for concurrent sessions on downstream readers — only the writes are protected. The Phase 1 risk-check (`2026-05-28-prime-session-marker-phase-1-write-only.md`) called out the "no consumers yet" property as a key Low-risk justifier; Phase 2 introduces consumers but only for the writer commands, not the downstream readers — coupling is concentrated entirely in the symlink.
- **Order swap in /prime preserves the `.prime-mtime`-after-append invariant.** Verified against spec § Item 2b lines 124-129: new order is (1) determine marker → (2) write `.session-marker` → (3) append header → (4) write `.prime-mtime` AFTER append. The only operation moved BEFORE the append is `.session-marker`; `.prime-mtime` stays AFTER, per the existing Phase 1 invariant at `prime.md`:161-168 ("Order matters: marker after append, never before"). Phase 1 invariant intact.
- **Symlink-vs-regular-file detection at downstream readers**: none of the 9 downstream consumers (`contract-check.md`:52, `drift-check.md`:18-48, `open-items.md`:41-69, `fix-repo-issues-scanner.md`:40-195, etc.) check `[ -L logs/session-plan.md ]` before reading. They all `cat`/`Read`/`grep` it transparently — fine for read paths, but any future write-back to that path (none currently exist outside `/session-plan` and `/prime` auto-mode Step 8c.8) would silently write THROUGH the symlink. Spec does not document this. `prime.md`:319 in auto-mode 8c.8 writes `logs/session-plan.md` directly — under Phase 2 this would write THROUGH the symlink into the marker-scoped file of whichever session last wrote the symlink. The spec does not address whether auto-mode 8c.8 should be updated; it falls into the Phase 3 scope per the session plan but is NOT in Phase 2.
- **No documented contract for the marker-bearing header shape**: spec embeds the format `## YYYY-MM-DD — Session ${MARKER}` in three commands but does not extract it to a canonical reference doc. The improvement-log entry (lines 130-131) mentions a Phase 3 docs update — the contract is undocumented during Phase 2 + early Phase 3 window. Future authors editing one consumer without the others see no shared reference; same drift-without-detection pattern flagged in B-04 of improvement-log.

## Mitigations

- **Dimension 5 (Hidden coupling — symlink cross-session race):** Before landing Phase 2, plan and confirm the Wave-2 Phase 3 commit will land in the same session as Wave 1 (Phase 2). The session plan declares "Recommended scope: Wave 1 + Wave 2" with both waves chained — keep that scope; do not ship Phase 2 alone without Phase 3 in the same operator session. The cross-session race window then closes within hours, not days, narrowing the symlink-coupling exposure window to the gap between the two commits.
- **Dimension 5 (Hidden coupling — auto-mode 8c.8 unaddressed):** Add to the Phase 2 commit OR explicit Phase 3 scope: update `prime.md`:319 (auto-mode Step 8c.8) to write to `logs/session-plan-${MARKER}.md` directly instead of `logs/session-plan.md`, mirroring `/session-plan` Step 7. Otherwise auto-mode writes silently THROUGH whichever session's symlink is current — a hidden write-coupling not covered by the spec. (If deferred: explicitly document in the Phase 2 commit message that auto-mode writes through the symlink and accept the exposure.)
- **Dimension 5 (Hidden coupling — undocumented header contract):** Add a one-line forward pointer to `docs/audit-discipline.md` or a stub `docs/session-marker.md` (per session plan item 8, "Documentation update") in the same Phase 2 commit, naming the marker-bearing header format `## YYYY-MM-DD — Session ${MARKER}` as the canonical shape. Don't defer the full doc to Phase 4; the stub closes the two-end-contract drift surface at land time.
- **Dimension 3 (Blast radius — 9 downstream consumers):** Before landing Phase 2, verify the symlink resolves correctly by running one read-test on each downstream consumer category: one `contract-check.md`-style read (`cat logs/session-plan.md`), one `drift-check.md`-style grep (`grep "^# Session Plan" logs/session-plan.md`), one `open-items.md`-style checkbox scan. This is mechanical (one shell-test pass) and confirms the symlink is transparent to all current readers before the commit ships.
- **Dimension 4 (Reversibility — file-to-symlink one-way state change):** Document the manual rollback recipe in the Phase 2 commit message: "To revert: `git revert <commit>`; then `rm logs/session-plan.md`; the next `/session-plan` invocation regenerates the regular file." Sub-second commit-message addition; closes the rollback ambiguity flagged in D4.
- **Dimension 4 (Reversibility — marker-scoped file accumulation):** Optionally add `logs/session-plan-S*.md` to `.gitignore` if those files should be per-machine-only (mirrors the existing `.session-marker` and `.prime-mtime` treatment). If they should be tracked (operator preference: session plan history), leave untouched and accept the forward log-bloat as intentional. Spec is silent on this; pick and document either way.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references (spec § Item 2b line 124-129 + line 209; `prime.md`:2, :60, :161-168, :319; `session-plan.md`:11-106 = 95 lines; `wrap-session.md`:63, :115, :212; `backup-session-plan.sh`:16; `session-start.md`:2; `contract-check.md`:52; `drift-check.md`:18-48; `open-items.md`:41-69; `fix-repo-issues-scanner.md`:40-195), grep counts (9 downstream commands referencing bare `session-plan.md` path; 0 current `[ -L ]` symlink-detection checks), verbatim quotes from spec ("if session A creates the symlink, then session B's `/session-plan` overwrites it, session A's downstream readers see session B's plan. This is an accepted Phase 2 limitation" — spec lines 309-310). Phase 1 precedent risk-check report (`2026-05-28-prime-session-marker-phase-1-write-only.md`) compared dimension-by-dimension. No training-data fallback used.

---

## Architectural Commentary

_System-owner second opinion (Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION. Invoked via direct `system-owner` agent spawn because the `/consult` Skill tool is currently disabled-model-invocation (documented workaround per session-notes 2026-05-29 cycle-2 wrap)._

### Concurrence with the dimension verdict

**Concur with PROCEED-WITH-CAUTION; reject the spec author's anticipated GO.** The dimension scoring is right. The High on Dimension 5 is real and the reasoning that drives it is the right reasoning: Item 2d (spec § "Item 2d — Step 7 OUTPUT_TARGET change + symlink", lines 286-314) does not eliminate the cross-session TOCTOU race — it relocates it onto the symlink target. The race window narrows from the body of the file to the symlink's mtime, but the class of failure is identical: last-writer-wins on shared per-session state, observed by readers that have no idea which session's plan they are looking at. The spec acknowledges this in lines 309-311 and ships it anyway. That is not a Low-risk move under `principles.md § OP-3` (loud failure over silent continuation) — a silent cross-session write-through with no detection at the reader side is the textbook silent-degradation pattern the principle prohibits.

The risk-check report's framing that this is a "NEW form of the race, not a closure of it" is sharper than the spec's own framing and is the correct frame to act on.

### Is the recommended mitigation path the right one?

**Mostly yes, with one reordering and one addition.**

- **Mitigation 1 (chain Wave 2 in same session)** — correctly identified as the single load-bearing mitigation. Operator's current Recommended scope already commits to this, which is why PROCEED-WITH-CAUTION is acceptable rather than RECONSIDER. If Wave 2 slipped, the verdict would have to escalate.
- **Mitigation 2 (`prime.md`:319 auto-mode 8c.8)** — the right answer here is **fix, not document**. Documenting an accepted hidden write-through-the-symlink is precisely the silent-degradation pattern `OP-3` rules out. The fix is one line and lives in a file the commit is already touching. Pulling it into Phase 2 closes the exposure without adding meaningful blast radius.
- **Mitigation 3 (canonical header-format stub)** — concur. Embedding `## YYYY-MM-DD — Session ${MARKER}` in three command bodies without a canonical reference creates the same two-end-contract drift surface `risk-topology.md § 1` flags for `.prime-mtime`. The marker-bearing header is now a two-end contract across at least four readers.
- **Mitigation 4 (read-tests for downstream consumers)** — concur. Cheap, mechanical, catches the only failure class that would surface inside the commit window.
- **Mitigation 5 (manual rollback recipe in commit message)** — concur. The file-to-symlink one-way state change is the asymmetry the spec underweights.
- **Mitigation 6 (gitignore decision on `logs/session-plan-S*.md`)** — concur, with a recommended default: **track them, don't gitignore**. The marker-scoped files are this session's plan history; tracking them preserves drift-check / contract-check archaeology and aligns with the same logic that keeps `session-notes.md` tracked.

**Recommended reordering:** Mitigation 2 moves from "OR document" to **required fix in the Phase 2 commit**. The "OR document" branch is the only place the mitigation list opens a silent-degradation escape hatch.

### Risks the dimension review missed

1. **Asymmetric phase coupling lock-in (material).** The risk-check report names this under Dimension 5 but understates the consequence: once Phase 2 ships, the system has shared state (the symlink) that depends on Phase 3 landing soon to close the race. If Phase 3 gets deferred mid-session, the system ships with a known structural race for an unbounded window. Phase 2 has built infrastructure that **requires** Phase 3 consumers to be safe, not just to be useful. Mitigation 1 manages the timing but does not eliminate the coupling. **Recommendation:** explicit pre-commit checkpoint — confirm Wave 2 is ready to attempt before committing Wave 1. If Wave 2 is not ready, hold Wave 1.

2. **The `/prime` Step 1a sibling-entry sweep becomes informational noise (minor).** Spec § Item 2b acknowledges the sweep "no longer marks a real hazard." Per `principles.md § AP-10` (error handling for impossible scenarios), an informational warning for a structurally-impossible-after-Phase-2 condition is the anti-pattern. **Recommendation:** silence or repurpose the sibling sweep in this commit, not leave as decoration. Spec Open Question #3's "keep informational" recommendation is wrong against `AP-10`.

### Is there a cleaner design that avoids the High hidden-coupling rating entirely?

**Yes — three alternatives:**

**Option A — Land Phase 3 in the same commit as Phase 2.** Eliminate the symlink. Update the 9 downstream readers to be marker-aware in the same atomic commit. No bridge, no relocation of the race, no asymmetric phase coupling. Cost: one larger commit (~10 command files vs 3); Blast Radius rises to Medium-High, but Hidden Coupling drops from High to Low. Tradeoff: operator's current Recommended scope splits Wave 1 (Phase 2) from Wave 2 (narrow Phase 3 — 2 of the 9 readers). Option A widens Wave 2 to cover all 9, or rescopes Wave 2 to land beside Wave 1 atomically.

**Option B — Defer Phase 2 entirely until all 9 readers are marker-aware.** Sequence as: Phase 3 (reader updates) first, then Phase 2 (writer updates). Cleanest from a coupling perspective.

**Option C — Skip the symlink; let downstream readers fail loud during the window.** Update the 9 downstream readers to detect `logs/session-plan.md` absence and emit a loud-fail note. Cleanest from `OP-3` perspective.

**Position:** **Option A is the cleaner design and is the right answer if the operator can absorb the wider commit.** It eliminates the only High rating, removes the asymmetric phase coupling material miss, and resolves Mitigation 2's question (auto-mode 8c.8 becomes a marker-aware writer alongside the other writers). Cost: one larger atomic commit instead of two chained commits. Current Wave 1+Wave 2 plan is already committed to landing both in the same session — Option A converts "chained" to "atomic" without changing total work, only the commit boundary.

If Option A is not viable, current path — PROCEED-WITH-CAUTION with all six mitigations applied, Mitigation 2 elevated from "document" to "fix", and the Wave-2-readiness checkpoint added — is structurally acceptable.

### Final position

Concur with PROCEED-WITH-CAUTION. Recommend:

1. Operator decision before commit: **Option A (atomic Phase 2+3) vs. current chained plan**. The right answer is Option A if scope absorbs; current plan if Wave 2's narrowness is load-bearing for a reason not stated in the spec.
2. If current plan stands: apply all six mitigations, with Mitigation 2 elevated to required fix (not "OR document"), and add a Wave-2-readiness checkpoint before committing Wave 1.
3. Silence or repurpose the `/prime` Step 1a sibling-entry sweep in this commit (`principles.md § AP-10`).

Files cited:
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/toctou-phase-2-spec.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/risk-checks/2026-05-29-plan-time-gate-for-toctou-mitigation-phase-2-full-spec.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/vault/principles/principles.md` (OP-3, DR-7, QS-3, AP-10)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/vault/architecture/risk-topology.md` (§ 1 two-end-contract precedent)
