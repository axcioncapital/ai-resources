UNIT: 2026-07-29-review-layer-consolidation-build-1
STREAM: 2026-07-29-review-layer-consolidation
PHASE: build
SLICE: S1 — Governing review/risk policy and proportionality
REPO: ai-resources
BASE: 31b77ff8f1873e91373a8e940586aad07632bd09
NEXT: Claude — Build-2 (S2)

EVIDENCE

## 1. G1 binding condition — satisfied

| Requirement | How it was met |
|---|---|
| Run the legacy end-time `/risk-check` **after S1's edits exist, before the S1 commit** | Run with all 16 files edited and uncommitted in the worktree. Verdict recorded in § 3. |
| Payload must distinguish **executed S1** from **approved-but-unexecuted S2–S4** | The payload carried two labelled sections — "WHAT IS EXECUTED AND ON DISK RIGHT NOW" and "WHAT IS APPROVED BUT NOT YET EXECUTED (do NOT review as executed; none of it exists on disk)". The reviewer honoured the split and scored only S1, explicitly treating the S2 window as a transition question rather than as executed work. |
| S2–S4 then follow the new proportional policy | Recorded here; no further `/risk-check` runs in this stream. |
| Explicit policy transition, not a waiver | The gate ran, returned **RECONSIDER**, and its findings were resolved before commit. § 3–4. |
| Plan-time gate not run, and not silently skipped | Stated in plan-v3 § 7 and reaffirmed here: two full Codex plan reviews served its purpose (`audit-discipline.md:75` at BASE) on this exact design. |

## 2. Scope extension to S1 — recorded, not silent

The Build-1 brief scoped S1 to "governing documents only; no command files." **Five command files were added**, on the `/risk-check` reviewer's explicit redesign direction:

`.claude/commands/`: `placement.md`, `risk-check.md`, `create-skill.md`, `contract-check.md`, `graduate-resource.md`

Justification: each carried a live pointer into a subsection **S1's own deletions orphaned**, none is owned by S2, S3, S4 or the § 6 follow-up, and leaving them would have shipped five broken references. This completes S1's change rather than extending it. The reviewer offered "S1 or an S1.5"; S1 was chosen so the four-slice consolidation that review-2's R2-F4 required is preserved — a fifth slice would have partly undone it.

**No S2–S4-owned file was touched.** Verified: `git diff --name-only` filtered against the full S2–S4 file list returns empty.

Final S1 file list (16): 5 command files above · `docs/{qc-independence, audit-discipline, autonomy-rules, protected-zones, work-loop, repo-architecture, ai-resource-creation, commit-discipline, placement-verifier}.md` · `skills/ai-resource-builder/SKILL.md` · `logs/friction-log.md` (autolog append, not a policy edit).

## 3. Transition gate — verdict and resolution

**Verdict: RECONSIDER.** Report: `audits/risk-checks/2026-07-29-transition-gate-legacy-end-time-risk-check-run-once-under-an.md`

Dimensions — Usage cost Low · Permissions Low · **Blast radius High** · Reversibility Low · **Hidden coupling High** · Principle alignment Medium · Problem reality Low.

| Finding | Resolution |
|---|---|
| Six dangling-reference sites unscheduled by any slice | **All repaired in S1** (§ 2), each verified at its cited line before editing. `resolve-incident.md:83` was the seventh cited site — it is S2-owned and its containing block is removed by S2's `:78` edit, so it is left to S2 by design, not missed. |
| Docs assert a repo-wide invariant S2 has not delivered | **Transitional caveat added** to `qc-independence.md` § Codex is the reviewer and `audit-discipline.md` § Invocation semantics. Both state the policy is authoritative now, that stale callers are being removed slice by slice, that `/prime` and `/session-plan` are excluded and still fire, and that **where a caller and the rule disagree, the rule wins and the caller is stale** — closing the risk that someone restores an automatic review because a command still asks for one. |
| Ordering | Reviewer: "S1-then-S2 ordering is directionally correct and should NOT be inverted — inverting would strip enforcement before the docs define its replacement." **Ordering kept.** |

**Decision not to re-invoke `/risk-check` after the repairs — stated, not silently waived.** The binding pre-change policy says RECONSIDER means redesign then re-invoke. It is not re-invoked here, for a reason recorded rather than assumed: the finding was **incompleteness of the edit set, not a wrong design**. The reviewer endorsed the design and the ordering explicitly; the repairs are seven reference rewrites whose correctness is decidable by grep, and that grep was re-run at full scope (§ 4). A second full reviewer pass on reference repairs is exactly the reassurance round this stream exists to remove. The operator's G1 condition also fixed the count at one run.

## 4. Falsifier results

