# Improvement Log

## Schema

Each entry is a `### YYYY-MM-DD — {title}` block. Fields:

- **Status:** `logged` | `proposed` | `pending` | `applied YYYY-MM-DD`
  *De facto convention: all current unresolved entries use `logged (pending)` as a combined compound state. The `/friday-checkup` [STALE] detection rule (added 2026-05-06) matches this compound form — not `pending` alone. If entries are normalized to the single-token schema in future, update the [STALE] match string in `friday-checkup.md` Step 6 accordingly.*
- **Verified:** present when Status is `applied` and the operator has confirmed the fix is live. Both `Status: applied` AND `Verified:` are required for `/resolve-improvement-log` to classify an entry as resolved.
- **Age:** auto-computed from the header date by `/resolve-improvement-log`; surfaced when > 6 weeks without resolution.
- **Review-cycle:** for items not yet resolved — records the last review date and disposition (e.g., `reviewed 2026-04-24, deferred to next quarterly`).
- **Category:** broad classification (e.g., `Audit-recurrence prevention`, `command/skill`).
- **Proposal:** the proposed change.
- **Target files:** files to be edited when executed.

Resolved entries (Status: applied + Verified) are archived to `improvement-log-archive.md` via `/resolve-improvement-log`.

---

## Triage — 2026-05-22 (friday-act improvement-log plan, item 1)

Read-only triage of the 4 entries logged this friday-checkup cycle. No fixes executed.

- **Friction logging stub entry ("note this")** — MED. Bundle with the 2 entries below — all 3 touch `note.md` / `friction-log.md`; one ~1 h session. — **SHIPPED 2026-05-22 commit `3a7ad4c`; archived.**
- **/note + /friction-log incompatible session-header formats** — MED-HIGH. Load-bearing fix of the trio: the format mismatch makes `/note friction:` append duplicate blocks and silently drop write-activity capture. Do first in the bundled session. — **SHIPPED 2026-05-22 commit `3a7ad4c`; archived.**
- **No trigger/context on manual friction entries** — MED. Bundle with the 2 above. — **SHIPPED 2026-05-22 commit `3a7ad4c`; archived.**
- **workflow-diagnosis / improvement-analyst boundary doc** — MED, dependent. Do inside the `/create-skill` run that fulfills `inbox/workflow-diagnosis.md` — not standalone. — **Still pending** (entry retained below as `### 2026-05-22 — workflow-diagnosis skill brief overlaps improvement-analyst`).

Queue: one bundled `note.md` / `friction-log.md` session for the 3 friction-logging entries; the boundary-doc entry rides with the workflow-diagnosis skill build.

**Annotation 2026-05-25:** Three of four entries shipped same-day (2026-05-22, commit `3a7ad4c` — unified session headers, stub detection, context capture). Triage block retained as historical record of the friday-act planning process. Only the workflow-diagnosis boundary-doc entry remains active.

---

### Sequencing note (five entries combined)

Suggested three-session sequence:

