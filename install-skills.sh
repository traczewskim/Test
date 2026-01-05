#!/bin/bash

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}Claude Code Skills Installer${NC}"
echo ""
echo "This script will install custom skills for Claude Code."
echo ""

# Check if skills directory exists
if [ ! -d "SKILLS/skills" ]; then
    echo -e "${YELLOW}Error: SKILLS/skills directory not found${NC}"
    echo "Please run this script from the claude-skills repository root."
    exit 1
fi

# Prompt for installation type
echo "Choose installation type:"
echo "  1) Personal (available in all projects) - ~/.claude/skills/"
echo "  2) Project-level (current project only) - ./.claude/skills/"
echo ""
read -p "Enter choice [1-2]: " choice

case $choice in
    1)
        INSTALL_DIR="$HOME/.claude/skills"
        INSTALL_TYPE="personal"
        ;;
    2)
        INSTALL_DIR="./.claude/skills"
        INSTALL_TYPE="project-level"
        ;;
    *)
        echo -e "${YELLOW}Invalid choice. Exiting.${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "Installing skills to: ${GREEN}${INSTALL_DIR}${NC}"
echo ""

# Create directory if it doesn't exist
if [ ! -d "$INSTALL_DIR" ]; then
    echo "Creating directory: $INSTALL_DIR"
    mkdir -p "$INSTALL_DIR"
fi

# Count directories to install
skill_count=$(ls -1d SKILLS/skills/*/ 2>/dev/null | wc -l)

if [ "$skill_count" -eq 0 ]; then
    echo -e "${YELLOW}No skill directories found in SKILLS/skills/${NC}"
    exit 1
fi

# Copy skill directories
echo "Installing $skill_count skill(s)..."
echo ""

for skill_dir in SKILLS/skills/*/; do
    skill_name=$(basename "$skill_dir")

    # Skip if not a directory
    if [ ! -d "$skill_dir" ]; then
        continue
    fi

    # Create skill directory if it doesn't exist
    mkdir -p "$INSTALL_DIR/$skill_name"

    # Copy skill files
    cp -r "$skill_dir"* "$INSTALL_DIR/$skill_name/"
    echo -e "  ${GREEN}✓${NC} Installed: $skill_name"
done

echo ""
echo -e "${GREEN}Installation complete!${NC}"
echo ""
echo "Installed skills:"
for skill_dir in SKILLS/skills/*/; do
    skill_name=$(basename "$skill_dir")
    if [ -d "$skill_dir" ]; then
        echo "  - $skill_name"
    fi
done

echo ""
echo "Available skills:"
echo "  - create-proposal - Create technical proposals with 5-phase workflow"
echo "  - create-technical-requirements - Generate detailed technical requirements"
echo "  - database-analysis - Analyze database patterns and execute queries"
echo "  - frontend-design - Create production-grade frontend interfaces"
echo "  - new-command - Interactive wizard for creating new commands and skills"
echo ""

if [ "$INSTALL_TYPE" = "project-level" ]; then
    echo -e "${YELLOW}Note: Project-level skills can be committed to git and shared with your team.${NC}"
else
    echo -e "${YELLOW}Note: Personal skills are available in all your projects.${NC}"
fi
