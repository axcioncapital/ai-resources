# Session Plan — 2026-05-29

## Intent
Implement TOCTOU mitigation Phases 2+3 as a single atomic commit — wire `.session-marker` consumer logic into all writers (`/session-start`, `/prime`, `/session-plan`) AND all readers (`/contract-check`, `/drift-check`, `/open-items`, `fix-repo-issues-scanner`, `/decide`) of `session-plan.md`, with a canonical session-marker contract doc, eliminating the symlink bridge entirely (Option A per system-owner advisory 2026-05-29).

**Plan revision note:** Original plan staged Wave 1 (Phase 2) + Wave 2 (narrow Phase 3 — wrap-session + handoff). Plan-time `/risk-check` on the Phase 2 spec returned PROCEED-WITH-CAUTION (Hidden Coupling: High) due to symlink-as-bridge between writer-side Phase 2 and unreached reader-side Phase 3. System-owner Function-B advisory recommended Option A (atomic Phase 2+3 in one commit, no symlink). Operator chose Option A. Real reader inventory differs from dispatch decision's named scope (`/wrap-session` + `/handoff` do NOT actually read `session-plan.md`); the real readers are `/contract-check`, `/drift-check`, `/open-items`, `fix-repo-issues-scanner`, `/decide`. Plan scope widened from the narrow Phase 3 to all actual readers; Phase 4 (legacy fallback cleanup) becomes irrelevant since no fallback paths are introduced in atomic Option A.

## Model
opus — match (active: `claude-opus-4-7[1m]`). Multi-file structural refactor across shared-state coordination protocol; heavy design judgment under cross-cutting constraints.

## Source Material
- `ai-resources/.claude/commands/prime.md` (Phase 1 reference implementation — Steps 8a.3.a / 8b.3.a / 8c.3 marker write)
- `ai-resources/.claude/commands/session-start.md` (Phase 2 consumer — Step 3 header location)
- `ai-resources/.claude/commands/session-plan.md` (Phase 2 consumer — Step 0 collision logic + Step 7 OUTPUT_TARGET)
- `ai-resources/.claude/commands/wrap-session.md` (Phase 3 downstream — marker-scoped plan + session-notes header reads)
- `ai-resources/.claude/commands/handoff.md` (Phase 3 downstream — marker-scoped reads at handoff time)
- `ai-resources/logs/improvement-log.md` lines 73-138 (canonical proposal with phased migration plan and target-files-by-phase enumeration)
- `ai-resources/audits/risk-checks/2026-05-28-prime-session-marker-phase-1-write-only.md` (Phase 1 risk-check precedent — verdict GO, all 5 dimensions Low)
- `ai-resources/docs/audit-discipline.md` (structural change class definitions — shared-state automation)

## Findings / Items to Address

Source anchor: improvement-log entry "2026-05-28 — Concurrent sessions cause TOCTOU races on shared log files" (lines 73-138), specifically § Migration plan (lines 117-122) and § Target files (lines 126-131). Session mandate narrows to Phases 2-3-narrow + Phase 4; broader Phase 3 (`/drift-check`, `/contract-check`, `/qc-pass`, friday-checkup) is explicitly out of scope per the friday-act dispatch decision (item 1) which named only `/session-start` + `/session-plan` + `/wrap-session` + `/handoff` + legacy-fallback cleanup.

