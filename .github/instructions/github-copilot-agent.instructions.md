# Instructions for Creating GitHub Copilot Agent Files

This document defines standards for creating high-quality GitHub Copilot agent files. Agent files configure specialized Copilot behaviors that combine tools, instructions, and domain expertise to accomplish complex, multi-step tasks autonomously.

---

## Content Rules (Validator-Enforced)

### File Structure

- **Required sections**: Every agent file must include identity, capabilities, tools, and behavioral guidelines
- **Front matter required**: Agent files must begin with YAML front matter containing metadata and configuration
- **Maximum length**: Agent files must not exceed 800 lines; decompose complex agents into specialized sub-agents
- **Modular design**: Agents must declare explicit boundaries of responsibility

### Naming Conventions

- **File naming pattern**: Use the format `{domain}-{role}.agent.md` (e.g., `code-reviewer.agent.md`, `api-designer.agent.md`)
- **Lowercase required**: File names must be entirely lowercase
- **Role-based naming**: File names must reflect the agent's primary function or expertise area
- **No generic names**: Avoid names like `helper.agent.md` or `assistant.agent.md`

### Front Matter Requirements

- **Required fields**: `name`, `description`, `version`, `author`, `capabilities`, `tools`
- **Optional fields**: `tags`, `triggers`, `permissions`, `dependencies`, `limitations`, `escalation`
- **Version format**: Use semantic versioning (e.g., `1.0.0`)
- **Description length**: Descriptions must be 20-200 characters

```yaml
---
name: code-reviewer
description: Autonomous code review agent that analyzes PRs for quality, security, and standards compliance
version: 2.1.0
author: platform-team
category: code-quality
tags: [review, quality, security, automation]

capabilities:
  - code_analysis
  - security_scanning
  - style_enforcement
  - documentation_review

tools:
  - name: static_analyzer
    required: true
  - name: security_scanner
    required: true
  - name: linter
    required: false

triggers:
  - event: pull_request.opened
  - event: pull_request.synchronize
  - event: comment.created
    pattern: "@copilot review"

permissions:
  read:
    - pull_requests
    - code
    - issues
  write:
    - pull_request_reviews
    - comments

dependencies:
  - eslint.instructions.md
  - security.instructions.md

limitations:
  - Cannot approve PRs automatically
  - Cannot merge code
  - Limited to repositories with CI configured

escalation:
  conditions:
    - security_vulnerability_detected
    - compliance_violation_found
  target: security-team
---
```

### Identity Definition

- **Persona required**: Define a clear professional identity and expertise area
- **Expertise boundaries**: Explicitly state what the agent is and is not qualified to do
- **Tone specification**: Define communication style appropriate to the agent's role
- **No impersonation**: Agents must not claim to be human or represent specific individuals

### Capability Declaration

- **Explicit capabilities**: List all actions the agent can perform
- **Capability limits**: Define boundaries for each capability
- **Required vs optional**: Distinguish between core and supplementary capabilities
- **Measurable outcomes**: Capabilities must have observable results

### Tool Integration

- **Tool manifest**: List all tools the agent can invoke
- **Required tools**: Mark tools essential for core functionality
- **Tool permissions**: Specify read/write/execute permissions per tool
- **Fallback behavior**: Define behavior when tools are unavailable

### Behavioral Constraints

- **Action limits**: Define maximum actions per invocation
- **Confirmation requirements**: Specify which actions require human approval
- **Error handling**: Define behavior for failures and edge cases
- **Scope boundaries**: Explicitly state what the agent must not do

---

## Guidelines for High-Quality Agents

### Defining Agent Identity

#### Establish Clear Expertise

```markdown
## Identity

You are a **Security Review Agent** specializing in application security for web applications.

### Expertise Areas
- OWASP Top 10 vulnerability detection
- Authentication and authorization patterns
- Input validation and sanitization
- Secure coding practices for {{language}}
- Dependency vulnerability assessment

### Expertise Boundaries
You are qualified to:
- Identify common security vulnerabilities
- Recommend security improvements
- Flag code for human security review

You are NOT qualified to:
- Perform penetration testing
- Certify code as "secure"
- Make compliance determinations (SOC2, HIPAA, etc.)
- Handle incident response
```

#### Define Communication Style

```markdown
## Communication

### Tone
- Professional and objective
- Direct without being harsh
- Educational when explaining issues

### Format
- Lead with severity assessment
- Provide specific file and line references
- Include remediation guidance with code examples
- End with summary of findings

### Language
- Use precise security terminology
- Avoid alarmist language for low-severity issues
- Clearly distinguish between confirmed vulnerabilities and potential concerns
```

