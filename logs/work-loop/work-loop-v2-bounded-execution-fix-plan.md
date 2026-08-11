---
task: work-loop-v2-bounded-execution-fix-plan
turn: codex
---

## Objective and scope

Produce an operator-reviewable fix plan for the Work Loop v2 bounded-execution failures described in the operator's 2026-08-11 postmortem and accompanying dispatcher recommendation. The task exit condition is an accepted plan that identifies what is actually broken now, orders the smallest justified implementation units, and gives each unit a proportionate evidence budget; implementation is outside this task unless Codex later continues with a separately bounded unit.

Scope: the Work Loop v2 dispatcher and its directly coupled operating contracts: `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, its focused tests and README, `.agents/skills/work-loop-v2/SKILL.md`, `.claude/commands/work-loop-v2.md`, the executable core only where the evidence proves a semantic rule must change, and the existing Work Loop v2 plans/current-state records needed to reconcile authority. The new plan may be written only to `plans/work-loop-v2-v0.2/bounded-execution-fix-plan-v0.1.md`.

Excluded from this unit: implementing any fix; changing live command, skill, core, script, test, settings, hook, or existing plan text; running the dispatcher; launching Claude or Codex subprocesses; behavioral AI fixtures; changing permission policy; deciding whether `runs/` is committed or ignored; cleanup of existing run evidence; and resolving the separate unattended fully-detached-descendant or branch-isolation blockers unless the postmortem changes their priority with verified evidence.

The operator's objective is to fix Work Loop v2 without repeating the expensive, unbounded verification session. The operator explicitly wants Claude to develop the fix plan itself, with Codex framing and later assessing it through Work Loop v2.

## Lane and unit

Standard. Implementation mode. Unit 1 — create the evidence-backed bounded-execution fix plan.

Named reason for the loop: the work spans several coupled executable and instructional surfaces, needs scope bounding to prevent another verification spiral, and the plan must be assessed by Codex before it can authorize implementation.

Codex framing decision: this unit produces one plan rather than fixes because the supplied recommendations mix verified defects, proposed mechanisms, already-settled policy, and later observability ideas. Separating repository reconciliation from implementation is the smallest unit that can safely make those distinctions. Adjacent implementation is deliberately held back until the plan is accepted.

## Brief

This unit exists now because a live Work Loop session escaped its bounded courier path and became a costly nested-AI test farm. The immediate need is not a larger control system; it is a repository-grounded plan that restores bounded execution, honest evidence, and proportional verification before another live dispatcher run. It aligns with the Work Loop core's existing requirements that evidence scale to consequence, no perfection pass occur, and the courier carry turns without taking decisions.

Required outcome: write `plans/work-loop-v2-v0.2/bounded-execution-fix-plan-v0.1.md` as a concise, implementation-ready plan. It must:

1. Reconstruct current repository reality for every candidate below and classify each as: verified current defect; already implemented or partly implemented; policy decision requiring the operator; valid later improvement; duplicate; or rejected because it would conflict with the Work Loop contract.
2. State the smallest coherent P0 required before another attended live dispatcher run, then separate P1/P2 work that is not needed for that safety boundary.
3. Split accepted work into independently assessable implementation units. For each unit state the observable outcome, allowed surfaces, exclusions, dependencies, stop conditions, and minimum evidence that can fail.
4. Put an explicit verification budget on every unit: default to static inspection and the simulated shell harness; zero nested Claude/Codex invocations; no exhaustive scenario matrix; and no live model-backed run unless a later unit explains why cheaper evidence cannot settle a consequential claim and obtains operator approval with a maximum invocation count and wall-clock deadline.
5. Preserve the dispatcher as courier/transport. Any candidate that would let it make semantic decisions, silently change scope, or become a second state system must be rejected or escalated.
6. Identify every settled decision that a proposed fix would reopen. In particular, do not silently replace the closed attended policy that currently launches Claude with `--permission-mode default`; surface any new `acceptEdits` capability as an operator decision, with its value, risk, and narrowest reversible boundary.
7. End with one recommended first implementation unit and explain why it has the highest safety value per unit of change. Do not authorize or perform that unit.

Operator source material and candidate set:

- Full postmortem: `/Users/patrik.lindeberg/.codex/attachments/c97f82c6-0a44-424f-9a01-01a5f579020f/pasted-text.txt`. Treat its incident account as source material and its remedies as proposals to verify, not as repository facts or settled mechanisms.
- Additional dispatcher recommendation supplied by the operator: preserve the state file's full content before each hop, not only its SHA-256, so a later rewrite cannot erase a prior actor's verdict; separately decide whether the `runs/` folder is tracked or ignored because leaving evidence untracked and unmanaged risks silent loss. The plan must address both candidates, but this unit does not make the `runs/` disposition decision.
- Postmortem P0 candidates: an explicitly operator-approved attended permission mode; permission-denial parsing; correct pre-existing-dirty-state classification; honest reporting of partial allowed-path effects; nested AI actors denied by default unless explicitly budgeted; and an absolute prohibition on interactive fallback after dispatcher failure.
- Postmortem P1 candidates: a stricter correction profile; explicit nested-AI verification budgets; a proportionality preflight for briefs; and compact state files that point to evidence instead of absorbing transcripts.
- Postmortem P2 candidates: richer `--status`; a safe stop operation; and task-scoped session counts.

Governing and current-state sources, with their disposition for this unit:

- Current operator decision in this brief: governs the objective, the planning-only boundary, and the requirement that Claude develop the plan.
- `plans/work-loop-v2-mvp/work-loop-v2-mvp-proposal-v0.4.md`: governing authority within MVP scope, as declared by the executable core. Do not reopen its settled decisions without naming the conflict.
- `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`: governing executable contract for roles, proportionality, state, courier limits, correction, and stopping. Its header/approval history is internally nuanced; preserve that nuance rather than claiming blanket approval status.
- `.agents/skills/work-loop-v2/SKILL.md` and `.claude/commands/work-loop-v2.md`: deployed operating interfaces whose current text must be checked, not assumed.
- `plans/work-loop-v2-v0.2/unattended-operation-plan-v0.2.md`: current plan spine and implementation-status record for dispatcher evolution. Use it to distinguish existing blockers and settled choices from new incident findings; do not treat every proposal in it as blanket authority.
- `logs/work-loop/axcion-harness-v0-2-p0-f-attended-policy.md`: authoritative closed record for the current attended `--permission-mode default` decision.
- `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `dispatch.test.sh`, and `README.md`: live repository reality for dispatcher behavior and evidence handling.
- Existing closed Work Loop task records and run captures: supporting evidence only where directly cited by a candidate or needed to resolve a conflict. Do not scan all run history.

