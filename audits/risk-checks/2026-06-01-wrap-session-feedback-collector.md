# Risk Check — 2026-06-01

## Change

Plan-time gate for: turning /wrap-session into a per-session feedback collector. Change set: (1) NEW agent ai-resources/.claude/agents/session-feedback-collector.md (fresh-context, model opus, tools Read/Glob/Grep/Write) that reads the just-written session note + a rubric doc and appends extracted signals to friction-log.md, improvement-log.md, innovation-registry.md; it does NOT write usage-log.md or maintenance-observations.md; (2) NEW doc ai-resources/docs/session-feedback-dimensions.md (~50-line rubric that CITES vault/CLAUDE.md grounding — system-doc.md §2/§4.5, principles.md OP-1/OP-9/OP-11, Autonomy Rules pause-list, audit-discipline.md risk-check classes, risk-topology.md — rather than restating; NOT always-loaded); (3) EDIT canonical ai-resources/.claude/commands/wrap-session.md — add a 3rd opt-in preflight toggle (Session feedback collection y/n) alongside the existing telemetry+coaching toggles and extend the shorthand parser; add a one-line "### Risky actions" capture in the existing Step 4 session-note write (warm-sourced danger input, "none" is common case); add a NEW gated Step 6.5 (between decisions-logging Steps 5-6 and coaching Step 7) that — when the toggle is yes and the session is non-trivial — launches the session-feedback-collector subagent with paths only, appends a "### Session Assessment" block to today's session-notes.md entry (after ### Decisions Made, before ### Next Steps), and surfaces any HIGH-severity safety signal prominently in chat; advisory only — NEVER blocks commit/push, including high-severity safety signals; (4) EDIT ai-resources/docs/agent-tier-table.md — add one line for the new agent; (5) MIRROR the toggle + Step 4 risky-actions line + Step 6.5 into the non-symlink workspace-root /.claude/commands/wrap-session.md (independent Phase-3 copy operating on workspace-level logs).

Design properties relevant to risk:
- Advisory-only, opt-in (defaults to operator choosing per-wrap; not always-on).
- Feeds ONLY existing consumer-backed stores (friction-log → /improve; improvement-log → /friday-checkup, /friday-act; innovation-registry → Friday triage). No new data store created.
- Soft-cap discipline: the collector dedups candidates against existing active improvement-log.md entries + archive, and caps appends per session (safety/guardrail-candidate signals get append priority), parking overflow in the Session Assessment block — to respect /friday-checkup's existing 7-entry improvement-log soft-cap that blocks Friday execution when exceeded.
- The collector is a NEW shared-state writer to three append-only logs that are also written by /improve, /friday-act, /innovation-sweep, and (for session-notes) /prime, /session-start, /wrap-session itself, and check-archive.sh.
- Canonical wrap-session.md is symlinked by ~16 project copies (changes auto-propagate); the workspace-root copy is an independent non-symlink that must be edited separately.
- The canonical wrap-session.md already contains a foreign-session pre-write guard on session-notes.md (Step 3.5) and a concurrent-session staging discipline (DR-10: no directory-wildcard git add).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/session-feedback-collector.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-feedback-dimensions.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/agent-tier-table.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/friction-log.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/innovation-registry.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A well-scoped advisory feature with no permission widening and bounded per-session token cost, but it introduces a new automated writer to three concurrently-written append-only logs through a command that propagates to 16 symlinked copies — the blast-radius and hidden-coupling dimensions are High and require paired mitigations before landing.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded file is touched. The new rubric doc is explicitly "NOT always-loaded" (CHANGE_DESCRIPTION item 2), and the agent-tier-table edit is one line in a file whose own header says "Not needed for every turn" (agent-tier-table.md:3).
- The new subagent is opt-in and only spawns at wrap-time when the operator toggles yes AND the session is non-trivial — pay-as-used, not per-turn or per-tool-call. The collector also follows the disk-notes/short-summary subagent contract direction (fresh-context, Read/Glob/Grep/Write), bounding main-session context return.
- Per-wrap incremental cost is one subagent invocation plus a ~50-line rubric read — comparable to the existing Step 7 coaching and Step 12 telemetry passes, which are also opt-in at the same preflight. No new always-on cost is added to the 16 symlinked project copies; they inherit an additional opt-in step, not a mandatory one.

### Dimension 2: Permissions Surface
**Risk:** Low

- No settings.json / settings.local.json edit is in the change set. No `allow`, `ask`, or `deny` entry is added, removed, or narrowed (no permission file appears in REFERENCED_FILE_PATHS or CHANGE_DESCRIPTION).
- The new agent declares tools Read/Glob/Grep/Write (CHANGE_DESCRIPTION item 1) — Write is already the established capability for every log-appending agent in this repo; no new tool family is introduced.
- The agent writes only to existing in-repo logs (friction-log.md, improvement-log.md, innovation-registry.md) — no cross-repo, external-API, or MCP capability. Model tier is `opus` declared in frontmatter, which is the only permitted out-of-session tier mechanism (workspace CLAUDE.md → Model Tier) — compliant, not a widening.

