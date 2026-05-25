# Risk Check — 2026-05-25

## Change

Plan-time risk-check on token-audit R1 fix to `/friday-act` Step 16a.

**Proposed change:** Extract the main-session read-and-display logic in `/friday-act` Step 16a (lines 158-178 of `ai-resources/.claude/commands/friday-act.md`) into a new pre-summarizing subagent.

**Current state:** Step 16a runs in main session and (a) greps SO Advisory for `## Recommendation`/`## Observation` sections and displays each in full (~50-200 lines), (b) greps Systems Review for `## Leverage Point` sections and displays in full (~50-200 lines), (c) for each scoped project in `PROJECT_LOG_BUNDLES`: reads `improvement-log.md` filtered to active entries + `session-notes.md` last 3 entries + `friction-log.md` last 5 entries (~100-400 lines per project, typically 2-3 projects).

**Total main-session cost:** ~500-1500 lines per friday-act session (~2,600-15,600 tokens). Source: `ai-resources/audits/token-audit-2026-05-25-ai-resources.md` § 9.2 HIGH (R1).

**Proposed new shape:**
1. Create new agent `friday-act-step16a-summarizer` at `ai-resources/.claude/agents/friday-act-step16a-summarizer.md`. Model: haiku or sonnet (mechanical-pattern read-and-summarize). Tools: Read, Glob, Bash, Write. Inputs: SO_ADVISORY_PATH, SO_REVIEW_PATH, PROJECT_LOG_BUNDLES, WORKING_DIR, DATE. Behavior: applies the existing section-grep logic, writes full per-scope notes to `audits/working/friday-act-step16a-{DATE}.md`, returns ≤30-line per-scope paste-ready summary (path anchor + section titles + per-project active-entry counts + 1-line per most-recent friction entry). Follows existing subagent contracts (cap-at-30-lines, write-to-disk, summary-only — `dd-log-sweep-agent.md` and `findings-extractor.md` are existing templates).
2. Replace lines 160-178 of `friday-act.md` Step 16a with a single subagent dispatch + display of the returned summary. The 16b paste-prompt loop downstream is unchanged.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/friday-act-step16a-summarizer.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-act.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/token-audit-2026-05-25-ai-resources.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/dd-log-sweep-agent.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/findings-extractor.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The refactor is well-scoped and saves a documented 2.6k-15.6k tokens per weekly run, but it introduces an undocumented new subagent contract (input shape + paste-ready summary format) whose downstream consumer (the 16b paste-prompt and 16c regex validation) requires the summary to remain operator-paste-suitable — one Medium-risk hidden-coupling concern needs a paired mitigation.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The new agent file lives in `ai-resources/.claude/agents/` — agent definitions load only when dispatched, not at every session start. Evidence: existing agent files in that directory (`dd-log-sweep-agent.md`, `findings-extractor.md`, plus 25 others enumerated by `ls ai-resources/.claude/agents/`) follow the same on-demand load pattern; no auto-load hook or `@import` proposed.
- No CLAUDE.md edits proposed (CHANGE_DESCRIPTION: "No CLAUDE.md changes. No settings.json changes. No hook changes.").
- No SessionStart, Stop, PreToolUse, UserPromptSubmit hook added.
- Net token effect on `/friday-act` invocation: main-session reduction of ~2,600-15,600 tokens/Friday session per `token-audit-2026-05-25-ai-resources.md` line 353 ("HIGH — 2,600–15,600 tokens/Friday session, weekly"). The new agent body (~80-120 lines per CHANGE_DESCRIPTION) loads only when Step 16a fires, replacing reads that were previously larger.
- Frequency is weekly (`/friday-act` cadence); not a per-tool-call or per-turn cost path.

### Dimension 2: Permissions Surface
**Risk:** Low

- CHANGE_DESCRIPTION explicitly: "No settings.json changes. No hook changes."
- Agent's declared tools (`Read, Glob, Bash, Write`) are the same set the main session already uses for these reads. No new tool family introduced.
- Writes are scoped to `audits/working/friday-act-step16a-{DATE}.md` — already an established write surface for working notes (see existing files in `audits/working/`: `audit-claude-md-working-notes-*.md`, `audit-critical-resources-working-notes-*.md`).
- No cross-repo writes; no external API; no MCP. Project-internal log reads stay within `{WORKSPACE}/projects/{name}/logs/` (same scope the main session already reads).

