# Decision Journal

> Archive: [decisions-archive-2026-07.md](decisions-archive-2026-07.md)

## 2026-07-29 — Review-layer consolidation: one independent review per change, sized to consequence

**Need.** Four layers of reviewers stacked automatically on Claude's work — the `QC → Triage` auto-loop, two prompting hooks, embedded reviewer stacks in eleven commands, and layer-4 guidance restating all of it — on top of the Codex review `/work-loop` already provides. Stream `2026-07-29-review-layer-consolidation`, challenged route, G1-approved package `logs/loop/…-shape.plan-v3.md`.

**Decision — the rule is now three rows** (`docs/qc-independence.md` § The rule): small or mechanical changes get deterministic verification and no model review; normal consequential changes get one Codex review; high-consequence or destructive changes get one **risk-aware** Codex review before implementation, then the deterministic execution-time safeguards, which are never removed. A second review happens only when a material finding forced a redesign — never on a pass counter, never on a wish for more assurance.

**`/risk-check` reversed from KEEP to de-automated.** Plan v2 kept it, arguing it was a structural gate rather than a stacked reviewer and citing `docs/work-loop.md:65`. That argument was **circular** — the cited line is an in-repo policy this stream may edit, not an external constraint — and Codex review-2 was right to reject it. Its seven dimensions moved into the Codex review brief. Nine reachable automatic firings removed; the command survives, operator-invoked only.

**Deletion deferred on consumer grounds, explicitly not on Prime grounds.** `/qc-pass` 26 consumers, `/risk-check` 26, `/refinement-deep` 26, `/resolve` 26 — counts re-derived with a parent-symlink-aware `find -L`, because `projects/axcion-design-studio/.claude/commands` is a **whole-directory symlink** and an ordinary `find` under-counts every command by exactly one. Deleting any canonical target breaks every command in that project at once. Migration needed first; none of the four is deleted here. Eight project copies are real separate files (inode-verified, not `diff`), six already diverged — canonical edits reach none of them. `projects/positioning-research` wires its own copies of the deleted nudge hooks.

