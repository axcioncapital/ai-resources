# Build `/leverage-idea` — idea-dump → leverage options → implementation plan

> **Status (2026-06-12): APPROVED — IMPLEMENTATION DEFERRED.** Operator approved the plan and deferred the build to a fresh session. Review chain complete: SO advisory WORTH-DOING → refinement-deep (4 triage fixes applied) → final /qc-pass GO (no findings). Resume: fresh session → `/prime` → execute this plan starting at EP-0 → gates as listed. First live test input: Patrik will supply a real example note dump.

## Context

Patrik regularly captures ideas about adding/improving AI resources as messy note dumps (often multi-page ChatGPT conversation exports). Today there is no pipeline that takes such a dump and answers: **what is THE BEST way to plug this idea into the system?** `/request-skill` is intake-only (no investigation), `/implementation-triage` judges an already-proposed implementation, `/resolve-repo-problem` handles faults not ideas. The gap: raw idea → cleaned brief → workspace-evidence check → repo investigation → **2–4 distinct leverage options compared** → recommendation with worth-doing verdict → implementation plan (or PARK).

Operator-confirmed requirements:
1. Pipeline **stops at the implementation plan** — no execution.
2. **Can conclude "don't build this"** — PARK verdict logs to `improvement-log.md`.
3. New-skill recommendations **hand off to the canonical `/request-skill` → `/create-skill` pipeline** (brief drafted, not auto-written).
4. **One final deliverable file** (consolidated analysis ending in the plan). The investigation subagent's working-notes file still exists per the repo's Subagent Contracts rule, but it is internal plumbing — operator reads only the analysis file.
5. Note dumps can be **many pages** → distillation happens inline (notes are already in main-session context); only the distilled Idea Brief is passed to the subagent.

**System Owner advisory (2026-06-12): WORTH-DOING** — new command is the right lever (extending `/request-skill` or `/implementation-triage` would invert their contracts); no overlap-degradation across neighboring pipelines. Three Important findings (SO-1/2/3) plus two advisory notes (SO-N1 semantic search, SO-N2 verdict boundary) folded in below. Full advisory currently stranded in the plan directory — relocation is **execution prerequisite EP-0, see Gates & verification**.

## Deliverable