### Dimension 3: Blast Radius
**Risk:** High

- **wrap-session.md propagation enumerated.** `find -name wrap-session.md -type l` returns 16 symlinks to the canonical ai-resources copy (harness, pe-kb-vault, travel-os, and 13 projects). Editing the canonical file auto-propagates the new preflight toggle + Step 4 risky-actions line + Step 6.5 to all 16 live project wraps in one commit. The workspace-root copy is a separate non-symlink regular file (`find -type f` returns 3 regular copies: workspace-root, canonical ai-resources, and the research-workflow template copy) and must be edited separately (item 5) — a divergence-prone manual mirror.
- **Shared-log writer fan-in enumerated.** `grep -rl` across `.claude/commands` + `.claude/hooks`: friction-log.md referenced by 16 files, improvement-log.md by 16 files, innovation-registry.md by 6 files. The collector becomes an additional automated writer alongside this existing fan-in (/improve, /friday-act, /innovation-sweep, check-archive.sh, and wrap-session itself).
- **Soft-cap contract dependency confirmed.** friday-act.md:92 reads `Soft cap — if active count > 7` with the chat line at :94 (`Improvement-log has {N} active entries (soft cap: 7)`). The improvement-log already holds 18 `### ` blocks (`grep -c "^### "`), well above the count this cap watches — an unbounded collector would push Friday execution further past the cap. The described dedup-and-cap-per-session discipline directly addresses this, but its correctness is load-bearing for the Friday pipeline.
- **Contract change to session-notes.md structure.** A new `### Session Assessment` block is inserted into today's entry (after ### Decisions Made, before ### Next Steps). Step 7a of the canonical wrap parses the session note by section ("scan from today's header to the next `##`"), and the Step 3.5 foreign-session guard counts `^## ` headers and `^**Mandate:**` lines — the new `### ` (H3) block does not collide with those H2/Mandate signals, so the guard is not broken, but any downstream section-parser must tolerate the new heading.

### Dimension 4: Reversibility
**Risk:** Medium

