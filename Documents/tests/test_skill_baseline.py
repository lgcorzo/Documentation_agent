import os
import yaml

SKILL_PATH = ".agentskills/uml2-okf-documenter/SKILL.md"

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
    assert "pyreverse" in content.lower()
    assert "mermaid" in content.lower()
    assert "okf" in content.lower() or "openwiki" in content.lower()
