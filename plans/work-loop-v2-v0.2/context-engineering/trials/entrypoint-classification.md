# S8a — Entrypoint classification

**Session:** S8a, per `../context-engineering-implementation-plan-v0.1.md` § 7, Phase 3.
**Date of scan:** 2026-08-04. **Lead:** Claude. **Observer:** the operator (confirmation still owed — see § 6).
**Status:** provisional. The operator has not yet re-run the row commands or confirmed the O-3 reading.

**O-3 reading applied: A — "the v0.2 entry protocol only."** Carried into this session by the task-state
file `logs/work-loop/context-engineering-s8a-entrypoint-classification.md`, which records the operator's
decision as governing. Under reading A only v0.2-generation paths are in the relevance population. Work
Loop v1 paths are **preserved visibly below as outside that population** — not deleted — so the narrower
claim this reading produces is explicit rather than implied.

> **The order is load-bearing.** O-3 was applied first to set the population; the relevance test then ran
> inside it. A path the reading includes cannot be classified out by the test.

**The relevance test, one condition:** a path in the population is **relevant** if plan-dependent briefing
or continuation actually happens through it.

**Two facts recorded per path decide *how* it would be wired, never *whether* it is relevant:** whether a
Codex skill is discoverable from it, and which state directory it uses.

---

## 1. The scan

Two roots, exactly as the brief scoped them. Both commands run 2026-08-04.

```
find -L "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources" \
  \( -name 'work-loop-v2.md' -o -name 'work-loop.md' \
     -o -path '*/work-loop-v2/SKILL.md' -o -path '*/work-loop/SKILL.md' \) \
  -type f -print
```

```
find -L "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects" \
  \( -name 'work-loop-v2.md' -o -name 'work-loop.md' \
     -o -path '*/work-loop-v2/SKILL.md' -o -path '*/work-loop/SKILL.md' \) \
  -type f -print
```

**Searched surface:** the two roots in full, recursively, following symlinks (`-L`). No pruning: `.git`,
`node_modules` and every dotted directory were traversed. **Filename patterns:** the five artifacts plan
§4.2 names — the v2 Claude command (`work-loop-v2.md`), the v2 Codex skill
(`*/work-loop-v2/SKILL.md`), the v1 Claude command and the v1 contract (both `work-loop.md`), and the v1
Codex skill (`*/work-loop/SKILL.md`).

**Exit status:** 0 for both. **Diagnostic output:** none. Neither run emitted a symlink-cycle warning, a
permission error, or any other message on stderr.

**Raw output — root 1 (`ai-resources`), 5 paths:**

```
/…/ai-resources/docs/work-loop.md
/…/ai-resources/.claude/commands/work-loop-v2.md
/…/ai-resources/.claude/commands/work-loop.md
/…/ai-resources/.agents/skills/work-loop/SKILL.md
/…/ai-resources/.agents/skills/work-loop-v2/SKILL.md
```

**Raw output — root 2 (`projects`), 9 paths:**

```
/…/projects/global-macro-analysis/.claude/commands/work-loop.md
/…/projects/axcion-design-studio/.claude/commands/work-loop-v2.md
/…/projects/axcion-design-studio/.claude/commands/work-loop.md
/…/projects/axcion-systems-builder/.claude/commands/work-loop-v2.md
/…/projects/axcion-systems-builder/.claude/commands/work-loop.md
/…/projects/axcion-crm/.claude/commands/work-loop.md
/…/projects/axcion-systems-builder-email-os/.claude/commands/work-loop.md
/…/projects/axcion-systems-builder-email-os/.claude/commands/work-loop-v2.md
/…/projects/axcion-systems-builder/.agents/skills/work-loop-v2/SKILL.md
```

### Count reconciliation

| | Count |
|---|---|
| Scan results, root 1 | 5 |
| Scan results, root 2 | 9 |
| **Scan results, total** | **14** |
| **Classification rows below** | **14** |
| **Reconciles** | **Yes — equal** |

No path appears twice in the scan output, and no row below lacks a scan result.

### File identity behind the 14 paths

The 14 access paths reach **five** canonical files. Verified by resolved inode, not by filename:

```
for p in <the 14 paths>; do stat -Lf '%i' "$p"; [ -L "$p" ] && readlink "$p"; done
```

| Canonical file | Inode | Access paths |
|---|---|---|
| `ai-resources/.claude/commands/work-loop-v2.md` (115 lines) | 15040234 | 4 |
| `ai-resources/.agents/skills/work-loop-v2/SKILL.md` (160 lines) | 15040219 | 2 |
| `ai-resources/.claude/commands/work-loop.md` (251 lines) | 14230662 | 6 |
| `ai-resources/.agents/skills/work-loop/SKILL.md` (119 lines) | 13541224 | 1 |
| `ai-resources/docs/work-loop.md` (260 lines) | 14232954 | 1 |

