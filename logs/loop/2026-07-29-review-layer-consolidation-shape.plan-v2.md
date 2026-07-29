UNIT: 2026-07-29-review-layer-consolidation-shape
STREAM: 2026-07-29-review-layer-consolidation
PHASE: shape
REPO: ai-resources
BASE: 83d4adce5e3763dc1b39e48c85e2bd76e0fe53b3
NEXT: Codex — review-2 of this plan, then G1

PLAN v2

Supersedes `…-shape.plan.md`. Immutable; v1 is retained unedited.
Written after Codex review-1 (`…-shape.review-1.md`, verdict REVISE). All four material
findings adjudicated below and folded into the body.

---

## 0. Adjudication of review-1

| Finding | Disposition | Basis |
|---|---|---|
| **R2-F1** — consumer search blind to symlinked parent directories | **fixed** | Reproduced exactly. `find projects -name 'qc-pass.md' -path '*/.claude/commands/*'` → 25; `find -L …` → 26. The missing consumer is `projects/axcion-design-studio/.claude/commands/qc-pass.md`, and `ls -ld` shows `projects/axcion-design-studio/.claude/commands -> ../../../ai-resources/.claude/commands` — the **directory** is the symlink. The repository had already recorded this method rule in `logs/decisions.md` (2026-07-29 `prime-lean-down-shape`, `rejected-premise`): *"`test -L` answers only about the final path component and is blind to a symlinked parent… Where two enumerations disagree on a count, explain the disagreement."* v1 repeated an error this repo had already logged. Inventory re-derived in § 1; falsifier replaced in § 7. |
| **R2-F2** — deferring `/qc-pass` and `/risk-check` to the Prime stream | **fixed** | No file-level dependency exists. `grep 'qc-pass\|risk-check'` over both Prime-stream artifacts in `logs/loop/` returns **nothing**. The only real coupling runs the other way — `prime.md` *cites* `/qc-pass` at 168, 174, 322, 554, 825 and `/risk-check` at 270, 458, 606, 816 — and `prime.md` is the Prime stream's own object, not a constraint on this stream's dispositions. § 2 now decides both commands across the four axes the review named, and the deferral that remains is justified on **consumer** grounds, never on Prime. |
| **R2-F3** — incomplete embedded-stack inventory | **fixed** | All three confirmed at the cited lines, and a systematic sweep run rather than accepting the three as given (§ 3). `friday-journal.md:157` spawns `qc-reviewer`, and `:323` states *"The gate cannot be skipped from inside the command."* `reconcile.md:58` invokes `/contract-check` then `:65` spawns `reconcile-reviewer`, with `:61` conceding the first is *"corroborating evidence only, never a hard dependency."* `scope-project.md:68` is *"**Delegate QC.** Spawn the `scope-qc-evaluator` (opus)"* with no optional qualifier — v1's description of that site as already-conditional was wrong. |
| **R2-F4** — B1 leaves the QC methodology self-contradictory and broadly mandatory | **fixed** | Confirmed. `qc-independence.md:28-34` depends verbatim on *"the second post-edit QC"* and *"how many triage + fix passes ran"* — machinery v1's B1 removed while keeping those lines. B1 is replaced by a single coherent rewrite (§ 4, slice B1). One correction to the finding's scope, evidenced: the **QC-PENDING architecture at line 12 must be retained**, because `prime.md:168, 174, 322` consume it and `prime.md` is an excluded file this stream may not edit. That is a genuine file-level dependency — of `prime.md` on this doc, not of this stream on the Prime stream — and retaining it is correct on its own merits, since it is the safeguard for the unreachable-review case the brief protects. |

No finding rejected, deferred or ruled out of scope.

---

## 1. Corrected consumer inventory (parent-symlink-aware)

Method: `find -L projects -name '{cmd}.md' -path '*/.claude/commands/*'`, plus a directory sweep
`find projects -maxdepth 3 -path '*/.claude/commands' -type l`.

