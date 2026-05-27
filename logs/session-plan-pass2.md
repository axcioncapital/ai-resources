# Session Plan — 2026-05-27

## Intent
Build the `/decide` skill via the canonical `/create-skill` pipeline (renamed from `decision-resolver` in the inbox brief at `inbox/decision-resolver.md`).

## Class
design

## Model
opus — match (active: `claude-opus-4-7[1m]`)

## Output artifact decision (revised 2026-05-27 post-Step-1, post-/risk-check)

`/decide` will be a **slash command at `.claude/commands/decide.md`**, NOT a SKILL.md at `skills/decide/SKILL.md`.

**Architectural reconfirm record** (resolves Finding 8 + risk-check Dimension 5 gating mitigation):
- **Routing baseline:** `docs/repo-architecture.md` § Canonical homes (Slash command row) and § Q2 — "Operator-invoked on-demand with specific input → produces specific output" maps to slash command at `.claude/commands/<name>.md`.
- **Composition graph homogeneity:** all named composition partners — `/resolve`, `/scope`, `/clarify`, `/recommend` — are slash commands at `.claude/commands/`, not SKILL.md skills. Putting `/decide` in `skills/` would create asymmetry in a tightly coupled set.
- **Precedent:** `/contract-check` shipped the same day as a slash command for behavior of comparable complexity.
- **Source from operator:** Step 1 Q1 confirmed Option A (slash command at `.claude/commands/decide.md`).
- **Why the original choice was wrong:** the prior rationale conflated which *pipeline* created the artifact with which *canonical home* the artifact belongs in. `/create-skill` is the right pipeline; the literal output target it names in its Step 2 ("Create the skill directory at `skills/{skill-name}/`") does not apply when the artifact's correct home is `.claude/commands/`. The pipeline's surrounding gates (evaluate, auto-fix, verify, present, commit) all still apply to the slash-command output.
- **Frontmatter implication:** slash commands at `.claude/commands/` use minimal frontmatter (`model:` only) — they do NOT require the full SKILL.md frontmatter set (`name:`, `description:`, `model:`, `effort:`). Pipeline Step 5's "frontmatter completeness gate" relaxes accordingly for this run.

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/inbox/decision-resolver.md` — source brief (pipeline reads in full at Step 1)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/create-skill.md` — pipeline definition
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/ai-resource-builder/SKILL.md` — canonical skill-creation methodology (loaded by `/create-skill` Step 1)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/ai-resource-builder/references/operational-frontmatter.md` — model-tier + effort guidance for SKILL.md frontmatter
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/resolve.md` — composition partner; gap analysis (QC-scoped only → cross-context evidence research)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/recommend.md` — anti-pattern reference (blanket judgment vs explicit per-item)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/clarify.md` — composition partner (pre-work clarifying questions)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` — new skill = structural change class

