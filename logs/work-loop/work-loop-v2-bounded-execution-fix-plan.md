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

Inspected (2026-08-11). Paths relative to the `ai-resources` checkout; `dispatch.sh` =
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

Result: `plans/work-loop-v2-v0.2/bounded-execution-fix-plan-v0.1.md` written — the only file this
unit created or changed besides this state file. It classifies all 15 supplied candidates (2 operator
dispatcher recommendations, 6 postmortem P0, 4 P1, 3 P2) into the six required categories; sets a
four-unit P0 boundary (U1 nested-actor default deny, U2 honest post-hop classification, U3
permission-denial stop, U4 no interactive fallback) with U1+U4 named as the irreducible subset; splits
accepted work into ten independently assessable units, each with observable outcome, allowed surfaces,
exclusions, dependencies, stop conditions and fail-capable minimum evidence; puts one verification
budget over all of them (static inspection plus the existing simulated harness, zero nested
Claude/Codex invocations, no scenario matrix, no live model-backed run without a separately approved
invocation cap and wall-clock deadline); tests every candidate against core § 4's courier limits and
rejects the two that would make the dispatcher decide; names six settled decisions a fix would reopen;
frames attended `acceptEdits` as an operator decision with value, risk and narrowest reversible
boundary rather than adopting it; and ends recommending U1 as the first implementation unit without
authorizing it.

Evidence: three classifications resolved *against* their supplied framing, which is what makes the
inspection fail-capable rather than confirmatory — claim 2b was not confirmed and its candidate was
narrowed instead of adopted; claim 7 came out false for this checkout and its candidate was re-scoped;
and the postmortem's own current-state section was found stale against `git log` in the incident
worktree. Two supplied P1/P2 candidates were rejected or parked as duplicates of text that already
exists (the proportionality preflight duplicates core § 3 *good enough, proceed* and is forbidden in
shape by core § 3 step 3's "no new field, artifact or stage"; "keep the task state compact" is already
core § 4, including its worked *Not this* example). Two more were found already partly implemented
(`SKILL.md:195` already prohibits screen-driving Claude; `--status` already exists and `--stop`'s
teardown already exists behind SIGTERM). A plan that had adopted every input would have been evidence
of nothing. The plan's § 8 coverage table carries a path-and-line reference for every load-bearing
classification.

For this prose planning unit, no automated or AI-backed behavioural execution would distinguish a
sound plan from an unsound one: the failure modes are misclassification — calling a built thing a
defect, a policy decision a fix, or missing a settled decision a unit would reopen — and each is
settled by reading the repository, which § 1 and § 2 do and cite. Running the dispatcher would
exercise the current code without saying anything about the ordering, the decision boundary, or the
duplicate finding; an AI-backed check would consume the exact resource this plan exists to bound while
grepping for words the plan itself supplied.

## Blocker

None.

## Next action

Codex: assess the plan at `plans/work-loop-v2-v0.2/bounded-execution-fix-plan-v0.1.md`.

Four things need your judgment specifically. (1) Claim (7) resolved FALSE for this checkout and claim
(2b) was not confirmed; both were re-scoped inside the plan rather than handed back, on the reading
that the brief's own task is to classify candidates and it explicitly withholds the `runs/` decision
from this unit — overrule that reading if you disagree, and the hand-back is the correct move instead.
(2) The P0 boundary is four units where the postmortem proposed six; attended permission mode was
moved out of P0 into an operator decision, and interactive-fallback was found already written at
`SKILL.md:195` and re-scoped to placement. (3) Two P1 candidates were rejected as duplicates of the
executable core — confirm that reading of core § 3 and § 4 before it becomes settled. (4) The
recommended first unit is U1; it is not authorized and was not performed.

Deferrals recorded, not implemented: the stale `unattended-operation-plan-v0.2.md` status table (dated
2026-08-07, says the suite is 368/0; the P0-F record of 2026-08-09 says 375/0) — noticed while reading
the plan spine, out of this unit's scope, and worth one line in a later unit. The three untracked run
files in `../ai-resources-diagnostics-workflow` were left untouched: that checkout is outside this
unit's scope and its disposition is U7's question.
