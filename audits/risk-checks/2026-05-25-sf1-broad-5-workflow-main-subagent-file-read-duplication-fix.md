# Risk Check — 2026-05-25

## Change

SF1 broad — 5-workflow main↔subagent file-read duplication fix. Scope: edit 5 command files across 3 project scopes + ai-resources. Changes per workflow:

1. /systems-review SR1 — replace main-session Read(systems-thinking-for-claude-code.md) with Glob/test-f existence check.
2. /consult CON2 — remove main-session Read of reference file(s) forwarded verbatim to system-owner subagent; change subagent brief to pass by path.
3. /architecture-review AR1 — remove main-session Reads of 2–4 audit files re-embedded verbatim in subagent brief; change brief to reference by path.
4. /analyze-transcript AT1 — remove Step 7b main Read of repo-architecture.md; update Step 7d brief to reference by path (system-owner subagent reads it per its grounding map).
5. /friday-act FA1+FA2 — Step 16a reads SO Advisory + Systems Review + per-project session-notes/friction-log in main (display-for-paste, no reasoning); delegate to a pre-summarizing subagent writing summary to disk + returning ≤30-line path summary.

All edits guided by 2026-05-25 token-audit findings (ai-resources, axcion-ai-system-owner, ai-development-lab). No edits to compaction-protocol.md. Per-workflow commits planned, end-time risk-check before wrap for the FA1+FA2 new-subagent change specifically.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-act.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/.claude/commands/consult.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/.claude/commands/architecture-review.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/.claude/commands/systems-review.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/.claude/commands/analyze-transcript.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The 4 mechanical edits (R1.a/b/c + AT1) are low-risk per-command body edits with no contract change; the FA1+FA2 component introduces a new subagent dispatch whose pre-summary→paste-prompt contract is the only structural risk in the bundle — mitigations are required for blast radius and hidden coupling on that one component.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded file is touched. The 5 edits land in `.claude/commands/*.md` bodies, which load only at command invocation, not per session. Evidence: token-audit-2026-05-25-ai-resources.md § 3 — "Commands only load on invocation … full body loads when invoked."
- Net effect is a **reduction** in usage cost, not an increase. Each fix removes a delegable read from main; FA1+FA2 alone saves ~2,600–15,600 tokens per Friday session per the audit (token-audit-2026-05-25-ai-resources.md line 353, "Estimated savings: HIGH — 2,600–15,600 tokens/Friday session, weekly").
- New subagent for FA1+FA2 will be invoked only inside `/friday-act` Step 16a (weekly cadence, frequency-bounded). No always-loaded auto-fire path.
- No new `@import` chain. No new hook. No new skill with broad keyword pattern.

### Dimension 2: Permissions Surface
**Risk:** Low

- `CHANGE_DESCRIPTION` contains no settings.json or hook edits. All 5 edits are command-body edits.
- The new FA1+FA2 subagent needs `Read`, `Glob`, and `Write` (write-to-disk for the working-notes summary). These are already-granted tools to existing analogous agents (e.g., `dd-log-sweep-agent.md`, `findings-extractor.md`). No new tool family is unlocked.
- The agent's `Write` scope is constrained to `audits/working/...` per the existing Subagent Contracts pattern (ai-resources/CLAUDE.md § Subagent Contracts, lines 34–40). No deny rule removed; no new external API access.

### Dimension 3: Blast Radius
**Risk:** Medium

- **5 files edited** across 3 scopes:
  - `ai-resources/.claude/commands/friday-act.md` (FA1+FA2, Step 16a)
  - `projects/axcion-ai-system-owner/.claude/commands/consult.md` (CON2, Step 3+4)
  - `projects/axcion-ai-system-owner/.claude/commands/architecture-review.md` (AR1, Step 3+4)
  - `projects/axcion-ai-system-owner/.claude/commands/systems-review.md` (SR1, Step 2)
  - `projects/ai-development-lab/.claude/commands/analyze-transcript.md` (AT1, Step 7b+7d)
