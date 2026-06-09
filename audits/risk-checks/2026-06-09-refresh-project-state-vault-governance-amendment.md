# Risk Check — 2026-06-09

## Change

Plan-time risk-check on the refresh-project-state structural change package (Strategic OS). The change has three coupled parts:
(1) Amend knowledge-bases/strategic-os/CLAUDE.md governance to add a machine-maintained `project-state/` folder + a new `status: auto` tier + frontmatter additions. Exact proposed wording is in projects/strategic-os/docs/project-state-workflow-spec.md §15 (as revised this session). The amendment: adds Governance Rule 5 (project-state/ is workflow-written, Rule-1 operator-sole-writer relaxed within that folder only, with an explicit carve-out that the workflow MAY update project-state/_index.md and the vault-root _master-index.md for the atomic-index rule); adds an `auto` tier to Governance Rule 2 AND to the parallel Query-mode operating-mode rule (both canonical-only locations must change together); adds frontmatter keys project/as_of/source_commit/generator to auto notes.
(2) Authorize the refresh-project-state workflow as the SOLE automated writer of project-state/ — an automated shared-state writer that writes into the canonical Obsidian vault the Strategic OS reads directly (no human placement/promotion step between project raw content and the OS). The compensating control replacing the human write-gate is the per-project confidentiality scrub (in the snapshot agent) + an independent two-pass scrub-verifier (deterministic keyword scan + semantic pass) run over the whole batch before any vault write. Vault writes are atomic (note + project-state/_index.md + _master-index.md as a unit, rollback on partial failure).
(3) Wire the OS state-retrieval-agent to read the vault project-state/ as a NEW signal source (distinct from the forbidden other-project inputs/output trees; the vault is a standalone KB, not a project tree). No settings.json read-path change is needed — the OS already has Read(*) + workspace root in additionalDirectories.

Note: This is PLAN-TIME only. Nothing lands this session. The dev artifacts (command + 2 agents) are already built in ai-resources/workflows/refresh-project-state/.claude/ but are NOT graduated or symlinked. Session 2 lands the amendment + scaffolds the vault + graduates + wires + dry-runs after a GO. Report GO / PROCEED-WITH-CAUTION / RECONSIDER.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/docs/project-state-workflow-spec.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/knowledge-bases/strategic-os/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/knowledge-bases/strategic-os/_master-index.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/.claude/agents/state-retrieval-agent.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/refresh-project-state/.claude/commands/refresh-project-state.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/refresh-project-state/.claude/agents/project-state-snapshot-agent.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/refresh-project-state/.claude/agents/project-state-scrub-verifier.md — exists
- knowledge-bases/strategic-os/.claude/commands/ — checked; /kb-query, /kb-update, /kb-integrity present (exists)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A well-gated, mostly-reversible package whose one elevated risk is the deliberate relaxation of the human write-gate on canonical shared state (OP-2) — legitimate because it is loud and recorded, but it carries two concrete must-fix items (the scrub-verifier's own independence/permission posture, and the snapshot agents' own deny-list enforcement) before Session-2 land.

## Consumer Inventory

Search terms: `refresh-project-state`, `project-state` / `project-state/`, `status: auto`, `state-retrieval-agent`, `_master-index`, `Cross-Project Read Protocol`, `Operator is sole writer`. Greps run with absolute paths across the full workspace root (`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo`), which contains both the canonical repo and all project/KB trees.

