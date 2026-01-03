# create-technical-requirements

Create comprehensive, step-by-step technical requirements documentation for tasks or features.

## Overview

This skill creates detailed technical requirements that are comprehensive enough for developers to implement without ambiguity. It breaks down feature requests into implementable specifications with complete logic flows, data structures, and integration points.

## When to Use

Use this skill when you need to:
- Break down feature requests into implementable specifications
- Document API endpoints and their complete logic
- Define database entities and their relationships
- Plan service layer architecture
- Outline integration requirements between systems

## Process

### 1. Understand the Context
- Read the feature description or task
- Identify all systems/components involved
- Understand the data flow and user journey
- Identify existing vs new components

### 2. Structure the Requirements

Requirements are organized by component type:
- API endpoints
- Services/business logic
- Database entities
- Configuration/environment variables
- External dependencies

### 3. Document Each Component

#### For API Endpoints:
```
X. Create endpoint: `METHOD /path/to/endpoint` (Purpose Description)
   - Request: (format)
     - `parameter_name` (type, required/optional) - description
   - Response:
     - `XXX Status Code` - when/why
     - Response format/structure

   **Endpoint Logic:**
   1. Step-by-step implementation details
   2. Validation requirements
   3. Data processing steps
   4. Integration points
   5. Response building
```

#### For Services:
```
X. Create `ServiceName` with the following methods:
   - `methodName(params)` - Purpose
     - Detailed implementation steps
     - What it accepts (parameters with types)
     - What it does (processing logic)
     - What it returns

   **Implementation Note:** Architecture patterns, design considerations

   **Dependencies:**
   - List existing and new dependencies
   - Include references (GitHub links, file paths)
   - Note which exist vs need creation
```

#### For Entities:
```
X. Create new entity: `EntityName`
   - Database schema and migrations required
   - Purpose description

   **Entity Properties:**
   - `field_name` (type, constraints) - description

   **Indexes:**
   - List all indexes with purpose

   **Relationships:**
   - Define foreign keys and relationships

   **Notes:**
   - Business rules
   - Usage context
   - Future considerations
   - Data lifecycle
```

## Key Principles

### Be Explicit
- Specify data types, constraints, and defaults
- Include both success and error scenarios
- Detail validation rules
- Define response codes and formats

### Provide Context
- Explain WHY decisions are made, not just WHAT
- Add **Logic:** sections for complex business rules
- Include **Notes:** for implementation considerations
- Reference existing code with URLs/paths when relevant

### Handle Edge Cases
- Document conditional flows (Case A, Case B)
- Specify error handling
- Include validation requirements
- Note optional vs required fields

### Think About Dependencies
- List existing components to reuse
- Identify new components to create
- Specify external services/libraries
- Include version or reference links

### Consider the Future
- Add **Future consideration:** for extensibility points
- Note where design allows flexibility
- Suggest patterns that enable scaling

## Formatting Guidelines

### Sections and Hierarchy
- Use numbered lists for sequential items
- Use nested bullets for details
- Use **bold headings** for subsections
- Use code blocks for formats/examples

### Inline Code
- Wrap technical terms: `ClassName`, `fieldName`
- Show formats: `prefix_{variable}`
- Display URLs: `https://example.com/path`

### Notes and Callouts
- **Logic:** for business rules
- **Note:** for important considerations
- **Implementation Note:** for technical guidance
- **Future consideration:** for extensibility

## Example Output Structure

```markdown
# [Feature Name] Requirements

1. Update existing endpoint/component
   - Changes needed
   **Logic:**
   - Business rules

2. Create endpoint: `POST /api/path`
   - Request: ...
   - Response: ...
   **Endpoint Logic:**
   1. Step by step

3. Create `ServiceName`
   - Methods and their logic
   **Dependencies:**
   - List with references

4. Create new entity: `EntityName`
   **Entity Properties:**
   - Fields with types
   **Indexes:**
   - Index definitions
   **Notes:**
   - Usage and considerations

## Existing Entities Referenced
**ExistingEntity**
- Relevant information
```

## Quality Checklist

- [ ] All endpoints have request/response formats
- [ ] All parameters have types and required/optional flag
- [ ] Logic flows are step-by-step
- [ ] Error scenarios are documented
- [ ] Database fields have types and constraints
- [ ] Indexes are defined for lookups
- [ ] Dependencies are identified (existing vs new)
- [ ] Integration points are detailed
- [ ] Edge cases are handled
- [ ] Future extensibility is considered

## Installation

**Project-level:**
```bash
cp -r SKILLS/skills/create-technical-requirements /path/to/your/project/.claude/skills/
```

**Personal:**
```bash
mkdir -p ~/.claude/skills
cp -r SKILLS/skills/create-technical-requirements ~/.claude/skills/
```

## Best Practices

1. **Start with the big picture** - Understand the full context before diving into details
2. **Be comprehensive** - Include all edge cases and error scenarios
3. **Think about data flow** - Document how data moves through the system
4. **Reference existing code** - Link to relevant files and components
5. **Consider maintainability** - Document why decisions were made
6. **Plan for testing** - Include testable requirements
7. **Think about operations** - Consider monitoring, logging, and debugging needs

## Tips

- Always specify data types and constraints
- Document both happy path and error cases
- Include examples for complex formats
- Reference existing patterns in the codebase
- Consider performance and scalability implications
- Think about backward compatibility
- Plan database migrations carefully
