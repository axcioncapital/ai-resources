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

- [x] **1 · Stage-3 path.** ~~In a scratch project, `/run-cluster` followed by `/run-sufficiency` completes Phase A and Phase C pre-flights and produces permission and parity tables — no "run `/run-cluster` first" exit.~~ **SUPERSEDED S11 (operator-authorized) — the original test cannot fail and therefore cannot verify anything.** It already passed against the *broken* skills, twice, in production (see the deployment correction below): `/run-sufficiency` passes the memo directory to each sub-agent at dispatch (`run-sufficiency.md:44,55`), which overrides the skills' broken declared path, so the end-to-end route was never blocked. A test that is green before and after the fix is not evidence.

  **Replacement test (discriminating — exercises the declared contract, which is the thing that was broken):** dispatch each skill **standalone**, with the memo directory *not* passed to it, against a fixture holding both refined and unrefined memos per cluster. Pre-fix it must **exit** at pre-flight; post-fix it must **proceed** and produce its table, reading **only** the `-refined` variant. — **RESULT (S11, executed, not read off the diff):** pre-fix both skills returned `EXITED-AT-PREFLIGHT` naming the absent `analysis/{section}/cluster-memos-refined/`; post-fix both returned `PROCEEDED` — Phase A wrote 2 permission tables + `.claim-permission-gate.done`, Phase C wrote the parity table + `.country-parity-checker.done`, and both agents explicitly read only `*-memo-refined.md`, leaving the unrefined pair unopened. Same test, opposite outcomes.
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

> ## ⚠ TWO FACTUAL CORRECTIONS — S11, established by direct evidence, not by argument
>
> **(1) The workflow IS deployed. The "not yet deployed anywhere / blast radius zero" premise is FALSE.**
> Two live projects symlink the canonical skills directly into `ai-resources/skills/`:
> `projects/research-pe-regime-shift-advisory-gap/reference/skills/{claim-permission-gate,country-parity-checker}` and the same pair under `projects/positioning-research/`. Neither holds a local copy. Both have **completed Stage 3 for section 1.1** — real cluster memos on disk, permission tables written, both `.done` sentinels present. **Any canonical skill edit in this mission takes live effect in both projects the moment it merges to `main`.** Every remaining thread must be assessed against that, not against an undeployed template. Sector Intelligence is the first *deliberate* deployment; it is not the first deployment.
>
> **(2) Thread 1 was NOT a demonstrated deployment blocker, and the audit's "unconditional runtime deadlock" is FALSE.**
> The defect landed 2026-05-26 (`9871b95`). `research-pe` ran Stage 3 on 2026-06-03 and `positioning-research` on 2026-06-10 — both *after* it — and both completed. The broken path never blocked them because `/run-sufficiency` **passes the memo directory to each sub-agent at dispatch** (`run-sufficiency.md:44,55`), and the sub-agent uses the directory it is handed; the path declared in the skill was inert prose. The deadlock is real **only** on the declared-contract route (a skill dispatched standalone, or any consumer that honours its stated inputs) — confirmed empirically in S11, where both skills exited at pre-flight when dispatched without the directory.
>
> **What thread 1 actually was:** a *latent contract defect* — the declared input contract contradicted both the writer and the naming registry, so any consumer honouring it deadlocked, while the live route silently papered over it. Worth fixing (and now fixed), but it did not gate deployment.
>
> **The consequence for this mission is structural, and is NOT resolved here.** Thread 2 was classified a "demonstrated blocker" by the **same audit**, on the same kind of reasoning-from-the-file that thread 1's classification failed. Its blocker status is now **unverified**, not confirmed false. A fix session opening thread 2 must establish its real-world failure mode **by execution** before treating it as a gate. More broadly: the audit reasons from what the files *say*; these skills are instructions an agent reads, and what the runtime *does* with them can differ. That gap is the mission's real hazard.

**Threads 3–8** are operator-approved canonical improvements to complete before deployment, but are **not** independently proven blockers — pilot 1 would run without them. The distinction matters: an implementation session that hits a wall on thread 7 must know it can deploy without it, rather than treating a design choice as a hard gate.

Grouped by weight:

| Group | Threads | Character |
|---|---|---|
| ~~Demonstrated blockers~~ → **reclassified S11** | 1, 2 | **1:** latent contract defect — *not* a runtime blocker (fixed S11; see correction (2) above). **2:** blocker status **unverified** — inherited from the same audit reasoning that got thread 1 wrong. Verify by execution before treating as a gate. |
| Small, worthwhile canonical fixes | 3, 5, 8 | Low design content; mostly hygiene, wording, and a presence-gate. |
| Broader operator-approved improvements | 4, 6, 7 | Real design choices. Useful and approved — not required for pilot 1 to run. |

Attach points below are grounded (verified S10 by direct read/grep), but each fix session confirms them before editing rather than trusting this list. **S11 lesson, applied to every remaining thread: confirm the *runtime* behaviour, not just the file text — the audit's file-level reading was wrong about thread 1 in exactly this way.**