| Consumer path | Reference type | Must change? |
|---|---|---|
| projects/strategic-os/.claude/agents/state-retrieval-agent.md | invokes (will read `project-state/`); parses (inclusion/exclusion lists) | yes |
| projects/strategic-os/CLAUDE.md § Cross-Project Read Protocol | parses (the exclusion hard-rules the agent restates); documents | yes |
| knowledge-bases/strategic-os/CLAUDE.md (vault governance) | parses (the governance text being amended — Rule 1, Rule 2, Query-mode, Note Frontmatter) | yes |
| knowledge-bases/strategic-os/_master-index.md | co-edits (atomic-index write target — new `## Project State` section + Recent-updates line) | yes |
| knowledge-bases/strategic-os/.claude/commands/kb-query.md | parses (reasons "only against canonical"; `auto` tier changes what is queryable) | yes |
| knowledge-bases/strategic-os/.claude/commands/kb-update.md | parses (atomic tri-write + "status is operator-only / never auto-promote") | no (workflow bypasses kb-update; but its "operator-only status" claim becomes narrower-than-governance unless noted) |
| knowledge-bases/strategic-os/.claude/commands/kb-integrity.md | parses (Check B missing-frontmatter; Check D index-drift over fixed folder list `research/architecture/decisions/findings`) | yes |
| projects/strategic-os/.claude/commands/{strategic-state, strategic-state-refresh, strategic-decision, prioritize, strategic-review, os-self-review}.md | invokes state-retrieval-agent (downstream callers whose state-feed content changes) | no (compatible — they consume the agent's JSON, schema unchanged) |
| projects/strategic-os/.claude/settings.json | imports (Read(\*) + additionalDirectories already cover the vault; deny rules on `*deal-*/*client-*/*confidential*`) | no |

Total: 9 distinct consumer rows; **6 must-change** (state-retrieval-agent, OS CLAUDE.md Cross-Project Read Protocol, vault CLAUDE.md, _master-index.md, kb-query, kb-integrity). The new contract (`refresh-project-state` token, `project-state/` folder, `status: auto` tier) has **zero current consumers** outside the spec itself (grep for `refresh-project-state` and `status: auto` returned only the spec / dev artifacts) — its sole consumer (state-retrieval-agent) is wired in the same package. The six dev artifacts already in `workflows/refresh-project-state/` are not yet symlinked, so they are not live consumers.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The amendment adds ~4 short clauses to the vault `CLAUDE.md` (Rule 5, the `auto` tier line, the Query-mode clause, the frontmatter keys) — vault CLAUDE.md is loaded only in vault-rooted sessions, not in OS or other-project sessions (`knowledge-bases/strategic-os/CLAUDE.md` lines 53-68 are the amendment site; it is a project-scoped CLAUDE.md, not an always-loaded workspace file).
- The OS `state-retrieval-agent` brief gains one inclusion-list entry (spec §6.1) — the agent is `model: sonnet` and invoked on demand by `/strategic-state` and four other commands, not per-turn (`state-retrieval-agent.md` line 4; six invoking commands found in grep). No auto-load hook, no `@import` into an always-loaded file.
- No SessionStart/Stop/PreToolUse hook is added by this change. The workflow runs only when the operator runs `/refresh-project-state` (`refresh-project-state.md` line 22).
- Pay-as-used: the snapshot fan-out and two-pass verify cost tokens only on an explicit refresh run, not ambiently.

### Dimension 2: Permissions Surface
**Risk:** Medium

- The OS `.claude/settings.json` confirms the spec's claim: `Read(*)`, `Glob(*)`, `Grep(*)` allow + `additionalDirectories: ["/Users/.../Axcion AI Repo"]` (settings.json lines 5-7, 41-43). The vault sits under that root with no deny rule covering it, so **no OS read-path widening is needed** — the wiring is an agent-brief inclusion-list edit only, not a permission grant. Good.
- BUT the package introduces a **new automated write path into canonical shared state**: the orchestrator writes `knowledge-bases/strategic-os/project-state/*.md` + `_index.md` + `_master-index.md` (`refresh-project-state.md` Step 4 lines 56-60). The dev orchestrator has no settings.json yet (it lives un-graduated in `workflows/`); the graduated command + snapshot agent (`Write` in its tools list, `project-state-snapshot-agent.md` lines 5-11) will need a scoped `Write(knowledge-bases/strategic-os/project-state/**)` and a staging-write allow (`Write(ai-resources/audits/working/**)`). That is a new write-capability into a tree that was previously human-write-only — a genuine surface addition, scoped narrowly. Medium, not High, because it is folder-scoped (`project-state/` only), not a broad `Write(**)`.
- The snapshot agent's confidentiality guarantee is an **in-prompt** read-block (`project-state-snapshot-agent.md` lines 34-36: "MUST NOT read or quote any file matching `*deal-*`...") — it is NOT backed by a settings.json `deny(Read(**/*deal-*))` in the scanned projects' own settings layers. The OS settings.json *does* carry those deny rules (lines 35-37), but the snapshot agents run inside each *target* project, under that project's settings, where the deny rule may be absent. This is the load-bearing confidentiality control and it currently rests on prompt-adherence, not a hard permission boundary. Flagged as a mitigation item.

### Dimension 3: Blast Radius
**Risk:** Medium

- Per the Step 1.5 inventory: **9 consumer rows, 6 must-change.** None of the must-change consumers *breaks* on the change — they require additive edits to stay correct, not rescue from breakage.
- Contract changes (the `parses` rows): the `auto` tier touches three governance locations that all assert "canonical-only" reasoning — vault CLAUDE.md Rule 2 (line 56), the Query-mode rule (line 33), and `kb-query.md` reasoning rule (line 23). The spec §15 correctly catches the first two (and notes its QC found the second). **The inventory surfaces a third the spec §15 wording does NOT name: `kb-query.md` line 23** ("Reason only against notes with `status: canonical`"). If `kb-query` is meant to surface `auto` notes too, that command body must change in lockstep, or `/kb-query` will silently ignore `project-state/` snapshots while the OS reads them — an inconsistency between the two readers of the same folder. This is a blast-radius gap not anticipated by the amendment wording.
- `kb-integrity.md` is a second un-anticipated consumer: Check B (line 27) FAILs notes "missing any of status/last_updated/Related" — `auto` notes satisfy this. But Check D (line 37) iterates a **hardcoded folder list** `research/architecture/decisions/findings` and will not scan `project-state/` for index-drift, leaving the new folder's index unguarded. Either acceptable-by-design (workflow owns its own atomic index) or a gap to close — call it out.
- `_master-index.md` is co-edited every run (new `## Project State` section + Recent-updates line, spec §5.2) — shared infra touched by an automated writer.
- The six OS commands that invoke the agent (`strategic-state`, `prioritize`, etc.) are compatible — they consume the agent's JSON output schema (`state-retrieval-agent.md` lines 21-39), which the change does not alter; only the *content* feeding it grows.

### Dimension 4: Reversibility
**Risk:** Medium

- The governance amendment itself is a clean single-file `git revert` on vault CLAUDE.md (text-only edit).
- BUT the package crosses several reversibility seams that a single revert does not clean:
  - **First vault writes create sibling files** (`project-state/*.md`, `project-state/_index.md`) and mutate `_master-index.md`. A `git revert` of the amendment does not delete the snapshot notes nor un-edit `_master-index.md`'s Project-State section — manual cleanup of the folder + the index section is required. This is why the spec §14 splits Session 1 / Session 2 at exactly this seam (`project-state-workflow-spec.md` lines 177-194) — good discipline.
  - The vault is its own git tree (the spec references "vault submodule dirty / detached", §9 line 148), so revert is per-repo; an operator must remember to revert in the vault tree, not just the canonical repo.
  - The OS `state-retrieval-agent` and OS `CLAUDE.md` Cross-Project Read Protocol live in the project tree — a third revert locus.
- Net: revert works but is **multi-step across three trees + a folder cleanup**, not a one-shot. The plan-time/Session-2 split keeps every irreversible write behind the GO gate, which is the right mitigation; scored Medium because the rollback is multi-step rather than propagated-beyond-git (no push, no external write, on-demand only — `refresh-project-state.md` line 22).

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **`source_commit` granularity coupling** (already self-documented, but real): `git -C "{PROJECT_DIR}" rev-parse` resolves to the nearest enclosing repo, so a project that is a plain subdir of the workspace repo yields the *workspace* HEAD, not its own — its §6.2 staleness check then reads stale on any workspace commit (`project-state-snapshot-agent.md` lines 40-41). The OS's freshness logic (spec §6.2) silently inherits this coarseness. Documented, but it is an implicit dependency on each target's git topology that the OS-side staleness flag does not see.
- **Two readers, one folder, divergent contracts:** the OS reads `project-state/` as authoritative (spec §6.1) while `/kb-query` (vault-side) still reasons canonical-only unless its body is amended (see Dim 3). Two systems reading the same notes with different authority rules is a classic hidden-coupling trap — closed only if the kb-query body change lands with the governance amendment.
- **Confidentiality control is a prompt contract, not a structural one:** the entire compensating-control story (replacing the human write-gate) rests on (a) the snapshot agent obeying an in-prompt read-block and (b) the scrub-verifier being genuinely independent. The verifier is a separate agent (`project-state-scrub-verifier.md`) and judges "fresh" (line 15) — good — but it shares the orchestrator and runs in the same session; its independence is by-prompt, and it is invoked by the same command that writes the vault. No structural firewall enforces that a FAIL cannot be written.
- **Atomic tri-write "rollback" is in-prompt, not transactional:** "if any single write fails, roll back the others" (`refresh-project-state.md` line 61) depends on the orchestrator holding prior content in memory and re-writing it — there is no filesystem transaction. A crash mid-rollback leaves index drift, the exact failure the vault's atomic rule exists to prevent (vault CLAUDE.md line 46).

### Dimension 6: Principle Alignment
**Risk:** Medium

Principles-base read at `projects/strategic-os/ai-strategy/principles-base.md` (frozen-ID index, 41 active).

- **OP-2 (automate execution; gate judgment) — the central tension.** OP-2 reserves operator oversight for "load-bearing/judgment decisions (hard-to-reverse, **shared-state**, future-shaping)" (principles-base line 40). Writing snapshots into the canonical vault the OS reads directly is exactly a shared-state write, and the change *removes the human write-gate* and replaces it with automated scrub controls. This is a real relaxation of OP-2's default, not a no-op. It does NOT score High because the relaxation is **loud and recorded** (OP-11/OP-3): spec §5.3 surfaces the governance conflict explicitly with three options and a DECIDED rationale (`project-state-workflow-spec.md` lines 104-114), and the amendment text itself (§15) names the relaxation and its compensating controls in the governance file. That is the legitimate OP-11 mechanism, so it is tension, not violation. Medium.
- **QS-9 (automation passes the SAME QC + risk-check gates).** Satisfied — this very risk-check, plus the spec's Session-2 dry-run + §13 acceptance criteria, are the gate (principles-base line 75; spec §13-14). Aligned.
- **OP-12 (closure before detection).** The scrub-verifier is new *detection*, but it ships behind a working *closure* channel: FAIL → snapshot withheld → surfaced to operator (`project-state-scrub-verifier.md` line 15; `refresh-project-state.md` line 50). Detection does not ship ahead of closure. Aligned — this is OP-12-positive.
- **OP-5 (advisory vs enforcement).** The workflow *acts* (writes the vault) rather than advises-and-stops, and the scrub-verifier *auto-withholds* — this is enforcement-flavored automation. But it is a per-component, explicitly-decided authority (spec §10 decision 1, the `/risk-check`-class flag), which is exactly how OP-5 says enforcement authority must be granted (principles-base line 43). Aligned-with-note, not a violation.
- **DR-7 / OP-9 / AP-7 (speculative abstraction).** The new contract (`project-state/` folder, `auto` tier) has zero current consumers (grep confirmed) — but its consumer (the OS state-retrieval-agent) lands in the *same* package, and the producer (the workflow) is its second concrete consumer. This is a first-consumer-with-producer landing, not "hooks for a Phase-2 that doesn't exist." No violation.
- **DR-8 (gated structural change).** Correctly routed through `/risk-check` at plan-time with the Session-1/Session-2 split (spec §14). Aligned.
- **OP-10 (system boundary = Claude Code).** The vault and all readers are Claude Code; no cross-tool governance introduced. Aligned.
- **DR-1 / DR-3 (placement).** Command + agents graduate to `ai-resources/` canonical (spec §12); vault changes live in the vault. Correct tiers. Aligned.

Net: one genuine principle *tension* (OP-2 shared-state gate relaxation), handled the loud/recorded way OP-11 licenses → Medium, not High.

## Mitigations

- **Dimension 2 (Permissions) — snapshot-agent confidentiality must rest on a hard boundary, not only prompt-adherence.** Before Session-2 land, confirm each target project's own settings layer carries `deny(Read(**/*deal-*))`, `deny(Read(**/*client-*))`, `deny(Read(**/*confidential*))` (mirroring the OS settings.json lines 35-37), so the snapshot agent running *inside* that project cannot read confidential files even if its in-prompt block is bypassed. Where a target project lacks these denies, add them (or accept the risk explicitly per-project). Do not rely on the in-prompt read-block as the sole control.
- **Dimension 2 (Permissions) — graduate with a folder-scoped Write grant only.** When the command graduates, add exactly `Write(knowledge-bases/strategic-os/project-state/**)` + `Write(ai-resources/audits/working/**)` (staging) and nothing broader. Confirm no `Write(knowledge-bases/strategic-os/**)` wildcard leaks in — the operator-sole-writer relaxation is scoped to `project-state/` only (amendment Rule 5).
- **Dimension 3 / Dimension 5 (Blast radius + Hidden coupling) — close the third canonical-only location in lockstep.** The §15 amendment names two canonical-only sites; the inventory found a **third: `kb-query.md` line 23**. Decide and apply in Session 2 whether `/kb-query` surfaces `auto` notes in `project-state/`. If yes, edit the kb-query body together with the governance amendment so the vault-side and OS-side readers agree; if no, record in the amendment that `auto` is OS-readable but intentionally outside `/kb-query` scope. Either way, do not land the governance amendment without resolving kb-query, or the two readers diverge silently.
- **Dimension 3 (Blast radius) — extend `/kb-integrity` Check D to `project-state/` or document the exemption.** Check D's folder list (`kb-integrity.md` line 37) does not include `project-state/`. In Session 2, either add it (so index-drift on the machine folder is still caught) or record in the amendment that `project-state/` index integrity is owned by the workflow's atomic write and intentionally outside kb-integrity's scan.
- **Dimension 5 (Hidden coupling) — verify the atomic-write rollback under a forced mid-write failure in the Session-2 dry-run.** The "roll back the others" guarantee (`refresh-project-state.md` line 61) is in-prompt, not transactional. The §13 acceptance criterion 4 already calls for a forced-failure test — treat it as blocking: confirm a forced failure leaves no index drift before the first full run.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, and the OS settings.json contents). The principles-base index was readable at `projects/strategic-os/ai-strategy/principles-base.md`; principle IDs cited from it. No training-data fallback was used on any read.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION. `/consult` was unavailable via the Skill tool (disable-model-invocation); the `system-owner` agent it delegates to was invoked directly. Full advisory on disk: projects/axcion-ai-system-owner/output/consultations/consult-2026-06-09-refresh-project-state-package-risk-check-second-opinion.md_

