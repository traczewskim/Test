# Service Release Management Skill

## Overview
This skill manages releases for EMP services following the organization's release workflow. It handles single service releases by validating release branches, checking PRs, merging, and creating version tags according to semantic versioning rules.

## Prerequisites
- Git repository access for service repositories
- GitHub CLI (`gh`) installed and authenticated
- Write access to merge PRs and push tags
- Understanding of semantic versioning (MAJOR.MINOR.PATCH)

## Services
The following services are managed separately in individual repositories:
- `emp_api`
- `emp_config`
- `emp_builder`
- `emp_case`
- `emp_ert`
- `emp_users`
- `emp_lambdas`

## Release Types

### 1. Single Service Release
Release for an individual service repository. This is the primary focus of this skill.

**Process**: Validate → Confirm → Merge PR → Tag

### 2. Product Release
Bundles multiple service versions together in the `emp_releases` repository.
*(Product release workflow to be documented separately)*

## Release Workflow

### Branch Strategy
- Development for future releases occurs in `release/vx.y.z` branches
- Branch naming format: `release/v{MAJOR}.{MINOR}.{PATCH}`
- Examples: `release/v2.1.0`, `release/v1.0.5`, `release/v3.0.0`
- Version tracking: Git tags only (no version files in code)

### Release Request Format
User initiates with: **"create release for [service]"**

Examples:
- "create release for emp_case"
- "create release for emp_api"
- "release emp_users"

**If service is not specified**, ask the user which service to release.

## Pre-Release Checklist

When a release is requested, perform these validation steps **before** taking any action:

### 1. Check Last Released Version
```bash
# Get the latest tag from git
git describe --tags --abbrev=0 2>/dev/null
```
Report the current released version (e.g., `v2.0.5`)

### 2. Check Release Branches
```bash
# List all release/* branches
git branch -r | grep "origin/release/"
```
Identify all open `release/*` branches

### 3. Check for Pull Requests
```bash
# For each release/* branch, check if PR exists
gh pr list --head "release/v2.1.0" --json number,title,state,url
```
Report PR status: Open, Merged, or No PR found

### 4. Validate Version Number
- Extract version from `release/*` branch name
- Compare with latest tag
- **Validate semver rules**: New version must be a valid increment
  - MAJOR: Breaking changes (v2.0.0 → v3.0.0)
  - MINOR: New features (v2.0.5 → v2.1.0)
  - PATCH: Bug fixes (v2.0.5 → v2.0.6)
- Flag invalid version bumps (e.g., v2.0.5 → v2.3.0 skips v2.1.0, v2.2.0)

### 5. Confirm Findings
Present all findings to the user:
```
Service: emp_case
Latest Release: v2.0.5
Release Branch: release/v2.1.0
PR Status: #123 (Open, ready to merge)
Target Branch: master
Version Validation: ✓ Valid MINOR bump (v2.0.5 → v2.1.0)
```

**Wait for user confirmation before proceeding.**

## Release Execution

After user confirms, execute these steps:

### Step 1: Merge Pull Request
```bash
# Get PR number for the release branch
PR_NUMBER=$(gh pr list --head "release/v2.1.0" --json number -q '.[0].number')

# Check target branch
TARGET_BRANCH=$(gh pr view $PR_NUMBER --json baseRefName -q .baseRefName)

# Merge the PR
gh pr merge $PR_NUMBER --merge --delete-branch=false
```

### Step 2: Create Git Tag
```bash
# Extract version from branch name
VERSION="v2.1.0"  # from release/v2.1.0

# Checkout and update target branch
git checkout $TARGET_BRANCH
git pull origin $TARGET_BRANCH

# Tag the merge commit
git tag -a "$VERSION" -m "Release $VERSION"

# Push tag to remote
git push origin "$VERSION"
```

### Step 3: Verify Release
```bash
# Confirm tag was created and pushed
git tag -l "$VERSION"
git ls-remote --tags origin | grep "$VERSION"
```

## Implementation Example

