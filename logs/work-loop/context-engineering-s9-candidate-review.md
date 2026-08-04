---
task: context-engineering-s9-candidate-review
turn: codex
---

## Objective and approved scope

Run Session S9: one independent, fresh-context review of the complete live Context Engineering candidate
and its Work Loop v2 wiring, named by the exact Git commit examined. Produce a single frozen finding set
or accept the candidate as readable and internally sound; do not claim behavioural seam proof.

Scope: read-only review of `.agents/skills/work-loop-v2/SKILL.md`,
`plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`, and
`.claude/commands/work-loop-v2.md`, using the governing specification, approved implementation plan, and
named closed records below. The only repository content this unit may change is this state file.

Excluded: editing the candidate; correcting findings; reopening S8b; producing or substituting S8b's
missing behavioural evidence; starting S10, S11, S12, or Phase 4; changing plans, trials, runtime files,
or closed records; adoption assessment or claims; and unrelated cleanup.

## Lane and unit

Standard. Unit 1 — S9 fresh-context candidate review.

Named reason for the loop: the governing plan requires one independent review of the whole candidate,
and its findings must be bounded and assessed before they can control correction or progression.

## Brief

The Route 3 amendment is approved and now permits S9 despite the missing S8b proof. This session is the
plan's one serious fresh-context review of the capability plus wiring; its output can establish that the
candidate reads correctly, never that the seam works. S8b stays closed and adoption condition 4 stays
unmet throughout.

**Required outcome.** Have an independent reviewer with fresh context, who did not write the candidate,
review the three-file live candidate at one exact Git commit. The reviewer returns exactly one final set
of material findings, ordered by severity and supported by tight file/line evidence, or an explicit
acceptance with no material findings. Each finding must state the violated governing requirement or the
concrete failure it can cause; suggestions without material consequence stay out.

The review must cover the candidate as one system: role separation; durable-source orientation; the
engineered brief contract; Direct Work admission; false-premise refusal; state-file ceiling and transport
boundary; semantic authority and content-bound approval; relevance-gated discovery; attributed framing;
non-accretion; consistency among the three runtime files; and consistency with the approved Route 3
boundary. It must explicitly distinguish what a read-only review can establish from the absent behavioural
seam evidence it cannot establish.

**Authority and source dispositions.**

- Governing operator direction: “now let's do s9. Prepare claude.” It authorises this review unit only.
- Governing plan of record:
  `plans/work-loop-v2-v0.2/context-engineering/context-engineering-implementation-plan-v0.1.md`, reapproved
  2026-08-04 against `1283d998f9cfa085348e52db551279f05d535f06`. Its §7.2, S9, Phase 3 exit, and §12
  govern this unit. Route 3 permits progression but does not supply evidence or adoption authority.
- Governing specification:
  `plans/work-loop-v2-v0.2/context-engineering-spec-v0.1.md`, approved against
  `148689d42ee7817239219417a1b884b961660f86`.
- Authoritative current state:
  `logs/work-loop/context-engineering-plan-deviation.md` closes the amendment as accepted;
  `logs/work-loop/context-engineering-s8a-entrypoint-classification.md` records reading A and the
  classification with its operator-observation gap;
  `logs/work-loop/context-engineering-s8b-seam-proof.md` closes S8b unproved; and
  `logs/work-loop/context-engineering-implementation.md` records the live integration and hardening.
- Verified-history starting points, not current facts: integration commit
  `4f3d6ca20a56eebcbd2773adfb3c7bc37815f623` and hardening commit
  `daebb0c3e6cc8415120cba8cfb916856fb2557e3`. Claude must establish the exact current candidate commit and
  whether the three runtime files still match the candidate described by those records before review.
- Governing workflow: `.agents/skills/work-loop-v2/SKILL.md` and
  `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`. Claude owns repository verification and
  every commit; the independent reviewer owns the S9 review; Codex later makes the progression judgment.

**Verification claims Claude must check before commissioning the review.**

1. The implementation plan is currently approved against `1283d998f9cfa085348e52db551279f05d535f06`
   and §12 says S9 may now open under §7.2.
2. The complete live candidate review surface is exactly the three runtime files named in scope. If a
   fourth live file carries Context Engineering behaviour or wiring, stop and hand back with the searched
   surface and evidence rather than silently omitting it.
3. The three candidate files have a single exact current Git commit the reviewer can name, and none changes
   between the review's start and Claude's post-review staleness check.
