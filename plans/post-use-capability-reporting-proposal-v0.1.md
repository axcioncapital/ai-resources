# Post-Use Capability Reporting Proposal v0.1

**Status:** Proposal for operator approval. Nothing in this document is implemented.
**Date:** 2026-08-14
**Decision owner:** Patrik
**Scope:** Judgment-heavy AI capabilities and MVPs after representative use. Deterministic capabilities remain under ordinary verification and testing unless real use reveals an operating-boundary question.

---

## 1. Executive proposal

Build one lightweight reporting capability, `/report-capability`, with two report types:

- **Incident** — packages one material failure or concerning event from real use.
- **Performance** — evaluates an MVP across selected representative uses and records a recommended or already-made adoption decision.

The capability writes a self-contained, evidence-backed report that a fresh session can understand without the original conversation. Reports live together in one small collection with a navigational index and a minimal status convention. The report records what happened and why it matters; it does not diagnose beyond the evidence, implement a fix, or create a GitHub issue automatically.

The existing repository machinery continues to own the lifecycle around the report:

- Work Loop v2 Adoption supplies the existing operating-evaluation logic and decision vocabulary.
- `/resolve-repo-problem` owns uncertain diagnosis and triage.
- `/resolve-incident` owns a known, bounded fault through correction and verification.
- The existing improvement backlog owns queued repository work.
- GitHub owns implementation progress only when an issue is deliberately chosen as the work carrier.
- Git and cited verification evidence, not a status label, establish that a correction is actually complete.

The proposal therefore adds a **durable evidence and handoff layer**, not a new evaluation lifecycle, backlog, or governance system.

## 2. Why a durable report is now justified

The first investigation correctly found that the repository already has most of the lifecycle:

- Work Loop v2 defines Adoption as representative operation followed by an explicit `adopt / revise / continue trial / stop` decision ([executable core](work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md)).
- Work Loop state files already preserve active orchestration, evidence, decisions, and accepted limitations ([Work Loop skill](../.agents/skills/work-loop-v2/SKILL.md)).
- `/resolve-repo-problem` is the triage front door and `/resolve-incident` is the bounded fix-and-verify path ([triage command](../.claude/commands/resolve-repo-problem.md), [incident command](../.claude/commands/resolve-incident.md)).
- Material findings already have a consequence-based admission bar and proportional independent review ([materiality bar](../docs/materiality-bar.md), [QC independence](../docs/qc-independence.md)).
- Repeated output-quality defects already have a separate capture-to-rule/eval/example loop ([defect-to-fix loop](../docs/defect-to-fix-loop.md)).

The remaining gap is narrower than a lifecycle gap but larger than a wording gap:

> The repository has no durable artifact designed to package a capability's real-use evidence, observed behavior, uncertainty, operating boundary, preserved strengths, and decision for a fresh future session.

A Work Loop file is authoritative task state, but it is optimized for orchestration and continuation. It should not also become the long-lived incident or performance record. Conversely, the existing resolved-incident record starts with diagnosis and implementation; it is too late in the flow to serve as the initial evidence package. The existing `workflow-evaluator` evaluates workflow architecture before production use, and `/post-project-review` diagnoses a project's process; neither evaluates a capability's observed post-use performance.

That makes one durable report function repository-specific and justified. It does **not** justify a general evaluation platform.

## 3. Design principles

1. **Decision-triggered, not automatic.** Write a report only when a real incident, adoption decision, or material follow-up question exists.
2. **Selected evidence, not per-use logging.** Point to representative cases, outputs, logs, commits, and operator observations. Do not record every invocation.
3. **One artifact, two report types.** Incident and performance reports share one command, template, location, identifier sequence, and index.
4. **Observation before diagnosis.** State what happened separately from possible cause; mark diagnosis as confirmed, unconfirmed, or not applicable.
5. **Preserve known-good behavior.** Every actionable finding names the behavior a correction must not damage.
6. **Existing routes own downstream work.** The report recommends a route; it does not become a second problem solver or backlog.
7. **Resolution requires evidence.** A finding becomes resolved only after the correction and proportionate reevaluation have evidence.
8. **Progressive formalization.** Scenario packs, scoring, automation, and broader integration wait for repeated real-use demand.

## 4. Proposed lifecycle

