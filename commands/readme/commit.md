# `/commit` - Create Git Commit

Creates a git commit with auto-generated message and optional ticket number.

## Usage

```bash
# Without ticket number (extracts from branch name if available)
/commit

# With ticket number (override branch extraction)
/commit ext-123

# On feature branch (ticket automatically extracted)
/new-ticket ext-456
# ... make changes ...
/commit  # Automatically uses [ext-456] prefix from branch name
```

## Features

- **Branch safety**: Automatically creates new feature branch if on main/master
- **Automatic ticket number**: Extracts ticket from branch name (`feature/*`, `fix/*`, `hotfix/*`)
- Automatically stages all changes (`git add .`)
- Analyzes diff to generate descriptive commit message
- Supports ticket number prefix (preserves casing): `[ext-123] commit message`
- Manual ticket override: Can provide ticket as argument to override branch extraction
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

2. Commit with explicit ticket number:
   ```bash
   /commit ext-456
   # Result: "[ext-456] fix login validation bug"
   ```

3. Commit on feature branch (ticket extracted from branch):
   ```bash
   /new-ticket ext-789
   # ... make changes ...
   /commit
   # Result: "[ext-789] add user profile page"
   ```

4. Override branch extraction:
   ```bash
   # On branch feature/ext-111
   # ... make changes for different ticket ...
   /commit ext-222  # Override with different ticket
   # Result: "[ext-222] fix critical bug"
   ```

5. Different ticket formats (all work, casing preserved):
   ```bash
   /commit ext-123      # → [ext-123] ...
   /commit EXT-123      # → [EXT-123] ...
   /commit jira-456     # → [jira-456] ...
   ```

## What it does

1. Checks if on main/master branch
2. Creates new feature branch if needed (prevents commits directly to main)
3. Determines ticket number (from argument OR extracted from branch name)
4. Stages all changes
5. Analyzes git diff
6. Generates commit message
7. Formats with ticket number if available
8. Creates commit locally
9. Shows commit hash and message

## Ticket Number Priority

The command determines the ticket number in this order:
1. **Argument**: If you provide a ticket as argument (`/commit ext-123`), use that
2. **Branch name**: If no argument, extract from branch name (e.g., `feature/ext-123-description` → `ext-123`)
   - Supports `feature/*`, `fix/*`, `hotfix/*` patterns
   - Extracts ticket up to first dash after numbers
3. **None**: If neither available, create commit without ticket prefix

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

## Integration with `/new-ticket`

When you use `/new-ticket` to start work on a ticket:
1. It creates a feature branch: `feature/<ticket-number>`
2. All subsequent `/commit` commands automatically extract the ticket number from the branch name
3. You can override by providing an argument: `/commit other-ticket`

**Workflow example:**
```bash
/new-ticket ext-500 release/v3.2.0  # Creates branch feature/ext-500
# ... make changes ...
/commit                              # Extracts [ext-500] from branch name
# ... make more changes ...
/commit                              # Still extracts [ext-500]
/commit urgent-fix                   # Override with [urgent-fix]
```

**Branch name patterns:**
- `feature/ext-2232-some-updates` → extracts `ext-2232`
- `fix/JIRA-456-bug-fix` → extracts `JIRA-456`
- `hotfix/ABC-123-critical` → extracts `ABC-123`

## Related Commands

- **[/new-ticket](new-ticket.md)** - Start work on a new ticket (stores ticket number)
- **[/pr](pr.md)** - Create pull requests
- **[/pr-review](pr-review.md)** - Review pull requests
