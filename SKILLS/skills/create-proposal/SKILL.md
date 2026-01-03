---
name: create-proposal
description: Create detailed technical proposals for new features, components, or workflows. Use when designing SSO systems, API endpoints, authentication flows, database schemas, or any architectural changes. Guides through requirements gathering, brainstorming, iterative proposal drafts, implementation, and documentation following Symfony/PHP project conventions.
---

# Create Proposal

This skill guides you through creating comprehensive technical proposals for new features, components, or workflows in a Symfony/PHP project. It follows a structured 5-phase approach to ensure thorough planning before implementation.

## When to Use This Skill

Use this skill when the user wants to:
- Creating a new proposal
- Design a new feature or component (e.g., SSO integration, payment system)
- Plan a new API endpoint or workflow
- Architect a database schema or entity structure
- Implement authentication or authorization systems
- Create any significant technical change requiring planning

## Proposal Workflow (5 Phases)

### Phase 1: Requirements Gathering

Start by understanding the full scope:

1. **Ask clarifying questions** to understand:
    - What problem are we solving?
    - Who are the stakeholders/users?
    - What are the technical constraints?
    - Are there existing systems to integrate with?
    - What are the security/performance requirements?
    - What's the expected timeline?

2. **Identify key components**:
    - Endpoints/routes needed
    - External services/APIs
    - Database entities
    - Authentication/authorization needs
    - Error handling requirements

3. **Document assumptions** clearly

**Example questions for an SSO proposal:**
- "Which identity provider are you integrating with?"
- "Do you need to support multiple user pools?"
- "What happens when a user doesn't exist?"
- "Should tokens be one-time use?"
- "What's the token expiration time?"

### Phase 2: Brainstorming & Exploration

Explore different approaches and trade-offs:

1. **Present multiple approaches** (minimum 2-3 options)
2. **Discuss pros and cons** of each approach
3. **Ask for feedback** on preferred direction
4. **Iterate** based on user input
5. **Identify risks** and mitigation strategies

Focus on:
- Architecture patterns (MVC, service layer, etc.)
- Technology choices (libraries, frameworks)
- Data flow and state management
- Security considerations
- Scalability implications

### Phase 3: Create Proposal Drafts

Create iterative proposal documents as the design evolves:

**Directory structure:**
```
./proposals/{proposal_name}/
├── proposal1.md  # Initial approach
├── proposal2.md  # Refined after feedback
├── proposal3.md  # Final design (if needed)
└── notes/
    ├── requirements.md
    ├── questions.md
    └── decisions.md
```

**Proposal document format:**
```markdown
# [Feature Name] - Proposal [N]

## Overview
Brief description of the feature/change

## Problem Statement
What problem are we solving?

## Proposed Solution
High-level description of the approach

## Architecture

### Components
List and describe all components:
- Controllers
- Services
- Entities
- Repositories
- Models (Request/Response)
- Exceptions

### Data Flow
Describe the request/response flow with sequence diagrams or step-by-step

### Database Schema
```sql
-- Table definitions
```

### Directory Structure
```
src/
├── Controller/
├── Service/
├── Entity/
├── Model/
└── ...
```

## API Endpoints

### Endpoint 1: [METHOD]:[PATH]
**Request:**
```json
{...}
```

**Response:**
```json
{...}
```

**Error Cases:**
- Case 1: ...
- Case 2: ...

## Security Considerations
- Authentication requirements
- Authorization checks
- Data validation
- Rate limiting
- Token management

## Dependencies
- External services
- PHP packages
- Environment variables

## Implementation Notes
- TODO items
- Known limitations
- Future improvements

## Testing Strategy
- Unit tests needed
- Integration tests
- Manual testing steps

## Deployment
- Migration steps
- Configuration changes
- Rollback plan
```

**Iterate on proposals:**
- Number proposals sequentially (proposal1.md, proposal2.md, etc.)
- Each iteration addresses feedback and refines the design
- Keep previous versions for reference

### Phase 4: Confirm Implementation

Before implementing, confirm with the user:

1. **Review final proposal** together
2. **Confirm all requirements** are addressed
3. **Get explicit approval** to proceed
4. **Ask**: "Are you ready to implement this proposal, or would you like to refine anything?"

**Only proceed to implementation after explicit confirmation.**

### Phase 5: Implementation & Documentation

#### Implementation Structure

Create implementation in:
```
./proposals/{proposal_name}/src/
```

Follow Symfony conventions:

**Controller Structure:**
- Pattern: `Controller/{Route}/{HTTPMethod}Controller.php`
- Example: `/auth/sso` POST → `Controller/Auth/Sso/PostController.php`
- Use invokable controllers with `__invoke()` method
- One controller per HTTP method per route

**Service Layer:**
- Pattern: `Service/{Feature}/{SemanticName}Service.php`
- Example: `Service/Sso/AuthSsoService.php`
- Contain business logic
- Inject dependencies via constructor

**Model Structure:**
- Pattern: `Model/{Route}/{HTTPMethod}{Type}.php`
- Example: `Model/Users/Sso/PostRequest.php`
- Types: `Request` (incoming), `Response` (outgoing)
- Use Symfony validation annotations

**Entity Structure:**
- Pattern: `Entity/{Feature}/{EntityName}.php`
- Example: `Entity/Sso/SsoToken.php`
- Use Doctrine annotations
- Include repository class

**Repository Structure:**
- Pattern: `Repository/{Feature}/{EntityName}Repository.php`
- Example: `Repository/Sso/SsoTokenRepository.php`
- Extend `ServiceEntityRepository`

**Exception Structure:**
- Pattern: `Exception/{Feature}/{ExceptionName}.php`
- Example: `Exception/Sso/NoMerchantAssignedException.php`
- Extend appropriate base exception

#### Create README.md

After implementation, create comprehensive documentation:

```
./proposals/{proposal_name}/README.md
```

**README.md structure:**
```markdown
# [Feature Name]

Brief description

## Architecture Overview
High-level description with component list

## Directory Structure
```
src/
├── Controller/
├── Service/
...
```

## Installation

### 1. Copy Files
Explain file placement

### 2. Install Dependencies
```bash
composer require package/name
```

### 3. Configure Services
Service configuration examples

### 4. Environment Variables
List all required env vars with examples

### 5. Run Migrations
```bash
php bin/console doctrine:migrations:migrate
```

## Usage

### Endpoint Documentation
For each endpoint:
- Request/response examples
- Error cases
- Authentication requirements

## Maintenance
Commands, cleanup tasks, scheduled jobs

## Security Considerations
Security features and best practices

## Logging
Logging configuration and channels

## Testing
Test cases to implement

## Troubleshooting
Common issues and solutions

## Architecture & Design Patterns
Explain patterns used and rationale

## Implementation Notes
Completed features and TODOs

## Compatibility
Versions and dependencies

## Support
Links to related docs
```

## Project Conventions

### Symfony/PHP Standards

**File Naming:**
- Controllers: `{HTTPMethod}Controller.php` (PostController, GetController)
- Services: `{Feature}{Purpose}Service.php` (UserSsoService)
- Models: `{HTTPMethod}{Type}.php` (PostRequest, GetResponse)

**Code Style:**
- Follow PSR-12
- Use type hints for all parameters and return types
- Document complex logic with comments
- Use dependency injection

**Error Handling:**
- Create custom exceptions for domain errors
- Return appropriate HTTP status codes
- Log errors to appropriate channels

**Configuration:**
- Environment variables for all configurable values
- Service definitions in YAML
- Document all configuration options

**Database:**
- Use Doctrine ORM
- Annotations for mapping
- Repository pattern for queries
- Migrations for schema changes

## Tips for Success

1. **Be thorough in Phase 1** - Better questions = better proposals
2. **Don't rush to implementation** - Design first, code later
3. **Iterate proposals** - Create proposal2.md, proposal3.md as needed
4. **Document decisions** - Capture why choices were made
5. **Follow conventions** - Consistency matters in codebases
6. **Test thoroughly** - Plan testing from the start
7. **Think about operations** - Logging, monitoring, cleanup tasks

## Examples of Good Proposals

Refer to existing proposals for patterns:
- SSO Implementation (comprehensive example)
- API endpoint additions
- Database schema changes
- Third-party integrations

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

## Output Files Summary

For a proposal named "user-authentication":

```
./proposals/user-authentication/
├── proposal1.md          # Initial design
├── proposal2.md          # Refined design
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

## Remember

- **Never skip Phase 4 confirmation** - Always get explicit approval before implementing
- **Proposals are living documents** - Update them as design evolves
- **Documentation is not optional** - README.md is the implementation guide
- **Follow existing patterns** - Look at the codebase for conventions
- **Think about the full lifecycle** - Installation, usage, maintenance, troubleshooting