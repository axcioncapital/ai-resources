---
mission_id: research-workflow-deploy-fitness
mission_name: Research workflow — Sector Intelligence deployment-fitness fixes
status: active            # active | paused | completed
started: 2026-07-13
revised: 2026-07-13       # S10 — operator's revised 8-item fix set supersedes the S8 thread list
---

<!--
  MISSION CONTRACT — a multi-session goal that individual sessions serve.
  Scaffolded by `/mission create` (S8). REVISED in S10, before any implementation session ran,
  to the operator's 8-item fix set. This is authoring, not drift: at revision time the mission
  was uncommitted and had served zero sessions, and `/mission create` step 10 explicitly directs
  the operator to complete the contract "before any implementation session." From here on the
  Goal / scope / Validation contract are frozen — only `status` and `## Open threads` may change.

  NOTE: `/mission` exposes create | list | read | close and NO update verb, so this revision was
  written directly. That gap is logged in `logs/improvement-log.md` (2026-07-13, S10).

  "Sessions served" is NOT stored here — `/mission read` renders it live by scanning
  logs/session-notes.md for the `Mission: {mission_id}` mandate bullet.

  Diagnosis of record: audits/research-workflow-deployment-fitness-2026-07-13.md (§1–7, unchanged).
  Finding IDs (C-1, D-3′, F-7 …) refer to that report. Where this plan and the audit's §4/§7 fix
  lists disagree, THIS FILE GOVERNS — the operator's S10 revision is the current fix set.
-->

## Goal

The canonical research workflow template and `/deploy-workflow` carry the eight general fixes below, each verified against the real command→skill handoff or real deployment behaviour (not against documentation), so that `/deploy-workflow` can be run for the Sector Intelligence pilot against a template that is correct **for any project** — not one bent toward this one. After deployment, the deferred threads close on their named triggers.

The organising constraint, which is what makes this mission hard: **the template must be able to receive project-declared requirements without containing them.** Every fix below adds a channel (a config value, a declared input, a recorded justification) rather than a hard-coded answer.

## In scope / Out of scope

- **In:** the canonical workflow under `workflows/research-workflow/` (commands, reference docs, template `CLAUDE.md`, `SETUP.md`, `.gitignore`, settings, shared-manifest); the canonical skills named in the threads (`claim-permission-gate`, `country-parity-checker`, `research-structure-creator`, `research-plan-creator`); `.claude/commands/deploy-workflow.md`; `docs/project-config-schema.md`; and the verification each thread's acceptance test needs.
- **Out:** creating or customizing the Sector Intelligence project (that happens after deployment, in the deployed project); the pilot's research content and per-unit configuration; the programme pack's §13 strategy decisions; rewriting the audit's findings rather than fixing files.

**Explicitly not to be built** (operator, S10 — these are the shapes an implementation session will be tempted into and must refuse):

- Research tiers.
- Stage-2 execution automation (the manual model is confirmed; `execution-agent` stays unwired for Stage 2).
- Exa integration.
- Source-memory infrastructure.
- A new claim-permission class (thread 5 is a *clarification* of the existing classes).
- A full counter-search agent / `counter-search-runner` (thread 6 is a *record requirement*, not a search subsystem).
- A large declared-outline system (thread 4 is a *pass-through*, not an architecture subsystem).

## Validation contract

> Frozen at revision, before any implementation session. Defines "done" and "on-mission" independently of how the work gets done, so a fresh-context check (`/drift-check`, `/contract-check`, `/qc-pass`) can judge against it rather than against a session's own account of itself.

**Acceptance assertions** — concrete statements that must ALL be true when the mission is complete. Each is stated as an *observable* test, and each must be run against real behaviour, not read off the diff:

- [ ] **1 · Stage-3 path.** In a scratch project, `/run-cluster` followed by `/run-sufficiency` completes Phase A and Phase C pre-flights and produces permission and parity tables — no "run `/run-cluster` first" exit.
- [ ] **2 · Placeholder handling.** A fresh `/deploy-workflow` run fills every deploy-time placeholder (including `{{CONFIDENTIAL_IDENTIFIER_N}}`) and **no** others; every `*.template.md` file and every unused optional component survives byte-identical; the leftover-placeholder validation passes and never prompts for a template-internal value.
- [ ] **3 · Deploy hygiene.** `git ls-files` in a freshly deployed project shows no `.claude/settings.local.json`; `/deploy-workflow` on a `PATH` without `python3` fails loudly *before* creating symlinks; the deploy completion message names every still-unfinished SETUP obligation with its template path.
- [ ] **4 · Architecture pass-through.** With a project-declared document architecture, approved section directives, and mandatory-section constraints supplied as input, the resulting architecture **contains every declared mandatory section, preserves the approved directives, and surfaces any proposed structural change for operator approval.** It **may** add non-conflicting supporting or back-matter sections (front matter, methodology, sources, appendices) — the test is completeness and preservation, not literal identity. A stricter "reproduces exactly these sections and nothing else" test is deliberately rejected: it would force the declared-outline subsystem this mission forbids.
- [ ] **5 · Evidence rules.** The evidence rules state, in the files that govern adjudication, that (a) supported evidence for a negative conclusion may remain `SUPPORTED`, and (b) failure to find evidence does not establish non-existence. **A direct scan of the governing permission-class definitions confirms the class set is unchanged** — verify the end state in the files, not the delta (workspace rule: the filesystem, not `git diff`, is the verification source).
- [ ] **6 · Scarcity record.** Evidence cannot be declared scarce without a recorded justification naming: the source ladders attempted, the source surfaces searched by name, the configured-language searches used, and — **for analytical, causal, comparative, or thesis-bearing claims** — at least one disconfirming search, **or a recorded "not applicable" rationale for a purely factual evidence need.** A synthetic scarce-evidence case without that record does not pass; a synthetic factual-datum case is not forced into a meaningless counter-search.
- [ ] **7 · Verification posture.** The existing `Verification posture` config field observably changes chapter-verification behaviour across all three of its current values (required / optional-sampled / skippable). It is no longer a phantom consumer in `docs/project-config-schema.md`.
- [ ] **8 · Single-country parity.** With a single-country country set, `country-parity-checker` skips dominance and thinness calculation entirely (no spurious `*-DOMINANT` / caveat noise) while still flagging evidence drawn from inappropriate regional sources.
- [ ] **Genericness.** A reviewer diffing the canonical files finds no Sector Intelligence content (see non-negotiables) and can name, for each of the 8 fixes, the *project-declared input* that carries the project-specific part.
- [ ] Every closed thread cites its acceptance-test **result** in the closing session's notes — not a claim that the code looks right.

**Non-negotiables** — boundaries no session may cross, even when locally convenient:

- **No Sector Intelligence content in canonical files.** Specifically named by the operator: its seven report sections, its verdict labels, its buyer lenses, its country choices, its themes, its approval roles, and its scoping test. The template supports project-declared requirements; it does not contain them. This is the mission's primary failure mode — every one of threads 4–8 is a place where hard-coding the pilot's answer would be the shortest path.
- **Nothing on the "explicitly not to be built" list above gets built**, in whole or in disguised part.
- **Each fix session runs the thread's acceptance test before marking it done.** Verification is against the actual command→skill handoff or actual deployment behaviour. No fix-and-declare; no "verified by reading the code."
- **Smallest general fix wins.** Where a thread can be closed by a channel (config value, declared input, recorded justification) or by a subsystem, it is closed by the channel.
- `/risk-check` gates apply to canonical command / hook / skill-contract edits per workspace Autonomy rule #9. Commit per workspace rules; **do not push**.

**Off-mission signals** — what drift looks like for THIS mission (feeds `/drift-check`):

- Any of the seven not-to-be-built shapes appearing in a diff, including a "small version" of one.
- A pilot-specific value (a section name, a country, a verdict label, a lens, a theme, an approver) landing in a canonical file.
- Editing pilot-project content or per-unit config from a mission-bound session.
- Closing a thread on a code read rather than an executed acceptance test.
- Widening into workflow refactors no thread names (restructuring stages, new commands).
- Re-litigating the S8→S10 triage-down decisions without new pilot evidence.

## Open threads

### Pre-deployment mission scope

**Threads 1–2 are demonstrated deployment blockers.** Threads 3–8 are operator-approved canonical improvements to complete before deployment, but are **not** independently proven blockers — pilot 1 would run without them. The distinction matters: an implementation session that hits a wall on thread 7 must know it can deploy without it, rather than treating a design choice as a hard gate.

Grouped by weight:

| Group | Threads | Character |
|---|---|---|
| Demonstrated blockers | 1, 2 | Runtime deadlock; broken placeholder lifecycle. Evidence in the audit. |
| Small, worthwhile canonical fixes | 3, 5, 8 | Low design content; mostly hygiene, wording, and a presence-gate. |
| Broader operator-approved improvements | 4, 6, 7 | Real design choices. Useful and approved — not required for pilot 1 to run. |

Attach points below are grounded (verified S10 by direct read/grep), but each fix session confirms them before editing rather than trusting this list.

