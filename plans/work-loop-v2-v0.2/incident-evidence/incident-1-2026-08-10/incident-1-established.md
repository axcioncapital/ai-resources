# Incident 1 — established from preserved evidence

**Route step 1 of the bounded-execution fix plan v0.2 (§ 0.4), incident 1 only.** Discovery unit.
Read-only against both evidence checkouts. No fix, no design, no test construction, no dispatcher run,
no live reproduction, zero nested AI invocations.

**Scope bound.** Incident 2 (`eval-mvp-v0.2-adoption-readiness-fix`, 2026-08-11) was not investigated
and is not referenced below except where the plan already links them. Its hypotheses H7–H10 remain
untouched.

**Classification.** Every material statement is **OBSERVED** (demonstrated by inspection or execution),
**INFERRED**, **PROPOSED**, or **UNKNOWN**, per SOP `:384`.

---

## 1. Evidence preserved, and where

All of it is copied into `plans/work-loop-v2-v0.2/incident-evidence/incident-1-2026-08-10/` in the
**bound** checkout. `MANIFEST.sha256` carries a SHA-256 for every file. Nothing was staged, modified or
committed in either evidence checkout; the incident checkout's three dirty files
(`logs/friction-log.md`, `logs/session-notes.md`, `logs/work-loop/diagnostics-workflow.md`) were read
and left exactly as they were.

| Bundle path | Contents | Prior exposure |
|---|---|---|
| `runs/` | All 15 dispatcher run artifacts for the 5 runs of 2026-08-10 — `.log`, `.hop1.claude.out`, `.hop1.claude.tree` | 12 committed **only on the unmerged branch** `session/2026-08-10-diagnostics-workflow`; 3 untracked in a working tree |
| `state/` | The task state file in three forms: as committed at `9a8399c`, as it stands uncommitted in the worktree, and the diff between them | Uncommitted in a working tree |
| `nested-session/runs/` | **16 nested `claude -p` transcripts** (`.out` + `.err`) and the two exit-code files | **`/private/tmp` only** — volatile |
| `nested-session/*.sh` | The 10 fixture/runner/oracle scripts that launched them | **`/private/tmp` only** — volatile |
| `nested-session/fixtures-inventory.txt` | Shape and size of the fixture trees (inputs, not evidence — not copied) | — |
| `session-transcripts/` | **All 9 Claude session transcripts** from that checkout on 2026-08-10, gzipped | `~/.claude/projects/`, subject to transcript retention |
| `reports/postmortem-2026-08-10.txt` | The 290-line postmortem — **a lead, not proof** (`:435`) | Codex attachment store |

**Two evidence sources were not in the plan's § 0.5 set and are the most exposed.** The 16 nested-run
transcripts and the 10 runner scripts existed only under `/private/tmp/claude-501/…/scratchpad/`, and
the 9 session transcripts only under `~/.claude/projects/`. Both locations are outside git and outside
the `runs/` disposition question in § 8. They are the *only* record of the unsupervised window, and
they are the evidence that corrects the plan's process count. **OBSERVED.**

**A third exposure the plan understated.** § 0.5 flags 3 untracked run files. In fact **none of the 15
incident-1 run artifacts exists on `main`** — the other 12 are committed only on an unmerged branch
(`git ls-tree -r HEAD` on the bound checkout returns zero matches for `20260810T1*`). **OBSERVED.**

---

## 2. What directly happened

All times from the dispatcher run-log clock. Session-transcript timestamps run exactly **60 minutes
behind** that clock; both are internally consistent, so ordering is unaffected. The offset itself is
**UNKNOWN** and is not load-bearing.

