# Session Plan — 2026-07-26 (S1-2d0)

## Intent

Run two picked menu items from mission `repo-integrity-repairs-2026-07` back-to-back under one approval gate: (1) the writer-sweep that makes three improvement-log writers emit a `Severity:` line, closing thread 10; (2) provisioning `logs/scripts/` in the 14 projects that lack it plus the `new-project.md` scaffold fix, closing thread 2.

## Model

opus — matches the active session model. Item 2 carries a design judgment (copy vs. symlink topology) and a cross-repo blast radius; item 1 is mechanical but sits inside a schema contract with a machine consumer.

## Source Material

- `logs/missions/repo-integrity-repairs-2026-07.md` — thread 10 (writer-sweep remainder) and thread 2 (provisioning gap).
- `logs/improvement-log.md` — the `## Schema` block (`Severity` declared required, with its machine consumer named) and the `2026-07-25` writer-sweep park entry.
- `logs/scripts/check-archive.sh` — canonical, post-thread-1 fix (requires `CLAUDE_PROJECT_DIR`, refuses loudly when unset).
- `.claude/commands/wrap-session.md:31` — the call site that fails in unprovisioned projects.

## Findings / Items to Address

### Item 1 — Severity-less improvement-log writers (thread 10)

- Verified by execution: `leverage-idea.md`, `improve.md`, `resolve-repo-problem.md` each return **0** occurrences of `Severity`. Controls: `wrap-session.md` = 2, `session-feedback-collector.md` = 6.
- `improve.md` carries **two** write templates (apply-path and log-path), not one. Both need the field, or half the writes stay invisible.
- Consequence if unfixed: an entry written through any of these three paths carries no `Severity`, so `/prime` Step 3's severity-anchored scan cannot see it. Demonstrated live by the `2026-07-21 — PowerPoint production capability` entry, written via the `leverage-idea` PARK path.

### Item 2 — `logs/scripts/` provisioning (thread 2)

Three premise corrections established before execution, none inherited from the thread text:

- The count is **14 of 27**, not 13 — `personal/` joined the list. `new-project.md` still returns 0 matches for `logs/scripts`, so the gap regenerates on every new project.
- The thread's "walk-up" framing is **false**. `wrap-session.md:31` calls `bash logs/scripts/check-archive.sh` on a plain relative path. In the 14 projects that call fails outright and the wrap continues, so their logs have never been archived.
- The 13 provisioned copies are **not broken and not stale-in-a-harmful-way**. They resolve `PROJECT_DIR` from their own location, which is correct for a local copy. Several are deliberately customised (`axcion-brand-book`: 1500/700 thresholds vs canonical 500/400). Replacing or symlinking them would destroy real settings.

Disclosed consequence, operator-approved at the gate: provisioning switches archiving **on**. At the next wrap, four projects exceed canonical thresholds and will have session notes trimmed to the last 10 entries with the remainder moved to an archive file — `axcion-website` (1861 lines), `axcion-design-studio` (1065), `axcion-ai-system-redesign` (684), `strategic-os` (512).

## Execution Sequence

### Stage 1 — Item 1: writer-sweep

1. Add `- **Severity:**` to the PARK template in `leverage-idea.md`, after `Category`.
2. Add it to **both** templates in `improve.md` (apply-path and log-path).
3. Add it to the entry schema in `resolve-repo-problem.md`.
4. Verify by re-grep: 0 → ≥1 per file, 3 of 3 files.
5. Tick mission thread 10 with cited evidence.

### Stage 2 — Item 2: provisioning + scaffold

6. Copy canonical `check-archive.sh` + `split-log.sh` into `logs/scripts/` for the 14 named projects. Copy, not symlink — matches the established per-project topology and preserves the ability to customise thresholds.
7. Verify: unprovisioned count 14 → 0; every copy byte-identical to canonical at write time.
8. Edit `new-project.md` to scaffold `logs/scripts/` so new projects do not land in this state.
9. Verify by re-grep that `new-project.md` matches `logs/scripts` (0 → ≥1).
10. Tick mission thread 2 with cited evidence, correcting its false `Breaks:` clause.

### Stage 3 — Close-out

11. Close the `2026-07-25` writer-sweep park entry in `improvement-log.md` (thread 10's source entry) and flip the parent `2026-07-14 — two entry formats` entry from `partially applied` if the writer-side half is now complete.
12. Commit both stages separately.

## Scope Alternatives

- **Narrower:** item 1 only. Rejected — the operator picked both explicitly and re-affirmed after the conflict was surfaced.
- **Wider:** normalise all 13 existing copies to canonical. **Rejected on evidence** — they are functionally correct and several carry deliberate customisation, so this would be destructive churn, not a fix.
- **Different shape:** symlink the 14 to canonical instead of copying. Rejected — it breaks the established topology and removes per-project threshold customisation, which is in active use.

## Autonomy Posture

Gated → executing under an operator-authorised gate waiver. Item 2 falls in the `/risk-check` "automation with shared-state effects" class. The conflict (gate requires a subagent; session standing instruction forbids the Agent tool unless asked) was surfaced before any write, and the operator replied "go both but skip risk check". Recorded as an operator-authorised waiver in the session-notes mandate block per `docs/audit-discipline.md`, not a self-waiver.

## Risk

- **Highest risk is item 2's archiving side-effect**, which is disclosed and approved above. It is reversible: the archive file retains every entry, nothing is deleted.
- **Cross-repo writes** touch 14 project repos. Each write is additive (creating a directory and two files where none exist) and reversible by deletion. No existing file is overwritten — verified before each write.
- **No independent QC subagent** runs this session, per the standing instruction. Verification is inline and execution-based: re-grep counts before and after, byte-comparison of copies against canonical, and a re-run census.
- **Residual:** the `new-project.md` scaffold edit ships without a gate. It affects future projects only, and its failure mode is visible at the next `/new-project` run rather than silent.
