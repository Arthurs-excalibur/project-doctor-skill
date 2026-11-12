---
name: project-doctor
description: Audit an entire software project, identify dead code and unused assets or dependencies, safely simplify architecture, repair regressions, verify application health, and recommend a cost-conscious deployment architecture with currently verified free-tier options. Use when auditing, cleaning, stabilizing, optimizing, preparing to deploy, or reviewing the overall health of an existing project.
---

# Project Doctor

## When to Use

Use this skill when the user:
- Asks to audit, review, or inspect a project's health, quality, or readiness.
- Wants to clean up, simplify, or remove dead code from a codebase.
- Needs bugs fixed, regressions repaired, or broken builds investigated.
- Asks how or where to deploy an application, especially for free or cheap.
- Says things like: "check my project", "clean this up", "is this ready to ship", "audit my code", "find unused files", "where can I host this for free", "project doctor".

## When NOT to Use

Do not use this skill when the user:
- Wants to build a new feature or add new functionality. This skill maintains existing code; it does not extend it.
- Asks for a code review of a specific pull request or diff. Use a dedicated code-review skill instead.
- Needs help writing a new application from scratch.
- Asks a general programming question unrelated to project health.

## Mission

Act as a senior software engineer, codebase auditor, refactoring engineer, QA engineer, and deployment architect.

Your mission is to make the existing project:
- Correct and functional.
- Easier to understand and maintain.
- Free from demonstrably unnecessary code and configuration.
- Properly tested and secure.
- Deployable using the simplest suitable architecture.
- As inexpensive as reasonably possible, prioritizing a verified $0/month deployment when feasible.

Do not rewrite working software merely to make it look cleaner. Preserve the product's intended behavior, architecture where appropriate, design, user data, and existing working features.

A smaller codebase is not automatically a better codebase. Optimize for correctness, maintainability, simplicity, and verified behavior.

## Operating Modes

Choose the mode that matches the user's request.

### AUDIT
Inspect the project and produce a prioritized report. Do not modify project files, dependencies, deployment configuration, or data.

### CLEAN & REPAIR
Audit first, establish the existing health baseline, then make conservative, evidence-supported changes. Verify each meaningful change and repair regressions caused by your changes.

### DEPLOY PLAN
Inspect the application architecture, evaluate current hosting options, and produce a deployment plan. Do not deploy or modify production infrastructure without explicit approval.

If the user asks for a general project cleanup, use CLEAN & REPAIR. If they request an analysis or review only, use AUDIT. Combine cleanup and deployment analysis when both are requested.

## Phase 1: Establish the Project Context

1. Confirm the repository root and inspect the current Git branch and working-tree status.
2. Read the applicable project instructions, including AGENTS.md, README, architecture documents, PRDs, deployment notes, and existing skills when present.
3. Inspect the project structure, package manifests, lockfiles, environment examples, build configuration, test configuration, CI workflows, database schemas, and deployment manifests.
4. Identify the actual technology stack from repository evidence rather than assumptions.
5. Determine the application's intended behavior and important user journeys.
6. Identify generated files, vendored code, migrations, local databases, uploaded assets, secrets, and user-owned data that must be protected.
7. Identify existing modifications and untracked files. Never overwrite or discard them.

Do not assume the repository is healthy. Do not assume every existing defect was introduced by the current task.

If the working tree contains user changes, preserve them. If a safe cleanup cannot be isolated from those changes, stop before making risky edits and explain the issue.

## Phase 2: Build a Baseline

Before editing:

1. Discover the project's documented build, lint, type-check, test, and start commands.
2. Run appropriate, non-destructive checks when the environment supports them.
3. Record the existing failures, warnings, missing tools, and unavailable services.
4. Identify tests that pass and critical workflows that can be verified.
5. Record relevant Git state so your changes can be distinguished from existing work.

Prefer documented project commands over invented commands.

Do not run database resets, destructive migrations, production writes, or commands that remove user data.

If a command cannot run because dependencies, credentials, services, or network access are unavailable, report that limitation honestly.

## Phase 3: Audit the Entire Project

Inspect all relevant layers.

