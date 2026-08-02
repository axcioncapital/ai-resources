# Session Notes — Archive 2026-08

## 2026-08-01 — Installed the Work Loop v2 MVP project (Step 0)

### Summary
Setup-only session, per the operator's explicit instruction: build nothing, design nothing. Committed
the four documents governing the Work Loop v2 MVP build into a new project folder, wrote an authority
README, and created the mission contract. Ran `/placement` first since this was a new top-level project
folder in an ambiguous layer (`plans/` vs `docs/`); its recommendation (`plans/`) was followed. Corrected
one factual claim in the README before committing (the Playbook's named commands — `/to-spec`,
`/implement`, etc. — do exist, as user-level Pocock skills in `~/.claude/skills/`, not in this repo).

### Decisions Made
- Placed the project folder at `ai-resources/plans/work-loop-v2-mvp/`, not `ai-resources/docs/`, per
  `/placement`'s recommendation — `docs/` already hosts the live v1 work-loop runtime contract
  (`work-loop.md`, `work-loop-spec.md`), and colocating the v2 destination-reference document there would
  invite exactly the authority confusion the README is meant to prevent.
- Added a canonical-home row to `docs/repo-architecture.md` for "multi-document build project"
  (`plans/<project-slug>/` with an authority README), since the map's existing plan-artifact row only
  described a flat file.
- Added an authority notice directly inside the Complete System explainer file (not just the README), so
  a session that opens that file directly still sees the destination-reference-only warning.
- Mission's validation contract, non-negotiables, and off-mission signals were drafted from Proposal § 4
  and § 6 rather than left as template placeholders, since the operator's setup instruction said "keep it
  light" but the mission template's own contract calls for writing the validation contract now, while
  fresh.

### Risky actions
None.

### Findings Declined
None — no findings this session (setup-only, no review, no defects observed).

### Next Steps
Playbook Step 1 (next session): investigate Codex-side resource packaging in the real Codex app — how a
Codex-side resource is installed, invoked, and reads/writes repository files. Commit a short cited
findings note. Do not investigate Claude Code command conventions (Claude inspects the repository itself
when implementation starts).

### Open Questions
None.

## 2026-08-01 — Session S1-eb7

**Mandate:** Investigate Codex-side resource packaging by inspection of primary sources — how a Codex-side resource is installed, invoked, and reads/writes repository files, plus any format or size constraints — done when: `plans/work-loop-v2-mvp/step-1-codex-packaging-findings.md` exists and is committed, every claim cited to an inspected source, and anything not inspectable from here named as an open gap rather than guessed.
- Out of scope: Claude Code command conventions (the repository answers repository questions at implementation time); building anything (no command, no resource, no executable core); any capability from the Complete System explainer (Consequential lane, worktrees, reviewer machinery, automation) — destination reference only, creates no requirements.
- Files in scope: (inferred)
- Stop if: answering a question would require asserting Codex behaviour that cannot be inspected from here — record it as an operator-checkable gap and continue with the rest.
- Allowed inputs: plans/work-loop-v2-mvp/README.md, plans/work-loop-v2-mvp/work-loop-v2-mvp-proposal-v0.4.md, plans/work-loop-v2-mvp/pocock-lifecycle-work-loop-mvp-v0.4.md, plans/work-loop-v2-mvp/skill-writing-standard-work-loop-v0.2.md, .agents/skills/work-loop/SKILL.md, docs/work-loop.md, ~/.codex/ and any Codex config or install surface present on this machine, Codex primary documentation
- Required outputs: plans/work-loop-v2-mvp/step-1-codex-packaging-findings.md
- Mission: work-loop-v2-mvp

**Work:** Work Loop v2 MVP Step 1 — investigate Codex-side resource packaging; commit a cited findings note

### Summary
Executed Playbook Step 1 for the Work Loop v2 MVP: answered the four Codex-packaging questions by
inspection, not guesswork. Established locally that `.agents/skills/` is scanned as a repo-level skill
source and that the five repo-side skills are all visible to Codex — but found that `.gitignore`
excludes all of them except `work-loop/`, so four exist only on this machine. Drafted a targeted
question set and handed it to the operator to run inside the real Codex app; verified every citation
Codex returned against the actual files (three line-number citations were wrong, substance correct each
time) before writing the findings note. Wrote and committed
`plans/work-loop-v2-mvp/step-1-codex-packaging-findings.md`.

### Decisions Made
- Ran the context-discovery engine (Step 2.4 of `/session-start`) — skipped it deliberately: this
  session reads and produces one new file, it does not modify existing repo structure, so the engine's
  pre-change routing map has nothing to contribute.
- Chose not to redesign the Proposal's repository-round-trip transport when local inspection found
  Codex could write files but not commit in the observed session. Recorded the finding as Step 2's first
  premise to test rather than treating it as a settled fact or acting on it — the Proposal is
  authoritative per `plans/work-loop-v2-mvp/README.md`, and a transport redesign is its call, not this
  session's.
- Corrected three mis-cited line numbers in the Codex-supplied report (the `description` length cap,
  the 500-line/5k-word recommendation, and the push-prohibition line) before writing them into the
  findings note, rather than reproducing the citations uninspected.
- Recorded `.agents/skills/` being gitignored (except `work-loop/`) as a build-relevant finding for
  later steps, not as a fix to apply now — out of this step's declared scope.

### Outcome
Outcome check skipped (not requested).

### Session Value Audit — 80/20 Review
Skipped (not requested).

### Risky actions
None. All commands run this session were read-only inspection (file reads, `grep`, `codex --help`,
config inspection) except the final `git add` + `git commit` of the one new findings-note file, staged
by explicit path. No destructive or external action taken.

### Findings Declined
- **`codex --help` on this machine resolves to a macOS-blocked binary and fails silently** — not queued
  as a new improvement-log entry: it is fully recorded, with evidence and the practical workaround (use
  the ChatGPT.app path), inside the findings note itself (§5), which is the correct durable home for a
  Codex-runtime fact this build's later steps will read directly. Duplicating it into
  `improvement-log.md` would split one fact across two owners for no benefit — it is a fact about the
  machine's Codex install, not a recurring Claude Code workflow defect.

Findings: 1 — queued 0, declined 1. 0 + 1 = 1.

### Session Assessment
Feedback collection skipped (not requested).

### Next Steps
Playbook Step 2 (next session): prototype the transport seam (throwaway). Test the round trip — does a
minimal repository-based hand-off between Codex and Claude actually work cleanly? Its first, sharpened
question from this session's findings: **can Codex commit at all** — Step 1 observed `.git` write-protected
in one session and could not establish whether that is fixed policy or a clearable per-session state.
Also test whether a new skill placed in `.agents/skills/` needs an explicit `.gitignore` re-include (like
`!work-loop/`) to survive in the repository. Discard the prototype code; keep only the conclusions note
and the minimal viable schema, per Playbook Step 2.

### Open Questions
None blocking. Noted, not resolved: whether Codex's inability to commit in the observed session is a
fixed runtime property or a configurable/escalatable one — named as Step 2's first thing to test, not
answered here.

## 2026-08-01 — Session S2-af1

**Mandate:** Prototype the Work Loop v2 transport seam (throwaway) — run one repository-based Codex/Claude round trip through a minimal state file and record the seam's real behaviour plus the minimal viable schema — done when: the round trip has worked once end to end across both apps; `plans/work-loop-v2-mvp/step-2-transport-seam-conclusions.md` exists and is committed recording the seam's behaviour and the minimal viable schema; both sharpened questions (can Codex commit at all; does a new `.agents/skills/` skill need its own `.gitignore` re-include) are answered by execution or named as operator-checkable gaps; and the prototype artifacts are discarded.
- Out of scope: writing the executable core (Step 3); building the Claude command or the Codex resource; designing schema beyond what the prototype actually proves; any capability from the Complete System explainer (Consequential lane, worktrees, reviewer machinery, automation) — destination reference only, creates no requirements; editing, retiring or "aligning" Work Loop v1; keeping the prototype code.
- Files in scope: .gitignore, logs/missions/work-loop-v2-mvp.md
- Stop if: the Codex side cannot be driven at all from this machine — record it as an operator-checkable gap rather than simulating Codex's half of the round trip; or answering a question would require asserting Codex behaviour that cannot be observed — record the gap and continue with the rest.
- Allowed inputs: plans/work-loop-v2-mvp/README.md, plans/work-loop-v2-mvp/work-loop-v2-mvp-proposal-v0.4.md, plans/work-loop-v2-mvp/pocock-lifecycle-work-loop-mvp-v0.4.md, plans/work-loop-v2-mvp/skill-writing-standard-work-loop-v0.2.md, plans/work-loop-v2-mvp/step-1-codex-packaging-findings.md, .agents/skills/work-loop/SKILL.md, docs/work-loop.md, .gitignore, ~/.codex/ and any Codex config or install surface present on this machine
- Required outputs: plans/work-loop-v2-mvp/step-2-transport-seam-conclusions.md, logs/loop/wl2-state.md
- Mission: work-loop-v2-mvp

**Work:** Work Loop v2 MVP Step 2 — transport-seam prototype (throwaway): test the Codex/Claude repository round trip

### Summary
Ran Playbook Step 2 to completion: a throwaway round trip between Codex and Claude through a
minimal state file (`logs/loop/wl2-state.md`). The round trip worked end to end (Codex writes brief
→ Claude reads/answers/commits → Codex reads result), but the key finding is that **git carried
none of the hand-off** — the file's full history is one commit (Claude's), so the shared working
tree did the transporting, not git. Both of Step 1's inherited premises were answered by execution:
Codex still cannot write `.git` (two independent sessions, same error), proven to be a Codex sandbox
restriction rather than a repo fault (positive control: Claude ran Codex's identical failing command
and it succeeded); and a new `.agents/skills/` skill needs exactly one `.gitignore` re-include line,
not four. Harvested a three-field minimal schema (`turn` / `Brief` / `Result`) with per-field
evidence, and flagged that `turn` is a protocol field absent from the Proposal's content ceiling —
for Step 3 to decide, not decided here. Wrote and committed the conclusions note, ticked both
mission threads with evidence pointers, and discarded the prototype (state file removed; one probe
skill folder remains — see Risky actions).

### Decisions Made
- Chose the shared-working-tree fallback (Codex writes/Claude commits) to *run* the round trip once
  Codex's `.git` block reproduced, rather than stopping the session — the Playbook explicitly allows
  this as a way to learn, and the mandate's `stop_if` only requires recording a gap, not halting on
  one. Did not treat the fallback as a transport redesign; the conclusions note states this
  explicitly as a Proposal-level decision reserved for the operator.
- Corrected the count sent back to Codex in the state file's Result section: the on-disk count of
  6 skill folders included the session's own throwaway probe folder. Rather than write a
  misleading number, both counts were recorded (6 raw / 5 excluding the probe) with the reason
  stated inline.
- Reverted the `.gitignore` re-include line immediately after using it to prove premise 2, rather
  than leaving it live — a live re-include is a commit hazard the plan's step 8 exists to prevent.
- Self-corrected the mandate line's `Files in scope` value mid-session after a hook flagged that
  `(inferred)` disables `check-foreign-staging.sh`'s guard regardless of what concrete paths are
  appended alongside it — removed the marker, kept the paths.

### Outcome
Outcome check skipped (not requested).

### Session Value Audit — 80/20 Review
Skipped (not requested).

### Risky actions
None destructive. One loose end: a throwaway probe skill folder (`.agents/skills/wl2-probe/`) is
still on disk — its removal was declined at the permission prompt twice (mid-session and at
cleanup). It is gitignored so it cannot be committed by accident, but it was not cleaned up as the
plan's step 8 intended. Flagged in the continuity scratchpad for the operator or the next session.

