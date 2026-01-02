---
description: Create a pull request to target branch
argument-hint: <target-branch>
allowed-tools: Bash(git push:*), Bash(git ls-remote:*), Bash(git branch:*), Bash(git log:*), Bash(git diff:*), Bash(gh pr create:*), Bash(gh pr edit:*), Bash(gh pr list:*)
---

# Create Pull Request Command

## Context

Current branch: !`git branch --show-current`

Target branch: $ARGUMENTS

Remote status: !`git remote -v`

Local commits vs origin: !`git status -sb`

Commits on current branch (vs target): !`git log $ARGUMENTS..HEAD --oneline`

Changed files: !`git diff --name-status $ARGUMENTS..HEAD`

Detailed diff: !`git diff $ARGUMENTS..HEAD --stat`

## Your Task

**IMPORTANT**: You MUST complete all steps in a single message using parallel tool calls where possible. Do not send multiple messages or additional responses beyond the required tool calls.

### 1. Validate Arguments

- Ensure target branch is provided in $ARGUMENTS
- If no target branch, respond with error: "Usage: /pr <target-branch>"
- Common target branches: master, main, develop, staging

### 2. Extract Ticket Number from Current Branch

- Get current branch name
- Look for ticket pattern: `feature/ext-123-description`, `bugfix/jira-456`, `ext-789`, etc.
- Extract ticket number (e.g., "ext-123", "jira-456")
- Convert to UPPERCASE (e.g., "EXT-123", "JIRA-456")
- If no ticket found, that's OK (proceed without ticket prefix)

### 3. Generate PR Title

- Analyze recent commits to understand the main purpose
- Create a concise, descriptive title (under 72 characters)
- If ticket number found, format as: `[TICKET-NUMBER] title`
- If no ticket number, format as: `title`
- Use imperative mood (e.g., "Add feature" not "Added feature")
- Examples:
  - `[EXT-123] Add user authentication with JWT`
  - `[JIRA-456] Fix memory leak in data processor`
  - `Update database schema for new fields`

### 4. Generate PR Description

Analyze the git diff and commit history to create a detailed description with:

**Structure:**
```markdown
## Summary
[2-3 sentences describing what this PR does and why]

## Changes
[Detailed bullet points of what was changed - focus on the "what" and "why"]
- Component/file: what changed and why
- Focus on business logic, not implementation details
- Group related changes together

## Technical Details
[Any important technical notes, patterns used, dependencies added]

## Testing
[How to test these changes, what scenarios to verify]
```

**Guidelines for description:**
- Be specific and detailed
- Explain WHY changes were made, not just WHAT
- Mention any breaking changes or migration steps
- Include testing instructions
- Keep it professional and clear
- Do NOT mention Claude or Claude Code

### 5. Push Current Branch

Before creating PR, ensure branch is pushed to remote:

- Check if remote branch exists: `git ls-remote --heads origin $(git branch --show-current)`
- If branch doesn't exist on remote:
  - Push: `git push -u origin $(git branch --show-current)`
- If branch exists but has different commits:
  - Force push with lease: `git push --force-with-lease origin $(git branch --show-current)`
- Report what was pushed

### 6. Create Pull Request

Use GitHub CLI to create the PR:

```bash
gh pr create \
  --base $ARGUMENTS \
  --head $(git branch --show-current) \
  --title "PR_TITLE_HERE" \
  --body "PR_DESCRIPTION_HERE"
```

**Important:**
- `--base` is the target branch from $ARGUMENTS
- `--head` is the current branch
- Command will create the PR and return the URL
- **DO NOT use --web flag** - do not open browser
- Use proper escaping for title and body (handle quotes, newlines)
- Use HEREDOC syntax for multi-line body: `--body "$(cat <<'EOF' ... EOF)"`

### 7. Report Results

After PR is created, show:
- ✓ PR created successfully
- PR #: [number]
- Title: [title]
- URL: [url]
- Target: current-branch → target-branch

## Error Handling

Handle these cases gracefully:

- **No target branch provided**: Show usage message
- **Target branch doesn't exist**: List available branches
- **No commits to create PR**: Error - nothing to merge
- **PR already exists**: Show existing PR URL
- **Not a git repository**: Error message
- **GitHub CLI not installed**: Error with installation instructions
- **Not authenticated with GitHub**: Error with `gh auth login` instructions

## Important Notes

- **Execute all operations in ONE message** - use parallel tool calls, do not send multiple responses
- Always push before creating PR
- Use --force-with-lease (safer than --force)
- Create PR directly from CLI (no --web flag needed)
- Generate meaningful, detailed descriptions
- Extract ticket numbers from branch names
- Do NOT mention Claude or Claude Code in PR title/description
- Handle multi-line descriptions properly in gh command using HEREDOC syntax