**Transition safeguard honoured, not waived.** The legacy end-time `/risk-check` ran once, on the executed S1 diff, before the S1 commit, with the unexecuted S2–S4 package explicitly excluded from its scope (operator's binding G1 condition). Verdict **RECONSIDER**; all findings resolved before commit — six dangling references the S1 deletions had orphaned, plus transitional caveats so neither governing doc asserts a repo-wide invariant the later slices had not yet delivered. The reviewer confirmed the S1→S2 ordering and warned against inverting it. The plan-time gate was not run and not silently skipped: two full Codex plan reviews had served its stated purpose on this exact design.

**Sequenced follow-up — the end state is NOT reached yet.** (1) **Prime-owned files**, excluded by this stream's brief: `prime.md:816` still fires the plan-time gate, `prime.md:168,171,173,174,322` still carry QC-PENDING detection (now inert — nothing writes the marker), `session-plan.md:157,159,211` still emits the two-gate pointer. (2) **Workspace root**, a different repo: `CLAUDE.md:57` (unconditional QC mandate + QC-PENDING commit-block), `:61`, `:65,69` (contract-check triggers keyed on rounds that can no longer occur), `:121` (Autonomy pause trigger #9), `:129` (auto-loop pointer). Until (2) lands, behavior in workspace-rooted sessions does not change.

**Found, not caused, and still open.** Seven broken command symlinks under `projects/` predate this stream: `projects/project-planning/.claude/commands/{route-change.md, audit-critical-resources.md}` point at canonical targets that no longer exist, and five more sit under the untracked `projects/strategic-os/.backup-untracked/`. Two commands silently fail to resolve in a live project. Out of this stream's scope; worth a dedicated fix.

**Decided by:** the operator, at G1, 2026-07-29 — approved with one binding ordering correction, no slice cut. Codex reviewed the plan twice; all eight material findings across both rounds were accepted, none rejected. This is a decision-log entry in an existing log — **not a registry, layer or gate.**

## 2026-07-29 — Stream `2026-07-29-review-layer-consolidation`: bookkeeping recovered retrospectively; brief-first ordering was NOT originally satisfied

**What was found.** A `/work-loop` Step 1 reconciliation hit the last row of `docs/work-loop.md` § Reconciliation: two artifacts existed that no resume tier could reach. `logs/loop/…-build-3.evidence.md` and `…-build-4.evidence.md` had no corresponding `.brief.md` — absent from the working tree **and** from all git history (`git log --all --oneline -- <both paths>` → empty; positive control: the same query against `…-build-2.brief.md` returns e410328). Both units had been run with brief and evidence deliberately combined into one file, on the stated reasoning that a separate brief was ceremony. Separately, none of the four Build evidence files carried `Status: complete`, and the Shape unit had written no evidence file at all — so every unit in the stream was permanently *incomplete* under § Resume order while its work had in fact landed.

**Why it mattered.** § Resume order globs briefs and every row of § Reconciliation keys on a brief or a pointer to one. A unit with no brief is invisible to both, however well documented it is. The stream's edits were committed and sound; the stream itself was unresumable — a bare `/work-loop` would hit the same stop forever, and Prove could never be opened.

**What was done, under operator authorization.** Retrospective recovery briefs written for Build-3 and Build-4, with scope transcribed from the G1-approved `…-shape.plan-v3.md` § 3 — the approved slice definitions — and **not** back-derived from what the evidence reports was done. `Status: complete` appended to Builds 1–4. A retrospective closure record written for Shape. No historical implementation evidence was rewritten; every append is a marked closure block that names the commit the work landed at.

**The ordering requirement was not satisfied and is not claimed to have been.** Each recovery brief opens with a notice saying so in terms. This entry is the durable record that the repair was retrospective — the contract's own remedy for a unit whose artifacts would otherwise misrepresent their own history.

**Two gaps recorded rather than closed.** (1) **`…-shape.review-2.md` was never transcribed** and does not exist in git, though a second Codex plan review demonstrably occurred — `plan-v3` § 0 adjudicates R2-F1/F2/F4 and this log's preceding entry states both rounds happened. It is **not** reconstructed: § Artifacts makes review files immutable Codex-authored transcriptions, and a Claude-written substitute would be a fabricated independent review. Prove reads plan-v3 § 0 in its place. (2) **plan-v3 § 3 S4 lists eight guidance files including `docs/weekly-cadence.md`; Build-4's evidence reports seven and does not list it.** Whether it needed no change or was missed is left to Prove, which is the unit that judges the result against Shape's criteria.

**Beyond the enumerated repair list:** the Shape closure record was not in the operator's list (recovery briefs for Builds 3–4; `Status: complete` on Builds 1–4). It was added because the instruction to continue the stream is unreachable without it — an unmarked Shape unit makes the stream resume at Shape, a phase § Resume order forbids re-running. Flagged for reversal if unwanted.

**Process finding, open.** The combined brief-and-evidence shortcut was taken twice in one stream and nothing warned either time. Whether `/work-loop` should detect a missing brief at unit open, rather than only at the next invocation's reconciliation, is a question for the command's own maintenance — out of this stream's brief.

**Decided by:** the operator, 2026-07-29, on a reconciliation stop that Claude reported and did not act on unilaterally.

## 2026-07-29 — /work-loop 2026-07-29-review-layer-consolidation: close (G2 approved)

**Need.** Replace the stacked automatic review layer — a general Claude review, a risk-reviewer subagent and specialist QC passes firing by default on every change — with one independent review per change, sized to its consequence.

**Outcome.** `close` — the operator approved the G2 release gate on 2026-07-29 with all four remaining items explicitly deferred and no further review round. Delivered across four Build slices: the governing review/risk policy rewritten (`docs/qc-independence.md` is the keystone; § The rule is what everything now points at), two prompting hooks deleted, eleven commands, one agent, two skills and nine governing/guidance documents realigned. `/qc-pass` and `/risk-check` **survive as operator-invoked commands** — only their automatic firings were removed; any later claim that this repo "no longer uses `/risk-check`" is false.

**Prove found what four Build sweeps had declared clear.** Twenty-four live references to removed machinery survived into the Prove unit — five caught by the protected-safeguard pass (§ 6 of the Prove evidence) and nineteen more by adjudicating Codex review-1 (§ 9). Two were materially broken producer/consumer contracts: `friday-act.md:272` emitted a plan-file field no consumer read, so a high-consequence item would have silently skipped its review; `incident-log-template.md:19` required a `/risk-check` verdict its only producer no longer emits. `lean-repo.md:118` still prescribed "each gated by `/risk-check` plan-time + end-time" — the exact double gate the stream existed to remove.

**Method rule this produces — a reference sweep must be keyed on the concept, not the token.** Build-1's miss was *directory scope* (`docs/ skills/` with no `.claude/`) and was fixed. Every later miss was *pattern scope*: the sweeps searched for command-shaped references (`/qc-pass`, `/risk-check`) and were structurally blind to the same concept appearing as a **field name** in a schema, a **step name** in prose, a **verdict token**, a **hook filename** in a JSON example, and whole **procedure sentences**. A grep tuned to one shape of reference proves nothing about the others. The check that actually worked was structural: enumerate every `§` pointer into the changed docs and validate each against the real heading list, and diff each protected file rather than searching it.

**Second-order finding: four consecutive units each declared the sweep complete, and each was wrong.** The failure was not insufficient care — it was that a self-authored sweep tends to re-run the query that already passed. This is why Prove and an external review both earned their keep here, and it is the strongest evidence in the stream for keeping *one* real review rather than none.

**Deferred by operator decision at G2 — four items, none resolved.**
1. `prime.md` (`:816`, `:168–174`, `:322`) and `session-plan.md` (`:157,159,211`) — excluded prime-owned files: the plan-time gate, the two-gate pointer, and the one surviving invalid section pointer (`§ Subagent-unavailable fallback`).
2. Workspace-root `CLAUDE.md` (`:57, 61, 65, 69, 121, 129`) — the unconditional QC mandate. **Until this lands, workspace-rooted session behaviour is unchanged.**
3. `projects/positioning-research` — still actively wires both deleted nudge hooks and carries local copies, so the retired layer still fires there. Outside repo scope; an operator decision.
4. **Highest priority.** `.claude/commands/work-loop.md:105` — still instructs two stacked `/risk-check` gates *in addition to* the challenged route's single Codex review, and cites `docs/audit-discipline.md:73-81`, a line range S1 deleted. Both the mandate and the dangling citation need repair. Must land *after* this self-referential stream closed. **Until it does, the command running this loop contradicts the policy the loop just shipped.**

**Limitations carried out of the stream, not resolved.** (a) This unit repaired what it reviewed — twenty-four sites changed by the session judging them, with no independent read of the repairs; G2 knowingly adjudicated self-verified work. (b) plan-v3 § 8's consumer-counting scope could not be reproduced — three attempts under different exclusion sets gave three different totals, none matching. Falsifier 2 was closed structurally instead (content-only edits, no file added or deleted under any `commands/` path, no symlink changed), and **the original counting scope remains undocumented**. (c) Falsifiers 1 and 4 fired literally and are carried as disclosed exceptions, not clean passes. (d) The Prove unit's brief was retrospective, so the unit was never bounded by a scope agreed before it started.

**Transition gate.** The legacy end-time `/risk-check` ran once in Build-1 under the G1 ordering condition and returned RECONSIDER. It was not re-run. Recorded as an **explicit operator adjudication**, superseding Build-1's record of the same disposition as Claude's own stated non-waiver — an agent declining to re-run its own gate and an operator adjudicating it discharged are different acts, and only the second happened.

**Concurrent-session note.** A second session worked this stream in the same worktree (`85a4bcc`, `ddfe7a4`, `315e0ae`, `89222f2` — retrospective brief recovery, review transcription, and an independent cross-session re-verification that found nothing changing the G2 package). Its dirty `logs/friction-log.md` and `logs/innovation-registry.md` were left untouched by this session on operator instruction. Related defect observed: `check-foreign-staging.sh` reads its footprint from the session marker `/session-start` writes, so a session resumed via `/handoff` has none and the foreign-staging guard degrades to warn-only — precisely when a concurrent session is live. Staged paths were verified by hand on every commit here instead. Not fixed; needs its own unit.

**Artifacts.** `logs/loop/2026-07-29-review-layer-consolidation-*` (Frame brief + evidence; Shape brief, plan, plan-v2, plan-v3, review-1, evidence; Build 1–4 briefs + evidence; Prove brief, evidence, review-1), deleted in this closing commit; recoverable at `b8ef77f`. Stream commits: `b8ba264` → `b8ef77f`; object edits in `ff000a4`, `e410328`, `c1b4435`, `8840672`, `8c24043`, `e24ba61`.

**Decided by:** the operator, at G2, 2026-07-29. Claude executed the close. The four deferrals are the operator's call, not a Claude judgement that the work is finished.

## 2026-07-30 — Resolve a blocked worktree merge by fixing forward, not by bypassing guards

**Context.** `/close-worktree-session` landing `session/2026-07-29-2` hit two sequential guard trips: uncommitted worktree changes, then a real merge conflict in `logs/friction-log.md` and `logs/improvement-log.md`. The operator's instruction was "just merge this I don't care what you have to do just do it don't ask me anything."

**Decision.** Read the instruction as authorizing the *outcome* (land the branch, stop asking questions), not as authorizing content loss or bypassing safety mechanisms. Concretely: committed the worktree's dirty files instead of discarding them; resolved the merge conflict by combining both sides (both were pure appends, no in-place edits) instead of picking one; when the resulting merge tripped `check-append-order`, fixed the actual ordering defect (relocated two misplaced blocks to file end) instead of `git commit --no-verify`.

**Rationale.** `/close-worktree-session`'s hard rule — "never auto-resolve a merge conflict, stop and hand back control" — exists because of a real prior incident (2026-07-17, conflict markers landed in this same `friction-log.md`). The operator's instruction removed the *ask-first* step, not the *do-it-safely* obligation; "don't care what you have to do" was read as "don't stop me with more questions," not as "it's fine if content is lost." Verified the safe path was actually safe before treating it as complete: both conflict-marker checks (working tree and `HEAD`) ran clean after resolution, and the append-order fix was verified against the file's actual header ordering, not assumed.

**Alternatives considered.** (a) Stop and ask despite the instruction — rejected: the operator had already answered this exact question once, and repeating it would be the "ask again after being told not to" failure this repo's Decision-Point Posture rule exists to prevent. (b) Pick one side of each conflict (e.g., `git checkout --theirs`) — rejected: would silently drop the other side's log entries, which is content loss the instruction did not ask for. (c) `git commit --no-verify` past the append-order hook — rejected: the hook had found a real defect (entries genuinely out of the required order), not a false positive; suppressing it would ship the defect instead of fixing it, and this repo's rule against skipping hooks without explicit request still applied — the operator authorized the merge, not a specific hook bypass.

**Decided by:** the operator's repeated instruction authorized proceeding without further questions; the specific mechanism (commit-then-merge, combine-don't-pick, fix-the-order-not-the-hook) was Claude's judgment call within that authorization.

