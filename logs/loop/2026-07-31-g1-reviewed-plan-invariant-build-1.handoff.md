UNIT: 2026-07-31-g1-reviewed-plan-invariant-build-1   STREAM: 2026-07-31-g1-reviewed-plan-invariant   PHASE: build → prove
REPO: ai-resources                                    BASE: 6050a5b83f976583154f79ecfd5335691ba3d156    NEXT: fresh Codex reviewer, then a Claude Prove unit

# Build handoff — Slice 1 implemented, ready for Prove

Governing authority: `docs/work-loop-repair-workflow.md` (§§6, 7, 14).
Written at pre-handoff HEAD `a8256df72e9430d37f8d50f77ccb55debcadeaec`. **A file cannot contain its own
commit SHA — the commit containing this handoff is the tip of this branch and is reported in the
session reply.**

---

## 1. Repair handoff envelope (§6.2)

```text
REPAIR: work-loop
SLICE: Slice 1 — G1 reviewed-plan integrity
UNIT: 2026-07-31-g1-reviewed-plan-invariant-build-1
STREAM: 2026-07-31-g1-reviewed-plan-invariant
REPO: ai-resources
WORKTREE: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-g1-reviewed-plan
BRANCH: codex/2026-07-31-g1-reviewed-plan-invariant
BASE: 6050a5b83f976583154f79ecfd5335691ba3d156
HEAD: pre-handoff a8256df72e9430d37f8d50f77ccb55debcadeaec; the commit containing this handoff is the branch tip
OBJECT: the S1 implementation candidate — commit 8762fc7fc413d1149eb3dec531d235bc368d1108, four files, blobs in §3
ROLE: Claude writer — releasing ownership (§9)
NEXT: a fresh Codex task reviews the actual worktree and the complete base-to-HEAD diff against this candidate identity; a Claude Prove unit then transcribes that review, adjudicates, and presents G2
```

## 2. State

**Last completed transition:** **Build complete.** The exact G1-approved package is implemented —
plan-v4 §7's single atomic slice, four files, ordered steps 1–4 with step 4 last. Evidence written,
all twenty acceptance criteria measured, every fixture run with positive controls.

**Not done:** the **Prove** unit is not opened — no brief, no evidence, no review. **G2 has not been
reached and no gate has passed since G1.** Build carries no review of its own by construction
(`.claude/commands/work-loop.md` § Build units), so the implementation has had **no independent
review yet**. That is the next thing that must happen.

**The G1-approved plan was never mutated.** Verified at pre-handoff HEAD:
`git rev-parse HEAD:{plan-v4}` → `9ae4839afc8ccb23c4bd50a2644f32213273ed90`, equal to the approved
identity at commit `df45a2b1…`. Review-2 likewise still resolves to `848ee9f9…` at `12b22dd9…`.
**G1 remains valid.**

**Worktree is clean** — `git status --porcelain` empty. Nothing staged, nothing untracked.

## 3. Candidate identity — what Prove must review

| Field | Value |
|---|---|
| Approved base | `6050a5b83f976583154f79ecfd5335691ba3d156` |
| **S1 implementation commit** | `8762fc7fc413d1149eb3dec531d235bc368d1108` |
| Candidate HEAD (pre-handoff) | `a8256df72e9430d37f8d50f77ccb55debcadeaec` |

**The four objects under repair, at HEAD** — these blobs are the candidate:

| Path | Blob at approved base | Blob at candidate HEAD |
|---|---|---|
| `docs/work-loop.md` | `88f555e630a4ae898d0eb6d1827d908faf1bf81a` | `8a7ba07ff0a40473ad8fbf4d7e93d676adaa84a2` |
| `.agents/skills/work-loop/SKILL.md` | `33986fb80e15fd26600a619793cef37e79c5650a` | `bc8e4931178586f79b53aa5ca03cd9203636db64` |
| `.claude/commands/work-loop.md` | `0e575aa5dab40a07927bd6cc3cf9af07940401f0` | `877a664511697495881c103a863227380f66d848` |
| `templates/capability-record.md` | `f0580c9e98f45232d83d1cf6d707b39c9e186acf` | `f9ac9d4d5e838a194cdf78734e9a5cd61440975a` |

**Artifact identities produced by this unit:**

| Artifact | Path | Commit | Blob |
|---|---|---|---|
| Build brief | `…-build-1.brief.md` | `b73f75a322d8207c4f7e66396170df253993ab88` | `ddcb0dae6c08fa83c3895cb894c15539986d3052` |
| **Build evidence** | `…-build-1.evidence.md` | `a8256df72e9430d37f8d50f77ccb55debcadeaec` | `8d890430d7e4a3a3291bc760c6b04fbfa05ffc7d` |

The Shape unit's identities are unchanged and carried forward from `…-shape.handoff-2.md` §3.

## 4. Commits produced by this session

Three, in order:

| Commit | What |
|---|---|
| `b73f75a3` | Build unit opened — brief only, no object edit |
| **`8762fc7f`** | **S1 — the implementation. Four files, one atomic commit** |
| `a8256df7` | Build evidence — A1–A20 and every fixture |

Every commit staged by explicit pathspec. No `git add -A`, no `git add .`. No push — pushes are gated
and batched to session wrap.

**Complete `base..HEAD` file set:** the four objects under repair · `docs/work-loop-repair-workflow.md`
· this stream's thirteen `logs/loop/` artifacts. **Nothing else. The diff is bounded to the approved
slice.**

## 5. Verification run, and what was observed

Full detail is in the Build evidence (blob `8d890430…`). Summary:

