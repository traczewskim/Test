# /compare-branch - Branch Comparison

Compare two branches to see their differences in commits, files, contributors, and tickets.

## Overview

The `/compare-branch` command provides comprehensive comparison between two git branches, showing unique commits, file changes, contributors, and extracted ticket numbers. Essential for release planning, code review, and understanding branch divergence.

## Usage

```bash
# Compare two specific branches
/compare-branch release/v3.2.0 release/v3.1.0

# Compare branch with main (auto-detect)
/compare-branch release/v3.2.0

# Compare current branch with main
/compare-branch

# Summary view only
/compare-branch release/v3.2.0 main --summary

# Focus on file changes
/compare-branch feature/ext-123 main --files

# Focus on commit history
/compare-branch release/v3.2.0 release/v3.1.0 --commits
```

## When to Use

### Release Planning

See what's going into a new release:

```bash
# Compare release candidate with previous release
/compare-branch release/v3.2.0 release/v3.1.0

# Shows:
# - New features (commits)
# - Files changed
# - Contributors
# - Tickets included
```

### Before Merging

Understand the impact before merging branches:

```bash
# What will change if I merge this feature?
/compare-branch feature/big-refactor main

# Review:
# - How many commits will be added
# - Which files will change
# - Potential conflicts
```

### Code Review

Review what's different between branches:

```bash
# Review teammate's branch
/compare-branch feature/user-auth main --detailed

# See complete picture:
# - All commits
# - Every file touched
# - Who contributed
```

### Track Progress

See how far ahead your branch is:

```bash
# On feature branch
/compare-branch

# Shows:
# - Your commits vs main
# - What changed in main since you branched
# - Divergence status
```

## Output Modes

### Detailed Mode (Default)

Complete comparison with all information:

```bash
/compare-branch release/v3.2.0 release/v3.1.0
```

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Branch Comparison
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Comparing: release/v3.2.0 ↔ release/v3.1.0

Common ancestor: abc1234
  Merge pull request #42 from feature/setup

Divergence: Linear (v3.2.0 is ahead)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
release/v3.2.0 (45 commits ahead)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Commits (showing latest 10):
  def456 Add user authentication system
  789abc Implement payment integration
  111bbb Fix profile page layout
  222ccc Update database schema
  333ddd Add email verification
  ... and 40 more

File Changes:
  15 files added
  23 files modified
  3 files deleted

  Files changed (showing top 10):
  A  src/auth/LoginService.php
  A  src/auth/TokenManager.php
  M  src/user/ProfileController.php
  M  config/database.php
  D  legacy/OldAuthSystem.php
  ... and 31 more

Contributors:
  25  John Doe
  12  Jane Smith
  8   Bob Johnson

Tickets:
  EXT-123, EXT-456, EXT-789
  JIRA-12, JIRA-34, JIRA-56

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
release/v3.1.0 (0 commits ahead)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

No unique commits

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Comparison Summary
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Relationship: Linear - v3.2.0 is ahead of v3.1.0

release/v3.2.0:
  45 unique commits
  41 files changed
  3 contributors
  8 tickets

release/v3.1.0:
  0 unique commits
  (direct ancestor of v3.2.0)

To update v3.1.0 to v3.2.0:
  git checkout release/v3.1.0
  git merge --ff-only release/v3.2.0
```

### Summary Mode

Quick overview without details:

```bash
/compare-branch release/v3.2.0 release/v3.1.0 --summary
```

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Branch Comparison Summary
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

release/v3.2.0 vs release/v3.1.0

release/v3.2.0: 45 commits, 41 files, 3 people
release/v3.1.0: 0 commits (ancestor)

Divergence: Linear

Use /compare-branch release/v3.2.0 release/v3.1.0 for detailed comparison
```

### Files Mode

Focus on file changes only:

```bash
/compare-branch feature/refactor main --files
```

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
File Changes: feature/refactor vs main
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Files in feature/refactor (not in main):

  Added (5 files):
    src/services/NewAuthService.php
    src/models/UserToken.php
    tests/AuthServiceTest.php
    config/auth.php
    docs/authentication.md

  Modified (12 files):
    src/controllers/UserController.php
    src/middleware/AuthMiddleware.php
    composer.json
    ... and 9 more

  Deleted (2 files):
    legacy/OldAuth.php
    legacy/SessionManager.php

Files in main (not in feature/refactor):

  Modified (3 files):
    README.md
    config/app.php
    package.json

