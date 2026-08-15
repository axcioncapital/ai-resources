---
description: RETIRED 2026-08-15. Repository incident diagnosis and bounded repair now belong to the Codex $diagnose-and-fix skill.
disable-model-invocation: true
---

# Retired: /resolve-incident

This command's separate incident-repair workflow was retired on 2026-08-15. It
remains as a small compatibility target because existing projects symlink this
canonical path.

Use Codex and invoke `$diagnose-and-fix` with the observed repository
failure. That skill owns evidence capture, executable reproduction, diagnosis,
bounded repair, and proof in one flow. Do not recreate the former
`/resolve-repo-problem` -> `/resolve-incident` split.
