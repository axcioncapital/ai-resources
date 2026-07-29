UNIT: 2026-07-29-review-layer-consolidation-shape
STREAM: 2026-07-29-review-layer-consolidation
PHASE: shape
REPO: ai-resources
BASE: 267c4c2b1d4d3c98956f9ca18e78c528ba4a7cd3
NEXT: Codex — pre-implementation review of this plan, then G1

PLAN

Immutable. A revision is `-v2`, never an edit to this file.

---

## 0. Premise verification (run before this plan was written)

| Premise | Verdict | What was run → what was observed |
|---|---|---|
| Frame artifacts at 267c4c2 complete and retained | **confirmed** | `git show --stat 267c4c2`; `git cat-file -e 267c4c2:logs/loop/…-frame.evidence.md` → present, 184 lines. `grep -n '^Status:'` on the working copy → `Status: complete` at line 8. Both frame files still on disk in `logs/loop/`. |
| Candidates have external project installations; most canonical symlinks; qc-pass and refinement-pass also have two regular copies | **confirmed, and incomplete** | `find projects -name '{cmd}.md' -path '*/.claude/commands/*'` split by `-type l` / `-type f`. qc-pass 25 = 23 symlink + 2 regular; refinement-pass 25 = 23 + 2. The two regular copies are `projects/axcion-sector-intelligence/` and `projects/positioning-research/` in both cases — as briefed. **Addition:** three further commands also carry regular copies the brief did not name — `implementation-triage` 25 = 24 + 1 (`axcion-ai-system-owner`), `consult` 27 = 25 + 2 (`axcion-sector-intelligence`, `axcion-ai-system-owner`), `reconcile` 14 = 13 + 1 (`buy-side-service-plan`). Eight forked copies total, not four. |
| Deleting a canonical target without migrating projects creates broken commands | **confirmed** | Scratch test in the session scratchpad: `ln -s target.md link.md`; with target present `test -e link.md` → PASS and `cat` returns content; after `rm target.md`, `test -e link.md` → FAIL, `cat link.md` → `No such file or directory`, while `ls -l` still lists the link. Breakage is silent at the filesystem level — the link object survives. |
| Automatic hooks, embedded stacks and in-repo guidance remain live | **confirmed** | `grep -c` in `.claude/settings.json` → 1 wiring each for `auto-qc-nudge.sh` and `auto-resolve-nudge.sh`; both files `-rwxr-xr-x`. Re-derived reviewer-token counts at HEAD: pm 12, friday-act 12, promote-workflow 6, fix-project-issues 6, new-project 3, resolve-incident 7, cleanup-worktree 2. All ten layer-4 docs present (`qc-independence` 34 lines … `onboarding-daniel` 381). |
| Protected deterministic and execution-time controls contain no judgment reviewer | **confirmed** | `grep -cEi 'Task tool\|subagent\|qc-reviewer\|triage-reviewer\|risk-check-reviewer\|refinement-reviewer\|system-owner\|Agent\('` → 0 on `pre-commit`, `check-destructive-liveness.sh`, `check-skill-size.sh`, `check-template-drift.sh`, `check-permission-sanity.sh`, `check-foreign-staging.sh`. Positive control: the same grep on `.claude/commands/qc-pass.md` → 6. |

**Consumer-search positive controls.** `find projects -name 'prime.md' -path '*/.claude/commands/*'` → 25 (known present); `find projects -name 'zzz-nonexistent.md' …` → 0 (known absent). Same primitive, so the per-command counts above are checks that can fire.

---

## 1. The finding that shapes this plan

**Six of the eight forked project copies have diverged from canonical.**
`diff` against `ai-resources/.claude/commands/{cmd}.md`:

| Fork | Result |
|---|---|
| `axcion-sector-intelligence/qc-pass.md` | diverged (5 lines) |
| `positioning-research/qc-pass.md` | diverged (5 lines) |
| `positioning-research/refinement-pass.md` | diverged (2 lines) |
| `axcion-sector-intelligence/consult.md` | diverged (8 lines) |
| `axcion-ai-system-owner/consult.md` | diverged (84 lines) |
| `buy-side-service-plan/reconcile.md` | diverged (29 lines) |
| `axcion-sector-intelligence/refinement-pass.md` | identical |
| `axcion-ai-system-owner/implementation-triage.md` | identical |