```text
Representative use or material incident
                 |
                 v
       /report-capability
       incident | performance
                 |
                 v
      Self-contained capability report
                 |
       +---------+----------+
       |                    |
       v                    v
 No material action    Material finding
 accept / no action    validate and route
                            |
             +--------------+--------------+
             |                             |
             v                             v
  diagnosis still open          fault and scope established
  /resolve-repo-problem         /resolve-incident or named owner
             |                             |
             +--------------+--------------+
                            |
                    bounded implementation
                  issue/PR only when useful
                            |
                            v
          targeted reevaluation + preserve check
                            |
                            v
            update finding, report, and index
```

This is the intended high-level loop:

> Representative evidence → capability report/evaluation → decision → validated issue where justified → bounded change → targeted reevaluation.

## 5. Operator interface

### 5.1 Create an incident report

Use when one real-use event failed or created a material concern:

```text
/report-capability incident
Capability: Buyer Fit Research
What happened: It treated one historical investment as a recurring acquisition pattern.
Evidence: BF-07 output and source notes in <paths>
Operational consequence: A weak buyer could be presented as a high-fit buyer.
Known-good behavior to preserve: citation discipline and geographic extraction.
```

The command inspects the named evidence, checks current capability/version context, and writes one report. It does not force a root-cause conclusion. If the cause is unclear, it recommends `/resolve-repo-problem`; if the fault, cause, and repair boundary are already established, it may recommend `/resolve-incident` or the capability's settled specialist owner.

### 5.2 Create a performance report

Use when representative use has produced enough evidence for an actual operating decision:

```text
/report-capability performance
Capability: Buyer Fit Research MVP
Decision needed: Can we adopt it for supervised research work?
Evidence: BF-03, BF-07, BF-11 and operator corrections in <paths>
Current boundary: supervised use only
Known-good behavior to preserve: source traceability and concise profiles
```

The report applies the existing Adoption questions: where the capability is reliable, operator burden, failure conditions, usefulness, evidence gaps, and the appropriate recommendation. Work Loop Adoption or the operator remains the lifecycle-decision owner; the reporting command packages that decision when one already exists and otherwise records a recommendation. It uses only the existing decision vocabulary:

- **Adopt**
- **Revise**
- **Continue trial**
- **Stop**

An operator request to “hold” maps to **Continue trial** with a named evidence condition. It does not create another lifecycle status.

### 5.3 Update an existing report

Updating is a maintenance action of the same command, not a third report type:

```text
/report-capability update CR-2026-001
F-01 implemented in PR #207.
Verification: BF-07, BF-11, and BF-14 passed; citation behavior remained intact.
```

The command checks the cited implementation and verification evidence, updates the finding and resolution section, recomputes the overall report status, and updates the index row. It never marks a finding resolved merely because an issue or PR is closed.

## 6. Minimum report contract

### 6.1 Metadata

Use one identifier namespace for both report types to avoid confusing capability incidents with the repository's existing `/resolve-incident` records:

```yaml
report_id: CR-2026-001
type: incident                  # incident | performance
capability: Buyer Fit Research
capability_ref: commit-or-version
status: open
created: 2026-08-14
last_reviewed: 2026-08-14
decision: revise               # performance only; n/a for incident
supersedes: null
linked_work: []                # issue, PR, incident record, or commit links
```

The metadata is deliberately small. A single `Linked issue` field is insufficient because one performance report can contain several findings and several implementation routes; links therefore belong primarily on findings, with `linked_work` serving as a summary.

### 6.2 Required body

Every report contains:

1. **Capability and intended outcome** — what was expected, the relevant version, and the decision or event that triggered the report.
2. **Evidence reviewed** — direct pointers to sessions, outputs, cases, logs, files, commits, or operator observations. Every material conclusion cites its supporting evidence.
3. **Observed performance or event** — expected versus observed behavior, without diagnosis being smuggled in as fact.
4. **What worked and must be preserved** — the regression boundary.
5. **Findings** — one or more stable `F-01` identifiers with classification, materiality, evidence, consequence, diagnosis status, disposition, route, and linked work.
6. **Usage boundary** — where the capability is currently safe/useful, where it is not, and what supervision is required.
7. **Decision** — performance reports use Adopt, Revise, Continue trial, or Stop; incident reports use a recommended disposition.
8. **Next route** — exact existing command or owner, why that route fits, and what must not happen prematurely.
9. **Resolution** — initially empty where action remains; later records issue/PR/commit, verification cases, preserve checks, resolution date, and residual limits.
10. **Fresh-session handoff check** — confirmation that a session with no access to the original conversation can continue correctly from the report and its cited evidence.