Check against the repository before writing the plan:

- Claim (1): the attended Claude launch is still hardcoded to `--permission-mode default`, with no operator-carried permission-mode option. Inspect the argument parser, launch construction, help text, and focused tests in the dispatcher surfaces; report the exact evidence that settles it.
- Claim (2): exit `25` still classifies a dirty state file from post-hop committedness without first proving that Claude changed that file during the hop, and its recovery text still tells the reader to commit/discard in language incompatible with Codex's role. Inspect the pre-hop snapshot, post-hop classification, and message text.
- Claim (3): run evidence records hashes and hop `.out` captures but does not preserve a byte-for-byte state snapshot before each hop. Inspect every write into the run evidence directory for the relevant patterns; bound any absence finding to those searched surfaces.
- Claim (4): the dispatcher does not parse Claude JSON `permission_denials` into a permission-specific structured stop. Inspect the output parsing and exit taxonomy, not only prose documentation.
- Claim (5): attended actors can still start nested `claude` or `codex` processes unless another existing control blocks them. Inspect the effective attended launch policy and dispatcher supervision logic; distinguish instruction, permission, and OS containment.
- Claim (6): `--status` already exists and reports some operational state, while a dispatcher `--stop` command may not. Inspect the parser, status branch, README, and tests so the plan does not propose already-built behavior.
- Claim (7): the supplied `runs/` disposition concern accurately describes this checkout today. Inspect tracked/ignored state and written policy for the exact run directory; do not generalize from a neighboring task or another checkout.

Evidence required for this planning artifact: quote the plan sections that (a) classify all supplied candidates, (b) define the P0 boundary, (c) assign bounded verification budgets, and (d) recommend the first implementation unit; provide a source-to-plan coverage table with direct paths/line references for the load-bearing classifications. For this prose planning unit, explain why automated or AI-backed behavioral execution would not meaningfully distinguish whether the plan is sound; do not invent a grep-as-success check. The plan itself and the inspection record are the failing evidence: each classification must be traceable to a current source and could have resolved differently.

