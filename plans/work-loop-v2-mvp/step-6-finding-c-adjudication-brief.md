# Step 6 — finding C adjudication brief

**For:** Codex, as independent adjudicator.
**Written by:** Claude, session S10-7e5, 2026-08-01.
**Why you and not Claude:** Claude authored all four candidate files. On 2026-08-01 the operator
explicitly rejected "let Claude choose" on this decision (`logs/decisions.md`, entry *"Work Loop v2
Step 6: finding C deferred rather than settled under an authorship conflict"*, § Alternatives
considered). The operator has said they will not decide until you have given an independent verdict.

This file is self-contained. It assumes you have no memory of any prior session.

---

## 1. What this is — and what it is NOT

**This IS:** a bounded adjudication of **one already-frozen finding**, finding C, from a review that
has already happened. You are choosing between three recorded options and giving a reasoned verdict.

**This is NOT a second review.** Do not re-review the candidate. Do not open new findings. The
mission's non-negotiables forbid a second broad review after the correction pass
(`logs/missions/work-loop-v2-mvp.md`), and the review brief that governed the first review states the
same rule. If you notice something outside finding C, record it as a **deferral** in your hand-back —
never as a new finding.

**Do not invoke `$work-loop-v2` for this, and do not open a task-state file in `logs/work-loop/`.**
This decision governs the Work Loop; running it *through* the Work Loop is self-hosting, forbidden by
`work-loop-v2-mvp-proposal-v0.4.md` § 6 and the mission's non-negotiables. Claude made exactly this
mistake once already and it was corrected at commit `4c77ced`. Read the files directly and write one
document.

**Do not run git.** Claude makes every commit. (Amended acceptance assertion, operator decision
2026-08-01; Codex was refused `.git` write access in two independent sessions —
`step-2-transport-seam-conclusions.md` § 2.)

**You find and judge; you do not fix.** Do not edit any candidate file. If you edit, the thing being
judged moves under you and the verdict means nothing (`qc-process-v0.1.md`, standing rule 4).

---

## 2. The one question you are answering

> Both Work Loop v2 runtime artifacts — the Claude-side command and the Codex-side skill — **spell
> out rules that the executable core already owns**, instead of linking to the core. The writing
> standard forbids this. The independent reviewer rated it material and said it must be corrected
> before acceptance. Correcting it now is the largest change to the candidate, landing at the freeze,
> with only a narrow closure check left to catch a mistake.
>
> **Should finding C be corrected in full now, bounded to a disclosed limitation with a reopening
> trigger, or accepted outright?**

Your verdict decides whether Step 6 closes by correction or by disclosure.

---

## 3. First — verify you are looking at the right bytes

The candidate **moved** after the review: findings A and B were corrected at commit `edd0d97`. The
hashes below are the **current** state at `HEAD` = `881fab4`, not the original freeze at `cc443e1`.
Judge against these.

| File | Lines | Blob hash (current) |
|---|---|---|
| `.claude/commands/work-loop-v2.md` | 114 | `af411f203ada638fa9d4d459a1043ea87e0837aa` |
| `.agents/skills/work-loop-v2/SKILL.md` | 120 | `b1135f514520a62e58ecd8e65d42a3ae43b82b3e` |
| `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` | 282 | `6a7cce1eda911d0f0c75c6e17ee9f9cef86f8d2a` |
| `logs/scripts/work-loop-v2-slice-1.test.sh` | 620 | `0b2390e9064a600073d569ccd933c9b4c67815e0` |

Check each with `git hash-object <path>`. **If any hash differs, stop and say so** — the candidate has
moved again and this brief is stale.

Harness state at these bytes, verified by Claude this session: `bash
logs/scripts/work-loop-v2-slice-1.test.sh` → **143 passed, 0 failed, exit 0**. Re-run it yourself;
do not take it on trust.

---

## 4. What to read, in this order, and why each matters

**Read these four first — they are the minimum to answer the question.**

1. `plans/work-loop-v2-mvp/step-6-candidate-review.md` — **§ 6 is the whole open decision**, written
   by Claude at the point of deferral. It states the three options and Claude's recommendation.
   §§ 1–5 give the review's context; § 7 covers the six known limitations.
2. `plans/work-loop-v2-mvp/step-6-review-findings.md` — the **frozen findings A, B, C** as the
   independent reviewer wrote them, including the verdict line that sets the acceptance bar. Short.
