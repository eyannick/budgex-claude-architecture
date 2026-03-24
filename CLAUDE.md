# CLAUDE.md

## Purpose

This file is the local entrypoint for Claude Code in this repository.

It is **not** the main source of truth for the agent system.
Its role is to:
- orient the model to the correct documentation,
- explain the repository-specific workflow,
- define the local read order,
- point to the runtime controls and operational scripts.

All durable rules, architecture decisions, routing logic, execution profiles, memory governance, and specialist behavior must live in their dedicated files under `.claude/`.

---

## Core principle

Do not treat `CLAUDE.md` as a catch-all instruction file.

When a rule already exists in a dedicated source-of-truth file, use that file instead of duplicating or reinterpreting the rule here.

If two files appear to conflict, resolve the conflict using:

1. safety and runtime controls,
2. `source-of-truth-map.md`,
3. `agent-team-playbook.md`,
4. dedicated source file for the topic.

---

## Read order

At session start, use this reading order:

1. `.claude/source-of-truth-map.md`
2. `.claude/agent-team-playbook.md`
3. relevant `.claude/agents/*.md`
4. relevant `.claude/memory/*.md`
5. relevant `.claude/checklists/*.md`
6. relevant `.claude/references/*.md`

Do not load all files by default if they are not useful for the current task.
Prefer the minimum relevant context.

---

## Repository layout

Expected Claude system layout:

```text
.claude/
├── CLAUDE.md
├── source-of-truth-map.md
├── agent-team-playbook.md
├── settings.local.json
├── agents/
├── memory/
├── references/
├── checklists/
├── hooks/
└── ops/