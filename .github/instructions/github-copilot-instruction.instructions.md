# Instructions for Creating GitHub Copilot Instruction Files

This document defines standards for creating high-quality GitHub Copilot instruction files. These rules ensure consistency, clarity, and effectiveness across all instruction files in the repository.

---

## Content Rules (Validator-Enforced)

### File Structure

- **Required sections**: Every instruction file must include a purpose statement, scope definition, and at least one actionable rule
- **Section ordering**: Place the most frequently referenced rules near the top of the file
- **Maximum file length**: Instruction files must not exceed 500 lines; split large files by domain
- **Single responsibility**: Each instruction file should focus on one domain or concern

### Naming Conventions

- **File naming pattern**: Use the format `{domain}.instructions.md` (e.g., `typescript.instructions.md`, `security.instructions.md`)
- **Lowercase required**: File names must be entirely lowercase
- **No spaces**: Use hyphens to separate words in file names
- **Descriptive names**: File names must clearly indicate the instruction domain

### Rule Formatting

- **Imperative mood**: Write rules as direct commands (e.g., "Use camelCase" not "camelCase should be used")
- **One rule per statement**: Each rule must express a single requirement
- **Specificity required**: Rules must be concrete and actionable, not vague or aspirational
- **No redundancy**: Each rule must appear in exactly one instruction file

### Examples

- **Required examples**: Every rule category must include at least one concrete example
- **Good/bad pairs**: When showing preferred patterns, include both correct and incorrect examples
- **Realistic content**: Examples must reflect actual use cases, not contrived scenarios
- **Syntax highlighting**: Code examples must specify the appropriate language

### Cross-References

- **Valid references only**: All references to other instruction files must point to existing files
- **Relative paths**: Use relative paths for internal references
- **No circular dependencies**: Instruction files must not create circular reference chains
- **Explicit scope boundaries**: Clearly state when another instruction file takes precedence

### Versioning

- **Date required**: Include a last-updated date in the front matter or header
- **Change documentation**: Significant rule changes must be noted in a changelog section or commit message
- **Deprecation notices**: Mark deprecated rules clearly with removal timeline

---

## Guidelines for High-Quality Instructions

### Writing Effective Rules

#### Be Specific and Actionable

```markdown
<!-- Bad: Vague and unenforceable -->
Write clean code.

<!-- Good: Specific and measurable -->
Limit functions to 50 lines or fewer. Extract logic into separate functions when this limit is exceeded.
```

#### Provide Context and Rationale

```markdown
<!-- Bad: Rule without explanation -->
Do not use `any` type.

<!-- Good: Rule with rationale -->
Do not use `any` type. Explicit typing catches errors at compile time and improves code documentation. Use `unknown` when the type is genuinely not known, then narrow with type guards.
```

#### Include Concrete Examples

```markdown
<!-- Bad: Abstract instruction -->
Use meaningful variable names.

<!-- Good: Instruction with examples -->
Use descriptive variable names that reveal intent.

// Avoid
const d = new Date();
const arr = users.filter(u => u.a);

// Prefer
const currentDate = new Date();
const activeUsers = users.filter(user => user.isActive);
```

### Organizing Instructions

#### Group Related Rules

Organize rules into logical sections that reflect how developers encounter them:

```markdown
## Function Design

### Naming
- Prefix boolean-returning functions with `is`, `has`, `can`, or `should`
- Use verbs for functions that perform actions

### Parameters
- Limit functions to 4 parameters maximum
- Use an options object for functions requiring more than 3 parameters

### Return Values
- Return early to reduce nesting
- Prefer returning objects over multiple return values
```

#### Prioritize by Impact

Place the most important and frequently applicable rules first:

1. **Critical rules**: Security, data integrity, breaking changes
2. **Common patterns**: Daily coding decisions
3. **Edge cases**: Situational guidance
4. **Preferences**: Style choices with lower impact

#### Define Clear Scope

```markdown
## Scope

This instruction file applies to:
- All TypeScript files in the `src/` directory
- Test files in `__tests__/` directories
- Shared type definitions in `types/`

This instruction file does not apply to:
- Generated code in `dist/`
- Third-party code in `vendor/`
- Configuration files
```

### Structuring Example Sections

#### Pattern: Rule → Rationale → Example → Counter-Example