### Dimension 3: Blast Radius
**Risk:** Low

- Files touched directly: 2 (NEW agent file; EDIT `friday-act.md` lines 158-178). Per CHANGE_DESCRIPTION's "Files affected" list.
- Callers of the affected code path: `grep "Step 16a\|step16a" ai-resources/.claude` returned 2 references, both in `friday-act.md` itself (lines 427 and 428 — the Notes section). No external command or skill dispatches into Step 16a from outside.
- The schema-contract referenced by downstream sub-steps (16b/16c regex `^\[(high|med|low)\] .+$`) is preserved (CHANGE_DESCRIPTION explicit). The `/friday-journal` ↔ `/friday-act` schema-contract at line 154 (Items section regex) is unaffected — Step 16a deals with paste-source display, not the regex itself.
- Downstream sub-steps 16b/16c/16d/16e (paste prompt, validation, disposition, RESULTS append) read the OPERATOR's paste, not the summary directly. The summary feeds operator judgment, not a machine consumer. So contract change is one-sided (display only) and backwards-compatible.
- `PROJECT_LOG_BUNDLES`, `SO_ADVISORY_PATH`, `SO_REVIEW_PATH` variables — used in 13 places across `friday-act.md` per the grep. The subagent consumes them but does not redefine them; producer-side (Step 1.5) unchanged.
- Two callers in the Notes section (lines 427, 428) describe Step 16a behavior; both should be updated to reflect the delegation but neither is load-bearing for execution.

### Dimension 4: Reversibility
**Risk:** Low