Editing a canonical command does not reach a fork. Those six projects keep today's behavior until the cross-project follow-up runs. This is a bounded, named limitation, not a defect in the plan.

**All 23 symlinks resolve to `ai-resources/`, the `main` checkout — not to this worktree.**
`readlink` on all 23 → `…/ai-resources/.claude/commands/qc-pass.md`. `ai-resources-2` is a **git worktree** of the same repository (`git rev-parse --git-dir` → `…/ai-resources/.git/worktrees/ai-resources-2`) on branch `session/2026-07-29-2`, while `ai-resources/` sits on `main`. **Nothing in this stream reaches a project consumer until the branch merges to `main`.** That is the plan's primary safety property and the reason no slice can break a live project mid-flight.

**Layer 1 constrains what the in-repo slices can actually change.**
Workspace `CLAUDE.md:57` is a standing session rule: *"Run `/qc-pass` after producing or editing any substantive artifact or plan, before approval or commit. Never skip QC as an efficiency call."* It binds every session whether or not a command restates it. So removing a command's **restatement** of that rule removes text, not behavior — the standing rule re-imposes it. Removing machinery that goes **beyond** one pass (chained reviewers, re-QC cycles, prompting hooks, reviewers on non-artifacts) changes behavior immediately, layer 1 or not.

That distinction, not file count, is how the Build slices are tiered below. It is also what G1 is really deciding.

---

## 2. Disposition per candidate — each with a cited distinct purpose

| Command | Distinct purpose (cited) | Disposition |
|---|---|---|
| **`/qc-pass`** | Context-isolated conformance review of an artifact (`docs/qc-independence.md:5,7`). Duplicated by Codex for work-loop-routed work (`docs/work-loop.md:74`). | **KEEP — retirement deferred** per brief. Remains the documented Codex-unavailable fallback (`docs/work-loop.md:74`). Automatic *chaining* around it removed. |
| **`/risk-check`** | Seven-dimension structural-change risk at two named session gates (`docs/audit-discipline.md:73-81`). Explicitly preserved by `docs/work-loop.md:65` — "the route never absorbs, replaces or reschedules it". | **KEEP unchanged — retirement deferred.** No slice touches its gates. |
| **`/refinement-pass`** | Writing quality and structure, not defect-finding — `.claude/agents/refinement-reviewer.md:11` "evaluate writing quality and structure". Genuinely distinct from `/qc-pass`. | **KEEP, operator-invoked only.** No automatic caller exists today; none is added. |
| **`/refinement-deep`** | Runs QC **and** refinement in parallel, then triages the combined set. Its purpose *is* the stacking the operator objects to; it has no distinct review dimension of its own. | **RETIRE — deferred.** 25 symlink consumers; no deletion this stream. Named in the follow-up record (Slice B10). |
| **`/triage`** | Prioritizes a suggestion set — `.claude/agents/triage-reviewer.md:11` "evaluate and prioritize suggestions or proposed changes". Distinct from QC (which finds defects). | **KEEP, operator-invoked only.** Auto-spawn removed (Slice B1). |
| **`/resolve`** | Post-QC importance verdict plus fix recommendations. Shares `triage-reviewer` with `/triage` (same agent, per its own description line 3). Overlap is near-total. | **RETIRE — deferred.** Named in the follow-up record. Auto-nudge removed now (Slice B2). |
| **`/contract-check`** | Cumulative drift against the **original** mandate across multiple QC rounds — a dimension no single QC pass can see (workspace `CLAUDE.md:65`). | **KEEP.** Note for the follow-up: its primary trigger (workspace `CLAUDE.md:69`, "two or more rounds of `/qc-pass` → `/resolve` → re-QC") is largely obsoleted once the auto-loop is gone. That trigger text is layer 1 — out of scope here. |
| **`/blindspot-scan`** | Real-usage fit — *will this actually run and get used?* A different class from artifact QC, and `check-destructive-liveness.sh:14-20` is the recorded evidence that plan-time reasoning cannot substitute for it. | **KEEP unchanged.** Already conditional in-repo (`scope-project.md:72`, "Optional and gate-placed"). Its automatic firing is mandated at layer 1 only. |
| **`/consult`** | System-owner **architectural** judgment, not artifact QC. | **KEEP.** Automatic invocation removed from `/resolve-incident` (Slice B6). Retained as the engine of `/fix-project-issues` Step 3, where it produces the candidate list rather than reviewing Claude's output. |
| **`/reconcile`** | Judges a project **output against the project mandate** — mandate compliance, not artifact quality (`.claude/agents/reconcile-reviewer.md` description). | **KEEP unchanged.** No automatic caller exists; `new-project.md:882-884` writes an operator-facing pointer only. |
| **`/implementation-triage`** | ROI verdict — *worth doing*, not *correct* (`.claude/commands/implementation-triage.md` description, "ROI-oriented, not risk-oriented"). | **KEEP unchanged.** Its one automatic caller (`new-project.md:433`) is a single advisory call at a real decision gate, once per pipeline, already non-blocking on failure (`new-project.md:440`). That is proportionate governance, not stacking. |