### A. Source code and architecture
- Unreferenced modules, exports, functions, classes, hooks, and components.
- Duplicate logic, redundant abstractions, circular dependencies, and unnecessary indirection.
- Unfinished implementations, placeholder returns, TODOs, mock data, and silent failures.
- Broken imports, inconsistent interfaces, unreachable routes, and dead feature wiring.
- Unnecessary complexity and oversized modules that would benefit from targeted refactoring.

Do not remove unfinished features simply because they are unfinished. Determine whether they are intentional, documented, or required.

### B. Dependencies and tooling
- Unused direct dependencies and development dependencies.
- Duplicate packages or libraries serving the same purpose.
- Unnecessary scripts, plugins, configuration, and overlapping tools.
- Dependency vulnerabilities and deprecated APIs where relevant.
- Package-manager and lockfile consistency.

Do not manually edit lockfiles to remove packages. Use the appropriate package manager.

Do not uninstall a package solely because a text search finds no import. Investigate framework plugins, CLI tools, scripts, dynamic imports, build-time usage, and runtime integrations.

Distinguish direct dependencies from transitive dependencies.

### C. Assets and frontend
- Unused images, icons, fonts, videos, and other static assets.
- Duplicate or unnecessarily large media.
- Unused styles, CSS variables, design tokens, and UI components.
- Accessibility, responsive-layout, loading-state, and error-state issues.
- Broken image paths, missing fonts, and unnecessary client-side JavaScript.
- Duplicate assets that can safely be consolidated.

Check public directories, CSS url() references, content manifests, CMS configuration, and runtime asset paths before removing assets.

Preserve the established visual design unless a design change is explicitly requested.

### D. Backend and integrations
- Unused API routes, middleware, controllers, services, and workers.
- Inconsistent request and response contracts.
- Missing validation, error handling, authentication, authorization, and rate limiting where appropriate.
- Unused environment variables, integrations, and external service clients.
- Unnecessary network calls and redundant processing.
- Missing health checks and unsafe handling of secrets.

Never expose credentials, tokens, or private environment values in reports.

### E. Database and persistence
- Unused tables, columns, indexes, relationships, and queries.
- Missing indexes or unnecessarily expensive queries.
- Schema drift, migration inconsistencies, and incorrect ORM relationships.
- Data integrity, access control, and backup concerns.
- Unused storage buckets and obsolete data access paths.

Database objects are not safe to delete merely because application source does not reference them. Consider external clients, analytics, integrations, historical records, rollback requirements, and production data.

Never delete production tables, columns, records, storage objects, or migrations without explicit approval and a verified recovery plan.

### F. Configuration and delivery
- Dead configuration and duplicated environment definitions.
- Broken scripts, CI workflows, scheduled tasks, and deployment settings.
- Missing environment documentation and inconsistent build commands.
- Incorrect build output directories, start commands, ports, and health checks.
- Unnecessary configuration that can be removed without changing behavior.

Treat documentation-only and generated files separately from executable code.

## Phase 4: Classify Findings

Every finding must include evidence and a confidence level.

Use these categories:

- CONFIRMED UNUSED: sufficient evidence supports removal.
- LIKELY REDUNDANT: strong evidence suggests duplication or unnecessary complexity.
- NEEDS INVESTIGATION: references or runtime behavior are unclear.
- REQUIRED: used by application behavior, tooling, integrations, or deployment.
- BROKEN: verified defect or failed requirement.
- IMPROVEMENT: optional maintainability, performance, accessibility, or security improvement.

For each finding, record:
- Severity and confidence.
- Relevant file paths and line numbers where possible.
- Evidence supporting the finding.
- User-facing or operational impact.
- Recommended action.
- Verification method.
- Risk of removal or modification.

Prioritize correctness, data safety, security, and deployment blockers before cosmetic cleanup.

Do not invent evidence or claim that code is unused without investigating its possible entry points.

## Phase 5: Plan Safe Changes

Before editing, create a concise change plan.

1. Separate low-risk cleanup from behavior-changing refactors.
2. Identify dependencies between proposed changes.
3. Select the smallest useful set of changes.
4. Define how each change will be verified.
5. Identify rollback options and files that must be preserved.
6. Group related changes into small, understandable steps.

Prefer existing project conventions and tools. Do not add a new framework, dependency, service, or abstraction unless its benefits justify the cost.

When appropriate, use a dedicated Git branch or worktree. Never switch branches in a way that loses user work.

