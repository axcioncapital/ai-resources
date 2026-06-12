---
mission_id: promote-rw-canonical
mission_name: Promote positioning-research improvements into the canonical research-workflow
status: completed
started: 2026-06-12
closed: 2026-06-12
---

<!--
  MISSION CONTRACT — a multi-session goal that individual sessions serve.
  Scaffolded by `/mission create`. Frozen at creation like a /contract-check contract:
  the Goal / In-Out scope / Definition of done sections are the north star and should
  not drift session-to-session. Only `status` (frontmatter) and `## Open threads` are
  meant to change over the mission's life, both edited via `/mission` — never hand-edited
  from inside a working session, and never written to by /session-start.

  "Sessions served" is NOT stored here — `/mission read` renders it live by scanning
  logs/session-notes.md for the `Mission: {mission_id}` mandate bullet.
-->

## Goal

The canonical research-workflow template (`ai-resources/workflows/research-workflow/`) plus its shared skills and hooks absorb positioning-research's evolved pipeline improvements (the C-series + QC-cleared D-series fixes) — generalized and placeholder-safe — with canonical's own independently-drifted files reconciled rather than overwritten, so every future research project deploys from a template that carries the project's full evolved tooling.

## In scope / Out of scope

- **In:** generalizing + graduating the project-ahead improvements into canonical (commands `run-preparation`, `run-execution`, `run-cluster`, `run-report`, `produce-prose-draft`; reference docs `quality-standards`, `file-conventions`, `stage-instructions`, `known-limits.template`; docs `required-reference-files`, `project-config-schema`; the C6 hook repair in `friction-log-auto.sh`; the D4/D6 skill edits in `ai-resources/skills/` if their QC clears); reconciling canonical's 7 independently-drifted files (merge-both-directions); updating the template's deployment surface (`SETUP.md`, `shared-manifest.json`).
- **Out:** promoting any positioning-research *content* (the filled CLAUDE.md body + Project Config, `source-map.md`, instantiated `known-limits.md`/`source-class-hierarchy.md`/`stage-5-paths.md`, `reference/inputs/`, `reference/sops/*`, `logs/`, `audits/`, `output/`); re-doing already-canonical work (C5, P1–P4 — verify-present only); the deferred foreign-staging-guard stale-marker hook bug (separate improvement-log item); any non-research-workflow infrastructure.

## Validation contract

> Written now, at mission creation — before any implementation session. Defines "done" and "on-mission" independently of how the work gets done, so a fresh-context check (`/drift-check`, `/contract-check`, `/qc-pass`) can judge against it rather than against a session's own account of itself.

**Acceptance assertions** — concrete statements that must ALL be true when the mission is complete:
- [x] Every graduated canonical file passes a residue scan: no `Nordic`/`Axcíon`/`Patrik`/`[1.1]`/country-set/`2024–2026` tokens; `{{PLACEHOLDER}}` shapes intact (not pre-filled). *(Verified S11 deploy-test: 0 hits across all 10 graduated files, strict scan incl. country names; placeholders intact in CLAUDE.md ×22, stage-instructions ×4, file-conventions ×1, quality-standards ×5, style-guide ×6.)*
- [x] Canonical's 7 independently-drifted files are reconciled (canonical advances preserved) — a post-land diff shows no canonical advance was dropped. *(Phase 2 merge-down, landed 3b23878 + 2c7ed1e risk-check record.)*
- [x] The C-series improvements (C1/C2/C3/C4/C7/C8) are present in canonical; C6's hook repair (auto-populating `#### Friction Events`) is live in `friction-log-auto.sh`. *(C-series: 3b23878; C6: 6b7da8a, synced to template copy 198eb55 — S11 verified 4 "Friction Events" refs in both canonical and template hook.)*
- [x] D4/D6 (if Phase-1 QC PASS) land in `ai-resources/skills/` (e.g. `claim-permission-gate/SKILL.md`), NOT in any template command. If Phase-1 QC fails, D-items are explicitly deferred, not silently dropped. *(Phase-1 QC cleared b931f10; landed 28afed3; S11 verified `skills/claim-permission-gate/` exists, no template-command copy.)*
- [x] The updated template still deploys clean: walking `SETUP.md` into a scratch project yields a working pipeline with `/workflow-status` passing and placeholders unfilled. *(S11 deploy-test: settings.json valid, all 19 required skills present, symlink loop created 77 working links, /workflow-status references resolve, placeholders unfilled. One minor finding logged to improvement-log: SETUP.md Step 1 copy path is stale — does not affect pipeline function.)*
- [x] `/sync-workflow` on positioning-research post-land reports in-sync (or only intentional project-specific divergence). *(S11 run: 33/39 identical; 6 divergences all intentional/explained — 4 generalization-vs-instantiation, 1 workspace-prime upgrade, 1 canonical-ahead C6 down-port logged as follow-up. 76 skill symlinks valid, 0 broken.)*
- [x] Each landing carries a `/risk-check` GO + independent QC clean + DR-7 consumer-confirmation note in its commit message. *(Landing-set risk-check 2c7ed1e PROCEED-WITH-CAUTION with mitigations + SO second opinion; QC GO per S3 wrap; commits 3b23878/28afed3/6b7da8a carry the gate notes.)*

**Non-negotiables** — boundaries no session may cross, even if locally convenient:
- No project-specific token is hardcoded into the canonical template.
- No already-landed work (C5, P1–P4) is re-graduated.
- No edit lands without `/risk-check` GO; no commit lands without independent QC (commit-block + `/handoff` QC-PENDING if QC is unreachable).
- `git push` is the only irreversible step and is operator-gated at session end — never autonomous.

**Off-mission signals** — what drift looks like for THIS mission (feeds `/drift-check`):
- Editing files outside the research-workflow template, its shared skills/hooks, and the positioning-research source/inventory artifacts.
- A D-fix being routed into a template command instead of a skill.
- A one-way push that overwrites a canonical-ahead file without the merge-down reconciliation.
- Promoting positioning-research content (domain terms, internal evidence) into the template.

## Open threads

- [x] Phase 0.2 — freeze the authoritative project-ahead-vs-canonical inventory by direct diff. *(b931f10, positioning-research)*
- [x] Phase 1 — clear the D1–D7 QC debt (independent /qc-pass on the calibration report). *(b931f10)*
- [x] Phase 2 — reconcile canonical's 7 drifted files (merge-down base). *(3b23878)*
- [x] Phase 3 — generalize + graduate the sweep in co-landing Groups A–E. *(3b23878 + 28afed3 + 6b7da8a; project-side 3f5723b)*
- [x] Phase 4 — deployment-contract reconciliation + DR-7 consumer confirmation + deploy-test. *(Deploy-test executed and PASSED in S11 — see Validation contract annotations.)*
- [x] Phase 5 — risk-check, independent QC, commit in groups, re-sync origin, gated push. *(Risk-check 2c7ed1e; QC GO; commits landed; /sync-workflow verified S11; push rides the standard wrap gate.)*
