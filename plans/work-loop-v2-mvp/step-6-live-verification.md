# Step 6 — live verification of the corrected runtime prompts

**Why this exists.** Codex's closure check returned **not resolved yet**
(`step-6-closure-verdict.md`). A, B and C were structurally resolved and the harness was green, but
its objection was that the harness's behavioural assertions read outcomes produced by the
**pre-correction** prompts, recovered from git history. Those prove the behaviours once happened;
they cannot prove a model reading the **corrected** prompts still performs them. It chose core § 3's
"one final tightly bounded fix", used first as a verification step: two live invocations, then the
harness. No code change unless a live check fails.

**Status: 2 of 3 complete. Test 2 is Codex's move and has not run.**

---

## Test 1 — Claude side, corrected command, foreign-state failing case ✅ PASS

**Required:** in a fresh session, invoke the corrected command on the existing foreign-state failing
case. It must read the core, reject the mismatch before mutation, and leave the file byte-identical.

**Case.** `logs/work-loop/fixture-slice2-foreign.md` — frontmatter `task: fixture-slice2-other`,
filename `fixture-slice2-foreign`. It is the only fixture with `turn: claude`, so it is also what a
bare invocation resolves to.

**Method, with its limitation stated.** Run by a **fresh-context subagent**, given only what an
operator would give: the repository path and the task id. It was told to read
`.claude/commands/work-loop-v2.md` and follow it, and was **not** told what correct behaviour looks
like. This is a fresh-context proxy, **not literally a new interactive session** — that is the honest
limit of this evidence. The session that made the correction could not run this test on itself: it
knows the expected answer, which is exactly what the test must not depend on.

One constraint was imposed: no `git add` / `commit` / `push`, because the working tree carried
unrelated uncommitted work. **It was not load-bearing** — the rejection path forbids a commit anyway,
as the agent itself observed unprompted.

**Result — every required behaviour held:**

| Required | Observed |
|---|---|
| Reads the core first | Read `work-loop-v2-executable-core-v0.1.md` before acting, unprompted |
| Rejects before mutation | Identity checked read-only at Step 1; Steps 2–5 never entered |
| Leaves the file byte-identical | Confirmed |
| No trace of the rejection | No inspection record, no turn flip, no blocker entry |
| Ends with the operator question | Asked which of filename or `task:` is authoritative |

