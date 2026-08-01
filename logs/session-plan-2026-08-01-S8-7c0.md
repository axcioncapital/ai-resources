# Session Plan — 2026-08-01

## Intent
Implement Work Loop v2 MVP Step 5, Slice 3 (admission discipline), red-green: write the failing acceptance harness first, then the behaviour, then record the evidence.

## Model
opus (judgment on scope split + spec-following implementation) — active model is claude-fable-5, at or above the recommended tier: match.

## Source Material
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/step-4-slice-plan.md (frozen — behaviours 3.1–3.4 at :69-79)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md (frozen — §2 admission/de-escalation, §3 proceed judgment, §5 deferral, §6 rules 4–5)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/README.md (frozen — authority order)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/skill-writing-standard-work-loop-v0.2.md (frozen — binding on artifact form)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/work-loop-v2.md (edit target — Claude side; :15 scope line names Slice 3's three gaps)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.agents/skills/work-loop-v2/SKILL.md (edit target — Codex side; mirror scope statement at :100-102)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/work-loop-v2-slice-1.test.sh (edit target — acceptance harness, 78 assertions after Slice 2)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/missions/work-loop-v2-mvp.md (tick via /mission only, at close)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/step-5-slice-1-evidence.md and step-5-slice-2-evidence.md (shape precedent for the evidence record)
- Context pack: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/output/context-packs/project-20260801-b7e41/pack.md

## Findings / Items to Address
1. Behaviour 3.1 — the admission test routes a small reversible fix to Direct Work with no state file, and refuses loop entry whose only reason is "this feels significant" (step-4-slice-plan.md:69-79).
2. Behaviour 3.2 — work already in the loop that turns out smaller de-escalates and closes (step-4-slice-plan.md:69-79; executable core §2).
3. Behaviour 3.3 — a tempting adjacent improvement noticed mid-unit is recorded as a deferral, not implemented (step-4-slice-plan.md:69-79; executable core §5 :230). Note :78-79 — 3.3 and 2.3 are different moments; building one does not cover the other.
4. Behaviour 3.4 — a pilot-quality result with written limitations is closed at assessment, not corrected (step-4-slice-plan.md:69-79; executable core §3 :77-110).
5. Pack conflict item — Playbook prescribes a per-slice review; mission non-negotiables and the settled Slice 1 operator decision (commit a79e6ee) forbid review before Step 6. Resolution: follow the settled decision — no per-slice review; Step 6 owns the candidate review. Surfaced, not silently resolved.
6. Pack unknown-scope item — no source fixes where admission/de-escalation/deferral live (Claude command, Codex resource, or both). Resolution to apply: both sides carry the behaviours symmetrically, since the scope-exclusion lines being replaced exist symmetrically (work-loop-v2.md:15 and SKILL.md:100-102); record the choice in the evidence file.
7. Pack dependency item — behaviours 3.2 and 3.4 need real Codex moves; nothing in-repo performs them. Resolution: offer the operator a live `$work-loop-v2` run at that point; fall back to disclosed fixture material per Slice 2 precedent.

## Execution Sequence
1. Read the frozen slice plan (:69-79 and surrounding), executable core §§2/3/5/6, both edit targets, and the harness header + Slice 2 block. Verify: the four behaviours' failing cases restated in-session from source, not from the pack.
2. RED — extend `work-loop-v2-slice-1.test.sh` with Slice 3 assertions (3.1–3.4), run it, capture the failing output. Verify: new assertions fail; all 78 pre-existing assertions still pass.
3. GREEN — implement admission test, de-escalation, and mid-unit deferral discipline in `work-loop-v2.md` and mirror in `SKILL.md`; replace the scope-exclusion lines. Verify: harness fully green; capture output.
4. Codex-dependent behaviours (3.2, 3.4): pause once to offer a live Codex run; otherwise land fixture material with the limitation disclosed in the evidence record. Verify: each behaviour has either a live move or a disclosed fixture.
5. Write `plans/work-loop-v2-mvp/step-5-slice-3-evidence.md` following the Slice 1/2 record shape (red output, green output, decisions, limitations). Verify: file exists and cites the harness run outputs.
6. Tick the mission's Slice 3 thread via `/mission` (never hand-edit). Verify: thread shows `[x]` with evidence reference.
7. Commit per repo commit rules (direct, no push). Verify: commits landed with `new:`/`update:` message shapes.

## Scope Alternatives
Single scope — no alternatives. The four behaviours are fixed by the frozen slice plan; the only degree of freedom (live Codex vs fixture for 3.2/3.4) is handled as a named stop point, not a scope tier.

## Autonomy Posture
Gated

**Stop points:**
- Before demonstrating behaviours 3.2/3.4: one offer to run `$work-loop-v2` live in the Codex app; on decline or no answer, proceed with disclosed fixtures (Slice 2 precedent).

## Risk
Structural change class touched (edits to an existing command and skill that manage shared loop state) — this work is high-consequence, so its one independent review is briefed risk-aware (qc-independence.md § Risk-aware review). Per the mission's settled decision, that review is Step 6's candidate review, not a per-slice gate — no review fires in this session. Environment-fit: not applicable (no launcher/terminal tooling).
