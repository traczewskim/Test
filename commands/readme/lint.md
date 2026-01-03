# /lint - Code Quality Check

Automatically detect and run all configured linters and formatters in your project with a single command.

## Overview

The `/lint` command scans your project for linter configurations, runs all detected linters, and presents aggregated results. No need to remember which linters you have or how to run them - this command handles it all.

## Usage

```bash
# Check all files with all detected linters
/lint

# Auto-fix all fixable issues
/lint --fix

# Run specific linter only
/lint eslint
/lint prettier --fix
/lint php-cs-fixer

# Lint only staged files (fast feedback before commit)
/lint --staged
/lint --fix --staged
```

## Supported Linters

The command automatically detects and runs:

### JavaScript/TypeScript
- **ESLint** - JavaScript/TypeScript linter
- **Prettier** - Code formatter
- **Stylelint** - CSS/SCSS linter

### PHP
- **PHP CS Fixer** - PHP code style fixer
- **PHPStan** - Static analysis tool
- **Psalm** - Static analysis tool
- **PHP_CodeSniffer (PHPCS)** - Code sniffer with auto-fix via PHPCBF

### Python
- **Black** - Code formatter
- **Flake8** - Style guide checker
- **Pylint** - Code analyzer

## How It Works

### 1. Auto-Detection

The command scans for:
- **Configuration files** (.eslintrc.js, .php-cs-fixer.php, etc.)
- **Installed binaries** (node_modules/.bin/eslint, vendor/bin/php-cs-fixer, etc.)
- **Package manifests** (package.json, composer.json dependencies)

Only runs linters that are both configured AND installed.

### 2. Execution

Runs detected linters sequentially and captures:
- Exit codes (pass/fail status)
- Error/warning messages
- File paths and line numbers
- Fixable vs. non-fixable issues

### 3. Results

Presents unified output across all linters:

```
Scanning for linters...

✓ Found: ESLint, Prettier
✓ Found: PHP CS Fixer

Running 3 linters...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✓ Prettier: All files formatted (42 files)

⚠ ESLint: 5 errors, 12 warnings in 3 files

  src/utils/api.ts:15:3
    ✗ error: 'response' is assigned but never used

  src/components/Button.tsx:42:5
    ⚠ warning: Missing return type annotation

  Run /lint eslint --fix to auto-fix 8 issues

✓ PHP CS Fixer: All files pass (128 files)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Lint Summary
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✓ Passed:  Prettier, PHP CS Fixer
⚠ Issues:  ESLint (5 errors, 12 warnings)

Total: 3 linters run, 2 passed, 1 with issues

Next steps:
  • Run /lint --fix to auto-fix 8 issues
  • Review ESLint errors that require manual fixes
```

## Examples

### Basic Code Check

Before committing, check code quality:

```bash
/lint
```

### Auto-Fix Issues

Automatically fix formatting and style issues:

```bash
/lint --fix
```

This will:
- Format code with Prettier
- Fix ESLint auto-fixable issues
- Apply PHP CS Fixer corrections
- Format Python with Black

### Pre-Commit Check

Only lint files you're about to commit:

```bash
# Stage your changes
git add src/NewFeature.tsx

# Lint only staged files
/lint --staged

# Fix staged files
/lint --fix --staged
```

Fast feedback loop - only checks what's changed.

### Specific Linter

Run just one linter for focused feedback:

```bash
# Only ESLint
/lint eslint

# Only PHP CS Fixer with auto-fix
/lint php-cs-fixer --fix

# Only Prettier
/lint prettier
```

Useful when:
- Fixing specific linter warnings
- Faster than running all linters
- Debugging linter configuration

### Fix Mode Output

When using `--fix`, see what was changed:

```bash
/lint --fix

✓ Prettier: Formatted 8 files
  - src/App.tsx
  - src/utils/format.js
  - src/components/Header.tsx
  ... and 5 more

✓ ESLint: Fixed 12 issues in 4 files
  - Removed 3 unused variables
  - Added 9 missing semicolons

⚠ PHPStan: 2 errors (not auto-fixable)
  - src/Service/UserService.php:45
    Return type mismatch

Fixed: 20 files modified
Remaining: 2 issues require manual attention
```

## Integration with Workflow

### Daily Development

```bash
# Make changes
vim src/Feature.tsx

# Quick check
/lint --staged

# Auto-fix
/lint --fix

# Commit
/commit
```

### Before Pull Request