**Nothing is deleted in this stream.** No canonical command file, no reviewer agent, no symlink target.

---

## 3. Build slices, in order

Each slice is one unit, one commit, staged by explicit pathspec.

### Tier 1 — behavior changes now, independent of layer 1

**B1 — Remove the automatic QC → Triage loop.** *Keystone; everything else references it.*
- Touches: `docs/qc-independence.md` (§ QC → Triage Auto-Loop, lines 14–34).
- Change: the loop stops being automatic. `triage-reviewer` is no longer auto-spawned on findings; the up-to-two post-edit re-QC cycles and the second triage pass are removed. **The `## QC → Triage Auto-Loop` heading is retained** so workspace `CLAUDE.md:129`'s pointer keeps resolving — the section states that triage now runs only when the operator asks. The materiality-floor paragraph (line 16) and the cap-exhaustion halt-and-surface rule (lines 28–34) are **kept**: the first bounds what counts as a finding, the second prevents a silent pass, and neither is a stacked reviewer.
- Evidence: quote the before/after section; `grep -n 'Auto-spawn' docs/qc-independence.md` → 0 hits, with the positive control that the same grep on `267c4c2:docs/qc-independence.md` → 1.

**B2 — Delete the two prompting hooks.**
- Touches: `.claude/hooks/auto-qc-nudge.sh` (delete), `.claude/hooks/auto-resolve-nudge.sh` (delete), `.claude/settings.json` (remove the two hook entries only).
- Rationale: they fire on *any* written file ≥50 lines regardless of risk, and the Stop hook then prompts `/resolve` on top. Pure unconditional prompting; nothing else reads them.
- **`/risk-check` note:** hook edits and `settings.json` edits are both listed change classes (`docs/audit-discipline.md:60-65`). `/risk-check` fires at its own gates on its own schedule and this plan neither absorbs nor reschedules it (`docs/work-loop.md:65`). No permission (`allow`/`ask`/`deny`) entry is touched.
- Consumer check already run: six project copies exist, all **regular files**, and only `projects/positioning-research/.claude/settings.json` wires them — via `$CLAUDE_PROJECT_DIR/.claude/hooks/…`, its own copy. Deleting the canonical pair breaks nothing there. Named in B10.
- Evidence: `git show --stat`; re-run the workspace-wide `grep -rl 'auto-qc-nudge\|auto-resolve-nudge' --include='settings*.json'` → only `positioning-research`, with the pre-change result (which also listed `ai-resources-2`) as control.

