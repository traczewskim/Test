---
description: Compare two branches to see differences
argument-hint: <branch1> [branch2] [--detailed|--summary|--files]
allowed-tools: Bash(git log:*), Bash(git diff:*), Bash(git rev-list:*), Bash(git branch:*), Bash(git show:*), Bash(git shortlog:*), Bash(git rev-parse:*)
---

# Compare Branch Command

## Context

Current branch: !`git branch --show-current`

Available branches: !`git branch -a | head -20`

Recent commits on current branch: !`git log --oneline -5`

## Your Task

**IMPORTANT**: You MUST complete all steps in a single message using parallel tool calls where possible. Do not send multiple messages.

This command compares two branches to show their differences, including unique commits, file changes, contributors, and tickets. Useful for release planning, understanding divergence, and reviewing what's changed.

### 1. Parse Arguments

Arguments are provided in $ARGUMENTS with these possible formats:

**Branch arguments:**
- `<branch1> <branch2>` - Compare two specific branches
- `<branch1>` - Compare branch1 with main/master (auto-detect)
- No arguments - Compare current branch with main/master

**Output format flags (optional):**
- `--detailed` - Full detailed comparison (default)
- `--summary` - Brief summary only
- `--files` - Focus on file changes
- `--commits` - Focus on commit differences

**Examples:**
- `/compare-branch release/v3.2.0 release/v3.1.0` - Compare two releases
- `/compare-branch release/v3.2.0` - Compare release with main
- `/compare-branch` - Compare current branch with main
- `/compare-branch feature/ext-123 main --files` - Show only file changes

**Parse logic:**
1. Extract branch names (non-flag arguments)
2. If 2 branches provided: Use both
3. If 1 branch provided: Compare with main/master (auto-detect)
4. If 0 branches provided: Compare current branch with main/master
5. Check for output format flags

### 2. Validate Branches

Ensure both branches exist:

```bash
# Validate branch1
git rev-parse --verify $branch1 >/dev/null 2>&1

# Validate branch2
git rev-parse --verify $branch2 >/dev/null 2>&1
```

**If branch doesn't exist:**
```
✗ Branch '$branch' not found

Available branches:
${list local and remote branches}

Usage: /compare-branch <branch1> [branch2]
```

Stop execution

**If branches are identical:**
```
Branch '$branch1' and '$branch2' point to the same commit

Nothing to compare - branches are identical
```

Stop execution (success)

### 3. Determine Comparison Direction

Identify which branch is "ahead" to provide meaningful context:

```bash
# Check if branch1 is ancestor of branch2
git merge-base --is-ancestor $branch1 $branch2

# Check if branch2 is ancestor of branch1
git merge-base --is-ancestor $branch2 $branch1
```

**Relationship types:**
- **Linear**: One branch is direct ancestor of the other
- **Diverged**: Branches have common ancestor but different commits
- **Independent**: No common history (rare)

### 4. Gather Comparison Data

Collect comprehensive information about differences:

#### A. Commit Differences

**Commits only in branch1:**
```bash
git log $branch2..$branch1 --oneline --no-merges
git rev-list --count $branch2..$branch1 --no-merges
```

**Commits only in branch2:**
```bash
git log $branch1..$branch2 --oneline --no-merges
git rev-list --count $branch1..$branch2 --no-merges
```

**Merge base (common ancestor):**
```bash
git merge-base $branch1 $branch2
git log $(git merge-base $branch1 $branch2) --oneline -1
```

#### B. File Changes

**Files changed in branch1 vs branch2:**
```bash
git diff --name-status $branch2..$branch1
git diff --stat $branch2..$branch1
```

**Files changed in branch2 vs branch1:**
```bash
git diff --name-status $branch1..$branch2
git diff --stat $branch1..$branch2
```

**Count by change type:**
```bash
# Added, Modified, Deleted files
git diff --name-status $branch2..$branch1 | awk '{print $1}' | sort | uniq -c
```

#### C. Contributors

**Contributors to branch1 (not in branch2):**
```bash
git shortlog -sn $branch2..$branch1
```

