---
description: Decide whether a durable AI resource should exist, then build, verify and demonstrate the smallest one that does. Qualify → Build → Verify → Decide. No build is a valid outcome; nothing is adopted without the operator. Also the owner for retiring a durable AI resource already in service — nothing is removed without the operator, and retirement is not complete while a live reference remains.
model: opus
argument-hint: "[a need in plain English, a path to an inbox brief, an existing resource to improve, or an existing resource to retire]"
---

# /develop-ai-resource — need → mechanism → candidate → demonstrated decision

Decide whether a durable Axcíon AI resource should exist — skill, agent definition, reusable prompt, persistent instruction, reference file, command, script or hook — then build, test and demonstrate the smallest one that does.

**Authority (v1).**

- **Creating a new durable resource** — this is the standard qualification path. `/create-skill` bounces an unqualified brief back here once, so new-resource work reaches a build engine through this command.
- **Improving an existing skill** — go straight to `/improve-skill` when the skill, the requested improvement and the mechanism are all already identified and settled. That is the ordinary path, not a bypass; `/improve-skill` stays independently reachable in v1.
- **Qualify the improvement here first** when the underlying need, scope, mechanism or system fit is materially uncertain or contested, or when the improvement may justify a different or a materially expanded resource.

- **Retiring an existing durable resource** — this command owns withdrawing a durable AI artifact that is already in service. It covers **AI artifacts only**, and two neighbouring classes sit outside it with **no live owner to route to**: retiring an **operating capability** has a definition, but the layer holding it lost its executor, so it is currently unreachable and its disposition is an open question; retiring a **non-AI repository feature** has no candidate owner at all and is carried as a recorded deferral. This command does not own, perform or re-home either. Where a request is one of them, say which class it is and that its ownership is unresolved — do not name a substitute owner.

This command is never mandatory or standard for *every* material improvement. The settled-mechanism test above is what decides.

**Boundary vs neighbours.**
- `/create-skill` and `/improve-skill` are the build engines this command hands skill-class work to at Step 2. `/improve-skill` is additionally an entry point in its own right, per **Authority** above.
- `/placement` remains a standalone advisory route. This command reads the same authoritative placement heuristics when mechanism or location is genuinely open.
- `/leverage-idea` starts from an idea dump and hands the recommended option to the command that owns its next step. On the new-or-materially-expanded-resource route it names this command and writes the brief to `inbox/` itself, so that arrival is an ordinary `inbox/` invocation — raw by construction, carrying neither reserved upstream label. `/request-skill` captures a brief for later. This qualifies and builds now.
- An independent Codex review (risk-aware when the change is high-consequence) and `/implementation-triage` are the specialist capabilities Step 3 draws on when the claim and consequence warrant it.
- `/work-loop-v2` owns **operating outcomes** — bounded repository and project work no specialist owner covers, including whether a capability that already exists enters normal operations. The boundary is sequential, never simultaneous: while the operating outcome is unresolved Work Loop v2 owns it, and once the open question is whether a *durable AI artifact* should exist, that question is this command's and Work Loop v2 routes it here. This command returns a disposition on the artifact and never takes the operating outcome back. The skill is not the capability; it is one implementation component. The v1 `/work-loop` command that once held this seam has been deleted — `skills/capability-development/SKILL.md` and `docs/work-loop.md` survive as v1 method documents with no live executor, and their disposition is not this command's to make. **No component emits the two reserved upstream provenance fields today**, so a brief carrying them is an unverified *claim* that Step 1.0 checks against a record on disk before honouring — see Step 1's upstream-brief clause.

Input: `$ARGUMENTS` — a plain-English need, a path to a brief in `ai-resources/inbox/`, an existing resource to improve, or an existing resource to retire. If empty, ask for the need in one line and wait.

---

### Step 1 — Qualify

**1.0 Upstream-qualified brief — verify the record, then trust it. Never the reverse.**

