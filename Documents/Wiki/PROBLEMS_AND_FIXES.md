# Problems and Fixes

## Summary

The following issues were detected while applying Documentation_agent in SpaceInvaders and were fixed in this repository.

| ID | Problem | Impact | Fix Applied |
|---|---|---|---|
| P1 | `graphify sync` command used in workflow | Fails with unknown command in current Graphify CLI | Replaced operational guidance with `graphify update .` and `graphify cluster-only .` |
| P2 | Graphify package name variability in uv ecosystem (`graphify` vs `graphifyy`) | Fresh installs can fail depending on published package name | Added robust installer fallback (`graphify` then `graphifyy`) and kept CLI command as `graphify` |
| P3 | `graphify update` without explicit path | Ambiguous behavior depending on cwd | Updated scripts/hooks to `graphify update .` |
| P4 | Wrapper install scripts did not verify final artifacts | Silent partial installs possible | Added post-install verification checks in both wrappers |
| P5 | README referred to `ai-vault` output as primary Graphify output | Misleading output location for current tool version | Updated docs to point to `graphify-out` and CRG wiki path |

## Updated files

- `install.ps1`
- `install.sh`
- `install-into-repo.ps1`
- `install-into-repo.sh`
- `hooks/post-commit`
- `hooks/post-checkout`
- `hooks/update-graph.ps1`
- `hooks/update-graph-checkout.ps1`
- `README.md`

## Post-install verification now enforced

Wrappers now fail fast if any of these are missing in the target repository:

- `.vscode/mcp.json`
- `.git/hooks/post-commit`
- `.git/hooks/post-checkout`
- `.code-review-graph/graph.db`
- `.code-review-graph/wiki`
- `graphify-out/GRAPH_REPORT.md`

## Additional validation completed

- Wrapper `install-into-repo.ps1` was executed end-to-end against SpaceInvaders.
- Verification step passed (`Verificacion final completada correctamente`).
