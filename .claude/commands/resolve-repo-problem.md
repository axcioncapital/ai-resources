---
description: RETIRED 2026-08-15. Repository-problem triage and repair now belong to the Codex $resolve-repository-problem skill.
disable-model-invocation: true
---

# Retired: /resolve-repo-problem

This command's triage-only workflow was retired on 2026-08-15. It remains as a
small compatibility target because existing projects symlink this canonical
path.

Use Codex and invoke `$resolve-repository-problem` with the observed repository
failure. That skill owns evidence capture, executable reproduction, diagnosis,
bounded repair, and proof in one flow. Do not recreate the former
`/resolve-repo-problem` -> `/resolve-incident` split.