```markdown
### Database Queries

**Rule**: Use parameterized queries for all database operations.

**Rationale**: Parameterized queries prevent SQL injection attacks and improve query plan caching.

**Correct**:
```typescript
const user = await db.query(
  'SELECT * FROM users WHERE id = $1',
  [userId]
);
```

**Incorrect**:
```typescript
const user = await db.query(
  `SELECT * FROM users WHERE id = ${userId}`
);
```
```

### Handling Exceptions

Document when rules should be relaxed and the process for doing so:

```markdown
## Exceptions

### When Exceptions Apply
- Legacy code under active migration may defer compliance until refactoring
- Generated code is exempt from formatting rules
- Performance-critical sections may bypass certain patterns with documented justification

### Exception Process
1. Add a comment explaining the exception: `// EXCEPTION: [rule-name] - [reason]`
2. Create a tracking issue for future remediation when applicable
3. Document exceptions in code review
```

---

## Instruction File Template

```markdown
# {Domain} Instructions

> Brief description of what this instruction file covers and its purpose.

**Last Updated**: YYYY-MM-DD
**Applies To**: {scope description}

---

## Overview

{2-3 sentences explaining the domain, why these rules matter, and any key principles}

---

## Rules

### {Category 1}

#### {Rule Name}

{Rule statement in imperative mood}

**Rationale**: {Why this rule exists}

**Example**:
```{language}
{code example}
```

### {Category 2}

...

---

## Exceptions

{When and how rules can be bypassed}

---

## Related Instructions

- [{Related Domain}](./{related-domain}.instructions.md) - {brief description}

---

## Changelog

| Date | Change |
|:-----|:-------|
| YYYY-MM-DD | Initial version |
```

---

## Domain Categories

Organize instruction files by these recommended domains:

| Domain | File Name | Coverage |
|:-------|:----------|:---------|
| Language-specific | `{language}.instructions.md` | Syntax, idioms, type usage |
| Framework-specific | `{framework}.instructions.md` | Framework patterns, lifecycle |
| Testing | `testing.instructions.md` | Test structure, coverage, mocking |
| Security | `security.instructions.md` | Authentication, data protection |
| API Design | `api.instructions.md` | Endpoints, responses, versioning |
| Database | `database.instructions.md` | Queries, migrations, modeling |
| Documentation | `documentation.instructions.md` | Comments, READMEs, changelogs |
| Git | `git.instructions.md` | Commits, branches, workflows |
| Performance | `performance.instructions.md` | Optimization, caching, profiling |
| Accessibility | `accessibility.instructions.md` | WCAG compliance, ARIA usage |

---

## Anti-Patterns to Avoid

### Vague Instructions

```markdown
<!-- Avoid -->
Write good tests.
Keep code clean.
Follow best practices.
```

### Contradictory Rules

Ensure rules across instruction files do not conflict. When overlap exists, explicitly define precedence:

```markdown
<!-- In security.instructions.md -->
## Precedence

Security rules in this file take precedence over convenience patterns defined in other instruction files. When a security rule conflicts with a style or pattern rule, follow the security rule.
```

### Over-Specification

Do not create rules for every possible scenario. Focus on:
- Decisions that recur frequently
- Patterns that significantly impact quality
- Conventions that require consistency across the team

### Outdated Examples

Review examples when dependencies update. Outdated examples mislead Copilot:

```markdown
<!-- Outdated: Old API -->
const response = await fetch(url, { method: 'GET' });
const data = response.json();  // Missing await

<!-- Current: Correct usage -->
const response = await fetch(url, { method: 'GET' });
const data = await response.json();
```

---

## Validation Checklist

Before committing instruction files, verify:

- [ ] File follows `{domain}.instructions.md` naming pattern
- [ ] Purpose and scope are clearly defined
- [ ] All rules are written in imperative mood
- [ ] Each rule is specific and actionable
- [ ] Examples are provided for rule categories
- [ ] Good/bad example pairs are included where helpful
- [ ] Code examples specify language for syntax highlighting
- [ ] Cross-references point to existing files
- [ ] Last-updated date is current
- [ ] No contradictions with other instruction files
- [ ] File length is under 500 lines
- [ ] No redundant rules duplicated from other files

---

## Maintenance

### Review Cycle

- Review instruction files quarterly for relevance
- Update examples when dependencies or APIs change
- Archive deprecated rules with migration guidance
- Solicit feedback from team members on rule clarity

### Measuring Effectiveness

Track instruction file quality through:
- Code review comments citing unclear rules
- Copilot suggestion acceptance rates
- Developer questions about ambiguous guidance
- Linter/validator violation frequency
