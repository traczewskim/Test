# `/pr-review` - Review Pull Request

Performs a thorough code review of a GitHub pull request with analysis of code quality, security, tests, and best practices.

## Usage

```bash
# List PRs and choose which to review
/pr-review

# Review specific PR by number
/pr-review 123
```

## Features

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

## Examples

1. Interactive review:
   ```bash
   /pr-review
   # Lists all open PRs
   # Prompts you to select which one to review
   # Performs thorough analysis
   ```

2. Direct review by PR number:
   ```bash
   /pr-review 42
   # Reviews PR #42 immediately
   # No prompt needed
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

1. Lists available PRs (or uses provided PR number)
2. Fetches PR metadata, diff, and changed files via GitHub API
3. Analyzes code for quality, security, tests, and best practices
4. Generates structured review with specific file/line references
5. Provides constructive feedback and suggestions
6. Displays local-only review (no GitHub posting)

## What it does NOT do

- Post review comments to GitHub
- Approve or reject PRs
- Merge PRs
- Checkout PR branch locally
- Modify any code

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

## Installation

Copy the command file to your Claude Code commands directory:

```bash
# Project-level (shared with team via git)
cp commands/commands/pr-review.md /path/to/your/project/.claude/commands/

# Personal (available in all projects)
mkdir -p ~/.claude/commands
cp commands/commands/pr-review.md ~/.claude/commands/
```