- **Plus 1 new file** for FA1+FA2: `ai-resources/.claude/agents/friday-act-step16a-summarizer.md` (or similar — the new pre-summarizing subagent).
- **Caller enumeration for the 4 R1-pattern edits.** The contract being changed is the subagent brief shape that the `system-owner` agent receives. Grep across ai-resources confirms `system-owner` is invoked from 6 commands: `/consult`, `/architecture-review`, `/implementation-triage`, `/systems-review`, `/friday-so`, `/so-monthly`, and inline by `/analyze-transcript` Step 7d. The 4 R1-pattern edits affect 3 of these caller sites (`/consult`, `/architecture-review`, `/systems-review`, `/analyze-transcript`), but the contract change is **backward-compatible**: replacing "embed file content verbatim" with "reference file by path" relies on the system-owner agent's Function B/C/E grounding map, which already reads those files (`projects/axcion-ai-system-owner/references/grounding.md` lines 62, 93–99, 178 confirm Function B reads `repo-architecture.md` and Function E reads `systems-thinking-for-claude-code.md` as primary grounding sources).
- **FA1+FA2 caller enumeration.** `/friday-act` Step 16a is called inside the weekly Friday cadence; no other command invokes Step 16a directly. The new subagent is one new dispatch site. Downstream coupling: Step 16b paste-prompt regex `^\[(high|med|low)\] .+$` consumes the operator's pasted lines (not the subagent's summary directly), so the summary→paste-prompt seam is operator-mediated, not regex-mechanical — see Hidden Coupling.
- **Shared infra touched:** none for R1.a/b/c + AT1 (no log files, no settings, no CLAUDE.md). FA1+FA2 adds one new file under `.claude/agents/` and one new working-notes pattern under `audits/working/`.
- The blast-radius rating is Medium (not Low) because 5 files in one bundle plus 1 new agent file crosses the "single isolated file" threshold; but no caller requires modification — the contract changes are backward-compatible.

### Dimension 4: Reversibility
**Risk:** Medium

- The 4 R1-pattern edits (R1.a/b/c + AT1) are clean `git revert` cases — single-file body edits with no sibling artifacts. Per-workflow commits (as planned in `logs/session-plan-pass4.md` Execution Sequence steps 3–10) make each edit individually revertable.
- FA1+FA2 creates a **new file** (the pre-summarizing subagent definition under `.claude/agents/`). `git revert` of the FA1+FA2 commit removes both the friday-act.md edit AND the new agent file together, IF both were staged in the same commit. The session plan calls for "Commit FA1+FA2" as a single commit (step 12), so revert is clean — verify both files are staged in the same commit before pushing.
- The new subagent will write to `audits/working/friday-act-step16a-{DATE}.md` on first invocation. These working-notes files are session-output artifacts; a revert of the code change does NOT remove already-generated working-notes. This is a one-step cleanup, not a load-bearing concern (working-notes are stale on revert but harmless).
- Concurrent-session activity: `git status` shows `logs/session-notes.md` and `logs/session-plan.md` modified by other sessions. Per-workflow commits limit blast radius if a revert is needed mid-bundle — confirmed by the session plan's per-commit verification step (step 4, 6, 8, 10, 12).
- No external writes (no push, no Notion, no API POST). No automation auto-fires between landing and a potential revert — the new subagent is dispatch-only from `/friday-act`, not hook-fired.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **R1.a/b/c (consult, architecture-review, systems-review) — Low coupling.** The contract being shifted is "embed file content in subagent brief" → "reference file by path." The system-owner agent's grounding.md already enumerates the files Function B and Function E read (lines 62, 93–99). The change relies on the agent honoring its own grounding map — an established repo convention, explicitly documented at the change site (the agent's Phase 3 procedure). One implicit dependency, documented. Per change-site coupling, this is Low.
- **AT1 (analyze-transcript) — Low coupling, same as above.** Step 7d brief change relies on the system-owner agent reading `repo-architecture.md` per Function B grounding — already documented and reproducible from the agent definition (system-owner.md lines 43–44). The audit's R2 implementation step verbatim names this rationale: "The system-owner subagent will read it once, in subagent context, where it belongs" (token-audit-2026-05-25-project-ai-development-lab.md line 263).
- **FA1+FA2 — Medium coupling.** Three implicit-dependency vectors:
  1. **Pre-summary contract is new.** The pre-summarizing subagent returns a ≤30-line summary that the main session displays for operator-paste. The downstream regex (`^\[(high|med|low)\] .+$` in Step 16b/16c) consumes operator paste, not the summary directly — the summary is operator-readable prose. Coupling vector: the summary must remain rich enough for the operator to extract `[risk] {text}` lines from. If the summary is too compressed, the operator paste rate drops; if too verbose, the cap-at-30-lines contract is violated. This is the prior risk-check's primary concern (2026-05-25-plan-time-risk-check-on-token-audit-r1-fix-to-friday-act-step-16a.md verdict).
  2. **`PROJECT_LOG_BUNDLES` enumeration depends on the `## Scopes audited` parse at Step 1.5.** The new subagent must consume the same list. Implicit contract — if the orchestrator-side enumeration changes, the subagent's input shape silently breaks. Documented at the change site (friday-act.md Step 1.5 lines 72–82) — mitigation feasible.
  3. **Function-overlap check.** No existing subagent already covers Step 16a — `findings-extractor`, `dd-log-sweep-agent`, and others operate on different inputs. No silent dual-handling concern.

