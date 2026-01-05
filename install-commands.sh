#!/bin/bash

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}Claude Code Commands Installer${NC}"
echo ""
echo "This script will install custom slash commands for Claude Code."
echo ""

# Check if commands directory exists
if [ ! -d "commands/commands" ]; then
    echo -e "${YELLOW}Error: commands/commands directory not found${NC}"
    echo "Please run this script from the claude-skills repository root."
    exit 1
fi

# Prompt for installation type
echo "Choose installation type:"
echo "  1) Personal (available in all projects) - ~/.claude/commands/"
echo "  2) Project-level (current project only) - ./.claude/commands/"
echo ""
read -p "Enter choice [1-2]: " choice

case $choice in
    1)
        INSTALL_DIR="$HOME/.claude/commands"
        INSTALL_TYPE="personal"
        ;;
    2)
        INSTALL_DIR="./.claude/commands"
        INSTALL_TYPE="project-level"
        ;;
    *)
        echo -e "${YELLOW}Invalid choice. Exiting.${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "Installing commands to: ${GREEN}${INSTALL_DIR}${NC}"
echo ""

# Create directory if it doesn't exist
if [ ! -d "$INSTALL_DIR" ]; then
    echo "Creating directory: $INSTALL_DIR"
    mkdir -p "$INSTALL_DIR"
fi

# Count files to install
file_count=$(ls -1 commands/commands/*.md 2>/dev/null | wc -l)

if [ "$file_count" -eq 0 ]; then
    echo -e "${YELLOW}No command files found in commands/commands/${NC}"
    exit 1
fi

# Copy command files
echo "Installing $file_count command(s)..."
echo ""

for file in commands/commands/*.md; do
    filename=$(basename "$file")
    command_name="${filename%.md}"

    cp "$file" "$INSTALL_DIR/"
    echo -e "  ${GREEN}✓${NC} Installed: /$command_name"
done

echo ""
echo -e "${GREEN}Installation complete!${NC}"
echo ""
echo "Installed commands:"
for file in commands/commands/*.md; do
    filename=$(basename "$file")
    command_name="${filename%.md}"
    echo "  - /$command_name"
done

echo ""
echo "You can now use these commands in Claude Code by typing:"
echo "  /new-ticket <ticket-number> [base-branch]"
echo "  /commit [ticket-number]"
echo "  /pr <target-branch>"
echo "  /pr-review <pr-number>"
echo "  /sync-branch <target-branch>"
echo "  /lint"
echo "  /compare-branch <branch1> [branch2]"
echo ""

if [ "$INSTALL_TYPE" = "project-level" ]; then
    echo -e "${YELLOW}Note: Project-level commands can be committed to git and shared with your team.${NC}"
else
    echo -e "${YELLOW}Note: Personal commands are available in all your projects.${NC}"
fi
