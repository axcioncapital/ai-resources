# Open issue — a new request has no way to reach Codex

**Status:** open, not fixed. Recorded for a later session at the operator's request.
**Found:** 2026-08-01, session S9-6ba, at the start of Step 6.
**Affects:** `.agents/skills/work-loop-v2/SKILL.md`, `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`.
**Not a blocker for Step 6 acceptance** — a workaround exists and is described below. It is a
candidate finding for the Step 6 candidate review.

This file is self-contained on purpose: it assumes the reader has no memory of the session that
found the problem.

---

## 1. What happened

The task was to test one acceptance behaviour — that Codex refuses to open a loop task whose only
stated reason is "this feels significant" (Slice 3, behaviour 3.1(b)).

The operator pasted this into Codex:

```
$work-loop-v2 — open a task to polish the fixture wording. Reason: this feels significant.
```

**Codex replied that it had no task visible to it.** It did not refuse on admission grounds, and it
did not open anything. It simply had nothing to act on.

This is the **second** occurrence of this class. The first is already on the record:
`step-5-slice-3-evidence.md` line 118 — *"the Codex opening prompt did not land"* — where the session
worked around it by hand-writing the brief instead.

## 2. Why Codex behaved that way

Codex was not malfunctioning. It was following its own resource correctly.

The Codex-side resource tells it, in the section that defines the seam
(`.agents/skills/work-loop-v2/SKILL.md` lines 16–18):

> You and Claude are not connected. **The task-state file is the only interface** […]
> You **write** the state file at `logs/work-loop/{task-id}.md`.

The executable core says the same thing more broadly (`work-loop-v2-executable-core-v0.1.md` § 4):

> **One task, one file.** It is the only interface between Codex, Claude **and the operator**.

Read literally — and Codex read it literally — no state file means no task, which means nothing to
see. That is the behaviour observed.

## 3. The actual defect: the artifacts contain two contradictory claims

The problem is not that Codex was too literal. It is that **both readings are written into the
artifacts, and they cannot both be true.**

| Claim | Where | What it implies |
|---|---|---|
| The state file is the *only* interface between Codex, Claude and the operator | core § 4; `SKILL.md:16` | A request cannot reach Codex except through a file |
| Codex shapes the brief by asking the operator questions — *"Ask what goes wrong today — one round, not an interrogation"* | `SKILL.md:44` | A conversational operator→Codex channel exists and is used |

The second claim requires a channel the first claim denies. And the gap bites at exactly one moment:
**the very first request in a task, when no file exists yet.** This is a chicken-and-egg problem —
the file is said to be the only way in, but the file is created by the act of coming in.

Nothing in either artifact says how a brand-new request gets to Codex.

## 4. The workaround used, and what it costs

Claude wrote the operator's request into a state file with `turn: codex`, deliberately carrying no
brief, no lane and no unit, and committed it (`0501d65`). Codex then picked the task up from the file
alone and handled it correctly — it refused admission, named the reason as non-qualifying, and routed
the request back to the operator.

So the workaround works. **But it has a real cost, and the cost lands on the exact discipline this
part of the build exists to protect.**

Behaviour 3.1(a) says a small reversible fix **opens no state file** — no brief, no ceremony. If the
only way to get a request in front of Codex is to write a state file first, then *every* request
creates a state file, including the ones that should have been Direct Work. Admission is decided
*after* the file exists, so the file can no longer be the evidence that admission was refused.

Concretely, the repository now holds `logs/work-loop/fixture-step6-admission.md` — a state file for a
task that was **never admitted**. Under the current design that object has no defined meaning.

There is a second, smaller cost: the acceptance harness asserted 3.1(b) partly by *file absence*
(`work-loop-v2-slice-1.test.sh:405`, `! ls logs/work-loop/ | grep -qi 'significant'`). Once a request
file exists before admission, absence stops being a valid measure of "opened nothing", and the
assertion has to test the refusal's substance instead.

## 5. How to reproduce

1. Ensure no open task file exists in `logs/work-loop/` (all fixtures closed, `turn: operator`).
2. In Codex, paste a new request in conversation, e.g.
   `$work-loop-v2 — open a task to polish the fixture wording. Reason: this feels significant.`
3. Observe: Codex reports no visible task rather than performing admission.

## 6. Options for a later session

Recorded as options, not as a decision. None of these should be built before the Step 6 review has
judged whether this is a finding.

- **A — Correct the wording (cheapest).** core § 4 and `SKILL.md:16` overstate the claim. The state
  file is the only interface **between Codex and Claude**; the operator reaches Codex directly. Say
  that, and the contradiction in § 3 disappears with no mechanism added. Does not by itself explain
  how Codex sees a request when the operator is not in a position to converse with it.
- **B — Define a pre-admission request state.** Make a file that carries a request but no brief a
  legitimate, named state, with refusal as a normal terminal outcome. Honest, but it adds a concept
  to the state file, and it weakens 3.1(a) — Direct Work would still create files.
- **C — Give the seam an explicit intake path.** Document how a request reaches Codex, with the file
  created only *on admission*. Preserves 3.1(a) intact. The largest change of the three.

**Recommendation for whoever picks this up: start with A.** It is a wording fix to two documents, it
resolves a genuine internal contradiction, and it is the only one of the three that adds nothing.
Whether B or C is also needed is a question the pilot (Step 7) will answer better than any amount of
design now — the pilot is where a real request arrives from a real operator with no session in
progress.

## 7. What this issue does *not* undermine

Worth stating plainly, because the workaround could look like it invalidated the test it was serving:

- **Behaviour 3.1(b) came out green, on live evidence.** Once Codex could see the request, it refused
  it on its own, named "this feels significant" as non-qualifying under core § 2, and routed the
  request back to the operator. That was the weakest evidence in Slice 3 and it is now closed by a
  real refusal rather than by artifact text plus an absent file.
- **The bare-invocation deferral carried open since Slice 2 also closed here.** Codex resolved the
  open task from the state file alone, given only the repository path and the file path.
- **Claude made the commit, not Codex** — consistent with the amended acceptance assertion 1.