Total file divergence: 22 files differ
```

### Commits Mode

Focus on commit history:

```bash
/compare-branch release/v3.2.0 release/v3.1.0 --commits
```

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Commit History: release/v3.2.0 vs release/v3.1.0
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Commits only in release/v3.2.0 (45 total):

  Recent commits:
  def456  2025-01-03  John Doe     [EXT-789] Add user authentication
  789abc  2025-01-02  Jane Smith   [EXT-456] Implement payment system
  111bbb  2025-01-02  John Doe     [EXT-123] Fix profile page
  222ccc  2025-01-01  Bob Johnson  Update database schema
  ... and 41 more

  First commit in this release:
  aaa111  2024-12-15  Alice Wong   [EXT-100] Initial v3.2.0 setup

Commits only in release/v3.1.0 (0 total):

  (None - v3.1.0 is ancestor)

Common ancestor:
  base99  2024-12-10  David Chen   Release v3.1.0

Diverged: 24 days ago
```

## Examples

### Example 1: Compare Release Branches

Planning a release - see what's new:

```bash
/compare-branch release/v3.2.0 release/v3.1.0
```

**Use case:** Release notes, changelog generation, stakeholder updates

**Shows:**
- All new features (commits)
- Files touched
- Team members who contributed
- Jira/ticket numbers for tracking

### Example 2: Compare Feature with Main

Before creating PR - understand changes:

```bash
/compare-branch feature/ext-123-auth main
```

**Use case:** Pre-PR review, impact analysis

**Shows:**
- How many commits you're adding
- Which files you changed
- What changed in main while you worked

### Example 3: Check Current Branch Status

Quick status check:

```bash
# On branch: feature/ext-456
/compare-branch
```

**Use case:** Daily standup, quick sync check

**Shows:**
- Your branch vs main
- How far ahead/behind
- Whether you need to sync

### Example 4: Release Divergence Check

See if two release branches diverged:

```bash
/compare-branch release/v3.2.0 release/v3.1.5
```

**Use case:** Hotfix tracking, backport planning

**Shows:**
- Commits unique to each release
- Which fixes/features went where
- Whether branches can be merged cleanly

## Use Cases

### 1. Release Management

**Scenario:** Preparing v3.2.0 release notes

```bash
# See everything new in v3.2.0
/compare-branch release/v3.2.0 release/v3.1.0

# Extract information:
# - Feature list from commit messages
# - Ticket numbers for release notes
# - Contributors to thank
# - File impact assessment
```

### 2. Code Review Preparation

**Scenario:** Big refactoring PR coming

```bash
# Review the impact
/compare-branch feature/big-refactor main --detailed

# Understand:
# - Scope of changes (file count)
# - Complexity (commit count)
# - Risk areas (deleted files)
# - Require extra reviewers if needed
```

### 3. Merge Conflict Prevention

**Scenario:** Working on long-running feature

```bash
# Check weekly
/compare-branch feature/long-running main

# Monitor:
# - Main is getting ahead (20 commits)
# - Files changed in main: 15
# - Your files changed: 12
# - Potential conflicts: 3 overlapping files

# Action: /sync-branch main
```

### 4. Backport Planning

**Scenario:** Need to backport fix to old release

```bash
# See divergence
/compare-branch release/v3.1.5 release/v3.2.0

# Identify:
# - Which commits to cherry-pick
# - Potential conflicts
# - Dependencies between commits
```

### 5. Team Collaboration

**Scenario:** Multiple features targeting same release

```bash
# See what others added
/compare-branch release/v3.2.0 main

# Coordinate:
# - Avoid duplicate work
# - Identify integration points
# - Plan testing together
```

## Workflow Integration

### Complete Development Workflow

```bash
# Day 1: Start feature
/new-ticket ext-123

# Day 5: Check status
/compare-branch
# Output: 5 commits ahead, 0 behind

# Day 10: Check again
/compare-branch
# Output: 8 commits ahead, 12 behind (main moved forward)

# Sync with main
/sync-branch main

# Day 15: Ready for PR
/compare-branch --summary
# Output: Clean, ready to merge
/pr main
```

### Release Preparation Workflow

```bash
# Create release branch
git checkout -b release/v3.2.0

# Throughout release cycle
/compare-branch release/v3.2.0 release/v3.1.0
# Track what's being added

# Before final release
/compare-branch release/v3.2.0 main
# Ensure all changes from main are included

# Generate changelog
/compare-branch release/v3.2.0 release/v3.1.0 --commits
# Copy commit messages for release notes
```

## Understanding Output

### Divergence Types

**Linear Relationship:**
```
release/v3.2.0: 45 commits ahead
release/v3.1.0: 0 commits ahead

→ v3.2.0 is newer, can fast-forward merge
```

**Diverged Relationship:**
```
release/v3.2.0: 45 commits ahead
main: 12 commits ahead

→ Both branches have unique commits, merge needed
```

**Independent (Rare):**
```
⚠️  No common history

→ Branches created separately, unusual
```

### Relationship Indicators

