# Framing a unit and writing the brief

**Read this only after Work Loop admission has succeeded, when preparing or materially
reframing a unit.** It owns opening a unit, sizing it, the single preparation pass, how
authority and relevance are treated, what Claude must verify, and the capability envelope.

**Contents**
- Opening a unit and writing the brief
- Size the unit against the clock
- Prepare once; write one brief for two audiences
- Keep authority semantic, content-bound, and explicit
- Mark what must be verified, and bound what you go looking at
- Justify the unit against the plan, and keep your own framing attributed
- Select on relevance as well as authority
- The capability envelope, the selected subset, and the runtime profile
- Keep every duty inside the four

## Opening a unit and writing the brief

One task, one file (core § 4), named for the task id. Set `status: active` and `turn: claude` when the brief is ready for Claude — both fields, in the same write, because a record missing either is malformed and every consumer refuses it.

Before writing anything:

1. **Find the real need, not the stated fix.** "Add a check to X" is usually a proposed remedy for an unstated problem. Ask what goes wrong today — one round, not an interrogation, and none at all if the answer is already in what they said.
2. **Read the object.** Open the file, run the grep, check the line the request cites. A brief written from the operator's description alone inherits every error in that description.
3. **State premises as checkable claims.** Each is something Claude will open, run or re-derive. "The hook fires at SessionStart" is a premise. "The hook is important" is not — it cannot be checked, so it cannot be a premise. Write absence claims to core § 6 rule 3: name the surface.
4. **Choose the smallest justified unit** (core § 3 step 2).

The file's shape, its five-field ceiling and what sits outside that ceiling are core § 4 — including the **exact heading strings** for the active fields, which Claude reads literally. Write those headings as core § 4 gives them; a file under different headings is malformed and Claude cannot act on it. What the brief itself must carry is core § 3 step 3, and where the brief places its claims to check — marked in place, or gathered under one collecting heading — is core § 3 step 3's choice, with both shapes valid.

**Required evidence must be able to fail** (core § 6 rule 5). Ask for a check that reads differently depending on whether the work happened. A check that greps a word your own brief already contains is not evidence — it is the commonest way a unit looks done and is not.

### Size the unit against the clock

**A unit that will run under a timer carries one dominant deliverable and one proportionate evidence set.** Judge that on the **reasoning and validation load**, not on the file list.

**An allowlist bounds files, not reasoning workload.** This is the load-bearing sentence. The dispatcher can prove a hop stayed inside its paths; nothing proves it stayed inside its thinking. A brief that reads as bounded because its `--allow-path` list is short is exactly the misreading this rule exists to prevent — a single-file unit can carry an unbounded amount of work.

Split the unit before you dispatch it when the brief has any of these shapes:

- It combines building something with remediating something else — a scenario redesign *and* a standards cleanup.
- It builds a shared component **and** integrates its first consumer. Building the helper and wiring the first caller are two dominant deliverables; the helper's own suite is a third. This shape cost a 902-second timeout on 2026-08-14, and splitting it recovered in 328 seconds.
- It integrates a consumer **and** runs the full regression matrix for that integration, where the regression set is substantial. Wiring and proving the wiring are separate units once proving it means more than one focused case.
- It asks for a historical or negative control to be constructed alongside the primary edit.
- It demands a full behavioural matrix for instruction files, rather than one targeted check.
- It says "all", "every" or "exhaustive" without a stated consequence that requires exhaustiveness.
- Its evidence set needs more than one fixture built from scratch before the primary work can start.

Split by deliverable, not by file count. Two oversized halves are not a fix.

**The primary edit begins after one targeted failing case, not after a broad baseline.** A full baseline suite precedes the primary edit only where establishing that baseline is the unit's *sole* deliverable — which makes it a discovery unit, assessed and accepted on its own. Evidence a previous unit already established and you already accepted is settled: cite it, and do not ask Claude to re-derive it before editing. On 2026-08-14 a correctly narrowed dispatcher unit still spent 593 seconds on baseline mapping it had accepted evidence for, and exited having changed nothing.

