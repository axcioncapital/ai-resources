# Session Plan — 2026-08-01

## Intent
Implement Slice 2 of Work Loop v2 (continuity and correction, behaviours 2.1–2.4) red-green in this fresh session — behaviour 2.1 (a fresh session reading the state file and Git alone) doubles as the real independent exercise of the Claude-side command.

## Model
opus — match (active session model is Fable 5, above the opus tier; the hard part is deciding — behaviour semantics, failing-case construction, harness design)

## Source Material
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/step-4-slice-plan.md (§ Slice 2, lines 54–65 — the four behaviours and their failing cases)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md (the contract each behaviour traces to)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/work-loop-v2.md (Claude-side artifact — behaviours 2.1, 2.2)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.agents/skills/work-loop-v2/SKILL.md (Codex-side artifact — behaviours 2.3, 2.4)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/work-loop-v2-slice-1.test.sh (34-assertion harness to extend; awk section-scoping and commit-anchored read patterns)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/missions/work-loop-v2-mvp.md (frozen validation contract — acceptance assertions 5 and 6; non-negotiables)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/step-5-slice-1-evidence.md (evidence-record template; carried limitations)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/work-loop/fixture-slice1-true.md (fixture precedent for constructing failing cases)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/cross-model-rules.md (Claude may not stand in for Codex — governs the 2.3/2.4 split)
- Context pack: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/output/context-packs/command-20260801-b7e3a/pack.md

## Findings / Items to Address
1. Behaviour 2.1 — a memory-free session reads the state file and produces the correct next action (step-4-slice-plan.md § Slice 2). This session IS the fresh session; run it first, before any implementation, while exposure is orientation-level only.
2. Behaviour 2.2 — a stale or foreign state file is rejected read-only before any mutation; first real exercise of the file-identity field, unproven until it passes (step-4-slice-plan.md lines 63–65).
3. Behaviour 2.3 — exactly one bounded correction frozen at the named findings; anything newly noticed at closure recorded as a deferral (Codex side, SKILL.md).
4. Behaviour 2.4 — when the correction was not enough, one option off the core's § 3 menu chosen once, on value and risk (Codex side, SKILL.md).
5. Carried limitation from Slice 1 (step-5-slice-1-evidence.md:45–46): 1.1 proven on routing only, not folder creation from absent logs/work-loop/; stale files not yet refused — item 2 closes the second.
6. Conflict resolutions confirmed at mandate: no slice-end review (mission non-negotiable wins, Slice 1 precedent); skill-writing standard applies when editing SKILL.md (Playbook's read limit targets planning history, not form standards).

## Execution Sequence
1. Read the slice plan § Slice 2, the executable core's relevant sections, and both artifacts' current state. Verify: the four behaviours' failing cases are each constructible as written.
2. Behaviour 2.1 (red first): construct the failing case per the slice plan, show it failing, then exercise `/work-loop-v2` fresh against a real state file; record the produced next action. Verify: correct next action derived from state file + Git alone, no Slice-1 conversational memory available (structurally true — this session did not build the command).
3. Behaviour 2.2 (red-green): extend the command's Step 1 with file-identity rejection; construct a foreign/stale fixture, show rejection read-only before mutation. Verify: harness assertion red before the edit, green after; no mutation on the rejected path.
4. Behaviours 2.3 and 2.4 (Codex side): extend SKILL.md with the bounded-correction closure shape and the § 3 menu choice; prepare Codex prompts; STOP for operator to run them in the Codex app; verify pasted results against disk, never trusting the paste. Verify: red harness assertions before, green after Codex's real round trip.
5. Extend `work-loop-v2-slice-1.test.sh` with Slice 2 assertions (follow its awk section-scoping and commit-anchored patterns). Verify: exit 0 with all assertions, including the original 34; falsifiability shown for each new assertion before accepting green.
6. Write the Slice 2 evidence record under plans/work-loop-v2-mvp/ (v-file convention). Verify: red-green evidence for all four behaviours, limitations stated.
7. Tick the mission's Slice 2 thread via /mission update + /mission check (frozen-prefix hash verified). Commit per behaviour boundary; no push.

## Scope Alternatives
- Min: behaviours 2.1 + 2.2 only (Claude-side), split record for 2.3/2.4 — mirrors Slice 1's split precedent if Codex cannot run this session.
- Recommended: all four behaviours end-to-end with the operator running the Codex prompts in-session.
- Max: recommended + close Slice 1's folder-creation limitation (1.1 sub-clause) if it falls out naturally of 2.1's exercise. Do not chase it otherwise.

## Autonomy Posture
Gated

**Stop points:**
- Handing each Codex prompt to the operator (2.3, 2.4) — operator runs the real Codex app; cross-model rule forbids Claude standing in.
- If behaviour 2.2's file-identity field cannot be implemented without amending the frozen executable core — stop and surface; the core is not this session's to edit.

## Risk
Structural change class touched (edits to an existing command and a Codex-side skill resource) — this work is high-consequence, so its one independent review is briefed risk-aware per docs/qc-independence.md. However, the mission's own non-negotiables forbid a review layer beyond Step 6 (the one fresh-context candidate review), and the operator's recorded decision (decisions.md 2026-08-01, Slice 1 precedent) resolves the conflict the same way for Slice 2: no slice-end review; the extended acceptance harness and behaviour 2.1's real fresh-session exercise are the standing checks; `unassessed` recorded factually in the mission thread if applicable. Environment-fit: n/a — no launcher/terminal tooling; all artifacts are in-session commands/skills.
