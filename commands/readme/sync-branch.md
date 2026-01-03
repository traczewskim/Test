# /sync-branch - Branch Synchronization

Keep your feature branch up-to-date with the latest changes from main, develop, or any target branch.

## Overview

The `/sync-branch` command updates your current branch with changes from a target branch (main/master/develop or release branches like release/v3.2.0). It handles divergence, uncommitted changes, conflicts, and provides clear guidance throughout the process.

## Usage

```bash
# Auto-detect target branch and sync
/sync-branch

# Sync with specific branch (merge strategy)
/sync-branch main
/sync-branch develop
/sync-branch release/v3.2.0

# Use rebase instead of merge
/sync-branch main --rebase
/sync-branch release/v3.2.0 --rebase

# Preview what would happen
/sync-branch main --dry-run

# Only fast-forward (fail if diverged)
/sync-branch main --ff-only
```

## When to Use

### Daily Development

Keep your feature branch current while working on long-running features:

```bash
# Monday: Start feature
/new-ticket ext-123

# Wednesday: Sync with latest main
/sync-branch main

# Continue development with latest code
```

### Before Creating PR

Ensure your branch is up-to-date before requesting review:

```bash
# Sync with target branch
/sync-branch main

# Run tests
/lint && npm test

# Create PR
/pr main
```

### After Team Pushes

When teammates merge to main and you need their changes:

```bash
# They merged authentication feature
# You need it for your work

/sync-branch main
# ✓ Now you have their changes
```

### Working with Release Branches

Keep feature branches synced with release branches during release cycles:

```bash
# Scenario: Features merge to release/v3.2.0 branch

# Start feature for release 3.2.0
/new-ticket ext-456

# Work on feature
# ... changes ...
/commit

# Sync with release branch (not main)
/sync-branch release/v3.2.0

# Continue development
# ... more changes ...
/commit

# Final sync before PR
/sync-branch release/v3.2.0

# Create PR to release branch
/pr release/v3.2.0
```

**Common release workflows:**
- Feature branches → release/vX.Y.Z → main
- Sync with release branch to get other features in the same release
- Release branches are integration points during release preparation

## How It Works

### 1. Safety Checks

Before syncing, the command validates:
- Not on a protected branch (main/master/develop)
- Working directory state (uncommitted changes)
- Target branch exists
- Network connectivity for fetch

### 2. Divergence Analysis

Shows exactly how branches differ:

```
Status:
  ↓ Behind by 5 commits  (new changes in main)
  ↑ Ahead by 3 commits   (your feature commits)
```

### 3. Sync Execution

Merges or rebases based on strategy:
- **Merge** (default): Creates merge commit, preserves history
- **Rebase**: Replays your commits on top, cleaner history
- **Fast-forward**: Only if no divergence

### 4. Conflict Resolution

If conflicts occur, provides clear guidance:
- Lists conflicted files
- Shows resolution steps
- Offers to abort safely

## Strategies Explained

### Merge Strategy (Default)

**What it does:**
```
      A---B---C  feature/ext-123 (your branch)
     /
D---E---F---G  main

# After merge:
      A---B---C---M  feature/ext-123
     /           /
D---E---F---G----  main
```

**Pros:**
- ✅ Safe - preserves all history
- ✅ Easy to understand
- ✅ No force push needed
- ✅ Good for shared branches

**Cons:**
- ❌ Creates merge commit
- ❌ History can get messy

**Use when:**
- Working on shared feature branch
- Unsure about rebase
- Want to preserve exact history

### Rebase Strategy

**What it does:**
```
      A---B---C  feature/ext-123 (your branch)
     /
D---E---F---G  main

# After rebase:
              A'---B'---C'  feature/ext-123
             /
D---E---F---G  main
```

**Pros:**
- ✅ Clean, linear history
- ✅ No merge commits
- ✅ Easier to understand in git log

**Cons:**
- ❌ Rewrites commit history
- ❌ Requires force push
- ❌ Can be confusing for beginners

**Use when:**
- Working alone on feature branch
- Want clean history
- Comfortable with git rebase

**Important:** Creates backup branch before rebasing

### Fast-Forward Only