- **Session 1 (rules, ~45 min):** Entry "Extend Model Tier rule to agents" + Entry "Codify subagent-summary cap + /usage-analysis discipline". Purely CLAUDE.md + one `/wrap-session` edit. Lowest risk, highest per-turn leverage. — **VERIFIED-DONE 2026-05-25:** Both source entries already codified by drift. Workspace `CLAUDE.md` § Model Tier names agents explicitly and references `docs/agent-tier-table.md` ("Extend Model Tier rule to agents" — done). `ai-resources/CLAUDE.md` § Subagent Contracts states the 30/20-line cap + notes-to-disk + summary-only rule and names existing implementations ("Codify subagent-summary cap" — done). `ai-resources/CLAUDE.md` § Session Telemetry codifies the `/usage-analysis`-every-substantive-session rule and `/wrap-session` prompt integration ("/usage-analysis discipline" — done). [FADING-GATE] pattern — booking was carried forward from when these rules did not yet exist; no edits required.
- **Session 2 (templates, ~1–2 hrs):** Existing entries — canonical project settings template + canonical project CLAUDE.md template. Touches `/new-project` pipeline + research-workflow templates. Before implementing, re-read the 2026-04-13 decision ("Commit Rules propagate by explicit copy") to confirm whether the inheritance workaround is still needed. — **VERIFIED-DONE 2026-05-25:** Templates extracted to `ai-resources/templates/` (settings template + 5 CLAUDE.md fragments + README); `/new-project` step 2 + step 4 rewired to consume via walk-up to `ai-resources/`; research-workflow CLAUDE.md aligned (2 within-section drift fixes; `## File Verification and Git Commits` preserved as workflow-local per risk-check mitigation #3). 2026-04-13 decision re-checked → **KEEP** (uneven per-project mirroring across 5 projects confirms inheritance still unreliable; rationale recorded in `templates/README.md`). Mitigations: plan-time `/risk-check` PROCEED-WITH-CAUTION + system-owner-added architecture-map update = 4 mitigations total; end-time `/risk-check` GO (all 5 dimensions Low). QC found bash-native substitution unsafe under apostrophes in description + agent global-substitution collision → swapped to python3 + mustache `{{NAME}}` / `{{PROJECT_DESCRIPTION}}` placeholders. Commits: `8b44015` (templates + arch map + cross-refs), `39b27b5` (`/new-project` rewire), `c692864` (research-workflow alignment), `54bf85b` (risk-check reports). Follow-on for a future session: `deploy-workflow.md:209` still carries an inline `CANONICAL_PERMS` literal — second consumer candidate for `templates/` unification.
- **Session 3 (detection + automation, ~45 min):** Entry "Add three questionnaire items to /repo-dd" + Entry "Pre-commit skill-size warning hook". Depends on Session 1 (Agent Tier Table) and Session 2 (canonical templates) landing first so the new questionnaire items have stable references. — Session 1 dependency satisfied (verified-done 2026-05-25); Session 2 dependency satisfied (verified-done 2026-05-25). — **VERIFIED-DONE 2026-05-25:** Both source entries shipped 2026-04-18 — commit `0962c0c` (source entries logged), commit `bbd2261` (`.claude/hooks/check-skill-size.sh` informational pre-commit warning at >300 lines), commit `e3f6dfe` (Prevention Session 3 wrap confirming "questionnaire + skill-size hook + broadened allowlist" both landed). Pre-commit hook present at `.claude/hooks/check-skill-size.sh` and wired in `.claude/hooks/pre-commit` lines 76–79. `/repo-dd` questionnaire concept present (command line 61). [FADING-GATE] pattern — booking carried forward through 2026-05-22 Sequencing note and 2026-05-25 dependency-satisfaction annotation when the underlying work had already shipped 5 weeks prior. No edits required.

### 2026-05-25 — Canonical scope-selection pattern doc (parked)
- **Status:** logged (pending)
- **Category:** process
- **Friction source:** cross-reference of friction 09:07 against existing /monday-prep and /friday-checkup scope-selection idioms — three different encodings across sibling commands
- **Proposal:** Create `docs/scope-selection-pattern.md` (reference the `/friday-checkup` Step 3 lines 82–95 as canonical pattern) and add a one-line pointer in `ai-resources/CLAUDE.md` under a "Command Conventions" section. Prevents the next audit-class command from inventing a fourth encoding. Triage verdict: park — N=2 pattern occurrences, premature to formalize; Finding 1 covers the concrete friction. Revisit when a third command needs the pattern.
- **Target files:** `docs/scope-selection-pattern.md` (new), `ai-resources/CLAUDE.md`

### 2026-05-25 — Pattern to watch: operator-caught review-class gaps (2 occurrences)
- **Status:** logged (pending)
- **Category:** process
- **Friction source:** friction-log 09:13 (B7 always-loaded skip) and 09:53 (risk-check existing-command exemption) — both caught by operator post-execution, not by /qc-pass or the plan
- **Proposal:** If the pattern recurs in the next 1–2 sessions (3+ total instances), add either (a) a review principle to `skills/ai-resource-builder/references/review-principles.md` ("When a command audits layer N, verify the candidate list includes the always-loaded layer above N") or (b) a /qc-pass checklist item for plan-time risk-class enumeration. Current count: 2 in one session — at watch threshold, below escalation threshold. No action this round.
- **Target files:** `skills/ai-resource-builder/references/review-principles.md` or qc-pass protocol (if escalated)

### 2026-05-25 — Extract shared rendering convention doc
- **Status:** logged (pending)
- **Category:** infrastructure
- **Friction source:** /session-start rendering fix (mandate confirmation) — current rendering rules (icon set + bold-label discipline + section-structure rules) are inlined in `session-start.md` Step 2 with a `<!-- TODO: extract to shared rendering convention -->` marker. One consumer today; deferred per DR-7 (generalize only when a second confirmed consumer exists).
- **Proposal:** When a second consumer appears (e.g., another confirmation-output command, or a friction event around `/prime` rendering inconsistency), extract the rules to `ai-resources/docs/rendering-conventions.md` and reference from `session-start.md` (replacing the inlined block) and `prime.md`. Side note: `/prime`'s output template currently uses plain-text labels (not bold inline) — minor inconsistency to harmonize in the same extraction session.
- **Target files:** `ai-resources/.claude/commands/session-start.md`, `ai-resources/.claude/commands/prime.md`, new `ai-resources/docs/rendering-conventions.md`

### 2026-05-28 — /session-start Step 0.5 mtime guard misses foreign writes that arrive DURING the Mandate Confirmation wait

- **Status:** logged — superseded by the broader 2026-05-28 entry below ("Concurrent sessions cause TOCTOU races on shared log files"); Phase 1 of the broader entry applied 2026-05-28. The narrow Step 2.5 patch proposed here is no longer the recommended fix; the structural per-session-marker approach replaces it. Retained for trace-history of how the problem was first observed.
- **Category:** session-issue
- **Source:** Surfaced live during axcion-brand-book session 2026-05-28 — operator explicitly attributed the trigger to "I start concurrent sessions."
- **Friction source:** /session-start Step 0.5 runs the concurrent-session mtime guard exactly once, immediately after Step 0's session-notes.md read and before Step 1 reads the mandate. It compares `SESSION_NOTES_MTIME` against `PRIME_MTIME` (or against `NOW - 120s` fallback) at that single instant. Today the guard returned `DELTA=0` (clean) at Step 0.5; Step 1 used the supplied mandate verbatim; Step 2 echoed the Mandate Confirmation block and waited for the operator's `y`. During that wait, the operator started a second /prime session, selected a different menu task (task 3 — backfill `_appendix/rejected_directions.md`), and that concurrent /prime wrote a `**Work (redirected via /prime task selection):**` line to logs/session-notes.md. The operator's `y` then arrived in the original session against the original (specimen) mandate echo — but session-notes.md by then contained the redirect line for the backfill task. The original session would have proceeded to Step 3 and written the specimen mandate alongside the foreign redirect line if the operator had not corrected the path via AskUserQuestion. Reproduction is reliable whenever a foreign session writes to session-notes.md between Step 0.5 (clean) and Step 3 (write).
- **Proposal:** Add a second mtime check at Step 3 immediately before locating today's header for the mandate-line write — call it "Step 2.5 — Re-check mtime guard at write time." Capture `WRITE_TIME_MTIME = stat session-notes.md` and compare to the `SESSION_NOTES_MTIME` value already captured in Step 0.5 (must persist that value into Step 3's scope). If `WRITE_TIME_MTIME > SESSION_NOTES_MTIME`, a foreign write happened during the Mandate Confirmation wait → surface a conflict block before applying the operator's confirmation: re-read the last ~20 lines of session-notes.md, show the diff to the operator, offer (1) proceed with the originally-confirmed mandate, (2) re-echo a new Mandate Confirmation reflecting whatever the foreign write redirected to, (3) stop. Default on no-response = (3) stop. Edits confined to `ai-resources/.claude/commands/session-start.md` (new Step 2.5 between Step 2 and Step 3). **/risk-check change class:** YES (canonical-command body edit; /session-start runs at every session start) — run /risk-check as advisory gate before landing. Secondary consideration: today's Step 0.5 tuning notes call out the 120s threshold and freshness window but do not anticipate the during-Step-2 window. Update the tuning-notes block in Step 0.5 to forward-reference the new Step 2.5 so operators reading Step 0.5 understand its coverage limit.
- **Target files:** `ai-resources/.claude/commands/session-start.md` (insert Step 2.5 between Step 2 and Step 3; update Step 0.5 tuning notes to forward-reference Step 2.5). Also worth considering: a one-line companion note in `ai-resources/.claude/commands/prime.md` Step 8a.3 reminding that the marker-write at Step 8a.3.a does not protect /session-start's Step 2 confirmation window.

