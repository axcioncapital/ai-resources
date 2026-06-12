# Risk Check — 2026-06-12

## Change

Apply 3 settings.json permission fixes from audits/friday-plans/2026-06-12-permissions.md, all same change class (permission-surface / settings.json):
(1) [high] fix the stale /Users/danielniklander/... additionalDirectories path in projects/interpersonal-communication/knowledge-base/.claude/settings.json — replace with the correct portable/machine path so ai-resources symlinks resolve;
(2) [med] add defaultMode: bypassPermissions + additionalDirectories to knowledge-bases/strategic-os/.claude/settings.json and knowledge-bases/marketing-communication/.claude/settings.json so KB sessions stop firing permission prompts and resolve ai-resources symlinks;
(3) [med] resolve the deny glob 0[1-8]_*.md in projects/axcion-brand-book/.claude/settings.json that silently shadows explicit allow entries for 02_color.md / 03_typography.md (narrow the deny glob to exclude the allowed files).
Each edits a separate KB/project settings.json in its own git repo; committed separately; push gated to wrap.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/interpersonal-communication/knowledge-base/.claude/settings.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/knowledge-bases/strategic-os/.claude/settings.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/knowledge-bases/marketing-communication/.claude/settings.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-brand-book/.claude/settings.json — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Three low-coupling settings.json edits that move each file *toward* the canonical permission template, but two carry template-conformance traps (item 1 reintroduces a tracked machine-specific path the template says belongs in `settings.local.json` Layer D′; item 3 risks under-narrowing the deny glob) that warrant paired mitigations before landing.

## Consumer Inventory

