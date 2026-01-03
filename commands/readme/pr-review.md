# `/pr-review` - Review Pull Request

Performs a thorough code review of a GitHub pull request with analysis of code quality, security, tests, and best practices.

## Usage

```bash
# Local-only review (default) - no GitHub interaction
/pr-review                    # List PRs and choose
/pr-review 123                # Review PR #123

# Interactive mode - add draft comments to GitHub
/pr-review --interactive      # List PRs and choose
/pr-review --interactive 123  # Review PR #123 with commenting
```

## Features

### Local Review (Default Mode)
- Lists all open PRs if no number provided
- Interactive PR selection via question prompt
- Fetches PR diff and metadata remotely (no local checkout)
- Comprehensive analysis covering:
  - **Code Quality**: Code smells, maintainability, complexity, error handling
  - **Security**: Injection vulnerabilities, auth issues, data exposure, input validation
  - **Test Coverage**: Test presence, quality, coverage gaps
  - **Best Practices**: Language conventions, framework patterns, performance
- Structured review with severity categories (Critical/Important/Minor)
- Local-only analysis (does NOT post to GitHub)
- Specific file and line number references
- Constructive feedback with suggested fixes

### Interactive Mode (--interactive flag)
All features from local mode, PLUS:
- **Optional GitHub commenting**: Choose whether to add comments after seeing the review
- **Severity filtering**: Select which severity levels to comment on (Critical / Critical+Important / All)
- **One-by-one review**: Interactively decide which issues to comment on
- **Context viewing**: View code context for each issue before deciding
- **Draft comments**: All comments added as drafts (not auto-submitted)
- **Browser preview**: Opens PR in browser for final review before submission
- **Skip option**: Can skip remaining issues at any time

## Examples

### Local-Only Review

1. Review with PR selection:
   ```bash
   /pr-review
   # Lists all open PRs
   # Prompts you to select which one to review
   # Performs thorough analysis
   # Displays local report only
   ```

2. Direct review by PR number:
   ```bash
   /pr-review 42
   # Reviews PR #42 immediately
   # Displays local report only
   ```

### Interactive Mode

3. Interactive review with commenting:
   ```bash
   /pr-review --interactive 42
   # Performs thorough analysis
   # Displays complete review
   # Asks: "Add comments to GitHub?"
   # If yes: "Which severity levels?"
   # Goes through each issue:
   #   [1/5] 🔴 Critical: SQL Injection vulnerability
   #   File: src/api/users.ts:45
   #   Add comment? [y/n/s/v]: y
   #   ✓ Comment added (draft)
   # Opens browser for final review
   ```

4. View context before deciding:
   ```bash
   /pr-review --interactive 42
   # During interactive loop:
   #   [2/5] 🟡 Important: Missing error handling
   #   Add comment? [y/n/s/v]: v
   #   # Shows code context around the issue
   #   Add comment? [y/n/s/v]: y
   #   ✓ Comment added (draft)
   ```

## Review Output Includes

- Overview and summary
- Strengths and positive aspects
- Issues categorized by severity (Critical/Important/Minor)
- Test coverage analysis
- Security analysis
- Prioritized recommendations
- Overall assessment and merge recommendation

## What it does

### Local-Only Mode
1. Lists available PRs (or uses provided PR number)
2. Fetches PR metadata, diff, and changed files via GitHub API
3. Analyzes code for quality, security, tests, and best practices
4. Generates structured review with specific file/line references
5. Provides constructive feedback and suggestions
6. Displays local-only review (no GitHub posting)

### Interactive Mode (--interactive)
All steps from local-only mode, PLUS:
7. Asks if you want to add comments to GitHub
8. Lets you choose severity levels to comment on
9. Presents each issue one-by-one for your decision
10. Allows viewing code context for each issue
11. Adds selected comments as drafts to GitHub
12. Opens PR in browser for final review and submission

## What it does NOT do

### Local-Only Mode
- Does NOT post any comments to GitHub
- Does NOT approve or reject PRs
- Does NOT merge PRs
- Does NOT checkout PR branch locally
- Does NOT modify any code

### Interactive Mode
- Does NOT auto-submit comments (all comments are drafts)
- Does NOT automatically approve or request changes
- Does NOT merge PRs
- Does NOT checkout PR branch locally
- Does NOT modify any code
- Does NOT add comments without your explicit approval

## Requirements

- GitHub CLI (`gh`) must be installed
- Must be authenticated with GitHub (`gh auth login`)
- Must be in a git repository with remote PRs

## Review Structure

The command generates a comprehensive review in this format:

```markdown
# Pull Request Review: [PR Title]

**PR**: #{number} by @{author}
**Branch**: {head} → {base}
**Files Changed**: {count} (+{additions} -{deletions})

---

## 📊 Overview
[Summary of what the PR does]

---

## ✅ Strengths
[Positive aspects and good practices]

---

## ⚠️  Issues & Concerns

### 🔴 Critical (Must Fix)
[Security, bugs, breaking changes]

### 🟡 Important (Should Fix)
[Code quality, maintainability issues]

### 🔵 Minor (Consider)
[Optional improvements, style]

---

## 🧪 Test Coverage
[Test analysis and gaps]

---

## 🔒 Security Analysis
[Security review findings]

---

## 📝 Recommendations
[Prioritized action items]

---

## 💭 Overall Assessment
**Recommendation**: [Approve / Request Changes / Needs Major Revision]
```

## Interactive Mode Workflow

When using `--interactive` flag, the command follows this workflow:

### 1. Generate and Display Review
First, the complete review is generated and displayed (same as local-only mode).

### 2. Ask About GitHub Comments
```
Would you like to add comments to this PR on GitHub? (yes/no)
```
- **no**: Command ends, review stays local-only
- **yes**: Proceed to severity selection

### 3. Choose Severity Levels
```
Which severity levels would you like to comment on?
[c] Critical only
[i] Critical + Important
[a] All issues (Critical + Important + Minor)

Choose:
```
Only issues matching the selected severity will be presented for commenting.

### 4. Interactive Comment Selection

For each issue, you'll see:
```
[3/15] 🔴 Critical: SQL Injection vulnerability
File: src/api/users.ts:45
Issue: User input directly concatenated into SQL query
Fix: Use parameterized queries instead

Add this comment? [y]es / [n]o / [s]kip-all / [v]iew context:
```

**Options:**
- **y** (yes): Adds the comment as a draft to GitHub
- **n** (no): Skips this issue, moves to next
- **s** (skip-all): Skips all remaining issues, goes to summary
- **v** (view): Shows code context around the issue, then asks again

### 5. Summary and Browser

After all selections, shows a summary:
```
─────────────────────────────────
Interactive Review Summary
─────────────────────────────────

✓ 3 comments added to draft review
⊘ 12 issues skipped

📝 Review the full analysis above for all findings.
🌐 Opening PR in browser for final review...
```

Then opens the PR in your browser where you can:
- Review all draft comments
- Edit comment text if needed
- Add more comments manually
- Choose review state (Comment / Approve / Request Changes)
- Submit the review

## Installation

Copy the command file to your Claude Code commands directory:

```bash
# Project-level (shared with team via git)
cp commands/commands/pr-review.md /path/to/your/project/.claude/commands/

# Personal (available in all projects)
mkdir -p ~/.claude/commands
cp commands/commands/pr-review.md ~/.claude/commands/
```