A brief carrying both `**Capability:**` and `**Settled upstream:**` claims to arrive from an upstream capability owner that has already validated the operating need, established ownership and the seam, and holds the adoption decision. **Two markdown field labels are a claim of provenance, not proof of it** — any document can carry them. So upstream mode is entered only when the claim is corroborated by a real record on disk.

**Route on field presence:**

- **Neither field** → ordinary direct invocation. Ignore this clause entirely and run Step 1 from 1.1. This is the common case and produces no output.
- **Exactly one field** → **malformed upstream handoff.** Report it and run 1.1–1.6 in full. A half-formed handoff is not a handoff.
- **Both fields** → run the four checks below. **All four must pass.**

**The four checks.** `{WORKSPACE}` resolves by the ancestor walk-up defined at 1.5. **If that walk-up fails, the checks cannot run: report a malformed upstream handoff on that ground and run 1.1–1.6 in full.** An unrunnable check is a failed check, never a passed one.

1. **The record resolves to exactly one file.** `**Capability:**` carries **either** a workspace-relative path to the record **or** a bare slug — and nothing else. A path is used as given. A bare slug is resolved by glob, and **exactly one** match is required; zero matches and two-or-more matches both fail.
   ```bash
   # bare-slug form
   ls {WORKSPACE}/projects/*/development/{slug}.md 2>/dev/null | wc -l   # must be exactly 1
   ```
2. **It is a capability record, in the expected location.** The resolved path must match `projects/{p}/development/{slug}.md` — the `development/` directory is what makes it a capability record's home; a file of the same name anywhere else is not one — **and** the file must open with YAML frontmatter carrying a `capability:` key. A file with no frontmatter, or frontmatter without that key, is some other document and fails here. (Reachable only via the path form; the bare-slug glob is already rooted at `projects/*/development/`.)
3. **Its identity agrees with the brief.** Read the frontmatter and require both:
   - `capability:` equals the slug the brief supplied — or, when a path was supplied, its **filename stem, without the `.md` extension**;
   - `owner_project:` equals the `{p}` segment of the record's own path.

   A record whose frontmatter disagrees with its own location, or with the brief that pointed at it, is reporting an identity it cannot support.
4. **Its `status:` is in the ACTIVE set** — `in-development` · `continue-trial` · `revise` · `paused`, per the `STATUS IS A SET` block in `templates/capability-record.md`. A record at a TERMINAL status (`adopted` · `keep-local` · `closed` · `retired` · `rejected`) fails this check.

   **Why this check exists.** Records are never deleted; a `rejected` record persists forever *as the evidence that the need was refused*. Without this check, that record would satisfy checks 1–3 and cause 1.1 to treat the need as validated by a document whose own content says the opposite — the same trust-the-label failure one level deeper. An ACTIVE status is the expected state at handoff because the **capability** is still in development; the check keys on the record's `status:` and makes no claim about the state of any calling unit.

**All four pass → upstream mode.** Treat 1.1 and 1.2 as satisfied by the record: do not re-derive the need and do not re-classify its evidence. Say so in one line, naming the resolved path and the record's `status:`, so the operator can see which record was trusted. **Steps 1.3–1.6 still run in full, scoped to the artifact:** does this artifact already exist, is this rung the smallest mechanism for *this artifact*, and where does it belong. Step 4's disposition covers the artifact only and returns to the calling unit; it is not an independent adoption decision — Step 4 carries the matching branch.

**Any check fails → MALFORMED UPSTREAM HANDOFF.** Report which check failed, what was expected, and what was observed — including the resolved path when there was one. Then **run 1.1–1.6 in full**, exactly as an ordinary direct invocation. Three prohibitions, each closing a way the failure could be silently swallowed:

- **Do not skip 1.1–1.2.** A failed provenance check means the need is *unvalidated*, which is precisely when qualification is needed most. Failing open here would make the check decorative.
- **Do not auto-repair the record**, and do not create one. Writing a capability record belongs to the upstream capability owner (`templates/capability-record.md`), never to this command; a consumer that repairs its own input destroys the evidence that the handoff was broken.
- **Do not infer the capability's content from the brief alone.** If the record cannot be read, its contents are unknown — not reconstructable from the document that pointed at it.

