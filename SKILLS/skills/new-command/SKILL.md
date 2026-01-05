---
name: new-command
description: Interactive wizard for creating new Claude Code commands and skills. Guides you through brainstorming, clarifying requirements, and generating properly structured commands or skills.
---

# New Command/Skill Creation Wizard

An interactive wizard that helps you create new Claude Code commands or skills. This skill guides you through the entire creation process, from ideation to implementation, asking clarifying questions and helping you make design decisions.

## When to Use This Skill

Use this skill when you want to:
- Create a new slash command for Claude Code
- Create a new skill for Claude Code
- Get guidance on whether to create a command vs. a skill
- Generate properly structured command/skill files
- Learn best practices for command/skill creation

## Workflow

This wizard follows a structured approach to help you create well-designed commands or skills:

### Phase 1: Discovery & Type Selection

**Your Task**: Understand what the user wants to create and determine whether it should be a command or a skill.

1. **Initial Discovery**
   - Ask the user to describe what they want to create
   - What problem does it solve?
   - What would a typical use case look like?

2. **Determine Type** (Command vs. Skill)

   Use the AskUserQuestion tool to help determine the type based on these criteria:

   **Choose COMMAND if**:
   - Simple, focused automation
   - Quick operations (git, build, test, etc.)
   - Should execute immediately with minimal interaction
   - Needs restricted tool access for safety
   - Argument-based (e.g., `/commit jira-123`)

   **Choose SKILL if**:
   - Complex, multi-step workflow
   - Requires iterative refinement or user guidance
   - Needs full Claude Code capabilities
   - Interactive, conversation-driven process
   - Domain expertise or creative work

   If unclear, ask clarifying questions using AskUserQuestion:
   - "Does this need multiple phases with user approval?"
   - "Should this execute immediately or guide the user through a process?"
   - "Does this need restricted tool access for safety?"

3. **Name Validation**
   - Ensure the name is lowercase with hyphens (e.g., `my-command`, not `myCommand` or `My Command`)
   - Check that the name doesn't conflict with existing commands/skills
   - Use Glob to check: `commands/commands/{name}.md` and `SKILLS/skills/{name}/`

### Phase 2: Requirements Gathering

**Your Task**: Gather detailed requirements through interactive questions.

1. **Core Functionality**
   - What specific actions should this perform?
   - What inputs does it need (arguments, file paths, etc.)?
   - What outputs should it produce?
   - What tools/APIs will it need to use?

2. **For Commands specifically, ask**:
   - What commands should it run? (git, npm, docker, etc.)
   - Does it need to capture context before executing? (use `!`command``)
   - What arguments should it accept? (use `$ARGUMENTS`)
   - What tools should be allowed? (for the `allowed-tools` directive)
   - Should it execute everything in a single message?

3. **For Skills specifically, ask**:
   - What are the main phases/steps in the workflow?
   - Where should user confirmation be required?
   - What files or artifacts should it create?
   - What quality criteria should be met?
   - What guidelines or principles should it follow?

4. **Brainstorming & Clarification**
   - Suggest improvements or alternatives based on existing commands/skills
   - Ask about edge cases and error handling
   - Clarify any ambiguous requirements
   - Reference similar existing commands/skills for inspiration

### Phase 3: Research & Pattern Analysis

**Your Task**: Analyze existing commands/skills to identify relevant patterns.

1. **Find Similar Examples**
   - Use Glob to list existing commands: `commands/commands/*.md`
   - Use Glob to list existing skills: `SKILLS/skills/*/SKILL.md`
   - Identify 1-2 similar commands/skills to use as reference

2. **Extract Patterns**
   - Read the reference files to understand structure
   - Identify reusable patterns (context capture, argument parsing, multi-phase workflows, etc.)
   - Note any best practices or anti-patterns

3. **Share Findings**
   - Show the user what patterns you found
   - Explain how they could apply to the new command/skill
   - Use AskUserQuestion if multiple approaches are viable

### Phase 4: Generation

**Your Task**: Create the command/skill file(s) based on gathered requirements.

