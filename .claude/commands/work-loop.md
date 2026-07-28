---
model: opus
effort: high
argument-hint: "[a need in plain English, a pasted Codex BRIEF block, or nothing to resume]"
---

Run one unit of the cross-model work loop: ingest a brief, verify its premises, classify the route, implement in-scope changes, return evidence for independent review, adjudicate the findings, and close. Codex is the independent reviewer; Claude is the single writer.

Input: `$ARGUMENTS` — a plain-English need, a pasted Codex `BRIEF` block, or empty to reconcile and resume.

**Read `ai-resources/docs/work-loop.md` before anything else, every invocation.** It is the contract: vocabulary, route triggers, block formats, artifact rules, reconciliation and resume order. This command orchestrates and implements; it does not restate the contract. Where this file and the contract disagree, the contract wins and the disagreement is a defect to report.

This command does **not** invoke `/session-start` or `/session-plan` — it is not a session lifecycle command, and `session-start.md:330` hard-fails without a `/prime` marker it has no business creating.

---

## Step 1 — Reconcile

Before consulting any resume tier, run the reconciliation table in `docs/work-loop.md` § Reconciliation. It is deterministic: match the observed state to a row and take that row's action. Report each repair in one line. Two rows are stops, not repairs:

- A record pointing at `Y` while an **incomplete** brief for `X` in the same stream is open → **stop, report both paths, ask.** Never merge, never guess.
- Uncommitted changes in `logs/loop/` → **report before resuming.** Never commit them silently.

One row is deliberately silent: a completed unit whose record reads `active_unit: none` is normal retained state, not an orphan. Do not report it and do not re-point to it.

## Step 2 — Resume or ingest

Apply the tiered resume in `docs/work-loop.md` § Resume order. No code path sorts by timestamp.

- **Resumed** → announce in one line (`Resuming {UNIT} — {phase}, route {route}.`) and continue at the phase that unit was in. Never re-run a completed phase and never ask the operator to re-explain.
- **No open work, `$ARGUMENTS` present** → treat it as a new need and continue to Step 3.
- **No open work, no `$ARGUMENTS`** → ask once what the need is. Wait.

**If `$ARGUMENTS` is a pasted Codex `BRIEF` block**, transcribe it verbatim to `logs/loop/{unit}.brief.md` at Step 3. Do not rewrite it, do not improve it, and do not merge two briefs. If it lacks the six header fields, ask Codex for a corrected block rather than filling them in yourself.

**If `$ARGUMENTS` is plain English**, compose the brief yourself in the contract's `BRIEF` shape. Say plainly in chat that this brief is Claude-authored, so it has had no independent framing — that is a real, recorded weakness of the unit, not a formality.

## Step 3 — Open the unit

**The unit opens before its premises are verified, and that order is the contract's** (`docs/work-loop.md` § The eight steps). It is deliberate: a rejected premise is a *result*, and a result needs an identity to be recorded under. Opening first guarantees that every artifact a unit produces — including the evidence for its own rejection — has a brief in front of it, which is exactly what § Resume order and § Reconciliation index on.

**Check the artifact root first** (`docs/work-loop.md` § Artifacts → Artifact root). The unit's artifacts belong in `logs/loop/` of the repository its block names in `REPO`, and this command must be running from that repository's root. If the invoking session's cwd is not that root, **stop before writing anything**:

> This unit declares `REPO: {repo}`, but this session is rooted at `{cwd}`. Its artifacts would be written where no `{repo}`-rooted `/work-loop` could find them. Re-invoke from `{repo}`. Nothing has been written.

Do not write the unit to the current root instead — that is the exact silent failure the rule exists to stop.

Allocate or carry the stream per `docs/work-loop.md` § Streams, units and phases, including the collision check against **both** surfaces (`logs/loop/{candidate}-*` and any `development/*.md` carrying `stream: {candidate}`).

Write in this order, and this order is load-bearing (contract § Ordering rule):

1. `logs/loop/{unit}.brief.md` — the fact.
2. The record pointer — **capability units only, and stubbed in this build**, so on the live routes this sub-step is a no-op.
3. `git add` **by explicit pathspec**, then commit.

