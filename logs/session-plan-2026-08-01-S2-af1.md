# Session Plan — 2026-08-01

## Intent
Prototype the Work Loop v2 transport seam — run one repository-based Codex/Claude round trip through a minimal state file, then record the seam's real behaviour and the minimal viable schema.

## Model
opus — match

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/README.md` — authority order; Document 4 is destination reference only
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/work-loop-v2-mvp-proposal-v0.4.md` — AUTHORITATIVE; § 3 settled decisions (esp. 6 and 10), § 6 standing rules
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/pocock-lifecycle-work-loop-mvp-v0.4.md` — § "Step 2" (lines 71–79): the question, the method, the done-when
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/step-1-codex-packaging-findings.md` — § 3 (transport), § 6 (open gaps), § 8 (what Step 2 inherits)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.agents/skills/work-loop/SKILL.md` — the one tracked repo-side Codex skill; shape reference
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.gitignore` — lines 74–77, the four-rule `.agents/` ladder
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/work-loop.md` — v1 runtime contract; read for contrast only, not to align to

## Findings / Items to Address
Premises inherited from Step 1, in the order of consequence that note assigned them. None is a decision; each is to be tested by execution.

1. **Can Codex commit at all?** — `git add --dry-run` and `git commit --dry-run` both failed with `Unable to create '.git/index.lock': Operation not permitted` in one Codex session on 2026-08-01. Unknown whether that is fixed runtime policy, a per-session profile, or clearable by escalation. Everything else in the round trip is downstream of this. Source: `step-1-codex-packaging-findings.md:88-94`, `:102-111`, `:177`, `:208`.
2. **Does a new skill in `.agents/skills/` reach Git?** — `.gitignore:74-77` is a four-rule ladder (`.agents/*`, `!.agents/skills/`, `.agents/skills/*`, `!.agents/skills/work-loop/`), because Git does not descend into an excluded directory. Strongly implies a new skill needs its own re-include line; confirm by execution, not by reading. Source: `step-1-codex-packaging-findings.md:30-39`, `:209`.
3. **Does explicit `$name` invocation behave reliably?** — the description budget is already over its documented cap. Optional depth. Source: `step-1-codex-packaging-findings.md:70-79`, `:210`.
4. **Does `codex exec` work as a non-interactive entry point?** — must use the ChatGPT.app binary path; the npm `codex` binary on this machine is macOS-blocked and fails silently. Optional depth. Source: `step-1-codex-packaging-findings.md:154-172`, `:211`.
5. **Transport redesign is out of bounds.** If premise 1 comes back "cannot commit", the shared working tree still allows a state-file exchange with neither side committing. Step 2 may *run* that fallback to learn whether it works; it may not *ratify* it as the seam's design — that is a Proposal-level call. Source: `step-1-codex-packaging-findings.md:111-113`; `README.md:9-18` authority order.

## Execution Sequence

1. **Verify premises against the live repository before acting** (Proposal § 6 universal safety rule; the Step 1 note's line citations are one day old but its *observations* were made in a different app session).
   *Verify:* `git check-ignore -v` on a hypothetical new path under `.agents/skills/` returns a matching rule; `git ls-files .agents/` lists only the `work-loop` skill. Both results recorded verbatim.

2. **Probe premise 2 — fully Claude-side, no Codex needed.** Create a throwaway skill folder under `.agents/skills/`, run `git check-ignore -v` against it, add a re-include line to `.gitignore`, re-run.
   *Verify:* `check-ignore` output flips from ignored to not-ignored **and** `git status --short` shows the file as untracked-visible. A positive control: confirm the pre-change state really was ignored, so the flip is attributable to the added rule. Revert the `.gitignore` line before the next step unless the round trip needs it.

3. **Design the minimal state file.** Smallest structure that carries one brief and one result. Start deliberately *below* the Proposal § 3 decision 10 content ceiling — that ceiling is a maximum, and the prototype is explicitly permitted to prove fields unnecessary.
   *Verify:* every field has a named consumer in a specific hop of step 5. A field with no consumer is struck before the round trip runs, not after.

4. **Probe premise 1 — operator-driven, Codex app.** Draft an exact, short instruction set for the operator to run inside Codex: attempt the Git writes against the state file and report output verbatim, including whether any escalation prompt appeared.
   *Verify:* verbatim output captured. Classify as fixed policy / per-session / clearable — or, if classifying would require attempting a prohibited mutation, name it as a still-open gap and stop that thread. Do not infer the classification from a single failure.

5. **Run the round trip once.** Codex writes the brief into the state file (committing if premise 1 allows); Claude reads it, writes a result, commits; Codex reads the result. If premise 1 blocks committing, run the shared-working-tree variant instead — to learn, not to ratify (see Finding 5).
   *Verify:* each hop's artifact is observed on disk **by the receiving side**, not asserted by the writing side. The loop closes once, end to end.

6. **Harvest the schema.** Record what the file genuinely needed, what it did not, and any friction discovered (commit behaviour, file-reading quirks, detection timing).
   *Verify:* every field is either evidenced as used by a real hop or struck with a reason.

7. **Write and commit `plans/work-loop-v2-mvp/step-2-transport-seam-conclusions.md`.** Every claim tagged by source — `[local]` / `[codex]` / `[operator]` — following the Step 1 note's own convention. Anything not established is named as a gap, not guessed.
   *Verify:* file exists on disk and is committed; no claim about Codex behaviour lacks a source tag; § "open gaps" is present even if short.

8. **Discard the prototype.** Delete the throwaway skill folder and state file; revert the `.gitignore` probe line.
   *Verify:* `git status --short` shows nothing beyond the conclusions note and ordinary session bookkeeping; `git check-ignore -v` returns to its step-1 behaviour.

## Scope Alternatives
- **Min** — steps 1, 2, 4, 5, 7, 8: premises 1 and 2 answered by execution, the round trip run in whatever mode actually works, conclusions note committed, prototype discarded. This alone satisfies the Playbook's done-when.
- **Recommended** — min plus steps 3 and 6 (deliberate minimal-schema design and harvest). This is what makes Step 3's executable core inherit a *learned* interface rather than an assumed one, which is the stated reason the Playbook wants the prototype built with a minimal file.
- **Max** — recommended plus premises 3 and 4 (explicit `$name` reliability, `codex exec` as non-interactive entry). Probe these opportunistically *during* the Codex hops already required by step 4/5; do not open separate Codex sessions for them. Drop without regret if context tightens.

## Autonomy Posture
Gated

**Stop points:**
- Before each hand-off requiring the operator to act inside the Codex app (steps 4 and 5). Claude cannot drive Codex; these are genuine hand-offs, and the instruction set goes to the operator complete rather than discovered mid-run.
- If answering premise 1 would require attempting a prohibited mutation or an escalation grant — record the gap and continue with the rest (mandate `stop_if`).
- If the Codex side cannot be driven at all from this machine — record as an operator-checkable gap; do **not** simulate Codex's half of the round trip (mandate `stop_if`).
- Before treating any fallback transport as the seam's design rather than as an observation (Finding 5).

## Risk
No durable structural change class lands: the only artifact this session keeps is one new note in `plans/`. Two shared-state surfaces are touched *temporarily* and must be reverted at step 8 — `.gitignore` (repo-wide tracking rules) and `.agents/skills/` (a throwaway skill folder, deleted at close). Named so the revert is verified rather than assumed; re-size the review if the prototype turns out to need a durable change.

Environment constraint carried from Step 1, relevant to the max scope only: the npm `codex` binary on this machine resolves to a macOS-blocked executable and fails silently; the ChatGPT.app path is the working entry point (`step-1-codex-packaging-findings.md:154-172`). Any `codex exec` probe that appears to "do nothing" should be checked against that before being read as a result.
