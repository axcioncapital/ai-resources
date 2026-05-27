# Risk Check — 2026-05-27

## Change

Add a pre-commit foreign-session detection guard to wrap-session.md (canonical + workspace-root Phase 3 copy). Logic: before staging logs/session-notes.md, count today-headers (`## YYYY-MM-DD`) in working tree vs HEAD. If the working tree contains more today-headers than this session has authored (1 if /prime+/session-start ran, 0 otherwise), stop with a chat prompt and either let the operator manually resolve (switch to other terminal, wrap there first, then re-run) or commit the union with explicit `union` reply. Symmetric counterpart to Plan 2 mtime guard in /session-start Step 0.5 (shipped 2026-05-26) — closes the post-/session-start window the same way Plan 2 closed the pre-/session-start window.

Insertion shape:
- ai-resources/.claude/commands/wrap-session.md: new Step 3.5 inserted between Step 3 (log archive) and Step 4 (append session note), AND/OR added as preface check to the explicit-staging block at lines 82–88.
- workspace-root /.claude/commands/wrap-session.md: insertion before Step 2 (append session note); guards the bare "Step 5. Commit the session note." finalizer at the bottom.

Detection mechanic (mechanical Bash):
```bash
TODAY=$(date '+%Y-%m-%d')
WT_COUNT=$(grep -c "^## ${TODAY}" logs/session-notes.md 2>/dev/null || echo 0)
HEAD_COUNT=$(git show HEAD:logs/session-notes.md 2>/dev/null | grep -c "^## ${TODAY}" || echo 0)
ADDED=$((WT_COUNT - HEAD_COUNT))
```
If `ADDED >= 2`: definite foreign — stop and prompt. If `ADDED == 1`: ambiguous — Claude inspects the added header and judges (own-mandate match → proceed; uncertain → stop). If `ADDED == 0`: proceed silently.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md — exists (NOT a symlink — Phase 3 workspace-root copy, simpler shape: ~70 lines, no log archive, no telemetry)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A targeted, evidence-grounded fix to a real, observed bug (concurrent-wrap clobber, commit `14d2a04`); insertion is mechanical Bash + clear stop semantics, but it (a) introduces a new dual-file contract that must stay in sync between canonical and Phase 3 copy, (b) silently relies on the operator following the `## YYYY-MM-DD` header convention everywhere in `session-notes.md`, and (c) inserts an interactive stop into a previously-uninterruptible commit path — each manageable with explicit mitigations.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The guard is invoked inside `/wrap-session`, which is operator-invoked once at session end — not auto-loaded, not per-tool-call, not per-turn. Evidence: `ai-resources/.claude/commands/wrap-session.md` line 1 has `model: sonnet` frontmatter and is referenced from CLAUDE.md only as a manual ritual ("Run `/wrap-session` if work is complete" — workspace CLAUDE.md § Commit behavior).
- Adds approximately 30–60 lines of inline Bash + prompt logic to two command files. Neither file is in the always-loaded set; both load only when the command is invoked. Per-session cost is bounded to one read of the command body, which already happens.
- No new `@import`, no new hook, no skill-with-broad-trigger added. The mechanical Bash block runs four shell commands at wrap time (`date`, two `grep -c`, one `git show`) — trivial token-equivalent footprint.

### Dimension 2: Permissions Surface
**Risk:** Low

- The new mechanic uses `grep`, `git show`, and `date` — all already exercised elsewhere in the wrap path (`grep` in Steps 8, 10, 11 of canonical wrap-session.md lines 66–77; `git show` is read-only against HEAD).
- No new `permissions.allow` / `permissions.ask` / `permissions.deny` change implied by the change description.
- No new tool family. No widening of Bash globs. No cross-repo write. No external API.

### Dimension 3: Blast Radius
**Risk:** Medium

