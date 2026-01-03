---
name: create technical requirements
description: Create comprehensive, step-by-step technical requirements documentation for a given task or feature description. The output should be detailed enough for developers to implement without ambiguity.
---

# Create Technical Requirements

## Goal
Create comprehensive, step-by-step technical requirements documentation for a given task or feature description. The output should be detailed enough for developers to implement without ambiguity.

## When to Use
- Breaking down feature requests into implementable specifications
- Documenting API endpoints and their complete logic
- Defining database entities and their relationships
- Planning service layer architecture
- Outlining integration requirements between systems

## Process

### 1. Understand the Context
- Read the feature description or task
- Identify all systems/components involved
- Understand the data flow and user journey
- Identify existing vs new components

### 2. Structure the Requirements
Organize requirements by component type:
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

### 4. Key Principles

#### Be Explicit
- Specify data types, constraints, and defaults
- Include both success and error scenarios
- Detail validation rules
- Define response codes and formats

#### Provide Context
- Explain WHY decisions are made, not just WHAT
- Add **Logic:** sections for complex business rules
- Include **Notes:** for implementation considerations
- Reference existing code with URLs/paths when relevant

#### Handle Edge Cases
- Document conditional flows (Case A, Case B)
- Specify error handling
- Include validation requirements
- Note optional vs required fields

#### Think About Dependencies
- List existing components to reuse
- Identify new components to create
- Specify external services/libraries
- Include version or reference links

#### Consider the Future
- Add **Future consideration:** for extensibility points
- Note where design allows flexibility
- Suggest patterns that enable scaling

### 5. Use Clear Formatting

#### Sections and Hierarchy
- Use numbered lists for sequential items
- Use nested bullets for details
- Use **bold headings** for subsections
- Use code blocks for formats/examples

#### Inline Code
- Wrap technical terms: `ClassName`, `fieldName`
- Show formats: `prefix_{variable}`
- Display URLs: `https://example.com/path`

#### Notes and Callouts
- **Logic:** for business rules
- **Note:** for important considerations
- **Implementation Note:** for technical guidance
- **Future consideration:** for extensibility

### 6. Reference Section
Include at the end if needed:
```
## Existing Entities Referenced

**EntityName** (context/location)
- Relevant fields
- How it's used in the requirements
```

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

