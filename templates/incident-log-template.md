---
incident-id: {DATE}-{SLUG}
status: {diagnosing | implementing | verifying | resolved | escalated | deferred}
severity: {S1-blocked | S2-degraded | S3-non-blocking | S4-cosmetic}
risk: {Low | Medium | High | Critical}
protected-zone-touched: {yes | no}
---

# Incident — {short title}

## Intake

{What failed, what was being attempted, what is blocked — 2–4 sentences. Include the session context: which command or workflow was running, what the operator was trying to do.}

## Classification

- **Risk:** {Low | Medium | High | Critical} — {1-line reasoning citing `audit-discipline.md` class, or "no in-class change"}
- **Protected zones touched:** {none | list — name each zone from `docs/protected-zones.md`}
- **`/risk-check` verdict:** {GO | PROCEED-WITH-CAUTION: {mitigations} | RECONSIDER | N/A — risk below High and no protected zone}
- **`/consult` second opinion:** {verbatim System Owner output | N/A — not required}

## Diagnosis

**Root cause:** {1–3 sentences. Distinguish the symptom (what broke) from the cause (why it broke).}

**Evidence:** {≥1 file:line citation — e.g., `ai-resources/.claude/commands/foo.md:42` — "the exact line that proves the cause"}

**Alternative causes considered:**
- {Candidate 1} — rejected because {reason}
- {Candidate 2} — rejected because {reason}
- {Add more if applicable; "none considered" is not acceptable for Medium+ risk}

## Resolution

**Smallest safe fix:** {1 paragraph. Name the exact files that change and what changes in each. State what behavior changes and what does not.}

**Files changed:** {list each file; for edits, note the line range}

**Files NOT changed (but considered):** {list with 1-line reason for each; "none" is acceptable if the fix is truly isolated}

## Verification receipt

- **What was tested:** {List specific behaviors checked — e.g., "command exits cleanly on empty $ARGUMENTS at step 1"; "line 42 of foo.md now reads 'bar' instead of 'baz'"}
- **What passed:** {Observable evidence — grep output, file content, command output. "Looks good" is not valid. Cite the tool call or the observed output.}
- **What was NOT tested + why:** {Be explicit — e.g., "did not test hook interaction — hooks not in scope of this incident"; "did not test edge case X — deferred to follow-up"}
- **Residual risk:** {1–2 sentences on what could still go wrong and under what conditions}
- **Rollback path:** {1 line — concrete manual action, e.g., "git revert {commit-hash}" or "restore from git show HEAD~1:path/to/file > path/to/file"}

## Recurrence prevention

{Select one level from the policy below. State what was done or deferred:}

- **Local note** — documented in this incident record only (always done; baseline)
- **Local prompt hardening** — clarified a command instruction or doc to prevent recurrence locally: {what changed, where}
- **Local validation** — added a pre-execution check inside a command: {what check, where}
- **Shared change (proposed; deferred)** — requires changing a shared command/agent/doc; logged in `improvement-log.md` for Friday cadence: {entry title}
- **Escalate (ADR)** — architecture-level change warranted; logged in `improvement-log.md` as an ADR candidate: {entry title}
- **None — one-off** — incident is a one-time occurrence with no structural recurrence risk: {brief justification}

## Follow-up

{None | Linked `logs/improvement-log.md` entry: "{YYYY-MM-DD} — {title}"}

---

## Pattern-tracking fields

> Leave blank if unsure. These fields are for future aggregate scanning — they do not need to be perfect on the first incident.

- **Affected component:** {command | agent | hook | shared doc | log | template | project asset | other: {specify}}
- **Failure category:** {path assumption | missing validation | unclear ownership | stale doc | weak contract | protected-zone ambiguity | brittle workflow handoff | insufficient verification | other: {specify}}
- **Related incidents:** {none | list of incident-ids from `logs/incident-log.md`}
- **Recurrence count for this failure category:** {1 — first occurrence | N — check `logs/incident-log.md` for prior entries in same category}
