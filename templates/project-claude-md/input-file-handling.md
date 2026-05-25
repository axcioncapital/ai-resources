## Input File Handling

Input files — context packs, reference documents, source data, prior artifacts the operator drops into the working directory — are read-only references. Use them by path, do not copy or rewrite them.

- **Default to `Read`.** When the operator points you at an input file (whether it lives in the project folder, an `inputs/` sibling, or an absolute path elsewhere on the filesystem), use the `Read` tool against that path. Never invoke `Write`, `Edit`, `MultiEdit`, or shell file-creation commands (`cp`, `cat >`, `tee`, redirection, `install`, etc.) against a file whose content originated outside the current session.
- **Do not materialize chat content.** If an input's content enters the conversation (pasted, quoted, or summarized), that does not make the chat copy canonical. The file on disk remains the source of truth.
- **Do not co-locate inputs with outputs for "provenance."** If provenance matters, record the absolute path of the input in the artifact's frontmatter or a `sources.md` file — do not duplicate the bytes.
- **Outputs are different.** Artifacts your command is *designed to produce* (plans, specs, drafts, reports) are written normally via `Write` into `output/{project}/`. This rule governs inputs only.
- **Operator-pasted content — save verbatim.** When the operator pastes file content and asks you to save it, use `Write` to save exactly as provided. No reformatting, no truncation, no restructuring. If no target path is given, ask before writing. Flag before writing if: target path exists and would be overwritten; content appears incomplete; content conflicts with an approved artifact. Confirm the write by stating target path and line count — do not describe the content.
- **Exception: legitimate copying.** Copy an input only when (a) the operator explicitly asks for an archival snapshot or reproducibility freeze, or (b) a downstream tool requires the file at a specific path and no symlink or path argument will satisfy it. In both cases, record the absolute source path in the copy's frontmatter or in a sibling `SOURCE.md`, and state in your turn-summary that you copied rather than referenced.

This rule mirrors the canonical `Input File Handling` section in the workspace-level `CLAUDE.md`. It is repeated here because projects are sometimes opened without the parent workspace context loaded.