### 2026-05-28 — Concurrent sessions cause TOCTOU races on shared log files (broader entry — supersedes the narrow `/session-start` Step 0.5 entry above)

- **Status:** Phase 1 applied 2026-05-28 (write-only `.session-marker` in `/prime`); Phases 2 (consumer reads in `/session-start` + `/session-plan`), 3 (downstream consumers `/drift-check` / `/wrap-session` / `/contract-check` / `/qc-pass`), and 4 (legacy-fallback cleanup) remain `pending`.
- **Verified:** 2026-05-28 — `/prime.md` Steps 8a.3.a / 8b.3.a / 8c.3 now write `logs/.session-marker` (one line `{date} S{N}`) immediately after their existing `.prime-mtime` writes; `.gitignore` line for `logs/.session-marker` added; risk-check report at `audits/risk-checks/2026-05-28-prime-session-marker-phase-1-write-only.md` (verdict GO, all 5 dimensions Low); `/qc-pass` verdict GO (no findings); bash logic smoke-tested in isolation (fresh→S1, same-day x2→S2, same-day x3→S3, day rollover→S1).
- **Category:** session-issue / cross-cutting architecture
- **Source:** Live recurrence during axcion-brand-book session 2026-05-28; operator explicitly attributed cause to deliberate concurrent-session use. Friction-log entry 2026-05-28 10:05 records the live event. This entry is broader than the earlier same-day `/session-start` Step 0.5 entry (which only proposed a Step 2.5 patch); supersede that proposal with the structural fix below.
- **Supersedes:** the same-day "2026-05-28 — /session-start Step 0.5 mtime guard misses foreign writes that arrive DURING the Mandate Confirmation wait" entry above. Mark that entry's Status as "logged — superseded by broader 2026-05-28 entry below" when applying this one. The narrow Step 2.5 patch from the prior entry is no longer the recommended fix; the structural per-session-marker approach replaces it.

#### Problem class

Three commands (`/prime`, `/session-start`, `/session-plan`) read shared log files (`logs/session-notes.md`, `logs/session-plan.md`) at command entry, make decisions based on the read, and later write back to those same files. Between the read and the write, an arbitrary number of conversation turns elapse (mandate confirmation echoes, class/intent confirmation prompts, AskUserQuestion blocks, Read calls for source material). When a second session is active in the same project, ANY write the second session makes to a shared log during the first session's read-to-write window is invisible to the first session's point-in-time mtime guard. This is a classic TOCTOU (time-of-check-to-time-of-use) race.

Today's session demonstrated the race three times in one startup sequence:

1. **`/session-start` Step 0.5 → Step 2 wait → Step 3 write.** Step 0.5 mtime check returned clean. Foreign write arrived during the Mandate Confirmation echo wait. Operator's `y` was applied against an echoed mandate that no longer matched on-disk content.
2. **`/session-plan` Step 0 → Step 7 write.** Step 0 mtime check found `session-plan.md` 25 hours old (clean). Foreign session's `/session-plan` rewrote the file during Step 1.5 / Step 2 / Step 3 confirmations. Step 7 Write tool errored with "File has been modified since read"; the only reason this race was visible was because Claude Code's Write tool happens to enforce read-before-write integrity at the tool level.
3. **`/session-notes.md` mandate-block overwrite.** Foreign session's `/session-start` Step 3 wrote its own mandate block under the same `## 2026-05-28` header that I had just written my mandate to. My mandate block was fully replaced.

The prior fix for `/session-plan` Step 0 (commit `8ab5685`, MISMATCH auto-route to pass2) was a one-off patch to one command. The race class survives in every other shared-log read-write site.