Completion condition: the plan file exists, contains the reconciled priority/unit structure above, changes nothing else beyond this state file, and hands back to Codex for assessment. Stop and hand back without creating the plan if a governing conflict makes the P0 boundary an operator decision, if the source postmortem is unreadable and the prepared context above is insufficient to classify a load-bearing candidate, or if satisfying the requested plan would require changing an excluded file.

Claude may challenge any false or stale premise rather than improvise around it.

## Latest result

**Final bounded fix (2026-08-11), core § 3 menu.** The superseded correction brief that the previous
round had retained below a separator is deleted from this file. Premise checked first: the separator
stood alone at line 178 and the superseded brief ran lines 180–240, while line 159's inline mention of
the separator belongs to the surviving instruction and was preserved. The file went from 240 lines to
176. `grep -c '^--- superseded'` and `grep -c '^Correct once — frozen findings:'` both return 0 now;
both returned 1 before. Nothing else in this file changed, and no other file was touched. The five
frozen findings were not revisited, no check was run, and no dispatcher, harness or model was launched.

**Correction round (2026-08-11).** All five frozen findings reproduced by reading the plan, the core
and the SOP; all five corrected in `plans/work-loop-v2-v0.2/bounded-execution-fix-plan-v0.1.md`. No
fix implemented, no dispatcher or harness run, no live model, no nested Claude/Codex process. Files
touched: the candidate plan and this state file — nothing else.

Reproduction, before correcting:

- Finding 1 REPRODUCES — the prior plan had nine sections and no structural-resolution section; searched it for the SOP path, "Lane B", "gate", "structural": no match. The SOP exists at `.agents/skills/work-loop-v2/references/repository-problem-resolution-sop.md` (1024 lines, tracked, clean).
- Finding 2 REPRODUCES — the prior plan proposed `--allow-nested-actors N` (default 0) inside U1's observable outcome and asserted a `--allow-nested-actors 1` control in U1's evidence, with no ladder comparison anywhere. Searched the postmortem, the run evidence, the plan spine and the skill for a verified authorised nesting use case: the only nesting in evidence is the failure itself.
- Finding 3 REPRODUCES — prior § 9 line 464: "U1 makes the runaway *impossible to reach* even if someone is tempted anyway", against prior U1 line 168: "a permission-layer deny is not containment — a determined child can evade a tool-name deny from a shell." Direct contradiction, same document.
- Finding 4 REPRODUCES — the prior plan bounded verification per unit but stated no case-level closure boundary; searched it for "representative", "operational", "closure boundary", "pilot": the only live-run text was one conditional hop attached to the `acceptEdits` decision, not a closure condition for the parent case.
- Finding 5 REPRODUCES — the prior plan carried no recovery chain; searched it for the state-file path, the checkout path and "gate position": no match. The method existed only in chat.

How each finding is resolved, with the corrected text against the prior text:

1. **Structural gate sequence** — new § 0 (*Method, gate position and recovery chain*). § 0.1 subordinates the SOP: "applied here as **non-governing methodology context, subordinate to the core** … does not become a state-file field, does not create a second state system, and does not override the core's close / continue / correct once / stop", and Work Loop vocabulary is declared unchanged. § 0.2 qualifies the parent case as structural against four SOP Lane B triggers with evidence per trigger — boundary-crossing, shared courier mechanism, false-report behaviour (the `STOP [25]` misreport), and survival of a prior control (`SKILL.md:195`) — and explicitly declines to claim the other two triggers. It marks the qualification provisional and rerouteable, and states that individual fixes stay bounded. § 0.3 gives the gate table: Gate 1 qualification provisional with priority settled by the operator as Proceed now and "does **not** approve a technical design, a mechanism, or a scope"; Gates 2–5 each **NOT** complete, with the basis for each, plus "What exists today is a candidate inventory, not a diagnosis." § 0.4 tailors the eight-step route — preserved-evidence failure proof rather than live reproduction, blind review in a genuinely fresh Codex context that never receives this plan, Claude's causal model and options, operator scope approval, isolated clean checkout, independent verification, one budgeted attended pilot, closure on observed behaviour. Prior text carried none of this: § 1 opened directly on the claim table.