### 6.3 Finding shape

```markdown
### F-01 — Historical exposure treated as recurring strategy

- **Classification:** confirmed defect | expected MVP limitation | insufficient evidence | misuse | optional improvement
- **Materiality:** material | non-material — named consequence
- **Status:** open | in progress | resolved | accepted | superseded | no action required
- **Observed:** expected behavior versus observed behavior
- **Evidence:** exact case/output/log pointers
- **Possible cause:** hypothesis, if useful
- **Diagnosis status:** confirmed | unconfirmed | not applicable
- **Preserve:** behavior that must remain intact
- **Disposition and route:** investigate, fix, continue trial, accept, or no action; name the existing route
- **Linked work:** issue / PR / incident record / commit, or —
- **Verification:** evidence after correction, or pending
```

The classification distinguishes a defect from an expected limitation, weak evidence, misuse, or a merely optional improvement. Status tracks whether attention remains. Keeping those as separate fields prevents “not yet understood” from being mistaken for “open defect.”

## 7. Status model and central index

### 7.1 Report statuses

Use only:

- **Open** — at least one material finding still requires a decision or action; no accepted implementation is active.
- **In progress** — at least one material finding has accepted implementation work underway.
- **Resolved** — every action-required finding has been corrected and verified. Accepted limitations may remain visible.
- **Accepted** — the material limitations were consciously accepted and no corrective work remains.
- **Superseded** — a later report replaces this report or its broader diagnosis.
- **No action required** — a performance review found no material action. This is not used to dismiss an incident whose evidence remains unresolved.

Do not add **Partially resolved**. When some findings are resolved and one remains open, the report remains Open or In progress and the finding statuses show the detail. This avoids another ambiguous state.

### 7.2 Finding statuses

Use the same vocabulary at finding level. The overall report status is derived from material findings rather than maintained as an independent judgment:

- any in-progress material finding → report In progress;
- otherwise any open material finding → report Open;
- all action-required findings verified → report Resolved;
- all material findings accepted with no fix → report Accepted;
- no material action identified → report No action required;
- replacement by a later report → report Superseded.

### 7.3 Index

Store reports in one collection, grouped by capability rather than split into incident and performance trees:

```text
reports/
└── capabilities/
    ├── index.md
    ├── buyer-fit-research/
    │   ├── CR-2026-001-incident.md
    │   └── CR-2026-004-performance.md
    └── email-os/
        └── CR-2026-002-incident.md
```

`index.md` contains one row per report:

```markdown
| ID | Capability | Type | Status | Decision | Material finding | Linked work | Updated |
|---|---|---|---|---|---|---|---|
| CR-2026-001 | Buyer Fit Research | Incident | In progress | n/a | F-01 historical exposure inference | #184 / PR #207 | 2026-08-19 |
```

The index is navigation and a current-state view, not a second source of truth. It does not repeat all findings, evidence, or resolution details. The report remains authoritative for the evaluation record; live repository and GitHub state must be checked before treating an index row as current, consistent with the repository's reconcile-at-read rule ([backlog reconciliation](../docs/backlog-reconciliation.md)).

This index is the one deliberate compromise in V1. A shared mutable table can drift or conflict during parallel sessions, but the clarified requirement makes “which capability findings still need attention?” a core query. V1 accepts that small risk at low report volume, updates one row only on explicit report creation or review, and forbids automatic synchronization. If the first real reports show frequent drift or merge conflicts, simplify or derive the index before adding more status machinery.

## 8. Source-of-truth boundaries

| Concern | Authoritative source |
|---|---|
| Active Work Loop task and current turn | Existing `logs/work-loop/{task-id}.md` state file |
| What was observed in post-use evaluation | Capability report and its cited evidence |
| Current capability implementation | Repository files and Git history |
| Problem diagnosis and selected repair | `/resolve-repo-problem` notes, `/resolve-incident` record, or the named specialist workflow |
| Queued repository improvement | Existing `logs/improvement-log.md` flow |
| GitHub implementation progress | Linked GitHub issue and PR |
| Whether a correction actually worked | Cited verification and reevaluation evidence |
| Cross-report navigation | `reports/capabilities/index.md` only |

