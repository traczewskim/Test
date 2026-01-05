---
description: Create a new GitHub release with tag
argument-hint: [version] [branch] [--pre-release]
allowed-tools: Bash(git tag:*), Bash(git fetch:*), Bash(git log:*), Bash(git rev-parse:*), Bash(git branch:*), Bash(gh release create:*), AskUserQuestion
---

# Release Command

## Context

Current branch: !`git branch --show-current`

Git status: !`git status -sb`

Arguments provided: $ARGUMENTS

Available tags: !`git tag --sort=-version:refname | head -20`

Available branches: !`git branch -a | grep -E '(master|main|release/)' | head -20`

## Your Task

**IMPORTANT**: This command creates GitHub releases using an interactive wizard. You MUST use the AskUserQuestion tool to gather all required information before creating the release.

### Workflow Overview

There are two release workflows:

1. **Regular Release** (from `origin/master`):
   - Only allowed from `origin/master` branch
   - Look for "merged release/vX.Y.Z" in recent commit messages
   - Extract version from the merged branch name
   - Create a regular GitHub release

2. **Pre-Release (RC)** (from `release/*` branches):
   - Usually from a `release/vX.Y.Z` branch
   - Extract version from branch name
   - Append `-rc.N` suffix (increment N if previous RCs exist)
   - Create a GitHub pre-release

### Step 1: Parse Arguments (Optional)

Arguments in $ARGUMENTS are OPTIONAL and can override wizard defaults:
- First argument: version (e.g., "v1.0.2", "1.0.2")
- Second argument: branch (e.g., "origin/master", "release/v1.0.2")
- Flag: "--pre-release" to mark as pre-release

If arguments are provided, use them as defaults in the wizard. If not provided, determine defaults as described below.

### Step 2: Determine Default Branch

**Default branch logic:**
- If no branch argument provided, default to `origin/master`
- Normalize the branch name (same as /pr command):
  - Check if exact branch exists: `git rev-parse --verify <branch> 2>/dev/null`
  - If doesn't exist, try alternatives:
    - "main" → try "origin/main"
    - "origin/main" → try "main"
    - "master" → try "origin/master"
    - "origin/master" → try "master"
    - "release/vX.Y.Z" → try "origin/release/vX.Y.Z"
  - Use first valid branch reference found
  - If no valid branch, show error with available branches

### Step 3: Determine Default Pre-Release Flag

**Default pre-release logic:**
- If branch is `origin/master` or `origin/main` → default is NO (regular release)
- If branch matches `release/*` or `origin/release/*` → default is YES (pre-release)
- If `--pre-release` flag in arguments → default is YES

### Step 4: Determine Default Version

**For Regular Release (from origin/master):**
1. Fetch latest changes: `git fetch origin master 2>/dev/null || true`
2. Look for recent "merged release/vX.Y.Z" commits:
   ```bash
   git log origin/master --oneline -50 --grep="Merge.*release/v"
   ```
3. Extract version from the most recent merge commit (e.g., "Merge pull request #123 from user/release/v1.0.2" → "v1.0.2")
4. If no merge found, get latest tag: `git tag --sort=-version:refname | head -1`
5. Suggest the extracted version as default