- The two NEW files (agent, rubric doc) and the four EDITs (two wrap-session copies, agent-tier-table, plus the Step-4/Step-6.5 logic) are all in-tree and `git revert`-able in the same working tree. The 16 symlinks need no separate revert — they auto-track the canonical file.
- **Append-only log mutation is the irreversibility vector.** Once the collector runs even once before a revert, it will have appended signals to friction-log.md / improvement-log.md / innovation-registry.md. A `git revert` of the *command* does not retract those already-committed log entries — they carry forward into /improve and Friday triage as if operator-authored. This matches the known append-only-log revert limitation (auto-memory: session-notes append-direction, end-time risk-check skip rule). Cleanup requires one manual step: prune the collector's appended entries from the three logs.
- No state propagates beyond git: no push, no external write, no Notion write is in the change set. Pushes remain gated at wrap (workspace CLAUDE.md → Push behavior). Net: clean code revert, but one manual log-pruning step if the collector fired before rollback — Medium, not Low.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Concurrent-write coupling with the existing foreign-session guard.** Step 6.5 runs AFTER the Step 3.5 pre-write guard has already cleared and (in the normal flow) after the Step 4 session-note write. The collector appends to session-notes.md (the Session Assessment block) and to three other logs late in the wrap. The wrap's own DR-10 discipline stages by explicit path with no directory-wildcard `git add`; the collector's extra writes to improvement-log.md / innovation-registry.md must be added to the "always-staged (if modified)" enumeration (canonical Step's staging list, lines 287–289) or they will be silently left uncommitted — an implicit dependency on the staging list being updated in lockstep.
- **Ordering coupling not visible from the change site.** Step 6.5 sits between Step 5 (decisions) and Step 7 (coaching). Step 7a re-reads today's session-note section to extract the mandate block; if Step 6.5 has just inserted a `### Session Assessment` block, Step 7a's "scan to next `##`" range now includes it — benign for mandate extraction (it keys on `**Mandate:**`), but the ordering assumption is silent and must hold.
- **Two-copy divergence is a silent contract.** The canonical and workspace-root wrap-session.md are independent (non-symlink). The existing Step 3.5 guard already carries a "PAIRED CONTRACT — keep in sync" comment block (canonical lines 40–47; workspace-root lines 12–19) precisely because these two files drift. Adding Step 6.5 + the toggle + the risky-actions line to both copies extends this manual-sync surface; without an equivalent paired-contract marker on the new step, a future edit to one copy silently desyncs the other.
- **Soft-cap coupling is an undocumented cross-command contract.** The collector's per-session append cap exists only to protect friday-act.md:92's `> 7` gate. That dependency lives in the collector's body, not at the friday-act site — a future change to the friday-act cap (e.g., raising to 10) would silently invalidate the collector's tuning unless the coupling is documented at both ends.

## Mitigations

- **Blast radius (symlink propagation):** Land the canonical ai-resources/.claude/commands/wrap-session.md edit and the workspace-root /.claude/commands/wrap-session.md mirror in the SAME commit, and immediately after, spot-verify two symlinked project copies (e.g., `projects/strategic-os/.claude/commands/wrap-session.md` and `knowledge-bases/pe-kb-vault/.claude/commands/wrap-session.md`) resolve to the new content — confirming the 16-way propagation landed and the non-symlink mirror matches.
- **Blast radius (soft-cap):** Before landing, write the collector's per-session append cap and dedup-against-active+archive rule explicitly into the agent body, and add a one-line pointer at friday-act.md:92 noting that the session-feedback-collector also appends to improvement-log under the same soft-cap — so the `> 7` contract is documented at both producer and consumer ends.
- **Hidden coupling (staging list):** In BOTH wrap-session.md copies, confirm improvement-log.md, friction-log.md, and innovation-registry.md are in the "always-staged (if modified this session)" enumeration (canonical lines 287–289 already list improvement-log.md and innovation-registry.md; add friction-log.md if the collector writes it) so the collector's appends are committed, not silently dropped by the explicit-path DR-10 staging rule.
- **Hidden coupling (two-copy sync):** Add a "PAIRED CONTRACT — keep in sync" comment marker on the new Step 6.5 and toggle in both wrap-session.md copies, mirroring the existing Step 3.5 paired-contract block, so future edits to one copy flag the sibling.
- **Reversibility (append-only logs):** Have the collector tag its appended entries with a stable marker (e.g., a `<!-- source: session-feedback-collector YYYY-MM-DD -->` comment per appended block) so that if the feature is reverted, the collector-authored entries can be located and pruned in one pass rather than hand-audited.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures. The two NEW files were evaluated from described intent only (tagged `not yet present`, not read), as required; this is noted in Dimensions 1, 2, 4, and 5 where their contribution is assessed.

## Architectural Commentary

_System-owner second opinion (Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION. Delivered chat-only per the advisory invocation; not written to output/consultations/._

**Q1 — Concur with PROCEED-WITH-CAUTION.** Sits in two gated change classes (new canonical command/agent + canonical edit), both All-projects blast radius (risk-topology.md §3), and is shared-state automation (DR-8 trigger). Respects OP-5 (advisory, never blocks) and OP-2, so not RECONSIDER; propagation surface + new automated writer into concurrently-written append-only logs is real, so not a clean GO. Verdict not downgradeable (DR-8).

**Q2 — Five mitigations are right; M2 insufficient + a sixth is missing.**
- M1+M3 satisfy DR-10 (explicit-path staging on concurrently-written append-only logs — honor in BOTH wrap copies).
- M4 correctly documents the two-copy non-symlink mirror (risk-topology.md §5 two-end contract).
- M5 correctly downgrades reversibility.
- **M2 UPGRADE (insufficient as written):** documenting the cap is not enough — the collector must ENFORCE a hard per-session append ceiling in its own body (Subagent Contracts: agent owns its output shape), fail loud on overflow (OP-3), not silently truncate.
- **M6 NEW (missing):** provenance separation (QS-9, AP-4). Every collector-appended entry must be visibly machine-authored so Friday triage / /resolve-improvement-log can weight or filter operator-authored vs collector-authored entries. M5's revert-marker should double as the provenance tag.

**Q3 — Soft-cap starvation risk was under-weighted (real).** The friday-act.md:92 `>7` soft-cap is not just a doc gap — it is a budget-contention failure mode. A per-session collector auto-filling the 7-entry budget crowds out operator-authored friction signals; fill rate scales with session count, not signal rate (OP-1 inversion; AP-4 symptom). Aggravated by concurrent writes (DR-10). Fix = strengthened M2 (enforced cap) + M6 (provenance ranking). Without both, hold the change.

**Position:** PROCEED-WITH-CAUTION, land with all five mitigations PLUS M2-upgraded (enforced fail-loud per-session cap in collector body) and M6 (provenance tag every collector-appended entry). Re-run end-time /risk-check after the collector's cap logic is written, since that logic is the load-bearing mitigation and does not exist at plan time. Grounded in OP-1/OP-5/QS-9/DR-8/DR-10 + Subagent Contracts.