This confirms plan §4.2's "one command file and one skill file, not three copies" and extends it: there is
**no duplicated content anywhere in either root.** Every project path is a symlink — either the file
itself, or a directory above it.

### Change against the plan's 2026-08-02 inventory

Plan §4.2 recorded **three** access paths to the v2 Claude command. The fresh scan finds **four**. The new
one is `projects/axcion-systems-builder-email-os/.claude/commands/work-loop-v2.md`, a project that did not
exist in the earlier inventory. This is recorded as a fact about the surface; it changes no verdict, since
the path classifies the same way as the other reachable-but-unequipped path.

---

## 2. In-population rows — reading A (v0.2 generation)

Six paths. Every one is **relevant**.

### Row 1 — `ai-resources/.claude/commands/work-loop-v2.md`

- **Reading applied:** A. **In population:** yes — v0.2 Claude entrypoint.
- **Access shape:** the canonical file itself (not a symlink).
- **Plan-dependent briefing or continuation through it?** **Yes — continuation, observed.** This
  classification session is itself an instance: the command was invoked here, read the executable core,
  checked the approved plan's claims, and continued the unit the plan sequences. `logs/work-loop/` holds
  19 state files. The command's own text binds it to the plan-dependent contract at line 11 — *"Read
  `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` before anything else, every invocation."*
- **Codex skill discoverable:** yes — `.agents/skills/work-loop-v2/SKILL.md` present.
- **State directory:** `logs/work-loop/` (19 files).
- **Verdict: RELEVANT** — by observed continuation.
- **Command:** `ls -1 "…/ai-resources/logs/work-loop/" | wc -l` → 19; `command grep -n 'executable-core' "…/ai-resources/.claude/commands/work-loop-v2.md"` → line 11.

### Row 2 — `projects/axcion-systems-builder/.claude/commands/work-loop-v2.md`

- **Reading applied:** A. **In population:** yes.
- **Access shape:** file symlink → `../../../../ai-resources/.claude/commands/work-loop-v2.md` (inode 15040234).
- **Plan-dependent briefing or continuation through it?** **Yes — continuation, observed.** The project
  holds three v2 state files (`crm-derived-answer-authority.md`, `decision-entry-referenceability.md`,
  `review-packet-preservation.md`), each with valid `task:`/`turn:` frontmatter, so v2 units have actually
  been opened and carried here. The executable core resolves from this root (inode 15029379, identical to
  the canonical), so the command's first mandatory read succeeds.
- **Codex skill discoverable:** yes — via the symlinked directory `.agents/skills/work-loop-v2`.
- **State directory:** `logs/work-loop/` (3 files).
- **Verdict: RELEVANT** — by observed continuation.
- **Command:** `grep -H '^task:\|^turn:' "…/projects/axcion-systems-builder/logs/work-loop/"*.md` → three tasks, all `turn: operator`.

### Row 3 — `projects/axcion-design-studio/.claude/commands/work-loop-v2.md`

- **Reading applied:** A. **In population:** yes.
- **Access shape:** reached through a **symlinked `commands/` directory** —
  `.claude/commands` → `../../../ai-resources/.claude/commands`. The file itself is not a symlink; it is
  the canonical inode 15040234 seen through a linked parent.
- **Plan-dependent briefing or continuation through it?** **Not observed, and not settled.** Three
  absences, each searched and named: `logs/work-loop/` is absent (so no v2 state file has ever existed
  here); `.agents/` is absent entirely (so no Codex skill is reachable); and
  `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` does not resolve from this root, so the
  command's first mandatory instruction would fail. But the command **is** invocable here, and two of
  those three absences are precisely the grounds Session S8a forbids classifying on: *"Do not classify a
  reading-A path out because it lacks a Codex skill or uses a different state directory."* The third is
  the same shape — a fact about this project's local surfaces, not about the path's behaviour.
- **Codex skill discoverable:** **no** — `.agents/` absent. *(Wiring shape, not relevance.)*
- **State directory:** **none** — neither `logs/work-loop/` nor `logs/loop/`. *(Wiring shape, not relevance.)*
- **Verdict: RELEVANT — by the plan's fail-safe.** Relevance cannot be settled by inspection here, and
  Session S8a's Stop clause directs the ambiguous case to *relevant*, explicitly warning against resolving
  it toward "not relevant" because that is the reading that lets work continue.