**B3 — Remove `/pm`'s internal QC pass.**
- Touches: `.claude/commands/pm.md` — Step 4 (the `qc-reviewer` dispatch), the pass-cap-2 machinery and its two operator messages (lines ~88, 130–150), the design note at line 162, and the plan-divergence note at 167.
- Rationale: the artifact is an **advisory chat ruling**, not a committed artifact — so workspace `CLAUDE.md:57` does not reach it, and this pass is purely additive. `pm.md:162` concedes the divergence: "This diverges from `/consult` (which has no internal QC)." `/consult` answers harder architectural questions with no internal reviewer.
- Retained: the Step 6 line telling the operator they may run `/qc-pass` on a ruling they consider load-bearing.
- Evidence: `grep -c 'qc-reviewer' .claude/commands/pm.md` → 0 (control: 267c4c2 copy → non-zero); a walkthrough of an ordinary `/pm` invocation showing the ruling path now ends at Step 6.

**B4 — Collapse `/cleanup-worktree`'s three-reviewer chain to one.**
- Touches: `.claude/commands/cleanup-worktree.md` (Step 7 triage pass, lines 77–81; Step 9 second QC pass, lines 104–107 and its quick-tier skip machinery at 25) and `skills/worktree-cleanup-investigator/references/execution-protocol.md` (§ 4 triage, § 6 second QC) plus the two pointer lines in `skills/worktree-cleanup-investigator/SKILL.md:93,245`.
- Change: **keep the Step 6 first QC pass.** Remove the `triage-reviewer` pass and the second `qc-reviewer` pass. Step 8 revision now addresses the first pass's findings directly.
- **Protected, and explicitly untouched:** Section 4 hard-gate blocks and the Step 13 cross-check that every irreversible operation is gated; Section 7 bias counters; `execution-protocol.md` § 7 hard-gate protocol, § 8 execution-time re-verification, § 9–10 per-operation rules; `check-destructive-liveness.sh`. The confirmations immediately before destructive operations are **not** the QC subagents and are not weakened by removing them.
- Evidence: destructive scenario walkthrough (below); `grep -c 'triage-reviewer' .claude/commands/cleanup-worktree.md` → 0 with control; hard-gate block count in the command unchanged before/after.

**B5 — Remove `/promote-workflow`'s duplicate P5 QC.**
- Touches: `.claude/commands/promote-workflow.md` — Phase 5 item 2 (lines 246–247), the Key-rules line at 282, and the Gates summary at line 37.
- Change: remove the mandatory independent `/qc-pass` on landed changes. **Keep** Phase 1 QC on judgment items' evidence artifacts (distinct purpose: validating an analysis, not the delta — lines 182–192) and **keep** `/risk-check` at P5.1.
- Rationale: P6 already verifies deterministically — residue scan for source-project tokens, `/sync-workflow` in-sync check, optional scratch deploy (lines 254–262). Model-judgment QC on top of a deterministic verification plus `/risk-check` is the third pass on one change.
- Retained verbatim: "QC-fail defers, never drops" for P1, and the push-gating rule at P5.4.
- Evidence: shared-change scenario walkthrough (below).

**B6 — Remove `/resolve-incident`'s automatic `/consult` second opinion.**
- Touches: `.claude/commands/resolve-incident.md` Step 18 (lines 114–119) and the incident-record field reference; `templates/incident-log-template.md` if it hard-requires the field.
- Change: the `/consult` Function B call becomes operator-invoked, not automatic on `RISK ≥ High`. `/risk-check` at line 78 is **kept** — it already gates High/protected fixes, and its RECONSIDER verdict already stops the fix (line 20).
- Retained: the verbatim-shape contract comment for `/risk-check` verdict tokens (lines 83); the `status: escalated` stop.
- Evidence: `grep -n 'Function B' .claude/commands/resolve-incident.md` shows no automatic invocation remains; the record field, if kept, is marked optional.

### Tier 2 — contingent on the layer-1 follow-up

These remove **restatements** of workspace `CLAUDE.md:57`. Until that rule changes in `workspace-root`, the standing rule still applies and behavior does not change. They are worth doing for consistency and to stop the duplication compounding, but the plan must not claim a behavioral saving for them.

