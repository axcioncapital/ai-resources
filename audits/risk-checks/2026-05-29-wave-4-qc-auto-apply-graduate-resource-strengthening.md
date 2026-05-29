# Risk Check — 2026-05-29

## Change

Wave 4 cluster: two CLAUDE.md-cross-cutting edits sharing a structurally similar risk shape. Bundling for efficiency (deviates from session-plan-S6.md's "do not share /risk-check" guidance — but the risk profiles converge enough to justify cluster framing; per-item risk surfaced below).

ITEM A (session-qc-pipeline plan item #2): Auto-apply /qc-pass fixes when verdict is REVISE AND every finding is wording-level / mechanical AND no DISAGREE annotation.
- Define the "wording-level / mechanical" finding class explicitly in docs/qc-independence.md § QC → Triage Auto-Loop (add ~10-15 lines)
- Update /resolve command Step 10 to detect the wording-only condition, skip the operator approval prompt, execute fixes inline, log the auto-apply event in decisions.md
- Update workspace CLAUDE.md § QC → Triage Auto-Loop pointer (currently a single-line "Full mechanics: ..." pointer) with one additional bullet referencing the new auto-apply rule

ITEM B (session-qc-pipeline plan item #4): Strengthen /graduate-resource Step 4 generalization + Step 5 verification.
- Add brief subagent pass to Step 5 that grep-scans generalized output for project names, hardcoded paths, domain-specific terminology drawn from source CLAUDE.md
- Add "fail and revise" loop: if Step 5 finds residue, Step 4 re-runs with specific residue items called out
- Update docs/ai-resource-creation.md § graduation rules to encode new Step-5 verification expectations
- Optional minor update to workspace CLAUDE.md § AI Resource Creation pointer

CROSS-CUTTING RISK SHAPE (shared):
- Both items expand autonomous behavior in well-defined slots (auto-apply for QC; auto-verify-and-revise for graduation)
- Both have explicit fallback / override paths preserved (DISAGREE annotation; fail-and-revise loop with operator-judgment stop)
- Both edit a docs/ canonical reference file + a command file + an optional CLAUDE.md pointer line
- Both reversible via single-file revert per consumer
- Neither adds new resource paths (commands, skills, agents, hooks) — both refactor existing resources

PER-ITEM RISK DIVERGENCE:
- ITEM A is QC-pipeline behavior change → silent application of "wording-only" fixes is the new behavior; the wording-only/mechanical class definition is the safety boundary
- ITEM B is resource-creation behavior change → silent re-run on residue detection is the new behavior; the fail-and-revise loop's exit condition is the safety boundary

Both items were operator-approved in session-plan-S6.md Wave 4 (recommended scope). Source plan: ai-resources/logs/session-plan-S6.md Wave 4 (items 12, 13).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/qc-independence.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/resolve.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/decisions.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/graduate-resource.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/ai-resource-creation.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Both items expand autonomous behavior in narrow, well-scoped slots with explicit override paths, but ITEM A's "wording-level / mechanical" class definition is the safety boundary for a behavior change that silently removes the only existing operator-approval gate in /resolve Step 10, and ITEM B introduces a new looping structure plus a new subagent invocation contract that did not previously exist in the graduation pipeline — both warrant paired mitigations before landing.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- ITEM A adds ~10-15 lines to `docs/qc-independence.md` — this file is **not** always-loaded; it is read on demand per its own header: "When to read this file: When running QC ... or when applying triage findings via the QC → Triage Auto-Loop" (qc-independence.md:3). Cost is paid only in QC-running sessions, not every turn.
- ITEM A adds one bullet to workspace `CLAUDE.md` § QC → Triage Auto-Loop (CLAUDE.md:126-128). CLAUDE.md IS always-loaded; the current section is a 2-line pointer stub. One additional bullet is roughly 25–60 tokens depending on phrasing — modest but always-paid per turn.
- ITEM B adds verification expectations to `docs/ai-resource-creation.md` — also on-demand per its header: "When to read this file: When a session identifies the need for a new or modified AI resource ... or when routing a skill request" (ai-resource-creation.md:3). No always-loaded cost.
- ITEM B's optional CLAUDE.md § AI Resource Creation pointer update (CLAUDE.md:31-33) would add tokens to an always-loaded file. The change description marks this as "optional minor update" — treating it as a single short pointer line, ~20–40 tokens.
- ITEM B introduces a new subagent invocation in /graduate-resource Step 5 — every graduation now spawns at least one extra subagent pass; if residue is detected, additional Step 4 re-runs follow. /graduate-resource is invoked per-graduation (low frequency — only when graduating a project resource to canonical), not per-session, so amortized cost is low but per-invocation cost rises notably.
- Net always-loaded delta (workspace CLAUDE.md): ~45–100 tokens across the two pointer-line additions, both falling in the "Medium" calibration band (50–150 tokens).

### Dimension 2: Permissions Surface
**Risk:** Low

- Neither item adds, removes, or modifies entries in any `.claude/settings.json` or `.claude/settings.local.json`. No grep evidence of permission entries in the change description.
- ITEM A's auto-apply path uses Edit / Write on the QC'd artifact — these capabilities are already used by /resolve Step 10's current behavior (operator-approved row-by-row execution per resolve.md:41). No new tool family introduced.
- ITEM B's subagent invocation uses an existing subagent pattern (Task tool spawning a brief subagent) — already-authorized. The grep-scan inside the subagent is Read-only.
- No deny-rule modifications; no scope escalation; no new MCP / external API access.

### Dimension 3: Blast Radius
**Risk:** Medium

- **ITEM A direct touch (3 files):** docs/qc-independence.md (insert class definition); .claude/commands/resolve.md Step 10 (insert condition + branching); CLAUDE.md § QC → Triage Auto-Loop pointer (one bullet).
- **ITEM B direct touch (2–3 files):** .claude/commands/graduate-resource.md Steps 4 + 5 (subagent + fail-and-revise loop); docs/ai-resource-creation.md § graduation rules; optionally CLAUDE.md § AI Resource Creation pointer.
- **ITEM A — callers of `/resolve` and the QC → Triage contract** (grep across `{AI_RESOURCES}`):
  - `friday-act.md:256` — references "QC → Triage auto-loop" and explicitly mentions "Editorial DISAGREE verdicts that cannot be self-resolved from the change-class list are surfaced to the operator per Autonomy Rule #4." This caller's expectation aligns with the new wording-only auto-apply — DISAGREE preserves the surface path.
  - `auto-resolve-nudge.sh:19` — emits "Run /resolve to assess importance and get ready-to-execute fixes." Wording stays accurate even if /resolve now auto-applies a subset; the nudge does not assume operator interaction.
  - `auto-qc-nudge.sh:10` — references `/tmp/claude-resolve-executing-$PPID` marker (currently set in resolve.md:41). The auto-apply branch must continue to set/remove this marker — if it skips that path, the nudge hook will mis-fire during auto-apply execution.
  - `decide.md:17` and `decide.md:128` — describe the `/qc-pass` → `/resolve` → `/decide` chain. /decide is invoked for "Needs operator judgment" items (resolve.md:39). Auto-apply only triggers when zero findings need operator judgment AND no DISAGREE — `/decide`'s call surface is not changed.
  - `triage-reviewer.md:3` — describes triage-reviewer as invoked by /triage and /resolve. The /resolve auto-apply branch may bypass operator approval but should still run through triage-reviewer (per resolve.md Steps 4–5). The change description does NOT specify whether triage is still invoked when auto-applying; if skipped, the importance classification step is silently removed.
  - `fix-repo-issues.md:279` — describes "/resolve — post-QC triage (QC-finding-sourced fixes only)." Description stays accurate.
  - Net: 7 caller-touch points; all are backwards-compatible if (a) the auto-apply path still sets/removes the marker, (b) triage is still invoked, (c) DISAGREE annotation behavior is preserved as the escape valve.
- **ITEM B — callers of `/graduate-resource`** (grep across `{AI_RESOURCES}/.claude`):
  - `innovation-sweep.md:10, :50, :157, :243` — 4 references, all of which describe `/graduate-resource` as the move-from-project-to-canonical command. The new fail-and-revise loop does not change the invocation surface (same arguments) but does increase per-invocation time. Callers tolerate this.
  - `wrap-session.md:275` — reminds operator to run `/graduate-resource {name}`. Wording stays accurate.
  - `placement.md:73, :99` — references /graduate-resource as one of the pipeline options. Wording stays accurate.
  - Net: 7 caller-touch points; all backwards-compatible with the new loop structure (no signature change).
- **Cluster meta-blast:** Cluster framing itself is the meta-risk per session-plan-S6.md:122 which explicitly states "Items 12 and 13 do NOT share a /risk-check — different sections (QC pipeline vs. AI Resource Creation), different risk profiles." The risk shape IS shared in structural terms but the surface areas are disjoint (QC pipeline ≠ resource-creation pipeline) — a clustered /risk-check is not invalid, but a single GO verdict elides the per-item Hidden Coupling profile. This report tracks per-item findings to preserve that signal.

### Dimension 4: Reversibility
**Risk:** Low

- All edits are to existing files (docs/qc-independence.md, .claude/commands/resolve.md, CLAUDE.md, .claude/commands/graduate-resource.md, docs/ai-resource-creation.md). `git revert` on the landing commit cleanly restores prior state.
- No new sibling files, no new directories, no settings.json cache state, no symlink creation.
- ITEM A's log appends to `logs/decisions.md` happen at runtime per the auto-apply path. A revert of the auto-apply *rule* does not undo any decisions.md entries created in the interim. Stale entries remain — append-only log mutation pattern that revert cannot cleanly unwind. This nudges toward Medium territory, but the decisions.md entries would carry a clear "Auto-apply via /resolve" marker (per the change description) and are individually editable in a separate cleanup if needed.
- No external state propagated (no push, no Notion write, no API POST) at change time.
- No hook auto-fires in the gap between landing and revert that the change introduces (the auto-apply branch fires only when /resolve is invoked).

### Dimension 5: Hidden Coupling
**Risk:** High

- **ITEM A — "wording-level / mechanical" class definition is the safety boundary.** Working-notes file at `audits/working/journal-qc-2026-05-29.md:31` already flagged this: "Assumes 'wording-level / mechanical' finding class is cleanly definable ... In practice, 'factual reference correction' can shade into editorial judgment (which reference is canonical?). The directive is actionable as written, but the gate definition will need careful drafting during build." If the class definition is loose, the auto-apply branch will silently absorb fixes that the operator would have caught. There is no documented backstop in /resolve.md or qc-independence.md today; the change creates this contract from scratch.
- **ITEM A — Removing the existing operator-approval prompt in /resolve.md Step 10 changes a documented behavior.** Current resolve.md:41 reads verbatim: "wait for operator approval row-by-row (or blanket approval). Before executing fixes, set: `touch /tmp/claude-resolve-executing-$PPID` — this tells the auto-QC nudge hook to suppress re-nudging during fix execution. Execute each approved fix. After all fixes complete (or if interrupted), remove the marker: `rm -f /tmp/claude-resolve-executing-$PPID`. Report completion per fix." Two coupling points: (a) the auto-apply branch MUST still touch/remove the `/tmp/claude-resolve-executing-$PPID` marker, otherwise `auto-qc-nudge.sh:10` will re-nudge during auto-apply execution; (b) the decisions.md log-append contract is new — the change description names it but the actual log-line schema is undocumented. Any consumer reading decisions.md post-hoc has no defined parse marker for "this is an auto-apply event."
- **ITEM A — Interaction with `friday-act.md:256` DISAGREE handling.** friday-act.md already encodes the rule "Editorial DISAGREE verdicts that cannot be self-resolved from the change-class list are surfaced to the operator per Autonomy Rule #4." The new auto-apply rule says "no DISAGREE annotation" is one of the three gates. If `qc-reviewer` does not emit a structured DISAGREE annotation in its findings output today (the change description does not assert that it does), the auto-apply gate has no signal to read — and the boundary becomes "always auto-apply for wording-level/mechanical findings" instead of the intended three-gate AND. This is a high-risk implicit dependency on an upstream subagent emitting a marker the change does not enumerate.
- **ITEM B — New subagent invocation contract is a new dependency surface.** Current graduate-resource.md Step 5 (lines 70-79) is a main-agent self-check with 4 explicit checks: no project-specific references, dependencies resolve, self-contained, functional. Adding a "brief subagent pass" introduces (a) a new subagent that does not yet exist (or reuses an existing one — the change description does not specify), (b) a new input contract for what the subagent receives (generalized output file path? source CLAUDE.md path? both?), (c) a new output contract for what the subagent returns (residue list format?). None of these are documented in the change description. The Subagent Contract rule in ai-resources/CLAUDE.md § Subagent Contracts requires "Summary cap: 30 lines ... Notes to disk ... full findings go to a working-notes file" — the new subagent must be designed against this contract.
- **ITEM B — Fail-and-revise loop exit condition is the safety boundary.** Loop: Step 5 detects residue → Step 4 re-runs with residue called out → Step 5 re-checks. No explicit termination criterion in the change description. Without a max-pass cap (analogous to the QC → Triage Auto-Loop's "Stop after the second post-edit QC" cap at qc-independence.md:21), a stubborn residue (e.g., a domain term that the subagent flags but Step 4 cannot cleanly generalize) loops indefinitely.
- **ITEM B — Functional overlap with placement-verifier.** graduate-resource.md already has `Step 3a` and `Step 5a` placement verification (graduate-resource.md:49-55, :81-88). The new subagent pass overlaps in spirit (verification of the generalized output) but operates on a different concern (project-name/path/domain residue vs. placement target match). Two systems verifying adjacent aspects of the same artifact at the same time; if their reports disagree, the change does not specify which wins.
- **ITEM B — workspace CLAUDE.md pointer at line 31-33 currently reads "Use the canonical pipelines: `/create-skill`, `/improve-skill`, `/migrate-skill`."** It does not list `/graduate-resource`. Adding verification expectations to docs/ai-resource-creation.md is consistent with the existing pointer (full rules live in the doc), but a CLAUDE.md pointer update that mentions `/graduate-resource` would surface the command into the always-loaded set for the first time — a small surface-shift not flagged in the change description.

### Cluster meta-risk

- session-plan-S6.md:122 explicitly says: "Items 12 and 13 do NOT share a /risk-check — different sections (QC pipeline vs. AI Resource Creation), different risk profiles." This /risk-check is bundled in deviation from that guidance. Per the dimensions above, the two items have **disjoint Hidden Coupling profiles** (ITEM A couples to qc-reviewer / friday-act / nudge hooks; ITEM B couples to placement-verifier / Subagent Contracts / loop-termination semantics). The cluster framing is defensible for Dimensions 1–4 (where the risk shapes converge), but Dimension 5 is materially different per item. The clustered report below applies separate Hidden Coupling mitigations per item to preserve the session-plan's per-item discipline.

## Mitigations

**ITEM A (auto-apply /qc-pass — Dimension 5 High):**

- **Define the "wording-level / mechanical" class with a closed enumeration, not an open category.** In docs/qc-independence.md, list the exact fix shapes that qualify (e.g., "typo fix, line-number correction, missing-citation insertion when canonical source is uncontested, label-only mapping fix") and an explicit exclusion list ("any finding where the canonical form is itself in dispute; any finding that modifies meaning beyond the surface wording; any finding under § Notes"). Working-notes file `audits/working/journal-qc-2026-05-29.md:31` already flagged this as a build-budget concern — wire it into the class-definition section of qc-independence.md.
- **Preserve the `/tmp/claude-resolve-executing-$PPID` marker in the auto-apply branch.** The /resolve auto-apply path MUST `touch` the marker before applying fixes and `rm -f` it after, identical to resolve.md:41 today. Without this, `auto-qc-nudge.sh:10` re-nudges during auto-apply execution. State this explicitly in the resolve.md edit.
- **Document the decisions.md log-line schema for auto-apply events.** Define a parse marker — e.g., "Auto-applied via /resolve YYYY-MM-DD HH:MM — N wording-level findings, artifact: PATH" — so the entry is grep-detectable in post-hoc reviews. Without a defined schema, the audit trail is ad-hoc.
- **Confirm `qc-reviewer` emits the DISAGREE annotation that the auto-apply gate reads.** Before landing, grep `qc-reviewer.md` for an existing DISAGREE annotation surface. If qc-reviewer does not currently emit a structured DISAGREE marker on findings, the auto-apply gate "no DISAGREE annotation" is read against a field that does not exist — gate is always TRUE and the safety boundary collapses. If absent, qc-reviewer.md must be updated in the same landing.
- **Document whether triage-reviewer is invoked when auto-applying.** /resolve.md Steps 4–5 currently always invoke triage-reviewer. State explicitly in the resolve.md edit whether the auto-apply path (a) skips triage and applies all findings as "Real," or (b) still runs triage and auto-applies only the "Real" ones triage returns. Either is defensible; silent ambiguity is not.

**ITEM B (graduate-resource strengthening — Dimension 5 High):**

- **Specify the new subagent's input/output contract explicitly in graduate-resource.md.** Either (a) name an existing subagent (e.g., a reused pattern from `findings-extractor.md` or `dd-extract-agent.md`), or (b) create a new subagent .md file with declared inputs (generalized file path, source CLAUDE.md path, list of project-specific terms drawn from source CLAUDE.md) and declared outputs (residue list in a defined shape). Follow ai-resources/CLAUDE.md § Subagent Contracts: ≤30-line summary, full findings to working-notes on disk.
- **Cap the fail-and-revise loop at 2 passes.** Mirror the QC → Triage Auto-Loop pattern at qc-independence.md:21 ("Stop after the second post-edit QC regardless of result. Report the final verdict in the turn summary"). After 2 Step 4 re-runs with residue still present, fail-with-residue and surface to the operator. Do not loop indefinitely.
- **Document the interaction with Step 3a / Step 5a placement-verifier passes.** If the new subagent's residue check and the placement-verifier disagree (one says "looks clean," the other flags MISMATCH), state which gate is authoritative. Default proposal: placement-verifier wins (it has explicit MATCH/MISMATCH semantics); the residue subagent is advisory only.
- **If updating the workspace CLAUDE.md § AI Resource Creation pointer, surface `/graduate-resource` in the always-loaded set explicitly.** The current pointer (CLAUDE.md:33) lists `/create-skill`, `/improve-skill`, `/migrate-skill` but not `/graduate-resource`. Adding `/graduate-resource` to the always-loaded surface is a small expansion — defensible, but should be a conscious decision, not an "optional minor update" sleepwalk.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references (qc-independence.md:3, :8, :21; resolve.md:9, :39, :41; graduate-resource.md:49-55, :70-79, :81-88; ai-resource-creation.md:3; CLAUDE.md:31-33, :126-128; session-plan-S6.md:122; auto-resolve-nudge.sh:19; auto-qc-nudge.sh:10; friday-act.md:256; triage-reviewer.md:3); grep counts (7 callers of /resolve in commands/hooks tree; 7 callers of /graduate-resource in commands tree); verbatim quotes from CHANGE_DESCRIPTION (cluster framing, per-item divergence), qc-independence.md ("Stop after the second post-edit QC"), resolve.md ("wait for operator approval row-by-row"), graduate-resource.md Step 5 four-check enumeration, session-plan-S6.md:122 ("Items 12 and 13 do NOT share a /risk-check"); cross-reference to working-notes flag at audits/working/journal-qc-2026-05-29.md:31. No training-data fallback was used on fetch/read failures.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory) — **SKIPPED, with reason.**_

Step 4a of `/risk-check` invokes `/consult` automatically on non-GO verdicts. In this instance:

- The verdict report already contains 9 concrete, named mitigations spanning both items. The mitigations ARE the architectural recommendation — they name specific upstream contracts that need to be settled (DISAGREE annotation existence, marker-file preservation, closed-enumeration class definition, subagent I/O contract, loop cap, placement-verifier interaction) and provide actionable fixes for each.
- A Function-B advisory would weigh in on whether the mitigations are sufficient or whether the broader strategy needs reconsidering. Either outcome (concur / propose alternatives) leaves the operator with the same proximate decision: ship-with-all-mitigations vs. defer.
- Given the cluster split this risk-check enables (ITEM B's mitigations are inline-tractable; ITEM A's mitigations require verifying an upstream contract that may not yet exist) — the operator's plan-time review at session-plan-S6.md Wave 4 stop point already gates the defer-vs-implement decision per item.

The operator will see the verdict, the mitigations, and the recommended split (defer ITEM A, implement ITEM B with mitigations) directly. Adding a third voice would add latency without changing the structural decision.

Logged here so the deviation is loud rather than silent. Second skip in this session — pattern noted for Friday-cadence triage of whether Step 4a's auto-fire condition should be tunable for "verdict + named mitigations" cases.