| Check | Result |
|---|---|
| A1–A20 | **All twenty PASS**, each with the command or inspection and the observation recorded |
| V-M1 (historical failure blocks) | `4e97dc9b…` vs `ca274137…` → differ → blocks |
| V-M2 (positive control) | equal → passes — the check is not blocking everything |
| V-M5 a/b/c | truncated SHA · cross path/blob · dropped field → all block |
| V-R1 (positive control) | binding relation holds → `eb827a67…` |
| V-R2, V-R3 | wrong blob and 7-hex commit → both block |
| V-H1–V-H4 | receipt-before-request ordering, four recorded fields, resume rule, M8/M9 traceable |
| V-C1–V-C3 | five close steps present · exception scoped to `hold-reframe` with ordinary carry surviving · template one line, `:7` byte-unchanged |
| A18 | zero matches, with the regex proven live against `d44a4fc:docs/work-loop.md:102` |
| A20 / F12 | working tree showed exactly the four `M` entries before commit; nothing outside scope |
| Falsifiers F1–F12 | none fired |

**Method note carried forward.** Both zsh hazards recorded in this stream were respected throughout:
every parameter followed by `:` was brace-delimited (`"${RCOMMIT}:${RPATH}"`), and multiple paths were
passed as explicit literals rather than through one variable. Every zero result was re-run against a
corpus that must match. **This is now written into the command itself** at `.claude/commands/work-loop.md:147`,
so it is no longer only a session convention.

## 6. Open findings and correction budget

**Open material findings: none.** Build ran no review — by design, it holds none.

**Deferred by this unit, recorded not implemented:**

- **BF-1** — `.agents/skills/work-loop/SKILL.md:98` cites `/qc-pass`, retired 2026-07-30. Outside the
  approved step list. Reopens on any slice touching the skill's fallback text, or a retired-command sweep.
- **BF-2** — the Prove path at `.claude/commands/work-loop.md:178` still hard-codes `review-1.md`.
  Plan-v4 §6.12 named `:131` only. Reopens at Slice 3, or when a Prove unit needs `review-2`.

**Carried forward from Shape, still deferred:** **OF-1** (post-G1 package mutation in the 2026-07-29
stream) → Slice 3 or its own · **OF-3** (review named at `logs/decisions.md:11` with no artifact) →
Slice 5/6. **OF-2** closed by the implementation.

**Correction budget:**

| Item | Status |
|---|---|
| Shape unit's budget | Fully spent in that unit — review-1, one correction pass, review-2. Untouched here |
| Build unit's reviews | **None exist** — Build holds no review and no gate |
| Prove unit's budget | **Fresh and unused** — Prove opens a new unit with its own initial review, at most one correction and at most one closure `review-2` |

## 7. Known limitations

- **The implementation has had no independent review.** Build holds none; Prove's is the first. Nothing
  here should be read as reviewed work.
- **These are documentation and instruction changes.** Every check was text inspection, git identity
  arithmetic on real historical blobs, or diff bounds. **None demonstrates that a future session obeys
  the instruction** — that is behavioural.
- **M8, M9 and M10 were traced through the written steps but not executed.** A mismatched re-emission,
  a post-restart re-offer and a capability `hold-reframe` continuation cannot be staged before the
  slice exists; they belong to Stage 9 (Use), as plan-v4 §11.6 declared.
- **Plan-v4 §13's boundaries all hold unchanged**: the RV2-01 content-level residual is implemented as
  approved and not narrowed; no validator was introduced; the §6.10 allocation exception is stated, not
  enforced; `hold-reframe` is Shape-side only; `unassessed` survives for reviewed-route work and Prove.
- **Two rendering judgments are declared** in the evidence §6 — the blocker handoff specified by
  required content rather than by citing the temporary repair workflow, and a one-clause pointer added
  at Step 7's fallback so A7 does not rest on reading order. Either can be overturned at Prove.
- **Line numbers** cited in the evidence are as of the S1 commit `8762fc7f…`.

**Worktree is expected clean** at handoff, with nothing staged and nothing untracked.

## 8. Ownership release

> Effective when the commit containing this handoff is created and the worktree is verified clean, I
> release sole-writer ownership of this repair worktree. No other Claude session may write before
> verifying this release and explicitly acquiring ownership.

## 9. Next action

1. **A fresh Codex task reviews the candidate** — the actual worktree and the **complete base-to-HEAD
   diff**, not a summary (`…repair-workflow.md` §5.4, §11). It must state the exact candidate identity
   it inspected: base, HEAD, the four blobs, and the evidence identity. Its object is the implementation
   plus `…-build-1.evidence.md`, judged **against plan-v4's falsification criteria F1–F12 and its
   acceptance criteria A1–A20** — not against whether the work reads well.
2. **A new Claude session opens the Prove unit**, verifies this envelope against Git, explicitly
   acquires ownership, transcribes the returned review verbatim to `…-prove.review-1.md`, computes and
   verifies its review identity, and adjudicates every material finding.
3. **G2 — the operator decides release.** Before it opens, verify per §11: HEAD equals the reviewed
   HEAD · base equals the approved base · worktree clean · diff bounded · evidence and review artifacts
   match their declared identities. **Any target-object commit after the review invalidates it.**

**Do not** mutate plan-v4, re-open G1, implement anything further under this slice, touch a path
outside the four files plus this stream's `logs/loop/` artifacts, invoke `/work-loop` or its skill to
govern this repair, switch branches, pull, merge, rebase, or import another stream's artifacts.
A discovery that materially invalidates the candidate is a **stop and report**, never a quiet fix.

LIMITATIONS: This handoff records state, identity and authority — not an independent judgment of the
implementation, which does not exist yet. Every identity in it was verified against Git in this
worktree at pre-handoff HEAD `a8256df7`; none rests on an asserted value. The containing commit's own
SHA cannot appear here.
