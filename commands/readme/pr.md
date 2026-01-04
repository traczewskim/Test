# `/pr` - Create or Update Pull Request

Creates a new GitHub pull request or updates an existing one with auto-generated title, detailed description, and ticket number detection.

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

- **Smart PR handling**: Checks for existing PRs and updates them instead of creating duplicates
- Auto-generates PR title from recent commits
- Creates detailed PR description with summary, changes, and testing notes
- Extracts ticket number from branch name (e.g., `feature/ext-123-login` → `[EXT-123]`)
- Automatically pushes current branch to remote
- Force pushes with `--force-with-lease` if branch already exists
- **Updates existing open PRs** with latest title, description, and comment notification
- **Creates new PR** if previous PR was closed/merged or doesn't exist
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

4. Updating existing PR:
   ```bash
   # On branch: feature/ext-123-user-auth (PR already exists)
   # Made more commits, want to update PR
   /pr master
   # Result: Updates existing PR #42 with new title, description, and adds comment
   ```

5. Creating new PR after previous was merged:
   ```bash
   # On branch: feature/ext-123-user-auth (PR #42 was merged)
   # Reusing branch for new changes
   /pr master
   # Result: Creates new PR #50 (previous PR was merged)
   ```

## What it does

1. Validates target branch argument
2. Extracts ticket number from current branch name
3. Analyzes commit history and changes
4. Generates descriptive PR title and detailed description
5. Pushes current branch to remote (force-with-lease if needed)
6. **Checks for existing PR** from this branch
7. **If PR exists and is open**: Updates PR title, description, and adds update comment
8. **If PR is closed/merged or doesn't exist**: Creates new PR using GitHub CLI
9. Displays PR URL and details

## What it does NOT do

- Merge the PR (manual review required)
- Run CI/CD tests
- Request reviewers automatically
- Create draft PRs (creates regular PRs)
- Open browser window

## Smart PR Behavior

The command intelligently handles existing PRs to prevent duplicates:

### Scenario 1: No Existing PR

```bash
/pr main
```

**Result:** Creates new PR

```
✓ PR created successfully

PR #42: [EXT-123] Add user authentication
URL: https://github.com/user/repo/pull/42
Target: feature/ext-123 → main
```

### Scenario 2: Open PR Exists

```bash
# PR #42 is already open for this branch
# You made more commits and want to update it

/pr main
```

**Result:** Updates existing PR

```
ℹ️  Existing PR found for this branch

PR #42: [EXT-123] Add user authentication
Status: Open
URL: https://github.com/user/repo/pull/42

Updating existing PR with latest changes...

✓ PR updated successfully

PR #42: [EXT-123] Add user authentication
Status: Updated with latest changes
URL: https://github.com/user/repo/pull/42

Latest commit: abc1234 Fix login validation
```

**What gets updated:**
- PR title (regenerated from latest commits)
- PR description (regenerated with latest changes)
- Comment added: "Updated PR with latest changes from abc1234 - Fix login validation"

### Scenario 3: Closed/Merged PR Exists

```bash
# PR #42 was merged
# You're reusing the branch for new work

/pr main
```

**Result:** Creates new PR

```
ℹ️  Previous PR for this branch was MERGED

PR #42: [EXT-123] Add user authentication
Status: MERGED
URL: https://github.com/user/repo/pull/42

Creating new PR for updated changes...

✓ PR created successfully

PR #50: [EXT-123] Add password reset feature
URL: https://github.com/user/repo/pull/50
```

### Why This Matters

**Prevents duplicate PRs:**
- Running `/pr` multiple times on same branch won't create PR #42, #43, #44...
- Updates the single open PR instead

**Allows branch reuse:**
- After PR is merged, you can continue working on the same branch
- New `/pr` creates a fresh PR for new changes

**Keeps PR description current:**
- As you add commits, PR description stays up-to-date
- Reviewers see latest changes reflected in description

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
