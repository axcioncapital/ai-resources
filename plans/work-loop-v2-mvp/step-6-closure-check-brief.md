# Step 6 — closure-check brief

**For:** Codex, as the reviewer who froze findings A, B and C.
**Written by:** Claude, session S10-7e5, 2026-08-01, after making the correction.

This is the **closure check**, the last step of the one permitted correction round. It is deliberately
narrow. Read this file before opening anything else.

---

## 1. The only two questions you are answering

Core § 3 fixes them, and they are the whole scope:

> **1. Are findings A, B and C resolved?**
> **2. Did the correction break something?**

Nothing else. This is **not** a second review — the mission's non-negotiables forbid one, and so does
the brief that governed your first pass. **Anything you newly notice becomes a deferral, recorded in
your hand-back. It never becomes a second correction round.**

If the correction is not enough, core § 3 gives you a menu — accept a written limitation, permit one
final tightly-bounded fix, revert, reframe, or stop. Choose **once**, on value and risk. If the choice
is really about accepting risk, it goes to the operator rather than to you.

**Do not fix anything.** You judge; Claude corrects. **Do not run git** — Claude commits. **Do not
invoke `$work-loop-v2`** and do not open a task-state file: this governs the Work Loop, so running it
through the Work Loop is self-hosting, forbidden by Proposal § 6.

---

## 2. Verify the bytes first

Approval attaches to bytes, never to a name. Check with `git hash-object <path>`:

| File | Lines | Blob hash |
|---|---|---|
| `.claude/commands/work-loop-v2.md` | 113 | `82ff6ebb79ccd63b28407298118ac964eef3dba1` |
| `.agents/skills/work-loop-v2/SKILL.md` | 116 | `7eb64cb851756d81ad9dd1041a1ee7e93dc06918` |
| `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` | 293 | `4790ede0ff1d4939e7320bc800e0fb8b351fbb06` |
| `logs/scripts/work-loop-v2-slice-1.test.sh` | 673 | `19ede0ec380658eba516492d131747b1889ca70a` |

If any hash differs, stop and say so — you are not looking at the corrected candidate.

---

## 3. What changed, so you can check it rather than rediscover it

**Finding C** — you ruled option 1 (`step-6-finding-c-verdict.md`). Applied as follows:

- Restated core policy removed from both runtime artifacts and replaced with links to the owning core
  sections. Actor-specific mechanics kept: task-id resolution, the inspection-record and
  result/evidence shapes, the read-only rejection mechanics, the closing-record template, the
  Next-routing table, the no-git boundary.
- The shared hand-off token `Correct once — frozen findings:` is now named **once**, in core § 3
  ("The hand-off token"). Both artifacts reference it and neither re-spells it. This is the single
  core edit your verdict authorised, taken to avoid an orphaned interface.
- Both runtime artifacts got shorter: 114 → 113 and 120 → 116.

**Your measurement correction was applied.** You were right that the surface is 11 positive
policy-wording locks (14 with the three section-presence form locks), not Claude's ten — line 213
routes through the `step1_of` helper and Claude's grep filter missed it. Verified by explicit line
read before editing.

**Findings A and B were not touched, and were verified to survive:**

- A — all six markers present in the skill: direct operator intake before a file exists, the
  three-case Next-routing table, the `logs/work-loop/` rule, and the no-git boundary.
- B — the closed-set state-file check (`KNOWN_WORKLOOP_FILES` / `unexpected_worklog_files`) is
  untouched in the harness.

---

## 4. The regression instrument, and the falsifiability evidence

```bash
bash logs/scripts/work-loop-v2-slice-1.test.sh    # from the repo root
```

**Expected: 149 passed, 0 failed, exit 0** (was 143 before the correction).

You required that the harness not be made green by deleting checks. Three proof runs were performed,
with the artifacts restored from a checksummed copy after each:

| Proof run | Red assertions |
|---|---|
| New harness vs. **pre-correction** artifacts | 8 — the restatement and token-duplication checks |
| Core links and retained mechanics stripped out | 8 — the link and mechanic checks |
| Targeted removal of the read-only rejection mechanic | 1 |

**17 of 17 new or rewritten assertions are proven failing-capable.** You are welcome to re-run any of
these yourself; the method is to mutate, run, and restore.

The rewritten assertions test three things instead of wording: that each artifact still **links** the
owning core section, that it does **not** re-state the rule, and that its **actor-specific mechanics**
survive. The negative checks are the load-bearing half — a link check alone does not discriminate,
because the pre-correction artifacts also cited "core § 2" while restating it underneath.

---

## 5. Worth your attention specifically

Three places where the correction made a judgement you may disagree with. Named here so you check them
deliberately rather than stumble on them:

1. **Trigger conditions were linked, not restated.** Your own deferral flagged the tension between
   "never restate the core" and the standard's requirement that stop conditions name their on-stop
   behaviour. The boundary used: link the trigger, keep the actor's on-stop mechanics. This is why the
   command no longer says "a small, reversible fix" and the skill no longer says "smaller than
   assumed". If you judge that a reader now cannot tell *when* to act without opening the core, say so
   — the mandatory core read is the assumption being leaned on.
2. **Three section-presence locks were kept, not deleted.** Lines requiring the Admission and
   De-escalating sections to exist. Rationale: after C, those sections still hold real actor mechanics,
   so their presence is an interface fact rather than a policy copy. You listed them in the correction
   surface, so confirm that keeping them is what you meant.
3. **The core grew by 11 lines.** Your verdict permitted exactly one shared-token edit. Confirm the
   edit stayed within that permission and changed no policy.

---

## 6. What to hand back

Write to **`plans/work-loop-v2-mvp/step-6-closure-verdict.md`**, then tell the operator in two or
three sentences. Structure:

```markdown
## Closure verdict
Resolved / Not resolved — one sentence.

## A — resolved?
## B — resolved?
## C — resolved?
One short paragraph each, citing what you checked.

## Did the correction break anything?
Regressions only. State whether you ran the harness and what it returned.

## If not resolved
Your single choice from core § 3's menu, with its value-and-risk ground. If the choice is really
about accepting risk, say that it belongs to the operator instead of choosing.

## Deferrals
Anything newly noticed. Not findings — deferrals.

## Accepted limitations to carry into the pilot
Confirm or amend: known limitations 3, 4 and 5 from `step-6-candidate-review.md` § 7, plus your own
deferral on the writing standard's stop-condition tension.
```

Once this check clears, Claude records the accepted commit and its four blob hashes, writes the
disclosed-limitations list, ticks the mission's Step 6 thread and commits. **Step 6 is not complete
and the thread is deliberately not ticked until then.**
