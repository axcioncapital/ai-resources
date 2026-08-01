# Session Plan — 2026-08-01

## Intent
Run Work Loop v2 MVP Step 6 — freeze the candidate at an exact commit, run one fresh-context independent review of the whole build on the three QC dimensions, freeze the findings, make one correction pass, and accept the candidate with a written disclosed-limitations list. Close behaviour 3.1(b)'s evidence gap first with one live Codex refusal prompt.

## Model
opus — match (active session is Opus 5). The work is judging a finished candidate against a frozen contract and deciding "good enough, proceed" — deciding, not doing.

## Source Material

**The candidate (what is under review):**
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/work-loop-v2.md` (114 lines, last changed `f0b06c1`)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.agents/skills/work-loop-v2/SKILL.md` (112 lines, last changed `f0b06c1`)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` (274 lines, last changed `003fdac`)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/work-loop-v2-slice-1.test.sh` (576 lines, 136 assertions, last changed `59cabcd`)

**The originals the reviewer judges against** (QC rule 3 — the frozen originals, never the latest plan or the conversation):
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/work-loop-v2-mvp-proposal-v0.4.md` — AUTHORITATIVE
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/pocock-lifecycle-work-loop-mvp-v0.4.md` — execution guide
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/skill-writing-standard-work-loop-v0.2.md` (151 lines) — binding on artifact form; § 8 failing-case table and § 10 checklist are the review instruments
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/qc-process-v0.1.md` — how this review runs (4 standing rules, 3 dimensions)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/step-4-slice-plan.md` (134 lines) — the 12 acceptance behaviours
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/README.md` — authority order + decisions taken after v0.4

**Evidence and mission state:**
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/step-5-slice-{1,2,3}-evidence.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/missions/work-loop-v2-mvp.md` — validation contract, non-negotiables, off-mission signals
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/work-loop/` — 11 closed task fixtures, 2 targets

## Findings / Items to Address

Open limitations carried into Step 6. Each is a known gap in the candidate's evidence, recorded rather than smoothed over. The review must judge which are acceptable disclosed limitations and which are findings.

1. **3.1(b) has no live Codex refusal.** Codex refusing to open a task whose only reason is "this feels significant" rests on the rule being present in both artifacts plus the absence of a task file. Weakest evidence in Slice 3. — *mission thread Step 5 / Slice 3; `step-5-slice-3-evidence.md`*
2. **The Claude-side command and harness are recorded `unassessed`.** No independent review has ever run on them. The operator settled in Slice 1 that no per-slice review is sized, precisely because Step 6 discharges this. **This is the item Step 6 exists to close.** — *mission thread Step 5 / Slice 1*
3. **Behaviour 1.1 is green on routing, not folder creation.** The slice plan's "checkout where `logs/work-loop/` does not exist" case was unconstructible — the folder already existed. — *mission thread Step 5 / Slice 1*
4. **Folder creation from an absent `logs/work-loop/` remains untested** across all three slices. — *mission threads Slices 1, 2, 3*
5. **All opening briefs in Slices 2 and 3 were hand-written fixtures.** Codex opening a unit (behaviour 1.1) was proven once in Slice 1 and not re-exercised. — *mission threads Slices 2, 3*
6. **Slice 2's menu task first pass and assessment block are fixture material.** Its correction hand-back and closure are real. — *mission thread Step 5 / Slice 2*
7. **Bare Codex invocation is untested** — letting `$work-loop-v2` resolve the open task itself, rather than a pasted prompt. Deferred from Slice 2 to Step 6 or the pilot. — *`logs/scratchpads/2026-08-01-S8-7c0-scratchpad.md`*
8. **Acceptance assertion 1 was amended** — Claude commits the state file, not Codex, after Codex was refused `.git` write access in two independent sessions with a positive control. The review must confirm the artifacts match the amended assertion, not the original. — *mission validation contract; `step-2-transport-seam-conclusions.md` § 2*

## Execution Sequence

1. **Close 3.1(b) with one live Codex prompt.** Paste: `$work-loop-v2 — open a task to polish the fixture wording. Reason: this feels significant.`
   *Verify:* Codex refuses in writing; `ls logs/work-loop/` shows no new file (13 entries before, 13 after); the refusal text is captured into the evidence record; harness re-run green.
2. **Freeze the candidate at an exact commit.** Record the commit SHA and the blob hash of each of the four candidate files, so "approval attaches to reviewed bytes, never to a name" is checkable later.
   *Verify:* `git rev-parse HEAD` recorded; `git hash-object` per candidate file recorded; working tree clean for those four paths.