- **Command:** `readlink "…/projects/axcion-design-studio/.claude/commands"` → `../../../ai-resources/.claude/commands`; `ls -d "…/projects/axcion-design-studio/.agents" "…/projects/axcion-design-studio/logs/work-loop"` → both `No such file or directory`.

### Row 4 — `projects/axcion-systems-builder-email-os/.claude/commands/work-loop-v2.md`

- **Reading applied:** A. **In population:** yes.
- **Access shape:** file symlink → `../../../../ai-resources/.claude/commands/work-loop-v2.md` (inode 15040234).
- **Plan-dependent briefing or continuation through it?** **Not observed, and not settled** — the same
  shape as Row 3. `logs/work-loop/` is absent, `.agents/` is absent, and the executable core does not
  resolve from this root. This project does carry `logs/loop/` with two v1 artifacts
  (`2026-07-30-writing-studio-phase9-mvp.brief.md`, `.evidence.md`), which shows plan-dependent loop work
  happens in the project — but through **v1**, which reading A places outside the population.
- **Codex skill discoverable:** **no** — `.agents/` absent. *(Wiring shape, not relevance.)*
- **State directory:** **none for v2**; `logs/loop/` present (2 files) for v1. *(Wiring shape, not relevance.)*
- **Verdict: RELEVANT — by the plan's fail-safe.** Same reasoning as Row 3.
- **Command:** `ls -d "…/projects/axcion-systems-builder-email-os/.agents" "…/projects/axcion-systems-builder-email-os/logs/work-loop"` → both absent; `ls -1 "…/projects/axcion-systems-builder-email-os/logs/loop/"` → 2 files.

### Row 5 — `ai-resources/.agents/skills/work-loop-v2/SKILL.md`

- **Reading applied:** A. **In population:** yes — v0.2 Codex entrypoint.
- **Access shape:** the canonical file itself (not a symlink).
- **Plan-dependent briefing or continuation through it?** **Yes — briefing, observed, at both sites.** The
  brief in this session's own state file was prepared through it. The skill's text carries the
  plan-dependent duties explicitly: line 71 — *"Treat plan approval as bound to identifiable content,
  never vaguely to a filename"*; line 81 — *"proportionately re-establish … the governing plan, applicable
  approved workflows, authoritative current state"*; line 85 — *"Say how this unit is justified against the
  approved plan."* Both of plan §4.2's sites (opening a unit and writing the brief; assessing and
  continuing) are live here.
- **Codex skill discoverable:** yes — this **is** the skill.
- **State directory:** `logs/work-loop/` (19 files).
- **Verdict: RELEVANT** — by observed briefing.
- **Command:** `command grep -n 'approved plan' "…/ai-resources/.agents/skills/work-loop-v2/SKILL.md"` → lines 71, 81, 85 among others.

### Row 6 — `projects/axcion-systems-builder/.agents/skills/work-loop-v2/SKILL.md`

- **Reading applied:** A. **In population:** yes.
- **Access shape:** reached through a **symlinked skill directory** —
  `.agents/skills/work-loop-v2` → `../../../../ai-resources/.agents/skills/work-loop-v2`. The file is the
  canonical inode 15040219. `.agents/` and `.agents/skills/` are real directories; only the skill folder
  is linked.
- **Plan-dependent briefing or continuation through it?** **Yes — briefing, observed.** The three v2 state
  files in this project each carry a Codex-written brief, which is the output of this site.
- **Codex skill discoverable:** yes — this is the skill, reachable from the project root.
- **State directory:** `logs/work-loop/` (3 files).
- **Verdict: RELEVANT** — by observed briefing.
- **Command:** `readlink "…/projects/axcion-systems-builder/.agents/skills/work-loop-v2"` → `../../../../ai-resources/.agents/skills/work-loop-v2`.

---

## 3. Out-of-population rows — Work Loop v1

Eight paths. Under reading A these carry **no relevance verdict**: the reading places them outside the
population before the test runs. They are preserved here in full so the narrowing reading A performs is
visible rather than silent.

**These rows were not inspected as a pretext to decide wiring, retirement, or O-3 again.** Each records
only what the scan and a `readlink`/`stat` returned.

