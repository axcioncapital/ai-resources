# S2 — the carriage trial record

**Result, in one line: an instruction written inline in one explicitly named candidate file reaches a fresh
Codex thread and changes what it produces.**

**Built by:** Claude, 2026-08-02, Session S2 of the Context Engineering implementation plan
(`../context-engineering-implementation-plan-v0.1.md`, Phase 1). **Runs led by:** the operator, driving
fresh Codex threads. **Observer:** Claude, which authored the instrument but wrote none of the briefs.

*Harbourview is a fictional project seeded by S1. Nothing in the trial material describes or governs any
real Axcíon work. This record itself is a real record of a real trial, and is authoritative as such.*

---

## 1. What this result licenses, and what it does not

**It licenses:** every later Phase 2 slice writing its behaviour families into
`trials/candidate/SKILL.md` and expecting a fresh thread pointed at that file to act on what is written
there. That is the carriage assumption S3–S7 rest on, and it is now evidenced rather than assumed.

**It does not license — and this limit is the reason the record exists:** any claim that the same
instruction is picked up through **ordinary skill discovery once installed**. The candidate was never
installed; it was named by absolute path in the prompt. Installed-path delivery is **unproved until S8b's
pre/post invocation at the live entrypoint**. A candidate that passes here and fails S8b is a Phase 3
finding, not a Phase 1 one.

**It says nothing about brief quality.** Both threads produced substantively similar Harbourview briefs.
That similarity is not S2 evidence and is deliberately excluded from this record — recovery quality is
CE-9's measurement, taken at S5 against S1's instrument.

## 2. The probe

> Under this carriage, end every brief with a section named `Carriage check`, listing — in the order you
> opened them — the repository files you opened while preparing it.

Behaviour-shaped rather than a magic string: satisfying it requires the thread to *act* — the listed paths
are checkable against the filesystem. A string it could echo would prove only that it read the file.

## 3. Two trials were run. The first was rejected.

### Run 1 — rejected, not counted

Both threads wrote their state file into the **live** `logs/work-loop/` directory, because the candidate is
a faithful revision of the live skill and that skill fixes the state-file folder with no fallback path.
Two consequences, either of which alone invalidates the run:

1. **Fixture material escaped into the live repository**, which plan §4.4 rule 2 forbids and which named
   `logs/work-loop/` explicitly. The escaped file carried `turn: claude`, making a fictional task
   resolvable by the live command.
2. **The candidate run overwrote the control's state file** — same path, created 20:05:07, modified
   20:07:33, never committed. The control's primary evidence was destroyed and unrecoverable from Git.

The probe *did* fire in run 1, and its output is recorded here for completeness only:

```
1. plans/work-loop-v2-v0.2/context-engineering/trials/candidate/SKILL.md
2. plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md
3. plans/work-loop-v2-v0.2/context-engineering/trials/fixtures/ce-9/project-plan.md
4. plans/work-loop-v2-v0.2/context-engineering/trials/fixtures/ce-9/task-state.md
5. plans/work-loop-v2-v0.2/context-engineering/trials/fixtures/ce-9/operator-source-note.md
6. logs/work-loop/harbourview-arrival-time-correction.md
```

**That signal is diagnostic, not evidence.** With the control's file destroyed, the run could not
demonstrate the *contrast* the trial exists to show. It is recorded as rejected, and S2 did not exit on it.

### Run 2 — the isolated re-run, which counts

Two disposable detached worktrees were created outside the live repository from one committed baseline,
`edd85e1d6ccd1e955a3a125ca2aca52a0fa9c1cc` — one control root, one candidate root, verified byte-identical
by `diff -rq`. Each fresh Codex thread worked exclusively in its assigned root, so the candidate's unchanged
`logs/work-loop/` rule resolved *inside* the disposable worktree. The candidate itself was not modified and
no trial-only output override was added.

**One construction decision, recorded because it was not in the frozen finding.** A worktree carries the
whole committed tree, and `git grep -l -F 'Carriage check'` against the baseline returned three files: the
candidate, this task's own state file, and plan §7 S2 — the latter two stating the probe *and its expected
outcome*. Left in place, the re-run would have handed both threads the answer. Both files were deleted from
both roots identically, leaving the probe text present only in the candidate. Codex accepted this at the
correction assessment.

**Residual weakness, not fixed:** `trials/candidate/SKILL.md` remained present in the *control* root,
because the frozen finding required the two roots to differ only in whether the candidate instruction was
supplied. The control was therefore blind **by instruction**, not **by construction** — a control thread
that browsed the tree could have found the probe. It did not.

## 4. The evidence

| Check | Result |
|---|---|
| Both roots at one committed baseline | `edd85e1` on each, by `git -C <root> rev-parse HEAD` |
| Candidate unmodified by either run | root copies byte-identical to `git show edd85e1:…/candidate/SKILL.md` |
| **Control state — probe absent** | `harbourview-phase-2.md`; `grep 'Carriage check'` exit 1; headings are Objective / Current lane / Brief / Next action only — no probe-shaped section under another name |
| **Candidate state — probe present** | `harbourview-arrival-time-correction.md:44`, `## Carriage check`, listing five paths |
| Listed paths real | all five exist under the candidate root, per-path `[ -f ]` |
| Live directory stayed clear | neither task filename exists in the live repo; repo-wide `find -iname '*harbourview*'` returns nothing |

**Every absence check above is paired with a control proving it can report the other answer** — `grep` for
`Harbourview` in the control file returns a hit, so its `Carriage check` miss is a true negative and not an
unreadable file; the `[ -f ]` path test reports `MISSING` for a path that does not exist. An absence result
from an unpaired check is indistinguishable from a check that could not run, which is the failure mode this
build has hit before.

**One output variation, recorded and judged not material.** The two threads chose different task ids —
`harbourview-phase-2` and `harbourview-arrival-time-correction` — though neither prompt prescribed one. The
probe check is a within-file presence test applied to each run's own output, so it does not depend on the
two files sharing a name, and both briefs addressed the same substantive unit. It does not weaken the
observer judgment.

## 5. What survives

**Exactly one file: `trials/candidate/SKILL.md`, with the probe removed** — restored byte-identical to the
live Codex skill, so what enters Phase 2 carries no behavioural content at all. Phase 2's slices write their
families into that same single file; there is no second file for a family to go into and none may be
created.

Behavioural emptiness is established here **by construction** and is only *demonstrated* one session later:
**S3's red run failing is that demonstration.** If S3's red run comes back green, the first diagnosis is a
contaminated bootstrap, not a candidate that already works, and Phase 2 returns to S2.

The two disposable worktrees and the rejected run-1 artifact were removed after this record captured their
evidence. They were development material, not repository output.