**1. Verdict — CONCUR with PROCEED-WITH-CAUTION.** Structurally sound, correctly gated with a clean Session-1/2 split. Not GO (the confidentiality boundary is not yet structural). Not RECONSIDER (the write-gate relaxation is real but handled the loud/recorded way the principles license — surfaced in spec §5.3, not smuggled). One sharpening: two mitigations are **GO-gates, not Session-2 line items** — the verdict must not drift to GO until they hold.

**2. The five mitigations are the right five.** Re-weighting:
- **#1 (target-project deny rules) and #2 (folder-scoped `Write`) carry the package — both are GO-gates.** Verified: the snapshot agent holds the confidentiality block in prose only, with raw `Read/Glob/Grep/Bash` granted and no settings-layer deny behind it inside target projects. Without #1, the load-bearing control is a sentence in a prompt.
- **#3 (kb-query 3rd canonical site)** — correctness-load-bearing, land in lockstep; silent divergence, not a breach.
- **#4 (kb-integrity Check D)** — cheapest, do it; also the recovery path for the rollback gap below.
- **#5 (forced-failure test)** — load-bearing, correctly scoped to before-first-run.

**3. What the six-dimension review MISSED (three):**
- **3a — the §13 rollback test gives false confidence.** It can verify rollback under a *handled* write error, but cannot verify crash-mid-rollback (process dies, in-memory prior content gone) — the exact index-drift the vault's atomic rule exists to prevent. Structural limit of in-prompt rollback. Disposition: either name it as accepted/`/kb-integrity`-recoverable residual, or take the structural fix (write-temp-then-rename `_master-index.md` last so the pointer flips atomically).
- **3b — `source_commit` coarseness is a wrong-input-to-judgment risk, not cosmetic.** For subdir projects `git -C` resolves to workspace HEAD, so a stale strategic snapshot can read as fresh to the OS that feeds firm roadmap decisions. Documented ≠ mitigated.
- **3c — the standalone-KB home is acceptable, but the package quietly changes what the vault IS.** The vault declares itself operator-sole-writer (Rule 1); the carve-out makes it two stores at once. The home is fine and the Cross-Project Read Protocol is genuinely not breached — but it wants one explicit sentence in the amendment naming `project-state/` as a deliberate vault-identity exception, so no future reader assumes operator-sole-writer holds vault-wide.

**4. Position:** PROCEED, with #1/#2/#5 promoted to hard GO-gates, #3 in lockstep, #4 done, plus the §13 acceptance criteria noting the test covers handled errors only, and one amendment sentence naming the vault-identity exception. The two things to carry: the false-confidence rollback test (3a) and the silent dual-identity vault (3c) — both want a recorded sentence, not a silent pass.
