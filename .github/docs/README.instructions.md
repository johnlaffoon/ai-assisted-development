


# Creating Team and Project-Specific Instructions

You can guide GitHub Copilot to follow your team's standards and project requirements by adding custom instruction files. These instructions help Copilot generate code that matches your preferred technologies, frameworks, and coding practices.

> **Note:** Detailed C# and testing standards are defined in the shared instruction files:
>
> - [csharp.instructions.md](../instructions/csharp.instructions.md)
> - [csharp-testing.instructions.md](../instructions/csharp-testing.instructions.md)
>
> Team/project instruction files should not duplicate these rules, but may reference or extend them for domain-specific needs.

### Accessibility Instructions


Use these to guide accessibility reviews. See the WCAG agent in `.github/agents/accessibility-expert.agent.md` for automated review triggers and guidance.

## How to Add Instructions

**Create an Instructions File:**


**Define Your Guidelines:**


**Commit and Share:**


## Example

```markdown
description: Always use type hints in Python. Write docstrings for every function. Use pytest for testing.
```

## Tips

