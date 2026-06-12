# Risk Check — 2026-06-12

## Change

Add a live-foreign-session nudge to /prime pointing at /concurrent-session-check, gated on the per-id-marker liveness oracle (new LIVE_FOREIGN_HERE computation in Step 1a + a conditional Step 6 brief line), plus a one-clause /concurrent-session-check pointer added to detect-concurrent-session.sh's ORACLE-path sharp nudge. Advisory, read-only additions; no new shared-mutable state; degrades safe when CLAUDE_CODE_SESSION_ID is unset.

The change is ALREADY APPLIED in the working tree — review the concrete diff, not a hypothetical.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/detect-concurrent-session.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/concurrent-session-check.md — exists (the command being pointed at)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The advisory/read-only additions are low-risk on five dimensions, but the hook edit landed only on the canonical copy — the two project-local hook copies that `docs/session-marker.md` declares "byte-identical" now drift, a Medium blast-radius gap that needs a re-sync before this is durable.

## Consumer Inventory

The change touches three contract surfaces: (a) the `/concurrent-session-check` command token, (b) the `LIVE_FOREIGN_HERE` oracle computation, (c) the canonical `detect-concurrent-session.sh` hook (which has byte-identical project copies). Search terms: `concurrent-session-check`, `LIVE_FOREIGN_HERE`, `detect-concurrent-session`, `prime.md` / `/prime`.

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/.claude/commands/concurrent-session-check.md | invokes (the command the new nudge points at; must accept zero-or-one arg — it does, Steps 1/26-29) | no |
| ai-resources/.claude/commands/prime.md | co-edits (both edit sites are in this file) | yes (already applied) |
| ai-resources/.claude/hooks/detect-concurrent-session.sh (canonical) | co-edits (the one-clause pointer) | yes (already applied) |
| projects/positioning-research/.claude/hooks/detect-concurrent-session.sh | co-edits (declared byte-identical copy — `docs/session-marker.md:164`) | yes (NOT yet applied — drift) |
| projects/research-pe-regime-shift-advisory-gap/.claude/hooks/detect-concurrent-session.sh | co-edits (declared byte-identical copy — `docs/session-marker.md:164`) | yes (NOT yet applied — drift) |
| docs/session-marker.md (L159, L164, L205, L209) | documents (registry of marker readers + "byte-identical project copies" claim) | no (no contract field changed; the byte-identical claim is now stale only if copies stay un-synced) |
| docs/parallel-sessions-playbook.md (L85, L110, L238) | documents (authority for parallel-session discipline; names the hook + the pre-flight check) | no |
| docs/backlog-reconciliation.md (L96-101) | documents (`/prime` Step 1a is the reference impl of the merged git scan — untouched by this edit) | no |
| ai-resources/.claude/hooks/check-foreign-staging.sh (L201) | documents (comment references the same oracle path) | no |
| docs/daniel-concurrent-session-hooks-setup.md | documents (operator setup doc; describes hook behaviour generically) | no |