- Direct file count: 2 files touched (canonical `ai-resources/.claude/commands/wrap-session.md` and workspace-root `.claude/commands/wrap-session.md` — confirmed via Read; the workspace copy is NOT a symlink to the canonical).
- Callers / references to `wrap-session`: `grep -rln "/wrap-session"` across `ai-resources/.claude`, `ai-resources/skills`, `ai-resources/docs`, and the two CLAUDE.md files returned 32 hits (Bash grep count). Spot-checks: workspace CLAUDE.md § Commit behavior ("remind Patrik to run `/wrap-session` if work is complete"), `skills/handoff/SKILL.md`, `docs/session-rituals.md`, `docs/compaction-protocol.md`, `docs/onboarding-daniel*.md`, `docs/weekly-session-guide.md`. All callers invoke the command by name — none parse its output or depend on its step-numbering. New Step 3.5 does not break any of these.
- Contract change: introduces a new pre-commit interactive prompt. Callers that invoke `/wrap-session` end-to-end will now occasionally see a stop-prompt where they previously saw silent commit — observable behavior change, but the change is by design (the whole point is to interrupt the clobber path).
- Phase 3 workspace-root copy must stay in sync with canonical wrap-session.md going forward. Two divergent shapes (canonical ~89 lines with archive + telemetry; workspace copy ~70 lines without) means the insertion point and surrounding step numbers differ between the two files — the guard logic is symmetric but the surrounding control flow is not. This is the same dual-maintenance burden that already exists for the file pair; the change extends but does not create it.
- Shared infra: `logs/session-notes.md` is read by `coach-reminder.sh` (line 10) and written by the session-end hook (referenced in wrap-session.md line 11 — the `/tmp/claude-wrap-session-done` lockfile race). Guard is read-only against the file and adds no new write path; existing race protections remain valid.

### Dimension 4: Reversibility
**Risk:** Low

- Two-file edit. `git revert` of the landing commit restores both wrap-session.md files cleanly to their pre-change state. No sibling files generated, no log mutation, no state pushed beyond the local repo (the guard itself is read-only against `git show HEAD:` and the working tree).
- No automation/hook/symlink added — nothing to fire between the change landing and a hypothetical revert.
- Operator muscle memory: the new stop-prompt at wrap time is the only behavioral change the operator must mentally hold across a revert. Low cost — the prompt is opt-in to engage (it only fires when ADDED ≥ 1), and absent the prompt the rest of the wrap is unchanged.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Implicit dependency on header-format convention.** The guard counts lines matching `^## YYYY-MM-DD` in `logs/session-notes.md`. The convention is documented in canonical wrap-session.md line 38 ("`## {date} — {one-line title}`") and used by `check-archive.sh` (per wrap-session.md line 38: "`check-archive.sh` interprets top entries as oldest"). If any other writer (e.g., the `coach-reminder.sh` hook line 10, future tooling, or an operator manual edit) ever emits a today-header in a different shape — leading whitespace, `# ` instead of `## `, or `## YYYY-MM-DD HH:MM` — the count diverges from reality silently. Single implicit-convention dependency; documented at the change site is feasible.
- **Couples to `/prime` and `/session-start` semantics.** The "expected count" (1 if `/prime`+`/session-start` ran, 0 otherwise) is asserted by the change description but is not self-evident at the wrap-session.md call site. The mapping between which upstream commands wrote today-headers and what count the guard should expect is an undocumented invariant. If `/prime` is refactored to not append a today-header, or `/session-start` ever appends a second header, the guard's expected baseline shifts silently. The `ADDED == 1` ambiguous-judgment branch ("Claude inspects the added header and judges — own-mandate match → proceed") softens this but converts a mechanical check into a fuzzy LLM-call at exactly the moment robust mechanical detection is most needed.
- **Functional overlap with Plan 2 mtime guard.** `/session-start` Step 0.5 already detects foreign writes via `logs/.prime-mtime` marker file and an mtime delta (session-start.md lines 26–71). The proposed guard uses a different mechanism (today-header count vs git HEAD) at a different point (wrap, not start). The two are intended to be symmetric, but they will both run in a typical full session — `/prime` → `/session-start` (Plan 2 mtime check) → ... → `/wrap-session` (this new check). If both fire on the same concurrent-wrap incident the operator sees two prompts with different framings; if one fires and the other does not, the asymmetry will be confusing to debug. New contract that callers (operators) must learn to interpret.
- **The "union" commit branch is an unprecedented operation.** Wrap-session.md has no existing "commit a union of two sessions' work" code path. Calling it out as a single-keyword reply (`union`) introduces a new operator vocabulary the rest of the wrap flow does not honor — e.g., the Files Created / Files Modified list in the session note (Step 4 lines 41–42) is derived from "conversation context," not from the working tree, so a union commit will ship file contents whose paths are not enumerated in either session's wrap note. Undocumented downstream effect on the audit trail.
- **The `ADDED == 1` "Claude inspects and judges" branch is a hidden LLM call inside a mechanical guard.** The branch is described as "Claude inspects the added header and judges" with criteria "own-mandate match → proceed; uncertain → stop." This is the same kind of LLM-in-the-loop check that the `[Step 0.5]` loud-fallback lines (session-start.md line 70: "silent degradation becomes loud") are designed to prevent. The 1-header ambiguous case is exactly the boundary case the change is meant to catch — and it is the case where the guard degrades to LLM judgment.