2. **Option ladder before the package** — new § 3 (*Intervention options — the ladder before the package*), stating "Complexity budget: zero" and opening with the outcome stated without a construction. § 3.2 works all eight rungs with a verdict each: rungs 1 and 2 (eliminate the trigger, simplify/restore the courier path) adopted as free and marked **insufficient alone** because written guidance is what already failed; rung 3 (remove the attended tool set) credible but probably too broad since Claude needs Bash for git; **rung 4 (narrow/reuse the existing `--disallowedTools` path) named the leading candidate with "no new flag, no new subsystem and no new file"**; rung 5 (isolate via the existing `--unattended` sandbox) credible but disproportionate; rung 6 not warranted; rung 7 covering the two reporting repairs; **rung 8 rejected for the nested-actor outcome**. § 3.3 drops `--allow-nested-actors N` outright — "the supplied evidence contains exactly one instance of nested AI invocation, and it is the failure" — and states the consequence plainly: no supported way to run nested AI, escalation to the operator instead. U1 was rewritten from a construction to an outcome: prior U1 read "`--allow-nested-actors N` (default 0) is the only way to lift them"; corrected U1 reads "**Construction:** **not settled here**", names rung 4 as leading and rung 3 as the alternative for the design gate, and adds a stop condition — "If the construction turns out to need a new flag after all, stop". § 4 was recast from four *units* to four *outcomes* (O1–O4) with a leading-candidate construction and ladder rung per row. U6 item 2 was reframed from "budget nested AI" to "**a brief may not propose nested Claude or Codex invocation**", because a budget for a rejected capability would be machinery for its own sake; its dependency on U1 is gone. U4 is now labelled "a supporting operating restriction, not a causal fix", in the unit and in § 3.4.

3. **Overclaim removed** — "impossible to reach" is gone from the document; the corrected § 11 says instead "What does **not** survive is the claim that it makes the runaway impossible to reach. It closes the default path by permission policy; it is not containment, a determined child can attempt to evade it from a shell". New § 3.4 separates the two claims explicitly — requested policy (provable by argv capture) versus effective containment ("**A permission-layer deny is not containment, and this plan claims no containment anywhere**", with the `--unattended` network refusal named as the only measured containment) — and states both disproving observations: for the intervention, an attended child that starts a `claude`/`codex` process while the deny rules are in its argv; for the diagnosis, preserved-log evidence that the cost came from one long session rather than nested invocations. U1 now carries a "What this evidence proves / What it does not prove" pair, and § 5's budget adds "Harness evidence is controller evidence."

4. **Closure boundary** — new § 6. § 6.1 tabulates what each evidence level closes and marks one genuine representative attended use as the only thing that closes the parent case. § 6.2 bounds the pilot in advance: one task, at most one Claude actor invocation, ten minutes wall-clock, no nested AI, no matrix, observed signals named before it runs, and — "If one genuine use cannot exercise a consequential claim, that claim is recorded as a limitation … Manufacturing sessions to close a claim is precisely the incident this plan exists to prevent". § 6.3 permits the intermediate and *not confirmed* states. § 6.4 states that this planning task closes on an accepted plan and that implementation opens as a **new** Work Loop task in an isolated branch/worktree at an agreed clean base, "**Never by copying this task's state file**", with the reason — a copied file carries a stale `task:` and is rejected by core § 6 rule 2. The prior plan's only live-run text was the conditional `acceptEdits` hop; that now points at the § 6.2 pilot rather than carrying a separate budget.

5. **Compaction-safe method** — § 0.5 is the durable recovery chain as a table: bound checkout, active state file, candidate plan, governing core, both operating interfaces, the SOP path, the incident evidence location with its two commits, the workflow phase ("Route step 1 of 8 not yet started; Gates 2–5 open"), and the current move. It opens by saying it lives in the plan, not only in chat, and states that **no** context manifest file, case database, second task-state artifact or other new file was created to hold it. § 7 repeats the point where it bites: "The SOP's own context manifest is deliberately **not** created as a file — its content lives in § 0.5." No file was created: the only write besides this state file was to the existing candidate plan.

Evidence: the corrected plan quoted above against the prior text, which Git holds at `95d10c1`. The
correction is checkable by `git diff 95d10c1 -- plans/work-loop-v2-v0.2/bounded-execution-fix-plan-v0.1.md`,
and it could have failed: findings 2 and 3 required removing a mechanism and a claim the prior version
had recommended, not adding to them. Net effect on proposed permanent machinery: one new mechanism
(`--allow-nested-actors N`) removed, none added — the plan now proposes zero new mechanisms.

