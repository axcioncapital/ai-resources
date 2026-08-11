# Work Loop v2 — bounded-execution fix plan, v0.2

**Written 2026-08-11 by Claude, under Work Loop v2 task `work-loop-v2-bounded-execution-fix-plan`,
Unit 1. Corrected once on 2026-08-11 against five frozen findings from Codex. Revised on 2026-08-11
into this v0.2 against six findings from an independent SOP-conformance review.** Planning artifact
only. Nothing here is authorized or implemented; every unit below is a proposal for Codex to assess
and the operator to approve.

**Supersedes `bounded-execution-fix-plan-v0.1.md`, which is retained unchanged.** v0.1 is the version
the closed planning task accepted; it stays on disk and stays referenced from that task's closing
record. This file is the version any further work reads.

**What this addresses.** On 2026-08-10 a Work Loop v2 task escaped its bounded courier path. The
dispatcher hit a permission dead end, misreported the resulting state, and Codex responded by driving
an interactive Claude session by hand — which removed the timeout, the one-hop bound, the run log,
the allowlist check and the process-tree teardown all at once. Inside that session Claude spawned at
least eight further `claude -p` processes to test Markdown instruction files. The task consumed ≥13
Claude processes; the four *recorded* dispatcher launches alone were 25m13s, 92 turns, 108,908 output
tokens and $11.34.

**What this plan is not.** It is not a larger control system, and it is not an approved design. It is
a candidate inventory plus a route to a design decision. Its net proposed permanent machinery is
**zero new mechanisms** — see § 3.

---

## 0.0 What changed in v0.2

Six findings from an independent review of v0.1 against the Repository Problem Resolution SOP. The
review's verdict was **ready with revisions for evidence gathering; not ready for implementation** —
it did not invalidate v0.1, and no finding overturned a classification, a ladder verdict or an
outcome. Each is resolved below.

| # | Finding | Resolution | Where |
|---|---|---|---|
| 1 | The SOP's **B5 design challenge** was missing — Codex challenges Claude's diagnosis, complexity, scope and tests *before* operator approval | Added as route step 4, ahead of the approval gate. Gate 3 now names it as a precondition | § 0.3, § 0.4 |
| 2 | The plan's causal and mechanism claims read as settled when Gate 2 has not been passed | All six are now labelled **HYPOTHESIS**, with the supersession rule stated. Inline tags at the points of use | **new § 0.6**, § 3.2, § 4, § 11 |
| 3 | "Cannot start nested work" overclaims what the proposed deny rule proves | Narrowed everywhere to *the default direct route is denied at the permission layer*, which is not containment | § 3.1, § 4 (O1), § 5 (U1) |
| 4 | The SOP's **B1 context manifest** was incomplete — no base commit, scope, exclusions, tests, authority gaps or current outcome | § 0.5 rewritten as the complete manifest. Still no new file, per § 7 | § 0.5 |
| 5 | Implementation was not treated as **high-risk** under the SOP | Classified high-risk, with the three obligations it carries. The workspace review-rule tension is surfaced, not silently resolved | **new § 6.5** |
| 6 | U7 proposed a new artifact for the `runs/` decision framing | **U7 retired as a unit.** The framing is written into § 8, beside the operator decision already framed there | § 5, § 7, § 8 |

**The review's own caveat, carried forward:** the SOP remains advisory. Its gate vocabulary is a
consolidation the SOP itself says must be confirmed before adoption (`:59`), and the Independent
Review SOP it defers to for verdicts does not exist in this checkout (`:37`, `:278`, `:1020`). Both
are recorded as authority gaps in the manifest (§ 0.5) and neither blocks the work — the SOP's own
`:372` requires exactly that handling.

---

## 0. Method, gate position and recovery chain

### 0.1 What method governs, and what only advises

The **Work Loop v2 executable core** governs — roles, the unit cycle, the state file, correction,
stopping. `.agents/skills/work-loop-v2/references/repository-problem-resolution-sop.md` (the SOP) is
applied here as **non-governing methodology context, subordinate to the core**. Its outcome and gate
vocabulary annotates this plan; it does **not** become a state-file field, does not create a second
state system, and does not override the core's close / continue / correct once / stop. Where the two
disagree, the core wins and the disagreement is reported.

Work Loop vocabulary is unchanged throughout: task, unit, brief, discovery unit, state file, lane,
mode, correction, evidence, deferral, continue, close.

**The SOP's own authority is incomplete, and that is recorded rather than resolved.** Its gate and
verdict vocabulary is a consolidation of three incompatible source gate sets, which the SOP flags as
"a decision, not a finding — confirm it before adopting" (`:59`). The Independent Review SOP it names
as owning that vocabulary (`:37`), as governing review depth (`:278`), and as holding an unresolved
authority overlap with it (`:1020`) does not exist in this checkout. Two sibling documents it names
are likewise absent. These are authority gaps in the manifest (§ 0.5), handled as `:372` directs:
recorded, then proceeded past. **No governance document is created to close them** — `:372` forbids
that too.