**What it does:**
Only updates if no divergence (you haven't made commits):

```
      (no commits)  feature/ext-123
     /
D---E---F---G  main

# After ff-only:
D---E---F---G  feature/ext-123 AND main
```

**Use when:**
- Want to update local branch
- Haven't made any commits yet
- Want to ensure no merge/rebase needed

## Examples

### Example 1: Simple Sync

You've been working on a feature and main has moved forward:

```bash
/sync-branch main
```

```
Fetching latest changes from origin/main...
✓ Fetched

Status:
  ↓ Behind by 5 commits
  ↑ Ahead by 3 commits

Merging origin/main into feature/ext-123...
✓ Successfully merged origin/main into feature/ext-123

Incorporated 5 commits from main

Recent commits from main:
  abc123 Add authentication middleware
  def456 Update database schema
  ... and 3 more

Next steps:
  ✓ Run tests: /lint && npm test
  ✓ Push updated branch: git push

Would you like to push the updated branch to remote? [y/n]
```

### Example 2: With Uncommitted Changes

You have work in progress:

```bash
/sync-branch main
```

```
⚠ You have uncommitted changes

  M  src/components/Button.tsx
  M  src/utils/format.js
  ?? src/NewFile.tsx

Options:
[s] Stash changes and sync (will restore after)
[c] Commit changes first (run /commit)
[a] Abort sync

Choose: s

✓ Stashed 3 files
Fetching latest changes from origin/main...
✓ Fetched
Merging origin/main...
✓ Successfully merged
✓ Restored your uncommitted changes

All set! Your changes are back and branch is synced.
```

### Example 3: Rebase for Clean History

You want a linear history:

```bash
/sync-branch develop --rebase
```

```
Creating backup: feature/ext-456-backup-1701234567
Rebasing feature/ext-456 onto origin/develop...
✓ Successfully rebased feature/ext-456 onto origin/develop

Replayed 3 commits on top of develop

⚠ Note: Branch history has been rewritten
  - Backup created: feature/ext-456-backup-1701234567
  - You'll need to force push: git push --force-with-lease

Next steps:
  ⚠ Branch history was rewritten
  ✓ Run tests: /lint && npm test
  ✓ Force push: git push --force-with-lease
  ⚠ Notify team members if branch is shared

Backup available: feature/ext-456-backup-1701234567
```

### Example 4: Handling Conflicts

Changes in main conflict with your work:

```bash
/sync-branch main
```

```
Merging origin/main into feature/ext-123...

⚠ Merge conflicts detected in 2 files:

  src/api/client.ts
  src/components/Header.tsx

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Conflict Resolution Options
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

How would you like to proceed?

[r] Resolve manually (will pause here)
[a] Abort sync (revert to state before sync)
[s] Show conflict details

Choose: r

Pausing for manual conflict resolution...

Steps to resolve:
1. Edit the conflicted files listed above
2. Look for conflict markers: <<<<<<<, =======, >>>>>>>
3. Choose which changes to keep
4. Remove conflict markers
5. Stage resolved files: git add <file>
6. Continue: git merge --continue

Current status shows conflicts - resolve them and continue.
```

### Example 5: Dry Run (Preview)

See what would happen without making changes:

```bash
/sync-branch main --dry-run
```

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
DRY RUN - No changes will be made
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Would sync: feature/ext-123
With: main
Strategy: merge

Changes to incorporate:
  abc123 Add authentication middleware
  def456 Update database schema
  789abc Fix user profile bug
  ... and 2 more

Your commits (would be preserved):
  111aaa Implement new feature
  222bbb Add tests
  333ccc Update docs

To execute: /sync-branch main
```

### Example 6: Already Up-to-Date

Your branch is current:

```bash
/sync-branch main
```

```
Fetching latest changes from origin/main...
✓ Fetched

Status:
  ↓ Behind by 0 commits
  ↑ Ahead by 3 commits

✓ Your branch is up-to-date with main

You have 3 local commits ready to push.
```

### Example 7: Syncing with Release Branch

Working on a feature for a specific release:

```bash
/sync-branch release/v3.2.0
```

```
Fetching latest changes from origin/release/v3.2.0...
✓ Fetched

Status:
  ↓ Behind by 8 commits
  ↑ Ahead by 2 commits

Your branch has diverged from release/v3.2.0:
  ↓ 8 new commits in release/v3.2.0
  ↑ 2 commits in your branch

Strategy: merge

Merging origin/release/v3.2.0 into feature/ext-456...
✓ Successfully merged origin/release/v3.2.0 into feature/ext-456

Incorporated 8 commits from release/v3.2.0

Recent commits from release/v3.2.0:
  abc123 Add user profile feature
  def456 Update payment integration
  789ghi Fix authentication bug
  ... and 5 more

Next steps:
  ✓ Run tests: /lint && npm test
  ✓ Push updated branch: git push

Would you like to push the updated branch to remote? [y/n]
```

**Why sync with release branches:**
- Get other features being released in the same version
- Ensure compatibility with features already merged to release
- Integration testing before release goes out

## Workflow Integration

### Complete Development Workflow

```bash
# 1. Start new feature
/new-ticket ext-123 main

# 2. Work on feature (day 1)
# ... make changes ...
/commit
/commit

# 3. Sync with main (day 2, main has updates)
/sync-branch main

# 4. Continue work
# ... more changes ...
/commit

# 5. Pre-PR sync (ensure latest)
/sync-branch main

# 6. Quality checks
/lint --fix

# 7. Create PR
/pr main
```

### Long-Running Feature Branches

For features that take multiple days/weeks:

```bash
# Monday
/new-ticket ext-big-feature

# Wednesday (sync with main)
/sync-branch main

# Friday (sync again)
/sync-branch main

# Next week Monday (sync again)
/sync-branch main

# Finally done
/pr main
```

Regular syncing keeps your branch manageable and reduces merge conflicts.

## Advanced Usage

### Auto-Detection

When you don't specify a target branch:

```bash
/sync-branch
```

The command auto-detects based on:
1. Branch naming patterns (feature/* → main, release/* → develop)
2. Available default branches (prefers main, then master, then develop)
3. Asks if detection fails

### Multiple Sync Strategies

Compare different strategies:

```bash
# Option 1: Merge (default)
/sync-branch main
# Creates merge commit, preserves history

# Option 2: Rebase
/sync-branch main --rebase
# Linear history, cleaner log

# Option 3: Preview first
/sync-branch main --dry-run
# See what would happen
```

### Dependency Updates After Sync

If package files changed:

```bash
/sync-branch main

# Command shows:
Suggestion:
  Your branch was significantly behind (15 commits)
  Consider running dependency updates:
  - npm install (if package.json changed)
  - composer install (if composer.json changed)

# Then run updates:
npm install
composer install
```

## Troubleshooting

### "Cannot sync protected branch"

**Issue:**
```
✗ Cannot sync protected branch 'main'
```

**Cause:** You're on main/master/develop

**Fix:** Checkout feature branch first
```bash
git checkout feature/ext-123
/sync-branch main
```

### "Branch has diverged" with --ff-only

**Issue:**
```
✗ Cannot fast-forward - branches have diverged
```

**Cause:** You have commits not in target branch

**Fix:** Use merge or rebase
```bash
/sync-branch main          # Merge strategy
/sync-branch main --rebase # Rebase strategy
```

### Conflicts After Stash Pop

**Issue:**
```
⚠ Your stashed changes conflict with the sync
```

**Cause:** Your uncommitted changes conflict with merged code

**Fix:** Resolve conflicts manually
```bash
# Edit conflicted files
# Then drop the stash
git stash drop
```

### Failed to Fetch

**Issue:**
```
✗ Failed to fetch from remote
```

**Possible causes:**
- Network down
- Remote URL wrong
- Authentication failed

**Fix:**
```bash
# Check network
ping github.com

# Check remote
git remote -v

# Test fetch manually
git fetch origin

# Re-authenticate if needed
git config credential.helper store
```

### Rebase Conflicts

**Issue:** Conflicts during rebase are harder to resolve

**Why:** Rebase applies commits one-by-one, can have multiple conflict points

**Fix:**
```bash
# Option 1: Abort and use merge
git rebase --abort
/sync-branch main  # Uses merge instead

# Option 2: Continue rebase
# Resolve conflicts
git add <resolved-files>
git rebase --continue
```

## Best Practices

### 1. Sync Regularly

Don't let your branch get too far behind:

```bash
# Bad: Sync after 2 weeks
# Result: 50+ commits behind, many conflicts

# Good: Sync every 2-3 days
# Result: 5-10 commits behind, fewer conflicts
```

### 2. Commit Before Syncing

While stashing works, committing is cleaner:

```bash
# Before sync
/commit

# Then sync
/sync-branch main

# Cleaner history, easier to track
```

### 3. Test After Syncing

Always verify after incorporating changes:

```bash
/sync-branch main

# Run quality checks
/lint

# Run tests
npm test

# Manual testing
npm start
```

### 4. Choose Strategy Based on Context

**Use merge when:**
- Branch is shared with others
- Preserving exact history matters
- Unsure about rebase

**Use rebase when:**
- Working alone
- Want clean history for PR
- Comfortable with git

### 5. Communicate Rebases

If you rebase a shared branch:

```bash
/sync-branch main --rebase

# Notify team:
# "Rebased feature/ext-123, please re-pull"

# Team members need:
git fetch
git reset --hard origin/feature/ext-123
```

## Comparison with Manual Git

| Manual Git | /sync-branch |
|-----------|--------------|
| `git fetch origin main` | Auto-fetches |
| `git status` (check dirty) | Auto-checks |
| `git merge origin/main` | Auto-merges |
| Check for conflicts manually | Auto-detects conflicts |
| Remember to stash | Offers to stash |
| Figure out divergence | Shows divergence clearly |
| Remember force-push after rebase | Reminds about force-push |

**The command handles the entire workflow**, not just one git command.

## Safety Features

### 1. Protected Branch Check
Won't let you sync main/master/develop

### 2. Working Directory Validation
Checks for uncommitted changes, offers to stash

### 3. Backup Before Rebase
Creates `feature-backup-timestamp` branch

### 4. Clear Conflict Guidance
Step-by-step resolution instructions

### 5. Dry Run Mode
Preview without making changes

### 6. Force-Push Warnings
Reminds about --force-with-lease after rebase

## Related Commands

- **/new-ticket** - Create feature branch (start of workflow)
- **/commit** - Commit changes (before syncing)
- **/lint** - Check code quality (after syncing)
- **/pr** - Create pull request (after final sync)

## Common Patterns

### Pattern 1: Daily Sync Routine

```bash
# Morning: Get latest
/sync-branch main

# Work
# ... changes ...
/commit

# Before leaving: Sync again if needed
/sync-branch main
```

### Pattern 2: Pre-PR Checklist

```bash
# 1. Final sync
/sync-branch main

# 2. Quality check
/lint --fix

# 3. Tests
npm test

# 4. Create PR
/pr main
```

### Pattern 3: Conflict Resolution

```bash
# Sync
/sync-branch main

# Conflicts detected
# [r] Resolve manually

# Resolve in editor
# Stage files
git add src/conflicted-file.ts

# Continue
git merge --continue

# Verify
/lint
npm test
```

## Tips

### Tip 1: Preview Big Merges

If main is many commits ahead, preview first:

```bash
/sync-branch main --dry-run
# Review what changes would come in
# Then execute
/sync-branch main
```

### Tip 2: Keep Backups

Rebase creates automatic backups:

```bash
/sync-branch main --rebase
# Creates: feature/ext-123-backup-1701234567

# If something goes wrong:
git reset --hard feature/ext-123-backup-1701234567
```

### Tip 3: Sync Before Long Work

Starting a big change? Sync first:

```bash
# Get latest
/sync-branch main

# Now work on big feature
# Starting from latest code = fewer future conflicts
```

### Tip 4: Test Immediately

Don't wait to discover sync broke something:

```bash
/sync-branch main
# ✓ Merged

# Test RIGHT NOW
/lint
npm test
npm start

# Find issues early
```

## FAQ

**Q: What's the difference between merge and rebase?**

A: Merge creates a merge commit and preserves history. Rebase replays your commits on top of target, creating linear history. Merge is safer, rebase is cleaner.

**Q: When should I use --rebase?**

A: When you want clean history and are working alone on the branch. Don't rebase shared branches without coordinating with your team.

**Q: What if I have uncommitted changes?**

A: Command offers to stash them automatically, syncs, then restores them.

**Q: Can I abort mid-sync?**

A: Yes, if conflicts occur, choose [a] abort. If already started, run `git merge --abort` or `git rebase --abort`.

**Q: How often should I sync?**

A: Every 2-3 days for long-running branches, or whenever main has changes you need.

**Q: What if sync creates conflicts?**

A: Command pauses and provides resolution steps. Fix conflicts, stage files, and continue the merge/rebase.

**Q: Is it safe?**

A: Yes. Command checks working directory, creates backups (for rebase), and allows aborting at any time.

## See Also

- [Git Merge Documentation](https://git-scm.com/docs/git-merge)
- [Git Rebase Documentation](https://git-scm.com/docs/git-rebase)
- [Resolving Merge Conflicts](https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging)