**Exactly one directory-level symlink exists**, and it is whole-directory:
`projects/axcion-design-studio/.claude/commands -> ../../../ai-resources/.claude/commands`.
That project therefore consumes **every** canonical command, not a chosen subset — so every
count below rises by exactly one, and any canonical deletion breaks it immediately.

| Command | v1 (blind) | Corrected | Of which real separate files |
|---|---|---|---|
| `qc-pass` | 25 | **26** | 2 |
| `refinement-pass` | 25 | **26** | 2 |
| `refinement-deep` | 25 | **26** | 0 |
| `triage` | 25 | **26** | 0 |
| `resolve` | 25 | **26** | 0 |
| `contract-check` | 21 | **22** | 0 |
| `blindspot-scan` | 18 | **19** | 0 |
| `implementation-triage` | 25 | **26** | 1 |
| `risk-check` | 25 | **26** | 0 |
| `consult` | 27 | **28** | 2 |
| `reconcile` | 14 | **15** | 1 |
| `pm` | 21 | **22** | 0 |

**Disagreement explained** (the rule `logs/decisions.md` requires): the two enumerations differ by
exactly 1 for every command, and the delta is always the same path under
`projects/axcion-design-studio/`. `find` does not descend into symlinked directories unless `-L`
is given; nothing else accounts for a difference.

**The eight real separate files re-verified by inode, not `diff`** (`diff` cannot distinguish
identity from equality — same recorded rule). `stat -f %i` returns a distinct inode from canonical
for all eight, so they are genuine independent files, and the v1 divergence measurement stands:
six of eight have drifted from canonical (`axcion-sector-intelligence/qc-pass` 5 lines,
`positioning-research/qc-pass` 5, `positioning-research/refinement-pass` 2,
`axcion-sector-intelligence/consult` 8, `axcion-ai-system-owner/consult` 84,
`buy-side-service-plan/reconcile` 29; the other two byte-identical but still separate files).
Canonical edits reach none of the eight.

**Unchanged from v1 and still the primary safety property:** all file symlinks and the one
directory symlink resolve into `ai-resources/` on `main`. This worktree is
`ai-resources-2` on `session/2026-07-29-2` (`git rev-parse --git-dir` →
`…/ai-resources/.git/worktrees/ai-resources-2`). Nothing here reaches a consumer before merge.

---

## 2. `/qc-pass` and `/risk-check` — decided here, on four axes

Review-1 is correct that Prime owns neither decision. Both are settled by this stream.

### `/qc-pass`

| Axis | Decision |
|---|---|
| **(a) automatic invocation to remove now** | **Remove all of it.** Nine sites: `qc-independence.md` auto-loop; both nudge hooks; `pm.md:94`; `friday-journal.md:157`; `cleanup-worktree.md:104` (second pass); `promote-workflow.md:246-247`; `friday-act.md:284-285`; `fix-project-issues.md:141`. Slices B1–B10. |
| **(b) fallback worth retaining** | **Yes — retain, operator-invoked.** `docs/work-loop.md:74` names `/qc-pass` as *the* Codex-unavailable fallback for the reviewed route, recorded `unassessed`, never passed. `prime.md:168, 174, 322` additionally consume the QC-PENDING flow that depends on it. Removing the command would break both. |
| **(c) physical deletion** | **Deferred — on consumer grounds, explicitly not on Prime grounds.** 26 consumers, one of them a whole-directory symlink that would break for every command at once. Requires a cross-project migration, named in B12. |
| **(d) workspace-root policy** | Separate follow-up in `workspace-root`: `CLAUDE.md:57` (the unconditional mandate), `:65-79` (contract-check triggers, blind-spot gate), `:129` (auto-loop pointer). Out of `REPO: ai-resources`; named in B12. |

### `/risk-check`

