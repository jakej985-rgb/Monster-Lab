# Monster Lab — Repository Agent Guidance

## Project context
Monster Lab is a Flutter/Dart learning application for learners age 6+, focused on programming, electronics, robotics, curriculum, and related interactive learning. Preserve age-appropriate learning while maintaining technical accuracy. The repository also contains platform packaging, release automation, curriculum validation, hardware-related functionality, and supporting scripts.

## Working principles
- **Inspect before acting.** Read relevant source, tests, documentation, configuration, workflows, and existing agent instructions before proposing or changing behavior.
- **Protect user data and learner safety.** Prioritize privacy, safety boundaries, data integrity, predictable recovery, and safe hardware interactions.
- **Preserve existing architecture and conventions.** Prefer focused changes and established patterns over sweeping rewrites.
- **Evidence over assumptions.** Verify claims in code, tests, logs, CI, or documentation. Clearly distinguish confirmed defects from hypotheses.
- **Avoid duplicate work.** Check existing GitHub issues, pull requests, commits, and roadmap relationships before creating work.
- **No fabricated results.** Never claim a command, test, build, workflow, or audit was run unless its execution/result is available.
- **Keep factory/source truth intact.** Do not overwrite authoritative curriculum, schema, configuration, or baseline data without an explicit reason and validation plan.
- **Explain exclusions.** Generated, vendor, binary, or impractical-to-review assets may be excluded only with a clear reason and coverage note.

## Repository changes and GitHub actions
- Audit and planning are read-only by default.
- Do not edit source, commit, push, tag, publish releases, merge PRs, or create/update/close issues unless the user explicitly authorizes that action.
- If authorized, limit the scope to the requested changes and inspect for existing work first.
- For code changes, add or update tests and run the relevant available checks. Report checks that could not be run and why.
- For issue proposals, include evidence, impact, acceptance criteria, tests, dependencies, affected paths, and appropriate labels when available.

## Existing specialist agents
Specialist agent instructions live under `.agents/agents/<agent-name>/agent.md`. Consult and delegate to them when their domain is relevant:
- curriculum-guardian / curriculum-validator — lesson and curriculum quality
- flutter-validator — Flutter/Dart quality and validation
- workflow-auditor — GitHub Actions coverage and workflow risks
- toolchain-path / toolchain-report — local toolchain discovery and reporting
- repair-agent — repair-focused diagnosis
- release-changelog — release notes
- push-gatekeeper — push readiness and pre-push safety

## Scout
For broad repository audits or issue-roadmap reconciliation, use `.agents/agents/m3tal-scout/agent.md`. Scout must not replace focused specialists; it coordinates broad investigation and routes domain-specific work as appropriate.
