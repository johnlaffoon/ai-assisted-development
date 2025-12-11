
# Specializing Your GitHub Copilot Coding Agent

Easily specialize your GitHub Copilot coding agent for your project's needs using simple file-based configuration. No code changes required.

> **Note:** C# code quality, naming, and testing standards are defined in the shared instruction files:
>
> - [csharp.instructions.md](../instructions/csharp.instructions.md)
> - [csharp-testing.instructions.md](../instructions/csharp-testing.instructions.md)
>
> Agent files should focus on specialization, orchestration, and domain-specific behaviors—not on duplicating general C# standards.

## How to Specialize Your Agent

**Create or Edit Configuration Files:**

- Place configuration files in your repository (e.g., `.github/instructions/`, `.github/agent-config/`, or similar folders).
- Use clear, descriptive filenames (e.g., `copilot-specialization.md`, `agent.instructions.md`).

**Define Agent Behaviors or Rules:**

- Add markdown or text files with instructions, rules, or preferences for your agent.
- Example: Specify coding standards, preferred libraries, or project-specific conventions.

**Commit and Push:**

- Commit your configuration files to your repository. The agent will automatically use these files to guide its behavior.

## Example

```markdown
// .github/agents/csharp-expert.agent.md
---
description: Use numpy for all array operations. Follow PEP8 style. Always write docstrings.
---
```

## Tips

- Use multiple files for different purposes (e.g., prompts, instructions, tool configs).
- Update configuration files at any time to adjust agent behavior.
- For advanced customization, see additional documentation or examples in this repo.
