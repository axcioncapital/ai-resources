# Decision Journal

> Archive: [decisions-archive-2026-05.md](decisions-archive-2026-05.md)

## 2026-05-22 — /prime redesign: slim brief + numbered task menu + session-start chaining

**Context.** The operator (a non-developer) reported `/prime`'s start-of-session brief was too dense — ~15–20 status-field lines in terse log shorthand, hard to scan and hard to understand. Request: shorter, plain-English, project-scoped, ending in a numbered 1–3 task menu where typing a number auto-runs the session-setup commands. Scoped via `/clarify` (4 questions) and an approved plan.

**Decisions.**
1. **Number flow — run both, then pause.** Typing 1–3 runs `/session-start` then `/session-plan`, shows the plan, and pauses for review. Not "start work immediately" — preserves the existing plan-review gate.
2. **Brief content — exception-based.** `/prime` shows only the last-session line, the numbered menu, and exception lines (carryover, HIGH-urgent problems, model mismatch, dirty tree, pull failure) that appear only when real. Inbox count, innovation count, and the decisions list are dropped from the default view; a footer points to `/open-items`.
3. **Task source — last-session + next-up, no subagent.** The 1–3 menu draws from last-session Next Steps and `next-up.md`; HIGH-urgent problems from a light `friction-log` / `improvement-log` scan are promoted into the menu. No subagent — `/prime` does the plain-English conversion inline (Sonnet).
4. **No project-scoping logic.** `/prime` already reads only the cwd repo's logs; the operator confirmed scope was already correct. The fix is density + wording only.
5. **Plan-mode guard.** Operator instruction mid-session: typing a number while plan mode is active must NOT start the `/session-start` chain — it defers until plan mode is exited (= ready to execute).

**Rationale.** The operator's `/clarify` answers drove decisions 1–4 directly. "Run both then pause" keeps the existing plan-review gate intact rather than auto-starting work. Exception-based density honors the operator's "only show next steps, carryover, urgent fixes" instruction while keeping rare-but-useful signals (model mismatch, pull failure) available when they fire. The no-subagent choice keeps session start fast and cheap. The plan-mode guard reflects the operator's mental model: plan mode = still planning; `/session-start` = ready to execute.

**Alternatives considered.**
- *Ultra-minimal brief (menu only):* Rejected by operator — wanted carryover + urgent-fix visibility.
- *Compressed all-fields brief:* Rejected by operator — chose exception-based over keeping every field.
- *Subagent-ranked task menu:* Rejected — adds cost and latency to every session start; last-session + next-up is sufficient.
- *Wide-scan task source (merge open-items, improvement-log, decisions and rank all):* Rejected — heavier read each session start; the lightweight source was chosen.

---

## 2026-05-22 — /prime scratchpad selection: sort by mtime, overriding the spec's anti-mtime rule

**Context.** A logged friction entry (2026-05-22 14:54) reported `/prime` Step 1b surfacing a stale "resumable scratchpad" as the resume point. Root cause: scratchpad filenames carry AI-typed `HH-MM` timestamps skewed 2–3 hours ahead of real write time (observed: a `16-30` filename written at 13:04, a `14-00` filename written at 11:25), and Step 1b selected the "most recent" by lexical filename sort. The friction entry's fix option (a) — "sort by mtime" — directly contradicted the `/prime` Step 1b spec, which explicitly forbade mtime sort ("a scratchpad's mtime can disagree with its filename ... an mtime sort can surface the wrong file").

**Decision.** Change `/prime` Step 1b to select the most-recent scratchpad by **filesystem mtime**, and rewrite the rationale. The downstream date-comparison bullet was also switched to the mtime date for internal consistency.

**Rationale.** The conflict resolves on a fact rather than a judgment call. The spec's anti-mtime rationale is the "pulled file carries checkout-time mtime, not write-time mtime" failure mode — but `logs/scratchpads/` is gitignored (`.gitignore` line 28, confirmed via `git check-ignore`). Git never writes gitignored files, so that failure mode cannot occur for this directory; mtime always reflects the actual local write time. The filename timestamp, by contrast, is typed by the AI session and is the unreliable signal here. The spec's rule is correct in general but wrong for this specific (gitignored) directory. Because the conflict was settled by fact, it was resolved without an operator stop (the `/session-plan` stop point only fires if the fix-approach cannot be resolved from the friction entry + spec).

**Alternatives considered.**
- *Keep lexical filename sort:* Rejected — it is the bug; filename times are skewed 2–3 h.
- *Monotonic filename time source (friction option b):* Rejected for this fix — it would edit `/handoff` and `/wrap-session` filename generators, outside the Min scope, and would not repair already-skewed filenames.
- *Prune stale scratchpads (friction option c):* Rejected — file deletion (Autonomy Rule #3 gate) and a `/wrap-session` change, not a `/prime` change; mtime sort solves the misrouting without deleting anything.

## 2026-05-22 — Session-issue investigation scoped to manual-only (auto-trigger hook dropped)

**Context.** Building an "investigate the issue" capability so that when Claude reports a session/workflow fault, it can be investigated and logged for the Friday fix cadence. The plan grew to include automatic triggering — an `[ISSUE]` guardrail flag + a workspace-`CLAUDE.md` rule, and a blocking `Stop`-hook backstop (`check-issue-investigated.sh`). That design passed `/qc-pass` (GO) and `/risk-check` (PROCEED-WITH-CAUTION; system-owner `/consult` concurred).

**Decision.** Drop the auto-trigger entirely — both the `[ISSUE]` flag/rule and the blocking hook. Ship manual-only: `/resolve-repo-problem` extended with MANUAL + AUTO modes (both operator-invoked) plus `/friday-checkup` pickup. 2 files instead of 6.

**Rationale.** The blocking `Stop` hook was the first of its kind in the repo and the highest-risk component, while being only a backstop of low marginal value — the rule alone already delivers the automatic behavior. The repo's own `session-guardrails.md` discipline says do not add hooks preemptively; promote a rule to a hook only after the rule proves unreliable. Dropping the hook also removes every `/risk-check`-gated change class from the change set.

**Alternatives considered.**
- *Keep the hook (full 6-file plan):* Rejected — QC-clean and risk-checked, but preemptive and low-value relative to its novelty risk.
- *Rule without hook (4 files):* Rejected by operator — preferred to avoid even the always-loaded rule for now; manual is simpler and the auto-trigger can be added later as a separate change.
- *Manual-only (chosen):* `/resolve-repo-problem` operator-invoked; revisit the auto-trigger later only if manual invocation proves easy to forget.
