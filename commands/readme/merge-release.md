# Merge Release PR

Merge an approved release Pull Request into the target branch with comprehensive safety checks.

## Usage

```bash
/merge-release [release-branch]
```

## Arguments

- `release-branch` (optional) - Release branch to merge (e.g., `release/v1.0.2` or just `v1.0.2`)

If no argument provided, enters interactive mode showing all open release PRs.

## Examples

**Interactive mode:**
```bash
/merge-release
# Lists all open release PRs and lets you choose
```

**Specify release branch:**
```bash
/merge-release release/v1.0.2
# Merges PR for release/v1.0.2
```

**Short form:**
```bash
/merge-release v1.0.2
# Automatically expands to release/v1.0.2
```

## What It Does

1. **Finds the release PR**
   - Looks for PR from specified release branch
   - Or lists all open release PRs (interactive mode)
   - Shows PR status and details

2. **Verifies PR can be merged safely**
   - ✓ Checks for required approvals
   - ✓ Validates CI/CD checks are passing
   - ✓ Ensures no merge conflicts
   - ✓ Confirms PR is in OPEN state

3. **Confirms before merging**
   - Shows summary of PR status
   - Asks for confirmation
   - Allows aborting if needed

4. **Merges the PR**
   - Uses merge commit strategy (preserves history)
   - Does NOT delete release branch (keeps for reference)
   - Reports merge commit SHA

5. **Provides next steps**
   - Suggests creating GitHub release
   - Reminds about tagging
   - Lists deployment considerations

## Safety Checks

### Review Status

**✓ APPROVED:** PR has required approvals
```
✓ Approved by 2 reviewers
```

**✗ CHANGES_REQUESTED:** Cannot merge
```
✗ Changes requested by reviewers
Address feedback before merging
```

**⚠ REVIEW_REQUIRED:** No approvals yet
```
⚠ Warning: PR has not been approved yet
Would you like to:
[w] Wait and check again
[m] Merge anyway (not recommended)
[a] Abort
```

### CI/CD Checks

**✓ Passing:** All checks successful
```
✓ All 5 checks passing
```

**✗ Failing:** Some checks failed
```
✗ Some checks failing:
- unit-tests (3 failures)
- integration-tests (1 failure)
```

**⏳ Running:** Tests in progress
```
⏳ CI/CD checks still running
Waiting for checks to complete...
```

### Merge Conflicts

**✓ MERGEABLE:** No conflicts
```
✓ No merge conflicts
```

**✗ CONFLICTING:** Has conflicts
```
✗ Merge conflicts detected

To resolve:
1. git checkout release/v1.0.2
2. git merge master
3. Resolve conflicts
4. git push
5. Run /merge-release again
```

## Interactive Workflow

When run without arguments:

```
Available release PRs:

[1] PR #42: Release v1.0.2
    release/v1.0.2 → master
    Status: ✓ Approved, ✓ Checks passing

[2] PR #43: Release v1.0.1-hotfix
    release/v1.0.1-hotfix → master
    Status: ⚠ Awaiting approval

Which release PR would you like to merge?
Enter number or release branch name:
```

## Merge Confirmation

Before merging, shows comprehensive summary:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Ready to Merge Release
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

PR #42: Release v1.0.2
release/v1.0.2 → master

Status:
  ✓ Approved by 2 reviewers
  ✓ All 5 checks passing
  ✓ No merge conflicts

URL: https://github.com/user/repo/pull/42

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Proceed with merge? [y/n]
```

## Post-Merge Actions

After successful merge:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Release Merged Successfully
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✓ Merged release/v1.0.2 into master

PR #42: Release v1.0.2
Merge commit: abc1234

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Next Steps
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. Create GitHub release:
   /release

2. Tag the release:
   git tag v1.0.2
   git push origin v1.0.2

3. Deploy to production
4. Monitor production metrics
5. Communicate release to team
```

## Error Handling

**No PR found:**
```
✗ No PR found for 'release/v1.0.2'

Create a release PR first:
  /create-release master v1.0.2
```

**PR not approved:**
```
✗ Cannot merge: PR requires approval

Get required approvals before merging.
```

**Checks failing:**
```
✗ Cannot merge: CI/CD checks failing

Fix the issues and try again.
```

**Already merged:**
```
✓ PR #42 is already merged

The release has been successfully merged to master.
```

**No open release PRs:**
```
✗ No open release PRs found

To create a release PR:
  /create-release
```

## Merge Strategy

Uses **merge commit** strategy:
- Preserves full commit history
- Creates explicit merge commit
- Recommended for releases
- Does NOT squash commits
- Does NOT delete release branch

**Why merge commits for releases?**
- Clear history of what was released
- Easy to revert if needed
- Preserves individual commit context
- Industry standard for releases

## Branch Management

**Release branches are NOT deleted after merge:**
- Kept for historical reference
- Useful for debugging production issues
- Can be used to recreate release tags
- Easy to compare with future releases

**To delete manually (if needed):**
```bash
git branch -d release/v1.0.2
git push origin --delete release/v1.0.2
```

## Integration with Workflow

Part of the complete release workflow:

```bash
# 1. Create release PR
/create-release master v1.0.2

# 2. Review and approve on GitHub
# (Team reviews the PR)

# 3. Merge the approved release
/merge-release v1.0.2

# 4. Create GitHub release
/release v1.0.2

# 5. Deploy to production
```

## Requirements

- **GitHub CLI** (`gh`) must be installed and authenticated
- **Write access** to the repository
- **Branch protection rules** may require admin override

## Installation

Run the installer:
```bash
./install-commands.sh
```

Or manually copy:
```bash
cp commands/commands/merge-release.md .claude/commands/
```

## Tips

- **Always wait for approvals**: Don't merge unapproved releases
- **Check CI/CD status**: Ensure all tests pass
- **Resolve conflicts early**: Don't merge with conflicts
- **Tag immediately**: Create git tag right after merge
- **Keep release branches**: Don't delete for historical reference
- **Document deployment**: Note any special deployment steps

## Troubleshooting

**Permission denied:**
```
✗ Insufficient permissions to merge

Contact a repository admin or merge manually on GitHub.
```

**Solution:** Ask admin to merge or get write access

**Checks stuck:**
```
⏳ CI/CD checks are still running

Checks have been running for 20 minutes.
```

**Solution:** Check CI/CD logs, may need to restart builds

**Stale approvals:**
```
⚠ Approvals may be stale after new commits
```

**Solution:** Re-request reviews from approvers

## Related Commands

- `/create-release` - Create release PR
- `/release` - Create GitHub release with tags
- `/pr` - Create regular feature PR
- `/sync-branch` - Keep branches up-to-date