4. S8b's closing record contains no behavioural seam proof and lists the causal post half, passing Direct
   Work check, and post-integration false-premise refusal as unmet.
5. The reviewer is fresh-context and independent of authorship of the candidate. If independence cannot be
   established, stop; do not let Claude review its own implementation and relabel that independent.

**Evidence required.** Record the independent reviewer's identity/independence basis, the exact Git commit
examined, the exact three-file surface, and the final frozen finding set or explicit acceptance. Claude's
observer check must independently confirm after the review that the named commit is the one examined and
the candidate did not change; if it changed, the review is stale and the unit stops. The result must state
that no runtime, plan, trial, or closed-record file changed and that the review does not establish S8b's
missing behaviour.

**Completion condition.** One independent review exists against the unchanged, exactly named candidate;
its material findings are final and ready for Codex to freeze for S10, or it accepts the candidate for
progression to Phase 4 under §7.2. S8b's debt and adoption condition 4 remain visibly unmet.

**Stop conditions.** Stop for Codex on a false premise, incomplete review surface, stale candidate, absent
reviewer independence, or evidence that cannot be produced. Stop for the operator if a finding is really
about accepting risk. Do not repair anything in S9.

## Latest material result

Inspected (2026-08-04):

- Claim (1): HOLDS — read `plans/work-loop-v2-v0.2/context-engineering/context-engineering-implementation-plan-v0.1.md`.
  The § Authority notice block reads `Current status: APPROVED as the plan of record — operator, 2026-08-04`
  with `Approved commit: 1283d998f9cfa085348e52db551279f05d535f06` (:24–25). §12 (:1466) reads
  "**S9 may now open**, under §7.2 and nothing else."
- Claim (2): HOLDS — searched the whole workspace by content, not filename, for `Context Engineering`,
  `engineered brief`, `CE-1`…`CE-17`, `semantic interface`, `relevance-gated`, `attributed framing`,
  `non-accretion`, `durable-source`, `work-loop-v2`, `wl2`. Surfaces searched: every `.claude/commands/`
  layer (workspace root, `ai-resources`, all 30+ projects), all 7 entries under `.agents/skills/`, all 86
  entries under `skills/`, all 38 files in `.claude/agents/` and 42 in `.codex/agents/`, all four
  `settings.json`/`settings.local.json` layers plus `~/.claude/settings.json`, all hook scripts in
  `.claude/hooks/` (18), workspace-root `.claude/hooks/` (6) and `.codex/hooks/` (18), all 53 files in
  `docs/`, and the always-loaded `CLAUDE.md`/`AGENTS.md` files. **No fourth live file carries Context
  Engineering behaviour or wiring.** The only non-`ai-resources` instances of the command —
  `projects/axcion-systems-builder/`, `projects/axcion-systems-builder-email-os/`,
  `projects/axcion-design-studio/` — were classified with `[ -L ]` and are **symlinks resolving to the
  canonical files**, not divergent copies. No hook or settings registration references work-loop-v2.
- Claim (3): HOLDS — `git rev-parse HEAD` returns `4f98cec122a23149406eaa19f8e737f6394973b9`, and
  `git status --porcelain` over the three files returns empty, so all three are clean at that commit.
  Their content last changed at `daebb0c` (SKILL.md, the command) and `4f3d6ca` (the core), so the
  candidate still matches the integration-and-hardening records the brief names as history. The
  no-change-during-review half was confirmed after the review — see Evidence below.
- Claim (4): HOLDS — read `logs/work-loop/context-engineering-s8b-seam-proof.md`. § Outcome states S8b
  "is closed without establishing the behavioural seam proof"; § Accepted limitations lists exactly the
  three owed checks — no byte-identical post half for the causal pre/post pair, no passing Direct Work
  bypass through the post-integration seam, no post-integration false-premise refusal with target hashes.
  Searched the file for any passage claiming seam proof; none present.
- Claim (5): HOLDS, with its basis recorded rather than asserted — see Evidence below.

Result: the one independent fresh-context review ran against the unchanged candidate at
`4f98cec122a23149406eaa19f8e737f6394973b9` and returned **four material findings, none critical** — it did
not accept the candidate outright. Findings 1 and 2 are high, 3 and 4 medium; all four sit in the
producer/consumer seam between the three runtime files, and all are read-level defects correctable by
editing text. The reviewer explicitly cleared the Route 3 boundary: no passage in any of the three files
describes the seam as behaviourally proved, and none implies adoption is available. No runtime, plan, trial
or closed-record file changed in this unit — the only repository content this unit touched is this state
file.