### Findings Declined
- **Probe folder deletion declined twice at the permission prompt.** Not queued — this is routine
  permission-in-the-loop behavior, not a system defect. Already recorded above under Risky actions
  with the continuity scratchpad as the operator-facing follow-up.
- **Codex cannot write `.git` (2 independent sessions); a new `.agents/skills/` skill needs exactly
  one `.gitignore` line, not four.** Not queued — both are fully recorded, with evidence and source
  tags, inside `plans/work-loop-v2-mvp/step-2-transport-seam-conclusions.md`, the correct durable
  home for build-relevant Codex-runtime facts this project's later steps will read directly. Same
  reasoning Step 1 applied to its own declined finding (`codex --help` blocked): duplicating into
  `improvement-log.md` would split one fact across two owners for no benefit.

Findings: 3 — queued 1 (severity: medium), declined 2. 1 + 2 = 3.

## 2026-08-01 — Session S3-19b

**Mandate:** Write the Work Loop v2 executable core — the single short document the Claude command and the Codex resource link to instead of restating rules — containing the seven sections Playbook Step 3 names, synthesized from the Proposal's settled decisions plus the Step 1 and Step 2 notes, with no decision reopened — done when: `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` exists and is committed with all seven sections present; the task-state interface section consciously decides where hand-off state lives (the `turn` field Step 2 proved is a protocol field the Proposal's content ceiling does not list) rather than silently dropping it; the core is checked against the skill-writing standard's Section 10 checklist; and the operator has read and approved it.
- Out of scope: Step 4's slice plan; building the Claude command or the Codex resource (Step 5); anything from the Complete System explainer (Consequential lane, worktrees, reviewer machinery, automation) — destination reference only, creates no requirements; editing, retiring or "aligning" Work Loop v1; reopening any settled decision in Proposal Section 3 or changing the Proposal's stated transport; closing the Step 2 § 6 open gaps that need the operator or the Codex app.
- Files in scope: logs/missions/work-loop-v2-mvp.md, plans/work-loop-v2-mvp/README.md
- Stop if: a section cannot be written without reopening a settled Proposal decision or making a Proposal-level call (e.g. formalising that Codex cannot write `.git`, or changing the transport from Git to the shared working tree) — surface it to the operator rather than deciding it; or the Complete System explainer is the only source for something the core would contain.
- Allowed inputs: plans/work-loop-v2-mvp/README.md, plans/work-loop-v2-mvp/work-loop-v2-mvp-proposal-v0.4.md, plans/work-loop-v2-mvp/pocock-lifecycle-work-loop-mvp-v0.4.md, plans/work-loop-v2-mvp/skill-writing-standard-work-loop-v0.2.md, plans/work-loop-v2-mvp/step-1-codex-packaging-findings.md, plans/work-loop-v2-mvp/step-2-transport-seam-conclusions.md, docs/work-loop.md, docs/work-loop-spec.md, .claude/commands/work-loop.md, .agents/skills/work-loop/SKILL.md (v1 read-only, form conventions only), logs/missions/work-loop-v2-mvp.md
- Required outputs: plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md
- Mission: work-loop-v2-mvp

**Work:** Work Loop v2 MVP Step 3 — write the executable core; operator reads and approves it

### Summary
Wrote the Work Loop v2 executable core — the one document the Claude command and the Codex resource
will link to instead of restating rules — from the Proposal's settled decisions plus the Step 1 and
Step 2 notes. Seven Playbook-mandated sections, one worked state-file example with its negative
counterpart, 275 lines / ~2,040 words against v1's 260 / 4,859. An independent subagent QC pass
(the process the operator adopted mid-session) returned PASS WITH CORRECTIONS and caught a genuine
blocking defect the author had missed; one correction pass fixed the frozen set. The operator then
settled the one item Step 3 escalated rather than decided — Claude commits the state file — which
also unblocked a deferred finding. Core approved, mission thread ticked with evidence.

### Decisions Made

**On the core's design (local, reversible, recorded in the core itself)**
- **`turn` lives in the state file's frontmatter**, named a protocol field and held outside
  Decision 10's five-field ceiling, which caps *content*. Step 2 flagged this and left it to Step 3.
  Kept in the same file because it is the only field the prototype demonstrably exercised, and a
  second file would open a second seam on day one.
- **State files live at `logs/work-loop/{task-id}.md`, not `logs/loop/`.** v1 is still live and
  globs `logs/loop/{STREAM}-*` in its own reconciliation, so a v2 file there would be swept into
  v1's bookkeeping while both systems exist. Verified against `docs/work-loop.md:246,253`.

**On the QC process (operator, adopting a Fable recommendation)**
- **Adopted**, and **scoped to the Work Loop v2 build only.** Written up at
  `plans/work-loop-v2-mvp/qc-process-v0.1.md`. The operator was offered three scopes and chose the
  narrow one. Reason it needed a choice: read workspace-wide, a Claude-side subagent QC pass is
  exactly what `CLAUDE.md` § Independent Review Rule tells sessions to reject. Inside this build the
  Proposal itself authorises targeted per-slice review (`:87`) and one candidate review
  (Decision 2, `:36`), so nothing is contested.
- The operator's own addition to Fable's advice is the load-bearing part: **the reviewer checks the
  artifact against the ORIGINAL files received at project start**, named by path — not the latest
  plan revision and not the conversation. A reviewer comparing against the current plan cannot see
  drift, because the plan drifted too.

**On the escalated open item (operator)**
- **Claude commits the state file.** Codex writes the brief; Claude makes every commit. This
  **amends the Proposal's destination behaviour 1**. The Proposal is not edited — the amendment is
  recorded in `plans/work-loop-v2-mvp/README.md` § "Decisions taken after v0.4" and in the core § 4,
  so a session reading the Proposal alone is pointed at the superseding decision. Logged to
  `decisions.md`.

**On the external review (Claude, per-item triage)**
- **Fable's finding A declined on verified premise grounds.** It asked to restore "genuine
  uncertainty" as an admission reason, citing the Proposal. Checked by grep: the Proposal contains
  **zero** occurrences of "uncertain"; the eight-reason list is at
  `the-work-loop-explained-complete-system-v0.2.md:45` — Document 4, which the folder README
  forbids as a requirements source, through the exact phrase ("the loop is entered only for") the
  README quotes as its example of wording that creates nothing. Adopting it would have been a scope
  breach, not a fix.
- **Findings B and C were already fixed** before the review arrived (`cba9bd8`); Fable was reading
  the pre-correction file. Said so rather than re-fixing.

**QC fixes applied** (independent subagent, verdict PASS WITH CORRECTIONS, scope frozen at 5)
- **B1, blocking** — the worked example carried a sixth field (`## Brief`) against Decision 10's
  five-field ceiling, and the core resolved it *silently*: it had written an explicit reconciliation
  for `turn` against that same ceiling and none for `Brief`. Slice 1 copies the example, so it would
  have shipped as a breach of the one settled decision Step 3 was bound to. The core now states what
  the ceiling covers — task **state** — and names `turn`, `task` and the brief as outside it.
- **C1** — the three-reason admission list was unsourced and narrower than Decision 1 plus
  destination behaviour 6. The sourced test (small and reversible → Direct) now governs; the three
  reasons became a guide, not a closed list.
- **C2** — de-escalation was absent though the Proposal (`:107`) requires demonstrating it in the
  Phase 4 regression set. Rule added.
- **C3** — "deferral" was defined and mandated but had no home in either the five active fields or
  the four closure fields. Now recorded at closure among the decisions that matter.
- **C4** — "Two notes on this design" was provenance, not behaviour. Cut; the decision it carried
  survives as a rule.

### Risky actions
None destructive. Three worth noting. First, the mission-file thread edit: the file forbids
hand-editing threads from a working session, so it went through the `/mission` update-then-check
sequence with the frozen prefix (lines 1–70 — Goal, scope, validation contract) hashed before and
after and verified byte-identical. Second, one dispatched subagent — the standing "no Agent tool
unless requested" posture was overridden by the operator's explicit instruction to use a subagent
for QC. Third, **a gate fired and was not overridden**: `check-foreign-staging.sh` BLOCKED the wrap
commit over `logs/next-up.md`. Verified it was this session's own promotion-sweep output and not a
concurrent session's, then unstaged it and committed without it rather than forcing past the guard.
The file is left uncommitted in the working tree; `/prime` still reads it. Root cause queued —
`wrap-session.md:332` instructs every wrap to stage that path and the hook does not recognise it.

### Findings Declined
- **`/mission check` cannot carry an evidence pointer, so ticking with evidence needs `update`
  first.** Not queued — this is designed behaviour, prescribed at the command's own item 24b, not a
  defect. Followed as documented.
- **`audits/working/` is gitignored, so the QC report will not survive a fresh clone.** Not queued —
  working notes are intentionally ephemeral by repo convention; the substance was written into the
  commit message instead.
- **External review input arrived with a false premise (Document 4 cited as the Proposal).** Not
  queued — the existing guidance already covers it (triage external review, do not rubber-stamp),
  and this session caught it by execution rather than by trust. No system gap to close.

### Next Steps
- **Step 4 — write the slice plan with acceptance behaviours.** Playbook lines 105–119. Lightweight
  session; done when the note exists and the operator has glanced at it.
- **Decide the mission-contract contradiction below** before Step 5 implements the round trip.
- Continuity scratchpad: `logs/scratchpads/2026-08-01-15-40-scratchpad.md`.

### Open Questions
The mission's **validation contract, acceptance assertion 1** still reads *"Codex … writes a bounded
brief into a task-state file, and commits it"* — which the settled "Claude commits" decision
contradicts. The contract is frozen at mission creation, so this session did not edit it. **As it
stands, the mission cannot satisfy its own definition of done.** The operator decides: amend the
assertion, or accept and record the divergence.

## 2026-08-01 — Session S4-1bc

**Mandate:** Write the Work Loop v2 MVP slice plan as one short note covering the three Proposal slices with a few observable acceptance behaviours each, and put the mission-contract contradiction to the operator for a decision — done when: `plans/work-loop-v2-mvp/step-4-slice-plan.md` exists and is committed with all three slices present, each carrying observable acceptance behaviours and the Slice 1 split point recorded; the operator has glanced at it; and the mission-contract contradiction has the operator's decision, recorded in the plan README and (if amended) in the mission file.
- Out of scope: implementing any slice (Step 5); reopening any settled decision in Proposal Section 3 or changing the stated transport; anything from the Complete System explainer (Document 4) — destination reference only, creates no requirements; editing, retiring or "aligning" Work Loop v1; ticket machinery (`/to-tickets` in spirit only).
- Files in scope: logs/missions/work-loop-v2-mvp.md, plans/work-loop-v2-mvp/README.md, logs/session-notes.md
- Stop if: a slice cannot be given acceptance behaviours without reopening a settled Proposal decision or making a Proposal-level call — surface it to the operator rather than deciding it; or Document 4 is the only source for something the slice plan would contain.
- Allowed inputs: plans/work-loop-v2-mvp/README.md, plans/work-loop-v2-mvp/work-loop-v2-mvp-proposal-v0.4.md, plans/work-loop-v2-mvp/pocock-lifecycle-work-loop-mvp-v0.4.md, plans/work-loop-v2-mvp/skill-writing-standard-work-loop-v0.2.md, plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md, plans/work-loop-v2-mvp/step-1-codex-packaging-findings.md, plans/work-loop-v2-mvp/step-2-transport-seam-conclusions.md, plans/work-loop-v2-mvp/qc-process-v0.1.md, logs/missions/work-loop-v2-mvp.md
- Required outputs: plans/work-loop-v2-mvp/step-4-slice-plan.md, logs/next-up.md
- Mission: work-loop-v2-mvp