Search terms: the four basenames (`settings.json` per directory), the stale literal `/Users/danielniklander/...`, the keys `additionalDirectories` / `defaultMode`, the deny glob `0[1-8]_*.md`, and the brand-book filenames `02_color.md` / `03_typography.md`.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `ai-resources/.claude/hooks/check-permission-sanity.sh` | parses (reads `.permissions.defaultMode` and `.permissions.deny` of each project's `settings.json` via `jq` at SessionStart) | no |
| `ai-resources/docs/permission-template.md` | documents (canonical shapes + Detection rulebook governing all four files) | no |
| `ai-resources/.claude/commands/permission-sweep.md` (via the template it consumes) | parses/documents (re-runs `--dry-run` to confirm clean per the plan's Execution notes) | no |
| `projects/axcion-brand-book/.claude/settings.json` SessionStart hooks (self) | parses (the same file's `auto-sync-shared.sh` upward-walk consumes `additionalDirectories` to reach ai-resources) | no |
| brand-book content files `02_color.md` / `03_typography.md` | co-edits (the allow entries that the deny glob currently shadows; behavior target of item 3) | no |

Total: 5 consumers, 0 must-change. No external consumer references the stale `/Users/danielniklander/...` literal anywhere in the repo (grep: 1 hit, the target file line 24 itself). The brand-book filenames `02_color.md` / `03_typography.md` appear in no other file (grep: 0 hits outside the settings.json). The blast radius is confined to the four edited files plus the SessionStart sanity hook that *reads* them but is not modified.

Note: the KB command directories (`.claude/commands/kb-integrity.md`, `kb-query.md`) are real files, not top-level symlinks into ai-resources; `additionalDirectories` matters because it grants the KB session reach into the shared `ai-resources/skills/` and `ai-resources/.claude/` symlink targets per Layer D′ — i.e., the consumer of the grant is the running session, not a tracked reference.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No content added to any always-loaded CLAUDE.md — all four edits are to `.claude/settings.json` permission blocks, which are not token-loaded into the model context. Evidence: target files are JSON permission config, read by the harness, not `@import`-ed.
- No new hook registered. Item 2 does not wire SessionStart hooks (the two KB files have none today; the change adds only `defaultMode` + `additionalDirectories` per the description, not hook blocks). The brand-book file's two existing SessionStart hooks (lines 68–90) are untouched.
- No subagent brief or skill description expanded.

### Dimension 2: Permissions Surface
**Risk:** Medium

- Item 2 adds `defaultMode: "bypassPermissions"` to two KB `settings.json` files that currently lack it (strategic-os lines 1–20, marketing-communication lines 1–20 — both have `allow`/`deny` only, no `defaultMode`). This is a genuine widening: it flips those sessions from prompt-on-Edit/Write to silent-bypass. It is the *canonical* Layer D shape (permission-template.md lines 160–186) and `bypassPermissions` is the operator's agreed floor (MEMORY: "zero permission prompts — bypassPermissions is the floor"), so it is an established pattern — but it is still a new capability grant in those two files. Medium, not Low.
- Item 2 also adds `additionalDirectories` granting the workspace-root absolute path — extends each KB session's filesystem reach to the whole `Axcion AI Repo` tree. Established pattern (Layer D′, lines 190–212), narrow in effect (one known directory), but a real reach extension.
- Item 1 replaces an existing (broken) `additionalDirectories` path with a working one — net effect is to *restore* intended reach, not widen beyond design. The grant target is unchanged in kind (workspace root), only the literal path is corrected.
- Item 3 *narrows* a deny glob — it removes deny coverage for `02_color.md` / `03_typography.md` so the explicit allows take effect. This is a deny-relaxation (Detection rulebook Rule 7, deny-shadows-allow). It only un-shadows two files the operator already explicitly allowed (lines 29–32), so it aligns intent rather than opening new surface — but per the heuristic, narrowing a deny is a Medium-class move and must be scoped precisely (see Mitigations).

### Dimension 3: Blast Radius
**Risk:** Low

- Per the Consumer Inventory: 5 consumers, **0 must-change**. No caller requires modification to keep working.
- Direct files touched: 4, each in its own git repo (per description), committed separately — no shared-file contention.
- Contract surface: `check-permission-sanity.sh` (lines 28–63) *parses* `defaultMode` and `deny` from these files. All three edits move the files *toward* what the hook expects (item 2 adds the `defaultMode` the hook nudges for at line 51; none removes a safety-floor deny entry — `Bash(rm -rf *)` / `Bash(sudo *)` are preserved in all four). So the parse-consumer's expectations are satisfied, not broken.
- No unanticipated consumer surfaced: the stale `danielniklander` literal has zero references outside its own file; the brand-book filenames have zero references outside their settings.json.

### Dimension 4: Reversibility
**Risk:** Low

- All four edits are single-file JSON property changes. `git revert` on each separate commit fully restores the prior `permissions` block within the same working tree. No sibling files created, no log/registry mutation, no data-file append.
- Item 1 caveat: the *prior* state is a known-broken path, so a revert would restore the broken state — but that is a clean, fully-reversible operation, which is what this dimension measures.
- Push is gated to wrap (per description and workspace push rule), so state does not propagate beyond local until the operator confirms — revert is a pure local-git operation up to that point.
- One soft note (keeps this Low, not Medium): after item 2 lands, the two KB sessions silently bypass prompts; a revert restores prompting but the operator may have built muscle memory of prompt-free KB sessions. This is cosmetic, not a rollback-blocking step.

### Dimension 5: Hidden Coupling
**Risk:** Low

- No new contract introduced. All three edits conform to contracts already documented in `permission-template.md` (Layers D / D′ and the Detection rulebook).
- The one implicit dependency is on the SessionStart sanity hook reading these files — but that coupling is explicit (the hook is named in the template at lines 280–304) and the edits satisfy, not violate, its checks. Established repo convention, documented at the change site → Low.
- Item 3's `0[1-8]_*.md` glob relies on Claude Code permission-pattern character-class semantics. The fix must honor those same semantics; this is an existing convention the file already uses (lines 57–58), not a new silent dependency.
- No auto-firing in unexpected contexts: item 2 adds no hooks; the brand-book hooks are untouched.

### Dimension 6: Principle Alignment
**Risk:** Medium

Principles-base read: `projects/strategic-os/ai-strategy/principles-base.md` (available).

- **DR-1 / DR-3 (placement) — item 1 is in tension.** The change as described replaces the stale path with "the correct portable/machine path" in the **tracked** `settings.json`. But `permission-template.md` Layer D′ (lines 185, 190–220) and Detection Rule 8 (line 396) are explicit: `additionalDirectories` is a **machine-specific absolute path that belongs in the gitignored `settings.local.json`, not the tracked file**. A tracked path "is correct on the machine that deployed it but breaks on every other machine that pulls the repo" (line 185) — which is *exactly* the failure mode that produced the stale `danielniklander` entry being fixed. Writing a corrected tracked path reproduces the root cause for the next operator. The template even prescribes the remediation for a foreign-machine tracked path: treat as **ADVISORY — relocate to `settings.local.json`** (Rule 8, line 396), not "fix the literal path." Note: the interpersonal-comm KB has **no `settings.local.json`** today (confirmed: `.claude/` holds only `settings.json` + `commands/`), so the correct fix is to *create* the local file with the grant and *remove* `additionalDirectories` from the tracked file. This is a Medium tension, not a violation, because the operator can choose the template-conformant path — see Mitigations.
- **DR-1 / DR-3 — item 2 has the same latent placement issue.** Adding `additionalDirectories` to the tracked KB `settings.json` (as the description states) again writes a machine-specific path into git-tracked config. Same Layer D′ rule applies. Same Medium tension.
- **OP-5 (advisory vs enforcement) — clean.** None of the three edits moves an advisory mechanism toward enforcement. They adjust static permission scope only.
- **OP-12 (closure before detection) — clean / supportive.** No new detection added; these are closure of three already-detected findings from the Friday checkup. The change *closes* findings rather than generating new ones — counts *for* it.
- **OP-9 / AP-7 / DR-7 (speculative abstraction) — clean.** No generalization, no hooks-for-later; each edit serves a confirmed present consumer (a live KB/project session that fires prompts or fails to resolve symlinks today).
- **OP-10 (system boundary) — clean.** All four files are Claude Code settings; nothing reaches into GPT/Perplexity/Notion/NotebookLM.

The Medium is driven solely by the placement tension on items 1 and 2 (tracked vs. `settings.local.json`). No principle is *violated* — the template offers a conformant path the operator can take.

## Mitigations

- **Dimension 6 / item 1 (placement):** Do not write the corrected workspace-root path into the tracked `settings.json`. Instead, (a) remove `additionalDirectories` from `projects/interpersonal-communication/knowledge-base/.claude/settings.json`, and (b) create `projects/interpersonal-communication/knowledge-base/.claude/settings.local.json` containing `{ "permissions": { "defaultMode": "bypassPermissions", "additionalDirectories": ["/Users/patrik.lindeberg/Claude Code/Axcion AI Repo"] } }` (Layer D′ canonical shape, template lines 198–207). Confirm `settings.local.json` is gitignored at that repo root before committing. This both fixes the stale-path symptom and removes the root cause for the next operator.
- **Dimension 6 / item 2 (placement):** Apply the same split for both KB files — add `defaultMode: "bypassPermissions"` to the tracked `settings.json` (this key *is* canonical in the tracked Layer D file), but put `additionalDirectories` in a new `settings.local.json` per Layer D′, not in the tracked file. Verify each KB `.claude/` ends up with a gitignored local file carrying the grant.
- **Dimension 2 / item 3 (deny narrowing):** Narrow the deny glob precisely — replace `Write(./brand-book/0[1-8]_*.md)` / `Edit(./brand-book/0[1-8]_*.md)` with character-class ranges that exclude exactly `02` and `03` (e.g., split into `0[1]_*.md` + `0[4-8]_*.md`), so files `01`, `04`–`08` remain denied and only `02_color.md` / `03_typography.md` are un-shadowed. After the edit, confirm the two target files resolve to *allow* and the other six (`01`, `04`–`08`) still resolve to *deny*. Do not simply drop the deny lines (that would un-protect `04`–`08`).
- **All items:** Run `/permission-sweep --dry-run` across all four scopes after the edits (per the plan's Execution notes, line 32) and confirm it returns clean — in particular that Rule 7 (deny-shadows-allow) and Rule 8 (tracked `additionalDirectories`) no longer fire.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references to the four target settings.json files, `permission-template.md`, `principles-base.md`, and `check-permission-sanity.sh`; grep counts for the stale literal and the brand-book filenames; verbatim quotes from CHANGE_DESCRIPTION and the friday-plan). No training-data fallback was used.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

**Full advisory on disk:** projects/axcion-ai-system-owner/output/consultations/consult-2026-06-12-permissions-friday-act-risk-second-opinion.md

**Verdict: concur with PROCEED-WITH-CAUTION. The mitigation path is the right one.** Apply all three mitigations as drafted — they are the structurally correct moves, not workarounds.

**Routing:** Each edit lands in its own KB/project sub-repo, reconciled against `ai-resources/docs/permission-template.md` (the single source of truth). No canonical command/agent/hook is touched → blast radius correctly Low (`risk-topology.md § 5`). Correctly gated as a permission change (`DR-8`, `DR-9`); verdict is binding and we do not downgrade it.

**Per item:**
- **Item 1 (stale danielniklander path):** patching the tracked path re-arms the root cause. `additionalDirectories` is machine-specific → Layer D′ gitignored `settings.local.json`, never tracked config. Relocation is the structural fix; path-correction is a patch (`permission-template.md § Layer D/D′`; Detection Rule 8).
- **Item 2:** `defaultMode: bypassPermissions` is canonical and correct (root cause #1/#3). The grant carries the same Layer D′ rule → relocate, don't track.
- **Item 3:** deny-shadows-allow (Rule 7). Precise narrowing to exclude only 02/03, keep 04–08 denied — correct. The under-narrowing trap is real.

**Three risks the dimension review missed:**
1. **[most material]** Relocation creates per-machine recovery debt — the grant now lives only on this machine; every other machine must paste the Layer D′ snippet once or symlinks break. Ship with a one-line recovery note. Reversibility-Low understates this standing obligation. (`permission-template.md § Layer D′` Migration note; interpersonal-comm KB already flagged multi-state in `repo-state.md § 1`.)
2. **Concurrent-session collision** (`DR-10`): the sweep + cross-repo `git add` act on shared state. Confirm no concurrent session on the four sub-repos before landing; enumerate explicit paths if one is live.
3. **Item 3 needs empirical confirmation:** `--dry-run` proves the file parses, not that the literal allow-vs-deny interaction behaves. Add one concrete check — an un-shadowed file (02/03) edits, a still-denied file (04–08) blocks.

None of the three block. All cheap. Add them, then land — separate commits per repo, push gated to wrap.
