# Risk Check — 2026-06-11

## Change

Build the deferred concurrent-session coverage fix P1–P4: (P1) register check-foreign-staging.sh at user level in ~/.claude/settings.json as a PreToolUse(Bash) hook by absolute canonical path so all ~17 checkouts get the commit-time staging block; (P2) register detect-concurrent-session.sh at user level as a SessionStart hook the same way; (P3) escalate check-foreign-staging.sh from warn+allow to stop-and-confirm in the no-concrete-footprint + live-foreign-session branch; (P4) port the per-id marker teardown line (rm -f logs/.session-marker-$CLAUDE_CODE_SESSION_ID) into workspace-root .claude/commands/wrap-session.md. Plan: logs/session-plan-2026-06-11-S1.md. Audit basis: audits/2026-06-10-concurrent-session-coverage-audit.md §6.

## Referenced files

- /Users/patrik.lindeberg/.claude/settings.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/check-foreign-staging.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/detect-concurrent-session.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/session-plan-2026-06-11-S1.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/2026-06-10-concurrent-session-coverage-audit.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The bundle is reversible, well-grounded, and principle-aligned (closes data-loss gaps, stays advisory), but P1 puts a per-Bash-call hook at machine-wide user scope and both P1/P2 stack on top of existing repo/project-level registrations that already fire the same hooks — so two High dimensions (Usage Cost, Hidden Coupling) require paired mitigations before landing.

## Consumer Inventory

Derived terms: `check-foreign-staging` (P1/P3 target), `detect-concurrent-session` (P2 target), the per-id marker teardown line `rm -f logs/.session-marker-${CLAUDE_CODE_SESSION_ID}` (P4 contract), and the two settings.json registration sites. Grep run across `ai-resources` and the workspace root. Rows below are the load-bearing consumers (execution/contract dependencies); pure documentation mentions in `audits/`, `logs/`, and `projects/*/output/consultations/` are noted in aggregate, not enumerated per-file.

