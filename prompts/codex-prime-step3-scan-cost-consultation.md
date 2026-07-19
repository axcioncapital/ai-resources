# Consultation brief for Codex — an orientation scan that costs 12k tokens/session and resists every obvious fix

**Written:** 2026-07-19 · **Author:** Claude (Opus 4.8), session S2-04b
**Status:** open problem. One attempt built, tested, and rejected at review. We want ideas, not code.
**Repo:** `~/Claude Code/Axcion AI Repo/` · **File in question:** `ai-resources/.claude/commands/prime.md`, Step 3 (lines ~200–226)

---

## What you're being asked

We are stuck on a constrained-optimisation problem with an awkward shape. **We are not asking you to implement anything.** We want your read on the bind and whatever approaches we haven't thought of. If your conclusion is "the framing is wrong" or "this isn't worth solving," say that — it's a live possibility and one we'd rather hear now.

---

## The system, in brief

This is a personal AI-agent workspace, not a software product. It's a git monorepo of markdown: a workspace root, a shared resource library (`ai-resources/`), and ~25 project sub-repos.

Slash commands are **markdown instruction files**, not programs. `/prime` is the session-orientation command: it runs at the start of every working session, reads state, and prints a short task menu. Its instructions are read **in full, by the model, on every invocation** — the file is 760 lines today.

`prime.md` is distributed by **symlink**: one canonical copy in `ai-resources/.claude/commands/`, symlinked into 25 project `.claude/commands/` directories. Edit canonical → all 25 update atomically. (28 paths carry the name; 25 are symlinks, 1 is canonical, and 2 are unrelated 33-line stubs with no Step 3.)

Step 3's job: scan `logs/improvement-log.md` — an append-only backlog of improvement items — and surface **unresolved HIGH-severity items** as candidates for the session task menu. Each project has its own `improvement-log.md`; 19 exist.

---

## The problem, measured

Step 3 currently issues this (verbatim from `prime.md:206`):

```
Bash(grep -nE -B6 "^-? ?\*\*Severity:\*\* *(high|HIGH|medium-high|critical|urgent)" logs/improvement-log.md)
```

…plus a second grep against a different log, and a third inline `python3 -c` that counts entries lacking a `Severity` field. The model is then instructed, in prose, to filter the returned lines in-context — dropping anything resolved, low, or medium.

**Measured today, by running it:**

| | |
|---|---|
| Output of that one grep, canonical log | **247 lines / 56,508 chars** (~12k tokens) |
| The command's own stated budget | **< 40 lines** (5.6× over) |
| Log size | 111 entries / 1,419 lines |
| Frequency | every session start, every project |

> **If you re-run this, you will get a bigger number than the table, and that is expected.** The figures above were taken at 11:05 on 2026-07-19. The log is append-only and grew during the same session — by 13:00 the identical command returned **263 lines / 58,267 chars**, because two backlog entries about this very problem were added to it. This is not measurement noise; it is the defect's defining property. **The cost grows monotonically and the scan has no upper bound.** Any proposal whose saving is a fixed subtraction, rather than something that bounds growth, buys time rather than fixing the problem.

Entry shape:

```markdown
### 2026-07-14 — Some finding title
- **Status:** logged (pending)
- **Severity:** medium-high — rationale prose runs on for a while…
- **Category:** …
```

`-B6` exists to drag each severity hit's **header and status lines** back with it, so the model can filter without a second read. That's why the output is ~7 lines per hit.

---

## Everything already ruled out, and why

This is the important section. Each of these was tried or explicitly foreclosed, and re-proposing one without new information isn't useful.

**1. Narrow the `-B6` context window.** Forbidden by the file's own note at `:217`: at `-B4` the header is lost on entries whose status runs to multiple lines, so hits become unattributable. Verified reasoning, not superstition.

**2. Drain the backlog so there's less to scan.** Already done. 0 resolved-but-unarchived entries remain. The log is *correctly* full — these are real open items. Draining is exhausted as a lever.

**3. Just `Read` the file instead.** Explicitly prohibited at `:201`. A full read of this file plus a sibling cost ~50–60k tokens per orientation and was the single most expensive recurring leak in the system; it was fixed on 2026-07-13 and the prohibition is load-bearing.

**4. Widen the severity pattern to catch more entries.** Wrong direction — see `:220`, which argues (correctly) that surfacing *unclassified* entries makes the task menu worse while multiplying cost.

**5. Replace the grep with an embedded parser.** **This is what we built, and it was rejected. Details below — read this one before proposing anything.**

---

## The attempt that failed, and the exact reason

We wrote a ~172-line Python parser to embed in Step 3 as a quoted heredoc. It parses entries, normalises the free-text severity vocabulary, applies the filter **in code** instead of in the model's head, and prints one compact line per unresolved-HIGH item plus a census of what it suppressed.