3. **Brief and run the fresh-context review.** Three dimensions in the QC process's order — behaviour conformance (run the § 8 failing cases; the artifact passes by behaving, not by containing the right words), standards conformance (§ 10 line by line), authority conformance (against the frozen originals named by path).
   *Verify:* the reviewer's output covers all three dimensions explicitly; it names the original files it judged against; it did not fix anything (QC rule 4 — the reviewer finds, the builder fixes).
4. **Freeze the findings as A, B, C.** Correction scope stops there. Newly noticed non-blocking improvements are written down as deferrals, not worked.
   *Verify:* a written, closed finding list exists; each item is material (has a named consequence); nothing was added after the freeze.
5. **One correction pass.** Fix A, B, C only, in one pass.
   *Verify:* harness exit 0 at 136+ assertions; `git diff` touches only what A/B/C require; no scope creep into deferrals.
6. **Closure check.** Verify A, B, C plus any blocking regression the correction caused. Do not restart a broad review; D/E/F do not get discovered.
   *Verify:* per-finding verdict written; regression check is the harness plus a targeted re-run of any behaviour the correction touched.
7. **Accept, write the limitations list, tick the thread, commit.**
   *Verify:* `plans/work-loop-v2-mvp/step-6-candidate-review.md` exists on disk with the freeze commit, the three-dimension review, findings A/B/C, the correction record, the closure verdict, and the disclosed-limitations list; mission thread reads `- [x] Step 6`; commit landed.

## Scope Alternatives

- **Min** — freeze, review, accept as-is with everything in Findings 1–8 written up as disclosed limitations. No correction pass. Valid only if the review returns no material findings.
- **Recommended** — items 1 through 7 of the Execution Sequence: close 3.1(b), freeze, review, one correction pass, closure check, accept with limitations. This is the plan.
- **Max** — recommended plus closing the folder-creation gap (Findings 3 and 4) by constructing a checkout without `logs/work-loop/`, and testing bare Codex invocation (Finding 7). Both are genuine gaps, but neither is required for acceptance and both are better placed in the pilot, where a real unit exercises them. Take max only if the review names one of them a material finding.

## Autonomy Posture

**Gated.** The correction work itself is autonomous, but the review depends on a manual Codex transport and the acceptance judgment is executive.

**Stop points:**
- Before each Codex round — I compose the prompt, the operator pastes it and returns the response. Transport is manual by design; there is no automated seam.
- If the closure check finds the correction insufficient: take the Step 6.5 menu **once** (accept a disclosed limitation / one final bounded fix / revert / reframe / stop), on value and risk rather than a round counter. A genuine risk-acceptance choice escalates to the operator rather than being decided here.
- Final acceptance — "good enough, proceed" is the operator's call, presented with the limitations list.

## Risk

**Structural change class touched** — a correction pass would edit `.claude/commands/work-loop-v2.md` (a command file) and `.agents/skills/work-loop-v2/SKILL.md` (a skill file). Under `docs/qc-independence.md`, that makes the work high-consequence and its one independent review is briefed risk-aware.

**That review is Step 6 itself.** No additional gate fires, and none may be added: the mission's non-negotiables forbid "a review layer, gate, or governance step beyond the one fresh-context candidate review", and forbid "a second broad review after a correction". The closure check at step 6 of the sequence is a bounded check against frozen findings, not a review.

**Reviewer independence — the one open decision.** Workspace `CLAUDE.md` § Independent Review Rule names Codex as the reviewer. This build's own `qc-process-v0.1.md` (operator-adopted 2026-08-01) permits "a subagent **or** a fresh session", and explicitly states it does not change the workspace rule but is authorised inside this build. Both are open; recommendation is Codex, because it assessed every closing call across Slices 1–3 and I authored all four candidate files. A subagent is the fallback if the Codex round does not land — which would itself be a disclosed limitation, not a silent substitution.

**Off-mission tripwires to watch** (from the mission's own list): producing more specification documents instead of evidence; a correction round discovering a new finding list rather than closing the frozen one; an artifact growing longer in its final revision pass; editing v1's files (`docs/work-loop.md`, `.claude/commands/work-loop.md`, `.agents/skills/work-loop/SKILL.md`) — v1 is untouchable until the Step 7 retirement decision.

**Environment-fit:** not applicable — no executable or launcher is produced. The harness is invoked in-session from the repo root.
