---
description: Create a git commit with optional ticket number
argument-hint: [ticket-number]
allowed-tools: Bash(git add:*), Bash(git commit:*), Bash(git status:*), Bash(git branch:*), Bash(git checkout:*), Bash(git log:*)
---

# Git Commit Command

## Context

Current repository status: !`git status`

Current git diff (staged and unstaged changes): !`git diff HEAD 2>/dev/null || git diff --cached`

Recent commits for reference: !`git log --oneline -5 2>/dev/null || echo "No previous commits (this will be the first commit)"`

Current branch: !`git branch --show-current`

## Your Task

**IMPORTANT**: You MUST complete all steps in a single message using parallel tool calls. Do not send multiple messages.

1. **Check branch safety**:
   - If current branch is `main` or `master`, create a new feature branch first
   - Branch naming: If ticket number provided, use `feature/[ticket]-description`, otherwise `feature/[description]`
   - Use `git checkout -b [branch-name]`

2. **Stage all changes**: Run `git add .` to stage all modified and new files

3. **Analyze the changes**: Review the git diff to understand what was changed

4. **Generate commit message**: Create a clear, concise commit message that describes the changes
   - Focus on what changed and why
   - Use imperative mood (e.g., "add feature" not "added feature")
   - Keep it under 72 characters if possible
   - Common patterns:
     - "add [feature/functionality]"
     - "fix [issue/bug]"
     - "update [component/file]"
     - "refactor [code/module]"
     - "remove [unused/deprecated]"
     - "improve [performance/structure]"
   - DO NOT mention Claude or Claude Code in the commit message

5. **Format with ticket number** (if provided):
   - Ticket number argument: $ARGUMENTS
   - If ticket number is provided:
     - Use the ticket number exactly as provided (preserve original casing)
     - Format: `[TICKET-NUMBER] commit message`
     - Example: `[ext-123] add user authentication`
   - If no ticket number provided:
     - Format: `commit message` (no prefix)
     - Example: `update documentation`

6. **Create the commit**:
   - Use ONLY the commit message generated in step 4 (with ticket prefix if provided)
   - Do NOT add any footers, attribution, or "Generated with Claude Code" text
   - Do NOT add "Co-Authored-By" lines
   - Format: `git commit -m "commit message"` (simple, single-line message only)
   - Example: `git commit -m "add user authentication"` or `git commit -m "[ext-123] fix login bug"`

7. **Report results**: Show the commit hash and message

## Important Notes

- **Execute all operations in ONE message** - do not send multiple responses
- Check if on main/master and create new branch if so
- Stage all changes before analyzing
- Generate ONE clear commit message
- **CRITICAL**: Commit messages must be clean and simple - NO footers, NO attribution, NO "Generated with Claude Code", NO "Co-Authored-By" lines
- Do NOT push to remote (user will do this manually)
- Keep messages professional and descriptive
