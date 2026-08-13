# Session Plan — 2026-08-02

## Intent
Run Claude's preparation half of Work Loop v2 Context Engineering S3 (Slice A): re-check the four premises in Codex's brief against the live repository, build the disposable red evaluation root outside the shared checkout with the answer key scrubbed, write the verbatim fresh-Codex red-evaluator prompt into the task-state file, and stop with `turn: operator` unchanged.

## Model
opus — match (active session model is opus). The hard part is deciding: judging whether a premise genuinely holds, deciding what counts as an answer key, and authoring a seeded prompt that must not leak the expected outcome. None of that is mechanical.

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/work-loop/context-engineering-implementation.md` — Codex's S3 brief; the task-state file this session writes the red prompt into
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-v0.2/context-engineering/trials/candidate/SKILL.md` — the candidate under test (read-only this session)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.agents/skills/work-loop-v2/SKILL.md` — the live skill, for the byte-identity comparison (never edited)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-v0.2/context-engineering/trials/ce-9-recovery-scenario.md` — S1's Harbourview scenario
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-v0.2/context-engineering/trials/fixtures/ce-9/` — the S1 fixture set
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-v0.2/context-engineering/trials/carriage-trial-record.md` — S2's record; the source of the premise-2 carriage limit
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-v0.2/context-engineering/context-engineering-implementation-plan-v0.1.md` — plan of record, §7 S3
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-v0.2/context-engineering-spec-v0.1.md` — governing spec (CE-1, CE-2, CE-3, CE-15, CE-17)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md` — the queued trial-isolation finding `f41ff8cd3073`

## Findings / Items to Address

1. **Premise 1 — candidate integrity.** Brief `:29-32`: `trials/candidate/` contains only `SKILL.md`; at preparation it is 116 lines and byte-identical to the live skill, SHA-256 `956c76f37230fb2a6b4d1605afecdcb4edd64a5828803464c29a0c9689720868`; it contains none of the named Slice A behaviour. Brief's own consequence: if the red run comes back green, the bootstrap is contaminated and S3 stops.
2. **Premise 2 — carriage licence is narrow.** Brief `:33-34`: S2 licenses carriage only when a fresh Codex task is *explicitly pointed at* the candidate file. Ordinary installed-skill discovery stays unproved until S8b. The red prompt must therefore name the candidate path explicitly and must not rely on discovery.
3. **Premise 3 — S1 instrument intact and live directory clean.** Brief `:35-36`: the Harbourview scenario and four fixtures exist under `trials/`, each fixture opens with the required `FIXTURE —` notice, and no Harbourview state exists in the live `logs/work-loop/` directory. Fixtures sit at `trials/fixtures/ce-9/`, one level deeper than the brief's wording implies.
4. **Premise 4 — evidence file absent.** Brief `:37-38`: `trials/slice-a-evidence.md` must not exist before S3 — it is an output of the completed trial, not an input.
5. **Queued finding `f41ff8cd3073`** (`logs/improvement-log.md`, 2026-08-02, medium-high): every Phase 2 trial run needs an isolated root *and* an answer-key scrub, and the implementation plan requires neither. S3 reproduces the S2 live-directory escape by default unless this session's setup supplies both. This is why the disposable root is a required output of the preparation stage rather than something the red run improvises.
6. **S2 precedent — two concrete failure modes to design against** (`trials/carriage-trial-record.md`, and last session's record): (a) the candidate faithfully copies the live skill's `logs/work-loop/` rule, so an un-isolated run writes fictional Harbourview state into the *live* directory with `turn: claude`, making a fictional task resolvable by the live command; (b) two runs sharing a root overwrite each other's state file before either is committed, destroying the control's evidence.
7. **S2 method lesson — absence checks need a positive control.** A case-insensitive `grep` for `CE-[0-9]+` false-positived on `slice-1`. Every "this string is not present" check in this session pairs with a control proving the same pattern form *can* match.

## Execution Sequence

1. **Verify premise 1.** `wc -l` the candidate (expect 116); `shasum -a 256` it and compare against the brief's literal hash; `diff` it against `.agents/skills/work-loop-v2/SKILL.md` (expect empty); `ls -A trials/candidate/` (expect `SKILL.md` alone). Then grep the candidate for the five Slice A behaviours, each absence check paired with a positive control on the same pattern form.
   *Verify:* all four mechanical checks pass and every Slice A grep returns zero while its control returns non-zero. Any mismatch → **stop** (contaminated bootstrap).
2. **Verify premise 2.** Read `trials/carriage-trial-record.md` and confirm the recorded carriage claim is scoped to explicit-file pointing, not discovery.
   *Verify:* the record's own wording is quoted into the session evidence, not paraphrased.
3. **Verify premise 3.** List `trials/fixtures/ce-9/`, confirm four fixtures, and confirm each opens with a `FIXTURE —` notice (head of file, not a whole-file grep). Then confirm `logs/work-loop/` holds no Harbourview state — grep with a positive control.
   *Verify:* fixture count is exactly four, four `FIXTURE —` openers found, zero Harbourview hits in the live directory with the control matching.
4. **Verify premise 4.** `test -e trials/slice-a-evidence.md` returns false.
   *Verify:* absent. If present → **stop** and return to Codex.
5. **Build the disposable red root** as a detached git worktree at a path outside the shared checkout (session scratchpad). Nothing about it may be shared with a later green root.
   *Verify:* the root resolves outside `ai-resources/`, and `git -C <root> rev-parse --show-toplevel` confirms it is its own tree.
6. **Scrub the answer key from the red root.** Remove or redact everything that states S3's expected outcome: the task-state file's S3 brief (including the five constructed failing cases and the four count targets), plan §7's S3 section, the S2 trial record, and any spec passage naming the expected result. Keep the candidate, the scenario and the fixtures intact.
   *Verify:* grep the scrubbed root for the answer-key strings (the five case names, the four count targets, `slice-a-evidence`) with a positive control per pattern; expect zero real hits. Record the control result alongside each zero.
7. **Write the red-evaluator prompt** into `logs/work-loop/context-engineering-implementation.md` — verbatim, carrying only the brief's fixed seeded request, the explicit candidate path, and the instruction to prepare but not execute the unit and not revise the candidate. No hints, no expected outcomes, no plan or spec excerpts. Leave `turn: operator`.
   *Verify:* re-read the written prompt and confirm it contains none of the five case names and none of the four count targets; `turn: operator` unchanged.
8. **Commit and hand back.** Stage only the two files in scope. Do not push.
   *Verify:* the commit contains exactly `logs/work-loop/context-engineering-implementation.md` and `logs/session-notes.md` (plus this plan file and the run manifest as session artifacts).

## Scope Alternatives

- **Minimum:** premises 1–4 verified and the red prompt written; the operator builds their own isolated root. Rejected — it hands the operator exactly the setup step that failed in S2, and finding `f41ff8cd3073` exists because that step is the one nobody was required to do.
- **Recommended (this plan):** premises verified, one scrubbed disposable red root built, red prompt written, handed back at `turn: operator`.
- **Maximum:** additionally pre-stage a second baseline root for the green run. Deliberately excluded — the green run is not licensed until a genuine red is preserved, and pre-staging it invites the two-roots-share-state failure the brief forbids.

## Autonomy Posture
Gated — the brief names its own halt conditions, and the session ends at an operator handoff rather than at a completed trial.

**Stop points:**
- Any of the four premises is false — stop, write nothing further, return the result to Codex.
- The candidate is not byte-identical to the live skill, or carries any Slice A behaviour — stop; treat the bootstrap as contaminated.
- `trials/slice-a-evidence.md` already exists — stop; it is an output, not an input.
- Terminal handoff: after the commit, stop. Running the red evaluator, revising the candidate, and the green run are all the operator's and Codex's, not this session's.

## Risk
No structural change classes apparent — re-size the review if scope changes. No hooks, permissions, CLAUDE.md, commands, agents or symlinks are touched; the live skill and executable core are explicitly out of scope. Environment-fit check does not apply (no executable or launcher is produced).

Two live risks are carried instead, both from S2's own evidence: (1) trial state escaping into the live `logs/work-loop/` directory, which step 5's isolation and step 6's scrub exist to prevent; and (2) an absence check returning a false pass, which the positive-control pairing in steps 1, 3, 6 and 7 exists to prevent. The reviewer for this unit is Codex, at the S3 observation handoff — not a Claude-side pass.