**Not deferred at all — decided KEEP, unchanged.** It is not a general reviewer stacked on
Claude's output; it is a structural-change gate with a distinct dimension set (usage cost,
permissions surface, blast radius, reversibility, hidden coupling, principle alignment, problem
reality) that Codex's per-unit review does not supply, firing at two named session boundaries
(`docs/audit-discipline.md:73-81`). `docs/work-loop.md:65` states the route never absorbs,
replaces or reschedules it. Its two in-command firings — `resolve-incident.md:78`,
`promote-workflow.md` P5.1 — are that gate at its proper place, not stacking.
Axes (a) and (b) are therefore empty; (c) is a decision not to delete rather than a deferral;
(d) needs no change, since workspace Autonomy Rule #9 already delegates the class list to
`audit-discipline.md`, which this stream does not touch.

---

## 3. Complete embedded-stack inventory and disposition

Method: `grep -nEi 'spawn.*(qc-reviewer|triage-reviewer|refinement-reviewer|risk-check-reviewer|reconcile-reviewer|scope-qc-evaluator|expert-check-reviewer)|Invoke /...|Run /...'` across all 92 files in `.claude/commands/`. Sites that spawn an **auditor which produces the command's primary
analysis** (`repo-dd-auditor`, `token-audit-auditor`, `lean-repo-auditor`, `diagnostics-scanner`,
`system-owner` in `/fix-project-issues`) are engines, not reviewers of Claude's output, and are
out of scope by the brief's own framing.

| Site | Line(s) | Automatic? | Disposition | Slice |
|---|---|---|---|---|
| `docs/qc-independence.md` auto-loop | 14–34 | yes | **Rewrite** to one coherent rule | B1 |
| `.claude/hooks/auto-qc-nudge.sh` | whole | yes | **Delete** | B2 |
| `.claude/hooks/auto-resolve-nudge.sh` | whole | yes | **Delete** | B2 |
| `pm.md` internal QC, cap 2 | 88, 94, 130–150, 162, 167 | yes | **Remove** — artifact is an advisory chat ruling, not a committed artifact; `:162` concedes `/consult` answers harder questions with none | B3 |
| `cleanup-worktree.md` + `execution-protocol.md` qc→triage→qc | 66, 77, 104 / §§ 4, 6 | yes | **Collapse to one** QC pass; every hard gate untouched | B4 |
| `promote-workflow.md` P5.2 independent QC | 37, 246–247, 282 | yes | **Remove**; keep P1 evidence QC and P5.1 `/risk-check` | B5 |
| `resolve-incident.md` `/consult` second opinion | 114–119 | yes, on RISK ≥ High | **Make operator-invoked**; `/risk-check` at `:78` kept | B6 |
| **`friday-journal.md` Step 5.5** | 155–176, 323 | yes, **unskippable** | **Make operator-invoked.** Three deterministic checks already cover the schema-critical surface — 5.4 mechanical pre-check, 5.6 drop-check, 5.7 deterministic risk-class scan — and `/friday-act` disposes every item with the operator. All three deterministic checks retained. | **B7** |
| **`reconcile.md` Step 3 `/contract-check`** | 56–61 | yes | **Remove the automatic `/contract-check`.** The file itself calls it *"corroborating evidence only, never a hard dependency"* (`:61`). `reconcile-reviewer` at `:65` is **kept** — it *is* the command's engine, producing the mandate-compliance judgment. | **B8** |
| **`scope-project.md` Stage 5 `scope-qc-evaluator`** | 68 | yes, mandatory | **KEEP unchanged.** Correcting v1: this is not a stacked reviewer. Stage 5 is *"Consolidated QC + brief emission (delegate + reconcile)"* — the delegation **is** the stage, and the evaluator produces the five-way readiness verdict the stage exists to emit. Items 2 and 3 at `:70,72` remain optional. | — |
| `new-project.md` Architecture Gate | 433, 440 | yes | **KEEP unchanged** — one advisory ROI call at a real decision gate, once per pipeline, already non-blocking on failure | — |
| `refinement-deep.md` qc+refinement+triage | 26, 32 | only when invoked | **RETIRE — deferred** on consumer grounds (26). Its body *is* the stacking; no automatic caller exists, so nothing to remove now | B12 |
| `refinement-pass.md`, `triage.md`, `expert-check.md`, `blindspot-scan.md`, `implementation-triage.md`, `contract-check.md`, `consult.md` | — | **no** | Operator-invoked already; unchanged | — |
| `resolve.md` | 9 | no | **RETIRE — deferred**; shares `triage-reviewer` with `/triage`; auto-nudge removed in B2 | B12 |

