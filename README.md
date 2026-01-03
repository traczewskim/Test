# claude-skills

A curated collection of custom slash commands and skills for Claude Code, designed to enhance your development workflow with safety features, automation, and best practices.

## What's Inside

### Slash Commands

Enhanced git workflow automation with safety features and standardized processes:

- **[/new-ticket](commands/readme/new-ticket.md)** - Start work on a new ticket with automatic branch creation and ticket storage
- **[/commit](commands/readme/commit.md)** - Create git commits with auto-generated messages and automatic ticket number integration
- **[/lint](commands/readme/lint.md)** - Auto-detect and run all configured linters/formatters with unified output
- **[/sync-branch](commands/readme/sync-branch.md)** - Keep feature branch up-to-date with target branch (merge/rebase strategies)
- **[/compare-branch](commands/readme/compare-branch.md)** - Compare two branches to see differences in commits, files, and tickets
- **[/pr](commands/readme/pr.md)** - Create GitHub pull requests with detailed descriptions and ticket extraction
- **[/pr-review](commands/readme/pr-review.md)** - Perform thorough code reviews with quality, security, and test analysis

**Key improvements over official Anthropic commands:**
- ✅ Integrated ticket workflow (create ticket → commit → PR)
- ✅ Branch safety (prevents commits directly to main/master)
- ✅ Automatic ticket number tracking across commands
- ✅ Ticket number support with preserved casing
- ✅ Detailed PR descriptions with structured format
- ✅ Single-message execution for reliability
- ✅ Restricted tool permissions for security

### Skills

Specialized capabilities for common development tasks:

- **[create-proposal](SKILLS/readme/create-proposal.md)** - Create detailed technical proposals for new features following a structured 5-phase approach (requirements → brainstorming → drafts → confirmation → implementation)
- **[create-technical-requirements](SKILLS/readme/create-technical-requirements.md)** - Generate comprehensive, step-by-step technical requirements documentation for implementable specifications
- **[database-analysis](SKILLS/readme/database-analysis.md)** - Connect to databases, execute queries, and analyze data patterns
- **[frontend-design](SKILLS/readme/frontend-design.md)** - Create distinctive, production-grade frontend interfaces with exceptional design quality

## Quick Start

### Installing Commands

Commands are markdown files that provide quick prompts and workflows.

**Using the installer (recommended):**
```bash
./install-commands.sh
```

**Manual installation:**

Project-level (shared with team via git):
```bash
cp commands/commands/*.md /path/to/your/project/.claude/commands/
```

Personal (available in all projects):
```bash
mkdir -p ~/.claude/commands
cp commands/commands/*.md ~/.claude/commands/
```

### Installing Skills

Skills are specialized capabilities for complex tasks.

**Using the installer (recommended):**
```bash
./install-skills.sh
```

**Manual installation:**

Project-level (shared with team via git):
```bash
cp -r SKILLS/skills/* /path/to/your/project/.claude/skills/
```

Personal (available in all projects):
```bash
mkdir -p ~/.claude/skills
cp -r SKILLS/skills/* ~/.claude/skills/
```

## Project Structure

```
claude-skills/
├── commands/
│   ├── commands/       # Actual command files for Claude Code
│   └── readme/         # Documentation for each command
├── SKILLS/
│   ├── skills/         # Actual skill directories for Claude Code
│   └── readme/         # Documentation for each skill
└── README.md           # This file
```

## Creating Your Own

### Commands

Slash commands are Markdown files with YAML frontmatter:

```markdown
---
description: Brief description for /help
argument-hint: [optional-args]
allowed-tools: Bash(git *), Read
---

# Instructions for Claude

Use !`command` to execute bash and capture output.
Use $ARGUMENTS to access command arguments.

Your task instructions here...
```

**Best Practices:**
1. Keep it simple - commands are for quick prompts, not complex workflows
2. Use allowed-tools to restrict permissions for safety
3. Capture context with `!` commands to get current state
4. Write clear, step-by-step instructions
5. Test before sharing

### Skills

Skills are more complex capabilities with detailed instructions and context.

See existing skills in `SKILLS/skills/` for examples and patterns.

## Resources

- [Claude Code Documentation](https://docs.anthropic.com/claude-code)
- [Slash Commands Guide](https://docs.anthropic.com/claude-code/guides/slash-commands)
- [YAML Frontmatter Options](https://docs.anthropic.com/claude-code/reference/slash-commands)

## Contributing

This is a personal collection, but feel free to fork and create your own custom commands and skills!

---

**Maintained By**: EMP Development Team
**Last Updated**: December 2025
