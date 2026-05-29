# Risk Check — 2026-05-29

## Change

Item 3 from `ai-resources/logs/session-plan-S5.md`: C-1+C-2 consult return-size cap + project-local system-owner agent symlink fix.

C-1 EDITS:
- Extend `ai-resources/.claude/agents/system-owner.md` Phase 5 Function A (general consultation) and Function B (pre-change advisory) to write the full advisory to `projects/axcion-ai-system-owner/output/consultations/consult-{DATE}-{slug}.md` and return a ≤30-line structured summary to the main session.
- Function A's "free-form structured answer, target under 60 lines" sometimes converges below the cap; in that case the on-disk write is skipped — only the return-summary contract is mandatory.
- Also update `ai-resources/.claude/commands/consult.md` Step 4 brief to mandate the sub-30-line return contract.

C-2 EDITS:
- Project-local copy at `projects/axcion-ai-system-owner/.claude/agents/system-owner.md` is a 12904-byte regular file (mtime 2026-05-04) with two factually-stale sentences ("Project-local to projects/axcion-ai-system-owner/ at v1.").
- Canonical at `ai-resources/.claude/agents/system-owner.md` is 12780 bytes (mtime 2026-05-08).
- Cleanest fix per the source memo: `rm` the project-local copy and replace with a symlink to canonical (matches `DR-1` and the workspace-root pattern — workspace root `.claude/agents/system-owner.md` is already a symlink to canonical).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/system-owner.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/consult.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/.claude/agents/system-owner.md — exists (regular file; will be replaced by symlink)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/output — exists (existing agent Write scope)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/output/consultations — not yet present (new subdir under existing Write scope)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/pipeline-reviews/consult-2026-05-29.md — exists (source memo)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/agents/system-owner.md — exists (workspace-root symlink to canonical)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Both edits are well-scoped and directionally correct (C-1 brings `/consult` into Subagent Contracts conformity; C-2 ends a drift hazard via established symlink pattern), but the change touches a shared six-consumer agent body and introduces a new contract (≤30-line summary + on-disk path back) that requires explicit display semantics in `/consult` Step 5 to avoid hiding the on-disk advisory from the operator.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The C-1 edit adds Phase 5 Function A/B instructions to the canonical agent body — agent body is not always-loaded (it loads only when `/consult`, `/architecture-review`, `/implementation-triage`, `/systems-review`, `/friday-so`, or `/so-monthly` is invoked). Evidence: `ai-resources/.claude/agents/system-owner.md` lines 1-11 (frontmatter, no auto-load hook).
- Net token impact on the agent body is small (a few sentences per function); the intent of the change is to *reduce* per-session token cost by bounding return-size at the contract floor (≤30 lines vs. the unbounded ~2-4k-token drip cited in `consult-2026-05-29.md` line 5 and friction-log 2026-05-25 → 2026-05-28+).
- The `consult.md` Step 4 brief edit adds one line to a non-always-loaded command file (loads only on `/consult` invocation). Evidence: `consult.md` line 4 declares `disable-model-invocation: true` — command does not auto-load via description matching.
- C-2 is byte-neutral or net-negative (replaces a 12904-byte regular file with a symlink to a 12780-byte canonical, deduplicating ~12.7 KB of disk content). No load-cost change at runtime (the consuming surface — operator opening a session inside `projects/axcion-ai-system-owner/` — loads the same content either way).
- No SessionStart, Stop, PreToolUse, or UserPromptSubmit hook is added or modified. No `@import` chain introduced.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json` changes proposed. Verbatim from `CHANGE_DESCRIPTION` § WRITE SCOPE: "Agent's `Write` tool already declared in frontmatter at `tools:` list; existing scope per agent body line 21 is `projects/axcion-ai-system-owner/output/` only. The proposed `output/consultations/` subdirectory is within this existing scope."
- Evidence confirms: `system-owner.md` line 11 declares `Write` in tools list; line 21 states "Write — scoped to `projects/axcion-ai-system-owner/output/` only." The `output/consultations/` path proposed for the new advisory file is a subdir under that existing scope.
- The C-1 edit does NOT widen the agent's tool surface — `Write` is already present and already used by Functions C, E, F, G to persist their reports.
- **Symlink change class flag (per audit-discipline.md line 23):** C-2 creates a new symlink. `ai-resources/docs/audit-discipline.md` line 23 lists "New symlinks" as a required `/risk-check` class. This memo satisfies that requirement. The symlink target (`ai-resources/.claude/agents/system-owner.md`) matches the established workspace-root pattern (verified via `ls -la`: `.claude/agents/system-owner.md -> ../../ai-resources/.claude/agents/system-owner.md`), so the symlink itself does not introduce a novel capability — it normalizes one of three remaining regular-file copies into the symlink convention already governing the other two.
- No new tool invocation pattern, no removed deny rule, no scope-escalation.

### Dimension 3: Blast Radius
**Risk:** Medium

- **Six consumer commands depend on the canonical agent body.** Enumeration from `CHANGE_DESCRIPTION` § CONSUMER SURFACE and verified by grep:
  - `/consult` — Functions A+B (target of this change).
  - `/architecture-review` — Function C (already writes to disk via Write tool; output shape unchanged by C-1).
  - `/implementation-triage` — Function D (naturally short; cap not load-bearing).
  - `/systems-review` — Function E (already writes to disk; output shape unchanged).
  - `/friday-so` — Function F (already writes to disk; output shape unchanged).
  - `/so-monthly` — Function G (already writes to disk; output shape unchanged).
- Grep across `ai-resources/.claude/` for `system-owner` references: 67 matches across the command set and consult-related docs — high reference density but concentrated in the six consumer commands plus `resolve-incident.md` (which invokes `/consult` Function B and depends on the brief shape: `resolve-incident.md` lines 114-119).
- **Contract changes (Phase 5 Function A and B only):** C-1 modifies the output shape of Function A and Function B only. Function C, D, E, F, G output shapes are not touched by the proposed edit. The five non-`/consult` consumers therefore see no contract drift from C-1.
- **`/resolve-incident` Function B dependency:** `resolve-incident.md` line 117 carries a verbatim-shape contract comment: "If `/consult` or `grounding.md` is ever reorganized and Function B is renamed, this step and the contract comment must be updated in the same commit." The proposed C-1 edit does NOT rename Function B — it extends Function B's output shape. The dependency remains intact, but `resolve-incident.md` Step c assumes the consult second opinion is recorded "verbatim in the incident record" — under the new contract, the verbatim record may be a ≤30-line summary plus a path, which is a downstream display change worth flagging (mitigation below).
- C-2 affects only the project-local agent-discovery surface for sessions opened inside `projects/axcion-ai-system-owner/`. No consumer command targets that file directly (all six consumers spawn `system-owner` via `Task` from the workspace root, picking up the workspace-root symlink → canonical chain). The project-local copy's only role is fallback discovery when a session is opened without `--add-dir ai-resources` — replacing it with a symlink preserves identical behavior.
- Workspace-root symlink already exists and points to canonical (`ls -la` verified). C-2 brings the project-local layer into the same shape; no new pattern is introduced.

### Dimension 4: Reversibility
**Risk:** Medium

- **C-1 (agent body + consult.md edits):** clean `git revert` restores both files. Low reversibility risk.
- **C-2 (symlink swap):** the `rm` operation against `projects/axcion-ai-system-owner/.claude/agents/system-owner.md` is destructive against the working tree, but the file is git-tracked (mtime 2026-05-04 matches a prior commit). Per `CHANGE_DESCRIPTION` § (3): "`git revert` brings the regular file back, but if uncommitted local edits exist on the project-local copy they would be lost."
- Verification step before `rm` is the standard mitigation (`git status` on the project-local file to confirm no uncommitted edits exist before the destructive op). If clean, `git revert` of the symlink-replacement commit restores the regular file byte-identical.
- **On-disk advisory files (new under `output/consultations/`):** these are append-only artifacts produced by future `/consult` runs after the change lands. They are not affected by C-1's revert — pre-revert advisories remain on disk; post-revert `/consult` runs revert to the unbounded-return behavior. No log-mutation reversibility concern (the new subdir holds individual reports, not a shared append log).
- No state propagates outside the local repo (no `git push` mid-session; no Notion write; no external API POST).
- No automation (hook, cron, symlink-firing) is added by C-1. The symlink in C-2 is a passive file-system pointer; it does not "fire" between landing and a potential revert.
- Path-back precedent exists: `2026-04-27-replace-3-stale-project-files-with-symlinks-buy-side.md` is a prior symlink-replacement risk-check in this repo — confirms the operator has used this pattern before with a clean reversibility profile.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Coupling between Phase 5 Function A/B output and `consult.md` Step 5 posture.** `consult.md` Step 5 (lines 102-104): "Return the agent's response unmodified … Do NOT add a preamble, do NOT summarize, do NOT add an 'I hope this helps' closing." Under the proposed C-1 contract, the "agent's response" becomes a ≤30-line summary plus an on-disk path. The "return unmodified" instruction will still work mechanically — the summary IS the response — but it leaves implicit whether the on-disk path is rendered as a clickable/visible reference for the operator. If the agent's summary ends with "Full advisory: {path}" and Step 5 returns it verbatim, the operator sees the path. If the agent omits the path-back line, the operator cannot find the on-disk file. **The new contract must explicitly require the path-back line in the summary** (mitigation below).
- **Subagent Contracts convention coupling.** `ai-resources/CLAUDE.md § Subagent Contracts` lines 33-40 establish the workspace pattern: "Summary cap: 30 lines … Notes to disk: full findings go to a working-notes file … Summary returned to main session includes the path." C-1 explicitly conforms to this convention, and the convention itself names the path-back requirement — so this is a documented contract, not a new undocumented one, *provided* the agent body's new Phase 5 wording cites or reproduces the path-back requirement. Risk of silent omission is real but mitigable.
- **Function A conditional-write coupling.** `CHANGE_DESCRIPTION`: "Function A's 'free-form structured answer, target under 60 lines' sometimes converges below the cap; in that case the on-disk write is skipped — only the return-summary contract is mandatory." This is a new conditional contract: "if response ≤ N lines, no on-disk write." The threshold is implicit (presumably 30 lines, matching the return cap). The agent body must state the threshold explicitly, otherwise different invocations will apply different cutoffs.
- **Hidden coupling with `/resolve-incident` Function B record-keeping.** `resolve-incident.md` line 119 says "Record the system-owner second opinion verbatim in the incident record." Under the new contract, the verbatim second opinion is a ≤30-line summary plus a path; the path's target file is the canonical record, but the incident record will hold the summary not the full advisory. This is a behavior shift, though acceptable (the path is recoverable). Worth a note in the incident-record convention but does not block the change.
- **Two-end contract with `/pm` is NOT touched.** `consult.md` Step 2's verbatim list (lines 48-64) is not in the C-1 edit scope; the Step 4 brief edit lives below the two-end-contract boundary and does not affect it.
- **No functional overlap with existing mechanisms.** Functions C, E, F, G already use the same on-disk + summary pattern (`system-owner.md` lines 91, 107, 117, 128 each declare "Write the full {report/advisory/review} to … Then echo {summary} to chat"). C-1 brings Functions A and B into the same pattern — convergence, not overlap.

## Mitigations

- **Dimension 3 (Blast Radius — Medium):** When editing `system-owner.md` Phase 5 Function A and Function B, scope the diff strictly to those two function blocks (lines 73 and 75-79 in the canonical) — do NOT touch Function C/D/E/F/G output-shape blocks (lines 81-128) even cosmetically in the same edit. After the edit, run `/qc-pass` against the five non-`/consult` consumer commands as a regression check (this is already in the source memo's Recommended next session line, `consult-2026-05-29.md` line 33). Update `resolve-incident.md` Step c (line 119) in the same commit OR add an inline note clarifying that the verbatim record may now be the ≤30-line summary plus path — pick one and apply, do not leave the dependency implicit.

- **Dimension 4 (Reversibility — Medium):** Before `rm` on the project-local `system-owner.md` copy, run `git status` on that one file to confirm no uncommitted local edits exist (per `CHANGE_DESCRIPTION` § (3)). If status shows uncommitted edits, stop and surface them — do not run the destructive op. After `ln -s`, verify the symlink resolves to the canonical content (`cat` through the symlink, confirm matches canonical) and that the symlink is git-tracked correctly (the new symlink should appear as deletion + new symlink in `git status`, then collapse to a single symlink entry after commit).

- **Dimension 5 (Hidden Coupling — Medium):** The Phase 5 Function A and Function B output-shape rewrite MUST explicitly require the summary to include a "Full advisory: {on-disk path}" line as the last (or near-last) line — without this, the `consult.md` Step 5 "return unmodified" posture will silently hide the on-disk file from the operator. Also state the conditional-write threshold explicitly: e.g., "If the response fits within 30 lines, skip the on-disk write and return the response directly" — pick a single threshold (30 lines is the natural floor matching the summary cap) and write it into the agent body verbatim so future invocations apply it deterministically. `consult.md` Step 5 is fine as-is; the path-back rendering responsibility lives in the agent body, not the command wrapper.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references to `system-owner.md`, `consult.md`, `consult-2026-05-29.md`, `audit-discipline.md`, `resolve-incident.md`, `ai-resources/CLAUDE.md`; `ls -la` output for the three system-owner.md locations; grep counts across `ai-resources/.claude/`; verbatim quotes from `CHANGE_DESCRIPTION`). No training-data fallback was used on fetch/read failures.

## Architectural Commentary

_System-owner second opinion (Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION. The canonical `/consult` slash command is not surfaced as a Skill in this session's harness skill list; the system-owner agent was invoked directly via the Agent tool, equivalent to /consult's Function B path._

**Position.** Concur with PROCEED-WITH-CAUTION. Two design revisions to C-1 and one revision to the mitigation set.

**Design revision 1 — Drop the conditional-write threshold; always write to disk.** The proposed "≤30 lines → skip on-disk write" carve-out conflicts with three vault principles: OP-3 (loud failure over silent continuation — operator perception of "is there an archive for this consult?" becomes ambiguous), DR-6 (outputs go to `output/{project}/` — unconditional, no carve-out for small outputs), and AP-7 (speculative abstraction — token-saving benefit is hypothetical, marginal cost is trivial). Functions C/E/F/G already write unconditionally; bringing A and B into alignment is the clean shape. Archive integrity also keeps a future Function F/G consumption path open without partial-archive degradation.

**Design revision 2 — Path-back is a leading line in the agent's returned summary, not a `consult.md` Step 5 transformation.** Concrete shape:

```
**Full advisory on disk:** projects/axcion-ai-system-owner/output/consultations/consult-{DATE}-{slug}.md