### Complete Release Flow
```bash
#!/bin/bash
set -e

SERVICE="emp_case"
RELEASE_BRANCH="release/v2.1.0"
VERSION="v2.1.0"

echo "=== Pre-Release Checklist ==="

# 1. Get latest release
LATEST=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
echo "Latest release: $LATEST"

# 2. List release branches
echo "Release branches:"
git branch -r | grep "origin/release/" || echo "  None found"

# 3. Check for PR
echo "Checking for PR..."
PR_INFO=$(gh pr list --head "$RELEASE_BRANCH" --json number,state,baseRefName,url)
PR_NUMBER=$(echo "$PR_INFO" | jq -r '.[0].number // empty')
PR_STATE=$(echo "$PR_INFO" | jq -r '.[0].state // empty')
TARGET_BRANCH=$(echo "$PR_INFO" | jq -r '.[0].baseRefName // empty')
PR_URL=$(echo "$PR_INFO" | jq -r '.[0].url // empty')

if [ -z "$PR_NUMBER" ]; then
    echo "  ✗ No PR found for $RELEASE_BRANCH"
    exit 1
else
    echo "  ✓ PR #$PR_NUMBER ($PR_STATE)"
    echo "  URL: $PR_URL"
    echo "  Target: $TARGET_BRANCH"
fi

# 4. Validate version
echo "Version validation:"
echo "  Current: $LATEST"
echo "  Proposed: $VERSION"

# Extract version components (remove 'v' prefix)
CURRENT_VER=${LATEST#v}
NEW_VER=${VERSION#v}

IFS='.' read -r curr_major curr_minor curr_patch <<< "$CURRENT_VER"
IFS='.' read -r new_major new_minor new_patch <<< "$NEW_VER"

# Validate semver increment
VALID=false
if [ "$new_major" -gt "$curr_major" ]; then
    echo "  ✓ Valid MAJOR bump"
    VALID=true
elif [ "$new_major" -eq "$curr_major" ] && [ "$new_minor" -gt "$curr_minor" ]; then
    echo "  ✓ Valid MINOR bump"
    VALID=true
elif [ "$new_major" -eq "$curr_major" ] && [ "$new_minor" -eq "$curr_minor" ] && [ "$new_patch" -gt "$curr_patch" ]; then
    echo "  ✓ Valid PATCH bump"
    VALID=true
else
    echo "  ✗ Invalid version increment"
    exit 1
fi

# Wait for confirmation (in practice, Claude would confirm with user)
echo ""
echo "=== Ready to Release ==="
read -p "Proceed with release $VERSION for $SERVICE? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Release cancelled"
    exit 1
fi

# Merge PR
echo "Merging PR #$PR_NUMBER..."
gh pr merge "$PR_NUMBER" --merge

# Checkout and update target branch
echo "Updating $TARGET_BRANCH..."
git checkout "$TARGET_BRANCH"
git pull origin "$TARGET_BRANCH"

# Create and push tag
echo "Creating tag $VERSION..."
git tag -a "$VERSION" -m "Release $VERSION"
git push origin "$VERSION"

echo ""
echo "=== Release Complete ==="
echo "Service: $SERVICE"
echo "Version: $VERSION"
echo "Tag: $(git rev-parse $VERSION)"
echo "Release URL: https://github.com/org/$SERVICE/releases/tag/$VERSION"
```

## Response Format

### Initial Validation Report
```
🔍 Release Validation for emp_case

Latest Release: v2.0.5
Release Branches Found:
  • release/v2.1.0

PR Check:
  ✓ PR #123 (Open)
  URL: https://github.com/org/emp_case/pull/123
  Target: master

Version Validation:
  Current: v2.0.5
  Proposed: v2.1.0
  ✓ Valid MINOR bump

Ready to proceed?
```

### User Confirmation
After presenting findings, wait for explicit user approval:
- "Proceed with release v2.1.0 for emp_case?"
- "Merge PR #123 and create tag v2.1.0?"

