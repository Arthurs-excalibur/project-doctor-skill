# Project Doctor

**Your AI-built app works on your machine. Project Doctor checks if it's actually ready to ship — then helps you deploy it for free.**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Works with Claude Code](https://img.shields.io/badge/Claude%20Code-skill-orange)](skills/project-doctor/SKILL.md)
[![Works with Cursor](https://img.shields.io/badge/Cursor-rule-purple)](.cursor/rules/project-doctor.mdc)
[![Works with Antigravity](https://img.shields.io/badge/Antigravity-skill-green)](skills/project-doctor/SKILL.md)

---

## Install

**macOS / Linux:**
```bash
curl -fsSL https://raw.githubusercontent.com/Arthurs-excalibur/project-doctor-skill/main/install.sh | bash
```

**Windows (PowerShell):**
```powershell
irm https://raw.githubusercontent.com/Arthurs-excalibur/project-doctor-skill/main/install.ps1 | iex
```

Then use it:
```
/doctor          — full read-only audit
/doctor-fix      — clean, repair, verify
/doctor-deploy   — free-tier deployment plan
```

Or just ask your agent: *"Run Project Doctor on this project."*

---

## What it does

Project Doctor acts as a senior engineer, QA engineer, and deployment architect rolled into one. It runs in three modes:

**AUDIT** — Inspects the entire project without touching a file. Produces a prioritized, evidence-backed report covering dead code, broken dependencies, security gaps, missing tests, and deployment blockers.

**CLEAN & REPAIR** — Establishes a health baseline first, then makes conservative, incremental changes. Verifies every change. Repairs regressions it introduces. Reports exactly what passed, failed, or could not be verified.

**DEPLOY PLAN** — Analyzes your application's actual runtime requirements, researches current hosting options, verifies free-tier quotas and limits, and gives you a concrete deployment plan — not a generic one.

It does not rewrite working code. It does not delete things it cannot prove are unused. It does not suppress failures to get a green build. It does not invent pricing claims.

---

## Sample output

```
Project Doctor — Audit Report

Health Baseline
  Stack: Next.js 14, TypeScript, Tailwind CSS, Prisma
  Build: PASS | Type-check: PASS | Tests: 14 passed, 2 failing

Findings
  [BROKEN]           /api/checkout — missing auth guard on order lookup (line 42)
  [CONFIRMED UNUSED] src/utils/legacy-formatter.ts — 0 references across source & configs
  [LIKELY REDUNDANT] moment + date-fns both installed — same purpose, pick one
  [RETAINED]         prisma/seed.ts — kept, referenced dynamically by database tooling

Deployment Plan (verified $0/month)
  Frontend + API  Vercel Hobby — within 100GB bandwidth limit
  Database        Supabase Free — within 500MB limit
                  Warning: projects pause after 7 days of inactivity
  Next step: run /doctor-fix to remove legacy-formatter.ts and patch /api/checkout
```

---

## Who it's for

- Vibe coders who built with AI and want a second opinion before shipping.
- Solo developers without a teammate to review their code.
- Students and beginners turning experiments into real applications.
- Indie hackers who need a deployment plan that fits a $0 budget.
- Developers with existing projects that need cleanup or a path to production.

---

## Manual installation

### Claude Code CLI

**Global** (works across all your projects):
```bash
# macOS / Linux
git clone https://github.com/Arthurs-excalibur/project-doctor-skill.git ~/.claude/skills/project-doctor

# Windows
git clone https://github.com/Arthurs-excalibur/project-doctor-skill.git "$HOME\.claude\skills\project-doctor"
```

**Project-level** (run from inside your project root):
```bash
mkdir -p .claude/skills
git clone https://github.com/Arthurs-excalibur/project-doctor-skill.git .claude/skills/project-doctor
```

### Cursor

Copy `.cursor/rules/project-doctor.mdc` from this repo into your project's `.cursor/rules/` folder.
Then use `@project-doctor` in Cursor Chat.

The one-liner installer handles this automatically.

### Google Antigravity

```bash
# macOS / Linux — global
git clone https://github.com/Arthurs-excalibur/project-doctor-skill.git ~/.gemini/antigravity/skills/project-doctor

# Project-level
git clone https://github.com/Arthurs-excalibur/project-doctor-skill.git .gemini/skills/project-doctor
```

### Generic / Open Agent Skills standard

```bash
mkdir -p .agents/skills
cp -r skills/project-doctor .agents/skills/project-doctor
```

---

## Uninstall

```bash
# macOS / Linux
./install.sh --uninstall

# Windows
.\install.ps1 -Uninstall
```

---

## How it works

The skill runs in phases, regardless of mode:

1. **Establish context** — reads your README, AGENTS.md, package manifests, lockfiles, CI config, database schemas, and deployment files. Identifies your actual stack from evidence, not assumptions.
2. **Build a baseline** — runs your documented build, lint, type-check, and test commands. Records what passes, fails, or cannot run. Never runs destructive commands.
3. **Audit** — inspects source code, dependencies, assets, backend routes, database objects, and configuration. Classifies every finding with evidence and a confidence level.
4. **Plan changes** — separates low-risk cleanup from behavior-changing refactors. Gets approval before destructive or risky operations.
5. **Execute incrementally** — makes the smallest coherent change, runs checks, inspects the diff, then continues.
6. **Repair regressions** — if a check fails after a change, traces it to the root cause and fixes it before moving on.
7. **Final verification** — reruns all relevant checks and compares against the baseline.
8. **Deployment audit** — evaluates hosting options against your app's actual requirements, verifies free-tier limits, and produces a concrete plan.

---

## Repo structure

```
project-doctor/
├── skills/
│   └── project-doctor/
│       └── SKILL.md              # skill definition (Claude Code, Antigravity, open standard)
├── .claude/
│   └── commands/
│       ├── doctor.md             # /doctor slash command
│       ├── doctor-fix.md         # /doctor-fix slash command
│       └── doctor-deploy.md      # /doctor-deploy slash command
├── .cursor/
│   └── rules/
│       └── project-doctor.mdc    # Cursor rule
├── install.sh                    # one-liner installer (macOS / Linux)
├── install.ps1                   # one-liner installer (Windows)
├── .gitignore
└── LICENSE                       # MIT
```

---

**Project Doctor — Check it. Fix it. Ship it.**