## Mitigations

- **Mitigation for Dimension 3 (blast radius) — per-workflow commits.** Session plan already specifies one commit per workflow (steps 4, 6, 8, 10, 12). Stage and commit each fix independently before moving to the next. Verify each commit boundary with the 1-grep verification noted in the session plan's Autonomy Posture § Stop points. Do NOT bundle all 5 edits into one commit — this would multiply revert cost if any one edit shows regression.
- **Mitigation for Dimension 4 (reversibility) — stage agent file and friday-act.md edit together in the FA1+FA2 commit.** Confirm `git status` shows both `.claude/agents/{new-summarizer}.md` AND `friday-act.md` staged before running `git commit`. A revert is clean only if the new file lands in the same commit as the dispatch-site edit.
- **Mitigation for Dimension 5 (hidden coupling, FA1+FA2 only) — document the pre-summary contract at the change site.** The new subagent's body must explicitly state (a) the summary cap (≤30 lines per scope per ai-resources/CLAUDE.md § Subagent Contracts, tighter 20-line cap if per-project invocation proliferates), (b) the operator-paste-suitability requirement (each section must surface enough detail for the operator to extract `[risk] {text}` paste lines), (c) the input shape (`SO_ADVISORY_PATH`, `SO_REVIEW_PATH`, `PROJECT_LOG_BUNDLES`, working-notes path). Mirror the existing pattern from `dd-log-sweep-agent.md` and `findings-extractor.md` — these are explicitly named as templates in the prior FA1-only risk-check (2026-05-25-plan-time-risk-check-on-token-audit-r1-fix-to-friday-act-step-16a.md line 14).
- **Mitigation for Dimension 5 (hidden coupling, all 4 R1-pattern edits) — verify grounding-map alignment at edit time.** For each of R1.a/b/c + AT1, before committing, grep the system-owner agent's grounding.md to confirm the file being referenced-by-path is in the function's grounding map for the active call site (Function B for consult + analyze-transcript Step 7d, Function C for architecture-review, Function E for systems-review). If a brief references a file the grounding map does not name, the subagent will not read it — silent failure mode.
- **Mitigation for Dimension 5 (hidden coupling, FA1+FA2) — run end-time `/risk-check` on the FA1+FA2 commit specifically.** The session plan already specifies this (step 13). The new-subagent-dispatch class is on the canonical `/risk-check` change-class list (ai-resources/docs/audit-discipline.md § Risk-check change classes line 22 — "New commands or skills"; subagent definitions are new-resource-class in practice).

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, audit-finding cross-references). No training-data fallback was used. Specifically:
- Function B/C/E grounding map confirmed at `projects/axcion-ai-system-owner/references/grounding.md` lines 62, 93–99, 178.
- Subagent contract (≤30-line cap, write-to-disk) confirmed at `ai-resources/CLAUDE.md` lines 34–40.
- FA1+FA2 token-savings range confirmed at `token-audit-2026-05-25-ai-resources.md` lines 350–354.
- AT1 triple-touch and fix specification confirmed at `token-audit-2026-05-25-project-ai-development-lab.md` lines 108, 259–263.
- SR1/CON2/AR1 findings confirmed at `token-audit-2026-05-25-project-axcion-ai-system-owner.md` lines 216, 236, 256, 296–301.
- The 6 system-owner callers enumerated by grep across `ai-resources/.claude/commands/` and `projects/*/.claude/commands/`.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