It worked, and it was well tested — 9-case fixture with expectations written down *before* running, edge cases covered (struck-through superseded status lines, bolded `**high**` values, un-dashed field variants, the file's own schema block, missing files). On the canonical log: **247 lines → 26 lines, 56,508 chars → 3,330.** A 94% cut, comfortably under budget.

**It was rejected at review, on a dimension nobody involved had measured.**

The parser is **172 lines / 7,396 chars**, replacing a **13-line / 787-char** block — inside a file that is read *in full* at every invocation. So the fix adds ~6,600 chars of permanent, per-session, per-project static cost to buy a runtime saving.

That trade is only positive where the log is large. Run across all 19 real `improvement-log.md` files:

- **3 large logs** (247, 149, 47 lines of scan output) — big win.
- **16 small logs**, most emitting **0 lines** today — the static cost is pure loss.
- **Net: total Step-3 cost goes UP in 13 of 19 project directories.**

Three independent reviewers — the design session, an architectural advisor, and the originating backlog item — all reasoned exclusively about *emitted output* and missed this. It was caught only by a reviewer instructed to re-derive every claim rather than accept any.

---

## The structural bind, stated plainly

Cost has two components and they pull against each other:

```
total per session = static weight of the instructions
                  + runtime output of the scan
```

Anything that makes the scan smarter **by adding instructions** pays static cost on every session in all 19 projects, including the 16 where there was nothing to save. Anything that stays small can't be much smarter than a grep.

Two further wrinkles worth knowing:

- **The stated budget is written purely in output terms** (`< 40 lines`). If the real cost is `static + dynamic`, the budget measures the wrong quantity — and every future optimisation will be argued against the wrong metric. We suspect this is the deeper defect, but haven't acted on it.
- **The distribution is extremely skewed.** One log carries 111 entries; most carry a handful. A single fixed strategy has to serve both ends, or the strategy has to vary by log — and "varies by log" itself costs instructions.

---

## Three real defects in the current implementation, independent of the cost problem

Any redesign should be aware of these; they may also be fixable *without* one.

1. **Two genuinely HIGH entries are invisible to every session in every project.** They write `- **Severity:** **high**` (the value in bold). The anchor expects `high` immediately after the space, sees `**high**`, and never matches. Cross-check: the parser finds 33 high-tier entries; `grep -c` on the live anchor returns 31; bolded-value entries number 2; 31 + 2 = 33.
2. **The inline `python3 -c` at `:210` calls `open()` with no guard.** It tracebacks wherever no `improvement-log.md` exists — 10 of the 28 consumer directories. The grep beside it degrades silently; this doesn't.
3. **The scan returns zero in 13 of 19 project logs** — not because those backlogs are empty, but because those logs never adopted the `Severity` field the anchor requires. The urgent-item channel is silently dead across most of the workspace and nobody noticed until this week. A zero-hit scan is indistinguishable from "nothing wrong."

---

## Environment constraints (these have bitten us before)

- Shell commands run under **zsh** on **macOS** — BSD `sed`/`date`, not GNU. Two logged incidents in this exact file: an unmatched glob crashing under zsh's `NOMATCH`, and `path` being a tied parameter that clobbers `$PATH`.
- An embedded heredoc containing `$` must be quoted (`<<'PY'`), or zsh interpolates it.
- The repo has a strong cultural rule against **safeguards that cannot fail**. Our own first attempt shipped a self-check that summed the same counters it had just incremented — structurally incapable of firing. We caught it, but only by explicitly trying to make it fire. If you propose a guard, assume you'll be asked to demonstrate it firing.
- Solutions requiring new install steps, hook registration, or per-project wiring are viable but expensive: hook *wiring* here is unversioned and a known open problem, so anything depending on it inherits that.

---

## What we'd value from you

Ranked, roughly:

1. **Approaches we've missed.** Especially ones that escape the static-vs-runtime tradeoff rather than trading within it.
2. **A view on the metric.** Is `static + dynamic` the right cost model? If so, what should the budget actually say, given the scan runs in 19 places with wildly different log sizes?
3. **Whether the three defects above should be split off** and fixed narrowly — small enough to escape the static-cost objection — leaving the cost problem for later. We lean this way but haven't committed.
4. **A "don't bother" verdict, if that's your read.** 12k tokens/session is real but not fatal, and this problem has now consumed two sessions. If the honest answer is that the cheapest fix is to shrink the *log* rather than the *scan*, or to accept the cost, say so.

Assume the reader is technical but that the repo's conventions are unfamiliar — explain your reasoning rather than just naming a solution.

---

## Where to look

| What | Path |
|---|---|
| The command, Step 3 | `ai-resources/.claude/commands/prime.md:200-226` |
| The log being scanned | `ai-resources/logs/improvement-log.md` (111 entries) |
| A schema-less project log, for contrast | `projects/axcion-brand-book/logs/improvement-log.md` |
| Full rejection rationale, 7 scored dimensions | `ai-resources/audits/risk-checks/2026-07-19-proposed-change-replace-prime-step-3-s-improvement-log-scan.md` |
| Architectural advisory on the rejected design | `projects/axcion-ai-system-owner/output/consultations/consult-2026-07-19-prime-step3-emit-redesign.md` |
| The backlog item, and the follow-ups filed | `ai-resources/logs/improvement-log.md`, entries dated 2026-07-19 |
| Rejected prototype + fixtures | session scratchpad, `scan3-v3.py` (retained for reference — **do not ship as-is; it is the 172-line version that failed on size**) |

To reproduce the headline number:

```bash
cd ai-resources
grep -nE -B6 "^-? ?\*\*Severity:\*\* *(high|HIGH|medium-high|critical|urgent)" logs/improvement-log.md | wc -lc
```