| # | Access path | Artifact | Access shape | Disposition |
|---|---|---|---|---|
| 7 | `ai-resources/.claude/commands/work-loop.md` | v1 Claude command (251 lines, inode 14230662) | canonical file | Outside reading A's population |
| 8 | `projects/global-macro-analysis/.claude/commands/work-loop.md` | v1 Claude command | file symlink → `../../../../ai-resources/.claude/commands/work-loop.md` | Outside reading A's population |
| 9 | `projects/axcion-design-studio/.claude/commands/work-loop.md` | v1 Claude command | via symlinked `commands/` directory | Outside reading A's population |
| 10 | `projects/axcion-systems-builder/.claude/commands/work-loop.md` | v1 Claude command | file symlink → `../../../../ai-resources/.claude/commands/work-loop.md` | Outside reading A's population |
| 11 | `projects/axcion-crm/.claude/commands/work-loop.md` | v1 Claude command | file symlink, **absolute** → `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/work-loop.md` | Outside reading A's population |
| 12 | `projects/axcion-systems-builder-email-os/.claude/commands/work-loop.md` | v1 Claude command | file symlink → `../../../../ai-resources/.claude/commands/work-loop.md` | Outside reading A's population |
| 13 | `ai-resources/.agents/skills/work-loop/SKILL.md` | v1 Codex skill (119 lines, inode 13541224) | canonical file | Outside reading A's population |
| 14 | `ai-resources/docs/work-loop.md` | v1 shared contract (260 lines, inode 14232954) | canonical file | Outside reading A's population |

**What reading A narrows away, stated plainly.** Six of these eight paths reach a live v1 command that
**authors its own plan-dependent brief** — `work-loop.md:41`, *"compose the brief yourself in the
contract's `BRIEF` shape"* — and v1 has its own Codex skill and its own state directory, `logs/loop/`,
which holds 10 artifacts in `ai-resources`, 3 in `axcion-systems-builder` and 2 in
`axcion-systems-builder-email-os`. Under reading B every one of these would enter the population and, by
plan §4.2, classify relevant. Under reading A they do not, and plan-dependent work can continue to flow
through them without Context Engineering. **That is the gap CE-17 exists to close, and reading A leaves it
open by design.** Plan §6 requires this narrowing to be written into the adoption record rather than left
implied; this paragraph is that record's source.

---

## 4. Exit condition

Session S8a's exit: *every access path carries a verdict backed by an observed condition and a named O-3
reading.*

| Requirement | Status |
|---|---|
| Every scanned access path has exactly one row | **Met** — 14 scanned, 14 rows, no duplicates |
| Every in-population path has an evidence-backed verdict | **Met** — 6 of 6 relevant; 4 by observed evidence, 2 by the plan's fail-safe |
| Every v1 path visibly outside reading A's population | **Met** — 8 rows preserved in § 3 with dispositions |
| Counts reconcile | **Met** — 14 = 14, stated in § 1 |
| Operator confirmation recorded | **NOT MET** — owed; see § 6 |

**The unit is therefore provisional, not complete.**

## 5. Limitations

1. **Scan surface is exactly the two roots the brief named** — `ai-resources` and `projects`. As a bounded
   check against a silent gap, `find -L "$HOME/.claude" -maxdepth 3` was run with the same four patterns
   and returned **no matches** (exit 0), so no user-level access path exists today. That check is recorded
   as an observation, not as a row, because it lies outside the briefed surface.
2. **Rows 3 and 4 rest on the fail-safe, not on positive evidence.** Both are reachable-but-unequipped
   paths. If the operator reads the S8a test as settled-by-inspection in these two cases, the verdicts
   flip to *not relevant* and S8b's wiring scope shrinks accordingly. This is flagged rather than resolved
   because the plan's stated direction and its stated prohibition both point at *relevant*.
3. **No behaviour was executed through any path.** Every verdict rests on repository state — state files,
   symlink targets, resolved inodes, artifact text. Whether an invocation through Rows 3 or 4 actually
   fails at the core read was reasoned from the absent file, not observed by running it.
4. **Phase 2's exit condition remains unmet** (the S7 grouped-regression run was declined). This session
   proceeds under the operator's explicit, recorded deviation. It creates no missing evidence and supports
   no adoption claim.

## 6. Operator observation — owed

Per plan § 7, Phase 3, S8a, the operator is this session's observer. Two confirmations are needed before
the unit can be called complete:

1. **Re-run the two `find -L` commands in § 1** and confirm the output matches the 14 paths recorded, and
   that both exit 0 with no stderr.
2. **Confirm reading A is the reading you chose** — "the v0.2 entry protocol only", with the consequence
   § 3 states: v1 stays outside the boundary, and adoption's claim is correspondingly narrower.

Spot-checking any row's command in § 2 is welcome but not required; the two above are what the plan asks
of the observer.

---

*Produced by `/work-loop-v2`, task `context-engineering-s8a-entrypoint-classification`, 2026-08-04. This
record classifies entrypoints. It wires nothing, decides no retirement, does not reopen O-3, and makes no
adoption claim.*
