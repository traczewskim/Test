---
description: Start work on a new ticket
argument-hint: <ticket-number> [base-branch]
allowed-tools: Bash(git rev-parse:*), Bash(git fetch:*), Bash(git checkout:*), Bash(git branch:*), Bash(git push:*)
---

# New Ticket Command

## Context

Current branch: !`git branch --show-current`

Git status: !`git status`

Arguments provided: $ARGUMENTS

## Your Task

**IMPORTANT**: You MUST complete all steps in a single message using parallel tool calls where possible. Do not send multiple messages.

### 1. Parse Arguments

Arguments are provided in $ARGUMENTS in the format: `<ticket-number> [base-branch]`

- **ticket-number** (REQUIRED): The ticket identifier (e.g., "jira-1234", "JIRA-456")
- **base-branch** (OPTIONAL): The branch to branch from (e.g., "release/v3.2.0", "develop")
  - If not provided, use "master" as default

**Parse the arguments:**
1. Split $ARGUMENTS by whitespace
2. First argument is the ticket number
3. Second argument (if present) is the base branch, otherwise use "master"

**Validation:**
- If NO ticket number is provided (empty $ARGUMENTS):
  - Stop immediately
  - Show error: "Error: Ticket number is required. Usage: /new-ticket <ticket-number> [base-branch]"
  - Do NOT proceed with any other steps
- If ticket number is provided, proceed

### 2. Validate and Normalize Base Branch

**Normalize the branch name:**
- User-provided branch is the base branch from step 1 (e.g., "main", "origin/main", "master")
- Check if the exact branch exists: `git rev-parse --verify <base-branch> 2>/dev/null`
- If it doesn't exist, try alternative forms:
  - If base branch is "main", try "origin/main"
  - If base branch is "origin/main", try "main"
  - If base branch is "master", try "origin/master"
  - If base branch is "origin/master", try "master"
  - Same pattern for: develop, staging, production, release/*, etc.
- Use the first valid branch reference found
- If no valid branch found, error with: "Error: Base branch '<base-branch>' does not exist. Available branches:" and list branches
- **Store the normalized branch name in a variable** - use this in ALL subsequent git commands
- Common base branches: master, main, develop, staging, release/*

### 3. Create Feature Branch

Create a new feature branch from the normalized base branch:

**Branch naming format:** `feature/<ticket-number>`
- Use the ticket number exactly as provided (preserve original casing)
- Examples:
  - Ticket "jira-1234" → branch "feature/jira-1234"
  - Ticket "JIRA-1234" → branch "feature/JIRA-1234"
  - Ticket "jira-456" → branch "feature/jira-456"

**Steps:**
1. First, fetch latest changes (if remote exists): `git fetch origin 2>/dev/null || true`
2. Create and checkout the new branch using the **normalized** base branch from step 2:
   ```bash
   git checkout -b feature/<ticket-number> <normalized-base-branch>
   ```

**Error handling:**
- If branch already exists:
  - Ask user if they want to switch to it or delete and recreate
  - Stop and wait for user decision

### 4. Push Branch and Set Up Tracking

Push the newly created branch to remote and set up tracking:

**Steps:**
1. Push with `-u` flag to set up tracking:
   ```bash
   git push -u origin feature/<ticket-number>
   ```

**This ensures:**
- The branch is available on the remote repository
- Tracking is set up so future `git push` commands work without arguments
- Other team members can see the branch

**Error handling:**
- If push fails (no remote, authentication issues, etc.):
  - Show the error message
  - Warn user that branch is local only
  - Continue to step 5 (don't fail completely)
  - User can manually push later

### 5. Report Results

Show a success message with clear information using the **normalized** base branch:

**If push succeeded:**
```
✓ Created and pushed new feature branch for ticket <ticket-number>

Branch: feature/<ticket-number>
Base: <normalized-base-branch>
Ticket: <ticket-number>
Remote: origin (tracking enabled)

The ticket number will be automatically extracted from the branch name when you run /commit.

Next steps:
  1. Make your changes
  2. Run /commit to create a commit (ticket number will be extracted from branch name)
  3. Run /pr <target-branch> to create a pull request
```

**If push failed (local only):**
```
✓ Created new feature branch for ticket <ticket-number> (local only)

Branch: feature/<ticket-number>
Base: <normalized-base-branch>
Ticket: <ticket-number>
⚠️  Warning: Branch was not pushed to remote

The ticket number will be automatically extracted from the branch name when you run /commit.

Next steps:
  1. Make your changes
  2. Run /commit to create a commit (ticket number will be extracted from branch name)
  3. Run /pr <target-branch> to create a pull request (will push and set up tracking)
```

## Important Notes

- **Execute all operations in ONE message** - do not send multiple responses
- Ticket number is REQUIRED - stop immediately if not provided
- Base branch defaults to "master" if not provided
- **Normalize base branch name** - handle "main" vs "origin/main", "master" vs "origin/master", etc.
- Use the **normalized** branch name in all git commands (fetch, checkout)
- Preserve ticket number casing exactly as provided
- Branch format is always `feature/<ticket-number>`
- The `/commit` command will automatically extract the ticket number from the branch name
- Fetch latest changes from origin before creating new branch
- **Push the new branch with `-u` flag** to set up tracking automatically
- If push fails, continue anyway (branch remains local only)