- [x] **1 — Stage-3 folder-path mismatch** (was C-1) — **DONE, S11 (2026-07-13).** `/run-cluster` writes refined memos to `analysis/cluster-memos/{section}/`; `claim-permission-gate/SKILL.md` (:49, :151) and `country-parity-checker/SKILL.md` (:39, :130) declared and pre-flight-verified `analysis/{section}/cluster-memos-refined/` — a directory nothing creates. (The canonical convention is `analysis/{artifact-type}/{section}/`, as `country-parity-checker:40` itself uses correctly for `analysis/claim-permission/{section}/`; the four defective lines had it inverted.)

  ~~Unconditional runtime deadlock at the first research unit; this alone blocks deployment.~~ **False — see correction (2) above.** It deadlocks only the declared-contract route, not the live `/run-sufficiency` route.

  **What shipped (4 defect lines + 2 cross-references):**
  - Both skills' Inputs row and pre-flight repointed to `analysis/cluster-memos/{section}/`.
  - Both now read **only** the `-refined` variant by name (`{section}-cluster-NN-memo-refined.md`), and their pre-flight explicitly rejects a directory holding only unrefined memos. This was **not** in the audit's "~4 lines" remedy and a bare path swap would have been wrong: `run-cluster.md:36` writes *both* variants into that one directory, so the skills — whose input tables promise "one memo per cluster" — would have been handed two files per cluster, one of them without claim IDs. The filter adopts the existing variant-suffix rule (`file-conventions.md` Rule 2) and the existing precedent (`review-chapter.md:26`); no new mechanism.
  - A `## Cross-References` "Input-path contract (load-bearing)" bullet added to **both** skills, naming `/run-cluster` as the writer and `file-conventions.md` as the naming registry, and requiring lockstep updates. (Risk-check mitigation — stops the contract being independently restated and drifting again.)
  - **Design decision, recorded:** the declared path + pre-flight were **kept**, not deleted in favour of the directory `/run-sufficiency` already passes at dispatch. Deleting them would have removed a correct guard — and that guard is precisely what protects a standalone dispatch. The two-source-of-truth remains (declaration *and* passed argument), now made explicit and lockstep-bound rather than silently contradictory; a future thread may collapse it, but not by deleting the guard.

  **Gates:** `/risk-check` → **PROCEED-WITH-CAUTION** (`audits/risk-checks/2026-07-13-stage3-cluster-memo-path-contract-two-canonical-skills.md`). It caught the false blast-radius claim. Both required mitigations applied: (M1) read-only dry-run of the corrected pre-flight against **both live projects'** real section-1.1 data — **passes** in both (research-pe 5 refined memos, positioning-research 4); no project file touched; the false claim corrected above. (M2) literal refined filename stated in each Inputs row + registry cross-reference added to both skills.

  **Verification:** the replacement acceptance test above, executed. Not a code read.

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

### Findings surfaced by EXECUTION in S11 — routed, not fixed

Four latent defects that no file-reading audit had found. All four came out of actually dispatching the two skills against a fixture — the same method the mission's non-negotiables mandate, now shown to pay. **Not fixed in S11** (out of thread-1 scope; the mission's stated primary failure mode is scope creep). Each is routed to the thread that owns it.

- **→ thread 5 (evidence rules).** **`claim-permission-gate` contradicts itself on the class vocabulary.** Behavior step 2 says the project's `quality-standards.md` is authoritative ("*These are the only valid class names*") and When-Not-to-Use forbids hard-coding thresholds in the skill — but the `## Output` schema then hard-codes four literal class names (`SUPPORTED` / `PROXY-SUPPORTED` / `ILLUSTRATIVE-ONLY` / `NOT-SUPPORTED`). A project whose class vocabulary differs puts the skill into self-contradiction. Fix direction: the Output schema should say "one of the class names parsed from `quality-standards.md`", not restate literals. Same defect on the Source-Diversity column (schema says pass/fail; a project matrix can define a third value).
- **→ thread 5 (evidence rules).** **A real hole in the canonical class thresholds.** A claim with **2 sources in 1 class** matches *no* class: `SUPPORTED` needs ≥3 sources/≥2 classes; `PROXY-SUPPORTED` needs 2 across ≥2 classes *or* 3+ in one class; `ILLUSTRATIVE-ONLY` is defined as 1 source; `NOT-SUPPORTED` as 0. Two-sources-one-class falls through the whole ladder. The test agent flagged it rather than inventing a threshold — correct behaviour, and it means real claims are currently unclassifiable.
- **→ thread 8 (country parity).** **`country-parity-checker` has no bucket for out-of-target, in-superset country evidence.** Evidence sourced from a country that is in `region_superset` but not in `target` is neither target evidence nor a non-broken-out regional aggregate. Same family as thread 8's presence-gate work; resolve them together.
- **→ deferred cleanups.** **`claim-permission-gate` pre-flight ordering is ambiguous.** The "sentinel already exists → exit silently" rule sits in `## Failure Behavior`, not as an ordered bullet in the pre-flight checklist, so when the sentinel exists *and* an input is missing, which outcome is emitted depends on the order an implementer happens to run the checks in.

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
