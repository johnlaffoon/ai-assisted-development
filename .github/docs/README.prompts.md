
# Creating Ready-to-Use Prompt Templates

You can define prompt templates for specific development scenarios and tasks to streamline your workflow. Prompt templates let you predefine the prompt text, mode, model, and available set of tools for your coding agent.

> **Note:** Prompt templates can reference shared instruction files (such as [csharp.instructions.md](../instructions/csharp.instructions.md)) to ensure generated code follows project standards. Templates should focus on scenario- or task-specific prompting, not on duplicating general coding rules.

## How to Create a Prompt Template

**Create a Prompt Template File:**

- Place your template in a dedicated folder (e.g., `.github/prompts/` or `.github/templates/`).
- Use a clear filename, such as `python-bugfix.prompt.md` or `refactor-js.prompt.md`.

**Define Template Content:**

- **Prompt Text:** Describe the scenario or task (e.g., "Refactor this function for readability.").
- **Mode:** Specify the mode (e.g., `code`, `chat`, `review`).
- **Model:** Indicate the preferred model (e.g., `gpt-4.1`, `gpt-3.5-turbo`).
- **Tools:** List the tools or APIs the agent should use (e.g., `pytest`, `black`, `npm`).

## Example

```markdown
---
prompt: "Write unit tests for the following Python function."
mode: code
model: gpt-4.1
tools: [pytest, coverage]
---
```

## Tips

- Use one template per file for clarity.
- Update templates as your project evolves.
- Organize templates by language, task, or team preference.