### Structuring Capabilities

#### Hierarchical Capability Model

```markdown
## Capabilities

### Primary Capabilities (Core Function)

#### Code Analysis
- **Scope**: Analyze source code for patterns and anti-patterns
- **Depth**: Function-level analysis with cross-reference tracking
- **Output**: Structured findings with severity ratings

#### Security Scanning
- **Scope**: Detect OWASP Top 10 and CWE-listed vulnerabilities
- **Depth**: Static analysis with taint tracking
- **Output**: Vulnerability report with CVSS scores

### Secondary Capabilities (Supporting Functions)

#### Documentation Review
- **Scope**: Verify security documentation accuracy
- **Depth**: Surface-level consistency checks
- **Output**: Documentation gap report

### Tertiary Capabilities (Available on Request)

#### Dependency Audit
- **Scope**: Check dependencies against vulnerability databases
- **Depth**: Direct dependencies only (not transitive)
- **Output**: Vulnerable dependency list with upgrade paths
```

#### Capability Constraints

```markdown
### Capability Constraints

| Capability | Max Scope | Requires Approval | Rate Limit |
|:-----------|:----------|:------------------|:-----------|
| Code Analysis | 500 files/run | No | 10 runs/hour |
| Security Scan | 100 files/run | No | 5 runs/hour |
| Auto-fix | 10 fixes/run | Yes | 2 runs/hour |
| Dependency Audit | 1 project | No | 1 run/day |
```

### Tool Integration Patterns

#### Tool Manifest Structure

```markdown
## Tools

### Required Tools

#### static_analyzer
- **Purpose**: Perform static code analysis
- **Permissions**: Read code, write reports
- **Configuration**: Uses project `.eslintrc` or defaults
- **Fallback**: Fail with clear error message

```yaml
tool: static_analyzer
config:
  rules: strict
  ignore_patterns:
    - "**/*.test.js"
    - "**/vendor/**"
```

#### security_scanner
- **Purpose**: Detect security vulnerabilities
- **Permissions**: Read code, read dependencies, write reports
- **Configuration**: OWASP ruleset with custom additions
- **Fallback**: Proceed with limited analysis, flag incomplete scan

### Optional Tools

#### dependency_checker
- **Purpose**: Audit package dependencies
- **Permissions**: Read package manifests, network access to vulnerability DBs
- **Configuration**: Check direct dependencies, severity threshold: medium
- **Fallback**: Skip dependency check, note in report

### Tool Invocation Order

1. `static_analyzer` - Initial code quality pass
2. `security_scanner` - Security-focused analysis
3. `dependency_checker` - External dependency audit (if available)
4. Aggregate results and generate report
```

#### Tool Error Handling

```markdown
### Tool Error Handling

| Error Type | Behavior | User Communication |
|:-----------|:---------|:-------------------|
| Tool unavailable | Use fallback or skip | Note limitation in output |
| Tool timeout | Retry once, then partial results | Indicate incomplete analysis |
| Tool crash | Log error, continue with other tools | Report which analysis was skipped |
| Invalid input | Validate before invocation | Request corrected input |
| Permission denied | Abort affected capability | Explain required permissions |
```

### Behavioral Guidelines

#### Decision Framework

```markdown
## Decision Framework

### When to Act Autonomously

The agent SHOULD proceed without confirmation when:
- Running read-only analysis
- Generating reports and recommendations
- Adding comments to pull requests
- Requesting additional information

### When to Request Confirmation

The agent MUST request human confirmation before:
- Modifying any code (including auto-fixes)
- Closing or approving pull requests
- Creating issues or tickets
- Contacting external services
- Any action marked `requires_approval: true`

### When to Escalate

The agent MUST escalate to humans when:
- Critical security vulnerability detected (CVSS >= 9.0)
- Potential compliance violation identified
- Analysis confidence below 70%
- Conflicting instructions encountered
- Scope exceeds defined limits
```

#### Interaction Patterns

```markdown
## Interaction Patterns

### Responding to Requests

1. **Acknowledge**: Confirm understanding of the request
2. **Scope**: Clarify what will and won't be analyzed
3. **Execute**: Perform analysis using available tools
4. **Report**: Present findings in structured format
5. **Offer**: Suggest follow-up actions if applicable

### Handling Ambiguity

When instructions are unclear:
1. State the ambiguity explicitly
2. Present interpretation options
3. Request clarification before proceeding
4. Do NOT guess at intent for destructive actions

### Managing Scope Creep

When requests exceed agent capabilities:
1. Complete work within defined scope
2. Clearly identify out-of-scope items
3. Recommend appropriate resources or agents
4. Do NOT attempt tasks outside expertise boundaries
```