Never `git add -A`, never `git add .`. Stage the paths this unit wrote, by name.

Announce: `UNIT: {unit-id}  STREAM: {stream-id}  PHASE: {phase}`

The route is not known yet — it is classified at Step 5, once the premises hold. Announce it there.

## Step 4 — Verify premises

**This step gates every edit to the object under work. Nothing is written to the brief's target before it passes.** Opening the unit at Step 3 is not an exception to that rule: the brief is the unit's own record, not a change to the object.

For each premise the brief asserts: run the script it cites, open the lines it names, re-derive the count it states — recording which primitive produced the number. Recall is not verification. A citation is not a check. **Re-derive against the live file every time** — a copy read earlier in the same session may already be stale.

Emit one line per premise:

```
PREMISE: confirmed — {claim} · {what was run} → {what was observed}
PREMISE: rejected  — {claim} · {what was run} → {what was observed instead}
```

**On any rejected load-bearing premise: stop the unit.** Make **zero edits to the object under work** and close as `rejected-premise` by the ordinary path in `docs/work-loop.md` § Closing without a change — evidence carrying the premise and what disproved it, the `CLOSE` block, the stream close and the durable `logs/decisions.md` pointer, all in one commit. Do not repair the brief's reasoning on its behalf and do not proceed on the surviving premises — a brief whose foundation is wrong needs re-briefing, not salvage.

**Negative results need a positive control.** An empty grep, a zero count or a "no matches" is not evidence until the same check has been shown to fire on a case that should match. State the control and its result alongside the negative.

## Step 5 — Classify the route

Apply `docs/work-loop.md` § Route triggers. Any one trigger fires; ambiguity resolves **upward**. State the route and the specific criterion that fired:

```
ROUTE: solo — one repository, 2 files, revert-reversible, no shared blast radius
```

For a **capability** unit, additionally apply `skills/capability-development/SKILL.md` § Route triggers. Read that skill only for capability units; never for ordinary work.

**Branch:**

| Route | This build |
|---|---|
| **solo** | Live — continue to Step 6 |
| **reviewed**, non-capability | Live — continue to Step 6 |
| **challenged** | **Stub — see Step 5a** |
| any **capability** unit | **Stub — see Step 5b** |

`/risk-check` fires at its own two gates on its own schedule (`docs/audit-discipline.md:73-81`). This command never absorbs, replaces, reschedules or substitutes for it. If the unit touches a structural class, the route escalates to challenged *and* `/risk-check` still runs at its own gates.

### Step 5a — Challenged route (stubbed)

Not yet implemented. It lands with the `update: /work-loop — challenged route, stream correlation, distinct pre/post reviews` commit, which adds: a pre-implementation review in the Shape unit, a post-implementation review in the Prove unit, the three operator stops (G1 scope and package · G2 release · G3 lifecycle), and stream correlation across units.

**Stop cleanly. Do not improvise the branch and do not silently down-route to `reviewed`** — a challenged unit run as reviewed skips the pre-implementation review, which is the only gate that stops a bad change *before* it is made.

The unit is already open by this point, so it does not evaporate: **close it as `route-unavailable`** by the ordinary path in `docs/work-loop.md` § Closing without a change, naming the trigger that fired and the revision that lands the route. Report:

> This unit classifies as **challenged** ({criterion that fired}). That route is not built yet — it lands with commit 3. **No edit was made to the object under work**; the unit closes as `route-unavailable`, and its brief and evidence stay recoverable from the closing commit. Options: wait for commit 3, or narrow the unit's scope until it genuinely classifies lower and re-run.

### Step 5b — Capability unit (stubbed)

Not yet implemented. It lands with the `update: /work-loop — capability units, record correlation, cardinality` commit, which adds: `projects/{p}/development/{slug}.md` record open and close, `stream:` / `active_unit:` correlation, the `## Units` table, per-slice Build cardinality, and the `capability-development` skill read.

**Stop cleanly** — and, exactly as at Step 5a, **close the open unit as `route-unavailable`** by the ordinary path in `docs/work-loop.md` § Closing without a change rather than abandoning it. Report:

> This unit is a **capability** unit. Capability handling is not built yet — it lands with commit 5. **No edit was made to the object under work**; the unit closes as `route-unavailable`. A non-capability slice of the same work can run now if one can be scoped.