> **No component emits these fields, and no live producer exists.** The producer was to ship with the v1 `/work-loop` capability route; that command has been deleted, and **Work Loop v2 does not emit these fields either**. Verified 2026-08-07 — searching `.claude/commands/`, `skills/` and `.agents/skills/` for the literal `Settled upstream` returns only this file, and for the literal `**Capability:**` returns only this file plus `.claude/commands/leverage-idea.md`, which instructs against writing that label. So this clause is **dormant producer-side and live consumer-side**: any brief reaching it came from something other than a proven producer, which is exactly why the checks above are mandatory rather than advisory. Check 1 is the normative value contract for `**Capability:**`; the producer-side obligations it would create are recorded in `plans/2026-07-28-work-loop-consolidated-build-plan.md` §11.

**1.1 State the understanding.** Three lines: the practical outcome wanted, what happens today, and any ambiguity blocking responsible progress. Read attachments and conversation first, then ask only where an answer would change the outcome, boundary or usefulness — grouped, in plain English.

**1.2 Establish the evidence.** What shows a real gap: a cited log entry, a reproduced failure, an operator-stated need, an observed workflow cost. Classify it **recurring · one-off but consequential · speculative**. Speculative is a valid finding — name it as such and let it shape the verdict.

**1.3 Inspect existing capability.** Scope the search to the proposed capability. Search by purpose and behaviour, not name alone, across `.claude/commands/`, `.claude/agents/`, `skills/`, `docs/`, `prompts/`, hooks and project-local equivalents. Use skill frontmatter to locate candidates, then **read the relevant skill body and its observable behaviour** — coverage means the resource performs the work and produces an observable result.

Disposition every near-match as **covers it · covers part of it · adjacent but different**, with the path.

Read `docs/repo-architecture.md` § Placement heuristics (Q1–Q8) when mechanism or location is genuinely open.

**1.4 Select the smallest mechanism.** Weigh only the rungs materially relevant to this need, preferring the less permanent:

accept the limitation → change an operating habit or information flow → normal prompting → reuse or improve an existing resource → use an external resource → a reusable prompt or reference file → a narrowly scoped persistent instruction → an operator-facing command or specialist skill → a deterministic script → a hook or other automatic enforcement.

A thinking aid — go straight to a later rung when the evidence warrants it.

**1.5 Apply the complexity budget** when the verdict is a **new or materially expanded** durable component. Read `docs/ai-resource-creation.md` rule #7 and apply it insofar as it stays compatible with the governing specification and the foundational principles at `{WORKSPACE}/projects/repo-documentation/vault/principles/principles.md` — a consequential one-off need can qualify without a prescribed log entry.

`{WORKSPACE}` is the Axcíon AI Repo root: resolve it by ancestor walk-up from the session directory — the nearest ancestor holding both `ai-resources/` and `projects/` — the same idiom `auto-sync-shared.sh` and `/reconcile` use. The principles vault lives at the workspace layer, not inside this repo, so a repo-relative path resolves from neither an `ai-resources` session nor a project session. If the walk-up finds no such ancestor, say the principles were unreachable and proceed on `docs/ai-resource-creation.md` rule #7 alone — do not infer their content.

Where two applicable authoritative sources appear to conflict, establish precedence first: the governing specification and the foundational principles set it. Bring the conflict to the operator **only** when the sources genuinely conflict *and* precedence cannot be established that way. A review judges premise and consequence, not which document wins.

**1.6 Verdict.** One of: **no build · accept the limitation · normal prompting · change an operating habit · reuse as-is · improve an existing resource · use an external resource · bounded experiment · project-local resource · shared resource · defer** (with a concrete trigger — a date, a quarter or a named event) **· retire an existing resource** (an artifact already in service should be withdrawn).