Command dispositions from v1 § 2 otherwise stand unchanged.

---

## 4. Build slices, in order

### Tier 1 — behavior changes now, independent of layer 1

**B1 — Rewrite `docs/qc-independence.md` as one coherent rule.** *Keystone.*
Replaces v1's partial edit, which review-1 correctly showed was self-contradictory.
- Touches: `docs/qc-independence.md` only.
- The rule the file states after this slice:
  1. **One independent review per change, not a chain.**
  2. **For `/work-loop`-routed work, Codex is that review** (`docs/work-loop.md:74-75`); `/qc-pass` does not also run.
  3. **Outside `/work-loop`, one `/qc-pass`**, with depth proportional to change materiality.
  4. **`/qc-pass` is the explicitly chosen fallback when Codex is unreachable** — recorded `unassessed`, never passed.
  5. **A second round only when the first found a material issue requiring redesign** — never automatically, never on a wish for more assurance.
- **Retained, rewritten to stand on their own** — no surviving reference to the deleted multi-pass loop: the **materiality floor** (`:16`, bounds what counts as a finding) and the **unresolved-material-finding halt-and-surface** (`:28-34`, rewritten to key on *"a material finding left unresolved"* instead of *"the second post-edit QC"* and *"how many triage + fix passes ran"*).
- **Retained unchanged: the QC-PENDING architecture (`:12`).** `prime.md:168, 174, 322` consume it, and `prime.md` is excluded from this stream. It is also the safeguard for exactly the unreachable-review case the brief protects.
- **Removed:** the auto-spawn of `triage-reviewer`; the up-to-two post-edit re-QC cycles; the second triage pass; the unconditional *"Post-edit QC is mandatory"* framing, replaced by rule 3's materiality proportionality.
- **The `## QC → Triage Auto-Loop` heading is retained** so workspace `CLAUDE.md:129`'s pointer keeps resolving.
- Evidence: full before/after; `grep -n 'second post-edit QC\|triage + fix passes\|Auto-spawn' docs/qc-independence.md` → 0, with the same grep at `83d4adc` as positive control; `grep -c 'QC-PENDING'` unchanged.

**B2 — Delete the two prompting hooks.** Unchanged from v1.
- Touches: `.claude/hooks/auto-qc-nudge.sh` (delete), `.claude/hooks/auto-resolve-nudge.sh` (delete), `.claude/settings.json` (two hook entries only; no `allow`/`ask`/`deny` touched).
- Consumer check stands: six project copies, all **regular files**; only `projects/positioning-research/.claude/settings.json` wires them, via its own `$CLAUDE_PROJECT_DIR` copy. Named in B12.
- `/risk-check` note: hook and `settings.json` edits are listed change classes (`audit-discipline.md:60-65`); the gate fires on its own schedule and this plan neither absorbs nor reschedules it.

**B3 — Remove `/pm`'s internal QC pass.** Unchanged from v1 (`pm.md` 88, 94, 130–150, 162, 167). Retains the Step 6 line offering the operator `/qc-pass` on a load-bearing ruling.

**B4 — Collapse `/cleanup-worktree` to one QC pass.** Unchanged from v1.
Protected and explicitly untouched: Section 4 hard-gate blocks and the Step 13 cross-check; Section 7 bias counters; `execution-protocol.md` §§ 7–10; `check-destructive-liveness.sh`.

**B5 — Remove `/promote-workflow` P5.2.** Unchanged from v1. Keeps P1 evidence QC, P5.1 `/risk-check`, P6 deterministic verification, and the P5.4 push gate.

