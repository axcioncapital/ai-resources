# Session Plan — 2026-05-22

## Intent
Tackle as much of the `/open-items` backlog as possible — the 3 inbox briefs (codex-dd, /repo-review, workflow-diagnosis skill), the 2 actionable 2026-05-22 friction entries (scratchpad clock-skew, /friday-act QC gap), and the 6 improvement-log pending items. Produce a plan with scope alternatives; operator approves or adjusts.

## Class
mixed (design-dominant) — quick command-file edits (friction fixes + the note/friction-log trio) are execution; the inbox-brief builds (codex-dd command, workflow-diagnosis skill) are new-resource creation. Class chosen without a blocking question per Decision-Point Posture; operator may correct.

## Model
opus — match (active session model `claude-opus-4-7[1m]`; the inbox-brief builds are architecture-judgment work — "the hard part is deciding")

## Source Material
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/inbox/codex-second-opinion-brief.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/inbox/repo-review-brief.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/inbox/workflow-diagnosis.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/friction-log.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-act.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/note.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friction-log.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/friction-log-auto.sh
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/create-skill.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/ai-resource-builder/SKILL.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md (risk-check change classes)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/ai-resource-creation.md (workflow-diagnosis boundary doc target)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/questionnaire.md (codex-dd depends on it as framework file)

## Findings / Items to Address

**Group A — friction fixes (2 items; command-file edits, NOT a risk-check class)**
1. **A1 — scratchpad clock-skew misroutes `/prime`.** Scratchpad filenames are skewed ahead of real time; `/prime` Step 1b sorts lexically, so it surfaces a stale scratchpad as the resume point every session. [src: friction-log.md 2026-05-22 14:54]. *Note: the friction entry's fix option (a) "sort by mtime" directly contradicts the current `/prime` Step 1b spec, which forbids mtime sort with a stated rationale. Real fix is likely option (b) monotonic filename time source or (c) prune stale scratchpads — a fix-approach decision made during execution. If the chosen fix deletes existing scratchpads → Autonomy Rule #3 stop point.*
2. **A2 — `/friday-act` ships plan files without QC.** `/friday-act` has no `/qc-pass` stage; 8 plan files committed unreviewed this cycle, a real defect (4 wrong risk-check annotations) found only on operator catch. Add an automatic QC step at `/friday-act` Step 3.6. [src: friction-log.md 2026-05-22 14:14]

**Group B — note/friction-log trio (3 improvement-log items; command-file edits, bundled ~1h)**
3. **B1 — `/note` and `/friction-log` write incompatible session-header formats** (load-bearing fix of the trio — do first). `note.md` emits `### Session:` / `#### Friction Events`; the other writers emit `## Session —` / `### Friction Events` / `#### Write Activity`. Result: `/note friction:` always appends a duplicate block and never captures write activity. [src: improvement-log.md 2026-05-22]
4. **B2 — friction logging produces unusable stub entries** (e.g. literal "note this"). Add post-capture stub detection to `note.md` Step A + `friction-log.md` Step 3 — flag short/placeholder text with `[STUB — expand before next /improve]`. [src: improvement-log.md 2026-05-22]
5. **B3 — no mechanism ties a manual friction entry to its producing session/command.** Add lightweight context capture (last commit short-hash + session-note title) to `note.md` Step A + `friction-log.md` Step 3. [src: improvement-log.md 2026-05-22]

**Group C — codex-dd command build (inbox brief; NEW command → risk-check class)**
6. **C — build `/codex-dd`.** A single-shot command that invokes `codex exec` (read-only sandbox) against `audits/questionnaire.md` and writes Codex's findings to `reports/codex-dd-YYYY-MM-DD.md` — a different-model second-opinion auditor. Brief rates the build "small": one command file + one mechanical wrapper-prompt template. [src: inbox/codex-second-opinion-brief.md]. *The expensive pilot RUN (steps 5–6 of the brief's kickoff) is build-then-decide and is deferred — build the command, run only the cheap auth check + throwaway probe.*

**Group D — workflow-diagnosis skill build (inbox brief + 1 improvement-log item; NEW skill → risk-check class)**
7. **D — build the `workflow-diagnosis` skill via `/create-skill`** on `inbox/workflow-diagnosis.md` — a 3-phase command that converts operator artifact-review notes into a workflow-improvement diagnosis spec. Full `/create-skill` pipeline run. Folds in **improvement-log item #6** (workflow-diagnosis ↔ improvement-analyst boundary note added to `docs/ai-resource-creation.md`), which the triage said must ride with this build. [src: inbox/workflow-diagnosis.md; improvement-log.md 2026-05-22]

**Excluded from all scope tiers (with rationale — operator may move into scope)**
- **`/repo-review` command build** (inbox brief) — too heavy for a same-session bolt-on: judgment-layer command with destructive-ish live pipeline testing (creates temp projects) and an operational dependency graph. Warrants its own session.
- **Improvement-log items #4 + #5** (`/wrap-session` leaner; `permission-sweep-auditor` template-class) — already BOOKED for a dedicated 2026-05-26 session; the booking exists specifically to break the deferral cycle, and the `permission-sweep-auditor` item carries an unresolved open question (is an agent-definition edit a risk-check change class?) that should be settled first.
- **Deferred decision** (`/new-project` template rename) — trigger-bound; fires automatically on the next `/new-project` or `/permission-sweep` session, not standalone work.

