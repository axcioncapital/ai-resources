# Risk Check — 2026-06-12

## Change

Two P3 first-firing hook-defect fixes. (A) Date-anchored the mandate-header lookup in .claude/hooks/check-foreign-staging.sh: added a marker-date extraction line (`dm = re.search(r'\b\d{4}-\d{2}-\d{2}\b', marker_raw); sess_date = dm.group(0) if dm else ""`), changed the footprint-read gate from `if sess and os.path.isfile(notes)` to `if sess and sess_date and os.path.isfile(notes)`, and changed the header regex from `r'^##\s+\d{4}-\d{2}-\d{2}\s+—\s+Session\s+' + re.escape(sess) + r'\b'` (any date) to `r'^##\s+' + re.escape(sess_date) + r'\s+—\s+Session\s+' + re.escape(sess) + r'\b'` (the marker's own date + S-number). Purpose: a prior-day same-S session entry (e.g. an older "## 2026-06-10 — Session S2" with an `(inferred)` footprint) could match first and shadow today's concrete footprint, false-firing the no-concrete-footprint BLOCK branch on a validly-scoped session. (B) Added continuity-mode Step C3 to skills/handoff/SKILL.md: a per-id session-marker teardown `[ -n "${CLAUDE_CODE_SESSION_ID}" ] && rm -f "logs/.session-marker-${CLAUDE_CODE_SESSION_ID}"` as the final continuity action on the DIRECT /handoff path, explicitly SKIPPED when /wrap-session Step 0.5 inlines continuity Steps C1–C2 (wrap owns its own Step 13 teardown that must run after its marker-dependent Steps 3.5/7a — a teardown at Step 0.5 would run too early and break them). Also updated the skill's "Tools required" note (continuity mode now uses one Bash rm -f on the direct path). Registered the new teardown end in docs/session-marker.md § Per-id marker teardown (the lifecycle previously documented only the /wrap-session Step 13 remover).

Goal: stop the newly-landed P3 guard (a PreToolUse hard block) from false-blocking legitimate commits, as observed 2026-06-11 S1→S2 (S1 deferred via QC-PENDING handoff, its stale per-id marker hard-blocked S2's QC-approved commit; and the undated header regex shadowed today's footprint).

Verification already done by the implementer: Python `py_compile` OK, `bash -n` OK on the hook; a standalone regex test confirmed the OLD regex matched both a stale prior-day "Session S2" header and today's, while the NEW regex matches ONLY today's; the malformed-marker edge (empty sess_date) safely skips the footprint read and degrades to the existing no-concrete-footprint path.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/check-foreign-staging.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/handoff/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-marker.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/detect-concurrent-session.sh — exists

## Verdict

GO

**Summary:** Two narrowing bug-fixes to a recently-landed advisory guard — both reduce false-positives, touch self-contained logic, revert cleanly, and align with the system's principles; the only watch-item is the per-id-marker contract's three-copy lockstep, which these edits do not break.

## Consumer Inventory

Search terms: `check-foreign-staging.sh`, `.session-marker-${CLAUDE_CODE_SESSION_ID}` / `.session-marker-*` (the per-id marker contract), the `## {date} — Session S{N}` header regex, `handoff` Step C3, `session-marker.md` § teardown. Greps run across `ai-resources/` and the workspace root.

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/.claude/hooks/detect-concurrent-session.sh | parses (reads same today-dated per-id marker set as liveness signal) | no |
| ai-resources/.claude/commands/wrap-session.md (canonical) | co-edits (Step 13 owns the paired per-id teardown C3 mirrors; Step 0.5 inlines C1–C2 and must keep skipping C3) | no |
| /.claude/commands/wrap-session.md (workspace-root paired copy) | co-edits (paired teardown contract; lockstep on next sync) | no |
| ai-resources/.claude/commands/prime.md | imports (writes per-id marker Steps 8a/8b/8c; rewrites it on resume after /clear — the assumption C3 relies on) | no |
| ai-resources/.claude/commands/concurrent-session-check.md | parses (reads today-dated per-id markers to detect live sessions) | no |
| ai-resources/.claude/commands/session-start.md | parses (writes/reads the `## {date} — Session S{N}` header the hook regex matches) | no |
| ai-resources/.claude/commands/session-plan.md | imports (resolves per-id marker) | no |
| ai-resources/.claude/commands/clarify.md | documents (forbidden from creating markers — unaffected) | no |
| projects/positioning-research/.claude/hooks/detect-concurrent-session.sh | parses (byte-identical project copy of the per-id liveness reader) | no |
| projects/research-pe-regime-shift-advisory-gap/.claude/hooks/detect-concurrent-session.sh | parses (byte-identical project copy) | no |
| ai-resources/docs/session-marker.md | documents (two-end contract registry — edited by this change to register C3) | yes |
| ai-resources/logs/session-notes.md | parses-target (the file the hook regex reads; its `## {date} — Session S{N}` headers are the contract the regex must keep matching) | no |

Total: 12 consumers, 1 must-change (session-marker.md, already edited by this change as designed). check-foreign-staging.sh has **no project copies** (single canonical hook — `find` returned only the one path), so its regex edit has zero lockstep obligation. The per-id-marker contract has three hook copies (detect-concurrent-session.sh ×3) plus two wrap-session copies, but none requires a code change here: C3 is purely *additive* to the marker lifecycle (one more remover at one more end), and the readers already treat marker *absence* as "no live foreign session" — which is exactly what C3 makes more accurate.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The hook change adds ~2 lines of Python (`dm`/`sess_date` extraction) inside an existing PreToolUse hook that already runs per Bash call — no new hook registered, no new per-call cost (check-foreign-staging.sh:150–151). The hook still early-exits at L97–98 for any non-commit/non-add-wide Bash call before the changed code runs.
- The SKILL.md change adds Step C3 (~30 lines) to handoff/SKILL.md, a `disable-model-invocation: true` skill (SKILL.md:14) invoked only on demand (`/handoff` or `/wrap-session` Step 0.5) — pay-as-used, not always-loaded.
- No always-loaded CLAUDE.md edit, no `@import`, no new SessionStart/Stop hook. session-marker.md is a referenced doc, not always-loaded.

### Dimension 2: Permissions Surface
**Risk:** Low

- No settings.json edit in the change set. No new `allow`/`ask`/`deny` entry.
- The new C3 teardown is a single `rm -f "logs/.session-marker-${CLAUDE_CODE_SESSION_ID}"` (SKILL.md:209) — a Bash call within the session's own `logs/` dir. The repo already runs Bash freely under the bypassPermissions floor (workspace CLAUDE.md autonomy rules; per-id `rm -f` on own markers is exactly what `/wrap-session` Step 13 already does, wrap-session.md:464). No new capability family introduced.
- The hook itself is read-only and writes nothing (header L54: "Reads only; writes nothing") — unchanged by Defect A.

### Dimension 3: Blast Radius
**Risk:** Low

- Direct files touched: 3 (check-foreign-staging.sh, handoff/SKILL.md, session-marker.md). Inventory found 12 consumers, **1 must-change** (session-marker.md, already edited as part of this change).
- Defect A's regex edit touches a contract — the `## {date} — Session S{N}` session-notes header — but the change *narrows* the match (date+S-number vs S-number alone), it does not change the header format. The `parses` consumers that write/read that header (session-start.md, prime.md) are unaffected: the header they emit (`## 2026-06-12 — Session S1`, confirmed in session-notes.md:489) still matches the new regex, which only stops matching *prior-day* same-S headers. The trailing `\b` after `sess` preserves matching of `(cont.)` / `(cont. 2)` same-date variants (session-notes.md:261/288).
- Defect B (C3) is additive to the per-id-marker lifecycle. The two readers of the today-dated per-id marker set (check-foreign-staging.sh `_live_foreign_session`, detect-concurrent-session.sh oracle path L143–154, plus its two byte-identical project copies) interpret marker *absence* as "no live foreign session" — C3 simply removes the marker at one more legitimate session-end point, making that interpretation more accurate. No reader needs a code change.
- check-foreign-staging.sh has no project/byte-identical copies (single canonical), so the regex edit has no lockstep obligation.

### Dimension 4: Reversibility
**Risk:** Low

- All three edits are in-place content edits to tracked files (hook, SKILL.md, doc) — a single `git revert` fully restores prior state within the working tree. No sibling files or directories created.
- No data/log mutation: the change does not append to improvement-log.md / session-notes.md as part of its mechanism (those are separate session-wrap acts).
- The C3 teardown deletes a *gitignored* per-id marker (`logs/.session-marker-*`, session-marker.md:21/33) — not tracked state, and recreated by `/prime` on the next session, so a revert of the SKILL.md leaves no stale tracked artifact. Worst case after revert: a handoff-ended session again leaves its stale marker until `/prime`'s next-day orphan prune — i.e. revert restores exactly the pre-fix behavior, cleanly.
- Not yet committed/pushed (end-time gate) — nothing has propagated beyond the local working tree.

### Dimension 5: Hidden Coupling
**Risk:** Low

- Defect A's new code depends on the marker file format `{YYYY-MM-DD} S{N}` (session-marker.md:19/31) — an established, documented convention, not a new undocumented contract. The date-extraction regex (`\b\d{4}-\d{2}-\d{2}\b`) reads the same field the S-number extraction already read. One implicit dependency on an existing convention → Low/Medium boundary; documented, so Low.
- The malformed-marker edge (empty `sess_date`) is handled explicitly: the `if sess and sess_date` gate (check-foreign-staging.sh:187) skips the footprint read and degrades to the existing no-concrete-footprint path — the implementer's regex/edge test confirms this. No silent failure introduced.
- Defect B's C3 is the most coupling-sensitive item, and the change *documents* the coupling rather than hiding it: the SKILL.md:228–234 SKIP-when-inlined rule and the docs/session-marker.md:148 registry entry both state that C3 must NOT fire when `/wrap-session` Step 0.5 inlines C1–C2 (because wrap's Step 13 teardown must run after its marker-dependent Steps 3.5/7a, wrap-session.md:464). This is the precise ordering hazard, and it is called out at the change site and in the two-end registry — the documented-contract path, not silent coupling.
- No functional overlap: C3 (direct-/handoff end) and Step 13 (wrap end) cover *disjoint* session-end paths; the SKIP rule guarantees they never both fire on the same end.

