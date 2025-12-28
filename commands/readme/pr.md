# `/pr` - Create Pull Request

Creates a GitHub pull request with auto-generated title, detailed description, and ticket number detection.

## Usage

```bash
# Create PR to master
/pr master

# Create PR to develop
/pr develop

# Create PR to any branch
/pr staging
```

## Features

- Auto-generates PR title from recent commits
- Creates detailed PR description with summary, changes, and testing notes
- Extracts ticket number from branch name (e.g., `feature/ext-123-login` → `[EXT-123]`)
- Automatically pushes current branch to remote
- Force pushes with `--force-with-lease` if branch already exists
- Does NOT open browser (creates PR via CLI only)
- Single-message execution (all operations in one response)
- Restricted tool permissions for safety
- Handles GitHub authentication and errors gracefully

## Examples

1. Simple PR from feature branch:
   ```bash
   # On branch: feature/ext-123-user-auth
   /pr master
   # Result: Creates PR with title "[EXT-123] Add user authentication"
   ```

2. PR without ticket number:
   ```bash
   # On branch: update-docs
   /pr master
   # Result: Creates PR with title "Update documentation"
   ```

3. PR to different target:
   ```bash
   # On branch: feature/ext-456-api
   /pr develop
   # Result: Creates PR to develop branch with title "[EXT-456] Add new API endpoints"
   ```

## What it does

1. Validates target branch argument
2. Extracts ticket number from current branch name
3. Analyzes commit history and changes
4. Generates descriptive PR title and detailed description
5. Pushes current branch to remote (force-with-lease if needed)
6. Creates PR using GitHub CLI (`gh pr create`)
7. Displays PR URL and details

## What it does NOT do

- Merge the PR (manual review required)
- Run CI/CD tests
- Request reviewers automatically
- Create draft PRs (creates regular PRs)
- Open browser window

## Requirements

- GitHub CLI (`gh`) must be installed
- Must be authenticated with GitHub (`gh auth login`)
- Must be in a git repository
- Target branch must exist

## PR Description Format

The command generates a structured description:

```markdown
## Summary
[Brief overview of what the PR does and why]

## Changes
- Detailed bullet points of what was changed
- Explains the "what" and "why" of changes
- Groups related changes together

## Technical Details
[Important technical notes, patterns, dependencies]

## Testing
[How to test the changes, scenarios to verify]
```

## Installation

Copy the command file to your Claude Code commands directory:

```bash
# Project-level (shared with team via git)
cp commands/commands/pr.md /path/to/your/project/.claude/commands/

# Personal (available in all projects)
mkdir -p ~/.claude/commands
cp commands/commands/pr.md ~/.claude/commands/
```
