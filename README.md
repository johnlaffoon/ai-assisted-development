# ai-assisted-development

**A workspace for building, specializing, and documenting advanced GitHub Copilot agents and prompt templates.**

> **Note:** C# code quality and testing standards are defined in the shared instruction files:
>
> - `.github/instructions/csharp.instructions.md`
> - `.github/instructions/csharp-testing.instructions.md`
>
> Agent and prompt files focus on specialization, orchestration, and scenario-specific guidance. Refer to the instruction files for general coding standards.

---

## Overview

The `ai-assisted-development` project provides a foundation for creating, customizing, and documenting GitHub Copilot agents and prompt templates. It is designed for teams and individuals who want to enhance Copilot's coding capabilities for specific technologies, workflows, and best practices.

Key features include:

- Modular agent and prompt template system
- File-based configuration for specialization
- Documentation and instruction files for team/project standards
- Support for C#, TypeScript, Angular, and more

Whether you're onboarding new contributors or building advanced automation, this workspace helps you get the most out of Copilot.


### Key Features

- **Agent Specialization**: Easily configure Copilot agents for your domain or technology.
- **Prompt Templates**: Create reusable prompts for common development scenarios.
- **Team Instructions**: Document coding standards and practices for consistent output.
- **Accessibility Reviews**: Automated accessibility checks for WCAG 2.2 Level AA compliance using the Accessibility Expert agent.
- **Extensible Structure**: Add new agents, instructions, and prompts as your needs evolve.

---

## Available Agents

- `.github/agents/csharp-expert.agent.md`: Expert C#/.NET coding guidance, architecture, testing, and security best practices.
- `.github/agents/accessibility-expert.agent.md`: Accessibility reviewer enforcing WCAG 2.2 Level AA across markup and styles. Triggers on changes to HTML/JSX/TSX/Vue/Svelte and CSS/SCSS/SASS/LESS/CSS-in-JS files. Invoke via comments `@copilot wcag` or `@copilot accessibility`.

---

## Table of Contents

- [ai-assisted-development](#ai-assisted-development)
  - [Overview](#overview)
    - [Key Features](#key-features)
  - [Table of Contents](#table-of-contents)
  - [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Installation](#installation)
    - [Quick Start](#quick-start)
  - [Shared Folder Junction Automation](#shared-folder-junction-automation)
    - [Purpose](#purpose)
    - [Usage](#usage)
    - [Quick Commands](#quick-commands)
    - [Notes](#notes)
  - [General Usage](#general-usage)
  - [Configuration](#configuration)
  - [Development](#development)
    - [Project Structure](#project-structure)
    - [Running Tests](#running-tests)
    - [Building](#building)
  - [Contributing](#contributing)

---

## Getting Started

### Prerequisites

- **Git** (latest)
- **Node.js** (recommended for TypeScript/Angular development)
- **.NET SDK** (recommended for C# development)
- **npm** (for managing TypeScript dependencies)

### Installation

Clone the repository:

```bash
git clone https://github.com/johnlaffoon/ai-assisted-development.git
cd ai-assisted-development
```

Install dependencies (if applicable):

```bash
# For TypeScript/Angular projects
npm install
```

### Quick Start

Explore the `.github` folder for agent, prompt, and instruction templates. Customize files as needed for your team or project.

---

## Shared Folder Junction Automation

To enable modular sharing of agent, instructions, and prompt folders across multiple repositories, use the per-folder PowerShell scripts.

### Purpose

- Creates Windows junction points in your project repo for shared folders from a central/shared repo.
- Ensures `.gitignore` in your project repo ignores these shared folders.
- Supports agents, instructions, and prompts via separate scripts.

### Usage

Run the appropriate script from the shared repo location:

```powershell
# For agents
powershell -File .\link-shared-agents.ps1 -ProjectRepoPath <absolute path to your project repo>
# For instructions
powershell -File .\link-shared-instructions.ps1 -ProjectRepoPath <absolute path to your project repo>
# For prompts
powershell -File .\link-shared-prompts.ps1 -ProjectRepoPath <absolute path to your project repo>
```

Each script creates a junction for the respective `.github/<folder>` and updates `.gitignore` accordingly. Use these when you only need to link specific folders.

### Quick Commands

```powershell
# Example: link shared folders into a project repo
$project = 'E:\GitHub\my-project-repo'
powershell -File .\link-shared-agents.ps1 -ProjectRepoPath $project
powershell -File .\link-shared-instructions.ps1 -ProjectRepoPath $project
powershell -File .\link-shared-prompts.ps1 -ProjectRepoPath $project
```

### Notes

- Junctions require NTFS volumes on Windows. On non-NTFS file systems, junction creation will fail. If you need cross-platform links, consider using symlinks with appropriate permissions.
- Ensure you have sufficient permissions to create junctions in the target project path.

---

## General Usage

- **Specialize Copilot Agents**: Edit files in `.github/agents/` and `.github/instructions/` to define agent behaviors and coding standards.
- **Create Prompt Templates**: Add new prompt files in `.github/prompts/` for common tasks (see `README.prompts.md` for guidance).
- **Document Team Practices**: Use `.github/docs/` to share best practices and onboarding info.

---

## Configuration

Configuration is file-based. See:

- `.github/agents/` for agent definitions
- `.github/instructions/` for team/project instructions
- `.github/prompts/` for prompt templates

Refer to the documentation files in `.github/docs/` for examples and tips.

---

## Development

### Project Structure

```text
ai-assisted-development/
├── .github/
│   ├── agents/           # Copilot agent definitions
│   ├── docs/             # Documentation and usage guides
│   ├── instructions/     # Team/project instructions
│   ├── prompts/          # Prompt templates
│   └── copilot-instructions.md # Project-wide Copilot guidance
├── README.md
```

### Running Tests

This workspace is primarily for configuration and documentation. If you add code, use standard tools:

- **C#**: xUnit
- **TypeScript**: npm test, Jest, or Angular CLI

### Building

No build steps required for documentation/configuration. For code, use standard build tools for your language.

---

## Contributing

Contributions are welcome! To help:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

See [README.prompts.md](.github/docs/README.prompts.md), [README.agents.md](.github/docs/README.agents.md), and [README.instructions.md](.github/docs/README.instructions.md) for more info.
