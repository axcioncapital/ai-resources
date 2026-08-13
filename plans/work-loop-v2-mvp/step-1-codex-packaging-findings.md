# Step 1 — Codex resource packaging: findings

**Playbook step:** Step 1, "Investigate Codex packaging" (`pocock-lifecycle-work-loop-mvp-v0.4.md:59–67`).
**Date:** 2026-08-01.
**Status:** complete. Four questions answered; open gaps listed in § 6.

**What this document is.** A record of what was established about the Codex side **by inspection**, and what could not be. It makes no design decisions and proposes no build. Where a fact bears on a later step, it is written as a premise for that step to test, never as a conclusion.

**How claims are sourced.** Every claim carries its evidence. Two investigators produced it:

- **[local]** — established in this Claude Code session by reading files and running commands on this machine.
- **[codex]** — established by Codex inspecting its own runtime, in a session run inside this repository on 2026-08-01. Its answers were re-checked here where checkable; § 7 lists the three citations that were wrong and the one claim that was incomplete.

A term used throughout: **"skill"** is Codex's own word for a packaged resource — a folder with a `SKILL.md` file in it. It is the Codex-side equivalent of what this repo calls a command or a skill.

---

## 1. How a Codex-side resource is installed

**There are two places a skill can live, and only one of them matters for this build.**

**User level.** `$CODEX_HOME/skills/<skill-name>/`, which defaults to `~/.codex/skills`. Installation is a file copy; the bundled `skill-installer` fetches from GitHub and writes there, and refuses if the folder already exists. **[local]** `~/.codex/skills/.system/skill-installer/SKILL.md`, § "Behavior and Options". Confirmed on disk: 21 skills present.

**Repository level.** `<repo>/.agents/skills/<skill-name>/`. Codex scans `.agents/skills` from the current working directory upward, through each parent, to the Git root. **[codex]** confirmed against `git rev-parse --show-toplevel` and the official skills documentation (`https://developers.openai.com/codex/skills`, accessed 2026-08-01).

**Codex can see this repository's skills right now.** Asked to name them, it returned all five: `work-loop`, `source-command-explore-section`, `source-command-friday-so`, `source-command-refresh-project-state`, `source-command-so-monthly`. **[codex]**

This is the answer that matters. A Codex-side resource does not have to be installed on a machine — it can live in the repository and be found there. Nothing needs to be copied into `~/.codex` for the repository to carry its own Codex side.

### The trap: `.agents/skills/` is gitignored

**A new skill folder placed in `.agents/skills/` is invisible to Git by default.** `.gitignore:74–77` excludes `.agents/*` and `.agents/skills/*`, and re-includes exactly one path: `!.agents/skills/work-loop/`. **[local]**

Verified: `git ls-files .agents` returns one file (`work-loop/SKILL.md`). `git check-ignore -v` confirms the other four are excluded by `.gitignore:76`, and returns nothing for `work-loop`. **[local]**

So of the five skills Codex can see, **only one is in the repository**; the other four exist on this machine alone and would not survive a fresh clone. That is deliberate, not a defect — `.gitignore:70–73` carries a comment explaining why four rules are needed rather than one negation (Git does not descend into an excluded directory, so each level must be re-included before the next is excluded). **[local]**

**Consequence for this build:** whatever Codex-side resource v2 ships, its path must be added to `.gitignore` as an explicit re-include, exactly as `work-loop/` already is. Skipping that produces a resource that works on this machine and silently does not exist for anyone else — the same class of failure already logged in this repo for unversioned hook wiring.

### `AGENTS.md` is a different mechanism

`AGENTS.md` is durable guidance loaded **before** work begins. Codex combines files from the Git root down to the working directory, and a closer file overrides a more distant one. A skill is the opposite: only its name, description and path are present up front, and its body loads only if it triggers. **[codex]**, official AGENTS.md documentation (`https://learn.chatgpt.com/docs/agent-configuration/agents-md`, accessed 2026-08-01).

`AGENTS.md` files in sibling project folders were **not** loaded in that session, because they sit outside this repository's Git root. **[codex]** Eight or more exist under `projects/`. **[local]**

---

## 2. How a Codex-side resource is invoked

**Two ways, both available.** **[codex]**, official skills documentation.

1. **Implicitly** — Codex matches the request against the skill's `description` and loads it.
2. **Explicitly** — the operator writes `$skill-name` in the prompt. In the interactive CLI, `/skills` or typing `$` opens a selector.

**One-shot, no chat window.** A skill can be named in a non-interactive run:

```sh
# Runs the work-loop skill once, read-only, against this repo. No chat session.
/Applications/ChatGPT.app/Contents/Resources/codex exec --ephemeral --sandbox read-only \
  -C "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources" \
  '$work-loop review the current uncommitted changes without modifying files'
```

**[codex]**, from `codex exec --help` and the official non-interactive-mode documentation.

**Newly added skills are detected automatically**, per the official documentation, with a restart as the stated fallback if one does not appear. Whether detection happens within the same turn or only at the next turn is **not documented**. **[codex]**