**Work:** Work Loop v2 MVP Step 4 — write the slice plan with acceptance behaviours

### Summary
Wrote the Work Loop v2 MVP Step 4 slice plan — three slices, four acceptance behaviours each, every
behaviour carrying a constructible failing case and a trace to a Proposal destination behaviour or a
core section. Reconciled all eight Phase 4 regression items against the slices (six map, two are
built by nothing, correctly). Resolved the operator-escalated mission-contract contradiction from the
prior session: acceptance assertion 1 amended so "Claude commits" is now the mission's own definition
of done, not a standing divergence from it. Mid-session, a concurrent session wrapped and wrote its
own commit while this session was still working; verified no cross-contamination.

### Decisions Made

**On the slice plan's design (local, reversible, recorded in the note itself)**
- **Slice 1's split point made concrete.** Playbook and Proposal both permit splitting Slice 1 at the
  Codex-side/Claude-side boundary but do not say which half goes first. Chose Claude side first
  (1.2 verify-premises/refuse-false-premise, 1.3 execute-and-evidence): it can be exercised against a
  hand-written state-file fixture without waiting on the Codex resource, and 1.2(b) is Phase 2's own
  stated exit condition — it must not be the deferred half.
- **File-identity rejection (2.2) placed in Slice 2, not Slice 1.** The Step 2 prototype could not
  exercise it — a stale leftover cannot arise in a single clean round trip
  (`step-2-transport-seam-conclusions.md` § 5) — so it belongs with the slice that tests continuity,
  not the one that proves the seam.
- **Mid-unit deferral (3.3) and closure-check deferral (2.3) kept as separate behaviours.** The
  writing standard's § 8 failing-case table lists them apart; building one does not exercise the
  other.
- **Two non-behaviour build obligations recorded in the note rather than assumed carried forward** —
  the Codex resource's `.gitignore` re-include, and reliance on explicit `$name` invocation (over-cap
  description budget: 12,963 chars against an 8,000-char fallback cap). The Playbook tells a Step 5
  session to load only the slice note and the core and nothing else from planning history
  (`:129`), so anything true but unwritten here is invisible to that session.

**On the mission-contract contradiction (operator, offered two options, chose one)**
- **Amended acceptance assertion 1** rather than recording a standing divergence. Original: "Codex …
  writes a bounded brief into a task-state file, and commits it." Now: "…Claude commits it." The
  amendment does not lower the bar — the substance (a bounded brief reaches the state file and is
  committed, operator transports nothing by hand) is unchanged; only who runs the commit changed, on
  the Step 2 evidence that Codex was refused write access to `.git` in two independent sessions with
  a positive control proving it is not a repository fault. Date, original wording, and basis recorded
  inline beside the assertion — the only amendment made to the frozen contract; the freeze otherwise
  stands. Recorded in `plans/work-loop-v2-mvp/README.md` too, so a reader following either document
  sees the resolution.

**On my own commit (Claude, forced by a guard)**
- **Replaced my mandate's `Files in scope: (inferred)` with the concrete paths already confirmed with
  the operator at plan time.** The `check-foreign-staging.sh` guard blocked the first commit attempt:
  a live per-id marker from an unrelated abandoned session (`S2-af1`, 12:03) made this look like the
  highest-risk concurrent-session shape, and the guard correctly refused to guess which staged files
  were mine. Fixed per the guard's own prescribed remedy rather than working around it.

### Outcome
Outcome check skipped (not requested).

### Risky actions
Two, neither destructive. First: the mission file's frozen-contract prefix (`## Goal` through end of
`## Validation contract`) was edited via `/mission update` then `/mission check`, hashed before and
after each operation and verified byte-identical both times — the amendment landed only inside
`## Open threads`, per the mission subsystem's own contract. Second: a concurrent session committed
(`382f449`) to this same repo mid-session, staging files this session did not author. Caught by the
`check-foreign-staging.sh` guard before the first commit attempt; resolved by declaring a concrete
`Files in scope` footprint rather than overriding the guard. No foreign file was included in either
of this session's two commits.

### Findings Declined
- **Leftover per-id session marker (`logs/.session-marker-af1a2dc7-...`, S2-af1, stale since 12:03)
  is what triggered the guard's highest-risk branch.** Not queued as a new finding — this is a fresh
  instance of an already-tracked mission thread (`repo-health-backlog-2026-07`, item 3 /
  `next-up.md` marker-teardown entries), not a new defect. No new entry needed.

### Next Steps
- **Step 5 — implement Slice 1 (core round trip), fresh session, red-green.** Load only
  `plans/work-loop-v2-mvp/step-4-slice-plan.md` and the executable core — nothing else from planning
  history (Playbook `:129`). Build the Claude side (1.2, 1.3) first per the recorded split-point
  rationale.
- Watch for the untested premise the slice note flags: whether explicit `$name` invocation is
  reliable under Codex's over-cap description budget. If Slice 1 fails at invocation, check that
  before debugging the loop logic itself.

### Open Questions
None.

## 2026-08-01 — Session S5-646

**Mandate:** Implement Work Loop v2 MVP Slice 1 (the core round trip) red-green — Claude side (1.2, 1.3) first against a hand-written state-file fixture, then the Codex side (1.1, 1.4) if the session holds — done when: 1.2 and 1.3 each have a constructed failing case shown failing before the work and passing after, with the implementation committed; and either 1.1 and 1.4 meet the same bar, or the session stopped at the recorded split point with the Claude side green and committed and the split recorded.
- Out of scope: Slice 2 and Slice 3 behaviours; every planning-history document except the two allowed inputs (Proposal, Playbook, writing standard, QC process, Step 1 / Step 2 notes); editing, retiring or "aligning" Work Loop v1 (`.claude/commands/work-loop.md`) — Step 7 owns that; the Phase 3 pilot (destination behaviour 7).
- Files in scope: logs/missions/work-loop-v2-mvp.md, logs/session-notes.md, .gitignore
- Stop if: explicit `$name` invocation proves unreliable under Codex's over-cap description budget — that is a finding for the operator, not something to design around inside the slice (slice plan `:99`); the Claude side is green and committed and the Codex side has not started when the session boundary arrives — stop there, do not carry a half-built second half (`:49`); a behaviour cannot be given a constructible failing case.
- Allowed inputs: plans/work-loop-v2-mvp/step-4-slice-plan.md, plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md, the live repository (convention inspection and fixture material only)
- Required outputs: a Work Loop v2 Claude-side command file (exact path decided in-session by repo inspection, Playbook `:131`), logs/work-loop/{task-id}.md (state file and fixtures — folder created, not falling back to logs/loop/), a red-green evidence record for 1.2 and 1.3
- Mission: work-loop-v2-mvp

**Work:** Work Loop v2 MVP Step 5 — implement Slice 1 (core round trip), red-green; Claude side (1.2, 1.3) first

### Summary
Built and executed Work Loop v2's Claude-side command (`.claude/commands/work-loop-v2.md`), covering
behaviours 1.2 (verify premises / refuse a false premise) and 1.3 (execute and evidence). Wrote a
red-green acceptance harness (`logs/scripts/work-loop-v2-slice-1.test.sh`, 18 assertions) and ran it
before the command existed (12 failed, 6 passed) and after (18/18 passed). Ran two fixture units
through the new command by hand: one with a deliberately false premise (handed back cleanly, no file
mutated) and one where every premise held (implemented, evidenced, committed). Stopped at the
predefined split point — the Codex side (1.1, 1.4) needs Codex itself invoked, which Claude cannot
stand in for — and wrote the split record with two obligations carried forward for that session.

### Decisions Made
- **(Claude)** Skipped Step 2.4's context-discovery agent at `/session-start`, stating the conflict
  rather than silently choosing: this session carries a standing no-Agent-tool-unless-requested rule,
  and the Playbook restricts a Step 5 session to two named planning documents, which a routing-map
  pack would widen. Operator did not object.
