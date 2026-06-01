# Risk Check — 2026-06-01

## Change

Add a clobber-suspicion sanity check to the foreign-session pre-write guard in wrap-session.md Step 3.5 (both ai-resources/.claude/commands/wrap-session.md and the paired workspace-root .claude/commands/wrap-session.md). Problem being fixed: the guard's marker-aware attribution path trusts logs/.session-marker as the session-identity oracle; a concurrent /prime can clobber that file (e.g. S8 -> S9), poisoning attribution so the foreign session's today-header is subtracted as "own" and the foreign delta zeroes (silent clobber false-negative, incident 2026-05-29, improvement-log lines 213-220).

The change INSERTS (does not reorder) a detection block after marker resolution: compute today-session-markers present in the working-tree session-notes.md but NOT in HEAD (uncommitted) that differ from the marker read from .session-marker; if any exist, set CLOBBER_SUSPECTED=1. In the attribution branch, when CLOBBER_SUSPECTED: emit a loud GUARD-WARN line naming the foreign markers, and set OWN_HEADERS_SUBTRACT=0 / OWN_MANDATES_SUBTRACT=0 so the existing FOREIGN>=1 STOP path fires and forces operator manual review. No existing operations are reordered; the marker-aware and PRIME_RAN branches are unchanged except for being gated behind the new clobber branch.

Net effect: strictly safer — converts a silent false-negative into a loud STOP-with-review. False-positive risk bounded by the uncommitted-only restriction (normal sequential same-day sessions have their prior header in HEAD, so are not flagged). ~20-25 inserted lines per file. This is editing shared-state detection logic in a command body (CLAUDE.md tripwire: automation-with-shared-state-effects).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-marker.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A strictly-safer fail-safe insertion into a self-contained Bash detector — but the two paired files diverge in step numbering and surrounding step references, and the new clobber branch must be gated and ordered correctly relative to the existing attribution branches in both files, so the edit is not byte-identical across the pair and carries a real mis-application risk that one targeted mitigation neutralizes.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The change touches two slash-command bodies (`wrap-session.md`), not any always-loaded CLAUDE.md, `@import`, hook, or frequently-spawned subagent. Command bodies load only on invocation — `/wrap-session` runs once per session at wrap, pay-as-used.
- The inserted block is ~20–25 lines of Bash inside the existing Step 3.5 detector fenced block (ai-resources file lines 57–184; workspace-root file lines 27–143). It adds to the one-time read cost of the command on invocation only, not to per-turn or per-session always-loaded context.
- No new auto-load trigger, skill description, or import chain introduced — verified by the edit being confined to an existing `bash` fence inside an already-existing step.

### Dimension 2: Permissions Surface
**Risk:** Low

- No settings-layer change. The change is inline Bash inside a command the repo already invokes; it introduces no new tool family. The detector already runs `grep`, `git show HEAD:...`, `awk`, `cat` (ai-resources file lines 64–182) — the new block computes over the same `logs/session-notes.md` and `logs/.session-marker` reads plus `git show HEAD:` already in use.
- No `allow`/`ask`/`deny` entry added or narrowed; no scope escalation; no external API or cross-repo write. The change is read-only detection that sets shell variables and emits a chat warning — it does not even add a new write target.

### Dimension 3: Blast Radius
**Risk:** Medium

- **Files touched directly: 2** — both `wrap-session.md` copies (ai-resources canonical + workspace-root Phase 3). The PAIRED CONTRACT comment block mandates keeping them in sync (ai-resources lines 40–47; workspace-root lines 12–19).
- **Paired-file divergence found (material).** The two files are NOT structurally identical, so the same edit does not apply verbatim:
  - In the ai-resources file the guard is **Step 3.5**; in the workspace-root file it is **Step 1.5** (workspace-root line 10: `1.5. **Foreign-session pre-write guard...**`). The change description's "Step 3.5 (both ... files)" is imprecise — the workspace-root sibling is Step 1.5.
  - Surrounding step references differ: ai-resources branches say "Proceed ... to Step 4" (lines 188, 239, 241); workspace-root says "Proceed ... to Step 2" (lines 147, 183, 184). Any prose the new branch adds that references a downstream step number must use the file-local number.
  - The marker-aware detector body itself IS present and structurally identical in both (ai-resources lines 88–134 ≈ workspace-root lines 54–96), so the insertion point and the variable contract (`OWN_HEADERS_SUBTRACT`, `OWN_MANDATES_SUBTRACT`, `MARKER`, `PRIME_RAN`) are the same. The divergence is in step numbering and the interpret-prose step references, not in the detector algebra.
