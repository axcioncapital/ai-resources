---
task: work-loop-v2-concurrent-task-isolation
turn: codex
---

## Objective and scope

Make concurrent Claude and Codex work a safe, supported Work Loop v2 operating model: when another useful task starts, the system should handle routine isolation mechanics, preserve task-to-checkout continuity across handoffs, make ownership visible, and refuse duplicate ownership of either a logical task or a writable checkout.

The target operator experience is automatic creation or reuse of a dedicated task worktree when concurrent writing requires isolation, without requiring the operator to reason through Git mechanics. Human control remains mandatory for whether tasks genuinely belong together, merge and final landing decisions, conflict resolution, and destructive cleanup. Excluded are automatic push, merge, branch deletion, worktree deletion, conflict resolution, universal one-worktree-per-session behavior, a general scheduler, a persistent task registry, and any second semantic state system.

Task exit condition: the repository contains an implemented and evidenced minimum mechanism, integrated with Work Loop v2's existing entry and handoff surfaces, that safely supports two concurrent tasks in one repository on separate worktrees, rejects the same logical task in two worktrees, rejects two dispatched writers in one physical checkout, reuses the bound task worktree on later handoffs, and presents understandable ownership/status information.

Governing task method: apply the structural route in `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.agents/skills/work-loop-v2/references/repository-problem-resolution-sop.md` inside the Work Loop v2 unit cycle: failure proof; blind fresh-context evidence review; causal model and structural options; Codex complexity challenge and operator scope lock; controlled Claude implementation; independent clean-environment verification; operator-controlled integration and representative fan-out-2 validation. Preserve this sequence through compaction and future unit rewrites without adding a second case document or state system.

## Lane and unit

Standard. Discovery mode. Unit 4 — SOP Step B4: build the evidence-supported causal model, compare structural options, and return a proposed scope for challenge before any implementation.

Named reason for the loop: the work spans investigation, planning, implementation, and independent assessment; its scope crosses existing concurrency and transport controls and must remain bounded before changes begin.

## Brief

The failure proof, fresh-context review, and controlled matrix now establish enough mechanism and consequence to begin the SOP's causal-model step. A live `claude -p` or `codex exec` run is not required for this unit: model-specific discipline could change frequency, but it cannot negate the executed `TMPDIR` bypass, shared-index contamination, or fragmented visibility. This unit must turn the evidence into competing structural explanations and options without treating one patch as inevitable.

Required outcome: perform SOP Step B4 and return a causal model, option comparison, recommendation, proposed implementation boundary, and behavioural verification plan. Do not implement, edit production resources, create a branch/worktree, or run more concurrency experiments; only update this state file for the handback.

Authority and evidence inputs:

- The operator requires concurrent Claude and Codex work to be a safe supported operating model now. Routine isolation may be automated when concurrent writing requires it, but task grouping, merging, final landing, conflict resolution, and destructive cleanup remain human decisions.
- The approved Work Loop v2 proposal, executable core, and deployed actor resources remain semantic authority. The proposal's original post-MVP deferral of isolated worktrees and single-writer enforcement is superseded for this bounded task by the later operator decision plus observed conflicts; its principles of one semantic interface, minimal machinery, and evidence-triggered scope still govern.
- The Repository Problem Resolution SOP's structural Lane B governs the investigation sequence. Step B4 requires a falsifiable causal chain, competing explanations, the option ladder, a least-complex recommendation, complexity effect, proposed scope, and verification plan.
- Gate 2 failure evidence is in commit `7a13a45`. Unit 3's full current matrix is below and was committed by Claude as `395edd1`; Codex accepts it without rerunning because it contains falsifiable controls and directly observed effects.
- The independent blind review was performed read-only by a fresh Codex subagent with zero inherited turns and without the task file, Claude's candidate explanations or qualification, the non-governing investigation, or a proposed plan. It independently confirmed that the checkout+task lock admits both cross-pairs, ownership is path-only/manual, dispatcher status is exact-lock-only, and the Claude hook does not enumerate Codex; it identified distinct `${TMPDIR}` roots and interactive/dispatched visibility as unresolved explanations. Unit 3 then confirmed both.

Codex assessment and framing decisions for this unit:

1. Treat Unit 3 as sufficient for causal modelling. Real model actors, fan-out above two, field frequency, and a causal link to historical loss remain explicit unknowns, but none blocks explaining or correcting the demonstrated mechanisms.
2. Do not force one cause across different harms. At minimum distinguish: identical checkout+task admission across different lock roots; duplicate logical-task ownership across worktrees leading to divergent state and a landing conflict; different tasks sharing one checkout/index leading to cross-task commit contamination; and fragmented ownership/status surfaces that miss neighbouring writers or report the wrong cause. Determine whether these share one enabling system property or require several causal chains.
3. The misattributed exit 24/25 diagnostics are in scope for analysis because understandable ownership/status information is part of the task exit condition. They need not become a separate repair if the recommended intervention removes the triggering state; otherwise state whether correcting them is necessary or a justified deferral.
4. Preserve the operator's target experience, but do not launder a mechanism into a requirement. Automatic create-or-reuse when isolation is actually required is the desired behaviour; the storage, lock, discovery, and attachment mechanism remains for the options analysis to justify.