- **(Claude)** Wrote concrete `files_in_scope` paths into the mandate rather than the literal
  `(inferred)` marker, despite `DIRECT` evaluating to 0 (no `**Execution route:** direct` line in this
  project's CLAUDE.md). Reasoned from the prior session's own recorded incident: an `(inferred)` scope
  triggered `check-foreign-staging.sh`'s highest-risk branch and blocked a commit. Deliberate deviation
  from the literal Step 3 instruction, stated inline at the time rather than applied silently.
- **(Claude)** Named the new command `/work-loop-v2` and decided it stays ai-resources-only for the
  MVP — no workspace-root symlink yet. Reasoned during the blind-spot scan: the Codex resource is
  already rooted in ai-resources, so Slice 2's fresh-session test does not need root reachability, and
  widening before the loop is proven adds blast radius for no benefit. Step 7 (v1 retirement) is the
  natural promotion point.
- **(Claude)** Added an executable acceptance harness (`logs/scripts/work-loop-v2-slice-1.test.sh`) as
  an in-session scope addition, announced rather than assumed (core § 6 rule 4). Placed beside the
  existing `prime-*.test.sh` tripwires — an established convention, not a new artifact category.
- **(Claude)** During the harness's own red run, caught and fixed three assertions that had passed for
  the wrong reason (matched the fixture's own filename text, matched a word already present in the
  brief, or would pass on the mere existence of a commit rather than its content). Tightened before
  accepting red, per the standing rule that an assertion which cannot fail is not evidence.
- **(Claude)** Did not tick the mission's Slice 1 thread — only the Claude side is built, and ticking
  it now would close the thread by assertion rather than by the validation contract.

### Outcome
(Step 6.4 skipped — not requested)

### Session Value Audit — 80/20 Review
(Step 6.4 skipped — not requested)

### Risky actions
None. Both fixture-unit executions were reversible, scoped to files created this session, and
committed individually. The false-premise run correctly changed nothing in the file the brief named.

### Findings Declined
Three, all from the blind-spot scan — **declined as superseded**, not queued to `improvement-log.md`:
the leftover `wl2-probe` resource, the `.gitignore` re-include naming only v1, and the undecided
workspace-root reachability. Each is already written as a mandatory prerequisite in the split record
(`plans/work-loop-v2-mvp/step-5-slice-1-evidence.md`) and in `### Next Steps` below, both of which the
next Work Loop v2 session reads directly as required input — a narrower, guaranteed-read channel than
the generic backlog queue, for a finding scoped to exactly one specific next session.

### Review status
This session touched structural change classes (a new Claude Code command, a new shared-state log
surface, a new script). `/blindspot-scan` ran pre-implementation (PROCEED-WITH-CONSTRAINTS, three
findings, all carried into the split record above). No independent Codex review ran on the landed
command or harness this session — **unassessed**. Sizing that review is the Codex-side session's
first order of business, per this session's own risk note in `logs/session-plan-2026-08-01-S5-646.md`.

### Next Steps
- **Codex-side session — implement 1.1 and 1.4**, using `$name` invocation of the new v2 Codex resource.
  Before testing invocation: delete the leftover `.agents/skills/wl2-probe/` (untracked, gitignored,
  still live — can silently satisfy the invocation test in place of the real resource) and add the
  resource's own `.gitignore` re-include (`!.agents/skills/<v2-name>/`) *before* its first commit —
  `.gitignore:77` currently only re-includes `work-loop` (v1), so any other name is silently ignored.
- Watch the untested premise: whether explicit `$name` invocation is reliable under Codex's over-cap
  (12,963 vs 8,000 char) description budget. If invocation fails, that is a finding for the operator,
  not something to design around inside the slice.

### Open Questions
None.

## 2026-08-01 — Session S6-974

**Mandate:** Implement Slice 1's Codex side (behaviours 1.1 and 1.4) red-green — clear the two recorded prerequisites, build the Work Loop v2 Codex resource, prepare the prompt the operator pastes into Codex, and test explicit `$name` invocation — done when: 1.1 and 1.4 each have a constructed failing case shown failing before the work and passing after with the implementation committed; the Codex prompt is written and handed over in chat; and the acceptance harness passes with the new assertions included.
- Out of scope: Slice 2 and Slice 3 behaviours (file-identity rejection, correction rounds, admission discipline); editing, retiring or "aligning" Work Loop v1 (`.claude/commands/work-loop.md`) — Step 7 owns that; reusing the `work-loop` resource name (it would overwrite v1's tracked resource); the Phase 3 pilot (destination behaviour 7); every planning-history document except the three allowed inputs.
- Files in scope: .gitignore, .agents/skills/wl2-probe, .claude/commands/work-loop-v2.md, logs/scripts/work-loop-v2-slice-1.test.sh, plans/work-loop-v2-mvp/step-5-slice-1-evidence.md, logs/missions/work-loop-v2-mvp.md, logs/session-notes.md, logs/decisions.md, logs/improvement-log.md, logs/next-up.md, logs/friction-log.md, logs/session-notes-archive-2026-07.md, logs/decisions-archive-2026-07.md, logs/runs/2026-08-01-S6-974.json (widened at wrap — `check-foreign-staging.sh` correctly flagged these as outside the original declared footprint; verified each belongs to this session before adding rather than overridden blind: friction-log.md and next-up.md specifically per the guard's own remedy)
- Stop if: explicit `$name` invocation proves unreliable under Codex's over-cap (12,963 vs 8,000 char) description budget — that is a finding for the operator, not something to design around inside the slice (slice plan `:99`); a behaviour cannot be given a constructible failing case; Codex cannot be driven at all this session — stop and record, do not have Claude stand in for it.
- Allowed inputs: plans/work-loop-v2-mvp/step-5-slice-1-evidence.md, plans/work-loop-v2-mvp/step-4-slice-plan.md, plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md, the live repository (convention inspection and fixture material only)
- Required outputs: the Work Loop v2 Codex resource (`.agents/skills/<v2-name>/SKILL.md` — exact name decided in-session), the Codex prompt delivered in chat, a red-green evidence record covering 1.1 and 1.4
- Mission: work-loop-v2-mvp

**Work:** Work Loop v2 MVP Step 5 — Codex side: implement behaviours 1.1 and 1.4, prepare the Codex prompt and clear its stated prerequisites

### Summary
Completed Work Loop v2 Slice 1: built the Codex-side resource, ran a real round trip through the
actual Codex app, and closed both remaining behaviours (1.1, 1.4) red-green. Cleared one of the two
recorded prerequisites (`.gitignore` re-include, falsifiable both ways) and deliberately kept the
other (`wl2-probe`) after a third declined deletion, repurposing it as a positive control instead of
re-asking. Prepared and handed the operator two Codex prompts in turn; the operator ran both in the
real app and pasted the results back, which this session verified against disk rather than trusting
the paste. Extended the acceptance harness from 18 to 34 assertions, found and repaired a genuine
defect in the harness itself (two assertions that could not pass once 1.4 succeeded — 1.1 and 1.4
have mutually exclusive end states on one file), and proved the repair was still falsifiable before
accepting green. Wrote a full evidence record and ticked the mission's Slice 1 thread with two
limitations stated rather than smoothed over. When the operator overruled a proposed follow-up
Codex review as unneeded ceremony, found that the mission's own non-negotiables already forbade it,
and recorded the decision as settled in the mission file. Also wrote a self-contained
harness/permission troubleshooting runbook, verifying every claim in it by execution and surfacing
three live defects found in the process (an `opus[1m]` model field in user settings, a `rm -rf` deny
rule that blocks by verb-text and not by effect, and a documented-but-orphaned permission-sanity
hook).

### Decisions Made
- **(Claude)** Skipped the automatic `/blindspot-scan` mid-session per explicit operator instruction
  ("do not use blindspot") — this was the operator overriding CLAUDE.md's stated auto-fire trigger for
  this session; not treated as a standing rule change.
- **(Claude)** Kept `wl2-probe` rather than re-requesting its deletion a fourth time (declined three
  times total across two sessions) and repurposed it as a positive control for the `$name` invocation
  test — recorded as a deliberate deviation from the split record's instruction, not an oversight.
- **(Claude)** Did not tell Codex where to write the state file in either prompt — routing had to come
  from the resource, or the invocation test proved nothing.
- **(Claude)** Retargeted the two failing 1.1 assertions to read from the commit that opened the file
  (`git log --diff-filter=A`) rather than the working tree, after confirming by inspection that the
  underlying hand-off genuinely happened and the harness — not the behaviour — was at fault. Proved the
  repair still falsifiable against a task id that was never opened before accepting it.
- **(Operator)** Declined the proposed follow-up Codex review of the Claude-side command and harness as
  unneeded ceremony. Verified against the mission's own non-negotiables ("do not add a review layer …
  beyond the one fresh-context candidate review") before recording it — the proposal was itself
  off-mission, not merely unnecessary. Recorded as settled, not deferred, in `logs/missions/work-loop-v2-mvp.md`.
- **(Claude)** Placed the new troubleshooting doc at `ai-resources/docs/` rather than duplicating
  existing permission/hook docs — it routes to `permission-template.md`, `settings-local-recovery.md`,
  `hook-rollback-recipes.md`, `settings-portability-invariant.md`, and `protected-zones.md` instead of
  restating them.

### Outcome
(Step 6.4 skipped — not requested)

### Session Value Audit — 80/20 Review
(Step 6.4 skipped — not requested)

### Risky actions
None destructive. Every mission-file edit went through `/mission update` then `/mission check`, with
the frozen prefix (Goal through Validation contract) hashed before and after each write and verified
byte-identical both times. Deletion of the leftover `wl2-probe` folder was declined at the permission
prompt (third time); repurposed rather than escalated. No git command was run by Codex at any point —
verified per-invocation, per the executable core's role split.

### Session Assessment
Skipped (Step 6.5 not requested — no `+feedback`/`full` flag).

### Findings Declined
None this session — the three settings/hook defects surfaced while writing the troubleshooting doc
were **queued**, not declined (see below); nothing else surfaced that named a real problem without
already being resolved in-session.

Findings: 3 — queued 3 (severity: high 1, medium-high 1, medium 1), declined 0. 3 + 0 = 3.

All three are the settings/hook defects verified by execution while writing
`docs/harness-and-permission-troubleshooting.md` (which explains each in full and is cross-referenced
from each entry): `~/.claude/settings.json`'s prohibited `"model": "opus[1m]"` field (high), the
`Bash(rm -rf *)` deny rule that blocks by verb-text and not effect, now a third occurrence (medium),
and `ai-resources/CLAUDE.md`'s claim of a `check-permission-sanity.sh` SessionStart hook that is
wired nowhere (medium-high). Logged to `logs/improvement-log.md`; the high and medium-high entries
promoted to `logs/next-up.md` this wrap and will reach the `/prime` menu next session. **Correction
made mid-wrap:** the first draft of this section wrote "Findings: 0", reasoning that documenting the
defects in the runbook was itself sufficient disposition — that was wrong. A doc only someone opens
is a notification, not a queue, and this step exists precisely to stop that substitution.

### Next Steps
- **Slice 2 — implement continuity and correction (behaviours 2.1–2.4), fresh session, red-green.**
  Straight to work — no review step in front of it, per this session's settled decision. 2.1 (a fresh
  session reading the state file and Git alone) is also the real independent exercise of the Claude-side
  command that the declined review would otherwise have provided.
- **Slice 1's two named limitations carry forward as open, not as blockers:** 1.1 is proven on routing
  only, not on folder creation from an absent `logs/work-loop/`; Slice 2/3 sessions should not assume
  that sub-clause is covered.
- **The three findings in `docs/harness-and-permission-troubleshooting.md` § 5 are the natural next
  session if the operator wants them fixed** — the `opus[1m]` model field in `~/.claude/settings.json`
  is one line and is quietly undermining `/model`.

### Open Questions
None.

### Review status
This session touched a structural change class (a new Codex-side resource, `.agents/skills/work-loop-v2/`,
plus a `.gitignore` rule governing what reaches commits). **No separate independent review ran, and
this is now a recorded operator decision, not a gap** — see `logs/missions/work-loop-v2-mvp.md` § Open
threads (Step 5 Slice 1 entry) for the full reasoning: a second review layer is forbidden by this
mission's own non-negotiables, Step 6 already is the one candidate review the mission permits, Slice
2's behaviour 2.1 exercises the command more rigorously than a reading review would, and the
34-assertion harness is the standing check. `unassessed` remains in the mission thread as a factual
record that no review ran, per `docs/qc-independence.md` — paired with the decision that none was
sized.

## 2026-08-01 — Session S7-3fc

**Mandate:** Implement Slice 2 of Work Loop v2 (continuity and correction, behaviours 2.1–2.4) red-green in this fresh session — done when: behaviours 2.1–2.4 each have a constructed failing case shown failing before the work and passing after, with the implementation committed
- Out of scope: a review step before the work (settled operator decision, mission file); Slice 3 behaviours (admission discipline); Step 6 review; Step 7 v1 retirement and pilot; editing any v1 artifact (`docs/work-loop.md`, `docs/work-loop-spec.md`, `.claude/commands/work-loop.md`, `.agents/skills/work-loop/SKILL.md`)
- Files in scope: plans/work-loop-v2-mvp/step-4-slice-plan.md, plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md, .claude/commands/work-loop-v2.md, .agents/skills/work-loop-v2/SKILL.md, logs/scripts/work-loop-v2-slice-1.test.sh, logs/missions/work-loop-v2-mvp.md
- Stop if: (none stated)
- Allowed inputs: plans/work-loop-v2-mvp/step-5-slice-1-evidence.md, plans/work-loop-v2-mvp/README.md, plans/work-loop-v2-mvp/pocock-lifecycle-work-loop-mvp-v0.4.md, plans/work-loop-v2-mvp/step-2-transport-seam-conclusions.md, logs/decisions.md, logs/work-loop/fixture-slice1-true.md, docs/cross-model-rules.md
- Required outputs: .claude/commands/work-loop-v2.md, .agents/skills/work-loop-v2/SKILL.md
- Context pack: output/context-packs/command-20260801-b7e3a/pack.md
- Mission: work-loop-v2-mvp

**Work:** Work Loop v2 MVP Step 5 — implement Slice 2 (continuity and correction, behaviours 2.1–2.4), red-green

### Summary
Completed Work Loop v2 Slice 2: all four behaviours (2.1–2.4) implemented and demonstrated
red-green, harness extended from 34 to 78 assertions, 78/78 exit 0. Behaviour 2.1 was exercised by
this genuinely fresh session picking up a committed task from the state file and Git alone — the
substitute exercise the Slice 1 no-review decision relied on. 2.2's file-identity rejection was
shown failing at two layers (missing check in the artifact; the pre-edit command genuinely writing
into a foreign file) before the fix, and the field is now proven. 2.3 and 2.4 ran through real
Codex judgment: Codex froze two findings it found on its own in a deliberately defective unit,
closed after one bounded round, recorded the dangled adjacent problem as a deferral in its own
words, and — on a constructed task whose second finding could not be fixed without crossing the
approved scope — chose once from the correction-exit menu on explicit value-and-risk grounds.
Evidence record written; mission thread ticked with the frozen prefix verified byte-identical.

### Decisions Made
- **(Claude)** Ran 2.1 first in the session, before implementing anything, so the fresh-session
  pickup happened at orientation-level exposure only — the recommended resolution of the context
  pack's open scope question, confirmed by the operator at mandate confirmation.
- **(Claude)** Demonstrated 2.2's run-level red by executing the pre-edit command against the
  foreign fixture only up to its first mutating write, then halting and reverting — carrying the
  defective run to a committed unit would have polluted history to prove a proven point.
- **(Claude)** Gave 2.4 its own constructed fixture (`fixture-slice2-menu`) after the correction
  task resolved both its findings fully — an honest partial resolution needs a structural blocker,
  so the fixture's second finding names a file its scope excludes (core § 6 rule 4 bars the edit).
  The fixture's first pass and assessment block are declared fixture material in the file itself.
- **(Claude)** Read the heading-level fix as inside Codex's frozen finding 2 ("the complete
  end-of-file shape") rather than as scope growth — stated in the hand-back, not silently assumed.
- **(Operator, deferred not decided)** Asked why the Codex prompts must be pasted rather than read
  from the state files — answered (a file cannot invoke Codex; two tasks were simultaneously at
  turn: codex), and the real improvement (bare `$work-loop-v2` resolving the open task itself) was
  recorded as a deferral for the Step 6 review rather than improvised mid-slice.

### Risky actions
None destructive. The 2.2 red demonstration deliberately mutated a fixture state file with the
pre-edit command, was halted at the first write, and was reverted from in-context content before
the fix landed; nothing was committed in the mutated state. Both mission-file writes went through
the update/check guard with the frozen prefix hashed before and after, byte-identical both times
(f312397…). Codex ran no git command at any point — verified per invocation via `git status`.

### Findings Declined
- **Codex's first menu-closure run wrote nothing to disk** (operator reported done; file untouched;
  re-run wrote correctly). Declined for the queue: single occurrence, caught by the verify-against-
  disk protocol working as designed, recorded as limitation 3 in the evidence record, and the Step 7
  pilot — already a queued mission thread — is the designated window to observe recurrence.
- **The harness filename still says `slice-1` while covering Slices 1–2.** Declined: cosmetic; the
  header states the real scope; renaming would break references in both artifacts, the mission file
  and two evidence records for zero behavioural gain.

Findings: 3 — queued 1 (severity: medium 1), declined 2. 1 + 2 = 3.

The queued finding: the Codex-side invocation currently requires the operator to paste a prompt
naming the task id; the resource could resolve the open task itself (single `turn: codex` file, ask
when several qualify). Operator-raised this session; logged to `logs/improvement-log.md` at medium —
it reaches `/open-items`, and its natural pickup is the Step 6 review or the pilot.

### Next Steps
- **Slice 3 — implement admission discipline (behaviours 3.1–3.4), fresh session, red-green.**
  Straight to work, per the settled no-pre-review decision in the mission file.
- Then Step 6 — one fresh-context candidate review, frozen by exact commit; the bare-invocation
  deferral and Slice 2's recorded limitations are inputs to it.
- Slice 2 limitations carry forward as open, not blockers: folder creation from an absent
  `logs/work-loop/` remains untested (Slice 1's limitation, still standing); Slice 2's opening
  briefs were hand-written fixtures — Codex opening was proven in Slice 1 only.

### Open Questions
None.

### Review status
This session touched a structural change class (edits to an existing command and a Codex-side skill
resource). **No separate independent review ran, and none was sized** — the same settled operator
decision recorded for Slice 1 applies (`logs/missions/work-loop-v2-mvp.md`, Step 5 Slice 1 entry):
the mission's non-negotiables forbid a review layer beyond Step 6's one fresh-context candidate
review, and the standing checks are stronger this time — the 78-assertion harness plus behaviour
2.1's real fresh-session exercise of the command, which is precisely the substitute exercise that
decision named. `unassessed` is recorded here as fact per `docs/qc-independence.md`; Step 6 remains
the mission's one review and these changes are inside its frozen-commit scope.

---

## 2026-08-01 — Fixed harness-and-permission-troubleshooting runbook (post-correction reconciliation)

**Work:** Correct `docs/harness-and-permission-troubleshooting.md` — reconcile the doc's summary sections with the same-day § 4.5 correction, and verify the correction's own claims independently.

### Summary
The runbook was written this morning (`c05d298`) and materially corrected later the same day: § 4.5 originally told readers to delete the `model` key from `~/.claude/settings.json`, which is destructive because `/model` writes that key itself. That correction was sound — I verified its central claim independently by observing the key read `opus[1m]` when the doc was written and `claude-fable-5[1m]` at 14:40:08 after the operator ran `/model`, with nothing else writing it. But the rewrite never reached the three sections that *summarise* § 4.5, leaving the doc contradicting itself at its own entry points. Applied seven fixes, all doc-only. Committed as `2eab561` (116 insertions, 25 deletions).

The highest-value find was incidental: widening § 4.1's orphan-hook scan from one directory to two (16 rows → 22) surfaced **two previously unknown orphaned hooks** at the workspace root — `session-start.sh` and `sync-shared-resources.sh`. Both verified genuinely dead before recording (unwired in every settings file, git hook, and other hook script; the `session-start.sh` hits inside `precompact.sh`/`postcompact.sh` are comments, not calls). `sync-shared-resources.sh` is the worse case: a sync mechanism that never fires while ~12 project documents describe it as live. § 5 finding #3 updated from three orphans to five.

### Decisions Made
- **Deliverable scope = correct the doc only** (operator-directed). Do not apply § 5's recommended fixes to the machine — finding #1's fix is destructive, and #2/#3 are harness-config changes the autonomy rules make operator decisions. Nothing outside the doc was touched; verified `~/.claude/settings.json` mtime unchanged (14:40:08) and workspace `CLAUDE.md` clean.
- **§ 6's model bullet narrowed rather than inverted.** Its wording is lifted verbatim from workspace `CLAUDE.md` § Model Tier — the non-negotiable rule currently under a pending operator decision. Simply inverting it would pre-empt a ruling the operator reserved, so the bullet was narrowed to committed layers and now points at § 4.5's open conflict box.
- **§ 3.4's option order changed** so the grep-around-a-`Read`-deny trick is listed last, not first. Its own text calls it "a real gap in the guard, not a blessed workaround"; leading with it taught routing around a confidentiality control.
- **§ 4.1 scan widened to both hook directories** rather than documenting the limitation — a diagnostic whose job is completeness should not return clean-looking output with a directory silently missing.
- **Routine:** header gained a revision note; ✅ marker definition widened to cover observed live state (§ 4.5's evidence is an observed value change, not a test); § 3.2's "all four" corrected to "all five".

### Risky actions
None. The one real hazard was caught and respected: the Step 3.5 pre-write guard fired CONCURRENT on `logs/session-notes.md` because session S7-3fc had uncommitted content in the working tree. I stopped rather than staging the union, and only proceeded after S7-3fc's own wrap (`2aa066f`) landed its content in HEAD and the guard re-ran clean (`FOREIGN=0`, `WT=8 HEAD=8`).

### Next Steps
Four operator decisions are open and recorded in the doc itself, none blocking:
1. **`CLAUDE.md` § Model Tier rule conflict** — the rule bans a `model` field in "any" settings layer and names the user layer explicitly, but the user layer is `/model`'s own storage, so the rule as written cannot be complied with while using `/model`. Evidence supports narrowing to committed layers. Recorded in § 4.5's conflict box, § 5 finding #1, and `improvement-log.md:2301`.
2. **`Bash(rm -rf *)` deny rule** (§ 5 finding #2) — denies by text not effect; has blocked legitimate cleanup three times across sessions.
3. **Five orphaned hooks** (§ 5 finding #3) — each needs registration or a correction to the documents claiming it runs. `sync-shared-resources.sh` is the priority.
4. **`warn-fable-model.sh` staleness** — asserts the operator does not want Fable for Axcíon work, but `/model claude-fable-5[1m]` was chosen deliberately this session.

### Open Questions
None blocking. Items 1–4 above are operator judgment calls, not unknowns.

### Findings Declined
- **Doc summary sections contradicted the corrected § 4.5** (§ 1 triage row, § 5 preamble, § 6 bullet) — declined as a queue item because it was **fixed this session** in commit `2eab561`. Nothing left to action.
- **§ 4.1's orphan scan was blind to the workspace-root hooks directory** — declined for the same reason: fixed this session. The *consequence* it revealed (two unrecorded orphans) was queued separately rather than declined.
- **§ 3.4 listed the grep-around-a-`Read`-deny workaround first**, ahead of the safe options — fixed this session; moved last with its warning kept.
- **`Bash(rm -rf *)` denies by verb-text, not effect** — declined as a duplicate. Already queued at `improvement-log.md:2304` (2026-08-01, third occurrence), with the same proposal.
- **`CLAUDE.md` § Model Tier bans a `model` field in a layer `/model` itself owns** — declined as a duplicate. Already queued at `improvement-log.md:2301`, and recorded in the doc at §§ 4.5 and 5.

## 2026-08-01 — Session S8-7c0
**Mandate:** Implement Work Loop v2 MVP Step 5, Slice 3 (admission discipline), red-green — done when: Slice 3's four acceptance behaviours (3.1–3.4) are green with red-then-green evidence recorded in step-5-slice-3-evidence.md, the mission's Slice 3 thread is ticked, and the work is committed
- Out of scope: (none stated)
- Files in scope: logs/scripts/work-loop-v2-slice-1.test.sh, .claude/commands/work-loop-v2.md, .agents/skills/work-loop-v2/SKILL.md, logs/missions/work-loop-v2-mvp.md, plans/work-loop-v2-mvp/step-4-slice-plan.md, plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md, plans/work-loop-v2-mvp/README.md, plans/work-loop-v2-mvp/skill-writing-standard-work-loop-v0.2.md
- Stop if: (none stated)
- Allowed inputs: plans/work-loop-v2-mvp/step-5-slice-2-evidence.md, plans/work-loop-v2-mvp/step-5-slice-1-evidence.md, plans/work-loop-v2-mvp/pocock-lifecycle-work-loop-mvp-v0.4.md, plans/work-loop-v2-mvp/step-2-transport-seam-conclusions.md, logs/decisions.md, logs/work-loop/fixture-slice2-menu.md, logs/work-loop/fixture-slice2-correction.md, logs/work-loop/fixture-target.md, .gitignore
- Required outputs: plans/work-loop-v2-mvp/step-5-slice-3-evidence.md, logs/scripts/work-loop-v2-slice-1.test.sh
- Context pack: output/context-packs/project-20260801-b7e41/pack.md
- Mission: work-loop-v2-mvp

**Work:** Work Loop v2 MVP Step 5 — implement Slice 3 (admission discipline), red-green

### Summary
Built Slice 3 — admission discipline — red-green in one session. The Work Loop now knows when *not*
to run: a small reversible fix is Direct Work with no state file, opening a task needs a named reason
("this feels significant" is refused), work that turns out smaller de-escalates and closes, and an
adjacent improvement noticed mid-unit is recorded as a deferral rather than done. The acceptance
harness went 78 → **136 assertions**, all green, every new one observed failing first. Four fixture
tasks were run; Codex made every closing and assessment call.

The most useful result was a failure I caused. The first behaviour-3.4 fixture was mis-designed — its
written limitation contradicted the task's own objective — so Codex's real assessment correctly froze
a correction instead of closing. That task then ran as a clean bounded correction, and a properly
designed second task (`fixture-slice3-close`) demonstrated 3.4 with zero correction rounds. Two of my
own harness defects surfaced and were fixed: assertions reading the working tree where they should
read history (the Slice 1 behaviour-1.1 lesson, repeated), and a limitations assertion testing bullet
syntax rather than substance.

### Decisions Made
- **Admission lives in both artifacts, asymmetrically** — the session's one undecided scope question
  (the slice plan gives Slice 3 no split point). Claude's command took the admission test,
  de-escalation and the Step 4 deferral rule; the Codex resource took the admission test and one
  assessment line for de-escalation. Ground: the Slice-2-era scope-exclusion lines being replaced
  existed in *both* files, so both had already promised the behaviour.
- **Followed Codex's correction verdict rather than overriding it.** When Codex refused to close
  `fixture-slice3-limits`, the cheap move was to call the fixture close enough and force it green.
  Ran the bounded correction instead and rebuilt the close case properly — the behaviour is now
  demonstrated on a task that actually tests it.
- **The 3.4 close-task brief was hand-written at the operator's direction** after the Codex opening
  prompt did not land. Disclosed as fixture material in the evidence record; Codex opening a unit is
  behaviour 1.1, already proven in Slice 1.
- **No per-slice review** — held to the operator's settled Slice 1 decision over the Playbook's
  per-slice review prescription. The context pack surfaced this as a conflict; Step 6's one
  fresh-context review remains the only review.
- **Harness assertion loosened on evidence, not convenience.** The last failing assertion required
  limitations in bullet form; Codex wrote prose. Nothing in the core or slice plan fixes that format,
  so the assertion was testing punctuation. Replaced with per-limitation substance checks and proved
  the replacement falsifiable by breaking one term and watching it fail.

### Risky actions
None. All writes were to this build's own fixtures, artifacts, harness and evidence records, staged
by explicit path. One deliberate temporary mutation — breaking a limitation term to prove an
assertion could fail — was backed up first, restored, and verified byte-identical to HEAD. The
mission file's frozen sections were hash-verified before and after the thread update.

### Findings Declined
- **Harness assertions read the working tree instead of history (3.3 hand-back)** — declined as a
  queue item: fixed this session in `149c812`. Same class as the Slice 1 behaviour-1.1 defect, and
  the fix is now in place for both.
- **A limitations assertion tested bullet syntax rather than substance (3.4)** — declined for the
  same reason: fixed this session in `59cabcd`, with falsifiability re-proven.
- **The first 3.4 fixture was mis-designed** — declined as a defect to queue. It is not a repo defect
  but a design error inside this slice's own construction, already corrected, and written up in the
  evidence record where Step 6's reviewer will read it.

Findings: 3 — queued 0, declined 3. 0 + 3 = 3.

### Next Steps
Mission `work-loop-v2-mvp`, Step 6: one fresh-context candidate review of the whole Work Loop v2
build, frozen by exact commit, one correction pass, accept with a limitations list. Freeze candidate
at `59cabcd` (last artifact-affecting commit). **Cheap win first:** behaviour 3.1(b) has no live
Codex refusal — one prompt (`$work-loop-v2 — open a task to polish the fixture wording. Reason: this
feels significant.`) closes the weakest evidence in the slice. Do **not** tidy the misspelled `Note:`
line in `fixture-target-2.md` — it is behaviour 3.3's assertion anchor.

### Open Questions
None blocking. The 3.1(b) evidence gap is named above with its one-prompt fix.
## 2026-08-01 — Session S9-6ba

**Mandate:** Run Work Loop v2 MVP Step 6 — freeze the candidate at an exact commit, run one fresh-context independent review of the whole build on the three QC dimensions, freeze the findings, make one correction pass, and accept the candidate with a written disclosed-limitations list — done when: the candidate is accepted at a named frozen commit with the limitations list written to `plans/work-loop-v2-mvp/step-6-candidate-review.md`; frozen findings A/B/C have had exactly one correction pass closure-checked against those findings plus blocking regressions only; the harness runs green (136+ assertions, exit 0) after any correction; the mission's Step 6 thread is ticked with evidence and the work is committed
- Out of scope: tidying the misspelled `Note:` line in `logs/work-loop/fixture-target-2.md` (behaviour 3.3's assertion anchor); any second broad review after the correction (mission non-negotiable); Step 7 work (v1 retirement decision, pilot units)
- Files in scope: .claude/commands/work-loop-v2.md, .agents/skills/work-loop-v2/SKILL.md, logs/scripts/work-loop-v2-slice-1.test.sh, logs/missions/work-loop-v2-mvp.md, plans/work-loop-v2-mvp/step-5-slice-3-evidence.md, plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md
- Footprint widened mid-session 2026-08-01: the executable core moved from Allowed inputs to Files in scope. Step 6 finding A named it as an edit target (its § 4 carried the contradictory interface claim); the original mandate assumed the core was read-only. Caught by check-foreign-staging.sh, disclosed to the operator, not overridden.
- Stop if: the closure check finds the correction insufficient — take the Step 6.5 menu once (accept a limitation / one final bounded fix / revert / reframe / stop) and escalate a genuine risk-acceptance choice to the operator
- Allowed inputs: plans/work-loop-v2-mvp/work-loop-v2-mvp-proposal-v0.4.md, plans/work-loop-v2-mvp/pocock-lifecycle-work-loop-mvp-v0.4.md, plans/work-loop-v2-mvp/skill-writing-standard-work-loop-v0.2.md, plans/work-loop-v2-mvp/qc-process-v0.1.md, plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md, plans/work-loop-v2-mvp/step-4-slice-plan.md, plans/work-loop-v2-mvp/README.md, plans/work-loop-v2-mvp/step-5-slice-1-evidence.md, plans/work-loop-v2-mvp/step-5-slice-2-evidence.md, logs/work-loop/
- Required outputs: plans/work-loop-v2-mvp/step-6-candidate-review.md
- Mission: work-loop-v2-mvp

**Work:** Work Loop v2 MVP Step 6 — one fresh-context candidate review of the whole build, frozen by exact commit, one correction pass, accept with a limitations list

### Summary
Ran Step 6's one candidate review. Codex reviewed the frozen candidate at `cc443e1` and returned
**Accept with corrections** on three material findings. A and B are corrected and committed
(`edd0d97`); **C is deferred to next session by operator decision**, so Step 6 is NOT complete and
the mission thread is deliberately not ticked. Before the review, behaviour 3.1(b) — the weakest
evidence in the whole build — was closed on a live, unprompted Codex refusal, which also closed the
bare-invocation deferral open since Slice 2. The harness went 136 → 143 assertions, all green, with
every new assertion proven able to fail first.

The session's most useful result was a transport failure. Codex could not see a request pasted into
chat at all, because the artifacts tell it the state file is the only interface while also having it
question the operator directly — two rules that cannot both hold at the first request, when no file
exists yet. That became `issue-codex-request-intake.md` at the operator's request, and the reviewer
independently rated the same contradiction material (finding A).

### Decisions Made
- **The operator's request was carried to Codex by a state file**, after a chat-pasted request proved
  invisible to it. Operator-directed. Cost recorded rather than smoothed: a file now exists for a
  task that was never admitted, which weakens the "Direct Work opens no state file" guarantee.
- **Finding C deferred to next session.** Claude recommended the bounded option and stated plainly
  that it authored the artifacts it was recommending not to rewrite; the operator deferred rather
  than settling it under that conflict.
- **The review did not run through `$work-loop-v2`.** Caught after Claude had already written the
  self-hosting version into the brief — running the candidate review through the candidate is
  forbidden by Proposal § 6 and the mission's non-negotiables. Fixed at `4c77ced`.
- **The 3.1(b) harness assertion was replaced on evidence, not convenience.** It proved the behaviour
  by file absence, which became meaningless once the request had to be carried by a file. Seven
  substance assertions replace it; six were proven to go red against a task that *was* opened.
- **The session footprint was widened mid-session, disclosed not overridden.** The executable core
  was declared a read-only input; finding A made it an edit target. `check-foreign-staging.sh`
  blocked the commit until the mandate was corrected.

### Risky actions
None irreversible. Two temporary mutations, both inside `logs/work-loop/` and both removed and
verified: an arbitrary state file planted twice to prove finding B's defect and then the fix's
falsifiability. One guard fired for real — `check-foreign-staging.sh` blocked a `git add -A` that
would have swept two files belonging to no session (`logs/friction-log.md`, `logs/next-up.md`, dirty
before this session began); staging was redone by explicit path and those two remain untouched.

### Findings Declined
- **Codex cannot see a chat-pasted request** — declined as a queue item: it is finding A, corrected
  this session at `edd0d97`, and separately written up in full at `issue-codex-request-intake.md`
  with three options for later. Queueing it again would duplicate a live record.
- **Codex's Next instruction contradicted the turn it set** — same reason: finding A, corrected.
- **The 3.1(a) harness assertion tested a filename, not state** — finding B, corrected and
  falsifiability re-proven this session.
- **Finding C (both artifacts restate core policy)** — declined as a backlog item because it is the
  named blocking item in `step-6-candidate-review.md` § 6 and the scratchpad's `resume_with:`, which
  is a stronger and more specific channel than the improvement log. It is open, not dropped.
- **Claude's mandate footprint was too narrow** — declined: the existing guard caught it before any
  commit, which is the guard working as designed. No system change indicated.
- **Claude wrote a self-hosting review brief** — declined: the rule it broke is already stated in the
  mission's non-negotiables and Proposal § 6. The failure was reading, not a missing rule.

Findings: 7 — queued 1 (severity: medium-high), declined 6. 1 + 6 = 7.

### Next Steps
Mission `work-loop-v2-mvp`, Step 6 — **settle finding C**, then run the closure check (A, B, C plus
blocking regressions only — no second broad review), re-record the accepted commit and its four blob
hashes, write the disclosed-limitations list, tick the thread and commit. Everything needed is in
`plans/work-loop-v2-mvp/step-6-candidate-review.md`, which is self-contained. **Read
`logs/decisions.md:207-208` before choosing on C** — Slice 3 already rejected duplication citing the
same "link to the core, never restate" rule, which suggests the remaining restatement is partly a
judged trade-off rather than pure oversight.

### Open Questions
**One, blocking Step 6:** finding C — correct it fully, bound it to a disclosed limitation with a
pilot reopening trigger, or accept it outright. Deferred by the operator on 2026-08-01. Claude's
recommendation is the bounded option, with the stated caveat that Claude authored the artifacts.
## 2026-08-01 — Session S10-7e5

**Mandate:** Prepare a self-contained adjudication brief that lets Codex give an independent verdict on Work Loop v2 Step 6 finding C — done when: `plans/work-loop-v2-mvp/step-6-finding-c-adjudication-brief.md` exists, names every context file Codex must read by path, states the three recorded options and the two conflicts, discloses Claude's authorship conflict, and is committed
- Out of scope: settling finding C (operator will not decide before Codex's verdict); the Step 6 closure check, acceptance, limitations list and mission-thread tick (all blocked on that verdict); any second broad review; Step 7 work
- Files in scope: logs/session-notes.md
- Stop if: the brief would require Claude to pre-judge finding C, or would route the adjudication through `$work-loop-v2` (self-hosting, forbidden by Proposal § 6)
- Allowed inputs: plans/work-loop-v2-mvp/, logs/decisions.md, logs/missions/work-loop-v2-mvp.md, logs/scripts/work-loop-v2-slice-1.test.sh, .claude/commands/work-loop-v2.md, .agents/skills/work-loop-v2/SKILL.md
- Required outputs: plans/work-loop-v2-mvp/step-6-finding-c-adjudication-brief.md
- Context pack: output/context-packs/qc-20260801-c6f1a/pack.md
- Mission: work-loop-v2-mvp
- Mandate revised mid-session 2026-08-01 by operator directive: the original mandate was to settle finding C and close Step 6. The operator directed that Codex give an independent verdict on C first and stated they will not decide before it. Step 6 acceptance is therefore deferred, not abandoned.

**Work:** Work Loop v2 MVP Step 6 — prepare the Codex adjudication brief for finding C (revised from: settle C and accept the candidate)

### Summary
Step 6 closed this session, across a mandate revision mid-session. Started as "settle finding C and
accept the candidate"; the operator rejected letting Claude decide C given the authorship conflict
(Claude wrote all four candidate files) and directed Codex adjudicate independently. Codex ruled
option 1 (correct in full) against Claude's recommended bounded option, and separately corrected
Claude's own blast-radius measurement upward. Claude implemented the correction, Codex's closure
check returned **not resolved** on a sharp objection (the harness proved the old prompts' behaviour,
not the corrected ones), and the two live invocations that followed both passed — one run by a
fresh-context subagent, one by the operator in Codex. Step 6 closed at commit `fc6c07c`, accepted
candidate recorded by blob hash, six disclosed limitations written, mission thread ticked.

### Decisions Made
- **Operator decision: Codex adjudicates finding C, not Claude.** Claude authored all four candidate
  files; the operator had already rejected "let Claude choose" in the prior session
  (`logs/decisions.md`, 2026-08-01) and reaffirmed it by routing the decision to Codex rather than
  accepting Claude's recommendation directly.
- **Codex's verdict: option 1 (correct finding C fully)**, against Claude's recommended option 2
  (bounded correction with a reopening trigger). Recorded in `step-6-finding-c-verdict.md`.
- **The one core edit Codex authorised**: naming the shared `Correct once — frozen findings:`
  hand-off token once, in the core (§ 3), so removing it from both runtime artifacts would not orphan
  the interface.
- **Codex's closure check returned NOT RESOLVED on first pass** — not a rubber stamp. It required
  live verification of the corrected prompts before accepting, rather than trusting harness green.
- **The closure was cleared on pre-authorised evidence, not a second explicit Codex confirmation.**
  Codex's verdict stated in advance that both live checks passing would clear it. Claude applied that
  condition rather than asking Codex to confirm again. Flagged explicitly to the operator; the
  live-verification record is self-contained if the operator wants that explicit confirmation anyway.
- Routine: scratchpad, session note and mission-thread updates for the closed step.

### Outcome
(Outcome check skipped — not requested this wrap.)

### Session Value Audit — 80/20 Review
(Skipped — not requested this wrap.)

### Risky actions
None. The correction touched two runtime artifacts that other sessions and Codex depend on, but every
change was proven falsifiable before commit (three mutation-and-restore proof runs, 17/17 assertions
shown able to fail) and verified live before acceptance rather than trusted on harness-green alone.

### Findings Declined
- **The fresh-context reader's core § 6 / § 7 contradiction** (rule 2 says report-and-change-nothing;
  § 7's operator-stop procedure for the same case says write-and-commit) — declined as a queue item:
  it is recorded as disclosed limitation 5 in `step-6-candidate-review.md` § 8.5 with a reopening
  trigger, which is a stronger and more specific channel than the improvement log. Confirmed
  pre-existing rather than caused by this session's correction.
- **Claude's own measurement errors this session** (six→ten→eleven assertion count; one
  case-sensitivity miss in an early mutation-proof run) — declined as findings about process: both
  were caught by the falsifiability discipline itself (Codex's re-derivation; Claude's own re-run),
  which is the mechanism working as designed, not a gap to fix.

Findings: 2 — queued 0, declined 2. 0 + 2 = 2.

### Next Steps
Mission `work-loop-v2-mvp`, Step 7 — the v1 retirement decision (hard boundary at pilot start), then
pilot two or three real CRM / Email OS units, one with a mid-task session handoff. Read the six
disclosed limitations in `step-6-candidate-review.md` § 8.5 first — several name their reopening
trigger as "the pilot," so Step 7 is where they get tested for real.

### Open Questions
None. Step 6 is closed with no unresolved threads.
## 2026-08-01 — Session S11-cf1

**Mandate:** Make the Work Loop v2 v1-retirement decision (the hard boundary at pilot start), then open the Phase 3 pilot — start the pilot log and run the first genuine CRM or Email OS work unit through the MVP — done when: `plans/work-loop-v2-mvp/step-7-v1-retirement-decision.md` exists and the decision is recorded in `logs/decisions.md`; `plans/work-loop-v2-mvp/step-7-pilot-log.md` exists and holds pilot unit 1's record; one real CRM or Email OS unit has run end-to-end through `$work-loop-v2` with its task-state file in `logs/work-loop/`; and the mission's Step 7 threads reflect what actually closed, with evidence.
- Out of scope: Step 8 entirely (fixing pilot blockers, the regression set, the post-pilot assessment, executing the retirement); pilot units 2 and 3 and the mid-task session-handoff test (the handoff requires a later session by construction); redesigning the MVP; reopening any of the six disclosed limitations in `step-6-candidate-review.md` § 8.5 unless a pilot unit materially obstructs operation.
- Files in scope: plans/work-loop-v2-mvp/step-6-candidate-review.md, plans/work-loop-v2-mvp/work-loop-v2-mvp-proposal-v0.4.md, docs/work-loop.md, .claude/commands/work-loop.md, .claude/commands/work-loop-v2.md, .agents/skills/work-loop-v2/SKILL.md, logs/missions/work-loop-v2-mvp.md, logs/decisions.md, logs/session-notes.md
- Stop if: the only available pilot unit would have to be manufactured rather than genuine — Proposal § Phase 3 requires real work units, and a fabricated one tests nothing; or a pilot observation would enter MVP scope without having materially obstructed useful operation (the Proposal's pilot presumption is no change).
- Allowed inputs: plans/work-loop-v2-mvp/, docs/work-loop.md, docs/work-loop-spec.md, .claude/commands/work-loop.md, .agents/skills/work-loop/SKILL.md, .claude/commands/work-loop-v2.md, .agents/skills/work-loop-v2/SKILL.md, logs/missions/work-loop-v2-mvp.md, logs/decisions.md, logs/work-loop/, projects/axcion-crm/, projects/axcion-systems-builder-email-os/
- Required outputs: plans/work-loop-v2-mvp/step-7-v1-retirement-decision.md, plans/work-loop-v2-mvp/step-7-pilot-log.md, logs/work-loop/{pilot-unit-1-task-id}.md
- Mission: work-loop-v2-mvp

**Work:** Work Loop v2 MVP Step 7 — v1 retirement decision, then pilot real CRM / Email OS units

## 2026-08-01 — Work Loop v2 pilot unit 2 closed with one correction round; Step 8 scope amended

### Summary

Resumed mid-pilot from the prior handoff and ran pilot unit 2 (`decision-entry-referenceability`)
end to end. The defect: `logs/decisions.md` in `axcion-systems-builder` had drifted into two entry
shapes, and `check-decision-refs.sh` indexes `##` headers only — so an entry opening as a bare bold
`**Decision …**` paragraph was structurally unreferenceable and produced **no orphan to notice**,
because no ref could ever be written for it. Silent negative evidence. Codex widened the objective
from one repo to the three actual owners of the contract; Claude checked six premises (all held),
wrote the fixture red first (3 failures), implemented, and normalized four entries by pure insertion.
Codex then froze **one** finding — a fifth entry Claude had reported but deliberately not touched —
proved its boundary from `session-notes.md` rather than from Claude's style inference, and closed
after one bounded round. **Condition 4 (one bounded correction on real work) is now exercised**, which
was the honest gap after unit 1. Separately, an operator question about installation portability
surfaced that FP-3's reopening trigger had **already fired unnoticed**: v2 is installed in three
projects, and the third holds an untracked byte-identical *copy* of the command with no core, no
skill and no `logs/work-loop/`.

### Decisions Made

**Operator decisions:**

- **Accept Claude's unit-2 recommendation** (the `check-decision-refs.sh` headerless defect) over the
  `check-foreign-staging.sh` tokenizer defect. Claude's stated ranking reason: the tokenizer's target
  is a shared hook every commit passes through, and editing it live while piloting through that same
  hook is avoidable risk.
- **Add portable installation to the pipeline** — *"If not, we need to add it."* Logged to
  `decisions.md` with the split Claude applied.
- **Route the fifth-entry question to Codex** rather than have Claude decide it inline.

**Claude decisions, within authority:**

- **Did not normalize the fifth headerless entry.** Evidence was a dated-vs-undated convention read
  off the file — consistent across all 12 dated paragraphs, but a pattern inferred, not a rule the
  journal states. Judged too weak against a governance record; handed back as an open question.
- **Split item 14 rather than adopting it whole** (bounded half → Step 8; full contract → post-MVP
  thread), because Step 8 is "fix demonstrated blockers only" and ends "stop; do not keep designing
  it". Operator told they can override and widen it.
- **Ticked the Step 7 retirement-decision thread**, which was done at `960dcae` and left unchecked.
- Routine: three scoped commits by explicit pathspec across three repos; the workspace root has eight
  modified and many untracked files from other sessions, none of which were swept in.

### Risky actions

**Shared-surface change, reviewed:** `logs/scripts/check-decision-refs.sh` is the single copy every
repo's wrap invokes, and it was modified. Covered by 65 assertions, verified not to fire on
conformant repos (`ai-resources` and workspace root both 0 findings, exit 0), and independently
re-run by Codex before closure. **Near-miss:** a fabricated commit hash (`1f8a0e1`) was written into
the unit's state file before that commit existed — caught before committing and replaced with a
reference to HEAD; now recorded as FP-6. No destructive git operations, no push, no external write.

### Findings Declined

- **The append-order guard is unwired in `axcion-systems-builder`** (`.git/hooks/` holds only samples,
  `core.hooksPath` unset) — declined as already covered by the queued item "Hook BODIES are versioned;
  hook WIRING is not" (`promote:379fec7dc59a`). The *new* half (the guard's KNOWN LIMIT) was queued
  separately rather than folded in.
- **Two self-caught recall-instead-of-check errors** (a paragraph count stated as 13 when it was 12;
  the fabricated commit hash) — declined as duplicates of the queued item "I state repo facts from
  recall instead of checking them" (`promote:f034f079ad5b`). Both were caught and corrected in-session;
  the hash one is separately queued as FP-6 because its hazard is in the loop's ordering, not in recall.

### Next Steps

**Unit 3, designed as the mid-task session-handoff test.** Three pilot conditions have never been
exercised — 3 (state recovery), 5 (Direct Work bypass), 7 (clean fresh-session continuation) — because
both units so far ran start-to-finish in one session and both were admitted to the loop. Unit 3 must
carry them or they get recorded as untested. Run it as: Codex opens → Claude checks premises and gets
partway → session deliberately stops → a fresh session finishes from the state file and Git alone.
Starting it fresh next session makes the handoff more genuine than forcing it tonight. Recommended
candidate: the `check-foreign-staging.sh` footprint-tokenizer defect.

Then Step 8, which is now heavier than it looks: the v1 retirement execution obligations (§ 4 of the
retirement record) **plus** the newly named portable-installation blocker.

### Open Questions

- **The usefulness judgment, still owed by the operator.** Mission acceptance assertion *"At least two
  real CRM / Email OS units have completed through the loop **and the operator judged the outcomes
  useful**"* has its count met after unit 2 but remains deliberately unticked — only the operator can
  supply the judgment. Asked twice this session, not yet answered.
- **The fate of `axcion-design-studio`'s stray command copy** — named in the Step 8 scope, not yet
  actioned.
## 2026-08-01 — Session S12-3bc

**Mandate:** Run pilot unit 3 of the Work Loop v2 MVP (Step 7) as a deliberate mid-task session-handoff test — Codex opens the unit, Claude checks its premises and implements partway, then this session stops so a fresh session finishes from the state file and Git alone — done when: unit 3's state file exists under `logs/work-loop/` carrying Codex's opening brief, Claude's premise-check record and a partial implementation; that state file is committed and this session stops mid-unit, leaving a fresh session able to finish from it and Git alone; and `plans/work-loop-v2-mvp/step-7-pilot-log.md` § Unit 3 records the unit as open with its status against conditions 3, 5 and 7.
- Out of scope: Step 8 entirely — fixing demonstrated blockers, running the regression set, the post-pilot assessment, executing the v1 retirement, and the portable-installation blocker.
- Files in scope: plans/work-loop-v2-mvp/step-7-pilot-log.md, plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md, .claude/commands/work-loop-v2.md, .agents/skills/work-loop-v2/SKILL.md, .claude/hooks/check-foreign-staging.sh, .codex/hooks/check-foreign-staging.sh, logs/missions/work-loop-v2-mvp.md, logs/session-notes.md, logs/work-loop
- Stop if: Codex has not opened unit 3 (no opening brief on disk) — Claude cannot open it, so the loop stalls there by design; or the candidate unit's premise fails the check (the `check-foreign-staging.sh` footprint-tokenizer defect no longer reproduces) — hand back rather than build.
- Required outputs: logs/work-loop/foreign-staging-target-repo.md, logs/scripts/check-foreign-staging.test.sh
- Mission: work-loop-v2-mvp

**Work:** Continue the Work Loop v2 pilot — unit 3 as the mid-task session-handoff test

### Summary
Ran Work Loop v2 pilot unit 3 (Step 7), designed from the start as the mid-task session-handoff test —
the last of three pilot conditions never exercised in units 1 and 2 (state recovery, the Direct Work
bypass, clean fresh-session continuation). Codex opened the unit against the recorded
`check-foreign-staging.sh` nested-repo defect; Claude checked all five of Codex's premises by
execution, built a permanent isolated-repo test harness (4 red / 2 green against the unmodified hook),
found an unrecorded silent-pass failure mode the original defect entry does not mention, and stopped
deliberately mid-task with a self-contained checkpoint. The hook itself was never touched this session.

### Decisions Made
- **(Codex)** Scoped Unit 1 narrowly — canonical hook plus a permanent harness only; docs, the defect
  record, the `.codex` fork and the sector-intelligence copy explicitly held to later units. Excluded
  the backlog entry's own "soft warn" fallback (both prior gates rejected it) and the retired
  `/risk-check`.
- **(Claude)** Rebuilt the premise-check as an isolated `mktemp -d` harness after Codex's brief
  required it, discarding an earlier live-working-tree reproduction that depended on ambient dirt and
  would not have survived a re-run (FP-7).
- **(Claude)** Corrected the harness's own fixture after running it exposed that C3 was going red for
  the wrong mechanism (blocking on an untracked `nested/` dir rather than reproducing the documented
  silent pass) — added a `.gitignore` line mirroring the live workspace's actual invisibility, commented
  in place (FP-8).
- **(Claude)** Recorded, rather than silently accepted, that two of six harness assertions (C2, C6)
  pass even against a dead no-op hook — proved with a stub swap — and named the remedy (a
  positive-identity assertion on C2) instead of shipping a harness with an undisclosed blind spot (FP-9).
- **(Claude)** Verdicted pilot conditions 3 and 7 as PENDING rather than yes — the checkpoint is staged
  and self-contained, but only the resuming session can prove the handoff actually works. Verdicting
  them now would close by assertion, the exact failure this pilot has avoided twice already.
- **(Claude)** Did not attempt to exercise condition 5 (Direct Work bypass) inside this unit — the
  defect is not small and reversible, so it was correctly admitted; manufacturing a small unit to force
  the condition would breach the pilot's genuine-units constraint. Recorded as still owed.

### Outcome
Outcome check skipped (not requested).

### Session Value Audit — 80/20 Review
Skipped (not requested).

### Risky actions
None destructive. The hook that gates every commit in this repo (`check-foreign-staging.sh`) was the
subject under test but was never edited — the plan's stop point (state file committed before any hook
edit) was never reached this session, since the session stopped at the premise-check/harness stage.
Both mission-file-adjacent writes (pilot log, session notes) were ordinary content edits, not
frozen-prefix mission-file writes. No destructive git operation, no push, no external write.

### Findings Declined
None this session beyond FP-7/FP-8/FP-9, which are recorded in full in the pilot log
(`plans/work-loop-v2-mvp/step-7-pilot-log.md` § Unit 3 § Friction points) and in the state file
(`logs/work-loop/foreign-staging-target-repo.md`) — not duplicated into `improvement-log.md`, since
they are pilot-run observations whose correct durable home is the pilot's own record, per the same
reasoning prior units applied to their own friction points.

Findings: 0 — direct review (this was a build/verify session, not an audit) produced no candidate for
`improvement-log.md` beyond what's already durably recorded above.

### Session Assessment
Skipped (not requested).

### Next Steps
- **Resume Work Loop v2 pilot unit 3 in a fresh session, from `logs/work-loop/foreign-staging-target-repo.md` and Git alone.** First action: settle whether a PreToolUse hook's process cwd equals the Bash tool's cwd or the project root — by execution, not inference. This requires temporarily registering a throwaway probe hook in `~/.claude/settings.json`, which is a gated harness-config change — **ask the operator before doing it.**
- Once settled, implement the smallest resolver satisfying Codex's four required behaviours (fail closed on any unparseable wide-add shape), re-run `logs/scripts/check-foreign-staging.test.sh` to 6/6 green, and re-verify against a dead-hook stub that it still reports failure.
- Separately, whenever a genuinely small real fix comes up, route it through `/work-loop-v2` to exercise condition 5 (Direct Work bypass) — do not manufacture one.
- Continuity scratchpad: `logs/scratchpads/2026-08-01-21-30-scratchpad.md`.

### Open Questions
**The usefulness judgment, still owed by the operator, asked a third time across three sessions.**
The mission's definition of done requires the operator's judgment that the loop produced useful real
work, not merely a count of completed units. Three units have now closed or reached their designed
stopping point. Not answered this session.
## 2026-08-01 — Session S13-ad0

**Mandate:** Resume Work Loop v2 pilot unit 3 from its state file and Git alone — settle the PreToolUse hook cwd question by execution, implement the smallest resolver in check-foreign-staging.sh, and record the unit's outcome in the pilot log — done when: logs/scripts/check-foreign-staging.test.sh reports 6/6 green against the fixed hook; the same harness still reports failure when run against a dead-hook stub; and plans/work-loop-v2-mvp/step-7-pilot-log.md § Unit 3 records the outcome with an evidenced verdict on pilot conditions 3 and 7.
- Out of scope: Step 8 entirely (demonstrated-blocker fixes, the regression set, the post-pilot assessment, the v1 retirement, the portable-installation blocker); manufacturing a unit to exercise pilot condition 5 (the Direct Work bypass) — it waits for a genuinely small real fix; the .codex fork of the hook, the defect record and the sector-intelligence copy, all three held to later units by Codex's opening brief.
- Files in scope: logs/work-loop/foreign-staging-target-repo.md, .claude/hooks/check-foreign-staging.sh, logs/scripts/check-foreign-staging.test.sh, plans/work-loop-v2-mvp/step-7-pilot-log.md, logs/session-notes.md, ../projects/axcion-sector-intelligence/.claude/hooks/check-foreign-staging.sh (widened mid-session: Codex opened Unit 2, which authorises the sector-fork backport; declared rather than committed silently)
- Stop if: the operator declines the throwaway probe hook in ~/.claude/settings.json and no other execution-based way exists to settle the hook-cwd question — stop rather than infer it; or the harness comes back green against the unmodified hook, meaning the recorded defect no longer reproduces — hand back rather than build.
- Mission: work-loop-v2-mvp

**Work:** Resume Work Loop v2 pilot unit 3 from the state file and Git alone — settle the hook-cwd question by execution, then implement the resolver to 6/6 green
## 2026-08-01 — Work Loop v2 pilot task `foreign-staging-target-repo` closed; FP-12 and the pilot's own result

### Summary
Continuation of S13-ad0 (no `/prime` this session; mandate inherited from S13's block above). Verified
Codex's Unit 2 assessment against the live repo rather than its summary — all five claims held —
then executed the closure unit: the operator-facing contract in `docs/commit-discipline.md`, the
originating defect marked RESOLVED, and its promoted queue item retired. Codex passed the closure unit
with no correction. Task closed; state file reduced to the closing record at `turn: operator`.

### Decisions Made
- **`logs/next-up.md` added to the unit's scope (operator decision)** — one checkbox only, to retire
  promoted item `8c600934fdd0`. Codex had stopped for this. Declining would leave `/prime` re-offering
  finished work every session.
- **Codex's claimed prohibition on approving/closing work was rejected on evidence.** No such rule
  exists — searched `docs/qc-independence.md`, `AGENTS.md`, `.codex/` and the core. The only live rule
  is *"Who commits: Claude"* (core `:227-231`), a `.git`-access fact, not a verdict restriction; the
  core assigns closure to Codex explicitly at `:74`. **No authorization was requested or granted.**
- **Contract statements 4 and 5 documented at disclosure level with no permanent harness case** —
  accepted by Codex on the grounds that they disclose limitations rather than promise protection.
- **The live-file falsification is one-off evidence only, not a reusable harness pattern** (Codex).
- Routine: committed S13's two stray artifacts (run manifest, session plan) alongside the closing
  record rather than leaving them untracked.

### Risky actions
The boundary-check falsification run mutates the **live** `logs/next-up.md`, and its first execution
left a second checkbox (`890b40e5ea5c`) ticked. Caught immediately, restored by hand, and the check
re-run clean — the PASS on record is post-restore. Disclosed to Codex rather than smoothed over, and
Codex ruled it acceptable as one-off evidence but explicitly not as a reusable pattern. Separately:
Codex asked the operator to override a governance rule that does not exist; the override was **not**
granted, and would have created a standing exception to a non-existent prohibition.

### Findings Declined
- *The core's § 4 / § 3-step-5 cross-reference gap that produced FP-12* — recorded in the pilot log as
  a one-line fix to apply during Step 8, not queued separately. Declining a duplicate queue entry: it
  is already carried where the work will happen, and the mission thread is its owner.

### Next Steps
- **The pilot exit decision is the operator's** — `plans/work-loop-v2-mvp/step-7-pilot-log.md`
  § Pilot exit condition. Read § The pilot's own result first; the input is written, the judgment is
  not made.
- Mission `work-loop-v2-mvp` Step 8 — retirement obligations plus the installation blocker.
- Pilot condition 5 (Direct Work bypass) remains owed; it must not be manufactured.

### Open Questions
- Whether v0.2 keeps the adversarial review and sheds the bookkeeping. The evidence points there; the
  call is the operator's and is not made here.
