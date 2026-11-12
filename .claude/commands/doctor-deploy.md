Read the project-doctor skill from skills/project-doctor/SKILL.md, then run Project Doctor using the DEPLOY PLAN operating mode.

Analyze the application architecture and produce a deployment recommendation:
1. Determine whether the app is static, server-rendered, serverless, or a long-running service.
2. Identify all required infrastructure: database, cache, storage, auth, workers, scheduled jobs.
3. Evaluate suitable hosting categories and specific providers.
4. Verify free-tier availability, quotas, limits, sleep policies, and upgrade triggers using current documentation.
5. Compare at least one simple architecture and one alternative.
6. Recommend the fewest services that satisfy the workload.
7. Run Pre-Launch Security Gate: verify zero exposed or hardcoded secrets, protected mutation routes, and database access controls.
8. Produce a deployment readiness checklist with required environment variables, build commands, and configuration.