**One skill calling another is not documented.** Several skills can apply to one request, but no mechanism was found for a skill to invoke another skill programmatically. **[codex]**

### The description budget is already over its cap

Codex caps the always-present skills list at **2% of the context window, or 8,000 characters when the window size is unknown**, and may shorten or omit descriptions to fit. The current runtime carries **41 skills totalling 12,963 characters** of descriptions. **[codex]**

That is roughly 1.6× the stated fallback cap, before v2 adds anything.

**Consequence for this build:** implicit triggering — Codex noticing the work loop on its own from a description — cannot be relied on, because the description may be shortened or dropped before it is ever matched. Explicit `$name` invocation does not depend on the description surviving. This is a premise for Step 3 to design against, not a decision made here.

---

## 3. How it reads and writes repository files

This is the group the v2 transport seam depends on, so it is reported in detail.

**Working directory.** Relative paths resolved against `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources` — the directory Codex was launched in. `-C` / `--cd` overrides it. **[codex]**, from `pwd` and `codex --help`.

**Ordinary file writes: direct, unattended, no merge step.** Codex operated in the real local checkout — not a sandbox copy and not a Git worktree. It verified this with `pwd -P`, `git rev-parse --show-toplevel`, `--git-dir` and `--git-common-dir`, all resolving to the real repository and its real `.git`. Its permission profile was `workspace-write`, under which writes inside the workspace run without asking. **[codex]**

**Git writes: blocked in that session.** Both `git add --dry-run` and `git commit --dry-run` failed with:

```
Unable to create '.git/index.lock': Operation not permitted
```

No lock file was left behind. **[codex]**

**Push: not possible in that session.** Command network access was disabled — `CODEX_SANDBOX_NETWORK_DISABLED=1`. **[codex]** Separately, this repo's own `AGENTS.md:66` forbids pushing outside the wrap workflow anyway. **[local]**

**`trust_level = "trusted"` is not a permission grant.** In `~/.codex/config.toml`, nine project paths carry `trust_level = "trusted"`, including this repository (`config.toml:64`). **[local]** That setting permits Codex to load project-scoped `.codex/config.toml`, hooks and rules. It does **not** grant filesystem, network, Git or approval bypasses — those are governed separately by the sandbox and approval settings. **[codex]**, official configuration documentation.

**Neither `sandbox_mode` nor `approval_policy` is set** in `~/.codex/config.toml`; the effective profile comes from the desktop runtime. **[codex]**, and consistent with the key survey run here **[local]**.

### This contradicts a premise the Proposal's transport rests on

The Proposal's round trip is: **Codex writes a brief into a state file and commits; Claude reads it, works, writes a result and commits; Codex reads the result.** The observation above is that Codex could write repository files freely but **could not commit** them.

Stated precisely, because the difference matters:

- **Established:** in one Codex session in this repository on 2026-08-01, `.git` was write-protected and both `git add` and `git commit` failed.
- **Not established:** whether that is a fixed property of the Codex desktop runtime, a per-session profile, or something changeable by configuration or by granting an escalation. Codex listed this among its own unknowns, noting it could not test escalation without attempting a prohibited mutation.

**This is carried to Step 2 as its first premise to test, not resolved here.** Step 2 is the throwaway transport prototype, and its stated purpose is exactly to find out whether the repository round trip works cleanly. It now has a specific, falsifiable first question: *can Codex commit at all?* If it cannot, the seam still has options that do not require redesigning anything — the working tree is shared, so a state file can be exchanged without either side committing it — but choosing among them is a Proposal-level matter and is not decided in this note.

No change to the Proposal is proposed here. Per the authority order in `README.md`, the Proposal is authoritative and this note reports to it.

---

## 4. Format and size constraints

**Required shape.** A skill is a folder containing `SKILL.md`. That file needs YAML frontmatter and a Markdown body. **[local]**, `~/.codex/skills/.system/skill-creator/SKILL.md` § "Anatomy of a Skill".

**Frontmatter fields.** The local validator accepts exactly five keys and rejects any other: `name`, `description`, `license`, `allowed-tools`, `metadata`. **[local]**, `quick_validate.py:40`. `name` and `description` are required. **[local]**, `quick_validate.py:53–54`.

**Only `name` and `description` decide when a skill triggers.** The body loads only after it triggers, if at all. **[local]**, `skill-creator/SKILL.md` § "SKILL.md (required)". Runtime behaviour of `license`, `allowed-tools` and `metadata` beyond validator acceptance was not established. **[codex]**

**Hard limits, both enforced by the validator:**

| Limit | Value | Evidence |
|---|---|---|
| `description` length | ≤ 1,024 characters | `quick_validate.py:85–88` **[local]** |
| `name` length | ≤ 64 characters | `quick_validate.py:10` **[local]** |

`description` must also contain no `<` or `>`. **[local]**, `quick_validate.py:83`.

**Naming rules.** Lowercase letters, digits and single hyphens; no leading or trailing hyphen; the folder is named exactly after the skill. **[local]**, `skill-creator/SKILL.md:236–242`. The validator does not check that the folder name matches. **[codex]**