Two things surfaced rather than resolved silently. First, a conflict: workspace CLAUDE.md says to
create a new version file when iterating rather than overwriting, while the brief permits writing only
`bounded-execution-fix-plan-v0.1.md` and the frozen correction boundary says to edit only the candidate
plan and this state file. The frozen boundary and the brief's named path were followed; the prior text
is preserved at `95d10c1`. Second, a resolved tension rather than a conflict: SOP Step B1 calls for a
context manifest, and frozen finding 5 forbids creating one — resolved by putting the manifest's
content in plan § 0.5, which finding 5 explicitly directs.

Inspected (2026-08-11), Unit 1. Paths relative to the `ai-resources` checkout; `dispatch.sh` =
`plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`.

- Claim (1): HOLDS — read the parser `dispatch.sh:282-303` (15 options, no permission-mode flag, unknown args exit 10 at `:302`) and both attended launch shapes `:1687-1694`, which pass the literal `--permission-mode default`; searched `dispatch.sh` for `permission-mode|permission_mode|acceptEdits|bypassPermissions|dangerously-skip` — every hit is that hardcoded pair, its comment block, or a run-log line. Help text is the leading comment block (`:301`) and names no such option. Tests pin the pair at `dispatch.test.sh:1945,1974,2324`; `README.md:316` states it "is not an option, and cannot be turned off".
- Claim (2a): HOLDS — the post-hop classification at `dispatch.sh:2007` tests `[ "$before_turn" = "claude" ] && state_dirty` only. `state_dirty()` (`:1416-1418`) is a bare `git status --porcelain` on the state file. `before_dirty` is computed at `:1917` but is consumed only by the crash-retry guard at `:1946`; the hash comparison that would settle authorship (`:2014`) runs *after* the `die 25`.
- Claim (2b): DOES NOT HOLD AS STATED — read both exit-25 message strings. `:1793` says "the expected Codex handoff (Codex never runs git)" and `:1795` says "Claude commits, so a previous run died between editing and committing"; both name the right owner, and "commit it and re-run" addresses the human reader, who may commit. The narrower defect that survives: neither message names its addressee, so a Codex reader can take it as an instruction to itself. Carried into Unit U2 as a one-clause wording fix, not dropped.
- Claim (3): HOLDS — enumerated every write into the run-evidence directory by searching `dispatch.sh` for `LOG_DIR`, `cp`, and all `>`/`>>` redirections: `$RUN_ID.log` (`:1123-1124`), `$RUN_ID.unattended-settings.json` (`:1294`), `$RUN_ID.hop<n>.<actor>.out` (`:1596-1597`), `$RUN_ID.hop<n>.<actor>.tree` (`:1502-1503`). No copy of the state file exists on any path. Identity is carried as sha256 only — `file_hash()` `:419`, used at `:1786, :1894, :1978`. Absence bounded to those searched surfaces.
- Claim (4): HOLDS — searched `dispatch.sh` for `permission_denials|jq|is_error|subtype|"result"`: no match. The hop capture is written (`:1596-1597`, `:1507`) and never parsed. Read the exit taxonomy comment `:121-166` (codes 0, 10–32): no permission-specific code. `permission_denials` occurs once across the whole spike, as README prose at `README.md:837`.
- Claim (5): HOLDS — searched the attended launch path for `Bash(claude|Bash(codex|'Task'|nested`: no match. `--claude-deny` defaults empty and the run log says `claude_deny=none` (`:1152`); the dispatcher states the posture itself at `:1325` — "unattended=off — Claude hops are NOT contained: open network, open filesystem, full tool set". Read `actor_tree_census` (`:643-670`) and teardown (`:848-855`): they terminate a tree on a stop, they do not prevent one being created. `UNATTENDED_BASE_DENY` (`:236-242`) carries no `claude`/`codex` rule either, and `--tools Bash,Skill` still exposes Bash — so nesting is blocked under `--unattended` only incidentally, by the sandbox's network refusal.
- Claim (6): HOLDS — `--status` is parsed at `:296` and implemented at `:1020-1092`: three lock states, `turn`/`task`/sha256/uncommitted, HEAD and branch, last run log with its last hop and last stop line, and `kill -TERM <pid>` at `:1038`. It reports no elapsed runtime, no actor pid, no descendant count, no deadline remaining, no output growth. Searched `dispatch.sh`, `dispatch.test.sh` and `README.md` for `--stop`: no match.
- Claim (7): FALSE for this checkout — `git ls-files` on `plans/work-loop-v2-v0.2/handoff-automation-spike/runs` returns 48 files, `find -type f` returns 48, `git status --porcelain --ignored` on that path returns 0 lines, `git check-ignore -v` on the directory exits non-zero, and `.gitignore` carries no matching pattern. The concern is real one worktree over: `../ai-resources-diagnostics-workflow` has three untracked run files from the 2026-08-10 run (`20260810T151601-…diagnostics-workflow.{log,hop1.claude.out,hop1.claude.tree}`). Re-scoped in the plan from "runs/ is untracked" to a per-checkout evidence-lifecycle gap that surfaces in linked worktrees. Not handed back: the brief already withholds the `runs/` disposition decision from this unit, and "classify each candidate" is exactly what a false candidate feeds.

