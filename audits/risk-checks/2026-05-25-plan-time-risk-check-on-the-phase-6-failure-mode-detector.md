# Risk Check — 2026-05-25

## Change

Plan-time risk-check on the Phase 6 (Failure Mode Detector + Prompt Hardener) build as specified in `harness/logs/session-plan.md`. Three WUs: (WU1) new `failure-mode-detector` skill + verify schema entries already present in `session-log-schema.md` + dry-run classifier against minimal-markdown seeded defect; (WU2) new `prompt-hardener` skill + governor edits at Phase B step 12 (replace `STUB [PHASE-6/7]:` with detector→hardener→re-invoke-via-step-6-overlay) AND Phase D registry closeout (set effectiveness + session_status + back-fill commit_sha); (WU3) reporter v1.5 update (verification stats + hardening log) + roadmap refresh. Structural classes touched: two new skills, governor SKILL.md edits at two distinct points (step 12 + Phase D), Marker Family Legend rewrite at line 54, Stub Marker Index row removal, reporter SKILL.md section additions, hardening-registry.json read-only by hardener / write-only by detector. Plan file: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness/logs/session-plan.md`.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness/logs/session-plan.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness/schemas/session-log-schema.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness/schemas/hardening-registry-schema.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness/schemas/write-ownership.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/skills/session-governor/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/skills/session-reporter/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/skills/failure-mode-detector/SKILL.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/skills/prompt-hardener/SKILL.md — not yet present

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Plan is well-scoped and consistent with established harness conventions, but carries a wrong-path reference for `hardening-registry.json` (plan says `harness/session/`, actual location is `harness/learning/`) and a within-session overlay-propagation contract that the plan asserts ("`active_hardenings` already loaded by the governor") but the governor SKILL.md does not currently implement — both are paired-mitigation issues that must be resolved during WU1/WU2 build.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Two new skills (`failure-mode-detector`, `prompt-hardener`) are pay-as-used — invoked by the governor's Phase B step 12 only on second-occurrence verification failure, not on every session or every unit. Evidence: plan line 67–69 routes invocation to the failure path; first-occurrence failures still use the Phase 5 step 11 path.
- No new always-loaded content. Both skills are model-tier-scoped via YAML frontmatter (plan line 63 names ai-resource-builder validators) — not added to any workspace or project CLAUDE.md.
- Governor SKILL.md is already loaded on every harness session — edits at step 12 and Phase D add inline behavior, not new always-loaded import chains. Current size 705 lines (verified `wc -l`); the step-12 swap-out replaces an existing STUB block, Phase D closeout adds ~10–15 lines, Marker Family Legend rewrite is a net-neutral line edit. Net token delta is small (<150 tokens).
- Reporter SKILL.md (260 lines) gains two new sections (verification-statistics + hardening-log) per plan line 74. Reporter is invoked once per session at Phase D — incremental cost per session is negligible.
- No new hooks. Plan does not register SessionStart, Stop, PreToolUse, or UserPromptSubmit hooks. The detector and hardener are skills, not hooks. Evidence: plan §Execution Sequence WU1–WU3 names no hook edits.

### Dimension 2: Permissions Surface
**Risk:** Low

- No permission-settings changes named in the plan. WU1–WU3 produce two SKILL.md files and edits to two existing SKILL.md files, plus a roadmap edit. No `allow`/`ask`/`deny` entries added or removed; no new Bash command family, no new Write path category, no new external API.
- The detector writes to `hardening-registry.json` (single-writer per `write-ownership.md` line 11). The path already lives in the harness-state write-permitted area used by the governor and mandate-parser — adding the detector as the assigned writer for that file aligns with existing schema (`write-ownership.md` already names the failure-mode-detector as the writer at line 11; the plan brings runtime into alignment with the schema, not the reverse).
- Per workspace `CLAUDE.md` Memory Index, repo is intentionally permissive — safety lives in git/risk-check/audits, not prompts. No permission posture shift.

### Dimension 3: Blast Radius
**Risk:** Medium

- Files touched directly by this plan (5):
  - **NEW** `.claude/skills/failure-mode-detector/SKILL.md` (WU1)
  - **NEW** `.claude/skills/prompt-hardener/SKILL.md` (WU2)
  - **EDIT** `.claude/skills/session-governor/SKILL.md` — Phase B step 12 fill + Phase D closeout + Marker Family Legend (line 54) + Stub Marker Index row removal (line 657) (WU2)
  - **EDIT** `.claude/skills/session-reporter/SKILL.md` — v1.5 section additions (WU3)
  - **EDIT** `harness/prep/harness-roadmap.md` — Phase 6 mark-✅ (WU3)
- Callers / dependents of touched components (enumerated via grep on `failure-mode-detector|prompt-hardener|hardening-registry|defect_classified|prompt_hardened` across `.claude`, `ai-resources`, `harness`):
  - `harness-rules.md` line 10 — already references `failure-mode-detector` (Phase 6) as an expected skill. No change needed; the new skill fills an already-named slot.
  - `mandate-parser/SKILL.md` lines 121, 128, 134, 211 — reads `hardening-registry.json` and summarizes into `mandate.json` `active_hardenings`. The plan does not change the registry schema, so mandate-parser remains compatible (no caller modification required).
  - `session-governor/SKILL.md` lines 100–102, 168, 400–404, 548, 555 — already references `active_hardenings` and the registry. Phase B step 6 prompt-assembly overlay (line 387+) already declares the read path. No contract change.
  - `session-log-schema.md` line 35 — already lists `defect_classified` and `prompt_hardened` event types. No schema add required (verified by plan Finding #2 of WU1, line 62).
  - `write-ownership.md` line 11 — already assigns the registry to the failure-mode-detector. No schema add required.
  - `promotion-candidates-schema.md` lines 25, 55 — references the hardening-registry as a `source_file` provenance string for Path A promotion. The detector's deferred-to-v2 promotion-candidate flagging (plan line 40) keeps this contract untouched in Phase 6.
- Total dependent callers: 5 (mandate-parser, governor, session-log-schema, write-ownership, promotion-candidates-schema). All are already aligned to the schemas the plan honors — zero require modification.
- Contract changes: the plan introduces no breaking schema change. The `defect_classified` and `prompt_hardened` event payloads are documented in the new skill (WU1) and the schema entries already exist as placeholders (line 35) — the plan expands payload-field docs only if the WU1 emit shape diverges (plan line 62), which is a backwards-compatible elaboration.
- Risk elevated to Medium (not Low) because the governor SKILL.md gets two distinct edits in WU2 (step 12 + Phase D) plus marker-table rewrites at four discrete locations (line 54 legend, lines 657–661 index rows, line 275 inline marker, line 344 inline marker for step 21 retain). The plan lists each location, but the four-touch governor edit in a single WU/single commit elevates the surface area beyond a single isolated change.

### Dimension 4: Reversibility
**Risk:** Medium

- Three separate commits (one per WU per plan line 64, 71, 77) means a single `git revert` per WU undoes the bulk of code changes cleanly. New skill files (WU1, WU2) are deleted by `git revert` of their creating commits.
- BUT: WU2 writes mid-session to `hardening-registry.json` (the detector's append-on-new-hardening pattern per `write-ownership.md` line 24). If the session that exercises Phase 6 fires the hardener, a `git revert` of WU2 leaves the appended registry entry behind (the data file is separate from the skill code). The plan acknowledges this implicitly with Finding #7 (commit_sha = null mid-unit, back-fill at Phase D) and Finding #8 (Phase D `effectiveness` + `session_status` transition).
- WU2 also appends `defect_classified` and `prompt_hardened` events to the append-only `session-log.json`. Append-only logs cannot be `git revert`'d in-place (the log file is not under git, or is committed as-is) — the events remain in the log. This matches existing patterns (the `verification_result`, `judgment_call`, `unit_learning_extracted` events are all append-only with the same property).
- WU2 governor SKILL.md edits to Phase D closeout will run on every subsequent session, updating registry entries' `effectiveness` and `session_status`. A WU2 revert removes the code but if any session has already run with the Phase D closeout, the registry entries already updated remain updated. Operator must mentally track: "if I revert WU2 after a Phase 6 fire, the registry will have orphan entries that the (reverted) detector wrote but the (reverted) closeout has touched."
- WU3 reporter edits surface new sections in `harness/reports/session-report-{session_id}.md`. A revert of WU3 leaves prior generated reports unchanged on disk — operator must regenerate reports for sessions whose Phase 6 fire was already reported, or accept the stale section content. Not a hard blocker because reports are regenerable.
- No external writes (no `git push`, no Notion write, no API POST) before operator approval — the autonomy rules (#2) gate push. Reversibility is bounded by the local working tree.
- Risk elevated to Medium because reverting WU2 after a live Phase 6 fire requires a one-step manual cleanup of stale registry entries (or a deliberate decision to keep them). This matches the plan's three-WU commit cadence — each commit is individually revertable but the registry state is data, not code.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Wrong-path coupling — load-bearing.** Plan line 61 says the detector "writes/updates `harness/session/hardening-registry.json`." The actual file lives at `harness/learning/hardening-registry.json` — verified by `ls harness/learning/` (file present, 3 bytes) AND by `mandate-parser/SKILL.md` line 121 ("`harness/learning/hardening-registry.json` | Active hardenings to apply during prompt assembly") AND by `governor/SKILL.md` line 548 (same path). If the detector skill is built with the plan's path verbatim, it will write to a new file in the wrong directory, leaving the canonical `harness/learning/hardening-registry.json` empty and breaking the mandate-parser → governor active-hardenings pipeline. **The plan has the path wrong; the build must use `harness/learning/hardening-registry.json`.**
- **Within-session overlay-propagation contract — unstated.** Plan line 67 says the hardener "writes the hardening to `hardening-registry.json` (already loaded by the governor as `active_hardenings`), then the governor's existing Phase B step 6 prompt-assembly overlay picks it up on the next invocation." However, the governor's `active_hardenings` is populated at Phase A step A1 from `mandate.json` (lines 100–105 of governor SKILL.md: "`hardening-registry.json` is already summarized into `mandate.json` `active_hardenings` by the mandate parser — read the registry file itself only if a hardening's full body is needed during prompt assembly"). A mid-session registry write therefore will NOT appear in `mandate.json` `active_hardenings`. For the within-session re-invoke to pick up the new hardening, either (a) the governor must re-read `hardening-registry.json` directly at step 6 when re-invoked via step 12, OR (b) the hardener must inject the hardening into the governor's in-memory `active_hardenings` for the current unit's re-invoke, OR (c) the mandate-parser must be re-run mid-session. None of these is in the existing governor SKILL.md. The plan asserts the overlay propagation works without explicating which mechanism (a/b/c) provides it.
- **Marker-rewrite coupling, documented.** Plan line 68 names a Marker Family Legend rewrite at line 54 of governor SKILL.md to rescope `STUB [PHASE-6/7]:` to step 21 only. The governor's bullet at line 54 currently reads: "filled by Phases 6–7 (failure-mode detection, maturation; covers the step 12 second-occurrence harden path as of Phase 5)". The plan's rewrite is correct in intent (step 21 maturation remains Phase 7), and the Stub Marker Index at lines 657–661 already has separate rows for step 12 and step 21 — the rewrite aligns the legend with the existing index. Coupling is documented at the change site; not hidden.
- **Phase D closeout coupling with `learnings.json` closeout — sibling pattern.** Plan line 69 places the registry closeout "around the existing `learnings.json` block, ~lines 588–606" of governor SKILL.md. Verified: lines 588–606 hold the `session_status` transition for `learnings.json`. Placing the hardening-registry closeout adjacent is the right pattern (Phase D already runs once per session, governor-sequenced, single-writer). The two closeouts share a structure but do not collide (different files, different writers — both governor-owned). Coupling is intentional and documented at the change site.
- **`workflow-config.yaml` no-write contract — documented and verified.** Plan line 70 adds `git diff --quiet harness/test-workflows/minimal-markdown/workflow-config.yaml` as a sufficiency check. This is the same contract the existing `hardening-registry-schema.md` line 38 declares ("the workflow config is read-only at runtime and is never mutated by the harness"). The plan honors the contract and adds a mechanical check; not hidden coupling.
- Risk elevated to Medium because the wrong-path and the unstated overlay-propagation are both implicit dependencies that the plan does not document at the change site — they will silently fire (or silently fail) during the build unless caught at WU1/WU2 design.

## Mitigations

- **Dimension 5 (wrong-path):** Before WU1 begins, correct the plan's registry path from `harness/session/hardening-registry.json` to `harness/learning/hardening-registry.json`. The corrected path is named consistently in `mandate-parser/SKILL.md` line 121, `governor/SKILL.md` line 548, and `write-ownership.md` line 11. The WU1 SKILL.md must write to the correct canonical location. Verification step at WU1 close: `test -f harness/learning/hardening-registry.json && test ! -f harness/session/hardening-registry.json`.
- **Dimension 5 (overlay propagation):** At Gate 0 (before WU1) OR at Gate 1 (before WU2), name the within-session overlay-propagation mechanism explicitly. Recommended mechanism — governor re-reads `hardening-registry.json` at step 6 when entering it via the step 12 re-invoke path (not on every step-6 entry, only on the post-hardener re-invoke). This requires a small governor SKILL.md edit in WU2 to the Prompt Assembly section (around line 400–404) clarifying when the registry is re-read. Alternatives are documented in the dimension finding above; choose one explicitly rather than letting WU2 silently assume the existing overlay code path handles it.
- **Dimension 3 (governor multi-touch):** Verify after WU2 commit via `grep -n "STUB \[PHASE-6/7\]:" .claude/skills/session-governor/SKILL.md` — expected output: exactly one remaining marker at step 21 (line 344 area). Also verify the Stub Marker Index table has the step 12 row removed and the step 21 row retained. Plan line 70 already names these checks; ensure they run before WU2 commit, not after.
- **Dimension 4 (revert leaves stale data):** Before WU2 fires the hardener live, take a snapshot of `harness/learning/hardening-registry.json` (its current state is `{}` per the 3-byte file size — effectively empty). If WU2 needs revert, the snapshot is the canonical pre-WU2 state. This is a one-line `cp` before any live exercise; document it in the WU2 commit message so a future revert knows the pre-state.

## Recommended redesign

(N/A — verdict is PROCEED-WITH-CAUTION, not RECONSIDER.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence — `wc -l` and `grep -n` outputs on the named SKILL.md files, `ls -la` of `harness/learning/` and `harness/session/`, line-level cross-references between the plan and the governor/mandate-parser SKILL.md files, and verbatim quotes from `write-ownership.md`, `hardening-registry-schema.md`, and `session-log-schema.md`. No training-data fallback was used on fetch/read failures; all referenced files were read in full or grep-bounded as needed. The two `not yet present` files (failure-mode-detector/SKILL.md, prompt-hardener/SKILL.md) were not read — their risk contribution was evaluated from the plan's stated intent only, as instructed.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

# Function B — Pre-change advisory: Phase 6 risk-check second opinion

## Verdict on verdict

**Concur with PROCEED-WITH-CAUTION, with one upgrade and one addition to the mitigation list.** The risk-check-reviewer scoped the change correctly, surfaced the two load-bearing hidden-coupling defects (wrong path + unstated overlay-propagation mechanism), and prescribed the right four mitigations. We accept the verdict as written.

The change sits cleanly inside repo conventions: workspace `.claude/skills/` is the correct home for harness machinery (`repo-architecture.md § Top-level layout`, "workspace-only skills (rare)" — but the rare exception is precisely the harness skill set, where `session-governor`, `session-reporter`, `mandate-parser`, `verification-playbook` already live). The audit artifact at `ai-resources/audits/risk-checks/` is correctly placed (`repo-architecture.md § Q7`). No symlink, permission, or CLAUDE.md edits — none of the cross-cutting blast-radius levers are pulled.

## Routing position

The reviewer-derived routing is correct and unchanged by us:

- Two new skills → `.claude/skills/failure-mode-detector/SKILL.md` and `.claude/skills/prompt-hardener/SKILL.md` — workspace-level harness skills, not graduated to `ai-resources/skills/` because they are tightly coupled to harness machinery, not portable across projects (`principles.md § DR-1`, three-tier model; harness scope explicitly governed separately per `system-doc.md § 1.1`).
- Governor and reporter edits stay in `.claude/skills/{session-governor,session-reporter}/SKILL.md`.
- Hardening-registry path is `harness/learning/hardening-registry.json` (operator brief confirms; mitigation 1 already corrects the plan's wrong-path).

No re-routing required.

## Architectural commentary on top of the routing

**1. The two mitigations the reviewer named as the top concern are the right ones — and they are paired, not independent.**

The wrong-path defect (mitigation 1) and the unstated overlay-propagation mechanism (mitigation 2) are the same defect class manifested in two places: the plan asserts pipeline continuity without naming the file-system contract that delivers it (`principles.md § OP-3 — loud failure over silent continuation`; `principles.md § AP-1 — silent conflict resolution`). Mitigation 2's recommended fix — governor re-reads `hardening-registry.json` at step 6 on the post-hardener re-invoke only — is the minimally-coupling option. It avoids re-running mandate-parser mid-session (which would create a second writer to `mandate.json` and violate `harness/schemas/write-ownership.md`) and avoids in-memory injection (which would create a second control path into `active_hardenings` that the governor SKILL.md does not currently model). Take the recommended option.

**2. Mitigation 3 (grep verification) is correct but should be promoted from "after WU2 commit" to "before WU2 commit."**

The plan already names this check at line 70 as a pre-commit verification. The risk-check report says "after WU2 commit, run grep …" — that is a one-word slip. Running it after commit means a failure produces a follow-up commit (or a `git reset`) rather than a clean WU2 commit. Verify before commit. This aligns with `principles.md § QS-3 — verify output against requirements before announcing complete`.

**3. Mitigation 4 (registry snapshot) is correct and load-bearing.**

The reviewer's Dimension 4 analysis is exactly right: `hardening-registry.json` is data, not code, and revert leaves stale entries. Snapshot before any live Phase 6 fire. The current file is 3 bytes (`{}`) — the snapshot is trivially cheap and is the difference between a clean revert and a one-step manual cleanup (`risk-topology.md § 5 — Signals that elevate a change to structural risk`: a "change [that] modifies a string literal matched by another component (two-end contract)" — the registry-entry shape is the two-end contract here).

## Risks the dimension review missed or under-weighted

**Missed risk 1 — Governor SKILL.md size and read-cost on every harness session.**

`session-governor/SKILL.md` is 705 lines today. WU2 adds the step-12 fill (replacing a `STUB` block — net-near-neutral) plus the Phase D closeout (~10–15 lines per the reviewer's estimate). This is harness-always-loaded content (`harness/.claude/references/harness-rules.md` line 10 — load on every harness session, every turn). `system-doc.md § 2.5` names context window as a hard constraint; `principles.md § DR-5` — "Every line costs tokens on every session." The reviewer evaluated this as Low (<150-token delta) which is correct on the marginal number, but the **trajectory** matters: governor SKILL.md was 705 lines before Phase 6 and will be ~720+ after; Phase 7 (step 21 maturation) will add more. We should accept this delta as low-risk for Phase 6 specifically, but flag that **by Phase 8, the governor SKILL.md will deserve a token-audit** — the current trajectory accumulates without an explicit ceiling. This is not a Phase 6 blocker; it is a forward-looking observation worth logging.

**Missed risk 2 — Phase D coupling between `learnings.json` closeout and the new hardening-registry closeout is a single point of failure for two unrelated subsystems.**

The reviewer rated this as "intentional coupling, documented at the change site" and we concur for Phase 6 scope. But the architectural pattern — Phase D as a serial closeout block that touches multiple sibling state files in sequence — is now adjacent to becoming a single-failure-mode boundary. If a future Phase D edit corrupts the block's structure, both `learnings.json` and `hardening-registry.json` closeouts fail simultaneously. The right answer for Phase 6 is to keep the closeouts adjacent (as the plan does) but to **separate them by a comment marker** so a future edit can fail one without bleeding into the other (`risk-topology.md § 1 Critical — system-wide effect if broken`, applied to the closeout block: the governor's Phase D is the closeout choke-point for all harness state). Add a clear `# --- learnings closeout ends; hardening closeout begins ---` separator. Cheap; encodes the boundary the dimension review left implicit.

