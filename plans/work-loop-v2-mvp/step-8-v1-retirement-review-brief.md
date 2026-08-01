# Step 8 — risk-aware review brief: executing the Work Loop v1 retirement

**Date:** 2026-08-01
**Session:** S14-198
**Reviewer:** Codex, fresh context
**Frozen at:** `f0c2ec9`
**Authority:** `docs/qc-independence.md` § The rule, row 3 — one **risk-aware** Codex review *before*
implementation. `step-7-v1-retirement-decision.md:107-110` sized this and it has not run.

---

## 1. What you are reviewing

**Not the decision.** Option A — archive v1 immediately — was taken by the operator at pilot start
against Claude's recommendation of Option C. It is not reopened, and arguing it is out of scope.

**You are reviewing the plan to execute it**: the six ordered prerequisites in
`step-7-v1-retirement-decision.md` § 4, judged against the verified state below. The question is
whether that sequence is safe, complete and correctly ordered — and what it misses.

**Nothing has been executed.** No v1 artifact has been moved, edited or archived.

## 2. Verified state — premise check run 2026-08-01, S14-198

Per § 37 of the review rule, every load-bearing claim below was re-derived by execution before this
brief was written. Primitives recorded so you can re-run them.

| Claim | Primitive | Result |
|---|---|---|
| 64 unmerged commits across three branches | `git rev-list --count main..<branch>` ×3 | **HOLDS** — 37 + 25 + 2 = 64 |
| Three worktrees live, one `prunable` | `git worktree list` | **HOLDS** — `session/2026-07-29-work-loop` marked `prunable` |
| Four v1 artifacts, 990 lines total | `wc -l` ×4 | **HOLDS** — 260 / 360 / 251 / 119 |
| One live capability record | `find -name prime-runtime-delegation.md` | **HOLDS** — `projects/axcion-ai-system-owner/development/` |
| `capability-development` reachable only via `/work-loop` | `grep -n disable-model-invocation` | **HOLDS** — `SKILL.md:17`, and `:24`/`:436` state it in prose |
| Six documentation / routing consumers | `grep -rln "/work-loop"` | **HOLDS, with one addition** — see § 3 |

**One correction to the record, in Claude's own disfavour:** the § 3.3 consumer list is *not* the
complete set. `logs/innovation-registry.md:167` carries a registry row naming a worktree copy of v1's
command and is not listed. Low stakes, but the list is presented as exhaustive and is not.

**One false alarm withdrawn:** `docs/repo-architecture.md:113` matches `/work-loop` but refers to
`plans/work-loop-v2-mvp/` — a **v2** reference. It is not a v1 consumer and must not be "repaired".

## 3. The sharpest coupling, stated plainly

`docs/qc-independence.md` is the doctrine file workspace `CLAUDE.md` § Independent Review Rule points
at. Two of its lines break under Option A, and the record understates this as "wording orphaned":

- `:25` — *"For `/work-loop`-routed work, Codex is the independent review (`docs/work-loop.md`
  § Route → depth → stops)"*. That citation targets a file being archived. After the retirement, the
  workspace's governing review rule cites a document that is no longer live.
- `:27` — *"Route it through `/work-loop`, or brief Codex directly."* This instructs the reader to use
  a command that will not exist.

This is not a documentation tidy-up. It is the rule that decides whether every other change in the
repo gets reviewed, and Option A breaks its only two concrete routing statements.

## 4. The seven risk-aware dimensions

Answer each against the plan in § 4 of the retirement record.

1. **Usage cost** — the sequence front-loads dispositioning 64 commits across three worktrees. Is that
   the cheapest correct order, or does something cheaper de-risk it first?
2. **Permissions surface** — does any step require a settings, hook or `.git` change? The plan does not
   say. If it does, that is a second structural class inside the first.
3. **Blast radius** — beyond § 3.3 items 1–6 plus the registry row: what else breaks that neither the
   record nor this brief names? An explicit consumer inventory is in the payload (§ 2) so you are not
   re-deriving it; you are checking it for holes.
4. **Reversibility** — archiving is a move, not a delete, so `git revert` recovers the files. Does it
   recover the *reachability*? `capability-development` sets `disable-model-invocation: true` and is
   reachable by no other path — reverting the move does not obviously restore a working route.
5. **Hidden coupling** — the one live capability record (`prime-runtime-delegation`, `status:
   in-development`) and mission `lean-prime-2026-07`'s two open threads both run on v1 and hold state
   in this checkout *and* in two live worktrees. Is "close or migrate" (step 2) actually executable, or
   does it need its own decision first?
6. **Principle alignment** — the plan's step 3 asks the executing session to *decide the fate of the
   capability-development subsystem*. Is that a decision a review can clear in advance, or must it go
   to the operator before any archiving starts?
7. **Problem reality** — was the drift Decision 4 guards against **observed**, or inferred? Decision 4
   states two Work Loop systems must not drift indefinitely. Name the evidence of actual drift, or say
   there is none and that the decision rests on prospective risk.

## 5. What the pilot changed, and what it did not

The pilot exit decision (2026-08-01, S14-198) accepted the pilot **with a v0.2 rework** that keeps the
adversarial review and sheds most of the bookkeeping. Two consequences you should hold:

- **It does not touch this retirement.** Option A is independent of v2's shape.
- **It does raise a question the plan does not ask:** v0.2 will change the v2 command, skill and core.
  Does any step here assume the *current* v2 shape? If so, say which.

## 6. Verdict shape

One of: **proceed as written** / **proceed with named corrections** / **do not proceed — named
blocker**. Apply the materiality floor (`docs/materiality-bar.md`): a finding names a concrete
consequence. Preference observations are Notes, not Findings.

**Do not** propose a second review, re-open Option A, or design v0.2. This is one review of one plan.