## 2026-07-30 — Retire /qc-pass, /risk-check, /resolve and /refinement-deep; Codex is the second opinion

**Context.** The 2026-07-29 review-layer consolidation already made Codex the independent reviewer in policy (`docs/qc-independence.md`) and retired the mandatory post-edit QC pass, the plan-QC requirement, the QC→Triage auto-loop and the QC-PENDING commit-block. It explicitly deferred the cross-project migration: `/qc-pass`, `/resolve` and `/refinement-deep` carried "retirement deferred — 26 projects link to them, one through a whole-directory symlink." The operator's instruction this session: "officially exclude mandatory qc pass and risk check as we are using codex second opinion from here on now. Retire these commands."

**Decision.** Deleted the commands and their agents outright, and completed the migration the prior entry deferred. Retired: `/qc-pass`, `/risk-check`, `/resolve`, `/refinement-deep`, the `qc-reviewer` and `risk-check-reviewer` agents, their `.codex/agents/*.toml` twins, all ~180 project symlinks, three forked real `qc-pass.md` copies (research-workflow template, axcion-sector-intelligence, positioning-research), and the two `.codex` auto-nudge hooks (`auto-qc-nudge.sh`, `auto-resolve-nudge.sh`) with their `hooks.json` wiring — the latter was still live-firing on every Write/Edit in the Codex mirror, nudging toward a command being deleted.