Produce, in plain language:

1. **Causal chain(s).** For each materially distinct failure: observed failure → immediate technical mechanism → enabling system property → broader failure class → intervention point. Name the safety invariant each chain violates and explain why the evidence supports every link.
2. **Competing explanations.** Cover every credible alternative, supporting and contrary evidence, confidence, remaining unknowns, and a concrete observation that would disprove each preferred diagnosis. Separate mechanisms proven by execution from claims about real-world frequency or historical causation.
3. **Structural options.** Compare the SOP ladder in order and justify every skipped rung: eliminate the trigger; simplify the operating model; remove the component; narrow or reuse an existing mechanism; isolate the capability; redesign the mechanism; repair the implementation; add a guard/control last. For every realistic option state what mechanism it changes; whether it prevents, contains, or detects each demonstrated failure; permanent complexity added and removed; maintenance owner; new failure modes; operational limits; reversibility; migration; and behavioural test.
4. **Recommendation.** Select the least-complex intervention that removes or materially reduces all safety-critical proven mechanisms. Do not present it as inevitable, and identify any part that is only a containment measure.
5. **Complexity effect.** List permanent machinery added, machinery removed or made obsolete, continuing maintenance, and whether the repository becomes structurally simpler. The default complexity budget is zero: justify every net-new persistent mechanism.
6. **Proposed scope.** Name exact existing components/files expected to change and the behavioural change in each; what old mechanism/instruction should be deleted or replaced; what remains unchanged; explicit non-goals; migration or compatibility needs; and any cross-repository effect. This is a proposal for Codex's Step B5 challenge, not approved implementation scope.
7. **Verification plan.** Turn the confirmed fixtures into behaviour-focused failing and passing cases for: identical-pair exclusion independent of `TMPDIR`; same-task/two-worktree refusal; two-task/one-checkout refusal; safe fan-out of two tasks on separate worktrees; later handoff reuse of the task-bound checkout; and operator-readable ownership/status across Claude/Codex and interactive/dispatched surfaces. Say what observable result would falsify the correction, and distinguish tests required before implementation acceptance from representative operator validation after integration.

Constraints and exclusions:

- No implementation and no production-file modification in this unit. Do not silently begin SOP Step B6 or create the eventual worktree.
- Do not propose automatic merge, push, landing, conflict resolution, branch/worktree deletion, universal one-worktree-per-session behaviour, a general scheduler, a persistent task registry, or a second semantic state system.
- A new command, agent, hook, database, service, recurring process, duplicated document, or additional gate is presumptively out. Include one only if removal, simplification, or reuse of existing machinery cannot satisfy a proven invariant, and state how it fails visibly and can later be removed.
- Check current repository surfaces before naming an exact scope. If the evidence or authority premise is false, report the mismatch and hand back rather than adapting silently.

Completion condition: `## Latest result` contains the complete B4 output and an explicit statement whether evidence is sufficient for Codex Step B5. Set `turn: codex`, commit only the state-file handback, and stop. Do not implement or ask the operator to approve scope yet.

## Latest result

Inspected (2026-08-11):

- Claim (1) — Gate 2 failure evidence is in commit `7a13a45`: **HOLDS** — `git log -1 --format='%H %s' 7a13a45` returns `7a13a452e685… work-loop: concurrent-task-isolation unit 1 — failure proof and Lane B qualification`.
- Claim (2) — Unit 3's matrix was committed as `395edd1`: **HOLDS** — `git log -1 --format='%H %s' 395edd1` returns `395edd1ffe98… work-loop: concurrent-task-isolation unit 3 — real-actor concurrency matrix`.
- Claim (3) — the SOP at `ai-resources/.agents/skills/work-loop-v2/references/repository-problem-resolution-sop.md` governs Step B4, and B4 requires a falsifiable chain, competing explanations, the ladder, a least-complex recommendation, complexity effect, proposed scope and a verification plan: **HOLDS** — read lines 512–604. B4.1 states the five-link chain and demands "what finding would disprove the diagnosis"; B4.2 lists the eight rungs in the order the brief gives; Prompt B4 lists outputs 1–7 exactly as briefed.
- Claim (4) — `dispatch.sh:484` builds `LOCK_KEY` from `checkout|task`, `:485` places `LOCK_DIR` under `${TMPDIR:-/tmp}`: **HOLDS** — both lines read exactly as the accepted matrix quotes them.
- Claim (5) — `.claude/hooks/detect-concurrent-session.sh:89` defaults `CC_PROCESS_PATTERN` to `native-binary/claude`: **HOLDS** — the line reads `CC_PROCESS_PATTERN="${CC_PROCESS_PATTERN:-native-binary/claude}"`.
- Claim (6) — `.claude/hooks/log-write-activity.sh:7` targets `$PROJECT_DIR/logs/friction-log.md`: **HOLDS** — `FRICTION_LOG="$PROJECT_DIR/logs/friction-log.md"`.
- Claim (7) — the default allowlist at `dispatch.sh:317` is `('^logs/work-loop/' '^plans/work-loop-v2-v0\.2/handoff-automation-spike/')`: **HOLDS**.
- Claim (8) — the two misattributing diagnostics are live strings in the current dispatcher, not artefacts of the fixture: **HOLDS** — `die 24 "Codex moved HEAD ($before_head -> $after_head) — Codex never runs git (core § 4)"` at `dispatch.sh:1991`; `die 25 "Claude edited logs/work-loop/$TASK.md but left it uncommitted (hop $hop) …"` at `dispatch.sh:2011`.
- Claim (9) — the authority premise, that the proposal's post-MVP deferral of isolated worktrees and single-writer enforcement is superseded for this task: **HOLDS, and needs less than the brief claims.** `plans/work-loop-v2-mvp/work-loop-v2-mvp-proposal-v0.4.md:154` heads that section "Post-MVP (**evidence-triggered**, not scheduled)"; line 158 defers "isolated worktrees"; line 160 defers "any enforcement mechanism for single-writer ownership (**an operating assumption until recurrence proves otherwise**)". The proposal does not have to be overridden — it makes both items conditional on evidence, and Unit 3 is that evidence. There is no conflict between the proposal and the operator decision to resolve.

