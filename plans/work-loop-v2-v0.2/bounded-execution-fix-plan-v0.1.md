# Work Loop v2 — bounded-execution fix plan, v0.1

**Written 2026-08-11 by Claude, under Work Loop v2 task `work-loop-v2-bounded-execution-fix-plan`,
Unit 1. Corrected once on 2026-08-11 against five frozen findings from Codex.** Planning artifact
only. Nothing here is authorized or implemented; every unit below is a proposal for Codex to assess
and the operator to approve.

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

*(Note of record: the SOP was committed to this repository at `3ef4313`, 2026-08-11 09:32 — one
minute after this plan's first version was committed at `95d10c1`, 09:31 — and was not among the
brief's named sources. That is why the first version did not apply it. It applies now.)*

### 0.2 Provisional qualification — this parent case is structural

Qualified against the SOP's Lane B triggers, provisionally, on current evidence. Four of the six
triggers are met:

| Trigger | Evidence |
|---|---|
| Crosses workflow / component / ownership boundaries | The failure spans the dispatcher (`dispatch.sh`), the Codex operating instructions (`SKILL.md`), the Claude command, and the operator's own transport behaviour. No single component owns it |
| Changes a shared mechanism or the operating model | The courier is the shared mechanism between Codex and Claude (core § 4). Any accepted fix changes how it launches actors or how a stop is read |
| Produced false-success or false-report behaviour | The dispatcher returned `STOP [25]` claiming Claude had edited the state file when the file was byte-identical and already dirty before launch (claim 2a, § 1). The system reported a specific cause that had not occurred |
| Survived a relevant prior control | `SKILL.md:195` already prohibited screen-driving Claude, in force, and the bypass happened anyway |

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
| 3 — Design approval (causal model supported, intervention approved) | **NOT reached** | No causal chain has been stated with a disproving observation, no blind independent review has run, and the operator has approved no design |
| 4 — Technical verification | **NOT reached** | Nothing is implemented |
| 5 — Operational closure | **NOT reached** | Nothing is integrated, and no representative use has happened |

**What exists today is a candidate inventory, not a diagnosis.** §§ 1 and 2 are inspection of current
code and classification of supplied proposals. Neither is failure proof, an independent challenge, a
supported causal model, or design approval. This plan does not claim any of those were completed, and
its recommendation in § 9 is a recommendation *for the next gate*, not an authorization.

### 0.4 The tailored route from here

Eight steps, tailored to this case. No new state system, no new artifact kind, no second task-state
file. Each step's product is either a section of this plan, a state-file field the core already has,
or a Work Loop unit.

1. **Establish the failure from preserved evidence, not a live reproduction.** The SOP permits this
   explicitly where reproduction is costly or unsafe, and here it is both — reproducing a runaway
   nested-AI session is the exact expense this case exists to prevent. The evidence already exists:
   the four dispatcher run logs and hop captures, the `STOP [25]` output, the state file of the
   incident task, and the incident worktree's Git history (`ea77d66`, `9a8399c`). This is a
   **discovery unit**, not an implementation unit.
2. **Blind raw-evidence review by a genuinely fresh Codex context.** That reviewer receives the
   problem statement and the raw evidence only — never this plan, never Claude's diagnosis, and
   never a document that links to either. The Codex context that framed this task cannot perform it,
   whatever instructions it is given.
3. **Claude reconciles the review into a causal model and options.** Causal chain with each link
   named, competing explanations, confidence, and — required — the observation that would disprove
   the diagnosis. Options compared down the ladder in § 3, not from the bottom up.
4. **Operator approves the scope.** Trade-off, not code: what changes, what stops happening, what is
   removed rather than added, whether permanent machinery goes down, how it is reversed. This is the
   gate the current plan has **not** passed.
5. **Implement in an isolated clean checkout** — a deliberate branch or worktree at an agreed clean
   base, opened as a **new Work Loop task**. Never by copying this task's state file (§ 6.4).
6. **Independent verification from a clean environment**, running the commands rather than reading
   Claude's report.
7. **One genuine attended pilot**, budgeted in advance: one task, at most one Claude actor
   invocation, ten minutes wall-clock, no nested AI, no scenario matrix.
8. **Close on observed behaviour.** Harness success alone does not close the parent case (§ 6).

### 0.5 Durable recovery chain — compaction-safe

If context is lost, this is what re-establishes the work. It lives here, in the plan, not only in
chat. **No context manifest file, case database, second task-state artifact or any other new file is
created to hold it.**

| Anchor | Value |
|---|---|
| Bound checkout | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources` |
| Active state file | `logs/work-loop/work-loop-v2-bounded-execution-fix-plan.md` |
| Candidate plan | `plans/work-loop-v2-v0.2/bounded-execution-fix-plan-v0.1.md` (this file) |
| Governing contract | `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` |
| Operating interfaces | `.agents/skills/work-loop-v2/SKILL.md` (Codex), `.claude/commands/work-loop-v2.md` (Claude) |
| Methodology reference (non-governing) | `.agents/skills/work-loop-v2/references/repository-problem-resolution-sop.md` |
| Incident evidence | `../ai-resources-diagnostics-workflow` — `logs/work-loop/diagnostics-workflow.md`, run files under `plans/work-loop-v2-v0.2/handoff-automation-spike/runs/`, commits `ea77d66` and `9a8399c` |
| Workflow phase | Route step 1 of 8 not yet started (§ 0.4). Gates 2–5 open (§ 0.3) |
| Current move | This one bounded plan correction. Claude implements no fix, runs no dispatcher or harness, and launches no nested AI |

---

## 1. Inspection — what the repository actually says today

Seven claims were checked by inspection before this plan was written. All paths are relative to the
`ai-resources` checkout at `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`; the
dispatcher lives at `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` and is referred to
below as `dispatch.sh`.

**What this section is.** Current-code inspection. It is **not** Gate 2 failure proof (§ 0.3) — it
establishes what the code does today, not what happened on 2026-08-10.

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
| **B. Decide whether `runs/` is tracked or ignored** | **Policy decision requiring the operator**, correctly raised but **mis-scoped** (claim 7) | Not a defect in this checkout, where evidence is fully tracked. The exposure is that the dispatcher's default log directory sits *inside the checkout being driven* (`dispatch.sh:385`) and inside its own `--allow-path` default (`:317`), so run files are written, pass every guard, and then wait for a human to commit them. In a short-lived worktree that human never arrives. **This unit does not make the decision** (brief boundary); Unit 7 frames it |

### Postmortem P0 candidates

| Candidate | Classification | Reasoning |
|---|---|---|
| **1. Attended permission-mode option (`--claude-permission-mode …`, incl. `acceptEdits`)** | **Policy decision requiring the operator** — capability gap is verified (claim 1), the change is not Claude's to make | This reopens a **closed** operator decision: `logs/work-loop/axcion-harness-v0-2-p0-f-attended-policy.md` (`turn: operator`, 2026-08-09) records launch-time `--permission-mode default` as *the settled attended mechanism*, chosen precisely so a child never inherits this checkout's `bypassPermissions`. Framed as a decision in § 5 |
| **2. Parse Claude's `permission_denials` into a permission-specific stop** | **Verified current defect** (claim 4) — **P0 outcome** | The incident's dead end was invisible to the dispatcher. It is also the candidate with the strongest indirect effect: a precise stop is what removes the *reason* to reach for an interactive session. Ladder position 7 (repair an implementation that writes a capture and never reads it), not 8 |
| **3. Correct dirty-state classification** | **Verified current defect** (claim 2a) — **P0 outcome** | `UNCOMMITTED_HANDBACK` must require evidence that Claude changed the file this hop. Ladder position 7 — the existing classification is simply wrong, and correcting wrong logic adds no machinery |
| **4. Report partial allowed-path effects honestly** | **Verified current defect** — **P0 outcome**, same code region as candidate 3 | `foreign_worktree()` (`:1364-1375`) reports only paths *outside* the allowlist, so in-allowlist implementation edits are structurally invisible; the `die 22` "no observable transition" text (`:2015`) mentions the state file only. Merged with candidate 3 into one unit rather than two, because they are one misreport with two faces |
| **5. Prohibit nested AI actors by default** | **Verified current defect** (claim 5) — **P0 outcome**; **construction not settled here** (§ 3) | The outcome — a dispatcher-launched actor cannot start nested Claude/Codex work by default — is retained. The postmortem's proposed construction included an `--allow-nested-actors N` override; that override is **rejected** for want of any verified authorised use case (§ 3.3) |
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
| **3. Task-scoped session counts** | **Valid later improvement, largely dissolved by the P0 outcomes** — **P2** | The count became untrustworthy *because* the dispatcher was bypassed and nesting was unbounded. With the nested-actor outcome and the no-fallback restriction in place, the run log's hop lines are already a task-scoped count. What survives is the reporting rule — never answer "how many sessions has this task used?" with workspace-wide telemetry — which is one sentence in the skill and can ride with P1 Unit 6 |

---

## 3. Intervention options — the ladder before the package

**Required by the correction, and it changes the shape of the recommendation.** The first version of
this plan proposed a package of controls without first asking whether anything could be *removed*,
*simplified* or *narrowed* instead. That is starting at the bottom of the ladder. This section starts
at the top.

**Complexity budget: zero.** No new permanent mechanism is proposed unless removal, simplification or
reuse of an existing mechanism demonstrably cannot achieve the outcome.

### 3.1 The outcome, stated without a construction

> A dispatcher-launched actor cannot start nested Claude or Codex work by default, and a dispatcher
> stop cannot be answered by leaving the dispatcher.

That is what must become true. **How** it becomes true is a design-gate decision (§ 0.3, Gate 3), not
a decision this plan is entitled to make. What follows compares the options; it does not choose among
the ones that survive.

### 3.2 The ladder, applied

| Rung | Option | Verdict on this case |
|---|---|---|
| 1 | **Eliminate the triggering condition** | **Adopt, and it is free.** The trigger was a brief that demanded behavioural verification of Markdown instruction files, which can only be satisfied by invoking Claude. A brief rule that forbids proposing nested AI invocation eliminates the demand at source. Zero machinery. **Insufficient alone** — it is written guidance, and the SOP's own definition of a durable fix excludes fixes that depend on a model remembering guidance. `SKILL.md:195` is the proof: it was in force and was violated |
| 2 | **Simplify the operating model** | **Adopt, and it is free.** The model already says one courier, one dispatcher, no screen-driving. The incident was a departure from the model, not a property of it. The simplification available is to remove the ambiguity a stop currently leaves about what may follow it — restoring the intended courier path rather than adding to it. Zero machinery. Same insufficiency as rung 1 |
| 3 | **Remove the problematic component** | **Credible, probably too broad.** The component is the attended child's unrestricted tool set (`dispatch.sh:1325`). Restricting the attended `--tools` roster removes capability rather than adding a guard, and the mechanism already exists on the unattended path. But Claude must run `git` to commit every hop (core § 4), and `git` arrives through Bash — so removing Bash removes the loop. A narrower roster is a design-gate question |
| 4 | **Narrow or reuse an existing mechanism** | **Leading candidate.** `--disallowedTools` already exists, already reaches attended hops when `--claude-deny` is set (`dispatch.sh:1687-1690`), and already composes additively rather than replacing. Adding `claude`/`codex` invocation rules to a default attended deny set reuses that mechanism and introduces **no new flag, no new subsystem and no new file**. Net new permanent machinery: zero |
| 5 | **Isolate the affected capability** | **Credible, disproportionate.** `--unattended` already isolates — the sandbox refuses network, so a nested `claude` call cannot reach the API at all. Making containment the default for attended runs would achieve the outcome through a mechanism already built and measured. It also changes the attended/unattended boundary, which is a settled artifact (plan v0.2, item 1d), and is a larger operating-model change than the proven mechanism requires |
| 6 | **Redesign the causal mechanism** | **Not warranted.** No evidence supports redesigning the courier |
| 7 | **Repair the existing implementation** | **Applies to the reporting defects, and lowers their burden.** The exit-25 misclassification is wrong logic (claim 2a), and the unparsed capture is a written-but-never-read file (claim 4). Correcting both is repair, not new control. One new exit code is the only addition, and it is a taxonomy entry rather than a mechanism |
| 8 | **Add a new guard, warning, gate or control** | **Rejected for the nested-actor outcome.** Rungs 1, 2 and 4 reach it between them without new machinery |

### 3.3 What was dropped, and why

**`--allow-nested-actors N` is dropped.** The supplied evidence contains exactly one instance of
nested AI invocation, and it is the failure. No verified authorised use case exists anywhere in the
postmortem, the run evidence, the plan spine or the skill. Adding an override flag would create a
mechanism whose only demonstrated use is the behaviour the mechanism exists to prevent, and would
require permanent maintenance, a count to enforce, an authorization to record and a test surface to
keep — all for symmetry. It is exactly the "new permanent mechanism" the SOP requires a verified
failure to justify, and none justifies this one.

**Consequence, stated plainly:** under this plan there is **no** supported way to run nested AI. A
future case that genuinely needs it goes to the operator as a capability question, at which point a
verified use case would exist and a mechanism could be justified on evidence. That is a deliberate
absence, not an oversight.

### 3.4 What the surviving options can and cannot prove

Kept separate on purpose, because conflating them is finding 3 in this correction.

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
  symptom and the causal model is wrong.
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
| **O1** | A dispatcher-launched actor cannot start nested Claude/Codex work by default | Deny rules added to the existing attended `--disallowedTools` path; brief rule forbidding the demand | 4 + 1 |
| **O2** | A stop names what actually happened — which files changed, and whether Claude touched the state file at all | Repair the classification logic and the reporting | 7 |
| **O3** | A permission dead end becomes a named stop carrying the denied tool, the target, and the decision required | Parse the capture already being written; one taxonomy entry | 7 |
| **O4** | A nonzero dispatcher exit is never answered by leaving the dispatcher | Place the existing prohibition at the point of failure | 2 |

**Why these four.** The incident's cost had two mechanisms: unbounded nesting (O1) and the
interactive bypass (O4). The bypass had one *cause*: the dispatcher reported the wrong thing and the
right thing was unavailable (O2, O3). Fixing the mechanisms without the cause leaves the same
temptation in place under a new prohibition — which is how `SKILL.md:195` already failed once.

**Why the permission-mode option is not in P0.** Without it, a permission dead end now *stops
honestly* instead of dead-ending silently. That is a safe outcome, not a blocked one. Adding attended
`acceptEdits` widens what a child may do without asking; it belongs in § 6 as an operator decision.

**If the operator wants less than four:** the irreducible pair is **O1 + O4**. That closes the
nesting path and removes the fallback. It leaves the misdiagnosis that caused the bypass in place,
and this plan does not recommend stopping there.

**Not in P0, and why:** state snapshots (U5 — forensics, not safety) · correction profile and nested-AI
prohibition (U6 — they govern the *next brief*, not the next run) · `runs/` disposition (U7 — an
operator decision) · richer `--status`, `--stop`, session counts (P2 — observability, not a boundary).

---

## 5. Implementation units

**Read these as scope proposals, not as approved work.** Each is independently assessable, and each
is subject to the design gate (§ 0.3). Construction details are the leading candidate at the time of
writing, not a locked design.

### Verification budget — applies to every unit below

- **Default method:** static inspection plus the existing simulated harness
  (`dispatch.test.sh`, currently 375 pass / 0 fail per the P0-F record). The harness already captures
  literal argv through a fake `claude` binary (`WL_ARGV_FILE`, `argv_pair`, `argv_has` —
  `dispatch.test.sh:1945, 1974, 2075, 2324`) and already drives full hop shapes through `--actor-cmd`.
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
  reports. It never establishes effective containment or real-world behaviour (§ 3.4, § 6).

### P0 units

#### U1 — Close the nested-actor path (outcome O1)

- **Observable outcome:** an attended Claude hop launched by the dispatcher cannot start `claude` or
  `codex` work by default, and the logged command line shows the policy that was requested.
- **Construction:** **not settled here.** Leading candidate is rung 4 — extend the attended
  `--disallowedTools` path (`dispatch.sh:1687-1690`) with a default deny set, composing with
  `--claude-deny` as that flag already composes. Rung 3 (a narrower attended `--tools` roster) is the
  alternative the design gate should compare it against. **No new flag is proposed, and no override
  mechanism exists** (§ 3.3).
- **Allowed surfaces:** `dispatch.sh` (deny set, launch construction, run-log lines),
  `dispatch.test.sh`, spike `README.md`.
- **Exclusions:** the `--unattended` contained profile (its deny set is a separate settled artifact);
  any settings.json in any layer; the executable core; the Claude command; the skill.
- **Dependencies:** design-gate approval of the construction. None otherwise.
- **Stop conditions:** if closing the gap requires editing a settings file rather than adding launch
  arguments — that reopens P0-F's settled mechanism, so stop and escalate. If a deny rule would also
  block the child's ordinary work (its own `git`, for instance), stop and hand back rather than
  widening. If the construction turns out to need a new flag after all, stop — that is a design
  change, and § 3.3 rejected the flag on the evidence available.
- **Minimum evidence that can fail:** matched red/green argv capture — against the pre-change
  dispatcher the new assertions must **fail**, and the existing 375 must still pass; against the
  changed one all pass. Plus one control: the `--unattended` argv is byte-unchanged.
- **What this evidence proves:** the requested policy reaches the child. **What it does not prove:**
  that a child cannot evade it. See § 3.4. The README states the distinction in the same breath, as
  P0-F already does for `--permission-mode`.
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
- **Verification budget:** static + harness + one recorded fixture. Zero AI invocations. The fixture
  is a *replay* of evidence already paid for; regenerating it live is out of budget.

#### U4 — A dispatcher stop is never authorization to continue by hand (outcome O4)

- **Observable outcome:** the Codex skill states, at the point where a stop is read, that a nonzero
  exit authorizes exactly two things — fix the cause and re-run the dispatcher, or stop for the
  operator — and never an interactive Claude session, a hand-carried hop, or a hand-edit of the state
  file. A dispatcher capability gap is a capability gap, not a licence.
- **Ladder position:** 2 — restoring the intended courier path. **This is a supporting operating
  restriction, not a causal fix.** Its presence is not evidence that any mechanism changed (§ 3.4).
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
- **Verification budget:** inspection only. Zero AI invocations, zero harness runs. Per the Claude
  command (`.claude/commands/work-loop-v2.md:209`), a prose change's evidence is the changed text.

### P1 units

#### U5 — Preserve the state file before each hop

- **Observable outcome:** each hop writes a byte-for-byte copy of the state file into the run
  evidence directory before the actor launches (`$RUN_ID.hop<n>.<actor>.state.md`), alongside the
  existing `.out` and `.tree`. The sha256 lines stay as they are.
- **Allowed surfaces:** `dispatch.sh` (`:1894` region), `dispatch.test.sh`, spike `README.md` § run
  evidence table (`:20`).
- **Exclusions:** the state file itself; retention or pruning policy for the evidence directory (U7's
  question); anything that reads the snapshot back and acts on it — this unit preserves, it does not
  compare.
- **Dependencies:** none. Interacts with U7.
- **Stop conditions:** if the snapshot would land anywhere the dispatcher's own allowlist does not
  cover, stop — a guard tripping on its own evidence is worse than no snapshot.
- **Minimum evidence that can fail:** run a simulated two-hop sequence; assert a snapshot exists per
  hop and that its bytes equal the pre-hop file, then mutate the file between hops and assert the two
  snapshots differ. Against the pre-change dispatcher, no snapshot exists at all.
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
- **Verification budget:** inspection only. Zero AI invocations.

#### U7 — Frame the `runs/` disposition as an operator decision

- **Observable outcome:** a short decision brief — not a decision — stating the three options
  (track and commit run evidence per run; ignore it and treat the checkout as ephemeral; keep it
  tracked in the canonical checkout and ignored in linked worktrees), each with what is lost, and the
  narrowest reversible boundary for each.
- **Allowed surfaces:** one new file under `plans/work-loop-v2-v0.2/`. **No `.gitignore` change and
  no `git add` of run evidence in this unit.**
- **Exclusions:** making the decision; any change to `dispatch.sh:385` (the default log directory);
  cleanup of existing run evidence in any checkout.
- **Dependencies:** none. Mention U5 if U5 has landed.
- **Stop conditions:** if the framing turns out to require deciding, hand back.
- **Minimum evidence that can fail:** the per-checkout state quoted for both checkouts, with the
  commands that produced it — this checkout 48/48 tracked, the incident worktree three untracked run
  files. A framing whose facts could not have come out differently is not a framing.
- **Verification budget:** inspection only. Zero AI invocations.

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
be established from the preserved evidence carries *not confirmed*, which is a valid result and not a
reason to manufacture a diagnosis.

### 6.4 Where implementation happens

**This planning task closes when the plan is accepted.** Implementation does not continue inside it.

Implementation opens as a **new Work Loop task**, in a deliberate isolated branch or worktree at an
agreed clean base commit, with its own state file named for its own task id. **Never by copying this
task's state file** — a copied state file carries a stale `task:` value, which core § 6 rule 2 and
the Claude command's identity check both reject read-only, and would be rejected on arrival.

The main checkout is not the implementation surface. One writer at a time; unrelated work is neither
staged nor committed; the rollback path is recorded before integration and stays usable after it.

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
- **No unit may create a second state system.** U5 writes evidence, not state; U7 decides where
  evidence lives, not what is true. The state file stays the single interface. The SOP's own context
  manifest is deliberately **not** created as a file — its content lives in § 0.5.

---

## 8. Settled decisions a proposed fix would reopen

Six. Each is named so no unit reopens one silently.

1. **Attended `--permission-mode default` is the settled attended mechanism.**
   Closed record: `logs/work-loop/axcion-harness-v0-2-p0-f-attended-policy.md`, `turn: operator`,
   2026-08-09. Adding `--claude-permission-mode acceptEdits` reopens it. **Operator decision, framed
   below.**
2. **Claude makes every commit** (core § 4). No recovery text, and no unit, may imply Codex commits.
   U2 carries the narrowing clause.
3. **The brief creates no new field, artifact or stage** (core § 3 step 3), and the state file holds
   at most five fields (core § 4). This rejects the proportionality preflight, constrains U6 to prose
   inside existing sections, and is why § 0.5 is a plan section rather than a manifest file.
4. **The dispatcher is transport** (core § 4 *An approved courier may carry the turn*). § 7 above.
5. **"A structured JSON outcome event plus observer process" is rejected**
   (`unattended-operation-plan-v0.2.md` § *Deferred*). Constrains U8.
6. **Phase 1 item 1a is narrowed, not closed** — a doubly-forked detached daemon still escapes the
   teardown. Constrains U9, and is a stated limitation of U1: a denied tool name is not a sandbox.

### The operator decision — attended `acceptEdits`

Stated with value, risk and the narrowest reversible boundary, as the brief requires. **Not decided
here.**

- **What it would allow.** A dispatcher option carrying an operator-approved permission mode into an
  attended Claude hop, so a run blocked on a permission gate can resume *inside the dispatcher*
  rather than by hand.
- **Value.** It closes the exact capability gap that produced the bypass. On 2026-08-10 the operator
  had already approved the edits; the dispatcher had no way to represent that approval, and the
  approval was then executed by driving Claude directly — which cost every safeguard at once.
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

---

## 9. Why the plan's soundness is not testable by execution

Required by the brief, and it is the same rule this plan applies to its own units.

This artifact is a set of classifications, options and boundaries. Its failure modes are
*misclassification* — calling an already-built thing a defect, a policy decision a fix, or missing a
settled decision a unit would reopen — and *starting too low on the ladder*, which is what the
correction caught. Both are settled by reading the repository and the governing documents, which
§§ 1–3 do and cite. Running the dispatcher would exercise the current code; it would not say whether
the ladder was applied honestly, whether `acceptEdits` is the operator's to decide, or whether the
proportionality preflight duplicates core § 3. An AI-backed check would be worse than useless: it
would consume the exact resource this plan exists to bound, while grepping for words this plan
supplied.

**What makes it fail-capable instead.** Each classification is traceable to a named file and line and
could have resolved differently — and several did. Claim 2b was **not** confirmed and its candidate
was narrowed rather than adopted. Claim 7 came out **false for this checkout** and its candidate was
re-scoped. The postmortem's "current repository state" was found **stale**. In this correction, the
plan's own leading proposal lost its override mechanism (§ 3.3) and its overclaim (§ 3.4), and the
package became a set of outcomes with construction deferred. A plan that had agreed with every input,
including its own first version, would be evidence of nothing.

---

## 10. Source-to-plan coverage

| Source | Where used |
|---|---|
| Postmortem, `~/.codex/attachments/c97f82c6-…/pasted-text.txt` (290 lines, read in full) | § 2 all three candidate tables; § 3.3; § 4 |
| `.agents/skills/work-loop-v2/references/repository-problem-resolution-sop.md` — Purpose/outcomes (`:39-60`), Step 1 qualification (`:89-110`), Lane B gates (`:350-362`), B2 forensic-evidence route (`:376-388`), B3 fresh-context rule (`:448-460`), B4.2 ladder (`:527-538`), B6 scope lock (`:685-701`), B9 closure (`:835-873`), durable-fix definition (`:918-921`) | § 0 in full; § 3; § 6 |
| `dispatch.sh:282-303` (parser) | Claim 1, claim 6 |
| `dispatch.sh:1687-1694` (attended launch) | Claim 1; § 3.2 rung 4; U1; § 8 decision |
| `dispatch.sh:1148-1152, 1325-1330` (attended posture, `claude_deny=none`) | Claim 5; § 3.2 rungs 3–4; U1 |
| `dispatch.sh:236-242` (`UNATTENDED_BASE_DENY`) | Claim 5; § 3.2 rung 5; U1 exclusions |
| `dispatch.sh:1416-1418` (`state_dirty`), `:1917`, `:2007-2019` | Claim 2a; § 0.2 false-report trigger; U2 |
| `dispatch.sh:1793-1795` (pre-flight exit 25) | Claim 2b; U2 narrowing |
| `dispatch.sh:1364-1375` (`foreign_worktree`), `:1390-1392` | P0-4; U2; § 8 decision risk |
| `dispatch.sh:419, 1123-1124, 1294, 1502-1503, 1596-1597, 1786, 1894, 1978` | Claim 3; U5 |
| `dispatch.sh:121-166` (exit taxonomy) | Claim 4; U2, U3 |
| `dispatch.sh:1020-1092` (`--status`), `:1038` | Claim 6; U8, U9 |
| `dispatch.sh:385, 317` (default log dir, default allowlist) | Candidate B; U7 |
| `dispatch.sh:643-670, 848-855` (census, teardown) | Claim 5; § 3.4; U8, U9 |
| `dispatch.test.sh:1945, 1974, 2075, 2324` (argv capture) | Verification budget; U1 evidence; § 6.1 |
| `README.md:44, 307, 316, 837` | Claims 1, 4; U3 fixture |
| `.agents/skills/work-loop-v2/SKILL.md:195, 250-256, 450, 505, 517-527` | § 0.2 prior-control trigger; § 3.2 rungs 1–2; U4; U6; P1-3 duplicate finding |
| `.claude/commands/work-loop-v2.md:209` | U4 verification budget; the prose-evidence rule |
| `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` §§ 3, 4, 6, 7 | § 0.1; § 6.4; § 7; § 8 items 2–4; P1-3 and P1-4 rejections |
| `logs/work-loop/axcion-harness-v0-2-p0-f-attended-policy.md` | § 8 item 1 and the decision |
| `plans/work-loop-v2-v0.2/unattended-operation-plan-v0.2.md` (status table; 1a; 1g; § Deferred) | § 8 items 5–6; U8, U9 |
| `../ai-resources-diagnostics-workflow` (git state, `9a8399c`, `ea77d66`, untracked run files) | Claim 7; stale-source correction; § 0.5; U7 evidence |

---

## 11. Recommended first move

**Not an implementation unit. The first move is route step 1 (§ 0.4): establish the failure from the
preserved run evidence, as a discovery unit.**

This is a change from the first version of this plan, which recommended building U1 immediately. That
recommendation started at the design stage without having passed Gate 2 or Gate 3, and it carried a
mechanism (`--allow-nested-actors`) that no evidence justified. Recommending construction before the
failure is established is the same error in miniature that this case exists to correct.

**Why failure proof first.** It is cheap — the evidence already exists in the four dispatcher run
logs, the hop captures, the incident state file and the incident worktree's Git history. It requires
no live reproduction, no dispatcher run and no model invocation. And it is the only step that can
disprove the current diagnosis: if the preserved logs show the cost came from a single long session
rather than from nested invocations, then O1 is aimed at a symptom and the whole package needs
reframing (§ 3.4). Building first would foreclose that.

**When construction does come, O1 is the first outcome to pursue**, for the reason the first version
gave and which survives: it is the smallest change on the list, it reuses a mechanism that already
exists rather than adding one, it reopens no settled decision, and it acts on the mechanism that
turned one unit into ≥13 Claude processes. What does **not** survive is the claim that it makes the
runaway impossible to reach. It closes the default path by permission policy; it is not containment,
a determined child can attempt to evade it from a shell, and the observation that would disprove it
is stated in § 3.4.

**This plan authorizes nothing and performs nothing.**