**The final finding set, ready for Codex to freeze:**

1. **[high] The closing record has two contradictory authors, and no wired Claude path commits it.**
   `SKILL.md:119`/`:140` instruct Codex to write the closing record itself and then tell the operator that
   Claude must commit it; core `:83` assigns it the other way — "Codex closes, **Claude writes and commits
   the closing record**". The skill's own rule (`SKILL.md:10`) makes core-vs-skill disagreement a defect.
   Failure it causes: follow the skill and the operator invokes the only wired Claude entrypoint, which
   refuses at `work-loop-v2.md:40` ("If `turn:` is not `claude`, stop … Change nothing") — the closed file
   is never committed and the harness's terminal check fails
   (`logs/scripts/work-loop-v2-slice-1.test.sh:151-152`). Follow the core instead and the command has no
   step that writes a closing record on Codex's close verdict; its only closing-record path is
   *De-escalating* (`work-loop-v2.md:80-87`), which is Claude's own initiative, not Codex's close. Either
   reading leaves the unit cycle without a wired terminal step. A correction must settle which party
   authors the closing record and give Claude a path that reaches the commit without tripping the `turn:`
   guard.
2. **[high] The command asserts a brief shape the producer never adopts and the core's own example
   contradicts.** `work-loop-v2.md:46` says an engineered brief marks claims where it states them "rather
   than collecting them under a single `Check against the repository:` sub-heading"; the core's worked
   example uses exactly that sub-heading (`core:210`); `SKILL.md:52`/`:77` require claims to name surface
   and pattern but say nothing about placement, so Codex is told neither shape. Failure it causes: the
   acceptance harness binds check 1.1 to the literal line
   (`work-loop-v2-slice-1.test.sh:129-130`, `grep -qiE '^check against the repository'`), so a brief in the
   shape the command describes fails an instrument both candidate files cite as binding over themselves
   (`SKILL.md:119`, `work-loop-v2.md:48`). The reviewer stated honestly that spec §7 (`:875`) rejects
   harness dependency as a constraint on the specification, so the governing defect is the internal one —
   the core is the single owner of the contract (`core:5-7`) and its example and the command now describe
   two different brief shapes; the harness failure is the observable consequence. A correction must state
   where the engineered brief places its claims, once, in the owning file.
3. **[medium] The active-field heading strings are load-bearing for the consumer but never pinned for the
   producer.** Codex writes the state file (`SKILL.md:19`) and is pointed only at core §4 for its shape
   (`SKILL.md:55`); four of the five names in core's normative field table (`core:169-173`) differ from the
   strings the command hard-binds to — `## Objective and scope` (`work-loop-v2.md:76`), `## Latest result`
   (`:48`), `## Blocker` (`:66`), `## Next action` (`:42`,`:102`,`:106`) — which appear in the core only
   inside `### Example` (`core:192-222`). Failure it causes: a file written from the normative table gives
   the command no `## Blocker` to replace `None.` in and no `## Objective and scope` to scope Step 4
   against; the harness's three active-field loops fail (`work-loop-v2-slice-1.test.sh:147`, `:291`,
   `:520`). The asymmetry marks it an omission: the skill pins the *closing*-record strings exactly and
   calls them its output contract (`SKILL.md:119-138`) and pins `## Next action` for corrections (`:113`).
   A correction must make one set of active-field heading strings normative in the file that owns the
   contract.
4. **[medium] The discovery brief is a permitted producer output with no consumer path.** `SKILL.md:61`
   requires each pass to end with one execution brief, **one discovery brief** or one genuine escalation,
   and `:63` requires Codex to prefer a discovery unit over refusing or guessing; spec §4.1 (`:342`) makes
   it a permitted output and CE-3 (`:586-589`) makes it required for a load-bearing unknown resolvable by
   inspection. Failure it causes: the consumer recognises only the execution shape — core §3 step 4
   (`:79-80`) reads "checks the brief's claims first …, then implements", the command's Step 4 is headed
   "If every claim holds, **implement the unit**" (`work-loop-v2.md:74`), and Step 2's record shape assumes
   a claim set a discovery brief may not carry. A discovery unit therefore reaches a step sequence whose
   only forward move is to implement, reintroducing at the consumer end the guess CE-3 exists to prevent.
   Medium rather than high because the mitigation exists in per-brief stop conditions rather than in the
   consumer contract. A correction must state what Claude does when the completion condition is *return
   evidence and hand back* rather than *implement*.

