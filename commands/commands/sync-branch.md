---
description: Sync current branch with target branch
argument-hint: [target-branch] [--rebase|--ff-only|--dry-run]
allowed-tools: Bash(git status:*), Bash(git fetch:*), Bash(git merge:*), Bash(git rebase:*), Bash(git stash:*), Bash(git log:*), Bash(git rev-list:*), Bash(git branch:*), Bash(git diff:*), Bash(git remote:*), AskUserQuestion
---

# Sync Branch Command

## Context

Current branch: !`git branch --show-current`

Git status: !`git status --short`

Recent commits: !`git log --oneline -5`

Remote branches: !`git branch -r | head -10`

## Your Task

**IMPORTANT**: You MUST complete all steps in a single message using parallel tool calls where possible. Do not send multiple messages.

This command keeps your feature branch up-to-date with a target branch (typically main/master/develop/release/*) by merging or rebasing the latest changes.

### 1. Parse Arguments

Arguments are provided in $ARGUMENTS with these possible formats:

**Target branch (optional):**
- `main` - Sync with main branch
- `develop` - Sync with develop branch
- `release/v3.2.0` - Sync with release branch
- No argument - Auto-detect or ask user

**Strategy flags (optional):**
- `--rebase` - Use rebase instead of merge
- `--ff-only` - Only fast-forward, fail if diverged
- `--dry-run` - Show what would happen without executing

**Examples:**
- `/sync-branch main` - Merge main into current branch
- `/sync-branch develop --rebase` - Rebase current branch onto develop
- `/sync-branch release/v3.2.0` - Merge release branch into current branch
- `/sync-branch --dry-run` - Preview sync with auto-detected target
- `/sync-branch main --ff-only` - Only update if no divergence

**Parse logic:**
1. Extract target branch name (first non-flag argument)
2. Check for `--rebase` flag → use rebase strategy
3. Check for `--ff-only` flag → use fast-forward only
4. Check for `--dry-run` flag → preview mode
5. Default strategy: merge (safest for most users)

### 2. Validate Current Branch

Check that we're not on a protected branch:

```bash
current_branch=$(git branch --show-current)
```

**If on main/master/develop:**
```
✗ Cannot sync protected branch '${current_branch}'

You're on a protected branch. Sync is for feature branches only.

To update this branch:
  git fetch origin ${current_branch}
  git merge origin/${current_branch}
```

Stop execution - do not proceed.

### 3. Check Working Directory

Determine if there are uncommitted changes:

```bash
git status --porcelain
```

**If working directory is dirty (has changes):**

Use AskUserQuestion to ask:
```
⚠ You have uncommitted changes

Options:
[s] Stash changes and sync (will restore after)
[c] Commit changes first (run /commit)
[a] Abort sync

Choose:
```

**Handle responses:**

- **'s' or 'stash'**:
  ```bash
  git stash push -m "Auto-stash before sync-branch"
  # Remember to pop stash after sync
  ```
  Continue to next step

- **'c' or 'commit'**:
  ```
  Please commit your changes first using /commit, then run /sync-branch again
  ```
  Stop execution

- **'a' or 'abort'**:
  ```
  Sync cancelled
  ```
  Stop execution

**If working directory is clean:**
Continue to next step

### 4. Determine Target Branch

**Priority order:**

1. **If target branch provided in $ARGUMENTS**: Use it
2. **If no target provided**: Auto-detect from branch name pattern
3. **If auto-detection fails**: Ask user

**Auto-detection logic:**

```bash
current_branch=$(git branch --show-current)

# Pattern: feature/*, bugfix/*, hotfix/* → likely branched from main/master or release/*
# Pattern: release/* → cannot auto-detect (is a target branch itself)
# Check which default branch exists
```

**Detection steps:**
1. Check if `main` branch exists: `git rev-parse --verify main 2>/dev/null`
2. Check if `master` branch exists: `git rev-parse --verify master 2>/dev/null`
3. Check if `develop` branch exists: `git rev-parse --verify develop 2>/dev/null`
4. Check for release branches: `git branch -r | grep 'origin/release/' | sed 's|origin/||'`
5. Use the first default branch found (main/master/develop)

**If auto-detection succeeds:**
```
Auto-detected target branch: main
```

**If auto-detection fails:**

List all available target branches and ask user:

```bash
# Get list of branches
default_branches=$(git branch -a | grep -E '(main|master|develop)' | sed 's|remotes/origin/||' | sort -u)
release_branches=$(git branch -r | grep 'origin/release/' | sed 's|origin/||' | sort -rn | head -5)
```

Use AskUserQuestion to ask:
```
Which branch should we sync with?

Default branches:
${default_branches}

Recent release branches:
${release_branches}

Enter target branch:
```

Parse response and validate the branch exists.

### 5. Fetch Latest Changes

Before syncing, fetch the latest from remote:

```bash
git fetch origin ${target_branch}
```

**Show progress:**
```
Fetching latest changes from origin/${target_branch}...
```

**Handle errors:**
- Network failure: Retry once after 2 seconds
- Branch doesn't exist on remote: Show error and list available branches
- Authentication failure: Show `git fetch` error and suggest checking credentials

### 6. Check Divergence

Analyze how the branches have diverged:

```bash
# How many commits behind
behind=$(git rev-list --count HEAD..origin/${target_branch})

# How many commits ahead (our feature commits)
ahead=$(git rev-list --count origin/${target_branch}..HEAD)

# Check if branches have diverged
diverged=$(git merge-base HEAD origin/${target_branch})
```

**Display divergence:**

```
Current branch: ${current_branch}
Target branch:  ${target_branch}

Status:
  ↓ Behind by ${behind} commits
  ↑ Ahead by ${ahead} commits
```

**Special cases:**

- **Behind = 0, Ahead = 0**:
  ```
  ✓ Your branch is up-to-date with ${target_branch}

  No sync needed!
  ```
  Stop execution (success)

- **Behind = 0, Ahead > 0**:
  ```
  ✓ Your branch is up-to-date with ${target_branch}

  You have ${ahead} local commits ready to push.
  ```
  Stop execution (success)

- **Behind > 0, Ahead = 0**:
  ```
  Your branch is ${behind} commits behind ${target_branch}

  This will be a fast-forward merge (safe and clean).
  ```
  Continue to sync

- **Behind > 0, Ahead > 0**:
  ```
  Your branch has diverged from ${target_branch}:
    ↓ ${behind} new commits in ${target_branch}
    ↑ ${ahead} commits in your branch

  Strategy: ${strategy} (merge/rebase)
  ```
  Continue to sync

### 7. Dry Run Mode

**If --dry-run flag was provided:**

Show what would happen but don't execute:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
DRY RUN - No changes will be made
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Would sync: ${current_branch}
With: ${target_branch}
Strategy: ${strategy}

Changes to incorporate:
${show recent commits from target_branch that would be merged}

Your commits (would be preserved):
${show commits in current branch not in target}

To execute: /sync-branch ${target_branch} [--rebase]
```

Stop execution (dry run complete)

### 8. Execute Sync

Based on strategy, execute the appropriate git operation.

#### Strategy: Merge (default)

```bash
git merge origin/${target_branch}
```

**Show progress:**
```
Merging origin/${target_branch} into ${current_branch}...
```

**On success (no conflicts):**
```
✓ Successfully merged origin/${target_branch} into ${current_branch}

Incorporated ${behind} commits from ${target_branch}
```

**On conflict:**
Go to section 9 (Handle Conflicts)

#### Strategy: Rebase

**Important**: Rebase rewrites commit history. Create backup first.

```bash
# Create backup branch
git branch ${current_branch}-backup-$(date +%s)

# Rebase onto target
git rebase origin/${target_branch}
```

**Show progress:**
```
Creating backup: ${current_branch}-backup-${timestamp}
Rebasing ${current_branch} onto origin/${target_branch}...
```

**On success:**
```
✓ Successfully rebased ${current_branch} onto origin/${target_branch}

Replayed ${ahead} commits on top of ${target_branch}

⚠ Note: Branch history has been rewritten
  - Backup created: ${current_branch}-backup-${timestamp}
  - You'll need to force push: git push --force-with-lease
```

**On conflict:**
Go to section 9 (Handle Conflicts)

#### Strategy: Fast-Forward Only

```bash
git merge --ff-only origin/${target_branch}
```

**On success:**
```
✓ Fast-forwarded to origin/${target_branch}
```

**On failure (diverged):**
```
✗ Cannot fast-forward - branches have diverged

Your branch has ${ahead} commits not in ${target_branch}

Options:
  /sync-branch ${target_branch}           # Merge (creates merge commit)
  /sync-branch ${target_branch} --rebase  # Rebase (rewrites history)
```

Stop execution

### 9. Handle Conflicts

**When conflicts occur during merge or rebase:**

```bash
# List conflicted files
conflicted_files=$(git diff --name-only --diff-filter=U)
conflict_count=$(echo "$conflicted_files" | wc -l)
```

**Display conflict information:**

```
⚠ Merge conflicts detected in ${conflict_count} files:

${conflicted_files}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Conflict Resolution Options
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Use AskUserQuestion to ask:
```
How would you like to proceed?

[r] Resolve manually (will pause here - resolve conflicts then continue)
[a] Abort sync (revert to state before sync)
[s] Show conflict details

Choose:
```

**Handle responses:**

- **'r' or 'resolve'**:
  ```
  Pausing for manual conflict resolution...

  Steps to resolve:
  1. Edit the conflicted files listed above
  2. Look for conflict markers: <<<<<<<, =======, >>>>>>>
  3. Choose which changes to keep
  4. Remove conflict markers
  5. Stage resolved files: git add <file>
  6. Continue:
     - For merge: git merge --continue
     - For rebase: git rebase --continue

  Current status: git status
  ```
  Stop execution (user will continue manually)

- **'a' or 'abort'**:
  ```bash
  # Abort based on strategy
  if merge:
    git merge --abort
  if rebase:
    git rebase --abort
  ```
  ```
  ✓ Sync aborted - your branch is unchanged
  ```
  Stop execution

- **'s' or 'show'**:
  ```bash
  # Show detailed conflict info
  git diff --diff-filter=U
  ```
  Display conflicts, then ask the question again

### 10. Post-Sync Actions

**After successful sync (if we had stashed changes):**

```bash
# Restore stashed changes
git stash pop
```

**If stash pop has conflicts:**
```
⚠ Your stashed changes conflict with the sync

Conflicts in:
${list files}

Resolve conflicts manually and run: git stash drop
```

**If stash pop succeeds:**
```
✓ Restored your uncommitted changes
```

### 11. Show Summary

After successful sync, show comprehensive summary:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Sync Complete
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Branch: ${current_branch}
Synced with: origin/${target_branch}
Strategy: ${strategy}

Changes:
  ✓ Incorporated ${behind} commits from ${target_branch}
  ✓ Preserved ${ahead} local commits

Updated files: ${file_count}
```

**List recently incorporated commits:**
```bash
git log HEAD~${behind}..origin/${target_branch} --oneline
```

Display as:
```
Recent commits from ${target_branch}:
  abc123 Add user authentication
  def456 Fix database migration
  ... and ${behind - 2} more
```

### 12. Next Steps Suggestions

Based on the situation, suggest next steps:

**If using merge strategy:**
```
Next steps:
  ✓ Run tests: /lint && npm test (or your test command)
  ✓ Push updated branch: git push
  ✓ Continue development
```

**If using rebase strategy:**
```
Next steps:
  ⚠ Branch history was rewritten
  ✓ Run tests: /lint && npm test
  ✓ Force push: git push --force-with-lease
  ⚠ Notify team members if branch is shared

Backup available: ${current_branch}-backup-${timestamp}
```

**If behind by many commits (>10):**
```
Suggestion:
  Your branch was significantly behind (${behind} commits)
  Consider running dependency updates:
  - npm install (if package.json changed)
  - composer install (if composer.json changed)
```

**If conflicts were resolved:**
```
Reminder:
  Conflicts were resolved - verify the merge:
  - Review changed files: git diff HEAD~1
  - Run tests: /lint
  - Test functionality manually
```

### 13. Offer to Push

**If sync was successful and no rebase was used:**

Use AskUserQuestion to ask:
```
Would you like to push the updated branch to remote? [y/n]
```

**If 'y' or 'yes':**
```bash
git push
```

Show result

**If 'n' or 'no':**
```
Branch updated locally. Push when ready: git push
```

**If rebase was used:**

Don't ask - just remind about force push:
```
Remember to force push: git push --force-with-lease
```

### 14. Error Handling

Handle these error cases gracefully:

**Target branch doesn't exist:**
```
✗ Branch '${target_branch}' not found

Available branches:
${git branch -a | grep -v HEAD}

Usage: /sync-branch <target-branch>
```

**Not a git repository:**
```
✗ Not a git repository

Initialize: git init
```

**Detached HEAD state:**
```
✗ You're in detached HEAD state

Checkout a branch first: git checkout <branch-name>
```

**Remote fetch fails:**
```
✗ Failed to fetch from remote

Check:
  - Network connection
  - Remote URL: git remote -v
  - Authentication: git fetch origin
```

**Already in sync operation:**
```
✗ A merge/rebase is already in progress

Complete or abort the current operation:
  - Continue: git merge --continue (or git rebase --continue)
  - Abort: git merge --abort (or git rebase --abort)
```

## Important Notes

- **Single message execution**: Complete all operations in ONE response
- **Safety first**: Check working directory, create backups for rebase
- **Clear communication**: Show divergence, explain what will happen
- **Merge is default**: Safer for beginners, preserves history
- **Rebase is optional**: Cleaner history but rewrites commits
- **Stash handling**: Save and restore user's uncommitted work
- **Conflict guidance**: Provide clear steps for resolution
- **Post-sync validation**: Suggest running tests and reviewing changes

## Examples

**Example 1: Simple sync (merge)**
```
User: /sync-branch main

✓ Working directory clean
Fetching latest changes from origin/main...
✓ Fetched

Status:
  ↓ Behind by 5 commits
  ↑ Ahead by 3 commits

Merging origin/main into feature/ext-123...
✓ Successfully merged

Next steps:
  ✓ Run tests
  ✓ Push: git push
```

**Example 2: Rebase strategy**
```
User: /sync-branch develop --rebase

Creating backup: feature/ext-456-backup-1701234567
Rebasing feature/ext-456 onto origin/develop...
✓ Successfully rebased

⚠ Branch history rewritten
  Force push required: git push --force-with-lease
```

**Example 3: Uncommitted changes**
```
User: /sync-branch main

⚠ You have uncommitted changes

Options:
[s] Stash and sync
[c] Commit first
[a] Abort

User: s

✓ Stashed 3 files
Syncing with main...
✓ Merged successfully
✓ Restored stashed changes
```

**Example 4: Conflicts**
```
User: /sync-branch main

⚠ Merge conflicts in 2 files:
  - src/api/client.ts
  - src/utils/helper.js

[r] Resolve manually
[a] Abort
[s] Show details

User: r

Pausing for manual resolution...

Steps:
1. Edit conflicted files
2. git add <file>
3. git merge --continue
```