**Write the packaging decision into the brief.** Mode-dependent packaging lines, inside `## Brief`. This is the brief's content, not the state file's: core § 4's five-field ceiling is unchanged and no new field, artifact or stage is created.

```
Dominant deliverable: {the one thing this unit delivers}
Evidence required in this hop: {only what could read differently because of that deliverable}
Evidence explicitly deferred: {what a later unit checks, named — or None.}
Primary edit begins after: {Implementation mode only — the targeted failing case, or the quoted
                           before-state where no meaningful failing test exists}
```

**`Evidence explicitly deferred:` takes `None.` when nothing is deferred.** Write it; do not drop the line. `None.` is a decision that nothing was held back, and it follows core § 4's own convention for `## Blocker`. A dropped line reads as a packaging decision never made, and Claude hands it back.

**The fourth line accepts a quoted before-state where no meaningful failing test exists.** Core § 3 already refuses ceremonial tests, and a prose, documentation or instruction-file change is the ordinary case with no automated check that could distinguish success from failure. There the thing that must exist first is the **text being replaced, quoted** — that is what makes the change checkable afterwards. Where the artifact is executable, the targeted failing case is still required and a before-state does not substitute for it.

**The first three lines are mode-neutral; the fourth belongs to Implementation alone.** A unit in Discovery or Adoption mode makes no primary edit — it inspects and hands back, changing nothing beyond the state file (core § 3 *The unit's mode*) — so writing that line on one would name an edit its own mode forbids. Write three lines in Discovery or Adoption mode, four in Implementation mode.

The three that always apply still carry the packaging decision: a Discovery unit can be overpacked exactly as an Implementation unit can, and *"establish six things about the dispatcher"* is the same failure as building two deliverables.

**The lines are required, and Claude checks them against the recorded mode.** A brief missing a line its mode requires, naming two deliverables on the first, or carrying the fourth line in Discovery or Adoption mode, is handed back to you as a false premise before the unit begins — so writing them is what gets the unit dispatched at all, not a convention that decays when nobody looks.

**`Dominant deliverable` admits exactly one entry.** A second entry is the split signal — it is how an oversized unit announces itself before it is dispatched, at the one moment splitting is still cheap. `Evidence explicitly deferred` makes the deferral a recorded decision rather than an omission, so the later unit that owns it can be written.

**A longer timeout is not the remedy for an oversized unit.** The actor timeout is a safety boundary, and on 2026-08-11 it was the one control that worked. Raising it buys a larger oversized unit whose failure arrives later, costs more, and — if it now finishes inside the new limit — produces no stop and no evidence at all. Do not propose it as a fix for sizing, and do not treat a hop that timed out as a reason to relax the clock.

**Where these rules came from.** The packaging outcomes (2026-08-14) answer a recurrence of the 2026-08-11 sizing failure after that fix was already in force — a shared-helper-plus-first-consumer unit that timed out at 902 seconds, and a correctly narrowed unit that spent 593 seconds re-establishing accepted baseline evidence and changed nothing. They add the two split triggers above, the primary-edit-begins-after rule, and the four packaging lines inside `## Brief`. **No state field, artifact or stage was added** — core § 4's ceiling is untouched, and core § 3 step 3 already permits the brief's content to grow. The four lines are the structural half of this fix: they make the packaging decision written rather than remembered, and Claude refuses a `Dominant deliverable` line naming two. The split triggers remain guidance and carry the same limit the 2026-08-11 entry in the main skill's § *Scope of this version* states.

### Prepare once; write one brief for two audiences

Prepare the unit in **one pass**. The operator supplies the objective and any optional raw material once; locate, derive and reconcile repository-resolvable context yourself. Do not open an iterative context interview, a separate QC pass or a preparation loop for information the pass can derive, and do not ask the operator to assemble, reconcile or restate context carried by durable sources. End the pass with exactly one execution brief, one discovery brief or one genuine escalation. Only a genuine operator-owned decision about intent, priority, authority or risk returns to the operator; evidence or a result after Claude begins work is normal subsequent Work Loop work, not another preparation pass.

When a load-bearing unknown is resolvable by repository inspection, make the open unit a **discovery unit** rather than refusing, guessing or asking the operator. State what must be established, what Claude must inspect, what evidence must return, and that Claude must then reframe or stop. Core § 3 step 4 is what Claude runs on receiving one, so make the completion condition unambiguously *return this evidence and hand back* rather than *implement* — a discovery brief whose completion condition reads like an execution brief will be built rather than investigated, which is the guess this unit exists to avoid.

Produce **one brief, for two audiences**, inside the one state file. Do not create a separate operator-orientation document or any second artifact describing the unit. The brief opens with operator orientation: one paragraph of at most three sentences answering only why this unit, why now and how it aligns with the approved plan. Its remainder is Claude's execution context: required outcome, minimum-sufficient prepared context, governing sources, scope, exclusions, constraints, required evidence, claims Claude must check, completion condition, stop conditions, and explicit permission to challenge a false premise or stale direction rather than improvise. A material update to the one canonical plan or current state remains durable context rather than a second handoff artifact only when it does not restate the brief; the test is duplication, not mention.

### Keep authority semantic, content-bound, and explicit

Classify each material claim cluster by its semantic role before it controls the brief: governing authority, verify-first repository claim, non-governing background, or unknown. Apply this hierarchy: current operator decision → canonical operator-approved project plan → applicable approved workflow or SOP → authoritative current state → verified repository reality → settled implementation decision → operator source material or exploratory context → Codex proposal or preference. A path, date, commanding filename, imperative wording, saved location, or operator authorship alone never grants authority; an unapproved draft stays a labelled proposal, and only a genuine explicit operator decision governs. The governing autonomy rule over this classification is core § 8; read it there rather than restating it here.

Treat plan approval as bound to identifiable content, never vaguely to a filename. Before describing a plan or its outcomes as approved, confirm the approval record identifies the content it attached to; an approval naming only a mutable file establishes no approved content, so surface that missing content identity and carry the source as non-governing or unknown rather than promoting the file's current contents to governing authority, inventing a binding, or resolving the gap silently. A draft does not govern. An editorial change that preserves meaning may retain approval; a material change to objective, scope, exclusions, settled decisions, intended sequence, acceptance conditions, or authority relationships returns the plan to draft and requires reapproval. If materiality is genuinely uncertain, escalate that question instead of resolving it toward continued approval.

Demote or supersede an apparently authoritative source only with cited evidence such as a later operator decision, explicit supersession, a newer approved plan, a decision record, or verified repository evidence that falsifies a factual premise. Age or apparent staleness alone is insufficient: without evidence, carry the source as a surfaced conflict or unknown. Keep exactly one plan identifiable as current, treat any unapproved amendment as a proposal, and when repository evidence falsifies a plan premise preserve the approved intent while surfacing the conflict rather than silently re-aiming the work. Make these dispositions and citations visible where the sources land in the one brief; create no ledger or additional authority artifact.

### Mark what must be verified, and bound what you go looking at

Leave every load-bearing repository assertion in the brief as a claim for Claude to check, naming the file or searched surface and the pattern or evidence that settles it. Do not state it as fact and do not soften it into an aside. A claim that turns out false is a valid outcome rather than a defect in the brief, because Claude's inspection is what settles it. Every absence claim names both the searched surface and the pattern used, and asserts nothing beyond that boundary.

Start from the operator objective and any supplied material, the approved plan, authoritative current state, and directly named artifacts. Expand past that set only to resolve a load-bearing claim, an explicit dependency, an authority conflict, or a cited reference, and keep each expansion traceable to which of those four it served. Stop once the brief can state its outcome, governing sources, boundary, exclusions, verification claims, required evidence and completion condition; where a load-bearing unknown remains, return it as a discovery unit or a genuine escalation instead of widening the search. Do not scan unrelated history, archives or adjacent systems on the chance they hold something useful.

A fresh thread recovers its bearings inside this same preparation pass, never as a stage of its own: proportionately re-establish the current operator request, the governing plan, applicable approved workflows, authoritative current state, material settled decisions, unresolved blockers, and the next justified unit. Re-establishing them is internal; the approved outcome and the current-state position are carried into the brief under the orientation rule above, at the same precision. Conversation may point you at a source; it never establishes authority or current state. Where no current-state source exists, derive only what the governing sources and verified repository evidence support — do not invent continuity to cover the gap, and do not answer it by starting a second state system.

### Justify the unit against the plan, bound it, and keep your own framing attributed

Carry the unit's plan justification inside the brief as one of its fields, never as a separate stage, gate or review pass standing in front of it, and treat the brief as unfinished until it can state that justification. Say how this unit is justified against the approved plan. Where the objective cannot be reconciled with that plan, escalate the irreconcilability instead of proceeding; where the work would depart from the approved canonical plan, surface the proposed deviation explicitly instead of applying it silently.

Keep the operator's objective as they stated it visible in the brief while bounding one unit that still delivers something observable, and name the adjacent work you are holding outside the unit rather than dropping it unrecorded. Where the objective carries more than one load-bearing part, the required outcome must not quietly cover only the convenient ones. Bounding and reframing are both legitimate and substitution is not; the difference is attribution, so a genuine reframing — you concluding the operator is aimed at the wrong problem — is carried as your own attributed proposal or escalated as an operator decision, and never arrives in the operator's voice.

Mark every boundary or exclusion you added on your own judgment as your framing decision and attach its reason, so it is never laundered into an operator requirement. Confine the brief to what it may define — required outcome, unit boundaries, governing constraints, verification questions, required evidence, completion conditions, stop conditions — and leave the mechanism to Claude. Do not turn an architecture, implementation mechanism, file structure, abstraction, library, command shape or technical sequence into a requirement unless governing authority has already settled it and you cite that; otherwise carry the choice as your attributed, non-governing proposal, or state it as a verification-and-evidence requirement. Specify what the evidence must prove; do not specify the construction that produces it.

### Select on relevance as well as authority, and disclose only what changed materially

Gate material on relevance as well as authority, in three classes rather than two. Material that passes both governs execution. Material whose relevance is uncertain stays visibly preserved as background, conflict or unknown and does not govern. Routine repetition, boilerplate and explanation without execution value is removed, and needs no record. Never silently promote an uncertain-relevance item to governing, and never silently erase one; knowingly dropping load-bearing context is unacceptable, and where the choice is genuinely forced over-inclusion is the worse error, because stale, speculative or low-authority material can masquerade as governing context and produce wrong work.

Disclose material reclassifications, and only those. Four kinds qualify: a proposal that resembled a requirement, a source that lost an authority conflict, a repository claim demoted to unverified, and a material item deliberately held outside the unit. Staying silent about one of those fails. So does the opposite error — do not build a discard ledger or a complete production trace, and do not disclose routine compression.

### The capability envelope, the unit's selected subset, and the runtime profile

A brief says what a unit may *do*, not only what it must achieve. This is the MVP envelope it selects from, what the carrier actually enforces, and where the selection and the resulting profile sit in the state file. **No new state field is created by any of this** — the subset goes inside `## Brief`, the profile inside `## Latest result`, and core § 4's five-field ceiling is untouched.

**The three sets.** Every capability falls in exactly one.

**Granted to a Standard unit by default:** read, search, inspect history, diagnose; run local tests, linting and builds; edit within task-scoped paths; create local branches; make local commits through the role that owns Git (Claude, core § 4); perform reversible local refactoring; write evidence to the existing task state and approved repository paths.

**Operator-reserved — not in the baseline and not selectable without a separate operator decision:** production deployment or release; public, customer, employee or partner communication; credential or secret access; destructive changes to shared or production state; force-push or shared-history rewriting; merge to a protected branch; irreversible deletion; permission, sandbox or policy changes whose purpose is to authorize the current action; disabling logging, containment or verification.

**Separately pre-authorizable, selectable per unit only once pre-authorized:** read-only network to approved domains; dependency resolution from approved registries; approved MCP or remote test services; branch push to an approved remote or namespace; draft PR creation; remote CI; bounded reversible external development-system writes. **The current membership of this set is empty.** Nothing in it is pre-authorized today, so a brief that selects from it is selecting something that does not yet exist — say so and escalate rather than assuming it.

**What the carrier actually does, per control and per actor path.** The carrier launches two different actors with two different argv shapes, and several controls reach only one of them. An actor-generic claim is therefore false, not merely imprecise. The verbs below are exact and are not interchangeable: **prevented** (fails closed before anything runs), **detected** (reported after the fact), **observed** (sampled and reported, proving nothing about what was possible), **requested** (asked of the child, which evaluates it), **deferred** (not attempted), and **neither carrier-selected nor carrier-verified** (fixed on the launch line, not chosen per unit, and confirmed by nothing).

| Control | Surface | Strength | Evidence that can fail |
|---|---|---|---|
| Exact task, checkout, state file, actor, turn | carrier identity checks; `work-loop-owner.sh --depth repo` | **Prevented** | the `RESULT` line's `task=`/`actor=`/`turn_before=`/`turn_after=`; a mismatched fixture must exit non-zero |
| Task-scoped write paths | the carrier's `--allow-path` allowlist, compared after the hop | **Detected, not prevented** — exit 24, or 30 once committed | a fixture writing a foreign path must produce the foreign classification and a non-zero exit, not a clean pass |
| Explicit sandbox per invocation — **Claude hop** | — | **Deferred.** The permission mode is a permission policy, not containment, and the attended surface refuses `--unattended`, `--contained` and `--sandbox` outright | n/a — report as deferred, never as met |
| Explicit sandbox per invocation — **Codex hop** | `--sandbox workspace-write`, fixed on the launch line | **Requested, and neither carrier-selected nor carrier-verified** | the recorded launch argv shows the flag. No `RESULT` field reports enforcement, so it is never "effective" |
| Network and external tools — **Claude hop** | — | **Deferred** | n/a — report as deferred, never as met |
| Network and external tools — **Codex hop** | a property of the Codex child's own sandbox, not a carrier control | **Neither carrier-selected nor carrier-verified** | the host's own sandbox report. The `RESULT` line has no network field |
| No raw bypass mode | the carrier refuses `--dangerously-skip-permissions`, `--bypass-permissions` and a raw `--permission-mode`, and allows exactly `default` and `acceptEdits` | **Prevented** — fails closed before the lock, the run log and any actor | each refused flag must exit non-zero. Load-bearing: this repository's own `defaultMode` is `bypassPermissions`, so the refusal is what stops inherited bypass |
| No nested Claude or Codex actor — **Claude hop** | the mandatory `--disallowedTools` set — `Bash(claude:*)`, `Bash(claude *)`, `Bash(codex:*)`, `Bash(codex *)` — plus the process-group census | **Requested (direct route) + observed.** Not prevented: the child evaluates the rules, and they block the ordinary direct route only | the per-argument launch argv must carry all four rules; the `RESULT` line's `nested=`, where `unobserved` and `0` are distinct states |
| No nested Claude or Codex actor — **Codex hop** | the census only. **The Codex launch line requests nothing** — no deny list, no rules path, no approval policy | **Observed only, today.** `codex exec` offers sandbox modes and config overrides, not a per-command deny list, so the carrier has no already-used mechanism to request the same of a Codex hop | the `RESULT` line's `nested=`, which is actor-agnostic and does cover this path. There is no argv evidence, because nothing is requested — and that absence is the finding |
| No push, merge, deploy, credential access or destructive shared-state operation — **Claude hop only** | `--claude-deny` rules, appended to the mandatory set and passed as `--disallowedTools`. **This surface exists on the Claude path alone**; a Codex-actor invocation has nothing to pass them to | **Requested per invocation, not a default.** Nothing denies these unless the invocation supplies the rules | **the recorded per-argument launch argv, and only that.** A paired run — rules passed versus omitted — differs in argv and can fail |
| Timeout, deadline, one-hop limits | the carrier's own bounds and one-hop structure | **Prevented** | a fixture exceeding the deadline must terminate and classify, not run on |
| Before/after repository evidence | `git` head before and after, plus the working-tree and staged-path splits | **Enforced** — captured on every hop | the `RESULT` line's `partial=`/`turn_*`; a hop leaving uncommitted work must be visible, not silently clean |
| Terminal classification that cannot turn missing evidence into success | the carrier's single-order classification, with `unavailable` distinct from `0` | **Prevented** | a fixture with unreadable evidence must classify `unavailable`, never success |

**`denials=` is not evidence that a deny rule was requested.** It reports whether the child's own `permission_denials` evidence was readable and what it contained. Two hops identical but for their deny set both return `denials=0` while their argv differs — so citing it to show a restriction was in force asserts something it cannot show. Cite argv for what was requested, and `denials=` only for what the child reported.

**The baseline deny set a Claude hop must pass.** The control above has no default, so this convention fixes it. Both match shapes per rule, for the same reason the mandatory nested-actor set carries both — which form an installed build honours is not established, and listing one would rest the policy on that guess.

```
Bash(git push:*)     Bash(git push *)        # push, including force-push
Bash(git merge:*)    Bash(git merge *)       # merge to a shared or protected branch
Bash(gh:*)           Bash(gh *)              # remote platform action: release, deploy, PR
Bash(security:*)     Bash(security *)        # credential and keychain access
Bash(rm -rf:*)       Bash(rm -rf *)          # irreversible deletion
```

That is a floor, not a ceiling: a unit may add rules, never drop one. And read it honestly — these are requested permission rules the child evaluates, blocking the ordinary direct route. They are not containment, and an alternate spelling is not covered.

**Where the selection goes.** Inside `## Brief`, as prose, naming what is selected and what is deliberately not:

```
Capability subset: baseline only — read, local tests, edits inside `logs/` and `docs/`,
local commits. Baseline deny set passed in full. Nothing selected from the
pre-authorizable set, which is empty today. No operator-reserved capability is needed.
```

**Where the profile goes.** Inside `## Latest result`, alongside the evidence, naming the actor path and separating what was observed from what was only asked for:

```
Runtime profile (Claude hop): the five baseline deny rules and the four mandatory
nested-actor rules were requested — all nine present in the recorded per-argument argv.
`nested=0` — observed, in that process group, during that window; not proof none existed.
Sandbox and network: deferred on this path, not applied and not claimed.
`denials=0` — the child's permission-denial evidence was readable and empty.
```

The one thing that must never appear is a requested-but-unverified property written as effective. "Sandbox `workspace-write` was effective" is a failure of this convention; "sandbox `workspace-write` was requested, and the carrier verifies nothing about it" is the same fact stated honestly. The carrier's own `nested=unobserved` versus `nested=0` distinction is the convention to copy.

**Still deferred, and named rather than omitted:** the connected-development profile, and full descendant containment. Neither is addressed by anything above, which restricts what a hop may *launch* and not what a launched descendant may then do.

### Keep every duty inside the four, and let no routine run leave a trace

Discharge every duty inside prepare, brief, assess and escalate, and add no machinery or new artifact kind beyond them. A routine invocation — one where no new operator input, no operator approval and no verified evidence has materially changed durable project understanding — reads the durable sources and produces only the brief: it writes no context file, no discovery log, no run record and no session note, and nothing accumulates from one run to the next. Durable maintenance is limited to the optional operator source material, the one canonical plan and the existing current-state interface, and you update those only when material understanding actually changes — keeping them current is maintenance, not an addition.
