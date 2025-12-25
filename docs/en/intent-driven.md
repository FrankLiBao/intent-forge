# Intent-Driven Development

## The Power Inversion

For decades, code has been king. Specifications served the code—they were disposable documentation, discarded once the "real work" began. We accepted code as the ultimate artifact of software development, and in the development process, we rushed to the coding phase as quickly as possible. Specifications, design documents, architectural decision records—all of these were merely temporary scaffolding.

Intent-Driven Development inverts this relationship. Specifications no longer merely *guide* implementation—they *generate* implementation. Well-written specifications, paired with modern AI models, can directly produce fully-functional, tested, and architecturally-compliant code. Code becomes a product of the specification, not the other way around.

This is not an incremental improvement—this is a paradigm shift.

## Why Intent-Driven Development Matters Now

Three major trends make Intent-Driven Development possible:

### Trend 1: AI Excels at Specification Interpretation

Modern Large Language Models (LLMs) excel at two key capabilities:

1. **Translating natural language requirements into structured specifications** - AI can extract clear, actionable specifications from user stories, feature descriptions, and business requirements.
2. **Generating working implementations from specifications** - Given good specifications, AI can generate code that conforms to architectural principles, best practices, and testing standards.

These capabilities transform specifications from *documentation* into *executable artifacts*.

### Trend 2: Modern Applications Are Declarative

Modern software stacks are increasingly declarative:

- **Infrastructure**: Terraform, Kubernetes, Docker Compose
- **Frontend**: React (JSX), SwiftUI, Jetpack Compose
- **Backend**: GraphQL schemas, OpenAPI/Swagger, gRPC proto files
- **Database**: Prisma schemas, SQL migrations, MongoDB schemas

Declarative systems are perfectly suited for Intent-Driven Development because they are already *specification-first*. Specifications don't just describe what the system should do—they *are* the system itself.

### Trend 3: Accelerating Tech Stack Changes

The pace of tech stack evolution is unprecedented:

- New frontend frameworks every year
- Cloud services continuously rolling out new features
- Language versions evolving rapidly
- Best practices constantly updating

In this environment, prematurely locking in technical details creates technical debt. Intent-Driven Development allows you to define *what to do* at a high level, then generate implementations based on current best practices. Want to switch frameworks? Regenerate. Want to adopt new patterns? Update the specification and re-implement.

## Core Principles

### 1. Specifications Are First-Class Citizens

In Intent-Driven Development, specifications aren't secondary documentation—they are primary artifacts:

- **Version controlled** - Specifications are stored in git alongside code
- **Reviewed** - Pull requests review specifications, not just code
- **Testable** - Specifications contain acceptance criteria that form the basis for tests
- **Evolvable** - Specifications are updated as requirements change, and code is regenerated accordingly

### 2. Separating Intent from Implementation

Intent-Driven Development strictly separates *what to do* (intent) from *how to do it* (implementation):

**Intent Layer**:
- User stories and use cases
- Functional requirements
- Acceptance criteria
- Non-functional requirements (performance, security, accessibility)

**Implementation Layer**:
- Tech stack choices
- Architectural patterns
- Libraries and frameworks
- Deployment strategies

This separation allows you to change the implementation without changing the intent, and vice versa.

### 3. Progressive Refinement

Intent-Driven Development is not a one-shot generation—it's multi-stage refinement:

1. **Constitution Phase** - Establish project-level principles and constraints
2. **Specification Phase** - Define functional requirements and user stories
3. **Clarification Phase** - Resolve ambiguities and under-specified areas
4. **Planning Phase** - Design technical implementation approach
5. **Tasks Phase** - Break down plan into executable tasks
6. **Implementation Phase** - Generate code and execute tasks
7. **Analysis Phase** - Validate consistency and completeness

Each phase builds on the previous one, with details increasing progressively as we move toward implementation.

### 4. Constraints Enable Quality Through Templates

Freeform prompts lead to inconsistent outputs. Intent-Driven Development uses *structured templates* to constrain AI output:

**Specification Templates** include:
- User stories section (required)
- Functional requirements (required)
- Non-functional requirements (optional)
- Technical constraints (optional)
- Acceptance checklist (required)

**Plan Templates** enforce:
- Phase -1: Constitution compliance gating
- Phase 0: Research and technical feasibility
- Phase 1: Design, contracts, and data models
- Core implementation steps
- Validation and testing strategies

Templates act as guardrails, ensuring AI generates comprehensive, consistent, and executable artifacts.

### 5. Constitution as Architectural Authority

Every project starts with a **constitution**—a set of non-negotiable principles that guide all development decisions:

Example principles:
- **Library-first principle** - Prefer libraries over hand-written implementations
- **CLI interface mandate** - All functionality must be accessible from the CLI
- **Test-first requirement** - Write tests before implementation
- **Simplicity principle** - Prefer simple solutions over complex ones

The constitution is automatically enforced during the analysis phase. Specifications or plans that violate the constitution are flagged as critical issues that must be resolved before implementation.

## Intent-Driven Development Workflow

### Complete Workflow

```
User Requirements
    ↓
【Phase 0: Constitution】
/intent.constitution → constitution.md
    ↓
【Phase 1: Specification】
/intent.specify → spec.md
    ↓
【Phase 2: Clarification】(Optional but recommended)
/intent.clarify → Updated spec.md
    ↓
【Phase 3: Planning】
/intent.plan → plan.md, research.md, data-model.md, contracts/
    ↓
【Phase 4: Tasks】
/intent.tasks → tasks.md
    ↓
【Phase 5: Analysis】(Optional but recommended)
/intent.analyze → Analysis report
    ↓
【Phase 6: Implementation】
/intent.implement → Working code
    ↓
Completed Feature
```

