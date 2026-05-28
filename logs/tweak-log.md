# Tweak Log

Per-`/tweak`-invocation audit record. Each invocation appends one bullet under a dated `## YYYY-MM-DD — /tweak invocations` block.

Used by:

- `/log-sweep` Cat A2 — archived via `split-log.sh` with KEEP=10 dated blocks.
- Friday cadence — pattern detection: if the same target or the same kind of cosmetic fix recurs, the underlying file becomes a candidate for `/improve-skill`.

Distinct from `maintenance-observations.md` (per-Friday-Act repo-health observations, single-writer `/friday-act`). This log is per-`/tweak`-invocation, single-writer `/tweak`. One writer × one purpose × one file per `repo-architecture.md` § Q6 canonical pattern.

Append-only. Do not hand-edit prior blocks. Schema is whatever `/tweak` writes — see `.claude/commands/tweak.md` Step 5a for the canonical block shape.

---
