---
iso_doc_type: "Specification"
iso_viewpoint: "ComponentView"
type: "specification"
title: "API & CLI Contracts"
source_path: "openwiki/specifications/api_contracts.md"
description: "Complete interface specification for all CLI scripts, Git hooks, and automation tools in the Documentation_agent ecosystem."
tags: ["iso15289", "specification", "api", "cli", "contracts"]
timestamp: "2026-07-31T18:15:00Z"
generated: "agent:okf-professional-documenter"
verified: "true"
last_verified_commit: "N/A"
---

# API & CLI Contracts: Documentation_agent Ecosystem

## 1. Installation Scripts

### `install.sh` (Linux/macOS)

* **Source:** `install.sh:L1-L123`
* **Purpose:** Automated environment setup for the DeepWiki Documenter ecosystem.
* **Prerequisites:** `git`, `curl`, internet access (for first-time tool installation).

#### Execution Contract

| Step | Command | Output Artifact | Failure Mode |
|:---|:---|:---|:---|
| 1. Install `uv` | `curl -LsSf https://astral.sh/uv/install.sh \| sh` | `~/.local/bin/uv` | Network error |
| 2. Install CRG | `uv tool install code-review-graph` | `code-review-graph` CLI | Package resolution |
| 3. Install Graphify | `uv tool install graphifyy` (fallback from `graphify`) | `graphify` CLI | Package naming variation |
| 4. Install Ollama | `curl -fsSL https://ollama.com/install.sh \| sh` | `ollama` service | Network error |
| 5. Pull embeddings | `ollama pull nomic-embed-text` | Model weights | Ollama not running |
| 6. Register MCP | `code-review-graph install -y --platform copilot --no-skills --no-hooks --no-instructions` | `.vscode/mcp.json` | Platform mismatch |
| 7. Install hooks | `cp hooks/* .git/hooks/` + `chmod +x` | Executable hooks | Missing `.git/` |
| 8. Build graph | `code-review-graph build` | `.code-review-graph/graph.db` | No source files |
| 9. Generate embeddings | `uvx --from "code-review-graph[embeddings]" code-review-graph embed` | Embedding vectors | Missing `sentence-transformers` |
| 10. Graphify update | `graphify update .` | `graphify-out/graph.json` | No parseable files |
| 11. Graphify cluster | `graphify cluster-only .` | `graphify-out/GRAPH_REPORT.md` | No graph data |

#### Environment Variables Set

| Variable | Value | Persistence |
|:---|:---|:---|
| `CRG_TOOLS` | `semantic_search_nodes_tool,query_graph_tool,get_impact_radius_tool,get_review_context_tool` | `~/.bashrc` or `~/.zshrc` |
| `PATH` | `$HOME/.local/bin:$PATH` | `~/.bashrc` or `~/.zshrc` |

---

## 2. Git Hooks

### `hooks/post-commit`

* **Source:** `hooks/post-commit:L1-L48`
* **Trigger:** Every `git commit`
* **Behavior:** Cross-platform (Bash detects OS, delegates to PowerShell on Windows).

| OS | CRG Action | Graphify Action | Bridge Event |
|:---|:---|:---|:---|
| Linux | `code-review-graph update` (background, 5min timeout) | `graphify update .` (background, 5min timeout) | `post_commit_graph_update` logged |
| Windows | Delegates to `update-graph.ps1` (hidden window) | Included in PS1 script | N/A (PS1 handles) |

**Guard:** Skips if `code-review-graph` or `graphify` processes already running.

### `hooks/post-checkout`

* **Source:** `hooks/post-checkout:L1-L62`
* **Trigger:** Every `git checkout` (branch switch only, `$3 == 1`).

| Changed Files | CRG Action | Graphify Action |
|:---|:---|:---|
| ≤ 5 | Incremental `update` | Incremental `update .` |
| > 5 | Full `build` | Forced `update .` (`GRAPHIFY_FORCE=true`) |

### `hooks/log-bridge-event.sh`

* **Source:** `hooks/log-bridge-event.sh:L1-L30`
* **Purpose:** Append structured JSON events to `.specify/bridge/bridge-events.jsonl`.
* **Usage:** `bash hooks/log-bridge-event.sh <event_type> [details]`

#### Event Schema

```json
{
  "event": "string (event type)",
  "commit": "string (short SHA)",
  "timestamp": "string (ISO 8601 UTC)",
  "agent": "string (producer identity)",
  "details": "string (optional context)"
}
```

---

## 3. OKF Validator

### `skills/validate/scripts/okf_validate.py`

* **Source:** `skills/validate/scripts/okf_validate.py`
* **Usage:** `python3 okf_validate.py <wiki_path> [--strict]`

#### Validation Rules

| Rule | Check | `--strict` Required |
|:---|:---|:---|
| YAML Frontmatter | Every `.md` file has `---` delimited YAML | No |
| Required Fields | `type`, `title`, `description`, `tags`, `timestamp` present | No |
| ISO Fields | `iso_doc_type`, `iso_viewpoint` present | Yes |
| Provenance Fields | `generated`, `verified`, `last_verified_commit` present | Yes |
| No Absolute Paths | No absolute path prefixes in file references (e.g. system home/mount paths or Windows drive letters) | No |
| Mermaid Syntax | Basic bracket/brace matching in `mermaid` blocks | Yes |

---

## 4. Agent Skills Interface

### `okf-professional-documenter`

* **Location:** `.agents/skills/okf-professional-documenter/SKILL.md`
* **Trigger:** When generating OKF-compliant documentation.
* **Input:** Source code directory, existing `openwiki/` state.
* **Output:** Updated `openwiki/**/*.md` files with OKF frontmatter.

### `uml2-okf-documenter`

* **Location:** `.agents/skills/uml2-okf-documenter/SKILL.md`
* **Trigger:** When generating ISO-standard documentation with UML 2.0 diagrams.
* **Modes:** Full Documentation (`full`) or Incremental Git Diff (`diff`).
* **Input:** Source code, `graphify-out/graph.json`, `git diff` output.
* **Output:** Complete or incremental `openwiki/` update with Mermaid UML 2.0 diagrams.