*(Note of record: the SOP was committed to this repository at `3ef4313`, 2026-08-11 09:32 — one
minute after this plan's first version was committed at `95d10c1`, 09:31 — and was not among the
brief's named sources. That is why the first version did not apply it. It applies now.)*

### 0.2 Provisional qualification — this parent case is structural

Qualified against the SOP's Lane B triggers, provisionally, on current evidence. Four of the six
triggers are met. Each row's evidence is **OBSERVED** — current-code inspection or a preserved
record — and none of it is a causal claim; the causal claims live in § 0.6 and are hypotheses.

| Trigger | Evidence | Class |
|---|---|---|
| Crosses workflow / component / ownership boundaries | The failure spans the dispatcher (`dispatch.sh`), the Codex operating instructions (`SKILL.md`), the Claude command, and the operator's own transport behaviour. No single component owns it | OBSERVED |
| Changes a shared mechanism or the operating model | The courier is the shared mechanism between Codex and Claude (core § 4). Any accepted fix changes how it launches actors or how a stop is read | OBSERVED |
| Produced false-success or false-report behaviour | The dispatcher returned `STOP [25]` claiming Claude had edited the state file when the file was byte-identical and already dirty before launch (claim 2a, § 1). The system reported a specific cause that had not occurred | OBSERVED |
| Survived a relevant prior control | `SKILL.md:195` already prohibited screen-driving Claude, in force, and the bypass happened anyway | OBSERVED |

The two remaining Lane B triggers — ambiguous authority over shared state, and repeatedly generated
compensating controls — are **not** claimed. Ambiguity of authority was not observed; core § 4 is
clear about who commits and who decides. And this is the first compensating-control round, not the
third.

**This qualification is provisional and rerouteable.** If the causal work at the next gate shows the
condition is bounded and locally correctable after all, the case drops to a normal repair rather than
completing a structural process for its own sake.

**Individual fixes stay bounded.** Structural qualification applies to the *parent case*. It does not
convert each unit below into a structural change, and it does not license a larger intervention than
the proven mechanism requires.

### 0.3 Gate position — stated honestly

| Gate | State | Basis |
|---|---|---|
| 1 — Admission (qualifies as structural, worth doing now) | **Qualification provisional (§ 0.2); priority settled by the operator: Proceed now** | The operator's 2026-08-11 request settles priority. It does **not** approve a technical design, a mechanism, or a scope |
| 2 — Failure proof | **NOT complete** | § 1 establishes the *current state of the code* by inspection. It does not establish the *failure* from the preserved run evidence of 2026-08-10, and no independent party has read that raw evidence |
| 3 — Design approval (causal model supported, intervention approved) | **NOT reached.** Now carries two named preconditions: the blind evidence review (route step 3) and the **B5 design challenge** (route step 4) | No causal chain has been stated with a disproving observation, no blind independent review has run, no design challenge has run, and the operator has approved no design |
| 4 — Technical verification | **NOT reached** | Nothing is implemented. Implementation is classified **high-risk** and carries the § 6.5 obligations |
| 5 — Operational closure | **NOT reached** | Nothing is integrated, and no representative use has happened |

**What exists today is a candidate inventory, not a diagnosis.** §§ 1 and 2 are inspection of current
code and classification of supplied proposals. Neither is failure proof, an independent challenge, a
supported causal model, or design approval. This plan does not claim any of those were completed, and
its recommendation in § 11 is a recommendation *for the next gate*, not an authorization.

### 0.4 The tailored route from here

Nine steps, tailored to this case. No new state system, no new artifact kind, no second task-state
file. Each step's product is either a section of this plan, a state-file field the core already has,
or a Work Loop unit.

0. **The context manifest is complete before discovery begins.** § 0.5 below. It fixes the base
   commit, the scope, the exclusions, the tests, the authority gaps and the current case outcome, so
   the discovery unit inherits a bounded surface rather than a general link to the repository — which
   is how `:368` says an investigation turns into a redesign. *Done in this revision.*
1. **Establish the failure from preserved evidence, not a live reproduction.** The SOP permits this
   explicitly (`:382`) where reproduction is costly or unsafe, and here it is both — reproducing a
   runaway nested-AI session is the exact expense this case exists to prevent. The evidence already
   exists: the four dispatcher run logs and hop captures, the `STOP [25]` output, the state file of
   the incident task, and the incident worktree's Git history (`ea77d66`, `9a8399c`). This is a
   **discovery unit**, not an implementation unit. Every material statement carries OBSERVED /
   INFERRED / PROPOSED / UNKNOWN (`:384`).
2. **Blind raw-evidence review by a genuinely fresh Codex context.** That reviewer receives the
   problem statement and the raw evidence only — never this plan, never Claude's diagnosis, and
   never a document that links to either. The Codex context that framed this task cannot perform it,
   whatever instructions it is given.
3. **Claude reconciles the review into a causal model and options.** Causal chain with each link
   named, competing explanations, confidence, and — required — the observation that would disprove
   the diagnosis. Options compared down the ladder in § 3, not from the bottom up. This step
   **rebuilds** § 0.6's hypotheses from evidence and may supersede any of them.
4. **Codex challenges the diagnosis and the complexity — SOP step B5 (`:606-612`).** *Added in v0.2.*
   Codex sees Claude's reasoning and attacks it: whether the evidence supports the causal mechanism,
   whether correlation was treated as causation, whether another explanation fits equally well,
   whether the proposal changes the mechanism or merely adds instructions above it, whether old
   machinery survives underneath, whether removal or an operating restriction would be safer, what
   new failure modes and maintenance the correction creates, whether the scope is proportioned, and
   which proposed changes should be cut entirely.
   **This review does not need a fresh context** (`:608`) — the anchoring risk it guards against has
   already passed at step 2, so the Codex context that ran steps 2–3 may run it.
   **Complexity budget zero (`:612`).** Any new permanent mechanism must answer seven questions: what
   verified failure requires it; why removal or a process restriction cannot solve the issue; which
   existing mechanisms were considered; what maintenance it creates; who owns that maintenance; how
   it fails visibly; how it is removed later. This plan proposes zero new permanent mechanisms
   (§ 3.2 rung 4, § 3.3), so the questions should be answerable trivially — and if any unit cannot
   answer them, that unit is the one B5 is meant to cut.
5. **Operator approves the scope.** Trade-off, not code: what changes, what stops happening, what is
   removed rather than added, whether permanent machinery goes down, how it is reversed. This is the
   gate the current plan has **not** passed.
6. **Implement in an isolated clean checkout** — a deliberate branch or worktree at an agreed clean
   base, opened as a **new Work Loop task**. Never by copying this task's state file (§ 6.4).
   Implementation is **high-risk**; § 6.5 states what that adds.
7. **Independent verification from a clean environment**, running the commands rather than reading
   Claude's report — plus the **additional independent review** high-risk changes require (§ 6.5).
8. **One genuine attended pilot**, budgeted in advance: one task, at most one Claude actor
   invocation, ten minutes wall-clock, no nested AI, no scenario matrix.
9. **Close on observed behaviour.** Harness success alone does not close the parent case (§ 6).

### 0.5 Context manifest — complete, compaction-safe, and no new file

This is the SOP's **B1 context manifest** (`:364-374`) and the durable recovery chain in one place.
If context is lost, this is what re-establishes the work. It lives here, in the plan, not only in
chat. **No context manifest file, case database, second task-state artifact or any other new file is
created to hold it** — § 7 and core § 3 step 3 both forbid that, and `:372` forbids creating
governance documents to satisfy this step.

**Complete as of 2026-08-11, ahead of the discovery unit.** *(v0.1 carried the anchor rows only; the
scope, exclusions, tests, authority-gap and outcome rows are added in v0.2.)*

#### Repositories and base commits

| Field | Value |
|---|---|
| Bound checkout | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources` |
| Base commit — bound checkout | **`a61708e`** ("session: wrap — Work Loop v2 bounded-execution fix plan closed", 2026-08-11) |
| Incident checkout (evidence source, **read-only**) | `../ai-resources-diagnostics-workflow` |
| Base commit — incident checkout | **`9a8399c`** ("update: diagnostics-workflow correction round — findings 1 and 3 resolved, finding 2 partial", 2026-08-10), on top of `ea77d66` |
| Implementation base | **Not yet agreed.** Route step 6 opens a new task on a deliberate branch or worktree at a base the operator agrees then. It is not `a61708e` by default |

#### Anchors

| Anchor | Value |
|---|---|
| Active state file | `logs/work-loop/work-loop-v2-bounded-execution-fix-plan.md` (planning task — **closed**) |
| Candidate plan | `plans/work-loop-v2-v0.2/bounded-execution-fix-plan-v0.2.md` (this file) |
| Superseded plan, retained | `plans/work-loop-v2-v0.2/bounded-execution-fix-plan-v0.1.md` |
| Governing contract | `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` |
| Operating interfaces | `.agents/skills/work-loop-v2/SKILL.md` (Codex), `.claude/commands/work-loop-v2.md` (Claude) |
| Methodology reference (non-governing) | `.agents/skills/work-loop-v2/references/repository-problem-resolution-sop.md` |
| Workflow phase | Route step 0 complete; step 1 of 9 not yet started (§ 0.4). Gates 2–5 open (§ 0.3) |
| Current move | This one bounded plan revision. Claude implements no fix, runs no dispatcher or harness, and launches no nested AI |

#### Forensic evidence available to the discovery unit

Preserved, already paid for, and sufficient for the `:382` forensic route. **Read-only in every case.**

- The four recorded dispatcher run logs and their hop captures, under
  `plans/work-loop-v2-v0.2/handoff-automation-spike/runs/`.
- In the incident checkout, three run files that remain **untracked** there and are therefore
  loss-exposed until the § 8 `runs/` decision is made: `20260810T151601-8db95197-34454-diagnostics-workflow.log`,
  `.hop1.claude.out`, `.hop1.claude.tree`.
- The `STOP [25]` output and its message text.
- The incident task state file `logs/work-loop/diagnostics-workflow.md` in the incident checkout —
  **uncommitted there**, and therefore also loss-exposed.
- The incident checkout's Git history: `ea77d66`, `9a8399c`.
- The postmortem, `~/.codex/attachments/c97f82c6-…/pasted-text.txt` (290 lines).

**Preservation obligation, before the discovery unit reads anything:** the loss-exposed items above
live only in one working tree. `:366` requires the repository state to be recoverable and unrelated
work to stay untouched. The discovery unit therefore copies what it needs into its own evidence
surface, or the operator commits them in that checkout — it does **not** stage or commit unrelated
work there to make them safe.

#### Previous related cases

- `logs/work-loop/axcion-harness-v0-2-p0-f-attended-policy.md` — the closed attended-policy decision
  (`turn: operator`, 2026-08-09). Constrains § 8 decision 1.
- `plans/work-loop-v2-v0.2/unattended-operation-plan-v0.2.md` — Phase 1 item 1a (narrowed, not
  closed) and § *Deferred*. Constrains U8 and U9.
- `plans/work-loop-v2-v0.2/core-resolver-argument-substitution-defect-report-2026-08-10.md` and
  `…-worktree-defect-report-2026-08-09.md` — prior dispatcher-adjacent defects in the same spike.

#### Tests that must be run

- **`plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`** — the dispatcher's own
  simulated harness, and the default verification instrument for every unit (§ 5).
- **Re-derive the baseline by execution before using it.** The `pass=375 fail=0` figure this plan
  quotes is a **recorded** number from `logs/work-loop/axcion-harness-v0-2-p0-f-attended-policy.md:47`,
  not re-derived in this revision. `:362`'s authority hierarchy puts reproducible execution above a
  historical record, so the implementing unit runs it rather than inheriting the number.
- **Do not conflate the two harnesses.** `logs/scripts/work-loop-v2-slice-1.test.sh` carries a known
  red baseline — 147 pass / 2 fail, from a stale `KNOWN_WORKLOOP_FILES` allowlist rather than a logic
  defect (`logs/improvement-log.md`, 2026-08-02). That is a **different** harness and does not bear on
  `dispatch.test.sh`. Recorded here so a future session does not read the red baseline as this
  plan's.

#### Approved investigation scope

The discovery unit establishes **what happened on 2026-08-10**, from the preserved evidence named
above, and nothing else. It produces the eight B2 outputs (`:408-421`) and classifies every material
statement. It writes no fix, proposes no design, and modifies no file outside its own result.

#### Explicit exclusions

- **No live reproduction of the incident**, and no dispatcher run of any kind.
- **Zero nested Claude or Codex invocations**, in every unit including closure checks.
- **No write into the incident checkout** beyond what the preservation obligation above permits, and
  no staging or committing of unrelated work in either checkout (`:366`).
- **No settings.json in any layer.**
- **No change to the executable core.** Core changes are not this task's to make.
- **No `.gitignore` change and no `git add` of run evidence** before the § 8 decision is taken.
- **No new file, field, artifact or stage** (core § 3 step 3, core § 4's five-field ceiling, § 7).

#### Authority gaps — recorded, not closed

Handled per `:372`: recorded in the manifest, proceeded past, and **not** closed by writing a
governance document.

1. **The SOP's gate and verdict vocabulary is unconfirmed.** `:59` says the consolidation "is a
   decision, not a finding — confirm it before adopting". It has not been confirmed. This plan
   therefore uses the vocabulary as annotation only (§ 0.1) and never as a state-file field.
2. **The Independent Review SOP does not exist in this checkout.** The SOP defers to it for review
   depth, verdicts and adjudication (`:37`, `:278`) and records an unresolved authority overlap with
   it (`:1020`). Every verdict word this plan borrows is therefore borrowed from a document that is
   not present.
3. **Two further sibling documents are absent** — the Codex–Claude Session Operating SOP and the AI
   Development Lifecycle SOP (`:37`).
4. **The workspace Independent Review Rule and the SOP's high-risk clause do not agree** on how many
   reviews a consequential change gets. Surfaced and resolved in § 6.5 rather than here.

#### Current case outcome (SOP vocabulary)

**Proceed — structural resolution**, provisionally (§ 0.2). Non-terminal. It is **not** *Resolved*,
which the SOP reserves for a correction that was verified, integrated and survived representative
use — none of which has happened. If the discovery unit cannot establish the failure from the
preserved evidence, the case takes **Not confirmed**, which is a valid result and is not *No action
justified* (§ 6.3).

### 0.6 Evidential status of the causal claims — all six are HYPOTHESIS

*New in v0.2, and the most consequential change in it.* Gate 2 has not been passed (§ 0.3), and
`:378` is explicit: no diagnosis or solution design begins until the failure is established. v0.1
respected that at the level of its section headings but still carried causal statements in prose that
read as settled. They are not settled. Every one of them is listed here, classified, and bound by the
supersession rule below.

**None of these is OBSERVED.** § 1's seven claims *are* OBSERVED — they are current-code inspection,
each traceable to a file and line. The difference matters: knowing what the code does today is not
knowing why the incident happened.

| # | Claim | Class | Stated at |
|---|---|---|---|
| **H1** | The incident's cost had two mechanisms — unbounded nesting, and the interactive bypass | INFERRED | § 4 *Why these four* |
| **H2** | The bypass had one cause: the dispatcher reported the wrong thing, and the right thing was unavailable | INFERRED | § 4 *Why these four* |
| **H3** | The triggering condition was a brief that demanded behavioural verification of Markdown instruction files, satisfiable only by invoking Claude | INFERRED | § 3.2 rung 1 |
| **H4** | Nesting is the mechanism that turned one unit into ≥13 Claude processes | INFERRED | § 11 |
| **H5** | A precise stop removes the *reason* to reach for an interactive session | PROPOSED | § 2, P0 candidate 2 |
| **H6** | Fixing the mechanisms without the cause leaves the same temptation in place under a new prohibition | PROPOSED | § 4 *Why these four* |

**What would disprove the set.** Evidence from the preserved run logs that the runaway cost came from
a single long session rather than from nested invocations. That would falsify H1 and H4 directly, and
would leave O1 aimed at a symptom (§ 3.4).

**Supersession rule.** Route step 1 rebuilds these from the failure evidence, and route step 4
challenges the rebuild. Where the evidence contradicts a hypothesis, **the hypothesis is superseded
and the units that depend on it are reopened, not patched.** H1 and H4 carry O1 and U1; H2 carries O2
and O3; H3 carries § 3.2 rungs 1–2 and U6 item 2; H5 and H6 carry § 4's *why* and the § 4 minimum
pair. A plan that survived contradicting evidence by adjusting its wording would be the failure this
case exists to correct, one level up.

---

## 1. Inspection — what the repository actually says today

Seven claims were checked by inspection before this plan was written. All paths are relative to the
`ai-resources` checkout at `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`; the
dispatcher lives at `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` and is referred to
below as `dispatch.sh`.

**What this section is.** Current-code inspection, and every verdict in it is **OBSERVED** — each
traceable to a file and line that could have read differently, and three of which did (§ 9). It is
**not** Gate 2 failure proof (§ 0.3) — it establishes what the code does today, not what happened on
2026-08-10. No causal claim appears in this section; those are in § 0.6.

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 1 | Attended Claude launch hardcoded to `--permission-mode default`, no operator-carried option | **HOLDS** | Parser `dispatch.sh:282-303` has 15 options and no permission-mode flag; unknown args exit 10 (`:302`). Both attended shapes pass the literal pair: `:1689` (with denies) and `:1694` (plain). Tests pin it: `dispatch.test.sh:1945,1974,2324`. README states it is "not an option, and cannot be turned off" (`README.md:316`) |
| 2a | Exit `25` classifies state-file dirtiness without proving Claude changed the file this hop | **HOLDS** | `dispatch.sh:2007` tests `[ "$before_turn" = "claude" ] && state_dirty` only. `state_dirty()` (`:1416-1418`) is a bare `git status --porcelain` on the state file. `before_dirty` **is** computed (`:1917`) but is used only by the crash-retry guard (`:1946`). The hash comparison that would settle it (`:2014`) runs *after* the die |
| 2b | Recovery text tells the reader to commit/discard "in language incompatible with Codex's role" | **DOES NOT HOLD AS STATED** | Both exit-25 messages name the right owner: `:1793` says "the expected Codex handoff (Codex never runs git)" and `:1795` says "Claude commits". The instruction "commit it and re-run" addresses the human reader, who may commit. The narrower real defect is that neither message *names its addressee*, so a Codex reader carrying the turn can read it as an instruction to itself. Retained in narrowed form (Unit 2) |
| 3 | Run evidence records hashes and hop `.out` captures, no byte-for-byte pre-hop state snapshot | **HOLDS** | Every write into the evidence directory: `$RUN_ID.log` (`:1123-1124`), `$RUN_ID.unattended-settings.json` (`:1294`), `$RUN_ID.hop<n>.<actor>.out` (`:1596-1597`), `$RUN_ID.hop<n>.<actor>.tree` (`:1502-1503`). Searched `dispatch.sh` for `LOG_DIR`, `cp`, and all `>`/`>>` redirections: no copy of the state file exists. Identity is carried as sha256 only — `file_hash()` `:419`, used `:1786, :1894, :1978` |
| 4 | Dispatcher does not parse Claude JSON `permission_denials` into a permission-specific stop | **HOLDS** | Searched `dispatch.sh` for `permission_denials`, `jq`, `is_error`, `subtype`: no match. The hop capture is written and never parsed (`:1596-1597`, `:1507`). The exit taxonomy (`:121-166`, codes 0 and 10–32) contains no permission code. `permission_denials` appears once in the spike, as README prose: `README.md:837` |
| 5 | Attended actors can still start nested `claude` or `codex` processes | **HOLDS** | Searched the attended launch path for any deny of `Bash(claude`, `Bash(codex`, or `Task`: no match. `--claude-deny` defaults empty and the run log says so — `claude_deny=none` (`:1152`). The dispatcher states the posture itself: "unattended=off — Claude hops are NOT contained: open network, open filesystem, full tool set" (`:1325`). Supervision (`actor_tree_census`, `:643-670`; teardown `:848-855`) terminates a tree on a stop; it does not prevent one from being created. Under `--unattended` the base deny set (`:236-242`) also carries no `claude`/`codex` rule and `--tools Bash,Skill` still exposes Bash — nesting is blocked there only *incidentally*, by the sandbox's network refusal |
| 6 | `--status` exists and reports some state; a dispatcher `--stop` may not exist | **HOLDS** | `--status` parsed at `:296`, branch at `:1020-1092`: lock state in three answers, `turn`/`task`/sha256/uncommitted, HEAD and branch, last run log with last hop line and last stop line, and `kill -TERM <pid>` as the stop instruction (`:1038`). It does **not** report elapsed runtime, the actor's pid, descendant count, deadline remaining, or output growth. Searched `dispatch.sh`, `dispatch.test.sh` and `README.md` for `--stop`: no match |
| 7 | The supplied `runs/` disposition concern describes **this checkout** today | **FALSE for this checkout; TRUE one worktree over** | This checkout: 48 files on disk, 48 tracked, 0 untracked, 0 ignored; `git check-ignore` returns non-zero on the directory and `.gitignore` carries no matching pattern. The incident checkout `../ai-resources-diagnostics-workflow` has three untracked run files from the 2026-08-10 run (`…20260810T151601-…diagnostics-workflow.{log,hop1.claude.out,hop1.claude.tree}`). The concern is real but is a **per-checkout evidence-lifecycle gap that surfaces in linked worktrees**, not a repo-wide untracked state |

**Two source facts are also stale and are corrected here.** The postmortem's *Current repository
state* says "No correction commit or closing record was created" and "The two command files contain
uncommitted correction edits". In `../ai-resources-diagnostics-workflow` the correction **is**
committed as `9a8399c` ("correction round — findings 1 and 3 resolved, finding 2 partial"), on top of
`ea77d66`, and no `.claude/commands/` path is dirty. What remains uncommitted there is the state file
itself plus `logs/friction-log.md`, `logs/session-notes.md` and the three run files. The task is still
`turn: claude`. Nothing in this plan depends on the stale reading.

---

## 2. Candidate classification

Every candidate supplied by the operator and the postmortem, classified. Categories are the six the
brief names: **verified current defect**, **already implemented / partly implemented**, **policy
decision requiring the operator**, **valid later improvement**, **duplicate**, **rejected (conflicts
with the Work Loop contract)**.

**A classification is not an authorization.** "Verified current defect" says the code does what the
candidate says it does. It does not say the candidate's proposed *construction* is the right answer —
that is § 3's question and the design gate's decision.

### Operator's own dispatcher recommendations

| Candidate | Classification | Reasoning |
|---|---|---|
| **A. Preserve the state file's full content before each hop, not only its SHA-256** | **Verified current defect** (claim 3) — priority **P1** | The loss path is real and non-recoverable: Codex writes the brief and does not commit, so the brief text exists only in the working tree until Claude's hop commits it. A Claude hop that rewrites the file wholesale erases a verdict Git never saw. It is P1 rather than P0 because losing forensics does not endanger the next run — it endangers the assessment of it |
| **B. Decide whether `runs/` is tracked or ignored** | **Policy decision requiring the operator**, correctly raised but **mis-scoped** (claim 7) | Not a defect in this checkout, where evidence is fully tracked. The exposure is that the dispatcher's default log directory sits *inside the checkout being driven* (`dispatch.sh:385`) and inside its own `--allow-path` default (`:317`), so run files are written, pass every guard, and then wait for a human to commit them. In a short-lived worktree that human never arrives. **This plan does not make the decision** (brief boundary); § 8 frames it |

### Postmortem P0 candidates

| Candidate | Classification | Reasoning |
|---|---|---|
| **1. Attended permission-mode option (`--claude-permission-mode …`, incl. `acceptEdits`)** | **Policy decision requiring the operator** — capability gap is verified (claim 1), the change is not Claude's to make | This reopens a **closed** operator decision: `logs/work-loop/axcion-harness-v0-2-p0-f-attended-policy.md` (`turn: operator`, 2026-08-09) records launch-time `--permission-mode default` as *the settled attended mechanism*, chosen precisely so a child never inherits this checkout's `bypassPermissions`. Framed as a decision in § 8 |
| **2. Parse Claude's `permission_denials` into a permission-specific stop** | **Verified current defect** (claim 4) — **P0 outcome** | The incident's dead end was invisible to the dispatcher. It is also the candidate with the strongest indirect effect — **H5, a PROPOSED hypothesis (§ 0.6), not a settled finding**: a precise stop is what removes the *reason* to reach for an interactive session. Ladder position 7 (repair an implementation that writes a capture and never reads it), not 8 |
| **3. Correct dirty-state classification** | **Verified current defect** (claim 2a) — **P0 outcome** | `UNCOMMITTED_HANDBACK` must require evidence that Claude changed the file this hop. Ladder position 7 — the existing classification is simply wrong, and correcting wrong logic adds no machinery |
| **4. Report partial allowed-path effects honestly** | **Verified current defect** — **P0 outcome**, same code region as candidate 3 | `foreign_worktree()` (`:1364-1375`) reports only paths *outside* the allowlist, so in-allowlist implementation edits are structurally invisible; the `die 22` "no observable transition" text (`:2015`) mentions the state file only. Merged with candidate 3 into one unit rather than two, because they are one misreport with two faces |
| **5. Prohibit nested AI actors by default** | **Verified current defect** (claim 5) — **P0 outcome**; **construction not settled here** (§ 3) | The outcome — the default direct route by which a dispatcher-launched actor starts nested Claude/Codex work is denied — is retained, in the narrowed form § 3.1 states. The postmortem's proposed construction included an `--allow-nested-actors N` override; that override is **rejected** for want of any verified authorised use case (§ 3.3) |
| **6. Absolute prohibition on interactive fallback after dispatcher failure** | **Partly implemented** — the rule exists, the placement does not — **P0 outcome** | `.agents/skills/work-loop-v2/SKILL.md:195` already says: "You never type into a Claude window, never read Claude's interface for progress, and never click through its prompts." The postmortem records that rule being violated. What is missing is the rule *at the point of failure*: the § *Three outcomes* table's **Stopped** row (`SKILL.md:256`) lists the codes and says nothing about what may not follow one. This is an operating restriction (§ 3.4), not a causal fix |

### Postmortem P1 candidates

| Candidate | Classification | Reasoning |
|---|---|---|
| **1. Stricter correction profile** | **Verified gap** — **P1** | Core § 3 *Correcting once* freezes **what** may change; nothing anywhere bounds **how much verification** a correction may spend. The incident's closure check became a second test suite inside a frozen scope, which is legal under the current text |
| **2. Explicit verification budget for nested AI work** | **Verified gap** — **P1**, and now **reframed** | Originally paired with an `--allow-nested-actors` flag. With that flag rejected (§ 3.3), the budget rule stands on its own as a **prohibition with a named escalation**: a brief may not propose nested Claude/Codex invocation, and a case that appears to require it goes to the operator as a capability question rather than being authorized by a flag |
| **3. Brief proportionality preflight** | **Duplicate in substance; rejected as a stage** | Core § 3 *The "good enough, proceed" judgment* already owns all four constraints (85–90% target, minimum necessary work, evidence scaled to consequence, no perfection pass), and `SKILL.md:450` already requires fail-capable evidence. Core § 3 step 3 also forbids the remedy's shape outright: "no new field, artifact or stage is created." **Rejected as a preflight stage.** At most, the trigger list (many scenarios plus negative controls; full behavioural matrices for Markdown files; multiple AI-backed fixtures; "all"/exhaustive without a consequence justification) is folded into P1 Unit 6 as examples inside the *existing* brief-writing step |
| **4. Keep the task state compact** | **Already specified** — compliance failure, not a specification gap | Core § 4 already says the state file is "current truth, not a diary", caps it at five fields, and gives a worked *Not this* example of exactly the accumulation the incident produced. A new rule would restate an existing one. **Parked**, with one exception folded into P1 Unit 6: briefs should name where bulk evidence lives (the run log, a working-notes path) so "point, don't absorb" has a concrete destination |

### Postmortem P2 candidates

| Candidate | Classification | Reasoning |
|---|---|---|
| **1. Richer `--status`** (elapsed, actor pid, descendant count, deadline remaining, output growth) | **Valid later improvement** — **P2** | Genuinely absent (claim 6). Descendant count should **reuse** `actor_tree_census` (`:643+`) rather than grow a second census. Constraint: `unattended-operation-plan-v0.2.md` § *Deferred* rejects "a structured JSON outcome event plus observer process" — enriching a read-only command is fine; growing an observer process is the rejected thing |
| **2. Dispatcher `--stop`** | **Valid later improvement, low marginal value** — **P2** | Verified absent, but the capability underneath already exists: the SIGTERM handler terminates the tree, *verifies* the result, pins the lock when it cannot account for the tree, and exits 28; `--status` already prints `kill -TERM <pid>` (`:1038`). `--stop` is a wrapper over that. It also inherits 1a's open gap — a doubly-forked detached daemon still escapes (`unattended-operation-plan-v0.2.md`, 1a "NARROWED, NOT CLOSED"). **It must not be described as closing 1a** |
| **3. Task-scoped session counts** | **Valid later improvement, largely dissolved by the P0 outcomes** — **P2** | The count became untrustworthy *because* the dispatcher was bypassed and nesting was unbounded (**H1, INFERRED**). With the nested-actor outcome and the no-fallback restriction in place, the run log's hop lines are already a task-scoped count. What survives is the reporting rule — never answer "how many sessions has this task used?" with workspace-wide telemetry — which is one sentence in the skill and can ride with P1 Unit 6 |

---

## 3. Intervention options — the ladder before the package

**Required by the correction, and it changes the shape of the recommendation.** The first version of
this plan proposed a package of controls without first asking whether anything could be *removed*,
*simplified* or *narrowed* instead. That is starting at the bottom of the ladder. This section starts
at the top.

**Complexity budget: zero.** No new permanent mechanism is proposed unless removal, simplification or
reuse of an existing mechanism demonstrably cannot achieve the outcome. This is the SOP's own default
(`:612`), and route step 4 tests it adversarially.

### 3.1 The outcome, stated without a construction — and narrowed

*Narrowed in v0.2 (finding 3).* v0.1 stated the outcome as "a dispatcher-launched actor **cannot
start** nested Claude or Codex work by default". That is a containment claim, and the leading
construction cannot prove containment — § 3.4 said so in the same document, which made the two
inconsistent. The outcome is now stated at the strength the evidence can reach:

> **O1.** By default, the direct route through which a dispatcher-launched actor starts nested Claude
> or Codex work is **denied at the child's permission layer**, the denial is visible in the launch
> argv and in the run log, and no supported path re-enables it.
>
> **O4.** A dispatcher stop cannot be answered by leaving the dispatcher.

**What "denied at the permission layer" means, precisely.** The default direct invocation is refused
by the child's own permission layer and the refusal is observable. It does **not** mean the capability
is removed, and it does **not** mean a determined child cannot construct an undenied path from a
shell. Materially reduced, not contained.

That is what must become true. **How** it becomes true is a design-gate decision (§ 0.3, Gate 3), not
a decision this plan is entitled to make. What follows compares the options; it does not choose among
the ones that survive.

### 3.2 The ladder, applied

| Rung | Option | Verdict on this case |
|---|---|---|
| 1 | **Eliminate the triggering condition** | **Adopt, and it is free.** The trigger was a brief that demanded behavioural verification of Markdown instruction files, which can only be satisfied by invoking Claude — **H3, INFERRED (§ 0.6)**. A brief rule that forbids proposing nested AI invocation eliminates the demand at source. Zero machinery. **Insufficient alone** — it is written guidance, and the SOP's own definition of a durable fix (`:920`) excludes fixes that depend on a model remembering guidance. `SKILL.md:195` is the proof: it was in force and was violated |
| 2 | **Simplify the operating model** | **Adopt, and it is free.** The model already says one courier, one dispatcher, no screen-driving. The incident was a departure from the model, not a property of it. The simplification available is to remove the ambiguity a stop currently leaves about what may follow it — restoring the intended courier path rather than adding to it. Zero machinery. Same insufficiency as rung 1 |
| 3 | **Remove the problematic component** | **Credible, probably too broad.** The component is the attended child's unrestricted tool set (`dispatch.sh:1325`). Restricting the attended `--tools` roster removes capability rather than adding a guard, and the mechanism already exists on the unattended path. But Claude must run `git` to commit every hop (core § 4), and `git` arrives through Bash — so removing Bash removes the loop. A narrower roster is a design-gate question |
| 4 | **Narrow or reuse an existing mechanism** | **Leading candidate.** `--disallowedTools` already exists, already reaches attended hops when `--claude-deny` is set (`dispatch.sh:1687-1690`), and already composes additively rather than replacing. Adding `claude`/`codex` invocation rules to a default attended deny set reuses that mechanism and introduces **no new flag, no new subsystem and no new file**. Net new permanent machinery: zero. It reaches the *narrowed* O1 of § 3.1, not containment |
| 5 | **Isolate the affected capability** | **Credible, disproportionate.** `--unattended` already isolates — the sandbox refuses network, so a nested `claude` call cannot reach the API at all. Making containment the default for attended runs would achieve the outcome through a mechanism already built and measured, and it is the **only** option on this ladder that would reach genuine containment. It also changes the attended/unattended boundary, which is a settled artifact (plan v0.2, item 1d), and is a larger operating-model change than the proven mechanism requires |
| 6 | **Redesign the causal mechanism** | **Not warranted.** No evidence supports redesigning the courier |
| 7 | **Repair the existing implementation** | **Applies to the reporting defects, and lowers their burden.** The exit-25 misclassification is wrong logic (claim 2a), and the unparsed capture is a written-but-never-read file (claim 4). Correcting both is repair, not new control. One new exit code is the only addition, and it is a taxonomy entry rather than a mechanism |
| 8 | **Add a new guard, warning, gate or control** | **Rejected for the nested-actor outcome.** Rungs 1, 2 and 4 reach the narrowed O1 between them without new machinery |

### 3.3 What was dropped, and why

**`--allow-nested-actors N` is dropped.** The supplied evidence contains exactly one instance of
nested AI invocation, and it is the failure. No verified authorised use case exists anywhere in the
postmortem, the run evidence, the plan spine or the skill. Adding an override flag would create a
mechanism whose only demonstrated use is the behaviour the mechanism exists to prevent, and would
require permanent maintenance, a count to enforce, an authorization to record and a test surface to
keep — all for symmetry. It is exactly the "new permanent mechanism" the SOP requires a verified
failure to justify (`:610`), and none justifies this one.

**Consequence, stated plainly:** under this plan there is **no** supported way to run nested AI. A
future case that genuinely needs it goes to the operator as a capability question, at which point a
verified use case would exist and a mechanism could be justified on evidence. That is a deliberate
absence, not an oversight.

### 3.4 What the surviving options can and cannot prove

Kept separate on purpose, because conflating them is finding 3 of the first correction — and the
independent review found v0.1 had reintroduced the conflation in § 3.1's own wording, which § 3.1
now fixes.

- **Requested policy** — that the deny rules reach the child, provable by literal argv capture
  against the existing harness. This is what a permission-layer control can demonstrate.
- **Effective containment** — that a child *cannot* start another model. A tool-name deny is enforced
  by the child's own permission layer, and a child with shell access can attempt constructions the
  deny does not name. **A permission-layer deny is not containment, and this plan claims no
  containment anywhere.** The only measured containment in this repository is the `--unattended`
  sandbox's network refusal (rung 5).
- **What would disprove the intervention:** an attended child that starts a `claude` or `codex`
  process while the deny rules are present in its argv.
- **What would disprove the diagnosis:** evidence from the preserved run logs that the runaway cost
  came from a single long session rather than from nested invocations — in which case nesting is a
  symptom and the causal model is wrong. This is § 0.6's disproving observation for H1 and H4.
- **An operating restriction is not a causal fix.** Placing the no-interactive-fallback rule at the
  point of failure (rung 2) narrows an opportunity for human and model choice. It does not change any
  mechanism, and evidence that the rule now exists is **not** evidence that the mechanism changed.
  The incident is proof of the difference: a rule already existed and did not hold.

---

## 4. The P0 boundary

**P0 = the smallest coherent set of *outcomes* required before another attended live dispatcher run.**
Four outcomes. Constructions are candidates, settled at the design gate.

| # | Outcome that must become true | Leading candidate construction | Ladder rung |
|---|---|---|---|
| **O1** | By default, the direct route through which a dispatcher-launched actor starts nested Claude/Codex work is denied at the child's permission layer, the denial is visible in the argv and run log, and no supported path re-enables it. **Not containment** (§ 3.1) | Deny rules added to the existing attended `--disallowedTools` path; brief rule forbidding the demand | 4 + 1 |
| **O2** | A stop names what actually happened — which files changed, and whether Claude touched the state file at all | Repair the classification logic and the reporting | 7 |
| **O3** | A permission dead end becomes a named stop carrying the denied tool, the target, and the decision required | Parse the capture already being written; one taxonomy entry | 7 |
| **O4** | A nonzero dispatcher exit is never answered by leaving the dispatcher | Place the existing prohibition at the point of failure | 2 |

**Why these four — HYPOTHESIS, not finding.** The reasoning below rests on H1, H2 and H6 (§ 0.6),
none of which has passed Gate 2. It is the plan's best current reading of the incident and it is the
first thing route step 1 will test.

> The incident's cost had two mechanisms: unbounded nesting (O1) and the interactive bypass (O4) —
> **H1**. The bypass had one *cause*: the dispatcher reported the wrong thing and the right thing was
> unavailable (O2, O3) — **H2**. Fixing the mechanisms without the cause leaves the same temptation in
> place under a new prohibition — **H6** — which is how `SKILL.md:195` already failed once.

**If the discovery unit contradicts H1**, this whole boundary is rebuilt rather than adjusted
(§ 0.6, supersession rule).

**Why the permission-mode option is not in P0.** Without it, a permission dead end now *stops
honestly* instead of dead-ending silently. That is a safe outcome, not a blocked one. Adding attended
`acceptEdits` widens what a child may do without asking; it belongs in § 8 as an operator decision.

**If the operator wants less than four:** the irreducible pair is **O1 + O4**. That closes the default
nesting route and removes the fallback. It leaves the misdiagnosis that caused the bypass in place,
and this plan does not recommend stopping there. *(This ranking depends on H1 and H2.)*

**Not in P0, and why:** state snapshots (U5 — forensics, not safety) · correction profile and nested-AI
prohibition (U6 — they govern the *next brief*, not the next run) · `runs/` disposition (an operator
decision, framed in § 8) · richer `--status`, `--stop`, session counts (P2 — observability, not a
boundary).

---

## 5. Implementation units

**Read these as scope proposals, not as approved work.** Each is independently assessable, and each
is subject to the design gate (§ 0.3) and to the B5 challenge that now precedes it (§ 0.4 step 4).
Construction details are the leading candidate at the time of writing, not a locked design.

### Verification budget — applies to every unit below

- **Default method:** static inspection plus the existing simulated harness
  (`dispatch.test.sh`). The harness already captures literal argv through a fake `claude` binary
  (`WL_ARGV_FILE`, `argv_pair`, `argv_has` — `dispatch.test.sh:1945, 1974, 2075, 2324`) and already
  drives full hop shapes through `--actor-cmd`. **Re-derive the pass baseline by execution** before
  relying on it (§ 0.5, *Tests that must be run*) — the `375 pass / 0 fail` figure is a record, not a
  measurement taken in this plan.
- **Zero nested Claude or Codex invocations.** Not one, in any unit, including closure checks.
- **No exhaustive scenario matrix.** Each unit's evidence is one matched red/green pair plus the
  controls named in its own row. A red half that passes is not evidence.
- **No live model-backed run** unless a later unit states why cheaper evidence cannot settle a
  consequential claim, and obtains operator approval carrying a **maximum invocation count** and a
  **wall-clock deadline**. The one budgeted pilot in § 6.2 is the sole planned instance.
- **Correction budget for any of these units:** the frozen findings only, static inspection plus the
  harness, zero nested AI, 10 minutes wall-clock. A correction that cannot finish inside that is
  handed back, not extended.
- **Harness evidence is controller evidence.** It establishes what the dispatcher requests and how it
  reports. It never establishes effective containment or real-world behaviour (§ 3.1, § 3.4, § 6).

### P0 units

#### U1 — Deny the default nested-actor route (outcome O1)

- **Observable outcome:** *narrowed in v0.2 (finding 3).* The default direct route by which an
  attended Claude hop starts `claude` or `codex` work is **denied at the child's permission layer**,
  and the logged command line shows the policy that was requested. **This is not containment** — see
  § 3.1 and the *what this proves* row below.
- **Construction:** **not settled here.** Leading candidate is rung 4 — extend the attended
  `--disallowedTools` path (`dispatch.sh:1687-1690`) with a default deny set, composing with
  `--claude-deny` as that flag already composes. Rung 3 (a narrower attended `--tools` roster) is the
  alternative the design gate should compare it against. **No new flag is proposed, and no override
  mechanism exists** (§ 3.3).
- **Allowed surfaces:** `dispatch.sh` (deny set, launch construction, run-log lines),
  `dispatch.test.sh`, spike `README.md`.
- **Exclusions:** the `--unattended` contained profile (its deny set is a separate settled artifact);
  any settings.json in any layer; the executable core; the Claude command; the skill.
- **Dependencies:** design-gate approval of the construction, which now follows the B5 challenge.
  None otherwise.
- **Stop conditions:** if closing the gap requires editing a settings file rather than adding launch
  arguments — that reopens P0-F's settled mechanism, so stop and escalate. If a deny rule would also
  block the child's ordinary work (its own `git`, for instance), stop and hand back rather than
  widening. If the construction turns out to need a new flag after all, stop — that is a design
  change, and § 3.3 rejected the flag on the evidence available.
- **Minimum evidence that can fail:** matched red/green argv capture — against the pre-change
  dispatcher the new assertions must **fail**, and the existing baseline must still pass; against the
  changed one all pass. Plus one control: the `--unattended` argv is byte-unchanged.
- **What this evidence proves:** the requested policy reaches the child. **What it does not prove:**
  that a child cannot evade it, and therefore not that nested work is impossible. See § 3.1 and
  § 3.4. The README states the distinction in the same breath, as P0-F already does for
  `--permission-mode`.
- **Depends on hypotheses:** H1, H4 (§ 0.6). If either is superseded, this unit is reopened.
- **Verification budget:** static + harness. Zero AI invocations.

#### U2 — Honest post-hop classification (outcome O2)

- **Observable outcome:** three separate, correct outcomes replace one wrong one.
  1. `UNCOMMITTED_HANDBACK` (25) fires only when Claude actually changed the state file this hop —
     `after_hash != before_hash`, or the file was clean before and is dirty now.
  2. A state file that was already dirty before launch and is byte-identical after produces a
     **different** outcome that says exactly that, and never says "Claude edited it".
  3. Any hop that leaves **in-allowlist** files modified lists them by path in the run log and in the
     stop message, whatever the exit code.
- **Ladder position:** 7 — repair of wrong logic. Adds no mechanism.
- **Allowed surfaces:** `dispatch.sh` (`:1917`, `:2007-2019`, `foreign_worktree` region `:1364-1375`,
  the exit taxonomy comment `:121-166`), `dispatch.test.sh`, spike `README.md`.
- **Exclusions:** the retry/partial-effect logic at `:1935-1973` (correct as written, different
  question); the Codex-HEAD guard `:1990`; the committed-path check `:1997-2005`.
- **Dependencies:** none.
- **Stop conditions:** if a new exit code is needed and the taxonomy has no free number in range,
  hand back rather than reusing an occupied one. If listing in-allowlist changes would require a
  second `git status` pass per hop with measurable cost, say so and hand back the cost.
- **Minimum evidence that can fail:** simulated hops via `--actor-cmd` producing each shape exactly —
  (a) pre-dirty state file + actor that changes nothing → must **not** report exit 25 with "Claude
  edited"; (b) clean state file + actor that edits and does not commit → must still report 25;
  (c) actor that modifies an allowed implementation file and leaves the state file alone → the file
  is named in the output. Red half run against the pre-change dispatcher: (a) must fail there.
- **Depends on hypotheses:** H2 (§ 0.6) for its *priority*, not for its correctness — claim 2a is
  OBSERVED, so the logic is wrong whatever the discovery unit finds. If H2 is superseded, U2 stays a
  valid repair and leaves P0.
- **Verification budget:** static + harness. Zero AI invocations.
- **Carried in, narrowed:** claim 2b. Add one clause to both exit-25 messages naming the addressee —
  the operator does this, not Codex — so a Codex reader cannot take it as an instruction to itself.
  A wording fix inside a unit already touching those two strings; not a separate unit.

#### U3 — Permission-denial parsed into a specific stop (outcome O3)

- **Observable outcome:** when a Claude hop's JSON capture contains `permission_denials`, the
  dispatcher exits with a permission-specific code whose message carries the denied tool, the exact
  target path or command, the files changed before the denial, and the operator decision required.
- **Ladder position:** 7 — the capture is already written and never read.
- **Allowed surfaces:** `dispatch.sh` (a parse step over the hop capture, plus one exit code and its
  taxonomy entry), `dispatch.test.sh`, spike `README.md`.
- **Exclusions:** the `--unattended` stream-json path's `system/init` handling; the launch
  construction; anything that would make the dispatcher *decide* what to do about a denial — it
  reports and stops (§ 7).
- **Dependencies:** a recorded real capture as a fixture; the spike already documents one at
  `runs/live-permission-denial-2026-08-05.md` (`README.md:837`). If that record does not contain a
  usable raw JSON body, hand back rather than generating a fresh one with a live run.
- **Minimum evidence that can fail:** replay a fixture JSON body carrying two `Edit` denials through
  the parse and assert the exact denied tool and target appear in the stop message; plus a control —
  a clean capture with no denials must produce the ordinary path and **no** permission stop. Against
  the pre-change dispatcher the first must fail.
- **Depends on hypotheses:** H2, H5 (§ 0.6) for its P0 placement. Claim 4 is OBSERVED, so the gap is
  real regardless.
- **Verification budget:** static + harness + one recorded fixture. Zero AI invocations. The fixture
  is a *replay* of evidence already paid for; regenerating it live is out of budget.

#### U4 — A dispatcher stop is never authorization to continue by hand (outcome O4)

- **Observable outcome:** the Codex skill states, at the point where a stop is read, that a nonzero
  exit authorizes exactly two things — fix the cause and re-run the dispatcher, or stop for the
  operator — and never an interactive Claude session, a hand-carried hop, or a hand-edit of the state
  file. A dispatcher capability gap is a capability gap, not a licence.
- **Ladder position:** 2 — restoring the intended courier path. **This is a supporting operating
  restriction, not a causal fix.** Its presence is not evidence that any mechanism changed (§ 3.4),
  and the SOP's durable-fix definition (`:920`) explicitly discounts fixes that depend on a model
  remembering guidance. U4 is proposed in full knowledge of that limit.
- **Allowed surfaces:** `.agents/skills/work-loop-v2/SKILL.md` — § *Three outcomes* (the **Stopped**
  row, `:250-256`) and § *What you never do* (`:517-527`).
- **Exclusions:** the executable core (§ 7 already reserves consequential situations for the
  operator); `.claude/commands/work-loop-v2.md` (Claude never chooses the transport, so the rule has
  no addressee there); the dispatcher.
- **Dependencies:** none.
- **Stop conditions:** if stating the rule requires contradicting core § 7 or the existing `:195`
  text, stop — the rule is meant to place an existing prohibition, not add a competing one.
- **Minimum evidence that can fail:** the changed text quoted against what it replaced, plus the
  demonstration that the current text does *not* say it — the **Stopped** row today lists codes only.
  One line on why no automated check distinguishes success from failure here: the artifact is an
  instruction to a model, and any grep would search for words this very brief supplied.
- **Depends on hypotheses:** H1, H6 (§ 0.6).
- **Verification budget:** inspection only. Zero AI invocations, zero harness runs. Per the Claude
  command (`.claude/commands/work-loop-v2.md:209`), a prose change's evidence is the changed text.

### P1 units

#### U5 — Preserve the state file before each hop

- **Observable outcome:** each hop writes a byte-for-byte copy of the state file into the run
  evidence directory before the actor launches (`$RUN_ID.hop<n>.<actor>.state.md`), alongside the
  existing `.out` and `.tree`. The sha256 lines stay as they are.
- **Allowed surfaces:** `dispatch.sh` (`:1894` region), `dispatch.test.sh`, spike `README.md` § run
  evidence table (`:20`).
- **Exclusions:** the state file itself; retention or pruning policy for the evidence directory (the
  § 8 `runs/` question); anything that reads the snapshot back and acts on it — this unit preserves,
  it does not compare.
- **Dependencies:** none. Interacts with the § 8 `runs/` decision.
- **Stop conditions:** if the snapshot would land anywhere the dispatcher's own allowlist does not
  cover, stop — a guard tripping on its own evidence is worse than no snapshot.
- **Minimum evidence that can fail:** run a simulated two-hop sequence; assert a snapshot exists per
  hop and that its bytes equal the pre-hop file, then mutate the file between hops and assert the two
  snapshots differ. Against the pre-change dispatcher, no snapshot exists at all.
- **Depends on hypotheses:** none. Claim 3 is OBSERVED and the loss path is structural.
- **Verification budget:** static + harness. Zero AI invocations.

#### U6 — Correction profile, nested-AI prohibition, and evidence pointers in the brief

Three small instruction changes that share one surface and one review, and are wrong to split.

- **Observable outcome:**
  1. A correction round carries an execution profile: only checks tied to the frozen findings, zero
     nested AI actors, a stated wall-clock ceiling, and — for instruction-file corrections —
     inspection unless one targeted behavioural check is materially necessary and said to be.
  2. **A brief may not propose nested Claude or Codex invocation.** Where a case appears to require
     it, that is escalated to the operator as a capability question — not authorized inside the
     brief. (Reframed from "budget it" to "prohibit and escalate", because § 3.3 rejected the flag
     that a budget would have authorized. A budget for a capability that does not exist would be
     machinery for its own sake.)
  3. A brief names where bulk evidence lives (run log, working-notes path) rather than letting the
     state file absorb it, and the session-count reporting rule from P2-3 is stated: a task-scoped
     question gets a task-scoped answer.
- **Allowed surfaces:** `.agents/skills/work-loop-v2/SKILL.md` — § *Opening a unit and writing the
  brief* and § *Assessing the result* (*Correcting once*). Possibly one sentence in
  `.claude/commands/work-loop-v2.md` § *Correction rounds*, if the ceiling must bind Claude's own
  closure work too.
- **Exclusions:** the executable core — **this unit must not add a field, artifact or stage**, which
  core § 3 step 3 and core § 4's five-field ceiling both forbid. The budget is text inside the brief,
  not a new heading. No proportionality "preflight" stage is created (§ 2, P1-3).
- **Dependencies:** none, now that item 2 no longer presupposes a flag.
- **Stop conditions:** if the change cannot be made without a new field or stage, stop and escalate —
  that is a core change, and core changes are not this task's to make.
- **Minimum evidence that can fail:** the changed text quoted against what it replaced, plus a
  demonstration that the current text does not bound correction cost (core § 3 *Correcting once*
  freezes scope only; `SKILL.md:505` restates that and adds no ceiling). One line on why automation
  would not distinguish success from failure.
- **Depends on hypotheses:** H3 for item 2's framing (§ 0.6).
- **Verification budget:** inspection only. Zero AI invocations.

#### U7 — retired in v0.2

**U7 was "frame the `runs/` disposition as an operator decision", and its only allowed surface was a
new file.** The independent review's finding 6 removed that file — the framing belongs in the case
document that already frames one operator decision in exactly this shape. With no artifact to
produce, no surface to bound and no evidence to gather beyond claim 7, nothing of a unit remained.

**The framing is written into § 8 instead, and is complete there.** No unit, no file, no work
carried forward. This is a net reduction of one unit, which is the direction the complexity budget
points.

The identifier is retired rather than reused, so that U8–U10 keep the numbers every other section
cites.

### P2 units

Not briefed here. Recorded so they are not lost, and so no one rebuilds them by accident.

- **U8 — richer `--status`:** elapsed runtime, actor pid, descendant count (reusing
  `actor_tree_census`), current hop, deadline remaining, output-file growth. Must stay read-only and
  must not become an observer process (rejected in `unattended-operation-plan-v0.2.md` § *Deferred*).
- **U9 — `--stop`:** a wrapper over the existing verified teardown. Must not be described as closing
  Phase 1 item 1a — the detached-daemon escape is still open.
- **U10 — task-scoped session counts:** largely dissolved by O1 and O4; the reporting sentence rides
  with U6.

---

## 6. Closure boundary for the parent case

**Harness success does not close this case.** The simulated suite establishes controller behaviour —
what the dispatcher requests, and how it reports. It cannot establish that a real Claude actor behaves
as intended, and this case exists because the gap between those two was crossed once already.

### 6.1 What each level of evidence closes

| Evidence | Closes |
|---|---|
| Static inspection | That the text or logic says what it is supposed to say |
| Simulated harness (red/green, argv capture, `--actor-cmd` hop shapes) | That the dispatcher **requests** the policy and **reports** the outcome correctly |
| Independent verification from a clean environment | That the above holds when someone else runs it, not when Claude reports it |
| The additional high-risk independent review (§ 6.5) | That a second party challenged the change itself, not only its test results |
| One genuine representative attended use | That the change survives a real actor. **Only this closes the parent case** |

### 6.2 The budgeted pilot

Bound in advance, before implementation begins:

- **One task**, representative rather than a fixture.
- **At most one Claude actor invocation.**
- **Ten minutes wall-clock.**
- **No nested AI. No exhaustive matrix. No second run "to be sure".**
- Observed signals defined before it runs: does the attended child start a nested actor; does a stop
  report the correct cause; is the run log complete.

**If one genuine use cannot exercise a consequential claim, that claim is recorded as a limitation.**
It is not answered by manufacturing additional sessions. Manufacturing sessions to close a claim is
precisely the incident this plan exists to prevent, and doing it in the name of verifying the fix
would be the same failure wearing a different label.

### 6.3 Outcome vocabulary for the parent case

Until an independently verified, operator-authorized implementation has survived one genuine
representative attended use, the parent case is **not** resolved. Intermediate states — integrated
but awaiting operational validation, or not confirmed — are honest and are used. A case that cannot
be established from the preserved evidence carries *Not confirmed*, which is a valid result and not a
reason to manufacture a diagnosis, and is **not** *No action justified* — that requires the premise to
be disproved, obsolete, duplicated or out of scope.

The current outcome is recorded in the manifest (§ 0.5): **Proceed — structural resolution**,
provisional.

### 6.4 Where implementation happens

**This planning task closes when the plan is accepted.** Implementation does not continue inside it.

Implementation opens as a **new Work Loop task**, in a deliberate isolated branch or worktree at an
agreed clean base commit, with its own state file named for its own task id. **Never by copying this
task's state file** — a copied state file carries a stale `task:` value, which core § 6 rule 2 and
the Claude command's identity check both reject read-only, and would be rejected on arrival.

The main checkout is not the implementation surface. One writer at a time; unrelated work is neither
staged nor committed; the rollback path is recorded before integration and stays usable after it —
and, per § 6.5, **tested** rather than only recorded.

### 6.5 Implementation is a high-risk change

*New in v0.2 (finding 5).* The SOP's high-risk list (`:947-951`) names repository permissions,
concurrent sessions, background processes and cross-repository automation. The P0 units touch all
four: U1 changes the permission policy carried into a child process; U2 and U3 change how the
dispatcher classifies and reports the state of a lock-protected, concurrently-reachable state file;
every unit changes a program whose job is to launch and tear down background process trees; and the
dispatcher drives linked worktrees, which is cross-repository automation in the sense that matters
here. **This is not a marginal call — it is four of the twelve named categories.**

`:951` attaches three obligations to a high-risk change, and they apply to the implementation task,
not to this plan:

1. **At least one further independent review**, beyond the ordinary per-unit assessment.
2. **The first implementation is restricted to a copy or test environment.** § 6.4's isolated branch
   or worktree already satisfies this, and is now load-bearing rather than good practice.
3. **A tested recovery path before proceeding.** Recording the rollback is not enough — it is
   executed once, from the clean environment, and the execution is the evidence. § 6.4 is amended
   accordingly.

`:951` also says these changes **are not deferred on grounds of rollout workload.** The cost of the
extra review is not a reason to skip it.

**A conflict is surfaced here rather than resolved silently.** The workspace Independent Review Rule
says one independent review per change, proportional to consequence, explicitly *not a chain*. The
SOP says a high-risk change gets *at least one further* independent review. Read naively these
disagree, and the workspace rule governs — the SOP is advisory (§ 0.1).

**Resolution taken, and why it is not a chain.** The reviews are of different objects, not repeated
reviews of one object:

- **Route step 4 (B5)** challenges the *design*, before approval. Its object is the causal model and
  the proposed scope.
- **Route step 7's further review** challenges the *implemented change*, after the fact. Its object
  is the diff and the recovery path.

Between them sits the operator's approval and the implementation itself, so neither review re-reads
what the other read. That is one review per object, which is what the workspace rule asks for, and it
satisfies `:951` without stacking gates. **What is explicitly not adopted:** a second review of the
design, a re-review after any fix, or a review of the review. If the implementing task finds itself
running a third review pass, that is the chain the workspace rule prohibits and it stops.

`:942` supplies the quality bar the further review must meet: *Codex verifies only by reading Claude's
summary* is a listed warning sign. The review runs the commands.

---

## 7. Preserving the dispatcher as courier

Core § 4 permits a courier to carry a turn the state file already states, and forbids it to change
content, choose which actor moves next, decide that a turn exists, continue past `turn: operator`, or
stand in as evidence. Every candidate was checked against that.

**Compatible — reporting or bounding, not deciding:**

- U2 and U3 make the dispatcher *report* more accurately. Reporting what a hop did is transport.
- U1 narrows what a launched actor may do. A launch restriction is transport-level configuration; it
  makes no judgment about the work.
- U5 preserves bytes. It compares nothing and concludes nothing.
- U8 and U10 report. U9 terminates on an instruction it is given.

**Rejected or constrained on this ground:**

- **A proportionality preflight inside the dispatcher would be a semantic decision** — judging whether
  a brief's verification demand is proportionate is Codex's assessment, not a courier's. Already
  rejected as a stage (§ 2); rejected a second time as a *location*. If any part of it lands, it
  lands in the Codex skill.
- **A correction "profile" enforced by the dispatcher** must be limited to the existing `--deadline`.
  The dispatcher may hold a clock; it may not decide what counts as a correction or which checks
  belong to a frozen finding.
- **`--allow-nested-actors N` is rejected outright** (§ 3.3). Beyond having no verified use case, an
  authorization count the dispatcher enforces would put it one short step from deciding *whether* a
  unit may spend model time — which is Codex's assessment and the operator's budget, not transport.
- **Nothing may make a stop advisory.** A guard that reports and continues would let the dispatcher
  decide that a turn exists. Every unit above stops.
- **No unit may create a second state system.** U5 writes evidence, not state; the § 8 `runs/`
  decision settles where evidence lives, not what is true. The state file stays the single interface.
  The SOP's own context manifest is deliberately **not** created as a file — its content lives in
  § 0.5, complete. **And the `runs/` decision framing is deliberately not created as a file either —
  it lives in § 8** (v0.2, finding 6; the unit that would have written it is retired).

---

## 8. Settled decisions a proposed fix would reopen, and the two operator decisions

Six settled decisions. Each is named so no unit reopens one silently.

1. **Attended `--permission-mode default` is the settled attended mechanism.**
   Closed record: `logs/work-loop/axcion-harness-v0-2-p0-f-attended-policy.md`, `turn: operator`,
   2026-08-09. Adding `--claude-permission-mode acceptEdits` reopens it. **Operator decision 1,
   framed below.**
2. **Claude makes every commit** (core § 4). No recovery text, and no unit, may imply Codex commits.
   U2 carries the narrowing clause.
3. **The brief creates no new field, artifact or stage** (core § 3 step 3), and the state file holds
   at most five fields (core § 4). This rejects the proportionality preflight, constrains U6 to prose
   inside existing sections, is why § 0.5 is a plan section rather than a manifest file, and is why
   decision 2 below is framed here rather than in a document of its own.
4. **The dispatcher is transport** (core § 4 *An approved courier may carry the turn*). § 7 above.
5. **"A structured JSON outcome event plus observer process" is rejected**
   (`unattended-operation-plan-v0.2.md` § *Deferred*). Constrains U8.
6. **Phase 1 item 1a is narrowed, not closed** — a doubly-forked detached daemon still escapes the
   teardown. Constrains U9, and is a stated limitation of U1: a denied tool name is not a sandbox.

### Operator decision 1 — attended `acceptEdits`

Stated with value, risk and the narrowest reversible boundary, as the brief requires. **Not decided
here.**

- **What it would allow.** A dispatcher option carrying an operator-approved permission mode into an
  attended Claude hop, so a run blocked on a permission gate can resume *inside the dispatcher*
  rather than by hand.
- **Value.** It closes the exact capability gap that produced the bypass. On 2026-08-10 the operator
  had already approved the edits; the dispatcher had no way to represent that approval, and the
  approval was then executed by driving Claude directly — which cost every safeguard at once.
  *(Rests on H2, INFERRED — § 0.6.)*
- **Risk.** `acceptEdits` applies file edits without asking. Combined with the allowlist it is
  bounded by path, but the allowlist is a per-task input written by Codex, and the plan v0.2 already
  records the honest cost: "too wide and this check means nothing" (`dispatch.sh:1390-1392`). It also
  moves attended runs away from a posture chosen *because* a child had silently inherited
  `bypassPermissions`.
- **Narrowest reversible boundary, if approved.** Opt-in per run, never a default. Accept only
  `default` and `acceptEdits`; reject `bypassPermissions` on every attended path, as now. Require the
  approval to be written into the run log at launch, naming the paths it covers. Refuse to combine
  with `--unattended`. Reversible by removing one argument from one invocation — no settings file in
  any layer is touched, which is the property P0-F chose and this preserves.
- **Verification, if approved.** Argv capture proves the request, not the effect, and P0-F already
  accepted exactly that limitation once. If the operator wants effect proven, that is the § 6.2
  pilot — one invocation, ten minutes — and not a separate budget.

### Operator decision 2 — the disposition of `runs/`

*Moved here in v0.2 (finding 6), replacing the retired U7 and its proposed new file.* Framed, **not
decided**. The framing is complete: nothing further needs to be produced before the operator can
choose.

**The verified state, and the commands that produced it.** In the bound checkout, run evidence is
fully tracked — 48 files on disk, 48 tracked, 0 untracked, 0 ignored; `git check-ignore` returns
non-zero on the directory and `.gitignore` carries no matching pattern. In the incident checkout
`../ai-resources-diagnostics-workflow`, `git status --short` shows three run files from the
2026-08-10 run still **untracked**, alongside an uncommitted state file. The concern is therefore not
a repo-wide untracked state; it is a **per-checkout evidence-lifecycle gap that surfaces in linked
worktrees** (claim 7). A framing whose facts could not have come out differently is not a framing —
these did: the supplied candidate asserted the problem was in this checkout, and it is not.

**Why it is a decision and not a defect.** The dispatcher's default log directory sits inside the
checkout being driven (`dispatch.sh:385`) and inside its own `--allow-path` default (`:317`). Run
files are written, pass every guard, and then wait for a human to commit them. In a canonical
checkout that human arrives. In a short-lived worktree they do not, and the worktree is removed with
the only copy of the evidence inside it. Nothing here is broken code — the behaviour follows from a
default nobody has chosen deliberately.

| Option | What it buys | What is lost | Narrowest reversible boundary |
|---|---|---|---|
| **Track and commit run evidence per run** | Evidence survives worktree removal. Forensics are always available, which is exactly what this case needed and did not have | Repository growth, and every run adds commit noise to an unrelated history | Add nothing to `.gitignore`; make committing run evidence part of the closing hop. Reversed by stopping, with the already-committed evidence retained |
| **Ignore it; treat the checkout as ephemeral** | No growth, no noise. Honest about run files being disposable | The 2026-08-10 evidence would not exist. This case would be unresolvable | One `.gitignore` line. Reversed by removing it — but evidence lost while it was in force does not come back |
| **Track in the canonical checkout, ignore in linked worktrees** | Matches the observed asymmetry: the canonical checkout keeps evidence, throwaway worktrees do not accumulate it | Two behaviours to understand, and the worktree case is precisely the one where evidence was lost | A worktree-local `.git/info/exclude` rather than a tracked `.gitignore`, so the rule does not propagate. Reversed per worktree |

**What this plan recommends, and does not decide.** Option 1, on the strength of the case at hand: the
only reason this incident could be investigated at all is that some evidence was preserved, and the
option that reliably preserves it costs repository growth — the cheapest of the three costs on the
table. **Option 3 is the trap:** it is the most sophisticated-looking answer and it optimises exactly
the wrong side, keeping evidence where loss was never observed and discarding it where loss actually
happened. The operator decides.

**Boundary, in every case.** No `.gitignore` change and no `git add` of run evidence happens before
this decision is taken. No change to `dispatch.sh:385`. No cleanup of existing run evidence in any
checkout — the incident files are inputs to the discovery unit (§ 0.5), and deleting them would
foreclose route step 1.

---

## 9. Why the plan's soundness is not testable by execution

Required by the brief, and it is the same rule this plan applies to its own units.

This artifact is a set of classifications, options and boundaries. Its failure modes are
*misclassification* — calling an already-built thing a defect, a policy decision a fix, or missing a
settled decision a unit would reopen — *starting too low on the ladder*, which the first correction
caught, and *stating hypotheses as findings*, which the independent review caught in v0.1. All three
are settled by reading the repository and the governing documents, which §§ 1–3 do and cite. Running
the dispatcher would exercise the current code; it would not say whether the ladder was applied
honestly, whether `acceptEdits` is the operator's to decide, or whether the proportionality preflight
duplicates core § 3. An AI-backed check would be worse than useless: it would consume the exact
resource this plan exists to bound, while grepping for words this plan supplied.

**What makes it fail-capable instead.** Each classification is traceable to a named file and line and
could have resolved differently — and several did. Claim 2b was **not** confirmed and its candidate
was narrowed rather than adopted. Claim 7 came out **false for this checkout** and its candidate was
re-scoped. The postmortem's "current repository state" was found **stale**. In the first correction,
the plan's own leading proposal lost its override mechanism (§ 3.3) and its overclaim (§ 3.4), and the
package became a set of outcomes with construction deferred. In this revision, the plan's central
outcome statement was **narrowed against its own § 3.4** (finding 3), its causal spine was demoted to
hypothesis (finding 2), and one of its ten units was **deleted rather than rewritten** (finding 6). A
plan that had agreed with every input, including its own two prior versions, would be evidence of
nothing.

---

## 10. Source-to-plan coverage

| Source | Where used |
|---|---|
| Postmortem, `~/.codex/attachments/c97f82c6-…/pasted-text.txt` (290 lines, read in full) | § 2 all three candidate tables; § 3.3; § 4 |
| `.agents/skills/work-loop-v2/references/repository-problem-resolution-sop.md` — related documents and vocabulary caveat (`:37`, `:59`), case outcomes (`:44-60`), Step 1 qualification (`:89-110`), authority hierarchy (`:362`), **B1 context manifest (`:364-374`)**, **B2 gate 2 and forensic route (`:376-388`, `:408-421`)**, B3 fresh-context rule (`:448-460`), B4.2 ladder (`:527-538`), **B5 design challenge (`:606-612`)**, B6 scope lock (`:685-701`), B9 closure (`:835-873`), durable-fix definition (`:920`), warning signs (`:922-945`), **high-risk changes (`:947-951`)**, limits of the approach (`:953-961`), unresolved authority overlap (`:1020`) | § 0 in full; § 3; § 5; § 6; § 8 |
| `dispatch.sh:282-303` (parser) | Claim 1, claim 6 |
| `dispatch.sh:1687-1694` (attended launch) | Claim 1; § 3.2 rung 4; U1; § 8 decision 1 |
| `dispatch.sh:1148-1152, 1325-1330` (attended posture, `claude_deny=none`) | Claim 5; § 3.2 rungs 3–4; U1 |
| `dispatch.sh:236-242` (`UNATTENDED_BASE_DENY`) | Claim 5; § 3.2 rung 5; U1 exclusions |
| `dispatch.sh:1416-1418` (`state_dirty`), `:1917`, `:2007-2019` | Claim 2a; § 0.2 false-report trigger; U2 |
| `dispatch.sh:1793-1795` (pre-flight exit 25) | Claim 2b; U2 narrowing |
| `dispatch.sh:1364-1375` (`foreign_worktree`), `:1390-1392` | P0-4; U2; § 8 decision 1 risk |
| `dispatch.sh:419, 1123-1124, 1294, 1502-1503, 1596-1597, 1786, 1894, 1978` | Claim 3; U5 |
| `dispatch.sh:121-166` (exit taxonomy) | Claim 4; U2, U3 |
| `dispatch.sh:1020-1092` (`--status`), `:1038` | Claim 6; U8, U9 |
| `dispatch.sh:385, 317` (default log dir, default allowlist) | Candidate B; § 8 decision 2 |
| `dispatch.sh:643-670, 848-855` (census, teardown) | Claim 5; § 3.4; U8, U9 |
| `dispatch.test.sh:1945, 1974, 2075, 2324` (argv capture) | Verification budget; U1 evidence; § 6.1 |
| `README.md:44, 307, 316, 837` | Claims 1, 4; U3 fixture |
| `.agents/skills/work-loop-v2/SKILL.md:195, 250-256, 450, 505, 517-527` | § 0.2 prior-control trigger; § 3.2 rungs 1–2; U4; U6; P1-3 duplicate finding |
| `.claude/commands/work-loop-v2.md:209` | U4 verification budget; the prose-evidence rule |
| `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` §§ 3, 4, 6, 7 | § 0.1; § 6.4; § 7; § 8 items 2–4; P1-3 and P1-4 rejections |
| `logs/work-loop/axcion-harness-v0-2-p0-f-attended-policy.md` (incl. `:47`, the recorded `pass=375 fail=0`) | § 0.5 tests; § 5 verification budget; § 8 item 1 and decision 1 |
| `plans/work-loop-v2-v0.2/unattended-operation-plan-v0.2.md` (status table; 1a; 1g; § Deferred) | § 8 items 5–6; U8, U9 |
| `logs/improvement-log.md`, 2026-08-02 entry (slice-1 harness red baseline) | § 0.5 tests — recorded to prevent conflation with `dispatch.test.sh` |
| `../ai-resources-diagnostics-workflow` (git state, `9a8399c`, `ea77d66`, untracked run files) | Claim 7; stale-source correction; § 0.5; § 8 decision 2 |
| Workspace `CLAUDE.md` § Independent Review Rule | § 6.5 conflict and its resolution |
| Independent SOP-conformance review of v0.1, 2026-08-11 (six findings) | § 0.0; § 0.3; § 0.4 step 4; § 0.5; § 0.6; § 3.1; § 4; U1; U7 retirement; § 6.5; § 8 decision 2 |

---

## 11. Recommended first move

**Not an implementation unit. The first move is route step 1 (§ 0.4): establish the failure from the
preserved run evidence, as a discovery unit.** Route step 0 — the context manifest — is complete as
of this revision (§ 0.5), so that unit can open against a bounded surface immediately.

This was already a change from the plan's first version, which recommended building U1 immediately.
That recommendation started at the design stage without having passed Gate 2 or Gate 3, and it carried
a mechanism (`--allow-nested-actors`) that no evidence justified. Recommending construction before the
failure is established is the same error in miniature that this case exists to correct.

**Why failure proof first.** It is cheap — the evidence already exists in the four dispatcher run
logs, the hop captures, the incident state file and the incident worktree's Git history. It requires
no live reproduction, no dispatcher run and no model invocation. And it is the only step that can
disprove the current diagnosis: if the preserved logs show the cost came from a single long session
rather than from nested invocations, then O1 is aimed at a symptom and the whole package needs
reframing (§ 0.6, § 3.4). Building first would foreclose that.

**One thing to do before that unit opens.** The evidence it depends on is loss-exposed — three run
files and a state file exist only in the incident checkout's working tree, uncommitted (§ 0.5). They
are preserved first, without staging unrelated work in that checkout. Losing the evidence would move
this case to *Not confirmed* permanently.

**When construction does come, O1 is the first outcome to pursue**, for the reason the first version
gave and which survives: it is the smallest change on the list, it reuses a mechanism that already
exists rather than adding one, it reopens no settled decision, and it acts on **H4 (§ 0.6, INFERRED)**
— the hypothesis that nesting is the mechanism that turned one unit into ≥13 Claude processes. What
does **not** survive is the claim that it makes the runaway impossible to reach. It denies the default
direct route by permission policy; it is not containment, a determined child can attempt to evade it
from a shell, and the observation that would disprove it is stated in § 3.4.

**This plan authorizes nothing and performs nothing.**
