# Risk Check — 2026-06-12

## Change

Re-sync 10 dormant project-local logs/scripts/split-log.sh copies by overwriting each with the fixed canonical ai-resources/logs/scripts/split-log.sh (commit 1ca4c1c — fence-aware header extraction + preamble preservation + bash-3.2 portable loop). Affected projects: buy-side-service-plan, obsidian-pe-kb, global-macro-analysis, project-planning, interpersonal-communication, nordic-pe-screening-project, ai-development-lab, axcion-brand-book, research-pe-regime-shift-advisory-gap, positioning-research. The script is shared-state automation (mutates live log files when /log-sweep runs in those projects). Propagation only — zero behavior change to the canonical, which already passed risk-check PROCEED-WITH-CAUTION at S6 with all mitigations applied and 19/19 isolated tests + independent QC GO. Mitigations planned: byte-identity (cmp) verification per copy after cp; per-repo commits with explicit-path staging; foreign-dirty skip-and-surface rule (4 concurrent sessions live in this checkout); re-enumeration via find before copying so no copy is missed.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/split-log.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/logs/scripts/split-log.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/obsidian-pe-kb/logs/scripts/split-log.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/global-macro-analysis/logs/scripts/split-log.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/logs/scripts/split-log.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/interpersonal-communication/logs/scripts/split-log.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-screening-project/logs/scripts/split-log.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/logs/scripts/split-log.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-brand-book/logs/scripts/split-log.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap/logs/scripts/split-log.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/positioning-research/logs/scripts/split-log.sh — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A uniform, well-mitigated propagation of a QC-passed bugfix to 10 live-but-low-frequency consumer copies; the only elevated risk is blast radius (10 shared-state automation files that mutate live logs), and the planned mitigations reduce it to a controlled, per-repo, byte-verified rollout — but the "dormant" framing understates that these copies are reachable via `/wrap-session` → `check-archive.sh`, which is a finding the operator should register.

## Consumer Inventory

Search terms: `split-log.sh` (basename), `split-log` (component), `check-archive.sh` (paired invoker), `SCRIPTS_DIR` (invocation marker). Grepped across `ai-resources/` and workspace root (`..`).

| Consumer path | Reference type | Must change? |
|---|---|---|
| `ai-resources/.claude/commands/log-sweep.md` (`SCRIPTS_DIR={AI_RESOURCES}/logs/scripts`, :31, :199) | invokes (canonical copy only) | no |
| `ai-resources/.claude/commands/wrap-session.md` (:31 runs `logs/scripts/check-archive.sh` from project cwd) | invokes (resolves to project-local copy) | no |
| `projects/{each}/logs/scripts/check-archive.sh` (`SPLIT="$PROJECT_DIR/logs/scripts/split-log.sh"`, :14) | invokes (the project-local copy being overwritten) | no |
| `projects/buy-side-service-plan/.claude/settings.json` (:87 SessionStart → check-archive.sh) | invokes (hook fires check-archive → project split-log) | no |
| `projects/positioning-research/.claude/settings.json` (:148 SessionStart → check-archive.sh) | invokes | no |
| `projects/research-pe-regime-shift-advisory-gap/.claude/settings.json` (:126 SessionStart → check-archive.sh) | invokes | no |
| `ai-resources/workflows/research-workflow/logs/scripts/split-log.sh` | co-edits (sibling install, already IDENTICAL to canonical) | no |
| `archive/.../split-log.sh`, workspace-root `logs/scripts/split-log.sh` | co-edits (out-of-scope siblings, DIFFER, not in the 10) | no |
| Audit/risk-check docs naming `split-log.sh` (repo-dd, log-sweep manifests) | documents | no |

Total: 9 distinct consumer classes, 0 must-change (the consumers invoke the script by path; none parse or hard-depend on its internal shape, so none requires modification). The 10 target files are themselves the change site, not consumers. Key correction to the description: the project-local copies are NOT purely "dormant" — `/wrap-session` Step 3 and three SessionStart hooks invoke `check-archive.sh`, which resolves `split-log.sh` to the **project-local** copy via `dirname "$0"/../..` (check-archive.sh:12,14). `/log-sweep` is the path that uses the canonical copy; `/wrap-session`/hooks use the project copy. So the overwrite changes live behavior on the `/wrap-session` path — which is exactly the intended fix.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded content added; the 10 files are scripts invoked on demand, not `@import`ed or loaded into any CLAUDE.md. No new hook is registered (existing SessionStart hooks already call check-archive.sh; their token cost is unchanged).
- Pure file-content replacement of existing scripts; per-session token cost is identical before and after. Evidence: change is `cp` over 10 existing `split-log.sh` files (CHANGE_DESCRIPTION); no settings or CLAUDE.md edit in the referenced-files set.