| Time | Event | Evidence |
|---|---|---|
| 11:39:20 | Run 1. `exit=0`, 317s, 22 turns, $2.34. → `09e5132`, `turn: codex` | `…113920….log`, `.hop1.claude.out` |
| 11:46:33 | Run 2. `exit=0`, 347s, 25 turns, $2.88. → `574a400`, `turn: codex` | `…114633….log` |
| 11:53:13 | Run 3. `exit=0`, 457s, 19 turns, $3.35. → `4a92e20`, `turn: codex` | `…115313….log` |
| 12:12:46 | **Run 4.** Claude `exit=0`, 392s, 26 turns, $2.76 — **2 permission denials**, both `Edit` on `.claude/commands/resolve-incident.md`. Claude stopped and asked. Dispatcher returned **`STOP [25]`**. **No commit; head unmoved at `4a92e20`** | `…121246….log`, `.hop1.claude.out` |
| 12:25:57 | **Session `94010558` — not dispatcher-launched.** `/work-loop-v2 diagnostics-workflow — resume the open Unit 3 after the attended dispatcher permission stop. The operator explicitly approved acceptEdits for .claude/commands and the bounded commit.` | `session-transcripts/94010558….jsonl.gz` |
| 12:34:16 | Commit `b2950d6` — 16 files. **No dispatcher run** | `git log`; no run log covers it |
| 12:35:46 | **Session `b7614047` — not dispatcher-launched.** `/work-loop-v2 … execute the open Unit 4 exactly from the state file. The operator explicitly approved the two protected command edits. Finish both command bodies, run the full six-case rea[l invocation matrix]` | `session-transcripts/b7614047….jsonl.gz` |
| 13:54:43–14:55:32 | **Session `053f3b80` — not dispatcher-launched.** Builds fixtures and runs **16 nested `claude -p` processes**, every one with `--permission-mode bypassPermissions` | `nested-session/`, transcript |
| 14:33:01 | Commit `ea77d66` — `.claude/commands/resolve-incident.md` **+149**, `resolve-repo-problem.md` **+80**. **No dispatcher run** | `git show ea77d66 --stat` |
| 15:03:13 | Session `7b75c96e` — not dispatcher-launched, 43 events, 93s. Purpose **UNKNOWN** | transcript |
| 15:16:01 | Run 5. `exit=0`, 318s, 17 turns, $2.26 — **1 permission denial**, `Edit` on `.claude/commands/resolve-repo-problem.md`. → `9a8399c`, `turn: codex` | `…151601….log` |

### 2.1 The plan's four cost figures are exact — verified by recomputation

Summing runs 1–4 from the hop captures: **1513 s = 25 m 13 s**, **92 turns**, **108,908 output
tokens**, **$11.3390**. The plan's "25m13s, 92 turns, 108,908 output tokens and $11.34" reproduces to
the digit. **OBSERVED.**

### 2.2 The process count is materially higher than the plan states

| Category | Count | Basis |
|---|---|---|
| Dispatcher-launched hops | 5 | 5 run logs |
| Claude sessions in that checkout **not** dispatcher-launched | 4 | 9 transcripts minus the 5 hop `session_id`s in the hop captures |
| Nested `claude -p` children | **16** | 16 `.out` files + 6 runner scripts |
| **Total observable Claude processes** | **25** | |

The plan (and the postmortem) say "≥13 Claude processes, and probably several more." **The observable
figure is 25.** The postmortem's own hedge at `:107` — "the state file reports eight real invocations
but names ten transcript files … no longer trustworthy" — is confirmed *and* resolvable: the state
file's "eight" is exactly the count in `runs/exits.txt`, which omits `smoke-c1`, the `C4t` transfer
re-run, and the entire 6-run `X*` correction series. **OBSERVED.**

### 2.3 The permission dead end — two gates that disagreed

Run 4's dispatcher allowlist **did** permit the file:
`^\.claude/commands/(resolve-repo-problem|resolve-incident)\.md$` is in its `allow_paths`. The child
was nonetheless launched `--permission-mode default`, and its own permission layer refused the `Edit` —
recorded verbatim in the hop capture's `permission_denials` array. In headless `-p` mode there is no
one to answer the prompt. **OBSERVED.**

Claude's contemporaneous record in the state file at `9a8399c` names the mechanism itself:

> `.claude/commands/` is not writable in this run. The hop was launched headless with
> `--permission-mode default` and did not inherit the checkout's `bypassPermissions`, so the `Edit`
> against `.claude/commands/resolve-repo-problem.md` was refused.