**Recommendations, not enforced:** body under 500 lines and under 5,000 words; split overflow into separate files and reference them from `SKILL.md`. **[local]**, `skill-creator/SKILL.md:140,145`.

**Optional bundled folders:** `agents/` (holds `openai.yaml`, UI metadata for skill lists), `scripts/`, `references/`, `assets/`. **[local]**, `skill-creator/SKILL.md` § "Anatomy of a Skill".

**Measured against this repo.** Description lengths of the five repo-side skills, all inside the 1,024 cap: **[local]**

| Skill | Description |
|---|---|
| `work-loop` | 705 chars |
| `source-command-refresh-project-state` | 349 |
| `source-command-so-monthly` | 262 |
| `source-command-explore-section` | 242 |
| `source-command-friday-so` | 195 |

The v1 `work-loop` description uses 69% of the cap. None of the five carries `metadata.short-description`. **[local]**

---

## 5. The command-line tool

**Two different Codex binaries are installed, and one of them does not run.** **[codex]**, from `ls -l`, `file`, `shasum -a 256` and package inspection of both paths.

| Path | Version | State |
|---|---|---|
| `/Applications/ChatGPT.app/Contents/Resources/codex` | 0.145.0-alpha.30, native ARM64 | works |
| `/usr/local/bin/codex` | 0.118.0, npm Node launcher | **blocked by macOS** |

The npm one exits 137 and raises a macOS "Malware Blocked" popup. Whether it actually contains malware was **not** established: `codesign --verify` reported invalid signatures for *both* binaries, and `spctl` returned an internal Code Signing subsystem error, so neither check isolated the cause. **[codex]**

This explains a local observation: `codex --help` run from this session produced no output at all — it resolved to the blocked `/usr/local/bin/codex`. **[local]**

**Practical consequence:** any script or instruction in this build that shells out to Codex must use the ChatGPT.app path, not the bare `codex` on `PATH`. Using `PATH` produces a silent failure with an empty result, which is the worst available failure mode.

**Subcommands** on the working binary: `exec`, `review`, `login`, `logout`, `mcp`, `plugin`, `mcp-server`, `app-server`, `remote-control`, `app`, `completion`, `update`, `doctor`, `sandbox`, `debug`, `apply`, `resume`, `archive`, `delete`, `unarchive`, `fork`, `cloud`, `exec-server`, `features`, `help`. **[codex]**

---

## 6. Open gaps

Nothing below was established. None is guessed at above.

1. **Can Codex commit at all?** Blocked in the observed session; unknown whether that is fixed policy, a session profile, or clearable by escalation. **This is Step 2's first premise to test.**
2. Whether escalation for `.git` writes, or for a push, would be granted — untestable without attempting a prohibited mutation.
3. The exact `approval_policy` behind the desktop session. Absent from `config.toml`; the runtime exposes "managed auto-review".
4. Whether a newly added skill is detected within the same turn or only at the next turn.
5. How an explicit `$name` resolves when a user-level and a repository-level skill share a name. Official docs say both appear; the tiebreak is undocumented.
6. Whether any mechanism lets one skill call another.
7. Hard size limits for the whole `SKILL.md` or the skill folder — only recommendations exist.
8. Runtime meaning of the `license`, `allowed-tools` and `metadata` frontmatter fields.
9. Whether the blocked npm binary is genuinely malicious. Unresolved; both signature checks were inconclusive.

---

## 7. Corrections applied to the Codex report

Recorded so a future reader trusts these line numbers rather than the originals. In all four cases the substance held; the pointer did not.

| Claim | Codex cited | Actually at | Note |
|---|---|---|---|
| `description` ≤ 1,024 chars | `quick_validate.py:10` | `quick_validate.py:85–88` | line 10 is `MAX_SKILL_NAME_LENGTH = 64` |
| Body < 500 lines / 5k words | `skill-creator/SKILL.md:132` | `:140` and `:145` | line 132 is about auxiliary docs |
| This repo forbids pushing | `AGENTS.md:58` | `AGENTS.md:62,66` | line 58 is a commit-message rule |
| Five repo skills are "visible in the repository" | — | — | true of Codex's *view*; only `work-loop` is tracked by Git (§ 1) |

The fourth is the one worth keeping. Codex answered the question asked — what it can see — and that answer was correct. The gap between "Codex can see it" and "it is in the repository" was invisible from its side and is the finding with the most consequence for the build.

---

## 8. What Step 2 inherits

Premises to test in the throwaway transport prototype, in order of consequence. None is a decision.

1. **Can Codex commit?** (§ 3). Everything else in the round trip is downstream of this.
2. **Does a new skill in `.agents/skills/` reach Git?** Only if `.gitignore` re-includes it explicitly (§ 1).
3. **Does explicit `$name` invocation behave reliably**, given the description budget is already over its cap (§ 2)?
4. **Does `codex exec` work as the non-interactive entry point**, using the ChatGPT.app binary path (§ 5)?