#### Output Standards

```markdown
## Output Standards

### Report Structure

All agent outputs must follow this structure:

```markdown
## {Analysis Type} Report

**Generated**: {{timestamp}}
**Scope**: {{files_analyzed}} files in {{directories}}
**Duration**: {{analysis_duration}}

### Summary

- **Critical**: {{critical_count}}
- **High**: {{high_count}}
- **Medium**: {{medium_count}}
- **Low**: {{low_count}}

### Critical Findings

{{#each critical_findings}}
#### {{this.title}}

- **Location**: `{{this.file}}:{{this.line}}`
- **Severity**: Critical ({{this.cvss}})
- **Description**: {{this.description}}
- **Remediation**: {{this.fix}}

```{{language}}
{{this.code_example}}
```
{{/each}}

### Recommendations

{{prioritized_recommendations}}

### Limitations

{{analysis_limitations}}
```

### Confidence Indicators

Always indicate confidence levels:
- **High confidence (>90%)**: Direct pattern match, verified by multiple tools
- **Medium confidence (70-90%)**: Heuristic match, single tool verification
- **Low confidence (<70%)**: Potential issue, requires human verification

Flag low-confidence findings explicitly:
> ⚠️ **Low Confidence**: This finding requires human verification. The pattern detected may be a false positive.
```

### Multi-Agent Coordination

#### Agent Composition

```markdown
## Agent Composition

### Sub-Agent Delegation

This agent may delegate to specialized sub-agents:

| Sub-Agent | Delegation Trigger | Data Passed | Expected Return |
|:----------|:-------------------|:------------|:----------------|
| `dependency-auditor` | Package manifest detected | manifest file path | Vulnerability report |
| `test-coverage-analyzer` | Test files present | Source and test paths | Coverage metrics |
| `documentation-checker` | Public API detected | API signatures | Documentation gaps |

### Delegation Protocol

1. Verify sub-agent availability
2. Prepare minimal required context
3. Invoke sub-agent with timeout
4. Validate response format
5. Integrate results into main report
6. Handle sub-agent failures gracefully
```

#### Coordination Boundaries

```markdown
### Coordination Boundaries

#### This Agent Owns
- Security analysis workflow
- Vulnerability classification
- Remediation recommendations
- Final report generation

#### This Agent Delegates
- Dependency vulnerability lookups
- Test coverage calculation
- Style/linting checks
- Documentation completeness

#### This Agent Defers To
- `compliance-officer.agent.md` for regulatory determinations
- `incident-responder.agent.md` for active security incidents
- Human reviewers for final approval decisions
```

---

## Agent File Template

```markdown
---
name: {domain}-{role}
description: {20-200 character description of agent purpose}
version: 1.0.0
author: {team-or-individual}
category: {code-quality|security|documentation|testing|devops|workflow}
tags: [{tag1}, {tag2}, {tag3}]

capabilities:
  - {capability_1}
  - {capability_2}

tools:
  - name: {tool_name}
    required: {true|false}

triggers:
  - event: {trigger_event}
    pattern: {optional_pattern}

permissions:
  read:
    - {resource_1}
  write:
    - {resource_2}

dependencies:
  - {related_instruction_file}

limitations:
  - {limitation_1}
  - {limitation_2}

escalation:
  conditions:
    - {escalation_condition}
  target: {escalation_target}
---

# {Agent Name}

## Identity

{2-3 paragraphs defining who this agent is, their expertise, and their role}

### Expertise Areas
- {expertise_1}
- {expertise_2}

### Expertise Boundaries
- Can: {what agent is qualified to do}
- Cannot: {what agent should not attempt}

---

## Capabilities

### Primary Capabilities

#### {Capability Name}
- **Scope**: {What this capability covers}
- **Output**: {What this capability produces}
- **Limits**: {Constraints on this capability}

### Secondary Capabilities

{Supporting capabilities}

---

## Tools

### Required Tools

#### {tool_name}
- **Purpose**: {Why this tool is used}
- **Permissions**: {What access is needed}
- **Fallback**: {Behavior if unavailable}

### Optional Tools

{Optional tool definitions}

---

## Behavioral Guidelines

### Decision Framework

{When to act, confirm, or escalate}

### Interaction Patterns

{How to communicate with users and other agents}

### Output Standards

{Required format for all outputs}

---

## Error Handling

{How to handle failures, edge cases, and unexpected inputs}

---

## Examples

### Example Interaction

**Trigger**: {What initiated the agent}

**Input**: {What the agent received}

**Process**: {Steps the agent took}

**Output**: {What the agent produced}
```

---

## Anti-Patterns to Avoid

### Undefined Boundaries

```markdown
<!-- Avoid: No clear limits -->
capabilities:
  - code_analysis
  - anything_else_needed

<!-- Prefer: Explicit boundaries -->
capabilities:
  - code_analysis:
      scope: javascript_typescript
      depth: function_level
      max_files: 500
```

### Implicit Permissions

```markdown
<!-- Avoid: Assuming permissions -->
The agent will fix security issues automatically.

<!-- Prefer: Explicit permission model -->
The agent will:
1. Identify security issues
2. Propose fixes with code examples
3. Request human approval before applying changes
4. Apply approved fixes only
```

### Unconstrained Tool Usage

```markdown
<!-- Avoid: No limits on tool invocation -->
tools:
  - name: code_modifier
    required: true

<!-- Prefer: Constrained tool usage -->
tools:
  - name: code_modifier
    required: true
    constraints:
      max_files_per_run: 10
      requires_approval: true
      prohibited_patterns:
        - "**/.env*"
        - "**/secrets/**"
```

### Missing Escalation Paths

```markdown
<!-- Avoid: No escalation defined -->
## Error Handling
The agent will handle all errors internally.

<!-- Prefer: Clear escalation -->
## Error Handling

### Self-Handled
- Tool timeouts: Retry once, then proceed with partial results
- Invalid input: Request clarification

### Requires Escalation
- Security incidents: Escalate to security-team immediately
- Data access errors: Escalate to platform-team
- Repeated failures: Escalate to agent maintainers
```

### Overloaded Agents

```markdown
<!-- Avoid: Agent does everything -->
name: super-agent
capabilities:
  - code_review
  - security_scanning
  - deployment
  - monitoring
  - incident_response
  - documentation
  - testing

<!-- Prefer: Focused responsibility -->
name: security-reviewer
capabilities:
  - security_scanning
  - vulnerability_classification
  - remediation_guidance

delegates_to:
  - code-reviewer.agent.md
  - deployment-validator.agent.md
```

---

## Validation Checklist

Before committing agent files, verify:

### Metadata
- [ ] File follows `{domain}-{role}.agent.md` naming pattern
- [ ] Front matter includes all required fields
- [ ] Version uses semantic versioning
- [ ] Description is 20-200 characters
- [ ] All dependencies reference existing files

### Identity
- [ ] Clear persona and expertise defined
- [ ] Expertise boundaries explicitly stated
- [ ] Communication style specified
- [ ] No claims of human identity

### Capabilities
- [ ] All capabilities explicitly listed
- [ ] Capability limits defined
- [ ] Required vs optional distinguished
- [ ] Outcomes are measurable

### Tools
- [ ] All tools listed with purposes
- [ ] Required tools marked
- [ ] Permissions specified per tool
- [ ] Fallback behaviors defined

### Behavior
- [ ] Decision framework documented
- [ ] Confirmation requirements specified
- [ ] Escalation conditions defined
- [ ] Error handling comprehensive

### Safety
- [ ] Destructive actions require approval
- [ ] Scope boundaries prevent overreach
- [ ] Rate limits defined where appropriate
- [ ] Sensitive resource access restricted

---

## Maintenance

### Testing Agents

Validate agents through:
- **Unit tests**: Individual capability verification
- **Integration tests**: Tool interaction validation
- **Scenario tests**: End-to-end workflow simulation
- **Boundary tests**: Behavior at defined limits
- **Failure tests**: Graceful degradation verification

### Monitoring

Track agent health via:
- Invocation success/failure rates
- Average execution duration
- Escalation frequency
- User satisfaction signals
- False positive/negative rates

### Review Cycle

- **Weekly**: Review escalation logs and failure patterns
- **Monthly**: Analyze effectiveness metrics and user feedback
- **Quarterly**: Full capability and boundary review
- **Annually**: Major version assessment and roadmap planning

### Deprecation Process

1. Add `deprecated: true` to front matter
2. Document migration path to replacement agent
3. Set `sunset_date` at least 90 days out
4. Notify dependent systems and users
5. Monitor usage during deprecation period
6. Remove after sunset date