## Mitigations

- **Dimension 3 mitigation (dual-file sync):** In the same landing PR, add a one-line cross-reference at the top of each wrap-session.md noting the other file ("Companion: `/.claude/commands/wrap-session.md` — Phase 3 workspace-root copy" and reverse), plus a note in the change-description that any future edit to one MUST be mirrored to the other. Add a follow-up improvement-log entry to track replacing the dual-file pattern with a single canonical + symlink before the next major wrap-session.md edit.
- **Dimension 5 mitigation (header-format coupling):** Document the `^## YYYY-MM-DD` header-format dependency inline at the guard site (one-line comment in the Bash block: "# Depends on session-notes.md today-header format `## YYYY-MM-DD` — keep in sync with wrap-session.md Step 4 and check-archive.sh"). This converts the implicit convention into a documented contract.
- **Dimension 5 mitigation (Plan 2 overlap):** In the Step 3.5 prose, add one sentence naming Plan 2 explicitly ("Symmetric counterpart to `/session-start` Step 0.5 mtime guard — that guard covers the `/prime` → `/session-start` window; this guard covers the post-`/session-start` → wrap window. Both may fire in the same incident from different sides."). Operator-facing prompt framing aligns the two so the asymmetry is interpretable.
- **Dimension 5 mitigation (ambiguous `ADDED == 1` branch):** Replace the open-ended "Claude inspects and judges" rule with a mechanical disambiguator: when `ADDED == 1`, compute the line range of the added today-header in the working tree (via `diff <(git show HEAD:logs/session-notes.md) logs/session-notes.md`) and check whether the next 1–3 lines contain a `**Mandate:**` line authored by this session (operator can identify via mandate text match against `$ARGUMENTS` if present, or fall through to stop-prompt by default). Default-to-stop on any genuine uncertainty rather than default-to-proceed; this preserves the spirit of session-start.md's "loud over silent" posture (line 70).
- **Dimension 5 mitigation (union-commit operator vocabulary):** Either (a) drop the `union` reply branch entirely in the initial landing — operator manually resolves by switching terminals — and add it only after operator usage clarifies whether it is needed; or (b) explicitly document that a union commit will leave the wrap-note's Files Modified list under-counting the actual shipped diff, and that the operator must reconcile manually. Option (a) reduces the new contract surface and is the safer ship.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file reads of both wrap-session.md files (canonical 89 lines, workspace-root 70 lines), file read of session-start.md Step 0.5 (lines 26–71), grep count of 32 references to `/wrap-session` across `ai-resources/.claude`, `ai-resources/skills`, `ai-resources/docs`, and CLAUDE.md files, audit-discipline.md § Risk-check change classes confirming canonical-command-edit triggers `/risk-check`, improvement-log.md entry 2026-05-27 lines 138–146 documenting the source incident (commit `14d2a04`), and inspection of the `coach-reminder.sh` and `check-archive.sh` shared-infra interactions. No training-data fallback was used.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

# Pre-Change Advisory — Foreign-Session Detection Guard in `wrap-session.md`

## Routing position

Per `repo-architecture.md` and the brief: canonical home is `ai-resources/.claude/commands/wrap-session.md`; the workspace-root `.claude/commands/wrap-session.md` is **intentionally not a symlink** because it operates on workspace-level `logs/session-notes.md` (different target file from the ai-resources copy). Both files must be edited as a coordinated pair. This dual-file shape is a recognized exception class — analogous to the explicit-duplication exception in `DR-5` (Recognized exception: deliberate cross-level mirroring with self-identification) — but applied to a command body rather than a CLAUDE.md rule. The routing is correct: the change cannot be collapsed into a single canonical file without rearchitecting which session-notes file each tier writes to (out of scope for this change).