**B6 — Make `/resolve-incident`'s `/consult` second opinion operator-invoked.** Unchanged from v1. `/risk-check` at `:78` and the `status: escalated` stop are kept.

**B7 — Make `/friday-journal` Step 5.5 operator-invoked.** *(new — R2-F3)*
- Touches: `.claude/commands/friday-journal.md` Step 5.5 (155–176), the per-finding disposition loop it drives (15c–15e), and the design note at `:323` including the *"cannot be skipped from inside the command"* clause.
- **Retained, all deterministic:** Step 5.4 mechanical schema pre-check, Step 5.6 drop-check, Step 5.7 deterministic risk-class scan. Also retained: the `**Risk-check required:**` producer contract at `:326`.
- Rationale from the invocation route: the report's schema-critical properties are covered deterministically, and `/friday-act` disposes every item with the operator before anything executes.

**B8 — Remove `/reconcile`'s automatic `/contract-check`.** *(new — R2-F3)*
- Touches: `.claude/commands/reconcile.md` Step 3 (56–61) and the `CONTRACT_CHECK_RESULT` field wherever the report template consumes it (`docs/reconcile-report-template.md`).
- `reconcile-reviewer` at `:65` is **kept** — it is the engine, not a stacked reviewer.
- The file's own words carry the argument: `:61` *"corroborating evidence only, never a hard dependency."*

### Tier 2 — contingent on the layer-1 follow-up

These remove **restatements** of workspace `CLAUDE.md:57`. Until that rule changes in
`workspace-root`, the standing rule still applies and behavior does not change. **No behavioral
saving may be claimed for them.**

**B9 — `/friday-act` sub-step 16k** (284–290, note at 489) → operator-invoked, matching the
in-repo precedent already set by `fix-repo-issues.md:285`.

**B10 — `/fix-project-issues` Step 3** (`:141`) → remove the per-edit `/qc-pass` restatement.
Keeps Step 1's independent gating re-derivation, Step 2's gated-item stop, and the `system-owner`
dispatch at 93–115.

**B11 — Layer-4 guidance.** `docs/session-rituals.md`, `weekly-cadence.md`,
`weekly-session-guide.md`, `friday-cadence-runbook.md`, `operator-maintenance-cadence.md`,
`onboarding-daniel.md`, `onboarding-daniel-cheatsheet.md`, `monday-prep.md:266-267`.
Not touched: `docs/materiality-bar.md` (the finding floor), `docs/audit-discipline.md`
(`/risk-check` unchanged).

### Closing slice

**B12 — One append-only entry in `logs/decisions.md`.**
Records: the `/qc-pass` deletion deferral **on consumer grounds** with the 26-consumer count and
the whole-directory symlink; the `/risk-check` **KEEP** decision and why it is not a deferral;
`/refinement-deep` and `/resolve` retirement deferred on the same consumer grounds; the eight real
separate project files (six diverged) canonical edits cannot reach; `positioning-research`'s
locally wired nudge hooks; and the required `workspace-root` follow-up on `CLAUDE.md:57, 65-79,
129`. **A decision-log entry in an existing log — not a registry, layer or gate.**

---

## 5. Dependencies, ordering, rollback

```
B1 ──> B3 B4 B5 B6 B7 B8      (all reference the auto-loop or its posture)
B1 ──> B9 B10 B11
B2 ─── independent, any time after B1
B11 ── last edit slice: it describes the end state
B12 ── last overall
```

Rollback: one commit per slice on `session/2026-07-29-2`; `git revert {sha}` per slice, B1 last.
Consumers are unreachable before merge (§ 1), so abandoning the branch is a complete rollback with
zero consumer impact. B2's two deletions restore by the same revert.

---

## 6. Scenarios