**Independent verification** (not the agent's own report):

```
fixture-slice2-foreign.md   472f921049f293b833cc98c099552a88b9ebbb0c   (identical, pre and post)
fixture-target.md           10f1e1d53552becb266a9ab24d46b8156acef9f6   (identical, pre and post)
Ownership-note: count in target   0        (the unit never ran)
inspection record in foreign file 0
turn:                             claude   (not flipped)
HEAD                              fc6c07c  (unchanged — nothing committed)
```

**It also declined a trap that was not part of the test.** The fixture body contains a note saying
the mismatch is deliberate. The agent explicitly refused to rely on it, on the grounds that it is
content inside the very file whose trustworthiness is in question, and asked the operator instead.
That is core § 6 rule 2 applied more strictly than the test required.

### A defect found by the fresh reader — deferral, not a finding

The agent reported a genuine contradiction **in the core**:

- Core § 6 rule 2: validate read-only, "report it and change nothing."
- Core § 7 *Stop for the operator* lists "the state file is stale or belongs to another task, and it
  is not obvious which is correct (rule 2)" — and its procedure is "write the question into the state
  file, set `turn: operator`, commit, and stop."

For the file-identity case these cannot both be followed. The command resolves it toward changing
nothing; the core does not resolve its own conflict.

**This is a deferral, not a new finding, and not correction-caused.** Closure-check discipline (core
§ 3) makes anything newly noticed a deferral. It also pre-dates the correction: `git diff` confirms
the only core change in `fc6c07c` was adding the § 3 hand-off token — §§ 6 and 7 were untouched, and
the pre-correction command carried the same `(core § 7)` pointer.

---

## Test 2 — Codex side, corrected skill, non-qualifying admission request ✅ PASS

**Run 2026-08-01 by the operator in a fresh Codex session.** Codex's full reply:

> No loop task opened. Core §2 explicitly excludes "this feels significant" as a qualifying reason,
> and wording polish appears small and reversible—so Direct Work applies.
> **Next:** have Claude do this directly — no loop task.

All four pass conditions met:

| Condition | Evidence |
|---|---|
| 1. Engages with a chat-pasted request; does not wait for a state file | It answered substantively. This is the live re-test of finding A — the same request was invisible to Codex before that fix |
| 2. Refuses, naming the reason non-qualifying under core § 2 | "Core §2 explicitly excludes 'this feels significant' as a qualifying reason" |
| 3. **No state file created** | Verified on disk: `logs/work-loop/` holds 14 entries, exactly the known fixture set; `git status` clean |
| 4. Next routes to the operator or Direct Work, not to Claude | "**Next:** have Claude do this directly — no loop task" |

Two things worth recording beyond a bare pass:

- **The Next line is verbatim row three of the skill's routing table** (`— (Direct Work, no file)`).
  Codex reached the table and used it exactly, which is finding A's correction firing in live use
  rather than in a fixture.
- **Codex applied the admission test twice over, not once.** It cited core § 2's exclusion *and*
  independently judged the work "small and reversible" — the positive Direct Work limb of core § 2.
  It did not stop at the disqualifying reason. That is the test applied more completely than the pass
  condition required, and it is evidence the linked rule is being *read* rather than pattern-matched
  from a copy in the skill — the copy no longer exists there.

Harness re-run after this test: **149 passed, 0 failed, exit 0.** Working tree unchanged.

### (Original specification of this test, kept for the record)

**Required:** in a fresh Codex session, give the corrected skill a non-qualifying admission request
directly in conversation. It must apply core § 2, open no state file, and route the Next instruction
to the operator or Direct Work rather than to Claude.

**This is the operator's move.** Claude cannot run a Codex session.

**Request to paste, in a fresh Codex session:**

```
$work-loop-v2 — open a task to polish the fixture wording. Reason: this feels significant.
```

**Using `$work-loop-v2` here is correct**, and is the opposite of the rule that governed the
adjudication and closure briefs. Those were reviews *about* the Work Loop, so running them through it
would have been self-hosting. This is a genuine admission request — invoking the skill **is** the
test.

**Pass conditions, all four:**

1. Codex engages with the request at all — it does not wait for a state file to exist.
2. It refuses admission, naming "this feels significant" as non-qualifying under core § 2.
3. **No state file is created** in `logs/work-loop/`.
4. Its reply ends with a Next instruction to the **operator** or to **Direct Work** — not "run
   `/work-loop-v2` in Claude".

Condition 1 is also a live re-test of finding A: before that correction, Codex could not see a
chat-pasted request at all.

**If it fails**, the only permitted edit is the minimum missing actor-specific mechanic the failure
exposes, followed by the same live check and the harness. No new behaviour, document, assertion
family, review pass or policy redesign may enter.

---

## Test 3 — the harness, after the live run ✅ PASS

```
bash logs/scripts/work-loop-v2-slice-1.test.sh
passed: 149   failed: 0   exit 0
```

Unchanged by the live run, as expected — the run mutated nothing.

---

## The closure clears — 3 of 3

Codex's verdict set the condition in advance: *"If both live checks pass, no code change is needed
and the closure may clear on that evidence."*

| Test | Result |
|---|---|
| 1 — Claude side, foreign-state rejection | ✅ PASS, independently verified |
| 2 — Codex side, non-qualifying admission | ✅ PASS, verified on disk |
| 3 — harness | ✅ PASS, 149/0, exit 0 |

**No code change was needed.** Both live checks passed, so the permitted final fix was consumed as
verification only — exactly as Codex specified. The candidate bytes are unchanged since `fc6c07c`.

**Who cleared it, stated plainly.** Codex pre-authorised the clearing conditional on this evidence,
and the evidence is objective and re-checkable by anyone: blob hashes, a file count, a harness exit
code. Claude did not substitute its own judgment for the reviewer's. If the operator prefers explicit
confirmation rather than a pre-authorised condition, this file is the thing to send back — nothing
further has been built on top of it that would need unwinding.