| Consumer path | Reference type | Must change? |
|---|---|---|
| /Users/patrik.lindeberg/.claude/settings.json | invokes (P1+P2 add the two new user-level registrations here) | yes |
| ai-resources/.claude/settings.json:58 | invokes (already registers check-foreign-staging.sh as PreToolUse(Bash) by `$CLAUDE_PROJECT_DIR`) | no (but double-fire risk — see D3/D5) |
| ai-resources/.claude/settings.json:144 | invokes (already registers detect-concurrent-session.sh as SessionStart) | no (double-fire risk) |
| projects/positioning-research/.claude/settings.json:164 | invokes (already registers detect-concurrent-session.sh as SessionStart) | no (double-fire risk) |
| ai-resources/.claude/commands/wrap-session.md:461–467 | co-edits (canonical Step 13 teardown; P4 ports an executable line that must stay lockstep — file's own MIRROR NOTE at L467 names the workspace-root copy as the port target) | no (P4 edits the *other* copy; canonical is the source) |
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md | co-edits (P4 target — adds the teardown line to match canonical Step 13) | yes |
| ai-resources/.claude/hooks/detect-concurrent-session.sh:107–156 | parses (oracle path reads `logs/.session-marker-*` liveness set that P4's teardown maintains — the two-end contract) | no |
| ai-resources/docs/session-marker.md | documents (registers the two-end teardown contract P4 depends on) | no (re-verify on edit; not modified by this change) |
| ai-resources/docs/commit-discipline.md | documents (registers the check-foreign-staging two-end contract) | no |
| projects/research-pe-regime-shift-advisory-gap/.claude/hooks/detect-concurrent-session.sh | imports (a copy of the hook exists in this project but is NOT registered in its settings.json — grep found no settings hit) | no |

Aggregate (non-load-bearing): `detect-concurrent-session` named in ~30 audit/log/consultation files; `check-foreign-staging` in ~16. These are historical records, not executable consumers.

Total: 10 load-bearing consumers, 2 must-change (the user-level settings.json, the workspace-root wrap-session.md). **Blast-radius finding not anticipated by the plan:** three existing registrations (ai-resources ×2, positioning-research ×1) already fire these exact hooks at repo/project scope; a user-level registration *stacks* with them rather than replacing them — see Dimension 3 and Dimension 5.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** High

- P1 registers a PreToolUse(Bash) hook at **user level**, so it runs on **every Bash tool call in every session on the machine** — not per-session, per-tool-call. The hook itself early-exits cheaply for non-commit/non-add-wide commands (`check-foreign-staging.sh` L72–91: regex on the command string before any git/file read), so the steady-state cost is one `python3` spawn + regex per Bash call, not a full footprint read. But the calibration band for "hook that runs per tool call (PreToolUse)" is explicitly High in this dimension's heuristic, and Bash is the most frequent tool. Evidence: `~/.claude/settings.json` currently has only PostToolUse(Write/Edit) + Stop + Notification hooks (L54–100) — no PreToolUse — so P1 adds a new always-on per-Bash-call cost surface where none exists today.
- P2 registers a SessionStart hook at user level — once-per-session cost (Medium band on its own), machine-wide.
- Net: P1 alone lands this dimension at High (per-tool-call PreToolUse). Mitigable — see Mitigations.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow`/`ask`/`deny` entries are added, removed, or narrowed. The change adds `hooks` entries only. Evidence: `~/.claude/settings.json` permissions block (L8–53) is untouched by the described P1–P4.
- The machine already runs `bash`-invoked hooks from `~/.claude/settings.json` by absolute path (`detect-innovation.sh`, L61/L72) and `defaultMode` is `bypassPermissions` (L49) with `Bash(*)` allowed (L10) — so no new capability is authorized that the settings don't already permit. The new hooks are read-only (`check-foreign-staging.sh` L47 "Reads only; writes nothing"; `detect-concurrent-session.sh` L13 "read-only detector"); P4 adds a single `rm -f` of this session's own per-id marker (scoped, self-owned).

### Dimension 3: Blast Radius
**Risk:** High

- Per the Step 1.5 inventory: 10 load-bearing consumers, 2 must-change. The two must-change targets (user-level settings.json, workspace-root wrap-session.md) are each single edits, which is contained.
- **The High driver is the unanticipated stacking, surfaced by the inventory:** P1's user-level PreToolUse(Bash) registration does not replace `ai-resources/.claude/settings.json:58` — Claude Code *merges* hook layers, so in an `ai-resources` session `check-foreign-staging.sh` would fire **twice** per gated commit (once from repo settings, once from user settings). Likewise P2 stacks with `ai-resources/.claude/settings.json:144` AND `projects/positioning-research/.claude/settings.json:164` — `detect-concurrent-session.sh` would emit its `systemMessage` twice at SessionStart in those two checkouts. The plan (`session-plan-2026-06-11-S1.md` L41–43) and audit §6 P1/P2 do not mention the pre-existing repo/project registrations; they describe the gap as "0/15 project repos" and treat user-level as additive-only.
- Double-firing of `check-foreign-staging.sh` (P1) is data-safe (idempotent read-only check; a second `exit 2` is the same block) but produces duplicate block messages. Double-firing of `detect-concurrent-session.sh` (P2) produces a duplicate concurrency nudge in `ai-resources` and `positioning-research` — cosmetic but confusing, and it muddies the very signal the campaign is sharpening.
- Shared infra touched: the commit path (P1/P3, every gated `git commit`/`add -A` machine-wide) and the SessionStart event (P2, every session machine-wide). This is the widest-reach class of change. Mitigable by de-duplicating the existing registrations — see Mitigations.

### Dimension 4: Reversibility
**Risk:** Low

- P1/P2 are additive JSON entries in `~/.claude/settings.json` — removing the two hook objects restores prior state exactly. Not under git (user-level file), so revert is a manual JSON edit rather than `git revert`, but it is a single clean deletion with no propagated state.
- P3 edits `check-foreign-staging.sh` in-repo — clean `git revert`. P4 adds one line to workspace-root `wrap-session.md` — clean `git revert`.
- No state propagates beyond the local machine: hooks are read-only (P4's `rm -f` removes only this session's own marker, which `/prime` would recreate). No push, no external write, no append-only log mutation is part of the change itself. A crashed session between landing and revert leaves at most a stale per-id marker, which `/prime`'s next-day prune clears (`detect-concurrent-session.sh` L54).

### Dimension 5: Hidden Coupling
**Risk:** High

- **Duplicate-registration coupling (same root as D3, scored here as the implicit-dependency failure):** P1/P2 silently rely on the assumption — stated nowhere in the plan — that no repo/project-level registration of these hooks exists. Grep disproves it: `ai-resources/.claude/settings.json:58,144` and `positioning-research/.claude/settings.json:164` already register them. The coupling is invisible from the change site (`~/.claude/settings.json`) because the conflicting registrations live in *other* repos' settings files. This is the textbook hidden-coupling shape: an implicit dependency on the absence of a sibling mechanism, where two systems both handle the same concern (functional overlap → double-fire).
- **P4 paired-copy coupling (acknowledged, but real):** the canonical `ai-resources/.claude/commands/wrap-session.md:461–467` carries the teardown as a "PAIRED CONTRACT" / "MIRROR NOTE" — P4 must reproduce the executable line `[ -n "${CLAUDE_CODE_SESSION_ID}" ] && rm -f "logs/.session-marker-${CLAUDE_CODE_SESSION_ID}"` and the ordering invariant ("run this **last**, after Step 3.5 attribution and Step 7a"). This is the same copy-drift class the plan itself flags (L57–58). The contract IS documented at the change site (canonical L467 names the port target) — so this is the Medium-band shape — but it compounds with the hook-stacking High to keep the dimension at High overall.
- **P3 contract change is backwards-compatible and self-documented:** the escalation reuses the existing `warn_open` branch (`check-foreign-staging.sh` L157–169) and the existing `exit 2` block contract (L280–298); no caller parses a new marker. Low on its own.

### Dimension 6: Principle Alignment
**Risk:** Low

- principles-base.md read successfully (`projects/strategic-os/ai-strategy/principles-base.md`). Relevant IDs checked: OP-5, OP-12, OP-9/AP-7/DR-7, OP-10, OP-2/AP-4, OP-11, DR-1/DR-3.
- **OP-12 (closure before detection) — actively served.** This is not new detection; the detection (Fix 2 block, Fix 1 nudge) already exists and *closes* the contamination it finds (`exit 2` blocks the commit). P1/P2 extend the *closure* channel's coverage from 1 checkout to all ~17. P3 closes a known fail-open hole. The change is on the correct side of OP-12.
- **OP-5 (advisory vs enforcement) — preserved.** P3 escalates warn+allow → stop-and-confirm, but `check-foreign-staging.sh` already enforces (`exit 2`) on the confirmed-foreign path (L280–298, L19 "ADVISORY STAGING TRIPWIRE … exit 2 feeds the foreign-file list back to the AGENT"). P3 narrows the *fail-open exception*, not a fresh advisory→enforcement upgrade; it is gated to "no-footprint AND live-foreign-session" (plan L45–46), the highest-risk shape. No silent authority grant.
- **OP-9 / AP-7 / DR-7 (speculative abstraction) — not triggered.** The consumers exist *today* (~17 checkouts the operator runs concurrent sessions in; audit §4 documents recorded collisions in `nordic-pe-screening-project`, `axcion-brand-book`). This is coverage extension to confirmed consumers, not "hooks for Phase 2."
- **OP-10 (system boundary) — not triggered.** All changes are inside Claude Code (hooks, settings, a wrap command). No cross-tool reach.
- **DR-1 / DR-3 (placement) — correct.** The canonical hook stays in `ai-resources/.claude/hooks/`; the per-machine absolute path lives in per-machine `~/.claude/settings.json` (audit §6 P1 reasons this explicitly: Daniel's clone points at his own path). User-level registration of a canonical hook by absolute path is the chosen single-source pattern (avoids the 17-copy drift anti-pattern) — aligned with DR-1's "one source = one truth."
- No principle revision is being made, so OP-11/OP-3 do not apply.

## Mitigations

- **Dimension 1 (Usage Cost, High → Medium):** Keep the cheap early-exit invariant intact when editing for P3 — P3 must add its stop-and-confirm logic *after* the L72–91 gated-verb early exit, never before it, so non-commit Bash calls still return at L91 without spawning the footprint read. Confirm in the P3 QC pass that the new branch lives inside the `is_commit or is_add_wide` region (L90+), not above it. This holds the per-Bash-call cost to a regex + one early `python3` exit.
- **Dimension 3 (Blast Radius, High → Medium) and Dimension 5 (Hidden Coupling, High → Medium) — same paired action:** Before (or as part of) landing P1/P2, **remove the now-redundant repo/project-level registrations** so each hook fires exactly once. Specifically: delete the `check-foreign-staging.sh` PreToolUse entry at `ai-resources/.claude/settings.json:58` and the `detect-concurrent-session.sh` SessionStart entries at `ai-resources/.claude/settings.json:144` and `projects/positioning-research/.claude/settings.json:164`, leaving the single user-level registration as the source of truth. If the operator prefers to keep repo-level as the canonical wiring instead, then P1/P2 must scope the user-level hook to NOT re-fire where a repo registration exists — but the clean fix is single-source at user level (matches the plan's own "one source = one truth" rationale, audit §6 P1). Verify post-edit that `check-foreign-staging.sh` fires once on a test `git commit` in an `ai-resources` session and `detect-concurrent-session.sh` emits one nudge at SessionStart in both `ai-resources` and `positioning-research`.
- **Dimension 5 (P4 copy-drift, supporting):** Port the canonical teardown line *verbatim* including the ordering comment ("run this **last**"), and add a paired-contract back-reference in the workspace-root copy pointing at canonical `wrap-session.md` Step 13, so the next drift check can detect divergence. Confirm the workspace-root copy places the teardown after its Step 3.5 attribution and any mandate-read step (the canonical L467 invariant).

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references to the four target files, the two settings.json layers, the canonical wrap-session.md, and principles-base.md; grep counts for the consumer inventory; verbatim quotes from the plan and audit). The double-registration finding is grounded in live grep hits (`ai-resources/.claude/settings.json:58,144`; `positioning-research/.claude/settings.json:164`), not inferred. No training-data fallback was used on any read.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

**Verdict concurrence: yes — PROCEED-WITH-CAUTION is correct.** The fix architecture is right and principle-aligned: it extends a closure channel (`principles.md § OP-12`), covers confirmed consumers not speculative ones (`§ DR-7`), and uses the correct single-source-at-user-level placement (`§ DR-1`, `§ DR-3`). The caution is entirely about *how it lands* — the three mitigations are the right gate.

**Recommended path: concur, with one sharpening on (b):**
- (a) P3-after-early-exit — concur, and treat it as a **blocking QC condition**, not advisory. A user-level PreToolUse(Bash) hook fires on every Bash call machine-wide (`risk-topology.md § 3`); only the regex early-exit holds the cost down.
- (b) De-dup to single user-level source — concur, pick deletion over scoped-coexistence. **Sharpening:** land the deletions and the user-level additions as ONE atomic change, not "before or as part of." Split commits leave a window of either double-fire or zero-coverage — they are two ends of one contract.
- (c) P4 verbatim + run-last + back-reference — concur; this is a two-end marker contract (`risk-topology.md § 1`, `§ 5`).

**Three risks the dimension review did not surface:**
- **R1 (load-bearing) — Daniel's clone regresses.** The whole rationale for user-level-by-path is the second operator's clone, but de-dup deletes the repo-level registrations that currently cover him, and his gitignored `~/.claude/settings.json` does not receive P1/P2. After landing, Daniel runs with zero concurrent-session coverage until he manually adds the hooks with his own paths. The change must carry an explicit operator-handoff note (`principles.md § OP-3`).
- **R2 — latent re-coupling.** The unregistered orphan copy in `research-pe-regime-shift-advisory-gap` is the exact shape that re-introduces double-fire later. Note it as deliberately unregistered, or delete it.
- **R3 — P3 raises the stakes of the deferred intra-project /prime race** (`risk-topology.md § 1` marker row): a false positive now hard-stops a commit instead of warning. Confirm the gate is tight or log it as a higher-consequence known interaction.

**Position:** Land P1–P4 with all three mitigations — (a) blocking, (b) atomic — plus the R1 handoff note before "complete." R2/R3 are named interactions to log, not blockers. End-time `/risk-check` re-fire applies at commit per `principles.md § DR-8` (hook edit + shared-state automation, both gated).