**Scope chosen by the operator** at two decision points: (a) blast radius — retire the QC-loop machinery (`/resolve`, `/refinement-deep`) alongside the two named commands, rather than only the two or keeping `/qc-pass` as a fallback; (b) sweep depth — fix everything that executes or instructs (commands, agents, hooks, settings, CLAUDE.md, docs, skills, templates, workflow templates), leave `logs/`, `audits/`, `plans/` and `reports/` untouched as historical record.

**What replaced them.** Nothing new was built. A structural change class no longer fires anything — it makes a change high-consequence, which is carried inside review *sizing* (`qc-independence.md` § The rule): mechanical → deterministic verification only; consequential → one Codex review; high-consequence → one risk-aware Codex review. The seven risk dimensions survive as the risk-aware review brief. The Codex-unreachable fallback is now inline self-review recorded `unassessed`, never `/qc-pass`.

**Functional breaks found and fixed** (each would have failed at runtime, not merely read stale): `/prime` 8c.11 actively invoked `/risk-check`; `/new-project` scaffolded symlinks to `qc-pass`/`resolve` into every new project; `/friday-journal` Step 5.5 and `/cleanup-worktree` Step 6 spawned the deleted `qc-reviewer` agent (both repointed — the former to a tier-pinned `general-purpose` dispatch with the 6-dimension rubric inlined, the latter likewise); the research-workflow `shared-manifest.json` declared `qc-pass`, `refinement-deep` and `qc-reviewer` as shared resources to deploy, and two of its commands spawned `qc-reviewer` (repointed to the workflow's own local `qc-gate` agent).

**Also renamed:** `audit-discipline.md` § "Risk-check change classes" → § "Structural change classes", with all pointers updated. Workspace `CLAUDE.md` § "QC Independence Rule" → § "Independent Review Rule"; the "QC → Triage Auto-Loop" section was deleted; autonomy pause-trigger #9 reframed from a command call to a consequence test, keeping the list at ten and realigning `CLAUDE.md` with `docs/autonomy-rules.md`.

**Alternatives considered.** (a) Deprecation stubs instead of deletion — rejected: the operator said retire, and the prior entry's deferral had already left two commands sitting as documented-but-dead for a day; git history is the recovery path. (b) Keeping `/qc-pass` as the named Codex-unreachable fallback (`qc-independence.md` explicitly named it as such) — the operator considered and declined this option; inline self-review is the fallback now. (c) Rewriting logs and audit reports too — rejected: it would falsify the record that explains why these gates existed.

**Recovery.** All deleted files are in git history immediately prior to this commit.

**Decided by:** the operator, on both scope questions. Claude executed the migration and chose the per-file replacement wording.

## 2026-07-30 — `/prime` Step 3 retired; finding promotion moves to a wrap-time owner

**Context.** `/prime` Step 3 was the only channel by which a severity-tagged finding reached the task
menu. It re-grepped `friction-log.md` and `improvement-log.md` at **every** orientation, in every
project, to re-derive a set that only changes when a finding is *written*. Before it was bounded on
2026-07-13 a full read of the pair cost ~50–60k tokens per session — the most expensive recurring leak
this harness has had — and even bounded it stayed the largest read in the orientation path.

**Decision.** Retire Step 3. `logs/scripts/promote-findings.sh` now sweeps the same entries once, at
wrap (`/wrap-session` Step 6.6, core path, no flag), and appends each not-already-queued finding to
`logs/next-up.md`. `/prime` Step 2 already read that queue; it is now the single channel. Promotion is
a write, orientation is a read — separating them is the whole point.

**The `medium-high` menu-reach contract moved with the scan, unchanged.** `prime.md:194` required that
narrowing that tier be done together with the two writer-side files plus a `logs/decisions.md` record.
This entry discharges the record half for the *relocation*; the tier itself is **not** narrowed —
`high` / `medium-high` / `critical` / `urgent` all still promote. The lockstep requirement now names
`promote-findings.sh` (`wrap-session.md` Step 12e, `session-feedback-collector.md`, and
`logs/improvement-log.md` § Schema repointed in the same commit).

**Identity lives in the destination, never in the source.** A content-derived id (`sha1` of source path
+ entry header, 12 hex) is written on the `next-up.md` line. The rejected alternative — stamping
`<!-- promoted -->` into the source entry — is forbidden by `docs/commit-discipline.md` § Maintenance-
owned in-place mutations, which confines in-place mutation of these two logs to dedicated sessions and
names a command that flips a status as a side-effect of ordinary work as exactly the drift it guards
against. `/wrap-session` is an ordinary work session, so that design would have been the rule's first
violation. Concurrency is handled by a `mkdir logs/.promote.lock` mutex; each sweep also de-duplicates
the queue by id, so a git union of two checkouts self-heals.

**Two accepted reductions, both deliberate, neither claimed away.**
1. **Backward-looking.** Findings from a session that never wraps are promoted by the next wrap *in
   that repository*; if none ever occurs there, they are never promoted. Step 3 re-grepped at every
   orientation, which is more frequent. *Rejected alternative:* also call the sweep from `/prime` — it
   puts a write back into the orientation path this stream exists to make read-only. **Trigger to
   adopt it anyway:** any finding observed unpromoted for more than one week.
2. **`friction-log.md` contributes nothing today.** It has no severity field, so Step 3 fell back to a
   keyword grep whose hits its own text called "candidates to judge, not findings" — a session could
   discard the incidental matches in context. A script cannot. Measured at retirement: that grep
   returned 3 hits and **all 3 were prose**. The sweep therefore applies the same severity-field test
   to both logs; the friction path is live code matching zero entries, not a stub. Consequence stated
   plainly: an un-tagged friction entry now reaches no queue at all. Closing that needs a severity
   field in the friction-log schema, not a looser regex.

**Menu tiering preserved.** With one queue feeding both tiers, `/prime` Step 5 tags a `next-up.md` item
carrying a `<!-- promote:… -->` id as `[urgent]` and everything else as `[next-up]`, keeping the
four-tier rank. Without that split a promoted `high` finding would have ranked below ordinary carryover.

**First production sweep:** 29 findings promoted from `improvement-log.md`, 0 from `friction-log.md`,
both source logs byte-identical afterwards (`shasum` before/after). Verified by
`logs/scripts/promote-findings.test.sh` — 35 assertions, 0 failed.

**Decided by:** Claude, executing the G1-approved plan `logs/loop/2026-07-30-prime-session-entry-
ownership-shape.plan-v3.md` § 1 S3. The two reductions above were approved at G1; the friction-log
finding is new evidence from this slice and is recorded here rather than silently absorbed.

## 2026-07-31 — work-loop repair Slice 1: operator scope binding for A20/F12 (Option A)

**Context.** Slice 1's approved plan (plan-v4) defined acceptance criterion A20 / falsifier F12 as: the
`BASE..HEAD` diff must touch only the four G1-approved target files plus the stream's own `logs/loop/`
artifacts. Codex's Prove `review-1` found this criterion failing — `docs/work-loop-repair-workflow.md`
sits in the diff and is outside that set. Traced in the worktree
(`ai-resources-g1-reviewed-plan`): the repair-workflow doc was introduced at commit `17ad3aa4…`, the
**second commit of the entire repair program**, before Frame, before Shape, before plan-v1 existed. It
was therefore already present — and A20 already unsatisfiable as literally written — at the point
`review-1` and `review-2` inspected plan-v4 and at the point G1 was approved. Neither review nor G1
caught it.

**Decision.** The operator approved **Option A**: a narrow, Slice-1-only scope binding recognizing
`docs/work-loop-repair-workflow.md`, at its exact existing blob `37c6be795568dd6942dc3883bb067ff03b0a5007`
(unmodified since `17ad3aa4…`), as pre-Shape repair-program governance rather than an S1 implementation
target. The binding does not authorize modifying that document, does not add it to the implementation
slice, does not widen the four-file scope, does not change the approved base `6050a5b8…`, does not
mutate plan-v4 or its identity, and creates no general exception for any other file, stream or slice.
Recorded verbatim in the Prove evidence's Entry 3 and CLOSE block, verified against Git before being
relied on.

**Rationale.** The property A20/F12 actually protect — no unapproved object changed — was independently
verifiable as satisfied: the S1 implementation commit (`8762fc7f…`) touched exactly the four approved
files, and the repair-workflow doc's blob was unchanged throughout. The binding states a fact already
true rather than editing anything; plan-v4's blob stays `9ae4839a…`, so G1 remains valid without
reopening it.

**Alternatives considered.**
- **Option B — accept A20/F12 as failed and stop** (`hold-reframe` the stream). Truthful and available,
  but disproportionate: it would halt a sound, correctly-scoped implementation over a criterion that was
  unsatisfiable from the moment it was authored, for reasons unrelated to what was actually built.
- **Option C — move the approved base past `17ad3aa4…`.** Rejected as strictly worse: `BASE:` is a
  binding field printed verbatim in every artifact of the stream (Frame brief, all four plan revisions,
  both Shape reviews, all evidence, both handoffs), and plan-v4 §11.5 uses `6050a5b8…` as a literal
  verification command argument. Moving it would make every existing artifact's stated base stale and
  contradict the approved plan's own verification text.

**Named risk, not hidden.** This is a post-G1 clarification of an approved criterion's reading, which is
adjacent to a separately-tracked open finding (OF-1: a 2026-07-29 package mutated after G1 in a
different stream). It differs in kind — nothing here is edited, and the decision is explicit, attributed
and recorded, the opposite of a silent mutation — but the adjacency was surfaced to the operator before
approval rather than glossed over.

## 2026-08-01 — Work Loop v2 MVP project folder placed in `plans/`, not `docs/`

**Context.** Step 0 of the Work Loop v2 MVP build (a new, separate multi-session project — not the
Work Loop v1 repair program above) required committing four governing documents plus an authority
README into a new project folder. This was a new top-level project folder in a genuinely ambiguous
layer, so `/placement` ran first per the workspace placement-discipline rule.

**Decision.** Placed the folder at `ai-resources/plans/work-loop-v2-mvp/`, following `/placement`'s
recommendation. Also added a canonical-home row to `docs/repo-architecture.md` for "multi-document
build project" in the same commit, since the map's existing plan-artifact row only described a flat
file, not a folder.

**Rationale.** `docs/` already hosts the *live v1* Work Loop runtime contract (`work-loop.md`,
`work-loop-spec.md`, consulted every `/work-loop` invocation). One of the four v2 documents is an
explicit destination-reference-only spec describing the full future system, including capabilities
(Consequential lane, worktree isolation, an independent-reviewer role, automation) that are explicitly
out of MVP scope. Placing that document beside the v1 runtime contract in `docs/` would create the
exact authority confusion its own README was written to prevent — a future session opening `docs/`
would find v1's current contract and v2's destination description sitting as apparent peers.
`plans/` already holds precedent for this project (`plans/2026-07-28-work-loop-consolidated-build-plan.md`)
and its plan artifacts are understood to go stale at ship time, at which point the surviving runtime
contract graduates to `docs/` — matching how this build is meant to end.

**Alternatives considered.**
- **Option B — `ai-resources/docs/work-loop-v2-mvp/`.** Defensible on the folder-shaped precedent of
  `docs/emailos-mvp-learning/` and `docs/ai-resource-development-playbook/`, both multi-doc project
  folders already living under `docs/`. Rejected for now: those folders are read by commands/operators
  as ongoing reference; this folder governs a one-time construction and is expected to be superseded
  by its own output. Revisit at ship time if the surviving core belongs in `docs/` anyway.

## 2026-08-01 — Work Loop v2 MVP Step 2: fallback transport run to learn, NOT adopted as the design

**Context.** Step 2's throwaway round-trip prototype reproduced Step 1's finding that Codex cannot
write `.git` in this environment (`Unable to create '.git/index.lock': Operation not permitted`),
now observed in two independent Codex sessions. The Proposal's stated transport is: Codex writes a
state file and commits it; Claude reads, writes a result, commits; Codex reads the result. With
Codex's commit blocked, the round trip as specified could not run unmodified.

**Decision.** Ran the round trip anyway, using the repository's shared working tree as the transport
for Codex's hop (Codex writes the file; Claude commits it) instead of stopping the session. Recorded
this in the conclusions note as an **observation** — "the round trip's real transport was the shared
filesystem, and the commit was a durability layer on top of it" — explicitly **not** as a proposed
redesign of the Proposal's transport.

**Rationale.** The Playbook's own Step 2 text permits exactly this: "the seam still has options that
do not require redesigning anything — the working tree is shared, so a state file can be exchanged
without either side committing it — but choosing among them is a Proposal-level matter and is not
decided in this note." The session's mandate `stop_if` only required recording the gap if Codex
could not be driven at all — it could be, just not for the `.git` write specifically — so continuing
to test the actual question (does *some* round trip work cleanly?) stayed inside the mandate. Also
established Codex's block is not fixed policy: it is a sandbox restriction on the Codex process
(proven by positive control — Claude ran Codex's identical failing `git add` and it succeeded), and
the Codex binary documents configurable levers (`--sandbox`, `--ask-for-approval`, `--add-dir`) that
`~/.codex/config.toml` currently leaves unset. So the *permanent* transport question is still open,
not foreclosed by this session's workaround.

**Alternatives considered.**
- **Stop the session at the block and escalate to the operator immediately.** Rejected: the mandate
  explicitly scoped this as a throwaway prototype meant to answer "does the round trip work
  cleanly," and stopping at the first obstacle would have delivered nothing for that question while
  the fallback path was already named as permitted in the governing Playbook text.
- **Treat the fallback as the new design and update the Proposal.** Rejected: per `README.md`'s
  authority order, the Proposal is authoritative and a transport redesign is explicitly out of this
  session's scope (`stop_if` / `Out of scope` on the mandate). Left as an operator decision, to be
  made with the additional evidence this session produced (positive control, documented sandbox
  levers, the "workspace-write doesn't fix it" dead end already ruled out).

## 2026-08-01 — Claude commits the Work Loop v2 state file (amends the Proposal)

**Context.** Work Loop v2 MVP Step 3 wrote the executable core. The Proposal's destination
behaviour 1 states that Codex "writes a bounded brief into a task-state file in the repository and
commits it." Step 2's transport prototype established by execution — two independent Codex sessions,
plus a positive control in which Claude ran the identical failing command successfully — that Codex
can write ordinary repository files but is refused write access to `.git`. In the observed round
trip Claude made the only commit and the shared working tree carried the hand-off. Step 3 flagged
this as Proposal-level rather than deciding it.

**Decision (operator).** Codex writes the brief into the state file; **Claude makes every commit.**

**Rationale.** It is what reality demonstrated rather than what the plan assumed. Nothing in the
design depends on the alternative — the file is exchanged through the repository either way — and
the `turn` field already enforces one writer at a time. Leaving it open would invite a future
session to relitigate it from the Proposal's superseded wording.

**Alternatives considered.**
- **Change the Codex sandbox setting so it can commit.** Rejected for now: Step 2 established that
  `workspace-write` was already active and `.git` was still blocked, so the only proven lever is
  `danger-full-access`, which removes the fence for everything rather than for Git. That is a
  decision about the operator's own machine, not a build decision.
- **Leave it open until Step 5.** Rejected: Step 5 implements the round trip and would have to
  invent an answer under implementation pressure.

**Recording mechanism.** The Proposal itself is NOT edited — planning is closed and the workspace
convention is to version rather than overwrite. The amendment is recorded in
`plans/work-loop-v2-mvp/README.md` § "Decisions taken after v0.4" and in the executable core § 4, so
a session reading the Proposal alone is pointed at the superseding decision.

**⚠ Known unresolved consequence.** The mission's validation contract, acceptance assertion 1, still
reads "Codex … commits it". That contract is frozen at mission creation and was not edited. As it
stands the mission cannot satisfy its own definition of done. Surfaced to the operator; not decided.

## 2026-08-01 — The adopted QC process is scoped to the Work Loop v2 build, not workspace-wide

**Context.** The operator asked to save a QC process (recommended by Fable, extended with their own
requirement that the reviewer check against the ORIGINAL project files) as a standing instruction for
checking Claude's own work. Read workspace-wide, that instruction conflicts head-on with workspace
`CLAUDE.md` § Independent Review Rule: "Codex is the reviewer — no Claude QC pass runs in addition to
it", plus an explicit instruction that recommendations to restore a mandatory Claude-side QC gate
"must be rejected."

**Decision (operator, from three offered scopes).** Keep it scoped to the Work Loop v2 MVP build.
`CLAUDE.md` is unchanged and Codex remains the reviewer everywhere else.

**Rationale.** Inside this build the conflict does not arise: the Proposal authorises targeted
per-slice review (`:87`) and one candidate review (Decision 2, `:36`), so a subagent QC pass is a way
of running a review the build's own governance already provides for. Fable's own opening line is
"don't invent a new QC layer," which is the same instinct the `CLAUDE.md` rule protects. Widening it
would have reversed a rule the operator wrote deliberately on 2026-07-30.

**Alternatives considered.**
- **Amend `CLAUDE.md` to permit Claude-side subagent QC workspace-wide.** Rejected by the operator.
- **Apply only the method rules workspace-wide** (three dimensions, original-files reference point,
  freeze-and-fix-once, reviewer-never-fixes) while keeping Codex as the sole reviewer. Offered and
  not taken; remains available if the narrow scope proves useful.

**Written up at** `plans/work-loop-v2-mvp/qc-process-v0.1.md`, with a paste-ready subagent brief.

## 2026-08-01 — Declined an external review finding on verified-premise grounds

**Context.** An external review (Fable) of the executable core raised three findings. Finding A —
the substantive one — held that the core had dropped "genuine uncertainty about the problem or
solution" from the Proposal's named admission reasons, and recommended restoring it.

**Decision (Claude, endorsed by the operator).** Declined. Findings B and C were reported as already
fixed rather than re-fixed.

**Rationale.** The premise was checked before acting and is false. `grep -i uncertain` returns **zero
matches** in the Proposal. The eight-reason admission list is at
`the-work-loop-explained-complete-system-v0.2.md:45` — Document 4, which the folder README designates
"DESTINATION REFERENCE ONLY. NOT A REQUIREMENTS DOCUMENT." That line opens with "The loop is entered
only for a named reason", which is the precise phrase the README quotes as its example of imperative
wording that creates nothing. Adopting the finding would have imported scope from the one document
the build forbids as a source. Two mitigations also apply: the core's reason list had already been
opened (it reads "a guide and not a closed list") by an earlier correction Fable had not seen, and
the five safety rules apply in every lane, so discovery work retains premise verification whether or
not it enters the loop.

**Alternatives considered.**
- **Adopt it as recommended.** Rejected on the above.
- **Adopt it as a deliberate widening rather than a restoration.** Offered to the operator as an
  available override; not taken.

**Wider point this is an instance of.** External review input is a brief like any other and its
premises are verified before adoption. Here the reviewer was sincere, specific, and wrong about which
document it was quoting — which is exactly the failure mode the folder README was written to prevent.

## 2026-08-01 — Amended the work-loop-v2-mvp mission's frozen acceptance assertion 1

**Context.** The prior session (S3-19b) settled that Claude, not Codex, commits the Work Loop v2
task-state file — forced by Step 2's finding that Codex is refused write access to `.git` in two
independent sessions, with a positive control proving it is not a repository fault. That decision
amended the Proposal's destination behaviour 1, but the mission's validation contract — frozen at
mission creation, before implementation began — still carried the pre-amendment wording ("Codex …
writes a bounded brief into a task-state file, and commits it"). As written, the mission could not
satisfy its own definition of done. S3-19b deliberately left the choice to the operator rather than
deciding it.

**Decision.** Amend acceptance assertion 1 to read "Codex is given an objective and writes a bounded
brief into a task-state file; **Claude commits it** — the operator transports nothing by hand." The
date, the original wording, and the basis are recorded inline beside the assertion in
`logs/missions/work-loop-v2-mvp.md`, and the resolution is cross-referenced in
`plans/work-loop-v2-mvp/README.md`.

**Rationale.** A contract that cannot be satisfied measures nothing. The alternative — leaving the
freeze absolute and recording a standing divergence — keeps the freeze more literally intact, but
means the assertion is either waived at mission close or blocks closure permanently. A waived
assertion teaches the habit of waiving assertions, which is worse than a recorded, reasoned amendment.
The amendment is narrow by design: it does not lower the bar the assertion sets. The substance —
a bounded brief reaches the state file and is committed, with nothing carried by hand — is unchanged.
Only who runs the commit changed, and that changed on evidence, not preference.

**Alternatives considered.**
- **Record the divergence, do not edit the frozen contract.** Rejected — keeps the mission
  permanently unable to close against its own literal text, and pushes the judgment call to whoever
  closes the mission later, with less context than the operator has now.
- **Leave it open, decide at mission close.** Not offered as an option — the contradiction was already
  known and named at S3-19b; deferring a known, resolvable contradiction serves no one.

**Scope of the amendment.** This is the *only* edit made to `work-loop-v2-mvp.md`'s frozen prefix
(`## Goal` through `## Validation contract`). Verified by hashing the prefix before and after both the
`/mission update` and `/mission check` operations that touched the file this session — byte-identical
in both cases, confirming nothing else in the frozen contract moved.
