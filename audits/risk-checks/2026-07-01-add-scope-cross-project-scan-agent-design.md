# Risk Check — 2026-07-01

## Change

Proposed structural change: add a new agent `scope-cross-project-scan` to the /scope-project workflow as a Stage-1 adjunct. It performs bounded, read-only cross-project reads across projects/* (each sibling's CLAUDE.md + routing-named files, ≤2 files per project) and returns a ranked {project → relevant files → why} list that becomes candidate raw material for Stage 2 synthesis. Recommended tier opus (relevance judgment; sonnet fallback). Toolset Read/Glob/Grep/Write, no Bash/Edit/commit. Key risk-defusing choice: it surfaces paths + one-line rationale only, never copies sibling file contents. Design doc: audits/working/2026-07-01-S3-scope-cross-project-scan-agent-design.md. NOTE: this session is design-only — the build is deferred; this risk-check evaluates the design before any build.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/2026-07-01-S3-scope-cross-project-scan-agent-design.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/scope-project.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/scope-synthesis-agent.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/context-discovery.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/project-scoping/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/agent-tier-table.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/scope-cross-project-scan.md — not yet present

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The design is well-bounded and precedent-backed, but the confidentiality control (a `⚠ sensitive-source` flag in place of the established scrub-verifier) is a High on Hidden Coupling that has a viable paired mitigation, so the design may proceed only with that mitigation applied at build time.

## Consumer Inventory

The agent file itself is `not yet present`, so it has no consumers yet. This inventory covers (a) the consumers of the *contract* the agent introduces at build time — the Stage-1 adjunct hook, the tier-table row, the SKILL.md authorization line — and (b) the components the design's own build checklist (§7) commits to co-editing.

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/.claude/commands/scope-project.md | co-edits | yes (build checklist §7.2: add Stage-1 adjunct hook) |
| ai-resources/skills/project-scoping/SKILL.md | co-edits | yes (build checklist §7.3: add authorization line) |
| ai-resources/docs/agent-tier-table.md | documents | yes (build checklist §7.4: register one row) |
| ai-resources/.claude/agents/scope-synthesis-agent.md | invokes (indirect) | no — receives operator-accepted paths through the existing "Raw material paths" input #1 (scope-synthesis-agent.md:17); its contract is unchanged |
| ai-resources/logs/session-plan-2026-07-01-S3.md | documents | no (session record) |
| ai-resources/logs/session-notes.md | documents | no (feature-idea + mandate record, lines 476/482/487) |
| workspace-root .claude/settings.json (deny block) | parses (relied-on) | no — the three `Read(**/*deal-*|*client-*|*confidential*)` deny patterns already exist and govern the new agent's reads; the design depends on them but does not modify them |

Total: 7 consumers, 3 must-change (all three are the design's own committed co-edits in §7 — none is an unanticipated consumer). The grep for `scope-cross-project-scan` returned 4 hits outside the design doc, all in `logs/` (session-plan + session-notes) — documentation references to the planned feature, not live invocations. No hidden consumer surfaced that the design did not anticipate.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Pay-as-used adjunct, not always-loaded. The agent is a `.claude/agents/` definition spawned only on demand at the Stage-1 gate of `/scope-project`, which is itself the low-frequency complex-build lane — "Optional adjunct, consistent with /scope-project's other adjuncts... gate-placed, SKIP-able, never blocking" (design §2). No content is added to any always-loaded CLAUDE.md, no hook is registered, no `@import` is added.
- The one row added to `agent-tier-table.md` (§7.4) is not always-loaded — the table's own header states "When to read this file... Not needed for every turn" (agent-tier-table.md:3).
- Tier cost is opus-per-run, flagged by the design itself as the sole cost lever (§6, OQ-1) with a structured sonnet fallback. Because invocation frequency is low (per complex-build scoping run, adjunct, SKIP-able), the opus choice does not create ongoing session cost — it is bounded to the runs where it fires.

### Dimension 2: Permissions Surface
**Risk:** Low

- No new permission entry is required and none is proposed. Toolset is `Read`, `Glob`, `Grep`, `Write` — identical to the existing `context-discovery` agent (context-discovery.md:5-9) and `scope-synthesis-agent` (scope-synthesis-agent.md:5-9). Explicitly "No Bash, no Edit, no commit" (design §6, §4).
- Cross-project reach is already-authorized capability, not a widening. The workspace root is a mounted `--add-dir` and reads across `projects/*` are governed by the existing workspace-root `deny` block (`Read(**/*deal-*)`, `Read(**/*client-*)`, `Read(**/*confidential*)` — workspace-root settings.json:28-30) plus the ai-resources `deny` block (`Read(archive/**)`, `Read(**/deprecated/**)` — ai-resources/.claude/settings.json:25-30). The design commits to respecting these (§3: "Skip archive/**, **/deprecated/**, output/** per existing deny rules").
- Write is scoped to the agent's own single report (`projects/project-planning/output/{project}/cross-project-scan.md`, design §5) — same posture as the other scope agents; no widening.

### Dimension 3: Blast Radius
**Risk:** Medium

- Grounded in the Consumer Inventory: 7 consumers, 3 must-change. All three must-change consumers are the design's own committed co-edits (§7.2 scope-project.md, §7.3 SKILL.md, §7.4 agent-tier-table.md) — anticipated, not surprises.
- No contract is broken. The scan feeds the *human-gated input pile*, not `scope-synthesis-agent` directly: "No agent-to-agent handoff. The scan feeds the human-gated input pile, not scope-synthesis-agent directly" (design §2). Accepted paths flow through the existing "Raw material paths" input #1 of `scope-synthesis-agent` (scope-synthesis-agent.md:17) — so the downstream agent's parse contract is untouched. This is why the `invokes (indirect)` row is `must-change? = no`.
- The scope-project.md hook is additive and gate-placed. The command already carries a SKIP path for adjuncts (scope-project.md:26) and already lists optional adjuncts at other stages (`/tech-consult`, `/consult`, `/blindspot-scan`, `/implementation-triage` — scope-project.md:43,53,72), so a Stage-1 adjunct slots into an established pattern rather than reshaping the orchestrator.
- Medium (not Low) because the change touches three files across two resource types (command + skill + doc table) in lockstep — above the "single isolated file" Low bar — but every touched consumer stays compatible and the co-edits are backwards-compatible additions.

### Dimension 4: Reversibility
**Risk:** Low

- Clean `git revert` restores prior state. The build produces a new agent file plus three additive edits (a Stage-1 adjunct block, one SKILL.md authorization line, one tier-table row) — all in-tree, all git-tracked, no data/log mutation and no external write. Reverting the commit removes the agent and the three additions together.
- The agent's runtime output is a per-run report under `output/{project}/` (design §5) — a generated artifact, not an append-only shared log; deleting a stale report is at most a trivial cleanup, and the design is deferred so no report exists yet.
- No automation fires between landing and revert: no hook, no cron, no symlink. The design commits to "Exclude from auto-sync (consistent with the other scope-* agents)" (§7.5), so no symlink-propagation cleanup is needed either.
- The change is design-only this session (build deferred), so nothing has landed yet — reversibility of the *design doc* is trivial.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Undocumented-strength confidentiality control substituted for an established one.** The precedent the design leans on — `refresh-project-state` (+ `project-state-snapshot-agent`, `project-state-scrub-verifier`) — does bounded read-only cross-project reads, but it does so behind a **load-bearing** confidentiality apparatus: a per-session active-load probe and a two-pass scrub-verifier, because (verbatim) "a filename deny cannot catch client names embedded in normally-named files" (refresh-project-state.md:14, Step 1.5). The new agent reads exactly such normally-named files — each sibling's `CLAUDE.md` and routing-named index files (design §3). The design judges the scrub "largely moot... this agent copies no content, so the scrub's purpose is largely moot — the flag is the proportionate control" (§4). But the risk the scrub defends against is not content-*copying* — it is a client/deal name *appearing in the reasoning*: the agent's own "why" line, or the ranked project name itself (`buy-side-service-plan` is named in §4.3 as a candidate). A path + rationale that reads "`buy-side-service-plan/CLAUDE.md` — relevant because it scopes the [ClientName] mandate" leaks the sensitive fact into the scoping project's artifact even though no file was copied. The `⚠ sensitive-source` flag is applied *after* the agent has already read and reasoned over the sensitive material — it flags, it does not prevent. This is a High: the change relies on an implicit "no leak without copy" assumption that the established precedent explicitly rejects.
- **Silent dependency on where the agent is launched from.** The workspace-root deny patterns (settings.json:28-30) protect the reads only if the session loads workspace-root settings — the precedent aborts hard when that guard is not active-loaded (refresh-project-state.md:36). The design's §3 precondition check tests *reachability* of the workspace root but does not test that the confidentiality *deny* is live-loaded for the session. Patrik launches via the VS Code extension by opening a folder (memory: `feedback_vscode_launch`), so the session root is not guaranteed to be workspace root — the deny could be configured but inactive, and this agent has no probe to catch that.
- One contract *is* documented at the change site (the ranked `{project → files → why}` schema, design §5; the ≤20-line summary parse contract), which is good — but it does not offset the confidentiality coupling above.

### Dimension 6: Principle Alignment
**Risk:** Medium

principles-base.md was readable (projects/strategic-os/ai-strategy/principles-base.md). Cited IDs below are grounded in it.

- **DR-7 / OP-9 / AP-7 (speculative abstraction) — clears, does not violate.** The Consumer Inventory shows the feature has a *confirmed, named consumer today*: `/scope-project` Stage 1, with a concrete triggering need recorded by the operator (session-notes.md:476: scoping a LinkedIn strategy → surface `positioning` + `axcion-brand-book` files). This is not a "hook for Phase 2" — it is built for an existing workflow with a felt gap ("the absence of this pass would be felt", session-notes.md:476). DR-7's second-consumer bar is not the relevant test here because the agent is specific to one consumer, not a generalization. No violation.
- **OP-10 (system boundary) — Low, actively respected.** The agent reads *Axcíon project files inside Claude Code's own repo tree*; it does not reach into GPT/Perplexity/NotebookLM/Notion. Cross-project ≠ cross-tool. No boundary expansion.
- **OP-5 (advisory vs enforcement) — Low, stays advisory.** The agent "surfaces, don't decide" (design §2): it returns candidate pointers to a human-gated pile; the operator marks which to accept (design §2, step 3). It advises and stops — no enforcement upgrade.
- **OP-2 / AP-4 (automate execution, gate judgment) — Low.** The load-bearing judgment (which pointers to accept, whether a sensitive source is admissible) stays operator-gated at the Stage-1 gate. The agent automates the *discovery*, not the *decision*. Correct split.
- **DR-6 / OP-3 confidentiality tension → the Medium here.** The design *does* surface the confidentiality question loudly (§4, OQ-2) rather than resolving it silently — which is the OP-3 / OP-11 "loud, not drift" posture and is to its credit. But by pre-selecting "flag-not-exclude" and judging the scrub "largely moot" (§4), it edges toward relaxing the precedent's confidentiality control without recording that as an explicit revision of the `refresh-project-state` standard. That is a tension, not a clear violation — the design flags it for `/blindspot-scan` (OQ-2) and defers the call. Named: the tension is with the established confidentiality-scrub standard behind DR-6's read-only cross-project posture. Because it is surfaced (not drifted), this is Medium, not High.

## Mitigations

Required for the High on Dimension 5 (Hidden Coupling). Apply at build time before landing:

- **Mitigation for Dimension 5 (confidentiality leak-without-copy):** In the deferred build, resolve OQ-2 toward **exclude-by-default for confidentiality-sensitive projects**, not flag-after-read. Concretely: the agent must screen candidate project dirs against the confidentiality-sensitive set (the design already names `buy-side-service-plan`, `strategic-os` in §4.3) *before* reading their `CLAUDE.md`/routing files, and skip them unless the operator has explicitly opted them in for this run via the `EXCLUDE`/opt-in input (contract §5). This moves the control ahead of the read+reason step so a client/deal fact cannot enter the agent's "why" line or the ranked list in the first place. The `⚠ sensitive-source` flag stays as a secondary signal for borderline projects, but it is no longer the sole control. This is the change that reduces Dimension 5 from High to Low.
- **Mitigation for Dimension 5 (launch-root deny not active-loaded):** Add a precondition probe (mirror `refresh-project-state.md` Step 1.5's active-load probe) that confirms the three `Read(**/*deal-*|*client-*|*confidential*)` deny patterns are *live for this session*, not merely present in workspace-root settings.json — and abort the scan (return "reach unavailable") if they are not. This closes the VS-Code-launch-root gap where the deny is configured but inactive.
- **Mitigation for Dimension 6 (Medium, optional but recommended):** In the build's SKILL.md authorization line (§7.3), state explicitly that this agent uses the *lighter* control (pre-read exclusion + flag) rather than the full `project-state-scrub-verifier`, and why (no content-copying). Recording the difference makes the relaxation a loud, deliberate choice (OP-11) rather than a silent divergence from the `refresh-project-state` precedent.

## Recommended redesign

(Verdict is PROCEED-WITH-CAUTION — no full redesign required; see Mitigations.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references (scope-project.md:26,43,53,72; scope-synthesis-agent.md:17; context-discovery.md:5-9; agent-tier-table.md:3; refresh-project-state.md:14,36, Step 1.5; workspace-root settings.json:28-30; ai-resources/.claude/settings.json:25-30; design doc §2–§7, OQ-1/OQ-2), grep counts (scope-cross-project-scan = 4 log hits, all documentation), verbatim quotes from the design doc and precedent, and principle IDs from principles-base.md (DR-7/OP-9/AP-7, OP-10, OP-5, OP-2/AP-4, DR-6, OP-3/OP-11). No training-data fallback was used on fetch/read failures.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

**Full advisory on disk:** projects/axcion-ai-system-owner/output/consultations/consult-2026-07-01-scope-cross-project-scan-riskcheck-2nd-opinion.md

**Position:** Concur with PROCEED-WITH-CAUTION. The three mitigations are the right path — mitigation 1 (pre-read exclusion) is load-bearing and non-negotiable; 2 and 3 each close a real gap.

**Routing:** Placement uncontested — canonical agent at `ai-resources/.claude/agents/`, auto-sync-excluded (repo-architecture Q2; `risk-topology.md § 3`). The exclusion is a correctness boundary, not cosmetic: an agent that reads *across* sibling dirs must never be symlinked *into* one. Confirm it lands in `EXCLUDE_AGENT_GLOBS`.

**On the three mitigations:**
1. The "no leak without content-copy" assumption is the actual defect. The leak vector is a client/deal name entering the agent's *own reasoning* (the "why" line / ranked project name), not a copied body. A control that fires after the read is silent-continuation wearing a label (`principles.md § OP-3`). Concur.
2. Deny-probe closes a real operator-specific gap — VS Code folder-launch means workspace-root deny can be present-but-inactive. Concur.
3. SKILL.md authorization line is the OP-11 obligation — records the relaxation as deliberate, not drift. Makes it a governed variant vs. a fork.

**Risk missed:** The confidentiality guarantee depends on three workspace-root deny patterns, but `risk-topology.md § 1` doesn't register them as a two-end contract. A future `/permission-sweep` could rename them and silently stale the probe's hard-coded list. Add a two-end-contract comment at both ends (`risk-topology.md § 5`).

**Risk understated:** Mitigation 1 must cover the schema's **"Scanned but not relevant"** section (and "Reach notes") too — otherwise "`buy-side-service-plan` — nothing surfaced" writes the sensitive name into the artifact anyway. Exclusion is from *every* output section, not just the ranking.

**Named conflict:** Design leans "flag-not-exclude (surfacing > suppression)"; mitigation reverses to exclude-by-default. Resolution isn't a compromise — exclude-by-default *with operator opt-in* IS the loud-surfacing posture (show the excluded set, let the operator choose). The instinct was right; only the ordering was wrong.

Build correctly deferred; re-run `/risk-check` end-time gate before commit (`principles.md § DR-8`).
</content>
</invoke>
