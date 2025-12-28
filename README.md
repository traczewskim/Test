# claude-skills

Custom slash commands for Claude Code with enhanced safety and workflow features.

**Improvements from official Anthropic commands:**
- ✅ Branch safety (prevents commits directly to main/master)
- ✅ Ticket number support with auto-uppercase
- ✅ Detailed PR descriptions with structured format
- ✅ Single-message execution for reliability
- ✅ Restricted tool permissions for security
- ✅ Smart ticket extraction from branch names

## Installation

To use these commands, copy the `commands/` directory to your Claude Code commands directory:

### Project-Level Commands (shared with team via git)
```bash
cp commands/*.md /path/to/your/project/.claude/commands/
```

### Personal Commands (available in all projects)
```bash
mkdir -p ~/.claude/commands
cp commands/*.md ~/.claude/commands/
```

## Available Commands

### `/commit` - Create Git Commit

Creates a git commit with auto-generated message and optional ticket number.

**Usage:**
```bash
# Without ticket number
/commit

# With ticket number (automatically uppercased)
/commit ext-123
```

**Features:**
- **Branch safety**: Automatically creates new feature branch if on main/master
- Automatically stages all changes (`git add .`)
- Analyzes diff to generate descriptive commit message
- Supports ticket number prefix: `[EXT-123] commit message`
- Uppercases ticket number automatically (ext-123 → EXT-123)
- Single-message execution (all operations in one response)
- Restricted tool permissions for safety
- Does NOT push to remote (manual push required)
- Does NOT mention Claude or Claude Code in messages

**Examples:**

1. Simple commit without ticket:
   ```bash
   /commit
   # Result: "add user authentication feature"
   ```

2. Commit with ticket number:
   ```bash
   /commit ext-456
   # Result: "[EXT-456] fix login validation bug"
   ```

3. Different ticket formats (all work):
   ```bash
   /commit ext-123      # → [EXT-123] ...
   /commit EXT-123      # → [EXT-123] ...
   /commit jira-456     # → [JIRA-456] ...
   ```

**What it does:**
1. Checks if on main/master branch
2. Creates new feature branch if needed (prevents commits directly to main)
3. Stages all changes
4. Analyzes git diff
5. Generates commit message
6. Formats with ticket number if provided
7. Creates commit locally
8. Shows commit hash and message

**What it does NOT do:**
- Push to remote (you push manually)
- Create PRs
- Run tests
- Modify files

### `/pr` - Create Pull Request

Creates a GitHub pull request with auto-generated title, detailed description, and ticket number detection.

**Usage:**
```bash
# Create PR to master
/pr master

# Create PR to develop
/pr develop

# Create PR to any branch
/pr staging
```

**Features:**
- Auto-generates PR title from recent commits
- Creates detailed PR description with summary, changes, and testing notes
- Extracts ticket number from branch name (e.g., `feature/ext-123-login` → `[EXT-123]`)
- Automatically pushes current branch to remote
- Force pushes with `--force-with-lease` if branch already exists
- Opens PR in browser automatically
- Single-message execution (all operations in one response)
- Restricted tool permissions for safety
- Handles GitHub authentication and errors gracefully

**Examples:**

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

**What it does:**
1. Validates target branch argument
2. Extracts ticket number from current branch name
3. Analyzes commit history and changes
4. Generates descriptive PR title and detailed description
5. Pushes current branch to remote (force-with-lease if needed)
6. Creates PR using GitHub CLI (`gh pr create`)
7. Opens PR in browser
8. Displays PR URL and details

**What it does NOT do:**
- Merge the PR (manual review required)
- Run CI/CD tests
- Request reviewers automatically
- Create draft PRs (creates regular PRs)

**Requirements:**
- GitHub CLI (`gh`) must be installed
- Must be authenticated with GitHub (`gh auth login`)
- Must be in a git repository
- Target branch must exist

**PR Description Format:**
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

## Command Structure

Slash commands are Markdown files with YAML frontmatter:

```markdown
---
description: Brief description for /help
argument-hint: [optional-args]
allowed-tools: Bash(git *), Read
---

# Instructions for Claude

Use !`command` to execute bash and capture output.
Use $ARGUMENTS to access command arguments.

Your task instructions here...
```

## Best Practices

1. **Keep it simple**: Slash commands are for quick prompts, not complex workflows
2. **Use allowed-tools**: Restrict which tools the command can use for safety
3. **Capture context**: Use `!` commands to get current state (git status, file contents, etc.)
4. **Clear instructions**: Tell Claude exactly what to do step-by-step
5. **Test before sharing**: Try the command locally before committing to git

## Creating New Commands

1. Create a new `.md` file in the `commands/` directory
2. Add YAML frontmatter with description and allowed tools
3. Write clear instructions for Claude
4. Test it by copying to `.claude/commands/`
5. Once verified, commit to git for team sharing

## Resources

- [Claude Code Documentation](https://docs.anthropic.com/claude-code)
- [Slash Commands Guide](https://docs.anthropic.com/claude-code/guides/slash-commands)
- [YAML Frontmatter Options](https://docs.anthropic.com/claude-code/reference/slash-commands)

---

**Maintained By**: EMP Development Team
**Last Updated**: December 2025