### Post-Release Report
```
✅ Release v2.1.0 Complete

Actions Taken:
  ✓ Merged PR #123 into master (commit abc123f)
  ✓ Created tag v2.1.0 on merge commit
  ✓ Pushed tag to origin

Service: emp_case
Version: v2.1.0
Tag Commit: abc123f
Release URL: https://github.com/org/emp_case/releases/tag/v2.1.0
```

## Error Handling

### Common Issues

#### No Release Branch Found
```
✗ No release/* branches found

Action: Create a release branch first (e.g., git checkout -b release/v2.1.0)
```

#### No PR for Release Branch
```
✗ No PR found for release/v2.1.0

Action: Create a PR for the release branch before proceeding
```

#### Invalid Version Increment
```
✗ Invalid version bump: v2.0.5 → v2.3.0

Current version: v2.0.5
Proposed version: v2.3.0
Issue: Skips v2.1.0 and v2.2.0

Action: Use v2.1.0 for next minor release
```

#### Tag Already Exists
```
✗ Tag v2.1.0 already exists

Action: Version already released. Use a different version number.
```

#### Merge Conflicts
```
✗ PR #123 has merge conflicts with master

Action: Resolve conflicts in release/v2.1.0 branch before merging
```

### Validation Checks
```bash
# Check if tag already exists
if git rev-parse "v$VERSION" >/dev/null 2>&1; then
    echo "Error: Tag v$VERSION already exists"
    exit 1
fi

# Check if PR is mergeable
MERGEABLE=$(gh pr view $PR_NUMBER --json mergeable -q .mergeable)
if [ "$MERGEABLE" != "MERGEABLE" ]; then
    echo "Error: PR #$PR_NUMBER is not mergeable (conflicts or checks failing)"
    exit 1
fi

# Validate semver format
if [[ ! $VERSION =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: Invalid version format. Use vX.Y.Z (e.g., v2.1.0)"
    exit 1
fi
```

## Best Practices

### Semantic Versioning Rules
- **MAJOR (X.0.0)**: Breaking changes, incompatible API changes
- **MINOR (x.Y.0)**: New features, backwards-compatible additions
- **PATCH (x.y.Z)**: Bug fixes, backwards-compatible fixes

### Release Branch Naming
- Always use format: `release/vX.Y.Z`
- Include 'v' prefix in branch name
- Use exact version number (not ranges or wildcards)

### Tag Creation
- Use annotated tags (not lightweight tags)
- Tag the merge commit on destination branch, not release branch
- Push tags immediately after creation
- Never modify or delete existing tags

### Pre-Release Verification
- Ensure PR has passed all CI/CD checks
- Verify no merge conflicts exist
- Confirm target branch is correct (usually `master`)
- Validate version follows semver rules

### Communication
- Always present findings before taking action
- Wait for explicit user confirmation
- Report all actions taken after completion
- Provide release URL for verification

## Limitations
- Only handles single service releases (product releases separate)
- Requires existing release branch with PR
- No automatic changelog generation (per user preference)
- Cannot create release branches (must exist beforehand)
- Assumes standard GitHub workflow (PRs, merges, tags)
- Target branch must be specified in PR (skill doesn't assume)

## Quick Reference

### User Commands
```
"create release for emp_case"
"release emp_api"
"create release for emp_users"
```

### What the Skill Does
1. ✓ Identifies service (or asks if not specified)
2. ✓ Checks latest release version
3. ✓ Finds release/* branches
4. ✓ Verifies PR exists for release branch
5. ✓ Validates version follows semver rules
6. ✓ Presents findings for confirmation
7. ✓ Merges PR after user approval
8. ✓ Creates tag on merge commit
9. ✓ Pushes tag to remote
10. ✓ Reports completion with release URL

### What the Skill Does NOT Do
- ✗ Create release branches
- ✗ Create PRs
- ✗ Generate changelogs
- ✗ Update version in code files
- ✗ Trigger deployments
- ✗ Create GitHub releases (creates tags only)

---

**Version**: 2.0
**Last Updated**: December 2025
**Maintained By**: EMP Release Management Team