- Revert path: one `git revert` on the commit restores the inline reads in `friday-act.md` and deletes the new agent file. CHANGE_DESCRIPTION: "revert is one git commit (restore the inline reads in friday-act.md + delete the new agent file)."
- No settings.json, CLAUDE.md, or hook state to clean up.
- Working-notes files written to `audits/working/friday-act-step16a-{DATE}.md` are session-output artifacts; if revert happens after a Friday run, the working file is residual but does not affect future sessions (it's date-stamped and not re-read).
- No external writes (no `git push`, no Notion, no API).
- No operator muscle-memory change: operator still invokes `/friday-act` the same way; Step 16a still displays a summary; the paste-prompt at 16b is identical.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **New contract not yet documented in the change site.** The subagent's return-summary format (path anchor + section titles + per-project active-entry counts + 1-line per most-recent friction entry) is a new operator-facing contract. It must contain enough signal that the operator can decide what to paste at 16b. If the summary collapses too aggressively, the operator loses the context they currently see in full sections and may miss SO recommendations or recurring friction. CHANGE_DESCRIPTION acknowledges this failure mode: "if subagent returns malformed summary, the 16b paste-prompt loses helpful context but does not crash."
- **Coupling-by-naming with `dd-log-sweep-agent.md` and `findings-extractor.md` templates** — both are existing patterns, but they target different consumers (the `/repo-dd` audit summary and the `/friday-checkup` consolidated findings respectively). The new agent's consumer is an interactive operator paste-step, not a downstream report — so the templates' shape may not transfer cleanly. Specifically, `findings-extractor.md` returns text without disk-write (per its own line 36: "Return this output directly to the caller. Do not write to disk."), while `dd-log-sweep-agent.md` writes structured patterns. The new agent's design mixes both (write to disk + return summary). Defensible, but the contract design has not yet been validated against the 16b operator-paste use case.
- **Implicit dependency on Step 1.5 variable shape.** The new agent's inputs (`SO_ADVISORY_PATH`, `SO_REVIEW_PATH`, `PROJECT_LOG_BUNDLES`) are produced by Step 1.5. The current inline 16a logic also depends on this — but it reads them in the same execution context where they were just bound. Delegating to a subagent means the orchestrator must serialize these inputs into the subagent's prompt. `PROJECT_LOG_BUNDLES` is a list of records (`{project, improvement_path, session_notes_path, friction_log_path}` per line 80) — serializing this cleanly into a subagent input is straightforward but is a new contract that must be documented in the new agent's input spec.
- **No functional overlap with existing mechanisms.** The new agent does not duplicate any existing subagent (the closest, `dd-log-sweep-agent.md`, is scoped to `/repo-dd` per its line-3 description; `findings-extractor.md` is scoped to `/friday-checkup`).
- **Auto-firing risk: none.** The agent fires only when `/friday-act` Step 16a executes, weekly cadence; no hook auto-fire.

## Mitigations

- **Dimension 5 (hidden coupling, Medium → Low):** Document the subagent's return-summary schema explicitly in the new agent file's body, with at least: (a) the exact shape each scope contributes (SO Advisory, Systems Review, per-project), (b) the minimum signal-density requirement (e.g., "every SO recommendation section title must appear; every active improvement-log entry's headline must appear; friction entries summarized to 1 line each — operator must be able to identify paste-worthy items without re-reading the source"), (c) a fallback when sections are missing (mirror the existing fallback at `friday-act.md` line 164: "section-target match failed — falling back to 30-line peek"). Also update `friday-act.md` Notes section (lines 427, 428) to reflect that Step 16a now dispatches a subagent, and explicitly cite the new agent's contract path so future edits to either end stay in sync.
- **Dimension 5 (hidden coupling, paired structural mitigation):** Before landing, validate the summary shape against one real Friday's data — pick the most recent `friday-checkup-2026-05-22.md` cycle, mentally run the new agent's summary output against the 16b paste-decision, and confirm an operator with only the summary (not the full sections) would still surface the same SO-derived items they would from the current inline display. If the summary loses load-bearing signal, expand the schema before merging.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: `friday-act.md` line numbers (54, 62, 80-81, 154, 156-178, 192, 198, 426-428), `token-audit-2026-05-25-ai-resources.md` § 9.2 R1 (lines 346-357), `findings-extractor.md` line 36, `dd-log-sweep-agent.md` line 3, `audit-discipline.md` § Risk-check change classes line 24, grep counts (2 callers of "Step 16a" inside `.claude`, 13 references to the path variables across `friday-act.md`), and `ls` enumeration of `ai-resources/.claude/agents/` (27 existing agent files showing the on-demand load pattern). No training-data fallback used.

---

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

# Pre-change Advisory — `friday-act-step16a-summarizer` extraction

## Position

**Concur with PROCEED-WITH-CAUTION.** The refactor is sound — it directly serves OP-1 (compound AI value, reduce manual/cost burden) and OP-2 (automate execution, gate judgment) by removing 2.6k–15.6k tokens of main-session reading per weekly cycle while keeping the operator's paste-disposition gate at 16b unchanged. The single Medium-risk hidden-coupling concern is real, and the two recommended mitigations are necessary but not sufficient.

## Routing — concur

The routing baseline you passed in is correct. New agent at `ai-resources/.claude/agents/friday-act-step16a-summarizer.md` matches the canonical home (`principles.md § DR-3` — agents canonical home). Q3 routing heuristic applies cleanly: "Operator-invoked routing/diagnostic that doesn't need full context → command + subagent (≤30-line summary, full notes to disk)" — and Step 16a's reads (SO Advisory `Recommendation`/`Observation` sections, Systems Review `Leverage Point` sections, per-project logs) are exactly that shape. `findings-extractor.md` and `dd-log-sweep-agent.md` are the right templates: `findings-extractor` for the ≤30-line cap discipline (`ai-resources/CLAUDE.md § Subagent Contracts`); `dd-log-sweep-agent` for the per-source structured schema + write-to-disk pattern.

Note: `findings-extractor` is `model: haiku` and does not write to disk; `dd-log-sweep-agent` is `model: haiku` and does. The new agent needs the dd-log-sweep-agent's hybrid shape (write-to-disk + ≤30-line return), and the tier should be `sonnet` not `haiku` — the work here is *structured factual extraction with judgment about what's load-bearing for the paste-disposition* (per `principles.md § QS-5`: "Is the hard part deciding what should be done?" — yes, when triaging which Recommendation lines materially differ from the checkup tactical items). Haiku will likely strip signal the operator needs at 16b.

## Architectural commentary

**The change is correctly classified as DR-7 / AP-7 safe.** This is not speculative abstraction — the consumer (`/friday-act` Step 16b/16c paste prompt) is real, present, and has a documented schema contract (the `^\[(high|med|low)\] .+$` regex shared with `/friday-journal` Step 5, per `friday-act.md` line 154). DR-7 ("generalize only when a second confirmed consumer exists") is satisfied: the second consumer is the existing prompt; the extraction has not invented a new audience.

**Hidden coupling — concur it's Medium.** The Step 16a output is read directly by the operator and silently produces the input for Step 16b. The current full-section display gives the operator literal Recommendation/Observation/Leverage-Point text to paste from. A subagent that pre-summarizes can — without changing any string contract — degrade the *signal density* of what the operator sees, producing paste decisions that diverge from the current behavior. This is a behavioral contract, not a syntactic one, and that is exactly the failure mode `principles.md § AP-1` (silent conflict resolution) warns against and `risk-topology.md § 5` flags as "two-end contract" risk.

## Mitigations — both necessary; one third is required

**Mitigation 1 (document the return-summary schema in the agent file and cross-reference in `friday-act.md` Notes lines 427–428):** correct and required. The friday-act.md Step 16a already carries the spec for what content matters; the new agent file must restate that spec in producer-side prose so the contract lives at both ends (per the two-end-contract pattern already used in `friday-act.md` Step 2 schema callout and Step 3.5 sub-step 16f). `(risk-topology.md § 5 — string-literal two-end contracts; principles.md § AP-1)`.

**Mitigation 2 (validate against `friday-checkup-2026-05-22.md` before landing):** correct and required. This is the operationalization of `principles.md § DR-9` (top-3 command analysis before applying audit-derived changes) and `principles.md § QS-3` (verify against requirements before announcing complete) — adapted to this change class. The validation criterion you stated ("operator paste-decisions at 16b are unchanged versus the current full-section display") is the right one.

**Risk the dimension review missed — and the third mitigation:** the dimension review treated the change as a pure refactor. It is not. Step 16a is the *only* place the operator sees the SO advisory and systems-review content during the friday-act flow in compressed form; the full-section display is itself a check on the SO outputs' quality. A subagent in the middle means: if `/friday-so` or `/systems-review` ship a degraded advisory (wrong section names, missing Leverage Point heading, fallback note triggered), the operator now sees the *summarizer's* characterization of the degradation rather than the raw fallback. This couples three commands (`friday-so`, `systems-review`, `friday-act`) through a fourth artifact (the summarizer's output schema) — and the harness only catches drift when the operator notices a bad paste decision two steps later.

The required third mitigation: **the subagent must preserve and pass through the existing 16a fallback semantics verbatim** — the `(section-target match failed — falling back to 30-line peek; report may use unfamiliar section names)` note (friday-act.md lines 164 and 170) and the equivalent for friction-log (line 176). Specifically: when the source-side section match fails, the subagent returns the fallback note in its summary unchanged, does not paraphrase it, and does not try to "be helpful" by inferring what the missing section probably contained. Add an explicit instruction in the agent body and an assertion in the schema documentation. `(principles.md § OP-3 — loud failure over silent continuation; principles.md § AP-2 — fabrication when evidence is insufficient)`.

## Recommended actions before landing

1. Adopt the two operator-listed mitigations as written.
2. Add the third mitigation above: explicit fallback-passthrough rule in the agent body + schema doc.
3. Set the agent tier to `sonnet`, not `haiku`. Triage judgment is load-bearing here. `(principles.md § QS-5)`.
4. Validation step 2 should compare paste-decisions on *two* prior cycles, not one — `friday-checkup-2026-05-22.md` plus one earlier — because the 2026-05-22 cycle may not exercise the section-name-variation fallback path. If both cycles produce identical operator dispositions, land it. If they diverge, the schema needs more signal preserved.

The change is worth landing. Don't land it without (3rd mitigation + sonnet tier + two-cycle validation).