- **Ahead**: Branch has commits not in other branch
- **Behind**: Other branch has commits not in this branch
- **Linear**: One branch is direct ancestor
- **Diverged**: Both have unique commits

### File Change Types

- **A (Added)**: New files created
- **M (Modified)**: Existing files changed
- **D (Deleted)**: Files removed
- **R (Renamed)**: Files moved/renamed

## Advanced Usage

### Compare Specific Commits

```bash
# Compare by commit hash
/compare-branch abc1234 def5678
```

### Compare Remote Branches

```bash
# Full remote branch names
/compare-branch origin/release/v3.2.0 origin/main
```

### Large Repositories

For repos with many differences:

```bash
# Use summary first
/compare-branch release/v3.2.0 release/v3.1.0 --summary

# Then drill into specific aspects
/compare-branch release/v3.2.0 release/v3.1.0 --files
/compare-branch release/v3.2.0 release/v3.1.0 --commits
```

## Tips

### Tip 1: Regular Comparisons

Compare weekly during long features:

```bash
# Monday morning routine
/compare-branch

# Shows if you're falling behind
# Reminds you to sync
```

### Tip 2: Pre-PR Checklist

Before creating PR:

```bash
# 1. Compare to see impact
/compare-branch feature/ext-123 main

# 2. If main is ahead, sync
/sync-branch main

# 3. Compare again to verify
/compare-branch --summary

# 4. Create PR
/pr main
```

### Tip 3: Release Notes Generation

Extract commits for release notes:

```bash
# Get full comparison
/compare-branch release/v3.2.0 release/v3.1.0 --commits

# Copy commit messages
# Group by ticket/feature
# Create release notes
```

### Tip 4: Conflict Prediction

Identify potential conflicts:

```bash
/compare-branch feature/my-work main --files

# Look for overlapping files:
# - Files you modified
# - Files that changed in main
# - Intersection = potential conflicts
```

## Troubleshooting

### "Branch not found"

**Issue:**
```
✗ Branch 'release/v3.2.0' not found
```

**Cause:** Branch name incorrect or not fetched

**Fix:**
```bash
# Fetch all branches
git fetch --all

# List available branches
git branch -a

# Use full name
/compare-branch origin/release/v3.2.0 main
```

### "Too many differences"

**Issue:** Output is overwhelming (500+ commits)

**Solution:**
```bash
# Start with summary
/compare-branch branch1 branch2 --summary

# Then focus on specific aspects
/compare-branch branch1 branch2 --files
```

### "No common ancestor"

**Issue:**
```
⚠️  No common history found
```

**Cause:** Branches created independently (rare)

**Meaning:** Branches don't share history, can't be meaningfully compared

## FAQ

**Q: What's the difference between /compare-branch and /sync-branch?**

A: `/compare-branch` shows differences (read-only), `/sync-branch` updates your branch (writes changes).

**Q: Can I compare more than 2 branches?**

A: No, but you can run multiple comparisons:
```bash
/compare-branch A B
/compare-branch B C
/compare-branch A C
```

**Q: Does this modify anything?**

A: No, `/compare-branch` is read-only. It only shows information, never changes branches.

**Q: How do I extract tickets from the output?**

A: The command auto-extracts patterns like `EXT-123`, `JIRA-456` from commit messages and lists them in the output.

**Q: What if branches are identical?**

A: Command will notify you that branches point to the same commit with no differences.

**Q: Can I compare tags?**

A: Yes, tags work like branch names:
```bash
/compare-branch v3.2.0 v3.1.0
```

## Related Commands

- **/sync-branch** - Update branch with latest changes
- **/pr** - Create pull request (after comparing)
- **/new-ticket** - Start new feature branch
- **/commit** - Commit changes

## Common Patterns

### Pattern 1: Release Comparison

```bash
# Weekly: See release progress
/compare-branch release/v3.2.0 main --summary

# Before release: Full details
/compare-branch release/v3.2.0 release/v3.1.0 --detailed
```

### Pattern 2: Feature Development Tracking

```bash
# Start feature
/new-ticket ext-123

# Day 3: Quick check
/compare-branch

# Day 7: Detailed review
/compare-branch feature/ext-123 main --detailed

# Before PR: Final check
/compare-branch --summary
/pr main
```

### Pattern 3: Merge Preparation

```bash
# Before big merge
/compare-branch feature/big-change main --files

# Identify conflicts
# Review impact

# Sync if needed
/sync-branch main

# Compare again
/compare-branch --summary
```

## See Also

- [Git Log Documentation](https://git-scm.com/docs/git-log)
- [Git Diff Documentation](https://git-scm.com/docs/git-diff)
- [Understanding Git Branches](https://git-scm.com/book/en/v2/Git-Branching-Branches-in-a-Nutshell)