1. **For Commands**:

   Create `commands/commands/{name}.md` with this structure:

   ```markdown
   ---
   description: Brief description for /help menu (one line)
   argument-hint: <required> [optional]  # Optional: only if it takes arguments
   allowed-tools: Bash(git *), Read, Grep  # List specific tools needed
   ---

   # Command Name

   ## Context

   Capture current state with !`commands`:
   Current branch: !`git branch --show-current`
   # Add other relevant context captures

   Arguments provided: $ARGUMENTS  # If applicable

   ## Your Task

   **IMPORTANT**: Complete all steps in a single message.

   ### 1. [First Step]
   Instructions for first step

   ### 2. [Second Step]
   Instructions for second step

   ### 3. Report Results
   - Summarize what was done
   - Provide next steps or confirmation

   ## Important Notes
   - Safety considerations
   - What NOT to do
   - Additional guidance
   ```

2. **For Skills**:

   Create `SKILLS/skills/{name}/SKILL.md` with this structure:

   ```markdown
   ---
   name: skill-name
   description: Comprehensive description of the skill's purpose and when to use it
   ---

   # Skill Name

   Brief overview of what this skill does.

   ## When to Use This Skill

   Clear criteria for when to invoke this skill:
   - Use case 1
   - Use case 2

   ## Workflow/Process

   ### Phase 1: Initial Step
   Detailed instructions for first phase

   ### Phase 2: Next Step
   Detailed instructions for second phase

   ## Guidelines and Best Practices

   Key principles:
   - Guideline 1
   - Guideline 2

   ## Example Workflows

   Concrete examples showing the skill in action

   ## Output/Deliverables

   What the skill produces

   ## Quality Checklist

   - [ ] Criteria 1
   - [ ] Criteria 2
   ```

3. **Generate the File**
   - Use the Write tool to create the file
   - Include all requirements gathered in Phase 2
   - Follow the patterns identified in Phase 3
   - Ensure proper YAML frontmatter formatting

### Phase 5: Documentation & Installation

**Your Task**: Create user-facing documentation and provide installation instructions.

1. **Create Documentation**

   **For Commands**, create `commands/readme/{name}.md`:
   ```markdown
   # Command Name

   Brief description of what this command does.

   ## Usage

   \`\`\`bash
   /command-name [arguments]
   \`\`\`

   ## Examples

   \`\`\`bash
   /command-name example-arg
   \`\`\`

   ## What It Does

   1. Step 1 explanation
   2. Step 2 explanation

   ## Installation

   Run the installer:
   \`\`\`bash
   ./install-commands.sh
   \`\`\`

   Select this command from the menu.
   ```

   **For Skills**, create `SKILLS/readme/{name}.md`:
   ```markdown
   # Skill Name

   Brief description of what this skill does.

   ## When to Use

   Use this skill when you need to...

   ## Usage

   Invoke the skill:
   \`\`\`bash
   /skill-name
   \`\`\`

   ## What It Does

   High-level workflow description

   ## Installation

   Run the installer:
   \`\`\`bash
   ./install-skills.sh
   \`\`\`

   Select this skill from the menu.
   ```

2. **Installation Instructions**

   Provide the user with clear next steps:

   **For Commands**:
   ```bash
   # Install to this project
   ./install-commands.sh
   # Then select: {command-name}

   # Or manually copy to project
   cp commands/commands/{name}.md .claude/commands/

   # Or install personally
   cp commands/commands/{name}.md ~/.claude/commands/
   ```

   **For Skills**:
   ```bash
   # Install to this project
   ./install-skills.sh
   # Then select: {skill-name}

   # Or manually copy to project
   cp -r SKILLS/skills/{name} .claude/skills/

   # Or install personally
   cp -r SKILLS/skills/{name} ~/.claude/skills/
   ```

3. **Testing Recommendation**

   Suggest the user test the command/skill:
   - Install it locally
   - Try a basic use case
   - Verify it works as expected
   - Iterate if needed

### Phase 6: Review & Iteration

**Your Task**: Review what was created and offer to make improvements.

1. **Summary**
   - Show what files were created
   - Summarize the functionality
   - List any assumptions made

2. **Offer Improvements**
   - Ask if anything should be adjusted
   - Suggest optional enhancements
   - Offer to add more examples or documentation