### Dimension 2: Permissions Surface
**Risk:** Low

- No settings.json permission entry is added, removed, or widened. The change writes only to 10 existing tracked files under `projects/*/logs/scripts/`. No new allow/ask/deny rule; no scope escalation; no external or cross-repo capability introduced. Evidence: referenced-file set contains only `split-log.sh` paths; no settings file referenced.

### Dimension 3: Blast Radius
**Risk:** Medium

- Touches 10 files directly, all of which are shared-state automation that mutates live append-only log files when invoked (check-archive.sh:14 invokes them; CHANGE_DESCRIPTION confirms shared-state class). This is the primary driver of Medium rather than Low.
- Consumer inventory: 9 consumer classes, **0 must-change**. No consumer parses the script's internal structure; all invoke it by path. The contract (CLI signature `<file> <keep> <top|bottom>`, archive-file naming, pointer format) is unchanged between old and new versions — verified by reading both (canonical lines 1-15 vs buy-side copy lines 1-15: identical signature and behavior surface). So the change is behaviour-compatible from every caller's perspective; the only behaviour delta is *correctness* (fence-aware + preamble-preserving), which is the fix's purpose.
- Uniformity verified: 9 of 10 old copies are byte-identical to each other (md5 `ec18f902...`). **positioning-research diverges** — it uses `mapfile -t HEADERS` (bash-4 only) instead of the bash-3.2 portable loop (diff confirmed). The re-sync therefore also closes a latent macOS-portability bug in that one copy (mapfile is undefined in bash 3.2, the macOS default). Net: the change improves, not regresses, that outlier.
- Shared-infra reach is real but bounded: each copy is project-scoped — overwriting project A's copy cannot affect project B. No single copy is read by more than one project's tooling.
- Blast-radius finding from the inventory not anticipated by the description: the "dormant" label is inaccurate for the `/wrap-session` path (3 projects also fire it via SessionStart hooks). This widens the *behavioural* footprint slightly but does not add a must-change consumer.

### Dimension 4: Reversibility
**Risk:** Low