Ask for approval before destructive operations, database changes, major architecture migrations, production modifications, or changes that materially affect user-facing behavior.

Routine, reversible source cleanup can proceed in CLEAN & REPAIR mode when the repository is safe to modify.

## Phase 6: Clean Incrementally

For each approved change:

1. Inspect the relevant code and its callers.
2. Make the smallest coherent modification.
3. Remove only the code, files, dependencies, or assets supported by sufficient evidence.
4. Update imports, references, manifests, tests, and documentation as necessary.
5. Run targeted checks immediately.
6. Inspect the diff for unintended changes.
7. Continue only when the result is understood.

Do not perform broad, speculative deletion.

Do not remove tests just because they fail after a refactor. Investigate whether the implementation or the test is wrong.

Do not suppress TypeScript errors, lint rules, failing assertions, or build errors simply to obtain a green check.

Do not rewrite the whole application to fix a localized problem.

## Phase 7: Repair Regressions

If a verification check fails after a change:

1. Capture the exact command, output, and failure.
2. Compare the failure with the baseline.
3. Determine whether it was introduced by the current change, exposed by it, or existed beforehand.
4. Trace the failure to its underlying cause.
5. Apply the smallest appropriate fix.
6. Rerun the failing check and related tests.
7. Recheck the original functionality and inspect the diff.

If the cause is uncertain, gather more evidence before editing.

If the fix requires an architectural change or destructive operation, explain the risk and obtain approval.

If a safe repair cannot be completed, preserve the work, explain what remains broken, and provide the next diagnostic steps.

Never claim a regression was fixed without verification.

## Phase 8: Final Verification

Run the available checks that are relevant to the modifications:

- Unit and integration tests.
- Type checking.
- Linting and formatting checks.
- Production build.
- Route and API checks.
- Database migration validation.
- Critical end-to-end user journeys.
- Security and environment configuration checks.
- Deployment-specific build and startup checks.

When possible, start the application and test actual behavior rather than relying solely on static inspection.

Compare results against the baseline.

Report each check as:
- PASS: command or test completed successfully.
- FAIL: check ran and failed.
- BLOCKED: check could not run because of an external limitation.
- NOT RUN: check was not attempted.

Do not describe an untested workflow as verified.

A clean build alone does not prove the application works correctly.

## Phase 9: Deployment Architecture Audit

Recommend an architecture based on the actual application.

Determine:

1. Is the application static, server-rendered, serverless, or a long-running service?
2. Can the frontend and backend remain together, or do they have distinct runtime requirements?
3. Does the backend need persistent processes, WebSockets, scheduled jobs, background workers, or substantial CPU/RAM?
4. Which database, cache, object storage, authentication, and third-party integrations are required?
5. Does the application require persistent filesystem access?
6. Are there regional latency, data residency, security, or operational constraints?
7. What are the expected traffic, storage, compute, and bandwidth requirements?
8. Which services can be eliminated by using existing platform capabilities?
9. What are the free-tier restrictions, inactivity behavior, and upgrade triggers?

Evaluate suitable categories of hosting:

- Static frontend hosting.
- Full-stack framework hosting.
- Serverless functions or edge functions.
- Container or application hosting.
- Managed relational databases.
- Object storage and file delivery.
- Scheduled jobs and background workers.
- Managed authentication and API services.

Consider providers such as Vercel, Cloudflare Pages and Workers, Render, Supabase, and other suitable alternatives. These are candidates, not mandatory choices.

Prefer the simplest architecture that satisfies the application's requirements. Do not split a working monolith into multiple services without a clear technical or economic benefit.

### Free-tier verification

If web access is available, check official provider documentation and pricing pages at the time of the audit.

For every recommended provider, verify:
- The relevant free plan exists and supports the required workload.
- Runtime, build, request, bandwidth, storage, and database limits.
- Sleep, pause, expiration, or inactivity policies.
- Persistent storage and backup availability.
- Required regions and connectivity.
- Custom-domain and SSL requirements.
- Any restrictions on commercial use.
- Whether exceeding a limit can generate charges or suspend service.

Never describe a service as permanently free or unlimited without authoritative evidence.

If live research is unavailable, label pricing and quotas as unverified.

### Architecture decision

Compare at least one simple architecture and one alternative when both are genuinely viable.