**Contributors to branch2 (not in branch1):**
```bash
git shortlog -sn $branch1..$branch2
```

#### D. Ticket Extraction

Extract ticket numbers from commit messages:

```bash
# Get all commit messages
git log $branch2..$branch1 --pretty=format:"%s"

# Extract patterns like: EXT-123, JIRA-456, [ABC-789]
# Look for: [A-Z]+-[0-9]+
```

Parse and deduplicate ticket numbers from both branches.

### 5. Display Comparison (Detailed Mode - Default)

Present comprehensive comparison in structured format:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Branch Comparison
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Comparing: ${branch1} ↔ ${branch2}

Common ancestor: ${merge_base_hash}
  ${merge_base_message}

Divergence: ${relationship_type}
```

#### Show Branch 1 Differences

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
${branch1} (${count} commits ahead)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Commits (showing latest 10):
  abc123 Add user authentication
  def456 Fix login bug
  789ghi Update profile page
  ... and ${remaining_count} more

File Changes:
  ${added_count} files added
  ${modified_count} files modified
  ${deleted_count} files deleted

  Files changed (showing top 10):
  A  src/auth/LoginService.php
  M  src/user/ProfileController.php
  D  legacy/OldAuth.php
  ... and ${remaining_files} more

Contributors:
  15  John Doe
  8   Jane Smith
  3   Bob Johnson

Tickets:
  EXT-123, EXT-456, EXT-789
  JIRA-12, JIRA-34
```

#### Show Branch 2 Differences

Repeat similar structure for branch2's unique content.

#### Summary Section

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Comparison Summary
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Relationship: ${relationship_description}

${branch1}:
  ${count1} unique commits
  ${files1} files changed
  ${contributors1} contributors
  ${tickets1} tickets

${branch2}:
  ${count2} unique commits
  ${files2} files changed
  ${contributors2} contributors
  ${tickets2} tickets

To merge ${branch1} into ${branch2}:
  git checkout ${branch2}
  git merge ${branch1}

To merge ${branch2} into ${branch1}:
  git checkout ${branch1}
  git merge ${branch2}
```

### 6. Display Comparison (Summary Mode)

When `--summary` flag is provided, show condensed view:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Branch Comparison Summary
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

${branch1} vs ${branch2}

${branch1}: ${count1} commits, ${files1} files, ${contributors1} people
${branch2}: ${count2} commits, ${files2} files, ${contributors2} people

Divergence: ${relationship_type}

Use /compare-branch ${branch1} ${branch2} for detailed comparison
```

### 7. Display Comparison (Files Mode)

When `--files` flag is provided, focus on file changes:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
File Changes: ${branch1} vs ${branch2}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Files in ${branch1} (not in ${branch2}):

  Added:
    src/auth/LoginService.php
    src/auth/TokenManager.php
    ... (${added_count} total)

  Modified:
    src/user/ProfileController.php
    config/auth.php
    ... (${modified_count} total)

  Deleted:
    legacy/OldAuth.php
    ... (${deleted_count} total)

Files in ${branch2} (not in ${branch1}):

  [Same structure as above]

Total file divergence: ${total_diverged_files} files differ
```

### 8. Display Comparison (Commits Mode)

When `--commits` flag is provided, focus on commit history:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Commit History: ${branch1} vs ${branch2}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Commits only in ${branch1} (${count1} total):

  Recent commits:
  abc123  2025-01-03  John Doe     Add user authentication
  def456  2025-01-02  Jane Smith   Fix login bug
  789ghi  2025-01-02  John Doe     Update profile page
  ... and ${remaining} more

  First commit in this branch:
  111aaa  2024-12-15  Bob Johnson  Initial feature setup

Commits only in ${branch2} (${count2} total):

  [Same structure as above]

Common ancestor:
  base99  2024-12-10  Alice Wong   Update dependencies

Diverged: ${days_diverged} days ago
```

### 9. Special Cases

#### Case: Branches Are Equal

```
✓ Branches are identical

${branch1} and ${branch2} have the same commits

No differences to show
```