**B7 — `/friday-act` plan-file QC.** Touches `.claude/commands/friday-act.md` sub-step 16k (284–290) and the design note at 489. Make it operator-invoked, matching the in-repo precedent already set by `fix-repo-issues.md:285` — *"an operator running `/qc-pass` on the written plan is appropriate but not auto-triggered — the inline clarify gate at Step 4 already provided one round of operator review."* Same shape, same argument, currently inconsistent between two sibling commands.

**B8 — `/fix-project-issues` per-edit QC.** Touches `.claude/commands/fix-project-issues.md` Step 3 (line 141). Remove the "after any substantive artifact edit, run `/qc-pass`" restatement. **Keep** Step 1's independent gating re-derivation (lines 139) and Step 2's gated-item stop — those protect destructive/external operations and are on the protected list. **Keep** the Step 3 `system-owner` dispatch (93–115): it generates the candidate list, it is not a reviewer stacked on Claude's output.

**B9 — Layer-4 guidance.** Touches `docs/session-rituals.md`, `docs/weekly-cadence.md`, `docs/weekly-session-guide.md`, `docs/friday-cadence-runbook.md`, `docs/operator-maintenance-cadence.md`, `docs/onboarding-daniel.md`, `docs/onboarding-daniel-cheatsheet.md`, and `.claude/commands/monday-prep.md:266-267`. Bring the described cadence into line with B1–B8. `docs/materiality-bar.md` is **not** touched — it is the finding floor, not a reviewer. `docs/audit-discipline.md` is **not** touched — `/risk-check` is unchanged.

### Closing slice

**B10 — Record the deferred retirements and the cross-project follow-up.**
- Touches: `logs/decisions.md` (one append-only entry).
- Content: the retirement of `/refinement-deep` and `/resolve` is **deferred**, as is `/qc-pass` and `/risk-check` retirement, pending the `2026-07-29-prime-minimum-responsibility` stream; the eight forked project copies (six diverged) that canonical edits will not reach; `projects/positioning-research`'s locally wired nudge hooks; and the required `workspace-root` follow-up on `CLAUDE.md:57,65-79,129`.
- **This is a decision-log entry in the existing log — not a registry, not a compatibility layer, not a gate.** No new file, no new convention, nothing that must be maintained.

---

## 4. Dependencies and ordering

```
B1 ──┬─> B3, B4, B5, B6        (they reference the auto-loop)
     └─> B7, B8, B9
B2 ── independent, may run any time after B1
B9 ── last of the edit slices: it describes the end state
B10 ─ last overall
```

B1 first is load-bearing: `friday-act.md:288` and `fix-project-issues.md:141` both point at the auto-loop, so editing them before B1 leaves live pointers to a section that is about to change.

---

## 5. Rollback

- Every slice is one commit on branch `session/2026-07-29-2`. Rollback is `git revert {sha}` per slice; slices are independent apart from the ordering above, and reverting B1 last restores the original state exactly.
- **Project consumers cannot be affected before merge.** All 23 symlinks resolve into `ai-resources/` on `main`; this worktree is on `session/2026-07-29-2`. Abandoning the branch is a complete rollback with zero consumer impact.
- B2 deletes two files; `git revert` restores them, and `.claude/settings.json` is restored in the same revert.
- No slice deletes a canonical command or agent, so no rollback path depends on restoring a symlink target.

---

## 6. Scenarios

**Ordinary.** Operator edits a 120-line command file in an ai-resources session. Today: `auto-qc-nudge.sh` fires → `/qc-pass` → findings → `triage-reviewer` auto-spawns → fixes → post-edit QC → possibly a second triage + QC → Stop hook nudges `/resolve`. After B1+B2: the workspace rule still calls for one `/qc-pass` (layer 1 unchanged); no auto-triage, no re-QC cycles, no hook prompting. **Structural saving: one reviewer pass instead of up to five, plus two removed prompts.** No token baseline was measured — see Limitations.