### Phase Descriptions

#### Phase 0: Constitution

**Input**: Project principles, architectural constraints, quality standards
**Output**: `constitution.md`
**Purpose**: Establish non-negotiable rules that guide all subsequent decisions

Example constitutional clause:
```markdown
## Article I: Library-First Principle

At every integration point, we prefer mature libraries over custom implementations.

Rationale: Reduce maintenance burden, improve reliability, accelerate development
```

#### Phase 1: Specification

**Input**: Feature descriptions, user stories, business requirements
**Output**: `spec.md`
**Purpose**: Define *what to do*, not *how to do it*

Specifications contain:
- User stories prioritized by importance
- Acceptance scenarios for each story
- Non-functional requirements
- Explicitly excluded scope

#### Phase 2: Clarification

**Input**: Ambiguities and under-specified areas in `spec.md`
**Output**: Updated `spec.md`
**Purpose**: Resolve uncertainty through structured Q&A

AI will:
1. Identify ambiguous areas in the specification
2. Generate targeted clarification questions (maximum 5)
3. Encode answers back into the specification

This reduces downstream rework by resolving ambiguities before implementation.

#### Phase 3: Planning

**Input**: Tech stack choices, architectural constraints
**Output**: `plan.md`, `research.md`, `data-model.md`, `contracts/`
**Purpose**: Translate intent into technical approach

Plans contain:
- **Phase -1**: Constitution compliance check
- **Phase 0**: Technical research and feasibility
- **Phase 1**: API contracts, data models, quickstart
- **Core Implementation**: Implementation steps in dependency order

#### Phase 4: Tasks

**Input**: `plan.md`
**Output**: `tasks.md`
**Purpose**: Break down plan into executable, dependency-ordered tasks

Task characteristics:
- Organized by user story
- Marked for parallelism `[P]`
- Include file paths
- Test-first ordering

#### Phase 5: Analysis (Optional)

**Input**: `spec.md`, `plan.md`, `tasks.md`, `constitution.md`
**Output**: Analysis report
**Purpose**: Validate consistency before implementation

Analysis checks:
- Coverage gaps between specifications and tasks
- Inconsistencies between plan and specification
- Constitution violations
- Duplicate or conflicting requirements

#### Phase 6: Implementation

**Input**: `tasks.md`
**Output**: Working code, tests, documentation
**Purpose**: Execute the plan

AI will:
1. Read tasks in dependency order
2. Generate code, tests, and documentation
3. Run validation checks
4. Report progress and issues

## Best Practices

### 1. Start Small

Don't try to specify an entire application at once. Start with a single feature:

**Good**: "Users can create an account and log in with email"
**Bad**: "Build a complete platform with authentication, authorization, user management, notifications, and auditing"

### 2. Clarify Early

Run `/intent.clarify` before creating a plan. Resolving ambiguities in the specification phase is much cheaper than during implementation.

### 3. Treat Tests as Acceptance Criteria

Write acceptance scenarios as testable hypotheses:

```markdown
**Given** user has empty shopping cart
**When** they add a product
**Then** cart displays 1 item and correct total price
```

These translate directly into test cases.

### 4. Use Constitution to Enforce Architecture

Don't repeat architectural decisions in every specification. Put them in the constitution once:

```markdown
## Article III: Test-First Requirement

All public API endpoints must have integration tests before implementation.

Enforcement: /intent.analyze will flag tasks missing tests
```

### 5. Separate Intent and Technology

In `/intent.specify`: Talk about *what users can do*
In `/intent.plan`: Talk about *how to implement it*

Don't mix these—it makes it possible to change implementation without changing requirements.

### 6. Review Specifications, Not Just Code

Make specification review part of the pull request process:
1. Review specification for completeness and clarity
2. Review plan for technical approach
3. Review tasks for executability
4. Then review generated code

This catches design issues that traditional code review misses.

## Comparison with Traditional Development

| Aspect | Traditional Development | Intent-Driven Development |
|--------|------------------------|---------------------------|
| **Primary Artifact** | Code | Specification |
| **Specification Role** | Temporary documentation | Executable source of truth |
| **AI Usage** | Code completion, debugging | End-to-end implementation |
| **Change Process** | Modify code | Update specification, regenerate |
| **Review Focus** | Code quality | Specification quality |
| **Technology Lock-in** | Early and rigid | Delayed and flexible |

## When to Use Intent-Driven Development

**Excellent fit**:
- New feature development (greenfield)
- Exploratory prototyping
- API-first projects
- Declarative infrastructure
- Tech stack migrations

**Less suitable**:
- Performance-critical code (requires manual optimization)
- Complex algorithms (require human design)
- Legacy codebase modernization (requires extracting specifications first)

## Conclusion

Intent-Driven Development represents a fundamental shift in software development—from code-first to specification-first. By making specifications executable, we gain:

- **Faster development** - AI handles boilerplate and implementation
- **Better quality** - Templates and constraints ensure consistency
- **Greater flexibility** - Change technology without breaking specifications
- **Clearer communication** - Specifications are the common language among team members

This is not about replacing developers with AI—it's about augmenting developers with AI to focus on what matters: *defining what should be built*, not *how to build it*.

---

**Ready to get started?** Check out [README.md](./README.md) for installation instructions and quick start guide.