1. **Phase 2a — `/session-start` Step 3 locate header by marker.** Current: appends mandate under bare `## YYYY-MM-DD` header. Target: read `.session-marker`, locate `## YYYY-MM-DD — Session {marker}` header. Fallback path if marker absent (interop with pre-Phase-2 sessions).
2. **Phase 2b — `/prime` writes marker-bearing today's header.** Current: writes `## YYYY-MM-DD` (or appends under existing). Target: writes `## YYYY-MM-DD — Session {marker}` after generating marker. Required so Phase 2a has a marker-scoped header to find. Adjacent to Phase 1 write site; minimal additional surface.
3. **Phase 2c — `/session-plan` Step 0 simplification.** Current: 6-hour-window mtime check → MATCH 3-option prompt or MISMATCH wrap-state check / pass2 route. Target: drop pass2 routing entirely; collision impossible because each session writes to its own `session-plan-{marker}.md`. Keep same-session 3-option prompt for legitimate re-invocations.
4. **Phase 2d — `/session-plan` Step 7 OUTPUT_TARGET change.** Current: `logs/session-plan.md` (or pass2). Target: `logs/session-plan-{marker}.md`. Create symlink `logs/session-plan.md` → current session's plan for downstream-reader backward compat during Phase 3 rollout.
5. **Phase 3a — `/wrap-session` marker-aware reads.** Locate this session's plan via marker (not bare `session-plan.md`); locate this session's header in `session-notes.md` via marker. Coaching-data classification at Step 7a must still match the parse contract; verify the marker-bearing header `## YYYY-MM-DD — Session {marker}` still satisfies any `^## ` regex consumers.
6. **Phase 3b — `/handoff` marker-aware reads.** Same pattern as `/wrap-session` — read marker, locate marker-scoped plan and session-notes header. Verify scratchpad write paths (already per-session-timestamped) don't need marker awareness.
7. **Phase 4 — legacy fallback removal.** After Phase 2-3 verified, remove the "if marker absent" fallback branches added in Phase 2a / 2c / 2d / 3a / 3b. Hard-fail with a clear error if marker is absent — `/prime` is now a hard prerequisite. Keep one short note in each command body pointing to `/prime` as the canonical marker source.
8. **Documentation update.** Add a short § "Session marker protocol" to `ai-resources/docs/audit-discipline.md` (or a new `docs/session-marker.md` if more natural) — single canonical reference that the four consumer commands and the `/prime` writer all point to, so future edits maintain the contract.

## Execution Sequence

Single atomic wave — Phase 2 + Phase 3 land in one commit. Per the improvement-log § Migration plan: "Run /risk-check before EACH phase, not as a one-shot" — under Option A there is exactly one phase to gate (atomic), so one plan-time + one end-time /risk-check covers it. Per SO advisory's Mitigation 5: rollback recipe must appear in commit message.

### Atomic Wave — Phase 2+3 implementation (10 files)

1. **Pre-spec inspection** (completed). Inventoried real downstream `session-plan.md` readers via grep. Result: `/contract-check`, `/drift-check`, `/open-items`, `fix-repo-issues-scanner` agent, `/decide`. Plus writer-side files: `/session-start`, `/session-plan`, `/prime`. Plus canonical doc stub. Total: 10 files (or 9 if doc extension is in-place to `docs/audit-discipline.md` rather than a new file).
2. **Draft atomic spec** → `audits/working/toctou-phase-2-and-3-atomic-spec.md` (supersedes `toctou-phase-2-spec.md`; the Phase 2 spec stays on disk as audit trail of the design pivot). Spec covers all 10 files with per-item current state → target state → exact edit shape → verification check. No symlink, no legacy-fallback paths (Option A bypasses both).
3. **Stop point.** Operator reviews atomic spec.
4. **Run `/risk-check` plan-time gate** on atomic spec. Expect dimension scoring to differ from Phase 2-only gate: Hidden Coupling should drop from High to Low (no symlink); Blast Radius may rise from Medium to Medium-High (10 files vs 3); Reversibility stays Medium (atomic git revert is clean; file-to-symlink state change disappears). Iterate if RECONSIDER, abort if NO-GO.
5. Apply spec to all 10 files. Per SO Mitigation 3: include canonical session-marker contract doc in the same commit. Per SO Mitigation 6: track `logs/session-plan-S*.md` variants (default; do NOT gitignore). Per SO Recommendation 2 (sibling sweep): silence or repurpose `/prime` Step 1a sibling-entry sweep in this commit per `principles.md § AP-10`.
6. **Mitigation 4 — read-tests.** Before commit, run one read-test per downstream consumer category: spawn a subagent to read each marker-aware consumer's body and confirm it correctly references `logs/session-plan-${MARKER}.md` (no orphan bare-path reads). Cheap mechanical verification.
7. **Run `/qc-pass`** on the cumulative implementation (independent context).
8. Resolve QC findings inline if REVISE; iterate if DISAGREE.
9. **Run `/risk-check` end-time gate** on the cumulative commit. Expect GO (atomic landing closes the Phase 2 coupling concern). Commit only after.
10. **Mark improvement-log entry** "2026-05-28 — Concurrent sessions cause TOCTOU races on shared log files" as Phases 2+3 APPLIED + Verified. Phase 4 (legacy fallback cleanup) becomes N/A since Option A introduces no fallback paths. Note the design pivot from staged-with-symlink to atomic-no-symlink in the entry update.