**Shared change.** `/promote-workflow` lands canonical template edits consumed by ~20 projects. After B5: `/risk-check` at P5.1 (unchanged), P1 evidence QC on judgment items (unchanged), P6 residue scan + `/sync-workflow` in-sync verification (unchanged, deterministic). Removed: the extra model-judgment QC at P5.2. The change class is still gated, and verification is still independent — it is deterministic rather than a third reviewer.

**Destructive.** `/cleanup-worktree` plans a `delete` on an untracked path. After B4: plan written → Step 13 verifies every irreversible operation appears as a Section 4 hard-gate block → Section 7 bias counters populated → **one** `qc-reviewer` pass → revision → `ExitPlanMode` for operator approval → at execution, the Section 4 hard gate demands the declared confirmation phrase → `check-destructive-liveness.sh` probes at PreToolUse immediately before the command. Every gate that stands between the plan and the destruction is intact; what was removed sits between two reviewers, not between the operator and the delete.

**Codex unavailable.** `/work-loop` falls back to `/qc-pass` and records the review `unassessed`, never passed (`docs/work-loop.md:74`, command Step 7). This plan **keeps `/qc-pass` and its agent on disk** precisely so that fallback stays available — which is also why retirement is deferred rather than executed. Outside `/work-loop`, workspace `CLAUDE.md:57` still mandates a pass, so no command loses its only review when Codex is unreachable.

---

## 7. What would falsify this plan

Each is mechanically checkable at Prove.

1. **A broken project symlink.** `find projects -path '*/.claude/commands/*' -type l ! -exec test -e {} \; -print` returns any path. Positive control: create and delete a scratch symlink and confirm the same predicate prints it.
2. **A workspace-wide completion claim.** Any evidence line, commit message or chat summary asserting the reviewer stack is removed *for the workspace* rather than *in this repository*. Layer 1 is untouched by design.
3. **Replacement machinery.** `git diff --name-status {BASE}..HEAD` shows any added file (`A`) other than `logs/loop/2026-07-29-review-layer-consolidation-*`. No registry, wrapper, flag, shim or new gate.
4. **A weakened protected safeguard.** `git diff {BASE}..HEAD -- .claude/hooks/pre-commit .claude/hooks/check-destructive-liveness.sh .claude/hooks/check-skill-size.sh .claude/hooks/check-template-drift.sh .claude/hooks/check-permission-sanity.sh .claude/hooks/check-foreign-staging.sh` is non-empty; or the Section 4 hard-gate / Section 7 bias-counter text in `cleanup-worktree.md` and `execution-protocol.md` §§ 7–10 differs; or any `allow`/`ask`/`deny` entry in `settings.json` changed.
5. **An excluded file touched.** `git diff --name-only {BASE}..HEAD` intersects any of: `.claude/commands/prime.md`, `.claude/commands/session-start.md`, `.claude/commands/session-plan.md`, `docs/backlog-reconciliation.md`, `.claude/commands/work-loop.md`, `workflows/research-workflow/**`, any `*prime-minimum-responsibility*` path.
6. **A deletion that was deferred.** Any canonical `.claude/commands/*.md` or `.claude/agents/*.md` deleted. Only the two hook scripts in B2 may be deleted.

---

## 8. Limitations of this plan

- **No token baseline was measured.** The brief permits a structural description and this plan gives one; the saving is stated as passes removed, not tokens. Prove cannot therefore report a quantified saving, and must not imply one.
- **Tier 2 delivers text, not behavior, until `workspace-root` changes.** Stated plainly in § 1 and § 3. If G1 approves Tier 2 anyway, the evidence at Prove must say the slices landed without a behavioral claim attached.
- **Six diverged project forks keep today's behavior.** Named, routed to B10, not fixable from this repository.
- **`/contract-check`'s primary trigger is left partly obsolete.** The trigger text lives at workspace `CLAUDE.md:69` — layer 1. The command is kept and unchanged; the inconsistency is recorded in B10 rather than resolved here.
- **`workflows/research-workflow/` is excluded** per the brief's settled scope. Its own `.claude/commands/qc-pass.md` and four `/risk-check` references are untouched, so that workflow's internal review posture is unchanged and this stream makes no claim about it.