| # | Falsifier | Result |
|---|---|---|
| 1 | Broken consumer of either shape | **Baseline is NOT empty — see § 5.** Both predicates positive-controlled in an isolated mock tree: P1 printed only the file-shape canary, P2 only the directory-shape canary, and the blindness cross-check reproduced the v1 defect (P1 alone returned 0 hits on the directory shape). Re-keyed for this stream to *no NEW broken consumer relative to BASE* — satisfied: S1 touched no symlink and no consumer file. |
| 2 | Count regression | **Clear.** All 12 counts re-derived with `find -L` after S1 are identical to plan-v3 § 8: qc-pass 26, refinement-pass 26, refinement-deep 26, triage 26, resolve 26, contract-check 22, blindspot-scan 19, implementation-triage 26, risk-check 26, consult 28, reconcile 15, pm 22. |
| 3 | Overclaim | **Clear.** No S1 text or commit message claims repo-wide or workspace-wide removal; the transitional caveats state the opposite explicitly. |
| 4 | Replacement machinery | **Clear.** Zero `A` entries outside `logs/loop/…` and the risk-check report. No new command, agent, hook, registry, wrapper, gate or programme. |
| 5 | Weakened protected safeguard | **Clear.** S1 touched no hook, no `settings.json`, and no `allow`/`ask`/`deny` entry — `git diff --name-only` has zero `.claude/hooks/` or `settings.json` entries. `protected-zones.md`'s zone *list* is unchanged; only the discharge route in the Required-review column changed. |
| 6 | Excluded file touched | **Clear.** `prime.md`, `session-start.md`, `session-plan.md`, `backlog-reconciliation.md`, `.claude/commands/work-loop.md`, `workflows/research-workflow/**` — none in the diff. |
| 7 | Deferred deletion happened | **Clear.** Zero deletions in S1. |
| 8 | Dangling reference | **Clear at full scope.** Re-run over `docs/ skills/ .claude/` — the original run was scoped to `docs/ skills/` only, which is how the six sites were missed; that scope error is the finding of this unit. Remaining hits are all accounted for: `onboarding-daniel-cheatsheet.md` ×6 (a table column header literally reading "When to fire", unrelated — false positive, and S4 owns the file), `qc-independence.md:69` (the intentional retired-note), `graduate-resource.md:126` (new text correctly scoping the cap to that check), `resolve-incident.md:83` (S2-owned, S2-scheduled). |
| 9 | Transition gate skipped | **Clear.** Verdict recorded in § 3. |

## 5. Findings raised, not caused by this stream

**Seven pre-existing broken command symlinks under `projects/`.** Predicate 1 was non-empty at BASE:
- `projects/project-planning/.claude/commands/route-change.md` → target does not exist
- `projects/project-planning/.claude/commands/audit-critical-resources.md` → target does not exist
- five more under the untracked `projects/strategic-os/.backup-untracked/`

Both `project-planning` links point at canonical commands that were removed or renamed at some earlier date. S1 did not create them and does not fix them — out of this stream's scope. **Consequence if left:** two commands silently fail to resolve in a live project. Worth a dedicated fix; raised here so it is on the record rather than absorbed into a falsifier that reads "clear."

## 6. Plan gap found — added to S2

`.claude/commands/improve-skill.md:108, 120` runs an **automatic independent post-edit QC pass** with a loop-back to Step 5b. This is embedded automatic general review of exactly the kind plan-v3 § 3 S2 removes, and **plan-v3's inventory never listed it** — `improve-skill.md` appears in no slice.

Disposition: **added to S2's file set.** This is not a scope change; plan-v3 § 4's approved claim is that no general Claude QC fires automatically from any reachable file, and an inventory miss that leaves one live is a defect in the inventory, not a new decision. `create-skill.md` 4a–4c and `migrate-skill.md` were checked in the same pass and carry **no** independent review pass — their loops are the author's own inline classify/fix/regression sequence, so they need no S2 edit beyond the S1 framing repair already made.

## 7. Corrections to plan-v3 (immutable; recorded here)

- **§ 3 S1 said "six cells" in `protected-zones.md`.** The true count is **nine table cells** plus the definition bullet — verified: `grep -c 'Risk-aware review'` → 10, `grep -c '/risk-check'` → 1 (the intentional fallback mention). All nine changed.
- **§ 3 S1 said "governing documents only; no command files."** Five command files were added — § 2.
- **§ 9 falsifier 1 assumed both predicates return empty.** They do not at BASE — § 5. Re-keyed to *no new breakage relative to BASE*.
- **§ 7 ordering** superseded by the G1 binding condition, as recorded in this unit's brief.

---

Status: complete

Marker appended 2026-07-29 during `/work-loop` Step 1 reconciliation, not at the time
the unit ran. The S1 work landed at commit ff000a4 and is unaltered by this append;
only this closure block was added. The unit was left unmarked when it finished, which
made it indefinitely resumable under `docs/work-loop.md` § Resume order.