**Verification:**
- New session: `/prime` → marker file written → marker-bearing header `## 2026-05-30 — Session S1` in session-notes → `/session-plan` → `logs/session-plan-S1.md` written → consumers (`/contract-check`, `/drift-check`, `/open-items`, `/decide`, `fix-repo-issues-scanner`) all read `session-plan-S1.md` directly via marker resolution.
- Two concurrent sessions: each writes to its own marker-scoped plan; no collision, no symlink race, no shared file to clobber.
- Read-test subagent confirms no bare `logs/session-plan.md` reads remain in any consumer body.

**Commit message includes Mitigation 5 rollback recipe:**
> Rollback: `git revert <this-hash>; rm -f logs/.session-marker logs/session-plan-S*.md` then re-run `/prime` to reseed pre-Phase-2 state.

## Scope Alternatives

Under Option A, scope is fixed at the atomic-wave shape — no narrower variant is meaningfully different (Min would defer too few consumers to drop coupling; Max would add Phase 4 cleanup but Phase 4 is N/A since no fallbacks are introduced).

**Single scope (Option A — atomic Phase 2+3):** All 10 files (3 writers + 5 readers + /prime auto-mode internal write + 1 doc stub) in one commit. Two `/risk-check` invocations (plan-time + end-time). Estimated session length: 2-3 hours of focused work.

**Discarded alternatives** (preserved for audit trail):
- ~~Original Wave 1 (Phase 2 only) + Wave 2 (narrow Phase 3) + Wave 3 (Phase 4 cleanup)~~ — superseded by Option A. The original Phase 2-only sub-scope received PROCEED-WITH-CAUTION on Hidden Coupling: High due to symlink-as-bridge. The original narrow Phase 3 scope (`/wrap-session` + `/handoff`) was empirically wrong (those files don't read `session-plan.md`).

## Autonomy Posture
Gated.

**Stop points:**
- After atomic spec drafted (operator reviews before plan-time /risk-check)
- After implementation, before /qc-pass (read-test verification window)
- After /qc-pass, before end-time /risk-check (if /qc-pass returns DISAGREE)
- On any /risk-check NO-GO verdict — abort, escalate
- On /qc-pass DISAGREE that cannot be resolved inline — escalate to operator

## Risk
Two `/risk-check` invocations total: plan-time gate on atomic spec, end-time gate on cumulative commit. Down from the original plan's 4-6 invocations because Option A collapses three phases into one atomic wave.

Structural change classes touched (per `ai-resources/docs/audit-discipline.md` § Risk-check change classes):
- Shared-state automation across 8 command/agent files (4-6 became 8 in Option A's wider scope)
- Cross-resource interaction pattern redesign (writer ↔ reader contract change)
- New always-loaded behavior (every `/prime` produces a marker file every consumer reads)
- Atomic landing closes the asymmetric-phase-coupling material miss the SO advisory flagged

The dimension scoring is expected to differ vs the Phase 2-only gate: Hidden Coupling drops from High to Low (no symlink), Blast Radius rises from Medium to Medium-High (10 files vs 3), Reversibility stays Medium with a cleaner revert path (no file-to-symlink state change). Net verdict expected: GO with NOTE on Blast Radius.
