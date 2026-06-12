# Risk Check — 2026-06-12

## Change

Batch of 6 SO-vetted structural fixes for ai-resources (source: /fix-project-issues 2026-06-12, SO advisory consult-2026-06-12-fix-project-issues-ai-resources.md): (1) id-16 — remove dead /fewer-permission-prompts reference from ai-resources CLAUDE.md (verify-then-fix, string re-located before edit); (2) id-17 — correct the false "does not host a canonical usage log" statement in ai-resources CLAUDE.md (logs/usage-log.md exists); (3) id-41 — replace 2 byte-identical research-workflow command copies (refinement-pass.md, update-claude-md.md under workflows/research-workflow/.claude/commands/) with symlinks to canonical, after byte-identity verification; (4) id-08/05/06/07 — collapse the T2-a/b/c verbatim mirror blocks (Commit Rules ~200-240 tok/turn, Model Selection/Tier ~90 tok/turn, Session Boundaries ~25 tok/turn) duplicated across the two always-loaded CLAUDE.md files (workspace root + ai-resources) into short pointers per DR-5, preserving any deliberate mirror with an explicit note; (5) id-12 — add Read deny rule for audits/working/** to ai-resources .claude/settings.json (226 stale scratch files ~24,700 lines currently readable; DR-9 top-3 command analysis required: must not break the commands that legitimately read audits/working — e.g. /fix-project-issues Step 2.5 re-reads scanner notes, qc/triage subagents write+read working notes); (6) id-31 — add a content-conservation tripwire to split-log.sh (line-count partition assertion: kept + archived = original, abort rotation on mismatch), canonical copy + template copy in workflows/research-workflow, NOT the 11 deployed project-local copies this session (propagation is a separate logged step). Change classes: cross-cutting always-loaded CLAUDE.md edits, new symlinks, permission/settings change, shared-state script edit. All edits this session only in ai-resources repo + workspace-root CLAUDE.md.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/refinement-pass.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/update-claude-md.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/settings.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/split-log.sh — NOT at this path; canonical copy located at `logs/scripts/split-log.sh` (template copy at `workflows/research-workflow/logs/scripts/split-log.sh`)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/hooks/split-log.sh — does not exist; template copy is at `workflows/research-workflow/logs/scripts/split-log.sh`
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/usage-log.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Five of the six fixes are Low-to-Medium risk; item 5 (the `Read(audits/working/**)` deny rule) is High-risk because it would break the one main-session re-read that `/fix-project-issues` Step 2.5 explicitly declares mandatory — that item must be rescoped before landing.

## Consumer Inventory

The batch touches six distinct change targets. Consumers grouped by target. The split-log.sh canonical path is `logs/scripts/split-log.sh` (not `.claude/hooks/` as the brief assumed — corrected in Referenced files).

| Consumer path | Reference type | Must change? |
|---|---|---|
| **Item 1 — `/fewer-permission-prompts` dead ref** | | |
| ai-resources/CLAUDE.md:50 | documents (the dead ref being removed) | yes (the edit site) |
| ai-resources/.claude/commands/permission-sweep.md:5,322 | documents (live `/fewer-permission-prompts` cross-refs — NOT the dead ref; these point at the real skill) | no |
| **Item 2 — usage-log false statement** | | |
| ai-resources/CLAUDE.md:10 | documents (the false statement being corrected) | yes (the edit site) |
| ai-resources/logs/usage-log.md | (the file whose existence falsifies the statement) | no (exists, 90,889 bytes) |
| **Item 3 — command-copy → symlink** | | |
| ai-resources/workflows/research-workflow/.claude/commands/refinement-pass.md | (the copy being symlinked) | yes (becomes symlink) |
| ai-resources/workflows/research-workflow/.claude/commands/update-claude-md.md | (the copy being symlinked) | yes (becomes symlink) |
| ai-resources/workflows/research-workflow/.claude/shared-manifest.json:37,40 | parses (lists both under `commands.shared`) | no (already declares them shared) |
| ai-resources/.claude/hooks/auto-sync-shared.sh | invokes (reads manifest, manages symlinks in deployed projects) | no |
| ai-resources/.claude/commands/{deploy-workflow,sync-workflow,promote-workflow,fix-symlinks}.md | invokes (symlink lifecycle) | no |
| **Item 4 — mirror-block collapse (CLAUDE.md ×2)** | | |
| ai-resources/CLAUDE.md (Commit Rules, Model Selection) | co-edits (always-loaded mirror) | yes (edit site) |
| /Users/.../Axcion AI Repo/CLAUDE.md (Commit behavior, Model Tier, Session Boundaries) | co-edits (always-loaded canonical) | yes (edit site) |
| principles-base.md GAP-3 / DR-5 | documents (declares this duplication a RESOLVED, recognized exception) | no — but governs the change |
| **Item 5 — `Read(audits/working/**)` deny** | | |
| ai-resources/.claude/settings.json:24-33 | (the deny array being extended) | yes (edit site) |
| ai-resources/.claude/commands/fix-project-issues.md:76 | reads (main-session re-read of SCAN_NOTES_PATH under audits/working — "the one place re-reading is required") | **yes — BREAKS** |
| ai-resources/.claude/commands/fix-repo-issues.md:113 | reads (main-session conditional re-read of working-notes paths) | yes — degraded |
| ai-resources/.claude/agents/{diagnostics-scanner,fix-repo-issues-scanner,log-sweep-auditor,project-state-snapshot-agent,fading-gate-scanner,friday-act-16a-summarizer}.md | writes (subagents write notes to audits/working) | no (subagent writes; Write not denied) |
| ai-resources/.claude/agents/qc-reviewer.md:136 | writes (optional disk-write escape valve) | no |
| ai-resources/.claude/commands/{log-sweep,promote-workflow,resolve-repo-problem,create-skill,innovation-sweep,contract-check,friday-journal,archive-project,fix-project-issues,fix-repo-issues}.md | reads/writes (working-notes lifecycle) | partial — see Dimension 3 |
| **Item 6 — split-log.sh tripwire** | | |
| ai-resources/logs/scripts/split-log.sh | (canonical copy edited) | yes (edit site) |
| ai-resources/workflows/research-workflow/logs/scripts/split-log.sh | co-edits (template copy edited this session) | yes (edit site) |
| ai-resources/logs/scripts/check-archive.sh | invokes (sole caller of split-log.sh) | no (interface unchanged) |
| ai-resources/.claude/commands/wrap-session.md (Step 11/12 → check-archive.sh) | invokes (transitive) | no |
| 11 deployed project-local split-log.sh copies | co-edits (NOT touched this session — separate logged propagation step) | no (deferred by design) |

Total: ~30 distinct consumers across six targets, ~10 must-change (mostly the edit sites themselves). One **unanticipated-breaking** consumer surfaced: `fix-project-issues.md:76` main-session re-read under item 5's deny scope. The brief anticipated the risk in the abstract ("must not break the commands that legitimately read audits/working — e.g. /fix-project-issues Step 2.5 re-reads scanner notes") — this inventory confirms it is a real break, not a hypothetical one.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Items 1, 2, 3, 5, 6 add **zero** ongoing token cost — they are dead-ref removal, a factual correction (net token-neutral), a copy→symlink swap, a settings deny entry, and a shell-script assertion. None touch always-loaded content in a way that grows it.
- Item 4 (mirror collapse) **reduces** always-loaded token cost: the brief cites ~200–240 tok/turn (Commit Rules) + ~90 (Model) + ~25 (Session Boundaries) of duplicated content collapsed to short pointers across two always-loaded CLAUDE.md files. This is a net token *reduction* on every turn — the opposite of a usage-cost risk. Verified the mirror blocks exist: ai-resources/CLAUDE.md:64-68 (Commit Rules), :22-24 (Model Selection); workspace CLAUDE.md:161-167 (Model Tier), :194-208 (Commit/Push behavior), :88 (Session Boundaries pointer).
- Net direction across the batch: usage cost goes **down**.

### Dimension 2: Permissions Surface
**Risk:** Medium

- Item 5 is the only permission change. It **adds a `deny` entry** (`Read(audits/working/**)`), which *narrows* the surface — the opposite of widening. By the heuristic, narrowing is not itself a widening risk.
- However, the settings.json baseline is already maximally broad: `Bash(*)`, `Write(**/.claude/**)`, `Edit(...Axcion AI Repo/**)`, `defaultMode: "bypassPermissions"` (settings.json:4,18-22,34). The deny floor (lines 24-33) is the *only* operative safety boundary in this layer. Adding a `Read` deny to that floor is a structural change to the one part of the config that actually constrains behavior — Medium because it is a load-bearing edit to the safety floor, and (per Dimension 3 / 5) it has a functional-breakage side effect, not because it widens capability.
- Precedent check: existing deny rules are all `Read(...archive...)` / `Read(...deprecated...)` / `Read(...old...)` (settings.json:27-32) — read-suppression of stale content. A `Read(audits/working/**)` deny fits that established *pattern* (suppress stale scratch). So the shape is in-family; the risk is the behavioral collision, not the shape.

### Dimension 3: Blast Radius
**Risk:** High

Grounded in the Consumer Inventory above. The High is driven entirely by **item 5**; the other five items are Low-to-Medium blast radius.

- **Item 5 — `Read(audits/working/**)` deny breaks a must-change consumer.** `fix-project-issues.md:76` states verbatim: *"Read the full candidate rows from `SCAN_NOTES_PATH` (this is the one place re-reading the scanner notes is required …)"*. `SCAN_NOTES_PATH` is set to `audits/working/...` (the scanner writes there; `AUDITS_WORKING_DIR = "{AI_RESOURCES}/audits/working/"`, fix-project-issues.md:26). Deny rules apply to the **main session's** Read tool. So the Step 2.5 reconciliation read — the very step the brief flagged, and the step the command's own prose says "would have prevented the 2026-06-05 collapse" — would be **blocked**. This is a non-backwards-compatible break of a wired caller. `fix-repo-issues.md:113` has the same exposure (conditional main-session re-read of working-notes paths).
  - Subagent writes are NOT affected: the deny is `Read`, not `Write`; and subagents that write to audits/working (diagnostics-scanner, fix-repo-issues-scanner, log-sweep-auditor, etc.) use Write, which is unaffected. The break is specifically the **main session's required re-reads**.
- **Item 3 — symlink swap is contained.** Both copies verified byte-identical to canonical (`diff -q` → IDENTICAL for both refinement-pass.md and update-claude-md.md). Both are already declared `commands.shared` in shared-manifest.json:37,40 — i.e., the deployment surface already *expects* them to be symlinks to canonical; the current real-file state is the drift, and the symlink is the correction. auto-sync-shared.sh manages symlinks in *deployed projects*, reading the manifest; it does not re-symlink inside the template itself, so converting the template copies to symlinks is consistent with the contract. Backwards-compatible. Low blast radius.
- **Item 6 — split-log.sh has exactly one caller.** Every audit row confirms `split-log.sh` is "Called by check-archive.sh" and nothing else (repo-due-diligence-2026-05-08:183, -2026-04-27:100, -2026-05-12:109, etc.). The tripwire adds an internal assertion (kept+archived=original) that aborts on mismatch — it changes no input/output interface, so check-archive.sh is unaffected on the success path. The only behavioral change is a new abort-on-corruption exit, which is the intended safety upgrade. The 11 project-local copies are explicitly out of scope this session. Low blast radius.
- **Items 1, 2, 4 — CLAUDE.md edits.** Items 1 and 2 are single-line edits within one file each (no caller parses those exact lines). Item 4 is a co-edit across the two always-loaded CLAUDE.md files — see Dimension 5 for the load-bearing-content coupling.

### Dimension 4: Reversibility
**Risk:** Low

- Items 1, 2, 4 (CLAUDE.md edits), 5 (settings.json deny line), and 6 (split-log.sh assertion) are all single-tree text edits that `git revert` restores cleanly. No log/registry mutation, no external write, no push (push is gated to wrap per workspace CLAUDE.md).
- Item 3 (copy→symlink) is reversible: `git revert` restores the real-file blobs. Symlinks are tracked in git as the link target, so revert is clean. One nuance: if the symlink is created and a session later resolves through it, no stale state persists — the canonical file is unchanged.
- `audits/working/` is **gitignored** (ai-resources/.gitignore:24-25, "Ephemeral audit working notes"), so item 5's deny rule does not interact with any committed state in that directory — revert of settings.json is sufficient.
- No automation fires between landing and a potential revert that would propagate state (the split-log tripwire only fires on the next check-archive run, and it is fail-safe — it aborts rather than mutates on mismatch).

### Dimension 5: Hidden Coupling
**Risk:** High

- **Item 5 — the deny rule silently couples to the subagent-contract read pattern.** The deny would not error loudly at edit time; it fires only when `/fix-project-issues` Step 2.5 (or `/fix-repo-issues`) next runs and the main session attempts the required re-read. That is a silent auto-firing in an unexpected context — exactly the hidden-coupling failure mode. The brief itself flags this ("must not break the commands that legitimately read audits/working") but the deny as described would still trigger it. Also note: `audits/working/` is gitignored precisely so a deny rule is *not* needed — ai-resources/.gitignore:24 comment reads "subagent-contract discipline lives in CLAUDE.md, **not as a deny rule**." The repo has already made the explicit decision that read-discipline on this directory is a CLAUDE.md convention, not a settings deny. Item 5 contradicts a recorded design decision.
- **Item 4 — mirror collapse couples to the standalone-checkout assumption.** The two mirror blocks are NOT accidental duplication. principles-base.md states GAP-3 ("CLAUDE.md intentional duplication") is **RESOLVED — recognized DR-5 exception**, and DR-5 itself reads "(Deliberate cross-level duplication is a recognized, self-identified exception.)" The mirrored content in the research-workflow CLAUDE.md is explicitly annotated: *"This rule mirrors the canonical … section in the workspace-level CLAUDE.md. It is repeated here because projects are sometimes opened without the parent workspace context loaded."* If the ai-resources CLAUDE.md mirror exists for the same reason — ai-resources sessions opening WITHOUT the workspace-root CLAUDE.md loaded (e.g., a standalone checkout) — then collapsing the mirror to a pointer **removes load-bearing always-loaded rules** (commit behavior, model-tier prohibition) from those sessions. The brief anticipates this ("preserving any deliberate mirror with an explicit note") — so the coupling is known, but it is the load-bearing hinge of item 4 and must be resolved per-block, not collapsed wholesale. Medium-to-High coupling; rolled into the dimension's High because item 5 also lands here.
- Items 1, 2, 3, 6 are self-contained (no implicit dependency surfaced): the dead-ref removal, the factual correction, the verified-identical symlink, and the single-caller script assertion.

### Dimension 6: Principle Alignment
**Risk:** Medium

principles-base.md was readable (42 principles, frozen IDs). Checks applied:

- **DR-5 / GAP-3 (item 4) — directly on point.** The change *invokes* DR-5 as its justification ("collapse … per DR-5"), but DR-5's own text and GAP-3's RESOLVED status make the mirror a *recognized exception*, not a violation to be cleaned up. Collapsing a deliberate mirror without confirming the standalone-checkout case would be acting against the recorded exception. The brief's "preserving any deliberate mirror with an explicit note" keeps this in alignment *if* honored — hence Medium (tension), not High. The principle is not violated as long as each block is checked against the standalone-load case before collapse.
- **DR-9 / AP-6 (item 5) — top-3 analysis required and now done.** The change is audit-derived; DR-9 mandates top-3 affected-command analysis before applying. This risk-check supplies it (Dimension 3). The analysis concludes the deny *breaks* a top consumer — so DR-9 is satisfied *by* this report, and the finding is "do not apply as-described," which is the principle working as intended. No misalignment in process; the substantive finding is the High in D3/D5.
- **OP-12 (closure before detection)** — item 6 (split-log tripwire) ADDS detection (a conservation assertion) but it is a *fail-safe abort* that closes the failure mode it detects (aborts the rotation rather than emitting a finding for someone else to close). This *serves* OP-12 rather than violating it. Aligned.
- **OP-9 / DR-7 / AP-7 (speculative abstraction)** — no item builds for an absent consumer. Item 6 deliberately scopes OUT the 11 project-local copies (no speculative propagation). Item 3 symlinks only files already declared shared. Aligned.
- **DR-8** — this is itself the DR-8 risk-check for a gated batch (cross-cutting CLAUDE.md, new symlinks, permission change, shared-state script). Verdict below is binding and must not be downgraded to push through.
- No principle is *clearly violated and unacknowledged*, so this dimension is not High. The DR-5 tension (item 4) and the gitignore-vs-deny recorded-decision tension (item 5, see D5) are real but acknowledged in the brief — Medium.

## Mitigations

Required because the verdict is PROCEED-WITH-CAUTION (High on Dimensions 3 and 5, both driven by item 5; plus the item-4 coupling).

- **Item 5 (Dimension 3 + 5 High) — do NOT add `Read(audits/working/**)` to settings.json as described. Rescope to one of:** (a) **Drop item 5 entirely** and rely on the existing recorded mechanism — `audits/working/` is already gitignored, and ai-resources/.gitignore:24 explicitly states read-discipline on this dir "lives in CLAUDE.md, not as a deny rule"; the 226 stale files are ephemeral and already excluded from git. The token/read cost the audit worried about is a CLAUDE.md/subagent-contract concern, not a permission-floor concern. **(Recommended.)** OR (b) if a deny is still wanted, **scope it to exclude the live read path** — but there is no clean glob that denies stale notes while allowing `SCAN_NOTES_PATH`, because both live under `audits/working/`; an age- or name-based exclusion is not expressible in the settings glob grammar, so (a) is the only clean option. Either way: before landing, run `/fix-project-issues` (or dry-read its Step 2.5) to confirm the main-session re-read of `SCAN_NOTES_PATH` still succeeds.
- **Item 4 (Dimension 5 coupling) — per-block check before collapse.** For each of the three mirror blocks (Commit Rules, Model Selection/Tier, Session Boundaries), confirm whether ai-resources sessions can open WITHOUT the workspace-root CLAUDE.md loaded (standalone checkout). Where they can, KEEP the mirror with the explicit "repeated because opened without parent context" annotation (matching the research-workflow CLAUDE.md precedent) rather than collapsing to a pointer. Collapse only blocks that are genuinely never loaded standalone. This honors the DR-5 recognized exception (GAP-3 RESOLVED).
- **Item 3 (precondition) — re-verify byte-identity immediately before the swap.** Already confirmed IDENTICAL at review time (`diff -q` on both files), but re-run at apply time since the canonical files could change between review and apply; symlink only on a clean IDENTICAL result (the brief already specifies "after byte-identity verification").

## Evidence-Grounding Note

All risk levels grounded in direct evidence: settings.json line numbers (4,18-34), CLAUDE.md line numbers (ai-resources :10,:50,:64-68; workspace :161-208), `diff -q` byte-identity results for both command copies, shared-manifest.json:37,40, fix-project-issues.md:26,76, ai-resources/.gitignore:24-25, principles-base.md DR-5/GAP-3/OP-12/DR-7/DR-9 verbatim, and grep counts across the repo + workspace root. The split-log.sh path was corrected from the brief's assumption (`.claude/hooks/`) to the verified location (`logs/scripts/`). No training-data fallback was used.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

**Full advisory on disk:** projects/axcion-ai-system-owner/output/consultations/consult-2026-06-12-risk-check-2nd-opinion-s10-fix-batch.md

**Verdict: We concur with PROCEED-WITH-CAUTION and with all three mitigations as written.** The risk-check did the load-bearing work — it ran the DR-9 top-3 analysis the permission change-class required, and that analysis surfaced a real break, not a hypothetical one. The verdict is binding (`principles.md § DR-8`; `risk-topology.md § 4`).

**Routing:** Whole batch lands in-place on canonical `ai-resources/` + workspace-root CLAUDE.md — no new homes, no tier questions. All four gated change classes converge here, so two-gate `/risk-check` is correct. The judgment surface is entirely risk, not routing.

**The recommended path is the right one:**
- **Item 5 — DROP.** Strongest finding. The deny contradicts a recorded design decision (`.gitignore:24`: read-discipline "lives in CLAUDE.md, not as a deny rule"). `audits/working/` is gitignored (`risk-topology.md § 5` zero-risk), so the stale-notes problem is a subagent-contract concern (`ai-resources/CLAUDE.md § Subagent Contracts`), not a permission-floor one. Option (b) correctly rejected — no glob separates `SCAN_NOTES_PATH` from stale siblings.
- **Item 4 — per-block check, KEEP genuine mirrors.** DR-5/GAP-3 make the mirror a recognized exception, not debt. Collapsing wholesale would act against the recorded exception (`principles.md § DR-5`, `§ GAP-3`).
- **Item 3 — re-verify byte-identity at apply time.** Sound; it's drift-correction of already-shared files, not new abstraction (`§ DR-7`).

**Three residual risks the dimension review did not fully surface:**
1. **Item 6 propagation debt (Medium)** — 11 deployed `split-log.sh` copies stay un-tripwired; the deferral is correct scope but leaves a non-uniform-guarantee window. Log it with a named trigger (next `/sync-workflow` or Friday cadence), not an open "separate step."
2. **Item 4's risk is realized at execution time** — each collapse edits always-loaded content (`risk-topology.md § 1 Critical`); the end-time gate must re-confirm no load-bearing standalone block was collapsed (`§ AP-4`).
3. **Same-file apply-order (Low)** — items 1, 2, and 4 all mutate `ai-resources/CLAUDE.md`; line numbers shift between edits. Sequence with a re-read, or verify the single-line edits against post-item-4 state.

**Position:** Proceed as five items (DROP item 5), honor the item-4 and item-3 mitigations, add the three execution notes. Residual risk drops from High → Low-Medium once item 5 is out — the High was entirely item-5-driven. End-time `/risk-check` must still fire and confirm: item 5 dropped (not re-scoped in), no load-bearing block collapsed, byte-identity held at apply.

## Execution Disposition (end-time gate record, 2026-06-12 S10)

Executed set = gated set minus three dropped items. All mitigations applied and QC-verified (qc-reviewer verdict GO).

| Item | Disposition | Evidence |
|---|---|---|
| 1 — dead `/fewer-permission-prompts` ref | **DROPPED — premise false.** `/fewer-permission-prompts` is a live built-in Claude Code skill (present in the session skill list); the 35d repo-dd audit only grepped repo files. CLAUDE.md:50's reference is valid. | verify-then-fix at apply time |
| 2 — usage-log false statement | **APPLIED.** CLAUDE.md:10 corrected to name `logs/usage-log.md` as ai-resources-only; contradiction with §Session Telemetry resolved. | QC GO finding 1a |
| 3 — symlink 2 command copies | **APPLIED.** Byte-identity re-verified at apply time (mitigation 3); relative symlinks matching sibling convention; resolve-identical confirmed. | QC GO finding 1b |
| 4 — CLAUDE.md mirror collapse | **DROPPED — already applied.** Commit 7d415fc (2026-06-08, W24 batch) landed the exact T2-a/b/c collapse same-day as the audit; workspace side in 76ef393. Mirror blocks confirmed unchanged this session (mitigation 2 honored vacuously). | git log + QC GO finding 2 |
| 5 — Read(audits/working/**) deny | **DROPPED per mitigation 1.** settings.json untouched (QC-confirmed). | QC GO finding 2 |
| 6 — split-log.sh tripwire | **APPLIED.** Conservation assertion (non-blank + header counts) aborts pre-write; fixture-tested incl. injected-bug abort path; template copy cmp-identical. Propagation debt for 11 deployed copies logged with named trigger (SO residual risk #1). | QC GO finding 4 |

SO second-opinion execution notes: #1 (propagation named trigger) — done, improvement-log entry with weekly review-cycle; #2 (end-time confirm no load-bearing block collapsed) — confirmed, item 4 dropped entirely, mirrors intact; #3 (same-file apply-order) — moot, only one CLAUDE.md edit landed (items 1, 4 dropped).