Total: 10 distinct consumers, 4 must-change (3 already applied: prime.md ×2 sites, canonical hook ×1; **1 outstanding — the two project-local hook copies**). The `/concurrent-session-check` command itself is a `not-yet-fully-wired` *target*: before this change its only invokers were docs/audits; `/prime` and the hook are now its first two live invocation surfaces.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The `/prime` additions are pay-as-oriented, not pay-per-turn — `/prime` runs once at session start, not per-tool-call. The new `LIVE_FOREIGN_HERE` scan is one bounded glob over `logs/.session-marker-*` (prime.md:116) plus one conditional brief line (prime.md:208). No always-loaded file (workspace/repo CLAUDE.md) is touched; grep over both CLAUDE.md files returns no edit.
- The hook edit adds ~250 chars to one `emit` string on the SHARP path only (detect-concurrent-session.sh:153) — it fires conditionally (`LIVE_FOREIGN_HERE >= 1`), not on every SessionStart, and emits to stderr not into context.
- The new `/prime` Step 1a prose is ~18 lines of command-body text, loaded only when `/prime` is invoked (it is `disable-model-invocation` adjacent, on-demand) — not an always-loaded `@import`.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json`/`settings.local.json` permission entry is added, removed, or widened. The new `/prime` scan uses `cat`/glob/test — already-authorized read-only shell idioms; the existing settings.local.json only lists `Bash(bash -n ...)` and `Bash(cp ...)` for this hook (settings.local.json:6-7), neither affected.
- No new tool family, no Write path, no external API, no scope escalation. The nudge points the operator at an existing command; it does not invoke it.

### Dimension 3: Blast Radius
**Risk:** Medium

- Inventory: 10 consumers, 4 must-change. Three must-change sites are already applied (prime.md two sites, canonical hook). **The driving finding: 2 must-change sites are NOT applied** — `projects/positioning-research/.claude/hooks/detect-concurrent-session.sh` and `projects/research-pe-regime-shift-advisory-gap/.claude/hooks/detect-concurrent-session.sh` both still emit the OLD sharp-nudge string (verified by `diff`: only L153 differs, the new `/concurrent-session-check` clause is absent in both copies).
- This is a real contract-of-record drift, not cosmetic: `docs/session-marker.md:164` registers these as "`+ byte-identical project copies`" and the repo's own settings.local.json carries a `cp` permission (L7) precisely to keep them in sync. The copies are no longer byte-identical, so an operator hitting the sharp nudge in those two projects gets the worktree-isolation advice but NOT the new `/concurrent-session-check` pre-flight pointer — the exact coverage this change exists to add is missing in 2 of 3 deployment locations.
- No parse-contract is broken: `/concurrent-session-check` already accepts zero-or-one argument (concurrent-session-check.md Step 1, L35-36), so the nudge's `/concurrent-session-check <task>` and bare-form references are both valid against the current command. The `LIVE_FOREIGN_HERE` name and oracle logic exactly mirror the hook's existing computation (detect-concurrent-session.sh:144-150 ↔ prime.md:113-122) — no new schema.
- `docs/session-marker.md` registry rows (L159/L205) describe behaviour, not a field the edit changed, so they do not strictly must-change — but the "byte-identical" line (L164) becomes inaccurate until the copies are re-synced.

### Dimension 4: Reversibility
**Risk:** Low

- All three applied edits are single-file, content-only changes inside the working tree (no commit yet per the diff). `git checkout -- .claude/commands/prime.md .claude/hooks/detect-concurrent-session.sh` fully restores prior state — verified the diff is confined to those two files.
- No data/log mutation, no `settings.json` change, no push, no external write, no automation that fires between landing and revert (the hook edit is a wording change to an existing emit, not a new hook registration). Clean revert.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The new `/prime` oracle silently relies on one established convention: that `/prime` writes its own per-id marker only at Step 8 (after Step 1a), so its own marker is absent at scan time. This is stated inline (prime.md:109, "writes this session's own per-id marker only at Step 8") and the defensive `SELF_MARKER` exclusion (prime.md:118) guards it even if that ordering changes — coupling is named at the change site and double-protected.
- The oracle mirrors the hook's logic by *duplication*, not shared code — if the hook's oracle definition changes, the `/prime` copy must change too. This is a pre-existing pattern (the hook already duplicates the oracle into check-foreign-staging.sh per its L201 comment) and prime.md:112 explicitly labels its block "same signal as detect-concurrent-session.sh," so the coupling is documented, not silent.
- No functional overlap creating double-handling: the hook fires the live alert at SessionStart; `/prime`'s line is the planning-time pair pointing at a *checker*, not a second detector. prime.md:125 states this distinction explicitly.

### Dimension 6: Principle Alignment
**Risk:** Low

- principles-base.md was readable (`projects/strategic-os/ai-strategy/principles-base.md`). Relevant IDs checked: OP-5, OP-9/AP-7/DR-7, OP-10, OP-12, DR-1/DR-3.
- **OP-5 (advisory vs enforcement) — aligned.** The change stays strictly advisory: prime.md:125 ("never blocks"), the brief line is a `⚠` advisory not a gate, and concurrent-session-check.md is `disable-model-invocation: true`, read-only, never-blocks (L22-24). No advisory→enforcement upgrade.
- **OP-9/AP-7/DR-7 (speculative abstraction) — aligned, not violated.** The nudge wires `/prime` and the hook to an *existing* consumer (`/concurrent-session-check`, a shipped command). This change is what gives that command its first two live invocation surfaces — it is closing the gap between a built checker and its callers, the opposite of building ahead of a consumer. No new generalization or "Phase-2 hook."
- **OP-12 (closure before detection) — aligned.** This adds no new detection. It routes an *existing* detection signal (the per-id oracle, already firing) toward a closure channel (`/concurrent-session-check`, the pre-flight checker that resolves the "is my next task safe" question). Detection→closure wiring is exactly the direction OP-12 favours.
- **DR-1/DR-3 (placement) — aligned.** Edits land in the canonical `ai-resources/` command and hook; no tier or home confusion.
- Note: the Dimension-3 project-copy drift is a *DR-8/sync-discipline* execution gap, not a principle violation — the change does not relax or revise any principle, so no OP-11 loud-revision obligation is triggered.

## Mitigations

- **Dimension 3 (Medium → Low): re-sync the two project-local hook copies before treating this change as landed.** Run the repo's own sanctioned sync (the `cp` already permitted in settings.local.json:7) for both targets: `cp .claude/hooks/detect-concurrent-session.sh "../projects/research-pe-regime-shift-advisory-gap/.claude/hooks/detect-concurrent-session.sh"` and the equivalent for `positioning-research`. Then confirm `diff` is empty against canonical for both, restoring the "byte-identical project copies" invariant `docs/session-marker.md:164` asserts. Without this, 2 of 3 deployment locations miss the new pointer.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: the applied `git diff`, file/line references in prime.md / detect-concurrent-session.sh / concurrent-session-check.md, `diff` output proving the two project-copy drifts, grep counts across `ai-resources` and the workspace root for the consumer inventory, and principle IDs read from `principles-base.md`. No training-data fallback was used.
