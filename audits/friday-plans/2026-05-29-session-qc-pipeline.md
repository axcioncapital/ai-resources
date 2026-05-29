# Friday Act Plan — 2026-05-29 — session-qc-pipeline

**Source report:** friday-checkup-2026-05-29.md (weekly tier)
**Journal report:** ai-resources/audits/friday-journal-2026-05-29.md
**Generated:** 2026-05-29
**Items:** 4

## Items

### 1. [high] Complete TOCTOU race mitigation Phases 2–4: `/session-start` + `/session-plan` consume `.session-marker`; downstream consumers (`/wrap-session`, `/handoff`); legacy-fallback cleanup. Phase 1 (write-only) shipped — 4 commands remain unpatched
- **Source:** so-derived
- **Risk-check required:** yes — change class: shared-state automation (cross-command `.session-marker` handoff restructure across 4 commands)
- **W2.4 auto-draft:** no

### 2. [high] Auto-apply `/qc-pass` fixes when verdict is REVISE AND every finding is wording-level / mechanical AND no DISAGREE annotation. Define the "wording-level / mechanical" finding class explicitly; update `/resolve` (or QC → Triage auto-loop) to skip the prompt and log the auto-apply event in `decisions.md`. Update workspace `CLAUDE.md` § QC → Triage Auto-Loop pointer (and `docs/qc-independence.md` § QC → Triage Auto-Loop) to encode the new auto-apply rule
- **Source:** journal-derived
- **Risk-check required:** yes — change class: workspace CLAUDE.md (cross-cutting QC → Triage Auto-Loop section + linked docs/qc-independence.md). Journal flagged this deterministically.
- **W2.4 auto-draft:** no

### 3. [med] Add Step 2.5 self-check QC to `/session-start`: validate mandate fields (work_scope, exit_condition, files_in_scope, stop_if) before presenting. Mirrors `/session-plan` Step 7 self-check pattern. Inline self-check (no subagent)
- **Source:** journal-derived
- **Risk-check required:** no — single-command edit, no CLAUDE.md change
- **W2.4 auto-draft:** no

### 4. [med] Strengthen `/graduate-resource` Step 4 generalization + Step 5 verification: add a brief subagent pass that grep-scans for project names, hardcoded paths, domain-specific terminology drawn from source `CLAUDE.md`. Add "fail and revise" loop. Run against 2–3 recently-graduated resources to confirm the gap is real first. Update `ai-resources/docs/ai-resource-creation.md` § graduation rules (the canonical pointer from workspace CLAUDE.md § AI Resource Creation) to encode the new Step-5 verification expectations
- **Source:** journal-derived
- **Risk-check required:** yes — change class: workspace CLAUDE.md (cross-cutting AI Resource Creation pointer + linked docs/ai-resource-creation.md). Journal flagged this deterministically.
- **W2.4 auto-draft:** no

## Execution notes
- Commit each fix separately (workspace commit-behavior rules).
- For any item marked "Risk-check required: yes", run `/risk-check` before executing that item.
- Items 1 and 2 are [high]; land first.
- Item 4 includes a verification step (run against 2–3 recently-graduated resources) before redesigning — confirm the gap is real first.
- Run `/wrap-session` when all items in this plan are done.
