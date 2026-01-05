# `/release` - Create GitHub Release

Creates a new GitHub release with automatic version detection, tag creation, and release notes generation. Supports both regular releases and pre-releases (release candidates).

## Usage

```bash
# Interactive wizard (recommended)
/release

# With version specified
/release v1.0.2

# With version and branch
/release v1.0.2 origin/master

# Create pre-release
/release v1.0.2-rc.1 release/v1.0.2 --pre-release
```

## Features

- **Interactive wizard**: Guides you through version, branch, and release type selection
- **Smart version detection**: Auto-detects version from merged commits or branch names
- **Two release workflows**: Regular releases from master, pre-releases from release branches
- **Auto-generated release notes**: Creates changelog from git commits since last release
- **Pre-release support**: Creates GitHub pre-releases for release candidates (RC)
- **Branch normalization**: Handles "main" vs "origin/main", "master" vs "origin/master"
- **Tag management**: Automatically creates and pushes git tags
- **Version validation**: Ensures proper Semantic Versioning format
- **Confirmation steps**: Asks for confirmation before creating release
- **Safe execution**: Validates branch exists, tag doesn't exist, proper format

## Release Workflows

### Workflow 1: Regular Release (from `origin/master`)

Regular releases are created from the `origin/master` branch after a release branch has been merged.

**Process:**
1. Merge `release/vX.Y.Z` branch into master
2. Run `/release` command
3. Command finds the merged release branch in commit history
4. Extracts version from the branch name (e.g., `release/v1.0.2` → `v1.0.2`)
5. Creates regular GitHub release with tag `v1.0.2`

**Example:**
```bash
# On master branch after merging release/v1.0.2
/release

# Wizard will:
# - Detect "v1.0.2" from merged "release/v1.0.2" commit
# - Default branch to "origin/master"
# - Default pre-release to "No"
# - Ask for confirmation
# - Create release v1.0.2
```

### Workflow 2: Pre-Release (from `release/*` branch)

Pre-releases (release candidates) are created from `release/*` branches for testing before the final release.

**Process:**
1. Create `release/vX.Y.Z` branch
2. Make changes and test
3. Run `/release` command from the release branch
4. Command extracts version from branch name
5. Checks for existing RC tags and suggests next number
6. Creates GitHub pre-release with tag `vX.Y.Z-rc.N`

**Example:**
```bash
# On release/v1.0.2 branch
/release

# Wizard will:
# - Detect "v1.0.2" from branch name
# - Default branch to "release/v1.0.2"
# - Default pre-release to "Yes"
# - Suggest "v1.0.2-rc.1" (or rc.2, rc.3, etc. if previous RCs exist)
# - Ask for confirmation
# - Create pre-release v1.0.2-rc.1
```

## Interactive Wizard

The command uses an interactive wizard with sensible defaults:

### Question 1: Branch Selection

```
Which branch should this release be created from?

○ origin/master (Recommended)
○ release/v1.0.2
○ Other
```

**Default:**
- `origin/master` if no arguments provided
- Detected from current branch if on a release branch
- Provided as argument if specified

### Question 2: Pre-Release Flag

```
Is this a pre-release (RC) or a regular release?

○ No - Regular release (Recommended)
○ Yes - Pre-release (RC)
```

**Default:**
- NO if branch is `origin/master`
- YES if branch is `release/*`
- Can be overridden with `--pre-release` flag

### Question 3: Version Selection

```
What version should be released?

○ v1.0.2 (Recommended)
○ v1.0.3
○ v1.1.0
○ v2.0.0
○ Other
```

**Default (Regular Release):**
- Extracted from most recent "merged release/vX.Y.Z" commit on master
- Falls back to latest tag + patch bump if no merge found

**Default (Pre-Release):**
- Extracted from branch name (e.g., `release/v1.0.2` → `v1.0.2-rc.1`)
- Increments RC number if previous RCs exist (rc.1 → rc.2 → rc.3)

### Final Confirmation

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Release Summary
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Version: v1.0.2
Branch: origin/master
Type: Regular Release

This will:
  • Create tag: v1.0.2
  • Create GitHub release from: origin/master
  • Generate release notes automatically

Proceed with release creation? (yes/no)

○ Yes, create release
○ No, cancel
```

## Examples

### Example 1: Regular Release from Master

```bash
# Scenario: release/v1.0.2 was merged to master
# You're on master branch

/release

# Wizard flow:
# 1. Branch: origin/master (detected)
# 2. Pre-release: No (default for master)
# 3. Version: v1.0.2 (detected from merge commit)
# 4. Confirm: Yes

# Result:
✓ Release Created Successfully

Version: v1.0.2
Type: Regular Release
Branch: origin/master
Tag: v1.0.2

Release URL: https://github.com/user/repo/releases/tag/v1.0.2
```

### Example 2: First Release Candidate

```bash
# Scenario: You created release/v1.0.2 branch
# Ready to create first RC for testing

git checkout release/v1.0.2
/release

# Wizard flow:
# 1. Branch: release/v1.0.2 (detected)
# 2. Pre-release: Yes (default for release branch)
# 3. Version: v1.0.2-rc.1 (first RC)
# 4. Confirm: Yes

# Result:
✓ Pre-Release Created Successfully

Version: v1.0.2-rc.1
Type: Pre-Release (RC)
Branch: release/v1.0.2
Tag: v1.0.2-rc.1

Release URL: https://github.com/user/repo/releases/tag/v1.0.2-rc.1

⚠️  This is a pre-release and will be marked as such on GitHub.
```

### Example 3: Second Release Candidate

```bash
# Scenario: v1.0.2-rc.1 exists, you fixed bugs
# Ready to create second RC

git checkout release/v1.0.2
/release

