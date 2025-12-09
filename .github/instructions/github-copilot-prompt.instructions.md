# Instructions for Creating GitHub Copilot Prompt Files

This document defines standards for creating high-quality GitHub Copilot prompt files. Prompt files are reusable templates that guide Copilot through specific tasks with consistent, predictable results.

---

## Content Rules (Validator-Enforced)

### File Structure

- **Required sections**: Every prompt file must include a title, description, input specification, and output specification
- **Front matter required**: Prompt files must begin with YAML front matter containing metadata
- **Maximum length**: Prompt files must not exceed 300 lines; complex workflows should be split into chained prompts
- **Template markers**: Use consistent placeholder syntax throughout the file

### Naming Conventions

- **File naming pattern**: Use the format `{action}-{subject}.prompt.md` (e.g., `generate-unit-test.prompt.md`, `review-pull-request.prompt.md`)
- **Lowercase required**: File names must be entirely lowercase
- **Verb-first naming**: File names must begin with an action verb
- **No abbreviations**: Use full words in file names for clarity

### Front Matter Requirements

- **Required fields**: `name`, `description`, `version`, `author`
- **Optional fields**: `tags`, `inputs`, `outputs`, `dependencies`, `category`
- **Version format**: Use semantic versioning (e.g., `1.0.0`)
- **Description length**: Descriptions must be 10-150 characters

```yaml
---
name: generate-unit-test
description: Generates unit tests for a given function or class
version: 1.2.0
author: team-name
category: testing
tags: [testing, unit-test, automation]
inputs:
  - name: source_code
    type: string
    required: true
    description: The function or class to test
  - name: framework
    type: enum
    values: [jest, mocha, pytest, junit]
    required: true
outputs:
  - name: test_file
    type: string
    description: Generated test file content
---
```

### Placeholder Syntax

- **Consistent delimiters**: Use double curly braces for all placeholders: `{{placeholder_name}}`
- **Snake case**: Placeholder names must use snake_case
- **Descriptive names**: Placeholder names must clearly indicate expected content
- **No nested placeholders**: Placeholders must not contain other placeholders
- **Default values**: Optional placeholders must specify defaults using `{{placeholder_name:default_value}}`

### Input Validation

- **Type specification**: All inputs must declare their expected type
- **Required flag**: All inputs must explicitly state whether they are required
- **Validation rules**: Include constraints for inputs (min/max length, patterns, allowed values)
- **Example values**: Provide example values for each input

### Output Specification

- **Format declaration**: Specify the expected output format (code, markdown, JSON, etc.)
- **Structure definition**: Define the structure of complex outputs
- **Success criteria**: State what constitutes successful output
- **Error handling**: Define expected behavior for edge cases

---

## Guidelines for High-Quality Prompts

### Writing Effective Prompts

#### Be Explicit About Context

```markdown
<!-- Bad: Assumes context -->
Write tests for this code.

<!-- Good: Provides full context -->
You are a senior software engineer writing unit tests.

**Context**:
- Language: {{language}}
- Testing framework: {{test_framework}}
- Code coverage target: {{coverage_target:80}}%

**Task**: Generate comprehensive unit tests for the following code that cover:
1. Happy path scenarios
2. Edge cases
3. Error conditions

**Source Code**:
```{{language}}
{{source_code}}
```
```

#### Structure with Clear Sections

```markdown
## Role

You are an expert {{domain}} developer specializing in {{specialty}}.

## Context

{{background_information}}

## Task

{{specific_task_description}}

## Constraints

- {{constraint_1}}
- {{constraint_2}}

## Input

{{input_content}}

## Expected Output

{{output_format_description}}
```

#### Provide Output Examples

```markdown
## Output Format

Return the result as a JSON object with the following structure:

```json
{
  "summary": "Brief description of changes",
  "changes": [
    {
      "file": "path/to/file",
      "type": "add|modify|delete",
      "description": "What changed and why"
    }
  ],
  "risks": ["potential risk 1", "potential risk 2"],
  "testing_notes": "Suggestions for testing these changes"
}
```
```

### Prompt Categories

#### Code Generation Prompts

Focus on producing functional, production-ready code:

```markdown
---
name: generate-api-endpoint
description: Generates a REST API endpoint with validation and error handling
version: 1.0.0
author: backend-team
category: code-generation
tags: [api, rest, backend]
inputs:
  - name: endpoint_path
    type: string
    required: true
    description: The URL path for the endpoint
    example: /api/users/{id}
  - name: http_method
    type: enum
    values: [GET, POST, PUT, PATCH, DELETE]
    required: true
  - name: request_schema
    type: object
    required: false
    description: JSON schema for request body
  - name: response_schema
    type: object
    required: true
    description: JSON schema for response body
outputs:
  - name: endpoint_code
    type: string
    format: code
    language: "{{language}}"
---

## Role

You are a backend developer creating production-ready API endpoints.

## Task

Generate a {{http_method}} endpoint for `{{endpoint_path}}` that:
1. Validates incoming requests against the provided schema
2. Implements proper error handling with appropriate HTTP status codes
3. Includes logging for debugging and monitoring
4. Follows RESTful conventions

## Request Schema

```json
{{request_schema:{}}}
```

## Response Schema

```json
{{response_schema}}
```

## Requirements

- Include input validation
- Return appropriate error responses (400, 404, 500)
- Add JSDoc/docstring comments
- Follow {{framework}} conventions
```

#### Code Review Prompts

Focus on identifying issues and suggesting improvements:

```markdown
---
name: review-code-quality
description: Reviews code for quality issues and improvement opportunities
version: 1.0.0
author: quality-team
category: code-review
tags: [review, quality, refactoring]
inputs:
  - name: code
    type: string
    required: true
  - name: language
    type: string
    required: true
  - name: review_focus
    type: array
    values: [security, performance, readability, maintainability, testing]
    required: false
    default: [readability, maintainability]
outputs:
  - name: review_report
    type: object
    format: markdown
---

## Role

You are a senior developer conducting a thorough code review.

## Review Focus Areas

{{#each review_focus}}
- {{this}}
{{/each}}

## Code to Review

```{{language}}
{{code}}
```

## Task

Analyze the code and provide:

1. **Critical Issues**: Problems that must be fixed before merging
2. **Warnings**: Issues that should be addressed but aren't blocking
3. **Suggestions**: Improvements that would enhance code quality
4. **Positive Observations**: Good practices worth highlighting

## Output Format

For each finding, include:
- Location (line number or function name)
- Severity (critical/warning/suggestion/positive)
- Description of the issue
- Recommended fix with code example
```

#### Documentation Prompts

Focus on generating clear, comprehensive documentation:

```markdown
---
name: generate-api-documentation
description: Generates API documentation from code
version: 1.0.0
author: docs-team
category: documentation
tags: [docs, api, openapi]
inputs:
  - name: source_code
    type: string
    required: true
  - name: doc_format
    type: enum
    values: [markdown, openapi, jsdoc]
    required: true
    default: markdown
outputs:
  - name: documentation
    type: string
    format: "{{doc_format}}"
---

## Role

You are a technical writer creating API documentation for developers.

## Source Code

```{{language}}
{{source_code}}
```

## Task

Generate {{doc_format}} documentation that includes:

1. **Overview**: Brief description of the API's purpose
2. **Endpoints**: All available endpoints with methods
3. **Parameters**: Request parameters with types and descriptions
4. **Responses**: Response formats with example payloads
5. **Error Codes**: Possible error responses and their meanings
6. **Examples**: Working code examples for common use cases

## Documentation Standards

- Use clear, concise language
- Include practical examples
- Document all edge cases
- Specify required vs optional parameters
```

#### Refactoring Prompts

Focus on improving existing code:

```markdown
---
name: refactor-for-readability
description: Refactors code to improve readability and maintainability
version: 1.0.0
author: quality-team
category: refactoring
tags: [refactor, clean-code, readability]
inputs:
  - name: code
    type: string
    required: true
  - name: language
    type: string
    required: true
  - name: preserve_behavior
    type: boolean
    required: true
    default: true
outputs:
  - name: refactored_code
    type: string
    format: code
  - name: changes_summary
    type: string
    format: markdown
---

## Role

You are a senior developer refactoring code for improved readability.

## Original Code

```{{language}}
{{code}}
```

## Constraints

- Preserve existing behavior: {{preserve_behavior}}
- Maintain all public interfaces
- Keep changes minimal and focused

## Refactoring Guidelines

Apply these improvements where appropriate:
1. Extract long functions into smaller, focused functions
2. Replace magic numbers with named constants
3. Improve variable and function names
4. Reduce nesting through early returns
5. Remove code duplication
6. Add clarifying comments for complex logic

## Output

Provide:
1. The refactored code
2. A summary of changes made and rationale for each
```

### Handling Complex Workflows

#### Chained Prompts

For multi-step tasks, create a series of prompts that build on each other:

```markdown
---
name: implement-feature-step-1-design
description: First step in feature implementation - creates design document
version: 1.0.0
author: architecture-team
category: workflow
tags: [feature, design, planning]
chain:
  next: implement-feature-step-2-code
  passes:
    - design_document
    - acceptance_criteria
---

## Step 1 of 3: Design

Based on the following feature request, create a technical design document.

## Feature Request

{{feature_description}}

## Output

Generate a design document including:
1. Technical approach
2. Component breakdown
3. Data model changes
4. API contracts
5. Acceptance criteria

The `design_document` and `acceptance_criteria` outputs will be passed to the next step.
```

#### Conditional Sections

Use conditional blocks for optional content:

```markdown
## Input Validation

{{#if request_schema}}
Validate requests against this schema:
```json
{{request_schema}}
```
{{else}}
No request body expected for this endpoint.
{{/if}}

{{#if authentication_required}}
## Authentication

This endpoint requires authentication:
- Method: {{auth_method:bearer}}
- Scopes: {{required_scopes:[]}}
{{/if}}
```

---

## Prompt File Template

```markdown
---
name: {action}-{subject}
description: {Brief description of what this prompt does}
version: 1.0.0
author: {team-or-individual}
category: {code-generation|code-review|documentation|refactoring|testing|workflow}
tags: [{tag1}, {tag2}]
inputs:
  - name: {input_name}
    type: {string|number|boolean|enum|array|object}
    required: {true|false}
    description: {What this input represents}
    example: {Example value}
    default: {Default value if optional}
outputs:
  - name: {output_name}
    type: {string|object|array}
    format: {code|markdown|json|text}
    description: {What this output contains}
---

# {Prompt Title}

## Role

{Define the persona Copilot should adopt}

## Context

{Background information needed to complete the task}

## Task

{Clear description of what should be accomplished}

## Input

{Input content with placeholders}

## Constraints

- {Constraint 1}
- {Constraint 2}

## Output Format

{Describe expected output structure with examples}

## Examples

### Example Input

{Show a realistic input example}

### Example Output

{Show the expected output for the example input}
```

---

## Anti-Patterns to Avoid

### Ambiguous Instructions

```markdown
<!-- Avoid -->
Make the code better.
Fix any issues you find.

<!-- Prefer -->
Refactor the code to:
1. Reduce cyclomatic complexity below 10
2. Extract functions longer than 30 lines
3. Replace nested conditionals with guard clauses
```

### Missing Context

```markdown
<!-- Avoid: No language or framework specified -->
Write a function to parse JSON.

<!-- Prefer: Full context provided -->
Write a TypeScript function using the zod library to parse and validate JSON input against the following schema: {{schema}}
```

### Overly Rigid Templates

```markdown
<!-- Avoid: No flexibility for variations -->
Return exactly 5 test cases.

<!-- Prefer: Adaptable requirements -->
Return test cases covering:
- At least 2 happy path scenarios
- At least 2 edge cases
- At least 1 error condition

Adjust the number of cases based on the complexity of the input code.
```

### Conflicting Instructions

```markdown
<!-- Avoid: Contradictory requirements -->
Keep the code concise. Add detailed comments explaining every line.

<!-- Prefer: Clear priorities -->
Prioritize code readability. Add comments only for:
- Complex algorithms
- Non-obvious business logic
- Workarounds with associated issue links
```

---

## Validation Checklist

Before committing prompt files, verify:

- [ ] File follows `{action}-{subject}.prompt.md` naming pattern
- [ ] File name begins with an action verb
- [ ] Front matter includes all required fields (`name`, `description`, `version`, `author`)
- [ ] Version uses semantic versioning format
- [ ] Description is 10-150 characters
- [ ] All placeholders use `{{snake_case}}` syntax
- [ ] All inputs specify type and required status
- [ ] Optional inputs have default values
- [ ] Output format is clearly specified
- [ ] At least one example is provided
- [ ] File length is under 300 lines
- [ ] No conflicting instructions
- [ ] Role/persona is clearly defined
- [ ] Constraints are explicit and measurable

---

## Maintenance

### Testing Prompts

Validate prompts by testing with:
- Minimal valid inputs
- Maximum complexity inputs
- Edge case inputs
- Invalid inputs (should fail gracefully)

### Version Management

- **Patch version** (1.0.x): Typo fixes, clarifications
- **Minor version** (1.x.0): New optional inputs, improved examples
- **Major version** (x.0.0): Breaking changes to inputs/outputs, significant behavior changes

### Deprecation Process

1. Mark deprecated prompts in front matter: `deprecated: true`
2. Add deprecation notice with migration path
3. Maintain deprecated prompts for at least 2 release cycles
4. Remove with next major version

```yaml
---
name: old-prompt-name
deprecated: true
deprecation_notice: Use new-prompt-name.prompt.md instead. Migration guide at /docs/migration.md
sunset_date: 2025-06-01
---
```