- **Downstream in-file consumers of the variables the change forces:** `OWN_MANDATES_SUBTRACT` feeds `FOREIGN_MANDATES` (line 138 / 99) AND `EXTRA_TODAY_MANDATES` in the classifier (line 166 / 125). `OWN_HEADERS_SUBTRACT` feeds `FOREIGN_HEADERS` (line 137 / 98). Forcing both to 0 under CLOBBER_SUSPECTED is compatible with all three consumers — it raises FOREIGN and EXTRA_TODAY_MANDATES, pushing FOREIGN_CLASS toward CONCURRENT (line 170 / 129), which is exactly the intended loud STOP. No consumer requires modification; the contract is backwards-compatible.
- **Cross-file consumers via grep:** the guard's detection signals (`^## YYYY-MM-DD` header, `^**Mandate:**` line) are shared conventions written by `session-start.md` Step 3 and consumed by the Step 4/Step 2 writer. The change does not alter those signal formats — it only changes the own-subtractor under one new condition — so no writer-side contract is touched. `session-marker.md` registers `wrap-session.md` Step 3.5 as a consumer of the marker contract (lines 127–129); this change keeps reading `.session-marker` the same way and adds a cross-check, so the registered consumer relationship is unchanged.
- Net: 2 files, both must change but with file-local adaptation; all in-file callers compatible; no cross-file contract break. Medium because of the must-edit-both-with-divergence factor, not because of caller breakage.

### Dimension 4: Reversibility
**Risk:** Low

- The change is two command-body edits. A `git revert` (or manual re-edit) of both files fully restores prior behavior within the working tree — no sibling files or directories are created, no data/log mutation, no settings cache.
- The detector is read-only: it reads `logs/session-notes.md`, `logs/.session-marker`, and `git show HEAD:...`, and on the new path only sets shell vars + emits a chat WARN. Reverting leaves no stale state in any log or registry. `.session-marker` is gitignored per-machine state (session-marker.md line 17) and is untouched by this change.
- No automation fires between landing and revert: the only trigger is the next manual `/wrap-session`. No hook, cron, or symlink added.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Implicit dependency on `.session-marker` format.** The new block must parse marker-bearing WT headers (`^## TODAY — Session ${MARKER}`) and compare the embedded marker against the one read from `.session-marker`. This silently depends on the header-format convention (`## YYYY-MM-DD — Session S{N}`, session-marker.md line 74) and the single-line marker format (`{YYYY-MM-DD} S{N}`, line 15). Both are established conventions documented in `session-marker.md`, and the existing detector already depends on them (ai-resources line 90) — so this is one inherited dependency, not a new undocumented one. Medium, not High, because the contract is documented at `session-marker.md` and the change adds a same-class read.
- **Ordering coupling inside the detector.** The new CLOBBER_SUSPECTED branch must sit after marker resolution (after line 86 / 52) and must gate/override the marker-aware subtractors BEFORE they flow into `FOREIGN_*` (lines 137–138 / 98–99) and the classifier (line 166 / 125). If inserted in the wrong place — e.g., after `FOREIGN` is already computed — the forced `OWN_*_SUBTRACT=0` would not propagate and the STOP would not fire. This is an implicit ordering contract the change must honor; it is not visible from the change description alone, only from the variable dataflow in the detector.
- **Residual false-positive case (bounded, fail-safe).** The uncommitted-only restriction does bound the normal sequential same-day case (prior session's header is in HEAD). But a same-terminal re-`/prime` (S8→S9 within one wrap-less stretch) that bumped `.session-marker` while the OLD-marker header sits uncommitted in WT would trip CLOBBER_SUSPECTED as a false-positive. This is acceptable: it converts to a loud STOP-with-review, never a silent clobber — fail-safe direction. Worth noting in the GUARD-WARN copy so the operator can recognize the benign re-prime case.
- **Residual false-negative case.** If a concurrent foreign session has ALREADY committed its marker-bearing header to HEAD before this wrap runs, the uncommitted-only diff will not see it (it is in HEAD, not WT-only). That case, however, is already handled by the existing `FOREIGN_HEADERS` path and is not the incident this change targets (the incident was a WT-only clobber, improvement-log line 218). The change neither closes nor reopens that path. Noted for completeness; not a regression.
- No functional overlap with the DR-8 `detect-concurrent-session.sh` SessionStart hook — that hook reads an OS `pgrep` signal at session-open and explicitly does NOT use the marker as a detection signal (session-marker.md lines 129–131). This change operates at wrap-time on file content. Different trigger, different mechanism — supplementary, not duplicative.

## Mitigations

- **Blast radius (Medium):** Apply the edit to BOTH files but adapt per file — in the ai-resources copy reference downstream "Step 4" and keep the "Step 3.5" label; in the workspace-root copy reference "Step 2" and keep the "Step 1.5" label. After editing, diff the two inserted blocks to confirm the detector algebra (variable names, the CLOBBER_SUSPECTED computation, the forced `OWN_*_SUBTRACT=0`) is identical while only step-number prose differs. Update the PAIRED CONTRACT comment in both files to register the new clobber-suspicion check as a kept-in-sync element.
- **Hidden coupling (Medium):** Insert the CLOBBER_SUSPECTED block immediately after marker resolution (after the `MARKER` assignment at ai-resources line 86 / workspace-root line 52) and BEFORE `FOREIGN_HEADERS`/`FOREIGN_MANDATES` are computed, so the forced `OWN_*_SUBTRACT=0` propagates into both the FOREIGN deltas and the EXTRA_TODAY_MANDATES classifier. Verify by a dry-run: stage a WT session-notes.md containing a today-header under a marker different from `.session-marker` with that header absent from HEAD, run the detector, and confirm it emits the GUARD-WARN and reaches a `FOREIGN >= 1` CONCURRENT STOP rather than `FOREIGN=0`. Add one clause to the GUARD-WARN copy distinguishing the benign same-terminal re-prime case from a genuine concurrent clobber.

## Recommended redesign

- (omitted — verdict is PROCEED-WITH-CAUTION)

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references to both `wrap-session.md` copies, the `improvement-log.md` incident at lines 213–221, and `session-marker.md` contract lines, plus the verbatim CHANGE_DESCRIPTION). No training-data fallback was used on fetch/read failures.