**Ordinary.** Today: nudge hook → `/qc-pass` → findings → auto `triage-reviewer` → fixes →
post-edit QC → possibly a second triage + QC → Stop hook nudges `/resolve`. After B1+B2: one
review, proportional to materiality; no auto-triage, no re-QC cycles, no prompting. **Structural:
one pass instead of up to five, plus two removed prompts. No token baseline measured.**

**Shared change.** `/promote-workflow` after B5: `/risk-check` P5.1 unchanged; P1 evidence QC
unchanged; P6 residue scan and `/sync-workflow` in-sync check unchanged and deterministic. Removed:
the third pass at P5.2.

**Destructive.** `/cleanup-worktree` after B4: Step 13 gate-coverage cross-check → Section 7 bias
counters → **one** QC pass → revision → `ExitPlanMode` → Section 4 hard gate demanding the declared
confirmation phrase → `check-destructive-liveness.sh` at PreToolUse. What was removed sat between
two reviewers, never between the operator and the delete.

**Codex unavailable.** `/qc-pass` and its agent stay on disk precisely so `docs/work-loop.md:74`'s
fallback survives — recorded `unassessed`, never passed. B1 rule 4 states this explicitly, and the
QC-PENDING commit-block at `qc-independence.md:12` is retained for the architectural case.

---

## 7. What would falsify this plan

1. **A broken consumer of either shape.** Both predicates must return empty, and both must be shown to fire first:
   ```
   find -L projects -path '*/.claude/commands/*.md' ! -exec test -e {} \; -print
   find projects -maxdepth 3 -path '*/.claude/commands' -type l ! -exec test -e {} \; -print
   ```
   Positive control: create a scratch broken file-symlink **and** a scratch broken directory-symlink, confirm each predicate prints its own shape. A control on only one shape does not clear this criterion — that is the v1 defect.
2. **A count regression.** The § 1 corrected counts, re-derived with `find -L` after the change, must be identical. Any drop means a consumer was severed.
3. **A workspace-wide completion claim** in any evidence line, commit message or summary. Layer 1 is untouched by design.
4. **Replacement machinery.** `git diff --name-status {BASE}..HEAD` shows any `A` other than `logs/loop/2026-07-29-review-layer-consolidation-*`.
5. **A weakened protected safeguard.** `git diff {BASE}..HEAD --` over the six protected hooks is non-empty; or `cleanup-worktree.md` Section 4 / Section 7 text or `execution-protocol.md` §§ 7–10 differ; or `friday-journal.md` Steps 5.4 / 5.6 / 5.7 differ; or any `allow`/`ask`/`deny` entry changed.
6. **An excluded file touched.** `.claude/commands/prime.md`, `session-start.md`, `session-plan.md`, `docs/backlog-reconciliation.md`, `.claude/commands/work-loop.md`, `workflows/research-workflow/**`, any `*prime-minimum-responsibility*` path.
7. **A deferred deletion happened.** Any canonical `.claude/commands/*.md` or `.claude/agents/*.md` deleted. Only B2's two hook scripts may be deleted.
8. **A dangling reference to removed machinery.** `grep -rn 'second post-edit QC\|triage + fix passes\|Auto-spawn .triage-reviewer' docs/ .claude/` returns any hit outside `logs/loop/`.

---

## 8. Limitations

- **No token baseline.** Saving stated as passes removed, not tokens. Prove must not imply a quantified figure.
- **Tier 2 delivers text, not behavior** until `workspace-root` changes.
- **Eight real separate project files keep today's behavior**, six of them already diverged. Named in B12; not fixable from this repository.
- **`/contract-check`'s primary trigger** (workspace `CLAUDE.md:69`) is left partly obsolete; the command is kept unchanged and the inconsistency is recorded, not resolved.
- **`workflows/research-workflow/` excluded** per settled scope; no claim is made about it.
- **The §1 inventory covers `projects/` only.** `knowledge-bases/`, `harness/` and `workflows/` were not swept for command installations. Stated because the v1 defect was exactly an unswept installation shape; Prove should extend the `find -L` sweep to those roots before any deletion is scheduled.