```bash
# Check everything
/lint

# Fix all auto-fixable issues
/lint --fix

# Verify all pass
/lint

# Create PR
/pr main
```

### CI/CD Alignment

The `/lint` command runs the same linters as your CI pipeline, giving you local feedback before pushing:

```yaml
# .github/workflows/lint.yml
- run: npm run lint        # /lint runs the same ESLint
- run: npm run format      # /lint runs the same Prettier
- run: vendor/bin/phpstan  # /lint runs the same PHPStan
```

Local `/lint` = CI checks, but faster and earlier.

## Error Handling

### No Linters Detected

```
No linters detected in this project.

To add linters:
- JavaScript: npm install --save-dev eslint prettier
- PHP: composer require --dev friendsofphp/php-cs-fixer

Then create configuration files.
```

### Linter Not Installed

```
⚠ Found .eslintrc.js but ESLint is not installed

Install: npm install --save-dev eslint
```

### Linter Errors

```
✗ ESLint: Command failed

Error: Cannot find module 'eslint-plugin-react'

Fix: npm install --save-dev eslint-plugin-react
```

## Advantages Over Manual Linting

| Manual Approach | /lint Command |
|----------------|---------------|
| Remember which linters exist | Auto-detects all linters |
| Run each separately | Single command for all |
| Different output formats | Unified, readable output |
| Miss some linters | Catches everything configured |
| Manual aggregation | Automatic summary |
| Remember fix flags | Smart --fix mode |

## Performance

### Speed Optimizations

- **Parallel detection**: Checks for all linters simultaneously
- **Sequential execution**: Runs one at a time for clear output
- **Staged-only mode**: Fast pre-commit checks
- **Smart caching**: Linters use their own caching (ESLint cache, etc.)

### Large Projects

For projects with 1000+ files:

```bash
# Faster: only changed files
/lint --staged

# Faster: specific linter
/lint prettier --fix

# Full check when needed
/lint
```

## Requirements

**None!**

The command uses whatever linters you already have installed. No additional dependencies needed.

**Your existing setup:**
- ✓ PHP CS Fixer already installed → Command will use it
- ✓ Your .php-cs-fixer.php config → Command respects it
- ✓ Any other linters you add later → Command auto-detects them

## Configuration

The `/lint` command respects your existing linter configurations:

- `.eslintrc.js` - ESLint rules
- `.prettierrc` - Prettier options
- `.php-cs-fixer.php` - PHP CS Fixer rules
- `phpstan.neon` - PHPStan configuration
- And all other config files

**It never overrides your settings.**

## Tips

### 1. Pre-Commit Hook

Add to `.git/hooks/pre-commit`:

```bash
#!/bin/bash
/lint --staged
```

Automatically checks code before every commit.

### 2. IDE Integration

While the command is great for manual checks, your IDE should still run linters on save for instant feedback.

### 3. Focus Mode

When fixing issues:

```bash
# See all ESLint issues
/lint eslint

# Fix what you can
/lint eslint --fix

# Check remaining
/lint eslint
```

### 4. Clean Commits

```bash
# Before committing
/lint --fix --staged

# Then commit clean code
/commit
```

## Troubleshooting

### "Command not found" errors

**Issue:** Linter binary not found

**Fix:** Install the linter:
```bash
npm install --save-dev eslint  # For ESLint
composer require --dev phpstan  # For PHPStan
```

### "Config file not found" warnings

**Issue:** Linter installed but not configured

**Fix:** Create config file:
```bash
npx eslint --init              # ESLint
vendor/bin/phpstan init        # PHPStan
```

### Slow performance

**Issue:** Linting takes too long

**Solutions:**
- Use `--staged` to lint only changed files
- Run specific linter: `/lint prettier`
- Enable linter caching in config files
- Add ignore patterns (.eslintignore, .prettierignore)

### Conflicts between linters

**Issue:** Prettier and ESLint disagree on formatting

**Fix:** Configure them to work together:
```bash
npm install --save-dev eslint-config-prettier
```

Add to `.eslintrc.js`:
```javascript
{
  "extends": ["prettier"]
}
```

## Related Commands

- **/commit** - Create commits (run `/lint --fix` first)
- **/pr** - Create pull requests (run `/lint` to verify)
- **/pr-review** - Review PRs (includes code quality checks)

## See Also

- [ESLint Documentation](https://eslint.org)
- [Prettier Documentation](https://prettier.io)
- [PHP CS Fixer Documentation](https://cs.symfony.com)
- [PHPStan Documentation](https://phpstan.org)
