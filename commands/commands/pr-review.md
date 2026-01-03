---
description: Review a pull request with thorough analysis
argument-hint: [--interactive] [pr-number]
allowed-tools: Bash(gh pr list:*), Bash(gh pr view:*), Bash(gh pr diff:*), Bash(gh pr review:*), Bash(git diff:*), AskUserQuestion
---

# Review Pull Request Command

## Context

Available PRs: !`gh pr list --json number,title,author,headRefName,updatedAt --limit 20`

PR argument (if provided): $ARGUMENTS

## Your Task

This command performs a thorough code review of a GitHub pull request.

**Modes:**
- **Local-only mode** (default): Generates comprehensive review locally, does NOT post to GitHub
- **Interactive mode** (`--interactive` flag): After local review, allows adding draft comments to GitHub

### 1. Parse Arguments and Determine Mode

**Parse $ARGUMENTS to extract:**
- Interactive flag: Check if `--interactive` is present in $ARGUMENTS
- PR number: Extract the numeric PR number from $ARGUMENTS (if provided)

**Examples:**
- `/pr-review 123` → PR 123, local-only mode
- `/pr-review --interactive 123` → PR 123, interactive mode
- `/pr-review --interactive` → No PR number, interactive mode, will ask user to select
- `/pr-review` → No PR number, local-only mode, will ask user to select

**If PR number is NOT provided:**
- Check the available PRs from the context above
- If NO open PRs exist: Display "No open pull requests found"
- If open PRs exist: Present them in a clear format and use AskUserQuestion to ask which PR to review
- Wait for user selection before proceeding

**If PR number is provided:**
- Use the PR number from $ARGUMENTS
- Validate it exists by checking against the PR list

### 2. Fetch PR Details

Once you have the PR number, gather comprehensive information:

```bash
# Get PR metadata
gh pr view {PR_NUMBER} --json title,author,body,baseRefName,headRefName,additions,deletions,changedFiles,commits,labels,reviewDecision

# Get the full diff
gh pr diff {PR_NUMBER}

# Get list of changed files
gh pr view {PR_NUMBER} --json files --jq '.files[].path'
```

### 3. Perform Thorough Code Review

Analyze the PR diff and provide detailed feedback on:

#### A. Code Quality
- **Code smells**: Duplicated code, long functions, complex conditionals
- **Maintainability**: Clear naming, proper structure, modularity
- **Readability**: Comments where needed, clear logic flow
- **Complexity**: Identify overly complex sections that could be simplified
- **Error handling**: Proper try-catch, validation, edge cases

#### B. Security Issues
- **Injection vulnerabilities**: SQL injection, command injection, XSS
- **Authentication/Authorization**: Proper access controls, token handling
- **Data exposure**: Sensitive data logging, information leakage
- **Input validation**: User input sanitization, type checking
- **Cryptography**: Secure algorithms, key management
- **Dependencies**: Known vulnerabilities in added packages

#### C. Test Coverage
- **Test presence**: Are tests included for new features/fixes?
- **Test quality**: Do tests cover edge cases, error paths, happy paths?
- **Test types**: Unit tests, integration tests, e2e tests where appropriate
- **Assertions**: Are tests actually validating the right things?
- **Missing tests**: What should be tested but isn't?

#### D. Best Practices
- **Language conventions**: Follows language-specific idioms and standards
- **Framework patterns**: Uses framework correctly (React hooks, async/await, etc.)
- **Performance**: Potential performance issues (n+1 queries, unnecessary re-renders)
- **Resource management**: Proper cleanup, connection handling, memory leaks
- **Documentation**: Code comments, README updates, API docs
- **Backwards compatibility**: Breaking changes, migration needs

### 4. Structure Your Review

Present the review in this format:

```markdown
# Pull Request Review: [PR Title]

**PR**: #{number} by @{author}
**Branch**: {head} → {base}
**Files Changed**: {count} (+{additions} -{deletions})

---

## 📊 Overview

[2-3 sentence summary of what this PR does]

---

## ✅ Strengths

- [Positive aspects of the implementation]
- [Good patterns or practices used]
- [Well-tested areas]

---

## ⚠️  Issues & Concerns

### 🔴 Critical (Must Fix)
[Issues that could cause bugs, security problems, or breaking changes]

- **File:Line** - Description of issue
  - Why it's a problem
  - Suggested fix

### 🟡 Important (Should Fix)
[Code quality, maintainability, or best practice violations]

- **File:Line** - Description of issue
  - Impact on codebase
  - Suggested improvement

### 🔵 Minor (Consider)
[Nice-to-have improvements, style suggestions]

- **File:Line** - Description
  - Optional improvement

---

## 🧪 Test Coverage

**Status**: [Good/Needs Improvement/Missing]

[Analysis of test coverage]
- What's tested well
- What's missing tests
- Suggestions for additional tests

---

## 🔒 Security Analysis

**Status**: [No Issues/Concerns Found/Issues Found]

[Security review findings]
- Vulnerabilities identified (if any)
- Security best practices check
- Input validation review

---

## 📝 Recommendations

1. [Prioritized list of actions]
2. [Most important changes first]
3. [Include both required and optional improvements]

---

## 💭 Overall Assessment

**Recommendation**: [Approve / Request Changes / Needs Major Revision]

[Final thoughts on the PR quality, risk level, and readiness to merge]
```