**Completion criterion:** the verdict names the mechanism *and* the evidence it rests on, and every near-match from 1.3 is dispositioned. On no build, reuse as-is or defer — go to Step 4 and stop. On **retire an existing resource** — go to Step 4's retirement branch and stop: there is no candidate to build or verify, and the dependency inventory that branch requires is the evidence.

---

### Step 2 — Build

**2.1 Assemble only what the candidate needs:** the need, representative examples, authoritative sources **by path rather than copied**, boundaries and confidentiality limits, expected behaviour, stopping conditions, and the cases Step 3 will test.

**2.2 Route by mechanism.**

- **Skill (new)** → invoke `/create-skill` via the Skill tool with a qualified brief.
- **Skill (improvement)** → invoke `/improve-skill` via the Skill tool with the target and the improvement.
- **Prompt, reference file, persistent instruction** → draft directly. Small, bounded, reversible.
- **Command, script, hook** → build the smallest version; Step 3 selects the verification. Deterministic surfaces get executable tests.

**2.3 Apply the specialist authoring method to any skill-class candidate.** The five practices below are the authoritative Axcíon copy — adapted, not installed, and not tracking upstream. Source: Matt Pocock's `writing-great-skills` (`SKILL.md` + `GLOSSARY.md`) — **pinned snapshot as of 2026-07-26**, commit `697d4ce9742da558fd1ba6697c8e9775e2e302dd` of `github.com/mattpocock/skills`. That commit is the snapshot boundary, not the authoring revision: it added cross-harness metadata, and the practices below were last materially changed at `af6d6922`. They cover only what `skills/ai-resource-builder/` leaves uncovered — trigger front-loading, negative triggers, progressive disclosure, required sections and the size budget already live there.

- **Leading words.** A compact concept already in the model's pretraining that the agent thinks with while running the skill. Make the steering word load-bearing: *"a weak leading word (be thorough when the agent is already thorough-ish) is a no-op; the fix is a stronger word (relentless), not a different technique."*
- **Completion criteria as steering.** *"A demanding completion criterion drives thorough legwork."* Each step states the condition that tells the agent the work is done — checkable, and exhaustive where that matters — not merely what to do.
- **Premature completion.** Steps still ahead create forward pull that tempts the agent to rush the one in front. Sharpen the current step's completion criterion first; split the sequence only if that fails.
- **No-op detection.** For every sentence ask *does this change behaviour versus the default?* When one fails, delete the whole sentence rather than trimming words from it.
- **Negation backfires.** Prohibition drags the forbidden behaviour into context: *"don't think of an elephant"* names the elephant and makes it **more** available. State the positive target wherever a target can be stated. This governs skill *bodies*; a description's negative triggers stay negative — they route, they do not steer.

Apply these while drafting the brief for the engine **and** while reading what the engine returns — not as a post-hoc read. Select only the practices this candidate turns on, and in the Step 4 report **name each practice used and the concrete change it produced**. A practice named without a change it produced is not evidence it was applied. This method governs skill *quality*; need validation, mechanism selection, placement, system fit and adoption stay with this command.

**Qualified brief contract.** The `/request-skill` brief shape (`# Resource Brief:` / Requested / Origin / Capability / Trigger Conditions / Exclusions / Context / Existing Skills Reviewed) plus two required fields:

```
**Mechanism:** {the 1.4 verdict and why this rung, not a lower one}
**Evidence:** {the 1.2 evidence, cited — or "speculative"}
```

Both fields present means qualified. A brief without them is raw and belongs at Step 1.

**2.4 Build the minimum.** Modify an existing resource when responsibilities substantially overlap. Keep the change narrow enough to evaluate, leave adjacent improvements alone, and follow current repository and Git practice. Add infrastructure only when the candidate cannot work or be tested without it — a draft lives in its intended location, not in a `v2` scaffold.

**Completion criterion:** one candidate exists, its scope matches the Step 1 verdict, and nothing outside that scope was touched.

---

### Step 3 — Verify

