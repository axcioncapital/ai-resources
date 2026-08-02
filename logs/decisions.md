# Decision Journal

> Archive: [decisions-archive-2026-08.md](decisions-archive-2026-08.md)

## 2026-08-01 — Codex's claimed prohibition on approving or closing work does not exist; no override was granted

**Decision (Claude, on evidence; operator informed rather than asked) — 2026-08-01.** **Context:**
Codex assessed the Work Loop v2 closure unit for `foreign-staging-target-repo`, passed it with no
correction required, and then declined to write the closing record, stating: *"The closure write was
blocked by this repository's rule prohibiting Codex from approving or closing work, and I did not
bypass it."* Its stated next action was: *"explicitly authorize Codex to write this Work Loop closure
despite that repository authority restriction."* The operator relayed this and was positioned to grant
that authorization. **Decision: refuse to route the operator toward an override, and verify the rule
first.** Searched `docs/qc-independence.md`, `AGENTS.md`, `.codex/`, and
`plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` for any bar on Codex approving or
closing work. **No such rule exists.** The only live rule in that area is core `:227-231`,
*"**Who commits: Claude.** Codex writes the brief into the file. **Claude makes every commit.**"* —
whose own stated reason is that *"Codex can write repository files, but was refused write access to
`.git`"*. That is a restriction on **committing**, not on **judging**. The core assigns closure to
Codex explicitly at `:74`: *"Codex reads the result and decides one of three things: close, correct
once, or stop."* **Rationale:** granting the requested authorization would have created a standing
operator exception to a prohibition that does not exist — permanently weakening a real rule (Claude
makes every commit) by "clarifying" it against an imagined one, and establishing that a model's
assertion of a rule is sufficient grounds to override it. The designed path required no exception at
all: Codex's verdict was already given, and Claude writes and commits the closing record because
Claude writes and commits everything. **Alternatives considered:** (a) grant the authorization as
requested — rejected, it overrides nothing real and sets the precedent above; (b) ask the operator to
adjudicate between Codex's claim and the repo — rejected under Decision-Point Posture, since the
question is settleable by reading the repository and is therefore not a genuine operator decision;
(c) have the operator write the closing record by hand — rejected as pure ceremony for zero gain.
**Consequence:** the task closed normally at `2526ac4` with nothing overridden. Logged as **FP-12** in
`plans/work-loop-v2-mvp/step-7-pilot-log.md`, with the generalisable lesson stated there: *a model
citing a rule is not evidence the rule exists; an override request is the moment to read the rule,
not the moment to grant it.* A one-line core fix is recorded but not applied — § 4's "Who commits"
note and § 3 step 5's assessment role sit in different sections and neither points at the other,
which is the gap Codex fell into. It belongs to Step 8, not to a separate queue entry.

## 2026-08-01 — Work Loop v2 pilot exit: accepted, with a v0.2 rework

**Context:** Session S14-198. The pilot's exit condition (`work-loop-v2-mvp-proposal-v0.4.md:102`) is
the operator's judgment on usefulness, not a unit count or a green harness. Three genuine units had
closed; the evidence split cleanly between what the loop's review caught and what its bookkeeping
cost, and Core § 2's Direct Work bypass had never fired once across all three units.

**Decision:** Exit accepted. The loop helped get real work done, and the shape it did it in is not
the shape to keep. Direction set for a v0.2 rework: keep the adversarial review — the component the
evidence supports without qualification — and shed most of the bookkeeping (state-file ceremony, turn
flags, unit numbering, the operator as message bus). Scope and shape are **not** decided here.

**Rationale:** Codex found two real defects in Claude's work that Claude's own passing test harness
reported as absent; a self-review cannot supply that. Against it, one checkbox tick went through a
brief, a premise check, a hand-back, an operator stop, a state-file edit and a commit. And condition 5
— the bypass meant to keep small reversible work *out* of the loop — never fired in three consecutive
genuine units. A bypass that never fires is a rule on paper, and that negative result is treated as
the strongest single input to the v0.2 rework, not as an unresolved pilot obligation.

