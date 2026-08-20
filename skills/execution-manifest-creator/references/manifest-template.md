# Execution Manifest Template

Use this template for the output. Omit the Sessions section when no question
requires research. Product names come only from Project Config; examples below
use placeholders deliberately.

---

```markdown
# Execution Manifest: [Section ID] — [Section Title]

## Executor Contract

- **Evidence executor:** [Project Config value]
- **Declared capabilities:** [Project Config tokens]
- **Supplementary lead provider:** [Project Config value or none]
- **Evidence rule:** Supplementary leads are not evidence of record. The evidence executor must run its own sweep, open underlying sources, and log access before use.

## Routing Summary

| Question ID | Question Short Title | Execution Role | Evidence Executor | Supplementary Leads | Routing Rationale |
|-------------|----------------------|----------------|-------------------|---------------------|-------------------|
| Q1 | [Title] | Evidence gathering | [configured executor] | [provider / No] | [search mode, capability fit, and lead-pass reason] |
| Q2 | [Title] | Mechanical / no research | n/a | No | [deterministic transformation over supplied artifacts] |
| ... | ... | ... | ... | ... | ... |

**Distribution:** [X] evidence-gathering questions, [Y] mechanical/no-research questions, [Z] not-worth-pursuing questions

## Source-Plan Table (#1-lite)

| Research Question | Required Source Classes | Native-Language Requirement | Paywall Risk | Stop Condition |
|-------------------|-------------------------|-----------------------------|--------------|----------------|
| Q1 | [classes from source-class-hierarchy] | [language passes or English-only] | [public-answerable / public-proxyable / public-gated → Tier-X route] | [normal sourcing / fast-lane / Tier-A deep session] |
| ... | ... | ... | ... | ... |

[If the known-unavailable-evidence register is absent, add the required degraded-mode note here.]

## Evidence Sessions

**Sessions: [count]**

| Session | Questions | Search Mode | Required Capabilities | Eligibility | Dependencies | Executor |
|---------|-----------|-------------|-----------------------|-------------|--------------|----------|
| A | Q1, Q3 | Search-led | full-source-access; lossless-artifact-handoff; audit-log; required-output-schema | ELIGIBLE | None | [configured executor] |
| B | Q4 | URL-led | baseline + native-language-search | ELIGIBLE | Hard: after A | [configured executor] |

**Language passes:** [Session → English and required local languages]

**Supplementary lead passes:** [Session → provider + why the false-negative test fires, or No + reason]

**Parallel opportunities:** [sessions that may run simultaneously]

## Operator Notes

- [Mechanical/no-research and not-worth-pursuing questions, with reasons]
- [Uncertainties or assumptions]
- [Any operator override proposed]

## Approval Gate

Do not create execution prompts or begin research until the operator approves this manifest.
```

---

## Stop output when eligibility fails

Do not fill the executable template when a required capability is absent. Return only:

```markdown
# Execution Manifest: STOPPED — No qualifying evidence executor

- **Configured executor:** [value]
- **Affected question/session:** [IDs]
- **Missing capabilities:** [tokens]
- **Required action:** Update the verified Project Config declaration or obtain an operator decision. No fallback executor is authorized.
```