#### Case: Linear Relationship (Fast-Forward Possible)

```
Linear relationship detected

${branch2} is a direct ancestor of ${branch1}

This means:
  - ${branch1} is ${count} commits ahead
  - ${branch2} can be fast-forwarded to ${branch1}
  - No merge conflicts expected

To update ${branch2}:
  git checkout ${branch2}
  git merge --ff-only ${branch1}
```

#### Case: One Branch Empty

```
${branch1} has all the commits

${branch2} is at the common ancestor with no unique commits

${branch1} contains everything in ${branch2} plus ${count} more commits
```

### 10. Additional Context

#### Release Branch Comparison Detection

If comparing release branches (both match `release/*` pattern):

```
🏷️  Release Comparison Detected

Comparing releases:
  ${branch1} (newer)
  ${branch2} (older)

This comparison shows what's new in ${branch1}
```

Add release-specific insights:
- Version increment type (major/minor/patch)
- Release date (from branch commit dates)
- Tickets by category if extractable

#### Current Branch Highlight

If one of the branches is the current branch:

```
💡 Note: ${current_branch} is your current branch
```

### 11. Helpful Next Steps

Based on the comparison, suggest relevant actions:

**If current branch is behind:**
```
Next steps:
  • Sync your branch: /sync-branch ${target_branch}
  • Review changes: git log ${current_branch}..${target_branch}
```

**If comparing releases:**
```
Next steps:
  • View detailed changes: git log ${older_release}..${newer_release}
  • Create changelog: git log ${older_release}..${newer_release} --pretty=format:"%s"
  • Merge to main: git checkout main && git merge ${newer_release}
```

**If branches diverged significantly:**
```
⚠️  Branches have diverged significantly

Consider:
  • Review both sets of changes carefully
  • Coordinate with team before merging
  • Resolve conflicts: /sync-branch ${target_branch}
```

### 12. Error Handling

Handle these error cases gracefully:

**Branch not found:**
```
✗ Branch '${branch}' not found

Available branches:
  Local: ${local_branches}
  Remote: ${remote_branches}

Tip: Use full branch name (e.g., origin/release/v3.2.0)
```

**No common ancestor:**
```
⚠️  No common history found

${branch1} and ${branch2} have completely separate histories

This is unusual - branches typically share a common ancestor
```

**Too many differences:**
```
⚠️  Large divergence detected

${branch1}: ${count1} commits (showing first 50)
${branch2}: ${count2} commits (showing first 50)

Use --summary for overview or compare smaller ranges
```

**Invalid comparison:**
```
✗ Cannot compare branch with itself

Branches: ${branch1} = ${branch2}

Usage: /compare-branch <branch1> <branch2>
```

## Important Notes

- **Single message execution**: Complete all operations in ONE response
- **Performance**: Limit output for very large differences
- **Context awareness**: Highlight current branch if involved
- **Actionable**: Provide next steps based on comparison
- **Visual clarity**: Use clear sections and formatting
- **Ticket extraction**: Parse common ticket patterns (JIRA, EXT, etc.)
- **Smart defaults**: Compare with main if only one branch provided

## Examples

**Example 1: Compare two releases**
```
User: /compare-branch release/v3.2.0 release/v3.1.0

Shows:
- 45 new commits in v3.2.0
- 23 files changed
- 5 contributors
- Tickets: EXT-123, EXT-456, JIRA-78
```

**Example 2: Compare with main**
```
User: /compare-branch release/v3.2.0

Shows:
- What's in release/v3.2.0 that's not in main
- What's in main that's not in release
- Divergence analysis
```

**Example 3: Current branch comparison**
```
User: /compare-branch

# Currently on: feature/ext-123
Shows:
- feature/ext-123 vs main
- Your commits vs what's in main
- How far ahead/behind you are
```

**Example 4: Summary mode**
```
User: /compare-branch release/v3.2.0 release/v3.1.0 --summary

Brief output:
- 45 commits, 23 files in v3.2.0
- 0 commits in v3.1.0 (linear)
```