Three questions, answered separately. **Answer all three before reading Step 4** — the decision is visible from here, and a skimmed verification is how this command fails.

**3.1 Is the candidate well made?** Clear purpose and scope; correct inputs and authoritative sources; appropriate invocation; necessary boundaries; useful output; a checkable completion or stopping condition; visible handling of missing evidence; proportionate length. For skill-class work, read the selected engine's own evaluation rather than repeating it.

**3.2 Does it belong in the system?** A durable resource is still justified; the mechanism is still the smallest reliable one; it duplicates and conflicts with nothing; it references rather than copies authoritative context; its consumers and handoffs are clear; its maintenance cost is proportionate; it can be replaced or removed cleanly. **Keep this separate from 3.1** — a well-made resource can still be the wrong thing to own.

**3.3 Does it do what it claims?** Choose tests from the candidate's own behavioural claims: a normal case, a materially different case, a non-interference case, a missing-evidence or stopping case, invocation and non-invocation, failure and recovery.

Judge depth in-session and store no classification. Deeper verification fits a resource that acts automatically, spans consumers, changes shared or persistent instructions, can destroy or overwrite work, or is hard to reverse. For mandatory change classes see `docs/audit-discipline.md`; for the verification floor by output class see `docs/spine-schemas.md` §4.

**3.4 Report what was observed.** A test that did not run is **unassessed** or **blocked**. Runtime behaviour is evidenced by execution — a file existing, documentation claiming a control is active, or a static check passing evidences none of it.

**3.5 Simplify.** Remove instructions, content or machinery that do not contribute to the demonstrated behaviour, then rerun the affected cases.

**Completion criterion:** 3.1, 3.2 and 3.3 each have a stated answer; every claim is marked observed, unassessed or blocked; simplification was considered, any non-contributing material removed, and every materially affected case rerun.

---

### Step 4 — Decide

**When a candidate was built,** give the operator: the need; the mechanism and why; what was reused, changed or left alone; **what happened before and what happens with the candidate**; where it applies and where it does not; what was actually tested and observed; what changes if it ships; and what would later justify simplifying, replacing or removing it.

The operator then chooses **Ship** (adopt via normal integration practice) · **Revise** (return only to the step the feedback affects) · **Defer** (preserve recoverably, unadopted) · **Delete candidate** (remove it, system unchanged). Adoption and integration wait for that choice.

**In upstream mode (1.0), this step returns a disposition — it does not make the adoption decision.** Record the disposition against the **capability record** named in the brief, which is the durable address and stays open while the capability is in development; the capability's adoption decision belongs to the upstream capability owner and its own operator gate, not here. This applies to **both** branches of this step, the built-candidate one above and the no-candidate one below.

Two consequences worth stating, because each would otherwise leave a step unsatisfiable:

- **Return address is the record, not the calling unit.** The unit that handed the brief over may already be closed by the time this step runs, so the record — durable, and open while the capability is in development — is the only address that reliably survives. **The caller-side contradiction this bullet used to describe is resolved** (2026-07-29): `docs/work-loop.md` § Execution boundary now states that a `/develop-ai-resource` hand-off supplying one *component* of a live stream is **not** terminal and not a `routed-out` close, and that its disposition returns through the capability record — which is exactly the design this step already assumed. `routed-out` is now reserved for a whole need leaving. Citations here are deliberately by section rather than line number; two line citations in this file drifted mid-session on 2026-07-28.
- **When the input was an `inbox/` brief, the returned disposition is what triggers archiving** under the closing rule below — there is no separate operator acceptance in upstream mode, because the accept/reject decision sits with the upstream capability owner.

**When no candidate was built,** give the recommendation, the evidence, and the existing capability or habit that serves the need instead. The operator chooses **Accept** or **Reconsider with additional evidence**.

