# File Write Discipline

> **When to read this file:** Before writing or editing files in a working directory — to confirm what counts as input (read-only) vs. output (write/edit allowed) and how operator-pasted content is handled. Workspace CLAUDE.md keeps the bright-line ("Input files are read-only — use `Read`"); this file enumerates the four operative rules.

Input files (context packs, reference documents, source data, prior artifacts the operator drops into the working directory) are read-only references. Outputs (artifacts your command is designed to produce) are written normally via `Write` into `output/{project}/`.

Iteration produces `v2.md` alongside `v1.md` in the same `output/{project}/` directory; v1 is retained.

- **Default to Read for inputs.** When pointed at an input file, use `Read` against that path. Never invoke `Write`, `Edit`, `MultiEdit`, or shell file-creation commands against a file whose content originated outside the current session.
- **Do not materialize chat content.** If an input's content enters the conversation (pasted, quoted, or summarized), the file on disk remains the source of truth.
- **Operator-pasted content — save verbatim.** When the operator pastes file content and asks you to save it, use `Write` to save exactly as provided. No reformatting, no truncation, no restructuring. If no target path is given, ask before writing. Flag before writing if: target path exists and would be overwritten; content appears incomplete; content conflicts with an approved artifact. Confirm the write by stating target path and line count — do not describe the content.
- **Exception — legitimate copying.** Copy an input only when the operator explicitly asks for an archival snapshot, or a downstream tool requires the file at a specific path. In both cases, record the absolute source path in the copy's frontmatter and state in your turn-summary that you copied rather than referenced.
