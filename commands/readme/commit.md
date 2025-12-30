# `/commit` - Create Git Commit

Creates a git commit with auto-generated message and optional ticket number.

## Usage

```bash
# Without ticket number
/commit

# With ticket number
/commit ext-123
```

## Features

- **Branch safety**: Automatically creates new feature branch if on main/master
- Automatically stages all changes (`git add .`)
- Analyzes diff to generate descriptive commit message
- Supports ticket number prefix (preserves casing): `[ext-123] commit message`
- Single-message execution (all operations in one response)
- Restricted tool permissions for safety
- Does NOT push to remote (manual push required)
- Does NOT mention Claude or Claude Code in messages

## Examples

1. Simple commit without ticket:
   ```bash
   /commit
   # Result: "add user authentication feature"
   ```

2. Commit with ticket number:
   ```bash
   /commit ext-456
   # Result: "[ext-456] fix login validation bug"
   ```

3. Different ticket formats (all work, casing preserved):
   ```bash
   /commit ext-123      # → [ext-123] ...
   /commit EXT-123      # → [EXT-123] ...
   /commit jira-456     # → [jira-456] ...
   ```

## What it does

1. Checks if on main/master branch
2. Creates new feature branch if needed (prevents commits directly to main)
3. Stages all changes
4. Analyzes git diff
5. Generates commit message
6. Formats with ticket number if provided
7. Creates commit locally
8. Shows commit hash and message

## What it does NOT do

- Push to remote (you push manually)
- Create PRs
- Run tests
- Modify files

## Installation

Copy the command file to your Claude Code commands directory:

```bash
# Project-level (shared with team via git)
cp commands/commands/commit.md /path/to/your/project/.claude/commands/

# Personal (available in all projects)
mkdir -p ~/.claude/commands
cp commands/commands/commit.md ~/.claude/commands/
```