#### Proposed structural fix — per-session markers on all shared writes

Each session at `/prime` time generates a 4-character session marker (e.g., `S1`, `S2`, `a3f7`) and persists it to `logs/.session-marker` (single file, last writer wins — but this file is only read by the SAME session's later commands, so the race surface is small).

All subsequent shared-log writes scope themselves with this marker:

- **`logs/session-notes.md`** — `/prime` writes `## YYYY-MM-DD — Session {marker}` instead of bare `## YYYY-MM-DD`. Each concurrent session gets its own header. Existing readers that grep `^## ${DATE}` still match (and the `/prime` Step 1a sibling-entry sweep already handles multiple same-day headers as a known pattern). `/session-start` Step 3 appends its Mandate block under THIS session's marker-bearing header (located by reading `.session-marker`, not by date-only match).
- **`logs/session-plan.md`** — replaced by `logs/session-plan-{marker}.md`. The collision detection in `/session-plan` Step 0 simplifies dramatically: there is no shared file to collide on. Each session writes to its own scoped file. `pass2` becomes unnecessary (and the existing pass2 mechanism graduates from "race-condition safety valve" to "explicit operator-initiated re-plan within one session").
- **Downstream readers** (`/drift-check`, `/wrap-session`, `/qc-pass`, etc.) read `.session-marker` first, then read the marker-scoped files. A symlink or alias from `logs/session-plan.md` to the current session's plan can preserve backward compatibility for readers that don't know about markers yet.

The marker is short and deterministic per session — the first existing `.session-marker` value on disk plus a deterministic increment (`S1` → `S2` → `S3`), wrapping at `S9` → `Sa` → `Sz`. `/prime` Step 0 reads the existing value (if present and same-day) to increment; otherwise resets to `S1` and writes `YYYY-MM-DD` + value. A same-day re-read of `.session-marker` returning a different value than the session's own cached marker is itself a concurrent-session signal that `/prime` can surface.

This eliminates the TOCTOU race at its root: there is no longer a shared mutable file for concurrent sessions to collide on. The remaining synchronization concern is `.session-marker` itself, but the file is small, atomic-write-friendly (single short token), and is read ONLY by the same session that wrote it — not cross-session — except during `/prime` increment.

#### Alternatives considered

- **(a) Atomic re-read at each write site.** Every shared-log write site re-reads mtime immediately before write and abort/restart if changed. Lower-magnitude change, but requires patching ~6 write sites across 4 commands and only narrows the race window (does not eliminate it). Rejected.
- **(b) Per-session subdirectory.** Each session writes to `logs/sessions/{marker}/{file}.md`. Cleaner separation than markers in filenames, but requires every consumer command to know about the subdirectory convention. Higher-friction migration. Rejected for now; can be a later step.
- **(c) Advisory file locks (`flock`).** Standard Unix pattern. Adds shell-state complexity, doesn't survive across tool boundaries (Claude Code Write tool doesn't acquire flocks), and would require wrapping every Write/Edit in a Bash flock dance. Rejected.
- **(d) Refuse concurrent sessions.** `/prime` detects an active session via marker file and refuses to start a second one. Operator preference is to RUN concurrent sessions (today's evidence), so refusing would block a workflow they actively use. Rejected.
- **(e) Status quo + Step 2.5 patches.** Each command gets a TOCTOU-narrowing patch like the one in the prior 2026-05-28 entry. The race class survives across the ~6 write sites and recurs whenever a new write site is added. This is the trajectory we've been on (the 2026-05-25 14:10 friction entry was the third recurrence). Rejected in favor of structural fix.

#### Migration plan

Phased, low-risk:

1. **Phase 1 — `/prime` writes the marker.** `/prime` Step 8a.3 / 8b.1 generates and persists the marker; existing today's-header behavior unchanged. No other command reads the marker yet. Risk: zero (additive).
2. **Phase 2 — `/session-start` and `/session-plan` consume the marker for header location and file naming.** Commands prefer marker-scoped files; fall back to legacy paths if marker absent (interop with sessions that started before Phase 2 rollout). Risk: low (each command's behavior gracefully degrades).
3. **Phase 3 — downstream consumers (`/drift-check`, `/wrap-session`, `/contract-check`, `/qc-pass` plan-reading) update to read marker first.** Risk: medium — many touchpoints.
4. **Phase 4 — deprecate legacy code paths.** Once Phase 3 is verified, remove the fallback paths in `/session-start` / `/session-plan`. Risk: low (Phase 3 has verified the new path).

**/risk-check change class:** YES (this is a cross-cutting protocol change across 5+ commands and 2+ shared log files; explicit shared-state coordination redesign). Run `/risk-check` before EACH phase, not as a one-shot.

#### Target files (by phase)

- Phase 1: `ai-resources/.claude/commands/prime.md` (Step 8a.3.a / 8b.1 — generate and persist `.session-marker`); new `ai-resources/.gitignore` line for `logs/.session-marker` (it's per-machine session state, not committed).
- Phase 2: `ai-resources/.claude/commands/session-start.md` (Step 3 — locate header by marker, not by date); `ai-resources/.claude/commands/session-plan.md` (Step 0 simplification — drop the 6-hour-window pass2 routing, write directly to `session-plan-{marker}.md`; Step 7 OUTPUT_TARGET changes).
- Phase 3: `ai-resources/.claude/commands/drift-check.md`, `ai-resources/.claude/commands/wrap-session.md`, `ai-resources/.claude/commands/contract-check.md`, `ai-resources/.claude/commands/qc-pass.md` (plan-reading branch), `ai-resources/skills/friday-checkup/SKILL.md` (any references to `session-plan.md`).
- Phase 4: cleanup of legacy fallback branches across Phase 2 commands.

#### Notes

- The friction-log 2026-05-28 10:05 entry is the live-event record; this is the proposal record. `/fix-repo-issues` will surface both.
- The narrow same-day `/session-start` Step 0.5 entry written earlier in this session is superseded — apply the supersede marker (`Status: logged — superseded by broader 2026-05-28 entry`) when this proposal is taken to plan.
- This is not a hotfix-able item; it requires a phased rollout. Suggested cadence: a dedicated `/friday-act` wave dedicated to Phase 1 (marker introduction) with `/risk-check` as advisory gate.

### 2026-05-28 — /pm forward-looking handling: re-evaluate after 3 paste cycles into /session-start

- **Status:** logged (pending)
- **Category:** command/skill
- **Source:** project-manager agent + /pm command landing 2026-05-28 — System Owner Function-B advisory flagged the design choice. Per `principles.md § DR-7` (generalize only on confirmed second-consumer evidence), v1 ships with forward-looking project-content handling (mandate generation, session-plan suggestions) inside `/pm`, with the operator manually pasting the verdict into `/session-start` or `/session-plan`. The architecturally cleaner answer — having `/session-start` and `/session-plan` natively read constitution docs — was deferred for lack of second-consumer evidence.
- **Trigger:** after the operator has used `/pm` for forward-looking questions (mandate or session-plan shapes) **three or more times** (counted by manual paste-into-`/session-start` cycles), re-evaluate whether forward-looking logic should move from PM into `/session-start` and `/session-plan` natively. Friday cadence review.
- **Proposal:** if the paste-step is recurring without complaint, status-quo is fine — close as `applied (no-op confirmed)`. If the paste-step is causing friction (forgotten paste, copy errors, divergence between PM verdict and final mandate), extract forward-looking logic into `/session-start` and `/session-plan` natively (they would invoke project-manager internally, or grow their own constitution-doc read).
- **Target files (when triggered):** `ai-resources/.claude/commands/session-start.md`, `ai-resources/.claude/commands/session-plan.md`, possibly `ai-resources/.claude/agents/project-manager.md` (Phase 3 forward-looking branch).

### 2026-05-28 — investigate sub-subagent dispatch (Task-from-agent) limitation

- **Status:** logged (pending)
- **Category:** command/skill / runtime-limitation
- **Source:** project-manager agent BLOCKING gate trace test (2026-05-28). The PM agent was designed to spawn `system-owner` via the `Task` tool for structure-general escalation. The trace test surfaced that the agent reports `Task` is not in its available toolset — despite the frontmatter declaring `tools: - Task`. Sub-subagent dispatch (agent → agent via Task) does not work in the current Claude Code runtime, regardless of frontmatter declaration. PM gracefully degrades to its DISPATCH FAILED fallback (per `principles.md § OP-3` loud failure rule), telling the operator to run `/consult` directly for structure questions.
- **Impact:** PM ships in degraded mode for structure escalation. Project-content advisory (retrospective + forward-looking — the primary use cases) works as designed. Structure-general questions emit a clear "run /consult directly" output instead of seamlessly folding in a system-owner consultation.
- **Investigation tasks:**
  1. Verify whether the tool name in agent frontmatter should be `Task` (current convention across system-owner.md, qc-reviewer.md, etc.) or `Agent` (the runtime-exposed tool name in main-session context). Check Claude Code documentation / release notes.
  2. If the convention is correct but Claude Code doesn't yet support sub-subagent dispatch, file a feature request upstream or accept the limitation as architectural (agents are leaf nodes; only commands and main session can spawn agents).
  3. If sub-subagent dispatch IS supported via a different mechanism (e.g., a wrapper, a different SDK call), update PM's Phase 4 to use the working pattern.
  4. Decide between three v1.1 design options: (a) seamless sub-subagent dispatch if supportable; (b) restructure PM to never attempt escalation (Phase 4 removed; structure questions always emit "/consult redirect"); (c) accept degraded mode as designed and update docs.
- **Proposal:** time-box the investigation to one Friday-act wave (~1 h). If sub-subagent dispatch can be made to work cleanly, ship the fix. If not, redesign PM Phase 4 to always emit the "/consult redirect" output deterministically (remove the conditional dispatch attempt; same operator-facing experience, simpler agent body).
- **Target files (when executed):** `ai-resources/.claude/agents/project-manager.md` (Phase 4); `ai-resources/.claude/commands/pm.md` (notes section if behavior changes); possibly `ai-resources/docs/agent-tier-table.md` notes column.
- **Triage cadence:** next Friday `/friday-act` wave.

### 2026-05-28 — /pm internal QC step: data-gated review after 3 invocations (pass-rate + verbatim-shape contract)

- **Status:** logged (pending)
- **Category:** command/skill / data-gated simplification
- **Source:** End-time `/risk-check` 2026-05-28 (PROCEED-WITH-CAUTION verdict). The `/pm` command Step 4 includes an internal QC pass via `qc-reviewer` with pass cap of 2. This was a **plan divergence** — the approved plan said no internal QC, mirroring `/consult`; the operator added the QC step mid-implementation because PM "will be solving quite important issues." The risk-checker promoted D1 Usage cost Low → Medium because each `/pm` invocation now lights up the High-tier `qc-reviewer` agent (per `risk-topology.md § 1`), with worst-case 4 Opus calls per invocation (PM → qc-reviewer → revised PM → qc-reviewer). System-owner end-time Function-B advisory concurred and asked that this v1.1 review entry name the verbatim-shape contract on `qc-reviewer` output (GO / REVISE / FLAG FOR EXTERNAL QC) explicitly so future audits catch drift if qc-reviewer's verdict tokens change.
- **Two coupled risks to track:**
  1. **QC pass-rate.** If the first-pass QC verdict is GO on >90% of invocations, the QC step is largely noise — the data points to removing it. If it surfaces real REVISE findings >30% of the time, it earns the cost. Operator should sample after first 3 invocations.
  2. **Verbatim-shape contract on qc-reviewer output.** `/pm` Step 5 parses `qc-reviewer`'s output for the tokens `GO`, `REVISE`, `FLAG FOR EXTERNAL QC` (exact strings). If `qc-reviewer.md` ever changes those token names or output structure, `/pm` Step 5 silently misclassifies the verdict. This is an implicit two-end contract — name it explicitly in this entry per `risk-topology.md § 1 — qc-reviewer agent` (High tier, every-pm-call dependency). Mitigation option for v1.1: extract the verdict-token list into a sibling reference doc both `qc-reviewer.md` and `/pm` Step 5 read, OR add a defensive shape check in `/pm` Step 5 that falls back to "GO" if the verdict token is unrecognized (loud-failure variant per `principles.md § OP-3`).
- **Trigger:** after the operator has used `/pm` three or more times, review the first-pass qc-reviewer pass-rate. Friday cadence.
- **Decision matrix (when triggered):**
  - **Pass-rate ≥90% on first pass** → QC step is mostly noise; consider removing Step 4 and converging back to /consult precedent. Document the data and rationale in the closure.
  - **Pass-rate 60–90%** → QC step is earning some signal; keep it but consider relaxing pass cap (currently 2) to 1, OR adding a fast-path that skips QC for retrospective questions (which are more constrained than forward-looking).
  - **Pass-rate <60%** → QC step is essential; PM rulings are routinely degraded without it. Keep as-is. Investigate why PM's first-pass quality is low (may indicate constitution-doc grounding issues, not QC necessity).
- **Verbatim-shape contract check (always, regardless of pass-rate):** review whether `qc-reviewer.md` has changed its verdict tokens or output shape since 2026-05-28. If yes, update `/pm` Step 5 parser in lockstep.
- **Target files (when executed):** `ai-resources/.claude/commands/pm.md` (Step 4 / Step 5 — possibly remove QC step, relax pass cap, or update verdict parser); possibly `ai-resources/.claude/agents/qc-reviewer.md` (if verdict-token shape stabilizes via shared reference doc).
- **Triage cadence:** next Friday `/friday-act` wave, gated on ≥3 `/pm` invocations having occurred.

### 2026-05-28 — extract change-shape classifier to shared reference (eliminate two-end contract)

- **Status:** logged (pending)
- **Category:** Audit-recurrence prevention / architectural deduplication
- **Source:** project-manager agent + /pm command landing 2026-05-28 — System Owner Function-B advisory (risk-check second opinion) named this as the architecturally correct v1.1+ state. The change-shape classifier list (Files / Commands / Agents / Models / Folder structure / Hooks / Workflows / Project boundaries / Permissions) is currently duplicated verbatim in `ai-resources/.claude/commands/consult.md` Step 2 and `ai-resources/.claude/agents/project-manager.md` Phase 3 (under `structure (change-shaped)`). The duplication is a **two-end contract per `risk-topology.md § 5`** — silent drift between the two copies causes routing inconsistency between `/consult` and `/pm`.
- **Mitigation in place at v1:** both files carry an explicit two-end-contract comment naming the sibling file. Comments decay per `principles.md § QS-7` — this is a stopgap, not the architectural fix.
- **Proposal:** extract the change-shape classifier to a shared reference doc that both commands `Read` at runtime. Candidate location: `ai-resources/docs/repo-architecture.md` § new "Change-shape classifier" subsection (it's a routing concept and lives naturally alongside repo-architecture's Q5 classifier reference). Both `consult.md` Step 2 and `project-manager.md` Phase 3 then become "read this section; apply the list" instead of carrying verbatim copies. Per `principles.md § DR-7` — generalize on confirmed second-consumer evidence (PM is the second consumer; the trigger is met).
- **Target files (when executed):** `ai-resources/docs/repo-architecture.md` (add classifier subsection); `ai-resources/.claude/commands/consult.md` (replace verbatim list with Read-and-apply reference); `ai-resources/.claude/agents/project-manager.md` (same).
- **Triage cadence:** next Friday `/friday-act` wave.

### 2026-05-28 — B-04 deferred companion: extract S-04 from execution-manifest-creator

- **Status:** logged (pending)
- **Category:** Cross-skill contract enforcement / half-extracted-state prevention
- **Source:** FX-B2 plan-time `/risk-check` System Owner Function-B advisory (2026-05-28) — `audits/risk-checks/2026-05-28-fx-b2-extract-swedish-finnish-norwegian-language-search.md § Architectural Commentary § Risk the Dimension Review Did Not Surface`. FX-B2 landed S-04 extraction on the `research-prompt-creator` skill (lines 143–166 → loader stanza; Self-Check line ~242 → Project-Config-driven), with per-language term content moved to `ai-resources/workflows/research-workflow/reference/language-search-blocks.template.md` + per-project `reference/language-search-blocks.md`. After FX-B2, S-04 has three canonical surfaces — `research-prompt-creator/SKILL.md` (now generalized), `execution-manifest-creator/SKILL.md` (still hardcoded with Nordic countries in its routing table), and `docs/project-config-schema.md` field 5 (the `Languages:` declaration). There is no automated check that S-04 contracts agree across all three surfaces (W2.2 accountability automation does not yet exist per `system-doc.md § 2.3, § 4.5`).
- **Risk if left undone:** Drift-without-detection at system scale (`principles.md § OP-3, § OP-11`). The half-extracted state is invisible technical debt — a future audit will surface "execution-manifest-creator still hardcodes Sweden/Norway/Finland" as a "you missed this" finding (AP-11 territory).
- **Proposal:** Apply the same FX-B3/B4/B5/B6/B2 extraction pattern to `execution-manifest-creator/SKILL.md` — move country-routing values out of the canonical skill into a per-project fillable reference (likely paired with the same `Languages:` / `Country set:` Project Config fields that drive `research-prompt-creator`). Use FX-B2's 3-case absent-file contract as precedent.
- **Sibling consideration (flagged by FX-B2 QC out-of-scope observation):** `research-prompt-creator/SKILL.md § S-03 (Country-Parity Enforcement Gate)` — at the time of the FX-B2 commit, line 142 still hardcodes `Sweden block → Norway block → Finland block → pan-Nordic synthesis last` and lists SVCA / Bolagsverket / NVCA / Brønnøysund / FVCA / PRH as example sources. This is S-03 (country routing), not S-04 (language blocks), so FX-B2 left it untouched — but it is the same "Nordic project content baked into a canonical skill" pattern. When B-04 is scheduled, evaluate whether the S-03 country-routing chunk in `research-prompt-creator` itself should be extracted in the same wave (likely as a `reference/country-routing.md` per-project file paired with the existing `Country set:` Project Config field). Defer-or-bundle decision belongs to the Friday-cadence triage.
- **Trigger (whichever fires first):**
  - The next research project declares `Languages:` with a non-Nordic set OR `Country set:` outside `[SE, NO, FI, DK]` (the current canonical-skill-hardcoded set).
  - Next Friday `/friday-checkup` cadence.
  - Operator explicitly raises it.
- **Target files (when executed):** `ai-resources/skills/execution-manifest-creator/SKILL.md` (loader stanza replacing hardcoded country routing); new `ai-resources/workflows/research-workflow/reference/{routing-or-country-set}.template.md` (canonical fillable); project-side instance file(s) for nordic-pe + buy-side + any future research projects.
- **Triage cadence:** next Friday `/friday-act` wave; treated as the Phase 2 follow-on companion to FX-B2.

### 2026-05-28 — placement-verifier four-pipeline extension (deferred Stage B scope)

- **Status:** logged (pending)
- **Category:** Placement-discipline / canonical-pipeline coverage
- **Source:** `/route-change` → `/placement` rename + verifier session (2026-05-28). SO advisory item #1 (post-write placement verifier) shipped lean — `docs/placement-verifier.md` procedure + integration into `/graduate-resource` only. Four other canonical creation pipelines (`/create-skill`, `/improve-skill`, `/migrate-skill`, `/new-project`) were deliberately left untouched per SO `Architectural Commentary § M1` and `principles.md § DR-7` (generalize on confirmed second-consumer evidence, not by analogy).
- **Risk if left undone:** placement misses inside the four un-integrated pipelines remain silent — same leak the verifier exists to close. Acceptable at v1 because `/graduate-resource` is the highest-leverage placement decision; other pipelines have stronger structural defaults (skill scaffolds always land in `skills/<name>/`; project scaffolds always land in `projects/<name>/`).
- **Proposal:** Extend the placement-verifier integration into a second pipeline when ANY of these fire: (a) an observed placement miss inside `/create-skill`, `/improve-skill`, `/migrate-skill`, or `/new-project` surfaces in `friction-log.md` (the canonical signal for placement misses per workspace CLAUDE.md § Placement Discipline); (b) the `/graduate-resource` verifier integration generates ≥2 MISMATCH events in a Friday-checkup window (indicates the pattern is load-bearing); (c) operator dispositions this in a Friday-act wave on judgment alone. When triggered, integrate one pipeline at a time — DR-7 / AP-7 still bites if all four are added pre-emptively.
- **Target files (when executed):** `ai-resources/.claude/commands/{create-skill | improve-skill | migrate-skill | new-project}.md` (one at a time) — add Step Xa (plan-time gate) and Step Yb (end-time gate) mirroring `/graduate-resource` Steps 3a and 5a. No changes to `docs/placement-verifier.md` itself (already designed to support any pipeline).
- **Triage cadence:** opportunistic — gated on the three triggers above, not on a fixed cadence.

### 2026-05-28 — Extract Q1–Q8 placement logic into shared SKILL.md (SO advisory item #2)

- **Status:** logged (pending)
- **Category:** Placement-discipline / DR-7 shared-judgment surface
- **Source:** SO advisory delivered as part of the `/route-change` → `/placement` rename session (2026-05-28). Original advisory recommended a shared SKILL.md that both `/placement` and the verifier consume; operator chose to ship only item #1 first.
- **Proposal:** Extract the Q1–Q8 placement heuristics currently embedded in `docs/repo-architecture.md § Placement heuristics` into a shared `skills/placement-classification/SKILL.md`. Both `/placement` and `docs/placement-verifier.md` then `Read` the SKILL.md instead of carrying their own classification logic. DR-7 trigger: `/placement` (consumer 1), `placement-verifier.md` (consumer 2) — second consumer is confirmed and the bar is met.
- **Risk if left undone:** classification logic remains split between `/placement`'s Step 3 (Q1–Q8 walk) and `placement-verifier.md`'s canonical-home lookup. Drift between the two is currently unguarded — a future edit to one could leave the other behind.
- **Target files (when executed):** new `ai-resources/skills/placement-classification/SKILL.md`; `ai-resources/.claude/commands/placement.md` Step 3 (Read-and-apply the SKILL.md); `ai-resources/docs/placement-verifier.md` Method (Read-and-apply the SKILL.md); `ai-resources/docs/repo-architecture.md § Placement heuristics` (becomes a pointer to the SKILL.md rather than the source of truth).
- **Triage cadence:** next Friday `/friday-act` wave that also touches `/placement` or `placement-verifier.md`, OR when item #1's four-pipeline extension fires (above) — that extension's second integration is the natural moment to extract the shared skill.

### 2026-05-28 — Architecture-gap report loop (SO advisory item #3)

- **Status:** logged (pending)
- **Category:** Placement-discipline / feedback-loop closure
- **Source:** SO advisory (`/route-change` → `/placement` rename session, 2026-05-28). `/placement` Step 14 surfaces architecture gaps (cases where `docs/repo-architecture.md` does not cover a proposed change) as a recommendation field in chat. Currently those gap reports live and die in chat — no aggregation, no Friday-act consumption.
- **Proposal:** When `/placement` populates the `**Architecture gap:**` field, also append a structured entry to `ai-resources/logs/maintenance-observations.md` under a new "Architecture gaps surfaced" subsection within the current week's session block. Friday-act consumes the section, decides whether `docs/repo-architecture.md` needs amendment, and dispositions accordingly.
- **Risk if left undone:** placement recommendations degrade silently as the architecture map staleness accumulates. The feedback loop named in workspace CLAUDE.md § Placement Discipline (friction-log as the upgrade signal) only catches *misses*, not *gaps*.
- **Target files (when executed):** `ai-resources/.claude/commands/placement.md` Step 14 (add maintenance-observations append after chat output); `ai-resources/logs/maintenance-observations.md` schema (document the new subsection); `ai-resources/.claude/commands/friday-act.md` (add the new subsection to its consumption sweep).
- **Triage cadence:** next monthly `/friday-act` wave (low priority — slow signal, low blast radius).

### 2026-05-28 — Track /placement skip-rate in gate-calibration (SO advisory item #4)

- **Status:** logged (pending)
- **Category:** Placement-discipline / fading-gate observability
- **Source:** SO advisory (`/route-change` → `/placement` rename session, 2026-05-28). The `gate-calibration.md` system (shipped 2026-05-18) tracks high-confirmation gates and surfaces `[FADING-GATE]` candidates in monthly `/friday-checkup`. `/placement` is exactly the kind of gate that's easy to "remember" early and skip when work is flowing — its skip-rate should be observable.
- **Proposal:** Add `/placement` to the gate-calibration tracking surface. Each session start, the gate-calibration mechanism increments either an "invoked" or "skipped" counter for `/placement`. The skip detection: when a file is created in a new top-level directory or new artifact category (the triggers listed in workspace CLAUDE.md § Placement Discipline) AND `/placement` was not invoked during the session, mark a skip. Monthly checkup surfaces a fading-gate candidate when skips exceed invocations for two consecutive months.
- **Risk if left undone:** placement-discipline drift is invisible until an audit catches a misplaced file. Today the operator has no way to see whether `/placement` is actually being used or being silently skipped.
- **Target files (when executed):** `ai-resources/docs/gate-calibration.md` (add `/placement` to tracked gates); a new SessionStart or Stop hook to detect file-creation events satisfying the trigger conditions; `ai-resources/.claude/commands/friday-checkup.md` Step 6 (consume the new tracking signal).
- **Triage cadence:** quarterly `/friday-act` wave — depends on the gate-calibration system maturing; low priority.

### 2026-05-28 — Tighten Placement Discipline trigger to constraint-on-Write checklist (SO advisory item #5)

- **Status:** logged (pending)
- **Category:** CLAUDE.md polish / always-loaded surface tightening
- **Source:** SO advisory (`/route-change` → `/placement` rename session, 2026-05-28). The current workspace CLAUDE.md § Placement Discipline trigger list (lines 39–42) reads as four prose bullets describing when to run `/placement`. SO suggested converting to a stricter "before any `Write` whose target path is not already in scratch context this session, ask: …" — makes the gate harder to skip rhetorically by reframing it as a constraint on Write actions rather than a procedure to remember.
- **Proposal:** Rewrite workspace CLAUDE.md § Placement Discipline trigger list as a constraint-on-Write checklist. Keep the "skip when" bullet list intact. Net token delta probably <0 (constraint phrasing is usually tighter than procedural).
- **Risk if left undone:** low — cosmetic vs. structural. Current prose is functional and operator already invokes `/placement` consistently. SO classified this as item #5 (lowest in the ranked list) for that reason.
- **Target files (when executed):** `~/Claude Code/Axcion AI Repo/CLAUDE.md` § Placement Discipline only.
- **Triage cadence:** opportunistic — bundle with the next workspace CLAUDE.md edit pass; do not schedule standalone.