### Dimension 6: Principle Alignment
**Risk:** Low

- principles-base.md was readable (projects/strategic-os/ai-strategy/principles-base.md). Checks applied against it directly.
- **OP-12 (closure before detection):** the change adds NO new detection — both fixes *narrow* an existing detector to stop false-positives. This actively serves OP-12 (consolidation/fixing over new building); it counts *for* the change, not against (principles-base.md:50).
- **OP-5 (advisory vs enforcement):** check-foreign-staging.sh is an advisory PreToolUse tripwire whose exit-2 feeds the model, not an operator prompt (hook header L14–18). The change does not move it toward enforcement — it reduces a false hard-block. No OP-5 tension (principles-base.md:43).
- **OP-9 / AP-7 / DR-7 (speculative abstraction):** no generalization or "hooks for later" — both consumers (the false-firing guard, the handoff-ended-session marker gap) are *confirmed, observed* incidents (2026-06-11 S1→S2), not anticipated future ones. C3 adds one teardown end to an existing lifecycle for a real consumer; not speculative (principles-base.md:27/30/85).
- **OP-10 (system boundary):** purely Claude Code-internal; no cross-tool reach. No tension (principles-base.md:48).
- **DR-1 / DR-3 (placement):** edits stay in their canonical homes — hook in `.claude/hooks/`, skill in `skills/handoff/`, contract doc in `docs/`. Correct tiers (principles-base.md:54/56).
- **OP-11 (loud revision):** the change revises no principle; it is a bug-fix to a guard, recorded in the doc registry and the change description. No silent drift.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references from the three edited files plus wrap-session.md and detect-concurrent-session.sh, grep counts for the consumer inventory, principle IDs read from principles-base.md, and verbatim quotes from CHANGE_DESCRIPTION). No training-data fallback was used.