**The dead end was never fixed.** Run 5, after the bypass, hit the same denial class on the other
command file — which is why `9a8399c` records finding 2 as *partial*. It was worked around by hand,
twice, and survived. **OBSERVED.**

### 2.4 The `STOP [25]` report was false in both halves

Run 4's log records `before: sha256=dab76b62…` and `after: sha256=dab76b62…` — **byte-identical**. The
same log's launch preamble records `note: the state file is uncommitted with turn: claude`, so the file
was **already dirty before the hop began**. The stop nevertheless said:

> `STOP [25] Claude edited logs/work-loop/diagnostics-workflow.md but left it uncommitted (hop 1)`

Claude did not edit it, and its uncommitted state pre-dated the hop. This is the plan's § 1 claim 2a
reproduced in live evidence rather than by code reading. **OBSERVED.**

### 2.5 The process-tree census recorded nothing, in every run

All five `.hop1.claude.tree` files are **0 bytes** — including the four runs that succeeded. The
dispatcher's own instrument for observing actor descendants produced no evidence at any point on
2026-08-10. Consequence: nesting is provable *only* from the interactive session's scratchpad, which
the dispatcher never saw. Why the census wrote nothing is **UNKNOWN** and is a code question for the
causal step, not settled here. **OBSERVED.**

### 2.6 The nested runs' cost is permanently unrecoverable

The 6 runner scripts invoke `claude -p` **without** `--output-format json`. All 16 `.out` files are
plain prose. No `num_turns`, `total_cost_usd`, `usage` or `session_id` exists for any of them. The
dominant cost of the incident — 16 processes across ~44 minutes — **cannot be measured, then or now.**
**OBSERVED.**

---

## 3. What remains uncertain

- **UNKNOWN — how run 4 spent its 392 seconds** before the denials. The hop capture holds the final
  result, not a turn-level breakdown; transcript `00eed962` would answer it and was not read to that
  depth in this unit.
- **UNKNOWN — the cost, turn count and duration of all 16 nested runs, and of the 4 non-dispatcher
  sessions.** Not recorded (§ 2.6). No later analysis can recover it.
- **UNKNOWN — why every `.tree` census wrote 0 bytes.** A `dispatch.sh` question.
- **UNKNOWN — the purpose of session `7b75c96e`** (15:03, 93s).
- **UNKNOWN — whether the 16 fixture runs ever wrote into the real checkout.** The state file asserts
  zero reached it (`:117`); the fixture trees survive and this was **not** re-verified here.
- **UNKNOWN — the 60-minute clock offset** between run logs and session transcripts.
- **INFERRED, not established — that the operator's approvals in the two bypass prompts were given at
  the moment the prompts state.** The prompt text is OBSERVED; the approval conversation is not in
  these transcripts.

---

## 4. Which proposed explanation the evidence supports or contradicts

Against § 0.6's incident-1 hypotheses. **These verdicts are evidence-fit judgments from the discovery
unit, not the causal model** — building that is route step 3, and challenging it is step 4.

| # | Hypothesis | Verdict | Basis |
|---|---|---|---|
| **H1** | The cost had two mechanisms — unbounded nesting **and** the interactive bypass | **SUPPORTED** | Both observed and separable: 16 nested children (§ 2.2) inside 4 unsupervised sessions (§ 2, escape window) |
| **H2** | The bypass had **one** cause: the dispatcher reported the wrong thing, and the right thing was unavailable | **CONTRADICTED AS STATED** | Two distinct triggers are observable, and the misreport is the *weaker* one. The permission dead end (§ 2.3) blocked the work; the false `STOP [25]` (§ 2.4) misdescribed it. The bypass prompt names the permission grant — "the operator explicitly approved acceptEdits for `.claude/commands`" — and not the misreport. "One cause" does not survive; both halves do, ranked the other way |
| **H3** | The trigger was a brief demanding behavioural verification of Markdown instruction files, satisfiable only by invoking Claude | **STRONGLY SUPPORTED** | The brief's own floor: "a file-content quote or presence grep is never sufficient … exercise the real invocation path" and "Behavioral evidence must come from actual command invocations against the candidate command bodies". The artifacts under test *are* Claude command files, so the only execution path is `claude -p`. The brief mandated nesting |
| **H4** | Nesting turned one unit into ≥13 Claude processes | **SUPPORTED, AND THE FIGURE IS LOW** | 25 observable (§ 2.2) |
| **H5** | A precise stop removes the *reason* to reach for an interactive session | **NOT SUPPORTED BY THIS EVIDENCE** | The reason in evidence is the permission refusal, which an accurate stop would have *described* better without changing what the child could do. Run 5 proves the point: back on the dispatcher, correctly reported, the same denial recurred and the same handwork followed |
| **H6** | Fixing the mechanisms without the cause leaves the temptation under a new prohibition | **UNTESTED** | Forward-looking; no 2026-08-10 evidence bears on it |