## Architectural Commentary

_System-owner second opinion (Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION. Full advisory on disk: projects/axcion-ai-system-owner/output/consultations/consult-2026-06-01-risk-check-second-opinion-wrap-session-clobber-guard.md_

**Routing:** Canonical command edit across a paired pair — gated change class. The guard touches `logs/.session-marker`, a High load-bearing two-end contract whose residual intra-project race is already documented. The 2026-05-29 incident is that parked risk now observed in practice. Correctly gated.

**1. Concur with PROCEED-WITH-CAUTION + both mitigations.** The insertion is fail-safe — it can only push toward the existing STOP, never away from it (OP-3 loud-failure-over-silent-continuation). Mitigation 1 (per-file prose, identical detector algebra, diff the blocks) neutralizes the real risk: non-byte-identical application across a divergent pair. Mitigation 2 (insert after marker resolution, dry-run to confirm CONCURRENT STOP) is load-bearing.

**2. Forcing OWN_*_SUBTRACT=0 is correct — do not narrow it.** Once the marker is suspected clobbered, it is exactly the input we can no longer trust, so any partial-attribution path reasons from the poisoned source (AP-1). Cost asymmetry — one manual review vs. a silent cross-session clobber — makes trust-nothing STOP right (OP-2). Build in the benign same-terminal re-prime discriminator, or the STOP becomes a rubber-stamp (AP-4).

**3. Strategic concern the dimension review missed.** It scored the patch in isolation; it did not weigh it against the parked structural fix (session-scoped marker) it sits on. The patch adds surface to the most intricate detector in the repo, but it is not speculative — it closes an observed incident, and the structural fix is a larger gated change. Right answer: ship now, but tag the clobber branch **superseded-on-arrival** and keep the session-scoped marker fix tracked (OP-11), so the fail-safe does not silently entrench marker-as-oracle.

**Position:** Proceed. No blocker. The one thing most worth getting right: **mitigation 2's insertion ordering, confirmed by dry-run** — a correct detector at the wrong point reproduces the original silent false-negative while looking fixed.

## Post-Gate Outcome — IMPLEMENTATION REJECTED AT VALIDATION (2026-06-01, S2)

This PROCEED-WITH-CAUTION verdict gated a design that **was implemented and then reverted before commit.** Mitigation 2 (the mandatory dry-run) replayed the exact 2026-05-29 incident in a temp git repo and the patched detector returned `CLOBBER=0, FOREIGN=0` — the original silent false-negative persisted.

Why the design fails (not a coding bug — a design-level dead end): in the real incident `.session-marker` is clobbered to the FOREIGN session's marker, so the foreign content matches `MARKER` while this session's own (committed) header is the "other." The uncommitted-only restriction (needed to avoid false-positives on normal same-day sequential sessions) therefore never fires on the incident. The broader any-other-marker signal fires on the incident but also on every second-or-later same-day session (rubber-stamp, AP-4). The clobber and benign-sequential cases are structurally identical in the files because the marker — the identity oracle — is the very thing that is unreliable.

**Disposition:** Reverted both wrap-session.md files (0 diff vs HEAD). Escalated to the Option 2 structural fix (session-scoped `CLAUDE_SESSION_MARKER` env var, immune to file clobber) in `logs/improvement-log.md` (2026-05-29 entry, status flipped to Option-1-VALIDATED-REJECTED). The verdict and dimension analysis above remain valid for the *design as described*; they did not (and a risk-check is not designed to) catch that the design is ineffective against its own target incident — that is what the dry-run mitigation caught, exactly as intended.