{≤30-line summary body}
```

`consult.md` Step 5's "return unmodified" pass-through stays identical — five sibling consumer commands use the same pass-through posture; introducing a special-case detect-and-display in `/consult` only would create sibling inconsistency that AP-1 (silent conflict resolution) prohibits. The agent body owns the format; the command stays a thin wrapper.

**Slug algorithm — reuse `resolve-incident.md` Step 1.** Restate inline in the agent body so the agent is self-contained: lowercase QUESTION → replace non-alphanumeric runs with single `-` → strip leading/trailing `-` → truncate to 60 chars, trim back to nearest preceding `-` if mid-word → fall back to `consult-{HHMMSS}` if empty. Collision rule: append `-2`, `-3`, … until unique. Slug-over-timestamp serves OP-1 (compounding value — past consultations become a browsable index).

**`resolve-incident.md` Step c is NOT a shape contract.** It is a verbatim-quote-the-agent contract (the High-risk-incident flow embeds `/consult`'s response verbatim into the incident record). A ≤30-line summary with a leading path-back line is still verbatim-quotable. **Replace the reviewer's "update or annotate resolve-incident.md in the same commit" mitigation with a grep-verify step: confirm `resolve-incident.md` carries no free-form-shape assumption.** That's a check, not an edit.

**C-1 / C-2 sequencing — split into two commits, C-1 first.** C-1 is a canonical-agent edit (change class per `risk-topology.md § 3`); C-2 is a new symlink (distinct class). One-commit coupling sacrifices independent reversibility. C-1 first ensures the canonical content is post-edit before the symlink points at it; if C-2 ships first, there is a brief window where the project session loads the pre-edit canonical (stale "v1 project-local" sentences via path-resolved symlink, but missing the on-disk-write directives).

**C-2 blast radius is bounded by the manifest.** `shared-manifest.json` declares `system-owner` as project-local; the auto-sync hook reads this and explicitly skips `system-owner` for this project. The symlink swap does NOT change the auto-sync surface — auto-sync still skips it. What changes: which file the project session loads at agent-discovery time. One project affected (axcion-ai-system-owner). No other consumer.

**Risk the dimension review missed — principle conflict in the proposed C-1 design.** The five-dimension review evaluates the change for downstream impact but has no column for "principle alignment of the proposed design itself." The conditional-write threshold conflicted with OP-3 / DR-6 / AP-7 and the review did not catch it. Worth a friction-log entry post-session: `/risk-check` shape misses design-internal principle drift.

**Net position.** PROCEED-WITH-CAUTION, with the design revisions above and four mitigations: (1) scope agent-body diff to Phase 5 Function A/B only; run `/qc-pass` against the five non-`/consult` consumer commands; grep-verify `resolve-incident.md` carries no free-form-shape assumption; (2) before `rm` on the project-local copy, run `git status` on that one file to confirm no uncommitted edits; after `ln -s`, verify the symlink resolves to canonical content; (3) agent-body rewrite explicitly emits a leading `**Full advisory on disk:** {path}` line followed by a blank line, then the summary body — no conditional-write threshold; (4) split C-1 and C-2 into two commits, C-1 first.
