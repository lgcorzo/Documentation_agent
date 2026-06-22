# Copilot Instructions - DeepWiki Documenter Installer

Use these instructions when the user asks to install this Documentation_agent into another repository.

## Goal
Install DeepWiki Documenter in a target repository with minimum manual steps and without generating non-Copilot platform artifacts.

## Required workflow
1. Verify source repository contains:
   - `.agentskills/`
   - `hooks/`
   - `.graphifyignore`
   - `.code-review-graphignore`
   - `install.ps1` (Windows) or `install.sh` (Linux)
2. Verify target path exists and contains `.git/`.
3. Prefer wrapper installers:
   - Windows: `install-into-repo.ps1 <target_repo_path>`
   - Linux: `./install-into-repo.sh <target_repo_path>`
4. After install, verify in target repository:
   - `.vscode/mcp.json` exists
   - `.git/hooks/post-commit` exists
   - `.git/hooks/post-checkout` exists
   - `code-review-graph build` executed successfully
   - embeddings generated successfully

## Non-interactive policy
Always run install commands in non-interactive mode. This repository already uses:
- `code-review-graph install -y --platform copilot --no-skills --no-hooks --no-instructions`

## Known failure prevention
- Never copy a file onto itself.
- If embedding fails due to missing sentence-transformers, run:
  - `uvx --from "code-review-graph[embeddings]" code-review-graph embed`
- If an executable is locked during reinstall, avoid reinstall loops and use `uvx --from ...` directly.

## What to avoid
- Do not install platform configs for tools other than GitHub Copilot.
- Do not inject extra instruction files (`CLAUDE.md`, `GEMINI.md`, `QODER.md`, etc.) in target repositories.
- Do not modify unrelated files in the target project.