- Each copy is a tracked regular file (not a symlink — verified for all 10) and is currently clean in git (porcelain returned empty for all 10 + canonical). A per-repo `git revert` or `git checkout` of the path fully restores the prior bytes; no sibling files or directories are created by the change itself.
- The change does not push beyond git (no push, no external write) — push remains gated to wrap. No log-data mutation is part of *this* change; it edits the tool, not the logs. (The tool's *future* runs mutate logs, but that is governed by the already-QC-passed canonical, not by this propagation.)
- Minor caveat keeping it Low (not trivially Low): revert is per-repo across up to 10 commits, so a full rollback is N small reverts rather than one — but each is a clean single-path revert with no manual cleanup. That is within the Low band.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The change introduces no new contract, marker, or filename convention — it propagates an existing one. The CLI signature, archive-file naming (`{BASE}-archive-{YYYYMM}.md`), and `> Archive: [...]` pointer format are unchanged between versions (read both copies).
- One implicit dependency exists but is pre-existing and unchanged: check-archive.sh locates split-log.sh by relative path (`$PROJECT_DIR/logs/scripts/split-log.sh`, :14). The re-sync keeps the file at the same path, so this coupling is preserved, not newly created.
- No silent auto-firing in an unexpected context: the new version's behaviour change (fence-aware, preamble-preserving) is strictly safer on the inputs these logs present — fenced `## ` placeholders stop being miscounted, and preamble lines stop being dropped. Consumers of archived logs read only the tail (/prime last-entry; check-archive bottom-10), never the preamble, per the prior canonical risk-check — so no downstream reader is surprised. No functional overlap with another mechanism is introduced.

### Dimension 6: Principle Alignment
**Risk:** Low

- principles-base.md was readable (`projects/strategic-os/ai-strategy/principles-base.md`). Checked against the structural-change-relevant IDs.
- **DR-1 / DR-3 (placement):** Aligned. The fix is authored in the canonical copy (`ai-resources/logs/scripts/`, DR-1 canonical tier) and propagated outward; it does not relocate any resource to a wrong tier. Per-project script copies are the established deployment pattern for this tool (check-archive.sh resolves them project-local by design).
- **OP-9 / AP-7 / DR-7 (speculative abstraction):** Aligned — and notably so. This is the opposite of speculation: every one of the 10 targets is a *confirmed existing consumer install*, not a "hook for later." Generalization is fully licensed (DR-7's "second confirmed consumer" bar is exceeded tenfold).
- **OP-12 (closure before detection):** Aligned. The change ships *closure* (a fixed archiver that no longer corrupts headers or drops preamble) — it adds no new detection/scan/flag. This counts *for* the change.
- **OP-5 (advisory vs enforcement):** Not touched — no advisory mechanism is upgraded to auto-correction; split-log.sh's enforcement scope (archiving) is unchanged.
- **OP-10 (system boundary):** Not touched — entirely within Claude Code; no cross-tool reach.
- **OP-11 (loud revision):** No principle is being revised, so no obligation triggers.
- **DR-10 (no wildcard `git add` during concurrent sessions):** Relevant and *honoured by the plan* — the description's "per-repo commits with explicit-path staging" and "foreign-dirty skip-and-surface rule (4 concurrent sessions live)" directly satisfy DR-10. This is a plan strength, not a violation.

## Mitigations

- **Dimension 3 (Blast Radius, Medium):** Apply the description's planned controls as hard preconditions, not best-effort: (a) `cmp -s` each target against the canonical *after* each `cp` and abort the batch on any non-match (byte-identity gate); (b) re-enumerate via `find . -name split-log.sh` immediately before copying and reconcile against the 10-path manifest so no install is missed and no out-of-scope sibling (archive/, workspace-root `logs/scripts/`, research-workflow template) is touched — those 3 are explicitly out of scope and must be excluded; (c) commit per-repo with explicit-path staging (no directory wildcards) and skip-and-surface any foreign-dirty project given the 4 concurrent sessions (DR-10).
- **Dimension 3 (framing correction):** In the commit message and/or wrap note, record that these copies are reachable via `/wrap-session` → `check-archive.sh` (not purely dormant), so the behavioural change on that path is a known, intended effect rather than a surprise on the next wrap in those projects. Specifically confirm positioning-research's `mapfile`→portable-loop change is desired (it fixes a latent bash-3.2 break), not an accidental overwrite of a local customization.

## Recommended redesign

(Not applicable — verdict is PROCEED-WITH-CAUTION.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence: both script versions read in full (canonical 106 lines, old copy 82 lines); `cmp`/`diff`/`md5` results for all 10 copies + 3 out-of-scope siblings; `grep -n` of log-sweep.md (:31, :199) and wrap-session.md (:31) invocation paths; check-archive.sh path-resolution lines (:12, :14); `git status --porcelain` clean-state and symlink checks on all 10 targets; SessionStart hook grep across project settings.json; principles-base.md ID citations (DR-1/DR-3/DR-7/DR-10, OP-9/OP-10/OP-11/OP-12/OP-5, AP-7). No training-data fallback was used on any read.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

**Full advisory on disk:** projects/axcion-ai-system-owner/output/consultations/consult-2026-06-12-split-log-dormant-copy-resync.md

**Verdict: concur with PROCEED-WITH-CAUTION, and the recommended mitigations are the right path — with one addition.**

Routing position: the change respects the baseline. Scripts under project `logs/scripts/` are project-local copies, not symlinks — there is no auto-sync for them (repo-architecture.md § Symlink topology). Manual per-repo overwrite IS the maintenance path this topology dictates. The change is correctly in-class ("Automation with shared-state effects", DR-8).

This is the right change, not just a safe one: leaving 10 copies divergent from a fixed canonical is silent drift (OP-11); propagating a confirmed fix to confirmed consumers is compounding-value maintenance (OP-1) and satisfies DR-7 (10 confirmed consumers, not speculation).

Mitigation dispositions — all endorsed:
- `cmp` byte-identity gate — keep hard, per-copy. Script mutation is NOT in the zero-risk log-append zone (risk-topology.md § 5).
- Per-repo explicit-path commits + foreign-dirty skip — load-bearing (DR-10); live concurrent-session friction already on record.
- Record `/wrap-session` reachability correction — endorsed; "dormant" understates that `check-archive.sh`/`/log-sweep` make these live (OP-3).
- `mapfile`→portable-loop — intended and correct (bash-3.2 floor on macOS); confirm the 10 targets share that floor.

**Risk the dimension review under-weighted — target-enumeration correctness.** The `find` exclusion of the 3 siblings is a single point of failure that `cmp` cannot catch: `cmp` verifies byte-identity *after* copy, never target-set correctness *before* it. **Addition: emit the resolved target list (find output minus the 3 exclusions) for a one-look operator confirmation before rollout** — this closes the gap the byte gate structurally cannot reach (OP-3).

With that one addition, PROCEED-WITH-CAUTION is correct and the rollout is sound.
