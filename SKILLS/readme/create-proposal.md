# create-proposal

Create detailed technical proposals for new features, components, or workflows following a structured 5-phase approach.

## Overview

This skill guides you through creating comprehensive technical proposals for new features in Symfony/PHP projects. It ensures thorough planning before implementation through requirements gathering, brainstorming, iterative drafts, confirmation, and final implementation.

## When to Use

Use this skill when you need to:
- Design a new feature or component (e.g., SSO integration, payment system)
- Plan a new API endpoint or workflow
- Architect a database schema or entity structure
- Implement authentication or authorization systems
- Create any significant technical change requiring planning

## The 5-Phase Workflow

### Phase 1: Requirements Gathering
- Ask clarifying questions to understand the problem
- Identify stakeholders, constraints, and integration needs
- Document security, performance, and timeline requirements
- Identify all necessary components (endpoints, services, entities, etc.)

### Phase 2: Brainstorming & Exploration
- Present multiple approaches (2-3 options minimum)
- Discuss pros and cons of each approach
- Identify risks and mitigation strategies
- Iterate based on user feedback

### Phase 3: Create Proposal Drafts
- Create iterative proposal documents as design evolves
- Save as `./proposals/{proposal_name}/proposal1.md`, `proposal2.md`, etc.
- Include comprehensive sections: Overview, Architecture, API Endpoints, Security, Testing
- Keep previous versions for reference

### Phase 4: Confirm Implementation
- Review final proposal with user
- Get explicit approval before proceeding
- Only move to implementation after confirmation

### Phase 5: Implementation & Documentation
- Implement following Symfony conventions
- Create comprehensive README.md with installation, usage, and troubleshooting
- Follow project patterns for controllers, services, entities, models

## Proposal Structure

Each proposal includes:
- **Overview** - Brief description of the feature
- **Problem Statement** - What problem we're solving
- **Proposed Solution** - High-level approach
- **Architecture** - Components, data flow, database schema, directory structure
- **API Endpoints** - Request/response formats, error cases
- **Security Considerations** - Authentication, authorization, validation
- **Dependencies** - External services, packages, environment variables
- **Implementation Notes** - TODOs, limitations, future improvements
- **Testing Strategy** - Unit tests, integration tests, manual testing
- **Deployment** - Migrations, configuration, rollback plan

## Project Conventions

### Symfony/PHP Standards

**File Naming:**
- Controllers: `{HTTPMethod}Controller.php` (PostController, GetController)
- Services: `{Feature}{Purpose}Service.php` (UserSsoService)
- Models: `{HTTPMethod}{Type}.php` (PostRequest, GetResponse)

**Directory Structure:**
- Controllers: `Controller/{Route}/{HTTPMethod}Controller.php`
- Services: `Service/{Feature}/{SemanticName}Service.php`
- Models: `Model/{Route}/{HTTPMethod}{Type}.php`
- Entities: `Entity/{Feature}/{EntityName}.php`
- Repositories: `Repository/{Feature}/{EntityName}Repository.php`
- Exceptions: `Exception/{Feature}/{ExceptionName}.php`

**Code Style:**
- Follow PSR-12
- Use type hints for all parameters and return types
- Use dependency injection
- Document complex logic with comments

## Output Files

For a proposal named "user-authentication":

```
./proposals/user-authentication/
├── proposal1.md          # Initial design
├── proposal2.md          # Refined design (if needed)
├── notes/
│   ├── requirements.md   # Gathered requirements
│   └── decisions.md      # Key decisions made
├── src/                  # Implementation (after approval)
│   ├── Controller/
│   ├── Service/
│   ├── Entity/
│   └── ...
└── README.md            # Final documentation
```

## Checklist Before Implementation

- [ ] All requirements documented
- [ ] Multiple approaches considered
- [ ] Trade-offs understood
- [ ] Architecture clearly defined
- [ ] Database schema designed
- [ ] API contracts specified
- [ ] Security reviewed
- [ ] Error handling planned
- [ ] Testing strategy defined
- [ ] User explicitly approved
- [ ] Deployment plan created

## Common Proposal Types

### Authentication/SSO
- Identity provider integration
- Token management
- User synchronization
- Session handling

### API Endpoints
- REST endpoints
- Request/response models
- Validation rules
- Error handling

### Database Changes
- New entities
- Schema migrations
- Repository methods
- Indexes and constraints

### Third-Party Integration
- API clients
- Webhook handling
- Rate limiting
- Error retry logic

## Tips for Success

1. **Be thorough in Phase 1** - Better questions = better proposals
2. **Don't rush to implementation** - Design first, code later
3. **Iterate proposals** - Create proposal2.md, proposal3.md as needed
4. **Document decisions** - Capture why choices were made
5. **Follow conventions** - Consistency matters in codebases
6. **Test thoroughly** - Plan testing from the start
7. **Think about operations** - Logging, monitoring, cleanup tasks

## Installation

**Project-level:**
```bash
cp -r SKILLS/skills/create-proposal /path/to/your/project/.claude/skills/
```

**Personal:**
```bash
mkdir -p ~/.claude/skills
cp -r SKILLS/skills/create-proposal ~/.claude/skills/
```

## Remember

- **Never skip Phase 4 confirmation** - Always get explicit approval before implementing
- **Proposals are living documents** - Update them as design evolves
- **Documentation is not optional** - README.md is the implementation guide
- **Follow existing patterns** - Look at the codebase for conventions
- **Think about the full lifecycle** - Installation, usage, maintenance, troubleshooting