**Missed risk 3 — The `Stop`-hook veto deferral (plan Finding #5) interacts with the hardener's mid-session re-invoke.**

Plan Finding #5 acknowledges the `Stop`-hook veto is still a Phase 1 stub and is out of scope. But the prompt-hardener's "re-invoke via step 6 overlay" path **is** a programmatic sub-agent re-invocation — which is precisely what a Stop-hook veto would gate. Today, with the veto stubbed, the hardener's re-invoke fires freely. This is correct for Phase 6 (the plan is not adding the veto), but it means the **failure-mode-detector + hardener loop has no upper bound on re-invocations within a single unit if step 12 keeps detecting failure** — there is no explicit "max harden attempts per unit" cap in the plan. The reviewer's Dimension 1 cost analysis assumed second-occurrence-only routing, which is correct for the first re-invoke; it did not enumerate the third, fourth, or Nth occurrence. Add a one-line cap in WU2's governor step 12 edit: **after one hardener-driven re-invoke per unit, route to step 13 (uncorrectable disposition) regardless of subsequent failure**. This matches `principles.md § AP-10 — error handling for impossible scenarios` inverted: it bounds an actually-possible runaway scenario without adding speculative defense (`principles.md § DR-7`).

## Position

**The right answer is: accept the PROCEED-WITH-CAUTION verdict, execute the four mitigations as written, and add three small augmentations.**

Augmentations:

1. **Mitigation 3 timing fix:** run the grep verification *before* WU2 commit, not after.
2. **Phase D separator marker:** add a comment marker between the `learnings.json` closeout and the hardening-registry closeout in WU2's Phase D edit.
3. **Re-invoke cap:** add a one-line cap in WU2's governor step 12 edit — one hardener-driven re-invoke per unit, then route to step 13.

None of these require re-running `/risk-check`. They are small, in-scope refinements that tighten the same surfaces the report already evaluated.