## Concur with PROCEED-WITH-CAUTION verdict

**Yes — concur.** The verdict shape is correct (`risk-topology.md § 3` classifies "Canonical command/agent edit" as `/risk-check`-gated, and `wrap-session.md` writes to `logs/session-notes.md` which is one of the "Key one-way data flows" in `system-doc.md § 4.5`). The change is symmetric, evidence-grounded, and mechanical in shape — `GO` would understate the dual-file coupling and the interactive-stop insertion; `RECONSIDER` would overstate the cost of a small Bash guard against a documented bug (commit 14d2a04).

The Dimension 3 (Medium) and Dimension 5 (Medium) markings are accurately placed:
- **Dim 3 (blast radius):** Every `/wrap-session` invocation across both ai-resources and workspace tiers hits this guard. That is the full session lifecycle for both tiers — high reach, but reach scoped to one well-defined session-boundary moment (`risk-topology.md § 1` lists `friday-checkup.md` as load-bearing for the same structural reason; `wrap-session.md` is its session-boundary counterpart).
- **Dim 5 (hidden coupling):** The dual-file contract (canonical + Phase 3) and the `## YYYY-MM-DD` header convention dependency are exactly the "two-end contract" pattern flagged in `risk-topology.md § 5` ("Change modifies a string literal matched by another component"). The header pattern is a contract between Patrik's manual writing convention and the guard's grep — invisible coupling until someone writes a non-conforming header.

## Recommended mitigations — concur, with refinements

The five mitigations are the right set for the risks named. Tightening on each:

**1. Dual-file cross-ref.** Right path. Both files need an inline comment naming the sibling. Stronger form: identical block (header line + path) at the top of the guard in each file. Grounded in `DR-5` recognized-exception pattern (silent duplication is the anti-pattern; explicit self-identifying duplication is acceptable).

