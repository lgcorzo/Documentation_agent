---
iso_doc_type: "Specification"
iso_viewpoint: "ComponentView"
type: "module"
title: "Module: convert_links"
source_path: "skills/validate/scripts/convert_links.py"
description: "Automated utility script for converting wiki double-bracket link structures to relative Markdown links."
tags: ["validate", "links", "openwiki"]
timestamp: "2026-08-01T10:15:36Z"
generated: "agent:uml2-okf-documenter"
verified: "true"
last_verified_commit: "f704192"
---

# Module Specification: convert_links

* **Source Reference:** [skills/validate/scripts/convert_links.py](../../../../../skills/validate/scripts/convert_links.py) (Lines: L1-L164)

## 1. Architectural Role & Responsibilities

The `convert_links` module is a utility script that automates the migration of legacy wiki Obsidian-style double-bracket wikilinks (`[[WikiLink]]`) into standard relative Markdown links (`[label](relative_path.md)`). This is used during automated documentation publishing pipelines to guarantee cross-platform and static host compatibility.

## 2. UML 2.0 Execution Flow (Sequence Diagram)

```mermaid
sequenceDiagram
    autonumber
    actor Runner as CLI / CI Workflow
    participant Main as main()
    participant Convert as convert_file()
    participant Resolve as resolve_wiki_link()
    participant Camel as camel_to_snake()

    Runner->>Main: Execute script
    activate Main
    Note over Main: Scans openwiki/ recursively for .md files
    loop for each md_file
        Main->>Convert: convert_file(file_path, wiki_root)
        activate Convert
        Note over Convert: Strips backticks & parses [[WikiLinks]]
        loop for each match
            Convert->>Resolve: resolve_wiki_link(link_content, current_file_dir, wiki_root)
            activate Resolve
            loop for each path part
                Resolve->>Camel: camel_to_snake(part)
                activate Camel
                Camel-->>Resolve: snake_case_part
                deactivate Camel
            end
            Note over Resolve: Walks wiki_root to calculate relative path
            Resolve-->>Convert: relative_target_path
            deactivate Resolve
        end
        Note over Convert: Replaces matches & writes file to disk
        Convert-->>Main: File converted
        deactivate Convert
    end
    Main-->>Runner: Finished
    deactivate Main
```

## 3. Function Specifications

### `camel_to_snake(name)` (L6-14)
- **Purpose:** Converts a CamelCase string to snake_case. Handles special cases like `init` -> `__init__` and `main` -> `__main__`.
- **Inputs:**
  - `name` (`str`): The string to convert.
- **Outputs:**
  - `str`: The converted snake_case string.

### `resolve_wiki_link(link_content, current_file_dir, wiki_root)` (L16-42)
- **Purpose:** Resolves a wikilink string into a relative file path from the source file. Normalizes folder names to snake_case and verifies file existence.
- **Inputs:**
  - `link_content` (`str`): The wikilink path reference.
  - `current_file_dir` (`str`): Directory containing the file being parsed.
  - `wiki_root` (`str`): Absolute path to the root directory of the wiki.
- **Outputs:**
  - `str | None`: The relative path to the target markdown file if found, otherwise `None`.

### `convert_file(file_path, wiki_root)` (L44-149)
- **Purpose:** Opens a markdown file, parses it for wikilinks and source code path citations, transforms them into standardized relative links, and saves changes.
- **Inputs:**
  - `file_path` (`str`): Path to the target markdown file.
  - `wiki_root` (`str`): Absolute path to the root of the wiki.
- **Outputs:**
  - `None`.

### `main()` (L150-160)
- **Purpose:** Scans the `openwiki/` folder recursively and processes all markdown files through `convert_file()`.
- **Inputs:** None.
- **Outputs:** None.
