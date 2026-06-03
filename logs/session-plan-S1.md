# Session Plan — S1 (2026-06-03)

## Intent

Reconstruct the System Owner agent's 4 missing `references/` grounding files — `persona.md`, `grounding.md`, `toolkit-relationship.md`, `systems-building-principles.md` — so the agent can run grounded again, and settle the vault path-wiring problem in `grounding.md`. Reconstruction is from surviving artifacts (the agent definition, the 2026-05-04 due-diligence audit's structural inventory, risk-check fragments quoting specific sections, the recovered vault docs, and a surviving consult output) — NOT invented. Anything that cannot be grounded against a surviving artifact is marked `[CITATION NEEDED]`.

## Model

opus — reconstruction-from-indirect-evidence judgment work. Active model `claude-opus-4-8[1m]` — match.

## Source Material

- `ai-resources/.claude/agents/system-owner.md` — the agent definition. Names all 4 references files, their read order, and (in Phase 4) enumerates persona.md § 5 voice rules 1–7 verbatim, plus the per-function read-map structure grounding.md must carry.
- `ai-resources/audits/repo-due-diligence-2026-05-04-project-axcion-ai-system-owner.md` — structural inventory: exact line counts (persona 91, grounding 136, toolkit-relationship 69, systems-building-principles 17), the project CLAUDE.md section list, and the placeholder status of systems-building-principles.md.
- `ai-resources/audits/risk-checks/*.md` — fragments quoting specific sections: grounding.md § 2 (per-function read maps, Functions F/G added 2026-05-04), grounding.md § 3 (triage steps), persona.md § 5 voice rule 7 (conflict-naming), toolkit-relationship.md § 1 (commands-not-invocable-from-agents; Task dispatch) and § 2 (`/sync-workflow`).
- `projects/repo-documentation/output/phase-1/{principles,risk-topology,blueprint,repo-state,system-doc}.md` + `components/` — the recovered vault architectural docs the grounding read-map points to. Their actual filenames and section headers must match what grounding.md § 1/§ 2 cite.
- `projects/repo-documentation/vault/` — the declared (CLAUDE.md line 23) vault location; needs path reconciliation against where docs actually live (`output/phase-1/`).
- `projects/axcion-ai-system-owner/output/consultations/consult-2026-06-02-parallel-sessions-playbook-pre-draft-framing.md` — a surviving consult output; demonstrates the persona voice in practice (citation discipline, declarative co-ownership voice).

## Findings / Items to Address

### Scope discovery (surfaced to operator, proceeding)
The whole `projects/axcion-ai-system-owner/` scaffold is gone, not only `references/` — the project CLAUDE.md (99 lines), `.claude/` (settings, shared-manifest, 60 symlinks), and `pipeline/` artifacts are all absent; only `output/consultations/` (one file) survives. The directory is not a git repo and is not tracked by ai-resources, so there is no local git recovery path (unlike repo-documentation, which had a remote). The scratchpad framed this session as "4 references files"; the broader scaffold gap is a SEPARATE follow-up and is NOT pulled into this session. The 4 references files remain necessary AND sufficient for the mandate's exit condition (SO runs grounded), because the agent reads `references/` + vault docs at invocation — not the project CLAUDE.md.

### Path-wiring decision (the design fork)
Agent def Phase 3 says read vault docs from `projects/repo-documentation/vault/` per grounding.md § 1. Recovered docs actually live under `projects/repo-documentation/output/phase-1/`. `vault/references/` does NOT exist (the `resolve-incident.md` path pointing there is stale). Decision to make inside grounding.md § 1: point the path map at the real location (`output/phase-1/`) vs. wire docs into a `vault/` location. Leaning toward pointing § 1 at `output/phase-1/` (the recovered, verified location) and recording the `vault/` aspiration as a documented future move — least-surprise, matches what is actually on disk. Will confirm against the recovered docs' real layout before committing the path map.

### Per-file reconstruction targets
- **persona.md** (~91 lines): identity + authority + § 5 voice rules 1–7 (have all 7 verbatim from agent def) + scope/decline rule. Voice demonstrated in the surviving consult output.
- **grounding.md** (~136 lines): § 1 vault path map (reconciled), § 2 per-function read map A–G (structure from agent def + risk-check fragments), § 3 triage rule (function detection + topic classifier adding risk-topology/blueprint/repo-state), § 4 caching note (deferred mitigation, project-plan D-3).
- **toolkit-relationship.md** (~69 lines): § 1 (slash commands not invocable from agents; direct Task dispatch), § 2 (`/sync-workflow` etc.), integration-mechanism map for change-shaped questions.
- **systems-building-principles.md** (~17 lines): placeholder, frontmatter `status: TBD — operator-provided`, heading `# Systems-Building Principles (placeholder)`, body = activation instructions only. Faithful, low-risk.

## Execution Sequence

1. Finish gathering reconstruction sources: read the surviving consult output (voice), the recovered vault doc section headers (for accurate § 1/§ 2 citations), and the remaining RDD/token-audit detail on references structure.
2. Settle the path-wiring decision against the real on-disk layout; record it.
3. Author the 4 references files under `projects/axcion-ai-system-owner/references/`, grounding every load-bearing line in a named surviving artifact; mark genuine gaps `[CITATION NEEDED]`.
4. Verify the agent def's expectations are satisfied: every file/section the agent reads (persona § 5, grounding § 1/§ 2/§ 3, toolkit § 1, systems-building status field) exists and is consistent.
5. Run `/qc-pass` (independent reviewer) on the 4 files. Fold cosmetic fixes; surface DISAGREE/editorial items.
6. Between-gate summary, then hand to the operator-review checkpoint: the reconstructed persona + read-map must be operator-reviewed before the SO is declared trusted and before item 2 (the grounded consult) chains.
7. Commit directly (per workspace Commit behavior). Push batched to wrap.

## Scope Alternatives

- **As-mandated (chosen):** 4 references files only. Restores the agent's grounding base. Leaves the broader scaffold gap (project CLAUDE.md, .claude/, pipeline/) for a follow-up.
- **Expanded:** also reconstruct the project CLAUDE.md + .claude/ scaffold this session. Rejected — out of mandate, larger surface, and not required for the agent to run grounded. Flagged as follow-up instead.
- **Minimal:** restore only persona.md + grounding.md (the two the agent hard-reads first). Rejected — toolkit-relationship.md is read on every invocation too (agent def Phase 1 step 3); a partial restore leaves the agent reading a missing file.

## Autonomy Posture

Full autonomy for drafting + independent QC. ONE operator-review checkpoint before the SO is declared trusted — reconstructing an agent's constitution from indirect evidence is the case that warrants review before reliance (per scratchpad). Not a `/risk-check` structural class (reference docs read by an existing agent — not a hook, permission, always-loaded CLAUDE.md, new command/skill, symlink, or shared-state automation).

## Risk

Low-to-moderate. The risk is reconstruction fidelity, not blast radius: a wrong voice rule or read-map entry would degrade SO output quality, but (a) the operator-review checkpoint catches it before reliance, (b) item 2's grounded consult is deferred behind that gate, and (c) every load-bearing line is cited to a surviving artifact or marked `[CITATION NEEDED]`, so invented content is visible rather than silent. No destructive ops; all writes are new files in an empty `references/` dir.
