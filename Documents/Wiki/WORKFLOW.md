# Operational Workflow

## End-to-end install workflow

```mermaid
flowchart TD
    A[Run wrapper install-into-repo] --> B[Copy agent assets to target repo]
    B --> C[Run target install.ps1 or install.sh]
    C --> D[Install CRG + Graphify]
    D --> E[Register MCP for Copilot]
    E --> F[Build CRG graph + embed]
    F --> G[Run graphify update .]
    G --> H[Run graphify cluster-only .]
    H --> I[Verify required outputs]
    I --> J[Installation complete]
```

## Hook update workflow

```mermaid
flowchart TD
    A[Git post-commit or post-checkout] --> B{OS}
    B -->|Windows| C[Run update-graph*.ps1 in background]
    B -->|Linux| D[Run update commands via hook script]
    C --> E[code-review-graph update or build]
    D --> E
    E --> F[graphify update .]
    F --> G[graph artifacts refreshed]
```

## Human consumption outputs

- CRG review wiki: `.code-review-graph/wiki/`
- Graphify structural report: `graphify-out/GRAPH_REPORT.md`
- Graphify interactive graph: `graphify-out/graph.html`

## Recommended operator checklist

1. Run installer in target repo.
2. Confirm wrapper verification passes.
3. Open `.code-review-graph/wiki/` for markdown navigation.
4. Open `graphify-out/graph.html` for interactive graph view.
5. Run a commit and confirm hooks refresh outputs.
