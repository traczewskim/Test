---
description: Create or update pull request to target branch
argument-hint: <target-branch>
allowed-tools: Bash(git push:*), Bash(git ls-remote:*), Bash(git branch:*), Bash(git log:*), Bash(git diff:*), Bash(gh pr create:*), Bash(gh pr edit:*), Bash(gh pr list:*), Bash(gh pr comment:*)
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

Before creating/updating PR, ensure branch is pushed to remote:

- Check if remote branch exists: `git ls-remote --heads origin $(git branch --show-current)`
- If branch doesn't exist on remote:
  - Push: `git push -u origin $(git branch --show-current)`
- If branch exists but has different commits:
  - Force push with lease: `git push --force-with-lease origin $(git branch --show-current)`
- Report what was pushed

### 6. Check for Existing Pull Request

Before creating a new PR, check if one already exists for this branch:

```bash
# List PRs for current branch (all states)
gh pr list --head $(git branch --show-current) --json number,state,title,url
```

**Parse the response:**

- **If NO PR exists**: Proceed to step 7 (Create New PR)
- **If PR exists**: Check the state

**PR States:**
- `OPEN`: PR is currently open
- `CLOSED`: PR was closed without merging
- `MERGED`: PR was merged

**Decision logic:**

1. **If state is OPEN**:
   ```
   ℹ️  Existing PR found for this branch

   PR #${number}: ${title}
   Status: Open
   URL: ${url}

   Updating existing PR with latest changes...
   ```
   - Proceed to step 8 (Update Existing PR)

2. **If state is CLOSED or MERGED**:
   ```
   ℹ️  Previous PR for this branch was ${state}

   PR #${number}: ${title}
   Status: ${state}
   URL: ${url}

   Creating new PR for updated changes...
   ```
   - Proceed to step 7 (Create New PR)

### 7. Create New Pull Request

Use GitHub CLI to create a new PR:

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

**After creation, show:**
```
✓ PR created successfully

PR #${number}: ${title}
URL: ${url}
Target: ${current_branch} → ${target_branch}
```

Skip to step 9 (Final Report)

### 8. Update Existing Pull Request

Update the existing open PR with new title and description:

```bash
gh pr edit ${pr_number} \
  --title "PR_TITLE_HERE" \
  --body "PR_DESCRIPTION_HERE"
```

**Important:**
- Use the PR number from step 6
- Update both title and body with freshly generated content
- This ensures PR reflects latest changes

**Additionally, push notification:**
```bash
# Add a comment to notify about the update
gh pr comment ${pr_number} --body "Updated PR with latest changes from $(git log -1 --pretty=format:'%h - %s')"
```

**After update, show:**
```
✓ PR updated successfully

PR #${number}: ${title}
Status: Updated with latest changes
URL: ${url}
Target: ${current_branch} → ${target_branch}

Latest commit: $(git log -1 --oneline)
```

### 9. Final Report

Show summary of what was done:

**For new PR:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Pull Request Created
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

PR #${number}: ${title}
URL: ${url}

${current_branch} → ${target_branch}

Changes:
  ${commit_count} commits
  ${files_count} files changed

Next steps:
  • Review PR on GitHub
  • Request reviewers
  • Address any CI/CD feedback
```

**For updated PR:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Pull Request Updated
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

PR #${number}: ${title}
URL: ${url}

${current_branch} → ${target_branch}

Updated with:
  ${new_commits} new commits
  ${updated_files} files changed

Latest: ${latest_commit_message}

Next steps:
  • Reviewers will be notified
  • Check CI/CD status
  • Respond to review comments
```

## Error Handling

Handle these cases gracefully:

- **No target branch provided**: Show usage message
- **Target branch doesn't exist**: List available branches
- **No commits to create PR**: Error - nothing to merge
- **PR check fails**: Continue to create new PR (fallback behavior)
- **Not a git repository**: Error message
- **GitHub CLI not installed**: Error with installation instructions
- **Not authenticated with GitHub**: Error with `gh auth login` instructions
- **Update PR fails**: Show error but don't fail completely, offer to create new PR

## Important Notes

- **Execute all operations in ONE message** - use parallel tool calls, do not send multiple responses
- **Check for existing PRs first** - Update open PRs instead of creating duplicates
- Always push before creating/updating PR
- Use --force-with-lease (safer than --force)
- Create PR directly from CLI (no --web flag needed)
- Generate meaningful, detailed descriptions
- Extract ticket numbers from branch names
- Do NOT mention Claude or Claude Code in PR title/description
- Handle multi-line descriptions properly in gh command using HEREDOC syntax
- **PR update behavior**:
  - If PR is OPEN → update title, description, and add comment
  - If PR is CLOSED/MERGED → create new PR
  - If no PR exists → create new PR
