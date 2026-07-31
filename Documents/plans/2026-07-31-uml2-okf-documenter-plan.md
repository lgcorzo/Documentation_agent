# `uml2-okf-documenter` Skill Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create the `uml2-okf-documenter` agent skill inside `/mnt/F024B17C24B145FE/Repos/Documentation_agent/.agentskills/uml2-okf-documenter/SKILL.md` following agent skill specifications, OKF / OpenWiki standards, UML 2.0 notation, and NotebookLM / local dev documentation agent integrations.

**Architecture:** The skill document (`SKILL.md`) will serve as an authoritative reference for software architecture documentation. It will instruct agents to extract deterministic AST data (`pyreverse`), query local topology graphs (`graphify`, `code-review-graph`), interact with NotebookLM MCP tools, generate Mermaid.js UML 2.0 diagrams, write OKF Markdown headers, and link pages with Obsidian Wikilinks.

**Tech Stack:** Agent Skills spec (`agentskills.io`), Open Knowledge Format (OKF), Mermaid.js UML 2.0, Pyreverse, Graphify, SQLite FTS5 (`code-review-graph`), NotebookLM MCP server (`notebooklm-mcp`).

## Global Constraints

- Must follow `agentskills.io` frontmatter specifications (`name` and `description` under 1024 chars).
- `description` MUST start with "Use when..." and contain ONLY triggering conditions (no workflow summary).
- Relative paths only — absolute paths are strictly forbidden.
- Zero-hallucination policy using AST / local tools as source of truth.

---

### Task 1: Baseline Verification and RED Phase Test Case Setup

**Files:**
- Test: `/mnt/F024B17C24B145FE/Repos/Documentation_agent/Documents/tests/test_skill_baseline.py`

**Interfaces:**
- Consumes: Skill specification rules
- Produces: Test script validating SKILL.md structure and YAML frontmatter compliance

- [ ] **Step 1: Write the failing validation test**

```python
import os
import yaml

SKILL_PATH = "/mnt/F024B17C24B145FE/Repos/Documentation_agent/.agentskills/uml2-okf-documenter/SKILL.md"

def test_skill_file_exists_and_valid():
    assert os.path.exists(SKILL_PATH), f"Skill file does not exist at {SKILL_PATH}"
    with open(SKILL_PATH, "r", encoding="utf-8") as f:
        content = f.read()
    
    parts = content.split("---")
    assert len(parts) >= 3, "YAML frontmatter delimiter '---' missing or invalid"
    frontmatter = yaml.safe_load(parts[1])
    assert "name" in frontmatter, "Frontmatter missing 'name'"
    assert "description" in frontmatter, "Frontmatter missing 'description'"
    assert frontmatter["name"] == "uml2-okf-documenter"
    assert frontmatter["description"].startswith("Use when")
    assert "pyreverse" in content
    assert "Mermaid" in content or "mermaid" in content
    assert "OKF" in content or "OpenWiki" in content
```

- [ ] **Step 2: Run test to verify it fails**

Run: `python3 -m pytest /mnt/F024B17C24B145FE/Repos/Documentation_agent/Documents/tests/test_skill_baseline.py -v`
Expected: FAIL (Skill file does not exist yet)

- [ ] **Step 3: Commit baseline test setup**

```bash
git add Documents/tests/test_skill_baseline.py
git commit -m "test: add baseline validation test for uml2-okf-documenter skill"
```

---

### Task 2: Create the `uml2-okf-documenter` Skill Document

**Files:**
- Create: `/mnt/F024B17C24B145FE/Repos/Documentation_agent/.agentskills/uml2-okf-documenter/SKILL.md`

**Interfaces:**
- Consumes: Technical spec design document
- Produces: Complete, enterprise-ready SKILL.md file for agent loading

- [ ] **Step 1: Write the SKILL.md file**

Create `/mnt/F024B17C24B145FE/Repos/Documentation_agent/.agentskills/uml2-okf-documenter/SKILL.md` with:
- YAML Frontmatter (`name`, `description`)
- Role & Core Objective (Principal Software Architect & Professional Documenter)
- Mandatory Tooling & Deterministic Rules (`pyreverse`, `graphify`, `code-review-graph`, `notebooklm-mcp`, relative paths)
- OKF & OpenWiki Standards (YAML headers, `./openwiki/` folder structure, `index.md`, `logs.md`)
- UML 2.0 Notation Guidelines (Mermaid class, sequence, package, component diagrams)
- Obsidian `[[Wikilinks]]` Syntax & Relative Source Citations
- Execution Workflow (Phases 1-4: Discovery, AST Extraction, OpenWiki Mirrored Generation, Indexing & Verification)

- [ ] **Step 2: Run test to verify it passes**

Run: `python3 -m pytest /mnt/F024B17C24B145FE/Repos/Documentation_agent/Documents/tests/test_skill_baseline.py -v`
Expected: PASS

- [ ] **Step 3: Commit the new skill**

```bash
git add .agentskills/uml2-okf-documenter/SKILL.md
git commit -m "feat: add uml2-okf-documenter skill in .agentskills"
```

---

### Task 3: Verification & Integration Validation

**Files:**
- Modify/Verify: `/mnt/F024B17C24B145FE/Repos/Documentation_agent/.agentskills/uml2-okf-documenter/SKILL.md`

- [ ] **Step 1: Verify Frontmatter and Token Efficiency**

Check word count and character count of frontmatter and body. Ensure under 500 words for SKILL.md body or well-structured sections.

- [ ] **Step 2: Final Verification Run**

Run: `python3 -m pytest /mnt/F024B17C24B145FE/Repos/Documentation_agent/Documents/tests/test_skill_baseline.py -v`
Expected: PASS
