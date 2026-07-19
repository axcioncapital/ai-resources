# Risk Check — 2026-07-19

## Change

PROPOSED CHANGE: replace /prime Step 3's improvement-log scan. Today it emits raw `grep -nE -B6` output (247 lines / 56,508 chars measured live in ai-resources) plus a separate python UNCLASSIFIED-count scan, and instructs the MODEL to apply the resolved/LOW/MED filter in-head. Replace both with one inline python3 parser (`<<'PY'` QUOTED heredoc) that parses entries, normalizes the free-text Severity value, applies the filter IN CODE, and emits one compact line per unresolved-HIGH entry plus a self-checked census. Measured on the canonical log: 26 lines / 3,330 chars — 94% reduction, under the command's own stated <40-line budget. Also REWRITE (not delete) the stale prose at prime.md:220. Mission repo-health-backlog-2026-07, thread 15.

WHY THE OBVIOUS ALTERNATIVES ARE UNAVAILABLE: narrowing `-B6` is explicitly forbidden at prime.md:217 ("Do not narrow it: at -B4 the header is lost"); the log drain has already run (0 resolved-unarchived). The emit side is the only remaining lever.

BLAST RADIUS — verified by the caller. `prime.md` is carried by 28 paths. 25 are symlinks to canonical. Of the 3 real files: one IS canonical (760 lines); the other two — projects/axcion-sector-intelligence/.claude/commands/prime.md and ai-resources/workflows/research-workflow/.claude/commands/prime.md — are 33-line stubs with `grep -c improvement-log` = 0 and `grep -c Severity` = 0. EFFECTIVE RADIUS = the 25 symlinked consumers. 18 of the 28 consumer directories have a `logs/improvement-log.md`; 10 do not (per caller's count — see re-derivation below, which finds 19/9).

MEASURED WORKSPACE-WIDE EFFECT: OLD total 464 lines. NEW total 92 lines across "all 18 live improvement-logs." 6 logs decrease, 1 unchanged, 12 increase from 0 to exactly 2 lines.

RELATED FINDING, not part of this change: the current scan returns zero in 13 of 18 project logs — `/prime`'s urgent-item detection is silently non-functional across most of the workspace. Filed to `/friday-act` separately.

DESIGN — three rules: (1) population-aware fail-open/fail-closed by measured Severity-classification fraction (≥0.5 show, <0.5 count-only); (2) disposition ledger replacing a tautological v2 census; (3) orphan scan for HIGH severity lines outside any parsed entry.

DEFECTS THIS FIXES BEYOND TOKEN COST: two genuine HIGH entries (`:765`, `:1140`) invisible under the current anchor because their Severity value is bolded (`**high**`); a pre-existing unguarded `open()` at prime.md:210 that tracebacks on a missing improvement-log.md (10 consumer dirs).

TESTING: fixture-declared-before-run methodology; 9-case schema-present fixture → "5 of 8 entries"; schema-absent fixture → "0 of 5 [log has no Severity schema]", exactly 2 lines; missing file → silent, exit 0; both guards fire on trigger fixtures and stay silent on canonical; live log → 26 lines.

RISKS THE CALLER FLAGGED AGAINST THEMSELVES: (a) filter-in-code silent-failure class; (b) zsh heredoc execution — validated only on the standalone `.py`, not the final wrapped form in `prime.md`; (c) a future editor could add a filter branch that drops entries without tripping the ledger; (d) `SCHEMA_THRESHOLD = 0.5` is a judgment call, untested at a mid-range population.

OUT OF SCOPE, deliberately: ticking mission thread 15; normalizing severity vocabulary; fixing the 13-project schema gap (stated as "filed to /friday-act this session").

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/missions/repo-health-backlog-2026-07.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/output/consultations/consult-2026-07-19-prime-step3-emit-redesign.md — exists
- /private/tmp/.../scratchpad/scan3-v3.py — exists
- /private/tmp/.../scratchpad/fixture2.md, fixture-noschema.md, fx-orphan.md, scan3-sabotaged.py — exist

## Verdict

RECONSIDER

**Summary:** The design itself is unusually well-verified (every fixture claim, every arithmetic claim, and the core defect chain all reproduced exactly by independent execution), but two independent dimensions score High on their own merits — the static instruction-file cost of the proposed heredoc is unmeasured and, in 13 of 19 real project directories, likely makes `/prime` more expensive per session, not less; and the change reaches universal shared infrastructure (25 live symlinked consumers) — and the rubric's "two or more High" rule forces RECONSIDER regardless of per-dimension mitigability.

## Consumer Inventory

Search terms derived from the change: `prime.md` (basename), `improvement-log.md` (data source), `Severity` / `UNRESOLVED HIGH` (new contract markers), `Step 3` scoped to the improvement-log scan.

| Consumer path | Reference type | Must change? |
|---|---|---|
| 25 symlinked `.claude/commands/prime.md` paths (workspace root, `harness/`, `archive/nordic-pe-macro-landscape-H1-2026/`, and 22 of 24 `projects/*/`, plus `knowledge-bases/pe-kb-vault/`) — all resolve to the canonical file via `readlink` | invokes | no (auto-propagate atomically via symlink; zero separate edits) |
| `projects/axcion-sector-intelligence/.claude/commands/prime.md` (real file, 33 lines) | documents (stale divergent copy) | no — confirmed by direct grep: 0 hits for `improvement-log`, 0 for `Severity`; contains no Step 3 at all |
| `ai-resources/workflows/research-workflow/.claude/commands/prime.md` (real file, 33 lines) | documents (stale divergent copy) | no — same confirmation, 0/0 hits |
| `logs/missions/repo-health-backlog-2026-07.md` (thread 15; thread 1/2 acceptance assertions) | parses-by-reference (validation contract cites Step 3's "<40 lines" and reachability) | no code change, but the mission's acceptance assertions are judged against this change's actual output |
| `docs/backlog-reconciliation.md` | documents Step 1a only (a different `/prime` step) | no — grepped directly; it references the Step 1a git cross-check, never Step 3 / `improvement-log.md` / `Severity`. Checked explicitly to rule out a lockstep-pair coupling; none found. |
| `logs/improvement-log.md` (data source, not a caller) | parsed-by (the change reads this file; not a consumer of the change's contract) | n/a — noted for completeness, not counted in the consumer total |

**Total: 28 consumer directories carry a `prime.md` path; 25 are live symlinked consumers (must-change = no, all); 2 are inert stub copies (confirmed zero Step-3 content); 1 mission file has an outcome-dependent (non-code) reference.** This is not an isolated change — it is read by every session-start in every active project in the workspace, even though the mechanical edit surface is a single canonical file.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** High

- **The reported "94% reduction" measures only the dynamic runtime-output delta, not the static instruction-file cost of the new heredoc — and the static cost is real.** `scan3-v3.py` as written (the exact file staged for landing) is 172 lines / 7,396 chars (`wc -l`/`wc -c`, executed directly). The current Step 3 code block it replaces is 12 lines / 698 chars (`sed -n '203,214p' prime.md | wc`). If landed at or near this size, Step 3's *static* definition inside `prime.md` grows by **+6,698 chars (~+1,675 tokens)** — incurred on every single `/prime` invocation, in every project, regardless of whether that project's log has anything to show.
- **Per-project total (static + dynamic) reverses direction for 13 of 19 measured real project logs.** Computed directly: for the 12 logs the caller reports going 0→2 dynamic lines, old total ≈ 698 + ~0 chars ≈ 698 chars; new total ≈ 7,396 + ~180 chars ≈ 7,576 chars — a **~10.8× increase** in Step-3 cost for those sessions, every session, going forward. The "1 unchanged" log (`projects/obsidian-pe-kb`, dynamic 0→0, `wc -l` verified) is **not actually unchanged** once static cost is counted — it moves from ≈698 to ≈7,396 chars too. Only the 6 large/populated logs (canonical, `axcion-website`, `project-planning`, etc.) see a large enough dynamic saving to make the net direction a decrease.
- **This gap is present in the change description, the mission thread, and the System Owner consult alike** — none of the three measures the static delta; all three measure runtime-output only. This is a new, independently-derived finding, not inherited from any input.
- **Mitigation is concrete and specific:** strip the module docstring and non-essential comments from `scan3-v3.py` before landing (the 34-line docstring and inline comment blocks are dev/audit-trail material, not runtime-necessary), and measure `prime.md`'s Step-3 section byte-size delta directly (not just the tool-output delta) as an explicit pre-commit check.

### Dimension 2: Permissions Surface
**Risk:** Low

- No new `allow`/`ask`/`deny` entries required. `python3` execution already falls under the existing broad grant: `ai-resources/.claude/settings.json:4` — `"Bash(*)"` — confirmed by direct read. The existing Step 3 already runs `python3 -c "…"` under this same grant; the change swaps the invocation form (`-c` → `<<'PY'` heredoc), not the permission class.
- No scope escalation (project → user), no new external capability, no MCP/API surface touched.

### Dimension 3: Blast Radius
**Risk:** High

- **Grounded directly in the Step 1.5 inventory:** 25 live symlinked consumers (>5, the explicit High threshold on caller count), reaching every active project's session-start orientation. This is "shared infrastructure touched in a way that affects multiple workflows" — the exact explicit High trigger in the heuristic — independent of the caller-count trigger.
- **Mitigating factor, also grounded in the inventory:** zero consumers require independent modification (symlinks auto-propagate atomically on the single canonical edit); the 2 real-file stub consumers are confirmed to carry zero Step-3 content and cannot regress; the interface contract (Step 3's role as an urgent-item source consumed by Step 5's model-level, not string-matched, extraction) stays conceptually backwards-compatible.
- Because two of the four explicit High conditions are independently met (`>5 dependent callers`; `shared infra … affects multiple workflows`), this is scored High on the honest reading of the heuristic, notwithstanding the mitigating symlink-propagation mechanics.
- Mitigation: the extensive fixture-based testing already performed is real and verified (see Dimension 7), but none of it exercises the byte-identical final form embedded in `prime.md` against a live sample of the 12 "increase" project logs — do that once before commit, in addition to the fixtures.

### Dimension 4: Reversibility
**Risk:** Low

- Single canonical-file edit (`ai-resources/.claude/commands/prime.md`). `git revert` on this one file restores all 25 symlinked consumers atomically and instantly — no per-consumer cleanup, since they are filesystem symlinks, not copies.
- No `settings.json` changes, no external writes (git push is separately gated per workspace convention, not part of this change).
- The planned `improvement-log.md` entry (filing the 13-project schema gap per the OP-12 discussion below) is a separate, independently-reversible additive log entry — its presence or absence does not depend on whether the code edit itself is reverted, and is not itself a source of reversibility risk.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **New output-format contract, Step 3 → Step 5.** The `UNRESOLVED HIGH: N of M entries` / indented-row / suppression-line format is a new contract, but it is documented at the change site (same file, same command) and consumed only by the same command's own Step 5, which extracts items via model-level reading rather than machine string-matching — self-contained, mild.
- **Functional overlap with `/resolve-improvement-log`'s documented three-tier resolution system — a genuine, currently-dormant divergence.** `improvement-log.md`'s own schema block (read directly, lines 1–19) documents three tiers for what counts as "resolved" (tier 1: `applied` + `Verified:`; tier 2: `resolved`/`RESOLVED` + date; tier 3, added 2026-07-18: `Status` begins `applied` + a date within ~40 chars). `scan3-v3.py`'s `classify_status()` reimplements its own, looser heuristic: any status beginning `applied` — **with no date requirement at all** — is bucketed `resolved` and suppressed from the menu. Checked directly against the live log: the two entries currently starting `applied` (`:1253`, `:1266`) both carry a date within 40 chars, so **no live divergence exists today** — but a future entry with `Status: applied` and no date would be silently suppressed by `scan3-v3.py` while `/resolve-improvement-log` would not yet consider it archival-resolved. This is exactly the "two systems handling the same concern with different criteria" pattern the Hidden Coupling dimension is designed to catch, and it is untested by any of the four supplied fixtures (none covers a bare `applied` status with no date).
- `SCHEMA_THRESHOLD = 0.5` is an implicit dependency on an assumed bimodal population (100% or 0% classified); the caller self-flagged this as risk (d) and it is not currently exercised at a mid-range value.

### Dimension 6: Principle Alignment
**Risk:** Medium

Grounded in `projects/strategic-os/ai-strategy/principles-base.md` (read directly; the frozen-ID index referenced by these instructions).

- **OP-12 (closure before detection) — real tension, not yet closed at gate time.** The new design surfaces, for the first time, a per-log "no Severity schema" signal across 12–13 previously-silent project logs — this is new detection. The System Owner consult (§3, read directly) concludes this is compliant with OP-12 *only if* the schema gap is filed as an `improvement-log.md` entry (with a `Severity` field) and routed to `/friday-act` "in this session, alongside the emit fix." **Direct re-derivation: no such entry exists yet.** `grep -n "schema gap\|13 project\|unschema\|13 of 18" logs/improvement-log.md logs/friction-log.md` returns no new entry on this finding. The session's own checkpoint scratchpad (`logs/scratchpads/2026-07-19-11-30-scratchpad.md`, read directly) lists "file the 13-project schema gap to `/friday-act` **this session**" under `## Resume With` — i.e. as the *next planned step after* a risk-check GO, not yet executed. The change description's phrasing ("filed to /friday-act this session, not fixed here") reads as a completed action; it is not yet completed. This is a sequencing gap, not a silent drift — the requirement is loudly named in two places (SO consult, scratchpad) and explicitly queued before commit — so it is scored Medium (tension, acknowledged and sequenced) rather than High (unacknowledged violation).
- **OP-11 (loud revision, never silent drift) — correctly followed.** The change rewrites `prime.md:220` rather than deleting it, explicitly preserving the count-not-content reasoning for the unschema'd population while retiring only its stale "30 of 87" evidence — this is the textbook-correct application of OP-11, not a violation.
- **OP-9/AP-7/DR-7 (speculative abstraction) — not triggered.** This is a fix to an actively-firing, universally-invoked scan (25 live consumers today), not a build for an absent future consumer. No new command/agent/gate is created; this is a same-step internal substitution, so the DR-9/creation complexity-budget gate does not apply.
- **OP-10 (system boundary)** — not touched; no cross-tool coordination involved.

### Dimension 7: Problem Reality
**Risk:** Low

- **Defect 1 — token bloat. Observed, not inferred.** Ran the exact current scan directly: `grep -nE -B6 "^-? ?\*\*Severity:\*\* *(high|HIGH|medium-high|critical|urgent)" logs/improvement-log.md` → 247 lines / 56,508 chars, matching the change description exactly. Ran `scan3-v3.py` against the same file → 26 lines / 3,330 chars, also matching exactly.
- **Defect 2 — bolded-severity invisibility bug at `:765`/`:1140`. Observed and traced.** Read both lines directly: both read `- **Severity:** **high** — …`, genuine HIGH entries. Grepped the actual old-scan output file for `^765:` and `^1140:` → zero hits in both cases, confirming these two lines are genuinely absent from the current tool's output — the consequence is traced to the instrument, not assumed.
- **Defect 3 — pre-existing unguarded `open()` at `prime.md:210`. Observed and reproduced by execution, closing a gap the System Owner consult explicitly flagged `[CITATION NEEDED]` on.** Read `prime.md:208–213` directly: the existing inline `python3 -c` block calls `open('logs/improvement-log.md', ...)` with no `try`/`except` and no existence check. Reproduced the failure directly: ran the identical code with `cwd=ai-resources/harness` (one of the 9 real, confirmed-missing-log consumer directories) → `FileNotFoundError`, uncaught, exit 1. This traces the consequence by execution, not merely by reading the code.
- **Re-derivation vs. the change description — three discrepancies found, none load-bearing against the core defect claims:**
  1. **"18 of 28 consumer directories have `logs/improvement-log.md`"** — re-derivation finds **19**, not 18 (direct `[ -f ]` walk across all 28 paths, listed explicitly in this session's work). The change description's own follow-on breakdown ("6 decrease, 1 unchanged, 12 increase") sums to 19, not 18 — an internal inconsistency in the input itself. My re-derivation wins per this gate's standing rule; the correct figure is 19/28, and the 464→92 aggregate (re-derived below) is consistent with 19, not 18.
  2. **The workspace-wide effect claim reproduces almost exactly.** Ran both the old grep and `scan3-v3.py` against all 19 real project `improvement-log.md` files found by direct `[ -f ]` walk: OLD total = **464 lines**, NEW total = **92 lines** — exact match to the change description. Per-log direction: 6 decrease, 1 unchanged, 12 increase — exact match. (Two individual logs differ by 1 line from the caller's per-log figures — 149→21 vs. claimed 149→22, and 47→12 vs. claimed 47→13 — immaterial, consistent with a trailing-newline `wc -l` counting difference.)
  3. **A claim in a *referenced input* (not the change description itself) was tested and found false, in the change's favor.** The System Owner consult lists "one entry carries two live Severity lines" as a must-fix-before-landing blocker (112 Severity-line count vs. 111 entry headers). Direct re-derivation (a full entry-span/orphan analysis, executed against the live file): **no entry has two Severity lines — all 111 entries have exactly one.** The 112th line is the schema-declaration block at line 13, entirely outside every entry span (confirmed: entry headers start at line 21), and its value ("`low` | `medium` | ... `critical`, or `none` for...") does not normalize to any HIGH tier, so `scan3-v3.py`'s existing orphan scan already and correctly ignores it — exactly as the change description independently claims ("PROVEN SILENT on the canonical log"). This is a case where an expert-authored input's own claim did not survive re-derivation; it removes a stated blocker rather than adding one.
- **zsh heredoc risk (b) — partially closed by this gate.** The change description explicitly flags this as untested: "I have NOT yet executed the final heredoc-wrapped form inside prime.md — only the standalone .py file." Executed directly: wrapped a regex containing a literal `$` end-anchor (`re.compile(r'high$')`) inside a `python3 <<'PY' … PY` heredoc via the Bash tool (confirmed running under `/bin/zsh`) — the `$` survived unexpanded and the regex matched correctly; separately ran the actual entry-parsing logic inside the same heredoc form against the live 111-entry log and got the correct count. This closes the *general mechanism* risk; the caller's own residual gap (the literal final text embedded in `prime.md`, byte-for-byte) remains open until landing, and is folded into the Dimension 3 mitigation above.
- **Consequence — traced, not assumed, on all three defects.** None of the three core defect claims rest on an inferred-but-unverified consequence; each was independently reproduced by direct execution in this gate.
- **Not defect-justified items:** none — every material claim in this change description is a defect-repair claim, and all were checked.

## Recommended redesign

- **Close the Dimension 1 gap before re-submitting:** strip `scan3-v3.py`'s docstring and non-essential comments to a lean functional core before it is embedded as the `prime.md` Step 3 heredoc, and measure the *static* Step-3 section size delta directly (old block vs. new block, in `prime.md` itself) alongside the runtime-output delta already measured. Re-run the per-project total (static + dynamic) across all 19 live `improvement-log.md` files — not just the 6 large ones — and confirm the net direction is a decrease in all 19, not just the populated logs, before treating "94% reduction" as the whole picture.
- **Close the Dimension 3 verification gap and the Dimension 6 sequencing gap in the same pass:** execute the byte-identical final heredoc form (not the standalone `.py`) inside `prime.md` against a live sample of at least 2–3 of the 12 "increase" project logs (not only the synthetic fixtures), and confirm the OP-12 closure channel — the `improvement-log.md` entry documenting the 13-project schema gap, carrying its own `Severity` field, routed to `/friday-act` — has actually landed (not merely planned in the scratchpad) before commit. Once both are done, re-run `/risk-check` on the updated design; Dimensions 2, 4, 5, and 7 are not expected to change materially, and Dimension 6 should clear to Low once the closure entry is confirmed on disk.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures. Every count, path, and testing claim in the change description was independently re-executed against the live filesystem in this session (not inherited); three discrepancies were found and are recorded above, none of which weakens the core defect-reality findings.