**2. Inline header-format dependency comment.** Right path. The `## YYYY-MM-DD` header convention is a tacit contract — `OP-11` (surfacing tacit principles is a recurring obligation) and `OP-3` (loud failure over silent continuation) both push for making it explicit at the consumer site. Add: the comment should state what happens if the convention is violated (guard returns false-negative; foreign session's entry is silently clobbered — i.e., the bug the guard is meant to prevent recurs silently). Naming the failure mode is the load-bearing part of the mitigation, not just naming the dependency.

**3. Plan 2 symmetry naming.** Right path. The Plan 2 mtime guard in `/session-start` Step 0.5 and this guard form a paired contract (start-side detection + end-side detection). Name them as a pair in both files' comments. This makes the symmetry discoverable when one half changes — a `/session-start` edit that drops the mtime guard now has a visible counterpart to consider. Grounded in `risk-topology.md § 5` two-end contract pattern.

**4. Mechanical disambiguator for `ADDED==1`.** Right path. The risk here is that `ADDED==1` matches both "operator added a fresh entry" (legitimate, proceed) and "foreign session added an entry today that this session is about to clobber" (illegitimate, stop). The disambiguator presumably distinguishes these by header authorship or by mtime delta. The mechanical form is preferred over interactive prompting on every `ADDED==1` (which would violate `AP-4` rubber-stamp approvals — fires the stop prompt on the legitimate case).

**5. Drop union-reply branch.** Right path if the union-reply branch was the "merge both sessions' entries" auto-resolution path. Auto-merging session notes is a silent-resolution pattern (`AP-1` silent conflict resolution) — the guard should stop and surface the conflict, not attempt reconciliation. The stop semantics are correct; the union-reply branch was an `AP-1` regression dressed as a helpful fallback. Dropping it tightens the guard to its intended shape.

## Risks the dimension review missed

**Risk A — Interactive stop in commit path violates `OP-2` (gate judgment, not execution) only if mis-scoped.** Inserting an interactive operator prompt into a previously-uninterruptible commit path is correctly flagged as Medium on Dim 5. The mitigation that matters: the stop must fire **only** on the genuine concurrent-clobber condition, not on every wrap. If the disambiguator (mitigation 4) is loose, the guard becomes a rubber-stamp gate (`AP-4`) — the operator approves through it on every wrap, the gate fades, and when the real concurrent-session case arrives, the operator approves through it again by reflex. This is the gate-fade failure mode the workspace already tracks (per the MEMORY entry on gate-calibration). **Recommendation:** the disambiguator's specificity is the load-bearing part — vague match conditions kill the guard's value faster than the dual-file sync risk.

**Risk B — Phase 3 copy is workspace-root, not ai-resources canonical — graduate-resource pressure.** The dual-file shape is structurally similar to the pattern `/graduate-resource` is designed to resolve: a resource lives in two tiers and the operator must keep them in sync. Per `DR-1` and `DR-7`, the workspace-root tier is legitimate for workspace-specific orchestration (`/wrap-session` qualifies — it's a session-lifecycle command). But the **content of the guard** is identical across both copies; only the target path differs. The right shape long-term might be a shared guard helper script that both copies invoke with a path argument, rather than duplicated guard logic. **Not for this change — that's `DR-7` speculative-generalization territory (one consumer, not two with different needs). Flag for a Friday observation if a third place ever needs the same guard.**

**Risk C — Guard runs pre-commit; what about pre-write?** The brief says "pre-commit foreign-session detection guard." If "pre-commit" means before `git add`/`git commit` but after the wrap has already written its own entry to `logs/session-notes.md`, then the guard catches the clobber *after* this session has overwritten it. The Plan 2 mtime guard fires at `/session-start` Step 0.5 — before any write. The symmetric counterpart should ideally fire **before this session's wrap writes its entry**, not before commit. Verify the insertion point: is the guard before the write to `logs/session-notes.md` or after? If after, the bug class shifts from "prevent clobber" to "detect-after-the-fact and let operator decide whether to revert." Both are valid, but they're different bug classes. **Recommendation:** name the insertion point explicitly in the commit message and confirm it matches the bug's actual collision moment (commit 14d2a04 would tell which). If after-write, rename the guard from "detection guard" to "clobber-detection-and-revert-prompt" — the operator-facing semantics are different.

**Risk D — Concurrent-session staging discipline already covers part of this (`DR-10`).** `DR-10` prohibits directory wildcards for `git add` during concurrent sessions, and prohibits `/cleanup-worktree` and `/permission-sweep` from running while a concurrent session is active. The new guard is an additional check on top of `DR-10`, not a replacement. **Verify:** the guard's failure mode does not silently weaken `DR-10`'s discipline — e.g., the guard passing should not be read as "concurrent-session check passed, wildcard staging is now safe." The two checks are independent; the guard does not license relaxation of `DR-10`. If the wrap-session body currently enumerates explicit paths per `DR-10`, that discipline stays — guard is additive.

## Position

The change should land with all five mitigations applied. The dimension review's main miss is **Risk A (disambiguator specificity) and Risk C (insertion-point clarity)**. Both are correctable inside the mitigation set you already have — tighten mitigation 4 with a concrete match-condition specification (not just "mechanical disambiguator"), and document the insertion-point ordering in the commit message and the inline comments.

The verdict stays PROCEED-WITH-CAUTION; the mitigation list grows from 5 to 5+2 (4a: specify the disambiguator's match condition explicitly; commit message addendum: state insertion-point relative to the wrap's own write).

---

**Citations applied:**
- Dual-file contract recognized-exception pattern — `principles.md § DR-5` Recognized exception
- Two-end contract / string-literal coupling — `risk-topology.md § 5` Signals that elevate
- Canonical command edit is `/risk-check`-gated — `risk-topology.md § 3` change-class table
- Wrap-session writes to a key one-way data flow — `system-doc.md § 4.5`
- Silent conflict resolution anti-pattern (union-reply branch) — `principles.md § AP-1`
- Rubber-stamp approval risk (loose disambiguator) — `principles.md § AP-4`
- Gate judgment, not execution — `principles.md § OP-2`
- Surface tacit conventions explicitly — `principles.md § OP-11`, `§ OP-3`
- Speculative generalization (shared guard helper deferred) — `principles.md § DR-7`
- Concurrent-session staging discipline (additive, not replacement) — `principles.md § DR-10`
