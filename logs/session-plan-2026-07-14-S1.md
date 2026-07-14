# Session Plan — 2026-07-14 S1

## Intent

Land the stranded `session/2026-07-13-research-workflow` branch into `main` and remove its worktree — closing the accepted one-sided marker-mutex gap at its root rather than papering over it — then give the repaired orphan lens an invocation path by folding it into `/architecture-review` and wiring that command into `/friday-checkup`'s quarterly tier. Correct one stale audit row on the way out.

## Model

**opus** — matches the active session model. Justified: the merge conflict resolution is a judgment task over append-only logs where a mechanical resolution is actively wrong (main archived entries the branch still carries), and M-1 is a design fold, not a copy-paste.

## Source Material

- `logs/session-notes.md` § 2026-07-13 S13 — Next Steps (items 1, 2, 4).
- `logs/scratchpads/2026-07-13-S13-marker-allocator-mutex-scratchpad.md` § Accepted Gap, § Resume With.
- `docs/session-marker.md` § Known gap — the one-sided mutex, logged loudly on operator instruction.
- `audits/lean-repo-2026-07-13.md` — M-1 (line 77), R-3 (line 69), the RR-04 row (line 124), the strict-order note (line 260).
- `logs/decisions.md` Decision 4 (2026-07-13) — the HOLD on M-1 → R-3 and its stated precondition.
- `logs/improvement-log.md` 682–683 — the Q3 lens defect and its **applied** fix (S12).
- `git diff --stat main...session/2026-07-13-research-workflow` — the mechanically-derived file list (18 files).

## Findings / Items to Address

### Item 1 — The stranded branch (menu #1)

The S13 framing — *"rebase or close"* — under-describes the object. Verified state:

- Branch is **unpushed** (no upstream, no remote ref). No shared-state hazard; no force-push question.
- Branch is **13 behind / 8 ahead** of `main`. Working tree **clean**.
- The 8 commits carry **real canonical work**, not session detritus: `.claude/commands/deploy-workflow.md` (+176 lines), `skills/claim-permission-gate/SKILL.md`, `skills/country-parity-checker/SKILL.md`, `workflows/research-workflow/SETUP.md` (+62), an audit, three fix-plans, and `logs/missions/research-workflow-deploy-fitness.md` (199 L, **`status: active`**).
- **Consequence nobody has stated:** that mission is `status: active` and lives **only on the branch**. `/prime` Step 1d scans `main`, so the mission is **invisible from every normal session**. The branch is not merely stale — it is hiding an active mission contract.
- **"Close" would have destroyed all of the above.** The menu item as written was a live footgun.
- The reason this matters for the mutex: that worktree runs a **real, non-symlink** `prime.md` on a branch predating the allocator fix (`sha=a0a24de11d16` vs canonical `31fe5952510d`). It is the **only divergent copy** in the workspace. Landing the branch and removing the worktree eliminates the divergent copy — the gap closes structurally, not by convention.

**Hazard (the real one):** `logs/session-notes.md` shows **390 changed / 246 deleted** lines across the merge base. That is because `main` **archived** July entries (S7, → `logs/session-notes-archive-2026-07.md`) while the branch did not. A naive conflict resolution can therefore (a) **resurrect archived entries** into the live log, or (b) **drop the branch's S10/S11/S13 entries**. Same shape for `logs/decisions.md` and `logs/improvement-log.md` — both append-only, both written by both sides. These files must be resolved **by union of content, verified per-hunk**, never by `--ours`/`--theirs` wholesale.

**Duplicate-marker artefact, expected:** both sides carry a `## 2026-07-13 — Session S13` header (the exact collision the mutex now prevents). The merge will surface it. Resolution: keep both, disambiguate the branch's as `S13-rw` or renumber — do **not** silently drop one. Decide at the point of conflict with both bodies on screen.

### Item 2 — M-1: the orphan lens has no way to fire (menu #3)

- **The precondition is now satisfied.** M-1 was held (`decisions.md` Decision 4, 2026-07-13) on exactly one ground: it would fold `/lean-repo`'s Q3 orphan lens into `/architecture-review` while **that lens was defective** — the lens that produced a confident, operator-approved instruction to delete six commands, four of them in live use. `improvement-log.md` records the Q3 fix as **applied and verified (S12)**, by planted known-positive. The hold's stated reason is discharged. Nothing else was ever holding M-1.
- **The defect M-1 fixes:** `grep -i "orphan|Q3|zero reference|unwired" .claude/commands/architecture-review.md` → **zero hits**. `/architecture-review` has no orphan/adoption lens at all. Meanwhile `/lean-repo` — which owns the lens — is itself an orphan with **no invocation path** (`audits/lean-repo-2026-07-13.md` line 198: *"both orphans, neither wired to any cadence. The lens has no way to fire."*).
- So the lens is currently **correct and unreachable**. M-1 is the wiring half: fold the three questions into `/architecture-review`, and wire `/architecture-review` into `/friday-checkup`'s quarterly tier so it fires without anyone remembering it.
- **Carry the corrected lens, not the original.** The Q3 that lands must be the S12 version: it must emit `no evidence of use in scanned scope → CONFIRM BEFORE DELETE` (never `orphan → Remove`), must be dispositioned **Investigate** and structurally barred from **Remove**, must **state its scanned scope** in the report, must grep `projects/*/logs/` + `projects/*/CLAUDE.md` (not just `ai-resources/`), and must run the `/explore-section` **known-positive instrument check** — reporting `Q3 VOID` and withholding all orphan findings if the instrument fails it. A fold that drops any of these re-arms the original defect inside the surviving component. This is the single highest-risk detail in the session.
- **R-3 stays out of scope.** Retiring `/lean-repo` is an open operator decision (three sessions running). M-1 landing is precisely what makes R-3 *safe* to decide later; it does not decide it.

