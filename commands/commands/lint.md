---
description: Run code quality checks and linters
argument-hint: [--fix] [linter-name]
allowed-tools: Bash(vendor/bin/*), Bash(npx *), Bash(node_modules/.bin/*), Bash(python *), Bash(black *), Bash(flake8 *), Bash(pylint *), Bash(composer *), Bash(npm *), Bash(ls *), Bash(test *), Bash(find *)
---

# Lint Command

## Context

Current directory contents: !`ls -la`

Package managers detected: !`test -f package.json && echo "npm/node" || echo ""; test -f composer.json && echo "php/composer" || echo ""`

Git status (to check for staged files): !`git status --short 2>/dev/null || echo "Not a git repository"`

## Your Task

**IMPORTANT**: You MUST complete all steps in a single message using parallel tool calls where possible. Do not send multiple messages.

This command automatically detects and runs all configured linters/formatters in the project, aggregates results, and optionally applies automatic fixes.

### 1. Parse Arguments

Arguments are provided in $ARGUMENTS with these possible formats:
- No arguments: Run all detected linters in check mode
- `--fix`: Run all linters in fix/write mode
- `eslint`: Run only ESLint
- `eslint --fix`: Run only ESLint in fix mode
- `--staged`: Run only on git staged files
- `--fix --staged`: Fix only staged files

**Parse logic:**
1. Check if `--fix` flag is present → enable fix mode
2. Check if `--staged` flag is present → only lint staged files
3. Check for specific linter name (eslint, prettier, phpstan, etc.) → run only that linter
4. If no specific linter, run all detected linters

### 2. Detect Available Linters

Check for linters in order of priority. For each, check both config files AND if the tool is installed.

#### JavaScript/TypeScript Linters

**ESLint:**
- Config files: `.eslintrc.js`, `.eslintrc.json`, `.eslintrc.yml`, `.eslintrc`, `eslint.config.js`, or `eslint` in `package.json`
- Binary check: `test -f node_modules/.bin/eslint`
- Check command: `npx eslint . --ext .js,.jsx,.ts,.tsx`
- Fix command: `npx eslint . --ext .js,.jsx,.ts,.tsx --fix`
- Staged only: `npx eslint $(git diff --cached --name-only --diff-filter=ACM | grep -E '\.(js|jsx|ts|tsx)$' | xargs)`

**Prettier:**
- Config files: `.prettierrc`, `.prettierrc.json`, `.prettierrc.yml`, `.prettierrc.js`, `prettier.config.js`, or `prettier` in `package.json`
- Binary check: `test -f node_modules/.bin/prettier`
- Check command: `npx prettier --check .`
- Fix command: `npx prettier --write .`
- Staged only: `npx prettier --check $(git diff --cached --name-only --diff-filter=ACM | xargs)`

**Stylelint (CSS/SCSS):**
- Config files: `.stylelintrc`, `.stylelintrc.json`, `stylelint.config.js`
- Binary check: `test -f node_modules/.bin/stylelint`
- Check command: `npx stylelint "**/*.{css,scss,sass}"`
- Fix command: `npx stylelint "**/*.{css,scss,sass}" --fix`

#### PHP Linters

**PHP CS Fixer:**
- Config files: `.php-cs-fixer.php`, `.php-cs-fixer.dist.php`, `.php_cs`
- Binary check: `test -f vendor/bin/php-cs-fixer`
- Check command: `vendor/bin/php-cs-fixer fix --dry-run --diff`
- Fix command: `vendor/bin/php-cs-fixer fix`
- Staged only: `vendor/bin/php-cs-fixer fix --dry-run --diff $(git diff --cached --name-only --diff-filter=ACM | grep '\.php$' | xargs)`

**PHPStan:**
- Config files: `phpstan.neon`, `phpstan.neon.dist`, `phpstan.dist.neon`
- Binary check: `test -f vendor/bin/phpstan`
- Check command: `vendor/bin/phpstan analyse`
- Fix command: Not supported (show message: "PHPStan does not support auto-fix")

**Psalm:**
- Config files: `psalm.xml`, `psalm.xml.dist`
- Binary check: `test -f vendor/bin/psalm`
- Check command: `vendor/bin/psalm`
- Fix command: `vendor/bin/psalm --alter --issues=all` (use with caution)

**PHP_CodeSniffer (PHPCS):**
- Config files: `phpcs.xml`, `phpcs.xml.dist`, `.phpcs.xml`
- Binary check: `test -f vendor/bin/phpcs`
- Check command: `vendor/bin/phpcs`
- Fix command: `vendor/bin/phpcbf` (if exists: `test -f vendor/bin/phpcbf`)

#### Python Linters

**Black (formatter):**
- Config files: `pyproject.toml` with `[tool.black]`, `.black`
- Binary check: `which black`
- Check command: `black --check .`
- Fix command: `black .`

**Flake8:**
- Config files: `.flake8`, `setup.cfg`, `tox.ini`
- Binary check: `which flake8`
- Check command: `flake8 .`
- Fix command: Not supported

**Pylint:**
- Config files: `.pylintrc`, `pylintrc`, `pyproject.toml`
- Binary check: `which pylint`
- Check command: `pylint **/*.py`
- Fix command: Not supported

### 3. Execute Detection

Run detection checks in parallel for speed. For each linter type:

```bash
# Example: Check for ESLint
(test -f .eslintrc.js || test -f .eslintrc.json || test -f eslint.config.js || grep -q '"eslint"' package.json 2>/dev/null) && test -f node_modules/.bin/eslint && echo "eslint:detected" || echo "eslint:not-found"
```

Build a list of detected linters.

### 4. Display Detection Results

Before running linters, show what was detected:

```
Scanning for linters...

✓ Found: ESLint, Prettier
✓ Found: PHP CS Fixer
✗ Not configured: PHPStan, Psalm

Running 3 linters...
```

If NO linters detected:
```
No linters detected in this project.

To add linters:
- JavaScript: npm install --save-dev eslint prettier
- PHP: composer require --dev friendsofphp/php-cs-fixer
- Python: pip install black flake8

Then create configuration files (.eslintrc.js, .php-cs-fixer.php, etc.)
```

### 5. Run Linters

Execute each detected linter based on mode (check or fix).

**Important execution rules:**
- Run linters sequentially (not parallel) to avoid output conflicts
- Capture both stdout and stderr
- Store exit codes
- Continue running all linters even if one fails
- Show progress as each linter runs

**For each linter:**

1. Show starting message:
   ```
   Running ESLint...
   ```

2. Execute appropriate command based on:
   - Fix mode: Use fix command
   - Check mode: Use check command
   - Staged only: Filter to staged files first

3. Capture output and exit code

4. Parse and format output (see section 6)

### 6. Format and Display Results

For each linter that ran, display results in a consistent format:

#### Success (exit code 0, no issues):
```
✓ ESLint: All files pass (24 files checked)
```

#### Warnings/Errors Found (exit code non-zero):
```
⚠ ESLint: 5 errors, 12 warnings in 3 files

  src/utils/api.ts:15:3
    ✗ error: 'response' is assigned but never used (no-unused-vars)

  src/components/Button.tsx:42:5
    ⚠ warning: Missing return type annotation

  ... and 14 more issues

  Run /lint eslint --fix to auto-fix 8 fixable issues
```

#### Fixed Issues (in --fix mode):
```
✓ Prettier: Formatted 8 files
  - src/utils/helper.js
  - src/components/Header.tsx
  ... and 6 more
```

#### Non-fixable Issues (in --fix mode):
```
⚠ PHPStan: 3 errors remain (not auto-fixable)

  src/Service/UserService.php:45
    ✗ error: Method returns int but should return string
```

### 7. Aggregate Summary

After all linters complete, show overall summary:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Lint Summary
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✓ Passed:  Prettier, Stylelint
⚠ Issues:  ESLint (5 errors, 12 warnings)
✗ Failed:  PHPStan (3 errors)

Total: 3 linters run, 2 passed, 1 with warnings, 1 failed
```

In fix mode, add:
```
Fixed: 8 files modified
Remaining: 3 issues require manual fixes
```

### 8. Exit Code Behavior

**Return appropriate status:**
- All linters passed (exit 0): Success message only
- Some linters have warnings: Show warnings, suggest fixes
- Any linter failed: Show errors prominently
- Mix of passed/failed: Show summary with next steps

**Next steps suggestion:**
```
Next steps:
  • Run /lint --fix to auto-fix 8 issues
  • Review PHPStan errors (not auto-fixable)
  • Run /lint eslint to see only ESLint issues
```

### 9. Handle Edge Cases

**No files match (e.g., --staged with no staged files):**
```
ℹ No staged files to lint

Stage files first: git add <files>
Or run without --staged flag: /lint
```

**Linter not installed but config exists:**
```
⚠ Found .eslintrc.js but ESLint is not installed

Install: npm install --save-dev eslint
Then run: /lint
```

**Linter crashes/errors:**
```
✗ ESLint: Command failed

Error: Cannot find module 'eslint-plugin-react'

Fix: npm install --save-dev eslint-plugin-react
```

**Permission issues:**
```
✗ PHP CS Fixer: Permission denied

Fix: chmod +x vendor/bin/php-cs-fixer
```

### 10. Specific Linter Mode

When running a specific linter (e.g., `/lint eslint`):

1. Skip detection phase for other linters
2. Check if requested linter is available
3. If not found, show helpful error:
   ```
   ✗ ESLint not found in this project

   Detected linters: PHP CS Fixer, PHPStan

   To add ESLint:
     npm install --save-dev eslint
     npx eslint --init
   ```
4. If found, run only that linter with full output (no truncation)

### 11. Performance Optimization

**For large projects:**
- Add file count limits (e.g., "Checking 1,247 files...")
- Show progress for slow linters
- Suggest using --staged for faster feedback
- Cache detection results (don't re-scan on every run)

**Timeout handling:**
- If a linter runs >60 seconds, show: "Still running ESLint... (60s elapsed)"
- Allow graceful termination

## Important Notes

- **Single message execution**: Run all detections and linting in ONE response
- **Parallel detection, sequential execution**: Detect all linters in parallel, but run them one at a time
- **Always continue**: Don't stop if one linter fails; run all and report
- **Smart output**: Truncate long outputs but provide counts and samples
- **Actionable results**: Always suggest next steps (--fix, specific linter, etc.)
- **Respect existing configs**: Use project's configured rules, don't override
- **Safe by default**: Check mode is default, --fix requires explicit flag
- **Handle missing tools gracefully**: If binary doesn't exist, skip with notice

## Examples

**Example 1: Check all linters**
```
User: /lint
Output:
  ✓ ESLint: All files pass
  ⚠ Prettier: 3 files need formatting
  ✓ PHP CS Fixer: All files pass
```

**Example 2: Fix all issues**
```
User: /lint --fix
Output:
  ✓ ESLint: Fixed 2 issues
  ✓ Prettier: Formatted 3 files
  ✓ PHP CS Fixer: Fixed 1 file
```

**Example 3: Specific linter**
```
User: /lint prettier --fix
Output:
  ✓ Prettier: Formatted 3 files
    - src/App.tsx
    - src/utils/format.js
    - README.md
```

**Example 4: Staged files only**
```
User: /lint --staged
Output:
  ✓ ESLint: 2 staged files pass
  ⚠ Prettier: 1 staged file needs formatting
    - src/NewFeature.tsx
```
