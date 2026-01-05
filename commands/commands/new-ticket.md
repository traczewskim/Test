---
description: Start work on a new ticket
argument-hint: <ticket-number> [base-branch]
allowed-tools: Bash(git rev-parse:*), Bash(git fetch:*), Bash(git checkout:*), Bash(git branch:*)
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

### 2. Validate Base Branch

Check if the base branch exists:

```bash
git rev-parse --verify <base-branch> 2>/dev/null
```

- If base branch does NOT exist:
  - List available branches: `git branch -a`
  - Stop with error: "Error: Base branch '<base-branch>' does not exist. Available branches: [list]"
- If base branch exists, proceed

### 3. Create Feature Branch

Create a new feature branch from the base branch:

**Branch naming format:** `feature/<ticket-number>`
- Use the ticket number exactly as provided (preserve original casing)
- Examples:
  - Ticket "jira-1234" → branch "feature/jira-1234"
  - Ticket "JIRA-1234" → branch "feature/JIRA-1234"
  - Ticket "jira-456" → branch "feature/jira-456"

**Steps:**
1. First, fetch latest changes (if remote exists): `git fetch origin <base-branch> 2>/dev/null || true`
2. Create and checkout the new branch:
   ```bash
   git checkout -b feature/<ticket-number> <base-branch>
   ```

**Error handling:**
- If branch already exists:
  - Ask user if they want to switch to it or delete and recreate
  - Stop and wait for user decision

### 4. Report Results

Show a success message with clear information:

```
✓ Created new feature branch for ticket <ticket-number>

Branch: feature/<ticket-number>
Base: <base-branch>
Ticket: <ticket-number>

The ticket number will be automatically extracted from the branch name when you run /commit.

Next steps:
  1. Make your changes
  2. Run /commit to create a commit (ticket number will be extracted from branch name)
  3. Run /pr <target-branch> to create a pull request
```

## Important Notes

- **Execute all operations in ONE message** - do not send multiple responses
- Ticket number is REQUIRED - stop immediately if not provided
- Base branch defaults to "master" if not provided
- Preserve ticket number casing exactly as provided
- Branch format is always `feature/<ticket-number>`
- The `/commit` command will automatically extract the ticket number from the branch name
- Fetch latest changes from base branch before creating new branch
- Do NOT push the new branch automatically (user will do this when ready)