# Wizard flow:
# 1. Branch: release/v1.0.2 (detected)
# 2. Pre-release: Yes (default for release branch)
# 3. Version: v1.0.2-rc.2 (incremented from rc.1)
# 4. Confirm: Yes

# Result:
✓ Pre-Release Created Successfully

Version: v1.0.2-rc.2
Type: Pre-Release (RC)
Branch: release/v1.0.2
Tag: v1.0.2-rc.2
```

### Example 4: Manual Version Override

```bash
# Scenario: Want to specify custom version

/release v2.0.0 origin/master

# Wizard flow:
# 1. Branch: origin/master (provided)
# 2. Pre-release: No (default for master)
# 3. Version: v2.0.0 (provided, but can change in wizard)
# 4. Confirm: Yes

# Result: Creates v2.0.0 release
```

## Version Format

The command follows **Semantic Versioning** with `v` prefix:

### Regular Releases
- Format: `vX.Y.Z`
- Examples: `v1.0.0`, `v1.0.2`, `v1.1.0`, `v2.0.0`
- Must NOT include `-rc` suffix

### Pre-Releases (Release Candidates)
- Format: `vX.Y.Z-rc.N`
- Examples: `v1.0.2-rc.1`, `v1.0.2-rc.2`, `v2.0.0-rc.1`
- Must include `-rc.N` suffix
- RC number increments: rc.1 → rc.2 → rc.3

**Auto-correction:**
- If you provide `1.0.2`, it becomes `v1.0.2`
- If pre-release is YES and version is `v1.0.2`, you'll be prompted to add `-rc.N`

## Auto-Generated Release Notes

The command automatically generates release notes from git commits:

**Process:**
1. Finds the previous release tag
2. Gets all commits between previous tag and current branch
3. Groups commits by type (if using conventional commits)
4. Generates markdown changelog

**Example Output:**
```markdown
## What's Changed

### Features
- Add user authentication with JWT
- Implement password reset flow

### Bug Fixes
- Fix memory leak in data processor
- Resolve race condition in API handler

### Documentation
- Update API documentation
- Add deployment guide

### Other Changes
- Refactor database connection logic
- Update dependencies

**Full Changelog**: https://github.com/user/repo/compare/v1.0.1...v1.0.2
```

**Commit Type Detection:**
- `feat:` → Features
- `fix:` → Bug Fixes
- `docs:` → Documentation
- `perf:` → Performance
- Other → Other Changes

## What it does

1. **Parse arguments** (optional): version, branch, pre-release flag
2. **Determine defaults**:
   - Default branch (origin/master or current branch)
   - Default pre-release flag (based on branch)
   - Default version (from merged commits or branch name)
3. **Interactive wizard**: Ask user to confirm/override defaults
4. **Validate inputs**:
   - Branch exists
   - Version format is correct
   - Tag doesn't already exist
   - Release workflow is valid (e.g., regular release from master)
5. **Show confirmation summary**
6. **Generate release notes** from git commits
7. **Create GitHub release** with tag using `gh release create`
8. **Display success message** with release URL

## What it does NOT do

- Merge branches (you must merge release branches manually)
- Build or compile code
- Run tests
- Deploy releases
- Delete tags or releases
- Modify existing releases

## Requirements

- GitHub CLI (`gh`) must be installed and authenticated
- Must be in a git repository
- Must have push access to the repository
- Branch must exist (local or remote)

## Error Handling

The command validates and handles errors gracefully:

- **Tag already exists**: Prompts for different version
- **Branch doesn't exist**: Shows available branches
- **Invalid version format**: Shows format examples
- **GitHub CLI not installed**: Shows installation instructions
- **Not authenticated**: Shows `gh auth login` instructions
- **Regular release from non-master branch**: Shows warning and asks for confirmation
- **Pre-release without -rc suffix**: Prompts to add RC number

## Installation

Copy the command files to your Claude Code commands directory:

```bash
# Project-level (shared with team via git)
cp commands/commands/release.md /path/to/your/project/.claude/commands/
cp commands/readme/release.md /path/to/your/project/.claude/commands/readme/

# Personal (available in all projects)
mkdir -p ~/.claude/commands
mkdir -p ~/.claude/commands/readme
cp commands/commands/release.md ~/.claude/commands/
cp commands/readme/release.md ~/.claude/commands/readme/
```

## Best Practices

1. **Regular Releases**:
   - Always create from `origin/master`
   - Ensure release branch is merged first
   - Version should match the merged release branch

2. **Pre-Releases**:
   - Create from `release/*` branch
   - Test thoroughly before final release
   - Increment RC number for each iteration
   - Create regular release only after RC testing is complete

3. **Version Numbers**:
   - Follow Semantic Versioning
   - Patch (vX.Y.Z+1): Bug fixes only
   - Minor (vX.Y+1.0): New features, backward compatible
   - Major (vX+1.0.0): Breaking changes

4. **Release Notes**:
   - Use conventional commits for better grouping
   - Review auto-generated notes before confirming
   - Add manual notes if needed (edit on GitHub after creation)

## Troubleshooting

**"Tag already exists"**
- Choose a different version number
- Or delete the existing tag: `git tag -d vX.Y.Z && git push origin :refs/tags/vX.Y.Z`

**"Branch not found"**
- Check branch name spelling
- Fetch latest: `git fetch origin`
- List branches: `git branch -a`

**"No commits since last release"**
- Verify you're on the correct branch
- Check if you've made commits: `git log`
- Proceed anyway if intentional (e.g., documentation-only release)

**"GitHub CLI not found"**
- Install: `brew install gh` (macOS) or see https://cli.github.com/
- Authenticate: `gh auth login`

**"Permission denied"**
- Ensure you have push access to the repository
- Check GitHub authentication: `gh auth status`