### Item 3 — The stale RR-04 row (menu #5)

`audits/lean-repo-2026-07-13.md` line 124 (RT-2) reads *"Retain until the worktree pilot validates a replacement"* and cites the RR-04 trigger. The pilot **ran and closed** in S4 (`5fce38c` — "marker teardown harness-enforced; RR-04 piloted and closed"). The row describes a future that already happened. Low-stakes bookkeeping, but it is a live audit document a future session will read cold and act on.

## Execution Sequence

### Stage 1 — Item 1: land the branch, close the gap

1. Pre-merge safety net: tag the current `main` (`git tag pre-merge-rw-2026-07-14`) so the merge is trivially revertible without touching reflog.
2. Record ground truth **before** merging: capture `git show session/...:logs/session-notes.md | grep -c '^## '`, the same for `decisions.md` / `improvement-log.md`, and the branch's 8 commit subjects. These are the *falsification targets* for step 5 — establish them before the merge can influence them.
3. `git merge session/2026-07-13-research-workflow` into `main`. Expect conflicts in `session-notes.md`, `decisions.md`, `improvement-log.md`.
4. Resolve conflicts **by union, per hunk, with both bodies on screen**. Rules: archived entries stay archived (do not resurrect `main`'s S7-archived content into the live log); every branch entry survives somewhere; the duplicate `S13` header is disambiguated, not dropped.
5. **Verify, do not assert** (this session's standing lesson): re-run the step-2 counts against the merged tree and prove every one of the 8 commits' content is present. Confirm `logs/missions/research-workflow-deploy-fitness.md` now exists on `main` and still reads `status: active`.
6. Remove the worktree (`git worktree remove`), then delete the merged branch.
7. **Prove the gap is closed by execution, not by argument:** enumerate every `prime.md` in the workspace, hash the allocator block in each, and confirm no divergent copy remains (canonical `31fe5952510d`; the stale one was `a0a24de11d16`). This is the mutex becoming two-sided, and it is an *observable* claim — treat it as one.
8. Commit.

### Stage 2 — Item 2: M-1

1. Read the **corrected** Q3 from `.claude/commands/lean-repo.md` + `.claude/agents/lean-repo-auditor.md` in full — the fold must carry the post-S12 text, including every guard listed in Findings above.
2. Fold the three leanness questions into `.claude/commands/architecture-review.md` as a section, preserving Q3's CONFIRM-BEFORE-DELETE verdict, its Investigate-only disposition, its scanned-scope declaration, and its known-positive instrument check.
3. Wire `/architecture-review` into `/friday-checkup`'s quarterly tier so the lens has an invocation path.
4. Verify the fold **against the defect, not against the diff**: re-run the S12 known-positive on the folded lens — `/explore-section` must come back as *used* (109 hits across 17 files), not as an orphan. If the folded lens reports it as an orphan, the fold is wrong and Stage 2 halts. A green read-through of my own edit is explicitly **not** evidence here.
5. Commit.

### Stage 3 — Item 3: RR-04

1. Correct the RT-2 / RR-04 row in `audits/lean-repo-2026-07-13.md` to state its real closed status, citing `5fce38c`.
2. Commit.

### Stage 4 — Close

Between-gate summary at each stage boundary. `/qc-pass` on the M-1 fold (the one substantive artifact). Report; do not auto-wrap.

## Scope Alternatives

- **Narrower (drop Stage 2):** land the branch, fix RR-04, stop. Leaves the repaired lens unreachable — the exact state the last three sessions kept deferring. Rejected: M-1's blocker is discharged and the fold is the cheapest it will ever be.
- **Narrower still (Stage 1 only):** defensible if the merge conflicts prove nastier than expected. Stage 1 is independently valuable and Stages 2–3 are independent of it. **This is the fallback if context gets constrained** — flag and defer, do not rush.
- **Wider (add R-3):** retire `/lean-repo` in the same session. Rejected: it is an open operator decision, not a defect, and bundling a decision into a fix session is how a decision gets made by accident.

## Autonomy Posture

**Gated.** Structural change classes present: canonical command + skill merge, new automation wiring (`/friday-checkup` → `/architecture-review`), cross-cutting edits. Plan-time `/risk-check` runs before Stage 1. Operator approved the scope at the auto-mode gate. Commits land directly per workspace rules; **push is batched to wrap** (11 commits already unpushed).

## Risk

- **Highest — a merge resolution that silently drops content.** Both sides wrote to the same append-only logs and `main` archived entries the branch still carries. Mitigation: ground-truth counts captured *before* the merge (Stage 1 step 2), verified *after* (step 5). The falsification target exists before the thing it tests.
- **Highest-consequence — M-1 folding the *pre-S12* lens.** Would re-arm, inside the surviving component, the defect that nearly deleted six live commands. Mitigation: fold from the live corrected file, then re-run the known-positive (Stage 2 step 4). The instrument is checked before its output is trusted.
- **The failure mode this repo keeps hitting:** stating a repo fact from recall instead of looking (2-for-2 in the last two sessions; both caught by the harness, not by me). Every claim in this plan's Findings was established by a command, and every verification step above is an execution, not a read-through. **A green harness in the wrong environment is indistinguishable from no harness at all** — S13's lesson, and it applies directly to Stage 2 step 4.
- **Reversibility:** high. Branch unpushed, `main` tagged pre-merge, nothing pushed until wrap.
