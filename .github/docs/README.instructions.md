
# Creating Team and Project-Specific Instructions

You can guide GitHub Copilot to follow your team's standards and project requirements by adding custom instruction files. These instructions help Copilot generate code that matches your preferred technologies, frameworks, and coding practices.

> **Note:** Detailed C# and testing standards are defined in the shared instruction files:
> - [csharp.instructions.md](../instructions/csharp.instructions.md)
> - [csharp-testing.instructions.md](../instructions/csharp-testing.instructions.md)
>
> Team/project instruction files should not duplicate these rules, but may reference or extend them for domain-specific needs.

## How to Add Instructions

**Create an Instructions File:**

- Place your file in a dedicated folder (e.g., `.github/instructions/` or `.github/copilot/`).
- Use a descriptive filename, such as `python-style.instructions.md` or `react-bestpractices.instructions.md`.

**Define Your Guidelines:**

- List rules, conventions, or preferences for your team or project.
- Example: "Use async/await for all Node.js code. Prefer functional React components. Follow Google Java style guide."

**Commit and Share:**

- Commit the file to your repository. Copilot will use these instructions to improve its suggestions for your team.

## Example

```markdown
---
description: Always use type hints in Python. Write docstrings for every function. Use pytest for testing.
---
```

## Tips

- Use multiple files for different languages or frameworks.
- Update instructions as your team practices evolve.
- Keep instructions clear and actionable for best results.