**Alternatives considered:**
1. Exit accepted, keep the current shape — rejected; the bookkeeping cost is the evidence against it.
2. Not yet, keep piloting — rejected; would also require closing the CRM/Email OS domain gap for real
   rather than by amendment (see the paired decision below), at further session cost.

**Recorded:** `plans/work-loop-v2-mvp/step-7-pilot-log.md` § The decision;
`logs/missions/work-loop-v2-mvp.md` Step 7 thread.

## 2026-08-01 — Work Loop v2 mission acceptance assertion 8 amended

**Context:** Session S14-198, decided alongside the pilot exit above. The mission's frozen acceptance
assertion read "At least two real CRM / Email OS units have completed through the loop." All three
pilot units were genuine `ai-resources` / `axcion-systems-builder` infrastructure work; "CRM" and
"Email OS" appear exactly once in the 774-line pilot log, in the standing constraint that named them.

**Decision:** Amend the assertion to "at least two genuine units — work the operator wanted done
anyway, never manufactured." The named domain changes; the substance does not.

**Rationale:** The constraint that actually governed the pilot throughout (`step-7-pilot-log.md:86`,
"genuine units only … a manufactured unit tests nothing") was met in full by all three units. Reading
the original wording as satisfied would have been false — the pilot never touched CRM or Email OS.
Leaving it frozen and unmet would have blocked mission completion on a label mismatch rather than on
missing evidence. This is the second amendment to this frozen contract; the freeze otherwise stands,
matching how the mission's one prior amendment (destination behaviour 1, Step 3) was handled.

**Alternatives considered:**
1. Leave frozen, record as not satisfied — rejected; honest but blocks on wording, not evidence.
2. Run one real CRM or Email OS unit to close it as literally written — rejected; would cost a further
   session testing nothing the pilot hadn't already tested, and is inconsistent with the exit decision
   just taken.

**Recorded:** `logs/missions/work-loop-v2-mvp.md`, acceptance assertion 8.

## 2026-08-02 — Work Loop v2 Context Engineering integration withdrawn: the required proof needs Codex and Claude running together

**Context.** Codex issued an implementation mandate to wire Context Engineering into the live Work
Loop v2 Codex-to-Claude path, and the operator approved the CE spec content at commit `148689d` for
that unit. The mandate's required evidence included a demonstration with fresh contexts: *"Fresh Codex
recovers that fact and produces the correct bounded brief. Fresh Claude receives the brief without
operator copying."*

**Decision.** The operator withdrew the mandate mid-session — *"implementation call was premature by
codex"* — and directed that the five applied edits be discarded. They were, and were verified
byte-identical to `HEAD` by checksum.

**Rationale.** The demonstration Codex asked for cannot be produced by Claude working alone. Codex
runs in the ChatGPT desktop app and is operator-driven; Claude cannot invoke it. So a session
structured as "Claude implements and proves it" could only ever have produced half the evidence and
then described the other half as owed. The CE specification already anticipates exactly this split in
CE-17's two-proofs table — the **isolated** proof (one preparation pass produces a consumable brief)
versus the **integrated** proof (the brief is actually delivered to and consumed by Claude with no
operator ferrying) — and states that *"a real adoption claim requires the integrated proof"* and that
the isolated one *"must never be presented as the integrated one."* This is a sequencing problem in
the brief, not a design problem in the specification.

**Alternatives considered.** (a) Implement anyway and report the integrated proof as owed — rejected
by the operator as premature, and it would have landed changes to three shared runtime artifacts on
half the evidence. (b) Substitute a fresh Claude subagent for the fresh Codex thread — rejected by
Claude before it was proposed: that is precisely the substitution CE-17's proof table names as a
failing case, and a standing session instruction forbids the Agent tool unless asked. (c) Leave the
edits uncommitted for a later session to judge — offered, and the operator chose discard instead.

**Consequence for the retry.** A future attempt must be structured as a genuinely two-model session:
the operator running Codex, Claude running against the same repository. The reverted design is
recorded in `logs/scratchpads/2026-08-02-13-08-scratchpad.md` so it need not be re-derived.

**Not decided here.** Whether the CE spec's stage header flips from "draft specification — awaiting
operator approval". The approval given was scoped *"for this implementation unit"*, so the spec was
left untouched.