Evidence:

- **Reviewer identity and independence basis.** A single dispatched fresh-context subagent
  (`general-purpose`, model pinned to `opus` per the workspace per-dispatch pinning rule), holding no
  conversation history and no authorship of any of the three candidate files. It was briefed only with the
  three-file surface, the governing specification, the plan's §7.2 and S9, and the four closed records; it
  was **told** the seam is unproved and which three checks are owed, rather than left to infer the gap.
  One review, not a chain. **The limit of this basis, stated rather than glossed:** independence here is
  fresh context plus non-authorship, not a different vendor — the candidate's authoring lineage and the
  reviewer are the same model family. Claim (5)'s specific prohibition — Claude reviewing its own
  implementation in the authoring context and relabelling that independent — did not occur. Claude's role
  in this unit was observer only, as plan §7's S9 row assigns; Claude formed no view on the candidate.
- **Exact commit examined:** `4f98cec122a23149406eaa19f8e737f6394973b9`. The reviewer re-derived it with
  `git rev-parse HEAD` and named it in its output, alongside the three blob hashes.
- **Exact three-file surface:** `.agents/skills/work-loop-v2/SKILL.md` (blob `372eb9a8`),
  `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` (blob `08398f6e`),
  `.claude/commands/work-loop-v2.md` (blob `30182ff1`).
- **Observer staleness check — the check that could have failed, and what it returned.** Run after the
  review closed: `git rev-parse HEAD` returned `4f98cec1…` unchanged; the three blob hashes re-derived to
  `372eb9a8` / `08398f6e` / `30182ff1`, byte-identical to the pre-review values recorded above; and
  `git status --porcelain` over the three returned empty. Had any of the four values differed, the review
  would be stale against a new candidate and this unit would stop instead of reporting. They did not.
- **Nothing else changed.** `git status --porcelain` over the whole repository shows only this state file
  (untracked before this commit) and `logs/friction-log.md`, which the write-logging hook modifies
  continuously and which is not staged. No runtime, plan, trial or closed-record file was touched.
- **What this does not establish.** The review does not establish S8b's missing behavioural seam evidence
  and cannot: it read the files and reasoned about them without ever invoking the seam. The three owed
  checks — causal post half, passing Direct Work check, post-integration false-premise refusal — remain
  unmet. This output says the candidate *reads* correctly, never that the seam *works*, and it is
  **non-adoption evidence** while Phase 6 adoption condition 4 stays unmet.

Deferrals noticed during this unit, recorded and not done (core §5; all outside this unit's scope):

- **The command's empty-argument resolution is now ambiguous and will stay ambiguous.** Two files under
  `logs/work-loop/` carry `turn: claude`: this task, and the permanent acceptance fixture
  `fixture-slice2-foreign.md` (whose `task:` is deliberately `fixture-slice2-other`). Command Step 1 says
  to list them and ask when more than one qualifies, so every future argument-free invocation asks. The
  fixture corpus poisons the default path by construction. Resolved here in favour of the live task, and
  disclosed rather than absorbed.
- **`.agents/skills/wl2-probe/SKILL.md` is live dead scaffolding** — 95 bytes, description "Throwaway Step
  2 transport probe. Delete me.", body "Probe body." Surfaced by the claim-2 absence search. Carries no
  Context Engineering behaviour, so it does not affect claim 2.
- **A mission-thread premise is now false.** `logs/missions/work-loop-v2-mvp.md`'s installation thread
  states that `axcion-design-studio` "holds a *copy* of the command with no core". Its
  `.claude/commands` is a symlink to `ai-resources/.claude/commands`, so it resolves to the canonical
  file. The thread's stated reopening trigger rests on a premise that no longer holds.

## Next action

Codex: assess this unit. The review is complete against the unchanged candidate at
`4f98cec122a23149406eaa19f8e737f6394973b9`, and the four findings above are final and ready to be frozen
for S10 under core §3 *Correcting once*. Note that S10 would touch runtime files, so the owed S8b checks
would then be owed against the changed candidate. Adoption condition 4 stays unmet either way.
