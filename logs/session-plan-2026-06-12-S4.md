# Session Plan — 2026-06-12 S4

## Intent

Run `/friday-act` (Friday cadence Session 2 — operator-driven fixes) to triage and act on this week's checkup backlog: the 16 `/improve` findings, 5 session issues, and the permission-sweep + log-sweep follow-ups captured in `audits/friday-checkup-2026-06-12.md`.

## Model

opus (`claude-opus-4-8[1m]`) — match. `/friday-act` is decision-heavy triage (worth-doing verdicts, fix-vs-park calls, per-fix risk judgment). Stay on Opus.

## Source Material

- `audits/friday-checkup-2026-06-12.md` — consolidated weekly checkup report (the triage backlog).
- `audits/permission-sweep-2026-06-12.md` — 41 files, 1 HIGH (Daniel machine path in interpersonal-communication KB), 12 advisory.
- `audits/log-sweep-2026-06-12.md` — 320 logs, 3 session-notes.md archival candidates.
- `logs/scratchpads/2026-06-12-09-30-scratchpad.md` — the friday-checkup session's Resume With line (named `/friday-act` as the next substantive action).
- `logs/improvement-log.md` — where `/friday-act` records triage dispositions.

## Findings / Items to Address

Per the checkup scratchpad, `/friday-act` must triage:
- **16 `/improve` findings** across 5 scopes (ai-resources: 0 new; the 16 are in marketing-positioning, nordic-pe-screening-project, positioning-research, project-planning, workspace).
- **5 session issues** surfaced during the checkup.
- **Permission-sweep follow-ups** — 1 HIGH (Daniel machine path leak in a KB file) + 12 advisory items.
- **Log-sweep follow-ups** — 3 `session-notes.md` archival candidates.

`/friday-act` runs its own structured triage; the exact item list is read live from the checkup report at invocation. This plan does not pre-empt the command's own backlog scan.

## Execution Sequence

1. Invoke `/friday-act`. It reads `audits/friday-checkup-2026-06-12.md` and builds its triage queue.
2. Work the command's operator-driven flow: per-item worth-doing verdicts, fix-vs-park decisions, per-fix `/risk-check` where a structural class is touched.
3. For each selected fix: apply structurally (default style), run independent `/qc-pass` on substantive artifacts before declaring complete, commit directly per workspace rules.
4. Record dispositions to `logs/improvement-log.md` as `/friday-act` directs.
5. On completion, surface the fix-plan summary and remind operator to `/wrap-session`.

## Scope Alternatives

- **Full triage (recommended):** work the whole checkup backlog through `/friday-act`.
- **HIGH-only subset:** address only the permission-sweep HIGH (Daniel machine-path leak) + any HIGH session issues, park the rest. Lower cost if context is constrained.
- **Triage-only, defer all fixes:** produce the fix plan, apply nothing this session. Useful if the concurrent-session situation turns out to be live.

## Autonomy Posture

Gated — `/friday-act` is operator-driven and self-gates each fix. Structural-class fixes inside it carry their own `/risk-check` (Autonomy Rule #9). No blanket auto-mode `/risk-check` at the orchestration level — the picked item is a triage command, not a single structural change.

## Risk

- **Concurrent-session collision (low).** 3 foreign per-id markers exist (S1, S2, S3). S1 + S2 have wrap commits → stale. S3's work is committed (`285c645`) but no separate wrap commit — possibly still open. `/friday-act` edits `logs/improvement-log.md` in place (the collision surface flagged in the 09:30 scratchpad). Mitigation: if an S3 terminal is confirmed live, defer improvement-log writes; the marker-disambiguated session-notes header is collision-safe regardless.
- **Structural fixes inside the backlog.** The permission-sweep HIGH and any hook/permission/CLAUDE.md fixes are `/risk-check` change classes — `/friday-act` gates each. Do not batch-apply structural fixes without per-item GO.
- **Dirty working tree (14 files).** Pre-existing mission-related changes (research-workflow, skills, hooks, settings.json) are uncommitted. Do not sweep them into `/friday-act` commits — commit only the explicit per-fix targets.