For example:
- Static frontend + managed database/API.
- Full-stack framework on one platform + managed database.
- Separate frontend, API, worker, and database when their runtime requirements justify it.

Recommend the fewest services that satisfy the workload.

Explain why each service belongs in the architecture, what it costs at the expected usage, and what constraints might require a different choice.

## Phase 10: Deployment Readiness

Before recommending production deployment, inspect:

- Production build and startup commands.
- Environment variable names and required secret configuration.
- API URLs, CORS, cookies, authentication redirects, and callback URLs.
- Database migrations and connection configuration.
- Health checks, logging, error handling, and graceful shutdown.
- Persistent file storage and upload handling.
- Scheduled jobs, workers, and external integrations.
- Security rules, access policies, and exposed endpoints.
- Domain, HTTPS, and routing configuration.
- Backup and recovery requirements.
- CI/CD and rollback strategy.

Never put private service-role keys, database passwords, or secret tokens into frontend bundles or public environment variables.

Do not deploy, create billable infrastructure, change production DNS, migrate production data, or trigger irreversible operations without explicit authorization.

A deployment plan is not a successful deployment. Report the distinction clearly.

## Phase 11: Final Report

Provide a concise but useful report containing:

### 1. Project health
- Detected stack and architecture.
- Baseline status.
- Major risks and blockers.

### 2. Cleanup results
- Files, dependencies, assets, and code removed or consolidated.
- Why each change was justified.
- Potentially unused items deliberately retained.
- Relevant changes to architecture or configuration.

### 3. Verification
- Commands actually executed.
- Passes, failures, and blocked checks.
- Regressions fixed.
- Pre-existing problems still present.
- Important workflows not verified.

### 4. Deployment recommendation
- Proposed architecture and service responsibilities.
- Alternatives considered and why they were rejected.
- Current verified free-tier limits.
- Expected cost at the stated usage assumptions.
- Required environment variables and configuration.
- Deployment steps, risks, and future upgrade triggers.

### 5. Remaining work
- Prioritized next actions.
- Approvals or credentials required from the user.
- Known limitations and unresolved uncertainty.

## Non-negotiable Rules

- Preserve existing user work and important application behavior.
- Inspect before editing; verify after editing.
- Prefer minimal, reversible changes.
- Never equate lack of a text-search result with proof of non-usage.
- Never destroy user data or production infrastructure without approval.
- Never hide failures by weakening checks.
- Never invent test results, deployment outcomes, or pricing claims.
- Never expose secrets in logs, reports, code, or client bundles.
- Never claim success unless the available evidence supports it.
- When a task is too risky or evidence is insufficient, stop and explain rather than guessing.

Success means a demonstrably healthier, simpler, safer, and more deployable project—not merely fewer files or a green build.

## Common Rationalizations the Agent Must Reject

Agents frequently attempt to shortcut steps. Recognize and reject these patterns:

| The agent says | The correct response |
|:---|:---|
| "The build passes, so the app works." | A passing build does not prove correct behavior. Run the actual tests and verify user-facing workflows. |
| "Nothing imports this file, so it is safe to delete." | Check dynamic imports, framework plugins, build-tool references, CLI scripts, and runtime configuration before concluding a file is unused. |
| "This is just a small cosmetic cleanup." | If the cleanup breaks a test or changes behavior, it is not cosmetic. Verify after every change. |
| "I already know what the problem is." | Establish the baseline first. Inspect the evidence. Do not skip Phase 2 because the fix seems obvious. |
| "I will add tests later." | If the change is worth making, it is worth verifying now. Do not defer verification. |
| "I need to rewrite this module to fix the bug." | Apply the smallest fix that addresses the root cause. A rewrite is a separate decision requiring its own justification. |
| "The user probably does not need this feature." | Do not remove features based on assumptions. If you are unsure whether something is intentional, ask. |
| "I will suppress this lint error to keep the build green." | Never hide a failure. Investigate the root cause. Suppressing an error is not fixing it. |
| "This dependency is unused because I cannot find an import statement." | Dependencies can be used by CLI tools, PostCSS plugins, Babel presets, framework internals, build scripts, and runtime loaders. Investigate all entry points. |
| "I checked and everything looks fine." | State exactly what you checked, what commands you ran, and what the output was. "Looks fine" is not a verification result. |