# Pre-Change Advisory — SF1 Broad (5-workflow main↔subagent read-duplication fix)

## Concurrence with PROCEED-WITH-CAUTION

We concur with PROCEED-WITH-CAUTION. The verdict shape is correctly calibrated: 4 of the 5 components are mechanical contract-cleanup edits with no structural risk; FA1+FA2 is the only structural component in the bundle because it introduces a new canonical agent file under `ai-resources/.claude/agents/`. That single component is a `/risk-check` change class (DR-8; `audit-discipline.md` — "New commands or skills"), and the surrounding mechanical edits are not. Bundling them under one verdict is sound because the mechanical edits ride the same execution session.

The architectural framing the verdict rests on is also correct:

- **Net direction is toward Lean** — every R1-pattern edit removes a redundant main-session read and relies on the receiving subagent honoring its documented grounding map. This is in alignment with `system-doc.md § 2.5 Design Constraints` ("every always-loaded file costs context on every turn — leaner is better") and the Subagent Contract pattern in `ai-resources/CLAUDE.md`.
- **Contract changes are backward-compatible by design** — the system-owner agent's per-function read map (`projects/axcion-ai-system-owner/references/grounding.md § 2`) already names every file being shifted from main-embedding to path-passing. The mechanical edits do not change the contract; they remove a violation of it (main was duplicating the agent's own grounding reads).
- **Routing position is correct** — the new pre-summarizing subagent canonical home is `ai-resources/.claude/agents/<name>.md` per Q2 of `repo-architecture.md`, with auto-symlink distribution to projects via the SessionStart hook (subject to manifest opt-out). Q3 confirms the "command + subagent (≤30-line summary, full notes to disk)" spawn shape — the new agent serves `/friday-act` Step 16a, not a new top-level command. This matches the existing pattern (`dd-log-sweep-agent`, `findings-extractor`).

## Concurrence with the 5 mitigations

The recommended mitigation path is the right one. All five mitigations are load-bearing for this bundle; none is excess scope. Specifically:

1. **Per-workflow commits** (Dim 3) — correctly addresses blast radius. Aligns with `risk-topology.md § 5` signal "Project-local files (not referenced by shared infra) → zero-risk"; per-commit granularity preserves that property at revert time.
2. **Stage agent file + friday-act.md together in the FA1+FA2 commit** (Dim 4) — correctly addresses reversibility. The new-agent-file class falls under DR-8 / `audit-discipline.md` "New commands or skills"; the stage-together rule is what makes `git revert` clean for that class.
3. **Document the pre-summary contract at the change site** (Dim 5, FA1+FA2) — correctly addresses the only genuine structural coupling in the bundle. The pre-summary→operator-paste→Step 16b/c regex seam is a multi-end implicit contract (`risk-topology.md § 5` "string literal matched by another component (two-end contract)"). Mirroring the `findings-extractor` / `dd-log-sweep-agent` precedent is the right template.
4. **Verify grounding-map alignment per R1 edit** (Dim 5, R1-pattern edits) — correctly addresses the only failure mode in the mechanical edits: a brief that references a file the receiving function's grounding map does not name. This is a silent-failure class (the subagent would not read it; nothing would error visibly); the pre-commit grep against `grounding.md` is the right test.
5. **End-time `/risk-check` on FA1+FA2 commit specifically** (Dim 5) — required by DR-8 two-gate firing model. The mechanical edits do not require an end-time fire of their own (they are not on the canonical `/risk-check` change class list, as the report itself notes); FA1+FA2 does, because it introduces a new canonical agent file (`audit-discipline.md` § Risk-check change classes — "New commands or skills").

The mitigations as a set are necessary AND sufficient given the dimension findings. Nothing in them is goldplating.

## Risks the dimension review may have under-weighted

Two notes — neither escalates the verdict, but both deserve to be visible during execution.

**(a) Auto-sync coverage of the new agent file.** The new `friday-act-step16a-summarizer.md` (or chosen name) lands in `ai-resources/.claude/agents/` and will auto-symlink to every project at next SessionStart per `repo-architecture.md` § Symlink topology. The hook is well-behaved (existing files never overwritten; project shared-manifest opt-out respected), but the agent's name MUST NOT collide with the baked-in exclusion globs (`EXCLUDE_AGENT_GLOBS = "pipeline-stage-* session-guide-generator"`) — confirm name does not match those patterns before committing. (`repo-architecture.md` § Symlink topology, sync rule 3.) The risk-check did not name this explicitly; the mitigation is one-line — grep the agent name against the exclusion globs before commit.

**(b) `friday-act.md` is on the High risk-topology tier.** `risk-topology.md § 1 (High — workstream-wide effect if broken)` does not list `friday-act.md` by name, but `friday-checkup.md` is named as Critical and `friday-act.md` is its execution-side counterpart in the same maintenance cadence. The Dim 5 mitigation for FA1+FA2 (document the pre-summary contract at the change site) is the right primary mitigation, but a one-line note in the friday-act.md commit message identifying which Step (16a) gained a delegated subagent will help future audits trace the change without having to diff. This is `QS-7` voice (explain why) applied to a load-bearing-adjacent edit.

Neither (a) nor (b) changes the verdict or the mitigation set. They are visibility additions.

## Position

The right answer is to proceed with the five mitigations as documented. The bundle is correctly scoped (mechanical cleanup + one structural component), correctly mitigated (per-workflow commits + stage-together + contract-at-site + grounding-map verify + end-time risk-check), and the net direction is toward Lean (`system-doc.md § 2.5`) without violating any DR-7/AP-7 boundary — the new subagent has a confirmed single consumer (`/friday-act` Step 16a) and is therefore not speculative abstraction.

Add the two visibility items above to the execution checklist:
- Pre-commit grep of the new agent name against `EXCLUDE_AGENT_GLOBS`.
- One-line "Step 16a now delegates to {agent}" identifier in the FA1+FA2 commit message.

Proceed.

---

**Files cited:**
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/vault/principles/principles.md` (DR-7, DR-8, AP-7, QS-7)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/vault/architecture/risk-topology.md` (§ 1 Critical/High; § 5 Safe Change Zones)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/vault/architecture/system-doc.md` (§ 2.5 Design Constraints)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/repo-architecture.md` (Q2, Q3, Q5, Symlink topology, Cross-repo coupling)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/risk-checks/2026-05-25-sf1-broad-5-workflow-main-subagent-file-read-duplication-fix.md` (full report)
