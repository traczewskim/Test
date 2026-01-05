# Create Release PR

Create a Pull Request from a release branch to target branch (usually master) with automatic ticket extraction and release label.

## Usage

```bash
/create-release [target-branch] [version]
```

## Arguments

- `target-branch` (optional) - Target branch for the PR (default: `master`)
- `version` (optional) - Version to release (e.g., `v1.0.2` or `1.0.2`)

If no arguments provided, enters interactive mode.

## Examples

**Interactive mode:**
```bash
/create-release
# Prompts for release branch and target
```

**Specify version only:**
```bash
/create-release v1.0.2
# Creates PR from release/v1.0.2 to master
```

**Specify target and version:**
```bash
/create-release master v1.0.2
# Creates PR from release/v1.0.2 to master
```

**Without 'v' prefix:**
```bash
/create-release 1.0.2
# Automatically normalizes to v1.0.2
```

## What It Does

1. **Detects or creates release branch**
   - Finds existing `release/vX.Y.Z` branch
   - Or creates new one from target branch
   - Lists available release branches if interactive

2. **Analyzes changes**
   - Compares release branch with target
   - Counts commits and changed files
   - Extracts ticket numbers from commit messages

3. **Creates Pull Request**
   - Title: `Release vX.Y.Z`
   - Adds "release" label automatically
   - Generates detailed description with:
     - Summary of changes
     - List of tickets (extracted from commits)
     - Commit history
     - Testing checklist

4. **Pushes to remote**
   - Ensures release branch is pushed
   - Handles both new and existing branches

## Interactive Workflow

When run without arguments, the command guides you through:

```
Available release branches:
- release/v1.0.2
- release/v1.0.1
- release/v0.9.5

Which release would you like to create a PR for?
[Or specify a new version]
```

## PR Description Format

The generated PR includes:

```markdown
## Release v1.0.2

This PR prepares release v1.0.2 for deployment to production.

## Changes

- Feature: User authentication
- Fix: Memory leak in data processor
- Update: Database schema

## Tickets

- JIRA-123
- JIRA-456
- JIRA-789

## Commits

abc123 [JIRA-123] add user authentication
def456 [JIRA-456] fix memory leak
...

## Testing Checklist

- [ ] All tests passing
- [ ] Manual testing completed
- [ ] Release notes reviewed
- [ ] Breaking changes documented
```

## Ticket Extraction

Automatically extracts ticket numbers from commits:

**Supported formats:**
- `[JIRA-123] commit message`
- `jira-456: commit message`
- `JIRA-789 commit message`

All tickets are normalized to uppercase and deduplicated.

## Release Branch Naming

Convention: `release/vX.Y.Z`

**Examples:**
- `release/v1.0.2`
- `release/v2.1.0`
- `release/v1.0.0-rc.1`

## Error Handling

**Release branch doesn't exist:**
```
Release branch 'release/v1.0.2' doesn't exist.

Would you like to:
[c] Create it from master
[a] Abort
```

**No changes to release:**
```
✗ No changes to release

release/v1.0.2 is up-to-date with master
```

**PR already exists:**
```
Existing PR found for this branch
PR #42: Release v1.0.2
Would you like to update it? [y/n]
```

## Next Steps

After creating the release PR:

1. **Review** the PR on GitHub
2. **Request approvals** from required reviewers
3. **Address feedback** if changes are requested
4. **Merge** using `/merge-release` once approved

## Integration with Workflow

This command is part of the release workflow:

```bash
# 1. Create release PR
/create-release master v1.0.2

# 2. Get approvals on GitHub

# 3. Merge the release
/merge-release

# 4. Create GitHub release
/release
```

## Installation

Run the installer:
```bash
./install-commands.sh
```

Or manually copy:
```bash
cp commands/commands/create-release.md .claude/commands/
```

## Tips

- **Use semantic versioning**: v1.0.2 (major.minor.patch)
- **Review commits**: Check what's included before creating PR
- **Add testing checklist**: Use the generated checklist in PR
- **Keep release branches**: Don't delete after merge (useful for reference)
- **Document breaking changes**: Note any in PR description

## Related Commands

- `/merge-release` - Merge approved release PR
- `/release` - Create GitHub release with tags and notes
- `/pr` - Create regular feature PR
- `/commit` - Commit changes with ticket numbers
