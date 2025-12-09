# Markdown Instructions for GitHub Copilot

This document defines documentation and content creation standards for markdown files. These rules are enforced by validators and should be followed for all markdown content.

---

## Content Rules (Validator-Enforced)

### Headings

- **H1 usage**: Each document must have exactly one H1 (`#`) heading at the top
- **Heading hierarchy**: Never skip heading levels (e.g., don't jump from H2 to H4)
- **Heading format**: Use ATX-style headings (`#`) not Setext-style (underlines)
- **No trailing punctuation**: Headings must not end with periods, colons, or semicolons
- **Unique headings**: All headings within a document must be unique for anchor linking

### Links

- **No broken links**: All internal links must resolve to existing files or anchors
- **Descriptive link text**: Never use "click here" or "link" as link text
- **Relative paths**: Use relative paths for internal documentation links
- **External link format**: External links must include the protocol (`https://`)

### Lists

- **Consistent markers**: Use either `-` or `*` for unordered lists, not both in the same document
- **Ordered list numbering**: Use `1.` for all items in ordered lists (auto-numbering)
- **List spacing**: Include a blank line before and after lists
- **Nested list indentation**: Use 2 spaces for nested list items

### Code

- **Fenced code blocks**: Use triple backticks, not indentation, for code blocks
- **Language specification**: Always specify the language after opening backticks
- **Inline code**: Use backticks for inline code, file names, and commands
- **No bare URLs**: Wrap URLs in angle brackets or use proper link syntax

### Images

- **Alt text required**: All images must have descriptive alt text
- **Relative paths**: Use relative paths for images stored in the repository
- **File naming**: Image files should use lowercase with hyphens (e.g., `my-diagram.png`)

### Tables

- **Header row required**: All tables must have a header row with alignment indicators
- **Cell alignment**: Use colons in separator row for alignment (`:---`, `:---:`, `---:`)
- **No empty cells**: Use "N/A" or "-" for cells with no applicable value

### Whitespace

- **Single trailing newline**: Files must end with exactly one newline character
- **No trailing whitespace**: Lines must not have trailing spaces
- **Blank line limits**: No more than one consecutive blank line
- **Line length**: Lines should not exceed 120 characters (except for URLs and tables)

---

## Formatting Guidelines

### Document Structure

```markdown
# Document Title

Brief introduction or summary paragraph.

## Overview

Context and background information.

## Main Content

Primary content organized by topic.

### Subsection

Detailed information within a topic.

## Related Resources

Links to related documentation.
```

### Front Matter (When Applicable)

```yaml
---
title: Document Title
description: Brief description for search and previews
author: Author Name
date: YYYY-MM-DD
tags: [tag1, tag2]
---
```

### Writing Style

- **Voice**: Use active voice and direct language
- **Tense**: Use present tense for descriptions, imperative mood for instructions
- **Pronouns**: Use "you" when addressing the reader; avoid "we" unless referring to a specific team
- **Abbreviations**: Define abbreviations on first use, e.g., "Application Programming Interface (API)"

### Code Examples

- Provide context before code blocks explaining what the code does
- Include comments within code for complex logic
- Show expected output when relevant
- Use realistic but simplified examples

```python
# Calculate the factorial of a number
def factorial(n: int) -> int:
    """Return the factorial of n."""
    if n <= 1:
        return 1
    return n * factorial(n - 1)

# Example usage
result = factorial(5)  # Returns 120
```

### Callouts and Admonitions

Use blockquotes with bold labels for callouts:

```markdown
> **Note**: Additional information that may be helpful.

> **Warning**: Important information about potential issues.

> **Tip**: Helpful suggestions for better results.

> **Important**: Critical information that must not be overlooked.
```

### Tables

```markdown
| Parameter | Type     | Required | Description                |
|:----------|:---------|:--------:|:---------------------------|
| `id`      | `string` | Yes      | Unique identifier          |
| `name`    | `string` | Yes      | Display name               |
| `count`   | `number` | No       | Optional count, default: 0 |
```

---

## File Organization

### Naming Conventions

- Use lowercase letters
- Separate words with hyphens (`-`)
- Use descriptive names that reflect content
- Include category prefixes when helpful (e.g., `guide-`, `ref-`, `tutorial-`)

**Examples:**
- `getting-started.md`
- `api-reference.md`
- `tutorial-authentication.md`

### Directory Structure

```
docs/
├── index.md
├── getting-started/
│   ├── installation.md
│   ├── configuration.md
│   └── quick-start.md
├── guides/
│   ├── authentication.md
│   └── deployment.md
├── reference/
│   ├── api.md
│   └── configuration-options.md
└── assets/
    └── images/
```

---

## Accessibility

- Provide alt text that conveys the meaning and purpose of images
- Use semantic heading structure for screen reader navigation
- Ensure sufficient color contrast in diagrams and images
- Provide text alternatives for visual-only content
- Use descriptive link text that makes sense out of context

---

## Version Control

- Write meaningful commit messages for documentation changes
- Keep changes focused—one topic per commit when possible
- Update the document date in front matter when making significant changes
- Mark deprecated content clearly rather than deleting immediately

---

## Validation Checklist

Before committing markdown files, ensure:

- [ ] Single H1 heading at document top
- [ ] Proper heading hierarchy (no skipped levels)
- [ ] All links are valid and use descriptive text
- [ ] Code blocks specify language
- [ ] Images have alt text
- [ ] No trailing whitespace
- [ ] File ends with single newline
- [ ] Tables have header rows
- [ ] Lists have consistent markers
- [ ] Line length under 120 characters