Also inspected, because the recommendation below rests on them (throwaway `mktemp -d` fixture under the session scratchpad; no repository, branch or worktree of this workspace was touched):

- `git rev-parse --path-format=absolute --git-common-dir` returns the **same** absolute path from a main checkout and from its linked worktree, and a directory created there from one is listed from the other. The Git common directory is therefore a repository-wide, `TMPDIR`-independent place to hold a lock — and `dispatch.sh:1202` already calls that exact command for the `--unattended` sandbox profile, so using it is reuse of a proven call, not a new dependency.
- `git worktree add <path> <branch>` **refuses** a branch already checked out elsewhere: `fatal: 'feat' is already used by worktree at '…/wt1'`.
- `git worktree add` **refuses** an existing path: `fatal: '../wt1' already exists`.
- `git worktree list --porcelain` prints `branch refs/heads/<name>` for each worktree, so a branch→checkout lookup needs no new storage.
- A failing-case harness already exists at `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, whose Case 0 points the suite at an absent dispatcher and asserts the suite goes red. New behaviour cases have a home; no new harness is required.

Result: SOP Step B4 is complete. The four harms resolve into **two** causal chains, not one and not four: a keying-and-location chain that explains M1b, M2, M3a, M3b and M3d, and a diagnostics chain that explains the misattributed exits and the blind status surfaces and is largely downstream of the first. The ladder was walked from rung 1; the recommendation sits at rungs 2 and 4 (simplify the operating model, reuse existing mechanisms) and adds no command, agent, hook, registry, service or gate. Evidence is sufficient for Codex Step B5.

Evidence: every claim above was settled by opening the named file or running the named command in this session, and each could have read the other way — the fixture's two `git worktree add` calls were issued expecting success and returned `fatal:` refusals, and the `--git-common-dir` comparison would have printed two different paths had linked worktrees kept separate stores. Section 2 below states, for each preferred diagnosis, the concrete observation that would disprove it. The accepted Unit 3 matrix is not restated here; it is committed at `395edd1` and cited by case id (core § 4 — Git holds the history).

---

### 1. Causal chains

#### Chain A — one lock is asked to express two invariants, and is kept where neither lives

**Observed failure.** Four distinct harms, all beginning with an admission that should have been a refusal: two dispatchers admitted for the same task under different `TMPDIR` roots (M1b); one logical task committed twice on two branches and colliding only at the merge (M2); two tasks in one checkout producing a commit that carried only the *other* task's file (M3a) and a commit that carried another task's half-written file (M3b); and the allowlist guard admitting a second task because both tasks' state files sit under the one allowed prefix (M3d).

**Immediate technical mechanism.** Exclusivity is decided by whether one directory exists. Its name is a hash of `checkout|task` (`dispatch.sh:484`) and its parent is `${TMPDIR:-/tmp}` (`dispatch.sh:485`).

**Enabling system property.** Two things independently need protecting: *one writer per logical task*, which is a property of the repository as a whole and must hold across every worktree; and *one dispatched writer per working tree and index*, which is a property of one checkout. The dispatcher expresses both with a single key formed by joining them. A joined key is **permissive by construction** — it refuses only when both halves match, so a difference in either half admits. M2 differs in checkout only and was admitted. M3a/M3b differ in task only and were admitted. And because the directory lives under an ambient environment variable, even the matched case is conditional: M1a and M1b had the identical key `27b2db957c62b13a` and differed only in `TMPDIR`, and one refused while the other admitted two live actors.

**Broader failure class.** Coordination implemented as a single composite key, stored outside the resource it protects. Any system in this shape has the same two properties: it cannot refuse a partial match, and its guarantee depends on the caller's environment rather than on the thing being guarded.

**Intervention point.** Two moves, both structural rather than additive. First, stop the two dimensions being independent — make the checkout a function of the task, so "two tasks in one checkout" and "one task in two checkouts" become states the system cannot represent. Second, move what remains of exclusivity into the repository itself, so a refusal cannot depend on an environment variable.

**Safety invariants violated.** (i) At most one writer per logical task. (ii) At most one dispatched writer per index and working tree. (iii) A refusal must not be conditional on ambient environment.

**Why each link is supported.** M1a versus M1b is a controlled pair with the key held constant and only the directory varied, so the location is load-bearing and not an artefact. M2 and M3 each vary exactly one half of the key and each was admitted, so the conjunction is load-bearing. M3d shows the existing allowlist guard is not a substitute, because the prefix that makes it a real mitigation (`^logs/work-loop/`) is precisely the prefix every task's state file shares. M3a is the strongest single link: both actors staged by explicit pathspec and contamination still occurred, so the index is shared at a level no actor-side discipline reaches.

#### Chain B — the guards explain with a model that admission no longer guarantees

**Observed failure.** Exit 24 said Codex moved HEAD when the concurrently dispatched Claude actor for the *other* task moved it. Exit 25 said a run had died between editing and committing when in fact another task's run had committed the file. `--status` reported `run: none in flight` while a run was live in the same checkout under a different `TMPDIR`, and again for a different task in a checkout with a live run. The concurrency hook reported `0 in this folder` for a live Codex-shaped process while its Claude-shaped control reported `1`. A session marker was invisible from a linked worktree.

**Immediate technical mechanism.** Each surface reads one narrow input and then states a cause as fact. Exit 24 hard-codes the inference "HEAD moved during a codex hop, and Codex never runs git, therefore Codex moved it" (`dispatch.sh:1991`). `--status` inspects only its own `LOCK_DIR` and names that one path (`dispatch.sh:1058`). The hook matches one process pattern, `native-binary/claude` (`detect-concurrent-session.sh:89`). Markers are per-worktree gitignored files.

**Enabling system property.** Every ownership and status surface is scoped to a single writer and infers cause from a single-writer assumption — while admission, per chain A, permits several. The assumption was true when each surface was written and is not enforced anywhere.

**Broader failure class.** Diagnostics that assert a cause derived from an invariant the system does not enforce. These are worse than silence: an operator following exit 24 investigates Codex, which did nothing.

**Intervention point.** Mostly upstream. Remove the multi-writer states and most of these surfaces stop being able to lie: exits 24 and 25 lose the trigger observed in M3a/M3b, and the per-task `--status` blindness of M4b stops mattering because two tasks can no longer share a checkout. What remains reachable afterwards is exit 24's hard-coded attribution, which any non-dispatcher writer in the same checkout — an interactive session, the operator — can still trigger. The narrow intervention there is wording: report what was observed (HEAD moved during this hop) instead of naming an actor that was not.

**Safety invariant violated.** A stop message must not assert a cause it did not observe.

**Relationship between the chains.** Chain B is not independent. It is what chain A's admissions look like from the outside, plus one pre-existing wording defect that survives chain A's repair. Treating it as a separate repair programme would build detection for states the first fix removes.

---

### 2. Competing explanations

**Preferred diagnosis: chain A as stated.** Confidence **high** for the mechanism, **not established** for field frequency (below).

- **Alternative 1 — the real cause is the shared Git index, and the lock is incidental.** Supporting: M3a and M3b are index contamination, and no lock design prevents two processes sharing one index once both are running. Against: M1b and M2 involve no shared index at all. Verdict: **partly true, and it converges on the same intervention** — "a checkout hosts one task" removes the shared index as a concurrency surface. Absorbed into chain A rather than dismissed. Confidence that it is a *complete* explanation: low.
- **Alternative 2 — the cause is actor commit discipline.** Supporting: M3b's actor ran `git add logs/work-loop/`, a broad stage. Against: **M3a falsifies it inside the accepted matrix** — both actors staged by explicit pathspec and the commit still carried only the other task's file. Verdict: an amplifier of severity, not the enabling property. Confidence it is the cause: very low. This matters because it is the explanation that would have produced the wrong fix — instructing actors to stage more carefully.
- **Alternative 3 — the cause is insufficient visibility; fix the surfaces and operators will avoid collisions.** Supporting: every collision came with a blind or wrong surface. Against: M1b admitted two live actors with no operator in the loop, and a dispatched run is by definition unattended. Detection cannot prevent a write that has already been admitted. Verdict: chain B is real and is a consequence, not the cause. Confidence it is the cause: very low.
- **Alternative 4 — `TMPDIR` never differs in real invocations, so M1b is a laboratory result.** Supporting: genuinely `UNKNOWN`; the matrix tested the mechanism, not its frequency. Against: the diagnosis does not depend on it — M2, M3a, M3b and M3d are all independent of `TMPDIR`, and each was produced with a single ambient environment. Verdict: **frequency is unresolved and the recommendation does not rest on it.** Even at zero frequency, a guarantee that holds only for callers who happen to share an environment variable is an unstated precondition, and the fix that removes it costs one changed path.
- **Alternative 5 — the dispatcher is a labelled spike, so none of this is a defect.** Supporting: `dispatch.sh:1` says "SPIKE, not production", and its own header at lines 13–16 already states the intended model — one instance per task, each in its own linked worktree, same-checkout concurrency unsafe. Against: that intent is documented in a comment and enforced nowhere, and the operator's requirement is that concurrent work be safe **now**. Verdict: this is not an alternative diagnosis; it is an argument about where the fix belongs. It is answered in § 6 (scope) rather than here.

**What would disprove the preferred diagnosis.**

- If a second dispatcher for the same task, launched from the same repository with a single shared-location task lock held, is still admitted — then keying and location are not the enabling property, and the fault is in the lock's acquire path (`dispatch.sh:488`) instead. Reproducible with `matrix-a.sh`.
- If M1b's admission reproduces with an **identical** `TMPDIR` and an existing lock directory, the location half of the chain is wrong.
- If M3a's contamination reproduces in a checkout hosting exactly one task, then "a checkout hosts one task" does not remove the mechanism and the shared index needs its own treatment.
- If exit 24 is observed firing with a *correct* attribution in the M3a fixture, chain B's misattribution claim is wrong.

**Proven by execution, and separately, not proven.** Proven: every mechanism above, by real OS processes performing real Git writes (M1a/b, M2, M3a–d, M5, M6). Not proven and still `UNKNOWN`: whether any real invocation path has ever supplied a differing `TMPDIR`; behaviour at fan-out above two; whether any recorded incident in this repository traces to these mechanisms; and whether a live model actor's own commit discipline changes the write effects. **No part of the recommendation is justified by frequency or by historical loss.** It is justified by demonstrated mechanisms plus an operator requirement.

---

### 3. Structural options

#### The ladder, walked in order

1. **Eliminate the triggering condition.** The trigger is concurrent work, which the operator requires — so not eliminable as a whole. **Partly taken:** a narrower trigger, *two tasks sharing one working tree*, is eliminable, and eliminating it removes M3a, M3b and M3d outright rather than guarding them.
2. **Simplify the operating model.** **Taken, and it is the core of the recommendation.** Bind one task to one checkout so the two lock dimensions stop being independent. The states behind M2 and M3 become unrepresentable rather than refused.
3. **Remove the problematic component.** Considered: delete the lock entirely and rely on Git. Git refuses one branch in two worktrees, but nothing stops two dispatchers in one checkout, so M1 survives. **Not fully takeable — but half of it is:** one of the lock's two key dimensions is removed by rung 2, which is a genuine deletion.
4. **Narrow or reuse an existing mechanism.** **Taken.** Reuse the existing `mkdir` atomic lock and its three-state pid inspection; reuse `git rev-parse --git-common-dir`, already called at `dispatch.sh:1202`; reuse `git worktree add`'s own refusals and `git worktree list --porcelain`; reuse the task-id filesystem-safety validation at `dispatch.sh:358–364`; reuse `dispatch.test.sh` for the new behaviour cases.
5. **Isolate the affected capability.** Already satisfied by rung 2 — the worktree *is* the isolation, and it is machinery the workspace already operates.
6. **Redesign the causal mechanism.** Skipped: a general ownership or leasing design is heavier than the problem, and rungs 2 and 4 already remove every proven mechanism.
7. **Repair the existing implementation.** Skipped as insufficient: moving `LOCK_DIR` alone fixes M1b and leaves M2, M3a, M3b and M3d untouched. It is Option B below and is listed to be rejected, not ignored.
8. **Add a new guard, warning, gate or control.** **Rejected.** A registry, a new hook, a pre-flight scanner or a new command all add permanent machinery to detect states that rung 2 makes impossible. Nothing below requires one.

#### The realistic options compared

**Option A — documentation and operator discipline only.**
Changes no mechanism. The dispatcher header and the playbook already state the intended model; the harms occurred anyway. Prevents nothing, contains nothing, detects nothing. Complexity added zero, removed zero. New failure modes: none, but every demonstrated harm remains reachable. Reversibility: total. Test: none possible — there is no behaviour to assert. **Listed as the baseline the others must beat.**

**Option B — move the lock only (`LOCK_DIR` → Git common directory, key unchanged).**
Changes the storage half of chain A. **Prevents** M1b. Does nothing for M2, M3a, M3b or M3d, because the composite key still admits any partial match. Complexity added: none. Removed: the `TMPDIR` dependency. Maintenance: none. New failure modes: a stale lock now persists in `.git` rather than in a temp directory that the OS eventually clears — visible and handled by the existing STALE LOCK path, but no longer self-cleaning. Operational limit: leaves the majority of the demonstrated harm in place. Reversible in one line. Migration: none. Test: run `matrix-a.sh` with two `TMPDIR` roots and assert the second dispatcher is refused. **Rejected as the answer, retained as one component of Option D.**

**Option C — two locks, both in the Git common directory: one keyed on the task, one on the checkout.**
Changes the keying half of chain A by splitting the conjunction into two independent claims. **Prevents** concurrent M1b, M2, M3a, M3b, M3d. **Does not prevent** the *sequential* form of M2 — task run in worktree A today, in worktree B tomorrow — because a lock exists only while a run is in flight, and M2's actual cost (a merge conflict discovered at landing) is a sequential cost surfaced later. Also does not satisfy the exit condition's "reuses the bound task worktree on later handoffs", for the same reason. Complexity added: one extra lock lifecycle in `dispatch.sh` (acquire two, release two, report two). Removed: the composite key and the `TMPDIR` dependency. Maintenance: modest — two locks means two stale-lock stories. New failure modes: partial acquisition (task lock taken, checkout lock refused) needs a defined unwind order or a run can strand a lock. Operational limit: continuity unsolved. Reversibility: high. Migration: none. Test: the six cases in § 7, of which case 5 (handoff reuse) fails by design. **This is the safety floor — the least-complex option that removes every safety-critical proven mechanism.**

**Option D — bind the task to a Git branch, and keep one repository-scoped task lock. (Recommended.)**
A dispatched task runs on branch `work-loop/<task-id>`. The binding record is the branch itself, which Git already stores, already excludes and already reports. Concretely: at admission the dispatcher resolves the task's branch, asks `git worktree list --porcelain` which worktree holds it, attaches there if one does, and creates the worktree if none does; it refuses visibly if the passed `--checkout` holds a different task's branch; and it holds one lock keyed on the task alone, in the Git common directory.

- *Which part of the mechanism it changes:* both halves of chain A. The checkout becomes a function of the task, so the two dimensions collapse into one and the joined key is no longer needed; and the one remaining lock moves into the repository.
- *Prevents / contains / detects:* **prevents** M1a and M1b (one task-keyed lock, repository-scoped, environment-independent); **prevents** M2 in both its concurrent and sequential forms (one branch cannot be checked out twice — Git refuses, verified above — and a later handoff finds the same worktree instead of a second one); **prevents** M3a, M3b and M3d (a checkout carries exactly one branch, therefore exactly one task); **contains only** the exit-24 wording defect, which is a residual of chain B and not removed by any of this.
- *Complexity added:* one naming rule (`work-loop/<task-id>`), and one create-or-reuse step in the dispatcher's admission path. No new file, command, agent, hook, registry, service or gate.
- *Complexity removed:* the composite lock key; the `TMPDIR` dependency; the allowlist's informal role as a cross-task safety measure (it stays a foreign-change guard, which is what it was designed to be); and the reachability of the M3-class states that exits 24 and 25 misdescribe.
- *Maintenance created:* one convention to keep true, owned by whoever owns `dispatch.sh`. No recurring process.
- *New failure modes, stated plainly:* **the dispatcher gains authority it does not have today — it would create a branch and a worktree.** That is the single biggest change in this proposal and the thing Codex should challenge hardest at B5. Mitigations that keep it bounded: create only, never delete, never merge, never push; refuse rather than guess whenever the state is ambiguous (path exists but is not a registered worktree; branch exists but is checked out somewhere unexpected; `git worktree list` shows a prunable entry); and reuse Git's own refusals rather than pre-checking and racing.
- *Operational limits:* it binds **dispatched** writers only. An operator opening two interactive windows on one checkout is unchanged — that is the playbook's Mode A, which `/new-worktree-session` and the concurrency nudge already own, and it is out of scope here. Worktrees accumulate, because deletion stays a human decision by the operator's own constraint. And one branch per task changes landing from one merge per session to one merge per task.
- *Reversibility:* high in code, lower in practice — branches and worktrees created under the convention outlive a revert and would need manual teardown.
- *Migration:* real, and it must be visible rather than silent. Existing open tasks have no task branch. **This task is the live example:** `work-loop-v2-concurrent-task-isolation` currently runs interactively on `session/2026-08-11-work-loop-ceremony`, which is not `work-loop/work-loop-v2-concurrent-task-isolation`. Applying the rule naively would relocate work in flight. Proposed handling for B6: the rule governs dispatched runs from the change forward; a task already on a non-conforming branch is reported at admission with its options, never moved automatically.
- *How it is tested:* all six cases in § 7, in `dispatch.test.sh`.

**Option E — derive the worktree path from the task id (`../<repo>-<task-id>`) instead of binding a branch.**
Same effect on chain A, with the binding carried by a filesystem naming rule rather than by Git. Advantage: no branch-practice change. Disadvantages: the binding is a convention the filesystem does not enforce, where Git genuinely enforces the branch one; it collides with `/new-worktree-session`'s existing rule of appending `-2`, `-3` to avoid clobbering, which is the exact opposite of reuse; and it dictates where a task must live, which is a harder constraint than dictating which branch it is on. **Second choice, and the fallback if the operator rejects one branch per task.**

**Option F — a persistent task→checkout registry, or a new command, hook or service.**
Explicitly excluded by the brief and independently unnecessary: Options D and E obtain the same binding from state Git already keeps. Rejected without further comparison.

---

### 4. Recommendation

**Option D**, with Option B's lock relocation folded into it, and Option E held as the fallback.

It is not inevitable, and two honest qualifications belong on it. First, **Option C is the least-complex answer to the safety question alone.** D is recommended over C because the task's own exit condition requires handoff continuity, and continuity needs something that persists between runs while a lock does not — and the cheapest persistent thing available is a branch name Git already stores and already excludes. If Codex judges continuity separable from safety, C is a defensible smaller landing.

Second, **the only part of D that is containment rather than prevention is the exit-24 wording.** Everything else removes the state instead of detecting it. Per the brief's framing decision 3: correcting exit 24 is **not necessary** for the exit condition once two tasks cannot share a checkout, because the observed trigger disappears. It stays reachable through non-dispatcher writers, so it is a **justified deferral** if Codex wants minimum scope, and a one-line honesty fix if not. My recommendation is to take the one line — it is inside a file the unit already opens, and leaving a message that names an actor it did not observe is the defect chain B exists to name.

---

### 5. Complexity effect

**Permanent machinery added:** one naming convention; one create-or-reuse branch in the dispatcher's existing admission path; one lock instead of one lock (relocated and re-keyed, not added). No new file, command, agent, hook, database, service, recurring process, duplicated document or gate. The default complexity budget of zero is met by net-new count.

**Permanent machinery removed or made obsolete:** the composite `checkout|task` key; the `${TMPDIR:-/tmp}` dependency; the allowlist's undocumented second job as a cross-task safety net; the reachability of the M3-class states behind two misattributing diagnostics; and the dispatcher header's comment-only statement of the one-task-per-worktree model, which becomes enforced behaviour rather than an unenforced note.

**Continuing maintenance created:** one convention, owned with `dispatch.sh`. No scheduled work.

**Is the repository structurally simpler?** Yes. It ends with one coordination dimension instead of two, one environment dependency instead of one plus an ambient variable, and an operating model that is enforced where it was previously only described. The honest cost against that: the dispatcher acquires the authority to create a branch and a worktree, which is a real expansion, and worktrees accumulate because their removal stays human.

---

### 6. Proposed scope — for Codex's B5 challenge, not approved

**Expected to change**

- `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` — the whole of the mechanism. (a) `:484–485` — one lock keyed on the task id alone, held under the Git common directory resolved by the call already used at `:1202`. (b) admission, after the existing task-id validation at `:358–364` — resolve `work-loop/<task-id>`, locate its worktree via `git worktree list --porcelain`, attach or create, and refuse visibly on any ambiguity, with new exit codes drawn from the unused range. (c) `--status` at `:987–1058` — enumerate the lock directory and `git worktree list` so the answer covers every task in the repository, not only the one asked about. (d) optional, per § 4 — `:1991`'s exit-24 text reports the observation rather than naming Codex.
- `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` — the six behaviour cases in § 7, alongside the existing Case 0 falsifiability proof.
- `docs/parallel-sessions-playbook.md` § 4, item 3 — its dispatched entry path currently states that the worktree is created by the operator and never by the dispatcher. If D lands, that sentence becomes false and must change with the code, not after it.
- `.claude/commands/new-worktree-session.md` — Step 1's rule of appending `-2`, `-3` to avoid clobbering directly contradicts reuse-by-binding. Either the two paths are reconciled explicitly or the command states that dispatched task worktrees are outside its rule. This is the one cross-surface conflict I found, and it is a wording change, not a behaviour change.
- `plans/work-loop-v2-v0.2/handoff-automation-spike/README.md` — records the dispatcher's contract; a scope change of this size makes it stale if left.

**What should be deleted or replaced:** the composite lock key and the `TMPDIR` lock root, replaced not patched; and the dispatcher header's claim at `:13–16` that multi-loop operation "is one instance per task, each in its own linked worktree", which stops being an instruction to the reader and becomes a statement of enforced behaviour.

**What must remain unchanged:** the executable core and the five-field state-file ceiling — **no new field, heading or frontmatter key**, and no checkout path recorded in the state file; the state file as the single semantic interface; `.claude/hooks/detect-concurrent-session.sh`, `.claude/hooks/check-foreign-staging.sh`, `.claude/hooks/log-write-activity.sh` and `logs/scripts/prime-session-entry.sh`; the existing exit-18 and exit-30 allowlist guards, which stay as defence in depth; `.claude/commands/work-loop-v2.md` and `.agents/skills/work-loop-v2/SKILL.md`, whose entry and handoff surfaces need no change because the binding is resolved by the dispatcher, not stated by an actor.

**Explicit non-goals:** automatic merge, push, landing, conflict resolution, branch deletion or worktree deletion; universal one-worktree-per-session behaviour; a scheduler; a persistent task registry; a second semantic state system; any change to interactive same-checkout concurrency, which the playbook and `/new-worktree-session` already own; and fan-out above two, which remains untested.

**Migration and compatibility:** as stated in Option D — the rule governs dispatched runs from the change forward, and a task already on a non-conforming branch is reported at admission rather than moved. The live example is this task.

**Cross-repository effect — verified, and it matters.** `dispatch.sh` exists as four independent copies: `ai-resources/`, `ai-resources-work-loop-ceremony/`, `ai-resources-eval/` and `ai-resources-diagnostics-workflow/`, all under `plans/work-loop-v2-v0.2/handoff-automation-spike/`. A change here does not propagate; it reaches the others only through the normal merge into `ai-resources`. Until it does, a dispatcher launched from another checkout keeps the old admission behaviour — which is itself a concurrency hazard during the transition and should be named in the B6 scope lock.

---

### 7. Verification plan

Six behaviour cases, one per clause of the task exit condition, added to `dispatch.test.sh` where Case 0 already proves the suite can fail. Each is written to fail first against today's dispatcher — the three retained matrix scripts (`matrix-a.sh`, `matrix-b.sh`, `matrix-c2.sh`, held outside the repository) are the confirmed fixtures they are derived from.

| # | Behaviour asserted | Fails today because | Falsified by |
|---|---|---|---|
| V1 | a second dispatcher for the same task in the same checkout is refused **whatever `TMPDIR` says** — run with two distinct roots and with one shared root as the control | M1b admitted with exit 22 and two live actors | any admission of the second dispatcher |
| V2 | the same task cannot be opened in two worktrees; the second attempt is refused with a message naming the worktree that holds it | M2 admitted both and produced a merge conflict at landing | two worktrees simultaneously holding the task |
| V3 | two different tasks cannot be dispatched into one checkout; the second is refused | M3a/M3b admitted both and contaminated commits | any commit containing another task's file |
| V4 | two different tasks on separate worktrees both run to completion, and **no commit contains the other task's file** | not currently guaranteed — M3d shows the allowlist admits when both tasks share the prefix | a cross-task path in either commit range |
| V5 | a later handoff for a task already bound to a worktree **attaches to that worktree** and creates no second one | no binding exists today; nothing persists between runs | a second worktree, or a refusal to attach |
| V6 | `--status` from any worktree, and with any `TMPDIR`, reports every in-flight task in the repository and the worktree each is bound to | `--status` read only its own lock path and reported `none in flight` during a live run | any live run absent from the answer |

**What result would show the correction failed.** Any one of: a second dispatcher admitted for the same task under a differing `TMPDIR`; a commit whose range contains a path belonging to another task; two worktrees holding one task at the same time; a handoff creating a second worktree for a task that already has one; `--status` omitting a live run visible to another caller; or — the regression risk specific to this fix — a *single* task failing to start because the binding logic refused a checkout that was in fact correct. The last one is the failure mode a create-or-reuse rule most plausibly introduces, and V5 is written to catch it.

**Required before implementation acceptance:** V1–V6 green in `dispatch.test.sh`, plus Case 0 still red-on-absent, plus one negative control per case in the style `parallel-isolation-check.sh` already uses — an expectation deliberately set wrong, to show the case can go red.

**Representative operator validation after integration, not before:** two genuinely useful concurrent tasks, run by the operator across separate worktrees with real Claude and Codex actors, through at least one handoff each, ending in a real landing. That run is the only place the two remaining unknowns can be touched — live model actors' own commit discipline, and whether the ownership and status information is actually understandable to a person rather than merely correct. It is explicitly **not** a precondition for accepting the implementation, and fan-out above two stays out of both stages.

---

### Sufficiency statement

**Evidence is sufficient for Codex Step B5.** The causal mechanisms are demonstrated by execution with controls, competing explanations are compared with one alternative falsified inside the accepted matrix, the ladder was walked from rung 1 with each skip justified, and disproving observations are stated for each preferred diagnosis. Three things remain open and none blocks the challenge: field frequency of a differing `TMPDIR`, fan-out above two, and any causal link to historical loss. The two decisions that need Codex's challenge and then the operator are the dispatcher's new authority to create a branch and a worktree, and whether one branch per dispatched task is acceptable practice.

## Blocker

None.

## Next action

Codex: run SOP Step B5 — challenge the diagnosis and the complexity in `## Latest result`. Four things need a decision before any scope lock:

