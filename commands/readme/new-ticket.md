# `/new-ticket` - Start Work on New Ticket

Creates a new feature branch for a ticket and stores the ticket number for automatic use in commits.

## Usage

```bash
# Start work on a ticket, branching from master (default)
/new-ticket ext-1234

# Start work on a ticket, branching from a specific branch
/new-ticket ext-1234 release/v3.2.0

# Start work on a ticket, branching from develop
/new-ticket JIRA-456 develop
```

## Features

- **Automatic branch creation**: Creates `feature/<ticket-number>` branch
- **Flexible base branch**: Choose which branch to branch from (defaults to master)
- **Smart ticket extraction**: `/commit` automatically extracts ticket from branch name
- **Branch validation**: Checks if base branch exists before creating new branch
- **Casing preservation**: Keeps ticket number exactly as provided
- **Integrated workflow**: Works seamlessly with `/commit` and `/pr` commands

## Arguments

1. **ticket-number** (REQUIRED): The ticket identifier
   - Examples: `ext-1234`, `EXT-1234`, `JIRA-456`, `abc-789`
   - Casing is preserved exactly as provided
   - Will be used as the branch name: `feature/<ticket-number>`

2. **base-branch** (OPTIONAL): The branch to branch from
   - Defaults to `master` if not provided
   - Examples: `release/v3.2.0`, `develop`, `main`, `staging`
   - Must be an existing branch

## Examples

### Example 1: Simple ticket on master

```bash
/new-ticket ext-1234
```

**Result:**
- Creates branch: `feature/ext-1234` from `master`
- Next `/commit` will automatically extract and use `[ext-1234]` prefix from branch name

### Example 2: Ticket on release branch

```bash
/new-ticket EXT-5678 release/v3.2.0
```

**Result:**
- Creates branch: `feature/EXT-5678` from `release/v3.2.0`
- Next `/commit` will automatically extract and use `[EXT-5678]` prefix from branch name

### Example 3: Full workflow

```bash
# 1. Start work on ticket
/new-ticket ext-999 develop

# 2. Make your changes
# ... edit files ...

# 3. Commit (ticket number automatically added)
/commit
# Result: "[ext-999] add user profile page"

# 4. Make more changes
# ... edit more files ...

# 5. Commit again (still uses same ticket)
/commit
# Result: "[ext-999] add profile validation"

# 6. Create pull request
/pr develop
# Result: PR titled "[EXT-999] Add user profile page with validation"
```

## What it does

1. **Validates arguments**: Ensures ticket number is provided
2. **Checks base branch**: Verifies base branch exists
3. **Fetches latest**: Gets latest changes from base branch (if remote exists)
4. **Creates branch**: Creates and checks out `feature/<ticket-number>` from base branch
5. **Reports success**: Shows branch name, base, and next steps

## What it does NOT do

- Push the new branch (you push when ready)
- Make any commits
- Modify any files
- Create pull requests

## Integration with other commands

### `/commit` command
After using `/new-ticket`, the `/commit` command will automatically:
- Extract the ticket number from the branch name
- Add `[ticket-number]` prefix to commit messages
- Supports `feature/*`, `fix/*`, `hotfix/*` patterns
- Intelligently extracts ticket (e.g., `feature/ext-2232-description` → `ext-2232`)
- You can still override by providing a different ticket: `/commit other-ticket`

### `/pr` command
The `/pr` command will:
- Extract ticket number from branch name `feature/ext-1234`
- Convert to uppercase for PR title: `[EXT-1234]`
- Include in PR title automatically

## Error Handling

### No ticket number provided
```bash
/new-ticket
```
**Error:** "Error: Ticket number is required. Usage: /new-ticket <ticket-number> [base-branch]"

### Base branch doesn't exist
```bash
/new-ticket ext-123 nonexistent-branch
```
**Error:** "Error: Base branch 'nonexistent-branch' does not exist. Available branches: [list]"

### Branch already exists
If `feature/ext-123` already exists, you'll be asked whether to:
- Switch to the existing branch
- Delete and recreate it

## Installation

Copy the command file to your Claude Code commands directory:

```bash
# Project-level (shared with team via git)
cp commands/commands/new-ticket.md /path/to/your/project/.claude/commands/

# Personal (available in all projects)
mkdir -p ~/.claude/commands
cp commands/commands/new-ticket.md ~/.claude/commands/
```

## Tips

1. **Use with team workflows**: Store in `.claude/commands/` and commit to git to share with team
2. **Consistent naming**: Always use the same ticket format your team uses (e.g., always lowercase or uppercase)
3. **Base branch**: For hotfixes on production, use the production branch as base
4. **Branch descriptions**: You can add descriptions to branch names (e.g., `feature/ext-123-add-auth`) - the ticket will still be extracted correctly

## Ticket Extraction

The `/commit` command automatically extracts the ticket number from your branch name:
- Works with `feature/*`, `fix/*`, and `hotfix/*` branches
- Extracts ticket up to the first dash after numbers
- Examples:
  - `feature/ext-2232-some-updates` → extracts `ext-2232`
  - `fix/JIRA-456-bug-fix` → extracts `JIRA-456`
  - `hotfix/ABC-123-critical` → extracts `ABC-123`
- No file storage needed - everything is based on branch naming

## Related Commands

- **[/commit](commit.md)** - Create commits with automatic ticket number
- **[/pr](pr.md)** - Create pull requests (extracts ticket from branch name)
- **[/review-pr](review-pr.md)** - Review pull requests