**For Pre-Release (from release/* branch):**
1. Extract version from branch name:
   - Branch `release/v1.0.2` → version `v1.0.2`
   - Branch `origin/release/v1.0.2` → version `v1.0.2`
2. Check for existing RC tags for this version:
   ```bash
   git tag --list "v1.0.2-rc.*" --sort=-version:refname
   ```
3. If RCs exist, suggest next RC number:
   - Found: `v1.0.2-rc.2` → suggest `v1.0.2-rc.3`
   - Found: `v1.0.2-rc.1` → suggest `v1.0.2-rc.2`
4. If no RCs exist, suggest: `v1.0.2-rc.1`

**Version format:**
- Always use `v` prefix (e.g., `v1.0.2`, not `1.0.2`)
- Pre-release format: `vX.Y.Z-rc.N` (e.g., `v1.0.2-rc.1`)

### Step 5: Interactive Wizard

Use the AskUserQuestion tool to ask for confirmation/input:

**Question 1: Select Branch**
- header: "Branch"
- question: "Which branch should this release be created from?"
- options:
  1. Default branch (determined in step 2) - mark as "(Recommended)"
  2. Other common branches if applicable (e.g., if default is master, also show release/* branches)
- multiSelect: false

**Question 2: Is this a pre-release?**
- header: "Pre-release"
- question: "Is this a pre-release (RC) or a regular release?"
- options:
  1. Based on default from step 3 (e.g., "No - Regular release" or "Yes - Pre-release (RC)") - mark as "(Recommended)"
  2. Opposite of default
- multiSelect: false

**Question 3: Select Version**
- header: "Version"
- question: "What version should be released?"
- options:
  1. Default version (determined in step 4) - mark as "(Recommended)"
  2. Other reasonable version suggestions (e.g., if default is v1.0.2, also suggest v1.0.3, v1.1.0, v2.0.0)
  3. For pre-releases, suggest other RC numbers if applicable
- multiSelect: false
- Note: User can select "Other" to provide custom version

### Step 6: Validate User Input

After receiving answers from the wizard:

1. **Validate branch exists:**
   ```bash
   git rev-parse --verify <selected-branch> 2>/dev/null
   ```
   - If not found, error: "Branch not found: <branch>"

2. **Validate version format:**
   - Must match: `vX.Y.Z` or `vX.Y.Z-rc.N`
   - If user provided version without `v` prefix, add it automatically
   - If pre-release is YES, ensure version has `-rc.N` suffix
   - If pre-release is NO, ensure version does NOT have `-rc` suffix

3. **Check if tag already exists:**
   ```bash
   git tag --list "<version>"
   ```
   - If tag exists, error: "Tag <version> already exists. Please choose a different version."

4. **Validate release workflow:**
   - If pre-release is NO and branch is NOT `origin/master` or `origin/main`:
     - Show warning: "⚠️  Regular releases are typically created from origin/master. Current branch: <branch>"
     - Ask for confirmation to proceed

### Step 7: Show Confirmation Summary

Before creating the release, show a summary and ask for final confirmation:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Release Summary
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Version: <version>
Branch: <branch>
Type: <Regular Release | Pre-Release (RC)>

This will:
  • Create tag: <version>
  • Create GitHub release from: <branch>
  • Generate release notes automatically

Proceed with release creation? (yes/no)
```

Use AskUserQuestion with:
- header: "Confirm"
- question: "Proceed with release creation?"
- options: ["Yes, create release", "No, cancel"]

If user selects "No, cancel", stop and show: "Release cancelled."

### Step 8: Generate Release Notes

Auto-generate release notes from commits:

1. **Find previous release tag:**
   ```bash
   git tag --sort=-version:refname | grep -v "rc" | head -1
   ```
   - For pre-releases, include RC tags: `git tag --sort=-version:refname | head -1`

2. **Get commits since last release:**
   ```bash
   git log <previous-tag>..<branch> --oneline --no-merges
   ```
   - If no previous tag, use: `git log <branch> --oneline --no-merges -20`

3. **Generate release notes:**
   - Group commits by type (if using conventional commits):
     - feat: → Features
     - fix: → Bug Fixes
     - docs: → Documentation
     - perf: → Performance
     - Other → Other Changes
   - Format as markdown:
     ```markdown
     ## What's Changed

     ### Features
     - Commit message 1
     - Commit message 2

     ### Bug Fixes
     - Fix message 1

     ### Other Changes
     - Other message 1

     **Full Changelog**: https://github.com/OWNER/REPO/compare/<previous-tag>...<version>
     ```

### Step 9: Create GitHub Release

Use `gh release create` to create the release:

**For Regular Release:**
```bash
gh release create "<version>" \
  --target "<branch>" \
  --title "<version>" \
  --notes "$(cat <<'EOF'
<generated-release-notes>
EOF
)"
```

**For Pre-Release:**
```bash
gh release create "<version>" \
  --target "<branch>" \
  --title "<version>" \
  --notes "$(cat <<'EOF'
<generated-release-notes>
EOF
)" \
  --prerelease
```

**Important:**
- `--target` is the branch to create the release from
- `--title` is the release title (use version)
- `--notes` contains the auto-generated release notes
- `--prerelease` flag marks it as a pre-release in GitHub
- The command will automatically create the git tag
- Use HEREDOC syntax for multi-line notes

### Step 10: Report Results

Show success message with release information:

**For Regular Release:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✓ Release Created Successfully
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Version: <version>
Type: Regular Release
Branch: <branch>
Tag: <version>

Release URL: <github-release-url>

Next steps:
  • Review release notes on GitHub
  • Announce the release to your team
  • Monitor for any issues
```

**For Pre-Release:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✓ Pre-Release Created Successfully
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Version: <version>
Type: Pre-Release (RC)
Branch: <branch>
Tag: <version>

Release URL: <github-release-url>

⚠️  This is a pre-release and will be marked as such on GitHub.

Next steps:
  • Test the release candidate
  • Gather feedback
  • Create regular release when ready
```

## Error Handling

Handle these cases gracefully:

- **No branch specified and default not found**: Error with available branches
- **Branch doesn't exist**: Error with available branches
- **Tag already exists**: Error - ask user to choose different version
- **Invalid version format**: Error with format examples
- **GitHub CLI not installed**: Error with installation instructions
- **Not authenticated with GitHub**: Error with `gh auth login` instructions
- **Release creation fails**: Show error from gh command
- **No commits since last release**: Warning - ask if user wants to proceed anyway
- **Not a git repository**: Error message
- **Pre-release from master**: Show warning and ask for confirmation

## Important Notes

- **Use interactive wizard** - always use AskUserQuestion for user input
- **Two workflows**: Regular release from master, Pre-release from release/* branches
- **Version extraction**: From merged commits (regular) or branch name (pre-release)
- **Auto-generate release notes** from git commits
- **Validate before creating** - check branch exists, tag doesn't exist, version format
- **Branch normalization** - handle "main" vs "origin/main", etc.
- **Version format** - always use `v` prefix, pre-releases use `-rc.N` suffix
- **GitHub CLI** - uses `gh release create` to create both tag and release
- **Pre-release flag** - marks release as pre-release in GitHub UI
- **Confirmation** - always ask for final confirmation before creating release
- Default branch is `origin/master` if not specified
- Extract ticket/version info from commit messages or branch names
- Show clear summaries and next steps