1. **Chain A or a competing explanation.** Alternative 1 (the shared Git index is the real cause) is absorbed rather than dismissed, and Alternative 2 (actor commit discipline) is treated as falsified by M3a. Challenge both readings.
2. **Option D or Option C.** C is the least-complex answer to safety alone; D is recommended only because the task's exit condition requires handoff continuity, which a transient lock cannot provide. Decide whether continuity is separable from safety at this stage.
3. **The new permanent authority.** Option D lets the dispatcher create a branch and a worktree, which it cannot do today. This is the proposal's largest single change and needs the Step B5 test: what verified failure requires it, why simplification cannot cover it, how it fails visibly, and how it is removed later. One branch per dispatched task also changes landing practice and is an operator decision at B6, not a Codex one.
4. **The exit-24 wording.** Recommended as a one-line honesty fix; stated as a justified deferral if minimum scope is preferred. Choose one explicitly rather than leaving it unrecorded.

Two scope facts to carry into B6: `dispatch.sh` exists as four independent copies across the sibling checkouts, so a fix here does not propagate until it merges into `ai-resources`; and `.claude/commands/new-worktree-session.md` Step 1 uniquifies worktree paths with `-2`/`-3`, which directly contradicts reuse-by-binding and must be reconciled in wording.

No implementation has begun and no production file was modified. This unit changed only this state file.