3. `plans/work-loop-v2-mvp/skill-writing-standard-work-loop-v0.2.md` — **the rule C invokes.**
   § 1 (line 15): *"The command and the resource link to the executable core for rules. They never
   restate the core's content. One policy owner; zero drift."* § 10 (line 143) repeats it as a
   pre-commit check. This standard is **binding on artifact form**.
4. `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` — **the policy owner.** The rules
   being restated live here: admission (§ 2), the unit cycle including *Correcting once* (§ 3), the
   task-state file (§ 4), safety (§ 6), when to stop and ask (§ 7).

**Then the two runtime artifacts — the things that would change under option 1.**

5. `.claude/commands/work-loop-v2.md` (114 lines) — Claude's half.
6. `.agents/skills/work-loop-v2/SKILL.md` (120 lines) — Codex's half. **This is your own resource** —
   note the conflict-of-interest cuts both ways here, and say so if it affects your judgment.

**Then the evidence that bears on the decision.**

7. `logs/decisions.md` — two entries matter, both findable by heading:
   - *Slice 3* (~line 200–212): symmetric duplication of three behaviours across both artifacts was
     **rejected** during the build, citing this same "link to the core, never restate" rule. This
     suggests the rule was understood and applied **selectively**, so some of what remains may be a
     judged trade-off rather than oversight. **Weigh this — it is the strongest evidence against
     treating the remaining restatement as pure sloppiness.**
   - *2026-08-01, finding C deferred* (~line 214–245): the full reasoning for the deferral, the
     alternatives considered, and the operator's rejection of "let Claude choose".
8. `logs/scripts/work-loop-v2-slice-1.test.sh` — the acceptance harness. The assertions listed in § 5
   below are the blast radius of option 1.
9. `plans/work-loop-v2-mvp/qc-process-v0.1.md` — the four standing rules and the three review
   dimensions. Rule 4 is why you must not fix.
10. `plans/work-loop-v2-mvp/pocock-lifecycle-work-loop-mvp-v0.4.md` — **§ Step 6 point 5** is the
    protocol that authorises this escalation and supplies the menu: accept a disclosed limitation,
    permit one final tightly bounded fix, revert, reframe, or stop. It says *"genuine risk-acceptance
    choices escalate to the operator."*

**Optional, only if you need the wider frame:** `plans/work-loop-v2-mvp/README.md` (authority order
and post-v0.4 decisions), `work-loop-v2-mvp-proposal-v0.4.md` (authoritative scope),
`logs/missions/work-loop-v2-mvp.md` (validation contract and non-negotiables).

**Do not treat `the-work-loop-explained-complete-system-v0.2.md` as requirements.** It is destination
reference only. Machinery from it leaking into the MVP is itself a known failure mode.

---

## 5. A measurement Claude made — re-derive it, do not trust it

`step-6-candidate-review.md` § 6 says **"six harness assertions test for exactly the restatement C
wants removed"** and cites lines 367, 369, 371, 377, 449, 459.

Claude re-measured this session and those six line numbers are **accurate**, but the count appears to
be **an undercount**. Ten assertions test artifact text for specific restated policy wording:

| Line | What it asserts the artifact literally contains |
|---|---|
| 246 | `Correct once — frozen findings:` in the command |
| 248 | `Correct once — frozen findings:` in the skill |
| 367 | `direct work` in the command's admission section |
| 369 | `named reason` in the command's admission section |
| 371 | `feels significant` in the command's admission section |
| 377 | `feels significant` in the skill's admission section |
| 449 | `feels significant` in the skill (3.1b path) |
| 459 | `clos` in the command's de-escalation section |
| 461 | `smaller than assumed` in the skill's assessment section |
| 488 | `defer` in the command's step-4 section |

Two further assertions (373, 379) match artifact text but are **negative** checks — that an obsolete
Slice 3 disclaimer is *absent*. Those are unaffected by finding C.

Re-derive with:

```bash
grep -nE "grep -qi? '" logs/scripts/work-loop-v2-slice-1.test.sh \
  | grep -E "_cmd|_res|CMD_F|SKILL_F" | grep -v 'admit_committed'
```

> ⚠ **Read this measurement with suspicion.** A larger count makes option 1 more expensive, and
> option 1 is the option Claude recommended *against*. This measurement therefore favours Claude's
> own recommendation, and Claude authored the files. Re-derive it. If the count is wrong, say so
> plainly — that finding is more useful to the operator than agreement.

---

## 6. The three options, as recorded