## Findings / Items to Address
1. **Core capability — 3-bucket output.** For each open decision question, `/decide` outputs one of: (a) Self-resolved (resolution + reasoning + file refs); (b) Recommendable (recommendation + evidence + gap + operator's verbatim original framing); (c) Operator-only (question + project context + why it cannot be evidence-grounded). Source: brief §Capability, lines 8–14.
2. **Trigger contract — operator-invoked only.** Not auto-fire. Picks up decision lists after `/qc-pass` REVISE, `/scope` "decisions I am making on your behalf", `/clarify` operator-decision questions, or mid-stream Claude turns that surfaced a decision list. Source: brief §Trigger Conditions, lines 16–25.
3. **Anti-narrowing protection — must-have, not optional.** Each recommendation shows (a) supporting file paths + excerpts, (b) operator's verbatim original framing where it exists in the conversation, (c) `[narrowing-check]` note where the recommendation may have constrained or reframed the original question. Origin: real friction incident (audience-phrasing rewrite caught by QC). Source: brief §Context, lines 37–41.
4. **Exclusions — four non-replacement contracts.** Does NOT auto-apply silently; does NOT replace `/recommend`, `/resolve`, or `/clarify`; does NOT re-escalate items already decided earlier in the session (must check `logs/session-notes.md`, `logs/session-plan.md`, and conversation history before treating an item as open); does NOT sweep the whole session unprompted. Source: brief §Exclusions, lines 27–33.
5. **Composition contract — three named upstream integrations.** `/resolve` → `/decide` (picks up "Needs operator judgment" Real items); `/scope` → `/decide` (grounds "decisions I am making on your behalf"); `/clarify` → `/decide` (pre-researches operator-decision questions). Source: brief §Composition with existing tools, lines 43–47.
6. **Token-efficiency cap — explicit, designed.** Per-question read-scope cap (max files / max bytes per question). Escalation-with-partial-evidence path when a question exceeds the cap — does NOT recurse. Source: brief §Token efficiency consideration, lines 55–57.
7. **Naming — operator-renamed throughout.** Command name = `decide`, not `decision-resolver`. Must be consistent in the slash-command filename (`.claude/commands/decide.md`) and all internal references. Source: operator mandate.
8. **Architectural reconfirm at Step 1.** Brief explicitly flags that the design pass may reveal tighter overlap with `/resolve` than expected, and an extension may be better than a new skill. Step 1 stop point must surface this verdict explicitly. Source: brief §Why a new command, line 53.

## Execution Sequence
1. **Invoke `/create-skill`** with the brief at `inbox/decision-resolver.md`. Pipeline Step 1: presents understanding, proposed structure, clarifying questions (including Finding 8 architectural reconfirm: new tool vs extend `/resolve`), and potential problems. **[STOP POINT: review Step 1 proposal before proceeding.]** Verification: proposal names the output target as `.claude/commands/decide.md` (slash command, not SKILL.md — see § Output artifact decision) and explicitly addresses Finding 8. ✅ Confirmed 2026-05-27 — operator picked Option A.
2. **Plan-time `/risk-check`** (workspace gate, inserted between Step 1 confirmation and Step 2 write). New skill = structural class per `audit-discipline.md`. **Verification:** verdict is `GO` or `PROCEED-WITH-CAUTION`; if `PROCEED-WITH-CAUTION`, mitigations are documented before Step 2 begins.
3. **Pipeline Step 2**: write `.claude/commands/decide.md` (slash command body; no bundled resources needed for this command). Must address Findings 1–7 plus the 4 risk-check mitigations (target-path resolved; auto-detection marker strings verified against live `/scope.md`, `/resolve.md`, `/clarify.md`; prior-decision check extended to `session-plan-pass{N}.md` siblings; cross-references added in upstream commands at end-time risk-check). **Verification:** rename to `decide` applied throughout; Findings 1–7 each traceable to a section in the command body.
4. **Pipeline Step 3**: evaluation subagent → report at `audits/working/evaluation-decide.md`. Returns verdict (PASS / REVISE / BLOCKED) + 1-line summary. **Verification:** report is written to disk; main session reads only the path + verdict line.
5. **Pipeline Steps 4a–4c**: triage evaluation findings → fix BLOCKING/IMPORTANT issues → regression check. Step 4d stall detection applies if same issue persists after 2 attempts. **Verification:** all BLOCKING/IMPORTANT findings resolved; fix log written.
6. **Pipeline Step 5**: verify the command file against its own embedded spec (trigger claims, exclusion claims, output format, frontmatter — `model:` required; `effort:` not applicable for slash commands per § Output artifact decision). **Verification:** no mismatches; frontmatter complete.
7. **Pipeline Step 6**: pipeline presents final SKILL.md + evaluation report + fixes applied + remaining minor issues. **[STOP POINT: review before additional /qc-pass.]** Verification: Patrik confirms no rework.
8. **Additional `/qc-pass`** (workspace gate, layered on top of pipeline's own Steps 3–4). This runs AFTER the pipeline's internal evaluate-auto-fix cycle, as an independent review of the final artifact. **Verification:** `GO` verdict. If `REVISE`, run `/resolve` to triage findings, apply fixes, then continue.
9. **End-time `/risk-check`** (workspace gate, before commit). **Verification:** `GO` verdict with documented delta from Step 2 draft to final.
10. **Pipeline Step 7**: commit after explicit approval (`new: decide — evidence-grounded pre-research of open decision questions`). Archive brief (`inbox/decision-resolver.md` → `inbox/archive/decision-resolver.md`). **Verification:** commit lands, brief is in `inbox/archive/`.
11. **Wrap**: log session decisions in `logs/session-notes.md`, flag push gate to operator.

## Scope Alternatives
- **Min** — Ship core 3-bucket capability (Finding 1) + anti-narrowing markers (Finding 3) + token cap stub (Finding 6). Operator pastes the decision list manually; no auto-detection of upstream command output. Naming and exclusions enforced (Findings 4, 7).
- **Recommended** — Min + explicit composition contract for `/resolve`, `/scope`, `/clarify` auto-detection (Finding 5) + prior-decision check against `session-notes.md`/`session-plan.md` (part of Finding 4) + full token cap with escalation path (Finding 6) + Step 1 architectural reconfirm surfaced (Finding 8).
- **Max** — Recommended + structured machine-readable output schema for downstream consumption + telemetry hook logging every `/decide` invocation to `logs/decide-usage.md` for friction-pattern analysis.

Default for this session: **Recommended.** Min loses too many named contracts; Max adds telemetry with no consumer yet.

## Autonomy Posture
Gated

**Stop points:**
- After `/create-skill` Step 1 proposal — review architectural-reconfirm finding (Finding 8) and Step 1 scope before plan-time `/risk-check`.
- After `/create-skill` Step 6 presentation — review final SKILL.md before the additional `/qc-pass`.
- After `/qc-pass` if REVISE — run `/resolve` and apply fixes; confirm before end-time `/risk-check`.

## Risk
Run `/risk-check` at plan-time (between Step 1 confirmation and Step 2 write) and again at end-time (Step 9, before commit). New skill falls under structural change classes listed in `ai-resources/docs/audit-discipline.md`.