**When the verdict is to retire an existing resource,** this branch runs instead of the two above. **The § 1.6 verdict is the only entry.** Naming an in-service artifact at invocation does not select this branch — an ordinary improvement invocation names one too — so an argument can *propose* retirement, but only qualification establishes it. A run that opens "retire X" and qualifies to `improve an existing resource` takes the built-candidate branch like any other improvement. Upstream mode (1.0) does not reach this branch either — an upstream brief asks for an artifact to *exist*, not for one to be withdrawn — so the disposition rule above still covers exactly the two branches it names.

**Retirement is not `Delete candidate`.** `Delete candidate` disposes of an unadopted candidate this run produced: nothing depended on it, so removing it leaves the system unchanged. Retirement withdraws something already in service, which by definition has dependents. The two are never interchangeable.

**Before the operator decides, put the proposal in front of them:** the artifact and where it lives; **every live surface that depends on it** — references, consumers, invocation paths, deployments, symlinks, automatic or scheduled triggers, and documentation that routes to it — established **by search, not by recall**; and for each surface, the **replacement or the accepted loss**. A surface that was never named was never dispositioned.

The operator then chooses **Retire** (remove it, on the plan above) · **Revise** (change the plan — usually one dependent's disposition) · **Defer** (leave it in service, with the concrete trigger that would reopen retirement) · **Keep** (retirement rejected). **Nothing is removed before that choice.**

**Retirement is complete only when** the machinery is gone or each remaining piece is explicitly dispositioned; every surface in the inventory is removed, repointed or recorded as an accepted loss; a re-run of the same search that built the inventory shows **no dangling route to the retired artifact**; and what was removed is stated in the ordinary task and commit evidence. No retirement register, tracker or status file — the commit is the record.

**A dependency that cannot yet be removed or safely dispositioned stops the retirement.** Name it, and take Revise or Defer. Declaring retirement complete with that dependency outstanding is a false retirement — which is exactly what happened when the v1 `/work-loop` command was deleted on 2026-08-06 (`0516bf6`) and four surfaces went on naming it.

**Closing an `inbox/` brief.** When the input was a brief in `inbox/` and the operator accepts a disposition of **no build · reuse as-is · rejection · deferral**, move the brief to `inbox/archive/` — the same convention a fulfilled brief follows. Add one line at the top of the archived file: the date, the disposition, and the reason in a clause. For a **deferral**, that line names the concrete trigger that would reopen it — a date, a quarter or a named event. The intake queue then holds only briefs still awaiting a decision. No register, tracker or status file.

**A retirement run closes the same way.** Where the input was an `inbox/` brief, `Retire`, `Keep` and `Defer` are its terminal dispositions: archive the brief under the convention above, with the one-line note naming the date, the disposition and the reason — and, for `Defer`, the concrete trigger that would reopen retirement. `Keep` archives like any answered question; the record that retirement was proposed and refused is the point. `Revise` is **not** terminal — the plan changes and the run continues, so the brief stays in the queue until one of the three is reached.

Where the recommendation is an external resource, state which is proposed — **reference without installing · install or enable · adapt or copy into Axcíon · use only its method now**. Each is a separate decision.

**Completion criterion:** candidate built — before/after demonstrated and a disposition obtained. No candidate — recommendation explained, and accepted or reconsidered. Retirement — the dependency inventory was established by search, the operator chose, and on **Retire** the re-run of that same search returns no dangling route. Either way, if the input was an `inbox/` brief, it has left the intake queue.

---

## Guardrails

- **Decide the technical questions here.** File shape, invocation model, hook design and test method are this command's job. Bring the operator business decisions — worth doing, acceptable burden, adoption.
- **Keep authoritative context by reference.** Copy when the source is unreachable, the content must stay fixed with the resource, or a pointer has demonstrably failed.
- **Stay inside the resource.** Portfolio prioritisation, repository redesign, incident recovery, architecture review, recurring audits, permission redesign and publication belong elsewhere — name the owner and route it.
- **These are reasoning phases.** They leave no stored state, gate or per-phase document.
- **Stop and surface** when the work needs a broader migration, or when two authoritative sources conflict.