- [ ] **1 — Stage-3 folder-path mismatch** (was C-1). `/run-cluster` writes refined memos to `analysis/cluster-memos/{section}/`; `claim-permission-gate/SKILL.md` (:49, :151) and `country-parity-checker/SKILL.md` (:39, :130) pre-flight-verify `analysis/{section}/cluster-memos-refined/` — a directory nothing creates — and exit. Align the two skill input contracts to the path `run-cluster` actually writes. Unconditional runtime deadlock at the first research unit; this alone blocks deployment.

- [ ] **2 — Deployment placeholder handling** (was D-3′). In `deploy-workflow.md` Steps 5–7: fill only immediate deploy-time placeholders (explicit list, including `{{CONFIDENTIAL_IDENTIFIER_N}}`, which today's narrow `{{[A-Z_]*}}` pattern misses); **preserve** placeholders inside deferred `*.template.md` files and inside unused optional components; and validate only those placeholders that must be resolved at deployment. Do **not** widen the discovery regex — the audit's original remedy was wrong: 65 of the 128 placeholders are template-internal and would be demanded prematurely, and Step 6/7 could `sed`-corrupt the `.template.md` shapes.

- [ ] **3 — Deploy hygiene bundle** (was D-1 + D-2 + python3 guard). Three small fixes, one session:
  - Add `.claude/settings.local.json` to the template `.gitignore` (verified S10: it is currently one line, `.DS_Store`). Note this is masked on the operator's machine by a global `~/.config/git/ignore` rule — it is a real portability defect for any other machine, not a local symptom.
  - Guard `python3` existence before Step 4 uses it for symlink-path computation (mirror the `jq` checks); today a `python3`-less machine gets silently broken symlinks.
  - Carry every unfinished SETUP obligation into Step 11's completion message. Step 10 deletes `SETUP.md` after replacement, dropping its §5d/§8b instantiation obligations, and nothing else restates them. **The consequence is a delayed hard interruption, not silent corruption** — corrected S10 against the audit: `run-cluster.md:11` treats `known-limits.md` as **hard-class and halts** with a remediation prompt if it is absent or unfilled, so an operator who forgets it is stopped at Stage 3, mid-research-unit, rather than drifting silently. (The audit's F-9 called this failure mode "silent"; that claim is **false** — its own F-13(b) says the opposite, and direct read confirms F-13(b). The fix's value is preventing a late, costly setup interruption.)

- [ ] **4 — Architecture pass-through to `research-structure-creator`** (bounded C-2 — *not* the declared-outline system the audit proposed, which the S8 triage already showed was overstated). Give the skill a channel to receive the project's **declared document architecture**, its **approved section directives**, and its **mandatory-section constraints**, and preserve those constraints through structure creation. `research-structure-creator/SKILL.md:121–134` already admits sections owning zero reader questions (Support / Future-State), and `run-report.md` Step 4.1.6 already gates the architecture at the operator — so the missing piece is the *input channel*, not the machinery. Build no new architecture subsystem.

- [ ] **5 — Clarify the existing evidence rules** (bounded C-3 — explicitly **no new permission class**). State, in the files that govern adjudication (`claim-permission-gate`, and the sufficiency rules `run-sufficiency` applies), that: (a) evidence which *supports* a negative conclusion may remain `SUPPORTED` — an evidenced negative is a first-class finding, not a shortfall; and (b) failure to find evidence does **not** establish non-existence, and must stay cautious. These are two different things, and the audit's original C-3 conflated them; the fix is wording that separates them, not a new class.

- [ ] **6 — Require a search record before declaring evidence scarce** (bounded F-8 — **not** a counter-search agent). Before scarcity can be declared, require a short recorded justification naming: the source ladders attempted; the source surfaces searched, by name; the configured-language searches used; and — **for analytical, causal, comparative, or thesis-bearing claims** — at least one disconfirming search, **or a recorded "not applicable" rationale where the evidence need is a purely factual datum.** The conditional is load-bearing: an unconditional counter-search requirement would be ritual overhead on "what was company X's 2025 revenue," and a gate that is mostly ritual gets pencil-whipped, which destroys it for the claims that need it. A scarcity concept already exists across `run-analysis`, `run-cluster` and `run-sufficiency` (verified S10), and `run-sufficiency` already carries a `disconfirmation_tested: true|false` disclosure keyed on a `.counter-search-runner.done` sentinel — so this extends real mechanisms rather than inventing one. Confirm the exact attach point at fix time. This is what stops "we didn't find it" from silently becoming "it isn't there."

- [ ] **7 — Make `Verification posture` actually control chapter verification** (bounded C-4). The field is declared in the template `CLAUDE.md` and in `docs/project-config-schema.md` (row 8) and is read by **nothing** — verified S10: those two files are its only occurrences anywhere in the workflow. Wire chapter verification to honour its three current values: required / optional-sampled / skippable. This closes the phantom consumer by *implementing* it rather than deleting the row, and it gives the template CLAUDE.md's cross-model rule ("Research Execution GPT verifies Claude's prose — Claude does not fact-check its own writing") the mechanical trigger it currently lacks. **Stated precisely** (corrected S10 — the audit's "zero wired post-drafting citation control" is too strong): the workflow *does* have compliance QC, citation conversion, and operator review. What is absent is an **automatically wired independent fact-verification step** — `verify-chapter` exists but `run-report` never calls it. With the R1 citation-fidelity subagent still deferred, that independent check is the missing layer.

- [ ] **8 — Single-country presence-gate in `country-parity-checker`** (bounded F-12). When the country set has one member, skip dominance and thinness calculation entirely — today every cluster reports `*-DOMINANT` (share = 1.0) and every section is spuriously `CLEARED-WITH-CAVEATS`. **Retain** the checks that catch evidence drawn from inappropriate regional sources (the PAN-NORDIC-style leakage detection) — that is the part that still does real work on a single-country project. Note this supersedes the S8 plan's config workaround: no `> 1.0` threshold hack as standing configuration; build the gate properly.

### At deployment (after all eight land)

- [ ] Run `/deploy-workflow` for the Sector Intelligence pilot. Write the project-local safeguards into the **deployed project** (audit §7 "Before research begins"): scoping preamble + §4.2 similarity test in the task plan; the seven-section checklist enforced at the architecture gate; ≥1 explicit disconfirmation question per unit; a **written** manual `/verify-chapter` step in the pre-KB gate checklist (memory-dependent gates are this workspace's most-documented failure mode); a §8.5-consistent evidence-calibration note; and the manual research operating model recorded (Claude plans / extracts / adjudicates / writes; operator runs the external research sessions). Operator-side: correct the programme pack's §6 wording, which still says Claude executes the research.

### Before research unit 2

- [ ] **F-7 — internal-import ingestion.** `run-preparation` Step 3c classifies internal-import research questions and diverts them to a "firm-held intake" that does not exist (grep-confirmed). Build the §8.4 path end-to-end (prior Axcíon report → evidence artifact consumable by Stage 3), exercised by a test fixture. Pilot unit 1 has nothing to import, so this is not a deployment blocker — but it is the programme's cumulative-KB premise, and it bites the moment unit 2 starts.

### Deferred cleanups (non-blocking; batch when convenient)

- [ ] **F-11 — two dead guards.** `check-claim-ids.sh` is fully built and registered in no settings.json event. `friction-log-auto.sh`'s documented PostToolUse branch is dead code with a header comment claiming it was fixed. Neither fires; both are wiring lies a future session will trust. Register or remove.
- [ ] **F-13 — doc/wiring drift bundle** (minus row 8, which thread 7 now closes by implementation): `project-config-schema.md` row 12 names `produce-knowledge-file` as the `Delivery vault` consumer, which it never reads; `known-limits.md` is hard-class to `run-cluster` and soft-class to `run-sufficiency`; `qc-gate.md` routes to a non-existent `/run-final`; `shared-manifest.json` omits three real template-local commands (`consult`, `run-sufficiency`, `session-plan`), so `auto-sync-shared.sh` cannot restore them if deleted; the template-local `knowledge-file-producer` has its `model:`/`effort:` frontmatter stripped and so dispatches QC unpinned.

### Evidence-gated (open ONLY when the named trigger fires)

Threads 4, 5, 6 and 8 above are the *bounded* fixes. These are the *unbounded* versions, which stay shut unless a pilot proves they are needed — do not open them in passing:

- [ ] **C-2-full — declared-outline mode** (a real architecture subsystem). Trigger: pilots show repeated architecture drift that thread 4's pass-through plus the 7-section gate checklist keeps having to correct.
- [ ] **C-3-full — a supported-negative permission class** + Phase F ratio exclusion. Trigger: a **second** Phase F `BLOCK` on an honest negative finding. (First occurrence: take the documented `OPERATOR-OVERRIDE` path and log it.)
- [ ] **F-8-full — Phase B counter-search agent.** Trigger: thread 6's search record proves insufficient — a report ships whose disconfirmation section the operator judges hollow.
- [ ] **F-14 — configurable question ceiling.** `research-plan-creator` Step 7 hard-caps plans at 12 questions. Trigger: the cap demonstrably binds in a pilot plan (consolidation drops questions the operator wanted kept). Collect the pilot-1 signal first.