One new file: `ai-resources/.claude/commands/leverage-idea.md`, plus one post-landing row append (SO-2 below). Self-contained — inline subagent brief, no new agent definition (follows `/resolve-repo-problem`'s single-investigator precedent).

**Scope boundary (SO-1):** the command body carries one boundary sentence vs. its nearest scope-neighbour `/tech-consult` — `/tech-consult` translates a broad business/project need into a build-ready technical plan (need-first, pre-idea); `/leverage-idea` starts from an already-captured idea about workspace AI resources and routes it to the best attach point (idea-first, system-routing).

### Frontmatter

```yaml
---
description: Process a pasted idea dump (ChatGPT export, brainstorm) into a structured Idea Brief, investigate workspace evidence and repo attach-points, generate 2–4 distinct leverage options, and recommend one with a worth-doing verdict and implementation plan — or PARK to improvement-log.md. Advisory only — writes analysis to audits/working/; applies no change.
model: opus
---
```

### Step outline

- **Step 0 — Input resolution + multi-idea split.** Notes from `$ARGUMENTS` or the pasted block. Multiple distinct ideas → pick strongest (decision-point posture, state pick + runner-up), process it, record the rest under `## Deferred Ideas`.
- **Step 1 — Distill Idea Brief (inline).** 5 fields: Core idea / Problem it solves / Claimed benefits / Constraints & assumptions / Source. Workspace-assertion claims in the notes get tagged for verification, not accepted.
- **Step 2 — Fast-path gates (inline, pre-subagent).** Duplicate gate (glob/grep commands, SKILL.md frontmatter, agents — exact duplicate → point to existing resource + `/improve-skill`, end, no files). Triviality gate (≤1-file cosmetic → recommend `/tweak`, end, no files).
- **Step 3 — Path setup.** `ANALYSIS_PATH = audits/working/{DATE}-idea-{SLUG}.md`; `NOTES_PATH = ...-investigation.md` (subagent plumbing). Slug algorithm per `/resolve-repo-problem`; `-2`/`-3` de-dupe.
- **Step 4 — Investigation (ONE general-purpose subagent, inline brief).** Receives the distilled Idea Brief only — never the raw dump. Part A: use-case evidence from `logs/friction-log.md`, `improvement-log.md`, `session-notes.md`, `defect-log.md`, recent `audits/` headers — cite entries or say "no evidence found", never infer. Part B: repo surface — existing resources touching this space, candidate attach points with paths; **search semantically (by capability/purpose), not just name-match** — this is the backstop for near-duplicates that Step 2's mechanical gate misses across ~70 skills / ~49 commands (SO-N1). Contract: full notes → `{NOTES_PATH}` with fixed headings `## Idea Brief (as received)` / `## Use-Case Evidence` / `## Repo Surface & Attach Points` / `## Investigator Observations`; return ≤30 lines ending `NOTES: {NOTES_PATH}`. One re-invoke on malformed return.
- **Step 5 — Leverage options (inline, the heart).** 2–4 options from the lever menu: extend existing resource / new command-agent / CLAUDE.md rule or doc / hook / park. Must be distinct levers, not size variants. Per-option block: 1–2 sentence shape + attach point, then Fit / Effort (S-M-L) / Risk (incl. `/risk-check` class if matched per `docs/audit-discipline.md`) / Evidence (cited or "speculative"). One Ranking line.
- **Step 6 — Recommendation + verdict (inline).** Recommended option + main rejected alternative, one line each. Verdict: WORTH-DOING / MARGINAL / NOT-WORTH-DOING (reuses `/implementation-triage` vocabulary). No evidence ≠ auto-fail, but verdict must flag the value case as speculative. MARGINAL-with-no-evidence or NOT-WORTH-DOING → PARK path. **Command body states explicitly: this is a routing verdict, not context-isolated ROI certification — for big/contested calls the operator can chain `/implementation-triage` for an independent read** (SO-N2 watch-item).
- **Step 7 — Implementation plan (skip on PARK).** Target files / Step sequence / Gates (`/risk-check` class if matched; `/qc-pass`) / Effort / Open assumptions. New-skill recommendation → embed the inbox brief verbatim in `/request-skill` format, ready to copy to `inbox/` on approval (command itself never writes `inbox/`). **Stop here.**
- **Step 8 — PARK path.** Append `logged (pending)` entry to `logs/improvement-log.md` per its schema; `Review-cycle:` trigger must be concrete (date/quarter/event), never "later" — **hard requirement in the command body, not a guideline; verify the entry schema against `/resolve-improvement-log`'s expected format while writing the command** (SO-3).
- **Step 9 — Write the analysis file** (`{ANALYSIS_PATH}`): Idea Brief / Evidence Findings (from subagent summary — do not re-read full notes) / Repo Surface / Leverage Options / Recommendation & Verdict / Implementation Plan or Park Rationale / Deferred Ideas / footer citing `{NOTES_PATH}`.
- **Step 10 — Chat report + handoff bridge.** Verdict line, recommendation + rejected alternative, `Analysis: {ANALYSIS_PATH}`, exactly one advisory bridge line (below). Bridge never auto-invokes.

### Handoff matrix

| Recommendation | Bridge |
|---|---|
| New skill | `/create-skill` — inbox brief drafted in analysis file, copy to `inbox/` on approval |
| New command / agent / hook / structural class | Plan's Gates section names the `/risk-check` class; bridge repeats it |
| Extend existing resource (non-class) | Plan is the execution spec — run on approval / follow-up session |
| PARK | Logged to `improvement-log.md` with concrete Review-cycle trigger |
| Tiny tweak (Step 2) | `/tweak "..."` — chat only |
| Duplicate (Step 2) | Point to existing resource + `/improve-skill` — chat only |

### Edge cases encoded in the body

Tiny/obvious idea (Step 2 fast path, no subagent spend) · duplicate (short-circuit; partial overlap → extend-existing option) · multiple ideas (Step 0 split) · no workspace evidence (speculative, not auto-PARK) · idea targets another tool (cross-model rules: options carry tool assignments) · very long paste (inline distill, brief-only to subagent).

## Reference files (precedents to mirror while writing)

- `ai-resources/.claude/commands/resolve-repo-problem.md` — subagent brief shape, notes contract, slug/path setup, bridge pattern
- `ai-resources/.claude/commands/implementation-triage.md` — verdict vocabulary
- `ai-resources/.claude/commands/request-skill.md` — inbox-brief format for the new-skill handoff
- `ai-resources/logs/improvement-log.md` — PARK entry schema
- `ai-resources/docs/audit-discipline.md` — risk-check change-class list

## Gates & verification

0. **EP-0 — DONE 2026-06-12 at session wrap** (advisory relocated to the consultations path; verify it exists, then skip): move the stranded SO advisory from `~/.claude/plans/let-s-build-a-process-witty-sparkle-agent-ad312c09f2923cb95.md` to `projects/axcion-ai-system-owner/output/consultations/consult-2026-06-12-leverage-idea-command.md` (plan mode blocked the canonical write). Create the `consultations/` directory if missing; if the move fails, surface it — do not lose the advisory.
1. **Post-approval:** `/blindspot-scan` fires (new command = risk-check change class) — resolve PAUSE-AND-FIX findings before writing.
2. **Pre-landing:** `/risk-check` on the new command (change class: new command), then `/qc-pass` on the written file.
3. **Post-landing (SO-2):** append a `/leverage-idea` row to the System Owner's `toolkit-relationship.md` § 5 in the same commit — otherwise future SO consultations silently mis-ground on a stale toolkit map.
4. **Functional verification:** first live run uses Patrik's real example note dump — confirms Step 0 split, Step 1 distillation on a multi-page paste, and that the analysis file ends in an executable plan. (Patrik offered an example; use it as the live test.)
5. Commit: `new: leverage-idea — idea dump → leverage options + worth-doing verdict` (+ toolkit-relationship row).