## Execution Sequence
1. **A1** — decide the scratchpad-skew fix approach (note the `/prime`-spec conflict on the mtime option); edit `prime.md` Step 1b. *Verify: `/prime` selects the true-latest scratchpad given skewed filenames. If the fix deletes scratchpads → STOP for operator approval. Commit.*
2. **A2** — add a `/qc-pass` stage to `friday-act.md` Step 3.6 (after plan files written, before the maintenance-observations commit). *Verify: stage present, invokes `qc-reviewer`, gates before commit. Commit.*
3. **B1 → B2 → B3** — edit `note.md` + `friction-log.md` (B1 header-format unification first, then B2 stub detection, then B3 context capture). *Verify: `note.md` emits the identical session block as `friction-log-auto.sh`; stub + context logic present. One bundled commit (all touch the same 2 files). `/qc-pass` the bundle.*
4. **Plan-time `/risk-check`** — one run covering the NEW-resource items in the approved scope (codex-dd; + workflow-diagnosis if Max). Operator-gated per Autonomy Rule #9. Apply mitigations. *(`/risk-check` plan-time fires once — A1/A2/B are command-file edits, not a change class, and are excluded from the run.)*
5. **C — codex-dd** — verify `codex login` auth → cheap throwaway `codex exec` probe → decide output schema → write `.claude/commands/codex-dd.md` + wrapper-prompt template. `/qc-pass`. Commit. *Verify: command is single-shot, read-only sandbox, mechanical wrapper (no editorial framing). Pilot RUN deferred to operator.*
6. **(Max only) D — workflow-diagnosis** — run `/create-skill` on `inbox/workflow-diagnosis.md` through its pipeline gates (pick recommended option at each gate per Decision-Point Posture); add the boundary note to `docs/ai-resource-creation.md`; move the brief to `inbox/archive/`. `/qc-pass` per `/create-skill`'s own gates. Commit. *Verify: SKILL.md + command emitted; boundary doc updated; brief archived.*
7. **Session end** — `/qc-pass` anything not yet reviewed; offer push (operator approval, Autonomy Rule #2); `/wrap-session`; `/usage-analysis`. *If context is clearly constrained before this point, invoke Context-Constraint Deferral: stop, flag deferred items, do not rush.*

## Scope Alternatives
- **Min — CONFIRMED MANDATE (operator-approved 2026-05-22)** — Groups A + B only (items 1–5). All command-file edits; no new resources; no `/risk-check`; no subagents beyond `/qc-pass`. ~2–2.5 h. Clears 2 friction entries + 3 improvement-log items. Certain to complete. Execution Sequence steps 1–3 only; steps 4–6 (risk-check, codex-dd, workflow-diagnosis) are out of scope.
- **Recommended** — Min + Group C (codex-dd command build, items 1–6). One plan-time `/risk-check` for the new command; codex pilot RUN deferred. ~4–5 h. Clears 5 backlog items + 1 inbox brief built. Ambitious but completable in one session.
- **Max** — Recommended + Group D (workflow-diagnosis `/create-skill` run, items 1–7; also clears improvement-log item #6). ~7–9 h — **honest flag: this will likely exhaust context / hit compaction and need a continuation session.** The plan-time `/risk-check` (step 4) covers both new resources in one run.

## Autonomy Posture
Gated

**Stop points:**
- Plan-time `/risk-check` (step 4) — operator approval before building the new command/skill (Autonomy Rule #9).
- A1 — if the chosen scratchpad-skew fix deletes existing scratchpad files (Autonomy Rule #3 — file deletion outside session output scope).
- A1 — if the fix-approach decision cannot be resolved from the friction entry + `/prime` spec (the mtime option conflicts with the current spec) — surface the conflict, recommend, proceed per CLAUDE.md conflict rule.
- codex-dd (step 5) — if `codex login` auth fails, the command cannot be built/tested; stop and report.
- Session-end push — operator approval (Autonomy Rule #2).
- Context-constraint deferral — if approaching compaction, defer remaining items, flag in chat, do not rush.
- `[COST]` advisory — Max scope crosses ≥4 subagents and ≥8 artifacts (`/create-skill` pipeline + `/risk-check` + multiple `/qc-pass`). Emit and continue.

## Risk
Touches structural change classes — **codex-dd is a NEW command; workflow-diagnosis is a NEW skill** (both on the `audit-discipline.md` risk-check change-class list). Run `/risk-check` once after this plan is approved (plan-time gate, covers both new resources). Run it again before commit if the built artifacts diverge from what was risk-checked (end-time gate). The Group A + B items are edits to existing command files — per the 2026-05-22 decision in `decisions.md`, editing an existing command file is NOT a risk-check change class — and are excluded from the `/risk-check` run.