Taken from `step-6-candidate-review.md` § 6. You may endorse one, or propose a fourth if the three
are genuinely wrong — but say why the recorded three fail before inventing one.

**Option 1 — Correct C fully.** Strip restated policy from both runtime artifacts; rewrite the
affected assertions so they test the *link* and the *behaviour* rather than the restated words. Meets
the reviewer's stated bar. Cost: roughly 15–20 of the command's 114 lines and 25–30 of the skill's
~120, touching nearly every section of both — the largest change to the candidate, at the freeze,
with only a narrow closure check remaining.

**Option 2 — Bounded correction (Claude's recommendation).** Record the remainder of C as a
**disclosed limitation with a concrete reopening trigger**: a pilot unit in which a restated rule in
either artifact contradicts the core, or in which a model follows the artifact's copy instead of the
core. Rationale: the harm C names is *"the duplicated policy has already drifted into finding A's
contradictory interface and next-turn rules"* — and that drift **is** finding A, which is fixed. The
remainder is prospective. The standard itself says the pilot "remains the only evaluation that
finally counts."

**Option 3 — Accept C outright** as a disclosed limitation with no reopening trigger. Cheapest and
weakest; the finding effectively stops existing.

---

## 7. Two conflicts you must resolve, not skip

**Conflict 1 — the reviewer's bar vs. the protocol's exit.** The frozen findings document opens:
*"Accept with corrections — … the three material findings below **must be corrected before
acceptance**."* Options 2 and 3 do not correct C, so both **overrule an independent reviewer's
explicit bar**. The protocol (`pocock-lifecycle` § Step 6 point 5) does provide a disclosed-limitation
exit, so this is permitted — but it is an override, and your verdict should say whether the override
is justified rather than pretend the tension isn't there.

**Conflict 2 — selective application of the rule.** Slice 3 rejected duplication citing the very same
rule, yet restatement remains elsewhere. Either the remaining restatement is a deliberate judged
trade-off (which weakens C), or the rule was applied inconsistently (which strengthens C). **Decide
which, with evidence from the artifacts.** This is probably the most decision-relevant question in
this brief.

---

## 8. Claude's position, stated so you can discount it

**Claude recommends option 2**, and this recommendation should carry little weight with you:

- Claude wrote all four candidate files and is recommending **not rewriting them**.
- The convenient answer and the recommended answer are the same answer — the condition under which an
  author's judgment is least reliable.
- Claude also produced the § 5 measurement that makes option 1 look more expensive.

The operator has already rejected letting Claude decide this. Your verdict is the input they are
waiting on. **Disagreeing with Claude is a fully expected outcome, not a problem.**

---

## 9. What to hand back

Write your verdict to:

**`plans/work-loop-v2-mvp/step-6-finding-c-verdict.md`**

Then tell the operator, in chat, what you concluded in two or three sentences.

Use this structure:

```markdown
## Verdict
Option 1 / Option 2 / Option 3 / other — one sentence saying which and why.

## Reasoning
Why this option, and specifically why the other two are worse. Address the pilot-versus-now
question: is the remaining restatement a real risk to a pilot, or a documentation defect?

## On the reviewer's bar
Is overruling "must be corrected before acceptance" justified here? If you pick option 1, say
whether the freeze timing genuinely makes it riskier than leaving C open.

## On selective application (conflict 2)
Judged trade-off, or inconsistency? Cite what you saw in the artifacts.

## On Claude's measurement
Is the ten-assertion count right? Correct it if not.

## If your verdict is option 2 or 3
State the exact disclosed-limitation wording you would accept, and — for option 2 — the exact
reopening trigger. Claude will copy this verbatim into the limitations list.

## If your verdict is option 1
State the bounded scope: which sections of which files, and which assertions must be rewritten.
The correction must stay inside one pass with a narrow closure check afterward.

## Deferrals
Anything you noticed that is outside finding C. Not findings — deferrals.

## Confidence
High / medium / low, and what would change your mind.
```

---

## 10. Summary of the rules binding you

1. Adjudicate finding C only. No second broad review, no new findings.
2. Do not invoke `$work-loop-v2`; do not open a task-state file.
3. Do not edit any candidate file. Do not run git.
4. Verify the four blob hashes before starting; stop if any differs.
5. Re-derive Claude's ten-assertion measurement rather than trusting it.
6. Judge against the frozen originals (§ 4 items 3, 4, 10), not against conversation.
7. Write the verdict to `step-6-finding-c-verdict.md`.
