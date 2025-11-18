# Codex Agent Global Instructions

## Context7 MCP usage
- Always use context7 MCP when you need:
  - code generation help,
  - setup or configuration steps,
  - library/API documentation.
- You should automatically use the context7 MCP tools (`resolve-library-id`, `get-library-docs`) to look up libraries and documentation instead of guessing, without me having to explicitly ask.

## Workflow
- After making a series of code changes, always run a typecheck or equivalent static check where possible.
  - For example, use tools like `mypy`, `pyright`, `tsc`, or language-specific equivalents.
  - If you cannot run a typecheck (e.g. missing tools or config), clearly state that and explain what would normally be run.

## Python version management and virtual environments
- Always use `pyenv` for Python version management.
  - When you need to choose or change a Python version, use `pyenv` (for example: `pyenv local 3.12.1`).
  - When suggesting installation commands, assume Python is managed by `pyenv`.
- Virtual environments must be based on the `pyenv`-managed Python.
  - Prefer using `pyenv` (and `pyenv-virtualenv` if available), for example:
    - `pyenv virtualenv 3.12.1 my-project`
    - `pyenv local my-project`
  - If you need to create a virtual environment directly in the repository, assume a `pyenv`-selected Python and use:
    - `python -m venv .venv`
  - When giving instructions, always show how to activate the environment explicitly, e.g.:
    - `source .venv/bin/activate`
  - Do not recommend using global `virtualenv` or system Python without `pyenv`, unless explicitly stated.

## System packages and tools
- When installing system packages or tools, always use Homebrew (`brew`) if possible.
  - If a package is available in Homebrew, prefer:
    - `brew install <package>`
  - Avoid recommending manual downloads, `curl | bash` installers, or other system package managers unless:
    - the package is not available in Homebrew, or
    - there is a very specific reason to use a different method (and this reason should be mentioned explicitly).

## Language / Documentation
- All documentation and code comments must be written exclusively in English.
- This applies to:
  - README files, guides, and reference docs
  - Inline code comments
  - Docstrings
  - Commit messages
  - Pull request titles and descriptions
- When editing or generating any text, do not switch to other languages even if the source text is mixed-language. Normalize everything to English.