### 5. Interactive Mode (if --interactive flag was provided)

**ONLY execute this section if the `--interactive` flag was present in $ARGUMENTS.**

After displaying the complete review, offer to add comments to GitHub:

#### Step 5.1: Ask About Adding Comments

Use AskUserQuestion to ask:
```
Would you like to add comments to this PR on GitHub? (yes/no)
```

**If answer is "no"**: Skip to section 6 (end of command)

**If answer is "yes"**: Continue to Step 5.2

#### Step 5.2: Ask About Severity Level

Use AskUserQuestion to ask:
```
Which severity levels would you like to comment on?
[c] Critical only
[i] Critical + Important
[a] All issues (Critical + Important + Minor)

Choose:
```

**Parse the response** and build a list of issues to present based on the selected severity level.

#### Step 5.3: Interactive Comment Selection

For each issue in the selected severity level, use AskUserQuestion to present:

```
[{current}/{total}] {emoji} {Severity}: {Issue Title}
File: {file_path}:{line_number}
Issue: {issue_description}
Fix: {suggested_fix}

Add this comment? [y]es / [n]o / [s]kip-all / [v]iew context:
```

**Handle responses:**

- **'v' or 'view'**:
  - Use `gh pr diff {PR_NUMBER}` or `git diff` to show ~10 lines of context around the issue location
  - Display the context
  - Ask the question again for the same issue

- **'y' or 'yes'**:
  - Add draft comment to GitHub using:
    ```bash
    gh pr review {PR_NUMBER} --comment \
      --body "**{Severity}**: {Issue Title}

{issue_description}

**Why this matters:**
{why_it's_a_problem}

**Suggested fix:**
{suggested_fix}" \
      --file "{file_path}" \
      --line {line_number}
    ```
  - Display: `✓ Comment added (draft)`
  - Track the count of added comments
  - Move to next issue

- **'n' or 'no'**:
  - Display: `⊘ Skipped`
  - Move to next issue

- **'s' or 'skip' or 'skip-all'**:
  - Display: `⊘ Skipped remaining {remaining_count} issues`
  - Exit the interactive loop

#### Step 5.4: Summary and Open Browser

After the interactive loop completes, display a summary:

```
─────────────────────────────────
Interactive Review Summary
─────────────────────────────────

✓ {added_count} comments added to draft review
⊘ {skipped_count} issues skipped

📝 Review the full analysis above for all findings.
🌐 Opening PR in browser for final review...
```

Then open the PR in the browser:
```bash
gh pr view {PR_NUMBER} --web
```

**Important notes for interactive mode:**
- All comments are added in DRAFT/COMMENT state (not REQUEST_CHANGES)
- Comments are NOT automatically submitted
- The user will review and submit manually in the GitHub UI
- If any `gh pr review` command fails, display the error and continue with remaining issues
- Keep track of successfully added comments vs. failed attempts

### 6. Be Thorough But Constructive

- **Be specific**: Always reference file names and line numbers
- **Explain WHY**: Don't just point out issues, explain the impact
- **Suggest solutions**: Provide concrete recommendations, not just criticism
- **Balance positive and negative**: Acknowledge good work too
- **Prioritize**: Not all issues are equal - categorize by severity
- **Be professional**: Constructive feedback, not harsh criticism

### 7. Error Handling

Handle these cases:

- **No PRs available**: Clear message, no error
- **Invalid PR number**: List available PRs
- **PR not found**: Error with helpful message
- **GitHub CLI not installed**: Installation instructions
- **Not authenticated**: `gh auth login` instructions
- **Network issues**: Clear error message

## Important Notes

**For all modes:**
- Focus on being helpful and educational
- Analyze the actual code changes, not just commit messages
- Consider the PR description and context
- Look for patterns across multiple files
- Be thorough - users expect detailed analysis
- Use markdown formatting for readability
- Reference specific files and line numbers from the diff

**For local-only mode (default):**
- This is a LOCAL review only - do NOT post comments to GitHub
- Do NOT use `gh pr review` or `gh pr comment` commands

**For interactive mode (--interactive flag):**
- ONLY add comments if user explicitly agrees in Step 5.1
- All comments are added as DRAFT (not automatically submitted)
- Use `gh pr review --comment` to add individual comments
- Always include file path and line number with comments
- Open browser at the end for manual review and submission
