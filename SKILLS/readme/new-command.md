# New Command/Skill Creation Wizard

An interactive wizard that guides you through creating new Claude Code commands and skills.

## When to Use

Use this skill when you want to:
- Create a new slash command (like `/commit` or `/lint`)
- Create a new skill for complex workflows
- Get help deciding between a command vs. a skill
- Generate properly structured files with best practices
- Learn how commands and skills work

## Usage

```bash
/new-command
```

The skill will interactively guide you through:
1. Understanding what you want to create
2. Determining whether it should be a command or skill
3. Gathering requirements and clarifying details
4. Analyzing existing patterns for inspiration
5. Generating the command/skill files
6. Creating documentation
7. Providing installation instructions

## What It Does

The wizard walks you through a structured 6-phase process:

1. **Discovery & Type Selection** - Understand your needs and choose command vs. skill
2. **Requirements Gathering** - Ask clarifying questions about functionality
3. **Research & Pattern Analysis** - Find similar examples and identify patterns
4. **Generation** - Create the command/skill file with proper structure
5. **Documentation & Installation** - Generate docs and install instructions
6. **Review & Iteration** - Offer improvements and next steps

### Command vs. Skill

The wizard helps you decide:

**Commands** are for:
- Quick, focused automation (git operations, running tests, etc.)
- Single-purpose tasks that execute immediately
- Operations that need restricted tool access for safety

**Skills** are for:
- Complex, multi-step workflows
- Interactive processes requiring user guidance
- Domain expertise or creative work

## Example Session

```bash
You: /new-command
Claude: I'll help you create a new command or skill! Let's start by understanding what you want to create.

What would you like this command/skill to do? Please describe the problem it solves and how you'd typically use it.

You: I want a command to automatically format code and fix linting issues

Claude: That sounds like a good fit for a command! Based on what you've described:
- It's a focused automation task
- It should execute immediately
- It's similar to the existing /lint command

Let me ask a few clarifying questions...
[continues with wizard process]
```

## Installation

Run the installer:
```bash
./install-skills.sh
```

Select **new-command** from the menu.

Or manually install:
```bash
# Install to current project
cp -r SKILLS/skills/new-command .claude/skills/

# Or install personally
cp -r SKILLS/skills/new-command ~/.claude/skills/
```

## Tips

- The wizard will ask lots of questions - this helps create better commands/skills
- Reference existing commands/skills when uncertain about structure
- Test your created command/skill before considering it done
- Iterate! You can always refine and improve

## What You'll Get

After completing the wizard, you'll have:
- A properly structured command (`.md` file) or skill (`SKILL.md` in directory)
- User-facing documentation in the readme folder
- Installation instructions
- Best practices applied automatically
- Examples and patterns from existing commands/skills
