#!/usr/bin/env python3
"""
pre_tool_use_guard.py — exemple de garde-fou dynamique pour Bash.
Lit l'event JSON sur stdin et bloque certaines commandes selon le contexte agent.
"""

import json
import sys

BLOCKED_PATTERNS = [
    "doctrine:schema:update --force",
    "rm -rf C:/Windows",
    "rm -rf C:/wamp64/www/projects",
]


def main():
    try:
        payload = json.load(sys.stdin)
    except Exception:
        raise SystemExit(0)

    tool_name = payload.get("tool_name", "")
    if tool_name != "Bash":
        raise SystemExit(0)

    command = payload.get("tool_input", {}).get("command", "")
    agent_type = payload.get("agent_type", "")

    for pattern in BLOCKED_PATTERNS:
        if pattern in command:
            print(f"Commande bloquée par guardrail: {pattern}", file=sys.stderr)
            raise SystemExit(2)

    if agent_type == "budgex-seo" and any(token in command for token in ["php bin/phpunit", "composer "]):
        print("Le stream SEO ne doit pas lancer d'outils backend lourds sans délégation dédiée.", file=sys.stderr)
        raise SystemExit(2)

    raise SystemExit(0)


if __name__ == "__main__":
    main()
