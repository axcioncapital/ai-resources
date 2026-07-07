# Incident Log

> **What this is:** One-line-per-incident index, appended by `/resolve-incident` on every resolved, escalated, or deferred incident. Full per-incident records live in `audits/incidents/`. Pattern detection across this log is deferred to v1.1.
>
> **Owner:** `ai-resources` repo. **Maintenance:** append-only; do not edit or delete prior entries. Archive at the quarterly `/friday-checkup` tier once ≥30 entries exist (mirror `improvement-log.md` archival pattern).
>
> **Rollback procedure (per incident):** To unwind a specific incident's records after the fact: (1) remove `audits/incidents/{DATE}-{SLUG}.md`; (2) delete the one-line entry block for that incident in this file; (3) if a paired `improvement-log.md` entry was written in Step 8c, delete that entry too. Each of these is a separate file edit — `git revert` of the introduction commit does not undo entries appended by later runs.
>
> **Related files:** `audits/incidents/` (full records) · `logs/improvement-log.md` (structural follow-ups) · `templates/incident-log-template.md` (per-incident record shape) · `.claude/commands/resolve-incident.md` (the command that writes here)
>
> **[PHASE-2-FILL]:** When W2.2 enforcement automation ships in Phase 2, decide whether this log is in-scope (event-log documenting incidents that happened) or out-of-scope (not a principles-tracking log). Deferred to Phase 2 design per system-doc.md § 6.3 Open Decisions.

---

## Schema

Each entry is appended by `/resolve-incident` Step 8. Copy this shape exactly — do not add fields or change field names without updating the command body in lockstep.

```markdown
### YYYY-MM-DD — {short title}

- **Status:** {resolved | escalated | deferred}
- **Risk:** {Low | Medium | High | Critical}
- **Protected zone touched:** {yes | no}
- **Affected component:** {command | agent | hook | shared doc | log | template | project asset | other}
- **Failure category:** {path assumption | missing validation | unclear ownership | stale doc | weak contract | protected-zone ambiguity | brittle workflow handoff | insufficient verification | other}
- **Root cause:** {1 sentence}
- **Follow-up:** {none | improvement-log entry "YYYY-MM-DD — {title}"}
- **Record:** `audits/incidents/YYYY-MM-DD-{slug}.md`
```

---

## Entries

<!-- /resolve-incident appends entries below this line -->

### 2026-07-07 — strategic-os `main` diverged from origin (local 3 / origin 20)

- **Status:** resolved
- **Risk:** Medium
- **Protected zone touched:** no
- **Affected component:** project asset
- **Failure category:** brittle workflow handoff
- **Root cause:** This machine committed 3 times on stale base `b9f42d7` without pulling while origin advanced 20 commits (2026-06-15→27 "operationalize OS" line); reconciled by rebasing the unique 2026-07-04 park onto origin/main and dropping two superseded promote commits.
- **Follow-up:** improvement-log entry "2026-07-07 — strategic-os `main` diverged from remote (local 3 / origin 20, pull blocked)" (in `projects/strategic-os/logs/improvement-log.md`)
- **Record:** `audits/incidents/2026-07-07-strategic-os-main-diverged-from-origin.md`