## Step 6 — Execute

Implement the in-scope change. `docs/work-loop.md` § Execution boundary governs what this command implements versus routes out — read it rather than judging by feel.

**Route out, do not implement, in exactly two cases:**

- A **new** durable AI artifact must be authored, or an existing one materially expanded → hand to `/develop-ai-resource` with the brief attached, per its authority at `.claude/commands/develop-ai-resource.md:13-17`. Return its disposition to this unit; do not let it make the adoption decision.
- No legitimate owner exists, or the work is a new enduring programme → hand to `/scope-project`. **Terminal exit:** close the stream, record the routing note, and hold nothing open pending a project.

While implementing:

- Read before writing. Verify each target file is what the brief assumes it is — a path that resolves is not a file whose content matches the claim.
- Keep the change inside the brief's stated scope. Work that is obviously worth doing but outside scope becomes a finding with disposition `deferred`, not a quiet extra edit.
- Commit the unit's artifacts by pathspec at write time, before the next phase begins.

## Step 7 — Evidence, review, adjudication

**Write `logs/loop/{unit}.evidence.md`** in the contract's `EVIDENCE` shape. Append-only — never rewrite a prior entry. Every claim names what was run and what was observed. `LIMITATIONS:` is populated on every unit; if nothing limits the result, say what was *not* checked and why that is acceptable. A blank `LIMITATIONS` fails the unit.

**Solo route:** no review. Continue to Step 8.

**Reviewed route:** emit the evidence as a chat block for Codex, and tell the operator plainly what to do with it — paste it into the Codex `work-loop` task, then paste the returned `REVIEW` block back here. Transcribe the review verbatim to `logs/loop/{unit}.review-1.md`. Commit by pathspec.

**If Codex cannot reach the object under review** — no repository access, or the object is outside `ai-resources` and unreadable — fall back to `/qc-pass` **and record the review as `unassessed`, not passed.** Never substitute a Claude subagent and describe it as independent: same model, same session lineage, no independence. The operator decides with the gap explicit.

**Adjudicate every material finding** with exactly one of the six dispositions in `docs/work-loop.md` § Block formats — `fixed` · `deferred` · `rejected` · `already-true` · `out-of-scope` · `operator` — each with its reason, and `rejected` with the evidence that disproves the finding. A finding is not dismissed by disagreeing with it.

`/resolve` and `/triage` do **not** fire. Adjudication is this step.

One correction pass, then the unit closes. A second review round is `review-2` and is justified only on the Independent Review SOP's five triggers — not on a general wish for more assurance.

## Step 8 — Close

Write the `CLOSE` block: outcome · commits · what closed · whether the stream closed with it. The outcome is exactly one of the four in `docs/work-loop.md` § Block formats — `close` · `rejected-premise` · `route-unavailable` · `routed-out`.

**Only `close` leaves its trace in the repository.** The other three changed nothing, so they all take § Closing without a change, which requires the durable one-entry pointer in `logs/decisions.md` alongside the evidence — without it, a unit that stopped is indistinguishable from one never attempted, and the same disproved brief returns a week later.

**The stream's last unit closes the stream in the same commit.** For solo, that is this single unit. On stream close, delete **every** `logs/loop/{STREAM}-*` file together, in the closing commit, by pathspec. Artifacts stay recoverable from git afterwards; the commit SHAs are the pointer. No stream is left in an "awaiting closure" state.

Announce in one line what closed and where the work landed. Then stop — this command does not chain into `/wrap-session` and does not push.

---

## What this command never does

- Never writes `logs/missions/{id}.md` — `/mission` is its sole writer.
- Never edits `/prime`, workspace `CLAUDE.md`, permissions, hooks or settings.
- Never runs `git add -A` or `git add .` — pathspec staging only.
- Never pushes. Never commits outside the unit's declared paths.
- Never holds methodology. Everything about *how* a capability phase is actually practised belongs to `skills/capability-development/SKILL.md`; this command cites that skill and never restates any part of it. The boundary is tested in both directions by A-CORE-7, which outranks the size target above.
- Never calls a same-model review independent.