The same fact should not be copied in full across these artifacts. Reports link outward and summarize only what a future reader needs to understand the finding and route.

## 9. Findings to implementation work

### 9.1 Admission to the problem flow

A report finding enters downstream work only when all three are true:

1. **Evidence reality:** the observation is supported by representative evidence and still reproduces or remains credible against the current capability version.
2. **Materiality:** not addressing it has a named consequence for correctness, reliability, operator burden, safety, or intended use.
3. **Action relevance:** the observation is not simply an accepted MVP boundary, insufficient evidence, misuse, or an optional preference.

Then route by certainty:

- **Diagnosis or repair boundary uncertain** → `/resolve-repo-problem "Investigate CR-2026-001 F-01 — <one-line observed failure>"`.
- **Fault, likely cause, scope, and acceptance evidence already established** → `/resolve-incident "Resolve CR-2026-001 F-01 — <bounded fault and expected behavior>"` or the capability's already-settled specialist improvement command.
- **Insufficient evidence** → Continue trial and name the next discriminating observation; do not create problem work.
- **Expected limitation or consciously accepted boundary** → Accepted; do not create problem work.
- **Misuse** → clarify the usage boundary. Treat it as a capability defect only if the interface or instructions materially invited the misuse.
- **Optional improvement** → no issue unless a concrete consequence and implementation need later emerge.

The originating report ID and finding ID travel through every downstream record. The downstream workflow links back to the report but does not rewrite its evidence narrative.

### 9.2 GitHub ticket gate

A finding may become a GitHub issue only when:

- it is a confirmed current defect or approved material improvement;
- the owning repository and capability are known;
- expected and observed behavior are explicit;
- the implementation boundary is small enough to assign;
- acceptance evidence can fail, not merely say “reviewed”;
- known-good behavior to preserve is named;
- duplicate and current-state checks have been performed;
- the operator has chosen GitHub as the useful implementation carrier.

Creating a ticket is not mandatory. A small in-session correction handled by `/resolve-incident` may be better represented by the report, incident record, commit, and verification receipt. GitHub is useful for cross-session, assigned, scheduled, or PR-shaped work. It must not become the evaluation record or the repository's general control plane; the harness plan explicitly defers that role ([harness MVP plan](axcion-harness-v0.2/mvp-plan.md)).

An issue created from a finding should contain:

- `Origin: CR-2026-001 / F-01`;
- expected versus observed behavior;
- material consequence;
- confirmed diagnosis or bounded implementation premise;
- acceptance evidence;
- preserve constraints;
- links to the report and relevant source evidence.

### 9.3 Closure and reevaluation

The trace is:

```text
CR-2026-001 / F-01
        -> problem or incident record
        -> GitHub issue when useful
        -> PR or commit
        -> targeted verification
        -> report update
        -> index status refresh
```

Reevaluation covers only:

1. the failed or weak behavior;
2. adjacent cases most likely to share the cause;
3. the named behavior to preserve.

Broaden the reevaluation only when the correction changed a cross-cutting behavioral surface or the targeted check exposes another failure. Deterministic fixes use deterministic regression evidence; judgment-heavy fixes use representative cases and a proportionate fresh assessment. Do not rerun a large adoption review merely to obtain a better-looking verdict.

## 10. Repository changes for the MVP

### Create new

1. **`.claude/commands/report-capability.md`** — the one operator interface. It creates incident or performance reports and updates existing reports. It packages evidence and applies the report contract; it does not implement fixes or create GitHub issues automatically.
2. **`templates/capability-report-template.md`** — the canonical report shape. One template with conditional incident/performance fields and the finding schema above.
3. **`reports/capabilities/index.md`** — collection contract plus the navigational table. The directory is created with this file; reports are added only on explicit invocation.

### Modify existing