3. **Next Steps**
   - Remind user to test the command/skill
   - Suggest contributing it back if it's generally useful
   - Offer to create additional related commands/skills

## Guidelines and Best Practices

### Command Best Practices

1. **Safety First**
   - Use `allowed-tools` to restrict tool access
   - Add safety checks (e.g., prevent commits to main/master)
   - Validate arguments before executing

2. **Context Capture**
   - Use `!`command`` to capture git status, branch, etc.
   - Capture context at the START of the command
   - All context capture must happen before any instructions

3. **Single-Message Execution**
   - Commands should complete in one response
   - No back-and-forth with the user
   - All logic should be self-contained

4. **Argument Handling**
   - Use `$ARGUMENTS` to access provided arguments
   - Parse and validate arguments explicitly
   - Provide clear `argument-hint` in frontmatter

### Skill Best Practices

1. **Clear Phases**
   - Break complex workflows into distinct phases
   - Use confirmation gates where appropriate
   - Make it easy to resume or iterate

2. **Quality Focus**
   - Include quality checklists
   - Define clear deliverables
   - Provide examples of good output

3. **Flexibility**
   - Don't over-prescribe implementation
   - Allow for creative solutions
   - Provide principles, not rigid rules

4. **Documentation**
   - Include example workflows
   - Document when to use vs. not use
   - Explain the reasoning behind guidelines

### General Best Practices

1. **Naming**
   - Use lowercase with hyphens: `my-command`, not `myCommand`
   - Be descriptive but concise
   - Avoid conflicts with existing commands/skills

2. **Descriptions**
   - Keep `description` brief for /help menu
   - Make it action-oriented ("Create...", "Run...", "Generate...")
   - Clarify what problem it solves

3. **Tool Permissions**
   - Commands: Restrict tools explicitly with `allowed-tools`
   - Skills: Have full tool access by default
   - Only allow what's necessary

4. **Error Handling**
   - Anticipate common errors
   - Provide helpful error messages
   - Include recovery steps

## Example: Creating a Simple Command

**User Request**: "I want a command to quickly run tests"

**Wizard Process**:

1. **Discovery**: Determine it's a command (simple, immediate execution)
2. **Requirements**:
   - Should detect test framework (Jest, pytest, cargo test, etc.)
   - Should accept optional test file path
   - Should show colored output
3. **Pattern Research**: Reference `/lint` for auto-detection pattern
4. **Generation**: Create `commands/commands/test.md`
5. **Documentation**: Create `commands/readme/test.md`
6. **Installation**: Provide install instructions

## Example: Creating a Complex Skill

**User Request**: "I want help writing API documentation"

**Wizard Process**:

1. **Discovery**: Determine it's a skill (multi-phase, requires analysis)
2. **Requirements**:
   - Phase 1: Analyze API endpoints
   - Phase 2: Generate OpenAPI spec
   - Phase 3: Write human-readable docs
   - Quality: Complete, accurate, includes examples
3. **Pattern Research**: Reference `create-technical-requirements` for structure
4. **Generation**: Create `SKILLS/skills/api-docs/SKILL.md`
5. **Documentation**: Create `SKILLS/readme/api-docs.md`
6. **Installation**: Provide install instructions

## Important Notes

- **Be Interactive**: Use AskUserQuestion frequently to clarify and confirm
- **Brainstorm Together**: Suggest improvements and alternatives
- **Reference Examples**: Show similar commands/skills for inspiration
- **Validate Assumptions**: Don't assume what the user wants - ask!
- **Iterate**: Offer to refine and improve after initial creation
- **Test**: Encourage testing before considering it complete

## Quality Checklist

Before completing the wizard, ensure:

- [ ] Type (command vs. skill) is appropriate for the use case
- [ ] Name follows conventions (lowercase-with-hyphens)
- [ ] Name doesn't conflict with existing commands/skills
- [ ] YAML frontmatter is properly formatted
- [ ] For commands: `allowed-tools` includes only necessary tools
- [ ] For commands: Context capture uses `!`command`` syntax
- [ ] For commands: Single-message execution pattern is clear
- [ ] For skills: Multi-phase workflow is well-structured
- [ ] Documentation file is created
- [ ] Installation instructions are provided
- [ ] User has had opportunity to review and iterate