**The § 0.6 disproof condition for H1/H4 did not fire.** It asked for evidence that the cost came from
one long session rather than nested invocations. The opposite is observed: 16 discrete nested processes
across 6 runner scripts. **H1 and H4 stand.**

**H2's demotion is the finding with teeth.** § 0.6's supersession rule binds H2 to outcomes **O2 and
O3**. Those rest on a "one cause" framing the evidence does not carry, so under the plan's own rule
they are **reopened, not patched**. What the evidence supports instead is a permission-model conflict:
the dispatcher's path allowlist and the child's `--permission-mode default` are separate gates that can
disagree, and when they do the run deadlocks with no in-band way to resolve it. That is a different
target from "the stop message was imprecise", and it is not currently any outcome's subject.

---

## 5. Raw evidence a fresh Codex session should review

For the SOP B3 blind review (route step 2). **Hand over § 1's bundle and the list below — not this
file, not either plan, and not § 2 or § 4 above**, which carry a reading of the evidence. `:459` fails
the control if the reviewer can reach a diagnosis through anything pasted in.

Ranked by what it settles:

1. **`runs/20260810T121246-8db95197-7178-diagnostics-workflow.log`** and its **`.hop1.claude.out`** —
   the `STOP [25]`, the identical before/after hashes, and the two `permission_denials` entries. One
   file pair carries both the dead end and the false report.
2. **`session-transcripts/94010558….jsonl.gz`, `b7614047….jsonl.gz`, `053f3b80….jsonl.gz`** — the three
   unsupervised sessions, in order. `053f3b80` is the one that ran the nested farm.
3. **`nested-session/runs/` (16 `.out`/`.err`) and `nested-session/*.sh`** — the nested invocations and
   the scripts that launched them, including the `--permission-mode bypassPermissions` line.
4. **`state/diagnostics-workflow.state-file.at-9a8399c.md`** — Claude's contemporaneous blocker record;
   and the **`.uncommitted.diff`**, which is the later handback.
5. **The five `.tree` files** — 0 bytes each; the absence is the evidence.
6. **`git log` / `git show --stat` for `b2950d6` and `ea77d66`** in
   `../ai-resources-diagnostics-workflow` — two commits no run log accounts for.
7. **`runs/*.log` for runs 1, 2, 3, 5** — the normal-operation baseline the failure is read against.
8. **`reports/postmortem-2026-08-10.txt`** — **last, and as a lead only.** It contains a diagnosis; a
   reviewer who reads it first is no longer blind. Withhold it from the B3 reviewer entirely if the
   blind reading is to hold.

**Questions the evidence can answer that this unit did not ask:** what run 4 did with its 392 seconds;
whether any fixture write escaped into the real checkout; and why `actor_tree_census` produced nothing.

---

## 6. Status

**Gate 2 (failure proof) — incident 1 half: met by the forensic route** (`:382`), reproduction being
neither safe nor informative here. Incident 2's half is **not** met and was not attempted.

The case outcome is unchanged: **Proceed — structural resolution**, provisional. Nothing here closes a
gate, approves a design, or authorises an implementation. Route step 2 (blind Codex review) is next.
