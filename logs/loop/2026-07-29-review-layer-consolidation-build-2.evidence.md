UNIT: 2026-07-29-review-layer-consolidation-build-2
STREAM: 2026-07-29-review-layer-consolidation
PHASE: build
SLICE: S2 — Automatic hooks and embedded general-review removals
REPO: ai-resources
BASE: ff000a4
NEXT: Claude — Build-3 (S3)

EVIDENCE

## 1. What was removed

**Two hooks deleted** — `.claude/hooks/auto-qc-nudge.sh` (1394 b), `.claude/hooks/auto-resolve-nudge.sh` (786 b). Their two `settings.json` entries removed (PostToolUse `Write|Edit`, Stop). File still parses: `python3 -c "json.load(...)"` → VALID. `grep -c nudge` → 0.

**Automatic review calls removed, by file:**

| File | Removed | Kept |
|---|---|---|
| `wrap-session.md` | 12b end-time `/risk-check` gate; 12c QC-PENDING commit guard | 12b replaced by a *stated, non-gating* review-status line in the wrap note |
| `qc-pass.md` | the QC-PENDING commit-block escalation at `:26` | the command; its two surviving roles |
| `promote-workflow.md` | P1 per-item `/qc-pass` → deterministic evidence qualification (artifact exists, cited lines resolve, materiality floor); P5.1 `/risk-check`; P5.2 independent `/qc-pass`; the `:282` "no edit lands without GO" rule | P4 anti-clobber, P6, P5.4 push gate, evidence-fail-defers-never-drops |
| `skills/handoff/SKILL.md` | the `**QC-PENDING:**` marker, its scratchpad directive and the commit-block | the session-marker teardown rationale (unrelated) |
| `pm.md` | Steps 4–5 entirely — internal `qc-reviewer` pass with 2-pass cap | Step 6 now *offers* `/qc-pass` on a load-bearing ruling |
| `cleanup-worktree.md` + `execution-protocol.md` | QC → triage → second QC collapsed to **one** risk-aware review; quick-tier skip rule; `execution-protocol` §§ 4–6 | see § 2 |
| `resolve-incident.md` | `:78` `/risk-check` invocation; `:83` verdict-token contract (S1's orphan, closed here as planned); `:114-119` automatic `/consult` → operator-invoked | `status: escalated` stop; the halt on an unresolved material finding |
| `friday-journal.md` | Step 5.5's automatic `qc-reviewer` → operator-offered (y/n at 15a-pre) | Steps 5.4, 5.6, 5.7 fully intact; `**Risk-check required:**` bullets rekeyed to `**High-consequence:**` |
| `friday-act.md` | `:279` risk-check firing; 16k automatic plan-file QC → offered | the 2026-05-22 evidence for 16k is retained as the reason it stays an *offer* rather than being dropped |
| `fix-project-issues.md` | `:141` per-edit `/qc-pass` → deterministic verification | Step 1 independent gating re-derivation, Step 2 gated-item stop, `:93-115` |
| `reconcile.md` | Step 3's automatic `/contract-check` | `reconcile-reviewer` at Step 4 — the engine |
| `improve-skill.md` | **Step 5e's independent post-edit QC subagent and its loop-back** — the Build-1 inventory correction | Step 4's evaluation pass (the pipeline's engine); 5e is now deterministic fix verification |

## 2. Protected set — proven untouched

- **Six protected hooks** — `check-destructive-liveness.sh`, `log-write-activity.sh`, `friction-log-auto.sh`, `check-stop-reminders.sh`, `coach-reminder.sh`, `improve-reminder.sh`: `git diff --name-only` per path → empty for all six.
- **Permission surface** — `git diff .claude/settings.json` filtered for `allow|ask|deny|Bash(|Read(|Write(` → **0 lines**. Only hook entries changed.
- **`cleanup-worktree.md`** — Section 4 hard gates and named confirmation phrases, Section 7 bias counters 1/2/4, Steps 13 and 13b: unchanged. Bias counter 3 rekeyed off the deleted second pass onto the surviving single review, as the brief required.
- **`execution-protocol.md` §§ 7–13** — unchanged, and **deliberately not renumbered** despite §§ 5–6 being removed. Renumbering would silently invalidate every reference that cites the hard-gate and execution-time sections by number. The gap is documented in the table of contents.
- **`friday-journal.md` Steps 5.4 / 5.6 / 5.7** — mechanics unchanged; only the flag *wording* changed, in lockstep across producer and consumer.
- **`promote-workflow.md`** P4 / P6 / P5.4 — unchanged.

## 3. Falsifier results

| # | Result |
|---|---|
| 1 | **Clear** relative to BASE (re-keyed in Build-1 § 4 — 7 breakages pre-exist, none created here). S2 touched no symlink. |
| 2 | **Clear.** Counts re-derived with `find -L`: qc-pass 26, refinement-pass 26, triage 26, resolve 26, contract-check 22, risk-check 26, consult 28, reconcile 15, pm 22 — all identical to plan-v3 § 8. |
| 3 | **Clear.** No repo-wide or workspace-wide claim made; S1's transitional caveats still stand. |
| 4 | **Clear.** No new command, agent, hook, registry, wrapper, gate or programme. The only additions are this unit's `logs/loop/` files. |
| 5 | **Clear** — § 2. |
| 6 | **Clear.** No excluded file in the diff. |
| 7 | **Clear.** Only the two hook scripts deleted; zero canonical commands or agents removed. |
| 8 | **One known stale line, owned by S4** — see § 4. |
| 9 | N/A — the transition gate ran once, in Build-1, as the G1 condition required. |

**Automatic-review sweep** (`auto-run|auto-fire|auto-spawn|auto-invoke|automatic` within 60 chars of a general reviewer, across `.claude/commands/ .claude/hooks/ skills/ docs/`, excluding retired-notes): two hits, both benign — `risk-check.md:177` is an instruction *not* to auto-invoke `/contract-check`, and `friday-cadence-runbook.md:85` is § 4 below.

## 4. Carried to S4

`docs/friday-cadence-runbook.md:85` — *"F4 auto-runs `/qc-pass` on the plan files it writes"* — became **false** when S2 made `/friday-act` 16k an offer. S4 owns that file and every other layer-4 guidance restatement; the line is corrected there rather than reached across a slice boundary. Recorded so it is a scheduled item, not a survivor.

## 5. Scope

No policy document owned by S1 was edited. No S3- or S4-owned file was edited. 18 tracked files changed: 11 commands, 2 hook deletions, `settings.json`, `skills/handoff/SKILL.md`, `execution-protocol.md`, and two hook-written autologs (`logs/friction-log.md`, `logs/innovation-registry.md`) that are not policy edits.