1. **`templates/README.md`** — register the capability-report template and `/report-capability` as its consumer.
2. **`.agents/skills/work-loop-v2/references/routing-index.md`** — add `/report-capability` as the specialist owner for packaging real-use capability evidence. This prevents the new command from becoming memory-dependent orphan infrastructure. Do not copy its method into the routing index.
3. **`.claude/commands/resolve-repo-problem.md`** — when invoked with a `CR-... / F-...` origin, preserve that immutable origin in triage notes, the improvement-log entry, and the fix-path bridge. Do not update report status from triage.
4. **`.claude/commands/resolve-incident.md`** — preserve an originating capability report/finding link in the incident record and, after verified closure, emit the exact `/report-capability update ...` handoff. Do not make the incident command a second report writer.
5. **`templates/incident-log-template.md`** — add one optional `Originating capability finding` field so the existing incident record can backlink without copying the report.
6. **`docs/repo-architecture.md`** — register `reports/capabilities/{capability-slug}/` as the home for durable post-use capability reports and state its distinction from `audits/incidents/` and operational logs.

No Work Loop mode, diagnostic scanner, Friday-cadence command, GitHub command, or existing backlog schema needs modification for V1. The wiring above carries immutable IDs and explicit handoffs; report/index mutation remains owned by `/report-capability` alone.

### Do not create

- separate `/evaluate-capability` or `/triage-findings` commands;
- a report-writing agent or independent report-review agent;
- separate incident and performance folder trees;
- a report database, dashboard, registry, generated catalog, or synchronization service;
- another backlog beside `improvement-log.md` and GitHub;
- automatic report generation after sessions or capability uses;
- automatic issue creation;
- scoring, weighted rubrics, mandatory severity matrices, or capability-health grades;
- a new Work Loop mode, lifecycle state, or capability record;
- revival of the retired v1 `templates/capability-record.md` path ([template contract](../templates/README.md)).

## 11. MVP verification and review

Before adoption, verify the reporting capability with three representative cases:

1. **One incident with uncertain cause** — report keeps observation and possible cause separate and routes to `/resolve-repo-problem`.
2. **One multi-finding performance review** — mixed resolved/accepted/open findings produce the correct overall status and an Adopt/Revise/Continue trial/Stop decision.
3. **One post-fix update** — issue/PR or commit evidence plus targeted reevaluation updates the finding, resolution section, and index without claiming more than the evidence proves.

For each case, run the fresh-session handoff test: give only the report to a fresh session and confirm it can identify the capability, evidence, uncertainty, preserve constraints, current boundary, and correct next route.

The build creates a new command, so it is a structural change under the repository's review rules. It should receive one risk-aware independent review before implementation, followed by deterministic verification of file creation, ID allocation, index synchronization, and update behavior. Do not add a second review chain.

## 12. Smallest implementation worth building now

Build exactly the bounded surface in §10:

- one command;
- one template;
- one capability-report collection and index;
- one template consumer-contract update;
- five narrow routing and traceability edits to existing sources.

Then use it for roughly 10 real reports before expanding it. The proving question is not whether the template looks complete; it is whether a later fresh session can correctly understand, route, implement, and verify a material finding without reopening the original conversation.

## 13. Explicitly deferred

Defer until actual reports demonstrate a repeated need:

- Codex-native skill packaging or a cross-tool wrapper. V1 proves the report contract in the operator's current command surface; multi-tool deployment should follow established resource-development machinery if real use earns it.
- automatic mutation of capability reports by `/resolve-repo-problem` or `/resolve-incident`;
- automatic GitHub status synchronization;
- auto-generated index rows or stale-status reconciliation;
- cross-report search beyond ordinary repository search;
- comparison views across capability versions;
- standardized scenario libraries, fixed trial counts, or statistical reliability claims;
- dashboards, databases, registries, notifications, and mandatory review cadences;
- integration with `/develop-ai-resource`, `/graduate-resource`, `/post-project-review`, Friday commands, or session telemetry;
- mandatory reports for deterministic capabilities or every MVP use.

Each deferred item should re-enter only after a concrete failure pattern names the value it would add.

## 14. Recommendation

Approve the MVP with one important refinement to the earlier lean recommendation:

> Keep Work Loop v2 and the existing problem/fix machinery as lifecycle owners, but add one durable, self-contained reporting function because orchestration state is not an adequate long-term incident and performance handoff artifact.

The status layer is also justified, but only in its smallest form: metadata in each report, finding-level statuses, and one navigational index. It must not become a parallel backlog. The report records evidence and disposition; existing problem workflows validate and route work; GitHub carries bounded implementation when useful; verification closes the finding.