Two supplied source facts were also found stale and are corrected in the plan: the postmortem's
*Current repository state* says no correction commit or closing record was created and that two
command files hold uncommitted correction edits, but `../ai-resources-diagnostics-workflow` carries
the correction as `9a8399c` on top of `ea77d66`, with no dirty `.claude/commands/` path.

Current shape of the plan, after correction: § 0 method, gate position and recovery chain; § 1 the
inspection above; § 2 all 15 supplied candidates classified into the six required categories, with
"a classification is not an authorization" stated; § 3 the option ladder at a zero complexity budget,
with the requested-policy / effective-containment split and both disproving observations; § 4 the P0
boundary as four **outcomes** (O1–O4) rather than four constructions, with O1+O4 as the irreducible
pair; § 5 ten independently assessable units under one verification budget (static inspection plus the
existing simulated harness, zero nested Claude/Codex invocations, no scenario matrix); § 6 the parent
case's closure boundary and the budgeted pilot; § 7 the courier limits, rejecting the two candidates
that would make the dispatcher decide; § 8 six settled decisions a fix would reopen, with attended
`acceptEdits` framed as an operator decision; § 9 why execution cannot test the plan; § 10 the
source-to-plan coverage table; § 11 the recommended first move.

For this prose planning unit, no automated or AI-backed behavioural execution would distinguish a
sound plan from an unsound one: the failure modes are misclassification and starting too low on the
option ladder — the second of which this correction caught — and both are settled by reading the
repository and the governing documents, which §§ 1–3 do and cite. Running the dispatcher would
exercise the current code without saying anything about the ladder, the decision boundary or the
duplicate finding; an AI-backed check would consume the exact resource this plan exists to bound while
grepping for words the plan itself supplied.

## Blocker

None.

## Next action

Claude: perform the one final tightly bounded fix permitted by executable core § 3 after the
correction introduced a state-management defect. In this state file only, delete the separator
`--- superseded, retained for the closure check only ---` and the entire superseded correction brief
below it. Preserve the current result, blocker, this instruction, and both candidate deferrals above
that separator. Change no other file and do not revisit the five frozen findings, run checks, launch
the dispatcher, or start another review/correction round. Then set `turn: codex` and hand back for a
closure check limited to whether the superseded block is gone and whether this cleanup broke
anything.

Candidate deferrals, recorded and not implemented — none of these is a second correction round:

1. The SOP names three sibling documents as related — an Independent Review SOP, a Codex–Claude
   Session Operating SOP and an AI Development Lifecycle SOP (`repository-problem-resolution-sop.md:37`).
   Searched this checkout for each by filename pattern: none exists. The SOP also carries its own open
   flag at `:59` saying its consolidated gate/verdict vocabulary "is a decision, not a finding —
   confirm it before adopting". Out of this correction's boundary; worth an operator decision before
   the SOP is leaned on further.
2. `unattended-operation-plan-v0.2.md`'s implementation-status table is dated 2026-08-07 and states
   the suite at 368/0, while the P0-F closed record of 2026-08-09 states 375/0. Carried over from the
   previous round, still unimplemented.

Done. Codex: run the closure check on this fix only — is the superseded block gone, and did the
cleanup break anything?
